import 'package:flutter/material.dart';

/// 앱 전체에서 사용하는 색상 정의
abstract class AppColors {
  static Color op(Color color, double alpha) =>
      color.withValues(alpha: alpha.clamp(0.0, 1.0));

  // Primary Colors (보라색 계열)
  static const Color primary = Color(0xFFB8A3E6); // 라벤더 보라색
  static const Color primaryLight = Color(0xFFD4C5F0);
  static const Color primaryDark = Color(0xFF9681D3);

  // Background Colors
  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF3F4F6);

  // Text Colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);

  // Accent Colors
  static const Color accent = Color(0xFFEC4899); // 핑크 (생일 강조용)
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // Calendar Specific
  static const Color calendarToday = primary;
  static const Color calendarSelected = primary;
  static const Color calendarWeekend = Color(0xFFEF4444);
  static const Color calendarDisabled = Color(0xFFD1D5DB);
  static const Color calendarEvent = accent;

  // Border Colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF3F4F6);
}