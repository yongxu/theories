import Becoming.SelectionLevels
import Becoming.Continuation

/-!
# Group ending: selection among groups through conditions of their own

`Becoming.SelectionLevels` divided the selection term proper of a family listed as groups into
selection within the groups and selection among them, and read off the counts which level wins.
This module states when the among-group part goes one way on the base: where a group with less of
an amount than another leaves no offspring. That happens where a group's members depend on a
condition of their own that ran into joint excess under gated renewal (`Flow.joint_excess_ends`):
they are no longer active, and where only active formations give, a formation that is not active
leaves no descendant.

* **Ending decides the among-group part.** Where every group with less of the amount than another
  group leaves no offspring (`Ended`), nothing is discordant among the groups
  (`among_not_against`). So the whole selects for the amount exactly where `k` times the
  within-group discordance is below `k` times the within-group concordance with the concordance
  among groups (`rises_iff_ended`): what is left against the amount is selection within the
  groups that go on. With groups uniform in the amount, nothing is selected within them, so the
  whole never selects against it (`not_against_of_ended`), and selects for it wherever a group
  with more of it leaves offspring beside one with less (`rises_of_ended`). For groups of any
  sizes, where every group with a lower mean leaves no offspring (`EndedBy`), nothing is
  discordant among the groups' means (`means_not_against`), and the sized division of
  `SelectionLevels.levels_sized` has no among-group part against the amount
  (`rises_iff_ended_sized`).
* **On the base.** Where only active formations give, a formation not active at a step leaves no
  descendant across it (`Flow.inactive_childless`). A member depending, at a need of at least `m`,
  on a condition whose gated renewal ran into joint excess (as in `Flow.joint_excess_ends`) is not
  active from then on, where activity needs support, and leaves no descendant
  (`Flow.excess_childless`). Over generations of descent (`SelectionTerm.Flow.Descended`), every
  member of a group whose members are not active has offspring number nothing, so the group
  leaves no offspring (`Flow.group_childless`); where every group with less of the amount is such
  a group, `Ended` holds (`Flow.ended_of_inactive`).
* **Over generations.** With exact transmission and groups uniform in the amount, where the groups
  with less of it are not active and a group with more of it leaves offspring beside one with
  less, the mean amount rises across the step (`Flow.raises_of_inactive`). With groups not
  uniform, it rises exactly where `k` times the within-group discordance is below `k` times the
  within-group concordance with the concordance among groups (`Flow.rises_iff_inactive`). For
  groups of any sizes, where the groups with a lower mean are not active (`Flow.endedBy_of_inactive`),
  the same holds with the sized terms (`Flow.rises_iff_inactive_sized`).
* **A condition shared by every group.** Where every member of a generation is not active (every
  group depending on one condition that ran into joint excess), the next generation is empty
  (`Flow.all_end`): one shared condition gives no selection among the groups that keeps it; every
  group ends with it.
* **Conditions coupled into one family.** A group's condition need not be its own or shared: a
  neighbour can renew it while drawing on a condition of its own. Where the renewal of a family
  of conditions is gated on the family read as one (whatever gives to a member depends on some
  member at a need of at least `m`) and the family's uptake exceeded its replenishment as in
  `Flow.family_excess_ends`, a member depending on any condition of the family leaves no
  descendant from then on (`Flow.family_childless`; `Flow.excess_childless` is the family of
  one condition). Groups whose members depend on conditions of one such family end together:
  each leaves no offspring and nothing is selected among them (`Flow.coupled_end_together`).
  So ending selects among groups only between families: where the groups with less of an
  amount depend on a family that ran into excess, they leave nothing (`Flow.ended_of_family`).
* **Groups formed by descent.** Read a generation by groups each founded at a value of the
  amount, and each later generation by their lineages (`SelectionLevels.lineages`), with exact
  transmission. Where at a step every lineage founded lower than another has its members not
  active, a member with less of the amount than another belongs to a lower lineage and leaves
  nothing, so nothing is discordant across the step (`Flow.lineages_none_against`). Where this
  holds at every step before `T`, the mean at `T` is not below where it started
  (`Flow.lineages_not_lower`), and it rises across a step wherever a lineage founded higher leaves
  offspring beside a lower lineage that has members (`Flow.lineages_raises`). Lineages keep what
  ending selected among them; the groups of `Exhausted`, formed across lineages, did not.
* **Witnesses.** Two groups of two: one keeping, holding back from its condition, and one whose
  condition ended, its members leaving no offspring. In the keeping group the member holding back
  leaves one offspring and its groupmate two, so within the group selection goes against holding
  back; among the groups it goes for it and outweighs (`Outweighed`). With the groupmate leaving
  five, selection within outweighs and the whole goes against holding back although the other
  group ended (`Outweighs`). Over two generations (`Exhausted`): two keeping groups and a group
  leaving nothing; at the first step selection among groups goes for holding back and the mean
  rises; the offspring of each keeping group, forming the next groups, are alike in holding back,
  so at the next step nothing is selected among them, selection within goes against it, and the
  mean falls below where it started. Selection among groups by ending uses up the differences
  among groups it acts on where the next groups are formed across them. With the groups formed by
  descent instead (`Assorted`): a group holding back and one not, whose members leave nothing; the
  mean rises from a half to one, the lineage holding back is all that is left, nothing is
  selected within it, and the mean stays at one, above where it started, although holding back
  leaves fewer offspring than not holding back would.

