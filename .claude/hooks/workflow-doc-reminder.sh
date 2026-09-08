#!/usr/bin/env bash
#
# Author      : Myunggyun Kim (claude_workflow)
# Description : UserPromptSubmit 훅. docs/task · docs/brainstorming · docs/strategy 에
#               활성 워크플로 문서가 있으면 그 목록과 갱신 지시를 매 턴 주입한다.
#               문서가 하나도 없으면 아무것도 출력하지 않는다(무소음).
# Input       : stdin 으로 훅 이벤트 JSON (사용하지 않음). CLAUDE_PROJECT_DIR 환경변수.
# Output      : stdout 으로 hookSpecificOutput.additionalContext JSON. 없으면 무출력.
# Notes       : jq 비의존(이 환경에 jq 없음). 파일명의 \ 와 " 는 제거해 JSON 을 보호한다.
#               항상 exit 0 — 훅 실패가 사용자 턴을 막지 않게 한다.
# Date        : 2026-08-19
#
set -u

cd "${CLAUDE_PROJECT_DIR:-.}" 2>/dev/null || exit 0

docs=$(ls docs/task/*.md docs/brainstorming/*.md docs/strategy/*.md 2>/dev/null)
[ -z "$docs" ] && exit 0

list=""
while IFS= read -r f; do
    [ -z "$f" ] && continue
    # JSON 문자열을 깨뜨리는 문자만 제거한다. 경로 구분자 / 는 반드시 보존할 것.
    f=$(printf '%s' "$f" | tr -d '\\"')
    list="${list}  - ${f}\n"
done <<< "$docs"

msg="[활성 워크플로 문서 — 매 턴 확인]\n${list}"
msg="${msg}이번 턴에서 사용자가 답변·결정·정정한 내용이 있으면, 답하기 전에 위 문서를 먼저 고칠 것.\n"
msg="${msg}(1) 답이 나온 항목은 '## 사용자 확인 사항' 에서 '## 사용자 결정 사항' 으로 옮기고 그 결과를 적는다.\n"
msg="${msg}(2) 범위·파일목록·리스크·'## 요약' 등 본문에도 파급을 반영한다.\n"
msg="${msg}(3) 어느 문서를 어떻게 고쳤는지 답변에 밝힌다.\n"
msg="${msg}채팅에만 남긴 답은 유실된 작업이다. 사용자가 '문서 갱신했냐'고 물어야 했다면 규칙 위반이다."

printf '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"%s"}}\n' "$msg"
exit 0
