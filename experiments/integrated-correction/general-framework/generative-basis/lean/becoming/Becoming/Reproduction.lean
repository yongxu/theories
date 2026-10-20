import Becoming.SelectionTerm
import Becoming.Dissipation

/-!
# Reproduction: what bounds offspring numbers, and selection on offspring number itself

`Becoming.SelectionTerm` states the selection term proper of Price's counting identity with
offspring numbers as weights, any natural numbers. It leaves open how offspring numbers are
bounded by what the flow gives, and the variance form of the response to selection. This
module states both and joins them.

* **Selection on offspring number itself, an arithmetic identity with no premise.** Read on
  the weights themselves, no pair is discordant (`discord_self`): of two numbers, one does not
  exceed the other. So the number of members times the total of the squared weights is the
  square of the total weight with the concordance of the weights with themselves, which totals
  the squared differences over pairs (`variation`, `concord_self`). Read over the rationals and
  divided by the square of the number of members, this is the mean square as the square of the
  mean with the variance. It is never below the square of the total, and equal exactly where
  the weights are uniform (`never_against`, `none_iff_uniform`). With offspring numbers as
  the weights (`number_variation`, `number_never_against`, `number_none_iff`): over offspring,
  the mean of their parent's offspring number is at least the mean offspring number over
  parents, and more exactly where offspring numbers vary. This is the selection term proper on
  offspring number itself: never negative, and none exactly where offspring numbers are uniform.
* **Over generations.** Read each member by its offspring number (`Generations.ByNumber`),
  a generation's total is the next generation's size (`ByNumber.sum_eq`), so the mean offspring
  number at a step is the ratio of the next size to this one, and no pair is ever discordant
  (`ByNumber.discord_none`). The step identity is then: the size times the size two steps on,
  with what transmission lowered so counted, is the square of the next size with the
  concordance and what transmission raised so counted (`ByNumber.step`). Where transmission
  lowers no offspring number the mean offspring number does not fall (`ByNumber.not_lower_step`);
  with exact transmission (each offspring leaving as many offspring as its parent) it rises
  exactly where offspring numbers vary and is kept exactly where they are uniform
  (`ByNumber.rises_exact_iff`, `ByNumber.kept_exact_iff`). This is the counting form of Fisher's
  fundamental theorem (Fisher 1930) in its case of exact transmission: the mean offspring number
  rises by the variance of offspring number over its mean. Where a
  mean fell over a stretch, a step of the stretch fell, found by deciding each step
  (`Generations.fell_step`), and a step falls exactly where what transmission lowered, with
  the discordant pairs, exceeds the concordance with what transmission raised
  (`Generations.falls_step_iff`).
* **The additive part: what any carried amount transmits is at most the whole.** Counted,
  Cauchy–Schwarz holds over any finite list (`bound_sq`). Over ordered pairs, how far apart the
  weights are times how far apart the amounts are totals twice the concordance with the
  discordance (`total_dist`), and on the weights themselves twice their squared differences, so
  the concordance with the discordance of offspring number with any carried amount, squared, is
  at most the squared differences of offspring numbers over pairs times those of the amount
  (`additive_le`; the covariance either way, `covariance_sq_le`). Divided through, the squared
  covariance is at most the product of the variances: the additive part of the variance in
  offspring number through the amount (Fisher's additive genetic variance, the squared covariance
  over the amount's variance, Price 1972) is at most the whole variance, and all of it where the
  amount is offspring number itself (`additive_self`, the exact case above). Over generations with
  exact transmission of the amount, the cross-multiplied rise or fall of its mean, squared, is at
  most that product (`Generations.response_sq_le`). The bound is attained only where offspring
  number goes with the amount pair by pair in one proportion; an amount can vary beside varying
  offspring numbers with no covariance at all (`Unrelated`).
* **What bounds offspring numbers.** A descendant is given to by its parent across the step
  (`Flow.DescendsAt`), at least one unit, so a parent's offspring number is at most what it
  gives them (`Flow.born_le_given`, over a family `Flow.born_le_given_family`). Where its
  offspring are distinct and stand within a family dissipated on across the step, the offspring
  number with one more where there is any is at most what the parent takes from the family
  (`Flow.number_within_take`): the weights of the selection term are amounts the flow fixes.
  Across a step at which a family is balanced and dissipated on, distinct offspring standing
  within it number, with the formations taking from it, at most its stock before the step
  (`Flow.born_within_stock`), and where any offspring stand within it some formation takes
  from it (`Flow.takers_pos_of_born`).
* **A lineage within a closed family ends.** Over generations of descent whose offspring stand
  within a family balanced and dissipated on across each step of a stretch, the steps at which
  the lineage reproduces number at most the family's stock at the start, with what stands at
  the end (`Flow.reproducing_within`). So over steps up to that stock, the generation after them
  is empty (`Flow.lineage_ends`).
* **Where they meet.** Selection on offspring number itself never lowers the mean offspring
  number, and a lineage within a family dissipated on ends. So read by offspring number, a
  lineage that began reproducing within such a family has a step, before the family's stock
  runs out, at which transmission lowered offspring number by more than selection on it and
  what transmission raised together (`Flow.closed_lineage_lowered`); offspring numbers are not
  transmitted exactly at every step up to the stock (`Flow.closed_not_exact`). What Fisher's
  theorem leaves to the transmission term (his "deterioration of the environment") is forced
  here by dissipation within a family nothing flows into.
* **Witnesses.** A parent with two offspring beside a parent with none: the mean over offspring
  of their parent's offspring number is two, over parents one (`Spread`). A parent takes three
  units from a pool and gives one to each of two offspring, which never reproduce: the pool and
  offspring are balanced and dissipated on, the lineage ends, and at the giving step
  transmission lowered offspring number by four (`OnePool`). Without dissipation a lineage
  within a family of stock one goes on at every step: two relata each give their one unit to
  the other in turn, losing nothing (`Relay`). Three members with offspring numbers one to three,
  the middle one alone carrying an amount: no covariance, while both vary (`Unrelated`).

Nothing is supposed about what the offspring are; descent is `Flow.DescendsAt` (the parent
takes part, gives to the offspring, and the offspring comes to stand). Modelling choices:
natural-number amounts, discrete steps and generations, finite families as lists. Every bound
on the base needs dissipation on a family holding the offspring: where something flows into
it from outside, the bounds read only the family's own stock and what flows in, and a lossless
exchange keeps a lineage going (`Relay`). No ethical predicate, ranking or axiom occurs; every
declaration has an empty axiom report.
-/

namespace Becoming

namespace Reproduction

open SelectionTerm

variable {α β : Type}

/-! ## Selection on offspring number itself -/

/-- Of two numbers, one does not exceed the other: the crossed excesses multiply to nothing. -/
theorem excess_cross (x y : Nat) : excess x y * excess y x = 0 :=
  match Nat.le_total x y with
  | .inl le => (congrArg (· * excess y x) (excess_of_le le)).trans (Nat.zero_mul _)
  | .inr le => (congrArg (excess x y * ·) (excess_of_le le)).trans (Nat.mul_zero _)

/-- What exceeds nothing is at most. -/
theorem le_of_excess_zero {a b : Nat} (zero : excess a b = 0) : a ≤ b :=
  match Nat.lt_or_ge b a with
  | .inl lt => absurd (excess_pos.mpr lt)
      fun pos => Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le pos (Nat.le_of_eq zero))
  | .inr ge => ge

