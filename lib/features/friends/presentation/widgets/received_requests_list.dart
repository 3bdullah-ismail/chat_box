import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/constants/values_manager.dart';
import 'package:silora/core/translations/locale_keys.g.dart';
import 'package:silora/features/auth/data/models/user_model.dart';
import 'package:silora/features/friends/data/models/friend_request_model.dart';
import 'package:silora/features/friends/presentation/manager/friend_cubit.dart';
import 'package:silora/features/friends/presentation/widgets/custom_empty_state.dart';
import 'package:silora/features/friends/presentation/widgets/friend_request_card.dart';

class ReceivedRequestsList extends StatelessWidget {
  final List<FriendRequestModel> receivedRequests;

  const ReceivedRequestsList({super.key, required this.receivedRequests});

  @override
  Widget build(BuildContext context) {
    if (receivedRequests.isEmpty) {
      return CustomEmptyState(
        icon: Icons.mark_email_read_outlined,
        title: LocaleKeys.friends_receivedRequests_emptyStateTitle.tr(),
        description: LocaleKeys.friends_receivedRequests_emptyStateDesc.tr(),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<FriendCubit>().getFriendRequests(),
      color: ColorManager.black,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.p20.w,
          vertical: AppPadding.p16.h,
        ),
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        itemCount: receivedRequests.length,
        separatorBuilder: (_, __) => SizedBox(height: AppSize.s8.h),
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
            onDecline: () {},
          );
        },
      ),
    );
  }
}
