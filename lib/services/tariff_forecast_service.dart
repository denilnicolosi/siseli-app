import '../models/hems_optimization_profile.dart';

class TariffForecastService {
  /// Single source of truth for "is this hour billed at the night tariff".
  /// Handles windows wrapping midnight (night 23 → day 7) and the reverse.
  /// Equal start hours are treated as misconfigured and fall back to 23–7.
  static bool isNightTariffHour(
    int hour, {
    int dayStartHour = 7,
    int nightStartHour = 23,
  }) {
    final dayStart = dayStartHour.clamp(0, 23);
    final nightStart = nightStartHour.clamp(0, 23);
    if (dayStart == nightStart) return hour < 7 || hour >= 23;
    if (dayStart < nightStart) return hour < dayStart || hour >= nightStart;
    return hour >= nightStart && hour < dayStart;
  }

  TariffForecastData buildDayNightForecast({
    required double dayTariffUahPerKwh,
    required double nightTariffUahPerKwh,
    int dayStartHour = 7,
    int nightStartHour = 23,
    int horizonHours = 24,
  }) {
    final now = DateTime.now();
    final prices = <DateTime, double>{};

    for (var i = 0; i < horizonHours; i++) {
      final hour = now.add(Duration(hours: i));
      final h = hour.hour;
      final isNight = isNightTariffHour(h,
          dayStartHour: dayStartHour, nightStartHour: nightStartHour);
      prices[DateTime(hour.year, hour.month, hour.day, h)] =
          isNight ? nightTariffUahPerKwh : dayTariffUahPerKwh;
    }

    return TariffForecastData(
      pricePerKwh: prices,
      externalSource: 'local_day_night_profile',
    );
  }
}