/-- Read on the weights themselves, nothing is discordant. -/
theorem discord_self (ps : List α) (w : α → Nat) : discord ps w w = 0 :=
  pairs_zero fun p q _ _ => excess_cross (w p) (w q)

/-- Concordance of the weights with themselves totals, over ordered pairs, the square of how
much one exceeds the other: over unordered pairs, the squared differences. -/
theorem concord_self (ps : List α) (w : α → Nat) :
    concord ps w w = total ps fun p => total ps fun q => excess (w p) (w q) * excess (w p) (w q) :=
  rfl

/-- Variation: the number of members times the total of the squared weights is the square of
the total weight with the squared differences over pairs. Divided by the square of the number of
members, the mean square is the square of the mean with the variance. No premise. -/
theorem variation (ps : List α) (w : α → Nat) :
    ps.length * weighted ps w w = total ps w * total ps w + concord ps w w :=
  (Nat.add_zero _).symm.trans ((congrArg (_ + ·) (discord_self ps w).symm).trans (covariation ps w w))

/-- So the number of members times the total of the squared weights is never below the square
of the total weight. -/
theorem never_against (ps : List α) (w : α → Nat) :
    total ps w * total ps w ≤ ps.length * weighted ps w w :=
  Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq (variation ps w).symm)

/-- No squared difference over pairs exactly where the weights are uniform. -/
theorem concord_self_zero_iff (ps : List α) (w : α → Nat) :
    concord ps w w = 0 ↔ ∀ p q, p ∈ ps → q ∈ ps → w p = w q :=
  have excess_zero : concord ps w w = 0 → ∀ p q, p ∈ ps → q ∈ ps → excess (w p) (w q) = 0 :=
    fun zero p q mp mq => match h : excess (w p) (w q) with
      | 0 => rfl
      | e + 1 => absurd (Nat.le_trans
          (Nat.le_of_eq ((congrArg (fun x => x * x) h).symm))
          (Nat.le_trans
            (le_total_of_mem (q := fun q' => excess (w p) (w q') * excess (w p) (w q')) mq)
            (Nat.le_trans
              (le_total_of_mem (q := fun p' => total ps fun q' =>
                excess (w p') (w q') * excess (w p') (w q')) mp)
              (Nat.le_of_eq zero))))
          (Nat.not_le_of_gt (Nat.mul_pos (Nat.succ_pos e) (Nat.succ_pos e)))
  ⟨fun zero p q mp mq => Nat.le_antisymm (le_of_excess_zero (excess_zero zero p q mp mq))
      (le_of_excess_zero (excess_zero zero q p mq mp)),
    fun same => pairs_zero fun p q mp mq => by
      show excess (w p) (w q) * excess (w p) (w q) = 0
      rw [same p q mp mq, excess_same, Nat.zero_mul]⟩

/-- The number of members times the total of the squared weights is the square of the total
weight exactly where the weights are uniform. -/
theorem none_iff_uniform (ps : List α) (w : α → Nat) :
    total ps w * total ps w = ps.length * weighted ps w w ↔
      ∀ p q, p ∈ ps → q ∈ ps → w p = w q :=
  ⟨fun same => (concord_self_zero_iff ps w).mp (Naturals.add_left_cancel
      ((variation ps w).symm.trans (same.symm.trans (Nat.add_zero _).symm))),
    fun uniform => (Nat.add_zero _).symm.trans ((congrArg (_ + ·)
      ((concord_self_zero_iff ps w).mpr uniform).symm).trans (variation ps w).symm)⟩

/-- Selection on offspring number itself: the number of parents times their offspring numbers
weighted by their offspring numbers is the square of the number of offspring with the squared
differences of offspring numbers over pairs of parents. -/
theorem number_variation (ps : List α) (kids : α → List α) :
    ps.length * selected ps kids (fun p => (kids p).length) =
      born ps kids * born ps kids +
        concord ps (fun p => (kids p).length) (fun p => (kids p).length) :=
  variation ps fun p => (kids p).length

/-- So over offspring the mean of their parent's offspring number is at least the mean
offspring number over parents. -/
theorem number_never_against (ps : List α) (kids : α → List α) :
    born ps kids * born ps kids ≤ ps.length * selected ps kids (fun p => (kids p).length) :=
  never_against ps fun p => (kids p).length

/-- And equal exactly where offspring numbers are uniform. -/
theorem number_none_iff (ps : List α) (kids : α → List α) :
    born ps kids * born ps kids = ps.length * selected ps kids (fun p => (kids p).length) ↔
      ∀ p q, p ∈ ps → q ∈ ps → (kids p).length = (kids q).length :=
  none_iff_uniform ps fun p => (kids p).length

/-! ## The additive part -/

theorem twice_le_of_le {x y : Nat} (le : x ≤ y) : 2 * (x * y) ≤ x * x + y * y :=
  match le_dest le with
  | ⟨e, at_y⟩ => by
    rw [at_y]
    have same : x * x + (x + e) * (x + e) = 2 * (x * (x + e)) + e * e := by
      rw [add_mul_split x e (x + e), Nat.mul_add e x e, Nat.mul_comm e x, Nat.add_left_comm,
        ← Nat.add_assoc (x * x) (x * e) (e * e), ← Nat.mul_add x x e, ← Nat.add_assoc, Nat.two_mul]
    rw [same]
    exact Nat.le_add_right _ _

/-- Twice a product is at most the sum of the squares. -/
theorem twice_le (x y : Nat) : 2 * (x * y) ≤ x * x + y * y :=
  match Nat.le_total x y with
  | .inl le => twice_le_of_le le
  | .inr le => by
    rw [Nat.mul_comm x y, Nat.add_comm (x * x)]
    exact twice_le_of_le le

theorem square_mul (a b : Nat) : a * b * (a * b) = a * a * (b * b) :=
  (mul_assoc_nat a b (a * b)).trans ((congrArg (a * ·) (mul_turn b a b)).trans (mul_assoc_nat a a (b * b)).symm)

theorem cross_mul (a b c d : Nat) : a * b * (c * d) = a * d * (c * b) :=
  (mul_assoc_nat a b (c * d)).trans ((congrArg (a * ·) ((mul_assoc_nat b c d).symm.trans
    ((Nat.mul_comm (b * c) d).trans (congrArg (d * ·) (Nat.mul_comm b c))))).trans
      (mul_assoc_nat a d (c * b)).symm)

theorem twice_mul (a b : Nat) : (a + a) * (b + b) = 2 * 2 * (a * b) := by
  rw [← Nat.two_mul a, ← Nat.two_mul b, mul_assoc_nat, mul_turn a 2 b, ← mul_assoc_nat]

/-- **Cauchy–Schwarz, counted.** Over any finite list, the square of the total of products is at
most the product of the totals of the squares. No premise. -/
theorem bound_sq (L : List β) (x y : β → Nat) :
    total L (fun i => x i * y i) * total L (fun i => x i * y i) ≤
      total L (fun i => x i * x i) * total L (fun i => y i * y i) :=
  have point : ∀ i j, 2 * (x i * y i * (x j * y j)) ≤ x i * x i * (y j * y j) + x j * x j * (y i * y i) :=
    fun i j => Nat.le_trans (Nat.le_of_eq (congrArg (2 * ·) (cross_mul (x i) (y j) (x j) (y i)).symm))
      (Nat.le_trans (twice_le (x i * y j) (x j * y i))
        (Nat.le_of_eq (by rw [square_mul, square_mul])))
  have summed := total_le L fun i _ => total_le L fun j _ => point i j
  have left : (total L fun i => total L fun j => 2 * (x i * y i * (x j * y j))) =
      2 * (total L (fun i => x i * y i) * total L (fun i => x i * y i)) := by
    rw [total_congr (fun i => total_mul 2 (fun j => x i * y i * (x j * y j)) L), total_mul,
      pairs_cross L (fun i => x i * y i) (fun i => x i * y i)]
  have right : (total L fun i => total L fun j => x i * x i * (y j * y j) + x j * x j * (y i * y i)) =
      2 * (total L (fun i => x i * x i) * total L (fun i => y i * y i)) := by
    rw [pairs_add, pairs_cross L (fun i => x i * x i) (fun i => y i * y i),
      pairs_cross' L (fun i => x i * x i) (fun i => y i * y i), ← Nat.two_mul]
  le_of_mul_le_mul (Nat.succ_pos 1) (Nat.le_trans (Nat.le_of_eq left.symm)
    (Nat.le_trans summed (Nat.le_of_eq right)))

/-- The ordered pairs of a list. -/
def pairsOf (ps : List α) : List (α × α) := ps.flatMap fun p => ps.map fun q => (p, q)

theorem total_bind (f : α → List β) (q : β → Nat) :
    ∀ ps : List α, total (ps.flatMap f) q = total ps fun p => total (f p) q
  | [] => rfl
  | p :: ps => (total_append q (ps.flatMap f) (f p)).trans
      (congrArg (total (f p) q + ·) (total_bind f q ps))

theorem total_pairsOf (ps : List α) (F : α → α → Nat) :
    total (pairsOf ps) (fun pq => F pq.1 pq.2) = total ps fun p => total ps (F p) :=
  (total_bind _ _ ps).trans (total_congr (fun p => total_map (fun q => (p, q)) _ ps) ps)

/-- How far apart two numbers are. -/
def dist (x y : Nat) : Nat := excess x y + excess y x

theorem dist_mul (a b c d : Nat) : (a + b) * (c + d) = a * c + a * d + (b * c + b * d) :=
  (add_mul_split a b (c + d)).trans (Naturals.add_congr (Nat.left_distrib a c d) (Nat.left_distrib b c d))

/-- Over ordered pairs, how far apart the weights are times how far apart the amounts are totals
twice the concordance with the discordance. -/
theorem total_dist (ps : List α) (w a : α → Nat) :
    (total ps fun p => total ps fun q => dist (w p) (w q) * dist (a p) (a q)) =
      (concord ps w a + discord ps w a) + (concord ps w a + discord ps w a) := by
  unfold dist
  rw [total_congr (fun p => total_congr (fun q => dist_mul (excess (w p) (w q)) (excess (w q) (w p))
      (excess (a p) (a q)) (excess (a q) (a p))) ps) ps, pairs_add, pairs_add, pairs_add,
    discord_swap, concord_swap]
  show concord ps w a + discord ps w a + (discord ps w a + concord ps w a) = _
  rw [Nat.add_comm (discord ps w a) (concord ps w a)]

/-- **The additive part is at most the whole.** The concordance with the discordance of offspring
number (or any weight) with a carried amount, squared, is at most the squared differences of the
weights over pairs times those of the amount: divided through, the squared covariance is at most
the product of the variances, so the part of the variance in offspring number carried by the
amount (its additive part, the squared covariance over the amount's variance) is at most the
whole. No premise. -/
theorem additive_le (ps : List α) (w a : α → Nat) :
    (concord ps w a + discord ps w a) * (concord ps w a + discord ps w a) ≤
      concord ps w w * concord ps a a :=
  have cs := bound_sq (pairsOf ps) (fun pq => dist (w pq.1) (w pq.2)) (fun pq => dist (a pq.1) (a pq.2))
  have uv := (total_pairsOf ps fun p q => dist (w p) (w q) * dist (a p) (a q)).trans (total_dist ps w a)
  have uu := (total_pairsOf ps fun p q => dist (w p) (w q) * dist (w p) (w q)).trans
    ((total_dist ps w w).trans (by rw [discord_self, Nat.add_zero]))
  have vv := (total_pairsOf ps fun p q => dist (a p) (a q) * dist (a p) (a q)).trans
    ((total_dist ps a a).trans (by rw [discord_self, Nat.add_zero]))
  le_of_mul_le_mul (Nat.mul_pos (Nat.succ_pos 1) (Nat.succ_pos 1)) (by
    rw [← twice_mul, ← twice_mul, ← uv, ← uu, ← vv]
    exact cs)

/-- So the covariance squared, whichever way it goes, is at most the product of the squared
differences: concordance less discordance, and discordance less concordance. -/
theorem covariance_sq_le (ps : List α) (w a : α → Nat) :
    (concord ps w a - discord ps w a) * (concord ps w a - discord ps w a) ≤
        concord ps w w * concord ps a a ∧
      (discord ps w a - concord ps w a) * (discord ps w a - concord ps w a) ≤
        concord ps w w * concord ps a a :=
  have up : concord ps w a - discord ps w a ≤ concord ps w a + discord ps w a :=
    Nat.le_trans (Nat.sub_le _ _) (Nat.le_add_right _ _)
  have down : discord ps w a - concord ps w a ≤ concord ps w a + discord ps w a :=
    Nat.le_trans (Nat.sub_le _ _) (Nat.le_add_left _ _)
  ⟨Nat.le_trans (Nat.mul_le_mul up up) (additive_le ps w a),
    Nat.le_trans (Nat.mul_le_mul down down) (additive_le ps w a)⟩

/-- **All of it is additive where the amount is the weight itself:** read on offspring number, the
bound is attained (Fisher's exact case, `variation`). -/
theorem additive_self (ps : List α) (w : α → Nat) :
    (concord ps w w + discord ps w w) * (concord ps w w + discord ps w w) = concord ps w w * concord ps w w := by
  rw [discord_self, Nat.add_zero]

theorem sub_le_of_le_add : ∀ {x y c : Nat}, x ≤ y + c → x - y ≤ c
  | _, 0, _, le => Nat.le_trans le (Nat.le_of_eq (Nat.zero_add _))
  | 0, _ + 1, _, _ => Nat.le_trans (Nat.le_of_eq (Nat.zero_sub _)) (Nat.zero_le _)
  | x + 1, y + 1, _, le => (Nat.succ_sub_succ x y).symm ▸
      sub_le_of_le_add (Nat.le_of_succ_le_succ (Nat.le_trans le (Nat.le_of_eq (Nat.succ_add y _))))

/-! ## Over generations -/

/-- A bounded search: a decidable property that does not fail at every number below `T` holds
at one, found by deciding each. -/
theorem search {P : Nat → Prop} (dec : ∀ t, Decidable (P t)) :
    ∀ T, ¬ (∀ t, t < T → ¬ P t) → ∃ t, t < T ∧ P t
  | 0, not_all => absurd (fun t lt => absurd lt (Nat.not_lt_zero t)) not_all
  | T + 1, not_all => match dec T with
    | .isTrue holds => ⟨T, Nat.lt_succ_self T, holds⟩
    | .isFalse fails =>
      match search dec T (fun all => not_all fun t lt holds =>
          match Nat.lt_or_ge t T with
          | .inl below => all t below holds
          | .inr above => fails (Eq.subst (motive := P)
              (Nat.le_antisymm (Nat.le_of_lt_succ lt) above) holds)) with
      | ⟨t, lt, holds⟩ => ⟨t, Nat.lt_succ_of_lt lt, holds⟩

namespace Generations

variable (G : Generations α)

/-- Each member is read by its offspring number at each step. -/
def ByNumber : Prop := ∀ t p, G.amount t p = G.offspringNumber t p

variable {G}

/-- A step falls exactly where what transmission lowered, with the discordant pairs, exceeds the
concordance with what transmission raised. -/
theorem falls_step_iff (t : Nat) :
    G.size t * G.sum (t + 1) < G.size (t + 1) * G.sum t ↔
      G.concordAt t + G.size t * G.raisedAt t < G.size t * G.loweredAt t + G.discordAt t :=
  lt_iff_of_balance (G.mean_step t).symm

/-- Where a mean fell over a stretch, a step of the stretch fell, found by deciding each. -/
theorem fell_step {T : Nat} (fell : G.size 0 * G.sum T < G.size T * G.sum 0) :
    ∃ t, t < T ∧ G.size t * G.sum (t + 1) < G.size (t + 1) * G.sum t :=
  search (fun _ => Nat.decLt _ _) T fun none => Nat.lt_irrefl _
    (Nat.lt_of_lt_of_le fell (G.not_lower T fun t lt => Nat.ge_of_not_lt (none t lt)))

/-- An empty generation leaves every later one empty. -/
theorem empty_from {t : Nat} (empty : G.size t = 0) : ∀ n, G.size (t + n) = 0
  | 0 => empty
  | n + 1 => (G.empty_after (empty_from empty n)).1

/-- **The response is at most what the spreads allow.** With exact transmission at a step, the
size times the next total exceeds the next size times the total (the mean's rise, cross-multiplied)
by at most the concordance, and falls short of it by at most the discordance; either, squared, is at
most the squared differences of offspring numbers over pairs times those of the amount. -/
theorem response_sq_le {t : Nat}
    (exact : SelectionTerm.Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1))) :
    (G.size t * G.sum (t + 1) - G.size (t + 1) * G.sum t) *
          (G.size t * G.sum (t + 1) - G.size (t + 1) * G.sum t) ≤
        concord (G.family t) (G.offspringNumber t) (G.offspringNumber t) *
          concord (G.family t) (G.amount t) (G.amount t) ∧
      (G.size (t + 1) * G.sum t - G.size t * G.sum (t + 1)) *
          (G.size (t + 1) * G.sum t - G.size t * G.sum (t + 1)) ≤
        concord (G.family t) (G.offspringNumber t) (G.offspringNumber t) *
          concord (G.family t) (G.amount t) (G.amount t) := by
  have step := G.mean_step t
  unfold SelectionTerm.Generations.raisedAt SelectionTerm.Generations.loweredAt at step
  rw [raised_exact exact, lowered_exact exact, Nat.mul_zero, Nat.zero_add, Nat.add_zero] at step
  have up : G.size t * G.sum (t + 1) - G.size (t + 1) * G.sum t ≤
      G.concordAt t + G.discordAt t :=
    Nat.le_trans (sub_le_of_le_add (Nat.le_trans (Nat.le_add_right _ (G.discordAt t)) (Nat.le_of_eq step)))
      (Nat.le_add_right _ _)
  have down : G.size (t + 1) * G.sum t - G.size t * G.sum (t + 1) ≤
      G.concordAt t + G.discordAt t :=
    Nat.le_trans (sub_le_of_le_add (Nat.le_trans (Nat.le_add_right _ (G.concordAt t))
      (Nat.le_of_eq (step.symm.trans (Nat.add_comm _ _) |>.trans (Nat.add_comm _ _)))))
      (Nat.le_add_left _ _)
  exact ⟨Nat.le_trans (Nat.mul_le_mul up up) (additive_le _ _ _),
    Nat.le_trans (Nat.mul_le_mul down down) (additive_le _ _ _)⟩

namespace ByNumber

variable (number : Generations.ByNumber G)
include number

/-- Read by offspring number, a generation's total is the next generation's size. -/
theorem sum_eq (t : Nat) : G.sum t = G.size (t + 1) :=
  (total_congr (fun p => number t p) (G.family t)).trans (G.born_eq t)

/-- Read by offspring number, no pair is discordant. -/
theorem discord_none (t : Nat) : G.discordAt t = 0 :=
  pairs_zero fun p q _ _ => by
    show excess (G.offspringNumber t p) (G.offspringNumber t q) *
      excess (G.amount t q) (G.amount t p) = 0
    rw [number t q, number t p]
    exact excess_cross _ _

/-- Read by offspring number, the concordance is that of offspring numbers with themselves. -/
theorem concord_eq (t : Nat) :
    G.concordAt t = concord (G.family t) (G.offspringNumber t) (G.offspringNumber t) :=
  total_congr (fun p => total_congr (fun q => by
    show excess (G.offspringNumber t p) (G.offspringNumber t q) *
        excess (G.amount t p) (G.amount t q) =
      excess (G.offspringNumber t p) (G.offspringNumber t q) *
        excess (G.offspringNumber t p) (G.offspringNumber t q)
    rw [number t p, number t q]) _) _

/-- The step identity read by offspring number: the size times the size two steps on, with
what transmission lowered so counted, is the square of the next size with the concordance and
what transmission raised so counted. -/
theorem step (t : Nat) :
    G.size t * G.size (t + 1 + 1) + G.size t * G.loweredAt t =
      G.size (t + 1) * G.size (t + 1) + (G.concordAt t + G.size t * G.raisedAt t) := by
  have h := G.mean_step t
  rw [sum_eq number (t + 1), sum_eq number t, discord_none number t, Nat.add_zero] at h
  exact h

/-- Where transmission lowers no offspring number across a step, the mean offspring number does
not fall across it. -/
theorem not_lower_step {t : Nat} (unlowered : G.loweredAt t = 0) :
    G.size (t + 1) * G.size (t + 1) ≤ G.size t * G.size (t + 1 + 1) := by
  have h := step number t
  rw [unlowered, Nat.mul_zero, Nat.add_zero] at h
  exact Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq h.symm)

/-- With exact transmission across a step, the mean offspring number rises exactly where some
pair of offspring numbers differs. -/
theorem rises_exact_iff {t : Nat}
    (exact : Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1))) :
    G.size (t + 1) * G.size (t + 1) < G.size t * G.size (t + 1 + 1) ↔ 0 < G.concordAt t := by
  have h := (G.rises_step_iff t).trans (G.raises_exact_iff exact)
  rw [sum_eq number t, sum_eq number (t + 1), discord_none number t] at h
  exact h

/-- With exact transmission across a step, the mean offspring number is kept exactly where
offspring numbers are uniform. -/
theorem kept_exact_iff {t : Nat}
    (exact : Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1))) :
    G.size (t + 1) * G.size (t + 1) = G.size t * G.size (t + 1 + 1) ↔
      ∀ p q, p ∈ G.family t → q ∈ G.family t → G.offspringNumber t p = G.offspringNumber t q := by
  have h := (G.kept_step_iff t).trans (G.balanced_exact_iff exact)
  rw [sum_eq number t, sum_eq number (t + 1), discord_none number t, concord_eq number t] at h
  exact h.trans ⟨fun zero => (concord_self_zero_iff _ _).mp zero.symm,
    fun uniform => ((concord_self_zero_iff _ _).mpr uniform).symm⟩

