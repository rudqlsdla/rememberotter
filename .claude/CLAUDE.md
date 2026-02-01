# 기억해달 (RememberOtter) 프로젝트 문서

## 프로젝트 개요
생일을 관리해주는 캘린더 앱. 소중한 사람들의 생일을 기록하고, 선물 교환 여부를 추적하며, 푸시 알림을 통해 생일을 놓치지 않도록 도와줍니다.

## 브랜딩 & 캐릭터

### 앱 이름
**기억해달** = "기억해달라" + "해달(Sea Otter)"의 언어유희

### 마스코트: 해달 (Sea Otter)

#### 해달과 앱의 연결고리
해달은 **좋아하는 돌을 평생 간직하는** 습성이 있습니다. 조개를 깰 때 사용하는 자기만의 돌을 겨드랑이 주머니에 넣고 평생 가지고 다니며 절대 잃어버리지 않습니다.

> "해달이 소중한 돌을 간직하듯, 소중한 사람들의 생일을 간직해드릴게요"

#### OtterImage 위젯 (구현됨)
`lib/shared/widgets/otter_image.dart`에 구현되어 있으며, 이미지 파일이 없으면 placeholder 아이콘을 표시합니다.

```dart
OtterImage(type: OtterType.empty, size: 120)
```

| OtterType | 용도 | Placeholder 아이콘 |
|-----------|------|-------------------|
| splash | 스플래시 화면 | Icons.pets |
| empty | 빈 목록 | Icons.cake_outlined |
| celebrate | 생일 축하 | Icons.celebration |
| gift | 선물 기록 | Icons.card_giftcard |
| error | 에러 상태 | Icons.error_outline |
| wave | 인사 | Icons.waving_hand |

이미지 파일 경로: `assets/images/otter/img_otter_{type}.png`

## 기술 스택

| 분류 | 패키지 | 버전 |
|------|--------|------|
| Framework | Flutter | 3.8.1+ |
| State Management | GetX | ^4.7.2 |
| UI Util | flutter_screenutil | ^5.9.3 |
| Local DB | Hive, hive_flutter | ^2.2.3 |
| Push Notification | flutter_local_notifications | ^18.0.1 |
| Timezone | timezone, flutter_timezone | ^0.10.0 |
| Permission | permission_handler | ^12.0.1 |
| App Info | package_info_plus | ^8.0.0 |
| Logging | logger | ^2.6.0 |
| UUID | uuid | ^4.5.1 |

## 프로젝트 구조

```
lib/
├── app/                              # 앱 설정
│   ├── app_bindings.dart             # 의존성 주입 (GetX)
│   ├── app_constants.dart            # 상수 정의
│   ├── app_pages.dart                # 페이지 라우트 매핑
│   └── app_routes.dart               # 라우트 이름 정의
│
├── design_system/                    # 디자인 시스템
│   └── variable/
│       └── app_colors.dart           # 앱 색상 정의
│
├── domain/                           # 도메인 레이어
│   ├── models/
│   │   ├── birthday.dart             # 생일 모델 (Hive)
│   │   ├── birthday.g.dart           # 생성된 어댑터
│   │   ├── gift.dart                 # 선물 모델 (Hive)
│   │   └── gift.g.dart               # 생성된 어댑터
│   └── repositories/
│       ├── birthday_repository.dart  # 생일 CRUD
│       └── gift_repository.dart      # 선물 CRUD
│
├── feature/                          # 기능별 폴더
│   ├── splash/
│   │   └── pages/splash_page.dart
│   ├── main/
│   │   └── pages/main_page.dart      # 탭 네비게이션 (캘린더/친구/설정)
│   ├── calendar/
│   │   ├── pages/calendar_page.dart  # 무한 스크롤 캘린더
│   │   └── widgets/month_calendar_widget.dart
│   ├── birthday/
│   │   ├── controllers/birthday_controller.dart
│   │   ├── pages/birthday_detail_page.dart
│   │   └── widgets/
│   │       ├── birthday_list_item.dart
│   │       └── birthday_form_sheet.dart
│   └── gift/
│       ├── controllers/gift_controller.dart
│       └── widgets/
│           ├── gift_list_item.dart
│           ├── gift_form_sheet.dart
│           └── gift_history_section.dart
│
├── shared/                           # 공통 유틸/위젯
│   ├── log/logger.dart
│   ├── services/
│   │   ├── notification_service.dart # 푸시 알림 스케줄링
│   │   └── settings_service.dart     # 앱 설정 (Hive)
│   └── widgets/
│       ├── otter_image.dart          # 해달 캐릭터 위젯
│       ├── date_picker_spinner.dart  # 날짜 선택 휠
│       ├── time_picker_spinner.dart  # 시간 선택 휠
│       └── year_picker_spinner.dart  # 연도 선택 휠
│
└── main.dart                         # 앱 진입점
```

