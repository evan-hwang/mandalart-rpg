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
    final progressPercent = goals.progressPercent;
    final progressRatio = goals.progressRatio;

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

          // 달성률 + 기한
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '달성률 ($progressPercent%)',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              if (deadline != null && deadline!.isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  width: 1,
                  height: 12,
                  color: AppColors.divider,
                ),
                const SizedBox(width: 8),
                Text(
                  deadline!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 12),

          // 프로그레스 바
          _ProgressBar(progress: progressRatio),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      constraints: const BoxConstraints(maxWidth: 280),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(4),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                width: constraints.maxWidth * progress,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
