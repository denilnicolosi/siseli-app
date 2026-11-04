# Smart Inverter App v2.0.9

First release from the `denilnicolosi/siseli-app` fork.

## New

### 🇮🇹 Italian language
- Full Italian translation of the app.
- Pick **Italiano** in Settings → Language, or use the language button (cycles English → Українська → Italiano).

### 💶 Euro currency
- Money values are shown in **€**, tariffs in **€/kWh**, and current cost in **€/h**.
- Default tariffs are now 0.25 €/kWh (day) and 0.125 €/kWh (night). Set your own in Settings → Station parameters.

## Fixes
- Schedule rule dialog: the priority row no longer overflows on small phone screens.

## ⚠️ Important: new app identity
This build uses its own app identity, so it installs as a **separate app** from the original Smart Inverter App:
- Android package: `com.denilnicolosi.smartinverterapp`
- Windows MSIX identity: `DenilNicolosi.SmartInverterApp`

You will need to sign in again and re-enter your settings. You can uninstall the original app afterwards.

In-app updates now come from this repository's releases.

## Android

The APK is a **debug build** (this repository has no release signing key yet). To install it, allow installation from unknown sources when prompted.
