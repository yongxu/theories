import Becoming.LearningRuns
import Becoming.Courses
import Becoming.Gain

/-!
# Identification along runs: the states of a run and what a bounded prefix fixes

`Becoming.Description` reads states off one history through a map (`SameAhead`, `StatesBelow`)
and states what a description of parts keeps and loses (`Separated`, `Rectangular`);
`Becoming.Identification` states what a bound on the states adds: a prefix of `N + N' - 1` steps
fixes the history, the extrapolation given the bound is right from there, Moore's bound holds
within one history. A course read along a run of any process is its course through a map
(`Parting.course`), every course is the course of a run of free branching (`Parting.freeRun`), every run of
a determined law is its orbit (`Branching.law_run_state`), and a whole of parts reached by a law's
courses is `Courses.reachedFrom`. This module states those laws of runs and of reached wholes.

* **The states of a run.** Two moments of a run of a determined law are one state exactly where
  their configurations are alike in the frame by `reg` (`sameAhead_iff_alike`). A run
  whose start returns has two moments that are one state (`returns_states`); a run taking a
  different value through the map at every moment has each moment as its own state (`new_each`);
  a run's course through the map has finitely many states exactly where it repeats from some
  step (`finitely_many_states_iff_lasso`).
  Along the run of negation from `true` there are exactly two states (`negation_two_states`), each
  defined through the other (`negation_each_through_other`).
* **A bounded prefix fixes a run's course, exactly.** Two runs of any process with at most `N` and
  `N'` states that are alike through the map before `N + N' - 1` are alike at every step
  (`prefix_fixes`); for every `T` two runs of free branching with one state and with `T + 1` part
  at `T` (`prefix_short`). Two moments of a run with at most `N` states are one state exactly where
  the courses from them agree for `N + N - 1` steps (`sameAhead_iff_below`), and for
  `N - 1` steps, with the values decided (`sameAhead_iff_classes`) or with no premise
  (`sameAhead_iff_within`). Moore's bound is exact on runs: for every `M` two runs of a law on
  `M + 2` positions part at `M` (`classes_exact_runs`); before Moore's step, agreement of two runs
  of a law on a list closed under it is refuted by nothing (`classes_unrefuted_runs`).
* **Extrapolations along runs.** The extrapolation given the bound misses at no step of a run with
  at most `N` states (`withBound_accords`); no extrapolation can always propose sooner on runs of
  free branching (`withBound_earliest`), and being given the bound buys silence, not an earlier rest
  (`rest_without_bound_missed`). On a run whose course through the map repeats, elimination over
  the lasso candidates is right from a step that is found (`rests_of_lasso`), a step no earlier
  than cubic in the bound (`byElimination_rest_cubic`). Along the run of negation from `true` the
  extrapolation given two states is right from step `3` (`negation_derived`). The run
  of the diagonal law of the extrapolation given the bound `N` has more than `N` states
  (`answer_exceeds_bound`).
* **What a description of parts keeps along courses.** Of the whole a law's courses reach,
  describing each part by itself keeps every reached combination (`separated_of_whole`) and
  adds none exactly where the reached whole is rectangular (`separation_faithful_iff`).
  After one move of copying the first part into the second, the parts always go alike and,
  described separately, could go apart (`copy_separation_admits_extra`). After one move of the law
  setting a third part to the parity of the first two (`parity`), the reached whole is the even
  triples (`parity_reached_iff`): every two parts are free in it and the three are not
  (`parity_whole_not_in_pairs`).
* **The coarsest class keeping the map's values and carrying the law.** The same course through
  the map is the coarsest relation that keeps the map's values and that the law keeps
  (`Law.sameFuture_coarsest`), with no premise. A class that keeps the values and carries the law
  (`Law.KeepsAndCarries`) is coarser than every such relation exactly where it merges every two
  configurations with the same course, exactly where it merges exactly those, exactly where it
  makes sense (`Law.coarsest_iff`); a class merging exactly those is coarser than every class that
  keeps the values and carries the law (`Law.coarser_of_exact`). Where a list holds every
  configuration the names are such a class, and a class keeping the values and carrying the law
  is coarser than every other into the universe of the map's values exactly where it merges
  exactly the configurations with the same course (`Law.coarsest_class`). For a law on any type
  no such class is constructed here: the quotient by the same course can be formed, but that it
  merges configurations with the same course takes `Quot.sound`, which the core does not use; the
  relation is always there.
* **The course of what couples into a formation.** Where `value` gives the values of what couples
  into a formation (`Web.ValuesThrough`; where admission is decided and the conditions coupled in
  by level are listed, `Web.listed_values`), its own course under a level history, read by
  `value`, is the value at each step of what couples in then (`Web.courseThrough`). Two histories
  are alike through its couplings up to a step exactly where its own courses under them share
  their prefix to that step (`Web.alikeThroughUpTo_iff_prefix`); a selection is through its
  couplings exactly where it selects each history by that prefix (`Web.selectsThrough_iff_prefix`,
  `Web.selects_alike_iff_prefix`). Where its own courses under two histories have at most `N` and
  `N'` states, histories alike through its couplings before `N + N' - 1` are alike through them at
  every step (`Web.alike_of_bounded`, `Web.selects_alike_of_bounded`), a bound attained in a web of
  one condition (`Web.bounded_exact`); where the two courses read together have at most `P`
  states, alike before `P` is enough (`IdentificationRuns.joint_agree`,
  `Web.alike_of_joint_bounded`). The states of an own course compare values at different steps,
  which the coupling, comparing two histories at one step, does not: they depend on the reading,
  and in the web of one condition a constant history has one state read by the level and more than
  every bound read with the step (`Web.states_by_reading`).

No ethical predicate, ranking or axiom occurs.

Declarations moved here unchanged, with their names, from `Becoming.Description` and
`Becoming.Identification` (board item W), and `Law.KeepsRelation` with `Law.KeepsRelation.run`
from `Becoming.SharedCodes` (board item WL2): see the sections so headed.
-/

/-! ## Laws that identify alike configurations (moved from `Becoming.Description`) -/

namespace Becoming

open Generative

universe u v w

namespace Law

variable {S : Type u} {R : Type v} {K : Type w}

