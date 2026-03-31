#!/usr/bin/env bash
# install.sh — lecture-pack 스킬팩 설치 스크립트
#
# 사용법:
#   git clone https://github.com/0dot77/lecture-pack.git
#   cd lecture-pack
#   bash install.sh
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

info()  { echo -e "${CYAN}ℹ${NC} $*"; }
ok()    { echo -e "${GREEN}✓${NC} $*"; }
warn()  { echo -e "${YELLOW}⚠${NC} $*"; }
err()   { echo -e "${RED}✗${NC} $*" >&2; }

echo ""
echo -e "${BOLD}╔════════════════════════════════════════╗${NC}"
echo -e "${BOLD}║       lecture-pack 설치                 ║${NC}"
echo -e "${BOLD}╚════════════════════════════════════════╝${NC}"
echo ""

SKILLS_DIR="$HOME/.claude/skills"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ─── 1. Claude Code 스킬 디렉토리 확인 ───────────────────
if [[ ! -d "$HOME/.claude" ]]; then
    err "Claude Code가 설치되어 있지 않은 것 같습니다."
    err "먼저 Claude Code를 설치하세요: https://claude.ai/code"
    exit 1
fi

mkdir -p "$SKILLS_DIR"
ok "Claude Code 확인됨"

# ─── 2. frontend-slides 설치 ─────────────────────────────
echo ""
info "의존 스킬 확인 중..."

if [[ -f "$SKILLS_DIR/frontend-slides/SKILL.md" ]]; then
    ok "frontend-slides 이미 설치됨"
else
    info "frontend-slides 스킬을 설치합니다..."

    TEMP_DIR=$(mktemp -d)
    git clone --depth 1 https://github.com/zarazhangrui/frontend-slides.git "$TEMP_DIR/frontend-slides" 2>/dev/null || {
        err "frontend-slides 다운로드에 실패했습니다."
        err "네트워크 연결을 확인하거나 수동으로 설치하세요:"
        err "  https://github.com/zarazhangrui/frontend-slides"
        rm -rf "$TEMP_DIR"
        exit 1
    }

    cp -r "$TEMP_DIR/frontend-slides" "$SKILLS_DIR/frontend-slides"
    rm -rf "$TEMP_DIR"
    ok "frontend-slides 설치 완료"
fi

# ─── 3. lecture-pack 스킬 설치 ────────────────────────────
echo ""
info "lecture-pack 스킬 설치 중..."

for skill in lesson-plan lecture-slides lecture-export; do
    if [[ -d "$SCRIPT_DIR/$skill" ]]; then
        cp -r "$SCRIPT_DIR/$skill" "$SKILLS_DIR/$skill"
        ok "$skill 설치됨"
    else
        warn "$skill 폴더를 찾을 수 없습니다 — 건너뜁니다"
    fi
done

# ─── 4. Node.js 확인 ─────────────────────────────────────
echo ""
if command -v node &>/dev/null; then
    NODE_VERSION=$(node --version)
    ok "Node.js 확인됨 ($NODE_VERSION)"
else
    warn "Node.js가 설치되어 있지 않습니다."
    warn "PDF 내보내기(/lecture-export)를 사용하려면 Node.js가 필요합니다."
    warn "설치: https://nodejs.org 또는 brew install node"
fi

# ─── 완료 ─────────────────────────────────────────────────
echo ""
echo -e "${BOLD}════════════════════════════════════════${NC}"
ok "설치가 완료되었습니다!"
echo ""
echo "  Claude Code를 재시작한 후 아래 명령어를 사용할 수 있습니다:"
echo ""
echo -e "  ${BOLD}/lesson-plan${NC}     교안 만들기"
echo -e "  ${BOLD}/lecture-slides${NC}  슬라이드 만들기"
echo -e "  ${BOLD}/lecture-export${NC}  PDF로 내보내기"
echo ""
echo -e "${BOLD}════════════════════════════════════════${NC}"
echo ""
