import Becoming.Remainder
import Becoming.Recurrence

/-!
# Closing: how loops form within the unfolding

`Becoming.Loops` (P118) shows that only a loop makes a carried difference run away, and
`Becoming.Remainder` (P120) that the loops that matter for a cut are those of the couplings that go
on. Both take the couplings as they stand. On 16 October 2026 Ren took the reading that "which
loops a world has is part of its situation; loops form and dissolve within the unfolding, and the
theorems take them as they stand at each step", pending "a loop-formation theorem". This module
states how loops form, within the theory without axiom and with no premise beyond the strengths each statement names.

* **Loops formed by a step.** The strengths before step `T` (`strengthsBefore`) keep the couplings
  acting at steps before `T` and drop the rest. A coupling of them is a coupling acting before `T`
  (`couples_before_iff`, in `Becoming.Remainder`'s `CouplesAt`); they rise with `T`
  (`couples_before_mono`). The loops formed by `T` are the loops of these. Every chain of
  couplings is formed by some step (`coupled_formed`), so the loops a world has are exactly the
  loops formed by some step (`onLoop_iff_formed`), and likewise what lies upstream
  (`upstream_iff_formed`).
* **A loop forms by closing.** The loops formed by step `T + 1` are those formed by step `T` and
  those through a coupling acting at step `T` that closes a chain: the coupling reads a level of a
  condition `d` and gives to a condition `c` from which a chain already leads, through the loop's
  condition, to `d` (`onLoop_succ_iff`). So a loop that forms at a step passes through a coupling
  acting at that step (`forms_by_closing`). An exchange coming to respond to the level of the
  condition it gives to forms a loop of one (`responds_to_own_level`). Chains join
  (`Coupled.append`), and a coupling with chains into and out of a condition closes a loop through
  it (`onLoop_of_closing`).
* **Before a loop forms.** The carried amount up to step `T` reads only the couplings acting before
  `T` (`carried_before`). So where no loop formed by `T` lies upstream of `c`, the carried amount
  at `c` up to `T` is at most a polynomial in the steps of degree one less than the number of listed
  conditions, whatever the couplings do later (`carried_le_polynomial_before`). The amounts up to
  the step a loop forms need not show whether it will: a self-loop forming at step `T`
  (`Closing.Onset`, a witness) carries the starting gap unchanged up to `T` and doubles it at every step after
  (`Onset.amount_before`, `Onset.amount_after`); it forms at `T` and not before (`Onset.forms`,
  `Onset.not_formed`), and one forming at any later step carries the same amounts up to `T`
  (`Onset.unforeseen`).
* **Couplings read off the course.** Where a law's strengths at each step are read from the levels
  so far (`ReadsBefore`), the law that gives what its read strengths make of the levels
  (`ExchangeLaw.carryingRead`) generates a course (`formedCourse`) that is the carried amount of the
  strengths it reads (`formedCourse_eq_carried`). Everything above then holds of the couplings the
  course itself forms: which loops form, and when, is read off the unfolding. In the threshold
  witness (`Closing.Threshold`) a steady gap of the part raises a level by one at each step, and the
  exchange with that condition responds to its level once the level has reached `θ`. The level is
  `t` up to `θ` (`Threshold.level_before`); the loop forms at step `θ` and not before
  (`Threshold.forms`, `Threshold.not_formed`); from then the level plus one doubles at every step
  (`Threshold.level_after`); and up to `θ` the course is the same for every threshold beyond it
  (`Threshold.unforeseen`).

**Readings (the AI's, taken by Ren on 16 October 2026; the second revised on 27 October 2026, board item DF2,
since `Onset.unforeseen` and `Threshold.unforeseen` are witnesses).**
- Loops form within the unfolding by closing: a loop forms at the step at which some exchange comes
  to respond to a level downstream of the condition it gives to. Where the strengths are read off
  the course, as in the threshold witness, the couplings, and so the loops, are part of what the
  unfolding forms. This is the theorem Ren's reading 3 of `Becoming.Loops` was left pending for;
  the reading can now say that loops form and dissolve within the unfolding by this closing, and
  that the theorems take them as they stand at each step.
- A loop's formation need not be foreseen from the amounts before it. Before it forms the growth
  is at most polynomial; in the witnesses the course so far does not show the step it forms
  (`Onset.unforeseen`, `Threshold.unforeseen`), and the amounts after it grow geometrically. This
  meets `Becoming.Runaway`: a runaway's break does not show before it, and the formation of the
  loop that runs away need not show either, in the amounts it carries. What can show it is what reads the couplings themselves (in the threshold
  witness, the distance of the level to `θ`).
- How loops dissolve is the other side, stated in `Becoming.Remainder` (couplings that stop: a loop
  whose couplings stop carries what a finite order carries).

What is not derived: which strengths a world reads off its course (the read strengths are
supplied, as the strengths are in `Becoming.Propagation`); laws whose strengths respond to levels
other than through such a reading; a characterization of when a loop of read strengths forms for
every law; real amounts and continuous time. The representation commits to discrete steps and
natural amounts. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

variable {F C : Type}

/-! ## Loops formed by a step -/

section Formed

variable {cs : List C} {part : F → Bool} {σ : Nat → F → C → Nat}
  {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F} {δ : C → Nat}

/-- **The strengths before step `T`.** The couplings acting at steps before `T`, the rest dropped. -/
def strengthsBefore (T : Nat) (k : Nat → F → C → Nat → C → Nat) : Nat → F → C → Nat → C → Nat :=
  fun u h c s d => bif Nat.ble T u then 0 else k u h c s d

theorem strengthsBefore_before {T u : Nat} (lt : u < T) (h : F) (c : C) (s : Nat) (d : C) :
    strengthsBefore T k u h c s d = k u h c s d :=
  congrArg (fun b => bif b then 0 else k u h c s d) (Naturals.ble_false_of_lt lt)

theorem strengthsBefore_from {T u : Nat} (le : T ≤ u) (h : F) (c : C) (s : Nat) (d : C) :
    strengthsBefore T k u h c s d = 0 :=
  congrArg (fun b => bif b then 0 else k u h c s d) (Nat.ble_eq_true_of_le le)

/-- The strengths before a step are at most the strengths. -/
theorem strengthsBefore_le (T u : Nat) (h : F) (c : C) (s : Nat) (d : C) :
    strengthsBefore T k u h c s d ≤ k u h c s d :=
  match Nat.lt_or_ge u T with
  | .inl lt => Nat.le_of_eq (strengthsBefore_before lt h c s d)
  | .inr ge => Nat.le_trans (Nat.le_of_eq (strengthsBefore_from ge h c s d)) (Nat.zero_le _)

/-- **A coupling of the strengths before `T` is a coupling acting before `T`.** -/
theorem couplesAt_before_iff {T u s : Nat} {d c : C} :
    CouplesAt cs part (strengthsBefore T k) present u s d c ↔
      u < T ∧ CouplesAt cs part k present u s d c :=
  ⟨fun ⟨h, mem, out, le, dMem, pos⟩ =>
    match Nat.lt_or_ge u T with
    | .inl lt => ⟨lt, h, mem, out, le, dMem,
        Nat.lt_of_lt_of_le pos (Nat.le_of_eq (strengthsBefore_before lt h c s d))⟩
    | .inr ge => absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq (strengthsBefore_from ge h c s d)))
        (Nat.lt_irrefl 0),
   fun ⟨lt, h, mem, out, le, dMem, pos⟩ => ⟨h, mem, out, le, dMem,
     Nat.lt_of_lt_of_le pos (Nat.le_of_eq (strengthsBefore_before lt h c s d).symm)⟩⟩

