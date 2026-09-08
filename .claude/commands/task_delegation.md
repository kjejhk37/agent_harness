# Task Delegation

When a task is delegated by the user, follow the steps below in order.

---

## Stage Boundaries

- Task (Step 1): Problem definition only. Do not include solutions, ideas, or code-change methods.
- Brainstorming (Step 2): Idea-level discussion only. Reading the current code (read-only) to judge whether an idea is feasible is allowed. Do not modify code or design concrete file/function-level changes here — that belongs to Strategy (Step 3).
- Strategy (Step 3): Concretize how to apply the ideas confirmed in Brainstorming to the code. Do not originate new ideas/alternatives at this stage — if a new idea is needed, go back to Step 2.

---

## Step 1 — Write the Task Document

Request answers to the following items from the user and save the completed content as `data/docs/task/{slug}_YYYYMMDD_HHMM.md`, where `{slug}` is a short content summary of the task's Purpose (see the Document Naming Convention in `claude_workflow/CLAUDE.md`) — not the literal word "summary". Reuse this same `{slug}` for every later-stage document in this work cycle (Steps 2, 3, 5, plus the code review and marker review documents).

- Purpose (required)
- Author (optional)
- User draft (optional) — ideas or direction the user has already conceived
- Requirements (optional)
- Checklist (optional)

---

## Step 2 — Brainstorming (Bidirectional)

The task document stays in `data/docs/task/` — do not move it.

Write a brainstorming draft and save it as `data/docs/brainstorming/{slug}_YYYYMMDD_HHMM.md`, reusing the same `{slug}` as the task document.

- Write the relative path of the task .md at the top of the brainstorming document (e.g. `../task/{slug}_YYYYMMDD_HHMM.md`).

The purpose of brainstorming is as follows.

- Clarify the user's goals.
- Identify risks in the implementation process in advance and discuss how to resolve them.
- Explore solutions to achieve the user's goals.
- Check the current code state (read-only) to judge whether an idea is feasible — do not design concrete file/function-level changes here (see Stage Boundaries above).

The brainstorming document must include the following sections, in this order.

- Details — The discussion itself: options considered, decisions made, and the reasoning behind them.
- Trade-offs — State the pros and cons of each solution and the risks that must be accepted.
- Q&A Log — Keep a running, chronological record of every question the user asks and the answer given during brainstorming, appended in the order they happen. This includes simple/factual/definitional questions (e.g. "what does this license term mean?"), not only questions that lead to a decision — log the question as asked and the answer as given, immediately when it happens, not only in retrospect when the user asks you to. This is in addition to the other sections, not a replacement for them.
- `## 요약` / `## 사용자 결정 사항` / `## 사용자 확인 사항` — the three closing sections defined in `claude_workflow/CLAUDE.md` § .md Writing Rules, in that order, as the very last content in the file. Do **not** merge them into a single "Summary & Open Questions" section — the permanent decision record and the still-open question list must stay separate. Whenever a new decision is made or a new question comes up, rewrite all three so they stay last — never leave stale content above them after an update.

**Brainstorming is conducted bidirectionally with the user.**

- After writing the draft, share it with the user and request feedback.
- Revise the brainstorming .md based on the user's feedback.
- Repeat share → feedback → revise until the user approves.
- Proceed to Step 3 only after user approval.

---

## Step 3 — Write the Strategy Document (Bidirectional)

Write a strategy document based on the brainstorming results and save it as `data/docs/strategy/{slug}_YYYYMMDD_HHMM.md`, reusing the same `{slug}` as the task/brainstorming documents.

- Write the relative path of the brainstorming .md at the top of the strategy document.

The purpose of the strategy document is as follows.

- Specify "how" to apply the brainstorming results to the code.
- Manage a checklist to track whether results are applied correctly.
- Define the final approval and verification criteria for code implementation.

The strategy document must include an implementation checklist.

- Write each item in `[ ]` format.
- Break the checklist down into the smallest implementable units.
- Write the concrete code change for every item alongside it, as **Before / After**.
- If this repo has cross-repo dependencies (see `CLAUDE.md` § Cross-Repo Roles), tag each item `[self]` / `[platform]` / `[graphics]` / `[mixed]` and resolve every non-`[self]` item via `.claude/commands/team_task_delegation.md` before finalizing this document.
- When a checklist section (e.g. `### Phase N — <설명>`) includes a change to a data schema (save file format, config schema, network protocol, DB schema, etc.), add one **schema** Before/After comparison for that section as a whole, showing the old and new schema definitions. This is one comparison per section, in addition to the per-item code Before/After below — the two are different things, and neither replaces the other. Sections with no schema change need no schema comparison.

### Before / After for Every Checklist Item

A checklist item states *what* will be done.
Before / After states *how the code will actually change*.
Both are required, because the point of Step 3 is to agree on the **level and depth of the code change** before any code is written — not merely to agree on the intent.

