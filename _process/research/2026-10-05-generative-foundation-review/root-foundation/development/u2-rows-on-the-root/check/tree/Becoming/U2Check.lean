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

/-!
# Scratch check of the U2 design's statements (not a landed module)

The definitional rows and the statements at a model, on the root: each row stated as the grammar
reading it is, or at the World's occurrence model or a process's model of its moves' relations. See
`DESIGN.md` in this folder.
-/

namespace Becoming

open Generative

namespace U2Check

universe u v w

/-! ## The occurrence model of a web: support, dependence and kept dependences

A web of one kind `V : Web X X` read on its occurrences `Nat × X`, as WRT2's occurrence model reads a
World's. A two-kind web `W : Web F C` is read through its one-kind reading `W.roles`
(`Becoming.Roles`), whose occurrences are `Nat × (F ⊕ C)`. -/

section Occurrences

variable {X : Type} (V : Web X X)

/-- What an occurrence requires, within its step (`World.withinStep`, the formation first). -/
def requiring : «际» (Nat × X) := World.withinStep V.requires

/-- The needs met within a step: the occurrence's need for the condition is within the condition's
level at that step. Read from amounts, as WRT2's within-step relations are. -/
def needMet : «际» (Nat × X) := World.withinStep fun t x y => V.need t x y ≤ V.level t y

/-- The occurrences active at their step, a region of the occurrence model. -/
def activeAt (o : Nat × X) : Prop := V.active o.1 o.2

/-- **Support is what an occurrence requires lying within the needs met**: at `(t, x)`, every
requiring is a need met. -/
theorem supported_iff (t : Nat) (x : X) :
    V.Supported t x ↔ «则» («而» (Web.partialIdentity (· = (t, x))) (requiring V)) (needMet V) :=
  ⟨fun supported o z ⟨y, ⟨same, at_o⟩, step, req⟩ => by
    subst same; subst at_o
    exact ⟨step, supported z.2 req⟩,
   fun within c req => (within (t, x) (t, c) ⟨(t, x), ⟨rfl, rfl⟩, rfl, req⟩).2⟩

/-- **Dependence is requiring from the active occurrences lying within the needs met.** -/
theorem dependent_iff :
    V.Dependent ↔ «则» («而» (Web.partialIdentity (activeAt V)) (requiring V)) (needMet V) :=
  ⟨fun dependent o z ⟨y, ⟨same, active⟩, step, req⟩ => by
    subst same
    exact ⟨step, dependent o.1 o.2 active z.2 req⟩,
   fun within t f active c req => (within (t, f) (t, c) ⟨(t, f), ⟨rfl, active⟩, rfl, req⟩).2⟩

end Occurrences

/-- **A two-kind web's support is a grammar statement at the occurrence model of its one-kind
reading**, the row `Web.roles_supported` being that both sides are this statement. -/
theorem roles_supported_reading {F C : Type} (W : Web F C) (t : Nat) (f : F) :
    W.Supported t f ↔
      «则» («而» (Web.partialIdentity (· = (t, .inl f))) (requiring W.roles)) (needMet W.roles) :=
  (W.roles_supported t f).symm.trans (supported_iff W.roles t (.inl f))

/-- **And its dependence**, the row `Web.roles_dependent`. -/
theorem roles_dependent_reading {F C : Type} (W : Web F C) :
    W.Dependent ↔ «则» («而» (Web.partialIdentity (activeAt W.roles)) (requiring W.roles)) (needMet W.roles) :=
  W.roles_dependent.symm.trans (dependent_iff W.roles)

/-! ## The steps on `Nat`, and a kernel -/

/-- **Lying within the closure of the steps on `Nat` is coming no earlier.** -/
theorem withinSteps_iff_le (n k : Nat) : «所闭» Steps.next n k ↔ n ≤ k :=
  ⟨fun within => within (fun m => n ≤ m) (fun _ _ le step => Eq.subst (motive := fun b => n ≤ b) step.symm
      (Nat.le_succ_of_le le)) (Nat.le_refl n),
   fun le => match le_dest le with
    | ⟨d, same⟩ => Eq.subst (motive := fun b => «所闭» Steps.next n b) same.symm
        (Nat.rec (motive := fun d => «所闭» Steps.next n (n + d)) («所闭之自反» Steps.next n)
          (fun _ ih => «所闭之传递» ih («缘在所闭» rfl)) d)⟩

