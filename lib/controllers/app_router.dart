import 'package:codetrackio/controllers/auth_controller.dart';
import 'package:codetrackio/screens/home_screen.dart';
import 'package:codetrackio/screens/leaderboard_screen.dart';
import 'package:codetrackio/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class AppRouter {
  final GoRouter route = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => const MaterialPage(child: AuthGate()),
      ),
      GoRoute(
        path: '/home',
        redirect: (context, state) => _redirect(context),
        pageBuilder: (context, state) =>
            const MaterialPage(child: HomeScreen()),
      ),
      GoRoute(
        path: '/leaderboard',
        redirect: (context, state) => _redirect(context),
        pageBuilder: (context, state) =>
            const MaterialPage(child: LeaderboardScreen()),
      ),
      GoRoute(
        path: '/profile',
        redirect: (context, state) => _redirect(context),
        pageBuilder: (context, state) =>
            const MaterialPage(child: Text('Profile')),
      ),
      GoRoute(
        path: '/setting',
        redirect: (context, state) => _redirect(context),
        pageBuilder: (context, state) =>
            const MaterialPage(child: SettingsScreen()),
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      child: Scaffold(
        body: Center(
          child: LottieBuilder.network(
            'https://lottie.host/c0ea6fa0-f1eb-4043-bfc5-45a387379d5e/xvzmbHTqrn.json',
          ),
        ),
      ),
    ),
  );
  static String? _redirect(BuildContext context) {
    if (AuthController().getCurrentUser() != null) {
      return null;
    }
    return '/';
  }
}
