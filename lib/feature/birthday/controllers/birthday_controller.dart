import 'package:get/get.dart';
import 'package:rememberotter/domain/models/birthday.dart';
import 'package:rememberotter/domain/repositories/birthday_repository.dart';

class BirthdayController extends GetxController {
  final BirthdayRepository _repository = BirthdayRepository();

  final RxList<Birthday> birthdays = <Birthday>[].obs;
  final RxList<Birthday> upcomingBirthdays = <Birthday>[].obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxList<Birthday> selectedDateBirthdays = <Birthday>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadBirthdays();
  }

  /// 모든 생일 로드
  void loadBirthdays() {
    birthdays.value = _repository.getAll();
    birthdays.sort((a, b) => a.daysUntilBirthday.compareTo(b.daysUntilBirthday));
    upcomingBirthdays.value = _repository.getUpcoming(days: 30);
    _updateSelectedDateBirthdays();
  }

  /// 선택된 날짜 변경
  void selectDate(DateTime date) {
    selectedDate.value = date;
    _updateSelectedDateBirthdays();
  }

  /// 선택된 날짜의 생일 업데이트
  void _updateSelectedDateBirthdays() {
    selectedDateBirthdays.value = _repository.getByDate(
      selectedDate.value.month,
      selectedDate.value.day,
    );
  }

  /// 특정 월의 생일 조회
  List<Birthday> getBirthdaysByMonth(int month) {
    return _repository.getByMonth(month);
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
    await _repository.add(
      name: name,
      birthDate: birthDate,
      memo: memo,
    );
    loadBirthdays();
  }

  /// 생일 수정
  Future<void> updateBirthday(Birthday birthday) async {
    await _repository.update(birthday);
    loadBirthdays();
  }

  /// 생일 삭제
  Future<void> deleteBirthday(String id) async {
    await _repository.delete(id);
    loadBirthdays();
  }

  /// 이름으로 검색
  List<Birthday> searchBirthdays(String query) {
    return _repository.search(query);
  }
}
