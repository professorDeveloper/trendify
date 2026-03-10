import 'package:flutter/material.dart';
import 'package:trendify/intro_pages/splash_page.dart';
import 'package:trendify/theme/app_theme.dart';

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
      home: SplashScreen(),
    );
  }
}
