# WU: a way of units (AI-written, 13 November 2026)

Board item WU, claimed on 13 November 2026 at 07:35 WIB. Ren's words of that morning, kept in [sources](../../../../../../sources/15-codex-theory-conversations/2026-11-12-where-we-are-and-the-loop.md): "push first so I can read it on GitHub, then continue", taken as going on to what the page for him named as not shown, how what brings a level's difference to a way comes to stand. Lean: the new module `Becoming.WayOfUnits`, importing only `Becoming.TurningInTime`. Home: [02 §11](../../../../../../theories/becoming/chapters/02-MAP.md#turning-in-time), anchor [`r-a-way-of-units`](../../../../../../theories/becoming/chapters/02-MAP.md#r-a-way-of-units). Record `a-way-of-units`; the atlas dynamic `turning-in-time` extended with it.

```text
Result(s): turning-in-time (TurningInTime.pair, net, AloneOutside, asItWas, turns_in_time_iff, Three.giving);
  going-alike-up-to-the-nets-end (Law.stepWhile and its theorems on never ending, steps and no next); margin-of-a-regime
  and regime-point-under-adjusting-giving (RegimeMargin's step, premises, ends_below, holds, the adjusted run's
  bound); shared-laws-on-the-grammar (GrammarLaws.keep, keep_all, mem_keep); when-a-selection-read-off-
  continuation-reads (first_of_decided).
Delta: a way as the units present, each a need and a use, on TurningInTime's pair, with a next while some unit
  goes on; the exact condition for any number of units (unending_iff_holds); for two units, turns_in_time_iff
  with its premises on marks proved on a carrier of two values and a transfer (two_units_iff); a greater need of
  the first unit, or more of the use on it, never ends a line that did not end (greater_need, more_use_on_first);
  with a first unit that takes nothing the line never ends exactly where the second unit's line alone never
  ends (takes_nothing_iff_alone, takes_nothing_ends); one ending while the net goes on (ends_while_net_goes);
  two witness ways from one start.
Supplied premises / correspondence: the needs, the uses, y, y1, y2 and hi as parameters; RegimeMargin's Short,
  Meets, Keeps and FromNothing on the giving; for unending_iff_holds the regime along the course; n <= m for two
  units. The readings of ReadingsSpread's overdrawn focal line and ReadOffInTime's gauges are AI readings.
Evidence: a scratch build of 13 November 2026, every axiom report empty and no warning (66 declarations, 47
  theorems); the file was edited after it in comments only (three passages of the header and one docstring;
  statements unchanged). The core run's receipt at landing.
Boundary: units only end; nothing builds a unit or derives that one that needs more is there; the marks of a way
  that conditions on a reading are not derived; the comparisons are for two units below the point of no return
  of what both take; nothing about a trained system.
Integration: 02 §11 (written by the coordinating session), the record, regions, the atlas entry with nine new
  premises and twelve binder rows, the Lean README rows, the checker's CORE entry and SCOPE paragraph, the root's
  import and bullet (the registration, written apart from this note).
```

## What it is

`Becoming.TurningInTime` proves when a line turns in time, with the levels at which the level makes a difference to the way given as premises: `AloneOutside`, `turns`, `kept`, `uses` and `uses₁`. This module derives one source of such a difference. A way is the units present. Each unit goes on while the level meets its own need, and each takes its own use from the level. When a unit ends, its use ends with it. No level is marked, and no kind is given as kept.

## What is proved

Each theorem is listed with its premises in the record; this is the shape.

1. **The model** (section 1; definitions). `need`, `use`, `goes`, `after` (the root's `GrammarLaws.keep`), `taken`, `left` (`RegimeMargin.step` under what every unit present takes), `Goes`, `net` (`Law.stepWhile Goes` on `TurningInTime.pair`), `course`, `Holds`, `Regime`.
2. **On lists and steps** (section 2; short). `after_eq_iff`: the way after a step is the way exactly where every unit's need is met. `mem_course_iff`: a unit is present after `n` steps exactly where it was present and its need was met at every step before. `length_keep_le`, `length_keep_lt`, `met_or_unmet`, `all_iff_while`, `anyGoes_iff` and the decision of `Goes`.
3. **An ending while the net goes on** (section 3). `ends_while_net_goes`: where the level is below the need of one unit of the way and meets another's, the line under the way's class ends there while the net goes on. It is the counterpart of `TurningInTime.kind_ends_while_net_goes` for the units' net, not an instance of it: the nets differ.
4. **The exact condition for any number of units** (section 4; the content). `unending_iff_holds`, by `fixed_while`, `stays` (from `RegimeMargin.holds`), `falls` (from `RegimeMargin.ends_below` and `first_of_decided`), `course_within` and `reaches_holds` (an induction on a bound on the way's length).
5. **The course as it was never rises** (section 5). `level_le_start`, `level_le_of_le`: `RegimeMargin.Adjusted.orbit_bound` in the regime's form, and `Optimum.never_rises` in that form. The package reaches the latter only inside the private `TurningInTime.regime_levels`, so it is proved again here.
6. **Two units and the tie to TurningInTime** (section 6). The carrier `Bool`, the first unit there or ended (`firstAfter`, `firstUse`, `twoWay`, `carrierCourse`). The transfer is `unending_iff_carrier`. TurningInTime's premises on marks are proved for the carrier: `first_outside`, `first_turns`, `first_kept`, `first_uses`, `first_uses₁`. `orbit_id_true` re-proves the private `TurningInTime.Three.orbit_id`. With these, `two_units_iff`.
7. **Comparisons of two units** (section 7). `greater_need`, by `level_le_of_le`; `more_use_on_first`. Both go through `two_units_iff`, so both ask all of its premises.
8. **A unit that takes nothing** (section 8). `takes_nothing_iff_alone` asks only `n ≤ m`. `takes_nothing_ends` adds four premises: nothing given from nothing, `0 < n`, `Short` at `H₂` with `y₁`, and a start below `H₂ + y₁`.
9. **Two ways from one start** (section 9; computed). `With.goes_on` (by `two_units_iff`), `With.goes_on_holds` (by `unending_iff_holds`, a witness that its premises can be met together from two units), `With.levels`, `Against.turns_and_ends`.

## What is given and not shown

- Units only end. Nothing builds a unit, and nothing derives that a unit which needs more is there.
- The needs, the uses, `y`, `y₁`, `y₂` and `hi` are parameters. `Short`, `Meets`, `Keeps` and `FromNothing` are premises on the giving.
- `unending_iff_holds` asks the regime along the course, up to one `hi`, at every way the course reaches with some unit going on there and at every step before it.
- The marks of a way that conditions on a reading are not derived: TurningInTime's marks, the lock's window and `ReadOffInTime`'s gauges stay given. TurningInTime's `marked` is a property of levels. Here the level at which the way changes depends on the way, so `unending_iff_holds` does not go through `turns_in_time_iff`.
- `two_units_iff` covers two units, from a start below `h + H₂ + y₁` and at most `hi`. A start at or above that bound is outside it. `unending_iff_holds` covers such a start under its own premises, which ask `Meets` at `h + H₂` too.
- `greater_need` and `more_use_on_first` are for two units; the comparison for any number of units is not stated. The readers' simulations found each true with some of its premises dropped (below). That is not proved.
- Nothing is about a trained system.

## How it was made

From the files' own first lines and times, 13 November 2026, WIB.

- **A first design, attacked** (`DESIGN-attacked.md`, about 07:22). It said that one structure, a way of parts, made all of TurningInTime's premises on marks follow (G1 to G7). Three AI readers read it, read only, building nothing:
  - from the package's narrowing and loop modules and the word to use (`readers/r3-knowing.md`);
  - from the modules where something reads (`readers/r3-readers.md`);
  - for logic, with simulations (`readers/r3-logic.md`).
  They found two claims false as written. The general condition needed the way to be not empty. The two-unit claim could not be typed on lists, since `AloneOutside` and `uses` quantify over every way. The word "part", and the word "reader", named other things in the package. Three claims were lemmas or restatements.
- **The design, cut back** (`DESIGN.md`, 07:33): a narrower claim, the word "unit", the two-unit tie through a carrier of two values. The board row was claimed at 07:35.
- **Implemented in scratch** by one AI agent, then read by two AI readers: `readers/v1-statements.md` (statements against words, about 08:00) and `readers/v2-premises.md` (each premise by simulation, about 08:28).
- **Repaired.** `along` was asked one configuration less. `takes_nothing_iff_alone` was added, and `takes_nothing_ends` cut to five premises. `With.goes_on_holds` was added. The header gained the premises it had dropped and lost its claim that `greater_need` is false without its bound. A scratch build at 08:35 had every axiom report empty.
- **Reread cold** by a third AI reader (`readers/v3-cold.md`, about 08:43), which found no wrong statement and four wording points. Three were fixed in the file by 08:45; the fourth stays (`READER.md`). These last edits were to comments only. The scratch build's copy differs from the landed file in three header passages and one docstring, and in no statement.
- **The landing texts** (this folder, the record, the atlas rows, the registration) were written by one AI agent from the coordinating session's statement and TT's landing. The home section was written by the coordinating session.
- **Checked to refute** by two AI checkers, read only (about 09:17 and 09:21): `readers/k1-said-against-proved.md`, what the record, the home section and the registration say against what the Lean proves, and `readers/k2-data-and-registration.md`, the atlas data, the binder rows, the registration against TT's and this folder. Neither found a wrong claim about what the Lean proves. Their findings and what was done are in `READER.md`; those on 02 §11 are the coordinating session's to apply.

Two earlier scratch forms of the module are kept in `held/` as text files, so that no second `WayOfUnits.lean` lies under the repository: `held/WayOfUnits-v1.lean.txt` (817 lines, saved 08:32) and `held/WayOfUnits-v2.lean.txt` (902 lines, saved 08:44). Which reader read which form is not recorded; it is inferred from file times, line counts and content. The first was saved after `v2-premises.md` (08:28) and before the repairs, and still has what `v1-statements.md` and `v2-premises.md` flagged (the heading "List lemmas", a local `length_pos_of_mem`, "never end together", no `takes_nothing_iff_alone`), so it is most likely the form those two read, though whether it changed between 08:00 and 08:28 is not known. The second is the form `v3-cold.md` names ("902 lines", 08:43): it differs from the landed file only in the comments that report's wording points changed. The reports cite line numbers only in other modules (`Continuation.lean`, `RegimeMargin.lean`), none in `WayOfUnits`.

## Simulations

The readers' Python is kept in `sim/` as written; they ran it, and it was not run again for this note. The reports give its scratch paths (`…/scratchpad/sim.py`, `…/scratchpad/v2/`, `…/scratchpad/v3/`), which are now:

| Folder | Report whose numbers it backs |
|---|---|
| `sim/r3-logic/sim.py` | `readers/r3-logic.md` §1: the counts for G1 to G7, the table of dropped premises for G4, the 556 cases and the counterexample against G7 without `below` |
| `sim/v2/` (`wu.py` the translation, `gen.py` the generators, the rest the tests the report names, with `drops.py`, `drops3.py` and `wit.py` from the same folder) | `readers/v2-premises.md`: every table of §1 and §2, the counterexamples for each dropped premise, the scans behind "not needed" |
| `sim/v3/sim.py`, `sim/v3/sim2.py` | `readers/v3-cold.md` §2: the table of cases with every premise and with the premises the header names dropped |

The scripts are not Lean. What they found is cited in the record as found by simulation. Their claims that some premises are not needed have been argued, and partly so: they are not proved.

Four further scripts from the session's scratch folder are named by no report and are kept in `sim/unnamed/` as written, not run again. `g7.py`, `g7b.py` and `g7c.py` (07:24 to 07:26) search for a greater need of the first unit ending a line that did not end, the failure r3-logic reports against G7 without `below`; the counterexample that report cites is in its own `sim/r3-logic/sim.py`, and whether the three were that reader's earlier searches is not recorded (an inference from their times and what they compute). `sim_units.py` (07:32) tests, under the regime's premises at `H₂`, the design's two comparisons and that a line whose first unit takes nothing ends, and computes the witness ways; who wrote it is not recorded.

## Failed candidates and corrections kept

- **The first design's claims**: "one structure, from which all six follow", G4 without a way that is not empty, and G5 typed on lists. Also "a candidate's ending would be the same turn" and "the plain form of 'do not shield what would end first'". The file is `DESIGN-attacked.md`, and the three `r3-*` reports say why each failed.
- **The design's W3 line**, "false without `below`", rested on r3-logic's G7 counterexample. That counterexample also breaks `Meets` or `Short` at `H₂` (v2, v3). The module now says the opposite, as a simulation finding. `DESIGN.md` keeps the old line as written.
- **The first module's `takes_nothing_ends`**, which restated `RegimeMargin.ends_below` under five premises it did not use (v1). It was replaced by `takes_nothing_iff_alone` and a five-premise corollary.

## Readings, not proved

- Where a way is units that each take, the first of turning in time's three levels is the need of a unit, and no mark is given (02 §11, Reading).
- `ReadingsSpread`'s overdrawn focal line is such a unit.
- The gauges `near` and `mid` of `ReadOffInTime`'s witness of one loss need more and take nothing, so they are the case of `takes_nothing_iff_alone`: their ending changes nothing in the level's course, and they can only be read. Their model is another one.
- One list-sieve definition could carry the membership theorems of `Narrowing`, `ReadingLoop` and this module (`r3-knowing.md` §2). It would remove duplicated proofs, not show a shared turn. It is not done.

## What is in this folder

| Path | What |
|---|---|
| `NOTE.md` | this note |
| `READER.md` | the six readings in short, what was done about each finding, and what stays open |
| `A-WAY-OF-UNITS.md`, `A-WAY-OF-UNITS.zh.md` | the item on one page, in English and in Chinese written apart (Fable, after the landing) |
| `a-way-of-units.svg`, `a-way-of-units.zh.svg` | that page's picture: the two witness ways from one start |
| `DESIGN-attacked.md` | the first design, as attacked (Fable; `DESIGN.md`'s first line calls it `DESIGN-R3-attacked.md`) |
| `DESIGN.md` | the design after the attack (Fable) |
| `readers/` | `r3-knowing.md`, `r3-readers.md`, `r3-logic.md` on the first design; `v1-statements.md`, `v2-premises.md` on the first module; `v3-cold.md` on the module as landed, before its last wording fixes; `k1-said-against-proved.md`, `k2-data-and-registration.md`, the two checkers of the prepared landing |
| `held/` | the two earlier scratch forms of the module, as text files |
| `sim/` | the readers' simulations, as above; `sim/unnamed/`, four scripts no report names |
| `kit/` | `fill_records.py`, which binds the record to the core run, and the lander's commands |

Files copied from the session's scratch folder are kept as written. The reports name scratch paths, which this note maps to `sim/`.
