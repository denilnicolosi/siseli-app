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
  String get forecast => 'Previsioni';

  @override
  String get account => 'Account';

  @override
  String get appSettings => 'Impostazioni applicazione';

  @override
  String get editProfile => 'Modifica profilo';

  @override
  String get cancel => 'Annulla';

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
  String get solar => 'Solare';

  @override
  String get load => 'Carico';

  @override
  String get connectionOnline => 'Online';

  @override
  String get connectionOffline => 'Offline';

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
  String batteryLevel(String level) {
    return 'Batteria: $level%';
  }

  @override
  String get batteryInstallYearLabel => 'Anno di installazione batteria';

  @override
  String get notificationsTitle => 'Notifiche';

  @override
  String get notificationsEmpty => 'Nessuna notifica';

  @override
  String get notificationsClear => 'Cancella tutto';

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
  String get socHistoryNoData =>
      'Dati ancora insufficienti.\nI dati vengono raccolti ogni 5 minuti.';

  @override
  String get acInput => 'Ingresso AC';

  @override
  String get mainSource => 'Sorgente principale';

  @override
  String get chartFullscreen => 'Schermo intero';

  @override
  String get chartRotate => 'Ruota';

  @override
  String forecastBasis(String kwp) {
    return 'Stima per $kwp kWp di pannelli dalla radiazione solare Open-Meteo';
  }

  @override
  String get applySafeCurrent => 'Applica corrente sicura';

  @override
  String safeCurrentApplied(String target, String read) {
    return 'Corrente sicura applicata: $target A (letta: $read)';
  }

  @override
  String safeCurrentFailed(String target, String read) {
    return 'Corrente sicura non confermata. Obiettivo $target A, letta: $read';
  }

  @override
  String get invSetOutputPriority => 'Priorità sorgente di uscita';

  @override
  String get invSetOutputPriorityDesc =>
      'Quale sorgente alimenta i carichi (programma 01). USB: prima l\'ingresso AC; solare e batteria solo se manca l\'ingresso AC. SUB: il solare carica prima la batteria, poi alimenta i carichi; l\'ingresso AC copre il resto. SBU: prima il solare, poi la batteria; l\'ingresso AC solo quando la batteria scende alla soglia di ritorno su AC (programma 12/43). Off-grid: usa SBU.';

  @override
  String get invSetChargerPriority => 'Priorità sorgente di carica';

  @override
  String get invSetChargerPriorityDesc =>
      'Quale sorgente carica la batteria (programma 16). CSO: prima il solare, l\'ingresso AC solo quando manca il sole. SNU: solare e ingresso AC insieme. OSO: solo solare, anche con ingresso AC presente. Senza generatore sull\'ingresso AC carica solo il solare.';

  @override
  String get invSetMaxChargeCurrent => 'Corrente di carica massima';

  @override
  String get invSetMaxChargeCurrentDesc =>
      'Corrente totale di carica della batteria, solare + ingresso AC (programma 02). Non può essere inferiore alla corrente di carica da AC (programma 11). Rispetta il limite del produttore della batteria.';

  @override
  String get invSetAcChargeCurrent => 'Corrente massima di carica da AC';

  @override
  String get invSetAcChargeCurrentDesc =>
      'Corrente massima per caricare la batteria dall\'ingresso AC, rete o generatore (programma 11). Tienila abbastanza bassa per il generatore e per l\'interruttore d\'ingresso.';

  @override
  String get invSetAcInputRange => 'Intervallo tensione ingresso AC';

  @override
  String get invSetAcInputRangeDesc =>
      'Tensione d\'ingresso AC accettata (programma 03). APL (elettrodomestici): 90-280 V, intervallo ampio. UPS: 170-280 V, intervallo stretto per carichi sensibili. L\'intervallo ampio tollera meglio un generatore con tensione instabile.';

  @override
  String get invSetBatteryType => 'Tipo di batteria';

  @override
  String get invSetBatteryTypeDesc =>
      'Chimica della batteria; determina le tensioni di carica (programma 05). AGM e Flooded: profili per piombo. Definito dall\'utente: imposti tu tensione di bulk, float e stacco (programmi 26, 27, 29). LIB/LiFe: litio.';

  @override
  String get invSetOverloadRestart => 'Riavvio automatico dopo sovraccarico';

  @override
  String get invSetOverloadRestartDesc =>
      'Se attivo, l\'uscita si riaccende da sola dopo uno spegnimento per sovraccarico (programma 06).';

  @override
  String get invSetOverTempRestart =>
      'Riavvio automatico dopo surriscaldamento';

  @override
  String get invSetOverTempRestartDesc =>
      'Se attivo, l\'uscita si riaccende da sola dopo uno spegnimento per temperatura eccessiva (programma 07).';

  @override
  String get invSetOutputVoltage => 'Tensione di uscita';

  @override
  String get invSetOutputVoltageDesc =>
      'Tensione AC fornita ai carichi (programma 08). In Italia: 230 V.';

  @override
  String get invSetOutputFrequency => 'Frequenza di uscita';

  @override
  String get invSetOutputFrequencyDesc =>
      'Frequenza AC fornita ai carichi (programma 09). In Europa: 50 Hz.';

  @override
  String get invSetOverloadBypass => 'Bypass in sovraccarico';

  @override
  String get invSetOverloadBypassDesc =>
      'Se attivo, in caso di sovraccarico in modalità batteria l\'inverter passa i carichi sull\'ingresso AC (programma 23). Serve solo con un generatore collegato.';

  @override
  String get invSetBuzzer => 'Allarme acustico (buzzer)';

  @override
  String get invSetBuzzerDesc =>
      'Attiva o disattiva il cicalino dell\'inverter per avvisi e guasti (programma 18).';

  @override
  String get invSetSourceLossBeep => 'Bip alla perdita della sorgente primaria';

  @override
  String get invSetSourceLossBeepDesc =>
      'Se attivo, l\'inverter emette un bip quando si interrompe la sorgente primaria scelta nel programma 01 (programma 22).';

  @override
  String get invSetReturnToDefaultScreen => 'Ritorno alla schermata principale';

  @override
  String get invSetReturnToDefaultScreenDesc =>
      'Se attivo, il display torna alla schermata principale circa 1 minuto dopo l\'ultimo tasto premuto; altrimenti resta sull\'ultima schermata (programma 19).';

  @override
  String get invSetBacklight => 'Retroilluminazione display';

  @override
  String get invSetBacklightDesc =>
      'Tiene sempre accesa la retroilluminazione del display, oppure la lascia spegnere quando è inattivo (programma 20).';

  @override
  String get invSetRecordFaults => 'Registra codici di guasto';

  @override
  String get invSetRecordFaultsDesc =>
      'Se attivo, l\'inverter salva i codici di guasto nella sua memoria (programma 25).';

  @override
  String get invSetEqualization => 'Equalizzazione batteria';

  @override
  String get invSetEqualizationDesc =>
      'Sovraccarica periodica controllata che bilancia le celle delle batterie al piombo (programma 33). Solo per batterie Flooded o definite dall\'utente; tienila spenta con il litio.';

  @override
  String get invSetEqualizationNow => 'Avvia equalizzazione ora';

  @override
  String get invSetEqualizationNowDesc =>
      'Avvia subito un ciclo di equalizzazione (programma 39). Funziona solo se l\'equalizzazione (programma 33) è attiva.';

  @override
  String get invSetBatteryPowerLimit => 'Limitazione potenza batteria';

  @override
  String get invSetBatteryPowerLimitDesc =>
      'Limita la potenza prelevata dalla batteria. Non descritta nel manuale Easun: verifica la documentazione dell\'inverter prima di modificarla.';

  @override
  String get invSetSmartLoadCutOff =>
      'Stacco carico smart su tensione batteria';

  @override
  String get invSetSmartLoadCutOffDesc =>
      'Stacca l\'uscita per il carico smart (secondario) in base alla tensione della batteria. Non descritta nel manuale Easun: verifica la documentazione dell\'inverter prima di modificarla.';

  @override
  String get invSetRgbLight => 'Luce RGB';

  @override
  String get invSetRgbLightDesc =>
      'Accende o spegne la luce di stato RGB dell\'inverter.';

  @override
  String get rdDualOutputVoltageSwitch => 'Uscita doppia';

  @override
  String get rdDualOutputVoltageSwitchDesc =>
      'Seconda uscita AC per carichi non essenziali; si spegne quando la batteria scende alla tensione di spegnimento.';

  @override
  String get rdAcInputFrequency => 'Frequenza ingresso AC';

  @override
  String get rdAcInputFrequencyDesc =>
      'Frequenza sull\'ingresso AC (rete o generatore). 0 Hz significa che non è collegato nulla.';

  @override
  String get rdLedPatternLight1 => 'Luci LED';

  @override
  String get rdLedPatternLight1Desc =>
      'Stato delle luci LED di stato dell\'inverter.';

  @override
  String get rdBatteryNumber => 'Tensione sistema batteria';

  @override
  String get rdBatteryNumberDesc =>
      'Classe di tensione del banco batterie per cui è costruito l\'inverter.';

  @override
  String get rdAcInputVoltage => 'Tensione ingresso AC';

  @override
  String get rdAcInputVoltageDesc =>
      'Tensione sull\'ingresso AC. 0 V significa nessuna rete o generatore collegato.';

  @override
  String get rdWorkingStates => 'Stato di funzionamento';

  @override
  String get rdWorkingStatesDesc =>
      'Modalità attuale: Inverter (carichi da batteria/solare), Linea (carichi dall\'ingresso AC), Standby o Guasto.';

  @override
  String get rdAcOutputActivePower => 'Potenza attiva in uscita';

  @override
  String get rdAcOutputActivePowerDesc =>
      'Potenza reale assorbita ora dai carichi.';

  @override
  String get rdBatteryEqualizationMode => 'Equalizzazione batteria';

  @override
  String get rdBatteryEqualizationModeDesc =>
      'Se l\'equalizzazione periodica è attiva (programma 33). Solo batterie al piombo.';

  @override
  String get rdGridConnectedSwitch1 => 'Immissione in rete';

  @override
  String get rdGridConnectedSwitch1Desc =>
      'Se l\'inverter può immettere energia in rete. Off-grid: tienila spenta.';

  @override
  String get rdGenerationPower => 'Potenza generata';

  @override
  String get rdGenerationPowerDesc =>
      'Potenza prodotta ora dai pannelli solari.';

  @override
  String get rdRatingOutputCurrent => 'Corrente nominale di uscita';

  @override
  String get rdRatingOutputCurrentDesc =>
      'Corrente AC di uscita continua massima dell\'inverter (dato di targa).';

  @override
  String get rdLowBatteryCutOffVoltage => 'Tensione di stacco batteria scarica';

  @override
  String get rdLowBatteryCutOffVoltageDesc =>
      'Sotto questa tensione l\'inverter spegne l\'uscita per proteggere la batteria (programma 29).';

  @override
  String get rdBatteryCapacity => 'Carica batteria (SOC)';

  @override
  String get rdBatteryCapacityDesc =>
      'Stato di carica riportato dall\'inverter.';

  @override
  String get rdStartBalancing => 'Avvia equalizzazione ora';

  @override
  String get rdStartBalancingDesc =>
      'Se è richiesto un ciclo di equalizzazione immediato (programma 39).';

  @override
  String get rdBatteryDischargeCurrent => 'Corrente di scarica batteria';

  @override
  String get rdBatteryDischargeCurrentDesc =>
      'Corrente che esce ora dalla batteria.';

  @override
  String get rdGridConnectedCurrent => 'Corrente di immissione in rete';

  @override
  String get rdGridConnectedCurrentDesc =>
      'Corrente massima immessa in rete quando l\'immissione è attiva. Non usata off-grid.';

  @override
  String get rdRatedBatteryVoltage => 'Tensione nominale batteria';

  @override
  String get rdRatedBatteryVoltageDesc =>
      'Tensione nominale del banco batterie.';

  @override
  String get rdOutputApparentPower => 'Potenza apparente in uscita';

  @override
  String get rdOutputApparentPowerDesc =>
      'Potenza apparente (VA) assorbita dai carichi, compresa la parte reattiva: è quella che l\'inverter deve erogare.';

  @override
  String get rdDualOutputTurnOffVoltage =>
      'Tensione di spegnimento uscita doppia';

  @override
  String get rdDualOutputTurnOffVoltageDesc =>
      'Tensione della batteria alla quale si spegne la seconda uscita.';

  @override
  String get rdMainCPUVersion1 => 'Firmware CPU principale';

  @override
  String get rdMainCPUVersion1Desc =>
      'Versione firmware del processore principale dell\'inverter.';

  @override
  String get rdChargerSourcePriority => 'Priorità sorgente di carica';

  @override
  String get rdChargerSourcePriorityDesc =>
      'Priorità di carica attuale (programma 16). CSO: prima il solare. SNU: solare + ingresso AC. OSO: solo solare.';

  @override
  String get rdComebackUtilityModeVolSBUPriorityStatus =>
      'Tensione di ritorno su AC (SBU)';

  @override
  String get rdComebackUtilityModeVolSBUPriorityStatusDesc =>
      'Con SBU o solare prima, sotto questa tensione della batteria i carichi passano sull\'ingresso AC (programma 12). Senza generatore non ha effetto.';

  @override
  String get rdNominalAcVoltage => 'Tensione AC nominale';

  @override
  String get rdNominalAcVoltageDesc => 'Tensione AC nominale dell\'inverter.';

  @override
  String get rdNominalAcCurrent => 'Corrente AC nominale';

  @override
  String get rdNominalAcCurrentDesc => 'Corrente AC nominale dell\'inverter.';

  @override
  String get rdOutputRelayStatus => 'Relè di uscita';

  @override
  String get rdOutputRelayStatusDesc =>
      'ON significa che l\'uscita AC è alimentata.';

  @override
  String get rdPhotovoltaicAccessFlag => 'Collegamento fotovoltaico';

  @override
  String get rdPhotovoltaicAccessFlagDesc =>
      'Se l\'inverter rileva i pannelli solari.';

  @override
  String get rdPvStatuss => 'Stato fotovoltaico';

  @override
  String get rdPvStatussDesc =>
      'Stato di funzionamento dell\'ingresso solare (regolatore MPPT).';

  @override
  String get rdRatedOutputFrequency => 'Frequenza nominale di uscita';

  @override
  String get rdRatedOutputFrequencyDesc =>
      'Frequenza di uscita impostata sull\'inverter (programma 09).';

  @override
  String get rdRatedOutputVoltage => 'Tensione nominale di uscita';

  @override
  String get rdRatedOutputVoltageDesc =>
      'Tensione di uscita impostata sull\'inverter (programma 08).';

  @override
  String get rdGridState => 'Stato ingresso AC';

  @override
  String get rdGridStateDesc =>
      'Se l\'ingresso AC (rete o generatore) è collegato.';

  @override
  String get rdBatteryEqualizationInterval => 'Intervallo di equalizzazione';

  @override
  String get rdBatteryEqualizationIntervalDesc =>
      'Giorni tra due cicli di equalizzazione (programma 37).';

  @override
  String get rdLoadPercentage => 'Percentuale di carico';

  @override
  String get rdLoadPercentageDesc =>
      'Carico in uscita in percentuale della potenza nominale dell\'inverter.';

  @override
  String get rdComebackBatteryModeVolSBUPriorityStatus =>
      'Tensione di ritorno a batteria (SBU)';

  @override
  String get rdComebackBatteryModeVolSBUPriorityStatusDesc =>
      'Con SBU o solare prima, sopra questa tensione della batteria i carichi tornano sulla batteria (programma 13).';

  @override
  String get rdPvInputPower => 'Potenza ingresso fotovoltaico';

  @override
  String get rdPvInputPowerDesc =>
      'Potenza che entra dai pannelli solari nel regolatore MPPT.';

  @override
  String get rdMaxTotalChargeCurrent1 => 'Corrente di carica totale massima';

  @override
  String get rdMaxTotalChargeCurrent1Desc =>
      'Limite di carica totale, solare + ingresso AC (programma 02).';

  @override
  String get rdBatState => 'Stato batteria';

  @override
  String get rdBatStateDesc =>
      'Se la batteria è in carica, in scarica o ferma.';

  @override
  String get rdOutputSourcePriority => 'Priorità sorgente di uscita';

  @override
  String get rdOutputSourcePriorityDesc =>
      'Priorità di uscita attuale (programma 01). USB: prima l\'ingresso AC. SUB: il solare carica prima, l\'AC copre il resto. SBU: solare, poi batteria, poi AC.';

  @override
  String get rdFloatChargingVoltage => 'Tensione di mantenimento (float)';

  @override
  String get rdFloatChargingVoltageDesc =>
      'Tensione mantenuta quando la batteria è piena (programma 27).';

  @override
  String get rdBatteryChargingCurrent => 'Corrente di carica batteria';

  @override
  String get rdBatteryChargingCurrentDesc =>
      'Corrente che entra ora nella batteria.';

  @override
  String get rdAcOutputRatingApparentPower => 'Potenza apparente nominale';

  @override
  String get rdAcOutputRatingApparentPowerDesc =>
      'Potenza nominale di uscita dell\'inverter in VA.';

  @override
  String get rdLoadStatus => 'Stato del carico';

  @override
  String get rdLoadStatusDesc =>
      'Se il carico in uscita è normale o in sovraccarico.';

  @override
  String get rdBatteryEqualizationVoltage => 'Tensione di equalizzazione';

  @override
  String get rdBatteryEqualizationVoltageDesc =>
      'Tensione di carica usata durante l\'equalizzazione (programma 34).';

  @override
  String get rdBatteryVoltage => 'Tensione batteria';

  @override
  String get rdBatteryVoltageDesc => 'Tensione della batteria misurata ora.';

  @override
  String get rdOutputVoltage => 'Tensione di uscita';

  @override
  String get rdOutputVoltageDesc => 'Tensione AC in uscita adesso.';

  @override
  String get rdBulkChargingVoltage => 'Tensione di carica (bulk)';

  @override
  String get rdBulkChargingVoltageDesc =>
      'Tensione obiettivo della carica a tensione costante (programma 26).';

  @override
  String get rdBatteryEqualizationTimeout => 'Timeout equalizzazione';

  @override
  String get rdBatteryEqualizationTimeoutDesc =>
      'Tempo massimo aggiuntivo concesso a un ciclo di equalizzazione (programma 36).';

  @override
  String get rdFeedInPower => 'Potenza immessa in rete';

  @override
  String get rdFeedInPowerDesc =>
      'Potenza immessa in rete. Off-grid resta a 0.';

  @override
  String get rdNtcMaximumTemperature => 'Temperatura interna massima';

  @override
  String get rdNtcMaximumTemperatureDesc =>
      'Temperatura più alta misurata dai sensori interni dell\'inverter (NTC).';

  @override
  String get rdMainsRelayStatus => 'Relè ingresso AC';

  @override
  String get rdMainsRelayStatusDesc =>
      'ON significa che carichi o caricatore sono collegati all\'ingresso AC.';

  @override
  String get rdBatteryRatingVoltage => 'Tensione nominale';

  @override
  String get rdBatteryRatingVoltageDesc =>
      'Tensione nominale riportata dall\'inverter.';

  @override
  String get rdRatedActivePower => 'Potenza attiva nominale';

  @override
  String get rdRatedActivePowerDesc =>
      'Potenza di uscita continua nominale dell\'inverter in W.';

  @override
  String get rdPvInputVoltage => 'Tensione ingresso fotovoltaico';

  @override
  String get rdPvInputVoltageDesc =>
      'Tensione della stringa solare; deve restare nell\'intervallo di tensione dell\'MPPT.';

  @override
  String get rdMainsInputRange => 'Intervallo ingresso AC';

  @override
  String get rdMainsInputRangeDesc =>
      'Intervallo di tensione AC accettato (programma 03). APL: 90-280 V. UPS: 170-280 V.';

  @override
  String get rdOutputFrequency => 'Frequenza di uscita';

  @override
  String get rdOutputFrequencyDesc => 'Frequenza AC misurata in uscita.';

  @override
  String get rdBatteryEqualizationTime => 'Durata equalizzazione';

  @override
  String get rdBatteryEqualizationTimeDesc =>
      'Durata di un ciclo di equalizzazione (programma 35).';

  @override
  String get rdBatteryType => 'Tipo di batteria';

  @override
  String get rdBatteryTypeDesc =>
      'Tipo di batteria impostato sull\'inverter (programma 05).';

  @override
  String get rdMaxUtilityChargeCurrent1 => 'Corrente di carica da AC';

  @override
  String get rdMaxUtilityChargeCurrent1Desc =>
      'Corrente massima di carica dall\'ingresso AC (programma 11).';

  @override
  String get rdValOn => 'Acceso';

  @override
  String get rdValOff => 'Spento';

  @override
  String get rdValEnabled => 'Attivo';

  @override
  String get rdValDisabled => 'Disattivo';

  @override
  String get rdValCharging => 'In carica';

  @override
  String get rdValDischarging => 'In scarica';

  @override
  String get rdValInvertMode => 'Modalità inverter';

  @override
  String get rdValLineMode => 'Modalità linea (da AC)';

  @override
  String get rdValStandbyMode => 'Standby';

  @override
  String get rdValFaultMode => 'Guasto';

  @override
  String get rdValAcNotConnected => 'Ingresso AC non collegato';

  @override
  String get rdValAcConnected => 'Ingresso AC collegato';

  @override
  String get rdValNormal => 'Normale';

  @override
  String get rdValPvWorking => 'Collegato e in funzione';

  @override
  String get rdValPvConnected => 'Pannelli collegati';

  @override
  String get invSetBackToAcVoltage => 'Tensione di ritorno su AC (SBU)';

  @override
  String get invSetBackToAcVoltageDesc =>
      'Con SBU o solare prima nel programma 01, sotto questa tensione della batteria i carichi passano sull\'ingresso AC (programma 12). Deve essere più bassa della tensione di ritorno a batteria. Senza generatore non ha effetto.';

  @override
  String get invSetBackToBatteryVoltage =>
      'Tensione di ritorno a batteria (SBU)';

  @override
  String get invSetBackToBatteryVoltageDesc =>
      'Con SBU o solare prima, quando la batteria risale sopra questa tensione i carichi tornano sulla batteria (programma 13). Deve essere più alta della tensione di ritorno su AC.';

  @override
  String get invSetBulkVoltage => 'Tensione di carica bulk (C.V.)';

  @override
  String get invSetBulkVoltageDesc =>
      'Tensione della fase di carica a tensione costante (programma 26). Modificabile solo con batteria definita dall\'utente; deve essere almeno pari alla tensione float. Segui i valori del produttore della batteria.';

  @override
  String get invSetFloatVoltage => 'Tensione di mantenimento (float)';

  @override
  String get invSetFloatVoltageDesc =>
      'Tensione mantenuta quando la batteria è piena (programma 27). Modificabile solo con batteria definita dall\'utente; non può superare la tensione bulk.';

  @override
  String get invSetLowCutOffVoltage => 'Tensione di stacco batteria scarica';

  @override
  String get invSetLowCutOffVoltageDesc =>
      'Sotto questa tensione della batteria l\'inverter spegne l\'uscita per proteggerla (programma 29). Deve essere più bassa della tensione di ritorno su AC.';

  @override
  String get invSetLowCutOffSoc => 'SOC di stacco batteria scarica';

  @override
  String get invSetLowCutOffSocDesc =>
      'Con batteria al litio in comunicazione con l\'inverter: sotto questo stato di carica l\'uscita si spegne (programma 45, predefinito 20%, intervallo 3-30%).';

  @override
  String get invSetEqVoltage => 'Tensione di equalizzazione';

  @override
  String get invSetEqVoltageDesc =>
      'Tensione di carica usata durante l\'equalizzazione (programma 34). Solo piombo.';

  @override
  String get invSetEqTime => 'Durata equalizzazione';

  @override
  String get invSetEqTimeDesc =>
      'Per quanto tempo viene mantenuta la tensione di equalizzazione (programma 35, 0-900 min).';

  @override
  String get invSetEqTimeout => 'Timeout equalizzazione';

  @override
  String get invSetEqTimeoutDesc =>
      'Tempo aggiuntivo concesso se la tensione di equalizzazione non viene raggiunta (programma 36, 0-900 min).';

  @override
  String get invSetEqInterval => 'Intervallo di equalizzazione';

  @override
  String get invSetEqIntervalDesc =>
      'Giorni tra due cicli di equalizzazione (programma 37, 1-90 giorni).';

  @override
  String get invSetOutputDelay => 'Ritardo uscita';

  @override
  String get invSetOutputDelayDesc =>
      'Ritardo prima che l\'uscita AC si accenda. Non descritto nel manuale Easun: verifica la documentazione dell\'inverter prima di modificarlo.';

  @override
  String get socDayChartTitle => 'Carica batteria (SOC) nella giornata';

  @override
  String get flowLosses => 'Perdite';

  @override
  String get flowLossesHint =>
      'Potenza in ingresso (sole, ingresso AC, batteria) che non arriva ai carichi né alla batteria: consumo proprio dell\'inverter e perdite di conversione.';

  @override
  String get flowMismatch => 'Scarto misure';

  @override
  String get flowMismatchHint =>
      'Esce più potenza di quella che le letture mostrano in ingresso: i valori sono stati letti in istanti leggermente diversi.';
}
