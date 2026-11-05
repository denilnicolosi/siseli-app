part of 'settings_tab.dart';

class _UpdateDownloadDialog extends StatefulWidget {
  final UpdateInfo info;

  const _UpdateDownloadDialog({required this.info});

  @override
  State<_UpdateDownloadDialog> createState() => _UpdateDownloadDialogState();
}

class _UpdateDownloadDialogState extends State<_UpdateDownloadDialog> {
  double _progress = 0.0;
  bool _isDone = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    unawaited(_startDownload());
  }

  Future<void> _startDownload() async {
    LogService.log(
        '📲 update.dialog download started: url=${widget.info.downloadUrl}, file=${widget.info.assetName}');
    try {
      final path = await UpdateService.downloadUpdateAsset(
        downloadUrl: widget.info.downloadUrl!,
        fileName: widget.info.assetName!,
        expectedBytes: widget.info.assetSize,
        onProgress: (value) {
          if (!mounted) return;
          setState(() {
            _progress = value.clamp(0.0, 1.0);
          });
        },
      );

      if (!mounted) return;

      if (path != null) {
        _isDone = true;
        LogService.log('✅ update.dialog download finished: path=$path');
        Navigator.of(context).pop(path);
        return;
      }

      setState(() {
        _isDone = true;
        _errorMessage =
            AppLocalizations.of(context)!.updatesDialogDownloadFailed;
      });
      LogService.log('update.dialog download finished with null path',
          level: LogLevel.warn);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isDone = true;
        _errorMessage =
            '${AppLocalizations.of(context)!.updatesDialogDownloadFailed} ($e)';
      });
      LogService.log('update.dialog exception during download',
          error: e, level: LogLevel.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canClose = _isDone;
    return PopScope(
      canPop: canClose,
      child: AlertDialog(
        title: Text(_errorMessage == null
            ? l10n.updatesDialogDownloadingTitle
            : l10n.updatesDialogDownloadFailedTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
                value: _progress > 0 && _progress < 1 ? _progress : null),
            const SizedBox(height: 12),
            Text(
              _errorMessage ??
                  (_progress > 0
                      ? '${(_progress * 100).toStringAsFixed(0)}%'
                      : l10n.updatesDialogPreparing),
            ),
            if (widget.info.assetName != null) ...[
              const SizedBox(height: 8),
              Text(
                widget.info.assetName!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
        actions: [
          if (canClose)
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.updatesDialogClose),
            ),
        ],
      ),
    );
  }
}
