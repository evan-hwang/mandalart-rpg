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

/// 특수 셀 인덱스
const int kMainIndex = 12; // (2,2) 중앙
const List<int> kSubIndices = [6, 8, 16, 18]; // 대각선 위치

/// 서브 과제별 세부 과제 매핑
const Map<int, List<int>> kSubGoalDetailMapping = {
  6:  [0, 1, 2, 5, 7],      // 좌상단 (건강)
  8:  [3, 4, 9, 13, 14],    // 우상단 (성장)
  16: [10, 11, 15, 20, 21], // 좌하단 (재테크)
  18: [17, 19, 22, 23, 24], // 우하단 (취미)
};

/// 인덱스로 셀 역할 계산
CellRole roleForIndex(int index) {
  if (index == kMainIndex) return CellRole.main;
  if (kSubIndices.contains(index)) return CellRole.sub;
  return CellRole.detail;
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
