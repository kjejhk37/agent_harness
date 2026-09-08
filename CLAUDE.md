# Project Overview

`claude_workflow` is a reusable Task Delegation workflow framework for AI-assisted (Claude Code) development projects.

- It defines the collaboration process — task → brainstorming → strategy → implementation → commit report — used to delegate and track work.
- Consuming projects link this repository in as a git submodule and import this file from their own `CLAUDE.md` (e.g. `@claude_workflow/CLAUDE.md`), so the shared rules live in one place instead of being duplicated per project.
- This repository holds no project-specific content (no target codebase, no domain scope) — that belongs in the consuming project's own `CLAUDE.md`.

---

# Collaboration Principles

Do not unconditionally agree with the user's opinions.
Actively propose alternatives or improvements when a better approach exists.
If the user's direction carries risks or trade-offs, state them clearly before proceeding.

All implementation work requires user approval obtained through the Task Delegation workflow before proceeding.
Do not take any action beyond the scope approved in the strategy document without explicit user consent.

**Trigger rule:** any request phrased as an instruction to create/add/implement something (e.g. "~를 만들어줘", "~를 추가해줘", "~를 구현해줘") unconditionally starts the Task Delegation Workflow from Step 1 — no exception for requests that look small or simple.
Do not skip Step 1, and do not substitute it with ad-hoc clarifying questions (e.g. a multiple-choice tool) — collect the Task Document fields as plain text per Step 1 first.

If an unexpected situation arises during implementation — such as the need to add or remove functionality not covered in the strategy — stop immediately, notify the user, update the strategy .md to reflect the change, and resume only after re-approval.

---

# Document Update Protocol

**This is a behavioral rule, not a formatting rule. It fires on ordinary conversation, every turn.**

While any document exists under `data/docs/task/`, `data/docs/brainstorming/`, or `data/docs/strategy/`, a work cycle is ACTIVE.
While a cycle is active, the brainstorming and strategy .md files — not the chat — are the record.

## When it fires

Before replying, check whether the user's message contained ANY of these.

- An answer to a question you asked.
- A decision, a preference, or a choice between options.
- A correction of a fact, an assumption, or something you wrote.
- A new constraint, requirement, or a change of scope.
- A rejection — "no", "don't do that", "that's wrong".

If yes, the documents must change **before you reply**.

Do not wait for the user to say "update the document."
Do not ask whether to update it.
**If you are unsure whether this turn qualifies, it qualifies — update.**

The trigger is the *content of the user's message*, not whether the conversation felt like it was "about a document."
Most qualifying turns will feel like they are about the work, not about the file. They still qualify.

## What to do before replying

1. Move each answered item from `## 사용자 확인 사항` to `## 사용자 결정 사항`, recording what was decided and what it causes.
2. Propagate the consequence through the body — scope, file lists, checklist, tests, risks, and `## 요약`. An answer that shrinks or grows the work must change those sections too, not just the decision list.
3. Apply it to **every** document the answer touches. Two documents on the same topic must never disagree.
4. State in your reply which documents you changed and where.

## Why

A chat answer that is not written into the document is lost work — the next session starts from the file, not the transcript.
If the user has to ask "did you update the document?", the rule was already broken.

> A `UserPromptSubmit` hook (`.claude/hooks/workflow-doc-reminder.sh`) lists the active documents each turn.
> The hook is a reminder, not the rule — this section is the rule, and it binds even if the hook is disabled or the file list is empty.

---

# Reply Footer — Current Work Line

**Every reply ends with one line stating what is being worked on right now.**

The user runs several Claude sessions on several tasks in parallel.
This line is how they tell at a glance which session is on which job — so it must look identical in every session and never be skipped.

Write it as the very last line of the reply, after all other content, in this exact format.

```
**[현재 작업]** {한 줄 요약}
```

- Keep it to a single line — one short sentence, no bullets, no second line, no extra heading.
- Name the concrete job, not the category: `CLAUDE.md 문서 경로를 data/docs 로 치환 중` beats `문서 수정 중`.
- While a work cycle is active, lead with the step and the `{slug}`: `**[현재 작업]** [Step 3 전략서] 렌더러_분기 — 체크리스트 사용자 검토 대기`.
- When waiting on the user, say what is being waited on: `사용자 승인 대기` beats `대기 중`.
- When there is nothing in progress, write `**[현재 작업]** 없음 — 다음 지시 대기`.
- This applies to every reply without exception, including replies that only ask a question or report an error.
- Never expand it into a status report — a fixed one-line shape is the entire point.

