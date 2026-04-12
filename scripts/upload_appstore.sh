#!/bin/bash
# ============================================================
# upload_appstore.sh — App Store Connect 업로드
# 사용법: ./scripts/upload_appstore.sh [ipa_path]
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/common.sh"

cd "$PROJECT_ROOT"

# ──────────────────────────────────────────
# IPA 경로 결정
# ──────────────────────────────────────────
IPA_PATH="${1:-}"

if [[ -z "$IPA_PATH" ]]; then
  IPA_PATH=$(find build/ios/ipa -name "*.ipa" -type f 2>/dev/null | head -n1)
fi

if [[ -z "$IPA_PATH" || ! -f "$IPA_PATH" ]]; then
  log_error "IPA 파일을 찾을 수 없습니다."
  echo "사용법: ./scripts/upload_appstore.sh [ipa_path]"
  echo "또는 먼저 빌드를 실행해주세요: ./scripts/build_release.sh --skip-android"
  exit 1
fi

log_info "업로드할 IPA: $IPA_PATH"

# ──────────────────────────────────────────
# Credential 로드
# ──────────────────────────────────────────
_load_credentials

if [[ -z "$API_KEY_ID" || -z "$API_ISSUER_ID" ]]; then
  log_error ".deploy_credentials에 App Store 인증 정보가 없습니다."
  echo ""
  echo "프로젝트 루트의 .deploy_credentials 파일에 다음 값을 추가해주세요:"
  echo ""
  echo -e "${CYAN}API_KEY_ID=\"XXXXXXXXXX\"${NC}"
  echo -e "${CYAN}API_ISSUER_ID=\"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\"${NC}"
  echo ""
  echo "App Store Connect → 사용자 및 액세스 → 통합 → API 키에서 발급할 수 있습니다."
  echo "AuthKey_<API_KEY_ID>.p8 파일은 ~/.private_keys/ 에 위치해야 합니다."
  exit 1
fi

if [[ -z "$API_KEY_ID" || -z "$API_ISSUER_ID" ]]; then
  log_error "API_KEY_ID 또는 API_ISSUER_ID가 설정되지 않았습니다."
  exit 1
fi

# ──────────────────────────────────────────
# AuthKey .p8 파일 확인 및 심볼릭 링크
# ──────────────────────────────────────────
P8_FILE="AuthKey_${API_KEY_ID}.p8"
PRIVATE_KEYS_DIR="$HOME/.private_keys"

if [[ ! -d "$PRIVATE_KEYS_DIR" ]]; then
  mkdir -p "$PRIVATE_KEYS_DIR"
fi

# .p8 파일 검색 (홈 디렉토리 및 프로젝트에서)
if [[ ! -f "$PRIVATE_KEYS_DIR/$P8_FILE" ]]; then
  # 일반적인 위치들에서 검색
  FOUND_P8=""
  for search_dir in "$HOME/Downloads" "$HOME/Desktop" "$PROJECT_ROOT"; do
    if [[ -f "$search_dir/$P8_FILE" ]]; then
      FOUND_P8="$search_dir/$P8_FILE"
      break
    fi
  done

  if [[ -n "$FOUND_P8" ]]; then
    log_info "$FOUND_P8 → $PRIVATE_KEYS_DIR/$P8_FILE 심볼릭 링크 생성"
    ln -sf "$FOUND_P8" "$PRIVATE_KEYS_DIR/$P8_FILE"
  else
    log_error "$P8_FILE 파일을 찾을 수 없습니다."
    echo "App Store Connect에서 다운로드한 .p8 파일을 다음 위치에 복사해주세요:"
    echo "  $PRIVATE_KEYS_DIR/$P8_FILE"
    exit 1
  fi
fi

# ──────────────────────────────────────────
# 업로드
# ──────────────────────────────────────────
log_info "App Store Connect에 업로드 중..."
echo ""

xcrun altool --upload-app \
  -f "$IPA_PATH" \
  -t ios \
  --apiKey "$API_KEY_ID" \
  --apiIssuer "$API_ISSUER_ID"

UPLOAD_RESULT=$?

if [[ $UPLOAD_RESULT -eq 0 ]]; then
  log_success "App Store 업로드 완료!"
  send_discord_notification \
    "🍎 App Store 업로드 성공" \
    "IPA가 App Store Connect에 업로드되었습니다.\n파일: \`$(basename "$IPA_PATH")\`" \
    "3066993" # 녹색
else
  log_error "App Store 업로드 실패 (exit code: $UPLOAD_RESULT)"
  send_discord_notification \
    "❌ App Store 업로드 실패" \
    "IPA 업로드 중 오류가 발생했습니다." \
    "15158332" # 빨간색
  exit 1
fi
