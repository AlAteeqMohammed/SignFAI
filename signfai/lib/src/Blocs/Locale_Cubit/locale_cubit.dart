import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show Locale;
import '../../Localization/app_localizations_setup.dart';
import 'package:meta/meta.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  // Passing an initial value (state) with a default 'Locale' to the super class.
  LocaleCubit() : super(const SelectedLocale(Locale('en'))) {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final savedLocale = await AppLocalizationsSetup.getLocale();
    emit(SelectedLocale(savedLocale));
  }

  Future<void> changeLocale(String languageCode) async {
    await AppLocalizationsSetup.setLocale(languageCode);
    emit(SelectedLocale(Locale(languageCode)));
  }

  // Once we call this method, the BlocBuilder<LocaleCubit>
  // in the 'main.dart' will rebuild the entire app with
  // the new emitted state that holds the 'ar' locale.
  void toArabic() => emit(const SelectedLocale(Locale('ar')));

  // Same as the previous method, but with the 'en' locale.
  void toEnglish() => emit(const SelectedLocale(Locale('en')));
}
