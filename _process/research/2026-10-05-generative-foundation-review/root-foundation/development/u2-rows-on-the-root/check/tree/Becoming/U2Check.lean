import Becoming.ProcessRepresentation
import Becoming.WorldRepresentation
import Becoming.Roles
import Becoming.JointKeeping
import Becoming.Verification
import Becoming.LimitVerification
import Becoming.Standpoints
import Becoming.Significance
import Becoming.Regions
import Becoming.Joint
import Becoming.Transmission
import Becoming.PoolResponse
import Becoming.Experiment
import Becoming.SharedCodes
import Becoming.LabelledRoles
import Becoming.Descent
import Becoming.Learning
import Becoming.Optimum
import Becoming.ValuationFrames

/-!
# Scratch check of U2's statements (not a landed module)

Each row stated at a World's occurrence model, at a process's model of its moves' relations, or on
the row's own carrier, every term of its statement a relation of the model: the grammar's, WRT2's
or WRP2's selection, a named comparison of the model's given amounts, or a supplied parameter. See
`DESIGN.md` in this folder. The namespace is the one proposed for the leaf.
-/

namespace Becoming

open Generative

namespace ModelStatements

universe u v w

/-! ## 1. The occurrence model of a web of one kind

A web of one kind `V : Web X X` read on its occurrences `Nat × X`, as WRT2 reads a World's. -/

section Occurrences

variable {X : Type} (V : Web X X)

