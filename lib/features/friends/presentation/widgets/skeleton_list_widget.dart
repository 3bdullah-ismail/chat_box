import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/constants/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum SkeletonType {
  friend,
  friendRequestCompact,
  friendRequestExpanded,
  addFriend,
  chatsList,
}

class SkeletonListWidget extends StatefulWidget {
  final SkeletonType type;
  final int count;

  const SkeletonListWidget({
    super.key,
    this.type = SkeletonType.friend,
    this.count = 4,
  });

  @override
  State<SkeletonListWidget> createState() => _SkeletonListWidgetState();
}

class _SkeletonListWidgetState extends State<SkeletonListWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final double slidePercent = _controller.value;
        final BoxDecoration shimmer = BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-2.0 + (slidePercent * 4.0), 0.0),
            end: Alignment(0.0 + (slidePercent * 4.0), 0.0),
            colors: const [
              ColorManager.surfaceGray,
              ColorManager.white,
              ColorManager.surfaceGray,
            ],
            stops: const [0.3, 0.5, 0.7],
          ),
          borderRadius: BorderRadius.circular(AppRadius.r8.r),
        );
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.count,
          separatorBuilder: (context, index) =>
              widget.type == SkeletonType.chatsList
              ? Divider(
                  color: ColorManager.borderGray.withValues(alpha: 0.3),
                  height: AppSize.s1.h,
                  thickness: AppSize.s1,
                )
              : SizedBox(height: AppSize.s12.h),
          itemBuilder: (context, index) => _buildItem(widget.type, shimmer),
        );
      },
    );
  }

  Widget _buildItem(SkeletonType type, BoxDecoration shimmer) {
    final bool isExpanded = type == SkeletonType.friendRequestExpanded;
    final bool isAddFriend = type == SkeletonType.addFriend;
    final bool isSimpleList = type == SkeletonType.chatsList;

    final cardDecoration = isSimpleList
        ? const BoxDecoration(color: ColorManager.white)
        : BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.circular(
              isAddFriend ? AppRadius.r12.r : AppRadius.r16.r,
            ),
            border: Border.all(
              color: ColorManager.borderGray.withValues(alpha: 0.8),
            ),
            boxShadow: [
              BoxShadow(
                color: ColorManager.black.withValues(alpha: 0.03),
                blurRadius: AppSize.s12,
                offset: const Offset(0, AppSize.s6),
              ),
            ],
          );

    final textColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width:
              (isExpanded
                      ? 120
                      : isAddFriend
                      ? 100
                      : isSimpleList
                      ? 70
                      : 90)
                  .w,
          height: AppSize.s14.h,
          decoration: shimmer,
        ),
        SizedBox(height: AppSize.s8.h),
        Container(
          width:
              (isExpanded
                      ? 160
                      : isAddFriend
                      ? 120
                      : isSimpleList
                      ? 130
                      : 140)
                  .w,
          height: AppSize.s10.h,
          decoration: shimmer,
        ),
        if (isAddFriend) ...[
          SizedBox(height: AppSize.s4.h),
          Container(width: 80.w, height: AppSize.s10.h, decoration: shimmer),
        ],
      ],
    );
    final Widget? trailingWidget = switch (type) {
      SkeletonType.friend => Container(
        width: AppSize.s40.w,
        height: AppSize.s40.h,
        decoration: shimmer.copyWith(
          borderRadius: BorderRadius.circular(AppRadius.r999.r),
        ),
      ),
      SkeletonType.friendRequestCompact => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 75.w,
            height: AppSize.s36.h,
            decoration: shimmer.copyWith(
              borderRadius: BorderRadius.circular(AppRadius.r12.r),
            ),
          ),
          SizedBox(width: AppSize.s6.w),
          Container(
            width: 75.w,
            height: AppSize.s36.h,
            decoration: shimmer.copyWith(
              borderRadius: BorderRadius.circular(AppRadius.r12.r),
            ),
          ),
        ],
      ),
      SkeletonType.addFriend => Container(
        width: AppSize.s120.w,
        height: 46.h,
        decoration: shimmer.copyWith(
          borderRadius: BorderRadius.circular(AppRadius.r12.r),
        ),
      ),
      SkeletonType.chatsList => Container(
        width: 35.w,
        height: AppSize.s14.h,
        decoration: shimmer.copyWith(
          borderRadius: BorderRadius.circular(AppRadius.r4.r),
        ),
      ),
      _ => null,
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSimpleList ? AppPadding.p8.w : AppPadding.p16.w,
        vertical: isSimpleList
            ? AppPadding.p18.h
            : (isExpanded ? AppPadding.p16.h : AppPadding.p12.h),
      ),
      decoration: cardDecoration,
      child: isExpanded
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 54.w,
                      height: 54.h,
                      decoration: shimmer.copyWith(
                        borderRadius: BorderRadius.circular(AppRadius.r999.r),
                      ),
                    ),
                    SizedBox(width: AppSize.s12.w),
                    Expanded(child: textColumn),
                  ],
                ),
                SizedBox(height: AppSize.s16.h),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: AppSize.s44.h,
                        decoration: shimmer.copyWith(
                          borderRadius: BorderRadius.circular(AppRadius.r12.r),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSize.s12.w),
                    Expanded(
                      child: Container(
                        height: AppSize.s44.h,
                        decoration: shimmer.copyWith(
                          borderRadius: BorderRadius.circular(AppRadius.r12.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Container(
                  width:
                      (isSimpleList
                              ? AppSize.s44
                              : (isAddFriend ? AppSize.s40 : AppSize.s48))
                          .w,
                  height:
                      (isSimpleList
                              ? AppSize.s44
                              : (isAddFriend ? AppSize.s40 : AppSize.s48))
                          .h,
                  decoration: shimmer.copyWith(
                    borderRadius: BorderRadius.circular(AppRadius.r999.r),
                  ),
                ),
                SizedBox(width: AppSize.s14.w),
                Expanded(child: textColumn),
                if (trailingWidget != null) ...[
                  SizedBox(width: AppSize.s8.w),
                  trailingWidget,
                ],
              ],
            ),
    );
  }
}
