import Becoming.ConditionalWeights

/-!
# The Markov blanket as a coupling structure, and what the existence claim forbids

The free-energy principle partitions a system's states into internal, sensory, active and external
states: sensory states are not moved by internal ones, active states not by external ones (Friston
2013; Kirchhoff, Parr, Palacios, Friston and Kiverstein 2018). Its existence claim is that whatever
persists, with such a partition, will appear to minimize free energy (Friston 2013, 2019). This
module states the partition on a determined law: four parts of one law, told apart only by which
part's next state reads which, with no separate entities (board item UE18).

* **The agent is driven by its sensory course** (`Blanketed`). A blanketed law has four parts; the
  internal and active parts move from the internal, sensory and active parts, the sensory and
  external parts from the sensory, active and external parts (`Blanketed.step`). Two courses from
  one internal and one active state, alike on the sensory part before `n`, have one internal and
  one active state at `n` (`Blanketed.agent_through_sensory`); two from one sensory and one external
  state, alike on the active part, have one sensory and one external state
  (`Blanketed.world_through_active`). So a determined policy is a selection through the sensory
  course alone, with no action listed among what couples in, and each side's course is fixed by its
  start and the blanket's course (`Blanketed.internal_through_blanket`,
  `Blanketed.external_through_blanket`): the deterministic case of the time-unrolled blanket
  (Virgo, Rosas and Biehl 2022), independence given the blanket's history, not its present state.
  A reading through the blanket separates at most what the blanket tells apart (`Deaf`).
* **What the sensory part reads of the world bounds what the agent can tell apart.** Where the
  sensory part reads the external part only through a map `π`, two courses from one internal,
  sensory and active state whose external parts are alike through `π` have one agent and one
  sensory course (`Blanketed.through_reading`): 03 §6's lumping (`Learning.Lumped`) on every
  blanketed law.
* **Self-evidencing does not see its break coming** (`ThresholdDrain`). The internal part is
  whether the system goes on, with a model `M` updated by any rule from what it senses and does, and
  the active part any policy; the sensory part reads the supply only by threshold (`Nat.blt 0`,
  `ThresholdDrain.reads_threshold`), and the supply drains by one each step, no action changing it.
  From a supply of three and from every supply of four or more, every reading of the internal
  course up to step four is alike, a free energy of the model's belief at any step before four
  among them, the sensory parts being alike there, while at step five the first has ended and the
  second goes on (`ThresholdDrain.any_model`). The break is registered when it comes, at step four,
  when the sensory parts first differ (`ThresholdDrain.alike_before_four`,
  `ThresholdDrain.sensed_at_break`, `ThresholdDrain.sensory_apart_at_four`), not before. The witness's blanket is the World's coupling by
  threshold: its sensory part is the World's admission at need one
  (`ThresholdDrain.sensory_is_admission`), and from one start its courses are blanket-alike before
  step `n + 2` exactly where the two supply histories are alike through the formation's couplings
  up to `n` (`ThresholdDrain.blanket_iff_through`). On the World the law is T6's invisible half
  (`Web.break_not_bounded`).
* **What the existence claim forbids.** On a listed domain the weighting placing all weight on one
  outcome (`point`) is the counting weighting restricted to the record of being that outcome
  (`point_is_restrict`): read off a course of a determined law, the claim's model is conditioning on
  the course itself. Under it the course weighs something and is of least surprisal, its share the
  whole (`least_surprisal`), and every event not holding at it weighs nothing
  (`point_forbids_rest`). The weighting read off a run's visits (`visits`), its occupation weighting,
  gives every visited, listed state a positive share (`read_off_admits`), ending included: the ended
  witness rests at a fixed point (`ThresholdDrain.short_rests`), a steady state of its law. A listed
  outcome has the share nothing exactly where its weight is nothing (`forbids_iff`): a course is
  forbidden only by a weighting fixed apart from it, such as the density of another law.

**Standing.** The blanket laws are near-definitional, the deterministic case of a known result. That
the existence claim alone forbids nothing is conceded by the principle's proponents, who class it
with principles of stationary action, not falsifiable strictly speaking (Ramstead and others 2023);
what forbids are laws of the courses themselves, holding whatever weighting is put on them.

