import Becoming.Response
import Becoming.SelectionPool

/-!
# Centers: where what a formation does comes back to it

`Becoming.Feedback` gives a formation's reach closure (what it can affect, at some remove) and its
influence closure (what can affect it), and `Becoming.MutualDependence` reads a flow in which both are
the whole. `Becoming.Latency` showed that the region a formation can represent from what it reads is
drawn along coupling. This module states, for any flow, where the region a formation acts on and the
region it can represent meet, when they coincide, and that formations whose acts come back to them
exist wherever formations are finitely many.

* **One loop.** Two formations lie in one loop where each can affect the other's continuation at some
  remove (`Flow.InOneLoop`): an equivalence (`InOneLoop.refl`, `InOneLoop.symm`, `InOneLoop.trans`),
  so the loops partition the formations. Being in `f`'s reach is being able to be affected by `f`
  (`Flow.withinReach_iff_influence`).
* **Acts that return.** A formation's acts return where whatever it can affect can affect it
  (`Flow.ReachReturns`): exactly where everything it reaches lies in its loop
  (`Flow.reachReturns_iff_loop`), and exactly where its loop is closed under affecting
  (`Flow.reachReturns_iff_closed`). It is a property of the loop: every formation in a loop whose acts
  return has acts that return (`ReachReturns.of_loop`).
* **The region acted on and the region represented.** Where a formation's acts return, everything it
  acts on lies within its coupling closure, what it can represent, for every coupling by level
  (`ReachReturns.represented`). With coupling by threshold only the two coincide exactly
  (`Flow.reachReturns_iff_represented`). Where its acts do not return, some formation it acts on can
  never affect it: the gap for one's own act, at that formation.
* **How a loop forms.** As exchange grows, loops only merge (`InOneLoop.mono`); returning is not
  monotone. In `Line` a acts on b and b does not act back, so a's acts do not return and b's do
  (`Line.open_not_returns`, `Line.open_b_returns`); when b comes to exchange with what a depends on, a
  and b are one loop and a's acts return (`Line.closed_one_loop`, `Line.closed_returns`).
* **Returning loops exist.** With finitely many formations listed and reach decided, every
  formation's reach holds a formation whose acts return (`Flow.exists_reachReturns`): following what
  a formation acts on and does not hear back from, the reach shrinks strictly until it closes.

Premises: the reach and influence closures are read off one flow and one web, through dependence
(`Web.DependsOn`, at some step) and exchange at some step, as in `Becoming.Feedback`; which loop a
formation draws its own region along is not chosen here. Finitely many formations and decided reach
where stated. No Lean axiom is used.
-/

namespace Becoming

variable {F C : Type}

namespace Flow

