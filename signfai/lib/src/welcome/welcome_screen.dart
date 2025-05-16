import 'package:flutter/material.dart';
import 'package:signfai/src/Localization/app_localizations.dart';
import 'package:signfai/src/modules/signup/sign_screen.dart';
import 'package:signfai/src/shared/components/components.dart';
import 'package:signfai/src/shared/styles/colors.dart';
import '../modules/login/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: secondaryColor,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: size.height * 0.5,
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
            height: size.height * 0.5 - 50,
            child: Center(
              child: Container(
                height: 150,
                width: 150,
                decoration: const BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadiusDirectional.all(
                    Radius.circular(
                      30.0,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image.asset(
                    "assets/images/IconOnly.png",
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: size.height * 0.5 - 75,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                height: 225,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadiusDirectional.all(
                    Radius.circular(
                      25.0,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      const SizedBox(height: 25),
                      const FittedBox(
                          fit: BoxFit.cover,
                          child: Text("SIGNFAI",
                              style: TextStyle(
                                  color: thirdColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22))),
                      FittedBox(
                          fit: BoxFit.cover,
                          child: Text(
                              AppLocalizations.of(context)
                                  .translate('home_title')!,
                              style: const TextStyle(
                                  color: fifthColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18))),
                      const Spacer(
                        flex: 1,
                      ),
                      buildButton(
                        width: size.width,
                        text: AppLocalizations.of(context).translate('login')!,
                        backgroundColor: primaryColor,
                        borderColor: primaryColor,
                        foregroundColor: Colors.white,
                        function: () {
                          navigateTo(context, const LoginScreen());
                        },
                      ),
                      const SizedBox(height: 12),
                      buildButton(
                        width: size.width,
                        text: AppLocalizations.of(context).translate('signup')!,
                        backgroundColor: Colors.white,
                        borderColor: primaryColor,
                        foregroundColor: primaryColor,
                        function: () {
                          navigateTo(context, const SignScreen());
                        },
                      ),
                      const Spacer(
                        flex: 2,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
