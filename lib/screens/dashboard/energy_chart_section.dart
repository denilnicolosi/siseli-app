part of 'dashboard_tab.dart';

class _EnergyChartSection extends StatefulWidget {
  final AppStateProvider provider;

  const _EnergyChartSection({required this.provider});

  @override
  State<_EnergyChartSection> createState() => _EnergyChartSectionState();
}

class _EnergyChartSectionState extends State<_EnergyChartSection> {
  static const Color _forecastSeriesColor = Color(0xFF38BDF8);

  int _selectedRange = 0;
  DateTime _currentDate = DateTime.now();
  bool _showProduction = true;
  bool _showConsumption = true;
  bool _showBattery = true;
  bool _showGrid = false;
  bool _showForecast = true;

  bool _isLoading = true;
  bool _isBackgroundRefreshing = false;
  List<FlSpot> _productionData = [];
  List<FlSpot> _consumptionData = [];
  List<FlSpot> _batteryData = [];
  List<FlSpot> _gridData = [];
  List<FlSpot> _forecastData = [];
  List<FlSpot> _socData = [];
  List<FlSpot> _batteryInData = [];
  List<FlSpot> _batteryOutData = [];
  Timer? _chartDebounce;
  Timer? _autoRefreshTimer;
  int _chartRequestSeq = 0;
  String? _lastRenderLogSignature;
  DateTime? _lastChartRefreshedAt;
  List<DailySolarForecast> _multiDayForecast = const [];
  bool _isDailyForecastLoading = true;

