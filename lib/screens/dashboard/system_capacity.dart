part of 'dashboard_tab.dart';

class _SystemCapacitySection extends StatelessWidget {
  final AppStateProvider provider;
  final InverterData data;

  const _SystemCapacitySection({
    required this.provider,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final expressive = context.expressive;
    final loadPercent = provider.inverterMaxPowerW > 0
        ? (data.loadPower / provider.inverterMaxPowerW).clamp(0.0, 1.0)
        : 0.0;
    final isOffline = provider.isInverterOffline;

    Color getLoadColor(double percent) {
      if (percent > 0.85) return const Color(0xFFEF4444);
      if (percent > 0.65) return const Color(0xFFF97316);
      return const Color(0xFF10B981);
    }

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
              title: l10n.equipmentStatus,
              subtitle:
                  isOffline ? l10n.connectionOffline : l10n.connectionOnline,
              icon: Icons.memory_rounded,
            ),
            const SizedBox(height: AppTheme.spacingXS),
            _ConnectionBadge(
              isOffline: isOffline,
              onlineLabel: l10n.connectionOnline,
              offlineLabel: l10n.connectionOffline,
              lastUpdatedPrefix: l10n.lastRealtimeUpdate,
              lastUpdatedAt: provider.lastSuccessfulRealtimeAt,
            ),
            const SizedBox(height: AppTheme.spacingL),
            AppCard(
              borderRadius: expressive.cornerMedium,
              enableBlur: false,
              backgroundColor: theme.colorScheme.surfaceContainerHigh,
              padding: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: AppProgressBar(
                  label: l10n.inverterLoad,
                  value: data.loadPower,
                  maxValue: provider.inverterMaxPowerW,
                  color: getLoadColor(loadPercent),
                  suffix: 'W',
                  tooltip: l10n.tooltipInverterLoad,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            AppCard(
              borderRadius: expressive.cornerMedium,
              enableBlur: false,
              backgroundColor: theme.colorScheme.surfaceContainerHigh,
              padding: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: AppProgressBar(
                  label: l10n.pvGeneration,
                  value: data.pvPower,
                  maxValue: provider.pvTotalCapacityW,
                  color: AppTheme.pvColor,
                  suffix: 'W',
                  tooltip: l10n.tooltipPvGeneration,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            AppCard(
              borderRadius: expressive.cornerMedium,
              enableBlur: false,
              backgroundColor: theme.colorScheme.surfaceContainerHigh,
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Row(
                children: [
                  Icon(
                    Icons.battery_6_bar_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                  Expanded(
                    child: Text(
                      '${AppLocalizations.of(context)!.battery}: ${data.batterySoc.toStringAsFixed(0)}%',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    Formatters.formatPower(data.batteryPower.abs()),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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
}

class _ConnectionBadge extends StatelessWidget {
  final bool isOffline;
  final String onlineLabel;
  final String offlineLabel;
  final String lastUpdatedPrefix;
  final DateTime? lastUpdatedAt;

  const _ConnectionBadge({
    required this.isOffline,
    required this.onlineLabel,
    required this.offlineLabel,
    required this.lastUpdatedPrefix,
    required this.lastUpdatedAt,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isOffline ? const Color(0xFFEF4444) : const Color(0xFF10B981);
    final text = isOffline ? offlineLabel : onlineLabel;
    final icon = isOffline ? Icons.cloud_off_rounded : Icons.cloud_done_rounded;
    final updated = lastUpdatedAt;
    final timeLabel = updated == null
        ? '--:--:--'
        : '${updated.hour.toString().padLeft(2, '0')}:${updated.minute.toString().padLeft(2, '0')}:${updated.second.toString().padLeft(2, '0')}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          borderRadius: 999,
          enableBlur: false,
          backgroundColor: color.withValues(alpha: 0.14),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingS,
            vertical: AppTheme.spacingXS,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: AppTheme.spacingS),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 150),
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.spacingXS),
        Text(
          '$lastUpdatedPrefix: $timeLabel',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelSmall
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

// ======================== ENERGY CHART SECTION ========================
