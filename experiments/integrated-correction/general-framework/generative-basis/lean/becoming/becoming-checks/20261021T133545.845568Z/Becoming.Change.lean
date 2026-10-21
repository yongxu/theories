import Becoming.Flow

/-!
# Change: what holds of every unfolding

The other modules state laws under premises about an unfolding: that activity needs
current support (`Dependent`), that levels change by what is taken and given
(`Flow.Balances`), that closed families are dissipated (`Dissipative`). This module states
what holds of every unfolding, with no premise about it. The representation's own
commitments are disclosed rather than assumed of what unfolds: change is read across
discrete steps, amounts are natural numbers, and counting needs the determination counted
to be decidable at each step.

* **One change, read of activity, dependence and standing.** A determination comes to be
  across a step where it fails before the step and holds after it, and ceases to be where
  it holds before and fails after (`ComesToBe`, `CeasesToBe`). A formation arising and
  ceasing, a dependence forming and dissolving, and a condition coming to stand and
  ceasing to stand are this one change, read three ways, by definition: each part of
  `Web.change_readings` holds by `Iff.rfl`, so it states how the definitions are read, not a law
  that excludes anything. What holds and ceases at
  no later step holds on (`persists`), and with excluded middle as a hypothesis in place
  of decidability too (`persists_of_em`); what fails and comes to be at no later step
  keeps failing, with no decidability (`stays_failing`). With excluded middle as a
  hypothesis, what does not recur has a step after which it does not occur
  (`exists_not_of_em`). Two stronger forms of what the core states, a step after which a
  formation is never active and a list holding every member that ever holds, would each
  give the limited principle of omniscience (`LPO`, Bishop 1967; Bridges and Richman 1987):
  every Boolean sequence has a `true` or is `false` throughout, which excluded middle gives and
  no constructive proof does
  (`Web.lpo_of_ending`, `Listed.lpo_of_few`). A formation's support changes only through
  its relations: it stays supported where no dependence forms or tightens and no
  condition it depends on falls (`Web.supported_of`).
* **Rises and falls over a stretch.** Over any stretch of steps, an amount at the end with
  everything it fell is the amount at the start with everything it rose (`over_stretch`),
  and so for the total of a finite family with the rises and falls of its members
  (`family_over_stretch`). Nothing is supposed about how the amounts change.
* **A floor and a ceiling.** No amount falls below zero, so over any stretch a finite
  family falls by at most its total at the start more than it rises (`fallen_within`),
  and falling at arbitrarily late steps needs rising at arbitrarily late steps
  (`rising_recurs`): in every unfolding, levels of finitely many conditions that keep
  falling keep rising (`Web.falls_need_rises`). For one amount this is the law of
  `Becoming.Renewal` that an observable never rising from some step on does not
  fall at arbitrarily late steps (`falls_not_recurring`). Where amounts are bounded, the
  family rises by at most its bound more than it falls (`risen_within`), and rising at
  arbitrarily late steps needs falling at arbitrarily late steps (`falling_recurs`).
* **Coming to be and ceasing to be keep pace.** A determination counts as zero or one, so
  both hold of it. Over any stretch, the members of a finite family holding at the end
  with those that ceased to be are those holding at the start with those that came to be
  (`held_over_stretch`); comings and ceasings differ by at most the number of members
  (`keep_pace`), and coming to be recurs exactly when ceasing to be recurs
  (`coming_recurs_iff`). Read of activity: the members of a finite family of formations
  active at the end with those that ceased are those active at the start with those that
  arose (`held_over_stretch`); they arise at arbitrarily late steps exactly when
  they cease at arbitrarily late steps (`Web.arising_recurs_iff`); and where the
  formations are finitely many and their activity is decided, arising recurs exactly
  when ceasing recurs (`Web.unceasing_iff`). Read of standing, with no
  premise at all: conditions of a finite family come to stand at arbitrarily late steps
  exactly when they cease to stand at arbitrarily late steps (`Web.standing_recurs_iff`).
* **Finiteness does the work.** Ever new formations can arise, none ever ceasing, while a
  level rises at every step and never falls (`Accretion`); formations all active at the start
  can cease one after another while nothing arises (`Attrition`).

These laws hold of the whole space of unfoldings; a law that needs a premise names it, and
the premise picks out a part of that space. No ethical predicate, ranking or axiom
occurs.
-/

namespace Becoming

variable {α : Type}

