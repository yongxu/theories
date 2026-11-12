Kept as written; local paths in it point to the session's scratch folder.

*AI-written (Fable), 12 November 2026, 23:00 WIB. The design for board item TT, from the maps in `tmp/r7/tt/map/` and my own reading of the statements it rests on. Implementers work from this file. Where a statement here cannot be proved as written, change it as little as possible, say exactly what changed and why, and do not weaken a claim silently.*

# TT design: the centre from what the package already has

## What the maps showed

The package already holds nearly every piece. Nobody had read them together.

- **The root has the gap and both ways a line ends.** `«至终有常»` (GrammarPath 222): alike leads to alike unless the other conditions nothing. `«亡而网续则不至终有常»`, `«亡而网续则本类不至终有常»` (253, 264): a line that ends while its last stage still conditions something breaks it. `«同行»` with `«局定后则有常当且仅当同行可续»` (GrammarLaws 2568, 2612) names the same gap from the other side. **No theorem relates `«同行»` and `«至终有常»`.**
- **The lock is already read on the grammar.** `ClosedCapture.lock_line` (GrammarRegularity 324): from a locked start the line under `lockedAlike` never ends while every step alters the loss. `adaptive_constant_iff` (221): the state's class is constant exactly where the rule makes no difference to it.
- **Every lock course is endless.** `Law.step` is total, so on it going alike and constancy coincide and the gap cannot open. The loss only rises (`Accrues`). Nothing in the lock modules needs what it uses.
- **The level's laws exist, with a changing draw.** `Optimum.ends_within` (2289), `kept_at_need`, `reread_kept_iff` (2369: a run split at a step `T`, the need kept exactly where it is met at `T`), `reread_deadline_iff` (the deadline in closed form). `RegimeMargin.holds`, `ends_iff_below` at a standing draw. All rest on `Amounts.falls_by_stretch`. No respect, no way of going on, appears in them: `T` is a parameter.
- **No law has a next only where a condition holds.** Guards appear only inside witnesses.

So three things are missing, and only three:

1. the tie between the root's two names for the gap;
2. a law's step cut where it cannot go on, so that a line on a law can end where the net ends;
3. one system that has both a way of going on kept alike and a level that runs down, where the step `T` of the level's laws is read off the level by two marks.

Everything else is used as it stands.

## The moves, and why each is on the frontier

| | Move | Joins | Adds |
|---|---|---|---|
| A | six short theorems in `GrammarPath.lean` | `«同行»` and `«至终有常»`; the old iff in GrammarLaws becomes their composite | no new term |
| B | a small module `Becoming.GuardedStep`: `Law.stepWhile` and its laws, each derived from the total step's | lets every determined law have a line that ends where the net ends | one definition |
| C | the module `Becoming.TurningInTime` rewritten: `Mechanism.adaptive` with a level, cut by a need | the lock's kept class, the level's laws and the root's two endings, on one relation | two definitions (`pair`, `AloneOutside`), no structure |
| C §6 | the lock as its case: PoolFromCourse's window course is a course of the pair by regrouping; the `Locked` region closed under the net gives the root's condition at a locked member | the lock modules to the centre by proof | none |

Not done, and why: re-deriving `ClosedCapture.join_course`, `course_past` and `window_past_course` from C's `agrees_until_marked` would be the next reorganization below. It saves one induction and costs a rebuild of 23 modules and their records. It waits until `ClosedCapture` is next opened. Nothing in C re-proves those laws.

Nothing is renamed. `RegimeMargin`, `Optimum`, `ClosedCapture`, `GrammarLaws` are not edited.

## Rules for every implementer

