import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'log_service.dart';

class DailySolarForecast {
  final DateTime date;
  final double energyWh;

  /// Open-Meteo daily WMO weather code (0 clear … 99 thunderstorm), null
  /// when the payload has none.
  final int? weatherCode;

  const DailySolarForecast({
    required this.date,
    required this.energyWh,
    this.weatherCode,
  });
}

class WeatherPerformanceSnapshot {
  final int localCacheHits;
  final int localCacheMisses;
  final int localInFlightJoins;
  final int dailyCacheHits;
  final int dailyCacheMisses;
  final int dailyInFlightJoins;
  final int localRequests;
  final int dailyRequests;
  final int localAvgMs;
  final int dailyAvgMs;

  const WeatherPerformanceSnapshot({
    required this.localCacheHits,
    required this.localCacheMisses,
    required this.localInFlightJoins,
    required this.dailyCacheHits,
    required this.dailyCacheMisses,
    required this.dailyInFlightJoins,
    required this.localRequests,
    required this.dailyRequests,
    required this.localAvgMs,
    required this.dailyAvgMs,
  });
}

class _MemoryCacheEntry<T> {
  final T data;
  final DateTime createdAt;

  const _MemoryCacheEntry({
    required this.data,
    required this.createdAt,
  });
}

class WeatherService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.open-meteo.com',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  // БЕЗПЕКА: Rate limiting
  DateTime? _lastRequestTime;
  static const _minRequestIntervalMs = 1000; // 1 запит за секунду мінімум

  // Runtime caches reduce repeated CPU work (lookup + interpolation) between UI refreshes.
  static const Duration _localForecastMemoryTtl = Duration(minutes: 12);
  static const Duration _dailyForecastMemoryTtl = Duration(minutes: 20);
  static const int _maxMemoryCacheEntries = 24;
  final Map<String, _MemoryCacheEntry<Map<String, double>>>
      _localForecastCache = <String, _MemoryCacheEntry<Map<String, double>>>{};
  final Map<String, _MemoryCacheEntry<List<DailySolarForecast>>>
      _dailyForecastCache =
      <String, _MemoryCacheEntry<List<DailySolarForecast>>>{};
  final Map<String, Future<Map<String, double>>> _localForecastInFlight =
      <String, Future<Map<String, double>>>{};
  final Map<String, Future<List<DailySolarForecast>>> _dailyForecastInFlight =
      <String, Future<List<DailySolarForecast>>>{};
  int _localCacheHits = 0;
  int _localCacheMisses = 0;
  int _localInFlightJoins = 0;
  int _dailyCacheHits = 0;
  int _dailyCacheMisses = 0;
  int _dailyInFlightJoins = 0;
  int _localRequests = 0;
  int _dailyRequests = 0;
  double _localAvgMs = 0;
  double _dailyAvgMs = 0;

  WeatherService() {
    // БЕЗПЕКА: Dio автоматично перевіряє SSL сертифікати
    // Open-Meteo використовує legitim Let's Encrypt сертифікати
  }

  /// БЕЗПЕКА: Rate limiting для запобігання DoS атакам
  Future<void> _applyRateLimit() async {
    final now = DateTime.now();
    if (_lastRequestTime != null) {
      final elapsed = now.difference(_lastRequestTime!).inMilliseconds;
      if (elapsed < _minRequestIntervalMs) {
        final delayMs = _minRequestIntervalMs - elapsed;
        LogService.log(
            '⏱️ Rate limit applied for Open-Meteo, delay=${delayMs}ms');
        await Future.delayed(Duration(milliseconds: delayMs));
      }
    }
    _lastRequestTime = DateTime.now();
  }

  static double? _toDoubleOrNull(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  // Динамічний кеш: вночі можна довше, вдень — частіше
  static int get _cacheValidDurationHours {
    final hour = DateTime.now().hour;
    return (hour >= 22 || hour < 6) ? 6 : 1;
  }

  Future<Map<String, dynamic>?> _loadOpenMeteoPayload({
    required double lat,
    required double lon,
    required int forecastDays,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    // Location is part of the key so a changed site never reuses old weather.
    final loc = '${lat.toStringAsFixed(2)}_${lon.toStringAsFixed(2)}';
    // v4: payload also carries daily weather_code.
    final cacheDataKey = 'openmeteo_cache_data_v4_${forecastDays}_$loc';
    final cacheTimeKey = 'openmeteo_cache_timestamp_v4_${forecastDays}_$loc';

    final cachedData = prefs.getString(cacheDataKey);
    final cacheTimestampStr = prefs.getString(cacheTimeKey);
    if (cachedData != null && cacheTimestampStr != null) {
      final cacheTimestamp = DateTime.parse(cacheTimestampStr);
      if (DateTime.now().difference(cacheTimestamp).inHours <
          _cacheValidDurationHours) {
        LogService.log('☀️ Прогноз з кешу (TTL: $_cacheValidDurationHoursг)');
        return json.decode(cachedData) as Map<String, dynamic>;
      }
    }

    final url = 'https://api.open-meteo.com/v1/forecast'
        '?latitude=$lat&longitude=$lon'
        '&hourly=shortwave_radiation'
        '&daily=weather_code'
        '&timezone=auto'
        '&past_days=14'
        '&forecast_days=$forecastDays';

    try {
      LogService.log(
          '🔄 Завантажуємо прогноз Open-Meteo (past=14, future=$forecastDays)...');

      // БЕЗПЕКА: Rate limiting
      await _applyRateLimit();

      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        await prefs.setString(cacheDataKey, json.encode(responseData));
        await prefs.setString(cacheTimeKey, DateTime.now().toIso8601String());
        LogService.log('✅ Open-Meteo завантажено успішно');
        return responseData;
      }
    } catch (e, stack) {
      LogService.log('❌ Помилка Open-Meteo', error: e, stack: stack);
      if (cachedData != null) {
        return json.decode(cachedData) as Map<String, dynamic>;
      }
    }

    return null;
  }

  // ─────────────────────────────────────────────────────────
  // PV MODEL: flat panels, so the horizontal GHI from Open-Meteo is the
  // irradiance on the panels.
  // ─────────────────────────────────────────────────────────

  /// Overall performance ratio: MPPT/inverter, wiring, soiling and the
  /// temperature loss of a typical day.
  // ponytail: one fixed ratio, no temperature model. Add `temperature_2m`
  // derating if summer forecasts run high.
  static const double performanceRatio = 0.80;

  /// Expected PV power (W) for [ghiWm2] on [pvCapacityW] of panels, never
  /// above the nameplate.
  @visibleForTesting
  static double pvWatts(double ghiWm2, double pvCapacityW) {
    if (ghiWm2 <= 0 || pvCapacityW <= 0) return 0;
    final w = ghiWm2 / 1000.0 * pvCapacityW * performanceRatio;
    return w > pvCapacityW ? pvCapacityW : w;
  }

  /// Hourly PV power keyed "yyyy-MM-dd HH:mm".
  Future<Map<String, double>> fetchLocalForecast({
    required double lat,
    required double lon,
    required double pvCapacityW,
    DateTime? targetDate, // null: only the rest of today and later
  }) async {
    final cacheKey =
        'local|${lat.toStringAsFixed(3)}|${lon.toStringAsFixed(3)}|'
        '${pvCapacityW.toStringAsFixed(0)}|${_targetDayKey(targetDate)}';

    final cached = _localForecastCache[cacheKey];
    if (cached != null &&
        DateTime.now().difference(cached.createdAt) < _localForecastMemoryTtl) {
      _localCacheHits++;
      return Map<String, double>.from(cached.data);
    }
    _localCacheMisses++;

    final inFlight = _localForecastInFlight[cacheKey];
    if (inFlight != null) {
      _localInFlightJoins++;
      final result = await inFlight;
      return Map<String, double>.from(result);
    }

    final future = _computeLocalForecast(
      lat: lat,
      lon: lon,
      pvCapacityW: pvCapacityW,
      targetDate: targetDate,
    );
    _localForecastInFlight[cacheKey] = future;
    final sw = Stopwatch()..start();

    try {
      final result = await future;
      _recordLocalDuration(sw.elapsedMilliseconds);
      _localForecastCache[cacheKey] = _MemoryCacheEntry<Map<String, double>>(
        data: Map<String, double>.from(result),
        createdAt: DateTime.now(),
      );
      _pruneCache(_localForecastCache);
      return Map<String, double>.from(result);
    } finally {
      _localForecastInFlight.remove(cacheKey);
    }
  }

  Future<Map<String, double>> _computeLocalForecast({
    required double lat,
    required double lon,
    required double pvCapacityW,
    required DateTime? targetDate,
  }) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final desiredDay = targetDate == null
        ? today
        : DateTime(targetDate.year, targetDate.month, targetDate.day);
    final dayDiff = desiredDay.difference(today).inDays;
    // Keep minimum of 2 days, but expand horizon for selected future date.
    final forecastDays = (dayDiff + 1).clamp(2, 16);

    final payload = await _loadOpenMeteoPayload(
      lat: lat,
      lon: lon,
      forecastDays: forecastDays,
    );
    if (payload == null) return {};
    return hourlyFromPayload(
      payload,
      pvCapacityW: pvCapacityW,
      now: now,
      targetDate: targetDate,
    );
  }

  Future<List<DailySolarForecast>> fetchDailyForecast({
    required double lat,
    required double lon,
    required double pvCapacityW,
    int daysAhead = 4,
  }) async {
    final cacheKey =
        'daily|${lat.toStringAsFixed(3)}|${lon.toStringAsFixed(3)}|'
        '${pvCapacityW.toStringAsFixed(0)}|${daysAhead.clamp(2, 16)}';

    final cached = _dailyForecastCache[cacheKey];
    if (cached != null &&
        DateTime.now().difference(cached.createdAt) < _dailyForecastMemoryTtl) {
      _dailyCacheHits++;
      return List<DailySolarForecast>.from(cached.data);
    }
    _dailyCacheMisses++;

    final inFlight = _dailyForecastInFlight[cacheKey];
    if (inFlight != null) {
      _dailyInFlightJoins++;
      final result = await inFlight;
      return List<DailySolarForecast>.from(result);
    }

    final future = _computeDailyForecast(
      lat: lat,
      lon: lon,
      pvCapacityW: pvCapacityW,
      daysAhead: daysAhead,
    );
    _dailyForecastInFlight[cacheKey] = future;
    final sw = Stopwatch()..start();

    try {
      final result = await future;
      _recordDailyDuration(sw.elapsedMilliseconds);
      _dailyForecastCache[cacheKey] =
          _MemoryCacheEntry<List<DailySolarForecast>>(
        data: List<DailySolarForecast>.from(result),
        createdAt: DateTime.now(),
      );
      _pruneCache(_dailyForecastCache);
      return List<DailySolarForecast>.from(result);
    } finally {
      _dailyForecastInFlight.remove(cacheKey);
    }
  }

  Future<List<DailySolarForecast>> _computeDailyForecast({
    required double lat,
    required double lon,
    required double pvCapacityW,
    required int daysAhead,
  }) async {
    final forecastDays = daysAhead.clamp(2, 16);
    final payload = await _loadOpenMeteoPayload(
      lat: lat,
      lon: lon,
      forecastDays: forecastDays,
    );
    if (payload == null) return const [];
    return dailyFromPayload(
      payload,
      pvCapacityW: pvCapacityW,
      now: DateTime.now(),
      days: forecastDays,
    );
  }

  /// Daily PV energy from an Open-Meteo payload, today and the next
  /// [days] - 1 days. Each hourly value is the mean power of that hour, so
  /// the hourly watts sum to watt-hours.
  @visibleForTesting
  static List<DailySolarForecast> dailyFromPayload(
    Map<String, dynamic> payload, {
    required double pvCapacityW,
    required DateTime now,
    required int days,
  }) {
    final times = (payload['hourly']['time'] as List).cast<String>();
    final List<dynamic> radiationList =
        payload['hourly']['shortwave_radiation'];

    final startDay = DateTime(now.year, now.month, now.day);
    final endDay = startDay.add(Duration(days: days - 1));
    final daily = <DateTime, double>{};

    for (var i = 0; i < times.length && i < radiationList.length; i++) {
      // The value stamped HH:00 covers the hour before it.
      final mid = DateTime.parse(times[i]).subtract(_halfHour);
      final day = DateTime(mid.year, mid.month, mid.day);
      if (day.isBefore(startDay) || day.isAfter(endDay)) continue;
      final ghi = _toDoubleOrNull(radiationList[i]) ?? 0;
      daily[day] = (daily[day] ?? 0) + pvWatts(ghi, pvCapacityW);
    }

    // Daily weather code by local date ("2026-11-06" -> 61).
    final codeByDay = <DateTime, int>{};
    final dailyPayload = payload['daily'];
    if (dailyPayload is Map) {
      final dayList = (dailyPayload['time'] as List?) ?? const [];
      final codes = (dailyPayload['weather_code'] as List?) ?? const [];
      for (var i = 0; i < dayList.length && i < codes.length; i++) {
        final d = DateTime.tryParse(dayList[i].toString());
        final c = codes[i];
        if (d != null && c is num) {
          codeByDay[DateTime(d.year, d.month, d.day)] = c.toInt();
        }
      }
    }

    return [
      for (final e in daily.entries)
        DailySolarForecast(
          date: e.key,
          energyWh: e.value,
          weatherCode: codeByDay[e.key],
        ),
    ]..sort((a, b) => a.date.compareTo(b.date));
  }

  /// Hourly PV power keyed at the middle of each hour ("yyyy-MM-dd HH:30"),
  /// for [targetDate] or, when null, from now on.
  @visibleForTesting
  static Map<String, double> hourlyFromPayload(
    Map<String, dynamic> payload, {
    required double pvCapacityW,
    required DateTime now,
    DateTime? targetDate,
  }) {
    final times = (payload['hourly']['time'] as List).cast<String>();
    final List<dynamic> radiationList =
        payload['hourly']['shortwave_radiation'];
    final formatter = DateFormat('yyyy-MM-dd HH:mm');
    final forecast = <String, double>{};

    for (var i = 0; i < times.length && i < radiationList.length; i++) {
      final end = DateTime.parse(times[i]);
      // Skip hours already over; the current hour is still a forecast.
      if (!end.isAfter(now)) continue;
      // The value stamped HH:00 is the mean of the hour before it.
      final mid = end.subtract(_halfHour);
      if (targetDate != null &&
          (mid.year != targetDate.year ||
              mid.month != targetDate.month ||
              mid.day != targetDate.day)) {
        continue;
      }
      final ghi = _toDoubleOrNull(radiationList[i]);
      if (ghi == null || ghi <= 0) continue;
      forecast[formatter.format(mid)] = pvWatts(ghi, pvCapacityW);
    }
    return forecast;
  }

  static const Duration _halfHour = Duration(minutes: 30);

  String _targetDayKey(DateTime? day) {
    if (day == null) return 'future';
    return '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
  }

  void _pruneCache<T>(Map<String, _MemoryCacheEntry<T>> cache) {
    if (cache.length <= _maxMemoryCacheEntries) return;
    final overflow = cache.length - _maxMemoryCacheEntries;
    final keysToRemove = cache.keys.take(overflow).toList(growable: false);
    for (final key in keysToRemove) {
      cache.remove(key);
    }
  }

  void _recordLocalDuration(int ms) {
    _localRequests++;
    _localAvgMs = _rollingAvg(_localAvgMs, _localRequests, ms.toDouble());
  }

  void _recordDailyDuration(int ms) {
    _dailyRequests++;
    _dailyAvgMs = _rollingAvg(_dailyAvgMs, _dailyRequests, ms.toDouble());
  }

  double _rollingAvg(double currentAvg, int count, double next) {
    if (count <= 1) return next;
    return currentAvg + ((next - currentAvg) / count);
  }

  WeatherPerformanceSnapshot getPerformanceSnapshot() {
    return WeatherPerformanceSnapshot(
      localCacheHits: _localCacheHits,
      localCacheMisses: _localCacheMisses,
      localInFlightJoins: _localInFlightJoins,
      dailyCacheHits: _dailyCacheHits,
      dailyCacheMisses: _dailyCacheMisses,
      dailyInFlightJoins: _dailyInFlightJoins,
      localRequests: _localRequests,
      dailyRequests: _dailyRequests,
      localAvgMs: _localAvgMs.round(),
      dailyAvgMs: _dailyAvgMs.round(),
    );
  }
}
