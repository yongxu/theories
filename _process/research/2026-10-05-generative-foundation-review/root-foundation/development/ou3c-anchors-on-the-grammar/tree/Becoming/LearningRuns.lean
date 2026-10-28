import Becoming.LearnableRuns
import Becoming.Parting

/-!
# Learning along runs: what a run's prefix fixes and what an extrapolation along it does

`Becoming.Learning` states, of any course of values, what a prefix fixes, what extrapolation by
elimination does on it, what the diagonal course of an extrapolation is, and what training
through data selects; `Becoming.Learnable` states what an extrapolation through a map learns
along a determined law's orbit. A course read along a run of any process is its course through a
map (`Parting.course`), every course is the course of a run of free branching through the
identity (`Parting.freeRun`), and every run of a determined law is its orbit
(`Branching.law_run_state`, `LearnableRuns`). This module states those laws of runs.

* **No prefix fixes the next value.** At a step where two runs of any process part (alike
  through the map before it and apart at it, `Parting.PartAt`), a value proposed from the prefix,
  the values decided, misses on one of them (`missed_on_one_of_part`). Every run's prefix is
  shared by two runs of free branching that repeat from that step on and take two given values
  there, and no value proposed from the prefix is right on both (`prefix_fixes_no_next`).
* **The diagonal law.** The course on which every value an extrapolation proposes misses is the
  course through a map of a run of a determined law that keeps the whole prefix (`answerReg`,
  `answer_course`); no list holds its configurations (`answer_open`); with two values told apart
  every value proposed along it misses (`answer_misses`); and elimination over every merging of
  classes of candidates never comes to rest along it (`merged_unrested`).
* **Elimination along a run.** The extrapolation is through the run's prefix
  (`byElimination_through_prefix`); every candidate it passed missed at an earlier step of the run
  (`missed_before`); over merged classes its current candidate is never beyond the place of one
  that accords along the run (`merged_bound`); where it is right from some step on along a run,
  the run's course through the map repeats from some step (`Learning.lasso_of_rest`).
* **Induction along a run held by a list.** On a run of a determined law whose configurations a
  list holds, elimination over the lasso candidates misses fewer than `tri l.length` times,
  proposes from `l.length` on and does not miss at arbitrarily late steps
  (`held_byElimination_bounded`); that it rests is unrefuted (`held_rest_unrefuted`). Along the run of
  negation from `false` it rests from step `3` (`alternate_rests`); negation never rests
  (`negation_never_rests`).
* **Generalization from a run.** Within the features that go alike across a map's lumping, their
  values at the configurations a run passed before `t` fix the value at a configuration exactly
  where it is lumped with one of them (`Learning.determines_lumped_iff`); the value carried over
  is right exactly where the world takes one value at the two (`Learning.lumped_right_iff`), as it does
  for a world going alike across the lumping (`Learning.lumped_world_right`).
* **Training on runs' prefixes.** Read the courses through the map of a process's runs as the
  class (`Courses`) and the moments before `t` as the data. A loss computed from the prefix
  selects alike runs alike through the map before `t` (`loss_through_prefix`); within a class free
  beyond the prefix, a selection through it leaves the value at a later moment as free as the class
  does (`unselected_beyond_prefix`); and a fit to the prefix is right at a moment on every run
  exactly where the prefix determines it there (`fit_right_iff_runs`). Where runs branch freely,
  the prefix fixes no later value (`free_prefix_fixes_nothing`).
* **Alike in the frame, learned alike.** On runs of a determined law beginning alike in the frame
  by `reg` (`Law.frameBy`), a value proposed at a step where the features differ is right on at
  most one (`claim_not_right_on_both`); with the features decided it misses on one, the prefixes
  equal at every step (`missed_on_one`). Along the runs of the law leaving two coordinates
  unchanged, no extrapolation through the map to the first predicts the second at both
  `(true, false)` and `(true, true)` (`pair_first_not_predicts`), none predicts it
  along every run (`pair_not_learnable`), and through the map to both, elimination over the lasso
  candidates predicts the second from step `2` (`pair_whole_predicts`).

No ethical predicate, ranking or axiom occurs.

Declarations moved here unchanged, with their names, from `Becoming.Learning` (board item W): see
the sections so headed.
-/

