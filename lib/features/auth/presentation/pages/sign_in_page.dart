import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:silora/core/constants/assets_manager.dart';
import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/constants/font_manager.dart';
import 'package:silora/core/constants/styles_manager.dart';
import 'package:silora/core/constants/values_manager.dart';
import 'package:silora/core/di/injection_container.dart';
import 'package:silora/core/routes/app_routes_names.dart';
import 'package:silora/core/translations/locale_keys.g.dart';
import 'package:silora/core/widgets/custom_dialog.dart';
import 'package:silora/core/widgets/custom_text_btn.dart';
import 'package:silora/features/auth/presentation/manager/auth_cubit.dart';
import 'package:silora/features/auth/presentation/widgets/sign_in_form_card_widget.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [ColorManager.lightBlue, ColorManager.white],
                ),
              ),
              child: BlocListener<AuthCubit, AuthState>(
                listenWhen: (_, state) =>
                    state is SignInSuccess || state is SignInError,
                listener: (context, state) {
                  if (state is SignInSuccess) {
                    if (!context.mounted) return;
                    context.go(AppRouteNames.layout);
                  } else if (state is SignInError) {
                    if (!context.mounted) return;
                    CustomAwesomeDialog.showError(
                      context: context,
                      message: state.errorMessage,
                    );
                  }
                },
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: REdgeInsets.symmetric(
                        horizontal: AppPadding.p24,
                        vertical: AppPadding.p20,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 430),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Center(
                                  child: Image.asset(
                                    ImageAssets.signInBanner,
                                    height: AppSize.s170.h,
                                    fit: BoxFit.contain,
                                    excludeFromSemantics: true,
                                  ),
                                ),
                                SizedBox(height: AppSize.s24.h),

                                SignInFormCardWidget(
                                  formKey: _formKey,
                                  cubit: context.read<AuthCubit>(),
                                ),
                                SizedBox(height: AppSize.s16.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      LocaleKeys.auth_signIn_dontHaveAccount
                                          .tr(),
                                      style: getMediumStyle(
                                        color: ColorManager.gray,
                                        fontSize: FontSize.s14,
                                      ),
                                    ),
                                    CustomTextBtn(
                                      color: ColorManager.blue,
                                      text: LocaleKeys.auth_signIn_signUpText
                                          .tr(),
                                      onPressed: () =>
                                          context.go(AppRouteNames.signUp),
                                    ),
                                  ],
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
            ),
          );
        },
      ),
    );
  }
}
