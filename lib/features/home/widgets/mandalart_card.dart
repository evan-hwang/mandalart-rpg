import 'package:flutter/material.dart';
import 'package:mandalart/core/constants/app_colors.dart';
import 'package:mandalart/features/mandalart/mandalart.dart';

/// 홈 화면 만다라트 카드 위젯
class MandalartCard extends StatelessWidget {
  const MandalartCard({
    super.key,
    required this.mandalart,
    required this.progressPercent,
    required this.onTap,
    required this.onLongPress,
    required this.onPinTap,
  });

  final Mandalart mandalart;
  final int progressPercent;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onPinTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            // 이모지 또는 아이콘
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: mandalart.emoji != null && mandalart.emoji!.isNotEmpty
                    ? Text(
                        mandalart.emoji!,
                        style: const TextStyle(fontSize: 24),
                      )
                    : const Icon(
                        Icons.flag_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
              ),
            ),

            const SizedBox(width: 14),

            // 제목 + 기간 + 프로그레스
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mandalart.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '$progressPercent% 달성',
                        style: TextStyle(
                          fontSize: 13,
                          color: progressPercent > 0
                              ? AppColors.primaryDark
                              : AppColors.textTertiary,
                          fontWeight: progressPercent > 0
                              ? FontWeight.w500
                              : FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '·',
                        style: TextStyle(
                          color: AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.flag_outlined,
                        size: 13,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          '목표 ${mandalart.dateRangeLabel}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // 프로그레스 바
                  _MiniProgressBar(progress: progressPercent / 100),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // 고정핀 버튼
            GestureDetector(
              onTap: onPinTap,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  mandalart.isPinned
                      ? Icons.push_pin
                      : Icons.push_pin_outlined,
                  color: mandalart.isPinned
                      ? AppColors.primary
                      : AppColors.textTertiary,
                  size: 20,
                ),
              ),
            ),

            const SizedBox(width: 4),

            // 화살표
            const Icon(
              Icons.chevron_right,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniProgressBar extends StatelessWidget {
  const _MiniProgressBar({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(3),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
