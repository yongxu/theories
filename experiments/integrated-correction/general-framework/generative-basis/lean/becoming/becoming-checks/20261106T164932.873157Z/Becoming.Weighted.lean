import Becoming.Witnesses

/-!
# Weighted histories

Ren, 12 October 2026, on laws that are not determined: "this is somewhat like quantum dynamics.
For examples, Fermi's diagrams. It cannot be always determined because there are so many patterns
and loops but we can still find a way to to integrate so we can still calculate this effects but
how how accurate can we do that uh what is the limitation do we have losses". The core's laws that
are not determined state what is possible, not how much. This module states what a weighting of
steps adds and proves where its sum over histories is exact and where it loses. The weights come
with their laws (`Weights`: alternatives add, successive steps compose, each with a unit, the
composition distributing over the addition); nothing is assumed of any world, and each theorem
holds for every weighting and listing it names.

* **The sum over histories is exact and factors into steps.** With the moves and configurations
  listed, the sum over every course of `n` steps of the composed weights of its steps is `n`
  steps of the transfer, taken one step at a time (`courses`, `Weights.along`, `Weights.transfer`,
  `Weights.sum_courses`). Exponentially many courses are summed by one-step compositions.
* **Possibility is the core's relation.** Where possibility weights (alternatives join,
  successions meet) read a process's steps and every move and configuration is listed, the
  transfer after `n` steps holds exactly where a trace of `n` moves leads to where the reading
  holds (`possibility`, `possibility_transfer_iff`). The core's laws that are not determined are
  this instance.
* **Counting refines possibility without loss.** A reading that keeps the laws of the weights can
  be taken course by course or at the end (`Weights.Hom`, `Weights.Hom.transfer`). Whether a count
  is zero is such a reading of counting in possibility (`counting`, `nonzero`, `support`), so the
  count of courses is not zero exactly where a course exists (`counting_transfer_iff`).
* **Integrating out is exact exactly where it is lumpable.** What is read through a description
  after any number of steps depends on the description alone exactly where it does after one
  step (`Weights.lumped_iff`), the weighted form of `carries_law_iff`; where it does not, the
  description carries no weighted law (`Lumping.loses`).
* **The losses, each a theorem.**
  - *Truncation.* What a truncation misses is exactly the part left out (`Weights.sum_append`);
    where alternatives only add, a truncation bounds the whole from below
    (`counting_truncation_le`).
  - *Cancellation.* With signed counts (`signed`), courses that are each possible can balance
    (`Interference.cancels`), a truncation can miss a cancellation (`Interference.truncation_misses_cancellation`), and
    no reading into possibility that keeps the join of alternatives sees a cancellation
    (`Interference.unseen`, `Interference.unseen_balanced`).
  - *Memory.* A weighting that depends on how one came is not a weighting of steps of the
    configurations it is given on (`Memory.not_of_steps`); it is one on configurations that keep
    what it needs (`Memory.of_kept`).
  - *Loops.* Around a loop of two moves the courses double at every step (`Weighted.Loop.courses_double`),
    so a sum over every horizon has no finite value without something more.
* **What every weighting of a listed domain sees.** The mass of an event on a listed domain
  follows inclusion under every weighting (`mass_mono`) and rises strictly where an entry of
  positive weight is added (`mass_lt_of_added`). Every weighting keeps an event's mass from
  falling exactly where the event is included on the domain (`every_weighting_iff`): the
  weightings counting one entry (`dirac`) tell events apart, so inclusion is all that every
  weighting agrees on, and one weighting can see less. Every event drawn from the domain stays
  within a bound exactly where the whole domain does (`every_event_within_iff`), while each entry
  within the bound does not put the entries together within it
  (`entries_within_not_together`).

**Readings.** The AI's, adopted on Ren's delegation of 15 October 2026 (DELEGATED-CHOICES D30). The
AI reads "Fermi's diagrams" as Feynman diagrams, whose sum over histories has this shape: the weight
of a history is composed of the weights of its steps, and alternatives add. Read so, the module
answers the question in four parts. The sum is exact, for every number of courses, with finitely
many configurations and a bounded horizon. It is exact through a coarser description exactly where
that description is lumpable. Its losses are the four above: a truncation misses exactly what it
drops, possibility cannot see a cancellation, memory must be kept in the configuration, and loops
multiply courses without bound. Every axiom report of the module is empty, as the core's are.

