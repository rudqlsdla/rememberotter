# 기억해달 (MemoCal) 프로젝트 문서

## 프로젝트 개요
생일을 관리해주는 캘린더 앱. 소중한 사람들의 생일을 기록하고, 선물 교환 여부를 추적하며, 푸시 알림을 통해 생일을 놓치지 않도록 도와줍니다.

## 기술 스택
- **Framework**: Flutter 3.8.1+
- **State Management**: GetX
- **UI Util**: flutter_screenutil (반응형 UI)
- **Logging**: logger

## 프로젝트 구조
```
lib/
├── app/                          # 앱 설정
│   ├── app_bindings.dart         # 의존성 주입
│   ├── app_constants.dart        # 상수 정의
│   ├── app_pages.dart            # 페이지 라우트 매핑
│   └── app_routes.dart           # 라우트 이름 정의
├── design_system/                # 디자인 시스템
│   └── variable/
│       └── app_colors.dart       # 앱 색상 정의
├── feature/                      # 기능별 폴더
│   ├── splash/                   # 스플래시 화면
│   │   └── pages/
│   │       └── splash_page.dart
│   └── main/                     # 메인 화면
│       └── pages/
│           └── main_page.dart
├── shared/                       # 공통 유틸
│   └── log/
│       └── logger.dart
└── main.dart                     # 앱 진입점
```

## 필수 기능 명세

### 1. 생일을 표시하는 달력
- [x] 월별 캘린더 뷰 (기본 구현 완료)
- [ ] 생일이 있는 날짜에 마커/뱃지 표시
- [ ] 날짜 선택 시 해당 날짜의 생일 목록 표시
- [ ] 오늘 날짜 하이라이트
- [ ] 이전/다음 달 네비게이션

### 2. 생일 CRUD
- [ ] **Create**: 생일 추가 (이름, 생년월일, 메모, 프로필 이미지)
- [ ] **Read**: 생일 목록 조회, 상세 조회
- [ ] **Update**: 생일 정보 수정
- [ ] **Delete**: 생일 삭제

### 3. 선물 주고받기 관리
- [ ] 선물 준 기록 추가/수정/삭제
- [ ] 선물 받은 기록 추가/수정/삭제
- [ ] 연도별 선물 히스토리 관리
- [ ] 선물 교환 여부 표시 (주기만 함/받기만 함/서로 교환)

### 4. 푸시 알림
- [ ] 생일 당일 알림
- [ ] 생일 N일 전 미리 알림 (설정 가능)
- [ ] 알림 시간 설정
- [ ] 알림 ON/OFF 개별 설정

## 데이터 모델 (Hive)

### Birthday (생일) - typeId: 0
```dart
@HiveType(typeId: 0)
class Birthday extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;           // 이름

  @HiveField(2)
  final DateTime birthDate;    // 생년월일

  @HiveField(3)
  final String? memo;          // 메모

  @HiveField(4)
  final String? profileImage;  // 프로필 이미지 경로

  @HiveField(5)
  final bool lunarCalendar;    // 음력 여부 (선택)

  @HiveField(6)
  final bool notificationEnabled; // 알림 활성화

  @HiveField(7)
  final int notificationDaysBefore; // N일 전 알림

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  final DateTime updatedAt;
}
```

### Gift (선물 기록) - typeId: 1
```dart
@HiveType(typeId: 1)
class Gift extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String birthdayId;     // 연관된 생일 ID

  @HiveField(2)
  final int year;              // 연도

  @HiveField(3)
  final bool given;            // 선물 줬는지

  @HiveField(4)
  final bool received;         // 선물 받았는지

  @HiveField(5)
  final String? givenGiftName; // 준 선물 이름

  @HiveField(6)
  final String? receivedGiftName; // 받은 선물 이름

  @HiveField(7)
  final String? memo;          // 메모

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  final DateTime updatedAt;
}
```

## 화면 구성

### 탭 구조 (현재 구현됨)
1. **캘린더 탭**: 월별 캘린더 + 다가오는 생일 목록
2. **친구 탭**: 전체 친구(생일) 목록
3. **설정 탭**: 알림 설정, 앱 설정

### 추가 필요 화면
- [ ] 생일 추가/수정 화면 (Bottom Sheet 또는 새 페이지)
- [ ] 생일 상세 화면 (선물 히스토리 포함)
- [ ] 선물 기록 추가/수정 화면

## 추가 필요 패키지

```yaml
dependencies:
  # 로컬 데이터베이스
  hive: ^2.2.3
  hive_flutter: ^1.1.0

dev_dependencies:
  hive_generator: ^2.0.1
  build_runner: ^2.4.8

  # 푸시 알림
  flutter_local_notifications: ^17.0.0
  timezone: ^0.9.2

  # 날짜 처리
  intl: ^0.19.0             # 날짜 포맷팅

  # 이미지 선택
  image_picker: ^1.0.7

  # 권한 처리
  permission_handler: ^11.3.0
```

## 색상 팔레트 (정의됨)
- **Primary**: `#B8A3E6` (라벤더 보라색)
- **Accent**: `#EC4899` (핑크 - 생일 강조용)
- **Background**: `#F9FAFB`
- **Text Primary**: `#111827`
- **Weekend (일요일)**: `#EF4444` (빨간색)
- **Saturday**: `#B8A3E6` (보라색)

## 구현 우선순위

### Phase 1: 핵심 기능
1. 데이터베이스 설정 (Hive)
2. Birthday 모델 및 Repository 구현
3. 생일 CRUD 기능 구현
4. 캘린더에 생일 마커 표시

### Phase 2: 선물 관리
5. Gift 모델 및 Repository 구현
6. 선물 기록 CRUD 기능 구현
7. 생일 상세 화면에 선물 히스토리 표시

### Phase 3: 알림
8. 로컬 푸시 알림 설정
9. 알림 스케줄링 로직 구현
10. 설정 화면에서 알림 관리

### Phase 4: 개선
11. 프로필 이미지 추가 기능
12. 음력 생일 지원 (선택)
13. UI/UX 개선

## 코딩 컨벤션
- GetX 패턴 사용 (Controller, Binding, Page 분리)
- feature 단위로 폴더 구성
- 색상은 `AppColors` 클래스 사용
- 화면 크기 대응은 `flutter_screenutil` 사용 (.w, .h, .sp)
