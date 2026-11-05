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
import '../../services/weather_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_components.dart';
import '../../widgets/energy_flow.dart';
import '../../utils/chart_log.dart';
import '../../utils/energy_totals.dart';
import '../../utils/formatters.dart';

part 'energy_flow_section.dart';
part 'energy_chart_section.dart';

class DashboardTab extends StatelessWidget {
  final AppStateProvider provider;
  final InverterData data;

  const DashboardTab({super.key, required this.provider, required this.data});

  @override
  Widget build(BuildContext context) {
    final sections = <Widget>[
      RepaintBoundary(
          child: _EnergyFlowSection(provider: provider, data: data)),
      RepaintBoundary(child: _EnergyChartSection(provider: provider)),
    ];

    final isCompact = MediaQuery.sizeOf(context).width < 600;
    final gap = isCompact ? AppTheme.spacingM : AppTheme.spacingL;
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
              // Compact bottom bar overlays the list (extendBody); Scaffold
              // reports its height as bottom padding.
              AppTheme.spacingL + MediaQuery.paddingOf(context).bottom,
            ),
            itemBuilder: (context, index) => sections[index],
            separatorBuilder: (_, __) => SizedBox(height: gap),
            itemCount: sections.length,
          ),
        ),
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
