Kept as written; local paths in it point to the session's scratch folder.

AI-written reading, 12 November 2026. Reader v1, lens: statement against claim. Read only; nothing built or run.

Files read: `tmp/r7/tt/lean/Becoming/GrammarPath.lean` (diffed against the package copy), `GuardedStep.lean`, `TurningInTime.lean`, `tmp/r7/tt/DESIGN.md`; in the package, the definitions and laws the new text cites (Grammar `«不穷» «核» «根» «因于核» «足以定核»`, GrammarPath `«至终有常» «本类至终有常» «亡而网续…» «出类不随则本类不至终有常»`, GrammarLaws `«同行» «同行之逐点» «有常则可续» «局定后则有常当且仅当同行可续» «同行之迭» «迭» «闭»`, OwnClass `«类闭则本类常闭»`, GrammarCourse `step sameValue line_on_orbit unending_iff`, RegimeMargin `step FromNothing Short Meets Keeps ends_below holds ends_iff_below short_of_below meets_of_below keeps_of_below Adjusted.draw_pos`, Optimum `never_rises level_le_start ends_within`, ReadOffInTime `first_of_decided`, Pace `turn step paced`, RuleCapture `Raises ReadsShare Locked turn_locked`, ClosedCapture `join joinRead turn_join`, GrammarRegularity `lockedAlike orbit_paced adaptive_constant_iff`, PoolFromCourse `windowRead window_unread`).

## Verdict

No statement is wrong and no docstring claims the reverse direction of what is proved. GrammarPath has additions only (one header sentence split, the old text kept). Every number in the three witness courses is right. `turns_in_time_iff`'s right side is a condition on the course as it was, and the marks do work in it. What remains: section 6 claims a join between the lock and the pair that no theorem makes; `regularity_in_level` says no more than "the way's class is not constant", in words that sound like more; and "What is given and what is not shown" leaves out several premises that carry weight.

## High

None.

## Medium

**M1. Section 6 does not tie the lock to the pair or its net by proof** (TurningInTime.lean 79-88, 103-105, 583-705).
- `locked_closed` and `locked_at_class` are stated on `Law.step (Pace.step (join fA fB) (joinRead hA) reads)`, which reads the share by `joinRead`.
- `window_is_pair` and `window_alone_outside` are stated on `Pace.step (join fA fB) (windowRead hA hL N K) reads`.
- No theorem identifies the `joinRead` course with a pair course, and no `Locked` fact is stated on the window course or on `net`. That identification would be the window at `K ≤ N`, by `window_unread`, and it is not stated.

So the section title "The lock as the case that needs nothing" and the sentence "The lock's courses are identified with the pair's only by regrouping, at a need of nothing" (line 103) say more than is proved. Only the window course is identified with a pair course. The lock results stand next to it without being joined to it.

On top of this, `window_unending` (698-703) holds for every `renew` and `left` at need 0: its proof never looks at the window's functions. It says nothing about the window. The header lists it as one of the window's facts (line 88) without saying so. The implementer's doubt says the same, and lines 104-105 say it in part.

**M2. `regularity_in_level` is exactly "the way's class is not constant"** (TurningInTime.lean 230-242; header 53-55).
- `«因于核» R E₁ E₂` is `«则» («合» E₁ E₂) («核» R E₁) ∧ ¬ «有常» R E₁`.
- With `E₁ = sameValue Prod.fst` and `E₂ = sameValue Prod.snd`, the meet is the identity on `W × Nat` (`pair_eq`). The core is reflexive (`«核为类»`), so the first conjunct holds for every relation `R`, whatever the net.
- All the content is therefore the second conjunct: `¬ «有常»` of the way's class. That holds where `0 < need` and some `w₀` is given (`constant_iff_needs_nothing`).
- Any second class whose meet with the way's class is the identity would "hold the regularity" in the same sense, the identity class itself included.

The docstring says the joint class is the identity, but it still headlines "the way's regularity lies in the level", which reads as a fact about the level that the statement does not contain. It should say that, the joint class being the identity, the law reduces to the non-constancy of the way's class.

**M3. "What is given and what is not shown" (96-108) leaves out premises that carry weight.** It names `AloneOutside`, the marks, `kept`, `turns`, the decidability of the marks, the course as it was below `H₁ + y₁` with uses of at least `H₁`, and the lock limits. Missing:
- `uses : ∀ w, Kept w → use w = H₂`. Every way of the kept kind has one standing use. Together with `kept` and `turns`, this makes the fate after the turn a single threshold, so the exactness of `turns_in_time_iff` past `T` rests on it.
- In `ends_with_net_regime`, `unending_iff_above` and `turns_in_time_iff`, the level's step is fixed as `RegimeMargin.step giving (use w)`, with one `giving` for both kinds. The level reads the way only through `use`. This is a choice of the model, like the one the section names for the marks.
- `Meets giving H₂ y₂ hi`, `Keeps giving H₂ hi`, `within : need ≤ H₂ + y₂`, and the start at most `hi`.
- `asItWasEnds`, the premise of `unending_iff_first_marked`: the course as it was comes below the need. Without it the iff fails, since a course that never drops and is never marked does not end.
- A given way `w₀` (a nonempty `W`) for `constant_iff_needs_nothing` and `regularity_in_level`.