---

# Custom Commands

- Task Delegation Workflow: [`.claude/commands/task_delegation.md`](.claude/commands/task_delegation.md)
- Code Review: [`.claude/commands/code_review.md`](.claude/commands/code_review.md)
- Marker Review: [`.claude/commands/marker_review.md`](.claude/commands/marker_review.md) — runs after the code review, an extension of the Task Delegation workflow.
- Git Workflow: [`.claude/commands/git_workflow.md`](.claude/commands/git_workflow.md) — Reference only if the file has been written.
- Dependency Evaluation: [`.claude/commands/dependency_eval.md`](.claude/commands/dependency_eval.md)

---

# .md Writing Rules

Write with the conclusion first (top-heavy structure).
Break each sentence onto its own line.
Use bullet points when listing examples or related items.

**Never point at something through a stand-in — an abbreviation, a code, or a pronoun. Write the name and the content in place.**

- Forbidden: "M9, R1 가 판독한 결과...", "위에서 말한 그것", "앞 항목과 동일", "결정 7과 같은 방식".
- The reason: a reader coming back to the document later cannot trace what `M9` or `R1` was. A document must read where it stands, without hunting back and forth through the file.
- Instead, write the name and the content of what you are pointing at, right there.
- When you genuinely must reference another item, do not write the number alone — add a phrase saying what that item is.
- This binds documents that are already written. Rewrite existing stand-ins when you touch a document.

Every .md ends with these three sections, in this order, as the very last content in the file.

This binds **every workflow document without exception** — task, brainstorming, strategy, commit, review, dependency — and any other .md you write.
Brainstorming and strategy documents are included: finishing one means writing these three, not just the discussion or the checklist.
The per-step definitions in `.claude/commands/task_delegation.md` never override this — if a step describes a different closing section, this rule wins.

- `## 요약` — the document's conclusion in a few bullets. It must stand on its own: a reader who skips the body still gets the verdict.
- `## 사용자 결정 사항` — decisions the user has already made, as a numbered list. Each item: what was decided, and what it causes. This is a permanent record; never demote it to a footnote, a strikethrough line, or a parenthetical.
- `## 사용자 확인 사항` — items still waiting on the user, as a numbered list. Phrase each as a question, attach the recommended answer, and state what changes depending on the answer. Write `없음` only when there is genuinely nothing left to confirm.

Keep the two lists separate.
A decided item moves from `사용자 확인 사항` to `사용자 결정 사항` — it does not stay in both, and it does not disappear.

Never bury an open question in the body alone.
If it needs a human decision, it must also appear in `## 사용자 확인 사항`.

These are formatting rules — *what a finished document looks like*.
*When* you must go back and rewrite one is a behavioral rule, defined in `# Document Update Protocol` above.

---

# Comment Writing Rules

Every function and class comment must include the following.

- Author
- Function/Class description
- Input description
- Output description
- Notes (trade-offs and risks)
- Date written

---

# Document Naming Convention

Every workflow document (task, brainstorming, strategy, commit, review, marker review) is named `{slug}_YYYYMMDD_HHMM.md`, where `{slug}` is a short content summary of the work cycle's topic (e.g. `렌더러_분기`, `main진입점_설정`) — never the literal word "summary".

- Derive `{slug}` from the Task Document's Purpose when writing the task .md.
- Reuse the identical `{slug}` for every later-stage document (brainstorming/strategy/commit/review/marker_review) in the same work cycle, so cross-reference links and the archive folder name stay traceable to one cycle at a glance.
- The archive folder name reuses the same `{slug}`: `data/docs/archive/{slug}_YYYYMMDD/`.

---

# Document Archiving

When a full work cycle is complete — task, brainstorming, strategy, implementation, and commit report all finalized — move the related documents into an archive folder to prevent Claude from loading unnecessary context during session recovery.

Archive by preserving the folder structure as a group so that relative paths between documents remain intact.

Archive destination: `data/docs/archive/{slug}_YYYYMMDD/`

