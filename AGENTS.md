# AI Agent Guidelines for Smart Inverter App

## Project Overview
This is a Flutter desktop application for monitoring and controlling PowMr/SmartESS solar inverters via the `solar.siseli.com` API. The app provides real-time energy flow visualization, automated control modes, and intelligent HEMS (Home Energy Management System) algorithms.

## Architecture & Data Flow
- **State Management**: Uses Provider pattern with `AppProvider` managing authentication, stations, devices, and real-time data
- **API Communication**: `InverterService` handles authentication (MD5-signed requests) and CRUD operations for stations/devices/data
- **Data Models**: `InverterData` parses complex API responses with custom logic for power calculations and SOC compensation
- **UI Structure**: Tab-based navigation (Dashboard/Automation/Details/Settings) with reactive updates via Provider. Large tabs are split with `part`/`part of`: `lib/screens/dashboard/` and `lib/screens/settings/` (private widgets stay library-private)
- **Docs**: `docs/` (HEMS_MODES, DEBUG_LOGGING, RELEASE_PROCESS, FONTS_LICENSES); release notes in `docs/release-notes/X.Y.Z.md` (read by `release.yml` and `scripts/*release.ps1`)

## Key Services & Patterns
- **InverterService**: API client with custom headers (appId, nonce, MD5 sign). Endpoints: `/apis/login/account`, `/apis/station/list`, `/apis/device/realTime`, `/apis/device/control`
- **HemsAlgorithmService**: Implements smart modes (Adaptive, Night Arbitrage, Storm) with tariff-aware logic and weather integration
- **WeatherService**: Fetches solar radiation forecasts from Open-Meteo API, learns dynamic conversion ratios from historical PV data
- **LogService**: Centralized logging with 1000-entry buffer, used throughout app instead of print/debugPrint
- **SecureStorageService**: Wraps `flutter_secure_storage` for credential storage (Windows: DPAPI). Use `SecureStorageService.savePassword/getPassword/deletePassword` — do NOT store secrets in `SharedPreferences`. The access token is not persisted (`deleteToken` only cleans up older installs)
- **TariffForecastService**: `isNightTariffHour()` is the single day/night tariff-window check — reuse it instead of hardcoding `hour >= 23 || hour < 7`
- **UpdateService**: Checks GitHub Releases API (`denilnicolosi/siseli-app`) via `dio` (the only HTTP client in the app), downloads installer (`.exe`/`.msi`/`.msix` priority order) to temp dir, and launches it via `Process.run`/`Process.start` with `runInShell: false`

## Control Modes & Settings
- **Output Priority**: 0=USB (Grid priority), 2=SBU (Solar priority)
- **Charger Priority**: 0=CSO (Solar first), 1=SNU (Solar+Utility), 2=OSO (Solar only), 3=Utility only
- **Automation Triggers**: Timer-based (23:00 grid, 07:00 solar) and algorithm-driven mode switching

## Development Workflow
- **Build**: `flutter build windows --release` (Windows x64 target)
- **Package (Inno Setup)**: Inno Setup script (`windows/installer_script.iss`) creates EXE installer
- **Package (MSIX)**: `flutter pub run msix:create` uses `msix_config` in `pubspec.yaml` (identity: `DenilNicolosi.SmartInverterApp`)
- **Test**: `flutter test` — `test/` covers HEMS adaptive logic, tariff windows, schedule rules, SOC history, grid outage detection, diagnostics export and widgets
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
- **Add new control mode**: Update `InverterService.setControlMode()` and `HemsAlgorithmService` logic
- **New UI screen**: Create in `lib/screens/`, add to `main_screen.dart` TabBarView, update localization
- **API endpoint**: Add method to `InverterService` with proper headers/signing
- **Settings persistence**: Use `SharedPreferences` in `AppProvider` for non-sensitive user prefs; use `SecureStorageService` for passwords
