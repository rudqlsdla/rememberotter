# 기억해달 (RememberOtter)

소중한 사람들의 생일을 기록하고 관리하는 캘린더 앱. 선물 교환 내역을 추적하고, 푸시 알림으로 생일을 놓치지 않도록 도와줍니다.

> **"기억해달"** = "기억해달라" + "해달(Sea Otter)"의 언어유희.
> 해달이 좋아하는 돌을 평생 간직하듯, 소중한 사람의 생일을 잊지 않고 간직합니다.

<p align="center">
  <a href="https://apps.apple.com/app/6758571069">
    <img src="https://img.shields.io/badge/App_Store-0D96F6?style=for-the-badge&logo=app-store&logoColor=white" alt="App Store" />
  </a>
  <a href="https://play.google.com/store/apps/details?id=com.rudqlsdla.rememberotter">
    <img src="https://img.shields.io/badge/Google_Play-414141?style=for-the-badge&logo=google-play&logoColor=white" alt="Google Play" />
  </a>
</p>

## 주요 기능

- **생일 관리** — CRUD + 무한 스크롤 캘린더 + D-day/나이 자동 계산
- **선물 기록** — 연도별 히스토리, 준/받은 선물 구분
- **로컬 푸시 알림** — 커스텀 시간/일수 설정, iOS 64개 알림 제한 자동 대응
- **연락처 가져오기** — 디바이스 연락처에서 생일 정보 일괄 가져오기 (중복 감지)
- **온보딩 플로우** — 알림 권한 → 연락처 가져오기 (최초 1회)
- **앱 업데이트 체커** — Firebase Remote Config 기반 soft/hard 업데이트 안내
- **피드백** — 디스코드 웹훅 연동

---

## 목차

