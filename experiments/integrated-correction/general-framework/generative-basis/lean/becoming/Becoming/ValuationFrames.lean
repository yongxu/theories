import Becoming.Inquiry
import Becoming.Labelled
import Becoming.Significance
import Becoming.Extension

/-!
# Valuations read on frames

`Becoming.Metaethics` states valuations over the relations a web or a flow forms, and
`Becoming.Significance` states the continuation condition on them; neither imports the frame. This
module holds their readings on frames and runs of a labelled process: formed relations as a process
on claims (`Valuation.relations`, `Valuation.Connected`); the scope of the two neutralities as the
frame's one closure, relational neutrality being closedness under the relations' steps
(`Valuation.transmits_iff_closed`), what the neutralities force from a valued living claim being
exactly what it reaches (`Valuation.forced_iff_reach`), and the whole forced exactly where it is
connected (`Valuation.forced_whole_iff_connected`; board item EC4); living significance on a frame
(`Valuation.livingSignificance`; the predicate `LivingSignificance` itself takes no valuation and
is stated in `Becoming.Extension` since R34) and the reason a sound inquiry
gives every position with access (`universal_reason`); access as a realized claim (`AccessAt`);
the instances on conditions read along a run (`Conditions.valuation` and what follows) and on
separate formations (`Separate`); the models showing each hypothesis needed (`Model`); and the
continuation condition read on the paths of a web and on conditions along a run
(`Web.paths_livingSignificance_comparison`, `Conditions.significant_of_unrestricted`).
Extension and comparison on a frame (`Extension`, `Comparison`, `LiftBetter`) and the paths of a
web (`Web.paths`) take no valuation and no condition; they are stated in `Becoming.Extension`.

Every declaration moved here unchanged, with its name, from `Becoming.Metaethics` or
`Becoming.Significance` (board item W); those of `Becoming.Extension` moved on unchanged in R31.
Every declaration has an empty axiom report.
-/

/-! ## Valuations read on frames (moved from `Becoming.Metaethics`) -/

namespace Becoming

open Generative Generative.InquirySufficiency

namespace Valuation

variable {Pos C : Type} (V : Valuation Pos C)

/-- Formed relations as a process on claims: a step reaches a related living claim. -/
def relations : Process C Unit :=
  ⟨fun c _ d => V.related c d ∧ V.living d⟩

/-- Every two living claims are linked through formed relations among living claims. -/
def Connected : Prop :=
  ∀ c d, V.living c → V.living d → Reach V.relations c d

variable {V}

/-- Under N_rel, each standpoint's significance is an invariant of the formed relations. -/
theorem transmits_invariant (neutral : Neutral V.transmits) (p : Pos) :
    Invariant V.relations (V.sig p) :=
  fun c _ d step held => neutral (p, c, d) held step.1 step.2

/-- Significance reaches every living claim linked to a valued one. -/
theorem reaches (neutral : Neutral V.transmits) {p : Pos} {c d : C}
    (linked : Reach V.relations c d) (held : V.sig p c) : V.sig p d :=
  (transmits_invariant neutral p).reach linked held


/-- **The rule of relational neutrality is closedness.** Significance transmits along formed
relations exactly where each standpoint's significance is a region closed under the relations'
steps (`Steps`, `Becoming.Frame`). -/
theorem transmits_iff_closed :
    Neutral V.transmits ↔ ∀ p, ClosedUnder (Steps V.relations) (V.sig p) :=
  ⟨fun neutral p c d held ⟨_, step⟩ => neutral (p, c, d) held step.1 step.2,
   fun closed ⟨p, c, d⟩ held related alive => closed p c d held ⟨(), related, alive⟩⟩

/-- **What the rules force is the closure.** From a living claim `c₀` significant from `p₀`, every
significance meeting the two neutralities (N_rel, N_std) gives `d` significance from `q` exactly
where `d` is reached from `c₀` through formed relations among living claims: the scope the rules
fix is the closure of the valued claim, whatever the standpoints. -/
theorem forced_iff_reach {p₀ q : Pos} {c₀ d : C} (alive₀ : V.living c₀) :
    (∀ sig : Pos → C → Prop, Neutral ({ V with sig := sig } : Valuation Pos C).transmits →
        Neutral ({ V with sig := sig } : Valuation Pos C).shares → sig p₀ c₀ → sig q d) ↔
      Reach V.relations c₀ d :=
  ⟨fun forced => forced (fun _ x => Reach V.relations c₀ x)
      (fun ⟨_, _, _⟩ reached related alive => reached.trans (Reach.of_step (a := ()) ⟨related, alive⟩))
      (fun ⟨_, _, _⟩ _ reached => reached) (Reach.refl _ c₀),
   fun reached sig transmit share held =>
     reaches (V := { V with sig := sig }) transmit reached (share (p₀, q, c₀) alive₀ held)⟩

