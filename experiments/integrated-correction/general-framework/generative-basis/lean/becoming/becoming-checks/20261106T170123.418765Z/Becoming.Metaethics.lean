import Becoming.Dependence

/-!
# Valuation and significance on the Becoming spine

Evaluation is stated over the same frame as the dynamics. Positions, their own
regions and their significance are formed within the unfolding; `own` is a region
of formed relations, not an owner. The laws below hold for any type of standpoints (`Pos`); the
reading that standpoints are formations is the instance `Pos := F`, with each formation's own
region its closure under a relation of the unfolding (`Web.selfValuation`, `Becoming.Boundaries`). `related` stands for formed relation
(conditioning, dependence, descent, cooperation) and `living` for the claims read as
living. Both are inputs of a valuation; 生生 is read separately, by widening what can form. The readings the
Becoming layer supplies below are narrower: `related` is co-participation in a
condition, which includes co-dependence without interaction, and `living` is activity
that does not undermine the dependence of others. Neither contains further generation:
an active formation participating in nothing counts as living.

The premise card, every item named and visible:
* S0, `SelfSignificance`: a position's own living claims have significance for it
  (significance, with no valence). Any S0-holding position with own living supplies a `Seed`.
* N, boundary neutrality. Each rule below is accepted, by its rivals, inside some
  formed boundary (`Within`); the premise is that no formed boundary restricts it
  (`Neutral`):
  - N_rel, `transmits`: significance passes along a formed relation to living
    content (patient side: self and other, kin, species, temporal distance);
  - N_std, `shares`: significance of living content holds from every standpoint;
  - A, `articulates`: a response a position has access to, which secures new
    content from its standpoint on the response's scope, supplies a contributory
    reason (addressee side: no endorsement condition).
* C, `Comparison`: a no-loss extension realizing more living content is better.
* L, `LiftBetter`: outcome comparisons lift to responses with several outcomes;
  conservative default, every outcome better than every outcome.
* J1–J4: `PracticalJudgment` (protection priority, frontier selection, assigned
  responsibility), additional commitments outside the core; `Becoming.Bridge`
  states them on configurations by `BetterAt`.
* Correspondence: E (formation), `Connected`, and the reading of `living`. For one
  run the Becoming layer can supply the last two: `Conditions.valuation` and
  `Web.valuation` read its formation events, so that `living` is activity that does
  not undermine others' dependence and `related` is participation in a common
  condition. Connection then rests on which conditions are counted: one that every
  formation requires at level zero connects any web without changing `living`, while
  a coarse common condition that every formation draws on empties `living` once a
  dependence on it fails. `Becoming.Correspondence` states one discipline: a condition
  relates two events only when one draws on it and the other depends on it at a
  positive level, so that idle conditions connect nothing and connection through a
  condition is made by its living use. Both readings are relative to a run, while
  `LivingSignificance`, `Comparison` and `universal_reason` take a `living` fixed across
  configurations; joining them needs a construction not given here.

Results:
* `significant_iff`: on a connected whole with some living content, living significance for every
  standpoint is equivalent to a seed with N_rel and N_std. This characterizes the
  content of living significance with no axiom; since Ren folded living significance (`LivingSignificance`) (11 October 2026) it is a condition,
  and a theorem of the continuation condition of `Becoming.Significance`. The forward direction is
  nearly immediate; the content lies in the backward direction and in minimality.
* `positioned_articulation_of_articulates`: the positioned articulation D follows
  from A with living significance read with unindexed significance.
* `universal_reason`: a sound inquiry whose goal is new living content gives every
  position with access a contributory reason for it.
* What C asks of the comparison it constrains, with no premise. Extensions are irreflexive
  and compose (`Extension.irrefl`, `Extension.trans`). A comparison read off a description of
  configurations and comparing no description with itself satisfies C only if the description
  tells every extension apart from its base (`Comparison.separates`). A natural-number score
  satisfying C rises by at least one at every link of an endless chain of extensions
  (`Comparison.climbs`), so it ranks some link above any configuration whatever
  (`Comparison.outgrows`); a bounded score is not constrained so.
* Minimality: dropping the seed, N_rel, N_std, connection or A each leaves a
  consistent countermodel. Each rival accepts the same rule inside a formed
  boundary: its own region, its own standpoint, or endorsers.
