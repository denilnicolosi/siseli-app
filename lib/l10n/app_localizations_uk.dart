// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Смарт Інвертор';

  @override
  String get login => 'Увійти';

  @override
  String get logout => 'Вийти';

  @override
  String get settings => 'Налаштування';

  @override
  String get theme => 'Тема';

  @override
  String get lightTheme => 'Світла тема';

  @override
  String get darkTheme => 'Темна тема';

  @override
  String get language => 'Мова';

  @override
  String get dashboard => 'Дашборд';

  @override
  String get data => 'Дані';

  @override
  String get energyOverview => 'Огляд енергії';

  @override
  String get production => 'Виробництво';

  @override
  String get consumption => 'Споживання';

  @override
  String get day => 'День';

  @override
  String get week => 'Тиждень';

  @override
  String get month => 'Місяць';

  @override
  String get mon => 'Пн';

  @override
  String get tue => 'Вт';

  @override
  String get wed => 'Ср';

  @override
  String get thu => 'Чт';

  @override
  String get fri => 'Пт';

  @override
  String get sat => 'Сб';

  @override
  String get sun => 'Нд';

  @override
  String get battery => 'Батарея';

  @override
  String get forecast => 'Прогноз';

  @override
  String get account => 'Акаунт';

  @override
  String get appSettings => 'Налаштування застосунку';

  @override
  String get editProfile => 'Редагувати профіль';

  @override
  String get cancel => 'Скасувати';

  @override
  String get save => 'Зберегти';

  @override
  String get userNameDefault => 'Користувач';

  @override
  String userId(String id) {
    return 'ID: $id';
  }

  @override
  String get advancedSettings => 'Розширені налаштування';

  @override
  String get email => 'Електронна пошта';

  @override
  String get password => 'Пароль';

  @override
  String get startWithWindows => 'Автозапуск з Windows';

  @override
  String get startInTray => 'Запускати в треї';

  @override
  String get startInTraySubtitle => 'Стартує згорнутим, якщо є збережена сесія';

  @override
  String get name => 'Ім\'я';

  @override
  String get notProvided => 'Не вказано';

  @override
  String get unknownValue => 'Невідомо';

  @override
  String get accountStatusLocal => 'Локальний профіль';

  @override
  String get accountStatusSynced => 'Профіль синхронізовано';

  @override
  String get cloudAccount => 'Cloud акаунт';

  @override
  String get phoneLabel => 'Телефон';

  @override
  String get sessionId => 'ID сесії';

  @override
  String get accountProfileHint =>
      'Дані профілю використовуються для відображення акаунта та доступу до хмари інвертора.';

  @override
  String get logoutConfirmMessage =>
      'Ви впевнені, що хочете вийти на цьому пристрої?';

  @override
  String get dangerZone => 'Небезпечна зона';

  @override
  String get nameCannotBeEmpty => 'Ім\'я не може бути порожнім';

  @override
  String get copy => 'Копіювати';

  @override
  String get copiedToClipboard => 'Скопійовано в буфер обміну';

  @override
  String get updatesTitle => 'Оновлення';

  @override
  String get updatesCheckingBackground => 'Перевірка оновлень у фоні...';

  @override
  String get updatesChecking => 'Перевірка оновлень...';

  @override
  String get updatesSubtitleDefault =>
      'Перевірити та встановити останню версію';

  @override
  String updatesSubtitleAvailable(String version) {
    return 'Доступна нова версія $version';
  }

  @override
  String updatesSubtitleSkipped(String version) {
    return 'Версію $version пропущено';
  }

  @override
  String updatesSubtitleUpToDate(String version) {
    return 'У вас остання версія ($version)';
  }

  @override
  String updatesLastChecked(String time) {
    return 'Остання перевірка: $time';
  }

  @override
  String updatesSkippedBanner(String version) {
    return 'Версію $version наразі пропущено.';
  }

  @override
  String get updatesSkippedRestored => 'Пропущену версію відновлено.';

  @override
  String get updatesRestore => 'Відновити';

  @override
  String updatesBannerAvailable(String version) {
    return 'Доступне оновлення $version';
  }

  @override
  String updatesCurrentVersion(String version) {
    return 'Поточна версія: $version';
  }

  @override
  String get updatesView => 'Переглянути';

  @override
  String get updatesSkip => 'Пропустити';

  @override
  String updatesSkippedNow(String version) {
    return 'Версію $version пропущено.';
  }

  @override
  String get updatesNoInstallerFound =>
      'У цьому релізі не знайдено сумісний інсталятор.';

  @override
  String get updatesDialogAvailableTitle => 'Доступне оновлення';

  @override
  String updatesDialogCurrent(String version) {
    return 'Поточна: $version';
  }

  @override
  String updatesDialogLatest(String version) {
    return 'Остання: $version';
  }

  @override
  String updatesDialogPublished(String time) {
    return 'Опубліковано: $time';
  }

  @override
  String updatesDialogPackage(String name) {
    return 'Пакет: $name';
  }

  @override
  String get updatesDialogSkipVersion => 'Пропустити цю версію';

  @override
  String get updatesDialogLater => 'Пізніше';

  @override
  String get updatesDialogDownload => 'Завантажити';

  @override
  String get updatesDialogDownloadingTitle => 'Завантаження оновлення';

  @override
  String get updatesDialogDownloadFailedTitle => 'Помилка завантаження';

  @override
  String get updatesDialogPreparing => 'Підготовка завантаження...';

  @override
  String get updatesDialogInstallTitle => 'Встановити оновлення';

  @override
  String updatesDialogInstallPrompt(String version) {
    return 'Оновлення завантажено ($version). Встановити зараз? Під час встановлення застосунок буде закрито.';
  }

  @override
  String get updatesDialogInstall => 'Встановити';

  @override
  String get updatesDialogInstallFailed =>
      'Не вдалося встановити. Запустіть інсталятор вручну.';

  @override
  String get updatesInstallPermissionNeeded =>
      'Дозвольте «Встановлення невідомих застосунків» для Smart Inverter у відкритих налаштуваннях, потім поверніться й натисніть «Встановити».';

  @override
  String get updatesDialogDownloadFailed =>
      'Не вдалося завантажити. Перевірте інтернет або файли релізу.';

  @override
  String get updatesDialogClose => 'Закрити';

  @override
  String get inverterSettings => 'Налаштування інвертора';

  @override
  String get refreshSettings => 'Оновити налаштування';

  @override
  String get settingsLoadingTitle => 'Налаштування завантажуються…';

  @override
  String get waitingInverterResponse => 'Очікуємо відповідь інвертора…';

  @override
  String get tapRefreshToLoad => 'Натисніть 🔄 для завантаження';

  @override
  String get realtimeReadings => 'Поточні показники';

  @override
  String unitOfMeasure(String unit) {
    return 'Одиниця виміру: $unit';
  }

  @override
  String get selectValue => 'Оберіть значення';

  @override
  String get newValue => 'Нове значення';

  @override
  String get apply => 'Застосувати';

  @override
  String get debugLogs => 'Debug Logs';

  @override
  String get viewSystemLogs => 'Переглянути системні логи';

  @override
  String get analyzeSystemLogs => 'Аналіз помилок застосунку та API-викликів';

  @override
  String get stationParameters => 'Параметри станції';

  @override
  String get stationParametersHint =>
      'Ці дані потрібні інтелектуальному алгоритму для точного розрахунку енергії та прогнозу погоди.';

  @override
  String get batteryCapacityLabel => 'Ємність АКБ';

  @override
  String get inputBreakerLabel => 'Ввідний автомат';

  @override
  String get gridVoltageLabel => 'Напруга мережі';

  @override
  String get houseLoadReserveLabel => 'Резерв навантаження будинку';

  @override
  String get autoReserveLoadTitle => 'Авто-резерв будинку';

  @override
  String get autoReserveLoadEnabledSubtitle =>
      'Резерв оновлюється автоматично за live та історичним навантаженням';

  @override
  String get autoReserveLoadDisabledSubtitle => 'Резерв фіксується вручну';

  @override
  String get reserveModeAuto => 'Режим: AUTO';

  @override
  String get reserveModeManual => 'Режим: MANUAL';

  @override
  String get reserveModeAutoHint =>
      'AUTO: резерв оновлюється за live-навантаженням і погодинним профілем зі згладжуванням та запасом безпеки.';

  @override
  String get reserveModeManualHint =>
      'MANUAL: резерв фіксований і дорівнює значенню, яке ви задали вручну.';

  @override
  String get houseLoadReserveHint =>
      'Резерв потужності для додаткових приладів, щоб під час заряду не вибивав автомат.';

  @override
  String get autoEstimateReserveLoad => 'Автооцінка резерву будинку';

  @override
  String get chargePowerEstimateTitle => 'Оцінка безпечної швидкості заряду';

  @override
  String get chargePowerSafeLimitLabel => 'Ліміт потужності заряду АКБ';

  @override
  String get chargeCurrentSafeLimitLabel => 'Ліміт струму заряду АКБ';

  @override
  String get chargeCurrentConservativeLabel => 'Консервативний струм заряду';

  @override
  String get chargeInputCurrentEstimateLabel => 'Оцінка струму по вводу AC';

  @override
  String get chargeBreakerRiskSafe => 'Ризик автомата: низький';

  @override
  String get chargeBreakerRiskElevated => 'Ризик автомата: підвищений';

  @override
  String get chargeBreakerRiskHigh =>
      'Ризик автомата: високий (можливе спрацювання)';

  @override
  String chargeBreakerRiskHint(String load) {
    return 'Аналіз враховує резерв/live/профільне навантаження: $load W';
  }

  @override
  String get chargeTimeToFullLabel => 'Час до 100%';

  @override
  String get chargeTimeUnavailable => 'Недостатньо даних';

  @override
  String get chargeEstimateNoRealtimeSoc =>
      'Немає поточного SOC. Час заряду з\'явиться після отримання телеметрії.';

  @override
  String chargeEstimateBasedOnSoc(String soc) {
    return 'Оцінка за поточним SOC: $soc%';
  }

  @override
  String get panelPowerLabel => 'Потужність панелей';

  @override
  String get inverterPowerLabel => 'Потужність інвертора';

  @override
  String get locationPreset => 'Пресет локації';

  @override
  String get latitudeLabel => 'Широта';

  @override
  String get longitudeLabel => 'Довгота';

  @override
  String get timeZoneLabel => 'Часовий пояс';

  @override
  String get geoPresetKyiv => 'Київ, UA';

  @override
  String get geoPresetLviv => 'Львів, UA';

  @override
  String get geoPresetOdesa => 'Одеса, UA';

  @override
  String get geoPresetDnipro => 'Дніпро, UA';

  @override
  String get geoPresetKharkiv => 'Харків, UA';

  @override
  String get geoPresetWarsaw => 'Варшава, PL';

  @override
  String get geoPresetBerlin => 'Берлін, DE';

  @override
  String get geoPresetCustom => 'Кастомно (вручну)';

  @override
  String geoSummary(String latitude, String longitude, String timeZone) {
    return 'Geo: $latitude, $longitude ($timeZone)';
  }

  @override
  String get useMyLocation => 'Використати мою позицію';

  @override
  String get locationHelp =>
      'Заповнює координати для прогнозу сонця та часовий пояс об\'єкта.';

  @override
  String get locationDetecting => 'Визначення позиції…';

  @override
  String locationDetected(String latitude, String longitude, String timeZone) {
    return 'Позицію визначено: $latitude, $longitude · $timeZone. Натисніть «Зберегти», щоб застосувати.';
  }

  @override
  String get locationServicesDisabled =>
      'Служби локації вимкнено. Увімкніть GPS у налаштуваннях системи й повторіть.';

  @override
  String get locationPermissionDenied =>
      'Доступ до локації відхилено. Дозвольте доступ для застосунку й повторіть.';

  @override
  String get locationPermissionDeniedForever =>
      'Доступ до локації заблоковано назавжди. Увімкніть його в налаштуваннях застосунку.';

  @override
  String get locationTimeout =>
      'GPS ще не визначив позицію. Повторіть біля вікна або з увімкненою високою точністю.';

  @override
  String get locationUnavailable =>
      'Не вдалося отримати поточну позицію. Повторіть.';

  @override
  String get openSettings => 'Відкрити налаштування';

  @override
  String get hardwareSettingsSaved => 'Параметри обладнання збережено!';

  @override
  String hardwareSummary(String battery, String pv, String inverter) {
    return 'АКБ: $battery Ah • PV: $pv W\nІнвертор: $inverter W';
  }

  @override
  String chargeLimitSummary(String breaker, String power, String current) {
    return 'Ввід C$breaker -> безпечний заряд АКБ $power W (~$current A)';
  }

  @override
  String get clear => 'Очистити';

  @override
  String get presetDisabled => 'Вимкнено';

  @override
  String get presetEnabled => 'Увімкнено';

  @override
  String get presetOutputUsb => 'USB - Пріоритет мережі';

  @override
  String get presetOutputSub => 'SUB - Пріоритет сонця';

  @override
  String get presetOutputSbu => 'SBU - Пріоритет сонця/АКБ';

  @override
  String get presetChargerCso => 'CSO - Спочатку сонце';

  @override
  String get presetChargerSnu => 'SNU - Сонце + Мережа';

  @override
  String get presetChargerOso => 'OSO - Тільки сонце';

  @override
  String get presetChargerUtilityOnly => 'Тільки мережа';

  @override
  String get presetFrequency50Hz => '50 Гц';

  @override
  String get presetFrequency60Hz => '60 Гц';

  @override
  String get presetAcInputAplWide => 'APL - Широкий діапазон';

  @override
  String get presetAcInputUpsNarrow => 'UPS - Вузький діапазон';

  @override
  String get presetBatteryTypeAgm => 'AGM';

  @override
  String get presetBatteryTypeFlooded => 'Flooded (залитий)';

  @override
  String get presetBatteryTypeUser => 'User (власні параметри)';

  @override
  String get presetBatteryTypeLib => 'LIB (літієвий)';

  @override
  String get presetBatteryTypeLife => 'LiFe';

  @override
  String get signInCloud => 'Увійдіть до Siseli Cloud';

  @override
  String get loginFailed => 'Помилка входу. Перевірте дані.';

  @override
  String get today => 'Сьогодні';

  @override
  String get forecastNextDays => 'Прогноз сонячної генерації на наступні дні';

  @override
  String get forecastPeak => 'Пік';

  @override
  String get forecastUnavailable => 'Дані прогнозу тимчасово недоступні';

  @override
  String get equipmentStatus => 'Статус обладнання';

  @override
  String get inverterLoad => 'Навантаження інвертора';

  @override
  String get refreshChart => 'Оновити графік';

  @override
  String get batterySignHint =>
      'АКБ: \'+\' означає заряд, \'-\' означає розряд.';

  @override
  String get chartNoDataTitle => 'Нема даних';

  @override
  String get chartNoDataMessage =>
      'Графік повинен завантажитися через деякий час';

  @override
  String get lessThanMinute => '< 1 хв';

  @override
  String minutesAgo(String count) {
    return '$count хв тому';
  }

  @override
  String hoursAgo(String count) {
    return '$count год тому';
  }

  @override
  String get solar => 'Сонце';

  @override
  String get load => 'Будинок';

  @override
  String get connectionOnline => 'Онлайн';

  @override
  String get connectionOffline => 'Офлайн';

  @override
  String get lastRealtimeUpdate => 'Останнє оновлення';

  @override
  String get dashboardAutoRefresh =>
      'Дані автоматично оновлюються кожні 60 секунд';

  @override
  String updatedAt(String time) {
    return 'Оновлено о $time';
  }

  @override
  String get updateFailed => 'Помилка оновлення';

  @override
  String get retry => 'Повторити';

  @override
  String get updated => 'Оновлено!';

  @override
  String get enableSolar => 'Увімкнути СОНЦЕ (SBU)';

  @override
  String get enableGrid => 'Увімкнути МЕРЕЖУ (USB)';

  @override
  String get showApp => 'Показати вікно';

  @override
  String get exit => 'Вийти';

  @override
  String batteryLevel(String level) {
    return 'АКБ: $level%';
  }

  @override
  String get batteryInstallYearLabel => 'Рік встановлення АКБ';

  @override
  String get notificationsTitle => 'Сповіщення';

  @override
  String get notificationsEmpty => 'Поки немає сповіщень';

  @override
  String get notificationsClear => 'Очистити всі';

  @override
  String get notifLowBatteryTitle => 'Низький заряд батареї';

  @override
  String notifLowBatteryBody(String soc) {
    return 'SOC батареї $soc% — наближається до резервного порогу';
  }

  @override
  String get notifBatteryRecoveredTitle => 'Батарея заряджена';

  @override
  String notifBatteryRecoveredBody(String soc) {
    return 'SOC батареї відновився до $soc%';
  }

  @override
  String get notifAnomalyTitle => 'Виявлено підвищене споживання';

  @override
  String notifAnomalyBody(String load, String times) {
    return 'Навантаження $load Вт — $times× вище норми для цієї години';
  }

  @override
  String get notifCycleTitle => 'Цикл заряду завершено';

  @override
  String notifCycleBody(String count, String soh) {
    return 'Всього циклів: $count. Стан батареї: $soh%';
  }

  @override
  String get socHistoryNoData =>
      'Даних ще недостатньо.\nДані збираються кожні 5 хвилин.';

  @override
  String get acInput => 'Вхід AC';

  @override
  String get mainSource => 'Основне джерело';

  @override
  String get chartFullscreen => 'На весь екран';

  @override
  String get chartRotate => 'Повернути';

  @override
  String forecastBasis(String kwp) {
    return 'Оцінка для $kwp кВтп панелей за сонячною радіацією Open-Meteo';
  }

  @override
  String get applySafeCurrent => 'Застосувати безпечний струм';

  @override
  String safeCurrentApplied(String target, String read) {
    return 'Безпечний струм застосовано: $target A (зчитано: $read)';
  }

  @override
  String safeCurrentFailed(String target, String read) {
    return 'Безпечний струм не підтверджено. Ціль $target A, зчитано: $read';
  }

  @override
  String get invSetOutputPriority => 'Output source priority';

  @override
  String get invSetOutputPriorityDesc =>
      'Which source powers the loads (program 01). USB: AC input first; solar and battery only when AC input is missing. SUB: solar charges the battery first, then feeds the loads; AC input covers the rest. SBU: solar first, then battery; AC input only when the battery falls to the back-to-AC point (program 12/43). Off-grid: use SBU.';

  @override
  String get invSetChargerPriority => 'Charger source priority';

  @override
  String get invSetChargerPriorityDesc =>
      'Which source charges the battery (program 16). CSO: solar first, AC input only when there is no sun. SNU: solar and AC input together. OSO: solar only, even when AC input is present. Without a generator on the AC input, only solar can charge.';

  @override
  String get invSetMaxChargeCurrent => 'Maximum charging current';

  @override
  String get invSetMaxChargeCurrentDesc =>
      'Total battery charging current, solar + AC input (program 02). It cannot be lower than the AC charging current (program 11). Stay within the battery maker\'s limit.';

  @override
  String get invSetAcChargeCurrent => 'Maximum AC charging current';

  @override
  String get invSetAcChargeCurrentDesc =>
      'Maximum current used to charge the battery from the AC input, grid or generator (program 11). Keep it low enough for the generator and the input breaker.';

  @override
  String get invSetAcInputRange => 'AC input voltage range';

  @override
  String get invSetAcInputRangeDesc =>
      'Accepted AC input voltage (program 03). APL (appliances): 90-280 V, wide range. UPS: 170-280 V, narrow range for sensitive loads. The wide range copes better with a generator whose voltage fluctuates.';

  @override
  String get invSetBatteryType => 'Battery type';

  @override
  String get invSetBatteryTypeDesc =>
      'Battery chemistry; it sets the charge voltages (program 05). AGM and Flooded: lead-acid presets. User-defined: you set bulk, float and cut-off voltages (programs 26, 27, 29). LIB/LiFe: lithium.';

  @override
  String get invSetOverloadRestart => 'Auto restart after overload';

  @override
  String get invSetOverloadRestartDesc =>
      'If enabled, the output turns back on by itself after an overload shutdown (program 06).';

  @override
  String get invSetOverTempRestart => 'Auto restart after over-temperature';

  @override
  String get invSetOverTempRestartDesc =>
      'If enabled, the output turns back on by itself after an over-temperature shutdown (program 07).';

  @override
  String get invSetOutputVoltage => 'Output voltage';

  @override
  String get invSetOutputVoltageDesc =>
      'AC voltage supplied to the loads (program 08). Europe: 230 V.';

  @override
  String get invSetOutputFrequency => 'Output frequency';

  @override
  String get invSetOutputFrequencyDesc =>
      'AC frequency supplied to the loads (program 09). Europe: 50 Hz.';

  @override
  String get invSetOverloadBypass => 'Bypass on overload';

  @override
  String get invSetOverloadBypassDesc =>
      'If enabled, on overload in battery mode the inverter moves the loads to the AC input (program 23). It only helps when a generator is connected.';

  @override
  String get invSetBuzzer => 'Buzzer alarm';

  @override
  String get invSetBuzzerDesc =>
      'Turns the inverter buzzer on or off for warnings and faults (program 18).';

  @override
  String get invSetSourceLossBeep => 'Beep when primary source is lost';

  @override
  String get invSetSourceLossBeepDesc =>
      'If enabled, the inverter beeps when the primary source chosen in program 01 is interrupted (program 22).';

  @override
  String get invSetReturnToDefaultScreen => 'Return to default screen';

  @override
  String get invSetReturnToDefaultScreenDesc =>
      'If enabled, the LCD goes back to the default screen about 1 minute after the last key press; otherwise it stays on the last screen (program 19).';

  @override
  String get invSetBacklight => 'LCD backlight';

  @override
  String get invSetBacklightDesc =>
      'Keeps the LCD backlight always on, or lets it switch off when idle (program 20).';

  @override
  String get invSetRecordFaults => 'Record fault codes';

  @override
  String get invSetRecordFaultsDesc =>
      'If enabled, the inverter stores fault codes in its history (program 25).';

  @override
  String get invSetEqualization => 'Battery equalization';

  @override
  String get invSetEqualizationDesc =>
      'Periodic controlled overcharge that balances lead-acid cells (program 33). Only for Flooded or User-defined batteries; keep it off for lithium.';

  @override
  String get invSetEqualizationNow => 'Start equalization now';

  @override
  String get invSetEqualizationNowDesc =>
      'Starts an equalization cycle right away (program 39). Works only if equalization (program 33) is enabled.';

  @override
  String get invSetBatteryPowerLimit => 'Battery power limiting';

  @override
  String get invSetBatteryPowerLimitDesc =>
      'Limits the power taken from the battery. Not described in the Easun manual: check the inverter documentation before changing it.';

  @override
  String get invSetSmartLoadCutOff => 'Smart load cut-off on battery voltage';

  @override
  String get invSetSmartLoadCutOffDesc =>
      'Disconnects the smart (secondary) load output based on battery voltage. Not described in the Easun manual: check the inverter documentation before changing it.';

  @override
  String get invSetRgbLight => 'RGB light';

  @override
  String get invSetRgbLightDesc =>
      'Turns the inverter RGB status light on or off.';

  @override
  String get rdDualOutputVoltageSwitch => 'Dual output';

  @override
  String get rdDualOutputVoltageSwitchDesc =>
      'Second AC output for non-essential loads; it is switched off when the battery drops to the turn-off voltage.';

  @override
  String get rdAcInputFrequency => 'AC input frequency';

  @override
  String get rdAcInputFrequencyDesc =>
      'Frequency on the AC input (grid or generator). 0 Hz means nothing is connected.';

  @override
  String get rdLedPatternLight1 => 'LED lights';

  @override
  String get rdLedPatternLight1Desc =>
      'State of the inverter status LED lights.';

  @override
  String get rdBatteryNumber => 'Battery system voltage';

  @override
  String get rdBatteryNumberDesc =>
      'Battery bank voltage class the inverter is built for.';

  @override
  String get rdAcInputVoltage => 'AC input voltage';

  @override
  String get rdAcInputVoltageDesc =>
      'Voltage on the AC input. 0 V means no grid or generator is connected.';

  @override
  String get rdWorkingStates => 'Working state';

  @override
  String get rdWorkingStatesDesc =>
      'Current inverter mode: Invert (loads from battery/solar), Line (loads from the AC input), Standby or Fault.';

  @override
  String get rdAcOutputActivePower => 'Output active power';

  @override
  String get rdAcOutputActivePowerDesc => 'Real power the loads are using now.';

  @override
  String get rdBatteryEqualizationMode => 'Battery equalization';

  @override
  String get rdBatteryEqualizationModeDesc =>
      'Whether periodic equalization is enabled (program 33). Lead-acid batteries only.';

  @override
  String get rdGridConnectedSwitch1 => 'Grid feed-in';

  @override
  String get rdGridConnectedSwitch1Desc =>
      'Whether the inverter may feed power into the grid. Off-grid: keep it off.';

  @override
  String get rdGenerationPower => 'Generation power';

  @override
  String get rdGenerationPowerDesc =>
      'Power the solar panels are producing now.';

  @override
  String get rdRatingOutputCurrent => 'Nominal output current';

  @override
  String get rdRatingOutputCurrentDesc =>
      'Maximum continuous AC output current of the inverter (rating plate value).';

  @override
  String get rdLowBatteryCutOffVoltage => 'Low battery cut-off voltage';

  @override
  String get rdLowBatteryCutOffVoltageDesc =>
      'Below this voltage the inverter turns the output off to protect the battery (program 29).';

  @override
  String get rdBatteryCapacity => 'Battery charge (SOC)';

  @override
  String get rdBatteryCapacityDesc =>
      'State of charge reported by the inverter.';

  @override
  String get rdStartBalancing => 'Start equalization now';

  @override
  String get rdStartBalancingDesc =>
      'Whether an immediate equalization cycle is requested (program 39).';

  @override
  String get rdBatteryDischargeCurrent => 'Battery discharge current';

  @override
  String get rdBatteryDischargeCurrentDesc =>
      'Current flowing out of the battery now.';

  @override
  String get rdGridConnectedCurrent => 'Grid feed-in current';

  @override
  String get rdGridConnectedCurrentDesc =>
      'Maximum current fed into the grid when feed-in is on. Not used off-grid.';

  @override
  String get rdRatedBatteryVoltage => 'Nominal battery voltage';

  @override
  String get rdRatedBatteryVoltageDesc => 'Rated voltage of the battery bank.';

  @override
  String get rdOutputApparentPower => 'Output apparent power';

  @override
  String get rdOutputApparentPowerDesc =>
      'Apparent power (VA) drawn by the loads, reactive part included: it is what the inverter has to supply.';

  @override
  String get rdDualOutputTurnOffVoltage => 'Dual output turn-off voltage';

  @override
  String get rdDualOutputTurnOffVoltageDesc =>
      'Battery voltage at which the second output is switched off.';

  @override
  String get rdMainCPUVersion1 => 'Main CPU firmware';

  @override
  String get rdMainCPUVersion1Desc =>
      'Firmware version of the inverter main processor.';

  @override
  String get rdChargerSourcePriority => 'Charger source priority';

  @override
  String get rdChargerSourcePriorityDesc =>
      'Current charger priority (program 16). CSO: solar first. SNU: solar + AC input. OSO: solar only.';

  @override
  String get rdComebackUtilityModeVolSBUPriorityStatus =>
      'Back-to-AC voltage (SBU)';

  @override
  String get rdComebackUtilityModeVolSBUPriorityStatusDesc =>
      'With SBU or solar first, below this battery voltage the loads move to the AC input (program 12). Without a generator it has no effect.';

  @override
  String get rdNominalAcVoltage => 'Nominal AC voltage';

  @override
  String get rdNominalAcVoltageDesc => 'Rated AC voltage of the inverter.';

  @override
  String get rdNominalAcCurrent => 'Nominal AC current';

  @override
  String get rdNominalAcCurrentDesc => 'Rated AC current of the inverter.';

  @override
  String get rdOutputRelayStatus => 'Output relay';

  @override
  String get rdOutputRelayStatusDesc => 'ON means the AC output is powered.';

  @override
  String get rdPhotovoltaicAccessFlag => 'PV connection';

  @override
  String get rdPhotovoltaicAccessFlagDesc =>
      'Whether the inverter detects the solar panels.';

  @override
  String get rdPvStatuss => 'PV status';

  @override
  String get rdPvStatussDesc =>
      'Working state of the solar input (MPPT charger).';

  @override
  String get rdRatedOutputFrequency => 'Nominal output frequency';

  @override
  String get rdRatedOutputFrequencyDesc =>
      'Output frequency set on the inverter (program 09).';

  @override
  String get rdRatedOutputVoltage => 'Nominal output voltage';

  @override
  String get rdRatedOutputVoltageDesc =>
      'Output voltage set on the inverter (program 08).';

  @override
  String get rdGridState => 'AC input state';

  @override
  String get rdGridStateDesc =>
      'Whether the AC input (grid or generator) is connected.';

  @override
  String get rdBatteryEqualizationInterval => 'Equalization interval';

  @override
  String get rdBatteryEqualizationIntervalDesc =>
      'Days between two equalization cycles (program 37).';

  @override
  String get rdLoadPercentage => 'Load percentage';

  @override
  String get rdLoadPercentageDesc =>
      'Output load as a share of the inverter rated power.';

  @override
  String get rdComebackBatteryModeVolSBUPriorityStatus =>
      'Back-to-battery voltage (SBU)';

  @override
  String get rdComebackBatteryModeVolSBUPriorityStatusDesc =>
      'With SBU or solar first, above this battery voltage the loads go back to the battery (program 13).';

  @override
  String get rdPvInputPower => 'PV input power';

  @override
  String get rdPvInputPowerDesc =>
      'Power entering from the solar panels into the MPPT charger.';

  @override
  String get rdMaxTotalChargeCurrent1 => 'Max total charge current';

  @override
  String get rdMaxTotalChargeCurrent1Desc =>
      'Total charging limit, solar + AC input (program 02).';

  @override
  String get rdBatState => 'Battery state';

  @override
  String get rdBatStateDesc =>
      'Whether the battery is charging, discharging or idle.';

  @override
  String get rdOutputSourcePriority => 'Output source priority';

  @override
  String get rdOutputSourcePriorityDesc =>
      'Current output priority (program 01). USB: AC input first. SUB: solar charges first, AC covers the rest. SBU: solar, then battery, then AC.';

  @override
  String get rdFloatChargingVoltage => 'Float charging voltage';

  @override
  String get rdFloatChargingVoltageDesc =>
      'Voltage held once the battery is full (program 27).';

  @override
  String get rdBatteryChargingCurrent => 'Battery charging current';

  @override
  String get rdBatteryChargingCurrentDesc =>
      'Current flowing into the battery now.';

  @override
  String get rdAcOutputRatingApparentPower => 'Nominal apparent power';

  @override
  String get rdAcOutputRatingApparentPowerDesc =>
      'Rated output power of the inverter in VA.';

  @override
  String get rdLoadStatus => 'Load status';

  @override
  String get rdLoadStatusDesc =>
      'Whether the output load is normal or overloaded.';

  @override
  String get rdBatteryEqualizationVoltage => 'Equalization voltage';

  @override
  String get rdBatteryEqualizationVoltageDesc =>
      'Charging voltage used during equalization (program 34).';

  @override
  String get rdBatteryVoltage => 'Battery voltage';

  @override
  String get rdBatteryVoltageDesc => 'Battery voltage measured now.';

  @override
  String get rdOutputVoltage => 'Output voltage';

  @override
  String get rdOutputVoltageDesc => 'AC voltage on the output now.';

  @override
  String get rdBulkChargingVoltage => 'Bulk charging voltage';

  @override
  String get rdBulkChargingVoltageDesc =>
      'Constant-voltage charging target (program 26).';

  @override
  String get rdBatteryEqualizationTimeout => 'Equalization timeout';

  @override
  String get rdBatteryEqualizationTimeoutDesc =>
      'Maximum extra time allowed for an equalization cycle (program 36).';

  @override
  String get rdFeedInPower => 'Feed-in power';

  @override
  String get rdFeedInPowerDesc =>
      'Power sent to the grid. Off-grid it stays at 0.';

  @override
  String get rdNtcMaximumTemperature => 'Max internal temperature';

  @override
  String get rdNtcMaximumTemperatureDesc =>
      'Highest temperature measured by the inverter internal sensors (NTC).';

  @override
  String get rdMainsRelayStatus => 'AC input relay';

  @override
  String get rdMainsRelayStatusDesc =>
      'ON means loads or charger are connected to the AC input.';

  @override
  String get rdBatteryRatingVoltage => 'Rated voltage';

  @override
  String get rdBatteryRatingVoltageDesc =>
      'Rated voltage reported by the inverter.';

  @override
  String get rdRatedActivePower => 'Nominal active power';

  @override
  String get rdRatedActivePowerDesc =>
      'Rated continuous output power of the inverter in W.';

  @override
  String get rdPvInputVoltage => 'PV input voltage';

  @override
  String get rdPvInputVoltageDesc =>
      'Voltage of the solar string; it must stay inside the MPPT voltage range.';

  @override
  String get rdMainsInputRange => 'AC input range';

  @override
  String get rdMainsInputRangeDesc =>
      'Accepted AC input voltage range (program 03). APL: 90-280 V. UPS: 170-280 V.';

  @override
  String get rdOutputFrequency => 'Output frequency';

  @override
  String get rdOutputFrequencyDesc => 'AC frequency measured on the output.';

  @override
  String get rdBatteryEqualizationTime => 'Equalization time';

  @override
  String get rdBatteryEqualizationTimeDesc =>
      'Duration of an equalization cycle (program 35).';

  @override
  String get rdBatteryType => 'Battery type';

  @override
  String get rdBatteryTypeDesc =>
      'Battery type set on the inverter (program 05).';

  @override
  String get rdMaxUtilityChargeCurrent1 => 'AC charging current';

  @override
  String get rdMaxUtilityChargeCurrent1Desc =>
      'Maximum current for charging from the AC input (program 11).';

  @override
  String get rdValOn => 'On';

  @override
  String get rdValOff => 'Off';

  @override
  String get rdValEnabled => 'Enabled';

  @override
  String get rdValDisabled => 'Disabled';

  @override
  String get rdValCharging => 'Charging';

  @override
  String get rdValDischarging => 'Discharging';

  @override
  String get rdValInvertMode => 'Inverter mode';

  @override
  String get rdValLineMode => 'Line mode';

  @override
  String get rdValStandbyMode => 'Standby';

  @override
  String get rdValFaultMode => 'Fault';

  @override
  String get rdValAcNotConnected => 'AC input not connected';

  @override
  String get rdValAcConnected => 'AC input connected';

  @override
  String get rdValNormal => 'Normal';

  @override
  String get rdValPvWorking => 'Connected and working';

  @override
  String get rdValPvConnected => 'Panels connected';

  @override
  String get invSetBackToAcVoltage => 'Back-to-AC voltage (SBU)';

  @override
  String get invSetBackToAcVoltageDesc =>
      'With SBU or solar first in program 01, below this battery voltage the loads move to the AC input (program 12). It must be lower than the back-to-battery voltage. Without a generator it has no effect.';

  @override
  String get invSetBackToBatteryVoltage => 'Back-to-battery voltage (SBU)';

  @override
  String get invSetBackToBatteryVoltageDesc =>
      'With SBU or solar first, once the battery is back above this voltage the loads return to battery power (program 13). It must be higher than the back-to-AC voltage.';

  @override
  String get invSetBulkVoltage => 'Bulk charging voltage (C.V.)';

  @override
  String get invSetBulkVoltageDesc =>
      'Constant-voltage charging target (program 26). Editable only with a User-defined battery; it must be at least the float voltage. Follow the battery maker\'s values.';

  @override
  String get invSetFloatVoltage => 'Float charging voltage';

  @override
  String get invSetFloatVoltageDesc =>
      'Voltage held once the battery is full (program 27). Editable only with a User-defined battery; it cannot exceed the bulk voltage.';

  @override
  String get invSetLowCutOffVoltage => 'Low DC cut-off voltage';

  @override
  String get invSetLowCutOffVoltageDesc =>
      'Below this battery voltage the inverter turns the output off to protect the battery (program 29). It must be lower than the back-to-AC voltage.';

  @override
  String get invSetLowCutOffSoc => 'Low DC cut-off SOC';

  @override
  String get invSetLowCutOffSocDesc =>
      'With a lithium battery that talks to the inverter: below this state of charge the output turns off (program 45, default 20%, range 3-30%).';

  @override
  String get invSetEqVoltage => 'Equalization voltage';

  @override
  String get invSetEqVoltageDesc =>
      'Charging voltage used during equalization (program 34). Lead-acid only.';

  @override
  String get invSetEqTime => 'Equalization time';

  @override
  String get invSetEqTimeDesc =>
      'How long the equalization voltage is held (program 35, 0-900 min).';

  @override
  String get invSetEqTimeout => 'Equalization timeout';

  @override
  String get invSetEqTimeoutDesc =>
      'Extra time allowed if the equalization voltage is not reached (program 36, 0-900 min).';

  @override
  String get invSetEqInterval => 'Equalization interval';

  @override
  String get invSetEqIntervalDesc =>
      'Days between two equalization cycles (program 37, 1-90 days).';

  @override
  String get invSetOutputDelay => 'Output delay';

  @override
  String get invSetOutputDelayDesc =>
      'Delay before the AC output turns on. Not described in the Easun manual: check the inverter documentation before changing it.';

  @override
  String get socDayChartTitle => 'Заряд батареї (SOC) протягом дня';

  @override
  String batteryDurationForecast(Object time, Object date) {
    return 'Прогноз тривалості роботи батареї: до $time $date';
  }

  @override
  String get flowLosses => 'Втрати';

  @override
  String get flowLossesHint =>
      'Вхідна потужність (сонце, вхід AC, батарея), що не доходить до навантаження чи батареї: власне споживання інвертора та втрати перетворення.';

  @override
  String get flowMismatch => 'Розбіжність вимірів';

  @override
  String get flowMismatchHint =>
      'Вихідна потужність більша за вхідну за показами: значення зчитано в трохи різні моменти.';

  @override
  String get batteryChargedTotal => 'Заряд АКБ';

  @override
  String get batteryDischargedTotal => 'Розряд АКБ';

  @override
  String get flowInverter => 'Інвертор';

  @override
  String get flowPower => 'Потужність';

  @override
  String get rdValPvNotConnected => 'Panels not connected';

  @override
  String get rdValPvLowVoltage => 'Not connected: voltage below the minimum';

  @override
  String get rdValPowerOnMode => 'Starting up';

  @override
  String get rdValPowerSavingMode => 'Power saving';

  @override
  String get rdValBypassMode => 'Bypass';

  @override
  String get rdValShutdownMode => 'Shut down';

  @override
  String get rdValIdle => 'Idle';

  @override
  String get rdValOverload => 'Overload';

  @override
  String get rdValNoLoad => 'No load';

  @override
  String get inverterSelfUseLabel => 'Inverter self-consumption';

  @override
  String get inverterSelfUseHint =>
      'Power the inverter uses for itself. The cloud sends battery current in whole amps, so below 3 A the battery power is estimated as solar − consumption − this value.';
}
