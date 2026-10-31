# Brief for the designs of RF's tests (plan §10)

Shared decisions. Every builder follows them; a builder that finds one wrong says so in its report and does not silently depart from it.

## What is being made

Designs, not freezes: nothing is frozen and nothing runs on a trained system, a model, data or people now. The deliverable is one experiment folder, `experiments/formations-that-read/`, with:
- `README.md` (short: status, files, how to reproduce Stage 0);
- `DESIGN.md`, in three layers: **the tests in ten minutes** (at most 1,100 words in all, about 110 per test), **the tests in an hour** (about 650 words per test), and **the rest** (exact tables, power checks, rivals, usage, provenance and reviews);
- one standard-library Python 3.11 script per test, `trN.py`, which computes Stage 0 and writes `trN.json` (deterministic: `fractions.Fraction` for exact values, `random.Random(seed)` with a frozen seed for simulations; no numpy; runs in seconds to a few minutes).

The integrator writes the README, the ten-minute layer's opening and the folder; builders draft their tests' parts.

## Numbering (one sequence, by law)

| Test | Law | Record | Module |
|---|---|---|---|
| TR1 | RF1, what choices show of an order | what-choices-show-of-an-order | Becoming.ShownOrder |
| TR2 | RF2, what readings fix of the unread | what-readings-fix-of-the-unread | Becoming.Unread |
| TR3 | RF4, readers reading readers | readers-reading-readers | Becoming.Cascade |
| TR4 | RF6.1, a revision that opens a correction | a-revision-that-opens-a-correction | Becoming.OpenedCorrection |
| TR5 | RF3, a reading kept by its update | a-reading-kept-by-its-update | Becoming.ReadingLoop |
| TR6 | RF6.3, a prediction read by what it predicts | a-prediction-read-by-what-it-predicts | Becoming.ReflexivePrediction |
| TR7 | RF7, complying when read | when-complying-when-read-is-best | Becoming.ReadStages |
| TR8 | RF-M.2, holding an act for a reading | what-holding-for-a-reading-is-worth | Becoming.HeldForReading |
| TR9 | RF-M.3, informing and revaluing (after TR8) | a-reading-informed-and-revalued | Becoming.ListingValuation |

RF-M's mechanism, the record acts-alike-from-a-model-or-from-an-order (ReadingLoop.Untested), gets no test of its own: TR1's Stage 0 carries its exact table, and TR1 may carry an optional variant across informing frames whose only verdict is RF1's. Write "TR3 (RF4)" in full where a thesis T3 could be confused.

## Stages

- **Stage 0, here, now.** Exact values (mirrors of the Lean's definitions, checked against the Lean's evaluated witnesses and against enumeration on small cases), simulated systems (the law's model and the rivals the test may meet), and the power check, which fixes which differences a verdict can rest on. No model call, no download, no yes needed: this is design work.
- **Stage A, later.** Runs on small trained systems (tabular or small networks, standard library where possible). A run, so on Ren's yes.
- **Stage B, later.** Language models through an API (several families, versions pinned, at least one family other than the theory's own, as VD1), open-weight models, public data, or people. On Ren's yes, with usage stated (calls, an estimate of tokens) and any download named (file, source, size).

## Rules every design keeps

1. **What it can refute.** RF's laws are theorems in the pure core; no run refutes them. Each test refutes at most a named correspondence or bridge (that a given system is the law's model, or chooses as its counts rank), and says what success cannot confirm (the law predicts nothing beyond its reach).
2. **The law's own quantifier.** The forbidden case is stated as the Lean states it (for every occasion, at every step, never below, exactly where), with every hypothesis; where the Lean's iff has an equality boundary, ties are excluded from verdicts or given their own rule. Where a design uses a general form that the Lean does not state (an inference), say so and list it as a candidate core lemma; do not write new Lean.
3. **Premises apart from the outcome.** Each premise is checked by a measure that does not read the outcome; a failed premise check voids a unit, it does not refute.
4. **Resolved differences only.** A verdict rests only on a difference the feedback resolves, shown by Stage 0's power check, which simulates the system the test may meet: the law's model with noise, readers fixed by what they read (position, label, cue, history), all-or-nothing and threshold agents, and hybrids of the law and a rival.
5. **Guards and controls.** Each support rule lists every measure bearing on its claim and reports it contradicted when any is resolved against it; a control is added wherever a rival passes every contrast; exploration is measured apart from selection where both occur.
6. **The unit.** For model runs, the call is the unit, each a fresh call unless the design's loop carries a course; versions pinned; pooled counts descriptive only, with the theory's own family reported apart.
7. **Usage.** State calls and an estimate of tokens per stage, and the harness: OpenRouter as VD1 and VD2 (key in Ren's interactive zsh, never printed; a spend guard) or the Claude CLI as LA1 to LA3 (the installed CLI is newer than their pins, so a smoke run is needed before any freeze).
8. **The freeze, later.** Predictions, verdict rules, exact values and code are frozen in one commit after the power check, and an independent reader reads the frozen files before any run.
9. **Words.** Structural and exact. Use the Lean's and the records' terms; quote a source's own word where it is the source's ("alignment faking", "off-switch game"); mark a reading "[AI reading]"; no claim that a test "validates" the theory.
10. **Lessons.** Follow experiments/README.md, "Freezing a test on a trained system", and state where a design meets each lesson.

## What each builder returns

In `rf-tests-build/<key>/`: the scripts and their JSON; `front.md` (one paragraph per test, at most 110 words each, in this order: the question; the law and its standing; what the test can refute and what it cannot; the forbidden case; Stage 0's result in one line; what Stage B needs and Ren's yes); `hour.md` (per test: the law and what it forbids, what the test can refute, Stage 0 and its results, Stage B's design, premises, verdict rules, rivals and controls, what each outcome would change, what is not tested; about 650 words per test); `rest.md` (exact tables, the power check's specification and results, the rival table, usage, the plan's corrections in full, references with what each showed); `plan10.md` (the corrected plan §10 entry for its tests, at most 120 words per test); and, where a record's next step misstates its test, `records.md` with the exact correction.
