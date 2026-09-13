# Codex에서 Agent Harness 사용하기

Codex는 이 파일과 같은 디렉터리의 `CLAUDE.md`를 먼저 읽고 공통 작업 절차를 따른다.
이 파일은 공통 절차의 복제본이 아니라 Codex용 연결 지침이다.

## 파일과 경로 해석

- Harness 루트는 이 `CODEX.md`가 있는 디렉터리다.
- 공통 지침은 Harness 루트의 `CLAUDE.md`, 절차 문서는 Harness 루트의 `.claude/commands/*.md`다.
- 소비 프로젝트에서 작업할 때 `docs/`, 대상 코드, Git 명령의 기준은 소비 프로젝트 루트다.
- 기존 문서의 `claude_workflow/CLAUDE.md`는 설치 폴더 이름과 관계없이 Harness 루트의 `CLAUDE.md`를 뜻한다.
- 소비 프로젝트의 `CLAUDE.md`에 `@경로`가 있으면 해당 파일을 직접 읽는다.
  순환 참조는 이미 읽은 경로를 기록해 중복 로딩하지 않는다.
- 소비 프로젝트 고유 규칙을 함께 읽고, 상위 시스템 지침과 사용자의 명시적 지시를 우선한다.

## 워크플로우 실행

사용자가 해당 작업을 요청하면 아래 원본 문서를 읽고 절차를 수행한다.
`.claude/commands`를 복사하거나 Codex의 슬래시 명령으로 자동 등록되었다고 가정하지 않는다.

| 작업 | Harness 루트 기준 원본 |
|---|---|
| 작업 위임 | `.claude/commands/task_delegation.md` |
| 지침 변경 | `.claude/commands/guideline_delegation.md` |
| 코드 리뷰 | `.claude/commands/code_review.md` |
| 마커 리뷰 | `.claude/commands/marker_review.md` |
| 저장소 간 작업 | `.claude/commands/team_task_delegation.md` |
| 의존성 검토 | `.claude/commands/dependency_eval.md` |
| 다이어그램 | `.claude/commands/diagram_delegation.md` |
| 디버깅 | `.claude/commands/debug.md` |
| 리팩터링 | `.claude/commands/refactor.md` |
| Git 참고 절차 | `.claude/commands/git_workflow.md` |

## Claude 전용 동작의 처리

- `.claude/settings.json`과 `.claude/hooks/workflow-doc-reminder.sh`는 이 연결만으로 Codex에서 실행되지 않는다.
  매 턴 작업 프로젝트의 `docs/task/`, `docs/brainstorming/`, `docs/strategy/`에서 활성 문서를 확인하고, `CLAUDE.md`의 Document Update Protocol에 따라 사용자 결정과 정정을 관련 문서에 반영한다.
  hook이 실행되었다고 보고하지 않는다.
- 문서의 Claude라는 수행자 이름은 Codex가 작업할 때 현재 에이전트로 해석한다.
  기존 `[CLAUDE-EDIT]`와 `[CLAUDE-EDIT-OLD]` 문자열은 호환성을 위한 마커이므로 임의로 바꾸지 않는다.
- Codex 단독 작업에 Claude의 `Co-Authored-By`를 붙이지 않는다.
  Git에 설정된 작성자를 유지하고, 실제 기여하지 않은 에이전트를 공동 작성자로 기록하지 않는다.
- 승인 상태, 티켓, 문서 경로와 리뷰 절차는 기존 공통 규칙을 유지한다.
  도구가 없거나 실행이 막혔으면 수행했다고 주장하지 않고 제한을 보고한다.

## 소비 프로젝트 연결

소비 프로젝트 루트에 `AGENTS.md`를 두고 실제 설치 경로를 사용해 다음처럼 명시한다.
서브모듈 안의 `AGENTS.md`만으로 소비 프로젝트 루트의 세션에 공통 규칙이 자동 적용되지는 않는다.

```markdown
# 프로젝트 지침

작업 전에 이 프로젝트의 CLAUDE.md와 agent_harness/CODEX.md를 직접 읽고 적용한다.
agent_harness/CODEX.md가 지정하는 공통 CLAUDE.md와 작업에 필요한 절차 문서도 읽는다.
작업 산출물 docs/와 Git 명령의 기준은 이 프로젝트 루트다.
```

다른 폴더 이름으로 설치했다면 `agent_harness/CODEX.md`를 실제 상대 경로로 바꾼다.
서브모듈이 비어 있으면 초기화가 필요하다고 알리고 지침 없이 작업을 진행하지 않는다.

## 확인 방법

새 Codex 세션을 이 저장소 루트에서 시작하고 “적용 중인 지침 파일과 활성 작업 문서를 나열해줘”라고 요청한다.
`AGENTS.md`, `CODEX.md`, `CLAUDE.md`를 읽고, 요청 작업에 해당하는 `.claude/commands` 원본을 선택하는지 확인한다.
소비 프로젝트에서는 프로젝트의 `CLAUDE.md`와 설치된 Harness 파일을 함께 읽는지 확인한다.
실제 구현이나 push를 실행하지 않는 읽기 전용 확인으로 시작한다.

공식 근거: [OpenAI의 AGENTS.md 지침 탐색 문서](https://learn.chatgpt.com/docs/agent-configuration/agents-md).
자동 탐색 진입점은 `AGENTS.md`이며, `CODEX.md`는 이 저장소의 진입점이 명시적으로 읽도록 지정한 문서다.
`Clodex.md`라는 별도 자동 인식 파일은 사용하지 않는다.

## 요약

- 기존 `CLAUDE.md`와 절차 문서를 Codex가 직접 읽어 재사용한다.
- Claude hook 실행을 대신하는 문서 확인 규칙을 제공하며, hook 자동 실행이나 명령 등록까지 제공하는 연결은 아니다.
- 소비 프로젝트는 루트 `AGENTS.md`에서 Harness를 명시적으로 연결해야 한다.

## 사용자 결정 사항

1. Codex 호환 연결을 추가하고 Harness 저장소에 push한다.
2. Harness 과정 개선 의견은 별도 문서로만 작성하고 기존 절차에는 적용하지 않는다.

## 사용자 확인 사항

없음
