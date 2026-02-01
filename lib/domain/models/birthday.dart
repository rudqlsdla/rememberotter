import 'package:hive/hive.dart';

part 'birthday.g.dart';

@HiveType(typeId: 0)
class Birthday extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final DateTime birthDate;

  @HiveField(3)
  final String? memo;

  @HiveField(4)
  final String? profileImage;

  @HiveField(5)
  @Deprecated('음력 기능 미사용 - Hive 호환성을 위해 필드 유지')
  final bool isLunarCalendar;

  @HiveField(6)
  final bool notificationEnabled;

  @HiveField(7)
  final int notificationDaysBefore;

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  final DateTime updatedAt;

  Birthday({
    required this.id,
    required this.name,
    required this.birthDate,
    this.memo,
    this.profileImage,
    this.isLunarCalendar = false,
    this.notificationEnabled = true,
    this.notificationDaysBefore = 1,
    required this.createdAt,
    required this.updatedAt,
  });

  Birthday copyWith({
    String? id,
    String? name,
    DateTime? birthDate,
    String? memo,
    String? profileImage,
    bool? isLunarCalendar,
    bool? notificationEnabled,
    int? notificationDaysBefore,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Birthday(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      memo: memo ?? this.memo,
      profileImage: profileImage ?? this.profileImage,
      isLunarCalendar: isLunarCalendar ?? this.isLunarCalendar,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      notificationDaysBefore: notificationDaysBefore ?? this.notificationDaysBefore,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// 올해 생일 날짜 반환
  DateTime get thisYearBirthday {
    final now = DateTime.now();
    return DateTime(now.year, birthDate.month, birthDate.day);
  }

  /// 다음 생일까지 남은 일수
  int get daysUntilBirthday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    var nextBirthday = DateTime(now.year, birthDate.month, birthDate.day);

    if (nextBirthday.isBefore(today) || nextBirthday.isAtSameMomentAs(today)) {
      nextBirthday = DateTime(now.year + 1, birthDate.month, birthDate.day);
    }

    return nextBirthday.difference(today).inDays;
  }

  /// 나이 계산 (올해 기준)
  int? get age {
    final now = DateTime.now();
    return now.year - birthDate.year;
  }
}
