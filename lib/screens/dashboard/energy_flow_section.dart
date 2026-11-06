part of 'dashboard_tab.dart';

class _EnergyFlowSection extends StatelessWidget {
  final AppStateProvider provider;
  final InverterData data;

  const _EnergyFlowSection({required this.provider, required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final expressive = context.expressive;
    final lastUpdatedAt = provider.lastSuccessfulRealtimeAt;
    final lastUpdatedLabel = lastUpdatedAt == null
        ? l10n.lastRealtimeUpdate
        : '${l10n.lastRealtimeUpdate}: ${lastUpdatedAt.hour.toString().padLeft(2, '0')}:${lastUpdatedAt.minute.toString().padLeft(2, '0')}';
    final isCompact = MediaQuery.sizeOf(context).width < 600;
    return AppCard(
      borderRadius: expressive.cornerLarge,
      // Same padding as the history and forecast cards.
      padding:
          EdgeInsets.all(isCompact ? AppTheme.spacingM : AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_tree_rounded,
                size: 20,
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
                onPressed: provider.isDataLoading ? null : provider.refreshAll,
                tooltip: l10n.refreshChart,
                // Small button: a full 48 px one made the header (and the
                // card's top margin) taller than the other cards.
                style: _cardHeaderButtonStyle,
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

/// Compact (32 px) style for the icon buttons in the dashboard card headers.
final ButtonStyle _cardHeaderButtonStyle = IconButton.styleFrom(
  minimumSize: const Size(32, 32),
  fixedSize: const Size(32, 32),
  padding: EdgeInsets.zero,
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
);

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
