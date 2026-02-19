import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 앱 설정 관리 서비스
class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  static const String _keyNotificationDaysBefore = 'notificationDaysBefore';
  static const String _keyNotificationHour = 'notificationHour';
  static const String _keyNotificationMinute = 'notificationMinute';
  static const String _keyUseInternationalAge = 'useInternationalAge';

  late SharedPreferences _prefs;

  /// SharedPreferences 초기화 (main에서 호출)
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// 기본 알림 일수 (기본값: 1일 전)
  int get notificationDaysBefore {
    return _prefs.getInt(_keyNotificationDaysBefore) ?? 1;
  }

  set notificationDaysBefore(int days) {
    _prefs.setInt(_keyNotificationDaysBefore, days);
  }

  /// 알림 시간 (기본값: 오전 9시)
  int get notificationHour {
    return _prefs.getInt(_keyNotificationHour) ?? 9;
  }

  set notificationHour(int hour) {
    _prefs.setInt(_keyNotificationHour, hour);
  }

  int get notificationMinute {
    return _prefs.getInt(_keyNotificationMinute) ?? 0;
  }

  set notificationMinute(int minute) {
    _prefs.setInt(_keyNotificationMinute, minute);
  }

  TimeOfDay get notificationTime {
    return TimeOfDay(hour: notificationHour, minute: notificationMinute);
  }

  set notificationTime(TimeOfDay time) {
    notificationHour = time.hour;
    notificationMinute = time.minute;
  }

  /// 알림 시간 라벨
  String get notificationTimeLabel {
    final hour = notificationHour;
    final minute = notificationMinute;
    final period = hour < 12 ? '오전' : '오후';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final displayMinute = minute.toString().padLeft(2, '0');
    return '$period $displayHour:$displayMinute';
  }

  /// 만나이 사용 여부 (기본값: true)
  bool get useInternationalAge {
    return _prefs.getBool(_keyUseInternationalAge) ?? true;
  }

  set useInternationalAge(bool value) {
    _prefs.setBool(_keyUseInternationalAge, value);
  }

  /// 알림 일수 옵션 목록
  static const List<int> notificationDaysOptions = [0, 1, 3, 7];

  /// 알림 일수 라벨
  static String getNotificationDaysLabel(int days) {
    switch (days) {
      case 0:
        return '당일';
      case 1:
        return '1일 전';
      case 3:
        return '3일 전';
      case 7:
        return '7일 전';
      default:
        return '$days일 전';
    }
  }
}