/-! ## Marks -/

/-- One where a decidable proposition holds, zero where it fails. -/
def mark (p : Prop) [decide : Decidable p] : Nat :=
  match decide with
  | .isTrue _ => 1
  | .isFalse _ => 0

theorem mark_cases {p : Prop} [decide : Decidable p] {q : Nat → Prop} (yes : p → q 1)
    (no : ¬ p → q 0) : q (mark p) :=
  match decide with
  | .isTrue holds => yes holds
  | .isFalse fails => no fails

theorem mark_le_one (p : Prop) [Decidable p] : mark p ≤ 1 :=
  mark_cases (q := (· ≤ 1)) (fun _ => Nat.le_refl 1) fun _ => Nat.zero_le 1

theorem mark_pos {p : Prop} [Decidable p] : 0 < mark p ↔ p :=
  mark_cases (q := fun m => 0 < m ↔ p) (fun holds => ⟨fun _ => holds, fun _ => Nat.succ_pos 0⟩)
    fun fails => ⟨fun pos => absurd pos (Nat.lt_irrefl 0), fun holds => absurd holds fails⟩

theorem mark_iff {p q : Prop} [Decidable p] [Decidable q] (same : p ↔ q) : mark p = mark q :=
  mark_cases (q := fun m => m = mark q)
    (fun holds => mark_cases (q := fun m => 1 = m) (fun _ => rfl)
      fun fails => absurd (same.mp holds) fails)
    fun fails => mark_cases (q := fun m => 0 = m) (fun holds => absurd (same.mpr holds) fails)
      fun _ => rfl

/-! ## Rise and fall -/

/-- By how much `a` exceeds `b`; zero where it does not. -/
def excess : Nat → Nat → Nat
  | 0, _ => 0
  | a + 1, 0 => a + 1
  | a + 1, b + 1 => excess a b

/-- Two amounts balance: `a` with the excess of `b` over it is `b` with the excess of `a`
over it. -/
theorem excess_balance : ∀ a b, a + excess b a = b + excess a b
  | 0, 0 => rfl
  | 0, _ + 1 => Nat.zero_add _
  | _ + 1, 0 => (Nat.zero_add _).symm
  | a + 1, b + 1 => (Nat.succ_add a _).trans
      ((congrArg Nat.succ (excess_balance a b)).trans (Nat.succ_add b _).symm)

theorem excess_pos : ∀ {a b : Nat}, 0 < excess a b ↔ b < a
  | 0, _ => ⟨fun pos => absurd pos (Nat.lt_irrefl 0), fun lt => absurd lt (Nat.not_lt_zero _)⟩
  | a + 1, 0 => ⟨fun _ => Nat.succ_pos a, fun _ => Nat.succ_pos a⟩
  | a + 1, b + 1 => (excess_pos (a := a) (b := b)).trans ⟨Nat.succ_lt_succ, Nat.lt_of_succ_lt_succ⟩

/-- The mark of one decidable proposition exceeds the mark of another by the mark of the
first holding while the second fails. -/
theorem excess_mark (p q : Prop) [dp : Decidable p] [dq : Decidable q] :
    excess (mark p) (mark q) = mark (p ∧ ¬ q) :=
  match dp, dq with
  | .isTrue _, .isTrue _ => rfl
  | .isTrue _, .isFalse _ => rfl
  | .isFalse _, _ => rfl

/-- How much an amount rises across the step from `t`. -/
def rise (q : Nat → Nat) (t : Nat) : Nat :=
  excess (q (t + 1)) (q t)

/-- How much an amount falls across the step from `t`. -/
def fall (q : Nat → Nat) (t : Nat) : Nat :=
  excess (q t) (q (t + 1))

/-- Across a step, the amount after it with its fall is the amount before it with its
rise. -/
theorem across (q : Nat → Nat) (t : Nat) : q (t + 1) + fall q t = q t + rise q t :=
  excess_balance (q (t + 1)) (q t)

/-- Over any stretch of steps, an amount at the end with everything it fell is the amount
at the start with everything it rose. -/
theorem over_stretch (q : Nat → Nat) :
    ∀ S n, q (S + n) + total (steps S n) (fall q) = q S + total (steps S n) (rise q) :=
  balance_over_stretch (across q)

/-- What the members of a finite family of amounts rose across the step from `t`. -/
def risen (as : List α) (q : α → Nat → Nat) (t : Nat) : Nat :=
  total as fun a => rise (q a) t

