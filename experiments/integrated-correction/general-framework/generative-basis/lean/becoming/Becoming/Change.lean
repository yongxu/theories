import Becoming.Flow
import Becoming.Grammar

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
* **Coming to be of a negation.** What ceases to be is the coming to be of its negation and what
  comes to be the ceasing of its negation, with no premise (`CeasesToBe.not_comes`,
  `ComesToBe.not_ceases`); read back, the determination must be stable where it is read
  (`ComesToBe.of_not`, `CeasesToBe.of_not`); on a web, a formation ceasing is its inactivity coming
  to be (`Web.ceasing_readings`).
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

/-- **What ceases to be is the coming to be of its negation.** No premise. -/
theorem CeasesToBe.not_comes {p : Nat → Prop} {t : Nat} (ceases : CeasesToBe p t) :
    ComesToBe (fun s => ¬ p s) t :=
  ⟨fun fails => fails ceases.1, ceases.2⟩

/-- **What comes to be is the ceasing of its negation.** No premise. -/
theorem ComesToBe.not_ceases {p : Nat → Prop} {t : Nat} (comes : ComesToBe p t) :
    CeasesToBe (fun s => ¬ p s) t :=
  ⟨comes.1, fun fails => fails comes.2⟩

/-- The converse readings need the determination stable where it is read back: the negation's
coming to be across `t` is the determination's ceasing exactly where `p t` follows from its
double negation, and the negation's ceasing is the determination's coming to be where
`p (t + 1)` does. -/
theorem ComesToBe.of_not {p : Nat → Prop} {t : Nat} (stable : ¬ ¬ p t → p t)
    (comes : ComesToBe (fun s => ¬ p s) t) : CeasesToBe p t :=
  ⟨stable comes.1, comes.2⟩

theorem CeasesToBe.of_not {p : Nat → Prop} {t : Nat} (stable : ¬ ¬ p (t + 1) → p (t + 1))
    (ceases : CeasesToBe (fun s => ¬ p s) t) : ComesToBe p t :=
  ⟨ceases.1, stable ceases.2⟩

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

/-- **A formation ceasing is its inactivity coming to be**, and its arising is its inactivity
ceasing; no premise. Read back, the formation's activity is needed decided only where the
inactivity's change is read as the activity's. -/
theorem ceasing_readings (t : Nat) (f : F) :
    (W.Ceases t f → ComesToBe (fun s => ¬ W.active s f) t) ∧
      (W.Arises t f → CeasesToBe (fun s => ¬ W.active s f) t) ∧
      ((¬ ¬ W.active t f → W.active t f) → ComesToBe (fun s => ¬ W.active s f) t → W.Ceases t f) ∧
      ((¬ ¬ W.active (t + 1) f → W.active (t + 1) f) →
        CeasesToBe (fun s => ¬ W.active s f) t → W.Arises t f) :=
  ⟨CeasesToBe.not_comes (p := fun s => W.active s f), ComesToBe.not_ceases (p := fun s => W.active s f),
   ComesToBe.of_not (p := fun s => W.active s f), CeasesToBe.of_not (p := fun s => W.active s f)⟩

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

/-! ## The grammar's reading: coming to be and ceasing to be as positions under a class

Read in `Becoming.Grammar` along the steps (`Steps.next`, with the two-valued class
`Steps.alike p` of a determination, stated in `Becoming.Arising`):

* **Ceasing to be is an ending, coming to be a beginning, at the value they hold.** A determination
  ceases to be across the step from `t` exactly where it holds at `t` and the line under its class
  ends there (`ceasesToBe_iff_wang`, 亡); it comes to be exactly where it holds after the step and
  the line begins there (`comesToBe_iff_sheng`, 生). The same positions read at the other value are
  the negation's changes (`comesToBe_not_iff_sheng`, `ceasesToBe_not_iff_wang`). Since 缘 along the
  steps is one-to-one, an ending is the next step's beginning, which gives `CeasesToBe.not_comes`
  and `ComesToBe.not_ceases` again through the grammar (`CeasesToBe.not_comes_by_grammar`,
  `ComesToBe.not_ceases_by_grammar`). Their converses need stability (`ComesToBe.of_not`) because
  the class sees only that the value changed: which value held before is read from the value after,
  and from `¬ p (t + 1)` and a change only `¬ ¬ p t` follows. With the determination decided, a
  beginning is exactly a coming to be or a ceasing to be (`sheng_iff_change`): the one change of
  `Web.change_readings` is one position, read at two values.
