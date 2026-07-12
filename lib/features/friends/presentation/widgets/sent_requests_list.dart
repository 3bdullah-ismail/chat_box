import 'package:chat_app/core/constants/color_manager.dart';
import 'package:chat_app/features/auth/data/models/user_model.dart';
import 'package:chat_app/features/friends/data/models/friend_request_model.dart';
import 'package:chat_app/features/friends/presentation/manager/friend_cubit.dart';
import 'package:chat_app/features/friends/presentation/widgets/custom_empty_state.dart';
import 'package:chat_app/features/friends/presentation/widgets/friend_request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SentRequestsList extends StatelessWidget {
  final List<FriendRequestModel> sentRequests;

  const SentRequestsList({super.key, required this.sentRequests});

  @override
  Widget build(BuildContext context) {
    if (sentRequests.isEmpty) {
      return const CustomEmptyState(
        icon: Icons.outbox_outlined,
        title: "No Sent Requests",
        description:
            "You haven't sent any friend requests yet. Go find some friends!",
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
        itemCount: sentRequests.length,
        separatorBuilder: (_, __) => SizedBox(height: 8.h),
        itemBuilder: (context, index) {
          final item = sentRequests[index];

          final userModel = UserModel(
            id: item.receiverId,
            name: item.receiverName.isNotEmpty ? item.receiverName : 'User',
            email: item.receiverEmail.isNotEmpty ? item.receiverEmail : '',
            username: item.receiverUsername.isNotEmpty
                ? item.receiverUsername
                : 'user',
          );

          return FriendRequestCard(
            user: userModel,
            isReceived: false,
            isCompact: false,
            onCancel: () {
              // TODO: context.read<FriendCubit>().cancelFriendRequest(item.id);
            },
          );
        },
      ),
    );
  }
}
