import 'package:chat_app/core/constants/color_manager.dart';
import 'package:chat_app/core/constants/styles_manager.dart';
import 'package:chat_app/core/widgets/custom_elevated_button.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/friends/presentation/widgets/friend_base_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddFriendCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback onAddPressed;

  const AddFriendCard({
    super.key,
    required this.user,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FriendBaseCard(
      title: user.name,
      avatarSize: 40.0,
      borderRadius: 12.0,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      avatarChild: const Icon(Icons.person, color: ColorManager.gray),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "@${user.username}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getMediumStyle(color: ColorManager.gray, fontSize: 14.sp),
          ),
          SizedBox(height: 2.h),
          Text(
            "Mutual Friend",
            style: getBoldStyle(color: ColorManager.gray, fontSize: 12.sp),
          ),
        ],
      ),
      trailing: CustomElevatedButton(
        label: "Add Friend",
        width: 120.w,
        height: 46.h,
        onTap: onAddPressed,
      ),
    );
  }
}
