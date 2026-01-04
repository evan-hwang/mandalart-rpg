import 'package:flutter/material.dart';
import 'package:mandalart/core/constants/app_colors.dart';

/// 앱 테마 설정
abstract final class AppTheme {
  static const String _fontFamily = 'Pretendard';

  /// 모바일 최적화 텍스트 테마
  static TextTheme get _textTheme => const TextTheme(
    // 제목
    displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, height: 1.3),
    displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, height: 1.3),
    displaySmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.3),
    headlineLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.4),
    headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.4),
    headlineSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.4),
    // 본문
    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, height: 1.4),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.4),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 1.4),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.5),
    // 라벨
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 1.3),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, height: 1.3),
    labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, height: 1.3),
  );

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: _fontFamily,
    textTheme: _textTheme,

    // 컬러 스킴
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.textPrimary,
      secondary: AppColors.primaryDark,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.error,
    ),

    // 배경
    scaffoldBackgroundColor: AppColors.background,

    // 앱바
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: _fontFamily,
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    // 카드
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.divider),
      ),
    ),

    // 버튼
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // FAB
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textPrimary,
      elevation: 2,
    ),

    // 입력 필드
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),

    // 바텀시트
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),

    // 다이얼로그
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),

    // 프로그레스 인디케이터
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.surfaceVariant,
    ),

    // 디바이더
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),
  );

  static ThemeData get dark => light.copyWith(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      surface: const Color(0xFF1E293B),
      onSurface: Colors.white,
    ),
    textTheme: _textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
  );
}
