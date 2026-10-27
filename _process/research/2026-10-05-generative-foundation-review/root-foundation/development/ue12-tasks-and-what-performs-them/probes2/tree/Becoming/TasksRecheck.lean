import Becoming.Tasks

/-!
# Recheck probes for `Becoming.Tasks` (UE12, sha256 `fbccc794…34da`)

AI-written probes for RECHECK-UE12.md, not for landing. Each block tests one finding or one
question of the recheck; its number is in the block's heading. Pure Lean, prelude only, built with
`scratch_build.py` against an unchanged copy of the module.
-/

namespace Becoming

open Generative

universe u v w w' u' v'

namespace Tasks

namespace Recheck

/-! ## R1. On a delivery, the lagged order is same-offset widening -/

section Lagged

variable {S : Type u} {A : Type v} {X : Type} {P : Process S A} {adm : S → X → Prop}

/-- **Along a reach, the lagged order ranks the end above the start exactly where same-offset
widening does**: the reach form of `Run.widensOrLater_next_iff`. -/
theorem widensOrLater_iff_widens_of_reach {s t : S} (reach : Reach P s t) :
    Reaching.WidensOrLater P adm t s ↔ Reaching.Widens P adm t s :=
  ⟨fun above => match above with
     | .inl widens => widens
     | .inr lag => absurd lag (Reaching.not_widensWithLag_of_reach reach),
   .inl⟩

/-- `Delivers.narrows`'s last conjunct follows from the one before it. -/
theorem not_widensWithLag_of_coversLater {s t : S}
    (later : ∃ d, Reaching.CoversLater P adm d s t) : ¬ Reaching.WidensWithLag P adm t s :=
  fun ⟨_, notBack⟩ => notBack later

end Lagged

/-- **On UE10's rising process the lagged order ranks the delivered output above its input**
(`RiseTask.widens`). -/
theorem riseTask_lagged : Reaching.WidensOrLater Rise.process Rise.adm true false :=
  .inl RiseTask.widens.2.1

/-! ## R1. Same-offset widening can rank a delivered input above its output too -/

namespace Fall

/-- Every step leads to `false`. -/
def process : Process Bool Unit := ⟨fun _ _ t => t = false⟩

/-- The task: `true` to `false`. -/
def task (x y : Bool) : Prop := x = true ∧ y = false

/-- From `true`, then `false` for good. -/
def fallen : Run process := ⟨fun | 0 => true | _ + 1 => false, fun _ => (), fun _ => rfl⟩

/-- A course from `false` stays at `false`. -/
theorem stays (r : Run process) (start : r.state 0 = false) : ∀ t, r.state t = false
  | 0 => start
  | t + 1 => r.step t

/-- Every configuration admits `0` under UE10's `Rise.adm`. -/
theorem admits_zero : ∀ s : Bool, Rise.adm s 0
  | false => rfl
  | true => Nat.zero_le 1

