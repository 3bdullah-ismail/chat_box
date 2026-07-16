import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/constants/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/font_manager.dart';
import '../../../../core/constants/styles_manager.dart';
import '../../../../core/widgets/custom_text_btn.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../widgets/skeleton_list_widget.dart';

class FriendsSkeletonView extends StatelessWidget {
  const FriendsSkeletonView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p24.w,
        vertical: AppPadding.p20.h,
      ),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Text(
          'Friends',
          style: getBoldStyle(
            color: ColorManager.black,
            fontSize: FontSize.s24.sp,
          ),
        ),
        SizedBox(height: AppSize.s20.h),
        CustomTextField(
          text: "Search by username, email, or phone",
          controller: controller,
        ),
        SizedBox(height: AppSize.s24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Friend Requests",
              style: getBoldStyle(
                color: ColorManager.black,
                fontSize: FontSize.s18.sp,
              ),
            ),
            CustomTextBtn(
              text: "View All",
              onPressed: () {},
              color: ColorManager.black.withValues(alpha: 0.3),
            ),
          ],
        ),
        SizedBox(height: AppSize.s8.h),
        const SkeletonListWidget(
          type: SkeletonType.friendRequestCompact,
          count: 1,
        ),
        SizedBox(height: AppSize.s24.h),
        Text(
          "Your Friends",
          style: getBoldStyle(
            color: ColorManager.black,
            fontSize: FontSize.s18.sp,
          ),
        ),
        SizedBox(height: AppSize.s12.h),
        const SkeletonListWidget(type: SkeletonType.friend, count: 3),
      ],
    );
  }
}
