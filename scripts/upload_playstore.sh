#!/bin/bash
# ============================================================
# upload_playstore.sh — Google Play Store 업로드
# 사용법: ./scripts/upload_playstore.sh [aab_path] [track]
# track: internal(기본), alpha, beta, production
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/common.sh"

cd "$PROJECT_ROOT"

# ──────────────────────────────────────────
# AAB 경로 및 트랙 결정
# ──────────────────────────────────────────
AAB_PATH="${1:-}"
TRACK="${2:-internal}"

if [[ -z "$AAB_PATH" ]]; then
  AAB_PATH="build/app/outputs/bundle/release/app-release.aab"
fi

if [[ ! -f "$AAB_PATH" ]]; then
  log_error "AAB 파일을 찾을 수 없습니다: $AAB_PATH"
  echo "사용법: ./scripts/upload_playstore.sh [aab_path] [track]"
  echo "또는 먼저 빌드를 실행해주세요: ./scripts/build_release.sh --skip-ios"
  exit 1
fi

log_info "업로드할 AAB: $AAB_PATH"
log_info "트랙: $TRACK"

# ──────────────────────────────────────────
# fastlane 설치 확인
# ──────────────────────────────────────────
if ! command -v fastlane &> /dev/null; then
  log_error "fastlane이 설치되어 있지 않습니다."
  echo ""
  echo "다음 명령어로 설치해주세요:"
  echo -e "  ${CYAN}brew install fastlane${NC}"
  echo "또는"
  echo -e "  ${CYAN}gem install fastlane${NC}"
  echo ""
  echo "자세한 내용: https://docs.fastlane.tools/getting-started/ios/setup/"
  exit 1
fi

# ──────────────────────────────────────────
# Credential 로드
# ──────────────────────────────────────────
_load_credentials

if [[ -z "$JSON_KEY_PATH" || -z "$PACKAGE_NAME" ]]; then
  log_error ".deploy_credentials에 Play Store 인증 정보가 없습니다."
  echo ""
  echo "프로젝트 루트의 .deploy_credentials 파일에 다음 값을 추가해주세요:"
  echo ""
  echo -e "${CYAN}JSON_KEY_PATH=\"/path/to/service-account.json\"${NC}"
  echo -e "${CYAN}PACKAGE_NAME=\"com.rudqlsdla.rememberotter\"${NC}"
  echo ""
  echo "Google Play Console → API 액세스 → 서비스 계정에서 JSON 키를 발급할 수 있습니다."
  exit 1
fi

if [[ ! -f "$JSON_KEY_PATH" ]]; then
  log_error "서비스 계정 JSON 파일을 찾을 수 없습니다: $JSON_KEY_PATH"
  exit 1
fi

# ──────────────────────────────────────────
# 업로드
# ──────────────────────────────────────────
log_info "Google Play Store에 업로드 중 (트랙: $TRACK)..."
echo ""

fastlane supply \
  --aab "$AAB_PATH" \
  --json_key "$JSON_KEY_PATH" \
  --package_name "$PACKAGE_NAME" \
  --track "$TRACK" \
  --skip_upload_metadata \
  --skip_upload_changelogs \
  --skip_upload_images \
  --skip_upload_screenshots

UPLOAD_RESULT=$?

if [[ $UPLOAD_RESULT -eq 0 ]]; then
  log_success "Play Store 업로드 완료! (트랙: $TRACK)"
  send_discord_notification \
    "🤖 Play Store 업로드 성공" \
    "AAB가 Play Store에 업로드되었습니다.\n트랙: \`$TRACK\`\n파일: \`$(basename "$AAB_PATH")\`" \
    "3066993" # 녹색
else
  log_error "Play Store 업로드 실패 (exit code: $UPLOAD_RESULT)"
  send_discord_notification \
    "❌ Play Store 업로드 실패" \
    "AAB 업로드 중 오류가 발생했습니다.\n트랙: \`$TRACK\`" \
    "15158332" # 빨간색
  exit 1
fi
