import Becoming.Retaining
import Becoming.Witnesses
import Becoming.Continuation

/-!
# Clearing: a source, a clearer and a dweller (a model witness)

One witness, read by many modules: a source feeds the clearer's resource, the clearer takes the
dweller's habitat at the first two steps, and the dweller ends. Its definitions and the facts that
read no more than the base, the admission of `Becoming.Admission`, the regions of
`Becoming.Regions` and the retaining of `Becoming.Retaining` are stated here once; the modules
that read further notions on it (feeding, reach, systems, boundaries, the continuation
condition) state those facts where the notions are.

* **The witness.** The flow and web (`Clearing.flow`, `Clearing.web`) balance
  (`Clearing.balances`), meet dependence and dissipation (`Clearing.dependent`,
  `Clearing.dissipative`), and the clearer's resource is fed from beyond at every step
  (`Clearing.fed`).
  The clearer is active at every step and every condition it depends on is renewed, while it
  draws down the dweller's habitat (`Clearing.undermines_within_renewal`); only the clearer's
  continuation is fed, and only by the source (`Clearing.fedBy_source`).
* **Losing beyond the dependence.** The levels without the clearer's part exist
  (`Clearing.withheld`); without it the dweller is admitted at every step
  (`Clearing.admitted_without`, `Clearing.admitted_all_without`), with it the dweller is
  unsupported from step 2 on (`Clearing.unsupported_with`). Within the clearer and the
  source that feeds it (`Clearing.alongDependence`) the levels with the part admit everything
  the levels without it admit, and beyond it the dweller is lost (`Clearing.loses_beyond`); over
  the whole the part narrows (`Clearing.narrows`). The clearer renews over its resource at every
  step and undermines at step one (`Clearing.renewing_over_resource`).
* **Centers bounded by their dependence disagree.** With each formation's significance stopping
  at its region along its dependence (`Clearing.dependenceRegion`), the clearer's part retains
  what has significance from the clearer's standpoint and loses the dweller from the dweller's
  (`Clearing.centers_disagree`).

Every declaration moved here unchanged, with its name, in R31 (20 October 2026), from
`Becoming.Continuation` (the witness), `Becoming.Regions` (losing beyond the dependence) and
`Becoming.Significance` (retaining along the dependence). The endings are stipulated in the
witness's activity, shown consistent with balance, support and dependence. No condition, ranking
or axiom occurs.
-/

namespace Becoming

namespace Clearing

open Frontier (unburnt burning)

/-- A source, a clearer and a dweller. -/
inductive Formation where
  | source
  | clearer
  | dweller

/-- The clearer's resource, the dweller's habitat, and the fuels the source burns. -/
inductive Place where
  | resource
  | habitat
  | fuel (n : Nat)

/-- The clearer takes one unit of the habitat at each of the first two steps. -/
def cleared : Nat → Nat := Witnesses.profile [1, 1] 0

def habitatLevel : Nat → Nat := Witnesses.profile [2, 1] 0

def dwellerLive : Nat → Prop := Witnesses.profile [True, True] False

/-- The source burns the `t`th fuel, two units, and gives the resource one; the clearer takes one
unit of the resource at every step and clears the habitat. -/
def flow : Flow Formation Place where
  present _ := [.source, .clearer, .dweller]
  take t f c := match f, c with
    | .source, .fuel n => 2 * burning n t
    | .source, .resource => 0
    | .source, .habitat => 0
    | .clearer, .resource => 1
    | .clearer, .habitat => cleared t
    | .clearer, .fuel _ => 0
    | .dweller, _ => 0
  give _ f c := match f, c with
    | .source, .resource => 1
    | .source, .habitat => 0
    | .source, .fuel _ => 0
    | .clearer, _ => 0
    | .dweller, _ => 0

/-- The clearer depends on its resource, the dweller on its habitat, each at need
one. -/
def web : Web Formation Place where
  level t c := match c with
    | .resource => 1
    | .habitat => habitatLevel t
    | .fuel n => 2 * unburnt n t
  active t f := match f with
    | .source => True
    | .clearer => True
    | .dweller => dwellerLive t
  requires _ f c := match f, c with
    | .clearer, .resource => True
    | .dweller, .habitat => True
    | .source, _ => False
    | .clearer, .habitat => False
    | .clearer, .fuel _ => False
    | .dweller, .resource => False
    | .dweller, .fuel _ => False
  need _ _ _ := 1
  draws t f c := match f, c with
    | .source, .fuel n => n = t
    | .source, .resource => False
    | .source, .habitat => False
    | .clearer, .resource => True
    | .clearer, .habitat => True
    | .clearer, .fuel _ => False
    | .dweller, _ => False