/-- **A delivered input can widen its output at the same offsets**: with `Rise.adm`, the task is
performed with the performing part trivial, and its input widens its output there, so the lagged
order ranks the input above the output. -/
theorem widens_back :
    Performs process (fun _ => ()) id (fun _ => True) task ∧
      Reaching.Widens process Rise.adm true false ∧
      Reaching.WidensOrLater process Rise.adm true false :=
  have widens : Reaching.Widens process Rise.adm true false :=
    ⟨fun r' start' => ⟨fallen, rfl, fun t x admitted =>
        have zero : x = 0 := Eq.subst (motive := fun y => Rise.adm y x) (stays r' start' t) admitted
        Eq.subst (motive := fun y => Rise.adm (fallen.state t) y) zero.symm (admits_zero _)⟩,
      fallen, rfl, fun r' start' includes =>
        have one : Rise.adm (r'.state 0) 1 := includes 0 1 (Nat.le_refl 1)
        Nat.noConfusion (Eq.subst (motive := fun y => Rise.adm y 1) start' one : (1 : Nat) = 0)⟩
  ⟨⟨⟨⟨true, trivial⟩, fun _ _ x _ => ⟨x, rfl, rfl⟩⟩,
     fun s _ ⟨_, atTrue, _⟩ =>
       have moves : process.step s () false := rfl
       ⟨false, Reach.of_step moves, trivial, atTrue, rfl⟩⟩,
   widens, .inl widens⟩

end Fall

/-! ## R1. On the catalytic cycle no configuration starts a course, so covering is silent -/

namespace CatalysisCourses

/-- Every move of the catalytic cycle ends with the enzyme bound to the substrate, or free with
the product. -/
theorem into {s : Bool × Bool} {a : Unit} {t : Bool × Bool} (step : Catalysis.process.step s a t) :
    t = (false, false) ∨ t = (true, true) :=
  match step with
  | .inl ⟨_, done⟩ => .inl done
  | .inr ⟨_, done⟩ => .inr done

/-- Nothing moves from the free enzyme with the product. -/
theorem stuck {a : Unit} {t : Bool × Bool} : ¬ Catalysis.process.step (true, true) a t :=
  fun step => match step with
  | .inl ⟨atStart, _⟩ => Bool.noConfusion (congrArg Prod.snd atStart)
  | .inr ⟨atStart, _⟩ => Bool.noConfusion (congrArg Prod.fst atStart)

/-- **No configuration of the catalytic cycle starts a course**: every course would stop by its
third step. -/
theorem no_course (r : Run Catalysis.process) : False :=
  have first : Catalysis.process.step (r.state 0) (r.act 0) (r.state 1) := r.step 0
  have second : Catalysis.process.step (r.state 1) (r.act 1) (r.state 2) := r.step 1
  have third : Catalysis.process.step (r.state 2) (r.act 2) (r.state 3) := r.step 2
  match into first with
  | .inr free =>
    stuck (Eq.subst (motive := fun x => Catalysis.process.step x (r.act 1) (r.state 2)) free second)
  | .inl bound =>
    match (Eq.subst (motive := fun x => Catalysis.process.step x (r.act 1) (r.state 2)) bound
        second : Catalysis.process.step (false, false) (r.act 1) (r.state 2)) with
    | .inl ⟨atStart, _⟩ => Bool.noConfusion (congrArg Prod.fst atStart)
    | .inr ⟨_, done⟩ =>
      stuck (Eq.subst (motive := fun x => Catalysis.process.step x (r.act 2) (r.state 3)) done
        third)

/-- **So on the catalytic cycle every configuration covers every other with every lag.** -/
theorem coversLater_all {Y : Type} (adm : Bool × Bool → Y → Prop) (d : Nat) (s s' : Bool × Bool) :
    Reaching.CoversLater Catalysis.process adm d s s' :=
  fun r' _ => (no_course r').elim

/-- **And no covering order ranks any configuration above another there.** -/
theorem not_widensOrLater {Y : Type} (adm : Bool × Bool → Y → Prop) (s s' : Bool × Bool) :
    ¬ Reaching.WidensOrLater Catalysis.process adm s s' :=
  fun above => match above with
  | .inl ⟨_, r, _, _⟩ => no_course r
  | .inr ⟨_, notBack⟩ => notBack ⟨0, coversLater_all adm 0 s' s⟩

/-- **On the catalytic cycle the delivery narrows the whole possible strictly, while its output
covers its input with every lag and no covering order ranks the two**: the covering conjuncts of
`Delivers.narrows` are silent where the output starts no course. -/
theorem narrows_unseen :
    (Reaching.Possible Catalysis.process (fun t y => t.2 = y) (true, false) false ∧
      ¬ Reaching.Possible Catalysis.process (fun t y => t.2 = y) (true, true) false) ∧
    (∀ d, Reaching.CoversLater Catalysis.process (fun t y => t.2 = y) d (true, true)
      (true, false)) ∧
    ¬ Reaching.WidensOrLater Catalysis.process (fun t y => t.2 = y) (true, false) (true, true) :=
  ⟨Catalysis.narrows, fun d => coversLater_all _ d _ _, not_widensOrLater _ _ _⟩

end CatalysisCourses

/-! ## 3a. `Possible.parallel_within`'s hypotheses are those of `Possible.parallel_interleave` -/

section Within

variable {S : Type u} {A : Type v} {S' : Type u'} {A' : Type v'} {C : Type w} {D : Type w'}
  {X Y : Type} {P : Process S A} {Q : Process S' A'}

/-- The converse of `Possible.of_interleave_left`, where the second process has a configuration. -/
theorem possible_interleave_left_of {part : S → C} {sub : S → X} {T : X → X → Prop} (s₂ : S')
    (possible : Possible P part sub T) :
    Possible (interleave P Q) (fun s => part s.1) (fun s => sub s.1) T :=
  match possible with
  | ⟨K, ⟨⟨s₀, inK⟩, present⟩, delivers⟩ =>
    ⟨K, ⟨⟨(s₀, s₂), inK⟩, fun s inK' x input => match present s.1 inK' x input with
        | ⟨t, samePart, sameSub⟩ => ⟨(t, s.2), samePart, sameSub⟩⟩,
     (Delivers.interleave_left (Q := Q) delivers).of_heldMoves⟩

/-- The converse of `Possible.of_interleave_right`, where the first process has a configuration. -/
theorem possible_interleave_right_of {part : S' → D} {sub : S' → Y} {T : Y → Y → Prop} (s₁ : S)
    (possible : Possible Q part sub T) :
    Possible (interleave P Q) (fun s => part s.2) (fun s => sub s.2) T :=
  match possible with
  | ⟨K, ⟨⟨s₀, inK⟩, present⟩, delivers⟩ =>
    ⟨K, ⟨⟨(s₁, s₀), inK⟩, fun s inK' x input => match present s.2 inK' x input with
        | ⟨t, samePart, sameSub⟩ => ⟨(s.1, t), samePart, sameSub⟩⟩,
     (Delivers.interleave_right (P := P) delivers).of_heldMoves⟩

end Within

/-! ## 3b. `PossibleFrom` is existential: a performer occurring naturally counts as made -/

section From

variable {S : Type u} {A : Type v} {C : Type w} {X : Type} {P : Process S A} {part : S → C}
  {sub : S → X} {T : X → X → Prop}

/-- **With every configuration counted natural, possible from natural configurations is
possible**: a performer already there is made at zero moves. -/
theorem possibleFrom_all_iff :
    PossibleFrom P part sub (fun _ => True) T ↔ Possible P part sub T :=
  ⟨PossibleFrom.possible, fun ⟨K, performs⟩ => match performs.1.1 with
    | ⟨s, inK⟩ => ⟨K, performs, s, trivial, s, Reach.refl P s, inK⟩⟩

end From

/-- **The universal form fails where the existential holds**: on `Unmade`, with every
configuration counted natural, the task is possible from natural configurations, and no performing
region can be reached from every one. -/
theorem unmade_forms :
    PossibleFrom Unmade.process Prod.fst Prod.snd (fun _ => True) Unmade.task ∧
      ¬ ∃ K : Bool → Prop, Performs Unmade.process Prod.fst Prod.snd K Unmade.task ∧
        ∀ s, True → ∃ t, Reach Unmade.process s t ∧ K t.1 :=
  ⟨⟨_, Unmade.performs, (true, false), trivial, (true, false), Reach.refl _ _, rfl⟩,
   fun ⟨K, ⟨_, delivers⟩, every⟩ => match every (false, false) trivial with
    | ⟨_, reach, inK⟩ =>
      have inAbsent : K false := Eq.subst (motive := K) (Unmade.absent_stays.reach reach rfl) inK
      match delivers (false, false) inAbsent ⟨true, rfl, rfl⟩ with
      | ⟨_, ⟨_, .nil _⟩, _, _, isProduct⟩ => Bool.noConfusion isProduct
      | ⟨_, ⟨_, .cons step _⟩, _⟩ => Bool.noConfusion (congrArg Prod.fst step.1)⟩

/-! ## R2. `tower_made_held` is UE11's `RuleTower.possible_iff_held` at the made performer -/

section Tower

variable {Z : Type} {R : Type v} {base : R → Z → Z → Prop} {up : Nat → R → R → R → Prop}
  {T : Z → Z → Prop}

/-- **`tower_made_held`, from `RuleTower.possible_iff_held`** at the formation "the part in `K`":
an instance. -/
theorem made_held_of_possible_iff_held {natural : Z × (Nat → R) → Prop}
    (possible : PossibleFrom (RuleTower.process base up) Prod.snd Prod.fst natural T) :
    ∃ K : (Nat → R) → Prop, Performs (RuleTower.process base up) Prod.snd Prod.fst K T ∧
      ∃ s, natural s ∧ ∃ n t,
        Reach (Reaching.heldMoves (RuleTower.process base up) (RuleTower.SameFrom n)) s t ∧
          K t.2 :=
  match possible with
  | ⟨K, performs, s, isNatural, t, reach, inK⟩ =>
    match (RuleTower.possible_iff_held (adm := fun u (_ : Unit) => K u.2) (s := s) (x := ())).mp
        ⟨t, reach, inK⟩ with
    | ⟨n, t', held, inK'⟩ => ⟨K, performs, s, isNatural, n, t', held, inK'⟩

/-- **The performers from the held level up are, where the performer is made, as they are in the
natural configuration**, since `RuleTower.SameFrom` is a class: what `tower_made_held`'s docstring
reads and its statement leaves to `Reach.same_of_heldMoves`. -/
theorem made_as_there {n : Nat} {s t : Z × (Nat → R)}
    (held : Reach (Reaching.heldMoves (RuleTower.process base up) (RuleTower.SameFrom n)) s t) :
    RuleTower.SameFrom n s t :=
  Reach.same_of_heldMoves (RuleTower.sameFrom_class n) held

end Tower

/-! ## R4. `Delivers.invariably`'s hypothesis is the grammar's fixed successor -/

section Fixed

variable {S : Type u} {A : Type v} {C : Type w} {X : Type} {P : Process S A}

/-- **At most one next configuration is the grammar's fixed successor of the steps**
(`«定后»`, `«定后之逐点»`). -/
theorem oneNext_iff_fixed :
    (∀ s a t a' t', P.step s a t → P.step s a' t' → t = t') ↔ «定后» (Steps P) :=
  ⟨fun oneNext => «定后之逐点».mpr fun _ _ _ ⟨a, step⟩ ⟨a', step'⟩ => oneNext _ a _ a' _ step step',
   fun fixed _ a _ a' _ step step' => «定后之逐点».mp fixed _ _ _ ⟨a, step⟩ ⟨a', step'⟩⟩

/-- `on_every_run` with the successor fixed only at what the trace's origin reaches
(`«定后于»`). -/
theorem on_every_run_within {s₀ : S} (fixed : «定后于» (Steps P) s₀) :
    ∀ {s t : S} {as : List A}, Reach P s₀ s → Trace P s as t → ∀ (r : Run P) (k : Nat),
      r.state k = s → ∃ n, r.state (k + n) = t
  | _, _, _, _, .nil _, _, _, at_ => ⟨0, at_⟩
  | s, t, _, reached, @Trace.cons _ _ _ _ m _ a _ step rest, r, k, at_ =>
    have runStep : P.step s (r.act k) (r.state (k + 1)) :=
      Eq.subst (motive := fun x => P.step x (r.act k) (r.state (k + 1))) at_ (r.step k)
    have same : r.state (k + 1) = m :=
      fixed s (reach_iff_withinClosure.mp reached) _ _ ⟨r.act k, runStep⟩ ⟨a, step⟩
    match on_every_run_within fixed (reached.trans (Reach.of_step step)) rest r (k + 1) same with
    | ⟨n, passes⟩ =>
      ⟨n + 1, Eq.subst (motive := fun j => r.state j = t)
        ((Nat.succ_add k n).trans (Nat.add_succ k n).symm) passes⟩

/-- **`Delivers.invariably` with the successor fixed only at what the presented configuration
reaches.** -/
theorem invariably_within {part : S → C} {sub : S → X} {K : C → Prop} {T : X → X → Prop}
    (delivers : Delivers P part sub K T) {s : S} (fixed : «定后于» (Steps P) s)
    (inK : K (part s)) (input : Input T (sub s)) :
    ∃ t, Reach P s t ∧ K (part t) ∧ T (sub s) (sub t) ∧
      ∀ r : Run P, r.state 0 = s → ∃ n, r.state n = t :=
  match delivers s inK input with
  | ⟨t, ⟨as, trace⟩, inK', out⟩ => ⟨t, ⟨as, trace⟩, inK', out, fun r start =>
      match on_every_run_within fixed (Reach.refl P s) trace r 0 start with
      | ⟨n, passes⟩ => ⟨n, Eq.subst (motive := fun j => r.state j = t) (Nat.zero_add n) passes⟩⟩

end Fixed

/-! ## R6. The counter is UE10's `Climb` -/

/-- The counter's process is UE10's `Climb.process`, by definition. -/
theorem counting_eq_climb : Counting.process = Climb.process := rfl

/-- `Counting.reach_add` is `Climb.trace_units`. -/
theorem reach_add_of_climb (x d : Nat) : Reach Counting.process x (x + d) :=
  ⟨_, Climb.trace_units d x⟩

/-! ## R3. The identity task needs each input had -/

/-- **A task relating each input to itself is performed by no region of any reading where an input
is not had**: `performs_identity`'s condition, which the module doc drops, is needed. -/
theorem identity_not_possible {D : Type} (part : Unit → D) (P : Process Unit Unit) :
    ¬ Possible P part (fun _ => false) (fun x y => True ∧ y = x) :=
  fun ⟨_, ⟨⟨s₀, inK⟩, present⟩, _⟩ => match present s₀ inK true ⟨true, trivial, rfl⟩ with
  | ⟨_, _, atTrue⟩ => Bool.noConfusion (atTrue : false = true)

/-! ## R3. Where no performing part is needed, the pair must still be regular -/

namespace Unregular

/-- `0` steps to `1`, and `2` steps to `3`. -/
def process : Process Nat Unit := ⟨fun s _ t => (s = 0 ∧ t = 1) ∨ (s = 2 ∧ t = 3)⟩

/-- The first task: `0` to `1` or to `2`. -/
def first (x y : Nat) : Prop := x = 0 ∧ (y = 1 ∨ y = 2)

/-- The second task: `2` to `3`. -/
def second (x y : Nat) : Prop := x = 2 ∧ y = 3

/-- The first task is performed with no performing part, by the step to `1`. -/
theorem performs_first : Performs process (fun _ => ()) id (fun _ => True) first :=
  ⟨⟨⟨0, trivial⟩, fun _ _ x _ => ⟨x, rfl, rfl⟩⟩,
   fun s _ ⟨_, atZero, _⟩ =>
     have moves : process.step s () 1 := .inl ⟨atZero, rfl⟩
     ⟨1, Reach.of_step moves, trivial, atZero, .inl rfl⟩⟩

/-- The second task is performed with no performing part. -/
theorem performs_second : Performs process (fun _ => ()) id (fun _ => True) second :=
  ⟨⟨⟨0, trivial⟩, fun _ _ x _ => ⟨x, rfl, rfl⟩⟩,
   fun s _ ⟨_, atTwo, _⟩ =>
     have moves : process.step s () 3 := .inr ⟨atTwo, rfl⟩
     ⟨3, Reach.of_step moves, trivial, atTwo, rfl⟩⟩

/-- From `0` or `1`, the count stays at `0` or `1`. -/
theorem stays : Invariant process (fun s => s = 0 ∨ s = 1) :=
  fun _ _ _ step held => match step, held with
  | .inl ⟨_, done⟩, _ => .inr done
  | .inr ⟨atTwo, _⟩, .inl atZero => Nat.noConfusion (atTwo.symm.trans atZero)
  | .inr ⟨atTwo, _⟩, .inr atOne => Nat.noConfusion (Nat.succ.inj (atTwo.symm.trans atOne))

/-- The pair is not regular: the output `1` of the first is not an input of the second. -/
theorem not_regular : ¬ Regular first second :=
  fun regular => match regular 0 1 ⟨rfl, .inl rfl⟩ with
  | ⟨_, isTwo, _⟩ => Nat.noConfusion (Nat.succ.inj isTwo)

/-- **Two tasks possible with no performing part, not a regular pair, whose composite no reading
performs**: `Possible.serial_of_unitPart`'s regularity, which the module doc drops, is needed. -/
theorem composite_not_possible {D : Type} (part : Nat → D) :
    ¬ Possible process part id («而» first second) :=
  fun ⟨K, ⟨⟨s₀, inK⟩, present⟩, delivers⟩ =>
    have input : Input («而» first second) 0 := ⟨3, 2, ⟨rfl, .inr rfl⟩, rfl, rfl⟩
    match present s₀ inK 0 input with
    | ⟨t, samePart, atZero⟩ =>
      match delivers t (Eq.subst (motive := K) samePart.symm inK)
          (Eq.subst (motive := Input («而» first second)) atZero.symm input) with
      | ⟨_, reach, _, _, _, isThree⟩ =>
        match stays.reach reach (.inl atZero) with
        | .inl zero => Nat.noConfusion (isThree.2.symm.trans zero)
        | .inr one => Nat.noConfusion (Nat.succ.inj (isThree.2.symm.trans one))

end Unregular

/-! ## R5. The conserved amount: the other two companions, and the invariant performing all four -/

namespace ConservedRecheck

open Conserved

/-- **No reading of the first substrate itself performs lowering it.** -/
theorem not_lower_first_alone {D : Type w} (f : Bool → D) :
    ¬ Possible Conserved.process (fun s => f s.1) Prod.fst Conserved.lower :=
  fun ⟨K, ⟨⟨s₀, inK⟩, present⟩, delivers⟩ =>
    match present s₀ inK true ⟨false, rfl, rfl⟩ with
    | ⟨_, samePart, isFull⟩ =>
      have inFull : K (f true) := Eq.subst (motive := fun b => K (f b)) isFull
        (Eq.subst (motive := K) samePart.symm inK)
      match delivers (true, true) inFull ⟨false, rfl, rfl⟩ with
      | ⟨_, reach, _, _, lowered⟩ =>
        Bool.noConfusion ((congrArg Prod.fst (full_stays.reach reach rfl)).symm.trans lowered)

/-- **No reading of the second substrate itself performs raising it.** -/
theorem not_raise_second_alone {D : Type w} (f : Bool → D) :
    ¬ Possible Conserved.process (fun s => f s.2) Prod.snd Conserved.raise :=
  fun ⟨K, ⟨⟨s₀, inK⟩, present⟩, delivers⟩ =>
    match present s₀ inK false ⟨true, rfl, rfl⟩ with
    | ⟨_, samePart, isEmpty⟩ =>
      have inEmpty : K (f false) := Eq.subst (motive := fun b => K (f b)) isEmpty
        (Eq.subst (motive := K) samePart.symm inK)
      match delivers (false, false) inEmpty ⟨true, rfl, rfl⟩ with
      | ⟨_, reach, _, _, raised⟩ =>
        Bool.noConfusion ((congrArg Prod.snd (empty_stays.reach reach rfl)).symm.trans raised)

/-- **Read as `holdsOne`, the performing part lowers the first too.** -/
theorem performs_lower_first_with_one :
    Performs Conserved.process holdsOne Prod.fst (fun c => c = true) Conserved.lower :=
  ⟨⟨⟨(true, false), rfl⟩, fun _ held _ ⟨_, isFull, _⟩ => ⟨(true, false), held.symm, isFull.symm⟩⟩,
   fun s held ⟨_, isFull, _⟩ => match s, held, isFull with
     | (true, false), _, _ =>
       have moves : Conserved.process.step (true, false) () (false, true) := .inr ⟨rfl, rfl⟩
       ⟨(false, true), Reach.of_step moves, rfl, rfl, rfl⟩
     | (true, true), held, _ => Bool.noConfusion held
     | (false, _), _, isFull => Bool.noConfusion isFull⟩

/-- **Read as `holdsOne`, the performing part raises the second.** -/
theorem performs_raise_second_with_one :
    Performs Conserved.process holdsOne Prod.snd (fun c => c = true) Conserved.raise :=
  ⟨⟨⟨(true, false), rfl⟩, fun _ held _ ⟨_, isEmpty, _⟩ => ⟨(true, false), held.symm, isEmpty.symm⟩⟩,
   fun s held ⟨_, isEmpty, _⟩ => match s, held, isEmpty with
     | (true, false), _, _ =>
       have moves : Conserved.process.step (true, false) () (false, true) := .inr ⟨rfl, rfl⟩
       ⟨(false, true), Reach.of_step moves, rfl, rfl, rfl⟩
     | (false, false), held, _ => Bool.noConfusion held
     | (_, true), _, isEmpty => Bool.noConfusion isEmpty⟩

/-- **Read as `holdsOne`, the performing part lowers the second.** -/
theorem performs_lower_second_with_one :
    Performs Conserved.process holdsOne Prod.snd (fun c => c = true) Conserved.lower :=
  ⟨⟨⟨(false, true), rfl⟩, fun _ held _ ⟨_, isFull, _⟩ => ⟨(false, true), held.symm, isFull.symm⟩⟩,
   fun s held ⟨_, isFull, _⟩ => match s, held, isFull with
     | (false, true), _, _ =>
       have moves : Conserved.process.step (false, true) () (true, false) := .inl ⟨rfl, rfl⟩
       ⟨(true, false), Reach.of_step moves, rfl, rfl, rfl⟩
     | (true, true), held, _ => Bool.noConfusion held
     | (_, false), _, isFull => Bool.noConfusion isFull⟩

/-- **With the first substrate, `holdsOne` recodes the configuration one to one**: what
`holdsOne_eq_xor`'s and `performs_with_one`'s docstrings say and their statements do not. -/
theorem holdsOne_recodes : ∀ s t : Bool × Bool, s.1 = t.1 → holdsOne s = holdsOne t → s = t
  | (false, false), (false, false), _, _ => rfl
  | (false, true), (false, true), _, _ => rfl
  | (true, false), (true, false), _, _ => rfl
  | (true, true), (true, true), _, _ => rfl
  | (false, false), (false, true), _, same => Bool.noConfusion same
  | (false, true), (false, false), _, same => Bool.noConfusion same
  | (true, false), (true, true), _, same => Bool.noConfusion same
  | (true, true), (true, false), _, same => Bool.noConfusion same
  | (false, _), (true, _), first, _ => Bool.noConfusion first
  | (true, _), (false, _), first, _ => Bool.noConfusion first

end ConservedRecheck

/-! ## Module doc. Held unchanged at every move, the enzyme does not deliver either -/

/-- **`Catalysis.not_held` for holding the enzyme unchanged**, the possible relative to a held part
in UE11's sense: the module doc's "not needed" reads it a fortiori. -/
theorem catalysis_not_held_unchanged :
    ¬ Delivers (Reaching.heldMoves Catalysis.process (fun s t => t.1 = s.1)) Prod.fst Prod.snd
      Catalysis.Free Catalysis.task :=
  fun held => match held (true, false) rfl ⟨true, rfl, rfl⟩ with
  | ⟨_, ⟨_, .nil _⟩, _, _, isProduct⟩ => Bool.noConfusion isProduct
  | ⟨_, ⟨_, .cons ⟨.inl ⟨_, bound⟩, kept⟩ _⟩, _, _⟩ =>
    Bool.noConfusion ((congrArg Prod.fst bound).symm.trans kept)
  | ⟨_, ⟨_, .cons ⟨.inr ⟨atStart, _⟩, _⟩ _⟩, _, _⟩ =>
    Bool.noConfusion (congrArg Prod.fst atStart)

/-! ## Fix forms. The Lean the recheck's fixes propose, checked here -/

/-! ### R2. The tower: the reach lemma once, and the made performer as the natural configuration
has it -/

section TowerFix

variable {Z : Type} {R : Type v} {base : R → Z → Z → Prop} {up : Nat → R → R → R → Prop}
  {T : Z → Z → Prop}

/-- What the tower reaches it reaches with the performers from some level up held
(`Reaching.reach_held_of_sequence` at `RuleTower.SameFrom`), the term both tower theorems inline. -/
theorem tower_reach_held {s t : Z × (Nat → R)} (reach : Reach (RuleTower.process base up) s t) :
    ∃ n, Reach (Reaching.heldMoves (RuleTower.process base up) (RuleTower.SameFrom n)) s t :=
  Reaching.reach_held_of_sequence (P := RuleTower.process base up)
    (E := fun n => RuleTower.SameFrom n)
    (fun _ _ le _ _ same => RuleTower.SameFrom.mono same le)
    (fun _ a _ step => ⟨a, RuleTower.step_sameFrom a step⟩) reach

/-- `tower_made_held` with what its docstring reads stated: the performers from the held level up
are, where the performer is made, as the natural configuration has them. -/
theorem tower_made_held_as_there {natural : Z × (Nat → R) → Prop}
    (possible : PossibleFrom (RuleTower.process base up) Prod.snd Prod.fst natural T) :
    ∃ K : (Nat → R) → Prop, Performs (RuleTower.process base up) Prod.snd Prod.fst K T ∧
      ∃ s, natural s ∧ ∃ n t,
        Reach (Reaching.heldMoves (RuleTower.process base up) (RuleTower.SameFrom n)) s t ∧
          RuleTower.SameFrom n s t ∧ K t.2 :=
  match possible with
  | ⟨K, performs, s, isNatural, t, reach, inK⟩ =>
    match tower_reach_held reach with
    | ⟨n, held⟩ => ⟨K, performs, s, isNatural, n, t, held,
        Reach.same_of_heldMoves (RuleTower.sameFrom_class n) held, inK⟩

/-- `tower_delivers_iff_held`'s forward direction through the one reach lemma. -/
theorem tower_delivers_held {K : (Nat → R) → Prop}
    (delivers : Delivers (RuleTower.process base up) Prod.snd Prod.fst K T) :
    ∀ s, K s.2 → Input T s.1 → ∃ n t,
      Reach (Reaching.heldMoves (RuleTower.process base up) (RuleTower.SameFrom n)) s t ∧
        K t.2 ∧ T s.1 t.1 :=
  fun s inK input => match delivers s inK input with
  | ⟨t, reach, inK', out⟩ => match tower_reach_held reach with
    | ⟨n, held⟩ => ⟨n, t, held, inK', out⟩

end TowerFix

/-! ### R4 and R6. The counter on UE10's `Climb`, its one next configuration stated on the
grammar -/

namespace ClimbTaskFix

/-- The climb's successor is fixed (`«定后»`). -/
theorem fixed : «定后» (Steps Climb.process) :=
  «定后之逐点».mpr fun _ _ _ ⟨_, first⟩ ⟨_, second⟩ => first.trans second.symm

/-- **Every task each of whose inputs has an output at or ahead of it is performed with no
performing part.** -/
theorem performs {T : Nat → Nat → Prop} (ahead : ∀ x y, T x y → ∃ d, y = x + d) :
    Performs Climb.process (fun _ => ()) id (fun _ => True) T :=
  ⟨⟨⟨0, trivial⟩, fun _ _ x _ => ⟨x, rfl, rfl⟩⟩,
   fun s _ ⟨y, out⟩ => match ahead s y out with
     | ⟨d, isAhead⟩ =>
       ⟨y, Eq.subst (motive := fun z => Reach Climb.process s z) isAhead.symm
          ⟨_, Climb.trace_units d s⟩, trivial, out⟩⟩

/-- And invariably, through the fixed successor (`invariably_within`, `«定后则定后于»`). -/
theorem invariably {T : Nat → Nat → Prop} (ahead : ∀ x y, T x y → ∃ d, y = x + d) (x : Nat)
    (input : Input T x) :
    ∃ t, Reach Climb.process x t ∧ True ∧ T x t ∧
      ∀ r : Run Climb.process, r.state 0 = x → ∃ n, r.state n = t :=
  invariably_within (performs ahead).2 («定后则定后于» fixed x) trivial input

/-- The module's `Counting.performs g` is the case of a function. -/
theorem performs_function (g : Nat → Nat) :
    Performs Climb.process (fun _ => ()) id (fun _ => True) (fun x y => y = x + g x) :=
  performs fun x _ out => ⟨g x, out⟩

end ClimbTaskFix

end Recheck

end Tasks

end Becoming