The amount is any reading; which group's condition, or which family of conditions, runs into
joint excess, and why, is a hypothesis wherever it enters, as is which conditions the groups'
members depend on.
Modelling choices: natural-number weights, amounts and levels, discrete steps, finite families as
lists, groups of equal size or, for the sized laws, a common multiple of the sizes. No ethical predicate, ranking or axiom occurs; every declaration has
an empty axiom report.
-/

namespace Becoming

namespace GroupEnding

open SelectionTerm SelectionLevels

variable {α : Type}

/-! ## Ending decides the among-group part -/

/-- Every group with less of the amount than another group leaves no offspring. -/
def Ended (gs : List (List α)) (w a : α → Nat) : Prop :=
  ∀ g h, g ∈ gs → h ∈ gs → total h a < total g a → total h w = 0

/-- Where a number is below another, the other exceeds it by something. -/
theorem excess_pos_of_lt {x y : Nat} (lt : y < x) : 0 < excess x y :=
  match le_dest lt with
  | ⟨d, eq⟩ => eq ▸ Nat.lt_of_lt_of_le (Nat.succ_pos d)
      (Nat.le_of_eq ((congrArg (excess · y) (Nat.succ_add y d)).trans (excess_add_left y (d + 1))).symm)

/-- Where the groups with less of the amount leave nothing, nothing is discordant among the
groups. -/
theorem among_not_against {gs : List (List α)} {w a : α → Nat} (ended : Ended gs w a) :
    discordAmong gs w a = 0 :=
  discord_zero_of_below fun h g mh mg less =>
    Nat.le_trans (Nat.le_of_eq (ended g h mg mh less)) (Nat.zero_le _)

/-- So the whole selects for the amount exactly where `k` times the within-group discordance is
below `k` times the within-group concordance with the concordance among groups. -/
theorem rises_iff_ended (gs : List (List α)) (w a : α → Nat) {m : Nat}
    (equal : ∀ g, g ∈ gs → g.length = m) (ended : Ended gs w a) :
    discord (whole gs) w a < concord (whole gs) w a ↔
      gs.length * discordWithin gs w a < gs.length * concordWithin gs w a + concordAmong gs w a := by
  have h := rises_iff gs w a equal
  rw [among_not_against ended, Nat.add_zero] at h
  exact h

/-- With groups uniform in the amount and the groups with less of it leaving nothing, the whole
never selects against it. -/
theorem not_against_of_ended (gs : List (List α)) (w a : α → Nat) {m : Nat}
    (equal : ∀ g, g ∈ gs → g.length = m) (uniform : ∀ g, g ∈ gs → ∃ c, ∀ p, p ∈ g → a p = c)
    (ended : Ended gs w a) :
    discord (whole gs) w a ≤ concord (whole gs) w a := by
  have h := levels_of_uniform gs w a equal uniform
  rw [among_not_against ended, Nat.add_zero] at h
  exact Nat.le_trans (Nat.le_add_right _ _) (Nat.le_of_eq h.symm)

/-- A positive term at one ordered pair of members makes the total over ordered pairs positive. -/
theorem pairs_pos {ps : List α} {F : α → α → Nat} {p q : α} (mp : p ∈ ps) (mq : q ∈ ps)
    (pos : 0 < F p q) : 0 < total ps fun p' => total ps (F p') :=
  total_pos_of_mem (q := fun p' => total ps (F p')) mp (total_pos_of_mem mq pos)

/-- And selects for it wherever a group with more of it leaves offspring beside one with less. -/
theorem rises_of_ended (gs : List (List α)) (w a : α → Nat) {m : Nat}
    (equal : ∀ g, g ∈ gs → g.length = m) (uniform : ∀ g, g ∈ gs → ∃ c, ∀ p, p ∈ g → a p = c)
    (ended : Ended gs w a) {g h : List α} (mg : g ∈ gs) (mh : h ∈ gs)
    (less : total h a < total g a) (leaves : 0 < total g w) :
    discord (whole gs) w a < concord (whole gs) w a := by
  have among : 0 < concordAmong gs w a :=
    pairs_pos (F := fun g' h' => excess (total g' w) (total h' w) * excess (total g' a) (total h' a))
      mg mh (Nat.mul_pos (excess_pos_of_lt (Nat.lt_of_lt_of_le (Nat.lt_of_le_of_lt
          (Nat.le_of_eq (ended g h mg mh less)) leaves) (Nat.le_refl _)))
        (excess_pos_of_lt less))
  have lv := levels_of_uniform gs w a equal uniform
  rw [among_not_against ended, Nat.add_zero] at lv
  exact Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right among) (Nat.le_of_eq lv.symm)

