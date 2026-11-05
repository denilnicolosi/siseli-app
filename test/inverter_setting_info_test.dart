import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inverter_app/l10n/app_localizations.dart';
import 'package:inverter_app/utils/inverter_reading_info.dart';
import 'package:inverter_app/utils/inverter_setting_info.dart';

void main() {
  test('every known inverter setting has an Italian name and description', () {
    final it = lookupAppLocalizations(const Locale('it'));
    final en = lookupAppLocalizations(const Locale('en'));
    for (final key in knownInverterSettingKeys) {
      final info = inverterSettingInfo(it, key);
      expect(info, isNotNull, reason: key);
      expect(info!.name, isNot(key), reason: key);
      expect(info.description.trim(), isNotEmpty, reason: key);
      // Italian text must really be translated, not the English fallback.
      expect(info.name, isNot(inverterSettingInfo(en, key)!.name), reason: key);
    }
  });

  test('unknown keys fall back to the API name', () {
    final it = lookupAppLocalizations(const Locale('it'));
    expect(inverterSettingInfo(it, 'someFutureSetting'), isNull);
    expect(inverterReadingInfo(it, 'someFutureReading'), isNull);
  });

  test('every known realtime reading has an Italian name and description', () {
    final it = lookupAppLocalizations(const Locale('it'));
    for (final key in knownInverterReadingKeys) {
      final info = inverterReadingInfo(it, key);
      expect(info, isNotNull, reason: key);
      expect(info!.name.trim(), isNotEmpty, reason: key);
      expect(info.description.trim(), isNotEmpty, reason: key);
    }
  });

  test('API enum values are translated, unknown ones pass through', () {
    final it = lookupAppLocalizations(const Locale('it'));
    expect(translateReadingValue(it, 'charge'), 'In carica');
    expect(translateReadingValue(it, 'OFF'), 'Spento');
    expect(translateReadingValue(it, 'SBU'), 'SBU');
  });

  test('every English text the API sends for the SMH III is translated', () {
    final it = lookupAppLocalizations(const Locale('it'));
    // valueDisplay strings captured from solar.siseli.com realtime data.
    const apiTexts = [
      'discharge',
      'off',
      'OFF',
      'ON',
      'disable',
      'Enable',
      'Invert Mode',
      'Not connected to mains power',
      'Normal working state',
      'Photovoltaic not connected',
      'Not connected and voltage below low voltage point',
    ];
    for (final text in apiTexts) {
      expect(translateReadingValue(it, text), isNot(text), reason: text);
    }
  });
}
