import Becoming.Feedback
import Becoming.Significance

/-!
# Bounded significance under the continuation condition

Where significance bounded by a region (`bounded`, of `Becoming.Retaining`), the route without
axiom of `Becoming.Interdependence` and `Becoming.Feedback`, meets the continuation condition of
`Becoming.Significance` (`Unrestricted`). Each theorem here takes the condition as a hypothesis or
concludes it; the two modules it reads neither import nor assume it.

* **Bounded by the whole is the condition.** Significance bounded by the whole is the continuation
  condition (`bounded_whole`). Where every formation one path admits lies in a standpoint's region
  or is admitted by the other, the bounded verdict is the condition's
  (`Web.retains_bounded_iff_retains`). Where a formation's feeding closure is the whole, the verdict
  within the closure is the condition's on every comparison (`Flow.within_closure_iff_retains`),
  as in `Overshoot` (`Overshoot.within_closure_iff_retains`). Under a common condition that feeds,
  significance bounded by each center's feeding closure is the continuation condition
  (`Flow.feeding_unrestricted_of_common`), and so is significance bounded by each center's system
  where it is the whole (`Flow.bounded_system_whole`, `Clearing.system_whole`).
* **Where the route and the condition part.** In `Clearing`, from the clearer's standpoint its
  part retains what has significance within its feeding closure, while under the condition it
  loses the dweller from every standpoint (`Clearing.within_closure_yet_loses`); significance
  bounded by each reach closure is not the condition, yet from the clearer's standpoint the part
  loses the dweller, as under it (`Clearing.reach_counts_dweller`). In `Trophic`, with the deer's
  browsing held, the wolves' part narrows and under the condition retains from no standpoint
  (`Trophic.mediated_uncoupled`); against the flow in which the deer respond the taking is mixed
  (`Trophic.responsive_mixed`); and a part with a member beyond a system is judged retaining by
  significance bounded by systems while under the condition it loses the deer
  (`Trophic.mixed_part`).

Every declaration moved here unchanged, with its name, in R31 (20 October 2026), from
`Becoming.Interdependence` (`bounded_whole`, `Web.retains_bounded_iff_retains`,
`Flow.within_closure_iff_retains`, `Overshoot.within_closure_iff_retains`,
`Clearing.within_closure_yet_loses`) and `Becoming.Feedback` (the rest), so that those modules
and the modules importing them do not import the condition. The condition is supplied, not
asserted; no ranking or axiom occurs.
-/

namespace Becoming

variable {F C Pos : Type}

/-! ## Where bounded significance meets the continuation condition -/

/-- Significance bounded by the whole is the continuation condition: where each standpoint's region is the whole,
nothing restricts significance. -/
theorem bounded_whole : Unrestricted (bounded fun (_ : Pos) (_ : F) => True) :=
  fun _ => trivial

namespace Web

variable {W : Web F C}

