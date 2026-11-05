import 'package:fl_chart/fl_chart.dart';

/// Compact one-line description of a chart series for diagnostic logs.
String describeSpots(List<FlSpot> spots) {
  if (spots.isEmpty) return 'count=0';
  var minX = spots.first.x, maxX = minX;
  var minY = spots.first.y, maxY = minY;
  for (final s in spots) {
    if (s.x < minX) minX = s.x;
    if (s.x > maxX) maxX = s.x;
    if (s.y < minY) minY = s.y;
    if (s.y > maxY) maxY = s.y;
  }
  return 'count=${spots.length},x=${minX.toStringAsFixed(2)}..${maxX.toStringAsFixed(2)},y=${minY.toStringAsFixed(1)}..${maxY.toStringAsFixed(1)}';
}
