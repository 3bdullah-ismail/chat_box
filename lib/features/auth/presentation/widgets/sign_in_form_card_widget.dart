import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/constants/font_manager.dart';
import 'package:silora/core/constants/styles_manager.dart';
import 'package:silora/core/constants/values_manager.dart';
import 'package:silora/core/routes/app_routes_names.dart';
import 'package:silora/features/auth/presentation/manager/auth_cubit.dart';
import 'package:silora/features/auth/presentation/widgets/sign_in_social_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/custom_text_btn.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/or_divider.dart';

class SignInFormCardWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final AuthCubit cubit;

  const SignInFormCardWidget({
    super.key,
    required this.formKey,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: REdgeInsets.all(AppPadding.p24),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        boxShadow: [
          BoxShadow(
            color: ColorManager.gray.withValues(alpha: 0.2),
            blurRadius: AppSize.s10,
            offset: const Offset(0, AppSize.s4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sign In',
            style: getBoldStyle(
              color: ColorManager.black,
              fontSize: FontSize.s36,
            ),
          ),
          SizedBox(height: AppSize.s8.h),
          Text(
            'Welcome back. Enter your details to\ncontinue.',
            style: getMediumStyle(
              color: ColorManager.lightGray,
              fontSize: FontSize.s16,
            ),
          ),
          SizedBox(height: AppSize.s24.h),
          Text(
            'EMAIL ADDRESS',
            style: getBoldStyle(
              color: ColorManager.gray,
              fontSize: FontSize.s11,
            ),
          ),
          SizedBox(height: AppSize.s8.h),
          CustomTextField(
            controller: cubit.emailController,
            text: 'name@company.com',
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
          ),

          SizedBox(height: AppSize.s16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PASSWORD',
                style: getBoldStyle(
                  color: ColorManager.gray,
                  fontSize: FontSize.s11,
                ),
              ),
              CustomTextBtn(
                color: ColorManager.blue,
                text: 'Forgot Password?',
                fontSize: FontSize.s14,
                fontWeight: FontWeightManager.bold,
                onPressed: () => context.go(AppRouteNames.resetPassWord),
              ),
            ],
          ),

          CustomTextField(
            controller: cubit.passwordController,
            text: 'Enter your password',
            isPass: true,
            validator: Validators.validatePassword,
          ),

          SizedBox(height: AppSize.s24.h),
          BlocSelector<AuthCubit, AuthState, bool>(
            selector: (state) => state is SignInLoading,
            builder: (context, isLoading) {
              return CustomElevatedButton(
                label: isLoading ? 'Signing In...' : 'Sign In',
                onTap: isLoading
                    ? null
                    : () {
                        if (formKey.currentState!.validate()) {
                          cubit.signInWithEmailAndPassword();
                        }
                      },
              );
            },
          ),

          SizedBox(height: AppSize.s20.h),
          const OrDivider(text: 'OR CONTINUE WITH'),
          SizedBox(height: AppSize.s20.h),
          const SignInSocialSectionWidget(),
        ],
      ),
    );
  }
}