/-- **A guess tracks a target where, on each run, the closure of the steps from some horizon lies
within the class of agreeing with it.** -/
theorem tracks_iff {S : Type u} {A : Type v} {P : Process S A} {V : Type w} {g : Nat → Run P → V}
    {h : Nat → Run P → V} :
    Limit.Tracks g h ↔ ∀ r, ∃ n, ∀ k, «所闭» Steps.next n k → g k r = h k r :=
  ⟨fun tracks r => match tracks r with
    | ⟨n, from_n⟩ => ⟨n, fun k within => from_n k ((withinSteps_iff_le n k).mp within)⟩,
   fun tracks r => match tracks r with
    | ⟨n, from_n⟩ => ⟨n, fun k le => from_n k ((withinSteps_iff_le n k).mpr le)⟩⟩

/-- **The row `Limit.identifies_iff_tracks` on the grammar**: identifying a hypothesis is the closure
of the steps from some horizon lying within agreement with the constant target. -/
theorem identifies_iff_reading {S : Type u} {A : Type v} {P : Process S A} {V : Type w}
    {g : Nat → Run P → V} {H : Run P → V} :
    Limit.Identifies g H ↔ ∀ r, ∃ n, ∀ k, «所闭» Steps.next n k → g k r = H r :=
  Limit.identifies_iff_tracks.trans tracks_iff

/-- **A kernel is the closure of the steps from a configuration lying within the guard.** -/
theorem kernel_iff {S : Type u} {A : Type v} {P : Process S A} {g : S → Prop} {s : S} :
    Viability.Kernel P g s ↔ ∀ t, «所闭» (Steps P) s t → g t :=
  ⟨fun kept t within => kept t (reach_iff_withinClosure.mpr within),
   fun kept t reach => kept t (reach_iff_withinClosure.mp reach)⟩

/-- **The row `Viability.kernel_and_iff` on the grammar**: the closure lies within a meet of two
regions exactly where it lies within each. -/
theorem kernel_and_reading {S : Type u} {A : Type v} {P : Process S A} {g₁ g₂ : S → Prop} {s : S} :
    (∀ t, «所闭» (Steps P) s t → g₁ t ∧ g₂ t) ↔
      (∀ t, «所闭» (Steps P) s t → g₁ t) ∧ ∀ t, «所闭» (Steps P) s t → g₂ t :=
  kernel_iff.symm.trans (Viability.kernel_and_iff.trans ⟨fun ⟨k₁, k₂⟩ => ⟨kernel_iff.mp k₁, kernel_iff.mp k₂⟩,
    fun ⟨k₁, k₂⟩ => ⟨kernel_iff.mpr k₁, kernel_iff.mpr k₂⟩⟩)

/-! ## Kept and lost dependences, renewal, transmission and the living events at the occurrence model

These read amounts across one step along the names, through relations of the occurrence model read
from them: a need met after the step, a dependence kept or lost across it, and a need within `δ` of
another's. Read as 缘, kept and lost run from the condition to the formation, as WRT2 reads requiring
under `«逆»`. -/

section AcrossSteps

variable {X : Type} (V : Web X X)

/-- An occurrence's need at its step is within the condition's level at the next step. -/
def metAfter : «际» (Nat × X) := fun x y => y.1 = x.1 + 1 ∧ V.need x.1 x.2 y.2 ≤ V.level y.1 y.2

/-- A dependence kept across the step, from the condition to the formation: its need met at the step
and after it. -/
def keptAcross : «际» (Nat × X) := fun y z => needMet V z y ∧ metAfter V z (y.1 + 1, y.2)

