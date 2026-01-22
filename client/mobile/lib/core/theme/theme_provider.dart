import 'package:flutter/material.dart';

class ThemeProvider {
  ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);

  void toggleTheme() {
    themeMode.value = themeMode.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  void setTheme(ThemeMode themeMode) {
    themeMode = themeMode;
  }

  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  void dispose() {
    themeMode.dispose();
  }
}
