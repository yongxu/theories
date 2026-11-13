AI-written (Opus reader), 13 November 2026. A read of section 7 of `Becoming.TurningInTime` (the working copy `tmp/r7/nr/lean/Becoming/TurningInTime.lean`), compared by diff with the landed module. Read only: no Lean was built or run, and no checker, gate or test was run. The simulations are in python, in `/private/tmp/claude-501/-Users-ren-theories/3c343411-bb06-4ddc-aa7a-5f9cd79133ad/scratchpad/v1sec/`: `core.py` (the model), `r123.py`, `pair.py`, `pair2.py`, `r6drop.py`, `r6search.py`, `r6search2.py`, `verify.py`, `verify2.py`, `keptstart.py`.

## (a) The statements, by simulation

**The model.** It follows the Lean as written now:
- `step g H x = (x - H) + g (x - H)`, with truncated subtraction. `FromNothing`, `Short`, `Meets` and `Keeps` are as in RegimeMargin.lean:249-265.
- `turned X g H T t` is `X t` for `t ≤ T`, and the orbit under `H` from `X T`, `t - T` steps on, after that.
- `Turned` is "some T" with T from 0, so the start is included. `MeetsNeed` means `need ≤` the course at every step.
- `Recoverable` and `NoReturnAt` are as in ReadOffInTime.lean:591-598. Agreement holds at every step `s ≤ N` (Counterfactual.lean:132).
- On the pair: `AloneOutside`, `turns`, `kept` and `uses` are as stated. `left w x = step g (use w) x`. The first marked step is taken on the course as it was.

Orbits are decided by cycle detection. The witness `T` of `Recoverable` is searched up to `max(len X, N) + 2`; beyond that the turned courses repeat.

**The cases.**
- Givings: the tents `min z (m - z)` for m = 8 to 16, and random tables with `g 0 = 0`.
- Courses: arbitrary non-rising lists, constant courses, and N = 0.
- Pairs: as-it-was ways along a cycle or a path of `alone`, with uses that vary but stay at least `H₁`.
- Marks: down-sets, intervals, arbitrary finite sets, and none.
- Starts already of the kept kind: 2574 cases.

**With every premise held, no statement failed.**
- R1 to R3 and `noReturnAt_of_below`: 667 random cases, each checked at every step up to the horizon.
- `course_turned`, `noReturn_exists`, `turns_in_time_iff_before`, and `turns_in_time_iff` as a control: 1500 targeted pair cases, plus the 2574 kept starts.
- The witness `Three.noReturn` and Three's three marks (nine, eight, six) and no mark.
- `turned … T` in place of `T + 1` fails in course_turned, as it should (for example Three marked at six).

**Each premise dropped in turn**, the others held. "CE" means a counterexample was found.

| theorem | needed (CE found) | not needed (none found) |
|---|---|---|
| `turned_meets_of_above` (R1 if) | fall, top, meets, keeps, within | — |
| `above_of_turned_meets` (R1 only if) | nothing, short, needs | fall (0 CE in 102 cases: "nothing about `X` is used" is right) |
| `recoverable_of_above` (R2 if) | fall, top, meets, keeps, within | — |
| `above_of_recoverable` (R2 only if) | fall, nothing, short, needs | — |
| `noReturnAt_iff_first_below` | all eight | — |
| `noReturnAt_of_below` | fall, nothing, short, needs | top, meets, keeps, within (0 CE in 777, 952, 175 and 247 cases) |
| `course_turned` | outside, turns, kept, uses, before, markedT | need, giving: no premise on them, as the docstring says |
| `noReturn_exists` | nothing, needs, short₁, uses₁, below | short (H₂), meets, keeps, within, high (0 CE in 1500 cases each) |
| `turns_in_time_iff_before` | outside, turns, kept, uses, nothing, needs, short₁, uses₁, below, high, **short**, **meets** | keeps (0 candidates in 400k draws), within (none found; argued below) |

So the docstrings' splits of R1 and R2 by direction are exactly right.

