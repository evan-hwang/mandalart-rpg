import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mandalart/core/constants/app_colors.dart';
import 'package:mandalart/core/constants/grid_constants.dart';
import 'package:mandalart/core/models/goal.dart';

/// 만다라트 그리드 셀 위젯
class MandalartCell extends StatefulWidget {
  const MandalartCell({
    super.key,
    required this.goal,
    required this.onTap,
    required this.onLongPress,
    this.isAreaComplete = false,
    this.isAllComplete = false,
  });

  final Goal goal;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool isAreaComplete; // 이 셀의 영역이 모두 완료됨
  final bool isAllComplete;  // 모든 영역이 완료됨 (메인 완료)

  @override
  State<MandalartCell> createState() => _MandalartCellState();
}

class _MandalartCellState extends State<MandalartCell>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    // 데이터 로딩 완료 후 초기화 (500ms 딜레이로 로딩 애니메이션 방지)
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _isInitialized = true;
      }
    });

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // 바운스 효과: 1.0 -> 1.15 -> 0.95 -> 1.0
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.15)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.15, end: 0.95)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.95, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 40,
      ),
    ]).animate(_animationController);
  }

  @override
  void didUpdateWidget(MandalartCell oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 초기화 완료 후에만 상태 변경 애니메이션 트리거
    // (화면 진입 시 데이터 로딩으로 인한 애니메이션 방지)
    if (_isInitialized && oldWidget.goal.status != widget.goal.status) {
      _triggerStatusAnimation(widget.goal.status);
    }
  }

  void _triggerStatusAnimation(GoalStatus newStatus) {
    // 완료 상태로 변경될 때 더 강한 애니메이션
    if (newStatus == GoalStatus.done) {
      _animationController.forward(from: 0);
    } else {
      // 다른 상태 변경 시 약한 애니메이션
      _animationController.forward(from: 0.3);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final role = widget.goal.role;

    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: () {
        HapticFeedback.mediumImpact();
        widget.onLongPress();
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              decoration: _buildDecoration(role),
              child: Stack(
                children: [
                  // 메인 콘텐츠
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        widget.goal.text.isEmpty
                            ? _placeholderText(role)
                            : widget.goal.text,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: _textStyle(role, widget.goal.text.isEmpty),
                      ),
                    ),
                  ),
                  // 메모 인디케이터 (우하단 점)
                  if (widget.goal.hasMemo)
                    Positioned(
                      right: 4,
                      bottom: 4,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  BoxDecoration _buildDecoration(CellRole role) {
    return switch (role) {
      CellRole.main => BoxDecoration(
          color: widget.isAllComplete ? const Color(0xFF1E2D3D) : AppColors.mainCell,
          borderRadius: BorderRadius.circular(12),
          border: widget.isAllComplete
              ? Border.all(color: const Color(0xFFD4A574), width: 2)
              : null,
          boxShadow: widget.isAllComplete
              ? [
                  BoxShadow(
                    color: const Color(0xFFD4A574).withValues(alpha: 0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
      CellRole.sub => BoxDecoration(
          color: widget.isAreaComplete
              ? const Color(0xFFB8956A) // 진한 머스타드
              : AppColors.subCell,
          borderRadius: BorderRadius.circular(10),
          boxShadow: widget.isAreaComplete
              ? [
                  BoxShadow(
                    color: AppColors.primaryDark.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
      CellRole.detail => BoxDecoration(
          color: _detailCellColor(),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _detailBorderColor(),
            width: widget.goal.isDone ? 2 : 1,
          ),
        ),
    };
  }

  Color _detailCellColor() {
    return switch (widget.goal.status) {
      GoalStatus.todo => AppColors.statusTodo,
      GoalStatus.done => AppColors.statusDone,
    };
  }

  Color _detailBorderColor() {
    return switch (widget.goal.status) {
      GoalStatus.todo => AppColors.detailCellBorder,
      GoalStatus.done => AppColors.statusDoneBorder,
    };
  }

  TextStyle _textStyle(CellRole role, bool isEmpty) {
    final baseStyle = switch (role) {
      CellRole.main => TextStyle(
          color: widget.isAllComplete ? const Color(0xFFD4A574) : AppColors.mainCellText,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
      CellRole.sub => TextStyle(
          color: widget.isAreaComplete ? const Color(0xFFFFFEFB) : AppColors.subCellText,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
      CellRole.detail => TextStyle(
          color: isEmpty ? AppColors.textTertiary : AppColors.detailCellText,
          fontSize: 10,
          fontWeight: FontWeight.w400,
          height: 1.3,
        ),
    };

    if (isEmpty && role != CellRole.main) {
      return baseStyle.copyWith(
        color: baseStyle.color?.withValues(alpha: 0.5),
      );
    }

    return baseStyle;
  }

  String _placeholderText(CellRole role) {
    return switch (role) {
      CellRole.main => '목표',
      CellRole.sub => '세부 목표',
      CellRole.detail => '계획',
    };
  }
}
