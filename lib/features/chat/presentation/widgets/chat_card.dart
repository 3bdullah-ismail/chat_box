import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/color_manager.dart';
import '../../../../core/constants/styles_manager.dart';
import '../../../../core/routes/app_routes_names.dart';
import '../../../../core/widgets/custom_avatar.dart';
import '../../data/models/conversation_model.dart';

class ChatCard extends StatelessWidget {
  final ConversationModel conversation;

  const ChatCard({super.key, required this.conversation});

  String _formatTime(int milliseconds) {
    if (milliseconds == 0) return "";
    final date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return DateFormat('hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final friendId = conversation.participants.keys.firstWhere(
      (key) => key != currentUserId,
      orElse: () => '',
    );

    final friendName = conversation.userNames[friendId] ?? 'Chat User';

    return InkWell(
      onTap: () {
        context.push(AppRouteNames.chat, extra: conversation.id);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: ColorManager.white,
          border: Border(
            bottom: BorderSide(
              color: ColorManager.gray.withValues(alpha: 0.06),
              width: 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomAvatar(title: friendName, imageUrl: null),
            14.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    friendName,
                    style: getBoldStyle(
                      color: ColorManager.black,
                      fontSize: 16.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  6.verticalSpace,
                  Text(
                    conversation.lastMessage.isEmpty
                        ? "Tap to start chatting..."
                        : conversation.lastMessage,
                    style: getRegularStyle(
                      color: conversation.lastMessage.isEmpty
                          ? ColorManager.gray.withValues(alpha: 0.5)
                          : ColorManager.gray,
                      fontSize: 14.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            12.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _formatTime(conversation.lastMessageTime),
                  style: getRegularStyle(
                    color: ColorManager.gray,
                    fontSize: 12.sp,
                  ),
                ),
                8.verticalSpace,
                if (conversation.lastMessage.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(4.r),
                    constraints: BoxConstraints(
                      minWidth: 20.w,
                      minHeight: 20.h,
                    ),
                    decoration: const BoxDecoration(
                      color: ColorManager.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "1",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