Maintain the internal structure as follows.

```
data/docs/archive/{slug}_YYYYMMDD/
  task/{slug}_YYYYMMDD_HHMM.md
  brainstorming/{slug}_YYYYMMDD_HHMM.md
  strategy/{slug}_YYYYMMDD_HHMM.md
  commit/{slug}_YYYYMMDD_HHMM.md
  review/{slug}_YYYYMMDD_HHMM.md          (if a code_review.md report was written for this cycle)
  marker_review/{slug}_YYYYMMDD_HHMM.md   (if a marker_review.md feedback document was written for this cycle)
```

`data/docs/dependency/` is excluded from archiving. Unlike task/brainstorming/strategy/commit/review, a dependency evaluation documents a decision that stays relevant for as long as the project depends on that library — not just for the cycle that introduced it. Keep `data/docs/dependency/*.md` at its top-level location permanently, as a cumulative project-wide registry, even after the cycle that produced it is archived.

A cycle is considered complete when all of the following conditions are met.

- All checklist items in the strategy document are marked `[x]`.
- All issues in the commit report are marked `[RESOLVED]` or `[DEFERRED]`.
- If a marker review was run: every marker is approved, and the `[승인됨]` marks and `[CLAUDE-EDIT-OLD]` blocks have been stripped from the code. The `[CLAUDE-EDIT]` markers themselves stay in the code permanently and are not a completion condition.

Mark an issue as `[DEFERRED]` when the user explicitly decides to postpone it to a future cycle.

During session recovery, read only the active documents in `data/docs/`.
Documents in `data/docs/archive/` are referenced only when the user explicitly requests it.

---

# Session Recovery

By default, the user reviews the implementation report in `data/docs/commit/` and delegates the next task.

Issues in the commit report follow a 3-stage lifecycle.

- Open — reported but no work delegated yet. Displayed with the original severity grade (e.g. `[CRITICAL]`).
- In Progress — a task delegation has been started to address the issue. Update the entry as follows.
- Resolved — the fixing work is complete. Update the entry as follows.

```
- [IN PROGRESS] Application crashes on startup when config file is missing.
  → task: ../task/{slug}_YYYYMMDD_HHMM.md

- [RESOLVED] Application crashes on startup when config file is missing.
  → resolved in: ../strategy/{slug}_YYYYMMDD_HHMM.md
```

Commit report issues are also split by origin into three sections — `### 1. 신규 이슈 (독립)` / `### 2. 기존 이슈` / `### 3. 신규 이슈 (기존 코드 연계)` — as defined in `.claude/commands/task_delegation.md` § Step 5.

- The severity grade and the 3-stage lifecycle above apply within each section.
- Issues under `### 2. 기존 이슈` and `### 3. 신규 이슈 (기존 코드 연계)` are never picked up on their own initiative. Whether they are fixed and when is the user's decision.

If the user requests a session recovery, read the following documents in order and present recommendations before proceeding.

- `data/docs/task/` — Review the original task document.
- `data/docs/brainstorming/` — Review the goals and trade-offs that were established.
- `data/docs/strategy/` — Identify which checklist items were approved (`(승인됨)`) and which were completed (`[x]`).
- `data/docs/commit/` — Review the implementation results and any outstanding issues by origin classification and severity.
- `data/docs/marker_review/` — Review which markers were approved and what feedback is still unapplied.

Based on the above, recommend the next action to the user.
Do not begin any work until the user confirms the direction.

---

# Project Initial Setup

If a project initial setup .md does not exist, confirm the following items, write the document, and reference it by relative path.

- User language (e.g. Korean, English, Japanese)
- Development language (e.g. Python, C++, C#, Rust)
- Base architecture (if none exists, recommend one based on project purpose and scalability)

---

# Core Development Principles

**Follow SOLID principles strictly. Apply the Single Responsibility Principle (SRP) with particular rigor.**
This ensures that developers can clearly understand AI-generated code after the fact.

**Always wrap external libraries in internal wrapper classes.**
This minimizes the scope of changes when an unverified library causes errors.
Define an internal class that owns and encapsulates all interactions with the external library.
Other modules must not reference the external library directly.

**Write unit tests for every developed feature.**
Whenever a feature is added or modified, run the build and unit tests without exception.
