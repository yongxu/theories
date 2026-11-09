import Becoming.Prelude
import Becoming.GrammarLaws
import GenerativeCore

/-!
# The Becoming spine: one frame for the whole unfolding

The core `Generative.Process` declares admissible changes of configuration. A
`Frame` adds one thing: which claims are realized at each configuration. Claims
describe differentiated realizations and their relations, not independent owners.
Which claims count as living and further generation, as basic conditions or as
significant is not part of the frame; such readings and premises are stated over
it in later layers. Evaluation therefore has no world model of its own.

This module supplies the combinators that ethics and dynamics modules repeatedly
rebuilt: infinite runs, the closure of a relation, reachability, invariants and new
realization. Runs, reachability and invariants are defined through the core `Trace`, so
results compose with the core's composition, product and transport theorems. Every
declaration has an empty axiom report.

**One closure, the grammar's.** A region is closed under a relation when whatever a member bears
the relation to is a member (`ClosedUnder`); one element lies within another's closure when every
closed region holding the other holds it (`WithinClosure`). Both are the grammar's, at the
relation: `ClosedUnder rel` is `«闭» rel` and `WithinClosure rel` is `«所闭» rel` of
`Becoming.GrammarLaws`, by definition (`closedUnder_iff_closed`, `withinClosure_iff_within`), and
their laws here are the grammar's closure laws at the relation. The closure is reflexive and
transitive, grows with the relation, is symmetric under a symmetric relation, and nothing
within it bears the relation to what lies beyond it (`WithinClosure.refl`,
`WithinClosure.trans`, `WithinClosure.mono`, `WithinClosure.symm`, `WithinClosure.not_rel`).
A region is an element's closure exactly when it holds the element, is closed and lies within
the closure (`closure_iff_certified`). An element *returns* along a relation where whatever lies
within its closure has it within its own (`ReturnsAlong`); its closure is then its loop, and one
returning element whose closure is the whole makes every closure the whole (`ReturnsAlong.loop`,
`ReturnsAlong.whole`). A group's closure is the union of its members' closures
(`WithinClosureOf`). A process's reach is the closure of its steps
(`reach_iff_withinClosure`), and an invariant is a region closed under them
(`invariant_iff_closedUnder`), so what holds where a process starts and is kept by its steps
holds wherever it reaches because the closure is closed (`Invariant.reach`). The closures of
the later layers, under feeding, influence, reach, sharing, coupling and pooled coupling, and
the scope a presupposition reaches, are this closure under their relations. `ClosedUnder`,
`WithinClosure` and their laws moved here unchanged, with their names, from
`Becoming.Feedback`, and `WithinClosureOf` from `Becoming.Selection`, now defined as the union it
was proved to be (board item EC1, 21 October 2026), all stated for elements of any type. `ReturnsAlong`
and its three laws moved here, with their names, from `Becoming.FlowCenters` (route (b)'s join,
9 November 2026), and `Flow.ReachReturns` of `Becoming.Centers` is its case along affecting.
-/

namespace Becoming

open Generative

universe u v w

/-- One unfolding: a declared process and the claims realized at each configuration. -/
structure Frame (S : Type u) (A : Type v) (C : Type w) where
  P : Process S A
  realized : S → C → Prop

variable {S : Type u} {A : Type v} {C : Type w}

/-! ## Runs -/

/-- An infinite execution: every successive configuration is an admissible step. -/
structure Run (P : Process S A) where
  state : Nat → S
  act : Nat → A
  step : ∀ n, P.step (state n) (act n) (state (n + 1))

/-- The `k` actions of a run from time `n`. -/
def Run.window {P : Process S A} (r : Run P) : Nat → Nat → List A
  | _, 0 => []
  | n, k + 1 => r.act n :: r.window (n + 1) k

/-- Every finite window of a run is a core trace. -/
theorem Run.window_trace {P : Process S A} (r : Run P) :
    ∀ k n, Trace P (r.state n) (r.window n k) (r.state (n + k))
  | 0, n => .nil _
  | k + 1, n => by
    have shift : n + 1 + k = n + (k + 1) := (Nat.succ_add n k).trans (Nat.add_succ n k).symm
    exact .cons (r.step n) (shift ▸ Run.window_trace r k (n + 1))

/-! ## Closure -/

