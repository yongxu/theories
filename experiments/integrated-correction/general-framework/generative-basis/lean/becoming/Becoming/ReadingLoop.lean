import Becoming.Blanket
import Becoming.Keeping
import Becoming.Narrowing
import Becoming.ShownOrder

/-!
# The reading loop: sensing, predicting, choosing, acting and revising as one law

A formation that reads senses what goes on, predicts it, chooses through what it predicts, acts on
what goes on and revises its prediction by what comes back. This module states that loop as one
law, a case of the blanketed law of `Becoming.Blanket`, with no separate subject: what senses,
predicts and chooses is the internal part of one determined law, told apart by which part reads
which (board item RF, round 2: RF3, and RF-M's mechanism with its first cases).

* **Kept readings** (RF3). A region kept along every finite reach is a closed region (`«闭»`), and
  conversely (`kept_iff_closed`). On one carrier of world and state, a formation acting from its
  state (`joint`), with a supplied reading of the world kept by its update under every act
  (`KeptBy`), keeps a task at every configuration reached from a sound one, and goes on from every
  sound configuration, exactly where each state's act can be taken at every world its reading admits
  and leads only where the task holds (`keeps_continues_iff`; `Good` alone, successor safety, is met
  by an act no world can take). Given choice over the states, such a policy exists exactly where
  each state has one such act (`keeping_policy_iff`): for a supplied invariant reading, policy
  existence reduces to a common act for each reading. Acts good for every two worlds a reading
  admits need not be one act good for all (`PairwiseShared`), and being kept is not being informative:
  the reading of every world and the reading of none are kept by every update (`everything_kept`,
  `nothing_kept`, `nothing_sound`).
* **The reading a formation's own history carries.** With the state the history of acts and values
  sensed, the worlds possible after a history (`Possible`) are kept by recording (`possible_kept`)
  and are the least reading so kept that holds at the starts (`possible_least`). What a policy acting
  from its history reaches from a start is possible after a history it generates, and every such
  world is a start or reached (`possible_of_reached`, `reached_of_possible`). So the policy keeps a
  task at every configuration reached from a start exactly where, at every history it generates, its
  act leads only where the task holds from every world possible after it (`history_keeps_iff`), and
  goes on exactly where its act can be taken at each (`history_continues_iff`). `Possible` gives
  exactly the worlds compatible with the recorded history and the starts; the policy must be safe and
  enabled at each, and a coarser reading can suffice where its further worlds ask compatible acts.
  These laws verify a given policy; finding one is a choice of acts along the histories it
  generates.
* **Two worlds and one formation.** For every blanketed law, from one internal, sensory and active
  start, two worlds give the formation one sensed course through step `n` exactly as long as, at
  each step before `n`, they answer alike the act it takes at the value it senses
  (`sensed_alike_iff`). Where, at each step before `N`, an answer of the second world differing from
  the first's breaks a task `K` on the values sensed (equality of values decided), a formation keeping
  `K` through step `N` in the second world senses alike in both through `N` (`alike_within`; at every
  step, `alike_of_kept`), so its internal and active course is one
  (`Blanketed.agent_through_sensory`). Two formations whose configurations are related by a relation
  their steps keep, under which the values sensed and the acts are one, sense and act alike at every
  step (`observed_alike`).
* **A formation keeping candidate laws** (`Loop`, RF-M's mechanism). Each candidate predicts the
  value sensed next from the value sensed and the act; the formation drops the candidates the
  latest answer refutes and chooses its act from those kept (`Loop.law`, a blanketed law). At
  configuration `n + 1` the candidates kept are exactly those listed that fit the answers to the acts
  of steps before `n`; the answer sensed at `n + 1` is taken in at the next step (`Loop.kept_iff`). A
  listed candidate predicting as the world answers wherever the world is in a region the world's
  moves keep is never dropped from a start in that region (`Loop.faithful_kept`; on the grammar, the
  region where it is kept, agrees with the answer pending and the world is in that region is closed,
  `Loop.fitting_closed`); candidates of the same listing predicting alike on the steps before `n`
  are kept alike at `n + 1` (`Loop.kept_alike`); and where the world answers the act chosen with the
  value sensed and stays, and every candidate listed predicts that answer, the formation rests at
  once on a model its course never refutes (`Loop.rests_of_unrefuted`).
* **What a course chosen through its model does not test** (`Untested`). Two worlds answer a known
  act alike and an untried act apart, high in one and low in the other. A formation choosing by the
  worst case over the candidates it keeps (`Untested.byWorst`, with `Untested.worst` the least rank
  predicted, `Untested.worst_le`, `Untested.worst_attained`) keeps both candidates, takes the known
  act and senses the middle value at every step in either world (`Untested.rests`,
  `Untested.alike_in_both`), never sensing the high value the first world holds
  (`Untested.never_high`), while the true candidate is kept in each world (`Untested.true_kept`). A
  formation trying the untried act first separates the worlds and rests on the true candidate in
  each (`Untested.explorer_up`, `Untested.explorer_down`), sensing the low value at step one and at
  no other step in the second (`Untested.explorer_low_once`). Every formation on these worlds,
  whatever its internal part, update and choice of act, that never senses the low value in the second
  world senses alike in both and takes the known act at every step (`Untested.floor_forgoes`, a case
  of `alike_of_kept`), and from a start not sensing high never senses high in the first
  (`Untested.floor_never_high`).
* **An unresolved model and a reversed ranking act alike** (`Untested`). Two specified formations,
  one keeping both candidates with a ranking of high above the middle and one keeping the true
  candidate with a ranking of the middle above high, have the same acts and values sensed at every
  step in the first world (`Untested.model_or_order`, a case of `observed_alike`). Both rankings fit a
  training occasion choosing the middle over the low value while ranking high and the middle
  oppositely (`Untested.both_accord`, `Untested.apart_beyond`); in general, with no cycle shown, the
  positive comparisons every strict according order shares are exactly the shown relation's reach
  (`ChoiceOccasions.above_in_every_iff_reach`). Started with the true candidate alone, the first
  takes the untried act and senses high from step three on (`Untested.informed_turns`), and the second
  keeps the known act (`Untested.order_rests`).

**Standing.** Near-definitional or short compositions: `kept_iff_closed`, `closed_of_keptBy`,
`good_of_keeps`, `keeps_iff_good`, `keeps_continues_iff`, `keeping_policy_iff` (whose choice
argument is `GuardHorizon`'s), the readings of everything and of nothing, `possible_kept`,
`Loop.faithful_kept`, `Loop.kept_alike`. General laws: `keeps_of_good`, `possible_least`,
`history_keeps_iff`, `history_continues_iff`, `sensed_alike_iff`, `alike_within`, `observed_alike`,
`Loop.kept_iff`, `Loop.fitting_closed`, `Loop.rests_of_unrefuted`; none is claimed new as
mathematics. Witnesses: `PairwiseShared` and `Untested`, of which `floor_forgoes` quantifies over every
formation on its two worlds. Not proved here: a condition for a history policy to exist that ties
histories alike in what couples in to futures alike for the task, and the nonvacuity of the starts;
and `Loop.law` is not given as an instance of `joint`, the two carriers related in prose only. RF-M is
partial: assistance with a helper's acts inside the law, preference as state, an institution revising
its rule of reading and disclosure in two stages are later items.

**Readings** [AI reading]. The kept reading is related to possibilistic belief interpretations of
regulation (Virgo, Biehl, Baltieri and Capucci 2025), whose closure is under the policy chosen
(`keeps_of_good` takes that) where `KeptBy` asks it under every act; the good regulator of Conant
and Ashby (1970) concerns simplest optimal regulation, and no optimality or model necessity is proved
here. The `Untested` witness is a deterministic case of persistent agreement along the course a
formation's own choices take, with disagreement off it, related to self-confirming equilibrium
(Fudenberg and Levine 1993) and incomplete learning (Rothschild 1974); its choice is a specified
one-step worst-case criterion, the special case of maxmin over candidates (Gilboa and Schmeidler
1989); the equilibrium, experimentation and representation theorems are not reproduced. Where only
answers breaking a task tell worlds apart, no formation keeping the task learns which holds: a
deterministic two-run obstruction beside safe-exploration methods that guarantee exploration under
regularity and reachability assumptions (Sui, Gotovos, Burdick and Krause 2015; Turchetta,
Berkenkamp and Krause 2016). One observed course can leave an unresolved model and a reversed ranking
indistinguishable, an illustration of the ambiguity between beliefs and preferences in inferring
what a formation values from what it does (Armstrong and Mindermann 2018, for planner and reward;
Reddy, Dragan and Levine 2018, for beliefs about dynamics); starting the first with the true
candidate changes its course and leaves the second's, so whether informing helps depends on which
holds. No general assistance theorem is established. These are readings, not containments.

**Modelling choices.** Discrete synchronous steps, as in `Becoming.Blanket`; candidates predicting the
next value from the value sensed and the act; elimination, not weighting; the act chosen from the
candidates kept and the value sensed; the witness's world does not move, so its acts change only
what is sensed; informing is represented by its outcome, a start with the true candidate alone, not
by an act within the law. **What the model leaves out:** probabilities and continuation values; how
candidates are proposed; a formation's revising its own order. Every declaration has an empty axiom
report. No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

namespace ReadingLoop

open Blanket

universe u

/-! ## Kept readings (RF3) -/

section Kept

variable {X : Type u}

/-- **A region kept along every finite reach is a closed region, and conversely**: one step is a
reach (`«及».one`), and a closed region holds what is reached (`«闭之及»`). -/
theorem kept_iff_closed {R : «际» X} {P : X → Prop} :
    (∀ x y, P x → «及» R x y → P y) ↔ «闭» R P :=
  ⟨fun kept x y holds step => kept x y holds (.one step),
   fun closed _ _ holds reach => «闭之及» closed holds reach⟩

end Kept

section Joint

variable {W M A O : Type}

/-- **A formation acting from its state, on one carrier of world and state.** The world becomes what
`world` admits under the act the state gives; the state is updated from that act and what is sensed
of the world it becomes. -/
def joint (world : W → A → W → Prop) (sense : W → O) (update : M → A → O → M) (act : M → A) :
    «际» (W × M) :=
  fun x y => world x.1 (act x.2) y.1 ∧ y.2 = update x.2 (act x.2) (sense y.1)

/-- The configurations at which the state's reading holds of the world. -/
def Sound (B : M → W → Prop) (x : W × M) : Prop := B x.2 x.1

/-- **A reading kept by the update**: wherever the state reads the world and the world becomes `w'`
under any act, the updated state reads `w'`. -/
def KeptBy (world : W → A → W → Prop) (sense : W → O) (update : M → A → O → M)
    (B : M → W → Prop) : Prop :=
  ∀ m w a w', B m w → world w a w' → B (update m a (sense w')) w'

/-- **A reading kept by the update is a closed region of every policy's loop.** -/
theorem closed_of_keptBy {world : W → A → W → Prop} {sense : W → O} {update : M → A → O → M}
    {B : M → W → Prop} (kept : KeptBy world sense update B) (act : M → A) :
    «闭» (joint world sense update act) (Sound B) :=
  fun x y sound step =>
    Eq.mpr (congrArg (fun m => B m y.1) step.2) (kept x.2 x.1 (act x.2) y.1 sound step.1)

/-- Successor safety for a state's reading of a task `K`: every world the reading admits becomes,
under the act, only worlds where `K` holds. An act no world can take meets it. -/
def Good (world : W → A → W → Prop) (B : M → W → Prop) (K : W → Prop) (m : M) (a : A) : Prop :=
  ∀ w, B m w → ∀ w', world w a w' → K w'

/-- An act good and enabled for a state's reading: at every world the reading admits it can be
taken, and it leads only to worlds where `K` holds. -/
def GoodEnabled (world : W → A → W → Prop) (B : M → W → Prop) (K : W → Prop) (m : M) (a : A) :
    Prop :=
  ∀ w, B m w → (∃ w', world w a w') ∧ ∀ w', world w a w' → K w'

/-- A policy keeps a task along the loop: the task holds at every configuration reached, by one
step or more, from a sound one; the sound one itself is not asked to hold it. -/
def Keeps (world : W → A → W → Prop) (sense : W → O) (update : M → A → O → M) (B : M → W → Prop)
    (K : W → Prop) (act : M → A) : Prop :=
  ∀ x y, Sound B x → «及» (joint world sense update act) x y → K y.1

/-- A policy goes on from every sound configuration: each has a successor along the loop. -/
def Continues (world : W → A → W → Prop) (sense : W → O) (update : M → A → O → M)
    (B : M → W → Prop) (act : M → A) : Prop :=
  ∀ x, Sound B x → ∃ y, joint world sense update act x y

/-- **The safety composition along the loop.** Where the reading is a closed region of the policy's
loop and each state's act is good for its reading, the task holds at every configuration reached from
a sound one. -/
theorem keeps_of_good {world : W → A → W → Prop} {sense : W → O} {update : M → A → O → M}
    {B : M → W → Prop} {K : W → Prop} {act : M → A}
    (closed : «闭» (joint world sense update act) (Sound B))
    (good : ∀ m, Good world B K m (act m)) : Keeps world sense update B K act := by
  intro x y sound reach
  revert sound
  induction reach with
  | one step => exact fun sound => good _ _ sound _ step.1
  | more step _ ih => exact fun sound => ih (closed _ _ sound step)

/-- **A policy keeping the task is good for every state's reading.** No hypothesis: one step from a
sound configuration is a reach. -/
theorem good_of_keeps {world : W → A → W → Prop} {sense : W → O} {update : M → A → O → M}
    {B : M → W → Prop} {K : W → Prop} {act : M → A} (keeps : Keeps world sense update B K act) :
    ∀ m, Good world B K m (act m) :=
  fun m w holds w' moves =>
    keeps (w, m) (w', update m (act m) (sense w')) holds
      («及».one (R := joint world sense update act) (And.intro moves rfl))

/-- **With the reading kept by the update, a policy keeps the task exactly where it is good for every
state's reading.** -/
theorem keeps_iff_good {world : W → A → W → Prop} {sense : W → O} {update : M → A → O → M}
    {B : M → W → Prop} {K : W → Prop} (kept : KeptBy world sense update B) (act : M → A) :
    Keeps world sense update B K act ↔ ∀ m, Good world B K m (act m) :=
  ⟨good_of_keeps, keeps_of_good (closed_of_keptBy kept act)⟩

/-- **With the reading kept by the update, a policy keeps the task and goes on from every sound
configuration exactly where its act is good and enabled for every state's reading.** What is reached
from a sound configuration is sound, so the policy goes on from there too. -/
theorem keeps_continues_iff {world : W → A → W → Prop} {sense : W → O} {update : M → A → O → M}
    {B : M → W → Prop} {K : W → Prop} (kept : KeptBy world sense update B) (act : M → A) :
    (Keeps world sense update B K act ∧ Continues world sense update B act) ↔
      ∀ m, GoodEnabled world B K m (act m) :=
  ⟨fun ⟨keeps, goes⟩ m w holds =>
    ⟨match goes (w, m) holds with
      | ⟨y, step⟩ => ⟨y.1, step.1⟩,
     good_of_keeps keeps m w holds⟩,
   fun good =>
    ⟨keeps_of_good (closed_of_keptBy kept act) fun m w holds => (good m w holds).2,
     fun x sound => match (good x.2 x.1 sound).1 with
      | ⟨w', moves⟩ => ⟨(w', update x.2 (act x.2) (sense w')), And.intro moves rfl⟩⟩⟩

/-- **A policy keeping the task and going on exists exactly where each state has an act good and
enabled for its reading**, given choice over the states (as for states listed,
`Viability.choiceOver_fin`) and the reading kept by the update. -/
theorem keeping_policy_iff (choice : Viability.ChoiceOver M A) {world : W → A → W → Prop}
    {sense : W → O} {update : M → A → O → M} {B : M → W → Prop} {K : W → Prop}
    (kept : KeptBy world sense update B) :
    (∃ act : M → A, Keeps world sense update B K act ∧ Continues world sense update B act) ↔
      ∀ m, ∃ a, GoodEnabled world B K m a :=
  ⟨fun ⟨act, both⟩ m => ⟨act m, (keeps_continues_iff kept act).mp both m⟩,
   fun each => match choice _ each with
    | ⟨act, good⟩ => ⟨act, (keeps_continues_iff kept act).mpr good⟩⟩

/-- **The reading admitting every world is kept by every update**; an act is good for it only where
it is good at every world. -/
theorem everything_kept (world : W → A → W → Prop) (sense : W → O) (update : M → A → O → M) :
    KeptBy world sense update (fun (_ : M) (_ : W) => True) :=
  fun _ _ _ _ _ _ => trivial

theorem everything_good_iff {world : W → A → W → Prop} {K : W → Prop} {m : M} {a : A} :
    Good world (fun (_ : M) (_ : W) => True) K m a ↔ ∀ w w', world w a w' → K w' :=
  ⟨fun good w => good w trivial, fun good w _ => good w⟩

/-- **The reading admitting no world is kept by every update and every act is good for it**, and no
configuration is sound for it. -/
theorem nothing_kept (world : W → A → W → Prop) (sense : W → O) (update : M → A → O → M) :
    KeptBy world sense update (fun (_ : M) (_ : W) => False) :=
  fun _ _ _ _ holds _ => holds

theorem nothing_good {world : W → A → W → Prop} {K : W → Prop} {m : M} {a : A} :
    Good world (fun (_ : M) (_ : W) => False) K m a :=
  fun _ holds => holds.elim

theorem nothing_sound (x : W × M) : ¬ Sound (fun (_ : M) (_ : W) => False) x :=
  fun holds => holds

end Joint

/-! ### Acts good pairwise need not be one act good for all -/

namespace PairwiseShared

/-- Three worlds, and three acts, each named by a world. -/
inductive Point where
  | p
  | q
  | r

/-- An act is good at a world where it is not the act that world names. -/
abbrev good (w x : Point) : Prop := x ≠ w

/-- **Every two worlds share a good act.** -/
theorem two_share : ∀ w₁ w₂ : Point, ∃ x, good w₁ x ∧ good w₂ x
  | .p, .p => ⟨.q, And.intro (fun h => nomatch h) (fun h => nomatch h)⟩
  | .p, .q => ⟨.r, And.intro (fun h => nomatch h) (fun h => nomatch h)⟩
  | .p, .r => ⟨.q, And.intro (fun h => nomatch h) (fun h => nomatch h)⟩
  | .q, .p => ⟨.r, And.intro (fun h => nomatch h) (fun h => nomatch h)⟩
  | .q, .q => ⟨.p, And.intro (fun h => nomatch h) (fun h => nomatch h)⟩
  | .q, .r => ⟨.p, And.intro (fun h => nomatch h) (fun h => nomatch h)⟩
  | .r, .p => ⟨.q, And.intro (fun h => nomatch h) (fun h => nomatch h)⟩
  | .r, .q => ⟨.p, And.intro (fun h => nomatch h) (fun h => nomatch h)⟩
  | .r, .r => ⟨.p, And.intro (fun h => nomatch h) (fun h => nomatch h)⟩

/-- **No act is good at all three**: a reading admitting the three has no act good for it. -/
theorem none_for_all : ¬ ∃ x, ∀ w, good w x :=
  fun ⟨x, all⟩ => all x rfl

end PairwiseShared

/-! ### The reading a formation's own history carries -/

section History

variable {W A O : Type} (world : W → A → W → Prop) (sense : W → O) (start : W → Prop)

/-- A history, newest first, recorded by an act and the value sensed after it. -/
def record (h : List (A × O)) (a : A) (o : O) : List (A × O) := (a, o) :: h

/-- **The worlds possible after a history**: where a course from a start, taking the history's acts
and sensing its values, could be. -/
def Possible : List (A × O) → W → Prop
  | [] => start
  | (a, o) :: h => fun w' => ∃ w, Possible h w ∧ world w a w' ∧ sense w' = o

/-- **The worlds possible after a history are kept by recording.** -/
theorem possible_kept : KeptBy world sense record (Possible world sense start) :=
  fun _ w _ _ holds moves => ⟨w, holds, moves, rfl⟩

/-- **They are the least reading kept by recording that holds at the starts**: every reading of the
history kept by recording and holding at every start holds wherever a world is possible. -/
theorem possible_least {B : List (A × O) → W → Prop} (kept : KeptBy world sense record B)
    (starts : ∀ w, start w → B [] w) : ∀ h w, Possible world sense start h w → B h w
  | [], w, holds => starts w holds
  | (a, _) :: h, w', ⟨w, holds, moves, sensed⟩ =>
    Eq.mpr (congrArg (fun v => B ((a, v) :: h) w') sensed.symm)
      (kept h w a w' (possible_least kept starts h w holds) moves)

/-- The histories a policy acting from its history generates: each act the policy's at the history
before it. -/
def Generated (act : List (A × O) → A) : List (A × O) → Prop
  | [] => True
  | (a, _) :: h => Generated act h ∧ a = act h

/-- The configurations at a history the policy generates, the world possible after it, are a closed
region of the policy's loop. -/
theorem generated_closed (act : List (A × O) → A) :
    «闭» (joint world sense record act)
      (fun x => Generated act x.2 ∧ Possible world sense start x.2 x.1) :=
  fun x y within step =>
    Eq.mpr (congrArg (fun m => Generated act m ∧ Possible world sense start m y.1) step.2)
      ⟨⟨within.1, rfl⟩, ⟨x.1, within.2, step.1, rfl⟩⟩

/-- **What a policy acting from its history reaches from a start is possible after a history it
generates.** -/
theorem possible_of_reached (act : List (A × O) → A) {w₀ : W} (holds : start w₀)
    {y : W × List (A × O)} (reach : «及» (joint world sense record act) (w₀, []) y) :
    Generated act y.2 ∧ Possible world sense start y.2 y.1 :=
  «闭之及» (x := (w₀, ([] : List (A × O)))) (generated_closed world sense start act) ⟨trivial, holds⟩ reach

/-- **And every world possible after a history the policy generates is a start or reached from
one.** -/
theorem reached_of_possible (act : List (A × O) → A) :
    ∀ h w, Generated act h → Possible world sense start h w →
      (h = [] ∧ start w) ∨ ∃ w₀, start w₀ ∧ «及» (joint world sense record act) (w₀, []) (w, h)
  | [], w, _, holds => .inl ⟨rfl, holds⟩
  | (a, o) :: h, w', generated, possible => by
    cases generated with
    | intro generated chosen =>
      cases possible with
      | intro w rest =>
        cases rest with
        | intro possible rest =>
          cases rest with
          | intro moves sensed =>
            have step : joint world sense record act (w, h) (w', (a, o) :: h) :=
              And.intro (Eq.mp (congrArg (fun b => world w b w') chosen) moves)
                (congrArg (fun p => p :: h) (congr (congrArg Prod.mk chosen) sensed.symm))
            cases reached_of_possible act h w generated possible with
            | inl first =>
              cases first with
              | intro empty holds =>
                subst empty
                exact .inr ⟨w, holds, .one step⟩
            | inr later =>
              cases later with
              | intro w₀ rest => exact .inr ⟨w₀, rest.1, «及之传递» rest.2 (.one step)⟩

/-- **The adequacy a formation acting from its history needs.** A policy acting from its history
keeps a task at every configuration reached from a start exactly where, at every history it
generates, its act leads only where the task holds from every world possible after it. -/
theorem history_keeps_iff (act : List (A × O) → A) (K : W → Prop) :
    (∀ w₀ y, start w₀ → «及» (joint world sense record act) (w₀, []) y → K y.1) ↔
      ∀ h, Generated act h → Good world (Possible world sense start) K h (act h) :=
  ⟨fun keeps h generated w possible w' moves =>
    have step : joint world sense record act (w, h) (w', record h (act h) (sense w')) :=
      And.intro moves rfl
    match reached_of_possible world sense start act h w generated possible with
    | .inl ⟨empty, holds⟩ => by subst empty; exact keeps w _ holds (.one step)
    | .inr ⟨w₀, holds, reach⟩ => keeps w₀ _ holds («及之传递» reach (.one step)),
   fun good w₀ y holds reach =>
    keeps_of_good (B := fun h w => Generated act h ∧ Possible world sense start h w)
      (generated_closed world sense start act)
      (fun h w within => good h within.1 w within.2) (w₀, []) y ⟨trivial, holds⟩ reach⟩

/-- **A policy acting from its history goes on from every start and everything it reaches exactly
where, at every history it generates, its act can be taken at every world possible after it.** -/
theorem history_continues_iff (act : List (A × O) → A) :
    (∀ w₀ y, start w₀ → (y = (w₀, []) ∨ «及» (joint world sense record act) (w₀, []) y) →
        ∃ z, joint world sense record act y z) ↔
      ∀ h w, Generated act h → Possible world sense start h w → ∃ w', world w (act h) w' :=
  ⟨fun goes h w generated possible =>
    match reached_of_possible world sense start act h w generated possible with
    | .inl ⟨empty, holds⟩ => by
      subst empty
      exact match goes w (w, []) holds (.inl rfl) with
        | ⟨z, step⟩ => ⟨z.1, step.1⟩
    | .inr ⟨w₀, holds, reach⟩ => match goes w₀ (w, h) holds (.inr reach) with
      | ⟨z, step⟩ => ⟨z.1, step.1⟩,
   fun can w₀ y holds reached =>
    have within : Generated act y.2 ∧ Possible world sense start y.2 y.1 :=
      match reached with
      | .inl same => by subst same; exact ⟨trivial, holds⟩
      | .inr reach => possible_of_reached world sense start act holds reach
    match can y.2 y.1 within.1 within.2 with
    | ⟨w', moves⟩ => ⟨(w', record y.2 (act y.2) (sense w')), And.intro moves rfl⟩⟩

end History

/-! ## Two worlds and one formation -/

section Courses

variable {I S A E : Type}

/-- **Two worlds give one formation one sensed course exactly as long as they answer alike to what it
does.** From one internal, sensory and active start, the values sensed agree through step `n`
exactly where, at each step before `n`, the two worlds answer the act taken at the value sensed
alike. -/
theorem sensed_alike_iff (b : Blanketed I S A E) {x y : Parts I S A E}
    (internal : x.internal = y.internal) (sensory : x.sensory = y.sensory)
    (active : x.active = y.active) :
    ∀ n, (∀ k, k ≤ n → (b.course x k).sensory = (b.course y k).sensory) ↔
      ∀ k, k < n → b.nextSensory (b.course x k).sensory (b.course x k).active
          (b.course x k).external =
        b.nextSensory (b.course x k).sensory (b.course x k).active (b.course y k).external
  | 0 => ⟨fun _ _ lt => absurd lt (Nat.not_lt_zero _),
      fun _ k le => by cases Nat.eq_zero_of_le_zero le; exact sensory⟩
  | n + 1 =>
    have ih := sensed_alike_iff b internal sensory active n
    ⟨fun alike k lt =>
      match Nat.lt_or_eq_of_le (Nat.le_of_lt_succ lt) with
      | .inl before => ih.mp (fun j le => alike j (Nat.le_succ_of_le le)) k before
      | .inr same => by
        subst same
        have agent := b.agent_through_sensory internal active k
          fun j lt' => alike j (Nat.le_succ_of_le (Nat.le_of_lt lt'))
        exact (alike (k + 1) (Nat.le_refl _)).trans
          (congr3 b.nextSensory (alike k (Nat.le_succ k)).symm agent.2.symm rfl),
     fun answers k le =>
      have before := ih.mpr fun j lt' => answers j (Nat.lt_succ_of_lt lt')
      match Nat.lt_or_eq_of_le le with
      | .inl lt' => before k (Nat.le_of_lt_succ lt')
      | .inr same => by
        subst same
        have agent := b.agent_through_sensory internal active n
          fun j lt' => before j (Nat.le_of_lt lt')
        exact (answers n (Nat.lt_succ_self n)).trans
          (congr3 b.nextSensory (before n (Nat.le_refl n)) agent.2 rfl)⟩

/-- **Where every answer telling two worlds apart breaks a task in the second, keeping the task there
is not telling them apart, through any horizon.** From one internal, sensory and active start,
equality of the values sensed decided: where at each step before `N` an answer of the second world to
the act and value of the first course differing from the first's breaks `K`, and `K` holds at each
step from one through `N` in the second world, the values sensed agree at every step through `N`. -/
theorem alike_within [DecidableEq S] (b : Blanketed I S A E) {x y : Parts I S A E}
    (internal : x.internal = y.internal) (sensory : x.sensory = y.sensory)
    (active : x.active = y.active) {K : S → Prop} (N : Nat)
    (breaks : ∀ k, k < N →
      b.nextSensory (b.course x k).sensory (b.course x k).active (b.course x k).external ≠
        b.nextSensory (b.course x k).sensory (b.course x k).active (b.course y k).external →
      ¬ K (b.nextSensory (b.course x k).sensory (b.course x k).active (b.course y k).external))
    (kept : ∀ k, k < N → K (b.course y (k + 1)).sensory) :
    ∀ n, n ≤ N → ∀ k, k ≤ n → (b.course x k).sensory = (b.course y k).sensory
  | 0, _ => fun k le => by cases Nat.eq_zero_of_le_zero le; exact sensory
  | n + 1, bound => fun k le =>
    have lt : n < N := Nat.lt_of_lt_of_le (Nat.lt_succ_self n) bound
    have before := alike_within b internal sensory active N breaks kept n (Nat.le_of_lt lt)
    match Nat.lt_or_eq_of_le le with
    | .inl lt' => before k (Nat.le_of_lt_succ lt')
    | .inr same => by
      subst same
      have agent := b.agent_through_sensory internal active n
        fun j lt' => before j (Nat.le_of_lt lt')
      have toY : b.nextSensory (b.course x n).sensory (b.course x n).active (b.course y n).external =
          (b.course y (n + 1)).sensory :=
        congr3 b.nextSensory (before n (Nat.le_refl n)) agent.2 rfl
      exact match decEq (b.nextSensory (b.course x n).sensory (b.course x n).active
          (b.course x n).external)
          (b.nextSensory (b.course x n).sensory (b.course x n).active (b.course y n).external) with
        | isTrue answered => answered.trans toY
        | isFalse apart => ((breaks n lt apart) (Eq.mpr (congrArg K toY) (kept n lt))).elim

/-- **At every step**: where the hypotheses of `alike_within` hold at every step, the values sensed
agree at every step. -/
theorem alike_of_kept [DecidableEq S] (b : Blanketed I S A E) {x y : Parts I S A E}
    (internal : x.internal = y.internal) (sensory : x.sensory = y.sensory)
    (active : x.active = y.active) {K : S → Prop}
    (breaks : ∀ k,
      b.nextSensory (b.course x k).sensory (b.course x k).active (b.course x k).external ≠
        b.nextSensory (b.course x k).sensory (b.course x k).active (b.course y k).external →
      ¬ K (b.nextSensory (b.course x k).sensory (b.course x k).active (b.course y k).external))
    (kept : ∀ n, K (b.course y (n + 1)).sensory) :
    ∀ n, (b.course x n).sensory = (b.course y n).sensory :=
  fun n => alike_within b internal sensory active n (fun k _ => breaks k) (fun k _ => kept k) n
    (Nat.le_refl n) n (Nat.le_refl n)

/-- **Formations related by a relation their steps keep sense and act alike.** For two blanketed laws
reading one kind of value and act, a relation between their configurations that their steps keep,
under which the values sensed and the acts are one, gives from related starts the same values sensed
and acts at every step: no selection through those tells the two apart. -/
theorem observed_alike {I₁ I₂ : Type} (b₁ : Blanketed I₁ S A E) (b₂ : Blanketed I₂ S A E)
    (R : Parts I₁ S A E → Parts I₂ S A E → Prop)
    (steps : ∀ x₁ x₂, R x₁ x₂ → R (b₁.step x₁) (b₂.step x₂))
    (observed : ∀ x₁ x₂, R x₁ x₂ → x₁.sensory = x₂.sensory ∧ x₁.active = x₂.active)
    {x₁ : Parts I₁ S A E} {x₂ : Parts I₂ S A E} (related : R x₁ x₂) :
    ∀ n, (b₁.course x₁ n).sensory = (b₂.course x₂ n).sensory ∧
      (b₁.course x₁ n).active = (b₂.course x₂ n).active := by
  have along : ∀ n, R (b₁.course x₁ n) (b₂.course x₂ n) := fun n => by
    induction n with
    | zero => exact related
    | succ n ih => exact steps _ _ ih
  exact fun n => observed _ _ (along n)

end Courses

/-! ## A formation keeping candidate laws (RF-M) -/

/-- **A formation keeping candidate laws, in a world.** Each candidate predicts the value sensed next
from the value sensed and the act; the formation chooses its act from the candidates it keeps and the
value sensed. The world answers and moves by its own law. -/
structure Loop (H S A E : Type) where
  /-- A candidate's prediction of the value sensed next. -/
  predict : H → S → A → S
  /-- The act chosen from the candidates kept and the value sensed. -/
  choose : List H → S → A
  /-- The world's answer: the value sensed next. -/
  answer : S → A → E → S
  /-- The world's next state. -/
  move : S → A → E → E

/-- Filtering by a test every member passes keeps the list. -/
theorem filter_all {α : Type} (p : α → Bool) :
    ∀ l : List α, (∀ x, x ∈ l → p x = true) → l.filter p = l
  | [], _ => rfl
  | a :: l, all => (Narrowing.filter_cons_true l (all a (.head _))).trans
      (congrArg (a :: ·) (filter_all p l fun x mem => all x (.tail _ mem)))

namespace Loop

variable {H S A E : Type} [DecidableEq S] (L : Loop H S A E)

/-- The candidates kept once the answer to the last act is sensed: those predicting otherwise are
dropped. -/
def keep (hs : List H) (last : Option (S × A)) (sensed : S) : List H :=
  match last with
  | none => hs
  | some (s, a) => hs.filter fun h => decide (L.predict h s a = sensed)

/-- **The loop as a blanketed law.** Its internal part holds the candidates kept and the last value
sensed with the act taken at it; its act is chosen from the candidates kept once the latest answer is
sensed. -/
def law : Blanketed (List H × Option (S × A)) S A E where
  nextInternal i s a := (L.keep i.1 i.2 s, some (s, a))
  nextSensory := L.answer
  nextActive i s _ := L.choose (L.keep i.1 i.2 s) s
  nextExternal := L.move

/-- A start: candidates listed, nothing yet answered. -/
def start (hs : List H) (s : S) (a : A) (e : E) : Parts (List H × Option (S × A)) S A E :=
  ⟨(hs, none), s, a, e⟩

/-- **The candidates kept are those fitting every answer taken in** (`Narrowing`'s revision, on the
formation's own course): at configuration `n + 1` from a start, a candidate is kept exactly where it
was listed and predicts, at each step before `n`, the value sensed after it; the answer sensed at
`n + 1` is taken in at the next step. -/
theorem kept_iff (hs : List H) (s : S) (a : A) (e : E) (h : H) :
    ∀ n, h ∈ (L.law.course (start hs s a e) (n + 1)).internal.1 ↔
      h ∈ hs ∧ ∀ k, k < n → L.predict h (L.law.course (start hs s a e) k).sensory
        (L.law.course (start hs s a e) k).active = (L.law.course (start hs s a e) (k + 1)).sensory
  | 0 => ⟨fun listed => ⟨listed, fun _ lt => absurd lt (Nat.not_lt_zero _)⟩,
      fun ⟨listed, _⟩ => listed⟩
  | n + 1 => by
    have ih := kept_iff hs s a e h n
    show h ∈ (L.law.course (start hs s a e) (n + 1)).internal.1.filter
        (fun g => decide (L.predict g (L.law.course (start hs s a e) n).sensory
          (L.law.course (start hs s a e) n).active =
            (L.law.course (start hs s a e) (n + 1)).sensory)) ↔ _
    exact (Narrowing.mem_filter _ h _).trans
      ⟨fun ⟨kept, fits⟩ => match ih.mp kept with
        | ⟨listed, before⟩ => ⟨listed, fun k lt =>
          match Nat.lt_or_eq_of_le (Nat.le_of_lt_succ lt) with
          | .inl lt' => before k lt'
          | .inr same => by subst same; exact of_decide_eq_true fits⟩,
       fun ⟨listed, all⟩ => ⟨ih.mpr ⟨listed, fun k lt => all k (Nat.lt_succ_of_lt lt)⟩,
         decide_eq_true (all n (Nat.lt_succ_self n))⟩⟩

/-- **A candidate predicting as the world answers in a region its moves keep is never dropped**:
listed, from a start in the region, it is kept at every step. -/
theorem faithful_kept {h : H} {Q : E → Prop} (stays : ∀ s a e, Q e → Q (L.move s a e))
    (faithful : ∀ s a e, Q e → L.answer s a e = L.predict h s a) {hs : List H} (listed : h ∈ hs)
    (s : S) (a : A) {e : E} (holds : Q e) (n : Nat) :
    h ∈ (L.law.course (start hs s a e) (n + 1)).internal.1 := by
  have within : ∀ k, Q (L.law.course (start hs s a e) k).external := fun k => by
    induction k with
    | zero => exact holds
    | succ k ih => exact stays _ _ _ ih
  exact (L.kept_iff hs s a e h n).mpr ⟨listed, fun k _ => (faithful _ _ _ (within k)).symm⟩

/-- **Candidates of the same listing predicting alike along the course are kept alike**: the
formation's model lumps the candidates its own course does not tell apart. -/
theorem kept_alike {hs : List H} {s : S} {a : A} {e : E} {h₁ h₂ : H} (n : Nat)
    (listed : h₁ ∈ hs ↔ h₂ ∈ hs)
    (alike : ∀ k, k < n → L.predict h₁ (L.law.course (start hs s a e) k).sensory
        (L.law.course (start hs s a e) k).active =
      L.predict h₂ (L.law.course (start hs s a e) k).sensory
        (L.law.course (start hs s a e) k).active) :
    h₁ ∈ (L.law.course (start hs s a e) (n + 1)).internal.1 ↔
      h₂ ∈ (L.law.course (start hs s a e) (n + 1)).internal.1 :=
  (L.kept_iff hs s a e h₁ n).trans (Iff.trans
    ⟨fun ⟨m, fits⟩ => ⟨listed.mp m, fun k lt => (alike k lt).symm.trans (fits k lt)⟩,
     fun ⟨m, fits⟩ => ⟨listed.mpr m, fun k lt => (alike k lt).trans (fits k lt)⟩⟩
    (L.kept_iff hs s a e h₂ n).symm)

/-- The configurations at which `h` is kept and agrees with the answer pending. -/
def Fitting (h : H) (x : Parts (List H × Option (S × A)) S A E) : Prop :=
  h ∈ x.internal.1 ∧ ∀ p : S × A, x.internal.2 = some p → L.predict h p.1 p.2 = x.sensory

/-- **The region where `h` is kept, agrees with the answer pending and the world is in a region its
moves keep is closed**, where `h` predicts as the world answers in that region (RF3's kept reading, on
the loop). -/
theorem fitting_closed {h : H} {Q : E → Prop} (stays : ∀ s a e, Q e → Q (L.move s a e))
    (faithful : ∀ s a e, Q e → L.answer s a e = L.predict h s a) :
    «闭» (fun x y => L.law.step x = y) (fun x => L.Fitting h x ∧ Q x.external) := by
  intro x y within stepped
  subst stepped
  cases x with
  | mk i s a e =>
    cases i with
    | mk hs last =>
      cases last with
      | none =>
        exact And.intro
          (And.intro within.1.1 fun p same => by cases same; exact (faithful s a e within.2).symm)
          (stays s a e within.2)
      | some p =>
        cases p with
        | mk s₀ a₀ =>
          exact And.intro
            (And.intro
              ((Narrowing.mem_filter (fun g => decide (L.predict g s₀ a₀ = s)) h hs).mpr
                ⟨within.1.1, decide_eq_true (within.1.2 (s₀, a₀) rfl)⟩)
              fun p same => by cases same; exact (faithful s a e within.2).symm)
            (stays s a e within.2)

/-- **A model its course never refutes rests.** Where the world answers the act chosen with the value
sensed and stays, the formation chooses that act from the candidates listed, and every candidate
listed predicts that answer, the formation rests at once: the same candidates, the same act and the
same value at every step. -/
theorem rests_of_unrefuted {hs : List H} {s : S} {a : A} {e : E} (answered : L.answer s a e = s)
    (stays : L.move s a e = e) (chosen : L.choose hs s = a)
    (unrefuted : ∀ h, h ∈ hs → L.predict h s a = s) :
    ∀ n, L.law.course (start hs s a e) (n + 1) = ⟨(hs, some (s, a)), s, a, e⟩ := by
  have all : L.keep hs (some (s, a)) s = hs :=
    filter_all _ hs fun h mem => decide_eq_true (unrefuted h mem)
  have first : L.law.step (start hs s a e) = ⟨(hs, some (s, a)), s, a, e⟩ := by
    show (⟨(hs, some (s, a)), L.answer s a e, L.choose hs s, L.move s a e⟩ :
      Parts (List H × Option (S × A)) S A E) = _
    rw [answered, chosen, stays]
  have again : L.law.step ⟨(hs, some (s, a)), s, a, e⟩ = ⟨(hs, some (s, a)), s, a, e⟩ := by
    show (⟨(L.keep hs (some (s, a)) s, some (s, a)), L.answer s a e,
      L.choose (L.keep hs (some (s, a)) s) s, L.move s a e⟩ :
        Parts (List H × Option (S × A)) S A E) = _
    rw [all, answered, chosen, stays]
  intro n
  induction n with
  | zero => exact first
  | succ n ih => exact (congrArg L.law.step ih).trans again

end Loop

/-! ## A witness: what a course chosen through its model does not test -/

namespace Untested

/-- Three values sensed. -/
inductive Value where
  | low
  | mid
  | high

instance : DecidableEq Value
  | .low, .low => isTrue rfl
  | .mid, .mid => isTrue rfl
  | .high, .high => isTrue rfl
  | .low, .mid => isFalse fun same => nomatch same
  | .low, .high => isFalse fun same => nomatch same
  | .mid, .low => isFalse fun same => nomatch same
  | .mid, .high => isFalse fun same => nomatch same
  | .high, .low => isFalse fun same => nomatch same
  | .high, .mid => isFalse fun same => nomatch same

/-- Two acts: one known, one untried. -/
inductive Act where
  | known
  | untried

/-- Two worlds, alike on the known act: in `up` the untried act answers high, in `down` low. -/
inductive World where
  | up
  | down

/-- The world's answer: the known act answers the middle value in both worlds. -/
def reply (_ : Value) (a : Act) (w : World) : Value :=
  match a with
  | .known => .mid
  | .untried => match w with
    | .up => .high
    | .down => .low

/-- A ranking of values: high above the middle above low. -/
def rank : Value → Nat
  | .low => 0
  | .mid => 1
  | .high => 2

/-- The lower of two numbers. -/
def lower (x y : Nat) : Nat := if x ≤ y then x else y

theorem lower_le_left (x y : Nat) : lower x y ≤ x :=
  match Nat.decLe x y with
  | isTrue le => Nat.le_of_eq (if_pos le)
  | isFalse above =>
    Nat.le_trans (Nat.le_of_eq (if_neg above)) (Nat.le_of_lt (Nat.gt_of_not_le above))

theorem lower_le_right (x y : Nat) : lower x y ≤ y :=
  match Nat.decLe x y with
  | isTrue le => Nat.le_trans (Nat.le_of_eq (if_pos le)) le
  | isFalse above => Nat.le_of_eq (if_neg above)

theorem lower_cases (x y : Nat) : lower x y = x ∨ lower x y = y :=
  match Nat.decLe x y with
  | isTrue le => .inl (if_pos le)
  | isFalse above => .inr (if_neg above)

/-- The worst rank the candidates kept predict for an act: the least over them; with none kept,
nothing, so both acts rank alike and the known act is taken. -/
def worst (r : Value → Nat) (a : Act) : List World → Nat
  | [] => 0
  | [w] => r (reply .mid a w)
  | w :: v :: ws => lower (r (reply .mid a w)) (worst r a (v :: ws))

/-- **The worst rank is at or below each candidate's.** -/
theorem worst_le (r : Value → Nat) (a : Act) :
    ∀ (ws : List World) (w : World), w ∈ ws → worst r a ws ≤ r (reply .mid a w)
  | [] => fun _ mem => nomatch mem
  | _ :: rest => match rest with
    | [] => fun _ mem => match mem with
      | .head _ => Nat.le_refl _
      | .tail _ inner => nomatch inner
    | v :: ws => fun _ mem => match mem with
      | .head _ => lower_le_left _ _
      | .tail _ inner => Nat.le_trans (lower_le_right _ _) (worst_le r a (v :: ws) _ inner)

/-- **And it is some candidate's**, where any is kept. -/
theorem worst_attained (r : Value → Nat) (a : Act) :
    ∀ (w : World) (ws : List World), ∃ v, v ∈ w :: ws ∧ worst r a (w :: ws) = r (reply .mid a v)
  | w, [] => ⟨w, .head _, rfl⟩
  | w, v :: ws =>
    match lower_cases (r (reply .mid a w)) (worst r a (v :: ws)) with
    | .inl left => ⟨w, .head _, left⟩
    | .inr right => match worst_attained r a v ws with
      | ⟨u, mem, at_u⟩ => ⟨u, .tail _ mem, right.trans at_u⟩

/-- **Choosing by the worst case** over the candidates kept (maxmin): the untried act where its worst
predicted value ranks strictly above the known act's, else the known act. -/
def byWorst (r : Value → Nat) (ws : List World) (_ : Value) : Act :=
  if worst r .known ws < worst r .untried ws then .untried else .known

/-- **The untried act is chosen exactly where its worst rank is strictly above the known act's.** -/
theorem byWorst_iff (r : Value → Nat) (ws : List World) (s : Value) :
    byWorst r ws s = .untried ↔ worst r .known ws < worst r .untried ws :=
  match Nat.decLt (worst r .known ws) (worst r .untried ws) with
  | isTrue lt => ⟨fun _ => lt, fun _ => if_pos lt⟩
  | isFalse not_lt =>
    ⟨fun same => (nomatch (if_neg not_lt).symm.trans same), fun lt => absurd lt not_lt⟩

/-- The loop: the candidates are the worlds, each predicting as that world answers; the world
stays. -/
def loop (r : Value → Nat) : Loop World Value Act World where
  predict w s a := reply s a w
  choose := byWorst r
  answer := reply
  move _ _ w := w

/-- Where the formation keeping both candidates rests: both kept, the known act, the middle value. -/
def rest (w : World) : Parts (List World × Option (Value × Act)) Value Act World :=
  ⟨([.up, .down], some (.mid, .known)), .mid, .known, w⟩

/-- **A model its course never refutes.** Keeping both candidates and choosing by the worst case,
from the middle value after the known act, the formation rests at once, in either world
(`Loop.rests_of_unrefuted`). -/
theorem rests (w : World) :
    ∀ n, (loop rank).law.course (Loop.start [.up, .down] .mid .known w) (n + 1) = rest w :=
  (loop rank).rests_of_unrefuted rfl rfl rfl fun _ _ => rfl

/-- **The true candidate is kept** in its own world, from every listing holding it. -/
theorem true_kept (r : Value → Nat) {ws : List World} {w : World} (listed : w ∈ ws) (s : Value)
    (a : Act) (n : Nat) :
    w ∈ ((loop r).law.course (Loop.start ws s a w) (n + 1)).internal.1 :=
  (loop r).faithful_kept (Q := fun e => e = w) (fun _ _ _ same => same)
    (fun _ _ _ same => by subst same; rfl) listed s a rfl n

/-- **The course is one in both worlds**: the formation keeps the same candidates, senses the same
values and takes the same acts in `up` and in `down`. -/
theorem alike_in_both :
    ∀ n, ((loop rank).law.course (Loop.start [.up, .down] .mid .known .up) n).internal =
        ((loop rank).law.course (Loop.start [.up, .down] .mid .known .down) n).internal ∧
      ((loop rank).law.course (Loop.start [.up, .down] .mid .known .up) n).sensory =
        ((loop rank).law.course (Loop.start [.up, .down] .mid .known .down) n).sensory ∧
      ((loop rank).law.course (Loop.start [.up, .down] .mid .known .up) n).active =
        ((loop rank).law.course (Loop.start [.up, .down] .mid .known .down) n).active
  | 0 => ⟨rfl, rfl, rfl⟩
  | n + 1 =>
    ⟨(congrArg Parts.internal (rests .up n)).trans (congrArg Parts.internal (rests .down n)).symm,
     (congrArg Parts.sensory (rests .up n)).trans (congrArg Parts.sensory (rests .down n)).symm,
     (congrArg Parts.active (rests .up n)).trans (congrArg Parts.active (rests .down n)).symm⟩

/-- **It never senses the high value the world `up` holds.** -/
theorem never_high :
    ∀ n, ((loop rank).law.course (Loop.start [.up, .down] .mid .known .up) n).sensory ≠ .high
  | 0 => fun same => nomatch same
  | n + 1 => fun same => nomatch (congrArg Parts.sensory (rests .up n)).symm.trans same

/-- Where a formation trying the untried act first rests in world `up`: the true candidate alone, the
untried act, the high value. -/
def upRest : Parts (List World × Option (Value × Act)) Value Act World :=
  ⟨([.up], some (.high, .untried)), .high, .untried, .up⟩

/-- Where it rests in world `down`: the true candidate alone, the known act, the middle value. -/
def downRest : Parts (List World × Option (Value × Act)) Value Act World :=
  ⟨([.down], some (.mid, .known)), .mid, .known, .down⟩

/-- **Trying first separates the worlds.** Starting with the untried act, in world `up` the formation
rests from step four on with the true candidate alone, taking the untried act and sensing high. -/
theorem explorer_up :
    ∀ n, (loop rank).law.course (Loop.start [.up, .down] .mid .untried .up) (n + 4) = upRest
  | 0 => rfl
  | n + 1 => (congrArg (loop rank).law.step (explorer_up n)).trans rfl

/-- In world `down` it rests from step three on with the true candidate alone, taking the known
act. -/
theorem explorer_down :
    ∀ n, (loop rank).law.course (Loop.start [.up, .down] .mid .untried .down) (n + 3) =
      downRest
  | 0 => rfl
  | n + 1 => (congrArg (loop rank).law.step (explorer_down n)).trans rfl

/-- **Trying costs the floor once** in world `down`: the value sensed is low at step one and at no
other step. -/
theorem explorer_low_once :
    ∀ n, ((loop rank).law.course (Loop.start [.up, .down] .mid .untried .down) n).sensory = .low ↔
      n = 1
  | 0 => ⟨fun same => (nomatch same), fun same => absurd same Nat.zero_ne_one⟩
  | k + 1 => match k with
    | 0 => ⟨fun _ => rfl, fun _ => rfl⟩
    | j + 1 => match j with
      | 0 => ⟨fun same => (nomatch same),
          fun same => Nat.noConfusion (congrArg Nat.pred same)⟩
      | n + 1 => ⟨fun same => (nomatch (congrArg Parts.sensory (explorer_down n)).symm.trans same),
          fun same => Nat.noConfusion (congrArg Nat.pred same)⟩

/-- **Keeping the floor forgoes what only the untried act shows.** For every blanketed law sensing and
moving as here, whatever its internal part, update and choice of act: from one start in both worlds,
where the value sensed in world `down` is never low, the formation senses alike in both worlds and
takes the known act at every step in `down`. -/
theorem floor_forgoes {I : Type} (b : Blanketed I Value Act World)
    (sensed : ∀ s a w, b.nextSensory s a w = reply s a w) (stays : ∀ s a w, b.nextExternal s a w = w)
    (i : I) (s : Value) (a : Act) (floor : ∀ n, (b.course ⟨i, s, a, .down⟩ n).sensory ≠ .low) :
    ∀ n, (b.course ⟨i, s, a, .up⟩ n).sensory = (b.course ⟨i, s, a, .down⟩ n).sensory ∧
      (b.course ⟨i, s, a, .down⟩ n).active = .known := by
  have external : ∀ (w : World) n, (b.course ⟨i, s, a, w⟩ n).external = w := fun w n => by
    induction n with
    | zero => rfl
    | succ n ih => exact (stays _ _ _).trans ih
  have known : ∀ n, (b.course ⟨i, s, a, .down⟩ n).active = .known := fun n =>
    match hact : (b.course ⟨i, s, a, .down⟩ n).active with
    | .known => rfl
    | .untried => absurd
        ((((sensed _ _ _).trans (congrArg (fun act => reply (b.course ⟨i, s, a, .down⟩ n).sensory act
          (b.course ⟨i, s, a, .down⟩ n).external) hact)).trans
          (congrArg (reply (b.course ⟨i, s, a, .down⟩ n).sensory .untried) (external .down n))).trans
          rfl)
        (floor (n + 1))
  have alike := alike_of_kept b (x := ⟨i, s, a, .up⟩) (y := ⟨i, s, a, .down⟩) rfl rfl rfl
    (K := fun v => v ≠ .low)
    (fun k apart => by
      rw [sensed, sensed, external .up k, external .down k] at apart
      rw [sensed, external .down k]
      cases hact : (b.course ⟨i, s, a, .up⟩ k).active with
      | known => rw [hact] at apart; exact (apart rfl).elim
      | untried => exact fun ne => ne rfl)
    (fun n => floor (n + 1))
  exact fun n => ⟨alike n, known n⟩

/-- **And so it never senses high in world `up`**, from a start not sensing high. -/
theorem floor_never_high {I : Type} (b : Blanketed I Value Act World)
    (sensed : ∀ s a w, b.nextSensory s a w = reply s a w) (stays : ∀ s a w, b.nextExternal s a w = w)
    (i : I) (s : Value) (a : Act) (start : s ≠ .high)
    (floor : ∀ n, (b.course ⟨i, s, a, .down⟩ n).sensory ≠ .low) :
    ∀ n, (b.course ⟨i, s, a, .up⟩ n).sensory ≠ .high
  | 0 => start
  | n + 1 => fun same =>
    have middle : (b.course ⟨i, s, a, .up⟩ (n + 1)).sensory = .mid :=
      (floor_forgoes b sensed stays i s a floor (n + 1)).1.trans
        (((sensed _ _ _).trans (congrArg (fun act => reply (b.course ⟨i, s, a, .down⟩ n).sensory act
          (b.course ⟨i, s, a, .down⟩ n).external) (floor_forgoes b sensed stays i s a floor n).2)).trans
          rfl)
    nomatch middle.symm.trans same

/-! ### An unresolved model and a reversed ranking act alike -/

/-- A second ranking of values: the middle above high above low. -/
def rank' : Value → Nat
  | .low => 0
  | .high => 1
  | .mid => 2

/-- The training occasion: the middle and the low value open, the middle chosen. -/
def training : ChoiceOccasions Value Unit where
  menu := fun _ v => v = .mid ∨ v = .low
  pick := fun _ => .mid

/-- An order read from ranks: `x` above `y` where `y` ranks below `x`. -/
def above (r : Value → Nat) : «际» Value := fun x y => r y < r x

/-- **Both rankings accord with the training occasion.** -/
theorem both_accord : training.Accords (above rank) ∧ training.Accords (above rank') :=
  ⟨fun _ y opened other => match opened with
    | .inl is_mid => absurd is_mid other
    | .inr is_low => by subst is_low; exact (by decide : 0 < 1),
   fun _ y opened other => match opened with
    | .inl is_mid => absurd is_mid other
    | .inr is_low => by subst is_low; exact (by decide : 0 < 2)⟩

/-- **They rank high and the middle oppositely**, a comparison the occasion does not show. -/
theorem apart_beyond : above rank .high .mid ∧ above rank' .mid .high :=
  ⟨(by decide : 1 < 2), (by decide : 1 < 2)⟩

/-- Where the formation keeping the true candidate with the second ranking rests. -/
def orderRest : Parts (List World × Option (Value × Act)) Value Act World :=
  ⟨([.up], some (.mid, .known)), .mid, .known, .up⟩

/-- **Keeping the true candidate, the second ranking rests on the known act.** -/
theorem order_rests :
    ∀ n, (loop rank').law.course (Loop.start [.up] .mid .known .up) (n + 1) = orderRest :=
  (loop rank').rests_of_unrefuted rfl rfl rfl fun _ _ => rfl

/-- **An unresolved model and a reversed ranking act alike.** In world `up`, the formation keeping both
candidates with the first ranking and the one keeping the true candidate with the second take the same
act and sense the same value at every step (`observed_alike`). -/
theorem model_or_order :
    ∀ n, ((loop rank).law.course (Loop.start [.up, .down] .mid .known .up) n).sensory =
        ((loop rank').law.course (Loop.start [.up] .mid .known .up) n).sensory ∧
      ((loop rank).law.course (Loop.start [.up, .down] .mid .known .up) n).active =
        ((loop rank').law.course (Loop.start [.up] .mid .known .up) n).active :=
  observed_alike (loop rank).law (loop rank').law
    (fun x₁ x₂ => (x₁ = Loop.start [.up, .down] .mid .known .up ∧
        x₂ = Loop.start [.up] .mid .known .up) ∨ (x₁ = rest .up ∧ x₂ = orderRest))
    (fun x₁ x₂ related => match related with
      | .inl ⟨first, second⟩ => .inr ⟨by subst first; rfl, by subst second; rfl⟩
      | .inr ⟨first, second⟩ => .inr ⟨by subst first; rfl, by subst second; rfl⟩)
    (fun x₁ x₂ related => match related with
      | .inl ⟨first, second⟩ => by subst first; subst second; exact ⟨rfl, rfl⟩
      | .inr ⟨first, second⟩ => by subst first; subst second; exact ⟨rfl, rfl⟩)
    (.inl ⟨rfl, rfl⟩)

/-- **Started with the true candidate alone, the first ranking turns**: from step three on the
formation takes the untried act and senses high. -/
theorem informed_turns :
    ∀ n, (loop rank).law.course (Loop.start [.up] .mid .known .up) (n + 3) = upRest
  | 0 => rfl
  | n + 1 => (congrArg (loop rank).law.step (informed_turns n)).trans rfl

end Untested

end ReadingLoop

end Becoming
