import Becoming.PairSelection

/-!
# EL7 (a), scratch: a cohort of pairs read in withholding counts

Scratch for the EL7 investigation (a); not part of the package and not landed. For any laws,
marks and supplied errors, over `n` steps of every pair's run:

* a place's offspring with `β` times its partner's withholding is `a + β n` with `γ` times its
  own (`offspring_balance`); within a pair, offspring with `β + γ` times the partner's
  withholding is the partner's with `β + γ` times one's own (`pair_balance`);
* a kind rises exactly where `β·N₀·P₁ + γ·N₁·Q₀ < β·N₁·P₀ + γ·N₀·Q₁`, with `N` the numbers of
  places, `Q` their own withholding and `P` their partners', of the kind (`1`) and not (`0`)
  (`kind_rises_iff_withheld`);
* on a cohort listed as pairs, the four terms of `pairs_rises_iff` are the same four terms read on
  own withholding: the within-pair ones times `β + γ` (`within_pairs`); the among-pair ones times
  `d` where `γ = β + d` (`means_of_le`), and exchanged, times `d`, where `β = γ + d`
  (`means_of_ge`); so the four-term law in withholding counts (`pairs_rises_iff_withheld_le`,
  `pairs_rises_iff_withheld_ge`).
-/

namespace Becoming
namespace EL7a

open PairSelection SelectionTerm SelectionLevels

/-! ## A place and its pair -/

/-- **A place's offspring with `β` times its partner's withholding is `a + β n` with `γ` times
its own**, for any laws, marks and errors. -/
theorem offspring_balance (a β γ n : Nat) (s : Place) :
    s.offspring a β γ n + β * s.other.withheld n = a + β * n + γ * s.withheld n := by
  show a + β * s.received n + γ * s.withheld n + β * s.other.withheld n =
    a + β * n + γ * s.withheld n
  rw [Nat.add_right_comm (a + β * s.received n), Nat.add_assoc a, ← Nat.left_distrib,
    received_add_withheld]

theorem other_other (s : Place) : s.other.other = s :=
  match s with
  | ⟨l, m, e, p⟩ => congrArg (fun q => (⟨l, m, e, q⟩ : Place)) (partner_partner p)

/-- The partner's form of `offspring_balance`. -/
theorem other_balance (a β γ n : Nat) (s : Place) :
    s.other.offspring a β γ n + β * s.withheld n = a + β * n + γ * s.other.withheld n :=
  (congrArg (fun t : Place => s.other.offspring a β γ n + β * t.withheld n) (other_other s)).symm.trans
    (offspring_balance a β γ n s.other)

/-- **Within a pair, offspring with `β + γ` times the partner's withholding is the partner's
with `β + γ` times one's own.** -/
theorem pair_balance (a β γ n : Nat) (s : Place) :
    s.offspring a β γ n + (β + γ) * s.other.withheld n =
      s.other.offspring a β γ n + (β + γ) * s.withheld n :=
  ((congrArg (s.offspring a β γ n + ·) (add_mul_split β γ (s.other.withheld n))).trans
    ((Nat.add_assoc _ _ _).symm.trans
      ((congrArg (· + γ * s.other.withheld n) (offspring_balance a β γ n s)).trans
        ((Nat.add_right_comm _ _ _).trans
          ((congrArg (· + γ * s.withheld n) (other_balance a β γ n s)).symm.trans
            ((Nat.add_assoc _ _ _).trans (congrArg (s.other.offspring a β γ n + ·)
              (add_mul_split β γ (s.withheld n)).symm)))))))

/-- **A pair's offspring with `β` times its withholding is twice `a + β n` with `γ` times its
withholding.** -/
theorem pair_total (a β γ n : Nat) (s : Place) :
    s.offspring a β γ n + s.other.offspring a β γ n +
        β * (s.withheld n + s.other.withheld n) =
      (a + β * n) + (a + β * n) + γ * (s.withheld n + s.other.withheld n) := by
  have h1 := offspring_balance a β γ n s
  have h2 := other_balance a β γ n s
  rw [Nat.left_distrib, Nat.left_distrib, Nat.add_comm (β * s.withheld n) (β * s.other.withheld n),
    Nat.add_add_add_comm, h1, h2, Nat.add_add_add_comm]

/-! ## The mean law in withholding counts -/

