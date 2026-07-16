import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/constants/font_manager.dart';
import 'package:silora/core/constants/styles_manager.dart';
import 'package:silora/core/constants/values_manager.dart';
import 'package:silora/core/routes/app_routes_names.dart';
import 'package:silora/core/widgets/custom_elevated_button.dart';
import 'package:silora/core/widgets/custom_text_btn.dart';
import 'package:silora/features/friends/presentation/widgets/empty_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class FriendsEmptyState extends StatelessWidget {
  const FriendsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p24.w,
        vertical: AppPadding.p20.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Friends',
            style: getBoldStyle(
              color: ColorManager.black,
              fontSize: FontSize.s24.sp,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: AppSize.s24.h,
              children: [
                const EmptyCard(),

                Column(
                  spacing: AppSize.s12.h,
                  children: [
                    Text(
                      "No Friends Yet",
                      textAlign: TextAlign.center,
                      style: getBoldStyle(
                        color: ColorManager.black,
                        fontSize: FontSize.s24.sp,
                      ),
                    ),
                    Text(
                      "You haven't added any friends yet. Start\nconnecting with people to chat, call and\nshare moments together.",
                      textAlign: TextAlign.center,
                      style: getMediumStyle(
                        color: ColorManager.gray,
                        fontSize: FontSize.s14.sp,
                      ),
                    ),
                  ],
                ),

                Column(
                  spacing: AppSize.s12.h,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: CustomElevatedButton(
                        label: "Add Friends",
                        onTap: () => context.push(AppRouteNames.addFriends),
                        prefixIcon: const Icon(Icons.person_add_alt),
                      ),
                    ),
                    CustomTextBtn(
                      text: "View Sent/Received Requests",
                      onPressed: () =>
                          context.push(AppRouteNames.friendRequest),
                      color: ColorManager.nearBlack,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
