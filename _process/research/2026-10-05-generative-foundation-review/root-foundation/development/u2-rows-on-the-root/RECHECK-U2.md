# U2's leaf: the re-check of its 21 items against their rows

AI re-check, 30 October 2026, by one independent reader, read-only, of the leaf `Becoming.ModelStatements` as it lands: 78 theorems in 121 declarations, at `f8bcee9b4`, where its kit moved to `78cdcc2c5` during the reading. F5's specification ([mv/F5-MODEL-STATEMENTS.md](../../../../2026-10-05-repository-reconciliation/architecture/mv/F5-MODEL-STATEMENTS.md) §6) asks for it: [REVIEW-U2](REVIEW-U2.md) read the 48-theorem scratch, before rows 11, 14, 15, 16 and 20–24 took their present statements and before `renewing_not_closed` existed. Each item's `review` names this re-check.

**What the reader checked.** For each of the 21 items it checked four things:
- whether the declaration states what its row states at the declared models, with exactly the row's hypotheses: none weakened, strengthened or vacuous, none dropped;
- whether the declared models are right;
- whether the proof goes through the row;
- whether the law text drafted for the row's record says exactly what the declaration shows.

It found the leaf and the scratch hold the same declarations, and reran the dependency check: all 21 reach their rows. It compiled three probes (items 4, 10 and 19).

## The items

All 21 declarations state their rows exactly at their declared models and are proved through them. None reaches its row only through another row's statement at a model.

| # | Item → row | Verdict |
|---|---|---|
| 1 | `roles_supported_reading` → `Web.roles_supported` | holds |
| 2 | `roles_dependent_reading` → `Web.roles_dependent` | holds |
| 3 | `roles_alive_reading` → `Web.roles_alive` | holds (with S1) |
| 4 | `renewingAt_iff_over_all_reading` → `Web.renewingAt_iff_over_all` | holds. Its full-region conjunct follows from `participating` (checked in Lean): the row's own redundancy, nothing vacuous added |
| 5 | `transmits_at_reading` → `Web.transmits_at_iff` | holds (law text, W3) |
| 6 | `identifies_iff_reading` → `Limit.identifies_iff_tracks` | holds. `process` is right by F5's lists (law text, W4) |
| 7 | `verifiableBy_reading` → `Ideals.verifiableBy_iff_interior` | holds |
| 8 | `significant_iff_held_reading` → `Valuation.significant_iff_held` | holds (Chinese text, W5) |
| 9 | `significance_undetermined_reading` → `Web.significance_undetermined` | declaration holds; **law text fails** (error): it dropped the hypothesis that some claim lives, without which its last clause is false |
| 10 | `only_together_reading` → `Dependence.Overdetermined.only_together` | declaration holds; **law text fails** (should-fix): it dropped the hypothesis that the parts make the difference together, and so stated another theorem |
| 11 | `response_not_fixed_reading` → `ExchangeLaw.response_not_fixed_by_coupling` | declaration holds; **law text fails** (should-fix): it dropped the decidability hypothesis, the step and "any condition" |
| 12 | `kernel_and_reading` → `Viability.kernel_and_iff` | holds |
| 13 | `differenceOnlyTogether_reading` → `Dependence.differenceOnlyTogether_iff` | holds |
| 14 | `not_fixes_reading` → `Run.not_fixes_of_untaken` | declaration holds; **law text fails** (error): its last clause dropped "each fixing its successor" and "before t", which makes the characterization false |
| 15 | `run_agrees_every_start_reading` → `SharedCodes.run_agrees_every_start_iff` | holds |
| 16 | `optimum_broken_reading` → `Web.optimum_broken_iff` | holds (law text, W6) |
| 17 | `living_on_reaches_reading` → `Web.living_on_reaches` | holds (W1) |
| 18 | `descent_reaches_reading` → `Flow.descent_reaches` | holds (W1) |
| 19 | `unselected_beyond_data_reading` → `Learning.Training.unselected_beyond_data` | holds. The closure is equivalent to the row's `Through` (the converse checked in Lean) |
| 20 | `finite_reading_not_exact` → `Renewable.no_exact_finite_reading` | holds |
| 21 | `renewing_not_closed` → `Renewable.no_exact_finite_reading` | holds. It is equivalent to the row by `finite_reading_iff`, pure logic. Its path through item 20 is the one F5 allows (same law, same row) |

## Other findings

