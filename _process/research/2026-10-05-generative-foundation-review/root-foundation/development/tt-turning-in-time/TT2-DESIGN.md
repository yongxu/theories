*AI-written (Fable), 13 November 2026. The design after two AI readers attacked its first form (`DESIGN-attacked.md`; reports `readers/n1-existing.md`, `readers/n2-logic.md`). Nothing here is proved until the Lean passes the core run.*

# The point of no return: a level and a step

## What the readers changed

- The name is `RegimeMargin`'s, not TurningInTime's: it calls the level `H + y` the point of no return (`ends_iff_below`, `holds`). `ReadOffInTime` defines a point of no return of a course as a step (`NoReturnAt`), with `feasible` and `keeps` given. One witness ties the two (`FourReaders.recoverable_iff_regime`). So the package has one name for a level and for a step, and no general theorem between them. That is the join.
- The join is a composition of what is proved, about 150 lines, and is said as that.
- It holds for any level course that never rises, however it arises; the pair enters only where its own course is shown to be a turned one.
- My sentence comparing it with `ReadableInTime` was wrong: the pair's course and the course as it was agree through step `T + 1` and first part at `T + 2`. Dropped.
- The family of feasible courses has to be said: a turn at any step, the start included. The pair's own courses are the turns at `T + 1` for a first marked step `T`.
- `T + 1`, not `T`: `Three.turned_and_ends` is the witness (marked at six, step 2; the level there is six, at the point; the line ends).

## Definitions (a new last section of `Becoming/TurningInTime.lean`, before `Three`)

For a level course `X : Nat → Nat`, a giving and a use `H`:

- `turned X giving H T : Nat → Nat`: `X t` for `t ≤ T`, and from there the level's course under `H` from `X T` (`Law.orbit (RegimeMargin.step giving H) (X T) (t - T)`).
- As courses in `ReadOffInTime`'s sense, over one condition: `Turned X giving H l'` says `l'` is `turned X giving H T` at every step, for some `T` (the feasible courses); `Meets need l'` says the need is met at every step (what is asked of a course).

## Theorems

**R1 `turned_meets_iff`.** For `X` never rising (`∀ t, X (t + 1) ≤ X t`) with `X 0 ≤ hi`, nothing given from nothing, `Short`, `Meets`, `Keeps` at `H` with `y`, `hi`, and `0 < need ≤ H + y`: the need is met at every step of `turned X giving H T` exactly where `H + y ≤ X T`.

**R2 `recoverable_iff_above`.** Same premises: `Recoverable (Turned X giving H) (Meets need) X N ↔ H + y ≤ X N`. (`RegimeMargin`'s point of no return, a level, read on `ReadOffInTime`'s definition.)

**R3 `noReturnAt_iff_first_below`.** Same premises: `NoReturnAt … X N ↔ X N < H + y ∧ ∀ n, n < N → H + y ≤ X n`: the point of no return of the course, a step, is the first step at which its level is below the point of no return of the regime it can turn to.

**R4 `course_turned`.** On the pair, with `AloneOutside`, `turns`, `kept`, `uses` and the level's step `RegimeMargin.step giving (use w)`: where `T` is the first step at which the level of the course as it was is marked, the pair's level course from `(w, x)` is `turned X giving H₂ (T + 1)`, `X` the level course as it was. (No premise on the need.)

**R5 `noReturn_exists`.** Under `turns_in_time_iff`'s premises on the course as it was (`Short` at `H₁`, uses of at least `H₁` along `alone`'s orbit, the start below `H₁ + y₁` and at most `hi`) and R1's at `H₂`: the course as it was has a point of no return `N`, with `N ≤ x`.

**R6 `turns_in_time_iff_before`.** Under `turns_in_time_iff`'s premises: the line never ends exactly where there is a first marked step `T` of the course as it was, the need met there and before, with `T + 1 < N` for `N` the point of no return of the course as it was; proved through R4 and R1, so that the pair's own course is the feasible course that meets the need.

**Witness `Three.noReturn`.** For `Three` from nine as it was (9, 8, 6, 2, 0), with the kept kind's use three and `y = 3`: the point of no return is step 3. First marked at step 0 or 1 the turn is before it (`Three.goes_on`); at step 2, `T + 1 = 3` is the point and the line ends (`Three.turned_and_ends`).

Lemmas as needed, not advertised: a never-rising course is not higher at a later step; the course of a way of the kept kind follows the level's course under `H₂` (now inlined in `unending_iff_above`: factor it out without changing that theorem's statement).

## What it lets someone see

- One name, one thing: the point of no return as a level (`RegimeMargin`) and as a step of a course (`ReadOffInTime`) are joined for every course that never rises, under turns to one standing use.
- On the pair, a turn holds exactly where the first marked step comes at least two steps before the point of no return of the course as it was: the marked step still takes as it was, and the level it leaves must be at or above the level from which the kept kind holds.

## What it does not show

- The feasible courses are turns to one standing use `H` at any step. Other continuations are not considered, and the marks stay given.
- `FourReaders.recoverable_iff_regime` is not derived from R2: its courses are over three places, and its course as it was is not of `RegimeMargin.step`'s form. That the two say the same of their models is a reading.
- `ReadOffInTime`'s selection side (`FirstApart`, `ReadableInTime`) is not instantiated. Nothing about a trained system.

## Texts that change with it

TurningInTime's header: the sentence "`Becoming.ReadOffInTime`'s laws on its own model are not joined; only its `first_of_decided` is used" and the sentence on the second layer; `Becoming.lean`'s bullet for TurningInTime. The implementer edits the header; the coordinator the rest.

## After the implementation (AI-written, 13 November 2026)

- The four direction theorems `turned_meets_of_above`, `above_of_turned_meets`, `recoverable_of_above` and `above_of_recoverable`, and `noReturnAt_of_below`, are public on purpose: each direction names the premises it uses, and that split is informative (reader report `readers/v1-section.md`). The lemmas that only serve proofs (`recoverable_decided`, `met_of_recoverable`, `asItWas_falls`, `kept_run` and the `turned` lemmas) are private.
- "The marked step still takes as it was" (in "What it lets someone see") is said in the Lean as: at the marked step the way is still the way as it was, so the level one step later is that of the course as it was.