/-- What the members of a finite family of amounts fell across the step from `t`. -/
def fallen (as : List α) (q : α → Nat → Nat) (t : Nat) : Nat :=
  total as fun a => fall (q a) t

/-- Over any stretch of steps, a finite family's total at the end with everything its
members fell is its total at the start with everything its members rose. -/
theorem family_over_stretch (q : α → Nat → Nat) (S n : Nat) :
    ∀ as : List α, total as (fun a => q a (S + n)) + total (steps S n) (fallen as q) =
      total as (fun a => q a S) + total (steps S n) (risen as q)
  | [] => (congrArg (0 + ·) (total_zero (steps S n))).trans
      (congrArg (0 + ·) (total_zero (steps S n))).symm
  | a :: as => calc
      (q a (S + n) + total as fun b => q b (S + n)) +
          total (steps S n) (fun t => fall (q a) t + fallen as q t)
          = (q a (S + n) + total as fun b => q b (S + n)) +
            (total (steps S n) (fall (q a)) + total (steps S n) (fallen as q)) :=
        congrArg ((q a (S + n) + total as fun b => q b (S + n)) + ·)
          (total_add (fall (q a)) (fallen as q) (steps S n))
      _ = (q a (S + n) + total (steps S n) (fall (q a))) +
            ((total as fun b => q b (S + n)) + total (steps S n) (fallen as q)) :=
        Nat.add_add_add_comm _ _ _ _
      _ = (q a S + total (steps S n) (rise (q a))) +
            ((total as fun b => q b S) + total (steps S n) (risen as q)) :=
        (congrArg (· + ((total as fun b => q b (S + n)) + total (steps S n) (fallen as q)))
          (over_stretch (q a) S n)).trans
          (congrArg ((q a S + total (steps S n) (rise (q a))) + ·) (family_over_stretch q S n as))
      _ = (q a S + total as fun b => q b S) +
            (total (steps S n) (rise (q a)) + total (steps S n) (risen as q)) :=
        Nat.add_add_add_comm _ _ _ _
      _ = (q a S + total as fun b => q b S) +
            total (steps S n) (fun t => rise (q a) t + risen as q t) :=
        congrArg ((q a S + total as fun b => q b S) + ·)
          (total_add (rise (q a)) (risen as q) (steps S n)).symm

/-- No amount falls below zero: over any stretch, a finite family falls by at most its
total at the start more than it rises. -/
theorem fallen_within (q : α → Nat → Nat) (as : List α) (S n : Nat) :
    total (steps S n) (fallen as q) ≤
      total as (fun a => q a S) + total (steps S n) (risen as q) :=
  Nat.le_trans (Nat.le_add_left _ _) (Nat.le_of_eq (family_over_stretch q S n as))

/-- Over any stretch, a finite family of amounts bounded by `B` rises by at most `B` for
each member more than it falls. -/
theorem risen_within {q : α → Nat → Nat} {as : List α} {B : Nat}
    (bounded : ∀ a t, a ∈ as → q a t ≤ B) (S n : Nat) :
    total (steps S n) (risen as q) ≤ total as (fun _ => B) + total (steps S n) (fallen as q) :=
  Nat.le_trans (Nat.le_add_left _ _) (Nat.le_trans
    (Nat.le_of_eq (family_over_stretch q S n as).symm)
    (Nat.add_le_add_right (total_le as fun a mem => bounded a (S + n) mem) _))

/-! ## Stretches of steps -/

theorem steps_mem : ∀ {T n t : Nat}, t ∈ steps T n → T ≤ t
  | _, 0, _, mem => nomatch mem
  | _, _ + 1, _, .head _ => Nat.le_refl _
  | _, _ + 1, _, .tail _ mem => Nat.le_of_succ_le (steps_mem mem)

theorem steps_last (q : Nat → Nat) :
    ∀ T n, total (steps T (n + 1)) q = total (steps T n) q + q (T + n)
  | T, 0 => Nat.add_comm (q T) 0
  | T, n + 1 =>
    (congrArg (q T + ·) ((steps_last q (T + 1) n).trans
      (congrArg (_ + ·) (congrArg q (Nat.add_right_comm T 1 n))))).trans
      (Nat.add_assoc _ _ _).symm

