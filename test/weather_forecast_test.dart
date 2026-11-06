import 'package:flutter_test/flutter_test.dart';
import 'package:inverter_app/services/weather_service.dart';

void main() {
  final payload = <String, dynamic>{
    'hourly': {
      'time': [
        '2026-11-05T12:00', // yesterday: ignored
        '2026-11-06T11:00', // covers 10:00-11:00
        '2026-11-06T12:00', // covers 11:00-12:00, above nameplate
        '2026-11-07T00:00', // covers 23:00-24:00 of the 6th
      ],
      'shortwave_radiation': [800, 500, 1300, 0],
    },
  };
  final now = DateTime(2026, 11, 6, 8);

  test('PV power: GHI x capacity x 0.80, clamped to nameplate', () {
    expect(WeatherService.pvWatts(500, 3000), 1200);
    expect(WeatherService.pvWatts(1300, 3000), 3000);
    expect(WeatherService.pvWatts(-5, 3000), 0);
  });

  test('daily energy sums hourly means, skips past days', () {
    final days = WeatherService.dailyFromPayload(payload,
        pvCapacityW: 3000, now: now, days: 2);
    expect(days, hasLength(1));
    expect(days.single.date, DateTime(2026, 11, 6));
    expect(days.single.energyWh, 1200 + 3000);
  });

  test('hourly points sit at the middle of the hour they cover', () {
    final hourly = WeatherService.hourlyFromPayload(payload,
        pvCapacityW: 3000, now: now, targetDate: DateTime(2026, 11, 6));
    expect(hourly, {'2026-11-06 10:30': 1200.0, '2026-11-06 11:30': 3000.0});
  });
}
