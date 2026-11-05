import 'dart:io' show Platform;
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/inverter_data.dart';
import '../theme/app_theme.dart';
import '../utils/inverter_reading_info.dart';

/// True when BackdropFilter / ImageFilter.blur should be disabled.
/// Disabled on mobile (low GPU bandwidth) and Windows (EGL_CONTEXT_LOST 12302).
bool get _isMobilePlatform =>
    !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isWindows);

class EnergyFlowDiagram extends StatefulWidget {
  final InverterData data;

  const EnergyFlowDiagram({super.key, required this.data});

  @override
  State<EnergyFlowDiagram> createState() => _EnergyFlowDiagramState();
}

class _FlowSnapshot {
  final double pvPowerW;
  final double loadPowerW;
  final double gridImportW;
  final double gridExportW;
  final double batteryChargeW;
  final double batteryDischargeW;
  final double solarToLoadW;
  final double solarToBatteryW;
  final double solarToGridW;
  final double batteryToLoadW;
  final double gridToLoadW;
  final double gridToBatteryW;
  final double balanceErrorW;

  const _FlowSnapshot({
    required this.pvPowerW,
    required this.loadPowerW,
    required this.gridImportW,
    required this.gridExportW,
    required this.batteryChargeW,
    required this.batteryDischargeW,
    required this.solarToLoadW,
    required this.solarToBatteryW,
    required this.solarToGridW,
    required this.batteryToLoadW,
    required this.gridToLoadW,
    required this.gridToBatteryW,
    required this.balanceErrorW,
  });

  factory _FlowSnapshot.fromData(InverterData data) {
    final pv = data.pvPower.clamp(0.0, 50000.0).toDouble();
    final load = data.loadPower.clamp(0.0, 50000.0).toDouble();
    final gridImport = math.max(data.gridPower, 0.0).clamp(0.0, 50000.0);
    final gridExport = math.max(-data.gridPower, 0.0).clamp(0.0, 50000.0);
    final batteryCharge = math.max(data.batteryPower, 0.0).clamp(0.0, 50000.0);
    final batteryDischarge =
        math.max(-data.batteryPower, 0.0).clamp(0.0, 50000.0);

    final solarToLoad = math.min(pv, load);
    final remainingLoadAfterSolar = math.max(load - solarToLoad, 0.0);
    final batteryToLoad = math.min(batteryDischarge, remainingLoadAfterSolar);
    final remainingLoad =
        math.max(remainingLoadAfterSolar - batteryToLoad, 0.0);
    final gridToLoad = math.min(gridImport, remainingLoad);

    final solarExcess = math.max(pv - solarToLoad, 0.0);
    final solarToBattery = math.min(solarExcess, batteryCharge);
    // Only measured export counts as solar -> AC; unexplained PV surplus
    // (inverter self-use, losses) stays in the Δ balance chip. Off-grid
    // there is no export at all.
    final solarToGrid = gridExport.toDouble();
    final gridToBattery = math.max(gridImport - gridToLoad, 0.0);

    final balanceError = (pv + gridImport + batteryDischarge) -
        (load + batteryCharge + gridExport);

    return _FlowSnapshot(
      pvPowerW: pv,
      loadPowerW: load,
      gridImportW: gridImport,
      gridExportW: gridExport,
      batteryChargeW: batteryCharge,
      batteryDischargeW: batteryDischarge,
      solarToLoadW: solarToLoad,
      solarToBatteryW: solarToBattery,
      solarToGridW: solarToGrid,
      batteryToLoadW: batteryToLoad,
      gridToLoadW: gridToLoad,
      gridToBatteryW: gridToBattery,
      balanceErrorW: balanceError,
    );
  }

  bool get balanceStable => balanceErrorW.abs() <= 120.0;
}

enum _InteractiveFlowLink {
  solarToLoad,
  solarToBattery,
  batteryToLoad,
  gridToLoad,
  gridToBattery,
  solarToGrid,
}