## Low

**L1. Header bullets drop premises that the theorems' own docstrings name** (TurningInTime.lean header):
- line 32: `RegimeMargin.ends_below` is described without `FromNothing`;
- lines 47-48: "constant exactly where, besides, every level meets the need" needs `W` nonempty. `constant_iff`'s own docstring is exact; the header paraphrase is not;
- lines 54-55: `regularity_in_level` is given without the way `w₀`;
- lines 64-66: `ends_with_net_regime` is given without `Short giving H y` and `FromNothing`;
- lines 70-72: `unending_iff_above` is given without `nothing`, `short`, `meets`, `keeps`, `within`, `needs` and `high`;
- lines 72-74: "at the first marked level, the need met there" leaves out that the need is met at every step before `T`. That follows from the level never rising (`Optimum.never_rises` under `regime_levels`), but the bullet does not say so.

**L2. GrammarPath header** (GrammarPath.lean 46-51):
- "`«局定后则有常当且仅当同行可续»` … is the composite of these two, by its own proof there" is not checked in Lean. The GrammarLaws proof composes `«有常局定后则同行»`, `«有常则可续»` and `«同行可续则有常»`, not the new laws. The composite does hold, because "onward" implies "decided", but it is argued only. "By its own proof there" can be read as saying that its proof is that composite. Say it is a reading.
- The witness that the fixed successor cannot be dropped (`R 0 1`, `R 0 2`, `«静»`) is correct by hand, since `«静»;R ⊆ R;«静»` holds and `«同行»` would give `1 = 2`. But it has no Lean witness, and the text does not say it is argued only.

**L3. GuardedStep header lines 36-38** say that where `can` always holds, "each law reads as the total step's (for `Law.stepWhile_unending_value_iff`, that is `Law.unending_iff`)". No theorem derives any total-step law from a guarded one at `can = fun _ => True`; `stepWhile_always` gives only the equality of relations. Also, "every law here is the total step's restricted" is a reading: the guarded laws are proved directly, and only the unending laws go through `line_on_orbit`.

**L4. `Three.ends_as_it_was` docstring** (774-775). "No level is marked" is true of `renew 10 0`, but the first conjunct proves it only for levels at least 1. "Marks from ten to nothing" names the empty interval `[10, 0]` obscurely.

**L5. `pair_adaptive` docstring** (126) uses "rule" outside §6, against the design's word rule. It is `Mechanism.adaptive`'s word, and the implementer flagged it. The header says "the second place".

**L6. `locked_closed` docstring** (603-607) says "whatever `ClosedCapture.join fA fB` relates". `join` is a function; the relation is `Law.step (Pace.step (join fA fB) (joinRead hA) reads)`.

**L7. `window_is_pair`** (674-678). The identification with PoolFromCourse's `paced` course goes by citing `ClosedCapture.orbit_paced`; it is not composed in Lean. Section 6's docstring (line 591) says that outside `[N, K)` the way after a step is "the share's own". But `windowAlone` also carries `reads` and the step count, so it is the schedule's step reading the share, not the share's law on `A` alone. The implementer flagged this too.

**L8. `kind_not_toEnd_of_turn`** (567-571) says "at a marked level `x`", but `marked x` is not a premise. It follows from `outside`, `keeps` and `turns`, so the docstring is not false. It could say that it follows.

## The three header docstrings, bullet by bullet

**GuardedStep** (14-34). Each named statement matches its bullet: `stepWhile_step`, `_always`, `_fixed`, `_steps_iff`, `_none_iff`, `_hasSucc_iff`, `_unending_iff`, `_unending_value_iff`, `_goesAlike_iff`, `_toEnd_iff` (the decided premise is named), and `_constant_iff`. "So constancy asks that the configurations of one value agree on whether they can go on" is right: applying the right side both ways gives `can s ↔ can s'`. Only L3 remains.

**TurningInTime** (12-108).
- What the root has: correct.
- What the level's laws have: correct except L1, line 32.
- What this module adds: `pair`, `net`, `AloneOutside`, `toEnd_iff`, `constant_iff`, `constant_iff_needs_nothing`, `constant_adaptive`, `toEnd_of_unmarked`, `unmarked_interval_iff` (both directions checked by hand), `core_tells`, `agrees_until_marked`, `asItWas_way`, `alike_along`, `ends_with_net` ("within `s.2` steps" is `ends_within` at `t := s.2`), `unending_iff_first_marked`, `unending_iff_above`, `turns_in_time_iff`, `kind_toEnd_of_unmarked` and `kind_not_toEnd_of_turn` all match their statements, apart from L1, M2 and M1.
- What is given: M3.

