import Becoming.Evolution

/-!
# The selection term: covariation of offspring number and amount, over generations

`Becoming.Evolution` states the counting form of Price's equation (`price`) and leaves its
selection term proper unstated: the weighted total `selected` is not selection, since where
every parent has the same number of offspring it is that number times the parents' total
(`selected_uniform`). This module states the selection term proper in counting form and
follows it over many generations of descent.

* **Covariation, an arithmetic identity with no premise.** Over any finite family read with
  weights and amounts, call a pair of members *concordant* by how much the one with more
  weight also has more amount, and *discordant* by how much the one with more weight has
  less (`concord`, `discord`: the products of the two excesses, over ordered pairs). Then the
  number of members times the weighted total, with the discordant pairs, is the total weight
  times the total amount, with the concordant pairs (`covariation`). Read over the rationals and
  divided by the square of the number of members, concordance less discordance is the
  covariance of weight and amount, so the identity is that covariance with its denominators
  cleared; both sides are natural numbers and nothing is subtracted. The rational reading is
  arithmetic and is not stated here. The identity rests on one balance for each pair
  (`pair_balance`).
* **The selection term proper.** With offspring numbers as weights, the parents' weighted
  total exceeds its uniform share (the number of offspring times the parents' total, over the
  number of parents) exactly where concordance exceeds discordance, and equals it exactly
  where they are equal (`selection_exceeds_iff`, `selection_none_iff`). Where offspring
  numbers are uniform, or amounts are, both vanish (`concord_uniform`, `discord_uniform`,
  `concord_alike`, `discord_alike`), which is the ninth review's probe answered: the weighted
  total moves, selection proper does not. With `price`, the number of parents times the
  offspring's total, with what transmission lowered so counted and the discordant pairs, is
  the number of offspring times the parents' total, with the concordant pairs and what
  transmission raised so counted (`offspring_covariation`). Read over the rationals and divided
  through, this is the standard form of Price's equation: the change of the mean amount times
  the mean offspring number is the covariance of offspring number and amount with the mean,
  over parents, of each parent's offspring number times its offspring's mean change.
* **Selection through support.** Where a member below another in amount has no more weight,
  nothing is discordant and the weighted total is at least its uniform share
  (`discord_zero_of_below`, `share_le_of_below`). `Becoming.Capture`'s premise (each carrier of a
  target leaves at least as many offspring as each other parent) is this condition for an amount
  of one at the carriers and none elsewhere. Where only active formations give and activity
  needs support (`Becoming.Evolution`), an unsupported parent leaves no offspring, so a reading
  highest at the supported parents is never selected against: the selection term proper on it
  is not negative (`Flow.support_not_against`). Over generations of descent in such a flow
  (`Flow.Descended`), a reading highest at each generation's supported members, which
  transmission never lowers, has a mean that does not fall over any stretch
  (`Flow.support_not_lower`, from `Generations.not_lower_step` and `Generations.not_lower`);
  with exact transmission it moves only upward, and only through a step where more offspring
  go with more of it (`Flow.support_moved_rises`).
* **Over generations.** Generations are given by a first family and, at each step, the
  offspring of each member (`Generations`, `Generations.family`); the next generation is the
  offspring of the last, so the number of offspring is the next generation's size and the
  offspring's total is its total (`Generations.born_eq`, `Generations.offspring_eq`). At each
  step the mean amount (the total over the size, compared by cross-multiplying) moves by the
  selection term proper and transmission together (`Generations.mean_step`): it is kept
  exactly where they balance, and rises exactly where concordance with what transmission
  raised exceeds discordance with what it lowered (`Generations.kept_step_iff`,
  `Generations.rises_step_iff`). Kept at every step of a stretch, the mean is kept over the
  stretch; rising at every step, it rises over it (`Generations.kept`, `Generations.rises`),
  an empty generation leaving the next one empty (`Generations.empty_after`).