- Write Before / After as **real code blocks**, not a prose summary of what will change.
- Quote the current code as it actually exists — read the target file before writing the item.
- Excerpt only the minimum range that changes, plus the surrounding context needed to judge it. Do not paste whole files.
- Annotate the changed lines inline with `<-- 추가` / `<-- 삭제` / `<-- 수정` so the user can see at a glance where the change lands.
- When there is no Before (a new file, a new function), write Before as `(신규 파일 — 기존 코드 없음)` and apply `<-- 추가` to the whole After block.

Example of one checklist item.

```
- [ ] 렌더러 분기 함수 추출

Before — src/renderer/pipeline.py:88
  def render(doc, fmt):
      if fmt == "html":
          return HtmlRenderer().run(doc)
      return TextRenderer().run(doc)

After
  def render(doc, fmt):
      renderer = select_renderer(fmt)      <-- 추가
      return renderer.run(doc)             <-- 추가
```

### Item-by-Item Approval

**The strategy document is approved one checklist item at a time — not as a whole document.**

- Present one checklist item together with its Before / After, and ask the user to approve it or give feedback.
- Present **exactly one item per turn**. Do not batch several items into one question, even when they look related.
- When the user gives feedback instead of approval, revise that item's Before / After and present it again.
- When an item is approved, mark it `(승인됨)` in front of the item text and remove it from `## 사용자 확인 사항`.

```
- [ ] (승인됨) 렌더러 분기 함수 추출
```

- `(승인됨)` records **approval**; `[ ]` / `[x]` records **implementation completion**. The two are independent axes and neither replaces the other.
- Keep the checklist small enough that item-by-item approval stays affordable — one item is one round trip with the user.
- Proceed to Step 4 only when `## 사용자 확인 사항` reads `없음`, meaning every checklist item is approved. Do not begin implementation before that.

### Closing Sections

The strategy document ends with the following four sections, in this order, as the very last content in the file.

1. `## 체크리스트 요약` — the checklist items only, listed flat with no Before / After attached. A reader who wants the plan without the code reads this one section.
2. `## 요약` — states what will be built and what the approval criteria are, so a reader who skips the checklist still gets the verdict.
3. `## 사용자 결정 사항` — carry every decision made during brainstorming forward into this list, so the strategy document stands on its own without re-reading the brainstorming .md.
4. `## 사용자 확인 사항` — the checklist items **not yet approved by the user**, as a numbered list. This section is the unapproved-item tracker: an item leaves it the moment it is approved, and `없음` means every item is approved and Step 4 may begin.

This ordering satisfies the three closing sections required by `claude_workflow/CLAUDE.md` § .md Writing Rules — `## 체크리스트 요약` sits immediately before them, not in place of any of them.

---

## Step 4 — Implementation

Implement according to the checklist in the user-approved strategy document.
Each time an item is completed, update the corresponding checklist item in the strategy document to `[x]`.

### Change Markers — `[CLAUDE-EDIT]`

**Every place the code is modified, deleted, or added gets a marker.**

```
[CLAUDE-EDIT] (작업명)
[CLAUDE-EDIT] (티켓명)
```

- Use the ticket name when a ticket exists. Otherwise use the work cycle's `{slug}` as the 작업명.
  - A consistent name is what makes the markers countable later — if the name drifts from session to session, the markers cannot be aggregated mechanically.
- Attach one marker per **changed logical block** — a function, a method, a conditional branch. Never per line.
  - One marker is one round trip during Marker Review, so the attachment unit decides the review cost.
  - Which exact lines changed is shown in Marker Review's code block, not by the marker's position.
- Write the marker as the target language's **single-line comment**.
  - `// [CLAUDE-EDIT] (작업명)` — C, C++, C#, Java, JavaScript, TypeScript, Rust, Go.
  - `# [CLAUDE-EDIT] (작업명)` — Python, Ruby, Shell, YAML.
  - `<!-- [CLAUDE-EDIT] (작업명) -->` — HTML, XML, Markdown.
  - A single-line comment is required because the markers are searched and counted one line at a time. A block comment spanning several lines breaks that.
- **The marker is permanent.** It is not removed when the code review finishes, and it is not removed when the reported issues are resolved.
  - This is deliberate: the markers exist to track, aggregate, and audit AI-written code after the fact, so they outlive the work cycle that created them.
  - The cost is accepted — markers accumulate as cycles pile up and add noise to the code. A cleanup rule will be defined separately once the downstream use of the markers is settled.

### Preserving the Original Code — `[CLAUDE-EDIT-OLD]`

**When code is modified or deleted, keep the original code as a comment instead of erasing it.**

```
// [CLAUDE-EDIT-OLD] (작업명)
//   if fmt == "html":
//       return HtmlRenderer().run(doc)
```

