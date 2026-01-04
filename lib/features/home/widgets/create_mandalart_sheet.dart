import 'package:flutter/material.dart';
import 'package:mandalart/core/constants/app_colors.dart';
import 'package:mandalart/core/data/mandalart_templates.dart';
import 'package:mandalart/features/home/widgets/emoji_picker_dialog.dart';
import 'package:mandalart/features/mandalart/mandalart.dart';

/// 만다라트 생성 결과 (Mandalart + 선택된 템플릿)
class CreateMandalartResult {
  final Mandalart mandalart;
  final MandalartTemplate? template;

  CreateMandalartResult({required this.mandalart, this.template});
}

/// 만다라트 생성/수정 바텀시트
class CreateMandalartSheet extends StatefulWidget {
  const CreateMandalartSheet({
    super.key,
    this.existing,
    this.template,
  });

  final Mandalart? existing;
  final MandalartTemplate? template;

  static Future<CreateMandalartResult?> show(
    BuildContext context, {
    Mandalart? existing,
    MandalartTemplate? template,
  }) {
    return showModalBottomSheet<CreateMandalartResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateMandalartSheet(existing: existing, template: template),
    );
  }

  @override
  State<CreateMandalartSheet> createState() => _CreateMandalartSheetState();
}

class _CreateMandalartSheetState extends State<CreateMandalartSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _deadlineController;
  DateTime? _selectedDate;
  String? _selectedEmoji;

  bool get _isEditing => widget.existing != null;
  bool get _hasTemplate => widget.template != null;

  @override
  void initState() {
    super.initState();
    // 기존 만다라트 > 템플릿 > 빈 값 순으로 초기값 설정
    _titleController = TextEditingController(
      text: widget.existing?.title ?? widget.template?.title ?? '',
    );
    _deadlineController = TextEditingController(
      text: widget.existing?.dateRangeLabel ?? '',
    );
    _selectedEmoji = widget.existing?.emoji ?? widget.template?.emoji;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
        _deadlineController.text =
            '${date.year}년 ${date.month}월 ${date.day}일';
      });
    }
  }

  Future<void> _pickEmoji() async {
    final emoji = await EmojiPickerDialog.show(
      context,
      selectedEmoji: _selectedEmoji,
    );
    if (emoji != null) {
      setState(() {
        _selectedEmoji = emoji.isEmpty ? null : emoji;
      });
    }
  }

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목을 입력해주세요')),
      );
      return;
    }

    final deadline = _deadlineController.text.trim();
    final mandalart = Mandalart(
      id: widget.existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      emoji: _selectedEmoji,
      dateRangeLabel: deadline.isEmpty ? '기간 없음' : deadline,
    );

    Navigator.pop(
      context,
      CreateMandalartResult(
        mandalart: mandalart,
        template: widget.template,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 드래그 핸들
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
              const SizedBox(height: 20),

              // 제목
              Text(
                _isEditing ? '한다라트 수정' : '새 한다라트 만들기',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _hasTemplate
                    ? '템플릿 "${widget.template!.title}"이 적용됩니다'
                    : '목표를 설정하고 25칸에 담아보세요',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // 이모지 선택
              Center(
                child: GestureDetector(
                  onTap: _pickEmoji,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.divider,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: _selectedEmoji != null
                          ? Text(
                              _selectedEmoji!,
                              style: const TextStyle(fontSize: 36),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_reaction_outlined,
                                  size: 28,
                                  color: AppColors.textTertiary,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '이모지',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 제목 입력
              TextField(
                controller: _titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: '한다라트 제목',
                  hintText: '예: 2025년 목표, 발전하는 나',
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // 기간 입력
              TextField(
                controller: _deadlineController,
                readOnly: true,
                onTap: _pickDate,
                decoration: const InputDecoration(
                  labelText: '목표 기간 (선택)',
                  hintText: '날짜를 선택하세요',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 24),

              // 버튼
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('취소'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: _save,
                      child: Text(_isEditing ? '저장' : '만들기'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
