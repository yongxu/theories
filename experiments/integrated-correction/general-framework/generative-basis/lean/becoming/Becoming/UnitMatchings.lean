import Becoming.GrammarLaws
import Becoming.Flow
import Becoming.SelectionReach
import Becoming.Undecided

/-!
# Unit matchings: the interface of amounts, the root's second sort

Amounts are the root's second sort (U1's verdict): balance is represented by selected matchings of
units, not derived from the unfolding. This module states that interface, at the scopes below. The
census form is GrammarLaws' and Flow's: a flow balances exactly where each step's lists of units
pair one to one under the one (`Flow.balances_iff_units`, from `«守数当且仅当可对»`), and over a
stretch the pairings at each step give one under the relation's closure (`«对之程»`,
`«程守数当且仅当可对»`). What is stated here is what the census does not give: the matching as
data, and the laws at a formation's exchange.

* **Frame matchings, both ways.** A selected matching of a frame (`FrameMatch`) is a bijection of
  its in-positions with its out-positions, given as data. It forces equal counts by pigeonhole,
  with no decidability (`FrameMatch.eq`). Each out-position has an in-position sent to it, by the
  fields `bwd_lt` and `fwd_bwd`, and only one (`FrameMatch.predecessor_unique`). A flow over a web has a selected matching at every step and
  condition exactly where it balances (`frameMatchings_iff_balances`); the converse is pairing by
  position, with no choice. A standing unit goes on, by the matching, as a standing unit or is taken
  (`FrameMatchings.next`); which of the two is the matching's.
* **The crossing laws.** In a one-to-one pairing whose first block on one side is longer than the
  first block on the other, some member of the other side's rest is related to a member of that
  longer block (`crossing_edge`, constructive). In a balanced flow, where a family listed without
  repetition has its stock rise past the inflow of a family containing it, one formation taking part is such that every pairing of what it takes from
  the risen family, with any other inputs, with what it gives the risen family, with any other
  outputs, relates some other input to a unit given the risen family (`rise_crossing_weak`). With
  the containing family written as the risen one followed by the rest, and beyond's inputs at the
  formation source-minimal, the input is one taken from the rest (`rise_crossing_strong`); only the
  risen family is asked to be without repetition, so the rest may share conditions with it. One
  formation, then every pairing; which unit crosses may depend on the pairing.
* **The residual counts.** At a formation, where beyond's units number the source-minimal count, a
  pairing of what it takes from a family and beyond's units with what it gives the family and the
  units ending there has exactly as many endings as it takes beyond what it gives
  (`endings_count`). With leaving outputs kept as well, leaving and endings together number that
  (`leaving_and_endings_count`), which of the two a residual unit is the pairing does not say; with
  no leaving outputs kept, this is `endings_count`.
* **Dissipation and storage.** On a family a present formation dissipates on, the source-minimal
  count is zero (`source_minimal_zero_of_dissipates`), and where it takes, the residual count is
  positive (`residual_pos_of_dissipates`). These are counts; that a source-free selected exchange
  pairing exists, or that a given line ends, is not shown. A formation taking from a family exactly what it gives it, and something,
  does not dissipate on it (`lossless_not_dissipative`).

**What is not shown.** Balance is not derived from the unfolding: every number-stated consumer of
the frame matchings would be a round trip, and no consumer is rerouted through them. The residual
units are accounting, not actual boundary traffic: once a formation's actual exchange outside the
family is kept, the identification of residual endpoints with actual losses fails. Which unit goes
where is the selected matching's, and lines are not World data. Unit continuation does not project
onto the World's conservation, and the orbits of renaming, re-pairing and forgetting do not exhaust
the matchings over one World; these two are the design's conclusions, not theorems of this module.
The two interfaces here are not joined: no labelled exchange pairing is shown to exist for a World's
formations, none is attached to the frames' given and taken positions, the data holding both is not
shown non-empty, and a `FrameMatch`'s graph is not bridged to `«对»` on labelled lists. Line laws
across steps (unique origin over many steps, the stretch law for selected matchings, residence) lie
outside the interface. Each of these is written down in U1's design
(`development/u1-balance-under-units/DESIGN.md`, §3 and §5). The flow's own stretch equation from
supplied pairings follows from `«对则守数»` at each step and `balance_over_stretch_on`, with no law
here.