/-- A dependence lost across the step, from the condition to the formation: at one step, the
condition's level after the step is below the need, and the dependence was met above that level
while it held (`Web.MetAbove`, which reads the dependence's history along the names). -/
def lostAcross : «际» (Nat × X) := fun y z =>
  z.1 = y.1 ∧ V.MetAbove z.1 z.2 y.2 (V.level (y.1 + 1) y.2) ∧ V.level (y.1 + 1) y.2 < V.need z.1 z.2 y.2

/-- What an occurrence takes part in, within its step: requiring or drawing. -/
def participating : «际» (Nat × X) := World.withinStep fun t x y => V.requires t x y ∨ V.draws t x y

/-- What an occurrence draws on, within its step. -/
def drawing : «际» (Nat × X) := World.withinStep V.draws

/-- **A dependence kept across the step is the kept relation from the condition to the formation.** -/
theorem kept_iff (t : Nat) (g c : X) : V.Kept t g c ↔ keptAcross V (t, c) (t, g) :=
  ⟨fun ⟨now, after⟩ => ⟨⟨rfl, now⟩, rfl, after⟩, fun ⟨⟨_, now⟩, _, after⟩ => ⟨now, after⟩⟩

/-- **Renewal over a region of conditions is an inclusion**: the occurrence is active, and requiring,
from the conditions of the region it takes part in, lies within the kept relation. -/
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

/-- **Undermining is drawing on a condition from which a dependence is lost across the step**: «能» at
the composite of drawing with requiring met with the lost relation. -/
theorem underminingAt_iff (t : Nat) (f : X) :
    V.UnderminingAt t f ↔ «能» («而» (drawing V) («合» («逆» (requiring V)) (lostAcross V))) (t, f) := by
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
      activeAt V (t, x) ∧ ¬ «能» («而» (drawing V) («合» («逆» (requiring V)) (lostAcross V))) (t, x) :=
  ⟨fun ⟨active, sound⟩ => ⟨active, fun under => sound ((underminingAt_iff V t x).mpr under)⟩,
   fun ⟨active, sound⟩ => ⟨active, fun under => sound ((underminingAt_iff V t x).mp under)⟩⟩

/-- One descent as a relation of occurrences: `x` at its first standing step `t + 1` and `g` at the
giving step `t`. -/
def descentAt (t : Nat) (x g : X) : «际» (Nat × X) := fun u v => u = (t + 1, x) ∧ v = (t, g)

/-- The occurrences requiring `c` at their step. -/
def requiringOf (c : X) (u : Nat × X) : Prop :=
  «能» («而» (requiring V) (Web.partialIdentity fun w => w.2 = c)) u

/-- The need of one occurrence for `c` is within `δ` of another's. Read from amounts with an addition,
which U1's interface does not hold. -/
def needWithin (δ : Nat) (c : X) : «际» (Nat × X) := fun y z => V.need y.1 y.2 c ≤ V.need z.1 z.2 c + δ

/-- **Inheritance at a descent is an inclusion**: what the descendant requires of `c` at its first
step, read from the giver and carried back one step along the names, the giver requires. -/
theorem inheritsAt_iff (t : Nat) (x g c : X) :
    V.InheritsAt t x g c ↔
      «则» («而» («而» («逆» (descentAt t x g)) («而» (requiring V) (Web.partialIdentity fun w => w.2 = c)))
        («逆» Steps.along)) (requiring V) := by
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

/-- **The need within `δ` at a descent is an inclusion**: the descent, where both require `c`, lies
within the need-within relation. -/
theorem needsWithinAt_iff (t : Nat) (x g c : X) (δ : Nat) :
    V.NeedsWithinAt t x g c δ ↔
      «则» («合» (descentAt t x g) fun u v => requiringOf V c u ∧ requiringOf V c v) (needWithin V δ c) := by
  constructor
  · intro within u v ⟨⟨at_u, at_v⟩, ⟨_, m, ⟨_, ru⟩, _, mc⟩, ⟨_, m', ⟨_, rv⟩, _, mc'⟩⟩
    subst at_u
    subst at_v
    exact within (mc ▸ ru) (mc' ▸ rv)
  · intro inside hx hg
    exact inside (t + 1, x) (t, g)
      ⟨⟨rfl, rfl⟩, ⟨(t + 1, c), (t + 1, c), ⟨rfl, hx⟩, rfl, rfl⟩, ⟨(t, c), (t, c), ⟨rfl, hg⟩, rfl, rfl⟩⟩

/-- **The row `Web.transmits_at_iff` at the occurrence model, for a web of one kind**: transmission at
a descent is the two inclusions, inheritance and the need within `δ`. -/
theorem transmits_at_one_kind (t : Nat) (x g c : X) (δ : Nat) :
    (V.requires (t + 1) x c → V.requires t g c ∧ V.need (t + 1) x c ≤ V.need t g c + δ) ↔
      «则» («而» («而» («逆» (descentAt t x g)) («而» (requiring V) (Web.partialIdentity fun w => w.2 = c)))
          («逆» Steps.along)) (requiring V) ∧
        «则» («合» (descentAt t x g) fun u v => requiringOf V c u ∧ requiringOf V c v) (needWithin V δ c) :=
  V.transmits_at_iff.trans
    ⟨fun ⟨i, n⟩ => ⟨(inheritsAt_iff V t x g c).mp i, (needsWithinAt_iff V t x g c δ).mp n⟩,
     fun ⟨i, n⟩ => ⟨(inheritsAt_iff V t x g c).mpr i, (needsWithinAt_iff V t x g c δ).mpr n⟩⟩

end AcrossSteps

/-- A region of conditions on the one kind of relatum: every formation lies in it. -/
def onConditions {F C : Type} (region : C → Prop) : F ⊕ C → Prop
  | .inl _ => True
  | .inr c => region c

/-- **The one-kind reading keeps renewal over a region.** -/
theorem roles_renewingOver {F C : Type} (W : Web F C) (region : C → Prop) (t : Nat) (f : F) :
    W.roles.RenewingOver (onConditions region) t (.inl f) ↔ W.RenewingOver region t f := by
  constructor
  · intro ⟨active, kept⟩
    exact ⟨active, fun c inside part g req => kept (.inr c) inside part (.inl g) req⟩
  · intro ⟨active, kept⟩
    refine ⟨active, fun y inside part z req => ?_⟩
    cases y with
    | inl _ => exact False.elim (Or.elim part (fun h => h) (fun h => h))
    | inr c =>
      cases z with
      | inl g => exact kept c inside part g req
      | inr _ => exact False.elim req

/-- **The row `Web.renewingAt_iff_over_all` at the occurrence model of the one-kind reading**: renewal
at a step is renewal over the region of every condition, an inclusion in the kept relation. -/
theorem renewingAt_reading {F C : Type} (W : Web F C) (t : Nat) (f : F) :
    W.RenewingAt t f ↔ activeAt W.roles (t, .inl f) ∧
      «则» («而» (Web.partialIdentity fun y =>
          participating W.roles (t, .inl f) y ∧ onConditions (fun _ => True) y.2) («逆» (requiring W.roles)))
        (keptAcross W.roles) :=
  W.renewingAt_iff_over_all.trans ((roles_renewingOver W (fun _ => True) t f).symm.trans
    (renewingOver_iff W.roles (onConditions fun _ => True) t (.inl f)))

/-- **The row `Web.roles_alive` at the occurrence model of the one-kind reading.** -/
theorem roles_alive_reading {F C : Type} (W : Web F C) (t : Nat) (f : F) :
    (W.active t f ∧ ¬ W.UnderminingAt t f) ↔ activeAt W.roles (t, .inl f) ∧
      ¬ «能» («而» (drawing W.roles) («合» («逆» (requiring W.roles)) (lostAcross W.roles))) (t, .inl f) :=
  (W.roles_alive t f).symm.trans (living_iff W.roles t (.inl f))

/-- **The row `Web.transmits_at_iff` at the occurrence model of the one-kind reading**: a two-kind
web's transmission at a descent is its one-kind reading's two inclusions. -/
theorem transmits_at_reading {F C : Type} (W : Web F C) (t : Nat) (x g : F) (c : C) (δ : Nat) :
    (W.requires (t + 1) x c → W.requires t g c ∧ W.need (t + 1) x c ≤ W.need t g c + δ) ↔
      «则» («而» («而» («逆» (descentAt t (.inl x) (.inl g)))
            («而» (requiring W.roles) (Web.partialIdentity fun w => w.2 = .inr c))) («逆» Steps.along))
          (requiring W.roles) ∧
        «则» («合» (descentAt t (.inl x) (.inl g)) fun u v =>
            requiringOf W.roles (.inr c) u ∧ requiringOf W.roles (.inr c) v)
          (needWithin W.roles δ (.inr c)) :=
  transmits_at_one_kind W.roles t (.inl x) (.inl g) (.inr c) δ

/-! ## N_rel as a closure, and its one-step rows -/

/-- **Relational neutrality (N_rel) is significance from each position closed under the formed
relation into living content.** -/
theorem neutral_transmits_iff {Pos C : Type} (V : Valuation Pos C) :
    Neutral V.transmits ↔ ∀ p, «闭» («合» V.related fun _ d => V.living d) (V.sig p) :=
  ⟨fun neutral p c d held ⟨related, alive⟩ => neutral (p, c, d) held related alive,
   fun closed ⟨p, c, d⟩ held related alive => closed p c d held ⟨related, alive⟩⟩

/-- **The row `Web.living_on_reaches` on the grammar**: one step of that closure, along living on a
relatum. -/
theorem living_on_reaches_reading {X Pos : Type} {W : Web X X} {own sig : Pos → X × Nat → Prop}
    (closed : ∀ p, «闭» («合» (W.sustenance own sig).related fun _ d => (W.sustenance own sig).living d)
      ((W.sustenance own sig).sig p))
    {p : Pos} {e d : X × Nat} (lives : W.LivesOn e d) (held : (W.sustenance own sig).sig p e)
    (alive : (W.sustenance own sig).living d) : (W.sustenance own sig).sig p d :=
  Web.living_on_reaches ((neutral_transmits_iff _).mpr closed) lives held alive

/-- **The row `Flow.descent_reaches` on the grammar**: the same along descent. -/
theorem descent_reaches_reading {X Pos : Type} {L : Flow X X} {W : Web X X} {own sig : Pos → X × Nat → Prop}
    (closed : ∀ p, «闭» («合» (L.descent W own sig).related fun _ d => (L.descent W own sig).living d)
      ((L.descent W own sig).sig p))
    {p : Pos} {x g : X} (descends : L.Descends W x g) {t s : Nat} (held : (L.descent W own sig).sig p (g, t))
    (alive : (L.descent W own sig).living (x, s)) : (L.descent W own sig).sig p (x, s) :=
  Flow.descent_reaches ((neutral_transmits_iff _).mpr closed) descends held alive

/-! ## A selection through the data -/

/-- **A selection through a relation of being alike is its region closed both ways along it.** -/
theorem through_iff {Y : Type u} {alike : Y → Y → Prop} {select : Y → Prop} :
    Learning.Training.Through alike select ↔ «闭» alike select ∧ «闭» («逆» alike) select :=
  ⟨fun through => ⟨fun x x' held same => (through x x' same).mp held,
     fun x' x held same => (through x x' same).mpr held⟩,
   fun ⟨forward, back⟩ x x' same => ⟨fun held => forward x x' held same, fun held => back x' x held same⟩⟩

