import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:window_manager/window_manager.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/app_provider.dart';
import '../../models/inverter_data.dart';
import '../../services/log_service.dart';
import '../../services/weather_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_components.dart';
import '../../widgets/energy_flow.dart';
import '../../widgets/weather_icon.dart';
import '../../utils/chart_log.dart';
import '../../utils/energy_totals.dart';
import '../../utils/formatters.dart';

part 'energy_flow_section.dart';
part 'energy_chart_section.dart';
part 'solar_forecast_section.dart';

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
      RepaintBoundary(child: _SolarForecastSection(provider: provider)),
    ];

    final isCompact = MediaQuery.sizeOf(context).width < 600;
    final gap = isCompact ? AppTheme.spacingM : AppTheme.spacingL;
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyR, control: true): () {
          if (!provider.isDataLoading) {
            unawaited(provider.refreshAll());
          }
        },
      },
      child: Focus(
        autofocus: true,
        child: RefreshIndicator(
          color: Theme.of(context).colorScheme.primary,
          onRefresh: provider.refreshAll,
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
