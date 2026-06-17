# 생일 전화 걸기 기능 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 생일 상세 페이지에서 해당 인물에게 바로 전화를 걸 수 있게 하고, 이를 위해 전화번호를 저장·입력·가져오는 데이터 경로를 추가한다.

**Architecture:** `Birthdays` 테이블에 nullable `phoneNumber` 컬럼을 추가(drift schema 1→2 마이그레이션)하고, 모델/리포지토리/컨트롤러/폼/연락처 가져오기/백업 복원에 전화번호를 흘려보낸다. 상세 페이지에서 `url_launcher`의 `tel:` 스킴으로 발신한다.

**Tech Stack:** Flutter, GetX, drift(SQLite), url_launcher, flutter_contacts, Firebase Analytics

**참고 spec:** `docs/superpowers/specs/2026-06-17-birthday-call-feature-design.md`

**테스트 전략:** 이 프로젝트의 기존 테스트는 순수 로직 단위 테스트(`test/lunar_converter_test.dart`)뿐이다. DB/UI/외부플러그인은 테스트 인프라가 없으므로, 순수 로직인 `Birthday` 모델은 TDD로 작성하고, 나머지 작업은 `flutter analyze`(컴파일·정적분석 통과)를 게이트로 삼고 spec의 검증 기준에 따라 수동 확인한다.

---

## File Structure

| 파일 | 작업 | 책임 |
|------|------|------|
| `lib/data/database/app_database.dart` | Modify | phoneNumber 컬럼 + schema 1→2 마이그레이션 |
| `lib/data/database/app_database.g.dart` | 재생성 | build_runner 생성물 |
| `test/birthday_model_test.dart` | Create | Birthday 모델 phoneNumber 단위 테스트 |
| `lib/domain/models/birthday.dart` | Modify | phoneNumber 필드 + copyWith |
| `lib/domain/repositories/birthday_repository.dart` | Modify | add/update/_fromRow 매핑 |
| `lib/feature/birthday/controllers/birthday_controller.dart` | Modify | addBirthday 파라미터 + batch 튜플 |
| `lib/feature/birthday/widgets/birthday_form_sheet.dart` | Modify | 전화번호 입력 필드 |
| `lib/feature/contact/controllers/contact_import_controller.dart` | Modify | 연락처 전화번호 추출 |
| `lib/shared/services/analytics_service.dart` | Modify | logBirthdayCall 이벤트 |
| `lib/feature/birthday/pages/birthday_detail_page.dart` | Modify | 전화 걸기 버튼 + 정보 행 |
| `lib/shared/services/backup_service.dart` | Modify | 복원 시 phoneNumber 보존 |
| `docs/privacy_policy.md` | Modify | 전화번호 수집 항목 반영 |

---

## Task 1: DB 스키마 + 마이그레이션

**Files:**
- Modify: `lib/data/database/app_database.dart`
- 재생성: `lib/data/database/app_database.g.dart`

- [ ] **Step 1: Birthdays 테이블에 phoneNumber 컬럼 추가**

`lib/data/database/app_database.dart`의 `Birthdays` 클래스에서 `notificationDaysBefore` 줄 아래, `createdAt` 줄 위에 추가:

```dart
  IntColumn get notificationDaysBefore => integer().withDefault(const Constant(1))();
  TextColumn get phoneNumber => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
```

- [ ] **Step 2: schemaVersion 2로 올리고 onUpgrade 추가**

`schemaVersion` getter를 변경:

```dart
  @override
  int get schemaVersion => 2;
```

`MigrationStrategy`에 `onUpgrade`를 추가 (onCreate와 beforeOpen 사이):

```dart
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _insertDefaultGroups();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(birthdays, birthdays.phoneNumber);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
```

- [ ] **Step 3: 코드 생성 실행**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: 성공, `app_database.g.dart`에 `phoneNumber` 관련 코드 생성 (에러 없음)

- [ ] **Step 4: 정적 분석**

Run: `flutter analyze lib/data/database/app_database.dart`
Expected: No issues found (해당 파일 기준)

- [ ] **Step 5: Commit**

```bash
git add lib/data/database/app_database.dart lib/data/database/app_database.g.dart
git commit -m "feat(\$birthday): Birthdays에 phoneNumber 컬럼 추가 (schema v2)"
```

---

## Task 2: Birthday 모델 + 단위 테스트 (TDD)

**Files:**
- Test: `test/birthday_model_test.dart` (Create)
- Modify: `lib/domain/models/birthday.dart`

