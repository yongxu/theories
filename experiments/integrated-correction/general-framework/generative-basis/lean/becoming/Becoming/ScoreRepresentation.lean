import Becoming.Lexical
import Becoming.Frame
import Becoming.Extension

/-!
# Which scores represent the priority of basic conditions

One situation of one unfolding. Alternative `k` either retains a protected basic condition with no
further gain (`k = 0`) or loses it and realizes `k` gains (`k > 0`); the alternatives are the
configurations of a frame with no moves, realizing those claims, and the gains are its living
claims. Three conditions are kept apart: living significance (`LivingSignificance`) makes each realized gain
fall under its relevance parameter (which carries no valence); C (`Comparison`) asks a comparison to rank every generative extension above its base; the lexical order of
the protected condition, then the gains (`Lexical.Above`, J1/J2 when a comparison meets
`BasicPriority`), gives the condition priority. In this situation:

* living significance, C and the lexical order hold together, and the lexical order never ranks
  any number of gains above the protected condition (`livingSignificance_leaves_ordering_open`,
  `above_satisfies_comparison`, `never_outranked`);
* living significance constrains positive relevance, not order: it holds as well beside a scalar
  order satisfying C that ranks gains above the protected condition
  (`comparison_does_not_yield_priority`), so J1/J2 follow from neither;
* every natural-number score satisfying C ranks some number of gains above the protected condition
  (`every_nat_score_outranks`, an instance of `Comparison.outgrows`), so no such score represents
  the lexical order here (`no_nat_score_represents`). The force is the unit step of the natural
  numbers;
* a bounded score (`1` for protection, `k / (k + 1)` for `k` gains, compared by
  cross-multiplication) satisfies C, never ranks gains above protection and agrees with the
  lexical order on every pair (`ratio_agrees`, `bounded_score_represents`).

So this situation separates the lexical order from unit-step aggregation only; bounded,
diminishing sensitivity to further gains represents it exactly here and remains a substantive
rival. Ported from `ProtectionPriorityRival` (F3J, 18 October 2026) with the bridge's
`protection_successor_extension` and `every_nat_score_trades_by_core`; its classical proof of
`priority_iff` is constructive here. Every declaration has an empty axiom report.
-/

namespace Becoming

namespace ScoreRepresentation

open Lexical

/-- The protected basic condition, or the `i`th gain. -/
inductive Claim where
  | basic
  | gain (i : Nat)

def realized : Nat → Claim → Prop
  | k, .basic => k = 0
  | k, .gain i => i < k

def living : Claim → Prop
  | .basic => False
  | .gain _ => True

/-- The alternatives as configurations of a frame with no moves. -/
def frame : Frame Nat Unit Claim := ⟨⟨fun _ _ _ => False⟩, realized⟩

def protect (k : Nat) (_ : Unit) : Prop := k = 0
def gain (k : Nat) (i : Nat) : Prop := i < k

/-- A generative extension starts past the protected alternative and adds gains. -/
theorem extension_shape {a b : Nat} (extension : Extension frame living a b) : 1 ≤ a ∧ a < b :=
  match extension with
  | ⟨_, .basic, never, _, _⟩ => False.elim never
  | ⟨keeps, .gain i, _, now, before⟩ =>
    have now : i < b := now
    have notBefore : ¬ i < a := before
    have below : a ≤ i := match Nat.lt_or_ge i a with
      | .inl lt => absurd lt notBefore
      | .inr ge => ge
    match a, keeps, below with
    | 0, keeps, _ =>
      have zero : b = 0 := keeps .basic rfl
      absurd (zero ▸ now) (Nat.not_lt_zero i)
    | m + 1, _, below => ⟨Nat.succ_le_succ (Nat.zero_le m), Nat.lt_of_le_of_lt below now⟩

/-- **Past the protected alternative, one more gain extends.** -/
theorem successor_extends (k : Nat) : Extension frame living (k + 1) (k + 1 + 1) :=
  ⟨fun c held => match c, held with
    | .basic, (zero : k + 1 = 0) => absurd zero (Naturals.succ_ne_zero k)
    | .gain _, (lt : _ < k + 1) => Nat.lt_succ_of_lt lt,
   .gain (k + 1), True.intro, Nat.lt_succ_self (k + 1), Nat.lt_irrefl (k + 1)⟩

/-- Living significance recognizes every realized gain of an alternative losing protection. -/
theorem livingSignificance_recognizes_gains (relevance : Nat → Claim → Prop) (g0 : LivingSignificance frame living relevance) :
    ∀ k i, i < k → relevance k (.gain i) :=
  fun k i held => g0 k (.gain i) True.intro held

