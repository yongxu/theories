import Becoming.Descent
import Becoming.Continuation

/-!
# Standpoints: whose continuation counts

Ren's proposal of 10 October 2026 ends with what is now the continuation condition: “for anything, its continuation into
the future has significance”. `Becoming.Continuation` states what the dynamics derives with
no ethical premise, the extent a continuing formation must count; it does not settle the
center, whose continuation counts. This module states the center on the valuations of
`Becoming.Metaethics`.

* **Held lives.** A living claim is *held* when some position counts it in its own region
  (`Valuation.Held` for all living claims, `Valuation.Unheld` for a claim no position
  holds). Where every life is held, living significance at the level of claims is exactly S0 at every
  position with standpoint neutrality (`Valuation.significant_iff_held`); neither
  connection nor relational neutrality is used. Where holding is decided and every living
  claim is reached through formed relations from a held one, living significance is S0 at every position,
  standpoint neutrality, and relational neutrality only into claims no position holds
  (`Valuation.significant_iff_reached`). None of these can be dropped: every life held
  and valued by its own standpoint only, where neither neutrality holds
  (`Apart.not_enough`), a life no standpoint holds (`Unclaimed.held_is_needed`), and a
  reached life no position holds (`Relayed.transmission_is_needed`). S0 already carries a
  position's significance along any relation into its own region
  (`Valuation.own_transmission`).
* **Two completions.** Standpoint neutrality completes S0 with no connection. On a
  connected whole where every position holds a living claim, S0 at every position with
  relational neutrality gives living significance without it (`Valuation.significant_of_transmits`).
  Where the relations are read as dependence, relational neutrality is the valuation form
  of counting what one's continuation depends on; in a whole where dependence links every
  two lives, the derived extent with S0 then reaches every life (a reading of the general
  theorem).
* **Each formation its own center.** Read stepwise, with each formation a position whose
  own region is its own events, every living event is held (`Web.held_by_formations`), so
  living significance there is S0 at every formation with standpoint neutrality
  (`Web.significant_iff_self`). The stepwise `living` reading, active and not undermining,
  is one reading of the proposal's weak form, continuation that does not damage another's
  (an AI reading). S0 ranges over living claims, so read this way the seed already carries
  that filter: a formation's own event that undermines is not living, and S0 says nothing
  of it (`Clearing.clearer_not_living`).
* **Conveyance crosses the boundary.** Read with one kind of relatum, conveyance relates
  two events at a common step when something is conveyed between their relata
  (`Flow.conveyance`; `living` is the stepwise reading). A relatum nothing is taken from
  or given to is related to nothing (`Flow.conveyance_idle`). The region of a family
  continuing as in `Flow.fed_from_beyond` is, from no step on, left uncrossed
  (`Flow.boundary_crossed`), so it is not a cut in the relations (`Flow.Cut`,
  `Flow.region_not_a_cut`); under relational neutrality, valuing a relatum's event reaches
  the living event of what is conveyed into it (`Flow.valuing_reaches_source`). In
  `Clearing` read with one kind of relatum, the resource's region is crossed at every
  step (`Clearing.crossed`, `Clearing.resource_not_cut`). Under living on the resource's
  region is no cut either, since the clearer lives on it
  (`Clearing.resource_not_cut_living_on`). What conveyance adds is a relation between two
  conditions, in the direction of inflow: read with one kind of relatum, something
  conveyed between two conditions relates their events (`Flow.roles_conveyance`), while
  interaction, living on and descent relate no two conditions at any steps
  (`Flow.roles_conditions_unrelated`), so the fuel and the resource of `Clearing` are
  related by conveyance alone (`Clearing.conveyance_only`). On Ren's delegation of 15 October 2026
  conveyance counts as a formed relation, as interaction, living on and descent do
  (DELEGATED-CHOICES D9, D12).
