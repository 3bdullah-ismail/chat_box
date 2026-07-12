import 'package:chat_app/core/constants/color_manager.dart';
import 'package:chat_app/core/constants/font_manager.dart';
import 'package:chat_app/core/constants/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyChats extends StatelessWidget {
  final VoidCallback onStartChat;
  final VoidCallback onDiscoverPeople;

  const EmptyChats({
    super.key,
    required this.onStartChat,
    required this.onDiscoverPeople,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 430.w),
        child: Padding(
          padding: REdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: SizedBox(
                  width: 150.w,
                  height: 150.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 130.w,
                        height: 130.h,
                        decoration: const BoxDecoration(
                          color: Color(0x26CFE7FF),
                          shape: BoxShape.circle,
                        ),
                      ),

                      Container(
                        width: 100.w,
                        height: 100.h,
                        decoration: BoxDecoration(
                          color: ColorManager.white,
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(color: ColorManager.borderGray),
                          boxShadow: [
                            BoxShadow(
                              color: ColorManager.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 40.sp,
                          color: ColorManager.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              Text(
                'No Conversations\nYet',
                textAlign: TextAlign.center,
                style: getBoldStyle(
                  color: ColorManager.black,
                  fontSize: FontSize.s36.sp,
                ).copyWith(height: 1.15, letterSpacing: -1.0),
              ),
              SizedBox(height: 16.h),
              Text(
                'Start a new chat to connect with your friends and colleagues. Your private and group messages will appear here.',
                textAlign: TextAlign.center,
                style: getMediumStyle(
                  color: ColorManager.gray,
                  fontSize: FontSize.s16.sp,
                ).copyWith(height: 1.5),
              ),
              SizedBox(height: 40.h),
              ElevatedButton(
                onPressed: onStartChat,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.black,
                  foregroundColor: ColorManager.white,
                  minimumSize: Size(double.infinity, 48.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Start Chatting',
                  style: getMediumStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s14.sp,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              OutlinedButton(
                onPressed: onDiscoverPeople,
                style: OutlinedButton.styleFrom(
                  foregroundColor: ColorManager.black,
                  side: const BorderSide(color: ColorManager.borderGray),
                  minimumSize: Size(double.infinity, 48.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Discover People',
                  style: getMediumStyle(
                    color: ColorManager.black,
                    fontSize: FontSize.s14.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
