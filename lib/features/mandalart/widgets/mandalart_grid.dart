import 'package:flutter/material.dart';
import 'package:mandalart/core/constants/app_colors.dart';
import 'package:mandalart/core/constants/grid_constants.dart';
import 'package:mandalart/core/models/goal.dart';
import 'package:mandalart/features/mandalart/widgets/mandalart_cell.dart';

/// 5x5 만다라트 그리드 위젯
/// 4개 서브 영역이 명확히 구분되는 레이아웃
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
    final goalMap = <int, Goal>{};
    for (final goal in goals) {
      goalMap[goal.gridIndex] = goal;
    }

    final areaCompleted = <AreaId, bool>{};
    for (final area in AreaId.values) {
      areaCompleted[area] = goals.isAreaDetailsDone(area);
    }
    final isAllComplete = goals.allSubGoalsComplete;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // 간격 설정 - 모든 영역 간 동일한 gap 사용
          const cellGap = 4.0; // 셀 간 기본 간격
          const areaGap = 14.0; // 영역 간 간격
          const bezel = 6.0; // 영역 배경이 셀 밖으로 확장되는 양

          final gridWidth = constraints.maxWidth;

          // 4개 영역을 배치
          // 가로: TL(3셀+2gap+2bezel) + areaGap + TR(2셀+1gap+2bezel)
          // 총 너비: 5*cellSize + 3*cellGap + areaGap + 4*bezel

          final cellSize =
              (gridWidth - 3 * cellGap - areaGap - 4 * bezel) / 5;

          // 영역 크기 계산
          final leftAreaW = 3 * cellSize + 2 * cellGap + 2 * bezel;
          final rightAreaW = 2 * cellSize + 1 * cellGap + 2 * bezel;
          final topLeftH = 2 * cellSize + 1 * cellGap + 2 * bezel;
          final bottomLeftH = 3 * cellSize + 2 * cellGap + 2 * bezel;
          final topRightH = 3 * cellSize + 2 * cellGap + 2 * bezel;
          final bottomRightH = 2 * cellSize + 1 * cellGap + 2 * bezel;

          // 영역 위치 계산
          // TL: 좌상단 (0, 0)
          final tlX = 0.0;
          final tlY = 0.0;
          // TR: TL 오른쪽 (areaGap 간격)
          final trX = leftAreaW + areaGap;
          final trY = 0.0;
          // BL: TL 아래쪽 (areaGap 간격)
          final blX = 0.0;
          final blY = topLeftH + areaGap;
          // BR: BL 오른쪽, TR 아래쪽 (areaGap 간격)
          final brX = rightAreaW + areaGap; // BL 너비 + 간격
          final brY = topRightH + areaGap; // TR 높이 + 간격

          // 총 높이 (왼쪽 기준)
          final gridHeight = topLeftH + areaGap + bottomLeftH;

          // 메인 셀 위치 (그리드 정중앙)
          final mainX = (gridWidth - cellSize) / 2;
          final mainY = (gridHeight - cellSize) / 2;

          // 각 셀의 절대 위치를 영역별로 계산
          Map<int, Offset> cellPositions = {};

          // TL 영역 (cols 0-2, rows 0-1): 6셀
          for (int r = 0; r < 2; r++) {
            for (int c = 0; c < 3; c++) {
              final idx = r * 5 + c;
              cellPositions[idx] = Offset(
                tlX + bezel + c * (cellSize + cellGap),
                tlY + bezel + r * (cellSize + cellGap),
              );
            }
          }

          // TR 영역 (cols 3-4, rows 0-2): 6셀
          for (int r = 0; r < 3; r++) {
            for (int c = 0; c < 2; c++) {
              final idx = r * 5 + (c + 3);
              cellPositions[idx] = Offset(
                trX + bezel + c * (cellSize + cellGap),
                trY + bezel + r * (cellSize + cellGap),
              );
            }
          }

          // BL 영역 (cols 0-1, rows 2-4): 6셀
          for (int r = 0; r < 3; r++) {
            for (int c = 0; c < 2; c++) {
              final idx = (r + 2) * 5 + c;
              cellPositions[idx] = Offset(
                blX + bezel + c * (cellSize + cellGap),
                blY + bezel + r * (cellSize + cellGap),
              );
            }
          }

          // BR 영역 (cols 2-4, rows 3-4): 6셀
          for (int r = 0; r < 2; r++) {
            for (int c = 0; c < 3; c++) {
              final idx = (r + 3) * 5 + (c + 2);
              cellPositions[idx] = Offset(
                brX + bezel + c * (cellSize + cellGap),
                brY + bezel + r * (cellSize + cellGap),
              );
            }
          }

          // MAIN 셀 (col 2, row 2): 1셀
          cellPositions[12] = Offset(mainX, mainY);

          return SizedBox(
            width: gridWidth,
            height: gridHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 1층: 4개 영역 배경
                // TL
                Positioned(
                  left: tlX,
                  top: tlY,
                  width: leftAreaW,
                  height: topLeftH,
                  child: _AreaBox(
                    isComplete: areaCompleted[AreaId.topLeft] ?? false,
                  ),
                ),
                // TR
                Positioned(
                  left: trX,
                  top: trY,
                  width: rightAreaW,
                  height: topRightH,
                  child: _AreaBox(
                    isComplete: areaCompleted[AreaId.topRight] ?? false,
                  ),
                ),
                // BL
                Positioned(
                  left: blX,
                  top: blY,
                  width: rightAreaW, // BL is 2 cols wide
                  height: bottomLeftH,
                  child: _AreaBox(
                    isComplete: areaCompleted[AreaId.bottomLeft] ?? false,
                  ),
                ),
                // BR
                Positioned(
                  left: brX,
                  top: brY,
                  width: leftAreaW, // BR is 3 cols wide
                  height: bottomRightH,
                  child: _AreaBox(
                    isComplete: areaCompleted[AreaId.bottomRight] ?? false,
                  ),
                ),

                // 2층: 25개 셀
                ...List.generate(kTotalCells, (index) {
                  final pos = cellPositions[index]!;
                  final goal = goalMap[index] ??
                      Goal(mandalartId: mandalartId, gridIndex: index);

                  final area = getAreaForIndex(index);
                  final isAreaComplete =
                      area != null && (areaCompleted[area] ?? false);

                  return Positioned(
                    left: pos.dx,
                    top: pos.dy,
                    width: cellSize,
                    height: cellSize,
                    child: MandalartCell(
                      goal: goal,
                      isAreaComplete: isAreaComplete,
                      isAllComplete: isAllComplete,
                      onTap: () => onCellTap(goal),
                      onLongPress: () => onCellLongPress(goal),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// 영역 배경 박스
class _AreaBox extends StatelessWidget {
  const _AreaBox({
    required this.isComplete,
  });

  final bool isComplete;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: isComplete ? AppColors.areaComplete : AppColors.areaNormal,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isComplete
            ? [
                BoxShadow(
                  color: AppColors.success.withValues(alpha: 0.25),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
    );
  }
}
