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
    this.isAreaComplete = false,
    this.isAllComplete = false,
  });

  final Goal goal;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool isAreaComplete; // 이 셀의 영역이 모두 완료됨
  final bool isAllComplete;  // 모든 영역이 완료됨 (메인 완료)

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
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
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
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration(CellRole role) {
    return switch (role) {
      CellRole.main => BoxDecoration(
          color: isAllComplete ? const Color(0xFF1E2D3D) : AppColors.mainCell,
          borderRadius: BorderRadius.circular(12),
          border: isAllComplete
              ? Border.all(color: const Color(0xFFD4A574), width: 2)
              : null,
          boxShadow: isAllComplete
              ? [
                  BoxShadow(
                    color: const Color(0xFFD4A574).withValues(alpha: 0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
      CellRole.sub => BoxDecoration(
          color: isAreaComplete
              ? const Color(0xFFB8956A) // 진한 머스타드
              : AppColors.subCell,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isAreaComplete
              ? [
                  BoxShadow(
                    color: AppColors.primaryDark.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
      CellRole.detail => BoxDecoration(
          color: _detailCellColor(),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _detailBorderColor(),
            width: goal.isDone ? 2 : 1,
          ),
        ),
    };
  }

  Color _detailCellColor() {
    return switch (goal.status) {
      GoalStatus.todo => AppColors.statusTodo,
      GoalStatus.done => AppColors.statusDone,
    };
  }

  Color _detailBorderColor() {
    return switch (goal.status) {
      GoalStatus.todo => AppColors.detailCellBorder,
      GoalStatus.done => AppColors.statusDoneBorder,
    };
  }

  TextStyle _textStyle(CellRole role, bool isEmpty) {
    final baseStyle = switch (role) {
      CellRole.main => TextStyle(
          color: isAllComplete ? const Color(0xFFD4A574) : AppColors.mainCellText,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
      CellRole.sub => TextStyle(
          color: isAreaComplete ? const Color(0xFFFFFEFB) : AppColors.subCellText,
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
      CellRole.main => '목표',
      CellRole.sub => '세부 목표',
      CellRole.detail => '계획',
    };
  }
}
