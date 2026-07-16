import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/constants/font_manager.dart';
import 'package:silora/core/constants/styles_manager.dart';
import 'package:silora/core/constants/values_manager.dart';
import 'package:silora/core/routes/app_routes_names.dart';
import 'package:silora/core/widgets/custom_elevated_button.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  Future<void> _onStartConnecting(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboarding', true);

    if (!context.mounted) return;

    final user = FirebaseAuth.instance.currentUser;
    final targetRoute = user != null
        ? AppRouteNames.layout
        : AppRouteNames.signIn;

    context.go(targetRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.lightBlue,
      body: SafeArea(
        child: Semantics(
          label: 'Onboarding Screen',
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
                        SizedBox(height: AppSize.s16.h),
                        Text(
                          "Silora",
                          semanticsLabel: "App Name: Silora",
                          style:
                              getBoldStyle(
                                color: ColorManager.black,
                                fontSize: FontSize.s32.sp,
                              ).copyWith(
                                letterSpacing: FontLetterSpacing.s22Spacing,
                                height: 1.1,
                              ),
                        ),
                        SizedBox(height: AppSize.s8.h),
                        Text(
                          "Where Every Connection Matters",
                          textAlign: TextAlign.center,
                          style: getBoldStyle(
                            color: ColorManager.black,
                            fontSize: FontSize.s22.sp,
                          ).copyWith(letterSpacing: -0.3, height: 1.2),
                        ),
                        SizedBox(height: AppSize.s12.h),
                        Padding(
                          padding: REdgeInsets.symmetric(
                            horizontal: AppPadding.p8,
                          ),
                          child: Text(
                            "Silora brings people closer through simple, secure, and meaningful conversations. Stay connected with friends, family, and the people who matter most.",
                            textAlign: TextAlign.center,
                            style: getRegularStyle(
                              color: ColorManager.black.withValues(alpha: 0.7),
                              fontSize: FontSize.s14.sp,
                            ).copyWith(height: 1.45),
                          ),
                        ),
                        24.verticalSpace,
                        const Expanded(
                          child: Center(child: _OnboardingPreview()),
                        ),
                        24.verticalSpace,
                        CustomElevatedButton(
                          label: "Start Connecting",
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

class _OnboardingPreview extends StatelessWidget {
  const _OnboardingPreview();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Silora messaging experience preview',
      child: const ExcludeSemantics(child: _PreviewMockDevice()),
    );
  }
}

class _PreviewMockDevice extends StatelessWidget {
  const _PreviewMockDevice();

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.75,
      child: AspectRatio(
        aspectRatio: 1 / 2.05,
        child: Container(
          padding: const EdgeInsets.all(AppPadding.p6),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: ColorManager.nearBlack,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 3.5, color: ColorManager.nearBlack),
              borderRadius: BorderRadius.circular(AppRadius.r36),
            ),
            shadows: const [
              BoxShadow(
                color: ColorManager.overlay,
                blurRadius: AppSize.s40,
                offset: Offset(0, 15),
                spreadRadius: -10,
              ),
            ],
          ),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: ColorManager.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.r30),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MockAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),

                    padding: EdgeInsets.symmetric(
                      horizontal: AppPadding.p16,
                      vertical: AppPadding.p12,
                    ),
                    child: _MockChatBody(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MockAppBar extends StatelessWidget {
  const _MockAppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppSize.s48,

      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: AppSize.s1, color: ColorManager.surfaceGray),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: AppSize.s20, height: AppSize.s20),
          Text(
            'Silora',
            style: getExtraBoldStyle(
              color: ColorManager.nearBlack,
              fontSize: FontSize.s11,
              letterSpacing: -0.25,
            ),
          ),
          Container(
            width: AppSize.s20,
            height: AppSize.s20,
            decoration: ShapeDecoration(
              color: ColorManager.lightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.r999),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MockChatBody extends StatelessWidget {
  const _MockChatBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const _MockReceivedMessage(
          usernameWidth: 80,
          messageWidth: double.infinity,
        ),
        const SizedBox(height: AppSize.s12),
        const Opacity(
          opacity: 0.6,
          child: _MockReceivedMessage(
            usernameWidth: AppSize.s50,
            messageWidth: AppSize.s100,
          ),
        ),
        const SizedBox(height: AppSize.s16),
        Container(
          constraints: const BoxConstraints(maxWidth: 150),
          padding: const EdgeInsets.all(AppPadding.p10),
          decoration: const ShapeDecoration(
            color: ColorManager.nearBlack,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppRadius.r12),
                topRight: Radius.circular(AppRadius.r12),
                bottomRight: Radius.circular(AppRadius.r12),
              ),
            ),
          ),
          child: Text(
            'Welcome to Silora.\nStay close to the people who matter.',
            style: getRegularStyle(
              color: ColorManager.white,
              fontSize: FontSize.s11,
            ).copyWith(height: 1.4),
          ),
        ),
      ],
    );
  }
}

class _MockReceivedMessage extends StatelessWidget {
  final double usernameWidth;
  final double messageWidth;

  const _MockReceivedMessage({
    required this.usernameWidth,
    required this.messageWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: AppSize.s32,
          height: AppSize.s32,
          decoration: ShapeDecoration(
            color: ColorManager.lightGray,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.r999),
            ),
          ),
        ),
        const SizedBox(width: AppSize.s8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSize.s4),
              Container(
                width: usernameWidth,
                height: AppSize.s6,
                decoration: ShapeDecoration(
                  color: ColorManager.lightGray,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.r999),
                  ),
                ),
              ),
              const SizedBox(height: AppSize.s4),
              Container(
                width: messageWidth,
                height: AppSize.s6,
                decoration: ShapeDecoration(
                  color: ColorManager.surfaceGray,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.r999),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
