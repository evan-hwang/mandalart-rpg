import 'package:flutter/material.dart';
import 'package:mandalart/core/constants/app_colors.dart';
import 'package:mandalart/core/models/goal.dart';
import 'package:mandalart/data/db/app_database.dart';
import 'package:mandalart/data/goal_repository.dart';
import 'package:mandalart/data/mandalart_repository.dart';
import 'package:mandalart/features/home/widgets/create_mandalart_sheet.dart';
import 'package:mandalart/features/home/widgets/mandalart_card.dart';
import 'package:mandalart/features/mandalart/mandalart.dart';
import 'package:mandalart/features/mandalart/mandalart_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MandalartRepository _mandalartRepository = MandalartRepository(appDatabase);
  final GoalRepository _goalRepository = GoalRepository(appDatabase);

  Future<void> _createMandalart() async {
    final result = await CreateMandalartSheet.show(context);
    if (result != null) {
      await _mandalartRepository.saveMandalart(result);
    }
  }

  Future<void> _editMandalart(Mandalart mandalart) async {
    final result = await CreateMandalartSheet.show(context, existing: mandalart);
    if (result != null) {
      await _mandalartRepository.saveMandalart(result);
    }
  }

  Future<void> _deleteMandalart(Mandalart mandalart) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('한다라트 삭제'),
        content: Text('"${mandalart.title}"을(를) 삭제하시겠습니까?\n모든 목표도 함께 삭제됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _mandalartRepository.deleteMandalart(mandalart.id);
    }
  }

  void _openMandalart(Mandalart mandalart) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MandalartDetailScreen(mandalart: mandalart),
      ),
    );
  }

  /// 만다라트별 달성률 계산 (25개 기준)
  Future<int> _calculateProgress(String mandalartId) async {
    final goalEntities = await _goalRepository.watchGoals(mandalartId).first;
    if (goalEntities.isEmpty) return 0;

    // GoalEntity를 Goal로 변환
    final goals = goalEntities.map((e) {
      return Goal(
        mandalartId: e.mandalartId,
        gridIndex: e.gridIndex,
        text: e.goalText,
        status: GoalStatus.fromValue(e.status),
        memo: e.memo ?? '',
      );
    }).toList();

    return goals.progressPercent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('한다라트'),
      ),
      body: StreamBuilder<List<Mandalart>>(
        stream: _mandalartRepository.watchMandalarts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final mandalarts = snapshot.data ?? [];

          if (mandalarts.isEmpty) {
            return _EmptyState(onCreate: _createMandalart);
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: mandalarts.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final mandalart = mandalarts[index];

              return FutureBuilder<int>(
                future: _calculateProgress(mandalart.id),
                builder: (context, progressSnapshot) {
                  final progress = progressSnapshot.data ?? 0;

                  return Dismissible(
                    key: ValueKey(mandalart.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                      ),
                    ),
                    confirmDismiss: (_) async {
                      await _deleteMandalart(mandalart);
                      return false; // 직접 삭제 처리하므로 false 반환
                    },
                    child: MandalartCard(
                      mandalart: mandalart,
                      progressPercent: progress,
                      onTap: () => _openMandalart(mandalart),
                      onLongPress: () => _editMandalart(mandalart),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createMandalart,
        icon: const Icon(Icons.add),
        label: const Text('만들기'),
      ),
    );
  }
}

/// 빈 상태 위젯
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.grid_view_rounded,
                size: 40,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '아직 한다라트가 없어요',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '꿈을 향한 여정을\n25칸에 담아보세요',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add),
              label: const Text('첫 한다라트 만들기'),
            ),
          ],
        ),
      ),
    );
  }
}
