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

class SentRequestsList extends StatelessWidget {
  final List<FriendRequestModel> sentRequests;

  const SentRequestsList({super.key, required this.sentRequests});

  @override
  Widget build(BuildContext context) {
    if (sentRequests.isEmpty) {
      return CustomEmptyState(
        icon: Icons.outbox_outlined,
        title: LocaleKeys.friends_sentRequests_emptyStateTitle.tr(),
        description: LocaleKeys.friends_sentRequests_emptyStateDesc.tr(),
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
        itemCount: sentRequests.length,
        separatorBuilder: (_, __) => SizedBox(height: AppSize.s8.h),
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
            onCancel: () {},
          );
        },
      ),
    );
  }
}