- [ ] **Step 1: 실패하는 테스트 작성**

`test/birthday_model_test.dart` 생성:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:rememberotter/domain/models/birthday.dart';

void main() {
  Birthday make({String? phoneNumber}) => Birthday(
        id: '1',
        name: 'A',
        birthDate: DateTime(2000, 1, 1),
        phoneNumber: phoneNumber,
        createdAt: DateTime(2020),
        updatedAt: DateTime(2020),
      );

  group('Birthday.phoneNumber', () {
    test('생성자로 전화번호를 보관한다', () {
      expect(make(phoneNumber: '010-1234-5678').phoneNumber, '010-1234-5678');
    });

    test('기본값은 null', () {
      expect(make().phoneNumber, isNull);
    });

    test('copyWith로 전화번호를 변경한다', () {
      final b = make(phoneNumber: '010').copyWith(phoneNumber: () => '999');
      expect(b.phoneNumber, '999');
    });

    test('copyWith로 전화번호를 null로 지운다', () {
      final b = make(phoneNumber: '010').copyWith(phoneNumber: () => null);
      expect(b.phoneNumber, isNull);
    });

    test('copyWith에 phoneNumber 미지정 시 기존값 유지', () {
      final b = make(phoneNumber: '010').copyWith(name: 'B');
      expect(b.phoneNumber, '010');
    });
  });
}
```

- [ ] **Step 2: 테스트 실행해 실패 확인**

Run: `flutter test test/birthday_model_test.dart`
Expected: 컴파일 실패 — `Birthday`에 `phoneNumber` 파라미터 없음

- [ ] **Step 3: 모델에 phoneNumber 추가**

`lib/domain/models/birthday.dart`에서:

필드 추가 (`groupId` 줄 아래):
```dart
  final String? groupId;
  final String? phoneNumber;
  final bool isLunarCalendar;
```

생성자 파라미터 추가 (`this.groupId,` 줄 아래):
```dart
    this.groupId,
    this.phoneNumber,
    this.isLunarCalendar = false,
```

copyWith 시그니처에 추가 (`String? Function()? groupId,` 줄 아래):
```dart
    String? Function()? groupId,
    String? Function()? phoneNumber,
    bool? isLunarCalendar,
```

copyWith 본문에 추가 (`groupId: groupId != null ? groupId() : this.groupId,` 줄 아래):
```dart
      groupId: groupId != null ? groupId() : this.groupId,
      phoneNumber: phoneNumber != null ? phoneNumber() : this.phoneNumber,
      isLunarCalendar: isLunarCalendar ?? this.isLunarCalendar,
```

- [ ] **Step 4: 테스트 실행해 통과 확인**

Run: `flutter test test/birthday_model_test.dart`
Expected: All tests passed (5 tests)

- [ ] **Step 5: Commit**

```bash
git add test/birthday_model_test.dart lib/domain/models/birthday.dart
git commit -m "feat(\$birthday): Birthday 모델에 phoneNumber 추가"
```

---

## Task 3: Repository 매핑

**Files:**
- Modify: `lib/domain/repositories/birthday_repository.dart`

- [ ] **Step 1: add() 파라미터/삽입/반환에 phoneNumber 추가**

`add()` 시그니처에 파라미터 추가 (`String? groupId,` 줄 아래):
```dart
    String? groupId,
    String? phoneNumber,
    bool isLunar = false,
```

`BirthdaysCompanion.insert(...)`에 추가 (`groupId: Value(groupId),` 줄 아래):
```dart
      groupId: Value(groupId),
      phoneNumber: Value(phoneNumber),
      isLunarCalendar: Value(isLunar),
```

반환 `Birthday(...)`에 추가 (`groupId: groupId,` 줄 아래):
```dart
      groupId: groupId,
      phoneNumber: phoneNumber,
      isLunarCalendar: isLunar,
```

- [ ] **Step 2: update()에 phoneNumber 추가**

`BirthdaysCompanion(...)`에 추가 (`groupId: Value(updated.groupId),` 줄 아래):
```dart
      groupId: Value(updated.groupId),
      phoneNumber: Value(updated.phoneNumber),
      isLunarCalendar: Value(updated.isLunarCalendar),
```

- [ ] **Step 3: _fromRow()에 phoneNumber 추가**

(`groupId: row.groupId,` 줄 아래):
```dart
      groupId: row.groupId,
      phoneNumber: row.phoneNumber,
      isLunarCalendar: row.isLunarCalendar,
