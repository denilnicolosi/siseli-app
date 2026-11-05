# Debug Logging

- [English](#english)
- [Українська](#українська)

---

## English

### Overview

The app has **two levels of logging**:

1. **In-memory log** — a 1000-entry buffer shown in the UI (`LogService.log`).
2. **File log** — critical events written to disk for later analysis (`LogService.logCritical`).

### Critical categories

| Category | Meaning | Where it is logged |
|----------|---------|--------------------|
| `CONTROL_WRITE` | A write to the inverter failed, or the safe charging current could not be confirmed by read-back | `app_provider.dart` (`changeSetting`, `applySafeChargingCurrent`) |

The app no longer switches inverter modes on its own (HEMS and automations were removed), so the old `BATTERY_*`, `EVENING_PROTECTION`, `MODE_CONFLICT`, `STALE_DATA` and `EMERGENCY_CHARGE` categories are gone.

### File location

```
~/Documents/siseli_debug_logs/
├── hems_critical_events.log-2026-05-12
├── hems_critical_events.log-2026-05-11.01
└── ... (at most 10 files, rotated at 5 MB)
```

The `hems_critical_events.log` file name is kept so older logs stay readable.

- **Windows**: `C:\Users\<user>\Documents\siseli_debug_logs\`
- **Android**: `/storage/emulated/0/Documents/siseli_debug_logs/` (or `/sdcard/...`)
- **iOS**: `~/Documents/siseli_debug_logs/`

### How to use

1. **Enable Developer Mode**: tap the app version 7 times in Settings.
2. **Open the logs**: Settings → 🐛 Debug Logs opens a full-screen view with file info, the logged categories, the critical-events file content and reload/delete buttons.
3. **Export**: copy the content from the screen, or open the `Documents/siseli_debug_logs/` folder.

### Entry format

```
[HH:MM:SS] [CATEGORY] MESSAGE
```

Example:

```
[18:45:33] [CONTROL_WRITE] ❌ setting.write failed: key=outputSourcePrioritySetting value=2 deviceSn=... (likely API timeout/offline).
```

### Developer API

```dart
// Initialize file logging at app startup
await LogService.initializeFileLogging();

// Log a critical event
LogService.logCritical('My critical message', category: 'MY_CATEGORY');

// Read all critical logs from file
final logs = await LogService.readCriticalLog();

// Get file path
final path = await LogService.getDebugLogPath();

// List all log files
final files = await LogService.listDebugLogFiles();

// Clear all logs
await LogService.clearDebugLogs();
```

### Troubleshooting

**"A setting does not change"**
1. Open Debug Logs and look for `CONTROL_WRITE`.
2. Check `key=` and `value=`, and whether the device was offline.
3. The cloud applies writes with a delay: wait about a minute and refresh the settings.

**"The app reacts slowly"**
1. Check the network connection.
2. Check the "Last update" time on the dashboard: the inverter Wi-Fi module sends data about every 5 minutes.

### Privacy

**Never logged** (masked automatically): tokens, passwords, keys, e-mail addresses, URL parameters with sensitive data.

**Logged**: SOC %, setting keys and values written, timestamps, version numbers, error types.

### Reporting a problem

Attach:
1. The **log file** from `Documents/siseli_debug_logs/`
2. The **time range** of the problem
3. A **short description** of what went wrong

---

## Українська

### Огляд

Застосунок має **два рівні логування**:

1. **Логи в пам'яті** — буфер на 1000 записів, що показується в UI (`LogService.log`).
2. **Файлові логи** — критичні події записуються на диск для аналізу (`LogService.logCritical`).

### Критичні категорії

| Категорія | Опис | Де логується |
|-----------|------|-------------|
| `CONTROL_WRITE` | Не вдалося записати налаштування в інвертор або підтвердити безпечний струм заряду зчитуванням | `app_provider.dart` (`changeSetting`, `applySafeChargingCurrent`) |

Застосунок більше не перемикає режими інвертора самостійно (HEMS і автоматизації видалено), тому старих категорій `BATTERY_*`, `EVENING_PROTECTION`, `MODE_CONFLICT`, `STALE_DATA` та `EMERGENCY_CHARGE` більше немає.

### Розташування файлів

```
~/Documents/siseli_debug_logs/
├── hems_critical_events.log-2026-05-12
├── hems_critical_events.log-2026-05-11.01
└── ... (максимум 10 файлів, ротація після 5 МБ)
```

Назву файлу `hems_critical_events.log` збережено, щоб старі логи залишались доступними.

- **Windows**: `C:\Users\<user>\Documents\siseli_debug_logs\`
- **Android**: `/storage/emulated/0/Documents/siseli_debug_logs/` (або `/sdcard/...`)
- **iOS**: `~/Documents/siseli_debug_logs/`

### Як користуватися

1. **Увімкнути Developer Mode**: натисніть на версію застосунку 7 разів у Settings.
2. **Переглянути логи**: Settings → 🐛 Debug Logs відкриває повноекранний вигляд з інформацією про файли, категоріями, вмістом файлу критичних подій і кнопками оновлення/видалення.
3. **Експорт**: скопіюйте вміст з екрана або відкрийте папку `Documents/siseli_debug_logs/`.

### Формат запису

```
[HH:MM:SS] [CATEGORY] MESSAGE
```

### API для розробників

Див. приклад коду в англійському розділі вище.

### Діагностика

**«Налаштування не змінюється»**
1. Відкрийте Debug Logs і шукайте `CONTROL_WRITE`.
2. Перевірте `key=` і `value=` та чи був пристрій офлайн.
3. Хмара застосовує запис із затримкою: зачекайте близько хвилини й оновіть налаштування.

**«Застосунок повільно реагує»**
1. Перевірте мережеве з'єднання.
2. Перевірте час «Останнє оновлення» на дашборді: Wi-Fi модуль інвертора надсилає дані приблизно кожні 5 хвилин.

### Конфіденційність

**Ніколи не логуються** (маскуються автоматично): токени, паролі, ключі, email-адреси, URL-параметри з чутливими даними.

**Логуються**: SOC %, записані ключі та значення налаштувань, час, номери версій, типи помилок.

### Звіт про проблему

Додайте:
1. **Файл логу** з `Documents/siseli_debug_logs/`
2. **Часовий діапазон** проблеми
3. **Короткий опис** того, що сталося

---

**Last updated / Остання оновлення:** 2026-11-05