/-- On a connected whole the grounds give living significance: what the two neutralities force from
the seed reaches every living claim, the closure being the whole (`forced_iff_reach`). -/
theorem significant_of_grounds (connected : V.Connected) : V.Grounds → V.Significant
  | ⟨⟨_, c₁, alive₁, held⟩, transmit, share⟩, _, c, alive =>
    (forced_iff_reach alive₁).mpr (connected c₁ c alive₁ alive) V.sig transmit share held

/-- Characterization of living significance's content on a connected whole with some living claim. -/
theorem significant_iff (connected : V.Connected) (p₀ : Pos) {c₀ : C}
    (alive₀ : V.living c₀) : V.Significant ↔ V.Grounds :=
  ⟨fun all => ⟨⟨p₀, c₀, alive₀, all p₀ c₀ alive₀⟩,
      fun ⟨p, _, d⟩ _ _ alive => all p d alive,
      fun ⟨_, q, c⟩ alive _ => all q c alive⟩,
    significant_of_grounds connected⟩

/-- **The whole is forced exactly where it is connected.** Every living claim is forced significant
from every standpoint by every valued living claim, under the two neutralities, exactly where the
formed relations connect the living claims: the scope reaches the whole exactly where the closure
is the whole. -/
theorem forced_whole_iff_connected (p₀ q : Pos) :
    (∀ c d, V.living c → V.living d →
        ∀ sig : Pos → C → Prop, Neutral ({ V with sig := sig } : Valuation Pos C).transmits →
          Neutral ({ V with sig := sig } : Valuation Pos C).shares → sig p₀ c → sig q d) ↔
      V.Connected :=
  ⟨fun forced c d alive alive' => (forced_iff_reach alive).mp (forced c d alive alive'),
   fun connected c d alive alive' => (forced_iff_reach alive).mpr (connected c d alive alive')⟩

end Valuation

variable {S A C Pos : Type}

/-- Claim-level significance is living significance for the frame, with relevance read as
significance from every standpoint. -/
theorem Valuation.livingSignificance (F : Frame S A C) {V : Valuation Pos C} (all : V.Significant) :
    LivingSignificance F V.living (fun _ c => ∀ p, V.sig p c) :=
  fun _ c alive _ p => all p c alive

/-- A sound inquiry whose goal is new living content gives every position with access
to it a contributory reason. Seed, N_rel, N_std and A are the normative premises;
connection and soundness are facts about the unfolding and the inquiry. -/
theorem universal_reason {R : Type} {k : Nat} (F : Frame S A C) (V : Valuation Pos C)
    (before : S → C → Prop) {safe : S → A → S → Prop} {sense : S → A → S → Fin k}
    {response : R → List A} {B : S → Prop}
    (access : Pos → Policy A R k → Prop) (Reason : Pos → Policy A R k → Prop)
    (grounds : V.Grounds) (connected : V.Connected)
    (articulate : Neutral (articulates V access (Scope F.P sense response B) before Reason))
    (policy : Policy A R k)
    (sound : Sound F.P safe (Novel F V.living before) sense response policy B) :
    ∀ p, access p policy → Reason p policy :=
  fun p available => positioned_articulation_of_articulates articulate p policy available
    fun t reached => match Scope.secures sound t reached with
      | ⟨c, alive, held, fresh⟩ =>
        ⟨c, Valuation.livingSignificance F (Valuation.significant_of_grounds connected grounds) t c alive held,
          fresh⟩

/-- Access as a realized claim: a position's access is formed in the unfolding. -/
def AccessAt {R : Type} (F : Frame S A C) (claim : Pos → R → C) (s : S) (p : Pos) (r : R) :
    Prop :=
  F.realized s (claim p r)

section Reading

open RelationalRenewal

/-- Formation events of a run read through its conditions. An event is living when
its formation is active and does not consume in the run (the relational reading of
`RenewalComparison`); two events are related when their formations participate in a
common condition. Standpoints, their regions and significance remain supplied. -/
def Conditions.valuation {F Cond : Type} {P : Process S A} (K : Conditions S F Cond)
    (r : Run P) (own sig : Pos → F × Nat → Prop) : Valuation Pos (F × Nat) where
  living e := (K.along r).active e.2 e.1 ∧ ¬ ConsumingIn (K.along r) e.1
  related e e' := ∃ c, Participates (K.along r) e.1 c ∧ Participates (K.along r) e'.1 c
  own := own
  sig := sig

