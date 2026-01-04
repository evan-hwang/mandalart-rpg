import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mandalart/core/constants/app_colors.dart';
import 'package:mandalart/core/constants/grid_constants.dart';
import 'package:mandalart/core/models/goal.dart';
import 'package:mandalart/core/services/preferences_service.dart';
import 'package:mandalart/data/db/app_database.dart';
import 'package:mandalart/data/goal_repository.dart';
import 'package:mandalart/data/mandalart_repository.dart';
import 'package:mandalart/features/home/home_screen.dart';
import 'package:mandalart/features/home/widgets/create_mandalart_sheet.dart';
import 'package:mandalart/features/mandalart/mandalart.dart';
import 'package:mandalart/features/mandalart/widgets/goal_edit_sheet.dart';
import 'package:mandalart/features/mandalart/widgets/mandalart_grid.dart';
import 'package:mandalart/features/mandalart/widgets/memo_list_sheet.dart';
import 'package:mandalart/features/mandalart/widgets/mandalart_header.dart';
import 'package:mandalart/features/mandalart/widgets/share_card.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

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
  final ScreenshotController _screenshotController = ScreenshotController();

  List<Goal> _currentGoals = [];
  late Mandalart _mandalart;

  @override
  void initState() {
    super.initState();
    _mandalart = widget.mandalart;
    _saveLastMandalartId();
  }

  /// 마지막 만다라트 ID 저장
  Future<void> _saveLastMandalartId() async {
    final prefs = await PreferencesService.getInstance();
    await prefs.setLastMandalartId(_mandalart.id);
  }

  /// 만다라트 수정
  Future<void> _editMandalart() async {
    final result = await CreateMandalartSheet.show(context, existing: _mandalart);
    if (result != null) {
      await _mandalartRepository.saveMandalart(result.mandalart);
      setState(() {
        _mandalart = result.mandalart;
      });
    }
  }

  /// 셀 탭 - 역할에 따라 다른 동작
  Future<void> _onCellTap(Goal goal) async {
    if (goal.role == CellRole.sub) {
      // 서브 과제: 회고(메모) 리스트 보기
      _showMemoList(goal);
    } else {
      // 메인/세부 과제: 편집 시트 열기
      final updatedGoal = await GoalEditSheet.show(context, goal);
      if (updatedGoal == null) return;
      await _saveGoal(updatedGoal);
    }
  }

  /// 서브 과제의 메모 리스트 보기
  void _showMemoList(Goal subGoal) {
    final detailIndices = kSubGoalDetailMapping[subGoal.gridIndex];
    if (detailIndices == null) return;

    final detailGoals = detailIndices
        .map((idx) => _currentGoals.firstWhere(
              (g) => g.gridIndex == idx,
              orElse: () => Goal(mandalartId: subGoal.mandalartId, gridIndex: idx),
            ))
        .toList();

    MemoListSheet.show(
      context,
      subGoal: subGoal,
      detailGoals: detailGoals,
      onGoalTap: (goal) async {
        // 세부 목표 편집 시트 열기
        final updatedGoal = await GoalEditSheet.show(context, goal);
        if (updatedGoal == null) return;
        await _saveGoal(updatedGoal);
      },
    );
  }

  /// 셀 롱프레스 - 역할에 따라 다른 동작
  Future<void> _onCellLongPress(Goal goal) async {
    if (goal.role == CellRole.detail) {
      // 세부 과제: 상태 토글
      final nextStatus = goal.status.next;
      final updatedGoal = goal.copyWith(status: nextStatus);
      await _saveGoal(updatedGoal);
    } else {
      // 메인/서브 과제: 편집 시트 열기
      final updatedGoal = await GoalEditSheet.show(context, goal);
      if (updatedGoal == null) return;
      await _saveGoal(updatedGoal);
    }
  }

  /// 목표 저장 + 자동 완료 체크
  Future<void> _saveGoal(Goal goal) async {
    await _repository.saveGoal(
      mandalartId: goal.mandalartId,
      gridIndex: goal.gridIndex,
      text: goal.text,
      status: goal.status.value,
      memo: goal.memo,
    );

    // 세부 과제가 완료되면 자동 완료 체크
    if (goal.role == CellRole.detail && goal.isDone) {
      await _checkAutoComplete(goal.mandalartId);
    }
  }

  /// 자동 완료 로직: 세부 5개 완료 → 서브 완료, 서브 4개 완료 → 메인 완료
  Future<void> _checkAutoComplete(String mandalartId) async {
    final entities = await _repository.watchGoals(mandalartId).first;
    final goals = _mapEntitiesToGoals(entities);

    // 각 서브 목표 체크
    for (final subIndex in kSubIndices) {
      if (goals.isSubGoalComplete(subIndex)) {
        // 서브 목표의 현재 상태 확인
        final subGoal = goals.goalAt(subIndex);
        if (subGoal != null && !subGoal.isDone) {
          // 서브 목표 자동 완료
          await _repository.saveGoal(
            mandalartId: mandalartId,
            gridIndex: subIndex,
            text: subGoal.text,
            status: GoalStatus.done.value,
            memo: subGoal.memo,
          );
        }
      }
    }

    // 모든 서브 완료 시 메인 자동 완료
    // 최신 상태 다시 조회
    final updatedEntities = await _repository.watchGoals(mandalartId).first;
    final updatedGoals = _mapEntitiesToGoals(updatedEntities);

    if (updatedGoals.allSubGoalsComplete) {
      final mainGoal = updatedGoals.goalAt(kMainIndex);
      if (mainGoal != null && !mainGoal.isDone) {
        await _repository.saveGoal(
          mandalartId: mandalartId,
          gridIndex: kMainIndex,
          text: mainGoal.text,
          status: GoalStatus.done.value,
          memo: mainGoal.memo,
        );
      }
    }
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
        updatedAt: e.updatedAt,
      );
    }).toList();
  }

  /// 만다라트 이미지로 공유
  Future<void> _shareAsImage() async {
    try {
      // 공유 카드 캡쳐
      final Uint8List? imageBytes = await _screenshotController.captureFromWidget(
        MediaQuery(
          data: const MediaQueryData(),
          child: Material(
            child: ShareCard(
              title: _mandalart.title,
              deadline: _mandalart.dateRangeLabel,
              goals: _currentGoals,
            ),
          ),
        ),
        pixelRatio: 3.0,
        delay: const Duration(milliseconds: 100),
      );

      if (imageBytes == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('이미지 생성에 실패했습니다')),
          );
        }
        return;
      }

      // 임시 파일로 저장
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/mandalart_${DateTime.now().millisecondsSinceEpoch}.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(imageBytes);

      // 공유 (iOS에서는 sharePositionOrigin 필요)
      final box = context.findRenderObject() as RenderBox?;
      await Share.shareXFiles(
        [XFile(imagePath)],
        text: '${_mandalart.title} - 한다라트',
        sharePositionOrigin: box != null
            ? box.localToGlobal(Offset.zero) & box.size
            : const Rect.fromLTWH(0, 0, 100, 100),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('공유 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => _goToHome(),
        ),
        title: const Text('한다라트'),
      ),
      body: StreamBuilder<List<GoalEntity>>(
        stream: _repository.watchGoals(_mandalart.id),
        builder: (context, snapshot) {
          final goals = snapshot.hasData
              ? _mapEntitiesToGoals(snapshot.data!)
              : <Goal>[];

          // 공유용으로 현재 goals 저장
          _currentGoals = goals;

          return Column(
            children: [
              // 헤더 (이모지, 제목, 달성률, 기한)
              MandalartHeader(
                title: _mandalart.title,
                emoji: _mandalart.emoji,
                deadline: _mandalart.dateRangeLabel,
                goals: goals,
                onMenuTap: () => _showMandalartOptions(context),
              ),

              // 5x5 그리드
              Expanded(
                child: Center(
                  child: MandalartGrid(
                    goals: goals,
                    mandalartId: _mandalart.id,
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
                      onPressed: _shareAsImage,
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
        title: const Text('한다라트 삭제'),
        content: Text(
          '"${_mandalart.title}"을(를) 삭제하시겠습니까?\n모든 목표도 함께 삭제됩니다.',
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
      await _mandalartRepository.deleteMandalart(_mandalart.id);
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
                title: const Text('한다라트 수정'),
                onTap: () {
                  Navigator.pop(context);
                  _editMandalart();
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
