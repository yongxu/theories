AI-written (Opus reader), 13 November 2026. A read-only reading of the trimmed `Becoming.WayOfUnits` (`tmp/r7/wu2/lean/Becoming/WayOfUnits.lean`) against the landed file and `tmp/r7/wu2/TRIM.md`. No Lean, checker, gate or test was run; git was not touched. The simulations are python, not Lean: what they find is computed cases, not theorems.

# Verdict

The three statements are the ones TRIM asks for, and the simulations found no case where any of them is false. Each premise left in them is needed: dropping any one gives a computed counterexample. That includes `FromNothing`, which an exhaustive search at `hi ≤ 5` had wrongly suggested could go. No other statement of the module changed. Two theorems were removed (`level_le_start`, `level_le_of_le`). No hand-written text cites them, but one formal-reuse relation in the record now describes a use the module no longer makes. The record, 02 §11, the atlas rows, the study note, the page for him, the README rows and the checker's SCOPE paragraph now say less than the Lean proves, or name premises it no longer has. They are listed below for the coordinator.

# (a) The statements by simulation

Scripts, all in `tmp/r7/wu2/readers/`:

- `t1_sim.py` translates the module as written: lists of units, `after` as the filter (`GrammarLaws.keep (goes x)`), `taken` the sum of uses, `left` as `RegimeMargin.step` (`(x - H) + g (x - H)` in truncated subtraction), the net's guard `Goes` (some unit present with its need met), `course` the uncut pair orbit, and "never ends" as `Goes` at every step (`Law.stepWhile_unending_iff`). `Short`, `Meets`, `Keeps` and `FromNothing` are as in `RegimeMargin.lean`. Giving is a finite table with a constant tail. The orbit is followed until a state repeats, so "never ends" is decided exactly, and a run with no repeat within the cap counts as undecided and is not used.
- `t1_fast.py` is a targeted random search (`n ≥ 1` in about 97% of draws).
- `t1_exhaust.py` searches exhaustively over every giving read by the lines, up to `hi`.
- `t1_hand.py` and `t1_verify.py` are hand-built cases plus a recheck of every counterexample reported.

One earlier output was wrong and has been corrected. `t1_fast.py`'s first run counted an undecided second line as an ending, and its report left out the giving's tail. Its "counterexamples" without `Keeps` and without `x ≤ hi` came from that, and `t1_verify.py` showed them spurious. The fixed run and the cases below are rechecked.

## With every premise

| statement | cases with the first line unending | of which `n = 0` / `n = m` / `h = 0` | false |
|---|---|---|---|
| `unending_above` (T0) | 6 140 random (all `n ≥ 1`, since `needs` is asked) | 0 / 1 872 / 3 097 | none |
| `greater_need` (T1) | 858 random (first run, mostly `n = 0`) + 1 617 random (286 `n > 0`) + exhaustive `hi ≤ 5`, `n ≥ 1`: 117 970 | many / 482+ / about 15% | none |
| `more_use_on_first` (T2) | 894 random (first run) + 1 546 random (162 `n > 0`) + exhaustive `hi ≤ 5`, `n ≥ 1`: 58 221 | many / 436+ / about 15% | none |

T1 and T2 apply only to starts at most `hi`. Starts above `hi` were tried only with `x ≤ hi` dropped, below.

## Each premise dropped in turn (the others kept, the dropped one broken)

Notation: giving is a table `g 0, g 1, …`, zero beyond it unless a tail is named. "Levels" are the course's levels up to the repeat.

**T0 `unending_above`** (`n ≤ m`, `FromNothing`, `Short giving H y`, `0 < n`):
- without `n ≤ m`: g = 0,1,0; m 0, h 1, n 8, H 3, y 2, start 5. The levels run 5, 2, 2, …: the first unit (need 0) goes on for ever, at 2 < H + y = 5.
- without `FromNothing`: g = 2,3,1,3,1,3,2,1; m 3, h 3, n 1, H 6, y 0, start 4. The levels run 4, 2, 2, …: never ends, at 2 < 6.
- without `0 < n`: any start below `H + y` with `n = 0` (for example g = 0,9,9,7,…; m 1, h 2, H 6, y 1, start 6, levels 6, 0, 0). This is what the docstring says, and `unending_needs_nothing` proves it.