/-- **The lexical order on the alternatives.** Protection is above any gains, and among
alternatives losing protection more gains are above. -/
theorem above_iff : ∀ a b : Nat, Above protect gain a b ↔ (a = 0 ∧ b ≠ 0) ∨ (b ≠ 0 ∧ b < a)
  | 0, 0 => ⟨fun above => absurd above (Above.irrefl 0),
      fun | .inl ⟨_, no⟩ => absurd rfl no | .inr ⟨no, _⟩ => absurd rfl no⟩
  | 0, k + 1 => ⟨fun _ => .inl ⟨rfl, Naturals.succ_ne_zero k⟩,
      fun _ => Above.anchor (fun _ _ => rfl) () rfl (Naturals.succ_ne_zero k)⟩
  | m + 1, 0 => ⟨fun above => absurd above (Above.no_trade () rfl (Naturals.succ_ne_zero m)),
      fun | .inl ⟨no, _⟩ => absurd no (Naturals.succ_ne_zero m) | .inr ⟨no, _⟩ => absurd rfl no⟩
  | m + 1, k + 1 =>
    ⟨fun above => match above with
      | .inl ⟨_, notBack⟩ => absurd (fun _ held => absurd held (Naturals.succ_ne_zero m)) notBack
      | .inr ⟨_, _, ⟨_, notBack⟩⟩ => .inr ⟨Naturals.succ_ne_zero k, match Nat.lt_or_ge (k + 1) (m + 1) with
          | .inl lt => lt
          | .inr ge => absurd (fun _ held => Nat.lt_of_lt_of_le held ge) notBack⟩,
     fun
      | .inl ⟨no, _⟩ => absurd no (Naturals.succ_ne_zero m)
      | .inr ⟨_, lt⟩ => .inr ⟨fun _ held => absurd held (Naturals.succ_ne_zero k),
          fun _ held => absurd held (Naturals.succ_ne_zero m),
          ⟨fun _ held => Nat.lt_trans held lt, fun back => Nat.lt_irrefl _ (back (k + 1) lt)⟩⟩⟩

/-- **The lexical order satisfies C here.** `Comparison`'s `Better s t` says `t` is above. -/
theorem above_satisfies_comparison : Comparison frame living fun s t => Above protect gain t s :=
  fun a b extension => match extension_shape extension with
  | ⟨one, lt⟩ => (above_iff b a).mpr (.inr ⟨fun zero => Nat.not_succ_le_zero 0 (Eq.subst (motive := fun x => 1 ≤ x) zero one), lt⟩)

/-- **The lexical order never ranks gains above the protected condition**, whatever their
number. -/
theorem never_outranked : ∀ k, 0 < k → ¬ Above protect gain k 0
  | 0, pos => absurd pos (Nat.lt_irrefl 0)
  | m + 1, _ => Above.no_trade () rfl (Naturals.succ_ne_zero m)

/-- A scalar order: protection weighs `w`, each gain one. -/
def weighted (w : Nat) : Nat → Nat
  | 0 => w
  | k + 1 => k + 1

theorem weighted_satisfies_comparison (w : Nat) :
    Comparison frame living fun s t => weighted w s < weighted w t :=
  fun a b extension => match a, b, extension_shape extension with
  | 0, _, ⟨one, _⟩ => absurd one (Nat.not_succ_le_zero 0)
  | _ + 1, 0, ⟨_, lt⟩ => absurd lt (Nat.not_lt_zero _)
  | _ + 1, _ + 1, ⟨_, lt⟩ => lt

/-- The scalar order ranks `w + 1` gains above protection. -/
theorem weighted_outranks (w : Nat) : weighted w 0 < weighted w (w + 1) := Nat.lt_succ_self w

/-- **C does not yield the priority**: a scalar order satisfying C ranks gains above protection,
where the lexical order does not. -/
theorem comparison_does_not_yield_priority :
    ∃ score : Nat → Nat, Comparison frame living (fun s t => score s < score t) ∧
      ∃ k, 0 < k ∧ score 0 < score k ∧ ¬ Above protect gain k 0 :=
  ⟨weighted 0, weighted_satisfies_comparison 0, 1, Nat.zero_lt_one, Nat.zero_lt_one,
   never_outranked 1 Nat.zero_lt_one⟩

/-- **Every natural-number score satisfying C ranks some number of gains above protection**:
the alternatives with gains form an endless chain of extensions, so by `Comparison.outgrows` the
alternative with `score 0 + 2` gains is ranked above protection. -/
theorem every_nat_score_outranks (score : Nat → Nat)
    (comparison : Comparison frame living fun s t => score s < score t) :
    0 < score 0 + 2 ∧ score 0 < score (score 0 + 2) :=
  ⟨Nat.zero_lt_succ _, Comparison.outgrows (next := fun i => i + 1) comparison successor_extends 0⟩

