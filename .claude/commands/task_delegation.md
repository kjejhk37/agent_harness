# Task Delegation

When a task is delegated by the user, follow the steps below in order.

---

## Step 1 — Write the Task Document

Request answers to the following items from the user and save the completed content as `docs/task/{slug}_YYYYMMDD_HHMM.md`, where `{slug}` is a short content summary of the task's Purpose (see the Document Naming Convention in `agent_harness/CLAUDE.md`) — not the literal word "summary". Reuse this same `{slug}` for every later-stage document in this work cycle (Steps 2, 3, 5).

- Purpose (required)
- Author (optional)
- User draft (optional) — ideas or direction the user has already conceived
- Requirements (optional)
- Checklist (optional)

---

## Step 2 — Brainstorming (Bidirectional)

The task document stays in `docs/task/` — do not move it.

Write a brainstorming draft and save it as `docs/brainstorming/{slug}_YYYYMMDD_HHMM.md`, reusing the same `{slug}` as the task document.

- Write the relative path of the task .md at the top of the brainstorming document (e.g. `../task/{slug}_YYYYMMDD_HHMM.md`).

The purpose of brainstorming is as follows.

- Clarify the user's goals and refine the implementation strategy.
- Identify risks in the implementation process in advance and discuss how to resolve them.
- Explore solutions to achieve the user's goals.

The brainstorming document must include the following sections, in this order.

- Details — The discussion itself: options considered, decisions made, and the reasoning behind them.
- Trade-offs — State the pros and cons of each solution and the risks that must be accepted.
- Q&A Log — Keep a running, chronological record of every question the user asks and the answer given during brainstorming, appended in the order they happen. This includes simple/factual/definitional questions (e.g. "what does this license term mean?"), not only questions that lead to a decision — log the question as asked and the answer as given, immediately when it happens, not only in retrospect when the user asks you to. This is in addition to the other sections, not a replacement for them.
- Summary & Open Questions (사용자 결정 필요) — Always the last section in the document. Restate the currently confirmed conclusions in a top-heavy list, followed by the questions still awaiting a user decision. Whenever a new decision is made or a new question comes up, rewrite this section so it stays the last thing in the file — never leave stale content above it after an update.

**Brainstorming is conducted bidirectionally with the user.**

- After writing the draft, share it with the user and request feedback.
- Revise the brainstorming .md based on the user's feedback.
- Repeat share → feedback → revise until the user approves.
- Proceed to Step 3 only after user approval.

---

## Step 3 — Write the Strategy Document (Bidirectional)

Write a strategy document based on the brainstorming results and save it as `docs/strategy/{slug}_YYYYMMDD_HHMM.md`, reusing the same `{slug}` as the task/brainstorming documents.

- Write the relative path of the brainstorming .md at the top of the strategy document.

The purpose of the strategy document is as follows.

- Specify "how" to apply the brainstorming results to the code.
- Manage a checklist to track whether results are applied correctly.
- Define the final approval and verification criteria for code implementation.

The strategy document must include an implementation checklist.

- Write each item in `[ ]` format.
- Break the checklist down into the smallest implementable units.

**The strategy document is reviewed bidirectionally with the user.**

- After writing the draft, share it with the user and request feedback.
- Revise the strategy .md based on the user's feedback.
- Repeat share → feedback → revise until the user approves.
- Proceed to Step 4 only after user approval. Do not begin implementation before approval.

---

## Step 4 — Implementation

Implement according to the checklist in the user-approved strategy document.
Each time an item is completed, update the corresponding checklist item in the strategy document to `[x]`.

When all checklist items are marked `[x]`, ask the user the following before proceeding to Step 5.

> Implementation is complete. Would you like to run a **Code Review**?
> (Stage 1: quality inspection against SOLID, library isolation, test coverage, comment rules.
>  Stage 2: ASCII or HTML diagrams — class diagram, sequence diagram.)

- If yes: run the code review per `.claude/commands/code_review.md`, then ask about refactor inspection (below).
- If no: proceed to Step 5.

After the code review (or if the user skipped it), ask:

> Would you like to run a **Refactor Inspection**?
> (Scans for SRP violations, coupling issues, missing tests, and naming problems. Reports issues only — no code is changed. Any fixes are handled via a new task delegation.)

- If yes: run the refactor inspection per `.claude/commands/refactor.md`, then proceed to Step 5.
- If no: proceed to Step 5.

---

## Step 5 — Implementation Result and Issue Report

After implementation is complete, write a result report as `docs/commit/{slug}_YYYYMMDD_HHMM.md`, reusing the same `{slug}` as the rest of the work cycle. Write the relative path of the strategy .md at the top of the commit document (e.g. `../strategy/{slug}_YYYYMMDD_HHMM.md`).

- Report only "errors identified in the current state," regardless of whether they relate to newly added features.
- Write the report in a top-heavy structure, one sentence per bullet point.
- Assign a severity level to each reported issue using the grades below.

### Issue Severity Grades

| Grade | Label | Criteria |
|---|---|---|
| 1 | `CRITICAL` | Blocks execution or causes data loss. Must be resolved before any further work. |
| 2 | `HIGH` | Major functional failure. A workaround exists but the issue cannot be left unresolved. |
| 3 | `MEDIUM` | Non-blocking functional issue. Does not prevent operation but requires resolution. |
| 4 | `LOW` | Minor issue with no functional impact. Can be deferred. |

Write each issue in the following format.

```
- [GRADE] Description of the issue
```

Example:

```
- [CRITICAL] Application crashes on startup when config file is missing.
- [MEDIUM] Return value is incorrect when an empty list is passed as input.
- [LOW] Variable naming does not follow the naming convention.
```

After writing the commit report, if any open issues exist, ask the user the following.

> Issues were identified in the commit report. Would you like to run **Debug** on any of them?
> (Writes a minimal reproduction script, traces the root cause, and resolves the issue.)

- If yes: confirm which issue to debug, then run per `.claude/commands/debug.md`.
- If no: hand off to the user for review.
