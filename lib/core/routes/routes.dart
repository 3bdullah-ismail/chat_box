import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silora/features/auth/presentation/pages/sign_in_page.dart';
import 'package:silora/features/auth/presentation/pages/signup_page.dart';
import 'package:silora/features/friends/presentation/pages/add_friends.dart';
import 'package:silora/features/friends/presentation/pages/friend_requests.dart';
import 'package:silora/features/layout/presentation/pages/layout.dart';
import 'package:silora/features/onboarding/page/onboarding.dart';

import '../../features/auth/data/models/user_model.dart';
import '../../features/auth/presentation/manager/auth_cubit.dart';
import '../../features/auth/presentation/pages/reset_pass.dart';
import '../../features/chat/presentation/manager/chat_cubit.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/friends/presentation/manager/friend_cubit.dart';
import '../../features/profile/presentation/manager/profile_cubit.dart';
import '../../features/profile/presentation/pages/choose_location_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/friend_profile_page.dart';
import '../di/injection_container.dart';
import '../constants/constant_manager.dart';
import 'app_routes_names.dart';

class Routes {
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: AppRouteNames.onboarding,
      redirect: (context, state) async {
        final prefs = await SharedPreferences.getInstance();
        final hasSeenOnboarding = prefs.getBool(AppConstants.seenOnboardingKey) ?? false;
        final isLoggedIn = FirebaseAuth.instance.currentUser != null;

        final isGoingToOnboarding =
            state.matchedLocation == AppRouteNames.onboarding;
        final isGoingToAuth =
            state.matchedLocation == AppRouteNames.signIn ||
            state.matchedLocation == AppRouteNames.signUp ||
            state.matchedLocation == AppRouteNames.resetPassWord;
        if (!hasSeenOnboarding) {
          return isGoingToOnboarding ? null : AppRouteNames.onboarding;
        }
        if (!isLoggedIn) {
          if (isGoingToAuth || isGoingToOnboarding) return null;
          return AppRouteNames.signIn;
        }
        if (isLoggedIn && (isGoingToAuth || isGoingToOnboarding)) {
          return AppRouteNames.layout;
        }
        return null;
      },
    routes: [
      GoRoute(
        path: AppRouteNames.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRouteNames.resetPassWord,
        builder: (context, state) => const ResetPassWord(),
      ),
      GoRoute(
        path: AppRouteNames.addFriends,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<FriendCubit>()..getUsers(),
          child: const AddFriends(),
        ),
      ),
      GoRoute(
        path: AppRouteNames.layout,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<FriendCubit>()),
            BlocProvider(create: (_) => getIt<ChatCubit>()),
            BlocProvider(create: (_) => getIt<AuthCubit>()),
            BlocProvider(create: (_) => getIt<ProfileCubit>()),
          ],
          child: const LayoutPage(),
        ),
      ),
      GoRoute(
        path: AppRouteNames.signIn,
        builder: (context, state) => const SignIn(),
      ),
      GoRoute(
        path: AppRouteNames.signUp,
        builder: (context, state) => const Signup(),
      ),
      GoRoute(
        path: AppRouteNames.friendRequest,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<FriendCubit>()..getFriendRequests(),
          child: const FriendRequests(),
        ),
      ),
      GoRoute(
        path: AppRouteNames.editProfile,
        builder: (context, state) {
          final user = state.extra as UserModel;
          return BlocProvider.value(
            value: getIt<ProfileCubit>(),
            child: EditProfilePage(user: user),
          );
        },
      ),
      GoRoute(
        path: AppRouteNames.friendProfile,
        builder: (context, state) {
          final user = state.extra as UserModel;
          return FriendProfilePage(user: user);
        },
      ),
      GoRoute(
        path: AppRouteNames.chat,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;

          return ChatPage(
            conversationId: extra['conversationId'] as String,
            friendUser: extra['friendUser'] as UserModel,
          );
        },
      ),
      GoRoute(
        path: AppRouteNames.chooseLocation,
        builder: (context, state) {
          return ChooseLocationPage();
        },
      ),
    ],
    errorBuilder: (context, state) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        SystemNavigator.pop();
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    },
  );
}
}