/-- The places' own withholding over `n` steps, totalled at the places a reading picks. -/
def ownWithheld (n : Nat) (u : Place → Nat) (ps : List Place) : Nat :=
  total ps fun p => p.withheld n * u p

/-- Their partners' withholding, totalled likewise. -/
def partnerWithheld (n : Nat) (u : Place → Nat) (ps : List Place) : Nat :=
  total ps fun p => p.other.withheld n * u p

/-- Over any places, offspring at the places a reading picks, with `β` times their partners'
withholding there, is `a + β n` times the reading's total with `γ` times their own. -/
theorem sum_balance (a β γ n : Nat) (u : Place → Nat) (ps : List Place) :
    total ps (fun p => p.offspring a β γ n * u p) + β * partnerWithheld n u ps =
      (a + β * n) * total ps u + γ * ownWithheld n u ps :=
  have pointwise : ∀ p : Place, p.offspring a β γ n * u p + β * (p.other.withheld n * u p) =
      (a + β * n) * u p + γ * (p.withheld n * u p) := fun p => by
    have h : (p.offspring a β γ n + β * p.other.withheld n) * u p =
        (a + β * n + γ * p.withheld n) * u p := congrArg (· * u p) (offspring_balance a β γ n p)
    rw [add_mul_split, add_mul_split, mul_assoc_nat, mul_assoc_nat] at h
    exact h
  (Naturals.add_congr rfl (total_mul β (fun p => p.other.withheld n * u p) ps).symm).trans
    ((total_add _ _ ps).symm.trans ((total_congr pointwise ps).trans ((total_add _ _ ps).trans
      (Naturals.add_congr (total_mul _ _ ps) (total_mul γ _ ps)))))

theorem scaled {W P N Q β γ M : Nat} (K : Nat) (h : W + β * P = M * N + γ * Q) :
    K * W + β * K * P = M * N * K + γ * K * Q := by
  have this : K * (W + β * P) = K * (M * N + γ * Q) := congrArg (K * ·) h
  rw [Nat.left_distrib, Nat.left_distrib] at this
  rw [Nat.mul_comm β K, mul_assoc_nat, Nat.mul_comm (M * N) K, Nat.mul_comm γ K, mul_assoc_nat]
  exact this

theorem lt_iff_shift {X Y u v C p q : Nat} (hx : X + u = C + p) (hy : Y + v = C + q) :
    X < Y ↔ v + p < u + q :=
  have e1 : X + (u + v) = C + (v + p) := by
    rw [← Nat.add_assoc, hx, Nat.add_assoc, Nat.add_comm p v]
  have e2 : Y + (u + v) = C + (u + q) := by
    rw [Nat.add_comm u v, ← Nat.add_assoc, hy, Nat.add_assoc, Nat.add_comm q u]
  ⟨fun lt => Nat.lt_of_add_lt_add_left (Nat.lt_of_le_of_lt (Nat.le_of_eq e1.symm)
      (Nat.lt_of_lt_of_le (Nat.add_lt_add_right lt (u + v)) (Nat.le_of_eq e2))),
   fun lt => Nat.lt_of_add_lt_add_right (Nat.lt_of_le_of_lt (Nat.le_of_eq e1)
      (Nat.lt_of_lt_of_le (Nat.add_lt_add_left lt C) (Nat.le_of_eq e2.symm)))⟩

/-- **A kind rises exactly where its members' excess of own withholding, times `γ`, exceeds
their partners' excess, times `β`**, for any places, laws, marks and errors: with `N₁`, `N₀`
the numbers of places of the kind and not, `Q₁`, `Q₀` their own withholding and `P₁`, `P₀`
their partners', the kind rises exactly where `β·N₀·P₁ + γ·N₁·Q₀ < β·N₁·P₀ + γ·N₀·Q₁`. Divided by
`N₁·N₀`: `β (P₁/N₁ − P₀/N₀) < γ (Q₁/N₁ − Q₀/N₀)`. -/
theorem kind_rises_iff_withheld (a β γ n : Nat) (ps : List Place) :
    discord ps (Place.offspring a β γ n) (amountOf Place.kind) <
        concord ps (Place.offspring a β γ n) (amountOf Place.kind) ↔
      β * total ps (otherOf Place.kind) * partnerWithheld n (amountOf Place.kind) ps +
          γ * total ps (amountOf Place.kind) * ownWithheld n (otherOf Place.kind) ps <
        β * total ps (amountOf Place.kind) * partnerWithheld n (otherOf Place.kind) ps +
          γ * total ps (otherOf Place.kind) * ownWithheld n (amountOf Place.kind) ps :=
  (kind_rises_iff ps (Place.offspring a β γ n) Place.kind).trans
    (lt_iff_shift
      (scaled (total ps (amountOf Place.kind)) (sum_balance a β γ n (otherOf Place.kind) ps))
      ((scaled (total ps (otherOf Place.kind)) (sum_balance a β γ n (amountOf Place.kind) ps)).trans
        (congrArg (· + γ * total ps (otherOf Place.kind) * ownWithheld n (amountOf Place.kind) ps)
          (Naturals.mul_right_comm (a + β * n) _ _))))

