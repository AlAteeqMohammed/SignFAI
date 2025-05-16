import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:signfai/core/locator.dart';
import 'package:signfai/core/shared_prefrence_repository.dart';
import 'app_localizations.dart';

class AppLocalizationsSetup {
  static const Iterable<Locale> supportedLocales = [
    Locale('en'),
    Locale('ar'),
  ];

  static const Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates =
      [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static Locale localeResolutionCallback(
      Locale locale, Iterable<Locale> supportedLocales) {
    for (Locale supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode &&
          supportedLocale.countryCode == locale.countryCode) {
        return supportedLocale;
      }
    }
    return supportedLocales.first;
  }

  static const String _languageKey = 'language_code';

  static Future<Locale> getLocale() async {
    final prefs = locator<SharedPreferencesRepository>();
    final languageCode = prefs.getData(key: _languageKey) ?? 'en';
    return Locale(languageCode);
  }

  static Future<void> setLocale(String languageCode) async {
    final prefs = locator<SharedPreferencesRepository>();
    await prefs.savedata(key: _languageKey, value: languageCode);
  }
}
