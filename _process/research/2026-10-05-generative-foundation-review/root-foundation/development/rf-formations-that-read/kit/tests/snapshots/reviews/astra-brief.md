You are an independent cross-model reviewer of test designs in the theory repository at the current directory (a git worktree). Read AGENTS.md first. Do not edit, create or delete any file, and do not commit. Make no network or model calls. You may run the Python scripts named below, which use only the standard library.

## What to review

The folder `experiments/formations-that-read/` holds the designs of nine tests, TR1 to TR9, of laws that board item RF proved in Lean's pure core. These are designs only: nothing is frozen and nothing has run on a model.
- `README.md` and `DESIGN.md`. DESIGN.md has three layers: a ten-minute part (at most 1,100 words), an hour part, and an index to the rest.
- `REST-*.md`: each test's full design.
- `trN.py` and `trN.json`: Stage 0. Each script mirrors the Lean's definitions, simulates the system the test may meet, and runs the power check.

Also changed:
- RF's plan, `_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md`; see `git diff` for §3, §4.1, §4.2, §4.6, §8, §10 (rewritten), §11 and §12.
- A record amendment script, not yet applied: `.../rf-formations-that-read/kit/tests/amend_next_delta.py`. Run it with argument `475` and no `--apply` to see the dry run of nine records' `next_delta` changes.

The Lean modules are in `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`: ShownOrder, Unread, Cascade, OpenedCorrection, ReadingLoop, ReflexivePrediction, ReadStages, HeldForReading and ListingValuation. Records are in `theories/becoming/results/records/<id>.json`.

## The rules the designs claim to keep

1. A run refutes at most a named correspondence or bridge, never the theorem.
2. Forbidden cases are stated in the law's own quantifier, with every hypothesis, and ties are excluded where the Lean has an equality boundary.
3. Premises are checked apart from the outcome.
4. Verdicts rest only on differences the power check resolves against the law's model with noise, readers fixed by what they read, all-or-nothing and threshold agents, and hybrids.
5. Each support rule has guards, and a control is added wherever a rival passes every contrast.
6. The call is the unit.
7. Usage is stated.
8. The freeze comes later.
9. Words are exact and structural.

## What to look for, most important first

(a) Any forbidden case, premise or verdict rule that misstates the Lean: check the theorem statements yourself.
(b) Any claim about Stage 0's numbers that the scripts or JSON do not support, and any flaw in a script's mirror, simulation or power check that would change a verdict rule.
(c) Any verdict that could pass or fail for a reason other than the bridge it names, any confound, or any missing control.
(d) Plan or record changes that misstate the Lean or the designs.
(e) Places where the ten-minute or hour layer overclaims, is unclear to a careful reader new to the work, or contradicts the rest.

## What to return

A numbered list of findings. Give each its severity (high, medium, low), its file and section or line, the problem, the evidence (theorem name and statement, script line, JSON key), and a concrete fix. Then a short paragraph naming what you checked and found sound, and what you did not check.