```

- [ ] **Step 4: 정적 분석**

Run: `flutter analyze lib/domain/repositories/birthday_repository.dart`
Expected: No issues found

- [ ] **Step 5: Commit**

```bash
git add lib/domain/repositories/birthday_repository.dart
git commit -m "feat(\$birthday): repository에 phoneNumber 매핑 추가"
```

---

## Task 4: Controller 파라미터/배치

**Files:**
- Modify: `lib/feature/birthday/controllers/birthday_controller.dart`

- [ ] **Step 1: addBirthday에 phoneNumber 파라미터 추가**

`addBirthday(...)` 시그니처에 추가 (`String? groupId,` 줄 아래):
```dart
    String? groupId,
    String? phoneNumber,
    bool isLunar = false,
```

`_repository.add(...)` 호출에 전달 (`groupId: groupId,` 줄 아래):
```dart
      groupId: groupId,
      phoneNumber: phoneNumber,
      isLunar: isLunar,
```

- [ ] **Step 2: addBirthdayBatch 튜플 타입에 phoneNumber 추가**

시그니처 변경:
```dart
  Future<void> addBirthdayBatch(
    List<({String name, DateTime birthDate, String? groupId, String? phoneNumber})> items,
  ) async {
```

루프 내 `_repository.add(...)` 호출에 전달:
```dart
      await _repository.add(
        name: item.name,
        birthDate: item.birthDate,
        groupId: item.groupId,
        phoneNumber: item.phoneNumber,
      );
```

- [ ] **Step 3: 정적 분석**

Run: `flutter analyze lib/feature/birthday/controllers/birthday_controller.dart`
Expected: No issues found (contact_import_controller는 Task 6에서 맞추므로 해당 파일 기준 분석)

- [ ] **Step 4: Commit**

```bash
git add lib/feature/birthday/controllers/birthday_controller.dart
git commit -m "feat(\$birthday): controller add/batch에 phoneNumber 전달"
```

---

## Task 5: 생일 추가/수정 폼 입력 필드

**Files:**
- Modify: `lib/feature/birthday/widgets/birthday_form_sheet.dart`

- [ ] **Step 1: 전화번호 컨트롤러 선언 및 생명주기 처리**

필드 선언 추가 (`final _memoController = TextEditingController();` 줄 아래):
```dart
  final _memoController = TextEditingController();
  final _phoneController = TextEditingController();
```

`initState`의 편집 분기에 추가 (`_memoController.text = widget.birthday!.memo ?? '';` 줄 아래):
```dart
      _memoController.text = widget.birthday!.memo ?? '';
      _phoneController.text = widget.birthday!.phoneNumber ?? '';
```

`dispose`에 추가 (`_memoController.dispose();` 줄 아래):
```dart
    _memoController.dispose();
    _phoneController.dispose();
```

- [ ] **Step 2: 전화번호 입력 필드 추가**

메모 `TextFormField`를 닫는 부분과 그 다음 `const SizedBox(height: 16),` 뒤(그룹 선택 `GestureDetector` 앞)에 추가:

```dart
              // 전화번호 입력
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: '전화번호 (선택)',
                  hintText: '전화번호를 입력하세요',
                  filled: true,
                  fillColor: AppColors.surfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
```

- [ ] **Step 3: _save()에서 phoneNumber 저장**

`_save()` 메서드 시작 부분(`final controller = Get.find<BirthdayController>();` 아래)에 추가:
```dart
    final controller = Get.find<BirthdayController>();
    final phone = _phoneController.text.trim();
    final phoneOrNull = phone.isEmpty ? null : phone;
```

편집 분기 `copyWith(...)`에 추가 (`groupId: () => _selectedGroupId,` 줄 아래):
```dart
        groupId: () => _selectedGroupId,
        phoneNumber: () => phoneOrNull,
        isLunarCalendar: _isLunar,
```

추가 분기 `controller.addBirthday(...)`에 추가 (`groupId: _selectedGroupId,` 줄 아래):
```dart
        groupId: _selectedGroupId,
        phoneNumber: phoneOrNull,
        isLunar: _isLunar,
```

- [ ] **Step 4: 정적 분석**

Run: `flutter analyze lib/feature/birthday/widgets/birthday_form_sheet.dart`
Expected: No issues found

- [ ] **Step 5: Commit**

```bash
git add lib/feature/birthday/widgets/birthday_form_sheet.dart
git commit -m "feat(\$birthday): 생일 폼에 전화번호 입력 추가"
```

---

## Task 6: 연락처 가져오기 전화번호 추출

**Files:**
- Modify: `lib/feature/contact/controllers/contact_import_controller.dart`

- [ ] **Step 1: 전화번호 추출 헬퍼 추가**

`getBirthday(Contact contact)` 메서드 아래에 추가:
```dart
  /// 연락처의 첫 번째 전화번호 (없으면 null)
  String? getPhone(Contact contact) {
    return contact.phones.firstOrNull?.number;
  }
```

- [ ] **Step 2: importSelected의 toImport 튜플에 phoneNumber 포함**

`toImport` 선언 타입을 변경:
```dart
    final List<({String name, DateTime birthDate, String? groupId, String? phoneNumber})> toImport = [];
```

`toImport.add(...)` 변경:
```dart
      toImport.add((
        name: contact.displayName,
        birthDate: birthday,
        groupId: null,
        phoneNumber: getPhone(contact),
      ));
```

- [ ] **Step 3: 정적 분석**

Run: `flutter analyze lib/feature/contact/controllers/contact_import_controller.dart`
Expected: No issues found

- [ ] **Step 4: Commit**

```bash
git add lib/feature/contact/controllers/contact_import_controller.dart
git commit -m "feat(\$contact): 연락처 가져오기 시 전화번호 함께 저장"
```

---

## Task 7: Analytics 이벤트

**Files:**
- Modify: `lib/shared/services/analytics_service.dart`

- [ ] **Step 1: logBirthdayCall 추가**

`logBirthdayDetailView()` 메서드 아래에 추가:
```dart
  void logBirthdayCall() {
    _analytics.logEvent(name: 'birthday_call');
  }
```

- [ ] **Step 2: 정적 분석**

Run: `flutter analyze lib/shared/services/analytics_service.dart`
Expected: No issues found

- [ ] **Step 3: Commit**

```bash
git add lib/shared/services/analytics_service.dart
git commit -m "feat(\$analytics): 전화 걸기 이벤트 로깅 추가"
```

---

## Task 8: 상세 페이지 전화 걸기 버튼

**Files:**
- Modify: `lib/feature/birthday/pages/birthday_detail_page.dart`

- [ ] **Step 1: import 추가**

파일 상단 import 블록에 추가:
```dart
import 'package:url_launcher/url_launcher.dart';
import 'package:rememberotter/shared/services/error_reporting_service.dart';
```

- [ ] **Step 2: _callBirthday 메서드 추가**

`_buildProfileSection(...)` 메서드 위(혹은 클래스 내 적절한 위치)에 추가:
```dart
  Future<void> _callBirthday(Birthday birthday) async {
    final phone = birthday.phoneNumber?.trim();
    if (phone == null || phone.isEmpty) {
      Get.snackbar(
        '전화번호 없음',
        '전화번호를 등록해주세요',
        snackPosition: SnackPosition.BOTTOM,
      );
      BirthdayFormSheet.show(birthday: birthday);
      return;
    }
    try {
      final uri = Uri(scheme: 'tel', path: phone);
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok) throw '전화 앱 실행 실패: $phone';
      AnalyticsService().logBirthdayCall();
    } catch (e, stack) {
      Get.snackbar(
        '전화 실패',
        '전화를 걸 수 없어요',
        snackPosition: SnackPosition.BOTTOM,
      );
      ErrorReportingService().reportError(e, stack);
    }
  }
