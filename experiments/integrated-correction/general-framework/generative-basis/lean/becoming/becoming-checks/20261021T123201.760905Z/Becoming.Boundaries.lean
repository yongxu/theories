import Becoming.Feedback
import Becoming.BoundedSignificance
import Becoming.Standpoints

/-!
# Boundaries: the self's presupposition, however its boundary is drawn

On 10 October 2026 Ren wrote “Truth exist”: “There is a set of universal invariations, that for
every universe, becoming happens, the law follows”, “the bases of all ethics, for all beings, in
all universes”, and “There is no absolute self, and the continuation goes beyond one’s cycle of
life, goes beyond one’s death.” Earlier that day Ren had written that the self is “a cognitive
model which can not justify itself without some sort of "belief"”, that “we” are “the
universe/ecosystem that realizes its own existence”, and that a center's “boundary” is “also with
in the same cognitive system”. The assistant proposed that the continuation condition of `Becoming.Significance`
might follow from three claims it read from Ren's words, through one inference to be stated
exactly, and Ren asked to pursue the strongest claims. This module states the result: an exact
decomposition of the continuation condition that locates the one step it adds to the self's presupposition. It
does not lower the continuation condition's content.

* **Boundaries of a self.** Along a relation, a boundary of a formation's self is a region that
  holds the formation and is closed under the relation (`Boundary`). The closure is the least
  boundary and the whole the greatest (`Boundary.closure`, `Boundary.whole`, `Boundary.holds`).
  Where everything lies within the formation's closure, the whole is its only boundary
  (`Boundary.only_whole`).
* **Standpoints as formations** (R34, 20 October 2026). The valuations of `Becoming.Metaethics`
  hold for any type of standpoints; their instance with the formations as standpoints, each one's
  own region its closure under a relation of the unfolding, `living` and `related` the web's
  stepwise reading, leaves `sig` the only evaluative parameter supplied (`Web.selfValuation`). A
  self's own region is its least boundary (`Web.selfValuation_own_least`); every event is its own
  formation's, so living significance is self-significance at every formation with standpoint
  neutrality, along any relation (`Web.selfValuation_held`, `Web.selfValuation_significant_iff`);
  along the empty relation the own region is the formation's own events, the case of
  `Web.significant_iff_self` (`Web.selfValuation_empty_own`); along feeding it is the feeding
  closure (`Web.selfValuation_feeding_own`); and under the continuation condition every premise of
  the valuation holds (`Web.selfValuation_of_unrestricted`). The relation is read off the
  unfolding (feeding, affecting, being affected, sharing a condition, coupling), and which one a
  center draws its region along is not derived here.
* **Truth however the boundary is drawn.** A claim about a self is super-true when it holds
  however the boundary is drawn among the admissible ones (`SuperTrue`), sub-true when it holds
  as the boundary is drawn somewhere (`SubTrue`), and boundary-invariant when, holding as drawn
  anywhere, it holds as drawn everywhere (`BoundaryInvariant`). The first two terms are those of
  supervaluation (Fine 1975) and subvaluation (Hyde 1997). Super-truth is invariant sub-truth
  (`superTrue_iff`), and invariance is determinacy: sub-true, the claim is super-true
  (`boundaryInvariant_iff_determinate`).
* **The scope of “within the self”.** What lies within the self however its boundary is drawn is
  the closure (`superTrue_member_iff`); everything lies within it as drawn somewhere
  (`subTrue_member`), so along a relation no formation is a clear non-member of any self.
  Wherever the whole is admissible, “everything within the self has a property” is super-true
  exactly when everything has it (`superTrue_all_iff`); it is sub-true exactly when everything
  within the closure has it (`subTrue_all_iff`).
* **The self's presupposition.** From a standpoint, with the boundary drawn at a region, the
  presupposition is that the continuation of everything within the region has significance
  (`SignificantWithin`). Super-true, it is significance over the union of the admissible
  boundaries (`superTrue_significantWithin_iff_union`); wherever the whole is admissible, as along
  any relation, it is the continuation condition (`unrestricted_iff_superTrue`, `superTrue_level_free`). Sub-true
  along a relation, it is significance over the closure (`subTrue_significantWithin_iff`): along
  the empty relation, the significance of the center's own continuation, a standpoint's own good;
  along the total relation, the continuation condition at that standpoint (`subTrue_empty_iff`,
  `subTrue_total_iff`). Drawn along a larger relation it says more (`subTrue_of_larger`,
  `Flow.presupposition_order`). Route (b)'s significance, bounded by each center's closure, is the
  significance of what lies definitely within the self (`bounded_closure_iff`), and the least
  that makes every presupposition sub-true (`bounded_closure_least`). Route (b) and the continuation condition are
  one presupposition with the operator “however the boundary is drawn” at narrow scope and at
  wide scope (`presupposition_scopes`); the operator does not distribute over the conditional.
  This extends route (b) from feeding to any relation.
* **The continuation condition decomposed: where its content lies.** Let every formation lie within some
  admissible boundary of every self, let each standpoint's presupposition be sub-true, and let it
  be boundary-invariant. Then nothing restricts significance (`unrestricted_of_presupposed`), and
  where the whole is admissible the continuation condition is exactly these premises
  (`unrestricted_iff_presupposed`, `unrestricted_iff_presupposed_along`). Wherever the whole is
  admissible, invariance is the conditional from the presupposition to the continuation condition at that
  standpoint (`boundaryInvariant_iff_conditional`); given the presupposition, it is the continuation condition
  there (`boundaryInvariant_iff_all`), which `Becoming.Significance` reads as boundary neutrality.
  The decomposition locates the step and does not lower the continuation condition's content. The step runs both
  ways: where some continuation lacks significance, an invariant presupposition is nowhere true
  (`not_subTrue_of_invariant`). Along a relation covering holds by construction, because every
  closed region holding the center, the whole included, counts as an admissible drawing of the
  self. Given the presupposition at every standpoint and every formation within some center's
  closure, invariance is equivalent to standpoint-invariance (`StandpointInvariant`,
  `boundaryInvariant_iff_standpointInvariant`), the rule of N_std; without the presupposition
  everywhere the two come apart (`OneCounts.forms_apart`). So the premises carry two
  decompositions already in the core to the significance of continuation:
  `Valuation.significant_iff` (a seed, N_rel and N_std on a connected whole) and
  `Valuation.significant_iff_held` (S0 at every standpoint with N_std). Agreement between
  standpoints and living significance at the level of claims follow (`retains_agree_of_presupposed`,
  `Valuation.significant_of_presupposed`).
* **Each premise is needed.** In `Clearing`, where nothing has significance, the presupposition is
  invariant and the whole is admissible, and the continuation condition fails (`Clearing.without_presupposition`).
  Significance bounded by each formation's feeding closure makes every presupposition sub-true
  with the whole admissible, and the continuation condition fails; at the clearer the presupposition is not
  invariant, and significance is not standpoint-invariant (`Clearing.without_invariance`,
  `Clearing.without_standpoint_invariance`). Were each self's only admissible boundary its
  feeding closure, the same significance would make every presupposition sub-true and invariant,
  the dweller would lie within no admissible boundary of the clearer, and the continuation condition would still
  fail (`Clearing.with_fixed_boundary`).
* **A part's exchange within reach.** Sub-true along a relation that holds affecting, the
  presupposition compares every part within the center's closure as the continuation condition does
  (`Flow.Balances.presupposed_comparison`): along affecting, every part within the center's reach
  closure (`Flow.Balances.presupposed_reach_comparison`); along sharing a condition, every part
  within its system. Neither invariance nor super-truth is used. Sub-truth along sharing a
  condition gives sub-truth along affecting (`Flow.presupposition_order`), so the premise along
  affecting is the weaker. Sub-truth depends on the relation and super-truth does not
  (`Clearing.levels_differ`). Drawn along sharing a condition, or held however the boundary is
  drawn, the clearer's own presupposition gives from its own standpoint that its part loses the
  dweller; drawn at the feeding closure, it is met by a significance under which the part retains
  (`Clearing.own_presupposition`).
* **Where the closure is the whole.** Where every formation lies within each center's closure
  along a relation, the whole is the only boundary, so invariance holds trivially and the continuation condition is
  the presupposition sub-true at every standpoint (`unrestricted_iff_presupposed_of_whole`). Along
  sharing a condition this holds wherever one condition is taken part in by everything
  (`Flow.unrestricted_iff_system_presupposed`, `Flow.unrestricted_iff_presupposed_of_common`), as
  in `Clearing` (`Clearing.system_presupposition`). The step is not removed there: it has moved
  into drawing the self's boundary closed under the relation.