/-! ## Weights that move with a count -/

theorem excess_of_balance {x y u v c : Nat} (h : x + c * u = y + c * v) :
    excess x y = c * excess v u := by
  cases Nat.lt_or_ge u v with
  | inl uv =>
    obtain ⟨d, rfl⟩ := le_dest (Nat.le_of_lt uv)
    have hx : x = y + c * d := Naturals.add_right_cancel (k := c * u) (h.trans (by
      rw [Nat.left_distrib, ← Nat.add_assoc, Nat.add_right_comm]))
    rw [hx, excess_add_left, excess_add_left]
  | inr vu =>
    obtain ⟨d, rfl⟩ := le_dest vu
    have hy : y = x + c * d := Naturals.add_right_cancel (k := c * v) (h.symm.trans (by
      rw [Nat.left_distrib, ← Nat.add_assoc, Nat.add_right_comm]))
    rw [hy, excess_self_add, excess_self_add, Nat.mul_zero]

section Moving

variable {α : Type}

/-- Where weights differ as `c` times a count differs, member by member, the weights'
concordance and discordance are `c` times the count's. -/
theorem concord_of_rising {ps : List α} {w k : α → Nat} {c : Nat}
    (same : ∀ p q, p ∈ ps → q ∈ ps → w p + c * k q = w q + c * k p) (a : α → Nat) :
    concord ps w a = c * concord ps k a ∧ discord ps w a = c * discord ps k a :=
  have ex : ∀ p q, p ∈ ps → q ∈ ps → excess (w p) (w q) = c * excess (k p) (k q) :=
    fun p q mp mq => excess_of_balance (same p q mp mq)
  ⟨(total_eq_of_mem fun p mp => (total_eq_of_mem fun q mq =>
      (congrArg (· * excess (a p) (a q)) (ex p q mp mq)).trans (mul_assoc_nat _ _ _)).trans
        (total_mul c (fun q => excess (k p) (k q) * excess (a p) (a q)) ps)).trans
      (total_mul c (fun p => total ps fun q => excess (k p) (k q) * excess (a p) (a q)) ps),
   (total_eq_of_mem fun p mp => (total_eq_of_mem fun q mq =>
      (congrArg (· * excess (a q) (a p)) (ex p q mp mq)).trans (mul_assoc_nat _ _ _)).trans
        (total_mul c (fun q => excess (k p) (k q) * excess (a q) (a p)) ps)).trans
      (total_mul c (fun p => total ps fun q => excess (k p) (k q) * excess (a q) (a p)) ps)⟩

/-- Where weights with `c` times a count are alike at every member, the weights' concordance is
`c` times the count's discordance, and their discordance `c` times its concordance. -/
theorem concord_of_falling {ps : List α} {w k : α → Nat} {c : Nat}
    (same : ∀ p q, p ∈ ps → q ∈ ps → w p + c * k p = w q + c * k q) (a : α → Nat) :
    concord ps w a = c * discord ps k a ∧ discord ps w a = c * concord ps k a :=
  have ex : ∀ p q, p ∈ ps → q ∈ ps → excess (w p) (w q) = c * excess (k q) (k p) :=
    fun p q mp mq => excess_of_balance (same p q mp mq)
  ⟨((total_eq_of_mem fun p mp => (total_eq_of_mem fun q mq =>
      (congrArg (· * excess (a p) (a q)) (ex p q mp mq)).trans (mul_assoc_nat _ _ _)).trans
        (total_mul c (fun q => excess (k q) (k p) * excess (a p) (a q)) ps)).trans
      (total_mul c (fun p => total ps fun q => excess (k q) (k p) * excess (a p) (a q)) ps)).trans
      (congrArg (c * ·) (total_swap (fun p q => excess (k q) (k p) * excess (a p) (a q)) ps ps)),
   ((total_eq_of_mem fun p mp => (total_eq_of_mem fun q mq =>
      (congrArg (· * excess (a q) (a p)) (ex p q mp mq)).trans (mul_assoc_nat _ _ _)).trans
        (total_mul c (fun q => excess (k q) (k p) * excess (a q) (a p)) ps)).trans
      (total_mul c (fun p => total ps fun q => excess (k q) (k p) * excess (a q) (a p)) ps)).trans
      (congrArg (c * ·) (total_swap (fun p q => excess (k q) (k p) * excess (a q) (a p)) ps ps))⟩