/-- **No natural-number score satisfying C represents the lexical order here.** -/
theorem no_nat_score_represents :
    ¬ ∃ score : Nat → Nat, Comparison frame living (fun s t => score s < score t) ∧
      ∀ k, 0 < k → score k ≤ score 0 :=
  fun ⟨score, comparison, never⟩ => match every_nat_score_outranks score comparison with
  | ⟨pos, outranks⟩ => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le outranks (never _ pos))

/-- **Living significance leaves the order open**: it holds beside the lexical order and beside a
scalar order satisfying C that ranks gains above protection. -/
theorem livingSignificance_leaves_ordering_open :
    LivingSignificance frame living (fun _ _ => True) ∧
      Comparison frame living (fun s t => Above protect gain t s) ∧
      (∀ k, 0 < k → ¬ Above protect gain k 0) ∧
      Comparison frame living (fun s t => weighted 0 s < weighted 0 t) ∧
      weighted 0 0 < weighted 0 1 :=
  ⟨fun _ _ _ _ => True.intro, above_satisfies_comparison, never_outranked,
   weighted_satisfies_comparison 0, Nat.zero_lt_one⟩

/-- The bounded score `1` for protection and `k / (k + 1)` for `k` gains, as numerator and
denominator. -/
def num : Nat → Nat
  | 0 => 1
  | k + 1 => k + 1

def den : Nat → Nat
  | 0 => 1
  | k + 1 => k + 1 + 1

/-- `ratioBetter first second`: the second alternative's bounded score is strictly higher. -/
def ratioBetter (first second : Nat) : Prop := num first * den second < num second * den first

theorem ratio_bounded : ∀ k, num k ≤ den k
  | 0 => Nat.le_refl 1
  | k + 1 => Nat.le_succ (k + 1)

/-- Cross-multiplied, the bounded scores of two alternatives with gains compare as the gains. -/
theorem cross_iff (k m : Nat) :
    (k + 1) * (m + 1 + 1) < (m + 1) * (k + 1 + 1) ↔ k + 1 < m + 1 := by
  rw [Nat.mul_succ (k + 1) (m + 1), Nat.mul_succ (m + 1) (k + 1), Nat.mul_comm (k + 1) (m + 1)]
  exact ⟨Nat.lt_of_add_lt_add_left, fun lt => Nat.add_lt_add_left lt _⟩

/-- **The bounded score agrees with the lexical order on every pair of alternatives.** -/
theorem ratio_agrees : ∀ a b : Nat, ratioBetter b a ↔ Above protect gain a b
  | 0, 0 => ⟨fun lt => absurd lt (Nat.lt_irrefl 1), fun above => absurd above (Above.irrefl 0)⟩
  | 0, k + 1 => ⟨fun _ => (above_iff 0 (k + 1)).mpr (.inl ⟨rfl, Naturals.succ_ne_zero k⟩),
      fun _ => by
        show (k + 1) * 1 < 1 * (k + 1 + 1)
        rw [Nat.mul_one, Nat.one_mul]
        exact Nat.lt_succ_self (k + 1)⟩
  | m + 1, 0 => ⟨fun lt => absurd lt (by
        show ¬ 1 * (m + 1 + 1) < (m + 1) * 1
        rw [Nat.mul_one, Nat.one_mul]
        exact Nat.not_lt_of_le (Nat.le_succ (m + 1))),
      fun above => absurd above (never_outranked (m + 1) (Nat.zero_lt_succ m))⟩
  | m + 1, k + 1 => (cross_iff k m).trans
      ((above_iff (m + 1) (k + 1)).trans
        ⟨fun | .inl ⟨no, _⟩ => absurd no (Naturals.succ_ne_zero m) | .inr ⟨_, lt⟩ => lt,
         fun lt => .inr ⟨Naturals.succ_ne_zero k, lt⟩⟩).symm

/-- **A bounded score satisfies C and never ranks gains above protection**: the exclusion above
depends on natural-number values, and bounded sensitivity is not excluded here. -/
theorem bounded_score_represents :
    Comparison frame living ratioBetter ∧ ∀ k, 0 < k → ¬ ratioBetter 0 k :=
  ⟨fun a b extension => (ratio_agrees b a).mpr (above_satisfies_comparison a b extension),
   fun k pos better => never_outranked k pos ((ratio_agrees k 0).mp better)⟩

end ScoreRepresentation

end Becoming
