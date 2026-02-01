import 'package:hive/hive.dart';
import 'package:rememberotter/domain/models/gift.dart';
import 'package:uuid/uuid.dart';

class GiftRepository {
  static const String _boxName = 'gifts';
  final _uuid = const Uuid();

  Box<Gift> get _box => Hive.box<Gift>(_boxName);

  /// 모든 선물 기록 조회
  List<Gift> getAll() {
    return _box.values.toList();
  }

  /// ID로 선물 기록 조회
  Gift? getById(String id) {
    return _box.values.where((g) => g.id == id).firstOrNull;
  }

  /// Birthday ID로 선물 기록 조회
  List<Gift> getByBirthdayId(String birthdayId) {
    return _box.values
        .where((g) => g.birthdayId == birthdayId)
        .toList()
      ..sort((a, b) => b.year.compareTo(a.year)); // 최신 연도 우선
  }

  /// Birthday ID와 연도로 선물 기록 조회
  Gift? getByBirthdayIdAndYear(String birthdayId, int year) {
    return _box.values
        .where((g) => g.birthdayId == birthdayId && g.year == year)
        .firstOrNull;
  }

  /// 연도별 선물 기록 조회
  List<Gift> getByYear(int year) {
    return _box.values.where((g) => g.year == year).toList();
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
    final gift = Gift(
      id: _uuid.v4(),
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

    await _box.put(gift.id, gift);
    return gift;
  }

  /// 선물 기록 수정
  Future<Gift?> update(Gift gift) async {
    final updated = gift.copyWith(updatedAt: DateTime.now());
    await _box.put(updated.id, updated);
    return updated;
  }

  /// 선물 기록 삭제
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  /// Birthday ID로 모든 선물 기록 삭제 (Birthday 삭제 시 사용)
  Future<void> deleteByBirthdayId(String birthdayId) async {
    final gifts = getByBirthdayId(birthdayId);
    for (final gift in gifts) {
      await _box.delete(gift.id);
    }
  }

  /// 모든 선물 기록 삭제
  Future<void> deleteAll() async {
    await _box.clear();
  }
}