theorem rising_of_affine {ps : List α} {W k : α → Nat} {C d : Nat}
    (aff : ∀ p, p ∈ ps → W p = C + d * k p) :
    ∀ p q, p ∈ ps → q ∈ ps → W p + d * k q = W q + d * k p :=
  fun p q mp mq => by rw [aff p mp, aff q mq, Nat.add_right_comm]

theorem falling_of_affine {ps : List α} {W k : α → Nat} {C d : Nat}
    (aff : ∀ p, p ∈ ps → W p + d * k p = C) :
    ∀ p q, p ∈ ps → q ∈ ps → W p + d * k p = W q + d * k q :=
  fun p q mp mq => (aff p mp).trans (aff q mq).symm

theorem mem_two {s t p : α} (m : p ∈ [s, t]) : p = s ∨ p = t :=
  match m with
  | .head _ => .inl rfl
  | .tail _ (.head _) => .inr rfl
  | .tail _ (.tail _ h) => nomatch h

end Moving

/-! ## The four terms on a cohort of pairs -/

/-- Within a pair, offspring move with own withholding by `β + γ`. -/
theorem pair_rising (a β γ n : Nat) (s : Place) :
    ∀ p q, p ∈ [s, s.other] → q ∈ [s, s.other] →
      p.offspring a β γ n + (β + γ) * q.withheld n =
        q.offspring a β γ n + (β + γ) * p.withheld n :=
  fun p q mp mq => by
    cases mem_two mp with
    | inl hp =>
      cases mem_two mq with
      | inl hq => rw [hp, hq]
      | inr hq => rw [hp, hq]; exact pair_balance a β γ n s
    | inr hp =>
      cases mem_two mq with
      | inl hq => rw [hp, hq]; exact (pair_balance a β γ n s).symm
      | inr hq => rw [hp, hq]

/-- **Within a pair, the concordance and discordance of offspring with any amount are `β + γ`
times those of own withholding.** -/
theorem pair_within (a β γ n : Nat) (s : Place) (amt : Place → Nat) :
    concord [s, s.other] (Place.offspring a β γ n) amt =
        (β + γ) * concord [s, s.other] (fun p => p.withheld n) amt ∧
      discord [s, s.other] (Place.offspring a β γ n) amt =
        (β + γ) * discord [s, s.other] (fun p => p.withheld n) amt :=
  concord_of_rising (pair_rising a β γ n s) amt

/-- **On a cohort listed as pairs, the within-pair terms are `β + γ` times those of own
withholding**, for any laws, marks and errors. -/
theorem within_pairs (a β γ n : Nat) {gs : List (List Place)}
    (paired : ∀ g, g ∈ gs → ∃ s, g = [s, s.other]) (amt : Place → Nat) :
    concordWithinBy gs (fun _ => 1) (Place.offspring a β γ n) amt =
        (β + γ) * concordWithinBy gs (fun _ => 1) (fun p => p.withheld n) amt ∧
      discordWithinBy gs (fun _ => 1) (Place.offspring a β γ n) amt =
        (β + γ) * discordWithinBy gs (fun _ => 1) (fun p => p.withheld n) amt :=
  ⟨(total_eq_of_mem fun g mg => match g, paired g mg with
      | _, ⟨s, rfl⟩ => (congrArg (1 * ·) (pair_within a β γ n s amt).1).trans
          (mul_turn 1 (β + γ) _)).trans
    (total_mul (β + γ) (fun g => 1 * concord g (fun p => p.withheld n) amt) gs),
   (total_eq_of_mem fun g mg => match g, paired g mg with
      | _, ⟨s, rfl⟩ => (congrArg (1 * ·) (pair_within a β γ n s amt).2).trans
          (mul_turn 1 (β + γ) _)).trans
    (total_mul (β + γ) (fun g => 1 * discord g (fun p => p.withheld n) amt) gs)⟩

