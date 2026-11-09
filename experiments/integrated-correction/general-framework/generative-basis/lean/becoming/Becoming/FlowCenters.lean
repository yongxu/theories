import Becoming.Centers
import Becoming.MutualDependence
import Becoming.Weightings
import Becoming.GrammarScope

/-!
# FlowCenters: the standpoints and the relation read off a flow

Read as lying within a center's own closure along a relation (`ownClosure`, held de se by
`selfAscribed`), significance makes the continuation condition exactly that every center's closure
is the whole (`ownClosure_unrestricted_iff`). There the relation and the centers are supplied:
`rel : F → F → Prop` and `center : Pos → F`. This module reads both off a flow. The relation is one
of the flow's own: affecting, being affected or feeding. The standpoints, each its own center, are
read two ways: every formation, as 03 reads them; or only the formations whose acts return
(`Flow.ReachReturns` of `Becoming.Centers`).

* **Every formation its own center.** Where every formation is some standpoint's center, held de
  se along affecting or along being affected the presupposition is the continuation condition
  exactly where the flow is mutually dependent (route (b)'s G3 piece,
  `Flow.mutuallyDependent_iff_unrestricted`, not imported here), and along feeding exactly where it
  is mutually fed (`Flow.mutuallyFed_iff_unrestricted`). With every formation that exchanges with
  some condition a standpoint, each such formation lies within its own closure, by reflexivity
  alone, and a formation that exchanges with nothing is covered only if some standpoint's closure
  holds it; so read, covering from activity is near-definitional (`Flow.covering_of_acting`).
* **Returning along a relation.** An element returns along a relation where whatever lies within
  its closure has it within its own (`ReturnsAlong`); along affecting this is `Flow.ReachReturns`
  (`Flow.reachReturns_iff_returnsAlong`). A returning element's own closure is its loop
  (`ReturnsAlong.loop`). One returning element whose closure is the whole makes every closure the
  whole (`ReturnsAlong.whole`). So, held de se at the returning elements and given one, the
  presupposition is the continuation condition exactly where every closure is the whole
  (`ownClosure_unrestricted_atReturning_iff`). With none, it holds vacuously, as there is no
  standpoint (`ownClosure_unrestricted_of_none`). It is standpoint-invariant exactly where any two
  returning elements lie in one loop (`ownClosure_standpointInvariant_atReturning_iff`).
* **The returning formations as the standpoints.** Held de se along affecting at the formations
  whose acts return (`Flow.Returning`), given one of them, the presupposition is the continuation
  condition exactly where the flow is mutually dependent
  (`Flow.returning_unrestricted_iff_mutuallyDependent`; the direction from the condition,
  `Flow.mutuallyDependent_of_returning_unrestricted`, is the one route (b)'s joining lemma,
  `Flow.unrestricted_of_mutuallyDependent`, G3's and not imported here, does not give; on the root,
  `«续无外»` at the one of affecting, `Flow.mutuallyDependent_of_returning_noOutside`). So along
  affecting the two readings of the standpoints give one condition, as with every formation a
  center: a property of the flow alone.
  Under mutual dependence every formation's acts return (`Flow.MutuallyDependent.reachReturns`).
  The step from each standpoint's own continuation, at the returning formations, gives the
  condition exactly where every formation's acts return (`Flow.atReturning_unrestricted_iff`).
* **Finitely many formations: covering, and the relation reversed.** With finitely many formations
  listed and reach decided, every formation lies within the influence closure of one whose acts
  return (`Flow.covered_by_returning`, from `Flow.exists_reachReturns`), so that where there is a
  formation, some formation's acts return. So the
  step across standpoints, drawn along being affected at the returning formations, gives the
  condition on every such flow, covering met by the flow rather than by making every formation a
  standpoint (`Flow.unrestricted_of_returning_standpointInvariant`). Held de se along being affected
  at the returning formations, with no step, the presupposition is the condition exactly where they
  lie in one loop (`Flow.returning_influence_unrestricted_iff`), which is exactly where, held de se
  along affecting at them, it is standpoint-invariant
  (`Flow.returning_influence_unrestricted_iff_invariant`). That is weaker than mutual dependence:
  one formation that everything else can affect at some remove and that affects nothing beyond
  itself is enough. There the two readings of the standpoints part.
