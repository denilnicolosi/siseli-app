part of 'dashboard_tab.dart';

class _QuickPulseSection extends StatelessWidget {
  final AppStateProvider provider;
  final InverterData data;

  const _QuickPulseSection({required this.provider, required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    String volts(double v) => '${v.toStringAsFixed(0)} V';
    final entries = [
      (
        label: l10n.production,
        value: Formatters.formatPower(data.pvPower),
        subtitle:
            '${volts(data.pvVoltage)} · ${(provider.pvTotalCapacityW / 1000).toStringAsFixed(1)} kWp',
        icon: Icons.wb_sunny_rounded,
        color: AppTheme.pvColor,
      ),
      (
        label: l10n.consumption,
        value: Formatters.formatPower(data.loadPower),
        subtitle:
            '${l10n.inverterLoad} ${data.loadPercentage.toStringAsFixed(0)}%',
        icon: Icons.home_rounded,
        color: AppTheme.loadColor,
      ),
      (
        label: l10n.battery,
        value: '${data.batterySoc.toStringAsFixed(0)}%',
        subtitle:
            '${Formatters.formatPower(data.batteryPower.abs())} · ${data.batteryVoltage.toStringAsFixed(1)} V',
        icon: Icons.battery_6_bar_rounded,
        color: AppTheme.batteryColor,
      ),
      (
        label: l10n.acInput,
        value: Formatters.formatPower(data.gridPower.abs()),
        subtitle: volts(data.gridVoltage),
        icon: Icons.electrical_services_rounded,
        color: AppTheme.gridColor,
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
          const spacing = AppTheme.spacingS;
          final columns = constraints.maxWidth >= 980 ? 4 : 2;
          final cardWidth =
              (constraints.maxWidth - (columns - 1) * spacing) / columns;
          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              for (final entry in entries)
                SizedBox(
                  width: cardWidth,
                  child: _PulseMetricTile(
                    label: entry.label,
                    value: entry.value,
                    subtitle: entry.subtitle,
                    icon: entry.icon,
                    color: entry.color,
                  ),
                ),
            ],
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
    final muted = theme.colorScheme.onSurfaceVariant;
    return AppCard(
      borderRadius: context.expressive.cornerMedium,
      enableBlur: false,
      backgroundColor: theme.colorScheme.surfaceContainerHigh,
      padding: const EdgeInsets.all(AppTheme.spacingS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: AppTheme.spacingXS),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(color: muted),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          AnimatedSwitcher(
            duration: context.motion.quick,
            switchInCurve: context.motion.standardCurve,
            switchOutCurve: context.motion.standardCurve,
            child: Text(
              value,
              key: ValueKey(value),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(color: muted),
          ),
        ],
      ),
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
