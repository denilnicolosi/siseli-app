import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:system_tray/system_tray.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:window_manager/window_manager.dart';
import '../l10n/app_localizations.dart';
import '../services/inverter_service.dart';
import '../services/demand_forecast_service.dart';
import '../services/weather_service.dart';
import '../services/log_service.dart';
import '../services/notification_service.dart';
import '../services/update_service.dart';
import '../services/secure_storage_service.dart';
import '../services/battery_tracker_service.dart';
import '../services/location_service.dart';
import '../models/inverter_data.dart';

class AppStateProvider extends ChangeNotifier {
  static const String _defaultAppVersionLabel = 'Version --';
  static const Duration realtimeRefreshInterval = Duration(minutes: 1);
  static const String _lastSnapshotKey = 'last_inverter_snapshot';
  static const String _skippedUpdateVersionKey = 'skipped_update_version';
  static const String _startInTrayKey = 'start_in_tray';
  // ponytail: fixed low-battery alert threshold (old HEMS reserve 20% + 5),
  // make it a setting if 25% is wrong for the battery bank.
  static const double lowBatteryNotifySoc = 25.0;
  final InverterService service = InverterService();
  final WeatherService weatherService = WeatherService();
  final DemandForecastService demandForecastService = DemandForecastService();
  final LocationService locationService = LocationService();
  final SystemTray systemTray = SystemTray();

  bool get _supportsDesktopIntegrations =>
      Platform.isWindows || Platform.isLinux || Platform.isMacOS;

  InverterData? data;
  bool isDataLoading = false;
  String statusMessage = '';

  Timer? _dataTimer;
  Timer? _weatherTimer;

  double batteryCapacityAh = 230.0;
  double pvTotalCapacityW = 3000.0;
  double inverterMaxPowerW = 5000.0;
  double acInputBreakerAmps = 20.0;
  double nominalGridVoltage = 230.0;
  double houseLoadReserveW = 600.0;
  bool autoHouseLoadReserveEnabled = false;
  DateTime? _lastAutoReservePersistAt;

  /// Battery installation date — used for the battery health (SOH) estimate.
  DateTime batteryInstallDate = DateTime(DateTime.now().year - 2, 1, 1);

  // Geo settings are editable by user; defaults are practical for Ukraine.
  double siteLatitude = 49.0;
  double siteLongitude = 31.0;
  String siteTimeZone = 'Europe/Kyiv';

  Map<String, double> hourlyForecast = {};
  Map<int, double> avgHourlyConsumptionStats = {};

  Map<String, double> historicalPvData = {};

  ThemeMode themeMode = ThemeMode.dark;
  String lang = 'it';

  bool isAutostartEnabled = false;
  bool isStartInTrayEnabled = false;
  String? savedEmail;
  String? userName;

  Map<String, dynamic>? userData;

  bool isAuthenticated = false;
  bool isCheckingAuth = true;

  bool isDeveloperMode = false;
  int _versionClickCount = 0;
  String _appVersionLabel = _defaultAppVersionLabel;

  bool _isSettingChanging = false;
  bool _isPollingInBackground = false;
  bool _timersStarted = false;
  int _consecutiveRealtimeNulls = 0;

  // --- Notification tracking ---
  bool _lowBatteryNotified = false;
  final NotificationService _notifService = NotificationService.instance;

  // --- Battery tracker (singleton) ---
  final BatteryTrackerService _batteryTracker = BatteryTrackerService.instance;

  // Anomaly detection: rolling samples per hour
  final Map<int, List<double>> _loadSamplesByHour = {};
  int _lastAnomalyNotifHour = -1;
  int _consecutiveDeviceNotFoundCount = 0;
  DateTime? _lastRealtimeNullLogAt;
  DateTime? _lastDeviceNotFoundLogAt;
  DateTime? _lastRecoveryAttemptAt;
  DateTime? _lastDeviceRecoveryAttemptAt;
  DateTime? _lastSuccessfulRealtimeAt;
  InverterData? _cachedSnapshotData;

  UpdateInfo? _updateInfo;
  bool _isCheckingForUpdates = false;
  DateTime? _lastUpdateCheckAt;
  String? _skippedUpdateVersion;

  bool get isSettingChanging => _isSettingChanging;
  bool get isConfigLoading => _isPollingInBackground;
  String get appVersionLabel => _appVersionLabel;
  bool get isInverterOffline => service.lastRealtimeOffline;
  DateTime? get lastSuccessfulRealtimeAt => _lastSuccessfulRealtimeAt;
  InverterData? get cachedSnapshotData => _cachedSnapshotData;
  UpdateInfo? get updateInfo => _updateInfo;
  bool get isCheckingForUpdates => _isCheckingForUpdates;
  DateTime? get lastUpdateCheckAt => _lastUpdateCheckAt;
  String? get skippedUpdateVersion => _skippedUpdateVersion;

  bool get hasPendingUpdate =>
      _updateInfo != null &&
      _updateInfo!.hasUpdate &&
      _updateInfo!.latestVersion != _skippedUpdateVersion;
  double get safeGridInputPowerW {
    final amps = acInputBreakerAmps.clamp(6.0, 80.0).toDouble();
    final volts = nominalGridVoltage.clamp(180.0, 260.0).toDouble();
    // Derating keeps continuous draw below the nominal breaker threshold.
    return (amps * volts * 0.9).clamp(0.0, 20000.0).toDouble();
  }

