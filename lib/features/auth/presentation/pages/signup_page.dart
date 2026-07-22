import 'package:silora/core/constants/assets_manager.dart';
import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/constants/font_manager.dart';
import 'package:silora/core/constants/styles_manager.dart';
import 'package:silora/core/constants/values_manager.dart';
import 'package:silora/core/di/injection_container.dart';
import 'package:silora/core/routes/app_routes_names.dart';
import 'package:silora/core/utils/validators.dart';
import 'package:silora/core/widgets/custom_elevated_button.dart';
import 'package:silora/core/widgets/custom_text_btn.dart';
import 'package:silora/core/widgets/custom_text_field.dart';
import 'package:silora/core/widgets/or_divider.dart';
import 'package:silora/core/widgets/social_signup_btn.dart';
import 'package:silora/features/auth/presentation/manager/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:silora/core/translations/locale_keys.g.dart';

import '../../../../core/widgets/custom_dialog.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();

  Widget _buildFieldLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppPadding.p8.h),
      child: Text(
        text,
        style: getBoldStyle(
          color: ColorManager.black,
          fontSize: FontSize.s14.sp,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: Scaffold(
        body: BlocListener<AuthCubit, AuthState>(
          listenWhen: (_, state) =>
              state is SignUpSuccess ||
              state is SignUpError ||
              state is VerificationEmailSuccess ||
              state is VerificationEmailError ||
              state is SignInSuccess ||
              state is SignInError,
          listener: (context, state) {
            if (!context.mounted) return;
            if (state is SignUpError ||
                state is VerificationEmailError ||
                state is SignInError) {
              final errorMessage = (state as dynamic).errorMessage;
              CustomAwesomeDialog.showError(
                context: context,
                message: errorMessage,
              );
            } else if (state is SignUpSuccess) {
              Future.microtask(context.read<AuthCubit>().verificationEmail);
            } else if (state is VerificationEmailSuccess) {
              CustomAwesomeDialog.showSuccess(
                context: context,
                message: state.message,
                title: LocaleKeys.auth_signUp_verificationEmailSent.tr(),
                btnOkOnPress: () => context.go(AppRouteNames.signIn),
              );
            } else if (state is SignInSuccess) {
              context.go(AppRouteNames.layout);
            }
          },
          child: Builder(
            builder: (context) {
              final cubit = context.read<AuthCubit>();
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: REdgeInsets.all(AppPadding.p24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: AppSize.s12.h),
                          Center(
                            child: Text(
                              LocaleKeys.auth_signUp_title.tr(),
                              style: getBoldStyle(
                                color: ColorManager.black,
                                fontSize: FontSize.s36.sp,
                              ),
                            ),
                          ),
                          SizedBox(height: AppSize.s8.h),
                          Center(
                            child: Text(
                              LocaleKeys.auth_signUp_description.tr(),
                              textAlign: TextAlign.center,
                              style: getRegularStyle(
                                color: ColorManager.lightGray,
                                fontSize: FontSize.s16.sp,
                              ),
                            ),
                          ),
                          SizedBox(height: AppSize.s32.h),
                          _buildFieldLabel(LocaleKeys.auth_signUp_nameLabel.tr()),
                          CustomTextField(
                            controller: cubit.nameController,
                            text: LocaleKeys.auth_signUp_nameHint.tr(),
                          ),
                          SizedBox(height: AppSize.s20.h),

                          _buildFieldLabel(LocaleKeys.auth_signUp_usernameLabel.tr()),
                          CustomTextField(
                            controller: cubit.usernameController,
                            text: LocaleKeys.auth_signUp_usernameHint.tr(),
                            validator: Validators.validateUsername,
                          ),
                          SizedBox(height: AppSize.s20.h),

                          _buildFieldLabel(LocaleKeys.auth_signUp_emailLabel.tr()),
                          CustomTextField(
                            controller: cubit.emailController,
                            text: LocaleKeys.auth_signUp_emailHint.tr(),
                            validator: Validators.validateEmail,
                          ),
                          SizedBox(height: AppSize.s20.h),

                          _buildFieldLabel(LocaleKeys.auth_signUp_passwordLabel.tr()),
                          CustomTextField(
                            controller: cubit.passwordController,
                            validator: Validators.validatePassword,
                            text: LocaleKeys.auth_signUp_passwordHint.tr(),
                            isPass: true,
                          ),
                          SizedBox(height: AppSize.s20.h),

                          _buildFieldLabel(LocaleKeys.auth_signUp_confirmPasswordLabel.tr()),
                          CustomTextField(
                            isPass: true,
                            controller: cubit.confirmPasswordController,
                            text: LocaleKeys.auth_signUp_passwordHint.tr(),
                            validator: (value) =>
                                Validators.validateConfirmPassword(
                                  value,
                                  cubit.passwordController.text,
                                ),
                          ),
                          SizedBox(height: AppSize.s32.h),
                          BlocSelector<AuthCubit, AuthState, bool>(
                            selector: (state) =>
                                state is SignUpLoading ||
                                state is VerificationEmailLoading,
                            builder: (context, isLoading) {
                              return CustomElevatedButton(
                                label: isLoading ? LocaleKeys.auth_signUp_signingUpBtn.tr() : LocaleKeys.auth_signUp_signUpBtn.tr(),
                                onTap: isLoading
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          cubit.signUpWithEmailAndPassword();
                                        }
                                      },
                              );
                            },
                          ),
                          SizedBox(height: AppSize.s24.h),
                          OrDivider(text: LocaleKeys.auth_signUp_socialIdentity.tr()),
                          SizedBox(height: AppSize.s16.h),
                          BlocSelector<AuthCubit, AuthState, bool>(
                            selector: (state) =>
                                state is SignUpLoading ||
                                state is SignInLoading,
                            builder: (context, isLoading) {
                              return SocialSignInButton(
                                asset: ImageAssets.google,
                                label: LocaleKeys.auth_social_google.tr(),
                                onTap: isLoading
                                    ? null
                                    : () => cubit.signInWithGoogle(),
                              );
                            },
                          ),
                          SizedBox(height: AppSize.s24.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                LocaleKeys.auth_signUp_alreadyHaveAccount.tr(),
                                style: getBoldStyle(
                                  color: ColorManager.black,
                                  fontSize: FontSize.s14.sp,
                                ),
                              ),
                              CustomTextBtn(
                                text: LocaleKeys.auth_signUp_signInText.tr(),
                                onPressed: () =>
                                    context.go(AppRouteNames.signIn),
                                color: ColorManager.blue,
                              ),
                            ],
                          ),
                          SizedBox(height: AppSize.s24.h),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              LocaleKeys.auth_signUp_termsAndPrivacy.tr(),
                              textAlign: TextAlign.center,
                              style: getRegularStyle(
                                color: ColorManager.gray,
                                fontSize: FontSize.s11.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
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