* **A line that never ends is a determination that never changes.** The line from `S` never ends
  (`«不穷»`) exactly where the determination keeps its value at `S` at every later step
  (`buqiong_alike_iff`), and then nothing comes to be or ceases to be from `S` on
  (`still_of_buqiong`). What fails and comes to be at no later step makes such a line with no
  premise (`buqiong_of_stays_failing`).
* **Deciding positions is what persistence needs.** Where the position of each later step is
  decided (it begins, or has a predecessor), what holds and ceases to be at no later step holds on
  (`persists_of_positions`), with no decidability of the determination. `persists` and
  `persists_of_em` follow (`persists_by_grammar`, `persists_of_em_by_grammar`): decidability
  decides positions, and so does excluded middle through `«四相之定当且仅当排中»`. Deciding the
  position of a step after another is deciding whether the determination changes across it
  (`positions_iff_change`), and asked of every determination along the steps it is still exactly
  excluded middle (`positions_iff_em`). `World.law_iff_em` in `Becoming.Space` calibrates the
  finite-world law of arising and ceasing to the same principle, so the two are equivalent as
  principles; within that law's proof, excluded middle decides positions only where it gives
  `persists_of_em`, and elsewhere it decides questions about unboundedly many steps.
* **The core of the class is the whole course.** Two steps lie in one class of the core of
  `Steps.alike p` (`«核»`) exactly when the determination agrees at them and at every pair of steps
  equally far after them (`core_iff_same_course`). So a step continues under the core exactly where
  the line under the class never ends from it (`continues_in_core_iff_buqiong`): taking the core as
  the criterion, only a determination that never changes again continues, as the grammar's flame
  shows (`«以核为判据则火无续»`).
* **On a web.** A formation ceases across the step from `t` exactly where it is active at `t` and
  its occurrence ends under the class of activity (`Web.ceases_iff_wang`); its ceasing is the
  beginning, at the next step, of an inactive line (`Web.ceases_iff_inactive_sheng`), which is how
  the grammar reads `Web.ceasing_readings`. With activity decided, a beginning on the web is an
  arising or a ceasing (`Web.sheng_iff_arises_or_ceases`). A formation active for one step only
  holds different positions under different classes at once (`Web.flash_positions`, from
  `«四相无自立»`).
-/

/-- Two equalities of steps carry an equivalence of a determination at them. -/
theorem Steps.iff_of_eqs (p : Nat → Prop) {a b c d : Nat} (h₁ : a = b) (h₂ : c = d)
    (h : p b ↔ p d) : p a ↔ p c := by
  cases h₁; cases h₂; exact h

section GrammarReading

variable {p : Nat → Prop} {t : Nat}

/-- **Ceasing to be is an ending (亡) at the value held.** -/
theorem ceasesToBe_iff_wang : CeasesToBe p t ↔ p t ∧ «亡» Steps.next (Steps.alike p) t :=
  ⟨fun ⟨holds, fails⟩ => ⟨holds, fun hs => fails (Iff.mp (Steps.hasSucc_iff.mp hs) holds)⟩,
   fun ⟨holds, ends⟩ =>
    ⟨holds, fun next => ends (Steps.hasSucc_iff.mpr ⟨fun _ => next, fun _ => holds⟩)⟩⟩