What is not derived: where weights come from, or which weighting an actual unfolding has; this is
a further law or an empirical correspondence. Signed counts are the least weighting here that
cancels. They are pairs compared by balance, not integers, since the core takes no quotient;
amplitudes with phases (complex numbers) belong to the periphery. Sums over infinitely many
configurations or an unbounded horizon, with their convergence, are not stated. The memory
witness is one weighting; that a configuration keeping the whole course makes every weighting one
of steps is not proved here for weights in general (for possibility, a kept history shows a law
with no other history: `Run.keepHistory_shown` in `Becoming.Unfolding`, P69).

`counting_transfer_iff` and `possibility_transfer_iff` are in `Becoming.WeightedTraces` (board
item W).
-/

namespace Becoming

universe u v w x

/-! ## Weights -/

/-- Weights: what a step contributes, how the contributions of alternatives add, and how those of
successive steps compose. The laws come with the weights; nothing here is assumed of any world. -/
structure Weights (R : Type w) where
  zero : R
  one : R
  add : R → R → R
  mul : R → R → R
  add_assoc : ∀ a b c, add (add a b) c = add a (add b c)
  zero_add : ∀ a, add zero a = a
  add_zero : ∀ a, add a zero = a
  mul_assoc : ∀ a b c, mul (mul a b) c = mul a (mul b c)
  one_mul : ∀ a, mul one a = a
  mul_one : ∀ a, mul a one = a
  zero_mul : ∀ a, mul zero a = zero
  mul_zero : ∀ a, mul a zero = zero
  left_distrib : ∀ a b c, mul a (add b c) = add (mul a b) (mul a c)
  right_distrib : ∀ a b c, mul (add a b) c = add (mul a c) (mul b c)

namespace Weights

variable {R : Type w} (W : Weights R)

/-- The sum of contributions over a list. -/
def sum {α : Type u} : List α → (α → R) → R
  | [], _ => W.zero
  | a :: as, f => W.add (f a) (sum as f)

variable {W}

theorem sum_append {α : Type u} (f : α → R) :
    ∀ l l' : List α, W.sum (l ++ l') f = W.add (W.sum l f) (W.sum l' f)
  | [], _ => (W.zero_add _).symm
  | a :: l, l' => (congrArg (W.add (f a)) (sum_append f l l')).trans (W.add_assoc _ _ _).symm

theorem sum_congr {α : Type u} {f g : α → R} :
    ∀ (l : List α), (∀ a, a ∈ l → f a = g a) → W.sum l f = W.sum l g
  | [], _ => rfl
  | a :: l, same =>
    (congrArg (fun x => W.add x _) (same a (.head _))).trans
      (congrArg (W.add _) (sum_congr l fun b mem => same b (.tail _ mem)))

theorem mul_sum {α : Type u} (c : R) (f : α → R) :
    ∀ l : List α, W.mul c (W.sum l f) = W.sum l fun a => W.mul c (f a)
  | [] => W.mul_zero c
  | _ :: l => (W.left_distrib _ _ _).trans (congrArg (W.add _) (mul_sum c f l))

theorem sum_map {α : Type u} {β : Type v} (g : α → β) (f : β → R) :
    ∀ l : List α, W.sum (l.map g) f = W.sum l fun a => f (g a)
  | [] => rfl
  | _ :: l => congrArg (W.add _) (sum_map g f l)

end Weights

/-- Each member of a list, followed by each of the list it is sent to. -/
def joinMap {α : Type u} {β : Type v} (g : α → List β) : List α → List β
  | [] => []
  | a :: l => g a ++ joinMap g l

theorem Weights.sum_joinMap {R : Type w} {W : Weights R} {α : Type u} {β : Type v}
    (g : α → List β) (f : β → R) :
    ∀ l : List α, W.sum (joinMap g l) f = W.sum l fun a => W.sum (g a) f
  | [] => rfl
  | a :: l => (Weights.sum_append f (g a) (joinMap g l)).trans
      (congrArg (W.add _) (Weights.sum_joinMap g f l))

/-! ## Sums over histories -/

section Histories

variable {R : Type w} (W : Weights R) {S : Type u} {A : Type v}

/-- The steps open from any configuration: a move and an outcome, from listed moves and listed
configurations. -/
def openSteps (moves : List A) (all : List S) : List (A × S) :=
  joinMap (fun a => all.map fun m => (a, m)) moves

