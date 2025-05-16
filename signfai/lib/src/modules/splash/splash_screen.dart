import 'dart:async';
import 'package:flutter/material.dart';
import 'package:signfai/core/locator.dart';
import 'package:signfai/core/shared_prefrence_repository.dart';
import 'package:signfai/src/modules/home/home_screen.dart';
import 'package:signfai/src/welcome/welcome_screen.dart';
import '../../shared/components/components.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void wait() {
    Future.delayed(const Duration(seconds: 2), () async {
      bool login = locator<SharedPreferencesRepository>().getLoggedIn();
      if (login) {
        navigateAndFinish(context, const HomeScreen());
      } else {
        navigateAndFinish(context, const WelcomeScreen());
      }
    });
  }

  @override
  void initState() {
    wait();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mdw = MediaQuery.of(context).size.width;
    final mdh = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
            body: Container(
                width: mdw,
                height: mdh,
                color: const Color.fromARGB(255, 214, 236, 230),
                child: Center(
                  child: SizedBox(
                    height: mdh * 0.75,
                    width: mdw * 0.75,
                    child:
                        Image.asset("assets/images/FullLogo_Transparent.png"),
                  ),
                ))),
      ),
    );
  }
}
