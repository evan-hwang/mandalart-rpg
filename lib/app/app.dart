import 'package:flutter/material.dart';
import 'package:mandalart/app/theme.dart';
import 'package:mandalart/features/home/home_screen.dart';

class MandalartApp extends StatelessWidget {
  const MandalartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mandalart',
      theme: buildAppTheme(),
      home: const HomeScreen(),
    );
  }
}