/-! ## Going alike, at a step and lumped (moved from `Becoming.Learning`) -/

namespace Becoming

open Generative

universe u v w

namespace Learning

section Change

variable {S : Type u} {A : Type v} {K : Type w}

/-- Configurations `s` and `s'` go alike under `π` by the move `a`. -/
def GoAlikeAt (P : Process S A) (π : S → K) (s s' : S) (a : A) : Prop :=
  ∀ u u', P.step s a u → P.step s' a u' → π u = π u'

/-- Going alike is going alike at every two configurations lumped together, by every move. -/
theorem goAlike_iff_at {P : Process S A} {π : S → K} :
    GoAlike P π ↔ ∀ s s' a, π s = π s' → GoAlikeAt P π s s' a :=
  ⟨fun alike s s' a same u u' step step' => alike s s' a u u' same step step',
   fun every s s' a u u' same step step' => every s s' a same u u' step step'⟩

/-- **A law of change generalizes exactly where the step goes alike.** Under a determined
process, the outcome of `a` observed at `s₀`, read through `π`, transfers to every step of `a`
from `s` exactly where `s₀` and `s` go alike under `π` by `a`. The prefix does not fix this
before `a` is taken at `s` (`Run.not_fixesThrough_of_goAlike` of `Becoming.Mechanism`). -/
theorem transfer_right_iff {P : Process S A} {π : S → K} (determined : Determined P)
    {s₀ s : S} {a : A} {u₀ : S} (observed : P.step s₀ a u₀) :
    (∀ u, P.step s a u → π u = π u₀) ↔ GoAlikeAt P π s₀ s a :=
  ⟨fun transfer u₁ u step₁ step =>
    (congrArg π (determined s₀ a u₁ u₀ step₁ observed)).trans (transfer u step).symm,
   fun alike u step => (alike u₀ u observed step).symm⟩

/-- The image of a determined law along a map has a fixed successor (`«定后»`) exactly where the
next configuration, read through the map, goes alike across what the map lumps. -/
theorem fixed_image_iff_lumped {next : S → S} {π : S → K} :
    «定后» («像» π (fun s t => (Law.process next).step s () t)) ↔ Lumped π (fun s => π (next s)) :=
  ⟨fun fixed s s' same => fixed (π (next s)) (π (next s'))
      ⟨π s, ⟨s, next s, rfl, rfl, rfl⟩, ⟨s', next s', same.symm, rfl, rfl⟩⟩,
   fun lumped _ _ ⟨_, ⟨s, _, at_k, step, to⟩, ⟨s', _, at_k', step', to'⟩⟩ =>
    to.symm.trans ((congrArg π step).trans ((lumped s s' (at_k.trans at_k'.symm)).trans
      ((congrArg π step').symm.trans to')))⟩

/-- **Structure and change are one lumping.** A determined law goes alike under `π` exactly
where the next configuration, read through `π`, goes alike across what `π` lumps: the grammar's law
of the image (`«像定后当且仅当同行»`) on the law's one move, going alike being the grammar's
(`goAlikeUnder_iff_alike`) and the image's fixed successor being the lumping
(`fixed_image_iff_lumped`). -/
theorem goAlike_iff_lumped {next : S → S} {π : S → K} :
    GoAlike (Law.process next) π ↔ Lumped π (fun s => π (next s)) :=
  goAlikeUnder_iff_alike.trans
    ⟨fun alike => fixed_image_iff_lumped.mp («像定后当且仅当同行».mpr (alike ())),
     fun lumped _ => «像定后当且仅当同行».mp (fixed_image_iff_lumped.mpr lumped)⟩

end Change

end Learning

end Becoming


namespace Becoming

open Generative

universe u v w x

namespace LearningRuns

open Learning

/-! ## Misses read through equal prefixes -/

section Transport

variable {O : Type u}

/-- A miss carries to an equal proposal and an equal value. -/
theorem missed_congr {c c' : Option O} {w w' : O} (claim : c = c') (value : w = w') :
    Misses c w → Misses c' w' :=
  fun ⟨v, made, differs⟩ => ⟨v, claim.symm.trans made, fun same => differs (same.trans value.symm)⟩