```

- [ ] **Step 3: 프로필 섹션에 전화 걸기 버튼 추가 (항상 표시)**

`_buildProfileSection`의 Column children에서 D-day 뱃지 `Container` 다음에 추가 (Column 닫기 전):
```dart
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _callBirthday(birthday),
              icon: const Icon(Icons.phone_outlined, size: 20),
              label: const Text('전화 걸기'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
```

- [ ] **Step 4: 정보 섹션에 전화번호 행 추가 (번호 있을 때만)**

`_buildInfoSection`에서 나이 `_buildInfoRow` 다음(그룹 `if` 블록 앞)에 추가:
```dart
          if (birthday.phoneNumber != null && birthday.phoneNumber!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.phone_outlined,
              label: '전화번호',
              value: birthday.phoneNumber!,
            ),
          ],
```

- [ ] **Step 5: 정적 분석**

Run: `flutter analyze lib/feature/birthday/pages/birthday_detail_page.dart`
Expected: No issues found

- [ ] **Step 6: Commit**

```bash
git add lib/feature/birthday/pages/birthday_detail_page.dart
git commit -m "feat(\$birthday): 상세 페이지에 전화 걸기 버튼 추가"
```

---

## Task 9: 백업 복원 시 전화번호 보존

**Files:**
- Modify: `lib/shared/services/backup_service.dart`

- [ ] **Step 1: overwrite 모드 복원에 phoneNumber 추가**

overwrite 분기의 `BirthdaysCompanion.insert(...)`에 추가 (`groupId: Value(row.groupId),` 줄 아래):
```dart
                groupId: Value(row.groupId),
                phoneNumber: Value(row.phoneNumber),
                isLunarCalendar: Value(row.isLunarCalendar),
