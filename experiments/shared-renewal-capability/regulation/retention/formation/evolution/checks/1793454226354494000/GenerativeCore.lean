import Std

/-!
# A relational core for generative dynamics

This file formalizes discrete, action-labelled admissibility. A state records the
conditions relevant to the declared transitions; a transition may change those
conditions and hence the available continuations. Neither observation by an
agent, probability, learning, significance, nor a favourable direction is
entailed by this semantic interface. Concrete mechanisms must supply them.

The substantive structural results are exact composition through an actual
intermediate state, conjunction of synchronized component constraints, and
transport under a faithful change of state representation. No common objective,
external selector, finite-state assumption, or scalar value is imposed.
-/

namespace Generative

universe u v w

/-- A declared relation of admissible actions and state changes. -/
structure Process (State : Type u) (Action : Type v) where
  step : State → Action → State → Prop

/-- Existential admissibility, not probability or ability under partial observation. -/
def Enabled {State : Type u} {Action : Type v}
    (P : Process State Action) (s : State) (a : Action) : Prop :=
  ∃ t, P.step s a t

/-- A finite path carries every intermediate state rather than resetting conditions. -/
inductive Trace {State : Type u} {Action : Type v}
    (P : Process State Action) : State → List Action → State → Prop where
  | nil (s : State) : Trace P s [] s
  | cons {s m t : State} {a : Action} {as : List Action} :
      P.step s a m → Trace P m as t → Trace P s (a :: as) t

variable {State : Type u} {Action : Type v} {Other : Type w}
variable {P : Process State Action}

theorem trace_nil_iff {s t : State} : Trace P s [] t ↔ s = t := by
  constructor
  · intro h
    cases h
    rfl
  · intro h
    subst t
    exact .nil s

theorem trace_cons_iff {s t : State} {a : Action} {as : List Action} :
    Trace P s (a :: as) t ↔ ∃ m, P.step s a m ∧ Trace P m as t := by
  constructor
  · intro h
    cases h with
    | cons hs ht => exact ⟨_, hs, ht⟩
  · rintro ⟨m, hs, ht⟩
    exact .cons hs ht

theorem trace_singleton_iff {s t : State} {a : Action} :
    Trace P s [a] t ↔ P.step s a t := by
  constructor
  · intro h
    obtain ⟨m, hs, ht⟩ := trace_cons_iff.mp h
    have hmt := trace_nil_iff.mp ht
    subst m
    exact hs
  · intro h
    exact .cons h (.nil t)

/-- Concatenation is possible precisely when the two paths share their actual boundary state. -/
theorem trace_append_iff {s t : State} {xs ys : List Action} :
    Trace P s (xs ++ ys) t ↔ ∃ m, Trace P s xs m ∧ Trace P m ys t := by
  induction xs generalizing s with
  | nil =>
    constructor
    · intro h
      exact ⟨s, .nil s, h⟩
    · rintro ⟨m, hm, ht⟩
      cases hm
      exact ht
  | cons a xs ih =>
    constructor
    · intro h
      obtain ⟨n, hs, ht⟩ := trace_cons_iff.mp h
      obtain ⟨m, hx, hy⟩ := ih.mp ht
      exact ⟨m, .cons hs hx, hy⟩
    · rintro ⟨m, hx, hy⟩
      obtain ⟨n, hs, ht⟩ := trace_cons_iff.mp hx
      exact .cons hs (ih.mpr ⟨m, ht, hy⟩)

theorem enabled_iff_singleton_trace {s : State} {a : Action} :
    Enabled P s a ↔ ∃ t, Trace P s [a] t := by
  constructor
  · rintro ⟨t, h⟩
    exact ⟨t, .cons h (.nil t)⟩
  · rintro ⟨t, h⟩
    obtain ⟨m, hs, _⟩ := trace_cons_iff.mp h
    exact ⟨m, hs⟩

/-- Distinct continuation constraints certify a consequential state distinction. -/
theorem enabled_difference_implies_state_difference {s t : State} {a : Action}
    (hs : Enabled P s a) (ht : ¬ Enabled P t a) : s ≠ t := by
  intro h
  subst t
  exact ht hs

