class Gift {
  final String id;
  final String birthdayId;
  final int year;
  final bool given;
  final bool received;
  final String? givenGiftName;
  final String? receivedGiftName;
  final String? memo;
  final DateTime createdAt;
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
