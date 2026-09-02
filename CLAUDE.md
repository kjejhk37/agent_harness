# Project Overview

`agent_harness` is a reusable Task Delegation workflow framework for AI-assisted (Claude Code) development projects.

- It defines the collaboration process — task → brainstorming → strategy → implementation → commit report — used to delegate and track work.
- Consuming projects link this repository in as a git submodule and import this file from their own `CLAUDE.md` (e.g. `@agent_harness/CLAUDE.md`), so the shared rules live in one place instead of being duplicated per project.
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
- Team Task Delegation Workflow: [`.claude/commands/team_task_delegation.md`](.claude/commands/team_task_delegation.md) — Cross-repo coordination between `platform` / `graphics` / `projects` repos. Independent of Task Delegation Workflow; only triggered from that workflow's Step 3 when a Strategy checklist item is tagged `[platform]` / `[graphics]` / `[mixed]`.
- Git Workflow: [`.claude/commands/git_workflow.md`](.claude/commands/git_workflow.md) — Reference only if the file has been written.
- Dependency Evaluation: [`.claude/commands/dependency_eval.md`](.claude/commands/dependency_eval.md)
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

`docs/` is organized by which delegator produced the content, not flatly.

```
docs/
  dependency/                              (top-level — see Dependency Evaluation below)

  TaskDelegation/
    task/
    brainstorming/
    strategy/
    commit/
    review/
    architecture/                          (hand-maintained architecture notes tied to this repo's strategies)
    archive/{slug}_YYYYMMDD/

  TeamTaskDelegation/
    inbox/
    outbox/

  DiagramDelegation/
    diagrams/
```

- `dependency/` stays directly under `docs/`, not nested under any delegator folder — a dependency evaluation is project/repo-scoped rather than tied to one delegator's workflow.
- `TeamTaskDelegation/` holds only the cross-repo request/response exchange (`inbox/`/`outbox/`). Once a request is received, the target repo processes it as its own `TaskDelegation` cycle (task/brainstorming/strategy/commit/review) — that content lives under `TaskDelegation/`, never duplicated under `TeamTaskDelegation/`, regardless of whether the cycle was triggered by a normal user request or by an inbound request document.
- `DiagramDelegation/diagrams/` holds only the dated diagram snapshots that `diagram_delegation.md` produces. It is never archived — see Document Archiving below.

---

# Document Naming Convention

Every workflow document (task, brainstorming, strategy, commit, review) is named `{slug}_YYYYMMDD_HHMM.md`, where `{slug}` is a short content summary of the work cycle's topic (e.g. `렌더러_분기`, `main진입점_설정`) — never the literal word "summary".

- Derive `{slug}` from the Task Document's Purpose when writing the task .md.
- Reuse the identical `{slug}` for every later-stage document (brainstorming/strategy/commit/review) in the same work cycle, so cross-reference links and the archive folder name stay traceable to one cycle at a glance.
- The archive folder name reuses the same `{slug}`: `docs/TaskDelegation/archive/{slug}_YYYYMMDD/`.

---

# Document Archiving

When a full work cycle is complete — task, brainstorming, strategy, implementation, and commit report all finalized — move the related documents into an archive folder to prevent Claude from loading unnecessary context during session recovery.

Archive by preserving the folder structure as a group so that relative paths between documents remain intact.

Archive destination: `docs/TaskDelegation/archive/{slug}_YYYYMMDD/`

Maintain the internal structure as follows.

```
docs/TaskDelegation/archive/{slug}_YYYYMMDD/
  task/{slug}_YYYYMMDD_HHMM.md
  brainstorming/{slug}_YYYYMMDD_HHMM.md
  strategy/{slug}_YYYYMMDD_HHMM.md
  commit/{slug}_YYYYMMDD_HHMM.md
  review/{slug}_YYYYMMDD_HHMM.md   (if a code_review.md report was written for this cycle)
```

`docs/dependency/` is excluded from archiving. Unlike task/brainstorming/strategy/commit/review, a dependency evaluation documents a decision that stays relevant for as long as the project depends on that library — not just for the cycle that introduced it. Keep `docs/dependency/*.md` at its top-level location permanently, as a cumulative project-wide registry, even after the cycle that produced it is archived.

`docs/TaskDelegation/architecture/` and `docs/DiagramDelegation/diagrams/` are excluded from archiving for the same reason. The former holds hand-maintained architecture notes; the latter holds the dated diagram snapshots produced by `diagram_delegation.md`. Both are permanent reference material — the diagram snapshots in particular are a cumulative time series, where each run adds a new dated file and never overwrites or archives an older one, so that silent architectural drift stays visible in diff.

A cycle is considered complete when all of the following conditions are met.

- All checklist items in the strategy document are marked `[x]`.
- All issues in the commit report are marked `[RESOLVED]` or `[DEFERRED]`.

Mark an issue as `[DEFERRED]` when the user explicitly decides to postpone it to a future cycle.

During session recovery, read only the active documents in `docs/`.
Documents in `docs/TaskDelegation/archive/` are referenced only when the user explicitly requests it.

---

# Session Recovery

By default, the user reviews the implementation report in `docs/TaskDelegation/commit/` and delegates the next task.

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

If the user requests a session recovery, read the following documents in order and present recommendations before proceeding.

- `docs/TaskDelegation/task/` — Review the original task document.
- `docs/TaskDelegation/brainstorming/` — Review the goals and trade-offs that were established.
- `docs/TaskDelegation/strategy/` — Identify which checklist items were completed and which remain.
- `docs/TaskDelegation/commit/` — Review the implementation results and any outstanding issues by severity.

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
