// Realtime field keys as sent by solar.siseli.com for the Easun SMH III.
// Texts (ARB `rd*` keys) follow the Easun iSolar SMH/SMG manual programs.
import '../l10n/app_localizations.dart';
import '../services/log_service.dart';

/// Localized name + explanation for a realtime reading key, or null.
({String name, String description})? inverterReadingInfo(
    AppLocalizations l10n, String key) {
  return switch (key) {
    'dualOutputVoltageSwitch' => (
        name: l10n.rdDualOutputVoltageSwitch,
        description: l10n.rdDualOutputVoltageSwitchDesc,
      ),
    'acInputFrequency' => (
        name: l10n.rdAcInputFrequency,
        description: l10n.rdAcInputFrequencyDesc,
      ),
    'ledPatternLight1' => (
        name: l10n.rdLedPatternLight1,
        description: l10n.rdLedPatternLight1Desc,
      ),
    'batteryNumber' => (
        name: l10n.rdBatteryNumber,
        description: l10n.rdBatteryNumberDesc,
      ),
    'acInputVoltage' => (
        name: l10n.rdAcInputVoltage,
        description: l10n.rdAcInputVoltageDesc,
      ),
    'workingStates' => (
        name: l10n.rdWorkingStates,
        description: l10n.rdWorkingStatesDesc,
      ),
    'acOutputActivePower' => (
        name: l10n.rdAcOutputActivePower,
        description: l10n.rdAcOutputActivePowerDesc,
      ),
    'batteryEqualizationMode' => (
        name: l10n.rdBatteryEqualizationMode,
        description: l10n.rdBatteryEqualizationModeDesc,
      ),
    'gridConnectedSwitch1' => (
        name: l10n.rdGridConnectedSwitch1,
        description: l10n.rdGridConnectedSwitch1Desc,
      ),
    'generationPower' => (
        name: l10n.rdGenerationPower,
        description: l10n.rdGenerationPowerDesc,
      ),
    'ratingOutputCurrent' => (
        name: l10n.rdRatingOutputCurrent,
        description: l10n.rdRatingOutputCurrentDesc,
      ),
    'lowBatteryCutOffVoltage' => (
        name: l10n.rdLowBatteryCutOffVoltage,
        description: l10n.rdLowBatteryCutOffVoltageDesc,
      ),
    'batteryCapacity' => (
        name: l10n.rdBatteryCapacity,
        description: l10n.rdBatteryCapacityDesc,
      ),
    'startBalancing' => (
        name: l10n.rdStartBalancing,
        description: l10n.rdStartBalancingDesc,
      ),
    'batteryDischargeCurrent' => (
        name: l10n.rdBatteryDischargeCurrent,
        description: l10n.rdBatteryDischargeCurrentDesc,
      ),
    'gridConnectedCurrent' => (
        name: l10n.rdGridConnectedCurrent,
        description: l10n.rdGridConnectedCurrentDesc,
      ),
    'ratedBatteryVoltage' => (
        name: l10n.rdRatedBatteryVoltage,
        description: l10n.rdRatedBatteryVoltageDesc,
      ),
    'outputApparentPower' => (
        name: l10n.rdOutputApparentPower,
        description: l10n.rdOutputApparentPowerDesc,
      ),
    'dualOutputTurnOffVoltage' => (
        name: l10n.rdDualOutputTurnOffVoltage,
        description: l10n.rdDualOutputTurnOffVoltageDesc,
      ),
    'mainCPUVersion1' => (
        name: l10n.rdMainCPUVersion1,
        description: l10n.rdMainCPUVersion1Desc,
      ),
    'chargerSourcePriority' => (
        name: l10n.rdChargerSourcePriority,
        description: l10n.rdChargerSourcePriorityDesc,
      ),
    'comebackUtilityModeVolSBUPriorityStatus' => (
        name: l10n.rdComebackUtilityModeVolSBUPriorityStatus,
        description: l10n.rdComebackUtilityModeVolSBUPriorityStatusDesc,
      ),
    'nominalAcVoltage' => (
        name: l10n.rdNominalAcVoltage,
        description: l10n.rdNominalAcVoltageDesc,
      ),
    'nominalAcCurrent' => (
        name: l10n.rdNominalAcCurrent,
        description: l10n.rdNominalAcCurrentDesc,
      ),
    'outputRelayStatus' => (
        name: l10n.rdOutputRelayStatus,
        description: l10n.rdOutputRelayStatusDesc,
      ),
    'photovoltaicAccessFlag' => (
        name: l10n.rdPhotovoltaicAccessFlag,
        description: l10n.rdPhotovoltaicAccessFlagDesc,
      ),
    'pvStatuss' => (
        name: l10n.rdPvStatuss,
        description: l10n.rdPvStatussDesc,
      ),
    'ratedOutputFrequency' => (
        name: l10n.rdRatedOutputFrequency,
        description: l10n.rdRatedOutputFrequencyDesc,
      ),
    'ratedOutputVoltage' => (
        name: l10n.rdRatedOutputVoltage,
        description: l10n.rdRatedOutputVoltageDesc,
      ),
    'gridState' => (
        name: l10n.rdGridState,
        description: l10n.rdGridStateDesc,
      ),
    'batteryEqualizationInterval' => (
        name: l10n.rdBatteryEqualizationInterval,
        description: l10n.rdBatteryEqualizationIntervalDesc,
      ),
    'loadPercentage' => (
        name: l10n.rdLoadPercentage,
        description: l10n.rdLoadPercentageDesc,
      ),
    'comebackBatteryModeVolSBUPriorityStatus' => (
        name: l10n.rdComebackBatteryModeVolSBUPriorityStatus,
        description: l10n.rdComebackBatteryModeVolSBUPriorityStatusDesc,
      ),
    'pvInputPower' => (
        name: l10n.rdPvInputPower,
        description: l10n.rdPvInputPowerDesc,
      ),
    'maxTotalChargeCurrent1' => (
        name: l10n.rdMaxTotalChargeCurrent1,
        description: l10n.rdMaxTotalChargeCurrent1Desc,
      ),
    'batState' => (
        name: l10n.rdBatState,
        description: l10n.rdBatStateDesc,
      ),
    'outputSourcePriority' => (
        name: l10n.rdOutputSourcePriority,
        description: l10n.rdOutputSourcePriorityDesc,
      ),
    'floatChargingVoltage' => (
        name: l10n.rdFloatChargingVoltage,
        description: l10n.rdFloatChargingVoltageDesc,
      ),
    'batteryChargingCurrent' => (
        name: l10n.rdBatteryChargingCurrent,
        description: l10n.rdBatteryChargingCurrentDesc,
      ),
    'acOutputRatingApparentPower' => (
        name: l10n.rdAcOutputRatingApparentPower,
        description: l10n.rdAcOutputRatingApparentPowerDesc,
      ),
    'loadStatus' => (
        name: l10n.rdLoadStatus,
        description: l10n.rdLoadStatusDesc,
      ),
    'batteryEqualizationVoltage' => (
        name: l10n.rdBatteryEqualizationVoltage,
        description: l10n.rdBatteryEqualizationVoltageDesc,
      ),
    'batteryVoltage' => (
        name: l10n.rdBatteryVoltage,
        description: l10n.rdBatteryVoltageDesc,
      ),
    'outputVoltage' => (
        name: l10n.rdOutputVoltage,
        description: l10n.rdOutputVoltageDesc,
      ),
    'bulkChargingVoltage' => (
        name: l10n.rdBulkChargingVoltage,
        description: l10n.rdBulkChargingVoltageDesc,
      ),
    'batteryEqualizationTimeout' => (
        name: l10n.rdBatteryEqualizationTimeout,
        description: l10n.rdBatteryEqualizationTimeoutDesc,
      ),
    'feedInPower' => (
        name: l10n.rdFeedInPower,
        description: l10n.rdFeedInPowerDesc,
      ),
    'ntcMaximumTemperature' => (
        name: l10n.rdNtcMaximumTemperature,
        description: l10n.rdNtcMaximumTemperatureDesc,
      ),
    'mainsRelayStatus' => (
        name: l10n.rdMainsRelayStatus,
        description: l10n.rdMainsRelayStatusDesc,
      ),
    'batteryRatingVoltage' => (
        name: l10n.rdBatteryRatingVoltage,
        description: l10n.rdBatteryRatingVoltageDesc,
      ),
    'ratedActivePower' => (
        name: l10n.rdRatedActivePower,
        description: l10n.rdRatedActivePowerDesc,
      ),
    'pvInputVoltage' => (
        name: l10n.rdPvInputVoltage,
        description: l10n.rdPvInputVoltageDesc,
      ),
    'mainsInputRange' => (
        name: l10n.rdMainsInputRange,
        description: l10n.rdMainsInputRangeDesc,
      ),
    'outputFrequency' => (
        name: l10n.rdOutputFrequency,
        description: l10n.rdOutputFrequencyDesc,
      ),
    'batteryEqualizationTime' => (
        name: l10n.rdBatteryEqualizationTime,
        description: l10n.rdBatteryEqualizationTimeDesc,
      ),
    'batteryType' => (
        name: l10n.rdBatteryType,
        description: l10n.rdBatteryTypeDesc,
      ),
    'maxUtilityChargeCurrent1' => (
        name: l10n.rdMaxUtilityChargeCurrent1,
        description: l10n.rdMaxUtilityChargeCurrent1Desc,
      ),
    _ => null,
  };
}

