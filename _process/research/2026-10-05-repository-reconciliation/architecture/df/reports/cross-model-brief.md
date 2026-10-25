Read-only review. Do NOT edit any file, run no git command that changes state, do not build Lean.

Repository worktree: /private/tmp/claude-501/-Users-ren-theories/4cd2c9b9-8aca-4fd1-99bb-ff1a3f9d1698/scratchpad/wt-df (a Lean-backed theory repository; AGENTS.md there gives its rules).

Context: board item DF corrects the defects listed in _process/research/2026-10-05-repository-reconciliation/architecture/DEFECTS-FOUND.md. The files listed in /private/tmp/claude-501/-Users-ren-theories/4cd2c9b9-8aca-4fd1-99bb-ff1a3f9d1698/scratchpad/df1-nonrec-files.txt were changed (see `git diff -- <file>` for each): Lean docstrings and comments only (no statement, proof, name or import may change), the root module list Becoming.lean, theories/becoming/results/data/regions.json (bases of records and modules), the goal next_step in _process/goals/theory-of-becoming.json, DELEGATED-CHOICES.md and .zh.md (a note appended to D45), SPINE.md, lines of chapters 02, 06 and 08, the RO kit's build_passages.py (a new gap-text correction) and its rebuilt passages.json, and three records (learnable-through-a-map, what-an-extrapolation-given-nothing-fixes, learned-procedure-transmission). Record JSON outside those three is being edited by others: ignore it.

Check, opening the Lean statements each changed sentence describes (lean under experiments/integrated-correction/general-framework/generative-basis/lean/):
1. Every changed docstring, chapter line, note or record sentence says exactly what the Lean proves: hypotheses kept, quantifiers and their scope right (several fixes concern ¬∀ read as ∀¬), direction right, no overclaim, no module or declaration misattributed.
2. Lean changes are docstrings/comments only (compare code with comments stripped).
3. English and Chinese say the same where both changed.
4. regions.json bases: "general" = stated on the grammar or for any carrier with no World; "frame" = on processes/frames; "periphery" = imports Mathlib or a periphery module; "old-base"/World = uses World. Check each changed base against the module's imports and statements.
5. build_passages.py: the new gap_sub mechanism is applied like reading_sub and reports a problem when it does not apply; passages.json is what the script builds (python3 -B <kit>/build_passages.py --check).
6. Becoming.lean: the Grammar and GrammarReadings bullets now list their importers; check the lists against `grep -l "^import Becoming.Grammar$"` etc.

Report only real problems, each with: file:line, the exact text, what is wrong, the evidence (path:line of the Lean), the exact fix, severity (error / imprecise / style). Say "none" if there are none. Keep it to a list.
