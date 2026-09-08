# docs 디렉토리 안내

**이 폴더는 어떤 딜리게이터가 만든 문서인지에 따라 나뉜다.**

Task Delegation 문서는 `docs/` 바로 아래에 평평하게 둔다.
나머지 딜리게이터는 자기 폴더를 하나씩 갖는다.

구조의 정본은 `CLAUDE.md` 의 `# Docs Directory Layout` 절이다.
이 문서는 그 구조를 폴더 옆에서 바로 읽기 위한 안내다.
둘이 어긋나면 `CLAUDE.md` 를 따른다.

**폴더는 미리 만들어 두지 않는다.**

문서를 처음 쓸 때 그 자리에서 만든다.
아래 목록은 앞으로 생길 자리의 지도이지, 지금 존재하는 폴더의 목록이 아니다.

---

## 폴더

Task Delegation 사이클이 만드는 문서는 다음 폴더에 들어간다.

- `task/` : Task 문서.
- `brainstorming/` : 브레인스토밍 문서.
- `strategy/` : 전략서.
- `commit/` : 구현 결과와 이슈 리포트.
- `review/` : 코드 리뷰 리포트.
- `marker_review/` : 마커 리뷰 리포트.
- `architecture/` : 손으로 관리하는 아키텍처 노트.
- `archive/{slug}_YYYYMMDD/` : 사이클이 끝난 문서 묶음.
- `dependency/` : 의존성 평가 문서.

다른 딜리게이터의 문서는 자기 폴더 아래에 들어간다.

- `TeamTaskDelegation/inbox/` : 다른 저장소에서 들어온 요청 문서.
- `TeamTaskDelegation/outbox/` : 이쪽에서 내보낸 응답 문서.
- `DiagramDelegation/diagrams/` : 날짜별 다이어그램 스냅샷.

---

## 알아 둘 것

**Task Delegation 폴더를 `TaskDelegation/` 아래로 옮기면 안 된다.**

`.claude/hooks/workflow-doc-reminder.sh` 가 매 턴 `docs/task`, `docs/brainstorming`, `docs/strategy` 를 직접 읽는다.
한 겹 감싸면 이 리마인더가 조용히 죽는다.
폴더가 아직 없는 상태는 문제되지 않는다. 훅이 조회 실패를 삼키고 아무것도 출력하지 않는다.

**`dependency/` 는 딜리게이터 폴더 밑으로 내리지 않는다.**

의존성 평가는 한 딜리게이터의 사이클이 아니라 저장소 전체에 걸리는 결정이다.
아카이브 대상도 아니다.

**`DiagramDelegation/diagrams/` 는 아카이브하지 않는다.**

스냅샷이 날짜별로 쌓여야 구조 변화가 diff 로 드러난다.
기존 스냅샷을 고치지 않고 새 날짜 파일을 추가한다.

**`TeamTaskDelegation/` 에는 주고받은 요청·응답 문서만 둔다.**

요청을 받은 저장소가 그것을 처리하는 과정은 그 저장소 자신의 Task Delegation 사이클이다.
그 산출물은 위의 평평한 폴더에 들어가고, `TeamTaskDelegation/` 아래에 복제하지 않는다.

---

## 요약

- `docs/` 는 문서를 만든 딜리게이터 기준으로 나뉜다.
- Task Delegation 문서 9종은 `docs/` 바로 아래 평평하게 두고, Team Task Delegation 과 Diagram Delegation 은 자기 폴더를 갖는다.
- 폴더는 미리 만들지 않고 문서를 처음 쓸 때 만든다. 위 목록은 자리의 지도다.
- `docs/task`, `docs/brainstorming`, `docs/strategy` 경로는 훅이 직접 읽으므로 한 겹 더 감싸면 안 된다.
- `dependency/` 와 `DiagramDelegation/diagrams/` 는 아카이브 대상이 아니다.
- 구조의 정본은 `CLAUDE.md` 의 `# Docs Directory Layout` 절이고, 이 문서는 안내용이다.

## 사용자 결정 사항

1. 워크플로 문서 경로를 `data/docs/` 가 아니라 `docs/` 로 되돌리기로 했다. 그 결과 훅이 읽는 경로와 문서가 놓이는 경로가 다시 일치한다.
2. Task Delegation 폴더를 `TaskDelegation/` 로 감싸지 않고 `docs/` 바로 아래 평평하게 두기로 했다. 그 결과 `workflow-doc-reminder.sh` 가 경로 수정 없이 그대로 동작한다.
3. 문서가 없는 빈 폴더를 저장소에 두지 않기로 했다. `.gitkeep` 11개를 지웠고, 그 결과 `docs/` 에는 실제 문서가 있는 자리만 남는다. 나머지 폴더는 첫 문서를 쓸 때 생긴다.

## 사용자 확인 사항

1. 없음.
