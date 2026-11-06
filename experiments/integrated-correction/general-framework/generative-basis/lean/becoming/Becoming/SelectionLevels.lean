import Becoming.SelectionTerm
import Becoming.Reproduction

/-!
# Selection levels: selection within groups and among them

`Becoming.SelectionTerm` states the selection term proper of a family: concordance less
discordance of weight and amount over ordered pairs of members, the covariance with its
denominators cleared. Where the family is listed group by group, the same term divides into
selection within the groups and selection among them. This module states that division, the
multilevel form of Price's equation (Price 1972), for groups of any sizes, and reads off the case
of equal sizes.

* **Groups of any sizes.** Let `n` be a common multiple of the groups' sizes, and give each group
  the factor `n` over its size. Read the family with each member read as its group (`context`),
  each group by its factor times its totals of weight and amount: `n` times its means
  (`concordMeans`, `discordMeans`). Read each group's own term by its factor (`concordWithinBy`,
  `discordWithinBy`). Then `n` squared times the whole's concordance, with `n` times the whole's
  size times the groups' own discordances and the discordance of the means, is `n` squared times
  the whole's discordance with the same for the concordances (`levels_sized`). Divided through,
  the whole's covariance is the size-weighted mean of the groups' covariances with the
  size-weighted covariance of their means: Price's partition for groups of unequal size, the
  among-group part the covariance of group means member by member (the contextual reading). It
  rests on three covariations, the whole's, each group's and the family read by groups'
  (`SelectionTerm.covariation`), meeting in one balance (`meet`). So the whole selects for the
  amount exactly where the means' concordance with the scaled within-group concordances exceeds
  the same for the discordances (`rises_iff_sized`, `none_iff_sized`); where the groups' means are
  alike nothing is selected among them (`means_none_of_alike`) and the whole selects exactly as
  the groups' own terms, each by its factor, go (`rises_iff_within_of_alike`).

* **The division, an arithmetic identity.** List a family as `k` groups of `m` members each
  (`whole`): the case of `levels_sized` with every factor one, the family read by groups counting
  each pair of groups `m` times `m` times (`pairs_context`). Read each group by its own concordance and discordance, summed over the groups
  (`concordWithin`, `discordWithin`), and the groups as members read by their totals of weight
  and amount (`concordAmong`, `discordAmong`). Then the whole's concordance, with `k` times the
  groups' discordance and the discordance among groups, is the whole's discordance, with `k`
  times the groups' concordance and the concordance among groups (`levels`). Read over the
  rationals and divided through, the whole's covariance of weight and amount is the mean of the
  groups' own covariances with the covariance of the groups' means: the law of total covariance,
  Price's partition of selection into within-group and between-group parts. It rests on the
  covariation of the whole, of each group, and of the groups read by their totals
  (`SelectionTerm.covariation`), with the family's totals the sums of the groups' (`whole_total`,
  `whole_weighted`, `whole_length`).
* **Which level wins.** So the whole's selection term is positive exactly where the concordance
  among groups with `k` times the groups' concordance exceeds the discordance among groups with
  `k` times the groups' discordance (`rises_iff`), and none exactly where they are equal
  (`none_iff`). Where selection within the groups goes against the amount, the whole selects for
  it only where selection among the groups goes for it (`among_for_of_rises`), and conversely
  (`within_for_of_rises`). Where every group is uniform in amount, or in weight, nothing is
  selected within them and the whole's selection is selection among groups alone
  (`within_none_of_uniform`, `levels_of_uniform`); where the groups' totals are all alike,
  nothing is selected among them and the whole's selection is `k` times selection within
  (`among_none_of_alike`, `levels_of_alike`).
* **Over generations.** In listed generations (`SelectionTerm.Generations`) with exact
  transmission, a generation listed as groups of equal size raises its mean amount across the step
  exactly where, read by offspring number, the among-group and `k` times the within-group
  concordance exceed the corresponding discordances (`rises_exact_iff_levels`); so an amount
  selected against within the groups has its mean rise only where selection among them goes for
  it (`among_for_of_raises`). For groups of any sizes the same holds with the sized terms
  (`rises_exact_iff_sized`). How the next generation is listed does not enter a step: listed as
  groups alike in mean, it raises its mean exactly as the groups' own terms go
  (`rises_exact_iff_within_of_alike`), so an amount selected for among groups at one step is
  selected against at the next wherever the next groups are alike in it and selection within them
  goes against it.
* **Groups formed by descent.** A group's lineage over listed generations is the group at the
  first generation and, at each later one, the offspring of its lineage at the one before
  (`lineage`, `lineages`); the lineages of a generation listed as groups list every later
  generation (`lineages_family`, `lineages_whole`). With exact transmission, every member of a
  lineage carries the value its group was founded at (`lineage_keeps`, `lineage_value`), so a
  lineage's mean stays where it was founded for as long as it has members (`lineage_total`), and
  lineages of groups uniform in an amount stay uniform in it (`lineages_uniform`). Nothing is then
  selected within them at any generation (`lineages_within_none`; for groups of any sizes each
  uniform, `within_by_none_of_uniform` and `rises_iff_means_of_uniform`), and the mean rises
  across any step exactly where the lineages' means are concordant with offspring number beyond
  their discordance (`rises_iff_lineages`): with groups formed by descent from groups uniform in
  the amount, selection is among the lineages alone, at every generation, and the differences
  among them stay as long as the lineages have members. Groups listed otherwise need not keep
  them: regrouped across lineages, groups can come out alike in mean, as in
  `GroupEnding.Exhausted`.
* **Returns to a reading.** Where each member's weight with `k` per unit of its own amount is a
  base with `b` per unit of a reading `o` of it, the weight's concordance with the amount, with
  `k` times the amount's spread (its concordance with itself) and `b` times the reading's
  discordance with it, is the weight's discordance with `b` times the reading's concordance
  (`returns_balance`, from `covariation` and `Reproduction.variation` with the relation carried
  to the totals, `returns_total`, `returns_weighted`). So the whole selects for the amount
  exactly where `b` times the reading's covariation with it exceeds `k` times its spread
  (`rises_iff_reading`): read over the rationals, where `b` times the regression of the reading on
  the amount exceeds `k`. No regression coefficient is formed.
* **Returns to groupmates; groups founded mixed.** List the family as groups of `m` members each,
  and let each unit a member keeps give `b` to every other member of its group and cost the keeper
  `c` (equivalently, give `b` to every member, its own included, and take `b + c` from the
  keeper): a member's offspring number with `b + c` per unit of its own amount is
  a base with `b` per unit of its group's total. The spread of the amount over the whole is the
  number of groups times the groups' own spreads with the spread among them (`spread_levels`). Within each group
  the offspring number goes against the amount by `b + c` times the group's spread
  (`within_returns`), so where `b + c` is positive selection within goes against keeping wherever
  a group varies in it (`within_against`); among the groups, read by their totals, where the groups differ, it goes for
  keeping exactly where `b + c` falls short of `m` times `b` (`among_returns`, `among_for_iff`). The whole selects for
  keeping exactly where `b + c` times the whole's spread falls short of `m` times `b` times the
  spread among groups (`rises_iff_returns`): with the share of the spread among groups `ρ` (the
  assortment), exactly where `m b ρ` exceeds `b + c`, Hamilton's rule with relatedness
  `(m ρ - 1) / (m - 1)` among groupmates. Groups uniform in the amount (assortment one, as
  groups formed by descent from uniform founders are) select for it, where they differ, exactly
  where `b` times `m - 1` exceeds `c` (`rises_iff_returns_of_uniform`); groups alike in their
  totals (assortment none) never select for it (`not_rises_of_alike`); between, the verdict
  turns on how much of the spread lies among groups. Over listed generations with exact
  transmission the mean rises across a step exactly so (`rises_exact_iff_returns`).
* **Returns kept and shared within the group.** Where each unit a member keeps costs it `K`, brings
  `s` back to it alone and gives `q` to every member of its group, its own included, selection within
  the groups goes by `s` against `K` alone, what is shared coming to the members of a group alike
  (`within_kept`); among them, read by their totals, by `s + m q` against `K` (`among_kept`); and the
  whole selects for keeping exactly where `K` times the whole's spread falls short of `s` times it
  with `m q` times the spread among groups (`rises_iff_kept`): read over the rationals, exactly where
  `K < s + m q ρ`. Returns to groupmates are its case with nothing kept (`s = 0`, `K = b + c`,
  `q = b`), and `within_returns`, `among_returns` and `rises_iff_returns` are derived from it. What
  comes back alone enters at every assortment; what is shared within the group only through it.