- **No axioms.** Every declaration must have an empty axiom report. Do not use `omega`, `simp`, `decide` on open terms, `Classical`, `funext`, `propext`, `by_cases` on an undecided proposition. Use `Nat.lt_or_ge`, explicit lemmas, `rw` with equalities, `cases`, `match`, `induction`. These core lemmas carry `propext` and are forbidden: `Nat.sub_eq_zero_of_le`, `Nat.sub_add_cancel`, `Nat.le_of_add_le_add_right`, `Nat.add_sub_of_le`. Use instead, from namespace `Becoming`: `sub_eq_zero_of_le`, `add_sub_of_le`, `le_of_add_le_add_right k`, `le_dest`; and `Naturals.sub_add_cancel`, `Naturals.add_sub_cancel`, `Naturals.sub_sub`. The scratch build reports any axiom; fix every one.
- **No warnings.** An unused variable is a warning and fails the step.
- **Build only your own module, in your own tree:** from `/Users/ren/theories/experiments/integrated-correction/general-framework/generative-basis/lean/becoming`, run `python3 -B scratch_build.py <your tree> <Module> [<Module> ...]`. It takes seconds when the closure is cached. Run nothing else: no `check_becoming.py` (not even `--help`), no gate, no render, no tests. Do not edit anything under `/Users/ren/theories` outside your tree and your report file.
- **Do not restate.** If a statement you need exists, use it by name. The maps list what exists: `tmp/r7/tt/map/*.md`. The held first attempt, `tmp/r7/the-loop/lean/Becoming/TurningInTime.lean`, has proof text you may reuse where this design keeps a statement; its reader's report `tmp/r7/the-loop/readers/lean-reader-1.md` says what was wrong with it.
- **Docstrings say exactly what is proved, every premise named.** No "exactly" for one direction. No borrowed field words (rule, share, stock, reader, lock, loss, window, oversight) outside §6, where the lock's own names are cited. Do not use "renew" for anything but the function named `renew` here (the root uses the word for `«复生»`); say "the way after a step". Do not call anything a "carrier" (the grammar's word for its type). Say "the level" for the number and "condition" only for the relation.
- **Names.** Check each new name against the package (`grep -rn "theorem <name>\b\|def <name>\b" Becoming/`). Known collisions to avoid: `Course`, `Lasts`, `not_constant`, `in_time`, `too_late`, `kept_iff`, `holds`, `falls`, `step`.

## A. `GrammarPath.lean`: the tie

Copy `Becoming/GrammarPath.lean` into the tree and add, directly after `«有常则至终有常»` (about line 228), in the same section and style:

```lean
/-- **Constancy up to the net's end, its successor fixed where `E` leads, is going alike
(至终有常局定后则同行).** -/
theorem «至终有常局定后则同行» {R E : «际» α} (constant : «至终有常» R E)
    (fixed : ∀ x x', E x x' → ∀ v w, R x' v → R x' w → v = w) : «同行» R E

/-- **Going alike, where it is decided of whatever `E` leads to from an occurrence that conditions
something whether it conditions anything, is constancy up to the net's end (同行可决则至终有常).** -/
theorem «同行可决则至终有常» {R E : «际» α} (alike : «同行» R E)
    (decided : ∀ u u' v, E u u' → R u v → (∃ v', R u' v') ∨ ∀ w, ¬ R u' w) : «至终有常» R E

/-- Constancy up to the net's end decides it (至终有常则可决). -/
theorem «至终有常则可决» {R E : «际» α} (constant : «至终有常» R E) :
    ∀ u u' v, E u u' → R u v → (∃ v', R u' v') ∨ ∀ w, ¬ R u' w

/-- **With the successor fixed where `E` leads, constancy up to the net's end is going alike with that
decided (局定后则至终有常当且仅当同行可决).** -/
theorem «局定后则至终有常当且仅当同行可决» {R E : «际» α}
    (fixed : ∀ x x', E x x' → ∀ v w, R x' v → R x' w → v = w) :
    «至终有常» R E ↔ «同行» R E ∧ ∀ u u' v, E u u' → R u v → (∃ v', R u' v') ∨ ∀ w, ¬ R u' w

/-- **Constancy up to the net's end, with a next where `E` leads from one that has one, is constancy
(至终有常可续则有常).** -/
theorem «至终有常可续则有常» {R E : «际» α} (constant : «至终有常» R E)
    (onward : ∀ u u' v, E u u' → R u v → ∃ v', R u' v') : «有常» R E

/-- **Constancy is constancy up to the net's end with a next where `E` leads (有常当且仅当至终有常可续).**
With no premise. -/
theorem «有常当且仅当至终有常可续» {R E : «际» α} :
    «有常» R E ↔ «至终有常» R E ∧ ∀ u u' v, E u u' → R u v → ∃ v', R u' v'
```

