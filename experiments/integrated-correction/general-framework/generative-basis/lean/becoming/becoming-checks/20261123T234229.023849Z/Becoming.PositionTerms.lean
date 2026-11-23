import Becoming.RelativePosition
import Becoming.Reproduction

/-!
# What the selection term reads of offspring numbers is their positions

Derived from `dj-a-line-on-a-stock/read-2026-11-16/ScratchPositionTerms.lean.txt` and placed below
`Becoming.SelectionShift` in Lean Unification Wave U2 (Board Rule 9).

`RelativePosition.Keeps ps w w'` says that two profiles of amounts give every listed member the same
position (its amount counted once for each listed member, against the total).
`SelectionTerm.concord` and `SelectionTerm.discord` are the two halves of the selection term proper,
totals over ordered pairs of listed members. Nothing is defined here but two helpers of the proofs
(`oneAt`, `apart`); both laws are stated in `Becoming.RelativePosition` and `Becoming.SelectionTerm`.

Every declaration compiles from Lean's prelude alone with an empty axiom report (`0` axioms).
-/

namespace Becoming

namespace PositionTerms

open RelativePosition SelectionTerm

variable {α : Type}

/-! ## Arithmetic -/

/-- Where `x` with `y'` is `y` with `x'` (the premise `common`: `x'` differs from `x` by what `y'`
differs from `y`), `x` exceeds `y` by what `x'` exceeds `y'`. Rests on `excess_add_right`. -/
theorem excess_of_common {x y x' y' : Nat} (common : x + y' = y + x') :
    excess x y = excess x' y' :=
  (excess_add_right x y y').symm.trans
    ((congrArg (fun k => excess k (y + y')) common).trans
      ((congr (congrArg excess (Nat.add_comm y x')) (Nat.add_comm y y')).trans
        (excess_add_right x' y' y)))

/-- The converse. Where `x` exceeds `y` by what `x'` exceeds `y'` (`forward`) and `y` exceeds `x` by
what `y'` exceeds `x'` (`backward`), `x` with `y'` is `y` with `x'`. Rests on `excess_balance`. -/
theorem common_of_excess {x y x' y' : Nat} (forward : excess x y = excess x' y')
    (backward : excess y x = excess y' x') : x + y' = y + x' :=
  Becoming.add_right_cancel (excess y x + excess x' y')
    ((Nat.add_add_add_comm x y' (excess y x) (excess x' y')).trans
      ((Naturals.add_congr (excess_balance x y) (excess_balance y' x')).trans
        ((Nat.add_add_add_comm y (excess x y) x' (excess y' x')).trans
          (congrArg (y + x' + ·)
            ((Naturals.add_congr forward backward.symm).trans (Nat.add_comm _ _))))))

/-- Two balances with the same `c` and the same `d` trade their first terms: from `x + d = t + c`
(`first`), `x' + d' = t' + c'` (`second`), `c = c'` and `d = d'`, `x' + t = x + t'`. Addition of
natural numbers only. -/
theorem trade_of_balances {x x' t t' c d c' d' : Nat} (first : x + d = t + c)
    (second : x' + d' = t' + c') (concordant : c = c') (discordant : d = d') : x' + t = x + t' :=
  Becoming.add_right_cancel (d + c)
    ((Nat.add_add_add_comm x' t d c).trans
      (((Naturals.add_congr (congrArg (x' + ·) discordant) first.symm).trans
          ((congrArg (· + (x + d)) (second.trans (congrArg (t' + ·) concordant.symm))).trans
            (Nat.add_comm (t' + c) (x + d)))).trans
        (Nat.add_add_add_comm x d t' c)))

/-! ## Left to right -/

/-- **Profiles with the same positions have the same terms.** Premise `keeps`: the profiles `w` and
`w'` give every listed member the same position. Then with every amount `a` the concordance of `w`
is the concordance of `w'`, and the discordance of `w` is the discordance of `w'`. No decidable
equality is used. Rests on `RelativePosition.keeps_iff_common` and `excess_of_common`. -/
theorem same_terms_of_keeps {ps : List α} {w w' : α → Nat}
    (keeps : RelativePosition.Keeps ps w w') (a : α → Nat) :
    SelectionTerm.concord ps w a = SelectionTerm.concord ps w' a ∧
      SelectionTerm.discord ps w a = SelectionTerm.discord ps w' a :=
  ⟨total_congr_on fun p mp => total_congr_on fun q mq =>
      congrArg (· * excess (a p) (a q)) (excess_of_common (keeps_iff_common.mp keeps p q mp mq)),
   total_congr_on fun p mp => total_congr_on fun q mq =>
      congrArg (· * excess (a q) (a p)) (excess_of_common (keeps_iff_common.mp keeps p q mp mq))⟩

/-! ## Right to left, by the amount that is one at a member -/

/-- The amount that is one at `p` and nothing at every other member. A helper of the proofs below;
it needs equality of members decided. -/
def oneAt [DecidableEq α] (p q : α) : Nat := mark (q = p)

/-- A weight times the amount that is one at `p` is `p`'s weight times that amount, at every
member. Rests on `mark_cases`. -/
theorem mul_oneAt [DecidableEq α] (w : α → Nat) (p q : α) : w q * oneAt p q = w p * oneAt p q :=
  mark_cases (p := q = p) (q := fun m => w q * m = w p * m)
    (fun same => congrArg (fun r => w r * 1) same)
    (fun _ => (Nat.mul_zero (w q)).trans (Nat.mul_zero (w p)).symm)

/-- A listed member is listed at least once: over a list with `p` in it (`mem`), the amount that is
one at `p` totals more than nothing. The total is how often `p` is listed. -/
theorem listed_pos [DecidableEq α] {p : α} {ps : List α} (mem : p ∈ ps) :
    0 < total ps (oneAt p) :=
  Nat.lt_of_lt_of_le (show 0 < oneAt p p from (mark_pos (p := p = p)).mpr rfl)
    (le_total_of_mem (q := oneAt p) mem)

/-- The weighted total of the amount that is one at `p` is `p`'s weight, as often as `p` is
listed. -/
theorem weighted_oneAt [DecidableEq α] (ps : List α) (w : α → Nat) (p : α) :
    weighted ps w (oneAt p) = w p * total ps (oneAt p) :=
  show total ps (fun q => w q * oneAt p q) = w p * total ps (oneAt p) from
    (total_congr (fun q => mul_oneAt w p q) ps).trans (total_mul (w p) (oneAt p) ps)

/-- `SelectionTerm.covariation` at the amount that is one at `p`. -/
theorem covariation_oneAt [DecidableEq α] (ps : List α) (w : α → Nat) (p : α) :
    ps.length * w p * total ps (oneAt p) + discord ps w (oneAt p) =
      total ps w * total ps (oneAt p) + concord ps w (oneAt p) :=
  (congrArg (· + discord ps w (oneAt p))
      ((mul_assoc_nat ps.length (w p) (total ps (oneAt p))).trans
        (congrArg (ps.length * ·) (weighted_oneAt ps w p).symm))).trans
    (covariation ps w (oneAt p))

/-- **The terms with one amount fix one member's position.** -/
theorem keeps_at_of_terms [DecidableEq α] {ps : List α} {w w' : α → Nat} {p : α} (mem : p ∈ ps)
    (concordant : concord ps w (oneAt p) = concord ps w' (oneAt p))
    (discordant : discord ps w (oneAt p) = discord ps w' (oneAt p)) :
    riseCount ps w w' p = fallCount ps w w' p :=
  show ps.length * w' p + total ps w = ps.length * w p + total ps w' from
    Nat.eq_of_mul_eq_mul_right (listed_pos mem)
      ((add_mul_split (ps.length * w' p) (total ps w) (total ps (oneAt p))).trans
        ((trade_of_balances (covariation_oneAt ps w p) (covariation_oneAt ps w' p)
            concordant discordant).trans
          (add_mul_split (ps.length * w p) (total ps w') (total ps (oneAt p))).symm))

/-- **Profiles give every listed member the same position iff they share terms with every amount (decidable equality).** -/
theorem keeps_iff_same_terms [DecidableEq α] {ps : List α} {w w' : α → Nat} :
    RelativePosition.Keeps ps w w' ↔ ∀ a : α → Nat,
      SelectionTerm.concord ps w a = SelectionTerm.concord ps w' a ∧
        SelectionTerm.discord ps w a = SelectionTerm.discord ps w' a :=
  ⟨same_terms_of_keeps, fun same p mem =>
    keeps_at_of_terms mem (same (oneAt p)).1 (same (oneAt p)).2⟩

/-! ## Right to left, by the profiles themselves: no decidable equality -/

/-- By how much two numbers are apart, squared. A helper of the proofs below. -/
def apart (x y : Nat) : Nat := excess x y * excess x y + excess y x * excess y x

/-- The two squares are the two crossed products with the squared difference. -/
theorem square_balance (x y : Nat) : x * x + y * y = x * y + y * x + apart x y :=
  have none : discordPair x y x y = 0 :=
    Naturals.add_congr (Reproduction.excess_cross x y) (Reproduction.excess_cross y x)
  (Nat.add_zero _).symm.trans ((congrArg (x * x + y * y + ·) none.symm).trans (pair_balance x y x y))

/-- A number whose square is at most nothing is nothing. -/
theorem zero_of_square_le : ∀ {e : Nat}, e * e ≤ 0 → e = 0
  | 0, _ => rfl
  | e + 1, le => absurd le (Nat.not_le_of_gt (Nat.mul_pos (Nat.succ_pos e) (Nat.succ_pos e)))

/-- Numbers nothing apart are equal. -/
theorem eq_of_apart_zero {x y : Nat} (zero : apart x y = 0) : x = y :=
  Nat.le_antisymm
    (Reproduction.le_of_excess_zero
      (zero_of_square_le (Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq zero))))
    (Reproduction.le_of_excess_zero
      (zero_of_square_le (Nat.le_trans (Nat.le_add_left _ _) (Nat.le_of_eq zero))))

/-- **Two readings of ordered pairs with the same squares and products agree on every pair.** -/
theorem pairs_agree (ps : List α) (F G : α → α → Nat)
    (first : (total ps fun p => total ps fun q => F p q * F p q) =
      total ps fun p => total ps fun q => G p q * F p q)
    (second : (total ps fun p => total ps fun q => F p q * G p q) =
      total ps fun p => total ps fun q => G p q * G p q) :
    ∀ p q, p ∈ ps → q ∈ ps → F p q = G p q :=
  have summed :
      (total ps fun p => total ps fun q => F p q * F p q) +
          (total ps fun p => total ps fun q => G p q * G p q) =
        ((total ps fun p => total ps fun q => F p q * G p q) +
            total ps fun p => total ps fun q => G p q * F p q) +
          total ps fun p => total ps fun q => apart (F p q) (G p q) :=
    (pairs_add ps (fun p q => F p q * F p q) (fun p q => G p q * G p q)).symm.trans
      ((total_congr (fun p => total_congr (fun q => square_balance (F p q) (G p q)) ps) ps).trans
        ((pairs_add ps (fun p q => F p q * G p q + G p q * F p q)
            (fun p q => apart (F p q) (G p q))).trans
          (congrArg (· + total ps fun p => total ps fun q => apart (F p q) (G p q))
            (pairs_add ps (fun p q => F p q * G p q) (fun p q => G p q * F p q)))))
  have zero : (total ps fun p => total ps fun q => apart (F p q) (G p q)) = 0 :=
    Naturals.add_left_cancel
      (summed.symm.trans ((Naturals.add_congr first second.symm).trans
        ((Nat.add_comm _ _).trans (Nat.add_zero _).symm)))
  fun p q mp mq => eq_of_apart_zero (Nat.le_antisymm
    (Nat.le_trans (le_total_of_mem (q := fun q' => apart (F p q') (G p q')) (a := q) mq)
      (Nat.le_trans
        (le_total_of_mem (q := fun p' => total ps fun q' => apart (F p' q') (G p' q')) mp)
        (Nat.le_of_eq zero)))
    (Nat.zero_le _))

/-- **Concordance with the two profiles themselves fixes every position (no decidable equality).** -/
theorem keeps_of_own_concord {ps : List α} {w w' : α → Nat}
    (first : SelectionTerm.concord ps w w = SelectionTerm.concord ps w' w)
    (second : SelectionTerm.concord ps w w' = SelectionTerm.concord ps w' w') :
    RelativePosition.Keeps ps w w' :=
  have agree := pairs_agree ps (fun p q => excess (w p) (w q)) (fun p q => excess (w' p) (w' q))
    first second
  keeps_iff_common.mpr fun p q mp mq => common_of_excess (agree p q mp mq) (agree q p mq mp)

/-- Two profiles give every listed member the same position iff each agrees in concordance with `w` and `w'`. -/
theorem keeps_iff_own_concord {ps : List α} {w w' : α → Nat} :
    RelativePosition.Keeps ps w w' ↔
      SelectionTerm.concord ps w w = SelectionTerm.concord ps w' w ∧
        SelectionTerm.concord ps w w' = SelectionTerm.concord ps w' w' :=
  ⟨fun keeps => ⟨(same_terms_of_keeps keeps w).1, (same_terms_of_keeps keeps w').1⟩,
   fun same => keeps_of_own_concord same.1 same.2⟩

/-- **Exact characterization without decidable equality.** Two profiles give every listed member
the same position iff they have the same concordance and discordance with every amount. -/
theorem keeps_iff_terms {ps : List α} {w w' : α → Nat} :
    RelativePosition.Keeps ps w w' ↔ ∀ a : α → Nat,
      SelectionTerm.concord ps w a = SelectionTerm.concord ps w' a ∧
        SelectionTerm.discord ps w a = SelectionTerm.discord ps w' a :=
  ⟨same_terms_of_keeps, fun same => keeps_of_own_concord (same w).1 (same w').1⟩

/-! ## Shift congruences and generation-step transport -/

/-- A profile shifted at every listed member by a common `k` gives every listed member the same position. -/
theorem keeps_of_shifted {ps : List α} {w w' : α → Nat} {k : Nat}
    (shift : ∀ p, p ∈ ps → w' p = w p + k) : RelativePosition.Keeps ps w w' :=
  keeps_iff_common.mpr fun p q mp mq =>
    (congrArg (w p + ·) (shift q mq)).trans
      ((keeps_iff_common.mp (keeps_add ps w k).1 p q mp mq).trans
        (congrArg (w q + ·) (shift p mp)).symm)

/-- Amounts alike at every listed member have the same concordance with any weights. -/
theorem concord_amount_on {ps : List α} {w a a' : α → Nat} (same : ∀ p, p ∈ ps → a' p = a p) :
    concord ps w a' = concord ps w a :=
  total_congr_on fun p mp => total_congr_on fun q mq =>
    congrArg (excess (w p) (w q) * ·) (congr (congrArg excess (same p mp)) (same q mq))

/-- And the same discordance. -/
theorem discord_amount_on {ps : List α} {w a a' : α → Nat} (same : ∀ p, p ∈ ps → a' p = a p) :
    discord ps w a' = discord ps w a :=
  total_congr_on fun p mp => total_congr_on fun q mq =>
    congrArg (excess (w p) (w q) * ·) (congr (congrArg excess (same q mq)) (same p mp))

/-- **Step transport of the selection term proper from positions.** Two courses of generations with the
same family, amounts alike on it, and offspring numbers giving every member the same position have the
same concordance and discordance at that step. -/
theorem kept_step {G G' : SelectionTerm.Generations α} {t : Nat}
    (family : G'.family t = G.family t)
    (amount : ∀ p, p ∈ G.family t → G'.amount t p = G.amount t p)
    (keeps : RelativePosition.Keeps (G.family t) (G.offspringNumber t) (G'.offspringNumber t)) :
    G'.concordAt t = G.concordAt t ∧ G'.discordAt t = G.discordAt t :=
  ⟨(congrArg (fun l => concord l (G'.offspringNumber t) (G'.amount t)) family).trans
      ((concord_amount_on amount).trans (keeps_iff_terms.mp keeps (G.amount t)).1.symm),
   (congrArg (fun l => discord l (G'.offspringNumber t) (G'.amount t)) family).trans
      ((discord_amount_on amount).trans (keeps_iff_terms.mp keeps (G.amount t)).2.symm)⟩

/-! ## What the laws do not say: order, and one amount -/

/-- **The same positions keep which listed member has more.** -/
theorem keeps_order {ps : List α} {w w' : α → Nat} (keeps : RelativePosition.Keeps ps w w')
    {p q : α} (mp : p ∈ ps) (mq : q ∈ ps) : w q < w p ↔ w' q < w' p :=
  lt_iff_of_balance (keeps_iff_common.mp keeps p q mp mq)

/-- With an amount constant across members, any two profiles have the same (zero) terms. -/
theorem uniform_amount_same_terms (ps : List α) (w w' : α → Nat) (k : Nat) :
    concord ps w (fun _ => k) = concord ps w' (fun _ => k) ∧
      discord ps w (fun _ => k) = discord ps w' (fun _ => k) :=
  ⟨(concord_alike (k := k) (fun _ _ => rfl) w).trans (concord_alike (k := k) (fun _ _ => rfl) w').symm,
   (discord_alike (k := k) (fun _ _ => rfl) w).trans (discord_alike (k := k) (fun _ _ => rfl) w').symm⟩

namespace TwoProfiles

/-- Nothing and one. -/
def near : Bool → Nat
  | false => 0
  | true => 1

/-- Nothing and two. -/
def far : Bool → Nat
  | false => 0
  | true => 2

theorem not_keeps : ¬ RelativePosition.Keeps [false, true] near far :=
  fun keeps => Nat.lt_irrefl 1 (Nat.lt_of_lt_of_le (Nat.lt_succ_self 1)
    (Nat.le_of_eq (show 2 = 1 from
      keeps_iff_common.mp keeps false true (.head _) (.tail _ (.head _)))))

/-- **The same order, not the same positions.** -/
theorem same_order_apart :
    (∀ p q : Bool, near q < near p ↔ far q < far p) ∧
      ¬ RelativePosition.Keeps [false, true] near far :=
  ⟨fun p q => match p, q with
    | false, false => ⟨fun lt => absurd lt (Nat.lt_irrefl 0), fun lt => absurd lt (Nat.lt_irrefl 0)⟩
    | false, true => ⟨fun lt => absurd lt (Nat.not_lt_zero 1), fun lt => absurd lt (Nat.not_lt_zero 2)⟩
    | true, false => ⟨fun _ => Nat.succ_pos 1, fun _ => Nat.succ_pos 0⟩
    | true, true => ⟨fun lt => absurd lt (Nat.lt_irrefl 1), fun lt => absurd lt (Nat.lt_irrefl 2)⟩,
   not_keeps⟩

/-- **One amount is not enough.** -/
theorem one_amount_not_enough :
    (concord [false, true] near (fun _ => 0) = concord [false, true] far (fun _ => 0) ∧
        discord [false, true] near (fun _ => 0) = discord [false, true] far (fun _ => 0)) ∧
      ¬ RelativePosition.Keeps [false, true] near far :=
  ⟨uniform_amount_same_terms [false, true] near far 0, not_keeps⟩

end TwoProfiles

end PositionTerms

end Becoming