/// Diagram node the user can tap to see its readings.
enum _FlowNode { solar, acInput, battery, load, inverter }

/// Realtime API fields that describe the current state of each node, in
/// display order. Settings and ratings (charge voltages, priorities,
/// nominal values, firmware) are left out: they are in the Data tab.
const _liveKeys = <_FlowNode, List<String>>{
  _FlowNode.solar: [
    'pvInputVoltage',
    'pvInputCurrent',
    'photovoltaicAccessFlag',
    'pvStatuss',
  ],
  _FlowNode.acInput: [
    'acInputVoltage',
    'acInputFrequency',
    'gridState',
    'mainsRelayStatus',
    'feedInPower',
  ],
  _FlowNode.battery: [
    'batteryVoltage',
    'batteryChargingCurrent',
    'batteryDischargeCurrent',
    'batState',
  ],
  _FlowNode.load: [
    'outputVoltage',
    'outputFrequency',
    'outputApparentPower',
    'loadPercentage',
    'loadStatus',
    'outputRelayStatus',
  ],
  _FlowNode.inverter: [
    'workingStates',
    'ntcMaximumTemperature',
  ],
};

class _EnergyFlowDiagramState extends State<EnergyFlowDiagram>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  _InteractiveFlowLink? _selectedLink;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 8))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 430;
    final snapshot = _FlowSnapshot.fromData(widget.data);
    final batterySoc = widget.data.batterySoc.toInt();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? const Color(0xFF0D172B) : const Color(0xFFF4F8FC);

    if (!_controller.isAnimating) {
      _controller.repeat();
    }
    final animation = _controller;

    // On mobile platforms disable heavy blur effects to keep rendering smooth.
    final enableBlur = !_isMobilePlatform;
    final selectedLink =
        _isLinkVisible(snapshot, _selectedLink) ? _selectedLink : null;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Stack(
            children: [
              Container(
                height: compact ? 252 : 280,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      base.withValues(alpha: 0.94),
                      Theme.of(context)
                          .cardColor
                          .withValues(alpha: isDark ? 0.78 : 0.92),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: enableBlur
                      ? [
                          BoxShadow(
                            color: (isDark ? Colors.black : Colors.blueGrey)
                                .withValues(alpha: isDark ? 0.35 : 0.1),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ]
                      : null,
                ),
              ),
              if (enableBlur && !compact)
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                    child: const SizedBox.expand(),
                  ),
                ),
              Positioned.fill(
                child: RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: animation,
                    child: _buildNodes(
                      context,
                      snapshot,
                      batterySoc,
                      selectedLink,
                      compact: compact,
                      enableBlur: enableBlur,
                    ),
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _FlowPainter(
                          animationValue: animation.value,
                          pvPower: snapshot.pvPowerW,
                          gridImportPower: snapshot.gridImportW,
                          gridExportPower: snapshot.gridExportW,
                          batteryChargePower: snapshot.batteryChargeW,
                          batteryDischargePower: snapshot.batteryDischargeW,
                          loadPower: snapshot.loadPowerW,
                          selectedLink: selectedLink,
                          isDark: isDark,
                          // Reduce extra blur strokes on mobile but keep particles.
                          reduceEffects: !enableBlur,
                        ),
                        child: child,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _FlowLegendBar(
          snapshot: snapshot,
          selectedLink: selectedLink,
          onSelectLink: (link) => setState(
            () => _selectedLink = _selectedLink == link ? null : link,
          ),
        ),
      ],
    );
  }

  Widget _buildNodes(BuildContext context, _FlowSnapshot snapshot,
      int batterySoc, _InteractiveFlowLink? selectedLink,
      {required bool compact, required bool enableBlur}) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: _NodeWidget(
              icon: Icons.solar_power_rounded,
              color: AppTheme.pvColor,
              title: l10n.solar,
              value: '${snapshot.pvPowerW.toStringAsFixed(0)} W',
              selected: selectedLink == _InteractiveFlowLink.solarToLoad ||
                  selectedLink == _InteractiveFlowLink.solarToBattery ||
                  selectedLink == _InteractiveFlowLink.solarToGrid,
              onTap: () => _showNodeDetails(_FlowNode.solar, snapshot),
              compact: compact,
              enableBlur: enableBlur,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: _NodeWidget(
              icon: Icons.electric_bolt_rounded,
              color: AppTheme.gridColor,
              title: l10n.acInput,
              value: _gridNodeLabel(snapshot),
              selected: selectedLink == _InteractiveFlowLink.gridToLoad ||
                  selectedLink == _InteractiveFlowLink.gridToBattery ||
                  selectedLink == _InteractiveFlowLink.solarToGrid,
              onTap: () => _showNodeDetails(_FlowNode.acInput, snapshot),
              compact: compact,
              enableBlur: enableBlur,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: _NodeWidget(
              icon: Icons.battery_charging_full_rounded,
              color: AppTheme.batteryColor,
              title: l10n.battery,
              value: '$batterySoc% ${_batteryNodeLabel(snapshot)}',
              selected: selectedLink == _InteractiveFlowLink.solarToBattery ||
                  selectedLink == _InteractiveFlowLink.gridToBattery ||
                  selectedLink == _InteractiveFlowLink.batteryToLoad,
              onTap: () => _showNodeDetails(_FlowNode.battery, snapshot),
              compact: compact,
              enableBlur: enableBlur,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: _NodeWidget(
              icon: Icons.home_rounded,
              color: AppTheme.loadColor,
              title: l10n.consumption,
              value: '${snapshot.loadPowerW.toStringAsFixed(0)} W',
              selected: selectedLink == _InteractiveFlowLink.solarToLoad ||
                  selectedLink == _InteractiveFlowLink.batteryToLoad ||
                  selectedLink == _InteractiveFlowLink.gridToLoad,
              onTap: () => _showNodeDetails(_FlowNode.load, snapshot),
              compact: compact,
              enableBlur: enableBlur,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: _CoreHub(
              animation: _controller,
              compact: compact,
              label: l10n.flowInverter,
              onTap: () => _showNodeDetails(_FlowNode.inverter, snapshot),
            ),
          ),
        ],
      ),
    );
  }

  /// Popup with the live readings of [node]: the values the diagram shows
  /// first, then the API fields listed in [_liveKeys].
  void _showNodeDetails(_FlowNode node, _FlowSnapshot snapshot) {
    final l10n = AppLocalizations.of(context)!;
    final data = widget.data;
    String w(double v) => '${v.toStringAsFixed(0)} W';

    final (title, icon, color) = switch (node) {
      _FlowNode.solar => (
          l10n.solar,
          Icons.solar_power_rounded,
          AppTheme.pvColor
        ),
      _FlowNode.acInput => (
          l10n.acInput,
          Icons.electric_bolt_rounded,
          AppTheme.gridColor
        ),
      _FlowNode.battery => (
          l10n.battery,
          Icons.battery_charging_full_rounded,
          AppTheme.batteryColor
        ),
      _FlowNode.load => (
          l10n.consumption,
          Icons.home_rounded,
          AppTheme.loadColor
        ),
      _FlowNode.inverter => (l10n.flowInverter, null, AppTheme.gridColor),
    };

    final summary = <(String, String)>[
      ...switch (node) {
        _FlowNode.solar => [(l10n.flowPower, w(snapshot.pvPowerW))],
        _FlowNode.acInput => [(l10n.flowPower, _gridNodeLabel(snapshot))],
        _FlowNode.battery => [
            (l10n.rdBatteryCapacity, '${data.batterySoc.toStringAsFixed(0)} %'),
            (l10n.flowPower, _batteryNodeLabel(snapshot)),
          ],
        _FlowNode.load => [(l10n.flowPower, w(snapshot.loadPowerW))],
        _FlowNode.inverter => [
            (
              snapshot.balanceErrorW >= 0 ? l10n.flowLosses : l10n.flowMismatch,
              w(snapshot.balanceErrorW.abs()),
            ),
          ],
      },
    ];
    final readings = <({String name, String value, String? description})>[];
    for (final key in _liveKeys[node]!) {
      if (!data.rawFields.containsKey(key)) continue;
      final field = data.rawFields[key];
      var name = key;
      var value = '-';
      var unit = '';
      if (field is Map) {
        name = field['nameDisplay']?.toString() ??
            field['name']?.toString() ??
            name;
        value = field['valueDisplay']?.toString() ??
            field['value']?.toString() ??
            '-';
        unit = field['unit']?.toString() ?? '';
      } else if (field != null) {
        value = field.toString();
      }
      final info = inverterReadingInfo(l10n, key);
      value = translateReadingValue(l10n, value);
      readings.add((
        name: info?.name ?? name,
        value: (unit.isNotEmpty && unit != 'null') ? '$value $unit' : value,
        description: info?.description,
      ));
    }

    showDialog<void>(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        Widget row(String name, String value,
                {String? description, bool strong = false}) =>
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              title: Text(name, style: theme.textTheme.bodyMedium),
              trailing: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 160),
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: strong ? color : theme.colorScheme.primary,
                  ),
                ),
              ),
              onTap: description == null
                  ? null
                  : () => showDialog<void>(
                        context: ctx,
                        builder: (c) => AlertDialog(
                          title:
                              Text(name, style: const TextStyle(fontSize: 16)),
                          content: Text(description),
                        ),
                      ),
            );
        return AlertDialog(
          title: Row(
            children: [
              icon == null
                  ? _InverterIcon(size: 24, color: color)
                  : Icon(icon, color: color),
              const SizedBox(width: 8),
              Expanded(child: Text(title)),
            ],
          ),
          content: SizedBox(
            width: 380,
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final (name, value) in summary)
                  row(name, value, strong: true),
                if (readings.isNotEmpty) const Divider(),
                for (final r in readings)
                  row(r.name, r.value, description: r.description),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(MaterialLocalizations.of(ctx).closeButtonLabel),
            ),
          ],
        );
      },
    );
  }

  String _gridNodeLabel(_FlowSnapshot snapshot) {
    if (snapshot.gridImportW > 25.0) {
      return 'IN ${snapshot.gridImportW.toStringAsFixed(0)} W';
    }
    if (snapshot.gridExportW > 25.0) {
      return 'OUT ${snapshot.gridExportW.toStringAsFixed(0)} W';
    }
    return '0 W';
  }

  String _batteryNodeLabel(_FlowSnapshot snapshot) {
    if (snapshot.batteryChargeW > 25.0) {
      return '↑${snapshot.batteryChargeW.toStringAsFixed(0)}W';
    }
    if (snapshot.batteryDischargeW > 25.0) {
      return '↓${snapshot.batteryDischargeW.toStringAsFixed(0)}W';
    }
    return '•0W';
  }

  bool _isLinkVisible(_FlowSnapshot snapshot, _InteractiveFlowLink? link) {
    if (link == null) return true;
    const threshold = 20.0;
    return switch (link) {
      _InteractiveFlowLink.solarToLoad => snapshot.solarToLoadW > threshold,
      _InteractiveFlowLink.solarToBattery =>
        snapshot.solarToBatteryW > threshold,
      _InteractiveFlowLink.batteryToLoad => snapshot.batteryToLoadW > threshold,
      _InteractiveFlowLink.gridToLoad => snapshot.gridToLoadW > threshold,
      _InteractiveFlowLink.gridToBattery => snapshot.gridToBatteryW > threshold,
      _InteractiveFlowLink.solarToGrid => snapshot.solarToGridW > threshold,
    };
  }
}

