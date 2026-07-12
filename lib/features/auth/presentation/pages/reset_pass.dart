import 'package:chat_app/core/constants/color_manager.dart';
import 'package:chat_app/core/constants/font_manager.dart';
import 'package:chat_app/core/constants/styles_manager.dart';
import 'package:chat_app/core/di/injection_container.dart';
import 'package:chat_app/core/routes/app_routes_names.dart';
import 'package:chat_app/core/utils/validators.dart';
import 'package:chat_app/core/widgets/custom_dialog.dart';
import 'package:chat_app/core/widgets/custom_elevated_button.dart';
import 'package:chat_app/core/widgets/custom_text_btn.dart';
import 'package:chat_app/core/widgets/custom_text_field.dart';
import 'package:chat_app/features/auth/presentation/manager/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ResetPassWord extends StatefulWidget {
  const ResetPassWord({super.key});

  @override
  State<ResetPassWord> createState() => _ResetPassWordState();
}

class _ResetPassWordState extends State<ResetPassWord> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: Scaffold(
        body: BlocListener<AuthCubit, AuthState>(
          listenWhen: (_, state) =>
              state is ResetPasswordSuccess || state is ResetPasswordError,
          listener: (context, state) {
            if (!context.mounted) return;

            if (state is ResetPasswordSuccess) {
              CustomAwesomeDialog.showSuccess(
                context: context,
                message: state.message,
                btnOkOnPress: () => context.go(AppRouteNames.signIn),
              );
            } else if (state is ResetPasswordError) {
              CustomAwesomeDialog.showError(
                context: context,
                message: state.errorMessage,
              );
            }
          },
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [ColorManager.lightBlue, ColorManager.white],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: REdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  child: Builder(
                    builder: (context) {
                      final cubit = context.read<AuthCubit>();
                      return Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            20.verticalSpace,
                            Text(
                              "Reset Password",
                              style: getBoldStyle(
                                color: ColorManager.black,
                                fontSize: FontSize.s36.sp,
                              ).copyWith(letterSpacing: -0.5),
                            ),
                            16.verticalSpace,
                            Text(
                              "Enter the email address associated with your account and we'll send you a link to reset your password.",
                              style: getMediumStyle(
                                color: ColorManager.gray,
                                fontSize: FontSize.s16.sp,
                              ).copyWith(height: 1.4),
                            ),
                            40.verticalSpace,
                            Text(
                              "Email Address",
                              style: getBoldStyle(
                                color: ColorManager.black,
                                fontSize: FontSize.s14.sp,
                              ),
                            ),
                            8.verticalSpace,
                            CustomTextField(
                              controller: cubit.emailController,
                              text: "name@company.com",
                              keyboardType: TextInputType.emailAddress,
                              validator: Validators.validateEmail,
                            ),
                            32.verticalSpace,
                            BlocSelector<AuthCubit, AuthState, bool>(
                              selector: (state) =>
                                  state is ResetPasswordLoading,
                              builder: (context, isLoading) {
                                return CustomElevatedButton(
                                  label: isLoading
                                      ? "Sending..."
                                      : "Send Reset Link",
                                  suffixIcon: isLoading
                                      ? const SizedBox()
                                      : Icon(
                                          Icons.play_arrow_outlined,
                                          color: ColorManager.white,
                                          size: 20.sp,
                                        ),
                                  onTap: isLoading
                                      ? null
                                      : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            cubit.resetPassword();
                                          }
                                        },
                                );
                              },
                            ),
                            32.verticalSpace,
                            const Divider(
                              color: ColorManager.lightGray,
                              thickness: 1,
                            ),
                            24.verticalSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Remembered your password? ",
                                  style: getMediumStyle(
                                    color: ColorManager.gray,
                                    fontSize: FontSize.s14.sp,
                                  ),
                                ),
                                CustomTextBtn(
                                  text: "Sign in",
                                  fontSize: FontSize.s14.sp,
                                  color: ColorManager.black,
                                  onPressed: () =>
                                      context.go(AppRouteNames.signIn),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
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
