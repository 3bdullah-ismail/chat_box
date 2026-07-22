import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/constants/font_manager.dart';
import 'package:silora/core/constants/styles_manager.dart';
import 'package:silora/core/constants/values_manager.dart';
import 'package:silora/core/di/injection_container.dart';
import 'package:silora/core/routes/app_routes_names.dart';
import 'package:silora/core/translations/locale_keys.g.dart';
import 'package:silora/core/utils/extension.dart';
import 'package:silora/core/widgets/custom_avatar.dart';
import 'package:silora/core/widgets/custom_dialog.dart';
import 'package:silora/core/widgets/custom_text_field.dart';
import 'package:silora/core/widgets/session_expired_widget.dart';

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
  late final ChatRoomCubit _chatCubit;

  @override
  void initState() {
    super.initState();

    _chatCubit = getIt<ChatRoomCubit>()
      ..listenToMessages(conversationId: widget.conversationId);
  }

  @override
  void dispose() {
    _chatCubit.setTyping(
      conversationId: widget.conversationId,
      isTyping: false,
    );
    _messageController.dispose();
    super.dispose();
  }

  void _showMessageOptions(BuildContext cubitContext, MessageModel message) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final isMe = message.senderId == currentUserId;

    showModalBottomSheet(
      context: cubitContext,
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
                    LocaleKeys.chat_page_deleteForEveryone.tr(),
                    style: getMediumStyle(color: ColorManager.black),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    cubitContext.read<ChatRoomCubit>().deleteForEveryone(
                      conversationId: widget.conversationId,
                      messageId: message.id,
                    );
                  },
                ),
              ListTile(
                leading: const Icon(Icons.delete, color: ColorManager.black),
                title: Text(
                  LocaleKeys.chat_page_deleteForMe.tr(),
                  style: getMediumStyle(color: ColorManager.black),
                ),
                onTap: () {
                  Navigator.pop(context);
                  cubitContext.read<ChatRoomCubit>().deleteForMe(
                    conversationId: widget.conversationId,
                    messageId: message.id,
                  );
                },
              ),
              if (!message.isDeletedForEveryone)
                ListTile(
                  leading: const Icon(Icons.copy, color: ColorManager.black),
                  title: Text(
                    LocaleKeys.chat_page_copy.tr(),
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
                  LocaleKeys.chat_page_cancel.tr(),
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
    return BlocProvider.value(
      value: _chatCubit,
      child: Builder(
        builder: (context) {
          return Scaffold(
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
              title: GestureDetector(
                onTap: () async {
                  final chatCubit = context.read<ChatRoomCubit>();
                  final realUser = await chatCubit.getFriendProfile(
                    widget.friendUser.id,
                  );

                  if (context.mounted) {
                    if (realUser != null) {
                      context.push(
                        AppRouteNames.friendProfile,
                        extra: realUser,
                      );
                    }
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomAvatar(
                      title: widget.friendUser.name.isNotEmpty
                          ? widget.friendUser.name.toCapitalized()
                          : "?",
                    ),
                    SizedBox(width: AppSize.s16.w),
                    Column(
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
                          stream: context.read<ChatRoomCubit>().getUserPresence(
                            widget.friendUser.id,
                          ),
                          builder: (context, presenceSnapshot) {
                            final presence = presenceSnapshot.data;

                            return StreamBuilder<bool>(
                              stream: context
                                  .read<ChatRoomCubit>()
                                  .getTypingStatus(
                                    conversationId: widget.conversationId,
                                    friendId: widget.friendUser.id,
                                  ),
                              builder: (context, typingSnapshot) {
                                final isTyping = typingSnapshot.data ?? false;

                                if (isTyping) {
                                  return Text(
                                    LocaleKeys.chat_page_typing.tr(),
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
                                    ? LocaleKeys.chat_page_online.tr()
                                    : presence.lastSeen == 0
                                    ? LocaleKeys.chat_page_offline.tr()
                                    : LocaleKeys.chat_page_lastSeen.tr(
                                        args: [
                                          formatLastSeen(presence.lastSeen),
                                        ],
                                      );

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
                    ),
                  ],
                ),
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
            body: SafeArea(
              child: Container(
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
                            state is GetMessagesError ||
                            state is ChatRoomSessionExpired,
                        builder: (context, state) {
                          if (state is GetMessagesLoading) {
                            return const SizedBox.shrink();
                          }

                          if (state is ChatRoomSessionExpired) {
                            return const SessionExpiredWidget();
                          }

                          if (state is GetMessagesError) {
                            return Center(
                              child: Text(
                                state.message,
                                style: getMediumStyle(
                                  color: ColorManager.error,
                                ),
                              ),
                            );
                          }

                          if (state is GetMessagesLoaded) {
                            final reversedMessages = state.messages.reversed
                                .toList();

                            if (reversedMessages.isEmpty) {
                              return Center(
                                child: Text(
                                  LocaleKeys.chat_page_noMessages.tr(),
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

                                if (message.deletedForUsers.contains(
                                  currentUserId,
                                )) {
                                  return const SizedBox.shrink();
                                }

                                return GestureDetector(
                                  onLongPress: () {
                                    _showMessageOptions(context, message);
                                  },
                                  child: ChatBubble(
                                    text: message.isDeletedForEveryone
                                        ? LocaleKeys.chat_page_messageDeleted
                                              .tr()
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
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _messageController,
                              text: LocaleKeys.chat_page_messageHint.tr(),
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              minLines: 1,
                              onChanged: (value) {
                                context.read<ChatRoomCubit>().setTyping(
                                  conversationId: widget.conversationId,
                                  isTyping: value.trim().isNotEmpty,
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
                                    text: text.trim(),
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
