import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mandalart/core/constants/app_colors.dart';
import 'package:mandalart/core/constants/grid_constants.dart';
import 'package:mandalart/core/models/goal.dart';

/// 만다라트 그리드 셀 위젯
class MandalartCell extends StatelessWidget {
  const MandalartCell({
    super.key,
    required this.goal,
    required this.onTap,
    required this.onLongPress,
  });

  final Goal goal;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final role = goal.role;

    return GestureDetector(
      onTap: onTap,
      onLongPress: () {
        HapticFeedback.mediumImpact();
        onLongPress();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: _buildDecoration(role),
        child: Stack(
          children: [
            // 메인 콘텐츠
            Center(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  goal.text.isEmpty ? _placeholderText(role) : goal.text,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: _textStyle(role, goal.text.isEmpty),
                ),
              ),
            ),

            // 완료 체크마크 (세부 과제만)
            if (role == CellRole.detail && goal.isDone)
              Positioned(
                right: 4,
                bottom: 4,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: AppColors.statusDoneCheck,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration(CellRole role) {
    return switch (role) {
      CellRole.main => BoxDecoration(
          color: AppColors.mainCell,
          borderRadius: BorderRadius.circular(12),
        ),
      CellRole.sub => BoxDecoration(
          color: AppColors.subCell,
          borderRadius: BorderRadius.circular(10),
        ),
      CellRole.detail => BoxDecoration(
          color: _detailCellColor(),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.detailCellBorder,
            width: 1,
          ),
        ),
    };
  }

  Color _detailCellColor() {
    return switch (goal.status) {
      GoalStatus.todo => AppColors.statusTodo,
      GoalStatus.doing => AppColors.statusDoing,
      GoalStatus.done => AppColors.statusDone,
    };
  }

  TextStyle _textStyle(CellRole role, bool isEmpty) {
    final baseStyle = switch (role) {
      CellRole.main => const TextStyle(
          color: AppColors.mainCellText,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
      CellRole.sub => const TextStyle(
          color: AppColors.subCellText,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
      CellRole.detail => TextStyle(
          color: isEmpty ? AppColors.textTertiary : AppColors.detailCellText,
          fontSize: 10,
          fontWeight: FontWeight.w400,
          height: 1.3,
        ),
    };

    if (isEmpty && role != CellRole.main) {
      return baseStyle.copyWith(
        color: baseStyle.color?.withValues(alpha: 0.5),
      );
    }

    return baseStyle;
  }

  String _placeholderText(CellRole role) {
    return switch (role) {
      CellRole.main => '메인 목표',
      CellRole.sub => '서브 과제',
      CellRole.detail => '',
    };
  }
}
