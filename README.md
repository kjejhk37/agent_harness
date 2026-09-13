# claude_workflow

Claude Code로 AI 보조 개발을 진행할 때 사용하는 재사용 가능한 Task Delegation 워크플로우 프레임워크입니다.

---

## 개요

- Task → Brainstorming → Strategy → Implementation → Commit Report로 이어지는 작업 위임 절차를 정의합니다.
- 특정 프로젝트의 코드베이스나 도메인 내용은 포함하지 않습니다 — 여러 프로젝트에서 공통으로 쓰는 워크플로우/규칙만 다룹니다.
- 사용하는 프로젝트는 이 저장소를 git submodule로 연동하고, 자신의 `CLAUDE.md`에서 `@claude_workflow/CLAUDE.md`로 import해서 공통 규칙을 가져다 씁니다.

## 문서 및 워크플로우

작업 절차, 문서 구조, 협업 원칙은 [`CLAUDE.md`](./CLAUDE.md)를 참고하세요.

## Codex 사용

Codex는 루트 [`AGENTS.md`](./AGENTS.md)를 진입점으로 삼아 [`CODEX.md`](./CODEX.md)와 기존 `CLAUDE.md`를 읽습니다.
소비 프로젝트 연결 방법과 Claude 전용 hook·명령의 차이는 `CODEX.md`에서 확인하세요.

## 요약

- Claude와 Codex가 기존 공통 워크플로우 문서를 재사용합니다.

## 사용자 결정 사항

1. Codex에서도 기존 Harness를 사용할 수 있도록 연결 파일을 추가합니다.

## 사용자 확인 사항

없음