**Why some premises are not needed:**
- `noReturnAt_of_below` and `noReturn_exists` need their H₂-side premises only to decide recoverability at each step, which a proof needs without Classical. That the course is not recoverable at step `x` needs only that `X x < need`: a course that agrees with `X` at step `x` does not meet the need there.
- `turns_in_time_iff_before`, without `within`: under `short`, `meets` and `keeps`, the levels up to `hi` whose orbit under H₂ meets the need are `[max(need, H₂+y₂), hi]`. That set is closed upward, and that is all R6 uses.

**Two counterexamples, for the docstrings.** They show that R6 rests on `short` and on `meets`, and that it is not interchangeable with `turns_in_time_iff`.
- **`short` dropped.** Giving `0,3,0,2,4,2,3,2` then 3; H₂ = 3, y₂ = 6, hi = 9, need 2; H₁ = 4, y₁ = 4; uses 4; start 7, marked at 7.
  - The course as it was is 7, 5, 4, 0. The pair's course is 7, 5, 2, 0: it ends.
  - The turn at step 2 holds at 4 under H₂, so the course is recoverable at 1, with N = 3 and `T + 1 = 1 < 3`.
  - So R6 is false here, while `turns_in_time_iff` is true (5 < 9).
  - R6 rests on `short` through `recoverable_iff_above`'s only-if direction at `T + 1`.
- **`meets` dropped.** Giving `0,1,3,3,0,2` then 0; H₂ = 3, y₂ = 1, hi = 13, need 4; start 9, marked at 9.
  - The course as it was is 9, 7, 5, 2, 0. The pair's course is 9, 7, 4: it ends.
  - The course is recoverable at 1 through the turn at 2. Both R6 and `turns_in_time_iff` fail.

## (b) The diff against DESIGN.md

**Existing statements and names are unchanged.**
- The only change to existing code: the induction `run` in `unending_iff_above` is factored out as the private `kept_run`, and that theorem's statement is unchanged.
- The section `## 7. Three courses from one start` is renumbered 8.
- The header's sentence "`Becoming.ReadOffInTime`'s laws on its own model are not joined; only its `first_of_decided` is used" is replaced, and the second-layer sentence is extended, as the design asks.
- Every other declaration is unchanged.

**Nothing the design asks for is missing.** R1 to R6 and `Three.noReturn` are there, under the design's names. The design's `Meets need` is named `MeetsNeed`, which avoids `RegimeMargin.Meets`.

**Added beyond the design.**
- The four direction theorems are public: `turned_meets_of_above`, `above_of_turned_meets`, `recoverable_of_above` and `above_of_recoverable`.
- `noReturnAt_of_below` is new, and is named in the header.
- The design said "Lemmas as needed, not advertised". These are small, correct and documented, so this is a choice, not a fault.

**No new theorem restates an existing one.**
- R6 has `turns_in_time_iff`'s left side. Its last conjunct is `∃ N, NoReturnAt … N ∧ T + 1 < N` in place of `H₂ + y₂ ≤ X (T + 1)`. The two are equivalent under the full premises through R2, but not without `short` (see the counterexample above).
- `noReturnAt_of_below` instantiates `noReturnAt_of_past`.

## (c) The sentences

The findings are in the structured return. In short:
- One sentence of the section docstring is garbled: "has `T + 1` before it" has nothing for "it" to refer to.
- R5 and its header line say "Under `turns_in_time_iff`'s premises", but R5 takes only some of them.
- `noReturnAt_of_below` and R5 do not say that their H₂-side premises only decide recoverability.
- R6's "proved through" names two theorems and leaves out `recoverable_iff_above`, where `short` enters. R6's conjuncts "the need met there and before" follow from `T + 1 < N` with no premise.
- `course_turned` has "the step … takes", a step as doer.
- `asItWas_falls` says "within `x` steps", but the statement is about step `x`.
- `Three.noReturn` uses "the turn at step 1 or 2", while `turned_and_ends` places the way's turn at the marked step.

The words rule is otherwise kept: no "law", "reader", "part" or "candidate" in the new text.

## (d) Sentences outside the file

These are in the structured return, with proposed wording. The files:
- `Becoming.lean`, the TurningInTime bullet.
- README.md and README.zh.md, their rows.
- `check_becoming.py`, its SCOPE paragraph.
- 02-MAP §11, under the anchors turning-in-time and r-turning-in-time.
- `turning-in-time.json`.
- The one page, `TURNING-IN-TIME.md`, and its zh copy.
