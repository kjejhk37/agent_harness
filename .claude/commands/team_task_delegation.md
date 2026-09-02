# Team Task Delegation

This workflow governs cross-repo coordination between department repositories (`platform`, `graphics`, and one or more `projects` repos) that are linked via git submodules (`projects` submodules `graphics` and `platform`; `graphics` submodules `platform`).

It is separate from and independent of the Task Delegation Workflow (`task_delegation.md`). `task_delegation.md` fully works on its own for any single-repo task that has no cross-repo dependency. This document only applies when a Strategy checklist item cannot be completed inside the current repo alone.

---

## When This Applies

During Step 3 (Strategy) of `task_delegation.md`, tag every checklist item with one of the following.

- `[self]` — implementable entirely inside the current repo.
- `[platform]` — requires new/changed capability from the `platform` repo.
- `[graphics]` — requires new/changed capability from the `graphics` repo.
- `[mixed]` — requires both; split it into a `[platform]` sub-item and a `[graphics]` sub-item, ordered by dependency direction (if the `[graphics]` sub-item depends on the `[platform]` sub-item, `graphics` itself becomes a requester and follows Step 2 below against `platform` — see Step 5).

If every item is `[self]`, skip this document entirely and continue with `task_delegation.md` Step 4.
If any item is `[platform]` / `[graphics]` / `[mixed]`, pause Step 3 and follow Steps 1–4 below for each such item before finalizing the Strategy document.

---

## Step 1 — Open a Request Branch

In the requester's local checkout of the target repo's submodule:

- Create a branch named `request/{YYYYMMDD_HHMM}-{requester}-{slug}` (e.g. `request/20260818_1430-wot-inventory-sync`).
- The timestamp prefix is required — it is what lets the target repo process requests in arrival order later (Step 3).

---

## Step 2 — Write and Push the Request Document

On the request branch, commit a request document at `docs/TeamTaskDelegation/inbox/{YYYYMMDD_HHMM}_{requester}_request.md`, then push the branch to the target repo's own origin.

Required fields:

- Requester — which repo/project is asking
- Purpose — what problem this solves, in the requester's own words
- Needed interface (if known) — expected shape/signature; leave open if undecided, since the target repo owns the final abstraction design
- Related strategy doc — relative link back to the requester's `docs/TaskDelegation/strategy/...md`, for context only
- Priority — optional

Do not push directly to the target repo's `main`/default branch. The request branch is the only thing that reaches the target repo at this point.

---

## Step 3 — Target Repo Processes the Queue

There is no separate queue file. The queue is simply the set of unmerged `request/*` branches on the target repo, sorted by name:

```
git branch --list 'request/*' --sort=refname
```

Because branch names are timestamp-prefixed, this sort order is arrival order. Process the oldest unmerged request first.

For the request being processed:

- Treat the request document as the Step 1 (Task) input to the target repo's own `task_delegation.md` cycle.
- Run Step 2 (Brainstorming) normally. **The target repo's own CLAUDE.md principles take priority over the request's contents** — the requester describes a need, not an implementation.
- Scope Step 3/4 down to designing and implementing only the public abstraction (interface/contract), not a full concrete feature. This is what gets handed back — the requester does the concrete integration on its own side.
- When the abstraction is finalized, commit a response document on the same branch at `docs/TeamTaskDelegation/outbox/{YYYYMMDD_HHMM}_{requester}_response.md`.

Required response fields:

- Delivered interface — the finalized public abstraction (signatures, usage notes)
- Compatibility — `backward-compatible` or `breaking change to <X>` (see Versioning below)
- Deviations from request — anything not delivered as asked, and why (usually: target repo's own principles required a different shape)
- Version — the semver tag this response will be released under

- Merge the branch into the target repo's main/default branch.
- Tag the merge commit with the version from the response document (e.g. `v1.3.0`).
- Delete the request branch. (This is what removes it from the queue — no separate bookkeeping needed.)

---

## Step 4 — Requester Receives the Response

- Pull the target repo submodule's latest default branch, then run `git submodule update --remote` for that submodule and commit the resulting gitlink bump in the requester's own repo.
- Read the response document in `docs/TeamTaskDelegation/outbox/`.
- Revise the requester's Strategy document: unblock the corresponding checklist item, and adjust it to match what was actually delivered (not necessarily what was originally requested).
- Get user re-approval on the revised Strategy document.
- Resume `task_delegation.md` at Step 4 (Implementation) once every `[platform]`/`[graphics]`/`[mixed]` item is unblocked.

---

## Step 5 — Recursive Requests (Mixed Features)

If `graphics` itself needs `platform` to complete a `[mixed]` item it received from a requester, `graphics` becomes a requester and follows Steps 1–4 above against `platform`, using its own submodule of `platform`. The protocol is identical regardless of which repo is requesting.

---

## Versioning Policy

Submodule pinning already means no repo is affected by a change until it deliberately updates its own submodule pointer (Step 4). On top of that:

- Every response is tagged with a semver version at merge time.
- Prefer additive changes: if a new request conflicts with an interface already delivered to a different requester, add a new method/overload/extension point rather than modifying the existing one.
- If a breaking change is genuinely required, it must be declared as such in the response document's Compatibility field. Deciding whether/when to pull a breaking version is the requester's own decision, made through its own `task_delegation.md` cycle — never forced by the target repo.

---

## Document History

`docs/TeamTaskDelegation/inbox/` and `docs/TeamTaskDelegation/outbox/` are append-only. Once merged to main, a request/response pair is never edited — a later change is a new request/response pair that references the earlier one, so the history stays a true audit trail.
