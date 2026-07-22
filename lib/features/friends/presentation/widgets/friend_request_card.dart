import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/constants/font_manager.dart';
import 'package:silora/core/constants/styles_manager.dart';
import 'package:silora/core/constants/values_manager.dart';
import 'package:silora/core/widgets/custom_elevated_button.dart';
import 'package:silora/features/auth/data/models/user_model.dart';
import 'package:silora/features/friends/presentation/widgets/friend_base_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:silora/core/translations/locale_keys.g.dart';

class FriendRequestCard extends StatelessWidget {
  final UserModel user;
  final bool isReceived;
  final bool isCompact;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final VoidCallback? onCancel;

  const FriendRequestCard({
    super.key,
    required this.user,
    this.isReceived = true,
    this.isCompact = true,
    this.onAccept,
    this.onDecline,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return FriendBaseCard(
      title: user.name,
      avatarSize: isCompact ? 48.0 : 54.0,
      padding: isCompact ? null : EdgeInsets.all(AppPadding.p16.w),
      subtitle: Text(
        "@${user.username}",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: getMediumStyle(
          color: ColorManager.neutralGray,
          fontSize: FontSize.s14.sp,
        ),
      ),
      trailing: isCompact ? _buildCompactButtons() : null,
      bottom: !isCompact ? _buildExpandedButtons() : null,
    );
  }

  Widget? _buildCompactButtons() {
    if (!isReceived) return null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSize.s6.w,
      children: [
        CustomElevatedButton(
          label: LocaleKeys.friends_cards_acceptBtn.tr(),
          width: 75.w,
          height: AppSize.s36.h,
          backgroundColor: ColorManager.black,
          textStyle: getMediumStyle(
            color: ColorManager.white,
            fontSize: FontSize.s13.sp,
          ),
          onTap: onAccept ?? () {},
        ),
        SizedBox(
          width: 75.w,
          height: AppSize.s36.h,
          child: TextButton(
            onPressed: onDecline ?? () {},
            style: TextButton.styleFrom(
              backgroundColor: ColorManager.lightGray,
              foregroundColor: ColorManager.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.r8.r),
              ),
              padding: EdgeInsets.zero,
            ),
            child: Text(
              LocaleKeys.friends_cards_declineBtn.tr(),
              style: getMediumStyle(
                color: ColorManager.error,
                fontSize: FontSize.s13.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedButtons() {
    if (isReceived) {
      return Row(
        children: [
          Expanded(
            child: CustomElevatedButton(
              label: LocaleKeys.friends_cards_acceptBtn.tr(),
              height: AppSize.s44.h,
              backgroundColor: ColorManager.black,
              textStyle: getMediumStyle(
                color: ColorManager.white,
                fontSize: FontSize.s14.sp,
              ),
              onTap: onAccept ?? () {},
            ),
          ),
          SizedBox(width: AppSize.s12.w),
          Expanded(
            child: OutlinedButton(
              onPressed: onDecline ?? () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: ColorManager.borderGray),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.r8.r),
                ),
                backgroundColor: ColorManager.white,
                fixedSize: Size.fromHeight(AppSize.s44.h),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                LocaleKeys.friends_cards_declineBtn.tr(),
                style: getMediumStyle(
                  color: ColorManager.nearBlack,
                  fontSize: FontSize.s14.sp,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return CustomElevatedButton(
        label: LocaleKeys.friends_cards_cancelRequestBtn.tr(),
        height: AppSize.s44.h,
        backgroundColor: ColorManager.lightGray,
        textStyle: getMediumStyle(
          color: ColorManager.nearBlack,
          fontSize: FontSize.s14.sp,
        ),
        onTap: onCancel ?? () {},
      );
    }
  }
}