/-- **The row `Learning.Training.unselected_beyond_data` on the grammar**: with the selection closed
both ways along agreeing on the data, the untried value is as free as the class leaves it. The row's
proof uses the closure back along agreement only. -/
theorem unselected_beyond_data_reading {I : Type u} {V : Type v} {C : (I → V) → Prop} {D : I → Prop} {x : I}
    {select : (I → V) → Prop}
    (closed : «闭» (Learning.Training.AgreeOn D) select ∧ «闭» («逆» (Learning.Training.AgreeOn D)) select)
    (free : Learning.Free C D x) {g g' : I → V} (member : C g) (member' : C g') (chosen : select g) :
    ∃ h, C h ∧ select h ∧ Learning.Training.AgreeOn D h g ∧ h x = g' x :=
  Learning.Training.unselected_beyond_data (through_iff.mpr closed) free member member' chosen

/-! ## A record fixing an outcome, read on relations indexed by moves -/

section Fixing

variable {S : Type u} {A : Type v} {P : Process S A}

/-- **The record up to `t` fixes `a`'s outcome at `s` exactly where every family of relations indexed
by moves, each with a fixed successor and holding the run's steps before `t`, relates `s` by `a` only
to `u`.** -/
theorem fixes_iff (r : Run P) (t : Nat) (s : S) (a : A) (u : S) :
    r.Fixes t s a u ↔ ∀ G : A → «际» S, (∀ b, «定后» (G b)) →
      (∀ n, n < t → G (r.act n) (r.state n) (r.state (n + 1))) → ∀ u', G a s u' → u' = u :=
  ⟨fun fixes G fixed steps u' rel =>
     fixes ⟨fun x b y => G b x y⟩ (determined_iff_fixed.mpr fixed) steps u' rel,
   fun fixes Q determined steps u' step => fixes (moveRel Q) (determined_iff_fixed.mp determined) steps u' step⟩

/-- **The row `Run.not_fixes_of_untaken` on relations indexed by moves**: a move not taken is related by
no record to one outcome. -/
theorem not_fixes_reading (determined : ∀ b, «定后» (moveRel P b)) (r : Run P) {t : Nat} {s : S} {b : A}
    (untaken : ¬ r.Takes t s b) {x y : S} (two : x ≠ y) :
    ¬ ∃ u, ∀ G : A → «际» S, (∀ b, «定后» (G b)) →
      (∀ n, n < t → G (r.act n) (r.state n) (r.state (n + 1))) → ∀ u', G b s u' → u' = u :=
  fun ⟨u, fixes⟩ => Run.not_fixes_of_untaken (determined_iff_fixed.mpr determined) r untaken two
    ⟨u, (fixes_iff r t s b u).mpr fixes⟩

end Fixing

/-! ## Joint difference-making at a process's model -/

section Joint

variable {S : Type u} {A : Type v} {F C : Type} (K : Dependence S F C)

/-- The change from `s` to `t` breaks `g`'s dependence on `c`, read as a relation on configurations
from the dependence's amounts. -/
def breaking (g : F) (c : C) : «际» S := fun s t => K.Breaks s t g c

/-- The change from `s` to `t` keeps it. -/
def keeping (g : F) (c : C) : «际» S := fun s t => K.Keeps s t g c

/-- **A move breaks a dependence where its relation meets the breaking**: «能» at the meet. -/
theorem breaksBy_iff {P : Process S A} {s : S} {a : A} {g : F} {c : C} :
    K.BreaksBy P s a g c ↔ «能» («合» (moveRel P a) (breaking K g c)) s :=
  Iff.rfl

/-- **The row `Dependence.Overdetermined.only_together` at the model**: an overdetermined loss is the
breaking met from the configuration and from each withholding of it. -/
theorem overdetermined_iff {P : Process S A} {withhold : F → S → S} {s : S} {a : A} {g : F} {c : C} :
    K.Overdetermined P withhold s a g c ↔
      «能» («合» (moveRel P a) (breaking K g c)) s ∧ ∀ f, «能» («合» (moveRel P a) (breaking K g c)) (withhold f s) :=
  Iff.rfl

/-- **The row `Dependence.Overdetermined.only_together` at the model**: where the breaking is met from
the configuration and from each withholding, every set of parts whose withholding keeps the
dependence and that makes the difference together makes it only together. -/
theorem only_together_reading {P : Process S A} {withhold : F → S → S} {fs : List F} {s : S} {a : A}
    {g : F} {c : C}
    (over : «能» («合» (moveRel P a) (breaking K g c)) s ∧
      ∀ f, «能» («合» (moveRel P a) (breaking K g c)) (withhold f s))
    (together : K.MakesDifferenceTogether P withhold fs s a g c) :
    K.DifferenceOnlyTogether P withhold fs s a g c :=
  Dependence.Overdetermined.only_together (K := K) ((overdetermined_iff K).mpr over) together

/-- **The row `Dependence.differenceOnlyTogether_iff` at a process's model**: with each move's relation
fixing its successor (`«定后»`, for `Determined`), the parts make the difference only together exactly
where together they do and each one's withholding leaves the same move's relation meeting the
breaking. -/
theorem differenceOnlyTogether_reading {P : Process S A} (fixed : ∀ b, «定后» (moveRel P b))
    {withhold : F → S → S} {fs : List F} {s : S} {a : A} {g : F} {c : C}
    (available : ∀ f, f ∈ fs → «能» (moveRel P a) (withhold f s))
    (depends : ∀ f, f ∈ fs → K.requires (withhold f s) g c)
    (met : ∀ f, f ∈ fs → K.need (withhold f s) g c ≤ K.level (withhold f s) c) :
    K.DifferenceOnlyTogether P withhold fs s a g c ↔
      K.MakesDifferenceTogether P withhold fs s a g c ∧
        ∀ f, f ∈ fs → «能» («合» (moveRel P a) (breaking K g c)) (withhold f s) :=
  K.differenceOnlyTogether_iff (determined_iff_fixed.mpr fixed) available depends met

end Joint

/-! ## Copying from an origin: passing through the hearings' copying relations -/

section Copying

variable {I : Type u} {M : Type v} [DecidableEq I] [DecidableEq M]

/-- In a hearing, at a sense, the copying relation: `j`'s form before the hearing is what `i` holds
after it. It is read from who hears whom at which sense. -/
def copies (m : M) (e : SharedCodes.Hearing I M) : «际» I := fun j i => SharedCodes.back m e i = j

/-- **A formation's origin after a word of hearings is what passes into it through the word's copying
relations in turn** (`«历»`). -/
theorem origin_iff_li (m : M) : ∀ (es : List (SharedCodes.Hearing I M)) (i j : I),
    SharedCodes.origin m es i = j ↔ «历» (copies m) es j i
  | [], _, _ => ⟨Eq.symm, Eq.symm⟩
  | e :: es, i, _ =>
    ⟨fun same => ⟨SharedCodes.origin m es i, same, (origin_iff_li m es i _).mp rfl⟩,
     fun ⟨y, step, rest⟩ => (congrArg (SharedCodes.back m e) ((origin_iff_li m es i y).mpr rest)).trans step⟩

/-- **The row `SharedCodes.run_agrees_every_start_iff` on the grammar**: where two forms differ, the
runs of the hearings `acts` agree at `m` at step `k` from every start exactly where every two
formations are reached from one formation through the first `k` hearings' copying relations in turn. -/
theorem run_agrees_every_start_reading {F : Type w} {a b : F} (apart : a ≠ b)
    (acts : Nat → SharedCodes.Hearing I M) (k : Nat) (m : M) :
    (∀ r : Run (SharedCodes.process (I := I) (M := M) (F := F) SharedCodes.always),
        (∀ t, r.act t = acts t) → ∀ i j, r.state k i m = r.state k j m) ↔
      ∀ i j, «而» («逆» («历» (copies m) (SharedCodes.hearings acts 0 k)))
        («历» (copies m) (SharedCodes.hearings acts 0 k)) i j :=
  (SharedCodes.run_agrees_every_start_iff apart acts k m).trans
    ⟨fun one i j => ⟨SharedCodes.origin m (SharedCodes.hearings acts 0 k) i,
        (origin_iff_li m _ i _).mp rfl, (origin_iff_li m _ j _).mp (one i j).symm⟩,
     fun shared i j => match shared i j with
       | ⟨o, from_i, from_j⟩ =>
         ((origin_iff_li m _ i o).mpr from_i).trans ((origin_iff_li m _ j o).mpr from_j).symm⟩

end Copying

/-! ## A finite reading, on the carrier of runs -/

/-- **The row `Renewable.no_exact_finite_reading` on the grammar**: no region of runs closed under
agreeing up to `h` is the region of runs in which the focal formation renews. -/
theorem no_exact_finite_reading_reading (h : Nat) :
    ∀ reading : Run Renewable.process → Prop, «闭» (fun r r' => r.AgreeUpTo h r') reading →
      ¬ ∀ r, reading r ↔ (Renewable.conditions.dependence.along r).RenewingIn .focal :=
  fun reading closed => Renewable.no_exact_finite_reading h reading
    fun r r' agree held => closed r r' held agree

/-- **That is one statement of closure**: the region of renewing runs is not closed under agreeing
up to `h`. -/
theorem no_exact_finite_reading_iff (h : Nat) :
    (∀ reading : Run Renewable.process → Prop, «闭» (fun r r' => r.AgreeUpTo h r') reading →
        ¬ ∀ r, reading r ↔ (Renewable.conditions.dependence.along r).RenewingIn .focal) ↔
      ¬ «闭» (fun r r' : Run Renewable.process => r.AgreeUpTo h r')
        (fun r => (Renewable.conditions.dependence.along r).RenewingIn .focal) :=
  ⟨fun none closed => none _ closed fun _ => Iff.rfl,
   fun not_closed _ closed exact => not_closed fun r r' renews agree =>
     (exact r').mp (closed r r' ((exact r).mpr renews) agree)⟩

/-! ## Living significance as inclusions of regions

A region of claims is held as its partial identity (`Web.partialIdentity`), as WRT2 holds activity,
standing and presence. -/

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

/-- **The row `Valuation.significant_iff_held` on the grammar**: where living lies within the own
regions together, living lies within every position's significance exactly where each position's own
living lies within its significance and what is living and significant from one position lies within
every other's. -/
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

end Valuations

section Retaining

variable {F C Pos : Type} (W : Web F C)

/-- What has significance from `p`, as a partial identity on (step, formation) pairs, the carrier
on which `Web.admitted` reads admission. -/
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

/-- **The row `Web.significance_undetermined` on the grammar**: with the empty region of
significance, what one level path admits with significance lies within what every other admits and
exceeds nothing; with the full region, living lies within significance; with the empty region, it
does not, where an event lives. Significance is a region the represented dynamics leave free. -/
theorem significance_undetermined_reading (own : Pos → F × Nat → Prop) (p : Pos) {e : F × Nat}
    (alive : W.active e.2 e.1 ∧ ¬ W.UnderminingAt e.2 e.1) :
    (∀ l l' : Nat → C → Nat,
        «则» («合» (significantAt (fun _ _ _ => False) p) (W.admitted l')) (W.admitted l) ∧
        ¬ «逾» («合» (significantAt (fun _ _ _ => False) p) (W.admitted l)) (W.admitted l')) ∧
      (∀ q, «则» (Web.partialIdentity (W.valuation own fun _ _ => True).living)
        (Web.partialIdentity ((W.valuation own fun _ _ => True).sig q))) ∧
      ¬ ∀ q, «则» (Web.partialIdentity (W.valuation own fun _ _ => False).living)
        (Web.partialIdentity ((W.valuation own fun _ _ => False).sig q)) :=
  match W.significance_undetermined own p alive with
  | ⟨paths, full, empty⟩ =>
    ⟨fun l l' => ⟨(retains_iff W _ p l l').mp (paths l l').1,
        fun adds => (paths l l').2 ((adds_iff W _ p l l').mpr adds)⟩,
     (significant_iff_reading _).mp full,
     fun inside => empty ((significant_iff_reading _).mpr inside)⟩

end Retaining

/-! ## Coupling bounds response: an inclusion of relations on histories -/

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

/-- **The row `ExchangeLaw.response_not_fixed_by_coupling` on the grammar**: where `g` couples `l`
and `l'` apart up to `t`, some law whose exchanging alike contains every formation's coupling class
does not relate them by what `g` takes from `c`, and some such law's exchanging alike is the full
relation (`«一»`) at every step. -/
theorem response_not_fixed_reading {W : Web F C} {obs : F → C → Prop} {l l' : Nat → C → Nat}
    {t : Nat} (decided : ∀ h t m, Decidable (W.AlikeThroughUpTo obs h l m t)) {g : F} (c : C)
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

/-! ## What a finite stretch verifies, on one carrier of points and stretches -/

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

/-- **The row `Ideals.verifiableBy_iff_interior` on the grammar**: a reading is verifiable exactly
where every point it holds bears membership to such a stretch. -/
theorem verifiableBy_reading {ι : X → Ideals.Ideal P} {K : X → Prop} :
    Ideals.VerifiableBy ι K ↔
      ∀ x, K x → «能» («合» (member ι) fun _ v => «承» (member ι) (onPoints (α := α) K) v) (.inl x) :=
  Ideals.verifiableBy_iff_interior.trans
    ⟨fun all x held => interiorBy_iff.mp (all x held), fun all x held => interiorBy_iff.mpr (all x held)⟩

end Verifying

end U2Check

end Becoming
