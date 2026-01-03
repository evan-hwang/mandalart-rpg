import 'package:flutter/material.dart';

/// 앱 컬러 팔레트 (이미지 참고)
abstract final class AppColors {
  // 브랜드 컬러
  static const Color primary = Color(0xFF4ADE80);      // 초록색 (서브 과제)
  static const Color primaryDark = Color(0xFF22C55E);  // 진한 초록

  // 배경
  static const Color background = Color(0xFFF8FAFC);   // 연한 회색 배경
  static const Color surface = Color(0xFFFFFFFF);      // 흰색 표면
  static const Color surfaceVariant = Color(0xFFF1F5F9); // 연한 회색 표면

  // 메인 목표 셀
  static const Color mainCell = Color(0xFF1E293B);     // 진한 남색
  static const Color mainCellText = Color(0xFFFFFFFF); // 흰색

  // 서브 과제 셀
  static const Color subCell = Color(0xFF4ADE80);      // 초록색
  static const Color subCellText = Color(0xFF0F172A);  // 검정

  // 세부 과제 셀
  static const Color detailCell = Color(0xFFFFFFFF);   // 흰색
  static const Color detailCellBorder = Color(0xFFE2E8F0); // 테두리
  static const Color detailCellText = Color(0xFF334155); // 진한 회색

  // 상태 컬러
  static const Color statusTodo = Color(0xFFFFFFFF);   // 기본 (흰색)
  static const Color statusDoing = Color(0xFFFEF3C7); // 진행 중 (노란색)
  static const Color statusDone = Color(0xFFDCFCE7);  // 완료 (연초록)
  static const Color statusDoneCheck = Color(0xFF22C55E); // 체크마크

  // 텍스트
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);

  // 기타
  static const Color divider = Color(0xFFE2E8F0);
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF22C55E);
}