**Modelling choices.** Natural-number amounts, one unit commensurable across conditions where a
family's takes and gives are summed; discrete steps; positions as numbers below a count; a family as
a list of conditions, a condition repeated in it repeating its labels, and formations counted with
their multiplicity in `Flow.present`. The lists `beyondL`, `leaveL` and `endedL` are any lists of
exchange occurrences: their names restrict no constructor. `«对» R` is a one-to-one pairing using
steps of `R`, not a claim that `R` is functional. The exchange lists are finite at one formation and
step; the frame matchings are indexed by every condition, with no finiteness asked.

Every declaration has an empty axiom report.
-/

namespace Becoming
namespace UnitMatchings

open Undecided (upto mem_upto upto_length)

/-! ## Frame matchings -/

/-- **A selected matching of a frame**: a bijection of the in-positions `i < N` with the
out-positions `j < M`, given as data. At a step and condition the in-positions are those standing
(below the level) and then those given; the out-positions are those standing after the step and then
those taken. -/
structure FrameMatch (N M : Nat) where
  fwd : Nat → Nat
  bwd : Nat → Nat
  fwd_lt : ∀ i, i < N → fwd i < M
  bwd_lt : ∀ j, j < M → bwd j < N
  bwd_fwd : ∀ i, i < N → bwd (fwd i) = i
  fwd_bwd : ∀ j, j < M → fwd (bwd j) = j

/-- A selected matching has no more in-positions than out-positions: pigeonhole, through the
grammar's `revisits_within`, with no decidability. -/
theorem FrameMatch.le {N M : Nat} (m : FrameMatch N M) : N ≤ M :=
  match Nat.lt_or_ge M N with
  | Or.inr ge => ge
  | Or.inl lt =>
    match revisits_within (upto M) m.fwd (fun n le =>
        mem_upto (m.fwd_lt n (Nat.lt_of_le_of_lt ((upto_length M) ▸ le) lt))) with
    | ⟨i, j, ij, jle, same⟩ => by
      have jN : j < N := Nat.lt_of_le_of_lt ((upto_length M) ▸ jle) lt
      have iN : i < N := Nat.lt_trans ij jN
      have e : i = j := (m.bwd_fwd i iN).symm.trans ((congrArg m.bwd same).trans (m.bwd_fwd j jN))
      exact absurd (e ▸ ij) (Nat.lt_irrefl j)

/-- A selected matching read backward. -/
def FrameMatch.symm {N M : Nat} (m : FrameMatch N M) : FrameMatch M N where
  fwd := m.bwd
  bwd := m.fwd
  fwd_lt := m.bwd_lt
  bwd_lt := m.fwd_lt
  bwd_fwd := m.fwd_bwd
  fwd_bwd := m.bwd_fwd

/-- **A selected matching forces equal counts.** -/
theorem FrameMatch.eq {N M : Nat} (m : FrameMatch N M) : N = M :=
  Nat.le_antisymm m.le m.symm.le

/-- Pairing by position: the identity matching, no choice. -/
def FrameMatch.id (N : Nat) : FrameMatch N N where
  fwd i := i
  bwd j := j
  fwd_lt _ h := h
  bwd_lt _ h := h
  bwd_fwd _ _ := rfl
  fwd_bwd _ _ := rfl

/-- **A fixed predecessor at a frame** (`«定前»` at a frame): an out-position has exactly one
in-position the selected matching sends to it. -/
theorem FrameMatch.predecessor_unique {N M : Nat} (m : FrameMatch N M) {i j : Nat} (iN : i < N)
    (e : m.fwd i = j) : i = m.bwd j :=
  (m.bwd_fwd i iN).symm.trans (congrArg m.bwd e)

variable {F C : Type}

/-- **Frame matchings of a flow over a web**: a selected matching of the frame at every step and
condition. The standing out-positions of the frame at `t` (below `level (t + 1)`) are the standing
in-positions of the frame at `t + 1`, by the same index, so the frames compose. -/
structure FrameMatchings (L : Flow F C) (W : Web F C) where
  m : ∀ t c, FrameMatch (W.level t c + L.given t c) (W.level (t + 1) c + L.taken t c)

theorem FrameMatchings.balances {L : Flow F C} {W : Web F C} (U : FrameMatchings L W) :
    L.Balances W :=
  fun t c => (U.m t c).eq.symm

