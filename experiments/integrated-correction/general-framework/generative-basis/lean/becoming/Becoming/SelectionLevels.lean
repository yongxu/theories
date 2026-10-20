import Becoming.SelectionTerm

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
* **Witnesses.** Two groups of two, the amount one at a member that holds back and none at the
  others. In both, the one holding back leaves fewer offspring than its groupmate, so selection
  within goes against holding back. Where the group without it leaves no offspring, selection
  among groups goes for holding back and outweighs it: the whole selects for it (`AmongWins`).
  Where the group without it leaves as many as its members can, selection among groups goes
  against holding back as well, and the whole selects against it (`WithinWins`). With a member
  holding back alone beside a group of three, one of them holding back, the two groups' totals of
  holding back are alike, so the reading by totals sees nothing among them; their means differ
  (one against a third), and the whole's selection for holding back is all among the means
  (`ByMeans`).

The weights are any natural numbers; with offspring numbers they are the selection term proper
of `Becoming.SelectionTerm` divided by level. Nothing is supposed about what the groups are or
why their members' offspring numbers differ: which level wins is read off the counts, not
explained. Modelling choices: natural-number weights and amounts, finite families as lists,
a common multiple of the groups' sizes in place of rational means, and for lineages exact
transmission at every step. No ethical predicate, ranking or axiom
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

/-- Totals agreeing at every member agree. -/
theorem total_eq_of_mem {p q : α → Nat} : ∀ {as : List α}, (∀ a, a ∈ as → p a = q a) →
    total as p = total as q
  | [], _ => rfl
  | a :: _, same => Naturals.add_congr (same a (.head _))
      (total_eq_of_mem fun b mem => same b (.tail a mem))

/-- With groups of `m` members each, the family has `k` times `m`. -/
theorem whole_length_of_equal {gs : List (List α)} {m : Nat} (equal : ∀ g, g ∈ gs → g.length = m) :
    (whole gs).length = gs.length * m :=
  (whole_length gs).trans ((total_eq_of_mem equal).trans (total_const m gs))

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
  Naturals.add_right_cancel (k := q + (s + p)) ((shuffle_left c dw d' q s p).trans
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
      ((total_eq_of_mem fun g mg =>
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
      (context_total _ gs).trans ((total_eq_of_mem fun g mg =>
        ((congrArg (g.length * ·) (square_split (c g) (total g w) (total g a))).trans
          ((mul_assoc_nat _ _ _).symm.trans ((congrArg (· * (total g w * total g a))
            ((mul_assoc_nat _ _ _).symm.trans (congrArg (· * c g) (common g mg)))).trans
            (mul_assoc_nat _ _ _))))).trans (total_mul n _ gs))
    have tw : ∀ q : α → Nat, total (context gs) (fun g => c g * total g q) =
        n * total gs fun g => total g q := fun q =>
      (context_total _ gs).trans ((total_eq_of_mem fun g mg =>
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
  (total_congr (fun x => (context_total (F x) gs).trans ((total_eq_of_mem fun h mh =>
      congrArg (· * F x h) (equal h mh)).trans (total_mul m _ gs))) (context gs)).trans
    ((context_total _ gs).trans ((total_eq_of_mem fun g mg =>
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

/-- An empty group adds nothing and has no members. -/
theorem nil_of_length_zero : ∀ {g : List α}, g.length = 0 → g = []
  | [], _ => rfl
  | _ :: _, len => Nat.noConfusion len

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
    have cw : concordWithin gs w a = 0 := total_zero_of fun g mg => (within g mg).1
    have dw : discordWithin gs w a = 0 := total_zero_of fun g mg => (within g mg).2
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
  ⟨lt_of_mul_lt_mul, fun lt => Nat.mul_lt_mul_of_pos_left lt (Nat.mul_pos pos pos)⟩

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
  exact h.trans ⟨lt_of_mul_lt_mul, fun lt => Nat.mul_lt_mul_of_pos_left lt pos⟩

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
  lt_of_mul_lt_mul (m := gs.length) (Nat.lt_of_add_lt_add_right (Nat.lt_of_le_of_lt
    (Nat.add_le_add_left against _) ((rises_iff gs w a equal).mp rises)))

/-- Where every group is uniform in amount, nothing is selected within the groups. -/
theorem within_none_of_uniform {gs : List (List α)} {w a : α → Nat}
    (uniform : ∀ g, g ∈ gs → ∃ c, ∀ p, p ∈ g → a p = c) :
    concordWithin gs w a = 0 ∧ discordWithin gs w a = 0 :=
  ⟨total_zero_of fun g mg => match uniform g mg with
      | ⟨_, same⟩ => concord_alike same w,
    total_zero_of fun g mg => match uniform g mg with
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
  ⟨total_zero_of fun g mg => match uniform g mg with
      | ⟨_, same⟩ => (congrArg (c g * ·) (concord_alike same w)).trans (Nat.mul_zero _),
    total_zero_of fun g mg => match uniform g mg with
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
  (total_eq_of_mem (lineage_keeps G within exact founded t)).trans (total_const v _)

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

end SelectionLevels

end Becoming
