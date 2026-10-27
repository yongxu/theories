import Becoming.HeldPossible

/-!
# UE11 re-check probes: the reading

AI-written, 27 October 2026, for the independent re-check of UE11's fix round
(`RECHECK-UE11.md`). Evidence only; nothing here is proposed for landing as written.

* Q1 `not_keepsWidening_of_recurs`: along a course that comes back to one configuration at
  arbitrarily late steps, no chain read off its configurations keeps widening.
* Q2 `Oscillating.returns`, `Oscillating.recurs`, `Oscillating.exceeds_now`,
  `Oscillating.held_widens`, `Oscillating.returning_has_both`: the module's `Oscillating` course
  only returns (period two), yet at every step the whole possible exceeds what the configuration
  admits, and the possible with the rule held widens across the course's first step (and so at
  every even step); it does not keep widening.
* Q3 `CopyDown.admitted_on_course`: every formation is admitted at some step of
  `CopyDown.course`.
* Q4 `RaisedRule.not_renews`, `RaisedRule.ceases`, `CopyDown.not_renews`, `CopyDown.ceases`: on
  both of the module's witnesses, read on the course's moments under what is held, no moment
  renews (`«复生»`), so every moment ceases (`«息»`).
* Q5 `Alternating`: the raised rule raised at every other step. The possible with the rule held
  keeps widening, every formation is possible from every configuration of the course, and read on
  the course's moments under the rule held, renewal without end (`«生生»`) holds at every even
  moment, so they do not cease (`«生生不息»`).
-/

namespace Becoming.RecheckUE11

open Generative

universe u v

/-! ## Q1. A course that keeps coming back keeps nothing widening -/

/-- **Along a course that comes back to one configuration at arbitrarily late steps, no chain read
off its configurations keeps widening.** -/
theorem not_keepsWidening_of_recurs {S : Type u} {A : Type v} {X : Type} {P : Process S A}
    (r : Run P) (F : S → X → Prop) {N : Nat}
    (recurs : ∀ d, ∃ m, N + d ≤ m ∧ r.state m = r.state N) :
    ¬ Reaching.KeepsWidening (fun n => F (r.state n)) :=
  fun keeps => match keeps.2 N with
  | ⟨d, x, later, notNow⟩ => match recurs d with
    | ⟨_, le, same⟩ => match Nat.le.dest le with
      | ⟨e, eq⟩ => notNow (Eq.subst (motive := fun y => F y x) same
          (Eq.subst (motive := fun k => F (r.state k) x) eq (keeps.1 (N + d) e x later)))

/-! ## Q2. `Oscillating` only returns, and meets both criteria of the reading -/

namespace Oscillating

open Becoming.Oscillating

theorem not_not_bool : ∀ b : Bool, (!(!b)) = b
  | true => rfl
  | false => rfl

/-- The course returns every two steps. -/
theorem returns (k : Nat) : course.state (k + 2) = course.state k :=
  congrArg (fun b => ((cond b 1 0 : Nat), (0 : Nat))) (not_not_bool (flip k))

/-- The configuration at step `0` comes back at arbitrarily late steps. -/
theorem recurs : ∀ d, ∃ m, 0 + d ≤ m ∧ course.state m = course.state 0
  | 0 => ⟨0, Nat.le_refl _, rfl⟩
  | d + 1 => match recurs d with
    | ⟨m, le, same⟩ => ⟨m + 2, Nat.succ_le_succ (Nat.le_succ_of_le le), (returns m).trans same⟩

/-- At every step the whole possible exceeds what the configuration admits. -/
theorem exceeds_now (k : Nat) :
    Reaching.Possible process adm (course.state k) 1 ∧ ¬ adm (course.state k) 1 :=
  ⟨every _ 1, fun admitted => Nat.noConfusion admitted⟩

/-- **The possible with the rule held widens across the course's first step**: what is possible so
at step `0` is possible so at step `1`, and `1` is possible so at step `1` only. -/
theorem held_widens :
    (∀ y, Reaching.PossibleHeld process Same adm (course.state 0) y →
      Reaching.PossibleHeld process Same adm (course.state 1) y) ∧
    Reaching.PossibleHeld process Same adm (course.state 1) 1 ∧
    ¬ Reaching.PossibleHeld process Same adm (course.state 0) 1 :=
  ⟨fun _ ⟨_, ⟨_, trace⟩, admitted⟩ =>
     ⟨course.state 1, Reach.refl _ _, admitted.trans (held_zero trace rfl rfl)⟩,
   ⟨(1, 1), Reach.of_step (a := ()) ⟨Or.inr ⟨rfl, Nat.le_refl 1⟩, rfl⟩, rfl⟩,
   fun ⟨_, ⟨_, trace⟩, admitted⟩ => Nat.noConfusion (admitted.trans (held_zero trace rfl rfl))⟩