**AI reading, adopted on Ren's delegation of 15 October 2026 (DELEGATED-CHOICES D21).**
- The presupposition reads the “belief” without which, Ren wrote, the self “can not justify
  itself”. Ren wrote this of the self's limit; using the belief as a premise is the AI's step, and
  sub-truth along a relation is far stronger than that some continuation has significance.
- Covering: Ren's “we” being “the universe/ecosystem that realizes its own existence” supports
  the whole as one drawing of “we”; “There is no absolute self” does not by itself give covering.
  Along a relation covering holds because every closed region holding the center, the whole
  included, counts as an admissible drawing of the self. That admissibility is the substantive
  choice, and it is why the admissible class is not a supervaluation of the ordinary, vague
  “self”: it has no clear non-members.
- Ren's “for all beings” reads most directly as standpoint-invariance, the rule of N_std; given
  the presupposition and covering, boundary-invariance is equivalent to it. Ren's “universal
  invariations” are invariances of the law across universes; extending them to significance is
  the AI's reading. To deny the step is to hold the presupposition true only relative to a drawing
  or only from a standpoint, or, since the step runs both ways, to give up the presupposition. The
  step takes the place of the earlier route's tolerance and, like tolerance with Chain, carries all
  of the continuation condition's content beyond the presupposition, in one step instead of many small ones.
- Where the rivals sit. Along a relation covering holds by construction, so the rivals deny
  another premise. A rival that grounds significance in a formed closure denies sub-truth along
  any relation under which that closure is not closed, as operational closure is not closed under
  feeding. Along a relation under which it is closed, it denies invariance: it holds its
  presupposition only at that closure, as route (b) does at the feeding closure. It denies
  covering only if it also restricts the admissible drawings to that closure. A vague self denies
  covering where every admissible drawing leaves the stranger out, and invariance where the
  stranger is borderline. A graded weight that falls to zero denies sub-truth if it falls inside
  the closure, and invariance if beyond it. A present-aim evaluator denies sub-truth. An earlier
  independent review raised the first two against the tolerance route to living significance. This module locates
  these denials; it does not refute them.
- Ren's order of levels, “the whole, and a weaker version is within the system that one is in,
  then the self”, is an order of readings of the presupposition: super-true; sub-true along
  affecting, at the reach closure offered in `Becoming.Feedback` for the system one is in; and
  sub-true at the self, along the empty relation. The weaker version gives the continuation condition's comparison
  on every part within one's reach. The reach closure points forward: on this reading the order
  runs down to the bare self, not through the feeding closure, which lies on another branch
  (`Flow.presupposition_order`). This direction is adopted as the reading of Ren's order of levels
  on Ren's delegation of 15 October 2026 (DELEGATED-CHOICES D21).

What is not derived:
- covering, sub-truth and invariance themselves. The presupposition is supplied as every
  significance is (`Web.significance_undetermined`); along a relation it already carries
  transmission along that relation, from the bare own good of the empty relation to the continuation condition of
  the total one;
- that a center knows its reach closure: its own feedback carries at most its influence closure
  (`Flow.Balances.uncoupled_beyond_influence`);
- the step from significance to a reason, to motivation or to practice.

The audit of the uses of living significance (`Becoming.Relevance`) is clean, and Ren folded living significance (`LivingSignificance`) on 11 October 2026: it
is no longer an axiom.
-/

namespace Becoming

variable {F C Pos : Type}

/-! ## Boundaries of a self -/

/-- A boundary of `f`'s self along a relation: a region that holds `f` and is closed under the
relation. -/
def Boundary (rel : F → F → Prop) (f : F) (region : F → Prop) : Prop :=
  ClosedUnder rel region ∧ region f

namespace Boundary

