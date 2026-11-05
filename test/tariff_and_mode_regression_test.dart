import 'package:flutter_test/flutter_test.dart';
import 'package:inverter_app/models/hems_optimization_profile.dart';
import 'package:inverter_app/models/inverter_data.dart';
import 'package:inverter_app/services/tariff_forecast_service.dart';
void main() {
  group('TariffForecastData.getNextCheapWindow', () {
    test('returns a future cheap window relative to provided from timestamp', () {
      final base = DateTime(2026, 5, 15, 0);
      final prices = <DateTime, double>{};
      for (var h = 0; h < 24; h++) {
        final dt = DateTime(base.year, base.month, base.day, h);
        final isNight = h >= 19 && h <= 22;
        prices[dt] = isNight ? 2.16 : 4.32;
      }
      final forecast = TariffForecastData(pricePerKwh: prices);
      final next = forecast.getNextCheapWindow(
        const Duration(hours: 2),
        1.0,
        from: DateTime(2026, 5, 15, 12, 9),
      );
      expect(next, isNotNull);
      expect(next, DateTime(2026, 5, 15, 19));
    });
    test('requires contiguous cheap slots for minimum duration', () {
      final base = DateTime(2026, 5, 15, 0);
      final prices = <DateTime, double>{
        DateTime(base.year, base.month, base.day, 12): 1.0,
        DateTime(base.year, base.month, base.day, 14): 1.0,
        DateTime(base.year, base.month, base.day, 15): 4.0,
      };
      final forecast = TariffForecastData(pricePerKwh: prices);
      final next = forecast.getNextCheapWindow(
        const Duration(hours: 2),
        1.0,
        from: DateTime(2026, 5, 15, 11),
      );
      expect(next, isNull);
    });
  });
  group('InverterData current mode fallback', () {
    test('uses outputSourcePriority when explicit mode is empty', () {
      final data = InverterData.fromJson(
        {
          'deviceAttributeState': {
            'fields': {
              'outputSourcePriority': {'value': '0'},
              'workingStates': {'valueDisplay': 'Line Mode', 'value': '4'},
            }
          }
        },
        'sn-test',
        '',
      );
      expect(data.currentModeStr, 'USB');
    });
  });
  group('TariffForecastService.isNightTariffHour', () {
    test('default 23–7 window wraps midnight', () {
      final night = [for (var h = 0; h < 24; h++) h]
          .where(TariffForecastService.isNightTariffHour)
          .toList();
      expect(night, [0, 1, 2, 3, 4, 5, 6, 23]);
    });
    test('custom window and inverted window', () {
      expect(
          TariffForecastService.isNightTariffHour(22,
              dayStartHour: 6, nightStartHour: 22),
          isTrue);
      expect(
          TariffForecastService.isNightTariffHour(6,
              dayStartHour: 6, nightStartHour: 22),
          isFalse);
      // night 1→5 expressed with day start after night start
      expect(
          TariffForecastService.isNightTariffHour(3,
              dayStartHour: 5, nightStartHour: 1),
          isTrue);
      expect(
          TariffForecastService.isNightTariffHour(12,
              dayStartHour: 5, nightStartHour: 1),
          isFalse);
    });
    test('equal hours fall back to 23–7', () {
      expect(
          TariffForecastService.isNightTariffHour(23,
              dayStartHour: 7, nightStartHour: 7),
          isTrue);
      expect(
          TariffForecastService.isNightTariffHour(12,
              dayStartHour: 7, nightStartHour: 7),
          isFalse);
    });
  });
}