/-- A miss at a step carries to a course with the same prefix and value there. -/
theorem missedAt_of_same {V : Type v} {pred : List O → Option V} {o : Nat → O} {o' : Nat → O}
    {val val' : V} {t : Nat} (same : prefixOf o t = prefixOf o' t) (now : val = val') :
    Misses (pred (prefixOf o t)) val → Misses (pred (prefixOf o' t)) val' :=
  missed_congr (congrArg pred same) now

/-- Held from `t` at the value of `o'`, a course agreeing with `o'` before `t` is missed at `t`
only where `o'` is. -/
theorem holdFrom_missed {pred : List O → Option O} {o o' : Nat → O} {t : Nat}
    (same : ∀ n, n < t → o n = o' n) :
    MissesAt pred (holdFrom o t (o' t)) t → MissesAt pred o' t :=
  missedAt_of_same
    (prefix_congr fun n before => (holdFrom_before o (o' t) before).trans (same n before))
    (holdFrom_after o (o' t) (Nat.le_refl t))

end Transport

/-! ## Along runs of any process -/

section AnyProcess

variable {S : Type u} {A : Type v} {R : Type w} {P : Process S A}

/-- **At a parting, a value proposed from the prefix misses on one of the two runs.** With the
values through the map decided, where two runs are alike through the map before `t` and apart at
`t`, a value proposed at `t` from the prefix misses on one of them. -/
theorem missed_on_one_of_part [DecidableEq R] (pred : List R → Option R) {reg : S → R}
    {r r' : Run P} {t : Nat} (part : Parting.PartAt reg r r' t) {w : R}
    (claims : pred (prefixOf (Parting.course reg r) t) = some w) :
    MissesAt pred (Parting.course reg r) t ∨ MissesAt pred (Parting.course reg r') t :=
  match claim_missed_on_one pred (Parting.course reg r) t part.2 claims with
  | .inl refuted => .inl (holdFrom_missed (fun _ _ => rfl) refuted)
  | .inr refuted => .inr (holdFrom_missed part.1 refuted)

/-- **No prefix of a run fixes the next value, not even among finite worlds.** Given two values,
the prefix of every run before `t` is the prefix of two runs of free branching that repeat from
`t` on, one taking each value at `t`; a value proposed from the prefix is not right on both. -/
theorem prefix_fixes_no_next (pred : List R → Option R) (reg : S → R) (r : Run P) (t : Nat)
    {x y : R} (two : x ≠ y) {w : R} (claims : pred (prefixOf (Parting.course reg r) t) = some w) :
    ∃ q q' : Run (Parting.free R), Lasso (Parting.course id q) t 0 ∧
      Lasso (Parting.course id q') t 0 ∧
      prefixOf (Parting.course id q) t = prefixOf (Parting.course reg r) t ∧
      prefixOf (Parting.course id q') t = prefixOf (Parting.course reg r) t ∧
      q.state t = x ∧ q'.state t = y ∧
      ¬ (¬ MissesAt pred (Parting.course id q) t ∧ ¬ MissesAt pred (Parting.course id q') t) :=
  match no_prefix_fixes_next_finite pred (Parting.course reg r) t two claims with
  | ⟨lasso, lasso', same, same', one⟩ =>
    ⟨Parting.freeRun (holdFrom (Parting.course reg r) t x),
     Parting.freeRun (holdFrom (Parting.course reg r) t y), lasso, lasso', same, same',
     holdFrom_after _ x (Nat.le_refl t), holdFrom_after _ y (Nat.le_refl t), one⟩

/-- **The extrapolation by elimination is through the run's prefix.** On two runs alike through
the map before `t`, its current candidate and its proposal at `t` are the same. -/
theorem byElimination_through_prefix [DecidableEq R] (H : Nat → List R → Option R) {reg : S → R}
    {r r' : Run P} {t : Nat} (same : ∀ n, n < t → reg (r.state n) = reg (r'.state n)) :
    index H (Parting.course reg r) t = index H (Parting.course reg r') t ∧
      byElimination H (prefixOf (Parting.course reg r) t) = byElimination H (prefixOf (Parting.course reg r') t) :=
  Learning.byElimination_through_prefix (prefix_congr same)

end AnyProcess

/-! ## Training on the prefixes of runs -/

section Training

variable {S : Type u} {A : Type v} {R : Type w} {P : Process S A}

/-- The courses through `reg` of the runs of `P`: the class an extrapolation through `reg` along
the runs can meet. -/
def Courses (P : Process S A) (reg : S → R) (g : Nat → R) : Prop :=
  ∃ r : Run P, ∀ n, g n = reg (r.state n)

/-- The course through the map of every run is one of them. -/
theorem course_mem (reg : S → R) (r : Run P) : Courses P reg (Parting.course reg r) :=
  ⟨r, fun _ => rfl⟩

/-- **A loss computed from the prefix selects alike runs alike through the map before `t`.** -/
theorem loss_through_prefix {L : Type x} {t : Nat} (loss : (Nat → R) → L)
    (on_data : ∀ g g', Training.AgreeOn (· < t) g g' → loss g = loss g') (choose : L → Prop)
    {reg : S → R} {r r' : Run P} (same : ∀ n, n < t → reg (r.state n) = reg (r'.state n)) :
    choose (loss (Parting.course reg r)) ↔ choose (loss (Parting.course reg r')) :=
  Training.loss_through loss on_data choose (Parting.course reg r) (Parting.course reg r') same

/-- **Training through the prefix leaves the later value as free as the runs leave it.** Where
the courses through the map of `P` are free at `x` beyond the prefix before `t`, for every run
whose course a selection through the prefix selects and every run, a selected course of a run
agrees with the first on the prefix and takes the second's value at `x`. -/
theorem unselected_beyond_prefix {reg : S → R} {t x : Nat} {select : (Nat → R) → Prop}
    (through : Training.Through (Training.AgreeOn (· < t)) select)
    (free : Free (Courses P reg) (· < t) x) {r r' : Run P}
    (chosen : select (Parting.course reg r)) :
    ∃ h, Courses P reg h ∧ select h ∧ Training.AgreeOn (· < t) h (Parting.course reg r) ∧
      h x = reg (r'.state x) :=
  Training.unselected_beyond_data through free (course_mem reg r) (course_mem reg r') chosen

/-- **A fit to the prefix is right at a moment on every run exactly where the prefix determines
it.** Every two runs alike through the map before `t` are alike at `x` exactly where, within the
courses through the map of `P`, the prefix before `t` determines the value at `x`. -/
theorem fit_right_iff_runs {reg : S → R} {t x : Nat} :
    (∀ r r' : Run P, (∀ n, n < t → reg (r'.state n) = reg (r.state n)) →
      reg (r'.state x) = reg (r.state x)) ↔ Determines (Courses P reg) (· < t) x :=
  have to_runs : (∀ f g, Courses P reg f → Courses P reg g → Training.AgreeOn (· < t) g f →
      g x = f x) → ∀ r r' : Run P, (∀ n, n < t → reg (r'.state n) = reg (r.state n)) →
        reg (r'.state x) = reg (r.state x) :=
    fun right r r' agree => right _ _ (course_mem reg r) (course_mem reg r') agree
  have of_runs : (∀ r r' : Run P, (∀ n, n < t → reg (r'.state n) = reg (r.state n)) →
      reg (r'.state x) = reg (r.state x)) → ∀ f g, Courses P reg f → Courses P reg g →
        Training.AgreeOn (· < t) g f → g x = f x :=
    fun right _ _ ⟨r, at_f⟩ ⟨r', at_g⟩ agree =>
      (at_g x).trans ((right r r' fun n before =>
        (at_g n).symm.trans ((agree n before).trans (at_f n))).trans (at_f x).symm)
  ⟨fun right => Training.fit_right_iff.mp (of_runs right),
   fun determines => to_runs (Training.fit_right_iff.mpr determines)⟩

/-- **Where runs branch freely, the prefix fixes no later value.** Given two values, within the
courses of the runs of free branching the prefix before `t` fixes the value at no
moment from `t` on. -/
theorem free_prefix_fixes_nothing {V : Type w} {t x : Nat} (late : t ≤ x) {y z : V}
    (two : y ≠ z) : ¬ Determines (Courses (Parting.free V) id) (· < t) x :=
  fun determines => every_determines_nothing (D := (· < t))
    (fun early => Nat.lt_irrefl x (Nat.lt_of_lt_of_le early late)) two
    fun g g' _ _ agree => determines g g' ⟨Parting.freeRun g, fun _ => rfl⟩
      ⟨Parting.freeRun g', fun _ => rfl⟩ agree

end Training

/-! ## The diagonal law -/

section Answer

variable {O : Type u}

/-- The map read along the diagonal law of `pred`: the value set against the proposal made from
the prefix the law keeps. -/
def answerReg (pred : List O → Option O) (other : O → O) (x : O) (l : List O) : O :=
  answerTo other x (pred l)

/-- **The diagonal course is the course through a map of a run of the diagonal law.** Along every
run of `answerStep` from the empty prefix, the course through `answerReg` is the diagonal course. -/
theorem answer_course (pred : List O → Option O) (other : O → O) (x : O)
    (r : Run (Law.process (answerStep pred other x))) (start : r.state 0 = []) (n : Nat) :
    Parting.course (answerReg pred other x) r n = diagonal pred other x n :=
  congrArg (answerReg pred other x)
    ((Branching.law_run_state r n).trans
      (congrArg (fun s => Law.orbit (answerStep pred other x) s n) start))

theorem answer_prefix (pred : List O → Option O) (other : O → O) (x : O)
    (r : Run (Law.process (answerStep pred other x))) (start : r.state 0 = []) (t : Nat) :
    prefixOf (Parting.course (answerReg pred other x) r) t = prefixOf (diagonal pred other x) t :=
  prefix_congr fun n _ => answer_course pred other x r start n

/-- **The diagonal world is open.** No list holds the configurations of a run of the diagonal
law from the empty prefix. -/
theorem answer_open (pred : List O → Option O) (other : O → O) (x : O)
    (r : Run (Law.process (answerStep pred other x))) (start : r.state 0 = []) :
    ¬ ∃ l : List (List O), ∀ n, r.state n ∈ l :=
  fun ⟨l, held⟩ => diagonal_open pred other x ⟨l, fun n =>
    Eq.subst (motive := fun s => s ∈ l)
      ((Branching.law_run_state r n).trans
        (congrArg (fun s => Law.orbit (answerStep pred other x) s n) start)) (held n)⟩

/-- **With two values told apart, every value proposed along the diagonal run misses.** -/
theorem answer_misses [DecidableEq O] (pred : List O → Option O) {a b : O} (two : a ≠ b)
    (r : Run (Law.process (answerStep pred (swapTo a b) a))) (start : r.state 0 = []) {t : Nat}
    {w : O} (claims : pred (prefixOf (Parting.course (answerReg pred (swapTo a b) a) r) t) = some w) :
    MissesAt pred (Parting.course (answerReg pred (swapTo a b) a) r) t :=
  missedAt_of_same (answer_prefix pred (swapTo a b) a r start t).symm
    (answer_course pred (swapTo a b) a r start t).symm
    (diagonal_misses pred (swapTo_moves two) a
      ((congrArg pred (answer_prefix pred (swapTo a b) a r start t)).symm.trans claims))

/-- **Elimination over every merging never rests along its diagonal run.** However classes of
candidates are chosen and merged, elimination over them is right from no step on along the run
of its diagonal law. -/
theorem merged_unrested [DecidableEq O] (G : Nat → Nat → List O → Option O) {other : O → O}
    (moves : ∀ v, other v ≠ v) (x : O) (r : Run (Law.process (answerStep (byElimination (merged G)) other x)))
    (start : r.state 0 = []) :
    ¬ ∃ T, ∀ t, T ≤ t → Parting.RightAt (byElimination (merged G)) (answerReg (byElimination (merged G)) other x)
      r t :=
  fun ⟨T, right⟩ => Learning.merged_unrested G moves x ⟨T, fun t late =>
    (congrArg (byElimination (merged G)) (answer_prefix (byElimination (merged G)) other x r start t)).symm.trans
      ((right t late).trans (congrArg some (answer_course (byElimination (merged G)) other x r start t)))⟩

end Answer

/-! ## Along runs of a determined law -/

section Determined

variable {S : Type u} {R : Type w} {next : S → S}

/-- **Induction along a run held by a list: the misses are bounded.** On a run of a
determined law whose configurations a list `l` holds, elimination over the lasso candidates,
through the map and given neither the configurations nor their number, misses fewer than
`tri l.length` times, proposes at every step from `l.length` on, and does not miss at
arbitrarily late steps. -/
theorem held_byElimination_bounded [DecidableEq R] (r : Run (Law.process next)) {l : List S}
    (held : ∀ n, r.state n ∈ l) (reg : S → R) :
    (∀ t, index lassos (LearnableRuns.course reg r) t < tri l.length) ∧
      (∀ t, l.length ≤ t → ∃ v, byElimination lassos (prefixOf (LearnableRuns.course reg r) t) = some v) ∧
      ¬ ∀ T, ∃ t, T ≤ t ∧ MissesAt (byElimination lassos) (LearnableRuns.course reg r) t :=
  have held' : ∀ n, Law.orbit next (r.state 0) n ∈ l := fun n =>
    Eq.subst (motive := fun s => s ∈ l) (Branching.law_run_state r n) (held n)
  match Learning.held_byElimination_bounded held' reg with
  | ⟨bound, claims, stops⟩ =>
    ⟨fun t => Nat.lt_of_le_of_lt
        (Nat.le_of_eq (congrArg (indexOn lassos) (LearnableRuns.prefix_eq reg r t))) (bound t),
     fun t late => match claims t late with
      | ⟨v, made⟩ => ⟨v, (congrArg (byElimination lassos) (LearnableRuns.prefix_eq reg r t)).trans made⟩,
     fun late => stops fun T => match late T with
      | ⟨t, after, refuted⟩ => ⟨t, after, missedAt_of_same (LearnableRuns.prefix_eq reg r t)
          (congrArg reg (Branching.law_run_state r t)) refuted⟩⟩

/-- **Induction along a run held by a list: that elimination rests is unrefuted.** -/
theorem held_rest_unrefuted [DecidableEq R] (r : Run (Law.process next)) {l : List S}
    (held : ∀ n, r.state n ∈ l) (reg : S → R) :
    ¬ ¬ LearnableRuns.Predicts reg reg (byElimination lassos) r :=
  fun never => Learning.held_rest_unrefuted
    (fun n => Eq.subst (motive := fun s => s ∈ l) (Branching.law_run_state r n) (held n)) reg
    fun ⟨T, rests⟩ => never ⟨T, (LearnableRuns.predictsFrom_iff r T).mpr rests⟩

/-- **A proposal finer than the map is right on at most one of two runs beginning alike.**
On runs of a determined law beginning alike in the frame by `reg`, at a step where the
features differ, a value an extrapolation proposes is not right on both. -/
theorem claim_not_right_on_both {V : Type x} {reg : S → R} {val : S → V} (pred : List R → Option V)
    {r r' : Run (Law.process next)}
    (alike : Alike (Law.frameBy next reg) (Law.frameBy next reg) (r.state 0) (r'.state 0))
    {t : Nat} (differ : val (r.state t) ≠ val (r'.state t)) :
    ¬ (pred (prefixOf (LearnableRuns.course reg r) t) = some (val (r.state t)) ∧
      pred (prefixOf (LearnableRuns.course reg r') t) = some (val (r'.state t))) :=
  fun ⟨right, right'⟩ =>
    Learnable.claim_not_right_on_both pred (Law.alike_iff_sameFuture.mp alike)
      (fun same => differ ((congrArg val (Branching.law_run_state r t)).trans
        (same.trans (congrArg val (Branching.law_run_state r' t)).symm)))
      ⟨(congrArg pred (LearnableRuns.prefix_eq reg r t)).symm.trans
          (right.trans (congrArg (fun s => some (val s)) (Branching.law_run_state r t))),
       (congrArg pred (LearnableRuns.prefix_eq reg r' t)).symm.trans
          (right'.trans (congrArg (fun s => some (val s)) (Branching.law_run_state r' t)))⟩

/-- **With the features decided, the proposal misses on one of two runs beginning alike, and their
prefixes are equal at every step.** -/
theorem missed_on_one {V : Type x} [DecidableEq V] {reg : S → R} {val : S → V}
    (pred : List R → Option V) {r r' : Run (Law.process next)}
    (alike : Alike (Law.frameBy next reg) (Law.frameBy next reg) (r.state 0) (r'.state 0))
    {t : Nat} (differ : val (r.state t) ≠ val (r'.state t)) {w : V}
    (claims : pred (prefixOf (LearnableRuns.course reg r) t) = some w) :
    (Misses (pred (prefixOf (LearnableRuns.course reg r) t)) (val (r.state t)) ∨
      Misses (pred (prefixOf (LearnableRuns.course reg r') t)) (val (r'.state t))) ∧
    ∀ n, prefixOf (LearnableRuns.course reg r) n = prefixOf (LearnableRuns.course reg r') n :=
  match Learnable.missed_on_one pred (Law.alike_iff_sameFuture.mp alike)
      (fun same => differ ((congrArg val (Branching.law_run_state r t)).trans
        (same.trans (congrArg val (Branching.law_run_state r' t)).symm)))
      ((congrArg pred (LearnableRuns.prefix_eq reg r t)).symm.trans claims) with
  | ⟨one, records⟩ =>
    ⟨match one with
     | .inl refuted => .inl (missedAt_of_same (LearnableRuns.prefix_eq reg r t).symm
         (congrArg val (Branching.law_run_state r t)).symm refuted)
     | .inr refuted => .inr (missedAt_of_same (LearnableRuns.prefix_eq reg r' t).symm
         (congrArg val (Branching.law_run_state r' t)).symm refuted),
     fun n => (LearnableRuns.prefix_eq reg r n).trans
       ((records n).trans (LearnableRuns.prefix_eq reg r' n).symm)⟩

end Determined

/-! ## Witnesses on runs -/

/-- **Negation never rests.** Along every run of the law of negation, each configuration differs
from the one before. -/
theorem negation_never_rests (r : Run (Law.process not)) (n : Nat) :
    r.state (n + 1) ≠ r.state n :=
  fun same => ListTests.not_ne_self (r.state n) ((r.step n).symm.trans same)

/-- **Two misses, then rest.** Along every run of negation from `false`, elimination over
the lasso candidates through the identity proposes each value right from step `3` on. -/
theorem alternate_rests (r : Run (Law.process not)) (start : r.state 0 = false) :
    LearnableRuns.PredictsFrom id id (byElimination lassos) r 3 :=
  (LearnableRuns.predictsFrom_iff r 3).mpr
    (Eq.subst (motive := fun s => Learnable.PredictsFrom not id id (byElimination lassos) s 3) start.symm
      Alternate.rests)

/-- The four configurations of two coordinates. -/
theorem pair_world : ∀ s : Bool × Bool, s ∈ [(true, true), (true, false), (false, true), (false, false)]
  | (true, true) => List.Mem.head _
  | (true, false) => List.Mem.tail _ (List.Mem.head _)
  | (false, true) => List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _))
  | (false, false) => List.Mem.tail _ (List.Mem.tail _ (List.Mem.tail _ (List.Mem.head _)))

/-- **Through the map to the first coordinate, no extrapolation predicts the second along the
runs from both `(true, false)` and `(true, true)`** of the law leaving each
configuration unchanged. -/
theorem pair_first_not_predicts (pred : List Bool → Option Bool) :
    ¬ (LearnableRuns.Predicts Prod.fst Prod.snd pred (Law.run Learnable.Pair.still (true, false)) ∧
      LearnableRuns.Predicts Prod.fst Prod.snd pred (Law.run Learnable.Pair.still (true, true))) :=
  fun ⟨rests, rests'⟩ => Learnable.Pair.first_not_predicts pred
    ⟨(LearnableRuns.predicts_iff _).mp rests, (LearnableRuns.predicts_iff _).mp rests'⟩

/-- **Through the map to the first coordinate, no extrapolation predicts the second along every
run.** -/
theorem pair_not_learnable :
    ¬ ∃ pred : List Bool → Option Bool, ∀ r : Run (Law.process Learnable.Pair.still),
      LearnableRuns.Predicts Prod.fst Prod.snd pred r :=
  fun learnable => Learnable.Pair.not_lumped
    ((LearnableRuns.still_learnable_iff_lumped (fun _ => rfl) pair_world).mp learnable)

/-- **Through the map to both, elimination over the lasso candidates predicts the second along
every run from step `2`.** -/
theorem pair_whole_predicts (r : Run (Law.process Learnable.Pair.still)) :
    LearnableRuns.PredictsFrom id Prod.snd (fun l => (byElimination lassos l).map Prod.snd) r 2 :=
  (LearnableRuns.predictsFrom_iff r 2).mpr (Learnable.Pair.whole_predicts (r.state 0))

end LearningRuns

end Becoming
