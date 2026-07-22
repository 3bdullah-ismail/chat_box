import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/routes/app_routes_names.dart';
import 'package:silora/core/translations/locale_keys.g.dart';
import 'package:silora/features/auth/data/models/user_model.dart';
import 'package:silora/features/friends/presentation/manager/friend_cubit.dart';
import 'package:silora/features/friends/presentation/widgets/friend_card.dart';
import 'package:silora/features/friends/presentation/widgets/friend_request_card.dart';

import '../../../../core/constants/font_manager.dart';
import '../../../../core/constants/styles_manager.dart';
import '../../../../core/constants/values_manager.dart';
import '../../../../core/widgets/custom_text_btn.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../chat/presentation/manager/chat_cubit.dart';

class FriendsMainContent extends StatefulWidget {
  final FriendCubit cubit;

  const FriendsMainContent({super.key, required this.cubit});

  @override
  State<FriendsMainContent> createState() => _FriendsMainContentState();
}

class _FriendsMainContentState extends State<FriendsMainContent> {
  late final TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRouteNames.addFriends),
        foregroundColor: ColorManager.black,
        backgroundColor: ColorManager.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.person_add_alt),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.p24.w,
          vertical: AppPadding.p20.h,
        ),
        physics: const BouncingScrollPhysics(),
        children: [
          Text(
            LocaleKeys.friends_mainContent_title.tr(),
            style: getBoldStyle(
              color: ColorManager.black,
              fontSize: FontSize.s24.sp,
            ),
          ),
          SizedBox(height: AppSize.s20.h),
          CustomTextField(
            controller: _searchController,
            text: LocaleKeys.friends_mainContent_searchHint.tr(),
            onChanged: (query) => setState(() => _searchQuery = query),
          ),
          SizedBox(height: AppSize.s24.h),
          _buildRequestsSection(),
          SizedBox(height: AppSize.s24.h),
          _buildFriendsSection(),
        ],
      ),
    );
  }

  Widget _buildRequestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleKeys.friends_mainContent_requestsSectionTitle.tr(),
              style: getBoldStyle(
                color: ColorManager.black,
                fontSize: FontSize.s18.sp,
              ),
            ),
            CustomTextBtn(
              text: LocaleKeys.friends_mainContent_viewAllBtn.tr(),
              onPressed: () => context.push(AppRouteNames.friendRequest),
              color: ColorManager.black,
            ),
          ],
        ),
        SizedBox(height: AppSize.s8.h),
        if (widget.cubit.receivedRequests.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.cubit.receivedRequests.length > 2
                ? 2
                : widget.cubit.receivedRequests.length,
            itemBuilder: (context, index) {
              final item = widget.cubit.receivedRequests[index];
              final userModel = UserModel(
                id: item.senderId,
                name: item.senderName.isNotEmpty ? item.senderName : 'User',
                email: item.senderEmail,
                username: item.senderUsername.isNotEmpty
                    ? item.senderUsername
                    : (item.senderEmail.isNotEmpty
                          ? item.senderEmail.split('@')[0]
                          : 'user'),
              );
              return FriendRequestCard(
                user: userModel,
                isReceived: true,
                isCompact: true,
                onAccept: () =>
                    context.read<FriendCubit>().acceptFriendRequest(item),
                onDecline: () {},
              );
            },
          ),
      ],
    );
  }

  Widget _buildFriendsSection() {
    final filteredFriends = widget.cubit.friends.where((friend) {
      final nameMatches = friend.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final usernameMatches = friend.username.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      return nameMatches || usernameMatches;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.friends_mainContent_friendsSectionTitle.tr(),
          style: getBoldStyle(
            color: ColorManager.black,
            fontSize: FontSize.s18.sp,
          ),
        ),
        SizedBox(height: AppSize.s8.h),
        if (filteredFriends.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredFriends.length,
            itemBuilder: (context, index) {
              final friend = filteredFriends[index];
              return FriendCard(
                user: friend,
                onChatPressed: () {
                  context.read<ChatCubit>().startChat(friendUser: friend);
                },
              );
            },
          ),
      ],
    );
  }
}
