import 'package:flutter/material.dart';
import 'package:mandalart/core/constants/app_colors.dart';
import 'package:mandalart/core/constants/grid_constants.dart' show CellRole, roleForIndex;
import 'package:mandalart/core/models/goal.dart';

/// 공유용 만다라트 카드 (이미지로 캡쳐됨)
class ShareCard extends StatelessWidget {
  const ShareCard({
    super.key,
    required this.title,
    required this.deadline,
    required this.goals,
  });

  final String title;
  final String? deadline;
  final List<Goal> goals;

  @override
  Widget build(BuildContext context) {
    final goalMap = <int, Goal>{};
    for (final goal in goals) {
      goalMap[goal.gridIndex] = goal;
    }

    return Container(
      width: 380,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 제목
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              fontFamily: 'Pretendard',
            ),
            textAlign: TextAlign.center,
          ),
          if (deadline != null && deadline!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              '목표 $deadline',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontFamily: 'Pretendard',
              ),
            ),
          ],
          const SizedBox(height: 8),
          // 진행률
          Text(
            '${goals.doneCount}/25 완료 (${(goals.progressRatio * 100).round()}%)',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
              fontFamily: 'Pretendard',
            ),
          ),
          const SizedBox(height: 20),
          // 5x5 그리드
          _buildGrid(goalMap),
          const SizedBox(height: 20),
          // 워터마크
          const Text(
            'Made with 한다라트',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textTertiary,
              fontFamily: 'Pretendard',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(Map<int, Goal> goalMap) {
    const cellSize = 60.0;
    const gap = 4.0;
    const gridSize = cellSize * 5 + gap * 4;

    return SizedBox(
      width: gridSize,
      height: gridSize,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: gap,
          crossAxisSpacing: gap,
        ),
        itemCount: 25,
        itemBuilder: (context, index) {
          final goal = goalMap[index];
          final role = roleForIndex(index);
          return _buildCell(role, goal);
        },
      ),
    );
  }

  Widget _buildCell(CellRole role, Goal? goal) {
    final hasText = goal != null && goal.text.isNotEmpty;
    final isDone = goal?.isDone ?? false;

    Color bgColor;
    Color textColor;
    Color? borderColor;

    switch (role) {
      case CellRole.main:
        bgColor = AppColors.mainCell;
        textColor = AppColors.mainCellText;
        break;
      case CellRole.sub:
        bgColor = AppColors.subCell;
        textColor = AppColors.subCellText;
        break;
      case CellRole.detail:
        if (isDone) {
          bgColor = AppColors.statusDone;
          textColor = AppColors.textPrimary;
          borderColor = AppColors.statusDoneBorder;
        } else {
          bgColor = AppColors.statusTodo;
          textColor = AppColors.detailCellText;
          borderColor = AppColors.detailCellBorder;
        }
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(role == CellRole.main ? 10 : 8),
        border: borderColor != null
            ? Border.all(color: borderColor, width: isDone ? 2 : 1)
            : null,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Text(
            hasText ? goal.text : '',
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9,
              fontWeight: role == CellRole.main ? FontWeight.w700 : FontWeight.w500,
              color: hasText ? textColor : textColor.withValues(alpha: 0.5),
              height: 1.2,
              fontFamily: 'Pretendard',
            ),
          ),
        ),
      ),
    );
  }
}
