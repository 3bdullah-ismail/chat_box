import 'package:chat_app/core/constants/color_manager.dart';
import 'package:chat_app/core/constants/styles_manager.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/friends/presentation/widgets/friend_base_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FriendCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onChatPressed;

  const FriendCard({super.key, required this.user, this.onChatPressed});

  @override
  Widget build(BuildContext context) {
    return FriendBaseCard(
      title: user.name,
      subtitle: Text(
        "@${user.username}",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: getMediumStyle(color: ColorManager.neutralGray, fontSize: 14.sp),
      ),
      trailing: Material(
        color: ColorManager.lightGray,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: IconButton(
          onPressed: onChatPressed,
          icon: Icon(
            Icons.chat_bubble_outline_rounded,
            size: 22.sp,
            color: ColorManager.nearBlack,
          ),
          constraints: BoxConstraints(minWidth: 40.w, minHeight: 40.h),
        ),
      ),
    );
  }
}
