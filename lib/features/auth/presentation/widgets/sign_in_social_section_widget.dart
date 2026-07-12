import 'package:chat_app/core/constants/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/social_signup_btn.dart';
import 'package:chat_app/features/auth/presentation/manager/auth_cubit.dart';

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
                label: 'Google',
                onTap: isLoading
                    ? null
                    : () {
                        cubit.signInWithGoogle();
                      },
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: SocialSignInButton(
                asset: ImageAssets.apple,
                label: 'Apple',
                onTap: isLoading
                    ? null
                    : () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Apple Sign-In coming soon'),
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
