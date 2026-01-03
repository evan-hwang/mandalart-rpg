import 'package:flutter/material.dart';
import 'package:mandalart/core/constants/app_colors.dart';
import 'package:mandalart/core/services/preferences_service.dart';
import 'package:mandalart/data/db/app_database.dart';
import 'package:mandalart/data/mandalart_repository.dart';
import 'package:mandalart/features/home/home_screen.dart';
import 'package:mandalart/features/mandalart/mandalart_detail_screen.dart';

/// 앱 시작 시 마지막 만다라트 로드
class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final prefs = await PreferencesService.getInstance();
    final lastId = prefs.getLastMandalartId();

    if (!mounted) return;

    if (lastId != null) {
      // 마지막 만다라트가 존재하는지 확인
      final repo = MandalartRepository(appDatabase);
      final mandalart = await repo.getMandalart(lastId);

      if (!mounted) return;

      if (mandalart != null) {
        // 마지막 만다라트로 바로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MandalartDetailScreen(mandalart: mandalart),
          ),
        );
        return;
      }
    }

    // 마지막 만다라트가 없으면 홈 화면으로
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