```

- [ ] **Step 2: merge 모드 복원에 phoneNumber 추가**

merge 분기의 `BirthdaysCompanion.insert(...)`에 동일하게 추가 (`groupId: Value(row.groupId),` 줄 아래):
```dart
                groupId: Value(row.groupId),
                phoneNumber: Value(row.phoneNumber),
                isLunarCalendar: Value(row.isLunarCalendar),
```

> `_currentSchemaVersion`은 1로 유지한다 (nullable 추가 필드는 앞뒤 호환). 내보내기는 `toJson()`이 자동 포함하므로 수정 불필요. 구버전 백업(phoneNumber 키 없음)은 `BirthdayData.fromJson`에서 null로 처리되어 안전.

- [ ] **Step 3: 정적 분석**

Run: `flutter analyze lib/shared/services/backup_service.dart`
Expected: No issues found

- [ ] **Step 4: Commit**

```bash
git add lib/shared/services/backup_service.dart
git commit -m "fix(\$backup): 복원 시 전화번호 보존"
```

---

## Task 10: 개인정보 처리방침 갱신

**Files:**
- Modify: `docs/privacy_policy.md`

- [ ] **Step 1: 연락처 수집 항목에 전화번호 추가 (제2조 1항 표)**

`| 연락처 생일 가져오기 | 연락처에 저장된 이름, 생년월일 | 단말기 연락처 접근 | 연락처 접근 권한 동의 (OS 권한 요청) |`
→ 수집 항목을 `연락처에 저장된 이름, 생년월일, 전화번호`로 변경

- [ ] **Step 2: 직접 입력 정보에 전화번호 추가 (제2조 3항)**

`이용자가 앱 내에서 직접 입력하는 생일 정보(이름, 생년월일, 메모)와 선물 기록은 이용자의 단말기(로컬 SQLite 데이터베이스)에만 저장되며, 외부 서버로 전송되지 않습니다.`
→ `(이름, 생년월일, 전화번호, 메모)`로 변경

- [ ] **Step 3: 참고 문구 수정 (제2조 3항)**

기존:
```
> **참고**: 앱은 회원가입을 요구하지 않으며, 이메일·전화번호·계정 정보를 수집하지 않습니다.
```
변경:
```
> **참고**: 앱은 회원가입을 요구하지 않으며, 이메일·계정 정보를 수집하지 않습니다. 전화번호는 이용자가 직접 입력하거나 연락처에서 가져온 경우에 한해 처리되며, 이용자의 단말기에만 로컬 저장되고 외부 서버로 전송되지 않습니다.
```

- [ ] **Step 4: 시행일 갱신**

```
- **시행일**: 2026년 6월 17일
- **이전 시행일**: 2026년 2월 21일
```

- [ ] **Step 5: Commit**

```bash
git add docs/privacy_policy.md
git commit -m "docs(\$privacy): 전화번호 수집 항목 반영"
```

---

## 최종 검증 (전체 작업 후)

- [ ] **전체 정적 분석:** `flutter analyze` → No issues found
- [ ] **전체 테스트:** `flutter test` → All tests passed
- [ ] **신규 설치 수동 확인:** 생일 추가 시 전화번호 입력·저장, 상세에서 표시·발신
- [ ] **DB 업그레이드 수동 확인:** 기존 v1 DB로 앱 실행 → 정상 기동, 기존 생일 유지(번호 null)
- [ ] **연락처 가져오기:** 번호 있는 연락처 가져오면 전화번호 저장됨
- [ ] **전화 걸기:** 번호 有 → 전화 앱 호출 / 번호 無 → 안내 스낵바 + 수정 폼
- [ ] **백업 round-trip:** 내보내기 → 복원(overwrite·merge) 시 전화번호 보존
- [ ] **구버전 백업 복원:** phoneNumber 키 없는 JSON 복원 시 에러 없이 번호 null
```
