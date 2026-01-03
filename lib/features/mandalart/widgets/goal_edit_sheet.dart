import 'package:flutter/material.dart';
import 'package:mandalart/core/constants/app_colors.dart';
import 'package:mandalart/core/constants/grid_constants.dart';
import 'package:mandalart/core/models/goal.dart';

/// 목표 편집 바텀시트
class GoalEditSheet extends StatefulWidget {
  const GoalEditSheet({
    super.key,
    required this.goal,
  });

  final Goal goal;

  static Future<Goal?> show(BuildContext context, Goal goal) {
    return showModalBottomSheet<Goal>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => GoalEditSheet(goal: goal),
    );
  }

  @override
  State<GoalEditSheet> createState() => _GoalEditSheetState();
}

class _GoalEditSheetState extends State<GoalEditSheet> {
  late final TextEditingController _textController;
  late final TextEditingController _memoController;
  late GoalStatus _status;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.goal.text);
    _memoController = TextEditingController(text: widget.goal.memo);
    _status = widget.goal.status;
  }

  @override
  void dispose() {
    _textController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  void _save() {
    final updatedGoal = widget.goal.copyWith(
      text: _textController.text.trim(),
      status: _status,
      memo: _memoController.text.trim(),
    );
    Navigator.pop(context, updatedGoal);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final role = widget.goal.role;

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
                _sheetTitle(role),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),

              // 목표 입력
              TextField(
                controller: _textController,
                autofocus: widget.goal.text.isEmpty,
                decoration: InputDecoration(
                  labelText: '목표',
                  hintText: _hintText(role),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // 상태 선택
              _StatusSelector(
                value: _status,
                onChanged: (status) => setState(() => _status = status),
              ),
              const SizedBox(height: 16),

              // 메모 입력
              TextField(
                controller: _memoController,
                decoration: const InputDecoration(
                  labelText: '메모 (선택)',
                  hintText: '회고나 메모를 작성해보세요',
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
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
                      child: const Text('저장'),
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

  String _sheetTitle(CellRole role) {
    return switch (role) {
      CellRole.main => '메인 목표 편집',
      CellRole.sub => '서브 과제 편집',
      CellRole.detail => '세부 과제 편집',
    };
  }

  String _hintText(CellRole role) {
    return switch (role) {
      CellRole.main => '예: 발전하는 나',
      CellRole.sub => '예: 건강, 성장, 재테크',
      CellRole.detail => '예: 헬스장 주 3회 가기',
    };
  }
}

/// 상태 선택 위젯
class _StatusSelector extends StatelessWidget {
  const _StatusSelector({
    required this.value,
    required this.onChanged,
  });

  final GoalStatus value;
  final ValueChanged<GoalStatus> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '상태',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: GoalStatus.values.map((status) {
            final isSelected = status == value;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: status != GoalStatus.done ? 8 : 0,
                ),
                child: _StatusChip(
                  status: status,
                  isSelected: isSelected,
                  onTap: () => onChanged(status),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.status,
    required this.isSelected,
    required this.onTap,
  });

  final GoalStatus status;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      GoalStatus.todo => AppColors.textTertiary,
      GoalStatus.doing => Colors.amber.shade600,
      GoalStatus.done => AppColors.statusDoneCheck,
    };

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            status.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? color : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
