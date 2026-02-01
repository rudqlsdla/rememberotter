import 'package:hive/hive.dart';

part 'gift.g.dart';

@HiveType(typeId: 1)
class Gift extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String birthdayId;

  @HiveField(2)
  final int year;

  @HiveField(3)
  final bool given;

  @HiveField(4)
  final bool received;

  @HiveField(5)
  final String? givenGiftName;

  @HiveField(6)
  final String? receivedGiftName;

  @HiveField(7)
  final String? memo;

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  final DateTime updatedAt;

  Gift({
    required this.id,
    required this.birthdayId,
    required this.year,
    this.given = false,
    this.received = false,
    this.givenGiftName,
    this.receivedGiftName,
    this.memo,
    required this.createdAt,
    required this.updatedAt,
  });

  Gift copyWith({
    String? id,
    String? birthdayId,
    int? year,
    bool? given,
    bool? received,
    String? givenGiftName,
    String? receivedGiftName,
    String? memo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Gift(
      id: id ?? this.id,
      birthdayId: birthdayId ?? this.birthdayId,
      year: year ?? this.year,
      given: given ?? this.given,
      received: received ?? this.received,
      givenGiftName: givenGiftName ?? this.givenGiftName,
      receivedGiftName: receivedGiftName ?? this.receivedGiftName,
      memo: memo ?? this.memo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// 선물 교환 상태 문자열
  String get exchangeStatus {
    if (given && received) return '서로 교환';
    if (given) return '선물함';
    if (received) return '받음';
    return '기록 없음';
  }
}