/-- What an occurrence requires, within its step (WRT2's `World.withinStep`, the formation first). -/
def requiring : «际» (Nat × X) := World.withinStep V.requires

/-- What an occurrence draws on, within its step (WRT2's). -/
def drawing : «际» (Nat × X) := World.withinStep V.draws

/-- The needs met within a step (WRT2's): the need within the condition's level at that step. -/
def needMet : «际» (Nat × X) := World.withinStep fun t x y => V.need t x y ≤ V.level t y

/-- The occurrences active at their step (WRT2's activity, as a region). -/
def activeAt (o : Nat × X) : Prop := V.active o.1 o.2

/-- What an occurrence takes part in, within its step: requiring or drawing. -/
def participating : «际» (Nat × X) := World.withinStep fun t x y => V.requires t x y ∨ V.draws t x y

/-- What an occurrence requires at a positive need, within its step: the need read by its sign. -/
def bearing : «际» (Nat × X) := World.withinStep fun t x y => V.requires t x y ∧ 0 < V.need t x y

/-- **Support at an occurrence**: what it requires lies within the needs met. -/
theorem supported_iff (t : Nat) (x : X) :
    V.Supported t x ↔ «则» («而» (Web.partialIdentity (· = (t, x))) (requiring V)) (needMet V) :=
  ⟨fun supported o z ⟨y, ⟨same, at_o⟩, step, req⟩ => by
    subst same; subst at_o
    exact ⟨step, supported z.2 req⟩,
   fun within c req => (within (t, x) (t, c) ⟨(t, x), ⟨rfl, rfl⟩, rfl, req⟩).2⟩

/-- **Dependence**: requiring from the active occurrences lies within the needs met. -/
theorem dependent_iff :
    V.Dependent ↔ «则» («而» (Web.partialIdentity (activeAt V)) (requiring V)) (needMet V) :=
  ⟨fun dependent o z ⟨y, ⟨same, active⟩, step, req⟩ => by
    subst same
    exact ⟨step, dependent o.1 o.2 active z.2 req⟩,
   fun within t f active c req => (within (t, f) (t, c) ⟨(t, f), ⟨rfl, active⟩, rfl, req⟩).2⟩

end Occurrences

/-- Two occurrences of one name, at any two steps: the names' class. -/
def sameName {X : Type} : «际» (Nat × X) := fun a b => a.2 = b.2

/-- The relation holding at exactly one pair. -/
def atPair {α : Type u} (p q : α) : «际» α := fun a b => a = p ∧ b = q

/-! ## 2. Across one step

These read amounts across one step along the names. Read as 缘, kept and undermined run from the
condition to the formation, as WRT2 reads requiring under `«逆»`. -/

section AcrossSteps

variable {X : Type} (V : Web X X)

/-- An occurrence's need at its step is within the condition's level at the next step. -/
def metAfter : «际» (Nat × X) := fun x y => y.1 = x.1 + 1 ∧ V.need x.1 x.2 y.2 ≤ V.level y.1 y.2

/-- An occurrence's need at its step is above the condition's level at the next step. -/
def belowAfter : «际» (Nat × X) := fun x y => y.1 = x.1 + 1 ∧ V.level y.1 y.2 < V.need x.1 x.2 y.2

/-- A dependence kept across the step, from the condition to the formation: its need met at the step
and after it. -/
def keptAcross : «际» (Nat × X) := fun y z => needMet V z y ∧ metAfter V z (y.1 + 1, y.2)

/-- A dependence undermined across the step, from the condition to the formation: at one step, the
condition's level after the step is below the need, and the dependence was met above that level
while it held (`Web.MetAbove`, which reads the dependence at every step since it formed). -/
def undermined : «际» (Nat × X) := fun y z =>
  z.1 = y.1 ∧ V.MetAbove z.1 z.2 y.2 (V.level (y.1 + 1) y.2) ∧ V.level (y.1 + 1) y.2 < V.need z.1 z.2 y.2

/-- **A dependence kept across the step is the kept relation from the condition to the formation.** -/
theorem kept_iff (t : Nat) (g c : X) : V.Kept t g c ↔ keptAcross V (t, c) (t, g) :=
  ⟨fun ⟨now, after⟩ => ⟨⟨rfl, now⟩, rfl, after⟩, fun ⟨⟨_, now⟩, _, after⟩ => ⟨now, after⟩⟩

/-- **Renewal at a step is an inclusion**: the occurrence is active, and requiring, from the conditions
it takes part in, lies within the kept relation. -/
theorem renewingAt_iff (t : Nat) (f : X) :
    V.RenewingAt t f ↔ activeAt V (t, f) ∧
      «则» («而» (Web.partialIdentity (participating V (t, f))) («逆» (requiring V))) (keptAcross V) := by
  constructor
  · intro ⟨active, kept⟩
    refine ⟨active, ?_⟩
    intro y z ⟨w, ⟨same, at_t, part⟩, at_w, req⟩
    cases same
    obtain ⟨yt, c⟩ := y
    obtain ⟨zt, g⟩ := z
    have e₁ : t = yt := at_t
    have e₂ : zt = yt := at_w
    subst e₂
    subst e₁
    have k := kept c part g req
    exact ⟨⟨rfl, k.1⟩, rfl, k.2⟩
  · intro ⟨active, inside⟩
    refine ⟨active, fun c part g req => ?_⟩
    have k := inside (t, c) (t, g) ⟨(t, c), ⟨rfl, rfl, part⟩, rfl, req⟩
    exact ⟨k.1.2, k.2.2⟩

/-- **Renewal over a region of conditions is the same inclusion, its source met with the region.** -/
theorem renewingOver_iff (region : X → Prop) (t : Nat) (f : X) :
    V.RenewingOver region t f ↔ activeAt V (t, f) ∧
      «则» («而» (Web.partialIdentity fun y => participating V (t, f) y ∧ region y.2) («逆» (requiring V)))
        (keptAcross V) := by
  constructor
  · intro ⟨active, kept⟩
    refine ⟨active, ?_⟩
    intro y z ⟨w, ⟨same, ⟨at_t, part⟩, inside⟩, at_w, req⟩
    cases same
    obtain ⟨yt, c⟩ := y
    obtain ⟨zt, g⟩ := z
    have e₁ : t = yt := at_t
    have e₂ : zt = yt := at_w
    subst e₂
    subst e₁
    have k := kept c inside part g req
    exact ⟨⟨rfl, k.1⟩, rfl, k.2⟩
  · intro ⟨active, inside⟩
    refine ⟨active, fun c within part g req => ?_⟩
    have k := inside (t, c) (t, g) ⟨(t, c), ⟨rfl, ⟨rfl, part⟩, within⟩, rfl, req⟩
    exact ⟨k.1.2, k.2.2⟩

/-- **Renewal along the whole web is an inclusion**: requiring, from every occurrence of every
condition an occurrence of `f` takes part in, lies within the kept relation. -/
theorem renewingIn_iff (f : X) :
    V.RenewingIn f ↔
      «则» («而» (Web.partialIdentity fun y =>
          «能» («逆» («而» («而» (Web.partialIdentity fun a => a.2 = f) (participating V)) sameName)) y)
        («逆» (requiring V))) (keptAcross V) := by
  constructor
  · intro renews y z ⟨w, ⟨same, u, v, ⟨u', ⟨same_u, at_f⟩, at_v, part⟩, name⟩, at_w, req⟩
    cases same
    cases same_u
    obtain ⟨yt, yc⟩ := y
    obtain ⟨zt, zg⟩ := z
    obtain ⟨vt, vc⟩ := v
    obtain ⟨ut, uf⟩ := u
    have e_f : uf = f := at_f
    have e_v : ut = vt := at_v
    have e_n : vc = yc := name
    have e_w : zt = yt := at_w
    subst e_f
    subst e_v
    subst e_n
    subst e_w
    have k := renews _ _ part _ _ req
    exact ⟨⟨rfl, k.1⟩, rfl, k.2⟩
  · intro inside t c part t' g req
    have k := inside (t', c) (t', g)
      ⟨(t', c), ⟨rfl, (t, f), (t, c), ⟨(t, f), ⟨rfl, rfl⟩, rfl, part⟩, rfl⟩, rfl, req⟩
    exact ⟨k.1.2, k.2.2⟩

/-- **Undermining is drawing on a condition from which a dependence is undermined across the step**:
«能» at the composite of drawing with requiring met with the undermined relation. -/
theorem underminingAt_iff (t : Nat) (f : X) :
    V.UnderminingAt t f ↔ «能» («而» (drawing V) («合» («逆» (requiring V)) (undermined V))) (t, f) := by
  constructor
  · intro ⟨c, draws, g, req, above, below⟩
    exact ⟨(t, g), (t, c), ⟨rfl, draws⟩, ⟨rfl, req⟩, rfl, above, below⟩
  · intro ⟨z, y, ⟨at_t, draws⟩, ⟨at_y, req⟩, _, above, below⟩
    obtain ⟨yt, c⟩ := y
    obtain ⟨zt, g⟩ := z
    have e₁ : t = yt := at_t
    have e₂ : zt = yt := at_y
    subst e₂
    subst e₁
    exact ⟨c, draws, g, req, above, below⟩

/-- **A living event at the occurrence model**: active, with no such drawing. -/
theorem living_iff (t : Nat) (x : X) :
    (V.active t x ∧ ¬ V.UnderminingAt t x) ↔
      activeAt V (t, x) ∧ ¬ «能» («而» (drawing V) («合» («逆» (requiring V)) (undermined V))) (t, x) :=
  ⟨fun ⟨active, sound⟩ => ⟨active, fun under => sound ((underminingAt_iff V t x).mpr under)⟩,
   fun ⟨active, sound⟩ => ⟨active, fun under => sound ((underminingAt_iff V t x).mp under)⟩⟩

/-- The occurrences requiring `c` at their step. -/
def requiringOf (c : X) (u : Nat × X) : Prop :=
  «能» («而» (requiring V) (Web.partialIdentity fun w => w.2 = c)) u

/-- The need of one occurrence for `c` is within `δ` of another's: two given needs compared with a
supplied amount added. -/
def needWithin (δ : Nat) (c : X) : «际» (Nat × X) := fun y z => V.need y.1 y.2 c ≤ V.need z.1 z.2 c + δ

/-- **Inheritance at a descent is an inclusion**: what the descendant at `t + 1` requires of `c`, read
from the giver at `t` and carried back one step along the names, the giver requires. -/
theorem inheritsAt_iff (t : Nat) (x g c : X) :
    V.InheritsAt t x g c ↔
      «则» («而» («而» («逆» (atPair (t + 1, x) (t, g)))
          («而» (requiring V) (Web.partialIdentity fun w => w.2 = c))) («逆» Steps.along)) (requiring V) := by
  constructor
  · intro inherits v z ⟨w', ⟨u, ⟨at_u, at_v⟩, w, ⟨same_t, req⟩, same, at_c⟩, next, name⟩
    subst at_u
    subst at_v
    subst same
    obtain ⟨wt, wc⟩ := w
    obtain ⟨zt, zc⟩ := z
    have e : zt = t := Nat.succ.inj ((next.symm.trans same_t.symm : zt + 1 = t + 1))
    have hc : zc = c := name.symm.trans at_c
    exact ⟨e.symm, hc ▸ inherits (at_c ▸ req)⟩
  · intro inside h
    exact (inside (t, g) (t, c)
      ⟨(t + 1, c), ⟨(t + 1, x), ⟨rfl, rfl⟩, (t + 1, c), ⟨rfl, h⟩, rfl, rfl⟩, rfl, rfl⟩).2

/-- **The need within `δ` at a descent is an inclusion**: the descent's pair, where both require `c`,
lies within the need-within relation. -/
theorem needsWithinAt_iff (t : Nat) (x g c : X) (δ : Nat) :
    V.NeedsWithinAt t x g c δ ↔
      «则» («合» (atPair (t + 1, x) (t, g)) fun u v => requiringOf V c u ∧ requiringOf V c v)
        (needWithin V δ c) := by
  constructor
  · intro within u v ⟨⟨at_u, at_v⟩, ⟨_, m, ⟨_, ru⟩, _, mc⟩, ⟨_, m', ⟨_, rv⟩, _, mc'⟩⟩
    subst at_u
    subst at_v
    exact within (mc ▸ ru) (mc' ▸ rv)
  · intro inside hx hg
    exact inside (t + 1, x) (t, g)
      ⟨⟨rfl, rfl⟩, ⟨(t + 1, c), (t + 1, c), ⟨rfl, hx⟩, rfl, rfl⟩, ⟨(t, c), (t, c), ⟨rfl, hg⟩, rfl, rfl⟩⟩

/-- **The row `Web.transmits_at_iff` for a web of one kind**: transmission at a descent is the two
inclusions. -/
theorem transmits_at_one_kind (t : Nat) (x g c : X) (δ : Nat) :
    (V.requires (t + 1) x c → V.requires t g c ∧ V.need (t + 1) x c ≤ V.need t g c + δ) ↔
      «则» («而» («而» («逆» (atPair (t + 1, x) (t, g)))
          («而» (requiring V) (Web.partialIdentity fun w => w.2 = c))) («逆» Steps.along)) (requiring V) ∧
        «则» («合» (atPair (t + 1, x) (t, g)) fun u v => requiringOf V c u ∧ requiringOf V c v)
          (needWithin V δ c) :=
  V.transmits_at_iff.trans
    ⟨fun ⟨i, n⟩ => ⟨(inheritsAt_iff V t x g c).mp i, (needsWithinAt_iff V t x g c δ).mp n⟩,
     fun ⟨i, n⟩ => ⟨(inheritsAt_iff V t x g c).mpr i, (needsWithinAt_iff V t x g c δ).mpr n⟩⟩

end AcrossSteps

/-! ## 3. Two kinds, through the one-kind reading -/

/-- A region of conditions on the one kind of relatum: it holds exactly the conditions in it. -/
def onConditions {F C : Type} (region : C → Prop) : F ⊕ C → Prop
  | .inl _ => False
  | .inr c => region c

/-- **The one-kind reading keeps renewal at a step.** -/
theorem roles_renewingAt {F C : Type} (W : Web F C) (t : Nat) (f : F) :
    W.roles.RenewingAt t (.inl f) ↔ W.RenewingAt t f := by
  constructor
  · intro ⟨active, kept⟩
    exact ⟨active, fun c part g req => kept (.inr c) part (.inl g) req⟩
  · intro ⟨active, kept⟩
    refine ⟨active, fun y part z req => ?_⟩
    cases y with
    | inl _ => exact False.elim (Or.elim part (fun h => h) (fun h => h))
    | inr c =>
      cases z with
      | inl g => exact kept c part g req
      | inr _ => exact False.elim req

/-- **The one-kind reading keeps renewal over a region.** -/
theorem roles_renewingOver {F C : Type} (W : Web F C) (region : C → Prop) (t : Nat) (f : F) :
    W.roles.RenewingOver (onConditions region) t (.inl f) ↔ W.RenewingOver region t f := by
  constructor
  · intro ⟨active, kept⟩
    exact ⟨active, fun c inside part g req => kept (.inr c) inside part (.inl g) req⟩
  · intro ⟨active, kept⟩
    refine ⟨active, fun y inside part z req => ?_⟩
    cases y with
    | inl _ => exact False.elim inside
    | inr c =>
      cases z with
      | inl g => exact kept c inside part g req
      | inr _ => exact False.elim req

/-- **The row `Web.roles_supported`**: a two-kind web's support is the grammar statement at the
occurrence model of its one-kind reading. -/
theorem roles_supported_reading {F C : Type} (W : Web F C) (t : Nat) (f : F) :
    W.Supported t f ↔
      «则» («而» (Web.partialIdentity (· = (t, .inl f))) (requiring W.roles)) (needMet W.roles) :=
  (W.roles_supported t f).symm.trans (supported_iff W.roles t (.inl f))

/-- **The row `Web.roles_dependent`.** -/
theorem roles_dependent_reading {F C : Type} (W : Web F C) :
    W.Dependent ↔ «则» («而» (Web.partialIdentity (activeAt W.roles)) (requiring W.roles)) (needMet W.roles) :=
  W.roles_dependent.symm.trans (dependent_iff W.roles)

/-- **The row `Web.roles_alive`.** -/
theorem roles_alive_reading {F C : Type} (W : Web F C) (t : Nat) (f : F) :
    (W.active t f ∧ ¬ W.UnderminingAt t f) ↔ activeAt W.roles (t, .inl f) ∧
      ¬ «能» («而» (drawing W.roles) («合» («逆» (requiring W.roles)) (undermined W.roles))) (t, .inl f) :=
  (W.roles_alive t f).symm.trans (living_iff W.roles t (.inl f))

/-- Renewal at a step of a two-kind web, at the occurrence model of its one-kind reading. -/
theorem renewingAt_reading {F C : Type} (W : Web F C) (t : Nat) (f : F) :
    W.RenewingAt t f ↔ activeAt W.roles (t, .inl f) ∧
      «则» («而» (Web.partialIdentity (participating W.roles (t, .inl f))) («逆» (requiring W.roles)))
        (keptAcross W.roles) :=
  (roles_renewingAt W t f).symm.trans (renewingAt_iff W.roles t (.inl f))

/-- Renewal over a region of conditions of a two-kind web, at the same model. -/
theorem renewingOver_reading {F C : Type} (W : Web F C) (region : C → Prop) (t : Nat) (f : F) :
    W.RenewingOver region t f ↔ activeAt W.roles (t, .inl f) ∧
      «则» («而» (Web.partialIdentity fun y => participating W.roles (t, .inl f) y ∧ onConditions region y.2)
        («逆» (requiring W.roles))) (keptAcross W.roles) :=
  (roles_renewingOver W region t f).symm.trans (renewingOver_iff W.roles (onConditions region) t (.inl f))

/-- **The row `Web.renewingAt_iff_over_all` at the occurrence model**: the two inclusions, the second's
source met with the region of every condition, are one. -/
theorem renewingAt_iff_over_all_reading {F C : Type} (W : Web F C) (t : Nat) (f : F) :
    (activeAt W.roles (t, .inl f) ∧
      «则» («而» (Web.partialIdentity (participating W.roles (t, .inl f))) («逆» (requiring W.roles)))
        (keptAcross W.roles)) ↔
    (activeAt W.roles (t, .inl f) ∧
      «则» («而» (Web.partialIdentity fun y =>
          participating W.roles (t, .inl f) y ∧ onConditions (fun _ => True) y.2) («逆» (requiring W.roles)))
        (keptAcross W.roles)) :=
  (renewingAt_reading W t f).symm.trans (W.renewingAt_iff_over_all.trans (renewingOver_reading W _ t f))

/-- **The row `Web.transmits_at_iff`**: a two-kind web's transmission at a descent is its one-kind
reading's two inclusions. -/
theorem transmits_at_reading {F C : Type} (W : Web F C) (t : Nat) (x g : F) (c : C) (δ : Nat) :
    (W.requires (t + 1) x c → W.requires t g c ∧ W.need (t + 1) x c ≤ W.need t g c + δ) ↔
      «则» («而» («而» («逆» (atPair (t + 1, .inl x) (t, .inl g)))
            («而» (requiring W.roles) (Web.partialIdentity fun w => w.2 = .inr c))) («逆» Steps.along))
          (requiring W.roles) ∧
        «则» («合» (atPair (t + 1, .inl x) (t, .inl g)) fun u v =>
            requiringOf W.roles (.inr c) u ∧ requiringOf W.roles (.inr c) v)
          (needWithin W.roles δ (.inr c)) :=
  transmits_at_one_kind W.roles t (.inl x) (.inl g) (.inr c) δ

/-! ## 4. Claims: regions of significance and relational neutrality

A region of claims is held as its partial identity (`Web.partialIdentity`), as WRT2 holds activity. -/

/-- Inclusion of partial identities is inclusion of the regions. -/
theorem partialIdentity_le_iff {α : Type} {P Q : α → Prop} :
    «则» (Web.partialIdentity P) (Web.partialIdentity Q) ↔ ∀ x, P x → Q x :=
  ⟨fun inside x held => (inside x x ⟨rfl, held⟩).2,
   fun inside _ _ ⟨same, held⟩ => ⟨same, inside _ held⟩⟩

section Valuations

variable {Pos C : Type} (V : Valuation Pos C)

/-- Living significance: living lies within significance from every position. -/
theorem significant_iff_reading :
    V.Significant ↔ ∀ p, «则» (Web.partialIdentity V.living) (Web.partialIdentity (V.sig p)) :=
  ⟨fun all p => partialIdentity_le_iff.mpr fun c alive => all p c alive,
   fun inside p c alive => partialIdentity_le_iff.mp (inside p) c alive⟩

/-- S0 at a position: its own living lies within its significance. -/
theorem selfSignificance_iff_reading (p : Pos) :
    V.SelfSignificance p ↔ «则» («合» (Web.partialIdentity (V.own p)) (Web.partialIdentity V.living))
      (Web.partialIdentity (V.sig p)) :=
  ⟨fun self _ _ ⟨⟨same, own⟩, _, alive⟩ => ⟨same, self _ own alive⟩,
   fun inside c own alive => (inside c c ⟨⟨rfl, own⟩, rfl, alive⟩).2⟩

/-- N_std: what is living and significant from one position lies within significance from every
other. -/
theorem shares_iff_reading :
    Neutral V.shares ↔ ∀ p q, «则» («合» (Web.partialIdentity V.living) (Web.partialIdentity (V.sig p)))
      (Web.partialIdentity (V.sig q)) :=
  ⟨fun neutral p q x _ ⟨⟨same, alive⟩, _, held⟩ => ⟨same, neutral (p, q, x) alive held⟩,
   fun inside ⟨p, q, c⟩ alive held => (inside p q c c ⟨⟨rfl, alive⟩, rfl, held⟩).2⟩

/-- Held lives: living lies within the positions' own regions together. -/
theorem held_iff_reading :
    V.Held ↔ «则» (Web.partialIdentity V.living) (Web.partialIdentity fun c => ∃ p, V.own p c) :=
  ⟨fun held => partialIdentity_le_iff.mpr held, fun inside => partialIdentity_le_iff.mp inside⟩

/-- **The row `Valuation.significant_iff_held` on the grammar.** -/
theorem significant_iff_held_reading
    (held : «则» (Web.partialIdentity V.living) (Web.partialIdentity fun c => ∃ p, V.own p c)) :
    (∀ p, «则» (Web.partialIdentity V.living) (Web.partialIdentity (V.sig p))) ↔
      (∀ p, «则» («合» (Web.partialIdentity (V.own p)) (Web.partialIdentity V.living))
          (Web.partialIdentity (V.sig p))) ∧
        ∀ p q, «则» («合» (Web.partialIdentity V.living) (Web.partialIdentity (V.sig p)))
          (Web.partialIdentity (V.sig q)) :=
  (significant_iff_reading V).symm.trans
    ((Valuation.significant_iff_held ((held_iff_reading V).mpr held)).trans
      ⟨fun ⟨self, share⟩ => ⟨fun p => (selfSignificance_iff_reading V p).mp (self p),
          (shares_iff_reading V).mp share⟩,
       fun ⟨self, share⟩ => ⟨fun p => (selfSignificance_iff_reading V p).mpr (self p),
          (shares_iff_reading V).mpr share⟩⟩)

/-- **Relational neutrality (N_rel) is significance from each position closed under the formed relation
into living content**, read from `Valuation.transmits_iff_closed` (`ClosedUnder` is `«闭»`). -/
theorem neutral_transmits_iff :
    Neutral V.transmits ↔ ∀ p, «闭» («合» V.related fun _ d => V.living d) (V.sig p) :=
  (Valuation.transmits_iff_closed (V := V)).trans
    ⟨fun closed p c d held ⟨related, alive⟩ => closed p c d held ⟨(), related, alive⟩,
     fun closed p c d held ⟨_, related, alive⟩ => closed p c d held ⟨related, alive⟩⟩

end Valuations

/-! ## 5. Living on, interacting and descent, at the occurrence model

The claims of a valuation on a web's events are its occurrences with the coordinates swapped,
`(x, t)` for `(t, x)`; each relation below is read on the occurrences. -/

section Sustenance

variable {X : Type} (V : Web X X)

/-- An occurrence lives on a relatum's occurrence, at any step of the relatum: at its step it draws on
the relatum and requires it at a positive need. -/
def livesOn : «际» (Nat × X) := «而» («合» (drawing V) (bearing V)) sameName

/-- Two occurrences interact through a condition, at any steps: one draws on it and the other requires
it at a positive need. -/
def interacts : «际» (Nat × X) := fun a b =>
  «而» («而» (drawing V) sameName) («逆» (bearing V)) a b ∨
    «而» («而» (bearing V) sameName) («逆» (drawing V)) a b

/-- The relation the sustenance valuation forms, at the occurrence model. -/
def sustenanceRel : «际» (Nat × X) := fun a b => interacts V a b ∨ livesOn V a b ∨ livesOn V b a

/-- The living occurrences: active, with no drawing on a condition from which a dependence is
undermined across the step. -/
def livingOcc (a : Nat × X) : Prop :=
  activeAt V a ∧ ¬ «能» («而» (drawing V) («合» («逆» (requiring V)) (undermined V))) a

theorem livesOn_iff (a b : Nat × X) : V.LivesOn (a.2, a.1) (b.2, b.1) ↔ livesOn V a b := by
  constructor
  · intro ⟨draws, bears⟩
    exact ⟨(a.1, b.2), ⟨⟨rfl, draws⟩, rfl, bears⟩, rfl⟩
  · intro ⟨w, ⟨⟨at₁, draws⟩, _, bears⟩, name⟩
    obtain ⟨wt, wy⟩ := w
    have e₁ : a.1 = wt := at₁
    have e₂ : wy = b.2 := name
    subst e₁
    subst e₂
    exact ⟨draws, bears⟩

theorem interacts_iff (a b : Nat × X) :
    (∃ c, V.Interacts c (a.2, a.1) (b.2, b.1)) ↔ interacts V a b := by
  constructor
  · intro ⟨c, h⟩
    cases h with
    | inl h => exact .inl ⟨(b.1, c), ⟨(a.1, c), ⟨rfl, h.1⟩, rfl⟩, ⟨rfl, h.2⟩⟩
    | inr h => exact .inr ⟨(b.1, c), ⟨(a.1, c), ⟨rfl, h.1⟩, rfl⟩, ⟨rfl, h.2⟩⟩
  · intro h
    cases h with
    | inl h =>
      obtain ⟨w₂, ⟨w₁, ⟨_, draws⟩, name⟩, _, bears⟩ := h
      obtain ⟨w₁t, w₁c⟩ := w₁
      obtain ⟨w₂t, w₂c⟩ := w₂
      have e : w₁c = w₂c := name
      subst e
      exact ⟨w₁c, .inl ⟨draws, bears⟩⟩
    | inr h =>
      obtain ⟨w₂, ⟨w₁, ⟨_, bears⟩, name⟩, _, draws⟩ := h
      obtain ⟨w₁t, w₁c⟩ := w₁
      obtain ⟨w₂t, w₂c⟩ := w₂
      have e : w₁c = w₂c := name
      subst e
      exact ⟨w₁c, .inr ⟨bears, draws⟩⟩

theorem sustenance_related_iff {Pos : Type} (own sig : Pos → X × Nat → Prop) (a b : Nat × X) :
    (V.sustenance own sig).related (a.2, a.1) (b.2, b.1) ↔ sustenanceRel V a b :=
  ⟨fun h => match h with
    | .inl inter => .inl ((interacts_iff V a b).mp inter)
    | .inr (.inl lives) => .inr (.inl ((livesOn_iff V a b).mp lives))
    | .inr (.inr lives) => .inr (.inr ((livesOn_iff V b a).mp lives)),
   fun h => match h with
    | .inl inter => .inl ((interacts_iff V a b).mpr inter)
    | .inr (.inl lives) => .inr (.inl ((livesOn_iff V a b).mpr lives))
    | .inr (.inr lives) => .inr (.inr ((livesOn_iff V b a).mpr lives))⟩

/-- **N_rel for the sustenance valuation, at the occurrence model.** -/
theorem sustenance_neutral_iff {Pos : Type} (own sig : Pos → X × Nat → Prop) :
    Neutral (V.sustenance own sig).transmits ↔
      ∀ p, «闭» («合» (sustenanceRel V) fun _ b => livingOcc V b) (fun a => sig p (a.2, a.1)) :=
  (neutral_transmits_iff _).trans
    ⟨fun closed p a b held ⟨rel, alive⟩ => closed p (a.2, a.1) (b.2, b.1) held
        ⟨(sustenance_related_iff V own sig a b).mpr rel, (living_iff V b.1 b.2).mpr alive⟩,
     fun closed p e d held ⟨rel, alive⟩ => closed p (e.2, e.1) (d.2, d.1) held
        ⟨(sustenance_related_iff V own sig (e.2, e.1) (d.2, d.1)).mp rel, (living_iff V d.2 d.1).mp alive⟩⟩

end Sustenance

/-- **The row `Web.living_on_reaches` at the occurrence model**: one step of N_rel's closure, along
living on. -/
theorem living_on_reaches_reading {X Pos : Type} {W : Web X X} {own sig : Pos → X × Nat → Prop}
    (closed : ∀ p, «闭» («合» (sustenanceRel W) fun _ b => livingOcc W b) (fun a => sig p (a.2, a.1)))
    {p : Pos} {a b : Nat × X} (lives : livesOn W a b) (held : sig p (a.2, a.1)) (alive : livingOcc W b) :
    sig p (b.2, b.1) :=
  Web.living_on_reaches ((sustenance_neutral_iff W own sig).mpr closed) ((livesOn_iff W a b).mpr lives) held
    ((living_iff W b.1 b.2).mpr alive)

section DescentModel

variable {X : Type} (L : Flow X X) (V : Web X X)

/-- The occurrences present at their step (WRT2's presence). -/
def presentAt (o : Nat × X) : Prop := o.2 ∈ L.present o.1

/-- What an occurrence gives to, within its step (WRT2's giving, read by sign). -/
def giving : «际» (Nat × X) := World.withinStep fun t g x => 0 < L.give t g x

/-- The occurrences standing at their step (WRT2's standing). -/
def standing (o : Nat × X) : Prop := 0 < V.level o.1 o.2

/-- Coming to stand across a step along the names: not standing, then standing. -/
def comesToStand : «际» (Nat × X) := «合» Steps.along fun a b => ¬ standing V a ∧ standing V b

/-- One descent within a step, from the giver's occurrence to the receiver's: the giver present and
giving to it, the receiver coming to stand across the step. -/
def descentStep : «际» (Nat × X) :=
  «合» («而» (Web.partialIdentity (presentAt L)) (giving L)) fun _ b => «能» (comesToStand V) b

/-- Descent between relata, read on their occurrences at any steps. -/
def descendsRel : «际» (Nat × X) := «而» («而» sameName (descentStep L V)) sameName

/-- The relation the descent valuation forms, at the occurrence model. -/
def descentRel : «际» (Nat × X) := fun a b => interacts V a b ∨ descendsRel L V a b ∨ descendsRel L V b a

theorem descends_iff (x g : X) (t s : Nat) : L.Descends V x g ↔ descendsRel L V (t, g) (s, x) := by
  constructor
  · intro ⟨u, present, gives, notStand, stand⟩
    exact ⟨(u, x), ⟨(u, g), rfl, ⟨(u, g), ⟨rfl, present⟩, rfl, gives⟩, (u + 1, x), ⟨rfl, rfl⟩, notStand, stand⟩,
      rfl⟩
  · intro ⟨w₂, ⟨w₁, name₁, ⟨w, ⟨same, present⟩, at_w, gives⟩, b', ⟨next, name'⟩, notStand, stand⟩, name₂⟩
    obtain ⟨w₂t, w₂x⟩ := w₂
    obtain ⟨w₁t, w₁g⟩ := w₁
    obtain ⟨b't, b'x⟩ := b'
    subst same
    have e₁ : g = w₁g := name₁
    have e₂ : w₁t = w₂t := at_w
    have e₃ : w₂x = x := name₂
    have e₄ : b't = w₂t + 1 := next
    have e₅ : b'x = w₂x := name'
    subst e₁
    subst e₂
    subst e₃
    subst e₄
    subst e₅
    exact ⟨_, present, gives, notStand, stand⟩

theorem descent_related_iff {Pos : Type} (own sig : Pos → X × Nat → Prop) (a b : Nat × X) :
    (L.descent V own sig).related (a.2, a.1) (b.2, b.1) ↔ descentRel L V a b :=
  ⟨fun h => match h with
    | .inl inter => .inl ((interacts_iff V a b).mp inter)
    | .inr (.inl d) => .inr (.inl ((descends_iff L V b.2 a.2 a.1 b.1).mp d))
    | .inr (.inr d) => .inr (.inr ((descends_iff L V a.2 b.2 b.1 a.1).mp d)),
   fun h => match h with
    | .inl inter => .inl ((interacts_iff V a b).mpr inter)
    | .inr (.inl d) => .inr (.inl ((descends_iff L V b.2 a.2 a.1 b.1).mpr d))
    | .inr (.inr d) => .inr (.inr ((descends_iff L V a.2 b.2 b.1 a.1).mpr d))⟩

/-- **N_rel for the descent valuation, at the occurrence model.** -/
theorem descent_neutral_iff {Pos : Type} (own sig : Pos → X × Nat → Prop) :
    Neutral (L.descent V own sig).transmits ↔
      ∀ p, «闭» («合» (descentRel L V) fun _ b => livingOcc V b) (fun a => sig p (a.2, a.1)) :=
  (neutral_transmits_iff _).trans
    ⟨fun closed p a b held ⟨rel, alive⟩ => closed p (a.2, a.1) (b.2, b.1) held
        ⟨(descent_related_iff L V own sig a b).mpr rel, (living_iff V b.1 b.2).mpr alive⟩,
     fun closed p e d held ⟨rel, alive⟩ => closed p (e.2, e.1) (d.2, d.1) held
        ⟨(descent_related_iff L V own sig (e.2, e.1) (d.2, d.1)).mp rel, (living_iff V d.2 d.1).mp alive⟩⟩

end DescentModel

/-- **The row `Flow.descent_reaches` at the occurrence model**: one step of N_rel's closure, along
descent. -/
theorem descent_reaches_reading {X Pos : Type} {L : Flow X X} {W : Web X X} {own sig : Pos → X × Nat → Prop}
    (closed : ∀ p, «闭» («合» (descentRel L W) fun _ b => livingOcc W b) (fun a => sig p (a.2, a.1)))
    {p : Pos} {a b : Nat × X} (descends : descendsRel L W a b) (held : sig p (a.2, a.1))
    (alive : livingOcc W b) : sig p (b.2, b.1) :=
  Flow.descent_reaches ((descent_neutral_iff L W own sig).mpr closed)
    ((descends_iff L W b.2 a.2 a.1 b.1).mpr descends) held ((living_iff W b.1 b.2).mpr alive)

/-! ## 6. What the paths admit -/

section Retaining

variable {F C Pos : Type} (W : Web F C)

/-- What has significance from `p`, as a partial identity on (step, formation) pairs, the carrier on
which `Web.admitted` reads admission. -/
def significantAt (sig : Pos → Nat → F → Prop) (p : Pos) : «际» (Nat × F) :=
  Web.partialIdentity fun x => sig p x.1 x.2

/-- **Retaining is an inclusion**: what `l'` admits with significance lies within what `l` admits. -/
theorem retains_iff (sig : Pos → Nat → F → Prop) (p : Pos) (l l' : Nat → C → Nat) :
    W.Retains sig p l l' ↔ «则» («合» (significantAt sig p) (W.admitted l')) (W.admitted l) :=
  ⟨fun retains _ _ ⟨⟨same, significant⟩, _, admits⟩ => ⟨same, retains _ _ significant admits⟩,
   fun inside t f significant admits => (inside (t, f) (t, f) ⟨⟨rfl, significant⟩, rfl, admits⟩).2⟩

/-- **Adding is exceeding** (`«逾»`): what `l` admits with significance exceeds what `l'` admits. -/
theorem adds_iff (sig : Pos → Nat → F → Prop) (p : Pos) (l l' : Nat → C → Nat) :
    W.Adds sig p l l' ↔ «逾» («合» (significantAt sig p) (W.admitted l)) (W.admitted l') :=
  ⟨fun ⟨t, f, significant, admits, not⟩ =>
     ⟨(t, f), (t, f), ⟨⟨rfl, significant⟩, rfl, admits⟩, fun ⟨_, admitted⟩ => not admitted⟩,
   fun ⟨x, _, ⟨⟨same, significant⟩, _, admits⟩, not⟩ =>
     ⟨x.1, x.2, significant, admits, fun admitted => not ⟨same, admitted⟩⟩⟩

/-- The living claims of a web of two kinds, read at the occurrence model of its one-kind reading. -/
def livingClaim (e : F × Nat) : Prop :=
  activeAt W.roles (e.2, .inl e.1) ∧
    ¬ «能» («而» (drawing W.roles) («合» («逆» (requiring W.roles)) (undermined W.roles))) (e.2, .inl e.1)

/-- Living significance of a web's valuation, with the living claims read at the occurrence model. -/
theorem significant_iff_livingClaim (own sig : Pos → F × Nat → Prop) :
    (W.valuation own sig).Significant ↔
      ∀ q, «则» (Web.partialIdentity (livingClaim W)) (Web.partialIdentity (sig q)) :=
  (significant_iff_reading _).trans
    ⟨fun inside q => partialIdentity_le_iff.mpr fun e alive =>
        partialIdentity_le_iff.mp (inside q) e ((roles_alive_reading W e.2 e.1).mpr alive),
     fun inside q => partialIdentity_le_iff.mpr fun e alive =>
        partialIdentity_le_iff.mp (inside q) e ((roles_alive_reading W e.2 e.1).mp alive)⟩

/-- **The row `Web.significance_undetermined` on the grammar**: with the empty region of significance,
what one path admits with it lies within what every other admits and exceeds nothing; with the full
region living lies within significance, and with the empty region it does not, where a claim lives. -/
theorem significance_undetermined_reading (own : Pos → F × Nat → Prop) (p : Pos) {e : F × Nat}
    (alive : livingClaim W e) :
    (∀ l l' : Nat → C → Nat,
        «则» («合» (significantAt (fun _ _ _ => False) p) (W.admitted l')) (W.admitted l) ∧
        ¬ «逾» («合» (significantAt (fun _ _ _ => False) p) (W.admitted l)) (W.admitted l')) ∧
      «则» (Web.partialIdentity (livingClaim W)) (Web.partialIdentity fun _ => True) ∧
      ¬ «则» (Web.partialIdentity (livingClaim W)) (Web.partialIdentity fun _ => False) :=
  match W.significance_undetermined own p ((roles_alive_reading W e.2 e.1).mpr alive) with
  | ⟨paths, full, empty⟩ =>
    ⟨fun l l' => ⟨(retains_iff W _ p l l').mp (paths l l').1,
        fun adds => (paths l l').2 ((adds_iff W _ p l l').mpr adds)⟩,
     (significant_iff_livingClaim W own fun _ _ => True).mp full p,
     fun inside => empty ((significant_iff_livingClaim W own fun _ _ => False).mpr fun _ => inside)⟩

end Retaining

/-! ## 7. The step index, and runs as lines -/

/-- **Lying within the closure of the steps on `Nat` is coming no earlier.** -/
theorem withinSteps_iff_le (n k : Nat) : «所闭» Steps.next n k ↔ n ≤ k :=
  ⟨fun within => within (fun m => n ≤ m) (fun _ _ le step => Eq.subst (motive := fun b => n ≤ b) step.symm
      (Nat.le_succ_of_le le)) (Nat.le_refl n),
   fun le => match le_dest le with
    | ⟨d, same⟩ => Eq.subst (motive := fun b => «所闭» Steps.next n b) same.symm
        (Nat.rec (motive := fun d => «所闭» Steps.next n (n + d)) («所闭之自反» Steps.next n)
          (fun _ ih => «所闭之传递» ih («缘在所闭» rfl)) d)⟩

/-- **Reaching along the steps on `Nat` is coming later.** -/
theorem before_iff_lt (n k : Nat) : «及» Steps.next n k ↔ n < k := by
  constructor
  · intro h
    induction h with
    | one step => exact step ▸ Nat.lt_succ_self _
    | more step _ ih => exact Nat.lt_trans (step ▸ Nat.lt_succ_self _) ih
  · intro lt
    obtain ⟨d, same⟩ := le_dest (show n + 1 ≤ k from lt)
    have reach : ∀ d, «及» Steps.next n (n + 1 + d) := fun d =>
      Nat.rec (motive := fun d => «及» Steps.next n (n + 1 + d)) (.one rfl)
        (fun _ ih => «及之传递» ih (.one rfl)) d
    exact Eq.subst (motive := fun b => «及» Steps.next n b) same.symm (reach d)

/-- **A guess tracks a target where, on each run, the closure of the steps from some horizon lies
within agreeing with it.** -/
theorem tracks_iff {S : Type u} {A : Type v} {P : Process S A} {V : Type w} {g : Nat → Run P → V}
    {h : Nat → Run P → V} :
    Limit.Tracks g h ↔ ∀ r, ∃ n, ∀ k, «所闭» Steps.next n k → g k r = h k r :=
  ⟨fun tracks r => match tracks r with
    | ⟨n, from_n⟩ => ⟨n, fun k within => from_n k ((withinSteps_iff_le n k).mp within)⟩,
   fun tracks r => match tracks r with
    | ⟨n, from_n⟩ => ⟨n, fun k le => from_n k ((withinSteps_iff_le n k).mpr le)⟩⟩

/-- **The row `Limit.identifies_iff_tracks` on the grammar**: identifying a hypothesis is, on each run,
the closure of the steps from some horizon lying within agreement with the constant target. -/
theorem identifies_iff_reading {S : Type u} {A : Type v} {P : Process S A} {V : Type w}
    {g : Nat → Run P → V} {H : Run P → V} :
    Limit.Identifies g H ↔ ∀ r, ∃ n, ∀ k, «所闭» Steps.next n k → g k r = H r :=
  Limit.identifies_iff_tracks.trans tracks_iff

/-- **Two runs agreeing up to `h`**: the same configurations within the closure of the steps up to
`h`, the same moves at the steps before it. -/
theorem agreeUpTo_iff {S : Type u} {A : Type v} {P : Process S A} (h : Nat) (r r' : Run P) :
    r.AgreeUpTo h r' ↔ (∀ n, «所闭» Steps.next n h → r.state n = r'.state n) ∧
      ∀ n, «及» Steps.next n h → r.act n = r'.act n :=
  ⟨fun ⟨states, acts⟩ => ⟨fun n within => states n ((withinSteps_iff_le n h).mp within),
      fun n before => acts n ((before_iff_lt n h).mp before)⟩,
   fun ⟨states, acts⟩ => ⟨fun n le => states n ((withinSteps_iff_le n h).mpr le),
      fun n lt => acts n ((before_iff_lt n h).mpr lt)⟩⟩

/-! ## 8. A process's model of its moves' relations -/

/-- **A kernel is the closure of the steps from a configuration lying within the guard.** -/
theorem kernel_iff {S : Type u} {A : Type v} {P : Process S A} {g : S → Prop} {s : S} :
    Viability.Kernel P g s ↔ ∀ t, «所闭» (Steps P) s t → g t :=
  ⟨fun kept t within => kept t (reach_iff_withinClosure.mpr within),
   fun kept t reach => kept t (reach_iff_withinClosure.mp reach)⟩

/-- **The row `Viability.kernel_and_iff` on the grammar**: the closure lies within a meet of two
regions exactly where it lies within each; a law of logic, for any relation. -/
theorem kernel_and_reading {S : Type u} {A : Type v} {P : Process S A} {g₁ g₂ : S → Prop} {s : S} :
    (∀ t, «所闭» (Steps P) s t → g₁ t ∧ g₂ t) ↔
      (∀ t, «所闭» (Steps P) s t → g₁ t) ∧ ∀ t, «所闭» (Steps P) s t → g₂ t :=
  kernel_iff.symm.trans (Viability.kernel_and_iff.trans ⟨fun ⟨k₁, k₂⟩ => ⟨kernel_iff.mp k₁, kernel_iff.mp k₂⟩,
    fun ⟨k₁, k₂⟩ => ⟨kernel_iff.mpr k₁, kernel_iff.mpr k₂⟩⟩)

section Joint

variable {S : Type u} {A : Type v} {F C : Type} (K : Dependence S F C)

/-- Withholding `f`'s part, as a relation on configurations: to the configuration the withholding
leaves. -/
def withholding (withhold : F → S → S) (f : F) : «际» S := fun s t => t = withhold f s

/-- **Withholding a list of parts one after another is passing through their withholdings in turn**
(`«历»`). -/
theorem withholdAll_iff_li (withhold : F → S → S) : ∀ (fs : List F) (s t : S),
    «历» (withholding withhold) fs s t ↔ t = withholdAll withhold fs s
  | [], _, _ => ⟨Eq.symm, Eq.symm⟩
  | f :: fs, s, t =>
    ⟨fun ⟨_, same, rest⟩ => ((withholdAll_iff_li withhold fs _ t).mp rest).trans
        (congrArg (withholdAll withhold fs) same),
     fun h => ⟨withhold f s, rfl, (withholdAll_iff_li withhold fs (withhold f s) t).mpr h⟩⟩

/-- The configurations at which `g` requires `c`. -/
def requiresAt (g : F) (c : C) (s : S) : Prop := K.requires s g c

/-- The configurations at which `g`'s need for `c` is within `c`'s level: two given amounts compared. -/
def needMetAt (g : F) (c : C) (s : S) : Prop := K.need s g c ≤ K.level s c

/-- The change from `s` to `t` breaks `g`'s dependence on `c`: required and met at `s`, with `c`'s level
at `t` below the need. -/
def breaking (g : F) (c : C) : «际» S := fun s t => K.Breaks s t g c

/-- The change from `s` to `t` keeps `g`'s dependence on `c`: its need at `s` met at `s` and at `t`. -/
def keeping (g : F) (c : C) : «际» S := fun s t => K.Keeps s t g c

/-- **The but-for statement at the model**: from `s` the move's relation meets the breaking; from what
`R` leaves the move can be taken, and the move from there lies within the keeping. -/
def differenceAt (P : Process S A) (R : «际» S) (s : S) (a : A) (g : F) (c : C) : Prop :=
  «能» («合» (moveRel P a) (breaking K g c)) s ∧ «能» («而» R (moveRel P a)) s ∧
    «则» («合» (fun w _ => R s w) (moveRel P a)) (keeping K g c)

theorem makesDifference_iff {P : Process S A} {withhold : F → S → S} {f : F} {s : S} {a : A} {g : F}
    {c : C} : K.MakesDifference P withhold f s a g c ↔ differenceAt K P (withholding withhold f) s a g c := by
  constructor
  · intro ⟨breaks, ⟨t, step⟩, keeps⟩
    refine ⟨breaks, ⟨t, withhold f s, rfl, step⟩, fun w t ⟨same, step⟩ => ?_⟩
    have same' : w = withhold f s := same
    subst same'
    exact keeps t step
  · intro ⟨breaks, ⟨t, w, same, step⟩, keeps⟩
    have same' : w = withhold f s := same
    subst same'
    exact ⟨breaks, ⟨t, step⟩, fun t step => keeps _ t ⟨rfl, step⟩⟩

theorem makesDifferenceTogether_iff {P : Process S A} {withhold : F → S → S} {fs : List F} {s : S}
    {a : A} {g : F} {c : C} :
    K.MakesDifferenceTogether P withhold fs s a g c ↔
      differenceAt K P («历» (withholding withhold) fs) s a g c := by
  constructor
  · intro ⟨breaks, ⟨t, step⟩, keeps⟩
    refine ⟨breaks, ⟨t, withholdAll withhold fs s, (withholdAll_iff_li withhold fs s _).mpr rfl, step⟩,
      fun w t ⟨reached, step⟩ => ?_⟩
    have same := (withholdAll_iff_li withhold fs s w).mp reached
    subst same
    exact keeps t step
  · intro ⟨breaks, ⟨t, w, reached, step⟩, keeps⟩
    have same := (withholdAll_iff_li withhold fs s w).mp reached
    subst same
    exact ⟨breaks, ⟨t, step⟩, fun t step => keeps _ t ⟨(withholdAll_iff_li withhold fs s _).mpr rfl, step⟩⟩

theorem differenceOnlyTogether_iff_model {P : Process S A} {withhold : F → S → S} {fs : List F} {s : S}
    {a : A} {g : F} {c : C} :
    K.DifferenceOnlyTogether P withhold fs s a g c ↔
      differenceAt K P («历» (withholding withhold) fs) s a g c ∧
        ∀ f, f ∈ fs → ¬ differenceAt K P (withholding withhold f) s a g c :=
  ⟨fun ⟨together, noPart⟩ => ⟨(makesDifferenceTogether_iff K).mp together,
      fun f member made => noPart f member ((makesDifference_iff K).mpr made)⟩,
   fun ⟨together, noPart⟩ => ⟨(makesDifferenceTogether_iff K).mpr together,
      fun f member made => noPart f member ((makesDifference_iff K).mp made)⟩⟩

/-- **An overdetermined loss**: the move's relation meets the breaking from the configuration and from
what each withholding leaves. -/
theorem overdetermined_iff {P : Process S A} {withhold : F → S → S} {s : S} {a : A} {g : F} {c : C} :
    K.Overdetermined P withhold s a g c ↔
      «能» («合» (moveRel P a) (breaking K g c)) s ∧
        ∀ f, «能» («而» (withholding withhold f) («合» (moveRel P a) (breaking K g c))) s :=
  ⟨fun ⟨breaks, each⟩ => ⟨breaks, fun f => match each f with
     | ⟨t, step, broken⟩ => ⟨t, withhold f s, rfl, step, broken⟩⟩,
   fun ⟨breaks, each⟩ => ⟨breaks, fun f => match each f with
     | ⟨t, w, same, step, broken⟩ => by
       have same' : w = withhold f s := same
       subst same'
       exact ⟨t, step, broken⟩⟩⟩

/-- **The row `Dependence.Overdetermined.only_together` at the model**: where the breaking is met from
the configuration and from what each withholding leaves, parts making the difference together make it
only together. -/
theorem only_together_reading {P : Process S A} {withhold : F → S → S} {fs : List F} {s : S} {a : A}
    {g : F} {c : C}
    (over : «能» («合» (moveRel P a) (breaking K g c)) s ∧
      ∀ f, «能» («而» (withholding withhold f) («合» (moveRel P a) (breaking K g c))) s)
    (together : differenceAt K P («历» (withholding withhold) fs) s a g c) :
    differenceAt K P («历» (withholding withhold) fs) s a g c ∧
      ∀ f, f ∈ fs → ¬ differenceAt K P (withholding withhold f) s a g c :=
  (differenceOnlyTogether_iff_model K).mp (Dependence.Overdetermined.only_together (K := K)
    ((overdetermined_iff K).mpr over) ((makesDifferenceTogether_iff K).mpr together))

/-- **The row `Dependence.differenceOnlyTogether_iff` at the model**: with each move's relation fixing
its successor, the move available from what each withholding leaves and the dependence required and
met there, the parts make the difference only together exactly where they do together and from what
each one's withholding leaves the move's relation meets the breaking. -/
theorem differenceOnlyTogether_reading {P : Process S A} (fixed : ∀ b, «定后» (moveRel P b))
    {withhold : F → S → S} {fs : List F} {s : S} {a : A} {g : F} {c : C}
    (available : ∀ f, f ∈ fs → «能» («而» (withholding withhold f) (moveRel P a)) s)
    (held : ∀ f, f ∈ fs → ∀ w, withholding withhold f s w → requiresAt K g c w ∧ needMetAt K g c w) :
    (differenceAt K P («历» (withholding withhold) fs) s a g c ∧
        ∀ f, f ∈ fs → ¬ differenceAt K P (withholding withhold f) s a g c) ↔
      differenceAt K P («历» (withholding withhold) fs) s a g c ∧
        ∀ f, f ∈ fs → «能» («而» (withholding withhold f) («合» (moveRel P a) (breaking K g c))) s :=
  (differenceOnlyTogether_iff_model K).symm.trans
    ((K.differenceOnlyTogether_iff (determined_iff_fixed.mpr fixed)
        (fun f member => match available f member with
          | ⟨t, w, same, step⟩ => by
            have same' : w = withhold f s := same
            subst same'
            exact ⟨t, step⟩)
        (fun f member => (held f member _ rfl).1) (fun f member => (held f member _ rfl).2)).trans
      ⟨fun ⟨together, each⟩ => ⟨(makesDifferenceTogether_iff K).mp together, fun f member =>
          match each f member with
          | ⟨t, step, broken⟩ => ⟨t, withhold f s, rfl, step, broken⟩⟩,
       fun ⟨together, each⟩ => ⟨(makesDifferenceTogether_iff K).mpr together, fun f member =>
          match each f member with
          | ⟨t, w, same, step, broken⟩ => by
            have same' : w = withhold f s := same
            subst same'
            exact ⟨t, step, broken⟩⟩⟩)

end Joint

section Fixing

variable {S : Type u} {A : Type v} {P : Process S A}

/-- **The record up to `t` fixes `a`'s outcome at `s` exactly where every family of relations indexed
by moves, each fixing its successor and holding the run's steps before `t`, relates `s` by `a` only to
`u`.** -/
theorem fixes_iff (r : Run P) (t : Nat) (s : S) (a : A) (u : S) :
    r.Fixes t s a u ↔ ∀ G : A → «际» S, (∀ b, «定后» (G b)) →
      (∀ n, «及» Steps.next n t → G (r.act n) (r.state n) (r.state (n + 1))) → ∀ u', G a s u' → u' = u :=
  ⟨fun fixes G fixed steps u' rel =>
     fixes ⟨fun x b y => G b x y⟩ (determined_iff_fixed.mpr fixed)
       (fun n lt => steps n ((before_iff_lt n t).mpr lt)) u' rel,
   fun fixes Q determined steps u' step => fixes (moveRel Q) (determined_iff_fixed.mp determined)
     (fun n before => steps n ((before_iff_lt n t).mp before)) u' step⟩

/-- **A run takes a move before `t`**: its line passes through the configuration and the move at a
step before `t`. -/
theorem takes_iff (r : Run P) (t : Nat) (s : S) (b : A) :
    r.Takes t s b ↔ ∃ n, «及» Steps.next n t ∧ r.state n = s ∧ r.act n = b :=
  ⟨fun ⟨n, lt, at_s, at_b⟩ => ⟨n, (before_iff_lt n t).mpr lt, at_s, at_b⟩,
   fun ⟨n, before, at_s, at_b⟩ => ⟨n, (before_iff_lt n t).mp before, at_s, at_b⟩⟩

/-- **The row `Run.not_fixes_of_untaken` at the model**: with each move's relation fixing its
successor and two configurations apart, a move the run's line has not passed through before `t` is
related by no record to one outcome. -/
theorem not_fixes_reading (determined : ∀ b, «定后» (moveRel P b)) (r : Run P) {t : Nat} {s : S} {b : A}
    (untaken : ¬ ∃ n, «及» Steps.next n t ∧ r.state n = s ∧ r.act n = b) {x y : S} (two : x ≠ y) :
    ¬ ∃ u, ∀ G : A → «际» S, (∀ b, «定后» (G b)) →
      (∀ n, «及» Steps.next n t → G (r.act n) (r.state n) (r.state (n + 1))) → ∀ u', G b s u' → u' = u :=
  fun ⟨u, fixes⟩ => Run.not_fixes_of_untaken (determined_iff_fixed.mpr determined) r
    (fun taken => untaken ((takes_iff r t s b).mp taken)) two ⟨u, (fixes_iff r t s b u).mpr fixes⟩

end Fixing

section Codes

variable {I : Type u} {M : Type v} [DecidableEq I] [DecidableEq M]

/-- In a hearing, at a sense, the copying relation: `i` holds after the hearing `j`'s form before it.
Read from who hears whom at which sense. -/
def copies (m : M) (e : SharedCodes.Hearing I M) : «际» I := fun j i => SharedCodes.back m e i = j

/-- **A formation's origin after a word of hearings is what passes into it through the word's copying
relations in turn** (`«历»`). -/
theorem origin_iff_li (m : M) : ∀ (es : List (SharedCodes.Hearing I M)) (i j : I),
    SharedCodes.origin m es i = j ↔ «历» (copies m) es j i
  | [], _, _ => ⟨Eq.symm, Eq.symm⟩
  | e :: es, i, _ =>
    ⟨fun same => ⟨SharedCodes.origin m es i, same, (origin_iff_li m es i _).mp rfl⟩,
     fun ⟨y, step, rest⟩ => (congrArg (SharedCodes.back m e) ((origin_iff_li m es i y).mpr rest)).trans step⟩

/-- **What a word of hearings reaches is passing through the hearings' moves in turn**: from `X`, the
code the word makes of it. -/
theorem reached_iff {F : Type w} (adopt : (M → F) → (M → F) → M → Bool) :
    ∀ (es : List (SharedCodes.Hearing I M)) (X Y : I → M → F),
      «历» (moveRel (SharedCodes.process adopt)) es X Y ↔ Y = SharedCodes.runBy adopt es X
  | [], _, _ => ⟨Eq.symm, Eq.symm⟩
  | e :: es, X, Y =>
    ⟨fun ⟨_, same, rest⟩ => ((reached_iff adopt es _ Y).mp rest).trans
        (congrArg (SharedCodes.runBy adopt es) same),
     fun h => ⟨SharedCodes.hearBy adopt e X, rfl, (reached_iff adopt es _ Y).mpr h⟩⟩

/-- **The runs of the hearings agree exactly where what the word of hearings reaches does**: every
code reached through the first `k` hearings from any start has all formations alike at `m`. -/
theorem runs_agree_iff_reached {F : Type w} (acts : Nat → SharedCodes.Hearing I M) (k : Nat) (m : M) :
    (∀ r : Run (SharedCodes.process (I := I) (M := M) (F := F) SharedCodes.always),
        (∀ t, r.act t = acts t) → ∀ i j, r.state k i m = r.state k j m) ↔
      ∀ X Y : I → M → F, «历» (moveRel (SharedCodes.process SharedCodes.always)) (SharedCodes.hearings acts 0 k) X Y →
        «则» «一» (sameValue fun i => Y i m) := by
  constructor
  · intro runs X Y reached i j _
    have same := (reached_iff SharedCodes.always _ X Y).mp reached
    subst same
    exact (SharedCodes.state_hearings (SharedCodes.hearingRun SharedCodes.always X acts) (fun _ => rfl) k i m).symm.trans
      ((runs _ (fun _ => rfl) i j).trans
        (SharedCodes.state_hearings (SharedCodes.hearingRun SharedCodes.always X acts) (fun _ => rfl) k j m))
  · intro traces r heard i j
    exact (SharedCodes.state_hearings r heard k i m).trans
      ((traces _ _ ((reached_iff SharedCodes.always _ _ _).mpr rfl) i j trivial).trans
        (SharedCodes.state_hearings r heard k j m).symm)

/-- **The row `SharedCodes.run_agrees_every_start_iff` at the process's model**: where two forms
differ, every code the first `k` hearings reach from any start has all formations alike at `m` exactly
where every two formations are reached from one formation through the hearings' copying relations. -/
theorem run_agrees_every_start_reading {F : Type w} {a b : F} (apart : a ≠ b)
    (acts : Nat → SharedCodes.Hearing I M) (k : Nat) (m : M) :
    (∀ X Y : I → M → F, «历» (moveRel (SharedCodes.process SharedCodes.always)) (SharedCodes.hearings acts 0 k) X Y →
        «则» «一» (sameValue fun i => Y i m)) ↔
      «则» «一» («而» («逆» («历» (copies m) (SharedCodes.hearings acts 0 k)))
        («历» (copies m) (SharedCodes.hearings acts 0 k))) :=
  (runs_agree_iff_reached acts k m).symm.trans ((SharedCodes.run_agrees_every_start_iff apart acts k m).trans
    ⟨fun one i j _ => ⟨SharedCodes.origin m (SharedCodes.hearings acts 0 k) i,
        (origin_iff_li m _ i _).mp rfl, (origin_iff_li m _ j _).mp (one i j).symm⟩,
     fun shared i j => match shared i j trivial with
       | ⟨o, from_i, from_j⟩ =>
         ((origin_iff_li m _ i o).mpr from_i).trans ((origin_iff_li m _ j o).mpr from_j).symm⟩)

end Codes

/-! ### A finite reading, on runs as lines -/

/-- The runs along which the focal formation renews, read at the occurrence model of the one-kind
reading of the web along the run (`renewingIn_iff`). -/
def renewingAlong (r : Run Renewable.process) : Prop :=
  «则» («而» (Web.partialIdentity fun y =>
      «能» («逆» («而» («而» (Web.partialIdentity fun a =>
          a.2 = (Sum.inl Renewable.Formation.focal : Renewable.Formation ⊕ Unit))
        (participating (Renewable.conditions.dependence.along r).roles)) sameName)) y)
    («逆» (requiring (Renewable.conditions.dependence.along r).roles)))
    (keptAcross (Renewable.conditions.dependence.along r).roles)

theorem renewing_iff_along (r : Run Renewable.process) :
    (Renewable.conditions.dependence.along r).RenewingIn .focal ↔ renewingAlong r :=
  ((Renewable.conditions.dependence.along r).roles_renewingIn .focal).symm.trans
    (renewingIn_iff (Renewable.conditions.dependence.along r).roles (.inl .focal))

/-- **The row `Renewable.no_exact_finite_reading` at the model**: no region of runs closed under
agreeing up to `h` is the region of runs along which the focal formation renews. -/
theorem finite_reading_not_exact (h : Nat) :
    ∀ reading : Run Renewable.process → Prop,
      «闭» (fun r r' => (∀ n, «所闭» Steps.next n h → r.state n = r'.state n) ∧
          ∀ n, «及» Steps.next n h → r.act n = r'.act n) reading →
        ¬ ∀ r, reading r ↔ renewingAlong r :=
  fun reading closed exact => Renewable.no_exact_finite_reading h reading
    (fun r r' agree held => closed r r' held ((agreeUpTo_iff h r r').mp agree))
    fun r => (exact r).trans (renewing_iff_along r).symm

/-- **That is one statement of closure**: the region of renewing runs is not closed under agreeing up
to `h`. -/
theorem finite_reading_iff (h : Nat) :
    (∀ reading : Run Renewable.process → Prop,
      «闭» (fun r r' => (∀ n, «所闭» Steps.next n h → r.state n = r'.state n) ∧
          ∀ n, «及» Steps.next n h → r.act n = r'.act n) reading →
        ¬ ∀ r, reading r ↔ renewingAlong r) ↔
      ¬ «闭» (fun r r' : Run Renewable.process => (∀ n, «所闭» Steps.next n h → r.state n = r'.state n) ∧
          ∀ n, «及» Steps.next n h → r.act n = r'.act n) renewingAlong :=
  ⟨fun none closed => none _ closed fun _ => Iff.rfl,
   fun not_closed _ closed exact => not_closed fun r r' renews agree =>
     (exact r').mp (closed r r' ((exact r).mpr renews) agree)⟩

/-- **The row `Renewable.no_exact_finite_reading` as a statement of closure**: the region of runs along
which the focal formation renews is not closed under agreeing up to `h`. -/
theorem renewing_not_closed (h : Nat) :
    ¬ «闭» (fun r r' : Run Renewable.process => (∀ n, «所闭» Steps.next n h → r.state n = r'.state n) ∧
        ∀ n, «及» Steps.next n h → r.act n = r'.act n) renewingAlong :=
  (finite_reading_iff h).mp (finite_reading_not_exact h)

/-! ## 9. The rows' own carriers -/

section Coupling

variable {F C : Type}

/-- Alike through `h`'s couplings up to `t`, as a relation on level histories. -/
def couplingAlike (W : Web F C) (obs : F → C → Prop) (h : F) (t : Nat) : «际» (Nat → C → Nat) :=
  fun l l' => W.AlikeThroughUpTo obs h l l' t

/-- Exchanging alike for `h` across the step from `t`, as a relation on level histories: the meet,
over the conditions, of the classes of what `h` takes and gives (`sameValue`). -/
def exchangingAlike (law : ExchangeLaw F C) (t : Nat) (h : F) : «际» (Nat → C → Nat) :=
  fun l l' => ∀ c, sameValue (fun m => law.take t h m c) l l' ∧ sameValue (fun m => law.give t h m c) l l'

/-- **Reading through the coupling is an inclusion**: for each formation outside the part and each
step, alike through its coupling lies within exchanging alike. -/
theorem through_iff_inclusion {law : ExchangeLaw F C} {W : Web F C} {obs : F → C → Prop}
    {part : F → Bool} :
    law.Through W obs part ↔
      ∀ h, part h = false → ∀ t, «则» (couplingAlike W obs h t) (exchangingAlike law t h) :=
  ⟨fun through h outside t l l' alike => through h outside t l l' alike,
   fun inside h outside t l l' alike => inside h outside t l l' alike⟩

/-- **The row `ExchangeLaw.response_not_fixed_by_coupling` on the grammar**: where membership of each
coupling class of `l` is decided and `g` couples `l` and `l'` apart up to `t`, some law whose exchanging
alike contains every formation's coupling class does not relate them by what `g` takes from `c` across
the step from `t`, and some such law's exchanging alike is the full relation at every step. -/
theorem response_not_fixed_reading {W : Web F C} {obs : F → C → Prop} {l l' : Nat → C → Nat}
    {t : Nat} (decided : ∀ h t m, Decidable (couplingAlike W obs h t l m)) {g : F} (c : C)
    (apart : ¬ couplingAlike W obs g t l l') :
    (∃ law : ExchangeLaw F C, (∀ h s, «则» (couplingAlike W obs h s) (exchangingAlike law s h)) ∧
        ¬ sameValue (fun m => law.take t g m c) l l') ∧
      ∃ law : ExchangeLaw F C, (∀ h s, «则» (couplingAlike W obs h s) (exchangingAlike law s h)) ∧
        ∀ s h, «谓» (exchangingAlike law s h) «一» :=
  match ExchangeLaw.response_not_fixed_by_coupling (W := W) (obs := obs) (l := l) (l' := l') (t := t)
      decided c apart with
  | ⟨⟨law, through, differs⟩, ⟨law', through', alike⟩⟩ =>
    ⟨⟨law, fun h => through_iff_inclusion.mp through h rfl, differs⟩,
     ⟨law', fun h => through_iff_inclusion.mp through' h rfl,
      fun s h _ _ => ⟨fun _ => trivial, fun _ => alike s h _ _⟩⟩⟩

end Coupling

section Verifying

variable {α : Type u} {P : Ideals.Preorder α} {X : Type v}

/-- Membership on one carrier of points and stretches: a point bears it to each stretch of its
ideal. -/
def member (ι : X → Ideals.Ideal P) : «际» (X ⊕ α)
  | .inl x, .inr p => (ι x).mem p
  | .inl _, .inl _ => False
  | .inr _, _ => False

/-- A reading of points on that carrier: the points it holds. -/
def onPoints (K : X → Prop) : X ⊕ α → Prop
  | .inl x => K x
  | .inr _ => False

/-- **The interior on the grammar**: a point lies in a reading's interior exactly where it bears
membership to a stretch every bearer of which the reading holds (`«承»`). -/
theorem interiorBy_iff {ι : X → Ideals.Ideal P} {K : X → Prop} {x : X} :
    Ideals.InteriorBy ι K x ↔
      «能» («合» (member ι) fun _ v => «承» (member ι) (onPoints (α := α) K) v) (.inl x) :=
  ⟨fun ⟨p, mem, all⟩ => ⟨.inr p, mem, fun
      | .inl y, mem' => all y mem'
      | .inr _, no => nomatch no⟩,
   fun
   | ⟨.inr p, mem, all⟩ => ⟨p, mem, fun y mem' => all (.inl y) mem'⟩
   | ⟨.inl _, no, _⟩ => nomatch no⟩

/-- **The row `Ideals.verifiableBy_iff_interior` on the grammar.** -/
theorem verifiableBy_reading {ι : X → Ideals.Ideal P} {K : X → Prop} :
    Ideals.VerifiableBy ι K ↔
      ∀ x, K x → «能» («合» (member ι) fun _ v => «承» (member ι) (onPoints (α := α) K) v) (.inl x) :=
  Ideals.verifiableBy_iff_interior.trans
    ⟨fun all x held => interiorBy_iff.mp (all x held), fun all x held => interiorBy_iff.mpr (all x held)⟩

end Verifying

section Selecting

variable {I : Type u} {V : Type v}

/-- Agreeing on the data, as a relation on functions: the meet, over the data, of the classes of the
values there (`sameValue`). -/
def agreeingOn (D : I → Prop) : «际» (I → V) := fun g g' => ∀ i, D i → sameValue (fun f => f i) g g'

/-- **A selection closed along agreeing on the data is a selection through it**, agreement being
symmetric. -/
theorem through_of_closed {D : I → Prop} {select : (I → V) → Prop}
    (closed : «闭» (Learning.Training.AgreeOn D) select) :
    Learning.Training.Through (Learning.Training.AgreeOn D) select :=
  fun g g' agree => ⟨fun held => closed g g' held agree, fun held => closed g' g held fun i d => (agree i d).symm⟩

/-- **A class free at `x` beyond the data**: every two members are related by agreeing, on the data,
with a member that is then alike at `x` with the second. -/
theorem free_iff {C : (I → V) → Prop} {D : I → Prop} {x : I} :
    Learning.Free C D x ↔
      «则» («合» (fun g _ => C g) fun _ g' => C g')
        («而» («合» («逆» (Learning.Training.AgreeOn D)) fun _ h => C h) (sameValue fun f => f x)) :=
  ⟨fun free g g' ⟨member, member'⟩ => match free g g' member member' with
     | ⟨h, member_h, agree, at_x⟩ => ⟨h, ⟨agree, member_h⟩, at_x⟩,
   fun inside g g' member member' => match inside g g' ⟨member, member'⟩ with
     | ⟨h, ⟨agree, member_h⟩, at_x⟩ => ⟨h, member_h, agree, at_x⟩⟩

/-- **The row `Learning.Training.unselected_beyond_data` on the grammar**: with the selection closed
along agreeing on the data and the class free at `x`, a selected member is related to every member by
agreeing with a selected member of the class that is then alike at `x`. -/
theorem unselected_beyond_data_reading {C : (I → V) → Prop} {D : I → Prop} {x : I}
    {select : (I → V) → Prop} (closed : «闭» (agreeingOn D) select)
    (free : «则» («合» (fun g _ => C g) fun _ g' => C g')
        («而» («合» («逆» (agreeingOn D)) fun _ h => C h) (sameValue fun f => f x)))
    {g g' : I → V} (member : C g) (member' : C g') (chosen : select g) :
    «而» («合» («逆» (agreeingOn D)) fun _ h => C h ∧ select h) (sameValue fun f => f x) g g' :=
  match Learning.Training.unselected_beyond_data (through_of_closed closed) (free_iff.mpr free) member
      member' chosen with
  | ⟨h, member_h, chosen_h, agree, at_x⟩ => ⟨h, ⟨agree, member_h, chosen_h⟩, at_x⟩

end Selecting

section Outcomes

variable {F C : Type}

/-- One outcome exceeds another on a family: at least as high at each of its conditions and higher at
one. Given levels compared. -/
def exceedsOn (ds : List C) : «际» (C → Nat) := fun o' o =>
  (∀ c, c ∈ ds → o c ≤ o' c) ∧ ∃ c, c ∈ ds ∧ o c < o' c

/-- One outcome stands lower than another at a condition beyond. Given levels compared. -/
def lowerBeyond (rest : List C) : «际» (C → Nat) := fun o o' => ∃ c, c ∈ rest ∧ o' c < o c

theorem rising_iff {ds : List C} {better : (C → Nat) → (C → Nat) → Prop} :
    Optimum.Rising ds better ↔ «则» (exceedsOn ds) better :=
  ⟨fun rising o' o exceeds => rising o o' exceeds, fun inside o o' exceeds => inside o' o exceeds⟩

theorem room_iff {ds rest : List C} {eligible : (C → Nat) → Prop} :
    Optimum.Room ds rest eligible ↔
      ∀ o, «能» («而» («而» (Web.partialIdentity eligible) (lowerBeyond rest)) (Web.partialIdentity eligible)) o →
        «能» («合» («逆» (exceedsOn ds)) fun _ o'' => eligible o'') o := by
  constructor
  · intro room o ⟨_, o₁, ⟨w, ⟨same, el⟩, c, mem, lower⟩, _, el₁⟩
    cases same
    obtain ⟨o'', el'', exceeds⟩ := room o o₁ el el₁ c mem lower
    exact ⟨o'', exceeds, el''⟩
  · intro inside o o' el el' c mem lower
    obtain ⟨o'', exceeds, el''⟩ := inside o ⟨o', o', ⟨o, ⟨rfl, el⟩, c, mem, lower⟩, rfl, el'⟩
    exact ⟨o'', el'', exceeds⟩

theorem frontier_iff {eligible : (C → Nat) → Prop} {better : (C → Nat) → (C → Nat) → Prop}
    {a : C → Nat} :
    Requirement.Frontier eligible better a ↔ eligible a ∧ ¬ «能» («合» («逆» better) fun _ b => eligible b) a :=
  ⟨fun ⟨el, unbeaten⟩ => ⟨el, fun ⟨b, beats, elb⟩ => unbeaten b elb beats⟩,
   fun ⟨el, noBetter⟩ => ⟨el, fun b elb beats => noBetter ⟨b, beats, elb⟩⟩⟩

theorem metOn_iff (W : Web F C) {dep : C → F} {rest : List C} {t : Nat} :
    W.MetOn dep rest t ↔
      ∀ c, c ∈ rest → «合» (requiring W.roles) (needMet W.roles) (t, .inl (dep c)) (t, .inr c) :=
  ⟨fun met c mem => ⟨⟨rfl, (met c mem).1⟩, rfl, (met c mem).2⟩,
   fun met c mem => ⟨(met c mem).1.2, (met c mem).2.2⟩⟩

theorem broken_iff (W : Web F C) {t : Nat} {g : F} {c : C} :
    W.Broken t g c ↔ «合» (requiring W.roles) (needMet W.roles) (t, .inl g) (t, .inr c) ∧
      belowAfter W.roles (t, .inl g) (t + 1, .inr c) :=
  ⟨fun ⟨req, met, below⟩ => ⟨⟨⟨rfl, req⟩, rfl, met⟩, rfl, below⟩,
   fun ⟨⟨⟨_, req⟩, _, met⟩, _, below⟩ => ⟨req, met, below⟩⟩

/-- **The row `Web.optimum_broken_iff` at the model**: where the levels after the step are an outcome
unbeaten among the eligible under an order containing exceeding on the family, with room beyond, and
each condition beyond is required and met by the formation named on it, a dependence beyond is broken
across the step exactly where some eligible outcome stands below its need there. -/
theorem optimum_broken_reading {W : Web F C} {ds rest : List C} {eligible : (C → Nat) → Prop}
    {better : (C → Nat) → (C → Nat) → Prop} {dep : C → F} {t : Nat}
    (rising : «则» (exceedsOn ds) better)
    (room : ∀ o, «能» («而» («而» (Web.partialIdentity eligible) (lowerBeyond rest))
        (Web.partialIdentity eligible)) o → «能» («合» («逆» (exceedsOn ds)) fun _ o'' => eligible o'') o)
    (optimum : eligible (W.level (t + 1)) ∧ ¬ «能» («合» («逆» better) fun _ b => eligible b) (W.level (t + 1)))
    (met : ∀ c, c ∈ rest → «合» (requiring W.roles) (needMet W.roles) (t, .inl (dep c)) (t, .inr c))
    {c : C} (mem : c ∈ rest) :
    («合» (requiring W.roles) (needMet W.roles) (t, .inl (dep c)) (t, .inr c) ∧
        belowAfter W.roles (t, .inl (dep c)) (t + 1, .inr c)) ↔
      ∃ o, eligible o ∧ o c < W.roles.need t (.inl (dep c)) (.inr c) :=
  (broken_iff W).symm.trans (Web.optimum_broken_iff (rising_iff.mpr rising) (room_iff.mpr room)
    (frontier_iff.mpr optimum) ((metOn_iff W).mpr met) mem)

end Outcomes

end ModelStatements

end Becoming