**Should-fix.**
- **S1.** What a reading keeps was under-reported, because some of U2's relations were the rows' own notions under a new name:
  - `breaking` and `keeping` (`Dependence.Breaks`, `Keeps`);
  - `couplingAlike` (`Web.AlikeThroughUpTo`);
  - `undermined` (it contained `Web.MetAbove`);
  - `copies` (`SharedCodes.back`);
  - `renewingAlong` (`Dependence.along`).
- **S2.** DESIGN was out of date in six places:
  - the counts and the log;
  - "all 20 readings";
  - row 24 without `renewing_not_closed`;
  - row 6's model;
  - row 11's description, with item 10's omission;
  - the room clause of row 20.
- **S3.** The leaf's docstring did not list what statements also keep:
  - decidability data;
  - logic premises;
  - in item 16, the model's raw data and an unnamed comparison.

**Wording.**
- **W1.** An `own` binder not in the statements of items 9, 17 and 18. It is implicit in the last two, so Lean could not infer it at a use.
- **W2.** `undermined` "reads the dependence since it formed". It reads it from some step since which the dependence has held.
- **W3.** Item 5's "first step" is not in the statement.
- **W4.** Item 6's "On the step index" against its model `process`. The kit's claim that its models follow the design's column, which said "the step index".
- **W5.** Item 8's union written 合, which names the meet here.
- **W6.** Item 16 needs "by the formation named on it".
- **W7.** The kit's comment described the draft field as final.
- **W8.** `lowerBeyond`'s docstring did not say which outcome stands lower.

**The reader's verdict.** Items 1–8, 12, 13 and 15–21 may name this re-check as they stand. Items 9, 10, 11 and 14 may not until their law texts, in both languages, carry the hypotheses their declarations state. S1–S3 do not affect verification, but should be fixed before landing.

## How each finding is taken

| Finding | Taken in |
|---|---|
| Items 9, 10, 11, 14: the law texts | `kit/laws_u2.py`, as the reader gave the fixes, both languages:<br>• item 9 adds "Where a claim lives at the occurrence model";<br>• item 10 states the parts whose but-for statement holds together;<br>• item 11 states the decided classes, the step and any condition;<br>• item 14 states "each fixing its successor and holding the run's steps before t".<br>All are within the caps (English 386 of 420 at most, Chinese 109 of 190) |
| S1 | `breaking`, `keeping`, `undermined` and `couplingAlike` are written out as their comparisons, each definitionally the notion it wrapped, so the proofs are unchanged. `copies` (the graph of `SharedCodes.back`) and `renewingAlong` (`Dependence.along`) are named in DESIGN §1 and in §2's kept column. The dependency check now expands the leaf's own definitions when it reports what is kept ([log](check/deps.log)), and shows `Web.Admits`, `SharedCodes.back` and `Dependence.along` where they are |
| S2 | DESIGN's status, counts and log, "21 items", row 24 with `renewing_not_closed`, row 6's model, row 11's description and row 20's room clause |
| S3 | The leaf's docstring lists the model's own data where compared, and the premises of logic or decidability a row takes |
| W1 | `own` moved into the proofs of items 9, 17 and 18. The valuation's own regions do not enter what they state |
| W2 | `undermined`'s docstring and DESIGN §1 |
| W3–W6 | `kit/laws_u2.py`: "the step after the giving step"; "At a process's model, ... on the step index"; "some position's own region", 某一位置之自有域; "by the formation named on it" |
| W7 | The kit's comment describes the final shape |
| W8 | `lowerBeyond`'s docstring says the second outcome stands lower than the first |

After these changes the leaf builds with 78 theorems in 121 declarations, every axiom report empty, and the dependency check passes for all 21 items.

## The reader's confirmation

The same reader confirmed the changes at `df7a965f8`, read-only, on five points:
- the four law texts now say exactly what their declarations show, in both languages;
- the other wording edits and the kit's comments;
- each written-out definition equals by `rfl` the notion it wrapped, with no statement's meaning changed;
- moving `own` into the three proofs is sound, since `transmits`, `living` and `Significant` never read the own regions (a probe derives each row at any `own` from the reading);
- the docstrings.

It reran the dependency check, which matches its log, and the records kit's dry run against this file: 16 records, 20 laws, 21 items, nothing written.

Two findings remained, both taken:
- Item 16's Chinese text now carries "by the formation named on it": 彼外每一条件皆为其上所名之形成所需且满足.
- The leaf's opening list separates the two uses in item 16: the levels after a step read as an outcome, and an outcome's level at a condition compared with a need.

With these, all 21 items name this re-check as their review.
