import Becoming.GrammarCourse
import Becoming.GrammarPath
import Becoming.GrammarRegularity
import Becoming.Lasting

/-!
# A law's step while it can go on (Law.stepWhile)

A determined law's step read as 缘 (`Law.step`, `Becoming.GrammarCourse`) gives every configuration
exactly one next one: its successor is fixed and every configuration has one, so on it nothing ever
conditions nothing, the net never ends, and going alike and constancy coincide there
(`«同行当且仅当有常»`, whose two premises are these). A line under a class can then end only by leaving
the class, never where the net ends. This module cuts the step where it cannot go on:
`Law.stepWhile can next` relates `s` to `next s` where `can s`, and relates `s` to nothing where
`can s` fails. A line on it can end where the net ends. A cut step of this shape is already used in a
witness: `Map.StepWhere.relation` (`Becoming.GrammarMap`), the short life's one step taken where a
proposition holds.

* **The tie to the whole step.** The cut step lies within the whole one (`Law.stepWhile_step`), is
  the whole step where it can always go on (`Law.stepWhile_always`), and has a fixed successor
  (`Law.stepWhile_fixed`, as the whole step's `Law.step_fixed`). A step of the cut step that continues
  under `E` is a step of the whole step that continues under `E` where it can go on
  (`Law.stepWhile_continues_iff`).
* **From the whole step's, through the tie.** A configuration has a successor in a line under `E`
  exactly where it can go on and is `E`-alike to the configuration after it
  (`Law.stepWhile_hasSucc_iff`, from `Law.step_hasSucc_iff`); under the one, the line from `s` never
  ends exactly where it can go on at every configuration of the orbit (`Law.stepWhile_unending_iff`,
  from `Law.unending_iff_steps`, with one private transfer: whether a line never ends depends on the
  relation and the class only through the steps that continue).
* **On the orbit.** `n` steps from `s` reach `orbit next s n` exactly where it can go on at each of
  the first `n` configurations of the orbit (`Law.stepWhile_steps_iff`, by its own induction on `n`;
  that the whole step reaches the orbit's configuration is `Law.steps_orbit`, `Becoming.Recurrence`,
  which the proof does not use).
* **Proved pointwise.** A configuration conditions nothing exactly where it cannot go on
  (`Law.stepWhile_none_iff`). A value class goes alike under the cut step exactly where two
  configurations of one value that can both go on go to configurations of one value
  (`Law.stepWhile_goesAlike_iff`, from `«同行之逐点»`). A value class is constant exactly where of two
  configurations of one value, where the first can go on, the second can too and their next
  configurations are of one value (`Law.stepWhile_constant_iff`, from `«有常之逐点»`); so constancy asks
  that the configurations of one value agree on whether they can go on, and going alike does not. For
  any relation, where `can` is decided at every configuration, constancy up to the net's end is going
  alike (`Law.stepWhile_toEnd_iff`), from `«局定后则至终有常当且仅当同行可决»` (`Becoming.GrammarPath`):
  the successor is fixed, and whether a configuration conditions anything is decided by `can`. That
  `can` be decided cannot be dropped: on two configurations left where they are, one that can always
  go on and one that can go on exactly where a proposition `P` holds, the cut step goes alike under
  the one and its constancy up to the net's end decides `P` (`Law.stepWhile_toEnd_decides`).
  `«尽则有终当且仅当排中»` (`Becoming.GrammarMap`, witnessed by `Map.StepWhere`) is a neighbour: there
  too a line's end takes a decision.
* **The guarded law.** `Viability.guardedStep` is a guarded law of another shape: a function on
  `Option S` under disturbances that stops at the first step beginning or ending outside the guard,
  where the cut step here is a relation asking `can` at the start of a step only. From a
  configuration that can go on, the guarded history of the law under the one disturbance
  (`Lasting.determined`) is at `n` the orbit's configuration exactly where `n` steps of the cut step
  lead there and it can go on there (`Law.stepWhile_guarded_iff`, by `Lasting.guarded_upto_iff`).

AI-written, 12 November 2026. Every declaration has an empty axiom report.
-/

namespace Becoming

universe u w

namespace Law

variable {S : Type u}

/-- A determined law's step while it can go on, read as 缘: `s` is a condition of `t` where `s` can go
on and `t` is the configuration after it. Where it cannot go on, `s` is a condition of nothing. -/
def stepWhile (can : S → Prop) (next : S → S) : «际» S := fun s t => can s ∧ t = next s

/-- The step while it can go on lies within the law's step. -/
theorem stepWhile_step {can : S → Prop} {next : S → S} : «则» (stepWhile can next) (step next) :=
  fun _ _ h => h.2

/-- Where it can always go on, the step while it can go on is the law's step. -/
theorem stepWhile_always (next : S → S) : «谓» (stepWhile (fun _ => True) next) (step next) :=
  fun _ _ => ⟨fun h => h.2, fun h => ⟨trivial, h⟩⟩

/-- The step while it can go on has a fixed successor, as the law's whole step has (`Law.step_fixed`). -/
theorem stepWhile_fixed (can : S → Prop) (next : S → S) : «定后» (stepWhile can next) :=
  fun _ _ ⟨_, ⟨_, e₁⟩, ⟨_, e₂⟩⟩ => e₁.trans e₂.symm

/-- A step of the cut law that continues under `E` is a step of the whole law that continues under
`E` where it can go on. -/
theorem stepWhile_continues_iff {can : S → Prop} {next : S → S} {E : «际» S} {s t : S} :
    «续» (stepWhile can next) E s t ↔ «续» (step next) (fun x y => can x ∧ E x y) s t :=
  ⟨fun ⟨⟨c, e⟩, h⟩ => ⟨e, c, h⟩, fun ⟨e, c, h⟩ => ⟨⟨c, e⟩, h⟩⟩

/-- `n` steps while it can go on lead from `s` to `t` exactly where it can go on at each of the first
`n` configurations of the orbit from `s` and `t` is the configuration `n` steps after `s`. -/
theorem stepWhile_steps_iff {can : S → Prop} {next : S → S} : ∀ (n : Nat) {s t : S},
    «迭» (stepWhile can next) n s t ↔ (∀ j, j < n → can (orbit next s j)) ∧ t = orbit next s n
  | 0, _, _ => ⟨fun e => ⟨fun j h => absurd h (Nat.not_lt_zero j), e.symm⟩, fun ⟨_, e⟩ => e.symm⟩
  | n + 1, s, t =>
    ⟨fun ⟨w, ⟨c, ew⟩, rest⟩ => by
      subst ew
      match (stepWhile_steps_iff n).mp rest with
      | ⟨all, et⟩ =>
        refine ⟨fun j h => ?_, et.trans (orbit_shift next s n).symm⟩
        match j, h with
        | 0, _ => exact c
        | j + 1, h =>
          exact Eq.mp (congrArg can (orbit_shift next s j).symm) (all j (Nat.lt_of_succ_lt_succ h)),
     fun ⟨all, et⟩ =>
      ⟨next s, ⟨all 0 (Nat.succ_pos n), rfl⟩,
        (stepWhile_steps_iff n).mpr
          ⟨fun j h => Eq.mp (congrArg can (orbit_shift next s j)) (all (j + 1) (Nat.succ_lt_succ h)),
           et.trans (orbit_shift next s n)⟩⟩⟩

/-- A configuration conditions nothing under the step while it can go on exactly where it cannot go
on. -/
theorem stepWhile_none_iff {can : S → Prop} {next : S → S} {t : S} :
    (∀ v, ¬ stepWhile can next t v) ↔ ¬ can t :=
  ⟨fun h c => h (next t) ⟨c, rfl⟩, fun h _ ⟨c, _⟩ => h c⟩

/-- A configuration has a successor in a line under `E` exactly where it can go on and is `E`-alike
to the configuration after it: `Law.step_hasSucc_iff` through `stepWhile_continues_iff`. -/
theorem stepWhile_hasSucc_iff {can : S → Prop} {next : S → S} {E : «际» S} {s : S} :
    «有后» (stepWhile can next) E s ↔ can s ∧ E s (next s) :=
  ⟨fun ⟨t, c⟩ => (step_hasSucc_iff (E := fun x y => can x ∧ E x y)).mp
      ⟨t, stepWhile_continues_iff.mp c⟩,
   fun h => match (step_hasSucc_iff (E := fun x y => can x ∧ E x y)).mpr h with
     | ⟨t, c⟩ => ⟨t, stepWhile_continues_iff.mpr c⟩⟩

/-- Whether a line never ends depends on the relation and the class only through the steps that
continue: where these are the same, so is it. The transfer `stepWhile_unending_iff` needs. -/
private theorem unending_of_continues {R R' E E' : «际» S}
    (same : ∀ x y, «续» R E x y ↔ «续» R' E' x y) {s : S} : «不穷» R E s ↔ «不穷» R' E' s :=
  ⟨fun never y reach =>
    match never y (match reach with
      | .inl e => .inl e
      | .inr line => .inr («及之单调» (fun x y => (same x y).mpr) _ _ line)) with
    | ⟨z, c⟩ => ⟨z, (same _ _).mp c⟩,
   fun never y reach =>
    match never y (match reach with
      | .inl e => .inl e
      | .inr line => .inr («及之单调» (fun x y => (same x y).mp) _ _ line)) with
    | ⟨z, c⟩ => ⟨z, (same _ _).mpr c⟩⟩

/-- The line from `s` under the one never ends exactly where it can go on at every configuration of
the orbit: `Law.unending_iff_steps` at the class `fun x y => can x ∧ «一» x y`, through
`stepWhile_continues_iff`. -/
theorem stepWhile_unending_iff {can : S → Prop} {next : S → S} {s : S} :
    «不穷» (stepWhile can next) «一» s ↔ ∀ n, can (orbit next s n) :=
  (unending_of_continues (fun _ _ => stepWhile_continues_iff)).trans
    ((unending_iff_steps (E := fun x y => can x ∧ «一» x y)).trans
      ⟨fun all n => (all n).1, fun all n => ⟨all n, trivial⟩⟩)

/-- A value class goes alike under the step while it can go on exactly where two configurations of
one value that can both go on go to configurations of one value. -/
theorem stepWhile_goesAlike_iff {K : Type w} {can : S → Prop} {next : S → S} {π : S → K} :
    «同行» (stepWhile can next) (sameValue π) ↔
      ∀ s s', π s = π s' → can s → can s' → π (next s) = π (next s') :=
  «同行之逐点».trans
    ⟨fun h s s' e c c' => h s s' e (next s) (next s') ⟨c, rfl⟩ ⟨c', rfl⟩,
     fun h x x' e y y' ⟨c, ey⟩ ⟨c', ey'⟩ => by
      subst ey
      subst ey'
      exact h x x' e c c'⟩

