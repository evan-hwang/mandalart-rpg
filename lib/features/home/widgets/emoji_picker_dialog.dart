import 'package:flutter/material.dart';
import 'package:mandalart/core/constants/app_colors.dart';

/// 이모지 선택 다이얼로그
class EmojiPickerDialog extends StatelessWidget {
  const EmojiPickerDialog({
    super.key,
    this.selectedEmoji,
  });

  final String? selectedEmoji;

  /// 목표 관련 이모지 목록
  static const List<String> goalEmojis = [
    // 성취/목표
    '🎯', '🏆', '⭐', '🌟', '💫', '✨', '🔥', '💪',
    // 성장/학습
    '📚', '📖', '✏️', '🎓', '💡', '🧠', '📝', '💼',
    // 건강/운동
    '🏃', '🚴', '🏋️', '🧘', '💪', '🥗', '🍎', '❤️',
    // 재테크/돈
    '💰', '💵', '📈', '🏦', '💎', '🪙', '📊', '💳',
    // 취미/즐거움
    '🎨', '🎵', '🎸', '📷', '🎮', '🎬', '🎭', '✈️',
    // 관계/소통
    '🤝', '💬', '👥', '❤️', '🫂', '👨‍👩‍👧‍👦', '🌈', '🌻',
    // 자연/명상
    '🌱', '🌿', '🌳', '🌸', '🌺', '🌞', '🌙', '⛰️',
    // 시간/계획
    '⏰', '📅', '🗓️', '⌛', '🎉', '🚀', '🛤️', '🏁',
  ];

  static Future<String?> show(BuildContext context, {String? selectedEmoji}) {
    return showDialog<String>(
      context: context,
      builder: (_) => EmojiPickerDialog(selectedEmoji: selectedEmoji),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('이모지 선택'),
      backgroundColor: AppColors.surface,
      contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemCount: goalEmojis.length,
          itemBuilder: (context, index) {
            final emoji = goalEmojis[index];
            final isSelected = emoji == selectedEmoji;

            return GestureDetector(
              onTap: () => Navigator.pop(context, emoji),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected
                      ? Border.all(color: AppColors.primary, width: 2)
                      : null,
                ),
                child: Center(
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        if (selectedEmoji != null)
          TextButton(
            onPressed: () => Navigator.pop(context, ''),
            child: const Text('삭제'),
          ),
      ],
    );
  }
}
