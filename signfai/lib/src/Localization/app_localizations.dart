import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert' show json;
import 'app_localizations_delegate.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = AppLocalizationsDelegate();

  Map<String, String>? localizedStrings;

  Future<void> load() async {
    String jsonString = await rootBundle.loadString('lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    localizedStrings = jsonMap.map<String, String>((key, value) {
      return MapEntry(key, value.toString());
    });
  }

  String? translate(String key) => localizedStrings![key];

  bool get isEnLocale => locale.languageCode == 'en';
}
