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
    final lastUpdatedAt = provider.lastSuccessfulRealtimeAt;
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
          const SizedBox(height: AppTheme.spacingXS),
          Text(
            l10n.dashboardAutoRefresh,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
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

/// Fullscreen helpers shared by the energy-flow and chart fullscreen views.
/// Desktop: native OS fullscreen. Mobile: immersive mode, optional landscape.
mixin _FullscreenViewMixin<T extends StatefulWidget> on State<T> {
  bool _enteredNativeFullscreen = false;

  bool get _isDesktop =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS);

  bool get _isMobile =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<void> enterFullscreen({bool landscape = false}) async {
    if (_isDesktop) {
      if (!await windowManager.isFullScreen()) {
        await windowManager.setFullScreen(true);
        _enteredNativeFullscreen = true;
      }
    } else if (_isMobile) {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      if (landscape) await lockOrientation(landscape: true);
    }
  }

  Future<void> lockOrientation({required bool landscape}) {
    if (!_isMobile) return Future.value();
    return SystemChrome.setPreferredOrientations(landscape
        ? const [
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight
          ]
        : const [DeviceOrientation.portraitUp]);
  }

  Future<void> exitFullscreen() async {
    if (_isDesktop) {
      if (_enteredNativeFullscreen) {
        _enteredNativeFullscreen = false;
        await windowManager.setFullScreen(false);
      }
    } else if (_isMobile) {
      await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  Future<void> closeFullscreen() async {
    await exitFullscreen();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    unawaited(exitFullscreen());
    super.dispose();
  }
}

class _EnergyFlowFullscreenViewState extends State<_EnergyFlowFullscreenView>
    with _FullscreenViewMixin {
  @override
  void initState() {
    super.initState();
    unawaited(enterFullscreen());
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
      (
        label: l10n.acInput,
        value: gridImport,
        icon: Icons.electric_bolt_rounded
      ),
      (
        label: l10n.battery,
        value: batteryDischarge,
        icon: Icons.battery_charging_full_rounded,
      ),
    ]..sort((a, b) => b.value.compareTo(a.value));

    final mainSource = dominant.first;

    // Leaving fullscreen on pop is handled by _FullscreenViewMixin.dispose.
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.equipmentStatus),
          actions: [
            IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: closeFullscreen,
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
                            '${l10n.mainSource}: ${mainSource.label} ${mainSource.value.toStringAsFixed(0)} W',
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
    );
  }
}
