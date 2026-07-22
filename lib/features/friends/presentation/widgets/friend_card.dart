import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/constants/font_manager.dart';
import 'package:silora/core/constants/styles_manager.dart';
import 'package:silora/core/constants/values_manager.dart';
import 'package:silora/core/routes/app_routes_names.dart';
import 'package:go_router/go_router.dart';
import 'package:silora/features/auth/data/models/user_model.dart';
import 'package:silora/features/friends/presentation/widgets/friend_base_card.dart';
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
      onTap: () => context.push(AppRouteNames.friendProfile, extra: user),
      subtitle: user.username.isNotEmpty
          ? Text(
              "@${user.username}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getMediumStyle(
                color: ColorManager.neutralGray,
                fontSize: FontSize.s14.sp,
              ),
            )
          : null,
      trailing: Material(
        color: ColorManager.lightGray,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: IconButton(
          onPressed: onChatPressed,
          icon: Icon(
            Icons.chat_bubble_outline_rounded,
            size: AppSize.s22.sp,
            color: ColorManager.nearBlack,
          ),
          constraints: BoxConstraints(
            minWidth: AppSize.s40.w,
            minHeight: AppSize.s40.h,
          ),
        ),
      ),
    );
  }
}
