class Formatters {
  static String formatPower(double watts) {
    if (watts.abs() >= 1000) {
      return '${(watts / 1000).toStringAsFixed(1)} kW';
    }
    return '${watts.toStringAsFixed(0)} W';
  }

  static String formatEnergy(double wattHours) {
    if (wattHours.abs() >= 1000) {
      return '${(wattHours / 1000).toStringAsFixed(1)} kWh';
    }
    return '${wattHours.toStringAsFixed(0)} Wh';
  }

  /// Compact chart Y-axis label with unit: "500 W", "1.5 kW".
  static String formatAxisPower(double watts) => _axis(watts, 'W');

  /// Compact chart Y-axis label with unit: "500 Wh", "2 kWh".
  static String formatAxisEnergy(double wh) => _axis(wh, 'Wh');

  static String _axis(double value, String unit) {
    if (value == 0) return '0';
    if (value.abs() >= 1000) {
      final k = value / 1000;
      final n =
          k == k.roundToDouble() ? k.toInt().toString() : k.toStringAsFixed(1);
      return '$n k$unit';
    }
    return '${value.toStringAsFixed(0)} $unit';
  }
}
