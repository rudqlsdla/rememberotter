import 'package:drift/drift.dart';
import 'package:rememberotter/data/database/app_database.dart';
import 'package:rememberotter/domain/models/birthday.dart';
import 'package:uuid/uuid.dart';

class BirthdayRepository {
  final _uuid = const Uuid();
  AppDatabase get _db => AppDatabase.instance;

  /// 모든 생일 조회
  Future<List<Birthday>> getAll() async {
    final rows = await _db.select(_db.birthdays).get();
    return rows.map(_fromRow).toList();
  }

  /// ID로 생일 조회
  Future<Birthday?> getById(String id) async {
    final row = await (_db.select(_db.birthdays)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  /// 특정 월의 생일 조회
  Future<List<Birthday>> getByMonth(int month) async {
    final rows = await (_db.select(_db.birthdays)
          ..where((t) => t.birthDate.month.equals(month)))
        .get();
    return rows.map(_fromRow).toList();
  }

  /// 특정 날짜의 생일 조회 (월, 일 기준)
  Future<List<Birthday>> getByDate(int month, int day) async {
    final rows = await (_db.select(_db.birthdays)
          ..where(
              (t) => t.birthDate.month.equals(month) & t.birthDate.day.equals(day)))
        .get();
    return rows.map(_fromRow).toList();
  }

  /// 생일 추가
  Future<Birthday> add({
    required String name,
    required DateTime birthDate,
    String? memo,
    String? profileImage,
    String? groupId,
    bool isLunar = false,
    bool notificationEnabled = true,
    int notificationDaysBefore = 1,
  }) async {
    final now = DateTime.now();
    final id = _uuid.v4();
    await _db.into(_db.birthdays).insert(BirthdaysCompanion.insert(
      id: id,
      name: name,
      birthDate: birthDate,
      memo: Value(memo),
      profileImage: Value(profileImage),
      groupId: Value(groupId),
      isLunarCalendar: Value(isLunar),
      notificationEnabled: Value(notificationEnabled),
      notificationDaysBefore: Value(notificationDaysBefore),
      createdAt: now,
      updatedAt: now,
    ));
    return Birthday(
      id: id,
      name: name,
      birthDate: birthDate,
      memo: memo,
      profileImage: profileImage,
      groupId: groupId,
      isLunarCalendar: isLunar,
      notificationEnabled: notificationEnabled,
      notificationDaysBefore: notificationDaysBefore,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// 생일 수정
  Future<Birthday?> update(Birthday birthday) async {
    final updated = birthday.copyWith(updatedAt: DateTime.now());
    await (_db.update(_db.birthdays)..where((t) => t.id.equals(updated.id)))
        .write(BirthdaysCompanion(
      name: Value(updated.name),
      birthDate: Value(updated.birthDate),
      memo: Value(updated.memo),
      profileImage: Value(updated.profileImage),
      groupId: Value(updated.groupId),
      isLunarCalendar: Value(updated.isLunarCalendar),
      notificationEnabled: Value(updated.notificationEnabled),
      notificationDaysBefore: Value(updated.notificationDaysBefore),
      updatedAt: Value(updated.updatedAt),
    ));
    return updated;
  }

  /// 생일 삭제
  Future<void> delete(String id) async {
    await (_db.delete(_db.birthdays)..where((t) => t.id.equals(id))).go();
  }

  /// 모든 생일 삭제
  Future<void> deleteAll() async {
    await _db.delete(_db.birthdays).go();
  }

  /// 이름으로 검색
  Future<List<Birthday>> search(String query) async {
    if (query.isEmpty) return getAll();
    final rows = await (_db.select(_db.birthdays)
          ..where((t) => t.name.like('%$query%')))
        .get();
    return rows.map(_fromRow).toList();
  }

  /// Drift row → 도메인 모델 변환
  Birthday _fromRow(BirthdayData row) {
    return Birthday(
      id: row.id,
      name: row.name,
      birthDate: row.birthDate,
      memo: row.memo,
      profileImage: row.profileImage,
      groupId: row.groupId,
      isLunarCalendar: row.isLunarCalendar,
      notificationEnabled: row.notificationEnabled,
      notificationDaysBefore: row.notificationDaysBefore,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