end ByNumber

end Generations

/-! ## What bounds offspring numbers -/

theorem mem_append_cases {a : α} : ∀ {l m : List α}, a ∈ l ++ m → a ∈ l ∨ a ∈ m
  | [], _, mem => .inr mem
  | b :: l, m, mem => match mem_cons_cases (q := l ++ m) mem with
    | .inl same => .inl (Eq.subst (motive := fun x => x ∈ b :: l) same.symm (.head l))
    | .inr rest => match mem_append_cases rest with
      | .inl here => .inl (.tail b here)
      | .inr there => .inr there

theorem mem_flatMap_cases {f : α → List β} {k : β} :
    ∀ {ps : List α}, k ∈ ps.flatMap f → ∃ p, p ∈ ps ∧ k ∈ f p
  | [], mem => nomatch mem
  | p :: ps, mem => match mem_append_cases (l := f p) (m := ps.flatMap f) mem with
    | .inl here => ⟨p, .head ps, here⟩
    | .inr there => match mem_flatMap_cases there with
      | ⟨q, mq, mk⟩ => ⟨q, .tail p mq, mk⟩

theorem exists_mem_of_length_pos : ∀ {l : List α}, 0 < l.length → ∃ a, a ∈ l
  | [], pos => absurd pos (Nat.lt_irrefl 0)
  | a :: _, _ => ⟨a, .head _⟩