**T1 `greater_need`** (`n ≤ m`, `m ≤ m'`, `FromNothing`, `Short`, `Meets`, `Keeps` at `H₂` up to `hi`, `x ≤ hi`):
- without `n ≤ m`: g = 0,5,2,4,0,0,3; hi 3, m 0, m' 1, h 0, n 4, H₂ 4, y₂ 0, start 3. First line 3, 0 with the unit needing 0 going on; second line ends.
- without `m ≤ m'`: g = 0,3,3,3,3,3; hi 5, H₂ 3, y₂ 1, h 1, n 1, start 5, m 6, m' 4. The first line runs 5, 4, 4, … (the first unit ends at 4). In the second the first unit stays at 4 and takes 4: 5, 4, 0, and it ends.
- without `FromNothing`: g = 2,0,2,0,0,0,0; hi 6, H₂ 3, y₂ 4, h 1, n 2, m 2, m' 7, start 6. The first line runs 6, 4, 2, 2, …: the first unit still there at 4 takes 4, and 2 comes from nothing. The second takes 3 at 4: 6, 4, 1, and it ends. Exhaustive search found 40 such cases at `hi = 6` and none at `hi ≤ 5`.
- without `Short`: g = 0,5,2,2,5,1,2,6,3,3; hi 6, H₂ 4, y₂ 4, h 1, n 1, m 6, m' 9, start 6. Levels 6 against 6, 6, 4, 0.
- without `Meets`: g = 0,4,0,0,2,2,1,2,6,5,5; hi 7, H₂ 2, y₂ 1, h 2, n 4, m 4, m' 8, start 5. The second line ends.
- without `Keeps`: g = 0,7,3,0,4,4,0; hi 5, H₂ 3, y₂ 1, h 1, n 1, m 5, m' 9, start 5. Both lines go 5, 8 (above `hi`, since `g 1 = 7` breaks `Keeps`). The first stays at 8 with both units; the second takes 3 from 8: 9, 6, 3, 0.
- without `x ≤ hi`: g = 0,4,3,0,4,4,0; hi 5, H₂ 3, y₂ 1, h 1, n 1, m 8, m' 9, start 8. The first line stays at 8; the second runs 8, 9, 6, 3, 0.

**T2 `more_use_on_first`** (`n ≤ m`, `FromNothing`, `Short`, `Meets`, `Keeps` at `H₂'`, `h + H₂ = h' + H₂'`, `h ≤ h'`, `x ≤ hi`):
- without `n ≤ m`: g all nothing; hi 2, m 1, n 5, h 0, H₂ 1, h' 1, H₂' 0, y₂' 0, start 2. The first line runs 2, 1, 1, … on the first unit alone taking 0. The second runs 2, 1, 0 with that unit taking 1, and it ends.
- without `FromNothing`: g = 2,0,2,0,0,0,0; hi 6, m 7, n 2, h 0, H₂ 4, h' 1, H₂' 3, y₂' 4, start 6. The first line runs 6, 4, 2, 2, …; the second runs 6, 4, 1, and it ends.
- without `Short` at `H₂'`: g = 0,0,3,0,0,0; hi 5, m 6, n 2, h 0, H₂ 3, h' 1, H₂' 2, y₂' 4 (`Meets` and `Keeps` hold, `Short` fails at `g 2 = 3`), start 5. The first line runs 5, 5, …; the second runs 5, 5, 3, 1, 0.
- without `Meets` at `H₂'`: the same case with y₂' 2 (`Short` and `Keeps` hold, `Meets` fails at `g 3 = 0`). A random case is also in `t1_fast.out`.
- without `Keeps` at `H₂'`: g = 0,7,3,0,4,4,0; hi 5, m 9, n 1, h 0, H₂ 4, h' 1, H₂' 3, y₂' 1, start 5. The first line runs 5, 8, 8, …; the second runs 5, 8, 9, 6, 3, 0.
- without the same sum: g = 0,3,1,0,6,2,3,4,0; hi 5, m 7, n 2, h 1, H₂ 2, h' 1, H₂' 4, y₂' 3, start 4.
- without `h ≤ h'`: g = 0,1,1,2,6,0,3,4; hi 4, m 8, n 1, h 3, H₂ 0, h' 0, H₂' 3, y₂' 4, start 4.
- without `x ≤ hi`: g = 0,4,3,0,4,4,0; hi 5, m 9, n 1, h 0, H₂ 4, h' 1, H₂' 3, y₂' 1, start 8. The first line stays at 8; the second runs 8, 9, 6, 3, 0.

So no premise of the three statements can go. The docstrings make one claim about need, that `unending_above` asks `0 < n` because of `n = 0`, and it is right. The header says "Whether `Short`, `Meets` and `Keeps` at the second unit's use can be dropped further is not shown." That now says less than is known: each has a concrete counterexample when dropped, and so do `FromNothing`, `n ≤ m` and `x ≤ hi`. These are computed cases, and they could be stated as such, or made Lean witnesses like `Against`.

# (b) The diff against TRIM.md