* On a run read relationally, an event is living when its formation is active and
  does not consume in the run. A condition in which every living formation
  participates discharges connection (`significant_iff_of_common`); without one,
  connection can fail (`Separate.not_connected`). A consuming formation and a formation
  that loses its support co-participate in the drawn condition, so under N_rel a
  standpoint valuing the consumer's activity holds significant the living events of
  the formation that loses its support (`valuing_consumption_reaches`). The
  transmission runs along co-participation and does not use the consumption.
* Read stepwise, with dependences that may change (`Web.valuation`), an event is
  living when it is active and not undermining: it does not draw on a condition at a
  step after which the condition is below both the present need of a dependence on it
  and a need of that dependence met while it held. This is the stepwise reading, kept beside the
  whole-run and relation-level readings on Ren's delegation of 15 October 2026; no comparison uses
  it (DELEGATED-CHOICES D1, D10). Being within renewal at the step is not used as `living`, since it
  withholds the event of a formation whose own dependence breaks (`Renewable.broken_formation`); not
  breaking is not used either, since it includes drawing after a loss, which in `Renewable` keeps
  the condition from returning (`Renewable.drawing_after_loss`). The same results hold: a common
  condition discharges connection, and an event drawing at a step that breaks a dependence is
  related to the broken formation, so under N_rel valuing it reaches that formation's living events
  (`Web.valuing_breaking_reaches`). On fixed dependences the two readings share `related`, both
  include the broken formation's own event, and they include different events in both directions
  (`Renewable.readings_differ`).
* Read through relations (`Web.relations`), a claim is a formation's relation to a
  condition at a step, living when the formation is active, participates in the
  condition and the relation is not undermining. The stepwise reading of events is the
  conjunction of the reading of relations (`Web.living_iff_relations`), and one event
  can have a living relation and an undermining one (`Mixed.one_event_two_relations`).

Nothing here proves S0, N, A, C, L or J, binds a position that rejects them, or
treats bringing new lives into existence. A contributory reason is not a duty, a
ranking or a prediction of recognition or compliance. Every declaration has an
empty axiom report.

The core imports only its own layers and the foundation. Living significance, C, D and the secured new
content are stated here once; `Becoming.Bridge` shows that the definitions of
`GenerativeComparison` and `PositionedPositiveReason` are these, so their theorems
apply without the core depending on them.

The valuations read on frames (`Valuation.relations`, `LivingSignificance`, `universal_reason`, `Comparison`,
`Extension`, `LiftBetter`, the `Conditions`, `Separate` and `Model` instances) are in
`Becoming.ValuationFrames` (board item W).
-/

namespace Becoming

/-! ## Boundaries and neutrality -/

/-- A rule accepted only inside a formed boundary. -/
def Within {I : Type} (bound : I → Prop) (rule : I → Prop) : Prop :=
  ∀ i, bound i → rule i

/-- Boundary neutrality: no formed boundary restricts the rule. -/
def Neutral {I : Type} (rule : I → Prop) : Prop :=
  ∀ i, rule i

theorem Neutral.within {I : Type} {rule : I → Prop} (neutral : Neutral rule)
    (bound : I → Prop) : Within bound rule :=
  fun i _ => neutral i

/-! ## Significance across formed relations and standpoints -/

/-- The patient and standpoint side of evaluation within one unfolding. The standpoints are a
type of their own, so every law stated over `Valuation` holds for any type of standpoints; the
reading that standpoints are formations is the instance `Pos := F`, stated with each formation's
own region its closure under a relation of the unfolding in `Web.selfValuation`
(`Becoming.Boundaries`), where `sig` is the one evaluative parameter supplied. -/
structure Valuation (Pos C : Type) where
  living : C → Prop
  related : C → C → Prop
  own : Pos → C → Prop
  sig : Pos → C → Prop

namespace Valuation

variable {Pos C : Type} (V : Valuation Pos C)

/-- Self-significance at a position (S0): its own living claims have significance from it. -/
def SelfSignificance (p : Pos) : Prop :=
  ∀ c, V.own p c → V.living c → V.sig p c

/-- Some living claim has significance from some standpoint. -/
def Seed : Prop :=
  ∃ p c, V.living c ∧ V.sig p c

