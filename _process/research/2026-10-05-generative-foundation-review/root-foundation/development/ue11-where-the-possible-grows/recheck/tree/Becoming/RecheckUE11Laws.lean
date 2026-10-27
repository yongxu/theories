import Becoming.HeldPossible

/-!
# UE11 re-check probes: the laws

AI-written, 27 October 2026, for the independent re-check of UE11's fix round
(`RECHECK-UE11.md`). Evidence only; nothing here is proposed for landing as written.

* Q6 `reach_held_iff_as_at_start`: for a class, what the moves holding it reach is exactly what
  the moves into configurations the same as the start reach (both directions; the module states
  one). `Adjacent`: for a relation that is not transitive the two differ. `Down`: for a transitive
  relation that is not symmetric they differ too.
* Q7 `RuleTower.move_above_keeps`: a move above `n` need not change any rule's value.
* Q8 `located_iff_wlem`: the located law without a decision, asked of every process, is exactly
  weak excluded middle; `Run.held_change_located_weak`: the module's located law holds with each
  step's holding only weakly decided (`¬ Same … ∨ ¬ ¬ Same …`).
* Q9 `unending_of_stays`, `not_begins_of_stays`, `Stay.fails`: without the keeps-widening premise
  the moments' laws are false: along a course whose every step holds the part, the line under it is
  unending from every moment and no line begins after moment `0`, on a course of `RaisedRule`'s
  process too.
-/

namespace Becoming.RecheckUE11

open Generative

universe u v

/-! ## Q6. Held move by move, and held as at the start -/

section Class

variable {S : Type u} {A : Type v} {P : Process S A} {Same : S → S → Prop}

theorem toStart (cls : «类» Same) {s : S} : ∀ {m t : S} {as : List A}, Same s m →
    Trace (Reaching.heldMoves P Same) m as t →
      Trace (Reaching.heldMoves P (fun _ u => Same s u)) m as t
  | _, _, _, _, .nil _ => .nil _
  | _, _, _, atM, .cons held rest =>
    .cons ⟨held.1, cls.trans atM held.2⟩ (toStart cls (cls.trans atM held.2) rest)

theorem fromStart (cls : «类» Same) {s : S} : ∀ {m t : S} {as : List A}, Same s m →
    Trace (Reaching.heldMoves P (fun _ u => Same s u)) m as t →
      Trace (Reaching.heldMoves P Same) m as t
  | _, _, _, _, .nil _ => .nil _
  | _, _, _, atM, .cons held rest =>
    .cons ⟨held.1, cls.trans (cls.symm atM) held.2⟩ (fromStart cls held.2 rest)

/-- **For a class, holding it move by move is holding it as it is at the start**, both ways: what
the moves holding `Same` reach from `s` is what the moves into configurations the same as `s`
reach. -/
theorem reach_held_iff_as_at_start (cls : «类» Same) {s t : S} :
    Reach (Reaching.heldMoves P Same) s t ↔ Reach (Reaching.heldMoves P (fun _ u => Same s u)) s t :=
  ⟨fun ⟨as, trace⟩ => ⟨as, toStart cls (cls.refl s) trace⟩,
   fun ⟨as, trace⟩ => ⟨as, fromStart cls (cls.refl s) trace⟩⟩

end Class

namespace Adjacent

/-- Counting up. -/
def process : Process Nat Unit := ⟨fun s _ t => t = s + 1⟩

/-- Adjacent or equal: reflexive and not transitive. -/
def Same (s t : Nat) : Prop := t = s + 1 ∨ t = s

/-- **Held move by move, `2` is reached from `0`, yet `2` is not the same as `0`.** -/
theorem differs :
    Reach (Reaching.heldMoves process Same) 0 2 ∧ ¬ Same 0 2 :=
  ⟨Reach.trans (Reach.of_step (a := ()) ⟨rfl, Or.inl rfl⟩) (Reach.of_step (a := ()) ⟨rfl, Or.inl rfl⟩),
   fun | .inl two => Nat.succ_ne_self 1 two
       | .inr two => Nat.noConfusion two⟩

end Adjacent

namespace Down

/-- From `0` to `5`, and from `5` to `3`. -/
def process : Process Nat Unit := ⟨fun s _ t => (s = 0 ∧ t = 5) ∨ (s = 5 ∧ t = 3)⟩

theorem not_five_le_three : ¬ 5 ≤ 3 :=
  fun le => Nat.not_succ_le_zero 1
    (Nat.le_of_succ_le_succ (Nat.le_of_succ_le_succ (Nat.le_of_succ_le_succ le)))

