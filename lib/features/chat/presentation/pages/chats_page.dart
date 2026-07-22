import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/constants/font_manager.dart';
import 'package:silora/core/constants/styles_manager.dart';
import 'package:silora/core/constants/values_manager.dart';
import 'package:silora/core/widgets/custom_text_field.dart';
import 'package:silora/core/widgets/session_expired_widget.dart';
import 'package:silora/features/chat/presentation/widgets/empty_chats.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:silora/core/translations/locale_keys.g.dart';

import '../../../../core/routes/app_routes_names.dart';
import '../../../friends/presentation/widgets/skeleton_list_widget.dart';
import '../manager/chat_cubit.dart';
import '../widgets/chat_card.dart';

class ChatsPage extends StatefulWidget {
  final VoidCallback onJumpToFriendsTab;

  const ChatsPage({super.key, required this.onJumpToFriendsTab});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().fetchMyConversations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          "Silora",
          style: getBoldStyle(
            color: ColorManager.black,
            fontSize: FontSize.s28,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSize.s12.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.p16.w),
              child: CustomTextField(
                controller: _searchController,
                text: LocaleKeys.chat_chatsPage_searchHint.tr(),
                prefixIcon: Icon(
                  Icons.search,
                  color: ColorManager.gray,
                  size: AppSize.s22.sp,
                ),
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
              ),
            ),
            AppSize.s12.verticalSpace,
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state is GetConversationsLoading) {
                    return const SingleChildScrollView(
                      child: SkeletonListWidget(type: SkeletonType.chatsList),
                    );
                  }

                  if (state is GetConversationsSessionExpired) {
                    return const SessionExpiredWidget();
                  }

                  if (state is GetConversationsError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: getRegularStyle(
                          color: ColorManager.error,
                          fontSize: FontSize.s14.sp,
                        ),
                      ),
                    );
                  }

                  if (state is GetConversationsLoaded) {
                    final conversations = state.conversations.where((conv) {
                      if (_searchQuery.isEmpty) return true;

                      return conv.userNames.values.any(
                        (name) => name.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ),
                      );
                    }).toList();

                    if (conversations.isEmpty) {
                      return EmptyChats(
                        onStartChat: () {
                          widget.onJumpToFriendsTab();
                        },
                        onDiscoverPeople: () {
                          context.push(AppRouteNames.addFriends);
                        },
                      );
                    }

                    return ListView.builder(
                      itemCount: conversations.length,
                      padding: EdgeInsets.only(bottom: AppPadding.p16.h),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ChatCard(conversation: conversations[index]);
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