/-! ## Groups of any sizes -/

/-- Every group with a lower mean of the amount than another leaves no offspring: groups of any
sizes, each read by its factor (`n` over its size, `n` a common multiple of the sizes). -/
def EndedBy (gs : List (List α)) (c : List α → Nat) (w a : α → Nat) : Prop :=
  ∀ g h, g ∈ gs → h ∈ gs → c h * total h a < c g * total g a → total h w = 0

/-- Where the groups with a lower mean leave nothing, nothing is discordant among the groups'
means. -/
theorem means_not_against {gs : List (List α)} {c : List α → Nat} {w a : α → Nat}
    (ended : EndedBy gs c w a) : discordMeans gs c w a = 0 :=
  discord_zero_of_below fun x y mx my less =>
    Nat.le_trans (Nat.le_of_eq ((congrArg (c x * ·)
      (ended y x (mem_of_mem_context my) (mem_of_mem_context mx) less)).trans (Nat.mul_zero _)))
      (Nat.zero_le _)

/-- So, for groups of any sizes, the whole selects for the amount exactly where `n` times the
whole's size times the groups' own discordances, each by its factor, is below the same for the
concordances with the concordance of the groups' means. -/
theorem rises_iff_ended_sized (gs : List (List α)) (w a : α → Nat) (c : List α → Nat) {n : Nat}
    (common : ∀ g, g ∈ gs → g.length * c g = n) (pos : 0 < n) (ended : EndedBy gs c w a) :
    discord (whole gs) w a < concord (whole gs) w a ↔
      n * (whole gs).length * discordWithinBy gs c w a <
        n * (whole gs).length * concordWithinBy gs c w a + concordMeans gs c w a := by
  have h := rises_iff_sized gs w a c common pos
  rw [means_not_against ended, Nat.add_zero] at h
  exact h

/-- A member of a group is a member of the family listed by groups. -/
theorem mem_whole : ∀ {gs : List (List α)} {h : List α} {p : α}, h ∈ gs → p ∈ h → p ∈ whole gs
  | _ :: gs, _, _, .head _, mp => List.mem_append_left (whole gs) mp
  | g :: _, _, _, .tail _ mh, mp => List.mem_append_right g (mem_whole mh mp)

/-! ## On the base -/

namespace Flow

variable {X : Type} {L : Flow X X} {W : Web X X}

/-- Where only active formations give, a formation not active at a step leaves no descendant
across it. -/
theorem inactive_childless (acting : L.Acting W) {t : Nat} {g : X} (inactive : ¬ W.active t g)
    (x : X) : ¬ L.DescendsAt W t x g :=
  fun descends => inactive (acting t g x descends.1 descends.2.1)

