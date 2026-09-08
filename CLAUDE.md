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

While any document exists under `docs/task/`, `docs/brainstorming/`, or `docs/strategy/`, a work cycle is ACTIVE.
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
- Name the concrete job, not the category: `CLAUDE.md 문서 경로를 docs 로 치환 중` beats `문서 수정 중`.
- While a work cycle is active, lead with the step and the `{slug}`: `**[현재 작업]** [Step 3 전략서] 렌더러_분기 — 체크리스트 사용자 검토 대기`.
- When waiting on the user, say what is being waited on: `사용자 승인 대기` beats `대기 중`.
- When there is nothing in progress, write `**[현재 작업]** 없음 — 다음 지시 대기`.
- This applies to every reply without exception, including replies that only ask a question or report an error.
- Never expand it into a status report — a fixed one-line shape is the entire point.
# Git — Trigger-Based

When the user asks Claude to commit or push (e.g. "push 해줘", "커밋해줘", "올려줘"), Claude runs the full `git add` / `git commit` / `git push` sequence itself, immediately.

- Do not decline, do not substitute it with "here are the commands, run them yourself", do not re-ask "are you sure" for an ordinary docs/code push.
- The request is the trigger and the authorization.

This is trigger-based, not autonomous — without a request, Claude does not commit/push on its own; it finishes the file changes and says they are ready to push (no wall of hand-off commands).

- Commit straight to `main` — the established pattern in every repo here; do not branch first unless asked.
- End commit messages with `Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>`.
- Submodule chains: push the dependency repo first, then `git submodule update --remote` and commit the pointer in each consumer.
- Refuse only genuinely dangerous ops (history rewrite, force-push, remote branch deletion) without explicit confirmation.

---

# Custom Commands

- Task Delegation Workflow: [`.claude/commands/task_delegation.md`](.claude/commands/task_delegation.md)
- Code Review: [`.claude/commands/code_review.md`](.claude/commands/code_review.md)
- Marker Review: [`.claude/commands/marker_review.md`](.claude/commands/marker_review.md) — runs after the code review, an extension of the Task Delegation workflow.
- Team Task Delegation Workflow: [`.claude/commands/team_task_delegation.md`](.claude/commands/team_task_delegation.md) — Cross-repo coordination between `platform` / `graphics` / `projects` repos. Independent of Task Delegation Workflow; only triggered from that workflow's Step 3 when a Strategy checklist item is tagged `[platform]` / `[graphics]` / `[mixed]`.
- Git Workflow: [`.claude/commands/git_workflow.md`](.claude/commands/git_workflow.md) — Reference only if the file has been written.
- Dependency Evaluation: [`.claude/commands/dependency_eval.md`](.claude/commands/dependency_eval.md)
- Guideline Delegation: [`.claude/commands/guideline_delegation.md`](.claude/commands/guideline_delegation.md) — Workflow for changing this repository's own guidelines (`CLAUDE.md`, `.claude/commands/*.md`, `.claude/hooks/*`). Guideline changes do **not** go through the Task Delegation Workflow: this repo holds no code, so Before/After code, `[CLAUDE-EDIT]` markers, Marker Review, and unit tests have nothing to act on. Its distinctive steps are the Step 2 sweep for rule exceptions and silent risks, and the Step 4 submodule propagation that follows.
- Diagram Delegation: [`.claude/commands/diagram_delegation.md`](.claude/commands/diagram_delegation.md) — User-triggered workflow that produces a dated architecture-diagram document (`docs/DiagramDelegation/diagrams/{slug}_YYYYMMDD_HHMM.md`), with an optional macro architecture review as Step 3. Independent of Task Delegation Workflow; never runs automatically.

---

# Cross-Repo Roles (Team Task Delegation)

This repository's consuming projects form a one-directional dependency chain: `platform → graphics → projects`, linked via git submodules (`projects` submodules `graphics` and `platform`; `graphics` submodules `platform`).

A repo's role in Team Task Delegation depends on which cross-repo item is being handled, not on which "department" it is — the same repo can be a requester in one exchange and a target in another.

- `platform` — always a target, never a requester (nothing is upstream of it).
- `graphics` — a target when `projects` requests from it; a requester when it needs `platform` to complete a `[mixed]` item (see `team_task_delegation.md` Step 5).
- `projects` — always a requester toward `platform`/`graphics`, never a target (nothing is downstream of it).

Whichever role applies for a given exchange, follow `team_task_delegation.md` Steps 1–4 for the requester side and Step 3 for the target side.

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

# Docs Directory Layout