variable {L L' : Flow F C} {W : Web F C} {obs : F → C → Prop} {f g h : F}

/-- Being within `f`'s reach is `f` being within that formation's influence closure. -/
theorem withinReach_iff_influence : L.WithinReach W f g ↔ L.WithinInfluence W g f :=
  ⟨fun within => WithinClosure.converse.mp within, fun within => WithinClosure.converse.mpr within⟩

/-- **One loop**: each can affect the other's continuation at some remove. -/
def InOneLoop (L : Flow F C) (W : Web F C) (f g : F) : Prop :=
  L.WithinReach W f g ∧ L.WithinReach W g f

theorem InOneLoop.refl (f : F) : L.InOneLoop W f f :=
  ⟨WithinClosure.refl f, WithinClosure.refl f⟩

theorem InOneLoop.symm (one : L.InOneLoop W f g) : L.InOneLoop W g f :=
  ⟨one.2, one.1⟩

theorem InOneLoop.trans (first : L.InOneLoop W f g) (second : L.InOneLoop W g h) :
    L.InOneLoop W f h :=
  ⟨first.1.trans second.1, second.2.trans first.2⟩

/-- **A formation's acts return**: whatever it can affect can affect it. -/
def ReachReturns (L : Flow F C) (W : Web F C) (f : F) : Prop :=
  ∀ g, L.WithinReach W f g → L.WithinReach W g f

theorem reachReturns_iff_loop : L.ReachReturns W f ↔ ∀ g, L.WithinReach W f g → L.InOneLoop W f g :=
  ⟨fun returns g within => ⟨within, returns g within⟩, fun loop g within => (loop g within).2⟩

/-- **Acts return exactly where the loop is closed under affecting.** -/
theorem reachReturns_iff_closed :
    L.ReachReturns W f ↔ ClosedUnder (L.Affects W) (L.InOneLoop W f) :=
  ⟨fun returns _ h one affects =>
     have reached : L.WithinReach W f h := one.1.trans (WithinClosure.of_rel affects)
     ⟨reached, returns h reached⟩,
   fun closed _ within => (within (L.InOneLoop W f) closed (InOneLoop.refl f)).2⟩

/-- Returning is a property of the loop. -/
theorem ReachReturns.of_loop (returns : L.ReachReturns W f) (one : L.InOneLoop W f g) :
    L.ReachReturns W g :=
  fun h within => (returns h (one.1.trans within)).trans one.1

/-- **Where acts return, what is acted on can be represented**: it lies within the coupling
closure, for every coupling by level. -/
theorem ReachReturns.represented (returns : L.ReachReturns W f) (within : L.WithinReach W f g) :
    L.WithinCoupling W obs f g :=
  withinCoupling_of_withinInfluence (withinReach_iff_influence.mp (returns g within))

/-- **With coupling by threshold only, acts return exactly where everything acted on can be
represented.** -/
theorem reachReturns_iff_represented :
    L.ReachReturns W f ↔ ∀ g, L.WithinReach W f g → L.WithinCoupling W thresholdOnly f g :=
  ⟨fun returns _ within => returns.represented within,
   fun represented g within =>
     withinReach_iff_influence.mpr (withinCoupling_thresholdOnly.mp (represented g within))⟩

/-- **Loops only merge as exchange grows.** -/
theorem InOneLoop.mono (more : ∀ h c, L.Exchanges h c → L'.Exchanges h c)
    (one : L.InOneLoop W f g) : L'.InOneLoop W f g :=
  have grow : ∀ a b, L.Affects W a b → L'.Affects W a b :=
    fun _ _ ⟨c, depends, exchanges⟩ => ⟨c, depends, more _ _ exchanges⟩
  ⟨WithinClosure.mono grow one.1, WithinClosure.mono grow one.2⟩

/-! ## Returning loops exist over finitely many formations -/

/-- A test holding at a listed member is counted. -/
theorem holdsCount_pos {p : F → Bool} :
    ∀ {xs : List F} {x : F}, x ∈ xs → p x = true → 0 < Web.holdsCount p xs
  | _ :: _, _, .head _, holds => by
      show 0 < (p _).toNat + _
      rw [holds]
      exact Nat.lt_of_lt_of_le Nat.zero_lt_one (Nat.le_add_right 1 _)
  | _ :: _, _, .tail _ mem, holds =>
      Nat.lt_of_lt_of_le (holdsCount_pos mem holds) (Nat.le_add_left _ _)

/-- A test implied by another and holding where the other fails counts strictly more. -/
theorem holdsCount_lt {p q : F → Bool} :
    ∀ {xs : List F}, (∀ x, x ∈ xs → p x = true → q x = true) →
      (∃ y, y ∈ xs ∧ q y = true ∧ p y = false) → Web.holdsCount p xs < Web.holdsCount q xs
  | [], _, ⟨_, mem, _⟩ => nomatch mem
  | x :: xs, imp, ⟨_, .head _, qy, py⟩ => by
      show (p x).toNat + Web.holdsCount p xs < (q x).toNat + Web.holdsCount q xs
      rw [qy, py]
      exact Nat.lt_of_le_of_lt (Nat.le_of_eq (Nat.zero_add _))
        (Nat.lt_of_lt_of_le (Nat.lt_succ_of_le
          (Web.holdsCount_le_of_imp fun z mem => imp z (.tail _ mem)))
          (Nat.le_of_eq (Nat.add_comm _ 1)))
  | x :: xs, imp, ⟨y, .tail _ mem, qy, py⟩ =>
      Nat.lt_of_le_of_lt
        (Nat.add_le_add_right (Web.toNat_le_of_imp (imp x (.head _))) _)
        (Nat.add_lt_add_left (holdsCount_lt (fun z m => imp z (.tail _ m)) ⟨y, mem, qy, py⟩) _)

/-- A search through a list for a member meeting a decided test. -/
theorem search {p : F → Prop} (decided : ∀ x, Decidable (p x)) :
    ∀ xs : List F, (∃ x, x ∈ xs ∧ p x) ∨ (∀ x, x ∈ xs → ¬ p x)
  | [] => .inr fun _ mem => nomatch mem
  | x :: xs => match decided x with
    | isTrue holds => .inl ⟨x, .head _, holds⟩
    | isFalse fails => match search decided xs with
      | .inl ⟨y, mem, holds⟩ => .inl ⟨y, .tail _ mem, holds⟩
      | .inr nothing => .inr fun y mem => match mem with
        | .head _ => fails
        | .tail _ mem' => nothing y mem'

/-- **Returning loops exist.** With finitely many formations listed and reach decided, every
formation's reach holds a formation whose acts return. -/
theorem exists_reachReturns (members : List F) (listed : ∀ g, g ∈ members)
    (decided : ∀ a b, Decidable (L.WithinReach W a b)) :
    ∀ f, ∃ c, L.WithinReach W f c ∧ L.ReachReturns W c := by
  let count : F → Nat := fun a => Web.holdsCount (fun x => @decide _ (decided a x)) members
  have main : ∀ n f, count f ≤ n → ∃ c, L.WithinReach W f c ∧ L.ReachReturns W c := by
    intro n
    induction n with
    | zero =>
        intro f bound
        exact absurd (Nat.lt_of_lt_of_le
          (holdsCount_pos (listed f) (@decide_eq_true _ (decided f f) (WithinClosure.refl f)))
          bound) (Nat.lt_irrefl 0)
    | succ n ih =>
        intro f bound
        match search (p := fun g => L.WithinReach W f g ∧ ¬ L.WithinReach W g f)
            (fun g => @instDecidableAnd _ _ (decided f g) (@instDecidableNot _ (decided g f)))
            members with
        | .inr nothing =>
            refine ⟨f, WithinClosure.refl f, fun g within => ?_⟩
            match decided g f with
            | isTrue back => exact back
            | isFalse no => exact absurd ⟨within, no⟩ (nothing g (listed g))
        | .inl ⟨g, _, reached, unreturned⟩ =>
            have fewer : count g < count f :=
              holdsCount_lt
                (fun x _ hx => @decide_eq_true _ (decided f x)
                  (reached.trans (@of_decide_eq_true _ (decided g x) hx)))
                ⟨f, listed f, @decide_eq_true _ (decided f f) (WithinClosure.refl f),
                  @decide_eq_false _ (decided g f) unreturned⟩
            match ih g (Nat.le_of_lt_succ (Nat.lt_of_lt_of_le fewer bound)) with
            | ⟨c, within, returns⟩ => exact ⟨c, reached.trans within, returns⟩
  exact fun f => main (count f) f (Nat.le_refl _)

end Flow

/-! ## How a loop forms -/

namespace Line

/-- Two formations. -/
inductive Node
  | a
  | b

/-- What each depends on. -/
inductive Spot
  | ofA
  | ofB

/-- a depends on its own condition, b on its own. -/
def web : Web Node Spot where
  level := fun _ _ => 1
  active := fun _ _ => True
  requires := fun _ g c => match g, c with
    | .a, .ofA => True
    | .a, .ofB => False
    | .b, .ofA => False
    | .b, .ofB => True
  need := fun _ _ _ => 1
  draws := fun _ _ _ => False

/-- a gives to what b depends on; with `back`, b gives to what a depends on. -/
def flow (back : Bool) : Flow Node Spot where
  present := fun _ => [.a, .b]
  take := fun _ _ _ => 0
  give := fun _ h c => match h, c with
    | .a, .ofA => 0
    | .a, .ofB => 1
    | .b, .ofA => if back then 1 else 0
    | .b, .ofB => 0

theorem a_affects_b (back : Bool) : (flow back).Affects web .a .b :=
  ⟨.ofB, ⟨0, trivial⟩, 0, .head _, .inr (show 0 < 1 from Nat.zero_lt_one)⟩

/-- In the open line b affects nothing. -/
theorem open_b_inert (g : Node) : ¬ (flow false).Affects web .b g :=
  fun ⟨c, ⟨_, requires⟩, _, _, exchanges⟩ => match g, c, requires, exchanges with
    | .a, .ofB, never, _ => nomatch never
    | .b, .ofA, never, _ => nomatch never
    | .a, .ofA, _, .inl taken => Nat.lt_irrefl 0 taken
    | .a, .ofA, _, .inr given => Nat.lt_irrefl 0 given
    | .b, .ofB, _, .inl taken => Nat.lt_irrefl 0 taken
    | .b, .ofB, _, .inr given => Nat.lt_irrefl 0 given

theorem open_b_alone {g : Node} (within : (flow false).WithinReach web .b g) : g = .b :=
  within (fun x => x = .b) (fun x y same affects => by
    subst same
    exact absurd affects (open_b_inert y)) rfl

/-- **In the open line a's acts do not return.** -/
theorem open_not_returns : ¬ (flow false).ReachReturns web .a :=
  fun returns => Node.noConfusion (open_b_alone (returns .b (WithinClosure.of_rel (a_affects_b false))))

/-- **And b's do**: b is the formation in a's reach whose acts return. -/
theorem open_b_returns : (flow false).ReachReturns web .b :=
  fun g within => by
    cases open_b_alone within
    exact WithinClosure.refl _

theorem closed_b_affects_a : (flow true).Affects web .b .a :=
  ⟨.ofA, ⟨0, trivial⟩, 0, .tail _ (.head _), .inr (by decide)⟩

/-- **Closing the link makes one loop.** -/
theorem closed_one_loop : (flow true).InOneLoop web .a .b :=
  ⟨WithinClosure.of_rel (a_affects_b true), WithinClosure.of_rel closed_b_affects_a⟩

/-- **And a's acts return.** -/
theorem closed_returns : (flow true).ReachReturns web .a :=
  fun g _ => match g with
    | .a => WithinClosure.refl _
    | .b => closed_one_loop.2

end Line

end Becoming
