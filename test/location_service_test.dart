import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inverter_app/services/location_service.dart';

/// In-memory stand-in for the geolocator plugin so the detection flow can be
/// tested on the host machine without platform channels.
class _FakeGeoPlatform implements GeoPlatform {
  _FakeGeoPlatform({
    this.serviceEnabled = true,
    this.permission = GeoPermission.granted,
    this.requestResult,
    this.fix = const GeoFix(latitude: 41.9028, longitude: 12.4964),
    this.fixError,
    this.checkPermissionError,
  });

  bool serviceEnabled;
  GeoPermission permission;
  GeoPermission? requestResult;
  GeoFix fix;
  Object? fixError;
  Object? checkPermissionError;

  int requestCalls = 0;
  int fixCalls = 0;
  bool openedAppSettings = false;
  bool openedLocationSettings = false;

  @override
  Future<bool> isLocationServiceEnabled() async => serviceEnabled;

  @override
  Future<GeoPermission> checkPermission() async {
    final error = checkPermissionError;
    if (error != null) throw error;
    return permission;
  }

  @override
  Future<GeoPermission> requestPermission() async {
    requestCalls++;
    permission = requestResult ?? permission;
    return permission;
  }

  @override
  Future<GeoFix> currentFix() async {
    fixCalls++;
    final error = fixError;
    if (error != null) throw error;
    return fix;
  }

  @override
  Future<bool> openAppSettings() async {
    openedAppSettings = true;
    return true;
  }

  @override
  Future<bool> openLocationSettings() async {
    openedLocationSettings = true;
    return true;
  }
}

TimeZoneResolver _resolver({
  String? weatherTimeZone,
  String? deviceTimeZone,
  void Function()? onDeviceLookup,
}) {
  return TimeZoneResolver(
    openMeteoLookup: (latitude, longitude) async => weatherTimeZone,
    deviceTimeZoneLookup: () async {
      onDeviceLookup?.call();
      return deviceTimeZone;
    },
  );
}

