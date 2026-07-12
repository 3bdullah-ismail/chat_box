import 'package:chat_app/core/constants/color_manager.dart';
import 'package:chat_app/core/constants/font_manager.dart';
import 'package:chat_app/core/constants/styles_manager.dart';
import 'package:chat_app/core/widgets/custom_text_field.dart';
import 'package:chat_app/core/widgets/loading.dart';
import 'package:chat_app/features/friends/presentation/manager/friend_cubit.dart';
import 'package:chat_app/features/friends/presentation/widgets/add_friend_card.dart';
import 'package:chat_app/features/friends/presentation/widgets/custom_empty_state.dart';
import 'package:chat_app/features/friends/presentation/widgets/skeleton_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AddFriends extends StatefulWidget {
  const AddFriends({super.key});

  @override
  State<AddFriends> createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  late final TextEditingController _searchController;

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
      backgroundColor: ColorManager.surfaceBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ColorManager.black,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Add Friends",
          style: getBoldStyle(
            color: ColorManager.black,
            fontSize: FontSize.s20.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            children: [
              CustomTextField(
                controller: _searchController,
                text: "Search by username, email, or phone",
                onChanged: (query) {
                  context.read<FriendCubit>().search(query);
                },
              ),
              SizedBox(height: 24.h),
              Expanded(
                child: BlocConsumer<FriendCubit, FriendState>(
                  listenWhen: (previous, current) =>
                      current is SendFriendRequestLoading ||
                      current is SendFriendRequestSuccess ||
                      current is SendFriendRequestError,
                  listener: (context, state) {
                    if (state is SendFriendRequestLoading) {
                      Loading.show(context);
                    } else if (state is SendFriendRequestSuccess) {
                      Loading.hide(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Friend request sent successfully!"),
                          backgroundColor: ColorManager.blue,
                        ),
                      );
                    } else if (state is SendFriendRequestError) {
                      Loading.hide(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: ColorManager.error,
                        ),
                      );
                    }
                  },
                  buildWhen: (previous, current) =>
                      current is GetUserLoading ||
                      current is GetUserLoaded ||
                      current is GetUserError,
                  builder: (context, state) {
                    if (state is GetUserLoading) {
                      return const SingleChildScrollView(
                        child: SkeletonListWidget(type: SkeletonType.addFriend),
                      );
                    }

                    if (state is GetUserError) {
                      return Center(child: Text(state.message));
                    }

                    if (state is GetUserLoaded) {
                      final usersToDisplay = state.filteredUsers;

                      if (usersToDisplay.isEmpty) {
                        return const CustomEmptyState(
                          icon: Icons.person_search_outlined,
                          title: "No Users Found",
                          description:
                              "We couldn't find anyone matching your search query. Try searching by username or email.",
                        );
                      }

                      return ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: usersToDisplay.length,
                        separatorBuilder: (_, __) => SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          final user = usersToDisplay[index];

                          return AddFriendCard(
                            user: user,
                            onAddPressed: () {
                              context.read<FriendCubit>().sendFriendRequest(
                                user.id,
                              );
                            },
                          );
                        },
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
