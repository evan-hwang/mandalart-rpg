class Mandalart {
  const Mandalart({
    required this.id,
    required this.title,
    this.emoji,
    required this.dateRangeLabel,
    this.isPinned = false,
  });

  final String id;
  final String title;
  final String? emoji;
  final String dateRangeLabel;
  final bool isPinned;

  Mandalart copyWith({
    String? id,
    String? title,
    String? emoji,
    String? dateRangeLabel,
    bool? isPinned,
  }) {
    return Mandalart(
      id: id ?? this.id,
      title: title ?? this.title,
      emoji: emoji ?? this.emoji,
      dateRangeLabel: dateRangeLabel ?? this.dateRangeLabel,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}