  double get recommendedBatteryChargePowerW {
    final availableForCharging = safeGridInputPowerW - houseLoadReserveW;
    final clampedByInverter =
        availableForCharging.clamp(0.0, inverterMaxPowerW).toDouble();
    return clampedByInverter;
  }

  double get recommendedBatteryChargeCurrentA =>
      (recommendedBatteryChargePowerW / 51.2).clamp(0.0, 400.0).toDouble();

  double estimateHouseLoadReserveW({DateTime? nowOverride}) {
    final now = nowOverride ?? DateTime.now();
    final hour = now.hour;
    final profileW =
        (avgHourlyConsumptionStats[hour] ?? 0.0).clamp(0.0, 15000.0).toDouble();
    final liveW = (data?.loadPower ?? 0.0).clamp(0.0, 15000.0).toDouble();

    if (profileW <= 0.0 && liveW <= 0.0) {
      return houseLoadReserveW.clamp(200.0, 8000.0).toDouble();
    }

    final baselineW = math.max(profileW, liveW);
    final withHeadroomW = (baselineW * 1.15) + 150.0;
    return withHeadroomW.clamp(200.0, 8000.0).toDouble();
  }

  Future<void> _maybeAutoTuneHouseReserve() async {
    if (!autoHouseLoadReserveEnabled) return;

    final suggested = estimateHouseLoadReserveW();
    final delta = (suggested - houseLoadReserveW).abs();
    if (delta < 80.0) return;

    // Smooth reserve updates to avoid reacting to short transient spikes.
    final smoothed = ((houseLoadReserveW * 0.7) + (suggested * 0.3))
        .clamp(200.0, 8000.0)
        .toDouble();
    final changedBy = (smoothed - houseLoadReserveW).abs();
    if (changedBy < 30.0) return;

    houseLoadReserveW = smoothed;

    final now = DateTime.now();
    final shouldPersist = _lastAutoReservePersistAt == null ||
        now.difference(_lastAutoReservePersistAt!) >=
            const Duration(minutes: 15) ||
        changedBy >= 250.0;
    if (shouldPersist) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('house_load_reserve_w', houseLoadReserveW);
      await prefs.setBool(
          'auto_house_load_reserve_enabled', autoHouseLoadReserveEnabled);
      _lastAutoReservePersistAt = now;
    }