theorem balances : flow.Balances web
  | _, .resource => rfl
  | 0, .habitat => rfl
  | 1, .habitat => rfl
  | _ + 2, .habitat => rfl
  | t, .fuel n => show 2 * unburnt n (t + 1) + (2 * burning n t + 0) = 2 * unburnt n t from
      (Nat.left_distrib 2 _ _).symm.trans (congrArg (2 * ·) (Frontier.burns n t))

theorem dependent : web.Dependent
  | _, .clearer, _, .resource, _ => Nat.le_refl 1
  | 0, .dweller, _, .habitat, _ => Nat.succ_le_succ (Nat.zero_le 1)
  | 1, .dweller, _, .habitat, _ => Nat.le_refl 1
  | _ + 2, .dweller, dead, .habitat, _ => nomatch dead
  | _, .source, _, _, no => nomatch no
  | _, .clearer, _, .habitat, no => nomatch no
  | _, .clearer, _, .fuel _, no => nomatch no
  | _, .dweller, _, .resource, no => nomatch no
  | _, .dweller, _, .fuel _, no => nomatch no

/-- Every family without repetition closed across a step is dissipated on: the source gives
the resource one unit and burns two; the clearer and the dweller give nothing. -/
theorem dissipative : flow.Dissipative
  | ds, t, distinct, closed, f, mem => match f, mem with
    | .clearer, _ => Nat.le_trans (Nat.le_of_eq ((congrArg (· + _) (total_zero ds)).trans
        (Nat.zero_add _))) (sign_le _)
    | .dweller, _ => show total ds (fun _ => 0) + sign (total ds (fun _ => 0)) ≤
          total ds (fun _ => 0) from
        Eq.subst (motive := fun x => x + sign x ≤ x) (total_zero ds).symm (Nat.le_refl 0)
    | .source, mem =>
      have gives : total ds (flow.give t .source) ≤ 1 :=
        total_le_at (q := flow.give t .source) (a := .resource) (fun c given => match c, given with
          | .resource, _ => rfl
          | .habitat, given => absurd given (Nat.lt_irrefl 0)
          | .fuel _, given => absurd given (Nat.lt_irrefl 0)) distinct
      have burnt : flow.take t .source (.fuel t) = 2 :=
        (congrArg (2 * ·) (Frontier.burning_self t)).trans (Nat.mul_one _)
      match Nat.decLe (total ds (flow.give t .source) + sign (total ds (flow.take t .source)))
          (total ds (flow.take t .source)) with
      | isTrue le => le
      | isFalse not => absurd (fun inside : Place.fuel t ∈ ds => not
          (Nat.le_trans (Nat.add_le_add gives (sign_le_one _))
            (Nat.le_trans (Nat.le_of_eq burnt.symm) (le_total_of_mem inside))))
          fun outside => Nat.noConfusion (burnt.symm.trans (closed .source mem (.fuel t) outside).1)

/-- The resource is fed from beyond at every step: the source conveys from the step's fuel. -/
theorem fed (t : Nat) : flow.FedFromBeyond [.resource] t :=
  ⟨.fuel t, .resource, (fun mem => match mem with | .tail _ no => nomatch no),
   .head _, .source, .head _,
   show 0 < 2 * burning t t from
     Eq.subst (motive := fun b => 0 < 2 * b) (Frontier.burning_self t).symm (Nat.succ_pos 1),
   Nat.zero_lt_one⟩

