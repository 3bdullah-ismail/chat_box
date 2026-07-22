import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:silora/core/constants/assets_manager.dart';
import 'package:silora/core/constants/values_manager.dart';
import 'package:silora/core/translations/locale_keys.g.dart';
import 'package:silora/features/auth/presentation/manager/auth_cubit.dart';

import '../../../../core/widgets/social_signup_btn.dart';

class SignInSocialSectionWidget extends StatelessWidget {
  const SignInSocialSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthCubit, AuthState, bool>(
      selector: (state) => state is SignInLoading,
      builder: (context, isLoading) {
        final cubit = context.read<AuthCubit>();
        return Row(
          children: [
            Expanded(
              child: SocialSignInButton(
                asset: ImageAssets.google,
                label: LocaleKeys.auth_social_google.tr(),
                onTap: isLoading
                    ? null
                    : () {
                        cubit.signInWithGoogle();
                      },
              ),
            ),
            SizedBox(width: AppSize.s16.w),
            Expanded(
              child: SocialSignInButton(
                asset: ImageAssets.apple,
                label: LocaleKeys.auth_social_apple.tr(),
                onTap: isLoading
                    ? null
                    : () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            LocaleKeys.auth_signIn_appleSignInComingSoon.tr(),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