/-- A split that keeps the map's value and carries a law relates configurations by a
bisimulation of the law framed by the map. -/
theorem kernel_bisimulation {next : S → S} {o : S → R} {π : S → K}
    (keeps : ∀ s s', π s = π s' → o s = o s') (alike : GoAlike (process next) π) :
    Bisimulation (frameBy next o) (frameBy next o) (fun s s' => π s = π s') :=
  fun s s' same =>
    have ahead : π (next s) = π (next s') := Learning.goAlike_iff_lumped.mp alike s s' same
    ⟨fun _ => ⟨fun h => (keeps s s' same).symm.trans h, fun h => (keeps s s' same).trans h⟩,
     fun _ _ to => ⟨next s', rfl, by cases to; exact ahead⟩,
     fun _ _ to => ⟨next s, rfl, by cases to; exact ahead⟩⟩

/-- Such a split loses nothing the map tells apart. -/
theorem sameFuture_of_law {next : S → S} {o : S → R} {π : S → K}
    (keeps : ∀ s s', π s = π s' → o s = o s') (alike : GoAlike (process next) π) {s s' : S}
    (same : π s = π s') : SameFuture next o s s' :=
  alike_iff_sameFuture.mp ⟨_, kernel_bisimulation keeps alike, same⟩

/-- **The coarsest split that keeps the map's value and carries a law makes sense.** -/
theorem identifiesAlike_of_law {next : S → S} {o : S → R} {π : S → K}
    (keeps : ∀ s s', π s = π s' → o s = o s') (alike : GoAlike (process next) π)
    (coarsest : ∀ s s', SameFuture next o s s' → π s = π s') : IdentifiesAlike (frameBy next o) π :=
  identifiesAlike_iff.mpr ⟨kernel_bisimulation keeps alike,
    fun s s' same => coarsest s s' (alike_iff_sameFuture.mp same)⟩

/-- The split that lumps everything always carries a law (`goAlike_const`), and makes sense only
where the map's value never differs. -/
theorem const_identifiesAlike_iff {next : S → S} {o : S → R} (k : K) :
    IdentifiesAlike (frameBy next o) (fun _ => k) ↔ ∀ s s', SameFuture next o s s' :=
  ⟨fun sense s s' => alike_iff_sameFuture.mp ((sense s s').mp rfl),
   fun all s s' => ⟨fun _ => alike_iff_sameFuture.mpr (all s s'), fun _ => rfl⟩⟩

/-- **The map's present value makes sense by itself exactly where it fixes its own future
through the map.** -/
theorem now_identifiesAlike_iff {next : S → S} {o : S → R} :
    IdentifiesAlike (frameBy next o) o ↔ ∀ s s', o s = o s' → SameFuture next o s s' :=
  ⟨fun sense s s' e => alike_iff_sameFuture.mp ((sense s s').mp e),
   fun fixes s s' => ⟨fun e => alike_iff_sameFuture.mpr (fixes s s' e),
     fun same => (alike_iff_sameFuture.mp same) 0⟩⟩

/-- **Through the identity map, the configuration itself is the split that makes sense**:
nothing alike is two. -/
theorem whole_identifiesAlike (next : S → S) : IdentifiesAlike (frameBy next id) id :=
  identifiesAlike_id_iff.mpr fun _ _ alike => alike_iff_sameFuture.mp alike 0

/-- **The part read through the map alone makes sense exactly where the rest never makes a
difference through the map**; elsewhere the split that makes sense includes the rest. -/
theorem part_identifiesAlike_iff {X : Type u} {C : Type v} {next : X × C → X × C} :
    IdentifiesAlike (frameBy next Prod.fst) Prod.fst ↔
      ∀ x c c', SameFuture next Prod.fst (x, c) (x, c') :=
  now_identifiesAlike_iff.trans
    ⟨fun fixes x c c' => fixes (x, c) (x, c') rfl,
     fun rest s s' e => by
       cases s with
       | mk x c =>
         cases s' with
         | mk x' c' =>
           have e : x = x' := e
           subst e
           exact rest x c c'⟩

/-- Where the map's value carries a law, it fixes its own future through the map. -/
theorem sameFuture_of_goAlike {next : S → S} {o : S → R} (alike : GoAlike (process next) o) :
    ∀ s s', o s = o s' → SameFuture next o s s' := by
  intro s s' e n
  induction n with
  | zero => exact e
  | succ n ih => exact Learning.goAlike_iff_lumped.mp alike _ _ ih

/-- **The map's present value makes sense by itself exactly where it carries a law**: a condition
on one step. -/
theorem now_identifiesAlike_iff_goAlike {next : S → S} {o : S → R} :
    IdentifiesAlike (frameBy next o) o ↔ GoAlike (process next) o :=
  now_identifiesAlike_iff.trans
    ⟨fun fixes => Learning.goAlike_iff_lumped.mpr fun s s' e => fixes s s' e 1, sameFuture_of_goAlike⟩

/-- **The part read through the map alone makes sense exactly where the rest makes no difference
to its next value.** -/
theorem part_identifiesAlike_iff_step {X : Type u} {C : Type v} {next : X × C → X × C} :
    IdentifiesAlike (frameBy next Prod.fst) Prod.fst ↔ ∀ x c c', (next (x, c)).1 = (next (x, c')).1 := by
  refine now_identifiesAlike_iff_goAlike.trans ⟨fun alike x c c' => Learning.goAlike_iff_lumped.mp alike _ _ rfl, ?_⟩
  intro every
  apply Learning.goAlike_iff_lumped.mpr
  intro s s' e
  cases s with
  | mk x c =>
    cases s' with
    | mk x' c' =>
      have e : x = x' := e
      subst e
      exact every x c c'

/-- A part whose next value is set by a rule that changes with it: the part alone makes sense
exactly where the rule makes no difference to it, the condition of `adaptive_state_law_iff`. -/
theorem adaptive_identifiesAlike_iff {X : Type u} {C : Type v} (F : C → X → X) (G : C → X → C) :
    IdentifiesAlike (frameBy (fun s : X × C => (F s.2 s.1, G s.2 s.1)) Prod.fst) Prod.fst ↔
      ∀ x c c', F c x = F c' x :=
  part_identifiesAlike_iff_step

end Law

namespace Motion

/-- The same law read as `Becoming.Mechanism`'s adaptive process, the passing as the rule. -/
theorem move_adaptive :
    Law.process move = adaptive (fun g x (_ : Unit) => x + g) (fun g (_ : Nat) => g) :=
  rfl