The Task Delegation documents sit directly under `docs/`.
The other delegators get their own folder there, so content is separated by which delegator produced it.

```
docs/
  task/
  brainstorming/
  strategy/
  commit/
  review/
  marker_review/
  architecture/                            (hand-maintained architecture notes tied to this repo's strategies)
  archive/{slug}_YYYYMMDD/
  dependency/                              (see Dependency Evaluation below)

  TeamTaskDelegation/
    inbox/
    outbox/

  DiagramDelegation/
    diagrams/

  GuidelineDelegation/
    changes/
```

- The Task Delegation folders are **not** nested under a `TaskDelegation/` folder. They stay flat under `docs/` because `.claude/hooks/workflow-doc-reminder.sh` reads `docs/task`, `docs/brainstorming`, and `docs/strategy` directly on every turn. Nesting them would silently break that reminder.
- `dependency/` stays directly under `docs/`, not nested under any delegator folder — a dependency evaluation is project/repo-scoped rather than tied to one delegator's workflow.
- `TeamTaskDelegation/` holds only the cross-repo request/response exchange (`inbox/`/`outbox/`). Once a request is received, the target repo processes it as its own Task Delegation cycle (task/brainstorming/strategy/commit/review/marker_review) — that content lives in the flat folders above, never duplicated under `TeamTaskDelegation/`, regardless of whether the cycle was triggered by a normal user request or by an inbound request document.
- `DiagramDelegation/diagrams/` holds only the dated diagram snapshots that `diagram_delegation.md` produces. It is never archived — see Document Archiving below.
- `GuidelineDelegation/changes/` holds only the dated records that `guideline_delegation.md` produces — what a guideline change touched, what the impact sweep found, and what was deliberately left alone. It is never archived, for the same reason the diagram snapshots are not: a rule's rationale is asked about long after the change that introduced it.

---

# Ticket — Cross-Repo Correlation Key

Every work cycle carries a **ticket**: one identifier that stays attached to the cycle from its task document through to the `[CLAUDE-EDIT]` markers left in the code.

A ticket is a correlation key, not an issue tracker.
It carries no status, no assignee, and no priority — those belong to the workflow documents themselves.

Format:

```
{YYYYMMDD_HHMM}-{repo}-{slug}
20260908_2100-wot-renderer_split
```

- `{YYYYMMDD_HHMM}` is the moment the task document is written. The timestamp comes first because `team_task_delegation.md` Step 3 sorts request branches by name to get arrival order — moving it out of the first position would silently break that sort.
- `{repo}` is this repository's alias from the table below. It is what makes the ticket unique without a central allocator, since consuming repos cannot see each other at allocation time.
- `{slug}` is the same slug the cycle's documents use (see Document Naming Convention below). It is what makes a marker readable — a ticket sitting in a code comment must say what the change was.

**The ticket is allocated exactly once, at the cycle's first step, and never re-derived.**

That first step is `task_delegation.md` Step 1 for code work, and `guideline_delegation.md` Step 1 for a change to this repository's own guidelines.

Step 1 is the only step that runs exactly once per cycle.
Step 2 loops until approval, Step 3 can send the cycle back to Step 2, and Marker Review's Route B sends it back to Step 3 with no cap on repeats.
An identifier allocated at a re-entrant step would drift between rounds, and drifting names are exactly what makes markers impossible to aggregate.

**A target repo inherits the ticket. It never allocates one.**

`team_task_delegation.md` Step 3 treats the request document as the Step 1 (Task) input to the target repo's own cycle, so the target repo starts at Step 2 and writes no task document of its own.
The ticket therefore has a single point of allocation, on the requester's side, and the same key spans both repos.
Markers the target repo leaves carry the requester's alias — that is the point, since the marker records which request caused the code.

Sequential ticket numbers are deliberately not used.
A counter needs an allocator, and this repository is a submodule with no server and no shared state, so consuming repos would collide.
GitHub issue numbers are per-repo, which makes `#12` ambiguous across the chain.

## Repo Aliases

| Alias | Repository |
|---|---|
| `platform` | platform |
| `graphics` | graphics |
| `wot` | World-of-Tank-imitation-Refactoring |

These are the aliases the repository already used before tickets existed — `platform` and `graphics` from Cross-Repo Roles above, `wot` from the `request/` branch example.
A repository not listed here uses its own repository name until an alias is added to this table.
The alias is lowercase, short, and unique across the chain.
The same alias is used in the ticket and in the `request/` branch name — they are the same string.

## Where the Ticket Appears

