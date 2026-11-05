import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:fl_chart/fl_chart.dart';
import 'package:window_manager/window_manager.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/app_provider.dart';
import '../../models/inverter_data.dart';
import '../../services/log_service.dart';
import '../../services/soc_history_service.dart';
import '../../services/weather_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_components.dart';
import '../../widgets/energy_flow.dart';
import '../../utils/chart_log.dart';
import '../../utils/formatters.dart';
import '../../utils/dashboard_diagnostics_export.dart';

part 'energy_flow_section.dart';
part 'stats_section.dart';
part 'month_economics.dart';
part 'system_capacity.dart';
part 'energy_chart_section.dart';
part 'soc_history.dart';

class DashboardTab extends StatelessWidget {
  final AppStateProvider provider;
  final InverterData data;

  const DashboardTab({super.key, required this.provider, required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statusMessage = provider.statusMessage.trim();
    final lastUpdatedAt = provider.lastSuccessfulRealtimeAt;
    final lastUpdatedShortLabel = lastUpdatedAt == null
        ? null
        : '${lastUpdatedAt.hour.toString().padLeft(2, '0')}:${lastUpdatedAt.minute.toString().padLeft(2, '0')}';
    final diagnosticsSnapshotText =
        buildDashboardDiagnosticsSnapshot(provider, data);
    final sections = <Widget>[
      RepaintBoundary(
          child: _EnergyFlowSection(provider: provider, data: data)),
      if (statusMessage.isNotEmpty)
        AppStatusBanner(
          message: statusMessage,
          icon: Icons.info_outline,
          meta: lastUpdatedShortLabel == null
              ? null
              : '${l10n.lastRealtimeUpdate}: $lastUpdatedShortLabel',
        ),
      _DashboardDiagnosticsCard(
        snapshotText: diagnosticsSnapshotText,
      ),
      RepaintBoundary(
          child: _QuickPulseSection(provider: provider, data: data)),
      RepaintBoundary(child: _StatsSection(provider: provider, data: data)),
      LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 1180;
          if (!wide) {
            return Column(
              children: [
                RepaintBoundary(
                  child: _EnergyChartSection(provider: provider),
                ),
                const SizedBox(height: AppTheme.spacingL),
                RepaintBoundary(
                  child: _SystemCapacitySection(
                    provider: provider,
                    data: data,
                  ),
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: RepaintBoundary(
                  child: _EnergyChartSection(provider: provider),
                ),
              ),
              const SizedBox(width: AppTheme.spacingL),
              Expanded(
                flex: 4,
                child: RepaintBoundary(
                  child: _SystemCapacitySection(
                    provider: provider,
                    data: data,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      RepaintBoundary(child: _MonthEconomicsBreakdown(provider: provider)),
      RepaintBoundary(child: _BatterySocHistoryCard(provider: provider)),
    ];

    final isCompact = MediaQuery.sizeOf(context).width < 600;
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyR, control: true): () {
          if (!provider.isDataLoading) {
            unawaited(provider.fetchData());
          }
        },
      },
      child: Focus(
        autofocus: true,
        child: RefreshIndicator(
          color: Theme.of(context).colorScheme.primary,
          onRefresh: provider.fetchData,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(
              parent: ClampingScrollPhysics(),
            ),
            padding: EdgeInsets.fromLTRB(
              isCompact ? AppTheme.spacingM : AppTheme.spacingL,
              isCompact ? AppTheme.spacingS : AppTheme.spacingL,
              isCompact ? AppTheme.spacingM : AppTheme.spacingL,
              AppTheme.spacingL,
            ),
            itemBuilder: (context, index) => sections[index],
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppTheme.spacingL),
            itemCount: sections.length,
          ),
        ),
      ),
    );
  }
}

class _DashboardDiagnosticsCard extends StatelessWidget {
  final String snapshotText;

  const _DashboardDiagnosticsCard({required this.snapshotText});

  Future<void> _copySnapshot(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    await Clipboard.setData(ClipboardData(text: snapshotText));
    final savedPath =
        await appendDashboardDiagnosticsSnapshotToFile(snapshotText);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(savedPath == null
            ? l10n.diagnosticsSnapshotCopied
            : '${l10n.diagnosticsSnapshotCopied}\n$savedPath'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final expressive = context.expressive;

    return AppCard(
      borderRadius: expressive.cornerXL,
      enableBlur: false,
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(expressive.cornerMedium),
              ),
              child: Icon(
                Icons.content_copy_rounded,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.diagnosticsSnapshot,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.diagnosticsSnapshotHint,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            FilledButton.tonalIcon(
              onPressed: () => _copySnapshot(context),
              icon: const Icon(Icons.copy_rounded, size: 18),
              label: Text(l10n.copyDiagnosticsSnapshot),
            ),
          ],
        ),
      ),
    );
  }
}

