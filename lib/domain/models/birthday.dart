import 'package:rememberotter/shared/services/settings_service.dart';

class Birthday {
  final String id;
  final String name;
  final DateTime birthDate;
  final String? memo;
  final String? profileImage;
  final String? groupId;
  final bool isLunarCalendar;
  final bool notificationEnabled;
  final int notificationDaysBefore;
  final DateTime createdAt;
  final DateTime updatedAt;

  Birthday({
    required this.id,
    required this.name,
    required this.birthDate,
    this.memo,
    this.profileImage,
    this.groupId,
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
    String? Function()? groupId,
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
      groupId: groupId != null ? groupId() : this.groupId,
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