Add to the header's paragraph "Up to the net's end" two sentences naming these six and saying that `«局定后则有常当且仅当同行可续»` (GrammarLaws) is the composite of the fourth and the sixth, by its own proof there; do not claim it is re-proved. Also add one witness sentence if the map `followup-tie-tongxing.md` gives one (the fixed successor cannot be dropped: `R 0 1`, `R 0 2` with `«静»`); a Lean witness is optional.

Build `Becoming.GrammarPath` and then its six dependents (`Becoming.GrammarCases`, `Becoming.OwnClass`, `Becoming.RoutesToC`, `Becoming.PremiseWitnesses`, `Becoming.FromTheDynamics`, `Becoming.PremisesTogether`) once, to see that nothing breaks.

## B. `Becoming/GuardedStep.lean`: a law's step while it can go on

New file. Imports `Becoming.GrammarCourse` and `Becoming.GrammarPath`. Namespace `Becoming`, then `namespace Law`. Header docstring: what it is for (the total step `Law.step` never lets the net end, so on it going alike and constancy coincide; cut where it cannot go on, a line can end where the net ends), each law, and that every law here is the total step's restricted, with `stepWhile_always` the tie.

```lean
/-- A determined law's step while it can go on, read as 缘: `s` is a condition of `t` where `s` can go
on and `t` is the configuration after it. Where it cannot go on, `s` is a condition of nothing. -/
def stepWhile (can : S → Prop) (next : S → S) : «际» S := fun s t => can s ∧ t = next s

theorem stepWhile_step {can : S → Prop} {next : S → S} : «则» (stepWhile can next) (step next)
theorem stepWhile_always (next : S → S) : «谓» (stepWhile (fun _ => True) next) (step next)
theorem stepWhile_fixed (can : S → Prop) (next : S → S) : «定后» (stepWhile can next)

/-- `n` steps -/
theorem stepWhile_steps_iff {can : S → Prop} {next : S → S} : ∀ (n : Nat) {s t : S},
    «迭» (stepWhile can next) n s t ↔ (∀ j, j < n → can (orbit next s j)) ∧ t = orbit next s n

/-- conditions nothing exactly where it cannot go on -/
theorem stepWhile_none_iff {can : S → Prop} {next : S → S} {t : S} :
    (∀ v, ¬ stepWhile can next t v) ↔ ¬ can t

/-- a successor in a line under `E` -/
theorem stepWhile_hasSucc_iff {can : S → Prop} {next : S → S} {E : «际» S} {s : S} :
    «有后» (stepWhile can next) E s ↔ can s ∧ E s (next s)

/-- the line under the one never ends exactly where it can go on at every step -/
theorem stepWhile_unending_iff {can : S → Prop} {next : S → S} {s : S} :
    «不穷» (stepWhile can next) «一» s ↔ ∀ n, can (orbit next s n)

/-- under a value class (the guarded form of `unending_iff`) -/
theorem stepWhile_unending_value_iff {can : S → Prop} {next : S → S} {o : S → R} {s : S} :
    «不穷» (stepWhile can next) (sameValue o) s ↔ ∀ n, can (orbit next s n) ∧ o (orbit next s n) = o s

/-- going alike -/
theorem stepWhile_goesAlike_iff {K : Type w} {can : S → Prop} {next : S → S} {π : S → K} :
    «同行» (stepWhile can next) (sameValue π) ↔
      ∀ s s', π s = π s' → can s → can s' → π (next s) = π (next s')

/-- constancy up to the net's end is going alike, for any relation, where `can` is decided:
`«局定后则至终有常当且仅当同行可决»` with the successor fixed and the next decided by `can` -/
theorem stepWhile_toEnd_iff {can : S → Prop} {next : S → S} {E : «际» S}
    (decided : ∀ s, can s ∨ ¬ can s) :
    «至终有常» (stepWhile can next) E ↔ «同行» (stepWhile can next) E

/-- constancy -/
theorem stepWhile_constant_iff {K : Type w} {can : S → Prop} {next : S → S} {π : S → K} :
    «有常» (stepWhile can next) (sameValue π) ↔
      ∀ s s', π s = π s' → can s → can s' ∧ π (next s) = π (next s')
```

