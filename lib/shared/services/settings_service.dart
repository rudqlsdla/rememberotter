import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

/// 앱 설정 관리 서비스
class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  static const String boxName = 'settings';
  static const String _keyNotificationDaysBefore = 'notificationDaysBefore';
  static const String _keyNotificationHour = 'notificationHour';
  static const String _keyNotificationMinute = 'notificationMinute';
  static const String _keyUseInternationalAge = 'useInternationalAge';

  Box get _box => Hive.box(boxName);

  /// Box 인스턴스 반환 (static 접근용)
  static Future<Box> getBox() async {
    return Hive.box(boxName);
  }

  /// 기본 알림 일수 (기본값: 1일 전)
  int get notificationDaysBefore {
    return _box.get(_keyNotificationDaysBefore, defaultValue: 1);
  }

  set notificationDaysBefore(int days) {
    _box.put(_keyNotificationDaysBefore, days);
  }

  /// 알림 시간 (기본값: 오전 9시)
  int get notificationHour {
    return _box.get(_keyNotificationHour, defaultValue: 9);
  }

  set notificationHour(int hour) {
    _box.put(_keyNotificationHour, hour);
  }

  int get notificationMinute {
    return _box.get(_keyNotificationMinute, defaultValue: 0);
  }

  set notificationMinute(int minute) {
    _box.put(_keyNotificationMinute, minute);
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
    return _box.get(_keyUseInternationalAge, defaultValue: true);
  }

  set useInternationalAge(bool value) {
    _box.put(_keyUseInternationalAge, value);
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
