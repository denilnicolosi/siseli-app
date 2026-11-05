part of 'dashboard_tab.dart';

class _BatterySocHistoryCard extends StatelessWidget {
  final AppStateProvider provider;

  const _BatterySocHistoryCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final expressive = context.expressive;
    final samples = provider.socHistory.samples;

    return AppCard(
      borderRadius: expressive.cornerLarge,
      enableBlur: false,
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSectionTitle(
              title: l10n.socHistoryTitle,
              subtitle: l10n.socHistorySubtitle,
              icon: Icons.battery_charging_full_rounded,
            ),
            const SizedBox(height: AppTheme.spacingM),
            if (samples.length < 2)
              _SocHistoryEmpty(message: l10n.socHistoryNoData)
            else
              _SocHistoryChart(
                samples: samples,
                reserveSoc: provider.hemsService
                    .buildDiagnosticsSnapshot()
                    .adaptiveReserveSoc,
                l10n: l10n,
              ),
          ],
        ),
      ),
    );
  }
}

class _SocHistoryEmpty extends StatelessWidget {
  final String message;
  const _SocHistoryEmpty({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 120,
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _SocHistoryChart extends StatefulWidget {
  final List<SocSample> samples;
  final double reserveSoc;
  final AppLocalizations l10n;

  const _SocHistoryChart({
    required this.samples,
    required this.reserveSoc,
    required this.l10n,
  });

  @override
  State<_SocHistoryChart> createState() => _SocHistoryChartState();
}

class _SocHistoryChartState extends State<_SocHistoryChart> {
  int? _touchedIndex;

  List<FlSpot> _buildSpots() {
    if (widget.samples.isEmpty) return const [];
    final oldest = widget.samples.first.timestamp;
    return widget.samples
        .map((s) =>
            FlSpot(s.timestamp.difference(oldest).inMinutes.toDouble(), s.soc))
        .toList();
  }

  Color _spotColor(double soc) {
    if (soc >= 70) return AppTheme.batteryColor;
    if (soc >= 40) return AppTheme.pvColor;
    return const Color(0xFFEF4444);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spots = _buildSpots();
    if (spots.isEmpty) return const SizedBox.shrink();

    final oldest = widget.samples.first.timestamp;
    final newest = widget.samples.last.timestamp;
    final totalMinutes =
        newest.difference(oldest).inMinutes.toDouble().clamp(1.0, 1440.0);

    // Determine a reasonable interval for X-axis labels (every 2h or 4h)
    final xInterval = (totalMinutes / 6).ceilToDouble().clamp(30.0, 240.0);

    final currentSoc = widget.samples.last.soc;
    final currentBatPower = widget.samples.last.batteryPower;
    final stateLabel = currentBatPower > 20
        ? widget.l10n.socHistoryChargingLabel
        : currentBatPower < -20
            ? widget.l10n.socHistoryDischargingLabel
            : widget.l10n.socHistoryIdleLabel;
    final stateColor = currentBatPower > 20
        ? AppTheme.batteryColor
        : currentBatPower < -20
            ? const Color(0xFFF97316)
            : theme.colorScheme.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status strip
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM, vertical: 4),
              decoration: BoxDecoration(
                color: _spotColor(currentSoc).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Text(
                '${currentSoc.toStringAsFixed(0)}%',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: _spotColor(currentSoc),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: AppTheme.spacingS),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM, vertical: 4),
              decoration: BoxDecoration(
                color: stateColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Text(
                stateLabel,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: stateColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Spacer(),
            Text(
              '${widget.samples.length} pts',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingM),
        SizedBox(
          height: 160,
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: 100,
              minX: 0,
              maxX: totalMinutes,
              clipData: const FlClipData.all(),
              lineTouchData: LineTouchData(
                enabled: true,
                touchCallback: (evt, resp) {
                  setState(() {
                    _touchedIndex = resp?.lineBarSpots?.firstOrNull?.spotIndex;
                  });
                },
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) =>
                      theme.colorScheme.surfaceContainerHighest,
                  getTooltipItems: (spots) => spots.map((s) {
                    final idx = s.spotIndex;
                    final sample = widget.samples[idx];
                    final hh = sample.timestamp.hour.toString().padLeft(2, '0');
                    final mm =
                        sample.timestamp.minute.toString().padLeft(2, '0');
                    return LineTooltipItem(
                      '$hh:$mm\n${s.y.toStringAsFixed(0)}%',
                      (theme.textTheme.labelMedium ?? const TextStyle())
                          .copyWith(
                        color: _spotColor(s.y),
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  }).toList(),
                ),
              ),
              lineBarsData: [
                // Main SOC line
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  curveSmoothness: 0.25,
                  color: AppTheme.batteryColor,
                  barWidth: 2.5,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    checkToShowDot: (s, bar) =>
                        _touchedIndex == spots.indexOf(s) || s == spots.last,
                    getDotPainter: (s, _, __, ___) => FlDotCirclePainter(
                      radius: s == spots.last ? 4 : 3,
                      color: _spotColor(s.y),
                      strokeWidth: 1.5,
                      strokeColor: theme.colorScheme.surface,
                    ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.batteryColor.withValues(alpha: 0.28),
                        AppTheme.batteryColor.withValues(alpha: 0.04),
                      ],
                    ),
                  ),
                ),
              ],
              // Reserve threshold dashed line
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(
                    y: widget.reserveSoc,
                    color: const Color(0xFFEF4444).withValues(alpha: 0.55),
                    strokeWidth: 1.2,
                    dashArray: [6, 4],
                    label: HorizontalLineLabel(
                      show: true,
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.only(right: 6, bottom: 2),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: const Color(0xFFEF4444),
                        fontWeight: FontWeight.w600,
                      ),
                      labelResolver: (_) => widget.l10n.socHistoryReserveLabel,
                    ),
                  ),
                ],
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 20,
                getDrawingHorizontalLine: (v) => FlLine(
                  color:
                      theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                  strokeWidth: 0.8,
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 20,
                    reservedSize: 30,
                    getTitlesWidget: (v, _) => Text(
                      '${v.toInt()}%',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: xInterval,
                    reservedSize: 22,
                    getTitlesWidget: (v, _) {
                      final dt = oldest.add(Duration(minutes: v.toInt()));
                      final hh = dt.hour.toString().padLeft(2, '0');
                      final mm = dt.minute.toString().padLeft(2, '0');
                      return Text(
                        '$hh:$mm',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 10,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacingS),
        // Legend row
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SocLegendDot(
              color: AppTheme.batteryColor,
              label: '≥70%',
            ),
            const SizedBox(width: AppTheme.spacingM),
            _SocLegendDot(
              color: AppTheme.pvColor,
              label: '40–69%',
            ),
            const SizedBox(width: AppTheme.spacingM),
            _SocLegendDot(
              color: const Color(0xFFEF4444),
              label: '<40%',
            ),
            const SizedBox(width: AppTheme.spacingL),
            Container(
              width: 18,
              height: 2,
              decoration: const BoxDecoration(
                color: Color(0xFFEF4444),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              widget.l10n.socHistoryReserveLabel,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SocLegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _SocLegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
