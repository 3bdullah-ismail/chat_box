import 'package:silora/core/di/injection_container.dart';
import 'package:silora/core/routes/routes.dart';
import 'package:silora/core/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  GoogleFonts.config.allowRuntimeFetching = true;

  await Firebase.initializeApp();
  await GoogleSignIn.instance.initialize(
    serverClientId:
        '710064998768-oeudr7utns02ivgtqkbdvj4urr7ih6vm.apps.googleusercontent.com',
  );
  configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        FlutterNativeSplash.remove();
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Silora',
          theme: AppTheme.theme,
          routerConfig: Routes.router,
        );
      },
      child: const SizedBox.shrink(),
    );
  }
}