/-- The number of offspring is the length of the next family. -/
theorem born_flatMap (ps : List α) (kids : α → List α) : born ps kids = (ps.flatMap kids).length :=
  (total_congr (fun p => (total_ones (kids p)).symm) ps).trans
    ((Generations.total_flatMap kids (fun _ => 1) ps).symm.trans (total_ones _))

namespace Flow

variable {X : Type} {L : Flow X X} {W : Web X X}

/-- A parent's offspring number is at most what it gives them: each descendant is given at least
one unit across the step. -/
theorem born_le_given {t : Nat} {p : X} {ks : List X}
    (descend : ∀ k, k ∈ ks → L.DescendsAt W t k p) : ks.length ≤ total ks (L.give t p) :=
  Nat.le_trans (Nat.le_of_eq (total_ones ks).symm) (total_le ks fun k mk => (descend k mk).2.1)

/-- So over a family of parents, the number of offspring is at most what the parents give them. -/
theorem born_le_given_family {t : Nat} {ps : List X} {kids : X → List X}
    (descend : ∀ p k, p ∈ ps → k ∈ kids p → L.DescendsAt W t k p) :
    born ps kids ≤ total ps fun p => total (kids p) (L.give t p) :=
  total_le ps fun p mp => born_le_given fun k mk => descend p k mp mk

