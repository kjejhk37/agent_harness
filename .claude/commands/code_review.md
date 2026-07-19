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
For each finding, also state a proposed resolution (해결 방안) — a concrete fix approach, not just a restatement of the problem.

```
- [GRADE] Description of the issue
  → 해결 방안: Concrete fix approach.
```

Present the Stage 1 report to the user and request feedback before proceeding to Stage 2.

### Resolving Findings

Group findings into two buckets when presenting them.

- **Immediately resolvable** — the finding is about code developed in this task, and fixing it does not require work beyond this task's already-developed scope. Request one blanket approval to resolve all of these together (no need to ask about each finding individually), then fix them directly, rebuild/retest, and mark them `[RESOLVED]` in the review document.
- **Needs separate handling** — do not auto-resolve; call these out as their own distinct list when either:
  1. The problem originates outside this task's developed scope (pre-existing code, another task's output).
  2. Resolving it would require work beyond what this task developed (scope expansion).

  For these, follow the "unexpected situation" rule in CLAUDE.md's Collaboration Principles — do not fix inline; present them separately and let the user decide whether to start a new task delegation cycle.

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
