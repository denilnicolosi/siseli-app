import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:geolocator/geolocator.dart';

import 'log_service.dart';

/// Where the site timezone stored next to a position fix came from.
enum TimeZoneSource {
  /// Resolved through Open-Meteo with `timezone=auto`, i.e. the same timezone
  /// the solar forecast uses for those coordinates.
  weatherService,

  /// Fallback to the device/OS timezone when the online lookup failed.
  device,
}

/// A WGS84 position fix plus the matching site timezone.
class SiteLocation {
  const SiteLocation({
    required this.latitude,
    required this.longitude,
    required this.timeZone,
    required this.timeZoneSource,
    this.accuracyMeters,
  });

  final double latitude;
  final double longitude;
  final String timeZone;
  final TimeZoneSource timeZoneSource;
  final double? accuracyMeters;
}

/// Why a site location could not be detected.
enum LocationFailure {
  /// GPS / system location services are turned off.
  serviceDisabled,

  /// The user (or the OS) denied the runtime location permission.
  permissionDenied,

  /// The permission is blocked permanently and can only be changed in the
  /// system app settings.
  permissionDeniedForever,

  /// No GPS fix was received before the timeout.
  timeout,

  /// Any other platform error (sensor unavailable, plugin error, ...).
  unavailable,
}

class LocationException implements Exception {
  const LocationException(this.failure, {this.cause});

  final LocationFailure failure;
  final Object? cause;

  @override
  String toString() =>
      'LocationException(${failure.name}${cause == null ? '' : ', $cause'})';
}

/// Permission state, decoupled from the geolocator enum so the detection flow
/// can be unit-tested without platform channels.
enum GeoPermission { granted, denied, deniedForever }

/// A raw position fix in WGS84 degrees.
class GeoFix {
  const GeoFix({
    required this.latitude,
    required this.longitude,
    this.accuracyMeters,
  });

  final double latitude;
  final double longitude;
  final double? accuracyMeters;
}

/// Thin abstraction over the geolocator plugin (faked in unit tests).
abstract class GeoPlatform {
  Future<bool> isLocationServiceEnabled();

  Future<GeoPermission> checkPermission();

  Future<GeoPermission> requestPermission();

  Future<GeoFix> currentFix();

  /// Opens the app settings page so the user can grant location access.
  Future<bool> openAppSettings();

  /// Opens the system location settings so the user can enable GPS.
  Future<bool> openLocationSettings();
}

/// Real implementation backed by the `geolocator` plugin.
///
/// Named `PluginGeoPlatform` (instead of `GeolocatorPlatform`) to avoid
/// shadowing the platform-interface class exported by `package:geolocator`.
class PluginGeoPlatform implements GeoPlatform {
  const PluginGeoPlatform();

  // High accuracy = GPS: an off-grid site often has no Wi-Fi and weak cell
  // coverage, so network-based (approximate) positioning may never answer.
  static const LocationSettings _fixSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    timeLimit: Duration(seconds: 15),
  );

  /// Oldest cached position accepted when a fresh fix fails. Older ones may
  /// come from another place (home vs. the plant) and must not be saved
  /// silently as the site location.
  static const Duration maxLastKnownAge = Duration(minutes: 10);

  /// Whether a cached position taken at [timestamp] is recent enough.
  static bool isFreshEnough(DateTime timestamp, {DateTime? now}) {
    final age = (now ?? DateTime.now()).difference(timestamp);
    return !age.isNegative && age <= maxLastKnownAge;
  }

  @override
  Future<bool> isLocationServiceEnabled() =>
      Geolocator.isLocationServiceEnabled();

  @override
  Future<GeoPermission> checkPermission() async =>
      _mapPermission(await Geolocator.checkPermission());

  @override
  Future<GeoPermission> requestPermission() async =>
      _mapPermission(await Geolocator.requestPermission());

  @override
  Future<GeoFix> currentFix() async {
    try {
      final position =
          await Geolocator.getCurrentPosition(locationSettings: _fixSettings);
      return GeoFix(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracyMeters: position.accuracy,
      );
    } catch (error) {
      // Fallback to the last known position if acquiring a fresh fix times out
      // or fails (e.g. indoors, weak GPS lock, stationary throttling).
      try {
        final last = await Geolocator.getLastKnownPosition();
        if (last != null && !isFreshEnough(last.timestamp)) {
          LogService.log('📍 fresh fix failed; last known position ignored '
              '(taken ${last.timestamp.toLocal()}, older than '
              '${maxLastKnownAge.inMinutes} min)');
        } else if (last != null) {
          LogService.log('📍 fresh fix failed, using last known position: '
              'lat=${last.latitude.toStringAsFixed(4)}, '
              'lon=${last.longitude.toStringAsFixed(4)}');
          return GeoFix(
            latitude: last.latitude,
            longitude: last.longitude,
            accuracyMeters: last.accuracy,
          );
        }
      } catch (_) {
        // If last known position lookup also fails, rethrow the original error.
      }
      rethrow;
    }
  }

  @override
  Future<bool> openAppSettings() => Geolocator.openAppSettings();

  @override
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  static GeoPermission _mapPermission(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return GeoPermission.granted;
      case LocationPermission.deniedForever:
        return GeoPermission.deniedForever;
      case LocationPermission.denied:
      case LocationPermission.unableToDetermine:
        return GeoPermission.denied;
    }
  }
}

