import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing app locale/language state
class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'selected_locale';
  Locale _locale = const Locale('en'); // Default to English
  
  /// Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('hi'), // Hindi
  ];

  /// Current locale
  Locale get locale => _locale;

  /// Initialize locale from saved preferences or device locale
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocaleCode = prefs.getString(_localeKey);
      
      if (savedLocaleCode != null) {
        // Use saved locale
        _locale = Locale(savedLocaleCode);
      } else {
        // Use device locale with fallback to English
        final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
        _locale = _getSupportedLocale(deviceLocale) ?? const Locale('en');
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing locale: $e');
      // Fallback to English
      _locale = const Locale('en');
      notifyListeners();
    }
  }

  /// Change app locale
  Future<void> changeLocale(String languageCode) async {
    try {
      final newLocale = Locale(languageCode);
      
      // Validate that the locale is supported
      if (supportedLocales.contains(newLocale)) {
        _locale = newLocale;
        
        // Save to preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_localeKey, languageCode);
        
        notifyListeners();
      } else {
        debugPrint('Unsupported locale: $languageCode');
      }
    } catch (e) {
      debugPrint('Error changing locale: $e');
    }
  }

  /// Get supported locale from device locale
  Locale? _getSupportedLocale(Locale deviceLocale) {
    // Check if device locale is directly supported
    for (Locale supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == deviceLocale.languageCode) {
        return supportedLocale;
      }
    }
    
    // Check if device locale language code matches any supported locale
    for (Locale supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == deviceLocale.languageCode) {
        return supportedLocale;
      }
    }
    
    return null; // No matching supported locale
  }

  /// Check if current locale is RTL (Right-to-Left)
  bool get isRTL => false; // Neither English nor Hindi are RTL

  /// Get language display name
  String getLanguageDisplayName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'hi':
        return 'हिंदी (Hindi)';
      default:
        return languageCode.toUpperCase();
    }
  }

  /// Get current language display name
  String get currentLanguageDisplayName {
    return getLanguageDisplayName(_locale.languageCode);
  }
}