/-- **Coming to be is a beginning (生) at the value held.** -/
theorem comesToBe_iff_sheng :
    ComesToBe p t ↔ p (t + 1) ∧ «生» Steps.next (Steps.alike p) (t + 1) :=
  ⟨fun ⟨fails, next⟩ => ⟨next, fun hp => fails (Iff.mpr (Steps.hasPred_iff.mp hp) next)⟩,
   fun ⟨next, begins⟩ =>
    ⟨fun holds => begins (Steps.hasPred_iff.mpr ⟨fun _ => next, fun _ => holds⟩), next⟩⟩

/-- A beginning read at the value that fails after it is the negation's coming to be. -/
theorem comesToBe_not_iff_sheng :
    ComesToBe (fun s => ¬ p s) t ↔ ¬ p (t + 1) ∧ «生» Steps.next (Steps.alike p) (t + 1) :=
  ⟨fun ⟨notNot, fails⟩ =>
    ⟨fails, fun hp => notNot fun holds => fails (Iff.mp (Steps.hasPred_iff.mp hp) holds)⟩,
   fun ⟨fails, begins⟩ =>
    ⟨fun failed => begins (Steps.hasPred_iff.mpr
      ⟨fun holds => absurd holds failed, fun next => absurd next fails⟩), fails⟩⟩

/-- An ending read at the value that fails before it is the negation's ceasing to be. -/
theorem ceasesToBe_not_iff_wang :
    CeasesToBe (fun s => ¬ p s) t ↔ ¬ p t ∧ «亡» Steps.next (Steps.alike p) t :=
  ⟨fun ⟨fails, notNot⟩ =>
    ⟨fails, fun hs => notNot fun next => fails (Iff.mpr (Steps.hasSucc_iff.mp hs) next)⟩,
   fun ⟨fails, ends⟩ =>
    ⟨fails, fun failsNext => ends (Steps.hasSucc_iff.mpr
      ⟨fun holds => absurd holds fails, fun next => absurd next failsNext⟩)⟩⟩

/-- `CeasesToBe.not_comes` through the grammar: the ending at `t` is the beginning at `t + 1`, read
at the value that fails there. -/
theorem CeasesToBe.not_comes_by_grammar (ceases : CeasesToBe p t) :
    ComesToBe (fun s => ¬ p s) t :=
  comesToBe_not_iff_sheng.mpr
    ⟨ceases.2, Steps.wang_iff_sheng_next.mp (ceasesToBe_iff_wang.mp ceases).2⟩

/-- `ComesToBe.not_ceases` through the grammar: the beginning at `t + 1` is the ending at `t`,
read at the value that fails there. -/
theorem ComesToBe.not_ceases_by_grammar (comes : ComesToBe p t) :
    CeasesToBe (fun s => ¬ p s) t :=
  ceasesToBe_not_iff_wang.mpr
    ⟨comes.1, Steps.wang_iff_sheng_next.mpr (comesToBe_iff_sheng.mp comes).2⟩

/-- **One change, one position.** With the determination decided, a step after another begins
under the class exactly where the determination comes to be or ceases to be across the step. -/
theorem sheng_iff_change [dp : ∀ s, Decidable (p s)] :
    «生» Steps.next (Steps.alike p) (t + 1) ↔ ComesToBe p t ∨ CeasesToBe p t :=
  ⟨fun begins => match dp t with
    | .isTrue holds =>
      .inr ⟨holds, fun next => begins (Steps.hasPred_iff.mpr ⟨fun _ => next, fun _ => holds⟩)⟩
    | .isFalse fails => match dp (t + 1) with
      | .isTrue next => .inl ⟨fails, next⟩
      | .isFalse failsNext => absurd (Steps.hasPred_iff.mpr
          ⟨fun holds => absurd holds fails, fun next => absurd next failsNext⟩) begins,
   fun changes => match changes with
    | .inl comes => (comesToBe_iff_sheng.mp comes).2
    | .inr ceases => Steps.wang_iff_sheng_next.mp (ceasesToBe_iff_wang.mp ceases).2⟩

