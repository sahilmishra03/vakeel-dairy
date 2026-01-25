// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'वकील डायरी';

  @override
  String get home => 'होम';

  @override
  String get cases => 'केस';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get reportsAndData => 'रिपोर्ट और डेटा';

  @override
  String get exportTodayCases => 'आज के केस एक्सपोर्ट करें';

  @override
  String get exportTodayCasesSubtitle => 'आज की सुनवाई का PDF बनाएं';

  @override
  String get exportAllCases => 'सभी केस एक्सपोर्ट करें';

  @override
  String get exportAllCasesSubtitle => 'पूर्ण केस डेटाबेस PDF बनाएं';

  @override
  String get appPreferences => 'ऐप प्राथमिकताएं';

  @override
  String get darkMode => 'डार्क मोड';

  @override
  String get language => 'भाषा';

  @override
  String get english => 'अंग्रेजी';

  @override
  String get hindi => 'हिंदी';

  @override
  String get generatingPdf => 'PDF बनाया जा रहा है...';

  @override
  String get exportFailed => 'एक्सपोर्ट विफल';

  @override
  String get noData => 'कोई डेटा नहीं';

  @override
  String get noTodayCases => 'आज के लिए कोई केस निर्धारित नहीं है';

  @override
  String get noCasesFound => 'डेटाबेस में कोई केस नहीं मिला';

  @override
  String get ok => 'ठीक';

  @override
  String get todayCasesReport => 'आज के केस रिपोर्ट';

  @override
  String get allCasesReport => 'सभी केस रिपोर्ट';

  @override
  String totalCases(int count) {
    return 'कुल केस: $count';
  }

  @override
  String generated(String timestamp) {
    return 'बनाया गया: $timestamp';
  }

  @override
  String get caseNumber => 'केस नं.';

  @override
  String get client => 'क्लाइंट';

  @override
  String get court => 'अदालत';

  @override
  String get nextHearing => 'अगली सुनवाई';

  @override
  String get status => 'स्थिति';

  @override
  String get active => 'सक्रिय';

  @override
  String get closed => 'बंद';

  @override
  String get vakeelDiaryFooter => 'वकील डायरी - लीगल केस मैनेजमेंट सिस्टम';

  @override
  String get addCase => 'केस जोड़ें';

  @override
  String get todaysHearings => 'आज की सुनवाई';

  @override
  String get activeCases => 'सक्रिय केस';

  @override
  String get viewAll => 'सभी देखें';

  @override
  String get noHearingsToday => 'आज के लिए कोई सुनवाई निर्धारित नहीं है';

  @override
  String get scheduledToday => 'आज निर्धारित';

  @override
  String get caseDetails => 'केस विवरण';

  @override
  String get editCase => 'केस संपादित करें';

  @override
  String get deleteCase => 'केस हटाएं';

  @override
  String get caseNumberHint => 'केस नंबर दर्ज करें';

  @override
  String get clientNameHint => 'क्लाइंट का नाम दर्ज करें';

  @override
  String get courtNameHint => 'अदालत का नाम दर्ज करें';

  @override
  String get nextHearingHint => 'अगली सुनवाई की तारीख चुनें';

  @override
  String get caseStatusHint => 'केस की स्थिति चुनें';

  @override
  String get save => 'सेव करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get delete => 'हटाएं';

  @override
  String get confirmDelete => 'क्या आप वाकई इस केस को हटाना चाहते हैं?';

  @override
  String get allCases => 'सभी केस';

  @override
  String get searchCases => 'केस खोजें...';
}
