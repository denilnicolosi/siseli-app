import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// Weather groups for the WMO codes Open-Meteo returns.
enum WeatherKind {
  clear,
  partlyCloudy,
  overcast,
  fog,
  drizzle,
  rain,
  snow,
  thunderstorm,
}

/// WMO 4677 code (Open-Meteo `weather_code`) to [WeatherKind]; null when
/// the code is unknown.
WeatherKind? weatherKindFor(int code) => switch (code) {
      0 || 1 => WeatherKind.clear,
      2 => WeatherKind.partlyCloudy,
      3 => WeatherKind.overcast,
      45 || 48 => WeatherKind.fog,
      51 || 53 || 55 || 56 || 57 => WeatherKind.drizzle,
      61 || 63 || 65 || 66 || 67 || 80 || 81 || 82 => WeatherKind.rain,
      71 || 73 || 75 || 77 || 85 || 86 => WeatherKind.snow,
      95 || 96 || 99 => WeatherKind.thunderstorm,
      _ => null,
    };

String weatherLabel(AppLocalizations l10n, WeatherKind kind) => switch (kind) {
      WeatherKind.clear => l10n.wxClear,
      WeatherKind.partlyCloudy => l10n.wxPartlyCloudy,
      WeatherKind.overcast => l10n.wxOvercast,
      WeatherKind.fog => l10n.wxFog,
      WeatherKind.drizzle => l10n.wxDrizzle,
      WeatherKind.rain => l10n.wxRain,
      WeatherKind.snow => l10n.wxSnow,
      WeatherKind.thunderstorm => l10n.wxThunderstorm,
    };

/// Day weather icon with a tooltip; draws nothing for an unknown code.
class WeatherIcon extends StatelessWidget {
  final int? code;
  final double size;

  const WeatherIcon({super.key, required this.code, this.size = 28});

  static const _sun = Color(0xFFF59E0B);
  static const _cloud = Color(0xFF94A3B8);
  static const _rain = Color(0xFF3B82F6);
  static const _snow = Color(0xFF7DD3FC);
  static const _storm = Color(0xFF8B5CF6);

  @override
  Widget build(BuildContext context) {
    final kind = code == null ? null : weatherKindFor(code!);
    if (kind == null) return SizedBox.square(dimension: size);

    // Material has no "sun behind cloud": stack the two.
    final icon = switch (kind) {
      WeatherKind.partlyCloudy => SizedBox.square(
          dimension: size,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Icon(Icons.wb_sunny_rounded,
                    size: size * 0.72, color: _sun),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child:
                    Icon(Icons.cloud_rounded, size: size * 0.72, color: _cloud),
              ),
            ],
          ),
        ),
      WeatherKind.clear =>
        Icon(Icons.wb_sunny_rounded, size: size, color: _sun),
      WeatherKind.overcast =>
        Icon(Icons.cloud_rounded, size: size, color: _cloud),
      WeatherKind.fog => Icon(Icons.foggy, size: size, color: _cloud),
      WeatherKind.drizzle =>
        Icon(Icons.grain_rounded, size: size, color: _rain),
      // No "cloud with rain" either: cloud on top, drops underneath.
      WeatherKind.rain => SizedBox.square(
          dimension: size,
          child: Stack(
            children: [
              Positioned(
                left: size * 0.1,
                top: -size * 0.06,
                child:
                    Icon(Icons.cloud_rounded, size: size * 0.8, color: _cloud),
              ),
              for (final left in [0.16, 0.38, 0.6])
                Positioned(
                  left: size * left,
                  bottom: 0,
                  child: Icon(Icons.water_drop_rounded,
                      size: size * 0.3, color: _rain),
                ),
            ],
          ),
        ),
      WeatherKind.snow => Icon(Icons.ac_unit_rounded, size: size, color: _snow),
      WeatherKind.thunderstorm =>
        Icon(Icons.thunderstorm_rounded, size: size, color: _storm),
    };

    final label = weatherLabel(AppLocalizations.of(context)!, kind);
    return Tooltip(
      message: label,
      triggerMode: TooltipTriggerMode.tap,
      child: Semantics(label: label, child: icon),
    );
  }
}