    LogService.log(
      '⚡ auto reserve tuned: suggested=${suggested.toStringAsFixed(0)}W '
      'applied=${houseLoadReserveW.toStringAsFixed(0)}W delta=${changedBy.toStringAsFixed(0)}W',
    );
    notifyListeners();
  }

  int get batteryCycles => _batteryTracker.cycleCount;

  double get batteryHealthPercent =>
      _batteryTracker.estimatedSohPercent(installDate: batteryInstallDate);

  Future<AppLocalizations> _getL10n() async {
    return await AppLocalizations.delegate.load(Locale(lang));
  }

  Future<void> fetchProfile() async {
    if (service.userId == null) {
      LogService.log('⚠️ profile.fetch skipped: userId is null');
      return;
    }

    LogService.log('👤 profile.fetch start: userId=${service.userId}');

    final data = await service.getUserInfo();
    if (data.isNotEmpty) {
      userData = data;
      LogService.log(
          '✅ profile.fetch success: account=${data['account']}, uid=${data['uid']}');
      notifyListeners();
    } else {
      LogService.log('⚠️ profile.fetch empty response');
    }
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    isDeveloperMode = prefs.getBool('is_developer_mode') ?? false;

    final isDark = prefs.getBool('is_dark_theme') ?? true;
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    batteryCapacityAh = prefs.getDouble('battery_capacity_ah') ?? 230.0;
    pvTotalCapacityW = prefs.getDouble('pv_total_capacity_w') ?? 3000.0;
    inverterMaxPowerW = prefs.getDouble('inverter_max_power_w') ?? 5000.0;
    acInputBreakerAmps = prefs.getDouble('ac_input_breaker_amps') ?? 20.0;
    nominalGridVoltage = prefs.getDouble('nominal_grid_voltage') ?? 230.0;
    houseLoadReserveW = prefs.getDouble('house_load_reserve_w') ?? 600.0;
    autoHouseLoadReserveEnabled =
        prefs.getBool('auto_house_load_reserve_enabled') ?? false;
    siteLatitude = prefs.getDouble('site_latitude') ?? 49.0;
    siteLongitude = prefs.getDouble('site_longitude') ?? 31.0;
    siteTimeZone = prefs.getString('site_time_zone') ?? 'Europe/Kyiv';

    // Battery health
    final installMs = prefs.getInt('battery_install_date_ms');
    if (installMs != null) {
      batteryInstallDate = DateTime.fromMillisecondsSinceEpoch(installMs);
    }
    lang = prefs.getString('app_lang') ?? 'it';
    if (_supportsDesktopIntegrations) {
      isAutostartEnabled = await launchAtStartup.isEnabled();
    } else {
      isAutostartEnabled = false;
    }
    isStartInTrayEnabled = prefs.getBool(_startInTrayKey) ?? false;
    final l10n = await _getL10n();
    userName = prefs.getString('user_name') ?? l10n.userNameDefault;
    savedEmail = prefs.getString('saved_email');
    _skippedUpdateVersion = prefs.getString(_skippedUpdateVersionKey);

    // Load historical PV data
    final historicalDataStr = prefs.getString('historical_pv_data');
    if (historicalDataStr != null) {
      try {
        final decoded = json.decode(historicalDataStr) as Map<String, dynamic>;
        historicalPvData = decoded
            .map((key, value) => MapEntry(key, (value as num).toDouble()));
      } catch (e) {
        LogService.log('Error loading historical PV data: $e');
        historicalPvData = {};
      }
    }

    final consumptionProfileStr = prefs.getString('consumption_profile_ewma');
    if (consumptionProfileStr != null && consumptionProfileStr.isNotEmpty) {
      try {
        final decoded =
            json.decode(consumptionProfileStr) as Map<String, dynamic>;
        avgHourlyConsumptionStats = decoded.map(
          (k, v) => MapEntry(int.tryParse(k) ?? 0, (v as num).toDouble()),
        );
      } catch (e) {
        LogService.log('Error loading EWMA consumption profile: $e');
        avgHourlyConsumptionStats = demandForecastService.buildDefaultProfile();
      }
    }

    // Load last successful realtime snapshot (used when inverter is offline).
    final snapshotStr = prefs.getString(_lastSnapshotKey);
    if (snapshotStr != null && snapshotStr.isNotEmpty) {
      try {
        final decoded = json.decode(snapshotStr) as Map<String, dynamic>;
        _cachedSnapshotData = InverterData.fromCacheMap(decoded);
      } catch (e) {
        LogService.log('Error loading cached inverter snapshot: $e');
        _cachedSnapshotData = null;
      }
    }

    // Перевірка автологіну при старті
    var loggedIn = await autoLogin();
    isAuthenticated = loggedIn;
    isCheckingAuth = false;

    if (loggedIn) {
      startTimers();
      await fetchProfile();
    }

    await _loadAppVersion();
    await _updateWeatherForecast();
    // Load persisted battery tracker and SOC history
    await _batteryTracker.load();
    await _updateStatusMessage(true);
    // Fire-and-forget startup check for a non-intrusive update badge in Settings.
    // ignore: unawaited_futures
    checkForUpdates();
    notifyListeners();
  }

  Future<UpdateInfo> checkForUpdates({bool force = false}) async {
    if (_isCheckingForUpdates) {
      return _updateInfo ??
          const UpdateInfo(
            hasUpdate: false,
            currentVersion: '--',
            latestVersion: '--',
          );
    }

    _isCheckingForUpdates = true;
    notifyListeners();
    try {
      final info = await UpdateService.fetchUpdateInfo();
      _updateInfo = info;
      _lastUpdateCheckAt = DateTime.now();

      if (force && _skippedUpdateVersion == info.latestVersion) {
        _skippedUpdateVersion = null;
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_skippedUpdateVersionKey);
      }

      // Notify when a new update is found (only once per version)
      if (info.hasUpdate && info.latestVersion != _skippedUpdateVersion) {
        final alreadyNotified = _notifService.notifications.any(
          (n) =>
              n.type == AppNotificationType.updateAvailable &&
              n.body.contains(info.latestVersion),
        );
        if (!alreadyNotified) {
          await _notifService.show(
            type: AppNotificationType.updateAvailable,
            title: 'Update Available',
            body: 'Version ${info.latestVersion} is ready to install',
          );
        }
      }

      return info;
    } finally {
      _isCheckingForUpdates = false;
      notifyListeners();
    }
  }

  Future<void> skipLatestUpdate() async {
    final info = _updateInfo;
    if (info == null || !info.hasUpdate) return;
    _skippedUpdateVersion = info.latestVersion;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_skippedUpdateVersionKey, info.latestVersion);
    notifyListeners();
  }

  Future<void> clearSkippedUpdate() async {
    _skippedUpdateVersion = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_skippedUpdateVersionKey);
    notifyListeners();
  }

  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final version = packageInfo.version.trim();
      final build = packageInfo.buildNumber.trim();
      if (version.isNotEmpty && build.isNotEmpty) {
        _appVersionLabel = 'Version $version+$build';
      } else if (version.isNotEmpty) {
        _appVersionLabel = 'Version $version';
      } else {
        _appVersionLabel = _defaultAppVersionLabel;
      }
    } catch (e) {
      LogService.log('Failed to load app version: $e');
      _appVersionLabel = _defaultAppVersionLabel;
    }
  }

  Future<void> saveHardwareSettings(double battery, double pv, double inverter,
      {DateTime? installDate,
      double? breakerAmps,
      double? gridVoltage,
      double? loadReserveW,
      bool? autoReserveEnabled}) async {
    final prefs = await SharedPreferences.getInstance();
    batteryCapacityAh = battery;
    pvTotalCapacityW = pv;
    inverterMaxPowerW = inverter;
    if (breakerAmps != null) {
      acInputBreakerAmps = breakerAmps.clamp(6.0, 80.0).toDouble();
    }
    if (gridVoltage != null) {
      nominalGridVoltage = gridVoltage.clamp(180.0, 260.0).toDouble();
    }
    if (loadReserveW != null) {
      houseLoadReserveW = loadReserveW.clamp(0.0, 12000.0).toDouble();
    }
    if (autoReserveEnabled != null) {
      autoHouseLoadReserveEnabled = autoReserveEnabled;
    }
    await prefs.setDouble('battery_capacity_ah', battery);
    await prefs.setDouble('pv_total_capacity_w', pv);
    await prefs.setDouble('inverter_max_power_w', inverter);
    await prefs.setDouble('ac_input_breaker_amps', acInputBreakerAmps);
    await prefs.setDouble('nominal_grid_voltage', nominalGridVoltage);
    await prefs.setDouble('house_load_reserve_w', houseLoadReserveW);
    await prefs.setBool(
        'auto_house_load_reserve_enabled', autoHouseLoadReserveEnabled);
    if (installDate != null) {
      batteryInstallDate = installDate;
      await prefs.setInt(
          'battery_install_date_ms', installDate.millisecondsSinceEpoch);
    }
    notifyListeners();
    await _updateWeatherForecast();
  }

  Future<void> saveGeoSettings({
    required double latitude,
    required double longitude,
    required String timeZone,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    siteLatitude = latitude;
    siteLongitude = longitude;
    siteTimeZone = timeZone.trim().isEmpty ? 'UTC' : timeZone.trim();
    await prefs.setDouble('site_latitude', siteLatitude);
    await prefs.setDouble('site_longitude', siteLongitude);
    await prefs.setString('site_time_zone', siteTimeZone);
    LogService.log(
        '📍 geo settings updated: lat=${siteLatitude.toStringAsFixed(4)}, lon=${siteLongitude.toStringAsFixed(4)}, tz=$siteTimeZone');
    notifyListeners();
    await _updateWeatherForecast();
  }

  /// Detects the current device position and the timezone for it.
  ///
  /// The result is returned to the caller (the settings dialog) so the user
  /// can review/confirm it; nothing is persisted until [saveGeoSettings] is
  /// called on save. Throws [LocationException] on failure.
  Future<SiteLocation> detectSiteLocation() =>
      locationService.detectSiteLocation();

  /// Opens the OS app settings so the user can grant location permission.
  Future<bool> openLocationPermissionSettings() =>
      locationService.openAppSettings();

  /// Opens the OS location settings so the user can turn GPS on.
  Future<bool> openLocationSystemSettings() =>
      locationService.openLocationSettings();

  Future<void> _updateWeatherForecast() async {
    final dynamicForecastMap = await weatherService.fetchLocalForecast(
      lat: siteLatitude,
      lon: siteLongitude,
      pvCapacityW: pvTotalCapacityW,
      efficiency: 0.85,
      historicalPvData: historicalPvData,
    );
    hourlyForecast = dynamicForecastMap;
    notifyListeners();
  }

  // --- ОНОВЛЕННЯ СТАТИСТИКИ СІМ'Ї ---
  Future<void> _updateConsumptionStats() async {
    if (service.currentStationId == null) return;

    try {
      if (avgHourlyConsumptionStats.isEmpty) {
        avgHourlyConsumptionStats = demandForecastService.buildDefaultProfile();
      }
      notifyListeners();
    } catch (e) {
      LogService.log('Помилка завантаження статистики: $e');
    }
  }

  Future<void> _persistConsumptionProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = avgHourlyConsumptionStats.map(
      (k, v) => MapEntry(k.toString(), v),
    );
    await prefs.setString('consumption_profile_ewma', json.encode(encoded));
  }

  /// Off-grid: with the battery (nearly) full the MPPT throttles PV down to
  /// the load, so those samples say nothing about what the panels could make.
  static const double _pvCurtailmentSoc = 95.0;

  void _recordPvHistory(InverterData currentData) async {
    if (currentData.batterySoc >= _pvCurtailmentSoc) return;
    try {
      final now = DateTime.now();
      final timeKey =
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}T${now.hour.toString().padLeft(2, '0')}:00";

      historicalPvData[timeKey] = currentData.pvPower;

      // Limit historical data to last 14 days to prevent unlimited growth
      final cutoffDate = now.subtract(const Duration(days: 14));
      historicalPvData.removeWhere((key, value) {
        try {
          final date = DateTime.parse(key.replaceAll(' ', 'T'));
          return date.isBefore(cutoffDate);
        } catch (_) {
          return true; // Remove invalid keys
        }
      });

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'historical_pv_data', json.encode(historicalPvData));
    } catch (e, stack) {
      // БЕЗПЕКА: Правильна обробка помилок вместо fire-and-forget
      LogService.log('❌ Error recording PV history', error: e, stack: stack);
    }
  }

  void handleVersionClick() async {
    _versionClickCount++;
    if (_versionClickCount >= 7 && !isDeveloperMode) {
      isDeveloperMode = true;
      _versionClickCount = 0;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_developer_mode', true);
      notifyListeners();
    }
  }

  String get displayAccount => userData?['account'] ?? 'N/A';

  String get displayName => userData?['name'] ?? 'N/A';

  String get displayEmail => userData?['email'] ?? '';

  String get displayPhone => userData?['cellphone'] ?? '';

  void startTimers() {
    if (_timersStarted) return;
    _timersStarted = true;
    if (_supportsDesktopIntegrations) {
      // ignore: unawaited_futures
      _initTray();
    }
    fetchData();
    _dataTimer = Timer.periodic(realtimeRefreshInterval, (_) => fetchData());
    _weatherTimer = Timer.periodic(
        const Duration(hours: 1), (_) => _updateWeatherForecast());
  }

  void stopTimers() {
    if (!_timersStarted) return;
    _timersStarted = false;
    _dataTimer?.cancel();
    _weatherTimer?.cancel();
    if (_supportsDesktopIntegrations) {
      systemTray.destroy();
    }
  }

  Future<void> setLanguage(String newLang) async {
    lang = newLang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_lang', lang);
    await _updateStatusMessage(true);
    if (isAuthenticated && _supportsDesktopIntegrations) {
      await _updateTrayMenu();
    }
    notifyListeners();
  }

  Future<void> _updateStatusMessage(bool isSuccess) async {
    final l10n = await _getL10n();
    if (isSuccess) {
      final time = DateTime.now().toString().substring(11, 19);
      statusMessage = l10n.updatedAt(time);
    } else {
      statusMessage = l10n.updateFailed;
    }
  }

  Future<void> toggleTheme() async {
    themeMode = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_theme', themeMode == ThemeMode.dark);
    notifyListeners();
  }

  /// Detects low-battery and recovery events.
  Future<void> _checkBatterySoc(InverterData d) async {
    final soc = d.batterySoc;
    const threshold = lowBatteryNotifySoc;

    // Battery cycle tracking
    final cycleCompleted = _batteryTracker.trackSoc(soc);
    if (cycleCompleted) {
      final l10n = await _getL10n();
      final soh =
          _batteryTracker.estimatedSohPercent(installDate: batteryInstallDate);
      await _notifService.show(
        type: AppNotificationType.custom,
        title: l10n.notifCycleTitle,
        body: l10n.notifCycleBody(
          _batteryTracker.cycleCount.toString(),
          soh.toStringAsFixed(0),
        ),
        showOsToast: false, // informational only
      );
    }

    if (soc < threshold && !_lowBatteryNotified) {
      _lowBatteryNotified = true;
      final l10n = await _getL10n();
      await _notifService.show(
        type: AppNotificationType.lowBattery,
        title: l10n.notifLowBatteryTitle,
        body: l10n.notifLowBatteryBody(soc.toStringAsFixed(0)),
      );
    } else if (soc >= threshold + 10.0 && _lowBatteryNotified) {
      _lowBatteryNotified = false;
      final l10n = await _getL10n();
      await _notifService.show(
        type: AppNotificationType.batteryRecovered,
        title: l10n.notifBatteryRecoveredTitle,
        body: l10n.notifBatteryRecoveredBody(soc.toStringAsFixed(0)),
      );
    }
  }

  /// Detects abnormal load spikes vs hourly rolling average.
  Future<void> _checkLoadAnomaly(InverterData d) async {
    final loadW = d.loadPower;
    if (loadW < 200) return; // ignore very low load
    final hour = DateTime.now().hour;
    final samples = _loadSamplesByHour.putIfAbsent(hour, () => []);
    if (samples.length >= 14) samples.removeAt(0);

    if (samples.length >= 5) {
      final avg = samples.reduce((a, b) => a + b) / samples.length;
      if (avg > 150 &&
          loadW > avg * 2.5 &&
          loadW > 800 &&
          _lastAnomalyNotifHour != hour) {
        _lastAnomalyNotifHour = hour;
        final times = (loadW / avg).toStringAsFixed(1);
        final l10n = await _getL10n();
        await _notifService.show(
          type: AppNotificationType.custom,
          title: l10n.notifAnomalyTitle,
          body: l10n.notifAnomalyBody(loadW.toStringAsFixed(0), times),
          showOsToast: true,
        );
        LogService.log(
            '📊 Load anomaly: ${loadW.toStringAsFixed(0)}W vs avg ${avg.toStringAsFixed(0)}W ($times×)');
      }
    }
    samples.add(loadW);
  }

  Future<void> toggleAutostart(bool val) async {
    if (!_supportsDesktopIntegrations) {
      isAutostartEnabled = false;
      notifyListeners();
      return;
    }
    if (val) {
      await launchAtStartup.enable();
    } else {
      await launchAtStartup.disable();
    }
    isAutostartEnabled = await launchAtStartup.isEnabled();
    if (isAuthenticated) await _updateTrayMenu();
    notifyListeners();
  }

  Future<void> toggleStartInTray(bool val) async {
    if (!_supportsDesktopIntegrations) {
      isStartInTrayEnabled = false;
      notifyListeners();
      return;
    }
    isStartInTrayEnabled = val;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_startInTrayKey, val);
    if (isAuthenticated) await _updateTrayMenu();
    notifyListeners();
  }

  Future<void> updateProfile(String newName) async {
    userName = newName;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', newName);
    notifyListeners();
  }

  String get userId => service.userId ?? 'N/A';

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('saved_email');
    var pass = await SecureStorageService.getPassword();

    // Backward compatibility: previous builds stored password in SharedPreferences.
    if ((pass == null || pass.isEmpty)) {
      final legacyPass = prefs.getString('saved_pass');
      if (legacyPass != null && legacyPass.isNotEmpty) {
        try {
          await SecureStorageService.savePassword(legacyPass);
          await prefs.remove('saved_pass');
        } catch (e) {
          LogService.log('Failed to migrate legacy password to secure storage',
              error: e);
        }
        pass = legacyPass;
      }
    }

    if (email != null && email.isNotEmpty && pass != null && pass.isNotEmpty) {
      return service.login(email, pass);
    }
    return false;
  }

  Future<bool> login(String email, String pass) async {
    var success = await service.login(email, pass);
    if (success) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_email', email);
      await prefs.remove('saved_pass');
      try {
        await SecureStorageService.savePassword(pass);
      } catch (e) {
        LogService.log('Failed to persist password securely after login',
            error: e);
      }
      savedEmail = email;

      isAuthenticated = true;
      startTimers();
      await fetchProfile();
      notifyListeners();
    }
    return success;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_email');
    await prefs.remove('saved_pass');
    try {
      await SecureStorageService.deletePassword();
      await SecureStorageService.deleteToken();
    } catch (e) {
      LogService.log('Failed to clear secure session data during logout',
          error: e);
    }
    savedEmail = null;
    service.accessToken = null;
    service.userId = null;
    userData = null;
    data = null;
    _lastSuccessfulRealtimeAt = null;
    _cachedSnapshotData = null;
    await prefs.remove(_lastSnapshotKey);

    stopTimers();
    isAuthenticated = false;
    notifyListeners();
  }

  Future<void> _initTray() async {
    if (!_supportsDesktopIntegrations) return;
    await systemTray.initSystemTray(
      title: 'Inverter',
      iconPath:
          Platform.isWindows ? 'assets/app_icon.ico' : 'assets/app_icon.png',
    );
    systemTray.registerSystemTrayEventHandler((eventName) {
      if (eventName == kSystemTrayEventClick) {
        windowManager.show();
      } else if (eventName == kSystemTrayEventRightClick) {
        systemTray.popUpContextMenu();
      }
    });
  }

  Future<void> _updateTrayMenu() async {
    if (!_supportsDesktopIntegrations) return;
    final l10n = await _getL10n();
    final menu = Menu();
    await menu.buildFrom([
      MenuItemLabel(label: l10n.enableSolar, onClicked: (_) => setMode(2)),
      MenuItemLabel(label: l10n.enableGrid, onClicked: (_) => setMode(0)),
      MenuSeparator(),
      MenuItemCheckbox(
        label: l10n.startWithWindows,
        checked: isAutostartEnabled,
        onClicked: (item) async => await toggleAutostart(!isAutostartEnabled),
      ),
      MenuItemCheckbox(
        label: l10n.startInTray,
        checked: isStartInTrayEnabled,
        onClicked: (item) async =>
            await toggleStartInTray(!isStartInTrayEnabled),
      ),
      MenuSeparator(),
      MenuItemLabel(
          label: l10n.showApp,
          onClicked: (_) async {
            await windowManager.show();
            await windowManager.focus();
          }),
      MenuItemLabel(
          label: l10n.exit,
          onClicked: (_) async {
            stopTimers();
            await windowManager.destroy();
            exit(0);
          }),
    ]);
    await systemTray.setContextMenu(menu);
    await systemTray.setTitle(
        l10n.batteryLevel(data?.batterySoc.toStringAsFixed(0) ?? '--'));
  }

  Future<void> fetchData() async {
    if (isDataLoading) return;

    final hasDevice = await service.ensureDeviceSelected();
    if (!hasDevice) {
      final now = DateTime.now();
      _consecutiveDeviceNotFoundCount++;
      if (_lastDeviceNotFoundLogAt == null ||
          now.difference(_lastDeviceNotFoundLogAt!) >
              const Duration(minutes: 15)) {
        LogService.log(
            '⚠️ fetchData: пристрій не знайдено, deviceSn=${service.deviceSn}, count=$_consecutiveDeviceNotFoundCount');
        _lastDeviceNotFoundLogAt = now;
      }

      // Auto-recovery: after 3 consecutive failures try re-selecting device,
      // after 10 failures re-login entirely (token may have expired).
      final recoveryCooldown = _lastDeviceRecoveryAttemptAt == null ||
          now.difference(_lastDeviceRecoveryAttemptAt!) >
              const Duration(minutes: 10);
      if (recoveryCooldown) {
        if (_consecutiveDeviceNotFoundCount >= 10) {
          _lastDeviceRecoveryAttemptAt = now;
          LogService.log(
              '🔑 fetchData: device not found for $_consecutiveDeviceNotFoundCount cycles, attempting re-login…');
          final prefs = await SharedPreferences.getInstance();
          final email = prefs.getString('saved_email');
          final pass = await SecureStorageService.getPassword();
          if (email != null && pass != null) {
            final ok = await service.login(email, pass);
            LogService.log('🔑 re-login result=$ok');
          }
        } else if (_consecutiveDeviceNotFoundCount >= 3) {
          _lastDeviceRecoveryAttemptAt = now;
          service.deviceSn = null;
          service.currentStationId = null;
          service.invalidateConfigCache();
          final reselected = await service.ensureDeviceSelected();
          LogService.log(
              '🔁 fetchData: forced device reselection after $_consecutiveDeviceNotFoundCount failures → ${reselected ? "ok, sn=${service.deviceSn}" : "failed"}');
        }
      }

      await _updateStatusMessage(false);
      notifyListeners();
      return;
    }
    _consecutiveDeviceNotFoundCount = 0;

    isDataLoading = true;
    notifyListeners();

    final newData = await service.getRealTimeData();

    if (newData != null) {
      _consecutiveRealtimeNulls = 0;
      _lastSuccessfulRealtimeAt = DateTime.now();
      // Read configs only now: a background config poll may have finished
      // while the realtime request was in flight.
      final previousConfigs =
          data?.rawFields['fullConfigs'] ?? service.cachedFullConfigs;
      if (previousConfigs != null) {
        newData.rawFields['fullConfigs'] = previousConfigs;
      }
      data = newData;
      _cachedSnapshotData = newData;
      _recordPvHistory(newData);
      avgHourlyConsumptionStats = demandForecastService.updateEwmaProfile(
        avgHourlyConsumptionStats,
        timestamp: DateTime.now(),
        loadW: newData.loadPower,
      );
      await _persistConsumptionProfile();
      await _maybeAutoTuneHouseReserve();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          _lastSnapshotKey, json.encode(newData.toCacheMap()));
      await _updateStatusMessage(true);
      if (isAuthenticated && _supportsDesktopIntegrations) {
        await _updateTrayMenu();
      }

      // --- Low battery alert + cycle tracking ---
      await _checkBatterySoc(newData);

      // --- Consumption anomaly detection ---
      await _checkLoadAnomaly(newData);

      if (avgHourlyConsumptionStats.isEmpty &&
          service.currentStationId != null) {
        await _updateConsumptionStats();
      }
      await service.updateDailyEnergyStats(DateTime.now());
    } else {
      _consecutiveRealtimeNulls++;
      final now = DateTime.now();
      if (_lastRealtimeNullLogAt == null ||
          now.difference(_lastRealtimeNullLogAt!) >
              const Duration(seconds: 75)) {
        LogService.log(
            '⚠️ fetchData: getRealTimeData повернув null, deviceSn=${service.deviceSn}, nulls=$_consecutiveRealtimeNulls');
        _lastRealtimeNullLogAt = now;
      }

      // Recover from stale/mismatched device assignment after repeated null cycles.
      final recoveryCooldownPassed = _lastRecoveryAttemptAt == null ||
          now.difference(_lastRecoveryAttemptAt!) > const Duration(minutes: 5);
      if (_consecutiveRealtimeNulls >= 3 &&
          recoveryCooldownPassed &&
          !service.lastRealtimeOffline) {
        _lastRecoveryAttemptAt = now;
        service.deviceSn = null;
        service.currentStationId = null;
        service.invalidateConfigCache();
        final reselectionOk = await service.ensureDeviceSelected();
        LogService.log(
            '🔁 fetchData recovery: device reselection=${reselectionOk ? 'ok' : 'failed'}, newDeviceSn=${service.deviceSn}');
      } else if (service.lastRealtimeOffline &&
          _consecutiveRealtimeNulls >= 3) {
        statusMessage = 'Інвертор офлайн. Очікуємо відновлення зв\'язку...';
      }
      if (!service.lastRealtimeOffline) {
        await _updateStatusMessage(false);
      }
    }

    isDataLoading = false;
    notifyListeners();

    if (newData != null) {
      final hasConfigs = data?.rawFields['fullConfigs']
              is Map<String, dynamic> &&
          (data!.rawFields['fullConfigs'] as Map<String, dynamic>).isNotEmpty;
      if (hasConfigs) return;

      // Fire-and-forget — don't block the fetch cycle waiting for configs
      // ignore: unawaited_futures
      _fetchConfigsInBackground(newData);
    }
  }

  Future<void> _fetchConfigsInBackground(InverterData currentData) async {
    await Future.delayed(const Duration(seconds: 2));

    // Quick check — may return from cache or trigger the batch
    final initial = await service.getDeviceFullConfigs();
    if (initial != null) {
      LogService.log('⚙️ config keys: ${initial.keys.join(', ')}');
      data?.rawFields['fullConfigs'] = initial;
      notifyListeners();
      return;
    }

    // Batch was triggered but data not ready; poll in background
    if (_isPollingInBackground) return;
    _isPollingInBackground = true;
    notifyListeners();
    try {
      final polled = await service.pollForConfigsBackground();
      if (polled != null) {
        LogService.log('⚙️ config keys: ${polled.keys.join(', ')}');
        data?.rawFields['fullConfigs'] = polled;
      }
    } finally {
      _isPollingInBackground = false;
      notifyListeners();
    }
  }

  Future<void> changeInverterSetting(String key, String value) async {
    _isSettingChanging = true;
    notifyListeners();

    final success = await service.updateSetting(key, value);

    if (success) {
      // Update local cache (configAttributeStates format has {value, valueDisplay, ...})
      final fullConfigs = data?.rawFields['fullConfigs'];
      if (fullConfigs is Map<String, dynamic> && fullConfigs.containsKey(key)) {
        final entry = fullConfigs[key];
        if (entry is Map<String, dynamic>) {
          entry['value'] = num.tryParse(value) ?? value;
          entry['valueDisplay'] = value;
        } else {
          fullConfigs[key] = value;
        }
      }
      await Future.delayed(const Duration(seconds: 5));
    }

    _isSettingChanging = false;
    notifyListeners();

    Future.delayed(const Duration(seconds: 65), () => fetchData());
  }

  int? _readConfigIntValue(String key) {
    final fullConfigs = data?.rawFields['fullConfigs'];
    if (fullConfigs is! Map<String, dynamic>) return null;
    final raw = fullConfigs[key];
    if (raw is Map<String, dynamic>) {
      final value = raw['value'] ?? raw['valueDisplay'];
      if (value is num) return value.round();
      return int.tryParse(value?.toString() ?? '');
    }
    if (raw is num) return raw.round();
    return int.tryParse(raw?.toString() ?? '');
  }

  Future<bool> _writeConfigWithRetry(
    String key,
    String value, {
    int attempts = 2,
    Duration retryDelay = const Duration(seconds: 3),
  }) async {
    for (var attempt = 1; attempt <= attempts; attempt++) {
      final ok = await service.setConfigItem(key, value);
      if (ok) return true;
      if (attempt < attempts) {
        LogService.log(
          '⏳ safe current write retry: key=$key value=$value attempt=$attempt/$attempts',
        );
        await Future.delayed(retryDelay);
      }
    }
    return false;
  }

  Future<
      ({
        bool success,
        int targetA,
        int? readTotalA,
        int? readUtilityA,
      })> applySafeChargingCurrent(double suggestedCurrentA) async {
    final targetA = suggestedCurrentA.round().clamp(0, 200).toInt();
    if (targetA <= 0) {
      return (
        success: false,
        targetA: targetA,
        readTotalA: null,
        readUtilityA: null,
      );
    }

    _isSettingChanging = true;
    notifyListeners();
    try {
      LogService.log(
          '🔧 safe current apply start: target=${targetA}A deviceSn=${service.deviceSn ?? '-'} stationId=${service.currentStationId ?? '-'}');

      Future<({bool totalOk, bool utilityOk})> writePass() async {
        final totalOk = await _writeConfigWithRetry(
          'setMaxChargingCurrent',
          targetA.toString(),
        );
        final utilityOk = await _writeConfigWithRetry(
          'setUtilityMaxChargingCurrent',
          targetA.toString(),
        );
        return (totalOk: totalOk, utilityOk: utilityOk);
      }

      var pass = await writePass();

      // Give backend more time to propagate write commands before read-back check.
      await Future.delayed(const Duration(seconds: 8));
      await fetchData();
      await refreshDeviceConfigs();

      var readTotalA = _readConfigIntValue('setMaxChargingCurrent');
      var readUtilityA = _readConfigIntValue('setUtilityMaxChargingCurrent');
      var readMatches = readTotalA == targetA && readUtilityA == targetA;

      // If the backend accepted the command but readback is still stale,
      // perform one more write/verify pass before giving up.
      if (!readMatches) {
        LogService.log(
          '⏳ safe current readback mismatch: target=${targetA}A '
          'read=${readTotalA?.toString() ?? '--'}/${readUtilityA?.toString() ?? '--'}A '
          '→ retrying once more after refresh',
        );
        await Future.delayed(const Duration(seconds: 5));
        await fetchData();
        await refreshDeviceConfigs();
        pass = await writePass();

        await Future.delayed(const Duration(seconds: 10));
        await fetchData();
        await refreshDeviceConfigs();

        readTotalA = _readConfigIntValue('setMaxChargingCurrent');
        readUtilityA = _readConfigIntValue('setUtilityMaxChargingCurrent');
        readMatches = readTotalA == targetA && readUtilityA == targetA;
      }

      final success = pass.totalOk && pass.utilityOk && readMatches;

      if (!success) {
        LogService.logCritical(
          '❌ safe current not confirmed: target=${targetA}A '
          'read=${readTotalA?.toString() ?? '--'}/${readUtilityA?.toString() ?? '--'}A '
          'deviceSn=${service.deviceSn ?? '-'} stationId=${service.currentStationId ?? '-'}',
          category: 'CONTROL_WRITE',
        );
      } else {
        LogService.log(
            '✅ safe current confirmed: target=${targetA}A read=$readTotalA/${readUtilityA}A');
      }

      return (
        success: success,
        targetA: targetA,
        readTotalA: readTotalA,
        readUtilityA: readUtilityA,
      );
    } finally {
      _isSettingChanging = false;
      notifyListeners();
    }
  }

  /// Force re-fetch device configs (invalidates cooldown cache)
  Future<void> refreshDeviceConfigs() async {
    if (_isPollingInBackground) return; // already running
    service.invalidateConfigCache();
    if (data == null) return;
    await _fetchConfigsInBackground(data!);
  }

  Future<bool> changeSetting(String key, String value) async {
    final l10n = await _getL10n();
    final oldFields = data?.rawFields != null
        ? Map<String, dynamic>.from(data!.rawFields)
        : null;

    final localKey = key.replaceAll('Setting', '');
    if (data != null && data!.rawFields.containsKey(localKey)) {
      data!.rawFields[localKey]['value'] = value;
      notifyListeners();
    }

    var success = await service.setConfigItem(key, value);

    if (success) {
      statusMessage = l10n.updated;
      await fetchData();
      LogService.log(
          '✅ setting.write applied: key=$key value=$value deviceSn=${service.deviceSn ?? '-'}');
    } else {
      if (oldFields != null && data != null) {
        data!.rawFields = oldFields;
      }
      statusMessage = l10n.updateFailed;
      LogService.logCritical(
          '❌ setting.write failed: key=$key value=$value '
          'deviceSn=${service.deviceSn ?? '-'} stationId=${service.currentStationId ?? '-'} '
          '(likely API timeout/offline).',
          category: 'CONTROL_WRITE');
      notifyListeners();
    }

    return success;
  }

  Future<bool> setMode(int mode) async {
    return changeSetting('outputSourcePrioritySetting', mode.toString());
  }
}
