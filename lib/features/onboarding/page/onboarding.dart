import 'package:chat_app/core/constants/color_manager.dart';
import 'package:chat_app/core/constants/font_manager.dart';
import 'package:chat_app/core/constants/styles_manager.dart';
import 'package:chat_app/core/routes/app_routes_names.dart';
import 'package:chat_app/core/widgets/custom_elevated_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.lightBlue,
      body: SafeArea(
        child: Semantics(
          label: 'Onboarding Screen',
          child: SingleChildScrollView(
            padding: REdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 24.h),
                Text(
                  "ChatBox",
                  semanticsLabel: "App Name: ChatBox",
                  style: getBoldStyle(
                    color: ColorManager.black,
                    fontSize: 36.sp,
                  ).copyWith(letterSpacing: -0.5, height: 1.1),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Connect Instantly, Anytime',
                  textAlign: TextAlign.center,
                  style: getBoldStyle(
                    color: ColorManager.black,
                    fontSize: 24.sp,
                  ).copyWith(letterSpacing: -0.3, height: 1.2),
                ),
                SizedBox(height: 12.h),
                Text(
                  'A modern messaging experience designed for everyone. Connect securely, chat instantly, and communicate effortlessly with friends, family, or teams.',
                  textAlign: TextAlign.center,
                  style: getRegularStyle(
                    color: ColorManager.black.withValues(alpha: 0.7),
                    fontSize: FontSize.s14.sp,
                  ).copyWith(height: 1.5),
                ),
                SizedBox(height: 28.h),
                const _OnboardingPreview(),
                SizedBox(height: 32.h),
                CustomElevatedButton(
                  label: "Get Started",
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('seen_onboarding', true);
                    if (context.mounted) {
                      context.go(
                        FirebaseAuth.instance.currentUser != null
                            ? AppRouteNames.chat
                            : AppRouteNames.signIn,
                      );
                    }
                  },
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingPreview extends StatelessWidget {
  const _OnboardingPreview();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        label: 'ChatBox interface preview showing a chat history',
        child: ExcludeSemantics(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: SizedBox(
              width: 0.75.sw,
              child: AspectRatio(
                aspectRatio: 240 / 440,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: ColorManager.nearBlack,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 4,
                        color: ColorManager.nearBlack,
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: ColorManager.overlay,
                        blurRadius: 50,
                        offset: Offset(0, 25),
                        spreadRadius: -12,
                      ),
                    ],
                  ),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 56,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: ColorManager.surfaceGray,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 24, height: 24),
                              Text(
                                'ChatBox',
                                style: TextStyle(
                                  color: ColorManager.nearBlack,
                                  fontSize: 12,
                                  fontFamily: FontConstants.fontFamily,
                                  fontWeight: FontWeight.w700,
                                  height: 1.33,
                                  letterSpacing: -0.30,
                                ),
                              ),
                              Container(
                                width: 24,
                                height: 24,
                                decoration: ShapeDecoration(
                                  color: ColorManager.lightBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: ShapeDecoration(
                                      color: ColorManager.lightGray,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          9999,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 96,
                                          height: 8,
                                          decoration: ShapeDecoration(
                                            color: ColorManager.lightGray,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(9999),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          width: double.infinity,
                                          height: 8,
                                          decoration: ShapeDecoration(
                                            color: ColorManager.surfaceGray,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(9999),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Opacity(
                                opacity: 0.6,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: ShapeDecoration(
                                        color: ColorManager.lightGray,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            9999,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 64,
                                            height: 8,
                                            decoration: ShapeDecoration(
                                              color: ColorManager.lightGray,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(9999),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            width: 123,
                                            height: 8,
                                            decoration: ShapeDecoration(
                                              color: ColorManager.surfaceGray,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(9999),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                constraints: const BoxConstraints(
                                  maxWidth: 162,
                                ),
                                padding: const EdgeInsets.all(12),
                                decoration: const ShapeDecoration(
                                  color: ColorManager.nearBlack,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'The architectural review is\ncomplete.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontFamily: FontConstants.fontFamily,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