/-- The courses of `n` steps: every sequence of `n` open steps. -/
def courses (moves : List A) (all : List S) : Nat → List (List (A × S))
  | 0 => [[]]
  | n + 1 => joinMap (fun p => (courses moves all n).map fun h => p :: h) (openSteps moves all)

/-- The weight along a course from a configuration, the weight of each step composed in order,
with what is read at its end. -/
def Weights.along (weight : S → A → S → R) (f : S → R) : S → List (A × S) → R
  | s, [] => f s
  | s, p :: h => W.mul (weight s p.1 p.2) (along weight f p.2 h)

/-- The transfer: what is read after `n` steps, one step at a time. -/
def Weights.transfer (weight : S → A → S → R) (moves : List A) (all : List S) (f : S → R) :
    Nat → S → R
  | 0, s => f s
  | n + 1, s => W.sum (openSteps moves all) fun p =>
      W.mul (weight s p.1 p.2) (transfer weight moves all f n p.2)

variable {W}

/-- **The sum over every course of `n` steps is `n` steps of the transfer.** For every weighting
of steps, with no condition: the sum over the histories factors into one-step compositions,
because the weight of a history is composed of the weights of its steps. -/
theorem Weights.sum_courses (weight : S → A → S → R) (moves : List A) (all : List S) (f : S → R) :
    ∀ n s, W.sum (courses moves all n) (W.along weight f s) = W.transfer weight moves all f n s
  | 0, s => W.add_zero (f s)
  | n + 1, s =>
    (Weights.sum_joinMap _ _ _).trans (Weights.sum_congr _ fun p _ =>
      (Weights.sum_map _ _ _).trans
        ((Weights.mul_sum (weight s p.1 p.2) (W.along weight f p.2) _).symm.trans
          (congrArg (W.mul _) (Weights.sum_courses weight moves all f n p.2))))

end Histories

/-! ## Integrating out -/

section Lumping

variable {R : Type w} {W : Weights R} {S : Type u} {A : Type v} {K : Type x}