namespace Conditions

variable {F Cond : Type} {P : Process S A} (K : Conditions S F Cond) (r : Run P)
  (own sig : Pos → F × Nat → Prop)

/-- A condition in which every living formation participates connects the whole. -/
theorem connected_of_common (c₀ : Cond)
    (common : ∀ e, (K.valuation r own sig).living e → Participates (K.along r) e.1 c₀) :
    (K.valuation r own sig).Connected :=
  fun c d alive alive' =>
    Reach.of_step (a := ()) ⟨⟨c₀, common c alive, common d alive'⟩, alive'⟩

/-- With a condition in which every living formation participates, living significance for every
standpoint is exactly a seed with N_rel and N_std. Connection follows from
co-participation, given which conditions are counted. -/
theorem significant_iff_of_common (c₀ : Cond)
    (common : ∀ e, (K.valuation r own sig).living e → Participates (K.along r) e.1 c₀)
    (p₀ : Pos) {e₀ : F × Nat} (alive₀ : (K.valuation r own sig).living e₀) :
    (K.valuation r own sig).Significant ↔ (K.valuation r own sig).Grounds :=
  Valuation.significant_iff (connected_of_common K r own sig c₀ common) p₀ alive₀

/-- A consuming formation and a formation that loses its support from some step on
co-participate in the drawn condition, so their events are related. -/
theorem consumption_relates {f : F} (consuming : ConsumingIn (K.along r) f) :
    ∃ g T, (∀ t, T ≤ t → ¬ Supported (K.along r) t g) ∧
      ∀ t t', (K.valuation r own sig).related (f, t) (g, t') :=
  match consuming with
  | ⟨c, drawn, g, T, depends, lost⟩ =>
    ⟨g, T, fun t after supported => Nat.not_le_of_gt (lost t after) (supported c depends),
      fun _ _ => ⟨c, Or.inr drawn, Or.inl depends⟩⟩

