// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Vakeel Diary';

  @override
  String get home => 'Home';

  @override
  String get cases => 'Cases';

  @override
  String get settings => 'Settings';

  @override
  String get reportsAndData => 'Reports & Data';

  @override
  String get exportTodayCases => 'Export Today\'s Cases';

  @override
  String get exportTodayCasesSubtitle => 'Generate PDF of today\'s hearings';

  @override
  String get exportAllCases => 'Export All Cases';

  @override
  String get exportAllCasesSubtitle => 'Generate complete case database PDF';

  @override
  String get appPreferences => 'App Preferences';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get hindi => 'Hindi';

  @override
  String get generatingPdf => 'Generating PDF...';

  @override
  String get exportFailed => 'Export Failed';

  @override
  String get noData => 'No Data';

  @override
  String get noTodayCases => 'No cases scheduled for today';

  @override
  String get noCasesFound => 'No cases found in the database';

  @override
  String get ok => 'OK';

  @override
  String get todayCasesReport => 'Today\'s Cases Report';

  @override
  String get allCasesReport => 'All Cases Report';

  @override
  String totalCases(int count) {
    return 'Total Cases: $count';
  }

  @override
  String generated(String timestamp) {
    return 'Generated: $timestamp';
  }

  @override
  String get caseNumber => 'Case No.';

  @override
  String get client => 'Client';

  @override
  String get court => 'Court';

  @override
  String get nextHearing => 'Next Hearing';

  @override
  String get status => 'Status';

  @override
  String get active => 'Active';

  @override
  String get closed => 'Closed';

  @override
  String get vakeelDiaryFooter => 'Vakeel Diary - Legal Case Management System';

  @override
  String get addCase => 'Add Case';

  @override
  String get todaysHearings => 'Today\'s Hearings';

  @override
  String get activeCases => 'Active Cases';

  @override
  String get viewAll => 'View All';

  @override
  String get noHearingsToday => 'No hearings scheduled for today';

  @override
  String get scheduledToday => 'scheduled today';

  @override
  String get caseDetails => 'Case Details';

  @override
  String get editCase => 'Edit Case';

  @override
  String get deleteCase => 'Delete Case';

  @override
  String get caseNumberHint => 'Enter case number';

  @override
  String get clientNameHint => 'Enter client name';

  @override
  String get courtNameHint => 'Enter court name';

  @override
  String get nextHearingHint => 'Select next hearing date';

  @override
  String get caseStatusHint => 'Select case status';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get confirmDelete => 'Are you sure you want to delete this case?';

  @override
  String get allCases => 'All Cases';

  @override
  String get searchCases => 'Search cases...';
}