theorem steps_mono (q : Nat → Nat) (T n : Nat) :
    ∀ m, total (steps T n) q ≤ total (steps T (n + m)) q
  | 0 => Nat.le_refl _
  | m + 1 => Nat.le_trans (steps_mono q T n m)
      (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq (steps_last q T (n + m)).symm))

/-! ## Recurrence -/

/-- Something holds of some member of a finite family at arbitrarily late steps.
`Sequences.Recurs` of `Becoming.Horizon` is the same notion for the moves of a run of sequences,
the family of one member (`Sequences.recurs_iff`, in `Becoming.Dissipation`). -/
def Recurs (as : List α) (e : α → Nat → Prop) : Prop :=
  ∀ N, ∃ t a, N ≤ t ∧ a ∈ as ∧ e a t

theorem Recurs.mono {as : List α} {e e' : α → Nat → Prop} (imp : ∀ a t, e a t → e' a t)
    (recurs : Recurs as e) : Recurs as e' :=
  fun N => match recurs N with
  | ⟨t, a, later, mem, holds⟩ => ⟨t, a, later, mem, imp a t holds⟩

/-- Where a quantity is positive at arbitrarily late steps, its totals over stretches from
any step exceed every bound. -/
theorem recurring_accumulates {q : Nat → Nat} (recurs : ∀ N, ∃ t, N ≤ t ∧ 0 < q t)
    (N : Nat) : ∀ K, ∃ n, K ≤ total (steps N n) q
  | 0 => ⟨0, Nat.zero_le _⟩
  | K + 1 => match recurring_accumulates recurs N K with
    | ⟨n, many⟩ => match recurs (N + n) with
      | ⟨_, later, positive⟩ => match le_dest later with
        | ⟨m, same⟩ => ⟨n + m + 1, Nat.le_trans
            (Nat.add_le_add (Nat.le_trans many (steps_mono q N n m))
              (Nat.lt_of_lt_of_le positive
                (Nat.le_of_eq (congrArg q (same.trans (Nat.add_assoc N n m))))))
            (Nat.le_of_eq (steps_last q N (n + m)).symm)⟩

/-- So where a quantity is positive at some member of a finite family at arbitrarily late
steps, the family's totals over stretches from any step exceed every bound. -/
theorem Recurs.accumulates {as : List α} {r : α → Nat → Nat}
    (recurs : Recurs as fun a t => 0 < r a t) (N : Nat) :
    ∀ K, ∃ n, K ≤ total (steps N n) fun t => total as fun a => r a t :=
  recurring_accumulates (fun M => match recurs M with
    | ⟨t, _, later, mem, positive⟩ => ⟨t, later, total_pos_of_mem mem positive⟩) N

/-- What exceeds `K` and is at most `K` and `R` together leaves `R` positive. -/
theorem pos_of_exceeds {K X R : Nat} (many : K + 1 ≤ X) (within : X ≤ K + R) : 0 < R :=
  match R, within with
  | 0, within => absurd (Nat.le_trans many within) (Nat.not_succ_le_self K)
  | R + 1, _ => Nat.succ_pos R

/-- In a finite family whose members fall at arbitrarily late steps, they also rise at
arbitrarily late steps. -/
theorem rising_recurs {as : List α} {q : α → Nat → Nat}
    (falls : Recurs as fun a t => 0 < fall (q a) t) : Recurs as fun a t => 0 < rise (q a) t :=
  fun N => match falls.accumulates N (total as (fun a => q a N) + 1) with
  | ⟨n, many⟩ => match total_pos (steps N n) (pos_of_exceeds many (fallen_within q as N n)) with
    | ⟨t, within, rose⟩ => match total_pos as rose with
      | ⟨a, mem, rises⟩ => ⟨t, a, steps_mem within, mem, rises⟩

/-- In a finite family of bounded amounts whose members rise at arbitrarily late steps,
they also fall at arbitrarily late steps. -/
theorem falling_recurs {as : List α} {q : α → Nat → Nat} {B : Nat}
    (bounded : ∀ a t, a ∈ as → q a t ≤ B)
    (rises : Recurs as fun a t => 0 < rise (q a) t) : Recurs as fun a t => 0 < fall (q a) t :=
  fun N => match rises.accumulates N (total as (fun _ => B) + 1) with
  | ⟨n, many⟩ => match total_pos (steps N n) (pos_of_exceeds many (risen_within bounded N n)) with
    | ⟨t, within, fell⟩ => match total_pos as fell with
      | ⟨a, mem, falls⟩ => ⟨t, a, steps_mem within, mem, falls⟩

