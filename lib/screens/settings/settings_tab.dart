import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';
import '../../models/inverter_data.dart';
import '../../providers/app_provider.dart';
import '../../services/location_service.dart';
import '../../services/log_service.dart';
import '../../services/update_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_components.dart';
import '../debug_logs_screen.dart';

part 'update_dialog.dart';
part 'hardware_settings_section.dart';

class SettingsTab extends StatelessWidget {
  final AppStateProvider provider;

  const SettingsTab({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final showLanguageInSettings = MediaQuery.of(context).size.width < 980;
    final isDesktop =
        Platform.isWindows || Platform.isLinux || Platform.isMacOS;
    final isMobilePlatform = Platform.isAndroid || Platform.isIOS;
    final enableGlassBlur = !isMobilePlatform;
    final supportsInAppUpdater = Platform.isWindows || Platform.isAndroid;
    final updateBanner = _buildUpdateBanner(context, l10n);

    final isCompact = MediaQuery.sizeOf(context).width < 600;
    return ListView(
      padding: EdgeInsets.fromLTRB(
        isCompact ? 12 : 20,
        isCompact ? 8 : 20,
        isCompact ? 12 : 20,
        // extendBody puts the compact bottom bar over the list; Scaffold
        // reports its height as bottom padding.
        20 + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        _buildSectionTitle(l10n.account),
        _buildAccountCard(context, l10n),
        const SizedBox(height: 24),
        _buildSectionTitle(l10n.appSettings),
        if (supportsInAppUpdater && updateBanner != null) ...[
          updateBanner,
          const SizedBox(height: 12),
        ],
        _buildSettingsControls(
          context,
          l10n,
          theme,
          showLanguageInSettings,
          isDesktop,
          supportsInAppUpdater,
          enableGlassBlur,
        ),
        const SizedBox(height: 16),
        HardwareSettingsSection(
          provider: provider,
          enableBlur: enableGlassBlur,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Builder(
      builder: (context) => AppSectionTitle(
        title: title,
        icon: Icons.tune_rounded,
      ),
    );
  }

  Widget _buildSettingsControls(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
    bool showLanguageInSettings,
    bool isDesktop,
    bool supportsInAppUpdater,
    bool enableGlassBlur,
  ) {
    return Column(
      children: [
        AppSectionCard(
          title: l10n.appSettings,
          icon: Icons.tune_rounded,
          child: Column(
            children: [
              if (showLanguageInSettings) ...[
                _buildSettingsTile(
                  context,
                  icon: Icons.language,
                  iconColor: theme.colorScheme.primary,
                  title: l10n.language,
                  trailing: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: theme.cardColor,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      value: provider.lang,
                      items: const [
                        DropdownMenuItem(value: 'en', child: Text('English')),
                        DropdownMenuItem(
                            value: 'uk', child: Text('Українська')),
                        DropdownMenuItem(value: 'it', child: Text('Italiano')),
                      ],
                      onChanged: (val) {
                        if (val != null) provider.setLanguage(val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
              _buildSettingsTile(
                context,
                icon: Icons.palette,
                iconColor: theme.colorScheme.secondary,
                title: l10n.theme,
                trailing: Switch(
                  value: provider.themeMode == ThemeMode.dark,
                  onChanged: (_) => provider.toggleTheme(),
                ),
              ),
              if (supportsInAppUpdater) ...[
                const SizedBox(height: 10),
                _buildSettingsTile(
                  context,
                  icon: Icons.update,
                  iconColor: theme.colorScheme.primary,
                  title: l10n.updatesTitle,
                  subtitle: _buildUpdateSubtitle(l10n),
                  trailing: provider.isCheckingForUpdates
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          provider.hasPendingUpdate
                              ? Icons.system_update_alt_rounded
                              : Icons.chevron_right,
                          color: provider.hasPendingUpdate
                              ? theme.colorScheme.secondary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                  onTap: () => _checkForUpdates(context),
                ),
              ],
            ],
          ),
        ),
        if (isDesktop) ...[
          const SizedBox(height: 12),
          AppSectionCard(
            title: l10n.settings,
            subtitle: l10n.startInTraySubtitle,
            icon: Icons.desktop_windows_rounded,
            child: Column(
              children: [
                _buildSettingsSwitchTile(
                  context,
                  icon: Icons.power_settings_new,
                  title: l10n.startWithWindows,
                  value: provider.isAutostartEnabled,
                  onChanged: provider.toggleAutostart,
                ),
                const SizedBox(height: 10),
                _buildSettingsSwitchTile(
                  context,
                  icon: Icons.minimize_rounded,
                  title: l10n.startInTray,
                  subtitle: l10n.startInTraySubtitle,
                  value: provider.isStartInTrayEnabled,
                  onChanged: provider.toggleStartInTray,
                ),
              ],
            ),
          ),
        ],
        if (provider.isDeveloperMode) ...[
          const SizedBox(height: 12),
          AppSectionCard(
            title: l10n.debugLogs,
            subtitle: l10n.analyzeSystemLogs,
            icon: Icons.bug_report_rounded,
            child: _buildSettingsTile(
              context,
              icon: Icons.description_outlined,
              iconColor: theme.colorScheme.error,
              title: l10n.viewSystemLogs,
              subtitle: l10n.analyzeSystemLogs,
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _openDebugLogs(context),
            ),
          ),
        ],
        const SizedBox(height: 20),
        GestureDetector(
          onTap: provider.handleVersionClick,
          child: Center(
            child: Text(
              provider.appVersionLabel,
              style: TextStyle(
                color: Colors.grey.withValues(alpha: 0.5),
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return _buildSettingsItemShell(
      context,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Icon(
          icon,
          color: iconColor ?? Theme.of(context).colorScheme.primary,
        ),
        title: Text(title),
        subtitle: subtitle == null ? null : Text(subtitle),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  Widget _buildSettingsSwitchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return _buildSettingsItemShell(
      context,
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        secondary: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: subtitle == null ? null : Text(subtitle),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSettingsItemShell(
    BuildContext context, {
    required Widget child,
  }) {
    final expressive = context.expressive;
    return AppGlassSurface(
      borderRadius: expressive.cornerMedium,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(expressive.cornerMedium),
        child: child,
      ),
    );
  }

  Widget? _buildUpdateBanner(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final enableGlassBlur = !(Platform.isAndroid || Platform.isIOS);
    final info = provider.updateInfo;

    if (provider.isCheckingForUpdates) {
      return AppGlassSurface(
        isStrong: false,
        enableBlur: enableGlassBlur,
        borderRadius: 14,
        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(l10n.updatesCheckingBackground)),
            ],
          ),
        ),
      );
    }

    if (info == null) {
      return null;
    }

    final isSkipped = provider.skippedUpdateVersion != null &&
        info.hasUpdate &&
        provider.skippedUpdateVersion == info.latestVersion;

    if (!provider.hasPendingUpdate && !isSkipped) {
      return null;
    }

    if (isSkipped) {
      final amberColor = Theme.of(context).colorScheme.tertiary;
      return AppGlassSurface(
        enableBlur: enableGlassBlur,
        borderRadius: 14,
        backgroundColor: amberColor.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(Icons.history_toggle_off_rounded, color: amberColor),
              const SizedBox(width: 10),
              Expanded(
                child: Text(l10n.updatesSkippedBanner(info.latestVersion)),
              ),
              TextButton(
                onPressed: () async {
                  await provider.clearSkippedUpdate();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.updatesSkippedRestored)),
                    );
                  }
                },
                child: Text(l10n.updatesRestore),
              ),
            ],
          ),
        ),
      );
    }

    final successColor = Theme.of(context).colorScheme.secondary;
    return AppGlassSurface(
      enableBlur: enableGlassBlur,
      borderRadius: 14,
      backgroundColor: successColor.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.system_update_alt_rounded, color: successColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.updatesBannerAvailable(info.latestVersion),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              l10n.updatesCurrentVersion(info.currentVersion),
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () => _showUpdateAvailableDialog(context, info),
                  icon: const Icon(Icons.visibility_rounded, size: 16),
                  label: Text(l10n.updatesView),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () async {
                    await provider.skipLatestUpdate();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text(l10n.updatesSkippedNow(info.latestVersion)),
                        ),
                      );
                    }
                  },
                  child: Text(l10n.updatesSkip),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final enableGlassBlur = !(Platform.isAndroid || Platform.isIOS);

    final displayName =
        provider.displayName.trim().isNotEmpty && provider.displayName != 'N/A'
            ? provider.displayName
            : (provider.userName?.trim().isNotEmpty ?? false)
                ? provider.userName!.trim()
                : l10n.userNameDefault;

    final email = provider.displayEmail.trim().isNotEmpty
        ? provider.displayEmail.trim()
        : (provider.savedEmail?.trim().isNotEmpty ?? false)
            ? provider.savedEmail!.trim()
            : l10n.notProvided;

    final phone = provider.displayPhone.trim().isNotEmpty
        ? provider.displayPhone.trim()
        : l10n.notProvided;

    final uid = provider.userData?['uid']?.toString().trim();
    final cloudAccount = provider.displayAccount.trim().isNotEmpty &&
            provider.displayAccount != 'N/A'
        ? provider.displayAccount
        : l10n.unknownValue;

    final statusLabel = provider.userData == null
        ? l10n.accountStatusLocal
        : l10n.accountStatusSynced;

    return AppGlassSurface(
      isStrong: true,
      enableBlur: enableGlassBlur,
      borderRadius: 24,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      child: Icon(Icons.person, size: 30),
                    ),
                    Positioned(
                      right: -3,
                      bottom: -3,
                      child: InkWell(
                        onTap: () => _showEditProfileDialog(context),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit,
                              size: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: TextStyle(
                          color: theme.textTheme.bodySmall?.color,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: provider.userData == null
                              ? theme.colorScheme.errorContainer
                              : theme.colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          statusLabel,
                          style: TextStyle(
                            color: provider.userData == null
                                ? theme.colorScheme.onErrorContainer
                                : theme.colorScheme.onSecondaryContainer,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            AppGlassSurface(
              enableBlur: enableGlassBlur,
              borderRadius: 14,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    _buildAccountInfoRow(
                      context,
                      label: l10n.cloudAccount,
                      value: cloudAccount,
                      icon: Icons.cloud_done_rounded,
                    ),
                    _buildAccountInfoRow(
                      context,
                      label: l10n.phoneLabel,
                      value: phone,
                      icon: Icons.phone_outlined,
                    ),
                    _buildAccountInfoRow(
                      context,
                      label: 'UID',
                      value: (uid?.isNotEmpty ?? false) ? uid! : '...',
                      icon: Icons.badge_outlined,
                      monospace: true,
                      onCopy: () => _copyToClipboard(
                        context,
                        (uid?.isNotEmpty ?? false) ? uid! : null,
                      ),
                    ),
                    _buildAccountInfoRow(
                      context,
                      label: l10n.sessionId,
                      value: provider.userId,
                      icon: Icons.fingerprint,
                      monospace: true,
                      onCopy: () => _copyToClipboard(context, provider.userId),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              l10n.accountProfileHint,
              style: TextStyle(
                fontSize: 12,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showEditProfileDialog(context),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: Text(l10n.editProfile),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _confirmLogout(context),
                    icon: Icon(
                      Icons.logout_rounded,
                      size: 18,
                      color: theme.colorScheme.error,
                    ),
                    label: Text(
                      l10n.logout,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountInfoRow(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    bool monospace = false,
    VoidCallback? onCopy,
  }) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon,
              size: 17, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: textStyle?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: textStyle?.copyWith(
                fontWeight: FontWeight.w600,
                fontFamily: monospace ? 'monospace' : null,
              ),
            ),
          ),
          if (onCopy != null) ...[
            const SizedBox(width: 4),
            IconButton(
              onPressed: onCopy,
              splashRadius: 16,
              icon: const Icon(Icons.copy_rounded, size: 16),
              color: Theme.of(context).textTheme.bodySmall?.color,
              tooltip: AppLocalizations.of(context)!.copy,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _copyToClipboard(BuildContext context, String? value) async {
    if (value == null || value.trim().isEmpty || value.trim() == '...') return;
    await Clipboard.setData(ClipboardData(text: value.trim()));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.copiedToClipboard)),
    );
  }

  void _openDebugLogs(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const DebugLogsScreen(),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final expressive = context.expressive;
    final controller = TextEditingController(text: provider.userName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(expressive.cornerLarge),
        ),
        title: Text(l10n.editProfile),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: l10n.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.nameCannotBeEmpty),
                  ),
                );
                return;
              }

              provider.updateProfile(name);
              Navigator.pop(context);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.logoutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await provider.logout();
    }
  }

  void _checkForUpdates(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final info = await provider.checkForUpdates(force: true);

    if (info.hasUpdate) {
      if (!context.mounted) return;
      await _showUpdateAvailableDialog(context, info);
    } else {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(l10n.updatesSubtitleUpToDate(info.currentVersion)),
        ),
      );
    }
  }

  Future<void> _showUpdateAvailableDialog(
      BuildContext context, UpdateInfo info) async {
    final l10n = AppLocalizations.of(context)!;
    final parentContext = context;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.updatesDialogAvailableTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.updatesDialogCurrent(info.currentVersion)),
            Text(l10n.updatesDialogLatest(info.latestVersion)),
            const SizedBox(height: 8),
            Text(l10n.updatesDialogPublished(
                UpdateService.formatPublishedAt(info.publishedAt))),
            if (info.assetName != null) ...[
              const SizedBox(height: 4),
              Text(l10n.updatesDialogPackage(info.assetName!)),
            ],
            if ((info.releaseNotes ?? '').trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                (info.releaseNotes!.trim().length > 220)
                    ? '${info.releaseNotes!.trim().substring(0, 220)}...'
                    : info.releaseNotes!.trim(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await provider.skipLatestUpdate();
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: Text(l10n.updatesDialogSkipVersion),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.updatesDialogLater),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _downloadAndInstallUpdate(parentContext, info);
            },
            icon: const Icon(Icons.download_rounded),
            label: Text(l10n.updatesDialogDownload),
          ),
        ],
      ),
    );
  }

  /// Download + install straight away (used by the update notification).
  static Future<void> startUpdate(
      BuildContext context, AppStateProvider provider) async {
    var info = provider.updateInfo;
    if (info == null || !info.hasUpdate) {
      info = await provider.checkForUpdates(force: true);
    }
    if (!context.mounted) return;
    if (!info.hasUpdate) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!
            .updatesSubtitleUpToDate(info.currentVersion)),
      ));
      return;
    }
    await SettingsTab(provider: provider)
        ._downloadAndInstallUpdate(context, info);
  }

  Future<void> _downloadAndInstallUpdate(
      BuildContext context, UpdateInfo info) async {
    final l10n = AppLocalizations.of(context)!;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (info.downloadUrl == null || info.assetName == null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(l10n.updatesNoInstallerFound),
        ),
      );
      return;
    }

    LogService.log(
        '📲 update.ui starting download dialog: version=${info.latestVersion}, asset=${info.assetName}');

    final path = await showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _UpdateDownloadDialog(info: info),
    );

    if (!context.mounted) return;

    if (path != null) {
      LogService.log('✅ update.ui download dialog completed: path=$path');
      final shouldInstall = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(l10n.updatesDialogInstallTitle),
          content: Text(l10n.updatesDialogInstallPrompt(info.latestVersion)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.updatesDialogInstall),
            ),
          ],
        ),
      );

      if (!context.mounted || shouldInstall != true) {
        LogService.log('update.ui install canceled by user');
        return;
      }

      LogService.log(
          'update.ui install confirmed: version=${info.latestVersion}, path=$path');
      final result = await UpdateService.installUpdate(path);
      if (result == UpdateInstallResult.started) {
        if (Platform.isAndroid) {
          // Android: system installer dialog overlays the app - stay open.
          LogService.log(
              'update.ui Android installer launched, returning to app');
          scaffoldMessenger.showSnackBar(
            SnackBar(content: Text(l10n.updatesDialogInstall)),
          );
        } else {
          LogService.log(
              'update.ui installer started successfully, exiting app');
          exit(0);
        }
      } else {
        LogService.log(
            'update.ui install not started ($result) for path=$path');
        final failMessage = result == UpdateInstallResult.needsPermission
            ? l10n.updatesInstallPermissionNeeded
            : Platform.isAndroid
                ? '${l10n.updatesDialogInstallFailed}\nAPK: $path'
                : l10n.updatesDialogInstallFailed;
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(failMessage),
            duration: const Duration(seconds: 15),
            action: Platform.isAndroid
                ? SnackBarAction(
                    label: l10n.updatesDialogInstall,
                    // Retry from the already-downloaded APK, no re-download.
                    onPressed: () =>
                        unawaited(UpdateService.installUpdate(path)),
                  )
                : null,
          ),
        );
      }
    } else {
      LogService.log(
          'update.ui download dialog finished without file path: version=${info.latestVersion}',
          level: LogLevel.warn);
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(l10n.updatesDialogDownloadFailed)),
      );
    }
  }

  String _buildUpdateSubtitle(AppLocalizations l10n) {
    final info = provider.updateInfo;
    if (provider.isCheckingForUpdates) {
      return l10n.updatesChecking;
    }
    if (info == null) {
      return l10n.updatesSubtitleDefault;
    }
    if (provider.hasPendingUpdate) {
      return l10n.updatesSubtitleAvailable(info.latestVersion);
    }
    if (provider.skippedUpdateVersion != null &&
        info.hasUpdate &&
        info.latestVersion == provider.skippedUpdateVersion) {
      return l10n.updatesSubtitleSkipped(info.latestVersion);
    }
    return l10n.updatesSubtitleUpToDate(info.currentVersion);
  }
}
