import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  bool _isDarkMode = false;
  Locale _currentLocale = const Locale('en');

  bool get isDarkMode => _isDarkMode;
  Locale get currentLocale => _currentLocale;

  ThemeProvider() {
    _loadThemeFromStorage();
  }

  void updateLocale(Locale locale) {
    _currentLocale = locale;
    notifyListeners();
  }

  bool get isHindiLocale => _currentLocale.languageCode == 'hi';

  double get _hindiFontScale => isHindiLocale ? 1.2 : 1.0;
  double get _hindiGreyFontScale => isHindiLocale ? 1.4 : 1.0;

  ThemeData get currentTheme {
    return _isDarkMode ? _darkTheme : _lightTheme;
  }

  ThemeData get _lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: Colors.black,
          fontSize: 16 * _hindiFontScale,
        ),
        bodyMedium: TextStyle(
          color: Colors.black,
          fontSize: 14 * _hindiFontScale,
        ),
        bodySmall: TextStyle(
          color: Colors.grey,
          fontSize: 12 * _hindiGreyFontScale,
        ),
        displayLarge: TextStyle(
          color: Colors.black,
          fontSize: 32 * _hindiFontScale,
        ),
        displayMedium: TextStyle(
          color: Colors.black,
          fontSize: 28 * _hindiFontScale,
        ),
        titleMedium: TextStyle(
          color: Colors.grey,
          fontSize: 14 * _hindiGreyFontScale,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: Colors.grey,
          fontSize: 11 * _hindiGreyFontScale,
        ),
      ),
    );
  }

  ThemeData get _darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.black,
      cardColor: Colors.grey[900],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: Colors.white,
          fontSize: 16 * _hindiFontScale,
        ),
        bodyMedium: TextStyle(
          color: Colors.white,
          fontSize: 14 * _hindiFontScale,
        ),
        bodySmall: TextStyle(
          color: Colors.grey[400],
          fontSize: 12 * _hindiGreyFontScale,
        ),
        displayLarge: TextStyle(
          color: Colors.white,
          fontSize: 32 * _hindiFontScale,
        ),
        displayMedium: TextStyle(
          color: Colors.white,
          fontSize: 28 * _hindiFontScale,
        ),
        titleMedium: TextStyle(
          color: Colors.grey[400],
          fontSize: 14 * _hindiGreyFontScale,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: Colors.grey[400],
          fontSize: 11 * _hindiGreyFontScale,
        ),
      ),
    );
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveThemeToStorage();
    notifyListeners();
  }

  void setTheme(bool isDark) {
    if (_isDarkMode != isDark) {
      _isDarkMode = isDark;
      _saveThemeToStorage();
      notifyListeners();
    }
  }

  void _loadThemeFromStorage() async {
    try {
      final box = await Hive.openBox('settings');
      _isDarkMode = box.get(_themeKey, defaultValue: false);
      notifyListeners();
    } catch (e) {
      _isDarkMode = false;
      notifyListeners();
    }
  }

  void _saveThemeToStorage() async {
    try {
      final box = await Hive.openBox('settings');
      await box.put(_themeKey, _isDarkMode);
    } catch (e) {
      // Handle error silently
    }
  }
}