/// API texts seen without a translation, logged once each so new ones can
/// be added to [translateReadingValue].
final _untranslatedValues = <String>{};

/// Translates enum-like display values sent by the API ("off", "charge"
/// …); anything unknown is returned unchanged.
String translateReadingValue(AppLocalizations l10n, String value) {
  final translated = _translateReadingValue(l10n, value);
  // Codes (OSO, SBU, LIC, firmware "U1 15 40") are uppercase: only log
  // values with lowercase words, i.e. English sentences.
  if (identical(translated, value) &&
      RegExp(r'[a-z]{3}').hasMatch(value) &&
      _untranslatedValues.add(value)) {
    LogService.log('⚠️ Untranslated API value: "$value"');
  }
  return translated;
}

String _translateReadingValue(AppLocalizations l10n, String value) {
  return switch (value.trim().toLowerCase()) {
    'on' => l10n.rdValOn,
    'off' => l10n.rdValOff,
    'enable' => l10n.rdValEnabled,
    'enabled' => l10n.rdValEnabled,
    'disable' => l10n.rdValDisabled,
    'disabled' => l10n.rdValDisabled,
    'charge' => l10n.rdValCharging,
    'discharge' => l10n.rdValDischarging,
    'invert mode' => l10n.rdValInvertMode,
    'line mode' => l10n.rdValLineMode,
    'standby mode' => l10n.rdValStandbyMode,
    'fault mode' => l10n.rdValFaultMode,
    'not connected to mains power' => l10n.rdValAcNotConnected,
    'connected to mains power' => l10n.rdValAcConnected,
    'normal working state' => l10n.rdValNormal,
    'normal access in working mode' => l10n.rdValPvWorking,
    'photovoltaic access' => l10n.rdValPvConnected,
    'photovoltaic not connected' => l10n.rdValPvNotConnected,
    'not connected and voltage below low voltage point' =>
      l10n.rdValPvLowVoltage,
    'power on mode' => l10n.rdValPowerOnMode,
    'power saving mode' => l10n.rdValPowerSavingMode,
    'battery mode' => l10n.rdValInvertMode,
    'bypass mode' => l10n.rdValBypassMode,
    'shutdown mode' => l10n.rdValShutdownMode,
    'standby' || 'idle' || 'static' => l10n.rdValIdle,
    'fault' => l10n.rdValFaultMode,
    'normal' => l10n.rdValNormal,
    'overload' => l10n.rdValOverload,
    'no load' => l10n.rdValNoLoad,
    _ => value,
  };
}

