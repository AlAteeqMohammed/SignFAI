import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/locator.dart';
import 'src/Blocs/blocs.dart';
import 'src/Blocs/providers.dart';
import 'src/modules/splash/splash_screen.dart';
import 'src/shared/styles/colors.dart';
import 'src/Localization/app_localizations_setup.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: BlocProviders.providers,
      child: BlocBuilder<LocaleCubit, LocaleState>(
        buildWhen: (previousState, currentState) =>
            previousState != currentState,
        builder: (_, localeState) {
          return MaterialApp(
              supportedLocales: AppLocalizationsSetup.supportedLocales,
              localizationsDelegates:
                  AppLocalizationsSetup.localizationsDelegates,
              //  localeResolutionCallback: AppLocalizationsSetup.localeResolutionCallback,
              locale: localeState.locale,
              debugShowCheckedModeBanner: false,
              title: 'SIGNFAI',
              theme: ThemeData(
                fontFamily: GoogleFonts.openSans().fontFamily,
                primarySwatch: Colors.blue,
              ),
              color: primaryColor,
              home: const SplashScreen());
        },
      ),
    );
  }
}