/-- **A course that only returns, with both criteria of the note's reading**: it returns every two
steps; at every step the whole possible exceeds what is admitted; the possible with the rule held
widens across a step; and it does not keep widening. -/
theorem returning_has_both :
    (∀ k, course.state (k + 2) = course.state k) ∧
    (∀ k, Reaching.Possible process adm (course.state k) 1 ∧ ¬ adm (course.state k) 1) ∧
    ((∀ y, Reaching.PossibleHeld process Same adm (course.state 0) y →
        Reaching.PossibleHeld process Same adm (course.state 1) y) ∧
      Reaching.PossibleHeld process Same adm (course.state 1) 1 ∧
      ¬ Reaching.PossibleHeld process Same adm (course.state 0) 1) ∧
    ¬ Reaching.KeepsWidening (fun k => Reaching.PossibleHeld process Same adm (course.state k)) :=
  ⟨returns, exceeds_now, held_widens,
   not_keepsWidening_of_recurs course (Reaching.PossibleHeld process Same adm) recurs⟩

end Oscillating

/-! ## Q3. `CopyDown`'s course admits every formation at some step -/

/-- Every formation is admitted at some step of `CopyDown.course`: `x` at step `x + 1`. -/
theorem CopyDown.admitted_on_course (x : Nat) :
    Becoming.CopyDown.adm (Becoming.CopyDown.course.state (x + 1)) x :=
  Eq.subst (motive := fun v => x + 1 < v) (Becoming.CopyDown.rule_below (Nat.lt_succ_self x)).symm
    (Nat.lt_succ_self (x + 1))

/-! ## Q4. On the module's witnesses, under what is held, every moment ceases -/

/-- On `RaisedRule`'s course, read on the course's moments under the rule held, no moment
renews: no line under the rule goes on even one step. -/
theorem RaisedRule.not_renews (n : Nat) :
    ¬ «复生» Steps.next (fun i j => Becoming.RaisedRule.Same (Becoming.RaisedRule.course.state i)
      (Becoming.RaisedRule.course.state j)) n :=
  fun ⟨y, _, _, _, next, same⟩ => Nat.succ_ne_self y (next.symm.trans same)

/-- So every moment of `RaisedRule`'s course ceases under the rule held (`«自不复生则息»`). -/
theorem RaisedRule.ceases (n : Nat) :
    «息» Steps.next (fun i j => Becoming.RaisedRule.Same (Becoming.RaisedRule.course.state i)
      (Becoming.RaisedRule.course.state j)) n :=
  «自不复生则息» (RaisedRule.not_renews n)

/-- On `CopyDown`'s course, read on the course's moments under the rules from any height `h` up
held, no moment renews. -/
theorem CopyDown.not_renews (h n : Nat) :
    ¬ «复生» Steps.next (fun i j => RuleTower.SameFrom h (Becoming.CopyDown.course.state i)
      (Becoming.CopyDown.course.state j)) n :=
  fun ⟨_, rfl, begins, _, rfl, same⟩ =>
    match Nat.lt_or_ge (n + 1) h with
    | .inl below => begins ⟨n, rfl, fun m above =>
        (Becoming.CopyDown.course.step n).2.2 m (fun eq => Nat.lt_irrefl n
          (Eq.subst (motive := fun j => n < j) eq
            (Nat.lt_trans (Nat.lt_succ_self n) (Nat.lt_of_lt_of_le below above))))⟩
    | .inr atLeast => (Becoming.CopyDown.changes_iff (n + 1) (n + 1)).mpr rfl (same (n + 1) atLeast)

/-- So every moment of `CopyDown`'s course ceases under the rules from every height up held. -/
theorem CopyDown.ceases (h n : Nat) :
    «息» Steps.next (fun i j => RuleTower.SameFrom h (Becoming.CopyDown.course.state i)
      (Becoming.CopyDown.course.state j)) n :=
  «自不复生则息» (CopyDown.not_renews h n)

/-! ## Q5. A witness with both: the rule raised at every other step -/

namespace Alternating

open Becoming.RaisedRule (process adm Same)

/-- `true` at the odd steps. -/
def odd : Nat → Bool
  | 0 => false
  | k + 1 => !odd k

/-- The rule at step `k`: raised across every even step. -/
def half : Nat → Nat
  | 0 => 0
  | 1 => 1
  | k + 2 => half k + 1