/// Realtime keys covered by [inverterReadingInfo] (used by the test).
const knownInverterReadingKeys = [
  'dualOutputVoltageSwitch',
  'acInputFrequency',
  'ledPatternLight1',
  'batteryNumber',
  'acInputVoltage',
  'workingStates',
  'acOutputActivePower',
  'batteryEqualizationMode',
  'gridConnectedSwitch1',
  'generationPower',
  'ratingOutputCurrent',
  'lowBatteryCutOffVoltage',
  'batteryCapacity',
  'startBalancing',
  'batteryDischargeCurrent',
  'gridConnectedCurrent',
  'ratedBatteryVoltage',
  'outputApparentPower',
  'dualOutputTurnOffVoltage',
  'mainCPUVersion1',
  'chargerSourcePriority',
  'comebackUtilityModeVolSBUPriorityStatus',
  'nominalAcVoltage',
  'nominalAcCurrent',
  'outputRelayStatus',
  'photovoltaicAccessFlag',
  'pvStatuss',
  'ratedOutputFrequency',
  'ratedOutputVoltage',
  'gridState',
  'batteryEqualizationInterval',
  'loadPercentage',
  'comebackBatteryModeVolSBUPriorityStatus',
  'pvInputPower',
  'maxTotalChargeCurrent1',
  'batState',
  'outputSourcePriority',
  'floatChargingVoltage',
  'batteryChargingCurrent',
  'acOutputRatingApparentPower',
  'loadStatus',
  'batteryEqualizationVoltage',
  'batteryVoltage',
  'outputVoltage',
  'bulkChargingVoltage',
  'batteryEqualizationTimeout',
  'feedInPower',
  'ntcMaximumTemperature',
  'mainsRelayStatus',
  'batteryRatingVoltage',
  'ratedActivePower',
  'pvInputVoltage',
  'mainsInputRange',
  'outputFrequency',
  'batteryEqualizationTime',
  'batteryType',
  'maxUtilityChargeCurrent1',
];
