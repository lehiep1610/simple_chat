import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RouteObserver extends NavigatorObserver {
  final List<Route<dynamic>> _routeStack = [];

  List<String> get routeStack =>
      _routeStack.map((r) => r.settings.name ?? 'unknown').toList();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routeStack.add(route);
    _logStack('PUSH', route.settings.name);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routeStack.remove(route);
    _logStack('POP', route.settings.name);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routeStack.remove(route);
    _logStack('REMOVE', route.settings.name);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute != null) {
      final index = _routeStack.indexOf(oldRoute);
      if (index != -1 && newRoute != null) {
        _routeStack[index] = newRoute;
      }
    }
    _logStack(
      'REPLACE',
      '${oldRoute?.settings.name} → ${newRoute?.settings.name}',
    );
  }

  void _logStack(String action, String? routeName) {
    if (kDebugMode) {
      print('═══════════════════════════════════════════');
      print('NAV ACTION: $action - $routeName');
      print('STACK (${_routeStack.length} routes):');
      for (int i = _routeStack.length - 1; i >= 0; i--) {
        final route = _routeStack[i];
        final marker = i == _routeStack.length - 1 ? '→ ' : '  ';
        print('   $marker[$i] ${route.settings.name ?? 'unknown'}');
      }
      print('═══════════════════════════════════════════');
    }
  }
}

// Global instance
final routeObserver = RouteObserver();