`stepWhile_toEnd_iff` must be proved from A's `«局定后则至终有常当且仅当同行可决»` (so B's tree needs A's `GrammarPath.lean`; until A is done, copy the six statements with their proofs into your tree's `GrammarPath.lean` yourself, exactly as in section A). `stepWhile_fixed` from `step_fixed` by inclusion if that is shorter, else directly. `stepWhile_unending_value_iff` follows the proof pattern of `reached_while_same` and `unending_iff` in GrammarCourse. If a law here is an instance of a GrammarLaws law (`«不穷则迭»`, `GrammarLaws.trace_on`, `«亡者不在长迭»`), prove it from that law.

## C. `Becoming/TurningInTime.lean`: one way of going on, one level, cut by a need

New file replacing the held attempt. Imports: `Becoming.GuardedStep`, `Becoming.GrammarRegularity`, `Becoming.OwnClass`, `Becoming.PoolFromCourse`, `Becoming.ReadOffInTime`. Namespace `Becoming.TurningInTime`. `variable {W : Type u}`.

### C1. The pair and its net

```lean
/-- One step: the way becomes `renew w x` and the level `left w x`. -/
def pair (renew : W → Nat → W) (left : W → Nat → Nat) (s : W × Nat) : W × Nat :=
  (renew s.1 s.2, left s.1 s.2)

/-- The pair's step is `Mechanism.adaptive`'s, with the level in the place of its rule. -/
theorem pair_adaptive (renew : W → Nat → W) (left : W → Nat → Nat) :
    «谓» (Law.step (pair renew left))
      (moveRel (adaptive (fun (x : Nat) (w : W) (_ : Unit) => renew w x) (fun x w => left w x)) ())

/-- The net: a next only where the level meets the need. -/
def net (need : Nat) (renew : W → Nat → W) (left : W → Nat → Nat) : «际» (W × Nat) :=
  Law.stepWhile (fun s => need ≤ s.2) (pair renew left)

/-- Outside the marked levels the way after a step is `alone` of the way: the level makes no
difference to it there. -/
def AloneOutside (marked : Nat → Prop) (alone : W → W) (renew : W → Nat → W) : Prop :=
  ∀ w x, ¬ marked x → renew w x = alone w
```

`asItWas alone left` is written out as `pair (fun w _ => alone w) left` (use a `local notation` or an `abbrev`; your choice, no warning).

### C2. Which differences of level make a difference (root predicates)