theorem held_ends : ∀ {m t : Nat} {as : List Unit}, (m = 0 ∨ m = 5) →
    Trace (Reaching.heldMoves process (fun s t => s ≤ t)) m as t → t = 0 ∨ t = 5
  | _, _, _, at_, .nil _ => at_
  | _, _, _, _, .cons (s := s) (m := m) held rest => match held.1 with
    | .inl ⟨_, five⟩ => held_ends (.inr five) rest
    | .inr ⟨five, three⟩ =>
      absurd (Eq.subst (motive := fun v => 5 ≤ v) three
        (Eq.subst (motive := fun v => v ≤ m) five held.2)) not_five_le_three

/-- **For `≤`, transitive and not symmetric, the two readings differ**: as at the start (`0 ≤ u`)
`3` is reached from `0`, move by move it is not. -/
theorem differs :
    Reach (Reaching.heldMoves process (fun _ u => 0 ≤ u)) 0 3 ∧
      ¬ Reach (Reaching.heldMoves process (fun s t => s ≤ t)) 0 3 :=
  ⟨Reach.trans (Reach.of_step (a := ()) ⟨Or.inl ⟨rfl, rfl⟩, Nat.zero_le 5⟩)
     (Reach.of_step (a := ()) ⟨Or.inr ⟨rfl, rfl⟩, Nat.zero_le 3⟩),
   fun ⟨_, trace⟩ => match held_ends (.inl rfl) trace with
     | .inl three => Nat.noConfusion three
     | .inr three => Nat.noConfusion (Nat.succ.inj (Nat.succ.inj (Nat.succ.inj three)))⟩

end Down

/-! ## Q7. A move above `n` need not change a rule -/

/-- Where `up` lets a rule stay, the move `n + 1`, above `n`, can leave every rule as it is. -/
theorem RuleTower.move_above_keeps {Z R : Type} (base : R → Z → Z → Prop)
    (s : Z × (Nat → R)) (n : Nat) :
    (RuleTower.process base (fun _ _ ρ ρ' => ρ' = ρ)).step s (n + 1) s ∧ n < n + 1 ∧
      RuleTower.SameFrom 0 s s :=
  ⟨⟨rfl, rfl, fun _ _ => rfl⟩, Nat.lt_succ_self n, fun _ _ => rfl⟩

/-! ## Q8. What locating needs without a decision -/

/-- Weakly decided at each index, a refutation of `p` throughout the first `d` indices gives an
index below `d` where `p` fails. -/
theorem exists_not_of_not_forall_lt {p : Nat → Prop} (weak : ∀ i, ¬ p i ∨ ¬ ¬ p i) :
    ∀ d, ¬ (∀ i, i < d → p i) → ∃ i, i < d ∧ ¬ p i
  | 0, notAll => absurd (fun _ lt => absurd lt (Nat.not_lt_zero _)) notAll
  | d + 1, notAll => match weak d with
    | .inl no => ⟨d, Nat.lt_succ_self d, no⟩
    | .inr notNo => match exists_not_of_not_forall_lt weak d (fun below => notNo (fun pd =>
        notAll (fun i lt => match Nat.lt_or_ge i d with
          | .inl earlier => below i earlier
          | .inr late =>
            Eq.subst (motive := p) (Nat.le_antisymm (Nat.le_of_lt_succ lt) late).symm pd))) with
      | ⟨i, lt, no⟩ => ⟨i, Nat.lt_succ_of_lt lt, no⟩

/-- **The module's located law with each step's holding only weakly decided.** -/
theorem Run.held_change_located_weak {S : Type u} {A : Type v} {X : Type} {P : Process S A}
    {Same : S → S → Prop} {adm : S → X → Prop} (r : Run P)
    (weak : ∀ n, ¬ Same (r.state n) (r.state (n + 1)) ∨ ¬ ¬ Same (r.state n) (r.state (n + 1)))
    {N d : Nat} {x : X} (later : Reaching.PossibleHeld P Same adm (r.state (N + d)) x)
    (notNow : ¬ Reaching.PossibleHeld P Same adm (r.state N) x) :
    ∃ n, N ≤ n ∧ n < N + d ∧ ¬ Same (r.state n) (r.state (n + 1)) :=
  match exists_not_of_not_forall_lt (p := fun i => Same (r.state (N + i)) (r.state (N + i + 1)))
      (fun i => weak (N + i)) d
      (fun stays => notNow (r.possible_of_stretch (Q := Reaching.heldMoves P Same) N d
        (fun i before => ⟨r.step (N + i), stays i before⟩) later)) with
  | ⟨i, lt, no⟩ => ⟨N + i, Nat.le_add_right N i, Nat.add_lt_add_left lt N, no⟩

/-- The located law without a decision, asked of every process (one formation). -/
def LocatedLaw : Prop :=
  ∀ (S A : Type) (P : Process S A) (r : Run P) (Same : S → S → Prop) (adm : S → Unit → Prop)
    (N d : Nat), Reaching.PossibleHeld P Same adm (r.state (N + d)) () →
      ¬ Reaching.PossibleHeld P Same adm (r.state N) () →
      ∃ n, N ≤ n ∧ n < N + d ∧ ¬ Same (r.state n) (r.state (n + 1))

