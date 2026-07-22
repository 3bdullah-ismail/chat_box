import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/color_manager.dart';
import '../../../core/constants/font_manager.dart';
import '../../../core/constants/styles_manager.dart';
import '../../../core/constants/values_manager.dart';
import '../../../core/translations/locale_keys.g.dart';

class PreviewMockDevice extends StatelessWidget {
  const PreviewMockDevice({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: LocaleKeys.onboarding_previewSemantics.tr(),
      container: true,
      excludeSemantics: true,
      child: FractionallySizedBox(
        widthFactor: AppSize.s0_75,
        child: AspectRatio(
          aspectRatio: 1 / AppSize.s2_05,
          child: Container(
            padding: const EdgeInsets.all(AppPadding.p6),
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: ColorManager.nearBlack,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: AppSize.s3_5,
                  color: ColorManager.nearBlack,
                ),
                borderRadius: BorderRadius.circular(AppRadius.r36),
              ),
              shadows: const [
                BoxShadow(
                  color: ColorManager.overlay,
                  blurRadius: AppSize.s40,
                  offset: const Offset(0, AppSize.s15),
                  spreadRadius: -AppSize.s10,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. App Bar
                  Container(
                    width: double.infinity,
                    height: AppSize.s48,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p16,
                    ),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: AppSize.s1,
                          color: ColorManager.surfaceGray,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: AppSize.s20, height: AppSize.s20),
                        Text(
                          LocaleKeys.onboarding_appName.tr(),
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
                              borderRadius: BorderRadius.circular(
                                AppRadius.r999,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 2. Chat Body
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.p16,
                        vertical: AppPadding.p12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const _MockReceivedMessage(
                            usernameWidth: AppSize.s80,
                            messageWidth: double.infinity,
                          ),
                          const SizedBox(height: AppSize.s12),
                          const Opacity(
                            opacity: AppSize.s0_6,
                            child: _MockReceivedMessage(
                              usernameWidth: AppSize.s50,
                              messageWidth: AppSize.s100,
                            ),
                          ),
                          const SizedBox(height: AppSize.s16),
                          Container(
                            constraints: const BoxConstraints(
                              maxWidth: AppSize.s150,
                            ),
                            padding: const EdgeInsets.all(AppPadding.p10),
                            decoration: const ShapeDecoration(
                              color: ColorManager.nearBlack,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusDirectional.only(
                                  topStart: Radius.circular(AppRadius.r12),
                                  topEnd: Radius.circular(AppRadius.r12),
                                  bottomEnd: Radius.circular(AppRadius.r12),
                                ),
                              ),
                            ),
                            child: Text(
                              LocaleKeys.onboarding_mockChatBubbleText.tr(),
                              style: getRegularStyle(
                                color: ColorManager.white,
                                fontSize: FontSize.s11,
                              ).copyWith(height: AppSize.s1_4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