/-- Reach along the steps from `s` reaches only later steps. -/
theorem Steps.reach_later {E : «际» Nat} {s y : Nat} (h : «相续» Steps.next E s y) :
    ∃ n, y = s + n + 1 := by
  induction h with
  | one c => exact ⟨0, c.1⟩
  | @more x m _ c _ ih =>
    match ih with
    | ⟨n, hy⟩ =>
      exact ⟨n + 1, hy.trans ((congrArg (fun k => k + n + 1) c.1).trans
        (congrArg (· + 1) (Nat.add_right_comm x 1 n)))⟩

/-- Where the line along the steps from `S` never ends, it reaches every later step. -/
theorem Steps.reached_of_buqiong {E : «际» Nat} {S : Nat} (h : «不穷» Steps.next E S) :
    ∀ n, «相续» Steps.next E S (S + n + 1)
  | 0 => .one ⟨rfl, Steps.hasSucc_iff.mp (h S (.inl rfl))⟩
  | n + 1 => «及之传递» (Steps.reached_of_buqiong h n)
      (.one ⟨rfl, Steps.hasSucc_iff.mp (h (S + n + 1) (.inr (Steps.reached_of_buqiong h n)))⟩)

/-- The line along the steps from `S` never ends (不穷) exactly when every later step is alike to
the next. -/
theorem Steps.buqiong_iff {E : «际» Nat} {S : Nat} :
    «不穷» Steps.next E S ↔ ∀ n, E (S + n) (S + n + 1) :=
  ⟨fun h n => match n with
    | 0 => Steps.hasSucc_iff.mp (h S (.inl rfl))
    | m + 1 => Steps.hasSucc_iff.mp (h (S + m + 1) (.inr (Steps.reached_of_buqiong h m))),
   fun alike y hy => match hy with
    | .inl same => by cases same; exact Steps.hasSucc_iff.mpr (alike 0)
    | .inr r => match Steps.reach_later r with
      | ⟨n, hy'⟩ => by cases hy'; exact Steps.hasSucc_iff.mpr (alike (n + 1))⟩

/-- A determination alike across every step from `S` keeps its value at `S`. -/
theorem Steps.keeps_of_alike {p : Nat → Prop} {S : Nat} (h : ∀ n, (p (S + n) ↔ p (S + n + 1))) :
    ∀ n, (p (S + n) ↔ p S)
  | 0 => Iff.rfl
  | n + 1 => (h n).symm.trans (Steps.keeps_of_alike h n)

/-- **A line that never ends is a determination that never changes:** under the class of `p`, the
line from `S` never ends exactly where `p` at every later step is as at `S`. -/
theorem buqiong_alike_iff {S : Nat} :
    «不穷» Steps.next (Steps.alike p) S ↔ ∀ n, (p (S + n) ↔ p S) :=
  ⟨fun h => Steps.keeps_of_alike (Steps.buqiong_iff.mp h),
   fun h => Steps.buqiong_iff.mpr fun n => (h n).trans (h (n + 1)).symm⟩

/-- Where the line from `S` never ends, nothing comes to be or ceases to be from `S` on. -/
theorem still_of_buqiong {S : Nat} (h : «不穷» Steps.next (Steps.alike p) S) :
    ∀ t, S ≤ t → ¬ ComesToBe p t ∧ ¬ CeasesToBe p t :=
  fun t later => match Nat.le.dest later with
  | ⟨m, same⟩ => by
    cases same
    exact ⟨fun ⟨fails, next⟩ => fails (Iff.mpr (Steps.buqiong_iff.mp h m) next),
      fun ⟨holds, fails⟩ => fails (Iff.mp (Steps.buqiong_iff.mp h m) holds)⟩

/-- What fails and comes to be at no later step makes a line that never ends; no decidability is
needed (`stays_failing`). -/
theorem buqiong_of_stays_failing {S : Nat} (fails : ¬ p S)
    (still : ∀ t, S ≤ t → ¬ ComesToBe p t) : «不穷» Steps.next (Steps.alike p) S :=
  buqiong_alike_iff.mpr fun n =>
    ⟨fun holds => absurd holds (stays_failing fails still n), fun holds => absurd holds fails⟩

