# Review of freeze 11 (TR2's Stage A): a reader other than its author

5 November 2026. AI-written (a Claude Code session). One reader other than the freeze's author, a Claude Opus subagent of the theory's own family, read the frozen files before the freeze landed: a full read, then a second round on the diff, under the coordinator's rule (at most five rounds, stopping at the first with nothing high or medium). It worked read-only, with small checks in a scratch folder, retrained the development seeds (0 to 3) to check §7's disclosure, and never ran the plan. The text the review changed is [FREEZE-11.md](../FREEZE-11.md).

## Round 1: a full read

No high finding, six medium and eight low; every one taken. What kept a second round going was the frozen check, which round 1 found weaker than the text said.

| # | Finding | How it was taken |
|---|---|---|
| M1 | The frozen check did not require the freeze's own files: an empty `FROZEN.sha256`, or one committed again with new hashes, passed. | It requires the four files (`REQUIRED`) and one commit of `FROZEN.sha256`, and the readout records the freeze commit and HEAD. Dry-run cases for each refusal. |
| M2 | The root was `experiments/`, so the repository-relative paths every other freeze lists would have refused. | The repository's root; the dry run checks the required paths there, and `tr2a.py check` runs on the merged tree at the landing. |
| M3 | The dry run rewrote its hashed result with a fresh time, so any rerun broke the freeze. | The hashed result is the same on every run (checked twice); the time goes to an ignored file. |
| M4 | A network not fitting the readings counted as "no twin". | None is counted for it, and the readout says how many did not fit. |
| M5 | §7 did not say whether settings were tuned after seeing outcomes. | It says the settings were set once, names the two changes after the first trainings (the xor act added; the twin split from generalization), and names the dry run's own trainings. The reader's retraining agreed with §7. |
| M6 | Some checks §6 named were not counted. | Counted, with the act counts asserted: 37 checks. |
| L1–L8 | F3 counted per unread occasion, not per pair; what `twin_selected` says; what is settled before the run; the cue pairs under S2 and S3; inexact readout wording; placeholders; pages that would go stale; docstring gaps. | Each taken in the text, the code's docstrings, README, DESIGN, REST and a dated note in FREEZE-7. |

## Round 2: on the diff

Nothing high or medium; four low, taken: `experiments/README.md` still listed TR2's Stage A as a design; `check` counted the commits with the files; three phrases claimed slightly more than the dry run checks; the time file was committed. The reader checked the new frozen check end to end in a scratch repository with the real layout, including a landing by merge (the merge commit is not a second commit of `FROZEN.sha256`) and a second commit (refused).
