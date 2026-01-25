import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/home_screen.dart';
import '../screens/view_all_cases_screen.dart';
import '../screens/settings_screen.dart';
import '../providers/locale_provider.dart';
import '../generated/app_localizations.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(key: PageStorageKey('home')),
    const ViewAllCasesScreen(key: PageStorageKey('cases')),
    const SettingsScreen(key: PageStorageKey('settings')),
  ];

  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    // Theme Constants (Consistent with App Theme)
    const Color primaryBlack = Color(0xFF111111);

    return Scaffold(
      body: SafeArea(
        child: PageStorage(bucket: _bucket, child: _screens[_currentIndex]),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: primaryBlack,
          unselectedItemColor: Colors.grey.shade600,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize:
                Provider.of<LocaleProvider>(context).locale.languageCode == 'hi'
                ? 14
                : 12,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize:
                Provider.of<LocaleProvider>(context).locale.languageCode == 'hi'
                ? 13
                : 11,
          ),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: AppLocalizations.of(context)!.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.folder_outlined),
              activeIcon: const Icon(Icons.folder),
              label: AppLocalizations.of(context)!.cases,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings_outlined),
              activeIcon: const Icon(Icons.settings),
              label: AppLocalizations.of(context)!.settings,
            ),
          ],
        ),
      ),
    );
  }
}
