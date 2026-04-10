# Firebase Analytics (GA) 설계 및 구현 가이드

새로운 기능을 추가할 때 이 문서를 참고하여 GA 이벤트를 설계하고 구현한다.

---

## 1. 아키텍처

### AnalyticsService

- **위치**: `lib/shared/services/analytics_service.dart`
- **패턴**: 싱글턴 (`static final _instance` + `factory`)
- **내부**: `FirebaseAnalytics.instance`를 감싸고, 각 이벤트별 public 메서드 제공
- **로깅**: 모든 이벤트에 `logger.d('[Analytics] ...')` 포함 (디버그 확인용)

```dart
// 사용법 — 어디서든 한 줄로 호출
AnalyticsService().logBirthdayAdd();
AnalyticsService().logSettingsChange(setting: 'notification_time', value: '09:00');
```

### 호출 위치 원칙

| 이벤트 성격 | 코드 삽입 위치 | 이유 |
|-----------|-------------|------|
| CRUD 완료 | **Controller** 메서드 내부 (성공 후) | 비즈니스 로직 완료 보장 |
| 폼/시트 오픈 | **Widget**의 `static show()` 메서드 | UI 진입점이 명확 |
| 설정 변경 | **Page** 내부 (값 저장 직후) | UI와 저장이 함께 일어남 |
| 시스템 이벤트 | **Service** 내부 | 알림 탭 등 UI 밖에서 발생 |

---

## 2. 이벤트 설계 원칙

### 2-1. 퍼널 기반 설계

모든 사용자 흐름을 **퍼널**로 본다. 퍼널에는 반드시 **시작점 이벤트 + 완료 이벤트**가 있어야 한다.

```
시작점 이벤트 → (사용자 행동) → 완료 이벤트
       ↓                           ↓
   100명 진입              60명 완료 = 전환율 60%, 드롭오프 40%
```

**드롭오프** = 시작점에서 완료로 넘어가지 않고 이탈한 비율. 이 수치가 높으면 해당 단계의 UX를 개선해야 한다.

새 기능을 추가할 때 자문할 것:
- 이 기능의 **시작점**은 어디인가? (버튼 클릭, 폼 오픈, 페이지 진입)
- 이 기능의 **완료**는 어디인가? (저장 성공, 전송 완료)
- 시작과 완료 사이에 **이탈 가능한 단계**가 있는가?

### 2-2. 네이밍 규칙

| 규칙 | 예시 |
|------|------|
| snake_case | `birthday_add`, `gift_form_open` |
| 40자 이내 (Firebase 제한) | O: `onboard_notification` / X: `onboarding_notification_permission_request` |
| `{대상}_{동작}` 형식 | `birthday_add`, `feedback_send` |
| 퍼널 시작점은 `_open` 접미사 | `birthday_form_open`, `feedback_form_open` |
| boolean은 문자열로 전달 | `'true'` / `'false'` (Firebase 권장) |

### 2-3. 파라미터 기준

**넣어야 하는 것:**
- 의사결정에 직접 영향을 주는 값 (mode: add/edit, count, success)
- 세그먼트 분석에 필요한 값 (setting 이름, tab 이름)

**넣지 말아야 하는 것:**
- 개인정보 (이름, 생년월일, 연락처)
- 의미 없이 상세한 값 (birthdayId, UUID)
- 동일 이벤트에 5개 이상 파라미터 (Firebase에서 분석하기 어려움)

---

## 3. 현재 구현된 이벤트 목록

### 이벤트 전체 목록 (22개)

| 이벤트명 | 파라미터 | 삽입 위치 |
|---------|---------|----------|
| `onboard_notification` | `allowed`: bool | notification_consent_page.dart |
| `onboard_contact_import` | `skipped`: bool, `count`: int | contact_import_onboarding_page.dart |
| `contact_permission_result` | `granted`: bool | contact_import_onboarding_page.dart |
| `birthday_form_open` | `mode`: add/edit | birthday_form_sheet.dart (show) |
| `birthday_add` | — | birthday_controller.dart |
| `birthday_batch_add` | `count`: int | birthday_controller.dart |
| `birthday_update` | — | birthday_controller.dart |
| `birthday_delete` | — | birthday_controller.dart |
| `birthday_search` | `result_count`: int | birthday_controller.dart (debounce 500ms) |
| `birthday_detail_view` | — | birthday_detail_page.dart |
| `gift_form_open` | `mode`: add/edit | gift_form_sheet.dart (show) |
| `gift_add` | — | gift_controller.dart |
| `gift_update` | — | gift_controller.dart |
| `gift_delete` | — | gift_controller.dart |
| `calendar_date_select` | — | calendar_page.dart |
| `tab_switch` | `tab`: calendar/friends | main_page.dart |
| `gift_stats_open` | — | main_page.dart |
| `feedback_form_open` | — | feedback_sheet.dart (show) |
| `feedback_send` | `success`: bool | feedback_sheet.dart |
| `settings_change` | `setting`: String, `value`: String | settings_page.dart |
| `notification_tap` | — | notification_service.dart |
| `easter_egg_found` | — | settings_page.dart |