/-! ## Coming to be and ceasing to be -/

/-- A determination comes to be across the step from `t`: it fails at `t` and holds after
the step. -/
def ComesToBe (p : Nat → Prop) (t : Nat) : Prop :=
  ¬ p t ∧ p (t + 1)

/-- A determination ceases to be across the step from `t`: it holds at `t` and fails after
the step. -/
def CeasesToBe (p : Nat → Prop) (t : Nat) : Prop :=
  p t ∧ ¬ p (t + 1)

section Determination

variable {p : Nat → Prop} [∀ t, Decidable (p t)]

instance (t : Nat) : Decidable (ComesToBe p t) := instDecidableAnd

instance (t : Nat) : Decidable (CeasesToBe p t) := instDecidableAnd

/-- A determination counted as zero or one rises by one exactly where it comes to be. -/
theorem rise_mark {t : Nat} : rise (fun s => mark (p s)) t = mark (ComesToBe p t) :=
  (excess_mark (p (t + 1)) (p t)).trans
    (mark_iff ⟨fun both => ⟨both.2, both.1⟩, fun both => ⟨both.2, both.1⟩⟩)

/-- A determination counted as zero or one falls by one exactly where it ceases to be. -/
theorem fall_mark {t : Nat} : fall (fun s => mark (p s)) t = mark (CeasesToBe p t) :=
  excess_mark (p t) (p (t + 1))

/-- What holds and ceases to be at no later step holds on. -/
theorem persists {S : Nat} (holds : p S) (unceasing : ∀ t, S ≤ t → ¬ CeasesToBe p t) :
    ∀ n, p (S + n)
  | 0 => holds
  | n + 1 => if next : p (S + n + 1) then next
    else absurd ⟨persists holds unceasing n, next⟩ (unceasing (S + n) (Nat.le_add_right S n))

end Determination

/-- With excluded middle, a negated universal has a counterexample. -/
theorem exists_not_of_em (em : ∀ P : Prop, P ∨ ¬ P) {Q : Nat → Prop} (notAll : ¬ ∀ N, Q N) :
    ∃ N, ¬ Q N :=
  match em (∃ N, ¬ Q N) with
  | .inl found => found
  | .inr nothing => absurd (fun N => match em (Q N) with
      | .inl q => q
      | .inr nq => absurd ⟨N, nq⟩ nothing) notAll

/-- What fails and comes to be at no later step keeps failing; no decidability is needed. -/
theorem stays_failing {p : Nat → Prop} {S : Nat} (fails : ¬ p S)
    (still : ∀ t, S ≤ t → ¬ ComesToBe p t) : ∀ n, ¬ p (S + n)
  | 0 => fails
  | n + 1 => fun holds =>
    still (S + n) (Nat.le_add_right S n) ⟨stays_failing fails still n, holds⟩

/-- With excluded middle as a hypothesis in place of decidability, what holds and ceases to
be at no later step holds on, as in `persists`. -/
theorem persists_of_em (em : ∀ P : Prop, P ∨ ¬ P) {p : Nat → Prop} {S : Nat} (holds : p S)
    (still : ∀ t, S ≤ t → ¬ CeasesToBe p t) : ∀ n, p (S + n)
  | 0 => holds
  | n + 1 => match em (p (S + n + 1)) with
    | .inl next => next
    | .inr next =>
      absurd ⟨persists_of_em em holds still n, next⟩ (still (S + n) (Nat.le_add_right S n))

/-! ## Omniscience -/

/-- The limited principle of omniscience: every Boolean sequence has a `true` or is `false`
throughout. Excluded middle gives it; it has no constructive proof. -/
def LPO : Prop :=
  ∀ s : Nat → Bool, (∃ n, s n = true) ∨ ∀ n, s n = false

/-- No `true` of `s` before `t`. -/
def clear (s : Nat → Bool) : Nat → Bool
  | 0 => true
  | t + 1 => clear s t && !s t

namespace Clear

theorem cases : ∀ b : Bool, b = false ∨ b = true
  | false => .inl rfl
  | true => .inr rfl

theorem false_of_not : ∀ b : Bool, (b = true → False) → b = false
  | false, _ => rfl
  | true, no => (no rfl).elim

theorem not_both {b : Bool} (no : b = false) (yes : b = true) : False :=
  nomatch no.symm.trans yes

