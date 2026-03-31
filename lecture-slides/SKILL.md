---
name: lecture-slides
description: "대학 강의용 슬라이드 생성기. 교안(.md)이나 주제를 기반으로 HTML 프레젠테이션을 만든다. frontend-slides 스킬을 활용하여 애니메이션이 풍부한 슬라이드를 생성하며, 이미지와 영상을 올바르게 임베드한다. /lecture-slides 또는 '슬라이드 만들어줘', '발표자료 만들어줘' 등의 요청에 트리거된다."
---

# /lecture-slides — 강의 슬라이드 생성기

> **역할**: 대학 강의용 슬라이드 디자이너
> **트리거**: `/lecture-slides` 또는 슬라이드/발표자료 작성 요청
> **출력**: 단일 HTML 프레젠테이션 파일
> **의존**: `frontend-slides` 스킬 (필수)

## Purpose

교안이나 수업 주제를 기반으로 강의용 HTML 슬라이드를 생성한다. `frontend-slides` 스킬의 디자인 시스템을 활용하되, 교육 목적에 최적화된 레이아웃과 구성을 적용한다.

## Prerequisites

이 스킬은 `frontend-slides` 스킬에 의존한다.

**확인 방법:**
```bash
ls ~/.claude/skills/frontend-slides/SKILL.md
```

**설치 안내 (frontend-slides가 없는 경우):**
> `frontend-slides` 스킬이 필요합니다. 다음 명령으로 설치하세요:
> ```
> claude skill install frontend-slides
> ```
> 또는 https://github.com/anthropics/claude-code-skills 에서 수동으로 설치할 수 있습니다.

## Behavior

### Phase 0: 의존성 확인

실행 시 `frontend-slides` 스킬이 설치되어 있는지 확인한다.
- 있으면 → Phase 1 진행
- 없으면 → 설치 안내 메시지 출력 후 중단

### Phase 1: 입력 확인

**소스 판별:**

| 입력 유형 | 설명 | 예시 |
|----------|------|------|
| **교안 파일** | 기존 마크다운 교안을 슬라이드로 변환 | `/lesson-plan`으로 생성한 .md 파일 |
| **주제 직접 입력** | 주제를 받아 슬라이드 구성 | "제너레이티브 아트 소개" |
| **기존 슬라이드 수정** | 이미 만든 HTML 슬라이드 수정/보강 | 경로 지정 |

교안 파일이 있으면 읽고 내용을 파악한다.

**추가 질문 (필요시):**

> "슬라이드에 특별히 원하는 스타일이나 분위기가 있나요?"
>
> 없으면 교육용 기본 스타일을 적용합니다.

### Phase 2: 슬라이드 설계

교안 내용을 슬라이드 단위로 분할한다.

**강의 슬라이드 구성 원칙:**

1. **제목 슬라이드** — 수업 제목, 과목명, 날짜
2. **목차 슬라이드** — 오늘 다룰 내용 개요
3. **내용 슬라이드** — 개념별 1-3장
4. **레퍼런스 슬라이드** — 이미지/영상 중심
5. **실습 안내 슬라이드** — 실습이 있는 경우
6. **요약 슬라이드** — 핵심 정리
7. **다음 수업 예고** — 마지막 슬라이드

**슬라이드당 내용 밀도:**
- 텍스트: 핵심 키워드와 짧은 문장 위주 (교안의 상세 설명을 요약)
- 이미지: 가능한 크게, 슬라이드 면적의 50% 이상 활용
- 한 슬라이드에 하나의 개념만

### Phase 3: 미디어 임베딩 규칙

강의 슬라이드에서 가장 중요한 부분. 이미지와 영상이 올바르게 표시되어야 한다.

