import 'package:flutter/material.dart';
import 'package:mandalart/core/constants/grid_constants.dart';
import 'package:mandalart/core/models/goal.dart';
import 'package:mandalart/features/mandalart/widgets/mandalart_cell.dart';

/// 5x5 만다라트 그리드 위젯
class MandalartGrid extends StatelessWidget {
  const MandalartGrid({
    super.key,
    required this.goals,
    required this.mandalartId,
    required this.onCellTap,
    required this.onCellLongPress,
  });

  final List<Goal> goals;
  final String mandalartId;
  final void Function(Goal goal) onCellTap;
  final void Function(Goal goal) onCellLongPress;

  @override
  Widget build(BuildContext context) {
    // 인덱스별 Goal 맵 생성
    final goalMap = <int, Goal>{};
    for (final goal in goals) {
      goalMap[goal.gridIndex] = goal;
    }

    // 영역별 완료 상태 미리 계산
    final areaCompleted = <AreaId, bool>{};
    for (final area in AreaId.values) {
      areaCompleted[area] = goals.isAreaDetailsDone(area);
    }
    final isAllComplete = goals.allSubGoalsComplete;

    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: kGridSize,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
          ),
          itemCount: kTotalCells,
          itemBuilder: (context, index) {
            final goal = goalMap[index] ??
                Goal(
                  mandalartId: mandalartId,
                  gridIndex: index,
                );

            // 이 셀이 속한 영역이 완료되었는지
            final area = getAreaForIndex(index);
            final isAreaComplete = area != null && (areaCompleted[area] ?? false);

            return MandalartCell(
              goal: goal,
              isAreaComplete: isAreaComplete,
              isAllComplete: isAllComplete,
              onTap: () => onCellTap(goal),
              onLongPress: () => onCellLongPress(goal),
            );
          },
        ),
      ),
    );
  }
}