### User Property (1개)

| 이름 | 값 | 설정 위치 |
|------|---|----------|
| `birthday_count_tier` | `0` / `1-5` / `6-20` / `21-50` / `51+` | birthday_controller.dart (loadBirthdays 후) |

### 퍼널 매핑

| 퍼널 | 시작 이벤트 | 완료 이벤트 | 분석 목적 |
|------|-----------|-----------|----------|
| 온보딩 (알림) | `onboard_notification` | — | 알림 허용률 |
| 온보딩 (연락처) | `contact_permission_result` | `onboard_contact_import` | 연락처 가져오기 전환율 |
| 생일 등록 | `birthday_form_open(add)` | `birthday_add` | 폼 완료율 |
| 생일 수정 | `birthday_form_open(edit)` | `birthday_update` | 수정 완료율 |
| 선물 기록 | `gift_form_open(add)` | `gift_add` | 선물 기능 채택률 |
| 캘린더 탐색 | `calendar_date_select` | `birthday_detail_view` | 캘린더→상세 전환율 |
| 피드백 | `feedback_form_open` | `feedback_send` | 피드백 작성 완료율 |
| 알림 재진입 | `notification_tap` | `birthday_detail_view` | 알림→앱 재진입률 |

---

## 4. 새 기능 추가 시 체크리스트

새 기능을 만들 때 아래 순서를 따른다:

### Step 1: 퍼널 식별

```
Q1. 사용자가 이 기능을 시작하는 진입점은? → 시작 이벤트
Q2. 이 기능의 성공적 완료 시점은?        → 완료 이벤트
Q3. 중간에 이탈 가능한 단계가 있는가?     → 중간 이벤트 (필요시)
```

### Step 2: 이벤트 정의

```
이벤트명: {대상}_{동작} (snake_case, 40자 이내)
파라미터: 의사결정에 필요한 최소한의 값만
삽입 위치: Controller / Widget show() / Service 중 택 1
```

### Step 3: AnalyticsService에 메서드 추가

```dart
void logNewFeatureAction({required String mode}) {
  _analytics.logEvent(
    name: 'new_feature_action',
    parameters: {'mode': mode},
  );
  logger.d('[Analytics] new_feature_action: mode=$mode');
}
```

### Step 4: 호출 코드 삽입

- CRUD 완료 → Controller 메서드 내 `await loadXxx()` 직후
- 폼 오픈 → Widget의 `static show()` 맨 첫 줄
- 설정 변경 → 값 저장 직후, `Navigator.pop()` 전후

### Step 5: 이 문서 업데이트

- "이벤트 전체 목록" 테이블에 추가
- 퍼널이 있다면 "퍼널 매핑" 테이블에 추가

---

## 5. 구현 패턴 예시

### 패턴 A: Controller에서 CRUD 완료 이벤트

```dart
// birthday_controller.dart
Future<void> addBirthday({...}) async {
  final birthday = await _repository.add(...);
  try {
    await _notificationService.scheduleBirthdayNotification(birthday);
  } catch (_) {}
  await loadBirthdays();
  _analyticsService.logBirthdayAdd();  // ← 성공 후 마지막에 호출
}
```

### 패턴 B: Widget static show()에서 폼 오픈 이벤트

```dart
// birthday_form_sheet.dart
static Future<void> show({Birthday? birthday, DateTime? initialDate}) {
  AnalyticsService().logBirthdayFormOpen(mode: birthday != null ? 'edit' : 'add');  // ← 첫 줄
  return Get.bottomSheet(...);
}
```

### 패턴 C: Page에서 설정 변경 이벤트