```lean
theorem toEnd_iff (need : Nat) (renew : W → Nat → W) (left : W → Nat → Nat) :
    «至终有常» (net need renew left) (sameValue (Prod.fst : W × Nat → W)) ↔
      ∀ w x x', need ≤ x → need ≤ x' → renew w x = renew w x'

theorem constant_iff (need : Nat) (renew : W → Nat → W) (left : W → Nat → Nat) :
    «有常» (net need renew left) (sameValue (Prod.fst : W × Nat → W)) ↔
      ∀ w x x', need ≤ x → need ≤ x' ∧ renew w x = renew w x'

/-- constant exactly where nothing is needed of the level and no level makes a difference; at
`need = 0` the second clause is `adaptive_constant_iff`'s -/
theorem constant_iff_needs_nothing (w₀ : W) (need : Nat) (renew : W → Nat → W) (left : W → Nat → Nat) :
    «有常» (net need renew left) (sameValue (Prod.fst : W × Nat → W)) ↔
      need = 0 ∧ ∀ w x x', renew w x = renew w x'

theorem toEnd_of_unmarked {marked : Nat → Prop} {alone : W → W} {renew : W → Nat → W}
    (outside : AloneOutside marked alone renew) {need : Nat} (un : ∀ x, need ≤ x → ¬ marked x)
    (left : W → Nat → Nat) : «至终有常» (net need renew left) (sameValue (Prod.fst : W × Nat → W))

theorem unmarked_interval_iff {need low high : Nat} :
    (∀ x, need ≤ x → ¬ (low ≤ x ∧ x ≤ high)) ↔ high < low ∨ high < need

/-- the core tells a level at which it goes on from one at which the net has ended (by `«有常则可续»`
at the core, no new root law) -/
theorem core_tells {need : Nat} {renew : W → Nat → W} {left : W → Nat → Nat} {w : W} {x x' : Nat}
    (ge : need ≤ x) (lt : x' < need) :
    ¬ «核» (net need renew left) (sameValue (Prod.fst : W × Nat → W)) (w, x) (w, x')

/-- the way's regularity lies in the level (`«因于核»`), where something is needed; as with the flame
and its fuel, the joint class here is identity -/
theorem regularity_in_level (w₀ : W) {need : Nat} (pos : 0 < need) (renew : W → Nat → W)
    (left : W → Nat → Nat) :
    «因于核» (net need renew left) (sameValue (Prod.fst : W × Nat → W))
      (sameValue (Prod.snd : W × Nat → Nat))
```

Prove `toEnd_iff` through B's `stepWhile_toEnd_iff` and `stepWhile_goesAlike_iff`. If the tie to `adaptive_constant_iff` at `need = 0` can be stated as a one-line corollary, add it (`constant_adaptive`); if it needs more than about ten lines, leave it to the docstring and say so in your report.

### C3. The course as it was

```lean
/-- Up to the first marked level of the course as it was, the course is the course as it was. -/
theorem agrees_until_marked {marked : Nat → Prop} {alone : W → W} {renew : W → Nat → W}
    (outside : AloneOutside marked alone renew) (left : W → Nat → Nat) (s : W × Nat) :
    ∀ n, (∀ j, j < n → ¬ marked (Law.orbit (pair (fun w _ => alone w) left) s j).2) →
      Law.orbit (pair renew left) s n = Law.orbit (pair (fun w _ => alone w) left) s n

theorem asItWas_way (alone : W → W) (left : W → Nat → Nat) (s : W × Nat) :
    ∀ n, (Law.orbit (pair (fun w _ => alone w) left) s n).1 = Law.orbit alone s.1 n

/-- with no marked level where it goes on, lines of `n` steps from one way at two levels end alike:
`«同行之迭»` through A's tie -/
theorem alike_along {marked : Nat → Prop} {alone : W → W} {renew : W → Nat → W}
    (outside : AloneOutside marked alone renew) {need : Nat} (un : ∀ x, need ≤ x → ¬ marked x)
    {left : W → Nat → Nat} (n : Nat) {w : W} {x x' : Nat} {t t' : W × Nat}
    (line : «迭» (net need renew left) n (w, x) t) (line' : «迭» (net need renew left) n (w, x') t') :
    t.1 = t'.1
```

### C4. Ending where the net ends

On the level of the course as it was, in `Optimum`'s form, so that `Optimum.ends_within` is used as it stands.

