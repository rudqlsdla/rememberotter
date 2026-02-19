import 'package:hive/hive.dart';
import 'package:rememberotter/shared/services/settings_service.dart';

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

  /// 만나이 계산
  int? get age {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  /// 연나이 계산 (올해 연도 - 출생 연도)
  int? get yearAge {
    final now = DateTime.now();
    return now.year - birthDate.year;
  }

  /// 설정에 따른 나이 텍스트 (예: "만 25세" 또는 "25세")
  String? get ageText {
    final useIntl = SettingsService().useInternationalAge;
    final displayAge = useIntl ? age : yearAge;
    if (displayAge == null) return null;
    return useIntl ? '만 $displayAge세' : '$displayAge세';
  }
}
