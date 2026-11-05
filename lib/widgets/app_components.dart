import 'dart:ui';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

class AppShellBackground extends StatelessWidget {
  final Widget child;

  const AppShellBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final expressive = context.expressive;

    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary
                      .withValues(alpha: isDark ? 0.2 : 0.1),
                  theme.scaffoldBackgroundColor,
                  theme.colorScheme.tertiary
                      .withValues(alpha: isDark ? 0.16 : 0.08),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -130,
          left: -90,
          child: IgnorePointer(
            child: Container(
              width: 330,
              height: 330,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.pvGlowColor.withValues(alpha: isDark ? 0.2 : 0.14),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: -140,
          bottom: -120,
          child: IgnorePointer(
            child: Container(
              width: 360,
              height: 360,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.gridGlowColor
                        .withValues(alpha: isDark ? 0.22 : 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface
                    .withValues(alpha: expressive.shellBackdropOpacity * 0.08),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

// ======================== КАРТОЧКИ ========================

/// Базова карточка з тінню та радіусом
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double borderRadius;
  final bool enableBlur;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppTheme.spacingL),
    this.onTap,
    this.backgroundColor,
    this.borderRadius = AppTheme.radiusLarge,
    this.enableBlur = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = AppGlassSurface(
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      enableBlur: enableBlur,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          mouseCursor: SystemMouseCursors.click,
          hoverColor: Theme.of(context).hoverColor,
          focusColor: Theme.of(context).focusColor,
          borderRadius: BorderRadius.circular(borderRadius),
          child: content,
        ),
      );
    }

    return content;
  }
}

class AppGlassSurface extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Color? backgroundColor;
  final bool isStrong;
  final bool enableBlur;

  const AppGlassSurface({
    super.key,
    required this.child,
    this.borderRadius = AppTheme.radiusLarge,
    this.backgroundColor,
    this.isStrong = false,
    this.enableBlur = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final motion = context.motion;
    final expressive = context.expressive;
    final isDark = theme.brightness == Brightness.dark;
    final isCompact = MediaQuery.sizeOf(context).shortestSide < 600;
    // BackdropFilter / ImageFilter.blur causes EGL_CONTEXT_LOST (12302) on
    // Windows with certain GPU drivers — disable it on Windows entirely.
    // Works correctly on macOS, Linux, and web.
    final allowBackdrop = enableBlur &&
        !Platform.isWindows &&
        (kIsWeb || !(Platform.isAndroid || Platform.isIOS));
    // When blur is disabled (e.g. Windows), boost surface opacity so panel
    // remains visually solid without the blur layer.
    final opacityBoost = allowBackdrop ? 0.0 : 0.28;
    final sigma = isCompact ? (isStrong ? 5.0 : 2.5) : (isStrong ? 12.0 : 6.0);
    final lightTop = (backgroundColor ?? Colors.white).withValues(
      alpha: ((isStrong ? 0.95 : 0.84) + opacityBoost).clamp(0.0, 1.0),
    );
    final lightBottom = theme.colorScheme.surface.withValues(
      alpha: ((isStrong ? 0.88 : 0.76) + opacityBoost).clamp(0.0, 1.0),
    );

    final decoratedChild = AnimatedContainer(
      duration: motion.regular,
      curve: motion.standardCurve,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            isDark
                ? (backgroundColor ?? theme.colorScheme.surfaceContainerHighest)
                    .withValues(
                        alpha: ((isStrong
                                    ? expressive.shellBackdropOpacity + 0.08
                                    : expressive.shellBackdropOpacity - 0.02) +
                                opacityBoost)
                            .clamp(0.0, 1.0))
                : lightTop,
            isDark
                ? theme.colorScheme.surfaceContainer.withValues(
                    alpha: ((isStrong
                                ? expressive.shellBackdropOpacity
                                : expressive.shellBackdropOpacity - 0.1) +
                            opacityBoost)
                        .clamp(0.0, 1.0))
                : lightBottom,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: isStrong ? 0.18 : 0.12)
              : theme.colorScheme.outlineVariant
                  .withValues(alpha: expressive.cardBorderOpacity),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                (isDark ? Colors.black : theme.colorScheme.primary).withValues(
              alpha: isDark
                  ? (isStrong ? 0.28 : 0.22)
                  : (isStrong ? expressive.softShadowOpacity : 0.08),
            ),
            blurRadius: isStrong ? 30 : 18,
            offset: Offset(0, isStrong ? 9 : 5),
          ),
        ],
      ),
      child: child,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: allowBackdrop
          ? BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: sigma,
                sigmaY: sigma,
              ),
              child: decoratedChild,
            )
          : decoratedChild,
    );
  }
}