* **The center is not derived along dependence.** The continuation of an event's
  formation is *fed by* another event when, at their common step, the other's formation
  gives to a condition the first requires (`Flow.FedBy`). In `Clearing` each
  formation holds and values its own events, and the clearer values also the source's, which
  feed its resource. Every life is held, S0 holds at every position, and each standpoint's
  significance is closed along feeding, while the dweller's living event has no
  significance from the clearer's standpoint: standpoint neutrality fails and living significance fails
  (`Clearing.center_not_derived`). The line holds for a derived extent that runs along
  dependence. In the same valuation the formed relations of the stepwise reading relate
  the clearer's event to the dweller's through the habitat both take part in, and
  transmission out of the clearer's own region fails: an extent run along every formed
  relation would reach the dweller. With standpoint neutrality added, living significance holds by
  `Web.significant_iff_self`. Significance at the level of claims does not separate
  counting another as a condition from counting it as a being that wants.

Reading S0 as what wanting is, the seed at each wanting point, and standpoint neutrality as
the continuation condition, so that what has significance from any center has it from every standpoint
and no center is privileged, is the AI's reading of Ren's proposal, adopted on Ren's delegation of
15 October 2026 (DELEGATED-CHOICES D11). Living significance is no longer an axiom: Ren folded it on 11 October 2026.
The source of `Clearing` requires nothing by stipulation. Decided holding is a disclosed logical
commitment of `significant_iff_reached`, as decided equality is of the conveyance results. Names are
working names.

`Flow.FedBy` and `Clearing.fedBy_source` are in `Becoming.Continuation` (board item W).
-/

namespace Becoming

/-! ## Held lives -/

namespace Valuation

variable {Pos C : Type} (V : Valuation Pos C)

/-- Every living claim lies in the own region of some position. -/
def Held : Prop :=
  ∀ c, V.living c → ∃ p, V.own p c

/-- A claim no position holds. -/
def Unheld (c : C) : Prop :=
  ¬ ∃ p, V.own p c

variable {V}

/-- Where every living claim is some position's own, living significance is S0 at every position with
standpoint neutrality. Neither connection nor relational neutrality is used. -/
theorem significant_iff_held (held : V.Held) :
    V.Significant ↔ (∀ p, V.SelfSignificance p) ∧ Neutral V.shares :=
  ⟨fun all => ⟨fun p c _ alive => all p c alive, fun ⟨_, q, c⟩ alive _ => all q c alive⟩,
    fun ⟨self, share⟩ q c alive => match held c alive with
      | ⟨p, own⟩ => share (p, q, c) alive (self p c own alive)⟩

