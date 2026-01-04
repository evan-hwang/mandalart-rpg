import 'package:flutter/material.dart';
import 'package:mandalart/core/constants/app_colors.dart';
import 'package:mandalart/core/models/goal.dart';

/// 만다라트 상세 화면 헤더 (이모지, 제목, 달성률, 기한)
class MandalartHeader extends StatelessWidget {
  const MandalartHeader({
    super.key,
    required this.title,
    required this.emoji,
    required this.deadline,
    required this.goals,
    this.onMenuTap,
  });

  final String title;
  final String? emoji;
  final String? deadline;
  final List<Goal> goals;
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // 이모지
          if (emoji != null && emoji!.isNotEmpty)
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  emoji!,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            )
          else
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.flag_rounded,
                size: 28,
                color: AppColors.textTertiary,
              ),
            ),

          const SizedBox(height: 12),

          // 제목 + 메뉴 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onMenuTap != null) ...[
                const SizedBox(width: 4),
                IconButton(
                  onPressed: onMenuTap,
                  icon: const Icon(Icons.more_vert),
                  iconSize: 20,
                  visualDensity: VisualDensity.compact,
                  color: AppColors.textTertiary,
                ),
              ],
            ],
          ),

          const SizedBox(height: 8),

          // 25칸 그라데이션 프로그레스 바
          _GradientProgressBar(
            completed: goals.doneCount,
            total: 25,
            ratio: goals.progressRatio,
          ),

          const SizedBox(height: 10),

          // 달성률 텍스트 + 기한
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 완료 개수
              _ProgressBadge(
                completed: goals.doneCount,
                total: 25,
                ratio: goals.progressRatio,
              ),
              if (deadline != null && deadline!.isNotEmpty) ...[
                const SizedBox(width: 12),
                Container(
                  width: 1,
                  height: 14,
                  color: AppColors.divider,
                ),
                const SizedBox(width: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.flag_outlined,
                      size: 14,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '목표 $deadline',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),

          const SizedBox(height: 16),

          // 서브 목표별 진행률
          _SubGoalProgressSection(goals: goals),
        ],
      ),
    );
  }
}

/// 서브 목표별 진행률 섹션
class _SubGoalProgressSection extends StatelessWidget {
  const _SubGoalProgressSection({required this.goals});

  final List<Goal> goals;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // 상단 2개 (좌상단, 우상단)
          Row(
            children: [
              Expanded(
                child: _SubGoalProgressItem(
                  label: goals.subGoalText(6) ?? '세부 목표',
                  doneCount: goals.subGoalDoneCount(6),
                  progress: goals.subGoalProgress(6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SubGoalProgressItem(
                  label: goals.subGoalText(8) ?? '세부 목표',
                  doneCount: goals.subGoalDoneCount(8),
                  progress: goals.subGoalProgress(8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 하단 2개 (좌하단, 우하단)
          Row(
            children: [
              Expanded(
                child: _SubGoalProgressItem(
                  label: goals.subGoalText(16) ?? '세부 목표',
                  doneCount: goals.subGoalDoneCount(16),
                  progress: goals.subGoalProgress(16),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SubGoalProgressItem(
                  label: goals.subGoalText(18) ?? '세부 목표',
                  doneCount: goals.subGoalDoneCount(18),
                  progress: goals.subGoalProgress(18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 개별 서브 목표 진행률 아이템
class _SubGoalProgressItem extends StatelessWidget {
  const _SubGoalProgressItem({
    required this.label,
    required this.doneCount,
    required this.progress,
  });

  final String label;
  final int doneCount;
  final double progress;

  Color get _progressColor {
    if (progress >= 1.0) return const Color(0xFFD4A574); // 골드/머스타드
    if (progress >= 0.6) return const Color(0xFF8DB4A0); // 틸
    if (progress > 0) return const Color(0xFF7A9E77); // 세이지
    return AppColors.textTertiary;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 라벨 + 개수
        Row(
          children: [
            Expanded(
              child: Text(
                label.isEmpty ? '세부 목표' : label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: progress >= 1.0
                      ? _progressColor
                      : AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '$doneCount/5',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _progressColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // 미니 프로그레스 바
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.progressTrack,
            borderRadius: BorderRadius.circular(2),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                    decoration: BoxDecoration(
                      color: _progressColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

/// 25칸 그라데이션 프로그레스 바
class _GradientProgressBar extends StatelessWidget {
  const _GradientProgressBar({
    required this.completed,
    required this.total,
    required this.ratio,
  });

  final int completed;
  final int total;
  final double ratio;

  /// 달성률에 따른 그라데이션 색상 (따뜻한 톤)
  List<Color> get _gradientColors {
    if (ratio >= 1.0) {
      // 100% 완료 - 골드/머스타드 그라데이션
      return [
        const Color(0xFFD4A574),
        const Color(0xFFC49565),
        const Color(0xFFB8956A),
      ];
    } else if (ratio >= 0.75) {
      // 75%+ - 세이지 → 틸 → 머스타드
      return [
        const Color(0xFF7A9E77),
        const Color(0xFF8DB4A0),
        const Color(0xFFB8A88A),
        const Color(0xFFD4A574),
      ];
    } else if (ratio >= 0.5) {
      // 50%+ - 세이지 → 틸
      return [
        const Color(0xFF7A9E77),
        const Color(0xFF8DB4A0),
        const Color(0xFF9DBFB0),
      ];
    } else if (ratio >= 0.25) {
      // 25%+ - 세이지 그린
      return [
        const Color(0xFF7A9E77),
        const Color(0xFF8EAD8B),
      ];
    } else {
      // 기본 - 단색 세이지
      return [
        const Color(0xFF8EAD8B),
        const Color(0xFF7A9E77),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      height: 10,
      decoration: BoxDecoration(
        color: AppColors.progressTrack,
        borderRadius: BorderRadius.circular(5),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // 채워진 부분 (그라데이션)
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                width: constraints.maxWidth * ratio,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _gradientColors,
                  ),
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: ratio > 0
                      ? [
                          BoxShadow(
                            color: _gradientColors.first.withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
              ),
              // 25칸 구분선 (미묘한 세그먼트)
              Row(
                children: List.generate(total, (index) {
                  final isLast = index == total - 1;
                  return Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: isLast
                            ? null
                            : Border(
                                right: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  width: 1,
                                ),
                              ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// 진행률 배지
class _ProgressBadge extends StatelessWidget {
  const _ProgressBadge({
    required this.completed,
    required this.total,
    required this.ratio,
  });

  final int completed;
  final int total;
  final double ratio;

  Color get _badgeColor {
    if (ratio >= 1.0) return const Color(0xFFFFD700);
    if (ratio >= 0.75) return const Color(0xFFA78BFA);
    if (ratio >= 0.5) return const Color(0xFF60A5FA);
    if (ratio >= 0.25) return const Color(0xFF2DD4BF);
    if (ratio > 0) return AppColors.statusDoneCheck;
    return AppColors.textTertiary;
  }

  @override
  Widget build(BuildContext context) {
    final percent = (ratio * 100).round();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _badgeColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _badgeColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$completed/$total',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _badgeColor,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 1,
            height: 12,
            color: _badgeColor.withValues(alpha: 0.3),
          ),
          const SizedBox(width: 6),
          Text(
            '$percent%',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _badgeColor,
            ),
          ),
          if (ratio >= 1.0) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.celebration,
              size: 14,
              color: _badgeColor,
            ),
          ],
        ],
      ),
    );
  }
}
