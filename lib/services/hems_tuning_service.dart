/// HEMS Tuning Service — auto-compute adaptive parameters
/// Based on system characteristics, history, and forecasts
library;

import 'dart:math';
import '../models/hems_optimization_profile.dart';
import 'log_service.dart';

class HemsTuningService {
  final HemsOptimizationProfile profile;

  HemsTuningService(this.profile);

  static const String _reasonPvVariance = 'reason=pv_variance_adaptation';
  static const String _reasonDwellVariance = 'reason=dwell_variance_adaptation';
  static const String _reasonReserveSoc = 'reason=reserve_soc_adaptation';

  /// Compute adaptive PV surplus threshold based on live variance
  double computeAdaptivePvSurplus(List<double> recentSurplusHistory) {
    if (recentSurplusHistory.isEmpty) {
      return profile.getAdaptivePvSurplusEnter();
    }

    // Calculate volatility (standard deviation)
    final mean = recentSurplusHistory.reduce((a, b) => a + b) /
        recentSurplusHistory.length;
    final variance = recentSurplusHistory
            .map((x) => pow(x - mean, 2).toDouble())
            .reduce((a, b) => a + b) /
        recentSurplusHistory.length;
    final stdDev = sqrt(variance);

    // Store for learning
    profile.learningMetrics['pvVariance'] = stdDev;

    // Base threshold adjusted for volatility
    final base = 0.10 * profile.pvPeakW;
    final hour = DateTime.now().hour;
    final hourPenalty = (hour < 10 || hour > 16) ? 1.5 : 0.9;

    // High variance = cloudy, need higher threshold to avoid flapping
    final variancePenalty = min(1.5, 1.0 + (stdDev / 200.0));

    final adaptive =
        (base * hourPenalty * variancePenalty).clamp(70, 600).toDouble();
    logParameterUpdate('pv_surplus_enter_w', base, adaptive,
        reasonCode: _reasonPvVariance);
    return adaptive;
  }

  /// Compute adaptive dwell time based on PV stability
  Duration computeAdaptiveDwell(List<double> recentSurplus) {
    if (recentSurplus.isEmpty) return const Duration(minutes: 15);

    final mean = recentSurplus.reduce((a, b) => a + b) / recentSurplus.length;
    final variance = recentSurplus
            .map((x) => pow(x - mean, 2).toDouble())
            .reduce((a, b) => a + b) /
        recentSurplus.length;
    final stdDev = sqrt(variance);

    // Cloudy (high variance) → short dwell (8 min)
    // Clear (low variance) → long dwell (25 min)
    final result = stdDev > 300
        ? const Duration(minutes: 8)
        : stdDev < 50
            ? const Duration(minutes: 25)
            : const Duration(minutes: 15);
    logParameterUpdate(
      'adaptive_dwell_minutes',
      15,
      result.inMinutes.toDouble(),
      reasonCode: _reasonDwellVariance,
    );
    return result;
  }

  /// Compute reserve SOC based on battery health, tariff, strategy
  double computeAdaptiveReserveSoc({
    required double baseReserveSoc,
    required bool isTimeOfUseTariff,
  }) {
    var adaptive = baseReserveSoc;

    // Battery health factor
    adaptive = profile.batteryHealth
        .getAdaptiveReserveSoc(baseReserveSoc: baseReserveSoc);

    // Strategy factor
    if (profile.optimizationStrategy == HemsOptimizationStrategy.solarMaxed) {
      adaptive -= 2; // more aggressive
    } else if (profile.optimizationStrategy ==
        HemsOptimizationStrategy.batteryLife) {
      adaptive += 3; // more conservative
    }

    // TOU tariff factor: if cheap night charge available, can use lower reserve
    if (isTimeOfUseTariff && profile.tariffForecast != null) {
      adaptive -= 1; // can afford lower reserve due to cheap charging
    }

    final clamped = adaptive.clamp(15, 35).toDouble();
    logParameterUpdate('reserve_soc', baseReserveSoc, clamped,
        reasonCode: _reasonReserveSoc);
    return clamped;
  }

  /// Log transitions when parameters change
  void logParameterUpdate(String paramName, double oldValue, double newValue,
      {String reasonCode = 'reason=parameter_update'}) {
    if ((oldValue - newValue).abs() > 0.01) {
      LogService.log(
        '🔧 HEMS: parameter adjusted ($reasonCode) — '
        '$paramName: ${oldValue.toStringAsFixed(1)} → ${newValue.toStringAsFixed(1)}',
      );
    }
  }
}
