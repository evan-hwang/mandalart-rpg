import 'package:flutter/material.dart';
import 'package:mandalart/core/constants/app_colors.dart';
import 'package:mandalart/core/models/goal.dart';

/// 서브 영역의 메모 리스트를 보여주는 바텀시트
class MemoListSheet extends StatelessWidget {
  const MemoListSheet({
    super.key,
    required this.subGoal,
    required this.detailGoals,
    required this.onGoalTap,
  });

  final Goal subGoal;
  final List<Goal> detailGoals;
  final void Function(Goal goal) onGoalTap;

  static Future<void> show(
    BuildContext context, {
    required Goal subGoal,
    required List<Goal> detailGoals,
    required void Function(Goal goal) onGoalTap,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MemoListSheet(
        subGoal: subGoal,
        detailGoals: detailGoals,
        onGoalTap: onGoalTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 메모가 있는 세부 과제 수
    final memoCount = detailGoals.where((g) => g.hasMemo).length;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // 드래그 핸들 + 헤더
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 드래그 핸들 + 닫기 버튼
                    Row(
                      children: [
                        const Spacer(),
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.divider,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(Icons.close, size: 20),
                              color: AppColors.textTertiary,
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.subCell,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            subGoal.text.isEmpty ? '세부 목표' : subGoal.text,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.subCellText,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '회고',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        '${detailGoals.length}개 계획 · $memoCount개 메모',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 세부 목표 리스트 (전체)
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  itemCount: detailGoals.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final goal = detailGoals[index];
                    return _GoalCard(
                      goal: goal,
                      onTap: () {
                        Navigator.pop(context);
                        onGoalTap(goal);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// 세부 목표 카드 위젯
class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.goal,
    required this.onTap,
  });

  final Goal goal;
  final VoidCallback onTap;

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.month}월 ${date.day}일';
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = _formatDate(goal.updatedAt);
    final hasMemo = goal.hasMemo;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단: 목표 제목 + 상태 + 날짜
            Row(
              children: [
                // 완료 상태 표시
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: goal.isDone ? AppColors.success : AppColors.textTertiary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    goal.text.isEmpty ? '계획' : goal.text,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (dateStr.isNotEmpty)
                  Text(
                    dateStr,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
            // 메모가 있으면 표시
            if (hasMemo) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.sticky_note_2_outlined,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        goal.memo,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