## 구현 완료 기능

### 1. 생일 관리 (완료)
- [x] 생일 CRUD (추가/조회/수정/삭제)
- [x] 무한 스크롤 캘린더 (과거/미래 5년)
- [x] 생일 마커 표시
- [x] 오늘 날짜 하이라이트
- [x] D-day 계산 및 표시
- [x] 나이 계산

### 2. 선물 관리 (완료)
- [x] 선물 기록 CRUD
- [x] 연도별 선물 히스토리
- [x] 준/받은 선물 구분
- [x] 생일 상세 페이지에 선물 섹션

### 3. 푸시 알림 (완료)
- [x] 로컬 푸시 알림 스케줄링
- [x] 알림 시간 설정 (커스텀 타임피커)
- [x] 알림 N일 전 설정 (당일/1일/3일/7일 전)
- [x] 알림 권한 관리
- [x] 설정 변경 시 기존 데이터 일괄 업데이트
- [x] 알림 날짜 지난 경우 내년으로 자동 재계산

### 4. 설정 (완료)
- [x] 알림 권한 상태 표시
- [x] 알림 시간 설정
- [x] 알림 받을 시점 설정
- [x] 앱 버전 표시 (동적)

### 5. UI/UX (완료)
- [x] OtterImage 위젯 (placeholder 지원)
- [x] 빈 화면 상태 개선
- [x] 스플래시 화면
- [x] 메이플스토리체 폰트 적용

## 데이터 모델

### Birthday (typeId: 0)
```dart
@HiveType(typeId: 0)
class Birthday extends HiveObject {
  @HiveField(0) final String id;
  @HiveField(1) final String name;
  @HiveField(2) final DateTime birthDate;
  @HiveField(3) final String? memo;
  @HiveField(4) final String? profileImage;
  @HiveField(5) final bool isLunarCalendar;      // @Deprecated - Hive 호환성 유지용
  @HiveField(6) final bool notificationEnabled;
  @HiveField(7) final int notificationDaysBefore;
  @HiveField(8) final DateTime createdAt;
  @HiveField(9) final DateTime updatedAt;
}
```

### Gift (typeId: 1)
```dart
@HiveType(typeId: 1)
class Gift extends HiveObject {
  @HiveField(0) final String id;
  @HiveField(1) final String birthdayId;
  @HiveField(2) final int year;
  @HiveField(3) final bool given;
  @HiveField(4) final bool received;
  @HiveField(5) final String? givenGiftName;
  @HiveField(6) final String? receivedGiftName;
  @HiveField(7) final String? memo;
  @HiveField(8) final DateTime createdAt;
  @HiveField(9) final DateTime updatedAt;
}
```

### Settings (Hive Box: 'settings')
- `notificationDaysBefore`: int (기본값: 1)
- `notificationHour`: int (기본값: 9)
- `notificationMinute`: int (기본값: 0)

## 화면 구성

### 메인 탭
1. **캘린더 탭**: 무한 스크롤 월별 캘린더 + 오늘 버튼
2. **친구 탭**: 생일 목록 (D-day 순 정렬)
3. **설정 탭**: 알림 설정, 앱 정보

### 주요 화면
- **생일 추가/수정**: Bottom Sheet (BirthdayFormSheet)
- **생일 상세**: BirthdayDetailPage (프로필 + 정보 + 선물 기록)
- **선물 추가/수정**: Bottom Sheet (GiftFormSheet)

## 색상 팔레트

```dart
// Primary Colors
primary: #B8A3E6        // 라벤더 보라
primaryLight: #D4C5F0
primaryDark: #9681D3

// Accent
accent: #EC4899         // 핑크 (생일 강조)

// Background
background: #F9FAFB
surface: #FFFFFF
surfaceVariant: #F3F4F6

// Text
textPrimary: #111827
textSecondary: #6B7280
textTertiary: #9CA3AF

// Status
success: #10B981
error: #EF4444
warning: #F59E0B

// Calendar
calendarToday: primary
calendarSelected: primary
calendarWeekend: #EF4444  // 일요일
calendarDisabled: #D1D5DB
calendarEvent: accent

// Border
border: #E5E7EB
divider: #F3F4F6
```

## 코딩 컨벤션

- **상태관리**: GetX 패턴 (Controller + Obx)
- **폴더구조**: feature 단위 분리
- **색상**: `AppColors` 클래스 사용
- **반응형**: flutter_screenutil (.w, .h, .sp)
- **Deprecation**: `withOpacity` 대신 `AppColors.op()` 사용

## 향후 개선 사항

- [ ] 해달 캐릭터 이미지 추가
- [ ] 프로필 이미지 업로드
- [ ] 다크모드 지원
- [ ] 위젯 (홈 화면)
- [ ] iCloud/Google Drive 백업
- [ ] 음력 생일 지원 (HiveField 유지됨, UI만 추가하면 됨)