/-- With holding decided, where every living claim is reached through formed relations
from a living claim some position holds, living significance is S0 at every position, standpoint
neutrality, and relational neutrality into claims no position holds. -/
theorem significant_iff_reached [∀ c, Decidable (∃ p, V.own p c)]
    (reached : ∀ c, V.living c → ∃ c₀ p, V.living c₀ ∧ V.own p c₀ ∧ Reach V.relations c₀ c) :
    V.Significant ↔
      (∀ p, V.SelfSignificance p) ∧ Neutral V.shares ∧ Within (fun i => V.Unheld i.2.2) V.transmits :=
  ⟨fun all => ⟨fun p c _ alive => all p c alive, fun ⟨_, q, c⟩ alive _ => all q c alive,
      fun ⟨p, _, d⟩ _ _ _ alive => all p d alive⟩,
    fun ⟨self, share, transmit⟩ q c alive => match reached c alive with
      | ⟨c₀, p, alive₀, own, path⟩ =>
        (show Invariant V.relations (V.sig q) from fun c' _ d step held =>
          match (inferInstance : Decidable (∃ p, V.own p d)) with
          | .isTrue ⟨p', own'⟩ => share (p', q, d) step.2 (self p' d own' step.2)
          | .isFalse unheld => transmit (q, c', d) unheld held step.1 step.2).reach path
          (share (p, q, c₀) alive₀ (self p c₀ own alive₀))⟩

/-- S0 at every position already carries each position's significance along any relation
into its own region: transmission into own regions adds nothing to S0. -/
theorem own_transmission (self : ∀ p, V.SelfSignificance p) :
    Within (fun i => V.own i.1 i.2.2) V.transmits :=
  fun ⟨p, _, d⟩ own _ _ alive => self p d own alive

/-- A second completion of S0: on a connected whole where every position holds a living
claim, S0 at every position with relational neutrality gives living significance, with no standpoint
neutrality. -/
theorem significant_of_transmits (connected : V.Connected)
    (holds : ∀ p, ∃ c, V.own p c ∧ V.living c) (self : ∀ p, V.SelfSignificance p)
    (transmit : Neutral V.transmits) : V.Significant :=
  fun q c alive => match holds q with
    | ⟨c₀, own, alive₀⟩ =>
      Valuation.reaches transmit (connected c₀ c alive₀ alive) (self q c₀ own alive₀)

end Valuation

/-! ## Each formation its own center -/

namespace Web

variable {F Cond Pos : Type} (W : Web F Cond)

/-- Read stepwise with each formation a position whose own region is its own events, every
living event is held. -/
theorem held_by_formations (sig : F → F × Nat → Prop) :
    (W.valuation (fun f e => e.1 = f) sig).Held :=
  fun e _ => ⟨e.1, rfl⟩

/-- So living significance there is S0 at every formation with standpoint neutrality. This is the
case of the empty relation of `Web.selfValuation_significant_iff` (`Becoming.Boundaries`), where
each formation's own region is its closure under a relation of the unfolding. -/
theorem significant_iff_self (sig : F → F × Nat → Prop) :
    (W.valuation (fun f e => e.1 = f) sig).Significant ↔
      (∀ f, (W.valuation (fun f e => e.1 = f) sig).SelfSignificance f) ∧
        Neutral (W.valuation (fun f e => e.1 = f) sig).shares :=
  Valuation.significant_iff_held (W.held_by_formations sig)

end Web

namespace Apart

/-- Two lives, each the own region of its own standpoint. -/
def own : Bool → Bool → Prop
  | true, true => True
  | true, false => False
  | false, true => False
  | false, false => True

def valuation : Valuation Bool Bool := ⟨fun _ => True, fun _ _ => True, own, own⟩

/-- Held lives and S0 do not suffice: every life is held and valued by its own standpoint
only, and neither standpoint neutrality nor relational neutrality holds. -/
theorem not_enough :
    valuation.Held ∧ (∀ p, valuation.SelfSignificance p) ∧ ¬ Neutral valuation.shares ∧
      ¬ Neutral valuation.transmits ∧ ¬ valuation.Significant :=
  ⟨fun c _ => match c with
    | true => ⟨true, trivial⟩
    | false => ⟨false, trivial⟩,
   fun _ _ held _ => held,
   fun share => share (true, false, true) trivial trivial,
   fun transmit => transmit (true, true, false) trivial trivial trivial,
   fun all => all false true trivial⟩

end Apart

namespace Unclaimed

/-- One standpoint, whose own region is one of two lives. -/
def own : Unit → Bool → Prop
  | (), true => True
  | (), false => False

def valuation : Valuation Unit Bool := ⟨fun _ => True, fun _ _ => False, own, own⟩

/-- Holding is needed: a life held by no standpoint has no significance though S0 and
standpoint neutrality hold. -/
theorem held_is_needed :
    ¬ valuation.Held ∧ (∀ p, valuation.SelfSignificance p) ∧ Neutral valuation.shares ∧
      ¬ valuation.Significant :=
  ⟨fun held => match held false trivial with
    | ⟨(), no⟩ => no,
   fun _ _ held _ => held,
   fun ⟨(), (), _⟩ _ held => held,
   fun all => all () false trivial⟩

end Unclaimed

namespace Relayed

/-- The held life is related to the unheld one. -/
def related : Bool → Bool → Prop
  | true, false => True
  | true, true => False
  | false, _ => False

def valuation : Valuation Unit Bool := ⟨fun _ => True, related, Unclaimed.own, Unclaimed.own⟩

/-- Relational neutrality into unheld lives is needed: every life is reached from a held
one, S0 and standpoint neutrality hold, and the unheld life has no significance. -/
theorem transmission_is_needed :
    (∀ c, valuation.living c →
        ∃ c₀ p, valuation.living c₀ ∧ valuation.own p c₀ ∧ Reach valuation.relations c₀ c) ∧
      (∀ p, valuation.SelfSignificance p) ∧ Neutral valuation.shares ∧
      ¬ Within (fun i => valuation.Unheld i.2.2) valuation.transmits ∧
      ¬ valuation.Significant :=
  ⟨fun c _ => match c with
    | true => ⟨true, (), trivial, trivial, Reach.refl _ true⟩
    | false => ⟨true, (), trivial, trivial, Reach.of_step (a := ()) ⟨trivial, trivial⟩⟩,
   fun _ _ held _ => held,
   fun ⟨(), (), _⟩ _ held => held,
   fun transmit => transmit ((), true, false) (fun ⟨(), no⟩ => no) trivial trivial trivial,
   fun all => all () false trivial⟩

end Relayed

/-! ## Conveyance crosses the boundary -/

namespace Flow

section Crossing

variable {X Pos : Type} (L : Flow X X) (W : Web X X) (own sig : Pos → X × Nat → Prop)

/-- Events read stepwise, related when something is conveyed between their relata across
their common step. -/
def conveyance : Valuation Pos (X × Nat) where
  living e := W.active e.2 e.1 ∧ ¬ W.UnderminingAt e.2 e.1
  related e e' := e.2 = e'.2 ∧ (L.Conveys e.2 e.1 e'.1 ∨ L.Conveys e.2 e'.1 e.1)
  own := own
  sig := sig

variable {L W own sig}

/-- A relatum nothing is taken from or given to across a step is related to nothing at that
step. -/
theorem conveyance_idle {x : X} {t : Nat}
    (idle : ∀ f, f ∈ L.present t → L.take t f x = 0 ∧ L.give t f x = 0) :
    ∀ e, ¬ (L.conveyance W own sig).related (x, t) e :=
  fun _ ⟨_, conveys⟩ => match conveys with
    | .inl ⟨f, present, takes, _⟩ =>
      Nat.lt_irrefl 0 (Eq.subst (motive := fun n => 0 < n) (idle f present).1 takes)
    | .inr ⟨f, present, _, gives⟩ =>
      Nat.lt_irrefl 0 (Eq.subst (motive := fun n => 0 < n) (idle f present).2 gives)

/-- The boundary of a continuing family is, from no step on, left uncrossed by
conveyance. -/
theorem boundary_crossed [DecidableEq X] (balances : L.Balances W)
    (dissipative : L.Dissipative) {ds : List X} (distinct : Distinct ds) {T₀ : Nat}
    (around : ∀ t, T₀ ≤ t → L.Around ds t) (recurs : ∀ N, ∃ t, N ≤ t ∧ 0 < L.takers ds t)
    (N : Nat) :
    ¬ ∀ t, N ≤ t → ¬ ∃ c d, ¬ c ∈ ds ∧ d ∈ ds ∧
      (L.conveyance W own sig).related (c, t) (d, t) :=
  fun never => fed_from_beyond balances dissipative distinct around recurs N
    fun t later ⟨c, d, outside, inside, conveys⟩ =>
      never t later ⟨c, d, outside, inside, rfl, .inl conveys⟩

/-- Under N_rel, valuing a relatum's event reaches the living event of what is conveyed
into it at that step. -/
theorem valuing_reaches_source (transmit : Neutral (L.conveyance W own sig).transmits)
    {p : Pos} {c d : X} {t : Nat} (conveys : L.Conveys t c d) (held : sig p (d, t))
    (alive : (L.conveyance W own sig).living (c, t)) : sig p (c, t) :=
  transmit (p, (d, t), (c, t)) held ⟨rfl, .inr conveys⟩ alive

/-- No formed relation leaves the region: nothing in it goes out of it along the valuation's relation
(`«不出»`). -/
def Cut {Q : Type} (V : Valuation Pos Q) (region : Q → Prop) : Prop :=
  «不出» V.related region

/-- The region of a continuing family is not a cut: conveyance leaves it. -/
theorem region_not_a_cut [DecidableEq X] (balances : L.Balances W)
    (dissipative : L.Dissipative) {ds : List X} (distinct : Distinct ds) {T₀ : Nat}
    (around : ∀ t, T₀ ≤ t → L.Around ds t) (recurs : ∀ N, ∃ t, N ≤ t ∧ 0 < L.takers ds t) :
    ¬ Cut (L.conveyance W own sig) (fun e => e.1 ∈ ds) :=
  fun cut => boundary_crossed (own := own) (sig := sig) balances dissipative distinct around
    recurs 0 fun t _ ⟨c, d, outside, inside, related⟩ =>
      cut (d, t) (c, t) inside outside ⟨rfl, related.2.symm⟩

end Crossing

section Roles

variable {F C Pos : Type} (L : Flow F C) (W : Web F C) (own sig : Pos → (F ⊕ C) × Nat → Prop)

/-- Read with one kind of relatum, something conveyed between two conditions relates their
events at that step. -/
theorem roles_conveyance {t : Nat} {c d : C} (conveys : L.Conveys t c d) :
    (L.roles.conveyance W.roles own sig).related (.inr c, t) (.inr d, t) :=
  match conveys with
  | ⟨f, present, takes, gives⟩ => ⟨rfl, .inl ⟨.inl f, mem_map_of present, takes, gives⟩⟩

/-- Interaction, living on and descent relate no two events of relata that take no part:
read with one kind of relatum, no two conditions are related by them, at any steps. -/
theorem roles_conditions_unrelated (c d : C) (t t' : Nat) :
    ¬ (W.roles.interaction own sig).related (.inr c, t) (.inr d, t') ∧
      ¬ (W.roles.sustenance own sig).related (.inr c, t) (.inr d, t') ∧
      ¬ (L.roles.descent W.roles own sig).related (.inr c, t) (.inr d, t') :=
  have apart : ¬ ∃ x, W.roles.Interacts x (.inr c, t) (.inr d, t') :=
    fun ⟨_, interacts⟩ => match interacts with
      | .inl ⟨drawn, _⟩ => drawn
      | .inr ⟨⟨required, _⟩, _⟩ => required
  ⟨apart,
   fun related => match related with
    | .inl interacts => apart interacts
    | .inr (.inl ⟨drawn, _⟩) => drawn
    | .inr (.inr ⟨drawn, _⟩) => drawn,
   fun related => match related with
    | .inl interacts => apart interacts
    | .inr (.inl ⟨_, present, _⟩) => inr_not_mem present
    | .inr (.inr ⟨_, present, _⟩) => inr_not_mem present⟩

end Roles

end Flow

/-! ## The clearing from its standpoints -/

namespace Clearing

open Frontier (burning)

/-- Read with one kind of relatum, conveyance relates the step's fuel to the resource at
every step. -/
theorem crossed {Pos : Type} (own sig : Pos → (Formation ⊕ Place) × Nat → Prop) (t : Nat) :
    (Flow.conveyance flow.roles web.roles own sig).related (.inr (.fuel t), t)
      (.inr .resource, t) :=
  ⟨rfl, .inl ⟨.inl .source, .head _,
    show 0 < 2 * burning t t from
      Eq.subst (motive := fun b => 0 < 2 * b) (Frontier.burning_self t).symm (Nat.succ_pos 1),
    Nat.zero_lt_one⟩⟩

/-- So the resource's region is not a cut in the relations. -/
theorem resource_not_cut {Pos : Type} (own sig : Pos → (Formation ⊕ Place) × Nat → Prop) :
    ¬ Flow.Cut (Flow.conveyance flow.roles web.roles own sig)
      (fun e => e.1 ∈ [Sum.inr Place.resource]) :=
  fun cut => cut (.inr .resource, 0) (.inr (.fuel 0), 0) (.head _)
    (fun mem => match mem with | .tail _ no => nomatch no)
    ⟨rfl, (crossed own sig 0).2.symm⟩

/-- Conveyance relates the step's fuel and the resource, which neither interaction, living on
nor descent relates. -/
theorem conveyance_only {Pos : Type} (own sig : Pos → (Formation ⊕ Place) × Nat → Prop)
    (t : Nat) :
    (Flow.conveyance flow.roles web.roles own sig).related (.inr (.fuel t), t)
        (.inr .resource, t) ∧
      ¬ (web.roles.interaction own sig).related (.inr (.fuel t), t) (.inr .resource, t) ∧
      ¬ (web.roles.sustenance own sig).related (.inr (.fuel t), t) (.inr .resource, t) ∧
      ¬ (flow.roles.descent web.roles own sig).related (.inr (.fuel t), t) (.inr .resource, t) :=
  ⟨crossed own sig t, Flow.roles_conditions_unrelated flow web own sig (.fuel t) .resource t t⟩

/-- Under living on, read with one kind of relatum, the resource's region is no cut either:
the clearer lives on the resource. -/
theorem resource_not_cut_living_on {Pos : Type}
    (own sig : Pos → (Formation ⊕ Place) × Nat → Prop) :
    ¬ Flow.Cut (web.roles.sustenance own sig) (fun e => e.1 ∈ [Sum.inr Place.resource]) :=
  fun cut => cut (.inr .resource, 0) (.inl .clearer, 0) (.head _)
    (fun mem => match mem with | .tail _ no => nomatch no)
    (.inr (.inr ⟨trivial, trivial, Nat.zero_lt_one⟩))

/-- Each formation holds its own events. -/
def own : Formation → Formation × Nat → Prop :=
  fun f e => e.1 = f

/-- Each formation values its own events, and the clearer values also the source's. -/
def sig : Formation → Formation × Nat → Prop
  | .clearer, e => e.1 = .clearer ∨ e.1 = .source
  | .source, e => e.1 = .source
  | .dweller, e => e.1 = .dweller

def valuation : Valuation Formation (Formation × Nat) :=
  web.valuation own sig

/-- S0 ranges over living claims: the clearer's own event at step one is active and not
living, for the clearer undermines there, so S0 says nothing of it. -/
theorem clearer_not_living :
    web.active 1 .clearer ∧ own .clearer (.clearer, 1) ∧ ¬ valuation.living (.clearer, 1) :=
  ⟨trivial, rfl, fun ⟨_, steady⟩ => steady undermines_within_renewal.2.2.2.2.2.2.2.2.1⟩

/-- The center is not derived along dependence. Each formation holds and values its own
events, and the clearer values also the source's, which feed its resource: every life is held,
S0 holds at every position, and each standpoint's significance is closed along feeding. The
dweller's event at step zero is living and has no significance from the clearer's
standpoint, so standpoint neutrality and living significance fail. The clearer's event at step zero is
related to it through the habitat, so transmission out of the clearer's own region along the
formed relations fails. -/
theorem center_not_derived :
    valuation.Held ∧ (∀ f, valuation.SelfSignificance f) ∧
      (∀ p e e', valuation.sig p e → flow.FedBy web e e' → valuation.sig p e') ∧
      valuation.living (.dweller, 0) ∧ ¬ valuation.sig .clearer (.dweller, 0) ∧
      ¬ Neutral valuation.shares ∧ ¬ valuation.Significant ∧
      valuation.related (.clearer, 0) (.dweller, 0) ∧
      ¬ Within (fun i => own i.1 i.2.1) valuation.transmits :=
  have alive : valuation.living (.dweller, 0) := ⟨trivial, fun ⟨_, draws, _⟩ => draws⟩
  have apart : ¬ valuation.sig .clearer (.dweller, 0) := fun
    | .inl same => Formation.noConfusion same
    | .inr same => Formation.noConfusion same
  have related : valuation.related (.clearer, 0) (.dweller, 0) :=
    ⟨.habitat, .inr trivial, .inl trivial⟩
  ⟨web.held_by_formations sig,
   fun f e owned _ => match f, e, owned with
    | .clearer, (.clearer, _), _ => .inl rfl
    | .source, (.source, _), _ => rfl
    | .dweller, (.dweller, _), _ => rfl,
   fun p _ _ valued fed => match p, fedBy_source fed, valued with
    | .clearer, ⟨_, source⟩, _ => .inr source
    | .source, ⟨clearer, _⟩, valued => Formation.noConfusion (clearer.symm.trans valued)
    | .dweller, ⟨clearer, _⟩, valued => Formation.noConfusion (clearer.symm.trans valued),
   alive, apart, fun share => apart (share (.dweller, .clearer, (.dweller, 0)) alive rfl),
   fun all => apart (all .clearer (.dweller, 0) alive), related,
   fun transmit => apart (transmit (.clearer, (.clearer, 0), (.dweller, 0)) rfl (.inl rfl)
     related alive)⟩

end Clearing

end Becoming
