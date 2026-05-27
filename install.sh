#!/usr/bin/env bash
# LazyVim 개인 설정 부트스트랩
# 새 머신에서 ~/.config/nvim 을 이 repo로 복원합니다.
#
# 사용:
#   curl -fsSL https://raw.githubusercontent.com/temeraire97/nvim-settings/main/install.sh | bash
#   또는
#   git clone git@github.com:temeraire97/nvim-settings.git /tmp/nvim-settings && bash /tmp/nvim-settings/install.sh

set -euo pipefail

REPO_SSH="git@github.com:temeraire97/nvim-settings.git"
REPO_HTTPS="https://github.com/temeraire97/nvim-settings.git"
TS="$(date +%Y%m%d-%H%M%S)"

log()  { printf '[*] %s\n' "$*"; }
warn() { printf '[!] %s\n' "$*" >&2; }
err()  { printf '[ERR] %s\n' "$*" >&2; exit 1; }

# 1. 사전 요구사항
command -v git  >/dev/null || err "git이 설치되어 있지 않습니다."
command -v nvim >/dev/null || err "neovim이 설치되어 있지 않습니다. (macOS: brew install neovim)"

NVIM_VER="$(nvim --version | head -n1 | awk '{print $2}')"
log "neovim 버전: ${NVIM_VER}"

# 2. 기존 nvim 관련 디렉터리 백업 (있을 때만)
for dir in \
  "$HOME/.config/nvim" \
  "$HOME/.local/share/nvim" \
  "$HOME/.local/state/nvim" \
  "$HOME/.cache/nvim"
do
  if [ -e "$dir" ]; then
    log "백업: $dir -> $dir.bak.$TS"
    mv "$dir" "$dir.bak.$TS"
  fi
done

# 3. repo clone (SSH 우선, 실패 시 HTTPS fallback)
log "clone: $REPO_SSH -> ~/.config/nvim"
if ! git clone "$REPO_SSH" "$HOME/.config/nvim" 2>/dev/null; then
  warn "SSH clone 실패. HTTPS로 재시도합니다 (push 시 SSH로 remote 변경 필요)."
  git clone "$REPO_HTTPS" "$HOME/.config/nvim"
fi

# 4. lazy.nvim headless 사전 설치
log "lazy.nvim 플러그인 동기화 (headless)"
if ! nvim --headless "+Lazy! sync" +qa 2>/dev/null; then
  warn "headless 동기화 실패. nvim을 직접 실행해 lazy.nvim에 맡기세요."
fi

log "완료. 'nvim'을 실행하면 됩니다."
log "  - extras: lazyvim.json 기반 자동 로드"
log "  - 플러그인 버전: lazy-lock.json 기반 고정"