**GrammarPath** (42-51 added). The six names and directions match. The new docstrings use "is" only for one direction (`«至终有常局定后则同行»`, `«同行可决则至终有常»`, `«至终有常可续则有常»`) and claim the two iffs as iffs. Only L2 remains.

## Vacuity

- The premises of `turns_in_time_iff` hold together: `Three` is a model of all of them (`H₁ = 5`, `y₁ = 5`, `H₂ = 3`, `y₂ = 3`, `hi = 12`, `need = 1`).
- `asItWasEnds` in `unending_iff_first_marked` is needed; without it the iff fails.
- The premises of `kind_not_toEnd_of_turn` can be met (`renew 6 6`, `w = true`, `x = 6`, `x₀ = 9`, `κ = id`, `alone = id`), but no Lean witness is stated.
- The iffs `toEnd_iff`, `constant_iff`, `unending_iff_above` and `turns_in_time_iff` are not exact by stipulation. Past the turn, though, `turns_in_time_iff`'s exactness rests on the absorbing kept kind with one standing use (`kept`, `turns`, `uses`; see M3).
- Vacuous or near-vacuous: `window_unending` (M1) and the first conjunct of `regularity_in_level` (M2).

## turns_in_time_iff's right side

The right side (508-518) refers only to:
- the orbit of `pair (fun w _ => alone w) (fun w x => RegimeMargin.step giving (use w) x)` from `(w, x)`: the course as it was, with its start and uses;
- `marked`, `need`, `H₂` and `y₂`.

`renew` does not appear. The marks do work: `T` is the first step at which the need is met and the level is marked, and before it no level is marked. Different marks give different `T`, and so different verdicts, as `Three.goes_on` against `Three.turned_and_ends` shows. The level at `T + 1` of the course as it was is `left` of the way and level at `T`. Since the course agrees with the course as it was up to `T` (`agrees_until_marked`), this is the level after the turning step: the `.2` of `pair renew left` at that configuration is `left` of the same pair. So the docstring's sentence is right.

## The three courses, worked by hand

Definitions:
- `giving z = min z (12 - z)`;
- `RegimeMargin.step g H x = (x - H) + g (x - H)`;
- `use true = 5`, `use false = 3`.

The course as it was (way `true`, use 5):
- 9: 4 + g 4 = 4 + 4 = **8**;
- 8: 3 + 3 = **6**;
- 6: 1 + 1 = **2**;
- 2: 0 + g 0 = **0**.

So 9, 8, 6, 2, 0, as stated.

Regime facts:
- `Short giving 5 5`: g 0..4 = 0..4, each below 5. Holds.
- `Short giving 3 3`: g 0..2 = 0, 1, 2, each below 3. Holds, so `H₂ + y₂ = 6`.
- `Meets giving 3 3 12`: for 3 ≤ z ≤ 9, g z = 3, 4, 5, 6, 5, 4, 3, each at least 3. Holds.
- `Keeps giving 3 12`: z = x - 3 ≤ 9. z ≤ 6 gives 2z ≤ 12; z > 6 gives 12. Holds.
- The start: 9 < 10, 9 ≤ 12, 0 < 1, 1 ≤ 6.

`goes_on`:
- Marks `[9, 9]`, `T = 0`: 1 ≤ 9 and 9 is marked; the level at step 1 as it was is 8 ≥ 6. The actual line goes `(true, 9)` → `(false, 8)` → 10 → 12 → 12 …, so it never ends. "Eight is left" is right.
- Marks `[8, 8]`, `T = 1`: 9 is not marked, 8 is; the level at step 2 as it was is 6 ≥ 6. The actual line goes `(true, 9)` → `(true, 8)` → `(false, 6)` → 6 …. "Six is left" is right.

`turned_and_ends` (marks `[6, 6]`):
- `(true, 9)` → `(true, 8)` → `(true, 6)` → `(false, 2)`, since `renew 6 6 true 6 = false` and `step g 5 6 = 2`. Orbit at 3 = `(false, 2)`: right.
- Then `step g 3 2 = 0`, giving `(false, 0)` at step 4. Levels 9, 8, 6, 2 are all at least 1, so the 4-step line is valid. 1 ≤ 0 fails, so `(false, 0)` conditions nothing and the line is not unending at step 4. Right.

`ends_as_it_was` (marks `[10, 0]`, empty):
- `(true, 9)` → `(true, 8)` → `(true, 6)` → `(true, 2)` → `(true, 0)`. 4 steps, ends at `(true, 0)`. Right.

## Not checked

- That the files compile, that the axiom reports are empty, and that there are no warnings. I took the implementers' reports for these and ran nothing.
- Whether `if_neg`, `if_pos`, `decide` and the `Decidable` instances used bring in `propext`.
- Whether the new names collide in the package.
- The maps in `tmp/r7/tt/map/` in full. I did not use them to judge whether an existing law was restated.
- The held first attempt and its reader's report.
- Proof terms line by line beyond what a statement's meaning needed. I took the type checker's word that each proof proves its statement.
- Whether `ClosedCapture.orbit_paced` and the PoolFromCourse course match as L7 assumes, beyond reading their statements.
