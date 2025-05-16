import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:signfai/core/locator.dart';
import 'package:signfai/core/shared_prefrence_repository.dart';
import 'package:signfai/src/shared/end_points.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> loginUser() async {
    try {
      emit(LoginLoading());
      var url =
          Uri.parse(ConstantsService.baseUrl + ConstantsService.logInEndpoint);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "username_or_email": usernameController.text,
            "password": passwordController.text
          }));

      var responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        locator<SharedPreferencesRepository>().setLoggedIn(isLoggedIn: true);
        locator<SharedPreferencesRepository>().savedata(
          key: 'access',
          value: responseBody["access"],
        );
        emit(LoginSuccess());
      } else {
        throw (responseBody["error"][0]);
      }
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  IconData suffix = Icons.visibility_off_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;

    emit(LoginPasswordVisibility());
  }
}