theorem and_both : ∀ (b c : Bool), b = true → c = true → (b && c) = true
  | true, true, _, _ => rfl
  | false, _, no, _ => nomatch no
  | true, false, _, no => nomatch no

/-- With no `true` before `t`, none before an earlier step. -/
theorem mono (s : Nat → Bool) {i : Nat} : ∀ {t}, i ≤ t → clear s t = true → clear s i = true
  | _, .refl, c => c
  | _ + 1, .step le, c => mono s le (ListTests.and_left c)

theorem false_before (s : Nat → Bool) {t : Nat} (c : clear s t = true) {i : Nat}
    (lt : i < t) : s i = false :=
  ListTests.false_of_not (ListTests.and_right (mono s lt c))

/-- Up to any step, nothing is `true` or some earlier step is the first `true`. -/
theorem or_first (s : Nat → Bool) :
    ∀ n, clear s n = true ∨ ∃ m, m < n ∧ clear s m = true ∧ s m = true
  | 0 => .inl rfl
  | n + 1 => match or_first s n with
    | .inr ⟨m, lt, c, yes⟩ => .inr ⟨m, Nat.lt_succ_of_lt lt, c, yes⟩
    | .inl c => match cases (s n) with
      | .inl no => .inl (and_both _ _ c (Eq.subst (motive := fun b => (!b) = true) no.symm rfl))
      | .inr yes => .inr ⟨n, Nat.lt_succ_self n, c, yes⟩

/-- A `true` has a first one. -/
theorem first_of_true (s : Nat → Bool) {n : Nat} (yes : s n = true) :
    ∃ m, clear s m = true ∧ s m = true :=
  match or_first s n with
  | .inl c => ⟨n, c, yes⟩
  | .inr ⟨m, _, c, first⟩ => ⟨m, c, first⟩

/-- The first `true` is one. -/
theorem first_unique (s : Nat → Bool) {a b : Nat} (ca : clear s a = true) (ya : s a = true)
    (cb : clear s b = true) (yb : s b = true) : a = b :=
  match Nat.lt_or_ge a b with
  | .inl lt => (not_both (false_before s cb lt) ya).elim
  | .inr ge => match Nat.lt_or_ge b a with
    | .inl lt => (not_both (false_before s ca lt) yb).elim
    | .inr ge' => Nat.le_antisymm ge' ge

end Clear

/-- How many members of a finite family come to be across the step from `t`. -/
def comings (as : List α) (p : α → Nat → Prop) [∀ a t, Decidable (p a t)] (t : Nat) : Nat :=
  total as fun a => mark (ComesToBe (p a) t)

/-- How many members of a finite family cease to be across the step from `t`. -/
def ceasings (as : List α) (p : α → Nat → Prop) [∀ a t, Decidable (p a t)] (t : Nat) : Nat :=
  total as fun a => mark (CeasesToBe (p a) t)

section Family

variable {as : List α} {p : α → Nat → Prop} [∀ a t, Decidable (p a t)]

/-- Over any stretch, the members of a finite family holding at the end with those that
ceased to be are those holding at the start with those that came to be. -/
theorem held_over_stretch (S n : Nat) :
    total as (fun a => mark (p a (S + n))) + total (steps S n) (ceasings as p) =
      total as (fun a => mark (p a S)) + total (steps S n) (comings as p) :=
  (congrArg (_ + ·) (total_congr (fun _ => total_congr (fun _ => fall_mark) as)
      (steps S n))).symm.trans
    ((family_over_stretch (fun a s => mark (p a s)) S n as).trans
      (congrArg (_ + ·) (total_congr (fun _ => total_congr (fun _ => rise_mark) as)
        (steps S n))))

theorem marks_within (t : Nat) : total as (fun a => mark (p a t)) ≤ as.length :=
  Nat.le_trans (total_le as fun a _ => mark_le_one (p a t)) (Nat.le_of_eq (total_ones as))

/-- Over any stretch, in a finite family, comings to be and ceasings to be differ by at
most the number of members. -/
theorem keep_pace (S n : Nat) :
    total (steps S n) (comings as p) ≤ as.length + total (steps S n) (ceasings as p) ∧
      total (steps S n) (ceasings as p) ≤ as.length + total (steps S n) (comings as p) :=
  ⟨Nat.le_trans (Nat.le_add_left _ _) (Nat.le_trans (Nat.le_of_eq (held_over_stretch S n).symm)
      (Nat.add_le_add_right (marks_within (S + n)) _)),
   Nat.le_trans (Nat.le_add_left _ _) (Nat.le_trans (Nat.le_of_eq (held_over_stretch S n))
      (Nat.add_le_add_right (marks_within S) _))⟩

