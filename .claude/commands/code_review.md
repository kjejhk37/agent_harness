# Code Review

Implementation code is reviewed in two stages before committing.

---

## Stage 1 — Quality Inspection

Inspect the implemented code against the following criteria and report each finding.

**SOLID Principles**
- Single Responsibility: each class and function has exactly one reason to change.
- Open/Closed: open for extension, closed for modification.
- Liskov Substitution: subtypes are substitutable for their base types.
- Interface Segregation: interfaces are not larger than what the client needs.
- Dependency Inversion: high-level modules do not depend on low-level modules.

**Library Isolation**
- No external library is referenced directly outside its wrapper class.

**Unit Tests**
- Every implemented feature has a corresponding unit test.
- All existing tests pass after the changes.

**Comment Rules**
- Every function and class has a comment that includes: author, description, input, output, notes, date.

Report findings using the issue severity grades defined in CLAUDE.md.
For each finding, also state a proposed resolution — a concrete fix approach, not just a restatement of the problem.
Follow the `.md` Writing Rules in this file (one sentence per line, bullet points for lists) — do not collapse a finding into a single run-on paragraph.

```
- [GRADE] Description of the issue.
  - Supporting detail, one sentence per line.
  - **[해결 방안]**
    - Concrete fix approach, one sentence per line.
```

### Issue Classification by Origin

Split the findings into the following **three sections**, by where the issue came from.
The point of the split is to separate what this branch is responsible for from pre-existing debt, so the user can judge each on its own terms.

```
### 1. 신규 이슈 (독립)
### 2. 기존 이슈
### 3. 신규 이슈 (기존 코드 연계)
```

1. **신규 이슈 (독립)** — caused by this branch's work, and independent of pre-existing code. A purely new defect, and the one class of finding this cycle must resolve.
2. **기존 이슈** — not caused by this branch's work; it already existed. Not this branch's responsibility. **The user decides whether it is fixed at all and when** — report it and leave it alone otherwise. Without an instruction from the user it stays a candidate for a later cycle.
3. **신규 이슈 (기존 코드 연계)** — caused by this branch's work, but entangled with pre-existing code, so fixing the new code alone will not resolve it. **The user decides here too**: report the finding and the scope of the change it would require, and proceed only after the user's decision. This is the point where the scope quietly expands if the rule is not followed.

Keep the severity grade on every finding in every section — the classification is a second axis, not a replacement for severity.
Write `없음` under a section that has no findings; never drop the section.

Splitting into sections means the findings are no longer ordered by severity in a single list. That is accepted, because reading "what this branch is responsible for" as one block matters more here.

Present the Stage 1 report to the user and request feedback before proceeding to Stage 2.

### Resolving Findings

The origin classification above decides how a finding is handled.

- **신규 이슈 (독립)** — immediately resolvable. Request one blanket approval to resolve all of these together (no need to ask about each finding individually), then fix them directly, rebuild/retest, and mark them `[RESOLVED]` in the review document.
- **기존 이슈** and **신규 이슈 (기존 코드 연계)** — never auto-resolve. Both are the user's call: whether to fix, and when. Follow the "unexpected situation" rule in CLAUDE.md's Collaboration Principles — do not fix inline; present them and let the user decide whether to start a new task delegation cycle.

### Markers on Fixed Code

Code fixed while resolving a finding gets a `[CLAUDE-EDIT]` marker, exactly as implementation code does.
Modified or deleted original code is preserved as a `[CLAUDE-EDIT-OLD]` comment block, exactly as in the implementation stage.
Both rules are defined in `.claude/commands/task_delegation.md` § Step 4.

Without this, Marker Review would cover the implementation output but miss everything changed after the review, and the two would fall out of step.

---

## Stage 2 — Diagram Generation

Based on the reviewed code, generate the following diagrams.

Generate diagrams in **ASCII** by default.
Switch to **HTML** if the user requests it or if the diagram is too complex to represent clearly in ASCII.

### Diagrams to generate

**Class Diagram**
- Show all classes, their fields and methods, and relationships (inheritance, composition, dependency).

**Sequence Diagram**
- Show the main interaction flow between objects for the primary use case.

Add diagrams as additional sections if other diagram types are relevant (e.g. state diagram, component diagram).

### ASCII format example

```
Class Diagram
┌─────────────────┐         ┌─────────────────┐
│   ClassName     │         │  OtherClass     │
├─────────────────┤ uses    ├─────────────────┤
│ - field: Type   │────────>│ - field: Type   │
├─────────────────┤         ├─────────────────┤
│ + method(): T   │         │ + method(): T   │
└─────────────────┘         └─────────────────┘

Sequence Diagram
Client          ServiceA         ServiceB
  │                │                │
  │─── request ───>│                │
  │                │─── call ──────>│
  │                │<── response ───│
  │<── result ─────│                │
```

### HTML format

Save as `docs/review/diagram_YYYYMMDD_HHMM.html`.
Use inline CSS only — no external dependencies.

---

## Output

Save the full review result (Stage 1 + Stage 2) as `docs/review/{slug}_YYYYMMDD_HHMM.md`, reusing the same `{slug}` as the reviewed work cycle.
Write the relative path of the strategy .md that was reviewed at the top of the document.
