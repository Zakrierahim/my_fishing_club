import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stores the selected language and restores it from local storage.
class LocaleController extends ChangeNotifier {
  LocaleController({Locale? locale}) : _locale = locale ?? english;

  static const Locale english = Locale('en');
  static const Locale malay = Locale('ms');
  static const String preferenceKey = 'app_locale';

  Locale _locale;

  Locale get locale => _locale;

  /// Reads the saved language. English is used when nothing is saved.
  static Future<LocaleController> restore() async {
    return LocaleController(locale: await _readSaved());
  }

  static Future<Locale> _readSaved() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      return localeFromCode(preferences.getString(preferenceKey));
    } catch (_) {
      return english;
    }
  }

  static Locale localeFromCode(String? code) {
    if (code == malay.languageCode) {
      return malay;
    }
    return english;
  }

  /// Switches language immediately, then stores the choice locally.
  Future<void> setLocale(Locale locale) async {
    final next = localeFromCode(locale.languageCode);
    if (next == _locale) {
      return;
    }
    _locale = next;
    notifyListeners();
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(preferenceKey, next.languageCode);
    } catch (_) {
      // The new language still applies for this session.
    }
  }
}
