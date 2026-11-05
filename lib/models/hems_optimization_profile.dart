/// HEMS Optimization Profile — unified model for all tuning parameters
/// Consolidates: base tunables + auto-tuning + learned drift
library;

/// Optimization strategy for HEMS decision-making
enum HemsOptimizationStrategy {
  economical, // Minimize grid import cost (TOU tariff priority)
  solarMaxed, // Maximize PV self-consumption (no curtailment)
  batteryLife, // Minimize battery cycles (conservative, grid-first)
  gridReliance, // Minimize grid dependency (off-grid / resilience)
  hybrid, // Balance all three (default)
}

/// Battery health / degradation model
class BatteryHealthModel {
  DateTime installationDate;
  double? healthPercentage; // 100% = new
  DateTime lastHealthCheckAt;

  BatteryHealthModel({
    required this.installationDate,
    this.healthPercentage = 100.0,
    DateTime? lastHealthCheckAt,
  }) : lastHealthCheckAt = lastHealthCheckAt ?? DateTime.now();

  double getAdaptiveReserveSoc({
    double baseReserveSoc = 20.0,
    double maxReserveSoc = 35.0,
  }) {
    final ageYears = DateTime.now().difference(installationDate).inDays / 365.0;
    final healthFactor = (healthPercentage ?? 100.0) / 100.0;

    double agePenalty;
    if (ageYears < 2) {
      agePenalty = -2; // aggressive (18%)
    } else if (ageYears < 5) {
      agePenalty = 0; // normal (20%)
    } else if (ageYears < 8) {
      agePenalty = 3; // cautious (23%)
    } else {
      agePenalty = 8; // very old (28%)
    }

    final healthPenalty = (1.0 - healthFactor) * 10.0;
    final adaptive = baseReserveSoc + agePenalty + healthPenalty;
    // Allow aggressive (lower) reserve for young batteries; clamp at 15% hard floor.
    return adaptive.clamp(15.0, maxReserveSoc);
  }
}

/// Tariff forecast (prices for grid energy, day-ahead or TOU)
class TariffForecastData {
  final Map<DateTime, double> pricePerKwh;
  final String externalSource;
  final DateTime fetchedAt;

  TariffForecastData({
    required this.pricePerKwh,
    this.externalSource = 'manual',
    DateTime? fetchedAt,
  }) : fetchedAt = fetchedAt ?? DateTime.now();

  double get _averagePrice {
    if (pricePerKwh.isEmpty) return 0.0;
    return pricePerKwh.values.reduce((a, b) => a + b) / pricePerKwh.length;
  }

  DateTime? getNextCheapWindow(
    Duration minDuration,
    double priceMargin, {
    DateTime? from,
  }) {
    if (pricePerKwh.isEmpty) return null;
    final startFrom = from ?? DateTime.now();
    final avg = _averagePrice;
    final maxPrice = avg * priceMargin;

    final sorted = pricePerKwh.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    DateTime? blockStart;
    DateTime? prevKey;

    for (final entry in sorted) {
      if (entry.key.isBefore(startFrom)) {
        continue;
      }

      final isCheap = entry.value <= maxPrice;
      if (!isCheap) {
        blockStart = null;
        prevKey = null;
        continue;
      }

      if (blockStart == null) {
        blockStart = entry.key;
        prevKey = entry.key;
      } else {
        final gap = entry.key.difference(prevKey!);
        if (gap > const Duration(hours: 1, minutes: 5)) {
          blockStart = entry.key;
        }
        prevKey = entry.key;
      }

      final duration = entry.key.difference(blockStart);
      if (duration >= minDuration) {
        return blockStart;
      }
    }
    return null;
  }
}

/// Demand forecast (predicted load for future hours/days)
class DemandForecastData {
  final Map<int, DemandMetrics> hourlyMetrics;
  final String season;
  final DateTime learnedAt;

  DemandForecastData({
    required this.hourlyMetrics,
    this.season = 'spring',
    DateTime? learnedAt,
  }) : learnedAt = learnedAt ?? DateTime.now();

  double predictLoad(int hour,
      {bool isWeekend = false, int? heatingDemandAheadDays}) {
    final metrics = hourlyMetrics[hour];
    if (metrics == null) return 500.0;
    var predicted = metrics.p50;
    if (season == 'winter' && (heatingDemandAheadDays ?? 0) > 0) {
      predicted *= 1.3;
    }
    if (isWeekend) predicted *= 0.85;
    return predicted;
  }
}

/// Metrics for a given hour (learned from history)
class DemandMetrics {
  double p25;
  double p50;
  double p75;
  double p90;

  DemandMetrics({
    required this.p25,
    required this.p50,
    required this.p75,
    required this.p90,
  });
}

/// Comprehensive tuning profile
class HemsOptimizationProfile {
  final String systemId;
  final double pvPeakW;
  final double batteryCapacityAh;

  HemsOptimizationStrategy optimizationStrategy;
  BatteryHealthModel batteryHealth;
  TariffForecastData? tariffForecast;
  DemandForecastData? demandForecast;

  Map<String, double> learningMetrics;

  HemsOptimizationProfile({
    required this.systemId,
    required this.pvPeakW,
    required this.batteryCapacityAh,
    this.optimizationStrategy = HemsOptimizationStrategy.hybrid,
    BatteryHealthModel? batteryHealth,
    this.tariffForecast,
    this.demandForecast,
    Map<String, double>? learningMetrics,
  })  : batteryHealth = batteryHealth ??
            BatteryHealthModel(installationDate: DateTime.now()),
        learningMetrics = learningMetrics ?? {};

  double getAdaptivePvSurplusEnter() {
    final hour = DateTime.now().hour;
    final baseThreshold = 0.10 * pvPeakW;
    final stabilityFactor = (hour < 10 || hour > 16) ? 1.5 : 0.9;
    final variance = learningMetrics['pvVariance'] ?? 0.0;
    final variancePenalty = variance > 200 ? 1.3 : 1.0;

    return (baseThreshold * stabilityFactor * variancePenalty).clamp(70, 600);
  }

  double getAdaptiveReserveSoc() => batteryHealth.getAdaptiveReserveSoc();

  Duration getAdaptiveModeHold() {
    final variance = learningMetrics['pvVariance'] ?? 0.0;
    if (variance > 300) return const Duration(minutes: 8);
    if (variance < 50) return const Duration(minutes: 25);
    return const Duration(minutes: 15);
  }
}
