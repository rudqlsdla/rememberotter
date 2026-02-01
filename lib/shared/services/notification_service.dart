import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:rememberotter/domain/models/birthday.dart';
import 'package:rememberotter/shared/log/logger.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // 알림 시간 (기본 오전 9시)
  static const int _defaultHour = 9;
  static const int _defaultMinute = 0;

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

    logger.i('NotificationService 초기화 완료');
  }

  void _onNotificationTapped(NotificationResponse response) {
    logger.i('알림 탭: ${response.payload}');
    // TODO: 알림 탭 시 해당 생일 상세 페이지로 이동
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

    final nextBirthday = _getNextBirthday(birthday.birthDate);
    final notificationDate = nextBirthday.subtract(
      Duration(days: birthday.notificationDaysBefore),
    );

    // 알림 시간 설정 (오전 9시)
    final scheduledDate = tz.TZDateTime(
      tz.local,
      notificationDate.year,
      notificationDate.month,
      notificationDate.day,
      _defaultHour,
      _defaultMinute,
    );

    // 이미 지난 시간이면 스킵
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      logger.i('${birthday.name} 알림: 이미 지난 시간');
      return;
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

  /// 모든 생일 알림 재스케줄링
  Future<void> rescheduleAllBirthdayNotifications(List<Birthday> birthdays) async {
    await cancelAllNotifications();
    for (final birthday in birthdays) {
      await scheduleBirthdayNotification(birthday);
    }
    logger.i('${birthdays.length}개 생일 알림 재스케줄링 완료');
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