```dart
// settings_page.dart - 알림 시간 변경 확인 버튼
onPressed: () async {
  setState(() {
    _notificationTime = tempTime;
    _settingsService.notificationTime = tempTime;
  });
  Navigator.pop(context);
  AnalyticsService().logSettingsChange(  // ← 저장 직후
    setting: 'notification_time',
    value: '${tempTime.hour}:${tempTime.minute.toString().padLeft(2, '0')}',
  );
  // ...후속 로직
},
```

### 패턴 D: Service에서 시스템 이벤트

```dart
// notification_service.dart
void _onNotificationTapped(NotificationResponse response) {
  logger.i('알림 탭: ${response.payload}');
  AnalyticsService().logNotificationTap();  // ← 콜백 시작 시
  // ...후속 로직
}
```

### 패턴 E: 검색 이벤트 debounce

```dart
// analytics_service.dart 내부
void logBirthdaySearch({required int resultCount}) {
  _searchDebounce?.cancel();
  _searchDebounce = Timer(const Duration(milliseconds: 500), () {
    _analytics.logEvent(
      name: 'birthday_search',
      parameters: {'result_count': resultCount},
    );
  });
}
```

타이핑할 때마다 호출되는 검색은 debounce로 마지막 입력만 전송한다.

---

## 6. 검증 방법

### Firebase DebugView 활성화

**iOS:**
Xcode > Product > Scheme > Edit Scheme > Run > Arguments > Arguments Passed On Launch에 추가:
```
-FIRDebugEnabled
```

**Android:**
```bash
adb shell setprop debug.firebase.analytics.app com.rudqlsdla.rememberotter
```

### 확인 절차

1. 위 설정 후 앱 실행
2. Firebase Console > Analytics > **DebugView** 열기
3. 앱에서 해당 기능 수행
4. DebugView에서 이벤트명 + 파라미터 실시간 확인
5. 이벤트가 나타나지 않으면:
   - `logger.d` 콘솔 출력 확인 (호출 자체가 안 되는지)
   - Firebase 초기화 확인 (`Firebase.initializeApp()`)
   - 디버그 모드 플래그 확인

### 디버그 모드 해제

**iOS:** `-FIRDebugDisabled` 추가 또는 기존 플래그 제거
**Android:**
```bash
adb shell setprop debug.firebase.analytics.app .none.
```

---

## 7. Firebase Console 퍼널 리포트 생성

### 방법 1: Firebase Console (간단)

1. Firebase Console > Analytics > **대시보드**
2. 좌측 메뉴 > **유입경로** (Funnel)
3. "새 유입경로" 클릭
4. Step 추가:
   - Step 1: 이벤트 선택 (예: `birthday_form_open`)
   - Step 2: 이벤트 선택 (예: `birthday_add`)
5. 필요시 파라미터 필터 추가 (예: `mode = add`)
6. 저장

### 방법 2: Google Analytics (상세)

1. [analytics.google.com](https://analytics.google.com) 접속
2. 좌측 > **탐색** > "유입경로 탐색" 선택
3. 단계 설정:
   - 단계 추가 > 이벤트 선택
   - 조건 추가 가능 (파라미터 값 필터)
4. 분석 기간 설정
5. 세그먼트 비교 가능 (`birthday_count_tier` 기준 등)

### 권장 퍼널 설정

| 퍼널 이름 | Step 1 | Step 2 | Step 3 |
|----------|--------|--------|--------|
| 생일 등록 전환 | `birthday_form_open` (mode=add) | `birthday_add` | — |
| 선물 기록 전환 | `gift_form_open` (mode=add) | `gift_add` | — |
| 온보딩 완주 | `onboard_notification` | `contact_permission_result` | `onboard_contact_import` |
| 피드백 전환 | `feedback_form_open` | `feedback_send` | — |
| 캘린더→상세 | `calendar_date_select` | `birthday_detail_view` | — |

---

## 주의사항

- Firebase 이벤트 이름은 **한번 전송하면 삭제 불가** (목록에 영구 표시). 네이밍 신중하게.
- 이벤트 데이터는 Firebase Console에 **최대 24시간 지연** 반영. DebugView만 실시간.
- Firebase 무료 플랜: 이벤트 종류 최대 **500개**, 파라미터 이벤트당 **25개**까지.
- 개인정보(이름, 연락처, 생년월일 등)를 파라미터로 보내면 안 됨 (Google 정책 위반).
