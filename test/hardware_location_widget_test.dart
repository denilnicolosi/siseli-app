import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:inverter_app/l10n/app_localizations.dart';
import 'package:inverter_app/providers/app_provider.dart';
import 'package:inverter_app/screens/settings/settings_tab.dart';
import 'package:inverter_app/services/location_service.dart';
import 'package:inverter_app/theme/app_theme.dart';

class _LocationTestProvider extends AppStateProvider {
  _LocationTestProvider({this.result, this.failure});

  final SiteLocation? result;
  final LocationFailure? failure;

  double? savedLatitude;
  double? savedLongitude;
  String? savedTimeZone;

  @override
  Future<SiteLocation> detectSiteLocation() async {
    final error = failure;
    if (error != null) throw LocationException(error);
    return result!;
  }

  @override
  Future<void> saveHardwareSettings(double battery, double pv, double inverter,
      {DateTime? installDate,
      double? breakerAmps,
      double? gridVoltage,
      double? loadReserveW,
      bool? autoReserveEnabled,
      double? selfConsumptionW}) async {}

  @override
  Future<void> saveGeoSettings({
    required double latitude,
    required double longitude,
    required String timeZone,
  }) async {
    savedLatitude = latitude;
    savedLongitude = longitude;
    savedTimeZone = timeZone;
  }
}

Future<void> _pumpHardwareSection(
  WidgetTester tester,
  AppStateProvider provider,
) async {
  await tester.binding.setSurfaceSize(const Size(800, 1200));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    ChangeNotifierProvider<AppStateProvider>.value(
      value: provider,
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: SingleChildScrollView(
            child: HardwareSettingsSection(
              provider: provider,
              enableBlur: false,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _openGeoSection(WidgetTester tester) async {
  await tester.tap(find.text('Station parameters'));
  await tester.pumpAndSettle();

  final dialogScrollable = find.descendant(
    of: find.byType(AlertDialog),
    matching: find.byType(Scrollable),
  );
  await tester.scrollUntilVisible(
    find.text('Use my location'),
    300,
    scrollable: dialogScrollable.first,
  );
  await tester.pumpAndSettle();
}

Future<void> _runAsAndroid(Future<void> Function() body) async {
  debugDefaultTargetPlatformOverride = TargetPlatform.android;
  try {
    await body();
  } finally {
    // Must be reset inside the test body: the framework verifies that
    // foundation debug variables are unset before tearDown callbacks run.
    debugDefaultTargetPlatformOverride = null;
  }
}

void main() {
  testWidgets('location button fills coordinates, timezone and saves them',
      (WidgetTester tester) async {
    await _runAsAndroid(() async {
      final provider = _LocationTestProvider(
        result: const SiteLocation(
          latitude: 41.9028,
          longitude: 12.4964,
          timeZone: 'Europe/Rome',
          timeZoneSource: TimeZoneSource.weatherService,
          accuracyMeters: 12,
        ),
      );
      await _pumpHardwareSection(tester, provider);
      await _openGeoSection(tester);

      await tester.tap(find.text('Use my location'));
      await tester.pumpAndSettle();

      expect(find.text('41.9028'), findsOneWidget);
      expect(find.text('12.4964'), findsOneWidget);
      expect(find.text('Europe/Rome'), findsOneWidget);
      expect(find.text('Custom (manual)'), findsOneWidget);
      expect(find.textContaining('Position detected'), findsOneWidget);

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(provider.savedLatitude, closeTo(41.9028, 1e-9));
      expect(provider.savedLongitude, closeTo(12.4964, 1e-9));
      expect(provider.savedTimeZone, 'Europe/Rome');
    });
  });

  testWidgets('permission failure is shown inline inside the dialog',
      (WidgetTester tester) async {
    await _runAsAndroid(() async {
      final provider =
          _LocationTestProvider(failure: LocationFailure.permissionDenied);
      await _pumpHardwareSection(tester, provider);
      await _openGeoSection(tester);

      await tester.tap(find.text('Use my location'));
      await tester.pumpAndSettle();

      expect(
        find.text('Location permission denied. Allow access to position for '
            'this app and try again.'),
        findsOneWidget,
      );
      expect(find.text('Open settings'), findsOneWidget);
      // The dialog stays open so the user can retry after fixing the permission.
      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });

  testWidgets('stored non-preset coordinates open the dialog as custom',
      (WidgetTester tester) async {
    final provider = _LocationTestProvider();
    provider.siteLatitude = 41.9028;
    provider.siteLongitude = 12.4964;
    await _pumpHardwareSection(tester, provider);

    await tester.tap(find.text('Station parameters'));
    await tester.pumpAndSettle();

    expect(find.text('Custom (manual)'), findsOneWidget);
  });

  testWidgets('stored preset coordinates still open the dialog as that preset',
      (WidgetTester tester) async {
    final provider = _LocationTestProvider();
    provider.siteLatitude = 50.4501;
    provider.siteLongitude = 30.5234;
    await _pumpHardwareSection(tester, provider);

    await tester.tap(find.text('Station parameters'));
    await tester.pumpAndSettle();

    expect(find.text('Kyiv, UA'), findsOneWidget);
    expect(find.text('Custom (manual)'), findsNothing);
  });
}
