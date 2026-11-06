part of 'dashboard_tab.dart';

/// "Solar forecast for the next days": daily PV energy cards, own card below
/// the energy history.
class _SolarForecastSection extends StatefulWidget {
  final AppStateProvider provider;

  const _SolarForecastSection({required this.provider});

  @override
  State<_SolarForecastSection> createState() => _SolarForecastSectionState();
}

class _SolarForecastSectionState extends State<_SolarForecastSection> {
  List<DailySolarForecast> _days = const [];
  bool _isLoading = true;
  Timer? _refreshTimer;
  late int _seenManualRefresh = widget.provider.manualRefreshCount;

  @override
  void didUpdateWidget(covariant _SolarForecastSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.provider.manualRefreshCount != _seenManualRefresh) {
      _seenManualRefresh = widget.provider.manualRefreshCount;
      _fetch();
    }
  }

  @override
  void initState() {
    super.initState();
    _fetch();
    _refreshTimer = Timer.periodic(const Duration(minutes: 5), (_) => _fetch());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetch() async {
    final p = widget.provider;
    try {
      // Same arguments as the chart section: the service cache serves both.
      final days = await p.weatherService.fetchDailyForecast(
        lat: p.siteLatitude,
        lon: p.siteLongitude,
        pvCapacityW: p.pvTotalCapacityW,
        daysAhead: 16,
      );
      if (mounted) setState(() => _days = days);
    } catch (e, stack) {
      LogService.log('[forecast] fetch failed', error: e, stack: stack);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _dayLabel(DateTime date, AppLocalizations l10n) {
    if (DateUtils.isSameDay(date, DateTime.now())) return l10n.today;
    final text =
        DateFormat('EEEE d/M', Localizations.localeOf(context).toString())
            .format(date);
    return text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final expressive = context.expressive;
    final isCompact = MediaQuery.sizeOf(context).width < 600;

    final Widget body;
    if (_isLoading && _days.isEmpty) {
      body = const Center(child: CircularProgressIndicator(strokeWidth: 2));
    } else if (_days.isEmpty) {
      body = AppEmptyState(
        title: l10n.forecastNextDays,
        message: l10n.forecastUnavailable,
        icon: Icons.wb_cloudy_outlined,
      );
    } else {
      body = LayoutBuilder(
        builder: (context, constraints) {
          const spacing = AppTheme.spacingS;
          final width = constraints.maxWidth;
          final columns = width >= 980
              ? 4
              : width >= 600
                  ? 3
                  : 2;
          final cardWidth = (width - (columns - 1) * spacing) / columns;
          final previewDays = _days.take(columns == 4 ? 8 : 6);

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
                          _dayLabel(day.date, l10n),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                Formatters.formatEnergy(day.energyWh),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            WeatherIcon(code: day.weatherCode),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      );
    }

    return AppCard(
      borderRadius: expressive.cornerLarge,
      enableBlur: false,
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      padding:
          EdgeInsets.all(isCompact ? AppTheme.spacingM : AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.wb_sunny_rounded,
                  size: 20, color: theme.colorScheme.tertiary),
              const SizedBox(width: AppTheme.spacingS),
              Expanded(
                child: Text(
                  l10n.forecastNextDays,
                  style: theme.textTheme.titleMedium
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
          body,
        ],
      ),
    );
  }
}