class _FlowLegendBar extends StatelessWidget {
  final _FlowSnapshot snapshot;
  final _InteractiveFlowLink? selectedLink;
  final ValueChanged<_InteractiveFlowLink> onSelectLink;

  const _FlowLegendBar({
    required this.snapshot,
    required this.selectedLink,
    required this.onSelectLink,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    const threshold = 20.0;

    final entries = <({
      IconData icon,
      Color color,
      String text,
      double power,
      _InteractiveFlowLink link,
    })>[
      (
        icon: Icons.solar_power_rounded,
        color: AppTheme.pvColor,
        text: '${l10n.solar} -> ${l10n.consumption}',
        power: snapshot.solarToLoadW,
        link: _InteractiveFlowLink.solarToLoad,
      ),
      (
        icon: Icons.battery_charging_full_rounded,
        color: AppTheme.batteryColor,
        text: '${l10n.solar} -> ${l10n.battery}',
        power: snapshot.solarToBatteryW,
        link: _InteractiveFlowLink.solarToBattery,
      ),
      (
        icon: Icons.home_rounded,
        color: AppTheme.loadColor,
        text: '${l10n.battery} -> ${l10n.consumption}',
        power: snapshot.batteryToLoadW,
        link: _InteractiveFlowLink.batteryToLoad,
      ),
      (
        icon: Icons.electric_bolt_rounded,
        color: AppTheme.gridColor,
        text: '${l10n.acInput} -> ${l10n.consumption}',
        power: snapshot.gridToLoadW,
        link: _InteractiveFlowLink.gridToLoad,
      ),
      (
        icon: Icons.battery_full_rounded,
        color: AppTheme.gridColor,
        text: '${l10n.acInput} -> ${l10n.battery}',
        power: snapshot.gridToBatteryW,
        link: _InteractiveFlowLink.gridToBattery,
      ),
      (
        icon: Icons.upload_rounded,
        color: AppTheme.gridColor,
        text: '${l10n.solar} -> ${l10n.acInput}',
        power: snapshot.solarToGridW,
        link: _InteractiveFlowLink.solarToGrid,
      ),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final e in entries)
          if (e.power > threshold)
            _FlowLegendChip(
              icon: e.icon,
              color: e.color,
              label: '${e.text}: ${e.power.toStringAsFixed(0)} W',
              selected: selectedLink == e.link,
              onTap: () => onSelectLink(e.link),
            ),
        // Δ = power in (PV + AC + battery discharge) − power out (loads +
        // battery charge + export). Positive: inverter self-use and
        // conversion losses. Negative: the readings do not add up.
        Tooltip(
          message: snapshot.balanceErrorW >= 0
              ? l10n.flowLossesHint
              : l10n.flowMismatchHint,
          triggerMode: TooltipTriggerMode.tap,
          showDuration: const Duration(seconds: 6),
          child: _FlowLegendChip(
            icon: snapshot.balanceErrorW >= 0
                ? Icons.local_fire_department_rounded
                : Icons.compare_arrows_rounded,
            color: snapshot.balanceStable
                ? theme.colorScheme.onSurfaceVariant
                : theme.colorScheme.error,
            label:
                '${snapshot.balanceErrorW >= 0 ? l10n.flowLosses : l10n.flowMismatch}: '
                '${snapshot.balanceErrorW.abs().toStringAsFixed(0)} W',
          ),
        ),
      ],
    );
  }
}

