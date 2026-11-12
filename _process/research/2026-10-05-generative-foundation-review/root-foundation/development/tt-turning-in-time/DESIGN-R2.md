Kept as written; local paths in it point to the session's scratch folder.

*AI-written (Fable), 12 November 2026, 23:35 WIB. Round 2 of the TT design: the changes taken from the three readers' reports (`tmp/r7/tt/readers/v1-statements.md`, `v2-duplicates.md`, `v3-conformance.md`). `DESIGN.md` still holds for everything not changed here, its rules included.*

# TT design, round 2

The first round's Lean is in `tmp/r7/tt/lean/Becoming/`: every designed statement proved, no axioms, no warnings. The readers found no false statement. They found two claims that say more than is proved, both from the design, one duplicate proof, and a header that leaves out premises. The changes below remove the over-claims, derive what was re-proved, and lower what a reader must read.

## A. `GrammarPath.lean` (header text only; the six theorems stay as they are)

1. Replace the sentence that calls `«局定后则有常当且仅当同行可续»` "the composite of these two, by its own proof there" with one that says plainly: that law follows from the fourth and the sixth of these; this is said here and not checked in Lean, and its proof in `Becoming.GrammarLaws` is its own and does not use them.
2. The witness sentence (0 conditions 1 and 2, the class `«静»`): say it is not a Lean statement here, and name `«后不定则核可不同行»` (GrammarLaws) as the law with that relation.
3. Say once that 可决 is used on the pattern of 可续: it is decided whether it conditions anything.
4. Mark the added text: "(These six laws and this paragraph's last sentences are AI-written, 12 November 2026.)"

The file must still differ from the package's original only by additions. Build `Becoming.GrammarPath`.

## B. `GuardedStep.lean`

1. Import `Becoming.GrammarRegularity` as well (for `Law.unending_iff_steps`, line 146 there; no cycle).
2. Add the tie and derive from it:

```lean
/-- A step of the cut law that continues under `E` is a step of the whole law that continues under
`E` where it can go on. -/
theorem stepWhile_continues_iff {can : S → Prop} {next : S → S} {E : «际» S} {s t : S} :
    «续» (stepWhile can next) E s t ↔ «续» (step next) (fun x y => can x ∧ E x y) s t
```

   - `stepWhile_hasSucc_iff` from `step_hasSucc_iff` through the tie.
   - `stepWhile_unending_iff` from `Law.unending_iff_steps` at `fun x y => can x ∧ E x y` (with whatever small transfer of `«不穷»` along the pointwise equality of `«续»` is needed; if the package has a law that `«不穷»` depends only on `«续»`, use it). Delete the private `stepWhile_unending_rel_iff` and its own induction. If the transfer costs more lines than the induction it replaces, keep one private transfer lemma and say so in your report; do not keep a second proof of `unending_iff_steps`.
3. Delete `stepWhile_unending_value_iff` (nothing uses it).
4. `stepWhile_fixed`: keep the one-line proof; its docstring names `Law.step_fixed` (Recurrence 263) as the whole law's.
5. Header: say truthfully which laws come from the whole step's (a successor in a line and a line that never ends, through the tie; `n` steps, on the orbit) and which are proved pointwise (going alike, constancy, constancy up to the net's end through GrammarPath's iff). Remove the sentence that each law "reads as the total step's". Name `Map.StepWhere.relation` (GrammarMap 506) as a cut step of this shape already used in a witness, and `«尽则有终当且仅当排中»` (GrammarMap) as the reason `decided` is a premise of `stepWhile_toEnd_iff`.

Build `Becoming.GuardedStep`.

## C. `TurningInTime.lean`

1. **`asItWas`.** Add, after `pair`:

```lean
/-- The step as it was: the way after a step is `alone` of the way at every level. -/
def asItWas (alone : W → W) (left : W → Nat → Nat) : W × Nat → W × Nat :=
  pair (fun w _ => alone w) left
```

   and use it in every statement and docstring in place of the written-out `pair (fun w _ => alone w) left`. Proofs may unfold it where needed.
