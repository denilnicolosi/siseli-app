# Smart Inverter ⚡

[![Version](https://img.shields.io/badge/version-3.0.0-blue.svg)](https://github.com/denilnicolosi/siseli-app/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat&logo=Flutter&logoColor=white)](https://flutter.dev)

**Windows 10/11 (x64) · Android** — monitoraggio e controllo di inverter solari collegati a `solar.siseli.com`.

[Italiano](#italiano) · [English](#english)

---

## Italiano

### Panoramica

Smart Inverter è una fork personalizzata di [yuraantonov11/siseli-app](https://github.com/yuraantonov11/siseli-app) (precedentemente `smart_inverter`), adattata al mio impianto off-grid: 3 kWp di pannelli fotovoltaici, inverter Easun iSolar SMH III da 6,2 kW e generatore opzionale sull'ingresso AC. Rispetto al progetto originale la dashboard è più compatta, le impostazioni dell'inverter sono descritte in italiano e le funzioni di automazione, tariffe e rilevamento blackout sono state rimosse.

L'app è compatibile con tutti gli inverter che utilizzano il dongle Wi-Fi **Ecomax**, denominato **Solar Plug-RWB1**, e che sono associati a un account `solar.siseli.com`.

Utilizza **API non ufficiali** di `solar.siseli.com`; non è affiliata a Siseli, Easun, Solar of Things o Sun House. È pensata come **alternativa** ad app come Solar of Things, Sun House e simili.

L'app non modifica mai le impostazioni dell'inverter in autonomia: ogni comando viene inviato solo dopo un'azione manuale dell'utente.

### Funzionalità

- **Dashboard in tempo reale** — fotovoltaico, batteria, carico e ingresso AC/generatore, con diagramma animato dei flussi di energia, indicazione delle perdite e stato online/offline. Aggiornamento manuale con pulsante, trascinamento verso il basso o `Ctrl+R`.
- **Cronologia energia** — grafici giorno/settimana/mese con navigazione tra i periodi; produzione, consumo, batteria e ingresso AC; sovrapposizione della previsione; grafico del SOC giornaliero quando è selezionata solo la batteria; modalità schermo intero (nativa su desktop, landscape su mobile).
- **Previsione solare** — radiazione solare da Open-Meteo, dimensionata sulla potenza dei pannelli e sulle coordinate del sito; previsione oraria e giornaliera, calibrata sui dati PV storici degli ultimi 14 giorni (i campioni con SOC ≥ 95% vengono esclusi perché l'MPPT limita la produzione a batteria piena).
- **Letture e impostazioni inverter** — tutte le letture in tempo reale con descrizione; impostazioni con nomi e spiegazioni basati sul manuale Easun iSolar (numeri di programma LCD); valori mostrati come etichette leggibili; modifica manuale con conferma e nuovo tentativo in caso di errore; aggiornamento delle configurazioni.
- **Batteria e notifiche** — SOC, correzione del SOC basata sulla tensione per LiFePO4 16S, avviso di batteria scarica sotto il 25%, notifica di recupero, tracciamento dei cicli con notifica a ciclo completato e stato di salute (SOH) stimato dall'anno di installazione, rilevamento di consumi anomali rispetto alla media oraria. Centro notifiche in-app e, su desktop, toast di sistema.
- **Parametri impianto e stima di ricarica** — capacità batteria e anno di installazione, potenza PV, potenza inverter, corrente dell'interruttore di ingresso (breaker AC), tensione di rete, riserva di carico casa (manuale o automatica), stima di potenza/corrente di ricarica sicura, rischio interruttore, tempo stimato al 100%, coordinate e fuso orario con preset o inserimento manuale, applicazione manuale della corrente sicura.
- **Integrazione desktop** — icona nel system tray con percentuale batteria e menu per mostrare l'app, uscire e selezionare manualmente SBU/USB; avvio con Windows; avvio minimizzato nel tray; chiusura della finestra nel tray.
- **Account e interfaccia** — login all'account Siseli, credenziali salvate nell'archivio sicuro del sistema e auto-login, profilo locale/cloud, interfaccia in italiano, inglese e ucraino con italiano predefinito, tema chiaro/scuro Material 3, layout responsive con rail laterale o barra inferiore, campanella notifiche.
- **Aggiornamenti** — controllo delle GitHub Releases, download e avvio dell'installer Windows (`.exe`, `.msi`, `.msix`) o dell'APK Android, possibilità di saltare una versione e ripristinarla, note di rilascio.
- **Continuità e diagnostica** — ultimo snapshot valido mostrato quando l'inverter è offline; modalità sviluppatore (7 clic sulla versione) con schermata dei log di debug, visualizzazione e cancellazione dei file di log.
- **Piattaforme** — Windows 10/11 x64 (installer EXE, MSIX, portable ZIP) e Android (APK/AAB).

### Requisiti

- Windows 10/11 x64 oppure Android.
- Un account `solar.siseli.com` con almeno una stazione/inverter visibile.
- Un inverter collegato a un dongle Wi-Fi Ecomax (Solar Plug-RWB1) e online.
- Connessione internet.
- Per la previsione: coordinate del sito e potenza dei pannelli configurate nei parametri impianto.

### Installazione

Scarica l'ultima versione dalla pagina [Releases](https://github.com/denilnicolosi/siseli-app/releases).

- **Windows** — installer `.exe`, pacchetto `.msix` o archivio portable `.zip`; Windows 10/11 x64.
- **Android** — APK (installabile) o bundle AAB; per gli aggiornamenti APK potrebbe essere necessario consentire l'installazione da app sconosciute.

### Primo avvio e configurazione

1. Accedi con l'account `solar.siseli.com`. Dopo il login le credenziali vengono salvate in modo sicuro per l'auto-login.
2. Verifica che la stazione e l'inverter siano online nel tuo account Siseli.
3. Vai in **Impostazioni → Parametri impianto** e inserisci capacità batteria (Ah), anno di installazione, potenza PV (W), potenza inverter (W), corrente dell'interruttore di ingresso, tensione di rete, riserva di carico casa, coordinate e fuso orario.
4. Apri la scheda **Dati** per leggere le letture in tempo reale e le impostazioni dell'inverter. Ogni modifica viene applicata solo dopo la conferma.
5. Su Windows puoi abilitare **Avvia con Windows** e **Avvia nella tray**; il menu del tray permette anche di passare manualmente tra SBU e USB.

### Sicurezza e privacy

- La password viene salvata tramite `flutter_secure_storage` (DPAPI su Windows), non in chiaro nelle preferenze.
- Il token di accesso non viene persistito; viene usato solo in memoria durante la sessione.
- Le richieste alle API Siseli sono firmate con `appId`, `nonce` e MD5.
- I log oscurano password, token e altri dati sensibili.
- Le credenziali vengono inviate solo a `solar.siseli.com`; l'app contatta anche Open-Meteo per la previsione e GitHub per gli aggiornamenti.
- L'app non è affiliata a Siseli; le API possono cambiare senza preavviso.

### Note e limiti

- Le descrizioni delle impostazioni seguono il manuale Easun iSolar; su altri inverter nomi e parametri possono differire.
- La correzione del SOC basata sulla tensione è tarata su pacchi LiFePO4 16S.
- L'app seleziona il primo dispositivo restituito dall'account; non è previsto un selettore multi-impianto.
- Le API non ufficiali possono cambiare senza preavviso e interrompere il funzionamento.

### Sviluppo

Stack: Flutter/Dart, Provider, Dio, `fl_chart`, `window_manager`, `system_tray`, `launch_at_startup`, `flutter_secure_storage`, `shared_preferences`, `local_notifier`.

```powershell
flutter pub get
flutter test
flutter run -d windows
flutter build windows --release
flutter build apk --release
```

Documentazione:

- [Processo di rilascio](docs/RELEASE_PROCESS.md)
- [Log di debug](docs/DEBUG_LOGGING.md)
- [Licenze dei font](docs/FONTS_LICENSES.md)
- [Changelog](CHANGELOG.md)
- [Contributing](CONTRIBUTING.md)
- [Repository fork](https://github.com/denilnicolosi/siseli-app)
- [Progetto originale](https://github.com/yuraantonov11/siseli-app)
- [Issues](https://github.com/denilnicolosi/siseli-app/issues)

### Licenza e disclaimer

Distribuita con licenza **MIT**. Vedi [LICENSE](LICENSE). Il progetto originale è di yuraantonov11 e contributori; questa fork mantiene la stessa licenza.

**Disclaimer:** applicazione non ufficiale, non affiliata a Siseli, Easun, Solar of Things, Sun House o ai rispettivi titolari. Usa API non documentate e può smettere di funzionare se cambiano. I dati e i comandi riguardano hardware reale: verifica sempre le impostazioni prima di applicarle. Uso a proprio rischio, senza garanzie.

---

## English

### Overview

Smart Inverter is a customized fork of [yuraantonov11/siseli-app](https://github.com/yuraantonov11/siseli-app) (formerly `smart_inverter`), tailored to my off-grid setup: 3 kWp PV, an Easun iSolar SMH III 6.2 kW inverter and an optional generator on the AC input. Compared with upstream, the dashboard is more compact, inverter settings are described in Italian, and the automation, tariff and blackout-detection features have been removed.

It works with any inverter using the **Ecomax** Wi-Fi dongle, named **Solar Plug-RWB1**, linked to a `solar.siseli.com` account.

It uses **unofficial** `solar.siseli.com` APIs. It is not affiliated with Siseli, Easun, Solar of Things or Sun House; those names belong to their respective owners. It is intended as an **alternative** to apps such as Solar of Things, Sun House and similar.

The app never changes inverter settings on its own: every command is sent only after a manual action by the user.

### Features

- **Real-time dashboard** — PV, battery, load and AC input/generator, with an animated energy-flow diagram, losses and online/offline status. Manual refresh via button, pull-to-refresh or `Ctrl+R`.
- **Energy history** — day/week/month charts with period navigation; production, consumption, battery and AC input; forecast overlay; daily SOC chart when only the battery series is selected; full-screen mode (native on desktop, landscape on mobile).
- **Solar forecast** — Open-Meteo solar radiation, sized on panel power and site coordinates; hourly and daily forecast, calibrated on the last 14 days of PV history (samples at SOC ≥ 95% are skipped because the MPPT curtails PV when the battery is full).
- **Inverter readings and settings** — all real-time readings with an explanation; settings with names and descriptions based on the Easun iSolar manual (LCD program numbers); readable option labels; manual changes with confirmation and retry; configuration refresh.
- **Battery and notifications** — SOC, voltage-based SOC correction for 16S LiFePO4, low-battery warning below 25%, recovery notification, cycle tracking with a cycle-completed notification and state of health (SOH) estimated from the installation year, detection of consumption anomalies against the hourly average. In-app notification center and, on desktop, OS toasts.
- **Plant parameters and charge estimate** — battery capacity and installation year, PV power, inverter power, AC breaker current, grid voltage, house load reserve (manual or automatic), safe charge power/current estimate, breaker risk, estimated time to 100%, coordinates and time zone with presets or manual entry, manual application of the safe current.
- **Desktop integration** — system tray icon with battery percentage and a menu to show the app, exit and manually select SBU/USB; start with Windows; start minimized in the tray; close the window to the tray.
- **Account and UI** — Siseli account login, credentials stored in the OS secure vault and auto-login, local/cloud profile, UI in Italian, English and Ukrainian with Italian as the default, Material 3 light/dark theme, responsive layout with a navigation rail or bottom bar, notification bell.
- **Updates** — GitHub Releases check, download and launch of the Windows installer (`.exe`, `.msi`, `.msix`) or Android APK, skip/restore a version, release notes.
- **Continuity and diagnostics** — last valid snapshot shown when the inverter is offline; developer mode (7 taps on the version) with a debug log screen to view and clear log files.
- **Platforms** — Windows 10/11 x64 (EXE installer, MSIX, portable ZIP) and Android (APK/AAB).

### Requirements

- Windows 10/11 x64 or Android.
- A `solar.siseli.com` account with at least one visible station/inverter.
- An inverter connected to an Ecomax Wi-Fi dongle (Solar Plug-RWB1) and online.
- Internet connection.
- For the forecast: site coordinates and panel power configured in the plant parameters.

### Installation

Download the latest version from the [Releases](https://github.com/denilnicolosi/siseli-app/releases) page.

- **Windows** — `.exe` installer, `.msix` package or portable `.zip`; Windows 10/11 x64.
- **Android** — APK (installable) or AAB bundle; for APK updates you may need to allow installation from unknown apps.

### First run and setup

1. Sign in with your `solar.siseli.com` account. After login, credentials are stored securely for auto-login.
2. Make sure the station and inverter are online in your Siseli account.
3. Go to **Settings → Station parameters** and enter battery capacity (Ah), installation year, PV power (W), inverter power (W), AC input breaker current, grid voltage, house load reserve, coordinates and time zone.
4. Open the **Data** tab to see real-time readings and inverter settings. Every change is applied only after confirmation.
5. On Windows you can enable **Start with Windows** and **Start in tray**; the tray menu also lets you switch manually between SBU and USB.

### Security and privacy

- The password is stored via `flutter_secure_storage` (DPAPI on Windows), not in plain text in preferences.
- The access token is not persisted; it is only used in memory during the session.
- Requests to the Siseli APIs are signed with `appId`, `nonce` and MD5.
- Logs mask passwords, tokens and other sensitive data.
- Credentials are sent only to `solar.siseli.com`; the app also contacts Open-Meteo for the forecast and GitHub for updates.
- The app is not affiliated with Siseli; the APIs may change without notice.

### Notes and limitations

- Setting descriptions follow the Easun iSolar manual; on other inverters names and parameters may differ.
- Voltage-based SOC correction is calibrated for 16S LiFePO4 packs.
- The app selects the first device returned by the account; there is no multi-plant selector.
- Unofficial APIs may change without notice and break the app.

### Development

Stack: Flutter/Dart, Provider, Dio, `fl_chart`, `window_manager`, `system_tray`, `launch_at_startup`, `flutter_secure_storage`, `shared_preferences`, `local_notifier`.

```powershell
flutter pub get
flutter test
flutter run -d windows
flutter build windows --release
flutter build apk --release
```

Documentation:

- [Release process](docs/RELEASE_PROCESS.md)
- [Debug logging](docs/DEBUG_LOGGING.md)
- [Font licenses](docs/FONTS_LICENSES.md)
- [Changelog](CHANGELOG.md)
- [Contributing](CONTRIBUTING.md)
- [Fork repository](https://github.com/denilnicolosi/siseli-app)
- [Original project](https://github.com/yuraantonov11/siseli-app)
- [Issues](https://github.com/denilnicolosi/siseli-app/issues)

### License and disclaimer

Licensed under the **MIT License**. See [LICENSE](LICENSE). The original project is by yuraantonov11 and contributors; this fork keeps the same license.

**Disclaimer:** unofficial application, not affiliated with Siseli, Easun, Solar of Things, Sun House or their respective owners. It uses undocumented APIs and may stop working if they change. Data and commands affect real hardware: always verify settings before applying them. Use at your own risk, without warranties.