/-- The frame matchings of a balanced flow by position. -/
def FrameMatchings.canonical {L : Flow F C} {W : Web F C} (b : L.Balances W) :
    FrameMatchings L W where
  m t c := cast (congrArg (FrameMatch (W.level t c + L.given t c)) (b t c).symm)
    (FrameMatch.id (W.level t c + L.given t c))

/-- **Frame matchings, both ways**: a flow has selected matchings of every frame exactly where it
balances; the converse needs no choice. A frame match exists exactly where the two counts are equal
(`FrameMatch.eq`, `FrameMatch.id`), so that matchings exist restates the balance equation; what a
matching adds is the bijection itself, as data. -/
theorem frameMatchings_iff_balances {L : Flow F C} {W : Web F C} :
    Nonempty (FrameMatchings L W) ↔ L.Balances W :=
  ⟨fun ⟨U⟩ => U.balances, fun b => ⟨FrameMatchings.canonical b⟩⟩

/-- **A standing unit's next place**: a unit standing at `t` goes on, by the selected matching, as a
standing unit at `t + 1` or is taken at `t`. Which of the two is the matching's; that it goes to
exactly one out-position is not. -/
theorem FrameMatchings.next {L : Flow F C} {W : Web F C} (U : FrameMatchings L W) {t : Nat} {c : C}
    {i : Nat} (standing : i < W.level t c) :
    (U.m t c).fwd i < W.level (t + 1) c ∨
      (W.level (t + 1) c ≤ (U.m t c).fwd i ∧ (U.m t c).fwd i < W.level (t + 1) c + L.taken t c) :=
  match Nat.lt_or_ge ((U.m t c).fwd i) (W.level (t + 1) c) with
  | Or.inl lt => Or.inl lt
  | Or.inr ge => Or.inr ⟨ge, (U.m t c).fwd_lt i (Nat.lt_of_lt_of_le standing (Nat.le_add_right _ _))⟩

/-! ## The crossing laws -/

section Crossing

universe u

variable {U : Type u}

/-- **A crossing edge**: where a one-to-one pairing of `b₁ ++ b₂` with `a₁ ++ a₂`, under the
converse, has more in `b₁` than in `a₁`, some member of `a₂` is related to some member of `b₁`.
Constructive: the witness is found where the pairing first sends a member of `b₁` outside `a₁`. It
holds for every pairing; which edge crosses may depend on the pairing. -/
theorem crossing_edge {R : «际» U} : ∀ (b₁ : List U) {b₂ a₁ a₂ : List U},
    «对» («逆» R) (b₁ ++ b₂) (a₁ ++ a₂) → a₁.length < b₁.length →
      ∃ x, x ∈ a₂ ∧ ∃ y, y ∈ b₁ ∧ R x y
  | [], _, _, _, _, lt => absurd lt (Nat.not_lt_zero _)
  | y :: b₁, b₂, a₁, a₂, p, lt => by
    obtain ⟨c₁, z, c₂, e, r, rest⟩ := «对之取» p [] (y := y) (b₂ := b₁ ++ b₂) rfl
    cases GrammarLaws.split_append a₁ e with
    | inl hf =>
      obtain ⟨f, ha, hc⟩ := hf
      subst ha
      subst hc
      have rest' : «对» («逆» R) (b₁ ++ b₂) ((c₁ ++ f) ++ a₂) :=
        Eq.subst (motive := fun l => «对» («逆» R) (b₁ ++ b₂) l)
          (ListTests.append_assoc c₁ f a₂).symm rest
      have len : (c₁ ++ z :: f).length = (c₁ ++ f).length + 1 := by
        rw [ListTests.length_append, ListTests.length_append]
        exact rfl
      rw [len] at lt
      obtain ⟨x, m, y', m', r'⟩ := crossing_edge b₁ rest' (Nat.lt_of_succ_lt_succ lt)
      exact ⟨x, m, y', List.Mem.tail _ m', r'⟩
    | inr hf =>
      obtain ⟨f, _, ha⟩ := hf
      exact ⟨z, ha ▸ GrammarLaws.mem_middle z c₂ f, y, List.Mem.head _, r⟩

end Crossing

/-- Exchange occurrences at one formation and step: units it took from a condition, units it gave
to a condition, units from beyond, units whose line ends there. Step and formation are parameters
of the lists below, not fields; a condition repeated in a list repeats its labels. -/
inductive Exchange (C : Type) where
  | took (c : C) (i : Nat)
  | gave (c : C) (i : Nat)
  | beyond (i : Nat)
  | ended (i : Nat)

