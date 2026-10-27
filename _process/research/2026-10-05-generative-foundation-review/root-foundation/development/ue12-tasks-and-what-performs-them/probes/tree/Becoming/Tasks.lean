import Becoming.HeldPossible

/-!
# Tasks and what performs them

Constructor theory states the laws of physics as statements about which tasks are possible, which
are impossible, and why (Deutsch, *Constructor theory*, 2013). This module reads its task and what
performs it on any process, as a held part (`Becoming.HeldPossible`).

**The reading.** A task is a relation on the states of a substrate, with no new type (Lean's prelude
has its own `Task`): its legitimate inputs are its domain (`Input`), and the outputs of an input are
what the task relates it to. A process on configurations is divided by two readings, the performing
part (`part`) and the substrate (`sub`); what both leave out is environment. A class `K` of the
performing part **performs** a task (`Performs`) where it is presented with the task's inputs
(`Presented`: some configuration has the part in `K`, and each state of the part in `K` is had with
every legitimate input) and delivers it (`Delivers`): from every configuration with the part in `K`
and the substrate a legitimate input, whatever the environment, the process reaches one with the
part in `K` and the substrate an output of that input. The part may leave `K` along the way; in `K`
at the end, it can perform the task again. A task is **possible** with a division where some class
of the performing part performs it (`Possible`).

**Modelling choices.** Delivery is existential, as the possible is: some admissible course delivers,
and delivering is having an output possible with the part in `K` (`delivers_iff_possible`).
Constructor theory's constructor delivers invariably. Where each configuration has at most one next
configuration, a delivery is invariable, the delivered configuration lying on every course from the
presented one (`Delivers.invariably`); where several are admitted, the reading here is the weaker.
Performance is exact: constructor theory's limit "short of perfection" and its approximate
constructors need amounts of error and are not read. Which tasks are possible depends on the
division (`Conserved.possible_with_one`).

**Laws.**
* **Held throughout, restored at the end.** What is delivered by moves holding any relation is
  delivered (`Delivers.of_heldMoves`), so a task delivered with the part in `K` at every move is
  delivered with it in `K` at the end. The converse fails on a catalytic cycle: the enzyme leaves its
  free form when it binds the substrate and is free again when it releases the product
  (`Catalysis.performs`, `Catalysis.not_held`). On the same cycle the task's transpose (`transpose`)
  is performed by no class of any reading of a performing part (`Catalysis.transpose_not_possible`):
  a possible task with an impossible transpose.
* **Composition.** One class reused in series performs a regular pair in series, with no further
  premise (`Performs.serial`), and performs two tasks on two substrates in parallel where each
  delivery holds the other substrate (`Delivers.parallel_reuse`). Two classes compose, in series
  (`Delivers.serial_holding`) or in parallel (`Delivers.parallel_holding`), where each delivers by
  the moves holding what the other uses: its performing part, and in parallel its substrate. The
  premise is the possible relative to a held part. Locality gives it: on two processes interleaved,
  on one substrate (`interleaveOn`) or on two (`interleave`), each one's moves hold the other's part,
  and performed tasks compose (`Performs.serial_interleaveOn`, `Performs.parallel_interleave`), so
  Deutsch's composition principle, every regular network of possible tasks is a possible task, holds
  there for pairs (`Possible.serial_interleaveOn`, `Possible.parallel_interleave`).
* **The premise is needed.** On a coupled process, a first task is performed with a trivial
  performing part, a second by a second part, every output of the first is an input of the second,
  and the first then the second is performed by no class of any reading of a performing part
  (`Coupled.composition_fails`): the first task's only move resets the second part
  (`Coupled.not_holding`).
* **A possible whole of impossible parts, and the division.** On two substrates passing one unit
  between them, raising the first is performed by no class of any reading of the second, lowering
  the second by none of any reading of the first, and the two in parallel are possible
  (`Conserved.whole_of_impossible_parts`); no reading of the first alone raises it either
  (`Conserved.not_raise_alone`). With the performing part read as the two together holding one unit,
  raising the first is possible (`Conserved.possible_with_one`).
* **The regress.** On a tower of performers with no top (`RuleTower.process`: the move `k + 1` changes
  the performer at level `k` as the one at level `k + 1` allows), every delivery is had with the
  performers from some level up held, so each chain of constructions a delivery uses is finite and
  begins with performers it does not construct (`tower_delivers_iff_held`). On the tower changing
  every level at once, a task is performed and no delivery holds the performers from any level up
  (`FlipTower.performs`, `FlipTower.not_held`).
* **What can be done with the part at hand** (`AtHand`): the substrate states reached by the moves
  holding the performing part unchanged, the possible relative to a held part. Along a course it
  grows only across steps changing the part (`changes_of_atHandGrows`), nothing is added from the
  step at which the part stays for good (`atHand_of_stays`), it keeps widening only where the part
  changes without end (`changes_of_atHandKeepsWidening`), and not where a list holds the substrate
  states reachable from the start (`not_atHandKeepsWidening_of_listed`).

Every declaration has an empty axiom report.
-/

namespace Becoming

open Generative

universe u v w w' u' v'

namespace Tasks

/-! ## Tasks and what performs them -/

section Reading

variable {S : Type u} {A : Type v} {C : Type w} {X : Type}

/-- A legitimate input of a task: a state the task relates to something. -/
def Input (T : X → X → Prop) (x : X) : Prop := ∃ y, T x y

/-- **A class of the performing part presented with a task's inputs**: some configuration has the
part in `K`, and each state of the part in `K` is had with every legitimate input of `T`. -/
def Presented (part : S → C) (sub : S → X) (K : C → Prop) (T : X → X → Prop) : Prop :=
  (∃ s, K (part s)) ∧ ∀ s, K (part s) → ∀ x, Input T x → ∃ t, part t = part s ∧ sub t = x

/-- **Delivering a task**: from every configuration with the performing part in `K` and the
substrate a legitimate input of `T`, the process reaches one with the part in `K` and the substrate
an output of that input. The part may leave `K` along the way. -/
def Delivers (P : Process S A) (part : S → C) (sub : S → X) (K : C → Prop) (T : X → X → Prop) :
    Prop :=
  ∀ s, K (part s) → Input T (sub s) → ∃ t, Reach P s t ∧ K (part t) ∧ T (sub s) (sub t)

/-- **What performs a task**: a class of the performing part presented with the task's inputs and
delivering it. -/
def Performs (P : Process S A) (part : S → C) (sub : S → X) (K : C → Prop) (T : X → X → Prop) :
    Prop :=
  Presented part sub K T ∧ Delivers P part sub K T

/-- **A possible task**, with the division read by `part` and `sub`: some class of the performing
part performs it. -/
def Possible (P : Process S A) (part : S → C) (sub : S → X) (T : X → X → Prop) : Prop :=
  ∃ K : C → Prop, Performs P part sub K T

variable {P : Process S A} {part : S → C} {sub : S → X} {K : C → Prop} {T : X → X → Prop}