```lean
theorem ends_with_net {marked : Nat → Prop} {alone : W → W} {renew : W → Nat → W}
    {left : W → Nat → Nat} (outside : AloneOutside marked alone renew)
    {need : Nat} (needs : 0 < need) (un : ∀ x, need ≤ x → ¬ marked x)
    {s : W × Nat} {g d : Nat → Nat} {r : Nat}
    (step : ∀ t, (Law.orbit (pair (fun w _ => alone w) left) s (t + 1)).2 =
      (Law.orbit (pair (fun w _ => alone w) left) s t).2 + g t - d t)
    (renews : ∀ t, g t ≤ r) (over : ∀ t, r < d t) :
    ∃ n t, n ≤ s.2 ∧ «迭» (net need renew left) n s t ∧ (∀ v, ¬ net need renew left t v) ∧
      t.1 = Law.orbit alone s.1 n
```

Proof route: `Optimum.ends_within step renews over needs` at `t := s.2`; then `first_of_decided` (ReadOffInTime 196) for the first step below the need; `agrees_until_marked` up to it; B's `stepWhile_steps_iff` and `stepWhile_none_iff`.

Then the regime as one way to meet its premises:

```lean
/-- `RegimeMargin.step` in `Optimum`'s form, where nothing gives from nothing. -/
theorem regime_step_eq {giving : Nat → Nat} (nothing : RegimeMargin.FromNothing giving) (d x : Nat) :
    RegimeMargin.step giving d x = x + giving (x - d) - d

theorem ends_with_net_regime {marked : Nat → Prop} {alone : W → W} {renew : W → Nat → W}
    (outside : AloneOutside marked alone renew) {need : Nat} (needs : 0 < need)
    (un : ∀ x, need ≤ x → ¬ marked x) {giving : Nat → Nat} {use : W → Nat} {H y : Nat}
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H y)
    {w : W} {x : Nat} (uses : ∀ j, H ≤ use (Law.orbit alone w j)) (below : x < H + y) :
    ∃ n t, n ≤ x ∧
      «迭» (net need renew (fun w x => RegimeMargin.step giving (use w) x)) n (w, x) t ∧
      (∀ v, ¬ net need renew (fun w x => RegimeMargin.step giving (use w) x) t v) ∧
      t.1 = Law.orbit alone w n
```

For the regime: `g t := giving (x̃ t - d t)`, `d t := use (Law.orbit alone w t)`, `r := H - 1`; `0 < H` follows from `short` and `below`; `g t ≤ r` needs the level to stay below `H + y`, which holds by a joint induction with `Optimum.never_rises` (the level never rises, so it stays within its start). Do not prove a fall by a new induction on the level where `Optimum`'s laws give it.

### C5. Turning in time, exactly

```lean
/-- **Split at the first marked level.** Where the course as it was comes to a level below the need,
the line never ends exactly where there is a step `T` of the course as it was, the need met and no
level marked before it, the need met and the level marked at it, from whose next configuration the
line never ends. -/
theorem unending_iff_first_marked {marked : Nat → Prop} [DecidablePred marked] {alone : W → W}
    {renew : W → Nat → W} {left : W → Nat → Nat} (outside : AloneOutside marked alone renew)
    {need : Nat} {s : W × Nat}
    (asItWasEnds : ∃ n, (Law.orbit (pair (fun w _ => alone w) left) s n).2 < need) :
    «不穷» (net need renew left) «一» s ↔
      ∃ T, (∀ j, j < T → need ≤ (Law.orbit (pair (fun w _ => alone w) left) s j).2 ∧
              ¬ marked (Law.orbit (pair (fun w _ => alone w) left) s j).2) ∧
        need ≤ (Law.orbit (pair (fun w _ => alone w) left) s T).2 ∧
        marked (Law.orbit (pair (fun w _ => alone w) left) s T).2 ∧
        «不穷» (net need renew left) «一»
          (pair renew left (Law.orbit (pair (fun w _ => alone w) left) s T))
```

Then the fate from the next configuration, by `RegimeMargin.ends_iff_below` as it stands:

```lean
/-- From a way of a kind that uses `H₂`, a kind every step keeps, the line never ends exactly where
the level is at or above `H₂ + y₂`. -/
theorem unending_iff_above {Kept : W → Prop} {renew : W → Nat → W} {giving : Nat → Nat}
    {use : W → Nat} {H₂ y₂ hi need : Nat}
    (kept : ∀ w x, Kept w → Kept (renew w x)) (uses : ∀ w, Kept w → use w = H₂)
    (nothing : RegimeMargin.FromNothing giving) (short : RegimeMargin.Short giving H₂ y₂)
    (meets : RegimeMargin.Meets giving H₂ y₂ hi) (keeps : RegimeMargin.Keeps giving H₂ hi)
    (needs : 0 < need) (within : need ≤ H₂ + y₂) {w : W} {x : Nat} (kind : Kept w) (high : x ≤ hi) :
    «不穷» (net need renew (fun w x => RegimeMargin.step giving (use w) x)) «一» (w, x) ↔ H₂ + y₂ ≤ x
```

And the two composed. State `turns_in_time_iff` as the composition of `unending_iff_first_marked`, `ends_with_net_regime`'s premises for the course as it was (so that `asItWasEnds` holds) and `unending_iff_above`, with these premises and no others: `outside`; `[DecidablePred marked]`; `turns : ∀ w x, marked x → Kept (renew w x)`; the premises of `unending_iff_above`; `nothing`; `short₁ : Short giving H₁ y₁`; `uses₁ : ∀ j, H₁ ≤ use (Law.orbit alone w j)`; `below : x < H₁ + y₁`; `high : x ≤ hi`. Its right side: there is a step `T` of the course as it was with the need met and no level marked before it, the need met and the level marked at it, and `H₂ + y₂ ≤` the level of the course as it was at `T + 1`. Write the exact Lean statement yourself from this, and check by hand that the level at `T + 1` of the course as it was is the level after the turning step (both use `left` of the way before the step). If the level at `T + 1` needs `≤ hi`, derive it from `Optimum.level_le_start` or the joint induction of C4, not from a new premise.

If the as-it-was use is one standing `k` and the giving one standing `r` while the need is met, add the closed form by `Optimum.reread_deadline_iff` only if it follows in a few lines; otherwise leave it out and say so.

The root reading, with a kind `κ : W → Bool`:

```lean
/-- With no marked level where it goes on and a kind that `alone` keeps, the class of the kind is
constant up to the net's end. -/
theorem kind_toEnd_of_unmarked {marked : Nat → Prop} {alone : W → W} {renew : W → Nat → W}
    (outside : AloneOutside marked alone renew) {need : Nat} (un : ∀ x, need ≤ x → ¬ marked x)
    {κ : W → Bool} (keeps : ∀ w, κ (alone w) = κ w) (left : W → Nat → Nat) :
    «至终有常» (net need renew left) (sameValue (fun s : W × Nat => κ s.1))

/-- Where at a marked level at which it goes on the way after the step is of another kind, and some
level at which it goes on is not marked, the class of the kind is not constant up to the net's end
at that member's class. -/
theorem kind_not_toEnd_of_turn {marked : Nat → Prop} {alone : W → W} {renew : W → Nat → W}
    (outside : AloneOutside marked alone renew) {need : Nat} {κ : W → Bool}
    (keeps : ∀ w, κ (alone w) = κ w) {left : W → Nat → Nat} {w : W} {x x° : Nat}
    (ge : need ≤ x) (turns : ¬ κ (renew w x) = κ w) (ge° : need ≤ x°) (un° : ¬ marked x°) :
    ¬ «本类至终有常» (net need renew left) (sameValue (fun s : W × Nat => κ s.1)) (w, x)
```

Use `«亡而网续则本类不至终有常»` for the second if its shape fits (a continuation step into an occurrence that ends under the class while it still conditions something); if it does not fit without an extra step on the line, prove it from the definition of `«本类至终有常»` and say in the docstring which root law it is the pair's case of.