/-- For any relation `E`, where whether a configuration can go on is decided, constancy up to the
net's end under the step while it can go on is going alike: `«局定后则至终有常当且仅当同行可决»` with the
successor fixed (`stepWhile_fixed`) and whether the next configuration conditions anything decided by
`can` (`stepWhile_none_iff`). -/
theorem stepWhile_toEnd_iff {can : S → Prop} {next : S → S} {E : «际» S}
    (decided : ∀ s, can s ∨ ¬ can s) :
    «至终有常» (stepWhile can next) E ↔ «同行» (stepWhile can next) E :=
  have tie := «局定后则至终有常当且仅当同行可决» (R := stepWhile can next) (E := E)
    (fun _ x' _ v w r r' => stepWhile_fixed can next v w ⟨x', r, r'⟩)
  ⟨fun constant => (tie.mp constant).1,
   fun alike => tie.mpr ⟨alike, fun _ u' _ _ _ => match decided u' with
     | .inl c => .inl ⟨next u', c, rfl⟩
     | .inr no => .inr (stepWhile_none_iff.mpr no)⟩⟩

/-- A value class is constant under the step while it can go on exactly where of two configurations
of one value, where the first can go on, the second can go on too and their next configurations are of
one value. -/
theorem stepWhile_constant_iff {K : Type w} {can : S → Prop} {next : S → S} {π : S → K} :
    «有常» (stepWhile can next) (sameValue π) ↔
      ∀ s s', π s = π s' → can s → can s' ∧ π (next s) = π (next s') :=
  («有常之逐点» (stepWhile can next) (sameValue π)).trans
    ⟨fun h s s' e c => match h s s' e (next s) ⟨c, rfl⟩ with
       | ⟨_, ⟨c', ev⟩, same⟩ => ⟨c', same.trans (congrArg π ev)⟩,
     fun h u u' e v ⟨c, ev⟩ => match h u u' e c with
       | ⟨c', same⟩ => ⟨next u', ⟨c', rfl⟩, by subst ev; exact same⟩⟩

