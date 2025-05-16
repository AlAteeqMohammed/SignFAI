import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signfai/core/locator.dart';
import 'package:signfai/core/shared_prefrence_repository.dart';
import 'package:signfai/src/Blocs/blocs.dart';
import 'package:signfai/src/Localization/app_localizations.dart';
import 'package:signfai/src/models/data.dart';
import 'package:signfai/src/shared/end_points.dart';
import 'package:http/http.dart' as http;
import '../../../shared/components/components.dart';
import '../../../welcome/welcome_screen.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of(context);

  void refresh() {
    emit(HomeRefresh());
  }

  void logout(BuildContext context) {
    locator<SharedPreferencesRepository>().setLoggedIn(isLoggedIn: false);
    navigateAndFinish(context, const WelcomeScreen());
  }

  langChange(BuildContext context) {
    if (AppLocalizations.of(context).isEnLocale) {
      BlocProvider.of<LocaleCubit>(context).toArabic();
      BlocProvider.of<LocaleCubit>(context).changeLocale('ar');
    } else {
      BlocProvider.of<LocaleCubit>(context).toEnglish();
      BlocProvider.of<LocaleCubit>(context).changeLocale('en');
    }
  }

  Future<List<Data>?> loadData(int tap) async {
    try {
      Uri url;
      List<Data> myRequests = [];
      String token =
          locator<SharedPreferencesRepository>().getData(key: 'access');
      if (tap == 0) {
        url = Uri.parse(
            ConstantsService.baseUrl + ConstantsService.loadLettersEndpoint);
      } else if (tap == 1) {
        url = Uri.parse(
            ConstantsService.baseUrl + ConstantsService.loadWordsEndpoint);
      } else {
        url = Uri.parse(
            ConstantsService.baseUrl + ConstantsService.loadSentencesEndpoint);
      }

      var response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      });
      var responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        for (var x in responseBody) {
          Data temp = Data.fromJson(x);
          myRequests.add(temp);
        }
        return myRequests;
      }
      return myRequests;
    } catch (e) {
      // emit(HomeFailure(e.toString()));
    }
    return null;
  }
}
