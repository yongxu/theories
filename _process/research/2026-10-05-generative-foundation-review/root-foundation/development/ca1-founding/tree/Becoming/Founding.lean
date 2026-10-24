import Becoming.GroupEnding
import Becoming.Reproduction

/-!
# Founding: selection within a whole, a lineage confined to it, and what a founding carries

`Becoming.SelectionLevels` divides selection into selection within groups and among them, and
`Becoming.GroupEnding` states how ending decides the among-group part. A whole whose parts descend
within it is such a group read over its own generations, and a whole founded by parts of an
earlier whole is a group of a further generation. This module states what selection within a
whole can and cannot carry: a lineage confined to a family of the whole's conditions in excess
has no member once they end, whatever selection within raised; where every next founder carries
its founder's value, the mean founding value rises exactly where selection among wholes goes for
it; and selection within a whole founded uniform needs variation that arose within it.

* **What outlasts the end of a family of conditions.** Where a family of conditions ran into
  excess under the coupled gate (`Becoming.Flow.family_excess_ends`), every member of a later
  generation of descent is the offspring of a member that did not depend on any condition of the
  family at the gate's need (`Flow.survivors_independent`).
* **A confined lineage ends.** A lineage every later member of which depends on some condition of
  such a family has no member from the generation after the family's end on
  (`Flow.confined_ends`), however far selection within the whole had raised it. A rise
  (`Flow.Rise`: an amount marking the lineage that selection within goes for, the lineage taking
  from the family during its excess) whose lineage is confined to the family
  (`Flow.ConfinedRise`) ends so (`Flow.ConfinedRise.ends`, which is `confined_ends`: the rise's
  other clauses do not enter).
* **Selection within needs variation arisen since the founding.** In generations whose first is
  uniform in an amount (one founder is the case of one part), exact transmission keeps every later
  member at the founding value (`uniform_until`), so nothing is selected within at a step before
  which transmission was exact (`none_within_until`); wherever offspring number is concordant or
  discordant with the amount at a step, transmission raised or lowered the amount at some step
  before it (`varied_before`).
* **What a founding carries.** Read wholes over generations (`Nested`): each whole founded by one
  part carrying the whole's value, its parts over generations of their own, and the next wholes
  founded by members of it at a later generation, carrying what they carry there (`Founded`).
  What transmission raised and lowered across a generation of wholes is exactly how far the
  founders of the next wholes moved from their founder within the whole (`raised_carried`,
  `lowered_carried`), so the mean founding value rises exactly where selection among wholes, with
  that within-whole change as the transmission term (Price 1970, 1972), comes out positive
  (`raises_iff_carried`). Where every next founder carries its founder's value (`Sequestered`),
  transmission across generations of wholes is exact (`exact_of_sequestered`) and the mean
  founding value rises exactly where selection among wholes goes for it (`raises_iff_among`, the
  exact case of `Generations.raises_exact_iff`), whatever selection and variation within each
  whole did. Within each whole of a founded reading, selection at a step needs variation arisen
  within it (`varied_within`).
* **Witnesses.** `Body`: one body condition in excess, two lineages that each meet every clause of
  a rise (`Body.confined_rise`, `Body.spread_rise`); the confined lineage ends
  (`Body.confined_ended`); the other's descendant depends on a condition outside the body
  (`Body.spread_unconfined`), and it still has a member a generation after every part depending on
  the body has ended (`Body.spread_outlasts`, `Body.body_ended`). `Germline`: within a whole a
  variant not holding back arises from the founder and selection within goes for it; among wholes,
  the whole holding back founds the next and the other none (by construction). With the next
  founder from the line carrying the founder's value the mean founding value rises from a half to
  one (`Germline.sequestered_rises`); with the next founders from the variants it falls from a
  half to none although selection among wholes goes for holding back
  (`Germline.unsequestered_falls`).

