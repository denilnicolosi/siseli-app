part of 'settings_tab.dart';

class HardwareSettingsSection extends StatelessWidget {
  final AppStateProvider provider;
  final bool enableBlur;

  const HardwareSettingsSection({
    super.key,
    required this.provider,
    this.enableBlur = true,
  });

  static const List<_GeoPreset> _geoPresets = [
    _GeoPreset('kyiv', 'Kyiv, UA', 50.4501, 30.5234, 'Europe/Kyiv'),
    _GeoPreset('lviv', 'Lviv, UA', 49.8397, 24.0297, 'Europe/Kyiv'),
    _GeoPreset('odesa', 'Odesa, UA', 46.4825, 30.7233, 'Europe/Kyiv'),
    _GeoPreset('dnipro', 'Dnipro, UA', 48.4647, 35.0462, 'Europe/Kyiv'),
    _GeoPreset('kharkiv', 'Kharkiv, UA', 49.9935, 36.2304, 'Europe/Kyiv'),
    _GeoPreset('warsaw', 'Warsaw, PL', 52.2297, 21.0122, 'Europe/Warsaw'),
    _GeoPreset('berlin', 'Berlin, DE', 52.5200, 13.4050, 'Europe/Berlin'),
    _GeoPreset('custom', 'Custom (manual)', 0, 0, 'UTC'),
  ];

  /// Tolerance used to decide whether stored coordinates belong to a preset.
  /// Presets save their exact coordinates, so anything else (manual or
  /// GPS-detected coordinates) must be shown as "custom" instead of being
  /// silently snapped back to a nearby preset city on the next save.
  static const double _presetMatchEpsilon = 1e-4;

  static _GeoPreset _matchPreset(double lat, double lon) {
    for (final p in _geoPresets.where((e) => e.id != 'custom')) {
      final latOk = (p.latitude - lat).abs() <= _presetMatchEpsilon;
      final lonOk = (p.longitude - lon).abs() <= _presetMatchEpsilon;
      if (latOk && lonOk) return p;
    }
    return _geoPresets.last;
  }

  static double _sanitizeLatitude(double value, double fallback) {
    if (!value.isFinite) return fallback;
    return value.clamp(-90.0, 90.0).toDouble();
  }

  static double _sanitizeLongitude(double value, double fallback) {
    if (!value.isFinite) return fallback;
    return value.clamp(-180.0, 180.0).toDouble();
  }

  String _geoPresetLabel(AppLocalizations l10n, _GeoPreset preset) {
    switch (preset.id) {
      case 'kyiv':
        return l10n.geoPresetKyiv;
      case 'lviv':
        return l10n.geoPresetLviv;
      case 'odesa':
        return l10n.geoPresetOdesa;
      case 'dnipro':
        return l10n.geoPresetDnipro;
      case 'kharkiv':
        return l10n.geoPresetKharkiv;
      case 'warsaw':
        return l10n.geoPresetWarsaw;
      case 'berlin':
        return l10n.geoPresetBerlin;
      case 'custom':
        return l10n.geoPresetCustom;
      default:
        return preset.label;
    }
  }

  static const List<double> _breakerPresetsA = [10, 16, 20, 25, 32, 40, 50, 63];

  static double _matchBreakerPreset(double amps) {
    return _breakerPresetsA.reduce(
      (best, candidate) =>
          (candidate - amps).abs() < (best - amps).abs() ? candidate : best,
    );
  }

