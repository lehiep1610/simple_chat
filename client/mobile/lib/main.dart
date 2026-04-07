import 'package:flutter/material.dart';
import 'package:simple_chat/core/di/service_locator.dart';
import 'package:simple_chat/core/router/app_router.dart';
import 'package:simple_chat/core/router/route_names.dart';
import 'package:simple_chat/core/router/route_observer.dart';
import 'package:simple_chat/core/session/auth_session_manager.dart';
import 'package:simple_chat/core/theme/app_theme.dart';
import 'package:simple_chat/core/theme/theme_provider.dart';
import 'package:simple_chat/features/auth/presentation/login/pages/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthSessionManager.instance.initialize();
  setupServiceLocator();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final ThemeProvider _themeProvider = ThemeProvider();
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(themeProvider: _themeProvider);
  }

  @override
  void dispose() {
    _themeProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeProvider.themeMode,
      builder: (context, themeMode, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        onGenerateRoute: _appRouter.generateRoute,
        navigatorObservers: [routeObserver],
        home: LoginPage(themeProvider: _themeProvider),
      ),
    );
  }
}
