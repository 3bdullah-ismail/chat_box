import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/routes/app_routes_names.dart';
import 'package:silora/core/widgets/loading.dart';
import 'package:silora/features/friends/presentation/manager/friend_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:silora/core/translations/locale_keys.g.dart';

import '../../../chat/presentation/manager/chat_cubit.dart';
import '../widgets/friends_empty_state.dart';
import '../widgets/friends_main_content.dart';
import '../widgets/friends_skeleton_view.dart';
import 'package:silora/core/widgets/session_expired_widget.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  void initState() {
    super.initState();
    context.read<FriendCubit>().getFriends();
    context.read<FriendCubit>().getFriendRequests();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ChatCubit, ChatState>(
          listener: (context, state) {
            if (state is ChatLoading) Loading.show(context);
            if (state is ChatError) {
              Loading.hide(context);
              _showSnackBar(context, state.message, ColorManager.error);
            }
            if (state is ChatSuccess) {
              Loading.hide(context);

              context.push(
                AppRouteNames.chat,
                extra: {
                  'conversationId': state.conversationId,
                  'friendUser': state.friendUser,
                },
              );
            }
          },
        ),
        BlocListener<FriendCubit, FriendState>(
          listener: (context, state) {
            if (state is AcceptFriendRequestLoading) Loading.show(context);
            if (state is AcceptFriendRequestSuccess) {
              Loading.hide(context);
              _showSnackBar(
                context,
                LocaleKeys.friends_friendRequests_successMsg.tr(),
                ColorManager.blue,
              );
            }
            if (state is AcceptFriendRequestError) {
              Loading.hide(context);
              _showSnackBar(context, state.message, ColorManager.error);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: ColorManager.surfaceBlue,
        body: SafeArea(
          child: BlocBuilder<FriendCubit, FriendState>(
            builder: (context, state) {
              final cubit = context.read<FriendCubit>();
              final hasNoFriends = cubit.friends.isEmpty;
              final hasNoRequests = cubit.receivedRequests.isEmpty;
              final isLoading =
                  state is GetFriendsLoading ||
                  state is GetFriendRequestLoading;
              final isInitial = state is FriendInitial;

              if (state is FriendSessionExpired) {
                return const SessionExpiredWidget();
              }

              if ((isLoading || isInitial) && hasNoFriends && hasNoRequests) {
                return const FriendsSkeletonView();
              }
              if (hasNoFriends && hasNoRequests) {
                return const FriendsEmptyState();
              }
              return FriendsMainContent(cubit: cubit);
            },
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }
}