2. **Remove `regularity_in_level`**, and the private `pair_eq` if nothing else uses it. Its first half holds of every relation, because the joint class is the identity (the root's own caveat, `«火之见证不择类»`); what it adds is only that the way's class is not constant, which `constant_iff_needs_nothing` already says. Remove its clause from the header.
3. **`net_zero`**, in section 1:

```lean
/-- At a need of nothing the net is the pair's whole step. -/
theorem net_zero (renew : W → Nat → W) (left : W → Nat → Nat) :
    «谓» (net 0 renew left) (Law.step (pair renew left))
```

4. **The kind, generalized, and the ending while the net goes on.** Let the kind be `κ : W → K` for any type `K` in `kind_toEnd_of_unmarked` and `kind_not_toEnd_of_turn`, and derive `toEnd_of_unmarked` as the case `κ := id` (keep its name and statement). Add:

```lean
/-- **The line under the kind ends while the net goes on.** At a level that meets the need, where the
way after the step is of another kind, the configuration ends under the kind's class and still
conditions something. -/
theorem kind_ends_while_net_goes {K : Type v} {κ : W → K} {need : Nat} {renew : W → Nat → W}
    {left : W → Nat → Nat} {w : W} {x : Nat} (ge : need ≤ x) (turns : ¬ κ (renew w x) = κ w) :
    «亡» (net need renew left) (sameValue (fun s : W × Nat => κ s.1)) (w, x) ∧
      ∃ v, net need renew left (w, x) v
```

   In `kind_not_toEnd_of_turn`'s docstring do not call `x` marked (it is not a premise); say that it is, by `outside` and `keeps`.
5. **`core_tells`' docstring** states what is proved without a doer: the core of the way's class does not relate a configuration whose level meets the need to one of the same way whose level is below it.
6. **`regime_levels`** (private): use `RegimeMargin.left_below` (474) or `Adjusted.step_below` (485) for the arithmetic they give, if they fit after weakening the draw; if they do not fit, keep the proof and say in your report exactly why.
7. **Section 6, restated so that what it says is what is proved.** Title: `## 6. The lock's courses as courses of the pair, at a need of nothing`. Keep `locked_closed`, `locked_at_class`, `window_is_pair`, `window_alone_outside` and the four definitions. Delete `window_unending`. Add:

```lean
/-- The joined step that reads off the share, regrouped, is the window pair's step as it was. -/
theorem join_is_asItWas … : ∀ t,
    windowRegroup (Law.orbit (Pace.step (join fA fB) (joinRead hA) reads) c t) =
      Law.orbit (asItWas (windowAlone fA hA reads) (windowLeft fB)) (windowRegroup c) t

/-- The window course is the course that reads off the share up to the first step at which that
course's loss lies in `[N, K)`. -/
theorem window_agrees_until_marked … : ∀ n,
    (∀ j, j < n → ¬ (N ≤ (Law.orbit (Pace.step (join fA fB) (joinRead hA) reads) c j).1.2 ∧
        (Law.orbit (Pace.step (join fA fB) (joinRead hA) reads) c j).1.2 < K)) →
      Law.orbit (Pace.step (join fA fB) (windowRead hA hL N K) reads) c n =
        Law.orbit (Pace.step (join fA fB) (joinRead hA) reads) c n

/-- The identification on PoolFromCourse's own course function. -/
theorem window_paced …   -- `window_is_pair` composed with `ClosedCapture.orbit_paced`, stated on `paced`
```

   `window_agrees_until_marked` must be proved from `agrees_until_marked`, `window_is_pair`, `join_is_asItWas` and the injectivity of `windowRegroup` (a small lemma), not by a new induction. **Before adding it, search `PoolFromCourse.lean`, `ClosedCapture.lean` and `ReadInTime.lean` for a theorem with this conclusion** (the window course equal to the course read off the share before the loss reaches `N`; `window_through`, `locked_along`, `course_past`, `window_past_course` are the nearest). If one exists with the same or a stronger conclusion, do not add ours: say which, and state in the section docstring that it is `agrees_until_marked` read on the window. If none exists, add ours and say in its docstring which existing laws are its neighbours and how it differs.

   Section docstring and header bullet: the lock's joined step, regrouped, is the pair's step, and a total step is the net at a need of nothing (`net_zero`); the course that reads off the share is the window course as it was (`join_is_asItWas`), and the window course agrees with it until its loss is first marked; along the course as it was the locked region is closed, which at a locked member is the root's condition at its class. Say plainly: nothing here derives that a lock needs nothing of what it uses; its models have a total step, so in them no line ends where the net ends and sections 4 and 5 say nothing of them.
8. **Header, "What is given and what is not shown"**: add what the readers listed: `uses` (the kept kind has one standing use); the level's step is `RegimeMargin.step giving (use w)` with one giving for every way; `Meets`, `Keeps`, `within`, `high`; that `unending_iff_first_marked` needs the course as it was to come below the need (without it a course never marked and never ending is a line that never ends with no such step); a given way where `constant_iff_needs_nothing` needs one. Under "What this module adds", either name each law's premises or say once, at the top of the list, that each bullet names the main premises and the law's own docstring names all.
9. **Small wording**: `pair_adaptive`'s docstring: "with the level in the place `adaptive` gives to what it calls the rule". `Three.ends_as_it_was`: "no level that meets the need is marked (marks from ten down to nothing hold no level)". Add to `Three.turned_and_ends` a conjunct, by `kind_ends_while_net_goes` at `κ := id`, that at step 2 of that course (the configuration `(true, 6)`) the line under the kind ends while the net goes on. `locked_closed`'s docstring names the relation (`Law.step (Pace.step (join fA fB) (joinRead hA) reads)`), not "whatever `join` relates".

Build `Becoming.TurningInTime`.

## What each implementer returns

As in `DESIGN.md`. In addition: for B.2 and C.6 and C.7, exactly which existing law was used or why none fits; the final count of theorems and definitions per file.
