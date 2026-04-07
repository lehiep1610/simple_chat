import 'package:flutter/material.dart';
import 'package:simple_chat/features/auth/presentation/signup/pages/signup.dart';
import 'package:simple_chat/features/chats/presentation/pages/inbox.dart';
import 'package:simple_chat/features/chats/presentation/pages/thread.dart';
import 'package:simple_chat/features/home/presentation/pages/home.dart';
import '../../features/auth/presentation/login/pages/login.dart';
import '../theme/theme_provider.dart';
import 'route_names.dart';

class AppRouter {
  final ThemeProvider themeProvider;

  AppRouter({required this.themeProvider});

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.login:
        return _buildRoute(LoginPage(themeProvider: themeProvider), settings);
      case RouteNames.home:
        return _buildRoute(Home(), settings);
      case RouteNames.register:
        return _buildRoute(SignUpPage(), settings);
      case RouteNames.inbox:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildRoute(Inbox(userId: args['userId'] as String), settings);
      case RouteNames.chat:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          Thread(
            friendId: args['friendId'] as String,
            friendName: args['friendName'] as String,
            userId: args['userId'] as String,
            conversationId: args['conversationId'] as String?,
          ),
          settings,
        );
      default:
        return _buildRoute(LoginPage(themeProvider: themeProvider), settings);
    }
  }

  static Route<dynamic> _buildRoute(Widget page, RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }

  // Helper methods for navigation
  static void navigateTo(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  static void navigateAndReplace(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }

  static void navigateAndClearStack(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  static void pop(BuildContext context, [dynamic result]) {
    Navigator.pop(context, result);
  }
}
