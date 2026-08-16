import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/constants/font_manager.dart';
import 'package:silora/core/constants/styles_manager.dart';
import 'package:silora/core/constants/values_manager.dart';
import 'package:silora/core/di/injection_container.dart';
import 'package:silora/core/routes/app_routes_names.dart';
import 'package:silora/core/translations/locale_keys.g.dart';
import 'package:silora/core/utils/validators.dart';
import 'package:silora/core/widgets/custom_dialog.dart';
import 'package:silora/core/widgets/custom_elevated_button.dart';
import 'package:silora/core/widgets/custom_text_btn.dart';
import 'package:silora/core/widgets/custom_text_field.dart';
import 'package:silora/features/auth/presentation/manager/auth_cubit.dart';

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
                  padding: REdgeInsets.symmetric(
                    horizontal: AppPadding.p24,
                    vertical: AppSize.s40,
                  ),
                  child: Builder(
                    builder: (context) {
                      final cubit = context.read<AuthCubit>();
                      return Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppSize.s20.verticalSpace,
                            Text(
                              LocaleKeys.auth_resetPassword_title.tr(),
                              style:
                                  getBoldStyle(
                                    color: ColorManager.black,
                                    fontSize: FontSize.s36.sp,
                                  ).copyWith(
                                    letterSpacing: FontLetterSpacing.s22Spacing,
                                  ),
                            ),
                            AppSize.s16.verticalSpace,
                            Text(
                              LocaleKeys.auth_resetPassword_description.tr(),
                              style: getMediumStyle(
                                color: ColorManager.gray,
                                fontSize: FontSize.s16.sp,
                              ).copyWith(height: 1.4),
                            ),
                            AppSize.s40.verticalSpace,
                            Text(
                              LocaleKeys.auth_resetPassword_emailAddressLabel
                                  .tr(),
                              style: getBoldStyle(
                                color: ColorManager.black,
                                fontSize: FontSize.s14.sp,
                              ),
                            ),
                            AppSize.s8.verticalSpace,
                            CustomTextField(
                              controller: cubit.emailController,
                              text: LocaleKeys.auth_resetPassword_emailHint
                                  .tr(),
                              keyboardType: TextInputType.emailAddress,
                              validator: Validators.validateEmail,
                            ),
                            AppSize.s32.verticalSpace,
                            BlocSelector<AuthCubit, AuthState, bool>(
                              selector: (state) =>
                                  state is ResetPasswordLoading,
                              builder: (context, isLoading) {
                                return CustomElevatedButton(
                                  label: isLoading
                                      ? LocaleKeys.auth_resetPassword_sendingBtn
                                            .tr()
                                      : LocaleKeys
                                            .auth_resetPassword_sendResetLinkBtn
                                            .tr(),
                                  suffixIcon: isLoading
                                      ? const SizedBox()
                                      : Icon(
                                          Icons.play_arrow_outlined,
                                          color: ColorManager.white,
                                          size: AppSize.s20.sp,
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
                            AppSize.s32.verticalSpace,
                            const Divider(
                              color: ColorManager.lightGray,
                              thickness: AppSize.s1,
                            ),
                            AppSize.s24.verticalSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  LocaleKeys
                                      .auth_resetPassword_rememberedPassword
                                      .tr(),
                                  style: getMediumStyle(
                                    color: ColorManager.gray,
                                    fontSize: FontSize.s14.sp,
                                  ),
                                ),
                                CustomTextBtn(
                                  text: LocaleKeys.auth_resetPassword_signInText
                                      .tr(),
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
