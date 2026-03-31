# lecture-pack

대학 강의 준비를 위한 Claude Code 스킬팩. 미디어아트/크리에이티브 코딩 수업을 위해 설계되었다.

## Skills

| 스킬 | 커맨드 | 설명 |
|------|--------|------|
| **lesson-plan** | `/lesson-plan` | 웹 리서치 기반 마크다운 교안 생성 |
| **lecture-slides** | `/lecture-slides` | 교안을 HTML 슬라이드로 변환 |
| **lecture-export** | `/lecture-export` | 슬라이드를 고화질 PDF로 익스포트 |

## Workflow

```
/lesson-plan → 교안(.md) → /lecture-slides → 슬라이드(.html) → /lecture-export → PDF
```

## Setup

### 1. 스킬 설치

```bash
# 각 스킬을 Claude Code에 등록
cp -r lesson-plan ~/.claude/skills/
cp -r lecture-slides ~/.claude/skills/
cp -r lecture-export ~/.claude/skills/
```

### 2. 의존성

- **frontend-slides** 스킬 필요 (lecture-slides용)
- **Node.js** 필요 (lecture-export용 — Playwright 자동 설치)

## Quality Presets (PDF Export)

| 프리셋 | 해상도 | 스케일 | 용도 |
|--------|--------|--------|------|
| compact | 1280×720 | 1x | 모바일, 용량 절약 |
| standard | 1920×1080 | 1x | 이메일, 빠른 공유 |
| high (기본) | 1920×1080 | 2x | 화면 공유, 인쇄 |
| ultra | 2560×1440 | 2x | 대형 인쇄, 포스터 |