- **The statements are the ones asked.** T0 is `unending_above` with exactly TRIM's premises (`n ≤ m`, `FromNothing`, `Short giving H y`, `0 < n`) and conclusion. `n = 0` is treated apart, as TRIM allows, through `unending_needs_nothing` and the `Nat.lt_or_ge 0 n` split in T1 and T2. T1 and T2 have exactly the premise lists TRIM gives. The names are kept, and the old proofs through `two_units_iff` are gone.
- **No other statement changed.** `two_units_iff`, `unending_iff_holds`, `takes_nothing_*`, `With`/`Against` and every definition are byte-identical. The new declarations are `carrierStep` (an abbrev), `step_falls`, `use_at_least`, `carrier_falls`, `carrier_above`, `unending_above`, `unending_needs_nothing`, `keeps_use`, `carrier_within`, `alone_holds`, `step_above_need`, `greater_need_along`, `step_same_sum`, `there_or_ended` and `more_use_along`. That is 79 declarations and 59 theorems, against 66 and 47 before; `build.log` agrees.
- **Removed:** `level_le_start` and `level_le_of_le`. With them the module no longer uses `RegimeMargin.Adjusted.*` (`orbit_regime`, `orbit_bound`, `regime_staysShort`, `regime_fromNothing`, `draw_pos`); a grep of the new file finds no `Adjusted`. The sections are renumbered: the old §5 is gone, the old §6 "Two units" is now §5, and the new §6 is `unending_above`. §7–§9 keep their numbers.
- One small difference from TRIM's sketch: `keeps_use` needs no `FromNothing`, since `z - (h + H₂) = (z - h) - H₂` always holds in truncated subtraction. Its docstring rightly names only `keeps`.

# (c) Header and docstrings, sentence by sentence

All the new and changed sentences match their statements. Notes:

1. **"point of no return" said with `Short` alone** (minor wording). The header bullet "A line of two units that never ends stays above the second unit's point of no return" and the title of §6 call `H₂ + y₂` the point of no return. `unending_above` asks only `Short`, which holds for any `y` up to that point (for `y = 0` the theorem says only "at or above `H`"). The theorem's own docstring says it better: "the level from which the second unit holds alone" is also more than `Short` gives. Suggested: "stays at or above `H₂ + y₂`, below which the level under the second unit's use falls" (§6 title likewise). The module already used "point of no return" for `h + H₂ + y₁` under `Short` alone, so this follows existing use, but it still says more than is there.
2. **"stays above"** in that bullet's title, where the theorem says at or above. Minor.
3. **"Whether `Short`, `Meets` and `Keeps` … can be dropped further is not shown."** See (a): each has a computed counterexample, and so do `FromNothing`, `n ≤ m` and `x ≤ hi`. Say so, as computed cases, or keep the sentence; as it stands it says less than is known.
4. `greater_need_along`'s docstring: "The two leave each other where the level is below `m'` and the first unit is there". In the proof the second line also takes the `.inr` branch where the first unit had already ended in both lines (there `first_turns` gives `false` all the same). Harmless, slightly narrower than the proof.
5. Words: no theorem is called a law, and none of reader, part, candidate, shed, shield or canary appears in the new text. "Unit", "goes on", "ends" and "takes" are used as asked. Every new declaration has a docstring naming its premises. Some name them only by role: "(`low`)", "(`keeps`)" on `use_at_least` and `keeps_use`, which say the premise and its name. `step_above_need`, `step_same_sum` and `there_or_ended` are short and complete.
6. The "What is given" paragraph's list of what T1 and T2 do without is exact. Its new lines on `unending_above` asking `0 < n` and on `unending_needs_nothing` are right.

# Stale citations (for the coordinator)

Sentences that would now be stale, wrong, or saying less than the Lean, if the trimmed file lands:

**Record `theories/becoming/results/records/a-way-of-units.json`**
- l. 88–89 (en/zh), the `greater_need` statement: "under two_units_iff's premises (… 0 < n ≤ H₂ + y₂, Short at h + H₂ with y₁, x < h + H₂ + y₁, x ≤ hi) and m ≤ m'". Now: `n ≤ m`, `m ≤ m'`, `FromNothing`, `Short`/`Meets`/`Keeps` at `H₂` with `y₂` up to `hi`, `x ≤ hi`.
- l. 95–96 (en/zh), the `more_use_on_first` statement: "0 < n, … Short at h + H₂ with y₁, x < h + H₂ + y₁, … and for H₂ with y₂ and for H₂' with y₂' each Short, Meets …, Keeps … and n at most the sum". Now: only at `H₂'` with `y₂'`, no `0 < n`, no `y₁`, no `within`. The zh text, "two_units_iff 的前提对 (h, H₂, y₂) 与 (h', H₂', y₂') 各自成立，共用 y₁", is stale too.
- l. 157: "For two_units_iff and greater_need: … greater_need adds m ≤ m'. A start at or above h + H₂ + y₁ is outside both." greater_need no longer shares these premises, and a start at or above `h + H₂ + y₁` (at most `hi`) is now inside it.
- l. 160: "For more_use_on_first: these premises for both pairs of uses … with one y₁".
- l. 179 (does_not_show): "The comparison theorems are for two units from below the point of no return of what both take; simulations found them true with some premises dropped, which is not proved."
- l. 224: "(66 declarations, 47 theorems)". Now 79 and 59.
- l. 298–312, the relation `regime-point-under-adjusting-giving` (formal-reuse): "Reuses the bound on the adjusted run … for the course as it was never rising", with conditions "Giving short of h + H₂ below y₁; the start below h + H₂ + y₁". The module no longer uses `RegimeMargin.Adjusted.*` directly; only `turns_in_time_iff` does, inside `two_units_iff`. Either drop the relation or re-say it as reached through TurningInTime.
- The declarations list (l. ~440–470) has none of the new theorems. At least `unending_above` and `unending_needs_nothing`, which say something by themselves, may want entries, and a statement line for `unending_above`.