- Start the preserved block with `[CLAUDE-EDIT-OLD] (작업명)`, then place the commented-out original code below it.
- This is what lets Marker Review show "원래 코드의 목적 및 기능" from the file itself, and it is what makes a pure deletion reviewable at all — a deletion with nothing left behind has nothing to attach a marker to.
- The distinct `[CLAUDE-EDIT-OLD]` tag separates these blocks from comments a human wrote, so the cleanup can tell them apart and never deletes a human's comment by mistake.
- Remove the whole preserved block once the change is approved in Marker Review.
- Until then the commented-out old code stays in the file. The code being temporarily untidy is accepted in exchange for the original being visible at review time.

### Proceeding

When all checklist items are marked `[x]`, ask the user the following before proceeding to Step 5.

> Implementation is complete. Would you like to run a **Code Review**?
> (Stage 1: quality inspection against SOLID, library isolation, test coverage, comment rules.
>  Stage 2: ASCII or HTML diagrams — class diagram, sequence diagram.)

- If yes: run the code review per `.claude/commands/code_review.md`, then ask about refactor inspection (below).
- If no: proceed to the Marker Review question.

After the code review (or if the user skipped it), ask:

> Would you like to run a **Refactor Inspection**?
> (Scans for SRP violations, coupling issues, missing tests, and naming problems. Reports issues only — no code is changed. Any fixes are handled via a new task delegation.)

- If yes: run the refactor inspection per `.claude/commands/refactor.md`, then proceed to the Marker Review question.
- If no: proceed to the Marker Review question.

Code fixed while resolving code review findings also gets a `[CLAUDE-EDIT]` marker, exactly as implementation code does.
Marker Review therefore covers every point touched in **both** the implementation stage and the code review stage.

### Marker Review

After the code review, ask:

> Would you like to run a **Marker Review**?
> (Walks every `[CLAUDE-EDIT]` marker one at a time, showing the actual code block plus the original purpose, the current purpose, and the reason for the change. You approve each one or give feedback.)

- If yes: run the marker review per `.claude/commands/marker_review.md`.
  - Feedback that is short and self-contained is fixed on the spot and the marker is re-approved there, without returning to Step 3. The qualifying conditions are defined in `.claude/commands/marker_review.md` § Route A — Short Fix.
  - If every marker is approved and no feedback needs the full loop, proceed to Step 5.
  - Otherwise return to Step 3 and write a strategy document for applying that feedback. The cycle runs 전략 → 구현 → 마커 리뷰 again.
- If no: proceed to Step 5.

---

## Step 5 — Implementation Result and Issue Report

After implementation is complete, write a result report as `data/docs/commit/{slug}_YYYYMMDD_HHMM.md`, reusing the same `{slug}` as the rest of the work cycle. Write the relative path of the strategy .md at the top of the commit document (e.g. `../strategy/{slug}_YYYYMMDD_HHMM.md`).

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

### Issue Classification by Origin

Split the reported issues into the following **three sections**, by where the issue came from.
The point of the split is to separate what this branch is responsible for from pre-existing debt, so the user can judge each on its own terms.

```
### 1. 신규 이슈 (독립)
### 2. 기존 이슈
### 3. 신규 이슈 (기존 코드 연계)
```

1. **신규 이슈 (독립)** — caused by this branch's work, and independent of pre-existing code. A purely new defect, and the one class of issue this cycle must resolve.
2. **기존 이슈** — not caused by this branch's work; it already existed. Not this branch's responsibility. **The user decides whether it is fixed at all and when** — report it and leave it alone otherwise. Without an instruction from the user it stays a candidate for a later cycle.
3. **신규 이슈 (기존 코드 연계)** — caused by this branch's work, but entangled with pre-existing code, so fixing the new code alone will not resolve it. **The user decides here too**: report the finding and the scope of the change it would require, and proceed only after the user's decision. This is the point where the scope quietly expands if the rule is not followed.

Keep the severity grade on every issue in every section. The classification is a second axis, not a replacement for severity.

Example:

```
### 1. 신규 이슈 (독립)

- [CRITICAL] Application crashes on startup when config file is missing.
- [LOW] Variable naming does not follow the naming convention.

### 2. 기존 이슈

- [MEDIUM] Return value is incorrect when an empty list is passed as input.

### 3. 신규 이슈 (기존 코드 연계)

- [HIGH] The new renderer branch double-escapes output because the legacy writer already escapes it.
```

Write `없음` under a section that has no issues — never drop the section.

After writing the commit report, if any open issues exist, ask the user the following.

> Issues were identified in the commit report. Would you like to run **Debug** on any of them?
> (Writes a minimal reproduction script, traces the root cause, and resolves the issue.)

- If yes: confirm which issue to debug, then run per `.claude/commands/debug.md`.
- If no: hand off to the user for review.
