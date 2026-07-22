import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/constants/styles_manager.dart';
import 'package:silora/core/constants/values_manager.dart';
import 'package:silora/core/widgets/custom_elevated_button.dart';
import 'package:silora/features/auth/data/models/user_model.dart';
import 'package:go_router/go_router.dart';
import 'package:silora/core/routes/app_routes_names.dart';
import 'package:silora/features/friends/presentation/widgets/friend_base_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:silora/core/translations/locale_keys.g.dart';

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
      onTap: () => context.push(AppRouteNames.friendProfile, extra: user),
      avatarSize: AppSize.s40,
      borderRadius: AppRadius.r12,
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p16.w,
        vertical: AppPadding.p12.h,
      ),
      avatarChild: const Icon(Icons.person, color: ColorManager.gray),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (user.username.isNotEmpty)
            Text(
              "@${user.username}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getMediumStyle(color: ColorManager.gray, fontSize: 14.sp),
            ),
          if (user.username.isNotEmpty) SizedBox(height: 2.h),
          Text(
            LocaleKeys.friends_cards_mutualFriend.tr(),
            style: getBoldStyle(color: ColorManager.gray, fontSize: 12.sp),
          ),
        ],
      ),
      trailing: CustomElevatedButton(
        label: LocaleKeys.friends_cards_addFriendBtn.tr(),
        width: 120.w,
        height: 46.h,
        onTap: onAddPressed,
      ),
    );
  }
}