/-- **Persistence needs decided positions only.** Where each later step's position is decided (it
begins, or has a predecessor, under the class), what holds and ceases to be at no later step
holds on. Nothing is asked of the determination itself. -/
theorem persists_of_positions {S : Nat}
    (positions : ∀ n, «生» Steps.next (Steps.alike p) (S + n + 1) ∨
      «有前» Steps.next (Steps.alike p) (S + n + 1))
    (holds : p S) (unceasing : ∀ t, S ≤ t → ¬ CeasesToBe p t) : ∀ n, p (S + n)
  | 0 => holds
  | n + 1 => match positions n with
    | .inr hp => Iff.mp (Steps.hasPred_iff.mp hp) (persists_of_positions positions holds unceasing n)
    | .inl begins =>
      have was := persists_of_positions positions holds unceasing n
      absurd ⟨was, fun next => begins (Steps.hasPred_iff.mpr ⟨fun _ => next, fun _ => was⟩)⟩
        (unceasing (S + n) (Nat.le_add_right S n))

/-- A decided determination decides the position of every step after another. -/
theorem positions_of_decided [dp : ∀ s, Decidable (p s)] (t : Nat) :
    «生» Steps.next (Steps.alike p) (t + 1) ∨ «有前» Steps.next (Steps.alike p) (t + 1) :=
  match dp t, dp (t + 1) with
  | .isTrue h₀, .isTrue h₁ => .inr (Steps.hasPred_iff.mpr ⟨fun _ => h₁, fun _ => h₀⟩)
  | .isFalse n₀, .isFalse n₁ =>
    .inr (Steps.hasPred_iff.mpr ⟨fun h => absurd h n₀, fun h => absurd h n₁⟩)
  | .isTrue h₀, .isFalse n₁ =>
    .inl fun hp => n₁ (Iff.mp (Steps.hasPred_iff.mp hp) h₀)
  | .isFalse n₀, .isTrue h₁ =>
    .inl fun hp => n₀ (Iff.mpr (Steps.hasPred_iff.mp hp) h₁)

/-- `persists`, derived through the positions: decidability decides them. -/
theorem persists_by_grammar [∀ s, Decidable (p s)] {S : Nat} (holds : p S)
    (unceasing : ∀ t, S ≤ t → ¬ CeasesToBe p t) : ∀ n, p (S + n) :=
  persists_of_positions (fun n => positions_of_decided (S + n)) holds unceasing

/-- `persists_of_em`, derived through the positions: excluded middle decides them
(`«四相之定当且仅当排中»`). -/
theorem persists_of_em_by_grammar (em : ∀ P : Prop, P ∨ ¬ P) {S : Nat} (holds : p S)
    (unceasing : ∀ t, S ≤ t → ¬ CeasesToBe p t) : ∀ n, p (S + n) :=
  persists_of_positions
    (fun n => «四相之定当且仅当排中».mpr em Nat Steps.next (Steps.alike p) (S + n + 1))
    holds unceasing

/-- Deciding the position of a step after another is deciding whether the determination changes
across the step. -/
theorem positions_iff_change :
    («生» Steps.next (Steps.alike p) (t + 1) ∨ «有前» Steps.next (Steps.alike p) (t + 1)) ↔
      (¬ (p t ↔ p (t + 1)) ∨ (p t ↔ p (t + 1))) :=
  ⟨fun h => match h with
    | .inl begins => .inl fun alike => begins (Steps.hasPred_iff.mpr alike)
    | .inr hp => .inr (Steps.hasPred_iff.mp hp),
   fun h => match h with
    | .inl changes => .inl fun hp => changes (Steps.hasPred_iff.mp hp)
    | .inr alike => .inr (Steps.hasPred_iff.mpr alike)⟩

