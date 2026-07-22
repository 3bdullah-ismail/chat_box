import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:silora/core/constants/color_manager.dart';
import 'package:silora/core/constants/font_manager.dart';
import 'package:silora/core/constants/styles_manager.dart';
import 'package:silora/core/constants/values_manager.dart';
import 'package:silora/core/translations/locale_keys.g.dart';
import 'package:silora/core/widgets/loading.dart';
import 'package:silora/features/friends/presentation/manager/friend_cubit.dart';
import 'package:silora/features/friends/presentation/widgets/received_requests_list.dart';
import 'package:silora/features/friends/presentation/widgets/sent_requests_list.dart';
import 'package:silora/features/friends/presentation/widgets/skeleton_list_widget.dart';
import 'package:silora/core/widgets/session_expired_widget.dart';

class FriendRequests extends StatefulWidget {
  const FriendRequests({super.key});

  @override
  State<FriendRequests> createState() => _FriendRequestsState();
}

class _FriendRequestsState extends State<FriendRequests> {
  @override
  void initState() {
    super.initState();
    context.read<FriendCubit>().getFriendRequests();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FriendCubit, FriendState>(
      listener: (context, state) {
        if (state is AcceptFriendRequestLoading) {
          Loading.show(context);
        } else if (state is AcceptFriendRequestSuccess) {
          Loading.hide(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(LocaleKeys.friends_friendRequests_successMsg.tr()),
              backgroundColor: ColorManager.blue,
            ),
          );
        } else if (state is AcceptFriendRequestError) {
          Loading.hide(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: ColorManager.error,
            ),
          );
        }
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: ColorManager.surfaceBlue,
          appBar: AppBar(
            backgroundColor: ColorManager.surfaceBlue,
            centerTitle: true,
            title: Text(
              LocaleKeys.friends_friendRequests_title.tr(),
              style: getBoldStyle(
                fontSize: FontSize.s20.sp,
                color: ColorManager.black,
              ),
            ),
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: ColorManager.black,
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.p24.w,
                vertical: AppPadding.p20.h,
              ),
              child: Column(
                children: [
                  TabBar(
                    dividerColor: ColorManager.transparent,
                    indicatorColor: ColorManager.black,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelStyle: getBoldStyle(
                      fontSize: FontSize.s16.sp,
                      color: ColorManager.black,
                    ),
                    unselectedLabelColor: ColorManager.gray,
                    unselectedLabelStyle: getMediumStyle(
                      fontSize: FontSize.s16.sp,
                      color: ColorManager.gray,
                    ),
                    tabs: [
                      Tab(
                        text: LocaleKeys.friends_friendRequests_tabReceived
                            .tr(),
                      ),
                      Tab(text: LocaleKeys.friends_friendRequests_tabSent.tr()),
                    ],
                  ),
                  Expanded(
                    child: BlocBuilder<FriendCubit, FriendState>(
                      buildWhen: (previous, current) =>
                          current is GetFriendRequestLoading ||
                          current is GetFriendRequestLoaded ||
                          current is GetFriendRequestError ||
                          current is FriendSessionExpired,
                      builder: (context, state) {
                        if (state is GetFriendRequestLoading) {
                          return const SingleChildScrollView(
                            child: SkeletonListWidget(
                              type: SkeletonType.friendRequestExpanded,
                            ),
                          );
                        }

                        if (state is FriendSessionExpired) {
                          return const SessionExpiredWidget();
                        }

                        if (state is GetFriendRequestError) {
                          return Center(
                            child: Text(
                              state.message,
                              style: getRegularStyle(color: ColorManager.error),
                            ),
                          );
                        }

                        if (state is GetFriendRequestLoaded) {
                          return TabBarView(
                            children: [
                              ReceivedRequestsList(
                                receivedRequests: state.receivedRequests,
                              ),
                              SentRequestsList(
                                sentRequests: state.sentRequests,
                              ),
                            ],
                          );
                        }

                        return const SingleChildScrollView(
                          child: SkeletonListWidget(
                            type: SkeletonType.friendRequestExpanded,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
