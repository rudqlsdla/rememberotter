#!/bin/bash
# ============================================================
# bump_version.sh — 버전 범프 + 커밋 + 태그 + 빌드/업로드 오케스트레이터
# 사용법: ./scripts/bump_version.sh [version] [build]
# 예시:   ./scripts/bump_version.sh 1.2.0 11
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/common.sh"

cd "$PROJECT_ROOT"

# ──────────────────────────────────────────
# 1. 현재 버전 표시
# ──────────────────────────────────────────
CURRENT_VERSION_LINE=$(grep '^version:' pubspec.yaml)
CURRENT_VERSION=$(echo "$CURRENT_VERSION_LINE" | sed 's/version: //' | cut -d'+' -f1)
CURRENT_BUILD=$(echo "$CURRENT_VERSION_LINE" | sed 's/version: //' | cut -d'+' -f2)

echo ""
log_info "현재 버전: ${CYAN}${CURRENT_VERSION}+${CURRENT_BUILD}${NC}"
echo ""

# ──────────────────────────────────────────
# 2. 새 버전/빌드 번호 입력
# ──────────────────────────────────────────
NEW_VERSION="${1:-}"
NEW_BUILD="${2:-}"

if [[ -z "$NEW_VERSION" ]]; then
  read -p "$(echo -e "${YELLOW}새 버전 번호${NC} (예: 1.2.0): ")" NEW_VERSION
fi

if [[ -z "$NEW_BUILD" ]]; then
  SUGGESTED_BUILD=$((CURRENT_BUILD + 1))
  read -p "$(echo -e "${YELLOW}새 빌드 번호${NC} [${SUGGESTED_BUILD}]: ")" NEW_BUILD
  NEW_BUILD="${NEW_BUILD:-$SUGGESTED_BUILD}"
fi