class _FlowLegendChip extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _FlowLegendChip({
    required this.icon,
    required this.color,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: selected
                ? color.withValues(alpha: 0.18)
                : theme.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(999),
            border: selected
                ? Border.all(color: color.withValues(alpha: 0.65))
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CoreHub extends StatelessWidget {
  final AnimationController animation;
  final bool compact;
  final String label;
  final VoidCallback onTap;

  const _CoreHub({
    required this.animation,
    required this.compact,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? Colors.white70 : const Color(0xFF1A2A42);
    final size = compact ? 70.0 : 82.0;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final t = (math.sin(animation.value * math.pi * 2) + 1) / 2;
        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withValues(alpha: isDark ? 0.18 : 0.72),
                  Theme.of(context)
                      .cardColor
                      .withValues(alpha: isDark ? 0.97 : 1.0),
                ],
              ),
              border: Border.all(
                color: AppTheme.gridColor.withValues(alpha: 0.36 + t * 0.4),
                width: 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.gridColor.withValues(alpha: 0.18 + t * 0.18),
                  blurRadius: isDark ? 24 : 14,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _InverterIcon(size: compact ? 26 : 32, color: fg),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: compact ? 9 : 10,
                    fontWeight: FontWeight.w700,
                    color: fg,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NodeWidget extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;
  final bool compact;
  final bool enableBlur;
  final bool selected;
  final VoidCallback? onTap;

  const _NodeWidget({
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
    required this.compact,
    required this.enableBlur,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final inner = Container(
      width: compact ? 94 : 108,
      height: compact ? 84 : 96,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: isDark ? 0.22 : 0.22),
            Theme.of(context).cardColor.withValues(alpha: isDark ? 0.44 : 0.94),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected
              ? color.withValues(alpha: 0.9)
              : color.withValues(alpha: isDark ? 0.5 : 0.62),
          width: selected ? 1.6 : 1.1,
        ),
        boxShadow: enableBlur
            ? [
                BoxShadow(
                  color: color.withValues(alpha: isDark ? 0.22 : 0.16),
                  blurRadius: isDark ? 20 : 14,
                  spreadRadius: -1,
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: compact ? 2 : 4),
          Flexible(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: compact ? 9 : 10,
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withValues(alpha: 0.95),
                  ),
            ),
          ),
          const SizedBox(height: 1),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: compact ? 11 : 12,
                fontWeight: FontWeight.w700,
                color: isDark ? color : color.withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );

    if (!enableBlur) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: inner,
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: inner,
          ),
        ),
      ),
    );
  }
}

