import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it'),
    Locale('uk')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Inverter'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light theme'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get darkTheme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// No description provided for @energyOverview.
  ///
  /// In en, this message translates to:
  /// **'Energy Overview'**
  String get energyOverview;

  /// No description provided for @production.
  ///
  /// In en, this message translates to:
  /// **'Production'**
  String get production;

  /// No description provided for @consumption.
  ///
  /// In en, this message translates to:
  /// **'Consumption'**
  String get consumption;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// No description provided for @battery.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get battery;

  /// No description provided for @forecast.
  ///
  /// In en, this message translates to:
  /// **'Forecast'**
  String get forecast;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'Application Settings'**
  String get appSettings;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @userNameDefault.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get userNameDefault;

  /// No description provided for @userId.
  ///
  /// In en, this message translates to:
  /// **'ID: {id}'**
  String userId(String id);

  /// No description provided for @advancedSettings.
  ///
  /// In en, this message translates to:
  /// **'Advanced Settings'**
  String get advancedSettings;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @startWithWindows.
  ///
  /// In en, this message translates to:
  /// **'Start with Windows'**
  String get startWithWindows;

  /// No description provided for @startInTray.
  ///
  /// In en, this message translates to:
  /// **'Start in tray'**
  String get startInTray;

  /// No description provided for @startInTraySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Starts minimized when a saved session exists'**
  String get startInTraySubtitle;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @notProvided.
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get notProvided;

  /// No description provided for @unknownValue.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownValue;

  /// No description provided for @accountStatusLocal.
  ///
  /// In en, this message translates to:
  /// **'Local profile only'**
  String get accountStatusLocal;

  /// No description provided for @accountStatusSynced.
  ///
  /// In en, this message translates to:
  /// **'Cloud profile synced'**
  String get accountStatusSynced;

  /// No description provided for @cloudAccount.
  ///
  /// In en, this message translates to:
  /// **'Cloud account'**
  String get cloudAccount;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @sessionId.
  ///
  /// In en, this message translates to:
  /// **'Session ID'**
  String get sessionId;

  /// No description provided for @accountProfileHint.
  ///
  /// In en, this message translates to:
  /// **'Profile data is used for account display and inverter cloud access.'**
  String get accountProfileHint;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out from this device?'**
  String get logoutConfirmMessage;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger zone'**
  String get dangerZone;

  /// No description provided for @nameCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get nameCannotBeEmpty;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copiedToClipboard;

  /// No description provided for @updatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get updatesTitle;

  /// No description provided for @updatesCheckingBackground.
  ///
  /// In en, this message translates to:
  /// **'Checking updates in background...'**
  String get updatesCheckingBackground;

  /// No description provided for @updatesChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking for updates...'**
  String get updatesChecking;

  /// No description provided for @updatesSubtitleDefault.
  ///
  /// In en, this message translates to:
  /// **'Check and install latest version'**
  String get updatesSubtitleDefault;

  /// No description provided for @updatesSubtitleAvailable.
  ///
  /// In en, this message translates to:
  /// **'New version {version} is available'**
  String updatesSubtitleAvailable(String version);

  /// No description provided for @updatesSubtitleSkipped.
  ///
  /// In en, this message translates to:
  /// **'Version {version} is skipped'**
  String updatesSubtitleSkipped(String version);

  /// No description provided for @updatesSubtitleUpToDate.
  ///
  /// In en, this message translates to:
  /// **'You are up to date ({version})'**
  String updatesSubtitleUpToDate(String version);

  /// No description provided for @updatesLastChecked.
  ///
  /// In en, this message translates to:
  /// **'Last checked: {time}'**
  String updatesLastChecked(String time);

  /// No description provided for @updatesSkippedBanner.
  ///
  /// In en, this message translates to:
  /// **'Version {version} is currently skipped.'**
  String updatesSkippedBanner(String version);

  /// No description provided for @updatesSkippedRestored.
  ///
  /// In en, this message translates to:
  /// **'Skipped version restored.'**
  String get updatesSkippedRestored;

  /// No description provided for @updatesRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get updatesRestore;

  /// No description provided for @updatesBannerAvailable.
  ///
  /// In en, this message translates to:
  /// **'New update {version} is available'**
  String updatesBannerAvailable(String version);

  /// No description provided for @updatesCurrentVersion.
  ///
  /// In en, this message translates to:
  /// **'Current version: {version}'**
  String updatesCurrentVersion(String version);

  /// No description provided for @updatesView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get updatesView;

  /// No description provided for @updatesSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get updatesSkip;

  /// No description provided for @updatesSkippedNow.
  ///
  /// In en, this message translates to:
  /// **'Version {version} was skipped.'**
  String updatesSkippedNow(String version);

  /// No description provided for @updatesNoInstallerFound.
  ///
  /// In en, this message translates to:
  /// **'No compatible installer was found in this release.'**
  String get updatesNoInstallerFound;

  /// No description provided for @updatesDialogAvailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Available'**
  String get updatesDialogAvailableTitle;

  /// No description provided for @updatesDialogCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current: {version}'**
  String updatesDialogCurrent(String version);

  /// No description provided for @updatesDialogLatest.
  ///
  /// In en, this message translates to:
  /// **'Latest: {version}'**
  String updatesDialogLatest(String version);

  /// No description provided for @updatesDialogPublished.
  ///
  /// In en, this message translates to:
  /// **'Published: {time}'**
  String updatesDialogPublished(String time);

  /// No description provided for @updatesDialogPackage.
  ///
  /// In en, this message translates to:
  /// **'Package: {name}'**
  String updatesDialogPackage(String name);

  /// No description provided for @updatesDialogSkipVersion.
  ///
  /// In en, this message translates to:
  /// **'Skip this version'**
  String get updatesDialogSkipVersion;

  /// No description provided for @updatesDialogLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get updatesDialogLater;

  /// No description provided for @updatesDialogDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get updatesDialogDownload;

  /// No description provided for @updatesDialogDownloadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Downloading update'**
  String get updatesDialogDownloadingTitle;

  /// No description provided for @updatesDialogDownloadFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Download failed'**
  String get updatesDialogDownloadFailedTitle;

  /// No description provided for @updatesDialogPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing download...'**
  String get updatesDialogPreparing;

  /// No description provided for @updatesDialogInstallTitle.
  ///
  /// In en, this message translates to:
  /// **'Install Update'**
  String get updatesDialogInstallTitle;

  /// No description provided for @updatesDialogInstallPrompt.
  ///
  /// In en, this message translates to:
  /// **'Update downloaded ({version}). Install now? The app will close during installation.'**
  String updatesDialogInstallPrompt(String version);

  /// No description provided for @updatesDialogInstall.
  ///
  /// In en, this message translates to:
  /// **'Install'**
  String get updatesDialogInstall;

  /// No description provided for @updatesDialogInstallFailed.
  ///
  /// In en, this message translates to:
  /// **'Installation failed. Please run installer manually.'**
  String get updatesDialogInstallFailed;

  /// No description provided for @updatesInstallPermissionNeeded.
  ///
  /// In en, this message translates to:
  /// **'Allow \"Install unknown apps\" for Smart Inverter in the settings that just opened, then come back and tap Install.'**
  String get updatesInstallPermissionNeeded;

  /// No description provided for @updatesDialogDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Download failed. Check internet or release assets.'**
  String get updatesDialogDownloadFailed;

  /// No description provided for @updatesDialogClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get updatesDialogClose;

  /// No description provided for @inverterSettings.
  ///
  /// In en, this message translates to:
  /// **'Inverter settings'**
  String get inverterSettings;

  /// No description provided for @refreshSettings.
  ///
  /// In en, this message translates to:
  /// **'Refresh settings'**
  String get refreshSettings;

  /// No description provided for @settingsLoadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings are loading…'**
  String get settingsLoadingTitle;

  /// No description provided for @waitingInverterResponse.
  ///
  /// In en, this message translates to:
  /// **'Waiting for inverter response…'**
  String get waitingInverterResponse;

  /// No description provided for @tapRefreshToLoad.
  ///
  /// In en, this message translates to:
  /// **'Tap refresh to load settings'**
  String get tapRefreshToLoad;

  /// No description provided for @realtimeReadings.
  ///
  /// In en, this message translates to:
  /// **'Realtime readings'**
  String get realtimeReadings;

  /// No description provided for @unitOfMeasure.
  ///
  /// In en, this message translates to:
  /// **'Unit: {unit}'**
  String unitOfMeasure(String unit);

  /// No description provided for @selectValue.
  ///
  /// In en, this message translates to:
  /// **'Select value'**
  String get selectValue;

  /// No description provided for @newValue.
  ///
  /// In en, this message translates to:
  /// **'New value'**
  String get newValue;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @debugLogs.
  ///
  /// In en, this message translates to:
  /// **'Debug Logs'**
  String get debugLogs;

  /// No description provided for @viewSystemLogs.
  ///
  /// In en, this message translates to:
  /// **'View system logs'**
  String get viewSystemLogs;

  /// No description provided for @analyzeSystemLogs.
  ///
  /// In en, this message translates to:
  /// **'Analyze app errors and API calls'**
  String get analyzeSystemLogs;

  /// No description provided for @stationParameters.
  ///
  /// In en, this message translates to:
  /// **'Station parameters'**
  String get stationParameters;

  /// No description provided for @stationParametersHint.
  ///
  /// In en, this message translates to:
  /// **'These values help the intelligent algorithm calculate energy balance and weather-based forecasts more accurately.'**
  String get stationParametersHint;

  /// No description provided for @batteryCapacityLabel.
  ///
  /// In en, this message translates to:
  /// **'Battery capacity'**
  String get batteryCapacityLabel;

  /// No description provided for @inputBreakerLabel.
  ///
  /// In en, this message translates to:
  /// **'Input breaker'**
  String get inputBreakerLabel;

  /// No description provided for @gridVoltageLabel.
  ///
  /// In en, this message translates to:
  /// **'Grid voltage'**
  String get gridVoltageLabel;

  /// No description provided for @houseLoadReserveLabel.
  ///
  /// In en, this message translates to:
  /// **'House reserve load'**
  String get houseLoadReserveLabel;

  /// No description provided for @autoReserveLoadTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto reserve load'**
  String get autoReserveLoadTitle;

  /// No description provided for @autoReserveLoadEnabledSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reserve is updated automatically from live and historical load'**
  String get autoReserveLoadEnabledSubtitle;

  /// No description provided for @autoReserveLoadDisabledSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reserve is fixed manually'**
  String get autoReserveLoadDisabledSubtitle;

  /// No description provided for @reserveModeAuto.
  ///
  /// In en, this message translates to:
  /// **'Mode: AUTO'**
  String get reserveModeAuto;

  /// No description provided for @reserveModeManual.
  ///
  /// In en, this message translates to:
  /// **'Mode: MANUAL'**
  String get reserveModeManual;

  /// No description provided for @reserveModeAutoHint.
  ///
  /// In en, this message translates to:
  /// **'AUTO: reserve updates from live load and hourly profile with smoothing and safety headroom.'**
  String get reserveModeAutoHint;

  /// No description provided for @reserveModeManualHint.
  ///
  /// In en, this message translates to:
  /// **'MANUAL: reserve stays fixed to the value you set.'**
  String get reserveModeManualHint;

  /// No description provided for @houseLoadReserveHint.
  ///
  /// In en, this message translates to:
  /// **'Reserve power for additional home appliances to avoid breaker trips during charging.'**
  String get houseLoadReserveHint;

  /// No description provided for @autoEstimateReserveLoad.
  ///
  /// In en, this message translates to:
  /// **'Auto estimate reserve load'**
  String get autoEstimateReserveLoad;

  /// No description provided for @chargePowerEstimateTitle.
  ///
  /// In en, this message translates to:
  /// **'Safe charge speed estimate'**
  String get chargePowerEstimateTitle;

  /// No description provided for @chargePowerSafeLimitLabel.
  ///
  /// In en, this message translates to:
  /// **'Battery charge power limit'**
  String get chargePowerSafeLimitLabel;

  /// No description provided for @chargeCurrentSafeLimitLabel.
  ///
  /// In en, this message translates to:
  /// **'Battery charge current limit'**
  String get chargeCurrentSafeLimitLabel;

  /// No description provided for @chargeCurrentConservativeLabel.
  ///
  /// In en, this message translates to:
  /// **'Conservative charge current'**
  String get chargeCurrentConservativeLabel;

  /// No description provided for @chargeInputCurrentEstimateLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated AC input current'**
  String get chargeInputCurrentEstimateLabel;

  /// No description provided for @chargeBreakerRiskSafe.
  ///
  /// In en, this message translates to:
  /// **'Breaker risk: low'**
  String get chargeBreakerRiskSafe;

  /// No description provided for @chargeBreakerRiskElevated.
  ///
  /// In en, this message translates to:
  /// **'Breaker risk: elevated'**
  String get chargeBreakerRiskElevated;

  /// No description provided for @chargeBreakerRiskHigh.
  ///
  /// In en, this message translates to:
  /// **'Breaker risk: high (trip likely)'**
  String get chargeBreakerRiskHigh;

  /// No description provided for @chargeBreakerRiskHint.
  ///
  /// In en, this message translates to:
  /// **'Analysis uses reserve/live/profile house load: {load} W'**
  String chargeBreakerRiskHint(String load);

  /// No description provided for @chargeTimeToFullLabel.
  ///
  /// In en, this message translates to:
  /// **'Time to 100%'**
  String get chargeTimeToFullLabel;

  /// No description provided for @chargeTimeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Not enough data'**
  String get chargeTimeUnavailable;

  /// No description provided for @chargeEstimateNoRealtimeSoc.
  ///
  /// In en, this message translates to:
  /// **'Realtime SOC is unavailable. Charge time will appear when live data is received.'**
  String get chargeEstimateNoRealtimeSoc;

  /// No description provided for @chargeEstimateBasedOnSoc.
  ///
  /// In en, this message translates to:
  /// **'Estimate based on current SOC: {soc}%'**
  String chargeEstimateBasedOnSoc(String soc);

  /// No description provided for @panelPowerLabel.
  ///
  /// In en, this message translates to:
  /// **'Panel power'**
  String get panelPowerLabel;

  /// No description provided for @inverterPowerLabel.
  ///
  /// In en, this message translates to:
  /// **'Inverter power'**
  String get inverterPowerLabel;

  /// No description provided for @locationPreset.
  ///
  /// In en, this message translates to:
  /// **'Location preset'**
  String get locationPreset;

  /// No description provided for @latitudeLabel.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitudeLabel;

  /// No description provided for @longitudeLabel.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get longitudeLabel;

  /// No description provided for @timeZoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Time zone'**
  String get timeZoneLabel;

  /// No description provided for @geoPresetKyiv.
  ///
  /// In en, this message translates to:
  /// **'Kyiv, UA'**
  String get geoPresetKyiv;

  /// No description provided for @geoPresetLviv.
  ///
  /// In en, this message translates to:
  /// **'Lviv, UA'**
  String get geoPresetLviv;

  /// No description provided for @geoPresetOdesa.
  ///
  /// In en, this message translates to:
  /// **'Odesa, UA'**
  String get geoPresetOdesa;

  /// No description provided for @geoPresetDnipro.
  ///
  /// In en, this message translates to:
  /// **'Dnipro, UA'**
  String get geoPresetDnipro;

  /// No description provided for @geoPresetKharkiv.
  ///
  /// In en, this message translates to:
  /// **'Kharkiv, UA'**
  String get geoPresetKharkiv;

  /// No description provided for @geoPresetWarsaw.
  ///
  /// In en, this message translates to:
  /// **'Warsaw, PL'**
  String get geoPresetWarsaw;

  /// No description provided for @geoPresetBerlin.
  ///
  /// In en, this message translates to:
  /// **'Berlin, DE'**
  String get geoPresetBerlin;

  /// No description provided for @geoPresetCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom (manual)'**
  String get geoPresetCustom;

  /// No description provided for @geoSummary.
  ///
  /// In en, this message translates to:
  /// **'Geo: {latitude}, {longitude} ({timeZone})'**
  String geoSummary(String latitude, String longitude, String timeZone);

  /// No description provided for @useMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my location'**
  String get useMyLocation;

  /// No description provided for @locationHelp.
  ///
  /// In en, this message translates to:
  /// **'Fills the site coordinates used by the solar forecast, plus the site timezone.'**
  String get locationHelp;

  /// No description provided for @locationDetecting.
  ///
  /// In en, this message translates to:
  /// **'Detecting location…'**
  String get locationDetecting;

  /// No description provided for @locationDetected.
  ///
  /// In en, this message translates to:
  /// **'Position detected: {latitude}, {longitude} · {timeZone}. Tap Save to apply.'**
  String locationDetected(String latitude, String longitude, String timeZone);

  /// No description provided for @locationServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are off. Turn on GPS/location in the system settings and try again.'**
  String get locationServicesDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied. Allow access to position for this app and try again.'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location permission is permanently denied. Enable it in the app settings.'**
  String get locationPermissionDeniedForever;

  /// No description provided for @locationTimeout.
  ///
  /// In en, this message translates to:
  /// **'No GPS fix received yet. Try again near a window or with high-accuracy location enabled.'**
  String get locationTimeout;

  /// No description provided for @locationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not read the current position. Try again.'**
  String get locationUnavailable;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @hardwareSettingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Hardware settings saved!'**
  String get hardwareSettingsSaved;

  /// No description provided for @hardwareSummary.
  ///
  /// In en, this message translates to:
  /// **'Battery: {battery} Ah • PV: {pv} W\nInverter: {inverter} W'**
  String hardwareSummary(String battery, String pv, String inverter);

  /// No description provided for @chargeLimitSummary.
  ///
  /// In en, this message translates to:
  /// **'Input C{breaker} -> safe battery charge {power} W (~{current} A)'**
  String chargeLimitSummary(String breaker, String power, String current);

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @presetDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get presetDisabled;

  /// No description provided for @presetEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get presetEnabled;

  /// No description provided for @presetOutputUsb.
  ///
  /// In en, this message translates to:
  /// **'USB - Grid priority'**
  String get presetOutputUsb;

  /// No description provided for @presetOutputSub.
  ///
  /// In en, this message translates to:
  /// **'SUB - Solar first'**
  String get presetOutputSub;

  /// No description provided for @presetOutputSbu.
  ///
  /// In en, this message translates to:
  /// **'SBU - Solar/Battery priority'**
  String get presetOutputSbu;

  /// No description provided for @presetChargerCso.
  ///
  /// In en, this message translates to:
  /// **'CSO - Solar first'**
  String get presetChargerCso;

  /// No description provided for @presetChargerSnu.
  ///
  /// In en, this message translates to:
  /// **'SNU - Solar + Utility'**
  String get presetChargerSnu;

  /// No description provided for @presetChargerOso.
  ///
  /// In en, this message translates to:
  /// **'OSO - Solar only'**
  String get presetChargerOso;

  /// No description provided for @presetChargerUtilityOnly.
  ///
  /// In en, this message translates to:
  /// **'Utility only'**
  String get presetChargerUtilityOnly;

  /// No description provided for @presetFrequency50Hz.
  ///
  /// In en, this message translates to:
  /// **'50 Hz'**
  String get presetFrequency50Hz;

  /// No description provided for @presetFrequency60Hz.
  ///
  /// In en, this message translates to:
  /// **'60 Hz'**
  String get presetFrequency60Hz;

  /// No description provided for @presetAcInputAplWide.
  ///
  /// In en, this message translates to:
  /// **'APL - Wide range'**
  String get presetAcInputAplWide;

  /// No description provided for @presetAcInputUpsNarrow.
  ///
  /// In en, this message translates to:
  /// **'UPS - Narrow range'**
  String get presetAcInputUpsNarrow;

  /// No description provided for @presetBatteryTypeAgm.
  ///
  /// In en, this message translates to:
  /// **'AGM'**
  String get presetBatteryTypeAgm;

  /// No description provided for @presetBatteryTypeFlooded.
  ///
  /// In en, this message translates to:
  /// **'Flooded'**
  String get presetBatteryTypeFlooded;

  /// No description provided for @presetBatteryTypeUser.
  ///
  /// In en, this message translates to:
  /// **'User-defined'**
  String get presetBatteryTypeUser;

  /// No description provided for @presetBatteryTypeLib.
  ///
  /// In en, this message translates to:
  /// **'LIB (Lithium)'**
  String get presetBatteryTypeLib;

  /// No description provided for @presetBatteryTypeLife.
  ///
  /// In en, this message translates to:
  /// **'LiFe'**
  String get presetBatteryTypeLife;

  /// No description provided for @signInCloud.
  ///
  /// In en, this message translates to:
  /// **'Sign in to Siseli Cloud'**
  String get signInCloud;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Check credentials.'**
  String get loginFailed;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @forecastNextDays.
  ///
  /// In en, this message translates to:
  /// **'Solar forecast for next days'**
  String get forecastNextDays;

  /// No description provided for @forecastPeak.
  ///
  /// In en, this message translates to:
  /// **'Peak'**
  String get forecastPeak;

  /// No description provided for @forecastUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Forecast data is temporarily unavailable'**
  String get forecastUnavailable;

  /// No description provided for @equipmentStatus.
  ///
  /// In en, this message translates to:
  /// **'Equipment status'**
  String get equipmentStatus;

  /// No description provided for @inverterLoad.
  ///
  /// In en, this message translates to:
  /// **'Inverter load'**
  String get inverterLoad;

  /// No description provided for @refreshChart.
  ///
  /// In en, this message translates to:
  /// **'Refresh chart'**
  String get refreshChart;

  /// No description provided for @batterySignHint.
  ///
  /// In en, this message translates to:
  /// **'Battery: \'+\' means charge, \'-\' means discharge.'**
  String get batterySignHint;

  /// No description provided for @chartNoDataTitle.
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get chartNoDataTitle;

  /// No description provided for @chartNoDataMessage.
  ///
  /// In en, this message translates to:
  /// **'The chart should load in a moment.'**
  String get chartNoDataMessage;

  /// No description provided for @lessThanMinute.
  ///
  /// In en, this message translates to:
  /// **'< 1 min'**
  String get lessThanMinute;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String minutesAgo(String count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hr ago'**
  String hoursAgo(String count);

  /// No description provided for @solar.
  ///
  /// In en, this message translates to:
  /// **'Solar'**
  String get solar;

  /// No description provided for @load.
  ///
  /// In en, this message translates to:
  /// **'Load'**
  String get load;

  /// No description provided for @connectionOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get connectionOnline;

  /// No description provided for @connectionOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get connectionOffline;

  /// No description provided for @lastRealtimeUpdate.
  ///
  /// In en, this message translates to:
  /// **'Last update'**
  String get lastRealtimeUpdate;

  /// No description provided for @dashboardAutoRefresh.
  ///
  /// In en, this message translates to:
  /// **'Data updates automatically every 60 seconds'**
  String get dashboardAutoRefresh;

  /// No description provided for @updatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated at {time}'**
  String updatedAt(String time);

  /// No description provided for @updateFailed.
  ///
  /// In en, this message translates to:
  /// **'Update failed'**
  String get updateFailed;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @updated.
  ///
  /// In en, this message translates to:
  /// **'Updated!'**
  String get updated;

  /// No description provided for @enableSolar.
  ///
  /// In en, this message translates to:
  /// **'Enable SOLAR (SBU)'**
  String get enableSolar;

  /// No description provided for @enableGrid.
  ///
  /// In en, this message translates to:
  /// **'Enable GRID (USB)'**
  String get enableGrid;

  /// No description provided for @showApp.
  ///
  /// In en, this message translates to:
  /// **'Show App'**
  String get showApp;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @batteryLevel.
  ///
  /// In en, this message translates to:
  /// **'Battery: {level}%'**
  String batteryLevel(String level);

  /// No description provided for @batteryInstallYearLabel.
  ///
  /// In en, this message translates to:
  /// **'Battery installation year'**
  String get batteryInstallYearLabel;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notificationsEmpty;

  /// No description provided for @notificationsClear.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get notificationsClear;

  /// No description provided for @notifLowBatteryTitle.
  ///
  /// In en, this message translates to:
  /// **'Low Battery'**
  String get notifLowBatteryTitle;

  /// No description provided for @notifLowBatteryBody.
  ///
  /// In en, this message translates to:
  /// **'Battery SOC is {soc}% — approaching reserve threshold'**
  String notifLowBatteryBody(String soc);

  /// No description provided for @notifBatteryRecoveredTitle.
  ///
  /// In en, this message translates to:
  /// **'Battery Charged'**
  String get notifBatteryRecoveredTitle;

  /// No description provided for @notifBatteryRecoveredBody.
  ///
  /// In en, this message translates to:
  /// **'Battery SOC recovered to {soc}%'**
  String notifBatteryRecoveredBody(String soc);

  /// No description provided for @notifAnomalyTitle.
  ///
  /// In en, this message translates to:
  /// **'High Consumption Detected'**
  String get notifAnomalyTitle;

  /// No description provided for @notifAnomalyBody.
  ///
  /// In en, this message translates to:
  /// **'Load is {load} W — {times}× above normal for this hour'**
  String notifAnomalyBody(String load, String times);

  /// No description provided for @notifCycleTitle.
  ///
  /// In en, this message translates to:
  /// **'Battery Cycle Completed'**
  String get notifCycleTitle;

  /// No description provided for @notifCycleBody.
  ///
  /// In en, this message translates to:
  /// **'Total cycles: {count}. Estimated battery health: {soh}%'**
  String notifCycleBody(String count, String soh);

  /// No description provided for @socHistoryNoData.
  ///
  /// In en, this message translates to:
  /// **'Not enough data yet.\nData is collected every 5 minutes.'**
  String get socHistoryNoData;

  /// No description provided for @acInput.
  ///
  /// In en, this message translates to:
  /// **'AC input'**
  String get acInput;

  /// No description provided for @mainSource.
  ///
  /// In en, this message translates to:
  /// **'Main source'**
  String get mainSource;

  /// No description provided for @chartFullscreen.
  ///
  /// In en, this message translates to:
  /// **'Full screen'**
  String get chartFullscreen;

  /// No description provided for @chartRotate.
  ///
  /// In en, this message translates to:
  /// **'Rotate'**
  String get chartRotate;

  /// No description provided for @forecastBasis.
  ///
  /// In en, this message translates to:
  /// **'Estimate for {kwp} kWp of panels from Open-Meteo solar radiation'**
  String forecastBasis(String kwp);

  /// No description provided for @applySafeCurrent.
  ///
  /// In en, this message translates to:
  /// **'Apply safe current'**
  String get applySafeCurrent;

  /// No description provided for @safeCurrentApplied.
  ///
  /// In en, this message translates to:
  /// **'Safe current applied: {target} A (read: {read})'**
  String safeCurrentApplied(String target, String read);

  /// No description provided for @safeCurrentFailed.
  ///
  /// In en, this message translates to:
  /// **'Safe current not confirmed. Target {target} A, read: {read}'**
  String safeCurrentFailed(String target, String read);

  /// No description provided for @invSetOutputPriority.
  ///
  /// In en, this message translates to:
  /// **'Output source priority'**
  String get invSetOutputPriority;

  /// No description provided for @invSetOutputPriorityDesc.
  ///
  /// In en, this message translates to:
  /// **'Which source powers the loads (program 01). USB: AC input first; solar and battery only when AC input is missing. SUB: solar charges the battery first, then feeds the loads; AC input covers the rest. SBU: solar first, then battery; AC input only when the battery falls to the back-to-AC point (program 12/43). Off-grid: use SBU.'**
  String get invSetOutputPriorityDesc;

  /// No description provided for @invSetChargerPriority.
  ///
  /// In en, this message translates to:
  /// **'Charger source priority'**
  String get invSetChargerPriority;

  /// No description provided for @invSetChargerPriorityDesc.
  ///
  /// In en, this message translates to:
  /// **'Which source charges the battery (program 16). CSO: solar first, AC input only when there is no sun. SNU: solar and AC input together. OSO: solar only, even when AC input is present. Without a generator on the AC input, only solar can charge.'**
  String get invSetChargerPriorityDesc;

  /// No description provided for @invSetMaxChargeCurrent.
  ///
  /// In en, this message translates to:
  /// **'Maximum charging current'**
  String get invSetMaxChargeCurrent;

  /// No description provided for @invSetMaxChargeCurrentDesc.
  ///
  /// In en, this message translates to:
  /// **'Total battery charging current, solar + AC input (program 02). It cannot be lower than the AC charging current (program 11). Stay within the battery maker\'s limit.'**
  String get invSetMaxChargeCurrentDesc;

  /// No description provided for @invSetAcChargeCurrent.
  ///
  /// In en, this message translates to:
  /// **'Maximum AC charging current'**
  String get invSetAcChargeCurrent;

  /// No description provided for @invSetAcChargeCurrentDesc.
  ///
  /// In en, this message translates to:
  /// **'Maximum current used to charge the battery from the AC input, grid or generator (program 11). Keep it low enough for the generator and the input breaker.'**
  String get invSetAcChargeCurrentDesc;

  /// No description provided for @invSetAcInputRange.
  ///
  /// In en, this message translates to:
  /// **'AC input voltage range'**
  String get invSetAcInputRange;

  /// No description provided for @invSetAcInputRangeDesc.
  ///
  /// In en, this message translates to:
  /// **'Accepted AC input voltage (program 03). APL (appliances): 90-280 V, wide range. UPS: 170-280 V, narrow range for sensitive loads. The wide range copes better with a generator whose voltage fluctuates.'**
  String get invSetAcInputRangeDesc;

  /// No description provided for @invSetBatteryType.
  ///
  /// In en, this message translates to:
  /// **'Battery type'**
  String get invSetBatteryType;

  /// No description provided for @invSetBatteryTypeDesc.
  ///
  /// In en, this message translates to:
  /// **'Battery chemistry; it sets the charge voltages (program 05). AGM and Flooded: lead-acid presets. User-defined: you set bulk, float and cut-off voltages (programs 26, 27, 29). LIB/LiFe: lithium.'**
  String get invSetBatteryTypeDesc;

  /// No description provided for @invSetOverloadRestart.
  ///
  /// In en, this message translates to:
  /// **'Auto restart after overload'**
  String get invSetOverloadRestart;

  /// No description provided for @invSetOverloadRestartDesc.
  ///
  /// In en, this message translates to:
  /// **'If enabled, the output turns back on by itself after an overload shutdown (program 06).'**
  String get invSetOverloadRestartDesc;

  /// No description provided for @invSetOverTempRestart.
  ///
  /// In en, this message translates to:
  /// **'Auto restart after over-temperature'**
  String get invSetOverTempRestart;

  /// No description provided for @invSetOverTempRestartDesc.
  ///
  /// In en, this message translates to:
  /// **'If enabled, the output turns back on by itself after an over-temperature shutdown (program 07).'**
  String get invSetOverTempRestartDesc;

  /// No description provided for @invSetOutputVoltage.
  ///
  /// In en, this message translates to:
  /// **'Output voltage'**
  String get invSetOutputVoltage;

  /// No description provided for @invSetOutputVoltageDesc.
  ///
  /// In en, this message translates to:
  /// **'AC voltage supplied to the loads (program 08). Europe: 230 V.'**
  String get invSetOutputVoltageDesc;

  /// No description provided for @invSetOutputFrequency.
  ///
  /// In en, this message translates to:
  /// **'Output frequency'**
  String get invSetOutputFrequency;

  /// No description provided for @invSetOutputFrequencyDesc.
  ///
  /// In en, this message translates to:
  /// **'AC frequency supplied to the loads (program 09). Europe: 50 Hz.'**
  String get invSetOutputFrequencyDesc;

  /// No description provided for @invSetOverloadBypass.
  ///
  /// In en, this message translates to:
  /// **'Bypass on overload'**
  String get invSetOverloadBypass;

  /// No description provided for @invSetOverloadBypassDesc.
  ///
  /// In en, this message translates to:
  /// **'If enabled, on overload in battery mode the inverter moves the loads to the AC input (program 23). It only helps when a generator is connected.'**
  String get invSetOverloadBypassDesc;

  /// No description provided for @invSetBuzzer.
  ///
  /// In en, this message translates to:
  /// **'Buzzer alarm'**
  String get invSetBuzzer;

  /// No description provided for @invSetBuzzerDesc.
  ///
  /// In en, this message translates to:
  /// **'Turns the inverter buzzer on or off for warnings and faults (program 18).'**
  String get invSetBuzzerDesc;

  /// No description provided for @invSetSourceLossBeep.
  ///
  /// In en, this message translates to:
  /// **'Beep when primary source is lost'**
  String get invSetSourceLossBeep;

  /// No description provided for @invSetSourceLossBeepDesc.
  ///
  /// In en, this message translates to:
  /// **'If enabled, the inverter beeps when the primary source chosen in program 01 is interrupted (program 22).'**
  String get invSetSourceLossBeepDesc;

  /// No description provided for @invSetReturnToDefaultScreen.
  ///
  /// In en, this message translates to:
  /// **'Return to default screen'**
  String get invSetReturnToDefaultScreen;

  /// No description provided for @invSetReturnToDefaultScreenDesc.
  ///
  /// In en, this message translates to:
  /// **'If enabled, the LCD goes back to the default screen about 1 minute after the last key press; otherwise it stays on the last screen (program 19).'**
  String get invSetReturnToDefaultScreenDesc;

  /// No description provided for @invSetBacklight.
  ///
  /// In en, this message translates to:
  /// **'LCD backlight'**
  String get invSetBacklight;

  /// No description provided for @invSetBacklightDesc.
  ///
  /// In en, this message translates to:
  /// **'Keeps the LCD backlight always on, or lets it switch off when idle (program 20).'**
  String get invSetBacklightDesc;

  /// No description provided for @invSetRecordFaults.
  ///
  /// In en, this message translates to:
  /// **'Record fault codes'**
  String get invSetRecordFaults;

  /// No description provided for @invSetRecordFaultsDesc.
  ///
  /// In en, this message translates to:
  /// **'If enabled, the inverter stores fault codes in its history (program 25).'**
  String get invSetRecordFaultsDesc;

  /// No description provided for @invSetEqualization.
  ///
  /// In en, this message translates to:
  /// **'Battery equalization'**
  String get invSetEqualization;

  /// No description provided for @invSetEqualizationDesc.
  ///
  /// In en, this message translates to:
  /// **'Periodic controlled overcharge that balances lead-acid cells (program 33). Only for Flooded or User-defined batteries; keep it off for lithium.'**
  String get invSetEqualizationDesc;

  /// No description provided for @invSetEqualizationNow.
  ///
  /// In en, this message translates to:
  /// **'Start equalization now'**
  String get invSetEqualizationNow;

  /// No description provided for @invSetEqualizationNowDesc.
  ///
  /// In en, this message translates to:
  /// **'Starts an equalization cycle right away (program 39). Works only if equalization (program 33) is enabled.'**
  String get invSetEqualizationNowDesc;

  /// No description provided for @invSetBatteryPowerLimit.
  ///
  /// In en, this message translates to:
  /// **'Battery power limiting'**
  String get invSetBatteryPowerLimit;

  /// No description provided for @invSetBatteryPowerLimitDesc.
  ///
  /// In en, this message translates to:
  /// **'Limits the power taken from the battery. Not described in the Easun manual: check the inverter documentation before changing it.'**
  String get invSetBatteryPowerLimitDesc;

  /// No description provided for @invSetSmartLoadCutOff.
  ///
  /// In en, this message translates to:
  /// **'Smart load cut-off on battery voltage'**
  String get invSetSmartLoadCutOff;

  /// No description provided for @invSetSmartLoadCutOffDesc.
  ///
  /// In en, this message translates to:
  /// **'Disconnects the smart (secondary) load output based on battery voltage. Not described in the Easun manual: check the inverter documentation before changing it.'**
  String get invSetSmartLoadCutOffDesc;

  /// No description provided for @invSetRgbLight.
  ///
  /// In en, this message translates to:
  /// **'RGB light'**
  String get invSetRgbLight;

  /// No description provided for @invSetRgbLightDesc.
  ///
  /// In en, this message translates to:
  /// **'Turns the inverter RGB status light on or off.'**
  String get invSetRgbLightDesc;

  /// No description provided for @rdDualOutputVoltageSwitch.
  ///
  /// In en, this message translates to:
  /// **'Dual output'**
  String get rdDualOutputVoltageSwitch;

  /// No description provided for @rdDualOutputVoltageSwitchDesc.
  ///
  /// In en, this message translates to:
  /// **'Second AC output for non-essential loads; it is switched off when the battery drops to the turn-off voltage.'**
  String get rdDualOutputVoltageSwitchDesc;

  /// No description provided for @rdAcInputFrequency.
  ///
  /// In en, this message translates to:
  /// **'AC input frequency'**
  String get rdAcInputFrequency;

  /// No description provided for @rdAcInputFrequencyDesc.
  ///
  /// In en, this message translates to:
  /// **'Frequency on the AC input (grid or generator). 0 Hz means nothing is connected.'**
  String get rdAcInputFrequencyDesc;

  /// No description provided for @rdLedPatternLight1.
  ///
  /// In en, this message translates to:
  /// **'LED lights'**
  String get rdLedPatternLight1;

  /// No description provided for @rdLedPatternLight1Desc.
  ///
  /// In en, this message translates to:
  /// **'State of the inverter status LED lights.'**
  String get rdLedPatternLight1Desc;

  /// No description provided for @rdBatteryNumber.
  ///
  /// In en, this message translates to:
  /// **'Battery system voltage'**
  String get rdBatteryNumber;

  /// No description provided for @rdBatteryNumberDesc.
  ///
  /// In en, this message translates to:
  /// **'Battery bank voltage class the inverter is built for.'**
  String get rdBatteryNumberDesc;

  /// No description provided for @rdAcInputVoltage.
  ///
  /// In en, this message translates to:
  /// **'AC input voltage'**
  String get rdAcInputVoltage;

  /// No description provided for @rdAcInputVoltageDesc.
  ///
  /// In en, this message translates to:
  /// **'Voltage on the AC input. 0 V means no grid or generator is connected.'**
  String get rdAcInputVoltageDesc;

  /// No description provided for @rdWorkingStates.
  ///
  /// In en, this message translates to:
  /// **'Working state'**
  String get rdWorkingStates;

  /// No description provided for @rdWorkingStatesDesc.
  ///
  /// In en, this message translates to:
  /// **'Current inverter mode: Invert (loads from battery/solar), Line (loads from the AC input), Standby or Fault.'**
  String get rdWorkingStatesDesc;

  /// No description provided for @rdAcOutputActivePower.
  ///
  /// In en, this message translates to:
  /// **'Output active power'**
  String get rdAcOutputActivePower;

  /// No description provided for @rdAcOutputActivePowerDesc.
  ///
  /// In en, this message translates to:
  /// **'Real power the loads are using now.'**
  String get rdAcOutputActivePowerDesc;

  /// No description provided for @rdBatteryEqualizationMode.
  ///
  /// In en, this message translates to:
  /// **'Battery equalization'**
  String get rdBatteryEqualizationMode;

  /// No description provided for @rdBatteryEqualizationModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Whether periodic equalization is enabled (program 33). Lead-acid batteries only.'**
  String get rdBatteryEqualizationModeDesc;

  /// No description provided for @rdGridConnectedSwitch1.
  ///
  /// In en, this message translates to:
  /// **'Grid feed-in'**
  String get rdGridConnectedSwitch1;

  /// No description provided for @rdGridConnectedSwitch1Desc.
  ///
  /// In en, this message translates to:
  /// **'Whether the inverter may feed power into the grid. Off-grid: keep it off.'**
  String get rdGridConnectedSwitch1Desc;

  /// No description provided for @rdGenerationPower.
  ///
  /// In en, this message translates to:
  /// **'Generation power'**
  String get rdGenerationPower;

  /// No description provided for @rdGenerationPowerDesc.
  ///
  /// In en, this message translates to:
  /// **'Power the solar panels are producing now.'**
  String get rdGenerationPowerDesc;

  /// No description provided for @rdRatingOutputCurrent.
  ///
  /// In en, this message translates to:
  /// **'Nominal output current'**
  String get rdRatingOutputCurrent;

  /// No description provided for @rdRatingOutputCurrentDesc.
  ///
  /// In en, this message translates to:
  /// **'Maximum continuous AC output current of the inverter (rating plate value).'**
  String get rdRatingOutputCurrentDesc;

  /// No description provided for @rdLowBatteryCutOffVoltage.
  ///
  /// In en, this message translates to:
  /// **'Low battery cut-off voltage'**
  String get rdLowBatteryCutOffVoltage;

  /// No description provided for @rdLowBatteryCutOffVoltageDesc.
  ///
  /// In en, this message translates to:
  /// **'Below this voltage the inverter turns the output off to protect the battery (program 29).'**
  String get rdLowBatteryCutOffVoltageDesc;

  /// No description provided for @rdBatteryCapacity.
  ///
  /// In en, this message translates to:
  /// **'Battery charge (SOC)'**
  String get rdBatteryCapacity;

  /// No description provided for @rdBatteryCapacityDesc.
  ///
  /// In en, this message translates to:
  /// **'State of charge reported by the inverter.'**
  String get rdBatteryCapacityDesc;

  /// No description provided for @rdStartBalancing.
  ///
  /// In en, this message translates to:
  /// **'Start equalization now'**
  String get rdStartBalancing;

  /// No description provided for @rdStartBalancingDesc.
  ///
  /// In en, this message translates to:
  /// **'Whether an immediate equalization cycle is requested (program 39).'**
  String get rdStartBalancingDesc;

  /// No description provided for @rdBatteryDischargeCurrent.
  ///
  /// In en, this message translates to:
  /// **'Battery discharge current'**
  String get rdBatteryDischargeCurrent;

  /// No description provided for @rdBatteryDischargeCurrentDesc.
  ///
  /// In en, this message translates to:
  /// **'Current flowing out of the battery now.'**
  String get rdBatteryDischargeCurrentDesc;

  /// No description provided for @rdGridConnectedCurrent.
  ///
  /// In en, this message translates to:
  /// **'Grid feed-in current'**
  String get rdGridConnectedCurrent;

  /// No description provided for @rdGridConnectedCurrentDesc.
  ///
  /// In en, this message translates to:
  /// **'Maximum current fed into the grid when feed-in is on. Not used off-grid.'**
  String get rdGridConnectedCurrentDesc;

  /// No description provided for @rdRatedBatteryVoltage.
  ///
  /// In en, this message translates to:
  /// **'Nominal battery voltage'**
  String get rdRatedBatteryVoltage;

  /// No description provided for @rdRatedBatteryVoltageDesc.
  ///
  /// In en, this message translates to:
  /// **'Rated voltage of the battery bank.'**
  String get rdRatedBatteryVoltageDesc;

  /// No description provided for @rdOutputApparentPower.
  ///
  /// In en, this message translates to:
  /// **'Output apparent power'**
  String get rdOutputApparentPower;

  /// No description provided for @rdOutputApparentPowerDesc.
  ///
  /// In en, this message translates to:
  /// **'Apparent power (VA) drawn by the loads, reactive part included: it is what the inverter has to supply.'**
  String get rdOutputApparentPowerDesc;

  /// No description provided for @rdDualOutputTurnOffVoltage.
  ///
  /// In en, this message translates to:
  /// **'Dual output turn-off voltage'**
  String get rdDualOutputTurnOffVoltage;

  /// No description provided for @rdDualOutputTurnOffVoltageDesc.
  ///
  /// In en, this message translates to:
  /// **'Battery voltage at which the second output is switched off.'**
  String get rdDualOutputTurnOffVoltageDesc;

  /// No description provided for @rdMainCPUVersion1.
  ///
  /// In en, this message translates to:
  /// **'Main CPU firmware'**
  String get rdMainCPUVersion1;

  /// No description provided for @rdMainCPUVersion1Desc.
  ///
  /// In en, this message translates to:
  /// **'Firmware version of the inverter main processor.'**
  String get rdMainCPUVersion1Desc;

  /// No description provided for @rdChargerSourcePriority.
  ///
  /// In en, this message translates to:
  /// **'Charger source priority'**
  String get rdChargerSourcePriority;

  /// No description provided for @rdChargerSourcePriorityDesc.
  ///
  /// In en, this message translates to:
  /// **'Current charger priority (program 16). CSO: solar first. SNU: solar + AC input. OSO: solar only.'**
  String get rdChargerSourcePriorityDesc;

  /// No description provided for @rdComebackUtilityModeVolSBUPriorityStatus.
  ///
  /// In en, this message translates to:
  /// **'Back-to-AC voltage (SBU)'**
  String get rdComebackUtilityModeVolSBUPriorityStatus;

  /// No description provided for @rdComebackUtilityModeVolSBUPriorityStatusDesc.
  ///
  /// In en, this message translates to:
  /// **'With SBU or solar first, below this battery voltage the loads move to the AC input (program 12). Without a generator it has no effect.'**
  String get rdComebackUtilityModeVolSBUPriorityStatusDesc;

  /// No description provided for @rdNominalAcVoltage.
  ///
  /// In en, this message translates to:
  /// **'Nominal AC voltage'**
  String get rdNominalAcVoltage;

  /// No description provided for @rdNominalAcVoltageDesc.
  ///
  /// In en, this message translates to:
  /// **'Rated AC voltage of the inverter.'**
  String get rdNominalAcVoltageDesc;

  /// No description provided for @rdNominalAcCurrent.
  ///
  /// In en, this message translates to:
  /// **'Nominal AC current'**
  String get rdNominalAcCurrent;

  /// No description provided for @rdNominalAcCurrentDesc.
  ///
  /// In en, this message translates to:
  /// **'Rated AC current of the inverter.'**
  String get rdNominalAcCurrentDesc;

  /// No description provided for @rdOutputRelayStatus.
  ///
  /// In en, this message translates to:
  /// **'Output relay'**
  String get rdOutputRelayStatus;

  /// No description provided for @rdOutputRelayStatusDesc.
  ///
  /// In en, this message translates to:
  /// **'ON means the AC output is powered.'**
  String get rdOutputRelayStatusDesc;

  /// No description provided for @rdPhotovoltaicAccessFlag.
  ///
  /// In en, this message translates to:
  /// **'PV connection'**
  String get rdPhotovoltaicAccessFlag;

  /// No description provided for @rdPhotovoltaicAccessFlagDesc.
  ///
  /// In en, this message translates to:
  /// **'Whether the inverter detects the solar panels.'**
  String get rdPhotovoltaicAccessFlagDesc;

  /// No description provided for @rdPvStatuss.
  ///
  /// In en, this message translates to:
  /// **'PV status'**
  String get rdPvStatuss;

  /// No description provided for @rdPvStatussDesc.
  ///
  /// In en, this message translates to:
  /// **'Working state of the solar input (MPPT charger).'**
  String get rdPvStatussDesc;

  /// No description provided for @rdRatedOutputFrequency.
  ///
  /// In en, this message translates to:
  /// **'Nominal output frequency'**
  String get rdRatedOutputFrequency;

  /// No description provided for @rdRatedOutputFrequencyDesc.
  ///
  /// In en, this message translates to:
  /// **'Output frequency set on the inverter (program 09).'**
  String get rdRatedOutputFrequencyDesc;

  /// No description provided for @rdRatedOutputVoltage.
  ///
  /// In en, this message translates to:
  /// **'Nominal output voltage'**
  String get rdRatedOutputVoltage;

  /// No description provided for @rdRatedOutputVoltageDesc.
  ///
  /// In en, this message translates to:
  /// **'Output voltage set on the inverter (program 08).'**
  String get rdRatedOutputVoltageDesc;

  /// No description provided for @rdGridState.
  ///
  /// In en, this message translates to:
  /// **'AC input state'**
  String get rdGridState;

  /// No description provided for @rdGridStateDesc.
  ///
  /// In en, this message translates to:
  /// **'Whether the AC input (grid or generator) is connected.'**
  String get rdGridStateDesc;

  /// No description provided for @rdBatteryEqualizationInterval.
  ///
  /// In en, this message translates to:
  /// **'Equalization interval'**
  String get rdBatteryEqualizationInterval;

  /// No description provided for @rdBatteryEqualizationIntervalDesc.
  ///
  /// In en, this message translates to:
  /// **'Days between two equalization cycles (program 37).'**
  String get rdBatteryEqualizationIntervalDesc;

  /// No description provided for @rdLoadPercentage.
  ///
  /// In en, this message translates to:
  /// **'Load percentage'**
  String get rdLoadPercentage;

  /// No description provided for @rdLoadPercentageDesc.
  ///
  /// In en, this message translates to:
  /// **'Output load as a share of the inverter rated power.'**
  String get rdLoadPercentageDesc;

  /// No description provided for @rdComebackBatteryModeVolSBUPriorityStatus.
  ///
  /// In en, this message translates to:
  /// **'Back-to-battery voltage (SBU)'**
  String get rdComebackBatteryModeVolSBUPriorityStatus;

  /// No description provided for @rdComebackBatteryModeVolSBUPriorityStatusDesc.
  ///
  /// In en, this message translates to:
  /// **'With SBU or solar first, above this battery voltage the loads go back to the battery (program 13).'**
  String get rdComebackBatteryModeVolSBUPriorityStatusDesc;

  /// No description provided for @rdPvInputPower.
  ///
  /// In en, this message translates to:
  /// **'PV input power'**
  String get rdPvInputPower;

  /// No description provided for @rdPvInputPowerDesc.
  ///
  /// In en, this message translates to:
  /// **'Power entering from the solar panels into the MPPT charger.'**
  String get rdPvInputPowerDesc;

  /// No description provided for @rdMaxTotalChargeCurrent1.
  ///
  /// In en, this message translates to:
  /// **'Max total charge current'**
  String get rdMaxTotalChargeCurrent1;

  /// No description provided for @rdMaxTotalChargeCurrent1Desc.
  ///
  /// In en, this message translates to:
  /// **'Total charging limit, solar + AC input (program 02).'**
  String get rdMaxTotalChargeCurrent1Desc;

  /// No description provided for @rdBatState.
  ///
  /// In en, this message translates to:
  /// **'Battery state'**
  String get rdBatState;

  /// No description provided for @rdBatStateDesc.
  ///
  /// In en, this message translates to:
  /// **'Whether the battery is charging, discharging or idle.'**
  String get rdBatStateDesc;

  /// No description provided for @rdOutputSourcePriority.
  ///
  /// In en, this message translates to:
  /// **'Output source priority'**
  String get rdOutputSourcePriority;

  /// No description provided for @rdOutputSourcePriorityDesc.
  ///
  /// In en, this message translates to:
  /// **'Current output priority (program 01). USB: AC input first. SUB: solar charges first, AC covers the rest. SBU: solar, then battery, then AC.'**
  String get rdOutputSourcePriorityDesc;

  /// No description provided for @rdFloatChargingVoltage.
  ///
  /// In en, this message translates to:
  /// **'Float charging voltage'**
  String get rdFloatChargingVoltage;

  /// No description provided for @rdFloatChargingVoltageDesc.
  ///
  /// In en, this message translates to:
  /// **'Voltage held once the battery is full (program 27).'**
  String get rdFloatChargingVoltageDesc;

  /// No description provided for @rdBatteryChargingCurrent.
  ///
  /// In en, this message translates to:
  /// **'Battery charging current'**
  String get rdBatteryChargingCurrent;

  /// No description provided for @rdBatteryChargingCurrentDesc.
  ///
  /// In en, this message translates to:
  /// **'Current flowing into the battery now.'**
  String get rdBatteryChargingCurrentDesc;

  /// No description provided for @rdAcOutputRatingApparentPower.
  ///
  /// In en, this message translates to:
  /// **'Nominal apparent power'**
  String get rdAcOutputRatingApparentPower;

  /// No description provided for @rdAcOutputRatingApparentPowerDesc.
  ///
  /// In en, this message translates to:
  /// **'Rated output power of the inverter in VA.'**
  String get rdAcOutputRatingApparentPowerDesc;

  /// No description provided for @rdLoadStatus.
  ///
  /// In en, this message translates to:
  /// **'Load status'**
  String get rdLoadStatus;

  /// No description provided for @rdLoadStatusDesc.
  ///
  /// In en, this message translates to:
  /// **'Whether the output load is normal or overloaded.'**
  String get rdLoadStatusDesc;

  /// No description provided for @rdBatteryEqualizationVoltage.
  ///
  /// In en, this message translates to:
  /// **'Equalization voltage'**
  String get rdBatteryEqualizationVoltage;

  /// No description provided for @rdBatteryEqualizationVoltageDesc.
  ///
  /// In en, this message translates to:
  /// **'Charging voltage used during equalization (program 34).'**
  String get rdBatteryEqualizationVoltageDesc;

  /// No description provided for @rdBatteryVoltage.
  ///
  /// In en, this message translates to:
  /// **'Battery voltage'**
  String get rdBatteryVoltage;

  /// No description provided for @rdBatteryVoltageDesc.
  ///
  /// In en, this message translates to:
  /// **'Battery voltage measured now.'**
  String get rdBatteryVoltageDesc;

  /// No description provided for @rdOutputVoltage.
  ///
  /// In en, this message translates to:
  /// **'Output voltage'**
  String get rdOutputVoltage;

  /// No description provided for @rdOutputVoltageDesc.
  ///
  /// In en, this message translates to:
  /// **'AC voltage on the output now.'**
  String get rdOutputVoltageDesc;

  /// No description provided for @rdBulkChargingVoltage.
  ///
  /// In en, this message translates to:
  /// **'Bulk charging voltage'**
  String get rdBulkChargingVoltage;

  /// No description provided for @rdBulkChargingVoltageDesc.
  ///
  /// In en, this message translates to:
  /// **'Constant-voltage charging target (program 26).'**
  String get rdBulkChargingVoltageDesc;

  /// No description provided for @rdBatteryEqualizationTimeout.
  ///
  /// In en, this message translates to:
  /// **'Equalization timeout'**
  String get rdBatteryEqualizationTimeout;

  /// No description provided for @rdBatteryEqualizationTimeoutDesc.
  ///
  /// In en, this message translates to:
  /// **'Maximum extra time allowed for an equalization cycle (program 36).'**
  String get rdBatteryEqualizationTimeoutDesc;

  /// No description provided for @rdFeedInPower.
  ///
  /// In en, this message translates to:
  /// **'Feed-in power'**
  String get rdFeedInPower;

  /// No description provided for @rdFeedInPowerDesc.
  ///
  /// In en, this message translates to:
  /// **'Power sent to the grid. Off-grid it stays at 0.'**
  String get rdFeedInPowerDesc;

  /// No description provided for @rdNtcMaximumTemperature.
  ///
  /// In en, this message translates to:
  /// **'Max internal temperature'**
  String get rdNtcMaximumTemperature;

  /// No description provided for @rdNtcMaximumTemperatureDesc.
  ///
  /// In en, this message translates to:
  /// **'Highest temperature measured by the inverter internal sensors (NTC).'**
  String get rdNtcMaximumTemperatureDesc;

  /// No description provided for @rdMainsRelayStatus.
  ///
  /// In en, this message translates to:
  /// **'AC input relay'**
  String get rdMainsRelayStatus;

  /// No description provided for @rdMainsRelayStatusDesc.
  ///
  /// In en, this message translates to:
  /// **'ON means loads or charger are connected to the AC input.'**
  String get rdMainsRelayStatusDesc;

  /// No description provided for @rdBatteryRatingVoltage.
  ///
  /// In en, this message translates to:
  /// **'Rated voltage'**
  String get rdBatteryRatingVoltage;

  /// No description provided for @rdBatteryRatingVoltageDesc.
  ///
  /// In en, this message translates to:
  /// **'Rated voltage reported by the inverter.'**
  String get rdBatteryRatingVoltageDesc;

  /// No description provided for @rdRatedActivePower.
  ///
  /// In en, this message translates to:
  /// **'Nominal active power'**
  String get rdRatedActivePower;

  /// No description provided for @rdRatedActivePowerDesc.
  ///
  /// In en, this message translates to:
  /// **'Rated continuous output power of the inverter in W.'**
  String get rdRatedActivePowerDesc;

  /// No description provided for @rdPvInputVoltage.
  ///
  /// In en, this message translates to:
  /// **'PV input voltage'**
  String get rdPvInputVoltage;

  /// No description provided for @rdPvInputVoltageDesc.
  ///
  /// In en, this message translates to:
  /// **'Voltage of the solar string; it must stay inside the MPPT voltage range.'**
  String get rdPvInputVoltageDesc;

  /// No description provided for @rdMainsInputRange.
  ///
  /// In en, this message translates to:
  /// **'AC input range'**
  String get rdMainsInputRange;

  /// No description provided for @rdMainsInputRangeDesc.
  ///
  /// In en, this message translates to:
  /// **'Accepted AC input voltage range (program 03). APL: 90-280 V. UPS: 170-280 V.'**
  String get rdMainsInputRangeDesc;

  /// No description provided for @rdOutputFrequency.
  ///
  /// In en, this message translates to:
  /// **'Output frequency'**
  String get rdOutputFrequency;

  /// No description provided for @rdOutputFrequencyDesc.
  ///
  /// In en, this message translates to:
  /// **'AC frequency measured on the output.'**
  String get rdOutputFrequencyDesc;

  /// No description provided for @rdBatteryEqualizationTime.
  ///
  /// In en, this message translates to:
  /// **'Equalization time'**
  String get rdBatteryEqualizationTime;

  /// No description provided for @rdBatteryEqualizationTimeDesc.
  ///
  /// In en, this message translates to:
  /// **'Duration of an equalization cycle (program 35).'**
  String get rdBatteryEqualizationTimeDesc;

  /// No description provided for @rdBatteryType.
  ///
  /// In en, this message translates to:
  /// **'Battery type'**
  String get rdBatteryType;

  /// No description provided for @rdBatteryTypeDesc.
  ///
  /// In en, this message translates to:
  /// **'Battery type set on the inverter (program 05).'**
  String get rdBatteryTypeDesc;

  /// No description provided for @rdMaxUtilityChargeCurrent1.
  ///
  /// In en, this message translates to:
  /// **'AC charging current'**
  String get rdMaxUtilityChargeCurrent1;

  /// No description provided for @rdMaxUtilityChargeCurrent1Desc.
  ///
  /// In en, this message translates to:
  /// **'Maximum current for charging from the AC input (program 11).'**
  String get rdMaxUtilityChargeCurrent1Desc;

  /// No description provided for @rdValOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get rdValOn;

  /// No description provided for @rdValOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get rdValOff;

  /// No description provided for @rdValEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get rdValEnabled;

  /// No description provided for @rdValDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get rdValDisabled;

  /// No description provided for @rdValCharging.
  ///
  /// In en, this message translates to:
  /// **'Charging'**
  String get rdValCharging;

  /// No description provided for @rdValDischarging.
  ///
  /// In en, this message translates to:
  /// **'Discharging'**
  String get rdValDischarging;

  /// No description provided for @rdValInvertMode.
  ///
  /// In en, this message translates to:
  /// **'Inverter mode'**
  String get rdValInvertMode;

  /// No description provided for @rdValLineMode.
  ///
  /// In en, this message translates to:
  /// **'Line mode'**
  String get rdValLineMode;

  /// No description provided for @rdValStandbyMode.
  ///
  /// In en, this message translates to:
  /// **'Standby'**
  String get rdValStandbyMode;

  /// No description provided for @rdValFaultMode.
  ///
  /// In en, this message translates to:
  /// **'Fault'**
  String get rdValFaultMode;

  /// No description provided for @rdValAcNotConnected.
  ///
  /// In en, this message translates to:
  /// **'AC input not connected'**
  String get rdValAcNotConnected;

  /// No description provided for @rdValAcConnected.
  ///
  /// In en, this message translates to:
  /// **'AC input connected'**
  String get rdValAcConnected;

  /// No description provided for @rdValNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get rdValNormal;

  /// No description provided for @rdValPvWorking.
  ///
  /// In en, this message translates to:
  /// **'Connected and working'**
  String get rdValPvWorking;

  /// No description provided for @rdValPvConnected.
  ///
  /// In en, this message translates to:
  /// **'Panels connected'**
  String get rdValPvConnected;

  /// No description provided for @invSetBackToAcVoltage.
  ///
  /// In en, this message translates to:
  /// **'Back-to-AC voltage (SBU)'**
  String get invSetBackToAcVoltage;

  /// No description provided for @invSetBackToAcVoltageDesc.
  ///
  /// In en, this message translates to:
  /// **'With SBU or solar first in program 01, below this battery voltage the loads move to the AC input (program 12). It must be lower than the back-to-battery voltage. Without a generator it has no effect.'**
  String get invSetBackToAcVoltageDesc;

  /// No description provided for @invSetBackToBatteryVoltage.
  ///
  /// In en, this message translates to:
  /// **'Back-to-battery voltage (SBU)'**
  String get invSetBackToBatteryVoltage;

  /// No description provided for @invSetBackToBatteryVoltageDesc.
  ///
  /// In en, this message translates to:
  /// **'With SBU or solar first, once the battery is back above this voltage the loads return to battery power (program 13). It must be higher than the back-to-AC voltage.'**
  String get invSetBackToBatteryVoltageDesc;

  /// No description provided for @invSetBulkVoltage.
  ///
  /// In en, this message translates to:
  /// **'Bulk charging voltage (C.V.)'**
  String get invSetBulkVoltage;

  /// No description provided for @invSetBulkVoltageDesc.
  ///
  /// In en, this message translates to:
  /// **'Constant-voltage charging target (program 26). Editable only with a User-defined battery; it must be at least the float voltage. Follow the battery maker\'s values.'**
  String get invSetBulkVoltageDesc;

  /// No description provided for @invSetFloatVoltage.
  ///
  /// In en, this message translates to:
  /// **'Float charging voltage'**
  String get invSetFloatVoltage;

  /// No description provided for @invSetFloatVoltageDesc.
  ///
  /// In en, this message translates to:
  /// **'Voltage held once the battery is full (program 27). Editable only with a User-defined battery; it cannot exceed the bulk voltage.'**
  String get invSetFloatVoltageDesc;

  /// No description provided for @invSetLowCutOffVoltage.
  ///
  /// In en, this message translates to:
  /// **'Low DC cut-off voltage'**
  String get invSetLowCutOffVoltage;

  /// No description provided for @invSetLowCutOffVoltageDesc.
  ///
  /// In en, this message translates to:
  /// **'Below this battery voltage the inverter turns the output off to protect the battery (program 29). It must be lower than the back-to-AC voltage.'**
  String get invSetLowCutOffVoltageDesc;

  /// No description provided for @invSetLowCutOffSoc.
  ///
  /// In en, this message translates to:
  /// **'Low DC cut-off SOC'**
  String get invSetLowCutOffSoc;

  /// No description provided for @invSetLowCutOffSocDesc.
  ///
  /// In en, this message translates to:
  /// **'With a lithium battery that talks to the inverter: below this state of charge the output turns off (program 45, default 20%, range 3-30%).'**
  String get invSetLowCutOffSocDesc;

  /// No description provided for @invSetEqVoltage.
  ///
  /// In en, this message translates to:
  /// **'Equalization voltage'**
  String get invSetEqVoltage;

  /// No description provided for @invSetEqVoltageDesc.
  ///
  /// In en, this message translates to:
  /// **'Charging voltage used during equalization (program 34). Lead-acid only.'**
  String get invSetEqVoltageDesc;

  /// No description provided for @invSetEqTime.
  ///
  /// In en, this message translates to:
  /// **'Equalization time'**
  String get invSetEqTime;

  /// No description provided for @invSetEqTimeDesc.
  ///
  /// In en, this message translates to:
  /// **'How long the equalization voltage is held (program 35, 0-900 min).'**
  String get invSetEqTimeDesc;

  /// No description provided for @invSetEqTimeout.
  ///
  /// In en, this message translates to:
  /// **'Equalization timeout'**
  String get invSetEqTimeout;

  /// No description provided for @invSetEqTimeoutDesc.
  ///
  /// In en, this message translates to:
  /// **'Extra time allowed if the equalization voltage is not reached (program 36, 0-900 min).'**
  String get invSetEqTimeoutDesc;

  /// No description provided for @invSetEqInterval.
  ///
  /// In en, this message translates to:
  /// **'Equalization interval'**
  String get invSetEqInterval;

  /// No description provided for @invSetEqIntervalDesc.
  ///
  /// In en, this message translates to:
  /// **'Days between two equalization cycles (program 37, 1-90 days).'**
  String get invSetEqIntervalDesc;

  /// No description provided for @invSetOutputDelay.
  ///
  /// In en, this message translates to:
  /// **'Output delay'**
  String get invSetOutputDelay;

  /// No description provided for @invSetOutputDelayDesc.
  ///
  /// In en, this message translates to:
  /// **'Delay before the AC output turns on. Not described in the Easun manual: check the inverter documentation before changing it.'**
  String get invSetOutputDelayDesc;

  /// No description provided for @socDayChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Battery charge (SOC) during the day'**
  String get socDayChartTitle;

  /// No description provided for @batteryDurationForecast.
  ///
  /// In en, this message translates to:
  /// **'Battery duration forecast: until {time} on {date}'**
  String batteryDurationForecast(Object time, Object date);

  /// No description provided for @flowLosses.
  ///
  /// In en, this message translates to:
  /// **'Losses'**
  String get flowLosses;

  /// No description provided for @flowLossesHint.
  ///
  /// In en, this message translates to:
  /// **'Power coming in (solar, AC input, battery) that does not reach the loads or the battery: inverter self-consumption and conversion losses.'**
  String get flowLossesHint;

  /// No description provided for @flowMismatch.
  ///
  /// In en, this message translates to:
  /// **'Reading mismatch'**
  String get flowMismatch;

  /// No description provided for @flowMismatchHint.
  ///
  /// In en, this message translates to:
  /// **'More power goes out than the readings show coming in: the values were sampled at slightly different moments.'**
  String get flowMismatchHint;

  /// No description provided for @batteryChargedTotal.
  ///
  /// In en, this message translates to:
  /// **'Battery charged'**
  String get batteryChargedTotal;

  /// No description provided for @batteryDischargedTotal.
  ///
  /// In en, this message translates to:
  /// **'Battery discharged'**
  String get batteryDischargedTotal;

  /// No description provided for @flowInverter.
  ///
  /// In en, this message translates to:
  /// **'Inverter'**
  String get flowInverter;

  /// No description provided for @flowPower.
  ///
  /// In en, this message translates to:
  /// **'Power'**
  String get flowPower;

  /// No description provided for @rdValPvNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Panels not connected'**
  String get rdValPvNotConnected;

  /// No description provided for @rdValPvLowVoltage.
  ///
  /// In en, this message translates to:
  /// **'Not connected: voltage below the minimum'**
  String get rdValPvLowVoltage;

  /// No description provided for @rdValPowerOnMode.
  ///
  /// In en, this message translates to:
  /// **'Starting up'**
  String get rdValPowerOnMode;

  /// No description provided for @rdValPowerSavingMode.
  ///
  /// In en, this message translates to:
  /// **'Power saving'**
  String get rdValPowerSavingMode;

  /// No description provided for @rdValBypassMode.
  ///
  /// In en, this message translates to:
  /// **'Bypass'**
  String get rdValBypassMode;

  /// No description provided for @rdValShutdownMode.
  ///
  /// In en, this message translates to:
  /// **'Shut down'**
  String get rdValShutdownMode;

  /// No description provided for @rdValIdle.
  ///
  /// In en, this message translates to:
  /// **'Idle'**
  String get rdValIdle;

  /// No description provided for @rdValOverload.
  ///
  /// In en, this message translates to:
  /// **'Overload'**
  String get rdValOverload;

  /// No description provided for @rdValNoLoad.
  ///
  /// In en, this message translates to:
  /// **'No load'**
  String get rdValNoLoad;

  /// No description provided for @inverterSelfUseLabel.
  ///
  /// In en, this message translates to:
  /// **'Inverter self-consumption'**
  String get inverterSelfUseLabel;

  /// No description provided for @inverterSelfUseHint.
  ///
  /// In en, this message translates to:
  /// **'Power the inverter uses for itself. The cloud sends battery current in whole amps, so below 3 A the battery power is estimated as solar − consumption − this value.'**
  String get inverterSelfUseHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