void main() {
  group('LocationService', () {
    test('returns the fix and the weather-service timezone on success',
        () async {
      final platform = _FakeGeoPlatform(
        fix: const GeoFix(
          latitude: 41.9028,
          longitude: 12.4964,
          accuracyMeters: 12,
        ),
      );
      final service = LocationService(
        platform: platform,
        timeZoneResolver: _resolver(weatherTimeZone: 'Europe/Rome'),
      );

      final result = await service.detectSiteLocation();

      expect(result.latitude, closeTo(41.9028, 1e-9));
      expect(result.longitude, closeTo(12.4964, 1e-9));
      expect(result.timeZone, 'Europe/Rome');
      expect(result.timeZoneSource, TimeZoneSource.weatherService);
      expect(result.accuracyMeters, 12);
      // Permission already granted: no runtime prompt.
      expect(platform.requestCalls, 0);
      expect(platform.fixCalls, 1);
    });

    test('falls back to the device timezone when the online lookup fails',
        () async {
      final service = LocationService(
        platform: _FakeGeoPlatform(),
        timeZoneResolver: _resolver(deviceTimeZone: 'Europe/Rome'),
      );

      final result = await service.detectSiteLocation();

      expect(result.timeZone, 'Europe/Rome');
      expect(result.timeZoneSource, TimeZoneSource.device);
    });

    test('uses UTC when no timezone can be resolved at all', () async {
      final service = LocationService(
        platform: _FakeGeoPlatform(),
        timeZoneResolver: _resolver(),
      );

      final result = await service.detectSiteLocation();

      expect(result.timeZone, 'UTC');
      expect(result.timeZoneSource, TimeZoneSource.device);
    });

    test('requests the permission when denied and continues if granted',
        () async {
      final platform = _FakeGeoPlatform(
        permission: GeoPermission.denied,
        requestResult: GeoPermission.granted,
      );
      final service = LocationService(
        platform: platform,
        timeZoneResolver: _resolver(weatherTimeZone: 'Europe/Rome'),
      );

      final result = await service.detectSiteLocation();

      expect(platform.requestCalls, 1);
      expect(result.timeZone, 'Europe/Rome');
    });

    test('throws serviceDisabled when location services are turned off',
        () async {
      final service = LocationService(
        platform: _FakeGeoPlatform(serviceEnabled: false),
        timeZoneResolver: _resolver(),
      );

      await expectLater(
        service.detectSiteLocation(),
        throwsA(isA<LocationException>().having((error) => error.failure,
            'failure', LocationFailure.serviceDisabled)),
      );
    });

    test('throws permissionDenied when the permission stays denied', () async {
      final platform = _FakeGeoPlatform(
        permission: GeoPermission.denied,
        requestResult: GeoPermission.denied,
      );
      final service = LocationService(
        platform: platform,
        timeZoneResolver: _resolver(),
      );

      await expectLater(
        service.detectSiteLocation(),
        throwsA(isA<LocationException>().having((error) => error.failure,
            'failure', LocationFailure.permissionDenied)),
      );
      expect(platform.fixCalls, 0);
    });

    test('throws permissionDeniedForever when the permission is blocked',
        () async {
      final platform = _FakeGeoPlatform(
        permission: GeoPermission.deniedForever,
      );
      final service = LocationService(
        platform: platform,
        timeZoneResolver: _resolver(),
      );

      await expectLater(
        service.detectSiteLocation(),
        throwsA(isA<LocationException>().having((error) => error.failure,
            'failure', LocationFailure.permissionDeniedForever)),
      );
      expect(platform.requestCalls, 0);
      expect(platform.fixCalls, 0);
    });

    test('throws timeout when no fix arrives in time', () async {
      final platform = _FakeGeoPlatform(
        fixError: TimeoutException('no fix'),
      );
      final service = LocationService(
        platform: platform,
        timeZoneResolver: _resolver(),
      );

      await expectLater(
        service.detectSiteLocation(),
        throwsA(isA<LocationException>().having(
            (error) => error.failure, 'failure', LocationFailure.timeout)),
      );
    });

    test('throws unavailable for unexpected platform errors', () async {
      final platform = _FakeGeoPlatform(
        fixError: Exception('platform channel failure'),
      );
      final service = LocationService(
        platform: platform,
        timeZoneResolver: _resolver(),
      );

      await expectLater(
        service.detectSiteLocation(),
        throwsA(isA<LocationException>().having(
            (error) => error.failure, 'failure', LocationFailure.unavailable)),
      );
    });

    test('maps platform permission exceptions to permissionDenied', () async {
      final platform = _FakeGeoPlatform(
        checkPermissionError: PlatformException(code: 'PERMISSION_DENIED'),
      );
      final service = LocationService(
        platform: platform,
        timeZoneResolver: _resolver(),
      );

      await expectLater(
        service.detectSiteLocation(),
        throwsA(isA<LocationException>().having((error) => error.failure,
            'failure', LocationFailure.permissionDenied)),
      );
    });

    test('maps known platform error codes to actionable failures', () async {
      const codes = <String, LocationFailure>{
        'PERMISSION_DENIED': LocationFailure.permissionDenied,
        'PERMISSION_DENIED_FOREVER': LocationFailure.permissionDeniedForever,
        'LOCATION_SERVICES_DISABLED': LocationFailure.serviceDisabled,
        'TIMEOUT': LocationFailure.timeout,
        'PERMISSION_DEFINITIONS_NOT_FOUND': LocationFailure.unavailable,
      };
      for (final entry in codes.entries) {
        final platform = _FakeGeoPlatform(
          checkPermissionError: PlatformException(code: entry.key),
        );
        final service = LocationService(
          platform: platform,
          timeZoneResolver: _resolver(),
        );

        await expectLater(
          service.detectSiteLocation(),
          throwsA(isA<LocationException>()
              .having((error) => error.failure, 'failure', entry.value)),
          reason: 'code ${entry.key} should map to ${entry.value.name}',
        );
      }
    });

    test('maps other platform exceptions to unavailable', () async {
      final platform = _FakeGeoPlatform(
        checkPermissionError:
            PlatformException(code: 'PERMISSION_DEFINITIONS_NOT_FOUND'),
      );
      final service = LocationService(
        platform: platform,
        timeZoneResolver: _resolver(),
      );

      await expectLater(
        service.detectSiteLocation(),
        throwsA(isA<LocationException>().having(
            (error) => error.failure, 'failure', LocationFailure.unavailable)),
      );
    });

    test('rejects non-finite or out-of-range coordinates', () async {
      final platform = _FakeGeoPlatform(
        fix: const GeoFix(latitude: double.nan, longitude: 12.4964),
      );
      final service = LocationService(
        platform: platform,
        timeZoneResolver: _resolver(),
      );

      await expectLater(
        service.detectSiteLocation(),
        throwsA(isA<LocationException>().having(
            (error) => error.failure, 'failure', LocationFailure.unavailable)),
      );
    });

    test('delegates opening the system settings pages', () async {
      final platform = _FakeGeoPlatform();
      final service = LocationService(
        platform: platform,
        timeZoneResolver: _resolver(),
      );

      expect(await service.openAppSettings(), isTrue);
      expect(await service.openLocationSettings(), isTrue);
      expect(platform.openedAppSettings, isTrue);
      expect(platform.openedLocationSettings, isTrue);
    });
  });

  group('TimeZoneResolver', () {
    test('prefers and trims the Open-Meteo timezone', () async {
      var deviceLookups = 0;
      final resolver = _resolver(
        weatherTimeZone: ' Europe/Rome ',
        deviceTimeZone: 'GMT',
        onDeviceLookup: () => deviceLookups++,
      );

      final resolved = await resolver.resolve(41.9028, 12.4964);

      expect(resolved.identifier, 'Europe/Rome');
      expect(resolved.source, TimeZoneSource.weatherService);
      expect(deviceLookups, 0);
    });

    test('ignores blank online results and falls back to the device', () async {
      final resolver = _resolver(
        weatherTimeZone: '   ',
        deviceTimeZone: 'Europe/Rome',
      );

      final resolved = await resolver.resolve(41.9028, 12.4964);

      expect(resolved.identifier, 'Europe/Rome');
      expect(resolved.source, TimeZoneSource.device);
    });

    test('returns UTC when both lookups fail', () async {
      final resolver = _resolver();

      final resolved = await resolver.resolve(0, 0);

      expect(resolved.identifier, 'UTC');
      expect(resolved.source, TimeZoneSource.device);
    });

    test('rejects "unknown" sentinels from the platform timezone lookup',
        () async {
      final resolver = _resolver(
        weatherTimeZone: 'Etc/Unknown',
        deviceTimeZone: 'Europe/Rome',
      );

      final resolved = await resolver.resolve(41.9028, 12.4964);

      expect(resolved.identifier, 'Europe/Rome');
      expect(resolved.source, TimeZoneSource.device);
    });
  });

  group('last known position fallback', () {
    final now = DateTime(2026, 11, 5, 16, 30);

    test('accepts a position from a few minutes ago', () {
      expect(
          PluginGeoPlatform.isFreshEnough(
              now.subtract(const Duration(minutes: 3)),
              now: now),
          isTrue);
    });

    test('rejects an old position (e.g. from another place)', () {
      expect(
          PluginGeoPlatform.isFreshEnough(
              now.subtract(const Duration(hours: 2)),
              now: now),
          isFalse);
    });

    test('rejects a timestamp in the future', () {
      expect(
          PluginGeoPlatform.isFreshEnough(now.add(const Duration(minutes: 1)),
              now: now),
          isFalse);
    });
  });
}