  static const Duration _autoRefreshInterval = Duration(minutes: 5);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scheduleFetchChartData(immediate: true));
    _autoRefreshTimer = Timer.periodic(_autoRefreshInterval, (_) {
      _maybeAutoRefresh();
    });
  }

  @override
  void dispose() {
    _chartDebounce?.cancel();
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  /// Silently refreshes chart only when viewing today in day mode.
  void _maybeAutoRefresh() {
    if (!mounted) return;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final viewing =
        DateTime(_currentDate.year, _currentDate.month, _currentDate.day);
    if (_selectedRange == 0 && viewing == today) {
      _fetchChartData(background: true);
    }
  }

  void _scheduleFetchChartData({bool immediate = false}) {
    _chartDebounce?.cancel();
    if (immediate) {
      _fetchChartData();
      return;
    }
    _chartDebounce = Timer(const Duration(milliseconds: 350), _fetchChartData);
  }

  void _startRangeLoadingState() {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _isBackgroundRefreshing = false;
      _productionData = [];
      _consumptionData = [];
      _batteryData = [];
      _gridData = [];
      _forecastData = [];
      _socData = [];
      _batteryInData = [];
      _batteryOutData = [];
    });
    LogService.log(
        '[chart] reset before fetch: range=$_selectedRange, date=${_currentDate.toIso8601String().substring(0, 10)}');
  }

  Future<void> _fetchChartData({bool background = false}) async {
    final requestId = ++_chartRequestSeq;
    final totalSw = Stopwatch()..start();
    LogService.log(
        '[chart] fetch start: requestId=$requestId, range=$_selectedRange, date=${_currentDate.toIso8601String().substring(0, 10)}, bg=$background');
    if (!background) {
      if (mounted && !_isLoading) setState(() => _isLoading = true);
    } else {
      if (mounted) setState(() => _isBackgroundRefreshing = true);
    }

    try {
      final chartSw = Stopwatch()..start();
      final chartFuture = widget.provider.service
          .getChartData(_selectedRange, _currentDate)
          .whenComplete(chartSw.stop);
      final dailySw = Stopwatch()..start();
      final dailyForecastFuture = widget.provider.weatherService
          .fetchDailyForecast(
            lat: widget.provider.siteLatitude,
            lon: widget.provider.siteLongitude,
            pvCapacityW: widget.provider.pvTotalCapacityW,
            efficiency: 0.85,
            historicalPvData: widget.provider.historicalPvData,
            daysAhead: 16,
          )
          .whenComplete(dailySw.stop);
      final daySw = Stopwatch()..start();
      final dayForecastFuture = (_selectedRange == 0
              ? widget.provider.weatherService.fetchLocalForecast(
                  lat: widget.provider.siteLatitude,
                  lon: widget.provider.siteLongitude,
                  pvCapacityW: widget.provider.pvTotalCapacityW,
                  efficiency: 0.85,
                  historicalPvData: widget.provider.historicalPvData,
                  targetDate: _currentDate,
                )
              : Future<Map<String, double>>.value(const <String, double>{}))
          .whenComplete(daySw.stop);

      final data = await chartFuture;
      final dailyForecast = await dailyForecastFuture;
      final forecast = await dayForecastFuture;

      if (!mounted || requestId != _chartRequestSeq) {
        LogService.log(
            '[chart] stale response ignored: requestId=$requestId, active=$_chartRequestSeq');
        return;
      }

      if (mounted) {
        final forecastSpots = _selectedRange == 0
            ? buildDayForecastSpots(forecast)
            : buildRangeForecastSpots(dailyForecast);

        setState(() {
          _productionData = normalizeSpots(data['pv'] ?? []);
          _consumptionData = normalizeSpots(data['load'] ?? []);
          _batteryData = normalizeSpots(data['battery'] ?? []);
          _gridData = normalizeSpots(data['grid'] ?? []);
          _socData = normalizeSpots(data['soc'] ?? []);
          _batteryInData = normalizeSpots(data['batteryIn'] ?? []);
          _batteryOutData = normalizeSpots(data['batteryOut'] ?? []);
          _forecastData = forecastSpots;
          _isLoading = false;
          _isBackgroundRefreshing = false;
          _lastChartRefreshedAt = DateTime.now();
          _multiDayForecast = dailyForecast;
          _isDailyForecastLoading = false;
        });

        logChartUiSummary('chart.ui fetched');
        totalSw.stop();
        LogService.log(
            '[chart] timing requestId=$requestId total=${totalSw.elapsedMilliseconds}ms '
            'chart=${chartSw.elapsedMilliseconds}ms daily=${dailySw.elapsedMilliseconds}ms '
            'day=${daySw.elapsedMilliseconds}ms');
      }
    } catch (e, stack) {
      totalSw.stop();
      LogService.log('[chart] fetch failed', error: e, stack: stack);
      if (!mounted || requestId != _chartRequestSeq) return;
      setState(() {
        _isLoading = false;
        _isBackgroundRefreshing = false;
        _isDailyForecastLoading = false;
      });
    }
  }

  List<FlSpot> buildRangeForecastSpots(List<DailySolarForecast> forecast) {
    if (forecast.isEmpty) return const [];

    if (_selectedRange == 1) {
      final weekStart = startOfWeek(_currentDate);
      final weekEnd = weekStart.add(const Duration(days: 6));
      return normalizeSpots(
        forecast.where((item) {
          final day = DateTime(item.date.year, item.date.month, item.date.day);
          return !day.isBefore(weekStart) && !day.isAfter(weekEnd);
        }).map((item) {
          final day = DateTime(item.date.year, item.date.month, item.date.day);
          return FlSpot(
              day.difference(weekStart).inDays.toDouble(), item.energyWh);
        }).toList(),
      );
    }

    if (_selectedRange == 2) {
      return normalizeSpots(
        forecast
            .where((item) =>
                item.date.year == _currentDate.year &&
                item.date.month == _currentDate.month)
            .map((item) => FlSpot(item.date.day.toDouble(), item.energyWh))
            .toList(),
      );
    }

    return const [];
  }

  List<FlSpot> buildDayForecastSpots(Map<String, double> forecast) {
    var spots = <FlSpot>[];
    var todayPrefix =
        "${_currentDate.year}-${_currentDate.month.toString().padLeft(2, '0')}-${_currentDate.day.toString().padLeft(2, '0')}";

    forecast.forEach((timeStr, value) {
      if (timeStr.startsWith(todayPrefix)) {
        final timeParts = timeStr.split(' ');
        if (timeParts.length > 1) {
          final hourStr = timeParts[1].split(':')[0];
          final minStr = timeParts[1].split(':')[1];
          final hour = double.tryParse(hourStr) ?? 0.0;
          final min = double.tryParse(minStr) ?? 0.0;
          final hourDouble = hour + min / 60.0;
          spots.add(FlSpot(hourDouble, value));
        }
      }
    });
    return normalizeSpots(spots);
  }

  List<FlSpot> normalizeSpots(List<FlSpot> raw) {
    final filtered = raw
        .where((s) => s.x.isFinite && s.y.isFinite)
        .map((s) => FlSpot(s.x, s.y))
        .toList();
    if (filtered.length < 2) return filtered;

    filtered.sort((a, b) => a.x.compareTo(b.x));

    // Merge duplicate/near-duplicate X values to avoid vertical segments that
    // can make cubic interpolation fold back into loops.
    const eps = 0.001;
    final merged = <FlSpot>[];
    for (final spot in filtered) {
      if (merged.isEmpty || (spot.x - merged.last.x).abs() > eps) {
        merged.add(spot);
      } else {
        merged[merged.length - 1] =
            FlSpot(merged.last.x, (merged.last.y + spot.y) / 2);
      }
    }
    return merged;
  }

  void changeDate(int offset) {
    setState(() {
      if (_selectedRange == 0) {
        _currentDate = _currentDate.add(Duration(days: offset));
      } else if (_selectedRange == 1) {
        _currentDate = _currentDate.add(Duration(days: 7 * offset));
      } else {
        _currentDate = DateTime(
            _currentDate.year, _currentDate.month + offset, _currentDate.day);
      }
    });
    _startRangeLoadingState();
    _scheduleFetchChartData();
  }

  String getDateText() {
    if (_selectedRange == 0) {
      final weekday = formatBottomAxisLabelForWeekday(_currentDate.weekday);
      return '$weekday ${_currentDate.day.toString().padLeft(2, '0')}.${_currentDate.month.toString().padLeft(2, '0')}.${_currentDate.year}';
    } else if (_selectedRange == 1) {
      final start = startOfWeek(_currentDate);
      final end = start.add(const Duration(days: 6));
      return '${start.day.toString().padLeft(2, '0')}.${start.month.toString().padLeft(2, '0')} - ${end.day.toString().padLeft(2, '0')}.${end.month.toString().padLeft(2, '0')}';
    } else {
      return '${_currentDate.month.toString().padLeft(2, '0')}.${_currentDate.year}';
    }
  }

  /// Short weekday name ("Lun"...) for DateTime.weekday (1 = Monday).
  String formatBottomAxisLabelForWeekday(int weekday) => formatBottomAxisLabel(
      (weekday - 1).toDouble(), AppLocalizations.of(context)!,
      forceWeek: true);

  DateTime startOfWeek(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return normalized.subtract(Duration(days: normalized.weekday - 1));
  }

  double? futureStartX0() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_selectedRange == 0) {
      final currentDay =
          DateTime(_currentDate.year, _currentDate.month, _currentDate.day);
      if (currentDay != today) return null;
      final x = now.hour + (now.minute / 60.0);
      return x >= 23 ? null : x;
    }

    if (_selectedRange == 1) {
      final weekStart = startOfWeek(_currentDate);
      final thisWeekStart = startOfWeek(today);
      if (weekStart != thisWeekStart) return null;
      final dayIndex = now.weekday - 1;
      final futureStart = dayIndex + 1.0;
      return futureStart > 6 ? null : futureStart;
    }

    final sameMonth =
        _currentDate.year == now.year && _currentDate.month == now.month;
    if (!sameMonth) return null;
    final lastDay = DateTime(now.year, now.month + 1, 0).day;
    final futureStart = now.day + 1.0;
    return futureStart > lastDay ? null : futureStart;
  }

  Future<void> _openFullscreen() {
    return Navigator.of(context).push<void>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => _EnergyChartFullscreenPage(
          title:
              '${AppLocalizations.of(context)!.energyOverview} · ${getDateText()}',
          legendBuilder: (onChanged) =>
              buildLegend(AppLocalizations.of(context)!, onChanged: onChanged),
          chartBuilder: buildChart,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final expressive = context.expressive;
    final isCompact = MediaQuery.sizeOf(context).width < 600;

    final refreshButton = IconButton(
      visualDensity: VisualDensity.compact,
      onPressed: _isBackgroundRefreshing
          ? null
          : () => _fetchChartData(background: true),
      tooltip: l10n.refreshChart,
      icon: _isBackgroundRefreshing
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.colorScheme.primary,
              ),
            )
          : const Icon(Icons.refresh_rounded, size: 20),
    );

    return AppCard(
      borderRadius: expressive.cornerLarge,
      enableBlur: false,
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding:
            EdgeInsets.all(isCompact ? AppTheme.spacingM : AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.insights_rounded,
                    size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: AppTheme.spacingS),
                Expanded(
                  child: Text(
                    l10n.energyOverview,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                if (_lastChartRefreshedAt != null && !isCompact)
                  _ChartRefreshBadge(
                    refreshedAt: _lastChartRefreshedAt!,
                    isRefreshing: _isBackgroundRefreshing,
                  ),
                refreshButton,
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: _isLoading ? null : _openFullscreen,
                  tooltip: l10n.chartFullscreen,
                  icon: const Icon(Icons.open_in_full_rounded, size: 20),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingS),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: AppTheme.spacingS,
                runSpacing: AppTheme.spacingS,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  buildTimeSelector(l10n),
                  buildDateNavigator(),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),
            buildLegend(l10n),
            const SizedBox(height: AppTheme.spacingS),
            AppCard(
              borderRadius: expressive.cornerMedium,
              enableBlur: false,
              backgroundColor: theme.colorScheme.surface,
              padding: EdgeInsets.zero,
              child: SizedBox(
                height: isCompact ? 210 : 300,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppTheme.spacingXS,
                    AppTheme.spacingM,
                    AppTheme.spacingM,
                    AppTheme.spacingXS,
                  ),
                  child: ExcludeSemantics(
                    child: RepaintBoundary(
                      child: _isLoading
                          ? const _ChartSkeleton()
                          : buildChart(context),
                    ),
                  ),
                ),
              ),
            ),
            if (!_isLoading) ...[
              const SizedBox(height: AppTheme.spacingS),
              buildTotals(context, l10n),
            ],
            if (_selectedRange == 0 || _showBattery) ...[
              const SizedBox(height: AppTheme.spacingXS),
              buildBatterySignHint(context),
            ],
            if (_showSocChart) ...[
              const SizedBox(height: AppTheme.spacingS),
              buildSocChart(context, l10n),
            ],
            const SizedBox(height: AppTheme.spacingM),
            buildMultiDayForecast(context, l10n),
          ],
        ),
      ),
    );
  }

  EnergyTotals get _totals => _selectedRange == 0
      ? EnergyTotals.fromPower(
          pv: _productionData,
          load: _consumptionData,
          battery: _batteryData,
          acIn: _gridData,
        )
      : EnergyTotals.fromDaily(
          pv: _productionData,
          load: _consumptionData,
          batteryIn: _batteryInData,
          batteryOut: _batteryOutData,
          acIn: _gridData,
        );

  Widget buildTotals(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final totals = _totals;
    final items = [
      (l10n.production, totals.pvWh, AppTheme.pvColor, Icons.wb_sunny_rounded),
      (l10n.consumption, totals.loadWh, AppTheme.loadColor, Icons.home_rounded),
      (
        l10n.batteryChargedTotal,
        totals.batteryInWh,
        AppTheme.batteryColor,
        Icons.battery_charging_full_rounded
      ),
      (
        l10n.batteryDischargedTotal,
        totals.batteryOutWh,
        AppTheme.batteryColor,
        Icons.battery_3_bar_rounded
      ),
      (
        l10n.acInput,
        totals.acInWh,
        AppTheme.gridColor,
        Icons.electrical_services_rounded
      ),
    ];
    return LayoutBuilder(builder: (context, constraints) {
      const spacing = AppTheme.spacingXS;
      final columns = constraints.maxWidth >= 700 ? 5 : 2;
      final width = (constraints.maxWidth - (columns - 1) * spacing) / columns;
      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [
          for (final (label, wh, color, icon) in items)
            Container(
              width: width,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingS,
                vertical: AppTheme.spacingXS,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHigh,
                borderRadius:
                    BorderRadius.circular(context.expressive.cornerSmall),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 14, color: color),
                      const SizedBox(width: AppTheme.spacingXS),
                      Expanded(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    wh == null ? '--' : Formatters.formatEnergy(wh),
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
        ],
      );
    });
  }

  /// Day view with only the battery series on: add the SOC % trend below.
  bool get _showSocChart =>
      _selectedRange == 0 &&
      !_isLoading &&
      _showBattery &&
      !_showProduction &&
      !_showConsumption &&
      !_showGrid;

  ({List<FlSpot> spots, DateTime depletionAt})? _buildSocForecast() {
    final now = DateTime.now();
    final selectedDay =
        DateTime(_currentDate.year, _currentDate.month, _currentDate.day);
    final today = DateTime(now.year, now.month, now.day);
    if (selectedDay != today || _socData.length < 2) return null;

    final lastSoc = _socData.last;
    final soc = lastSoc.y;
    final targetSoc = AppStateProvider.lowBatteryNotifySoc;
    if (soc <= targetSoc) return null;

    final recentSocPoints =
        _socData.where((spot) => spot.x >= lastSoc.x - 6).toList();
    if (recentSocPoints.length < 3) return null;

    // Fit the net SOC trend over all recent readings. Averaging only the
    // downward steps overweights telemetry noise and makes the estimate too
    // pessimistic when the battery briefly rebounds between samples.
    final meanX =
        recentSocPoints.map((spot) => spot.x).reduce((a, b) => a + b) /
            recentSocPoints.length;
    final meanY =
        recentSocPoints.map((spot) => spot.y).reduce((a, b) => a + b) /
            recentSocPoints.length;
    var covariance = 0.0;
    var variance = 0.0;
    for (final spot in recentSocPoints) {
      final dx = spot.x - meanX;
      covariance += dx * (spot.y - meanY);
      variance += dx * dx;
    }
    if (variance <= 0) return null;
    final socSlopePerHour = covariance / variance;
    if (socSlopePerHour >= -0.1) return null;
    final socDropPerHour = -socSlopePerHour;

    final hoursToThreshold = (soc - targetSoc) / socDropPerHour;
    final depletionAt = selectedDay.add(Duration(
      minutes: ((lastSoc.x + hoursToThreshold) * 60).round(),
    ));
    // Not clamp(lastSoc.x, 23): after 23:00 the lower bound exceeds the
    // upper one, clamp throws and the whole chart section failed to build.
    final rawEndX = lastSoc.x + hoursToThreshold;
    final endX = rawEndX < 23.0 ? rawEndX : 23.0;
    final endSoc = soc - (endX - lastSoc.x) * socDropPerHour;

    return (
      // No room left on the 0-23 h axis: keep the text, skip the line.
      spots: endX > lastSoc.x
          ? [FlSpot(lastSoc.x, soc), FlSpot(endX, endSoc)]
          : const <FlSpot>[],
      depletionAt: depletionAt,
    );
  }

  Widget buildSocChart(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.labelSmall
        ?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final socForecast = _buildSocForecast();
    final forecastTime = socForecast == null
        ? null
        : '${socForecast.depletionAt.hour.toString().padLeft(2, '0')}:${socForecast.depletionAt.minute.toString().padLeft(2, '0')}';
    final forecastDate = socForecast == null
        ? null
        : '${socForecast.depletionAt.day.toString().padLeft(2, '0')}.${socForecast.depletionAt.month.toString().padLeft(2, '0')}.${socForecast.depletionAt.year}';
    return AppCard(
      borderRadius: context.expressive.cornerMedium,
      enableBlur: false,
      backgroundColor: theme.colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(
        AppTheme.spacingXS,
        AppTheme.spacingS,
        AppTheme.spacingM,
        AppTheme.spacingXS,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: AppTheme.spacingS),
            child: Row(
              children: [
                const Icon(Icons.battery_charging_full_rounded,
                    size: 16, color: AppTheme.batteryColor),
                const SizedBox(width: AppTheme.spacingXS),
                Expanded(
                  child: Text(l10n.socDayChartTitle,
                      style: theme.textTheme.labelLarge),
                ),
                if (_socData.isNotEmpty) ...[
                  const SizedBox(width: AppTheme.spacingS),
                  Text(
                    '${_socData.last.y.toStringAsFixed(0)}%',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.batteryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          SizedBox(
            height: 140,
            child: _socData.length < 2
                ? Center(child: Text(l10n.socHistoryNoData, style: labelStyle))
                : LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: 23,
                      minY: 0,
                      maxY: 100,
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          fitInsideHorizontally: true,
                          fitInsideVertically: true,
                          getTooltipItems: (spots) => spots
                              .map((s) => LineTooltipItem(
                                    '${formatBottomAxisLabel(s.x, l10n)}  ${s.y.toStringAsFixed(0)}%',
                                    theme.textTheme.labelSmall!,
                                  ))
                              .toList(),
                        ),
                      ),
                      gridData: FlGridData(
                        drawVerticalLine: false,
                        horizontalInterval: 25,
                        getDrawingHorizontalLine: (_) => FlLine(
                          color: theme.colorScheme.outlineVariant
                              .withValues(alpha: 0.4),
                          strokeWidth: 1,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(),
                        rightTitles: const AxisTitles(),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: 25,
                            getTitlesWidget: (value, meta) => SideTitleWidget(
                              meta: meta,
                              child:
                                  Text('${value.toInt()}%', style: labelStyle),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 4,
                            getTitlesWidget: (value, meta) {
                              // Skip the forced 23:00 label next to 20:00.
                              if (value == meta.max) {
                                return const SizedBox.shrink();
                              }
                              return SideTitleWidget(
                                meta: meta,
                                child: Text(formatBottomAxisLabel(value, l10n),
                                    style: labelStyle),
                              );
                            },
                          ),
                        ),
                      ),
                      extraLinesData: ExtraLinesData(horizontalLines: [
                        HorizontalLine(
                          y: AppStateProvider.lowBatteryNotifySoc,
                          color:
                              const Color(0xFFEF4444).withValues(alpha: 0.55),
                          strokeWidth: 1,
                          dashArray: [6, 4],
                        ),
                      ]),
                      lineBarsData: [
                        LineChartBarData(
                          spots: _socData,
                          color: AppTheme.batteryColor,
                          barWidth: 2,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color:
                                AppTheme.batteryColor.withValues(alpha: 0.15),
                          ),
                        ),
                        if (socForecast != null && socForecast.spots.isNotEmpty)
                          LineChartBarData(
                            spots: socForecast.spots,
                            color: AppTheme.batteryColor.withValues(alpha: 0.8),
                            barWidth: 2,
                            dashArray: [6, 4],
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                          ),
                      ],
                    ),
                  ),
          ),
          if (socForecast != null) ...[
            const SizedBox(height: AppTheme.spacingXS),
            Padding(
              padding: const EdgeInsets.only(left: AppTheme.spacingS),
              child: Text(
                l10n.batteryDurationForecast(forecastTime!, forecastDate!),
                style: labelStyle,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildMultiDayForecast(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final expressive = context.expressive;
    if (_isDailyForecastLoading && _multiDayForecast.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }
    if (_multiDayForecast.isEmpty) {
      return AppEmptyState(
        title: l10n.forecastNextDays,
        message: l10n.forecastUnavailable,
        icon: Icons.wb_cloudy_outlined,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.wb_sunny_rounded,
                size: 18, color: theme.colorScheme.tertiary),
            const SizedBox(width: AppTheme.spacingS),
            Expanded(
              child: Text(
                l10n.forecastNextDays,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2, bottom: AppTheme.spacingS),
          child: Text(
            l10n.forecastBasis(
                (widget.provider.pvTotalCapacityW / 1000).toStringAsFixed(1)),
            style: theme.textTheme.labelSmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = AppTheme.spacingS;
            final width = constraints.maxWidth;
            final columns = width >= 980
                ? 4
                : width >= 600
                    ? 3
                    : 2;
            final cardWidth = (width - (columns - 1) * spacing) / columns;
            final previewDays =
                _multiDayForecast.take(columns == 4 ? 8 : 6).toList();

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                for (final day in previewDays)
                  SizedBox(
                    width: cardWidth,
                    child: AppCard(
                      borderRadius: expressive.cornerMedium,
                      padding: const EdgeInsets.all(AppTheme.spacingS),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dayLabel(day.date, l10n),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            Formatters.formatEnergy(day.energyWh),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${l10n.forecastPeak}: ${Formatters.formatPower(day.peakPowerW)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  String dayLabel(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final current = DateTime(date.year, date.month, date.day);
    if (current == today) return l10n.today;
    const weekKeys = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
    final key = weekKeys[current.weekday - 1];
    final weekLabel = weekLabel0(key, l10n);
    return '$weekLabel ${current.day.toString().padLeft(2, '0')}.${current.month.toString().padLeft(2, '0')}';
  }

  String weekLabel0(String key, AppLocalizations l10n) {
    switch (key) {
      case 'mon':
        return l10n.mon;
      case 'tue':
        return l10n.tue;
      case 'wed':
        return l10n.wed;
      case 'thu':
        return l10n.thu;
      case 'fri':
        return l10n.fri;
      case 'sat':
        return l10n.sat;
      case 'sun':
        return l10n.sun;
      default:
        return '';
    }
  }

  Widget buildTimeSelector(AppLocalizations l10n) {
    final expressive = context.expressive;
    return SegmentedButton<int>(
      showSelectedIcon: false,
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(expressive.cornerMedium),
          ),
        ),
      ),
      segments: [
        ButtonSegment<int>(value: 0, label: Text(l10n.day)),
        ButtonSegment<int>(value: 1, label: Text(l10n.week)),
        ButtonSegment<int>(value: 2, label: Text(l10n.month)),
      ],
      selected: {_selectedRange},
      onSelectionChanged: (selected) {
        final next = selected.first;
        if (next == _selectedRange) return;
        setState(() => _selectedRange = next);
        _startRangeLoadingState();
        _scheduleFetchChartData();
      },
    );
  }

  Widget buildDateNavigator() {
    final theme = Theme.of(context);
    final expressive = context.expressive;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final forecastLimit = today.add(const Duration(days: 16));
    final currentDay =
        DateTime(_currentDate.year, _currentDate.month, _currentDate.day);
    final currentMonth = DateTime(_currentDate.year, _currentDate.month);
    final maxMonth = DateTime(forecastLimit.year, forecastLimit.month);
    final currentWeek = startOfWeek(_currentDate);
    final maxWeek = startOfWeek(forecastLimit);

    final canGoForward = _selectedRange == 0
        ? currentDay.isBefore(forecastLimit)
        : _selectedRange == 1
            ? currentWeek.isBefore(maxWeek)
            : currentMonth.isBefore(maxMonth);

    return AppCard(
      borderRadius: expressive.cornerMedium,
      enableBlur: false,
      backgroundColor: theme.colorScheme.surfaceContainerHigh,
      padding: EdgeInsets.zero,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.chevron_left),
            onPressed: () => changeDate(-1),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 96),
            child: Text(
              getDateText(),
              style: theme.textTheme.labelLarge,
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.chevron_right),
            onPressed: canGoForward ? () => changeDate(1) : null,
          ),
        ],
      ),
    );
  }

  /// [onChanged] lets the fullscreen route repaint after a series toggle.
  Widget buildLegend(AppLocalizations l10n, {VoidCallback? onChanged}) {
    void toggle(VoidCallback flip) {
      setState(flip);
      onChanged?.call();
    }

    return Wrap(
      spacing: AppTheme.spacingXS,
      runSpacing: AppTheme.spacingXS,
      children: [
        _buildLegendChip(
          label: l10n.production,
          color: AppTheme.pvColor,
          icon: Icons.wb_sunny_rounded,
          isActive: _showProduction,
          onTap: () => toggle(() => _showProduction = !_showProduction),
        ),
        _buildLegendChip(
          label: l10n.consumption,
          color: AppTheme.loadColor,
          icon: Icons.home_rounded,
          isActive: _showConsumption,
          onTap: () => toggle(() => _showConsumption = !_showConsumption),
        ),
        _buildLegendChip(
          label: l10n.battery,
          color: AppTheme.batteryColor,
          icon: Icons.battery_charging_full_rounded,
          isActive: _showBattery,
          onTap: () => toggle(() => _showBattery = !_showBattery),
        ),
        _buildLegendChip(
          label: l10n.acInput,
          color: AppTheme.gridColor,
          icon: Icons.electrical_services_rounded,
          isActive: _showGrid,
          onTap: () => toggle(() => _showGrid = !_showGrid),
        ),
        _buildLegendChip(
          label: l10n.forecast,
          color: _forecastSeriesColor,
          icon: Icons.cloud_queue_rounded,
          isActive: _showForecast && _forecastData.isNotEmpty,
          onTap: _forecastData.isNotEmpty
              ? () => toggle(() => _showForecast = !_showForecast)
              : null,
        ),
      ],
    );
  }

  Widget _buildLegendChip({
    required String label,
    required Color color,
    required IconData icon,
    required bool isActive,
    required VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return FilterChip(
      selected: isActive,
      onSelected: onTap == null ? null : (_) => onTap(),
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      labelPadding: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      avatar: Icon(
        icon,
        size: 14,
        color: isActive ? color : color.withValues(alpha: 0.54),
      ),
      label: Text(label),
      labelStyle: theme.textTheme.labelSmall?.copyWith(
        color: isActive
            ? theme.colorScheme.onSurface
            : theme.colorScheme.onSurfaceVariant,
      ),
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      selectedColor: theme.colorScheme.secondaryContainer,
      side: BorderSide(
        color: isActive
            ? theme.colorScheme.secondary
            : theme.colorScheme.outlineVariant,
      ),
      showCheckmark: false,
      elevation: 0,
      pressElevation: 0,
    );
  }

  Widget buildBatterySignHint(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      AppLocalizations.of(context)!.batterySignHint,
      style: theme.textTheme.labelSmall
          ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
    );
  }

  Widget buildChart(BuildContext context) {
    final minX = getMinX();
    final maxX = getMaxX();
    final futureStartX = futureStartX0();

    final visibleSpots = getVisibleSpots();
    final minY = getMinY(visibleSpots);
    final maxY = getMaxY(visibleSpots);
    final renderSignature =
        '$_selectedRange|${minX.toStringAsFixed(2)}|${maxX.toStringAsFixed(2)}|${minY.toStringAsFixed(1)}|${maxY.toStringAsFixed(1)}|${visibleSpots.length}';
    if (_lastRenderLogSignature != renderSignature) {
      _lastRenderLogSignature = renderSignature;
      LogService.log(
          '[chart] render: range=$_selectedRange, x=${minX.toStringAsFixed(2)}..${maxX.toStringAsFixed(2)}, y=${minY.toStringAsFixed(1)}..${maxY.toStringAsFixed(1)}, visible=${visibleSpots.length}');
    }

    if (_selectedRange != 0) {
      return buildBarChart(context, minX, maxX, minY, maxY, futureStartX);
    }

    var lines = <LineChartBarData>[];

    if (_showProduction && _productionData.isNotEmpty) {
      lines.add(buildLineData(
        _productionData,
        AppTheme.pvColor,
        isCurved: _selectedRange == 0,
      ));
    }
    if (_showConsumption && _consumptionData.isNotEmpty) {
      lines.add(buildLineData(
        _consumptionData,
        AppTheme.loadColor,
        isCurved: _selectedRange == 0,
      ));
    }
    if (_showBattery && _batteryData.isNotEmpty) {
      lines.add(buildLineData(
        _batteryData,
        AppTheme.batteryColor,
        isCurved: _selectedRange == 0,
      ));
    }
    if (_showGrid && _gridData.isNotEmpty) {
      lines.add(buildLineData(
        _gridData,
        AppTheme.gridColor,
        isCurved: _selectedRange == 0,
      ));
    }

    if (_showForecast && _forecastData.isNotEmpty && _selectedRange == 0) {
      lines.add(LineChartBarData(
        spots: normalizeSpots(_forecastData),
        isCurved: true,
        curveSmoothness: 0.18,
        preventCurveOverShooting: true,
        preventCurveOvershootingThreshold: 8,
        color: _forecastSeriesColor.withValues(alpha: 0.8),
        barWidth: 2,
        dotData: const FlDotData(show: false),
        dashArray: [5, 5],
        belowBarData: BarAreaData(show: false),
      ));
    }

    if (lines.isEmpty) {
      return AppEmptyState(
        title: AppLocalizations.of(context)!.chartNoDataTitle,
        message: AppLocalizations.of(context)!.chartNoDataMessage,
        icon: Icons.show_chart_rounded,
      );
    }

    return LineChart(
      LineChartData(
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxY,
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipColor: (spot) =>
                Theme.of(context).colorScheme.surfaceContainerHighest,
            getTooltipItems: (spots) {
              final timeStyle = TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              );
              return [
                for (var i = 0; i < spots.length; i++)
                  LineTooltipItem(
                    // HH:mm once, above the first value of the touched column.
                    i == 0 && _selectedRange == 0
                        ? '${formatHourOfDay(spots[i].x)}\n'
                        : '',
                    timeStyle,
                    children: [
                      TextSpan(
                        text: _selectedRange == 0
                            ? Formatters.formatPower(spots[i].y)
                            : Formatters.formatEnergy(spots[i].y),
                        style: TextStyle(
                          color: spots[i].bar.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
              ];
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 52,
              interval: _computeLeftInterval(minY, maxY),
              getTitlesWidget: (value, meta) {
                if (value == meta.min || value == meta.max) {
                  return const SizedBox.shrink();
                }
                return SideTitleWidget(
                  meta: meta,
                  child: Text(
                    _selectedRange == 0
                        ? Formatters.formatAxisPower(value)
                        : Formatters.formatAxisEnergy(value),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: _selectedRange == 0
                  ? 4
                  : _selectedRange == 1
                      ? 1
                      : ((maxX - minX) > 20 ? 5 : 2),
              getTitlesWidget: (value, meta) {
                // fl_chart always labels the axis max (23:00), which then
                // collides with the previous tick (20:00).
                if (value == meta.max &&
                    meta.appliedInterval > 0 &&
                    (value - meta.min) % meta.appliedInterval != 0) {
                  return const SizedBox.shrink();
                }
                return SideTitleWidget(
                  meta: meta,
                  space: 10,
                  child: Text(
                    formatBottomAxisLabel(value, AppLocalizations.of(context)!),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.18),
            strokeWidth: 0.8,
          ),
        ),
        rangeAnnotations: futureStartX == null
            ? const RangeAnnotations()
            : RangeAnnotations(
                verticalRangeAnnotations: [
                  VerticalRangeAnnotation(
                    x1: futureStartX,
                    x2: maxX,
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.05),
                  ),
                ],
              ),
        borderData: FlBorderData(show: false),
        lineBarsData: lines,
      ),
    );
  }

  Widget buildBarChart(
    BuildContext context,
    double minX,
    double maxX,
    double minY,
    double maxY,
    double? futureStartX,
  ) {
    final series = buildBarSeries(AppLocalizations.of(context)!);
    if (series.isEmpty) {
      return AppEmptyState(
        title: AppLocalizations.of(context)!.chartNoDataTitle,
        message: AppLocalizations.of(context)!.chartNoDataMessage,
        icon: Icons.bar_chart_rounded,
      );
    }

    return LayoutBuilder(builder: (context, constraints) {
      final groups = <BarChartGroupData>[];
      final start = minX.round();
      final end = maxX.round();
      // Fit every group in its slot: 30 month days x 4 series used to overlap
      // the neighbouring days with fixed 5 px rods + 4 px gaps.
      final groupCount = (end - start + 1).clamp(1, 31);
      final slotWidth = (constraints.maxWidth - 52) / groupCount;
      final barsSpace = slotWidth < 24 ? 1.0 : 4.0;
      final rodWidth =
          ((slotWidth * 0.75 - barsSpace * (series.length - 1)) / series.length)
              .clamp(1.5, 8.0)
              .toDouble();

      for (var x = start; x <= end; x++) {
        final rods = <BarChartRodData>[];
        for (final s in series) {
          final value = s.points[x] ?? 0.0;
          rods.add(
            BarChartRodData(
              toY: value,
              color: s.color,
              width: rodWidth,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }
        groups.add(
          BarChartGroupData(
            x: x,
            barsSpace: barsSpace,
            barRods: rods,
          ),
        );
      }

      return BarChart(
        BarChartData(
          minY: minY,
          maxY: maxY,
          baselineY: 0,
          barGroups: groups,
          groupsSpace: 8,
          titlesData: FlTitlesData(
            show: true,
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 52,
                interval: _computeLeftInterval(minY, maxY),
                getTitlesWidget: (value, meta) {
                  if (value == meta.min || value == meta.max) {
                    return const SizedBox.shrink();
                  }
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      Formatters.formatAxisEnergy(value),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval:
                    _selectedRange == 1 ? 1 : ((maxX - minX) > 20 ? 5 : 2),
                getTitlesWidget: (value, meta) {
                  // Bar charts label every group and ignore `interval`:
                  // in the month view keep day 1 and every 5th day only.
                  final day = value.round();
                  if (_selectedRange == 2 && day != 1 && day % 5 != 0) {
                    return const SizedBox.shrink();
                  }
                  return SideTitleWidget(
                    meta: meta,
                    space: 10,
                    child: Text(
                      formatBottomAxisLabel(
                          value, AppLocalizations.of(context)!),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.18),
              strokeWidth: 0.8,
            ),
          ),
          rangeAnnotations: futureStartX == null
              ? const RangeAnnotations()
              : RangeAnnotations(
                  verticalRangeAnnotations: [
                    VerticalRangeAnnotation(
                      x1: futureStartX,
                      x2: maxX,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.05),
                    ),
                  ],
                ),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipColor: (_) =>
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final name = series[rodIndex].name;
                final when = _selectedRange == 1
                    ? formatBottomAxisLabel(
                        group.x.toDouble(), AppLocalizations.of(context)!)
                    : '${group.x}';
                return BarTooltipItem(
                  '${rodIndex == 0 ? '$when\n' : ''}$name\n${Formatters.formatEnergy(rod.toY)}',
                  TextStyle(
                    color: rod.color,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
  }

  List<_BarSeriesConfig> buildBarSeries(AppLocalizations l10n) {
    final result = <_BarSeriesConfig>[];

    Map<int, double> toMap(List<FlSpot> spots) {
      final map = <int, double>{};
      for (final spot in spots) {
        map[spot.x.round()] = spot.y;
      }
      return map;
    }

    if (_showProduction && _productionData.isNotEmpty) {
      result.add(_BarSeriesConfig(
        name: l10n.production,
        color: AppTheme.pvColor,
        points: toMap(_productionData),
      ));
    }
    if (_showConsumption && _consumptionData.isNotEmpty) {
      result.add(_BarSeriesConfig(
        name: l10n.consumption,
        color: AppTheme.loadColor,
        points: toMap(_consumptionData),
      ));
    }
    if (_showBattery && _batteryData.isNotEmpty) {
      result.add(_BarSeriesConfig(
        name: l10n.battery,
        color: AppTheme.batteryColor,
        points: toMap(_batteryData),
      ));
    }
    if (_showGrid && _gridData.isNotEmpty) {
      result.add(_BarSeriesConfig(
        name: l10n.acInput,
        color: AppTheme.gridColor,
        points: toMap(_gridData),
      ));
    }
    if (_showForecast && _forecastData.isNotEmpty && _selectedRange != 0) {
      result.add(_BarSeriesConfig(
        name: l10n.forecast,
        color: _forecastSeriesColor.withValues(alpha: 0.75),
        points: toMap(_forecastData),
      ));
    }

    return result;
  }

  LineChartBarData buildLineData(
    List<FlSpot> spots,
    Color color, {
    required bool isCurved,
  }) {
    final normalized = normalizeSpots(spots);
    final useCurved = isCurved && normalized.length >= 4;
    return LineChartBarData(
      spots: normalized,
      isCurved: useCurved,
      curveSmoothness: useCurved ? 0.24 : 0.0,
      preventCurveOverShooting: true,
      preventCurveOvershootingThreshold: 8,
      color: color,
      barWidth: 3,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withValues(alpha: 0.08),
            color.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }

  double getMaxY([List<FlSpot>? spots]) {
    spots ??= getVisibleSpots();
    if (spots.isEmpty) return 10.0;
    var max = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    return max == 0 ? 10.0 : max * 1.15;
  }

  double getMaxX() {
    if (_selectedRange == 0) return 23;
    if (_selectedRange == 1) return 6;

    final lastDay = DateTime(_currentDate.year, _currentDate.month + 1, 0).day;
    return lastDay.toDouble();
  }

  double getMinX() {
    if (_selectedRange == 0 || _selectedRange == 1) return 0;
    return 1;
  }

  String formatBottomAxisLabel(double value, AppLocalizations l10n,
      {bool forceWeek = false}) {
    final rounded = value.round();
    if ((value - rounded).abs() > 0.01) return '';

    if (_selectedRange == 0 && !forceWeek) {
      return '$rounded:00';
    }

    if (_selectedRange == 1 || forceWeek) {
      const weekKeys = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
      if (rounded < 0 || rounded >= weekKeys.length) return '';
      switch (weekKeys[rounded]) {
        case 'mon':
          return l10n.mon;
        case 'tue':
          return l10n.tue;
        case 'wed':
          return l10n.wed;
        case 'thu':
          return l10n.thu;
        case 'fri':
          return l10n.fri;
        case 'sat':
          return l10n.sat;
        case 'sun':
          return l10n.sun;
      }
    }

    final lastDay = DateTime(_currentDate.year, _currentDate.month + 1, 0).day;
    if (rounded < 1 || rounded > lastDay) return '';
    final day = rounded.toString().padLeft(2, '0');
    final month = _currentDate.month.toString().padLeft(2, '0');
    return '$day.$month';
  }

  double getMinY([List<FlSpot>? spots]) {
    spots ??= getVisibleSpots();
    var minVal = 0.0;
    for (var spot in spots) {
      if (spot.y < minVal) minVal = spot.y;
    }
    return minVal >= 0 ? 0 : minVal * 1.2;
  }

  /// Compute a Y-axis interval that produces ~5 ticks max to prevent label overlap.
  double _computeLeftInterval(double minY, double maxY) {
    final range = maxY - minY;
    if (range <= 0) return 1;
    final rawInterval = range / 5;
    final niceSteps = [1, 2, 5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000];
    for (final step in niceSteps) {
      if (rawInterval <= step) return step.toDouble();
    }
    return (rawInterval / 1000).ceil() * 1000.0;
  }

  List<FlSpot> getVisibleSpots() {
    var all = <FlSpot>[];
    if (_showProduction) all.addAll(_productionData);
    if (_showConsumption) all.addAll(_consumptionData);
    if (_showBattery) all.addAll(_batteryData);
    if (_showGrid) all.addAll(_gridData);
    if (_showForecast) all.addAll(_forecastData);
    return all;
  }

  void logChartUiSummary(String prefix) {
    const fmt = describeSpots;

    String quality(List<FlSpot> spots) {
      if (spots.isEmpty) return 'missing';
      if (spots.any((s) => !s.x.isFinite || !s.y.isFinite)) return 'invalid';

      final uniqueX = spots.map((e) => e.x.toStringAsFixed(3)).toSet().length;
      if (uniqueX < 2) return 'poor';

      final minX = spots.map((e) => e.x).reduce((a, b) => a < b ? a : b);
      final maxX = spots.map((e) => e.x).reduce((a, b) => a > b ? a : b);
      final axisMin = getMinX();
      final axisMax = getMaxX();
      final span = (axisMax - axisMin).abs();
      final covered = (maxX - minX).abs();
      final coverage = span > 0 ? (covered / span).clamp(0.0, 1.0) : 1.0;

      if (coverage < 0.25) return 'low';
      if (coverage < 0.6) return 'partial';
      return 'good';
    }

    LogService.log(
        '[chart] $prefix | range=$_selectedRange pv[q=${quality(_productionData)}](${fmt(_productionData)}) load[q=${quality(_consumptionData)}](${fmt(_consumptionData)}) battery[q=${quality(_batteryData)}](${fmt(_batteryData)}) grid[q=${quality(_gridData)}](${fmt(_gridData)}) forecast[q=${quality(_forecastData)}](${fmt(_forecastData)})');
  }
}

class _ChartRefreshBadge extends StatefulWidget {
  final DateTime refreshedAt;
  final bool isRefreshing;

  const _ChartRefreshBadge({
    required this.refreshedAt,
    required this.isRefreshing,
  });

  @override
  State<_ChartRefreshBadge> createState() => _ChartRefreshBadgeState();
}

class _ChartSkeleton extends StatelessWidget {
  const _ChartSkeleton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final barColor = theme.colorScheme.surfaceContainerHighest;
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final h in [0.25, 0.48, 0.36, 0.62, 0.44, 0.7, 0.52, 0.6])
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        widthFactor: 0.62,
                        heightFactor: h,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: barColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                AppLocalizations.of(context)!.waitingInverterResponse,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartRefreshBadgeState extends State<_ChartRefreshBadge> {
  Timer? ticker;

  @override
  void initState() {
    super.initState();
    // Tick every 30s to keep the "minutes ago" label fresh.
    ticker = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    ticker?.cancel();
    super.dispose();
  }

  String label() {
    final l10n = AppLocalizations.of(context)!;
    if (widget.isRefreshing) return '...';
    final diff = DateTime.now().difference(widget.refreshedAt);
    if (diff.inSeconds < 60) return l10n.lessThanMinute;
    if (diff.inMinutes < 60) return l10n.minutesAgo(diff.inMinutes.toString());
    return l10n.hoursAgo(diff.inHours.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isStale = !widget.isRefreshing &&
        DateTime.now().difference(widget.refreshedAt) >
            const Duration(minutes: 6);
    final color = isStale
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).hintColor;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.isRefreshing)
          SizedBox(
            width: 10,
            height: 10,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: color,
            ),
          )
        else
          Icon(
            isStale ? Icons.sync_problem_rounded : Icons.sync_rounded,
            size: 12,
            color: color,
          ),
        const SizedBox(width: AppTheme.spacingXS),
        Text(
          label(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
        ),
      ],
    );
  }
}

class _BarSeriesConfig {
  final String name;
  final Color color;
  final Map<int, double> points;

  const _BarSeriesConfig({
    required this.name,
    required this.color,
    required this.points,
  });
}

/// Fullscreen chart: opens in landscape on phones, with a button to flip
/// back to portrait. Reuses the section's own chart/legend builders.
class _EnergyChartFullscreenPage extends StatefulWidget {
  final String title;
  final Widget Function(VoidCallback onChanged) legendBuilder;
  final Widget Function(BuildContext context) chartBuilder;

  const _EnergyChartFullscreenPage({
    required this.title,
    required this.legendBuilder,
    required this.chartBuilder,
  });

  @override
  State<_EnergyChartFullscreenPage> createState() =>
      _EnergyChartFullscreenPageState();
}

class _EnergyChartFullscreenPageState extends State<_EnergyChartFullscreenPage>
    with _FullscreenViewMixin {
  bool _landscape = true;

  @override
  void initState() {
    super.initState();
    unawaited(enterFullscreen(landscape: true));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 44,
        title: Text(widget.title, style: theme.textTheme.titleSmall),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          onPressed: closeFullscreen,
        ),
        actions: [
          if (_isMobile)
            IconButton(
              icon: const Icon(Icons.screen_rotation_rounded),
              tooltip: l10n.chartRotate,
              onPressed: () {
                setState(() => _landscape = !_landscape);
                unawaited(lockOrientation(landscape: _landscape));
              },
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.spacingS,
            0,
            AppTheme.spacingM,
            AppTheme.spacingS,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.legendBuilder(() => setState(() {})),
              const SizedBox(height: AppTheme.spacingS),
              Expanded(child: widget.chartBuilder(context)),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================== SOC HISTORY CHART ========================
