# 음력 생일 기능 설계 (평달 기준)

- 작성일: 2026-06-16
- 배경: 사용자 피드백 "양력음력이 구분되었으면 합니다" (v1.2.1, Android)
- 상태: 승인됨 → 구현 계획 단계

## 목표

생일을 **양력 / 음력**으로 구분해서 저장하고, 음력 생일은 매년 그 해의 양력 날짜로 변환해 D-day·캘린더·알림·위젯에 정확히 반영한다.

## 결정 사항 (브레인스토밍 합의)

1. **정식 변환**: 음력 생일은 입력한 음력 날짜를 매년 양력으로 변환해 계산한다. (단순 라벨 표시 아님)
2. **평달 기준만**: 윤달 체크박스는 만들지 않는다. 윤달 출생자(극소수)는 평달로 근사한다.
   - 근거: 현실에서도 윤달 생일은 19년에 한 번꼴이라 평달로 타협하는 것이 일반적 관행.
3. **양방향 입력 변환 포함**: 양력 날짜만 아는 사용자도 음력으로 저장할 수 있도록 양력↔음력 입력 변환을 지원한다.

## 핵심 아이디어

"입력값(저장값)"과 "올해 양력 발생일"을 분리한다.
- 음력 생일은 `birthDate`에 **음력 연·월·일**을 그대로 저장.
- D-day·캘린더·알림·위젯이 참조하는 "양력 발생일"은 매년 변환해서 계산.
- 양력 생일은 기존과 완전히 동일하게 동작.

## 설계 상세

### 1. 변환 유틸 — `lib/shared/utils/lunar_converter.dart`
- `korean_lunar_calendar` 패키지 래핑 (순수 Dart, 약 1391~2050 지원). 버전은 구현 시 pub.dev 확인.
- 라이브러리 의존을 한 곳에 격리하는 단일 진입점.
- 메서드:
  - `DateTime lunarToSolar(int year, int month, int day)` — 변환 실패/존재하지 않는 날짜면 그 달 마지막 유효일로 fallback.
  - `({int month, int day}) solarToLunar(DateTime solar)` — 음력 월/일 반환. 결과가 윤달이어도 평달 값으로 근사(평달 정책).

### 2. DB / 저장
- **기존 `isLunarCalendar` 필드 재사용** → 마이그레이션·schemaVersion 변경 없음.
- 음력이면 `birthDate` = 음력 Y/M/D, 양력이면 양력 Y/M/D (현행 유지).

### 3. 도메인 모델 `lib/domain/models/birthday.dart`
- `DateTime solarDateForYear(int year)` 추가
  - 양력: `DateTime(year, birthDate.month, birthDate.day)`
  - 음력: `LunarConverter.lunarToSolar(year, birthDate.month, birthDate.day)`
- `thisYearBirthday`, `daysUntilBirthday`, (신규) `nextSolarBirthday`를 `solarDateForYear` 기반으로 재작성.
  - **양력 동작은 기존과 동일한 결과를 유지**(surgical). 음력만 변환 경유.
- `bool fallsOnSolarDate(DateTime date)` 추가 — 캘린더 매칭용. 해당 연도(`date.year`) 기준 변환 후 월/일 비교.
- `age` / `yearAge`는 `birthDate.year`(음력 연도) 그대로 사용 — 평달 근사 정책과 일관.

### 4. 폼 UI `lib/feature/birthday/widgets/birthday_form_sheet.dart`
- **저장 기준 세그먼트 토글 `[양력으로 챙김 | 음력으로 챙김]`** → `isLunar` 결정.
- 스피너 입력은 저장 기준 그대로 받고, 바로 아래 **반대 달력 변환값을 라이브 표시**:
  - 음력 저장 → "양력(올해): O월 O일"
  - 양력 저장 → "음력: O월 O일"
- **양력만 아는 케이스**: 음력 저장 모드에서 `양력으로 입력` 보조 토글 제공 → 양력 날짜를 받아 `solarToLunar`로 음력 값으로 변환해 저장. (구체 인터랙션은 구현 계획에서 확정)
- 저장 시 `isLunar` 전달.
- `BirthdayController.addBirthday` / `BirthdayRepository.add`에 `isLunar` 파라미터 추가 (현재 add는 isLunar를 안 넘김 → 보완). 수정 경로는 `update()`가 이미 `isLunarCalendar`를 저장함.

### 5. 캘린더 매칭 `lib/feature/birthday/controllers/birthday_controller.dart`
- `getBirthdaysOnDate(DateTime)`, `_updateSelectedDateBirthdays()`, `hasBirthdayOnDate(DateTime)`를 `fallsOnSolarDate(date)` 사용으로 교체 (연도 포함 날짜라 음력 변환 가능).
- 라이브 캘린더 경로는 `getBirthdaysOnDate` / `selectedDate`(둘 다 연도 포함)를 통과함 — 확인 완료.
- `getBirthdaysByMonth(int month)`(연도 없는 월 단위)와 repository `getByMonth`/`getByDate`는 호출처 없음(dead) → 손대지 않음.

### 6. 알림 `lib/shared/services/notification_service.dart`
- `_getNextBirthday(DateTime)` → 모델의 `nextSolarBirthday`(또는 Birthday 단위 계산) 사용하도록 변경. 음력 변환 반영.

### 7. 위젯 `lib/shared/services/widget_service.dart`
- 표시용 `month` / `day`를 `nextSolarBirthday`의 양력 월/일로 사용. `daysUntil`은 모델에서 자동 보정됨.

### 8. 표시
- 리스트 아이템(`birthday_list_item.dart`): 음력이면 `음력 M월 D일` 라벨.
- 상세(`birthday_detail_page.dart`): 음력이면 `음력 YYYY년 M월 D일` + (필요 시) 올해 양력 발생일 보조 표기.

## 범위 밖 (YAGNI)
- 윤달(閏月) 체크박스 / 윤달 정밀 처리
- 연락처 가져오기에서의 음력 처리 (폰 연락처 생일은 양력으로 간주)
- 음력 관련 다크모드/별도 화면 등

## 성공 기준
- 음력 생일 추가 시 매년 올바른 양력 날짜에 D-day·캘린더·알림·위젯이 표시된다.
- 양력 생일은 기존과 동일하게 동작한다(회귀 없음).
- 폼에서 양력/음력 전환 시 반대 달력 값이 즉시 표시되고, 양력만 알아도 음력으로 저장할 수 있다.
- 음력 생일은 리스트·상세에서 `음력` 라벨로 구분된다.
