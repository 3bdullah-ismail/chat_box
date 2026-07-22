import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silora/core/constants/constant_manager.dart';
import 'package:silora/core/di/injection_container.dart';
import 'package:silora/core/translations/codegen_loader.g.dart';

import 'Silora.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  GoogleFonts.config.allowRuntimeFetching = true;

  await Firebase.initializeApp();
  await GoogleSignIn.instance.initialize(
    serverClientId:
        '710064998768-oeudr7utns02ivgtqkbdvj4urr7ih6vm.apps.googleusercontent.com',
  );
  configureDependencies();

  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool(AppConstants.seenOnboardingKey) ?? false;

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      assetLoader: const CodegenLoader(),
      child: Silora(),
    ),
  );
}
