import Becoming.HeldPossible

/-!
# Tasks and what performs them

Constructor theory states the laws of physics as statements about which tasks are possible, which
are impossible, and why (Deutsch, *Constructor theory*, 2013). This module reads its task and what
performs it on any process. What performs a task is a region of a performing part's states that
every delivery restores at its end. Holding the part at every move, the possible relative to a held
part (`Becoming.HeldPossible`), is sufficient (`Delivers.of_heldMoves`) and not needed
(`Catalysis.not_held`, `Catalysis.not_held_unchanged`); it enters as a premise of composition and in
what can be done with the part held.

**The reading.** A task is a relation on the states of a substrate, with no new type (Lean's prelude
has its own `Task`): its legitimate inputs are its domain (`Input`), and the outputs of an input are
what the task relates it to. A process on configurations is divided by two readings, the performing
part (`part`) and the substrate (`sub`); what both leave out is environment. A region `K` of the
performing part's states, which constructor theory calls an attribute, **performs** a task
(`Performs`) where it is presented with the task's inputs (`Presented`: some configuration has the
part in `K`, and each state of the part in `K` is had with every legitimate input) and delivers it
(`Delivers`): from every configuration with the part in `K` and the substrate a legitimate input,
whatever the environment, the process reaches one with the part in `K` and the substrate an output
of that input. The part may leave `K` along the way; in `K` at the end, it can perform the task
again. A task is **possible** with a division where some region of the performing part performs it
(`Possible`), and **possible from** natural configurations where, besides, the performer can be made
from one of them (`PossibleFrom`, constructor theory's pharaonic reading). Serial composition and
the transpose are the grammar's `«而»` and `«逆»`: `«而» T T'` is `T` then `T'`, where constructor
theory's `AB` is `B` then `A`.

**Modelling choices.** Delivery is existential, as the possible is: some trace delivers, and
delivering is having an output possible with the part in `K` (`delivers_iff_possible`). Delivery
reads finite traces, and covering reads infinite runs: a configuration that starts no run is covered
by every configuration (UE10's `NoCourse`). Where the successor is fixed at what the presented
configuration reaches (the grammar's `«定后于»` on the steps), the delivered configuration lies on
every course from the presented one (`Delivers.invariably`): constructor theory's invariable
delivery without its halting. Delivery is passing an output and may take zero moves, so a task
relating each input to itself is performed on every process with a configuration where each of its
inputs is had (`performs_identity`), and nothing marks where a delivery ends, so on UE10's climbing
process every task each of whose inputs has an output at or ahead of it is performed, and
invariably (`ClimbTask.performs`, `ClimbTask.invariably`); constructor theory's halting (Deutsch
§3.13) is not read, and the trace may differ from one presentation to another, where constructor
theory keeps what the user does the same (§1.1). Presentation is co-occurrence in the
configurations, not a course of the process: who presents is not read. A task with no legitimate
input is possible on every process with a configuration (`possible_of_no_input`). A reading of the
performing part may be an invariant of the process (`Conserved.holdsOne_kept`), and a task need not
list what its deliveries change (`Resetting.not_holding`). `Possible` is not pharaonic: a task can
be possible though its performer cannot be made from configurations without it
(`Unmade.possible_not_possibleFrom`), where constructor theory counts such a task impossible
(Deutsch §3.1); `PossibleFrom` reads that requirement, relative to which configurations are counted
natural. Performance is exact: constructor theory's limit "short of perfection" and its approximate
constructors need amounts of error and are not read. Steps are discrete. Which tasks are possible
depends on the division (`Conserved.performs_with_one`).

**Laws.**
* **Held throughout, restored at the end.** What is delivered by moves holding any relation is
  delivered (`Delivers.of_heldMoves`), so a task delivered with the part in `K` at every move is
  delivered with it in `K` at the end. The converse fails on a catalytic cycle: the enzyme leaves its
  free form when it binds the substrate and is free again when it releases the product
  (`Catalysis.performs`, `Catalysis.not_held`). On the same cycle the task's transpose is performed
  by no region of any reading of a performing part (`Catalysis.transpose_not_possible`): a possible
  task with an impossible transpose.
* **Composition.** One region delivering a regular pair, every output of the first an input of the
  second, delivers it in series (`Delivers.serial`, `Performs.serial`), and one region delivering two
  tasks on two substrates, each by the moves holding the other substrate, delivers them in parallel,
  in turn (`Delivers.parallel_inTurn`). Two regions together deliver, in series
  (`Delivers.serial_holding`) or in parallel (`Delivers.parallel_holding`), where each delivers by the
  moves holding what the other uses: its performing part, and in parallel its substrate. These are
  the one-region laws at the pair region (`Delivers.pair_left`, `Delivers.pair_right`,
  `Delivers.pair_left_held`, `Delivers.pair_right_held`). The holding premise is sufficient, not
  needed: what the other uses restored at the end suffices, as on a catalysed series
  (`CatalysedSeries.not_holding`, `CatalysedSeries.performs_pair`). Where no performing part is
  needed, read with the part trivial, a regular pair of possible tasks is possible in series
  (`Possible.serial_of_unitPart`), and the pair must be regular (`Unregular.composite_not_possible`).
* **Locality.** Locality gives the premise for deliveries made on their own performer and substrate.
  In Deutsch and Marletto's form (*Constructor theory of time*, §3), a task performed on one
  substrate only cannot change the attribute of another. Two processes interleaved, on one substrate
  (`interleaveOn`) or on two (`interleave`), are such a case: no move changes both, so each one's
  moves hold the other's part. Tasks performed in the two processes then compose, in series where the
  pair is regular (`Performs.serial_interleaveOn`, `Performs.parallel_interleave`), and so do tasks
  possible in them (`Possible.serial_interleaveOn`, `Possible.parallel_interleave`). Possibility is
  read in each process. Within the interleaving on two substrates, a task is possible with a division
  read off one process exactly where it is possible in that process, given a configuration of the
  other (`Possible.of_interleave_left`, `Possible.interleave_left`, and on the right), so tasks
  possible there with divisions read off each process are possible in parallel
  (`Possible.parallel_within`). Within one interleaving on one substrate, a task can be possible with
  one part's division through the other part's moves, and there a regular pair of possible tasks can
  have no possible composite (`ResettingInterleaved.composition_fails_within`).
* **Composition is not a law of every process.** On a resetting process, a first task is performed
  with a trivial performing part, a second by a second part, every output of the first is an input of
  the second, and the first then the second is performed by no region of any reading of a performing
  part (`Resetting.composition_fails`): every delivery of the first task resets the second part
  (`Resetting.not_holding`), which that task does not list. Listed so, the pair is not regular
  (`Resetting.listed_not_regular`). One part under two regions need not compose either
  (`Resetting.one_part_two_regions`).
* **A possible whole of impossible parts, and the division.** On two substrates passing one unit
  between them, raising the first is performed by no region of any reading of the second, lowering
  the second by none of any reading of the first, and the two in parallel are possible
  (`Conserved.whole_of_impossible_parts`); no reading of a substrate itself performs raising or
  lowering it (`Conserved.not_raise_alone`, `Conserved.not_lower_alone`,
  `Conserved.not_lower_first_alone`, `Conserved.not_raise_second_alone`). Constructor theory's
  pattern for an additive conservation law holds there with each substrate's change performed by
  readings of the other: raising either and lowering either are impossible, and each transpose in
  parallel with the other raising is possible (`Conserved.additive_pattern`, Deutsch §3.4). With the
  performing part read as whether the two together hold one unit, which every move keeps and which
  with the first substrate recodes the configuration one to one (`Conserved.holdsOne_kept`,
  `Conserved.holdsOne_recodes`), each of the four single tasks is performed
  (`Conserved.performs_with_one`, `Conserved.performs_lower_first_with_one`,
  `Conserved.performs_raise_second_with_one`, `Conserved.performs_lower_second_with_one`).
* **The regress.** On a tower of performers with no top (`RuleTower.process`: the move `k + 1`
  changes the performer at level `k` as the one at level `k + 1` allows), what is reached is reached
  with the performers from some level up held (`tower_reach_held`, as in UE11's
  `RuleTower.possible_iff_held`), so every delivery is had with them held, and conversely
  (`tower_delivers_iff_held`): a regress within one performance, finite because a delivery is. That
  the performer can be made from a natural configuration is `PossibleFrom`, which reads constructor
  theory's requirement on chains of construction (Deutsch §3.1); on the tower such a performer is
  made with the performers from some level up held as the natural configuration has them
  (`tower_made_held`), so a chain of constructions beginning with a natural configuration constructs
  only finitely many levels. On the tower changing every level at once, a task is performed and no
  delivery holds the performers from any level up (`FlipTower.performs`, `FlipTower.not_held`).
* **What can be done with the part held** (`PossibleWithPartHeld`): the substrate states reached by
  the moves holding the performing part unchanged, UE11's possible relative to a held part. Along a
  course it grows only across steps changing the part (`changes_of_partHeldGrows`), nothing is added
  from the step at which the part stays for good (`possibleWithPartHeld_of_stays`), it keeps widening
  only where from every step some bounded stretch does not keep the part throughout
  (`changes_of_partHeldKeepsWidening`), and not where a list holds the substrate states reachable
  from the start (`not_partHeldKeepsWidening_of_listed`).
* **The order possible tasks carry.** A delivery adds nothing to the whole possible: what is
  possible from its output is possible from its input (`Delivers.adds_nothing`, by
  `Reaching.Possible.of_reach`), and on the catalytic cycle it narrows the whole possible strictly
  (`Catalysis.narrows`). Widening what can be reached follows deliveries in neither direction. The
  input covers the output with a lag the trace's length (`Reaching.coversLater_of_trace`), so
  widening with a lag never ranks the output above the input (`Reaching.not_widensWithLag_of_reach`),
  and UE10's lagged order ranks it above exactly where same-offset widening does
  (`Reaching.widensOrLater_iff_of_reach`). Same-offset widening can rank the output above the input
  (`RiseTask.widens`, on UE10's rising process) or the input above the output
  (`FallTask.widens_back`). Covering reads infinite runs, and on the catalytic cycle no configuration
  starts one (`Catalysis.no_course`): there every configuration covers every other with every lag and
  the lagged order ranks nothing (`Catalysis.coversLater_all`, `Catalysis.not_widensOrLater`), while
  the whole possible narrows strictly. So what every delivery carries is the inclusion of the whole
  possible, from the output into the input, and not widening.

Every declaration has an empty axiom report.
-/

namespace Becoming

open Generative

universe u v w w' u' v'

/-! ## Reach and lagged covering -/

namespace Reaching

variable {S : Type u} {A : Type v} {Y : Type} {P : Process S A} {adm : S → Y → Prop}

/-- **A configuration covers, with a lag the trace's length, every configuration a trace from it
reaches**: what a course from the end admits, the course from the start with the trace prefixed
admits that many steps later (`Run.coversLater_next`, for a trace). -/
theorem coversLater_of_trace :
    ∀ {s t : S} {as : List A}, Trace P s as t → CoversLater P adm as.length s t
  | _, _, _, .nil _ => fun r' start => ⟨r', start, fun _ _ admitted => admitted⟩
  | s, _, _, @Trace.cons _ _ _ _ _ _ a _ step rest => fun r' start =>
    match coversLater_of_trace rest r' start with
    | ⟨r, start', later⟩ =>
      ⟨Run.cons s a r (Eq.subst (motive := fun y => P.step s a y) start'.symm step), rfl,
        fun k x admitted => later k x admitted⟩

/-- **What a configuration reaches is never ranked above it by widening with a lag**: it covers
what it reaches with a lag (`coversLater_of_trace`; `Run.not_widensWithLag_next`, for reach). -/
theorem not_widensWithLag_of_reach {s t : S} (reach : Reach P s t) : ¬ WidensWithLag P adm t s :=
  fun ⟨_, notBack⟩ => match reach with
  | ⟨_, trace⟩ => notBack ⟨_, coversLater_of_trace trace⟩

/-- **On what a configuration reaches, UE10's lagged order is same-offset widening**: the lag adds
nothing there (`not_widensWithLag_of_reach`; `Run.widensOrLater_next_iff`, for reach). -/
theorem widensOrLater_iff_of_reach {s t : S} (reach : Reach P s t) :
    WidensOrLater P adm t s ↔ Widens P adm t s :=
  ⟨fun above => match above with
     | .inl widens => widens
     | .inr lag => absurd lag (not_widensWithLag_of_reach reach),
   .inl⟩

end Reaching

namespace Tasks

/-! ## Tasks and what performs them -/

section Reading

variable {S : Type u} {A : Type v} {C : Type w} {X : Type}

/-- A legitimate input of a task: a state the task relates to something. -/
def Input (T : X → X → Prop) (x : X) : Prop := ∃ y, T x y

/-- **A region of the performing part presented with a task's inputs**: some configuration has the
part in `K`, and each state of the part in `K` is had with every legitimate input of `T`. -/
def Presented (part : S → C) (sub : S → X) (K : C → Prop) (T : X → X → Prop) : Prop :=
  (∃ s, K (part s)) ∧ ∀ s, K (part s) → ∀ x, Input T x → ∃ t, part t = part s ∧ sub t = x

/-- **Delivering a task**: from every configuration with the performing part in `K` and the
substrate a legitimate input of `T`, the process reaches one with the part in `K` and the substrate
an output of that input. The part may leave `K` along the way. -/
def Delivers (P : Process S A) (part : S → C) (sub : S → X) (K : C → Prop) (T : X → X → Prop) :
    Prop :=
  ∀ s, K (part s) → Input T (sub s) → ∃ t, Reach P s t ∧ K (part t) ∧ T (sub s) (sub t)

/-- **What performs a task**: a region of the performing part presented with the task's inputs and
delivering it. -/
def Performs (P : Process S A) (part : S → C) (sub : S → X) (K : C → Prop) (T : X → X → Prop) :
    Prop :=
  Presented part sub K T ∧ Delivers P part sub K T

/-- **A possible task**, with the division read by `part` and `sub`: some region of the performing
part performs it. -/
def Possible (P : Process S A) (part : S → C) (sub : S → X) (T : X → X → Prop) : Prop :=
  ∃ K : C → Prop, Performs P part sub K T

/-- **A task possible from natural configurations**, constructor theory's pharaonic reading (Deutsch
§3.1): some region of the performing part performs it, and from some configuration counted natural
the process reaches one with the part in that region, so the performer can be made from what is
there naturally. What counts as natural is a parameter, as in constructor theory, where it depends
partly on local conditions. -/
def PossibleFrom (P : Process S A) (part : S → C) (sub : S → X) (natural : S → Prop)
    (T : X → X → Prop) : Prop :=
  ∃ K : C → Prop, Performs P part sub K T ∧ ∃ s, natural s ∧ ∃ t, Reach P s t ∧ K (part t)

variable {P : Process S A} {part : S → C} {sub : S → X} {K : C → Prop} {T : X → X → Prop}

/-- A task possible from natural configurations is possible. -/
theorem PossibleFrom.possible {natural : S → Prop} (possible : PossibleFrom P part sub natural T) :
    Possible P part sub T :=
  match possible with
  | ⟨K, performs, _⟩ => ⟨K, performs⟩

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

/-- Where the successor is fixed at what `s₀` reaches (`«定后于»` on the steps), every course
passing a configuration `s₀` reaches passes the end of every trace from it. -/
theorem on_every_run {s₀ : S} (fixed : «定后于» (Steps P) s₀) :
    ∀ {s t : S} {as : List A}, Reach P s₀ s → Trace P s as t → ∀ (r : Run P) (k : Nat),
      r.state k = s → ∃ n, r.state (k + n) = t
  | _, _, _, _, .nil _, _, _, at_ => ⟨0, at_⟩
  | s, t, _, reached, @Trace.cons _ _ _ _ m _ a _ step rest, r, k, at_ =>
    have runStep : P.step s (r.act k) (r.state (k + 1)) :=
      Eq.subst (motive := fun x => P.step x (r.act k) (r.state (k + 1))) at_ (r.step k)
    have same : r.state (k + 1) = m :=
      fixed s (reach_iff_withinClosure.mp reached) _ _ ⟨r.act k, runStep⟩ ⟨a, step⟩
    match on_every_run fixed (reached.trans (Reach.of_step step)) rest r (k + 1) same with
    | ⟨n, passes⟩ =>
      ⟨n + 1, Eq.subst (motive := fun j => r.state j = t)
        ((Nat.succ_add k n).trans (Nat.add_succ k n).symm) passes⟩

/-- **Where the successor is fixed at what the presented configuration reaches** (`«定后于»` on
the steps), **the delivered configuration lies on every course from the presented one.** This is
constructor theory's invariable delivery without its halting. A process with at most one next
configuration everywhere gives the premise (`«定后则定后于»`). Nothing marks where a delivery ends,
so on UE10's climbing process every task each of whose inputs has an output at or ahead of it is
delivered invariably (`ClimbTask.invariably`), which constructor theory excludes by asking a
constructor to signal that it is done (Deutsch §3.13). -/
theorem Delivers.invariably (delivers : Delivers P part sub K T) {s : S}
    (fixed : «定后于» (Steps P) s) (inK : K (part s)) (input : Input T (sub s)) :
    ∃ t, Reach P s t ∧ K (part t) ∧ T (sub s) (sub t) ∧
      ∀ r : Run P, r.state 0 = s → ∃ n, r.state n = t :=
  match delivers s inK input with
  | ⟨t, ⟨as, trace⟩, inK', out⟩ => ⟨t, ⟨as, trace⟩, inK', out, fun r start =>
      match on_every_run fixed (Reach.refl P s) trace r 0 start with
      | ⟨n, passes⟩ => ⟨n, Eq.subst (motive := fun j => r.state j = t) (Nat.zero_add n) passes⟩⟩

/-- **On every process with a configuration, a task relating each of its inputs to itself is
performed with no performing part**, at zero moves, wherever each of its inputs is had. -/
theorem performs_identity {I : X → Prop} (inhabited : ∃ _ : S, True)
    (had : ∀ x, I x → ∃ s, sub s = x) :
    Performs P (fun _ => ()) sub (fun _ => True) (fun x y => I x ∧ y = x) :=
  ⟨⟨match inhabited with | ⟨s, _⟩ => ⟨s, trivial⟩,
    fun _ _ x ⟨_, inI, _⟩ => match had x inI with | ⟨t, same⟩ => ⟨t, rfl, same⟩⟩,
   fun s _ ⟨_, inI, _⟩ => ⟨s, Reach.refl P s, trivial, inI, rfl⟩⟩

/-- **A task with no legitimate input is possible on every process with a configuration**, with the
performing part trivial: presented with nothing, it has nothing to deliver. -/
theorem possible_of_no_input (inhabited : ∃ _ : S, True) (none : ∀ x, ¬ Input T x) :
    Possible P (fun _ => ()) sub T :=
  match inhabited with
  | ⟨s, _⟩ => ⟨fun _ => True, ⟨⟨s, trivial⟩, fun _ _ x input => (none x input).elim⟩,
      fun _ _ input => (none _ input).elim⟩

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

/-- A regular pair: every output of `T` is a legitimate input of `T'`. This is the inclusion of
constructor theory's clause on serial composition (Deutsch §1.2); its sentence on regular networks
can be read as equality of the two sets, and with inclusion the composition principle claims
more. -/
def Regular (T T' : X → X → Prop) : Prop := ∀ x y, T x y → Input T' y

/-- The parallel composite: `T` on one substrate and `T'` on another. -/
def parallel (T : X → X → Prop) (T' : Y → Y → Prop) (p q : X × Y) : Prop :=
  T p.1 q.1 ∧ T' p.2 q.2

/-- A reading the same is a class (`«类»`). -/
theorem sameReading_class (f : S → D) : «类» (fun s t : S => f t = f s) :=
  ⟨fun _ => rfl, fun same => same.symm, fun first second => second.trans first⟩

/-- **One region delivering a regular pair delivers it in series**: where `K` delivers `T` and `T'`,
and every output of `T` is an input of `T'`, `K` delivers `T` then `T'`. -/
theorem Delivers.serial (first : Delivers P part sub K T) (second : Delivers P part sub K T')
    (regular : Regular T T') : Delivers P part sub K («而» T T') :=
  fun s inK ⟨_, y, out, _⟩ => match first s inK ⟨y, out⟩ with
  | ⟨t, reach, inK', out'⟩ => match second t inK' (regular _ _ out') with
    | ⟨u, reach', inK'', out''⟩ => ⟨u, reach.trans reach', inK'', sub t, out', out''⟩

/-- **One region performing a task and delivering a second, every output of the first an input of
the second, performs the first then the second** (`Delivers.serial`): the second task need not be
presented, and no further premise is needed. -/
theorem Performs.serial (first : Performs P part sub K T) (second : Delivers P part sub K T')
    (regular : Regular T T') : Performs P part sub K («而» T T') :=
  ⟨⟨first.1.1, fun s inK x ⟨_, y, out, _⟩ => first.1.2 s inK x ⟨y, out⟩⟩,
   Delivers.serial first.2 second regular⟩

/-- **Delivered by the moves holding another reading, a task is delivered by the pair region**: the
region `K` of the first reading with any region `L` of the other, which those moves keep. -/
theorem Delivers.pair_left {part' : S → D} {L : D → Prop}
    (held : Delivers (Reaching.heldMoves P (fun s t => part' t = part' s)) part sub K T) :
    Delivers P (fun s => (part s, part' s)) sub (fun c => K c.1 ∧ L c.2) T :=
  fun s inKL input => match held s inKL.1 input with
  | ⟨t, reach, inK, out⟩ =>
    have kept : part' t = part' s := Reach.same_of_heldMoves (sameReading_class part') reach
    ⟨t, Reach.of_heldMoves reach, ⟨inK, Eq.subst (motive := L) kept.symm inKL.2⟩, out⟩

/-- **Delivered by the moves holding the first reading, a task is delivered by the pair region**,
the region `K` of the first reading kept. -/
theorem Delivers.pair_right {part' : S → D} {L : D → Prop}
    (held : Delivers (Reaching.heldMoves P (fun s t => part t = part s)) part' sub L T) :
    Delivers P (fun s => (part s, part' s)) sub (fun c => K c.1 ∧ L c.2) T :=
  fun s inKL input => match held s inKL.2 input with
  | ⟨t, reach, inL, out⟩ =>
    have kept : part t = part s := Reach.same_of_heldMoves (sameReading_class part) reach
    ⟨t, Reach.of_heldMoves reach, ⟨Eq.subst (motive := K) kept.symm inKL.1, inL⟩, out⟩

/-- **Two regions in series, each delivering by the moves holding the other's part**: where `K`
delivers `T` by the moves holding the part read by `part'` and `L` delivers `T'` by the moves
holding the part read by `part`, and every output of `T` is an input of `T'`, the two together
deliver `T` then `T'`. It is the one-region law (`Delivers.serial`) at the pair region. The holding
premise is sufficient, not needed: what the other uses restored at the end suffices
(`CatalysedSeries.performs_pair`). -/
theorem Delivers.serial_holding {part' : S → D} {L : D → Prop}
    (first : Delivers (Reaching.heldMoves P (fun s t => part' t = part' s)) part sub K T)
    (second : Delivers (Reaching.heldMoves P (fun s t => part t = part s)) part' sub L T')
    (regular : Regular T T') :
    Delivers P (fun s => (part s, part' s)) sub (fun c => K c.1 ∧ L c.2) («而» T T') :=
  Delivers.serial (Delivers.pair_left first) (Delivers.pair_right second) regular

/-- **One region delivering two tasks in turn, on two substrates**: where `K` delivers `T` by the
moves holding the second substrate and `T'` by the moves holding the first, it delivers the two in
parallel, one after the other. -/
theorem Delivers.parallel_inTurn {sub' : S → Y} {T' : Y → Y → Prop}
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

/-- Delivered by the moves holding another part and another substrate, a task is delivered by the
pair region with the other substrate held. -/
theorem Delivers.pair_left_held {part' : S → D} {sub' : S → Y} {L : D → Prop}
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

/-- Delivered by the moves holding the first part and the first substrate, a task on another
substrate is delivered by the pair region with the first substrate held. -/
theorem Delivers.pair_right_held {part' : S → D} {sub' : S → Y} {L : D → Prop}
    {T' : Y → Y → Prop}
    (held : Delivers (Reaching.heldMoves P (fun s t => (part t, sub t) = (part s, sub s)))
      part' sub' L T') :
    Delivers (Reaching.heldMoves P (fun s t => sub t = sub s)) (fun s => (part s, part' s)) sub'
      (fun c => K c.1 ∧ L c.2) T' :=
  fun s inKL input => match held s inKL.2 input with
  | ⟨t, reach, inL, out⟩ =>
    have kept : (part t, sub t) = (part s, sub s) :=
      Reach.same_of_heldMoves (sameReading_class fun s => (part s, sub s)) reach
    ⟨t, Reach.heldMoves_mono (fun _ _ same => (congrArg Prod.snd same : sub _ = sub _)) reach,
     ⟨Eq.subst (motive := K) (congrArg Prod.fst kept : part t = part s).symm inKL.1, inL⟩, out⟩

/-- **Two regions in parallel, each delivering by the moves holding what the other uses**: where
`K` delivers `T` on the substrate read by `sub` by the moves holding the other part and the other
substrate, and `L` delivers `T'` likewise, the two together deliver `T` and `T'` in parallel. It is
`Delivers.parallel_inTurn` at the pair region. -/
theorem Delivers.parallel_holding {part' : S → D} {sub' : S → Y} {L : D → Prop}
    {T' : Y → Y → Prop}
    (first : Delivers (Reaching.heldMoves P (fun s t => (part' t, sub' t) = (part' s, sub' s)))
      part sub K T)
    (second : Delivers (Reaching.heldMoves P (fun s t => (part t, sub t) = (part s, sub s)))
      part' sub' L T') :
    Delivers P (fun s => (part s, part' s)) (fun s => (sub s, sub' s)) (fun c => K c.1 ∧ L c.2)
      (parallel T T') :=
  Delivers.parallel_inTurn (Delivers.pair_left_held first) (Delivers.pair_right_held second)

/-- Read with the performing part trivial, a region performing a task can be taken as every state
of the part. -/
theorem Performs.unitPart {L : Unit → Prop} (performs : Performs P (fun _ => ()) sub L T) :
    Performs P (fun _ => ()) sub (fun _ => True) T :=
  match performs.1.1 with
  | ⟨s₀, inL⟩ =>
    ⟨⟨⟨s₀, trivial⟩, fun _ _ x input => match performs.1.2 s₀ inL x input with
       | ⟨t, _, at_⟩ => ⟨t, rfl, at_⟩⟩,
     fun s _ input => match performs.2 s inL input with
       | ⟨t, reach, _, out⟩ => ⟨t, reach, trivial, out⟩⟩

/-- **Where a task needs no performing part, a regular pair composes**: read with the performing
part trivial, so that the substrate is transformed from every configuration whatever the rest, a
regular pair of possible tasks is possible in series (`Performs.serial`). The pair must be regular
(`Unregular.composite_not_possible`). -/
theorem Possible.serial_of_unitPart (first : Possible P (fun _ => ()) sub T)
    (second : Possible P (fun _ => ()) sub T') (regular : Regular T T') :
    Possible P (fun _ => ()) sub («而» T T') :=
  match first, second with
  | ⟨_, performs⟩, ⟨_, performs'⟩ =>
    ⟨_, Performs.serial performs.unitPart performs'.unitPart.2 regular⟩

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

/-- What the interleaving reaches, the first process reaches on the first configurations. -/
theorem reach_fst_of_interleave :
    ∀ {s t : S × S'} {as : List (A ⊕ A')}, Trace (interleave P Q) s as t → Reach P s.1 t.1
  | _, _, _, .nil _ => Reach.refl _ _
  | _, _, _, @Trace.cons _ _ _ _ _ _ (.inl _) _ step rest =>
    (Reach.of_step step.1).trans (reach_fst_of_interleave rest)
  | _, t, _, @Trace.cons _ _ _ _ _ _ (.inr _) _ step rest =>
    Eq.subst (motive := fun x => Reach P x t.1) step.2 (reach_fst_of_interleave rest)

/-- What the interleaving reaches, the second process reaches on the second configurations. -/
theorem reach_snd_of_interleave :
    ∀ {s t : S × S'} {as : List (A ⊕ A')}, Trace (interleave P Q) s as t → Reach Q s.2 t.2
  | _, _, _, .nil _ => Reach.refl _ _
  | _, t, _, @Trace.cons _ _ _ _ _ _ (.inl _) _ step rest =>
    Eq.subst (motive := fun x => Reach Q x t.2) step.2 (reach_snd_of_interleave rest)
  | _, _, _, @Trace.cons _ _ _ _ _ _ (.inr _) _ step rest =>
    (Reach.of_step step.1).trans (reach_snd_of_interleave rest)

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

/-- Regions presented in each process are presented together in the interleaving. -/
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

/-- **Tasks possible in two processes are possible in parallel in their interleaving**, each task's
division read off its own process. -/
theorem Possible.parallel_interleave {part : S → C} {sub : S → X} {T : X → X → Prop}
    {part' : S' → D} {sub' : S' → Y} {T' : Y → Y → Prop}
    (first : Possible P part sub T) (second : Possible Q part' sub' T') :
    Possible (interleave P Q) (fun s => (part s.1, part' s.2)) (fun s => (sub s.1, sub' s.2))
      (parallel T T') :=
  match first, second with
  | ⟨_, performs⟩, ⟨_, performs'⟩ => ⟨_, performs.parallel_interleave performs'⟩

/-- A task possible in the interleaving with a division read off the first process is possible in
the first process. -/
theorem Possible.of_interleave_left {part : S → C} {sub : S → X} {T : X → X → Prop}
    (possible : Possible (interleave P Q) (fun s => part s.1) (fun s => sub s.1) T) :
    Possible P part sub T :=
  match possible with
  | ⟨K, ⟨⟨s₀, inK⟩, present⟩, delivers⟩ =>
    ⟨K, ⟨⟨s₀.1, inK⟩, fun s inK' x input => match present (s, s₀.2) inK' x input with
        | ⟨t, samePart, sameSub⟩ => ⟨t.1, samePart, sameSub⟩⟩,
     fun s inK' input => match delivers (s, s₀.2) inK' input with
        | ⟨t, ⟨_, trace⟩, inKt, out⟩ => ⟨t.1, reach_fst_of_interleave trace, inKt, out⟩⟩

/-- A task possible in the interleaving with a division read off the second process is possible in
the second process. -/
theorem Possible.of_interleave_right {part : S' → D} {sub : S' → Y} {T : Y → Y → Prop}
    (possible : Possible (interleave P Q) (fun s => part s.2) (fun s => sub s.2) T) :
    Possible Q part sub T :=
  match possible with
  | ⟨K, ⟨⟨s₀, inK⟩, present⟩, delivers⟩ =>
    ⟨K, ⟨⟨s₀.2, inK⟩, fun s inK' x input => match present (s₀.1, s) inK' x input with
        | ⟨t, samePart, sameSub⟩ => ⟨t.2, samePart, sameSub⟩⟩,
     fun s inK' input => match delivers (s₀.1, s) inK' input with
        | ⟨t, ⟨_, trace⟩, inKt, out⟩ => ⟨t.2, reach_snd_of_interleave trace, inKt, out⟩⟩

/-- **Conversely, a task possible in the first process is possible in the interleaving with its
division read off the first process**, given a configuration of the second. -/
theorem Possible.interleave_left {part : S → C} {sub : S → X} {T : X → X → Prop} (s₂ : S')
    (possible : Possible P part sub T) :
    Possible (interleave P Q) (fun s => part s.1) (fun s => sub s.1) T :=
  match possible with
  | ⟨K, ⟨⟨s₀, inK⟩, present⟩, delivers⟩ =>
    ⟨K, ⟨⟨(s₀, s₂), inK⟩, fun s inK' x input => match present s.1 inK' x input with
        | ⟨t, samePart, sameSub⟩ => ⟨(t, s.2), samePart, sameSub⟩⟩,
     (Delivers.interleave_left (Q := Q) delivers).of_heldMoves⟩

/-- **Conversely, a task possible in the second process is possible in the interleaving with its
division read off the second process**, given a configuration of the first. -/
theorem Possible.interleave_right {part : S' → D} {sub : S' → Y} {T : Y → Y → Prop} (s₁ : S)
    (possible : Possible Q part sub T) :
    Possible (interleave P Q) (fun s => part s.2) (fun s => sub s.2) T :=
  match possible with
  | ⟨K, ⟨⟨s₀, inK⟩, present⟩, delivers⟩ =>
    ⟨K, ⟨⟨(s₁, s₀), inK⟩, fun s inK' x input => match present s.2 inK' x input with
        | ⟨t, samePart, sameSub⟩ => ⟨(s.1, t), samePart, sameSub⟩⟩,
     (Delivers.interleave_right (P := P) delivers).of_heldMoves⟩

/-- **Within the interleaving on two substrates, tasks possible there with divisions read off each
process are possible in parallel**: since a move of either keeps the other's configuration, this is
the composition principle for a parallel pair within the interleaving, for divisions read off each
process. Possibility so read is possibility in each process (`Possible.of_interleave_left`,
`Possible.interleave_left`, and on the right), so this is `Possible.parallel_interleave` read
within the interleaving. -/
theorem Possible.parallel_within {part : S → C} {sub : S → X} {T : X → X → Prop}
    {part' : S' → D} {sub' : S' → Y} {T' : Y → Y → Prop}
    (first : Possible (interleave P Q) (fun s => part s.1) (fun s => sub s.1) T)
    (second : Possible (interleave P Q) (fun s => part' s.2) (fun s => sub' s.2) T') :
    Possible (interleave P Q) (fun s => (part s.1, part' s.2)) (fun s => (sub s.1, sub' s.2))
      (parallel T T') :=
  Possible.parallel_interleave (Possible.of_interleave_left first)
    (Possible.of_interleave_right second)

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
      («而» T T') :=
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

/-- **Tasks possible with two parts, each in its own process on one substrate, are possible in
series in their interleaving.** Where `T` is possible in the first process and `T'` in the second,
and every output of `T` is an input of `T'`, the two parts together perform `T` then `T'`.
Possibility is read in the two processes, not in the interleaving. Within one interleaving, a task
can be possible with one part's division through the other part's moves, and there a regular pair of
possible tasks can have no possible composite (`ResettingInterleaved.composition_fails_within`). -/
theorem Possible.serial_interleaveOn {P : Process (C × X) A} {Q : Process (D × X) A'}
    {T T' : X → X → Prop} (first : Possible P Prod.fst Prod.snd T)
    (second : Possible Q Prod.fst Prod.snd T') (regular : Regular T T') :
    Possible (interleaveOn P Q) (fun s => s.1) (fun s => s.2) («而» T T') :=
  match first, second with
  | ⟨_, performs⟩, ⟨_, performs'⟩ => ⟨_, performs.serial_interleaveOn performs' regular⟩

end Interleave

/-! ## The regress -/

section Tower

variable {Z : Type} {R : Type v} {base : R → Z → Z → Prop} {up : Nat → R → R → R → Prop}
  {K : (Nat → R) → Prop} {T : Z → Z → Prop}

/-- **What the tower reaches it reaches with the performers from some level up held**
(`Reaching.reach_held_of_sequence` at `RuleTower.SameFrom`, as in UE11's
`RuleTower.possible_iff_held`). -/
theorem tower_reach_held {s t : Z × (Nat → R)} (reach : Reach (RuleTower.process base up) s t) :
    ∃ n, Reach (Reaching.heldMoves (RuleTower.process base up) (RuleTower.SameFrom n)) s t :=
  Reaching.reach_held_of_sequence (P := RuleTower.process base up)
    (E := fun n => RuleTower.SameFrom n)
    (fun _ _ le _ _ same => RuleTower.SameFrom.mono same le)
    (fun _ a _ step => ⟨a, RuleTower.step_sameFrom a step⟩) reach

/-- **On a tower of performers with no top, every delivery is had with the performers from some
level up held**, and conversely (`tower_reach_held`). The move `k + 1` changes the performer at
level `k` as the one at level `k + 1` allows, so within a delivery each performer changed is changed
as the one above it allows, and the performers from some level up are not changed: a regress within
one performance, finite because a delivery is. Constructor theory's requirement that chains of
construction begin with naturally-occurring constructors concerns making the performer itself (the
pharaonic task, Deutsch §3.1), which `PossibleFrom` reads, and on the tower `tower_made_held`. Read
with the substrate the tower's state and the performing part its performers. -/
theorem tower_delivers_iff_held :
    Delivers (RuleTower.process base up) Prod.snd Prod.fst K T ↔
      ∀ s, K s.2 → Input T s.1 → ∃ n t,
        Reach (Reaching.heldMoves (RuleTower.process base up) (RuleTower.SameFrom n)) s t ∧
          K t.2 ∧ T s.1 t.1 :=
  ⟨fun delivers s inK input => match delivers s inK input with
     | ⟨t, reach, inK', out⟩ => match tower_reach_held reach with
       | ⟨n, held⟩ => ⟨n, t, held, inK', out⟩,
   fun held s inK input => match held s inK input with
     | ⟨_, t, reach, inK', out⟩ => ⟨t, Reach.of_heldMoves reach, inK', out⟩⟩

/-- **On a tower of performers with no top, a performer made from a natural configuration is made
with the performers from some level up held, as the natural configuration has them** (UE11's
`RuleTower.possible_iff_held`, at the part in the region; `tower_reach_held`). The construction
changes the substrate and the performers below some level, each as the one above allows, and takes
the performers from that level up as found. That it begins with a natural configuration is
`PossibleFrom`, this theorem's hypothesis, which reads constructor theory's requirement on chains of
construction (Deutsch §3.1). The theorem adds that on the tower the regress the requirement avoids
ends at a finite height, because a construction is a finite trace. -/
theorem tower_made_held {natural : Z × (Nat → R) → Prop}
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

end Tower

/-! ## What can be done with the part held -/

section PartHeld

variable {S : Type u} {A : Type v} {C : Type w} {X : Type} {P : Process S A} {part : S → C}
  {sub : S → X}

/-- **What can be done with the performing part held**: the substrate states reached from `s` by
the moves holding the performing part unchanged, UE11's possible relative to a held part
(`Reaching.PossibleHeld`) at the part's sameness and the substrate's reading. -/
def PossibleWithPartHeld (P : Process S A) (part : S → C) (sub : S → X) (s : S) (y : X) : Prop :=
  Reaching.PossibleHeld P (fun s t => part t = part s) (fun t y => sub t = y) s y

/-- Delivered by the moves holding the performing part unchanged, from a configuration with the
part in `K` and the substrate a legitimate input some output can be done with the part held. -/
theorem Delivers.possibleWithPartHeld {K : C → Prop} {T : X → X → Prop}
    (delivers : Delivers (Reaching.heldMoves P (fun s t => part t = part s)) part sub K T)
    {s : S} (inK : K (part s)) (input : Input T (sub s)) :
    ∃ y, T (sub s) y ∧ PossibleWithPartHeld P part sub s y :=
  match delivers s inK input with
  | ⟨t, reach, _, out⟩ => ⟨sub t, out, t, reach, rfl⟩

/-- **What can be done with the part held grows only across steps changing the part**
(`Run.changes_of_heldGrows`). -/
theorem changes_of_partHeldGrows (r : Run P) (n : Nat) {y : X}
    (grows : PossibleWithPartHeld P part sub (r.state (n + 1)) y ∧
      ¬ PossibleWithPartHeld P part sub (r.state n) y) :
    part (r.state (n + 1)) ≠ part (r.state n) :=
  r.changes_of_heldGrows (Same := fun s t => part t = part s) (adm := fun t y => sub t = y) n grows

/-- **From the step at which the part stays for good, nothing is added to what can be done with
it held** (`Run.possibleHeld_of_stays`). -/
theorem possibleWithPartHeld_of_stays (r : Run P) {N : Nat}
    (stays : ∀ n, N ≤ n → part (r.state (n + 1)) = part (r.state n)) (d : Nat) {y : X}
    (later : PossibleWithPartHeld P part sub (r.state (N + d)) y) :
    PossibleWithPartHeld P part sub (r.state N) y :=
  r.possibleHeld_of_stays (Same := fun s t => part t = part s) (adm := fun t y => sub t = y)
    stays d later

/-- **What can be done with the part held keeps widening only where the part does not stay**
(`Run.changes_of_heldKeepsWidening`): from every step some bounded stretch of the course does not
keep it throughout. -/
theorem changes_of_partHeldKeepsWidening (r : Run P)
    (keeps : Reaching.KeepsWidening (fun n => PossibleWithPartHeld P part sub (r.state n)))
    (N : Nat) : ∃ d, ¬ ∀ i, i < d → part (r.state (N + i + 1)) = part (r.state (N + i)) :=
  r.changes_of_heldKeepsWidening (Same := fun s t => part t = part s)
    (adm := fun t y => sub t = y) keeps N

/-- **What can be done with the part held does not keep widening where a list holds the substrate
states reachable from the course's start** (`Run.not_heldKeepsWidening_of_listed`). -/
theorem not_partHeldKeepsWidening_of_listed (r : Run P)
    (listed : ∃ ys : List X, ∀ y, Reaching.Possible P (fun t y => sub t = y) (r.state 0) y →
      y ∈ ys) :
    ¬ Reaching.KeepsWidening (fun n => PossibleWithPartHeld P part sub (r.state n)) :=
  r.not_heldKeepsWidening_of_listed (Same := fun s t => part t = part s) listed

end PartHeld

/-! ## The order possible tasks carry -/

section Order

variable {S : Type u} {A : Type v} {C : Type w} {X : Type} {P : Process S A} {part : S → C}
  {sub : S → X} {K : C → Prop} {T : X → X → Prop}

/-- **A delivery adds nothing to the whole possible**: from every configuration with the part in
`K` and the substrate a legitimate input, the process reaches one with an output, from which nothing
is possible that is not possible from the first (`Reaching.Possible.of_reach`), and which the first
covers with a lag (`Reaching.coversLater_of_trace`), so that widening with a lag does not rank it
above the first (`Reaching.not_widensWithLag_of_reach`). Covering reads infinite runs, so where the
output starts none, the last conjunct holds of every configuration (`Catalysis.coversLater_all`). -/
theorem Delivers.adds_nothing (delivers : Delivers P part sub K T) {s : S} (inK : K (part s))
    (input : Input T (sub s)) {Y : Type} (adm : S → Y → Prop) :
    ∃ t, Reach P s t ∧ K (part t) ∧ T (sub s) (sub t) ∧
      (∀ y, Reaching.Possible P adm t y → Reaching.Possible P adm s y) ∧
      ∃ d, Reaching.CoversLater P adm d s t :=
  match delivers s inK input with
  | ⟨t, reach, inK', out⟩ =>
    ⟨t, reach, inK', out, fun _ possible => Reaching.Possible.of_reach reach possible,
     match reach with
     | ⟨_, trace⟩ => ⟨_, Reaching.coversLater_of_trace trace⟩⟩

end Order

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

/-- **Held unchanged at every move, the enzyme does not deliver either**: UE11's possible relative
to a held part, at the enzyme. -/
theorem not_held_unchanged :
    ¬ Delivers (Reaching.heldMoves process (fun s t => t.1 = s.1)) Prod.fst Prod.snd Free task :=
  fun held => match held (true, false) rfl ⟨true, rfl, rfl⟩ with
  | ⟨_, ⟨_, .nil _⟩, _, _, isProduct⟩ => Bool.noConfusion isProduct
  | ⟨_, ⟨_, .cons ⟨.inl ⟨_, bound⟩, kept⟩ _⟩, _, _⟩ =>
    Bool.noConfusion ((congrArg Prod.fst bound).symm.trans kept)
  | ⟨_, ⟨_, .cons ⟨.inr ⟨atStart, _⟩, _⟩ _⟩, _, _⟩ =>
    Bool.noConfusion (congrArg Prod.fst atStart)

/-- The product stays the product. -/
theorem product_stays : Invariant process (fun s => s.2 = true) :=
  fun _ _ _ step product => match step with
  | .inl ⟨atStart, _⟩ => Bool.noConfusion ((congrArg Prod.snd atStart).symm.trans product)
  | .inr ⟨atStart, _⟩ => Bool.noConfusion ((congrArg Prod.snd atStart).symm.trans product)

/-- **The transpose is performed by no region of any reading of a performing part**: no course
turns the product back into the substrate. The task is possible and its transpose (`«逆»`) is
not. -/
theorem transpose_not_possible {D : Type w} (part : Bool × Bool → D) :
    ¬ Possible process part Prod.snd («逆» task) :=
  fun ⟨K, ⟨⟨s₀, inK⟩, present⟩, delivers⟩ =>
    match present s₀ inK true ⟨false, rfl, rfl⟩ with
    | ⟨t, samePart, isProduct⟩ =>
      match delivers t (Eq.subst (motive := K) samePart.symm inK) ⟨false, rfl, isProduct⟩ with
      | ⟨_, reach, _, restored, _⟩ =>
        Bool.noConfusion ((product_stays.reach reach isProduct).symm.trans restored)

/-- **The delivery narrows the whole possible strictly**: the substrate is possible from the free
enzyme with the substrate, and not from the free enzyme with the product, which the delivery
reaches. -/
theorem narrows :
    Reaching.Possible process (fun t y => t.2 = y) (true, false) false ∧
      ¬ Reaching.Possible process (fun t y => t.2 = y) (true, true) false :=
  ⟨⟨(true, false), Reach.refl _ _, rfl⟩,
   fun ⟨_, reach, isSubstrate⟩ =>
     Bool.noConfusion ((product_stays.reach reach rfl).symm.trans isSubstrate)⟩

/-- Every move of the catalytic cycle ends with the enzyme bound to the substrate, or free with the
product. -/
theorem into {s : Bool × Bool} {a : Unit} {t : Bool × Bool} (step : process.step s a t) :
    t = (false, false) ∨ t = (true, true) :=
  match step with
  | .inl ⟨_, done⟩ => .inl done
  | .inr ⟨_, done⟩ => .inr done

/-- Nothing moves from the free enzyme with the product. -/
theorem stuck {a : Unit} {t : Bool × Bool} : ¬ process.step (true, true) a t :=
  fun step => match step with
  | .inl ⟨atStart, _⟩ => Bool.noConfusion (congrArg Prod.snd atStart)
  | .inr ⟨atStart, _⟩ => Bool.noConfusion (congrArg Prod.fst atStart)

/-- **No configuration of the catalytic cycle starts a course**: every course would stop by its
third step. -/
theorem no_course (r : Run process) : False :=
  have first : process.step (r.state 0) (r.act 0) (r.state 1) := r.step 0
  have second : process.step (r.state 1) (r.act 1) (r.state 2) := r.step 1
  have third : process.step (r.state 2) (r.act 2) (r.state 3) := r.step 2
  match into first with
  | .inr free =>
    stuck (Eq.subst (motive := fun x => process.step x (r.act 1) (r.state 2)) free second)
  | .inl bound =>
    match (Eq.subst (motive := fun x => process.step x (r.act 1) (r.state 2)) bound
        second : process.step (false, false) (r.act 1) (r.state 2)) with
    | .inl ⟨atStart, _⟩ => Bool.noConfusion (congrArg Prod.fst atStart)
    | .inr ⟨_, done⟩ =>
      stuck (Eq.subst (motive := fun x => process.step x (r.act 2) (r.state 3)) done third)

/-- **So on the catalytic cycle every configuration covers every other with every lag**: covering
reads infinite runs, and none starts here. -/
theorem coversLater_all {Y : Type} (adm : Bool × Bool → Y → Prop) (d : Nat) (s s' : Bool × Bool) :
    Reaching.CoversLater process adm d s s' :=
  fun r' _ => (no_course r').elim

/-- **And UE10's lagged order ranks no configuration above another there**, while the delivery
narrows the whole possible strictly (`narrows`). -/
theorem not_widensOrLater {Y : Type} (adm : Bool × Bool → Y → Prop) (s s' : Bool × Bool) :
    ¬ Reaching.WidensOrLater process adm s s' :=
  fun above => match above with
  | .inl ⟨_, r, _, _⟩ => no_course r
  | .inr ⟨_, notBack⟩ => notBack ⟨0, coversLater_all adm 0 s' s⟩

end Catalysis

/-! ### A resetting process: composition fails where a delivery changes what its task does not list -/

namespace Resetting

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

/-- **The first task then the second is performed by no region of any reading of a performing
part**: presented with the substrate at `0`, no course reaches `2`. -/
theorem not_possible {D : Type w} (part : Bool × Nat → D) :
    ¬ Possible process part Prod.snd («而» first second) :=
  fun ⟨K, ⟨⟨s₀, inK⟩, present⟩, delivers⟩ =>
    have input : Input («而» first second) 0 := ⟨2, 1, ⟨rfl, rfl⟩, rfl, rfl⟩
    match present s₀ inK 0 input with
    | ⟨t, samePart, atZero⟩ =>
      match delivers t (Eq.subst (motive := K) samePart.symm inK)
          (Eq.subst (motive := Input («而» first second)) atZero.symm input) with
      | ⟨_, reach, _, _, _, isTwo⟩ => not_two reach atZero isTwo.2

/-- **Every delivery of the first task resets the second part**: delivered by moves holding it, the
first task is not delivered from the second part on. -/
theorem not_holding :
    ¬ Delivers (Reaching.heldMoves process (fun s t => t.1 = s.1)) (fun _ => ()) Prod.snd
      (fun _ => True) first :=
  fun held => match held (true, 0) trivial ⟨1, rfl, rfl⟩ with
  | ⟨_, ⟨_, .nil _⟩, _, _, isOne⟩ => Nat.noConfusion isOne.symm
  | ⟨_, ⟨_, .cons ⟨.inl ⟨_, off⟩, kept⟩ _⟩, _, _⟩ =>
    Bool.noConfusion ((congrArg Prod.fst off).symm.trans kept)
  | ⟨_, ⟨_, .cons ⟨.inr ⟨atOne, _⟩, _⟩ _⟩, _, _⟩ =>
    Nat.noConfusion (congrArg Prod.snd atOne).symm

/-- **Composition fails where a delivery changes what its task does not list.** The first task is
performed with a trivial performing part and the second by the second part on. Every output of the
first is an input of the second. The first then the second is performed by no region of any
reading of a performing part, because every delivery of the first task resets the second part
(`not_holding`), which that task does not list. Constructor theory asks a task to list its
unavoidable outputs, reading a constructor with its substrates as a closed system (Deutsch §1.1).
Listed so, this pair is not regular (`listed_not_regular`). Read as each delivery holding what its
task does not list, that requirement gives the premise of `Delivers.serial_holding`, under which the
composite is delivered. -/
theorem composition_fails :
    Performs process (fun _ => ()) Prod.snd (fun _ => True) first ∧
      Performs process Prod.fst Prod.snd On second ∧ Regular first second ∧
      ∀ (D : Type w) (part : Bool × Nat → D), ¬ Possible process part Prod.snd («而» first second) :=
  ⟨performs_first, performs_second, regular, fun _ part => not_possible part⟩

/-- The first task listing the second part, which every delivery of it sets off. -/
def firstListed (x y : Bool × Nat) : Prop := x.2 = 0 ∧ y = (false, 1)

/-- The second task listing the second part, which it needs on. -/
def secondListed (x y : Bool × Nat) : Prop := x = (true, 1) ∧ y = (true, 2)

/-- **Listed with the part every delivery of it changes, the first task's output is not an input
of the second**: the pair is not regular. -/
theorem listed_not_regular : ¬ Regular firstListed secondListed :=
  fun regular => match regular (false, 0) (false, 1) ⟨rfl, rfl⟩ with
  | ⟨_, isOn, _⟩ => Bool.noConfusion (congrArg Prod.fst isOn)

/-- The second part, in any state, performs the first task. -/
theorem performs_first_by_part : Performs process Prod.fst Prod.snd (fun _ => True) first :=
  ⟨⟨⟨(false, 0), trivial⟩, fun s _ x _ => ⟨(s.1, x), rfl, rfl⟩⟩,
   fun s _ ⟨_, atZero, _⟩ =>
     have moves : process.step s () (false, 1) := .inl ⟨atZero, rfl⟩
     ⟨(false, 1), Reach.of_step moves, trivial, atZero, rfl⟩⟩

/-- **One part under two regions need not compose**: the second part performs the first task with
every state and the second with on, the pair is regular, and the first then the second is performed
by no region of it. -/
theorem one_part_two_regions :
    Performs process Prod.fst Prod.snd (fun _ => True) first ∧
      Performs process Prod.fst Prod.snd On second ∧ Regular first second ∧
      ¬ Possible process Prod.fst Prod.snd («而» first second) :=
  ⟨performs_first_by_part, performs_second, regular, not_possible Prod.fst⟩

end Resetting

/-! ### A catalysed series: the holding premise is sufficient, not needed -/

namespace CatalysedSeries

/-- A configuration is an enzyme, free (`true`) or bound (`false`), and a count: the free enzyme
binds at `0`, the bound enzyme is released with the count at `1`, and the free enzyme moves the
count from `1` to `2`. -/
def process : Process (Bool × Nat) Unit :=
  ⟨fun s _ t => (s = (true, 0) ∧ t = (false, 0)) ∨ (s = (false, 0) ∧ t = (true, 1)) ∨
    (s = (true, 1) ∧ t = (true, 2))⟩

/-- **The first task is not delivered by moves holding the enzyme**: from the free enzyme at `0`
the only move binds it, so `Delivers.serial_holding`'s first premise fails. -/
theorem not_holding :
    ¬ Delivers (Reaching.heldMoves process (fun s t => t.1 = s.1)) (fun _ => ()) Prod.snd
      (fun _ => True) Resetting.first :=
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
      («而» Resetting.first Resetting.second) :=
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

end CatalysedSeries

/-! ### A pair not regular: with no performing part, serial composition needs regularity -/

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

/-- **Two tasks possible with no performing part, not a regular pair, whose composite is performed
by no region of any reading**: `Possible.serial_of_unitPart` needs its regular pair. -/
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

/-! ### Within one interleaving on one substrate, composition can fail -/

namespace ResettingInterleaved

/-- A performing part that never moves. -/
def idle : Process (Unit × Nat) Unit := ⟨fun _ _ _ => False⟩

/-- The idle part and the resetting process's part interleaved on one count. -/
def process : Process ((Unit × Bool) × Nat) (Unit ⊕ Unit) := interleaveOn idle Resetting.process

/-- The first task is possible with the first part's division: the second part's moves deliver
it. -/
theorem first_possible : Possible process (fun s => s.1.1) (fun s => s.2) Resetting.first :=
  ⟨fun _ => True,
   ⟨⟨(((), false), 0), trivial⟩, fun s _ x _ => ⟨(s.1, x), rfl, rfl⟩⟩,
   fun s _ ⟨_, atZero, _⟩ =>
     have moves : process.step s (.inr ()) ((s.1.1, false), 1) := ⟨.inl ⟨atZero, rfl⟩, rfl⟩
     ⟨((s.1.1, false), 1), Reach.of_step moves, trivial, atZero, rfl⟩⟩

/-- The second task is possible with the second part's division. -/
theorem second_possible : Possible process (fun s => s.1.2) (fun s => s.2) Resetting.second :=
  ⟨Resetting.On,
   ⟨⟨(((), true), 1), rfl⟩, fun s _ x _ => ⟨(s.1, x), rfl, rfl⟩⟩,
   fun s on ⟨_, atOne, _⟩ =>
     have moves : process.step s (.inr ()) ((s.1.1, true), 2) :=
       ⟨.inr ⟨congr (congrArg Prod.mk on) atOne, rfl⟩, rfl⟩
     ⟨((s.1.1, true), 2), Reach.of_step moves, rfl, atOne, rfl⟩⟩

/-- From a count at `0`, the count stays at `0`, or the second part is off with the count at
`1`. -/
theorem stays : Invariant process (fun s => s.2 = 0 ∨ (s.1.2 = false ∧ s.2 = 1)) :=
  fun _ a _ step held => match a, step, held with
  | .inl _, step, _ => False.elim step.1
  | .inr _, ⟨.inl ⟨_, done⟩, _⟩, _ =>
    .inr ⟨(congrArg Prod.fst done : _), (congrArg Prod.snd done : _)⟩
  | .inr _, ⟨.inr ⟨atOne, _⟩, _⟩, .inl atZero =>
    Nat.noConfusion ((congrArg Prod.snd atOne).symm.trans atZero)
  | .inr _, ⟨.inr ⟨atOne, _⟩, _⟩, .inr ⟨off, _⟩ =>
    Bool.noConfusion ((congrArg Prod.fst atOne).symm.trans off)

/-- From a count at `0`, no course reaches the count at `2`. -/
theorem not_two {s t : (Unit × Bool) × Nat} (reach : Reach process s t) (atZero : s.2 = 0) :
    t.2 ≠ 2 :=
  fun atTwo => match stays.reach reach (.inl atZero) with
  | .inl zero => Nat.noConfusion (atTwo.symm.trans zero)
  | .inr ⟨_, one⟩ => Nat.noConfusion (Nat.succ.inj (one.symm.trans atTwo))

/-- The first task then the second is performed by no region of any reading of a performing
part. -/
theorem not_possible {D : Type w} (part : (Unit × Bool) × Nat → D) :
    ¬ Possible process part (fun s => s.2) («而» Resetting.first Resetting.second) :=
  fun ⟨K, ⟨⟨s₀, inK⟩, present⟩, delivers⟩ =>
    have input : Input («而» Resetting.first Resetting.second) 0 := ⟨2, 1, ⟨rfl, rfl⟩, rfl, rfl⟩
    match present s₀ inK 0 input with
    | ⟨t, samePart, atZero⟩ =>
      match delivers t (Eq.subst (motive := K) samePart.symm inK)
          (Eq.subst (motive := Input («而» Resetting.first Resetting.second)) atZero.symm
            input) with
      | ⟨_, reach, _, _, _, isTwo⟩ => not_two reach atZero isTwo.2

/-- **Within `interleaveOn`, two possible tasks, each with its own part's division, form a regular
pair whose composite no reading performs.** Every move holds the other part, as locality asks; the
first task is credited to the idle part but delivered by the second part's moves, which reset the
second part. -/
theorem composition_fails_within :
    Possible process (fun s => s.1.1) (fun s => s.2) Resetting.first ∧
      Possible process (fun s => s.1.2) (fun s => s.2) Resetting.second ∧
      Regular Resetting.first Resetting.second ∧
      ∀ (D : Type w) (part : (Unit × Bool) × Nat → D),
        ¬ Possible process part (fun s => s.2) («而» Resetting.first Resetting.second) :=
  ⟨first_possible, second_possible, Resetting.regular, fun _ part => not_possible part⟩

end ResettingInterleaved

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

/-- Whether the two together hold one unit. -/
def holdsOne : Bool × Bool → Bool
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
theorem unit_stays : Invariant process (fun s => s = (false, true) ∨ s = (true, false)) :=
  fun _ _ _ step _ => match step with
  | .inl ⟨_, done⟩ => .inr done
  | .inr ⟨_, done⟩ => .inl done

/-- From the first empty, a reached configuration with the first full has the second empty. -/
theorem second_empty_of_raised :
    ∀ {t u : Bool × Bool}, t.1 = false → Reach process t u → u.1 = true → u.2 = false
  | (false, false), _, _, reach, _ => congrArg Prod.snd (empty_stays.reach reach rfl)
  | (false, true), _, _, reach, raised => match unit_stays.reach reach (.inl rfl) with
    | .inl atStart => Bool.noConfusion (raised.symm.trans (congrArg Prod.fst atStart))
    | .inr done => congrArg Prod.snd done
  | (true, _), _, empty, _, _ => Bool.noConfusion empty

/-- From the second full, a reached configuration with the second empty has the first full. -/
theorem first_full_of_lowered :
    ∀ {t u : Bool × Bool}, t.2 = true → Reach process t u → u.2 = false → u.1 = true
  | (true, true), _, _, reach, lowered =>
    Bool.noConfusion ((congrArg Prod.snd (full_stays.reach reach rfl)).symm.trans lowered)
  | (false, true), _, _, reach, lowered => match unit_stays.reach reach (.inl rfl) with
    | .inl atStart => Bool.noConfusion ((congrArg Prod.snd atStart).symm.trans lowered)
    | .inr done => congrArg Prod.fst done
  | (_, false), _, full, _, _ => Bool.noConfusion full

/-- From the first full, a reached configuration with the first empty has the second full. -/
theorem second_full_of_emptied :
    ∀ {t u : Bool × Bool}, t.1 = true → Reach process t u → u.1 = false → u.2 = true
  | (true, true), _, _, reach, emptied =>
    Bool.noConfusion ((congrArg Prod.fst (full_stays.reach reach rfl)).symm.trans emptied)
  | (true, false), _, _, reach, emptied => match unit_stays.reach reach (.inr rfl) with
    | .inl done => congrArg Prod.snd done
    | .inr atStart => Bool.noConfusion ((congrArg Prod.fst atStart).symm.trans emptied)
  | (false, _), _, full, _, _ => Bool.noConfusion full

/-- From the second empty, a reached configuration with the second full has the first empty. -/
theorem first_empty_of_raised_second :
    ∀ {t u : Bool × Bool}, t.2 = false → Reach process t u → u.2 = true → u.1 = false
  | (false, false), _, _, reach, _ => congrArg Prod.fst (empty_stays.reach reach rfl)
  | (true, false), _, _, reach, raised => match unit_stays.reach reach (.inr rfl) with
    | .inl done => congrArg Prod.fst done
    | .inr atStart => Bool.noConfusion (raised.symm.trans (congrArg Prod.snd atStart))
  | (_, true), _, empty, _, _ => Bool.noConfusion empty

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

/-- **No reading of the first substrate performs raising the second**: from both empty nothing
moves, and from the first full the unit passes, leaving the first empty. -/
theorem not_raise_second {D : Type w} (f : Bool → D) :
    ¬ Possible process (fun s => f s.1) Prod.snd raise :=
  fun ⟨K, ⟨⟨s₀, inK⟩, present⟩, delivers⟩ =>
    have emptyFails : ¬ K (f false) := fun inEmpty =>
      match delivers (false, false) inEmpty ⟨true, rfl, rfl⟩ with
      | ⟨_, reach, _, _, raised⟩ =>
        Bool.noConfusion ((congrArg Prod.snd (empty_stays.reach reach rfl)).symm.trans raised)
    match present s₀ inK false ⟨true, rfl, rfl⟩ with
    | ⟨t, samePart, isEmpty⟩ =>
      match delivers t (Eq.subst (motive := K) samePart.symm inK) ⟨true, isEmpty, rfl⟩ with
      | ⟨_, reach, inKu, _, raised⟩ =>
        emptyFails (Eq.subst (motive := fun b => K (f b))
          (first_empty_of_raised_second isEmpty reach raised) inKu)

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

/-- **No reading of the second substrate itself performs lowering it**: presented with the second
full, its reading is the one it has with both full, from which nothing moves. -/
theorem not_lower_alone {D : Type w} (f : Bool → D) :
    ¬ Possible process (fun s => f s.2) Prod.snd lower :=
  fun ⟨K, ⟨⟨s₀, inK⟩, present⟩, delivers⟩ =>
    match present s₀ inK true ⟨false, rfl, rfl⟩ with
    | ⟨_, samePart, isFull⟩ =>
      have inFull : K (f true) := Eq.subst (motive := fun b => K (f b)) isFull
        (Eq.subst (motive := K) samePart.symm inK)
      match delivers (true, true) inFull ⟨false, rfl, rfl⟩ with
      | ⟨_, reach, _, _, lowered⟩ =>
        Bool.noConfusion ((congrArg Prod.snd (full_stays.reach reach rfl)).symm.trans lowered)

/-- **No reading of the first substrate itself performs lowering it**: presented with the first
full, its reading is the one it has with both full, from which nothing moves. -/
theorem not_lower_first_alone {D : Type w} (f : Bool → D) :
    ¬ Possible process (fun s => f s.1) Prod.fst lower :=
  fun ⟨K, ⟨⟨s₀, inK⟩, present⟩, delivers⟩ =>
    match present s₀ inK true ⟨false, rfl, rfl⟩ with
    | ⟨_, samePart, isFull⟩ =>
      have inFull : K (f true) := Eq.subst (motive := fun b => K (f b)) isFull
        (Eq.subst (motive := K) samePart.symm inK)
      match delivers (true, true) inFull ⟨false, rfl, rfl⟩ with
      | ⟨_, reach, _, _, lowered⟩ =>
        Bool.noConfusion ((congrArg Prod.fst (full_stays.reach reach rfl)).symm.trans lowered)

/-- **No reading of the second substrate itself performs raising it**: presented with the second
empty, its reading is the one it has with both empty, from which nothing moves. -/
theorem not_raise_second_alone {D : Type w} (f : Bool → D) :
    ¬ Possible process (fun s => f s.2) Prod.snd raise :=
  fun ⟨K, ⟨⟨s₀, inK⟩, present⟩, delivers⟩ =>
    match present s₀ inK false ⟨true, rfl, rfl⟩ with
    | ⟨_, samePart, isEmpty⟩ =>
      have inEmpty : K (f false) := Eq.subst (motive := fun b => K (f b)) isEmpty
        (Eq.subst (motive := K) samePart.symm inK)
      match delivers (false, false) inEmpty ⟨true, rfl, rfl⟩ with
      | ⟨_, reach, _, _, raised⟩ =>
        Bool.noConfusion ((congrArg Prod.snd (empty_stays.reach reach rfl)).symm.trans raised)

/-- **A possible whole of impossible parts**: the first raised and the second lowered, in parallel,
are possible; raising the first is performed by no region of any reading of the second substrate
alone, and lowering the second by none of any reading of the first alone. Readings of the two
together are not ranged over, and one of them performs (`performs_with_one`). -/
theorem whole_of_impossible_parts {D : Type w} :
    Possible process (fun _ => ()) id (parallel raise lower) ∧
      (∀ f : Bool → D, ¬ Possible process (fun s => f s.2) Prod.fst raise) ∧
      (∀ f : Bool → D, ¬ Possible process (fun s => f s.1) Prod.snd lower) :=
  ⟨⟨_, performs_both⟩, not_raise, not_lower⟩

/-- **Lowering the first, the transpose of raising it, is performed by no region of any reading of
the second substrate**: from both full nothing moves, and from the first full the unit passes,
leaving the second full. -/
theorem not_lower_first {D : Type w} (f : Bool → D) :
    ¬ Possible process (fun s => f s.2) Prod.fst lower :=
  fun ⟨K, ⟨⟨s₀, inK⟩, present⟩, delivers⟩ =>
    have fullFails : ¬ K (f true) := fun inFull =>
      match delivers (true, true) inFull ⟨false, rfl, rfl⟩ with
      | ⟨_, reach, _, _, emptied⟩ =>
        Bool.noConfusion
          ((congrArg Prod.fst (full_stays.reach reach rfl)).symm.trans emptied)
    match present s₀ inK true ⟨false, rfl, rfl⟩ with
    | ⟨t, samePart, isFull⟩ =>
      match delivers t (Eq.subst (motive := K) samePart.symm inK) ⟨false, isFull, rfl⟩ with
      | ⟨_, reach, inKu, _, emptied⟩ =>
        fullFails (Eq.subst (motive := fun b => K (f b))
          (second_full_of_emptied isFull reach emptied) inKu)

/-- **The first lowered and the second raised, in parallel, are performed with a trivial performing
part.** -/
theorem performs_lower_raise :
    Performs process (fun _ => ()) id (fun _ => True) (parallel lower raise) :=
  ⟨⟨⟨(true, false), trivial⟩, fun _ _ p _ => ⟨p, rfl, rfl⟩⟩,
   fun s _ ⟨_, ⟨isFull, _⟩, isEmpty, _⟩ =>
     have moves : process.step s () (false, true) :=
       .inr ⟨congr (congrArg Prod.mk isFull) isEmpty, rfl⟩
     ⟨(false, true), Reach.of_step moves, trivial, ⟨isFull, rfl⟩, isEmpty, rfl⟩⟩

/-- **Constructor theory's pattern for an additive conservation law (Deutsch §3.4)**, with each
substrate's change performed by readings of the other: raising the first and its transpose,
lowering it, are performed by no region of any reading of the second; raising the second and
lowering it, by none of any reading of the first; and each transpose in parallel with the other
raising is possible, lowering the first with raising the second and raising the first with
lowering the second. -/
theorem additive_pattern {D : Type w} :
    (∀ f : Bool → D, ¬ Possible process (fun s => f s.2) Prod.fst raise) ∧
      (∀ f : Bool → D, ¬ Possible process (fun s => f s.2) Prod.fst lower) ∧
      (∀ f : Bool → D, ¬ Possible process (fun s => f s.1) Prod.snd raise) ∧
      (∀ f : Bool → D, ¬ Possible process (fun s => f s.1) Prod.snd lower) ∧
      Possible process (fun _ => ()) id (parallel lower raise) ∧
      Possible process (fun _ => ()) id (parallel raise lower) :=
  ⟨not_raise, not_lower_first, not_raise_second, not_lower, ⟨_, performs_lower_raise⟩,
   ⟨_, performs_both⟩⟩

/-- Whether the two together hold one unit is their exclusive or. -/
theorem holdsOne_eq_xor : ∀ s : Bool × Bool, holdsOne s = xor s.1 s.2
  | (false, false) => rfl
  | (false, true) => rfl
  | (true, false) => rfl
  | (true, true) => rfl

/-- **With the first substrate, whether the two together hold one unit recodes the configuration one
to one.** -/
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

/-- **Every move keeps whether the two together hold one unit**: read as the performing part, it is
an invariant of the process, so every region of it is restored by every course. -/
theorem holdsOne_kept : ∀ s a t, process.step s a t → holdsOne t = holdsOne s
  | _, _, _, .inl ⟨atStart, done⟩ =>
    (congrArg holdsOne done).trans
      ((rfl : holdsOne (true, false) = holdsOne (false, true)).trans
        (congrArg holdsOne atStart).symm)
  | _, _, _, .inr ⟨atStart, done⟩ =>
    (congrArg holdsOne done).trans
      ((rfl : holdsOne (false, true) = holdsOne (true, false)).trans
        (congrArg holdsOne atStart).symm)

/-- **The division matters.** With the performing part read as whether the two together hold one
unit, raising the first is performed. That reading is their exclusive or (`holdsOne_eq_xor`). Every
move keeps it (`holdsOne_kept`), and with the first substrate it recodes the configuration one to
one (`holdsOne_recodes`). An invariant of the process read as the performer is never consumed; the
same reading performs each of the four single tasks (`performs_lower_first_with_one`,
`performs_raise_second_with_one`, `performs_lower_second_with_one`). Constructor theory's verdict,
that a task changing a substrate's conserved amount is impossible, needs the performer read off the
rest of the configuration (`whole_of_impossible_parts`). -/
theorem performs_with_one : Performs process holdsOne Prod.fst (fun c => c = true) raise :=
  ⟨⟨⟨(false, true), rfl⟩, fun _ held _ ⟨_, isEmpty, _⟩ => ⟨(false, true), held.symm, isEmpty.symm⟩⟩,
   fun s held ⟨_, isEmpty, _⟩ => match s, held, isEmpty with
     | (false, true), _, _ =>
       have moves : process.step (false, true) () (true, false) := .inl ⟨rfl, rfl⟩
       ⟨(true, false), Reach.of_step moves, rfl, rfl, rfl⟩
     | (false, false), held, _ => Bool.noConfusion held
     | (true, _), _, isEmpty => Bool.noConfusion isEmpty⟩

/-- Read as whether the two together hold one unit, the performing part lowers the first. -/
theorem performs_lower_first_with_one :
    Performs process holdsOne Prod.fst (fun c => c = true) lower :=
  ⟨⟨⟨(true, false), rfl⟩, fun _ held _ ⟨_, isFull, _⟩ => ⟨(true, false), held.symm, isFull.symm⟩⟩,
   fun s held ⟨_, isFull, _⟩ => match s, held, isFull with
     | (true, false), _, _ =>
       have moves : process.step (true, false) () (false, true) := .inr ⟨rfl, rfl⟩
       ⟨(false, true), Reach.of_step moves, rfl, rfl, rfl⟩
     | (true, true), held, _ => Bool.noConfusion held
     | (false, _), _, isFull => Bool.noConfusion isFull⟩

/-- Read as whether the two together hold one unit, the performing part raises the second. -/
theorem performs_raise_second_with_one :
    Performs process holdsOne Prod.snd (fun c => c = true) raise :=
  ⟨⟨⟨(true, false), rfl⟩, fun _ held _ ⟨_, isEmpty, _⟩ => ⟨(true, false), held.symm, isEmpty.symm⟩⟩,
   fun s held ⟨_, isEmpty, _⟩ => match s, held, isEmpty with
     | (true, false), _, _ =>
       have moves : process.step (true, false) () (false, true) := .inr ⟨rfl, rfl⟩
       ⟨(false, true), Reach.of_step moves, rfl, rfl, rfl⟩
     | (false, false), held, _ => Bool.noConfusion held
     | (_, true), _, isEmpty => Bool.noConfusion isEmpty⟩

/-- Read as whether the two together hold one unit, the performing part lowers the second. -/
theorem performs_lower_second_with_one :
    Performs process holdsOne Prod.snd (fun c => c = true) lower :=
  ⟨⟨⟨(false, true), rfl⟩, fun _ held _ ⟨_, isFull, _⟩ => ⟨(false, true), held.symm, isFull.symm⟩⟩,
   fun s held ⟨_, isFull, _⟩ => match s, held, isFull with
     | (false, true), _, _ =>
       have moves : process.step (false, true) () (true, false) := .inl ⟨rfl, rfl⟩
       ⟨(true, false), Reach.of_step moves, rfl, rfl, rfl⟩
     | (true, true), held, _ => Bool.noConfusion held
     | (_, false), _, isFull => Bool.noConfusion isFull⟩

end Conserved

/-! ### UE10's climbing process: invariable delivery without halting -/

namespace ClimbTask

/-- The climb's successor is fixed (`«定后»` on the steps of UE10's `Climb.process`). -/
theorem fixed : «定后» (Steps Climb.process) :=
  «定后之逐点».mpr fun _ _ _ ⟨_, first⟩ ⟨_, second⟩ => first.trans second.symm

/-- **Every task each of whose inputs has an output at or ahead of it is performed, with no
performing part**, by climbing to that output (`Climb.trace_units`). -/
theorem performs {T : Nat → Nat → Prop} (ahead : ∀ x, Input T x → ∃ d, T x (x + d)) :
    Performs Climb.process (fun _ => ()) id (fun _ => True) T :=
  ⟨⟨⟨0, trivial⟩, fun _ _ x _ => ⟨x, rfl, rfl⟩⟩,
   fun s _ input => match ahead s input with
     | ⟨d, out⟩ => ⟨s + d, ⟨_, Climb.trace_units d s⟩, trivial, out⟩⟩

/-- **And invariably, in `Delivers.invariably`'s sense** (`fixed`, `«定后则定后于»`): every course
from the input passes the output, though nothing marks that the delivery has ended. -/
theorem invariably {T : Nat → Nat → Prop} (ahead : ∀ x, Input T x → ∃ d, T x (x + d)) (x : Nat)
    (input : Input T x) :
    ∃ t, Reach Climb.process x t ∧ True ∧ T x t ∧
      ∀ r : Run Climb.process, r.state 0 = x → ∃ n, r.state n = t :=
  Delivers.invariably (performs ahead).2 («定后则定后于» fixed x) trivial input

/-- A task taking each count to itself plus an amount is performed. -/
theorem performs_function (g : Nat → Nat) :
    Performs Climb.process (fun _ => ()) id (fun _ => True) (fun x y => y = x + g x) :=
  performs fun x _ => ⟨g x, rfl⟩

/-- Every move changes the count. -/
theorem moves_change : ∀ s a t, Climb.process.step s a t → t ≠ s :=
  fun s _ _ step same => Nat.succ_ne_self s (step.symm.trans same)

/-- **The identity task is performed though every move changes the count** (`moves_change`):
delivery at zero moves. -/
theorem performs_identity :
    Performs Climb.process (fun _ => ()) id (fun _ => True) (fun x y => y = x) :=
  performs fun _ _ => ⟨0, rfl⟩

end ClimbTask

/-! ### An unmade performer: possible, not possible from what is there naturally -/

namespace Unmade

/-- A configuration is an enzyme, present (`true`) or absent (`false`), and a molecule, the
substrate (`false`) or the product (`true`): the present enzyme turns the substrate into the
product, and nothing makes an enzyme. -/
def process : Process (Bool × Bool) Unit := ⟨fun s _ t => s = (true, false) ∧ t = (true, true)⟩

/-- The substrate made the product. -/
def task (x y : Bool) : Prop := x = false ∧ y = true

/-- The present enzyme performs the task. -/
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

/-- **Possible, though not possible from configurations with no enzyme**: the present enzyme
performs the task, and no region performing it can be reached from a configuration with the enzyme
absent, from which nothing moves. -/
theorem possible_not_possibleFrom :
    Possible process Prod.fst Prod.snd task ∧
      ¬ PossibleFrom process Prod.fst Prod.snd (fun s => s.1 = false) task :=
  ⟨⟨_, performs⟩, fun ⟨K, ⟨_, delivers⟩, _, absent, _, reach, inK⟩ =>
    have inAbsent : K false := Eq.subst (motive := K) (absent_stays.reach reach absent) inK
    match delivers (false, false) inAbsent ⟨true, rfl, rfl⟩ with
    | ⟨_, ⟨_, .nil _⟩, _, _, isProduct⟩ => Bool.noConfusion isProduct
    | ⟨_, ⟨_, .cons step _⟩, _⟩ => Bool.noConfusion (congrArg Prod.fst step.1)⟩

end Unmade

/-! ### A tower changing every level at once: no delivery holds a level -/

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
every level. This is the delivery form of UE11's `Synchronous.tower_law_fails`, and it bears on the
regress within one delivery; making the performer (`PossibleFrom`, `tower_made_held`) is not
touched, since here the performer is there from the start. -/
theorem not_held (n : Nat) :
    ¬ Delivers (Reaching.heldMoves process (RuleTower.SameFrom n)) Prod.snd Prod.fst Alike task :=
  fun held => match held (false, fun _ => false) (fun _ => rfl) ⟨true, rfl, rfl⟩ with
  | ⟨_, ⟨_, .nil _⟩, _, _, atTrue⟩ => Bool.noConfusion atTrue
  | ⟨_, ⟨_, .cons ⟨⟨_, flipped⟩, same⟩ _⟩, _, _⟩ =>
    Bool.noConfusion ((same n (Nat.le_refl n)).symm.trans (flipped n))

end FlipTower

/-! ### A delivery widening what can be reached at the same offsets -/

namespace RiseTask

/-- The task: `false` to `true`. -/
def task (x y : Bool) : Prop := x = false ∧ y = true

/-- **A delivery can widen what can be reached at the same offsets**: on UE10's rising process,
where every step leads to `true`, the task is performed with the performing part trivial, and its
output widens its input at the same offsets (`Rise.rises`), while the input covers the output with
a lag (`Reaching.coversLater_of_trace`); so UE10's lagged order ranks the output above the input
(`Reaching.widensOrLater_iff_of_reach`). `FallTask.widens_back` has the reverse. -/
theorem widens :
    Performs Rise.process (fun _ => ()) id (fun _ => True) task ∧
      Reaching.Widens Rise.process Rise.adm true false ∧
      ∃ d, Reaching.CoversLater Rise.process Rise.adm d false true :=
  have moves : Rise.process.step false () true := rfl
  ⟨⟨⟨⟨false, trivial⟩, fun _ _ x _ => ⟨x, rfl, rfl⟩⟩,
    fun s _ ⟨_, atFalse, _⟩ =>
      have moves : Rise.process.step s () true := rfl
      ⟨true, Reach.of_step moves, trivial, atFalse, rfl⟩⟩,
   Rise.rises,
   match (Reach.of_step moves : Reach Rise.process false true) with
   | ⟨_, trace⟩ => ⟨_, Reaching.coversLater_of_trace trace⟩⟩

end RiseTask

/-! ### A delivery whose input widens its output at the same offsets -/

namespace FallTask

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

/-- **A delivered input can widen its output at the same offsets**: on the process where every step
leads to `false`, read with UE10's `Rise.adm`, the task is performed with the performing part
trivial, and its input widens its output at the same offsets, so UE10's lagged order ranks the
input above the output. -/
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

end FallTask

end Tasks

end Becoming
