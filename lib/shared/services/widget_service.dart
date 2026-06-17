import 'dart:convert';
import 'dart:io';

import 'package:home_widget/home_widget.dart';
import 'package:rememberotter/domain/models/birthday.dart';
import 'package:rememberotter/shared/log/logger.dart';
import 'package:rememberotter/shared/services/analytics_service.dart';
import 'package:rememberotter/shared/services/error_reporting_service.dart';

class WidgetService {
  static final WidgetService _instance = WidgetService._internal();
  factory WidgetService() => _instance;
  WidgetService._internal();

  static const String _appGroupId = 'group.com.rudqlsdla.rememberotter';
  static const String _iOSWidgetName = 'BirthdayWidget';
  static const String _androidWidgetProvider =
      'com.rudqlsdla.rememberotter.widget.BirthdayWidgetProvider';

  Future<void> initialize() async {
    if (Platform.isIOS) {
      await HomeWidget.setAppGroupId(_appGroupId);
    }
    logger.i('WidgetService 초기화 완료');
  }

  /// 위젯 데이터 업데이트 (D-day 순 정렬된 생일 목록을 받아 상위 3개 저장)
  Future<void> updateWidgetData(List<Birthday> birthdays) async {
    try {
      final sorted = List<Birthday>.from(birthdays)
        ..sort((a, b) => a.daysUntilBirthday.compareTo(b.daysUntilBirthday));

      final top3 = sorted.take(3).toList();

      final jsonList = top3.map((b) {
        final solar = b.nextSolarBirthday;
        return {
          'name': b.name,
          'daysUntil': b.daysUntilBirthday,
          'month': solar.month,
          'day': solar.day,
          'ageText': b.ageText ?? '',
        };
      }).toList();

      final jsonString = jsonEncode(jsonList);

      await HomeWidget.saveWidgetData<String>(
        'upcoming_birthdays',
        jsonString,
      );

      if (Platform.isIOS) {
        await HomeWidget.updateWidget(iOSName: _iOSWidgetName);
      } else if (Platform.isAndroid) {
        await HomeWidget.updateWidget(
            qualifiedAndroidName: _androidWidgetProvider);
      }

      logger.d('위젯 데이터 업데이트 완료: ${top3.length}개');
      AnalyticsService().logWidgetUpdate(count: top3.length);
    } catch (e, stack) {
      logger.e('위젯 데이터 업데이트 실패: $e');
      ErrorReportingService().reportError(e, stack);
    }
  }
}
