# 생일인 사람에게 전화 걸기 기능 설계

- **작성일**: 2026-06-17
- **상태**: 설계 확정

## 목표

생일 상세 페이지에서 해당 인물에게 바로 전화를 걸 수 있게 한다. 앱에 전화번호 필드가 없으므로 전화번호를 저장·입력·가져오는 데이터 경로를 함께 추가한다.

## 결정 사항 (브레인스토밍 결과)

| 질문 | 결정 |
|------|------|
| 전화번호 확보 방식 | **DB/모델에 전화번호 필드 추가** (로컬에만 저장, 외부 전송 없음) |
| 전화 버튼 위치 | **생일 상세 페이지 정보 영역의 전화번호 행** (나이 아래, 번호와 함께 전화 걸기 아이콘 버튼) |
| 번호 없는 생일 처리 | **번호 있을 때만 전화번호 행/걸기 버튼 표시.** 번호 없으면 노출하지 않음 |
| 연락처 가져오기 | **전화번호도 함께 저장** |

## 비목표 (YAGNI)

- 리스트 아이템 / 푸시 알림 액션에서의 전화 걸기 (나중에 확장 가능)
- 전화번호 형식 검증·정규화 (입력값 그대로 저장, `tel:` 스킴에 전달)
- 문자(SMS)·카카오톡 등 다른 연락 수단

## 변경 범위

### 1. 데이터 계층

**`lib/data/database/app_database.dart`**
- `Birthdays` 테이블에 컬럼 추가: `TextColumn get phoneNumber => text().nullable()();`
- `schemaVersion` 1 → **2**
- `MigrationStrategy`에 `onUpgrade` 추가:
  ```dart
  onUpgrade: (m, from, to) async {
    if (from < 2) {
      await m.addColumn(birthdays, birthdays.phoneNumber);
    }
  },
  ```
- `dart run build_runner build`로 `app_database.g.dart` 재생성

**`lib/domain/models/birthday.dart`**
- `final String? phoneNumber;` 필드 + 생성자 파라미터 추가
- `copyWith`에 `String? Function()? phoneNumber` 추가 (groupId와 동일하게 null로 비울 수 있도록)

**`lib/domain/repositories/birthday_repository.dart`**
- `add()`에 `String? phoneNumber` 파라미터 추가 → `BirthdaysCompanion.insert(... phoneNumber: Value(phoneNumber))`
- 반환 `Birthday(... phoneNumber: phoneNumber)`
- `update()`의 `BirthdaysCompanion`에 `phoneNumber: Value(updated.phoneNumber)` 추가
- `_fromRow`에 `phoneNumber: row.phoneNumber` 추가

### 2. 컨트롤러

**`lib/feature/birthday/controllers/birthday_controller.dart`**
- `addBirthday(...)`에 `String? phoneNumber` 파라미터 추가 → repository로 전달
- `addBirthdayBatch` 튜플 타입을 `({String name, DateTime birthDate, String? groupId, String? phoneNumber})`로 확장 → repository `add`에 `phoneNumber` 전달

### 3. 입력 UI

**`lib/feature/birthday/widgets/birthday_form_sheet.dart`**
- `_phoneController` (TextEditingController) 추가, `initState`에서 기존 값 채우기, `dispose`에서 해제
- 메모 입력 아래에 "전화번호 (선택)" `TextFormField` 추가 (`keyboardType: TextInputType.phone`)
- `_save()`: 추가/수정 모두 `phoneNumber` 전달 (빈 문자열이면 null)
  - 추가: `controller.addBirthday(... phoneNumber: ...)`
  - 수정: `widget.birthday!.copyWith(phoneNumber: () => ...)`

**`lib/feature/contact/controllers/contact_import_controller.dart`**
- 헬퍼 추가: `String? getPhone(Contact c) => c.phones.firstOrNull?.number;`
- `importSelected()`의 `toImport` 튜플에 `phoneNumber: getPhone(contact)` 포함

### 4. 전화 걸기 UI

**`lib/feature/birthday/pages/birthday_detail_page.dart`**
- 프로필 섹션(`_buildProfileSection`) D-day 뱃지 아래에 "전화 걸기" 버튼 **항상 표시**
- 버튼 탭 동작:
  - `birthday.phoneNumber`가 있으면 → `url_launcher`의 `launchUrl(Uri(scheme: 'tel', path: number), mode: LaunchMode.externalApplication)`. 실패 시 `try/catch` → 스낵바("전화를 걸 수 없어요") + `ErrorReportingService().reportError`
  - 없으면 → 스낵바("전화번호를 등록해주세요") 후 `BirthdayFormSheet.show(birthday: birthday)` 열기