/-- The rule of relational neutrality (N_rel): significance passes along a formed relation to
living content. -/
def transmits : Pos × C × C → Prop
  | (p, c, d) => V.sig p c → V.related c d → V.living d → V.sig p d

/-- The rule of standpoint neutrality (N_std): significance of living content holds from every
standpoint. -/
def shares : Pos × Pos × C → Prop
  | (p, q, c) => V.living c → V.sig p c → V.sig q c

/-- What living significance needs beyond the frame: a seed and both neutralities. -/
def Grounds : Prop :=
  V.Seed ∧ Neutral V.transmits ∧ Neutral V.shares

/-- Living significance at the level of claims: every living claim is significant from every standpoint. -/
def Significant : Prop :=
  ∀ p c, V.living c → V.sig p c

variable {V}

theorem seed_of_selfSignificance {p : Pos} {c : C} (self : V.SelfSignificance p) (own : V.own p c)
    (alive : V.living c) : V.Seed :=
  ⟨p, c, alive, self c own alive⟩

end Valuation

/-! ## Living significance, D and the universal reason on the frame -/

variable {S A C Pos : Type}

/-- Every admitted outcome of the response holds relevant content absent before it. -/
def SecuresNewContent {H R : Type} (admitted : R → H → Prop) (before : H → C → Prop)
    (relevance : H → C → Prop) (r : R) : Prop :=
  ∀ h, admitted r h → ∃ c, relevance h c ∧ ¬ before h c

/-- D: positioned articulation. Endorsement does not occur in it. -/
def PositionedArticulation {H R : Type} (access : Pos → R → Prop)
    (admitted : R → H → Prop) (before : H → C → Prop) (relevance : H → C → Prop)
    (Reason : Pos → R → Prop) : Prop :=
  ∀ p r, access p r → SecuresNewContent admitted before relevance r → Reason p r

/-- A's rule: securing positive content from one's own standpoint, with access,
supplies a contributory reason. -/
def articulates {H R : Type} (V : Valuation Pos C) (access : Pos → R → Prop)
    (admitted : R → H → Prop) (before : H → C → Prop) (Reason : Pos → R → Prop) :
    Pos × R → Prop
  | (p, r) => access p r →
      SecuresNewContent admitted before (fun _ c => V.sig p c) r → Reason p r

/-- D follows from A with living significance read with unindexed significance. -/
theorem positioned_articulation_of_articulates {H R : Type} {V : Valuation Pos C}
    {access : Pos → R → Prop} {admitted : R → H → Prop} {before : H → C → Prop}
    {Reason : Pos → R → Prop} (articulate : Neutral (articulates V access admitted before Reason)) :
    PositionedArticulation access admitted before (fun _ c => ∀ p, V.sig p c) Reason :=
  fun p r available secured => articulate (p, r) available fun h inScope =>
    match secured h inScope with
    | ⟨c, all, fresh⟩ => ⟨c, all p, fresh⟩

/-! ## Comparison, lifting and practical judgment on the frame -/

/-! ## The relational reading supplied by the Becoming layer -/

section Reading

open RelationalRenewal

/-! Two formations, each participating only in its own condition: both are living
and nothing consumes, yet no formed relation links them. -/

namespace Separate

def same : Bool → Bool → Prop
  | false, false => True
  | false, true => False
  | true, false => False
  | true, true => True

def conditions : Conditions Unit Bool Bool :=
  ⟨fun _ _ => 0, fun _ _ => True, same, fun _ _ => 0, fun _ _ => False⟩

