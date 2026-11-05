part of 'dashboard_tab.dart';

class _MonthEconomicsBreakdown extends StatelessWidget {
  final AppStateProvider provider;

  const _MonthEconomicsBreakdown({required this.provider});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final expressive = context.expressive;
    final l10n = AppLocalizations.of(context)!;
    final load = provider.monthLoadKwh;
    final grid = provider.monthGridKwh;
    final selfConsumed = provider.monthSelfConsumedKwh;
    final gridCost = provider.monthToPayUah;
    final savedCost = provider.monthSavedUah;
    final dailyEconomics = provider.monthDailyEconomics;
    final progress = provider.monthProgressFraction;
    final economicsMethod = provider.monthEconomicsUsesTelemetryTou
        ? l10n.economicsMethodTelemetry(
            provider.batteryRoundTripEfficiencyPercent.toStringAsFixed(0),
          )
        : l10n.economicsMethodEstimated(
            provider.nightEnergySharePercent.toStringAsFixed(0),
          );
    final sourceValue = provider.monthEconomicsUsesTelemetryTou
        ? l10n.calculationSourceTelemetry
        : l10n.calculationSourceFallback;
    final accuracyValue = provider.monthEconomicsUsesTelemetryTou
        ? l10n.calculationAccuracyHigh
        : l10n.calculationAccuracyEstimated;
    final paymentPrefix =
        provider.monthEconomicsUsesEstimatedFallback ? '~' : '';
    const savingsPrefix = '~';
    final effectiveTariffTooltip = provider.monthEconomicsUsesTelemetryTou
        ? l10n.tooltipEffectiveTariffTelemetry(
            provider.tariffDayStartHour.toString().padLeft(2, '0'),
            provider.tariffNightStartHour.toString().padLeft(2, '0'),
          )
        : l10n.effectiveTariffFormula(
            provider.dayTariffUahPerKwh.toStringAsFixed(2),
            provider.nightTariffUahPerKwh.toStringAsFixed(2),
            provider.nightEnergySharePercent.toStringAsFixed(0),
          );

    String fmt(double? v) => v == null ? '--' : v.toStringAsFixed(1);

