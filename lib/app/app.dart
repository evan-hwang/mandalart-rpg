import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mandalart/core/theme/app_theme.dart';
import 'package:mandalart/features/startup/startup_screen.dart';

class MandalartApp extends StatelessWidget {
  const MandalartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '한다라트',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      locale: const Locale('ko', 'KR'),
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const StartupScreen(),
    );
  }
}
