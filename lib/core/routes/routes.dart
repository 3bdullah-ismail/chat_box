import 'package:chat_app/features/auth/presentation/pages/sign_in_page.dart';
import 'package:chat_app/features/auth/presentation/pages/signup_page.dart';
import 'package:chat_app/features/friends/presentation/pages/add_friends.dart';
import 'package:chat_app/features/friends/presentation/pages/friend_requests.dart';
import 'package:chat_app/features/layout/presentation/pages/layout.dart';
import 'package:chat_app/features/onboarding/page/onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/presentation/pages/reset_pass.dart';
import '../../features/chat/presentation/manager/chat_cubit.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/friends/presentation/manager/friend_cubit.dart';
import '../di/injection_container.dart';
import 'app_routes_names.dart';

class Routes {
  static final GoRouter router = GoRouter(
    initialLocation: AppRouteNames.onboarding,
    redirect: (context, state) async {
      final prefs = await SharedPreferences.getInstance();
      final seenOnboarding = prefs.getBool('seen_onboarding') ?? false;
      final isLoggedIn = FirebaseAuth.instance.currentUser != null;

      final isGoingToOnboarding =
          state.matchedLocation == AppRouteNames.onboarding;
      final isGoingToAuth =
          state.matchedLocation == AppRouteNames.signIn ||
          state.matchedLocation == AppRouteNames.signUp ||
          state.matchedLocation == AppRouteNames.resetPassWord;
      if (!seenOnboarding) {
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
        path: AppRouteNames.chat,
        builder: (context, state) => const ChatPage(),
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