/-- What a formation takes from a family across the step, labelled by condition and position. -/
def takenUnits (L : Flow F C) (f : F) (cs : List C) (t : Nat) : List (Exchange C) :=
  «聚» (fun c => (upto (L.take t f c)).map (Exchange.took c)) cs

/-- What a formation gives a family across the step, labelled by condition and position. -/
def givenUnits (L : Flow F C) (f : F) (cs : List C) (t : Nat) : List (Exchange C) :=
  «聚» (fun c => (upto (L.give t f c)).map (Exchange.gave c)) cs

theorem length_takenUnits (L : Flow F C) (f : F) (cs : List C) (t : Nat) :
    (takenUnits L f cs t).length = total cs (L.take t f) :=
  («聚之长» _ cs).trans (total_congr
    (fun _ => (length_map _ _).trans (upto_length _)) cs)

theorem length_givenUnits (L : Flow F C) (f : F) (cs : List C) (t : Nat) :
    (givenUnits L f cs t).length = total cs (L.give t f) :=
  («聚之长» _ cs).trans (total_congr
    (fun _ => (length_map _ _).trans (upto_length _)) cs)

/-- **The crossing joined to the World, weak form**: where a family's stock rises past the inflow
of a family containing it, some formation taking part is such that, at every pairing of what it
takes from the risen family, followed by any other inputs, with what it gives the risen family,
followed by any other outputs, some unit it gives the risen family continues one of the other
inputs. One formation, then every pairing. That the other inputs are the formation's actual inputs
is the representation's, not this theorem's. -/
theorem rise_crossing_weak {L : Flow F C} {W : Web F C} {ds es : List C} {t : Nat}
    (balances : L.Balances W) (distinct : Distinct ds) (sub : ∀ c, c ∈ ds → c ∈ es)
    (rises : W.stock ds t + L.inflow es t < W.stock ds (t + 1)) :
    ∃ f, f ∈ L.present t ∧ ∀ (R : «际» (Exchange C)) (elseL outL : List (Exchange C)),
      «对» R (takenUnits L f ds t ++ elseL) (givenUnits L f ds t ++ outL) →
        ∃ x, x ∈ elseL ∧ ∃ y, y ∈ givenUnits L f ds t ∧ R x y :=
  match balances.rise_draws_beyond_inflow distinct sub rises with
  | ⟨f, present, _, lt, _⟩ => ⟨f, present, fun _ _ _ p =>
      crossing_edge (givenUnits L f ds t) («对之逆» p)
        (by rw [length_takenUnits, length_givenUnits]; exact lt)⟩

/-- **The crossing joined to the World, strong form**: with the containing family written as the
risen one followed by the rest, and beyond's inputs at the formation source-minimal over it (as many
as it gives the containing family beyond what it takes from it), at every pairing of what it takes
from the risen family, beyond's units and what it takes from the rest, with what it gives the risen
family and any other outputs, some unit it gives the risen family continues a unit it took from the
rest. "From outside the risen family" needs the containing family distinct as a whole; the theorem
says "from the rest". -/
theorem rise_crossing_strong {L : Flow F C} {W : Web F C} {ds rest : List C} {t : Nat}
    (balances : L.Balances W) (distinct : Distinct ds)
    (rises : W.stock ds t + L.inflow (ds ++ rest) t < W.stock ds (t + 1)) :
    ∃ f, f ∈ L.present t ∧ ∀ (R : «际» (Exchange C)) (beyondL outL : List (Exchange C)),
      beyondL.length = excess (total (ds ++ rest) (L.give t f)) (total (ds ++ rest) (L.take t f)) →
      «对» R ((takenUnits L f ds t ++ beyondL) ++ takenUnits L f rest t)
        (givenUnits L f ds t ++ outL) →
        ∃ x, x ∈ takenUnits L f rest t ∧ ∃ y, y ∈ givenUnits L f ds t ∧ R x y :=
  match balances.rise_draws_beyond_inflow distinct (fun _ m => mem_append_of_left rest m) rises with
  | ⟨f, present, ex, lt, _⟩ => ⟨f, present, fun _ beyondL _ hb p => by
      apply crossing_edge (givenUnits L f ds t) («对之逆» p)
      have bal := excess_balance (total ds (L.take t f)) (total ds (L.give t f))
      rw [Flow.excess_zero_of_le (Nat.le_of_lt lt), Nat.add_zero] at bal
      rw [ListTests.length_append, length_takenUnits, hb, length_givenUnits]
      exact Nat.lt_of_lt_of_le (Nat.add_lt_add_left ex _) (Nat.le_of_eq bal)⟩

