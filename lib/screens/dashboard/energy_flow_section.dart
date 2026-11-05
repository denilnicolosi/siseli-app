part of 'dashboard_tab.dart';

class _EnergyFlowSection extends StatelessWidget {
  final AppStateProvider provider;
  final InverterData data;

  const _EnergyFlowSection({required this.provider, required this.data});

  Future<void> _openEnergyFlowFullscreen(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return _EnergyFlowFullscreenView(data: data);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final expressive = context.expressive;
    final isGridOutage = provider.isGridOutageDetected;
    final lastUpdatedAt = provider.lastSuccessfulRealtimeAt;
    final backupHours = provider.estimateBackupHoursRemaining();
    final batteryOnlyHours = provider.estimateBatteryOnlyHoursRemaining();
    final lastUpdatedLabel = lastUpdatedAt == null
        ? l10n.lastRealtimeUpdate
        : '${l10n.lastRealtimeUpdate}: ${lastUpdatedAt.hour.toString().padLeft(2, '0')}:${lastUpdatedAt.minute.toString().padLeft(2, '0')}';
    return AppCard(
      borderRadius: expressive.cornerLarge,
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_tree_rounded,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: AppTheme.spacingS),
              Expanded(
                child: Text(
                  l10n.equipmentStatus,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingS),
              IconButton.filledTonal(
                onPressed: provider.isDataLoading ? null : provider.fetchData,
                tooltip: l10n.refreshChart,
                icon: AnimatedSwitcher(
                  duration: context.motion.quick,
                  child: provider.isDataLoading
                      ? SizedBox(
                          key: const ValueKey('refresh-loading'),
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.primary,
                          ),
                        )
                      : const Icon(
                          Icons.refresh_rounded,
                          key: ValueKey('refresh-icon'),
                          size: 18,
                        ),
                ),
              ),
              IconButton.filledTonal(
                onPressed: () => _openEnergyFlowFullscreen(context),
                icon: const Icon(Icons.open_in_full_rounded, size: 18),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingXS),
          Text(
            lastUpdatedLabel,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (isGridOutage) ...[
            const SizedBox(height: AppTheme.spacingM),
            _GridOutageRuntimeBanner(
              voltage: data.gridVoltage,
              backupHours: backupHours,
              batteryOnlyHours: batteryOnlyHours,
              isSolarCoveringLoad: provider.isLoadCoveredBySolarNow,
            ),
          ],
          const SizedBox(height: AppTheme.spacingM),
          RepaintBoundary(
            child: ExcludeSemantics(child: EnergyFlowDiagram(data: data)),
          ),
        ],
      ),
    );
  }
}

class _EnergyFlowFullscreenView extends StatefulWidget {
  final InverterData data;

  const _EnergyFlowFullscreenView({required this.data});

  @override
  State<_EnergyFlowFullscreenView> createState() =>
      _EnergyFlowFullscreenViewState();
}

class _EnergyFlowFullscreenViewState extends State<_EnergyFlowFullscreenView> {
  bool _enteredNativeFullscreen = false;
  bool _wasNativeFullscreen = false;

  bool get _supportsNativeFullscreen {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS;
  }

  @override
  void initState() {
    super.initState();
    // Enter native OS fullscreen so the view fills the monitor, not only app layout.
    unawaited(_enterNativeFullscreen());
  }

  Future<void> _enterNativeFullscreen() async {
    if (!_supportsNativeFullscreen) return;
    final isFull = await windowManager.isFullScreen();
    _wasNativeFullscreen = isFull;
    if (!isFull) {
      await windowManager.setFullScreen(true);
      _enteredNativeFullscreen = true;
    }
  }

  Future<void> _restoreNativeFullscreen() async {
    if (!_supportsNativeFullscreen) return;
    if (_enteredNativeFullscreen && !_wasNativeFullscreen) {
      await windowManager.setFullScreen(false);
    }
  }