/-- In a finite family of determinations, coming to be recurs exactly when ceasing to be
recurs. -/
theorem coming_recurs_iff :
    Recurs as (fun a => ComesToBe (p a)) ↔ Recurs as (fun a => CeasesToBe (p a)) :=
  ⟨fun comes => (falling_recurs (q := fun a s => mark (p a s)) (fun _ _ _ => mark_le_one _)
      (comes.mono fun _ _ c => Nat.lt_of_lt_of_le (mark_pos.mpr c)
        (Nat.le_of_eq rise_mark.symm))).mono
      fun _ _ falls => mark_pos.mp (Nat.lt_of_lt_of_le falls (Nat.le_of_eq fall_mark)),
   fun ceases => (rising_recurs (q := fun a s => mark (p a s))
      (ceases.mono fun _ _ c => Nat.lt_of_lt_of_le (mark_pos.mpr c)
        (Nat.le_of_eq fall_mark.symm))).mono
      fun _ _ rises => mark_pos.mp (Nat.lt_of_lt_of_le rises (Nat.le_of_eq rise_mark))⟩

end Family

/-! ## The readings in a web -/

variable {F C : Type}

namespace Web

variable (W : Web F C)

/-- A formation ceases across the step from `t`: active at `t`, not active after it. -/
def Ceases (t : Nat) (f : F) : Prop :=
  W.active t f ∧ ¬ W.active (t + 1) f

/-- A condition ceases to stand across the step from `t`: a positive standing at `t`, none
after it. -/
def CeasesToStand (t : Nat) (c : C) : Prop :=
  0 < W.level t c ∧ ¬ 0 < W.level (t + 1) c

/-- Arising and ceasing, forming and dissolving, coming to stand and ceasing to stand are
one change, coming to be and ceasing to be, read of activity, dependence and standing. This is
read three ways, by definition: each part holds by `Iff.rfl`. -/
theorem change_readings (t : Nat) (f g : F) (c : C) :
    (W.Arises t f ↔ ComesToBe (W.active · f) t) ∧ (W.Ceases t f ↔ CeasesToBe (W.active · f) t) ∧
    (W.Forms t g c ↔ ComesToBe (W.requires · g c) t) ∧
    (W.Dissolves t g c ↔ CeasesToBe (W.requires · g c) t) ∧
    (W.ComesToStand t c ↔ ComesToBe (0 < W.level · c) t) ∧
    (W.CeasesToStand t c ↔ CeasesToBe (0 < W.level · c) t) :=
  ⟨.rfl, .rfl, .rfl, .rfl, .rfl, .rfl⟩

/-- Support changes only through relations: a formation supported at `s` is supported at
`t` where each dependence it has at `t` it had at `s`, at no greater need, on a condition
standing no lower. -/
theorem supported_of {s t : Nat} {f : F} (supported : W.Supported s f)
    (kept : ∀ c, W.requires t f c →
      W.requires s f c ∧ W.need t f c ≤ W.need s f c ∧ W.level s c ≤ W.level t c) :
    W.Supported t f :=
  fun c requires => match kept c requires with
  | ⟨had, need, level⟩ => Nat.le_trans need (Nat.le_trans (supported c had) level)

/-- In every unfolding, levels of a finite family of conditions that fall at arbitrarily
late steps rise at arbitrarily late steps. -/
theorem falls_need_rises {cs : List C} (falls : Recurs cs fun c t => W.Falls t c) :
    Recurs cs fun c t => W.Rises t c :=
  (rising_recurs (q := fun c t => W.level t c) (falls.mono fun _ _ => excess_pos.mpr)).mono
    fun _ _ => excess_pos.mp

/-- In a finite family of conditions, coming to stand recurs exactly when ceasing to stand
recurs. -/
theorem standing_recurs_iff (cs : List C) :
    Recurs cs (fun c t => W.ComesToStand t c) ↔ Recurs cs (fun c t => W.CeasesToStand t c) :=
  coming_recurs_iff (p := fun c t => 0 < W.level t c)

section Activity

variable [∀ t f, Decidable (W.active t f)]

instance (t : Nat) (f : F) : Decidable (W.Arises t f) := instDecidableAnd