/-- Under the continuation condition, wherever every formation `l'` admits lies in `p`'s region or is admitted by
`l`, the verdict of significance bounded by the region is the continuation condition's. -/
theorem retains_bounded_iff_retains {sig : Pos → Nat → F → Prop}
    (unrestricted : Unrestricted sig) {region : Pos → F → Prop} {p : Pos}
    {l l' : Nat → C → Nat}
    (covers : ∀ t f, W.Admits (l' t) t f → region p f ∨ W.Admits (l t) t f) :
    W.Retains (bounded region) p l l' ↔ W.Retains sig p l l' :=
  (retains_bounded_iff_includes covers).trans (retains_iff_includes unrestricted p).symm

end Web

namespace Flow

variable {L : Flow F C} {W : Web F C}

/-- Where a formation's feeding closure is the whole, under the continuation condition the verdict within its
closure is the continuation condition's on every comparison. -/
theorem within_closure_iff_retains {sig : F → Nat → F → Prop}
    (unrestricted : Unrestricted sig) {p : F} (whole : ∀ f, L.WithinFeeding W p f)
    {l l' : Nat → C → Nat} :
    W.Retains (bounded (L.WithinFeeding W)) p l l' ↔ W.Retains sig p l l' :=
  Web.retains_bounded_iff_retains unrestricted fun _ f _ => .inl (whole f)

/-- Under a common condition that feeds, significance bounded by each center's feeding closure,
the route without axiom of `Becoming.Interdependence`, is the continuation condition. -/
theorem feeding_unrestricted_of_common {Pos : Type} {t : Nat} {c : C}
    (common : ∀ g, g ∈ L.present t ∧ W.requires t g c ∧ 0 < L.give t g c) (center : Pos → F) :
    Unrestricted (bounded fun q => L.WithinFeeding W (center q)) :=
  fun i => feeding_whole_of_common common (center i.1) i.2.2

/-- Where each center's system is the whole, significance bounded by the system is the continuation condition. -/
theorem bounded_system_whole {Pos : Type} {center : Pos → F}
    (connected : ∀ p g, L.WithinSystem W (center p) g) :
    Unrestricted (bounded fun p => L.WithinSystem W (center p)) :=
  fun i => connected i.1 i.2.2

/-! ## Feeding from a step -/

section FeedingFrom

variable (L : Flow F C) (W : Web F C)

/-- `g`'s continuation is fed from `h` at some step from `s` on. -/
def FedFromAfter (s : Nat) (g h : F) : Prop :=
  ∃ t, s ≤ t ∧ L.FedBy W (g, t) (h, t)

/-- **The feeding closure from a step**: what feeds `f`'s continuation at some step from `s` on,
or feeds what does. Unlike the feeding closure across every step (`WithinFeeding`), it shrinks as
feeding stops. -/
def WithinFeedingFrom (s : Nat) (f g : F) : Prop :=
  WithinClosure (L.FedFromAfter W s) f g

variable {L W}

/-- From the first step it is the feeding closure. -/
theorem withinFeedingFrom_zero {f g : F} : L.WithinFeedingFrom W 0 f g ↔ L.WithinFeeding W f g :=
  ⟨WithinClosure.mono fun _ _ ⟨t, _, fed⟩ => ⟨t, fed⟩,
   WithinClosure.mono fun _ _ ⟨t, fed⟩ => ⟨t, Nat.zero_le t, fed⟩⟩

/-- **It shrinks with time**: what lies in the closure from a later step lies in the closure from
an earlier one. -/
theorem WithinFeedingFrom.earlier {s s' : Nat} (le : s ≤ s') {f g : F}
    (within : L.WithinFeedingFrom W s' f g) : L.WithinFeedingFrom W s f g :=
  WithinClosure.mono (fun _ _ ⟨t, late, fed⟩ => ⟨t, Nat.le_trans le late, fed⟩) within

/-- **What gives to no requirement from `s` on lies outside every other formation's closure from
`s`.** -/
theorem not_withinFeedingFrom {s : Nat} {h : F}
    (quits : ∀ t x c, s ≤ t → W.requires t x c → h ∈ L.present t → ¬ 0 < L.give t h c) {f : F}
    (ne : f ≠ h) : ¬ L.WithinFeedingFrom W s f h :=
  fun within => within (fun x => x ≠ h)
    (fun x _ _ ⟨t, late, _, c, requires, present, gives⟩ same =>
      quits t x c late requires (Eq.subst (motive := fun z => z ∈ L.present t) same present)
        (Eq.subst (motive := fun z => 0 < L.give t z c) same gives))
    ne rfl

/-- **Care bounded by feeding from each step permits ending what feeds no more.** With significance
at step `t` bounded by the center's feeding closure from `t`: where `h`, not the center, gives to
no requirement from `T` on, and `l` admits every formation `l'` admits except `h` from `T` on, `l`
retains from the center what has that significance against `l'`. -/
theorem feedingFrom_permits {p h : F} (ne : p ≠ h) {T : Nat}
    (quits : ∀ t x c, T ≤ t → W.requires t x c → h ∈ L.present t → ¬ 0 < L.give t h c)
    {l l' : Nat → C → Nat}
    (only : ∀ t f, W.Admits (l' t) t f → W.Admits (l t) t f ∨ (f = h ∧ T ≤ t)) :
    W.Retains (fun q t g => L.WithinFeedingFrom W t q g) p l l' :=
  fun t f within admits => match only t f admits with
    | .inl kept => kept
    | .inr ⟨same, late⟩ => absurd (Eq.subst (motive := L.WithinFeedingFrom W t p) same within)
        (not_withinFeedingFrom (fun t' x c le => quits t' x c (Nat.le_trans late le)) ne)

/-- **Under the continuation condition the same part loses.** Where `l'` admits a formation at a
step at which `l` does not, `l` retains against `l'` from no standpoint; with `feedingFrom_permits`,
care bounded by feeding from each step permits what the condition counts as a loss. -/
theorem feedingFrom_parts {sig : F → Nat → F → Prop} (unrestricted : Unrestricted sig) {p h : F}
    (ne : p ≠ h) {T : Nat}
    (quits : ∀ t x c, T ≤ t → W.requires t x c → h ∈ L.present t → ¬ 0 < L.give t h c)
    {l l' : Nat → C → Nat}
    (only : ∀ t f, W.Admits (l' t) t f → W.Admits (l t) t f ∨ (f = h ∧ T ≤ t)) {t : Nat}
    (admits : W.Admits (l' t) t h) (lost : ¬ W.Admits (l t) t h) :
    W.Retains (fun q t g => L.WithinFeedingFrom W t q g) p l l' ∧ ¬ W.Retains sig p l l' :=
  ⟨feedingFrom_permits ne quits only, fun retains => lost (retains t h (unrestricted (p, t, h)) admits)⟩

end FeedingFrom

end Flow

/-! ## Witnesses -/

namespace Overshoot

/-- In this interdependent whole, under the continuation condition, the verdict within a formation's feeding
closure is the continuation condition's, from either standpoint and on every comparison. -/
theorem within_closure_iff_retains {sig : Bool → Nat → Bool → Prop}
    (unrestricted : Unrestricted sig) (p : Bool) {l l' : Nat → Bool → Nat} :
    web.Retains (bounded (flow.WithinFeeding web)) p l l' ↔ web.Retains sig p l l' :=
  Flow.within_closure_iff_retains unrestricted (closure_whole p)

end Overshoot

namespace Trophic

/-- The mediated effect does not show in the comparison that holds the rest of the exchange
fixed. The wolves lie within the forest's influence closure, yet their part does not reach the
forest: with the deer's browsing held as it is, the forest is supported with the part exactly
where the levels without it admit it, at every step. So compared, the part narrows: the levels
without it include those with it and admit the deer where those with it do not. Under the continuation condition
it does not retain what has significance, from any standpoint. -/
theorem mediated_uncoupled {l : Nat → Place → Nat}
    (without : flow.WithheldLevels wolvesPart web l) {Pos : Type}
    {sig : Pos → Nat → Formation → Prop} (unrestricted : Unrestricted sig) (p : Pos) :
    flow.WithinInfluence web .forest .wolves ∧ ¬ flow.Reaches web wolvesPart .forest ∧
      (∀ t, web.Supported t .forest ↔ web.Admits (l t) t .forest) ∧
      web.Includes l web.level ∧ web.Exceeds l web.level ∧ ¬ web.Retains sig p web.level l :=
  have deer := deer_without_wolves without
  ⟨mediates.2.2.2.2.2.2.2.2.2.2.2.2.2.2.2.1, wolves_unreached,
   fun t => balances.admits_unreached without wolves_unreached t,
   balances.opens_nothing without fun _ _ => Nat.zero_le _, ⟨1, .deer, deer.1, deer.2⟩,
   fun retains => retains.not_added ⟨1, .deer, unrestricted (p, 1, .deer), deer.1, deer.2⟩⟩

/-- Compared with the flow in which the deer respond, the wolves' taking is mixed: with it the
forest is admitted at the third step and without it not, and without it the deer are admitted at
the second step and with it not. Under the continuation condition neither level path retains what has
significance along the other. -/
theorem responsive_mixed {Pos : Type} {sig : Pos → Nat → Formation → Prop}
    (unrestricted : Unrestricted sig) (p : Pos) :
    web.Exceeds web.level responsiveWeb.level ∧ web.Exceeds responsiveWeb.level web.level ∧
      ¬ web.Retains sig p web.level responsiveWeb.level ∧
      ¬ web.Retains sig p responsiveWeb.level web.level :=
  have forest : web.Exceeds web.level responsiveWeb.level :=
    ⟨2, .forest, fun c requires => match c, requires with
      | .growth, _ => Nat.succ_le_succ (Nat.zero_le 1)
      | .herd, no => nomatch no
      | .den, no => (nomatch no),
     fun admits => Nat.not_succ_le_zero 0 (admits .growth trivial)⟩
  have deer : web.Exceeds responsiveWeb.level web.level :=
    ⟨1, .deer, fun c requires => match c, requires with
      | .growth, no => nomatch no
      | .herd, _ => Nat.le_refl 1
      | .den, no => (nomatch no),
     fun admits => Nat.not_succ_le_zero 0 (admits .herd trivial)⟩
  ⟨forest, deer,
   fun retains => retains.not_added ((Web.adds_iff_exceeds unrestricted p).mpr deer),
   fun retains => retains.not_added ((Web.adds_iff_exceeds unrestricted p).mpr forest)⟩

/-- A part with members beyond a system. From the far formation's standpoint, significance bounded
by each formation's system judges the joint part of the far formation and the wolves as
retaining, while under the continuation condition the part loses the deer: the comparison within the system holds
for parts within it. -/
theorem mixed_part {l : Nat → Place → Nat} (without : flow.WithheldLevels farWolvesPart web l)
    {sig : Formation → Nat → Formation → Prop} (unrestricted : Unrestricted sig) :
    farWolvesPart .far = true ∧ ¬ flow.WithinSystem web .far .wolves ∧
      web.Retains (bounded (flow.WithinSystem web)) .far web.level l ∧
      ¬ web.Retains sig .far web.level l :=
  have admitted : web.Admits (l 1) 1 .deer := fun c requires => match c, requires with
    | .growth, no => nomatch no
    | .herd, _ => Nat.le_of_eq (without.unique farWolves_withheld 1 .herd).symm
    | .den, no => nomatch no
  ⟨rfl, fun within => Formation.noConfusion (far_system within),
   fun _ g within _ => match g, far_system within with
    | _, rfl => fun c requires => match c, requires with
      | .growth, no => nomatch no
      | .herd, no => nomatch no
      | .den, _ => Nat.le_refl 1,
   fun retains => retains.not_added ⟨1, .deer, unrestricted (.far, 1, .deer), admitted,
     fun admits => Nat.not_succ_le_zero 0 (admits .herd trivial)⟩⟩

end Trophic

namespace Clearing

/-- The route and the continuation condition part here. From the clearer's standpoint its part retains what has
significance within its feeding closure. Under the continuation condition the part loses the dweller from every
standpoint, and from the dweller's standpoint, within the dweller's own closure, it loses the
dweller too. -/
theorem within_closure_yet_loses {l : Nat → Place → Nat}
    (without : flow.WithheldLevels clearerPart web l) {sig : Pos → Nat → Formation → Prop}
    (unrestricted : Unrestricted sig) (p : Pos) :
    web.Retains (bounded (flow.WithinFeeding web)) .clearer web.level l ∧
      ¬ web.Retains sig p web.level l ∧
      web.Adds (bounded (flow.WithinFeeding web)) .dweller l web.level :=
  ⟨Web.retains_bounded_iff.mpr fun t => ((loses_beyond without).1 t).2.2.narrow
      fun _ within => within alongDependence fedClosed trivial,
   (clearer_loses_dweller without unrestricted p).2.1,
   ⟨2, .dweller, Flow.WithinFeeding.refl _, admitted_without without 2, unsupported_with 0⟩⟩

/-- The clearer's web is one system: every formation lies within every other's system, so
significance bounded by each formation's system is the continuation condition. Here the system does not separate
from the whole; the reach closure does (`reach_counts_dweller`). -/
theorem system_whole :
    (∀ p g, flow.WithinSystem web p g) ∧ Unrestricted (bounded (flow.WithinSystem web)) :=
  have whole : ∀ p g, flow.WithinSystem web p g := fun p g =>
    (clearer_system p).symm.trans (clearer_system g)
  ⟨whole, Flow.bounded_system_whole (center := id) whole⟩

/-- Significance bounded by each formation's reach closure is not the continuation condition, yet from the
clearer's standpoint it judges the clearer's own part as the continuation condition does: the part loses the
dweller. Bounded by the influence closure, the part retains (`system_counts_dweller`). -/
theorem reach_counts_dweller {l : Nat → Place → Nat}
    (without : flow.WithheldLevels clearerPart web l) :
    ¬ Unrestricted (bounded (flow.WithinReach web)) ∧
      web.Adds (bounded (flow.WithinReach web)) .clearer l web.level ∧
      ¬ web.Retains (bounded (flow.WithinReach web)) .clearer web.level l ∧
      (web.Retains (bounded (flow.WithinReach web)) .clearer web.level l ↔
        web.Includes web.level l) :=
  have adds : web.Adds (bounded (flow.WithinReach web)) .clearer l web.level :=
    ⟨2, .dweller, reach_middle.1, admitted_without without 2, unsupported_with 0⟩
  ⟨fun all => reach_middle.2.1 (all (.clearer, 0, .source)), adds,
   fun retains => retains.not_added adds,
   (balances.comparison_within_reach without (sig := bounded (flow.WithinReach web))
     (p := Formation.clearer) fun _ _ reached =>
       Flow.reaches_withinReach (Flow.own_within_reach clearer_own) reached.reaches).1⟩


end Clearing

end Becoming
