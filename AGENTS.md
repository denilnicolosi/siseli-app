# AI Agent Guidelines for Smart Inverter App

## Project Overview
This is a Flutter desktop application for monitoring and controlling PowMr/SmartESS solar inverters via the `solar.siseli.com` API. It targets an **off-grid** plant (3 kWp PV, Easun iSolar SMH III 6.2 kW, optional generator on the AC input): real-time monitoring, energy history, solar forecast and manual inverter settings. There is no HEMS and no automation: the app never writes inverter settings on its own.

## Architecture & Data Flow
- **State Management**: Uses Provider pattern with `AppProvider` managing authentication, stations, devices, and real-time data
- **API Communication**: `InverterService` handles authentication (MD5-signed requests) and CRUD operations for stations/devices/data
- **Data Models**: `InverterData` parses complex API responses with custom logic for power calculations and SOC compensation
- **UI Structure**: Tab-based navigation (Dashboard/Details/Settings) with reactive updates via Provider. Large tabs are split with `part`/`part of`: `lib/screens/dashboard/` and `lib/screens/settings/` (private widgets stay library-private)
- **Docs**: `docs/` (DEBUG_LOGGING, RELEASE_PROCESS, FONTS_LICENSES; English + Ukrainian where translated); release notes in `docs/release-notes/X.Y.Z.md` (read by `release.yml` and `scripts/*release.ps1`)

## Key Services & Patterns
- **InverterService**: API client with custom headers (appId, nonce, MD5 sign). Endpoints: `/apis/login/account`, `/apis/station/list`, `/apis/device/realTime`, `/apis/device/control`
- **WeatherService**: Fetches solar radiation forecasts from Open-Meteo for the site `lat`/`lon` (required), sized on `pvTotalCapacityW`; learns radiation→PV bins from historical PV data (samples at SOC ≥ 95% are skipped because the MPPT curtails PV when the battery is full)
- **LogService**: Centralized logging with 1000-entry buffer, used throughout app instead of print/debugPrint
- **SecureStorageService**: Wraps `flutter_secure_storage` for credential storage (Windows: DPAPI). Use `SecureStorageService.savePassword/getPassword/deletePassword` — do NOT store secrets in `SharedPreferences`. The access token is not persisted (`deleteToken` only cleans up older installs)
- **UpdateService**: Checks GitHub Releases API (`denilnicolosi/siseli-app`) via `dio` (the only HTTP client in the app), downloads installer (`.exe`/`.msi`/`.msix` priority order) to temp dir, and launches it via `Process.run`/`Process.start` with `runInShell: false`

## Control Modes & Settings
- **Output Priority** (`outputSourcePrioritySetting`): 0=USB (AC input first), 1=SUB, 2=SBU (solar → battery → AC; recommended off-grid)
- **Charger Priority**: 0=CSO (Solar first), 1=SNU (Solar+Utility), 2=OSO (Solar only), 3=Utility only
- **Setting labels**: `lib/utils/inverter_setting_info.dart` maps config keys to localized names/descriptions (Easun manual LCD programs); unknown keys fall back to the API name

## Development Workflow
- **Build**: `flutter build windows --release` (Windows x64 target)
- **Package (Inno Setup)**: Inno Setup script (`windows/installer_script.iss`) creates EXE installer
- **Package (MSIX)**: `flutter pub run msix:create` uses `msix_config` in `pubspec.yaml` (identity: `DenilNicolosi.SmartInverterApp`)
- **Test**: `flutter test` — `test/` covers SOC history, inverter setting labels and widgets
- **Localize**: ARB files (`lib/l10n/app_*.arb`) with placeholders for dynamic strings
- **Icons**: `flutter_launcher_icons` generates from `assets/app_icon.png`

## UI/UX Patterns
- **Theme**: Material 3 with amber seed color, light/dark modes
- **Charts**: `fl_chart` for energy flow visualization (pie/bar charts)
- **System Tray**: Windows integration with `system_tray` package for background operation
- **Window Management**: `window_manager` for desktop window controls (minimize to tray, prevent close)

## Integration Points
- **External APIs**: solar.siseli.com (inverter control), open-meteo.com (weather forecasts), api.github.com (update checks via `UpdateService`)
- **Desktop Features**: Auto-startup (`launch_at_startup`), system tray, window management
- **Security**: Credentials stored via `SecureStorageService` (DPAPI on Windows); API requests signed with MD5 using `crypto` package; `encrypt` package available for additional encryption needs

## Common Tasks
- **Add an inverter setting label**: add the key to `inverterSettingInfo` + `knownInverterSettingKeys` and `invSet*` keys to `app_en.arb`/`app_it.arb`, then `flutter gen-l10n`
- **New UI screen**: Create in `lib/screens/`, add to the `destinations` list and `_buildRawPage` in `main_screen.dart`, update localization
- **API endpoint**: Add method to `InverterService` with proper headers/signing
- **Settings persistence**: Use `SharedPreferences` in `AppProvider` for non-sensitive user prefs; use `SecureStorageService` for passwords