class _FlowPainter extends CustomPainter {
  final double animationValue;
  final double pvPower;
  final double gridImportPower;
  final double gridExportPower;
  final double batteryChargePower;
  final double batteryDischargePower;
  final double loadPower;
  final _InteractiveFlowLink? selectedLink;
  final bool isDark;
  final bool reduceEffects;

  _FlowPainter({
    required this.animationValue,
    required this.pvPower,
    required this.gridImportPower,
    required this.gridExportPower,
    required this.batteryChargePower,
    required this.batteryDischargePower,
    required this.loadPower,
    required this.selectedLink,
    required this.isDark,
    required this.reduceEffects,
  });

  Path _createSPath(Offset start, Offset end) {
    final path = Path();
    path.moveTo(start.dx, start.dy);
    path.cubicTo(
      start.dx + (end.dx - start.dx) / 2,
      start.dy,
      start.dx + (end.dx - start.dx) / 2,
      end.dy,
      end.dx,
      end.dy,
    );
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final pvPos = const Offset(64, 56);
    final gridPos = Offset(size.width - 64, 56);
    final batPos = Offset(64, size.height - 56);
    final loadPos = Offset(size.width - 64, size.height - 56);

    final pvPath = _createSPath(pvPos, center);
    final gridPath = _createSPath(gridPos, center);
    final batPath = _createSPath(batPos, center);
    final loadPath = _createSPath(center, loadPos);
    final centerToBatPath = _createSPath(center, batPos);
    final centerToGridPath = _createSPath(center, gridPos);

    _drawBaseLine(canvas, pvPath);
    _drawBaseLine(canvas, gridPath);
    _drawBaseLine(canvas, batPath);
    _drawBaseLine(canvas, loadPath);

    if (pvPower > 0) {
      final selected = selectedLink == null ||
          selectedLink == _InteractiveFlowLink.solarToLoad ||
          selectedLink == _InteractiveFlowLink.solarToBattery ||
          selectedLink == _InteractiveFlowLink.solarToGrid;
      _drawEnergy(
        canvas,
        pvPath,
        AppTheme.pvColor,
        _scaledIntensity(_intensity(pvPower), selected),
      );
    }

    if (gridImportPower > 25.0) {
      final selected = selectedLink == null ||
          selectedLink == _InteractiveFlowLink.gridToLoad ||
          selectedLink == _InteractiveFlowLink.gridToBattery;
      _drawEnergy(canvas, gridPath, AppTheme.gridColor,
          _scaledIntensity(_intensity(gridImportPower), selected));
    }

    if (gridExportPower > 25.0) {
      final selected = selectedLink == null ||
          selectedLink == _InteractiveFlowLink.solarToGrid;
      _drawEnergy(
        canvas,
        centerToGridPath,
        AppTheme.gridColor,
        _scaledIntensity(_intensity(gridExportPower), selected),
      );
    }

    if (loadPower > 0) {
      final selected = selectedLink == null ||
          selectedLink == _InteractiveFlowLink.solarToLoad ||
          selectedLink == _InteractiveFlowLink.batteryToLoad ||
          selectedLink == _InteractiveFlowLink.gridToLoad;
      _drawEnergy(canvas, loadPath, AppTheme.loadColor,
          _scaledIntensity(_intensity(loadPower), selected));
    }

    if (batteryChargePower > 25.0) {
      final selected = selectedLink == null ||
          selectedLink == _InteractiveFlowLink.solarToBattery ||
          selectedLink == _InteractiveFlowLink.gridToBattery;
      _drawEnergy(
        canvas,
        centerToBatPath,
        AppTheme.batteryColor,
        _scaledIntensity(_intensity(batteryChargePower), selected),
      );
    } else if (batteryDischargePower > 25.0 ||
        (pvPower <= 0 && gridImportPower <= 25.0)) {
      // No solar and no AC input: the battery is the only source powering
      // the inverter, even when its current reads ~0 A.
      final selected = selectedLink == null ||
          selectedLink == _InteractiveFlowLink.batteryToLoad;
      _drawEnergy(
        canvas,
        batPath,
        AppTheme.batteryColor,
        _scaledIntensity(_intensity(batteryDischargePower), selected),
      );
    }
  }

