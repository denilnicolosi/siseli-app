import '../l10n/app_localizations.dart';

/// Localized name + explanation for an inverter config key.
///
/// Texts follow the LCD setting programs of the Easun iSolar SMH/SMG manual
/// (program numbers quoted in each description). Returns null for keys we do
/// not know, so the UI can fall back to the name sent by the API.
({String name, String description})? inverterSettingInfo(
    AppLocalizations l10n, String key) {
  return switch (key) {
    'outputSourcePrioritySetting' => (
        name: l10n.invSetOutputPriority,
        description: l10n.invSetOutputPriorityDesc,
      ),
    'chargerSourcePrioritySetting' => (
        name: l10n.invSetChargerPriority,
        description: l10n.invSetChargerPriorityDesc,
      ),
    'setMaxChargingCurrent' => (
        name: l10n.invSetMaxChargeCurrent,
        description: l10n.invSetMaxChargeCurrentDesc,
      ),
    'setUtilityMaxChargingCurrent' => (
        name: l10n.invSetAcChargeCurrent,
        description: l10n.invSetAcChargeCurrentDesc,
      ),
    'acInputRangeSetting' => (
        name: l10n.invSetAcInputRange,
        description: l10n.invSetAcInputRangeDesc,
      ),
    'settingBatteryType' => (
        name: l10n.invSetBatteryType,
        description: l10n.invSetBatteryTypeDesc,
      ),
    'overLoadRestartSetting' => (
        name: l10n.invSetOverloadRestart,
        description: l10n.invSetOverloadRestartDesc,
      ),
    'overTemperatureAutoRestartSetting' => (
        name: l10n.invSetOverTempRestart,
        description: l10n.invSetOverTempRestartDesc,
      ),
    'outputVoltageSettings' => (
        name: l10n.invSetOutputVoltage,
        description: l10n.invSetOutputVoltageDesc,
      ),
    'outputFrequencySetting' => (
        name: l10n.invSetOutputFrequency,
        description: l10n.invSetOutputFrequencyDesc,
      ),
    'transferToBypassFromOverload' => (
        name: l10n.invSetOverloadBypass,
        description: l10n.invSetOverloadBypassDesc,
      ),
    'buzzerAlarmSetting' => (
        name: l10n.invSetBuzzer,
        description: l10n.invSetBuzzerDesc,
      ),
    'beepsWhilePrimarySourceInterupt' => (
        name: l10n.invSetSourceLossBeep,
        description: l10n.invSetSourceLossBeepDesc,
      ),
    'autoReturnToDefaultDisplayScreen' => (
        name: l10n.invSetReturnToDefaultScreen,
        description: l10n.invSetReturnToDefaultScreenDesc,
      ),
    'lcdBacklightSetting' => (
        name: l10n.invSetBacklight,
        description: l10n.invSetBacklightDesc,
      ),
    'recordFaultCodeSetting' => (
        name: l10n.invSetRecordFaults,
        description: l10n.invSetRecordFaultsDesc,
      ),
    'batteryEqualizationSetting' => (
        name: l10n.invSetEqualization,
        description: l10n.invSetEqualizationDesc,
      ),
    'batteryEqualizationActivateImmediate' => (
        name: l10n.invSetEqualizationNow,
        description: l10n.invSetEqualizationNowDesc,
      ),
    'batteryPowerLimitingSetting' => (
        name: l10n.invSetBatteryPowerLimit,
        description: l10n.invSetBatteryPowerLimitDesc,
      ),
    'cutOffVoltBatteryForSmartMainLoad' => (
        name: l10n.invSetSmartLoadCutOff,
        description: l10n.invSetSmartLoadCutOffDesc,
      ),
    'rgbOnAndOffControlSetting' => (
        name: l10n.invSetRgbLight,
        description: l10n.invSetRgbLightDesc,
      ),
    'comebackUtilityModeVolSBUPriority' => (
        name: l10n.invSetBackToAcVoltage,
        description: l10n.invSetBackToAcVoltageDesc,
      ),
    'comebackBatteryModeVolSBUPriority' => (
        name: l10n.invSetBackToBatteryVoltage,
        description: l10n.invSetBackToBatteryVoltageDesc,
      ),
    'setBatteryCVChargeVoltage' => (
        name: l10n.invSetBulkVoltage,
        description: l10n.invSetBulkVoltageDesc,
      ),
    'setBatteryFloatChargingVoltage' => (
        name: l10n.invSetFloatVoltage,
        description: l10n.invSetFloatVoltageDesc,
      ),
    'LowBatteryCutOffVoltageSetting' => (
        name: l10n.invSetLowCutOffVoltage,
        description: l10n.invSetLowCutOffVoltageDesc,
      ),
    'lowDCCutOffSOCSetting' => (
        name: l10n.invSetLowCutOffSoc,
        description: l10n.invSetLowCutOffSocDesc,
      ),
    'setBatteryEqualizationVoltage' => (
        name: l10n.invSetEqVoltage,
        description: l10n.invSetEqVoltageDesc,
      ),
    'setBatteryEqualizationTime' => (
        name: l10n.invSetEqTime,
        description: l10n.invSetEqTimeDesc,
      ),
    'setBatteryEqualizationOverTime' => (
        name: l10n.invSetEqTimeout,
        description: l10n.invSetEqTimeoutDesc,
      ),
    'batteryEqualizationIntervalSetting' => (
        name: l10n.invSetEqInterval,
        description: l10n.invSetEqIntervalDesc,
      ),
    'outputDelaySetting' => (
        name: l10n.invSetOutputDelay,
        description: l10n.invSetOutputDelayDesc,
      ),
    _ => null,
  };
}

/// Config keys covered by [inverterSettingInfo] (used by the test).
const knownInverterSettingKeys = [
  'outputSourcePrioritySetting',
  'chargerSourcePrioritySetting',
  'setMaxChargingCurrent',
  'setUtilityMaxChargingCurrent',
  'acInputRangeSetting',
  'settingBatteryType',
  'overLoadRestartSetting',
  'overTemperatureAutoRestartSetting',
  'outputVoltageSettings',
  'outputFrequencySetting',
  'transferToBypassFromOverload',
  'buzzerAlarmSetting',
  'beepsWhilePrimarySourceInterupt',
  'autoReturnToDefaultDisplayScreen',
  'lcdBacklightSetting',
  'recordFaultCodeSetting',
  'batteryEqualizationSetting',
  'batteryEqualizationActivateImmediate',
  'batteryPowerLimitingSetting',
  'cutOffVoltBatteryForSmartMainLoad',
  'rgbOnAndOffControlSetting',
  'comebackUtilityModeVolSBUPriority',
  'comebackBatteryModeVolSBUPriority',
  'setBatteryCVChargeVoltage',
  'setBatteryFloatChargingVoltage',
  'LowBatteryCutOffVoltageSetting',
  'lowDCCutOffSOCSetting',
  'setBatteryEqualizationVoltage',
  'setBatteryEqualizationTime',
  'setBatteryEqualizationOverTime',
  'batteryEqualizationIntervalSetting',
  'outputDelaySetting',
];