/-- Where `γ = β + d`, a pair's offspring is twice `a + β n` with `d` times its withholding. -/
theorem pair_affine_le (a β d n : Nat) (s : Place) :
    1 * total [s, s.other] (Place.offspring a β (β + d) n) =
      (a + β * n) + (a + β * n) + d * (1 * total [s, s.other] (fun p => p.withheld n)) :=
  have h' : s.offspring a β (β + d) n + s.other.offspring a β (β + d) n +
        β * (s.withheld n + s.other.withheld n) =
      (a + β * n) + (a + β * n) + d * (s.withheld n + s.other.withheld n) +
        β * (s.withheld n + s.other.withheld n) :=
    (pair_total a β (β + d) n s).trans (by
      rw [add_mul_split, ← Nat.add_assoc, Nat.add_right_comm (a + β * n + (a + β * n))])
  (Nat.one_mul _).trans ((Naturals.add_right_cancel h').trans
    (congrArg (fun x => (a + β * n) + (a + β * n) + d * x) (Nat.one_mul _).symm))

/-- Where `β = γ + d`, a pair's offspring with `d` times its withholding is twice `a + β n`. -/
theorem pair_affine_ge (a γ d n : Nat) (s : Place) :
    1 * total [s, s.other] (Place.offspring a (γ + d) γ n) +
        d * (1 * total [s, s.other] (fun p => p.withheld n)) =
      (a + (γ + d) * n) + (a + (γ + d) * n) :=
  have h' : s.offspring a (γ + d) γ n + s.other.offspring a (γ + d) γ n +
        d * (s.withheld n + s.other.withheld n) + γ * (s.withheld n + s.other.withheld n) =
      (a + (γ + d) * n) + (a + (γ + d) * n) + γ * (s.withheld n + s.other.withheld n) :=
    ((Nat.add_assoc _ _ _).trans (congrArg (_ + ·) ((Nat.add_comm _ _).trans
      (add_mul_split γ d _).symm))).trans (pair_total a (γ + d) γ n s)
  (Naturals.add_congr (Nat.one_mul _) (congrArg (d * ·) (Nat.one_mul _))).trans
    (Naturals.add_right_cancel h')

/-- **Among pairs, where `γ = β + d`, the means' concordance and discordance are `d` times those
of the pairs' withholding.** -/
theorem means_of_le (a β d n : Nat) {gs : List (List Place)}
    (paired : ∀ g, g ∈ gs → ∃ s, g = [s, s.other]) (amt : Place → Nat) :
    concordMeans gs (fun _ => 1) (Place.offspring a β (β + d) n) amt =
        d * concordMeans gs (fun _ => 1) (fun p => p.withheld n) amt ∧
      discordMeans gs (fun _ => 1) (Place.offspring a β (β + d) n) amt =
        d * discordMeans gs (fun _ => 1) (fun p => p.withheld n) amt :=
  concord_of_rising (ps := context gs) (w := fun g => 1 * total g (Place.offspring a β (β + d) n))
    (k := fun g => 1 * total g (fun p => p.withheld n))
    (rising_of_affine (C := (a + β * n) + (a + β * n)) fun g mg =>
      match g, paired g (mem_of_mem_context mg) with
      | _, ⟨s, rfl⟩ => pair_affine_le a β d n s) (fun g => 1 * total g amt)

/-- **Among pairs, where `β = γ + d`, the means' concordance is `d` times the discordance of the
pairs' withholding, and their discordance `d` times its concordance.** -/
theorem means_of_ge (a γ d n : Nat) {gs : List (List Place)}
    (paired : ∀ g, g ∈ gs → ∃ s, g = [s, s.other]) (amt : Place → Nat) :
    concordMeans gs (fun _ => 1) (Place.offspring a (γ + d) γ n) amt =
        d * discordMeans gs (fun _ => 1) (fun p => p.withheld n) amt ∧
      discordMeans gs (fun _ => 1) (Place.offspring a (γ + d) γ n) amt =
        d * concordMeans gs (fun _ => 1) (fun p => p.withheld n) amt :=
  concord_of_falling (ps := context gs) (w := fun g => 1 * total g (Place.offspring a (γ + d) γ n))
    (k := fun g => 1 * total g (fun p => p.withheld n))
    (falling_of_affine (C := (a + (γ + d) * n) + (a + (γ + d) * n)) fun g mg =>
      match g, paired g (mem_of_mem_context mg) with
      | _, ⟨s, rfl⟩ => pair_affine_ge a γ d n s) (fun g => 1 * total g amt)

theorem two_of_paired {gs : List (List Place)} (paired : ∀ g, g ∈ gs → ∃ s, g = [s, s.other]) :
    ∀ g, g ∈ gs → g.length = 2 := fun g mg => match g, paired g mg with
  | _, ⟨_, rfl⟩ => rfl

/-- **The four-term law in withholding counts, where `γ = β + d`**: on a cohort listed as pairs,
for any laws, marks and errors, the whole selects for an amount exactly where the four terms of
own withholding, the within-pair ones by `β + γ` and the among-pair ones by `d`, do. -/
theorem pairs_rises_iff_withheld_le (a β d n : Nat) {gs : List (List Place)}
    (paired : ∀ g, g ∈ gs → ∃ s, g = [s, s.other]) (amt : Place → Nat) :
    discord (whole gs) (Place.offspring a β (β + d) n) amt <
        concord (whole gs) (Place.offspring a β (β + d) n) amt ↔
      2 * (whole gs).length *
            ((β + (β + d)) * discordWithinBy gs (fun _ => 1) (fun p => p.withheld n) amt) +
          d * discordMeans gs (fun _ => 1) (fun p => p.withheld n) amt <
        2 * (whole gs).length *
            ((β + (β + d)) * concordWithinBy gs (fun _ => 1) (fun p => p.withheld n) amt) +
          d * concordMeans gs (fun _ => 1) (fun p => p.withheld n) amt := by
  have w := within_pairs a β (β + d) n paired amt
  have m := means_of_le a β d n paired amt
  rw [← w.1, ← w.2, ← m.1, ← m.2]
  exact pairs_rises_iff gs (two_of_paired paired) _ amt

/-- **The four-term law in withholding counts, where `β = γ + d`**: the among-pair terms
exchange, so the whole selects for an amount exactly where `d` times the discordance of the
pairs' withholding with the amount, with the within-pair concordance of own withholding by
`β + γ`, exceeds the same with the roles exchanged. -/
theorem pairs_rises_iff_withheld_ge (a γ d n : Nat) {gs : List (List Place)}
    (paired : ∀ g, g ∈ gs → ∃ s, g = [s, s.other]) (amt : Place → Nat) :
    discord (whole gs) (Place.offspring a (γ + d) γ n) amt <
        concord (whole gs) (Place.offspring a (γ + d) γ n) amt ↔
      2 * (whole gs).length *
            (((γ + d) + γ) * discordWithinBy gs (fun _ => 1) (fun p => p.withheld n) amt) +
          d * concordMeans gs (fun _ => 1) (fun p => p.withheld n) amt <
        2 * (whole gs).length *
            (((γ + d) + γ) * concordWithinBy gs (fun _ => 1) (fun p => p.withheld n) amt) +
          d * discordMeans gs (fun _ => 1) (fun p => p.withheld n) amt := by
  have w := within_pairs a (γ + d) γ n paired amt
  have m := means_of_ge a γ d n paired amt
  rw [← w.1, ← w.2, ← m.1, ← m.2]
  exact pairs_rises_iff gs (two_of_paired paired) _ amt

/-- The premise is met by the record's cohorts. -/
example (a β d n x y z : Nat) := pairs_rises_iff_withheld_le a β d n (cohort_paired x y z)
  (amountOf Place.kind)

end EL7a
end Becoming

#print axioms Becoming.EL7a.offspring_balance
#print axioms Becoming.EL7a.pair_balance
#print axioms Becoming.EL7a.pair_total
#print axioms Becoming.EL7a.sum_balance
#print axioms Becoming.EL7a.kind_rises_iff_withheld
#print axioms Becoming.EL7a.excess_of_balance
#print axioms Becoming.EL7a.concord_of_rising
#print axioms Becoming.EL7a.concord_of_falling
#print axioms Becoming.EL7a.within_pairs
#print axioms Becoming.EL7a.means_of_le
#print axioms Becoming.EL7a.means_of_ge
#print axioms Becoming.EL7a.pairs_rises_iff_withheld_le
#print axioms Becoming.EL7a.pairs_rises_iff_withheld_ge