    return AppCard(
      borderRadius: expressive.cornerLarge,
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(expressive.cornerSmall),
                ),
                child: Icon(
                  Icons.pie_chart_rounded,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppTheme.spacingS),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.monthlyEnergyBreakdown,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${DateTime.now().month.toString().padLeft(2, '0')}.${DateTime.now().year}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Tooltip(
                message: l10n.tooltipMonthProgress,
                child: Text(
                  '${provider.monthProgressPercent}%',
                  style: theme.textTheme.labelMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingXS),
          Tooltip(
            message:
                '${l10n.monthLoadEnergy} = ${l10n.monthGridImport} + ${l10n.monthSelfConsumed}',
            child: Text(
              '${l10n.monthLoadEnergy} = ${l10n.monthGridImport} + ${l10n.monthSelfConsumed}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 7,
              value: progress,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          _BreakdownItem(
            label: l10n.calculationSourceLabel,
            value: sourceValue,
            color: AppTheme.gridColor,
            tooltip: economicsMethod,
          ),
          const SizedBox(height: AppTheme.spacingS),
          _BreakdownItem(
            label: l10n.calculationAccuracyLabel,
            value: accuracyValue,
            color: AppTheme.loadColor,
          ),
          const SizedBox(height: AppTheme.spacingM),
          LayoutBuilder(builder: (context, constraints) {
            final compact = constraints.maxWidth < 700;
            final items = [
              _BreakdownItem(
                label: l10n.monthLoadEnergy,
                value: '${fmt(load)} kWh',
                color: AppTheme.pvColor,
              ),
              _BreakdownItem(
                label: l10n.monthGridImport,
                value: '${fmt(grid)} kWh',
                color: AppTheme.gridColor,
              ),
              _BreakdownItem(
                label: l10n.monthSelfConsumed,
                value: '${fmt(selfConsumed)} kWh',
                color: AppTheme.batteryColor,
              ),
            ];

            if (compact) {
              return Column(
                children: [
                  for (var i = 0; i < items.length; i++) ...[
                    items[i],
                    if (i != items.length - 1)
                      const SizedBox(height: AppTheme.spacingS),
                  ],
                ],
              );
            }

            return Row(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  Expanded(child: items[i]),
                  if (i != items.length - 1)
                    const SizedBox(width: AppTheme.spacingM),
                ],
              ],
            );
          }),
          const SizedBox(height: AppTheme.spacingM),
          LayoutBuilder(builder: (context, constraints) {
            final compact = constraints.maxWidth < 700;
            final moneyItems = [
              _BreakdownItem(
                label: l10n.monthGridCost,
                value:
                    '${gridCost == null || gridCost == 0.0 ? '0.0' : '$paymentPrefix${gridCost.toStringAsFixed(1)}'} ${l10n.currencyUah}',
                color: AppTheme.gridColor,
              ),
              _BreakdownItem(
                label: l10n.monthSavedCost,
                value:
                    '${savedCost == null || savedCost == 0.0 ? '0.0' : '$savingsPrefix${savedCost.toStringAsFixed(1)}'} ${l10n.currencyUah}',
                color: AppTheme.batteryColor,
              ),
              _BreakdownItem(
                label: l10n.monthEffectiveTariff,
                value:
                    '${provider.effectiveTariffUahPerKwh.toStringAsFixed(2)} ${l10n.energyTariffUnit}',
                color: AppTheme.loadColor,
                tooltip: effectiveTariffTooltip,
              ),
            ];

            if (compact) {
              return Column(
                children: [
                  for (var i = 0; i < moneyItems.length; i++) ...[
                    moneyItems[i],
                    if (i != moneyItems.length - 1)
                      const SizedBox(height: AppTheme.spacingS),
                  ],
                ],
              );
            }

            return Row(
              children: [
                for (var i = 0; i < moneyItems.length; i++) ...[
                  Expanded(child: moneyItems[i]),
                  if (i != moneyItems.length - 1)
                    const SizedBox(width: AppTheme.spacingM),
                ],
              ],
            );
          }),
          if (dailyEconomics.isNotEmpty) ...[
            const SizedBox(height: AppTheme.spacingM),
            RepaintBoundary(
                child: _MonthEconomicsMiniChart(data: dailyEconomics)),
          ],
        ],
      ),
    );
  }
}

class _MonthEconomicsMiniChart extends StatelessWidget {
  final List<({int day, double payableUah, double savedUah})> data;

  const _MonthEconomicsMiniChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final bars = data
        .map(
          (d) => BarChartGroupData(
            x: d.day,
            barRods: [
              BarChartRodData(
                toY: d.payableUah,
                width: 6,
                borderRadius: BorderRadius.circular(2),
                color: AppTheme.gridColor.withValues(alpha: 0.85),
              ),
              BarChartRodData(
                toY: d.savedUah,
                width: 6,
                borderRadius: BorderRadius.circular(2),
                color: AppTheme.batteryColor,
              ),
            ],
            barsSpace: 3,
          ),
        )
        .toList(growable: false);

    return SizedBox(
      height: 120,
      child: BarChart(
        BarChartData(
          barGroups: bars,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => theme.colorScheme.surfaceContainerHighest,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final label =
                    rodIndex == 0 ? l10n.monthGridCost : l10n.monthSavedCost;
                final amount = rod.toY.isFinite ? rod.toY : 0.0;
                return BarTooltipItem(
                  '${group.x}\n$label: ${amount.toStringAsFixed(0)} ${l10n.currencyUah}',
                  (theme.textTheme.labelMedium ?? const TextStyle()).copyWith(
                    color: rod.color ?? theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                );
              },
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 5,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
          ),
          groupsSpace: 5,
        ),
      ),
    );
  }
}

class _BreakdownItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final String? tooltip;

  const _BreakdownItem({
    required this.label,
    required this.value,
    required this.color,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final expressive = context.expressive;
    final card = AppCard(
      borderRadius: expressive.cornerMedium,
      enableBlur: false,
      backgroundColor: theme.colorScheme.surfaceContainerHigh,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: AppTheme.spacingS),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingXS),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
    if (tooltip == null) return card;
    return Tooltip(message: tooltip!, child: card);
  }
}

// ======================== SYSTEM CAPACITY SECTION ========================