/-- **The couplings formed by `T`** are the couplings acting at some step before `T`. -/
theorem couples_before_iff {T : Nat} {d c : C} :
    Couples cs part (strengthsBefore T k) present d c ↔
      ∃ u s, u < T ∧ CouplesAt cs part k present u s d c :=
  ⟨fun couples => match couples_iff_couplesAt.mp couples with
    | ⟨u, s, at_⟩ => match couplesAt_before_iff.mp at_ with
      | ⟨lt, at_⟩ => ⟨u, s, lt, at_⟩,
   fun ⟨u, s, lt, at_⟩ => couples_iff_couplesAt.mpr ⟨u, s, couplesAt_before_iff.mpr ⟨lt, at_⟩⟩⟩

/-- The couplings formed by a step stay formed. -/
theorem couples_before_mono {T T' : Nat} (le : T ≤ T') {d c : C}
    (couples : Couples cs part (strengthsBefore T k) present d c) :
    Couples cs part (strengthsBefore T' k) present d c :=
  match couples_before_iff.mp couples with
  | ⟨u, s, lt, at_⟩ => couples_before_iff.mpr ⟨u, s, Nat.lt_of_lt_of_le lt le, at_⟩

/-- A coupling formed by a step is a coupling. -/
theorem couples_of_before {T : Nat} {d c : C}
    (couples : Couples cs part (strengthsBefore T k) present d c) : Couples cs part k present d c :=
  match couples_before_iff.mp couples with
  | ⟨u, s, _, at_⟩ => couples_iff_couplesAt.mpr ⟨u, s, at_⟩

/-- A coupling acting at `u` is formed by `u + 1`. -/
theorem couples_before_of_couplesAt {u s : Nat} {d c : C}
    (at_ : CouplesAt cs part k present u s d c) :
    Couples cs part (strengthsBefore (u + 1) k) present d c :=
  couples_before_iff.mpr ⟨u, s, Nat.lt_succ_self u, at_⟩

variable {k' : Nat → F → C → Nat → C → Nat}

/-- Chains carry over to strengths with more couplings. -/
theorem Coupled.lift (more : ∀ d c, Couples cs part k present d c → Couples cs part k' present d c)
    {v : Nat → C} {j : Nat} (chain : Coupled cs part k present v j) : Coupled cs part k' present v j :=
  fun i lt => more _ _ (chain i lt)

theorem OnLoop.lift (more : ∀ d c, Couples cs part k present d c → Couples cs part k' present d c)
    {e : C} : OnLoop cs part k present e → OnLoop cs part k' present e
  | ⟨v, m, pos, start, back, chain⟩ => ⟨v, m, pos, start, back, Coupled.lift more chain⟩

theorem Upstream.lift (more : ∀ d c, Couples cs part k present d c → Couples cs part k' present d c)
    {e c : C} : Upstream cs part k present e c → Upstream cs part k' present e c
  | ⟨v, j, start, ends, chain⟩ => ⟨v, j, start, ends, Coupled.lift more chain⟩

/-- **Every chain is formed by some step.** -/
theorem coupled_formed {v : Nat → C} :
    ∀ {m : Nat}, Coupled cs part k present v m →
      ∃ T, Coupled cs part (strengthsBefore T k) present v m
  | 0, _ => ⟨0, fun i lt => absurd lt (Nat.not_lt_zero i)⟩
  | m + 1, chain =>
    match coupled_formed (m := m) (fun i lt => chain i (Nat.lt_succ_of_lt lt)),
      couples_iff_couplesAt.mp (chain m (Nat.lt_succ_self m)) with
    | ⟨T, first⟩, ⟨u, s, at_⟩ =>
      ⟨T + (u + 1), fun i lt =>
        match Nat.lt_or_ge i m with
        | .inl before => couples_before_mono (Nat.le_add_right T (u + 1)) (first i before)
        | .inr after => by
          have same : i = m := Nat.le_antisymm (Nat.le_of_lt_succ lt) after
          subst same
          exact couples_before_mono (Nat.le_add_left (u + 1) T) (couples_before_of_couplesAt at_)⟩

/-- **The loops a world has are the loops formed by some step.** -/
theorem onLoop_iff_formed {e : C} :
    OnLoop cs part k present e ↔ ∃ T, OnLoop cs part (strengthsBefore T k) present e :=
  ⟨fun ⟨_, _, pos, start, back, chain⟩ => match coupled_formed chain with
    | ⟨T, formed⟩ => ⟨T, _, _, pos, start, back, formed⟩,
   fun ⟨_, loop⟩ => OnLoop.lift (fun _ _ => couples_of_before) loop⟩

/-- **What lies upstream is what lies upstream by some step.** -/
theorem upstream_iff_formed {e c : C} :
    Upstream cs part k present e c ↔ ∃ T, Upstream cs part (strengthsBefore T k) present e c :=
  ⟨fun ⟨_, _, start, ends, chain⟩ => match coupled_formed chain with
    | ⟨T, formed⟩ => ⟨T, _, _, start, ends, formed⟩,
   fun ⟨_, up⟩ => Upstream.lift (fun _ _ => couples_of_before) up⟩

end Formed

/-! ## A loop forms by closing -/

section Closing

variable {cs : List C} {part : F → Bool} {k : Nat → F → C → Nat → C → Nat}
  {present : Nat → List F}

/-- `v` up to `i`, then `w` from `i` on. -/
def Closing.join (v w : Nat → C) (i : Nat) : Nat → C :=
  fun l => bif Nat.ble l i then v l else w (l - i)

theorem Closing.join_below {v w : Nat → C} {i l : Nat} (le : l ≤ i) : Closing.join v w i l = v l :=
  congrArg (fun b => bif b then v l else w (l - i)) (Nat.ble_eq_true_of_le le)

theorem Closing.join_from {v w : Nat → C} {i : Nat} (meet : v i = w 0) :
    ∀ r, Closing.join v w i (i + r) = w r
  | 0 => (Closing.join_below (Nat.le_refl i)).trans meet
  | r + 1 =>
    (congrArg (fun b => bif b then v (i + (r + 1)) else w (i + (r + 1) - i))
      (Naturals.ble_false_of_lt (Nat.lt_of_lt_of_le (Nat.lt_succ_self i)
        (Nat.add_le_add_left (Nat.succ_pos r) i)))).trans
      (congrArg w (Naturals.add_sub_cancel_left i (r + 1)))

/-- **Chains join.** A chain ending where another starts, followed by it. -/
theorem Coupled.append {v w : Nat → C} {i j : Nat} (cv : Coupled cs part k present v i)
    (cw : Coupled cs part k present w j) (meet : v i = w 0) :
    Coupled cs part k present (Closing.join v w i) (i + j) := by
  intro l lt
  cases Nat.lt_or_ge l i with
  | inl before =>
    rw [Closing.join_below (Nat.le_of_lt before), Closing.join_below before]
    exact cv l before
  | inr after =>
    obtain ⟨r, split⟩ := le_dest after
    subst split
    rw [Closing.join_from meet r,
      show i + r + 1 = i + (r + 1) from rfl, Closing.join_from meet (r + 1)]
    exact cw r (Naturals.le_of_add_le_add_left (k := i) lt)

/-- A chain of one coupling. -/
theorem Coupled.one {d c : C} (couples : Couples cs part k present d c) :
    Coupled cs part k present (fun l => bif Nat.ble l 0 then d else c) 1
  | 0, _ => couples
  | i + 1, lt => absurd (Nat.lt_of_succ_lt_succ lt) (Nat.not_lt_zero i)

/-- **Upstream is within the closure of coupling.** Where a chain of couplings leads from `e` to
`c`, `c` lies within `e`'s closure under coupling (`«线则所闭»`, the chain read as a line). -/
theorem Upstream.within {e c : C} (up : Upstream cs part k present e c) :
    WithinClosure (Couples cs part k present) e c :=
  match up with
  | ⟨v, j, start, finish, chain⟩ =>
    Eq.subst (motive := fun x => «所闭» (Couples cs part k present) e x) finish
      (Eq.subst (motive := fun x => «所闭» (Couples cs part k present) x (v j)) start
        («线则所闭» (R := Couples cs part k present) chain j (Nat.le_refl j)))

/-- **A reach of couplings is a chain.** Where `x` reaches `y` by couplings, a chain of one
coupling or more leads from `x` to `y`. -/
theorem Coupled.of_reach {x y : C} :
    «及» (Couples cs part k present) x y →
      ∃ (v : Nat → C) (m : Nat), 0 < m ∧ v 0 = x ∧ v m = y ∧ Coupled cs part k present v m
  | .one h => ⟨_, 1, Nat.succ_pos 0, rfl, rfl, Coupled.one h⟩
  | .more h rest => match Coupled.of_reach rest with
    | ⟨w, m, _, start, finish, chain⟩ =>
      ⟨Closing.join (fun l => bif Nat.ble l 0 then x else _) w 1, 1 + m,
        Nat.lt_of_lt_of_le (Nat.succ_pos 0) (Nat.le_add_right 1 m),
        Closing.join_below (Nat.zero_le 1), (Closing.join_from start.symm m).trans finish,
        Coupled.append (Coupled.one h) chain start.symm⟩

/-- **A coupling with chains into and out of a condition closes a loop through it.** Where `d` is
coupled into `c`, a chain leads from `c` to `e` and another from `e` to `d`, `e` lies on a loop:
`d` reaches `e`, its coupling into `c` followed by what lies within `c`'s closure
(`«及当且仅当一步而所闭»`), and `e` is `d` or reaches it (`«所闭当且仅当同一或及»`), so `e`
reaches itself (`«及之传递»`), and a reach of couplings is a chain (`Coupled.of_reach`). -/
theorem onLoop_of_closing {d c e : C} (couples : Couples cs part k present d c)
    (into : Upstream cs part k present c e) (outOf : Upstream cs part k present e d) :
    OnLoop cs part k present e :=
  have reaches : «及» (Couples cs part k present) d e :=
    «及当且仅当一步而所闭».mpr ⟨c, couples, Upstream.within into⟩
  Coupled.of_reach (match «所闭当且仅当同一或及».mp (Upstream.within outOf) with
    | .inl same => Eq.subst (motive := fun x => «及» (Couples cs part k present) x e) same.symm reaches
    | .inr before => «及之传递» before reaches)

/-- A condition lies upstream of itself. -/
theorem Upstream.refl (c : C) : Upstream cs part k present c c :=
  ⟨fun _ => c, 0, rfl, rfl, fun i lt => absurd lt (Nat.not_lt_zero i)⟩

/-- A chain formed by `T + 1` is formed by `T`, or one of its couplings acts at step `T`. -/
theorem Closing.split {T : Nat} {v : Nat → C} :
    ∀ {m : Nat}, Coupled cs part (strengthsBefore (T + 1) k) present v m →
      Coupled cs part (strengthsBefore T k) present v m ∨
        ∃ i s, i < m ∧ CouplesAt cs part k present T s (v i) (v (i + 1))
  | 0, _ => .inl fun i lt => absurd lt (Nat.not_lt_zero i)
  | m + 1, chain =>
    match Closing.split (m := m) (fun i lt => chain i (Nat.lt_succ_of_lt lt)) with
    | .inr ⟨i, s, lt, at_⟩ => .inr ⟨i, s, Nat.lt_succ_of_lt lt, at_⟩
    | .inl first =>
      match couples_before_iff.mp (chain m (Nat.lt_succ_self m)) with
      | ⟨u, s, lt, at_⟩ =>
        match Nat.lt_or_ge u T with
        | .inl early => .inl fun i lt' =>
          match Nat.lt_or_ge i m with
          | .inl before => first i before
          | .inr after => by
            have same : i = m := Nat.le_antisymm (Nat.le_of_lt_succ lt') after
            subst same
            exact couples_before_iff.mpr ⟨u, s, early, at_⟩
        | .inr late => by
          have same : u = T := Nat.le_antisymm (Nat.le_of_lt_succ lt) late
          subst same
          exact .inr ⟨m, s, Nat.lt_succ_self m, at_⟩

/-- **A loop forms by closing.** The loops formed by step `T + 1` are the loops formed by step `T`
and the loops through a coupling acting at step `T` that closes a chain: it reads a level of `d`
and gives to `c`, and chains lead from `c` to the loop's condition and from it to `d`. -/
theorem onLoop_succ_iff {T : Nat} {e : C} :
    OnLoop cs part (strengthsBefore (T + 1) k) present e ↔
      OnLoop cs part (strengthsBefore T k) present e ∨
        ∃ d c s, CouplesAt cs part k present T s d c ∧
          Upstream cs part (strengthsBefore (T + 1) k) present c e ∧
            Upstream cs part (strengthsBefore (T + 1) k) present e d :=
  ⟨fun ⟨v, m, pos, start, back, chain⟩ =>
    match Closing.split chain with
    | .inl early => .inl ⟨v, m, pos, start, back, early⟩
    | .inr ⟨i, s, lt, at_⟩ =>
      match gap_of_lt lt with
      | ⟨r, split⟩ =>
        .inr ⟨v i, v (i + 1), s, at_,
          ⟨fun l => v (i + 1 + l), r, rfl,
            (congrArg v ((Nat.add_right_comm i 1 r).trans split.symm)).trans back,
            fun l lt' => chain (i + 1 + l)
              (Nat.lt_of_lt_of_le (Nat.add_lt_add_left lt' (i + 1))
                (Nat.le_of_eq ((Nat.add_right_comm i 1 r).trans split.symm)))⟩,
          ⟨v, i, start, rfl, fun l lt' => chain l (Nat.lt_trans lt' lt)⟩⟩,
   fun formed => match formed with
    | .inl early => OnLoop.lift (fun _ _ => couples_before_mono (Nat.le_succ T)) early
    | .inr ⟨_, _, s, at_, into, outOf⟩ =>
      onLoop_of_closing (couples_before_iff.mpr ⟨T, s, Nat.lt_succ_self T, at_⟩) into outOf⟩

/-- **A loop that forms passes through a coupling acting at the step it forms.** -/
theorem forms_by_closing {T : Nat} {e : C}
    (now : OnLoop cs part (strengthsBefore (T + 1) k) present e)
    (before : ¬ OnLoop cs part (strengthsBefore T k) present e) :
    ∃ d c s, CouplesAt cs part k present T s d c ∧
      Upstream cs part (strengthsBefore (T + 1) k) present c e ∧
        Upstream cs part (strengthsBefore (T + 1) k) present e d :=
  match onLoop_succ_iff.mp now with
  | .inl early => absurd early before
  | .inr closing => closing

/-- **An exchange coming to respond to the level it gives to forms a loop of one.** -/
theorem responds_to_own_level {T s : Nat} {c : C} (at_ : CouplesAt cs part k present T s c c) :
    OnLoop cs part (strengthsBefore (T + 1) k) present c :=
  onLoop_succ_iff.mpr (.inr ⟨c, c, s, at_, Upstream.refl c, Upstream.refl c⟩)

end Closing

/-! ## Before a loop forms -/

section Before

variable {cs : List C} {part : F → Bool} {σ : Nat → F → C → Nat}
  {k : Nat → F → C → Nat → C → Nat} {present : Nat → List F} {δ : C → Nat}

/-- What a formation gives with strengths that agree at its step. -/
theorem carriedGive_congr_strength {k' : Nat → F → C → Nat → C → Nat} {t : Nat} {h : F} {c : C}
    {l : Nat → C → Nat} (same : ∀ s d, k' t h c s d = k t h c s d) :
    carriedGive cs part σ k' t h c l = carriedGive cs part σ k t h c l := by
  cases hp : part h with
  | true => rw [carriedGive_of_part hp, carriedGive_of_part hp]
  | false =>
    rw [carriedGive_of_rest hp, carriedGive_of_rest hp]
    exact total_congr (fun s => total_congr (fun d => congrArg (· * l s d) (same s d)) cs) _

/-- **The carried amount up to `T` reads only the couplings acting before `T`.** -/
theorem carried_before {T : Nat} :
    ∀ t, t ≤ T → ∀ s, s ≤ t → ∀ c,
      carried cs part σ (strengthsBefore T k) present δ s c = carried cs part σ k present δ s c
  | 0, _, s, le, c => by
    have zero : s = 0 := Nat.eq_zero_of_le_zero le
    subst zero
    rfl
  | t + 1, le, s, le', c =>
    match le_succ_cases le' with
    | .inl before => carried_before t (Nat.le_of_succ_le le) s before c
    | .inr now => by
      subst now
      exact (carried_succ t c).trans ((Naturals.add_congr
        (carried_before t (Nat.le_of_succ_le le) t (Nat.le_refl t) c)
        (total_congr (fun h =>
          (carriedGive_congr_strength fun s d => strengthsBefore_before le h c s d).trans
            (carriedGive_congr fun s d sle _ _ _ =>
              carried_before t (Nat.le_of_succ_le le) s sle d)) _)).trans
        (carried_succ t c).symm)

/-- The strengths into a condition before a step are at most the strengths into it. -/
theorem inflow_before_le (T t : Nat) (c : C) :
    inflow cs part (strengthsBefore T k) present t c ≤ inflow cs part k present t c :=
  total_le _ fun h _ => match part h with
    | true => Nat.le_refl 0
    | false => total_le _ fun s _ => total_le _ fun d _ => strengthsBefore_le T t h c s d

/-- **Before a loop forms upstream, the growth is at most polynomial.** With every condition
listed, the part giving no gap after the start, starting gaps at most `D` and the strengths into
each condition summing to at most `M` at each step: where no loop formed by step `T` lies upstream
of `c`, the carried amount at `c` at every step up to `T` is at most `D` times a polynomial in the
steps of degree one less than the number of listed conditions, whatever the couplings do later. -/
theorem carried_le_polynomial_before (every : ∀ c, c ∈ cs) {T : Nat} {c : C}
    (noLoop : ∀ e, Upstream cs part (strengthsBefore T k) present e c →
      ¬ OnLoop cs part (strengthsBefore T k) present e)
    {n : Nat} (long : cs.length ≤ n + 1) {M D : Nat} (start : ∀ c, δ c ≤ D)
    (into : ∀ t c, inflow cs part k present t c ≤ M) {t : Nat} (le : t ≤ T) :
    carried cs part (fun _ _ _ => 0) k present δ t c ≤ D * Loops.orderSum M n t :=
  Nat.le_trans (Nat.le_of_eq (carried_before t le t (Nat.le_refl t) c).symm)
    (carried_le_polynomial every noLoop long start
      (fun t c => Nat.le_trans (inflow_before_le T t c) (into t c)) t)

end Before

/-! ## A loop forming at a step -/

namespace Closing.Onset

/-- A self-loop of strength one that acts from step `T` on. -/
def strengths (T : Nat) : Nat → Unit → Unit → Nat → Unit → Nat :=
  fun u h c s d => bif Nat.ble T u then Loops.SelfLoop.strengths 1 u h c s d else 0

/-- What the self-loop forming at `T` carries from the starting gap `D`. -/
def amount (T D : Nat) : Nat → Nat :=
  fun t => carried [()] (fun _ => false) (fun _ _ _ => 0) (strengths T) (fun _ => [()])
    (fun _ => D) t ()

theorem strengths_early {T u : Nat} (lt : u < T) (h c : Unit) (s : Nat) (d : Unit) :
    strengths T u h c s d = Loops.SelfLoop.strengths 0 u h c s d :=
  (congrArg (fun b => bif b then Loops.SelfLoop.strengths 1 u h c s d else 0)
    (Naturals.ble_false_of_lt lt)).trans (Propagation.cond_same (Nat.beq s u) 0).symm

theorem strengths_late {T u : Nat} (le : T ≤ u) (h c : Unit) (s : Nat) (d : Unit) :
    strengths T u h c s d = Loops.SelfLoop.strengths 1 u h c s d :=
  congrArg (fun b => bif b then Loops.SelfLoop.strengths 1 u h c s d else 0)
    (Nat.ble_eq_true_of_le le)

theorem amount_succ_early {T D t : Nat} (lt : t < T) : amount T D (t + 1) = amount T D t :=
  (carried_succ t ()).trans ((congrArg (amount T D t + ·)
    ((total_congr (fun h => carriedGive_congr_strength fun s d => strengths_early lt h () s d)
      [()]).trans ((Loops.SelfLoop.give 0 t _).trans (Nat.zero_mul _)))).trans (Nat.add_zero _))

theorem amount_succ_late {T D t : Nat} (le : T ≤ t) :
    amount T D (t + 1) = amount T D t + amount T D t :=
  (carried_succ t ()).trans (congrArg (amount T D t + ·)
    ((total_congr (fun h => carriedGive_congr_strength fun s d => strengths_late le h () s d)
      [()]).trans ((Loops.SelfLoop.give 1 t _).trans (Nat.one_mul _))))

/-- **Up to the step it forms, the loop carries the starting gap unchanged.** -/
theorem amount_before {T D : Nat} : ∀ t, t ≤ T → amount T D t = D
  | 0, _ => rfl
  | t + 1, le => (amount_succ_early le).trans (amount_before t (Nat.le_of_succ_le le))

/-- **From the step it forms, it doubles at every step.** -/
theorem amount_after (T D : Nat) : ∀ r, amount T D (T + r) = D * 2 ^ r
  | 0 => (amount_before T (Nat.le_refl T)).trans (Nat.mul_one D).symm
  | r + 1 => (amount_succ_late (Nat.le_add_right T r)).trans
      ((Naturals.add_congr (amount_after T D r) (amount_after T D r)).trans
        ((Nat.left_distrib D _ _).symm.trans (congrArg (D * ·) (Loops.two_pow_succ r).symm)))

/-- **It forms at step `T`.** -/
theorem forms (T : Nat) :
    OnLoop [()] (fun _ => false) (strengthsBefore (T + 1) (strengths T)) (fun _ => [()]) () :=
  responds_to_own_level ⟨(), .head _, rfl, Nat.le_refl T, .head _,
    Nat.lt_of_lt_of_le (Nat.succ_pos 0) (Nat.le_of_eq
      ((congrArg (fun b => bif b then (1 : Nat) else 0) (beq_self T)).symm.trans
        (strengths_late (Nat.le_refl T) () () T ()).symm))⟩

/-- **It is not formed before step `T`.** -/
theorem not_formed (T : Nat) :
    ¬ OnLoop [()] (fun _ => false) (strengthsBefore T (strengths T)) (fun _ => [()]) () :=
  fun ⟨_, _, pos, _, _, chain⟩ =>
    match couples_before_iff.mp (chain 0 pos) with
    | ⟨u, s, lt, _, _, _, _, _, positive⟩ =>
      absurd (Nat.lt_of_lt_of_le positive (Nat.le_of_eq
        ((strengths_early lt () () s ()).trans (Propagation.cond_same (Nat.beq s u) 0))))
        (Nat.lt_irrefl 0)

/-- **The amounts before it forms do not show whether it will.** A loop forming at step `T` and
one forming at any later step carry the same amounts at every step up to `T`. -/
theorem unforeseen {T T' D t : Nat} (later : T ≤ T') (le : t ≤ T) :
    amount T D t = amount T' D t :=
  (amount_before t le).trans (amount_before t (Nat.le_trans le later)).symm

end Closing.Onset

/-! ## Couplings read off the course -/

section Read

variable {cs : List C} {part : F → Bool} {σ : Nat → F → C → Nat} {present : Nat → List F}
  {δ : C → Nat} {κ : (Nat → C → Nat) → Nat → F → C → Nat → C → Nat}

/-- **Strengths read from the levels so far.** At each step the strengths depend on the levels up
to that step only. -/
def ReadsBefore (κ : (Nat → C → Nat) → Nat → F → C → Nat → C → Nat) : Prop :=
  ∀ t l l', AgreeUpTo l l' t → ∀ h c s d, κ l t h c s d = κ l' t h c s d

/-- **The carrying law with read strengths.** The part gives its gaps, each formation outside it
what the strengths read from the levels make of them, and nothing is taken. -/
def ExchangeLaw.carryingRead (cs : List C) (part : F → Bool) (σ : Nat → F → C → Nat)
    (κ : (Nat → C → Nat) → Nat → F → C → Nat → C → Nat) : ExchangeLaw F C :=
  ⟨fun _ _ _ _ => 0, fun t h l c => carriedGive cs part σ (κ l) t h c l⟩

/-- The course the carrying law with read strengths generates. -/
def formedCourse (cs : List C) (part : F → Bool) (σ : Nat → F → C → Nat)
    (κ : (Nat → C → Nat) → Nat → F → C → Nat → C → Nat) (present : Nat → List F)
    (δ : C → Nat) : Nat → C → Nat :=
  (ExchangeLaw.carryingRead cs part σ κ).levels present δ

/-- With strengths read from the levels so far, the law reads what has stood. -/
theorem ExchangeLaw.carryingRead_nonanticipating (reads : ReadsBefore κ) :
    (ExchangeLaw.carryingRead cs part σ κ).Nonanticipating :=
  fun t h l l' agree c =>
    ⟨rfl, (carriedGive_congr_strength fun s d => reads t l l' agree h c s d).trans
      (carriedGive_congr fun s d le _ _ _ => agree s le d)⟩

/-- Across each step the course grows by what the strengths read from it make of it. -/
theorem formedCourse_succ (reads : ReadsBefore κ) (t : Nat) (c : C) :
    formedCourse cs part σ κ present δ (t + 1) c =
      formedCourse cs part σ κ present δ t c +
        total (present t) fun h => carriedGive cs part σ (κ (formedCourse cs part σ κ present δ))
          t h c (formedCourse cs part σ κ present δ) :=
  have totals := ExchangeLaw.totals_under (start := δ)
    (ExchangeLaw.carryingRead_nonanticipating (cs := cs) (part := part) (σ := σ) reads) t c
  ((ExchangeLaw.carryingRead cs part σ κ).levels_succ (present := present) (start := δ) t c).trans
    ((congrArg (fun x => _ + _ - x) (totals.1.trans (total_zero (present t)))).trans
      ((Nat.sub_zero _).trans (congrArg (formedCourse cs part σ κ present δ t c + ·) totals.2)))

/-- **The course is the carried amount of the strengths it reads.** -/
theorem formedCourse_eq_carried (reads : ReadsBefore κ) :
    ∀ t c, formedCourse cs part σ κ present δ t c =
      carried cs part σ (κ (formedCourse cs part σ κ present δ)) present δ t c :=
  have upto : ∀ t s, s ≤ t → ∀ c, formedCourse cs part σ κ present δ s c =
      carried cs part σ (κ (formedCourse cs part σ κ present δ)) present δ s c := by
    intro t
    induction t with
    | zero =>
      intro s le c
      have zero : s = 0 := Nat.eq_zero_of_le_zero le
      subst zero
      rfl
    | succ t ih =>
      intro s le c
      cases le_succ_cases le with
      | inl before => exact ih s before c
      | inr now =>
        subst now
        exact (formedCourse_succ reads t c).trans ((Naturals.add_congr (ih t (Nat.le_refl t) c)
          (total_congr (fun _ => carriedGive_congr fun s d sle _ _ _ => ih s sle d) _)).trans
          (carried_succ t c).symm)
  fun t c => upto t t (Nat.le_refl t) c

end Read

/-! ## A loop forming where a level reaches a threshold -/

namespace Closing.Threshold

/-- The exchange of the formation outside the part with the one condition responds to its current
level once that level has reached `θ`. -/
def reading (θ : Nat) : (Nat → Unit → Nat) → Nat → Bool → Unit → Nat → Unit → Nat :=
  fun l u _ _ s _ => bif Nat.beq s u then (bif Nat.ble θ (l u ()) then 1 else 0) else 0

theorem reads (θ : Nat) : ReadsBefore (reading θ) :=
  fun t _ _ agree _ _ s _ =>
    congrArg (fun x => bif Nat.beq s t then (bif Nat.ble θ x then 1 else 0) else 0)
      (agree t (Nat.le_refl t) ())

/-- The level of the one condition: a steady gap of one from the part, the formation outside it
responding once the level has reached `θ`. -/
def level (θ : Nat) : Nat → Nat :=
  fun t => formedCourse [()] (fun h => h) (fun _ _ _ => 1) (reading θ) (fun _ => [true, false])
    (fun _ => 0) t ()

/-- The read strengths of the course. -/
def strengths (θ : Nat) : Nat → Bool → Unit → Nat → Unit → Nat :=
  reading θ (formedCourse [()] (fun h => h) (fun _ _ _ => 1) (reading θ) (fun _ => [true, false]) (fun _ => 0))

theorem strengths_eq (θ u : Nat) (h : Bool) (c : Unit) (s : Nat) (d : Unit) :
    strengths θ u h c s d = bif Nat.beq s u then (bif Nat.ble θ (level θ u) then 1 else 0) else 0 :=
  rfl

/-- Across each step the level rises by one, and by itself once it has reached `θ`. -/
theorem level_succ (θ t : Nat) :
    level θ (t + 1) = level θ t + (1 + ((bif Nat.ble θ (level θ t) then 1 else 0) * level θ t)) :=
  (formedCourse_succ (reads θ) t ()).trans (congrArg (level θ t + ·)
    (show 1 + ((total (steps 0 (t + 1)) fun s =>
        (bif Nat.beq s t then (bif Nat.ble θ (level θ t) then 1 else 0) else 0) * level θ s + 0) +
          0) = _ from
      congrArg (1 + ·) ((Nat.add_zero _).trans ((Propagation.total_steps_at (fun s ne =>
        match hb : Nat.beq s t with
        | true => absurd (Nat.eq_of_beq_eq_true hb) ne
        | false => (congrArg (fun b =>
              (bif b then (bif Nat.ble θ (level θ t) then 1 else 0) else 0) * level θ s + 0) hb).trans
            ((Nat.add_zero _).trans (Nat.zero_mul _)))).trans
        ((Nat.add_zero _).trans (congrArg (fun b =>
          (bif b then (bif Nat.ble θ (level θ t) then 1 else 0) else 0) * level θ t)
          (beq_self t)))))))

/-- **Up to the threshold the level rises by one at each step.** -/
theorem level_before (θ : Nat) : ∀ t, t ≤ θ → level θ t = t
  | 0, _ => rfl
  | t + 1, le =>
    have below : level θ t = t := level_before θ t (Nat.le_of_succ_le le)
    (level_succ θ t).trans
      ((congrArg (fun x => x + (1 + ((bif Nat.ble θ x then 1 else 0) * x))) below).trans
        (congrArg (fun b => t + (1 + ((bif b then 1 else 0) * t)))
          (Naturals.ble_false_of_lt le) |>.trans
          (congrArg (fun x => t + (1 + x)) (Nat.zero_mul t))))

/-- The level never falls. -/
theorem level_le_succ (θ t : Nat) : level θ t ≤ level θ (t + 1) :=
  Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq (level_succ θ t).symm)

theorem level_ge (θ : Nat) : ∀ r, θ ≤ level θ (θ + r)
  | 0 => Nat.le_of_eq (level_before θ θ (Nat.le_refl θ)).symm
  | r + 1 => Nat.le_trans (level_ge θ r) (level_le_succ θ (θ + r))

/-- **From the threshold on, the level plus one doubles at every step.** -/
theorem level_after (θ : Nat) : ∀ r, level θ (θ + r) + 1 = (θ + 1) * 2 ^ r
  | 0 => (congrArg (· + 1) (level_before θ θ (Nat.le_refl θ))).trans (Nat.mul_one (θ + 1)).symm
  | r + 1 =>
    have grown : level θ (θ + r + 1) = level θ (θ + r) + (1 + level θ (θ + r)) :=
      (level_succ θ (θ + r)).trans (congrArg (fun b => level θ (θ + r) +
          (1 + ((bif b then 1 else 0) * level θ (θ + r))))
        (Nat.ble_eq_true_of_le (level_ge θ r)) |>.trans
        (congrArg (fun x => level θ (θ + r) + (1 + x)) (Nat.one_mul _)))
    (congrArg (· + 1) grown).trans
      ((congrArg (fun x => level θ (θ + r) + x + 1) (Nat.add_comm 1 (level θ (θ + r)))).trans
        ((congrArg (· + 1) (Nat.add_comm (level θ (θ + r)) (level θ (θ + r) + 1))).trans
          ((Naturals.add_congr (level_after θ r) (level_after θ r)).trans
            ((Nat.left_distrib (θ + 1) _ _).symm.trans
              (congrArg ((θ + 1) * ·) (Loops.two_pow_succ r).symm)))))

/-- **The loop is not formed before the threshold is reached.** -/
theorem not_formed (θ : Nat) :
    ¬ OnLoop [()] (fun h => h) (strengthsBefore θ (strengths θ)) (fun _ => [true, false]) () :=
  fun ⟨_, _, pos, _, _, chain⟩ =>
    match couples_before_iff.mp (chain 0 pos) with
    | ⟨u, s, lt, _, _, _, _, _, positive⟩ =>
      have reached : Nat.ble θ (level θ u) = false :=
        (congrArg (fun x => Nat.ble θ x) (level_before θ u (Nat.le_of_lt lt))).trans
          (Naturals.ble_false_of_lt lt)
      have zero : ∀ h, strengths θ u h () s () = 0 := by
        intro h
        show (bif Nat.beq s u then (bif Nat.ble θ (level θ u) then 1 else 0) else 0) = 0
        rw [reached]
        cases Nat.beq s u <;> rfl
      absurd (Nat.lt_of_lt_of_le positive (Nat.le_of_eq (zero _))) (Nat.lt_irrefl 0)

/-- **The loop forms at the step the level reaches the threshold:** the exchange comes to respond
to the level it gives to. -/
theorem forms (θ : Nat) :
    OnLoop [()] (fun h => h) (strengthsBefore (θ + 1) (strengths θ)) (fun _ => [true, false]) () :=
  responds_to_own_level ⟨false, .tail _ (.head _), rfl, Nat.le_refl θ, .head _,
    Nat.lt_of_lt_of_le (Nat.succ_pos 0) (Nat.le_of_eq
      ((congrArg (fun b => bif b then (1 : Nat) else 0)
          ((Nat.ble_eq_true_of_le (Nat.le_refl θ)).symm.trans
            (congrArg (Nat.ble θ) (level_before θ θ (Nat.le_refl θ)).symm))).trans
        ((congrArg (fun b => bif b then (bif Nat.ble θ (level θ θ) then 1 else 0) else 0)
          (beq_self θ)).symm.trans (strengths_eq θ θ false () θ ()).symm)))⟩

/-- **Up to the threshold the course does not show it.** For every threshold beyond `θ`, the level
is the same at every step up to `θ`. -/
theorem unforeseen {θ θ' t : Nat} (later : θ ≤ θ') (le : t ≤ θ) : level θ t = level θ' t :=
  (level_before θ t le).trans (level_before θ' t (Nat.le_trans le later)).symm

end Closing.Threshold

end Becoming