/-- The weights are amounts the flow fixes: where a parent's offspring are distinct and stand
within a family dissipated on across the step, its offspring number, with one more where there
is any, is at most what it takes from the family. -/
theorem number_within_take {ds : List X} {t : Nat} (dissipates : L.DissipatesOn ds t) {p : X}
    {ks : List X} (descend : ∀ k, k ∈ ks → L.DescendsAt W t k p)
    (within : ∀ k, k ∈ ks → k ∈ ds) (distinct : Distinct ks) :
    ks.length + sign ks.length ≤ total ds (L.take t p) :=
  match Nat.decEq ks.length 0 with
  | .isTrue zero => Nat.le_trans
      (Nat.le_of_eq ((congrArg (fun n => n + sign n) zero).trans rfl)) (Nat.zero_le _)
  | .isFalse nonzero => match exists_mem_of_length_pos (Nat.pos_of_ne_zero nonzero) with
    | ⟨k, mk⟩ =>
      have present : p ∈ L.present t := (descend k mk).1
      have gives : 0 < total ds (L.give t p) :=
        total_pos_of_mem (q := L.give t p) (within k mk) (descend k mk).2.1
      have given : ks.length ≤ total ds (L.give t p) :=
        Nat.le_trans (born_le_given descend)
          (total_le_of_support distinct fun j mj _ => within j mj)
      Nat.le_trans
        (Nat.add_le_add given (Nat.le_trans (sign_le_one _)
          (sign_pos (dissipates.takes_of_gives present gives))))
        (dissipates p present)

