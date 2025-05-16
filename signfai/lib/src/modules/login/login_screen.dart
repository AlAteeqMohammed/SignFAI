import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signfai/src/Localization/app_localizations.dart';
import '../../shared/styles/colors.dart';
import '../../shared/components/components.dart';
import '../home/home_screen.dart';
import 'cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    var size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginLoading) {
            circularProgress(context);
          }
          if (state is LoginSuccess) {
            Navigator.pop(context);
            navigateAndFinish(context, const HomeScreen());
          }
          if (state is LoginFailure) {
            Navigator.pop(context);
            FocusManager.instance.primaryFocus?.unfocus();
            showSnackBar(
                context: context,
                message: state.error,
                duration: 3,
                icon: Icons.error_outline);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: forthColor,
            body: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: size.height * 0.4,
                  width: size.width,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadiusDirectional.vertical(
                      bottom: Radius.circular(
                        25.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                    height: size.height * 0.4 - 30,
                    child: Visibility(
                        visible: !isKeyboard,
                        child: Center(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                              Container(
                                  height: 100,
                                  width: 100,
                                  decoration: const BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadiusDirectional.all(
                                      Radius.circular(
                                        20.0,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7),
                                    child: Image.asset(
                                      "assets/images/IconOnly.png",
                                    ),
                                  ))
                            ])))),
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: !isKeyboard
                              ? size.height * 0.4 - 175
                              : size.height * 0.4 - 250,
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            height: 240,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadiusDirectional.all(
                                Radius.circular(
                                  25.0,
                                ),
                              ),
                            ),
                            child: Form(
                              key: LoginCubit.get(context).formKey,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const SizedBox(height: 30),
                                    SizedBox(
                                      height: 55,
                                      child: defaultFormField(
                                          controller: LoginCubit.get(context)
                                              .usernameController,
                                          type: TextInputType.text,
                                          hint: AppLocalizations.of(context)
                                              .translate('username')!,
                                          prefix: Icons.person,
                                          validate: (val) {
                                            if (val!.isEmpty) {
                                              return '';
                                            }
                                            return null;
                                          }),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      height: 55,
                                      child: defaultFormField(
                                          controller: LoginCubit.get(context)
                                              .passwordController,
                                          type: TextInputType.visiblePassword,
                                          hint: AppLocalizations.of(context)
                                              .translate('password')!,
                                          prefix: Icons.lock,
                                          suffix:
                                              LoginCubit.get(context).suffix,
                                          isPassword: LoginCubit.get(context)
                                              .isPassword,
                                          suffixPressed: () {
                                            LoginCubit.get(context)
                                                .changePasswordVisibility();
                                          },
                                          validate: (val) {
                                            if (val!.isEmpty) {
                                              return '';
                                            }
                                            return null;
                                          }),
                                    ),
                                    const Spacer(),
                                    buildButton(
                                      width: size.width,
                                      text: AppLocalizations.of(context)
                                          .translate('login')!,
                                      backgroundColor: primaryColor,
                                      borderColor: primaryColor,
                                      foregroundColor: Colors.white,
                                      function: () {
                                        if (LoginCubit.get(context)
                                            .formKey
                                            .currentState!
                                            .validate()) {
                                          LoginCubit.get(context).loginUser();
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 30)
                                  ],
                                ),
                              ),
                            )),
                        const SizedBox(height: 30)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
