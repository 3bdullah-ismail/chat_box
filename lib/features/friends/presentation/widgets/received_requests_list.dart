import 'package:chat_app/core/constants/color_manager.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/friends/data/models/friend_request_model.dart';
import 'package:chat_app/features/friends/presentation/manager/friend_cubit.dart';
import 'package:chat_app/features/friends/presentation/widgets/custom_empty_state.dart';
import 'package:chat_app/features/friends/presentation/widgets/friend_request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReceivedRequestsList extends StatelessWidget {
  final List<FriendRequestModel> receivedRequests;

  const ReceivedRequestsList({super.key, required this.receivedRequests});

  @override
  Widget build(BuildContext context) {
    if (receivedRequests.isEmpty) {
      return const CustomEmptyState(
        icon: Icons.mark_email_read_outlined,
        title: "No Received Requests",
        description:
            "When someone sends you a friend request, it will appear here.",
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<FriendCubit>().getFriendRequests(),
      color: ColorManager.black,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        itemCount: receivedRequests.length,
        separatorBuilder: (_, __) => SizedBox(height: 8.h),
        itemBuilder: (context, index) {
          final item = receivedRequests[index];

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
            isCompact: false,
            onAccept: () =>
                context.read<FriendCubit>().acceptFriendRequest(item),
            onDecline: () {
              // TODO: context.read<FriendCubit>().declineFriendRequest(item);
            },
          );
        },
      ),
    );
  }
}