/-- Across a step at which a family is balanced and dissipated on, distinct offspring standing
within it number, with the formations taking from it, at most its stock before the step. -/
theorem born_within_stock {ds : List X} {t : Nat} (balances : L.BalancesOn W ds t)
    (dissipates : L.DissipatesOn ds t) {ps : List X} {kids : X → List X}
    (descend : ∀ p k, p ∈ ps → k ∈ kids p → L.DescendsAt W t k p)
    (within : ∀ p k, p ∈ ps → k ∈ kids p → k ∈ ds) (distinct : Distinct (ps.flatMap kids)) :
    born ps kids + L.takers ds t ≤ W.stock ds t :=
  have standing : born ps kids ≤ W.stock ds (t + 1) :=
    Nat.le_trans (Nat.le_of_eq ((born_flatMap ps kids).trans (total_ones _).symm))
      (Nat.le_trans
        (total_le _ fun k mk => match mem_flatMap_cases mk with
          | ⟨p, mp, mkp⟩ => (descend p k mp mkp).2.2.2)
        (total_le_of_support distinct fun k mk _ => match mem_flatMap_cases mk with
          | ⟨p, mp, mkp⟩ => within p k mp mkp))
  Nat.le_trans (Nat.add_le_add_right standing _) (balances.runs_down dissipates)

/-- Where offspring stand within a family dissipated on across the step, some formation takes
from it. -/
theorem takers_pos_of_born {ds : List X} {t : Nat} (dissipates : L.DissipatesOn ds t)
    {ps : List X} {kids : X → List X}
    (descend : ∀ p k, p ∈ ps → k ∈ kids p → L.DescendsAt W t k p)
    (within : ∀ p k, p ∈ ps → k ∈ kids p → k ∈ ds) (born_pos : 0 < born ps kids) :
    0 < L.takers ds t :=
  match exists_mem_of_length_pos (Nat.lt_of_lt_of_le born_pos (Nat.le_of_eq (born_flatMap ps kids))) with
  | ⟨k, mk⟩ => match mem_flatMap_cases mk with
    | ⟨p, mp, mkp⟩ =>
      have present : p ∈ L.present t := (descend p k mp mkp).1
      have gives : 0 < total ds (L.give t p) :=
        total_pos_of_mem (q := L.give t p) (within p k mp mkp) (descend p k mp mkp).2.1
      total_pos_of_mem (q := fun f => sign (total ds (L.take t f))) present
        (sign_pos (dissipates.takes_of_gives present gives))

/-! ## A lineage within a closed family ends -/

variable {G : Generations X}

/-- A step at which the lineage reproduces into a family dissipated on has a formation taking
from it. -/
theorem reproducing_le_takers {ds : List X} (descended : SelectionTerm.Flow.Descended L W G)
    (within : ∀ t p k, p ∈ G.family t → k ∈ G.kids t p → k ∈ ds) {t : Nat}
    (dissipates : L.DissipatesOn ds t) : sign (G.size (t + 1)) ≤ L.takers ds t :=
  match h : G.size (t + 1) with
  | 0 => Nat.le_trans (sign_le 0) (Nat.zero_le _)
  | n + 1 => Nat.le_trans (sign_le_one _)
      (takers_pos_of_born dissipates (descended t) (within t)
        (Nat.lt_of_lt_of_le (Nat.succ_pos n) (Nat.le_of_eq (h.symm.trans (G.born_eq t).symm))))

/-- Over generations of descent whose offspring stand within a family balanced and dissipated on
across each step of a stretch, the steps at which the lineage reproduces number at most the
family's stock at the start, with what stands at the end. -/
theorem reproducing_within {ds : List X} (descended : SelectionTerm.Flow.Descended L W G)
    (within : ∀ t p k, p ∈ G.family t → k ∈ G.kids t p → k ∈ ds) (T : Nat)
    (balances : ∀ t, t < T → L.BalancesOn W ds t) (dissipates : ∀ t, t < T → L.DissipatesOn ds t) :
    W.stock ds T + total (steps 0 T) (fun t => sign (G.size (t + 1))) ≤ W.stock ds 0 := by
  have h := Becoming.Flow.takers_within_on (L := L) (W := W) (cs := ds) 0 T
    (fun t _ lt => balances t (Eq.subst (motive := fun x => t < x) (Nat.zero_add T) lt))
    (fun t _ lt => dissipates t (Eq.subst (motive := fun x => t < x) (Nat.zero_add T) lt))
  rw [Nat.zero_add] at h
  exact Nat.le_trans (Nat.add_le_add_left (total_le (steps 0 T) fun t mt =>
      reproducing_le_takers descended within (dissipates t
        (Eq.subst (motive := fun x => t < x) (Nat.zero_add T) (between_of_mem_steps mt).2))) _) h

/-- A lineage within a closed family ends: where the family is balanced and dissipated on across
each step up to its stock at the start, the generation after them is empty. -/
theorem lineage_ends {ds : List X} (descended : SelectionTerm.Flow.Descended L W G)
    (within : ∀ t p k, p ∈ G.family t → k ∈ G.kids t p → k ∈ ds)
    (balances : ∀ t, t < W.stock ds 0 + 1 → L.BalancesOn W ds t)
    (dissipates : ∀ t, t < W.stock ds 0 + 1 → L.DissipatesOn ds t) :
    G.size (W.stock ds 0 + 1) = 0 :=
  match Nat.decEq (G.size (W.stock ds 0 + 1)) 0 with
  | .isTrue zero => zero
  | .isFalse going =>
    have every : ∀ t, t ∈ steps 0 (W.stock ds 0 + 1) → 1 ≤ sign (G.size (t + 1)) :=
      fun t mt => match h : G.size (t + 1) with
        | 0 => absurd (match le_dest (Nat.succ_le_of_lt (Eq.subst (motive := fun x => t < x)
              (Nat.zero_add _) (between_of_mem_steps mt).2)) with
            | ⟨d, eq⟩ => Eq.subst (motive := fun x => G.size x = 0) eq.symm
                (Generations.empty_from h d)) going
        | _ + 1 => Nat.le_refl 1
    absurd (Nat.le_trans (Nat.le_trans (Nat.le_of_eq (Nat.one_mul _).symm)
        (Nat.le_trans (steps_ge (q := fun _ => 1) 0 _ fun _ _ => Nat.le_refl 1)
          (total_le _ every)))
        (Nat.le_trans (Nat.le_add_left _ _)
          (reproducing_within descended within _ balances dissipates)))
      (Nat.not_succ_le_self _)

/-- A lineage that began reproducing, with a generation emptied at step `S + 1`, has a last
reproducing generation before it. -/
theorem last_reproducing {S : Nat} (first : 0 < G.size 0) (emptied : G.size (S + 1) = 0) :
    ∃ m, m < S + 1 ∧ 0 < G.size m ∧ G.size (m + 1) = 0 :=
  search (fun m => instDecidableAnd (dp := Nat.decLt 0 (G.size m)) (dq := Nat.decEq _ 0)) (S + 1)
    fun none =>
      have standing : ∀ m, m ≤ S + 1 → 0 < G.size m := fun m =>
        Nat.rec (motive := fun m => m ≤ S + 1 → 0 < G.size m) (fun _ => first)
          (fun m ih le => Nat.pos_of_ne_zero fun zero =>
            none m le ⟨ih (Nat.le_of_succ_le le), zero⟩) m
      Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le (standing (S + 1) (Nat.le_refl _))
        (Nat.le_of_eq emptied))