### C6. The lock as the case that needs nothing

Read `Pace.lean`, `RuleCapture.lean` 150-200, `ClosedCapture.lean` 225-260, `PoolFromCourse.lean` 236-262, `GrammarRegularity.lean` 285-345, `OwnClass.lean` 99-122 and the maps `followup-ownclass-lock.md`, `followup-invariant-lock.md`, `lock-2.md` first.

1. `locked_closed`: under `Raises`, `ReadsShare` and `upper` (the premises of `turn_locked`), the region `fun q => Locked M favours hA (q.1.1, q.2.1)` is `«闭»` under `Law.step (Pace.step (join fA fB) (joinRead hA) reads)`. No `Accrues`.
2. `locked_at_class`: at a locked `m`, `«本类至终有常» … (lockedAlike M favours hA) m ∧ «所缘同于» … (lockedAlike M favours hA) m`, from 1 by `«类闭则本类常闭»` (OwnClass 105), `decided` met because the step is total.
3. `window_is_pair`: a regrouping `((a, x), g, n) ↦ ((a, g, n), x)` under which `Pace.step (join fA fB) (windowRead hA hL N K) reads` is `pair renew left` for the `renew` and `left` you read off `Pace.step`, `join` and `windowRead`; stated on orbits: for all `t`, the regrouped orbit is the pair's orbit from the regrouped start. And `window_alone_outside`: that `renew` is `AloneOutside (fun x => N ≤ x ∧ x < K) alone renew` for the `alone` that reads `hA`. So PoolFromCourse's course is a course of the pair with the marks `[N, K)` and a need of nothing, and its net never ends (`Law.stepWhile_unending_iff` at a guard always met).

Each of these states an identification. None re-proves `locked_stays`, `lock_line`, `window_never_read`, `window_past_course` or `course_past`. If 3 cannot be proved in the form above (the schedule, the step count or `turn`'s shape stand in the way), stop, and report exactly which definition blocks it and what weaker identification is true.

### C7. Three courses from one start

With giving `fun z => min z (12 - z)`, a use of five as it was and three once of the kept kind, a need of one, `hi := 12`, from the level nine: the course as it was runs nine, eight, six, two, nothing. With the marks so that the level is first marked at step 0 or at step 1, the line never ends (eight or six left, both at or above six). With the marks so that it is first marked at step 2, it turns and ends (two left). With no marked level, it ends as it was. Check each number by hand before stating it. State the three as theorems through `turns_in_time_iff` or `unending_iff_first_marked` (the first), by computation (`decide` on closed terms, `rfl`) for the lines that end. Use `RegimeMargin.short_of_below`, `meets_of_below`, `keeps_of_below` with `rfl` for the regime facts. Names: `Three.goes_on`, `Three.turned_and_ends`, `Three.ends_as_it_was`.

### The header docstring of C

Title: `# Turning in time: a line that ends where the net ends, or while the net goes on`. Say, in this order and in the root's words: what the root already has (the two endings, `«至终有常»`, with names); what the level's laws already have (`Optimum`'s, `RegimeMargin`'s, with names); what this module adds (the pair cut by a need; which differences of level make a difference; ending where the net ends; the split at the first marked level; the lock as the case that needs nothing); then a section "What is given and what is not shown" listing every premise that carries weight (`AloneOutside` and the marks are given, not derived; `Kept` is kept by premise; that the marked levels are levels of the same quantity the going on needs is a choice of the model; nothing here is about a trained system; `ReadOffInTime`'s laws on its own model are not joined; the lock's courses are identified with the pair's only by regrouping, at a need of nothing). First line of the docstring body: "AI-written, 12 November 2026."

## What each implementer returns

The files written; the scratch build's audit (theorems, declarations, axioms, warnings); every statement that differs from this design, with the old and new form and the reason; every statement not proved, with where it stuck; every existing law used, by name; anything in the design you believe is wrong.
