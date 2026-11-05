// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Smart Inverter';

  @override
  String get login => 'Accedi';

  @override
  String get logout => 'Esci';

  @override
  String get settings => 'Impostazioni';

  @override
  String get theme => 'Tema';

  @override
  String get lightTheme => 'Tema chiaro';

  @override
  String get darkTheme => 'Tema scuro';

  @override
  String get language => 'Lingua';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get automation => 'Automazione';

  @override
  String get data => 'Dati';

  @override
  String get energyOverview => 'Panoramica energia';

  @override
  String get production => 'Produzione';

  @override
  String get consumption => 'Consumo';

  @override
  String get day => 'Giorno';

  @override
  String get week => 'Settimana';

  @override
  String get month => 'Mese';

  @override
  String get mon => 'Lun';

  @override
  String get tue => 'Mar';

  @override
  String get wed => 'Mer';

  @override
  String get thu => 'Gio';

  @override
  String get fri => 'Ven';

  @override
  String get sat => 'Sab';

  @override
  String get sun => 'Dom';

  @override
  String get battery => 'Batteria';

  @override
  String get grid => 'Rete';

  @override
  String get forecast => 'Previsioni';

  @override
  String get modeAdaptive => 'Intelligenza adattiva (Auto)';

  @override
  String get modeAdaptiveSubtitle =>
      'Modalità dinamica: previsioni, tariffa e stato batteria';

  @override
  String get modeAdaptiveDesc =>
      'La modalità adattiva analizza continuamente:\n• produzione FV e consumo di casa in tempo reale\n• previsione solare per il resto della giornata\n• SOC della batteria e riserva di sicurezza\n• fasce tariffarie orarie (notte/giorno/sera)\n\nCosa fa:\n• Di notte prevede se il sole di domani basterà e decide se serve caricare dalla rete\n• Di giorno ottimizza la priorità delle sorgenti per conservare energia per il picco serale\n• La sera usa l\'energia della batteria fino alla soglia di riserva configurata\n• Torna automaticamente alla rete se la sicurezza della batteria o la stabilità dell\'alimentazione sono a rischio\n\nRisultato: meno commutazioni manuali, costi energetici più bassi e funzionamento quotidiano più stabile.';

  @override
  String get modeArbitrage => 'Arbitraggio notturno';

  @override
  String get modeArbitrageSubtitle =>
      'Ottimizzazione rigorosa dei costi per fasce tariffarie';

  @override
  String get modeArbitrageDesc =>
      'Questa modalità punta al minimo costo dell\'elettricità:\n• Nella fascia notturna forza il funzionamento da rete e carica la batteria\n• Di giorno/sera dà priorità a batteria e solare\n• La carica da rete è disattivata fuori dalla fascia notturna\n\nIdeale quando il risparmio è l\'obiettivo principale, anche con più cicli della batteria.';

  @override
  String get modeStorm => 'Riserva / Tempesta';

  @override
  String get modeStormSubtitle => 'Massima prontezza di backup per i blackout';

  @override
  String get modeStormDesc =>
      'Questa modalità privilegia l\'affidabilità rispetto al risparmio:\n• Mantiene la batteria il più carica possibile\n• Alimenta la casa dalla rete per conservare la batteria per le emergenze\n• Ignora l\'ottimizzazione tariffaria quando la riserva è critica\n\nConsigliata prima di temporali, periodi di rete instabile o blackout prolungati previsti.';

  @override
  String get account => 'Account';

  @override
  String get appSettings => 'Impostazioni applicazione';

  @override
  String get editProfile => 'Modifica profilo';

  @override
  String get cancel => 'Annulla';

  @override
  String get confirm => 'Conferma';

  @override
  String get save => 'Salva';

  @override
  String get userNameDefault => 'Utente';

  @override
  String userId(String id) {
    return 'ID: $id';
  }

  @override
  String get advancedSettings => 'Impostazioni avanzate';

  @override
  String get hemsTitle => 'Modalità HEMS intelligenti';

  @override
  String get hemsSubtitle =>
      'Scegli la strategia: automazione adattiva, risparmio o riserva di backup';

  @override
  String get gotIt => 'Ho capito';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get startWithWindows => 'Avvia con Windows';

  @override
  String get startInTray => 'Avvia nella tray';

  @override
  String get startInTraySubtitle =>
      'Si avvia ridotta a icona se esiste una sessione salvata';

  @override
  String get name => 'Nome';

  @override
  String get notProvided => 'Non fornito';

  @override
  String get unknownValue => 'Sconosciuto';

  @override
  String get accountStatusLocal => 'Solo profilo locale';

  @override
  String get accountStatusSynced => 'Profilo cloud sincronizzato';

  @override
  String get cloudAccount => 'Account cloud';

  @override
  String get phoneLabel => 'Telefono';

  @override
  String get sessionId => 'ID sessione';

  @override
  String get accountProfileHint =>
      'I dati del profilo servono per mostrare l\'account e accedere al cloud dell\'inverter.';

  @override
  String get logoutConfirmMessage =>
      'Vuoi davvero uscire da questo dispositivo?';

  @override
  String get dangerZone => 'Zona pericolosa';

  @override
  String get nameCannotBeEmpty => 'Il nome non può essere vuoto';

  @override
  String get copy => 'Copia';

  @override
  String get copiedToClipboard => 'Copiato negli appunti';

  @override
  String get diagnosticsSnapshot => 'Istantanea diagnostica';

  @override
  String get diagnosticsSnapshotHint =>
      'Copia un report compatto per la risoluzione problemi o l\'assistenza.';

  @override
  String get copyDiagnosticsSnapshot => 'Copia istantanea';

  @override
  String get diagnosticsSnapshotCopied =>
      'Istantanea diagnostica copiata negli appunti';

  @override
  String get updatesTitle => 'Aggiornamenti';

  @override
  String get updatesCheckingBackground =>
      'Verifica aggiornamenti in background...';

  @override
  String get updatesChecking => 'Verifica aggiornamenti...';

  @override
  String get updatesSubtitleDefault =>
      'Controlla e installa l\'ultima versione';

  @override
  String updatesSubtitleAvailable(String version) {
    return 'Nuova versione $version disponibile';
  }

  @override
  String updatesSubtitleSkipped(String version) {
    return 'Versione $version ignorata';
  }

  @override
  String updatesSubtitleUpToDate(String version) {
    return 'Sei aggiornato ($version)';
  }

  @override
  String updatesLastChecked(String time) {
    return 'Ultimo controllo: $time';
  }

  @override
  String updatesSkippedBanner(String version) {
    return 'La versione $version è attualmente ignorata.';
  }

  @override
  String get updatesSkippedRestored => 'Versione ignorata ripristinata.';

  @override
  String get updatesRestore => 'Ripristina';

  @override
  String updatesBannerAvailable(String version) {
    return 'Nuovo aggiornamento $version disponibile';
  }

  @override
  String updatesCurrentVersion(String version) {
    return 'Versione attuale: $version';
  }

  @override
  String get updatesView => 'Vedi';

  @override
  String get updatesSkip => 'Ignora';

  @override
  String updatesSkippedNow(String version) {
    return 'La versione $version è stata ignorata.';
  }

  @override
  String get updatesNoInstallerFound =>
      'Nessun installer compatibile trovato in questa release.';

  @override
  String get updatesDialogAvailableTitle => 'Aggiornamento disponibile';

  @override
  String updatesDialogCurrent(String version) {
    return 'Attuale: $version';
  }

  @override
  String updatesDialogLatest(String version) {
    return 'Più recente: $version';
  }

  @override
  String updatesDialogPublished(String time) {
    return 'Pubblicata: $time';
  }

  @override
  String updatesDialogPackage(String name) {
    return 'Pacchetto: $name';
  }

  @override
  String get updatesDialogSkipVersion => 'Ignora questa versione';

  @override
  String get updatesDialogLater => 'Più tardi';

  @override
  String get updatesDialogDownload => 'Scarica';

  @override
  String get updatesDialogDownloadingTitle => 'Download aggiornamento';

  @override
  String get updatesDialogDownloadFailedTitle => 'Download non riuscito';

  @override
  String get updatesDialogPreparing => 'Preparazione download...';

  @override
  String get updatesDialogInstallTitle => 'Installa aggiornamento';

  @override
  String updatesDialogInstallPrompt(String version) {
    return 'Aggiornamento scaricato ($version). Installare ora? L\'app verrà chiusa durante l\'installazione.';
  }

  @override
  String get updatesDialogInstall => 'Installa';

  @override
  String get updatesDialogInstallFailed =>
      'Installazione non riuscita. Avvia l\'installer manualmente.';

  @override
  String get updatesInstallPermissionNeeded =>
      'Consenti \"Installa app sconosciute\" per Smart Inverter nelle impostazioni appena aperte, poi torna qui e tocca Installa.';

  @override
  String get updatesDialogDownloadFailed =>
      'Download non riuscito. Controlla la connessione o gli asset della release.';

  @override
  String get updatesDialogClose => 'Chiudi';

  @override
  String get inverterSettings => 'Impostazioni inverter';

  @override
  String get refreshSettings => 'Aggiorna impostazioni';

  @override
  String get settingsLoadingTitle => 'Caricamento impostazioni…';

  @override
  String get waitingInverterResponse => 'In attesa di risposta dall\'inverter…';

  @override
  String get tapRefreshToLoad => 'Tocca aggiorna per caricare le impostazioni';

  @override
  String get realtimeReadings => 'Letture in tempo reale';

  @override
  String unitOfMeasure(String unit) {
    return 'Unità: $unit';
  }

  @override
  String get selectValue => 'Seleziona valore';

  @override
  String get newValue => 'Nuovo valore';

  @override
  String get apply => 'Applica';

  @override
  String get debugLogs => 'Log di debug';

  @override
  String get viewSystemLogs => 'Visualizza log di sistema';

  @override
  String get analyzeSystemLogs => 'Analizza errori dell\'app e chiamate API';

  @override
  String get stationParameters => 'Parametri impianto';

  @override
  String get stationParametersHint =>
      'Questi valori aiutano l\'algoritmo intelligente a calcolare con più precisione il bilancio energetico e le previsioni meteo.';

  @override
  String get batteryCapacityLabel => 'Capacità batteria';

  @override
  String get inputBreakerLabel => 'Interruttore di ingresso';

  @override
  String get gridVoltageLabel => 'Tensione di rete';

  @override
  String get houseLoadReserveLabel => 'Carico di riserva casa';

  @override
  String get autoReserveLoadTitle => 'Carico di riserva automatico';

  @override
  String get autoReserveLoadEnabledSubtitle =>
      'La riserva si aggiorna automaticamente dal carico attuale e storico';

  @override
  String get autoReserveLoadDisabledSubtitle =>
      'La riserva è fissata manualmente';

  @override
  String get reserveModeAuto => 'Modalità: AUTO';

  @override
  String get reserveModeManual => 'Modalità: MANUALE';

  @override
  String get reserveModeAutoHint =>
      'AUTO: la riserva si aggiorna dal carico attuale e dal profilo orario con smussamento e margine di sicurezza.';

  @override
  String get reserveModeManualHint =>
      'MANUALE: la riserva resta fissa al valore impostato.';

  @override
  String get houseLoadReserveHint =>
      'Potenza di riserva per altri elettrodomestici, per evitare lo scatto dell\'interruttore durante la carica.';

  @override
  String get autoEstimateReserveLoad => 'Stima automatica carico di riserva';

  @override
  String get chargePowerEstimateTitle => 'Stima velocità di carica sicura';

  @override
  String get chargePowerSafeLimitLabel => 'Limite potenza di carica batteria';

  @override
  String get chargeCurrentSafeLimitLabel =>
      'Limite corrente di carica batteria';

  @override
  String get chargeCurrentConservativeLabel => 'Corrente di carica prudente';

  @override
  String get chargeInputCurrentEstimateLabel =>
      'Corrente di ingresso AC stimata';

  @override
  String get chargeBreakerRiskSafe => 'Rischio interruttore: basso';

  @override
  String get chargeBreakerRiskElevated => 'Rischio interruttore: elevato';

  @override
  String get chargeBreakerRiskHigh =>
      'Rischio interruttore: alto (scatto probabile)';

  @override
  String chargeBreakerRiskHint(String load) {
    return 'L\'analisi usa il carico casa riserva/attuale/profilo: $load W';
  }

  @override
  String get chargeTimeToFullLabel => 'Tempo al 100%';

  @override
  String get chargeTimeUnavailable => 'Dati insufficienti';

  @override
  String get chargeEstimateNoRealtimeSoc =>
      'SOC in tempo reale non disponibile. Il tempo di carica apparirà quando arriveranno i dati live.';

  @override
  String chargeEstimateBasedOnSoc(String soc) {
    return 'Stima basata sul SOC attuale: $soc%';
  }

  @override
  String get panelPowerLabel => 'Potenza pannelli';

  @override
  String get inverterPowerLabel => 'Potenza inverter';

  @override
  String get locationPreset => 'Località predefinita';

  @override
  String get latitudeLabel => 'Latitudine';

  @override
  String get longitudeLabel => 'Longitudine';

  @override
  String get timeZoneLabel => 'Fuso orario';

  @override
  String get astronomicalWindowsTitle =>
      'Finestre astronomiche (alba/tramonto)';

  @override
  String get astronomicalWindowsAutoSubtitle =>
      'Finestre automatiche dalle coordinate geografiche';

  @override
  String get astronomicalWindowsManualSubtitle => 'Usa limiti orari manuali';

  @override
  String get manualDayStartHour => 'Ora inizio giorno manuale';

  @override
  String get manualEveningStartHour => 'Ora inizio sera manuale';

  @override
  String get manualNightStartHour => 'Ora inizio notte manuale';

  @override
  String get geoPresetKyiv => 'Kyiv, UA';

  @override
  String get geoPresetLviv => 'Leopoli, UA';

  @override
  String get geoPresetOdesa => 'Odessa, UA';

  @override
  String get geoPresetDnipro => 'Dnipro, UA';

  @override
  String get geoPresetKharkiv => 'Charkiv, UA';

  @override
  String get geoPresetWarsaw => 'Varsavia, PL';

  @override
  String get geoPresetBerlin => 'Berlino, DE';

  @override
  String get geoPresetCustom => 'Personalizzata (manuale)';

  @override
  String geoSummary(String latitude, String longitude, String timeZone) {
    return 'Geo: $latitude, $longitude ($timeZone)';
  }

  @override
  String get windowsAstronomicalAuto => 'Finestre: astronomiche (auto)';

  @override
  String windowsManualSummary(String day, String evening, String night) {
    return 'Finestre: manuali $day:00 / $evening:00 / $night:00';
  }

  @override
  String get hardwareSettingsSaved => 'Impostazioni hardware salvate!';

  @override
  String hardwareSummary(String battery, String pv, String inverter) {
    return 'Batteria: $battery Ah • FV: $pv W\nInverter: $inverter W';
  }

  @override
  String chargeLimitSummary(String breaker, String power, String current) {
    return 'Ingresso C$breaker -> carica batteria sicura $power W (~$current A)';
  }

  @override
  String get clear => 'Cancella';

  @override
  String get presetDisabled => 'Disattivato';

  @override
  String get presetEnabled => 'Attivato';

  @override
  String get presetOutputUsb => 'USB - Priorità rete';

  @override
  String get presetOutputSub => 'SUB - Prima il solare';

  @override
  String get presetOutputSbu => 'SBU - Priorità solare/batteria';

  @override
  String get presetChargerCso => 'CSO - Prima il solare';

  @override
  String get presetChargerSnu => 'SNU - Solare + rete';

  @override
  String get presetChargerOso => 'OSO - Solo solare';

  @override
  String get presetChargerUtilityOnly => 'Solo rete';

  @override
  String get presetFrequency50Hz => '50 Hz';

  @override
  String get presetFrequency60Hz => '60 Hz';

  @override
  String get presetAcInputAplWide => 'APL - Intervallo ampio';

  @override
  String get presetAcInputUpsNarrow => 'UPS - Intervallo stretto';

  @override
  String get presetBatteryTypeAgm => 'AGM';

  @override
  String get presetBatteryTypeFlooded => 'Piombo liquido';

  @override
  String get presetBatteryTypeUser => 'Definita dall\'utente';

  @override
  String get presetBatteryTypeLib => 'LIB (Litio)';

  @override
  String get presetBatteryTypeLife => 'LiFe';

  @override
  String get signInCloud => 'Accedi a Siseli Cloud';

  @override
  String get loginFailed => 'Accesso non riuscito. Controlla le credenziali.';

  @override
  String get today => 'Oggi';

  @override
  String get forecastNextDays => 'Previsione solare per i prossimi giorni';

  @override
  String get forecastPeak => 'Picco';

  @override
  String get forecastUnavailable =>
      'Dati di previsione temporaneamente non disponibili';

  @override
  String get equipmentStatus => 'Stato apparecchiature';

  @override
  String get inverterLoad => 'Carico inverter';

  @override
  String get pvGeneration => 'Produzione FV';

  @override
  String get refreshChart => 'Aggiorna grafico';

  @override
  String get batterySignHint =>
      'Batteria: \'+\' significa carica, \'-\' significa scarica.';

  @override
  String get chartNoDataTitle => 'Ancora nessun dato';

  @override
  String get chartNoDataMessage => 'Il grafico si caricherà a breve.';

  @override
  String get lessThanMinute => '< 1 min';

  @override
  String minutesAgo(String count) {
    return '$count min fa';
  }

  @override
  String hoursAgo(String count) {
    return '$count h fa';
  }

  @override
  String get total => 'Totale';

  @override
  String get solar => 'Solare';

  @override
  String get load => 'Carico';

  @override
  String get connectionOnline => 'Online';

  @override
  String get connectionOffline => 'Offline';

  @override
  String get gridOutageDetectedShort => 'Blackout rete';

  @override
  String get gridOutageVisualTitle => 'Rete elettrica non disponibile';

  @override
  String gridOutageVisualBody(String voltage) {
    return 'Rilevato dalla tensione di ingresso ($voltage V), non dal cambio di modalità';
  }

  @override
  String backupRuntimeHybrid(String duration) {
    return 'Autonomia stimata (batteria + solare): ~$duration';
  }

  @override
  String backupRuntimeBatteryOnly(String duration) {
    return 'Solo batteria: ~$duration';
  }

  @override
  String get backupRuntimeSolarCoverHint =>
      'Il solare copre attualmente il carico, l\'autonomia reale può essere maggiore.';

  @override
  String get runtimeInfinite => 'continua';

  @override
  String get runtimeNow => 'ora';

  @override
  String runtimeMinutes(String minutes) {
    return '$minutes min';
  }

  @override
  String runtimeHoursOnly(String hours) {
    return '$hours h';
  }

  @override
  String runtimeHoursMinutes(String hours, String minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get lastRealtimeUpdate => 'Ultimo aggiornamento';

  @override
  String updatedAt(String time) {
    return 'Aggiornato alle $time';
  }

  @override
  String get updateFailed => 'Aggiornamento non riuscito';

  @override
  String get retry => 'Riprova';

  @override
  String get updated => 'Aggiornato!';

  @override
  String get enableSolar => 'Attiva SOLARE (SBU)';

  @override
  String get enableGrid => 'Attiva RETE (USB)';

  @override
  String get showApp => 'Mostra app';

  @override
  String get exit => 'Esci';

  @override
  String get tooltipTodayEnergy => 'Energia solare totale prodotta oggi';

  @override
  String get tooltipTotalEnergy =>
      'Energia solare totale prodotta dall\'installazione del dispositivo';

  @override
  String get tooltipCo2 =>
      'Riduzione stimata delle emissioni di CO₂ grazie alla produzione solare';

  @override
  String get tooltipInverterLoad =>
      'Carico attuale dell\'inverter rispetto alla potenza nominale';

  @override
  String get tooltipPvGeneration =>
      'Produzione FV attuale rispetto alla potenza totale dei pannelli installati';

  @override
  String batteryLevel(String level) {
    return 'Batteria: $level%';
  }

  @override
  String get batteryInstallYearLabel => 'Anno di installazione batteria';

  @override
  String get hemsStrategyLabel => 'Strategia di ottimizzazione HEMS';

  @override
  String get hemsStrategyEconomical =>
      'Economica (minimizza il costo della rete)';

  @override
  String get hemsStrategySolarMaxed =>
      'Solare massimo (massimizza l\'autoconsumo)';

  @override
  String get hemsStrategyBatteryLife => 'Vita batteria (cicli prudenti)';

  @override
  String get hemsStrategyGridReliance =>
      'Affidabilità rete (resilienza / off-grid)';

  @override
  String get hemsStrategyHybrid => 'Ibrida (bilanciata — consigliata)';

  @override
  String get moneySavedMonth => 'Risparmiato questo mese';

  @override
  String get paymentThisMonth => 'Da pagare questo mese';

  @override
  String get currencyUah => '€';

  @override
  String get energyTariffDayLabel => 'Tariffa diurna';

  @override
  String get energyTariffNightLabel => 'Tariffa notturna';

  @override
  String get energyTariffUnit => '€/kWh';

  @override
  String get nightEnergyShareLabel => 'Quota energia notturna';

  @override
  String get nightEnergyShareUnit => '%';

  @override
  String get autoEstimateNightShare => 'Stima automatica quota notturna';

  @override
  String get batteryRoundTripEfficiencyLabel =>
      'Efficienza round-trip batteria';

  @override
  String get batteryRoundTripEfficiencyHint =>
      'Usata per ridurre il risparmio dall\'energia spostata tramite batteria. Imposta 100% per disattivare la correzione delle perdite.';

  @override
  String get nightShareFallbackHint =>
      'Usata solo come ripiego quando l\'economia oraria da telemetria non è disponibile.';

  @override
  String economicsMethodTelemetry(String efficiency) {
    return 'Telemetria oraria • Efficienza batteria $efficiency%';
  }

  @override
  String economicsMethodEstimated(String share) {
    return 'Stima di ripiego • Quota notturna $share%';
  }

  @override
  String get calculationSourceLabel => 'Fonte del calcolo';

  @override
  String get calculationAccuracyLabel => 'Precisione';

  @override
  String get calculationSourceTelemetry => 'Telemetria oraria';

  @override
  String get calculationSourceFallback => 'Stima di ripiego';

  @override
  String get calculationAccuracyHigh => 'Alta';

  @override
  String get calculationAccuracyEstimated => 'Stimata';

  @override
  String effectiveTariffFormula(String day, String night, String share) {
    return 'Formula: $day*(1-$share%) + $night*$share%';
  }

  @override
  String tooltipMoneySavedMonthTelemetry(String efficiency) {
    return 'Calcolato dalla telemetria con tariffa oraria giorno/notte. L\'energia spostata tramite batteria è corretta con efficienza round-trip del $efficiency%.';
  }

  @override
  String tooltipMoneySavedMonthEstimated(String share, String efficiency) {
    return 'Stimato dal solare autoconsumato con quota notturna di ripiego $share% ed efficienza batteria $efficiency%.';
  }

  @override
  String tooltipPaymentThisMonthTelemetry(String dayStart, String nightStart) {
    return 'Calcolato dalla telemetria con fasce tariffarie orarie: giorno dalle $dayStart:00, notte dalle $nightStart:00.';
  }

  @override
  String tooltipPaymentThisMonthEstimated(String share) {
    return 'Bolletta mensile stimata con quota notturna di ripiego $share% per la ripartizione giorno/notte.';
  }

  @override
  String tooltipEffectiveTariffTelemetry(String dayStart, String nightStart) {
    return 'Solo tariffa media di riferimento. Pagamento e risparmio reali sopra sono calcolati ora per ora dalla telemetria con giorno dalle $dayStart:00 e notte dalle $nightStart:00.';
  }

  @override
  String get projectedSavedMonth => 'Risparmio previsto a fine mese';

  @override
  String get projectedPaymentMonth => 'Pagamento previsto a fine mese';

  @override
  String get tooltipProjectedSavedMonth =>
      'Previsione basata sull\'andamento del mese dell\'energia solare autoconsumata';

  @override
  String get tooltipProjectedPaymentMonth =>
      'Previsione basata sull\'andamento del mese dell\'energia prelevata dalla rete';

  @override
  String get monthlyEnergyBreakdown => 'Ripartizione energetica mensile';

  @override
  String get monthLoadEnergy => 'Consumo questo mese';

  @override
  String get monthGridImport => 'Prelievo dalla rete';

  @override
  String get monthSelfConsumed => 'Solare autoconsumato';

  @override
  String get monthGridCost => 'Costo rete questo mese';

  @override
  String get monthSavedCost => 'Risparmio questo mese';

  @override
  String get monthEffectiveTariff => 'Tariffa effettiva';

  @override
  String get tooltipMonthProgress => 'Avanzamento del mese corrente';

  @override
  String get plannedOutageTitle => 'Avviso blackout programmato';

  @override
  String get plannedOutageEnabledSubtitle =>
      'Precarica automatica prima del blackout';

  @override
  String get plannedOutageDisabledSubtitle =>
      'Nessun blackout programmato manualmente';

  @override
  String get plannedOutageStartLabel => 'Inizio blackout';

  @override
  String get plannedOutageEndLabel => 'Fine blackout';

  @override
  String get notificationsTitle => 'Notifiche';

  @override
  String get notificationsEmpty => 'Nessuna notifica';

  @override
  String get notificationsClear => 'Cancella tutto';

  @override
  String get notifGridOutageTitle => 'Blackout rete elettrica';

  @override
  String get notifGridOutageBody =>
      'Tensione di rete assente — funzionamento da solare/batteria';

  @override
  String get notifGridRestoredTitle => 'Rete elettrica ripristinata';

  @override
  String notifGridRestoredBody(String voltage) {
    return 'Tensione di rete tornata normale ($voltage V)';
  }

  @override
  String get notifLowBatteryTitle => 'Batteria scarica';

  @override
  String notifLowBatteryBody(String soc) {
    return 'SOC batteria al $soc% — vicino alla soglia di riserva';
  }

  @override
  String get notifBatteryRecoveredTitle => 'Batteria carica';

  @override
  String notifBatteryRecoveredBody(String soc) {
    return 'SOC batteria risalito al $soc%';
  }

  @override
  String get notifModeChangedTitle => 'Modalità HEMS cambiata';

  @override
  String notifModeChangedBody(String mode) {
    return 'Modalità attiva: $mode';
  }

  @override
  String get notifGridInstabilityTitle => 'Rete instabile';

  @override
  String get notifGridInstabilityBody =>
      'Rilevati frequenti cambi di stato della rete';

  @override
  String get notifAutoStormTitle => 'Modalità Tempesta automatica attivata';

  @override
  String get notifAutoStormBody =>
      'Blackout rilevato — passato alla modalità Tempesta per proteggere la batteria';

  @override
  String get notifForecastStormTitle => 'Modalità Tempesta — Allerta meteo';

  @override
  String notifForecastStormBody(String reason) {
    return 'Maltempo in arrivo: $reason — passato alla modalità Tempesta';
  }

  @override
  String get notifForecastStormRestoredTitle =>
      'Modalità adattiva ripristinata';

  @override
  String get notifForecastStormRestoredBody =>
      'Rischio meteo cessato — ripristinata la modalità HEMS normale';

  @override
  String get notifAutoAdaptiveTitle => 'Modalità adattiva ripristinata';

  @override
  String get notifAutoAdaptiveBody =>
      'La rete è tornata — ripristinata automaticamente la modalità adattiva';

  @override
  String get notifAnomalyTitle => 'Consumo elevato rilevato';

  @override
  String notifAnomalyBody(String load, String times) {
    return 'Carico di $load W — $times× sopra la norma per quest\'ora';
  }

  @override
  String get notifCycleTitle => 'Ciclo batteria completato';

  @override
  String notifCycleBody(String count, String soh) {
    return 'Cicli totali: $count. Salute batteria stimata: $soh%';
  }

  @override
  String get eventHistoryTitle => 'Cronologia eventi';

  @override
  String get eventHistoryEmpty => 'Nessun evento registrato';

  @override
  String get eventHistoryClear => 'Cancella cronologia';

  @override
  String get eventHistoryShowAll => 'Mostra tutto';

  @override
  String get exportCsv => 'Esporta CSV';

  @override
  String exportedTo(String path) {
    return 'Salvato in:\n$path';
  }

  @override
  String get exportFailed => 'Esportazione non riuscita';

  @override
  String get currentCostPerHour => 'Costo attuale';

  @override
  String get uahPerHour => '€/h';

  @override
  String get batteryCycles => 'Cicli';

  @override
  String get batteryHealth => 'Salute batteria';

  @override
  String battSohPercent(String soh) {
    return 'SOH $soh%';
  }

  @override
  String get autoStormByForecastTitle =>
      'Modalità Tempesta automatica da previsioni meteo';

  @override
  String get autoStormByForecastEnabledSubtitle =>
      'Passa alla modalità Tempesta quando è previsto maltempo (prossime 12 h)';

  @override
  String get autoStormByForecastDisabledSubtitle =>
      'Modalità Tempesta da previsioni disattivata';

  @override
  String get socHistoryTitle => 'SOC batteria — ultime 24 h';

  @override
  String get socHistorySubtitle => 'Andamento livello di carica';

  @override
  String get socHistoryNoData =>
      'Dati ancora insufficienti.\nI dati vengono raccolti ogni 5 minuti.';

  @override
  String get socHistoryReserveLabel => 'Riserva';

  @override
  String get socHistoryChargingLabel => 'In carica';

  @override
  String get socHistoryDischargingLabel => 'In scarica';

  @override
  String get socHistoryIdleLabel => 'Inattiva';

  @override
  String get scheduleRulesTitle => 'Regole programmate';

  @override
  String get scheduleRulesSubtitle =>
      'Forza una modalità HEMS in una fascia oraria ricorrente';

  @override
  String get scheduleRulesEmpty =>
      'Nessuna regola programmata.\nTocca + per aggiungere la prima.';

  @override
  String get scheduleRuleAdd => 'Aggiungi regola';

  @override
  String get scheduleRuleEdit => 'Modifica regola';

  @override
  String get scheduleRuleDelete => 'Elimina regola';

  @override
  String scheduleRuleDeleteConfirm(String name) {
    return 'Eliminare la regola \"$name\"?';
  }

  @override
  String get scheduleRuleName => 'Nome regola';

  @override
  String get scheduleRuleNameHint => 'Es. Solare mattutino, Carica weekend…';

  @override
  String get scheduleRuleDays => 'Giorni attivi';

  @override
  String get scheduleRuleStartTime => 'Ora di inizio';

  @override
  String get scheduleRuleEndTime => 'Ora di fine';

  @override
  String get scheduleRuleMode => 'Modalità HEMS forzata';

  @override
  String get scheduleRuleModeAdaptive => 'Adattiva (Auto)';

  @override
  String get scheduleRuleModeArbitrage => 'Arbitraggio notturno';

  @override
  String get scheduleRuleModeStorm => 'Tempesta / Riserva';

  @override
  String get scheduleRuleActive => 'Attiva ora';

  @override
  String get scheduleRuleNameEmpty => 'Inserisci un nome';

  @override
  String get scheduleRuleNoDays => 'Seleziona almeno un giorno';

  @override
  String get scheduleRulePriority => 'Priorità';

  @override
  String get scheduleRulePriorityHint =>
      'In caso di sovrapposizione vince la priorità più alta';

  @override
  String scheduleRuleConflict(int count) {
    return '$count regole sovrapposte ora — uso la priorità più alta';
  }
}
