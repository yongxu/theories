AI-written (Opus reader), 13 November 2026. A reading of `tmp/r7/nr/DESIGN.md` against the Lean; nothing was built or run.

Paths are relative to `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/`.

## 1. Already proved? (question 1a)

Neither N1 nor N2 is stated anywhere. `Recoverable` and `NoReturnAt` are used only in `ReadOffInTime.lean`. But N1 is a composition of statements that are already there, and none of its content is new:

- `TurningInTime.unending_iff_above` (TurningInTime.lean:511) says that a turned course from level `z` keeps the need exactly where `H₂ + y₂ ≤ z`. Its internal `run` (lines 520–530) is the identification of the pair's course with `Law.orbit (RegimeMargin.step giving H₂) z`.
- Underneath it are `RegimeMargin.ends_iff_below` (RegimeMargin.lean:741) and `RegimeMargin.holds` (RegimeMargin.lean:730).
- The course as it was never rises: `Optimum.never_rises`, through `regime_levels`. `regime_levels` is **private** (TurningInTime.lean:383), so a leaf module cannot reuse it.

The proof of N1 picks `T := N` for one direction. For the other direction, a witness `turned T` with `T < N` agrees with `X` up to `N` and keeps, so `X N = turned T N ≥ X T ≥ H₂ + y₂` by `holds`. That is about 20–40 lines. N2 follows from N1 in a few lines: rewrite pointwise, use `Nat.lt_of_not_le`, and get existence from `noReturnAt_of_past` (ReadOffInTime.lean:632) with `Nat.decLe` and `Optimum.ends_within`.

`Optimum.reread_kept_iff` (Optimum.lean:2369) does not give N1. Its `keeps` premise asks that each step keep `m`. That fails for `m := need` when `need ≤ z < H₂ + y₂`, and with `m := H₂ + y₂` it proves a different "keeps". `Optimum.reread_deadline_iff` (Optimum.lean:2396) needs constant giving at or above the need, which the regime does not have. `ConditionInTime` has nothing on recoverability.

## 2. Is the instance honest? (1b)

`AgreeUpTo` (Counterfactual.lean:132) means `∀ s ≤ t, ∀ c, l s c = l' s c`. That is the agreement the design describes, and it includes step N.

The instance is true and not empty. But `feasible := {turned T | T : Nat}` is exactly the choice that turns `Recoverable` into "the regime started at `X N` does not end". So N1 is `ends_iff_below` read at `X N`, and its tag should be "near-definitional / composition".

The family is also not "the pair's own":

- **Turns at unmarked steps.** The pair is deterministic once `marked` is given. `turned T` for an unmarked `T` is a course the pair cannot take, so the family quantifies over the marks.
- **The turn at step 0.** A mark at step T changes the way only after step T. So the pair's turned courses are `turned (T+1)` (the design's own N3), and `turned 0` is never one of them, unless the start way is already Kept.

Counterexample from `Three` (giving `min z (12-z)`, uses 5 and 3, so `H₂ + y₂ = 6`): start at 6, so `X = 6, 2, 0`.

- With the design's family, `Recoverable` holds at 0, so `NoReturnAt` is 1.
- With the pair's family `{turned (T+1)}`, `Recoverable` already fails at 0 (`X 1 = 2 < 6`), so `NoReturnAt` is 0.

N4 is the same under both families, because it only asks at `T+1 ≥ 1`. N2 does depend on the choice.

## 3. FourReaders (question 4, 1c)

On the habitat, `FourReaders.Feasible` (ReadOffInTime.lean:967) is the whole turned family of `X := habitat .never` under `RegimeMargin.step giving 1`, not a subfamily:

- `stopped_is_regime` (ReadOffInTime.lean:1068) with `stopAt` (ReadOffInTime.lean:1060) gives `levels k = turned (stopAt k)` on `.habitat`.
- `turned T` is `levels .never` for every `T ≥ 3`, by `orbit_one`.