* **Where the returning formations and a supplied center part.** In `Clearing` the only formation
  whose acts return is the dweller, which acts on nothing; the clearer's and the source's do not
  (`Clearing.reachReturns_iff`). Held de se along being affected, the presupposition is the
  condition at the returning formations, and is not with the clearer as the one center supplied;
  along affecting it is not, and the flow is not mutually dependent (`Clearing.returning_apart`).
  Under that one reading the clearer's part retains with the clearer as the one center and loses
  the dweller from the dweller (`Clearing.returning_loses_dweller`): the verdict changes with the
  center alone.
* **The relation still matters.** In `Drawing`, a balanced pair each taking from what the other
  depends on, every formation's acts return; held de se at them the presupposition is the condition
  along affecting and along being affected, and not along feeding
  (`Drawing.returning_feeding_apart`).
* **Failed candidates, kept.** Covering from activity along feeding, by the returning formations:
  in `Clearing` the clearer takes from its resource, and lies within the feeding closure of no
  formation whose acts return (`Clearing.clearer_beyond_returning_feeding`). Standpoints read as bearing on
  themselves (`Web.SelfBearing`) as well as returning: in `Unexchanged` every formation's acts
  return and none bears on itself, so that reading has no standpoint and, there being formations,
  covers none of them; there the
  step from each standpoint's own continuation at the returning formations gives the condition,
  and the de se condition along affecting fails (`Unexchanged.apart`).