/// Result of [TimeZoneResolver.resolve].
class ResolvedTimeZone {
  const ResolvedTimeZone(this.identifier, this.source);

  final String identifier;
  final TimeZoneSource source;
}

typedef OpenMeteoTimeZoneLookup = Future<String?> Function(
    double latitude, double longitude);
typedef DeviceTimeZoneLookup = Future<String?> Function();

/// Resolves the IANA timezone name for a pair of coordinates.
///
/// The primary source is Open-Meteo (`timezone=auto`) because it is the same
/// data source the solar forecast uses, so the stored timezone always matches
/// the weather data. When the lookup fails (offline, API error) the device
/// timezone is used as a pragmatic fallback.
class TimeZoneResolver {
  TimeZoneResolver({
    OpenMeteoTimeZoneLookup? openMeteoLookup,
    DeviceTimeZoneLookup? deviceTimeZoneLookup,
  })  : _openMeteoLookup = openMeteoLookup ?? _fetchFromOpenMeteo,
        _deviceTimeZoneLookup = deviceTimeZoneLookup ?? _fetchDeviceTimeZone;

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 6),
      receiveTimeout: const Duration(seconds: 6),
      sendTimeout: const Duration(seconds: 6),
    ),
  );

  static const String _openMeteoUrl = 'https://api.open-meteo.com/v1/forecast';

  final OpenMeteoTimeZoneLookup _openMeteoLookup;
  final DeviceTimeZoneLookup _deviceTimeZoneLookup;

  Future<ResolvedTimeZone> resolve(double latitude, double longitude) async {
    final fromWeather = await _openMeteoLookup(latitude, longitude);
    if (_isPlausibleTimeZone(fromWeather)) {
      return ResolvedTimeZone(
          fromWeather!.trim(), TimeZoneSource.weatherService);
    }
    final fromDevice = await _deviceTimeZoneLookup();
    if (_isPlausibleTimeZone(fromDevice)) {
      return ResolvedTimeZone(fromDevice!.trim(), TimeZoneSource.device);
    }
    return const ResolvedTimeZone('UTC', TimeZoneSource.device);
  }

  static bool _isPlausibleTimeZone(String? value) {
    if (value == null) return false;
    final trimmed = value.trim();
    if (trimmed.isEmpty || trimmed.length > 64) return false;
    // flutter_timezone returns sentinels such as "Etc/Unknown" when the OS
    // timezone cannot be mapped: never store those as the site timezone.
    final lower = trimmed.toLowerCase();
    return !lower.contains('unknown');
  }

  /// Queries Open-Meteo only for the `timezone` metadata of the coordinates.
  static Future<String?> _fetchFromOpenMeteo(
      double latitude, double longitude) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        _openMeteoUrl,
        queryParameters: <String, dynamic>{
          'latitude': latitude,
          'longitude': longitude,
          'timezone': 'auto',
          'forecast_days': 1,
          'current': 'temperature_2m',
        },
      );
      final data = response.data;
      final timeZone = data?['timezone'];
      if (timeZone is String && _isPlausibleTimeZone(timeZone)) {
        return timeZone;
      }
      LogService.log('📍 timezone lookup: Open-Meteo returned no timezone for '
          'lat=${latitude.toStringAsFixed(4)}, lon=${longitude.toStringAsFixed(4)}');
    } catch (error, stack) {
      LogService.log('⚠️ timezone lookup failed, falling back to device zone',
          error: error, stack: stack);
    }
    return null;
  }

  static Future<String?> _fetchDeviceTimeZone() async {
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      return info.identifier;
    } catch (error, stack) {
      LogService.log('⚠️ device timezone lookup failed',
          error: error, stack: stack);
      return null;
    }
  }
}

