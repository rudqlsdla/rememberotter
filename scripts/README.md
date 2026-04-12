# 배포 자동화 스크립트

Flutter 프로젝트의 버전 범프 → 빌드 → 스토어 업로드를 자동화하는 스크립트.

## 구조

```
scripts/
├── common.sh            # 공통 유틸리티 (색상, 로그, Discord 알림)
├── bump_version.sh      # 버전 범프 + 커밋 + 태그 (오케스트레이터)
├── build_release.sh     # Flutter 릴리즈 빌드 (iOS/Android)
├── upload_appstore.sh   # App Store Connect IPA 업로드
└── upload_playstore.sh  # Google Play Store AAB 업로드

.deploy_credentials      # 인증 정보 (gitignore 대상)
```

## 빠른 시작

### 1. 스크립트 복사

`scripts/` 폴더를 프로젝트 루트에 복사.

### 2. 실행 권한 부여

```bash
chmod +x scripts/*.sh
```

### 3. `.gitignore`에 추가

```
.deploy_credentials
```

### 4. `.deploy_credentials` 생성

프로젝트 루트에 `.deploy_credentials` 파일 생성:

```bash
# ─── App Store Connect ───
API_KEY_ID="XXXXXXXXXX"
API_ISSUER_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

# ─── Google Play Store ───
JSON_KEY_PATH="/path/to/service-account.json"
PACKAGE_NAME="com.example.app"

# ─── Discord Webhook (선택) ───
DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/..."
```

### 5. 프로젝트별 수정 필요 사항

| 파일 | 수정 항목 |
|------|----------|
| `bump_version.sh` | 커밋 메시지 형식, 태그 prefix (`app-`) |
| `upload_appstore.sh` | `.p8` 파일 검색 경로 (필요 시) |
| `upload_playstore.sh` | 기본 트랙 (`internal`) |

---

## 사용법

### 버전 범프 (전체 플로우)

```bash
# 대화형
./scripts/bump_version.sh

# 인자 전달
./scripts/bump_version.sh 1.2.0 11
```

**실행 순서:**
1. 현재 버전 표시 (pubspec.yaml)
2. 새 버전/빌드 번호 입력
3. 배포 옵션 선택 (빌드? iOS? Android? 업로드?)
4. Git clean 체크
5. `pubspec.yaml` 업데이트
6. `ios/Runner.xcodeproj/project.pbxproj` 업데이트
7. `git fetch && git pull` → `git commit` → `git tag`
8. Discord 알림
9. (선택) 빌드 → 업로드

### 빌드만

```bash
# 전체 빌드 (업로드 없이)
./scripts/build_release.sh --no-upload

# iOS만
./scripts/build_release.sh --skip-android --no-upload

# Android만
./scripts/build_release.sh --skip-ios --no-upload
```

### 업로드만

```bash
# App Store
./scripts/upload_appstore.sh [ipa_path]

# Play Store (트랙: internal, alpha, beta, production)
./scripts/upload_playstore.sh [aab_path] [track]
```

---

## 인증 설정 가이드

### App Store Connect API 키

1. [App Store Connect](https://appstoreconnect.apple.com) → **사용자 및 액세스** → **통합** → **API 키**
2. **API 키 생성** → 역할: **앱 관리** 이상
3. 받은 값:
   - `API_KEY_ID` — 키 목록에 표시되는 키 ID
   - `API_ISSUER_ID` — 페이지 상단 Issuer ID
   - `AuthKey_<KEY_ID>.p8` — **1회만 다운로드 가능**
4. `.p8` 파일 배치:
   ```bash
   mkdir -p ~/.private_keys
   cp ~/Downloads/AuthKey_XXXXXXXXXX.p8 ~/.private_keys/
   ```

### Google Play Store 서비스 계정

1. [Google Cloud Console](https://console.cloud.google.com) → 프로젝트 선택 (또는 생성)
2. **IAM 및 관리자** → **서비스 계정** → **+ 서비스 계정 만들기**
3. 생성된 계정 클릭 → **키** 탭 → **키 추가** → **새 키 만들기** → **JSON**
4. [Google Play Console](https://play.google.com/console) → **사용자 및 권한** → **새 사용자 초대**
   - 이메일: 서비스 계정 이메일 (`xxx@xxx.iam.gserviceaccount.com`)
   - 권한: **프로덕션으로 출시** + **앱을 테스트 트랙으로 출시**
5. fastlane 설치:
   ```bash
   brew install fastlane
   ```

### Discord 웹훅 (선택)

1. Discord 서버 → 채널 설정 → **연동** → **웹후크** → **새 웹후크**
2. URL 복사 → `.deploy_credentials`에 추가
3. 미설정 시 알림이 조용히 스킵됨

---

## iOS project.pbxproj 업데이트 로직

`bump_version.sh`는 다음 규칙으로 Xcode 프로젝트 파일을 업데이트:

| 키 | 매칭 규칙 | 이유 |
|----|----------|------|
| `MARKETING_VERSION` | 3파트(`x.y.z`)만 매칭 | RunnerTests(`1.0`) 보호 |
| `CURRENT_PROJECT_VERSION` | 전체 일괄 업데이트 | 모든 타겟에 적용 (테스트에 무해) |
| `FLUTTER_BUILD_NAME` | 전체 매칭 | Runner 타겟에만 존재 |
| `FLUTTER_BUILD_NUMBER` | 전체 매칭 | Runner 타겟에만 존재 |

> **주의:** Widget Extension 등 추가 타겟이 3파트 MARKETING_VERSION을 사용하면 함께 업데이트됨. 필요 시 sed 패턴을 섹션별로 분리해야 함.

---

## 엣지 케이스

| 상황 | 동작 |
|------|------|
| Git working directory dirty | 에러 종료 |
| 동일 태그 존재 | 에러 종료 |
| Flutter 미설치 | 에러 메시지 |
| fastlane 미설치 | 설치 안내 메시지 |
| Discord URL 미설정 | 조용히 스킵 |
| `.deploy_credentials` 없음 | 가이드 메시지 출력 |
| `.p8` 파일 없음 | Downloads/Desktop에서 자동 검색 후 심볼릭 링크 |