/-- A region is closed under a relation: whatever a member bears the relation to is a member. It
is the grammar's closed region `«闭»` at the relation. -/
def ClosedUnder {X : Type u} (rel : X → X → Prop) (region : X → Prop) : Prop :=
  «闭» rel region

/-- `g` lies within `f`'s closure under a relation: every region closed under it that holds `f`
holds `g`. It is the grammar's closure `«所闭»` at the relation. -/
def WithinClosure {X : Type u} (rel : X → X → Prop) (f g : X) : Prop :=
  «所闭» rel f g

/-- A region closed under a relation is the grammar's closed region, by definition. -/
theorem closedUnder_iff_closed {X : Type u} {rel : X → X → Prop} {region : X → Prop} :
    ClosedUnder rel region ↔ «闭» rel region :=
  Iff.rfl

/-- Lying within a closure is the grammar's, by definition. -/
theorem withinClosure_iff_within {X : Type u} {rel : X → X → Prop} {f g : X} :
    WithinClosure rel f g ↔ «所闭» rel f g :=
  Iff.rfl

namespace WithinClosure

variable {X : Type u} {rel rel' : X → X → Prop}

/-- An element lies within its own closure (`«所闭之自反»`). -/
theorem refl (f : X) : WithinClosure rel f f :=
  «所闭之自反» rel f

/-- A closure is transitive (`«所闭之传递»`). -/
theorem trans {f g h : X} (first : WithinClosure rel f g) (second : WithinClosure rel g h) :
    WithinClosure rel f h :=
  «所闭之传递» first second

/-- What an element bears the relation to lies within its closure (`«缘在所闭»`). -/
theorem of_rel {f g : X} (related : rel f g) : WithinClosure rel f g :=
  «缘在所闭» related

/-- A larger relation has a larger closure (`«所闭之单调»`). -/
theorem mono (larger : ∀ g h, rel g h → rel' g h) {f g : X} (within : WithinClosure rel f g) :
    WithinClosure rel' f g :=
  «所闭之单调» larger f g within

/-- Under a symmetric relation the closure is symmetric (`«所闭之对称»`). -/
theorem symm (symmetric : ∀ g h, rel g h → rel h g) {f g : X} (within : WithinClosure rel f g) :
    WithinClosure rel g f :=
  «所闭之对称» symmetric f g within

/-- Nothing within a closure bears the relation to what lies beyond it (`«所闭之界»`). -/
theorem not_rel {f g h : X} (within : WithinClosure rel f g) (beyond : ¬ WithinClosure rel f h) :
    ¬ rel g h :=
  «所闭之界» within beyond

end WithinClosure

/-- An element's closure is closed under the relation (`«所闭之闭»`). -/
theorem closedUnder_withinClosure {X : Type u} {rel : X → X → Prop} (f : X) :
    ClosedUnder rel (WithinClosure rel f) :=
  «所闭之闭» rel f

/-- **A certificate of a closure.** A region is an element's closure exactly when it holds the
element, is closed under the relation and lies within the element's closure: what the region
holds is reached, and nothing reached leaves it (`«所闭之证»`). -/
theorem closure_iff_certified {X : Type u} {rel : X → X → Prop} {region : X → Prop} {f : X} :
    (∀ g, region g ↔ WithinClosure rel f g) ↔
      region f ∧ ClosedUnder rel region ∧ ∀ g, region g → WithinClosure rel f g :=
  «所闭之证»

/-- **Certified regions apart are closures apart.** Where a closed region holds `f` but not `g`,
`g` is not within `f`'s closure (`«闭而外则不所闭»`). -/
theorem not_within_of_closed {X : Type u} {rel : X → X → Prop} {region : X → Prop} {f g : X}
    (closed : ClosedUnder rel region) (holds : region f) (outside : ¬ region g) :
    ¬ WithinClosure rel f g :=
  «闭而外则不所闭» closed holds outside

/-- `c` *returns* along a relation: whatever lies within its closure has `c` within its own
closure. Along affecting this is `Flow.ReachReturns`: whatever a formation can affect can affect
it. -/
def ReturnsAlong {X : Type u} (rel : X → X → Prop) (c : X) : Prop :=
  ∀ g, WithinClosure rel c g → WithinClosure rel g c

/-- A returning element's own closure is its loop: what lies within it has the element within its
own closure. -/
theorem ReturnsAlong.loop {X : Type u} {rel : X → X → Prop} {c g : X} (returns : ReturnsAlong rel c)
    (within : WithinClosure rel c g) : WithinClosure rel c g ∧ WithinClosure rel g c :=
  ⟨within, returns g within⟩

/-- Where every closure is the whole, every element returns. -/
theorem returnsAlong_of_whole {X : Type u} {rel : X → X → Prop}
    (whole : ∀ f g, WithinClosure rel f g) (c : X) : ReturnsAlong rel c :=
  fun g _ => whole g c

/-- **One returning element whose closure is the whole makes every closure the whole.** -/
theorem ReturnsAlong.whole {X : Type u} {rel : X → X → Prop} {c : X} (returns : ReturnsAlong rel c)
    (whole : ∀ g, WithinClosure rel c g) : ∀ f g, WithinClosure rel f g :=
  fun f g => (returns f (whole f)).trans (whole g)

/-- `g` lies within a group's closure under a relation: within some member's closure. -/
def WithinClosureOf {X : Type u} (rel : X → X → Prop) (group : X → Prop) (g : X) : Prop :=
  ∃ f, group f ∧ WithinClosure rel f g

/-- **A group's closure is the union of its members' closures**, by definition. -/
theorem withinClosureOf_iff {X : Type u} {rel : X → X → Prop} {group : X → Prop} {g : X} :
    WithinClosureOf rel group g ↔ ∃ f, group f ∧ WithinClosure rel f g :=
  Iff.rfl

/-- What lies within a member's closure lies within the group's. -/
theorem WithinClosureOf.of_member {X : Type u} {rel : X → X → Prop} {group : X → Prop} {f g : X}
    (member : group f) (within : WithinClosure rel f g) : WithinClosureOf rel group g :=
  ⟨f, member, within⟩

/-- A group's closure lies in every region closed under the relation that holds every member: it
is the least such region. -/
theorem WithinClosureOf.least {X : Type u} {rel : X → X → Prop} {group : X → Prop} {g : X}
    (within : WithinClosureOf rel group g) (region : X → Prop) (closed : ClosedUnder rel region)
    (holds : ∀ f, group f → region f) : region g :=
  match within with
  | ⟨f, member, inside⟩ => inside region closed (holds f member)

/-- A group's closure is closed under the relation. -/
theorem closedUnder_withinClosureOf {X : Type u} {rel : X → X → Prop} {group : X → Prop} :
    ClosedUnder rel (WithinClosureOf rel group) :=
  fun _ _ ⟨f, member, within⟩ related => ⟨f, member, within.trans (WithinClosure.of_rel related)⟩

/-- The closure of the group holding one element is that element's closure. -/
theorem withinClosureOf_single {X : Type u} {rel : X → X → Prop} {f g : X} :
    WithinClosureOf rel (fun x => x = f) g ↔ WithinClosure rel f g :=
  ⟨fun ⟨_, same, within⟩ => same ▸ within, fun within => ⟨f, rfl, within⟩⟩

/-! ## Reachability -/

/-- Some finite admissible path leads from `s` to `t`. -/
def Reach (P : Process S A) (s t : S) : Prop := ∃ as, Trace P s as t

theorem Reach.refl (P : Process S A) (s : S) : Reach P s s := ⟨[], .nil s⟩

theorem Reach.of_step {P : Process S A} {s t : S} {a : A} (h : P.step s a t) : Reach P s t :=
  ⟨[a], .cons h (.nil t)⟩

theorem Reach.trans {P : Process S A} {s m t : S} :
    Reach P s m → Reach P m t → Reach P s t
  | ⟨xs, hx⟩, ⟨ys, hy⟩ => ⟨xs ++ ys, trace_append_iff.mpr ⟨m, hx, hy⟩⟩

/-- A step-preserving map carries reachability (core `trace_map`). -/
theorem Reach.map {S' : Type u} {P : Process S A} {Q : Process S' A} {f : S → S'}
    (preserve : ∀ s a t, P.step s a t → Q.step (f s) a (f t)) {s t : S} :
    Reach P s t → Reach Q (f s) (f t)
  | ⟨as, h⟩ => ⟨as, trace_map preserve h⟩

/-- A summary whose steps lift from every concrete configuration reflects
reachability (core `trace_lift`). -/
theorem Reach.lift {S' : Type u} {P : Process S A} {Q : Process S' A} {q : S → S'}
    (lift : ∀ s a r, Q.step (q s) a r → ∃ t, P.step s a t ∧ q t = r) {s : S} {r : S'} :
    Reach Q (q s) r → ∃ t, Reach P s t ∧ q t = r
  | ⟨_, h⟩ => match trace_lift lift h with
    | ⟨t, path, same⟩ => ⟨t, ⟨_, path⟩, same⟩

/-- One step of a process, whatever its action. -/
def Steps (P : Process S A) (s t : S) : Prop := ∃ a, P.step s a t

/-- The end of a core trace lies within its start's closure under the steps. -/
theorem withinClosure_of_trace {P : Process S A} :
    ∀ {s : S} {as : List A} {t : S}, Trace P s as t → WithinClosure (Steps P) s t
  | _, _, _, .nil x => WithinClosure.refl x
  | _, _, _, .cons step rest => (WithinClosure.of_rel ⟨_, step⟩).trans (withinClosure_of_trace rest)

/-- **Reach is the closure of the steps.** A configuration is reached from another exactly
when it lies within the other's closure under one step of the process. -/
theorem reach_iff_withinClosure {P : Process S A} {s t : S} :
    Reach P s t ↔ WithinClosure (Steps P) s t :=
  ⟨fun ⟨_, path⟩ => withinClosure_of_trace path,
   fun within => within (Reach P s) (fun _ _ reached ⟨_, step⟩ => reached.trans (.of_step step))
     (Reach.refl P s)⟩

/-- A run reaches every later configuration from every earlier one. -/
theorem Run.reach {P : Process S A} (r : Run P) (n k : Nat) :
    Reach P (r.state n) (r.state (n + k)) :=
  ⟨r.window n k, r.window_trace k n⟩

/-! ## Invariants -/

/-- A property preserved by every admissible step. -/
def Invariant (P : Process S A) (I : S → Prop) : Prop :=
  ∀ s a t, P.step s a t → I s → I t

theorem Invariant.trace {P : Process S A} {I : S → Prop} (inv : Invariant P I)
    {s t : S} {as : List A} (h : Trace P s as t) : I s → I t := by
  induction h with
  | nil => exact id
  | cons step _ ih => exact fun held => ih (inv _ _ _ step held)

/-- An invariant is a region closed under the steps. -/
theorem invariant_iff_closedUnder {P : Process S A} {I : S → Prop} :
    Invariant P I ↔ ClosedUnder (Steps P) I :=
  ⟨fun inv s t held ⟨a, step⟩ => inv s a t step held,
   fun closed s a t step held => closed s t held ⟨a, step⟩⟩

/-- What holds where a process starts and is kept by its steps holds wherever it reaches: the
closure of the steps is closed. -/
theorem Invariant.reach {P : Process S A} {I : S → Prop} (inv : Invariant P I)
    {s t : S} (reached : Reach P s t) : I s → I t :=
  reach_iff_withinClosure.mp reached I (invariant_iff_closedUnder.mp inv)

theorem Invariant.run {P : Process S A} {I : S → Prop} (inv : Invariant P I)
    (r : Run P) (start : I (r.state 0)) : ∀ n, I (r.state n)
  | 0 => start
  | n + 1 => inv _ _ _ (r.step n) (inv.run r start n)

/-! ## New realization -/

/-- A claim of the given reading realized at `t` and not recorded as realized
before. Following the core convention, the configuration retains whatever history
the question needs, so `before` is an observable of the configuration itself. -/
def Novel (F : Frame S A C) (reading : C → Prop) (before : S → C → Prop) (t : S) : Prop :=
  ∃ c, reading c ∧ F.realized t c ∧ ¬ before t c

/-- Novelty is monotone in the reading. -/
theorem Novel.mono {F : Frame S A C} {reading reading' : C → Prop} {before : S → C → Prop}
    {t : S} (sub : ∀ c, reading c → reading' c) : Novel F reading before t → Novel F reading' before t
  | ⟨c, read, real, fresh⟩ => ⟨c, sub c read, real, fresh⟩

end Becoming