/// Detects the current position and resolves the timezone for it.
///
/// The result is not persisted here: the caller decides when to save the site
/// geo settings (the settings dialog saves them together with the other
/// station parameters).
class LocationService {
  LocationService({
    GeoPlatform? platform,
    TimeZoneResolver? timeZoneResolver,
  })  : _platform = platform ?? const PluginGeoPlatform(),
        _timeZoneResolver = timeZoneResolver ?? TimeZoneResolver();

  final GeoPlatform _platform;
  final TimeZoneResolver _timeZoneResolver;

  /// Upper bound for the whole fix acquisition. `LocationSettings.timeLimit`
  /// is enforced by the Android/iOS plugins, but not by every platform
  /// implementation (e.g. Windows), so the future is also timed out here.
  static const Duration _fixTimeout = Duration(seconds: 25);

  /// Runs the permission flow, acquires a position fix and resolves the
  /// timezone. Throws [LocationException] with a user-actionable reason.
  Future<SiteLocation> detectSiteLocation() async {
    try {
      return await _detectSiteLocation();
    } on LocationException {
      rethrow;
    } on PlatformException catch (error, stack) {
      LogService.log('📍 location detection: platform error',
          error: error, stack: stack);
      final failure = switch (error.code) {
        'PERMISSION_DENIED' => LocationFailure.permissionDenied,
        'PERMISSION_DENIED_FOREVER' => LocationFailure.permissionDeniedForever,
        'LOCATION_SERVICES_DISABLED' => LocationFailure.serviceDisabled,
        'TIMEOUT' => LocationFailure.timeout,
        _ => LocationFailure.unavailable,
      };
      throw LocationException(failure, cause: error);
    } catch (error, stack) {
      LogService.log('📍 location detection: unexpected error',
          error: error, stack: stack);
      throw LocationException(LocationFailure.unavailable, cause: error);
    }
  }

  Future<SiteLocation> _detectSiteLocation() async {
    final serviceEnabled = await _platform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      LogService.log('📍 location detection: location services disabled');
      throw const LocationException(LocationFailure.serviceDisabled);
    }

    var permission = await _platform.checkPermission();
    if (permission == GeoPermission.denied) {
      permission = await _platform.requestPermission();
    }
    if (permission == GeoPermission.deniedForever) {
      LogService.log('📍 location detection: permission denied forever');
      throw const LocationException(LocationFailure.permissionDeniedForever);
    }
    if (permission != GeoPermission.granted) {
      LogService.log('📍 location detection: permission denied');
      throw const LocationException(LocationFailure.permissionDenied);
    }

    GeoFix fix;
    try {
      fix = await _platform.currentFix().timeout(_fixTimeout);
    } on TimeoutException catch (error) {
      LogService.log('📍 location detection: GPS timeout', error: error);
      throw LocationException(LocationFailure.timeout, cause: error);
    } catch (error, stack) {
      LogService.log('📍 location detection: platform error',
          error: error, stack: stack);
      throw LocationException(LocationFailure.unavailable, cause: error);
    }

    if (!_isValidCoordinate(fix.latitude, fix.longitude)) {
      LogService.log(
          '📍 location detection: platform returned invalid coordinates');
      throw const LocationException(LocationFailure.unavailable);
    }

    final resolved =
        await _timeZoneResolver.resolve(fix.latitude, fix.longitude);
    LogService.log(
        '📍 position detected: lat=${fix.latitude.toStringAsFixed(4)}, '
        'lon=${fix.longitude.toStringAsFixed(4)}, '
        'accuracy=${fix.accuracyMeters?.toStringAsFixed(0) ?? '?'} m, '
        'tz=${resolved.identifier} (${resolved.source.name})');

    return SiteLocation(
      latitude: fix.latitude,
      longitude: fix.longitude,
      timeZone: resolved.identifier,
      timeZoneSource: resolved.source,
      accuracyMeters: fix.accuracyMeters,
    );
  }

  static bool _isValidCoordinate(double latitude, double longitude) {
    if (!latitude.isFinite || !longitude.isFinite) return false;
    return latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }

  /// Opens the system app settings so the user can allow location access.
  Future<bool> openAppSettings() => _platform.openAppSettings();

  /// Opens the system location settings so the user can turn GPS on.
  Future<bool> openLocationSettings() => _platform.openLocationSettings();
}
