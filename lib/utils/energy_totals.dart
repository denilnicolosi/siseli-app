import 'package:fl_chart/fl_chart.dart';

/// Energy totals (Wh) shown under the energy history chart.
/// A null value means the API did not provide that series.
class EnergyTotals {
  const EnergyTotals({
    required this.pvWh,
    required this.loadWh,
    required this.batteryInWh,
    required this.batteryOutWh,
    required this.acInWh,
  });

  final double? pvWh;
  final double? loadWh;
  final double? batteryInWh;
  final double? batteryOutWh;
  final double? acInWh;

  /// Day view: series are power samples in W at x = hour of day.
  /// Battery power is signed (+ charge, − discharge).
  factory EnergyTotals.fromPower({
    required List<FlSpot> pv,
    required List<FlSpot> load,
    required List<FlSpot> battery,
    required List<FlSpot> acIn,
  }) {
    return EnergyTotals(
      pvWh: _integrate(pv, (w) => w),
      loadWh: _integrate(load, (w) => w),
      batteryInWh: _integrate(battery, (w) => w > 0 ? w : 0),
      batteryOutWh: _integrate(battery, (w) => w < 0 ? -w : 0),
      acInWh: _integrate(acIn, (w) => w > 0 ? w : 0),
    );
  }

  /// Week/month views: series are already energy per day in Wh.
  factory EnergyTotals.fromDaily({
    required List<FlSpot> pv,
    required List<FlSpot> load,
    required List<FlSpot> batteryIn,
    required List<FlSpot> batteryOut,
    required List<FlSpot> acIn,
  }) {
    double? sum(List<FlSpot> s) =>
        s.isEmpty ? null : s.fold<double>(0, (a, p) => a + p.y.abs());
    return EnergyTotals(
      pvWh: sum(pv),
      loadWh: sum(load),
      batteryInWh: sum(batteryIn),
      batteryOutWh: sum(batteryOut),
      acInWh: sum(acIn),
    );
  }

  /// Each sample holds until the next one; gaps longer than 30 min (missing
  /// telemetry) count as one 5-minute sample, and the last sample counts
  /// 5 minutes, matching the ~5 min cadence of the history API.
  static double? _integrate(List<FlSpot> spots, double Function(double) f) {
    if (spots.isEmpty) return null;
    const defaultStepH = 5 / 60;
    var wh = 0.0;
    for (var i = 0; i < spots.length; i++) {
      final gap = i + 1 < spots.length ? spots[i + 1].x - spots[i].x : 0.0;
      final stepH = gap > 0 && gap <= 0.5 ? gap : defaultStepH;
      wh += f(spots[i].y) * stepH;
    }
    return wh;
  }
}

/// "HH:mm" for a fractional hour (e.g. 13.5 -> "13:30").
String formatHourOfDay(double hours) {
  final totalMinutes = (hours * 60).round().clamp(0, 24 * 60 - 1);
  final h = (totalMinutes ~/ 60).toString().padLeft(2, '0');
  final m = (totalMinutes % 60).toString().padLeft(2, '0');
  return '$h:$m';
}
