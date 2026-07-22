import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:load_switch/load_switch.dart';
import 'package:silora/core/constants/font_manager.dart';
import 'package:silora/core/translations/locale_keys.g.dart';

import '../../../../core/constants/color_manager.dart';
import '../../../../core/constants/styles_manager.dart';
import '../../../../core/constants/values_manager.dart';

class NotificationsCard extends StatefulWidget {
  const NotificationsCard({super.key});

  @override
  State<NotificationsCard> createState() => _NotificationsCardState();
}

class _NotificationsCardState extends State<NotificationsCard> {
  bool _enabled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p16.w,
        vertical: AppSize.s6.h,
      ),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.r16.r),
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
          LocaleKeys.profile_notifications_title.tr(),
          style: getMediumStyle(
            color: ColorManager.black,
            fontSize: FontSize.s16.sp,
          ),
        ),
        trailing: LoadSwitch.managed(
          style: SpinStyle.cupertino,
          height: AppSize.s28.h,
          width: 56.w,
          switchDecoration: (value, isActive) => BoxDecoration(
            color: isActive
                ? (value ? ColorManager.blue : ColorManager.lightGray)
                : ColorManager.blue,
            borderRadius: BorderRadius.circular(AppRadius.r30.r),
          ),
          value: _enabled,
          onToggle: () async {
            await Future.delayed(const Duration(seconds: 2));
            return !_enabled;
          },
          onChanged: (nextValue) {
            setState(() {
              _enabled = nextValue;
            });
          },
        ),
      ),
    );
  }
}
