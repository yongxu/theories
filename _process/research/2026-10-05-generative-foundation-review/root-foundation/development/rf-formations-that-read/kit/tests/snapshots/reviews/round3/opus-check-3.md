*The Opus reader's report of the third check, verbatim (31 October 2026); read-only on rf-round2 at 5094ab46c. `m2null.py` beside it is the integrator's 3,000-run check of the note outside the diff (3 of 3,000 at 0.00208).*

I found no medium or high problems: every claimed fix in the second round is in the files and is correct. Four small textual problems remain. Nothing in the worktree was edited, and no script was rerun, because every number could be checked from the JSON.

**Step 1.** I checked all 24 rows (20 from the five lenses, 4 from astra). For the medium ones:
- **lean2-1:** every cited name exists in `RevisionPlans.lean`, `HeldForReading.lean` and `ListingValuation.lean` and says what the text says. `forgone_lt_iff` is in fact proved through `above_iff` and `held_above_held_iff`.
- **scripts2-2:** the m4 test and the Holm correction over 24 p-values are in the code and the JSON.
- **scripts2-3:** the G-arm figures 0.022, 0.0036 and 0.337 are all in `harness_check`.
- **scripts2-4 and astra2-13:** the logic of the guard beside an unresolved bridge in `full_protocol` is right; the 0.0003 and 0.0006 figures and G1's 1.0 match the JSON.
- **taken2-1:** TR6's bridge is stated the same way in all four layers.
- **taken2-3:** the sensitivity wording is consistent across layers.
- **astra2-12:** the coupling code and the 3,200 to 4,800 change match `tr2.json`.
- **astra2-14:** the exact union for tied modal options is in `probe_ranks_any_first`.

The TR7 forbidden cases match `ReadStages.lean`. The other figures I checked against the JSON: the 448,517 checks, the 0.815 and 0.807 thresholds, 0.0385 and 0.028, 0.99 and 0.92, 0.42 and 0.27, 0.97 and 0.91, 0.0057 and 0.0504, plan_pairs 16,607,472, and the TR4 ranges.

The one claim not exactly as stated is in REVIEW.md itself (item 1 below); the file it describes is correct.

**Problems found (all low):**

1. **`experiments/formations-that-read/REVIEW.md:95` (scripts2-1).** The row says the constant control is now named apart at "(0 and 0.002)". The file it describes, `REST-TR4-TR5.md:126`, says "at 0 and 0", and `tr4.json` (constant hallucination, U=40: first 0.0, last 0.0) supports the file, not the row. Fix: change "(0 and 0.002)" to "(0 and 0)".

2. **`experiments/formations-that-read/tr8.py:1213`, carried into `tr9.json:7930`.** The `full_protocol.assumptions` text is hard-coded as "G1's probe computes R5's cost-blind counts". `tr9.py` imports `part_D_full`, so `tr9.json` says R5 too. But TR9's G1 uses N8's counts (`tr9.py:1015-1017`, and REST-TR8-TR9 R11 says N8). Fix: pass the rival's name into `part_D_full` and regenerate both JSON files, or word the line generically ("a cost-blind count: R5's in TR8, N8's in TR9").

3. **`experiments/formations-that-read/DESIGN.md:110`.** It reads "G, scored first: m2 and m3 on harness-written records". But m2 and m3 test the crew's acts, not the records. REST-TR4-TR5 lines 72 and 88 and `tr4.py:43` say "on the crew's acts". Fix: "m2 and m3 on the crew's acts at harness-written records".

4. **`experiments/formations-that-read/REST-TR8-TR9.md:325` (R7 item 6).** The guard is stated with one extra trigger beyond the hour part and the code: "a bridge otherwise supported is reported contradicted if … a contradicted condition in the same context, or a supported condition whose probe …". A bridge that is otherwise supported has no contradicted condition, so the first trigger can never apply. As written, the rule reads differently from `DESIGN.md:196` and `full_protocol`. Fix: drop that clause, keeping only the probe trigger.

**No stale text remains in the live design files.** There is no "18 p-values", "0.05/18" or "m1, m2 or m3" in live TR4 text. "Worst case" in TR2 now means only the worst coupling, and the remaining hits in TR1 refer to an unrelated worst-case rule. Neither TR8 nor TR9 still calls the menu ranking a candidate lemma; the only "candidate core lemma" left for them is `expanded_shortfall` (with `answer_least_of_scaled` + `informed_le` for TR9), and no verdict rests on either.

**Outside the diff, not counted above:** at 60 units the faithful-crew row has m2 rejecting at Holm's first step in 4 of 400 runs (0.01). That is high for an exact test at 0.00208, where about 1% of runs would show 4 or more by chance. It predates this round (the old `tr4.json` has the same 0.01), but it may be worth a look before the freeze.
