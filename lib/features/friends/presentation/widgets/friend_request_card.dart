import 'package:chat_app/core/constants/color_manager.dart';
import 'package:chat_app/core/constants/styles_manager.dart';
import 'package:chat_app/core/widgets/custom_elevated_button.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/friends/presentation/widgets/friend_base_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      padding: isCompact ? null : EdgeInsets.all(16.w),
      subtitle: Text(
        "@${user.username}",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: getMediumStyle(color: ColorManager.neutralGray, fontSize: 14.sp),
      ),
      trailing: isCompact ? _buildCompactButtons() : null,
      bottom: !isCompact ? _buildExpandedButtons() : null,
    );
  }

  Widget? _buildCompactButtons() {
    if (!isReceived) return null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 6.w,
      children: [
        CustomElevatedButton(
          label: "Accept",
          width: 75.w,
          height: 36.h,
          backgroundColor: ColorManager.black,
          textStyle: getMediumStyle(color: ColorManager.white, fontSize: 13.sp),
          onTap: onAccept ?? () {},
        ),
        SizedBox(
          width: 75.w,
          height: 36.h,
          child: TextButton(
            onPressed: onDecline ?? () {},
            style: TextButton.styleFrom(
              backgroundColor: ColorManager.lightGray,
              foregroundColor: ColorManager.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.zero,
            ),
            child: Text(
              "Decline",
              style: getMediumStyle(color: ColorManager.error, fontSize: 13.sp),
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
              label: "Accept",
              height: 44.h,
              backgroundColor: ColorManager.black,
              textStyle: getMediumStyle(
                color: ColorManager.white,
                fontSize: 14.sp,
              ),
              onTap: onAccept ?? () {},
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: OutlinedButton(
              onPressed: onDecline ?? () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: ColorManager.borderGray),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                backgroundColor: ColorManager.white,
                fixedSize: Size.fromHeight(44.h),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                "Decline",
                style: getMediumStyle(
                  color: ColorManager.nearBlack,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return CustomElevatedButton(
        label: "Cancel Request",
        height: 44.h,
        backgroundColor: ColorManager.lightGray,
        textStyle: getMediumStyle(
          color: ColorManager.nearBlack,
          fontSize: 14.sp,
        ),
        onTap: onCancel ?? () {},
      );
    }
  }
}
