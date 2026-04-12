#!/bin/bash
# ============================================================
# build_release.sh — Flutter 릴리즈 빌드
# 플래그: --no-upload, --skip-ios, --skip-android
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/common.sh"

cd "$PROJECT_ROOT"

# ──────────────────────────────────────────
# 플래그 파싱
# ──────────────────────────────────────────
NO_UPLOAD=false
SKIP_IOS=false
SKIP_ANDROID=false

for arg in "$@"; do
  case $arg in
    --no-upload)   NO_UPLOAD=true ;;
    --skip-ios)    SKIP_IOS=true ;;
    --skip-android) SKIP_ANDROID=true ;;
    *)
      log_error "알 수 없는 플래그: $arg"
      echo "사용법: ./scripts/build_release.sh [--no-upload] [--skip-ios] [--skip-android]"
      exit 1
      ;;
  esac
done

# ──────────────────────────────────────────
# Flutter 설치 확인
# ──────────────────────────────────────────
if ! command -v flutter &> /dev/null; then
  log_error "Flutter가 설치되어 있지 않습니다."
  log_error "https://docs.flutter.dev/get-started/install 에서 설치해주세요."
  exit 1
fi

# ──────────────────────────────────────────
# flutter pub get
# ──────────────────────────────────────────
log_info "flutter pub get 실행 중..."
flutter pub get

# ──────────────────────────────────────────
# Android 빌드 (App Bundle)
# ──────────────────────────────────────────
AAB_PATH=""
if [[ "$SKIP_ANDROID" == false ]]; then
  echo ""
  log_info "Android App Bundle 빌드 중..."
  flutter build appbundle --release

  AAB_PATH="build/app/outputs/bundle/release/app-release.aab"
  if [[ -f "$AAB_PATH" ]]; then
    log_success "Android 빌드 완료: $AAB_PATH"
  else
    log_error "Android 빌드 결과물을 찾을 수 없습니다."
    exit 1
  fi
else
  log_info "Android 빌드 건너뜀 (--skip-android)"
fi

# ──────────────────────────────────────────
# iOS 빌드 (IPA)
# ──────────────────────────────────────────
IPA_PATH=""
if [[ "$SKIP_IOS" == false ]]; then
  echo ""
  log_info "iOS IPA 빌드 중..."
  flutter build ipa --release

  IPA_PATH=$(find build/ios/ipa -name "*.ipa" -type f 2>/dev/null | head -n1)
  if [[ -n "$IPA_PATH" ]]; then
    log_success "iOS 빌드 완료: $IPA_PATH"
  else
    log_error "iOS 빌드 결과물을 찾을 수 없습니다."
    exit 1
  fi
else
  log_info "iOS 빌드 건너뜀 (--skip-ios)"
fi

# ──────────────────────────────────────────
# 업로드
# ──────────────────────────────────────────
if [[ "$NO_UPLOAD" == true ]]; then
  log_info "업로드 건너뜀 (--no-upload)"
  echo ""
  log_success "빌드 완료!"
  exit 0
fi

echo ""

# App Store 업로드
if [[ "$SKIP_IOS" == false && -n "$IPA_PATH" ]]; then
  read -p "$(echo -e "${YELLOW}App Store에 업로드할까요?${NC} (y/N): ")" UPLOAD_IOS
  if [[ "$UPLOAD_IOS" =~ ^[Yy]$ ]]; then
    "$SCRIPT_DIR/upload_appstore.sh" "$IPA_PATH"
  fi
fi

# Play Store 업로드
if [[ "$SKIP_ANDROID" == false && -n "$AAB_PATH" ]]; then
  read -p "$(echo -e "${YELLOW}Play Store에 업로드할까요?${NC} (y/N): ")" UPLOAD_ANDROID
  if [[ "$UPLOAD_ANDROID" =~ ^[Yy]$ ]]; then
    "$SCRIPT_DIR/upload_playstore.sh" "$AAB_PATH"
  fi
fi

echo ""
log_success "모든 빌드 작업이 완료되었습니다!"
