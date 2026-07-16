import 'package:silora/core/constants/font_manager.dart';
import 'package:silora/core/constants/values_manager.dart';
import 'package:silora/core/utils/extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/color_manager.dart';
import '../../../../core/constants/styles_manager.dart';
import '../../../../core/routes/app_routes_names.dart';
import '../../../../core/utils/time_format_methods.dart';
import '../../../../core/widgets/custom_avatar.dart';
import '../../../auth/data/models/user_model.dart';
import '../../data/models/conversation_model.dart';

class ChatCard extends StatelessWidget {
  final ConversationModel conversation;

  const ChatCard({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final friendId = conversation.participants.keys.firstWhere(
      (key) => key != currentUserId,
      orElse: () => '',
    );

    final friendName = conversation.userNames[friendId] ?? 'Chat User';
    final myUnreadCount = conversation.getUnreadCount(currentUserId ?? '');

    return InkWell(
      onTap: () {
        final friendModel = UserModel(
          id: friendId,
          name: friendName,
          email: '',
          username: '',
        );

        context.push(
          AppRouteNames.chat,
          extra: {'conversationId': conversation.id, 'friendUser': friendModel},
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.p16.w,
          vertical: AppPadding.p14.h,
        ),
        decoration: BoxDecoration(
          color: ColorManager.white,
          border: Border(
            bottom: BorderSide(
              color: ColorManager.gray.withValues(alpha: 0.06),
              width: AppSize.s1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomAvatar(title: friendName, imageUrl: null),
            AppSize.s14.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    friendName.toCapitalized(),
                    style: getBoldStyle(
                      color: ColorManager.black,
                      fontSize: FontSize.s16.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSize.s6.verticalSpace,
                  Text(
                    conversation.lastMessage.isEmpty
                        ? "Tap to start chatting..."
                        : conversation.lastMessage,
                    style: getRegularStyle(
                      color: conversation.lastMessage.isEmpty
                          ? ColorManager.gray.withValues(alpha: 0.5)
                          : ColorManager.gray,
                      fontSize: FontSize.s14.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            AppSize.s12.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  conversation.lastMessage.isEmpty
                      ? ""
                      : formatTime(conversation.lastMessageTime),
                  style: getRegularStyle(
                    color: ColorManager.gray,
                    fontSize: FontSize.s12.sp,
                  ),
                ),
                if (myUnreadCount > 0 &&
                    conversation.lastMessageSenderId != currentUserId) ...[
                  AppSize.s6.verticalSpace,
                  Container(
                    padding: const EdgeInsets.all(AppPadding.p6),
                    decoration: const BoxDecoration(
                      color: ColorManager.blue,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: AppSize.s20.w,
                      minHeight: AppSize.s20.h,
                    ),
                    child: Center(
                      child: Text(
                        "$myUnreadCount",
                        style: getBoldStyle(
                          color: ColorManager.white,
                          fontSize: FontSize.s11.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