/-- A member depending, at a need of at least `m`, on some condition of a family whose renewal is
gated on the family as one (whatever gives to a member depends on some member at a need of at
least `m`), where the family's uptake exceeded its replenishment over `n` steps from `T` starting
from a stock below `n + m`, leaves no descendant at any step from `T + n` on: it is not active
there (`Flow.family_excess_ends`). -/
theorem family_childless (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {ds : List X} {m : Nat}
    (gated : ∀ t f, f ∈ L.present t → ∀ d, d ∈ ds → 0 < L.give t f d →
      ∃ e, e ∈ ds ∧ W.requires t f e ∧ m ≤ W.need t f e)
    {T n : Nat} (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (start : W.stock ds T < n + m) (k : Nat) {g e : X} (inside : e ∈ ds)
    (depends : W.requires (T + n + k) g e) (high : m ≤ W.need (T + n + k) g e) (x : X) :
    ¬ L.DescendsAt W (T + n + k) x g :=
  inactive_childless acting
    (Becoming.Flow.family_excess_ends balances acting dependent gated excess start k g e inside
      depends high) x

/-- A member depending, at a need of at least `m`, on a condition whose gated renewal ran into
`n` steps of joint excess from `T` starting below `n + m`, leaves no descendant at any step from
`T + n` on: the family of one condition. -/
theorem excess_childless (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {c : X} {m : Nat}
    (gated : ∀ t f, f ∈ L.present t → 0 < L.give t f c →
      W.requires t f c ∧ m ≤ W.need t f c)
    {T n : Nat} (excess : ∀ k, k < n → L.given (T + k) c < L.taken (T + k) c)
    (start : W.level T c < n + m) (k : Nat) {g : X}
    (depends : W.requires (T + n + k) g c) (high : m ≤ W.need (T + n + k) g c) (x : X) :
    ¬ L.DescendsAt W (T + n + k) x g :=
  family_childless (ds := [c]) balances acting dependent
    (fun t f present => Becoming.Flow.gate_single (gated t f present)) excess start k (.head [])
    depends high x

/-- Over generations of descent, a member not active at a step has offspring number nothing. -/
theorem offspring_zero (acting : L.Acting W) {G : Generations X}
    (descended : SelectionTerm.Flow.Descended L W G) {t : Nat} {p : X} (mp : p ∈ G.family t)
    (inactive : ¬ W.active t p) : G.offspringNumber t p = 0 :=
  match h : G.kids t p with
  | [] => congrArg List.length h
  | k :: _ => absurd (descended t p k mp (h ▸ .head _)) (inactive_childless acting inactive k)

/-- So a group of a generation whose members are not active leaves no offspring. -/
theorem group_childless (acting : L.Acting W) {G : Generations X}
    (descended : SelectionTerm.Flow.Descended L W G) {t : Nat} {h : List X}
    (within : ∀ p, p ∈ h → p ∈ G.family t) (inactive : ∀ p, p ∈ h → ¬ W.active t p) :
    total h (G.offspringNumber t) = 0 :=
  total_zero_of fun p mp => offspring_zero acting descended (within p mp) (inactive p mp)

/-- Where every group with less of the amount than another has its members not active, the
groups with less leave nothing. -/
theorem ended_of_inactive (acting : L.Acting W) {G : Generations X}
    (descended : SelectionTerm.Flow.Descended L W G) {t : Nat} {gs : List (List X)}
    (listed : whole gs = G.family t) {a : X → Nat}
    (inactive : ∀ g h, g ∈ gs → h ∈ gs → total h a < total g a → ∀ p, p ∈ h → ¬ W.active t p) :
    Ended gs (G.offspringNumber t) a :=
  fun g h mg mh less => group_childless acting descended
    (fun _ mp => listed ▸ mem_whole mh mp) (inactive g h mg mh less)

/-- Over generations of descent with exact transmission and groups uniform in the amount, where
the groups with less of it are not active and a group with more of it leaves offspring beside
one with less, the mean amount rises across the step. -/
theorem raises_of_inactive (acting : L.Acting W) {G : Generations X}
    (descended : SelectionTerm.Flow.Descended L W G) {t m : Nat} (gs : List (List X))
    (listed : whole gs = G.family t) (equal : ∀ g, g ∈ gs → g.length = m)
    (uniform : ∀ g, g ∈ gs → ∃ c, ∀ p, p ∈ g → G.amount t p = c)
    (exact : Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (inactive : ∀ g h, g ∈ gs → h ∈ gs → total h (G.amount t) < total g (G.amount t) →
      ∀ p, p ∈ h → ¬ W.active t p)
    {g h : List X} (mg : g ∈ gs) (mh : h ∈ gs) (less : total h (G.amount t) < total g (G.amount t))
    (leaves : 0 < total g (G.offspringNumber t)) : G.Raises t :=
  (G.raises_exact_iff exact).mpr (by
    unfold Generations.concordAt Generations.discordAt
    rw [← listed]
    exact rises_of_ended gs _ _ equal uniform (ended_of_inactive acting descended listed inactive)
      mg mh less leaves)

/-- Over generations of descent with exact transmission, where the groups with less of the
amount are not active, the mean amount rises across the step exactly where `k` times the
within-group discordance is below `k` times the within-group concordance with the concordance
among groups: the groups need not be uniform, so selection within the groups that go on can
outweigh what ending does among them. -/
theorem rises_iff_inactive (acting : L.Acting W) {G : Generations X}
    (descended : SelectionTerm.Flow.Descended L W G) {t m : Nat} (gs : List (List X))
    (listed : whole gs = G.family t) (equal : ∀ g, g ∈ gs → g.length = m)
    (exact : Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (inactive : ∀ g h, g ∈ gs → h ∈ gs → total h (G.amount t) < total g (G.amount t) →
      ∀ p, p ∈ h → ¬ W.active t p) :
    G.Raises t ↔
      gs.length * discordWithin gs (G.offspringNumber t) (G.amount t) <
        gs.length * concordWithin gs (G.offspringNumber t) (G.amount t) +
          concordAmong gs (G.offspringNumber t) (G.amount t) := by
  have h := rises_exact_iff_levels G gs listed equal exact
  rw [among_not_against (ended_of_inactive acting descended listed inactive), Nat.add_zero] at h
  exact h

/-- For groups of any sizes: where every group with a lower mean of the amount than another has
its members not active, the groups with a lower mean leave nothing. -/
theorem endedBy_of_inactive (acting : L.Acting W) {G : Generations X}
    (descended : SelectionTerm.Flow.Descended L W G) {t : Nat} {gs : List (List X)}
    (listed : whole gs = G.family t) {c : List X → Nat} {a : X → Nat}
    (inactive : ∀ g h, g ∈ gs → h ∈ gs → c h * total h a < c g * total g a →
      ∀ p, p ∈ h → ¬ W.active t p) :
    EndedBy gs c (G.offspringNumber t) a :=
  fun g h mg mh less => group_childless acting descended
    (fun _ mp => listed ▸ mem_whole mh mp) (inactive g h mg mh less)

/-- Over generations of descent with exact transmission, a generation listed as groups of any
sizes: where the groups with a lower mean of the amount are not active, the mean rises across the
step exactly where `n` times the generation's size times the groups' own discordances, each by its
factor, is below the same for the concordances with the concordance of the groups' means. -/
theorem rises_iff_inactive_sized (acting : L.Acting W) {G : Generations X}
    (descended : SelectionTerm.Flow.Descended L W G) {t n : Nat} (gs : List (List X))
    (c : List X → Nat) (listed : whole gs = G.family t) (common : ∀ g, g ∈ gs → g.length * c g = n)
    (pos : 0 < n) (exact : Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    (inactive : ∀ g h, g ∈ gs → h ∈ gs → c h * total h (G.amount t) < c g * total g (G.amount t) →
      ∀ p, p ∈ h → ¬ W.active t p) :
    G.Raises t ↔
      n * (whole gs).length * discordWithinBy gs c (G.offspringNumber t) (G.amount t) <
        n * (whole gs).length * concordWithinBy gs c (G.offspringNumber t) (G.amount t) +
          concordMeans gs c (G.offspringNumber t) (G.amount t) := by
  have h := rises_exact_iff_sized G gs c listed common pos exact
  rw [means_not_against (endedBy_of_inactive acting descended listed inactive), Nat.add_zero] at h
  exact h

/-- Groups whose conditions are coupled end together: where every member of every group depends,
at a need of at least `m`, on some condition of one family whose renewal is gated on the family
as one and whose uptake exceeded its replenishment over `n` steps from `T` starting from a stock
below `n + m`, then at every generation of descent from `T + n` on each group leaves no
offspring, and nothing is selected among the groups, for any amount. The members need not share
a condition: depending on conditions of one coupled family is enough. -/
theorem coupled_end_together (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {ds : List X} {m : Nat}
    (gated : ∀ t f, f ∈ L.present t → ∀ d, d ∈ ds → 0 < L.give t f d →
      ∃ e, e ∈ ds ∧ W.requires t f e ∧ m ≤ W.need t f e)
    {T n : Nat} (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (start : W.stock ds T < n + m) (k : Nat) {G : Generations X}
    (descended : SelectionTerm.Flow.Descended L W G) {gs : List (List X)}
    (within : ∀ h p, h ∈ gs → p ∈ h → p ∈ G.family (T + n + k))
    (coupled : ∀ h p, h ∈ gs → p ∈ h →
      ∃ e, e ∈ ds ∧ W.requires (T + n + k) p e ∧ m ≤ W.need (T + n + k) p e)
    (a : X → Nat) :
    (∀ h, h ∈ gs → total h (G.offspringNumber (T + n + k)) = 0) ∧
      concordAmong gs (G.offspringNumber (T + n + k)) a = 0 ∧
      discordAmong gs (G.offspringNumber (T + n + k)) a = 0 :=
  have ends : ∀ h, h ∈ gs → total h (G.offspringNumber (T + n + k)) = 0 := fun h mh =>
    group_childless acting descended (fun p mp => within h p mh mp) fun p mp => match coupled h p mh mp with
      | ⟨e, inside, depends, high⟩ =>
        Becoming.Flow.family_excess_ends balances acting dependent gated excess start k p e inside
          depends high
  ⟨ends, concord_uniform (w := fun h => total h (G.offspringNumber (T + n + k))) ends
      (fun h => total h a),
    discord_uniform (w := fun h => total h (G.offspringNumber (T + n + k))) ends
      (fun h => total h a)⟩

/-- So ending selects among groups only between coupled families: where every group with less
of the amount than another has its members each depending, at a need of at least `m`, on some
condition of a family whose gated renewal ran into family excess as above, the groups with less
leave nothing at every generation from `T + n` on. -/
theorem ended_of_family (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {ds : List X} {m : Nat}
    (gated : ∀ t f, f ∈ L.present t → ∀ d, d ∈ ds → 0 < L.give t f d →
      ∃ e, e ∈ ds ∧ W.requires t f e ∧ m ≤ W.need t f e)
    {T n : Nat} (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (start : W.stock ds T < n + m) (k : Nat) {G : Generations X}
    (descended : SelectionTerm.Flow.Descended L W G) {gs : List (List X)}
    (listed : whole gs = G.family (T + n + k)) {a : X → Nat}
    (coupled : ∀ g h, g ∈ gs → h ∈ gs → total h a < total g a → ∀ p, p ∈ h →
      ∃ e, e ∈ ds ∧ W.requires (T + n + k) p e ∧ m ≤ W.need (T + n + k) p e) :
    Ended gs (G.offspringNumber (T + n + k)) a :=
  ended_of_inactive acting descended listed fun g h mg mh less p mp =>
    match coupled g h mg mh less p mp with
    | ⟨e, inside, depends, high⟩ =>
      Becoming.Flow.family_excess_ends balances acting dependent gated excess start k p e inside
        depends high

/-- Where every member of a generation is not active, the next generation is empty: one
condition shared by every group, once it ends them, leaves no group to select among. -/
theorem all_end (acting : L.Acting W) {G : Generations X}
    (descended : SelectionTerm.Flow.Descended L W G) {t : Nat}
    (inactive : ∀ p, p ∈ G.family t → ¬ W.active t p) : G.size (t + 1) = 0 :=
  (G.born_eq t).symm.trans (total_zero_of fun p mp =>
    offspring_zero acting descended mp (inactive p mp))

/-- Groups formed by descent: a generation listed as groups each founded at a value `v` of the
amount, with exact transmission. Where at a step every lineage founded lower than another has its
members not active, nothing is discordant across the step: a member with less of the amount than
another belongs to a lower lineage and leaves nothing. -/
theorem lineages_none_against (acting : L.Acting W) {G : Generations X}
    (descended : SelectionTerm.Flow.Descended L W G) {gs : List (List X)}
    (listed : whole gs = G.family 0)
    (exact : ∀ t, Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    {v : List X → Nat} (founded : ∀ g, g ∈ gs → ∀ p, p ∈ g → G.amount 0 p = v g) {t : Nat}
    (inactive : ∀ g h, g ∈ gs → h ∈ gs → v h < v g → ∀ p, p ∈ lineage G h t → ¬ W.active t p) :
    G.discordAt t = 0 :=
  show discord (G.family t) (G.offspringNumber t) (G.amount t) = 0 from
  discord_zero_of_below fun p q mp mq less =>
    match ListTests.mem_flatMap_iff.mp ((congrArg (p ∈ ·) (lineages_family G listed t)).mpr mp),
      ListTests.mem_flatMap_iff.mp ((congrArg (q ∈ ·) (lineages_family G listed t)).mpr mq) with
    | ⟨h, mh, ph⟩, ⟨g, mg, qg⟩ => by
      rw [lineage_value G listed exact founded mh t ph,
        lineage_value G listed exact founded mg t qg] at less
      rw [offspring_zero acting descended mp (inactive g h mg mh less p ph)]
      exact Nat.zero_le _

/-- So, where at every step before `T` the lineages founded lower than another are not active,
the mean amount at `T` is not below where it started: groups formed by descent keep what ending
selected among them, at every step. -/
theorem lineages_not_lower (acting : L.Acting W) {G : Generations X}
    (descended : SelectionTerm.Flow.Descended L W G) {gs : List (List X)}
    (listed : whole gs = G.family 0)
    (exact : ∀ t, Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    {v : List X → Nat} (founded : ∀ g, g ∈ gs → ∀ p, p ∈ g → G.amount 0 p = v g) {T : Nat}
    (inactive : ∀ t, t < T → ∀ g h, g ∈ gs → h ∈ gs → v h < v g →
      ∀ p, p ∈ lineage G h t → ¬ W.active t p) :
    G.size T * G.sum 0 ≤ G.size 0 * G.sum T :=
  G.not_lower T fun t lt => G.not_lower_step
    (lineages_none_against acting descended listed exact founded (inactive t lt))
    (lowered_exact (exact t))

/-- And the mean rises across a step wherever a lineage founded higher leaves offspring beside a
lineage founded lower that has members. -/
theorem lineages_raises (acting : L.Acting W) {G : Generations X}
    (descended : SelectionTerm.Flow.Descended L W G) {gs : List (List X)}
    (listed : whole gs = G.family 0)
    (exact : ∀ t, Exact (G.family t) (G.kids t) (G.amount t) (G.amount (t + 1)))
    {v : List X → Nat} (founded : ∀ g, g ∈ gs → ∀ p, p ∈ g → G.amount 0 p = v g) {t : Nat}
    (inactive : ∀ g h, g ∈ gs → h ∈ gs → v h < v g → ∀ p, p ∈ lineage G h t → ¬ W.active t p)
    {g h : List X} (mg : g ∈ gs) (mh : h ∈ gs) (less : v h < v g) {p q : X}
    (mp : p ∈ lineage G g t) (mq : q ∈ lineage G h t) (leaves : 0 < G.offspringNumber t p) :
    G.Raises t := by
  have pin : p ∈ G.family t :=
    (congrArg (p ∈ ·) (lineages_family G listed t)).mp (ListTests.mem_flatMap_iff.mpr ⟨g, mg, mp⟩)
  have qin : q ∈ G.family t :=
    (congrArg (q ∈ ·) (lineages_family G listed t)).mp (ListTests.mem_flatMap_iff.mpr ⟨h, mh, mq⟩)
  have none : G.offspringNumber t q = 0 :=
    offspring_zero acting descended qin (inactive g h mg mh less q mq)
  have more : G.amount t q < G.amount t p := by
    rw [lineage_value G listed exact founded mg t mp, lineage_value G listed exact founded mh t mq]
    exact less
  apply (G.raises_exact_iff (exact t)).mpr
  rw [lineages_none_against acting descended listed exact founded inactive]
  exact pairs_pos (F := fun p' q' => excess (G.offspringNumber t p') (G.offspringNumber t q') *
      excess (G.amount t p') (G.amount t q')) pin qin
    (Nat.mul_pos (excess_pos_of_lt (none ▸ leaves)) (excess_pos_of_lt more))

end Flow

/-! ## Witnesses -/

open SelectionLevels.Member

/-- The keeping group, with the member holding back, and the group whose condition ended. -/
def keepingFirst : List (List Member) := [[held, mate], [first, second]]

/-- One at both members of the keeping group, none in the other: groups uniform in keeping. -/
def keeps : Member → Nat
  | held => 1
  | mate => 1
  | first => 0
  | second => 0

theorem uniform : ∀ g, g ∈ keepingFirst → ∃ c, ∀ p, p ∈ g → keeps p = c
  | _, .head _ => ⟨1, fun p mp => match p, mp with
      | _, .head _ => rfl
      | _, .tail _ (.head _) => rfl⟩
  | _, .tail _ (.head _) => ⟨0, fun p mp => match p, mp with
      | _, .head _ => rfl
      | _, .tail _ (.head _) => rfl⟩

theorem equal : ∀ g, g ∈ keepingFirst → g.length = 2 := SelectionLevels.equal

namespace Outweighed

/-- In the keeping group the member holding back leaves one offspring and its groupmate two; the
other group, its condition ended, leaves none. -/
def offspring : Member → Nat
  | held => 1
  | mate => 2
  | first => 0
  | second => 0

/-- Within the keeping group selection goes against holding back (discordance one); among the
groups, nothing against keeping and concordance three; the whole selects for holding back
(concordance two, discordance one). -/
theorem outweighed :
    Ended keepingFirst offspring holds ∧
      concordWithin keepingFirst offspring holds = 0 ∧ discordWithin keepingFirst offspring holds = 1 ∧
      concordAmong keepingFirst offspring holds = 3 ∧ discordAmong keepingFirst offspring holds = 0 ∧
      concord (whole keepingFirst) offspring holds = 2 ∧ discord (whole keepingFirst) offspring holds = 1 :=
  ⟨fun g h mg mh less => match g, h, mg, mh with
      | _, _, .head _, .head _ => absurd less (Nat.lt_irrefl _)
      | _, _, .tail _ (.head _), .head _ => absurd less (by decide)
      | _, _, .head _, .tail _ (.head _) => rfl
      | _, _, .tail _ (.head _), .tail _ (.head _) => rfl,
    rfl, rfl, rfl, rfl, rfl, rfl⟩

/-- Read with keeping, the groups uniform in it, the whole never selects against keeping, and
selects for it. -/
theorem keeping_rises :
    discord (whole keepingFirst) offspring keeps < concord (whole keepingFirst) offspring keeps :=
  rises_of_ended keepingFirst offspring keeps equal uniform
    (fun g h mg mh less => match g, h, mg, mh with
      | _, _, .head _, .head _ => absurd less (Nat.lt_irrefl _)
      | _, _, .tail _ (.head _), .head _ => absurd less (by decide)
      | _, _, .head _, .tail _ (.head _) => rfl
      | _, _, .tail _ (.head _), .tail _ (.head _) => absurd less (Nat.lt_irrefl _))
    (.head _) (.tail _ (.head _)) (by decide) (by decide)

end Outweighed

namespace Outweighs

/-- In the keeping group the member holding back leaves one offspring and its groupmate five; the
other group, its condition ended, leaves none. -/
def offspring : Member → Nat
  | held => 1
  | mate => 5
  | first => 0
  | second => 0

/-- Within the keeping group selection goes against holding back (discordance four); among the
groups, concordance six and nothing against; the whole selects against holding back
(concordance two, discordance four), although the other group ended. -/
theorem outweighs :
    Ended keepingFirst offspring holds ∧
      concordWithin keepingFirst offspring holds = 0 ∧ discordWithin keepingFirst offspring holds = 4 ∧
      concordAmong keepingFirst offspring holds = 6 ∧ discordAmong keepingFirst offspring holds = 0 ∧
      concord (whole keepingFirst) offspring holds = 2 ∧ discord (whole keepingFirst) offspring holds = 4 :=
  ⟨fun g h mg mh less => match g, h, mg, mh with
      | _, _, .head _, .head _ => absurd less (Nat.lt_irrefl _)
      | _, _, .tail _ (.head _), .head _ => absurd less (by decide)
      | _, _, .head _, .tail _ (.head _) => rfl
      | _, _, .tail _ (.head _), .tail _ (.head _) => rfl,
    rfl, rfl, rfl, rfl, rfl, rfl⟩

end Outweighs

namespace Exhausted

/-- The first generation: two keeping groups, each a member holding back (even) beside a
groupmate (odd), and a group whose members leave nothing. -/
def firstKids (p : Nat) : List Nat :=
  bif p == 0 then [10, 12] else bif p == 1 then [11, 13, 15] else
    bif p == 2 then [20, 22] else bif p == 3 then [21, 23, 25] else []

/-- Later, a member holding back leaves one offspring and any other two, each like its parent. -/
def laterKids (p : Nat) : List Nat := bif p % 2 == 0 then [p + 100] else [p + 100, p + 200]

def kids : Nat → Nat → List Nat
  | 0, p => firstKids p
  | _ + 1, p => laterKids p

/-- Holding back: one at the even members, none at the odd; offspring keep their parent's. -/
def holding (_ p : Nat) : Nat := (p + 1) % 2

def G : Generations Nat := ⟨[0, 1, 2, 3, 5, 7], kids, holding⟩

/-- The first generation by groups, and the next listed by descent: the offspring of each keeping
group form a group. -/
def first : List (List Nat) := [[0, 1], [2, 3], [5, 7]]

def next : List (List Nat) := [[10, 12, 11, 13, 15], [20, 22, 21, 23, 25]]

theorem first_listed : whole first = G.family 0 := rfl

theorem next_listed : whole next = G.family 1 := rfl

/-- At the first step the group without holding back leaves nothing: within the keeping groups
holding back is selected against (discordance two), among the groups for it (concordance ten),
and the mean rises (from a third to two fifths). -/
theorem first_step :
    total [5, 7] (G.offspringNumber 0) = 0 ∧
      concordWithin first (G.offspringNumber 0) (G.amount 0) = 0 ∧
      discordWithin first (G.offspringNumber 0) (G.amount 0) = 2 ∧
      concordAmong first (G.offspringNumber 0) (G.amount 0) = 10 ∧
      discordAmong first (G.offspringNumber 0) (G.amount 0) = 0 ∧ G.Raises 0 :=
  ⟨rfl, rfl, rfl, rfl, rfl, by decide⟩

/-- The groups formed by descent hold back alike: two in each. -/
theorem alike : ∀ g, g ∈ next → total g (G.amount 1) = 2
  | _, .head _ => rfl
  | _, .tail _ (.head _) => rfl
  | _, .tail _ (.tail _ mem) => nomatch mem

/-- At the next step the groups formed by descent are alike in holding back (two of five each),
so nothing is selected among them; within them holding back is selected against (discordance
twelve), and the mean falls (from two fifths to a quarter), below where it started: selection
among groups by ending used up the differences among groups it acted on. -/
theorem next_step :
    (∀ g, g ∈ next → total g (G.amount 1) = 2) ∧
      concordAmong next (G.offspringNumber 1) (G.amount 1) = 0 ∧
      discordAmong next (G.offspringNumber 1) (G.amount 1) = 0 ∧
      concordWithin next (G.offspringNumber 1) (G.amount 1) = 0 ∧
      discordWithin next (G.offspringNumber 1) (G.amount 1) = 12 ∧ ¬ G.Raises 1 ∧
      G.size 0 * G.sum 2 < G.size 2 * G.sum 0 :=
  ⟨alike, rfl, rfl, rfl, rfl, by decide, by decide⟩

end Exhausted

namespace Assorted

/-- The first generation by descent-formed groups: a group holding back (the even members) and a
group not holding back (the odd), whose members leave nothing. -/
def firstKids (p : Nat) : List Nat := bif p == 0 then [10, 12] else bif p == 2 then [20, 22] else []

def kids : Nat → Nat → List Nat
  | 0, p => firstKids p
  | _ + 1, p => Exhausted.laterKids p

def G : Generations Nat := ⟨[0, 2, 1, 3], kids, Exhausted.holding⟩

def first : List (List Nat) := [[0, 2], [1, 3]]

theorem first_listed : whole first = G.family 0 := rfl

theorem uniform : ∀ g, g ∈ first → ∃ c, ∀ p, p ∈ g → G.amount 0 p = c
  | _, .head _ => ⟨1, fun p mp => match p, mp with
      | _, .head _ => rfl
      | _, .tail _ (.head _) => rfl
      | _, .tail _ (.tail _ mem) => nomatch mem⟩
  | _, .tail _ (.head _) => ⟨0, fun p mp => match p, mp with
      | _, .head _ => rfl
      | _, .tail _ (.head _) => rfl
      | _, .tail _ (.tail _ mem) => nomatch mem⟩
  | _, .tail _ (.tail _ mem) => nomatch mem

/-- At the first step the group not holding back leaves nothing and the mean rises (from a half
to one). Its lineage has ended; the lineage holding back is all there is, nothing is selected
within it at the next step, and later steps keep the mean at one: above where it started, where
the mixed groups of `Exhausted` fell below it. Holding back leaves fewer offspring than not
holding back would, but no lineage of the next generations holds both. -/
theorem kept :
    lineages G first 1 = [[10, 12, 20, 22], []] ∧ G.Raises 0 ∧
      concordWithin (lineages G first 1) (G.offspringNumber 1) (G.amount 1) = 0 ∧
      discordWithin (lineages G first 1) (G.offspringNumber 1) (G.amount 1) = 0 ∧
      ¬ G.Raises 1 ∧ G.size 2 * G.sum 1 = G.size 1 * G.sum 2 ∧
      G.size 2 * G.sum 0 < G.size 0 * G.sum 2 :=
  ⟨rfl, by decide, rfl, rfl, by decide, by decide, by decide⟩

end Assorted

end GroupEnding

end Becoming