theorem stays (e e' : Bool × Nat)
    (related : ∃ c, (same e.1 c ∨ False) ∧ (same e'.1 c ∨ False)) :
    e.1 = false → e'.1 = false :=
  match e, e', related with
  | (false, _), (false, _), _ => fun _ => rfl
  | (true, _), _, _ => fun h => Bool.noConfusion h
  | (false, _), (true, _), ⟨false, _, .inl h⟩ => (nomatch h)
  | (false, _), (true, _), ⟨true, .inl h, _⟩ => (nomatch h)
  | (_, _), (_, _), ⟨_, .inr h, _⟩ => (nomatch h)
  | (_, _), (_, _), ⟨_, _, .inr h⟩ => (nomatch h)

end Separate

/-! ### The stepwise reading -/

/-- Formation events of a web read stepwise. An event is living when its formation is
active and it is not undermining: it does not draw on a condition at a step after which
the condition is below both the present need of a dependence on it and a need of that
dependence met while it held. Two events are related when their
formations participate in a common condition at their steps. Standpoints, their regions
and significance remain supplied. -/
def Web.valuation {F Cond : Type} (W : Web F Cond) (own sig : Pos → F × Nat → Prop) :
    Valuation Pos (F × Nat) where
  living e := W.active e.2 e.1 ∧ ¬ W.UnderminingAt e.2 e.1
  related e e' := ∃ c, W.Participates e.2 e.1 c ∧ W.Participates e'.2 e'.1 c
  own := own
  sig := sig

namespace Web

variable {F Cond : Type} (W : Web F Cond) (own sig : Pos → F × Nat → Prop)

/-- An event drawing on a condition at a step that breaks a dependence on it is not
living, and is related to every event of the broken formation that participates in the
condition. Other formations may take part in the breaking. -/
theorem breaking_relates {f g : F} {t : Nat} {c : Cond} (drawn : W.draws t f c)
    (broken : W.Broken t g c) :
    ¬ (W.valuation own sig).living (f, t) ∧
      ∀ t', W.Participates t' g c → (W.valuation own sig).related (f, t) (g, t') :=
  ⟨fun ⟨_, notUndermining⟩ =>
    notUndermining ⟨c, (show W.BreakingOn t f c from ⟨drawn, g, broken⟩).undermining⟩,
   fun _ joins => ⟨c, Or.inr drawn, joins⟩⟩

/-- Under N_rel, a standpoint that values an event drawing at a step that breaks a
dependence holds significant every living event of the broken formation that
participates in the condition, its event at that step included. The drawing event is
not living, so S0 alone supplies no such valuation. -/
theorem valuing_breaking_reaches (transmit : Neutral (W.valuation own sig).transmits)
    {f g : F} {t : Nat} {c : Cond} (drawn : W.draws t f c) (broken : W.Broken t g c)
    {p : Pos} (held : (W.valuation own sig).sig p (f, t)) {t' : Nat}
    (joins : W.Participates t' g c) (alive : (W.valuation own sig).living (g, t')) :
    (W.valuation own sig).sig p (g, t') :=
  transmit (p, (f, t), (g, t')) held ((breaking_relates W own sig drawn broken).2 t' joins) alive

end Web

/-- Relations read stepwise. A claim is a formation's relation to a condition at a step.
It is living when the formation is active and participates in the condition there, and
the relation is not undermining. Two relations are related when they concern one
condition or belong to one event. Standpoints, their regions and significance remain
supplied. -/
def Web.relations {F Cond : Type} (W : Web F Cond) (own sig : Pos → F × Cond × Nat → Prop) :
    Valuation Pos (F × Cond × Nat) where
  living e := W.active e.2.2 e.1 ∧ W.Participates e.2.2 e.1 e.2.1 ∧
    ¬ W.UnderminingOn e.2.2 e.1 e.2.1
  related e e' := e.2.1 = e'.2.1 ∨ (e.1 = e'.1 ∧ e.2.2 = e'.2.2)
  own := own
  sig := sig

/-- An event is living exactly when it is active and each of its relations to the
conditions it participates in is living: the stepwise reading of events is the
conjunction of the reading of relations. -/
theorem Web.living_iff_relations {F Cond : Type} (W : Web F Cond)
    (own sig : Pos → F × Nat → Prop) (own' sig' : Pos → F × Cond × Nat → Prop) (f : F)
    (t : Nat) :
    (W.valuation own sig).living (f, t) ↔
      W.active t f ∧ ∀ c, W.Participates t f c → (W.relations own' sig').living (f, c, t) :=
  ⟨fun ⟨active, notUndermining⟩ =>
    ⟨active, fun c joins => ⟨active, joins, fun undermining => notUndermining ⟨c, undermining⟩⟩⟩,
   fun ⟨active, all⟩ =>
    ⟨active, fun ⟨c, undermining⟩ => (all c (Or.inr undermining.1)).2.2 undermining⟩⟩

namespace Mixed

inductive Formation where
  | drawer
  | dependent

inductive Source where
  | kept
  | lost

/-- One event draws on two conditions; its step keeps the dependence on one and breaks
the dependence on the other. -/
def web : Web Formation Source where
  level t
    | .kept => 1
    | .lost => match t with
      | 0 => 1
      | _ + 1 => 0
  active t
    | .drawer => True
    | .dependent => match t with
      | 0 => True
      | _ + 1 => False
  requires _
    | .drawer => fun _ => False
    | .dependent => fun _ => True
  need _ _ _ := 1
  draws _
    | .drawer => fun _ => True
    | .dependent => fun _ => False

theorem dependent : web.Dependent
  | _, .drawer, _, _, depends => False.elim depends
  | 0, .dependent, _, .kept, _ => Nat.le_refl 1
  | 0, .dependent, _, .lost, _ => Nat.le_refl 1
  | _ + 1, .dependent, active, _, _ => False.elim active

/-- The event is not living, while one of its relations is: one activity takes part in
both generation and degeneration, and the reading of relations keeps them apart. -/
theorem one_event_two_relations (own sig : Pos → Formation × Nat → Prop)
    (own' sig' : Pos → Formation × Source × Nat → Prop) :
    ¬ (web.valuation own sig).living (.drawer, 0) ∧
    (web.relations own' sig').living (.drawer, .kept, 0) ∧
    ¬ (web.relations own' sig').living (.drawer, .lost, 0) :=
  have undermining : web.UnderminingOn 0 .drawer .lost :=
    ⟨trivial, .dependent, trivial,
      ⟨0, Nat.le_refl 0, fun _ _ _ => trivial, Nat.le_refl 1, Nat.le_refl _⟩, Nat.zero_lt_one⟩
  ⟨fun ⟨_, notUndermining⟩ => notUndermining ⟨.lost, undermining⟩,
   ⟨trivial, Or.inr trivial, fun ⟨_, _, _, _, unmet⟩ => Nat.lt_irrefl 1 unmet⟩,
   fun ⟨_, _, notUndermining⟩ => notUndermining undermining⟩

end Mixed

end Reading

/-! ## Minimality: each premise is needed, and each rival is a bounded rule -/

namespace Model

inductive Who where
  | evaluator | bystander

inductive Life where
  | self | other | beyond

-- Exhaustive, non-overlapping patterns keep these definitions free of `propext`.
def related : Life → Life → Prop
  | .self, .self => False
  | .self, .other => True
  | .self, .beyond => False
  | .other, .self => True
  | .other, .other => False
  | .other, .beyond => False
  | .beyond, _ => False

def own : Who → Life → Prop
  | .evaluator, .self => True
  | .evaluator, .other => False
  | .evaluator, .beyond => False
  | .bystander, _ => False

/-- `beyond` stands outside every formed relation of the others. -/
def linked : Life → Prop
  | .self => True
  | .other => True
  | .beyond => False

def valuation (living : Life → Prop) (sig : Who → Life → Prop) : Valuation Who Life :=
  ⟨living, related, own, sig⟩

/-- Significance of the evaluator's own region only, from every standpoint. -/
def ownRegion : Who → Life → Prop
  | _, .self => True
  | _, .other => False
  | _, .beyond => False

/-- Significance from the evaluator's standpoint only. -/
def ownStandpoint : Who → Life → Prop
  | .evaluator, _ => True
  | .bystander, _ => False

theorem no_relation_into_beyond : ∀ c, ¬ related c .beyond
  | .self => id
  | .other => id
  | .beyond => id

/-- Only the evaluator endorses. -/
def endorses : Who → Prop
  | .evaluator => True
  | .bystander => False

/-- A is needed for endorsement independence. Every living claim is significant from
every standpoint, yet a reason restricted to endorsers is consistent with that and
withholds the reason from a non-endorsing position with access. -/
theorem articulation_neutrality_is_needed :
    let V := valuation linked (fun _ _ => True)
    let Art := articulates (H := Unit) (R := Unit) V (fun _ _ => True) (fun _ _ => True)
      (fun _ _ => False) (fun p _ => endorses p)
    V.Significant ∧ Within (fun i => endorses i.1) Art ∧ ¬ Neutral Art :=
  ⟨fun _ _ _ => trivial,
    fun | (.evaluator, _), _, _, _ => trivial
        | (.bystander, _), bound, _, _ => (nomatch bound),
    fun neutral => neutral (.bystander, ()) trivial (fun _ _ => ⟨.self, trivial, id⟩)⟩

end Model

end Becoming
