import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inverter_app/utils/energy_totals.dart';

void main() {
  test('day totals integrate power samples and split battery in/out', () {
    // 1 kW PV for 2 h in 15-minute samples; battery +500 W then -500 W.
    final pv = [for (var i = 0; i <= 8; i++) FlSpot(10 + i * 0.25, 1000)];
    final battery = [
      for (var i = 0; i < 4; i++) FlSpot(10 + i * 0.25, 500),
      for (var i = 4; i <= 8; i++) FlSpot(10 + i * 0.25, -500),
    ];
    final t = EnergyTotals.fromPower(
        pv: pv, load: const [], battery: battery, acIn: const []);
    // 8 steps of 0.25 h + last sample 5 min.
    expect(t.pvWh, closeTo(2000 + 1000 * 5 / 60, 0.01));
    expect(t.batteryInWh, closeTo(500, 0.01));
    expect(t.batteryOutWh, closeTo(500 + 500 * 5 / 60, 0.01));
    expect(t.loadWh, isNull);
  });

  test('a telemetry gap does not count as hours of constant power', () {
    final t = EnergyTotals.fromPower(
      pv: const [FlSpot(8, 1000), FlSpot(14, 1000)],
      load: const [],
      battery: const [],
      acIn: const [],
    );
    expect(t.pvWh, closeTo(2 * 1000 * 5 / 60, 0.01));
  });

  test('week/month totals sum daily energy', () {
    final t = EnergyTotals.fromDaily(
      pv: const [FlSpot(0, 4000), FlSpot(1, 3500)],
      load: const [FlSpot(0, 1200)],
      batteryIn: const [FlSpot(0, 2000)],
      batteryOut: const [],
      acIn: const [FlSpot(0, 0)],
    );
    expect(t.pvWh, 7500);
    expect(t.loadWh, 1200);
    expect(t.batteryInWh, 2000);
    expect(t.batteryOutWh, isNull);
    expect(t.acInWh, 0);
  });

  test('HH:mm formatting', () {
    expect(formatHourOfDay(13.5), '13:30');
    expect(formatHourOfDay(0), '00:00');
    expect(formatHourOfDay(9.9999), '10:00');
    expect(formatHourOfDay(23.999), '23:59');
  });
}