namespace Two

/-- Counting up. -/
def process : Process Nat Unit := ⟨fun s _ t => t = s + 1⟩

/-- Its course from `0`. -/
def course : Run process := ⟨fun n => n, fun _ => (), fun _ => rfl⟩

/-- The part held across the first step exactly where `Q`, across the second exactly where not. -/
def Same (Q : Prop) (s _ : Nat) : Prop :=
  match s with
  | 0 => Q
  | 1 => ¬ Q
  | _ + 2 => True

/-- `2` admits the one formation. -/
def adm (s : Nat) (_ : Unit) : Prop := s = 2

theorem from_one {Q : Prop} (q : Q) : ∀ {as : List Unit} {s t : Nat},
    Trace (Reaching.heldMoves process (Same Q)) s as t → s = 1 → t = 2 → False
  | _, _, _, .nil _, one, two => Nat.noConfusion (Nat.succ.inj (one.symm.trans two))
  | _, _, _, .cons (s := s) (m := m) held _, one, _ =>
    (Eq.subst (motive := fun v => Same Q v m) one held.2) q

theorem from_zero {Q : Prop} : ∀ {as : List Unit} {s t : Nat},
    Trace (Reaching.heldMoves process (Same Q)) s as t → s = 0 → t = 2 → False
  | _, _, _, .nil _, zero, two => Nat.noConfusion (zero.symm.trans two)
  | _, _, _, .cons (s := s) (m := m) held rest, zero, two =>
    from_one (Eq.subst (motive := fun v => Same Q v m) zero held.2) rest
      (held.1.trans (congrArg (· + 1) zero)) two

theorem not_now (Q : Prop) : ¬ Reaching.PossibleHeld process (Same Q) adm (course.state 0) () :=
  fun ⟨_, ⟨_, trace⟩, admitted⟩ => from_zero trace rfl admitted

end Two

/-- **The located law without a decision, asked of every process, gives weak excluded middle.** -/
theorem wlem_of_located (law : LocatedLaw) (Q : Prop) : ¬ Q ∨ ¬ ¬ Q :=
  match law Nat Unit Two.process Two.course (Two.Same Q) Two.adm 0 2 ⟨2, Reach.refl _ _, rfl⟩
      (Two.not_now Q) with
  | ⟨0, _, _, no⟩ => .inl no
  | ⟨1, _, _, no⟩ => .inr no
  | ⟨k + 2, _, lt, _⟩ => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 2 k))

/-- **Exactly**: the located law without a decision, asked of every process, is weak excluded
middle. -/
theorem located_iff_wlem : LocatedLaw ↔ ∀ Q : Prop, ¬ Q ∨ ¬ ¬ Q :=
  ⟨wlem_of_located, fun wlem _ _ _ r _ _ _ _ later notNow =>
    Run.held_change_located_weak r (fun _ => wlem _) later notNow⟩

/-! ## Q9. Without the keeps-widening premise, the moments' laws fail -/

section Stays

variable {S : Type u} {A : Type v} {P : Process S A} {Same : S → S → Prop}

/-- Along a course whose every step holds the part, the course's line under the part is unending
from every moment (`«不穷»`). -/
theorem unending_of_stays (r : Run P) (stays : ∀ n, Same (r.state n) (r.state (n + 1))) (N : Nat) :
    «不穷» Steps.next (fun n m => Same (r.state n) (r.state m)) N :=
  Steps.buqiong_iff.mpr (fun n => stays (N + n))

/-- Along such a course no line under the part begins after moment `0`. -/
theorem not_begins_of_stays (r : Run P) (stays : ∀ n, Same (r.state n) (r.state (n + 1)))
    (n : Nat) : ¬ «生» Steps.next (fun i j => Same (r.state i) (r.state j)) (n + 1) :=
  fun begins => begins (Steps.hasPred_iff.mpr (stays n))

end Stays

namespace Stay

/-- `RaisedRule`'s process, staying at rule `0`, position `0`. -/
def course : Run Becoming.RaisedRule.process :=
  ⟨fun _ => (0, 0), fun _ => (), fun _ => Or.inr ⟨rfl, Nat.le_refl 0⟩⟩

/-- **On a course of the module's own witness process, the unpremised sentences fail**: from
every moment the line under the rule held is unending, and after moment `0` no line begins. -/
theorem fails :
    (∀ N, «不穷» Steps.next
      (fun n m => Becoming.RaisedRule.Same (course.state n) (course.state m)) N) ∧
    (∀ n, ¬ «生» Steps.next
      (fun i j => Becoming.RaisedRule.Same (course.state i) (course.state j)) (n + 1)) :=
  ⟨unending_of_stays course (fun _ => rfl), not_begins_of_stays course (fun _ => rfl)⟩

end Stay

end Becoming.RecheckUE11