end GrammarReading

/-- A determination that holds at the first step and is `Q` after it. -/
def Steps.firstThen (Q : Prop) : Nat → Prop :=
  fun s => Nat.casesOn (motive := fun _ => Prop) s True fun _ => Q

/-- **The grammar's calibration along the steps.** That the position of every step of every
determination is decided is exactly excluded middle: the determination true at the first step and
`Q` after it begins at the second step exactly where `Q` fails. -/
theorem positions_iff_em :
    (∀ (p : Nat → Prop) (t : Nat), «生» Steps.next (Steps.alike p) t ∨
      «有前» Steps.next (Steps.alike p) t) ↔ ∀ Q : Prop, Q ∨ ¬ Q :=
  ⟨fun decided Q => match decided (Steps.firstThen Q) (0 + 1) with
    | .inl begins => .inr fun q => begins (Steps.hasPred_iff.mpr ⟨fun _ => q, fun _ => trivial⟩)
    | .inr hp => .inl (Iff.mp (Steps.hasPred_iff.mp hp) trivial),
   fun em p t => «四相之定当且仅当排中».mpr em Nat Steps.next (Steps.alike p) t⟩

/-- A constant relation along the steps carries its pairs along every later step. -/
theorem Steps.course_of_constant {S : «际» Nat} (constant : «有常» Steps.next S) {s s' : Nat}
    (h : S s s') : ∀ n, S (s + n) (s' + n)
  | 0 => h
  | n + 1 =>
    match («有常之逐点» Steps.next S).mp constant (s + n) (s' + n)
      (Steps.course_of_constant constant h n) (s + n + 1) rfl with
    | ⟨_, hv, hS⟩ => by cases hv; exact hS

/-- **The core of the class is the whole course (核).** Two steps lie in one class of the core of
`Steps.alike p` exactly when `p` agrees at every pair of steps equally far after them. -/
theorem core_iff_same_course {p : Nat → Prop} {s s' : Nat} :
    «核» Steps.next (Steps.alike p) s s' ↔ ∀ n, (p (s + n) ↔ p (s' + n)) :=
  ⟨fun ⟨_, inside, _, constant, h⟩ n => inside _ _ (Steps.course_of_constant constant h n),
   fun h => ⟨fun u u' => ∀ n, (p (u + n) ↔ p (u' + n)),
    fun _ _ same => same 0,
    fun _ _ same n => (same n).symm,
    («有常之逐点» Steps.next _).mpr fun u u' same v hv =>
      ⟨u' + 1, rfl, by
        cases hv
        exact fun n => Steps.iff_of_eqs p (Nat.add_right_comm u 1 n)
          (Nat.add_right_comm u' 1 n) (same (n + 1))⟩,
    h⟩⟩

/-- **Continuing under the core is never ending under the class.** A step continues to the next
under the core of `Steps.alike p` exactly where the line under the class never ends from it. -/
theorem continues_in_core_iff_buqiong {p : Nat → Prop} {s : Nat} :
    «续» Steps.next («核» Steps.next (Steps.alike p)) s (s + 1) ↔
      «不穷» Steps.next (Steps.alike p) s :=
  ⟨fun ⟨_, core⟩ => Steps.buqiong_iff.mpr fun n =>
    Steps.iff_of_eqs p rfl (Nat.add_right_comm s 1 n).symm (core_iff_same_course.mp core n),
   fun never => ⟨rfl, core_iff_same_course.mpr fun n =>
    Steps.iff_of_eqs p rfl (Nat.add_right_comm s 1 n) (Steps.buqiong_iff.mp never n)⟩⟩

/-- Under a class constant along the steps, a determination unchanged across one step is
unchanged across the next (`«有常则续不尽»`). -/
theorem still_stays_of_constant {p : Nat → Prop} {t : Nat}
    (constant : «有常» Steps.next (Steps.alike p)) (still : p t ↔ p (t + 1)) :
    p (t + 1) ↔ p (t + 1 + 1) :=
  Steps.hasSucc_iff.mp («有常则续不尽» constant ⟨t, rfl, still⟩)

namespace Web

variable {F C : Type} {W : Web F C} {t : Nat} {f : F}

/-- **A formation ceasing is an ending (亡)** of its active occurrence under the class of
activity. -/
theorem ceases_iff_wang : W.Ceases t f ↔ W.active t f ∧ «亡» Steps.along W.activityClass (t, f) :=
  ⟨fun ceases => match (ceasesToBe_iff_wang (p := (W.active · f))).mp ceases with
    | ⟨active, ends⟩ => ⟨active, wang_iff_steps.mpr ends⟩,
   fun ⟨active, ends⟩ =>
    (ceasesToBe_iff_wang (p := (W.active · f))).mpr ⟨active, wang_iff_steps.mp ends⟩⟩

/-- A formation ceasing is the beginning (生), at the next step, of a line of inactivity: the
grammar's form of `ceasing_readings`. -/
theorem ceases_iff_inactive_sheng :
    W.Ceases t f ↔ W.active t f ∧ «生» Steps.along W.activityClass (t + 1, f) :=
  ⟨fun ceases => match ceases_iff_wang.mp ceases with
    | ⟨active, ends⟩ =>
      ⟨active, sheng_iff_steps.mpr (Steps.wang_iff_sheng_next.mp (wang_iff_steps.mp ends))⟩,
   fun ⟨active, begins⟩ => ceases_iff_wang.mpr
    ⟨active, wang_iff_steps.mpr (Steps.wang_iff_sheng_next.mpr (sheng_iff_steps.mp begins))⟩⟩

/-- With activity decided, an occurrence after the first step begins under the class of activity
exactly where the formation arises or ceases across the step before it. -/
theorem sheng_iff_arises_or_ceases [∀ s g, Decidable (W.active s g)] :
    «生» Steps.along W.activityClass (t + 1, f) ↔ W.Arises t f ∨ W.Ceases t f :=
  sheng_iff_steps.trans (sheng_iff_change (p := (W.active · f)))

/-- A condition ceasing to stand is an ending of the determination "standing" along the steps. -/
theorem ceasesToStand_iff_wang {c : C} :
    W.CeasesToStand t c ↔ 0 < W.level t c ∧ «亡» Steps.next (Steps.alike (0 < W.level · c)) t :=
  ceasesToBe_iff_wang (p := (0 < W.level · c))

/-- A dependence dissolving is an ending of the determination "depends" along the steps. -/
theorem dissolves_iff_wang {c : C} :
    W.Dissolves t f c ↔ W.requires t f c ∧ «亡» Steps.next (Steps.alike (W.requires · f c)) t :=
  ceasesToBe_iff_wang (p := (W.requires · f c))

/-- **A flash holds different positions at once (`«四相无自立»`).** A formation that arises across
the step from `t` and ceases across the next is, at step `t + 1`, abiding under the one, beginning
and ending under identity, and beginning and ending under the class of activity. -/
theorem flash_positions (arises : W.Arises t f) (ceases : W.Ceases (t + 1) f) :
    «住» Steps.along «一» (t + 1, f) ∧ «生» Steps.along «静» (t + 1, f) ∧
      «亡» Steps.along «静» (t + 1, f) ∧ «生» Steps.along W.activityClass (t + 1, f) ∧
      «亡» Steps.along W.activityClass (t + 1, f) :=
  match «四相无自立» (R := Steps.along) Steps.along_irrefl (x := (t, f)) (y := (t + 1, f))
    (z := (t + 1 + 1, f)) ⟨rfl, rfl⟩ ⟨rfl, rfl⟩ with
  | ⟨abides, begins, ends⟩ =>
    ⟨abides, begins, ends, (arises_iff_sheng.mp arises).2, (ceases_iff_wang.mp ceases).2⟩

end Web

end Becoming
