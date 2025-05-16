import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signfai/src/Localization/app_localizations.dart';
import 'package:signfai/src/modules/login/login_screen.dart';
import '../../shared/styles/colors.dart';
import '../../shared/components/components.dart';
import 'cubit/sign_cubit.dart';

class SignScreen extends StatelessWidget {
  const SignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    var size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => SignCubit(),
      child: BlocConsumer<SignCubit, SignState>(
        listener: (context, state) {
          if (state is SignLoading) {
            circularProgress(context);
          }
          if (state is SignSuccess) {
            Navigator.pop(context);
            navigateAndFinish(context, const LoginScreen());
          }
          if (state is SignFailure) {
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
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                            height: 300,
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
                              key: SignCubit.get(context).formKey,
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
                                          controller: SignCubit.get(context)
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
                                          controller: SignCubit.get(context)
                                              .emailController,
                                          type: TextInputType.emailAddress,
                                          hint: AppLocalizations.of(context)
                                              .translate('email')!,
                                          prefix: Icons.email,
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
                                          controller: SignCubit.get(context)
                                              .passwordController,
                                          type: TextInputType.visiblePassword,
                                          hint: AppLocalizations.of(context)
                                              .translate('password')!,
                                          prefix: Icons.lock,
                                          suffix: SignCubit.get(context).suffix,
                                          isPassword:
                                              SignCubit.get(context).isPassword,
                                          suffixPressed: () {
                                            SignCubit.get(context)
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
                                          .translate('signup')!,
                                      backgroundColor: primaryColor,
                                      borderColor: primaryColor,
                                      foregroundColor: Colors.white,
                                      function: () {
                                        if (SignCubit.get(context)
                                            .formKey
                                            .currentState!
                                            .validate()) {
                                          SignCubit.get(context).signupUser();
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
