import 'package:flutter/material.dart';
import 'package:mandalart/core/theme/app_theme.dart';
import 'package:mandalart/features/startup/startup_screen.dart';

class MandalartApp extends StatelessWidget {
  const MandalartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mandalart',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      home: const StartupScreen(),
    );
  }
}
