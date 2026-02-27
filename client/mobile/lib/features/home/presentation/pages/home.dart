import 'package:flutter/material.dart';
import 'package:simple_chat/core/di/service_locator.dart';
import 'package:simple_chat/core/session/auth_session_manager.dart';
import 'package:simple_chat/features/chats/presentation/pages/inbox.dart';
import 'package:simple_chat/features/notifications/presentation/notifications.dart';
import 'package:simple_chat/features/people/presentation/people.dart';
import 'package:simple_chat/features/settings/presentation/settings.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    final userId = sl<AuthSessionManager>().userId ?? '';
    _pages = [
      Inbox(userId: userId),
      const PeoplePage(),
      const NotificationsPage(),
      const SettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'People',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