/-- **Delivering is having an output possible with the part in `K`** (`Reaching.Possible`): from
every configuration with the part in `K` and the substrate a legitimate input, some output of that
input is possible with the part in `K`. -/
theorem delivers_iff_possible :
    Delivers P part sub K T ↔ ∀ s, K (part s) → Input T (sub s) →
      ∃ y, T (sub s) y ∧ Reaching.Possible P (fun t y => K (part t) ∧ sub t = y) s y :=
  ⟨fun delivers s inK input => match delivers s inK input with
     | ⟨t, reach, inK', out⟩ => ⟨sub t, out, t, reach, inK', rfl⟩,
   fun possible s inK input => match possible s inK input with
     | ⟨_, out, t, reach, inK', same⟩ =>
       ⟨t, reach, inK', Eq.subst (motive := fun y => T (sub s) y) same.symm out⟩⟩

/-- Where each configuration has at most one next configuration, every course passing the start of
a trace passes its end. -/
theorem on_every_run (oneNext : ∀ s a t a' t', P.step s a t → P.step s a' t' → t = t') :
    ∀ {s t : S} {as : List A}, Trace P s as t → ∀ (r : Run P) (k : Nat), r.state k = s →
      ∃ n, r.state (k + n) = t
  | _, _, _, .nil _, _, _, at_ => ⟨0, at_⟩
  | _, t, _, .cons step rest, r, k, at_ =>
    match on_every_run oneNext rest r (k + 1)
        (oneNext _ _ _ _ _ (Eq.subst (motive := fun x => P.step x (r.act k) (r.state (k + 1))) at_
          (r.step k)) step) with
    | ⟨n, passes⟩ =>
      ⟨n + 1, Eq.subst (motive := fun j => r.state j = t)
        ((Nat.succ_add k n).trans (Nat.add_succ k n).symm) passes⟩

/-- **Where each configuration has at most one next configuration, a delivery is invariable**: the
delivered configuration lies on every course from the presented one, as constructor theory's
constructor delivers. -/
theorem Delivers.invariably (oneNext : ∀ s a t a' t', P.step s a t → P.step s a' t' → t = t')
    (delivers : Delivers P part sub K T) {s : S} (inK : K (part s)) (input : Input T (sub s)) :
    ∃ t, K (part t) ∧ T (sub s) (sub t) ∧ ∀ r : Run P, r.state 0 = s → ∃ n, r.state n = t :=
  match delivers s inK input with
  | ⟨t, ⟨_, trace⟩, inK', out⟩ => ⟨t, inK', out, fun r start =>
      match on_every_run oneNext trace r 0 start with
      | ⟨n, passes⟩ => ⟨n, Eq.subst (motive := fun j => r.state j = t) (Nat.zero_add n) passes⟩⟩

/-! ## Held throughout and restored at the end -/

/-- **What is delivered by moves holding a relation is delivered** (`Reach.of_heldMoves`): with the
relation `fun _ t => K (part t)`, a task delivered with the part in `K` at every move is delivered
with it in `K` at the end. -/
theorem Delivers.of_heldMoves {Same : S → S → Prop}
    (held : Delivers (Reaching.heldMoves P Same) part sub K T) : Delivers P part sub K T :=
  fun s inK input => match held s inK input with
  | ⟨t, reach, inK', out⟩ => ⟨t, Reach.of_heldMoves reach, inK', out⟩

/-- What is performed by moves holding a relation is performed. -/
theorem Performs.of_heldMoves {Same : S → S → Prop}
    (held : Performs (Reaching.heldMoves P Same) part sub K T) : Performs P part sub K T :=
  ⟨held.1, held.2.of_heldMoves⟩

/-- What is delivered by moves holding a relation is delivered by moves holding any weaker one
(`Reach.heldMoves_mono`). -/
theorem Delivers.heldMoves_mono {Same Same' : S → S → Prop}
    (weaker : ∀ s t, Same s t → Same' s t)
    (held : Delivers (Reaching.heldMoves P Same) part sub K T) :
    Delivers (Reaching.heldMoves P Same') part sub K T :=
  fun s inK input => match held s inK input with
  | ⟨t, reach, inK', out⟩ => ⟨t, Reach.heldMoves_mono weaker reach, inK', out⟩

end Reading

/-! ## Composition -/

section Composition

variable {S : Type u} {A : Type v} {C : Type w} {D : Type w'} {X Y : Type}
  {P : Process S A} {part : S → C} {sub : S → X} {K : C → Prop} {T T' : X → X → Prop}

/-- The serial composite: the net effect of `T` and then `T'` on one substrate. -/
def serial (T T' : X → X → Prop) (x z : X) : Prop := ∃ y, T x y ∧ T' y z

/-- A regular pair: every output of `T` is a legitimate input of `T'`. -/
def Regular (T T' : X → X → Prop) : Prop := ∀ x y, T x y → Input T' y

/-- The parallel composite: `T` on one substrate and `T'` on another. -/
def parallel (T : X → X → Prop) (T' : Y → Y → Prop) (p q : X × Y) : Prop :=
  T p.1 q.1 ∧ T' p.2 q.2

/-- The transpose: the task with its inputs and outputs exchanged. -/
def transpose (T : X → X → Prop) (x y : X) : Prop := T y x

/-- A reading the same is a class (`«类»`). -/
theorem sameReading_class (f : S → D) : «类» (fun s t : S => f t = f s) :=
  ⟨fun _ => rfl, fun same => same.symm, fun first second => second.trans first⟩

/-- **One class reused in series**: where `K` performs `T` and `T'`, and every output of `T` is an
input of `T'`, `K` performs `T` then `T'`, with no further premise. -/
theorem Performs.serial (first : Performs P part sub K T) (second : Performs P part sub K T')
    (regular : Regular T T') : Performs P part sub K (serial T T') :=
  ⟨⟨first.1.1, fun s inK x ⟨_, y, out, _⟩ => first.1.2 s inK x ⟨y, out⟩⟩,
   fun s inK ⟨_, y, out, _⟩ => match first.2 s inK ⟨y, out⟩ with
     | ⟨t, reach, inK', out'⟩ => match second.2 t inK' (regular _ _ out') with
       | ⟨u, reach', inK'', out''⟩ => ⟨u, reach.trans reach', inK'', sub t, out', out''⟩⟩

/-- **Two classes in series, each delivering by the moves holding the other's part**: where `K`
delivers `T` by the moves holding the part read by `part'` and `L` delivers `T'` by the moves
holding the part read by `part`, and every output of `T` is an input of `T'`, the two together
deliver `T` then `T'`. The premise is the possible relative to a held part. -/
theorem Delivers.serial_holding {part' : S → D} {L : D → Prop}
    (first : Delivers (Reaching.heldMoves P (fun s t => part' t = part' s)) part sub K T)
    (second : Delivers (Reaching.heldMoves P (fun s t => part t = part s)) part' sub L T')
    (regular : Regular T T') :
    Delivers P (fun s => (part s, part' s)) sub (fun c => K c.1 ∧ L c.2) (serial T T') :=
  fun s inKL ⟨_, y, out, _⟩ => match first s inKL.1 ⟨y, out⟩ with
  | ⟨t, reach, inK, out'⟩ =>
    have kept : part' t = part' s := Reach.same_of_heldMoves (sameReading_class part') reach
    match second t (Eq.subst (motive := L) kept.symm inKL.2) (regular _ _ out') with
    | ⟨u, reach', inL, out''⟩ =>
      have kept' : part u = part t := Reach.same_of_heldMoves (sameReading_class part) reach'
      ⟨u, (Reach.of_heldMoves reach).trans (Reach.of_heldMoves reach'),
       ⟨Eq.subst (motive := K) kept'.symm inK, inL⟩, sub t, out', out''⟩

/-- **Two classes in parallel, each delivering by the moves holding what the other uses**: where
`K` delivers `T` on the substrate read by `sub` by the moves holding the other part and the other
substrate, and `L` delivers `T'` likewise, the two together deliver `T` and `T'` in parallel. -/
theorem Delivers.parallel_holding {part' : S → D} {sub' : S → Y} {L : D → Prop}
    {T' : Y → Y → Prop}
    (first : Delivers (Reaching.heldMoves P (fun s t => (part' t, sub' t) = (part' s, sub' s)))
      part sub K T)
    (second : Delivers (Reaching.heldMoves P (fun s t => (part t, sub t) = (part s, sub s)))
      part' sub' L T') :
    Delivers P (fun s => (part s, part' s)) (fun s => (sub s, sub' s)) (fun c => K c.1 ∧ L c.2)
      (parallel T T') :=
  fun s inKL ⟨_, out, out'⟩ => match first s inKL.1 ⟨_, out⟩ with
  | ⟨t, reach, inK, outT⟩ =>
    have kept : (part' t, sub' t) = (part' s, sub' s) :=
      Reach.same_of_heldMoves (sameReading_class fun s => (part' s, sub' s)) reach
    match second t (Eq.subst (motive := L) (congrArg Prod.fst kept : part' t = part' s).symm inKL.2)
        (Eq.subst (motive := Input T') (congrArg Prod.snd kept : sub' t = sub' s).symm ⟨_, out'⟩) with
    | ⟨u, reach', inL, outT'⟩ =>
      have kept' : (part u, sub u) = (part t, sub t) :=
        Reach.same_of_heldMoves (sameReading_class fun s => (part s, sub s)) reach'
      ⟨u, (Reach.of_heldMoves reach).trans (Reach.of_heldMoves reach'),
       ⟨Eq.subst (motive := K) (congrArg Prod.fst kept' : part u = part t).symm inK, inL⟩,
       Eq.subst (motive := fun x => T (sub s) x) (congrArg Prod.snd kept' : sub u = sub t).symm outT,
       Eq.subst (motive := fun y => T' y (sub' u)) (congrArg Prod.snd kept : sub' t = sub' s) outT'⟩

/-- **One class reused in parallel**: where `K` delivers `T` by the moves holding the second
substrate and `T'` by the moves holding the first, it delivers the two in parallel, one in turn
after the other. -/
theorem Delivers.parallel_reuse {sub' : S → Y} {T' : Y → Y → Prop}
    (first : Delivers (Reaching.heldMoves P (fun s t => sub' t = sub' s)) part sub K T)
    (second : Delivers (Reaching.heldMoves P (fun s t => sub t = sub s)) part sub' K T') :
    Delivers P part (fun s => (sub s, sub' s)) K (parallel T T') :=
  fun s inK ⟨_, out, out'⟩ => match first s inK ⟨_, out⟩ with
  | ⟨t, reach, inK', outT⟩ =>
    have kept : sub' t = sub' s := Reach.same_of_heldMoves (sameReading_class sub') reach
    match second t inK' (Eq.subst (motive := Input T') kept.symm ⟨_, out'⟩) with
    | ⟨u, reach', inK'', outT'⟩ =>
      have kept' : sub u = sub t := Reach.same_of_heldMoves (sameReading_class sub) reach'
      ⟨u, (Reach.of_heldMoves reach).trans (Reach.of_heldMoves reach'), inK'',
       Eq.subst (motive := fun x => T (sub s) x) kept'.symm outT,
       Eq.subst (motive := fun y => T' y (sub' u)) kept outT'⟩

end Composition

/-! ## Locality: two processes interleaved -/

section Interleave

variable {S : Type u} {A : Type v} {S' : Type u'} {A' : Type v'} {C : Type w} {D : Type w'}
  {X Y : Type} {P : Process S A} {Q : Process S' A'}

/-- **Two processes interleaved**: a configuration is one of each, and a move is a move of either,
the other's configuration kept. -/
def interleave (P : Process S A) (Q : Process S' A') : Process (S × S') (A ⊕ A') :=
  ⟨fun s a t => match a with
    | .inl a => P.step s.1 a t.1 ∧ t.2 = s.2
    | .inr a => Q.step s.2 a t.2 ∧ t.1 = s.1⟩

/-- What the first process reaches, the interleaving reaches by moves holding the second's
configuration. -/
theorem reach_interleave_left (s₂ : S') :
    ∀ {s₁ t₁ : S} {as : List A}, Trace P s₁ as t₁ →
      Reach (Reaching.heldMoves (interleave P Q) (fun s t => t.2 = s.2)) (s₁, s₂) (t₁, s₂)
  | _, _, _, .nil _ => Reach.refl _ _
  | s₁, _, _, @Trace.cons _ _ _ _ m _ a _ step rest =>
    have first : (Reaching.heldMoves (interleave P Q) (fun s t => t.2 = s.2)).step (s₁, s₂)
        (.inl a) (m, s₂) := ⟨⟨step, rfl⟩, rfl⟩
    (Reach.of_step first).trans (reach_interleave_left s₂ rest)

/-- What the second process reaches, the interleaving reaches by moves holding the first's
configuration. -/
theorem reach_interleave_right (s₁ : S) :
    ∀ {s₂ t₂ : S'} {as : List A'}, Trace Q s₂ as t₂ →
      Reach (Reaching.heldMoves (interleave P Q) (fun s t => t.1 = s.1)) (s₁, s₂) (s₁, t₂)
  | _, _, _, .nil _ => Reach.refl _ _
  | s₂, _, _, @Trace.cons _ _ _ _ m _ a _ step rest =>
    have first : (Reaching.heldMoves (interleave P Q) (fun s t => t.1 = s.1)).step (s₁, s₂)
        (.inr a) (s₁, m) := ⟨⟨step, rfl⟩, rfl⟩
    (Reach.of_step first).trans (reach_interleave_right s₁ rest)

/-- What the first process delivers, the interleaving delivers by moves holding the second's
configuration. -/
theorem Delivers.interleave_left {part : S → C} {sub : S → X} {K : C → Prop} {T : X → X → Prop}
    (delivers : Delivers P part sub K T) :
    Delivers (Reaching.heldMoves (interleave P Q) (fun s t => t.2 = s.2)) (fun s => part s.1)
      (fun s => sub s.1) K T :=
  fun s inK input => match delivers s.1 inK input with
  | ⟨t₁, ⟨_, trace⟩, inK', out⟩ => ⟨(t₁, s.2), reach_interleave_left s.2 trace, inK', out⟩

/-- What the second process delivers, the interleaving delivers by moves holding the first's
configuration. -/
theorem Delivers.interleave_right {part : S' → D} {sub : S' → Y} {L : D → Prop}
    {T : Y → Y → Prop} (delivers : Delivers Q part sub L T) :
    Delivers (Reaching.heldMoves (interleave P Q) (fun s t => t.1 = s.1)) (fun s => part s.2)
      (fun s => sub s.2) L T :=
  fun s inL input => match delivers s.2 inL input with
  | ⟨t₂, ⟨_, trace⟩, inL', out⟩ => ⟨(s.1, t₂), reach_interleave_right s.1 trace, inL', out⟩

/-- Classes presented in each process are presented together in the interleaving. -/
theorem Presented.interleave {part : S → C} {sub : S → X} {K : C → Prop} {T : X → X → Prop}
    {part' : S' → D} {sub' : S' → Y} {L : D → Prop} {T' : Y → Y → Prop}
    (first : Presented part sub K T) (second : Presented part' sub' L T') :
    Presented (fun s : S × S' => (part s.1, part' s.2)) (fun s => (sub s.1, sub' s.2))
      (fun c => K c.1 ∧ L c.2) (parallel T T') :=
  ⟨match first.1, second.1 with
   | ⟨s₁, inK⟩, ⟨s₂, inL⟩ => ⟨(s₁, s₂), inK, inL⟩,
   fun s inKL p ⟨_, out, out'⟩ =>
     match first.2 s.1 inKL.1 p.1 ⟨_, out⟩, second.2 s.2 inKL.2 p.2 ⟨_, out'⟩ with
     | ⟨t₁, samePart, sameSub⟩, ⟨t₂, samePart', sameSub'⟩ =>
       ⟨(t₁, t₂), congr (congrArg Prod.mk samePart) samePart',
        congr (congrArg Prod.mk sameSub) sameSub'⟩⟩

/-- **On two processes interleaved, performed tasks compose in parallel**: where `K` performs `T`
in the first and `L` performs `T'` in the second, the two together perform them in parallel. The
holding premise of `Delivers.parallel_holding` is met, since each process's moves hold the other's
configuration. -/
theorem Performs.parallel_interleave {part : S → C} {sub : S → X} {K : C → Prop}
    {T : X → X → Prop} {part' : S' → D} {sub' : S' → Y} {L : D → Prop} {T' : Y → Y → Prop}
    (first : Performs P part sub K T) (second : Performs Q part' sub' L T') :
    Performs (interleave P Q) (fun s => (part s.1, part' s.2)) (fun s => (sub s.1, sub' s.2))
      (fun c => K c.1 ∧ L c.2) (parallel T T') :=
  ⟨first.1.interleave second.1,
   Delivers.parallel_holding
     ((Delivers.interleave_left first.2).heldMoves_mono
       fun _ _ same => congrArg (fun z => (part' z, sub' z)) same)
     ((Delivers.interleave_right second.2).heldMoves_mono
       fun _ _ same => congrArg (fun z => (part z, sub z)) same)⟩

/-- **On two processes interleaved, possible tasks are possible in parallel**: Deutsch's composition
principle, read for a parallel pair, holds there. -/
theorem Possible.parallel_interleave {part : S → C} {sub : S → X} {T : X → X → Prop}
    {part' : S' → D} {sub' : S' → Y} {T' : Y → Y → Prop}
    (first : Possible P part sub T) (second : Possible Q part' sub' T') :
    Possible (interleave P Q) (fun s => (part s.1, part' s.2)) (fun s => (sub s.1, sub' s.2))
      (parallel T T') :=
  match first, second with
  | ⟨_, performs⟩, ⟨_, performs'⟩ => ⟨_, performs.parallel_interleave performs'⟩

/-- **Two performing parts interleaved on one substrate**: a configuration is a state of each part
and the substrate's; a move of the first changes its part and the substrate, the second part kept,
and a move of the second changes its part and the substrate, the first part kept. -/
def interleaveOn (P : Process (C × X) A) (Q : Process (D × X) A') :
    Process ((C × D) × X) (A ⊕ A') :=
  ⟨fun s a t => match a with
    | .inl a => P.step (s.1.1, s.2) a (t.1.1, t.2) ∧ t.1.2 = s.1.2
    | .inr a => Q.step (s.1.2, s.2) a (t.1.2, t.2) ∧ t.1.1 = s.1.1⟩

/-- What the first reaches, the interleaving on one substrate reaches by moves holding the second
part. -/
theorem reach_interleaveOn_left {P : Process (C × X) A} {Q : Process (D × X) A'} (d : D) :
    ∀ {s₁ t₁ : C × X} {as : List A}, Trace P s₁ as t₁ →
      Reach (Reaching.heldMoves (interleaveOn P Q) (fun s t => t.1.2 = s.1.2))
        ((s₁.1, d), s₁.2) ((t₁.1, d), t₁.2)
  | _, _, _, .nil _ => Reach.refl _ _
  | s₁, _, _, @Trace.cons _ _ _ _ m _ a _ step rest =>
    have first : (Reaching.heldMoves (interleaveOn P Q) (fun s t => t.1.2 = s.1.2)).step
        ((s₁.1, d), s₁.2) (.inl a) ((m.1, d), m.2) := ⟨⟨step, rfl⟩, rfl⟩
    (Reach.of_step first).trans (reach_interleaveOn_left d rest)

/-- What the second reaches, the interleaving on one substrate reaches by moves holding the first
part. -/
theorem reach_interleaveOn_right {P : Process (C × X) A} {Q : Process (D × X) A'} (c : C) :
    ∀ {s₂ t₂ : D × X} {as : List A'}, Trace Q s₂ as t₂ →
      Reach (Reaching.heldMoves (interleaveOn P Q) (fun s t => t.1.1 = s.1.1))
        ((c, s₂.1), s₂.2) ((c, t₂.1), t₂.2)
  | _, _, _, .nil _ => Reach.refl _ _
  | s₂, _, _, @Trace.cons _ _ _ _ m _ a _ step rest =>
    have first : (Reaching.heldMoves (interleaveOn P Q) (fun s t => t.1.1 = s.1.1)).step
        ((c, s₂.1), s₂.2) (.inr a) ((c, m.1), m.2) := ⟨⟨step, rfl⟩, rfl⟩
    (Reach.of_step first).trans (reach_interleaveOn_right c rest)

/-- **On two performing parts interleaved on one substrate, performed tasks compose in series**:
where `K` performs `T` in the first and `L` performs `T'` in the second, and every output of `T` is
an input of `T'`, the two parts together perform `T` then `T'`. The holding premise of
`Delivers.serial_holding` is met, since each one's moves hold the other part. -/
theorem Performs.serial_interleaveOn {P : Process (C × X) A} {Q : Process (D × X) A'}
    {K : C → Prop} {L : D → Prop} {T T' : X → X → Prop}
    (first : Performs P Prod.fst Prod.snd K T) (second : Performs Q Prod.fst Prod.snd L T')
    (regular : Regular T T') :
    Performs (interleaveOn P Q) (fun s => s.1) (fun s => s.2) (fun c => K c.1 ∧ L c.2)
      (Tasks.serial T T') :=
  ⟨match first.1.1, second.1.1 with
   | ⟨s₁, inK⟩, ⟨s₂, inL⟩ => ⟨⟨⟨(s₁.1, s₂.1), s₁.2⟩, inK, inL⟩, fun s _ x _ => ⟨(s.1, x), rfl, rfl⟩⟩,
   Delivers.serial_holding (part := fun s => s.1.1) (part' := fun s => s.1.2)
     (fun s inK input => match first.2 (s.1.1, s.2) inK input with
       | ⟨t₁, ⟨_, trace⟩, inK', out⟩ =>
         ⟨((t₁.1, s.1.2), t₁.2), reach_interleaveOn_left s.1.2 trace, inK', out⟩)
     (fun s inL input => match second.2 (s.1.2, s.2) inL input with
       | ⟨t₂, ⟨_, trace⟩, inL', out⟩ =>
         ⟨((s.1.1, t₂.1), t₂.2), reach_interleaveOn_right s.1.1 trace, inL', out⟩)
     regular⟩

/-- **On two performing parts interleaved on one substrate, possible tasks are possible in
series**: Deutsch's composition principle, read for a regular pair, holds there. -/
theorem Possible.serial_interleaveOn {P : Process (C × X) A} {Q : Process (D × X) A'}
    {T T' : X → X → Prop} (first : Possible P Prod.fst Prod.snd T)
    (second : Possible Q Prod.fst Prod.snd T') (regular : Regular T T') :
    Possible (interleaveOn P Q) (fun s => s.1) (fun s => s.2) (Tasks.serial T T') :=
  match first, second with
  | ⟨_, performs⟩, ⟨_, performs'⟩ => ⟨_, performs.serial_interleaveOn performs' regular⟩

end Interleave

/-! ## The regress -/

section Tower

variable {Z : Type} {R : Type v} {base : R → Z → Z → Prop} {up : Nat → R → R → R → Prop}
  {K : (Nat → R) → Prop} {T : Z → Z → Prop}

/-- **On a tower of performers with no top, every delivery is had with the performers from some
level up held**, and conversely (`Reaching.reach_held_of_sequence`): the move `k + 1` changes the
performer at level `k` as the one at level `k + 1` allows, so each chain of constructions a
delivery uses is finite and begins with performers it does not construct. Read with the substrate
the tower's state and the performing part its performers. -/
theorem tower_delivers_iff_held :
    Delivers (RuleTower.process base up) Prod.snd Prod.fst K T ↔
      ∀ s, K s.2 → Input T s.1 → ∃ n t,
        Reach (Reaching.heldMoves (RuleTower.process base up) (RuleTower.SameFrom n)) s t ∧
          K t.2 ∧ T s.1 t.1 :=
  ⟨fun delivers s inK input => match delivers s inK input with
     | ⟨t, reach, inK', out⟩ =>
       match Reaching.reach_held_of_sequence (P := RuleTower.process base up)
           (E := fun n => RuleTower.SameFrom n)
           (fun _ _ le _ _ same => RuleTower.SameFrom.mono same le)
           (fun _ a _ step => ⟨a, RuleTower.step_sameFrom a step⟩) reach with
       | ⟨n, held⟩ => ⟨n, t, held, inK', out⟩,
   fun held s inK input => match held s inK input with
     | ⟨_, t, reach, inK', out⟩ => ⟨t, Reach.of_heldMoves reach, inK', out⟩⟩

end Tower

/-! ## What can be done with the part at hand -/

section AtHand

variable {S : Type u} {A : Type v} {C : Type w} {X : Type} {P : Process S A} {part : S → C}
  {sub : S → X}

/-- **What can be done with the performing part at hand**: the substrate states reached from `s`
by the moves holding the performing part unchanged (`Reaching.PossibleHeld`). -/
def AtHand (P : Process S A) (part : S → C) (sub : S → X) (s : S) (y : X) : Prop :=
  Reaching.PossibleHeld P (fun s t => part t = part s) (fun t y => sub t = y) s y

/-- Delivered by the moves holding the performing part unchanged, some output of each presented
input can be had with the part at hand. -/
theorem Delivers.atHand {K : C → Prop} {T : X → X → Prop}
    (delivers : Delivers (Reaching.heldMoves P (fun s t => part t = part s)) part sub K T)
    {s : S} (inK : K (part s)) (input : Input T (sub s)) :
    ∃ y, T (sub s) y ∧ AtHand P part sub s y :=
  match delivers s inK input with
  | ⟨t, reach, _, out⟩ => ⟨sub t, out, t, reach, rfl⟩

/-- **What can be done with the part at hand grows only across steps changing the part**
(`Run.changes_of_heldGrows`). -/
theorem changes_of_atHandGrows (r : Run P) (n : Nat) {y : X}
    (grows : AtHand P part sub (r.state (n + 1)) y ∧ ¬ AtHand P part sub (r.state n) y) :
    part (r.state (n + 1)) ≠ part (r.state n) :=
  r.changes_of_heldGrows (Same := fun s t => part t = part s) (adm := fun t y => sub t = y) n grows

/-- **From the step at which the part stays for good, nothing is added to what can be done with
it** (`Run.possibleHeld_of_stays`). -/
theorem atHand_of_stays (r : Run P) {N : Nat}
    (stays : ∀ n, N ≤ n → part (r.state (n + 1)) = part (r.state n)) (d : Nat) {y : X}
    (later : AtHand P part sub (r.state (N + d)) y) : AtHand P part sub (r.state N) y :=
  r.possibleHeld_of_stays (Same := fun s t => part t = part s) (adm := fun t y => sub t = y)
    stays d later

/-- **What can be done with the part at hand keeps widening only where the part changes without
end** (`Run.changes_of_heldKeepsWidening`): from every step some bounded stretch of the course
changes it. -/
theorem changes_of_atHandKeepsWidening (r : Run P)
    (keeps : Reaching.KeepsWidening (fun n => AtHand P part sub (r.state n))) (N : Nat) :
    ∃ d, ¬ ∀ i, i < d → part (r.state (N + i + 1)) = part (r.state (N + i)) :=
  r.changes_of_heldKeepsWidening (Same := fun s t => part t = part s)
    (adm := fun t y => sub t = y) keeps N

/-- **What can be done with the part at hand does not keep widening where a list holds the
substrate states reachable from the course's start** (`Run.not_heldKeepsWidening_of_listed`). -/
theorem not_atHandKeepsWidening_of_listed (r : Run P)
    (listed : ∃ ys : List X, ∀ y, Reaching.Possible P (fun t y => sub t = y) (r.state 0) y →
      y ∈ ys) :
    ¬ Reaching.KeepsWidening (fun n => AtHand P part sub (r.state n)) :=
  r.not_heldKeepsWidening_of_listed (Same := fun s t => part t = part s) listed

end AtHand

/-! ## Witnesses -/

/-! ### A catalytic cycle: restored at the end, not held throughout -/

namespace Catalysis

/-- A configuration is an enzyme, free (`true`) or bound (`false`), and a molecule, the substrate
(`false`) or the product (`true`): the free enzyme binds the substrate, and the bound enzyme
releases the product and is free again. -/
def process : Process (Bool × Bool) Unit :=
  ⟨fun s _ t => (s = (true, false) ∧ t = (false, false)) ∨ (s = (false, false) ∧ t = (true, true))⟩

/-- The enzyme free. -/
def Free (e : Bool) : Prop := e = true

/-- The task: the substrate made the product. -/
def task (x y : Bool) : Prop := x = false ∧ y = true

/-- Bound and released, the free enzyme with the substrate reaches the free enzyme with the
product. -/
theorem reach_product : Reach process (true, false) (true, true) :=
  have binds : process.step (true, false) () (false, false) := .inl ⟨rfl, rfl⟩
  have releases : process.step (false, false) () (true, true) := .inr ⟨rfl, rfl⟩
  (Reach.of_step binds).trans (Reach.of_step releases)

/-- **The free enzyme performs the task**: it leaves its free form and is free again at the end. -/
theorem performs : Performs process Prod.fst Prod.snd Free task :=
  ⟨⟨⟨(true, false), rfl⟩, fun _ free _ ⟨_, isSubstrate, _⟩ =>
      ⟨(true, false), free.symm, isSubstrate.symm⟩⟩,
   fun _ free ⟨_, isSubstrate, _⟩ =>
     ⟨(true, true), Eq.subst (motive := fun u => Reach process u (true, true))
       (congr (congrArg Prod.mk free) isSubstrate).symm reach_product, rfl, isSubstrate, rfl⟩⟩

/-- **Held free at every move, the enzyme does not deliver**: the only move from the free enzyme
with the substrate binds it. -/
theorem not_held :
    ¬ Delivers (Reaching.heldMoves process (fun _ t => Free t.1)) Prod.fst Prod.snd Free task :=
  fun held => match held (true, false) rfl ⟨true, rfl, rfl⟩ with
  | ⟨_, ⟨_, .nil _⟩, _, _, isProduct⟩ => Bool.noConfusion isProduct
  | ⟨_, ⟨_, .cons ⟨.inl ⟨_, bound⟩, free⟩ _⟩, _, _⟩ =>
    Bool.noConfusion (Eq.subst (motive := fun u : Bool × Bool => u.1 = true) bound free)
  | ⟨_, ⟨_, .cons ⟨.inr ⟨atStart, _⟩, _⟩ _⟩, _, _⟩ =>
    Bool.noConfusion (congrArg Prod.fst atStart)

/-- The product stays the product. -/
theorem product_stays : Invariant process (fun s => s.2 = true) :=
  fun _ _ _ step product => match step with
  | .inl ⟨atStart, _⟩ => Bool.noConfusion ((congrArg Prod.snd atStart).symm.trans product)
  | .inr ⟨atStart, _⟩ => Bool.noConfusion ((congrArg Prod.snd atStart).symm.trans product)

/-- **The transpose is performed by no class of any reading of a performing part**: no course turns
the product back into the substrate. The task is possible and its transpose is not. -/
theorem transpose_not_possible {D : Type w} (part : Bool × Bool → D) :
    ¬ Possible process part Prod.snd (transpose task) :=
  fun ⟨K, ⟨⟨s₀, inK⟩, present⟩, delivers⟩ =>
    match present s₀ inK true ⟨false, rfl, rfl⟩ with
    | ⟨t, samePart, isProduct⟩ =>
      match delivers t (Eq.subst (motive := K) samePart.symm inK) ⟨false, rfl, isProduct⟩ with
      | ⟨_, reach, _, restored, _⟩ =>
        Bool.noConfusion ((product_stays.reach reach isProduct).symm.trans restored)

end Catalysis

/-! ### A coupled process: composition fails without the holding premise -/

namespace Coupled

/-- A configuration is a second performing part, on (`true`) or off (`false`), and a substrate, a
number: the substrate at `0` goes to `1` and sets the second part off, whatever it was; the
substrate at `1` goes to `2` with the second part on, which stays on. -/
def process : Process (Bool × Nat) Unit :=
  ⟨fun s _ t => (s.2 = 0 ∧ t = (false, 1)) ∨ (s = (true, 1) ∧ t = (true, 2))⟩

/-- The first task: `0` to `1`. -/
def first (x y : Nat) : Prop := x = 0 ∧ y = 1

/-- The second task: `1` to `2`. -/
def second (x y : Nat) : Prop := x = 1 ∧ y = 2

/-- The second part on. -/
def On (b : Bool) : Prop := b = true

/-- The first task is performed with a trivial performing part. -/
theorem performs_first : Performs process (fun _ => ()) Prod.snd (fun _ => True) first :=
  ⟨⟨⟨(false, 0), trivial⟩, fun s _ x _ => ⟨(s.1, x), rfl, rfl⟩⟩,
   fun s _ ⟨_, atZero, _⟩ =>
     have moves : process.step s () (false, 1) := .inl ⟨atZero, rfl⟩
     ⟨(false, 1), Reach.of_step moves, trivial, atZero, rfl⟩⟩

/-- The second task is performed by the second part on. -/
theorem performs_second : Performs process Prod.fst Prod.snd On second :=
  ⟨⟨⟨(true, 1), rfl⟩, fun _ on _ ⟨_, atOne, _⟩ => ⟨(true, 1), on.symm, atOne.symm⟩⟩,
   fun s on ⟨_, atOne, _⟩ =>
     have moves : process.step s () (true, 2) := .inr ⟨congr (congrArg Prod.mk on) atOne, rfl⟩
     ⟨(true, 2), Reach.of_step moves, rfl, atOne, rfl⟩⟩

/-- Every output of the first task is an input of the second. -/
theorem regular : Regular first second := fun _ _ ⟨_, isOne⟩ => ⟨2, isOne, rfl⟩

/-- From a substrate at `0`, the substrate stays at `0` or the configuration is the second part off
with the substrate at `1`. -/
theorem stays : Invariant process (fun s => s.2 = 0 ∨ s = (false, 1)) :=
  fun _ _ _ step held => match step, held with
  | .inl ⟨_, done⟩, _ => .inr done
  | .inr ⟨atOne, _⟩, .inl atZero =>
    Nat.noConfusion ((congrArg Prod.snd atOne).symm.trans atZero)
  | .inr ⟨atOne, _⟩, .inr off =>
    Bool.noConfusion ((congrArg Prod.fst atOne).symm.trans (congrArg Prod.fst off))

/-- From a substrate at `0`, no course reaches the substrate at `2`. -/
theorem not_two {s t : Bool × Nat} (reach : Reach process s t) (atZero : s.2 = 0) : t.2 ≠ 2 :=
  fun atTwo => match stays.reach reach (.inl atZero) with
  | .inl zero => Nat.noConfusion (atTwo.symm.trans zero)
  | .inr off => Nat.noConfusion (Nat.succ.inj ((congrArg Prod.snd off).symm.trans atTwo).symm)

/-- **The first task then the second is performed by no class of any reading of a performing
part**: presented with the substrate at `0`, no course reaches `2`. -/
theorem not_possible {D : Type w} (part : Bool × Nat → D) :
    ¬ Possible process part Prod.snd (serial first second) :=
  fun ⟨K, ⟨⟨s₀, inK⟩, present⟩, delivers⟩ =>
    have input : Input (serial first second) 0 := ⟨2, 1, ⟨rfl, rfl⟩, rfl, rfl⟩
    match present s₀ inK 0 input with
    | ⟨t, samePart, atZero⟩ =>
      match delivers t (Eq.subst (motive := K) samePart.symm inK)
          (Eq.subst (motive := Input (serial first second)) atZero.symm input) with
      | ⟨_, reach, _, _, _, isTwo⟩ => not_two reach atZero isTwo.2

/-- **The first task's moves do not hold the second part**: delivered by moves holding it, the first
task is not delivered from the second part on. -/
theorem not_holding :
    ¬ Delivers (Reaching.heldMoves process (fun s t => t.1 = s.1)) (fun _ => ()) Prod.snd
      (fun _ => True) first :=
  fun held => match held (true, 0) trivial ⟨1, rfl, rfl⟩ with
  | ⟨_, ⟨_, .nil _⟩, _, _, isOne⟩ => Nat.noConfusion isOne.symm
  | ⟨_, ⟨_, .cons ⟨.inl ⟨_, off⟩, kept⟩ _⟩, _, _⟩ =>
    Bool.noConfusion ((congrArg Prod.fst off).symm.trans kept)
  | ⟨_, ⟨_, .cons ⟨.inr ⟨atOne, _⟩, _⟩ _⟩, _, _⟩ =>
    Nat.noConfusion (congrArg Prod.snd atOne).symm

/-- **Composition fails without the holding premise**: the first task is performed with a trivial
performing part and the second by the second part on, every output of the first is an input of the
second, and the first then the second is performed by no class of any reading of a performing part.
Deutsch's composition principle, every regular network of possible tasks is a possible task, is so
a premise about the process. -/
theorem composition_fails :
    Performs process (fun _ => ()) Prod.snd (fun _ => True) first ∧
      Performs process Prod.fst Prod.snd On second ∧ Regular first second ∧
      ∀ (D : Type w) (part : Bool × Nat → D), ¬ Possible process part Prod.snd (serial first second) :=
  ⟨performs_first, performs_second, regular, fun _ part => not_possible part⟩

end Coupled

/-! ### A conserved amount: a possible whole of impossible parts, and the division -/

namespace Conserved

/-- Two substrates, each holding a unit (`true`) or none (`false`): a move passes the unit from one
to the other, so the two together keep their amount. -/
def process : Process (Bool × Bool) Unit :=
  ⟨fun s _ t => (s = (false, true) ∧ t = (true, false)) ∨ (s = (true, false) ∧ t = (false, true))⟩

/-- Raising a substrate by one unit. -/
def raise (x y : Bool) : Prop := x = false ∧ y = true

/-- Lowering a substrate by one unit. -/
def lower (x y : Bool) : Prop := x = true ∧ y = false

/-- The two together hold one unit. -/
def one : Bool × Bool → Bool
  | (false, b) => b
  | (true, b) => !b

/-- Both substrates empty, nothing moves. -/
theorem empty_stays : Invariant process (fun s => s = (false, false)) :=
  fun _ _ _ step empty => match step with
  | .inl ⟨atStart, _⟩ => Bool.noConfusion (congrArg Prod.snd (atStart.symm.trans empty))
  | .inr ⟨atStart, _⟩ => Bool.noConfusion (congrArg Prod.fst (atStart.symm.trans empty))

/-- Both substrates full, nothing moves. -/
theorem full_stays : Invariant process (fun s => s = (true, true)) :=
  fun _ _ _ step full => match step with
  | .inl ⟨atStart, _⟩ => Bool.noConfusion (congrArg Prod.fst (atStart.symm.trans full))
  | .inr ⟨atStart, _⟩ => Bool.noConfusion (congrArg Prod.snd (atStart.symm.trans full))

/-- The unit passes between the two. -/
theorem one_stays : Invariant process (fun s => s = (false, true) ∨ s = (true, false)) :=
  fun _ _ _ step _ => match step with
  | .inl ⟨_, done⟩ => .inr done
  | .inr ⟨_, done⟩ => .inl done

/-- From the first empty, a reached configuration with the first full has the second empty. -/
theorem second_empty_of_raised :
    ∀ {t u : Bool × Bool}, t.1 = false → Reach process t u → u.1 = true → u.2 = false
  | (false, false), _, _, reach, _ => congrArg Prod.snd (empty_stays.reach reach rfl)
  | (false, true), _, _, reach, raised => match one_stays.reach reach (.inl rfl) with
    | .inl atStart => Bool.noConfusion (raised.symm.trans (congrArg Prod.fst atStart))
    | .inr done => congrArg Prod.snd done
  | (true, _), _, empty, _, _ => Bool.noConfusion empty

/-- From the second full, a reached configuration with the second empty has the first full. -/
theorem first_full_of_lowered :
    ∀ {t u : Bool × Bool}, t.2 = true → Reach process t u → u.2 = false → u.1 = true
  | (true, true), _, _, reach, lowered =>
    Bool.noConfusion ((congrArg Prod.snd (full_stays.reach reach rfl)).symm.trans lowered)
  | (false, true), _, _, reach, lowered => match one_stays.reach reach (.inl rfl) with
    | .inl atStart => Bool.noConfusion ((congrArg Prod.snd atStart).symm.trans lowered)
    | .inr done => congrArg Prod.fst done
  | (_, false), _, full, _, _ => Bool.noConfusion full

/-- The two in parallel, the first raised and the second lowered, are performed with a trivial
performing part. -/
theorem performs_both : Performs process (fun _ => ()) id (fun _ => True) (parallel raise lower) :=
  ⟨⟨⟨(false, true), trivial⟩, fun _ _ p _ => ⟨p, rfl, rfl⟩⟩,
   fun s _ ⟨_, ⟨isEmpty, _⟩, isFull, _⟩ =>
     have moves : process.step s () (true, false) :=
       .inl ⟨congr (congrArg Prod.mk isEmpty) isFull, rfl⟩
     ⟨(true, false), Reach.of_step moves, trivial, ⟨isEmpty, rfl⟩, isFull, rfl⟩⟩

/-- **No reading of the second substrate performs raising the first**: from both empty nothing
moves, and from the second full the unit passes, leaving the second empty. -/
theorem not_raise {D : Type w} (f : Bool → D) :
    ¬ Possible process (fun s => f s.2) Prod.fst raise :=
  fun ⟨K, ⟨⟨s₀, inK⟩, present⟩, delivers⟩ =>
    have emptyFails : ¬ K (f false) := fun inEmpty =>
      match delivers (false, false) inEmpty ⟨true, rfl, rfl⟩ with
      | ⟨_, reach, _, _, raised⟩ =>
        Bool.noConfusion ((congrArg Prod.fst (empty_stays.reach reach rfl)).symm.trans raised)
    match present s₀ inK false ⟨true, rfl, rfl⟩ with
    | ⟨t, samePart, isEmpty⟩ =>
      match delivers t (Eq.subst (motive := K) samePart.symm inK) ⟨true, isEmpty, rfl⟩ with
      | ⟨_, reach, inKu, _, raised⟩ =>
        emptyFails (Eq.subst (motive := fun b => K (f b))
          (second_empty_of_raised isEmpty reach raised) inKu)

/-- **No reading of the first substrate performs lowering the second**: from both full nothing
moves, and from the first empty the unit passes, leaving the first full. -/
theorem not_lower {D : Type w} (f : Bool → D) :
    ¬ Possible process (fun s => f s.1) Prod.snd lower :=
  fun ⟨K, ⟨⟨s₀, inK⟩, present⟩, delivers⟩ =>
    have fullFails : ¬ K (f true) := fun inFull =>
      match delivers (true, true) inFull ⟨false, rfl, rfl⟩ with
      | ⟨_, reach, _, _, lowered⟩ =>
        Bool.noConfusion ((congrArg Prod.snd (full_stays.reach reach rfl)).symm.trans lowered)
    match present s₀ inK true ⟨false, rfl, rfl⟩ with
    | ⟨t, samePart, isFull⟩ =>
      match delivers t (Eq.subst (motive := K) samePart.symm inK) ⟨false, isFull, rfl⟩ with
      | ⟨_, reach, inKu, _, lowered⟩ =>
        fullFails (Eq.subst (motive := fun b => K (f b))
          (first_full_of_lowered isFull reach lowered) inKu)

/-- **No reading of the first substrate itself performs raising it**: presented with the first
empty, its reading is the one it has with both empty, from which nothing moves. -/
theorem not_raise_alone {D : Type w} (f : Bool → D) :
    ¬ Possible process (fun s => f s.1) Prod.fst raise :=
  fun ⟨K, ⟨⟨s₀, inK⟩, present⟩, delivers⟩ =>
    match present s₀ inK false ⟨true, rfl, rfl⟩ with
    | ⟨_, samePart, isEmpty⟩ =>
      have inEmpty : K (f false) := Eq.subst (motive := fun b => K (f b)) isEmpty
        (Eq.subst (motive := K) samePart.symm inK)
      match delivers (false, false) inEmpty ⟨true, rfl, rfl⟩ with
      | ⟨_, reach, _, _, raised⟩ =>
        Bool.noConfusion ((congrArg Prod.fst (empty_stays.reach reach rfl)).symm.trans raised)

/-- **A possible whole of impossible parts**: the first raised and the second lowered, in parallel,
are possible; raising the first is performed by no class of any reading of the second substrate,
and lowering the second by none of any reading of the first. -/
theorem whole_of_impossible_parts {D : Type w} :
    Possible process (fun _ => ()) id (parallel raise lower) ∧
      (∀ f : Bool → D, ¬ Possible process (fun s => f s.2) Prod.fst raise) ∧
      (∀ f : Bool → D, ¬ Possible process (fun s => f s.1) Prod.snd lower) :=
  ⟨⟨_, performs_both⟩, not_raise, not_lower⟩

/-- **The division matters**: with the performing part read as the two together holding one unit,
raising the first is possible, since that reading stays as it is while the unit passes. -/
theorem possible_with_one : Performs process one Prod.fst (fun c => c = true) raise :=
  ⟨⟨⟨(false, true), rfl⟩, fun _ held _ ⟨_, isEmpty, _⟩ => ⟨(false, true), held.symm, isEmpty.symm⟩⟩,
   fun s held ⟨_, isEmpty, _⟩ => match s, held, isEmpty with
     | (false, true), _, _ =>
       have moves : process.step (false, true) () (true, false) := .inl ⟨rfl, rfl⟩
       ⟨(true, false), Reach.of_step moves, rfl, rfl, rfl⟩
     | (false, false), held, _ => Bool.noConfusion held
     | (true, _), _, isEmpty => Bool.noConfusion isEmpty⟩

end Conserved

/-! ### A tower changing every level at once: the regress fails -/

namespace FlipTower

/-- **The tower changing every level at once** (`RuleTower.synchronous`): at every move the
substrate flips, and so does the performer at every level. -/
def process : Process (Bool × (Nat → Bool)) Unit :=
  RuleTower.synchronous (fun _ z z' => z' = !z) (fun _ _ r r' => r' = !r)

/-- The performers at every level alike. -/
def Alike (rules : Nat → Bool) : Prop := ∀ k, rules k = rules 0

/-- The task: the substrate from `false` to `true`. -/
def task (x y : Bool) : Prop := x = false ∧ y = true

/-- **The performers alike perform the task**, flipping with the substrate. -/
theorem performs : Performs process Prod.snd Prod.fst Alike task :=
  ⟨⟨⟨(false, fun _ => false), fun _ => rfl⟩, fun s _ _ ⟨_, atFalse, _⟩ =>
      ⟨(false, s.2), rfl, atFalse.symm⟩⟩,
   fun s alike ⟨_, atFalse, _⟩ =>
     have moves : process.step s () (!s.1, fun k => !(s.2 k)) := ⟨rfl, fun _ => rfl⟩
     ⟨(!s.1, fun k => !(s.2 k)), Reach.of_step moves, fun k => congrArg (fun b => !b) (alike k),
      atFalse, congrArg (fun b => !b) atFalse⟩⟩

/-- **No delivery holds the performers from any level up**: every move changes the performer at
every level. -/
theorem not_held (n : Nat) :
    ¬ Delivers (Reaching.heldMoves process (RuleTower.SameFrom n)) Prod.snd Prod.fst Alike task :=
  fun held => match held (false, fun _ => false) (fun _ => rfl) ⟨true, rfl, rfl⟩ with
  | ⟨_, ⟨_, .nil _⟩, _, _, atTrue⟩ => Bool.noConfusion atTrue
  | ⟨_, ⟨_, .cons ⟨⟨_, flipped⟩, same⟩ _⟩, _, _⟩ =>
    Bool.noConfusion ((same n (Nat.le_refl n)).symm.trans (flipped n))

end FlipTower

end Tasks

end Becoming
