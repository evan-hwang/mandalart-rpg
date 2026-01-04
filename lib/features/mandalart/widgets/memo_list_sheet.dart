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
    // 메모가 있는 세부 과제만 필터링
    final goalsWithMemo = detailGoals.where((g) => g.hasMemo).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.85,
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
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.divider,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
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
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 메모가 있는 세부 목표 리스트
              Expanded(
                child: goalsWithMemo.isEmpty
                    ? _EmptyState()
                    : ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        itemCount: goalsWithMemo.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final goal = goalsWithMemo[index];
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

/// 빈 상태 위젯
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_alt_outlined,
            size: 48,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 12),
          const Text(
            '아직 메모가 없어요',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
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
