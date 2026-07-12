import 'package:chat_app/core/di/injection_container.dart';
import 'package:chat_app/core/routes/routes.dart';
import 'package:chat_app/core/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: AppTheme.theme,
          routerConfig: Routes.router,
        );
      },
      child: const SizedBox.shrink(),
    );
  }
}