**Chapter `theories/becoming/chapters/02-MAP.md`, §11**
- l. 519: "Under the same premises a greater `m` never ends a line that did not end (`WayOfUnits.greater_need`), and neither does more of the use on the first unit …". Still true, but it says less: now under `n ≤ m`, nothing from nothing and the regime at the second unit's use, from any start at most `hi`.
- l. 523: "`WayOfUnits.greater_need` and `WayOfUnits.more_use_on_first` are for two units, from below the point of no return of what both take". Stale: they hold from any start at most `hi`.

**Atlas `theories/becoming/results/atlas/entries/dynamics.json`**
- l. 2148: "the comparison theorems for any number of units, and their premises trimmed to what the simulations found enough … None is stated." The trim is now stated, and the simulations here found every remaining premise needed.
- l. 2313–2327, the binder row for `greater_need`, "takes": `optimum-coupled-need-positive`, `turningintime-within` and `regimemargin-start-below-point` are no longer premises.
- l. 2330–2345, the binder row for `more_use_on_first`, "takes": the same three ids are stale. Its `regimemargin-short/meets/keeps` are now at `H₂'` only.
- l. 1927–1960, the `lean` list: `unending_above` is not there (an addition, if wanted).
- The `wayofunits-*` premises in `premises.json` (l. 34570–34665) stay right.

**Study note `_process/…/wu-a-way-of-units/NOTE.md`** (append-only practice: the coordinator may add a dated section rather than rewrite)
- l. 8: Result(s) "regime-point-under-adjusting-giving (… the adjusted run's bound)".
- l. 21–22: Evidence "(66 declarations, 47 theorems)".
- l. 25–26: Boundary "the comparisons are for two units below the point of no return of what both take".
- l. 44, item 5: "**The course as it was never rises** (section 5). `level_le_start`, `level_le_of_le` …". Both theorems are removed.
- l. 45, item 6: "(section 6)". Now section 5.
- l. 46, item 7: "`greater_need`, by `level_le_of_le`; … Both go through `two_units_iff`, so both ask all of its premises."
- l. 57: "The readers' simulations found each true with some of its premises dropped (below). That is not proved."

**The page for him `_process/…/wu-a-way-of-units/A-WAY-OF-UNITS.md` and `.zh.md`**
- l. 29: "Three comparisons, for two units, from a start below the level at which both would hold:" (zh l. 29: "三个比较，都是对两个单元、从两者都守得住的水位之下出发"). Two of the three now hold from any start at most `hi`.
- l. 44 (en and zh): "The three comparisons are for two units. Simulations found them true with some premises dropped; that is not proved." (zh: "模拟发现去掉某些前提后它们仍然成立；这一点没有证明。")

**Lean package text** (not generated)
- `README.md` l. 397 and `README.zh.md` l. 246: "under those premises [two_units_iff's] a greater need of the first unit, or … more of the use on it, never ends a line that did not end". Says less than the Lean.
- `check_becoming.py` l. 475–476, the SCOPE paragraph: "Under those premises a greater need of the first unit …". The same. This is the checker's own text, for the coordinator to edit.

**Generated, regenerated at landing (not to hand-edit):** `results/lean-declarations/becoming-core-part-7.md` l. 3225–3226 (rows for `level_le_start`, `level_le_of_le`), `results/data/lean-index.json` (l. 156528, 156534), `becoming-verification.json`, `results/data/atlas.json`, `results/records/a-way-of-units.md`, and the atlas pages `premises/a.md` and `families/a.md`.

`RESULT-WORKFLOW`'s frozen-section rule may apply to any note section that a record cites. I did not check which of the note's sections are cited by anchor.
