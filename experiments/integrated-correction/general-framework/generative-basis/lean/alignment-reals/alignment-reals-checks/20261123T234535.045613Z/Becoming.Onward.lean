import Becoming.Horizon
import Becoming.Parting

/-!
# Onward: where a run goes on

`Becoming.Branching` states laws along runs: merging nothing within finitely many
configurations, a run comes back and the configuration it starts from returns; nothing rises
along it; a configuration that never returns needs openness. Each takes the run as given.
Building a run from a configuration that can move takes a continuation at every step, and taking
one at every step is a selection the core does not assume. This module states where a run goes on
with nothing selected, and what a run takes where nothing else gives one.

* **Within finitely many configurations, a run is a course into a return.** Where a list holds
  every configuration, a course as long as the list repeats a configuration, which returns
  (`returning_of_continues`). From where a course leads to a configuration that returns, a run
  starts: round the return, preceded by the course (`run_of_returning`, `run_of_reach`). So a run
  starts at a configuration exactly where a course as long as the list does
  (`run_iff_continues`), exactly where courses of every length do (`run_iff_unbounded`), and
  exactly where a course leads to a return (`run_iff_returning`). No decision and no selection
  is used. Where the successors are also listed, whether a run starts is decided
  (`run_decided`). Where branching is infinite, courses of every length do not give a run
  (`fan_no_run`).
* **A family that keeps moving.** A family keeps moving where from each member some step leads
  to a member (`KeepsMoving`); the steps within it form a process (`within`). Within finitely
  many configurations, a run starts at each member and stays in the family
  (`KeepsMoving.run`).
* **The laws along runs, with no run given.** Merging nothing within finitely many
  configurations, a configuration returns exactly where a course as long as the list starts from
  it (`lossless_returns_iff`), so each member of a family that keeps moving returns
  (`KeepsMoving.returns`); a quantity that never falls across a step within the family keeps its
  value across each such step (`lossless_no_rise`), so a rise within it needs a merge
  (`rise_needs_merge`); and a configuration with courses of every length that never returns
  needs openness (`lossless_unlisted`). These are `Branching`'s laws along runs
  (`Lossless.returns`, `Lossless.no_rise`, `rise_not_lossless`, `Lossless.unlisted`) stated for
  every configuration from which the process can keep moving.
* **Searched moves.** Where a test recognizes, among enumerated moves, a step that stays in the
  family wherever there is one (`Finds`), a run is built as data, with no selection: the test is
  searched until it passes (`search`, through accessibility, `searchFrom`), each step is taken
  that way (`searchedStep`), and the run starts at the member and stays in the family
  (`searchedRun`, `searchedRun_start`, `searchedRun_within`). Where the steps and the family
  are decided and the steps' moves are enumerated, testing each enumerated move is such a test
  (`decidedTest`, `decidedTest_finds`).
* **What a run takes in general.** A run from every member of every family that keeps moving,
  asked of every process, is exactly the principle that a total relation has a sequence along it
  from every start (`DependentChoice`; standard name: dependent choice) (`runs_iff_dependentChoice`).