Premises: the relation and the standpoints are read off one flow and one web, as in
`Becoming.Feedback` and `Becoming.Centers`. The relations are read across all steps (a dependence
at some step, an exchange at some step) and own closure ignores its step, so nothing here is about
order in time. Exchanging counts taking as well as giving, so mutual dependence includes mutual
drain (`Drawing`): it is not mutual benefit. Which flow relation a center's own closure is drawn
along (affecting, being affected, feeding) is still a choice: the laws above differ by it. Which
formations are the standpoints (every formation, or those whose acts return) is a reading, not
something the flow fixes; the two agree along affecting and part along being affected. The class
stays the one of the relation, as the own-closure reading takes it
(`ownClosure_unrestricted_iff_noOutside`); which class a center's own line runs under is not read
here. Reading significance as own closure is itself a reading (07 §1). Finitely many formations and
decided reach where stated. Every law here is a short composition: the substance it draws on is
`Flow.exists_reachReturns` (a returning formation in every formation's reach, on finitely many) and
the closure laws. No ethical premise, and no Lean axiom is used.
-/

namespace Becoming

/-! ## Returning along a relation -/

section Returning

variable {X : Type}

/-- `c` *returns* along a relation: whatever lies within its closure has `c` within its own
closure. Along affecting this is `Flow.ReachReturns`: whatever a formation can affect can affect
it. -/
def ReturnsAlong (rel : X → X → Prop) (c : X) : Prop :=
  ∀ g, WithinClosure rel c g → WithinClosure rel g c

/-- The elements returning along a relation, each a standpoint and its own center. -/
abbrev Returning (rel : X → X → Prop) : Type := {c : X // ReturnsAlong rel c}

variable {rel : X → X → Prop}

/-- A returning element's own closure is its loop: what lies within it has the element within its
own closure. -/
theorem ReturnsAlong.loop {c g : X} (returns : ReturnsAlong rel c)
    (within : WithinClosure rel c g) : WithinClosure rel c g ∧ WithinClosure rel g c :=
  ⟨within, returns g within⟩

/-- Where every closure is the whole, every element returns. -/
theorem returnsAlong_of_whole (whole : ∀ f g, WithinClosure rel f g) (c : X) :
    ReturnsAlong rel c :=
  fun g _ => whole g c

/-- **One returning element whose closure is the whole makes every closure the whole.** -/
theorem ReturnsAlong.whole {c : X} (returns : ReturnsAlong rel c)
    (whole : ∀ g, WithinClosure rel c g) : ∀ f g, WithinClosure rel f g :=
  fun f g => (returns f (whole f)).trans (whole g)

/-- **Held de se at the returning elements, the presupposition is the continuation condition
exactly where every closure is the whole**, given one returning element. -/
theorem ownClosure_unrestricted_atReturning_iff (some : ∃ c, ReturnsAlong rel c) :
    Unrestricted (selfAscribed (ownClosure rel) (Subtype.val : Returning rel → X)) ↔
      ∀ f g, WithinClosure rel f g :=
  match some with
  | ⟨c, returns⟩ =>
    ⟨fun unrestricted => returns.whole (ownClosure_unrestricted_iff.mp unrestricted ⟨c, returns⟩),
     fun whole => ownClosure_unrestricted_of_whole fun p g => whole p.1 g⟩

/-- With no returning element there is no standpoint, and the condition holds at the returning
elements vacuously. -/
theorem ownClosure_unrestricted_of_none (none : ∀ c, ¬ ReturnsAlong rel c) :
    Unrestricted (selfAscribed (ownClosure rel) (Subtype.val : Returning rel → X)) :=
  fun i => absurd i.1.2 (none i.1.1)

/-- **Held de se at the returning elements, the presupposition is standpoint-invariant exactly
where any two of them lie in one loop**: each within the other's closure. -/
theorem ownClosure_standpointInvariant_atReturning_iff :
    StandpointInvariant (selfAscribed (ownClosure rel) (Subtype.val : Returning rel → X)) ↔
      ∀ c c' : Returning rel, WithinClosure rel c.1 c'.1 :=
  ownClosure_standpointInvariant_iff_centersWithin

end Returning

/-! ## The standpoints read off a flow -/

namespace Flow

variable {F C : Type} {L : Flow F C} {W : Web F C}

/-- **Where every formation is some standpoint's center, held de se along feeding, the
presupposition is the continuation condition exactly where the flow is mutually fed.** Along
affecting and along being affected it is mutual dependence (`Flow.mutuallyDependent_iff_unrestricted`,
route (b)'s G3 piece, not imported here); along feeding it is the stronger mutual feeding. The
forward half is `Flow.MutuallyFed.unrestricted`. -/
theorem mutuallyFed_iff_unrestricted {Pos : Type} {center : Pos → F}
    (onto : ∀ f, ∃ p, center p = f) :
    L.MutuallyFed W ↔ Unrestricted (selfAscribed (ownClosure (L.FedFrom W)) center) :=
  ⟨fun fed => fed.unrestricted center,
   fun unrestricted f g => match onto f with
     | ⟨p, at_⟩ => Eq.subst (motive := fun x => L.WithinFeeding W x g) at_
         (ownClosure_unrestricted_iff.mp unrestricted p g)⟩

/-- **Covering from activity, read with every formation that exchanges with some condition a
standpoint.** Every such formation lies within some such standpoint's closure, along any relation:
its own, by reflexivity. Near-definitional. -/
theorem covering_of_acting (rel : F → F → Prop) {g : F} (acts : ∃ c, L.Exchanges g c) :
    ∃ p : {f : F // ∃ c, L.Exchanges f c}, WithinClosure rel p.1 g :=
  ⟨⟨g, acts⟩, WithinClosure.refl g⟩

/-- **The formations whose acts return**, read as the standpoints, each its own center. -/
abbrev Returning (L : Flow F C) (W : Web F C) : Type := Becoming.Returning (L.Affects W)

/-- A formation's acts return exactly where it returns along affecting. -/
theorem reachReturns_iff_returnsAlong {c : F} :
    L.ReachReturns W c ↔ ReturnsAlong (L.Affects W) c :=
  Iff.rfl

/-- **Held de se along affecting at the returning formations, the presupposition is the
continuation condition only where the flow is mutually dependent**, given one of them: its reach is
the whole, and whatever it reaches reaches it back. -/
theorem mutuallyDependent_of_returning_unrestricted (some : ∃ c, L.ReachReturns W c)
    (unrestricted :
      Unrestricted (selfAscribed (ownClosure (L.Affects W)) (Subtype.val : L.Returning W → F))) :
    L.MutuallyDependent W :=
  mutuallyDependent_iff_reach.mpr ((ownClosure_unrestricted_atReturning_iff some).mp unrestricted)

/-- **Held de se along affecting at the returning formations, the presupposition is the
continuation condition exactly where the flow is mutually dependent**, given one of them: the first
law with mutual dependence read forward. Its backward half is also route (b)'s joining lemma
(`Flow.unrestricted_of_mutuallyDependent`, G3's, not imported here) at these centers. -/
theorem returning_unrestricted_iff_mutuallyDependent (some : ∃ c, L.ReachReturns W c) :
    Unrestricted (selfAscribed (ownClosure (L.Affects W)) (Subtype.val : L.Returning W → F)) ↔
      L.MutuallyDependent W :=
  (ownClosure_unrestricted_atReturning_iff some).trans mutuallyDependent_iff_reach.symm

/-- **On the root, at the returning formations and along affecting, the condition `«续无外»` holds
only where the flow is mutually dependent**, given one of them: `ownClosure_unrestricted_iff_noOutside`
with the relation and the centers read off the flow, the class the one of affecting. -/
theorem mutuallyDependent_of_returning_noOutside (some : ∃ c, L.ReachReturns W c)
    (none : «续无外» (L.Affects W) «一» (Subtype.val : L.Returning W → F)) :
    L.MutuallyDependent W :=
  mutuallyDependent_of_returning_unrestricted some (ownClosure_unrestricted_iff_noOutside.mpr none)

/-- **Under mutual dependence every formation's acts return**: the two readings of the
standpoints are then one. -/
theorem MutuallyDependent.reachReturns (dependent : L.MutuallyDependent W) (c : F) :
    L.ReachReturns W c :=
  fun g _ => mutuallyDependent_iff_reach.mp dependent g c

/-- **At the returning formations, the step from each standpoint's own continuation gives the
condition exactly where every formation's acts return**, given one of them. -/
theorem atReturning_unrestricted_iff (some : ∃ c, L.ReachReturns W c) :
    Unrestricted (atCenters (Subtype.val : L.Returning W → F)) ↔ ∀ g, L.ReachReturns W g :=
  match some with
  | ⟨c, returns⟩ => (unrestricted_atCenters_iff (⟨c, returns⟩ : L.Returning W)).trans
      ⟨fun every g => match every g with
        | ⟨q, same⟩ => Eq.subst (motive := fun x => L.ReachReturns W x) same q.2,
       fun every g => ⟨⟨g, every g⟩, rfl⟩⟩

/-! ### Finitely many formations -/

/-- **Covering by the returning formations.** With finitely many formations listed and reach
decided, every formation lies within the influence closure of a formation whose acts return. -/
theorem covered_by_returning (members : List F) (listed : ∀ g, g ∈ members)
    (decided : ∀ a b, Decidable (L.WithinReach W a b)) (g : F) :
    ∃ c : L.Returning W, L.WithinInfluence W c.1 g :=
  match exists_reachReturns members listed decided g with
  | ⟨c, within, returns⟩ => ⟨⟨c, returns⟩, withinReach_iff_influence.mp within⟩

/-- **The step across standpoints, at the returning formations and along being affected, gives
the continuation condition on every finite flow.** With finitely many formations listed and reach
decided, every significance that makes each returning formation's presupposition sub-true at its
influence closure and is standpoint-invariant is the continuation condition: covering is met by
the flow, not supplied. -/
theorem unrestricted_of_returning_standpointInvariant (members : List F)
    (listed : ∀ g, g ∈ members) (decided : ∀ a b, Decidable (L.WithinReach W a b))
    {sig : L.Returning W → Nat → F → Prop}
    (presupposed : ∀ p : L.Returning W, SubTrue (Boundary (L.AffectedBy W) p.1)
      (SignificantWithin sig p))
    (invariant : StandpointInvariant sig) : Unrestricted sig :=
  unrestricted_of_standpointInvariant (rel := L.AffectedBy W) (center := Subtype.val)
    (covered_by_returning members listed decided) presupposed invariant

/-- **Held de se along being affected at the returning formations, the presupposition is the
continuation condition exactly where they lie in one loop**, with finitely many formations listed
and reach decided: every formation reaches some returning formation, and so every one. -/
theorem returning_influence_unrestricted_iff (members : List F) (listed : ∀ g, g ∈ members)
    (decided : ∀ a b, Decidable (L.WithinReach W a b)) :
    Unrestricted (selfAscribed (ownClosure (L.AffectedBy W)) (Subtype.val : L.Returning W → F)) ↔
      ∀ c c' : L.Returning W, L.WithinReach W c.1 c'.1 :=
  ⟨fun unrestricted c c' => c'.2 c.1
      (withinReach_iff_influence.mpr (ownClosure_unrestricted_iff.mp unrestricted c c'.1)),
   fun oneLoop => ownClosure_unrestricted_iff.mpr fun c g =>
     match exists_reachReturns members listed decided g with
     | ⟨c'', within, returns⟩ =>
       withinReach_iff_influence.mp (within.trans (oneLoop ⟨c'', returns⟩ c))⟩

/-- **Held de se at the returning formations, the presupposition along being affected is the
condition exactly where along affecting it is standpoint-invariant**, with finitely many formations
listed and reach decided. -/
theorem returning_influence_unrestricted_iff_invariant (members : List F)
    (listed : ∀ g, g ∈ members) (decided : ∀ a b, Decidable (L.WithinReach W a b)) :
    Unrestricted (selfAscribed (ownClosure (L.AffectedBy W)) (Subtype.val : L.Returning W → F)) ↔
      StandpointInvariant
        (selfAscribed (ownClosure (L.Affects W)) (Subtype.val : L.Returning W → F)) :=
  (returning_influence_unrestricted_iff members listed decided).trans
    ownClosure_standpointInvariant_atReturning_iff.symm

end Flow

/-! ## Where the returning formations and a supplied center part: `Clearing` -/

namespace Clearing

/-- Nothing the dweller affects lies outside it: it exchanges with nothing. -/
theorem dweller_reach_closed : ClosedUnder (flow.Affects web) (fun x => x = Formation.dweller) :=
  fun x _ inside ⟨_, _, _, _, exchanges⟩ => match x, inside, exchanges with
    | _, rfl, .inl takes => absurd takes (Nat.lt_irrefl 0)
    | _, rfl, .inr gives => absurd gives (Nat.lt_irrefl 0)

/-- The dweller's acts return: it reaches only itself. -/
theorem dweller_returns : flow.ReachReturns web .dweller :=
  fun _ within =>
    Eq.subst (motive := fun x => flow.WithinReach web x .dweller)
      (within (fun x => x = Formation.dweller) dweller_reach_closed rfl).symm
      (WithinClosure.refl _)

/-- The clearer's acts do not return: it affects the dweller, which cannot affect it. -/
theorem clearer_not_returns : ¬ flow.ReachReturns web .clearer :=
  fun returns => reach_centred (returns .dweller reach_middle.1)

/-- The source's acts do not return: it affects the clearer, which cannot affect it. -/
theorem source_not_returns : ¬ flow.ReachReturns web .source :=
  fun returns => reach_middle.2.1 (returns .clearer
    (WithinClosure.of_rel ⟨.resource, ⟨0, trivial⟩, 0, .head _, .inr Nat.zero_lt_one⟩))

/-- **The only formation whose acts return is the dweller.** -/
theorem reachReturns_iff : ∀ f, flow.ReachReturns web f ↔ f = .dweller
  | .source => ⟨fun returns => absurd returns source_not_returns, fun same => nomatch same⟩
  | .clearer => ⟨fun returns => absurd returns clearer_not_returns, fun same => nomatch same⟩
  | .dweller => ⟨fun _ => rfl, fun _ => dweller_returns⟩

/-- The dweller's influence closure is the whole: the clearer takes from its habitat, and the
source gives to the clearer's resource. -/
theorem dweller_influence_whole : ∀ g, flow.WithinInfluence web .dweller g
  | .dweller => WithinClosure.refl _
  | .clearer => WithinClosure.of_rel ⟨.habitat, ⟨0, trivial⟩, 0, .tail _ (.head _), .inl Nat.zero_lt_one⟩
  | .source => (WithinClosure.of_rel
      ⟨.habitat, ⟨0, trivial⟩, 0, .tail _ (.head _), .inl Nat.zero_lt_one⟩ :
        flow.WithinInfluence web .dweller .clearer).trans reach_middle.2.2.1

/-- **The returning formations and a supplied center part.** The only formation whose acts
return is the dweller. Held de se along being affected, the presupposition is the continuation
condition at the returning formations, and is not with the clearer as the one center; held de se
along affecting at the returning formations it is not, and the flow is not mutually dependent. -/
theorem returning_apart :
    (∀ f, flow.ReachReturns web f ↔ f = .dweller) ∧
      Unrestricted (selfAscribed (ownClosure (flow.AffectedBy web))
        (Subtype.val : flow.Returning web → Formation)) ∧
      ¬ Unrestricted (selfAscribed (ownClosure (flow.AffectedBy web))
        (fun (_ : Unit) => Formation.clearer)) ∧
      ¬ Unrestricted (selfAscribed (ownClosure (flow.Affects web))
        (Subtype.val : flow.Returning web → Formation)) ∧
      ¬ flow.MutuallyDependent web :=
  ⟨reachReturns_iff,
   ownClosure_unrestricted_iff.mpr fun p g =>
     Eq.subst (motive := fun x => flow.WithinInfluence web x g)
       ((reachReturns_iff p.1).mp p.2).symm (dweller_influence_whole g),
   fun unrestricted => levels.2.1 (ownClosure_unrestricted_iff.mp unrestricted () .dweller),
   fun unrestricted =>
     reach_centred (ownClosure_unrestricted_iff.mp unrestricted ⟨.dweller, dweller_returns⟩ .clearer),
   shares_not_mutual.2⟩

/-- **The verdicts part with the center.** Under one reading, significance held de se along being
affected, the clearer's part retains with the clearer as the one center, the dweller lying beyond
the clearer's influence closure, and loses the dweller from the dweller, the formation whose acts
return. -/
theorem returning_loses_dweller {l : Nat → Place → Nat}
    (without : flow.WithheldLevels clearerPart web l) :
    web.Retains (selfAscribed (ownClosure (flow.AffectedBy web))
        (fun (_ : Unit) => Formation.clearer)) () web.level l ∧
      ¬ web.Retains (selfAscribed (ownClosure (flow.AffectedBy web))
        (Subtype.val : flow.Returning web → Formation)) ⟨.dweller, dweller_returns⟩ web.level l :=
  ⟨(Web.retains_bounded_iff
      (region := fun (_ : Unit) g => flow.WithinInfluence web .clearer g)).mpr fun t =>
        ((loses_beyond without).1 t).2.2.narrow
          fun _ within => within alongDependence alongDependence_closed trivial,
   (clearer_loses_dweller without returning_apart.2.1 ⟨.dweller, dweller_returns⟩).2.1⟩

/-- Nothing feeds the dweller's continuation: nothing gives to its habitat. -/
theorem dweller_feeding_closed :
    ClosedUnder (flow.FedFrom web) (fun x => x = Formation.dweller) :=
  fun x y inside fed => match x, inside, fed with
    | _, rfl, ⟨_, _, .habitat, _, _, gives⟩ => match y, gives with
      | .source, gives => absurd gives (Nat.lt_irrefl 0)
      | .clearer, gives => absurd gives (Nat.lt_irrefl 0)
      | .dweller, gives => absurd gives (Nat.lt_irrefl 0)
    | _, rfl, ⟨_, _, .resource, no, _, _⟩ => nomatch no
    | _, rfl, ⟨_, _, .fuel _, no, _, _⟩ => nomatch no

/-- **Covering from activity along feeding, by the returning formations, fails.** The clearer
takes part, taking from its resource, and lies within the feeding closure of no formation whose acts
return. -/
theorem clearer_beyond_returning_feeding :
    flow.Exchanges .clearer .resource ∧
      ∀ c : flow.Returning web, ¬ flow.WithinFeeding web c.1 .clearer :=
  ⟨⟨0, .tail _ (.head _), .inl Nat.zero_lt_one⟩,
   fun c within => nomatch
     (within (fun x => x = Formation.dweller) dweller_feeding_closed ((reachReturns_iff c.1).mp c.2))⟩

end Clearing

/-! ## Along feeding, not: `Drawing` -/

namespace Drawing

/-- **The relation still matters.** In `Drawing`, a balanced pair each taking from the condition the
other depends on, every formation's acts return. Held de se at them along affecting or along being
affected, the presupposition is the continuation condition; along feeding it is not, since nothing
gives. -/
theorem returning_feeding_apart :
    (∀ c, flow.ReachReturns web c) ∧
      Unrestricted (selfAscribed (ownClosure (flow.Affects web))
        (Subtype.val : flow.Returning web → Bool)) ∧
      Unrestricted (selfAscribed (ownClosure (flow.AffectedBy web))
        (Subtype.val : flow.Returning web → Bool)) ∧
      ¬ Unrestricted (selfAscribed (ownClosure (flow.FedFrom web))
        (Subtype.val : flow.Returning web → Bool)) :=
  have returns := Flow.MutuallyDependent.reachReturns mutuallyDependent
  ⟨returns,
   (Flow.returning_unrestricted_iff_mutuallyDependent ⟨true, returns true⟩).mpr mutuallyDependent,
   ownClosure_unrestricted_iff.mpr fun p g => mutuallyDependent p.1 g,
   fun unrestricted =>
     mutual_not_fed.2.2.1 (ownClosure_unrestricted_iff.mp unrestricted ⟨true, returns true⟩ false)⟩

end Drawing

/-! ## Every formation returning, and none bearing on itself: `Unexchanged` -/

namespace Unexchanged

/-- Two formations, taking part and exchanging nothing. -/
def flow : Flow Bool Bool where
  present _ := [true, false]
  take _ _ _ := 0
  give _ _ _ := 0

/-- Both active, neither requiring anything. -/
def web : Web Bool Bool where
  level _ _ := 1
  active _ _ := True
  requires _ _ _ := False
  need _ _ _ := 1
  draws _ _ _ := False

/-- Nothing affects anything. -/
theorem not_affects (f g : Bool) : ¬ flow.Affects web f g :=
  fun ⟨_, ⟨_, no⟩, _⟩ => no

/-- Each formation reaches only itself. -/
theorem reach_self {f g : Bool} (within : flow.WithinReach web f g) : g = f :=
  within (fun x => x = f) (fun _ _ _ affects => absurd affects (not_affects _ _)) rfl

/-- Every formation's acts return. -/
theorem every_returns (c : Bool) : flow.ReachReturns web c :=
  fun _ within => Eq.subst (motive := fun x => flow.WithinReach web x c) (reach_self within).symm
    (WithinClosure.refl c)

/-- **Every formation returning, none bearing on itself.** Every formation's acts return, so the
step from each standpoint's own continuation gives the condition at the returning formations; held
de se along affecting it is not the condition, and the flow is not mutually dependent. No formation
bears on itself, so standpoints read as bearing on themselves and returning are none, and cover
nothing. -/
theorem apart :
    (∀ c, flow.ReachReturns web c) ∧
      Unrestricted (atCenters (Subtype.val : flow.Returning web → Bool)) ∧
      ¬ Unrestricted (selfAscribed (ownClosure (flow.Affects web))
        (Subtype.val : flow.Returning web → Bool)) ∧
      ¬ flow.MutuallyDependent web ∧
      ∀ c, ¬ web.SelfBearing c :=
  ⟨every_returns,
   (Flow.atReturning_unrestricted_iff ⟨true, every_returns true⟩).mpr every_returns,
   fun unrestricted => Bool.noConfusion
     (reach_self (ownClosure_unrestricted_iff.mp unrestricted ⟨true, every_returns true⟩ false)),
   fun dependent => Bool.noConfusion (reach_self (Flow.mutuallyDependent_iff_reach.mp dependent true false)),
   fun _ self => (self 0 trivial).1⟩

end Unexchanged

end Becoming
