import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/constants/font_manager.dart';
import 'package:silora/core/constants/constant_manager.dart';
import 'package:silora/core/constants/styles_manager.dart';
import 'package:silora/core/constants/values_manager.dart';
import 'package:silora/core/routes/app_routes_names.dart';
import 'package:silora/core/translations/locale_keys.g.dart';
import 'package:silora/core/widgets/custom_elevated_button.dart';

import '../widgets/preview_mock_device.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  Future<void> _onStartConnecting(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.seenOnboardingKey, true);

    if (!context.mounted) return;

    final user = FirebaseAuth.instance.currentUser;
    final targetRoute = user != null
        ? AppRouteNames.layout
        : AppRouteNames.signIn;

    context.go(targetRoute);
  }

  @override
  Widget build(BuildContext context) {
    // This explicitly tells Flutter to rebuild this widget when the locale changes.
    context.locale;
    return Scaffold(
      backgroundColor: ColorManager.lightBlue,
      body: SafeArea(
        child: Semantics(
          label: LocaleKeys.onboarding_screenLabel.tr(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: REdgeInsets.symmetric(
                  horizontal: AppPadding.p24,
                  vertical: AppPadding.p16,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - AppSize.s32.h,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // تم تبسيط الـ Language Switcher بدون الحاجة لـ setState
                        const _LanguageSwitcher(),
                        SizedBox(height: AppSize.s16.h),
                        Text(
                          LocaleKeys.onboarding_appName.tr(),
                          semanticsLabel: LocaleKeys.onboarding_appNameSemantics
                              .tr(),
                          style:
                              getBoldStyle(
                                color: ColorManager.black,
                                fontSize: FontSize.s32.sp,
                              ).copyWith(
                                letterSpacing: FontLetterSpacing.s22Spacing,
                                height: AppSize.s1_1,
                              ),
                        ),
                        SizedBox(height: AppSize.s8.h),
                        Text(
                          LocaleKeys.onboarding_subtitle.tr(),
                          textAlign: TextAlign.center,
                          style: getBoldStyle(
                            color: ColorManager.black,
                            fontSize: FontSize.s22.sp,
                          ).copyWith(letterSpacing: -AppSize.s0_3, height: AppSize.s1_2),
                        ),
                        SizedBox(height: AppSize.s12.h),
                        Padding(
                          padding: REdgeInsets.symmetric(
                            horizontal: AppPadding.p8,
                          ),
                          child: Text(
                            LocaleKeys.onboarding_description.tr(),
                            textAlign: TextAlign.center,
                            style: getRegularStyle(
                              color: ColorManager.black.withValues(alpha: 0.7),
                              fontSize: FontSize.s14.sp,
                            ).copyWith(height: AppSize.s1_45),
                          ),
                        ),
                        AppSize.s24.verticalSpace,
                        Expanded(
                          child: Center(child: PreviewMockDevice()),
                        ),
                        AppSize.s24.verticalSpace,
                        CustomElevatedButton(
                          label: LocaleKeys.onboarding_startConnectingBtn.tr(),
                          onTap: () => _onStartConnecting(context),
                        ),
                        SizedBox(height: AppSize.s8.h),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LanguageSwitcher extends StatelessWidget {
  const _LanguageSwitcher();

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == AppConstants.arabicLanguageCode;

    return Align(
      alignment: AlignmentDirectional.topEnd,
      child: TextButton.icon(
        onPressed: () async {
          final newLocale = isArabic ? const Locale(AppConstants.englishLanguageCode) : const Locale(AppConstants.arabicLanguageCode);
          await context.setLocale(newLocale);
        },
        icon: const Icon(Icons.language, color: ColorManager.black),
        label: Text(
          isArabic ? AppConstants.englishLanguageName : AppConstants.arabicLanguageName,
          style: getMediumStyle(
            color: ColorManager.black,
            fontSize: FontSize.s14.sp,
          ),
        ),
      ),
    );
  }
}
