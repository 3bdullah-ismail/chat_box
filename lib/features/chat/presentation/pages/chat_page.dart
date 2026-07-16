import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/constants/font_manager.dart';
import 'package:silora/core/constants/styles_manager.dart';
import 'package:silora/core/constants/values_manager.dart';
import 'package:silora/core/di/injection_container.dart';
import 'package:silora/core/utils/extension.dart';
import 'package:silora/core/widgets/custom_avatar.dart';
import 'package:silora/core/widgets/custom_dialog.dart';
import 'package:silora/core/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/time_format_methods.dart';
import '../../../auth/data/models/user_model.dart';
import '../../data/models/message_model.dart';
import '../../data/models/presence_model.dart';
import '../manager/chat_room_cubit.dart';
import '../widgets/chat_bubble.dart';

class ChatPage extends StatefulWidget {
  final String conversationId;
  final UserModel friendUser;

  const ChatPage({
    super.key,
    required this.conversationId,
    required this.friendUser,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _showMessageOptions(BuildContext context, MessageModel message) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final isMe = message.senderId == currentUserId;

    showModalBottomSheet(
      context: context,
      backgroundColor: ColorManager.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.r20),
        ),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isMe && !message.isDeletedForEveryone)
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline,
                    color: ColorManager.black,
                  ),
                  title: Text(
                    "Delete for everyone",
                    style: getMediumStyle(color: ColorManager.black),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<ChatRoomCubit>().deleteForEveryone(
                      conversationId: widget.conversationId,
                      messageId: message.id,
                    );
                  },
                ),
              ListTile(
                leading: const Icon(Icons.delete, color: ColorManager.black),
                title: Text(
                  "Delete for me",
                  style: getMediumStyle(color: ColorManager.black),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.read<ChatRoomCubit>().deleteForMe(
                    conversationId: widget.conversationId,
                    messageId: message.id,
                  );
                },
              ),
              if (!message.isDeletedForEveryone)
                ListTile(
                  leading: const Icon(Icons.copy, color: ColorManager.black),
                  title: Text(
                    "Copy",
                    style: getMediumStyle(color: ColorManager.black),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await Clipboard.setData(ClipboardData(text: message.text));
                  },
                ),
              ListTile(
                leading: const Icon(Icons.close, color: ColorManager.black),
                title: Text(
                  "Cancel",
                  style: getMediumStyle(color: ColorManager.black),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<ChatRoomCubit>()
            ..listenToMessages(conversationId: widget.conversationId),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: ColorManager.black,
            ),
            onPressed: () => context.pop(),
          ),
          backgroundColor: ColorManager.white,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomAvatar(
                title: widget.friendUser.name.isNotEmpty
                    ? widget.friendUser.name.toCapitalized()
                    : "?",
              ),
              SizedBox(width: AppSize.s16.w),
              Builder(
                builder: (innerContext) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.friendUser.name.toCapitalized(),
                        style: getBoldStyle(
                          color: ColorManager.black,
                          fontSize: FontSize.s24.sp,
                        ),
                      ),
                      StreamBuilder<PresenceModel>(
                        stream: innerContext
                            .read<ChatRoomCubit>()
                            .getUserPresence(widget.friendUser.id),
                        builder: (context, presenceSnapshot) {
                          final presence = presenceSnapshot.data;

                          return StreamBuilder<bool>(
                            stream: innerContext
                                .read<ChatRoomCubit>()
                                .getTypingStatus(
                                  conversationId: widget.conversationId,
                                  friendId: widget.friendUser.id,
                                ),
                            builder: (context, typingSnapshot) {
                              final isTyping = typingSnapshot.data ?? false;

                              if (isTyping) {
                                return Text(
                                  "Typing...",
                                  style: getRegularStyle(
                                    color: ColorManager.blue,
                                    fontSize: FontSize.s12.sp,
                                  ),
                                );
                              }

                              if (presence == null) {
                                return const SizedBox();
                              }

                              final text = presence.online
                                  ? "Online"
                                  : presence.lastSeen == 0
                                      ? "Offline"
                                      : "Last seen ${formatLastSeen(presence.lastSeen)}";

                              return Text(
                                text,
                                style: getRegularStyle(
                                  color: presence.online
                                      ? ColorManager.blue
                                      : ColorManager.gray,
                                  fontSize: FontSize.s12.sp,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.more_vert,
                color: ColorManager.black,
                size: AppSize.s28.sp,
              ),
              onPressed: () {},
            ),
            AppSize.s8.horizontalSpace,
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [ColorManager.lightBlue, ColorManager.white],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: BlocConsumer<ChatRoomCubit, ChatRoomState>(
                  listenWhen: (_, state) => state is SendMessageError,
                  listener: (context, state) {
                    if (state is SendMessageError) {
                      CustomAwesomeDialog.showError(
                        context: context,
                        message: state.message,
                      );
                    }
                  },
                  buildWhen: (_, state) =>
                      state is GetMessagesLoading ||
                      state is GetMessagesLoaded ||
                      state is GetMessagesError,
                  builder: (context, state) {
                    if (state is GetMessagesLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: ColorManager.black,
                        ),
                      );
                    }

                    if (state is GetMessagesError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: getMediumStyle(color: ColorManager.error),
                        ),
                      );
                    }

                    if (state is GetMessagesLoaded) {
                      final reversedMessages = state.messages.reversed.toList();

                      if (reversedMessages.isEmpty) {
                        return Center(
                          child: Text(
                            'No messages yet.\nSay Hello! 👋',
                            textAlign: TextAlign.center,
                            style: getMediumStyle(
                              color: ColorManager.gray,
                              fontSize: FontSize.s16.sp,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.all(AppPadding.p16),
                        itemCount: reversedMessages.length,
                        itemBuilder: (context, index) {
                          final message = reversedMessages[index];
                          final currentUserId =
                              FirebaseAuth.instance.currentUser?.uid;
                          final isMe = message.senderId == currentUserId;

                          if (message.deletedForUsers.contains(currentUserId)) {
                            return const SizedBox.shrink();
                          }

                          return GestureDetector(
                            onLongPress: () {
                              _showMessageOptions(context, message);
                            },
                            child: ChatBubble(
                              text: message.isDeletedForEveryone
                                  ? "🚫 This message was deleted"
                                  : message.text,
                              isMe: isMe,
                              time: formatTime(message.timestamp),
                              isSeen: message.isSeen,
                            ),
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
              Padding(
                padding: REdgeInsets.fromLTRB(
                  AppPadding.p16,
                  AppPadding.p8,
                  AppPadding.p16,
                  AppPadding.p16,
                ),
                child: Builder(
                  builder: (context) {
                    return Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _messageController,
                            text: 'Message...',
                            onChanged: (value) {
                              context.read<ChatRoomCubit>().setTyping(
                                conversationId: widget.conversationId,
                                isTyping: value.isNotEmpty,
                              );
                            },
                          ),
                        ),
                        SizedBox(width: AppSize.s10.w),
                        Container(
                          width: AppSize.s44.w,
                          height: AppSize.s44.h,
                          decoration: const BoxDecoration(
                            color: ColorManager.black,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.send_rounded,
                              color: ColorManager.white,
                              size: AppSize.s20.sp,
                            ),
                            onPressed: () {
                              final text = _messageController.text;
                              if (text.trim().isNotEmpty) {
                                context.read<ChatRoomCubit>().sendNewMessage(
                                  conversationId: widget.conversationId,
                                  receiverId: widget.friendUser.id,
                                  text: text,
                                );
                                _messageController.clear();
                                context.read<ChatRoomCubit>().setTyping(
                                  conversationId: widget.conversationId,
                                  isTyping: false,
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
