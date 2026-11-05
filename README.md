# Smart Inverter Desktop ⚡️

[![Version](https://img.shields.io/badge/version-1.4.0-blue.svg)](https://github.com/denilnicolosi/siseli-app/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat&logo=Flutter&logoColor=white)](https://flutter.dev)

A modern, fast, and elegant desktop application built with Flutter for monitoring and controlling solar inverters integrated with `solar.siseli.com` using the Wi-Fi module ECO/MAX-730.

---

## 📑 Table of Contents / Зміст
- [English Version](#english-version-en)
- [Українська версія](#українська-версія-ua)

---

# English Version (EN)

Built for an **off-grid** solar system: the app monitors the plant and lets you change inverter settings by hand. It never switches inverter modes on its own.

## Features 🚀
* **Real-time Monitoring**: Solar, battery, load and AC input (generator) with an animated energy flow diagram.
* **Energy History**: Day / week / month chart with a full-screen view that rotates the phone to landscape.
* **Solar Forecast**: Next days' production from Open-Meteo radiation, sized on your panel power (e.g. 3 kWp) and site location.
* **Inverter Settings**: Output and charger priorities (USB/SUB/SBU, CSO/SNU/OSO) and the other parameters, each with an explanation based on the Easun iSolar manual.
* **Battery**: SOC history, cycle count and low-battery notifications.
* **System Tray Integration** (desktop): Run in the background with battery status on hover.

## Setup
1. **Hardware Configuration:** In Settings → Station parameters enter battery Ah, panel power (W) and the site location (latitude/longitude) used by the forecast.

---

# Українська версія (UA)

Створено для **автономної (off-grid)** сонячної системи: застосунок показує стан установки й дозволяє змінювати налаштування інвертора вручну. Він ніколи не перемикає режими інвертора самостійно.

## Можливості 🚀
* **Моніторинг у реальному часі**: сонце, АКБ, навантаження та вхід AC (генератор) з анімованою схемою потоків енергії.
* **Історія енергії**: графік за день / тиждень / місяць з повноекранним режимом, що повертає телефон горизонтально.
* **Прогноз генерації**: виробництво на наступні дні за радіацією Open-Meteo з урахуванням потужності панелей (наприклад 3 кВтп) і розташування.
* **Налаштування інвертора**: пріоритети виходу та заряду (USB/SUB/SBU, CSO/SNU/OSO) та інші параметри, кожен з поясненням за інструкцією Easun iSolar.
* **АКБ**: історія SOC, кількість циклів і сповіщення про низький заряд.
* **Робота у треї** (desktop): моніторинг заряду АКБ без відкриття вікна програми.

## Налаштування
1. **Параметри заліза:** у Settings → Station parameters вкажіть ємність АКБ (Ah), потужність панелей (W) та координати місця (широта/довгота) для прогнозу.

---

## Technology Stack 💻
- **Flutter** & **Dart**
- **Provider** (State Management)
- **Dio** (HTTP Client)
- **Fl_Chart** (Graphics)

## Installation 📥
Download the EXE from the [Releases](https://github.com/denilnicolosi/siseli-app/releases) section. Supports Windows 10/11.

## Android Release (AAB/APK) 🤖
1. Create an upload keystore inside `android/`:

```powershell
keytool -genkey -v -keystore android\upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Create `android/key.properties` from `android/key.properties.example` and fill in real passwords/alias.

3. Build release artifacts:

```powershell
flutter pub get
flutter build appbundle --release
flutter build apk --release
```

Generated files:
- `build/app/outputs/bundle/release/app-release.aab`
- `build/app/outputs/flutter-apk/app-release.apk`

## Release Process 📦
Canonical release runbook:
- `docs/RELEASE_PROCESS.md`

Set Android signing secrets for GitHub Actions tag releases:

```powershell
.\scripts\setup_github_android_signing.ps1 -KeystorePath .\android\upload-keystore.jks -StorePassword "<store-password>" -KeyAlias "upload" -KeyPassword "<key-password>" -Repo denilnicolosi/siseli-app
```

Official release command (prepare -> build -> commit -> tag -> push):

```powershell
.\scripts\release.ps1 -Version 2.0.4 -Push -SkipInno
```

Quick command for validation/build only:

```powershell
.\scripts\build_release.ps1 -SkipInno
```

## License 📄
This project is licensed under the MIT License.
Bundled fonts and their licenses are documented in `docs/FONTS_LICENSES.md`.

## Disclaimer ⚠️
This application uses the internal API of the solar.siseli.com platform. Use at your own risk.