- 정보 섹션(`_buildInfoSection`): `phoneNumber`가 있으면 `Icons.phone_outlined` 행 추가
- `AnalyticsService().logBirthdayCall()` 호출 (실제 발신 시)

**`lib/shared/services/analytics_service.dart`**
- `logBirthdayCall()` 이벤트 메서드 추가 (기존 이벤트 로깅 패턴 따름)

### 5. 백업 (JSON 내보내기/복원)

> CLAUDE.md에는 백업이 "미구현"으로 적혀 있으나 실제로는 `BackupService`로 구현되어 있음. (CLAUDE.md는 별도로 갱신 필요 — 이번 작업 범위 밖, 사용자에게 보고)

**`lib/shared/services/backup_service.dart`**
- **내보내기**: `BirthdayData.toJson()` 사용 → 재생성 후 phoneNumber 자동 포함. **수정 불필요**
- **복원 (필수 수정)**: `restoreBackup()`의 `BirthdaysCompanion.insert(...)`가 필드를 명시 나열함. **overwrite·merge 두 분기 모두**에 `phoneNumber: Value(row.phoneNumber)` 추가. (누락 시 복원 때 전화번호 유실)
- **`_currentSchemaVersion`은 1로 유지** — nullable 필드 추가는 앞뒤 호환. 올리면 구버전 앱이 신규 백업을 통째로 거부하게 되어 UX 악화

**호환성 검증 (사람이 작성한 백업 데이터로 확인)**
- 구버전 백업(phoneNumber 키 없음) → 신규 앱 복원: `BirthdayData.fromJson`에서 키 부재 → `null` (nullable이라 안전)
- 신규 백업 → 구버전 앱 복원: 구버전은 phoneNumber 키 무시, 나머지 정상 복원 (전화번호만 유실, 허용 가능)

### 6. 개인정보 처리방침

**`docs/privacy_policy.md`**
- 제2조 1항 표: "연락처 생일 가져오기" 수집 항목을 `이름, 생년월일` → `이름, 생년월일, 전화번호`로 수정
- 제2조 3항: 직접 입력 정보 목록(이름·생년월일·메모)에 전화번호 추가
- 제2조 3항 참고 문구: "…이메일·전화번호·계정 정보를 수집하지 않습니다" 문장에서 전화번호 부분 수정 — 전화번호는 이용자 단말기에만 로컬 저장하며 외부 서버로 전송하지 않음을 명시
- 시행일 갱신 (시행일 → 2026-06-17, 이전 시행일 → 2026-02-21)
- 제4조(제3자 제공)·제5조(위탁)·제6조(국외 이전)·제9조(안전성)·제11조(민감정보)는 **변경 없음** — 전화번호가 기기 밖으로 나가지 않으므로

## 데이터 흐름

```
[입력]
폼 입력 / 연락처 가져오기 → BirthdayController → BirthdayRepository → SQLite(phoneNumber)

[발신]
상세 페이지 "전화 걸기" 탭
  → 번호 有: url_launcher tel:번호 → 시스템 전화 앱
  → 번호 無: 스낵바 안내 → 수정 폼
```

## 마이그레이션 안전성

- 기존 사용자 DB는 `phoneNumber` 없이 존재 → `onUpgrade`로 nullable 컬럼 추가, 기존 행은 `null`
- 기존 생일은 상세에서 "전화 걸기" 탭 시 등록 유도 흐름으로 자연스럽게 번호 추가 가능

## 검증 기준

1. `dart run build_runner build` 성공, 컴파일 에러 없음
2. 신규 설치: 생일 추가 시 전화번호 입력·저장·재조회 확인
3. 기존 DB 업그레이드(schema 1→2): 앱 정상 실행, 기존 생일 유지, 번호 null
4. 연락처 가져오기: 번호 있는 연락처 가져오면 전화번호 저장됨
5. 상세 페이지: 번호 有 → 전화 앱 호출 / 번호 無 → 안내 후 수정 폼
6. 백업 내보내기 → 복원(overwrite·merge): 전화번호 보존 확인
7. 구버전 백업(phoneNumber 키 없는 JSON) 복원: 에러 없이 번호 null로 복원
8. 개인정보 처리방침 문구 일관성 확인
```
