import 'package:chat_app/core/constants/color_manager.dart';
import 'package:chat_app/core/constants/font_manager.dart';
import 'package:chat_app/core/constants/styles_manager.dart';
import 'package:chat_app/core/widgets/custom_text_field.dart';
import 'package:chat_app/features/chat/presentation/widgets/empty_chats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../friends/presentation/widgets/skeleton_list_widget.dart';
import '../manager/chat_cubit.dart';
import '../widgets/chat_card.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final TextEditingController _searchController = TextEditingController();

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
          "ChatBox",
          style: getBoldStyle(
            color: ColorManager.black,
            fontSize: FontSize.s28,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: ColorManager.black, size: 36.sp),
            onPressed: () {},
          ),
          8.horizontalSpace,
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            12.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomTextField(
                controller: _searchController,
                text: "Search for people",
                prefixIcon: Icon(
                  Icons.search,
                  color: ColorManager.gray,
                  size: 22.sp,
                ),
              ),
            ),
            12.verticalSpace,
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state is GetConversationsLoading) {
                    return const SingleChildScrollView(
                      child: SkeletonListWidget(type: SkeletonType.chatsList),
                    );
                  }

                  if (state is GetConversationsError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: getRegularStyle(
                          color: ColorManager.error,
                          fontSize: 14.sp,
                        ),
                      ),
                    );
                  }

                  if (state is GetConversationsLoaded) {
                    final conversations = state.conversations;

                    if (conversations.isEmpty) {
                      return EmptyChats(
                        onStartChat: () {},
                        onDiscoverPeople: () {},
                      );
                    }

                    return ListView.builder(
                      itemCount: conversations.length,
                      padding: EdgeInsets.only(bottom: 16.h),
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