/-- Across an even step the rule is raised; across an odd one it stays. -/
theorem step_cases : ∀ k, (half (k + 1) = half k + 1 ∧ odd k = false) ∨
    (half (k + 1) = half k ∧ odd k = true)
  | 0 => .inl ⟨rfl, rfl⟩
  | 1 => .inr ⟨rfl, rfl⟩
  | k + 2 => match step_cases k with
    | .inl ⟨raise, even⟩ => .inl ⟨congrArg (· + 1) raise,
        (Oscillating.not_not_bool (odd k)).trans even⟩
    | .inr ⟨stay, isOdd⟩ => .inr ⟨congrArg (· + 1) stay,
        (Oscillating.not_not_bool (odd k)).trans isOdd⟩

/-- The course: from rule `0` at position `0`, the rule raised across every even step, the
position moved to `0` (kept) across every odd one. -/
def course : Run process :=
  ⟨fun k => (half k, 0), fun _ => (), fun k => match step_cases k with
    | .inl ⟨raise, _⟩ => Or.inl ⟨raise, rfl⟩
    | .inr ⟨stay, _⟩ => Or.inr ⟨stay, Nat.zero_le _⟩⟩

theorem half_le (k : Nat) : ∀ d, half k ≤ half (k + d)
  | 0 => Nat.le_refl _
  | d + 1 => Nat.le_trans (half_le k d) (match step_cases (k + d) with
    | .inl ⟨raise, _⟩ => Eq.subst (motive := fun v => half (k + d) ≤ v) raise.symm
        (Nat.le_succ (half (k + d)))
    | .inr ⟨stay, _⟩ => Nat.le_of_eq stay.symm)

/-- With the rule held, the possible at step `k` is what lies at most the rule there. -/
theorem held_iff (k y : Nat) :
    Reaching.PossibleHeld process Same adm (course.state k) y ↔ y ≤ half k :=
  Becoming.RaisedRule.held_iff (half k) y

/-- **With the rule held, the possible keeps widening along the course.** -/
theorem held_keeps_widening :
    Reaching.KeepsWidening (fun k => Reaching.PossibleHeld process Same adm (course.state k)) :=
  ⟨fun k d y held => (held_iff (k + d) y).mpr (Nat.le_trans ((held_iff k y).mp held) (half_le k d)),
   fun k => ⟨2, half k + 1, (held_iff (k + 2) (half k + 1)).mpr (Nat.le_refl _),
     fun held => Nat.not_succ_le_self (half k) ((held_iff k (half k + 1)).mp held)⟩⟩

/-- **From every configuration of the course every formation is possible.** -/
theorem whole_every (k y : Nat) : Reaching.Possible process adm (course.state k) y :=
  Becoming.RaisedRule.whole_every (half k) y

/-- **Read on the course's moments under the rule held, renewal without end holds at every even
moment**: each even moment conditions a beginning (the rule raised) whose line goes on one step
(the rule kept) to the next even moment. -/
theorem renews_without_end {k : Nat} (even : odd k = false) :
    «生生» Steps.next (fun i j => Same (course.state i) (course.state j)) k :=
  ⟨fun j => odd j = false, fun j evenJ => ⟨j + 1, j + 2, rfl,
      fun pred => match step_cases j, Steps.hasPred_iff.mp pred with
        | .inl ⟨raise, _⟩, same => Nat.succ_ne_self (half j) (raise.symm.trans same)
        | .inr ⟨_, isOdd⟩, _ => Bool.noConfusion (evenJ.symm.trans isOdd),
      .one ⟨rfl, match step_cases (j + 1) with
        | .inl ⟨_, isEven⟩ => Bool.noConfusion
            ((congrArg (fun b => !b) evenJ).symm.trans isEven)
        | .inr ⟨stay, _⟩ => stay⟩,
      (Oscillating.not_not_bool (odd j)).trans evenJ⟩, even⟩

/-- **Both at once, with a fixed whole possible**: the possible with the rule held keeps widening,
every formation is possible from every configuration of the course, and the course's moments
under the rule held renew without end from step `0`, so they do not cease. -/
theorem both :
    Reaching.KeepsWidening (fun k => Reaching.PossibleHeld process Same adm (course.state k)) ∧
    (∀ k y, Reaching.Possible process adm (course.state k) y) ∧
    «生生» Steps.next (fun i j => Same (course.state i) (course.state j)) 0 ∧
    ¬ «息» Steps.next (fun i j => Same (course.state i) (course.state j)) 0 :=
  ⟨held_keeps_widening, whole_every, renews_without_end rfl, «生生不息» (renews_without_end rfl)⟩

end Alternating

end Becoming.RecheckUE11