/-- Where they meet: read by offspring number, a lineage that began reproducing within a family
balanced and dissipated on across each step up to its stock has a step, before the stock runs
out, at which transmission lowered offspring number by more than selection on it and what
transmission raised together. -/
theorem closed_lineage_lowered {ds : List X} (descended : SelectionTerm.Flow.Descended L W G)
    (within : ∀ t p k, p ∈ G.family t → k ∈ G.kids t p → k ∈ ds)
    (balances : ∀ t, t < W.stock ds 0 + 1 → L.BalancesOn W ds t)
    (dissipates : ∀ t, t < W.stock ds 0 + 1 → L.DissipatesOn ds t)
    (number : Generations.ByNumber G) (reproducing : 0 < G.size 1) :
    ∃ t, t < W.stock ds 0 ∧ G.concordAt t + G.size t * G.raisedAt t < G.size t * G.loweredAt t :=
  have first : 0 < G.size 0 := Nat.pos_of_ne_zero fun zero =>
    Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le reproducing (Nat.le_of_eq (G.empty_after zero).1))
  match last_reproducing first (lineage_ends descended within balances dissipates) with
  | ⟨m, below, standing, emptied⟩ =>
    have fell : G.size 0 * G.sum m < G.size m * G.sum 0 := by
      rw [Generations.ByNumber.sum_eq number m, emptied, Nat.mul_zero,
        Generations.ByNumber.sum_eq number 0]
      exact Nat.mul_pos standing reproducing
    match Generations.fell_step fell with
    | ⟨t, lt, falls⟩ =>
      have lowered := (Generations.falls_step_iff t).mp falls
      ⟨t, Nat.lt_of_lt_of_le lt (Nat.le_of_lt_succ below), by
        rw [Generations.ByNumber.discord_none number t, Nat.add_zero] at lowered
        exact lowered⟩

/-- So within such a family offspring numbers are not transmitted exactly at every step up to
its stock. -/
theorem closed_not_exact {ds : List X} (descended : SelectionTerm.Flow.Descended L W G)
    (within : ∀ t p k, p ∈ G.family t → k ∈ G.kids t p → k ∈ ds)
    (balances : ∀ t, t < W.stock ds 0 + 1 → L.BalancesOn W ds t)
    (dissipates : ∀ t, t < W.stock ds 0 + 1 → L.DissipatesOn ds t)
    (number : Generations.ByNumber G) (reproducing : 0 < G.size 1) :
    ¬ ∀ t, t < W.stock ds 0 → Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)) :=
  fun exact => match closed_lineage_lowered descended within balances dissipates number
      reproducing with
    | ⟨t, lt, lowered⟩ => by
      have none : G.loweredAt t = 0 := lowered_exact (exact t lt)
      rw [none, Nat.mul_zero] at lowered
      exact Nat.not_lt_zero _ lowered

end Flow

/-! ## Witnesses -/

namespace Spread

/-- A parent with two offspring beside a parent with none (`SelectionTerm.Rising`). -/
def parents : List Bool := Rising.generations.family 0

def kids : Bool → List Bool := Rising.generations.kids 0

/-- Two offspring of two parents; over offspring their parent's offspring number totals four, so
its mean is two against a mean of one over parents; the squared difference over pairs is four. -/
theorem spread :
    born parents kids = 2 ∧ selected parents kids (fun p => (kids p).length) = 4 ∧
      concord parents (fun p => (kids p).length) (fun p => (kids p).length) = 4 ∧
      born parents kids * born parents kids <
        parents.length * selected parents kids (fun p => (kids p).length) :=
  ⟨rfl, rfl, rfl, by decide⟩

end Spread

namespace OnePool

/-- A pool, a parent, and two offspring. -/
inductive Relatum where
  | pool
  | parent
  | left
  | right

open Relatum

def level : Nat → Relatum → Nat
  | 0, pool => 3
  | _ + 1, pool => 0
  | _, parent => 1
  | 0, left => 0
  | _ + 1, left => 1
  | 0, right => 0
  | _ + 1, right => 1

def web : Web Relatum Relatum where
  level := level
  active _ _ := True
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- What the parent takes at the first step: three units from the pool. -/
def takeFirst : Relatum → Relatum → Nat
  | parent, pool => 3
  | parent, parent => 0
  | parent, left => 0
  | parent, right => 0
  | pool, _ => 0
  | left, _ => 0
  | right, _ => 0

/-- What the parent gives at the first step: one unit to each offspring. -/
def giveFirst : Relatum → Relatum → Nat
  | parent, left => 1
  | parent, right => 1
  | parent, pool => 0
  | parent, parent => 0
  | pool, _ => 0
  | left, _ => 0
  | right, _ => 0

def take : Nat → Relatum → Relatum → Nat
  | 0 => takeFirst
  | _ + 1 => fun _ _ => 0

def give : Nat → Relatum → Relatum → Nat
  | 0 => giveFirst
  | _ + 1 => fun _ _ => 0

def present : Nat → List Relatum
  | 0 => [parent]
  | _ + 1 => []

/-- The parent takes three units from the pool at the first step and gives one to each
offspring; nothing takes part after. -/
def flow : Flow Relatum Relatum where
  present := present
  take := take
  give := give

/-- The pool and the two offspring. -/
def family : List Relatum := [pool, left, right]

theorem balances : flow.Balances web
  | 0, pool => rfl
  | 0, parent => rfl
  | 0, left => rfl
  | 0, right => rfl
  | _ + 1, pool => rfl
  | _ + 1, parent => rfl
  | _ + 1, left => rfl
  | _ + 1, right => rfl

theorem dissipates : ∀ t, flow.DissipatesOn family t
  | 0, _, .head _ => Nat.le_refl 3
  | 0, _, .tail _ mem => nomatch mem
  | _ + 1, _, mem => nomatch mem

/-- The parent's two offspring. -/
def firstKids : Relatum → List Relatum
  | parent => [left, right]
  | pool => []
  | left => []
  | right => []

def kids : Nat → Relatum → List Relatum
  | 0 => firstKids
  | _ + 1 => fun _ => []

/-- The parent, its two offspring, then none; each read by its offspring number. -/
def generations : Generations Relatum where
  first := [parent]
  kids := kids
  amount t p := (kids t p).length

