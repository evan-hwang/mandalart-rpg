import 'package:flutter/material.dart';

/// 앱 컬러 팔레트 - 눈이 편한 따뜻한 톤
abstract final class AppColors {
  // 브랜드 컬러 (따뜻한 골드/머스타드)
  static const Color primary = Color(0xFFD4A574);      // 머스타드 골드
  static const Color primaryDark = Color(0xFFB8956A);  // 진한 골드

  // 배경 (따뜻한 크림 톤)
  static const Color background = Color(0xFFFAFAF8);   // 크림 배경
  static const Color surface = Color(0xFFFFFEFB);      // 오프화이트
  static const Color surfaceVariant = Color(0xFFF5F3EF); // 따뜻한 회색

  // 영역 배경 (소프트 베이지)
  static const Color areaNormal = Color(0xFFF0EDE8);   // 기본 영역 배경
  static const Color areaComplete = Color(0xFFD4E4D1); // 완료 영역 배경

  // 메인 목표 셀 (딥 네이비)
  static const Color mainCell = Color(0xFF2D3A4F);     // 딥 네이비
  static const Color mainCellText = Color(0xFFFFFEFB); // 오프화이트

  // 서브 과제 셀 (머스타드 골드)
  static const Color subCell = Color(0xFFD4A574);      // 머스타드 골드
  static const Color subCellText = Color(0xFF3D3229);  // 다크 브라운

  // 세부 과제 셀
  static const Color detailCell = Color(0xFFFFFEFB);   // 오프화이트
  static const Color detailCellBorder = Color(0xFFE5E0D8); // 따뜻한 테두리
  static const Color detailCellText = Color(0xFF4A4540); // 다크 그레이

  // 상태 컬러 (채도 낮춤)
  static const Color statusTodo = Color(0xFFFFFEFB);   // 기본 (오프화이트)
  static const Color statusDoing = Color(0xFFF5E1D0);  // 진행 중 (소프트 피치)
  static const Color statusDone = Color(0xFFD5E3D1);   // 완료 (소프트 세이지)
  static const Color statusDoneBorder = Color(0xFF9DB89A); // 완료 테두리 (머티드 그린)
  static const Color statusDoneCheck = Color(0xFF7A9E77); // 체크마크 (세이지 그린)

  // 프로그레스 바
  static const Color progressTrack = Color(0xFFE5E0D8);  // 빈 공간
  static const Color progressFill = Color(0xFF7A9E77);   // 채워진 부분 (세이지)

  // 텍스트
  static const Color textPrimary = Color(0xFF2D2A26);    // 다크 브라운
  static const Color textSecondary = Color(0xFF6B6560);  // 미디엄 브라운
  static const Color textTertiary = Color(0xFF9C9590);   // 라이트 브라운

  // 기타
  static const Color divider = Color(0xFFE5E0D8);
  static const Color error = Color(0xFFD97373);          // 소프트 레드
  static const Color success = Color(0xFF7A9E77);        // 세이지 그린
}