- [기술 스택](#기술-스택)
- [사전 요구사항](#사전-요구사항)
- [시작하기](#시작하기)
- [아키텍처 개요](#아키텍처-개요)
- [데이터베이스 스키마](#데이터베이스-스키마)
- [서비스 레이어](#서비스-레이어)
- [라우팅](#라우팅)
- [디자인 시스템](#디자인-시스템)
- [코드 생성](#코드-생성)
- [사용 가능한 명령어](#사용-가능한-명령어)
- [배포](#배포)
- [트러블슈팅](#트러블슈팅)

---

## 기술 스택

| 분류 | 기술 | 버전 |
|------|------|------|
| **프레임워크** | Flutter | 3.8.1+ |
| **언어** | Dart | ^3.8.1 |
| **상태관리** | GetX | ^4.7.2 |
| **반응형 UI** | flutter_screenutil | ^5.9.3 |
| **데이터베이스** | Drift (SQLite) | ^2.24.0 |
| **로컬 저장소** | SharedPreferences | ^2.3.4 |
| **Firebase** | Core, Remote Config, Analytics | 3.13.0+ |
| **푸시 알림** | flutter_local_notifications | ^18.0.1 |
| **연락처** | flutter_contacts | ^1.1.9+2 |
| **폰트** | 메이플스토리체 (Light 300, Bold 700) | - |

---

## 사전 요구사항

- **Flutter SDK** 3.8.1 이상 ([설치 가이드](https://docs.flutter.dev/get-started/install))
- **Dart SDK** 3.8.1 이상 (Flutter SDK에 포함)
- **Xcode** 15+ (iOS/macOS 빌드 시)
- **Android Studio** 또는 **Android SDK** (Android 빌드 시)
- **CocoaPods** (iOS 의존성 관리)
- **Firebase 프로젝트** (이미 설정 완료, `firebase_options.dart` 포함)

Flutter 설치 확인:

```bash
flutter doctor
```

모든 항목에 체크마크가 표시되는지 확인하세요.

---

## 시작하기

### 1. 저장소 클론

```bash
git clone https://github.com/rudqlsdla/rememberotter.git
cd rememberotter
```

### 2. Flutter 의존성 설치

```bash
flutter pub get
```

### 3. 코드 생성 실행

Drift(DB), flutter_gen(에셋/폰트), OSS 라이선스 코드를 생성합니다.

```bash
dart run build_runner build --delete-conflicting-outputs
```

생성되는 파일:
- `lib/data/database/app_database.g.dart` — Drift ORM 코드
- `lib/gen/assets.gen.dart` — 에셋 경로 상수
- `lib/gen/fonts.gen.dart` — 폰트 패밀리 상수
- `lib/oss_licenses.dart` — 오픈소스 라이선스 목록

### 4. iOS 의존성 설치 (iOS 빌드 시)

```bash
cd ios && pod install && cd ..
```

### 5. 앱 실행

```bash
# iOS 시뮬레이터
flutter run -d ios

# Android 에뮬레이터
flutter run -d android

# macOS
flutter run -d macos
```

---

## 아키텍처 개요

### 프로젝트 구조

```
lib/
├── main.dart                         # 앱 진입점 + 초기화 순서
├── firebase_options.dart             # FlutterFire CLI 자동 생성
├── oss_licenses.dart                 # 오픈소스 라이선스 (자동 생성)
│
├── app/                              # 앱 설정
│   ├── app_bindings.dart             # GetX 글로벌 의존성 주입
│   ├── app_constants.dart            # 앱 이름, 외부 링크 등 상수
│   ├── app_pages.dart                # 라우트 → 페이지 매핑
│   └── app_routes.dart               # 라우트 경로 상수
│
├── data/                             # 데이터 계층
│   └── database/
│       ├── app_database.dart         # Drift 테이블 정의 + 싱글턴 DB
│       └── app_database.g.dart       # Drift 자동 생성 코드
│
├── design_system/                    # 디자인 토큰
│   └── variable/
│       └── app_colors.dart           # 색상 팔레트
│
├── domain/                           # 도메인 계층
│   ├── models/
│   │   ├── birthday.dart             # Birthday 모델 (computed properties)
│   │   └── gift.dart                 # Gift 모델
│   └── repositories/
│       ├── birthday_repository.dart  # 생일 CRUD
│       └── gift_repository.dart      # 선물 CRUD
│
├── feature/                          # 기능별 모듈
│   ├── splash/                       # 스플래시 화면
│   ├── main/                         # 메인 탭 (캘린더 + 친구)
│   ├── calendar/                     # 무한 스크롤 캘린더
│   ├── birthday/                     # 생일 관리 (Controller + 상세 + 폼)
│   ├── gift/                         # 선물 관리
│   ├── contact/                      # 연락처 가져오기
│   ├── onboarding/                   # 온보딩 (알림 권한 + 연락처)
│   └── settings/                     # 설정
│
├── shared/                           # 공유 코드
│   ├── log/logger.dart               # Logger 유틸
│   ├── services/                     # 싱글턴 서비스 (알림, 설정, Remote Config 등)
│   └── widgets/                      # 공통 위젯 (OtterImage, Picker 등)
│
└── gen/                              # flutter_gen 자동 생성
    ├── assets.gen.dart
    └── fonts.gen.dart
```

### 앱 초기화 순서

`main.dart`에서 다음 순서로 초기화됩니다:

```
WidgetsFlutterBinding.ensureInitialized()
        │
        ▼
Firebase.initializeApp()          ← Firebase Core 초기화
        │
        ▼
RemoteConfigService.initialize()  ← Remote Config fetch & activate
        │
        ▼
SettingsService.initialize()      ← SharedPreferences 로드
        │
        ▼
AppDatabase.instance              ← Drift SQLite 싱글턴
        │
        ▼
NotificationService.initialize()  ← 타임존 + 알림 플러그인 + 콜드스타트 처리
        │
        ▼
SystemChrome (portraitUp only)    ← 세로 모드 고정
        │
        ▼
runApp(MyApp())                   ← ScreenUtilInit + GetMaterialApp 시작
```

### 온보딩 플로우

```
SplashPage ──(최초 실행)──▶ NotificationConsentPage ──▶ ContactImportOnboardingPage ──▶ MainPage
     │
     └──(재실행)──▶ MainPage
```

### 데이터 흐름

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   UI Layer   │     │   Controller │     │  Repository  │
│ (Pages +     │◄───▶│  (GetX Rx)   │◄───▶│  (Drift DAO) │
│  Widgets)    │     │              │     │              │
└──────────────┘     └──────────────┘     └──────┬───────┘
                                                  │
                                                  ▼
                                          ┌──────────────┐
                                          │   SQLite DB  │
                                          │ rememberotter │
                                          │    .db       │
                                          └──────────────┘
```

- **UI 계층**: `Obx()` 위젯으로 반응형 렌더링
- **Controller**: `GetxController`에서 `RxList`로 상태 관리, Repository 호출
- **Repository**: Drift ORM으로 SQLite CRUD
- **Services**: 싱글턴 패턴, 알림/설정/Firebase 등 앱 인프라 담당

---

## 데이터베이스 스키마

Drift ORM 사용, 파일명 `rememberotter.db`, 스키마 버전 1.

### Birthdays 테이블

| 컬럼 | 타입 | 기본값 | 설명 |
|------|------|--------|------|
| `id` | TEXT (PK) | UUID v4 | 고유 식별자 |
| `name` | TEXT | - | 이름 |
| `birthDate` | DATETIME | - | 생년월일 |
| `memo` | TEXT? | null | 메모 |
| `profileImage` | TEXT? | null | 프로필 이미지 (미구현) |
| `isLunarCalendar` | BOOL | false | 음력 여부 (deprecated) |
| `notificationEnabled` | BOOL | true | 알림 활성화 |
| `notificationDaysBefore` | INT | 1 | 며칠 전 알림 |
| `createdAt` | DATETIME | - | 생성일 |
| `updatedAt` | DATETIME | - | 수정일 |

### Gifts 테이블

| 컬럼 | 타입 | 기본값 | 설명 |
|------|------|--------|------|
| `id` | TEXT (PK) | UUID v4 | 고유 식별자 |
| `birthdayId` | TEXT (FK) | - | Birthdays.id 참조 |
| `year` | INT | - | 선물 교환 연도 |
| `given` | BOOL | false | 선물 줬는지 |
| `received` | BOOL | false | 선물 받았는지 |
| `givenGiftName` | TEXT? | null | 준 선물 이름 |
| `receivedGiftName` | TEXT? | null | 받은 선물 이름 |
| `memo` | TEXT? | null | 메모 |
| `createdAt` | DATETIME | - | 생성일 |
| `updatedAt` | DATETIME | - | 수정일 |

### Computed Properties

**Birthday 모델:**
- `thisYearBirthday` — 올해 생일 날짜
- `daysUntilBirthday` — D-day (0=오늘)
- `age` — 만 나이
- `yearAge` — 연 나이 (현재 연도 - 출생 연도)
- `ageText` — 설정에 따른 나이 표시 텍스트

**Gift 모델:**
- `exchangeStatus` — "서로 교환" | "선물함" | "받음" | "기록 없음"

---

## 서비스 레이어

모든 서비스는 싱글턴 패턴(factory constructor)으로 구현되어 있습니다.

### NotificationService

로컬 푸시 알림 스케줄링을 담당합니다.

- `flutter_local_notifications` + `timezone` 패키지 사용
- iOS 64개 알림 제한 자동 대응 (D-day 순 우선 스케줄)
- 알림 탭 → 해당 생일 상세 페이지로 딥링크
- 앱 콜드 스타트 시 알림 페이로드 처리

### SettingsService

SharedPreferences 기반 앱 설정 관리.

| 설정 키 | 기본값 | 설명 |
|---------|--------|------|
| `notificationDaysBefore` | 1 | 생일 며칠 전 알림 |
| `notificationHour` | 9 | 알림 시각 (시) |
| `notificationMinute` | 0 | 알림 시각 (분) |
| `useInternationalAge` | true | 만 나이(true) vs 연 나이(false) |

### RemoteConfigService

Firebase Remote Config 기반 앱 업데이트 상태 판단.

| Remote Config 키 | 설명 |
|-------------------|------|
| `hard_latest_version` | 강제 업데이트 최소 버전 |
| `soft_latest_version` | 권장 업데이트 최소 버전 |
| `latest_version` | 최신 버전 |
| `feedback_webhook_url` | 디스코드 웹훅 URL |

업데이트 상태: `none` | `soft` | `hard`

### FeedbackService

디스코드 웹훅으로 사용자 피드백 전송. 기기 정보(OS, 버전, 모델) 자동 첨부.

### ContactService

디바이스 연락처에서 생일 정보가 있는 항목만 조회. 권한 요청/확인/설정 열기 지원.

---

## 라우팅

GetX 라우팅 사용. 모든 경로는 `AppRoutes`에 정의되어 있습니다.

| 경로 | 페이지 | 설명 |
|------|--------|------|
| `/splash` | SplashPage | 애니메이션 스플래시 + 버전 체크 |
| `/onboarding/notification-consent` | NotificationConsentPage | 알림 권한 요청 (최초 1회) |
| `/onboarding/contact-import` | ContactImportOnboardingPage | 연락처 가져오기 (최초, 선택) |
| `/main` | MainPage | 메인 화면 (캘린더 + 친구 탭) |
| `/birthday/detail` | BirthdayDetailPage | 생일 상세 (birthdayId 인자) |
| `/settings` | SettingsPage | 설정 |
| `/settings/oss-licenses` | OssLicensesPage | 오픈소스 라이선스 |
| `/contact/import` | ContactImportPage | 연락처 가져오기 (설정에서 접근) |

---

## 디자인 시스템

### 색상 팔레트 (AppColors)

| 이름 | 색상 코드 | 용도 |
|------|-----------|------|
| `primary` | `#B8A3E6` | 라벤더 (메인 색상) |
| `primaryLight` | `#D4C5F0` | 밝은 라벤더 |
| `primaryDark` | `#9681D3` | 어두운 라벤더 |
| `accent` | `#EC4899` | 핑크 (생일 강조) |
| `background` | `#F9FAFB` | 배경색 |
| `surface` | `#FFFFFF` | 카드/시트 배경 |
| `textPrimary` | `#111827` | 기본 텍스트 |
| `textSecondary` | `#6B7280` | 보조 텍스트 |
| `success` | `#10B981` | 성공 |
| `error` | `#EF4444` | 에러 |

> `AppColors.op(Color, double)` 유틸로 opacity를 적용합니다. `withOpacity()` 대신 사용하세요.

### 반응형 레이아웃

flutter_screenutil 사용, 디자인 기준 사이즈:
- 폰: 390 x 844
- 태블릿: 674 x 842

```dart
// 사용 예시
Container(
  width: 100.w,   // 너비
  height: 50.h,   // 높이
  child: Text('텍스트', style: TextStyle(fontSize: 14.sp)),
)
```

### 마스코트 (해달 캐릭터)

`OtterImage` 위젯으로 해달 이미지를 표시합니다. 이미지가 없으면 placeholder 아이콘이 표시됩니다.

```dart
OtterImage(type: OtterType.empty, size: 120)
```

| OtterType | 용도 |
|-----------|------|
| `splash` | 스플래시 화면 |
| `empty` | 빈 목록 |
| `celebrate` | 생일 축하 |
| `gift` | 선물 기록 |
| `error` | 에러 상태 |
| `wave` | 인사/업데이트 |

---

## 코드 생성

프로젝트에서 사용하는 코드 생성 도구:

| 도구 | 생성 파일 | 용도 |
|------|-----------|------|
| drift_dev | `app_database.g.dart` | Drift ORM 코드 |
| flutter_gen_runner | `assets.gen.dart`, `fonts.gen.dart` | 에셋/폰트 타입 세이프 접근 |
| flutter_oss_licenses | `oss_licenses.dart` | 오픈소스 라이선스 목록 |

```bash
# 전체 코드 생성 (일회성)
dart run build_runner build --delete-conflicting-outputs

# 파일 변경 감지 모드 (개발 중)
dart run build_runner watch --delete-conflicting-outputs
```

---

## 사용 가능한 명령어

| 명령어 | 설명 |
|--------|------|
| `flutter pub get` | 의존성 설치 |
| `dart run build_runner build --delete-conflicting-outputs` | 코드 생성 (Drift, flutter_gen, OSS) |
| `dart run build_runner watch --delete-conflicting-outputs` | 코드 생성 (파일 변경 감지) |
| `dart run flutter_launcher_icons` | 앱 아이콘 생성 |
| `flutter run -d ios` | iOS 시뮬레이터에서 실행 |
| `flutter run -d android` | Android 에뮬레이터에서 실행 |
| `flutter run -d macos` | macOS에서 실행 |
| `flutter build ios --release` | iOS 릴리스 빌드 |
| `flutter build appbundle --release` | Android App Bundle 릴리스 빌드 |
| `flutter analyze` | 정적 분석 (flutter_lints) |
| `flutter test` | 테스트 실행 |

---

## 배포

### iOS (App Store)

```bash
# 1. 릴리스 빌드
flutter build ios --release

# 2. Xcode에서 Archive
#    Xcode → Product → Archive → Distribute App → App Store Connect

# 3. App Store Connect에서 심사 제출
```

App Store URL: https://apps.apple.com/app/6758571069

### Android (Google Play)

```bash
# 1. App Bundle 빌드
flutter build appbundle --release

# 2. Google Play Console에 업로드
#    build/app/outputs/bundle/release/app-release.aab
```

Google Play URL: https://play.google.com/store/apps/details?id=com.rudqlsdla.rememberotter

### 버전 관리

`pubspec.yaml`의 `version` 필드를 업데이트합니다:

```yaml
version: 1.0.0+1
#         │     └── 빌드 번호 (정수, 매 빌드마다 증가)
#         └──────── 시맨틱 버전 (major.minor.patch)
```

Remote Config의 버전 키도 함께 업데이트하세요:
- `hard_latest_version` — 강제 업데이트 최소 버전
- `soft_latest_version` — 권장 업데이트 최소 버전
- `latest_version` — 최신 버전

---

## 트러블슈팅

### CocoaPods 관련 에러

```bash
cd ios && pod deintegrate && pod install && cd ..
```

### Drift 코드 생성 충돌

```bash
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### iOS 시뮬레이터에서 알림이 동작하지 않음

iOS 시뮬레이터에서는 로컬 알림의 소리/배지만 동작하고, 실제 알림 배너는 실기기에서만 테스트 가능합니다.

### Android 빌드 시 `minSdkVersion` 에러

`android/app/build.gradle.kts`에서 Flutter의 기본 minSdkVersion을 사용 중입니다. 특정 플러그인이 더 높은 버전을 요구하면 `android/local.properties`에서 `flutter.minSdkVersion`을 확인하세요.

### `flutter pub get` 실패

```bash
flutter clean
flutter pub get
```

### firebase_options.dart 관련 에러

FlutterFire CLI로 생성된 파일이 이미 포함되어 있습니다. 새로운 Firebase 프로젝트로 교체하려면:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

---

## 문서

| 문서 | 위치 |
|------|------|
| 개인정보처리방침 | [Notion](https://crystal-scribe-8e8.notion.site/30eb6e53419b80e49521e5693d5fa93a) |
| 서비스 이용약관 | [Notion](https://crystal-scribe-8e8.notion.site/30eb6e53419b80e2b821dd40066b8479) |
| 해달 이미지 생성 프롬프트 | `docs/otter_image_prompts.md` |