  Future<void> _closeView() async {
    await _restoreNativeFullscreen();
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    unawaited(_restoreNativeFullscreen());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final gridImport = math.max(widget.data.gridPower, 0.0);
    final batteryDischarge = math.max(-widget.data.batteryPower, 0.0);
    final solar = math.max(widget.data.pvPower, 0.0);

    final dominant = [
      (label: l10n.solar, value: solar, icon: Icons.solar_power_rounded),
      (label: l10n.grid, value: gridImport, icon: Icons.electric_bolt_rounded),
      (
        label: l10n.battery,
        value: batteryDischarge,
        icon: Icons.battery_charging_full_rounded,
      ),
    ]..sort((a, b) => b.value.compareTo(a.value));

    final mainSource = dominant.first;

    return Dialog.fullscreen(
      child: WillPopScope(
        onWillPop: () async {
          await _restoreNativeFullscreen();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(l10n.equipmentStatus),
            actions: [
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: _closeView,
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppCard(
                    borderRadius: context.expressive.cornerMedium,
                    enableBlur: false,
                    backgroundColor: theme.colorScheme.surfaceContainerLow,
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    child: Wrap(
                      spacing: AppTheme.spacingM,
                      runSpacing: AppTheme.spacingS,
                      children: [
                        _DashboardPill(
                          icon: mainSource.icon,
                          label:
                              'Main source: ${mainSource.label} ${mainSource.value.toStringAsFixed(0)} W',
                          color: theme.colorScheme.primary,
                        ),
                        _DashboardPill(
                          icon: Icons.home_rounded,
                          label:
                              '${l10n.load}: ${widget.data.loadPower.toStringAsFixed(0)} W',
                          color: AppTheme.loadColor,
                        ),
                        _DashboardPill(
                          icon: Icons.battery_6_bar_rounded,
                          label:
                              '${l10n.battery}: ${widget.data.batterySoc.toStringAsFixed(0)}% (${widget.data.batteryPower.toStringAsFixed(0)} W)',
                          color: AppTheme.batteryColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  Expanded(
                    child: SingleChildScrollView(
                      child: EnergyFlowDiagram(
                        data: widget.data,
                        showInteractiveToolbar: true,
                        autofocusShortcuts: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GridOutageRuntimeBanner extends StatelessWidget {
  final double voltage;
  final double? backupHours;
  final double? batteryOnlyHours;
  final bool isSolarCoveringLoad;

  const _GridOutageRuntimeBanner({
    required this.voltage,
    required this.backupHours,
    required this.batteryOnlyHours,
    required this.isSolarCoveringLoad,
  });

  String _formatHoursLabel(AppLocalizations l10n, double? hours) {
    if (hours == null) return '--';
    if (hours.isInfinite) return l10n.runtimeInfinite;
    if (hours <= 0.02) return l10n.runtimeNow;
    if (hours < 1.0) {
      final mins = (hours * 60).round().clamp(1, 59);
      return l10n.runtimeMinutes(mins.toString());
    }
    final h = hours.floor();
    final mins = ((hours - h) * 60).round();
    if (mins <= 0) return l10n.runtimeHoursOnly(h.toString());
    return l10n.runtimeHoursMinutes(h.toString(), mins.toString());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final effectiveBackupLabel = _formatHoursLabel(l10n, backupHours);
    final batteryOnlyLabel = _formatHoursLabel(l10n, batteryOnlyHours);

    return AppCard(
      borderRadius: context.expressive.cornerMedium,
      enableBlur: false,
      backgroundColor: theme.colorScheme.errorContainer.withValues(alpha: 0.58),
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.power_off_rounded,
                color: theme.colorScheme.onErrorContainer,
              ),
              const SizedBox(width: AppTheme.spacingS),
              Expanded(
                child: Text(
                  l10n.gridOutageVisualTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingXS),
          Text(
            l10n.gridOutageVisualBody(voltage.toStringAsFixed(0)),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onErrorContainer,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            l10n.backupRuntimeHybrid(effectiveBackupLabel),
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onErrorContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppTheme.spacingXS),
          Text(
            l10n.backupRuntimeBatteryOnly(batteryOnlyLabel),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onErrorContainer,
            ),
          ),
          if (isSolarCoveringLoad) ...[
            const SizedBox(height: AppTheme.spacingXS),
            Text(
              l10n.backupRuntimeSolarCoverHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