# ──────────────────────────────────────────
# 3. 버전 형식 검증
# ──────────────────────────────────────────
if ! [[ "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  log_error "버전 형식이 올바르지 않습니다: $NEW_VERSION (x.y.z 형식 필요)"
  exit 1
fi

if ! [[ "$NEW_BUILD" =~ ^[0-9]+$ ]]; then
  log_error "빌드 번호는 숫자여야 합니다: $NEW_BUILD"
  exit 1
fi

echo ""
log_info "새 버전: ${GREEN}${NEW_VERSION}+${NEW_BUILD}${NC}"
echo ""

# ──────────────────────────────────────────
# 4. 배포 옵션 대화형 입력
# ──────────────────────────────────────────
DO_BUILD="n"
DO_IOS="y"
DO_ANDROID="y"
DO_UPLOAD="n"

read -p "$(echo -e "${YELLOW}빌드도 실행할까요?${NC} (y/N): ")" DO_BUILD
DO_BUILD="${DO_BUILD:-n}"

if [[ "$DO_BUILD" =~ ^[Yy]$ ]]; then
  read -p "$(echo -e "${YELLOW}iOS 빌드?${NC} (Y/n): ")" DO_IOS
  DO_IOS="${DO_IOS:-y}"

  read -p "$(echo -e "${YELLOW}Android 빌드?${NC} (Y/n): ")" DO_ANDROID
  DO_ANDROID="${DO_ANDROID:-y}"

  read -p "$(echo -e "${YELLOW}빌드 후 스토어 업로드?${NC} (y/N): ")" DO_UPLOAD
  DO_UPLOAD="${DO_UPLOAD:-n}"

  if [[ "$DO_UPLOAD" =~ ^[Yy]$ ]]; then
    DO_UPLOAD_IOS="n"
    DO_UPLOAD_ANDROID="n"

    if [[ "$DO_IOS" =~ ^[Yy]$ ]]; then
      read -p "$(echo -e "${YELLOW}App Store 업로드?${NC} (Y/n): ")" DO_UPLOAD_IOS
      DO_UPLOAD_IOS="${DO_UPLOAD_IOS:-y}"
    fi

    if [[ "$DO_ANDROID" =~ ^[Yy]$ ]]; then
      read -p "$(echo -e "${YELLOW}Play Store 업로드?${NC} (Y/n): ")" DO_UPLOAD_ANDROID
      DO_UPLOAD_ANDROID="${DO_UPLOAD_ANDROID:-y}"
    fi
  fi
fi

# ──────────────────────────────────────────
# 5. Working directory clean 체크
# ──────────────────────────────────────────
if [[ -n "$(git status --porcelain)" ]]; then
  log_error "Git working directory가 clean하지 않습니다."
  echo ""
  git status --short
  echo ""
  log_error "먼저 변경 사항을 커밋하거나 stash해주세요."
  exit 1
fi

# ──────────────────────────────────────────
# 6. 이전 태그 찾기
# ──────────────────────────────────────────
LATEST_TAG=$(git tag -l 'app-*' --sort=-version:refname | head -n1)
if [[ -n "$LATEST_TAG" ]]; then
  log_info "최근 태그: $LATEST_TAG"
else
  log_info "이전 배포 태그가 없습니다."
fi

# ──────────────────────────────────────────
# 7. pubspec.yaml 업데이트
# ──────────────────────────────────────────
log_info "pubspec.yaml 업데이트 중..."
sed -i '' "s/^version: .*/version: ${NEW_VERSION}+${NEW_BUILD}/" pubspec.yaml

# ──────────────────────────────────────────
# 8. iOS project.pbxproj 업데이트
# ──────────────────────────────────────────
PBXPROJ="ios/Runner.xcodeproj/project.pbxproj"

if [[ -f "$PBXPROJ" ]]; then
  log_info "iOS project.pbxproj 업데이트 중..."

  # MARKETING_VERSION — 3파트(x.y.z)만 매칭하여 RunnerTests(1.0)는 보호
  sed -i '' -E "s/(MARKETING_VERSION = )[0-9]+\.[0-9]+\.[0-9]+;/\1${NEW_VERSION};/g" "$PBXPROJ"

  # CURRENT_PROJECT_VERSION — 전체 일괄 업데이트
  sed -i '' -E "s/(CURRENT_PROJECT_VERSION = )[0-9]+;/\1${NEW_BUILD};/g" "$PBXPROJ"

  # FLUTTER_BUILD_NAME / FLUTTER_BUILD_NUMBER — Runner 타겟에만 존재
  sed -i '' -E "s/(FLUTTER_BUILD_NAME = )[^;]+;/\1${NEW_VERSION};/g" "$PBXPROJ"
  sed -i '' -E "s/(FLUTTER_BUILD_NUMBER = )[^;]+;/\1${NEW_BUILD};/g" "$PBXPROJ"
else
  log_warn "iOS 프로젝트 파일을 찾을 수 없습니다: $PBXPROJ"
fi

# ──────────────────────────────────────────
# 9. git fetch && git pull
# ──────────────────────────────────────────
log_info "git fetch && git pull..."
git fetch
git pull

# ──────────────────────────────────────────
# 10-11. git add + commit
# ──────────────────────────────────────────
log_info "변경 사항 커밋 중..."
git add pubspec.yaml
if [[ -f "$PBXPROJ" ]]; then
  git add "$PBXPROJ"
fi

COMMIT_MSG="chore(\$app): version update ${NEW_VERSION}(${NEW_BUILD})"
git commit -m "$COMMIT_MSG"

# ──────────────────────────────────────────
# 12. git tag
# ──────────────────────────────────────────
TAG_NAME="app-${NEW_VERSION}(${NEW_BUILD})"

if git tag -l "$TAG_NAME" | grep -q "$TAG_NAME"; then
  log_error "태그가 이미 존재합니다: $TAG_NAME"
  exit 1
fi

git tag "$TAG_NAME"
log_success "태그 생성: $TAG_NAME"

# ──────────────────────────────────────────
# 13. Discord 알림
# ──────────────────────────────────────────
CHANGE_LOG=""
if [[ -n "$LATEST_TAG" ]]; then
  CHANGE_LOG=$(git log --oneline "$LATEST_TAG"..HEAD 2>/dev/null || echo "")
fi

send_discord_notification \
  "🦦 기억해달 v${NEW_VERSION}(${NEW_BUILD}) 버전 범프" \
  "버전이 업데이트되었습니다.\n\n**변경 사항:**\n\`\`\`\n${CHANGE_LOG:-"첫 릴리즈"}\n\`\`\`"

# ──────────────────────────────────────────
# 14. 빌드/업로드 파이프라인
# ──────────────────────────────────────────
echo ""
log_success "버전 범프 완료: ${NEW_VERSION}+${NEW_BUILD}"
echo ""

if [[ "$DO_BUILD" =~ ^[Yy]$ ]]; then
  BUILD_FLAGS=""

  if [[ "$DO_IOS" =~ ^[Nn]$ ]]; then
    BUILD_FLAGS="$BUILD_FLAGS --skip-ios"
  fi

  if [[ "$DO_ANDROID" =~ ^[Nn]$ ]]; then
    BUILD_FLAGS="$BUILD_FLAGS --skip-android"
  fi

  if [[ "$DO_UPLOAD" =~ ^[Yy]$ ]]; then
    if [[ "$DO_UPLOAD_IOS" =~ ^[Yy]$ ]]; then
      BUILD_FLAGS="$BUILD_FLAGS --upload-ios"
    fi
    if [[ "$DO_UPLOAD_ANDROID" =~ ^[Yy]$ ]]; then
      BUILD_FLAGS="$BUILD_FLAGS --upload-android"
    fi
  fi

  log_info "빌드 시작..."
  "$SCRIPT_DIR/build_release.sh" $BUILD_FLAGS
fi

echo ""
log_success "모든 작업이 완료되었습니다!"
echo ""
log_info "git push를 잊지 마세요:"
echo -e "  ${CYAN}git push && git push --tags${NC}"
echo ""