/-- Under N_rel, a standpoint that values a consuming formation's activity holds
significant every living event of a formation that loses its support to the consumed
condition. The transmission runs along co-participation; it does not use the
consumption. Under the relational reading the consumer's own events are not living,
so S0 alone supplies no such valuation. N_rel's rival needs a boundary, or a narrower
account of which co-participation is a formed relation. -/
theorem valuing_consumption_reaches (transmit : Neutral (K.valuation r own sig).transmits)
    {f : F} (consuming : ConsumingIn (K.along r) f) :
    ∃ g T, (∀ t, T ≤ t → ¬ Supported (K.along r) t g) ∧
      ∀ p t t', (K.valuation r own sig).sig p (f, t) →
        (K.valuation r own sig).living (g, t') → (K.valuation r own sig).sig p (g, t') :=
  match consumption_relates K r own sig consuming with
  | ⟨g, T, lost, related⟩ =>
    ⟨g, T, lost, fun p t t' held alive => transmit (p, (f, t), (g, t')) held (related t t') alive⟩

end Conditions

namespace Separate

def frame : Process Unit Unit := ⟨fun _ _ _ => True⟩

def still : Run frame := ⟨fun _ => (), fun _ => (), fun _ => trivial⟩

theorem not_connected (own sig : Unit → Bool × Nat → Prop) :
    ¬ (conditions.valuation still own sig).Connected := fun connected =>
  Bool.noConfusion (Invariant.reach (P := (conditions.valuation still own sig).relations)
    (I := fun e => e.1 = false) (fun e _ e' step => stays e e' step.1)
    (connected (false, 0) (true, 0) ⟨trivial, fun ⟨_, drawn, _⟩ => drawn⟩
      ⟨trivial, fun ⟨_, drawn, _⟩ => drawn⟩) rfl)

end Separate

namespace Web

variable {F Cond : Type} (W : Web F Cond) (own sig : Pos → F × Nat → Prop)

/-- A condition in which every living event participates connects the whole. -/
theorem connected_of_common (c₀ : Cond)
    (common : ∀ e, (W.valuation own sig).living e → W.Participates e.2 e.1 c₀) :
    (W.valuation own sig).Connected :=
  fun c d alive alive' =>
    Reach.of_step (a := ()) ⟨⟨c₀, common c alive, common d alive'⟩, alive'⟩

/-- With a condition in which every living event participates, living significance for every standpoint
is exactly a seed with N_rel and N_std, on the stepwise reading as on the whole-run
one. -/
theorem significant_iff_of_common (c₀ : Cond)
    (common : ∀ e, (W.valuation own sig).living e → W.Participates e.2 e.1 c₀)
    (p₀ : Pos) {e₀ : F × Nat} (alive₀ : (W.valuation own sig).living e₀) :
    (W.valuation own sig).Significant ↔ (W.valuation own sig).Grounds :=
  Valuation.significant_iff (connected_of_common W own sig c₀ common) p₀ alive₀

end Web

/-- On fixed dependences the stepwise reading relates exactly the events the whole-run
reading relates; the readings differ only in which events are living. -/
theorem Conditions.stepwise_related {F Cond : Type} {P : Process S A} (K : Conditions S F Cond)
    (r : Run P) (own sig : Pos → F × Nat → Prop) :
    ((K.dependence.along r).valuation own sig).related = (K.valuation r own sig).related :=
  rfl

/-- In one process the two readings include different events, in both directions. In
the escalating run the focal formation consumes, so the whole-run reading counts none
of its events as living, while the stepwise reading includes its first. In the dipping
run it does not consume, since the condition returns, so the whole-run reading counts
its first event as living, while the stepwise reading does not: it draws at a step
that breaks the sustaining formation's dependence. Both readings include the sustaining
formation's event at the step that breaks its dependence. -/
theorem Renewable.readings_differ (own sig : Pos → Renewable.Formation × Nat → Prop) :
    ((Renewable.conditions.dependence.along Renewable.escalating).valuation own sig).living
      (.focal, 0) ∧
    ¬ (Renewable.conditions.valuation Renewable.escalating own sig).living (.focal, 0) ∧
    (Renewable.conditions.valuation Renewable.dipping own sig).living (.focal, 0) ∧
    ¬ ((Renewable.conditions.dependence.along Renewable.dipping).valuation own sig).living
      (.focal, 0) ∧
    (Renewable.conditions.valuation Renewable.escalating own sig).living (.sustaining, 1) ∧
    ((Renewable.conditions.dependence.along Renewable.escalating).valuation own sig).living
      (.sustaining, 1) :=
  match Renewable.broken_formation with
  | ⟨active, _, _, victim⟩ =>
    ⟨⟨trivial, Renewable.stepwise_includes_before_escalation.2.1.not_undermining⟩,
     fun ⟨_, notConsuming⟩ => notConsuming
       ((Web.static_consumingIn _ _).mp Renewable.stepwise_includes_before_escalation.1),
     ⟨trivial, fun consuming => Renewable.dip_breaks_without_consuming.1
       ((Web.static_consumingIn _ _).mpr consuming)⟩,
     fun ⟨_, notUndermining⟩ => notUndermining
       ⟨(), trivial, .sustaining, trivial,
         ⟨0, Nat.le_refl 0, fun _ _ _ => trivial, Nat.le_refl 1, Nat.le_refl _⟩, Nat.zero_lt_one⟩,
     ⟨active, fun ⟨_, drawn, _⟩ => drawn⟩, ⟨active, victim⟩⟩

end Reading

namespace Model

theorem linked_connected (sig : Who → Life → Prop) : (valuation linked sig).Connected
  | .self, .self, _, _ => Reach.refl _ _
  | .other, .other, _, _ => Reach.refl _ _
  | .self, .other, _, _ => Reach.of_step (a := ()) ⟨trivial, trivial⟩
  | .other, .self, _, _ => Reach.of_step (a := ()) ⟨trivial, trivial⟩
  | .beyond, _, dead, _ => nomatch dead
  | _, .beyond, _, dead => nomatch dead

/-- Present aim: no seed. Both neutralities hold vacuously; nothing is significant. -/
theorem seed_is_needed :
    let V := valuation linked (fun _ _ => False)
    V.Connected ∧ ¬ V.Seed ∧ Neutral V.transmits ∧ Neutral V.shares ∧ ¬ V.Significant :=
  ⟨linked_connected _, fun ⟨_, _, _, held⟩ => held,
    fun ⟨_, _, _⟩ held => (nomatch held), fun ⟨_, _, _⟩ _ held => (nomatch held),
    fun all => all .evaluator .self trivial⟩

/-- N_rel is needed. The rival holds S0, a seed and N_std, and transmits significance
only inside the evaluator's own region. -/
theorem relational_neutrality_is_needed :
    let V := valuation linked ownRegion
    V.Connected ∧ V.SelfSignificance .evaluator ∧ V.Seed ∧ Neutral V.shares ∧
    Within (fun i => own .evaluator i.2.2) V.transmits ∧
    ¬ Neutral V.transmits ∧ ¬ V.Significant :=
  ⟨linked_connected _,
    fun | .self, _, _ => trivial
        | .other, owned, _ => (nomatch owned)
        | .beyond, owned, _ => (nomatch owned),
    ⟨.evaluator, .self, trivial, trivial⟩,
    fun | (_, _, .self), _, _ => trivial
        | (_, _, .other), _, held => held
        | (_, _, .beyond), dead, _ => dead,
    fun | (_, _, .self), _, _, _, _ => trivial
        | (_, _, .other), bound, _, _, _ => (nomatch bound)
        | (_, _, .beyond), bound, _, _, _ => (nomatch bound),
    fun neutral => neutral (.evaluator, .self, .other) trivial trivial trivial,
    fun all => all .evaluator .other trivial⟩

/-- N_std is needed. The rival holds a seed and N_rel at every standpoint, and shares
significance only with its own standpoint. -/
theorem standpoint_neutrality_is_needed :
    let V := valuation linked ownStandpoint
    V.Connected ∧ V.Seed ∧ Neutral V.transmits ∧
    Within (fun i => i.1 = i.2.1) V.shares ∧
    ¬ Neutral V.shares ∧ ¬ V.Significant :=
  ⟨linked_connected _, ⟨.evaluator, .self, trivial, trivial⟩,
    fun | (.evaluator, _, _), _, _, _ => trivial
        | (.bystander, _, _), held, _, _ => held,
    fun | (_, _, _), rfl, _, held => held,
    fun neutral => neutral (.evaluator, .bystander, .self) trivial trivial,
    fun all => all .bystander .self trivial⟩

/-- No path of formed relations enters `beyond` from elsewhere. -/
theorem isolated {living : Life → Prop} {sig : Who → Life → Prop} :
    ∀ {c : Life} {word : List Unit},
      Trace (valuation living sig).relations c word .beyond → c = .beyond
  | _, _, .nil _ => rfl
  | _, _, .cons step rest => by
    have entered := isolated rest
    subst entered
    exact absurd step.1 (no_relation_into_beyond _)

/-- Connection is needed: with an unrelated living claim, every premise holds and
significance stops where formed relations stop. -/
theorem connection_is_needed :
    let V := valuation (fun _ => True) (fun _ c => linked c)
    V.Grounds ∧ ¬ V.Connected ∧ ¬ V.Significant :=
  ⟨⟨⟨.evaluator, .self, trivial, trivial⟩,
      fun | (_, _, .self), _, _, _ => trivial
          | (_, _, .other), _, _, _ => trivial
          | (_, c, .beyond), _, rel, _ => absurd rel (no_relation_into_beyond c),
      fun | (_, _, _), _, held => held⟩,
    fun connected => match connected .self .beyond trivial trivial with
      | ⟨_, path⟩ => Life.noConfusion (isolated path),
    fun all => all .evaluator .beyond trivial⟩

end Model

end Becoming

/-! ## The continuation condition on frames and on the paths of a web (moved from `Becoming.Significance`) -/

namespace Becoming

open Generative

variable {F C Pos : Type}

/-- Read through a run, living significance follows from the continuation condition the same way. -/
theorem Conditions.significant_of_unrestricted {S A Cond : Type} {P : Process S A}
    (K : Conditions S F Cond) (r : Run P) {sig : Pos → Nat → F → Prop}
    (unrestricted : Unrestricted sig) (own : Pos → F × Nat → Prop) :
    (K.valuation r own fun p e => sig p e.2 e.1).Significant :=
  fun p e _ => unrestricted (p, e.2, e.1)

/-- On level paths, under the continuation condition, living significance holds with unindexed significance for every reading of
`living`, and so does C, with “better” read as retaining and adding what has significance. -/
theorem Web.paths_livingSignificance_comparison (W : Web F C) {sig : Pos → Nat → F → Prop}
    (unrestricted : Unrestricted sig) (living : F × Nat → Prop) (p : Pos) :
    LivingSignificance W.paths living (fun _ e => ∀ q, sig q e.2 e.1) ∧
      Comparison W.paths living fun l' l => W.Retains sig p l l' ∧ W.Adds sig p l l' :=
  ⟨fun _ e _ _ q => unrestricted (q, e.2, e.1),
   fun _ _ ⟨keeps, e, _, realized, fresh⟩ =>
     ⟨fun t f _ admits => keeps (f, t) admits,
      ⟨e.2, e.1, unrestricted (p, e.2, e.1), realized, fresh⟩⟩⟩

end Becoming