What keeps it from being an instance of the design's N1:

- `C = Place`, not `Unit`. `AgreeUpTo` also compares `news` and `news'`. Each `k` still agrees with `.never` up to `stopAt k` on those, so this costs one case split.
- Its course as it was is not of `RegimeMargin.step` form. The renewer gives on the level before the draws: `2 → 1` while `step g 2 2 = g 0`. Only "never rises, at most hi" is available, which N1 needs anyway.
- `keeps` is the need 1 and the point is 2 (`regime_point`), the same shape as `need ≤ H₂ + y₂`.

A general N1 would say: for any `X` that never rises with `X 0 ≤ hi`, a condition `c₀`, `feasible S l' := ∃ T ∈ S, AgreeUpTo l' X T ∧ ∀ k, l' (T+k) c₀ = Law.orbit (step giving H₂) (X T) k`, and `keeps` reading `c₀`, `Recoverable` at `N` is `H₂ + y₂ ≤ X N` whenever `S` contains every `T ≤ N`. The pair would enter only through N3.

Re-deriving `recoverable_iff_regime` (ReadOffInTime.lean:1097) from it costs roughly 30–50 lines, and its value is a check that N1's premises are not tailored to the pair. It is worth it only if the general form is what lands. Otherwise drop the "subfamily" sentence instead.

## 4. What N4 adds (question 3, 1d)

Nothing. `turns_in_time_iff`'s last clause is `H₂ + y₂ ≤ (…) (T + 1)).2` (TurningInTime.lean:575–576). N4 is that clause rewritten by N1 at `T+1`, followed by `NoReturnAt.recoverable_iff` (ReadOffInTime.lean:607). It is two `Iff.trans`. N3 is the only new fact about the pair: the pair's course is `turned (T+1)`. The proof of `turns_in_time_iff` has this only implicitly, through `agrees_until_marked` and `unending_iff_above`'s `run`. N4 does not use N3.

## 5. Where it should live (question 5, 1e)

TurningInTime already imports ReadOffInTime, so a new section adds no import either way. A section inside TurningInTime makes these sentences false:

- the header sentence "`Becoming.ReadOffInTime`'s laws on its own model are not joined; only its `first_of_decided` is used" (TurningInTime.lean:136);
- the layer sentence "through … `Becoming.ReadOffInTime` (for `first_of_decided`)" (TurningInTime.lean:137–138);
- the index entry (Becoming.lean:5004–5008).

All three would need editing. `WayOfUnits` imports TurningInTime and is unaffected either way.

My recommendation is a split:

- The general N1 and N2 (over an `X` that never rises, with no pair) go in ReadOffInTime's `NoReturn` area or just before `FourReaders`. ReadOffInTime already imports RegimeMargin.
- N3, and N4 if it is kept at all, go in a leaf that imports TurningInTime. This leaves TurningInTime's header true. `regime_levels` would then have to be made public or restated.

## 6. Sentences that say more than N1 to N4 prove (1f)

- "Its header calls `H₂ + y₂` 'the kept kind's point of no return' in words": false. TurningInTime.lean has no "no return" anywhere. It is RegimeMargin that names `H + y` so (its section titles at RegimeMargin.lean:702 and 726, and the docstring of `ends_iff_below`).
- "The feasible courses are the pair's own" (N3): N3 shows only that the pair's course is one member. The family includes turns the pair cannot take (section 2).
- "It is ReadOffInTime's own definition, and it comes out as a level": this holds only for the chosen family. Say the family.
- "`ReadableInTime` asks recoverability at … `T`; here it is asked one step later": that `T` is `FirstApart` on a web, and N4's `T` is the first marked step. Comparing them is a reading.
- "N1 (…any giving under the regime's premises)" and FourReaders "say the same of their models": not shown, and "a subfamily" is inaccurate (section 3).
- "The level at which the fall first makes a difference": a reading, not a statement.