/-- Feasibility refers to at least one path, not to guaranteed or sustainable success. -/
def Feasible (P : Process State Action) (s : State) (as : List Action) : Prop :=
  ∃ t, Trace P s as t

/-- The suffix must be feasible from the state actually reached by its prefix. -/
theorem feasible_append_iff {s : State} {xs ys : List Action} :
    Feasible P s (xs ++ ys) ↔ ∃ m, Trace P s xs m ∧ Feasible P m ys := by
  constructor
  · rintro ⟨t, h⟩
    obtain ⟨m, hx, hy⟩ := trace_append_iff.mp h
    exact ⟨m, hx, t, hy⟩
  · rintro ⟨m, hx, t, hy⟩
    exact ⟨t, trace_append_iff.mpr ⟨m, hx, hy⟩⟩

theorem feasible_prefix {s : State} {xs ys : List Action}
    (h : Feasible P s (xs ++ ys)) : Feasible P s xs := by
  obtain ⟨m, hx, _⟩ := feasible_append_iff.mp h
  exact ⟨m, hx⟩

/-- Synchronized composition retains both states and requires both local constraints.
This is one declared mode of composition, not a claim about all interactions. -/
def productProcess (P : Process State Action) (Q : Process Other Action) :
    Process (State × Other) Action where
  step s a t := P.step s.1 a t.1 ∧ Q.step s.2 a t.2

theorem enabled_product_iff {Q : Process Other Action}
    {s : State} {q : Other} {a : Action} :
    Enabled (productProcess P Q) (s, q) a ↔ Enabled P s a ∧ Enabled Q q a := by
  constructor
  · rintro ⟨⟨t, r⟩, hp, hq⟩
    exact ⟨⟨t, hp⟩, ⟨r, hq⟩⟩
  · rintro ⟨⟨t, hp⟩, ⟨r, hq⟩⟩
    exact ⟨(t, r), hp, hq⟩

theorem trace_product_left {Q : Process Other Action}
    {s t : State × Other} {as : List Action}
    (h : Trace (productProcess P Q) s as t) : Trace P s.1 as t.1 := by
  induction h with
  | nil s => exact .nil s.1
  | cons hstep _ ih => exact .cons hstep.1 ih

theorem trace_product_right {Q : Process Other Action}
    {s t : State × Other} {as : List Action}
    (h : Trace (productProcess P Q) s as t) : Trace Q s.2 as t.2 := by
  induction h with
  | nil s => exact .nil s.2
  | cons hstep _ ih => exact .cons hstep.2 ih

theorem trace_product_mk {Q : Process Other Action}
    {s t : State} {q r : Other} {as : List Action}
    (hp : Trace P s as t) (hq : Trace Q q as r) :
    Trace (productProcess P Q) (s, q) as (t, r) := by
  induction hp generalizing q with
  | nil s =>
    cases hq
    exact .nil _
  | cons hs _ ih =>
    obtain ⟨m, hqm, hmr⟩ := trace_cons_iff.mp hq
    exact .cons ⟨hs, hqm⟩ (ih hmr)

/-- Shared-action paths are exactly the intersection of the two component constraints. -/
theorem trace_product_iff {Q : Process Other Action}
    {s t : State} {q r : Other} {as : List Action} :
    Trace (productProcess P Q) (s, q) as (t, r) ↔
      Trace P s as t ∧ Trace Q q as r := by
  constructor
  · intro h
    exact ⟨trace_product_left h, trace_product_right h⟩
  · rintro ⟨hp, hq⟩
    exact trace_product_mk hp hq

theorem feasible_product_iff {Q : Process Other Action}
    {s : State} {q : Other} {as : List Action} :
    Feasible (productProcess P Q) (s, q) as ↔ Feasible P s as ∧ Feasible Q q as := by
  constructor
  · rintro ⟨⟨t, r⟩, h⟩
    exact ⟨⟨t, trace_product_left h⟩, ⟨r, trace_product_right h⟩⟩
  · rintro ⟨⟨t, hp⟩, ⟨r, hq⟩⟩
    exact ⟨(t, r), trace_product_mk hp hq⟩