/-- **Integrating out is exact at every horizon exactly where it is exact at one step.** For a
description `π` with a representative of each of its values, what is read through `π` after any
number of steps depends only on the description exactly where it does after one step: the
weighted form of `carries_law_iff`, lumpability. -/
theorem Weights.lumped_iff (weight : S → A → S → R) (moves : List A) (all : List S) (π : S → K)
    (rep : K → S) (represents : ∀ k, π (rep k) = k) :
    (∀ n (g : K → R) s s', π s = π s' →
        W.transfer weight moves all (fun m => g (π m)) n s =
          W.transfer weight moves all (fun m => g (π m)) n s') ↔
      ∀ (g : K → R) s s', π s = π s' →
        W.transfer weight moves all (fun m => g (π m)) 1 s =
          W.transfer weight moves all (fun m => g (π m)) 1 s' := by
  refine ⟨fun lumped g s s' same => lumped 1 g s s' same, fun one => ?_⟩
  intro n
  induction n with
  | zero => exact fun g s s' same => congrArg g same
  | succ n ih =>
    intro g s s' same
    -- After `n` steps what is read through `π` is read off the description.
    have read : ∀ m, W.transfer weight moves all (fun m => g (π m)) n m =
        W.transfer weight moves all (fun m => g (π m)) n (rep (π m)) :=
      fun m => ih g m (rep (π m)) (represents (π m)).symm
    have through : ∀ t, W.transfer weight moves all (fun m => g (π m)) (n + 1) t =
        W.transfer weight moves all
          (fun m => W.transfer weight moves all (fun m => g (π m)) n (rep (π m))) 1 t :=
      fun t => Weights.sum_congr _ fun p _ => congrArg (W.mul _) (read p.2)
    exact (through s).trans ((one (fun k => W.transfer weight moves all (fun m => g (π m)) n (rep k))
      s s' same).trans (through s').symm)

end Lumping

/-! ## Readings between weightings -/

section Readings

variable {R : Type w} {T : Type x}

/-- A reading of one weighting in another that keeps its laws: alternatives still add, and
successive steps still compose. -/
structure Weights.Hom (W : Weights R) (V : Weights T) where
  map : R → T
  map_zero : map W.zero = V.zero
  map_one : map W.one = V.one
  map_add : ∀ a b, map (W.add a b) = V.add (map a) (map b)
  map_mul : ∀ a b, map (W.mul a b) = V.mul (map a) (map b)

variable {W : Weights R} {V : Weights T}

theorem Weights.Hom.sum (h : Weights.Hom W V) {α : Type u} (f : α → R) :
    ∀ l : List α, h.map (W.sum l f) = V.sum l fun a => h.map (f a)
  | [] => h.map_zero
  | _ :: l => (h.map_add _ _).trans (congrArg (V.add _) (Weights.Hom.sum h f l))

/-- **A reading that keeps the laws can be taken course by course or at the end:** the sum over
histories read through it is the sum over histories of what it reads. -/
theorem Weights.Hom.transfer (h : Weights.Hom W V) {S : Type u} {A : Type v}
    (weight : S → A → S → R) (moves : List A) (all : List S) (f : S → R) :
    ∀ n s, h.map (W.transfer weight moves all f n s) =
      V.transfer (fun s a t => h.map (weight s a t)) moves all (fun s => h.map (f s)) n s
  | 0, _ => rfl
  | n + 1, _ => (Weights.Hom.sum h _ _).trans (Weights.sum_congr _ fun p _ =>
      (h.map_mul _ _).trans (congrArg (V.mul _) (Weights.Hom.transfer h weight moves all f n p.2)))

end Readings

/-! ## Possibility and counting -/

/-- Possibility: alternatives join, steps in succession meet. -/
def possibility : Weights Bool where
  zero := false
  one := true
  add := or
  mul := and
  add_assoc := fun a b c => by cases a <;> cases b <;> cases c <;> rfl
  zero_add := fun a => by cases a <;> rfl
  add_zero := fun a => by cases a <;> rfl
  mul_assoc := fun a b c => by cases a <;> cases b <;> cases c <;> rfl
  one_mul := fun a => by cases a <;> rfl
  mul_one := fun a => by cases a <;> rfl
  zero_mul := fun a => by cases a <;> rfl
  mul_zero := fun a => by cases a <;> rfl
  left_distrib := fun a b c => by cases a <;> cases b <;> cases c <;> rfl
  right_distrib := fun a b c => by cases a <;> cases b <;> cases c <;> rfl

/-- Counting: alternatives add, steps in succession multiply. -/
def counting : Weights Nat where
  zero := 0
  one := 1
  add := Nat.add
  mul := Nat.mul
  add_assoc := Nat.add_assoc
  zero_add := Nat.zero_add
  add_zero := Nat.add_zero
  mul_assoc := mul_assoc_nat
  one_mul := Nat.one_mul
  mul_one := Nat.mul_one
  zero_mul := Nat.zero_mul
  mul_zero := Nat.mul_zero
  left_distrib := Nat.left_distrib
  right_distrib := fun a b c => add_mul_split a b c

theorem possibility_sum_true {α : Type u} {g : α → Bool} :
    ∀ {l : List α}, possibility.sum l g = true → ∃ x, x ∈ l ∧ g x = true
  | [], holds => Bool.noConfusion holds
  | a :: l, holds => by
    cases here : g a with
    | true => exact ⟨a, .head _, here⟩
    | false =>
      have rest : possibility.sum l g = true := by
        have joined : (g a || possibility.sum l g) = true := holds
        rw [here] at joined
        exact joined
      obtain ⟨x, mem, holds⟩ := possibility_sum_true rest
      exact ⟨x, .tail _ mem, holds⟩

theorem possibility_sum_of_mem {α : Type u} {g : α → Bool} {x : α} (holds : g x = true) :
    ∀ {l : List α}, x ∈ l → possibility.sum l g = true
  | _ :: _, .head _ => show (g x || _) = true by rw [holds]; rfl
  | b :: l, .tail _ mem => show (g b || _) = true by
      rw [possibility_sum_of_mem holds mem]
      cases g b <;> rfl

/-- The list lemmas below repeat `Openness`'s and `Population`'s at every universe. -/
theorem mem_appended_right {α : Type u} {a : α} {l' : List α} (mem : a ∈ l') :
    ∀ l : List α, a ∈ l ++ l'
  | [] => mem
  | _ :: l => .tail _ (mem_appended_right mem l)

theorem mem_joinMap {α : Type u} {β : Type v} (g : α → List β) {a : α} {b : β} (inner : b ∈ g a) :
    ∀ {l : List α}, a ∈ l → b ∈ joinMap g l
  | _ :: l, .head _ => mem_appended_left (joinMap g l) inner
  | c :: _, .tail _ mem => mem_appended_right (mem_joinMap g inner mem) (g c)

theorem mem_openSteps {S : Type u} {A : Type v} {moves : List A} {all : List S} {a : A} {m : S}
    (move : a ∈ moves) (reached : m ∈ all) : (a, m) ∈ openSteps moves all :=
  mem_joinMap (fun a => all.map fun m => (a, m)) (ListTests.mem_map_of (f := fun m => (a, m)) reached) move

/-- **Counting read as possibility loses nothing of what is possible:** a count is not zero
exactly where possibility holds, since counts of alternatives cannot cancel. -/
def support : Weights.Hom counting possibility where
  map := nonzero
  map_zero := rfl
  map_one := rfl
  map_add := fun a b => by
    cases b with
    | zero => cases a <;> rfl
    | succ b => cases a <;> rfl
  map_mul := fun a b => by
    cases b with
    | zero => cases a <;> rfl
    | succ b =>
      cases a with
      | zero => exact (congrArg nonzero (Nat.zero_mul (b + 1)) : _)
      | succ a => rfl

namespace Lumping

/-- Two configurations with one description: from the first both outcomes are open, from the
second neither. -/
def weight : Bool → Unit → Bool → Nat
  | true, _, _ => 1
  | false, _, _ => 0

/-- **Integrating out can lose the law.** Two configurations with one description differ in what
is read after one step, so the description carries no weighted law. -/
theorem loses :
    ¬ ∀ (g : Unit → Nat) (s s' : Bool), (fun _ : Bool => ()) s = (fun _ : Bool => ()) s' →
      counting.transfer weight [()] [true, false] (fun m => g ((fun _ : Bool => ()) m)) 1 s =
        counting.transfer weight [()] [true, false] (fun m => g ((fun _ : Bool => ()) m)) 1 s' :=
  fun lumped => Nat.noConfusion (lumped (fun _ => 1) true false rfl : 2 = 0)

end Lumping

/-! ## Truncation, cancellation, memory and loops -/

/-- **Where alternatives cannot cancel, a truncation bounds the whole from below.** -/
theorem counting_truncation_le {α : Type u} (kept dropped : List α) (f : α → Nat) :
    counting.sum kept f ≤ counting.sum (kept ++ dropped) f :=
  (Weights.sum_append (W := counting) f kept dropped) ▸ Nat.le_add_right _ _

theorem pair_eq {a b c d : Nat} (first : a = c) (second : b = d) : (a, b) = (c, d) := by
  subst first
  subst second
  rfl

theorem swap_middle (w x y z : Nat) : (w + x) + (y + z) = (w + y) + (z + x) := by
  rw [Nat.add_add_add_comm, Nat.add_comm x z]

theorem pair_assoc (a₁ a₂ c₁ c₂ e₁ e₂ : Nat) :
    (a₁ * c₁ + a₂ * c₂) * e₁ + (a₁ * c₂ + a₂ * c₁) * e₂ =
      a₁ * (c₁ * e₁ + c₂ * e₂) + a₂ * (c₁ * e₂ + c₂ * e₁) := by
  rw [add_mul_split, add_mul_split, mul_assoc_nat, mul_assoc_nat, mul_assoc_nat, mul_assoc_nat,
    Nat.left_distrib a₁, Nat.left_distrib a₂]
  exact swap_middle _ _ _ _

theorem pair_spread (a₁ a₂ b₁ b₂ c₁ c₂ : Nat) :
    a₁ * (b₁ + c₁) + a₂ * (b₂ + c₂) = (a₁ * b₁ + a₂ * b₂) + (a₁ * c₁ + a₂ * c₂) := by
  rw [Nat.left_distrib a₁, Nat.left_distrib a₂, Nat.add_add_add_comm]

theorem pair_spread_right (a₁ a₂ b₁ b₂ c₁ c₂ : Nat) :
    (a₁ + b₁) * c₁ + (a₂ + b₂) * c₂ = (a₁ * c₁ + a₂ * c₂) + (b₁ * c₁ + b₂ * c₂) := by
  rw [add_mul_split, add_mul_split, Nat.add_add_add_comm]

/-- Signed counts: a contribution is a pair, what adds and what subtracts. Alternatives add part
by part; a step that subtracts turns what follows around. -/
def signed : Weights (Nat × Nat) where
  zero := (0, 0)
  one := (1, 0)
  add := fun x y => (x.1 + y.1, x.2 + y.2)
  mul := fun x y => (x.1 * y.1 + x.2 * y.2, x.1 * y.2 + x.2 * y.1)
  add_assoc := fun x y z => pair_eq (Nat.add_assoc _ _ _) (Nat.add_assoc _ _ _)
  zero_add := fun x => pair_eq (Nat.zero_add _) (Nat.zero_add _)
  add_zero := fun _ => rfl
  mul_assoc := fun x y z => pair_eq (pair_assoc _ _ _ _ _ _) (pair_assoc _ _ _ _ _ _)
  one_mul := fun x => pair_eq
    (by rw [Nat.one_mul, Nat.zero_mul, Nat.add_zero]) (by rw [Nat.one_mul, Nat.zero_mul, Nat.add_zero])
  mul_one := fun x => pair_eq
    (by rw [Nat.mul_one, Nat.mul_zero, Nat.add_zero]) (by rw [Nat.mul_one, Nat.mul_zero, Nat.zero_add])
  zero_mul := fun x => pair_eq
    (by rw [Nat.zero_mul, Nat.zero_mul]) (by rw [Nat.zero_mul, Nat.zero_mul])
  mul_zero := fun _ => rfl
  left_distrib := fun x y z => pair_eq (pair_spread _ _ _ _ _ _) (pair_spread _ _ _ _ _ _)
  right_distrib := fun x y z => pair_eq (pair_spread_right _ _ _ _ _ _)
    (pair_spread_right _ _ _ _ _ _)

namespace Interference

/-- Two moves from one configuration back to it, one adding and one subtracting. -/
def weight : Unit → Bool → Unit → Nat × Nat
  | _, true, _ => (1, 0)
  | _, false, _ => (0, 1)

/-- **Possible courses can cancel.** Each of the two courses is possible, and so is their join;
their signed counts balance, what adds equalling what subtracts. -/
theorem cancels :
    possibility.transfer (fun _ _ _ => true) [true, false] [()] (fun _ => true) 1 () = true ∧
      signed.transfer weight [true, false] [()] (fun _ => signed.one) 1 () = (1, 1) :=
  ⟨rfl, rfl⟩

/-- **A truncation can miss a cancellation where courses cancel:** keeping the first course alone gives a
count that only adds, while the whole balances. -/
theorem truncation_misses_cancellation :
    signed.sum [((true : Bool), ())] (fun p => signed.mul (weight () p.1 p.2) signed.one) =
      (1, 0) :=
  rfl

/-- **No reading into possibility that keeps the join of alternatives sees a cancellation:** if
it marks a course possible, it marks possible every sum the course enters, balanced or not. -/
theorem unseen (φ : Nat × Nat → Bool) (joins : ∀ x y, φ (signed.add x y) = (φ x || φ y))
    {x : Nat × Nat} (marks : φ x = true) (y : Nat × Nat) : φ (signed.add x y) = true :=
  (joins x y).trans (by rw [marks]; rfl)

/-- So such a reading marks the balanced join of the two courses possible. -/
theorem unseen_balanced (φ : Nat × Nat → Bool)
    (joins : ∀ x y, φ (signed.add x y) = (φ x || φ y)) (marks : φ (1, 0) = true) :
    φ (1, 1) = true :=
  unseen φ joins marks (0, 1)

end Interference

namespace Memory

/-- A weighting of two-step courses that remembers: the second move must differ from the
first. -/
def differ : Bool → Bool → Bool
  | true, true => false
  | true, false => true
  | false, true => true
  | false, false => false

/-- **A weighting with memory is not a weighting of steps of the configurations it is given
on.** No possibility weight of steps on one configuration, read through any end reading, gives
"the second move differs from the first". -/
theorem not_of_steps (w : Unit → Bool → Unit → Bool) (f : Unit → Bool) :
    ¬ ∀ a b, possibility.along w f () [(a, ()), (b, ())] = differ a b := by
  intro gives
  have mixed : (w () true () && (w () false () && f ())) = true := gives true false
  have repeated : (w () true () && (w () true () && f ())) = false := gives true true
  obtain ⟨first, rest⟩ := bool_of_and_true mixed
  obtain ⟨_, ends⟩ := bool_of_and_true rest
  rw [first, ends] at repeated
  exact Bool.noConfusion repeated

/-- Whether a configuration keeping the last move keeps the move just made. -/
def lands : Option Bool → Bool → Bool
  | some x, a => x == a
  | none, _ => false

/-- Whether a move differs from the move kept before; with none kept, every move does. -/
def fresh : Option Bool → Bool → Bool
  | some x, a => differ x a
  | none, _ => true

/-- The step weight on configurations that keep the last move: a move lands where it is kept and
must differ from the move kept before. -/
def kept (last : Option Bool) (a : Bool) (next : Option Bool) : Bool :=
  lands next a && fresh last a

/-- **The same weighting is a weighting of steps once the configuration keeps what it needs.**
The loss of memory is a loss of the description, not of the unfolding. -/
theorem of_kept : ∀ a b,
    possibility.along kept (fun _ => true) none [(a, some a), (b, some b)] = differ a b
  | true, true => rfl
  | true, false => rfl
  | false, true => rfl
  | false, false => rfl

end Memory

namespace Weighted.Loop

/-- One configuration and two moves back to it. -/
def courses (n : Nat) : Nat :=
  counting.transfer (fun _ _ _ => 1) [true, false] [()] (fun _ => 1) n ()

/-- **Around a loop the courses double at every step:** their count after `n` steps is
`2 ^ n`, so a sum over every horizon has no finite value without something more. -/
theorem courses_double : ∀ n, courses n = 2 ^ n
  | 0 => rfl
  | n + 1 => by
    show 1 * courses n + (1 * courses n + 0) = 2 ^ n * 2
    rw [courses_double n, Nat.one_mul, Nat.add_zero, Nat.mul_two]

end Weighted.Loop

/-! ## What every weighting of a listed domain sees -/

section Mass

variable {Ω : Type u}

/-- The mass of an event on a listed domain under a weighting of its entries. An entry listed
twice counts twice. -/
def mass (domain : List Ω) (weight : Ω → Nat) (event : Ω → Bool) : Nat :=
  match domain with
  | [] => 0
  | h :: tail => (if event h = true then weight h else 0) + mass tail weight event

/-- One event included in another on a listed domain. -/
def IncludedOn (domain : List Ω) (before after : Ω → Bool) : Prop :=
  ∀ h ∈ domain, before h = true → after h = true

theorem IncludedOn.tail {h : Ω} {tail : List Ω} {before after : Ω → Bool}
    (included : IncludedOn (h :: tail) before after) : IncludedOn tail before after :=
  fun x mem => included x (List.Mem.tail h mem)

/-- An entry's contribution follows inclusion. -/
theorem entry_le {before after : Ω → Bool} (weight : Ω → Nat) {h : Ω}
    (included : before h = true → after h = true) :
    (if before h = true then weight h else 0) ≤ (if after h = true then weight h else 0) := by
  cases hb : before h with
  | false => exact Nat.zero_le _
  | true =>
    cases ha : after h with
    | false => exact Bool.noConfusion (ha.symm.trans (included hb))
    | true => exact Nat.le_refl _

/-- **Mass follows inclusion**, under every weighting. -/
theorem mass_mono {before after : Ω → Bool} (weight : Ω → Nat) :
    ∀ {domain : List Ω}, IncludedOn domain before after →
      mass domain weight before ≤ mass domain weight after
  | [], _ => Nat.le_refl 0
  | h :: tail, included =>
    Nat.add_le_add (entry_le weight (included h (List.Mem.head tail))) (mass_mono weight included.tail)

/-- **Mass rises where a weighted entry is added**: an event included in another, lacking an
entry of the domain the other has, has less mass under a weighting giving that entry weight. -/
theorem mass_lt_of_added {before after : Ω → Bool} (weight : Ω → Nat) {x : Ω}
    (positive : 0 < weight x) (absent : before x = false) (present : after x = true) :
    ∀ {domain : List Ω}, IncludedOn domain before after → x ∈ domain →
      mass domain weight before < mass domain weight after
  | _ :: tail, included, .head _ => by
    show (if before x = true then weight x else 0) + mass tail weight before <
      (if after x = true then weight x else 0) + mass tail weight after
    cases hb : before x with
    | true => exact Bool.noConfusion (absent.symm.trans hb)
    | false =>
      cases ha : after x with
      | false => exact Bool.noConfusion (ha.symm.trans present)
      | true => exact Nat.add_lt_add_of_lt_of_le positive (mass_mono weight included.tail)
  | h :: _, included, .tail _ mem =>
    Nat.add_lt_add_of_le_of_lt (entry_le weight (included h (List.Mem.head _)))
      (mass_lt_of_added weight positive absent present included.tail mem)

/-- The weighting counting the entry `x` once. -/
def dirac [DecidableEq Ω] (x : Ω) (y : Ω) : Nat :=
  if y = x then 1 else 0

theorem mem_of_mass_dirac_pos [DecidableEq Ω] {x : Ω} {event : Ω → Bool} :
    ∀ {domain : List Ω}, 0 < mass domain (dirac x) event → x ∈ domain ∧ event x = true
  | [], pos => absurd pos (Nat.lt_irrefl 0)
  | h :: tail, pos => by
    have pos : 0 < (if event h = true then dirac x h else 0) + mass tail (dirac x) event := pos
    cases he : event h with
    | false =>
      rw [he] at pos
      have rest := mem_of_mass_dirac_pos (Nat.zero_add (mass tail (dirac x) event) ▸ pos)
      exact ⟨List.Mem.tail h rest.1, rest.2⟩
    | true =>
      rw [he] at pos
      exact Decidable.byCases (dec := inferInstanceAs (Decidable (h = x)))
        (fun same : h = x => same ▸ ⟨List.Mem.head tail, he⟩)
        (fun other : ¬ h = x => by
          have zero : dirac x h = 0 := if_neg other
          have rest := mem_of_mass_dirac_pos (Nat.zero_add (mass tail (dirac x) event) ▸
            zero ▸ pos)
          exact ⟨List.Mem.tail h rest.1, rest.2⟩)

theorem mass_dirac_pos [DecidableEq Ω] {x : Ω} {event : Ω → Bool} (occurs : event x = true) :
    ∀ {domain : List Ω}, x ∈ domain → 0 < mass domain (dirac x) event
  | _ :: tail, .head _ => by
    show 0 < (if event x = true then dirac x x else 0) + mass tail (dirac x) event
    rw [occurs]
    have one : dirac x x = 1 := if_pos rfl
    exact Nat.lt_of_lt_of_le (one ▸ Nat.zero_lt_one) (Nat.le_add_right _ _)
  | _ :: _, .tail _ mem => Nat.lt_of_lt_of_le (mass_dirac_pos occurs mem) (Nat.le_add_left _ _)

/-- **Every weighting keeps an event's mass from falling exactly where it is included.** The
weightings counting one entry (`dirac`) separate events on the domain, so inclusion is all that
every weighting agrees on; one weighting, the law of chance of an actual unfolding, can see
less. -/
theorem every_weighting_iff [DecidableEq Ω] {domain : List Ω} {before after : Ω → Bool} :
    (∀ weight : Ω → Nat, mass domain weight before ≤ mass domain weight after) ↔
      IncludedOn domain before after :=
  ⟨fun all x mem occurs => (mem_of_mass_dirac_pos
      (Nat.lt_of_lt_of_le (mass_dirac_pos occurs mem) (all (dirac x)))).2,
   fun included weight => mass_mono weight included⟩

/-- **Every event drawn from a listed domain stays within a bound exactly where the whole domain
does.** The whole domain is one event, and every event is included in it. -/
theorem every_event_within_iff {domain : List Ω} {weight : Ω → Nat} {bound : Nat} :
    (∀ event : Ω → Bool, mass domain weight event ≤ bound) ↔
      mass domain weight (fun _ => true) ≤ bound :=
  ⟨fun all => all _, fun whole _ => Nat.le_trans (mass_mono weight fun _ _ _ => rfl) whole⟩

/-- **Each entry within the bound does not put the entries together within it.** Two entries of
weight two each, against the bound two. -/
theorem entries_within_not_together :
    (∀ x, x ∈ [false, true] → (fun _ : Bool => 2) x ≤ 2) ∧
      ¬ mass [false, true] (fun _ => 2) (fun _ => true) ≤ 2 :=
  ⟨fun _ _ => Nat.le_refl 2, fun within =>
    Nat.not_succ_le_zero 1 (Nat.le_of_succ_le_succ (Nat.le_of_succ_le_succ
      (show 4 ≤ 2 from within)))⟩

end Mass

/-- Counting one for each member of a list counts its length. -/
theorem Situations.sum_one {α : Type u} : ∀ l : List α, counting.sum l (fun _ => 1) = l.length
  | [] => rfl
  | _ :: l => (Nat.add_comm 1 _).trans (congrArg (· + 1) (Situations.sum_one l))

end Becoming