instance (t : Nat) (f : F) : Decidable (W.Ceases t f) := instDecidableAnd

/-- In a finite family of formations, arising recurs exactly when ceasing recurs. -/
theorem arising_recurs_iff (fs : List F) :
    Recurs fs (fun f t => W.Arises t f) ↔ Recurs fs (fun f t => W.Ceases t f) :=
  coming_recurs_iff (p := fun f t => W.active t f)

/-- Where one list covers the formations active at each step from some step on, and their
activity is decided, arising recurs exactly when ceasing recurs. Nothing is asked of the
formations beyond the list or of the steps before: finitely many formations in all is not
needed. -/
theorem unceasing_iff_covering {fs : List F} {T : Nat}
    (covers : ∀ t, T ≤ t → ∀ f, W.active t f → f ∈ fs) :
    W.Unceasing ↔ ∀ N, ∃ t f, N ≤ t ∧ W.Ceases t f :=
  ⟨fun unceasing N => match (W.arising_recurs_iff fs).mp
      (fun N => match unceasing (N + T) with
        | ⟨t, f, later, arises⟩ => ⟨t, f, Nat.le_trans (Nat.le_add_right N T) later,
            covers (t + 1) (Nat.le_succ_of_le (Nat.le_trans (Nat.le_add_left T N) later)) f arises.2,
            arises⟩) N with
    | ⟨t, f, later, _, ceases⟩ => ⟨t, f, later, ceases⟩,
   fun ceasing N => match (W.arising_recurs_iff fs).mpr
      (fun N => match ceasing (N + T) with
        | ⟨t, f, later, ceases⟩ => ⟨t, f, Nat.le_trans (Nat.le_add_right N T) later,
            covers t (Nat.le_trans (Nat.le_add_left T N) later) f ceases.1, ceases⟩) N with
    | ⟨t, f, later, _, arises⟩ => ⟨t, f, later, arises⟩⟩

/-- Where the formations are finitely many and their activity is decided, some formation
arises at arbitrarily late steps (`Unceasing`) exactly when some formation ceases at
arbitrarily late steps: arising recurs exactly when ceasing recurs. -/
theorem unceasing_iff {fs : List F} (all : ∀ f, f ∈ fs) :
    W.Unceasing ↔ ∀ N, ∃ t f, N ≤ t ∧ W.Ceases t f :=
  W.unceasing_iff_covering (T := 0) fun _ _ f _ => all f

end Activity

end Web

/-! ## Finiteness does the work -/

namespace Accretion

/-- Formation `f` arises across step `f` and never ceases; the one condition rises at every
step. -/
def web : Web Nat Unit where
  level t _ := t
  active t f := f < t
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

theorem unceasing : web.Unceasing :=
  fun N => ⟨N, N, Nat.le_refl N, Nat.lt_irrefl N, Nat.lt_succ_self N⟩

theorem never_ceases : ∀ t f, ¬ web.Ceases t f :=
  fun _ _ ceases => ceases.2 (Nat.lt_succ_of_lt ceases.1)

theorem rises : ∀ t, web.Rises t () :=
  fun t => Nat.lt_succ_self t

theorem never_falls : ∀ t, ¬ web.Falls t () :=
  fun t falls => Nat.lt_asymm falls (Nat.lt_succ_self t)

end Accretion

namespace Attrition

/-- Every formation is active from the start, and formation `f` ceases across step `f`;
nothing arises. -/
def web : Web Nat Unit where
  level _ _ := 0
  active t f := t ≤ f
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

theorem ceasing : ∀ N, ∃ t f, N ≤ t ∧ web.Ceases t f :=
  fun N => ⟨N, N, Nat.le_refl N, Nat.le_refl N, Nat.not_succ_le_self N⟩

theorem nothing_arises : ∀ t f, ¬ web.Arises t f :=
  fun _ _ arises => arises.1 (Nat.le_of_succ_le arises.2)

end Attrition

/-- An amount at most another leaves no excess over it. -/
theorem Flow.excess_zero_of_le : ∀ {a b : Nat}, a ≤ b → excess a b = 0
  | 0, _, _ => rfl
  | _ + 1, 0, le => absurd le (Nat.not_succ_le_zero _)
  | a + 1, b + 1, le => Flow.excess_zero_of_le (a := a) (b := b) (Nat.le_of_succ_le_succ le)

end Becoming
