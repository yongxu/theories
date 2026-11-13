AI-written (Opus reader), 13 November 2026. The logic of N1 to N4, by simulation. Read only. No Lean was built or run.

Scripts, in `/private/tmp/claude-501/-Users-ren-theories/3c343411-bb06-4ddc-aa7a-5f9cd79133ad/scratchpad/nr/`:
`nr_core.py` (the model), `nr_n1n2.py`, `nr_dirs.py`, `nr_n3n4.py`, `nr_exhaustive.py`, `nr_apart.py`. Outputs are next to them: `n1n2.out`, `n3n4.out`, `exh.out`.

## Model

The model follows the definitions exactly:
- `step g H x = (x-H)+g(x-H)`, with truncated subtraction.
- `Short`, `Meets`, `Keeps` and `FromNothing` are written as in RegimeMargin.lean:255-271.
- `AgreeUpTo l l' N` means `∀ s ≤ N`, as in Counterfactual.lean:132.
- `Recoverable` and `NoReturnAt` are written as in ReadOffInTime.lean:591-598.
- `turned T j` is `X j` for `j ≤ T`, and `orbit (step g H₂) (X T) (j-T)` after that.
- `keeps l` is `∀ t, need ≤ l t`.

Every course is eventually periodic, so each `∀ n` and `∃ T` is decided exactly by cycle detection, not by a cut-off.

The test cases:
- Givings: the tents `min z (m-z)` for m = 10, 12, 14, 16, and random lists with `g 0 = 0`.
- Courses X: arbitrary non-rising lists, and as-it-was courses whose use varies along a cycle of `alone` but stays at least H₁.
- Marks: down-sets, intervals, arbitrary sets, and none. The exhaustive run uses all 2048 subsets of levels 0..10, on Three's pair (TurningInTime.lean:903-914) and on two tent-16 pairs.
- Needs from 1 to H₂+y₂. Starts from 0 up to min(H₁+y₁-1, hi). The "start above hi" drop uses starts up to hi+8.

## (1) N1 to N4 as stated

No failure was found:
- **N1 and N2:** 0 failures in 6000 random cases, each checked at every N up to the horizon + 2.
- **N3 and N4:** 0 failures in 6000 random cases plus 942,080 exhaustive cases (50,176 of them lines that never end). The "T + 1 < N" form of N4 also has 0 failures.

## (2) The off-by-one

- **T + 1 is right, and T is wrong.**
  - With `turned T` in place of `turned (T+1)`, N3 fails in 323,072 exhaustive cases.
  - With `Recoverable … T` in place of `T + 1`, N4 fails in 179,712 exhaustive cases.
  - The clean counterexample is the package's own `Three.turned_and_ends` (TurningInTime.lean:958). Start 9, mark at level 6, so X = 9, 8, 6, 2, 0 and the first marked step is T = 2. Then H₂+y₂ = 6 ≤ X 2, so the course is recoverable at T, but X 3 = 2 and the line ends.
- **The family `turned T` with X up to and including T is right.** At N = 0 the witness is `turned 0`, the kept kind from the start.
- **A kept start is consistent with both families.** There X is the H₂-run, so `turned T = X` for every T, and T and T+1 agree (28 cases).
- **N3's name overclaims.** N3 calls the feasible courses "the pair's own", but they are not. The pair's courses are `turned (T+1)`, with T ≥ 0. If feasible is narrowed to those, N1 fails at N = 0 in 280 of 6000 cases. Counterexample: giving `min z (14-z)`, H₂ = 1, y₂ = 1, need 1, X = 9, 0, 0, … Here X 0 = 9 ≥ 2, but no `turned (T+1)` keeps. N4 survives the narrowing, because it only asks at N = T+1 ≥ 1. N2 does not survive it: the point moves earlier wherever X 0 ≥ H₂+y₂ > X 1.
- **The design misreads the first step apart.** Under "What it would let someone see", the design says ReadableInTime asks recoverability "at the first step apart, T". But T is the first *marked* step. The pair's level and the level of the course as it was agree through T+1, and they first part at T+2 exactly, never earlier (104,448 cases).
  - On Three's pair, in 27,648 of 33,792 lines that never end, the course as it was is **not** recoverable at the first step apart. Example: start 8, mark 8, X = 8, 6, 2, 0, while the pair's course is 8, 6, 6, 6, …; they first part at step 2, where X = 2 < 6.
  - So turning in time here is not `ReadableInTime` with l = X and l' = the pair's course. T+1 is the step *before* the first step apart.

## (3) Dropping premises

Each premise was dropped in turn, with every other premise held. There were 6000 cases per drop; the table counts the cases with a failure:

| dropped | N1 | N2 | direction that breaks |
|---|---|---|---|
| none | 0 | 0 | |
| FromNothing | 1581 | 1581 | only-if |
| Short at H₂ | 419 | 419 | only-if |
| Meets | 1036 | 1036 | if |
| Keeps | 61 | 61 | if |
| 0 < need | 5990 | 5990 | only-if |
| need ≤ H₂+y₂ | 88 | 88 | if |
| never rising | 345 | 90 | both |
| X 0 ≤ hi | 2306 | 2306 | if |

**Never rising is needed for N1 itself**, not only for its use in N4:
- The if direction needs `need ≤ X j` for j < N.
- The only-if direction needs it in the branch where the witness T ≥ N.

**N1 holds for every non-rising `X : Nat → Nat` with X 0 ≤ hi, however X arises.** Half of the all-premises cases used arbitrary non-rising lists. N1 needs nothing about H₁, `alone` or marks, so state it over an arbitrary X.

**N3 does not need "the need met there and before".** Without it there were 0 failures in 1564 cases: the pair's orbit does not depend on the need.