  void _showEditDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final expressive = context.expressive;
    final batteryCtrl = TextEditingController(
        text: provider.batteryCapacityAh.toStringAsFixed(0));
    final pvCtrl = TextEditingController(
        text: provider.pvTotalCapacityW.toStringAsFixed(0));
    final inverterCtrl = TextEditingController(
        text: provider.inverterMaxPowerW.toStringAsFixed(0));
    final latitudeCtrl =
        TextEditingController(text: provider.siteLatitude.toStringAsFixed(4));
    final longitudeCtrl =
        TextEditingController(text: provider.siteLongitude.toStringAsFixed(4));
    final timeZoneCtrl = TextEditingController(text: provider.siteTimeZone);
    final installYearCtrl = TextEditingController(
        text: provider.batteryInstallDate.year.toString());
    final gridVoltageCtrl = TextEditingController(
        text: provider.nominalGridVoltage.toStringAsFixed(0));
    final reserveLoadCtrl = TextEditingController(
        text: provider.houseLoadReserveW.toStringAsFixed(0));
    var selectedPreset =
        _matchPreset(provider.siteLatitude, provider.siteLongitude);
    var selectedBreakerA = _matchBreakerPreset(provider.acInputBreakerAmps);
    var autoReserveEnabled = provider.autoHouseLoadReserveEnabled;
    var isDetectingLocation = false;
    LocationFailure? locationFailure;
    String? locationDetectedMessage;
    final supportsLocationDetection =
        defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          final parsedGridVoltage = (double.tryParse(gridVoltageCtrl.text) ??
                  provider.nominalGridVoltage)
              .clamp(180.0, 260.0)
              .toDouble();
          final parsedReserveW = (double.tryParse(reserveLoadCtrl.text) ??
                  provider.houseLoadReserveW)
              .clamp(0.0, 12000.0)
              .toDouble();
          final safeGridPowerW = (selectedBreakerA * parsedGridVoltage * 0.9)
              .clamp(0.0, 20000.0)
              .toDouble();
          final recommendedChargeW = (safeGridPowerW - parsedReserveW)
              .clamp(0.0, provider.inverterMaxPowerW)
              .toDouble();
          final recommendedChargeA =
              (recommendedChargeW / 51.2).clamp(0.0, 400.0).toDouble();
          final profilePeakLoadW = provider.avgHourlyConsumptionStats.isEmpty
              ? 0.0
              : provider.avgHourlyConsumptionStats.values
                  .reduce(math.max)
                  .clamp(0.0, 15000.0)
                  .toDouble();
          final liveLoadW =
              (provider.data?.loadPower ?? 0.0).clamp(0.0, 15000.0).toDouble();
          final analyzedHouseLoadW =
              math.max(parsedReserveW, math.max(profilePeakLoadW, liveLoadW));
          final conservativeChargeW = (safeGridPowerW - analyzedHouseLoadW)
              .clamp(0.0, provider.inverterMaxPowerW)
              .toDouble();
          final conservativeChargeA =
              (conservativeChargeW / 51.2).clamp(0.0, 400.0).toDouble();
          final estimatedInputCurrentAtRecommendedA = parsedGridVoltage <= 1.0
              ? 0.0
              : ((analyzedHouseLoadW + recommendedChargeW) / parsedGridVoltage)
                  .clamp(0.0, 300.0)
                  .toDouble();
          final breakerUtilization = selectedBreakerA <= 0
              ? 0.0
              : (estimatedInputCurrentAtRecommendedA / selectedBreakerA)
                  .clamp(0.0, 2.0)
                  .toDouble();
          final breakerRiskHigh = breakerUtilization >= 0.95;
          final breakerRiskElevated =
              !breakerRiskHigh && breakerUtilization >= 0.85;
          final socForEstimate = provider.data?.batterySoc;
          double? estimateHours;
          if (socForEstimate != null && recommendedChargeW > 1.0) {
            final capacityWh = provider.batteryCapacityAh * 51.2;
            final deltaSoc =
                ((100.0 - socForEstimate.clamp(0.0, 100.0)) / 100.0)
                    .clamp(0.0, 1.0)
                    .toDouble();
            // ~96% one-way charge efficiency (≈92% round trip).
            const chargingEfficiency = 0.96;
            final requiredInputWh =
                (capacityWh * deltaSoc) / chargingEfficiency;
            final rawHours = requiredInputWh / recommendedChargeW;
            if (rawHours.isFinite) {
              estimateHours = rawHours.clamp(0.0, 240.0).toDouble();
            }
          }

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(expressive.cornerXL),
            ),
            title: Text(l10n.stationParameters),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.stationParametersHint,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                      context,
                      batteryCtrl,
                      l10n.batteryCapacityLabel,
                      'Ah',
                      Icons.battery_charging_full_rounded),
                  const SizedBox(height: 16),
                  _buildTextField(
                      context,
                      installYearCtrl,
                      l10n.batteryInstallYearLabel,
                      '',
                      Icons.calendar_today_outlined),
                  const SizedBox(height: 16),
                  _buildTextField(context, pvCtrl, l10n.panelPowerLabel, 'W',
                      Icons.grid_4x4_rounded),
                  const SizedBox(height: 16),
                  _buildTextField(context, inverterCtrl,
                      l10n.inverterPowerLabel, 'W', Icons.bolt_rounded),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<double>(
                    initialValue: selectedBreakerA,
                    decoration: InputDecoration(
                      labelText: l10n.inputBreakerLabel,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      prefixIcon: Icon(Icons.electrical_services_rounded,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    items: _breakerPresetsA
                        .map(
                          (amp) => DropdownMenuItem<double>(
                            value: amp,
                            child: Text(
                              'C${amp.toStringAsFixed(0)} (${amp.toStringAsFixed(0)} A)',
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        setStateDialog(() => selectedBreakerA = v);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    context,
                    gridVoltageCtrl,
                    l10n.gridVoltageLabel,
                    'V',
                    Icons.electric_bolt_rounded,
                    onChanged: (_) => setStateDialog(() {}),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    context,
                    reserveLoadCtrl,
                    l10n.houseLoadReserveLabel,
                    'W',
                    Icons.home_work_outlined,
                    enabled: !autoReserveEnabled,
                    onChanged: (_) => setStateDialog(() {}),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.autoReserveLoadTitle),
                    subtitle: Text(
                      autoReserveEnabled
                          ? l10n.autoReserveLoadEnabledSubtitle
                          : l10n.autoReserveLoadDisabledSubtitle,
                    ),
                    value: autoReserveEnabled,
                    onChanged: (v) {
                      setStateDialog(() => autoReserveEnabled = v);
                    },
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Tooltip(
                      message: autoReserveEnabled
                          ? l10n.reserveModeAutoHint
                          : l10n.reserveModeManualHint,
                      child: AppStatusChip(
                        icon: autoReserveEnabled
                            ? Icons.auto_awesome_rounded
                            : Icons.tune_rounded,
                        label: autoReserveEnabled
                            ? l10n.reserveModeAuto
                            : l10n.reserveModeManual,
                        color: autoReserveEnabled
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.houseLoadReserveHint,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: autoReserveEnabled
                          ? null
                          : () {
                              final suggested =
                                  provider.estimateHouseLoadReserveW();
                              setStateDialog(() {
                                reserveLoadCtrl.text =
                                    suggested.toStringAsFixed(0);
                              });
                            },
                      icon: const Icon(Icons.auto_fix_high_rounded, size: 16),
                      label: Text(l10n.autoEstimateReserveLoad),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppGlassSurface(
                    borderRadius: 14,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.chargePowerEstimateTitle,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          _buildDiagnosticRow(
                            context,
                            label: l10n.chargePowerSafeLimitLabel,
                            value: '${recommendedChargeW.toStringAsFixed(0)} W',
                            icon: Icons.speed_rounded,
                          ),
                          const SizedBox(height: 6),
                          _buildDiagnosticRow(
                            context,
                            label: l10n.chargeCurrentSafeLimitLabel,
                            value: '${recommendedChargeA.toStringAsFixed(1)} A',
                            icon: Icons.battery_charging_full_rounded,
                          ),
                          const SizedBox(height: 6),
                          _buildDiagnosticRow(
                            context,
                            label: l10n.chargeCurrentConservativeLabel,
                            value:
                                '${conservativeChargeA.toStringAsFixed(1)} A (${conservativeChargeW.toStringAsFixed(0)} W)',
                            icon: Icons.shield_rounded,
                          ),
                          const SizedBox(height: 6),
                          _buildDiagnosticRow(
                            context,
                            label: l10n.chargeInputCurrentEstimateLabel,
                            value:
                                '${estimatedInputCurrentAtRecommendedA.toStringAsFixed(1)} A / C${selectedBreakerA.toStringAsFixed(0)}',
                            icon: Icons.electrical_services_rounded,
                          ),
                          const SizedBox(height: 8),
                          AppStatusChip(
                            icon: breakerRiskHigh
                                ? Icons.warning_amber_rounded
                                : breakerRiskElevated
                                    ? Icons.info_outline_rounded
                                    : Icons.verified_rounded,
                            label: breakerRiskHigh
                                ? l10n.chargeBreakerRiskHigh
                                : breakerRiskElevated
                                    ? l10n.chargeBreakerRiskElevated
                                    : l10n.chargeBreakerRiskSafe,
                            color: breakerRiskHigh
                                ? Theme.of(context).colorScheme.error
                                : breakerRiskElevated
                                    ? Theme.of(context).colorScheme.tertiary
                                    : Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(height: 6),
                          _buildDiagnosticRow(
                            context,
                            label: l10n.chargeTimeToFullLabel,
                            value: estimateHours == null
                                ? l10n.chargeTimeUnavailable
                                : '${estimateHours.toStringAsFixed(1)} h',
                            icon: Icons.timelapse_rounded,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            socForEstimate == null
                                ? l10n.chargeEstimateNoRealtimeSoc
                                : l10n.chargeEstimateBasedOnSoc(
                                    socForEstimate.toStringAsFixed(0),
                                  ),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.chargeBreakerRiskHint(
                              analyzedHouseLoadW.toStringAsFixed(0),
                            ),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: provider.isSettingChanging
                          ? null
                          : () async {
                              final result =
                                  await provider.applySafeChargingCurrent(
                                recommendedChargeA,
                              );
                              if (!context.mounted) return;
                              final readback =
                                  '${result.readTotalA?.toString() ?? '--'}/${result.readUtilityA?.toString() ?? '--'} A';
                              final text = result.success
                                  ? l10n.safeCurrentApplied(
                                      result.targetA.toString(), readback)
                                  : l10n.safeCurrentFailed(
                                      result.targetA.toString(), readback);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(text)),
                              );
                            },
                      icon: provider.isSettingChanging
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.electrical_services_rounded),
                      label: Text(l10n.applySafeCurrent),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    // Re-created when the preset changes programmatically
                    // (e.g. GPS detection switches to "custom"), because
                    // initialValue is only read on first build.
                    key: ValueKey<String>('geo-preset-${selectedPreset.id}'),
                    isExpanded: true,
                    initialValue: selectedPreset.id,
                    decoration: InputDecoration(
                      labelText: l10n.locationPreset,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      prefixIcon: Icon(Icons.map_outlined,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    items: _geoPresets
                        .map((p) => DropdownMenuItem(
                              value: p.id,
                              child: Text(_geoPresetLabel(l10n, p)),
                            ))
                        .toList(),
                    onChanged: (id) {
                      if (id == null) return;
                      final preset = _geoPresets.firstWhere((p) => p.id == id);
                      setStateDialog(() {
                        selectedPreset = preset;
                        // The previous "position detected" hint no longer
                        // describes what will be saved.
                        locationDetectedMessage = null;
                        locationFailure = null;
                      });
                      if (preset.id != 'custom') {
                        latitudeCtrl.text = preset.latitude.toStringAsFixed(4);
                        longitudeCtrl.text =
                            preset.longitude.toStringAsFixed(4);
                        timeZoneCtrl.text = preset.timeZone;
                      }
                    },
                  ),
                  if (supportsLocationDetection) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: isDetectingLocation
                            ? null
                            : () async {
                                setStateDialog(() {
                                  isDetectingLocation = true;
                                  locationFailure = null;
                                  locationDetectedMessage = null;
                                });
                                try {
                                  final location =
                                      await provider.detectSiteLocation();
                                  if (!context.mounted) return;
                                  setStateDialog(() {
                                    selectedPreset = _geoPresets.last;
                                    latitudeCtrl.text =
                                        location.latitude.toStringAsFixed(4);
                                    longitudeCtrl.text =
                                        location.longitude.toStringAsFixed(4);
                                    timeZoneCtrl.text = location.timeZone;
                                    locationDetectedMessage =
                                        l10n.locationDetected(
                                      location.latitude.toStringAsFixed(4),
                                      location.longitude.toStringAsFixed(4),
                                      location.timeZone,
                                    );
                                  });
                                } on LocationException catch (error) {
                                  if (!context.mounted) return;
                                  setStateDialog(
                                      () => locationFailure = error.failure);
                                } catch (error, stack) {
                                  LogService.log('❌ location detection failed',
                                      error: error, stack: stack);
                                  if (!context.mounted) return;
                                  setStateDialog(() => locationFailure =
                                      LocationFailure.unavailable);
                                } finally {
                                  if (context.mounted) {
                                    setStateDialog(
                                        () => isDetectingLocation = false);
                                  }
                                }
                              },
                        icon: isDetectingLocation
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.my_location_rounded),
                        label: Text(isDetectingLocation
                            ? l10n.locationDetecting
                            : l10n.useMyLocation),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.locationHelp,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ),
                    if (locationFailure != null) ...[
                      const SizedBox(height: 8),
                      _buildLocationError(
                          context, l10n, provider, locationFailure!),
                    ] else if (locationDetectedMessage != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              locationDetectedMessage!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                  if (selectedPreset.id == 'custom') ...[
                    const SizedBox(height: 16),
                    _buildTextField(context, latitudeCtrl, l10n.latitudeLabel,
                        'deg', Icons.place_outlined),
                    const SizedBox(height: 16),
                    _buildTextField(context, longitudeCtrl, l10n.longitudeLabel,
                        'deg', Icons.explore_outlined),
                  ],
                  const SizedBox(height: 16),
                  _buildTextField(context, timeZoneCtrl, l10n.timeZoneLabel, '',
                      Icons.schedule_rounded,
                      allowDecimalOnly: false),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            actionsPadding: const EdgeInsets.only(right: 16, bottom: 16),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: isDetectingLocation
                    ? null
                    : () {
                        final bat = double.tryParse(batteryCtrl.text) ??
                            provider.batteryCapacityAh;
                        final pv = double.tryParse(pvCtrl.text) ??
                            provider.pvTotalCapacityW;
                        final inv = double.tryParse(inverterCtrl.text) ??
                            provider.inverterMaxPowerW;
                        final gridVoltage =
                            double.tryParse(gridVoltageCtrl.text) ??
                                provider.nominalGridVoltage;
                        final houseReserveW =
                            double.tryParse(reserveLoadCtrl.text) ??
                                provider.houseLoadReserveW;
                        final installYear =
                            int.tryParse(installYearCtrl.text) ??
                                provider.batteryInstallDate.year;
                        final installDate = DateTime(
                            installYear.clamp(2000, DateTime.now().year), 1, 1);

                        final rawLat = selectedPreset.id == 'custom'
                            ? (double.tryParse(latitudeCtrl.text) ??
                                provider.siteLatitude)
                            : selectedPreset.latitude;
                        final rawLon = selectedPreset.id == 'custom'
                            ? (double.tryParse(longitudeCtrl.text) ??
                                provider.siteLongitude)
                            : selectedPreset.longitude;
                        final lat =
                            _sanitizeLatitude(rawLat, provider.siteLatitude);
                        final lon =
                            _sanitizeLongitude(rawLon, provider.siteLongitude);
                        final tz = timeZoneCtrl.text.trim().isEmpty
                            ? provider.siteTimeZone
                            : timeZoneCtrl.text.trim();

                        provider.saveHardwareSettings(
                          bat,
                          pv,
                          inv,
                          installDate: installDate,
                          breakerAmps: selectedBreakerA,
                          gridVoltage: gridVoltage,
                          loadReserveW: houseReserveW,
                          autoReserveEnabled: autoReserveEnabled,
                        );
                        provider.saveGeoSettings(
                          latitude: lat,
                          longitude: lon,
                          timeZone: tz,
                        );
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.hardwareSettingsSaved),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                child: Text(l10n.save,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Builds inline feedback for a failed location detection. Shown inside the
  /// dialog (a SnackBar would sit behind the modal barrier) and, when the user
  /// can fix the cause from the system UI, offers a shortcut to the right
  /// settings page.
  Widget _buildLocationError(
    BuildContext context,
    AppLocalizations l10n,
    AppStateProvider provider,
    LocationFailure failure,
  ) {
    final theme = Theme.of(context);
    final message = switch (failure) {
      LocationFailure.serviceDisabled => l10n.locationServicesDisabled,
      LocationFailure.permissionDenied => l10n.locationPermissionDenied,
      LocationFailure.permissionDeniedForever =>
        l10n.locationPermissionDeniedForever,
      LocationFailure.timeout => l10n.locationTimeout,
      LocationFailure.unavailable => l10n.locationUnavailable,
    };
    final openSettings = switch (failure) {
      LocationFailure.serviceDisabled => provider.openLocationSystemSettings,
      LocationFailure.permissionDenied ||
      LocationFailure.permissionDeniedForever =>
        provider.openLocationPermissionSettings,
      LocationFailure.timeout || LocationFailure.unavailable => null,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 18, color: theme.colorScheme.error),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          if (openSettings != null)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => unawaited(
                  openSettings().catchError((Object error, StackTrace stack) {
                    LogService.log('❌ opening location settings failed',
                        error: error, stack: stack);
                    return false;
                  }),
                ),
                child: Text(l10n.openSettings),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context, TextEditingController controller,
      String label, String suffix, IconData icon,
      {bool allowDecimalOnly = true,
      bool enabled = true,
      ValueChanged<String>? onChanged}) {
    return TextField(
      controller: controller,
      enabled: enabled,
      onChanged: onChanged,
      keyboardType: allowDecimalOnly
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      inputFormatters: allowDecimalOnly
          ? [FilteringTextInputFormatter.allow(RegExp(r'^-?\d+\.?\d*'))]
          : null,
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        prefixIcon:
            Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildDiagnosticRow(BuildContext context,
      {required String label, required String value, IconData? icon}) {
    final theme = Theme.of(context);
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 15, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
        ],
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppCard(
      borderRadius: AppTheme.radiusLarge,
      enableBlur: enableBlur,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showEditDialog(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.solar_power_rounded,
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.stationParameters,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      l10n.hardwareSummary(
                        provider.batteryCapacityAh.toInt().toString(),
                        provider.pvTotalCapacityW.toInt().toString(),
                        provider.inverterMaxPowerW.toInt().toString(),
                      ),
                      style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.4),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.geoSummary(
                        provider.siteLatitude.toStringAsFixed(4),
                        provider.siteLongitude.toStringAsFixed(4),
                        provider.siteTimeZone,
                      ),
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.3),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.chargeLimitSummary(
                        provider.acInputBreakerAmps.toStringAsFixed(0),
                        provider.recommendedBatteryChargePowerW
                            .toStringAsFixed(0),
                        provider.recommendedBatteryChargeCurrentA
                            .toStringAsFixed(1),
                      ),
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.3),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _GeoPreset {
  final String id;
  final String label;
  final double latitude;
  final double longitude;
  final String timeZone;

  const _GeoPreset(
    this.id,
    this.label,
    this.latitude,
    this.longitude,
    this.timeZone,
  );
}
