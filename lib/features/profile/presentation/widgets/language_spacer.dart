import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/constants/font_manager.dart';
import 'package:silora/core/constants/styles_manager.dart';
import 'package:silora/core/constants/values_manager.dart';

class LanguageSpacer extends StatelessWidget {
  const LanguageSpacer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale.languageCode;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p16.w,
        vertical: AppSize.s6.h,
      ),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(color: ColorManager.borderGray, width: AppSize.s1.w),
        boxShadow: [
          BoxShadow(
            color: ColorManager.gray.withValues(alpha: .04),
            blurRadius: AppSize.s10.r,
            offset: const Offset(0, AppSize.s2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          currentLocale == 'ar' ? 'اللغة' : 'Language',
          style: getMediumStyle(
            color: ColorManager.black,
            fontSize: FontSize.s16.sp,
          ),
        ),
        trailing: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: currentLocale,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: ColorManager.gray,
              size: AppSize.s24.r,
            ),
            style: getMediumStyle(
              color: ColorManager.black,
              fontSize: FontSize.s14.sp,
            ),
            onChanged: (String? newValue) {
              if (newValue != null && newValue != currentLocale) {
                context.setLocale(Locale(newValue));
              }
            },
            items: const [
              DropdownMenuItem<String>(
                value: 'en',
                child: Text('English 🇺🇸'),
              ),
              DropdownMenuItem<String>(
                value: 'ar',
                child: Text('العربية 🇪🇬'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