variable {rel rel' : F → F → Prop}

/-- The closure is a boundary, the least. -/
theorem closure (f : F) : Boundary rel f (WithinClosure rel f) :=
  ⟨closedUnder_withinClosure f, WithinClosure.refl f⟩

/-- The whole is a boundary of every self, the greatest. -/
theorem whole (f : F) : Boundary rel f fun _ => True :=
  ⟨fun _ _ _ _ => trivial, trivial⟩

/-- Every boundary holds the closure. -/
theorem holds {f : F} {region : F → Prop} (boundary : Boundary rel f region) {g : F}
    (within : WithinClosure rel f g) : region g :=
  within region boundary.1 boundary.2

/-- A boundary along a larger relation is a boundary along a smaller one. -/
theorem of_larger (larger : ∀ g h, rel g h → rel' g h) {f : F} {region : F → Prop}
    (boundary : Boundary rel' f region) : Boundary rel f region :=
  ⟨fun g h inside related => boundary.1 g h inside (larger g h related), boundary.2⟩

/-- Where everything lies within `f`'s closure, the whole is `f`'s only boundary. -/
theorem only_whole {f : F} (connected : ∀ g, WithinClosure rel f g) {region : F → Prop}
    (boundary : Boundary rel f region) : ∀ g, region g :=
  fun g => boundary.holds (connected g)

end Boundary

/-! ## Standpoints as formations, a self's region as its closure

The valuations of `Becoming.Metaethics` take standpoints of any type, each with a supplied region
(`own`) and a supplied significance (`sig`). Every law there holds for any type of standpoints; the
reading that standpoints are formations is the instance with the formations themselves as the
standpoints. Here that instance is stated with each formation's own region its closure under a
relation of the unfolding, the least boundary of its self: feeding (`Flow.FedFrom`), affecting
(`Flow.Affects`, the reach closure), being affected (`Flow.AffectedBy`, the influence closure),
sharing a condition (`Flow.Shares`, the system) or being affected through what couples in (the
coupling closure). `living` and `related` are the web's stepwise reading. So the one evaluative
parameter supplied is `sig`, the significance of a formation's continuation at a step from a
standpoint, and the continuation condition fills exactly that. -/

section Selves

/-- **The valuation of a web's events from the formations themselves**: the standpoints are the
formations, each one's own region is its closure under `rel`, `living` and `related` are the
stepwise reading of `Web.valuation`, and an event's significance from a formation is that of the
event's formation's continuation at its step. Only `sig` is supplied. -/
def Web.selfValuation (W : Web F C) (rel : F → F → Prop) (sig : F → Nat → F → Prop) :
    Valuation F (F × Nat) :=
  W.valuation (fun f e => WithinClosure rel f e.1) fun f e => sig f e.2 e.1

variable {W : Web F C} {rel : F → F → Prop} {sig : F → Nat → F → Prop}

/-- **A self's own region is its least boundary**: it holds the formation's own events, it is a
boundary along `rel`, and every boundary along `rel` holds it. -/
theorem Web.selfValuation_own_least (f : F) :
    (∀ t, (W.selfValuation rel sig).own f (f, t)) ∧
      Boundary rel f (fun g => ∀ t, (W.selfValuation rel sig).own f (g, t)) ∧
      ∀ region, Boundary rel f region → ∀ e, (W.selfValuation rel sig).own f e → region e.1 :=
  ⟨fun _ => WithinClosure.refl f, ⟨fun _ _ inside related _ => (inside 0).trans (.of_rel related),
     fun _ => WithinClosure.refl f⟩,
   fun _ boundary _ own => boundary.holds own⟩

/-- **Every event is its own formation's**: each event lies in the own region of its formation. -/
theorem Web.selfValuation_held : (W.selfValuation rel sig).Held :=
  fun e _ => ⟨e.1, WithinClosure.refl e.1⟩

/-- So living significance there is self-significance at every formation with standpoint
neutrality, along any relation (`Valuation.significant_iff_held`); along the empty relation each
formation's own region is its own events (`Web.selfValuation_empty_own`), the case of
`Web.significant_iff_self`. -/
theorem Web.selfValuation_significant_iff :
    (W.selfValuation rel sig).Significant ↔
      (∀ f, (W.selfValuation rel sig).SelfSignificance f) ∧
        Neutral (W.selfValuation rel sig).shares :=
  Valuation.significant_iff_held Web.selfValuation_held

/-- Along the empty relation a formation's own region is its own events. -/
theorem Web.selfValuation_empty_own {f : F} {e : F × Nat} :
    (W.selfValuation (fun _ _ => False) sig).own f e ↔ e.1 = f :=
  ⟨fun within => within (· = f) (fun _ _ _ no => no.elim) rfl,
   fun same => same ▸ WithinClosure.refl e.1⟩

/-- Along feeding a formation's own region is its feeding closure, what its continuation depends
on. -/
theorem Web.selfValuation_feeding_own (L : Flow F C) {f : F} {e : F × Nat} :
    (W.selfValuation (L.FedFrom W) sig).own f e ↔ L.WithinFeeding W f e.1 :=
  Iff.rfl

/-- **Under the continuation condition the valuation from the formations has every premise**:
living significance at the level of claims, self-significance at every formation, both
neutralities and a seed wherever something lives (`Valuation.premises_of_unrestricted`), along any
relation. -/
theorem Web.selfValuation_of_unrestricted (unrestricted : Unrestricted sig) :
    (W.selfValuation rel sig).Significant ∧ (∀ f, (W.selfValuation rel sig).SelfSignificance f) ∧
      Neutral (W.selfValuation rel sig).transmits ∧ Neutral (W.selfValuation rel sig).shares ∧
      ∀ e, (W.selfValuation rel sig).living e → F → (W.selfValuation rel sig).Seed :=
  Valuation.premises_of_unrestricted unrestricted Prod.fst Prod.snd fun _ _ held => held

end Selves

/-! ## Truth however the boundary is drawn -/

/-- A claim about a self is super-true when it holds however the self's boundary is drawn among
the admissible ones. -/
def SuperTrue (admissible : (F → Prop) → Prop) (claim : (F → Prop) → Prop) : Prop :=
  ∀ region, admissible region → claim region

/-- A claim about a self is sub-true when it holds as the boundary is drawn at some admissible
region. -/
def SubTrue (admissible : (F → Prop) → Prop) (claim : (F → Prop) → Prop) : Prop :=
  ∃ region, admissible region ∧ claim region

/-- A claim about a self is invariant when, holding as the boundary is drawn at one admissible
region, it holds as it is drawn at every other. -/
def BoundaryInvariant (admissible : (F → Prop) → Prop) (claim : (F → Prop) → Prop) : Prop :=
  ∀ region region', admissible region → admissible region' → claim region → claim region'

/-- Where some boundary is admissible, super-truth is invariant sub-truth. -/
theorem superTrue_iff {admissible claim : (F → Prop) → Prop} (some : ∃ region, admissible region) :
    SuperTrue admissible claim ↔ SubTrue admissible claim ∧ BoundaryInvariant admissible claim :=
  ⟨fun super => match some with
    | ⟨region, admitted⟩ => ⟨⟨region, admitted, super region admitted⟩,
        fun _ region' _ admitted' _ => super region' admitted'⟩,
   fun ⟨⟨region, admitted, holds⟩, invariant⟩ region' admitted' =>
     invariant region region' admitted admitted' holds⟩

/-- Invariance is determinacy: a claim is invariant exactly when, true as the boundary is drawn
somewhere, it is true however it is drawn. -/
theorem boundaryInvariant_iff_determinate {admissible claim : (F → Prop) → Prop} :
    BoundaryInvariant admissible claim ↔ (SubTrue admissible claim → SuperTrue admissible claim) :=
  ⟨fun invariant ⟨region, admitted, holds⟩ region' admitted' =>
     invariant region region' admitted admitted' holds,
   fun determinate region region' admitted admitted' holds =>
     determinate ⟨region, admitted, holds⟩ region' admitted'⟩

/-! ## The scope of “within the self” -/

/-- What lies within the self however its boundary is drawn is the closure. -/
theorem superTrue_member_iff {rel : F → F → Prop} {f g : F} :
    SuperTrue (Boundary rel f) (fun region => region g) ↔ WithinClosure rel f g :=
  ⟨fun super region closed holds => super region ⟨closed, holds⟩,
   fun within _ boundary => boundary.holds within⟩

/-- Everything lies within the self as its boundary is drawn somewhere: at the whole. -/
theorem subTrue_member {rel : F → F → Prop} (f g : F) :
    SubTrue (Boundary rel f) (fun region => region g) :=
  ⟨fun _ => True, Boundary.whole f, trivial⟩

/-- Wherever the whole is admissible, “everything within the self has the property” is
super-true exactly when everything has it. -/
theorem superTrue_all_iff {admissible : (F → Prop) → Prop} (whole : admissible fun _ => True)
    {s : F → Prop} : SuperTrue admissible (fun region => ∀ g, region g → s g) ↔ ∀ g, s g :=
  ⟨fun super g => super _ whole g trivial, fun all _ _ g _ => all g⟩

/-- Along a relation, the same claim is sub-true exactly when everything within the closure has
the property. -/
theorem subTrue_all_iff {rel : F → F → Prop} {f : F} {s : F → Prop} :
    SubTrue (Boundary rel f) (fun region => ∀ g, region g → s g) ↔
      ∀ g, WithinClosure rel f g → s g :=
  ⟨fun ⟨_, boundary, all⟩ g within => all g (boundary.holds within),
   fun all => ⟨WithinClosure rel f, Boundary.closure f, all⟩⟩

/-! ## The self's presupposition -/

/-- From standpoint `p`, with the self's boundary drawn at a region, the continuation of
everything within the region has significance at every step. -/
def SignificantWithin (sig : Pos → Nat → F → Prop) (p : Pos) (region : F → Prop) : Prop :=
  ∀ g, region g → ∀ t, sig p t g

/-- The presupposition is super-true exactly when, from `p`, the continuation of everything
within some admissible boundary has significance at every step: significance over the union of
the admissible boundaries. -/
theorem superTrue_significantWithin_iff_union {admissible : (F → Prop) → Prop}
    {sig : Pos → Nat → F → Prop} {p : Pos} :
    SuperTrue admissible (SignificantWithin sig p) ↔
      ∀ t g, (∃ region, admissible region ∧ region g) → sig p t g :=
  ⟨fun super t g ⟨region, admitted, inside⟩ => super region admitted g inside t,
   fun all region admitted g inside t => all t g ⟨region, admitted, inside⟩⟩

/-- Wherever the whole is admissible, the presupposition is super-true exactly when, from `p`,
the continuation of everything has significance at every step. -/
theorem superTrue_significantWithin_iff {admissible : (F → Prop) → Prop}
    (whole : admissible fun _ => True) {sig : Pos → Nat → F → Prop} {p : Pos} :
    SuperTrue admissible (SignificantWithin sig p) ↔ ∀ t g, sig p t g :=
  ⟨fun super t g => superTrue_significantWithin_iff_union.mp super t g ⟨_, whole, trivial⟩,
   fun all => superTrue_significantWithin_iff_union.mpr fun t g _ => all t g⟩

/-- Along a relation, the presupposition is sub-true at `f` exactly when, from `p`, the
continuation of everything within `f`'s closure has significance at every step. -/
theorem subTrue_significantWithin_iff {rel : F → F → Prop} {f : F} {sig : Pos → Nat → F → Prop}
    {p : Pos} :
    SubTrue (Boundary rel f) (SignificantWithin sig p) ↔ ∀ t g, WithinClosure rel f g → sig p t g :=
  ⟨fun sub t g within => (subTrue_all_iff (s := fun g => ∀ t, sig p t g)).mp sub g within t,
   fun all => (subTrue_all_iff (s := fun g => ∀ t, sig p t g)).mpr fun g within t =>
     all t g within⟩

/-- Sub-truth along a larger relation gives sub-truth along a smaller one. -/
theorem subTrue_of_larger {rel rel' : F → F → Prop} (larger : ∀ g h, rel g h → rel' g h)
    {f : F} {claim : (F → Prop) → Prop} (sub : SubTrue (Boundary rel' f) claim) :
    SubTrue (Boundary rel f) claim :=
  match sub with
  | ⟨region, boundary, holds⟩ => ⟨region, boundary.of_larger larger, holds⟩

/-- Along the total relation the whole is the only boundary, so the presupposition is sub-true
exactly when, from `p`, the continuation of everything has significance at every step: the continuation condition
at that standpoint. -/
theorem subTrue_total_iff {f : F} {sig : Pos → Nat → F → Prop} {p : Pos} :
    SubTrue (Boundary (fun _ _ => True) f) (SignificantWithin sig p) ↔ ∀ t g, sig p t g :=
  ⟨fun sub t g => subTrue_significantWithin_iff.mp sub t g
     (WithinClosure.of_rel (rel := fun _ _ => True) trivial),
   fun all => subTrue_significantWithin_iff.mpr fun t g _ => all t g⟩

/-- Along the empty relation the center alone is the least boundary, so the presupposition is
sub-true exactly when, from `p`, the center's own continuation has significance at every step: a
standpoint's own good. -/
theorem subTrue_empty_iff {f : F} {sig : Pos → Nat → F → Prop} {p : Pos} :
    SubTrue (Boundary (fun _ _ => False) f) (SignificantWithin sig p) ↔ ∀ t, sig p t f :=
  ⟨fun sub t => subTrue_significantWithin_iff.mp sub t f (WithinClosure.refl f),
   fun own => ⟨fun g => g = f, ⟨fun _ _ _ no => no.elim, rfl⟩,
     fun _ same t => Eq.subst (motive := fun x => sig p t x) same.symm (own t)⟩⟩

/-- The continuation condition is the presupposition held however each self's boundary is drawn, along any
relation. -/
theorem unrestricted_iff_superTrue (rel : F → F → Prop) (center : Pos → F)
    {sig : Pos → Nat → F → Prop} :
    Unrestricted sig ↔ ∀ p, SuperTrue (Boundary rel (center p)) (SignificantWithin sig p) :=
  ⟨fun unrestricted p => (superTrue_significantWithin_iff (Boundary.whole _)).mpr
      fun t g => unrestricted (p, t, g),
   fun super i => (superTrue_significantWithin_iff (Boundary.whole _)).mp (super i.1) i.2.1 i.2.2⟩

/-- Its super-truth does not depend on the relation: the presupposition is super-true along one
relation exactly when it is along any other. -/
theorem superTrue_level_free (rel rel' : F → F → Prop) (f : F) (sig : Pos → Nat → F → Prop)
    (p : Pos) :
    SuperTrue (Boundary rel f) (SignificantWithin sig p) ↔
      SuperTrue (Boundary rel' f) (SignificantWithin sig p) :=
  (superTrue_significantWithin_iff (Boundary.whole f)).trans
    (superTrue_significantWithin_iff (Boundary.whole f)).symm

/-- Significance bounded by each center's closure is the significance of what lies within the
self however its boundary is drawn. -/
theorem bounded_closure_iff (rel : F → F → Prop) (center : Pos → F) (p : Pos) (t : Nat) (g : F) :
    bounded (fun q => WithinClosure rel (center q)) p t g ↔
      SuperTrue (Boundary rel (center p)) (fun region => region g) :=
  superTrue_member_iff.symm

/-- It is the least significance that makes every standpoint's presupposition sub-true: it does
so, and every significance that does contains it. -/
theorem bounded_closure_least (rel : F → F → Prop) (center : Pos → F) :
    (∀ p, SubTrue (Boundary rel (center p))
        (SignificantWithin (bounded fun q => WithinClosure rel (center q)) p)) ∧
      ∀ sig : Pos → Nat → F → Prop,
        (∀ p, SubTrue (Boundary rel (center p)) (SignificantWithin sig p)) →
          ∀ p t g, bounded (fun q => WithinClosure rel (center q)) p t g → sig p t g :=
  ⟨fun _ => subTrue_significantWithin_iff.mpr fun _ _ within => within,
   fun _ sub p t g within => subTrue_significantWithin_iff.mp (sub p) t g within⟩

/-- The two scopes. From standpoint `p`, “whatever lies definitely within the self has
significance”, the operator “however the boundary is drawn” at narrow scope, is the
presupposition sub-true; “however the boundary is drawn, everything within the self has
significance”, the operator at wide scope, is the continuation condition at that standpoint. -/
theorem presupposition_scopes (rel : F → F → Prop) (f : F) (sig : Pos → Nat → F → Prop)
    (p : Pos) :
    ((∀ t g, SuperTrue (Boundary rel f) (fun region => region g) → sig p t g) ↔
        SubTrue (Boundary rel f) (SignificantWithin sig p)) ∧
      (SuperTrue (Boundary rel f) (SignificantWithin sig p) ↔ ∀ t g, sig p t g) :=
  ⟨⟨fun narrow => subTrue_significantWithin_iff.mpr fun t g within =>
       narrow t g (superTrue_member_iff.mpr within),
    fun sub t g definite => subTrue_significantWithin_iff.mp sub t g
       (superTrue_member_iff.mp definite)⟩,
   superTrue_significantWithin_iff (Boundary.whole f)⟩

/-! ## The continuation condition from the presupposition -/

/-- Invariance is one step. Wherever the whole is admissible, the presupposition is invariant
exactly when, holding as the boundary is drawn anywhere, it holds as it is drawn at the whole:
the step from the continuation a self acts for to continuation as such. -/
theorem boundaryInvariant_iff_extends {admissible : (F → Prop) → Prop}
    (whole : admissible fun _ => True)
    {sig : Pos → Nat → F → Prop} {p : Pos} :
    BoundaryInvariant admissible (SignificantWithin sig p) ↔
      ∀ region, admissible region → SignificantWithin sig p region →
        SignificantWithin sig p fun _ => True :=
  ⟨fun invariant region admitted holds => invariant region _ admitted whole holds,
   fun extension region _ admitted _ holds g _ => extension region admitted holds g trivial⟩

/-- Given the presupposition, invariance is the continuation condition at that standpoint. Wherever the whole is
admissible and the presupposition is sub-true, it is invariant exactly when, from `p`, the
continuation of everything has significance at every step: the step carries all that the continuation condition
adds to the presupposition. -/
theorem boundaryInvariant_iff_all {admissible : (F → Prop) → Prop}
    (whole : admissible fun _ => True) {sig : Pos → Nat → F → Prop} {p : Pos}
    (presupposed : SubTrue admissible (SignificantWithin sig p)) :
    BoundaryInvariant admissible (SignificantWithin sig p) ↔ ∀ t g, sig p t g :=
  ⟨fun invariant => (superTrue_significantWithin_iff whole).mp
      ((superTrue_iff ⟨_, whole⟩).mpr ⟨presupposed, invariant⟩),
   fun all _ _ _ _ _ g _ t => all t g⟩

/-- Invariance is the conditional from the presupposition to the continuation condition at that standpoint.
Wherever the whole is admissible, the presupposition is invariant exactly when, sub-true, it gives
every continuation significance from `p`. No presupposition is assumed. -/
theorem boundaryInvariant_iff_conditional {admissible : (F → Prop) → Prop}
    (whole : admissible fun _ => True) {sig : Pos → Nat → F → Prop} {p : Pos} :
    BoundaryInvariant admissible (SignificantWithin sig p) ↔
      (SubTrue admissible (SignificantWithin sig p) → ∀ t g, sig p t g) :=
  ⟨fun invariant ⟨region, admitted, holds⟩ t g =>
     invariant region _ admitted whole holds g trivial t,
   fun conditional region _ admitted _ holds g _ t => conditional ⟨region, admitted, holds⟩ t g⟩

/-- Invariance runs both ways. Wherever the whole is admissible and some continuation lacks
significance from `p`, an invariant presupposition holds as the boundary is drawn nowhere. -/
theorem not_subTrue_of_invariant {admissible : (F → Prop) → Prop}
    (whole : admissible fun _ => True) {sig : Pos → Nat → F → Prop} {p : Pos}
    (invariant : BoundaryInvariant admissible (SignificantWithin sig p)) {t : Nat} {g : F}
    (lacks : ¬ sig p t g) : ¬ SubTrue admissible (SignificantWithin sig p) :=
  fun sub => lacks ((boundaryInvariant_iff_conditional whole).mp invariant sub t g)

/-- **The continuation condition from three premises.** Let every formation lie within some admissible boundary of
every self; let each standpoint's presupposition, that the continuation of its self has
significance, hold as its boundary is drawn somewhere; and let the presupposition be invariant.
Then nothing restricts significance. -/
theorem unrestricted_of_presupposed {admissible : Pos → (F → Prop) → Prop}
    (covers : ∀ p g, ∃ region, admissible p region ∧ region g) {sig : Pos → Nat → F → Prop}
    (presupposed : ∀ p, SubTrue (admissible p) (SignificantWithin sig p))
    (invariant : ∀ p, BoundaryInvariant (admissible p) (SignificantWithin sig p)) :
    Unrestricted sig :=
  fun i => match presupposed i.1, covers i.1 i.2.2 with
    | ⟨region, admitted, holds⟩, ⟨region', admitted', inside⟩ =>
      invariant i.1 region region' admitted admitted' holds i.2.2 inside i.2.1

/-- Where the whole is an admissible boundary of every self, the continuation condition is exactly the
presupposition, sub-true and invariant at every standpoint. -/
theorem unrestricted_iff_presupposed {admissible : Pos → (F → Prop) → Prop}
    (whole : ∀ p, admissible p fun _ => True) {sig : Pos → Nat → F → Prop} :
    Unrestricted sig ↔ ∀ p, SubTrue (admissible p) (SignificantWithin sig p) ∧
      BoundaryInvariant (admissible p) (SignificantWithin sig p) :=
  ⟨fun unrestricted p => (superTrue_iff ⟨_, whole p⟩).mp
      ((superTrue_significantWithin_iff (whole p)).mpr fun t g => unrestricted (p, t, g)),
   fun premises i => (superTrue_significantWithin_iff (whole i.1)).mp
      ((superTrue_iff ⟨_, whole i.1⟩).mpr (premises i.1)) i.2.1 i.2.2⟩

/-- Along any relation, with each self's boundaries the regions that hold its center and are
closed under the relation, the whole is admissible, so the continuation condition is the presupposition, sub-true
and invariant at every standpoint. -/
theorem unrestricted_iff_presupposed_along (rel : F → F → Prop) (center : Pos → F)
    {sig : Pos → Nat → F → Prop} :
    Unrestricted sig ↔ ∀ p, SubTrue (Boundary rel (center p)) (SignificantWithin sig p) ∧
      BoundaryInvariant (Boundary rel (center p)) (SignificantWithin sig p) :=
  unrestricted_iff_presupposed fun p => Boundary.whole (center p)

/-- Where each center's closure is the whole, the continuation condition is the presupposition sub-true at every
standpoint, because the whole is then the only boundary (`Boundary.only_whole`) and invariance
holds trivially. -/
theorem unrestricted_iff_presupposed_of_whole {rel : F → F → Prop} {center : Pos → F}
    (connected : ∀ p g, WithinClosure rel (center p) g) {sig : Pos → Nat → F → Prop} :
    Unrestricted sig ↔ ∀ p, SubTrue (Boundary rel (center p)) (SignificantWithin sig p) :=
  ⟨fun unrestricted p => subTrue_significantWithin_iff.mpr fun t g _ => unrestricted (p, t, g),
   fun presupposed i => subTrue_significantWithin_iff.mp (presupposed i.1) i.2.1 i.2.2
     (connected i.1 i.2.2)⟩

/-- Under the three premises every standpoint retains alike. -/
theorem retains_agree_of_presupposed {admissible : Pos → (F → Prop) → Prop}
    (whole : ∀ p, admissible p fun _ => True) {sig : Pos → Nat → F → Prop}
    (premises : ∀ p, SubTrue (admissible p) (SignificantWithin sig p) ∧
      BoundaryInvariant (admissible p) (SignificantWithin sig p))
    (W : Web F C) (p q : Pos) {l l' : Nat → C → Nat} :
    W.Retains sig p l l' ↔ W.Retains sig q l l' :=
  Web.retains_agree ((unrestricted_iff_presupposed whole).mpr premises) p q

/-- Under the three premises living significance holds at the level of claims, on every reading in which a
claim's significance from a standpoint is that of some formation's continuation at some step. -/
theorem Valuation.significant_of_presupposed {Q : Type} {V : Valuation Pos Q}
    {admissible : Pos → (F → Prop) → Prop} (whole : ∀ p, admissible p fun _ => True)
    {sig : Pos → Nat → F → Prop}
    (premises : ∀ p, SubTrue (admissible p) (SignificantWithin sig p) ∧
      BoundaryInvariant (admissible p) (SignificantWithin sig p))
    (formation : Q → F) (step : Q → Nat) (reads : ∀ p c, sig p (step c) (formation c) → V.sig p c) :
    V.Significant :=
  (Valuation.premises_of_unrestricted ((unrestricted_iff_presupposed whole).mpr premises)
    formation step reads).1

/-! ## The step across standpoints -/

/-- Significance is standpoint-invariant when what has significance from one standpoint has it
from every other. -/
def StandpointInvariant (sig : Pos → Nat → F → Prop) : Prop :=
  ∀ p q t g, sig p t g → sig q t g

/-- **The continuation condition across standpoints.** Along a relation, let every formation lie within some
center's closure, let each standpoint's presupposition be sub-true, and let significance be
standpoint-invariant. Then nothing restricts significance. -/
theorem unrestricted_of_standpointInvariant {rel : F → F → Prop} {center : Pos → F}
    (centers : ∀ g, ∃ q, WithinClosure rel (center q) g) {sig : Pos → Nat → F → Prop}
    (presupposed : ∀ p, SubTrue (Boundary rel (center p)) (SignificantWithin sig p))
    (invariant : StandpointInvariant sig) : Unrestricted sig :=
  fun i => match centers i.2.2 with
    | ⟨q, within⟩ =>
      invariant q i.1 i.2.1 i.2.2
        (subTrue_significantWithin_iff.mp (presupposed q) i.2.1 i.2.2 within)

/-- Given the presupposition and centers covering, the two forms of the step are equivalent:
each is then the continuation condition. Along a relation, with every formation within some center's closure and
every standpoint's presupposition sub-true, the presupposition is invariant across each self's
boundaries exactly when significance is invariant across standpoints, the rule of N_std. -/
theorem boundaryInvariant_iff_standpointInvariant {rel : F → F → Prop} {center : Pos → F}
    (centers : ∀ g, ∃ q, WithinClosure rel (center q) g) {sig : Pos → Nat → F → Prop}
    (presupposed : ∀ p, SubTrue (Boundary rel (center p)) (SignificantWithin sig p)) :
    (∀ p, BoundaryInvariant (Boundary rel (center p)) (SignificantWithin sig p)) ↔
      StandpointInvariant sig :=
  ⟨fun invariant _ q t g _ =>
     ((unrestricted_iff_presupposed_along rel center).mpr fun p => ⟨presupposed p, invariant p⟩)
       (q, t, g),
   fun invariant p => (boundaryInvariant_iff_all (Boundary.whole (center p)) (presupposed p)).mpr
     fun t g => unrestricted_of_standpointInvariant centers presupposed invariant (p, t, g)⟩

/-! ## A part's exchange within reach and within the system -/

namespace Flow

variable {L : Flow F C} {W : Web F C} {part : F → Bool}

/-- The order of the presupposition's readings. Drawn along a larger relation it says more: along
the total relation it is the continuation condition at the standpoint (`subTrue_total_iff`); along sharing a
condition it gives the presupposition along affecting and along being affected; along being
affected, the one along feeding; along any relation, the one along the empty relation, a
standpoint's own good (`subTrue_empty_iff`). -/
theorem presupposition_order {f : F} {sig : Pos → Nat → F → Prop} {p : Pos} :
    (SubTrue (Boundary (fun _ _ => True) f) (SignificantWithin sig p) →
      SubTrue (Boundary (L.Shares W) f) (SignificantWithin sig p)) ∧
    (SubTrue (Boundary (L.Shares W) f) (SignificantWithin sig p) →
      SubTrue (Boundary (L.Affects W) f) (SignificantWithin sig p)) ∧
    (SubTrue (Boundary (L.Shares W) f) (SignificantWithin sig p) →
      SubTrue (Boundary (L.AffectedBy W) f) (SignificantWithin sig p)) ∧
    (SubTrue (Boundary (L.AffectedBy W) f) (SignificantWithin sig p) →
      SubTrue (Boundary (L.FedFrom W) f) (SignificantWithin sig p)) ∧
    (∀ rel : F → F → Prop, SubTrue (Boundary rel f) (SignificantWithin sig p) →
      SubTrue (Boundary (fun _ _ => False) f) (SignificantWithin sig p)) :=
  ⟨subTrue_of_larger fun _ _ _ => trivial,
   subTrue_of_larger fun _ _ affects => shares_symm (shares_of_affectedBy affects),
   subTrue_of_larger fun _ _ => shares_of_affectedBy,
   subTrue_of_larger fun _ _ => affectedBy_of_fedFrom,
   fun _ => subTrue_of_larger fun _ _ no => no.elim⟩

/-- The presupposition drawn along a relation that holds affecting compares every part within
the closure as the continuation condition does. Let the presupposition at standpoint `p` be sub-true along such a
relation at `p`'s center. Then for every part whose members lie within the center's closure, the
levels with and without the part retain what has significance from `p` exactly as they include
each other, both ways, and neither adds a continuation with significance exactly when neither
exceeds the other. Neither invariance nor super-truth is used. -/
theorem Balances.presupposed_comparison (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {rel : F → F → Prop}
    (holds : ∀ g h, L.Affects W g h → rel g h) {sig : Pos → Nat → F → Prop} {center : Pos → F}
    {p : Pos} (presupposed : SubTrue (Boundary rel (center p)) (SignificantWithin sig p))
    (members : ∀ h, part h = true → WithinClosure rel (center p) h) :
    (W.Retains sig p W.level l ↔ W.Includes W.level l) ∧
      (W.Retains sig p l W.level ↔ W.Includes l W.level) ∧
      (¬ W.Adds sig p W.level l ↔ ¬ W.Exceeds W.level l) ∧
      (¬ W.Adds sig p l W.level ↔ ¬ W.Exceeds l W.level) :=
  balances.comparison_within_reach without fun t g reached =>
    subTrue_significantWithin_iff.mp presupposed t g
      (reaches_within_closed (fun x y inside affects =>
        closedUnder_withinClosure (center p) x y inside (holds x y affects))
        members reached.reaches)

/-- Drawn along affecting, the presupposition compares every part within the center's reach
closure as the continuation condition does. Its premise is weaker than the one along sharing a condition
(`presupposition_order`). -/
theorem Balances.presupposed_reach_comparison (balances : L.Balances W) {l : Nat → C → Nat}
    (without : L.WithheldLevels part W l) {sig : Pos → Nat → F → Prop} {center : Pos → F}
    {p : Pos} (presupposed : SubTrue (Boundary (L.Affects W) (center p)) (SignificantWithin sig p))
    (members : ∀ h, part h = true → L.WithinReach W (center p) h) :
    (W.Retains sig p W.level l ↔ W.Includes W.level l) ∧
      (W.Retains sig p l W.level ↔ W.Includes l W.level) ∧
      (¬ W.Adds sig p W.level l ↔ ¬ W.Exceeds W.level l) ∧
      (¬ W.Adds sig p l W.level ↔ ¬ W.Exceeds l W.level) :=
  balances.presupposed_comparison without (fun _ _ affects => affects) presupposed members

/-- Where everything lies within each center's system, the continuation condition is the presupposition drawn
along sharing a condition at every standpoint, since the whole is then the only boundary. -/
theorem unrestricted_iff_system_presupposed {center : Pos → F}
    (connected : ∀ p g, L.WithinSystem W (center p) g) {sig : Pos → Nat → F → Prop} :
    Unrestricted sig ↔
      ∀ p, SubTrue (Boundary (L.Shares W) (center p)) (SignificantWithin sig p) :=
  unrestricted_iff_presupposed_of_whole connected

/-- Under one common condition, which every formation takes part in, the continuation condition is the
presupposition drawn along sharing a condition at every standpoint. -/
theorem unrestricted_iff_presupposed_of_common {c : C} (common : ∀ g, L.TakesPart W g c)
    {center : Pos → F} {sig : Pos → Nat → F → Prop} :
    Unrestricted sig ↔
      ∀ p, SubTrue (Boundary (L.Shares W) (center p)) (SignificantWithin sig p) :=
  unrestricted_iff_system_presupposed fun p => system_whole_of_common common (center p)

end Flow

/-! ## Witnesses: each premise is needed -/

namespace Clearing

/-- Without the presupposition. Where nothing has significance the presupposition is invariant
at every standpoint, vacuously, the whole is a boundary of every self, and the continuation condition fails. -/
theorem without_presupposition :
    (∀ p, BoundaryInvariant (Boundary (flow.FedFrom web) p)
        (SignificantWithin (fun (_ : Formation) (_ : Nat) (_ : Formation) => False) p)) ∧
      (∀ p, Boundary (flow.FedFrom web) p fun _ => True) ∧
      ¬ Unrestricted (fun (_ : Formation) (_ : Nat) (_ : Formation) => False) :=
  ⟨fun _ _ _ boundary _ holds => (holds _ boundary.2 0).elim, fun p => Boundary.whole p,
   fun all => all (.clearer, 0, .clearer)⟩

/-- Without invariance. Significance bounded by each formation's feeding closure makes every
presupposition sub-true, the whole is a boundary of every self, and the continuation condition fails: from the
clearer's standpoint the presupposition is not invariant, since the dweller lies beyond its
feeding closure. -/
theorem without_invariance :
    (∀ p, SubTrue (Boundary (flow.FedFrom web) p)
        (SignificantWithin (bounded (WithinClosure (flow.FedFrom web))) p)) ∧
      (∀ p, Boundary (flow.FedFrom web) p fun _ => True) ∧
      ¬ BoundaryInvariant (Boundary (flow.FedFrom web) .clearer)
        (SignificantWithin (bounded (WithinClosure (flow.FedFrom web))) .clearer) ∧
      ¬ Unrestricted (bounded (WithinClosure (flow.FedFrom web))) :=
  ⟨(bounded_closure_least (flow.FedFrom web) id).1, fun p => Boundary.whole p,
   fun invariant => dweller_beyond ((invariant _ _ (Boundary.closure Formation.clearer) (Boundary.whole Formation.clearer)
       (fun _ within _ => within) .dweller trivial 0)),
   fun all => dweller_beyond ((all (.clearer, 0, .dweller)))⟩

/-- Without standpoint-invariance. Significance bounded by each formation's feeding closure makes
every presupposition sub-true, and every formation lies within its own closure, while
significance is not standpoint-invariant: the dweller's continuation has significance from its
own standpoint and not from the clearer's. -/
theorem without_standpoint_invariance :
    (∀ p, SubTrue (Boundary (flow.FedFrom web) p)
        (SignificantWithin (bounded (WithinClosure (flow.FedFrom web))) p)) ∧
      (∀ g, ∃ q, WithinClosure (flow.FedFrom web) q g) ∧
      ¬ StandpointInvariant (bounded (WithinClosure (flow.FedFrom web))) :=
  ⟨(bounded_closure_least (flow.FedFrom web) id).1, fun g => ⟨g, WithinClosure.refl g⟩,
   fun invariant => dweller_beyond ((invariant .dweller .clearer 0 .dweller (WithinClosure.refl _)))⟩

/-- With a fixed boundary. Were each self's only admissible boundary its feeding closure,
significance bounded by the closure would make every presupposition sub-true and invariant, and
the continuation condition would still fail: the dweller then lies within no admissible boundary of the
clearer. -/
theorem with_fixed_boundary :
    (∀ p, SubTrue (fun region => ∀ g, region g ↔ WithinClosure (flow.FedFrom web) p g)
        (SignificantWithin (bounded (WithinClosure (flow.FedFrom web))) p)) ∧
      (∀ p, BoundaryInvariant (fun region => ∀ g, region g ↔ WithinClosure (flow.FedFrom web) p g)
        (SignificantWithin (bounded (WithinClosure (flow.FedFrom web))) p)) ∧
      ¬ (∃ region : Formation → Prop,
          (∀ g, region g ↔ WithinClosure (flow.FedFrom web) .clearer g) ∧ region .dweller) ∧
      ¬ Unrestricted (bounded (WithinClosure (flow.FedFrom web))) :=
  ⟨fun p => ⟨WithinClosure (flow.FedFrom web) p, fun _ => Iff.rfl, fun _ within _ => within⟩,
   fun _ _ _ _ fixed' _ g inside _ => (fixed' g).mp inside,
   fun ⟨_, fixed, inside⟩ =>
     dweller_beyond (((fixed .dweller).mp inside)),
   fun all => dweller_beyond ((all (.clearer, 0, .dweller)))⟩

/-- The presupposition's sub-truth depends on the level; its super-truth does not
(`superTrue_level_free`). Significance bounded by each formation's feeding closure makes the
clearer's presupposition sub-true along feeding, and not along sharing a condition, since the
dweller lies within the clearer's system. -/
theorem levels_differ :
    SubTrue (Boundary (flow.FedFrom web) .clearer)
        (SignificantWithin (bounded (WithinClosure (flow.FedFrom web))) .clearer) ∧
      ¬ SubTrue (Boundary (flow.Shares web) .clearer)
        (SignificantWithin (bounded (WithinClosure (flow.FedFrom web))) .clearer) :=
  ⟨subTrue_significantWithin_iff.mpr fun _ _ within => within,
   fun sub => dweller_beyond ((subTrue_significantWithin_iff.mp sub 0 .dweller levels.2.2))⟩

/-- The clearer's own presupposition counts the dweller, unless it is drawn at the feeding
closure. Held as the clearer's boundary is drawn somewhere along sharing a condition, and so also
if held however the boundary is drawn, it gives from the clearer's own standpoint that its part
loses the dweller, so the part does not retain what has significance. Held only as the boundary
is drawn at the feeding closure, it is met by a significance under which the part retains:
significance bounded by that closure. -/
theorem own_presupposition {l : Nat → Place → Nat}
    (without : flow.WithheldLevels clearerPart web l) {sig : Formation → Nat → Formation → Prop} :
    (SubTrue (Boundary (flow.Shares web) .clearer) (SignificantWithin sig .clearer) →
        web.Adds sig .clearer l web.level ∧ ¬ web.Retains sig .clearer web.level l) ∧
      (SuperTrue (Boundary (flow.FedFrom web) .clearer) (SignificantWithin sig .clearer) →
        web.Adds sig .clearer l web.level ∧ ¬ web.Retains sig .clearer web.level l) ∧
      web.Retains (bounded (WithinClosure (flow.FedFrom web))) .clearer web.level l :=
  have counts : SubTrue (Boundary (flow.Shares web) .clearer) (SignificantWithin sig .clearer) →
      web.Adds sig .clearer l web.level ∧ ¬ web.Retains sig .clearer web.level l :=
    fun presupposed =>
      have adds : web.Adds sig .clearer l web.level :=
        ⟨2, .dweller, subTrue_significantWithin_iff.mp presupposed 2 .dweller levels.2.2,
         admitted_without without 2, unsupported_with 0⟩
      ⟨adds, fun retains => retains.not_added adds⟩
  ⟨counts,
   fun super => counts ⟨fun _ => True, Boundary.whole _, fun g _ t =>
     (superTrue_significantWithin_iff (Boundary.whole _)).mp super t g⟩,
   (system_counts_dweller without).2.2.of_fewer fun _ _ _ within =>
     Flow.withinInfluence_of_withinFeeding (within)⟩

/-- The clearer's web is one system, so the continuation condition is exactly the presupposition drawn along sharing
a condition at every standpoint. -/
theorem system_presupposition (sig : Formation → Nat → Formation → Prop) :
    Unrestricted sig ↔
      ∀ p, SubTrue (Boundary (flow.Shares web) p) (SignificantWithin sig p) :=
  Flow.unrestricted_iff_system_presupposed (center := id) system_whole.1

end Clearing

/-! Significance the same from every standpoint that counts one formation only. -/

namespace OneCounts

/-- From either standpoint only `true`'s continuation has significance. -/
def sig : Bool → Nat → Bool → Prop :=
  fun _ _ g => g = true

/-- The two forms of the step come apart without the presupposition at every standpoint.
Significance is standpoint-invariant. Along the empty relation the presupposition at `true` holds
as its boundary is drawn at `true` alone and fails at the whole, so it is not invariant across
`true`'s boundaries; at `false` it is not sub-true. -/
theorem forms_apart :
    StandpointInvariant sig ∧
      ¬ BoundaryInvariant (Boundary (fun _ _ => False) true) (SignificantWithin sig true) ∧
      ¬ SubTrue (Boundary (fun _ _ => False) false) (SignificantWithin sig false) :=
  ⟨fun _ _ _ _ same => same,
   fun invariant => Bool.noConfusion (invariant (fun g => g = true) (fun _ => True)
     ⟨fun _ _ _ no => no.elim, rfl⟩ (Boundary.whole true) (fun _ same _ => same) false trivial 0),
   fun sub => Bool.noConfusion (subTrue_empty_iff.mp sub 0)⟩

end OneCounts

end Becoming

section BoundaryFlows

/-!
## Boundary flows: the self's boundaries drawn along what a flow relates

`Becoming.Boundaries` states, along any relation among formations, the boundaries of a
formation's self (`Boundary`: a region holding the formation, closed under the relation), truth
however the boundary is drawn (`SuperTrue`, `SubTrue`, `BoundaryInvariant`), and the self's
presupposition (`SignificantWithin`) with the decomposition of the continuation condition through
it. A flow and its web form the relations it is drawn along: feeding (`Flow.FedFrom`), affecting
(`Flow.Affects`, whose closure is the reach closure `Flow.WithinReach`) and sharing a condition
(`Flow.Shares`, whose closure is the system `Flow.WithinSystem`). This section states the laws of
`Becoming.Boundaries` for the boundaries drawn along a flow's relations, and proves them through
those laws. Every closed region holding the center, the whole included, counts as a drawing of the
self, as in `Becoming.Boundaries`.

* **The scope of “within the self”, along affecting.** Every formation lies within the self as its
  boundary is drawn somewhere (`subTrue_member`); wherever the whole is a drawing, “everything
  within the self has a property” is super-true exactly when everything has it
  (`superTrue_all_iff`); significance bounded by each center's reach closure is the significance of
  what lies within the self however its boundary is drawn (`bounded_reach_iff`). The operator
  “however the boundary is drawn” at narrow scope gives the presupposition sub-true, at wide scope
  the continuation condition at that standpoint (`reach_scopes`). Sub-true along affecting, the
  presupposition gives the center's own continuation significance (`own_continuation`).
* **Super-truth, whatever the flow's relation.** The continuation condition is the presupposition
  held however each self's boundary is drawn along affecting (`unrestricted_iff_superTrue`), and the
  presupposition is super-true drawn along feeding exactly when drawn along sharing a condition
  (`superTrue_level_free`).
* **Where the system is the whole.** Under one condition every formation takes part in, the whole
  is the only boundary of a self drawn along sharing a condition (`only_whole_of_common`), and the
  presupposition drawn along sharing is the presupposition drawn along everything
  (`shares_iff_total_of_common`).
* **The step, along affecting.** Invariance of the presupposition is its determinacy
  (`boundaryInvariant_iff_determinate`) and its extension to the whole
  (`boundaryInvariant_iff_extends`); invariant, it is nowhere true where some continuation lacks
  significance (`not_subTrue_of_invariant`). Sub-true and invariant at every standpoint, it gives
  the continuation condition (`unrestricted_of_presupposed`); with every formation within some
  center's reach closure, invariance is standpoint-invariance
  (`boundaryInvariant_iff_standpointInvariant`); and the premises give living significance at the
  level of claims on every reading by continuations (`significant_of_presupposed`).
* **The whole as region.** Under significance bounded by the whole, retaining what has significance
  along a web is inclusion (`retains_whole_iff_includes`).

The presupposition, covering and invariance remain premises, as in `Becoming.Boundaries`; nothing
here derives them. Significance is supplied, as every significance is; no ranking or axiom occurs.
-/

namespace Becoming

namespace BoundaryFlows

variable {F C Pos : Type}

section Drawn

variable (L : Flow F C) (W : Web F C)

/-! ### The scope of “within the self”, along affecting -/

/-- **Along affecting, “everything within the self has the property” is super-true exactly when
everything has it.** -/
theorem superTrue_all_iff (f : F) {s : F → Prop} :
    SuperTrue (Boundary (L.Affects W) f) (fun region => ∀ g, region g → s g) ↔ ∀ g, s g :=
  Becoming.superTrue_all_iff (Boundary.whole f)

/-- **Significance bounded by each center's reach closure is the significance of what lies within
the self however its boundary is drawn along affecting.** -/
theorem bounded_reach_iff (center : Pos → F) (p : Pos) (t : Nat) (g : F) :
    bounded (fun q => L.WithinReach W (center q)) p t g ↔
      SuperTrue (Boundary (L.Affects W) (center p)) (fun region => region g) :=
  bounded_closure_iff (L.Affects W) center p t g

/-- **The two scopes, along affecting.** From standpoint `p`, “whatever lies definitely within the
self has significance” is the presupposition sub-true along affecting; “however the boundary is
drawn along affecting, everything within the self has significance” is the continuation of
everything having significance from `p`. -/
theorem reach_scopes (f : F) (sig : Pos → Nat → F → Prop) (p : Pos) :
    ((∀ t g, SuperTrue (Boundary (L.Affects W) f) (fun region => region g) → sig p t g) ↔
        SubTrue (Boundary (L.Affects W) f) (SignificantWithin sig p)) ∧
      (SuperTrue (Boundary (L.Affects W) f) (SignificantWithin sig p) ↔ ∀ t g, sig p t g) :=
  presupposition_scopes (L.Affects W) f sig p

/-! ### Super-truth, whatever the flow's relation -/

/-- **The continuation condition is the presupposition held however each self's boundary is drawn
along affecting.** -/
theorem unrestricted_iff_superTrue (center : Pos → F) {sig : Pos → Nat → F → Prop} :
    Unrestricted sig ↔
      ∀ p, SuperTrue (Boundary (L.Affects W) (center p)) (SignificantWithin sig p) :=
  Becoming.unrestricted_iff_superTrue (L.Affects W) center

/-- **Super-truth drawn along feeding is super-truth drawn along sharing a condition.** -/
theorem superTrue_level_free (f : F) (sig : Pos → Nat → F → Prop) (p : Pos) :
    SuperTrue (Boundary (L.FedFrom W) f) (SignificantWithin sig p) ↔
      SuperTrue (Boundary (L.Shares W) f) (SignificantWithin sig p) :=
  Becoming.superTrue_level_free (L.FedFrom W) (L.Shares W) f sig p

/-! ### The step, along affecting -/

/-- **Along affecting, invariance is extension to the whole**: holding as the boundary is drawn
anywhere along affecting, the presupposition holds as it is drawn at the whole. -/
theorem boundaryInvariant_iff_extends {f : F} {sig : Pos → Nat → F → Prop} {p : Pos} :
    BoundaryInvariant (Boundary (L.Affects W) f) (SignificantWithin sig p) ↔
      ∀ region, Boundary (L.Affects W) f region → SignificantWithin sig p region →
        SignificantWithin sig p fun _ => True :=
  Becoming.boundaryInvariant_iff_extends (Boundary.whole f)

end Drawn

section Related

variable {L : Flow F C} {W : Web F C}

/-! ### The center's own continuation -/

/-- **The presupposition drawn along affecting gives the center's own continuation significance.**
-/
theorem own_continuation {f : F} {sig : Pos → Nat → F → Prop} {p : Pos}
    (presupposed : SubTrue (Boundary (L.Affects W) f) (SignificantWithin sig p)) :
    ∀ t, sig p t f :=
  subTrue_empty_iff.mp (subTrue_of_larger (rel := fun _ _ => False) (fun _ _ no => no.elim)
    presupposed)

/-! ### Where the system is the whole -/

/-- **Under a common condition the whole is the only boundary drawn along sharing.** Where every
formation takes part in one condition, every boundary of a self along sharing a condition holds
every formation. -/
theorem only_whole_of_common {c : C} (common : ∀ g, L.TakesPart W g c) {f : F}
    {region : F → Prop} (boundary : Boundary (L.Shares W) f region) : ∀ g, region g :=
  Boundary.only_whole (Flow.system_whole_of_common common f) boundary

/-- **Under a common condition, drawing the self along sharing is drawing it along everything.**
Where every formation takes part in one condition, the presupposition is sub-true along sharing a
condition exactly when it is sub-true along the total relation. -/
theorem shares_iff_total_of_common {c : C} (common : ∀ g, L.TakesPart W g c) {f : F}
    {sig : Pos → Nat → F → Prop} {p : Pos} :
    SubTrue (Boundary (L.Shares W) f) (SignificantWithin sig p) ↔
      SubTrue (Boundary (fun _ _ => True) f) (SignificantWithin sig p) :=
  ⟨fun sub => subTrue_total_iff.mpr fun t g =>
     subTrue_significantWithin_iff.mp sub t g (Flow.system_whole_of_common common f g),
   (Flow.presupposition_order (L := L) (W := W)).1⟩

/-! ### The step from the presupposition -/

/-- **Invariant along affecting, the presupposition holds nowhere where some continuation lacks
significance.** -/
theorem not_subTrue_of_invariant {f : F} {sig : Pos → Nat → F → Prop} {p : Pos}
    (invariant : BoundaryInvariant (Boundary (L.Affects W) f) (SignificantWithin sig p))
    {t : Nat} {g : F} (lacks : ¬ sig p t g) :
    ¬ SubTrue (Boundary (L.Affects W) f) (SignificantWithin sig p) :=
  Becoming.not_subTrue_of_invariant (Boundary.whole f) invariant lacks

/-- **The continuation condition from the presupposition along affecting.** Where each standpoint's
presupposition is sub-true and invariant across the boundaries of its center's self drawn along
affecting, nothing restricts significance. Every formation lies within the whole, a drawing of every
self. -/
theorem unrestricted_of_presupposed {center : Pos → F} {sig : Pos → Nat → F → Prop}
    (presupposed : ∀ p, SubTrue (Boundary (L.Affects W) (center p)) (SignificantWithin sig p))
    (invariant : ∀ p, BoundaryInvariant (Boundary (L.Affects W) (center p))
      (SignificantWithin sig p)) :
    Unrestricted sig :=
  Becoming.unrestricted_of_presupposed (fun p _ => ⟨_, Boundary.whole (center p), trivial⟩)
    presupposed invariant

/-- **Living significance at the level of claims, from the premises along affecting**, on every
reading in which a claim's significance from a standpoint is that of some formation's continuation
at some step. -/
theorem significant_of_presupposed {Q : Type} {V : Valuation Pos Q} {center : Pos → F}
    {sig : Pos → Nat → F → Prop}
    (premises : ∀ p, SubTrue (Boundary (L.Affects W) (center p)) (SignificantWithin sig p) ∧
      BoundaryInvariant (Boundary (L.Affects W) (center p)) (SignificantWithin sig p))
    (formation : Q → F) (step : Q → Nat) (reads : ∀ p c, sig p (step c) (formation c) → V.sig p c) :
    V.Significant :=
  Valuation.significant_of_presupposed (fun p => Boundary.whole (center p)) premises formation step
    reads

end Related

/-! ### The whole as region -/

/-- **Under significance bounded by the whole, retaining is inclusion**: along a web, `l` retains
what has significance along `l'` from any standpoint exactly when it includes what `l'` admits. -/
theorem retains_whole_iff_includes (W : Web F C) (p : Pos) {l l' : Nat → C → Nat} :
    W.Retains (bounded fun (_ : Pos) (_ : F) => True) p l l' ↔ W.Includes l l' :=
  Web.retains_iff_includes bounded_whole p

end BoundaryFlows

end Becoming

end BoundaryFlows

section BoundaryWorlds

/-!
## Boundary worlds: the presupposition along what affects what in a world

`Becoming.Readings` restates two results of `Becoming.Boundaries` as a dichotomy: under the
invariance standard, the presupposition that one's own continuation has significance holds as the
boundary is drawn somewhere exactly where the continuation of everything has significance from
that standpoint (`presupposition_iff_all_of_invariant`), and a rival bounded by a region holding
the self's closure meets the standard exactly where the region is everything
(`bounded_invariant_iff`). Both are stated there for any relation between formations. This section
states them for the relation of a world: its relata, related where one exchanges with a condition
the other depends on (`Flow.Affects` of the world's flow and web), with boundaries closed under it
(`Boundary`) and the closure its reach (`Flow.WithinReach`).

* **Within some boundary is for everything.** In every world, where the presupposition drawn along
  affecting at a standpoint's center is boundary-invariant, it holds as the boundary is drawn
  somewhere exactly when the continuation of every relatum has significance from that standpoint
  at every step (`presupposition_iff_all`).
* **A bounded rival meets the standard only as everything.** In every world, a significance
  bounded by a region holding the center's reach meets the invariance standard along affecting
  exactly where the region holds every relatum (`bounded_invariant_iff`).

The significance enters only as a predicate the theorems quantify over; nothing here asserts that
it meets the standard or that the presupposition holds. No ethical predicate, ranking or axiom
occurs.

Declarations moved here unchanged, with their names, from `Becoming.Readings` (board item W): see
the sections so headed.
-/

/-! ### The presupposition as a dichotomy (moved from `Becoming.Readings`) -/

namespace Becoming

variable {F C Pos : Type}

/-- Under invariance the presupposition is the continuation condition at that standpoint: wherever the whole is
admissible and the presupposition is boundary-invariant, it holds as the boundary is drawn
somewhere exactly when the continuation of everything has significance from `p`. A restatement of
`boundaryInvariant_iff_conditional`. -/
theorem presupposition_iff_all_of_invariant {admissible : (F → Prop) → Prop}
    (whole : admissible fun _ => True) {sig : Pos → Nat → F → Prop} {p : Pos}
    (invariant : BoundaryInvariant admissible (SignificantWithin sig p)) :
    SubTrue admissible (SignificantWithin sig p) ↔ ∀ t g, sig p t g :=
  ⟨(boundaryInvariant_iff_conditional whole).mp invariant,
   fun all => ⟨_, whole, fun g _ t => all t g⟩⟩

/-- A rival bounded by a region holding the self's closure meets the standard exactly where the
region is everything: along a relation, its presupposition is invariant exactly where the region
holds every formation. A case of `boundaryInvariant_iff_all`. -/
theorem bounded_invariant_iff {rel : F → F → Prop} {center : Pos → F} {region : Pos → F → Prop}
    {p : Pos} (holds : ∀ g, WithinClosure rel (center p) g → region p g) :
    BoundaryInvariant (Boundary rel (center p)) (SignificantWithin (bounded region) p) ↔
      ∀ g, region p g :=
  (boundaryInvariant_iff_all (Boundary.whole (center p))
      ⟨_, Boundary.closure (center p), fun g within _ => holds g within⟩).trans
    ⟨fun all g => all 0 g, fun all _ g => all g⟩

end Becoming


namespace Becoming

namespace BoundaryWorlds

variable {Pos : Type}

/-- **In every world, under invariance along affecting, the presupposition holding within some
boundary is significance for every relatum.** -/
theorem presupposition_iff_all (w : World) {center : Pos → w.Relatum}
    {sig : Pos → Nat → w.Relatum → Prop} {p : Pos}
    (invariant : BoundaryInvariant (Boundary (w.flow.Affects w.web) (center p))
      (SignificantWithin sig p)) :
    SubTrue (Boundary (w.flow.Affects w.web) (center p)) (SignificantWithin sig p) ↔
      ∀ t g, sig p t g :=
  presupposition_iff_all_of_invariant (Boundary.whole (center p)) invariant

end BoundaryWorlds

end Becoming

end BoundaryWorlds
