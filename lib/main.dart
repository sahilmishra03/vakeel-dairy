import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'widgets/main_screen.dart';
import 'services/hive_service.dart';
import 'providers/case_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'generated/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  await HiveService.init();

  // Initialize LocaleProvider
  final localeProvider = LocaleProvider();
  await localeProvider.initialize();

  runApp(VakeelDairyApp(localeProvider: localeProvider));
}

class VakeelDairyApp extends StatelessWidget {
  final LocaleProvider localeProvider;
  
  const VakeelDairyApp({super.key, required this.localeProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CaseProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider.value(value: localeProvider),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, child) {
          return MaterialApp(
            title: 'Vakeel Dairy',
            theme: themeProvider.currentTheme,
            home: const MainScreen(),
            debugShowCheckedModeBanner: false,
            
            // Localization configuration
            locale: localeProvider.locale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LocaleProvider.supportedLocales,
          );
        },
      ),
    );
  }
}
