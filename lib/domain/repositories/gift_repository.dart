import 'package:drift/drift.dart';
import 'package:rememberotter/data/database/app_database.dart';
import 'package:rememberotter/domain/models/gift.dart';
import 'package:uuid/uuid.dart';

class GiftRepository {
  final _uuid = const Uuid();
  AppDatabase get _db => AppDatabase.instance;

  /// 모든 선물 기록 조회
  Future<List<Gift>> getAll() async {
    final rows = await _db.select(_db.gifts).get();
    return rows.map(_fromRow).toList();
  }

  /// ID로 선물 기록 조회
  Future<Gift?> getById(String id) async {
    final row = await (_db.select(_db.gifts)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  /// Birthday ID로 선물 기록 조회
  Future<List<Gift>> getByBirthdayId(String birthdayId) async {
    final rows = await (_db.select(_db.gifts)
          ..where((t) => t.birthdayId.equals(birthdayId))
          ..orderBy([(t) => OrderingTerm.desc(t.year)]))
        .get();
    return rows.map(_fromRow).toList();
  }

  /// Birthday ID와 연도로 선물 기록 조회
  Future<Gift?> getByBirthdayIdAndYear(String birthdayId, int year) async {
    final row = await (_db.select(_db.gifts)
          ..where((t) => t.birthdayId.equals(birthdayId) & t.year.equals(year)))
        .getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  /// 연도별 선물 기록 조회
  Future<List<Gift>> getByYear(int year) async {
    final rows = await (_db.select(_db.gifts)
          ..where((t) => t.year.equals(year)))
        .get();
    return rows.map(_fromRow).toList();
  }

  /// 선물 기록 추가
  Future<Gift> add({
    required String birthdayId,
    required int year,
    bool given = false,
    bool received = false,
    String? givenGiftName,
    String? receivedGiftName,
    String? memo,
  }) async {
    final now = DateTime.now();
    final id = _uuid.v4();
    await _db.into(_db.gifts).insert(GiftsCompanion.insert(
      id: id,
      birthdayId: birthdayId,
      year: year,
      given: Value(given),
      received: Value(received),
      givenGiftName: Value(givenGiftName),
      receivedGiftName: Value(receivedGiftName),
      memo: Value(memo),
      createdAt: now,
      updatedAt: now,
    ));
    return Gift(
      id: id,
      birthdayId: birthdayId,
      year: year,
      given: given,
      received: received,
      givenGiftName: givenGiftName,
      receivedGiftName: receivedGiftName,
      memo: memo,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// 선물 기록 수정
  Future<Gift?> update(Gift gift) async {
    final updated = gift.copyWith(updatedAt: DateTime.now());
    await (_db.update(_db.gifts)..where((t) => t.id.equals(updated.id)))
        .write(GiftsCompanion(
      birthdayId: Value(updated.birthdayId),
      year: Value(updated.year),
      given: Value(updated.given),
      received: Value(updated.received),
      givenGiftName: Value(updated.givenGiftName),
      receivedGiftName: Value(updated.receivedGiftName),
      memo: Value(updated.memo),
      updatedAt: Value(updated.updatedAt),
    ));
    return updated;
  }

  /// 선물 기록 삭제
  Future<void> delete(String id) async {
    await (_db.delete(_db.gifts)..where((t) => t.id.equals(id))).go();
  }

  /// Birthday ID로 모든 선물 기록 삭제 (Birthday 삭제 시 사용)
  Future<void> deleteByBirthdayId(String birthdayId) async {
    await (_db.delete(_db.gifts)
          ..where((t) => t.birthdayId.equals(birthdayId)))
        .go();
  }

  /// 모든 선물 기록 삭제
  Future<void> deleteAll() async {
    await _db.delete(_db.gifts).go();
  }

  /// Drift row → 도메인 모델 변환
  Gift _fromRow(GiftData row) {
    return Gift(
      id: row.id,
      birthdayId: row.birthdayId,
      year: row.year,
      given: row.given,
      received: row.received,
      givenGiftName: row.givenGiftName,
      receivedGiftName: row.receivedGiftName,
      memo: row.memo,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
