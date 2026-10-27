import Becoming.Tasks

/-!
# Review probes for `Becoming.Tasks` (UE12)

AI-written probes for REVIEW-UE12.md, not for landing. Each block tests one finding; the finding's
number is in the block's heading. Pure Lean, prelude only, built with `scratch_build.py`.
-/

namespace Becoming

open Generative

universe u v w w' u' v'

namespace Tasks

namespace Probe

/-! ## F7. `serial` and `transpose` are the grammar's `«而»` and `«逆»`, by definition -/

theorem serial_iff_er {X : Type} {T T' : X → X → Prop} {x z : X} :
    serial T T' x z ↔ «而» T T' x z := Iff.rfl

theorem transpose_iff_ni {X : Type} {T : X → X → Prop} {x y : X} :
    transpose T x y ↔ «逆» T x y := Iff.rfl

/-! ## F3. No halting: a counter performs, invariably, every task whose outputs lie ahead -/

namespace Counter

/-- Counting up: every move adds one. -/
def process : Process Nat Unit := ⟨fun s _ t => t = s + 1⟩

/-- Each configuration has at most one next configuration. -/
theorem oneNext : ∀ s a t a' t', process.step s a t → process.step s a' t' → t = t' :=
  fun _ _ _ _ _ first second => first.trans second.symm

theorem reach_add (x : Nat) : ∀ d, Reach process x (x + d)
  | 0 => Reach.refl process x
  | d + 1 => (reach_add x d).trans (Reach.of_step (a := ()) rfl)

/-- **Every task taking each count to itself plus any amount is performed, with no performing
part.** -/
theorem performs (g : Nat → Nat) :
    Performs process (fun _ => ()) id (fun _ => True) (fun x y => y = x + g x) :=
  ⟨⟨⟨0, trivial⟩, fun _ _ x _ => ⟨x, rfl, rfl⟩⟩,
   fun s _ _ => ⟨s + g s, reach_add s (g s), trivial, rfl⟩⟩

/-- **And invariably, in `Delivers.invariably`'s sense**: every course from the input passes the
output. -/
theorem invariably (g : Nat → Nat) (x : Nat) :
    ∃ t, True ∧ t = x + g x ∧ ∀ r : Run process, r.state 0 = x → ∃ n, r.state n = t :=
  Delivers.invariably oneNext (performs g).2 (s := x) trivial ⟨_, rfl⟩

/-- Every move changes the count. -/
theorem moves_change : ∀ s a t, process.step s a t → t ≠ s :=
  fun s _ _ step same => Nat.succ_ne_self s (step.symm.trans same)

/-- **The identity task is performed though every move changes the count**: delivery at zero
moves. -/
theorem performs_identity : Performs process (fun _ => ()) id (fun _ => True) (fun x y => y = x) :=
  performs (fun _ => 0)

end Counter

/-- **On every process, an identity task is performed with no performing part**, at zero moves,
wherever each of its states is had. -/
theorem performs_identity {S : Type u} {A : Type v} {X : Type} {P : Process S A} {sub : S → X}
    {I : X → Prop} (inhabited : ∃ _ : S, True) (had : ∀ x, I x → ∃ s, sub s = x) :
    Performs P (fun _ => ()) sub (fun _ => True) (fun x y => I x ∧ y = x) :=
  ⟨⟨match inhabited with | ⟨s, _⟩ => ⟨s, trivial⟩,
    fun _ _ x ⟨_, inI, _⟩ => match had x inI with | ⟨t, same⟩ => ⟨t, rfl, same⟩⟩,
   fun s _ ⟨_, inI, _⟩ => ⟨s, Reach.refl P s, trivial, inI, rfl⟩⟩

/-! ## F4. `Delivers.invariably`'s conclusion does not say the configuration is reached -/

namespace Stuck

/-- No moves. -/
def process : Process Bool Unit := ⟨fun _ _ _ => False⟩

/-- `false` to `true`. -/
def task (x y : Bool) : Prop := x = false ∧ y = true

/-- **The conclusion form of `Delivers.invariably` holds of a configuration never reached**, and the
task is not delivered: with no course at all, "every course passes `true`" holds vacuously. -/
theorem conclusion_without_reach :
    (∃ t : Bool, True ∧ task false t ∧ ∀ r : Run process, r.state 0 = false → ∃ n, r.state n = t) ∧
      ¬ Reach process false true ∧ ¬ Delivers process id id (fun _ => True) task :=
  ⟨⟨true, trivial, ⟨rfl, rfl⟩, fun r _ => False.elim (r.step 0)⟩,
   fun ⟨_, trace⟩ => match trace with
     | .cons step _ => step,
   fun delivers => match delivers false trivial ⟨true, rfl, rfl⟩ with
     | ⟨_, ⟨_, .nil _⟩, _, _, atTrue⟩ => Bool.noConfusion atTrue
     | ⟨_, ⟨_, .cons step _⟩, _, _⟩ => step⟩

end Stuck

/-- **`Delivers.invariably` with the delivered configuration reached** (the suggested statement). -/
theorem invariably_reached {S : Type u} {A : Type v} {C : Type w} {X : Type} {P : Process S A}
    {part : S → C} {sub : S → X} {K : C → Prop} {T : X → X → Prop}
    (oneNext : ∀ s a t a' t', P.step s a t → P.step s a' t' → t = t')
    (delivers : Delivers P part sub K T) {s : S} (inK : K (part s)) (input : Input T (sub s)) :
    ∃ t, Reach P s t ∧ K (part t) ∧ T (sub s) (sub t) ∧
      ∀ r : Run P, r.state 0 = s → ∃ n, r.state n = t :=
  match delivers s inK input with
  | ⟨t, ⟨as, trace⟩, inK', out⟩ => ⟨t, ⟨as, trace⟩, inK', out, fun r start =>
      match on_every_run oneNext trace r 0 start with
      | ⟨n, passes⟩ => ⟨n, Eq.subst (motive := fun j => r.state j = t) (Nat.zero_add n) passes⟩⟩

/-! ## F8. One part under two classes: the coupled process, read with the second part alone -/

/-- **The second part performs the first task too**, with the class of all its states. -/
theorem coupled_first_by_part :
    Performs Coupled.process Prod.fst Prod.snd (fun _ => True) Coupled.first :=
  ⟨⟨⟨(false, 0), trivial⟩, fun s _ x _ => ⟨(s.1, x), rfl, rfl⟩⟩,
   fun s _ ⟨_, atZero, _⟩ =>
     have moves : Coupled.process.step s () (false, 1) := .inl ⟨atZero, rfl⟩
     ⟨(false, 1), Reach.of_step moves, trivial, atZero, rfl⟩⟩

/-- **One part reused under two classes does not compose**: the same part performs the first task
(every state) and the second (on), the pair is regular, and the first then the second is
performed by no class of it. -/
theorem one_part_two_classes :
    Performs Coupled.process Prod.fst Prod.snd (fun _ => True) Coupled.first ∧
      Performs Coupled.process Prod.fst Prod.snd Coupled.On Coupled.second ∧
      Regular Coupled.first Coupled.second ∧
      ¬ Possible Coupled.process Prod.fst Prod.snd (serial Coupled.first Coupled.second) :=
  ⟨coupled_first_by_part, Coupled.performs_second, Coupled.regular, Coupled.not_possible Prod.fst⟩

/-! ## F9. The holding premise is sufficient, not needed: restored at the end suffices -/

namespace CatalysedSerial

/-- A configuration is an enzyme, free (`true`) or bound (`false`), and a count: the free enzyme
binds at `0`, the bound enzyme is released with the count at `1`, and the free enzyme moves the
count from `1` to `2`. -/
def process : Process (Bool × Nat) Unit :=
  ⟨fun s _ t => (s = (true, 0) ∧ t = (false, 0)) ∨ (s = (false, 0) ∧ t = (true, 1)) ∨
    (s = (true, 1) ∧ t = (true, 2))⟩

/-- **The first task is not delivered by moves holding the enzyme**: from the free enzyme at `0`
the only move binds it. So `Delivers.serial_holding`'s first premise fails. -/
theorem not_holding :
    ¬ Delivers (Reaching.heldMoves process (fun s t => t.1 = s.1)) (fun _ => ()) Prod.snd
      (fun _ => True) Coupled.first :=
  fun held => match held (true, 0) trivial ⟨1, rfl, rfl⟩ with
  | ⟨_, ⟨_, .nil _⟩, _, _, isOne⟩ => Nat.noConfusion isOne.symm
  | ⟨_, ⟨_, .cons ⟨.inl ⟨_, bound⟩, kept⟩ _⟩, _, _⟩ =>
    Bool.noConfusion ((congrArg Prod.fst bound).symm.trans kept)
  | ⟨_, ⟨_, .cons ⟨.inr (.inl ⟨atStart, _⟩), _⟩ _⟩, _, _⟩ =>
    Bool.noConfusion (congrArg Prod.fst atStart)
  | ⟨_, ⟨_, .cons ⟨.inr (.inr ⟨atStart, _⟩), _⟩ _⟩, _, _⟩ =>
    Nat.noConfusion (congrArg Prod.snd atStart)

/-- **Yet the trivial part and the free enzyme together perform the first task then the
second**: the enzyme is restored at the end of the first delivery. -/
theorem performs_pair :
    Performs process (fun s => ((), s.1)) Prod.snd (fun c => True ∧ c.2 = true)
      (serial Coupled.first Coupled.second) :=
  ⟨⟨⟨(true, 0), trivial, rfl⟩, fun s _ x _ => ⟨(s.1, x), rfl, rfl⟩⟩,
   fun s inK ⟨_, _, ⟨atZero, _⟩, _⟩ =>
     have isStart : s = (true, 0) := congr (congrArg Prod.mk inK.2) atZero
     have binds : process.step (true, 0) () (false, 0) := .inl ⟨rfl, rfl⟩
     have releases : process.step (false, 0) () (true, 1) := .inr (.inl ⟨rfl, rfl⟩)
     have moves : process.step (true, 1) () (true, 2) := .inr (.inr ⟨rfl, rfl⟩)
     have reach : Reach process (true, 0) (true, 2) :=
       ((Reach.of_step binds).trans (Reach.of_step releases)).trans (Reach.of_step moves)
     ⟨(true, 2), Eq.subst (motive := fun x => Reach process x (true, 2)) isStart.symm reach,
      ⟨trivial, rfl⟩, 1, ⟨atZero, rfl⟩, rfl, rfl⟩⟩

end CatalysedSerial

/-! ## F10. One composition law below, the two-class laws its instances at the pair class -/

section General

variable {S : Type u} {A : Type v} {C : Type w} {D : Type w'} {X Y : Type}
  {P : Process S A} {part : S → C} {sub : S → X} {K : C → Prop} {T T' : X → X → Prop}

/-- **One class delivering a regular pair delivers it in series**: the delivery half of
`Performs.serial`, which uses only the second task's delivery. -/
theorem delivers_inSeries (first : Delivers P part sub K T) (second : Delivers P part sub K T')
    (regular : Regular T T') : Delivers P part sub K (serial T T') :=
  fun s inK ⟨_, y, out, _⟩ => match first s inK ⟨y, out⟩ with
    | ⟨t, reach, inK', out'⟩ => match second t inK' (regular _ _ out') with
      | ⟨u, reach', inK'', out''⟩ => ⟨u, reach.trans reach', inK'', sub t, out', out''⟩

/-- `Performs.serial` with the second task only delivered. -/
theorem performs_inSeries (first : Performs P part sub K T) (second : Delivers P part sub K T')
    (regular : Regular T T') : Performs P part sub K (serial T T') :=
  ⟨⟨first.1.1, fun s inK x ⟨_, y, out, _⟩ => first.1.2 s inK x ⟨y, out⟩⟩,
   delivers_inSeries first.2 second regular⟩

/-- Delivered by moves holding another reading, a task is delivered by the pair class, any class
of that reading kept. -/
theorem delivers_pair_left {part' : S → D} {L : D → Prop}
    (held : Delivers (Reaching.heldMoves P (fun s t => part' t = part' s)) part sub K T) :
    Delivers P (fun s => (part s, part' s)) sub (fun c => K c.1 ∧ L c.2) T :=
  fun s inKL input => match held s inKL.1 input with
    | ⟨t, reach, inK, out⟩ =>
      have kept : part' t = part' s := Reach.same_of_heldMoves (sameReading_class part') reach
      ⟨t, Reach.of_heldMoves reach, ⟨inK, Eq.subst (motive := L) kept.symm inKL.2⟩, out⟩

theorem delivers_pair_right {part' : S → D} {L : D → Prop}
    (held : Delivers (Reaching.heldMoves P (fun s t => part t = part s)) part' sub L T') :
    Delivers P (fun s => (part s, part' s)) sub (fun c => K c.1 ∧ L c.2) T' :=
  fun s inKL input => match held s inKL.2 input with
    | ⟨t, reach, inL, out⟩ =>
      have kept : part t = part s := Reach.same_of_heldMoves (sameReading_class part) reach
      ⟨t, Reach.of_heldMoves reach, ⟨Eq.subst (motive := K) kept.symm inKL.1, inL⟩, out⟩

/-- **`Delivers.serial_holding`, as the one-class law at the pair class.** -/
theorem serial_holding_derived {part' : S → D} {L : D → Prop}
    (first : Delivers (Reaching.heldMoves P (fun s t => part' t = part' s)) part sub K T)
    (second : Delivers (Reaching.heldMoves P (fun s t => part t = part s)) part' sub L T')
    (regular : Regular T T') :
    Delivers P (fun s => (part s, part' s)) sub (fun c => K c.1 ∧ L c.2) (serial T T') :=
  delivers_inSeries (delivers_pair_left first) (delivers_pair_right second) regular

theorem delivers_pair_left_holding {part' : S → D} {sub' : S → Y} {L : D → Prop}
    (held : Delivers (Reaching.heldMoves P (fun s t => (part' t, sub' t) = (part' s, sub' s)))
      part sub K T) :
    Delivers (Reaching.heldMoves P (fun s t => sub' t = sub' s)) (fun s => (part s, part' s)) sub
      (fun c => K c.1 ∧ L c.2) T :=
  fun s inKL input => match held s inKL.1 input with
    | ⟨t, reach, inK, out⟩ =>
      have kept : (part' t, sub' t) = (part' s, sub' s) :=
        Reach.same_of_heldMoves (sameReading_class fun s => (part' s, sub' s)) reach
      ⟨t, Reach.heldMoves_mono (fun _ _ same => (congrArg Prod.snd same : sub' _ = sub' _)) reach,
       ⟨inK, Eq.subst (motive := L) (congrArg Prod.fst kept : part' t = part' s).symm inKL.2⟩, out⟩

theorem delivers_pair_right_holding {part' : S → D} {sub' : S → Y} {L : D → Prop}
    {T₂ : Y → Y → Prop}
    (held : Delivers (Reaching.heldMoves P (fun s t => (part t, sub t) = (part s, sub s)))
      part' sub' L T₂) :
    Delivers (Reaching.heldMoves P (fun s t => sub t = sub s)) (fun s => (part s, part' s)) sub'
      (fun c => K c.1 ∧ L c.2) T₂ :=
  fun s inKL input => match held s inKL.2 input with
    | ⟨t, reach, inL, out⟩ =>
      have kept : (part t, sub t) = (part s, sub s) :=
        Reach.same_of_heldMoves (sameReading_class fun s => (part s, sub s)) reach
      ⟨t, Reach.heldMoves_mono (fun _ _ same => (congrArg Prod.snd same : sub _ = sub _)) reach,
       ⟨Eq.subst (motive := K) (congrArg Prod.fst kept : part t = part s).symm inKL.1, inL⟩, out⟩

/-- **`Delivers.parallel_holding`, as `Delivers.parallel_reuse` at the pair class.** -/
theorem parallel_holding_derived {part' : S → D} {sub' : S → Y} {L : D → Prop}
    {T₂ : Y → Y → Prop}
    (first : Delivers (Reaching.heldMoves P (fun s t => (part' t, sub' t) = (part' s, sub' s)))
      part sub K T)
    (second : Delivers (Reaching.heldMoves P (fun s t => (part t, sub t) = (part s, sub s)))
      part' sub' L T₂) :
    Delivers P (fun s => (part s, part' s)) (fun s => (sub s, sub' s)) (fun c => K c.1 ∧ L c.2)
      (parallel T T₂) :=
  Delivers.parallel_reuse (delivers_pair_left_holding first) (delivers_pair_right_holding second)

end General

/-! ## F2. Within an interleaving on one substrate, the composition principle can fail -/

namespace InterleavedCoupled

/-- A performing part that never moves. -/
def idle : Process (Unit × Nat) Unit := ⟨fun _ _ _ => False⟩

/-- The idle part and the coupled process's part interleaved on one count. -/
def process : Process ((Unit × Bool) × Nat) (Unit ⊕ Unit) := interleaveOn idle Coupled.process

/-- The first task is possible with the first part's division: the second's moves deliver it. -/
theorem first_possible : Possible process (fun s => s.1.1) (fun s => s.2) Coupled.first :=
  ⟨fun _ => True,
   ⟨⟨(((), false), 0), trivial⟩, fun s _ x _ => ⟨(s.1, x), rfl, rfl⟩⟩,
   fun s _ ⟨_, atZero, _⟩ =>
     have moves : process.step s (.inr ()) ((s.1.1, false), 1) := ⟨.inl ⟨atZero, rfl⟩, rfl⟩
     ⟨((s.1.1, false), 1), Reach.of_step moves, trivial, atZero, rfl⟩⟩

/-- The second task is possible with the second part's division. -/
theorem second_possible : Possible process (fun s => s.1.2) (fun s => s.2) Coupled.second :=
  ⟨Coupled.On,
   ⟨⟨(((), true), 1), rfl⟩, fun s _ x _ => ⟨(s.1, x), rfl, rfl⟩⟩,
   fun s on ⟨_, atOne, _⟩ =>
     have moves : process.step s (.inr ()) ((s.1.1, true), 2) :=
       ⟨.inr ⟨congr (congrArg Prod.mk on) atOne, rfl⟩, rfl⟩
     ⟨((s.1.1, true), 2), Reach.of_step moves, rfl, atOne, rfl⟩⟩

/-- From a count at `0`, the count stays at `0`, or the second part is off with the count at `1`. -/
theorem stays : Invariant process (fun s => s.2 = 0 ∨ (s.1.2 = false ∧ s.2 = 1)) :=
  fun _ a _ step held => match a, step, held with
  | .inl _, step, _ => False.elim step.1
  | .inr _, ⟨.inl ⟨_, done⟩, _⟩, _ =>
    .inr ⟨(congrArg Prod.fst done : _), (congrArg Prod.snd done : _)⟩
  | .inr _, ⟨.inr ⟨atOne, _⟩, _⟩, .inl atZero =>
    Nat.noConfusion ((congrArg Prod.snd atOne).symm.trans atZero)
  | .inr _, ⟨.inr ⟨atOne, _⟩, _⟩, .inr ⟨off, _⟩ =>
    Bool.noConfusion ((congrArg Prod.fst atOne).symm.trans off)

theorem not_two {s t : (Unit × Bool) × Nat} (reach : Reach process s t) (atZero : s.2 = 0) :
    t.2 ≠ 2 :=
  fun atTwo => match stays.reach reach (.inl atZero) with
  | .inl zero => Nat.noConfusion (atTwo.symm.trans zero)
  | .inr ⟨_, one⟩ => Nat.noConfusion (Nat.succ.inj (one.symm.trans atTwo))

theorem not_possible {D : Type} (part : (Unit × Bool) × Nat → D) :
    ¬ Possible process part (fun s => s.2) (serial Coupled.first Coupled.second) :=
  fun ⟨K, ⟨⟨s₀, inK⟩, present⟩, delivers⟩ =>
    have input : Input (serial Coupled.first Coupled.second) 0 := ⟨2, 1, ⟨rfl, rfl⟩, rfl, rfl⟩
    match present s₀ inK 0 input with
    | ⟨t, samePart, atZero⟩ =>
      match delivers t (Eq.subst (motive := K) samePart.symm inK)
          (Eq.subst (motive := Input (serial Coupled.first Coupled.second)) atZero.symm input) with
      | ⟨_, reach, _, _, _, isTwo⟩ => not_two reach atZero isTwo.2

/-- **Within `interleaveOn`, two possible tasks, each with its own part's division, form a regular
pair whose composite no reading performs.** -/
theorem composition_fails_within :
    Possible process (fun s => s.1.1) (fun s => s.2) Coupled.first ∧
      Possible process (fun s => s.1.2) (fun s => s.2) Coupled.second ∧
      Regular Coupled.first Coupled.second ∧
      ∀ (D : Type) (part : (Unit × Bool) × Nat → D),
        ¬ Possible process part (fun s => s.2) (serial Coupled.first Coupled.second) :=
  ⟨first_possible, second_possible, Coupled.regular, fun _ part => not_possible part⟩

end InterleavedCoupled

/-! ## F2. Within an interleaving on two substrates, it holds for divisions read off each process -/

section Projection

variable {S : Type u} {A : Type v} {S' : Type u'} {A' : Type v'} {C : Type w} {D : Type w'}
  {X Y : Type} {P : Process S A} {Q : Process S' A'}

theorem reach_interleave_fst :
    ∀ {s t : S × S'} {as : List (A ⊕ A')}, Trace (interleave P Q) s as t → Reach P s.1 t.1
  | _, _, _, .nil _ => Reach.refl _ _
  | _, _, _, @Trace.cons _ _ _ _ _ _ (.inl _) _ step rest =>
    (Reach.of_step step.1).trans (reach_interleave_fst rest)
  | _, t, _, @Trace.cons _ _ _ _ _ _ (.inr _) _ step rest =>
    Eq.subst (motive := fun x => Reach P x t.1) step.2 (reach_interleave_fst rest)

theorem reach_interleave_snd :
    ∀ {s t : S × S'} {as : List (A ⊕ A')}, Trace (interleave P Q) s as t → Reach Q s.2 t.2
  | _, _, _, .nil _ => Reach.refl _ _
  | _, t, _, @Trace.cons _ _ _ _ _ _ (.inl _) _ step rest =>
    Eq.subst (motive := fun x => Reach Q x t.2) step.2 (reach_interleave_snd rest)
  | _, _, _, @Trace.cons _ _ _ _ _ _ (.inr _) _ step rest =>
    (Reach.of_step step.1).trans (reach_interleave_snd rest)

theorem possible_of_interleave_left {part : S → C} {sub : S → X} {T : X → X → Prop}
    (possible : Possible (interleave P Q) (fun s => part s.1) (fun s => sub s.1) T) :
    Possible P part sub T :=
  match possible with
  | ⟨K, ⟨⟨s₀, inK⟩, present⟩, delivers⟩ =>
    ⟨K, ⟨⟨s₀.1, inK⟩, fun s inK' x input => match present (s, s₀.2) inK' x input with
        | ⟨t, samePart, sameSub⟩ => ⟨t.1, samePart, sameSub⟩⟩,
     fun s inK' input => match delivers (s, s₀.2) inK' input with
        | ⟨t, ⟨_, trace⟩, inKt, out⟩ => ⟨t.1, reach_interleave_fst trace, inKt, out⟩⟩

theorem possible_of_interleave_right {part : S' → D} {sub : S' → Y} {T : Y → Y → Prop}
    (possible : Possible (interleave P Q) (fun s => part s.2) (fun s => sub s.2) T) :
    Possible Q part sub T :=
  match possible with
  | ⟨K, ⟨⟨s₀, inK⟩, present⟩, delivers⟩ =>
    ⟨K, ⟨⟨s₀.2, inK⟩, fun s inK' x input => match present (s₀.1, s) inK' x input with
        | ⟨t, samePart, sameSub⟩ => ⟨t.2, samePart, sameSub⟩⟩,
     fun s inK' input => match delivers (s₀.1, s) inK' input with
        | ⟨t, ⟨_, trace⟩, inKt, out⟩ => ⟨t.2, reach_interleave_snd trace, inKt, out⟩⟩

/-- **Within the interleaving on two substrates, tasks possible there with divisions read off each
process are possible in parallel.** -/
theorem possible_parallel_within {part : S → C} {sub : S → X} {T : X → X → Prop}
    {part' : S' → D} {sub' : S' → Y} {T' : Y → Y → Prop}
    (first : Possible (interleave P Q) (fun s => part s.1) (fun s => sub s.1) T)
    (second : Possible (interleave P Q) (fun s => part' s.2) (fun s => sub' s.2) T') :
    Possible (interleave P Q) (fun s => (part s.1, part' s.2)) (fun s => (sub s.1, sub' s.2))
      (parallel T T') :=
  Possible.parallel_interleave (possible_of_interleave_left first)
    (possible_of_interleave_right second)

end Projection

/-! ## F12. The companion of `Conserved.not_raise_alone` -/

/-- **No reading of the second substrate itself performs lowering it.** -/
theorem not_lower_alone {D : Type w} (f : Bool → D) :
    ¬ Possible Conserved.process (fun s => f s.2) Prod.snd Conserved.lower :=
  fun ⟨K, ⟨⟨s₀, inK⟩, present⟩, delivers⟩ =>
    match present s₀ inK true ⟨false, rfl, rfl⟩ with
    | ⟨_, samePart, isFull⟩ =>
      have inFull : K (f true) := Eq.subst (motive := fun b => K (f b)) isFull
        (Eq.subst (motive := K) samePart.symm inK)
      match delivers (true, true) inFull ⟨false, rfl, rfl⟩ with
      | ⟨_, reach, _, _, lowered⟩ =>
        Bool.noConfusion
          ((congrArg Prod.snd (Conserved.full_stays.reach reach rfl)).symm.trans lowered)

/-! ## F12. Deutsch's §3.4 pattern on the same witness: the transpose impossible, `Ã ⊗ B` possible -/

/-- From the first full, a reached configuration with the first empty has the second full. -/
theorem second_full_of_emptied :
    ∀ {t u : Bool × Bool}, t.1 = true → Reach Conserved.process t u → u.1 = false → u.2 = true
  | (true, true), _, _, reach, emptied =>
    Bool.noConfusion ((congrArg Prod.fst (Conserved.full_stays.reach reach rfl)).symm.trans emptied)
  | (true, false), _, _, reach, emptied => match Conserved.one_stays.reach reach (.inr rfl) with
    | .inl done => congrArg Prod.snd done
    | .inr atStart => Bool.noConfusion ((congrArg Prod.fst atStart).symm.trans emptied)
  | (false, _), _, full, _, _ => Bool.noConfusion full

/-- **Lowering the first, the transpose of raising it, is performed by no class of any reading of
the second substrate.** -/
theorem not_lower_first {D : Type w} (f : Bool → D) :
    ¬ Possible Conserved.process (fun s => f s.2) Prod.fst Conserved.lower :=
  fun ⟨K, ⟨⟨s₀, inK⟩, present⟩, delivers⟩ =>
    have fullFails : ¬ K (f true) := fun inFull =>
      match delivers (true, true) inFull ⟨false, rfl, rfl⟩ with
      | ⟨_, reach, _, _, emptied⟩ =>
        Bool.noConfusion
          ((congrArg Prod.fst (Conserved.full_stays.reach reach rfl)).symm.trans emptied)
    match present s₀ inK true ⟨false, rfl, rfl⟩ with
    | ⟨t, samePart, isFull⟩ =>
      match delivers t (Eq.subst (motive := K) samePart.symm inK) ⟨false, isFull, rfl⟩ with
      | ⟨_, reach, inKu, _, emptied⟩ =>
        fullFails (Eq.subst (motive := fun b => K (f b))
          (second_full_of_emptied isFull reach emptied) inKu)

/-- **The first lowered and the second raised, in parallel, are performed with no performing
part**: `Ã ⊗ B` possible where `A` and `B` both raise. -/
theorem performs_lower_raise :
    Performs Conserved.process (fun _ => ()) id (fun _ => True)
      (parallel Conserved.lower Conserved.raise) :=
  ⟨⟨⟨(true, false), trivial⟩, fun _ _ p _ => ⟨p, rfl, rfl⟩⟩,
   fun s _ ⟨_, ⟨isFull, _⟩, isEmpty, _⟩ =>
     have moves : Conserved.process.step s () (false, true) :=
       .inr ⟨congr (congrArg Prod.mk isFull) isEmpty, rfl⟩
     ⟨(false, true), Reach.of_step moves, trivial, ⟨isFull, rfl⟩, isEmpty, rfl⟩⟩

/-! ## F11. What `Conserved.one` is: the exclusive or of the two substrates, kept by every move -/

/-- `Conserved.one` is the exclusive or of the two substrates: with the first, a one-to-one
recoding of the configuration. -/
theorem one_eq_xor : ∀ s : Bool × Bool, Conserved.one s = xor s.1 s.2
  | (false, false) => rfl
  | (false, true) => rfl
  | (true, false) => rfl
  | (true, true) => rfl

/-- **Every move keeps `Conserved.one`**: the performing part of `possible_with_one` is an
invariant of the whole process, so every class of it is restored by every course. -/
theorem one_kept : ∀ s a t, Conserved.process.step s a t → Conserved.one t = Conserved.one s
  | _, _, _, .inl ⟨atStart, done⟩ =>
    (congrArg Conserved.one done).trans
      ((rfl : Conserved.one (true, false) = Conserved.one (false, true)).trans
        (congrArg Conserved.one atStart).symm)
  | _, _, _, .inr ⟨atStart, done⟩ =>
    (congrArg Conserved.one done).trans
      ((rfl : Conserved.one (false, true) = Conserved.one (true, false)).trans
        (congrArg Conserved.one atStart).symm)

/-! ## F6. `Possible` asks only that some configuration have the class: nothing need make it -/

namespace Unmade

/-- A configuration is an enzyme, present (`true`) or absent (`false`), and a molecule, the
substrate (`false`) or the product (`true`): the present enzyme turns the substrate into the
product, and nothing makes an enzyme. -/
def process : Process (Bool × Bool) Unit := ⟨fun s _ t => s = (true, false) ∧ t = (true, true)⟩

/-- The substrate made the product. -/
def task (x y : Bool) : Prop := x = false ∧ y = true

theorem performs : Performs process Prod.fst Prod.snd (fun e => e = true) task :=
  ⟨⟨⟨(true, false), rfl⟩,
    fun _ present _ ⟨_, isSubstrate, _⟩ => ⟨(true, false), present.symm, isSubstrate.symm⟩⟩,
   fun s present ⟨_, isSubstrate, _⟩ =>
     have moves : process.step s () (true, true) :=
       ⟨congr (congrArg Prod.mk present) isSubstrate, rfl⟩
     ⟨(true, true), Reach.of_step moves, rfl, isSubstrate, rfl⟩⟩

/-- An absent enzyme stays absent. -/
theorem absent_stays : Invariant process (fun s => s.1 = false) :=
  fun _ _ _ step absent => Bool.noConfusion ((congrArg Prod.fst step.1).symm.trans absent)

/-- **Possible, though no enzyme can be made**: the class performs the task, and from the
configuration with no enzyme no configuration with one is reached. -/
theorem possible_unmade :
    Possible process Prod.fst Prod.snd task ∧
      ∀ t, Reach process (false, false) t → ¬ t.1 = true :=
  ⟨⟨_, performs⟩, fun _ reach present =>
    Bool.noConfusion (present.symm.trans (absent_stays.reach reach rfl))⟩

end Unmade

end Probe

end Tasks

end Becoming