/-- A map preserving transitions also preserves declared finite paths. -/
theorem trace_map {Q : Process Other Action} {f : State → Other}
    (hstep : ∀ s a t, P.step s a t → Q.step (f s) a (f t))
    {s t : State} {as : List Action} (h : Trace P s as t) :
    Trace Q (f s) as (f t) := by
  induction h with
  | nil s => exact .nil (f s)
  | cons hs _ ih => exact .cons (hstep _ _ _ hs) ih

/-- Every abstract path can be realized from the specified concrete initial state
if each abstract step lifts from every concrete state in its starting fibre.
This condition is stronger than collecting edges seen in some representative. -/
theorem trace_lift {Q : Process Other Action} {q : State → Other}
    (hlift : ∀ s a r, Q.step (q s) a r → ∃ t, P.step s a t ∧ q t = r)
    {s : State} {r : Other} {as : List Action}
    (h : Trace Q (q s) as r) : ∃ t, Trace P s as t ∧ q t = r := by
  induction as generalizing s with
  | nil =>
    exact ⟨s, .nil s, trace_nil_iff.mp h⟩
  | cons a as ih =>
    obtain ⟨m, hstep, htail⟩ := trace_cons_iff.mp h
    obtain ⟨t, ht, hqt⟩ := hlift s a m hstep
    have tail : Trace Q (q t) as r := by simpa only [hqt] using htail
    obtain ⟨u, hu, hqu⟩ := ih tail
    exact ⟨u, .cons ht hu, hqu⟩

/-- Local preservation and lifting certify exact finite-path representation.
The endpoint equality is essential: lifting need not identify concrete states. -/
theorem projected_trace_iff {Q : Process Other Action} {q : State → Other}
    (hpreserve : ∀ s a t, P.step s a t → Q.step (q s) a (q t))
    (hlift : ∀ s a r, Q.step (q s) a r → ∃ t, P.step s a t ∧ q t = r)
    {s : State} {r : Other} {as : List Action} :
    Trace Q (q s) as r ↔ ∃ t, Trace P s as t ∧ q t = r := by
  constructor
  · exact trace_lift hlift
  · rintro ⟨t, h, hqt⟩
    have projected := trace_map hpreserve h
    simpa only [hqt] using projected

/-- The local obligations are also necessary for this precise finite-path contract.
Thus certification can be reduced to one-step preservation and fibre-wise lifting,
without checking arbitrarily long words one by one. -/
theorem projection_exact_iff {Q : Process Other Action} {q : State → Other} :
    ((∀ s a t, P.step s a t → Q.step (q s) a (q t)) ∧
      (∀ s a r, Q.step (q s) a r → ∃ t, P.step s a t ∧ q t = r)) ↔
    (∀ s as r, Trace Q (q s) as r ↔ ∃ t, Trace P s as t ∧ q t = r) := by
  constructor
  · rintro ⟨hpreserve, hlift⟩ s as r
    exact projected_trace_iff hpreserve hlift
  · intro hexact
    constructor
    · intro s a t h
      have traceQ := (hexact s [a] (q t)).mpr
        ⟨t, trace_singleton_iff.mpr h, rfl⟩
      exact trace_singleton_iff.mp traceQ
    · intro s a r h
      obtain ⟨t, ht, hqt⟩ := (hexact s [a] r).mp (trace_singleton_iff.mpr h)
      exact ⟨t, trace_singleton_iff.mp ht, hqt⟩

/-- Equivalent pointwise form of the exactness criterion: equality of projected
one-step possibilities is equivalent to equality of all projected finite paths. -/
theorem local_exact_iff_trace_exact {Q : Process Other Action} {q : State → Other} :
    (∀ s a r, Q.step (q s) a r ↔ ∃ t, P.step s a t ∧ q t = r) ↔
    (∀ s as r, Trace Q (q s) as r ↔ ∃ t, Trace P s as t ∧ q t = r) := by
  constructor
  · intro hlocal
    apply projection_exact_iff.mp
    constructor
    · intro s a t h
      exact (hlocal s a (q t)).mpr ⟨t, h, rfl⟩
    · intro s a r h
      exact (hlocal s a r).mp h
  · intro hglobal s a r
    constructor
    · intro h
      obtain ⟨t, ht, hqt⟩ := (hglobal s [a] r).mp (trace_singleton_iff.mpr h)
      exact ⟨t, trace_singleton_iff.mp ht, hqt⟩
    · rintro ⟨t, ht, hqt⟩
      exact trace_singleton_iff.mp
        ((hglobal s [a] r).mpr ⟨t, trace_singleton_iff.mpr ht, hqt⟩)

