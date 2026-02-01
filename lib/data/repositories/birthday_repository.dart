import 'package:hive/hive.dart';
import 'package:memocal/data/models/birthday.dart';
import 'package:uuid/uuid.dart';

class BirthdayRepository {
  static const String _boxName = 'birthdays';
  final _uuid = const Uuid();

  Box<Birthday> get _box => Hive.box<Birthday>(_boxName);

  /// 모든 생일 조회
  List<Birthday> getAll() {
    return _box.values.toList();
  }

  /// ID로 생일 조회
  Birthday? getById(String id) {
    return _box.values.where((b) => b.id == id).firstOrNull;
  }

  /// 특정 월의 생일 조회
  List<Birthday> getByMonth(int month) {
    return _box.values.where((b) => b.birthDate.month == month).toList();
  }

  /// 특정 날짜의 생일 조회 (월, 일 기준)
  List<Birthday> getByDate(int month, int day) {
    return _box.values
        .where((b) => b.birthDate.month == month && b.birthDate.day == day)
        .toList();
  }

  /// 다가오는 생일 조회 (N일 이내)
  List<Birthday> getUpcoming({int days = 30}) {
    final all = _box.values.toList();
    return all.where((b) => b.daysUntilBirthday <= days).toList()
      ..sort((a, b) => a.daysUntilBirthday.compareTo(b.daysUntilBirthday));
  }

  /// 오늘 생일인 사람 조회
  List<Birthday> getTodayBirthdays() {
    final now = DateTime.now();
    return getByDate(now.month, now.day);
  }

  /// 생일 추가
  Future<Birthday> add({
    required String name,
    required DateTime birthDate,
    String? memo,
    String? profileImage,
    bool isLunarCalendar = false,
    bool notificationEnabled = true,
    int notificationDaysBefore = 1,
  }) async {
    final now = DateTime.now();
    final birthday = Birthday(
      id: _uuid.v4(),
      name: name,
      birthDate: birthDate,
      memo: memo,
      profileImage: profileImage,
      isLunarCalendar: isLunarCalendar,
      notificationEnabled: notificationEnabled,
      notificationDaysBefore: notificationDaysBefore,
      createdAt: now,
      updatedAt: now,
    );

    await _box.put(birthday.id, birthday);
    return birthday;
  }

  /// 생일 수정
  Future<Birthday?> update(Birthday birthday) async {
    final updated = birthday.copyWith(updatedAt: DateTime.now());
    await _box.put(updated.id, updated);
    return updated;
  }

  /// 생일 삭제
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  /// 모든 생일 삭제
  Future<void> deleteAll() async {
    await _box.clear();
  }

  /// 이름으로 검색
  List<Birthday> search(String query) {
    if (query.isEmpty) return getAll();
    final lowerQuery = query.toLowerCase();
    return _box.values
        .where((b) => b.name.toLowerCase().contains(lowerQuery))
        .toList();
  }
}
