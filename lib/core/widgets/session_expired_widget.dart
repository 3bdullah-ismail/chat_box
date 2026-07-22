import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/constants/font_manager.dart';
import 'package:silora/core/constants/styles_manager.dart';
import 'package:silora/core/constants/values_manager.dart';
import 'package:silora/core/routes/app_routes_names.dart';
import 'package:silora/core/widgets/custom_elevated_button.dart';
import 'package:silora/features/auth/presentation/manager/auth_cubit.dart';

class SessionExpiredWidget extends StatelessWidget {
  const SessionExpiredWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppPadding.p24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_clock_rounded,
              size: 80.r,
              color: ColorManager.danger,
            ),
            SizedBox(height: AppSize.s16.h),
            Text(
              "Session Expired",
              style: getBoldStyle(
                color: ColorManager.black,
                fontSize: FontSize.s20.sp,
              ),
            ),
            SizedBox(height: AppSize.s8.h),
            Text(
              "Your session has expired. Please sign in again to continue.",
              textAlign: TextAlign.center,
              style: getRegularStyle(
                color: ColorManager.gray,
                fontSize: FontSize.s14.sp,
              ),
            ),
            SizedBox(height: AppSize.s24.h),
            CustomElevatedButton(
              label: "Sign in",
              onTap: () {
                context.read<AuthCubit>().signOut();
                context.go(AppRouteNames.signIn);
              },
            ),
          ],
        ),
      ),
    );
  }
}