* **What moves a mean.** Conversely, where the mean of a generation differs from the first,
  some step before it is unbalanced, and the step is found by deciding each one
  (`Generations.moved_unbalanced`). With exact transmission (each offspring carries its
  parent's amount, `Exact`) the step has selection proper (`Generations.moved_by_selection`);
  with uniform offspring numbers it has inexact transmission
  (`Generations.moved_by_transmission`). So a mean amount moves over generations of descent
  only through selection proper or transmission, the counting form of the response to
  selection.
* **Witnesses.** A parent carrying one unit with two offspring beside a parent carrying none
  with none: transmission is exact, concordance is two and discordance none, and the mean
  rises from a half to one (`Rising`). Two parents each with two offspring: the weighted total
  is twice the parents' total, selection proper is none and the mean is kept (`Doubling`). On
  `Drawdown`'s flow, its parent and two descendants are generations of descent meeting the
  support laws' premises, the reading highest at the descendant needing less; the mean rises,
  here by transmission (`SupportedDescent`).

Nothing is supposed about how the offspring come about or what the amounts are; the weights
are any natural numbers and, over generations, the offspring numbers. Modelling choices:
natural-number amounts and weights, finite families as lists, discrete generations. Rational
amounts with a common denominator, a selection term read of support, and a law of forming
are not stated here. No ethical predicate, ranking or axiom occurs; every declaration has an
empty axiom report.
-/

namespace Becoming

namespace SelectionTerm

variable {α : Type}

/-! ## Arithmetic -/

/-- What exceeds by `d` exceeds by `d`. -/
theorem excess_add_left : ∀ x d : Nat, excess (x + d) x = d
  | 0, 0 => rfl
  | 0, d + 1 => (congrArg (excess · 0) (Nat.zero_add (d + 1))).trans rfl
  | x + 1, d => (congrArg (excess · (x + 1)) (Nat.succ_add x d)).trans (excess_add_left x d)

/-- Nothing falls short of what exceeds it. -/
theorem excess_self_add : ∀ x d : Nat, excess x (x + d) = 0
  | 0, _ => rfl
  | x + 1, d => (congrArg (excess (x + 1)) (Nat.succ_add x d)).trans (excess_self_add x d)

/-- Halves of equal doubles are equal. -/
theorem half : ∀ {a b : Nat}, a + a = b + b → a = b
  | 0, 0, _ => rfl
  | 0, _ + 1, same => Nat.noConfusion same
  | _ + 1, 0, same => Nat.noConfusion same
  | a + 1, b + 1, same =>
    have inner : (a + 1) + a = (b + 1) + b := Nat.succ.inj same
    congrArg (· + 1) (half (Nat.succ.inj
      ((Nat.succ_add a a).symm.trans (inner.trans (Nat.succ_add b b)))))

/-- What balances orders alike: where `x + p = y + q`, `y` is below `x` exactly where `p` is
below `q`. -/
theorem lt_iff_of_balance {x p y q : Nat} (same : x + p = y + q) : y < x ↔ p < q :=
  ⟨fun below => Nat.lt_of_add_lt_add_left (Nat.lt_of_lt_of_le
      (Nat.add_lt_add_right below p) (Nat.le_of_eq same)),
    fun below => Nat.lt_of_add_lt_add_right (Nat.lt_of_lt_of_le
      (Nat.add_lt_add_left below y) (Nat.le_of_eq same.symm))⟩

/-- And equal alike. -/
theorem eq_iff_of_balance {x p y q : Nat} (same : x + p = y + q) : y = x ↔ p = q :=
  ⟨fun eq => Naturals.add_left_cancel ((congrArg (· + p) eq).trans same),
    fun eq => (add_right_cancel p (same.trans (congrArg (y + ·) eq.symm))).symm⟩

/-- And at most alike. -/
theorem le_of_mul_le_mul {m a b : Nat} (pos : 0 < m) (le : m * a ≤ m * b) : a ≤ b :=
  match Nat.lt_or_ge b a with
  | .inl lt => absurd (Nat.lt_of_le_of_lt le (Nat.mul_lt_mul_of_pos_left lt pos)) (Nat.lt_irrefl _)
  | .inr ge => ge

theorem pos_of_mul_pos {m a : Nat} (pos : 0 < m * a) : 0 < m :=
  match m, pos with
  | 0, pos => absurd (Nat.lt_of_lt_of_le pos (Nat.le_of_eq (Nat.zero_mul a))) (Nat.lt_irrefl 0)
  | _ + 1, _ => Nat.succ_pos _

/-- Two sums in which both terms trade places. -/
theorem swap_both (a b c d : Nat) : a + b + (c + d) = b + a + (d + c) :=
  (congrArg (· + (c + d)) (Nat.add_comm a b)).trans (congrArg (b + a + ·) (Nat.add_comm c d))

/-! ## One pair -/

/-- How much the pair is concordant: the first has more weight and more amount, or less of
both. -/
def concordPair (x y u v : Nat) : Nat := excess x y * excess u v + excess y x * excess v u

/-- How much the pair is discordant: the first has more weight and less amount, or the
reverse. -/
def discordPair (x y u v : Nat) : Nat := excess x y * excess v u + excess y x * excess u v

theorem pair_ordered (x d u f : Nat) :
    x * u + (x + d) * (u + f) + discordPair x (x + d) u (u + f) =
      x * (u + f) + (x + d) * u + concordPair x (x + d) u (u + f) := by
  unfold discordPair concordPair
  rw [excess_self_add x d, excess_add_left x d, excess_self_add u f, excess_add_left u f,
    Nat.zero_mul f]
  show x * u + (x + d) * (u + f) + (0 + 0) = x * (u + f) + (x + d) * u + (0 + d * f)
  rw [Nat.zero_add (d * f)]
  show x * u + (x + d) * (u + f) = x * (u + f) + (x + d) * u + d * f
  rw [add_mul_split x d (u + f), add_mul_split x d u, Nat.left_distrib d u f]
  exact (Nat.add_left_comm (x * u) (x * (u + f)) (d * u + d * f)).trans
    ((congrArg (x * (u + f) + ·) (Nat.add_assoc (x * u) (d * u) (d * f)).symm).trans
      (Nat.add_assoc (x * (u + f)) (x * u + d * u) (d * f)).symm)

/-- The balance of one pair: the products of each member's own weight and amount, with the
pair's discordance, are the crossed products with its concordance. -/
theorem pair_balance (x y u v : Nat) :
    x * u + y * v + discordPair x y u v = x * v + y * u + concordPair x y u v :=
  match Nat.le_total x y, Nat.le_total u v with
  | .inl xy, .inl uv => by
    obtain ⟨d, rfl⟩ := le_dest xy
    obtain ⟨f, rfl⟩ := le_dest uv
    exact pair_ordered x d u f
  | .inl xy, .inr vu => by
    obtain ⟨d, rfl⟩ := le_dest xy
    obtain ⟨f, rfl⟩ := le_dest vu
    exact (pair_ordered x d v f).symm
  | .inr yx, .inr vu => by
    obtain ⟨d, rfl⟩ := le_dest yx
    obtain ⟨f, rfl⟩ := le_dest vu
    exact (swap_both _ _ _ _).trans ((pair_ordered y d v f).trans (swap_both _ _ _ _))
  | .inr yx, .inl uv => by
    obtain ⟨d, rfl⟩ := le_dest yx
    obtain ⟨f, rfl⟩ := le_dest uv
    exact ((swap_both _ _ _ _).trans ((pair_ordered y d u f).trans (swap_both _ _ _ _))).symm

/-! ## Covariation -/

/-- Each member's weight times its amount, totalled. -/
def weighted (ps : List α) (w a : α → Nat) : Nat := total ps fun p => w p * a p

/-- Concordance over ordered pairs: by how much more weight goes with more amount. -/
def concord (ps : List α) (w a : α → Nat) : Nat :=
  total ps fun p => total ps fun q => excess (w p) (w q) * excess (a p) (a q)

/-- Discordance over ordered pairs: by how much more weight goes with less amount. -/
def discord (ps : List α) (w a : α → Nat) : Nat :=
  total ps fun p => total ps fun q => excess (w p) (w q) * excess (a q) (a p)

/-- A total over ordered pairs of a sum is the sum of the totals. -/
theorem pairs_add (ps : List α) (F G : α → α → Nat) :
    (total ps fun p => total ps fun q => F p q + G p q) =
      (total ps fun p => total ps (F p)) + total ps fun p => total ps (G p) :=
  (total_congr (fun p => total_add (F p) (G p) ps) ps).trans (total_add _ _ ps)

theorem pairs_own (ps : List α) (c : α → Nat) :
    (total ps fun p => total ps fun _ => c p) = ps.length * total ps c :=
  (total_congr (fun p => total_const (c p) ps) ps).trans (total_mul ps.length c ps)

theorem pairs_other (ps : List α) (c : α → Nat) :
    (total ps fun _ => total ps c) = ps.length * total ps c :=
  total_const (total ps c) ps

/-- Crossed products total the product of the totals. -/
theorem pairs_cross (ps : List α) (w a : α → Nat) :
    (total ps fun p => total ps fun q => w p * a q) = total ps w * total ps a :=
  (total_congr (fun p => total_mul (w p) a ps) ps).trans
    ((total_congr (fun p => Nat.mul_comm (w p) (total ps a)) ps).trans
      ((total_mul (total ps a) w ps).trans (Nat.mul_comm _ _)))

theorem pairs_cross' (ps : List α) (w a : α → Nat) :
    (total ps fun p => total ps fun q => w q * a p) = total ps w * total ps a :=
  (total_swap (fun p q => w q * a p) ps ps).trans (pairs_cross ps w a)

/-- Discordance read from the second member of each pair is discordance. -/
theorem discord_swap (ps : List α) (w a : α → Nat) :
    (total ps fun p => total ps fun q => excess (w q) (w p) * excess (a p) (a q)) =
      discord ps w a :=
  total_swap (fun p q => excess (w q) (w p) * excess (a p) (a q)) ps ps

theorem concord_swap (ps : List α) (w a : α → Nat) :
    (total ps fun p => total ps fun q => excess (w q) (w p) * excess (a q) (a p)) =
      concord ps w a :=
  total_swap (fun p q => excess (w q) (w p) * excess (a q) (a p)) ps ps

/-- Covariation: the number of members times the weighted total, with the discordant pairs,
is the total weight times the total amount, with the concordant pairs. Divided by the square
of the number of members, concordance less discordance is the covariance of weight and
amount. No premise. -/
theorem covariation (ps : List α) (w a : α → Nat) :
    ps.length * weighted ps w a + discord ps w a = total ps w * total ps a + concord ps w a :=
  have summed : (total ps fun p => total ps fun q => w p * a p + w q * a q +
        (excess (w p) (w q) * excess (a q) (a p) + excess (w q) (w p) * excess (a p) (a q))) =
      (total ps fun p => total ps fun q => w p * a q + w q * a p +
        (excess (w p) (w q) * excess (a p) (a q) + excess (w q) (w p) * excess (a q) (a p))) :=
    total_congr (fun p => total_congr (fun q => pair_balance (w p) (w q) (a p) (a q)) ps) ps
  have own : (total ps fun p => total ps fun q => w p * a p + w q * a q +
        (excess (w p) (w q) * excess (a q) (a p) + excess (w q) (w p) * excess (a p) (a q))) =
      ps.length * weighted ps w a + ps.length * weighted ps w a +
        (discord ps w a + discord ps w a) :=
    (pairs_add ps (fun p q => w p * a p + w q * a q)
        (fun p q => excess (w p) (w q) * excess (a q) (a p) +
          excess (w q) (w p) * excess (a p) (a q))).trans
      (Naturals.add_congr
        ((pairs_add ps (fun p _ => w p * a p) (fun _ q => w q * a q)).trans
          (Naturals.add_congr (pairs_own ps fun p => w p * a p)
            (pairs_other ps fun q => w q * a q)))
        ((pairs_add ps (fun p q => excess (w p) (w q) * excess (a q) (a p))
            (fun p q => excess (w q) (w p) * excess (a p) (a q))).trans
          (congrArg (discord ps w a + ·) (discord_swap ps w a))))
  have crossed : (total ps fun p => total ps fun q => w p * a q + w q * a p +
        (excess (w p) (w q) * excess (a p) (a q) + excess (w q) (w p) * excess (a q) (a p))) =
      total ps w * total ps a + total ps w * total ps a + (concord ps w a + concord ps w a) :=
    (pairs_add ps (fun p q => w p * a q + w q * a p)
        (fun p q => excess (w p) (w q) * excess (a p) (a q) +
          excess (w q) (w p) * excess (a q) (a p))).trans
      (Naturals.add_congr
        ((pairs_add ps (fun p q => w p * a q) (fun p q => w q * a p)).trans
          (Naturals.add_congr (pairs_cross ps w a) (pairs_cross' ps w a)))
        ((pairs_add ps (fun p q => excess (w p) (w q) * excess (a p) (a q))
            (fun p q => excess (w q) (w p) * excess (a q) (a p))).trans
          (congrArg (concord ps w a + ·) (concord_swap ps w a))))
  half ((Nat.add_add_add_comm _ _ _ _).trans
    (own.symm.trans (summed.trans (crossed.trans (Nat.add_add_add_comm _ _ _ _).symm))))

/-- More weight goes with more amount than with less exactly where the weighted total exceeds
its uniform share. -/
theorem exceeds_iff (ps : List α) (w a : α → Nat) :
    total ps w * total ps a < ps.length * weighted ps w a ↔ discord ps w a < concord ps w a :=
  lt_iff_of_balance (covariation ps w a)

theorem none_iff (ps : List α) (w a : α → Nat) :
    total ps w * total ps a = ps.length * weighted ps w a ↔ discord ps w a = concord ps w a :=
  eq_iff_of_balance (covariation ps w a)

theorem pairs_zero {ps : List α} {F : α → α → Nat}
    (zero : ∀ p q, p ∈ ps → q ∈ ps → F p q = 0) : (total ps fun p => total ps (F p)) = 0 :=
  total_eq_zero fun p mp => total_eq_zero fun q mq => zero p q mp mq

/-- With uniform weights nothing is concordant. -/
theorem concord_uniform {ps : List α} {w : α → Nat} {k : Nat} (same : ∀ p, p ∈ ps → w p = k)
    (a : α → Nat) : concord ps w a = 0 :=
  pairs_zero fun p q mp mq => by
    rw [same p mp, same q mq, excess_self, Nat.zero_mul]

theorem discord_uniform {ps : List α} {w : α → Nat} {k : Nat} (same : ∀ p, p ∈ ps → w p = k)
    (a : α → Nat) : discord ps w a = 0 :=
  pairs_zero fun p q mp mq => by
    rw [same p mp, same q mq, excess_self, Nat.zero_mul]

/-- With uniform amounts nothing is concordant. -/
theorem concord_alike {ps : List α} {a : α → Nat} {k : Nat} (same : ∀ p, p ∈ ps → a p = k)
    (w : α → Nat) : concord ps w a = 0 :=
  pairs_zero fun p q mp mq => by
    rw [same p mp, same q mq, excess_self]; rfl

theorem discord_alike {ps : List α} {a : α → Nat} {k : Nat} (same : ∀ p, p ∈ ps → a p = k)
    (w : α → Nat) : discord ps w a = 0 :=
  pairs_zero fun p q mp mq => by
    rw [same p mp, same q mq, excess_self]; rfl

/-! ## The selection term proper -/

/-- The number of offspring, over a finite family of parents. -/
def born (ps : List α) (kids : α → List α) : Nat := total ps fun p => (kids p).length

/-- The selection term proper: the number of parents times the offspring-weighted amounts,
with the pairs where more offspring go with less amount, is the number of offspring times the
parents' total, with the pairs where more offspring go with more amount. -/
theorem selection_covariation (ps : List α) (kids : α → List α) (a : α → Nat) :
    ps.length * selected ps kids a + discord ps (fun p => (kids p).length) a =
      born ps kids * total ps a + concord ps (fun p => (kids p).length) a :=
  covariation ps (fun p => (kids p).length) a

/-- The weighted total exceeds its uniform share exactly where concordance exceeds
discordance. -/
theorem selection_exceeds_iff (ps : List α) (kids : α → List α) (a : α → Nat) :
    born ps kids * total ps a < ps.length * selected ps kids a ↔
      discord ps (fun p => (kids p).length) a < concord ps (fun p => (kids p).length) a :=
  exceeds_iff ps _ a

theorem selection_none_iff (ps : List α) (kids : α → List α) (a : α → Nat) :
    born ps kids * total ps a = ps.length * selected ps kids a ↔
      discord ps (fun p => (kids p).length) a = concord ps (fun p => (kids p).length) a :=
  none_iff ps _ a

/-- Price's equation with its selection term proper, denominators cleared: the number of
parents times the offspring's total, with what transmission lowered so counted and the
discordant pairs, is the number of offspring times the parents' total, with the concordant
pairs and what transmission raised so counted. -/
theorem offspring_covariation (ps : List α) (kids : α → List α) (a b : α → Nat) :
    ps.length * offspring ps kids b +
        (ps.length * lowered ps kids a b + discord ps (fun p => (kids p).length) a) =
      born ps kids * total ps a +
        (concord ps (fun p => (kids p).length) a + ps.length * raised ps kids a b) := by
  have scaled : ps.length * (offspring ps kids b + lowered ps kids a b) =
      ps.length * (selected ps kids a + raised ps kids a b) := congrArg _ (price ps kids a b)
  rw [Nat.left_distrib, Nat.left_distrib] at scaled
  rw [← Nat.add_assoc, scaled, Nat.add_right_comm, selection_covariation, Nat.add_assoc]

/-- Each offspring carries its parent's amount. -/
def Exact (ps : List α) (kids : α → List α) (a b : α → Nat) : Prop :=
  ∀ p, p ∈ ps → ∀ k, k ∈ kids p → b k = a p

theorem raised_exact {ps : List α} {kids : α → List α} {a b : α → Nat}
    (exact : Exact ps kids a b) : raised ps kids a b = 0 :=
  total_eq_zero fun p mp => total_eq_zero fun k mk =>
    (congrArg (excess · (a p)) (exact p mp k mk)).trans (excess_self (a p))

theorem lowered_exact {ps : List α} {kids : α → List α} {a b : α → Nat}
    (exact : Exact ps kids a b) : lowered ps kids a b = 0 :=
  total_eq_zero fun p mp => total_eq_zero fun k mk =>
    (congrArg (excess (a p)) (exact p mp k mk)).trans (excess_self (a p))

/-- Where a member below another in amount has no more weight, nothing is discordant. -/
theorem discord_zero_of_below {ps : List α} {w a : α → Nat}
    (below : ∀ p q, p ∈ ps → q ∈ ps → a p < a q → w p ≤ w q) : discord ps w a = 0 :=
  pairs_zero fun p q mp mq =>
    match Nat.lt_or_ge (a p) (a q) with
    | .inl lt => by rw [Flow.excess_zero_of_le (below p q mp mq lt)]; exact Nat.zero_mul _
    | .inr ge => by rw [Flow.excess_zero_of_le ge]; rfl

/-- So the weighted total is at least its uniform share. -/
theorem share_le_of_below {ps : List α} {w a : α → Nat}
    (below : ∀ p q, p ∈ ps → q ∈ ps → a p < a q → w p ≤ w q) :
    total ps w * total ps a ≤ ps.length * weighted ps w a :=
  Nat.le_trans (Nat.le_add_right _ (concord ps w a))
    (Nat.le_of_eq ((covariation ps w a).symm.trans
      (congrArg (ps.length * weighted ps w a + ·) (discord_zero_of_below below))))

namespace Flow

variable {X : Type} {L : Flow X X} {W : Web X X}

/-- Selection through support, in the covariance form: where only active formations give and
activity needs support, and a reading `s` is highest at the supported parents, nothing is
discordant between offspring numbers and `s`, so the selection term proper on `s` is not
negative: the parents' offspring-weighted `s` is at least its uniform share. -/
theorem support_not_against (acting : L.Acting W) (dependent : W.Dependent) {t : Nat}
    {ps : List X} {kids : X → List X}
    (descend : ∀ p k, p ∈ ps → k ∈ kids p → L.DescendsAt W t k p) {s : X → Nat}
    (top : ∀ p, p ∈ ps → W.Supported t p → ∀ q, q ∈ ps → s q ≤ s p) :
    discord ps (fun p => (kids p).length) s = 0 ∧
      born ps kids * total ps s ≤ ps.length * selected ps kids s :=
  have below : ∀ p q, p ∈ ps → q ∈ ps → s p < s q → (kids p).length ≤ (kids q).length :=
    fun p q mp mq lt =>
      have unsupported : ¬ W.Supported t p :=
        fun supported => Nat.lt_irrefl _ (Nat.lt_of_lt_of_le lt (top p mp supported q mq))
      match kids p, descend p with
      | [], _ => Nat.zero_le _
      | k :: _, descends =>
        absurd (descends k mp (.head _)) (Becoming.Flow.unsupported_childless acting dependent unsupported k)
  ⟨discord_zero_of_below below, share_le_of_below below⟩

end Flow

/-! ## Over generations -/

/-- Generations of descent: a first family, the offspring of each member at each step, and
an amount read of each member at each step. -/
structure Generations (α : Type) where
  first : List α
  kids : Nat → α → List α
  amount : Nat → α → Nat

namespace Generations

variable (G : Generations α)

/-- The family at each step: the first, then the offspring of the last. -/
def family : Nat → List α
  | 0 => G.first
  | t + 1 => (family t).flatMap (G.kids t)

def size (t : Nat) : Nat := (G.family t).length

/-- The total amount of a generation; its mean is this over the size. -/
def sum (t : Nat) : Nat := total (G.family t) (G.amount t)

/-- The offspring numbers at a step. -/
def offspringNumber (t : Nat) (p : α) : Nat := (G.kids t p).length

def concordAt (t : Nat) : Nat := concord (G.family t) (G.offspringNumber t) (G.amount t)

def discordAt (t : Nat) : Nat := discord (G.family t) (G.offspringNumber t) (G.amount t)

def raisedAt (t : Nat) : Nat := raised (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1))

def loweredAt (t : Nat) : Nat := lowered (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1))

theorem total_flatMap (f : α → List α) (q : α → Nat) :
    ∀ ps : List α, total (ps.flatMap f) q = total ps fun p => total (f p) q
  | [] => rfl
  | p :: ps => (total_append q (ps.flatMap f) (f p)).trans
      (congrArg (total (f p) q + ·) (total_flatMap f q ps))

/-- The number of offspring is the next generation's size. -/
theorem born_eq (t : Nat) : born (G.family t) (G.kids t) = G.size (t + 1) :=
  (total_congr (fun p => (total_ones (G.kids t p)).symm) _).trans
    ((total_flatMap (G.kids t) (fun _ => 1) (G.family t)).symm.trans
      (total_ones (G.family (t + 1))))

/-- The offspring's total is the next generation's total. -/
theorem offspring_eq (t : Nat) :
    offspring (G.family t) (G.kids t) (G.amount (t + 1)) = G.sum (t + 1) :=
  (total_flatMap (G.kids t) (G.amount (t + 1)) (G.family t)).symm

/-- The mean moves by the selection term proper and transmission together: the size times the
next total, with what transmission lowered so counted and the discordant pairs, is the next
size times the total, with the concordant pairs and what transmission raised so counted. -/
theorem mean_step (t : Nat) :
    G.size t * G.sum (t + 1) + (G.size t * G.loweredAt t + G.discordAt t) =
      G.size (t + 1) * G.sum t + (G.concordAt t + G.size t * G.raisedAt t) := by
  have step := offspring_covariation (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1))
  rw [offspring_eq, born_eq] at step
  exact step

/-- A step is balanced where the selection term proper and transmission cancel. -/
def Balanced (t : Nat) : Prop :=
  G.size t * G.loweredAt t + G.discordAt t = G.concordAt t + G.size t * G.raisedAt t

/-- A step raises where concordance with what transmission raised exceeds discordance with
what it lowered. -/
def Raises (t : Nat) : Prop :=
  G.size t * G.loweredAt t + G.discordAt t < G.concordAt t + G.size t * G.raisedAt t

instance balancedDecidable (t : Nat) : Decidable (G.Balanced t) := Nat.decEq _ _

instance raisesDecidable (t : Nat) : Decidable (G.Raises t) := Nat.decLt _ _

/-- The mean is kept across a step exactly where it is balanced (means compared by
cross-multiplying). -/
theorem kept_step_iff (t : Nat) :
    G.size (t + 1) * G.sum t = G.size t * G.sum (t + 1) ↔ G.Balanced t :=
  eq_iff_of_balance (G.mean_step t)

/-- The mean rises across a step exactly where the step raises. -/
theorem rises_step_iff (t : Nat) :
    G.size (t + 1) * G.sum t < G.size t * G.sum (t + 1) ↔ G.Raises t :=
  lt_iff_of_balance (G.mean_step t)

/-- An empty generation leaves the next one empty. -/
theorem empty_after {t : Nat} (empty : G.size t = 0) : G.size (t + 1) = 0 ∧ G.sum (t + 1) = 0 :=
  have nil : G.family t = [] := nil_of_length_zero empty
  have next : G.family (t + 1) = [] :=
    (rfl : G.family (t + 1) = (G.family t).flatMap (G.kids t)).trans
      (congrArg (fun l : List α => l.flatMap (G.kids t)) nil)
  ⟨congrArg List.length next, congrArg (total · (G.amount (t + 1))) next⟩

/-- An empty generation totals nothing. -/
theorem empty_sum {t : Nat} (empty : G.size t = 0) : G.sum t = 0 :=
  congrArg (total · (G.amount t)) (nil_of_length_zero empty)

/-- A mean kept to a generation and across its step is kept to the next. -/
theorem kept_extend {T : Nat} (kept : G.size 0 * G.sum T = G.size T * G.sum 0)
    (step : G.Balanced T) : G.size 0 * G.sum (T + 1) = G.size (T + 1) * G.sum 0 := by
  have across := ((G.kept_step_iff T).mpr step).symm
  match pos : G.size T with
  | 0 =>
    have after := G.empty_after pos
    rw [after.1, after.2, Nat.zero_mul]
    rfl
  | m + 1 =>
    rw [pos] at kept across
    apply Nat.eq_of_mul_eq_mul_left (Nat.succ_pos m)
    rw [mul_turn (m + 1) (G.size 0) (G.sum (T + 1)), across,
      mul_turn (G.size 0) (G.size (T + 1)) (G.sum T), kept,
      mul_turn (G.size (T + 1)) (m + 1) (G.sum 0)]

/-- Balanced at every step of a stretch, the mean is kept over the stretch. -/
theorem kept : ∀ (T : Nat), (∀ t, t < T → G.Balanced t) →
    G.size 0 * G.sum T = G.size T * G.sum 0
  | 0, _ => rfl
  | T + 1, balanced => G.kept_extend (kept T fun t lt => balanced t (Nat.lt_succ_of_lt lt))
      (balanced T (Nat.lt_succ_self T))

/-- Raising at every step of a stretch, the mean rises over it. -/
theorem rises : ∀ (T : Nat), (∀ t, t < T + 1 → G.Raises t) →
    G.size (T + 1) * G.sum 0 < G.size 0 * G.sum (T + 1)
  | 0, raises => (G.rises_step_iff 0).mpr (raises 0 (Nat.succ_pos 0))
  | T + 1, raises => by
    have before := rises T fun t lt => raises t (Nat.lt_succ_of_lt lt)
    have across := (G.rises_step_iff (T + 1)).mpr (raises (T + 1) (Nat.lt_succ_self _))
    have middle : 0 < G.size (T + 1) := pos_of_mul_pos (Nat.lt_of_le_of_lt (Nat.zero_le _) across)
    have last : 0 < G.size (T + 1 + 1) := match pos : G.size (T + 1 + 1) with
      | 0 => absurd across (by
          rw [G.empty_sum pos]
          exact Nat.not_lt_zero _)
      | _ + 1 => Nat.succ_pos _
    apply Naturals.lt_of_mul_lt_mul_left (m := G.size (T + 1))
    rw [mul_turn (G.size (T + 1)) (G.size (T + 1 + 1)) (G.sum 0)]
    apply Nat.lt_of_lt_of_le (Nat.mul_lt_mul_of_pos_left before last)
    rw [mul_turn (G.size (T + 1 + 1)) (G.size 0) (G.sum (T + 1)),
      mul_turn (G.size (T + 1)) (G.size 0) (G.sum (T + 1 + 1))]
    exact Nat.mul_le_mul_left _ (Nat.le_of_lt across)

/-- Where nothing is discordant and transmission lowers nothing, the mean does not fall across
the step. -/
theorem not_lower_step {t : Nat} (none : G.discordAt t = 0) (unlowered : G.loweredAt t = 0) :
    G.size (t + 1) * G.sum t ≤ G.size t * G.sum (t + 1) := by
  have step := G.mean_step t
  rw [none, unlowered] at step
  have kept : G.size t * G.sum (t + 1) =
      G.size (t + 1) * G.sum t + (G.concordAt t + G.size t * G.raisedAt t) := step
  rw [kept]
  exact Nat.le_add_right _ _

/-- Not falling at any step of a stretch, the mean does not fall over it. -/
theorem not_lower : ∀ (T : Nat),
    (∀ t, t < T → G.size (t + 1) * G.sum t ≤ G.size t * G.sum (t + 1)) →
    G.size T * G.sum 0 ≤ G.size 0 * G.sum T
  | 0, _ => Nat.le_refl _
  | T + 1, steps => by
    have before := not_lower T fun t lt => steps t (Nat.lt_succ_of_lt lt)
    have across := steps T (Nat.lt_succ_self T)
    match pos : G.size T with
    | 0 =>
      rw [(G.empty_after pos).1, Nat.zero_mul]
      exact Nat.zero_le _
    | m + 1 =>
      rw [pos] at before across
      apply le_of_mul_le_mul (Nat.succ_pos m)
      rw [mul_turn (m + 1) (G.size (T + 1)) (G.sum 0)]
      apply Nat.le_trans (Nat.mul_le_mul_left (G.size (T + 1)) before)
      rw [mul_turn (G.size (T + 1)) (G.size 0) (G.sum T),
        mul_turn (m + 1) (G.size 0) (G.sum (T + 1))]
      exact Nat.mul_le_mul_left _ across

/-- What moves a mean: where a generation's mean differs from the first's, some step before it
is unbalanced, found by deciding each step. -/
theorem moved_unbalanced : ∀ {T : Nat}, G.size 0 * G.sum T ≠ G.size T * G.sum 0 →
    ∃ t, t < T ∧ ¬ G.Balanced t
  | 0, moved => absurd rfl moved
  | T + 1, moved =>
    match Nat.decEq (G.size T * G.loweredAt T + G.discordAt T)
        (G.concordAt T + G.size T * G.raisedAt T) with
    | isFalse unbalanced => ⟨T, Nat.lt_succ_self T, unbalanced⟩
    | isTrue balanced =>
      match moved_unbalanced (T := T) (fun kept => moved (G.kept_extend kept balanced)) with
      | ⟨t, lt, unbalanced⟩ => ⟨t, Nat.lt_succ_of_lt lt, unbalanced⟩

/-- With exact transmission at a step, it is balanced exactly where selection proper is none. -/
theorem balanced_exact_iff {t : Nat}
    (exact : Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1))) :
    G.Balanced t ↔ G.discordAt t = G.concordAt t := by
  unfold Balanced raisedAt loweredAt
  rw [raised_exact exact, lowered_exact exact, Nat.mul_zero, Nat.zero_add, Nat.add_zero]

