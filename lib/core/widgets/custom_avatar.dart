import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/color_manager.dart';
import '../../../../core/constants/styles_manager.dart';

class CustomAvatar extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String? fallbackLetter;
  final Widget? avatarChild;
  final double avatarSize;

  const CustomAvatar({
    super.key,
    required this.title,
    this.imageUrl,
    this.fallbackLetter,
    this.avatarChild,
    this.avatarSize = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    final firstLetter =
        fallbackLetter ??
        (title.trim().isNotEmpty ? title.trim()[0].toUpperCase() : 'A');

    return Container(
      height: avatarSize.h,
      width: avatarSize.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorManager.borderGray,
        image: imageUrl != null && imageUrl!.isNotEmpty
            ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
            : null,
      ),
      child:
          avatarChild ??
          ((imageUrl == null || imageUrl!.isEmpty)
              ? Center(
                  child: Text(
                    firstLetter,
                    style: getBoldStyle(
                      color: ColorManager.nearBlack,
                      fontSize: (avatarSize * 0.35).sp,
                    ),
                  ),
                )
              : null),
    );
  }
}
