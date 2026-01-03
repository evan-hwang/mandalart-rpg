import 'package:flutter/material.dart';
import 'package:mandalart/core/constants/app_colors.dart';
import 'package:mandalart/core/constants/grid_constants.dart';
import 'package:mandalart/core/models/goal.dart';
import 'package:mandalart/core/services/preferences_service.dart';
import 'package:mandalart/data/db/app_database.dart';
import 'package:mandalart/data/goal_repository.dart';
import 'package:mandalart/data/mandalart_repository.dart';
import 'package:mandalart/features/home/home_screen.dart';
import 'package:mandalart/features/mandalart/mandalart.dart';
import 'package:mandalart/features/mandalart/widgets/goal_edit_sheet.dart';
import 'package:mandalart/features/mandalart/widgets/mandalart_grid.dart';
import 'package:mandalart/features/mandalart/widgets/mandalart_header.dart';

class MandalartDetailScreen extends StatefulWidget {
  const MandalartDetailScreen({
    super.key,
    required this.mandalart,
  });

  final Mandalart mandalart;

  @override
  State<MandalartDetailScreen> createState() => _MandalartDetailScreenState();
}

class _MandalartDetailScreenState extends State<MandalartDetailScreen> {
  final GoalRepository _repository = GoalRepository(appDatabase);
  final MandalartRepository _mandalartRepository = MandalartRepository(appDatabase);

  @override
  void initState() {
    super.initState();
    _saveLastMandalartId();
  }

  /// 마지막 만다라트 ID 저장
  Future<void> _saveLastMandalartId() async {
    final prefs = await PreferencesService.getInstance();
    await prefs.setLastMandalartId(widget.mandalart.id);
  }

  /// 셀 탭 - 편집 시트 열기
  Future<void> _onCellTap(Goal goal) async {
    final updatedGoal = await GoalEditSheet.show(context, goal);
    if (updatedGoal == null) return;

    await _saveGoal(updatedGoal);
  }

  /// 셀 롱프레스 - 상태 토글
  Future<void> _onCellLongPress(Goal goal) async {
    // 세부 과제만 상태 토글 가능
    if (goal.role != CellRole.detail) {
      _onCellTap(goal);
      return;
    }

    final nextStatus = goal.status.next;
    final updatedGoal = goal.copyWith(status: nextStatus);
    await _saveGoal(updatedGoal);
  }

  /// 목표 저장
  Future<void> _saveGoal(Goal goal) async {
    await _repository.saveGoal(
      mandalartId: goal.mandalartId,
      gridIndex: goal.gridIndex,
      text: goal.text,
      status: goal.status.value,
      memo: goal.memo,
    );
  }

  /// GoalEntity -> Goal 변환
  List<Goal> _mapEntitiesToGoals(List<GoalEntity> entities) {
    return entities.map((e) {
      return Goal(
        mandalartId: e.mandalartId,
        gridIndex: e.gridIndex,
        text: e.goalText,
        status: GoalStatus.fromValue(e.status),
        memo: e.memo ?? '',
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('만다라트'),
        actions: [
          TextButton.icon(
            onPressed: () => _goToHome(),
            icon: const Icon(Icons.grid_view, size: 18),
            label: const Text('목록'),
          ),
        ],
      ),
      body: StreamBuilder<List<GoalEntity>>(
        stream: _repository.watchGoals(widget.mandalart.id),
        builder: (context, snapshot) {
          final goals = snapshot.hasData
              ? _mapEntitiesToGoals(snapshot.data!)
              : <Goal>[];

          return Column(
            children: [
              // 헤더 (이모지, 제목, 달성률, 기한)
              MandalartHeader(
                title: widget.mandalart.title,
                emoji: null, // TODO: 이모지 필드 추가 후 연결
                deadline: widget.mandalart.dateRangeLabel,
                goals: goals,
                onMenuTap: () => _showMandalartOptions(context),
              ),

              // 5x5 그리드
              Expanded(
                child: Center(
                  child: MandalartGrid(
                    goals: goals,
                    mandalartId: widget.mandalart.id,
                    onCellTap: _onCellTap,
                    onCellLongPress: _onCellLongPress,
                  ),
                ),
              ),

              // 하단 공유 버튼
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: 공유 기능 구현
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('공유 기능은 준비 중입니다')),
                        );
                      },
                      icon: const Icon(Icons.share_outlined, size: 18),
                      label: const Text('공유하기'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: const BorderSide(color: AppColors.divider),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 홈 화면으로 이동
  void _goToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  /// 만다라트 삭제
  Future<void> _deleteMandalart() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('만다라트 삭제'),
        content: Text(
          '"${widget.mandalart.title}"을(를) 삭제하시겠습니까?\n모든 목표도 함께 삭제됩니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // 마지막 만다라트 ID 삭제
      final prefs = await PreferencesService.getInstance();
      await prefs.clearLastMandalartId();
      // 만다라트 삭제
      await _mandalartRepository.deleteMandalart(widget.mandalart.id);
      // 홈 화면으로 이동
      if (mounted) _goToHome();
    }
  }

  void _showMandalartOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('만다라트 수정'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: 수정 기능
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: AppColors.error),
                title: const Text('삭제', style: TextStyle(color: AppColors.error)),
                onTap: () {
                  Navigator.pop(context);
                  _deleteMandalart();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
