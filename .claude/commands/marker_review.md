# Marker Review

Marker Review is an extension of the Task Delegation workflow, not a separate procedure.
It runs after the code review in `.claude/commands/task_delegation.md` § Step 4, and before Step 5.

Its purpose is to agree on the **level and depth of the code change after implementation**, the way item-by-item strategy approval does before implementation.
The `[CLAUDE-EDIT]` markers left during implementation and code review form the table of contents; Marker Review walks that table of contents with the user.

---

## Scope

Every `[CLAUDE-EDIT]` marker touched in this work cycle.

- Markers added during **implementation** (Step 4).
- Markers added while **resolving code review findings**.

Both are in scope. A marker is a marker regardless of which stage produced it.

---

## Procedure

Walk the markers **one at a time**. Present exactly one marker per turn.

For each marker, present the progress indicator plus the following four items.

1. **Progress** — `현재 마커 번호 / 총 마커 수`, so the user always knows how much review is left.
2. **The actual code block** — the real code, with the changed lines marked.
3. **원래 코드의 목적 및 기능** — what the code existed for and what it did before the change.
4. **현재 코드의 목적 및 기능** — what the code exists for and what it does after the change.
5. **수정 이유** — the grounds for moving from the original function to the current one.

Items 3 and 4 sit side by side on purpose.
The user must be able to judge whether **the function was preserved or changed as intended** — not just whether the stated reason sounds plausible.

- For newly added code, write item 3 as `(신규 — 기존 코드 없음)`.
- For deleted code, write item 4 as `(삭제됨 — 현재 코드 없음)`.

### Showing the Code

**The actual code block is mandatory.**
Marker Review must never become a procedure where the user approves after hearing an explanation alone — reading the code is the premise of this stage.

- Mark the changed lines with either `+` / `-` or `<-- 추가` / `<-- 삭제` / `<-- 수정`.
- Pick one of the two notations and use it **consistently throughout a single marker review**.
- Excerpt only the minimum range around the marker, plus the surrounding context needed to judge it. Do not paste whole files.
- The original code is available in the file itself as the `[CLAUDE-EDIT-OLD]` comment block left during implementation.
- This is the same notation the strategy document uses for Before / After, so the change the user approved in Step 3 and the code they see here can be compared in the same form.

### Presentation Format

```
[3/12] src/renderer/pipeline.py:88  [CLAUDE-EDIT] (렌더러_분기)

  def render(doc, fmt):
-     if fmt == "html":                          <-- 삭제
-         return HtmlRenderer().run(doc)         <-- 삭제
+     renderer = select_renderer(fmt)            <-- 추가
+     return renderer.run(doc)                   <-- 추가

원래 코드의 목적 및 기능
  단일 렌더 경로로 모든 포맷을 처리했다.
  포맷 판별을 호출부에서 수행했다.

현재 코드의 목적 및 기능
  포맷별 렌더러를 선택하는 분기로 바뀌었다.
  판별 책임이 select_renderer 로 이동했다.

수정 이유
  호출부 3곳에 같은 판별 로직이 중복되어 있었다.
  포맷을 추가할 때 3곳을 모두 고쳐야 했다.
```

---

## Approval

The user either **approves** the marker or **gives feedback** on it.

### When Approved

Mark the approval **in the code**, appended after the marker.

```
[CLAUDE-EDIT] (작업명) [승인됨]
```

- Only `[승인됨]` is added — the `[CLAUDE-EDIT] (작업명)` marker itself is untouched.
- Because the approval is a fixed string, it can be found and stripped mechanically. Nothing else needs to be parsed.

When **every** marker in the cycle is approved, do the following as one pass.

- Remove every `[승인됨]` string.
- Remove every `[CLAUDE-EDIT-OLD]` block along with the commented-out original code inside it.
- Leave every `[CLAUDE-EDIT]` marker in place. Those are permanent, per `.claude/commands/task_delegation.md` § Step 4.

### When Feedback Is Given

Record the feedback in `docs/marker_review/{slug}_YYYYMMDD_HHMM.md`, reusing the same `{slug}` as the rest of the work cycle.
Write the relative path of the reviewed strategy .md at the top of the document.

There are two routes from here, decided by the size of the change the feedback requires.

#### Route A — Short Fix (fix it on the spot)

A short, self-contained change is fixed immediately and the marker is updated in place, without going back to the strategy stage.

Examples of what qualifies: renaming some of the fields in a `Vec3`, correcting a few dozen lines inside a single script.

**Route A applies only when every one of the following holds.**

- The change stays inside the range of the marker being reviewed — one file, and no edits scattered across other files.
- The change touches no other module's behavior or interface. It is self-contained.
- The change adds no functionality and removes none. It is a rename, a constant, a local correction of logic already agreed on.
- The change is on the order of a few dozen lines at most.
- No new unit test is required — the existing tests already cover the changed behavior.

**If any single condition fails, use Route B. If it is unclear which route applies, use Route B.**
The conservative default matters here: this route skips strategy approval, so it must stay narrow enough that skipping it costs nothing.

Procedure for Route A.

1. Make the fix on the spot.
2. Update the marker in place — refresh the `[CLAUDE-EDIT-OLD]` block to match the new original, and leave the `[CLAUDE-EDIT]` marker itself alone.
3. Run the build and the unit tests, as required for every change by `claude_workflow/CLAUDE.md` § Core Development Principles.
4. Present the same marker again — the updated code block plus the four items — and get approval for it.
5. Record the feedback and what was done about it in the marker review document.
6. On approval, move to the next marker. **Do not return to the strategy stage, and do not cancel any other marker's approval.**

If the fix turns out to be larger than it looked once started, **stop immediately**, leave the code as it was, and move that piece of feedback to Route B.
This follows the "unexpected situation" rule in `claude_workflow/CLAUDE.md` § Collaboration Principles — the scope must never grow quietly inside Route A.

#### Route B — Full Loop (through the strategy stage)

Anything that is not a short fix is applied through the workflow: **전략 → 구현 → 마커 리뷰**, so that the change passes through strategy approval like any other implementation work.
Marker Review is therefore the gate that triggers a new cycle.

Begin applying Route B feedback when either of the following holds.

- Every marker has been reviewed — approved, short-fixed, or given feedback.
- The user asks for the feedback to be applied immediately, partway through.

The second case exists so that a user facing many markers is not forced to wait for a full sweep before anything gets fixed.

---

## Returning to Strategy

Only Route B feedback sends the cycle back to the strategy stage.
A marker fixed and re-approved through Route A does not — it is settled where it stands.

**When the cycle returns to the strategy stage, every existing marker approval is cancelled.**

- Strip every `[승인됨]` string when the return happens.
- The reason: applying the feedback changes the code again, which can make an earlier approval meaningless.
- Consequently, the second and later rounds of Marker Review re-examine **all** markers, not only the new ones.
- The cost is accepted — the round trips grow. In exchange there is no approval state to carry forward or track across rounds, which keeps the rule simple.

---

## Termination

Marker Review ends when **no Route B feedback remains and every marker is approved**.

- Feedback resolved through Route A does not block termination — it was fixed and the marker was re-approved on the spot, so nothing is outstanding.
- On termination: strip the approval marks and the `[CLAUDE-EDIT-OLD]` blocks as described above, then proceed to Step 5 (Implementation Result and Issue Report).
- If even one piece of Route B feedback exists, return to Step 3 instead.
- There is no cap on how many times the loop may run.