// ======================== СТАТУС БАНЕР ========================

class AppStatusBanner extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color? color;
  final String? meta;

  const AppStatusBanner({
    super.key,
    required this.message,
    required this.icon,
    this.color,
    this.meta,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bannerColor = color ?? theme.colorScheme.primary;

    return AppGlassSurface(
      borderRadius: AppTheme.radiusLarge,
      backgroundColor: theme.cardColor.withValues(alpha: isDark ? 0.36 : 0.62),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          gradient: LinearGradient(
            colors: [
              bannerColor.withValues(alpha: isDark ? 0.12 : 0.08),
              Colors.transparent,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 10, horizontal: AppTheme.spacingM),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: bannerColor.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999),
                  border:
                      Border.all(color: bannerColor.withValues(alpha: 0.42)),
                  boxShadow: [
                    BoxShadow(
                      color: bannerColor.withValues(alpha: isDark ? 0.28 : 0.2),
                      blurRadius: 12,
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: Icon(icon, color: bannerColor, size: 16),
              ),
              const SizedBox(width: AppTheme.spacingS),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (meta != null && meta!.trim().isNotEmpty)
                      Text(
                        meta!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================== SECTION TITLE ========================

class AppSectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;

  const AppSectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppTheme.spacingM,
        left: AppTheme.spacingXS,
        top: AppTheme.spacingS,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(context.expressive.cornerSmall),
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withValues(alpha: 0.5),
                  ),
                  child: Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
                    size: 16,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingS),
              ],
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        letterSpacing: 0.9,
                      ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppTheme.spacingXS),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

class AppSectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget child;
  final Widget? trailing;
  final double? borderRadius;
  final bool enableBlur;

  const AppSectionCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.child,
    this.trailing,
    this.borderRadius,
    this.enableBlur = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final expressive = context.expressive;
    return AppCard(
      borderRadius: borderRadius ?? expressive.cornerLarge,
      enableBlur: enableBlur,
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(expressive.cornerSmall),
                ),
                child: Icon(icon, size: 18, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: AppTheme.spacingS),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null && subtitle!.trim().isNotEmpty)
                      Text(
                        subtitle!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: AppTheme.spacingS),
                trailing!,
              ],
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          child,
        ],
      ),
    );
  }
}

class AppStatusChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const AppStatusChip({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingXS,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.32)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: AppTheme.spacingS),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ======================== STAT CARD ========================

// ======================== INFO ROW ========================

// ======================== PROGRESS BAR ========================

class AppProgressBar extends StatelessWidget {
  final String label;
  final double value;
  final double maxValue;
  final Color color;
  final String? suffix;
  final bool showPercentage;
  final String? tooltip;

  const AppProgressBar({
    super.key,
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
    this.suffix,
    this.showPercentage = true,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (value / maxValue).clamp(0.0, 1.0);

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            Text(
              '${value.toInt()} ${suffix ?? ''} / ${maxValue.toInt()}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingS),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          child: LinearProgressIndicator(
            value: percent,
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 8,
          ),
        ),
        if (showPercentage) ...[
          const SizedBox(height: AppTheme.spacingXS),
          Text(
            '${(percent * 100).toInt()}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ],
    );
    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        preferBelow: false,
        waitDuration: const Duration(milliseconds: 600),
        child: content,
      );
    }
    return content;
  }
}

// ======================== LEGEND ITEM ========================

// ======================== MODE SELECTOR BUTTON ========================

// ======================== EMPTY STATE ========================

class AppEmptyState extends StatelessWidget {
  final String title;
  final String? message;
  final IconData icon;
  final VoidCallback? onRetry;

  const AppEmptyState({
    super.key,
    required this.title,
    this.message,
    required this.icon,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            const SizedBox(height: AppTheme.spacingL),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: AppTheme.spacingS),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: AppTheme.spacingL),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(l10n?.retry ?? 'Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