**Modelling choices.** Discrete synchronous steps; the four parts of any types; the blanket as
sparse coupling of a determined law, not conditional independence of a stationary density, which
can come apart from it (Biehl, Pollock and Kanai 2021; Aguilera, Millidge, Tschantz and Buckley
2022); natural weights on listed outcomes; surprisal read as the reciprocal share
(`Share.le_iff_reciprocal`), with no logarithm. **What the model leaves out:** densities, the
Helmholtz decomposition and nonequilibrium steady states, the principle's own construction; noise;
any free energy (UE17's is in the periphery); which blanket a thing has; a World formation in
general as the agent of a blanketed law, which is an item of its own. Every declaration has an empty
axiom report. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

namespace Blanket

universe u

open ConditionalWeights

/-- Three equalities give one equality of a three-place map. -/
theorem congr3 {α β γ δ : Sort _} (f : α → β → γ → δ) {a a' : α} {b b' : β} {c c' : γ}
    (ha : a = a') (hb : b = b') (hc : c = c') : f a b c = f a' b' c' :=
  match ha, hb, hc with
  | rfl, rfl, rfl => rfl

/-! ## The blanket as a coupling structure -/

/-- **A blanketed law**: a determined law on four parts. The internal and active parts move from
the internal, sensory and active parts; the sensory and external parts from the sensory, active and
external parts. -/
structure Blanketed (I S A E : Type u) where
  /-- The internal part's next state. -/
  nextInternal : I → S → A → I
  /-- The sensory part's next state. -/
  nextSensory : S → A → E → S
  /-- The active part's next state. -/
  nextActive : I → S → A → A
  /-- The external part's next state. -/
  nextExternal : S → A → E → E

/-- A configuration of a blanketed law: its four parts. -/
structure Parts (I S A E : Type u) where
  /-- The internal part. -/
  internal : I
  /-- The sensory part. -/
  sensory : S
  /-- The active part. -/
  active : A
  /-- The external part. -/
  external : E

namespace Blanketed

variable {I S A E : Type u} (b : Blanketed I S A E)

/-- **The step**: every part moves at once, each from the parts it reads. -/
def step (x : Parts I S A E) : Parts I S A E :=
  ⟨b.nextInternal x.internal x.sensory x.active, b.nextSensory x.sensory x.active x.external,
   b.nextActive x.internal x.sensory x.active, b.nextExternal x.sensory x.active x.external⟩

/-- The course from `x`: the law's orbit. -/
def course (x : Parts I S A E) : Nat → Parts I S A E := Law.orbit b.step x

/-- **The agent is driven by its sensory course.** Two courses from one internal and one active
state, alike on the sensory part before `n`, have one internal and one active state at `n`: the
internal and active parts together, the principle's autonomous states, read the world only through
the sensory course. -/
theorem agent_through_sensory {x y : Parts I S A E} (internal : x.internal = y.internal)
    (active : x.active = y.active) :
    ∀ n, (∀ k, k < n → (b.course x k).sensory = (b.course y k).sensory) →
      (b.course x n).internal = (b.course y n).internal ∧
        (b.course x n).active = (b.course y n).active
  | 0, _ => ⟨internal, active⟩
  | n + 1, alike =>
    match agent_through_sensory internal active n (fun k lt => alike k (Nat.lt_succ_of_lt lt)) with
    | ⟨i, a⟩ =>
      ⟨congr3 b.nextInternal i (alike n (Nat.lt_succ_self n)) a,
       congr3 b.nextActive i (alike n (Nat.lt_succ_self n)) a⟩

/-- **The world is driven by the active course.** Two courses from one sensory and one external
state, alike on the active part before `n`, have one sensory and one external state at `n`. -/
theorem world_through_active {x y : Parts I S A E} (sensory : x.sensory = y.sensory)
    (external : x.external = y.external) :
    ∀ n, (∀ k, k < n → (b.course x k).active = (b.course y k).active) →
      (b.course x n).sensory = (b.course y n).sensory ∧
        (b.course x n).external = (b.course y n).external
  | 0, _ => ⟨sensory, external⟩
  | n + 1, alike =>
    match world_through_active sensory external n (fun k lt => alike k (Nat.lt_succ_of_lt lt)) with
    | ⟨s, e⟩ =>
      ⟨congr3 b.nextSensory s (alike n (Nat.lt_succ_self n)) e,
       congr3 b.nextExternal s (alike n (Nat.lt_succ_self n)) e⟩

/-- Two courses alike on the blanket, the sensory and active parts, at every step before `n`. -/
def BlanketAlike (x y : Parts I S A E) (n : Nat) : Prop :=
  ∀ k, k < n → (b.course x k).sensory = (b.course y k).sensory ∧
    (b.course x k).active = (b.course y k).active

/-- **The internal course is fixed by its start and the blanket's course**, a corollary of the
agent's: the active part's agreement after the start follows from the internal and sensory
parts. -/
theorem internal_through_blanket {x y : Parts I S A E} (start : x.internal = y.internal) :
    ∀ n, b.BlanketAlike x y n → (b.course x n).internal = (b.course y n).internal
  | 0, _ => start
  | n + 1, alike =>
    (b.agent_through_sensory start (alike 0 (Nat.succ_pos n)).2 (n + 1)
      fun k lt => (alike k lt).1).1

/-- **The external course is fixed by its start and the blanket's course.** -/
theorem external_through_blanket {x y : Parts I S A E} (start : x.external = y.external) :
    ∀ n, b.BlanketAlike x y n → (b.course x n).external = (b.course y n).external
  | 0, _ => start
  | n + 1, alike =>
    congr3 b.nextExternal (alike n (Nat.lt_succ_self n)).1 (alike n (Nat.lt_succ_self n)).2
      (external_through_blanket start n fun k lt => alike k (Nat.lt_succ_of_lt lt))

/-- **Every reading of the internal course is a selection through the blanket**: a reading that
depends on the internal course only up to `n` is alike on two courses from one internal state that
are alike on the blanket before `n`. -/
theorem reads_through_blanket {V : Type} (read : (Nat → I) → V) {n : Nat}
    (reads : ∀ f g : Nat → I, (∀ k, k ≤ n → f k = g k) → read f = read g)
    {x y : Parts I S A E} (start : x.internal = y.internal) (alike : b.BlanketAlike x y n) :
    read (fun k => (b.course x k).internal) = read (fun k => (b.course y k).internal) :=
  reads _ _ fun k le => b.internal_through_blanket start k fun j lt =>
    alike j (Nat.lt_of_lt_of_le lt le)

/-- **What the sensory part reads of the world bounds what the agent tells apart** (03 §6's
lumping). Where the sensory part reads the external part only through `π`, two courses from one
internal, sensory and active state whose external parts are alike through `π` before `n` have one
internal, sensory and active state at `n`. -/
theorem through_reading {P : Type} (π : E → P)
    (reads : ∀ s a, Learning.Lumped π (b.nextSensory s a)) {x y : Parts I S A E}
    (internal : x.internal = y.internal) (sensory : x.sensory = y.sensory)
    (active : x.active = y.active) :
    ∀ n, (∀ k, k < n → π (b.course x k).external = π (b.course y k).external) →
      (b.course x n).internal = (b.course y n).internal ∧
        (b.course x n).sensory = (b.course y n).sensory ∧
        (b.course x n).active = (b.course y n).active
  | 0, _ => ⟨internal, sensory, active⟩
  | n + 1, alike =>
    match through_reading π reads internal sensory active n
        (fun k lt => alike k (Nat.lt_succ_of_lt lt)) with
    | ⟨i, s, a⟩ =>
      ⟨congr3 b.nextInternal i s a,
       (reads (b.course x n).sensory (b.course x n).active _ _ (alike n (Nat.lt_succ_self n))).trans
         (congr3 b.nextSensory s a rfl),
       congr3 b.nextActive i s a⟩

end Blanketed

/-! ## A reading through the blanket separates at most what it tells apart -/

namespace Deaf

/-- An internal part that reads nothing; the sensory part copies the external one. -/
def law : Blanketed Unit Bool Unit Bool where
  nextInternal _ _ _ := ()
  nextSensory _ _ e := e
  nextActive _ _ _ := ()
  nextExternal _ _ e := e

/-- **Blankets apart, internal courses alike**: the internal course need not tell apart what the
blanket does. -/
theorem lumps :
    ¬ law.BlanketAlike ⟨(), true, (), true⟩ ⟨(), false, (), false⟩ 1 ∧
      ∀ n, (law.course ⟨(), true, (), true⟩ n).internal =
        (law.course ⟨(), false, (), false⟩ n).internal :=
  ⟨fun alike => Bool.noConfusion (show true = false from (alike 0 Nat.zero_lt_one).1),
   fun _ => rfl⟩

end Deaf

/-! ## Self-evidencing does not see its break coming -/

namespace ThresholdDrain

/-- The internal part is whether the system goes on; the sensory part whether the supply meets the
need of one, read by threshold only; the active part nothing; the supply drains by one each
step. -/
def law : Blanketed Bool Bool Unit Nat where
  nextInternal i s _ := i && s
  nextSensory _ _ e := Nat.blt 0 e
  nextActive _ _ a := a
  nextExternal _ _ e := e - 1

/-- From a supply of three. -/
def short : Parts Bool Bool Unit Nat := ⟨true, true, (), 3⟩

/-- From a supply of a hundred. -/
def long : Parts Bool Bool Unit Nat := ⟨true, true, (), 100⟩

/-- The sensory part reads the supply only through the threshold. -/
theorem reads_threshold (s : Bool) (a : Unit) : Learning.Lumped (Nat.blt 0) (law.nextSensory s a) :=
  fun _ _ same => same

/-- **The break is registered when it comes.** At step four the sensory part has registered the
break from a supply of three and not from a hundred, while the internal parts are alike; at step
five the first has ended. -/
theorem sensed_at_break :
    (law.course short 4).sensory = false ∧ (law.course long 4).sensory = true ∧
      (law.course short 4).internal = (law.course long 4).internal ∧
      (law.course short 5).internal = false ∧ (law.course long 5).internal = true :=
  ⟨rfl, rfl, rfl, rfl, rfl⟩

/-- **The blankets agree before step four.** -/
theorem alike_before_four : law.BlanketAlike short long 4 :=
  fun k lt => match k, lt with
    | 0, _ => ⟨rfl, rfl⟩
    | 1, _ => ⟨rfl, rfl⟩
    | 2, _ => ⟨rfl, rfl⟩
    | 3, _ => ⟨rfl, rfl⟩
    | k + 4, lt => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 4 k))

/-- The ended configuration. -/
def ended : Parts Bool Bool Unit Nat := ⟨false, false, (), 0⟩

theorem ended_rests : law.step ended = ended := rfl

/-- **The ended system rests**: from step five the course from a supply of three is at the ended
configuration, a fixed point of its law, a steady state. -/
theorem short_rests : ∀ n, law.course short (n + 5) = ended
  | 0 => rfl
  | n + 1 => (congrArg law.step (short_rests n)).trans ended_rests

/-! ### The witness's blanket is the World's coupling by threshold -/

/-- The supply read as a web: the one formation requires the one condition at need one. -/
def web : Web Unit Unit :=
  ⟨fun _ _ => 0, fun _ _ => True, fun _ _ _ => True, fun _ _ _ => 1, fun _ _ _ => True⟩

/-- **The sensory part is the World's admission at need one.** -/
theorem sensory_is_admission (s : Bool) (a : Unit) (e t : Nat) :
    web.Admits (fun _ => e) t () ↔ law.nextSensory s a e = true :=
  ⟨fun admits => Nat.ble_eq_true_of_le (admits () trivial),
   fun reads _ _ => Nat.le_of_ble_eq_true reads⟩

theorem external_course (x : Parts Bool Bool Unit Nat) :
    ∀ s, (law.course x s).external = x.external - s
  | 0 => rfl
  | s + 1 => congrArg (· - 1) (external_course x s)

theorem sensory_succ (x : Parts Bool Bool Unit Nat) (s : Nat) :
    (law.course x (s + 1)).sensory = Nat.blt 0 (x.external - s) :=
  congrArg (Nat.blt 0) (external_course x s)

/-- **The witness's blanket is the World's coupling by threshold.** From one internal and sensory
start, the courses from two supplies are alike on the blanket before step `n + 2` exactly where the
two supply histories are alike through the formation's couplings, by threshold only, up to `n`. -/
theorem blanket_iff_through (e e' n : Nat) :
    law.BlanketAlike ⟨true, true, (), e⟩ ⟨true, true, (), e'⟩ (n + 2) ↔
      web.AlikeThroughUpTo (fun _ _ => False) () (fun t _ => e - t) (fun t _ => e' - t) n :=
  ⟨fun alike s le =>
    have same : Nat.blt 0 (e - s) = Nat.blt 0 (e' - s) :=
      (sensory_succ ⟨true, true, (), e⟩ s).symm.trans
        ((alike (s + 1) (Nat.succ_lt_succ (Nat.lt_succ_of_le le))).1.trans
          (sensory_succ ⟨true, true, (), e'⟩ s))
    ⟨((sensory_is_admission true () (e - s) s).trans
        ⟨fun h => same.symm.trans h, fun h => same.trans h⟩).trans
        (sensory_is_admission true () (e' - s) s).symm,
     fun _ never => never.elim⟩,
   fun through k lt => match k, lt with
    | 0, _ => ⟨rfl, rfl⟩
    | s + 1, lt =>
      ⟨(sensory_succ ⟨true, true, (), e⟩ s).trans
        ((bool_eq_of_iff
          (((sensory_is_admission true () (e - s) s).symm.trans
            (through s (Nat.le_of_lt_succ (Nat.lt_of_succ_lt_succ lt))).1).trans
            (sensory_is_admission true () (e' - s) s))).trans
          (sensory_succ ⟨true, true, (), e'⟩ s).symm),
       rfl⟩⟩

/-! ### Any model, any policy -/

section AnyModel

variable {M A : Type} (update : M → Bool → A → M) (policy : Bool × M → Bool → A → A)

/-- The internal part is whether the system goes on with a model `M`, updated by any rule from what
it senses and does; the active part is any policy; the supply drains by one each step, no action
changing it. -/
def modelLaw : Blanketed (Bool × M) Bool A Nat where
  nextInternal i s a := (i.1 && s, update i.2 s a)
  nextSensory _ _ e := Nat.blt 0 e
  nextActive i s a := policy i s a
  nextExternal _ _ e := e - 1

/-- Going on, with model `m`, act `a` and a supply. -/
def start (m : M) (a : A) (supply : Nat) : Parts (Bool × M) Bool A Nat :=
  ⟨(true, m), true, a, supply⟩

theorem sensed_alike (m : M) (a : A) (d : Nat) : ∀ k, k < 4 →
    ((modelLaw update policy).course (start m a 3) k).sensory =
      ((modelLaw update policy).course (start m a (d + 4)) k).sensory
  | 0, _ => rfl
  | 1, _ => rfl
  | 2, _ => rfl
  | 3, _ => rfl
  | k + 4, lt => absurd lt (Nat.not_lt_of_le (Nat.le_add_left 4 k))

theorem blanket_alike (m : M) (a : A) (d : Nat) :
    (modelLaw update policy).BlanketAlike (start m a 3) (start m a (d + 4)) 4 :=
  fun k lt => ⟨sensed_alike update policy m a d k lt,
    ((modelLaw update policy).agent_through_sensory (x := start m a 3) (y := start m a (d + 4)) rfl
      rfl k fun j lt' => sensed_alike update policy m a d j (Nat.lt_trans lt' lt)).2⟩

/-- **Whatever the model and the policy**, every reading of the internal course up to step four,
a free energy of the model's belief at any step before four among them (the sensory parts being
alike there), is alike from a supply of three and from every supply of four or more, while at step
five the first has ended and the second goes on. -/
theorem any_model (m : M) (a : A) (d : Nat) {V : Type} (read : (Nat → Bool × M) → V)
    (reads : ∀ f g : Nat → Bool × M, (∀ k, k ≤ 4 → f k = g k) → read f = read g) :
    read (fun k => ((modelLaw update policy).course (start m a 3) k).internal) =
        read (fun k => ((modelLaw update policy).course (start m a (d + 4)) k).internal) ∧
      ((modelLaw update policy).course (start m a 3) 5).internal.1 = false ∧
      ((modelLaw update policy).course (start m a (d + 4)) 5).internal.1 = true :=
  ⟨(modelLaw update policy).reads_through_blanket read reads rfl (blanket_alike update policy m a d),
   rfl,
   match d with
   | 0 => rfl
   | _ + 1 => rfl⟩

/-- **The sensory parts differ at step four**, whatever the model and the policy: a free energy of
the model's belief at step four, reading the record there, can separate the two courses. -/
theorem sensory_apart_at_four (m : M) (a : A) (d : Nat) :
    ((modelLaw update policy).course (start m a 3) 4).sensory = false ∧
      ((modelLaw update policy).course (start m a (d + 4)) 4).sensory = true :=
  ⟨rfl, match d with
    | 0 => rfl
    | _ + 1 => rfl⟩

end AnyModel

end ThresholdDrain

/-! ## What the existence claim forbids -/

/-- A listed entry meeting an event weighs at most the event's mass. -/
theorem le_mass_of_mem {Ω : Type u} {w : Ω → Nat} {e : Ω → Bool} {x : Ω} (holds : e x = true) :
    ∀ {l : List Ω}, x ∈ l → w x ≤ mass l w e
  | _, .head _ => Nat.le_trans (Nat.le_of_eq (if_pos holds).symm) (Nat.le_add_right _ _)
  | _, .tail _ mem => Nat.le_trans (le_mass_of_mem holds mem) (Nat.le_add_left _ _)

section Existence

variable {Ω : Type u} [DecidableEq Ω]

/-- The weighting placing all weight on the outcome `x`. -/
def point (x : Ω) (y : Ω) : Nat := if y = x then 1 else 0

/-- The event of being the outcome `x`. -/
def isAt (x : Ω) (y : Ω) : Bool := decide (y = x)

/-- **The point weighting is conditioning on the outcome itself**: the counting weighting
restricted to the record of being `x`. -/
theorem point_is_restrict (x y : Ω) :
    point x y = ConditionalWeights.restrict (isAt x) (fun _ => 1) y :=
  match decEq y x with
  | isTrue same =>
    (if_pos same).trans (if_pos (decide_eq_true same : isAt x y = true)).symm
  | isFalse other =>
    (if_neg other).trans
      (if_neg (fun h : isAt x y = true => other (of_decide_eq_true h))).symm

/-- Under the weighting on `x`, the event of being `x` weighs the whole. -/
theorem point_whole (x : Ω) (l : List Ω) :
    mass l (point x) (isAt x) = mass l (point x) (fun _ => true) :=
  mass_congr (fun y => match decEq y x with
    | isTrue same =>
      (if_pos (decide_eq_true same : isAt x y = true)).trans (if_pos rfl).symm
    | isFalse other =>
      (if_neg (fun h : isAt x y = true => other (of_decide_eq_true h))).trans
        ((if_neg other : point x y = 0).symm.trans (if_pos rfl).symm)) l

/-- **Every listed outcome is of least surprisal under the weighting on it**: it weighs
something, its share is the whole, and no event has a greater share. -/
theorem least_surprisal {x : Ω} {l : List Ω} (mem : x ∈ l) :
    0 < (share l (point x) (isAt x)).part ∧ (share l (point x) (isAt x)).Same Share.one ∧
      ∀ e, (share l (point x) e).le (share l (point x) (isAt x)) :=
  ⟨Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le Nat.zero_lt_one (Nat.le_of_eq (if_pos rfl).symm))
     (le_mass_of_mem (w := point x) (e := isAt x) (decide_eq_true rfl) mem),
   show mass l (point x) (isAt x) * 1 = 1 * mass l (point x) (fun _ => true) from
     (Nat.mul_one _).trans ((point_whole x l).trans (Nat.one_mul _).symm),
   fun e => show mass l (point x) e * mass l (point x) (fun _ => true) ≤
       mass l (point x) (isAt x) * mass l (point x) (fun _ => true) from
     Nat.mul_le_mul_right _
       (Nat.le_trans (share_within l (point x) e) (Nat.le_of_eq (point_whole x l).symm))⟩

/-- **Under the weighting on `x`, every event not holding at `x` weighs nothing.** -/
theorem point_forbids_rest (x : Ω) {e : Ω → Bool} (off : e x = false) :
    ∀ l : List Ω, (share l (point x) e).part = 0
  | [] => rfl
  | y :: l =>
    have head : (if e y = true then point x y else 0) = 0 :=
      match decEq y x with
      | isTrue same =>
        if_neg fun h : e y = true =>
          Bool.noConfusion (off.symm.trans ((congrArg e same).symm.trans h))
      | isFalse other =>
        match decEq (e y) true with
        | isTrue h => (if_pos h).trans (if_neg other)
        | isFalse h => if_neg h
    (congrArg (· + mass l (point x) e) head).trans
      ((Nat.zero_add _).trans (point_forbids_rest x off l))

/-- **The weighting read off a run**: how often each state is visited in its first `n` steps, its
occupation weighting. -/
def visits (r : Nat → Ω) : Nat → Ω → Nat
  | 0, _ => 0
  | n + 1, y => visits r n y + (if r n = y then 1 else 0)

/-- Visits do not fall as the run goes on. -/
theorem visits_le_succ (r : Nat → Ω) (n : Nat) (y : Ω) : visits r n y ≤ visits r (n + 1) y :=
  Nat.le_add_right _ _

/-- Read off the run, every state it visits has positive weight. -/
theorem visits_pos (r : Nat → Ω) : ∀ n k, k < n → 0 < visits r n (r k)
  | 0, _, lt => absurd lt (Nat.not_lt_zero _)
  | n + 1, k, lt => match Nat.lt_or_eq_of_le (Nat.le_of_lt_succ lt) with
    | .inl before => Nat.lt_of_lt_of_le (visits_pos r n k before) (visits_le_succ r n (r k))
    | .inr same =>
      Nat.lt_of_lt_of_le (Nat.lt_of_lt_of_le Nat.zero_lt_one
        (Nat.le_of_eq (if_pos (congrArg r same.symm)).symm)) (Nat.le_add_left _ _)

/-- Read off the run, a state it does not visit has no weight. -/
theorem visits_zero (r : Nat → Ω) (y : Ω) : ∀ n, (∀ k, k < n → r k ≠ y) → visits r n y = 0
  | 0, _ => rfl
  | n + 1, unvisited =>
    (congrArg (· + _) (visits_zero r y n fun k lt => unvisited k (Nat.lt_succ_of_lt lt))).trans
      ((Nat.zero_add _).trans (if_neg (unvisited n (Nat.lt_succ_self n))))

/-- **Read off the run, every visited, listed state has a positive share**, whatever the run does,
ending included. -/
theorem read_off_admits (r : Nat → Ω) {n k : Nat} (lt : k < n) {l : List Ω} (mem : r k ∈ l) :
    0 < (share l (visits r n) (isAt (r k))).part :=
  Nat.lt_of_lt_of_le (visits_pos r n k lt)
    (le_mass_of_mem (w := visits r n) (e := isAt (r k)) (decide_eq_true rfl) mem)

/-- Under a weighting weighing `x` nothing, the event of being `x` has the share nothing. -/
theorem unweighted_share (w : Ω → Nat) (x : Ω) (zero : w x = 0) (l : List Ω) :
    (share l w (isAt x)).part = 0 :=
  (mass_congr (e' := fun _ => false) (w' := w) (fun y => match decEq y x with
    | isTrue same =>
      (if_pos (decide_eq_true same : isAt x y = true)).trans
        ((congrArg w same).trans (zero.trans (if_neg Bool.false_ne_true).symm))
    | isFalse other =>
      (if_neg (fun h : isAt x y = true => other (of_decide_eq_true h))).trans
        (if_neg Bool.false_ne_true).symm) l).trans (mass_none w l)

/-- **A listed outcome is forbidden exactly where its weight is nothing**: forbidding a course
needs a weighting fixed apart from it. -/
theorem forbids_iff {w : Ω → Nat} {x : Ω} {l : List Ω} (mem : x ∈ l) :
    (share l w (isAt x)).part = 0 ↔ w x = 0 :=
  ⟨fun zero => Nat.eq_zero_of_le_zero
      (Nat.le_trans (le_mass_of_mem (w := w) (e := isAt x) (decide_eq_true rfl) mem)
        (Nat.le_of_eq zero)),
   fun zero => unweighted_share w x zero l⟩

end Existence

end Blanket

end Becoming