/-- With exact transmission at a step, it raises exactly where concordance exceeds
discordance. -/
theorem raises_exact_iff {t : Nat}
    (exact : Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1))) :
    G.Raises t ↔ G.discordAt t < G.concordAt t := by
  unfold Raises raisedAt loweredAt
  rw [raised_exact exact, lowered_exact exact, Nat.mul_zero, Nat.zero_add, Nat.add_zero]

/-- With exact transmission, a moved mean has a step with selection proper. -/
theorem moved_by_selection {T : Nat}
    (exact : ∀ t, t < T → Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (moved : G.size 0 * G.sum T ≠ G.size T * G.sum 0) :
    ∃ t, t < T ∧ G.discordAt t ≠ G.concordAt t :=
  match G.moved_unbalanced moved with
  | ⟨t, lt, unbalanced⟩ =>
    ⟨t, lt, fun none => unbalanced ((G.balanced_exact_iff (exact t lt)).mpr none)⟩

/-- With uniform offspring numbers at a step, it is balanced exactly where transmission
lowers as much as it raises. -/
theorem balanced_uniform_iff {t k : Nat}
    (same : ∀ p, p ∈ G.family t → G.offspringNumber t p = k) :
    G.Balanced t ↔ G.size t * G.loweredAt t = G.size t * G.raisedAt t := by
  unfold Balanced concordAt discordAt
  rw [concord_uniform same, discord_uniform same, Nat.add_zero, Nat.zero_add]

/-- With uniform offspring numbers, a moved mean has a step with inexact transmission. -/
theorem moved_by_transmission {T : Nat}
    (uniform : ∀ t, t < T → ∃ k, ∀ p, p ∈ G.family t → G.offspringNumber t p = k)
    (moved : G.size 0 * G.sum T ≠ G.size T * G.sum 0) :
    ∃ t, t < T ∧ G.loweredAt t ≠ G.raisedAt t :=
  match G.moved_unbalanced moved with
  | ⟨t, lt, unbalanced⟩ => match uniform t lt with
    | ⟨_, same⟩ => ⟨t, lt, fun even => unbalanced ((G.balanced_uniform_iff same).mpr
        (congrArg (G.size t * ·) even))⟩

end Generations

namespace Flow

variable {X : Type} {L : Flow X X} {W : Web X X}

/-- Generations of descent in a flow: each listed offspring of a member at a step descends from
it across that step. -/
def Descended (L : Flow X X) (W : Web X X) (G : Generations X) : Prop :=
  ∀ t p k, p ∈ G.family t → k ∈ G.kids t p → L.DescendsAt W t k p

/-- Selection through support over generations of descent: where only active formations give
and activity needs support, a reading highest at each generation's supported members, which
transmission never lowers, has a mean that does not fall over any stretch. -/
theorem support_not_lower (acting : L.Acting W) (dependent : W.Dependent) {G : Generations X}
    (descended : Descended L W G)
    (top : ∀ t p, p ∈ G.family t → W.Supported t p → ∀ q, q ∈ G.family t →
      G.amount t q ≤ G.amount t p)
    {T : Nat} (unlowered : ∀ t, t < T → G.loweredAt t = 0) :
    G.size T * G.sum 0 ≤ G.size 0 * G.sum T :=
  G.not_lower T fun t lt => G.not_lower_step
    (support_not_against acting dependent (descended t) (top t)).1 (unlowered t lt)

/-- And with exact transmission the mean of such a reading moves only upward, and only by
selection proper: where it moved over a stretch it rose, and at some step of the stretch more
offspring went with more of it. -/
theorem support_moved_rises (acting : L.Acting W) (dependent : W.Dependent) {G : Generations X}
    (descended : Descended L W G)
    (top : ∀ t p, p ∈ G.family t → W.Supported t p → ∀ q, q ∈ G.family t →
      G.amount t q ≤ G.amount t p)
    {T : Nat} (exact : ∀ t, t < T → Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (moved : G.size 0 * G.sum T ≠ G.size T * G.sum 0) :
    G.size T * G.sum 0 < G.size 0 * G.sum T ∧ ∃ t, t < T ∧ G.discordAt t < G.concordAt t :=
  have none : ∀ t, G.discordAt t = 0 := fun t =>
    (support_not_against acting dependent (descended t) (top t)).1
  ⟨Nat.lt_of_le_of_ne (support_not_lower acting dependent descended top
      fun t lt => lowered_exact (exact t lt)) fun same => moved same.symm,
    match G.moved_by_selection exact moved with
    | ⟨t, lt, differ⟩ => ⟨t, lt, (none t).symm ▸ Nat.pos_of_ne_zero
        fun zero => differ ((none t).trans zero.symm)⟩⟩

end Flow

/-! ## Witnesses -/

namespace Rising

/-- A parent carrying one unit with two offspring carrying it, beside a parent carrying none
with none. -/
def generations : Generations Bool where
  first := [true, false]
  kids _ p := match p with
    | true => [true, true]
    | false => []
  amount _ p := match p with
    | true => 1
    | false => 0

theorem exact : Exact (generations.family 0) (generations.kids 0) (generations.amount 0)
    (generations.amount 1)
  | true, _, _, .head _ => rfl
  | true, _, _, .tail _ (.head _) => rfl
  | true, _, _, .tail _ (.tail _ mem) => nomatch mem
  | false, _, _, mem => nomatch mem

/-- Concordance two, discordance none, transmission exact, and the mean rises from a half to
one. -/
theorem rising :
    generations.concordAt 0 = 2 ∧ generations.discordAt 0 = 0 ∧
      generations.raisedAt 0 = 0 ∧ generations.loweredAt 0 = 0 ∧
      generations.size 0 = 2 ∧ generations.sum 0 = 1 ∧
      generations.size 1 = 2 ∧ generations.sum 1 = 2 ∧
      generations.size 1 * generations.sum 0 < generations.size 0 * generations.sum 1 ∧
      generations.Raises 0 :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl, by decide, by decide⟩

end Rising

namespace Doubling

/-- Two parents, carrying one unit and none, each with two offspring carrying its amount. -/
def generations : Generations Bool where
  first := [true, false]
  kids _ p := [p, p]
  amount _ p := match p with
    | true => 1
    | false => 0

/-- The weighted total is twice the parents' total, selection proper is none and the mean is
kept. -/
theorem doubling :
    selected (generations.family 0) (generations.kids 0) (generations.amount 0) = 2 ∧
      generations.sum 0 = 1 ∧ generations.concordAt 0 = 0 ∧ generations.discordAt 0 = 0 ∧
      generations.size 1 * generations.sum 0 = generations.size 0 * generations.sum 1 ∧
      generations.Balanced 0 :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩

end Doubling

namespace SupportedDescent

open Drawdown (Relatum)

/-- `Drawdown`'s descent as generations: the parent, then its two descendants, then none. The
reading is one at the parent and at the descendant inheriting its need, two at the one needing
less, and none at the pool. -/
def generations : Generations Relatum where
  first := [.parent]
  kids t p := match t, p with
    | 0, .parent => [.same, .varied]
    | 0, .pool => []
    | 0, .same => []
    | 0, .varied => []
    | _ + 1, _ => []
  amount _ x := match x with
    | .pool => 0
    | .parent => 1
    | .same => 1
    | .varied => 2

theorem family_late : ∀ n, generations.family (n + 2) = []
  | 0 => rfl
  | n + 1 => by
    show (generations.family (n + 2)).flatMap (generations.kids (n + 2)) = []
    rw [family_late n]
    rfl

theorem descended : Flow.Descended Drawdown.flow Drawdown.web generations
  | 0, _, _, .head _, .head _ => Drawdown.descends_same
  | 0, _, _, .head _, .tail _ (.head _) => Drawdown.descends_varied
  | 0, _, _, .head _, .tail _ (.tail _ mem) => nomatch mem
  | 0, _, _, .tail _ mem, _ => nomatch mem
  | _ + 1, _, _, _, mem => nomatch mem

theorem top : ∀ t p, p ∈ generations.family t → Drawdown.web.Supported t p →
    ∀ q, q ∈ generations.family t → generations.amount t q ≤ generations.amount t p
  | 0, _, .head _, _, _, .head _ => Nat.le_refl 1
  | 0, _, .head _, _, _, .tail _ mem => nomatch mem
  | 0, _, .tail _ mem, _, _, _ => nomatch mem
  | 1, _, .head _, supported, _, _ => absurd supported (Drawdown.same_unsupported 1 (Nat.le_refl 1))
  | 1, _, .tail _ (.head _), _, _, .head _ => Nat.le_succ 1
  | 1, _, .tail _ (.head _), _, _, .tail _ (.head _) => Nat.le_refl 2
  | 1, _, .tail _ (.head _), _, _, .tail _ (.tail _ mem) => nomatch mem
  | 1, _, .tail _ (.tail _ mem), _, _, _ => nomatch mem
  | n + 2, p, mem, _, _, _ => by
    have empty : p ∈ ([] : List Relatum) := family_late n ▸ mem
    cases empty

/-- The support laws' premises met on `Drawdown`'s flow: generations of descent, a reading
highest at each generation's supported members, nothing lowered across the giving step; the mean
does not fall (`Flow.support_not_lower`) and here rises, from one to three halves, by what
transmission raised at the descendant needing less. -/
theorem supported_descent :
    Flow.Descended Drawdown.flow Drawdown.web generations ∧ generations.loweredAt 0 = 0 ∧
      generations.size 1 * generations.sum 0 ≤ generations.size 0 * generations.sum 1 ∧
      generations.size 1 * generations.sum 0 < generations.size 0 * generations.sum 1 ∧
      generations.raisedAt 0 = 1 ∧ generations.concordAt 0 = 0 :=
  ⟨descended, rfl,
    Flow.support_not_lower Drawdown.acting Drawdown.dependent descended top (T := 1)
      fun t lt => (Nat.eq_zero_of_le_zero (Nat.le_of_lt_succ lt)).symm ▸
        (rfl : generations.loweredAt 0 = 0),
    by decide, rfl, rfl⟩

end SupportedDescent

end SelectionTerm

end Becoming
