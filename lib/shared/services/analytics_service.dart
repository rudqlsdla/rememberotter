import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:rememberotter/shared/log/logger.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // 검색 이벤트 debounce용
  Timer? _searchDebounce;

  // ── 온보딩 ──

  void logOnboardingNotification({required bool allowed}) {
    _analytics.logEvent(
      name: 'onboard_notification',
      parameters: {'allowed': allowed.toString()},
    );
    logger.d('[Analytics] onboard_notification: allowed=$allowed');
  }

  void logOnboardingContactImport({required bool skipped, int count = 0}) {
    _analytics.logEvent(
      name: 'onboard_contact_import',
      parameters: {
        'skipped': skipped.toString(),
        'count': count,
      },
    );
    logger.d('[Analytics] onboard_contact_import: skipped=$skipped, count=$count');
  }

  void logContactPermissionResult({required bool granted}) {
    _analytics.logEvent(
      name: 'contact_permission_result',
      parameters: {'granted': granted.toString()},
    );
    logger.d('[Analytics] contact_permission_result: granted=$granted');
  }

  // ── 생일 CRUD ──

  void logBirthdayFormOpen({required String mode}) {
    _analytics.logEvent(
      name: 'birthday_form_open',
      parameters: {'mode': mode},
    );
    logger.d('[Analytics] birthday_form_open: mode=$mode');
  }

  void logBirthdayAdd() {
    _analytics.logEvent(name: 'birthday_add');
    logger.d('[Analytics] birthday_add');
  }

  void logBirthdayBatchAdd({required int count}) {
    _analytics.logEvent(
      name: 'birthday_batch_add',
      parameters: {'count': count},
    );
    logger.d('[Analytics] birthday_batch_add: count=$count');
  }

  void logBirthdayUpdate() {
    _analytics.logEvent(name: 'birthday_update');
    logger.d('[Analytics] birthday_update');
  }

  void logBirthdayDelete() {
    _analytics.logEvent(name: 'birthday_delete');
    logger.d('[Analytics] birthday_delete');
  }

  void logBirthdaySearch({required int resultCount}) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      _analytics.logEvent(
        name: 'birthday_search',
        parameters: {'result_count': resultCount},
      );
      logger.d('[Analytics] birthday_search: result_count=$resultCount');
    });
  }

  void logBirthdayDetailView() {
    _analytics.logEvent(name: 'birthday_detail_view');
    logger.d('[Analytics] birthday_detail_view');
  }

  // ── 선물 CRUD ──

  void logGiftFormOpen({required String mode}) {
    _analytics.logEvent(
      name: 'gift_form_open',
      parameters: {'mode': mode},
    );
    logger.d('[Analytics] gift_form_open: mode=$mode');
  }

  void logGiftAdd() {
    _analytics.logEvent(name: 'gift_add');
    logger.d('[Analytics] gift_add');
  }

  void logGiftUpdate() {
    _analytics.logEvent(name: 'gift_update');
    logger.d('[Analytics] gift_update');
  }

  void logGiftDelete() {
    _analytics.logEvent(name: 'gift_delete');
    logger.d('[Analytics] gift_delete');
  }

  // ── 캘린더 / 네비게이션 ──

  void logCalendarDateSelect() {
    _analytics.logEvent(name: 'calendar_date_select');
    logger.d('[Analytics] calendar_date_select');
  }

  void logTabSwitch({required String tab}) {
    _analytics.logEvent(
      name: 'tab_switch',
      parameters: {'tab': tab},
    );
    logger.d('[Analytics] tab_switch: tab=$tab');
  }

  void logGiftStatsOpen() {
    _analytics.logEvent(name: 'gift_stats_open');
    logger.d('[Analytics] gift_stats_open');
  }

  // ── 설정 ──

  void logSettingsChange({required String setting, required String value}) {
    _analytics.logEvent(
      name: 'settings_change',
      parameters: {
        'setting': setting,
        'value': value,
      },
    );
    logger.d('[Analytics] settings_change: setting=$setting, value=$value');
  }

  // ── 피드백 ──

  void logFeedbackFormOpen() {
    _analytics.logEvent(name: 'feedback_form_open');
    logger.d('[Analytics] feedback_form_open');
  }

  void logFeedbackSend({required bool success}) {
    _analytics.logEvent(
      name: 'feedback_send',
      parameters: {'success': success.toString()},
    );
    logger.d('[Analytics] feedback_send: success=$success');
  }

  // ── 알림 ──

  void logNotificationTap() {
    _analytics.logEvent(name: 'notification_tap');
    logger.d('[Analytics] notification_tap');
  }

  // ── 이스터에그 ──

  void logEasterEggFound() {
    _analytics.logEvent(name: 'easter_egg_found');
    logger.d('[Analytics] easter_egg_found');
  }

  // ── 홈 화면 위젯 ──

  void logWidgetUpdate({required int count}) {
    _analytics.logEvent(
      name: 'widget_update',
      parameters: {'count': count},
    );
    logger.d('[Analytics] widget_update: count=$count');
  }

  // ── 백업/복원 ──

  void logBackupExport({required bool success, int birthdayCount = 0}) {
    _analytics.logEvent(
      name: 'backup_export',
      parameters: {
        'success': success.toString(),
        'birthday_count': birthdayCount,
      },
    );
    logger.d('[Analytics] backup_export: success=$success, birthday_count=$birthdayCount');
  }

  void logBackupRestore({
    required bool success,
    required String mode,
    int birthdayCount = 0,
  }) {
    _analytics.logEvent(
      name: 'backup_restore',
      parameters: {
        'success': success.toString(),
        'mode': mode,
        'birthday_count': birthdayCount,
      },
    );
    logger.d('[Analytics] backup_restore: success=$success, mode=$mode, birthday_count=$birthdayCount');
  }

  // ── User Property ──

  void setUserBirthdayCount(int count) {
    String tier;
    if (count == 0) {
      tier = '0';
    } else if (count <= 5) {
      tier = '1-5';
    } else if (count <= 20) {
      tier = '6-20';
    } else if (count <= 50) {
      tier = '21-50';
    } else {
      tier = '51+';
    }

    _analytics.setUserProperty(name: 'birthday_count_tier', value: tier);
    logger.d('[Analytics] setUserProperty: birthday_count_tier=$tier');
  }
}
