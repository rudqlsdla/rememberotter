import 'package:korean_lunar_utils/korean_lunar_utils.dart';

/// 음력 <-> 양력 변환 유틸 (평달 기준).
///
/// korean_lunar_utils 패키지를 래핑해 라이브러리 의존을 한 곳에 격리한다.
/// 윤달은 다루지 않으며(평달 근사), 지원 범위(1900~2049) 밖이면 입력값을
/// 그대로 양력으로 간주해 조용히 fallback 한다.
class LunarConverter {
  LunarConverter._();

  /// 음력(평달) 연·월·일 → 해당 양력 날짜.
  static DateTime lunarToSolar(int year, int month, int day) {
    try {
      return LunarSolarConverter.convertLunarToSolar(DateTime(year, month, day));
    } catch (_) {
      return DateTime(year, month, day);
    }
  }

  /// 양력 날짜 → 음력(평달) 날짜. 윤달 정보는 무시한다.
  static DateTime solarToLunar(DateTime solar) {
    try {
      return LunarSolarConverter.convertSolarToLunar(
        DateTime(solar.year, solar.month, solar.day),
      );
    } catch (_) {
      return solar;
    }
  }
}
