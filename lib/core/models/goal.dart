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
  /// 인덱스로 Goal 찾기
  Goal? goalAt(int index) {
    try {
      return firstWhere((g) => g.gridIndex == index);
    } catch (_) {
      return null;
    }
  }

  /// 특정 영역의 세부 과제들이 모두 완료되었는지
  bool isAreaDetailsDone(AreaId area) {
    final detailIndices = kSubGoalDetailMapping[kAreaToSubIndex[area]!]!;
    for (final idx in detailIndices) {
      final goal = goalAt(idx);
      if (goal == null || !goal.isDone) return false;
    }
    return true;
  }

  /// 특정 서브 과제가 완료되었는지 (세부 5개 모두 완료)
  bool isSubGoalComplete(int subIndex) {
    final detailIndices = kSubGoalDetailMapping[subIndex];
    if (detailIndices == null) return false;
    for (final idx in detailIndices) {
      final goal = goalAt(idx);
      if (goal == null || !goal.isDone) return false;
    }
    return true;
  }

  /// 서브별 완료된 세부 과제 개수 (0~5)
  int subGoalDoneCount(int subIndex) {
    final detailIndices = kSubGoalDetailMapping[subIndex];
    if (detailIndices == null) return 0;
    int count = 0;
    for (final idx in detailIndices) {
      final goal = goalAt(idx);
      if (goal != null && goal.isDone) count++;
    }
    return count;
  }

  /// 서브별 진행률 (0.0 ~ 1.0)
  double subGoalProgress(int subIndex) {
    return subGoalDoneCount(subIndex) / 5;
  }

  /// 서브 목표 이름 가져오기
  String? subGoalText(int subIndex) {
    return goalAt(subIndex)?.text;
  }

  /// 모든 서브 과제가 완료되었는지
  bool get allSubGoalsComplete {
    for (final subIndex in kSubIndices) {
      if (!isSubGoalComplete(subIndex)) return false;
    }
    return true;
  }

  /// 완료된 세부 과제 개수
  int get completedDetailCount {
    return where((g) => g.role == CellRole.detail && g.isDone).length;
  }

  /// 완료된 서브 과제 개수
  int get completedSubCount {
    int count = 0;
    for (final subIndex in kSubIndices) {
      if (isSubGoalComplete(subIndex)) count++;
    }
    return count;
  }

  /// 메인 완료 여부
  bool get isMainComplete => allSubGoalsComplete;

  /// 전체 완료 개수 (25개 기준: 20 detail + 4 sub + 1 main)
  int get totalCompletedCount {
    int count = completedDetailCount;
    count += completedSubCount;
    if (isMainComplete) count++;
    return count;
  }

  /// 전체 개수 (항상 25)
  int get totalCount => 25;

  /// 달성률 (0.0 ~ 1.0) - 25개 기준
  double get progressRatio {
    return totalCompletedCount / totalCount;
  }

  /// 달성률 퍼센트 (0 ~ 100)
  int get progressPercent => (progressRatio * 100).round();

  /// 완료된 개수 (alias for UI) - 25개 기준
  int get doneCount => totalCompletedCount;
}
