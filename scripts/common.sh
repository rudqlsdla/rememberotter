#!/bin/bash
# ============================================================
# common.sh — 공통 유틸리티
# ============================================================

# 터미널 색상 상수
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 프로젝트 루트 디렉토리 (이 스크립트 기준)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# 배포 인증 정보 로드
_load_credentials() {
  local cred_file="$PROJECT_ROOT/.deploy_credentials"
  if [[ -f "$cred_file" ]]; then
    source "$cred_file"
  fi
}

# Discord 웹훅 알림 전송
# 사용법: send_discord_notification "제목" "메시지" [색상코드]
send_discord_notification() {
  _load_credentials

  if [[ -z "$DISCORD_WEBHOOK_URL" ]]; then
    return 0 # URL 미설정 시 조용히 스킵
  fi

  local title="$1"
  local message="$2"
  local color="${3:-5814783}" # 기본: 라벤더 (#58B9FF → 5814783)

  local payload=$(cat <<EOF
{
  "embeds": [{
    "title": "$title",
    "description": "$message",
    "color": $color
  }]
}
EOF
)

  curl -s -H "Content-Type: application/json" \
    -d "$payload" \
    "$DISCORD_WEBHOOK_URL" > /dev/null 2>&1 || true
}

# 유틸리티 함수
log_info() {
  echo -e "${CYAN}[INFO]${NC} $1"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
  echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}
