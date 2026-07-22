import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/constants/values_manager.dart';

class ProfileSkeletonView extends StatefulWidget {
  const ProfileSkeletonView({super.key});

  @override
  State<ProfileSkeletonView> createState() => _ProfileSkeletonViewState();
}

class _ProfileSkeletonViewState extends State<ProfileSkeletonView>
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

        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.p24.w,
            vertical: AppPadding.p20.h,
          ),
          child: Column(
            children: [
              Container(
                width: 96.r,
                height: 96.r,
                decoration: shimmer.copyWith(
                  borderRadius: BorderRadius.circular(AppRadius.r999.r),
                ),
              ),
              SizedBox(height: AppSize.s12.h),
              Container(
                width: 140.w,
                height: 24.h,
                decoration: shimmer,
              ),
              SizedBox(height: AppSize.s4.h),
              Container(
                width: 100.w,
                height: 14.h,
                decoration: shimmer,
              ),
              SizedBox(height: AppSize.s12.h),
              Container(
                width: 250.w,
                height: 14.h,
                decoration: shimmer,
              ),
              SizedBox(height: AppSize.s4.h),
              Container(
                width: 200.w,
                height: 14.h,
                decoration: shimmer,
              ),
              SizedBox(height: AppSize.s24.h),

              _buildCardSkeleton(shimmer, height: 160.h),
              SizedBox(height: AppSize.s16.h),
              _buildCardSkeleton(shimmer, height: 60.h),
              SizedBox(height: AppSize.s16.h),
              _buildCardSkeleton(shimmer, height: 60.h),
              SizedBox(height: AppSize.s32.h),
              
              Container(
                width: double.infinity,
                height: 56.h,
                decoration: shimmer.copyWith(
                  borderRadius: BorderRadius.circular(AppRadius.r16.r),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCardSkeleton(BoxDecoration shimmer, {required double height}) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(AppRadius.r16.r),
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
      ),
      padding: EdgeInsets.all(AppPadding.p16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120.w,
            height: 16.h,
            decoration: shimmer,
          ),
          if (height > 100) ...[
            SizedBox(height: AppSize.s16.h),
            Container(
              width: 200.w,
              height: 14.h,
              decoration: shimmer,
            ),
            SizedBox(height: AppSize.s12.h),
            Container(
              width: 150.w,
              height: 14.h,
              decoration: shimmer,
            ),
            SizedBox(height: AppSize.s12.h),
            Container(
              width: 180.w,
              height: 14.h,
              decoration: shimmer,
            ),
          ]
        ],
      ),
    );
  }
}