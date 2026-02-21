import 'package:get/get.dart';
import 'package:rememberotter/domain/models/birthday.dart';
import 'package:rememberotter/domain/repositories/birthday_repository.dart';
import 'package:rememberotter/feature/gift/controllers/gift_controller.dart';
import 'package:rememberotter/shared/services/notification_service.dart';

class BirthdayController extends GetxController {
  final BirthdayRepository _repository = BirthdayRepository();
  final NotificationService _notificationService = NotificationService();

  final RxList<Birthday> birthdays = <Birthday>[].obs;
  final RxList<Birthday> upcomingBirthdays = <Birthday>[].obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxList<Birthday> selectedDateBirthdays = <Birthday>[].obs;
  final RxBool isLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadBirthdays();
  }

  /// 모든 생일 알림 스케줄링
  Future<void> _scheduleAllNotifications() async {
    await _notificationService.rescheduleAllBirthdayNotifications(birthdays);
  }

  /// 모든 생일 로드
  Future<void> loadBirthdays() async {
    final all = await _repository.getAll();
    all.sort((a, b) => a.daysUntilBirthday.compareTo(b.daysUntilBirthday));
    birthdays.value = all;
    upcomingBirthdays.value =
        all.where((b) => b.daysUntilBirthday <= 30).toList();
    _updateSelectedDateBirthdays();
    _scheduleAllNotifications();
    isLoaded.value = true;
  }

  /// 선택된 날짜 변경
  void selectDate(DateTime date) {
    selectedDate.value = date;
    _updateSelectedDateBirthdays();
  }

  /// 선택된 날짜의 생일 업데이트 (로드된 리스트에서 필터링)
  void _updateSelectedDateBirthdays() {
    selectedDateBirthdays.value = birthdays
        .where((b) =>
            b.birthDate.month == selectedDate.value.month &&
            b.birthDate.day == selectedDate.value.day)
        .toList();
  }

  /// 특정 월의 생일 조회 (로드된 리스트에서 필터링)
  List<Birthday> getBirthdaysByMonth(int month) {
    return birthdays.where((b) => b.birthDate.month == month).toList();
  }

  /// 특정 날짜에 생일이 있는지 확인
  bool hasBirthdayOnDate(DateTime date) {
    return birthdays.any(
      (b) => b.birthDate.month == date.month && b.birthDate.day == date.day,
    );
  }

  /// 특정 날짜의 생일 목록
  List<Birthday> getBirthdaysOnDate(DateTime date) {
    return birthdays
        .where((b) => b.birthDate.month == date.month && b.birthDate.day == date.day)
        .toList();
  }

  /// 생일 추가
  Future<void> addBirthday({
    required String name,
    required DateTime birthDate,
    String? memo,
  }) async {
    final birthday = await _repository.add(
      name: name,
      birthDate: birthDate,
      memo: memo,
    );
    try {
      await _notificationService.scheduleBirthdayNotification(birthday);
    } catch (_) {}
    await loadBirthdays();
  }

  /// 생일 수정
  Future<void> updateBirthday(Birthday birthday) async {
    await _repository.update(birthday);
    try {
      await _notificationService.scheduleBirthdayNotification(birthday);
    } catch (_) {}
    await loadBirthdays();
  }

  /// 생일 삭제 (관련 선물 기록도 함께 삭제)
  Future<void> deleteBirthday(String id) async {
    // 알림 취소
    await _notificationService.cancelBirthdayNotification(id);
    // 관련 선물 기록 먼저 삭제
    if (Get.isRegistered<GiftController>()) {
      await Get.find<GiftController>().deleteGiftsByBirthdayId(id);
    }
    await _repository.delete(id);
    await loadBirthdays();
  }

  /// 생일 일괄 추가 (연락처 가져오기용)
  Future<void> addBirthdayBatch(
    List<({String name, DateTime birthDate})> items,
  ) async {
    for (final item in items) {
      await _repository.add(
        name: item.name,
        birthDate: item.birthDate,
      );
    }
    await loadBirthdays();
    try {
      await _notificationService.rescheduleAllBirthdayNotifications(birthdays);
    } catch (_) {}
  }

  /// 이름으로 검색 (로드된 리스트에서 필터링)
  List<Birthday> searchBirthdays(String query) {
    if (query.isEmpty) return birthdays.toList();
    final lowerQuery = query.toLowerCase();
    return birthdays
        .where((b) => b.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// 모든 생일의 알림 일수 일괄 업데이트
  Future<void> updateAllNotificationDaysBefore(int days) async {
    for (final birthday in birthdays) {
      if (birthday.notificationDaysBefore != days) {
        final updated = birthday.copyWith(notificationDaysBefore: days);
        await _repository.update(updated);
      }
    }
    await loadBirthdays();
    try {
      await _notificationService.rescheduleAllBirthdayNotifications(birthdays);
    } catch (_) {}
  }
}
