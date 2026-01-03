import 'package:mandalart/core/constants/grid_constants.dart';

/// 목표 상태
enum GoalStatus {
  todo(0),
  doing(1),
  done(2);

  const GoalStatus(this.value);
  final int value;

  static GoalStatus fromValue(int value) {
    return GoalStatus.values.firstWhere(
      (s) => s.value == value,
      orElse: () => GoalStatus.todo,
    );
  }

  String get label {
    return switch (this) {
      GoalStatus.todo => '할 일',
      GoalStatus.doing => '진행 중',
      GoalStatus.done => '완료',
    };
  }

  GoalStatus get next {
    final nextIndex = (index + 1) % GoalStatus.values.length;
    return GoalStatus.values[nextIndex];
  }
}

/// 목표 데이터 모델
class Goal {
  const Goal({
    required this.mandalartId,
    required this.gridIndex,
    this.text = '',
    this.status = GoalStatus.todo,
    this.memo = '',
  });

  final String mandalartId;
  final int gridIndex;
  final String text;
  final GoalStatus status;
  final String memo;

  /// 셀 역할
  CellRole get role => roleForIndex(gridIndex);

  /// 빈 목표인지 확인
  bool get isEmpty => text.isEmpty;

  /// 완료 여부
  bool get isDone => status == GoalStatus.done;

  /// 복사본 생성
  Goal copyWith({
    String? mandalartId,
    int? gridIndex,
    String? text,
    GoalStatus? status,
    String? memo,
  }) {
    return Goal(
      mandalartId: mandalartId ?? this.mandalartId,
      gridIndex: gridIndex ?? this.gridIndex,
      text: text ?? this.text,
      status: status ?? this.status,
      memo: memo ?? this.memo,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Goal &&
        other.mandalartId == mandalartId &&
        other.gridIndex == gridIndex &&
        other.text == text &&
        other.status == status &&
        other.memo == memo;
  }

  @override
  int get hashCode {
    return Object.hash(mandalartId, gridIndex, text, status, memo);
  }
}

/// 달성률 계산 확장
extension GoalListExtension on List<Goal> {
  /// 세부 과제 중 완료된 개수
  int get completedDetailCount {
    return where((g) => g.role == CellRole.detail && g.isDone).length;
  }

  /// 전체 세부 과제 개수 (항상 20)
  int get totalDetailCount => 20;

  /// 달성률 (0.0 ~ 1.0)
  double get progressRatio {
    if (totalDetailCount == 0) return 0;
    return completedDetailCount / totalDetailCount;
  }

  /// 달성률 퍼센트 (0 ~ 100)
  int get progressPercent => (progressRatio * 100).round();
}
