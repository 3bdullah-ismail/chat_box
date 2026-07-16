import 'package:silora/core/constants/styles_manager.dart';
import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/constants/font_manager.dart';
import 'package:silora/core/constants/values_manager.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String time;
  final bool isSeen;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.time,
    this.isSeen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: AppPadding.p12,
              left: AppPadding.p20,
              right: 40.75,
              bottom: AppPadding.p12,
            ),
            constraints: const BoxConstraints(maxWidth: 297.50),
            decoration: BoxDecoration(
              color: isMe ? ColorManager.black : ColorManager.white,
              border: Border.all(
                color: isMe
                    ? ColorManager.transparent
                    : ColorManager.borderGray,
                width: AppSize.s1,
              ),
              borderRadius: BorderRadius.circular(AppRadius.r12),
              boxShadow: [
                BoxShadow(
                  color: ColorManager.black.withValues(alpha: 0.04),
                  blurRadius: AppSize.s2,
                  offset: const Offset(0, AppSize.s1),
                ),
              ],
            ),
            child: Text(
              text,
              style: getRegularStyle(
                color: isMe ? ColorManager.white : ColorManager.nearBlack,
                fontSize: FontSize.s16,
              ).copyWith(height: 1.50),
            ),
          ),

          const SizedBox(height: AppSize.s4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: getRegularStyle(
                    color: ColorManager.neutralGray,
                    fontSize: FontSize.s11,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: AppSize.s4),
                  Icon(
                    isSeen ? Icons.done_all : Icons.done,
                    size: AppSize.s14,
                    color: isSeen
                        ? ColorManager.blue
                        : ColorManager.neutralGray,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
