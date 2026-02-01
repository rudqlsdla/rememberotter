import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:rememberotter/app/app_routes.dart';
import 'package:rememberotter/domain/models/birthday.dart';
import 'package:rememberotter/shared/log/logger.dart';
import 'package:rememberotter/shared/services/settings_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  /// iOS 최대 예약 알림 개수 제한
  static const int _maxScheduledNotifications = 64;

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final SettingsService _settingsService = SettingsService();

  Future<void> initialize() async {
    // 타임존 초기화
    tz.initializeTimeZones();
    final timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // Android 설정
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS 설정 (권한 요청은 permission_handler로 별도 처리)
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // 앱이 종료된 상태에서 알림 탭으로 실행된 경우 처리
    final launchDetails = await _notifications.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp == true) {
      final response = launchDetails!.notificationResponse;
      if (response != null) {
        // 약간의 딜레이 후 이동 (앱 초기화 완료 대기)
        Future.delayed(const Duration(milliseconds: 500), () {
          _onNotificationTapped(response);
        });
      }
    }

    logger.i('NotificationService 초기화 완료');
  }

  void _onNotificationTapped(NotificationResponse response) {
    logger.i('알림 탭: ${response.payload}');

    final birthdayId = response.payload;
    if (birthdayId != null && birthdayId.isNotEmpty) {
      Get.toNamed(AppRoutes.birthdayDetail, arguments: birthdayId);
    }
  }

  /// 알림 권한 상태 확인
  Future<PermissionStatus> checkPermission() async {
    return await Permission.notification.status;
  }

  /// 알림 권한 요청
  Future<bool> requestPermission() async {
    final status = await Permission.notification.request();
    logger.i('알림 권한 요청 결과: $status');
    return status.isGranted;
  }

  /// 알림 권한이 영구 거부되었는지 확인
  Future<bool> isPermanentlyDenied() async {
    return await Permission.notification.isPermanentlyDenied;
  }

  /// 앱 설정 화면 열기
  Future<bool> openSettings() async {
    return await openAppSettings();
  }

  /// 생일 알림 스케줄링
  Future<void> scheduleBirthdayNotification(Birthday birthday) async {
    if (!birthday.notificationEnabled) {
      await cancelBirthdayNotification(birthday.id);
      return;
    }

    var nextBirthday = _getNextBirthday(birthday.birthDate);
    var notificationDate = nextBirthday.subtract(
      Duration(days: birthday.notificationDaysBefore),
    );

    // 알림 시간 설정 (설정된 시간 사용)
    var scheduledDate = tz.TZDateTime(
      tz.local,
      notificationDate.year,
      notificationDate.month,
      notificationDate.day,
      _settingsService.notificationHour,
      _settingsService.notificationMinute,
    );

    // 이미 지난 시간이면 내년 생일 기준으로 재계산
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      nextBirthday = DateTime(nextBirthday.year + 1, nextBirthday.month, nextBirthday.day);
      notificationDate = nextBirthday.subtract(
        Duration(days: birthday.notificationDaysBefore),
      );
      scheduledDate = tz.TZDateTime(
        tz.local,
        notificationDate.year,
        notificationDate.month,
        notificationDate.day,
        _settingsService.notificationHour,
        _settingsService.notificationMinute,
      );
    }

    final notificationId = birthday.id.hashCode;

    // 알림 메시지 생성
    String title;
    String body;
    if (birthday.notificationDaysBefore == 0) {
      title = '오늘은 ${birthday.name}님의 생일이에요!';
      body = '잊지 않고 기억해달이 알려드려요 🎂';
    } else if (birthday.notificationDaysBefore == 1) {
      title = '내일은 ${birthday.name}님의 생일이에요!';
      body = '미리 준비해보세요 🎁';
    } else {
      title = '${birthday.notificationDaysBefore}일 후 ${birthday.name}님의 생일이에요!';
      body = '미리 준비해보세요 🎁';
    }

    await _notifications.zonedSchedule(
      notificationId,
      title,
      body,
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'birthday_channel',
          '생일 알림',
          channelDescription: '생일 알림을 받습니다',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: birthday.id,
    );

    logger.i('${birthday.name} 알림 스케줄: $scheduledDate');
  }

  /// 생일 알림 취소
  Future<void> cancelBirthdayNotification(String birthdayId) async {
    final notificationId = birthdayId.hashCode;
    await _notifications.cancel(notificationId);
    logger.i('알림 취소: $birthdayId');
  }

  /// 모든 알림 취소
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    logger.i('모든 알림 취소');
  }

  /// 모든 생일 알림 재스케줄링 (iOS 64개 제한 대응)
  Future<void> rescheduleAllBirthdayNotifications(List<Birthday> birthdays) async {
    await cancelAllNotifications();

    // 알림 활성화된 생일만 필터링
    final enabledBirthdays = birthdays
        .where((b) => b.notificationEnabled)
        .toList();

    // D-day 가까운 순으로 정렬
    enabledBirthdays.sort((a, b) =>
        a.daysUntilBirthday.compareTo(b.daysUntilBirthday));

    // 최대 64개만 스케줄링
    final toSchedule = enabledBirthdays.take(_maxScheduledNotifications);

    for (final birthday in toSchedule) {
      await scheduleBirthdayNotification(birthday);
    }

    logger.i('${toSchedule.length}/${enabledBirthdays.length}개 생일 알림 스케줄링 완료');
  }

  /// 다음 생일 날짜 계산
  DateTime _getNextBirthday(DateTime birthDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    var nextBirthday = DateTime(now.year, birthDate.month, birthDate.day);

    if (nextBirthday.isBefore(today)) {
      nextBirthday = DateTime(now.year + 1, birthDate.month, birthDate.day);
    }

    return nextBirthday;
  }

  /// 예정된 알림 목록 확인 (디버그용)
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}