**Readings (the AI's, D43).**
- Within finitely many configurations, whatever goes on without end does so by coming round: the
  course itself shows where it returns, and the run goes round there. Nothing is selected and
  nothing decided; going on is read off the unfolding.
- Where the configurations are not bounded, going on without end is given where the moves can be
  searched; asked of every process, that every configuration that can keep moving starts a run
  is exactly dependent choice.

What is not derived: whether the core gives `DependentChoice` (a statement about the theory,
needing a model outside it); runs along unbounded configurations where the branching is finite
and nothing is searched, given in `Becoming.Lasting` through `EitherThroughout` and a selection
(`Lasting.lifting`); the laws along runs where nothing lists the configurations. No ethical
predicate, ranking or axiom occurs.

**Classical sources.** Within finitely many configurations a run is a lasso: a course into a
cycle, found by the pigeonhole principle (`revisits_within` of `Becoming.Recurrence`). The fan
(`fan_no_run`) is the failure of König's lemma (König 1927) without finite branching: courses of
every length give no infinite path. König's lemma itself, for finite branching over unbounded
configurations, is not stated here; it is not constructive in general, and weak König's lemma is
equivalent to `LLPO` (Ishihara 1990; Bridges and Richman 1987), the principle `EitherThroughout`
that `Becoming.Lasting` uses for lifting (`eitherThroughout_iff_llpoForDecided`). `DependentChoice` is the axiom of dependent choice (Bernays 1942), and
`runs_iff_dependentChoice` states it as exactly what runs from every family that keeps moving take, at
`Type 0`.
-/

namespace Becoming

open Generative

universe u v

namespace Onward

variable {S : Type u} {A : Type v} {P : Process S A}

/-! ## Runs from courses -/

/-- From each configuration of a run, courses of every length start. -/
theorem continues_of_run (r : Run P) : ∀ (n i : Nat), Lasting.Continues P n (r.state i)
  | 0, _ => trivial
  | n + 1, i => ⟨r.act i, r.state (i + 1), r.step i, continues_of_run r n (i + 1)⟩

theorem unbounded_of_run (r : Run P) : Lasting.Unbounded P (r.state 0) :=
  fun n => continues_of_run r n 0

/-- Every configuration of a run can be had from its start. -/
theorem reach_of_run (r : Run P) (n : Nat) : Reach P (r.state 0) (r.state n) :=
  Eq.subst (motive := fun m => Reach P (r.state 0) (r.state m)) (Nat.zero_add n) (r.reach 0 n)

/-- **A run from where a course leads**: the course, then the run. -/
theorem run_of_trace : ∀ {s t : S} {as : List A}, Trace P s as t →
    (∃ r : Run P, r.state 0 = t) → ∃ r : Run P, r.state 0 = s
  | _, _, _, .nil _, found => found
  | _, _, _, .cons step rest, found =>
    match run_of_trace rest found with
    | ⟨r, start⟩ =>
      ⟨Run.cons _ _ r (Eq.subst (motive := fun z => P.step _ _ z) start.symm step), rfl⟩

theorem run_of_reach {s t : S} (reach : Reach P s t) (found : ∃ r : Run P, r.state 0 = t) :
    ∃ r : Run P, r.state 0 = s :=
  match reach with
  | ⟨_, path⟩ => run_of_trace path found

/-- **A run from where a course leads to a return**: round the return, preceded by the course.
No selection. -/
theorem run_of_returning {s t : S} (reach : Reach P s t) (returns : Branching.Returns P t) :
    ∃ r : Run P, r.state 0 = s :=
  run_of_reach reach (match returns.run with
    | ⟨r, start, _⟩ => ⟨r, start⟩)

/-- Along a course by position, each position leads to every later one. -/
theorem reach_along {g : Nat → S} {L : Nat}
    (steps : ∀ k, k < L → ∃ a, P.step (g k) a (g (k + 1))) :
    ∀ d i, i + d ≤ L → Reach P (g i) (g (i + d)) :=
  fun d i le => reach_iff_withinClosure.mpr
    («线则所闭» (R := Steps P) (g := fun k => g (i + k)) (N := d)
      (fun k lt => Eq.subst (motive := fun m => Steps P (g (i + k)) (g m)) (Nat.add_assoc i k 1)
        (steps (i + k) (Nat.lt_of_lt_of_le (Nat.add_lt_add_left lt i) le)))
      d (Nat.le_refl d))

/-- **Within finitely many configurations, a course as long as the list leads to a return.** The
course repeats a configuration, and the repeated configuration returns. No decidability. -/
theorem returning_of_continues {all : List S} (every : ∀ x, x ∈ all) {s : S}
    (continues : Lasting.Continues P all.length s) :
    ∃ t, Reach P s t ∧ Branching.Returns P t :=
  match Parting.path_of_continues all.length s continues with
  | ⟨g, start, steps⟩ =>
    match «线有限则入返» (R := Steps P) (l := all) (g := g) steps (fun n _ => every (g n)) with
    | ⟨i, _, within, loop⟩ =>
      ⟨g i, Eq.subst (motive := fun x => Reach P x (g i)) start (reach_iff_withinClosure.mpr within),
        Branching.returns_iff_reaches.mpr loop⟩

/-- **Within finitely many configurations, a course as long as the list gives a run.** No
decidability and no selection. -/
theorem run_of_continues {all : List S} (every : ∀ x, x ∈ all) {s : S}
    (continues : Lasting.Continues P all.length s) : ∃ r : Run P, r.state 0 = s :=
  match returning_of_continues every continues with
  | ⟨_, reach, returns⟩ => run_of_returning reach returns

/-- **Within finitely many configurations, a run starts exactly where a course as long as the
list does.** -/
theorem run_iff_continues {all : List S} (every : ∀ x, x ∈ all) {s : S} :
    (∃ r : Run P, r.state 0 = s) ↔ Lasting.Continues P all.length s :=
  ⟨fun ⟨r, start⟩ =>
    Eq.subst (motive := Lasting.Continues P all.length) start (continues_of_run r all.length 0),
   run_of_continues every⟩

/-- **Within finitely many configurations, a run starts exactly where courses of every length
do.** -/
theorem run_iff_unbounded {all : List S} (every : ∀ x, x ∈ all) {s : S} :
    (∃ r : Run P, r.state 0 = s) ↔ Lasting.Unbounded P s :=
  ⟨fun ⟨r, start⟩ => Eq.subst (motive := Lasting.Unbounded P) start (unbounded_of_run r),
   fun unbounded => run_of_continues every (unbounded all.length)⟩

/-- **Within finitely many configurations, a run starts exactly where a course leads to a
return.** -/
theorem run_iff_returning {all : List S} (every : ∀ x, x ∈ all) {s : S} :
    (∃ r : Run P, r.state 0 = s) ↔ ∃ t, Reach P s t ∧ Branching.Returns P t :=
  ⟨fun ⟨r, start⟩ => returning_of_continues every
    (Eq.subst (motive := Lasting.Continues P all.length) start (continues_of_run r all.length 0)),
   fun ⟨_, reach, returns⟩ => run_of_returning reach returns⟩

/-- **Within finitely many configurations whose successors are listed, whether a run starts is
decided.** -/
theorem run_decided {all : List S} (every : ∀ x, x ∈ all) (branching : Lasting.FinitelyBranching P)
    (s : S) : Decided (∃ r : Run P, r.state 0 = s) :=
  match Lasting.Continues.decided branching all.length s with
  | .inl continues => .inl (run_of_continues every continues)
  | .inr never => .inr fun found => never ((run_iff_continues every).mp found)

/-- **Where branching is infinite, courses of every length do not give a run**: the root of
`Lasting.Fan` has courses of every length and no run. This is the failure of König's lemma
(König 1927) without finite branching. -/
theorem fan_no_run : ¬ ∃ r : Run Lasting.Fan.process, r.state 0 = .root :=
  fun ⟨r, start⟩ => Lasting.Fan.no_unbounded_step
    ⟨r.state 1,
     ⟨r.act 0, Eq.subst (motive := fun x => Lasting.Fan.process.step x (r.act 0) (r.state 1))
       start (r.step 0)⟩,
     fun n => continues_of_run r n 1⟩

/-! ## A family that keeps moving -/

/-- A family keeps moving: from each member some step leads to a member. -/
def KeepsMoving (P : Process S A) (K : S → Prop) : Prop :=
  ∀ s, K s → ∃ a t, P.step s a t ∧ K t

/-- The steps within a family. -/
def within (P : Process S A) (K : S → Prop) : Process S A :=
  ⟨fun s a t => P.step s a t ∧ K s ∧ K t⟩

/-- A run of the steps within a family is a run of the process. -/
def ofWithin {K : S → Prop} (r : Run (within P K)) : Run P :=
  ⟨r.state, r.act, fun n => (r.step n).1⟩

theorem ofWithin_within {K : S → Prop} (r : Run (within P K)) (n : Nat) :
    K ((ofWithin r).state n) :=
  (r.step n).2.1

/-- From a member of a family that keeps moving, courses of every length stay in the family. -/
theorem KeepsMoving.continues {K : S → Prop} (moving : KeepsMoving P K) :
    ∀ (n : Nat) (s : S), K s → Lasting.Continues (within P K) n s
  | 0, _, _ => trivial
  | n + 1, s, held =>
    match moving s held with
    | ⟨a, t, step, kept⟩ => ⟨a, t, ⟨step, held, kept⟩, KeepsMoving.continues moving n t kept⟩

/-- **Within finitely many configurations, a run starts at each member of a family that keeps
moving and stays in the family.** No decidability and no selection. -/
theorem KeepsMoving.run {all : List S} (every : ∀ x, x ∈ all) {K : S → Prop}
    (moving : KeepsMoving P K) {s : S} (held : K s) :
    ∃ r : Run P, r.state 0 = s ∧ ∀ n, K (r.state n) :=
  match run_of_continues (P := within P K) every (moving.continues all.length s held) with
  | ⟨r, start⟩ => ⟨ofWithin r, start, ofWithin_within r⟩

/-! ## The laws along runs, with no run given -/

/-- **Merging nothing within finitely many configurations, a configuration returns exactly
where a course as long as the list starts from it.** `Branching.Lossless.returns`, with no run
given. -/
theorem lossless_returns_iff (lossless : Branching.Lossless P) {all : List S}
    (every : ∀ x, x ∈ all) {s : S} :
    Branching.Returns P s ↔ Lasting.Continues P all.length s :=
  ⟨fun returns =>
    match returns.run with
    | ⟨r, start, _⟩ =>
      Eq.subst (motive := Lasting.Continues P all.length) start (continues_of_run r all.length 0),
   fun continues =>
    match run_of_continues every continues with
    | ⟨r, start⟩ => Eq.subst (motive := Branching.Returns P) start (lossless.returns every r)⟩

/-- **Merging nothing within finitely many configurations, each member of a family that keeps
moving returns.** -/
theorem KeepsMoving.returns (lossless : Branching.Lossless P) {all : List S}
    (every : ∀ x, x ∈ all) {K : S → Prop} (moving : KeepsMoving P K) {s : S} (held : K s) :
    Branching.Returns P s :=
  match moving.run every held with
  | ⟨r, start, _⟩ => Eq.subst (motive := Branching.Returns P) start (lossless.returns every r)

/-- **Merging nothing within finitely many configurations, nothing rises within a family that
keeps moving.** A quantity that never falls across a step within the family keeps its value
across each such step. `Branching.Lossless.no_rise`, with no run given. -/
theorem lossless_no_rise (lossless : Branching.Lossless P) {all : List S} (every : ∀ x, x ∈ all)
    {K : S → Prop} (moving : KeepsMoving P K) {q : S → Nat}
    (never_falls : ∀ x a y, K x → K y → P.step x a y → q x ≤ q y) {x y : S} {a : A}
    (hx : K x) (hy : K y) (step : P.step x a y) : q y = q x :=
  match moving.run every hy with
  | ⟨r, start, kept⟩ =>
    have into : P.step x a (r.state 0) :=
      Eq.subst (motive := fun z => P.step x a z) start.symm step
    have kept' : ∀ n, K ((Run.cons x a r into).state n) := fun n =>
      match n with
      | 0 => hx
      | n + 1 => kept n
    Eq.subst (motive := fun z => q z = q x) start
      (lossless.no_rise (Run.cons x a r into) (fun _ => every _)
        (fun n => never_falls _ _ _ (kept' n) (kept' (n + 1)) ((Run.cons x a r into).step n)) 0)

/-- **Within finitely many configurations, a rise within a family that keeps moving needs a
merge.** -/
theorem rise_needs_merge {all : List S} (every : ∀ x, x ∈ all) {K : S → Prop}
    (moving : KeepsMoving P K) {q : S → Nat}
    (never_falls : ∀ x a y, K x → K y → P.step x a y → q x ≤ q y) {x y : S} {a : A}
    (hx : K x) (hy : K y) (step : P.step x a y) (rises : q x < q y) : ¬ Branching.Lossless P :=
  fun lossless =>
    Nat.ne_of_lt rises (lossless_no_rise lossless every moving never_falls hx hy step).symm

/-- **Merging nothing, a configuration with courses of every length that never returns needs
openness.** `Branching.Lossless.unlisted`, with no run given. -/
theorem lossless_unlisted (lossless : Branching.Lossless P) {s : S}
    (unbounded : Lasting.Unbounded P s) (never : ¬ Branching.Returns P s) :
    ¬ ∃ all : List S, ∀ x, x ∈ all :=
  fun ⟨_, every⟩ => never ((lossless_returns_iff lossless every).mpr (unbounded _))

/-! ## Searched moves -/

/-- One place after another where a test has failed. -/
def Later (p : Nat → Bool) (m n : Nat) : Prop := m = n + 1 ∧ p n = false

/-- From where the search is accessible, the first place on that passes. -/
def searchFrom (p : Nat → Bool) {start : Nat} (acc : Acc (Later p) start) :
    {k : Nat // p k = true} :=
  Acc.rec (motive := fun _ _ => {k : Nat // p k = true})
    (fun n _ next =>
      match passes : p n with
      | true => ⟨n, passes⟩
      | false => next (n + 1) ⟨rfl, passes⟩) acc

/-- Below a place that passes, the search is accessible. -/
theorem acc_below (p : Nat → Bool) {k : Nat} (passes : p k = true) :
    ∀ d n, n + d = k → Acc (Later p) n
  | 0, _, same => Acc.intro _ fun _ later =>
      Bool.noConfusion (passes.symm.trans ((congrArg p same).symm.trans later.2))
  | d + 1, n, same => Acc.intro n fun _ later =>
      Eq.subst (motive := fun x => Acc (Later p) x) later.1.symm
        (acc_below p passes d (n + 1) ((Nat.succ_add n d).trans same))

/-- **A place that passes, found by search**, where some place passes. -/
def search (p : Nat → Bool) (found : ∃ k, p k = true) : {k : Nat // p k = true} :=
  searchFrom p (match found with
    | ⟨k, passes⟩ => acc_below p passes k 0 (Nat.zero_add k))

/-- A test recognizes, among enumerated moves, a step that stays in the family: what passes is
such a step, and where there is such a step, some enumerated move passes. -/
def Finds (P : Process S A) (K : S → Prop) (e : Nat → A × S) (test : S → Nat → Bool) : Prop :=
  (∀ s n, test s n = true → P.step s (e n).1 (e n).2 ∧ K (e n).2) ∧
    ∀ s a t, P.step s a t → K t → ∃ n, test s n = true

section Searched

variable {K : S → Prop} {e : Nat → A × S} {test : S → Nat → Bool}

/-- A step that stays in the family, found by searching the test. -/
def searchedStep (finds : Finds P K e test) (moving : KeepsMoving P K) (s : S) (held : K s) :
    {p : A × S // P.step s p.1 p.2 ∧ K p.2} :=
  match search (test s) (match moving s held with
      | ⟨a, t, step, kept⟩ => finds.2 s a t step kept) with
  | ⟨k, passes⟩ => ⟨e k, finds.1 s k passes⟩

/-- **A run built by search**, each step found by the test. -/
def searchedRun (finds : Finds P K e test) (moving : KeepsMoving P K) (s : S) (held : K s) :
    Run P :=
  Lasting.runOf (searchedStep finds moving) s held

theorem searchedRun_start (finds : Finds P K e test) (moving : KeepsMoving P K) (s : S)
    (held : K s) : (searchedRun finds moving s held).state 0 = s :=
  rfl

theorem searchedRun_within (finds : Finds P K e test) (moving : KeepsMoving P K) (s : S)
    (held : K s) (n : Nat) : K ((searchedRun finds moving s held).state n) :=
  Lasting.runOf_within _ s held n

end Searched

/-- Testing each enumerated move, where steps and the family are decided. -/
def decidedTest (P : Process S A) (K : S → Prop) [∀ s a t, Decidable (P.step s a t)]
    [∀ s, Decidable (K s)] (e : Nat → A × S) : S → Nat → Bool :=
  fun s n => decide (P.step s (e n).1 (e n).2) && decide (K (e n).2)

/-- **Where steps and the family are decided and the steps' moves are enumerated, testing each
enumerated move recognizes a step that stays in the family.** -/
theorem decidedTest_finds {K : S → Prop} [∀ s a t, Decidable (P.step s a t)]
    [∀ s, Decidable (K s)] {e : Nat → A × S}
    (enumerated : ∀ s a t, P.step s a t → ∃ n, e n = (a, t)) :
    Finds P K e (decidedTest P K e) :=
  ⟨fun _ _ passes =>
    ⟨of_decide_eq_true (bool_of_and_true passes).1, of_decide_eq_true (bool_of_and_true passes).2⟩,
   fun s a t step kept =>
    match enumerated s a t step with
    | ⟨n, same⟩ =>
      ⟨n, (Eq.subst
        (motive := fun p : A × S => (decide (P.step s p.1 p.2) && decide (K p.2)) = true)
        same.symm (bool_and_true (decide_eq_true step) (decide_eq_true kept)) :
          decidedTest P K e s n = true)⟩⟩

/-! ## What a run takes in general -/

/-- A total relation has a sequence along it from every start (standard name: dependent
choice). -/
def DependentChoice : Prop :=
  ∀ (α : Type) (R : α → α → Prop), (∀ x, ∃ y, R x y) →
    ∀ x, ∃ f : Nat → α, f 0 = x ∧ ∀ n, R (f n) (f (n + 1))

/-- The move recorded with a configuration, where one is. -/
def moveOf {B : Type} : (o : Option B) → (∃ b, o = some b) → B
  | some b, _ => b
  | none, found => False.elim (match found with | ⟨_, same⟩ => nomatch same)

theorem moveOf_eq {B : Type} : ∀ {o : Option B} (found : ∃ b, o = some b) {b : B},
    o = some b → moveOf o found = b
  | some c, _, _, same => (Option.some.inj same : c = _)
  | none, _, _, same => nomatch same

/-- **A run from every member of every family that keeps moving, asked of every process, is
exactly `DependentChoice`.** -/
theorem runs_iff_dependentChoice :
    (∀ (S A : Type) (P : Process S A) (K : S → Prop), KeepsMoving P K →
      ∀ s, K s → ∃ r : Run P, r.state 0 = s ∧ ∀ n, K (r.state n)) ↔ DependentChoice :=
  ⟨fun runs α R total x =>
    match runs α Unit ⟨fun y _ z => R y z⟩ (fun _ => True)
        (fun y _ => match total y with
          | ⟨z, related⟩ => ⟨(), z, related, trivial⟩) x trivial with
    | ⟨r, start, _⟩ => ⟨r.state, start, r.step⟩,
   fun selection S A P K moving s held =>
    match selection (Option A × {x : S // K x})
        (fun p q => ∃ a, q.1 = some a ∧ P.step p.2.1 a q.2.1)
        (fun p => match moving p.2.1 p.2.2 with
          | ⟨a, t, step, kept⟩ => ⟨(some a, ⟨t, kept⟩), a, rfl, step⟩)
        (none, ⟨s, held⟩) with
    | ⟨f, start, along⟩ =>
      ⟨⟨fun n => (f n).2.1,
        fun n => moveOf (f (n + 1)).1 (match along n with | ⟨a, same, _⟩ => ⟨a, same⟩),
        fun n => match along n with
          | ⟨_, same, step⟩ =>
            Eq.subst (motive := fun b => P.step (f n).2.1 b (f (n + 1)).2.1)
              (moveOf_eq _ same).symm step⟩,
       congrArg (fun p => p.2.1) start,
       fun n => (f n).2.2⟩⟩

end Onward

end Becoming