/-- Undermining within renewal. The clearer is active and supported at every step; the only
condition it depends on is its resource, which is renewed, fed from beyond and taken from
jointly within what each step gives; in a balanced, dissipative flow. Its clearing of the
habitat undermines at step one, and the dweller, depending on the habitat, is
inactive from step two on. -/
theorem undermines_within_renewal :
    flow.Balances web ∧ flow.Dissipative ∧ web.Dependent ∧
      (∀ t c, web.requires t .clearer c → c = .resource) ∧
      (∀ t, web.active t .clearer ∧ web.Supported t .clearer) ∧
      web.Renewed .resource ∧ (∀ t, flow.FedFromBeyond [.resource] t) ∧
      (∀ t, flow.WithinJoint t .resource) ∧
      web.UnderminingAt 1 .clearer ∧ ∀ n, ¬ web.active (n + 2) .dweller :=
  ⟨balances, dissipative, dependent,
   fun _ c depends => match c, depends with | .resource, _ => rfl,
   fun t => ⟨trivial, dependent t .clearer trivial⟩,
   fun _ g depends => match g, depends with | .clearer, _ => ⟨Nat.le_refl 1, Nat.le_refl 1⟩,
   fed, fun _ => Nat.le_refl 1,
   ⟨.habitat, trivial, .dweller, trivial,
    Web.MetAbove.now (W := web) (t := 1) (g := Formation.dweller) (c := Place.habitat)
      trivial (Nat.le_refl 1) Nat.zero_lt_one,
    Nat.zero_lt_one⟩,
   fun _ dead => dead⟩

end Clearing

namespace Clearing

open Frontier (burning)

/-- Only the clearer's continuation is fed, and only by the source. -/
theorem fedBy_source {e e' : Formation × Nat} (fed : flow.FedBy web e e') :
    e.1 = .clearer ∧ e'.1 = .source :=
  match e, e', fed with
  | (.clearer, _), (.source, _), _ => ⟨rfl, rfl⟩
  | (.clearer, _), (.clearer, _), ⟨_, .resource, _, _, gives⟩ => absurd gives (Nat.lt_irrefl 0)
  | (.clearer, _), (.dweller, _), ⟨_, .resource, _, _, gives⟩ => absurd gives (Nat.lt_irrefl 0)
  | (.source, _), _, ⟨_, _, no, _⟩ => nomatch no
  | (.dweller, _), (.source, _), ⟨_, .habitat, _, _, gives⟩ => absurd gives (Nat.lt_irrefl 0)
  | (.dweller, _), (.clearer, _), ⟨_, .habitat, _, _, gives⟩ => absurd gives (Nat.lt_irrefl 0)
  | (.dweller, _), (.dweller, _), ⟨_, .habitat, _, _, gives⟩ => absurd gives (Nat.lt_irrefl 0)

end Clearing

/-! ## Losing beyond the dependence -/

namespace Clearing

open Frontier (unburnt burning)

/-- The clearer's part. -/
def clearerPart : Formation → Bool
  | .source => false
  | .clearer => true
  | .dweller => false

/-- The clearer and the source that feeds the one condition it requires. -/
def alongDependence : Formation → Prop
  | .source => True
  | .clearer => True
  | .dweller => False

/-- The levels without the clearer's part: the resource rises by one at each step, the
habitat stays at two, and the source burns its fuels as before. -/
def withheldLevel (t : Nat) : Place → Nat
  | .resource => t + 1
  | .habitat => 2
  | .fuel n => 2 * unburnt n t

theorem withheld : flow.WithheldLevels clearerPart web withheldLevel :=
  ⟨fun t c => match c with
    | .resource => rfl
    | .habitat => rfl
    | .fuel n => show 2 * unburnt n (t + 1) + (2 * burning n t + 0) = 2 * unburnt n t from
        (Nat.left_distrib 2 _ _).symm.trans (congrArg (2 * ·) (Frontier.burns n t)),
   fun c => match c with
    | .resource => rfl
    | .habitat => rfl
    | .fuel _ => rfl⟩

/-- Without the clearer's part the dweller is admitted at every step. -/
theorem admitted_without {l : Nat → Place → Nat}
    (without : flow.WithheldLevels clearerPart web l) (t : Nat) :
    web.Admits (l t) t .dweller :=
  fun c requires => match c, requires with
  | .habitat, _ => Nat.le_trans (Nat.le_succ 1)
      (Nat.le_of_eq (without.unique withheld t .habitat).symm)
  | .resource, no => nomatch no
  | .fuel _, no => nomatch no