theorem enabled_projection_iff {Q : Process Other Action} {q : State → Other}
    (hpreserve : ∀ s a t, P.step s a t → Q.step (q s) a (q t))
    (hlift : ∀ s a r, Q.step (q s) a r → ∃ t, P.step s a t ∧ q t = r)
    {s : State} {a : Action} :
    Enabled P s a ↔ Enabled Q (q s) a := by
  constructor
  · rintro ⟨t, h⟩
    exact ⟨q t, hpreserve s a t h⟩
  · rintro ⟨r, h⟩
    obtain ⟨t, ht, _⟩ := hlift s a r h
    exact ⟨t, ht⟩

/-- The same obligations preserve all finite action-word capabilities.
No result about probabilities, observable labels, policies or infinite paths
is asserted by this finite existential statement. -/
theorem feasible_projection_iff {Q : Process Other Action} {q : State → Other}
    (hpreserve : ∀ s a t, P.step s a t → Q.step (q s) a (q t))
    (hlift : ∀ s a r, Q.step (q s) a r → ∃ t, P.step s a t ∧ q t = r)
    {s : State} {as : List Action} :
    Feasible P s as ↔ Feasible Q (q s) as := by
  constructor
  · rintro ⟨t, h⟩
    exact ⟨q t, trace_map hpreserve h⟩
  · rintro ⟨r, h⟩
    obtain ⟨t, ht, _⟩ := trace_lift hlift h
    exact ⟨t, ht⟩

/-- Any summary preserving word capabilities must retain distinctions witnessed
by different feasible futures. This is a relative necessity result, not a claim
that all state differences must be observable or retained. -/
theorem feasible_difference_implies_projection_difference
    {Q : Process Other Action} {q : State → Other}
    (hexact : ∀ s as, Feasible P s as ↔ Feasible Q (q s) as)
    {s t : State} {as : List Action}
    (hs : Feasible P s as) (ht : ¬ Feasible P t as) : q s ≠ q t := by
  intro hq
  apply ht
  apply (hexact t as).mpr
  rw [← hq]
  exact (hexact s as).mp hs

/-- When the state map is also injective, corresponding endpoint traces agree. -/
theorem trace_faithful_iff {Q : Process Other Action} {q : State → Other}
    (hpreserve : ∀ s a t, P.step s a t → Q.step (q s) a (q t))
    (hlift : ∀ s a r, Q.step (q s) a r → ∃ t, P.step s a t ∧ q t = r)
    (hinjective : ∀ s t, q s = q t → s = t)
    {s t : State} {as : List Action} :
    Trace P s as t ↔ Trace Q (q s) as (q t) := by
  constructor
  · exact trace_map hpreserve
  · intro h
    obtain ⟨u, hu, hqu⟩ := trace_lift hlift h
    have hut := hinjective u t hqu
    subst u
    exact hu

end Generative

#print axioms Generative.trace_append_iff
#print axioms Generative.trace_singleton_iff
#print axioms Generative.enabled_iff_singleton_trace
#print axioms Generative.enabled_difference_implies_state_difference
#print axioms Generative.feasible_append_iff
#print axioms Generative.feasible_prefix
#print axioms Generative.enabled_product_iff
#print axioms Generative.trace_product_iff
#print axioms Generative.feasible_product_iff
#print axioms Generative.trace_map
#print axioms Generative.trace_lift
#print axioms Generative.projected_trace_iff
#print axioms Generative.projection_exact_iff
#print axioms Generative.local_exact_iff_trace_exact
#print axioms Generative.enabled_projection_iff
#print axioms Generative.feasible_projection_iff
#print axioms Generative.feasible_difference_implies_projection_difference
#print axioms Generative.trace_faithful_iff