- The `Ticket` field at the top of every workflow document in the cycle.
- The `request/` branch name, and the request and response document filenames, in `team_task_delegation.md`.
- Every `[CLAUDE-EDIT]` marker the cycle produces. A change made outside a delegation cycle has no ticket and falls back to the 작업명 form — see `task_delegation.md` § Change Markers.
- The checklist item in the requester's strategy document that the request unblocks.

**Never use the ticket as a stand-in in prose.**

Writing "the change from 20260908_2100-wot-renderer_split" in place of naming what the change was violates the stand-in ban in § .md Writing Rules above.
The ticket belongs in filenames, header fields, and markers — places where a reader is looking a cycle up, not reading a sentence.

---

# Document Naming Convention

Every workflow document (task, brainstorming, strategy, commit, review, marker review) is named `{slug}_YYYYMMDD_HHMM.md`, where `{slug}` is a short content summary of the work cycle's topic (e.g. `렌더러_분기`, `main진입점_설정`) — never the literal word "summary".

- Derive `{slug}` from the Task Document's Purpose when writing the task .md.
- Reuse the identical `{slug}` for every later-stage document (brainstorming/strategy/commit/review/marker_review) in the same work cycle, so cross-reference links and the archive folder name stay traceable to one cycle at a glance.
- The archive folder name reuses the same `{slug}`: `docs/archive/{slug}_YYYYMMDD/`.
- Write the cycle's ticket as a `Ticket` field at the top of every one of these documents. The filename carries the slug; the header carries the full ticket, so a document found on its own still names the repo and the moment it belongs to.

---

# Document Archiving

When a full work cycle is complete — task, brainstorming, strategy, implementation, and commit report all finalized — move the related documents into an archive folder to prevent Claude from loading unnecessary context during session recovery.

Archive by preserving the folder structure as a group so that relative paths between documents remain intact.

Archive destination: `docs/archive/{slug}_YYYYMMDD/`

Maintain the internal structure as follows.

```
docs/archive/{slug}_YYYYMMDD/
  task/{slug}_YYYYMMDD_HHMM.md
  brainstorming/{slug}_YYYYMMDD_HHMM.md
  strategy/{slug}_YYYYMMDD_HHMM.md
  commit/{slug}_YYYYMMDD_HHMM.md
  review/{slug}_YYYYMMDD_HHMM.md          (if a code_review.md report was written for this cycle)
  marker_review/{slug}_YYYYMMDD_HHMM.md   (if a marker_review.md feedback document was written for this cycle)
```

`docs/GuidelineDelegation/changes/` is excluded from archiving, as is `docs/DiagramDelegation/diagrams/`.

`docs/dependency/` is excluded from archiving. Unlike task/brainstorming/strategy/commit/review, a dependency evaluation documents a decision that stays relevant for as long as the project depends on that library — not just for the cycle that introduced it. Keep `docs/dependency/*.md` at its top-level location permanently, as a cumulative project-wide registry, even after the cycle that produced it is archived.

`docs/architecture/` and `docs/DiagramDelegation/diagrams/` are excluded from archiving for the same reason. The former holds hand-maintained architecture notes; the latter holds the dated diagram snapshots produced by `diagram_delegation.md`. Both are permanent reference material — the diagram snapshots in particular are a cumulative time series, where each run adds a new dated file and never overwrites or archives an older one, so that silent architectural drift stays visible in diff.

A cycle is considered complete when all of the following conditions are met.

- All checklist items in the strategy document are marked `[x]`.
- All issues in the commit report are marked `[RESOLVED]` or `[DEFERRED]`.
- If a marker review was run: every marker is approved, and the `[승인됨]` marks and `[CLAUDE-EDIT-OLD]` blocks have been stripped from the code. The `[CLAUDE-EDIT]` markers themselves stay in the code permanently and are not a completion condition.

Mark an issue as `[DEFERRED]` when the user explicitly decides to postpone it to a future cycle.

During session recovery, read only the active documents in `docs/`.
Documents in `docs/archive/` are referenced only when the user explicitly requests it.

---

# Session Recovery

By default, the user reviews the implementation report in `docs/commit/` and delegates the next task.

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

- `docs/task/` — Review the original task document.
- `docs/brainstorming/` — Review the goals and trade-offs that were established.
- `docs/strategy/` — Identify which checklist items were approved (`(승인됨)`) and which were completed (`[x]`).
- `docs/commit/` — Review the implementation results and any outstanding issues by origin classification and severity.
- `docs/marker_review/` — Review which markers were approved and what feedback is still unapplied.

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
