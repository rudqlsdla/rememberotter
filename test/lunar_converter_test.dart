import 'package:flutter_test/flutter_test.dart';
import 'package:rememberotter/domain/models/birthday.dart';
import 'package:rememberotter/shared/utils/lunar_converter.dart';

Birthday _lunar(int m, int d) => Birthday(
      id: 'x',
      name: 'n',
      birthDate: DateTime(1990, m, d),
      isLunarCalendar: true,
      createdAt: DateTime(2020),
      updatedAt: DateTime(2020),
    );

void main() {
  group('LunarConverter.lunarToSolar (설날 = 음력 1월 1일)', () {
    test('2024 설날 → 2024-02-10', () {
      final solar = LunarConverter.lunarToSolar(2024, 1, 1);
      expect(solar.year, 2024);
      expect(solar.month, 2);
      expect(solar.day, 10);
    });

    test('2025 설날 → 2025-01-29', () {
      final solar = LunarConverter.lunarToSolar(2025, 1, 1);
      expect(solar.month, 1);
      expect(solar.day, 29);
    });

    test('2026 설날 → 2026-02-17', () {
      final solar = LunarConverter.lunarToSolar(2026, 1, 1);
      expect(solar.month, 2);
      expect(solar.day, 17);
    });

    test('같은 음력 생일이 해마다 다른 양력 날짜로 변환된다', () {
      final y2025 = LunarConverter.lunarToSolar(2025, 3, 15);
      final y2026 = LunarConverter.lunarToSolar(2026, 3, 15);
      expect(y2025.month == y2026.month && y2025.day == y2026.day, isFalse);
    });
  });

  group('LunarConverter.solarToLunar (양력 → 음력 왕복)', () {
    test('2024-02-10 → 음력 1월 1일', () {
      final lunar = LunarConverter.solarToLunar(DateTime(2024, 2, 10));
      expect(lunar.month, 1);
      expect(lunar.day, 1);
    });

    test('lunarToSolar ∘ solarToLunar 왕복 일치', () {
      final solar = DateTime(1990, 5, 1);
      final lunar = LunarConverter.solarToLunar(solar);
      final back = LunarConverter.lunarToSolar(lunar.year, lunar.month, lunar.day);
      expect(back.year, solar.year);
      expect(back.month, solar.month);
      expect(back.day, solar.day);
    });
  });

  group('Birthday.solarOccurrenceInYear — 섣달(음력 12월) 연도 보정', () {
    test('음력 12월 30일의 2026년 발생일은 2027년이 아니라 2026년이다', () {
      final occ = _lunar(12, 30).solarOccurrenceInYear(2026);
      expect(occ.year, 2026); // 버그였다면 2027
      expect(occ.month, 2);
    });

    test('음력 12월 30일은 해마다 발생 양력 연도가 입력 연도와 같다', () {
      for (final y in [2024, 2025, 2026, 2027]) {
        expect(_lunar(12, 30).solarOccurrenceInYear(y).year, y);
      }
    });

    test('음력 5월 5일(평이한 달)은 같은 양력 연도에 머문다', () {
      final occ = _lunar(5, 5).solarOccurrenceInYear(2026);
      expect(occ.year, 2026);
      expect(occ.month, 6);
      expect(occ.day, 19);
    });
  });

  group('나이 계산 — 연나이는 띠(음력 연도), 만나이는 양력 출생연도', () {
    Birthday solar(DateTime d) => Birthday(
          id: 'x', name: 'n', birthDate: d, createdAt: DateTime(2020),
          updatedAt: DateTime(2020));

    test('섣달(음력 1990/12/30)의 실제 양력 출생연도는 1991', () {
      expect(LunarConverter.lunarToSolar(1990, 12, 30).year, 1991);
    });

    test('연나이는 입력한 음력 연도(1990) 기준 — 띠/생년 관습', () {
      final lunarB = _lunar(12, 30); // 음력 1990년
      final solar1990 = solar(DateTime(1990, 6, 1));
      expect(lunarB.yearAge, solar1990.yearAge); // 둘 다 올해 - 1990
    });

    test('섣달 출생자는 만나이 < 연나이 (만나이만 양력 출생연도 1991 보정)', () {
      final lunarB = _lunar(12, 30);
      expect(lunarB.age! < lunarB.yearAge!, isTrue);
    });
  });

  group('오늘이 생일이면 D-0', () {
    test('양력 생일 당일은 daysUntilBirthday == 0 (365 아님)', () {
      final now = DateTime.now();
      final todayB = Birthday(
        id: 'x', name: 'n', birthDate: DateTime(2000, now.month, now.day),
        isLunarCalendar: false, createdAt: DateTime(2020),
        updatedAt: DateTime(2020));
      expect(todayB.daysUntilBirthday, 0);
    });
  });

  group('지원 범위 밖 fallback', () {
    test('범위 밖 연도는 입력값을 양력으로 fallback (예외 없음)', () {
      final solar = LunarConverter.lunarToSolar(2100, 3, 15);
      expect(solar, DateTime(2100, 3, 15));
    });
  });
}
