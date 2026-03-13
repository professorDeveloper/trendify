import 'package:flutter/material.dart';
import 'package:trendify/features/shell/bottom_navbar.dart';

import 'core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      home: MainBottomNavbar(),
    );
  }
}
