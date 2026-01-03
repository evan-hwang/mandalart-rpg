/// 5x5 만다라트 그리드 상수 및 유틸리티
library;

/// 그리드 크기
const int kGridSize = 5;
const int kTotalCells = kGridSize * kGridSize; // 25

/// 셀 역할
enum CellRole {
  main,   // 메인 목표 (중앙)
  sub,    // 서브 과제 (대각선 4개)
  detail, // 세부 과제 (나머지 20개)
}

/// 영역 식별자 (4개 서브 영역)
enum AreaId {
  topLeft,     // 좌상단 (서브1 - idx 6)
  topRight,    // 우상단 (서브2 - idx 8)
  bottomLeft,  // 좌하단 (서브3 - idx 16)
  bottomRight, // 우하단 (서브4 - idx 18)
}

/// 특수 셀 인덱스
const int kMainIndex = 12; // (2,2) 중앙
const List<int> kSubIndices = [6, 8, 16, 18]; // 대각선 위치

/// 서브 과제별 세부 과제 매핑
const Map<int, List<int>> kSubGoalDetailMapping = {
  6:  [0, 1, 2, 5, 7],      // 좌상단
  8:  [3, 4, 9, 13, 14],    // 우상단
  16: [10, 11, 15, 20, 21], // 좌하단
  18: [17, 19, 22, 23, 24], // 우하단
};

/// 서브 인덱스 → 영역 ID 매핑
const Map<int, AreaId> kSubIndexToArea = {
  6:  AreaId.topLeft,
  8:  AreaId.topRight,
  16: AreaId.bottomLeft,
  18: AreaId.bottomRight,
};

/// 영역 ID → 서브 인덱스 매핑
const Map<AreaId, int> kAreaToSubIndex = {
  AreaId.topLeft:     6,
  AreaId.topRight:    8,
  AreaId.bottomLeft:  16,
  AreaId.bottomRight: 18,
};

/// 영역별 모든 셀 인덱스 (서브 + 세부)
const Map<AreaId, List<int>> kAreaCells = {
  AreaId.topLeft:     [0, 1, 2, 5, 6, 7],
  AreaId.topRight:    [3, 4, 8, 9, 13, 14],
  AreaId.bottomLeft:  [10, 11, 15, 16, 20, 21],
  AreaId.bottomRight: [17, 18, 19, 22, 23, 24],
};

/// 인덱스로 셀 역할 계산
CellRole roleForIndex(int index) {
  if (index == kMainIndex) return CellRole.main;
  if (kSubIndices.contains(index)) return CellRole.sub;
  return CellRole.detail;
}

/// 인덱스로 영역 ID 계산 (메인은 null)
AreaId? getAreaForIndex(int index) {
  if (index == kMainIndex) return null;
  for (final entry in kAreaCells.entries) {
    if (entry.value.contains(index)) {
      return entry.key;
    }
  }
  return null;
}

/// 세부 과제가 속한 서브 과제 인덱스 찾기
int? getParentSubIndex(int detailIndex) {
  for (final entry in kSubGoalDetailMapping.entries) {
    if (entry.value.contains(detailIndex)) {
      return entry.key;
    }
  }
  return null;
}

/// 인덱스로 행/열 계산
({int row, int col}) indexToPosition(int index) {
  return (row: index ~/ kGridSize, col: index % kGridSize);
}

/// 행/열로 인덱스 계산
int positionToIndex(int row, int col) {
  return row * kGridSize + col;
}