/-- With the clearer's part the dweller is not supported from the third step on. -/
theorem unsupported_with (n : Nat) : ¬ web.Supported (n + 2) .dweller :=
  fun supported => Nat.not_succ_le_zero 0 (supported .habitat trivial)

/-- The clearer's part narrows what can form: the levels without it include those with it,
and some formation is admitted without it and not with it. -/
theorem narrows {l : Nat → Place → Nat} (without : flow.WithheldLevels clearerPart web l) :
    web.Includes l web.level ∧ web.Exceeds l web.level :=
  ⟨balances.opens_nothing without fun _ _ => Nat.zero_le _,
   ⟨2, .dweller, admitted_without without 2, unsupported_with 0⟩⟩

/-- Continuing while losing beyond its dependence. At every step the clearer is active and
supported, and within itself and the source, the levels with its part admit everything the
levels without it admit. From the third step on, beyond them, the dweller is admitted
without the clearer's part and not with it. -/
theorem loses_beyond {l : Nat → Place → Nat} (without : flow.WithheldLevels clearerPart web l) :
    (∀ t, web.active t .clearer ∧ web.Supported t .clearer ∧
      web.AdmitsWithin alongDependence (web.level t) (l t) t) ∧
    ∀ n, web.LosesBeyond alongDependence (web.level (n + 2)) (l (n + 2)) (n + 2) :=
  ⟨fun t => ⟨trivial, dependent t .clearer trivial, fun f member _ => match f, member with
      | .source, _ => fun _ no => (nomatch no)
      | .clearer, _ => dependent t .clearer trivial⟩,
   fun n => ⟨.dweller, fun no => no, admitted_without without (n + 2), unsupported_with n⟩⟩

/-- Renewing over its resource. At every step the clearer is within renewal over its
resource, the one condition it requires, so it keeps its own support; at step one its draw on
the habitat undermines, and it is not within renewal. -/
theorem renewing_over_resource :
    (∀ t, web.RenewingOver (· = .resource) t .clearer) ∧
      (∀ t c, web.requires t .clearer c → c = .resource) ∧
      web.UnderminingAt 1 .clearer ∧ ¬ web.RenewingAt 1 .clearer :=
  match undermines_within_renewal with
  | ⟨_, _, _, only, _, renewed, _, _, undermining, _⟩ =>
    ⟨fun t => ⟨trivial, fun c same => match c, same with
        | _, rfl => fun _ g requires => renewed t g requires⟩,
     only, undermining, fun renewing => renewing.not_undermining undermining⟩

end Clearing

/-! ## Retaining along the dependence -/

namespace Clearing

/-- Without the clearer's part every formation is admitted at every step: the source requires
nothing, the resource rises by one at each step and the habitat stays at two. -/
theorem admitted_all_without {l : Nat → Place → Nat}
    (without : flow.WithheldLevels clearerPart web l) : ∀ t f, web.Admits (l t) t f
  | _, .source => fun _ no => nomatch no
  | t, .clearer => fun c requires => match c, requires with
    | .resource, _ => Nat.le_trans (Nat.succ_le_succ (Nat.zero_le t))
        (Nat.le_of_eq (without.unique withheld t .resource).symm)
    | .habitat, no => nomatch no
    | .fuel _, no => nomatch no
  | t, .dweller => admitted_without without t

/-- Each formation's region along its dependence: the clearer with the source that feeds its
resource; the source and the dweller, which nothing feeds, alone. -/
def dependenceRegion : Formation → Formation → Prop
  | .clearer, f => alongDependence f
  | .source, f => f = .source
  | .dweller, f => f = .dweller

/-- Centers bounded by their dependence license the clearer's part and disagree. With each
formation's significance stopping at its region along its dependence, the clearer's part retains
what has significance from the clearer's standpoint at every step, and loses the dweller from
the dweller's. -/
theorem centers_disagree {l : Nat → Place → Nat}
    (without : flow.WithheldLevels clearerPart web l) :
    web.Retains (bounded dependenceRegion) .clearer web.level l ∧
      web.Adds (bounded dependenceRegion) .dweller l web.level :=
  ⟨Web.retains_bounded_iff.mpr fun t => ((loses_beyond without).1 t).2.2,
   ⟨2, .dweller, rfl, admitted_without without 2, unsupported_with 0⟩⟩

end Clearing

end Becoming
