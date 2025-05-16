import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signfai/src/shared/end_points.dart';
import 'package:http/http.dart' as http;

part 'sign_state.dart';

class SignCubit extends Cubit<SignState> {
  SignCubit() : super(SignInitial());

  static SignCubit get(context) => BlocProvider.of(context);

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  int? id;

  Future<void> signupUser() async {
    try {
      emit(SignLoading());
      var url =
          Uri.parse(ConstantsService.baseUrl + ConstantsService.signupEndpoint);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "username": usernameController.text,
            "email": emailController.text,
            "password": passwordController.text
          }));

      var responseBody = jsonDecode(response.body);
      if (response.statusCode == 201) {
        emit(SignSuccess());
      } else {
        String? error;
        if (responseBody["username"] != null) {
          error = responseBody["username"][0];
        }
        if (responseBody["email"] != null) {
          error = responseBody["email"][0];
        }
        if (responseBody["password"] != null) {
          error = responseBody["password"][0];
        }
        throw (error!);
      }
    } catch (e) {
      emit(SignFailure(e.toString()));
    }
  }

  IconData suffix = Icons.visibility_off_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;

    emit(SignPasswordVisibility());
  }
}