## (4) The point of no return exists, under turns_in_time_iff's premises only

N1's own premises do not give it. A counterexample is X ≡ hi with hi ≥ H₂+y₂: X is never below H₂+y₂, so it is recoverable at every step and has no point of no return.

Under `short₁`, `uses₁` and `below`, there is a point, and the argument is constructive:
- `Optimum.ends_within` gives `X (X 0) < need ≤ H₂+y₂`, as in `turns_in_time_iff` (TurningInTime.lean:584-588).
- So N1 gives ¬Recoverable at `X 0`.
- Recoverability is decided through N1 by `Nat.decLe`.
- `noReturnAt_of_past` (ReadOffInTime.lean:633) then gives a point N ≤ X 0. In the simulation a point was always found.

## Counterexamples (minimal ones, from `n1n2.out`)

Each is listed as: giving; H₂, y₂, hi, need; X; the failure.

- **FromNothing dropped:** g = 2,5,3,6,0…; H₂ = 3, y₂ = 1, hi = 3, need 1; X = 1,1,1,1,0. The course is recoverable at 0, but X 0 = 1 < 4.
- **Short dropped:** g = `min z (10-z)`; H₂ = 3, y₂ = 7, hi = 10, need 2; X ≡ 9. The course is recoverable, but X = 9 < 10.
- **Meets dropped:** g = `min z (12-z)`; H₂ = 4, y₂ = 0, hi = 5, need 4; X = 5,4,0. X 0 = 5 ≥ 4, but the course is not recoverable at 0.
- **Keeps dropped:** g = 0,8,8,9,9,0…; H₂ = 5, y₂ = 1, hi = 9, need 5; X = 8,1,… The H₂-run from 8 goes 12, 7, 10, 5, 0.
- **need ≤ H₂+y₂ dropped:** g = `min z (14-z)`; H₂ = 1, y₂ = 1, hi = 2, need 3; X = 2,0. X 0 = 2 ≥ 2, but the course is not recoverable.
- **Never rising dropped:**
  - only-if breaks: g = `min z (10-z)`; H₂ = 1, y₂ = 1, need 1; X = 1,4,1,…. The course is recoverable at 0 through T = 1.
  - if breaks: X = 3,0,2,3,4,4,0 with H₂+y₂ = 4. At N = 4, X = 4 ≥ 4, but the course is not recoverable, because X 1 = 0 < need.
- **X 0 ≤ hi dropped:** g = `min z (10-z)`; H₂ = 6, y₂ = 7, hi = 11, need 5; X = 17,0.

## (5) A constructive proof route

**K `keeps_turned_iff`.** `keeps (turned T) ↔ H₂+y₂ ≤ X T`, with X non-rising and X 0 ≤ hi. Define `turned T j _ := if j ≤ T then X j else orbit (step g H₂) (X T) (j - T)`. The `if` is on `Nat.decLe`, so there is no Classical.
- Only-if: split on `Nat.lt_or_ge (X T) (H₂+y₂)`. If it is below, `RegimeMargin.ends_below short nothing` gives `run (X T)` = 0 at step `X T`. Then `turned T (T + X T) = 0 < need`, using `if_neg` and `Naturals.add_sub_cancel`.
- If: for j ≤ T, `X T ≤ X j`. This needs an antitone lemma from step-wise non-rising, by induction on the gap. The package states only `X t ≤ X 0` (`Optimum.level_le_start`, Optimum.lean:2262), so the antitone lemma is new and small. For j = T+k, `RegimeMargin.holds meets keeps low (X T ≤ X 0 ≤ hi)` (RegimeMargin.lean:730), with `need ≤ H₂+y₂`.

**N1.**
- If: the witness is T := N. `AgreeUpTo` holds by `if_pos`, and K gives keeps.
- Only-if: K gives `H₂+y₂ ≤ X T`. Split on `Nat.lt_or_ge T N`.
  - If N ≤ T, the antitone lemma gives the bound.
  - If T < N, write N = T+k with `le_dest`. Agreement at N gives `X N = run (X T) k ≥ X T`, by `holds`.

**N2.** Rewrite each conjunct with N1, using `Nat.not_le_of_gt` and `Nat.gt_of_not_le`. State the existence separately, as in (4).

**N3.** For all j, `(orbit pair s j).2 = turned (T+1) j`.
- For j ≤ T: `TurningInTime.agrees_until_marked` (TurningInTime.lean:296), since no level is marked before T.
- For j = T+1: one more `pair` step; the levels agree because `asItWas` uses the same `left`.
- For j = T+1+k: `Law.orbit_add pair s (T+1) k` (Recurrence.lean:244), then the kept-kind induction now inlined as `run` inside `unending_iff_above` (TurningInTime.lean:521-532). Factor that induction out as a lemma; `turns` gives a kept way at T+1, and `kept` and `uses` carry it on.
- What is decided here: `Nat.lt_or_ge j (T+2)` and `le_dest`.

**N4.** Rewrite `turns_in_time_iff`'s last clause with N1 at T+1. The premises come from the private `regime_levels`:
- never rising: from `levels.1`, `.2.1` and `.2.2`, through `Optimum.never_rises`;
- X ≤ hi: from `level_le_start`.

The "T+1 < N" form follows by `NoReturnAt.recoverable_iff`. Proved this way, N4 adds nothing that `turns_in_time_iff` lacks.

A route that does derive something goes through N3 and K: the line goes on exactly where its own course `turned (T+1)` keeps, and that holds exactly where the course as it was is recoverable at T+1. This route needs `unending_iff_first_marked`, the shift by `orbit_add`, and K.