**이미지 임베딩:**
```html
<!-- 외부 이미지 -->
<img src="https://example.com/image.jpg"
     alt="작품 설명"
     style="max-height: min(60vh, 500px); width: auto; object-fit: contain;"
     loading="lazy"
     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
<div style="display:none; align-items:center; justify-content:center;
            height: min(60vh, 500px); background: rgba(255,255,255,0.05);
            border-radius: 8px; color: rgba(255,255,255,0.5); font-size: 0.9rem;">
  이미지를 불러올 수 없습니다
</div>
```

**영상 임베딩 (YouTube):**
```html
<div style="max-width: min(90%, 900px); aspect-ratio: 16/9; margin: 0 auto;">
  <iframe src="https://www.youtube.com/embed/VIDEO_ID"
          style="width: 100%; height: 100%; border: none; border-radius: 8px;"
          allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope"
          allowfullscreen></iframe>
</div>
```

**영상 임베딩 (Vimeo):**
```html
<div style="max-width: min(90%, 900px); aspect-ratio: 16/9; margin: 0 auto;">
  <iframe src="https://player.vimeo.com/video/VIDEO_ID"
          style="width: 100%; height: 100%; border: none; border-radius: 8px;"
          allow="autoplay; fullscreen; picture-in-picture"
          allowfullscreen></iframe>
</div>
```

**미디어 관련 주의사항:**
- 외부 이미지는 반드시 `onerror` 핸들러를 포함하여 로드 실패 시 fallback 표시
- 영상은 embed URL을 사용한다 (youtube.com/watch?v= → youtube.com/embed/)
- viewport 규칙을 준수한다: 이미지 `max-height: min(60vh, 500px)`, 영상 `max-height: min(60vh, 500px)`
- `loading="lazy"`로 초기 로딩 성능 확보

### Phase 4: 슬라이드 생성

`frontend-slides` 스킬의 워크플로우를 따른다:

1. **지원 파일 읽기** — `frontend-slides` 스킬의 다음 파일을 읽는다:
   - `html-template.md` — HTML 구조 및 JS 기능
   - `viewport-base.css` — 필수 CSS (전체 포함)
   - `animation-patterns.md` — 애니메이션 레퍼런스

2. **HTML 생성** — 단일 HTML 파일로 생성
   - `viewport-base.css` 전체를 `<style>` 태그에 포함
   - 키보드 네비게이션 (좌우 화살표, 스페이스바)
   - 슬라이드 번호 표시
   - 전체화면 지원

3. **교육용 추가 기능:**
   - 발표자 노트 토글 (N키) — `<div class="speaker-note">` 요소를 각 슬라이드에 포함 가능
   - 슬라이드 개요 오버레이 (O키) — 전체 슬라이드 썸네일 보기

### Phase 5: 전달

- HTML 파일을 저장한다
- 브라우저에서 자동으로 연다 (`open` 명령)
- 사용법을 안내한다:
  > - ← → 화살표: 슬라이드 이동
  > - N: 발표자 노트 토글
  > - O: 슬라이드 개요
  > - F: 전체화면
- 수정 사항이 있는지 확인한다
- PDF로 내보내려면 `/lecture-export`를 사용하라고 안내한다

## Style Guidelines for Lectures

교육용 슬라이드에 적합한 스타일:

- **가독성 우선**: 본문 폰트 최소 `clamp(1rem, 2.5vw, 1.5rem)`
- **대비**: 배경과 텍스트의 명확한 대비 (WCAG AA 이상)
- **여백**: 슬라이드 가장자리에 충분한 패딩 (`5vw` 이상)
- **색상 절제**: 주 색상 2-3개, 강조 색상 1개
- **코드 블록**: 프로그래밍 수업의 경우 구문 강조 포함
- **다크 테마 권장**: 강의실 프로젝터에서 눈의 피로도가 낮음

## Notes

- 이 스킬은 `frontend-slides` 스킬의 디자인 시스템 위에서 동작한다
- 교안이 없어도 주제만으로 슬라이드를 생성할 수 있다
- 교안에서 슬라이드를 만들 때 내용을 요약하여 키워드 중심으로 변환한다
- PDF 익스포트는 `/lecture-export` 스킬을 사용한다