* **Returns in groups of any sizes.** With `n` a positive common multiple of the groups' sizes, let what each
  unit kept shares reach every member of its group as `q` per unit of a reading `R` of the group.
  Within each group, by its factor, selection goes by `s` against `K` as before (`within_shared_by`);
  among the groups' means, read member by member, by `s` against `K` with `n q` times the reading's
  covariation with the means (`means_shared`, from `kept_balance`, the balance of returns kept on
  any list); and the whole selects for keeping exactly where `K` times `n` times its spread, with
  `q` times the reading's discordance with the group means, falls short of the same with `s` and
  the concordance (`rises_iff_shared_sized`). Two readings are two modelling choices. Each member
  gaining `q` for every unit its group holds (the reading the group's total, as in the equal-size
  laws): the verdict goes through the covariance, member by member, of a member's group total with
  its group's mean (`rises_iff_kept_sized`); with equal sizes this is the size times the spread
  among groups, `rises_iff_kept`'s form (a reading, not stated as a theorem), and with unequal
  sizes it is not a function of the whole's spread and the size-weighted spread of the means.
  What each unit kept gives its group divided among the members (the reading `n` times the group's mean): the verdict goes
  through the size-weighted spread of the group means (`rises_iff_divided_sized`), over the
  rationals, where the amount varies, `K < s + Q ρ` with `Q = n q` what a unit gives its group and
  `ρ` the share of the variance among the means, weighted by size: Hamilton's rule with what comes
  back alone added, for groups of any sizes.
* **Witnesses.** Two groups of two, the amount one at a member that holds back and none at the
  others. In both, the one holding back leaves fewer offspring than its groupmate, so selection
  within goes against holding back. Where the group without it leaves no offspring, selection
  among groups goes for holding back and outweighs it: the whole selects for it (`AmongWins`).
  Where the group without it leaves as many as its members can, selection among groups goes
  against holding back as well, and the whole selects against it (`WithinWins`). With a member
  holding back alone beside a group of three, one of them holding back, the two groups' totals of
  holding back are alike, so the reading by totals sees nothing among them; their means differ
  (one against a third), and the whole's selection for holding back is all among the means
  (`ByMeans`). With two keepers and two others, each unit kept giving two to every groupmate and
  taking one from the keeper, the keepers together select for keeping and the keepers apart,
  with the same returns, against it (`Founding.either_verdict`). With six members in three pairs,
  two thirds of the spread among the pairs, returns of three and a take of two meet the rule at
  assortment one and yet the whole selects against keeping (`Partly.below_one`). With the same two
  keepers and two others, the keepers as a pair and each of the others alone, or each keeper
  alone and the others as a pair,
  the whole's spread and the size-weighted spread of the group means are the same, all of it among
  the means; with each unit kept giving two to every other member of its group and taking one from
  the keeper, the whole selects for keeping with the keepers together and against it with each
  alone (`Sized.either_verdict`); with what is shared divided among the members, the two listings
  give one verdict for any returns the same in both (`Sized.divided_one_verdict`).

The weights are any natural numbers; with offspring numbers they are the selection term proper
of `Becoming.SelectionTerm` divided by level. Nothing is supposed about what the groups are or
why their members' offspring numbers differ: which level wins is read off the counts, not
explained; where the offspring numbers come from returns to groupmates, it is read off the returns
and how much of the amount's spread lies among the groups. Modelling choices: natural-number
weights and amounts, finite families as lists, a common multiple of the groups' sizes in place of
rational means, for lineages exact transmission at every step, and for returns offspring numbers
depending on own and groupmates' amounts additively (no synergy), with groups of equal size for
the spread among groups and of any sizes for a reading of the group, a common multiple of the
sizes in place of rational means. No ethical predicate, ranking or axiom
occurs; every declaration has an empty axiom report.
-/

namespace Becoming

namespace SelectionLevels

open SelectionTerm

variable {α : Type}

/-! ## The family listed by groups -/

/-- The family listed group by group. -/
def whole (gs : List (List α)) : List α := gs.flatMap id

/-- A total over the family is the sum of the groups' totals. -/
theorem whole_total (gs : List (List α)) (q : α → Nat) :
    total (whole gs) q = total gs fun g => total g q :=
  match gs with
  | [] => rfl
  | g :: gs => (total_append q (whole gs) g).trans (congrArg (total g q + ·) (whole_total gs q))

/-- So is the weighted total. -/
theorem whole_weighted (gs : List (List α)) (w a : α → Nat) :
    weighted (whole gs) w a = total gs fun g => weighted g w a :=
  whole_total gs fun p => w p * a p

/-- And the number of members. -/
theorem whole_length (gs : List (List α)) : (whole gs).length = total gs fun g => g.length :=
  (total_ones (whole gs)).symm.trans
    ((whole_total gs fun _ => 1).trans (total_congr (fun g => total_ones g) gs))

/-- With groups of `m` members each, the family has `k` times `m`. -/
theorem whole_length_of_equal {gs : List (List α)} {m : Nat} (equal : ∀ g, g ∈ gs → g.length = m) :
    (whole gs).length = gs.length * m :=
  (whole_length gs).trans ((total_congr_on equal).trans (total_const m gs))

/-- The groups' own concordance, summed over the groups. -/
def concordWithin (gs : List (List α)) (w a : α → Nat) : Nat := total gs fun g => concord g w a

/-- The groups' own discordance, summed over the groups. -/
def discordWithin (gs : List (List α)) (w a : α → Nat) : Nat := total gs fun g => discord g w a

/-- Concordance among the groups, each read by its totals of weight and amount. -/
def concordAmong (gs : List (List α)) (w a : α → Nat) : Nat :=
  concord gs (fun g => total g w) (fun g => total g a)

/-- Discordance among the groups, each read by its totals of weight and amount. -/
def discordAmong (gs : List (List α)) (w a : α → Nat) : Nat :=
  discord gs (fun g => total g w) (fun g => total g a)

/-! ## Groups of any sizes -/

/-- The family with each member read as its group: each group listed once for each of its
members. -/
def context (gs : List (List α)) : List (List α) := gs.flatMap fun g => g.map fun _ => g

/-- A total over the members read as their groups counts each group once for each member. -/
theorem context_total (q : List α → Nat) :
    ∀ gs : List (List α), total (context gs) q = total gs fun g => g.length * q g
  | [] => rfl
  | g :: gs => (total_append q (context gs) (g.map fun _ => g)).trans
      (Naturals.add_congr ((total_map (fun _ => g) q g).trans (total_const (q g) g))
        (context_total q gs))

/-- So the family read by groups has as many members as the family. -/
theorem context_length (gs : List (List α)) : (context gs).length = (whole gs).length :=
  (total_ones (context gs)).symm.trans ((context_total (fun _ => 1) gs).trans
    ((total_congr (p := fun g => g.length * 1) (q := fun g => g.length)
      (fun g => Nat.mul_one g.length) gs).trans (whole_length gs).symm))

/-- A member read as its group reads a group of the family. -/
theorem mem_of_mem_context : ∀ {gs : List (List α)} {x : List α}, x ∈ context gs → x ∈ gs
  | g :: _, _, mem => match mem_append_cases mem with
    | .inl here => match preimage_of_mem_map here with
      | ⟨_, _, same⟩ => same ▸ .head _
    | .inr there => .tail g (mem_of_mem_context there)

/-- Each group's own concordance, by a factor of its own, summed over the groups. -/
def concordWithinBy (gs : List (List α)) (c : List α → Nat) (w a : α → Nat) : Nat :=
  total gs fun g => c g * concord g w a

/-- Each group's own discordance, by a factor of its own, summed over the groups. -/
def discordWithinBy (gs : List (List α)) (c : List α → Nat) (w a : α → Nat) : Nat :=
  total gs fun g => c g * discord g w a

/-- Concordance of the groups' means, member by member: each member read by its group's totals
of weight and amount, each by the group's factor. -/
def concordMeans (gs : List (List α)) (c : List α → Nat) (w a : α → Nat) : Nat :=
  concord (context gs) (fun g => c g * total g w) (fun g => c g * total g a)

/-- Discordance of the groups' means, member by member. -/
def discordMeans (gs : List (List α)) (c : List α → Nat) (w a : α → Nat) : Nat :=
  discord (context gs) (fun g => c g * total g w) (fun g => c g * total g a)

theorem shuffle_left (c dw d' q s p : Nat) :
    c + (dw + d') + (q + (s + p)) = q + c + (s + dw + (p + d')) :=
  (Nat.add_add_add_comm c (dw + d') q (s + p)).trans (Naturals.add_congr (Nat.add_comm c q)
    ((Nat.add_add_add_comm dw d' s p).trans
      (Naturals.add_congr (Nat.add_comm dw s) (Nat.add_comm d' p))))

theorem shuffle_right (s d p cw q c' : Nat) :
    s + d + (p + cw + (q + c')) = d + (cw + c') + (q + (s + p)) :=
  (congrArg (s + d + ·) (Nat.add_add_add_comm p cw q c')).trans
    ((Nat.add_add_add_comm s d (p + q) (cw + c')).trans ((Nat.add_comm _ _).trans
      (congrArg (d + (cw + c') + ·) ((congrArg (s + ·) (Nat.add_comm p q)).trans
        (Nat.add_left_comm s q p)))))

/-- Three balances meeting: the whole's, the groups' and the means'. -/
theorem meet {s d q c dw p cw d' c' : Nat} (whole : s + d = q + c) (groups : s + dw = p + cw)
    (means : p + d' = q + c') : c + (dw + d') = d + (cw + c') :=
  add_right_cancel (q + (s + p)) ((shuffle_left c dw d' q s p).trans
    ((Naturals.add_congr whole.symm (Naturals.add_congr groups means)).trans
      (shuffle_right s d p cw q c')))

theorem square_split (n x y : Nat) : n * x * (n * y) = n * n * (x * y) :=
  (mul_assoc_nat n x (n * y)).trans ((congrArg (n * ·) (mul_turn x n y)).trans
    (mul_assoc_nat n n (x * y)).symm)

/-- Selection within groups and among them, for groups of any sizes: with `n` a common multiple
of the groups' sizes and each group's factor `n` over its size, `n` squared times the whole's
concordance, with `n` times the whole's size times the groups' own discordances, each by its
factor, and the discordance of the groups' means, is `n` squared times the whole's discordance,
with the same for the concordances. Divided through by `n` squared times the whole's size squared,
the whole's covariance is the size-weighted mean of the groups' covariances with the size-weighted
covariance of their means: Price's partition for groups of unequal size. No premise beyond the
common multiple. -/
theorem levels_sized (gs : List (List α)) (w a : α → Nat) (c : List α → Nat) {n : Nat}
    (common : ∀ g, g ∈ gs → g.length * c g = n) :
    n * n * concord (whole gs) w a +
        (n * (whole gs).length * discordWithinBy gs c w a + discordMeans gs c w a) =
      n * n * discord (whole gs) w a +
        (n * (whole gs).length * concordWithinBy gs c w a + concordMeans gs c w a) :=
  have whole_cov : (whole gs).length * (total gs fun g => weighted g w a) + discord (whole gs) w a =
      (total gs fun g => total g w) * (total gs fun g => total g a) + concord (whole gs) w a := by
    have h := covariation (whole gs) w a
    rw [whole_weighted, whole_total, whole_total] at h
    exact h
  have groups : n * (total gs fun g => weighted g w a) + discordWithinBy gs c w a =
      (total gs fun g => c g * (total g w * total g a)) + concordWithinBy gs c w a :=
    (Naturals.add_congr (total_mul n _ gs).symm rfl).trans ((total_add _ _ gs).symm.trans
      ((total_congr_on fun g mg =>
        have h := congrArg (c g * ·) (covariation g w a)
        have own : c g * (g.length * weighted g w a) = n * weighted g w a :=
          (mul_assoc_nat _ _ _).symm.trans (congrArg (· * weighted g w a)
            ((Nat.mul_comm _ _).trans (common g mg)))
        (Naturals.add_congr own.symm rfl).trans ((Nat.left_distrib _ _ _).symm.trans
          (h.trans (Nat.left_distrib _ _ _)))).trans (total_add _ _ gs)))
  have means : (whole gs).length * (n * total gs fun g => c g * (total g w * total g a)) +
      discordMeans gs c w a =
        n * (total gs fun g => total g w) * (n * total gs fun g => total g a) +
          concordMeans gs c w a := by
    have h := covariation (context gs) (fun g => c g * total g w) (fun g => c g * total g a)
    have wt : weighted (context gs) (fun g => c g * total g w) (fun g => c g * total g a) =
        n * total gs fun g => c g * (total g w * total g a) :=
      (context_total _ gs).trans ((total_congr_on fun g mg =>
        ((congrArg (g.length * ·) (square_split (c g) (total g w) (total g a))).trans
          ((mul_assoc_nat _ _ _).symm.trans ((congrArg (· * (total g w * total g a))
            ((mul_assoc_nat _ _ _).symm.trans (congrArg (· * c g) (common g mg)))).trans
            (mul_assoc_nat _ _ _))))).trans (total_mul n _ gs))
    have tw : ∀ q : α → Nat, total (context gs) (fun g => c g * total g q) =
        n * total gs fun g => total g q := fun q =>
      (context_total _ gs).trans ((total_congr_on fun g mg =>
        (mul_assoc_nat _ _ _).symm.trans (congrArg (· * total g q) (common g mg))).trans
        (total_mul n _ gs))
    rw [context_length, wt, tw w, tw a] at h
    exact h
  have e1 : n * n * ((whole gs).length * (total gs fun g => weighted g w a)) +
      n * n * discord (whole gs) w a =
        n * n * ((total gs fun g => total g w) * (total gs fun g => total g a)) +
          n * n * concord (whole gs) w a :=
    (Nat.left_distrib _ _ _).symm.trans ((congrArg (n * n * ·) whole_cov).trans
      (Nat.left_distrib _ _ _))
  have e2 : n * n * ((whole gs).length * (total gs fun g => weighted g w a)) +
      n * (whole gs).length * discordWithinBy gs c w a =
        (whole gs).length * (n * total gs fun g => c g * (total g w * total g a)) +
          n * (whole gs).length * concordWithinBy gs c w a := by
    have h : n * (whole gs).length * (n * total gs fun g => weighted g w a) +
        n * (whole gs).length * discordWithinBy gs c w a =
          n * (whole gs).length * (total gs fun g => c g * (total g w * total g a)) +
            n * (whole gs).length * concordWithinBy gs c w a :=
      (Nat.left_distrib _ _ _).symm.trans ((congrArg (n * (whole gs).length * ·) groups).trans
        (Nat.left_distrib _ _ _))
    have sq : n * (whole gs).length * (n * total gs fun g => weighted g w a) =
        n * n * ((whole gs).length * total gs fun g => weighted g w a) :=
      square_split n _ _ |>.trans rfl
    have pr : n * (whole gs).length * (total gs fun g => c g * (total g w * total g a)) =
        (whole gs).length * (n * total gs fun g => c g * (total g w * total g a)) :=
      (congrArg (· * _) (Nat.mul_comm n _)).trans (mul_assoc_nat _ _ _)
    rw [sq, pr] at h
    exact h
  have e3 : (whole gs).length * (n * total gs fun g => c g * (total g w * total g a)) +
      discordMeans gs c w a =
        n * n * ((total gs fun g => total g w) * (total gs fun g => total g a)) +
          concordMeans gs c w a := by
    rw [← square_split]
    exact means
  meet e1 e2 e3

/-! ## The division -/

/-- The family read as its groups, each group listed once for each of its `m` members: totals
over ordered pairs count each pair of groups `m` times `m` times. -/
theorem pairs_context {gs : List (List α)} {m : Nat} (equal : ∀ g, g ∈ gs → g.length = m)
    (F : List α → List α → Nat) :
    (total (context gs) fun x => total (context gs) (F x)) =
      m * m * total gs fun g => total gs (F g) :=
  (total_congr (fun x => (context_total (F x) gs).trans ((total_congr_on fun h mh =>
      congrArg (· * F x h) (equal h mh)).trans (total_mul m _ gs))) (context gs)).trans
    ((context_total _ gs).trans ((total_congr_on fun g mg =>
      (congrArg (· * (m * total gs (F g))) (equal g mg)).trans (mul_assoc_nat _ _ _).symm).trans
      (total_mul (m * m) _ gs)))

/-- Each factor one: each group's own term once. -/
theorem within_by_one (gs : List (List α)) (w a : α → Nat) :
    concordWithinBy gs (fun _ => 1) w a = concordWithin gs w a ∧
      discordWithinBy gs (fun _ => 1) w a = discordWithin gs w a :=
  ⟨total_congr (fun g => Nat.one_mul (concord g w a)) gs,
    total_congr (fun g => Nat.one_mul (discord g w a)) gs⟩

/-- Groups read by their totals, each by the factor one, are read by their totals. -/
theorem among_by_one (gs : List (List α)) (w a : α → Nat) :
    concord gs (fun g => 1 * total g w) (fun g => 1 * total g a) = concordAmong gs w a ∧
      discord gs (fun g => 1 * total g w) (fun g => 1 * total g a) = discordAmong gs w a :=
  ⟨total_congr (fun g => total_congr (fun h => by
      show excess (1 * total g w) (1 * total h w) * excess (1 * total g a) (1 * total h a) =
        excess (total g w) (total h w) * excess (total g a) (total h a)
      rw [Nat.one_mul (total g w), Nat.one_mul (total h w), Nat.one_mul (total g a),
        Nat.one_mul (total h a)]) gs) gs,
    total_congr (fun g => total_congr (fun h => by
      show excess (1 * total g w) (1 * total h w) * excess (1 * total h a) (1 * total g a) =
        excess (total g w) (total h w) * excess (total h a) (total g a)
      rw [Nat.one_mul (total g w), Nat.one_mul (total h w), Nat.one_mul (total g a),
        Nat.one_mul (total h a)]) gs) gs⟩

/-- Groups all empty leave the family empty. -/
theorem whole_nil : ∀ {gs : List (List α)}, (∀ g, g ∈ gs → g.length = 0) → whole gs = []
  | [], _ => rfl
  | g :: gs, empty => (congrArg (· ++ whole gs) (nil_of_length_zero (empty g (.head gs)))).trans
      (whole_nil fun h mh => empty h (.tail g mh))

/-- Selection within groups and among them, for `k` groups of equal size: the whole's
concordance, with `k` times the groups' own discordance and the discordance among groups, is the
whole's discordance, with `k` times the groups' own concordance and the concordance among groups.
Divided through, the whole's covariance is the mean of the groups' covariances with the
covariance of their means. No premise beyond the equal sizes: the case of `levels_sized` with
every factor one. -/
theorem levels (gs : List (List α)) (w a : α → Nat) {m : Nat}
    (equal : ∀ g, g ∈ gs → g.length = m) :
    concord (whole gs) w a + (gs.length * discordWithin gs w a + discordAmong gs w a) =
      discord (whole gs) w a + (gs.length * concordWithin gs w a + concordAmong gs w a) :=
  match m, equal with
  | 0, equal =>
    have nil := whole_nil equal
    have zero : ∀ g, g ∈ gs → total g w = 0 := fun g mg => by
      rw [nil_of_length_zero (equal g mg)]; rfl
    have within : ∀ g, g ∈ gs → concord g w a = 0 ∧ discord g w a = 0 := fun g mg => by
      rw [nil_of_length_zero (equal g mg)]; exact ⟨rfl, rfl⟩
    have cw : concordWithin gs w a = 0 := total_eq_zero fun g mg => (within g mg).1
    have dw : discordWithin gs w a = 0 := total_eq_zero fun g mg => (within g mg).2
    have ca : concordAmong gs w a = 0 := concord_uniform zero _
    have da : discordAmong gs w a = 0 := discord_uniform zero _
    by rw [nil, cw, dw, ca, da]; rfl
  | m + 1, equal =>
    have sized := levels_sized gs w a (fun _ => 1) (n := m + 1)
      fun g mg => (Nat.mul_one _).trans (equal g mg)
    have scale : (m + 1) * (whole gs).length = (m + 1) * (m + 1) * gs.length :=
      (congrArg ((m + 1) * ·) ((whole_length_of_equal equal).trans (Nat.mul_comm _ _))).trans
        (mul_assoc_nat _ _ _).symm
    have among : ∀ F H : List α → Nat,
        concord (context gs) F H = (m + 1) * (m + 1) * concord gs F H ∧
          discord (context gs) F H = (m + 1) * (m + 1) * discord gs F H := fun F H =>
      ⟨pairs_context equal fun x y => excess (F x) (F y) * excess (H x) (H y),
        pairs_context equal fun x y => excess (F x) (F y) * excess (H y) (H x)⟩
    by
      unfold concordMeans discordMeans at sized
      rw [(within_by_one gs w a).1, (within_by_one gs w a).2, scale,
        (among _ _).1, (among _ _).2, (among_by_one gs w a).1, (among_by_one gs w a).2, mul_assoc_nat _ gs.length, mul_assoc_nat _ gs.length,
        ← Nat.left_distrib, ← Nat.left_distrib, ← Nat.left_distrib, ← Nat.left_distrib] at sized
      exact Nat.le_antisymm
        (le_of_mul_le_mul (Nat.mul_pos (Nat.succ_pos m) (Nat.succ_pos m)) (Nat.le_of_eq sized))
        (le_of_mul_le_mul (Nat.mul_pos (Nat.succ_pos m) (Nat.succ_pos m)) (Nat.le_of_eq sized.symm))

/-- The whole selects for the amount exactly where the concordance among groups with `k` times
the groups' concordance exceeds the discordance among groups with `k` times the groups'
discordance. -/
theorem rises_iff (gs : List (List α)) (w a : α → Nat) {m : Nat}
    (equal : ∀ g, g ∈ gs → g.length = m) :
    discord (whole gs) w a < concord (whole gs) w a ↔
      gs.length * discordWithin gs w a + discordAmong gs w a <
        gs.length * concordWithin gs w a + concordAmong gs w a :=
  lt_iff_of_balance (levels gs w a equal)

/-- And selects nothing exactly where they are equal. -/
theorem none_iff (gs : List (List α)) (w a : α → Nat) {m : Nat}
    (equal : ∀ g, g ∈ gs → g.length = m) :
    discord (whole gs) w a = concord (whole gs) w a ↔
      gs.length * discordWithin gs w a + discordAmong gs w a =
        gs.length * concordWithin gs w a + concordAmong gs w a :=
  eq_iff_of_balance (levels gs w a equal)

/-! ## Which level wins, for groups of any sizes -/

/-- A positive square keeps the order both ways. -/
theorem square_lt_iff {n x y : Nat} (pos : 0 < n) : n * n * x < n * n * y ↔ x < y :=
  ⟨Naturals.lt_of_mul_lt_mul_left, fun lt => Nat.mul_lt_mul_of_pos_left lt (Nat.mul_pos pos pos)⟩

/-- And equality. -/
theorem square_eq_iff {n x y : Nat} (pos : 0 < n) : n * n * x = n * n * y ↔ x = y :=
  ⟨Nat.eq_of_mul_eq_mul_left (Nat.mul_pos pos pos), congrArg (n * n * ·)⟩

/-- For groups of any sizes, the whole selects for the amount exactly where the concordance of
the groups' means with `n` times the whole's size times the groups' own concordances, each by its
factor, exceeds the same for the discordances. -/
theorem rises_iff_sized (gs : List (List α)) (w a : α → Nat) (c : List α → Nat) {n : Nat}
    (common : ∀ g, g ∈ gs → g.length * c g = n) (pos : 0 < n) :
    discord (whole gs) w a < concord (whole gs) w a ↔
      n * (whole gs).length * discordWithinBy gs c w a + discordMeans gs c w a <
        n * (whole gs).length * concordWithinBy gs c w a + concordMeans gs c w a :=
  (square_lt_iff pos).symm.trans (lt_iff_of_balance (levels_sized gs w a c common))

/-- And selects nothing exactly where they are equal. -/
theorem none_iff_sized (gs : List (List α)) (w a : α → Nat) (c : List α → Nat) {n : Nat}
    (common : ∀ g, g ∈ gs → g.length * c g = n) (pos : 0 < n) :
    discord (whole gs) w a = concord (whole gs) w a ↔
      n * (whole gs).length * discordWithinBy gs c w a + discordMeans gs c w a =
        n * (whole gs).length * concordWithinBy gs c w a + concordMeans gs c w a :=
  (square_eq_iff pos).symm.trans (eq_iff_of_balance (levels_sized gs w a c common))

/-- Where the groups' means of amount are all alike, nothing is selected among them. -/
theorem means_none_of_alike {gs : List (List α)} {w a : α → Nat} {c : List α → Nat} {d : Nat}
    (alike : ∀ g, g ∈ gs → c g * total g a = d) :
    concordMeans gs c w a = 0 ∧ discordMeans gs c w a = 0 :=
  ⟨concord_alike (fun x mx => alike x (mem_of_mem_context mx)) _,
    discord_alike (fun x mx => alike x (mem_of_mem_context mx)) _⟩

/-- So, for a family with members, the whole selects for the amount exactly where the groups' own
concordances, each by its factor, exceed their discordances: with the groups alike in mean,
selection within them is all there is. -/
theorem rises_iff_within_of_alike (gs : List (List α)) (w a : α → Nat) (c : List α → Nat)
    {n d : Nat} (common : ∀ g, g ∈ gs → g.length * c g = n)
    (pos : 0 < n * (whole gs).length) (alike : ∀ g, g ∈ gs → c g * total g a = d) :
    discord (whole gs) w a < concord (whole gs) w a ↔
      discordWithinBy gs c w a < concordWithinBy gs c w a := by
  have h := rises_iff_sized gs w a c common (pos_of_mul_pos pos)
  rw [(means_none_of_alike alike).1, (means_none_of_alike alike).2, Nat.add_zero,
    Nat.add_zero] at h
  exact h.trans ⟨Naturals.lt_of_mul_lt_mul_left, fun lt => Nat.mul_lt_mul_of_pos_left lt pos⟩

/-- Where selection within the groups goes against the amount, the whole selects for it only
where selection among the groups goes for it. -/
theorem among_for_of_rises (gs : List (List α)) (w a : α → Nat) {m : Nat}
    (equal : ∀ g, g ∈ gs → g.length = m)
    (against : concordWithin gs w a ≤ discordWithin gs w a)
    (rises : discord (whole gs) w a < concord (whole gs) w a) :
    discordAmong gs w a < concordAmong gs w a :=
  Nat.lt_of_add_lt_add_left (Nat.lt_of_le_of_lt
    (Nat.add_le_add_right (Nat.mul_le_mul_left _ against) _)
    ((rises_iff gs w a equal).mp rises))

/-- And where selection among the groups goes against it, the whole selects for it only where
selection within the groups goes for it. -/
theorem within_for_of_rises (gs : List (List α)) (w a : α → Nat) {m : Nat}
    (equal : ∀ g, g ∈ gs → g.length = m)
    (against : concordAmong gs w a ≤ discordAmong gs w a)
    (rises : discord (whole gs) w a < concord (whole gs) w a) :
    discordWithin gs w a < concordWithin gs w a :=
  Naturals.lt_of_mul_lt_mul_left (m := gs.length) (Nat.lt_of_add_lt_add_right (Nat.lt_of_le_of_lt
    (Nat.add_le_add_left against _) ((rises_iff gs w a equal).mp rises)))

/-- Where every group is uniform in amount, nothing is selected within the groups. -/
theorem within_none_of_uniform {gs : List (List α)} {w a : α → Nat}
    (uniform : ∀ g, g ∈ gs → ∃ c, ∀ p, p ∈ g → a p = c) :
    concordWithin gs w a = 0 ∧ discordWithin gs w a = 0 :=
  ⟨total_eq_zero fun g mg => match uniform g mg with
      | ⟨_, same⟩ => concord_alike same w,
    total_eq_zero fun g mg => match uniform g mg with
      | ⟨_, same⟩ => discord_alike same w⟩

/-- So the whole's selection is selection among groups alone. -/
theorem levels_of_uniform (gs : List (List α)) (w a : α → Nat) {m : Nat}
    (equal : ∀ g, g ∈ gs → g.length = m) (uniform : ∀ g, g ∈ gs → ∃ c, ∀ p, p ∈ g → a p = c) :
    concord (whole gs) w a + discordAmong gs w a = discord (whole gs) w a + concordAmong gs w a := by
  have h := levels gs w a equal
  rw [(within_none_of_uniform uniform).1, (within_none_of_uniform uniform).2, Nat.mul_zero,
    Nat.zero_add, Nat.zero_add] at h
  exact h

/-- Where the groups' totals of amount are all alike, nothing is selected among the groups. -/
theorem among_none_of_alike {gs : List (List α)} {w a : α → Nat} {c : Nat}
    (alike : ∀ g, g ∈ gs → total g a = c) :
    concordAmong gs w a = 0 ∧ discordAmong gs w a = 0 :=
  ⟨concord_alike alike _, discord_alike alike _⟩

/-- So the whole's selection is `k` times selection within the groups. -/
theorem levels_of_alike (gs : List (List α)) (w a : α → Nat) {m c : Nat}
    (equal : ∀ g, g ∈ gs → g.length = m) (alike : ∀ g, g ∈ gs → total g a = c) :
    concord (whole gs) w a + gs.length * discordWithin gs w a =
      discord (whole gs) w a + gs.length * concordWithin gs w a := by
  have h := levels gs w a equal
  rw [(among_none_of_alike alike).1, (among_none_of_alike alike).2, Nat.add_zero, Nat.add_zero] at h
  exact h

/-! ## Over generations -/

/-- Over listed generations with exact transmission, a generation listed as groups of equal size:
its mean amount rises across the step exactly where, read by offspring number, the concordance
among groups with `k` times the groups' own concordance exceeds the discordance among groups with
`k` times the groups' own discordance. -/
theorem rises_exact_iff_levels (G : Generations α) {t m : Nat} (gs : List (List α))
    (listed : whole gs = G.family t) (equal : ∀ g, g ∈ gs → g.length = m)
    (exact : Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1))) :
    G.Raises t ↔
      gs.length * discordWithin gs (G.offspringNumber t) (G.amount t) +
          discordAmong gs (G.offspringNumber t) (G.amount t) <
        gs.length * concordWithin gs (G.offspringNumber t) (G.amount t) +
          concordAmong gs (G.offspringNumber t) (G.amount t) :=
  (G.raises_exact_iff exact).trans (by
    unfold Generations.concordAt Generations.discordAt
    rw [← listed]
    exact rises_iff gs _ _ equal)

/-- Over listed generations with exact transmission, a generation listed as groups of any sizes,
with `n` a common multiple of their sizes: its mean amount rises across the step exactly where,
read by offspring number, the concordance of the groups' means with `n` times the generation's
size times the groups' own concordances, each by its factor, exceeds the same for the
discordances. -/
theorem rises_exact_iff_sized (G : Generations α) {t n : Nat} (gs : List (List α))
    (c : List α → Nat) (listed : whole gs = G.family t) (common : ∀ g, g ∈ gs → g.length * c g = n)
    (pos : 0 < n) (exact : Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1))) :
    G.Raises t ↔
      n * (whole gs).length * discordWithinBy gs c (G.offspringNumber t) (G.amount t) +
          discordMeans gs c (G.offspringNumber t) (G.amount t) <
        n * (whole gs).length * concordWithinBy gs c (G.offspringNumber t) (G.amount t) +
          concordMeans gs c (G.offspringNumber t) (G.amount t) :=
  (G.raises_exact_iff exact).trans (by
    unfold Generations.concordAt Generations.discordAt
    rw [← listed]
    exact rises_iff_sized gs _ _ c common pos)

/-- How the next generation is listed does not enter the step: listed as groups alike in mean,
a generation with exact transmission raises its mean across the step exactly where, read by
offspring number, the groups' own concordances, each by its factor, exceed their discordances. So
an amount selected for among groups at one step is selected against at the next wherever the next
generation's groups are alike in it and selection within them goes against it. -/
theorem rises_exact_iff_within_of_alike (G : Generations α) {t n d : Nat} (gs : List (List α))
    (c : List α → Nat) (listed : whole gs = G.family t) (common : ∀ g, g ∈ gs → g.length * c g = n)
    (pos : 0 < n * (whole gs).length)
    (alike : ∀ g, g ∈ gs → c g * total g (G.amount t) = d)
    (exact : Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1))) :
    G.Raises t ↔
      discordWithinBy gs c (G.offspringNumber t) (G.amount t) <
        concordWithinBy gs c (G.offspringNumber t) (G.amount t) :=
  (G.raises_exact_iff exact).trans (by
    unfold Generations.concordAt Generations.discordAt
    rw [← listed]
    exact rises_iff_within_of_alike gs _ _ c common pos alike)

/-- So, with exact transmission, where selection within the groups goes against the amount, its
mean rises only where selection among the groups goes for it. -/
theorem among_for_of_raises (G : Generations α) {t m : Nat} (gs : List (List α))
    (listed : whole gs = G.family t) (equal : ∀ g, g ∈ gs → g.length = m)
    (exact : Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (against : concordWithin gs (G.offspringNumber t) (G.amount t) ≤
      discordWithin gs (G.offspringNumber t) (G.amount t))
    (raises : G.Raises t) :
    discordAmong gs (G.offspringNumber t) (G.amount t) <
      concordAmong gs (G.offspringNumber t) (G.amount t) :=
  Nat.lt_of_add_lt_add_left (Nat.lt_of_le_of_lt
    (Nat.add_le_add_right (Nat.mul_le_mul_left _ against) _)
    ((rises_exact_iff_levels G gs listed equal exact).mp raises))

/-! ## Groups formed by descent -/

/-- Where every group is uniform in amount, nothing is selected within the groups, each read by a
factor of its own. -/
theorem within_by_none_of_uniform {gs : List (List α)} {c : List α → Nat} {w a : α → Nat}
    (uniform : ∀ g, g ∈ gs → ∃ v, ∀ p, p ∈ g → a p = v) :
    concordWithinBy gs c w a = 0 ∧ discordWithinBy gs c w a = 0 :=
  ⟨total_eq_zero fun g mg => match uniform g mg with
      | ⟨_, same⟩ => (congrArg (c g * ·) (concord_alike same w)).trans (Nat.mul_zero _),
    total_eq_zero fun g mg => match uniform g mg with
      | ⟨_, same⟩ => (congrArg (c g * ·) (discord_alike same w)).trans (Nat.mul_zero _)⟩

/-- So, for groups of any sizes each uniform in amount, the whole selects for the amount exactly
where the groups' means are concordant with offspring number beyond their discordance: all of it
is selection among groups. -/
theorem rises_iff_means_of_uniform (gs : List (List α)) (w a : α → Nat) (c : List α → Nat)
    {n : Nat} (common : ∀ g, g ∈ gs → g.length * c g = n) (pos : 0 < n)
    (uniform : ∀ g, g ∈ gs → ∃ v, ∀ p, p ∈ g → a p = v) :
    discord (whole gs) w a < concord (whole gs) w a ↔ discordMeans gs c w a < concordMeans gs c w a := by
  have h := rises_iff_sized gs w a c common pos
  rw [(within_by_none_of_uniform (c := c) (w := w) uniform).1,
    (within_by_none_of_uniform (c := c) (w := w) uniform).2, Nat.mul_zero, Nat.zero_add,
    Nat.zero_add] at h
  exact h

/-- A group's lineage over listed generations: the group at the first generation, and at each
later one the offspring of its lineage at the one before. -/
def lineage (G : Generations α) (g : List α) : Nat → List α
  | 0 => g
  | t + 1 => (lineage G g t).flatMap (G.kids t)

/-- Groups formed by descent: each group of the first generation read by its lineage. -/
def lineages (G : Generations α) (gs : List (List α)) (t : Nat) : List (List α) :=
  gs.map fun g => lineage G g t

/-- Families read by groups joined after a map. -/
theorem whole_map {β : Type} (f : β → List α) : ∀ gs : List β, whole (gs.map f) = gs.flatMap f
  | [] => rfl
  | g :: gs => show f g ++ whole (gs.map f) = f g ++ gs.flatMap f from
      congrArg (f g ++ ·) (whole_map f gs)

/-- Offspring of a joined family are the offspring of each part, joined. -/
theorem flatMap_flatMap {β : Type} (F : β → List α) (k : α → List α) :
    ∀ gs : List β, (gs.flatMap F).flatMap k = gs.flatMap fun g => (F g).flatMap k
  | [] => rfl
  | g :: gs => show (F g ++ gs.flatMap F).flatMap k = (F g).flatMap k ++ _ from
      (flatMap_join (F g) (gs.flatMap F) k).trans
        (congrArg ((F g).flatMap k ++ ·) (flatMap_flatMap F k gs))
where
  flatMap_join : ∀ (l m : List α) (k : α → List α), (l ++ m).flatMap k = l.flatMap k ++ m.flatMap k
    | [], _, _ => rfl
    | x :: l, m, k => show k x ++ (l ++ m).flatMap k = (k x ++ l.flatMap k) ++ m.flatMap k from
        (congrArg (k x ++ ·) (flatMap_join l m k)).trans (ListTests.append_assoc _ _ _).symm

/-- A generation listed as groups is, at every later generation, the union of their lineages. -/
theorem lineages_family (G : Generations α) {gs : List (List α)} (listed : whole gs = G.family 0) :
    ∀ t, (gs.flatMap fun g => lineage G g t) = G.family t
  | 0 => listed
  | t + 1 => (flatMap_flatMap (fun g => lineage G g t) (G.kids t) gs).symm.trans
      (congrArg (List.flatMap (G.kids t)) (lineages_family G listed t))

/-- So the lineages list each later generation by groups. -/
theorem lineages_whole (G : Generations α) {gs : List (List α)} (listed : whole gs = G.family 0)
    (t : Nat) : whole (lineages G gs t) = G.family t :=
  (whole_map _ gs).trans (lineages_family G listed t)

/-- A lineage's members belong to their generation. -/
theorem lineage_within (G : Generations α) {g : List α} (within : ∀ p, p ∈ g → p ∈ G.family 0) :
    ∀ t p, p ∈ lineage G g t → p ∈ G.family t
  | 0, p, mp => within p mp
  | t + 1, _, mp => match ListTests.mem_flatMap_iff.mp mp with
    | ⟨q, mq, mk⟩ => ListTests.mem_flatMap_iff.mpr ⟨q, lineage_within G within t q mq, mk⟩

/-- With exact transmission, a lineage founded by a group uniform at a value keeps that value at
every generation: whatever offspring it leaves carry it. -/
theorem lineage_keeps (G : Generations α) {g : List α} {v : Nat}
    (within : ∀ p, p ∈ g → p ∈ G.family 0)
    (exact : ∀ t, Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (founded : ∀ p, p ∈ g → G.amount 0 p = v) : ∀ t p, p ∈ lineage G g t → G.amount t p = v
  | 0, p, mp => founded p mp
  | t + 1, p, mp => match ListTests.mem_flatMap_iff.mp mp with
    | ⟨q, mq, mk⟩ => (exact t q (lineage_within G within t q mq) p mk).trans
        (lineage_keeps G within exact founded t q mq)

/-- So its total is its size times the value: its mean stays where it was founded for as long as
it has members. -/
theorem lineage_total (G : Generations α) {g : List α} {v : Nat}
    (within : ∀ p, p ∈ g → p ∈ G.family 0)
    (exact : ∀ t, Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (founded : ∀ p, p ∈ g → G.amount 0 p = v) (t : Nat) :
    total (lineage G g t) (G.amount t) = (lineage G g t).length * v :=
  (total_congr_on (lineage_keeps G within exact founded t)).trans (total_const v _)

/-- Read by groups of the first generation each founded at a value, with exact transmission:
every member of a group's lineage, at every generation, carries the value its group was founded
at. -/
theorem lineage_value (G : Generations α) {gs : List (List α)} (listed : whole gs = G.family 0)
    (exact : ∀ t, Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    {v : List α → Nat} (founded : ∀ g, g ∈ gs → ∀ p, p ∈ g → G.amount 0 p = v g) {g : List α}
    (mg : g ∈ gs) (t : Nat) {p : α} (mp : p ∈ lineage G g t) : G.amount t p = v g :=
  lineage_keeps G (fun _ mq => listed ▸ ListTests.mem_flatMap_iff.mpr ⟨g, mg, mq⟩) exact
    (founded g mg) t p mp

/-- Groups uniform in an amount at the first generation, with exact transmission: their lineages
are uniform in it at every generation. -/
theorem lineages_uniform (G : Generations α) {gs : List (List α)} (listed : whole gs = G.family 0)
    (exact : ∀ t, Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (uniform : ∀ g, g ∈ gs → ∃ v, ∀ p, p ∈ g → G.amount 0 p = v) (t : Nat) :
    ∀ h, h ∈ lineages G gs t → ∃ v, ∀ p, p ∈ h → G.amount t p = v :=
  fun _ mh => match preimage_of_mem_map mh with
  | ⟨g, mg, same⟩ => match uniform g mg with
    | ⟨v, founded⟩ => ⟨v, same ▸ lineage_keeps G
        (fun _ mp => listed ▸ ListTests.mem_flatMap_iff.mpr ⟨g, mg, mp⟩) exact founded t⟩

/-- So at every generation nothing is selected within the lineages, for any weight. -/
theorem lineages_within_none (G : Generations α) {gs : List (List α)}
    (listed : whole gs = G.family 0)
    (exact : ∀ t, Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (uniform : ∀ g, g ∈ gs → ∃ v, ∀ p, p ∈ g → G.amount 0 p = v) (t : Nat) (w : α → Nat) :
    concordWithin (lineages G gs t) w (G.amount t) = 0 ∧
      discordWithin (lineages G gs t) w (G.amount t) = 0 :=
  within_none_of_uniform (lineages_uniform G listed exact uniform t)

/-- And the mean rises across any step exactly where the lineages' means, read by a common
multiple `n` of their sizes, are concordant with offspring number beyond their discordance: with
groups formed by descent from groups uniform in the amount, selection is among the lineages alone
at every generation. (A lineage that has ended has no members and no factor; read the lineages
that have members.) -/
theorem rises_iff_lineages (G : Generations α) {gs : List (List α)}
    (listed : whole gs = G.family 0)
    (exact : ∀ t, Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (uniform : ∀ g, g ∈ gs → ∃ v, ∀ p, p ∈ g → G.amount 0 p = v) {t n : Nat}
    (c : List α → Nat) (common : ∀ h, h ∈ lineages G gs t → h.length * c h = n) (pos : 0 < n) :
    G.Raises t ↔
      discordMeans (lineages G gs t) c (G.offspringNumber t) (G.amount t) <
        concordMeans (lineages G gs t) c (G.offspringNumber t) (G.amount t) :=
  (G.raises_exact_iff (exact t)).trans (by
    unfold Generations.concordAt Generations.discordAt
    rw [← lineages_whole G listed t]
    exact rises_iff_means_of_uniform _ _ _ c common pos (lineages_uniform G listed exact uniform t))

/-! ## Returns to groupmates -/

/-- Balances add. -/
theorem balance_add {x p y q x' p' y' q' : Nat} (one : x + p = y + q) (two : x' + p' = y' + q') :
    x + x' + (p + p') = y + y' + (q + q') :=
  (Nat.add_add_add_comm x x' p p').trans ((Naturals.add_congr one two).trans
    (Nat.add_add_add_comm y q y' q'))

/-- A balance scales. -/
theorem balance_mul (k : Nat) {x p y q : Nat} (same : x + p = y + q) :
    k * x + k * p = k * y + k * q :=
  (Nat.left_distrib k x p).symm.trans ((congrArg (k * ·) same).trans (Nat.left_distrib k y q))

/-- Where each member's weight with `k` per unit of its amount is a base `B` with `b` per unit of a
reading `o`, the totals keep the relation. -/
theorem returns_total {ps : List α} {w a o : α → Nat} {B b k : Nat}
    (returns : ∀ p, p ∈ ps → w p + k * a p = B + b * o p) :
    total ps w + k * total ps a = ps.length * B + b * total ps o :=
  (Naturals.add_congr rfl (total_mul k a ps).symm).trans
    ((total_add w (fun p => k * a p) ps).symm.trans ((total_congr_on returns).trans
      ((total_add (fun _ => B) (fun p => b * o p) ps).trans
        (Naturals.add_congr (total_const B ps) (total_mul b o ps)))))

/-- And so do the totals weighted by the amount. -/
theorem returns_weighted {ps : List α} {w a o : α → Nat} {B b k : Nat}
    (returns : ∀ p, p ∈ ps → w p + k * a p = B + b * o p) :
    weighted ps w a + k * weighted ps a a = B * total ps a + b * weighted ps o a :=
  (Naturals.add_congr rfl (total_mul k (fun p => a p * a p) ps).symm).trans
    ((total_add (fun p => w p * a p) (fun p => k * (a p * a p)) ps).symm.trans
      ((total_congr_on fun p mp =>
        (congrArg (w p * a p + ·) (mul_assoc_nat k (a p) (a p)).symm).trans
          ((add_mul_split (w p) (k * a p) (a p)).symm.trans
            ((congrArg (· * a p) (returns p mp)).trans
              ((add_mul_split B (b * o p) (a p)).trans
                (congrArg (B * a p + ·) (mul_assoc_nat b (o p) (a p))))))).trans
        ((total_add (fun p => B * a p) (fun p => b * (o p * a p)) ps).trans
          (Naturals.add_congr (total_mul B a ps) (total_mul b (fun p => o p * a p) ps)))))

/-- Returns to a reading: where each member's weight with `k` per unit of its own amount is a base
with `b` per unit of a reading `o`, the weight's concordance with the amount, with `k` times the
amount's spread and `b` times the reading's discordance with the amount, is the weight's
discordance with `b` times the reading's concordance. Read over the rationals and divided
through, the covariance of weight and amount is `b` times the covariance of the reading with the
amount less `k` times the amount's variance. No premise beyond the returns. -/
theorem returns_balance (ps : List α) (w a o : α → Nat) {B b k : Nat}
    (returns : ∀ p, p ∈ ps → w p + k * a p = B + b * o p) :
    concord ps w a + k * concord ps a a + b * discord ps o a =
      discord ps w a + b * concord ps o a := by
  have ew := covariation ps w a
  have ea : ps.length * weighted ps a a + 0 = total ps a * total ps a + concord ps a a :=
    (Nat.add_zero _).trans (Reproduction.variation ps a)
  have eo := covariation ps o a
  have sum := balance_add (balance_add ew (balance_mul k ea)) (balance_mul b eo.symm)
  have tot := returns_total returns
  have wt := returns_weighted returns
  have left : ps.length * weighted ps w a + k * (ps.length * weighted ps a a) =
      ps.length * (B * total ps a) + b * (ps.length * weighted ps o a) :=
    (congrArg (ps.length * weighted ps w a + ·)
        (mul_turn k ps.length (weighted ps a a))).trans
      ((Nat.left_distrib _ _ _).symm.trans ((congrArg (ps.length * ·) wt).trans
        ((Nat.left_distrib _ _ _).trans
          (congrArg (ps.length * (B * total ps a) + ·) (mul_turn ps.length b _)))))
  have right : total ps w * total ps a + k * (total ps a * total ps a) =
      ps.length * (B * total ps a) + b * (total ps o * total ps a) :=
    (congrArg (total ps w * total ps a + ·) (mul_assoc_nat k _ _)).symm.trans
      ((add_mul_split _ _ _).symm.trans ((congrArg (· * total ps a) tot).trans
        ((add_mul_split _ _ _).trans (Naturals.add_congr (mul_assoc_nat _ _ _)
          (mul_assoc_nat _ _ _)))))
  rw [left, right, Nat.add_right_comm (ps.length * (B * total ps a))
    (b * (total ps o * total ps a))] at sum
  have cut := Naturals.add_left_cancel sum
  rw [Nat.mul_zero, Nat.add_zero] at cut
  exact cut.symm

/-- So the weight is concordant with the amount beyond its discordance exactly where `b` times the
reading's concordance with the amount exceeds `k` times the amount's spread with `b` times the
reading's discordance: read over the rationals, exactly where `b` times the regression of the
reading on the amount exceeds `k`. -/
theorem rises_iff_reading (ps : List α) (w a o : α → Nat) {B b k : Nat}
    (returns : ∀ p, p ∈ ps → w p + k * a p = B + b * o p) :
    discord ps w a < concord ps w a ↔
      k * concord ps a a + b * discord ps o a < b * concord ps o a :=
  lt_iff_of_balance ((Nat.add_assoc _ _ _).symm.trans (returns_balance ps w a o returns))

/-- The spread of an amount over a family listed as groups of equal size is the number of
groups times the groups' own spreads with the spread among them. -/
theorem spread_levels (gs : List (List α)) (a : α → Nat) {m : Nat}
    (equal : ∀ g, g ∈ gs → g.length = m) :
    concord (whole gs) a a = gs.length * concordWithin gs a a + concordAmong gs a a := by
  have h := levels gs a a equal
  have dw : discordWithin gs a a = 0 :=
    total_eq_zero fun g _ => Reproduction.discord_self g a
  have da : discordAmong gs a a = 0 := Reproduction.discord_self gs fun g => total g a
  rw [dw, da, Reproduction.discord_self, Nat.mul_zero, Nat.zero_add, Nat.add_zero,
    Nat.zero_add] at h
  exact h

/-- **Returns kept and shared within the group, within each group.** Where each unit a member
keeps costs it `K`, brings `s` back to it alone and gives `q` to every member of its group, its own
included, summed over the groups: the groups' own concordance with `K` times their own spreads is
their discordance with `s` times those spreads. What is shared within a group comes to its members
alike and selects nothing within it. -/
theorem within_kept {gs : List (List α)} {w a : α → Nat} {B s q K : Nat}
    (returns : ∀ g, g ∈ gs → ∀ p, p ∈ g → w p + K * a p = B + s * a p + q * total g a) :
    concordWithin gs w a + K * concordWithin gs a a =
      discordWithin gs w a + s * concordWithin gs a a :=
  (Naturals.add_congr rfl (total_mul K (fun g => concord g a a) gs).symm).trans
    ((total_add (fun g => concord g w a) (fun g => K * concord g a a) gs).symm.trans
      ((total_congr_on fun g mg =>
          have h := returns_balance g w a a (B := B + q * total g a) (b := s) (k := K)
            fun p mp => (returns g mg p mp).trans (Nat.add_right_comm _ _ _)
          by rw [Reproduction.discord_self, Nat.mul_zero, Nat.add_zero] at h; exact h).trans
        ((total_add (fun g => discord g w a) (fun g => s * concord g a a) gs).trans
          (Naturals.add_congr rfl (total_mul s (fun g => concord g a a) gs)))))

/-- **And among the groups.** Among groups of `m` members each, read by their totals, a group's
offspring with `K` per unit it holds is `m` times the base with `s + m q` per unit, so the groups'
concordance with `K` times the spread among them is their discordance with `s + m q` times it. -/
theorem among_kept {gs : List (List α)} {w a : α → Nat} {B s q K m : Nat}
    (equal : ∀ g, g ∈ gs → g.length = m)
    (returns : ∀ g, g ∈ gs → ∀ p, p ∈ g → w p + K * a p = B + s * a p + q * total g a) :
    concordAmong gs w a + K * concordAmong gs a a =
      discordAmong gs w a + (s + m * q) * concordAmong gs a a := by
  have grouped : ∀ g, g ∈ gs →
      total g w + K * total g a = m * B + (s + m * q) * total g a := fun g mg =>
    (returns_total (o := a) (B := B + q * total g a) (b := s)
        fun p mp => (returns g mg p mp).trans (Nat.add_right_comm _ _ _)).trans (by
      rw [equal g mg, Nat.left_distrib, add_mul_split, mul_assoc_nat m q, Nat.add_assoc,
        Nat.add_comm (m * (q * total g a))])
  have h := returns_balance gs (fun g => total g w) (fun g => total g a) (fun g => total g a)
    grouped
  rw [Reproduction.discord_self, Nat.mul_zero, Nat.add_zero] at h
  exact h

/-- Within a group where each unit a member keeps gives `b` to every other member and costs the
keeper `c` (equivalently, gives `b` to every member, own included, and takes `b + c` from the
keeper): selection within goes against the amount by
`b + c` times the group's spread. Summed over the groups: the groups' own discordance is their
concordance with `b + c` times their own spreads. The case of `within_kept` with nothing kept. -/
theorem within_returns {gs : List (List α)} {w a : α → Nat} {B b c : Nat}
    (returns : ∀ g, g ∈ gs → ∀ p, p ∈ g → w p + (b + c) * a p = B + b * total g a) :
    discordWithin gs w a = concordWithin gs w a + (b + c) * concordWithin gs a a :=
  have h := within_kept (B := B) (s := 0) (q := b) (K := b + c)
    fun g mg p mp => (returns g mg p mp).trans (by rw [Nat.zero_mul, Nat.add_zero])
  by rw [Nat.zero_mul, Nat.add_zero] at h; exact h.symm

/-- So selection within goes against the amount wherever a group varies in it and `b + c` is
not none. -/
theorem within_against {gs : List (List α)} {w a : α → Nat} {B b c : Nat}
    (returns : ∀ g, g ∈ gs → ∀ p, p ∈ g → w p + (b + c) * a p = B + b * total g a)
    (paid : 0 < b + c) (varies : 0 < concordWithin gs a a) :
    concordWithin gs w a < discordWithin gs w a :=
  Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right (Nat.mul_pos paid varies))
    (Nat.le_of_eq (within_returns returns).symm)

/-- Among groups of `m` members each: a group's offspring with `b + c` per unit of its total is
`m` times the base with `m` times `b` per unit, so the groups' concordance, with `b + c` times the
spread among them, is their discordance with `m` times `b` times that spread. The case of
`among_kept` with nothing kept. -/
theorem among_returns {gs : List (List α)} {w a : α → Nat} {B b c m : Nat}
    (equal : ∀ g, g ∈ gs → g.length = m)
    (returns : ∀ g, g ∈ gs → ∀ p, p ∈ g → w p + (b + c) * a p = B + b * total g a) :
    concordAmong gs w a + (b + c) * concordAmong gs a a =
      discordAmong gs w a + m * b * concordAmong gs a a :=
  have h := among_kept equal (B := B) (s := 0) (q := b) (K := b + c)
    fun g mg p mp => (returns g mg p mp).trans (by rw [Nat.zero_mul, Nat.add_zero])
  by rw [Nat.zero_add] at h; exact h

/-- So selection among the groups goes for the amount exactly where `b + c` times the spread among
them falls short of `m` times `b` times it: where the groups differ, exactly where `b` times
`m - 1` exceeds `c`. -/
theorem among_for_iff {gs : List (List α)} {w a : α → Nat} {B b c m : Nat}
    (equal : ∀ g, g ∈ gs → g.length = m)
    (returns : ∀ g, g ∈ gs → ∀ p, p ∈ g → w p + (b + c) * a p = B + b * total g a) :
    discordAmong gs w a < concordAmong gs w a ↔
      (b + c) * concordAmong gs a a < m * b * concordAmong gs a a :=
  lt_iff_of_balance (among_returns equal returns)

/-- **The rule of returns kept and shared within the group**, for groups of equal size `m`: where
each unit a member keeps costs it `K`, brings `s` back to it alone and gives `q` to every member of
its group, its own included, the whole selects for keeping exactly where `K` times the whole's
spread falls short of `s` times it with `m` times `q` times the spread among groups. Read over the
rationals, with the assortment `ρ` the share of the spread among groups, exactly where `K` falls
short of `s + m q ρ`: what comes back to the keeper alone enters at every assortment, what is
shared within the group only through the assortment. -/
theorem rises_iff_kept (gs : List (List α)) (w a : α → Nat) {B s q K m : Nat}
    (equal : ∀ g, g ∈ gs → g.length = m)
    (returns : ∀ g, g ∈ gs → ∀ p, p ∈ g → w p + K * a p = B + s * a p + q * total g a) :
    discord (whole gs) w a < concord (whole gs) w a ↔
      K * concord (whole gs) a a < s * concord (whole gs) a a + m * q * concordAmong gs a a := by
  have h := balance_add (balance_mul gs.length (within_kept returns)) (among_kept equal returns)
  have balance : gs.length * concordWithin gs w a + concordAmong gs w a +
      K * concord (whole gs) a a =
        gs.length * discordWithin gs w a + discordAmong gs w a +
          (s * concord (whole gs) a a + m * q * concordAmong gs a a) := by
    rw [spread_levels gs a equal, Nat.left_distrib K, Nat.left_distrib s,
      mul_turn K gs.length, mul_turn s gs.length, Nat.add_assoc (gs.length * (s * _))]
    rw [add_mul_split s (m * q)] at h
    exact h
  exact (rises_iff gs w a equal).trans (lt_iff_of_balance balance)

/-- The rule of returns to groupmates, for groups of equal size: where each member's offspring
number with `b + c` per unit of its own amount is a base with `b` per unit its group holds, the
whole selects for the amount exactly where `b + c` times the whole's spread falls short of `m`
times `b` times the spread among groups. Read over the rationals, with
the share of the spread among groups `ρ` (the assortment), exactly where `m b ρ` exceeds `b + c`:
with the relatedness `r = (m ρ - 1) / (m - 1)` of a member to its groupmates, where `r` times `b`
times `m - 1` exceeds `c`, Hamilton's rule for returns to groupmates. The case of
`rises_iff_kept` with nothing kept. -/
theorem rises_iff_returns (gs : List (List α)) (w a : α → Nat) {B b c m : Nat}
    (equal : ∀ g, g ∈ gs → g.length = m)
    (returns : ∀ g, g ∈ gs → ∀ p, p ∈ g → w p + (b + c) * a p = B + b * total g a) :
    discord (whole gs) w a < concord (whole gs) w a ↔
      (b + c) * concord (whole gs) a a < m * b * concordAmong gs a a :=
  (rises_iff_kept gs w a (B := B) (s := 0) (q := b) (K := b + c) equal
    fun g mg p mp => (returns g mg p mp).trans (by rw [Nat.zero_mul, Nat.add_zero])).trans
    (by rw [Nat.zero_mul, Nat.zero_add])

/-- Groups uniform in the amount (assortment one, as groups formed by descent from uniform
founders are): where the groups differ, the whole selects for the amount exactly where `b + c`
falls short of `m` times `b`, that is where `b` times `m - 1` exceeds `c`. -/
theorem rises_iff_returns_of_uniform (gs : List (List α)) (w a : α → Nat) {B b c m : Nat}
    (equal : ∀ g, g ∈ gs → g.length = m)
    (returns : ∀ g, g ∈ gs → ∀ p, p ∈ g → w p + (b + c) * a p = B + b * total g a)
    (uniform : ∀ g, g ∈ gs → ∃ v, ∀ p, p ∈ g → a p = v) (differ : 0 < concordAmong gs a a) :
    discord (whole gs) w a < concord (whole gs) w a ↔ b + c < m * b := by
  have h := rises_iff_returns gs w a equal returns
  rw [spread_levels gs a equal, (within_none_of_uniform (w := a) uniform).1, Nat.mul_zero,
    Nat.zero_add, Nat.mul_comm (b + c), Nat.mul_comm (m * b)] at h
  exact h.trans ⟨Naturals.lt_of_mul_lt_mul_left, fun lt => Nat.mul_lt_mul_of_pos_left lt differ⟩

/-- Groups alike in their totals of the amount (assortment none): the whole never selects for it,
whatever the returns. -/
theorem not_rises_of_alike (gs : List (List α)) (w a : α → Nat) {B b c m d : Nat}
    (equal : ∀ g, g ∈ gs → g.length = m)
    (returns : ∀ g, g ∈ gs → ∀ p, p ∈ g → w p + (b + c) * a p = B + b * total g a)
    (alike : ∀ g, g ∈ gs → total g a = d) :
    ¬ discord (whole gs) w a < concord (whole gs) w a := fun rises =>
  have h := (rises_iff_returns gs w a equal returns).mp rises
  Nat.not_lt_zero _ (by
    rw [(among_none_of_alike (w := a) alike).1, Nat.mul_zero] at h
    exact h)

/-- Over listed generations with exact transmission, a generation listed as groups of equal size
whose members' offspring numbers return to groupmates: its mean amount rises across the step
exactly where `b + c` times the generation's spread falls short of `m` times `b` times the spread
among its groups. -/
theorem rises_exact_iff_returns (G : Generations α) {t m B b c : Nat} (gs : List (List α))
    (listed : whole gs = G.family t) (equal : ∀ g, g ∈ gs → g.length = m)
    (returns : ∀ g, g ∈ gs → ∀ p, p ∈ g →
      G.offspringNumber t p + (b + c) * G.amount t p = B + b * total g (G.amount t))
    (exact : Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1))) :
    G.Raises t ↔
      (b + c) * concord (G.family t) (G.amount t) (G.amount t) <
        m * b * concordAmong gs (G.amount t) (G.amount t) :=
  (G.raises_exact_iff exact).trans (by
    unfold Generations.concordAt Generations.discordAt
    rw [← listed]
    exact rises_iff_returns gs _ _ equal returns)

/-! ## Returns in groups of any sizes -/

/-- Two balances sharing their first terms leave a balance of the rest. -/
theorem cancel_two {X Y p q r t : Nat} (one : X + p = Y + q) (two : X + r = Y + t) :
    p + t = q + r :=
  Naturals.add_left_cancel (k := X + Y) ((Nat.add_add_add_comm X Y p t).trans
    ((congrArg (· + (Y + t)) one).trans ((congrArg ((Y + q) + ·) two.symm).trans
      ((Nat.add_add_add_comm Y q X r).trans (congrArg (· + (q + r)) (Nat.add_comm Y X))))))

/-- A combination's balance: where `v` is `s` per unit of the amount with `b` per unit of a
reading `o`, its discordance with the amount, with `s` times the amount's spread and `b` times the
reading's concordance, is its concordance with `b` times the reading's discordance. -/
theorem combination_balance (ps : List α) (a o : α → Nat) (s b : Nat) :
    discord ps (fun p => s * a p + b * o p) a + (s * concord ps a a + b * concord ps o a) =
      concord ps (fun p => s * a p + b * o p) a + b * discord ps o a := by
  have ev := covariation ps (fun p => s * a p + b * o p) a
  have ea := Reproduction.variation ps a
  have eo := covariation ps o a
  have tt : total ps (fun p => s * a p + b * o p) = s * total ps a + b * total ps o :=
    (total_add (fun p => s * a p) (fun p => b * o p) ps).trans
      (Naturals.add_congr (total_mul s a ps) (total_mul b o ps))
  have wt : weighted ps (fun p => s * a p + b * o p) a =
      s * weighted ps a a + b * weighted ps o a :=
    (total_congr (fun p => (add_mul_split (s * a p) (b * o p) (a p)).trans
        (Naturals.add_congr (mul_assoc_nat s (a p) (a p)) (mul_assoc_nat b (o p) (a p)))) ps).trans
      ((total_add (fun p => s * (a p * a p)) (fun p => b * (o p * a p)) ps).trans
        (Naturals.add_congr (total_mul s _ ps) (total_mul b _ ps)))
  rw [tt, wt, Nat.left_distrib, add_mul_split] at ev
  rw [mul_turn ps.length s, mul_turn ps.length b, mul_assoc_nat s, mul_assoc_nat b] at ev
  have sa : s * (ps.length * weighted ps a a) = s * (total ps a * total ps a) + s * concord ps a a :=
    (congrArg (s * ·) ea).trans (Nat.left_distrib _ _ _)
  have bo : b * (ps.length * weighted ps o a) + b * discord ps o a =
      b * (total ps o * total ps a) + b * concord ps o a :=
    (Nat.left_distrib _ _ _).symm.trans ((congrArg (b * ·) eo).trans (Nat.left_distrib _ _ _))
  have two : s * (ps.length * weighted ps a a) + b * (ps.length * weighted ps o a) +
      b * discord ps o a =
        s * (total ps a * total ps a) + b * (total ps o * total ps a) +
          (s * concord ps a a + b * concord ps o a) :=
    (Nat.add_assoc _ _ _).trans ((Naturals.add_congr sa bo).trans
      (Nat.add_add_add_comm _ _ _ _))
  exact cancel_two ev two

/-- **Returns kept, on any list**: where each member's weight with `k` per unit of its own amount is
a base with `s` per unit of the amount and `b` per unit of a reading `o`, the weight's concordance
with the amount, with `k` times its spread and `b` times the reading's discordance with it, is the
weight's discordance with `s` times the spread and `b` times the reading's concordance. -/
theorem kept_balance (ps : List α) (w a o : α → Nat) {B s b k : Nat}
    (returns : ∀ p, p ∈ ps → w p + k * a p = B + s * a p + b * o p) :
    concord ps w a + k * concord ps a a + b * discord ps o a =
      discord ps w a + (s * concord ps a a + b * concord ps o a) := by
  have r := returns_balance ps w a (fun p => s * a p + b * o p) (B := B) (b := 1) (k := k)
    fun p mp => by rw [Nat.one_mul]; exact (returns p mp).trans (Nat.add_assoc _ _ _)
  rw [Nat.one_mul, Nat.one_mul] at r
  exact cancel_two ((Nat.add_comm _ _).trans (r.trans (Nat.add_comm _ _)))
    (combination_balance ps a o s b)


/-- Returns kept and shared within groups of any sizes, within each group by its factor. -/
theorem within_shared_by {gs : List (List α)} {w a : α → Nat} (c R : List α → Nat) {B s q K : Nat}
    (returns : ∀ g, g ∈ gs → ∀ p, p ∈ g → w p + K * a p = B + s * a p + q * R g) :
    concordWithinBy gs c w a + K * concordWithinBy gs c a a =
      discordWithinBy gs c w a + s * concordWithinBy gs c a a := by
  have per : ∀ g, g ∈ gs → c g * concord g w a + K * (c g * concord g a a) =
      c g * discord g w a + s * (c g * concord g a a) := fun g mg => by
    have h := returns_balance g w a a (B := B + q * R g) (b := s) (k := K)
      fun p mp => (returns g mg p mp).trans (Nat.add_right_comm _ _ _)
    rw [Reproduction.discord_self, Nat.mul_zero, Nat.add_zero] at h
    rw [mul_turn K (c g), mul_turn s (c g), ← Nat.left_distrib, ← Nat.left_distrib, h]
  exact (Naturals.add_congr rfl (total_mul K (fun g => c g * concord g a a) gs).symm).trans
    ((total_add (fun g => c g * concord g w a) (fun g => K * (c g * concord g a a)) gs).symm.trans
      ((total_congr_on per).trans
        ((total_add (fun g => c g * discord g w a) (fun g => s * (c g * concord g a a)) gs).trans
          (Naturals.add_congr rfl (total_mul s (fun g => c g * concord g a a) gs)))))

/-- And among the groups' means, read member by member: a group's total by its factor, with `K`
per unit of the same for the amount, is `n` times the base with `s` per unit of it and `n q` per
unit of what the group's reading `R` gives each member. -/
theorem means_shared {gs : List (List α)} {w a : α → Nat} (c R : List α → Nat) {B s q K n : Nat}
    (common : ∀ g, g ∈ gs → g.length * c g = n)
    (returns : ∀ g, g ∈ gs → ∀ p, p ∈ g → w p + K * a p = B + s * a p + q * R g) :
    concordMeans gs c w a + K * concordMeans gs c a a +
        n * q * discord (context gs) R (fun g => c g * total g a) =
      discordMeans gs c w a + (s * concordMeans gs c a a +
        n * q * concord (context gs) R (fun g => c g * total g a)) :=
  kept_balance (context gs) (fun g => c g * total g w) (fun g => c g * total g a) R
    (B := n * B) fun g mg => by
      have mg' := mem_of_mem_context mg
      have t := returns_total (ps := g) (w := w) (o := a) (B := B + q * R g) (b := s)
        (k := K) fun p mp => (returns g mg' p mp).trans (Nat.add_right_comm _ _ _)
      have cl : c g * g.length = n := (Nat.mul_comm _ _).trans (common g mg')
      have e : c g * (total g w + K * total g a) =
          c g * (g.length * (B + q * R g) + s * total g a) := congrArg (c g * ·) t
      rw [Nat.left_distrib (c g) (total g w) (K * total g a),
        Nat.left_distrib (c g) (g.length * (B + q * R g)) (s * total g a),
        mul_turn (c g) K, mul_turn (c g) s, ← mul_assoc_nat (c g) g.length, cl,
        Nat.left_distrib n B (q * R g), ← mul_assoc_nat n q] at e
      exact e.trans (Nat.add_right_comm _ _ _)

/-- **Returns kept and shared within groups of any sizes.** Let `n` be a positive common multiple
of the groups' sizes, each group's factor `n` over its size, and let what each unit a member keeps shares
reach every member of its group as `q` per unit of a reading `R` of the group. Where each unit a
member keeps costs it `K` and brings `s` back to it alone, the whole selects for keeping exactly
where `K` times `n` times the whole's spread, with `q` times the discordance, member by member, of
the reading with the groups' means by their factors (`n` times each mean), falls short of `s` times
`n` times the spread with `q` times their concordance. Read over the rationals, exactly where `K` times the
amount's variance falls short of `s` times it with `q` times the covariance, member by member, of
the reading with the group means. -/
theorem rises_iff_shared_sized (gs : List (List α)) (w a : α → Nat) (c R : List α → Nat)
    {B s q K n : Nat} (common : ∀ g, g ∈ gs → g.length * c g = n) (pos : 0 < n)
    (returns : ∀ g, g ∈ gs → ∀ p, p ∈ g → w p + K * a p = B + s * a p + q * R g) :
    discord (whole gs) w a < concord (whole gs) w a ↔
      K * (n * concord (whole gs) a a) + q * discord (context gs) R (fun g => c g * total g a) <
        s * (n * concord (whole gs) a a) +
          q * concord (context gs) R (fun g => c g * total g a) := by
  have e1 := levels_sized gs w a c common
  have e2 := levels_sized gs a a c common
  have wb := within_shared_by c R returns
  have mk := means_shared c R common returns
  have z1 : discordWithinBy gs c a a = 0 :=
    total_eq_zero fun g _ => by rw [Reproduction.discord_self, Nat.mul_zero]
  have z2 : discordMeans gs c a a = 0 := Reproduction.discord_self _ _
  have z3 : discord (whole gs) a a = 0 := Reproduction.discord_self _ _
  rw [z1, z2, z3, Nat.mul_zero, Nat.mul_zero] at e2
  have e2' : n * n * concord (whole gs) a a =
      n * (whole gs).length * concordWithinBy gs c a a + concordMeans gs c a a :=
    (Nat.add_zero _).symm.trans (e2.trans (Nat.zero_add _))
  have wb' : n * (whole gs).length * concordWithinBy gs c w a +
      K * (n * (whole gs).length * concordWithinBy gs c a a) =
        n * (whole gs).length * discordWithinBy gs c w a +
          s * (n * (whole gs).length * concordWithinBy gs c a a) := by
    have h : n * (whole gs).length * (concordWithinBy gs c w a + K * concordWithinBy gs c a a) =
        n * (whole gs).length * (discordWithinBy gs c w a + s * concordWithinBy gs c a a) :=
      congrArg (n * (whole gs).length * ·) wb
    rw [Nat.left_distrib, Nat.left_distrib, mul_turn (n * (whole gs).length) K,
      mul_turn (n * (whole gs).length) s] at h
    exact h
  have hK : K * (n * n * concord (whole gs) a a) =
      K * (n * (whole gs).length * concordWithinBy gs c a a) + K * concordMeans gs c a a := by
    rw [e2', Nat.left_distrib]
  have hS : s * (n * n * concord (whole gs) a a) =
      s * (n * (whole gs).length * concordWithinBy gs c a a) + s * concordMeans gs c a a := by
    rw [e2', Nat.left_distrib]
  -- the within-group terms cancel, then the means'
  have e3 := cancel_two ((Nat.add_left_comm _ _ _).symm.trans (e1.trans (Nat.add_left_comm _ _ _)))
    wb'.symm
  have eB := cancel_two
    (((Nat.add_assoc _ _ _).trans (Nat.add_left_comm _ _ _)).symm.trans
      (e3.trans ((Nat.add_assoc _ _ _).trans (Nat.add_left_comm _ _ _))))
    (mk.symm.trans (Nat.add_assoc _ _ _))
  have bal : n * n * concord (whole gs) w a +
      (K * (n * n * concord (whole gs) a a) + n * q * discord (context gs) R (fun g => c g * total g a)) =
        n * n * discord (whole gs) w a +
          (s * (n * n * concord (whole gs) a a) + n * q * concord (context gs) R (fun g => c g * total g a)) := by
    rw [hK, hS]
    exact ((Nat.add_assoc _ _ _).trans (congrArg (_ + ·) (Nat.add_assoc _ _ _).symm)).symm.trans
      (eB.trans ((Nat.add_assoc _ _ _).trans (congrArg (_ + ·) (Nat.add_assoc _ _ _).symm)))
  have k1 : K * (n * n * concord (whole gs) a a) = n * (K * (n * concord (whole gs) a a)) := by
    rw [mul_assoc_nat n n, mul_turn K n]
  have s1 : s * (n * n * concord (whole gs) a a) = n * (s * (n * concord (whole gs) a a)) := by
    rw [mul_assoc_nat n n, mul_turn s n]
  rw [k1, s1, mul_assoc_nat n q, mul_assoc_nat n q, ← Nat.left_distrib, ← Nat.left_distrib] at bal
  exact (square_lt_iff pos).symm.trans ((lt_iff_of_balance bal).trans
    ⟨Naturals.lt_of_mul_lt_mul_left, fun lt => Nat.mul_lt_mul_of_pos_left lt pos⟩)

/-- **Each member gaining `q` for every unit its group holds**, groups of any sizes: the reading
is the group's total, so the verdict goes through the covariance, member by member, of each
member's group total with its group's mean (the second term by the group's factor, `n` times the
mean). With equal sizes the total is the size times the mean and the verdict reads as
`rises_iff_kept`'s, in the spread among groups (a reading, not stated as a theorem); with unequal
sizes it is not a function of the whole's spread and the size-weighted spread of the group means
(`Sized.either_verdict`). -/
theorem rises_iff_kept_sized (gs : List (List α)) (w a : α → Nat) (c : List α → Nat)
    {B s q K n : Nat} (common : ∀ g, g ∈ gs → g.length * c g = n) (pos : 0 < n)
    (returns : ∀ g, g ∈ gs → ∀ p, p ∈ g → w p + K * a p = B + s * a p + q * total g a) :
    discord (whole gs) w a < concord (whole gs) w a ↔
      K * (n * concord (whole gs) a a) +
          q * discord (context gs) (fun g => total g a) (fun g => c g * total g a) <
        s * (n * concord (whole gs) a a) +
          q * concord (context gs) (fun g => total g a) (fun g => c g * total g a) :=
  rises_iff_shared_sized gs w a c (fun g => total g a) common pos returns

/-- **What each unit kept gives its group divided among the members**, groups of any sizes: each
member gaining `q` per unit of `n` times its group's mean (the group's total by its factor), the
whole selects for keeping exactly where `K` times `n` times the whole's spread falls short of `s`
times it with `q` times the spread of the groups' means by their factors (`n` times each mean),
member by member. Read over the rationals where the amount varies, with the assortment `ρ` the share of the amount's variance lying among the group means, weighted
by size, and `Q = n q` what each unit kept gives its group, exactly where `K < s + Q ρ`: Hamilton's
rule with what comes back alone added, for groups of any sizes, where what is shared is divided. -/
theorem rises_iff_divided_sized (gs : List (List α)) (w a : α → Nat) (c : List α → Nat)
    {B s q K n : Nat} (common : ∀ g, g ∈ gs → g.length * c g = n) (pos : 0 < n)
    (returns : ∀ g, g ∈ gs → ∀ p, p ∈ g → w p + K * a p = B + s * a p + q * (c g * total g a)) :
    discord (whole gs) w a < concord (whole gs) w a ↔
      K * (n * concord (whole gs) a a) <
        s * (n * concord (whole gs) a a) + q * concordMeans gs c a a := by
  have h := rises_iff_shared_sized gs w a c (fun g => c g * total g a) common pos returns
  have z : discord (context gs) (fun g => c g * total g a) (fun g => c g * total g a) = 0 :=
    Reproduction.discord_self _ _
  rw [z, Nat.mul_zero, Nat.add_zero] at h
  exact h

/-! ## Witnesses -/

/-- Four members: one holding back, its groupmate, and the two members of the other group. -/
inductive Member where
  | held
  | mate
  | first
  | second

open Member

/-- One at the member holding back, none at the others. -/
def holds : Member → Nat
  | held => 1
  | mate => 0
  | first => 0
  | second => 0

/-- The group with the member holding back, and the group without. -/
def groups : List (List Member) := [[held, mate], [first, second]]

theorem equal : ∀ g, g ∈ groups → g.length = 2
  | _, .head _ => rfl
  | _, .tail _ (.head _) => rfl
  | _, .tail _ (.tail _ mem) => nomatch mem

namespace AmongWins

/-- The member holding back leaves two offspring and its groupmate three; the group without it
leaves none. -/
def offspring : Member → Nat
  | held => 2
  | mate => 3
  | first => 0
  | second => 0

/-- Within the groups, holding back is selected against (discordance one, concordance none);
among them, for (concordance five, discordance none); the whole selects for it (concordance four,
discordance one). -/
theorem among_wins :
    concordWithin groups offspring holds = 0 ∧ discordWithin groups offspring holds = 1 ∧
      concordAmong groups offspring holds = 5 ∧ discordAmong groups offspring holds = 0 ∧
      concord (whole groups) offspring holds = 4 ∧ discord (whole groups) offspring holds = 1 ∧
      discord (whole groups) offspring holds < concord (whole groups) offspring holds :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl, by decide⟩

end AmongWins

namespace WithinWins

/-- The member holding back leaves two offspring and its groupmate three; each member of the
group without it leaves three. -/
def offspring : Member → Nat
  | held => 2
  | mate => 3
  | first => 3
  | second => 3

/-- Within the groups, holding back is selected against; among them, against as well (the group
with it leaves five, the group without six); the whole selects against it (concordance none,
discordance three). -/
theorem within_wins :
    concordWithin groups offspring holds = 0 ∧ discordWithin groups offspring holds = 1 ∧
      concordAmong groups offspring holds = 0 ∧ discordAmong groups offspring holds = 1 ∧
      concord (whole groups) offspring holds = 0 ∧ discord (whole groups) offspring holds = 3 :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩

end WithinWins

namespace ByMeans

/-- Groups of unequal size: the member holding back alone, and its three neighbours, one of them
holding back as well. -/
def unequal : List (List Member) := [[held], [mate, first, second]]

/-- One at the two members holding back. -/
def holding : Member → Nat
  | held => 1
  | mate => 1
  | first => 0
  | second => 0

/-- The member alone leaves three offspring, each of the others one. -/
def offspring : Member → Nat
  | held => 3
  | mate => 1
  | first => 1
  | second => 1

/-- The factors: three over one, three over three. -/
def factor (g : List Member) : Nat := 3 / g.length

theorem common : ∀ g, g ∈ unequal → g.length * factor g = 3
  | _, .head _ => rfl
  | _, .tail _ (.head _) => rfl
  | _, .tail _ (.tail _ mem) => nomatch mem

/-- Read by their totals the two groups hold back alike (one each), so nothing is concordant
among them; read by their means (one against a third) they are, and the whole selects for holding
back with nothing selected within the groups: the reading by totals misses selection among groups
of unequal size. -/
theorem by_means :
    concordAmong unequal offspring holding = 0 ∧ discordAmong unequal offspring holding = 0 ∧
      concordWithinBy unequal factor offspring holding = 0 ∧
      discordWithinBy unequal factor offspring holding = 0 ∧
      concordMeans unequal factor offspring holding = 36 ∧
      discordMeans unequal factor offspring holding = 0 ∧
      concord (whole unequal) offspring holding = 4 ∧ discord (whole unequal) offspring holding = 0 :=
  ⟨rfl, rfl, rfl, rfl, rfl, rfl, rfl, rfl⟩

end ByMeans

namespace Founding

/-- Two members keep the amount, two do not. -/
def keeps : Member → Nat
  | held => 1
  | mate => 1
  | first => 0
  | second => 0

/-- Founded by descent: those keeping it together. -/
def assorted : List (List Member) := [[held, mate], [first, second]]

/-- Founded mixed: each keeper with one that does not keep. -/
def mixed : List (List Member) := [[held, first], [mate, second]]

theorem assorted_equal : ∀ g, g ∈ assorted → g.length = 2
  | _, .head _ => rfl
  | _, .tail _ (.head _) => rfl
  | _, .tail _ (.tail _ mem) => nomatch mem

theorem mixed_equal : ∀ g, g ∈ mixed → g.length = 2
  | _, .head _ => rfl
  | _, .tail _ (.head _) => rfl
  | _, .tail _ (.tail _ mem) => nomatch mem

/-- Each unit kept gives two to every other member of its group and takes one from its keeper; the
base is one. With the keepers together, each leaves two offspring and the others one. -/
def assortedOffspring : Member → Nat
  | held => 2
  | mate => 2
  | first => 1
  | second => 1

/-- With the keepers apart, each keeper leaves none and the others three. -/
def mixedOffspring : Member → Nat
  | held => 0
  | mate => 0
  | first => 3
  | second => 3

theorem assorted_returns : ∀ g, g ∈ assorted → ∀ p, p ∈ g →
    assortedOffspring p + (2 + 1) * keeps p = 1 + 2 * total g keeps
  | _, .head _, _, .head _ => rfl
  | _, .head _, _, .tail _ (.head _) => rfl
  | _, .head _, _, .tail _ (.tail _ mem) => nomatch mem
  | _, .tail _ (.head _), _, .head _ => rfl
  | _, .tail _ (.head _), _, .tail _ (.head _) => rfl
  | _, .tail _ (.head _), _, .tail _ (.tail _ mem) => nomatch mem
  | _, .tail _ (.tail _ mem), _, _ => nomatch mem

theorem mixed_returns : ∀ g, g ∈ mixed → ∀ p, p ∈ g →
    mixedOffspring p + (2 + 1) * keeps p = 1 + 2 * total g keeps
  | _, .head _, _, .head _ => rfl
  | _, .head _, _, .tail _ (.head _) => rfl
  | _, .head _, _, .tail _ (.tail _ mem) => nomatch mem
  | _, .tail _ (.head _), _, .head _ => rfl
  | _, .tail _ (.head _), _, .tail _ (.head _) => rfl
  | _, .tail _ (.head _), _, .tail _ (.tail _ mem) => nomatch mem
  | _, .tail _ (.tail _ mem), _, _ => nomatch mem

/-- The same returns, either verdict by how the groups are founded: with the keepers
together (all the spread among groups) the whole selects for keeping, three times the spread
falling short of four times the spread among groups; with them apart (none of it among groups)
it selects against keeping, selection within being all there is. -/
theorem either_verdict :
    discord (whole assorted) assortedOffspring keeps <
        concord (whole assorted) assortedOffspring keeps ∧
      (2 + 1) * concord (whole assorted) keeps keeps = 12 ∧
      2 * 2 * concordAmong assorted keeps keeps = 16 ∧
      concord (whole mixed) mixedOffspring keeps < discord (whole mixed) mixedOffspring keeps ∧
      concordAmong mixed keeps keeps = 0 ∧
      concordWithin mixed mixedOffspring keeps < discordWithin mixed mixedOffspring keeps :=
  ⟨(rises_iff_returns assorted assortedOffspring keeps assorted_equal assorted_returns).mpr
      (by decide), rfl, rfl, by decide, rfl, by decide⟩

end Founding

namespace Partly

/-- Six members in three groups of two: both keep in the first group, one in the second, none in
the third. -/
def groups : List (List Nat) := [[0, 1], [2, 3], [4, 5]]

def keeps : Nat → Nat
  | 0 => 1
  | 1 => 1
  | 2 => 1
  | _ => 0

theorem equal : ∀ g, g ∈ groups → g.length = 2
  | _, .head _ => rfl
  | _, .tail _ (.head _) => rfl
  | _, .tail _ (.tail _ (.head _)) => rfl
  | _, .tail _ (.tail _ (.tail _ mem)) => nomatch mem

/-- Each unit kept gives three to every other member of its group and takes two from its keeper;
the base is two. -/
def offspring : Nat → Nat
  | 0 => 3
  | 1 => 3
  | 2 => 0
  | 3 => 5
  | _ => 2

theorem returns : ∀ g, g ∈ groups → ∀ p, p ∈ g →
    offspring p + (3 + 2) * keeps p = 2 + 3 * total g keeps
  | _, .head _, _, .head _ => rfl
  | _, .head _, _, .tail _ (.head _) => rfl
  | _, .head _, _, .tail _ (.tail _ mem) => nomatch mem
  | _, .tail _ (.head _), _, .head _ => rfl
  | _, .tail _ (.head _), _, .tail _ (.head _) => rfl
  | _, .tail _ (.head _), _, .tail _ (.tail _ mem) => nomatch mem
  | _, .tail _ (.tail _ (.head _)), _, .head _ => rfl
  | _, .tail _ (.tail _ (.head _)), _, .tail _ (.head _) => rfl
  | _, .tail _ (.tail _ (.head _)), _, .tail _ (.tail _ mem) => nomatch mem
  | _, .tail _ (.tail _ (.tail _ mem)), _, _ => nomatch mem

/-- Assortment below one: two thirds of the spread lies among the groups. The returns meet the rule at assortment one (five falls short of six: `b` times `m - 1`, three, exceeds `c`,
two), yet with these groups the whole selects against keeping, five times the spread (fifteen)
exceeding four times the spread among groups (twelve). -/
theorem below_one :
    3 + 2 < 2 * 3 ∧
      3 * concordAmong groups keeps keeps = 2 * concord (whole groups) keeps keeps ∧
      (3 + 2) * concord (whole groups) keeps keeps = 45 ∧
      2 * 3 * concordAmong groups keeps keeps = 36 ∧
      ¬ discord (whole groups) offspring keeps < concord (whole groups) offspring keeps :=
  ⟨by decide, rfl, rfl, rfl, fun rises =>
    absurd ((rises_iff_returns groups offspring keeps equal returns).mp rises) (by decide)⟩

end Partly


namespace Sized

/-- The two keepers together, and each other alone. -/
def together : List (List Member) := [[held, mate], [first], [second]]

/-- Each keeper alone, and the two others together: both listings have groups of unequal size. -/
def apart : List (List Member) := [[held], [mate], [first, second]]

/-- The factors: two over each group's size. -/
def factor (g : List Member) : Nat := 2 / g.length

theorem together_common : ∀ g, g ∈ together → g.length * factor g = 2
  | _, .head _ => rfl
  | _, .tail _ (.head _) => rfl
  | _, .tail _ (.tail _ (.head _)) => rfl
  | _, .tail _ (.tail _ (.tail _ mem)) => nomatch mem

theorem apart_common : ∀ g, g ∈ apart → g.length * factor g = 2
  | _, .head _ => rfl
  | _, .tail _ (.head _) => rfl
  | _, .tail _ (.tail _ (.head _)) => rfl
  | _, .tail _ (.tail _ (.tail _ mem)) => nomatch mem

/-- Each unit kept gives two to every other member of its group and takes one from its keeper
(`K = 3`, `q = 2`, nothing coming back to the keeper alone), the base four: with the keepers
together, each leaves five and the others four. -/
def togetherOffspring : Member → Nat
  | held => 5
  | mate => 5
  | first => 4
  | second => 4

/-- With each keeper alone, each leaves three and the others four. -/
def apartOffspring : Member → Nat
  | held => 3
  | mate => 3
  | first => 4
  | second => 4

theorem together_returns : ∀ g, g ∈ together → ∀ p, p ∈ g →
    togetherOffspring p + 3 * Founding.keeps p =
      4 + 0 * Founding.keeps p + 2 * total g Founding.keeps
  | _, .head _, _, .head _ => rfl
  | _, .head _, _, .tail _ (.head _) => rfl
  | _, .head _, _, .tail _ (.tail _ mem) => nomatch mem
  | _, .tail _ (.head _), _, .head _ => rfl
  | _, .tail _ (.head _), _, .tail _ mem => nomatch mem
  | _, .tail _ (.tail _ (.head _)), _, .head _ => rfl
  | _, .tail _ (.tail _ (.head _)), _, .tail _ mem => nomatch mem
  | _, .tail _ (.tail _ (.tail _ mem)), _, _ => nomatch mem

theorem apart_returns : ∀ g, g ∈ apart → ∀ p, p ∈ g →
    apartOffspring p + 3 * Founding.keeps p = 4 + 0 * Founding.keeps p + 2 * total g Founding.keeps
  | _, .head _, _, .head _ => rfl
  | _, .head _, _, .tail _ mem => nomatch mem
  | _, .tail _ (.head _), _, .head _ => rfl
  | _, .tail _ (.head _), _, .tail _ mem => nomatch mem
  | _, .tail _ (.tail _ (.head _)), _, .head _ => rfl
  | _, .tail _ (.tail _ (.head _)), _, .tail _ (.head _) => rfl
  | _, .tail _ (.tail _ (.head _)), _, .tail _ (.tail _ mem) => nomatch mem
  | _, .tail _ (.tail _ (.tail _ mem)), _, _ => nomatch mem

/-- The same members, the same returns, the same spread of keeping over the whole and the same
size-weighted spread of the group means (all of the spread lying among the means in both), and
either verdict: with the keepers together a member's group total goes with its group's mean twice
as steeply as with each keeper alone, and the whole selects for keeping in the first listing and
against it in the second. So with groups of unequal size the verdict is not a function of the
whole's spread and the size-weighted spread of the group means. -/
theorem either_verdict :
    discord (whole together) togetherOffspring Founding.keeps <
        concord (whole together) togetherOffspring Founding.keeps ∧
      concord (whole apart) apartOffspring Founding.keeps <
        discord (whole apart) apartOffspring Founding.keeps ∧
      concord (whole together) Founding.keeps Founding.keeps = 4 ∧
      concord (whole apart) Founding.keeps Founding.keeps = 4 ∧
      concordMeans together factor Founding.keeps Founding.keeps = 16 ∧
      concordMeans apart factor Founding.keeps Founding.keeps = 16 ∧
      concord (context together) (fun g => total g Founding.keeps)
        (fun g => factor g * total g Founding.keeps) = 16 ∧
      concord (context apart) (fun g => total g Founding.keeps)
        (fun g => factor g * total g Founding.keeps) = 8 :=
  ⟨(rises_iff_kept_sized together togetherOffspring Founding.keeps factor together_common
      (by decide) together_returns).mpr (by decide),
    by decide, rfl, rfl, rfl, rfl, rfl, rfl⟩

/-- Where what each unit kept gives its group is divided among the members instead, the two
listings give one verdict, whatever the offspring numbers meeting the same returns: the verdict
goes through the spread of the groups' means, and that spread is the same. -/
theorem divided_one_verdict {w w' : Member → Nat} {B s q K : Nat}
    (on_together : ∀ g, g ∈ together → ∀ p, p ∈ g → w p + K * Founding.keeps p =
      B + s * Founding.keeps p + q * (factor g * total g Founding.keeps))
    (on_apart : ∀ g, g ∈ apart → ∀ p, p ∈ g → w' p + K * Founding.keeps p =
      B + s * Founding.keeps p + q * (factor g * total g Founding.keeps)) :
    discord (whole together) w Founding.keeps < concord (whole together) w Founding.keeps ↔
      discord (whole apart) w' Founding.keeps < concord (whole apart) w' Founding.keeps := by
  have one := rises_iff_divided_sized together w Founding.keeps factor together_common
    (by decide) on_together
  have two := rises_iff_divided_sized apart w' Founding.keeps factor apart_common
    (by decide) on_apart
  have st : concord (whole together) Founding.keeps Founding.keeps = 4 := rfl
  have sa : concord (whole apart) Founding.keeps Founding.keeps = 4 := rfl
  have mt : concordMeans together factor Founding.keeps Founding.keeps = 16 := rfl
  have ma : concordMeans apart factor Founding.keeps Founding.keeps = 16 := rfl
  rw [st, mt] at one
  rw [sa, ma] at two
  exact one.trans two.symm

end Sized

end SelectionLevels

end Becoming
