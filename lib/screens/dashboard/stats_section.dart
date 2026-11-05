part of 'dashboard_tab.dart';

class _QuickPulseSection extends StatelessWidget {
  final AppStateProvider provider;
  final InverterData data;

  const _QuickPulseSection({required this.provider, required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final entries = [
      (
        label: l10n.production,
        value: Formatters.formatPower(data.pvPower),
        subtitle: '${provider.pvTotalCapacityW.toStringAsFixed(0)} W',
        icon: Icons.wb_sunny_rounded,
        color: AppTheme.pvColor,
      ),
      (
        label: l10n.consumption,
        value: Formatters.formatPower(data.loadPower),
        subtitle:
            '${provider.currentCostPerHourUah.toStringAsFixed(2)} ${l10n.uahPerHour}',
        icon: Icons.home_rounded,
        color: AppTheme.loadColor,
      ),
      (
        label: l10n.battery,
        value: '${data.batterySoc.toStringAsFixed(0)}%',
        subtitle: Formatters.formatPower(data.batteryPower.abs()),
        icon: Icons.battery_6_bar_rounded,
        color: AppTheme.batteryColor,
      ),
      (
        label: l10n.grid,
        value: Formatters.formatPower(data.gridPower.abs()),
        subtitle: provider.isGridOutageDetected
            ? l10n.gridOutageDetectedShort
            : provider.isInverterOffline
                ? l10n.connectionOffline
                : l10n.connectionOnline,
        icon: Icons.electrical_services_rounded,
        color: provider.isGridOutageDetected
            ? theme.colorScheme.error
            : AppTheme.gridColor,
      ),
    ];

    return AppSectionCard(
      title: l10n.energyOverview,
      subtitle: l10n.realtimeReadings,
      icon: Icons.bolt_rounded,
      trailing: AppStatusChip(
        icon: provider.isInverterOffline
            ? Icons.cloud_off_rounded
            : Icons.cloud_done_rounded,
        label: provider.isInverterOffline
            ? l10n.connectionOffline
            : l10n.connectionOnline,
        color: provider.isInverterOffline
            ? theme.colorScheme.error
            : AppTheme.batteryColor,
      ),
      borderRadius: context.expressive.cornerXL,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final columns = width >= 980
              ? 4
              : width >= 640
                  ? 2
                  : 1;
          final cardWidth =
              (width - (columns - 1) * AppTheme.spacingM) / columns;
          return Wrap(
            spacing: AppTheme.spacingM,
            runSpacing: AppTheme.spacingM,
            children: entries
                .map(
                  (entry) => SizedBox(
                    width: cardWidth,
                    child: _PulseMetricTile(
                      label: entry.label,
                      value: entry.value,
                      subtitle: entry.subtitle,
                      icon: entry.icon,
                      color: entry.color,
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}

class _PulseMetricTile extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _PulseMetricTile({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      borderRadius: context.expressive.cornerMedium,
      enableBlur: false,
      backgroundColor: theme.colorScheme.surfaceContainerHigh,
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius:
                  BorderRadius.circular(context.expressive.cornerSmall),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXS),
                AnimatedSwitcher(
                  duration: context.motion.quick,
                  switchInCurve: context.motion.standardCurve,
                  switchOutCurve: context.motion.standardCurve,
                  child: Text(
                    value,
                    key: ValueKey(value),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ======================== STATS SECTION ========================

class _StatsSection extends StatelessWidget {
  final AppStateProvider provider;
  final InverterData data;

  const _StatsSection({required this.provider, required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final expressive = context.expressive;
    final daily = provider.service.dailyEnergy.toStringAsFixed(1);
    final total = provider.service.totalEnergy.toStringAsFixed(0);
    final co2 = provider.service.co2Reduction.toStringAsFixed(1);
    final savedMoney = provider.monthSavedUah;
    final monthToPay = provider.monthToPayUah;
    final projectedSavedMoney = provider.projectedMonthSavedUah;
    final projectedMonthToPay = provider.projectedMonthToPayUah;
    final batteryEff =
        provider.batteryRoundTripEfficiencyPercent.toStringAsFixed(0);
    final nightShare = provider.nightEnergySharePercent.toStringAsFixed(0);
    final dayStart = provider.tariffDayStartHour.toString().padLeft(2, '0');
    final nightStart = provider.tariffNightStartHour.toString().padLeft(2, '0');
    final paymentTooltip = provider.monthEconomicsUsesTelemetryTou
        ? l10n.tooltipPaymentThisMonthTelemetry(dayStart, nightStart)
        : l10n.tooltipPaymentThisMonthEstimated(nightShare);
    final savedTooltip = provider.monthEconomicsUsesTelemetryTou
        ? l10n.tooltipMoneySavedMonthTelemetry(batteryEff)
        : l10n.tooltipMoneySavedMonthEstimated(nightShare, batteryEff);
    final sourceValue = provider.monthEconomicsUsesTelemetryTou
        ? l10n.calculationSourceTelemetry
        : l10n.calculationSourceFallback;
    final paymentPrefix =
        provider.monthEconomicsUsesEstimatedFallback ? '~' : '';
    const savingsPrefix = '~';
    const projectionPrefix = '~';
    return AppCard(
      borderRadius: expressive.cornerXL,
      enableBlur: false,
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // ignore: unused_local_variable
            final compact = constraints.maxWidth < 1080;
            final featuredMetrics = [
              _HeroMetricCard(
                label: l10n.today,
                value: daily,
                unit: 'kWh',
                icon: Icons.today_rounded,
                color: AppTheme.pvColor,
                tooltip: l10n.tooltipTodayEnergy,
              ),
              _HeroMetricCard(
                label: l10n.moneySavedMonth,
                value: savedMoney == null || savedMoney == 0.0
                    ? '0.0'
                    : '$savingsPrefix${savedMoney.toStringAsFixed(1)}',
                unit: l10n.currencyUah,
                icon: Icons.savings_rounded,
                color: AppTheme.batteryColor,
                tooltip: savedTooltip,
              ),
              _HeroMetricCard(
                label: l10n.paymentThisMonth,
                value: monthToPay == null || monthToPay == 0.0
                    ? '0.0'
                    : '$paymentPrefix${monthToPay.toStringAsFixed(1)}',
                unit: l10n.currencyUah,
                icon: Icons.receipt_long_rounded,
                color: AppTheme.gridColor,
                tooltip: paymentTooltip,
              ),
            ];

            final supportingMetrics = [
              _SupportingMetricCard(
                label: l10n.total,
                value: total,
                unit: 'kWh',
                icon: Icons.assessment_rounded,
                color: AppTheme.pvColor,
                tooltip: l10n.tooltipTotalEnergy,
              ),
              _SupportingMetricCard(
                label: 'CO2',
                value: co2,
                unit: 'kg',
                icon: Icons.eco_rounded,
                color: AppTheme.batteryColor,
                tooltip: l10n.tooltipCo2,
              ),
              _SupportingMetricCard(
                label: l10n.projectedSavedMonth,
                value: projectedSavedMoney == null || projectedSavedMoney == 0.0
                    ? '0.0'
                    : '$projectionPrefix${projectedSavedMoney.toStringAsFixed(1)}',
                unit: l10n.currencyUah,
                icon: Icons.trending_up_rounded,
                color: AppTheme.batteryColor,
                tooltip: l10n.tooltipProjectedSavedMonth,
              ),
              _SupportingMetricCard(
                label: l10n.projectedPaymentMonth,
                value: projectedMonthToPay == null || projectedMonthToPay == 0.0
                    ? '0.0'
                    : '$projectionPrefix${projectedMonthToPay.toStringAsFixed(1)}',
                unit: l10n.currencyUah,
                icon: Icons.calendar_month_rounded,
                color: AppTheme.gridColor,
                tooltip: l10n.tooltipProjectedPaymentMonth,
              ),
            ];

            final summary = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius:
                            BorderRadius.circular(expressive.cornerMedium),
                      ),
                      child: Icon(
                        Icons.dashboard_customize_rounded,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.energyOverview,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingXS),
                          Text(
                            '${l10n.calculationSourceLabel}: $sourceValue',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingM),
                Wrap(
                  spacing: AppTheme.spacingS,
                  runSpacing: AppTheme.spacingS,
                  children: [
                    _DashboardPill(
                      icon: provider.isInverterOffline
                          ? Icons.cloud_off_rounded
                          : Icons.cloud_done_rounded,
                      label: provider.isInverterOffline
                          ? l10n.connectionOffline
                          : l10n.connectionOnline,
                      color: provider.isInverterOffline
                          ? theme.colorScheme.error
                          : AppTheme.batteryColor,
                    ),
                    _DashboardPill(
                      icon: Icons.tune_rounded,
                      label: sourceValue,
                      color: theme.colorScheme.primary,
                    ),
                    _DashboardPill(
                      icon: Icons.bolt_rounded,
                      label:
                          '${Formatters.formatPower(data.loadPower)} / ${Formatters.formatPower(provider.inverterMaxPowerW)}',
                      color: AppTheme.loadColor,
                    ),
                    _DashboardPill(
                      icon: Icons.currency_exchange_rounded,
                      label:
                          '${l10n.currentCostPerHour}: ${provider.currentCostPerHourUah.toStringAsFixed(2)} ${l10n.uahPerHour}',
                      color: AppTheme.gridColor,
                    ),
                    _DashboardPill(
                      icon: Icons.repeat_rounded,
                      label: '${l10n.batteryCycles}: ${provider.batteryCycles}',
                      color: AppTheme.batteryColor,
                    ),
                    _DashboardPill(
                      icon: Icons.health_and_safety_rounded,
                      label: l10n.battSohPercent(
                        provider.batteryHealthPercent.toStringAsFixed(0),
                      ),
                      color: theme.colorScheme.tertiary,
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingL),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final metricCompact = constraints.maxWidth < 760;
                    if (metricCompact) {
                      return Column(
                        children: [
                          for (var i = 0; i < featuredMetrics.length; i++) ...[
                            featuredMetrics[i],
                            if (i != featuredMetrics.length - 1)
                              const SizedBox(height: AppTheme.spacingM),
                          ],
                        ],
                      );
                    }
                    return Row(
                      children: [
                        for (var i = 0; i < featuredMetrics.length; i++) ...[
                          Expanded(child: featuredMetrics[i]),
                          if (i != featuredMetrics.length - 1)
                            const SizedBox(width: AppTheme.spacingM),
                        ],
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppTheme.spacingM),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final columns = width >= 900
                        ? 4
                        : width >= 540
                            ? 2
                            : 1;
                    final cardWidth =
                        (width - (AppTheme.spacingM * (columns - 1))) / columns;
                    return Wrap(
                      spacing: AppTheme.spacingM,
                      runSpacing: AppTheme.spacingM,
                      children: supportingMetrics
                          .map(
                            (metric) => SizedBox(
                              width: cardWidth,
                              child: metric,
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ],
            );

            return summary;
          },
        ),
      ),
    );
  }
}

class _HeroMetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final String? tooltip;

  const _HeroMetricCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final card = _MetricCard(
      label: label,
      value: value,
      unit: unit,
      icon: icon,
      color: color,
      compact: false,
    );
    return tooltip == null ? card : Tooltip(message: tooltip!, child: card);
  }
}

class _SupportingMetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final String? tooltip;

  const _SupportingMetricCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final card = _MetricCard(
      label: label,
      value: value,
      unit: unit,
      icon: icon,
      color: color,
      compact: true,
    );
    return tooltip == null ? card : Tooltip(message: tooltip!, child: card);
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final bool compact;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final expressive = context.expressive;

    if (compact) {
      return AppCard(
        borderRadius: expressive.cornerMedium,
        enableBlur: false,
        backgroundColor: theme.colorScheme.surfaceContainerLow,
        padding: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Row(
            children: [
              _MetricIcon(icon: icon, color: color, size: 36),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXS),
                    AnimatedSwitcher(
                      duration: context.motion.quick,
                      switchInCurve: context.motion.standardCurve,
                      switchOutCurve: context.motion.standardCurve,
                      child: Text(
                        '$value $unit',
                        key: ValueKey('$label-$value-$unit'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return AppCard(
      borderRadius: expressive.cornerLarge,
      enableBlur: false,
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MetricIcon(icon: icon, color: color, size: 44),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppTheme.spacingXS),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: AppTheme.spacingXS,
            children: [
              AnimatedSwitcher(
                duration: context.motion.quick,
                switchInCurve: context.motion.standardCurve,
                switchOutCurve: context.motion.standardCurve,
                child: Text(
                  value,
                  key: ValueKey('$label-$value'),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacingXS),
                child: Text(
                  unit,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const _MetricIcon({
    required this.icon,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(context.expressive.cornerMedium),
      ),
      child: Icon(icon, size: size * 0.5, color: color),
    );
  }
}

class _DashboardPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _DashboardPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      borderRadius: 999,
      enableBlur: false,
      backgroundColor: theme.colorScheme.surfaceContainerHigh,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: AppTheme.spacingS),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