  void _drawBaseLine(Canvas canvas, Path path) {
    final linePaint = Paint()
      ..color = (isDark ? Colors.white : const Color(0xFF6B7F97))
          .withValues(alpha: isDark ? 0.1 : 0.24)
      ..strokeWidth = 2.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);
  }

  double _intensity(double watts) {
    return (watts / 4000).clamp(0.22, 1.0);
  }

  double _scaledIntensity(double intensity, bool selected) {
    if (selectedLink == null) return intensity;
    final scale = selected ? 1.18 : 0.26;
    return (intensity * scale).clamp(0.08, 1.0);
  }

  void _drawEnergy(Canvas canvas, Path path, Color color, double intensity) {
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;

    final metric = metrics.first;
    final segment = metric.extractPath(0, metric.length);

    final glow = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withValues(alpha: isDark ? 0.08 : 0.08),
          color.withValues(
              alpha:
                  (isDark ? 0.22 : 0.2) + intensity * (isDark ? 0.24 : 0.14)),
          color.withValues(alpha: isDark ? 0.08 : 0.08),
        ],
      ).createShader(segment.getBounds())
      ..strokeWidth =
          (reduceEffects ? 3.2 : 4) + intensity * (reduceEffects ? 1.8 : 3)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = reduceEffects
          ? const MaskFilter.blur(BlurStyle.normal, 3)
          : MaskFilter.blur(BlurStyle.normal, isDark ? 6 : 3);

    canvas.drawPath(segment, glow);
    // Thin solid core so the active path stands out from the idle ones.
    canvas.drawPath(
      segment,
      Paint()
        ..color = color.withValues(alpha: 0.25 + intensity * 0.4)
        ..strokeWidth = 2.2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    // Always draw particles; on mobile reduceEffects only limits blur/stroke.
    _drawParticles(canvas, metric, color, intensity);
  }

  /// Moving chevrons (">") pointing along the path: the flow direction.
  void _drawParticles(
    Canvas canvas,
    PathMetric metric,
    Color color,
    double intensity,
  ) {
    final count = 3 + (intensity * 3).round();
    final speed = 0.55 + intensity * 1.1;
    final s = 5.0 + intensity * 3.0;
    final alpha = (0.45 + intensity * 0.8).clamp(0.2, 1.0);

    final glow = Paint()
      ..color = color.withValues(alpha: alpha * 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    final stroke = Paint()
      ..color = color.withValues(alpha: alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final chevron = Path()
      ..moveTo(-s * 0.7, -s)
      ..lineTo(0, 0)
      ..lineTo(-s * 0.7, s);

    for (var i = 0; i < count; i++) {
      final progress = ((animationValue * speed) + i / count) % 1.0;
      final tangent = metric.getTangentForOffset(metric.length * progress);
      if (tangent == null) continue;
      canvas
        ..save()
        ..translate(tangent.position.dx, tangent.position.dy)
        ..rotate(tangent.vector.direction)
        ..drawCircle(Offset(-s * 0.35, 0), s, glow)
        ..drawPath(chevron, stroke)
        ..restore();
    }
  }

  @override
  bool shouldRepaint(covariant _FlowPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.pvPower != pvPower ||
        oldDelegate.gridImportPower != gridImportPower ||
        oldDelegate.gridExportPower != gridExportPower ||
        oldDelegate.batteryChargePower != batteryChargePower ||
        oldDelegate.batteryDischargePower != batteryDischargePower ||
        oldDelegate.loadPower != loadPower ||
        oldDelegate.selectedLink != selectedLink ||
        oldDelegate.isDark != isDark ||
        oldDelegate.reduceEffects != reduceEffects;
  }
}

/// Electrical inverter symbol: a box split by a diagonal, DC (⎓) top-left,
/// AC sine wave bottom-right.
class _InverterIcon extends StatelessWidget {
  final double size;
  final Color color;

  const _InverterIcon({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size.square(size),
        painter: _InverterIconPainter(color),
      );
}

class _InverterIconPainter extends CustomPainter {
  final Color color;

  _InverterIconPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final u = size.width;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = u * 0.075
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final box = Rect.fromLTWH(u * 0.06, u * 0.06, u * 0.88, u * 0.88);
    canvas.drawRRect(
        RRect.fromRectAndRadius(box, Radius.circular(u * 0.16)), paint);
    canvas.drawLine(
        Offset(box.left + u * 0.05, box.bottom - u * 0.05),
        Offset(box.right - u * 0.05, box.top + u * 0.05),
        paint..strokeWidth = u * 0.055);

    // DC: solid line over a dashed line.
    paint.strokeWidth = u * 0.07;
    canvas.drawLine(Offset(u * 0.2, u * 0.3), Offset(u * 0.46, u * 0.3), paint);
    for (final x in [0.2, 0.31, 0.42]) {
      canvas.drawLine(
          Offset(u * x, u * 0.41), Offset(u * (x + 0.04), u * 0.41), paint);
    }

    // AC: one sine period.
    final wave = Path()..moveTo(u * 0.54, u * 0.7);
    for (var i = 1; i <= 24; i++) {
      final t = i / 24;
      wave.lineTo(
        u * (0.54 + 0.28 * t),
        u * (0.7 - 0.08 * math.sin(t * 2 * math.pi)),
      );
    }
    canvas.drawPath(wave, paint);
  }

  @override
  bool shouldRepaint(_InverterIconPainter old) => old.color != color;
}
