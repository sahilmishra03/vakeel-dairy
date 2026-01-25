import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
    Locale('hi'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Vakeel Diary'**
  String get appTitle;

  /// Subtitle for the application
  ///
  /// In en, this message translates to:
  /// **'Advocate Portal'**
  String get advocatePortal;

  /// Navigation tab label for Home
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Navigation tab label for Cases
  ///
  /// In en, this message translates to:
  /// **'Cases'**
  String get cases;

  /// Navigation tab label for Settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Section header for export options
  ///
  /// In en, this message translates to:
  /// **'Reports & Data'**
  String get reportsAndData;

  /// Button to export today's cases
  ///
  /// In en, this message translates to:
  /// **'Export Today\'s Cases'**
  String get exportTodayCases;

  /// Subtitle for export today's cases button
  ///
  /// In en, this message translates to:
  /// **'Generate PDF of today\'s hearings'**
  String get exportTodayCasesSubtitle;

  /// Button to export all cases
  ///
  /// In en, this message translates to:
  /// **'Export All Cases'**
  String get exportAllCases;

  /// Subtitle for export all cases button
  ///
  /// In en, this message translates to:
  /// **'Generate complete case database PDF'**
  String get exportAllCasesSubtitle;

  /// Section header for app preferences
  ///
  /// In en, this message translates to:
  /// **'App Preferences'**
  String get appPreferences;

  /// Label for dark mode toggle
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Label for language selection
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Hindi language option
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// Loading message during PDF generation
  ///
  /// In en, this message translates to:
  /// **'Generating PDF...'**
  String get generatingPdf;

  /// Error dialog title for failed export
  ///
  /// In en, this message translates to:
  /// **'Export Failed'**
  String get exportFailed;

  /// Dialog title when no data is available
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get noData;

  /// Message when no cases are scheduled for today
  ///
  /// In en, this message translates to:
  /// **'No cases scheduled for today'**
  String get noTodayCases;

  /// Message when no cases are found in database
  ///
  /// In en, this message translates to:
  /// **'No cases found in the database'**
  String get noCasesFound;

  /// OK button label
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// PDF report title for today's cases
  ///
  /// In en, this message translates to:
  /// **'Today\'s Cases Report'**
  String get todayCasesReport;

  /// PDF report title for all cases
  ///
  /// In en, this message translates to:
  /// **'All Cases Report'**
  String get allCasesReport;

  /// Total cases count with placeholder
  ///
  /// In en, this message translates to:
  /// **'Total Cases: {count}'**
  String totalCases(int count);

  /// Generation timestamp with placeholder
  ///
  /// In en, this message translates to:
  /// **'Generated: {timestamp}'**
  String generated(String timestamp);

  /// Table header for case number
  ///
  /// In en, this message translates to:
  /// **'Case No.'**
  String get caseNumber;

  /// Table header for client name
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get client;

  /// Table header for court name
  ///
  /// In en, this message translates to:
  /// **'Court'**
  String get court;

  /// Table header for next hearing date
  ///
  /// In en, this message translates to:
  /// **'Next Hearing'**
  String get nextHearing;

  /// Table header for case status
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Case status - Active
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// Case status - Closed
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// Footer text in PDF reports
  ///
  /// In en, this message translates to:
  /// **'Vakeel Diary - Legal Case Management System'**
  String get vakeelDiaryFooter;

  /// Button to add new case
  ///
  /// In en, this message translates to:
  /// **'Add Case'**
  String get addCase;

  /// Section header for today's hearings
  ///
  /// In en, this message translates to:
  /// **'Today\'s Hearings'**
  String get todaysHearings;

  /// Label for active cases count
  ///
  /// In en, this message translates to:
  /// **'Active Cases'**
  String get activeCases;

  /// Button to view all cases
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// Message when no hearings are scheduled for today
  ///
  /// In en, this message translates to:
  /// **'No hearings scheduled for today'**
  String get noHearingsToday;

  /// Text for scheduled today count
  ///
  /// In en, this message translates to:
  /// **'scheduled today'**
  String get scheduledToday;

  /// Title for case details screen
  ///
  /// In en, this message translates to:
  /// **'Case Details'**
  String get caseDetails;

  /// Button to edit case
  ///
  /// In en, this message translates to:
  /// **'Edit Case'**
  String get editCase;

  /// Button to delete case
  ///
  /// In en, this message translates to:
  /// **'Delete Case'**
  String get deleteCase;

  /// Title for delete case confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Case?'**
  String get deleteCaseTitle;

  /// Message for delete case confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteCaseMessage;

  /// Hint text for case number field
  ///
  /// In en, this message translates to:
  /// **'Enter case number'**
  String get caseNumberHint;

  /// Hint text for client name field
  ///
  /// In en, this message translates to:
  /// **'Enter client name'**
  String get clientNameHint;

  /// Hint text for court name field
  ///
  /// In en, this message translates to:
  /// **'Enter court name'**
  String get courtNameHint;

  /// Hint text for next hearing date field
  ///
  /// In en, this message translates to:
  /// **'Select next hearing date'**
  String get nextHearingHint;

  /// Hint text for case status field
  ///
  /// In en, this message translates to:
  /// **'Select case status'**
  String get caseStatusHint;

  /// Save button label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Delete button label
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Confirmation message for case deletion
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this case?'**
  String get confirmDelete;

  /// Screen title for all cases view
  ///
  /// In en, this message translates to:
  /// **'All Cases'**
  String get allCases;

  /// Hint text for search field
  ///
  /// In en, this message translates to:
  /// **'Search cases...'**
  String get searchCases;

  /// Case type - Civil
  ///
  /// In en, this message translates to:
  /// **'Civil'**
  String get civil;

  /// Case type - Criminal
  ///
  /// In en, this message translates to:
  /// **'Criminal'**
  String get criminal;

  /// Case type - Family
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get family;

  /// Case type - Corporate
  ///
  /// In en, this message translates to:
  /// **'Corporate'**
  String get corporate;

  /// Case type - Appellate
  ///
  /// In en, this message translates to:
  /// **'Appellate'**
  String get appellate;

  /// Section header for parties information
  ///
  /// In en, this message translates to:
  /// **'Parties'**
  String get parties;

  /// Label for client name field
  ///
  /// In en, this message translates to:
  /// **'Client Name'**
  String get clientName;

  /// Label for opponent name field
  ///
  /// In en, this message translates to:
  /// **'Opponent Name'**
  String get opponentName;

  /// Label for judge name field
  ///
  /// In en, this message translates to:
  /// **'Judge Name'**
  String get judgeName;

  /// Section header for timeline information
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timeline;

  /// Label for previous hearing date
  ///
  /// In en, this message translates to:
  /// **'Previous Hearing'**
  String get previousHearing;

  /// Label for case status selection
  ///
  /// In en, this message translates to:
  /// **'Case Status'**
  String get caseStatus;

  /// Label for case type selection
  ///
  /// In en, this message translates to:
  /// **'Case Type'**
  String get caseType;

  /// Hint text for full name
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Hint text for opponent party name
  ///
  /// In en, this message translates to:
  /// **'Opponent party name'**
  String get opponentPartyName;

  /// Hint text for judge name
  ///
  /// In en, this message translates to:
  /// **'Honorable Judge'**
  String get honorableJudge;

  /// Hint text for date selection
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// Text for features coming soon
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;
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
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
