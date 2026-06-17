# 기억해달 (RememberOtter) 프로젝트 문서

## 프로젝트 개요
생일 관리 캘린더 앱. 소중한 사람들의 생일을 기록하고, 그룹으로 분류하며, 선물 교환 여부 및 금액을 추적하고, 푸시 알림과 홈 화면 위젯으로 생일을 놓치지 않도록 도와준다.

## 브랜딩 & 캐릭터

### 앱 이름
**기억해달** = "기억해달라" + "해달(Sea Otter)"의 언어유희

### 마스코트: 해달 (Sea Otter)
해달은 **좋아하는 돌을 평생 간직하는** 습성이 있다. 이 컨셉을 "소중한 사람의 생일을 간직"하는 앱과 연결.

| 습성 | 앱 연결 | 활용 |
|------|---------|------|
| 돌을 평생 간직 | 생일을 잊지 않고 기억 | 핵심 컨셉 |
| 잠잘 때 손 잡고 잠 | 소중한 사람과의 연결 | 빈 화면 일러스트 |
| 배 위에 조개 올려놓음 | 생일 정보를 정리 보관 | 리스트 화면 |

#### 캐릭터 디자인 가이드
- **스타일**: 스티커 일러스트 (흰 외곽선, 파스텔 톤)
- **메인 컬러**: 라벤더 보라색 (#B8A3E6)
- **포인트 컬러**: 핑크 (#EC4899)
- **표정**: 동글동글, 친근한 미소, 반짝이는 눈

#### OtterImage 위젯
`lib/shared/widgets/otter_image.dart` — 이미지 로드 실패 시 placeholder 아이콘 표시.

```dart
OtterImage(type: OtterType.empty, size: 120)
```

| OtterType | 용도 | 이미지 경로 | Placeholder 아이콘 |
|-----------|------|-------------|-------------------|
| splash | 스플래시 화면 | `splash/splash_otter.png` | Icons.pets |
| empty | 빈 목록 | `common/otter_empty.png` | Icons.cake_outlined |
| celebrate | 생일 축하 | `common/otter_celebrate.png` | Icons.celebration |
| gift | 선물 기록 | `common/otter_gift.png` | Icons.card_giftcard |
| error | 에러 상태 | `common/otter_error.png` | Icons.error_outline |
| wave | 인사/업데이트 | `common/otter_wave.png` | Icons.waving_hand |

기타 이미지: `common/icon_otter.png` (소형 아이콘), `logo/app_icon.png` (앱 아이콘)

## 기술 스택

| 분류 | 패키지 | 버전 |
|------|--------|------|
| Framework | Flutter | 3.8.1+ |
| State Management | GetX | ^4.7.2 |
| UI | flutter_screenutil | ^5.9.3 |
| Database | drift | ^2.24.0 |
| | sqlite3_flutter_libs | ^0.5.28 |
| | path, path_provider | |
| Local Storage | shared_preferences | ^2.3.4 |
| Firebase | firebase_core | ^3.13.0 |
| | firebase_remote_config | ^5.3.0 |
| | firebase_analytics | ^11.4.0 |
| | cloud_firestore | ^5.6.0 |
| Push Notification | flutter_local_notifications | ^18.0.1 |
| Timezone | timezone, flutter_timezone | ^0.10.0 / ^3.0.1 |
| Contacts | flutter_contacts | ^1.1.9+2 |
| Permission | permission_handler | ^12.0.1 |
| Home Widget | home_widget | ^0.7.0 |
| HTTP | http | ^1.2.2 |
| Device Info | device_info_plus | ^11.1.0 |
| App Info | package_info_plus | ^8.0.0 |
| URL | url_launcher | ^6.3.1 |
| Logging | logger | ^2.6.0 |
| UUID | uuid | ^4.5.1 |

**Dev Dependencies**: drift_dev, build_runner, flutter_gen_runner, flutter_launcher_icons, flutter_oss_licenses

## 프로젝트 구조

```
lib/
├── app/
│   ├── app_bindings.dart             # GetX 글로벌 바인딩 (Group, Birthday, Gift)
│   ├── app_constants.dart            # 상수 (appName 등)
│   ├── app_pages.dart                # 라우트 → 페이지 매핑
│   └── app_routes.dart               # 라우트 이름 정의
│
├── data/
│   └── database/
│       ├── app_database.dart         # Drift 테이블 정의 & DB 설정
│       ├── app_database.g.dart       # 생성 코드
│       └── seed_data.dart            # 더미 데이터 (테스트용)
│
├── design_system/
│   └── variable/app_colors.dart      # 색상 팔레트
│
├── domain/
│   ├── models/
│   │   ├── birthday.dart             # 생일 모델 (groupId, computed properties)
│   │   ├── gift.dart                 # 선물 모델 (금액 포함)
│   │   └── group.dart                # 그룹 모델
│   └── repositories/
│       ├── birthday_repository.dart
│       ├── gift_repository.dart
│       └── group_repository.dart
│
├── feature/
│   ├── splash/pages/splash_page.dart
│   ├── main/pages/main_page.dart               # 탭 (캘린더/생일) + 그룹 필터
│   ├── calendar/
│   │   ├── pages/calendar_page.dart
│   │   └── widgets/
│   │       ├── month_calendar_widget.dart
│   │       └── date_birthday_sheet.dart
│   ├── birthday/
│   │   ├── controllers/birthday_controller.dart
│   │   ├── pages/birthday_detail_page.dart
│   │   └── widgets/
│   │       ├── birthday_form_sheet.dart
│   │       └── birthday_list_item.dart
│   ├── gift/
│   │   ├── controllers/gift_controller.dart
│   │   └── widgets/
│   │       ├── gift_form_sheet.dart
│   │       ├── gift_history_section.dart
│   │       ├── gift_list_item.dart
│   │       ├── gift_statistics_sheet.dart      # 선물 금액 통계
│   │       └── shopping_link_section.dart      # 쇼핑 링크 추천
│   ├── group/
│   │   ├── controllers/group_controller.dart
│   │   ├── pages/group_management_page.dart
│   │   └── widgets/group_form_sheet.dart
│   ├── contact/
│   │   ├── controllers/contact_import_controller.dart
│   │   ├── pages/contact_import_page.dart
│   │   └── widgets/contact_list_item.dart
│   ├── onboarding/pages/
│   │   ├── notification_consent_page.dart
│   │   └── contact_import_onboarding_page.dart
│   └── settings/
│       ├── pages/
│       │   ├── settings_page.dart
│       │   └── oss_licenses_page.dart
│       └── widgets/feedback_sheet.dart
│
├── shared/
│   ├── log/logger.dart
│   ├── services/
│   │   ├── notification_service.dart       # 푸시 알림 스케줄링
│   │   ├── settings_service.dart           # 앱 설정 (SharedPreferences)
│   │   ├── remote_config_service.dart      # Firebase Remote Config
│   │   ├── feedback_service.dart           # 디스코드 웹훅 피드백
│   │   ├── contact_service.dart            # 연락처 권한 & 조회
│   │   ├── analytics_service.dart          # Firebase Analytics 이벤트
│   │   ├── error_reporting_service.dart    # 에러 → 디스코드 웹훅
│   │   ├── shopping_link_service.dart      # Firestore에서 쇼핑 링크 관리
│   │   └── widget_service.dart             # 홈 화면 위젯 데이터 동기화
│   ├── utils/price_formatter.dart
│   └── widgets/
│       ├── otter_image.dart
│       ├── update_bottom_sheet.dart
│       ├── input_amount_sheet.dart
│       ├── date_picker_spinner.dart
│       ├── time_picker_spinner.dart
│       └── year_picker_spinner.dart
│
├── gen/
│   ├── assets.gen.dart               # flutter_gen 자동 생성
│   └── fonts.gen.dart
│
├── firebase_options.dart             # FlutterFire CLI 자동 생성
├── oss_licenses.dart                 # 자동 생성
└── main.dart                         # 진입점
```

### 네이티브 위젯
- iOS: `ios/BirthdayWidget/` (WidgetKit)
- Android: `android/app/src/main/kotlin/com/rudqlsdla/rememberotter/widget/BirthdayWidgetProvider.kt`
- App Group: `group.com.rudqlsdla.rememberotter`

## 앱 초기화 순서 (main.dart)

1. `WidgetsFlutterBinding.ensureInitialized()`
2. 글로벌 에러 핸들러 등록 (`FlutterError.onError`, `PlatformDispatcher.instance.onError`) → `ErrorReportingService`로 전송
3. `Firebase.initializeApp()`
4. `RemoteConfigService().initialize()`
5. `ShoppingLinkService().initialize()` — Firestore `config/shopping_links` 읽기
6. `SettingsService().initialize()`
7. `AppDatabase.instance` — Drift SQLite
8. `NotificationService().initialize()`
9. `WidgetService().initialize()` — iOS App Group 설정
10. `SystemChrome.setPreferredOrientations([portraitUp])`

`GetMaterialApp`은 `FirebaseAnalyticsObserver`와 `routeObserver`를 navigatorObservers에 등록.

## 라우트

| 경로 | 페이지 | 설명 |
|------|--------|------|
| `/splash` | SplashPage | 애니메이션 스플래시 + 버전 체크 |
| `/onboarding/notification-consent` | NotificationConsentPage | 알림 권한 요청 (최초 1회) |
| `/onboarding/contact-import` | ContactImportOnboardingPage | 연락처 가져오기 (최초, 선택) |
| `/main` | MainPage | 메인 (캘린더 + 생일 탭) |
| `/birthday/detail` | BirthdayDetailPage | 생일 상세 (birthdayId 인자) |
| `/settings` | SettingsPage | 설정 |
| `/settings/oss-licenses` | OssLicensesPage | 오픈소스 라이선스 |
| `/settings/groups` | GroupManagementPage | 그룹 관리 (추가/수정/삭제/순서) |
| `/contact/import` | ContactImportPage | 연락처 가져오기 (설정에서 접근) |

## 온보딩 플로우

```
SplashPage → (최초 실행 시) NotificationConsentPage → ContactImportOnboardingPage → MainPage
           → (재실행 시) MainPage
```

## 데이터베이스 (Drift/SQLite)

`lib/data/database/app_database.dart` — 싱글턴, `rememberotter.db`, schemaVersion = 1, `PRAGMA foreign_keys = ON`.
최초 생성 시 기본 그룹 자동 삽입 (가족/친구/직장/기타).

### Groups 테이블
| 컬럼 | 타입 | 비고 |
|------|------|------|
| id | TEXT (PK) | 기본: family, friends, work, etc |
| name | TEXT | |
| colorValue | INT | ARGB (예: 0xFFEF4444) |
| sortOrder | INT | |
| createdAt | DATETIME | |
| updatedAt | DATETIME | |

### Birthdays 테이블
| 컬럼 | 타입 | 비고 |
|------|------|------|
| id | TEXT (PK) | UUID v4 |
| name | TEXT | |
| birthDate | DATETIME | |
| memo | TEXT? | |
| profileImage | TEXT? | 미구현 |
| groupId | TEXT? | → Groups.id |
| isLunarCalendar | BOOL | 음력 생일 여부 (true면 birthDate를 음력 Y/M/D로 저장) |
| notificationEnabled | BOOL | 기본 true |
| notificationDaysBefore | INT | 기본 1 |
| createdAt | DATETIME | |
| updatedAt | DATETIME | |

### Gifts 테이블
| 컬럼 | 타입 | 비고 |
|------|------|------|
| id | TEXT (PK) | UUID v4 |
| birthdayId | TEXT (FK) | → Birthdays.id |
| year | INT | |
| given | BOOL | |
| received | BOOL | |
| givenGiftName | TEXT? | |
| givenGiftPrice | INT? | |
| receivedGiftName | TEXT? | |
| receivedGiftPrice | INT? | |
| memo | TEXT? | |
| createdAt | DATETIME | |
| updatedAt | DATETIME | |

## 도메인 모델 Computed Properties

### Birthday
- `thisYearBirthday` — 올해 생일 날짜
- `daysUntilBirthday` — D-day (0=오늘)
- `age` — 만 나이
- `yearAge` — 연 나이 (현재 연도 - 출생 연도)
- `ageText` — SettingsService 설정에 따라 포맷

### Gift
- `exchangeStatus` — "서로 교환" | "선물함" | "받음" | "기록 없음"

### Group
- `color` — colorValue를 Flutter Color로 변환

## 서비스

### NotificationService (싱글턴)
- 로컬 푸시 알림 스케줄링 (flutter_local_notifications + timezone)
- iOS 64개 알림 제한 대응 (daysUntilBirthday 순 우선 스케줄)
- 알림 탭 시 해당 생일 상세 페이지로 이동
- 콜드 스타트 알림 처리

### SettingsService (싱글턴, SharedPreferences)
- `notificationDaysBefore` (기본 1), `notificationHour` (기본 9), `notificationMinute` (기본 0)
- `useInternationalAge` (기본 true) — 만 나이 vs 연 나이
- 정적 옵션: `notificationDaysOptions = [0, 1, 3, 7]`

### RemoteConfigService (싱글턴, Firebase)
- 앱 업데이트 상태 판단: `UpdateStatus { none, soft, hard }`
- Remote Config 키: `hard_latest_version`, `soft_latest_version`, `latest_version`, `feedback_webhook_url`
- 시맨틱 버전 비교
- 스토어 URL: iOS `apps.apple.com/app/6758571069`, Android `play.google.com/...com.rudqlsdla.rememberotter`

### ShoppingLinkService (싱글턴, Firestore)
- `config/shopping_links` 도큐먼트에서 1회 읽기
- 키: `kakao_shopping_url`, `naver_shopping_url`, `coupang_shopping_url`, `default_shopping_query`
- 실패 시 기본값 사용 (네이버/카카오/쿠팡 검색 URL)

### WidgetService (싱글턴, home_widget)
- App Group: `group.com.rudqlsdla.rememberotter`
- iOS: `BirthdayWidget`, Android: `BirthdayWidgetProvider`
- `updateWidgetData()` — D-day 상위 3개 생일을 JSON으로 저장 후 위젯 업데이트
- `BirthdayController.loadBirthdays()`에서 자동 호출

### AnalyticsService (싱글턴, Firebase Analytics)
- 온보딩, 생일/선물/그룹 CRUD, 탭 전환, 통계 열람, 위젯 업데이트 등 주요 이벤트 로깅
- 검색은 debounce 처리
- `setUserBirthdayCount()`로 유저 프로퍼티 설정

### ErrorReportingService (싱글턴)
- Flutter/비동기 에러를 디스코드 웹훅으로 전송
- `kDebugMode`에서는 전송하지 않음
- 레이트 리미팅 (동일 에러 중복 방지, 분당 횟수 제한)
- 기기 정보 footer 포함

### FeedbackService (싱글턴)
- 디스코드 웹훅으로 사용자 피드백 전송 (URL은 Remote Config에서)
- 기기 정보 수집 (device_info_plus): 버전, OS, 기기 모델

### ContactService (싱글턴)
- flutter_contacts로 연락처 조회 (생일 이벤트 있는 것만)
- 권한 관리 (요청, 확인, 설정 열기)

## 컨트롤러

### GroupController (GetX, fenix: true)
- `groups` — 전체 그룹 (sortOrder 순)
- `getGroupById()`, `addGroup()`, `updateGroup()`, `deleteGroup()`, `reorderGroups()`

### BirthdayController (GetX, fenix: true)
- `birthdays` — 전체 목록 (D-day 순 정렬)
- `upcomingBirthdays` — 30일 이내
- `selectedDate`, `selectedDateBirthdays` — 캘린더 선택
- `selectedGroupFilter`, `showUngroupedOnly`, `filteredBirthdays` — 그룹 필터링
- `isLoaded` — 초기 로드 완료 플래그
- `addBirthdayBatch()` — 연락처 대량 가져오기
- `updateAllNotificationDaysBefore()` — 설정 변경 시 일괄 업데이트
- CRUD + 알림 자동 스케줄/취소 + 위젯 데이터 업데이트

### GiftController (GetX, fenix: true)
- `gifts` — 전체 선물 목록
- 생일별, 연도별 조회
- 금액 통계 (총 준/받은 금액)
- CRUD + 생일 삭제 시 연쇄 삭제

### ContactImportController (GetX)
- 연락처 목록 조회, 검색, 선택
- 중복 감지 (이름+월+일 키)
- 생일 없는 연락처에 수동 날짜 입력
- 선택 항목 대량 가져오기

## 색상 팔레트 (AppColors)

```dart
primary: #B8A3E6        // 라벤더 (메인)
primaryLight: #D4C5F0
primaryDark: #9681D3
accent: #EC4899         // 핑크 (생일 강조)

background: #F9FAFB
surface: #FFFFFF
surfaceVariant: #F3F4F6

textPrimary: #111827
textSecondary: #6B7280
textTertiary: #9CA3AF

success: #10B981
error: #EF4444
warning: #F59E0B

calendarWeekend: #EF4444
calendarDisabled: #D1D5DB
border: #E5E7EB
divider: #F3F4F6
```

`AppColors.op(Color, double)` — withOpacity 대체 유틸

## 코딩 컨벤션

- **상태관리**: GetX (Controller + Obx)
- **폴더구조**: feature 단위 분리
- **색상**: `AppColors` 클래스만 사용
- **반응형**: flutter_screenutil (.w, .h, .sp)
- **DB**: Drift ORM (Repository 패턴)
- **서비스**: 싱글턴 패턴 (factory constructor)
- **Opacity**: `AppColors.op()` 사용 (withOpacity 사용 금지)
- **코드 생성**: `dart run build_runner build` (Drift, flutter_gen)
- **폰트**: 메이플스토리체 (Light 300, Bold 700)
- **에러 처리**: try/catch에서 `ErrorReportingService().reportError(e, stack)` 호출
- **이벤트 로깅**: 주요 유저 액션은 `AnalyticsService` 메서드 호출

## 구현 완료 기능

- [x] 생일 CRUD + 무한 스크롤 캘린더 + D-day/나이 계산
- [x] 음력 생일 (양/음 구분, 평달 기준 매년 양력 변환, 양↔음 입력 변환, `lib/shared/utils/lunar_converter.dart`)
- [x] 그룹 기능 (가족/친구/직장/기타 기본 제공, 커스텀 추가, 색상/순서, 필터링)
- [x] 선물 CRUD + 연도별 히스토리 + 준/받은 구분 + **금액 기록** + **통계 시트**
- [x] 쇼핑 링크 추천 (네이버/카카오/쿠팡, Firestore 관리)
- [x] 로컬 푸시 알림 (커스텀 시간/일수, iOS 64개 제한 대응)
- [x] 홈 화면 위젯 (iOS WidgetKit + Android AppWidget, D-day 상위 3개)
- [x] 연락처에서 생일 가져오기 (권한 관리, 중복 감지, 수동 입력)
- [x] 온보딩 플로우 (알림 권한 → 연락처 가져오기)
- [x] Firebase Remote Config 업데이트 체커 (soft/hard)
- [x] Firebase Analytics 상세 이벤트 로깅
- [x] 디스코드 웹훅 피드백
- [x] 디스코드 웹훅 에러 리포팅 (레이트 리미팅 포함)
- [x] 설정 (알림, 나이 표시, 그룹 관리, 연락처 가져오기, 피드백, 버전, OSS)
- [x] 애니메이션 스플래시 화면
- [x] OtterImage 위젯 + 실제 캐릭터 이미지 (splash, empty, celebrate, gift, error, wave)

## 미구현

- [ ] 프로필 이미지 업로드 (DB 필드 있음)
- [ ] 다크모드
- [ ] iCloud/Google Drive 백업