/-- **That `can` be decided cannot be dropped from `stepWhile_toEnd_iff` (witness).** On the two truth
values, with the step that leaves each where it is, let `true` always be able to go on and `false`
exactly where `P` holds. Under the one the cut step goes alike, and its constancy up to the net's end
decides `P`. -/
theorem stepWhile_toEnd_decides (P : Prop) :
    «同行» (stepWhile (fun b : Bool => b = true ∨ P) id) («一» : «际» Bool) ∧
      («至终有常» (stepWhile (fun b : Bool => b = true ∨ P) id) («一» : «际» Bool) → P ∨ ¬ P) :=
  ⟨«同行之逐点».mpr fun _ _ _ _ _ _ _ => trivial,
   fun constant =>
    match constant true false trivial true ⟨.inl rfl, rfl⟩ with
    | .inl ⟨_, ⟨can, _⟩, _⟩ => can.elim (fun e => Bool.noConfusion e) .inl
    | .inr stops => .inr fun p => stops false ⟨.inr p, rfl⟩⟩

/-- **The cut step and the guarded law.** From a configuration that can go on, the guarded history
(`Viability.guardedHistory`) of the law as a law of change under one disturbance
(`Lasting.determined`) is at `n` the orbit's configuration exactly where `n` steps of the cut step
lead there and it can go on there. The guarded law asks the guard at both ends of a step; the cut step
asks `can` at its start only. By `Lasting.guarded_upto_iff`. -/
theorem stepWhile_guarded_iff {can : S → Prop} [DecidablePred can] {next : S → S} {s : S}
    (start : can s) {n : Nat} :
    Viability.guardedHistory (Lasting.determined next) can s (fun _ => ()) n = some (orbit next s n) ↔
      «迭» (stepWhile can next) n s (orbit next s n) ∧ can (orbit next s n) :=
  have same : ∀ k, orbit next s k = Viability.history (Lasting.determined next) s (fun _ => ()) k :=
    Lasting.orbit_eq_history next s (fun _ => ())
  have upto : Viability.guardedHistory (Lasting.determined next) can s (fun _ => ()) n =
      some (orbit next s n) ↔ ∀ k, k ≤ n → can (orbit next s k) :=
    ⟨fun agree k le => Eq.mpr (congrArg can (same k))
        ((Lasting.guarded_upto_iff start).mp (agree.trans (congrArg some (same n))) k le),
     fun all => ((Lasting.guarded_upto_iff start).mpr fun k le =>
        Eq.mp (congrArg can (same k)) (all k le)).trans (congrArg some (same n)).symm⟩
  upto.trans
    ⟨fun all => ⟨(stepWhile_steps_iff n).mpr ⟨fun j lt => all j (Nat.le_of_lt lt), rfl⟩,
        all n (Nat.le_refl n)⟩,
     fun ⟨steps, last⟩ k le => (Nat.lt_or_eq_of_le le).elim
        (fun lt => ((stepWhile_steps_iff n).mp steps).1 k lt)
        (fun e => Eq.mpr (congrArg (fun j => can (orbit next s j)) e) last)⟩

end Law

end Becoming
