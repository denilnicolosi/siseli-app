// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Smart Inverter';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get lightTheme => 'Light theme';

  @override
  String get darkTheme => 'Dark theme';

  @override
  String get language => 'Language';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get data => 'Data';

  @override
  String get energyOverview => 'Energy Overview';

  @override
  String get production => 'Production';

  @override
  String get consumption => 'Consumption';

  @override
  String get day => 'Day';

  @override
  String get week => 'Week';

  @override
  String get month => 'Month';

  @override
  String get mon => 'Mon';

  @override
  String get tue => 'Tue';

  @override
  String get wed => 'Wed';

  @override
  String get thu => 'Thu';

  @override
  String get fri => 'Fri';

  @override
  String get sat => 'Sat';

  @override
  String get sun => 'Sun';

  @override
  String get battery => 'Battery';

  @override
  String get forecast => 'Forecast';

  @override
  String get account => 'Account';

  @override
  String get appSettings => 'Application Settings';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get userNameDefault => 'User';

  @override
  String userId(String id) {
    return 'ID: $id';
  }

  @override
  String get advancedSettings => 'Advanced Settings';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get startWithWindows => 'Start with Windows';

  @override
  String get startInTray => 'Start in tray';

  @override
  String get startInTraySubtitle =>
      'Starts minimized when a saved session exists';

  @override
  String get name => 'Name';

  @override
  String get notProvided => 'Not provided';

  @override
  String get unknownValue => 'Unknown';

  @override
  String get accountStatusLocal => 'Local profile only';

  @override
  String get accountStatusSynced => 'Cloud profile synced';

  @override
  String get cloudAccount => 'Cloud account';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get sessionId => 'Session ID';

  @override
  String get accountProfileHint =>
      'Profile data is used for account display and inverter cloud access.';

  @override
  String get logoutConfirmMessage =>
      'Are you sure you want to sign out from this device?';

  @override
  String get dangerZone => 'Danger zone';

  @override
  String get nameCannotBeEmpty => 'Name cannot be empty';

  @override
  String get copy => 'Copy';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get updatesTitle => 'Updates';

  @override
  String get updatesCheckingBackground => 'Checking updates in background...';

  @override
  String get updatesChecking => 'Checking for updates...';

  @override
  String get updatesSubtitleDefault => 'Check and install latest version';

  @override
  String updatesSubtitleAvailable(String version) {
    return 'New version $version is available';
  }

  @override
  String updatesSubtitleSkipped(String version) {
    return 'Version $version is skipped';
  }

  @override
  String updatesSubtitleUpToDate(String version) {
    return 'You are up to date ($version)';
  }

  @override
  String updatesLastChecked(String time) {
    return 'Last checked: $time';
  }

  @override
  String updatesSkippedBanner(String version) {
    return 'Version $version is currently skipped.';
  }

  @override
  String get updatesSkippedRestored => 'Skipped version restored.';

  @override
  String get updatesRestore => 'Restore';

  @override
  String updatesBannerAvailable(String version) {
    return 'New update $version is available';
  }

  @override
  String updatesCurrentVersion(String version) {
    return 'Current version: $version';
  }

  @override
  String get updatesView => 'View';

  @override
  String get updatesSkip => 'Skip';

  @override
  String updatesSkippedNow(String version) {
    return 'Version $version was skipped.';
  }

  @override
  String get updatesNoInstallerFound =>
      'No compatible installer was found in this release.';

  @override
  String get updatesDialogAvailableTitle => 'Update Available';

  @override
  String updatesDialogCurrent(String version) {
    return 'Current: $version';
  }

  @override
  String updatesDialogLatest(String version) {
    return 'Latest: $version';
  }

  @override
  String updatesDialogPublished(String time) {
    return 'Published: $time';
  }

  @override
  String updatesDialogPackage(String name) {
    return 'Package: $name';
  }

  @override
  String get updatesDialogSkipVersion => 'Skip this version';

  @override
  String get updatesDialogLater => 'Later';

  @override
  String get updatesDialogDownload => 'Download';

  @override
  String get updatesDialogDownloadingTitle => 'Downloading update';

  @override
  String get updatesDialogDownloadFailedTitle => 'Download failed';

  @override
  String get updatesDialogPreparing => 'Preparing download...';

  @override
  String get updatesDialogInstallTitle => 'Install Update';

  @override
  String updatesDialogInstallPrompt(String version) {
    return 'Update downloaded ($version). Install now? The app will close during installation.';
  }

  @override
  String get updatesDialogInstall => 'Install';

  @override
  String get updatesDialogInstallFailed =>
      'Installation failed. Please run installer manually.';

  @override
  String get updatesInstallPermissionNeeded =>
      'Allow \"Install unknown apps\" for Smart Inverter in the settings that just opened, then come back and tap Install.';

  @override
  String get updatesDialogDownloadFailed =>
      'Download failed. Check internet or release assets.';

  @override
  String get updatesDialogClose => 'Close';

  @override
  String get inverterSettings => 'Inverter settings';

  @override
  String get refreshSettings => 'Refresh settings';

  @override
  String get settingsLoadingTitle => 'Settings are loading…';

  @override
  String get waitingInverterResponse => 'Waiting for inverter response…';

  @override
  String get tapRefreshToLoad => 'Tap refresh to load settings';

  @override
  String get realtimeReadings => 'Realtime readings';

  @override
  String unitOfMeasure(String unit) {
    return 'Unit: $unit';
  }

  @override
  String get selectValue => 'Select value';

  @override
  String get newValue => 'New value';

  @override
  String get apply => 'Apply';

  @override
  String get debugLogs => 'Debug Logs';

  @override
  String get viewSystemLogs => 'View system logs';

  @override
  String get analyzeSystemLogs => 'Analyze app errors and API calls';

  @override
  String get stationParameters => 'Station parameters';

  @override
  String get stationParametersHint =>
      'These values help the intelligent algorithm calculate energy balance and weather-based forecasts more accurately.';

  @override
  String get batteryCapacityLabel => 'Battery capacity';

  @override
  String get inputBreakerLabel => 'Input breaker';

  @override
  String get gridVoltageLabel => 'Grid voltage';

  @override
  String get houseLoadReserveLabel => 'House reserve load';

  @override
  String get autoReserveLoadTitle => 'Auto reserve load';

  @override
  String get autoReserveLoadEnabledSubtitle =>
      'Reserve is updated automatically from live and historical load';

  @override
  String get autoReserveLoadDisabledSubtitle => 'Reserve is fixed manually';

  @override
  String get reserveModeAuto => 'Mode: AUTO';

  @override
  String get reserveModeManual => 'Mode: MANUAL';

  @override
  String get reserveModeAutoHint =>
      'AUTO: reserve updates from live load and hourly profile with smoothing and safety headroom.';

  @override
  String get reserveModeManualHint =>
      'MANUAL: reserve stays fixed to the value you set.';

  @override
  String get houseLoadReserveHint =>
      'Reserve power for additional home appliances to avoid breaker trips during charging.';

  @override
  String get autoEstimateReserveLoad => 'Auto estimate reserve load';

  @override
  String get chargePowerEstimateTitle => 'Safe charge speed estimate';

  @override
  String get chargePowerSafeLimitLabel => 'Battery charge power limit';

  @override
  String get chargeCurrentSafeLimitLabel => 'Battery charge current limit';

  @override
  String get chargeCurrentConservativeLabel => 'Conservative charge current';

  @override
  String get chargeInputCurrentEstimateLabel => 'Estimated AC input current';

  @override
  String get chargeBreakerRiskSafe => 'Breaker risk: low';

  @override
  String get chargeBreakerRiskElevated => 'Breaker risk: elevated';

  @override
  String get chargeBreakerRiskHigh => 'Breaker risk: high (trip likely)';

  @override
  String chargeBreakerRiskHint(String load) {
    return 'Analysis uses reserve/live/profile house load: $load W';
  }

  @override
  String get chargeTimeToFullLabel => 'Time to 100%';

  @override
  String get chargeTimeUnavailable => 'Not enough data';

  @override
  String get chargeEstimateNoRealtimeSoc =>
      'Realtime SOC is unavailable. Charge time will appear when live data is received.';

  @override
  String chargeEstimateBasedOnSoc(String soc) {
    return 'Estimate based on current SOC: $soc%';
  }

  @override
  String get panelPowerLabel => 'Panel power';

  @override
  String get inverterPowerLabel => 'Inverter power';

  @override
  String get locationPreset => 'Location preset';

  @override
  String get latitudeLabel => 'Latitude';

  @override
  String get longitudeLabel => 'Longitude';

  @override
  String get timeZoneLabel => 'Time zone';

  @override
  String get geoPresetKyiv => 'Kyiv, UA';

  @override
  String get geoPresetLviv => 'Lviv, UA';

  @override
  String get geoPresetOdesa => 'Odesa, UA';

  @override
  String get geoPresetDnipro => 'Dnipro, UA';

  @override
  String get geoPresetKharkiv => 'Kharkiv, UA';

  @override
  String get geoPresetWarsaw => 'Warsaw, PL';

  @override
  String get geoPresetBerlin => 'Berlin, DE';

  @override
  String get geoPresetCustom => 'Custom (manual)';

  @override
  String geoSummary(String latitude, String longitude, String timeZone) {
    return 'Geo: $latitude, $longitude ($timeZone)';
  }

  @override
  String get hardwareSettingsSaved => 'Hardware settings saved!';

  @override
  String hardwareSummary(String battery, String pv, String inverter) {
    return 'Battery: $battery Ah • PV: $pv W\nInverter: $inverter W';
  }

  @override
  String chargeLimitSummary(String breaker, String power, String current) {
    return 'Input C$breaker -> safe battery charge $power W (~$current A)';
  }

  @override
  String get clear => 'Clear';

  @override
  String get presetDisabled => 'Disabled';

  @override
  String get presetEnabled => 'Enabled';

  @override
  String get presetOutputUsb => 'USB - Grid priority';

  @override
  String get presetOutputSub => 'SUB - Solar first';

  @override
  String get presetOutputSbu => 'SBU - Solar/Battery priority';

  @override
  String get presetChargerCso => 'CSO - Solar first';

  @override
  String get presetChargerSnu => 'SNU - Solar + Utility';

  @override
  String get presetChargerOso => 'OSO - Solar only';

  @override
  String get presetChargerUtilityOnly => 'Utility only';

  @override
  String get presetFrequency50Hz => '50 Hz';

  @override
  String get presetFrequency60Hz => '60 Hz';

  @override
  String get presetAcInputAplWide => 'APL - Wide range';

  @override
  String get presetAcInputUpsNarrow => 'UPS - Narrow range';

  @override
  String get presetBatteryTypeAgm => 'AGM';

  @override
  String get presetBatteryTypeFlooded => 'Flooded';

  @override
  String get presetBatteryTypeUser => 'User-defined';

  @override
  String get presetBatteryTypeLib => 'LIB (Lithium)';

  @override
  String get presetBatteryTypeLife => 'LiFe';

  @override
  String get signInCloud => 'Sign in to Siseli Cloud';

  @override
  String get loginFailed => 'Login failed. Check credentials.';

  @override
  String get today => 'Today';

  @override
  String get forecastNextDays => 'Solar forecast for next days';

  @override
  String get forecastPeak => 'Peak';

  @override
  String get forecastUnavailable => 'Forecast data is temporarily unavailable';

  @override
  String get equipmentStatus => 'Equipment status';

  @override
  String get inverterLoad => 'Inverter load';

  @override
  String get refreshChart => 'Refresh chart';

  @override
  String get batterySignHint =>
      'Battery: \'+\' means charge, \'-\' means discharge.';

  @override
  String get chartNoDataTitle => 'No data yet';

  @override
  String get chartNoDataMessage => 'The chart should load in a moment.';

  @override
  String get lessThanMinute => '< 1 min';

  @override
  String minutesAgo(String count) {
    return '$count min ago';
  }

  @override
  String hoursAgo(String count) {
    return '$count hr ago';
  }

  @override
  String get solar => 'Solar';

  @override
  String get load => 'Load';

  @override
  String get connectionOnline => 'Online';

  @override
  String get connectionOffline => 'Offline';

  @override
  String get lastRealtimeUpdate => 'Last update';

  @override
  String updatedAt(String time) {
    return 'Updated at $time';
  }

  @override
  String get updateFailed => 'Update failed';

  @override
  String get retry => 'Retry';

  @override
  String get updated => 'Updated!';

  @override
  String get enableSolar => 'Enable SOLAR (SBU)';

  @override
  String get enableGrid => 'Enable GRID (USB)';

  @override
  String get showApp => 'Show App';

  @override
  String get exit => 'Exit';

  @override
  String batteryLevel(String level) {
    return 'Battery: $level%';
  }

  @override
  String get batteryInstallYearLabel => 'Battery installation year';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmpty => 'No notifications yet';

  @override
  String get notificationsClear => 'Clear all';

  @override
  String get notifLowBatteryTitle => 'Low Battery';

  @override
  String notifLowBatteryBody(String soc) {
    return 'Battery SOC is $soc% — approaching reserve threshold';
  }

  @override
  String get notifBatteryRecoveredTitle => 'Battery Charged';

  @override
  String notifBatteryRecoveredBody(String soc) {
    return 'Battery SOC recovered to $soc%';
  }

  @override
  String get notifAnomalyTitle => 'High Consumption Detected';

  @override
  String notifAnomalyBody(String load, String times) {
    return 'Load is $load W — $times× above normal for this hour';
  }

  @override
  String get notifCycleTitle => 'Battery Cycle Completed';

  @override
  String notifCycleBody(String count, String soh) {
    return 'Total cycles: $count. Estimated battery health: $soh%';
  }

  @override
  String get socHistoryNoData =>
      'Not enough data yet.\nData is collected every 5 minutes.';

  @override
  String get acInput => 'AC input';

  @override
  String get mainSource => 'Main source';

  @override
  String get chartFullscreen => 'Full screen';

  @override
  String get chartRotate => 'Rotate';

  @override
  String forecastBasis(String kwp) {
    return 'Estimate for $kwp kWp of panels from Open-Meteo solar radiation';
  }

  @override
  String get applySafeCurrent => 'Apply safe current';

  @override
  String safeCurrentApplied(String target, String read) {
    return 'Safe current applied: $target A (read: $read)';
  }

  @override
  String safeCurrentFailed(String target, String read) {
    return 'Safe current not confirmed. Target $target A, read: $read';
  }

  @override
  String get invSetOutputPriority => 'Output source priority';

  @override
  String get invSetOutputPriorityDesc =>
      'Which source powers the loads (program 01). USB: AC input first; solar and battery only when AC input is missing. SUB: solar charges the battery first, then feeds the loads; AC input covers the rest. SBU: solar first, then battery; AC input only when the battery falls to the back-to-AC point (program 12/43). Off-grid: use SBU.';

  @override
  String get invSetChargerPriority => 'Charger source priority';

  @override
  String get invSetChargerPriorityDesc =>
      'Which source charges the battery (program 16). CSO: solar first, AC input only when there is no sun. SNU: solar and AC input together. OSO: solar only, even when AC input is present. Without a generator on the AC input, only solar can charge.';

  @override
  String get invSetMaxChargeCurrent => 'Maximum charging current';

  @override
  String get invSetMaxChargeCurrentDesc =>
      'Total battery charging current, solar + AC input (program 02). It cannot be lower than the AC charging current (program 11). Stay within the battery maker\'s limit.';

  @override
  String get invSetAcChargeCurrent => 'Maximum AC charging current';

  @override
  String get invSetAcChargeCurrentDesc =>
      'Maximum current used to charge the battery from the AC input, grid or generator (program 11). Keep it low enough for the generator and the input breaker.';

  @override
  String get invSetAcInputRange => 'AC input voltage range';

  @override
  String get invSetAcInputRangeDesc =>
      'Accepted AC input voltage (program 03). APL (appliances): 90-280 V, wide range. UPS: 170-280 V, narrow range for sensitive loads. The wide range copes better with a generator whose voltage fluctuates.';

  @override
  String get invSetBatteryType => 'Battery type';

  @override
  String get invSetBatteryTypeDesc =>
      'Battery chemistry; it sets the charge voltages (program 05). AGM and Flooded: lead-acid presets. User-defined: you set bulk, float and cut-off voltages (programs 26, 27, 29). LIB/LiFe: lithium.';

  @override
  String get invSetOverloadRestart => 'Auto restart after overload';

  @override
  String get invSetOverloadRestartDesc =>
      'If enabled, the output turns back on by itself after an overload shutdown (program 06).';

  @override
  String get invSetOverTempRestart => 'Auto restart after over-temperature';

  @override
  String get invSetOverTempRestartDesc =>
      'If enabled, the output turns back on by itself after an over-temperature shutdown (program 07).';

  @override
  String get invSetOutputVoltage => 'Output voltage';

  @override
  String get invSetOutputVoltageDesc =>
      'AC voltage supplied to the loads (program 08). Europe: 230 V.';

  @override
  String get invSetOutputFrequency => 'Output frequency';

  @override
  String get invSetOutputFrequencyDesc =>
      'AC frequency supplied to the loads (program 09). Europe: 50 Hz.';

  @override
  String get invSetOverloadBypass => 'Bypass on overload';

  @override
  String get invSetOverloadBypassDesc =>
      'If enabled, on overload in battery mode the inverter moves the loads to the AC input (program 23). It only helps when a generator is connected.';

  @override
  String get invSetBuzzer => 'Buzzer alarm';

  @override
  String get invSetBuzzerDesc =>
      'Turns the inverter buzzer on or off for warnings and faults (program 18).';

  @override
  String get invSetSourceLossBeep => 'Beep when primary source is lost';

  @override
  String get invSetSourceLossBeepDesc =>
      'If enabled, the inverter beeps when the primary source chosen in program 01 is interrupted (program 22).';

  @override
  String get invSetReturnToDefaultScreen => 'Return to default screen';

  @override
  String get invSetReturnToDefaultScreenDesc =>
      'If enabled, the LCD goes back to the default screen about 1 minute after the last key press; otherwise it stays on the last screen (program 19).';

  @override
  String get invSetBacklight => 'LCD backlight';

  @override
  String get invSetBacklightDesc =>
      'Keeps the LCD backlight always on, or lets it switch off when idle (program 20).';

  @override
  String get invSetRecordFaults => 'Record fault codes';

  @override
  String get invSetRecordFaultsDesc =>
      'If enabled, the inverter stores fault codes in its history (program 25).';

  @override
  String get invSetEqualization => 'Battery equalization';

  @override
  String get invSetEqualizationDesc =>
      'Periodic controlled overcharge that balances lead-acid cells (program 33). Only for Flooded or User-defined batteries; keep it off for lithium.';

  @override
  String get invSetEqualizationNow => 'Start equalization now';

  @override
  String get invSetEqualizationNowDesc =>
      'Starts an equalization cycle right away (program 39). Works only if equalization (program 33) is enabled.';

  @override
  String get invSetBatteryPowerLimit => 'Battery power limiting';

  @override
  String get invSetBatteryPowerLimitDesc =>
      'Limits the power taken from the battery. Not described in the Easun manual: check the inverter documentation before changing it.';

  @override
  String get invSetSmartLoadCutOff => 'Smart load cut-off on battery voltage';

  @override
  String get invSetSmartLoadCutOffDesc =>
      'Disconnects the smart (secondary) load output based on battery voltage. Not described in the Easun manual: check the inverter documentation before changing it.';

  @override
  String get invSetRgbLight => 'RGB light';

  @override
  String get invSetRgbLightDesc =>
      'Turns the inverter RGB status light on or off.';

  @override
  String get rdDualOutputVoltageSwitch => 'Dual output';

  @override
  String get rdDualOutputVoltageSwitchDesc =>
      'Second AC output for non-essential loads; it is switched off when the battery drops to the turn-off voltage.';

  @override
  String get rdAcInputFrequency => 'AC input frequency';

  @override
  String get rdAcInputFrequencyDesc =>
      'Frequency on the AC input (grid or generator). 0 Hz means nothing is connected.';

  @override
  String get rdLedPatternLight1 => 'LED lights';

  @override
  String get rdLedPatternLight1Desc =>
      'State of the inverter status LED lights.';

  @override
  String get rdBatteryNumber => 'Battery system voltage';

  @override
  String get rdBatteryNumberDesc =>
      'Battery bank voltage class the inverter is built for.';

  @override
  String get rdAcInputVoltage => 'AC input voltage';

  @override
  String get rdAcInputVoltageDesc =>
      'Voltage on the AC input. 0 V means no grid or generator is connected.';

  @override
  String get rdWorkingStates => 'Working state';

  @override
  String get rdWorkingStatesDesc =>
      'Current inverter mode: Invert (loads from battery/solar), Line (loads from the AC input), Standby or Fault.';

  @override
  String get rdAcOutputActivePower => 'Output active power';

  @override
  String get rdAcOutputActivePowerDesc => 'Real power the loads are using now.';

  @override
  String get rdBatteryEqualizationMode => 'Battery equalization';

  @override
  String get rdBatteryEqualizationModeDesc =>
      'Whether periodic equalization is enabled (program 33). Lead-acid batteries only.';

  @override
  String get rdGridConnectedSwitch1 => 'Grid feed-in';

  @override
  String get rdGridConnectedSwitch1Desc =>
      'Whether the inverter may feed power into the grid. Off-grid: keep it off.';

  @override
  String get rdGenerationPower => 'Generation power';

  @override
  String get rdGenerationPowerDesc =>
      'Power the solar panels are producing now.';

  @override
  String get rdRatingOutputCurrent => 'Nominal output current';

  @override
  String get rdRatingOutputCurrentDesc =>
      'Maximum continuous AC output current of the inverter (rating plate value).';

  @override
  String get rdLowBatteryCutOffVoltage => 'Low battery cut-off voltage';

  @override
  String get rdLowBatteryCutOffVoltageDesc =>
      'Below this voltage the inverter turns the output off to protect the battery (program 29).';

  @override
  String get rdBatteryCapacity => 'Battery charge (SOC)';

  @override
  String get rdBatteryCapacityDesc =>
      'State of charge reported by the inverter.';

  @override
  String get rdStartBalancing => 'Start equalization now';

  @override
  String get rdStartBalancingDesc =>
      'Whether an immediate equalization cycle is requested (program 39).';

  @override
  String get rdBatteryDischargeCurrent => 'Battery discharge current';

  @override
  String get rdBatteryDischargeCurrentDesc =>
      'Current flowing out of the battery now.';

  @override
  String get rdGridConnectedCurrent => 'Grid feed-in current';

  @override
  String get rdGridConnectedCurrentDesc =>
      'Maximum current fed into the grid when feed-in is on. Not used off-grid.';

  @override
  String get rdRatedBatteryVoltage => 'Nominal battery voltage';

  @override
  String get rdRatedBatteryVoltageDesc => 'Rated voltage of the battery bank.';

  @override
  String get rdOutputApparentPower => 'Output apparent power';

  @override
  String get rdOutputApparentPowerDesc =>
      'Apparent power (VA) drawn by the loads, reactive part included: it is what the inverter has to supply.';

  @override
  String get rdDualOutputTurnOffVoltage => 'Dual output turn-off voltage';

  @override
  String get rdDualOutputTurnOffVoltageDesc =>
      'Battery voltage at which the second output is switched off.';

  @override
  String get rdMainCPUVersion1 => 'Main CPU firmware';

  @override
  String get rdMainCPUVersion1Desc =>
      'Firmware version of the inverter main processor.';

  @override
  String get rdChargerSourcePriority => 'Charger source priority';

  @override
  String get rdChargerSourcePriorityDesc =>
      'Current charger priority (program 16). CSO: solar first. SNU: solar + AC input. OSO: solar only.';

  @override
  String get rdComebackUtilityModeVolSBUPriorityStatus =>
      'Back-to-AC voltage (SBU)';

  @override
  String get rdComebackUtilityModeVolSBUPriorityStatusDesc =>
      'With SBU or solar first, below this battery voltage the loads move to the AC input (program 12). Without a generator it has no effect.';

  @override
  String get rdNominalAcVoltage => 'Nominal AC voltage';

  @override
  String get rdNominalAcVoltageDesc => 'Rated AC voltage of the inverter.';

  @override
  String get rdNominalAcCurrent => 'Nominal AC current';

  @override
  String get rdNominalAcCurrentDesc => 'Rated AC current of the inverter.';

  @override
  String get rdOutputRelayStatus => 'Output relay';

  @override
  String get rdOutputRelayStatusDesc => 'ON means the AC output is powered.';

  @override
  String get rdPhotovoltaicAccessFlag => 'PV connection';

  @override
  String get rdPhotovoltaicAccessFlagDesc =>
      'Whether the inverter detects the solar panels.';

  @override
  String get rdPvStatuss => 'PV status';

  @override
  String get rdPvStatussDesc =>
      'Working state of the solar input (MPPT charger).';

  @override
  String get rdRatedOutputFrequency => 'Nominal output frequency';

  @override
  String get rdRatedOutputFrequencyDesc =>
      'Output frequency set on the inverter (program 09).';

  @override
  String get rdRatedOutputVoltage => 'Nominal output voltage';

  @override
  String get rdRatedOutputVoltageDesc =>
      'Output voltage set on the inverter (program 08).';

  @override
  String get rdGridState => 'AC input state';

  @override
  String get rdGridStateDesc =>
      'Whether the AC input (grid or generator) is connected.';

  @override
  String get rdBatteryEqualizationInterval => 'Equalization interval';

  @override
  String get rdBatteryEqualizationIntervalDesc =>
      'Days between two equalization cycles (program 37).';

  @override
  String get rdLoadPercentage => 'Load percentage';

  @override
  String get rdLoadPercentageDesc =>
      'Output load as a share of the inverter rated power.';

  @override
  String get rdComebackBatteryModeVolSBUPriorityStatus =>
      'Back-to-battery voltage (SBU)';

  @override
  String get rdComebackBatteryModeVolSBUPriorityStatusDesc =>
      'With SBU or solar first, above this battery voltage the loads go back to the battery (program 13).';

  @override
  String get rdPvInputPower => 'PV input power';

  @override
  String get rdPvInputPowerDesc =>
      'Power entering from the solar panels into the MPPT charger.';

  @override
  String get rdMaxTotalChargeCurrent1 => 'Max total charge current';

  @override
  String get rdMaxTotalChargeCurrent1Desc =>
      'Total charging limit, solar + AC input (program 02).';

  @override
  String get rdBatState => 'Battery state';

  @override
  String get rdBatStateDesc =>
      'Whether the battery is charging, discharging or idle.';

  @override
  String get rdOutputSourcePriority => 'Output source priority';

  @override
  String get rdOutputSourcePriorityDesc =>
      'Current output priority (program 01). USB: AC input first. SUB: solar charges first, AC covers the rest. SBU: solar, then battery, then AC.';

  @override
  String get rdFloatChargingVoltage => 'Float charging voltage';

  @override
  String get rdFloatChargingVoltageDesc =>
      'Voltage held once the battery is full (program 27).';

  @override
  String get rdBatteryChargingCurrent => 'Battery charging current';

  @override
  String get rdBatteryChargingCurrentDesc =>
      'Current flowing into the battery now.';

  @override
  String get rdAcOutputRatingApparentPower => 'Nominal apparent power';

  @override
  String get rdAcOutputRatingApparentPowerDesc =>
      'Rated output power of the inverter in VA.';

  @override
  String get rdLoadStatus => 'Load status';

  @override
  String get rdLoadStatusDesc =>
      'Whether the output load is normal or overloaded.';

  @override
  String get rdBatteryEqualizationVoltage => 'Equalization voltage';

  @override
  String get rdBatteryEqualizationVoltageDesc =>
      'Charging voltage used during equalization (program 34).';

  @override
  String get rdBatteryVoltage => 'Battery voltage';

  @override
  String get rdBatteryVoltageDesc => 'Battery voltage measured now.';

  @override
  String get rdOutputVoltage => 'Output voltage';

  @override
  String get rdOutputVoltageDesc => 'AC voltage on the output now.';

  @override
  String get rdBulkChargingVoltage => 'Bulk charging voltage';

  @override
  String get rdBulkChargingVoltageDesc =>
      'Constant-voltage charging target (program 26).';

  @override
  String get rdBatteryEqualizationTimeout => 'Equalization timeout';

  @override
  String get rdBatteryEqualizationTimeoutDesc =>
      'Maximum extra time allowed for an equalization cycle (program 36).';

  @override
  String get rdFeedInPower => 'Feed-in power';

  @override
  String get rdFeedInPowerDesc =>
      'Power sent to the grid. Off-grid it stays at 0.';

  @override
  String get rdNtcMaximumTemperature => 'Max internal temperature';

  @override
  String get rdNtcMaximumTemperatureDesc =>
      'Highest temperature measured by the inverter internal sensors (NTC).';

  @override
  String get rdMainsRelayStatus => 'AC input relay';

  @override
  String get rdMainsRelayStatusDesc =>
      'ON means loads or charger are connected to the AC input.';

  @override
  String get rdBatteryRatingVoltage => 'Rated voltage';

  @override
  String get rdBatteryRatingVoltageDesc =>
      'Rated voltage reported by the inverter.';

  @override
  String get rdRatedActivePower => 'Nominal active power';

  @override
  String get rdRatedActivePowerDesc =>
      'Rated continuous output power of the inverter in W.';

  @override
  String get rdPvInputVoltage => 'PV input voltage';

  @override
  String get rdPvInputVoltageDesc =>
      'Voltage of the solar string; it must stay inside the MPPT voltage range.';

  @override
  String get rdMainsInputRange => 'AC input range';

  @override
  String get rdMainsInputRangeDesc =>
      'Accepted AC input voltage range (program 03). APL: 90-280 V. UPS: 170-280 V.';

  @override
  String get rdOutputFrequency => 'Output frequency';

  @override
  String get rdOutputFrequencyDesc => 'AC frequency measured on the output.';

  @override
  String get rdBatteryEqualizationTime => 'Equalization time';

  @override
  String get rdBatteryEqualizationTimeDesc =>
      'Duration of an equalization cycle (program 35).';

  @override
  String get rdBatteryType => 'Battery type';

  @override
  String get rdBatteryTypeDesc =>
      'Battery type set on the inverter (program 05).';

  @override
  String get rdMaxUtilityChargeCurrent1 => 'AC charging current';

  @override
  String get rdMaxUtilityChargeCurrent1Desc =>
      'Maximum current for charging from the AC input (program 11).';

  @override
  String get rdValOn => 'On';

  @override
  String get rdValOff => 'Off';

  @override
  String get rdValEnabled => 'Enabled';

  @override
  String get rdValDisabled => 'Disabled';

  @override
  String get rdValCharging => 'Charging';

  @override
  String get rdValDischarging => 'Discharging';

  @override
  String get rdValInvertMode => 'Inverter mode';

  @override
  String get rdValLineMode => 'Line mode';

  @override
  String get rdValStandbyMode => 'Standby';

  @override
  String get rdValFaultMode => 'Fault';

  @override
  String get rdValAcNotConnected => 'AC input not connected';

  @override
  String get rdValAcConnected => 'AC input connected';

  @override
  String get rdValNormal => 'Normal';

  @override
  String get rdValPvWorking => 'Connected and working';

  @override
  String get rdValPvConnected => 'Panels connected';

  @override
  String get invSetBackToAcVoltage => 'Back-to-AC voltage (SBU)';

  @override
  String get invSetBackToAcVoltageDesc =>
      'With SBU or solar first in program 01, below this battery voltage the loads move to the AC input (program 12). It must be lower than the back-to-battery voltage. Without a generator it has no effect.';

  @override
  String get invSetBackToBatteryVoltage => 'Back-to-battery voltage (SBU)';

  @override
  String get invSetBackToBatteryVoltageDesc =>
      'With SBU or solar first, once the battery is back above this voltage the loads return to battery power (program 13). It must be higher than the back-to-AC voltage.';

  @override
  String get invSetBulkVoltage => 'Bulk charging voltage (C.V.)';

  @override
  String get invSetBulkVoltageDesc =>
      'Constant-voltage charging target (program 26). Editable only with a User-defined battery; it must be at least the float voltage. Follow the battery maker\'s values.';

  @override
  String get invSetFloatVoltage => 'Float charging voltage';

  @override
  String get invSetFloatVoltageDesc =>
      'Voltage held once the battery is full (program 27). Editable only with a User-defined battery; it cannot exceed the bulk voltage.';

  @override
  String get invSetLowCutOffVoltage => 'Low DC cut-off voltage';

  @override
  String get invSetLowCutOffVoltageDesc =>
      'Below this battery voltage the inverter turns the output off to protect the battery (program 29). It must be lower than the back-to-AC voltage.';

  @override
  String get invSetLowCutOffSoc => 'Low DC cut-off SOC';

  @override
  String get invSetLowCutOffSocDesc =>
      'With a lithium battery that talks to the inverter: below this state of charge the output turns off (program 45, default 20%, range 3-30%).';

  @override
  String get invSetEqVoltage => 'Equalization voltage';

  @override
  String get invSetEqVoltageDesc =>
      'Charging voltage used during equalization (program 34). Lead-acid only.';

  @override
  String get invSetEqTime => 'Equalization time';

  @override
  String get invSetEqTimeDesc =>
      'How long the equalization voltage is held (program 35, 0-900 min).';

  @override
  String get invSetEqTimeout => 'Equalization timeout';

  @override
  String get invSetEqTimeoutDesc =>
      'Extra time allowed if the equalization voltage is not reached (program 36, 0-900 min).';

  @override
  String get invSetEqInterval => 'Equalization interval';

  @override
  String get invSetEqIntervalDesc =>
      'Days between two equalization cycles (program 37, 1-90 days).';

  @override
  String get invSetOutputDelay => 'Output delay';

  @override
  String get invSetOutputDelayDesc =>
      'Delay before the AC output turns on. Not described in the Easun manual: check the inverter documentation before changing it.';

  @override
  String get socDayChartTitle => 'Battery charge (SOC) during the day';

  @override
  String get flowLosses => 'Losses';

  @override
  String get flowLossesHint =>
      'Power coming in (solar, AC input, battery) that does not reach the loads or the battery: inverter self-consumption and conversion losses.';

  @override
  String get flowMismatch => 'Reading mismatch';

  @override
  String get flowMismatchHint =>
      'More power goes out than the readings show coming in: the values were sampled at slightly different moments.';
}