/-- **Through the map to the standing alone, the split that makes sense is the pair.** -/
theorem pair_identifiesAlike : IdentifiesAlike (Law.frameBy move Prod.fst) (fun s : Nat × Nat => s) :=
  fun ⟨x, v⟩ ⟨x', v'⟩ =>
    ⟨fun e => match e with | rfl => Alike.refl _ (x, v),
     fun alike =>
      have h := Law.alike_iff_sameFuture.mp alike
      have hx : x = x' := h 0
      have h1 : x + v = x' + v' := h 1
      match hx with
      | rfl => match cancel x ((Nat.add_comm v x).trans (h1.trans (Nat.add_comm x v'))) with
        | rfl => rfl⟩

/-- The standing alone carries no law: the passing makes a difference to it. -/
theorem standing_alone : ¬ GoAlike (Law.process move) Prod.fst :=
  fun alike => absurd ((adaptive_state_law_iff.mp (move_adaptive ▸ alike)) 0 1 0 ()) (by decide)

/-- Neither alone makes sense. -/
theorem neither_alone :
    ¬ IdentifiesAlike (Law.frameBy move Prod.fst) Prod.fst ∧
      ¬ IdentifiesAlike (Law.frameBy move Prod.fst) Prod.snd :=
  ⟨fun sense => standing_alone (carries_law_iff.mp (Law.IdentifiesAlike.carries sense)),
   fun sense => passing_alone (Law.alike_iff_sameFuture.mp ((sense (0, 0) (1, 0)).mp rfl))⟩

/-- **Where nothing passes, the standing alone makes sense**: the pair is one. -/
theorem still_identifiesAlike : IdentifiesAlike (Law.frameBy still Prod.fst) Prod.fst :=
  Law.now_identifiesAlike_iff.mpr fun s s' h n =>
    (congrArg Prod.fst (orbit_still s n)).trans (h.trans (congrArg Prod.fst (orbit_still s' n)).symm)

end Motion

section Moments

variable {O : Type v}

/-- **Every history through a map is a determined law read through a map**: the law of
moments, each going on to the next, which is the succession of the step index and nothing more.
Its alike moments are the moments that are one state. -/
theorem alike_moments_iff {o : Nat → O} {t t' : Nat} :
    Alike (Law.frameBy Nat.succ o) (Law.frameBy Nat.succ o) t t' ↔ SameAhead o t t' :=
  Law.alike_iff_sameFuture.trans
    ⟨fun h n => (congrArg o (Law.succ_orbit t n)).symm.trans
        ((h n).trans (congrArg o (Law.succ_orbit t' n))),
     fun h n => (congrArg o (Law.succ_orbit t n)).trans
        ((h n).trans (congrArg o (Law.succ_orbit t' n)).symm)⟩

end Moments

end Becoming

/-! ## Names that identify alike configurations (moved from `Becoming.Identification`) -/

namespace Becoming

open Generative

universe u v w

namespace Law

variable {S : Type v} {R : Type w}

/-- **The split that makes sense, named with no quotient.** In a world a list holds, naming each
configuration by its future through the map before `N + N - 1` makes sense. -/
theorem name_identifiesAlike {next : S → S} {o : S → R} {l : List S} (world : ∀ s, s ∈ l) :
    IdentifiesAlike (Law.frameBy next o) (name next o (l.length + l.length - 1)) :=
  fun s s' =>
    (Identification.prefix_eq_iff.trans
      (sameFuture_iff_below (fun s _ => world (next s)) (world s) (world s')).symm).trans
      Law.alike_iff_sameFuture.symm

/-- **The names carry the law.** -/
theorem name_carries {next : S → S} {o : S → R} {l : List S} (world : ∀ s, s ∈ l) :
    ∃ Q : Process (List R) Unit,
      Determined Q ∧ FactorsThrough (Law.process next) (name next o (l.length + l.length - 1)) Q :=
  Law.IdentifiesAlike.carries (name_identifiesAlike world)

/-- **Likeness is decided by comparing names.** -/
def decideAlike [DecidableEq R] {next : S → S} {o : S → R} {l : List S} (world : ∀ s, s ∈ l)
    (s s' : S) : Decidable (Alike (Law.frameBy next o) (Law.frameBy next o) s s') :=
  decidable_of_iff _ (name_identifiesAlike world s s')

end Law

end Becoming


/-! ## The coarsest class keeping the map's values and carrying the law -/

namespace Becoming

open Generative

universe u v w w'

namespace Law

variable {S : Type u} {R : Type v} {K : Type w} {K' : Type w'}

/-! Declarations moved here unchanged, with their names, from `Becoming.SharedCodes` (board item
WL2), so that the coarsest relation below is stated with them. -/

/-- A law keeps a relation of configurations: related configurations go on to related
configurations. -/
def KeepsRelation (T : S → S) (rel : S → S → Prop) : Prop := ∀ x y, rel x y → rel (T x) (T y)

/-- **A kept relation holds at every step** of the runs from related configurations. -/
theorem KeepsRelation.run {T : S → S} {rel : S → S → Prop} (keeps : KeepsRelation T rel) {x y : S}
    (related : rel x y) : ∀ n, rel ((run T x).state n) ((run T y).state n)
  | 0 => related
  | n + 1 => keeps _ _ (KeepsRelation.run keeps related n)

/-- A class keeps the map's values and carries the law: configurations it merges take the same
value through the map and go by a step to configurations it merges. -/
def KeepsAndCarries (next : S → S) (o : S → R) (π : S → K) : Prop :=
  (∀ s s', π s = π s' → o s = o s') ∧ GoAlike (process next) π

variable {next : S → S} {o : S → R}

/-- **The same course through the map is the coarsest relation that keeps the map's values and
that the law keeps**, with no premise: it keeps the values, the law keeps it, and it holds every
relation that does both. -/
theorem sameFuture_coarsest :
    (∀ s s', SameFuture next o s s' → o s = o s') ∧ KeepsRelation next (SameFuture next o) ∧
      ∀ E : S → S → Prop, (∀ s s', E s s' → o s = o s') → KeepsRelation next E →
        ∀ s s', E s s' → SameFuture next o s s' :=
  ⟨fun _ _ same => same 0,
   fun s s' same n => (congrArg o (orbit_shift next s n)).symm.trans
      ((same (n + 1)).trans (congrArg o (orbit_shift next s' n))),
   fun _ keeps kept _ _ related n => keeps _ _ (KeepsRelation.run kept related n)⟩

/-- A class merging exactly the configurations with the same course through the map keeps the
values and carries the law. -/
theorem KeepsAndCarries.of_exact {π : S → K}
    (exact : ∀ s s', π s = π s' ↔ SameFuture next o s s') : KeepsAndCarries next o π :=
  ⟨fun s s' same => (exact s s').mp same 0,
   Learning.goAlike_iff_lumped.mpr fun s s' same =>
     (exact (next s) (next s')).mpr (sameFuture_coarsest.2.1 s s' ((exact s s').mp same))⟩

/-- **A class merging exactly the configurations with the same course through the map is coarser
than every class that keeps the values and carries the law**, in every universe. -/
theorem coarser_of_exact {π : S → K} (exact : ∀ s s', π s = π s' ↔ SameFuture next o s s')
    {κ : S → K'} (other : KeepsAndCarries next o κ) : ∀ s s', κ s = κ s' → π s = π s' :=
  fun _ _ same => (exact _ _).mpr (sameFuture_of_law other.1 other.2 same)

/-- **A class keeping the map's values and carrying the law is coarser than every relation that
keeps the values and that the law keeps exactly where it merges exactly the configurations with
the same course through the map.** For such a class four conditions are one: it merges every two
configurations that some relation keeping the values and kept by the law relates; it merges every
two with the same course through the map; it merges exactly those; it makes sense. -/
theorem coarsest_iff {π : S → K} (lawful : KeepsAndCarries next o π) :
    ((∀ E : S → S → Prop, (∀ s s', E s s' → o s = o s') → KeepsRelation next E →
        ∀ s s', E s s' → π s = π s') ↔
      ∀ s s', SameFuture next o s s' → π s = π s') ∧
    ((∀ s s', SameFuture next o s s' → π s = π s') ↔
      ∀ s s', π s = π s' ↔ SameFuture next o s s') ∧
    ((∀ s s', π s = π s' ↔ SameFuture next o s s') ↔ IdentifiesAlike (frameBy next o) π) :=
  ⟨⟨fun every => every (SameFuture next o) sameFuture_coarsest.1 sameFuture_coarsest.2.1,
    fun merges E keeps kept s s' related =>
      merges s s' (sameFuture_coarsest.2.2 E keeps kept s s' related)⟩,
   ⟨fun merges s s' => ⟨fun same => sameFuture_of_law lawful.1 lawful.2 same, merges s s'⟩,
    fun exact s s' => (exact s s').mpr⟩,
   ⟨fun exact s s' => (exact s s').trans alike_iff_sameFuture.symm,
    fun sense s s' => (sense s s').trans alike_iff_sameFuture⟩⟩

/-- **The coarsest class, named.** Where a list holds every configuration, the names, each
configuration's course through the map before `N + N - 1` with `N` the list's length, keep the
values, carry the law and merge exactly the configurations with the same course; and a class that
keeps the values and carries the law is coarser than every class into the names' universe that
does both exactly where it merges exactly the configurations with the same course. -/
theorem coarsest_class {l : List S} (world : ∀ s, s ∈ l) :
    (KeepsAndCarries next o (name next o (l.length + l.length - 1)) ∧
      ∀ s s', name next o (l.length + l.length - 1) s = name next o (l.length + l.length - 1) s' ↔
        SameFuture next o s s') ∧
    ∀ {π : S → K}, KeepsAndCarries next o π →
      ((∀ {K'' : Type v} (κ : S → K''), KeepsAndCarries next o κ →
          ∀ s s', κ s = κ s' → π s = π s') ↔
        ∀ s s', π s = π s' ↔ SameFuture next o s s') :=
  have exact : ∀ s s', name next o (l.length + l.length - 1) s =
      name next o (l.length + l.length - 1) s' ↔ SameFuture next o s s' :=
    fun s s' => (name_identifiesAlike world s s').trans alike_iff_sameFuture
  ⟨⟨KeepsAndCarries.of_exact exact, exact⟩,
   fun lawful =>
    ⟨fun coarser s s' =>
      ⟨fun same => sameFuture_of_law lawful.1 lawful.2 same,
       fun same => coarser _ (KeepsAndCarries.of_exact exact) s s' ((exact s s').mpr same)⟩,
     fun exact' _ _ other => coarser_of_exact exact' other⟩⟩

end Law

end Becoming


namespace Becoming

open Generative

universe u v w

namespace IdentificationRuns

open Learning

/-! ## Moments read through pointwise equal courses -/

section Congr

variable {O : Type u}

theorem sameAhead_congr {o o' : Nat → O} (same : ∀ n, o n = o' n) {t t' : Nat}
    (ahead : SameAhead o t t') : SameAhead o' t t' :=
  fun n => (same (t + n)).symm.trans ((ahead n).trans (same (t' + n)))

theorem statesBelow_congr {o o' : Nat → O} (same : ∀ n, o n = o' n) {N : Nat}
    (bound : StatesBelow o N) : StatesBelow o' N :=
  fun t => match bound t with
    | ⟨i, lt, ahead⟩ => ⟨i, lt, sameAhead_congr same ahead⟩

end Congr

/-! ## Along runs of any process -/

section AnyProcess

variable {S : Type u} {A : Type v} {R : Type w} {P : Process S A}

/-- **A bounded prefix fixes a run's course.** Two runs whose courses through the map have at most
`N` and `N'` states and which are alike through it before `N + N' - 1` are alike at every step. -/
theorem prefix_fixes {reg : S → R} {r r' : Run P} {N N' : Nat}
    (bound : StatesBelow (Parting.course reg r) N) (bound' : StatesBelow (Parting.course reg r') N')
    (agree : ∀ n, n < N + N' - 1 → reg (r.state n) = reg (r'.state n)) :
    ∀ n, reg (r.state n) = reg (r'.state n) :=
  Identification.prefix_fixes bound bound' (prefix_congr agree)

end AnyProcess

/-! ## Runs of free branching: the bounds are exact -/

section Free

variable {O : Type u}

/-- **The prefix before `T` does not fix a run's course.** Given two values, for every `T` two
runs of free branching, one with one state and one with at most `T + 1`, part at `T`. -/
theorem prefix_short {x y : O} (two : x ≠ y) (T : Nat) :
    ∃ q q' : Run (Parting.free O), StatesBelow (Parting.course id q) 1 ∧
      StatesBelow (Parting.course id q') (T + 1) ∧ Parting.PartAt id q q' T :=
  match Identification.prefix_short two T with
  | ⟨o, o', bound, bound', same, differ⟩ =>
    ⟨Parting.freeRun o, Parting.freeRun o', bound, bound',
     Identification.prefix_eq_iff.mp same, differ⟩

/-- **No extrapolation can always propose sooner.** Given two values, no extrapolation that misses
at no step of every run of free branching with at most `M + 2` states proposes at step
`M + M + 2` on each. -/
theorem withBound_earliest {x y : O} (two : x ≠ y) (pred : List O → Option O) (M : Nat) :
    ¬ ∀ q : Run (Parting.free O), StatesBelow (Parting.course id q) (M + 2) →
      Accords pred (Parting.course id q) ∧ ∃ w, pred (prefixOf (Parting.course id q) (M + M + 2)) = some w :=
  fun all => Identification.withBound_earliest two pred M fun o bound => all (Parting.freeRun o) bound

/-- **Being given the bound buys silence, not an earlier rest.** Given two values, no extrapolation
right at step `1` on every run of free branching with one state misses at no step of every
such run with two states. -/
theorem rest_without_bound_missed {x y : O} (two : x ≠ y) (pred : List O → Option O) :
    ¬ ((∀ q : Run (Parting.free O), StatesBelow (Parting.course id q) 1 →
        Parting.RightAt pred id q 1) ∧
      ∀ q : Run (Parting.free O), StatesBelow (Parting.course id q) 2 →
        Accords pred (Parting.course id q)) :=
  fun ⟨right, holds⟩ => Identification.rest_without_bound_missed two pred
    ⟨fun o bound => right (Parting.freeRun o) bound, fun o bound => holds (Parting.freeRun o) bound⟩

/-- **Elimination rests no earlier than a cubic step.** A step from which elimination over the
lasso candidates is right along every run of free branching on two values with
at most `N = 2m + 3` states comes after `(N³ - N) / 4`. -/
theorem byElimination_rest_cubic (m : Nat) {T : Nat}
    (rests : ∀ q : Run (Parting.free Bool), StatesBelow (Parting.course id q) (2 * m + 3) →
      ∀ t, T ≤ t → Parting.RightAt (byElimination lassos) id q t) :
    (2 * m + 3) * ((m + 1) * (m + 2)) < T :=
  Identification.byElimination_rest_cubic m fun o bound t late => rests (Parting.freeRun o) bound t late

/-- **The diagonal world of an extrapolation exceeds the bound it is given.** Where `other`
moves every value, the run of the diagonal law of the extrapolation given the bound `N` has more
than `N` states through the map. -/
theorem answer_exceeds_bound [DecidableEq O] {other : O → O} (moves : ∀ v, other v ≠ v) (x : O)
    (N : Nat) (r : Run (Law.process (answerStep (Identification.withBound N) other x)))
    (start : r.state 0 = []) :
    ¬ StatesBelow (Parting.course (LearningRuns.answerReg (Identification.withBound N) other x) r) N :=
  fun bound => Identification.answer_exceeds_bound moves x N
    (statesBelow_congr (LearningRuns.answer_course _ other x r start) bound)

end Free

/-! ## Along runs of a determined law -/

section Determined

variable {S : Type u} {R : Type w} {next : S → S}

/-- **Two moments of a run of a determined law are one state exactly where their configurations
are alike in the frame by `reg`.** -/
theorem sameAhead_iff_alike (reg : S → R) (r : Run (Law.process next)) {t t' : Nat} :
    SameAhead (Parting.course reg r) t t' ↔
      Alike (Law.frameBy next reg) (Law.frameBy next reg) (r.state t) (r.state t') :=
  have along : ∀ n, Parting.course reg r n = reg (Law.orbit next (r.state 0) n) :=
    fun n => congrArg reg (Branching.law_run_state r n)
  have at_t : ∀ n, reg (Law.orbit next (r.state t) n) =
      reg (Law.orbit next (Law.orbit next (r.state 0) t) n) :=
    fun n => congrArg (fun a => reg (Law.orbit next a n)) (Branching.law_run_state r t)
  have at_t' : ∀ n, reg (Law.orbit next (r.state t') n) =
      reg (Law.orbit next (Law.orbit next (r.state 0) t') n) :=
    fun n => congrArg (fun a => reg (Law.orbit next a n)) (Branching.law_run_state r t')
  ⟨fun same => Law.alike_iff_sameFuture.mpr fun n =>
      (at_t n).trans ((sameAhead_orbit_iff.mp (sameAhead_congr along same) n).trans (at_t' n).symm),
   fun alike => sameAhead_congr (fun n => (along n).symm)
      (sameAhead_orbit_iff.mpr fun n =>
        (at_t n).symm.trans ((Law.alike_iff_sameFuture.mp alike n).trans (at_t' n)))⟩

/-- **A run from a configuration that returns has two moments that are one state**, through
every map. -/
theorem returns_states (r : Run (Law.process next)) (returns : Law.Returns next (r.state 0))
    (reg : S → R) : ∃ i j, i < j ∧ SameAhead (Parting.course reg r) i j :=
  match returns.states reg with
  | ⟨i, j, lt, same⟩ =>
    ⟨i, j, lt, sameAhead_congr (fun n => (congrArg reg (Branching.law_run_state r n)).symm) same⟩

/-- **Moore's bound before its step, refuted by nothing, along runs.** Two runs of a determined
law beginning in a list closed under it, alike through the map for `N - 1` steps, `N` the list's
length: that they are alike through it at a step is refuted by nothing. -/
theorem classes_unrefuted_runs {reg : S → R} {l : List S} (closed : ∀ s, s ∈ l → next s ∈ l)
    {r r' : Run (Law.process next)} (mem : r.state 0 ∈ l) (mem' : r'.state 0 ∈ l)
    (agree : ∀ n, n < l.length - 1 → reg (r.state n) = reg (r'.state n)) (n : Nat) :
    ¬ ¬ reg (r.state n) = reg (r'.state n) :=
  fun differ => Law.sameFuture_classes_unrefuted (o := reg) closed mem mem'
    (fun k early => (congrArg reg (Branching.law_run_state r k)).symm.trans
      ((agree k early).trans (congrArg reg (Branching.law_run_state r' k))))
    n fun same => differ ((congrArg reg (Branching.law_run_state r n)).trans
      (same.trans (congrArg reg (Branching.law_run_state r' n)).symm))

end Determined

/-- **Moore's bound is exact on runs.** Given two values, for every `M` a law on a list of `M + 2`
positions closed under it, and a map, have two runs, from `0` and from `1`, that part at
`M`. -/
theorem classes_exact_runs {R : Type w} {x y : R} (two : x ≠ y) (M : Nat) :
    ∃ (next : Nat → Nat) (reg : Nat → R) (l : List Nat), l.length = M + 2 ∧
      (∀ p, p ∈ l → next p ∈ l) ∧ 0 ∈ l ∧ 1 ∈ l ∧
      Parting.PartAt reg (Law.run next 0) (Law.run next 1) M :=
  match Law.sameFuture_classes_exact two M with
  | ⟨next, reg, l, length, closed, at0, at1, agree, differ⟩ =>
    ⟨next, reg, l, length, closed, at0, at1, agree, differ⟩

/-! ## The run of negation -/

section Negation

theorem negation_course (r : Run (Law.process not)) (start : r.state 0 = true) (n : Nat) :
    Parting.course id r n = Negation.course n :=
  (Branching.law_run_state r n).trans (congrArg (fun s => Law.orbit not s n) start)

/-- **Exactly two states along the run of negation from `true`.** -/
theorem negation_two_states (r : Run (Law.process not)) (start : r.state 0 = true) :
    (¬ SameAhead (Parting.course id r) 0 1) ∧ SameAhead (Parting.course id r) 0 2 ∧
      ∀ t, SameAhead (Parting.course id r) t 0 ∨ SameAhead (Parting.course id r) t 1 :=
  have along := negation_course r start
  have back : ∀ n, Negation.course n = Parting.course id r n := fun n => (along n).symm
  match Negation.two_states with
  | ⟨apart, same, each⟩ =>
    ⟨fun ahead => apart (sameAhead_congr along ahead), sameAhead_congr back same,
     fun t => match each t with
      | .inl first => .inl (sameAhead_congr back first)
      | .inr second => .inr (sameAhead_congr back second)⟩

/-- **Each state of the run of negation is defined through the other.** One takes `true` and
goes into the other, which takes `false` and goes into the first. -/
theorem negation_each_through_other (r : Run (Law.process not)) (start : r.state 0 = true)
    (t : Nat) :
    (SameAhead (Parting.course id r) t 0 →
        r.state t = true ∧ SameAhead (Parting.course id r) (t + 1) 1) ∧
      (SameAhead (Parting.course id r) t 1 →
        r.state t = false ∧ SameAhead (Parting.course id r) (t + 1) 0) :=
  have along := negation_course r start
  have back : ∀ n, Negation.course n = Parting.course id r n := fun n => (along n).symm
  ⟨fun ahead => match (Negation.each_through_other t).1 (sameAhead_congr along ahead) with
    | ⟨value, next⟩ => ⟨(along t).trans value, sameAhead_congr back next⟩,
   fun ahead => match (Negation.each_through_other t).2 (sameAhead_congr along ahead) with
    | ⟨value, next⟩ => ⟨(along t).trans value, sameAhead_congr back next⟩⟩

/-- **The liar's truth is derived along the run.** Along the run of negation from `true`, the
extrapolation given two states is right at every step from `3` on. -/
theorem negation_derived (r : Run (Law.process not)) (start : r.state 0 = true) :
    ∀ t, 3 ≤ t → Parting.RightAt (Identification.withBound 2) id r t :=
  fun t late =>
    (congrArg (Identification.withBound 2)
        (prefix_congr fun n _ => negation_course r start n)).trans
      ((Identification.negation_derived t late).trans
        (congrArg some (negation_course r start t).symm))

end Negation

/-! ## What a description of parts keeps along courses -/

section Separation

variable {A : Type u} {B : Type v}

theorem separated_congr {whole whole' : A × B → Prop} (same : ∀ p, whole p ↔ whole' p)
    {p : A × B} : Separated whole p → Separated whole' p :=
  fun ⟨⟨b, held⟩, ⟨a, held'⟩⟩ => ⟨⟨b, (same _).mp held⟩, ⟨a, (same _).mp held'⟩⟩

end Separation

/-- **After copying, two parts that always go alike, described separately, could go apart.** One
move of the law copying the first part into the second reaches only parts going alike, and the
separate descriptions admit `(true, false)`, which is not reached. -/
theorem copy_separation_admits_extra :
    Separated (Courses.reachedFrom (fun p : Bool × Bool => (p.1, p.1)) (fun _ => True) 1)
        (true, false) ∧
      ¬ Courses.reachedFrom (fun p : Bool × Bool => (p.1, p.1)) (fun _ => True) 1 (true, false) :=
  match separation_admits_extra with
  | ⟨separated, apart⟩ =>
    ⟨separated_congr (fun p => (Courses.copy_relates_course.1 p).symm) separated,
     fun reached => apart ((Courses.copy_relates_course.1 _).mp reached)⟩

/-- The law setting the third part to the parity of the first two. -/
def parity (p : Bool × Bool × Bool) : Bool × Bool × Bool := (p.1, p.2.1, flipIf p.1 p.2.1)

/-- An even triple is left as it is by `parity`. -/
theorem parity_fixed : ∀ p : Bool × Bool × Bool, EvenThree p → parity p = p
  | (true, true, true), odd => nomatch odd
  | (true, true, false), _ => rfl
  | (true, false, true), _ => rfl
  | (true, false, false), odd => nomatch odd
  | (false, true, true), _ => rfl
  | (false, true, false), odd => nomatch odd
  | (false, false, true), odd => nomatch odd
  | (false, false, false), _ => rfl

/-- **One move of `parity` reaches exactly the even triples.** -/
theorem parity_reached_iff (p : Bool × Bool × Bool) :
    Courses.reachedFrom parity (fun _ => True) 1 p ↔ EvenThree p :=
  ⟨fun reached => match Courses.reachedFrom_succ.mp reached with
    | ⟨q, _, moved⟩ => Eq.subst (motive := EvenThree) moved (even_first q.1 q.2.1),
   fun even => Courses.reachedFrom_succ.mpr
    ⟨p, Courses.reachedFrom_zero.mpr trivial, parity_fixed p even⟩⟩

/-- **A relation the reached whole holds and no two parts hold.** After one move of `parity`,
every two of the three parts may be anything in the reached whole, and the three may not. -/
theorem parity_whole_not_in_pairs :
    (∀ x y : Bool, ∃ z, Courses.reachedFrom parity (fun _ => True) 1 (x, y, z)) ∧
      (∀ y z : Bool, ∃ x, Courses.reachedFrom parity (fun _ => True) 1 (x, y, z)) ∧
      (∀ x z : Bool, ∃ y, Courses.reachedFrom parity (fun _ => True) 1 (x, y, z)) ∧
      ¬ Courses.reachedFrom parity (fun _ => True) 1 (true, false, false) :=
  match whole_not_in_pairs with
  | ⟨first, second, third, odd⟩ =>
    ⟨fun x y => match first x y with
      | ⟨z, even⟩ => ⟨z, (parity_reached_iff _).mpr even⟩,
     fun y z => match second y z with
      | ⟨x, even⟩ => ⟨x, (parity_reached_iff _).mpr even⟩,
     fun x z => match third x z with
      | ⟨y, even⟩ => ⟨y, (parity_reached_iff _).mpr even⟩,
     fun reached => odd ((parity_reached_iff _).mp reached)⟩

end IdentificationRuns

end Becoming

/-! ## The course of what couples into a formation -/

namespace Becoming

open Generative

universe u

namespace IdentificationRuns

variable {O : Type u}

/-- **Two courses whose joint course has at most `P` states are fixed by their agreement before
`P`.** Each step is one state of the joint course with a step before `P`, where the two agree. -/
theorem joint_agree {o o' : Nat → O} {P : Nat} (bound : StatesBelow (fun n => (o n, o' n)) P)
    (agree : ∀ n, n < P → o n = o' n) : ∀ n, o n = o' n :=
  fun n => match bound n with
    | ⟨i, lt, same⟩ =>
      have pair : (o n, o' n) = (o i, o' i) := same 0
      (Prod.mk.inj pair).1.trans ((agree i lt).trans (Prod.mk.inj pair).2.symm)

end IdentificationRuns

namespace Web

variable {F C : Type} {O : Type u}

/-- `value` gives the values of what couples into `g`: at each step, two levels take one value
exactly where they admit `g` alike and the conditions coupled into `g` by level stand alike. -/
def ValuesThrough (W : Web F C) (obs : F → C → Prop) (g : F) (value : Nat → (C → Nat) → O) :
    Prop :=
  ∀ t x y, value t x = value t y ↔ (W.Admits x t g ↔ W.Admits y t g) ∧ ∀ c, obs g c → x c = y c

/-- A formation's own course under a level history, read by `value`: the value, at each step, of
what couples into it then. -/
def courseThrough (value : Nat → (C → Nat) → O) (l : Nat → C → Nat) : Nat → O :=
  fun t => value t (l t)

variable {W : Web F C} {obs : F → C → Prop} {g : F} {value : Nat → (C → Nat) → O}
  {l l' : Nat → C → Nat}

/-- **Where admission at `g` is decided and the conditions coupled into `g` by level are listed,
they give the values of what couples into `g`**: whether the levels admit `g`, and the listed
levels. -/
theorem listed_values {admits : Nat → (C → Nat) → Bool}
    (decides : ∀ t x, admits t x = true ↔ W.Admits x t g) {cs : List C}
    (listed : ∀ c, obs g c ↔ c ∈ cs) :
    W.ValuesThrough obs g (fun t x => (admits t x, cs.map x)) :=
  fun t x y =>
    ⟨fun same =>
      match Prod.mk.inj same with
      | ⟨admitted, levels⟩ =>
        ⟨(decides t x).symm.trans
          ((Eq.subst (motive := fun b => admits t x = true ↔ b = true) admitted Iff.rfl).trans
            (decides t y)),
         fun c observed => map_eq_at levels ((listed c).mp observed)⟩,
     fun ⟨admitted, levels⟩ =>
      (congrArg (Prod.mk · (cs.map x))
          (bool_eq_of_iff ((decides t x).trans (admitted.trans (decides t y).symm)))).trans
        (congrArg (Prod.mk (admits t y))
          (map_eq_on fun c mem => levels c ((listed c).mpr mem)))⟩

/-- **Alike through a formation's couplings at a step is one value of its own course there.** -/
theorem alikeThrough_iff (values : W.ValuesThrough obs g value) {t : Nat} :
    W.AlikeThrough obs g l l' t ↔ courseThrough value l t = courseThrough value l' t :=
  (values t (l t) (l' t)).symm

/-- **Alike through a formation's couplings up to a step is one prefix of its own course**: its
own courses under the two histories agree before the next step. -/
theorem alikeThroughUpTo_iff_prefix (values : W.ValuesThrough obs g value) {t : Nat} :
    W.AlikeThroughUpTo obs g l l' t ↔
      Learning.prefixOf (courseThrough value l) (t + 1) =
        Learning.prefixOf (courseThrough value l') (t + 1) :=
  Iff.trans
    ⟨fun alike n lt => (alikeThrough_iff values).mp (alike n (Nat.le_of_lt_succ lt)),
     fun agree s le => (alikeThrough_iff values).mpr (agree s (Nat.lt_succ_of_le le))⟩
    Identification.prefix_eq_iff.symm

/-- **A selection through a formation's couplings selects by the prefix of its own course.** A
selection is through `g`'s couplings up to `t` exactly where it selects each history by the
prefix of `g`'s own course before `t + 1`. -/
theorem selectsThrough_iff_prefix (values : W.ValuesThrough obs g value) {t : Nat}
    {select : (Nat → C → Nat) → Prop} :
    W.SelectsThrough obs g t select ↔
      ∃ choose : List O → Prop,
        ∀ l, select l ↔ choose (Learning.prefixOf (courseThrough value l) (t + 1)) :=
  ⟨fun through =>
    ⟨fun p => ∃ l, Learning.prefixOf (courseThrough value l) (t + 1) = p ∧ select l,
     fun l => ⟨fun chosen => ⟨l, rfl, chosen⟩,
      fun ⟨l', same, chosen⟩ =>
        (through l' l ((alikeThroughUpTo_iff_prefix values).mpr same)).mp chosen⟩⟩,
   fun ⟨choose, by_prefix⟩ l l' alike =>
    have same := (alikeThroughUpTo_iff_prefix values).mp alike
    (by_prefix l).trans
      ((Eq.subst (motive := fun p =>
          choose (Learning.prefixOf (courseThrough value l) (t + 1)) ↔ choose p) same Iff.rfl).trans
        (by_prefix l').symm)⟩

/-- **Two histories are selected alike by every selection through a formation's couplings up to
`t` exactly where its own courses under them share their prefix before `t + 1`.** -/
theorem selects_alike_iff_prefix (values : W.ValuesThrough obs g value) {t : Nat} :
    (∀ select, W.SelectsThrough obs g t select → (select l ↔ select l')) ↔
      Learning.prefixOf (courseThrough value l) (t + 1) =
        Learning.prefixOf (courseThrough value l') (t + 1) :=
  selects_alike_iff.trans (alikeThroughUpTo_iff_prefix values)

/-- **Along own courses with at most `N` and `N'` states, what a formation ever tells apart it
tells apart within `N + N' - 1` steps.** Where its own courses under two histories have at most
`N` and `N'` states and the histories are alike through its couplings at every step before
`N + N' - 1`, they are alike through them up to every step. -/
theorem alike_of_bounded (values : W.ValuesThrough obs g value) {N N' : Nat}
    (bound : StatesBelow (courseThrough value l) N)
    (bound' : StatesBelow (courseThrough value l') N')
    (alike : ∀ s, s < N + N' - 1 → W.AlikeThrough obs g l l' s) :
    ∀ t, W.AlikeThroughUpTo obs g l l' t :=
  have every := Identification.bounded_agree bound bound' fun n lt =>
    (alikeThrough_iff values).mp (alike n lt)
  fun _ s _ => (alikeThrough_iff values).mpr (every s)

/-- So every selection through its couplings, at every step, selects the two alike. -/
theorem selects_alike_of_bounded (values : W.ValuesThrough obs g value) {N N' : Nat}
    (bound : StatesBelow (courseThrough value l) N)
    (bound' : StatesBelow (courseThrough value l') N')
    (alike : ∀ s, s < N + N' - 1 → W.AlikeThrough obs g l l' s) {t : Nat}
    {select : (Nat → C → Nat) → Prop} (through : W.SelectsThrough obs g t select) :
    select l ↔ select l' :=
  through l l' (alike_of_bounded values bound bound' alike t)

/-- **Read together, `P` states are enough.** Where its own courses under two histories, read
together step by step, have at most `P` states and the histories are alike through its couplings
at every step before `P`, they are alike through them up to every step. -/
theorem alike_of_joint_bounded (values : W.ValuesThrough obs g value) {P : Nat}
    (bound : StatesBelow (fun n => (courseThrough value l n, courseThrough value l' n)) P)
    (alike : ∀ s, s < P → W.AlikeThrough obs g l l' s) :
    ∀ t, W.AlikeThroughUpTo obs g l l' t :=
  have every := IdentificationRuns.joint_agree bound fun n lt =>
    (alikeThrough_iff values).mp (alike n lt)
  fun _ s _ => (alikeThrough_iff values).mpr (every s)

/-- One formation and one condition, which the formation requires nothing of. -/
def oneCondition : Web Unit Unit :=
  ⟨fun _ _ => 0, fun _ _ => True, fun _ _ _ => False, fun _ _ _ => 0, fun _ _ _ => False⟩

/-- In `oneCondition`, with the condition coupled into the formation by level, its level gives
the values of what couples in. -/
theorem oneCondition_values :
    oneCondition.ValuesThrough (fun _ _ => True) () (fun _ x => x ()) :=
  fun _ _ _ =>
    ⟨fun same => ⟨⟨fun _ _ never => (nomatch never), fun _ _ never => (nomatch never)⟩,
       fun c _ => match c with | () => same⟩,
     fun ⟨_, levels⟩ => levels () trivial⟩

/-- **The bound is attained.** In the web of one condition, read by its level, for every `M` and
`M'` there are two histories whose own courses have at most `M + 1` and `M' + 1` states, alike
through the couplings at every step before `M + M'` and apart at `M + M'`, the step before
`(M + 1) + (M' + 1) - 1`. -/
theorem bounded_exact (M M' : Nat) :
    oneCondition.ValuesThrough (fun _ _ => True) () (fun _ x => x ()) ∧
      ∃ l l' : Nat → Unit → Nat,
        StatesBelow (courseThrough (fun _ x => x ()) l) (M + 1) ∧
        StatesBelow (courseThrough (fun _ x => x ()) l') (M' + 1) ∧
        (∀ s, s < M + M' → oneCondition.AlikeThrough (fun _ _ => True) () l l' s) ∧
        ¬ oneCondition.AlikeThrough (fun _ _ => True) () l l' (M + M') :=
  ⟨oneCondition_values,
   match Identification.bounded_agree_exact (O := Nat) (x := 0) (y := 1) (fun h => nomatch h) M M'
   with
   | ⟨o, o', bound, bound', same, apart⟩ =>
     ⟨fun t _ => o t, fun t _ => o' t, bound, bound',
      fun s lt =>
        (alikeThrough_iff oneCondition_values).mpr (Identification.prefix_eq_iff.mp same s lt),
      fun alike => apart ((alikeThrough_iff oneCondition_values).mp alike)⟩⟩

/-- **The states of an own course belong to the reading.** In the web of one condition, the level
with the step also gives the values of what couples in; the own course of a history holding the
level at zero has one state read by the level, and more than every bound read with the step. -/
theorem states_by_reading :
    oneCondition.ValuesThrough (fun _ _ => True) () (fun t x => (t, x ())) ∧
      StatesBelow (courseThrough (fun _ x => x ()) (fun _ _ => 0)) 1 ∧
      ∀ N, ¬ StatesBelow (courseThrough (fun t x => (t, x ())) (fun _ _ => 0)) N :=
  ⟨fun _ _ _ =>
    ⟨fun same => ⟨⟨fun _ _ never => (nomatch never), fun _ _ never => (nomatch never)⟩,
       fun c _ => match c with | () => (Prod.mk.inj same).2⟩,
     fun ⟨_, levels⟩ => congrArg (Prod.mk _) (levels () trivial)⟩,
   fun _ => ⟨0, Nat.zero_lt_one, fun _ => rfl⟩,
   fun N bound => match bound N with
     | ⟨i, lt, same⟩ =>
       have at_start : ((N + 0, 0) : Nat × Nat) = (i + 0, 0) := same 0
       Nat.lt_irrefl N (Eq.subst (motive := fun k => k < N) (Prod.mk.inj at_start).1.symm lt)⟩

end Web

end Becoming