**Readings (the AI's).** Cancer is read as a confined rise: a lineage of a body's parts marked by
an amount that selection within the body goes for, drawing on the body's conditions while their
uptake exceeds their renewal, its descent confined to the body. `Flow.confined_ends` is then the
law that what cancer wins within a body it loses with the body; a transmissible cancer is a rise
whose confinement fails, and in `Body` the two lineages both meet every clause of a rise and,
among what the base leaves free, differ only in where one descendant's need lies. `Sequestered`
is read as a germ line set apart from the soma, where it does not vary, and `Founded` with one
founder as the single-cell bottleneck; together with `SelectionLevels.lineages_within_none` and
`GroupEnding.Assorted`, these are laws of two ways that keep a part of a formed whole from turning
back. Removal of parts by the whole's rule (policing in the literature) is not stated, nor how
parts first come to live as one. That a given tumour meets the clauses is empirical.

The amount is any reading; which family of conditions runs into excess, which members depend on
it and how foundings are drawn are hypotheses wherever they enter. Modelling choices: natural-
number amounts and levels, discrete steps, finite generations as lists, one founder per whole in
`Nested`. No ethical predicate, ranking or axiom occurs; every declaration has an empty axiom
report.
-/

namespace Becoming

namespace Founding

open SelectionTerm SelectionLevels

variable {α : Type}

/-- The one member of a list of one. -/
theorem of_mem_single {p f : α} : p ∈ [f] → p = f
  | .head _ => rfl
  | .tail _ no => nomatch no

/-- A list with no member is empty. -/
theorem nil_of_none : ∀ {l : List α}, (∀ x, x ∈ l → False) → l = []
  | [], _ => rfl
  | x :: _, empty => (empty x (.head _)).elim

/-! ## What outlasts the end of a family of conditions -/

namespace Flow

variable {X : Type} {L : Flow X X} {W : Web X X}

/-- **What outlasts the end of a family of conditions.** Where only active formations give,
activity needs support and the renewal of a family of conditions is gated on the family as one,
`n` steps of the family's uptake exceeding its replenishment from `T`, from a stock below `n + m`,
leave every member of a later generation of descent the offspring of a member that depended on no
condition of the family at a need of at least `m`. -/
theorem survivors_independent (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {G : Generations X} (descended : SelectionTerm.Flow.Descended L W G)
    {ds : List X} {m : Nat}
    (gated : ∀ t f, f ∈ L.present t → ∀ d, d ∈ ds → 0 < L.give t f d →
      ∃ e, e ∈ ds ∧ W.requires t f e ∧ m ≤ W.need t f e)
    {T n : Nat} (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (start : W.stock ds T < n + m) (k : Nat) {x : X} (mx : x ∈ G.family (T + n + k + 1)) :
    ∃ p, p ∈ G.family (T + n + k) ∧ x ∈ G.kids (T + n + k) p ∧
      ∀ e, e ∈ ds → W.requires (T + n + k) p e → ¬ m ≤ W.need (T + n + k) p e :=
  match ListTests.mem_flatMap_iff.mp mx with
  | ⟨p, mp, mk⟩ => ⟨p, mp, mk, fun _ inside depends high =>
      GroupEnding.Flow.family_childless balances acting dependent gated excess start k inside
        depends high x (descended (T + n + k) p x mp mk)⟩

/-- **A confined lineage ends.** Under the same premises, a lineage of a group of the first
generation every member of which, from step `T + n` on, depends on some condition of the family
at a need of at least `m`, has no member at any generation after `T + n`: whatever selection had
raised it to before, nothing of it goes on. -/
theorem confined_ends (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {G : Generations X} (descended : SelectionTerm.Flow.Descended L W G)
    {ds : List X} {m : Nat}
    (gated : ∀ t f, f ∈ L.present t → ∀ d, d ∈ ds → 0 < L.give t f d →
      ∃ e, e ∈ ds ∧ W.requires t f e ∧ m ≤ W.need t f e)
    {T n : Nat} (excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k))
    (start : W.stock ds T < n + m) {h : List X} (founded : ∀ p, p ∈ h → p ∈ G.family 0)
    (confined : ∀ k p, p ∈ lineage G h (T + n + k) →
      ∃ e, e ∈ ds ∧ W.requires (T + n + k) p e ∧ m ≤ W.need (T + n + k) p e) (k : Nat) :
    lineage G h (T + n + k + 1) = [] :=
  nil_of_none fun x mx => match ListTests.mem_flatMap_iff.mp mx with
  | ⟨p, mp, mk⟩ => match confined k p mp with
    | ⟨_, inside, depends, high⟩ =>
      GroupEnding.Flow.family_childless balances acting dependent gated excess start k inside
        depends high x
        (descended (T + n + k) p x (lineage_within G founded (T + n + k) p mp) mk)

/-- **A rise within a whole drawing on a family of conditions in excess.** A lineage of a group
of the first generation of descent: at some step before the end of the family, an amount marks the
lineage there (positive exactly at its members) and selection within the generation goes for it
(offspring number concordant with it beyond its discordance); a member of the lineage takes from
the family while its uptake exceeds its renewal; the family's renewal is gated on it, and its
uptake exceeds its replenishment over `n` steps from `T`, from a stock below `n + m`. -/
structure Rise (L : Flow X X) (W : Web X X) (G : Generations X) (h ds : List X) (m T n : Nat) :
    Prop where
  founded : ∀ p, p ∈ h → p ∈ G.family 0
  selected : ∃ t, t < T + n ∧ (∀ p, p ∈ G.family t → (0 < G.amount t p ↔ p ∈ lineage G h t)) ∧
    G.discordAt t < G.concordAt t
  draws : ∃ t p d, T ≤ t ∧ t < T + n ∧ p ∈ lineage G h t ∧ d ∈ ds ∧ 0 < L.take t p d
  gated : ∀ t f, f ∈ L.present t → ∀ d, d ∈ ds → 0 < L.give t f d →
    ∃ e, e ∈ ds ∧ W.requires t f e ∧ m ≤ W.need t f e
  excess : ∀ k, k < n → L.replenishment ds (T + k) < L.uptake ds (T + k)
  start : W.stock ds T < n + m

/-- **A confined rise within a whole.** A rise whose lineage is confined to the family: from
`T + n` on every member of the lineage depends on some condition of the family at a need of at
least `m`. -/
structure ConfinedRise (L : Flow X X) (W : Web X X) (G : Generations X) (h ds : List X)
    (m T n : Nat) : Prop extends Rise L W G h ds m T n where
  confined : ∀ k p, p ∈ lineage G h (T + n + k) →
    ∃ e, e ∈ ds ∧ W.requires (T + n + k) p e ∧ m ≤ W.need (T + n + k) p e

/-- **A confined rise ends with the conditions it draws on**, on the base where only active
formations give and activity needs support: the lineage has no member at any generation after
`T + n`. Its selection within, and its drawing, do not enter (the law is `confined_ends`): what it
won within the whole it loses with the whole's conditions. -/
theorem ConfinedRise.ends (balances : L.Balances W) (acting : L.Acting W)
    (dependent : W.Dependent) {G : Generations X} (descended : SelectionTerm.Flow.Descended L W G)
    {h ds : List X} {m T n : Nat} (rise : ConfinedRise L W G h ds m T n) (k : Nat) :
    lineage G h (T + n + k + 1) = [] :=
  confined_ends balances acting dependent descended rise.gated rise.excess rise.start rise.founded
    rise.confined k

end Flow

/-! ## Selection within needs variation arisen since the founding -/

/-- Generations founded uniform at `v`, with exact transmission at every step before `t`: every
member at `t` carries `v`. -/
theorem uniform_until (G : Generations α) {v : Nat}
    (founded : ∀ p, p ∈ G.family 0 → G.amount 0 p = v) :
    ∀ {t : Nat}, (∀ s, s < t → Exact (G.family s) (G.kids s) (G.amount s) (G.amount (s + 1))) →
      ∀ p, p ∈ G.family t → G.amount t p = v
  | 0, _, p, mp => founded p mp
  | t + 1, exact, p, mp => match ListTests.mem_flatMap_iff.mp mp with
    | ⟨q, mq, mk⟩ => (exact t (Nat.lt_succ_self t) q mq p mk).trans
        (uniform_until G founded (fun s lt => exact s (Nat.lt_succ_of_lt lt)) q mq)

/-- So nothing is selected within them at `t`, for any weight. -/
theorem none_within_until (G : Generations α) {v : Nat}
    (founded : ∀ p, p ∈ G.family 0 → G.amount 0 p = v) {t : Nat}
    (exact : ∀ s, s < t → Exact (G.family s) (G.kids s) (G.amount s) (G.amount (s + 1)))
    (w : α → Nat) :
    concord (G.family t) w (G.amount t) = 0 ∧ discord (G.family t) w (G.amount t) = 0 :=
  ⟨concord_alike (uniform_until G founded exact) w, discord_alike (uniform_until G founded exact) w⟩

/-- Transmission that neither raised nor lowered anything is exact. -/
theorem exact_of_none {ps : List α} {kids : α → List α} {a b : α → Nat}
    (raised0 : raised ps kids a b = 0) (lowered0 : lowered ps kids a b = 0) :
    Exact ps kids a b :=
  fun p mp k mk =>
    have up : excess (b k) (a p) = 0 := Nat.eq_zero_of_le_zero (Nat.le_trans
      (le_total_of_mem (q := fun k => excess (b k) (a p)) mk)
      (Nat.le_trans (le_total_of_mem (q := fun p => total (kids p) fun k => excess (b k) (a p)) mp)
        (Nat.le_of_eq raised0)))
    have down : excess (a p) (b k) = 0 := Nat.eq_zero_of_le_zero (Nat.le_trans
      (le_total_of_mem (q := fun k => excess (a p) (b k)) mk)
      (Nat.le_trans (le_total_of_mem (q := fun p => total (kids p) fun k => excess (a p) (b k)) mp)
        (Nat.le_of_eq lowered0)))
    Nat.le_antisymm (Reproduction.le_of_excess_zero up) (Reproduction.le_of_excess_zero down)

/-- Before any step, either transmission raised or lowered nothing at every earlier step, or it
raised or lowered something at one of them. -/
theorem changed_or_none (G : Generations α) :
    ∀ t, (∀ s, s < t → G.raisedAt s = 0 ∧ G.loweredAt s = 0) ∨
      ∃ s, s < t ∧ (0 < G.raisedAt s ∨ 0 < G.loweredAt s)
  | 0 => .inl fun s lt => absurd lt (Nat.not_lt_zero s)
  | t + 1 => match changed_or_none G t with
    | .inr ⟨s, lt, changed⟩ => .inr ⟨s, Nat.lt_succ_of_lt lt, changed⟩
    | .inl still => match Nat.decEq (G.raisedAt t) 0 with
      | isFalse up => .inr ⟨t, Nat.lt_succ_self t, .inl (Nat.pos_of_ne_zero up)⟩
      | isTrue up => match Nat.decEq (G.loweredAt t) 0 with
        | isFalse down => .inr ⟨t, Nat.lt_succ_self t, .inr (Nat.pos_of_ne_zero down)⟩
        | isTrue down => .inl fun s lt =>
          match Nat.lt_or_eq_of_le (Nat.le_of_lt_succ lt) with
          | .inl earlier => still s earlier
          | .inr same => same ▸ ⟨up, down⟩

/-- **Selection within needs variation arisen since the founding.** In generations whose first is
uniform in an amount, wherever offspring number is concordant or discordant with the amount at a
step, transmission raised or lowered the amount at some step before it. -/
theorem varied_before (G : Generations α) {v : Nat}
    (founded : ∀ p, p ∈ G.family 0 → G.amount 0 p = v) {t : Nat}
    (selected : G.concordAt t ≠ 0 ∨ G.discordAt t ≠ 0) :
    ∃ s, s < t ∧ (0 < G.raisedAt s ∨ 0 < G.loweredAt s) :=
  match changed_or_none G t with
  | .inr changed => changed
  | .inl still =>
    have zero := none_within_until G founded
      (fun s lt => exact_of_none (still s lt).1 (still s lt).2) (G.offspringNumber t)
    (match selected with
      | .inl concordant => concordant zero.1
      | .inr discordant => discordant zero.2).elim

/-! ## What a founding carries -/

/-- Wholes over generations: `wholes` lists the founders of each generation of wholes, the next
foundings of each and the value each whole is founded at; `soma t f` reads the whole founded by
`f` at generation `t` over its own generations of parts; `span t f` is the generation of that
whole at which it founds the next wholes. -/
structure Nested (α : Type) where
  wholes : Generations α
  soma : Nat → α → Generations α
  span : Nat → α → Nat

namespace Nested

variable (C : Nested α)

/-- Each whole is founded by its one founder, which carries the whole's founding value, and each
next founding is a member of the whole at its span, carrying there what it carries as a founder. -/
def Founded : Prop :=
  ∀ t f, f ∈ C.wholes.family t →
    (C.soma t f).first = [f] ∧ (C.soma t f).amount 0 f = C.wholes.amount t f ∧
      ∀ k, k ∈ C.wholes.kids t f → k ∈ (C.soma t f).family (C.span t f) ∧
        C.wholes.amount (t + 1) k = (C.soma t f).amount (C.span t f) k

/-- Each next founder carries its founder's value: the outcome a founding line set apart from the
parts selection and variation within the whole act on gives, where that line itself does not
vary. -/
def Sequestered : Prop :=
  ∀ t f, f ∈ C.wholes.family t → ∀ k, k ∈ C.wholes.kids t f →
    (C.soma t f).amount (C.span t f) k = (C.soma t f).amount 0 f

/-- What transmission raised across a generation of wholes is how far, upward, the next founders
moved from their founder within its whole. -/
theorem raised_carried {C : Nested α} (founded : C.Founded) (t : Nat) :
    C.wholes.raisedAt t = total (C.wholes.family t) fun f => total (C.wholes.kids t f) fun k =>
      excess ((C.soma t f).amount (C.span t f) k) ((C.soma t f).amount 0 f) :=
  total_eq_of_mem fun f mf => match founded t f mf with
  | ⟨_, start, next⟩ => total_eq_of_mem fun k mk =>
    (congrArg (excess · (C.wholes.amount t f)) (next k mk).2).trans
      (congrArg (excess _ ·) start.symm)

/-- And what it lowered is how far, downward, they moved. -/
theorem lowered_carried {C : Nested α} (founded : C.Founded) (t : Nat) :
    C.wholes.loweredAt t = total (C.wholes.family t) fun f => total (C.wholes.kids t f) fun k =>
      excess ((C.soma t f).amount 0 f) ((C.soma t f).amount (C.span t f) k) :=
  total_eq_of_mem fun f mf => match founded t f mf with
  | ⟨_, start, next⟩ => total_eq_of_mem fun k mk =>
    (congrArg (excess (C.wholes.amount t f) ·) (next k mk).2).trans
      (congrArg (excess · _) start.symm)

/-- **What a founding carries.** The mean founding value rises across a generation of wholes
exactly where selection among wholes, with the change carried within the wholes to the next
founders, goes for it: the change within enters as transmission. -/
theorem raises_iff_carried {C : Nested α} (founded : C.Founded) (t : Nat) :
    C.wholes.Raises t ↔
      C.wholes.size t * (total (C.wholes.family t) fun f => total (C.wholes.kids t f) fun k =>
          excess ((C.soma t f).amount 0 f) ((C.soma t f).amount (C.span t f) k)) +
          C.wholes.discordAt t <
        C.wholes.concordAt t +
          C.wholes.size t * (total (C.wholes.family t) fun f => total (C.wholes.kids t f) fun k =>
            excess ((C.soma t f).amount (C.span t f) k) ((C.soma t f).amount 0 f)) := by
  unfold Generations.Raises
  rw [raised_carried founded t, lowered_carried founded t]

/-- With the foundings drawn from members carrying the founder's value, transmission across
generations of wholes is exact. -/
theorem exact_of_sequestered {C : Nested α} (founded : C.Founded) (sequestered : C.Sequestered)
    (t : Nat) :
    Exact (C.wholes.family t) (C.wholes.kids t) (C.wholes.amount t) (C.wholes.amount (t + 1)) :=
  fun f mf k mk => match founded t f mf with
  | ⟨_, start, next⟩ => (next k mk).2.trans ((sequestered t f mf k mk).trans start)

/-- **Sequestration.** So the mean founding value rises across a generation of wholes exactly
where selection among wholes goes for it, whatever selection and variation within each whole
did. -/
theorem raises_iff_among {C : Nested α} (founded : C.Founded) (sequestered : C.Sequestered)
    (t : Nat) : C.wholes.Raises t ↔ C.wholes.discordAt t < C.wholes.concordAt t :=
  C.wholes.raises_exact_iff (exact_of_sequestered founded sequestered t)

/-- Within each whole of a founded reading, selection at a step needs variation arisen within it
since its founding. -/
theorem varied_within {C : Nested α} (founded : C.Founded) {t : Nat} {f : α}
    (mf : f ∈ C.wholes.family t) {s : Nat}
    (selected : (C.soma t f).concordAt s ≠ 0 ∨ (C.soma t f).discordAt s ≠ 0) :
    ∃ r, r < s ∧ (0 < (C.soma t f).raisedAt r ∨ 0 < (C.soma t f).loweredAt r) :=
  match founded t f mf with
  | ⟨first, start, _⟩ => varied_before (C.soma t f)
      (fun _ mp => (congrArg ((C.soma t f).amount 0) (of_mem_single (first ▸ mp))).trans start)
      selected

end Nested

/-! ## Witnesses -/

namespace Body

/-- One condition of the body and one outside it; a part that leaves no offspring; the founders
of two lineages and their descendants. -/
inductive Relatum where
  | body
  | outside
  | cell
  | confined
  | spread
  | confined₁
  | spread₁
  | spread₂

open Relatum

/-- One at the body. -/
def atBody : Relatum → Nat
  | body => 1
  | outside => 0
  | cell => 0
  | confined => 0
  | spread => 0
  | confined₁ => 0
  | spread₁ => 0
  | spread₂ => 0

/-- One at the parts of the body: the cell, both founders and the confined offspring. -/
def ofBody : Relatum → Nat
  | body => 0
  | outside => 0
  | cell => 1
  | confined => 1
  | spread => 1
  | confined₁ => 1
  | spread₁ => 0
  | spread₂ => 0

/-- One at the spreading lineage's descendants. -/
def beyond : Relatum → Nat
  | body => 0
  | outside => 0
  | cell => 0
  | confined => 0
  | spread => 0
  | confined₁ => 0
  | spread₁ => 1
  | spread₂ => 1

/-- One at the condition outside the body. -/
def atOutside : Relatum → Nat
  | body => 0
  | outside => 1
  | cell => 0
  | confined => 0
  | spread => 0
  | confined₁ => 0
  | spread₁ => 0
  | spread₂ => 0

/-- The body's parts need two of the body; the spreading lineage's descendants need one of the
condition outside it; nothing else is needed. -/
def need (f c : Relatum) : Nat := ofBody f * 2 * atBody c + beyond f * atOutside c

/-- One at each founder of a lineage. -/
def founder : Relatum → Nat
  | body => 0
  | outside => 0
  | cell => 0
  | confined => 1
  | spread => 1
  | confined₁ => 0
  | spread₁ => 0
  | spread₂ => 0

/-- Each lineage's offspring across the first step, and the spreading lineage's across the
second. -/
def kids₀ : Relatum → List Relatum
  | body => []
  | outside => []
  | cell => []
  | confined => [confined₁]
  | spread => [spread₁]
  | confined₁ => []
  | spread₁ => []
  | spread₂ => []

def kids₁ : Relatum → List Relatum
  | body => []
  | outside => []
  | cell => []
  | confined => []
  | spread => []
  | confined₁ => []
  | spread₁ => [spread₂]
  | spread₂ => []

def kids : Nat → Relatum → List Relatum
  | 0 => kids₀
  | 1 => kids₁
  | _ + 2 => fun _ => []

/-- One unit to each offspring: the confined founder's, the spreading founder's, and the
spreading lineage's second. -/
def toConfined₁ : Relatum → Nat
  | body => 0
  | outside => 0
  | cell => 0
  | confined => 0
  | spread => 0
  | confined₁ => 1
  | spread₁ => 0
  | spread₂ => 0

def toSpread₁ : Relatum → Nat
  | body => 0
  | outside => 0
  | cell => 0
  | confined => 0
  | spread => 0
  | confined₁ => 0
  | spread₁ => 1
  | spread₂ => 0

def toSpread₂ : Relatum → Nat
  | body => 0
  | outside => 0
  | cell => 0
  | confined => 0
  | spread => 0
  | confined₁ => 0
  | spread₁ => 0
  | spread₂ => 1

def give₀ : Relatum → Relatum → Nat
  | body => fun _ => 0
  | outside => fun _ => 0
  | cell => fun _ => 0
  | confined => toConfined₁
  | spread => toSpread₁
  | confined₁ => fun _ => 0
  | spread₁ => fun _ => 0
  | spread₂ => fun _ => 0

def give₁ : Relatum → Relatum → Nat
  | body => fun _ => 0
  | outside => fun _ => 0
  | cell => fun _ => 0
  | confined => fun _ => 0
  | spread => fun _ => 0
  | confined₁ => fun _ => 0
  | spread₁ => toSpread₂
  | spread₂ => fun _ => 0

/-- The cell and both founders take part across the first step, each founder taking one unit of
the body; the spreading lineage's descendant alone across the second; then nothing. -/
def present : Nat → List Relatum
  | 0 => [cell, confined, spread]
  | 1 => [spread₁]
  | _ + 2 => []

def flow : Flow Relatum Relatum where
  present := present
  take t f c := match t with
    | 0 => founder f * atBody c
    | _ + 1 => 0
  give t f c := match t with
    | 0 => give₀ f c
    | 1 => give₁ f c
    | _ + 2 => 0

/-- The body stands at two and then at nothing; the condition outside at one throughout; each
offspring comes to stand across the step it is given to. -/
def level : Nat → Relatum → Nat
  | t, body => Witnesses.profile [2] 0 t
  | _, outside => 1
  | _, cell => 0
  | _, confined => 0
  | _, spread => 0
  | t, confined₁ => Witnesses.profile [0] 1 t
  | t, spread₁ => Witnesses.profile [0] 1 t
  | t, spread₂ => Witnesses.profile [0, 0] 1 t

/-- The cell and the founders are active at the first step, the spreading lineage's descendant at
the second; a formation requires what it needs some of. -/
def web : Web Relatum Relatum where
  level := level
  active t f := match f with
    | cell => Witnesses.profile [True] False t
    | confined => Witnesses.profile [True] False t
    | spread => Witnesses.profile [True] False t
    | spread₁ => Witnesses.profile [False, True] False t
    | body => False
    | outside => False
    | confined₁ => False
    | spread₂ => False
  requires _ f c := 0 < need f c
  need _ f c := need f c
  draws _ f c := 0 < need f c

/-- The generations: the cell and both founders; the founders' offspring; the spreading
lineage's second offspring; then none. The amount is a mark. -/
def generationsBy (mark : Relatum → Nat) : Generations Relatum := ⟨[cell, confined, spread], kids, fun _ => mark⟩

/-- The mark of the confined lineage. -/
def ofConfined : Relatum → Nat
  | body => 0
  | outside => 0
  | cell => 0
  | confined => 1
  | spread => 0
  | confined₁ => 1
  | spread₁ => 0
  | spread₂ => 0

/-- The mark of the spreading lineage. -/
def ofSpread : Relatum → Nat
  | body => 0
  | outside => 0
  | cell => 0
  | confined => 0
  | spread => 1
  | confined₁ => 0
  | spread₁ => 1
  | spread₂ => 1

theorem balances : flow.Balances web
  | 0, body => rfl
  | 0, outside => rfl
  | 0, cell => rfl
  | 0, confined => rfl
  | 0, spread => rfl
  | 0, confined₁ => rfl
  | 0, spread₁ => rfl
  | 0, spread₂ => rfl
  | 1, body => rfl
  | 1, outside => rfl
  | 1, cell => rfl
  | 1, confined => rfl
  | 1, spread => rfl
  | 1, confined₁ => rfl
  | 1, spread₁ => rfl
  | 1, spread₂ => rfl
  | _ + 2, body => rfl
  | _ + 2, outside => rfl
  | _ + 2, cell => rfl
  | _ + 2, confined => rfl
  | _ + 2, spread => rfl
  | _ + 2, confined₁ => rfl
  | _ + 2, spread₁ => rfl
  | _ + 2, spread₂ => rfl

theorem acting : flow.Acting web
  | 0, _, _, .head _, _ => trivial
  | 0, _, _, .tail _ (.head _), _ => trivial
  | 0, _, _, .tail _ (.tail _ (.head _)), _ => trivial
  | 0, _, _, .tail _ (.tail _ (.tail _ no)), _ => nomatch no
  | 1, _, _, .head _, _ => trivial
  | 1, _, _, .tail _ no, _ => nomatch no
  | _ + 2, _, _, no, _ => nomatch no

theorem dependent : web.Dependent
  | 0, cell, _ => fun c _ => match c with
    | body => Nat.le_refl 2
    | outside => Nat.zero_le _
    | cell => Nat.zero_le _
    | confined => Nat.zero_le _
    | spread => Nat.zero_le _
    | confined₁ => Nat.zero_le _
    | spread₁ => Nat.zero_le _
    | spread₂ => Nat.zero_le _
  | 0, confined, _ => fun c _ => match c with
    | body => Nat.le_refl 2
    | outside => Nat.zero_le _
    | cell => Nat.zero_le _
    | confined => Nat.zero_le _
    | spread => Nat.zero_le _
    | confined₁ => Nat.zero_le _
    | spread₁ => Nat.zero_le _
    | spread₂ => Nat.zero_le _
  | 0, spread, _ => fun c _ => match c with
    | body => Nat.le_refl 2
    | outside => Nat.zero_le _
    | cell => Nat.zero_le _
    | confined => Nat.zero_le _
    | spread => Nat.zero_le _
    | confined₁ => Nat.zero_le _
    | spread₁ => Nat.zero_le _
    | spread₂ => Nat.zero_le _
  | 1, spread₁, _ => fun c _ => match c with
    | body => Nat.zero_le _
    | outside => Nat.le_refl 1
    | cell => Nat.zero_le _
    | confined => Nat.zero_le _
    | spread => Nat.zero_le _
    | confined₁ => Nat.zero_le _
    | spread₁ => Nat.zero_le _
    | spread₂ => Nat.zero_le _
  | 0, spread₁, no => nomatch no
  | _ + 1, cell, no => nomatch no
  | _ + 1, confined, no => nomatch no
  | _ + 1, spread, no => nomatch no
  | _ + 2, spread₁, no => nomatch no
  | _, body, no => nomatch no
  | _, outside, no => nomatch no
  | _, confined₁, no => nomatch no
  | _, spread₂, no => nomatch no

theorem family_late (mark : Relatum → Nat) : ∀ n, (generationsBy mark).family (n + 3) = []
  | 0 => rfl
  | n + 1 => by
    show ((generationsBy mark).family (n + 3)).flatMap ((generationsBy mark).kids (n + 3)) = []
    rw [family_late mark n]
    rfl

theorem descended (mark : Relatum → Nat) :
    SelectionTerm.Flow.Descended flow web (generationsBy mark)
  | 0, _, _, .tail _ (.head _), .head _ => ⟨.tail _ (.head _), Nat.zero_lt_one,
      Nat.lt_irrefl 0, Nat.zero_lt_one⟩
  | 0, _, _, .tail _ (.tail _ (.head _)), .head _ => ⟨.tail _ (.tail _ (.head _)),
      Nat.zero_lt_one, Nat.lt_irrefl 0, Nat.zero_lt_one⟩
  | 0, _, _, .head _, no => nomatch no
  | 0, _, _, .tail _ (.head _), .tail _ no => nomatch no
  | 0, _, _, .tail _ (.tail _ (.head _)), .tail _ no => nomatch no
  | 0, _, _, .tail _ (.tail _ (.tail _ no)), _ => nomatch no
  | 1, _, _, .head _, no => nomatch no
  | 1, _, _, .tail _ (.head _), .head _ => ⟨.head _, Nat.zero_lt_one, Nat.lt_irrefl 0,
      Nat.zero_lt_one⟩
  | 1, _, _, .tail _ (.head _), .tail _ no => nomatch no
  | 1, _, _, .tail _ (.tail _ no), _ => nomatch no
  | 2, _, _, .head _, no => nomatch no
  | 2, _, _, .tail _ no, _ => nomatch no
  | n + 3, p, _, mp, _ => by
    have empty : p ∈ ([] : List Relatum) := family_late mark n ▸ mp
    cases empty

/-- Nothing gives to the body. -/
theorem give_body : ∀ t f, flow.give t f body = 0
  | 0, body => rfl
  | 1, body => rfl
  | 0, outside => rfl
  | 1, outside => rfl
  | 0, cell => rfl
  | 1, cell => rfl
  | 0, confined => rfl
  | 1, confined => rfl
  | 0, spread => rfl
  | 1, spread => rfl
  | 0, confined₁ => rfl
  | 1, confined₁ => rfl
  | 0, spread₁ => rfl
  | 1, spread₁ => rfl
  | 0, spread₂ => rfl
  | 1, spread₂ => rfl
  | _ + 2, _ => rfl

/-- The confined lineage: the founder, its offspring, then none. -/
theorem confined_late (mark : Relatum → Nat) :
    ∀ n, lineage (generationsBy mark) [confined] (n + 2) = []
  | 0 => rfl
  | n + 1 => by
    show (lineage (generationsBy mark) [confined] (n + 2)).flatMap
      ((generationsBy mark).kids (n + 2)) = []
    rw [confined_late mark n]
    rfl

/-- Nothing renews the body, which is gated on itself at need two. -/
theorem gated : ∀ t f, f ∈ flow.present t → ∀ d, d ∈ [body] → 0 < flow.give t f d →
    ∃ e, e ∈ [body] ∧ web.requires t f e ∧ 2 ≤ web.need t f e
  | t, f, _, _, .head _, gives =>
    (Nat.lt_irrefl 0 (Nat.lt_of_lt_of_le gives (Nat.le_of_eq (give_body t f)))).elim
  | _, _, _, _, .tail _ no, _ => nomatch no

/-- The body's uptake exceeds its replenishment across the first step. -/
theorem excess : ∀ k, k < 1 → flow.replenishment [body] (0 + k) < flow.uptake [body] (0 + k)
  | 0, _ => by decide
  | _ + 1, late => absurd late (Nat.not_lt_zero _ ∘ Nat.lt_of_succ_lt_succ)

/-- From a stock of two. -/
theorem start : web.stock [body] 0 < 1 + 2 := by decide

/-- At the first step the confined lineage's mark is positive exactly at its founder. -/
theorem confined_marks : ∀ p, p ∈ (generationsBy ofConfined).family 0 →
    (0 < (generationsBy ofConfined).amount 0 p ↔ p ∈ lineage (generationsBy ofConfined) [confined] 0)
  | _, .head _ => ⟨fun pos => absurd pos (Nat.lt_irrefl 0), fun no => nomatch no⟩
  | _, .tail _ (.head _) => ⟨fun _ => .head _, fun _ => Nat.zero_lt_one⟩
  | _, .tail _ (.tail _ (.head _)) => ⟨fun pos => absurd pos (Nat.lt_irrefl 0), fun no => nomatch no⟩
  | _, .tail _ (.tail _ (.tail _ no)) => nomatch no

/-- And the spreading lineage's at its founder. -/
theorem spread_marks : ∀ p, p ∈ (generationsBy ofSpread).family 0 →
    (0 < (generationsBy ofSpread).amount 0 p ↔ p ∈ lineage (generationsBy ofSpread) [spread] 0)
  | _, .head _ => ⟨fun pos => absurd pos (Nat.lt_irrefl 0), fun no => nomatch no⟩
  | _, .tail _ (.head _) => ⟨fun pos => absurd pos (Nat.lt_irrefl 0), fun no => nomatch no⟩
  | _, .tail _ (.tail _ (.head _)) => ⟨fun _ => .head _, fun _ => Nat.zero_lt_one⟩
  | _, .tail _ (.tail _ (.tail _ no)) => nomatch no

/-- **The confined lineage rises within the body and is confined to it.** At the first step the
mark is positive exactly at its founder and selection within goes for it; the founder takes from
the body while its uptake exceeds its renewal; its descendant needs two of the body. -/
theorem confined_rise :
    Flow.ConfinedRise flow web (generationsBy ofConfined) [confined] [body] 2 0 1 where
  founded
    | _, .head _ => .tail _ (.head _)
    | _, .tail _ no => nomatch no
  selected := ⟨0, Nat.zero_lt_one, confined_marks, by decide⟩
  draws := ⟨0, confined, body, Nat.le_refl 0, Nat.zero_lt_one, .head _, .head _, Nat.zero_lt_one⟩
  gated := gated
  excess := excess
  start := start
  confined
    | 0, _, .head _ => ⟨body, .head _, Nat.zero_lt_two, Nat.le_refl 2⟩
    | 0, _, .tail _ no => nomatch no
    | k + 1, p, mp => by
      have late : 0 + 1 + (k + 1) = k + 2 :=
        (congrArg (· + (k + 1)) (Nat.zero_add 1)).trans (Nat.add_comm 1 (k + 1))
      have empty : p ∈ ([] : List Relatum) := confined_late ofConfined k ▸ late ▸ mp
      cases empty

/-- So the confined lineage has no member from the second generation on. -/
theorem confined_ended (k : Nat) :
    lineage (generationsBy ofConfined) [confined] (0 + 1 + k + 1) = [] :=
  confined_rise.ends balances acting dependent (descended ofConfined) k

/-- **The spreading lineage rises within the body alike.** At the first step its mark is positive
exactly at its founder and selection within goes for it, and the founder takes from the body while
its uptake exceeds its renewal: every clause of a rise holds of it. -/
theorem spread_rise : Flow.Rise flow web (generationsBy ofSpread) [spread] [body] 2 0 1 where
  founded
    | _, .head _ => .tail _ (.tail _ (.head _))
    | _, .tail _ no => nomatch no
  selected := ⟨0, Nat.zero_lt_one, spread_marks, by decide⟩
  draws := ⟨0, spread, body, Nat.le_refl 0, Nat.zero_lt_one, .head _, .head _, Nat.zero_lt_one⟩
  gated := gated
  excess := excess
  start := start

/-- But it is not confined: its descendant at the first step needs nothing of the body. -/
theorem spread_unconfined :
    ¬ ∀ k p, p ∈ lineage (generationsBy ofSpread) [spread] (0 + 1 + k) →
      ∃ e, e ∈ [body] ∧ web.requires (0 + 1 + k) p e ∧ 2 ≤ web.need (0 + 1 + k) p e :=
  fun held => match held 0 spread₁ (.head _) with
  | ⟨_, .head _, _, high⟩ => absurd high (by decide)
  | ⟨_, .tail _ no, _, _⟩ => nomatch no

/-- From the first step on, nothing depending on the body at need two is active. -/
theorem body_ended (k : Nat) (g : Relatum) (depends : web.requires (0 + 1 + k) g body)
    (high : 2 ≤ web.need (0 + 1 + k) g body) : ¬ web.active (0 + 1 + k) g :=
  Becoming.Flow.family_excess_ends balances acting dependent gated excess start k g body (.head _)
    depends high

/-- **The spreading lineage outlasts the body's parts.** It has a member at the second
generation, after every part depending on the body has ended (`body_ended`); its lineage has no
member from the third generation on, the witness modelling no new whole it founds. -/
theorem spread_outlasts : lineage (generationsBy ofSpread) [spread] 2 = [spread₂] := rfl

end Body

namespace Germline

/-- Two founders, one holding back and one not; within the first whole, a part carrying the
founder's value and a variant arising from it that does not hold back; their offspring. -/
inductive Part where
  | founder
  | ender
  | germ
  | variant
  | germ₂
  | variant₂
  | variant₃

open Part

/-- One where a part holds back. -/
def holds : Part → Nat
  | founder => 1
  | ender => 0
  | germ => 1
  | variant => 0
  | germ₂ => 1
  | variant₂ => 0
  | variant₃ => 0

/-- Within the first whole: the founder's offspring are a part like it and a variant; the variant
then leaves two offspring and the other one. -/
def within : Nat → Part → List Part
  | 0, founder => [germ, variant]
  | 0, ender => []
  | 0, germ => []
  | 0, variant => []
  | 0, germ₂ => []
  | 0, variant₂ => []
  | 0, variant₃ => []
  | 1, founder => []
  | 1, ender => []
  | 1, germ => [germ₂]
  | 1, variant => [variant₂, variant₃]
  | 1, germ₂ => []
  | 1, variant₂ => []
  | 1, variant₃ => []
  | _ + 2, _ => []

/-- Each whole read over its own generations from its founder. -/
def soma (_ : Nat) (f : Part) : Generations Part := ⟨[f], within, fun _ => holds⟩

/-- The whole holding back founds the next whole; the other founds none (by construction). -/
def foundings (next : List Part) : Nat → Part → List Part
  | 0, founder => next
  | 0, ender => []
  | 0, germ => []
  | 0, variant => []
  | 0, germ₂ => []
  | 0, variant₂ => []
  | 0, variant₃ => []
  | _ + 1, _ => []

/-- The two readings: the next whole founded from the line carrying the founder's value, or from
the variants. -/
def nested (next : List Part) : Nested Part :=
  ⟨⟨[founder, ender], foundings next, fun _ => holds⟩, soma, fun _ _ => 2⟩

def sequestered : Nested Part := nested [germ₂]

def unsequestered : Nested Part := nested [variant₂, variant₃]

/-- The first whole's parts at its second generation. -/
theorem family_two : (soma 0 founder).family 2 = [germ₂, variant₂, variant₃] := rfl

theorem founded (next : List Part) (inside : ∀ k, k ∈ next → k ∈ [germ₂, variant₂, variant₃]) :
    (nested next).Founded
  | 0, _, .head _ => ⟨rfl, rfl, fun k mk => ⟨family_two ▸ inside k mk, rfl⟩⟩
  | 0, _, .tail _ (.head _) => ⟨rfl, rfl, fun _ no => nomatch no⟩
  | 0, _, .tail _ (.tail _ no) => nomatch no
  | _ + 1, _, _ => ⟨rfl, rfl, fun _ no => nomatch no⟩

theorem sequestered_founded : sequestered.Founded :=
  founded [germ₂] fun
    | _, .head _ => .head _
    | _, .tail _ no => nomatch no

theorem unsequestered_founded : unsequestered.Founded :=
  founded [variant₂, variant₃] fun
    | _, .head _ => .tail _ (.head _)
    | _, .tail _ (.head _) => .tail _ (.tail _ (.head _))
    | _, .tail _ (.tail _ no) => nomatch no

theorem sequestered_sequestered : sequestered.Sequestered
  | 0, _, .head _, _, .head _ => rfl
  | 0, _, .head _, _, .tail _ no => nomatch no
  | 0, _, .tail _ (.head _), _, no => nomatch no
  | 0, _, .tail _ (.tail _ no), _, _ => nomatch no
  | _ + 1, _, _, _, no => nomatch no

/-- Within the whole, the variant arises from the founder (transmission lowers holding back at
the first step) and selection goes against holding back at the second. -/
theorem within_against :
    0 < (soma 0 founder).loweredAt 0 ∧
      (soma 0 founder).concordAt 1 < (soma 0 founder).discordAt 1 :=
  ⟨by decide, by decide⟩

/-- **With a germ line the mean founding value rises**, by selection among wholes alone. -/
theorem sequestered_rises :
    sequestered.wholes.discordAt 0 < sequestered.wholes.concordAt 0 ∧ sequestered.wholes.Raises 0 ∧
      sequestered.wholes.size 0 = 2 ∧ sequestered.wholes.sum 0 = 1 ∧
      sequestered.wholes.size 1 = 1 ∧ sequestered.wholes.sum 1 = 1 :=
  ⟨by decide, (Nested.raises_iff_among sequestered_founded sequestered_sequestered 0).mpr
    (by decide), rfl, rfl, rfl, rfl⟩

/-- **Without it, the mean founding value falls**, from a half to none, although selection among
wholes goes for holding back: the change within the whole enters as transmission and outweighs
it. -/
theorem unsequestered_falls :
    unsequestered.wholes.discordAt 0 < unsequestered.wholes.concordAt 0 ∧
      ¬ unsequestered.wholes.Raises 0 ∧ unsequestered.wholes.sum 0 = 1 ∧
      unsequestered.wholes.size 1 = 2 ∧ unsequestered.wholes.sum 1 = 0 ∧
      ¬ unsequestered.Sequestered :=
  ⟨by decide, by decide, rfl, rfl, rfl,
    fun sequestered => absurd (sequestered 0 founder (.head _) variant₂ (.head _)) (by decide)⟩

end Germline

end Founding

end Becoming
