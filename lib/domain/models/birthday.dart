import 'package:rememberotter/shared/services/settings_service.dart';
import 'package:rememberotter/shared/utils/lunar_converter.dart';

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

  /// 음력 출생 월·일을 주어진 음력 연도 기준으로 양력 변환
  DateTime _solarFromLunarYear(int lunarYear) =>
      LunarConverter.lunarToSolar(lunarYear, birthDate.month, birthDate.day);

  /// 주어진 양력 연도(solarYear) 안에서의 양력 발생일.
  /// 음력 11·12월처럼 발생일이 다음 양력 연도로 넘어가는 경우,
  /// 직전 음력 연도에서 넘어온 날짜를 보정해 반환한다.
  DateTime solarOccurrenceInYear(int solarYear) {
    if (!isLunarCalendar) {
      return DateTime(solarYear, birthDate.month, birthDate.day);
    }
    final current = _solarFromLunarYear(solarYear);
    if (current.year == solarYear) return current;
    final prev = _solarFromLunarYear(solarYear - 1);
    if (prev.year == solarYear) return prev;
    return current;
  }

  /// 올해 양력 생일 날짜
  DateTime get thisYearBirthday => solarOccurrenceInYear(DateTime.now().year);

  /// 다음(오늘 포함) 양력 생일 날짜
  DateTime get nextSolarBirthday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    for (var y = now.year; y <= now.year + 2; y++) {
      final s = solarOccurrenceInYear(y);
      if (!s.isBefore(today)) return s;
    }
    return solarOccurrenceInYear(now.year + 1);
  }

  /// date(연·월·일)가 이 생일의 그 해 양력 발생일과 같은 날인지
  bool fallsOnSolarDate(DateTime date) {
    if (!isLunarCalendar) {
      return birthDate.month == date.month && birthDate.day == date.day;
    }
    final s = solarOccurrenceInYear(date.year);
    return s.month == date.month && s.day == date.day;
  }

  /// 다음 생일까지 남은 일수
  int get daysUntilBirthday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    for (var y = now.year; y <= now.year + 2; y++) {
      final s = solarOccurrenceInYear(y);
      if (s.isAfter(today)) return s.difference(today).inDays;
    }
    return solarOccurrenceInYear(now.year + 1).difference(today).inDays;
  }

  /// 출생 양력 날짜 (음력이면 변환). 나이 계산 기준.
  DateTime get _solarBirthDate => isLunarCalendar
      ? _solarFromLunarYear(birthDate.year)
      : birthDate;

  /// 만나이 계산 (양력 출생 연도 기준, 올해 생일 경과 여부로 보정)
  int? get age {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    int age = now.year - _solarBirthDate.year;
    if (today.isBefore(thisYearBirthday)) {
      age--;
    }
    return age;
  }

  /// 연나이 계산 (올해 연도 - 출생 연도).
  /// 음력은 입력한 음력 연도(띠/생년 관습)를 그대로 사용한다.
  int? get yearAge {
    return DateTime.now().year - birthDate.year;
  }

  /// 설정에 따른 나이 텍스트 (예: "만 25세" 또는 "25세")
  String? get ageText {
    final useIntl = SettingsService().useInternationalAge;
    final displayAge = useIntl ? age : yearAge;
    if (displayAge == null) return null;
    return useIntl ? '만 $displayAge세' : '$displayAge세';
  }
}