theorem descended : SelectionTerm.Flow.Descended flow web generations
  | 0, _, _, .head _, .head _ => ⟨.head _, Nat.succ_pos 0, Nat.lt_irrefl 0, Nat.succ_pos 0⟩
  | 0, _, _, .head _, .tail _ (.head _) => ⟨.head _, Nat.succ_pos 0, Nat.lt_irrefl 0, Nat.succ_pos 0⟩
  | 0, _, _, .head _, .tail _ (.tail _ mem) => nomatch mem
  | 0, _, _, .tail _ mem, _ => nomatch mem
  | 1, _, _, .head _, mem => nomatch mem
  | 1, _, _, .tail _ (.head _), mem => nomatch mem
  | 1, _, _, .tail _ (.tail _ mem), _ => nomatch mem
  | n + 2, p, k, mem, kid => by
    have empty : generations.family (n + 2) = [] := family_late n
    exact absurd (Eq.subst (motive := fun l => p ∈ l) empty mem) (fun no => nomatch no)
where
  family_late : ∀ n, generations.family (n + 2) = []
    | 0 => rfl
    | n + 1 => by
      show (generations.family (n + 2)).flatMap (generations.kids (n + 2)) = []
      rw [family_late n]
      rfl

theorem within : ∀ t p k, p ∈ generations.family t → k ∈ generations.kids t p → k ∈ family
  | 0, _, _, .head _, .head _ => .tail _ (.head _)
  | 0, _, _, .head _, .tail _ (.head _) => .tail _ (.tail _ (.head _))
  | 0, _, _, .head _, .tail _ (.tail _ mem) => nomatch mem
  | 0, _, _, .tail _ mem, _ => nomatch mem
  | _ + 1, .pool, _, _, mem => nomatch mem
  | _ + 1, .parent, _, _, mem => nomatch mem
  | _ + 1, .left, _, _, mem => nomatch mem
  | _ + 1, .right, _, _, mem => nomatch mem

/-- The premises of the laws met: the pool and offspring balanced and dissipated on, the lineage
within them, read by offspring number, reproducing. The stock is three, the lineage ends, and at
the giving step transmission lowered offspring number by four. -/
theorem one_pool :
    web.stock family 0 = 3 ∧ generations.size 1 = 2 ∧ generations.size 4 = 0 ∧
      generations.loweredAt 0 = 4 ∧ generations.concordAt 0 = 0 ∧ generations.raisedAt 0 = 0 ∧
      (∃ t, t < web.stock family 0 ∧ generations.concordAt t +
        generations.size t * generations.raisedAt t < generations.size t * generations.loweredAt t) :=
  ⟨rfl, rfl,
    Flow.lineage_ends descended within (fun t _ => balances.on family t) (fun t _ => dissipates t),
    rfl, rfl, rfl,
    Flow.closed_lineage_lowered descended within (fun t _ => balances.on family t)
      (fun t _ => dissipates t) (fun _ _ => rfl) (Nat.succ_pos 1)⟩

end OnePool

namespace Relay

/-- Which of two relata stands at each step: the first at even steps, the second at odd. -/
def turn : Nat → Bool
  | 0 => true
  | n + 1 => !turn n

/-- One unit at the relatum whose turn it is. -/
def on : Bool → Bool → Nat
  | true, true => 1
  | true, false => 0
  | false, true => 0
  | false, false => 1

def web : Web Bool Bool where
  level t x := on (turn t) x
  active _ _ := True
  requires _ _ _ := False
  need _ _ _ := 0
  draws _ _ _ := False

/-- The relatum whose turn it is takes its one unit from itself and gives one to the other,
losing nothing. -/
def flow : Flow Bool Bool where
  present t := [turn t]
  take t f c := on (turn t) f * on (turn t) c
  give t f c := on (turn t) f * on (!turn t) c

def family : List Bool := [true, false]

theorem exchange : ∀ e c : Bool,
    on (!e) c + (on e e * on e c + 0) = on e c + (on e e * on (!e) c + 0) := by decide

theorem balances : flow.Balances web := fun t c => exchange (turn t) c

theorem not_dissipates (t : Nat) : ¬ flow.DissipatesOn family t :=
  fun dissipates => absurd (dissipates (turn t) (.head _)) (by
    show ¬ (on (turn t) (turn t) * on (!turn t) true + (on (turn t) (turn t) * on (!turn t) false + 0)
        + sign (on (turn t) (turn t) * on (turn t) true + (on (turn t) (turn t) * on (turn t) false + 0))
        ≤ on (turn t) (turn t) * on (turn t) true + (on (turn t) (turn t) * on (turn t) false + 0))
    cases turn t <;> decide)

/-- Each generation is the relatum whose turn it is; its offspring is the other. -/
def generations : Generations Bool where
  first := [true]
  kids _ p := [!p]
  amount _ _ := 1

theorem family_eq : ∀ t, generations.family t = [turn t]
  | 0 => rfl
  | t + 1 => by
    show (generations.family t).flatMap (generations.kids t) = [turn (t + 1)]
    rw [family_eq t]
    rfl

theorem descends (t : Nat) : flow.DescendsAt web t (!turn t) (turn t) :=
  ⟨.head _, by show 0 < on (turn t) (turn t) * on (!turn t) (!turn t); cases turn t <;> decide,
    by show ¬ 0 < on (turn t) (!turn t); cases turn t <;> decide,
    by show 0 < on (!turn t) (!turn t); cases turn t <;> decide⟩

theorem descended : SelectionTerm.Flow.Descended flow web generations := fun t p k mp mk =>
  match mem_cons_cases (Eq.subst (motive := fun l => p ∈ l) (family_eq t) mp),
      mem_cons_cases mk with
  | .inl hp, .inl hk => by subst hk; subst hp; exact descends t
  | _, .inr mem => nomatch mem
  | .inr mem, _ => nomatch mem

/-- Without dissipation, a lineage within a family of stock one goes on at every step: the flow
balances, the family is not dissipated on at any step, and every generation has one member. -/
theorem relay : flow.Balances web ∧ (∀ t, ¬ flow.DissipatesOn family t) ∧
    SelectionTerm.Flow.Descended flow web generations ∧ ∀ n, generations.size n = 1 ∧ web.stock family n = 1 :=
  ⟨balances, not_dissipates, descended, fun n => ⟨congrArg List.length (family_eq n), by
    show on (turn n) true + (on (turn n) false + 0) = 1
    cases turn n <;> rfl⟩⟩

end Relay

namespace Unrelated

/-- Three members with offspring numbers one, two and three, the middle one alone carrying an
amount: concordance and discordance are one each, so the covariance is nothing while offspring
number varies (six) and so does the amount (two): none of the variance in offspring number is
carried by the amount, against the bound's twelve. -/
def amount : Nat → Nat
  | 1 => 1
  | _ => 0

theorem unrelated :
    concord [0, 1, 2] (fun p => p + 1) amount = 1 ∧ discord [0, 1, 2] (fun p => p + 1) amount = 1 ∧
      concord [0, 1, 2] (fun p => p + 1) (fun p => p + 1) = 6 ∧ concord [0, 1, 2] amount amount = 2 :=
  ⟨rfl, rfl, rfl, rfl⟩

end Unrelated

end Reproduction

end Becoming