/-! ## The residual counts, dissipation and storage -/

/-- **How many end, from any pairing**: at a formation, a pairing of what it takes from a family and
beyond's units with what it gives the family and the units ending there has, where beyond's units
are source-minimal, exactly as many endings as it takes beyond what it gives. The residual units are
accounting, not actual boundary traffic. -/
theorem endings_count {L : Flow F C} {f : F} {cs : List C} {t : Nat} {R : «际» (Exchange C)}
    {beyondL endedL : List (Exchange C)}
    (minimal : beyondL.length = excess (total cs (L.give t f)) (total cs (L.take t f)))
    (p : «对» R (takenUnits L f cs t ++ beyondL) (givenUnits L f cs t ++ endedL)) :
    endedL.length = excess (total cs (L.take t f)) (total cs (L.give t f)) := by
  have e := «对之长» p
  rw [ListTests.length_append, ListTests.length_append, length_takenUnits, length_givenUnits,
    minimal, excess_balance] at e
  exact Naturals.add_left_cancel e.symm

/-- **Leaving and ending together**: where the outputs keep the units that leave the family as well
as those that end, beyond's units source-minimal, it is leaving and ending together that number
taken beyond given; which of the two a residual unit is, the pairing does not say. -/
theorem leaving_and_endings_count {L : Flow F C} {f : F} {cs : List C} {t : Nat}
    {R : «际» (Exchange C)} {beyondL leaveL endedL : List (Exchange C)}
    (minimal : beyondL.length = excess (total cs (L.give t f)) (total cs (L.take t f)))
    (p : «对» R (takenUnits L f cs t ++ beyondL) (givenUnits L f cs t ++ (leaveL ++ endedL))) :
    leaveL.length + endedL.length = excess (total cs (L.take t f)) (total cs (L.give t f)) := by
  have e := «对之长» p
  rw [ListTests.length_append, ListTests.length_append, ListTests.length_append,
    length_takenUnits, length_givenUnits, minimal, excess_balance] at e
  exact Naturals.add_left_cancel e.symm

/-- **The source-minimal count is zero where the formation dissipates**: on a family a present
formation dissipates on, beyond's source-minimal count is zero. -/
theorem source_minimal_zero_of_dissipates {L : Flow F C} {cs : List C} {t : Nat} {f : F}
    (dissipates : L.DissipatesOn cs t) (present : f ∈ L.present t) :
    excess (total cs (L.give t f)) (total cs (L.take t f)) = 0 :=
  Flow.excess_zero_of_le (Nat.le_trans (Nat.le_add_right _ _) (dissipates f present))

/-- **The residual count is positive where a dissipating formation takes**: on a family a present
formation dissipates on and takes from, taken beyond given is positive. That a line ends there is
the residual reading of this count, not shown here. -/
theorem residual_pos_of_dissipates {L : Flow F C} {cs : List C} {t : Nat} {f : F}
    (dissipates : L.DissipatesOn cs t) (present : f ∈ L.present t)
    (takes : 0 < total cs (L.take t f)) :
    0 < excess (total cs (L.take t f)) (total cs (L.give t f)) := by
  have d := dissipates f present
  cases h : total cs (L.take t f) with
  | zero => rw [h] at takes; exact absurd takes (Nat.lt_irrefl 0)
  | succ k =>
    rw [h] at d
    exact excess_pos.mpr (Nat.lt_of_succ_le d)

/-- **Lossless storage through a dissipating formation is excluded**: a present formation that
takes from a family exactly what it gives it, and takes something, does not dissipate on it. Close
to the definition: with `same`, dissipating would ask more than the take of the take. -/
theorem lossless_not_dissipative {L : Flow F C} {cs : List C} {t : Nat} {f : F}
    (present : f ∈ L.present t) (same : total cs (L.give t f) = total cs (L.take t f))
    (takes : 0 < total cs (L.take t f)) : ¬ L.DissipatesOn cs t := fun d => by
  have h := d f present
  rw [same] at h
  cases e : total cs (L.take t f) with
  | zero => rw [e] at takes; exact Nat.lt_irrefl 0 takes
  | succ k => rw [e] at h; exact Nat.not_succ_le_self (k + 1) h

end UnitMatchings
end Becoming
