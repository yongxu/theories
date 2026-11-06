import Becoming.Blanket
import Becoming.Histories
import Becoming.IdentificationRuns

/-!
# A formation's couplings as its blanket, and when a blanket constrains

AI-written, 1 November 2026 (board item UE27), revised after an independent review of the Lean;
extended the same day by board item UE28 with a formation's level as the internal part.
`Blanket` states the principle's Markov blanket as a coupling structure, a determined law on four
parts, and joins it to the World at one witness (`ThresholdDrain.blanket_iff_through`). Its header
leaves out which blanket a thing has, and its record leaves open a World formation in general as
the agent of a blanketed law. This module states both in the pure core. Every law in it is
near-definitional; what is new is the classification of when a blanket's existence constrains,
to which a formation's level along one run adds a World case.

* **A formation's couplings as its blanket, by construction.** For any web, any formation `g` whose
  couplings `obs` give the values of what couples into it (`Web.ValuesThrough`), any model `update`
  fed by those values, any policy and any environment `env`, which may read the formation's act, the
  coupling law (`couplingLaw`) is blanketed, its sensory part's next state the value of what couples
  into `g` at the step. Its sensory course is the formation's own course through its couplings under
  the course's own level history (`sensory_course`). Two of its courses from one start of the
  agent's parts are alike on the blanket before `n + 2` exactly where their level histories are
  alike through `g`'s couplings up to `n` (`blanket_iff_through`), and then their internal courses
  agree up to `n + 2` (`internal_through_couplings`). Where the act does not move the levels (the
  open loop, `openLoop`), every reading of the internal course up to `n + 2` is a selection through
  the couplings up to `n` (`internal_selectsThrough`). In the closed loop both sides of
  `blanket_iff_through` are read off one course, so there it says that the sensory part carries
  exactly the coupling values and that the agent follows its sensory course. The law is a
  construction, not a test: with the step on the world's side and the environment arbitrary, it
  exists wherever the couplings give the values, and having it forbids nothing of the formation's
  course (the first level below). What it states is what the sensory part carries and that what the
  agent tells apart passes through it. For every world `w` and formation `g` of it, with `obs` any
  couplings by level, admission at `g` decided and `obs g` listed, the values exist
  (`Web.listed_values`, with `w.web` as the web), so any model fed by what couples into `g` is such
  an agent. The World's own case is the open loop at `w.web.level`; the closed loop is a model
  beside the World, whose own exchange is not written as an environment. The internal part is a
  model; a formation's own level as the internal part, along one run, is the last item
  below. `ThresholdDrain`'s join is the case of the witness's web with no couplings (the set of
  couplings empty, `ThresholdCase.values`),
  the supply as the environment state beside the step, the two courses corresponding part by part
  (`ThresholdCase.threshold_case`).
* **The law a family shows, part by part.** A part of the next configuration depends only on a
  reading (`PartDependsOnlyOn`) where configurations agreeing under one map go, under one move, to
  configurations agreeing under another. `DependsOnlyOn` is the case where the second map is the
  identity and `GoAlike` the case of one map, both by definition; `Determined` is equivalent to the
  case where both are the identity (`partDependsOnlyOn_id_iff`). The law a family shows has such a
  part exactly where the family is consistent under the two maps
  (`shownBy_partDependsOnlyOn_iff`). A law determined part by part (`BlanketDetermined`) is two
  cases, one for the agent and one for the world: the blanket's form on the law a family shows,
  which may be partial and keeps the family's moves. A family is admitted by such a law exactly
  where it is consistent part by part (`admitted_iff`), such a law is determined
  (`BlanketDetermined.determined`), and the courses of every blanketed law form a family consistent
  part by part (`blanketed_courses_consistent`).
* **When the existence of a blanket constrains**, at three levels.
  1. With parts that read the course and not only the configuration, which course and the step
     (`clocked`) or the course's future (`future`), every family of courses is the course family of
     a blanketed law (`clocked_course`, `future_course`), its clocked reading consistent part by
     part though the family need not be consistent (`clocked_witness`). The step alone is not
     enough for a family (`clock_only_fails`).
  2. With parts read off the configuration, a degenerate map gives every family a law determined
     part by part (the constant map, `const_consistent`), or exactly the families whose law is
     determined (the whole configuration as the internal part, `whole_iff`, with
     `shownBy_determined_iff`), so it refutes no family whose law is determined. Any injective map,
     degenerate or not, gives one only where the law is determined (`injective_consistent`), and not
     always there: under the identity reading of the sparse partition below it fails
     (`injective_converse_fails`).
  3. A sparse partition fixed apart from the family, on a law the same at every step, the internal
     part barred from reading the external part that moves it, can be refuted, even by one run
     (`ReadsExternal.not_consistent`, `ReadsExternal.not_blanketed`), while the whole configuration
     reads the same run as a law determined part by part (`ReadsExternal.whole_consistent`).
  Whoever may pick the reading after seeing the family can pick one of the first two kinds, so a
  blanket read that way constrains nothing. `Hexagram.runsOrder_reads` makes the same kind of
  refutation for a line-by-line reading of a law the same at every step.
* **A formation's level as the internal part, along one run.** With the step as the external part
  (`stepExternal`), a course is consistent part by part exactly where its agent is consistent: at
  any two steps alike on the internal, sensory and active states, the next internal and active
  states agree (`AgentConsistent`, `stepExternal_consistent_iff`). The world's half holds of every
  such course, the world's side being the run read by the step, the World's other records entering
  only through it; so exactly there some law determined part by part admits it
  (`stepExternal_admitted_iff`), and, given the functions, it is the course of a blanketed law whose
  internal part moves by the sensory state at its own step and whose world's side is the open loop
  at that course (`stepLaw_course`); the converse is not stated. The condition is tested only at
  steps where the three states recur. On a World's run read with a formation's own level as the
  internal part, a value across steps of what couples into it as the sensory part, telling two steps
  apart only by admission at each and the levels coupled in (`ValuesAcross`; where admission is
  decided and the couplings listed, `listed_values`' value meets it, `listed_valuesAcross`), and its
  act, its rows at the steps a presence course marks (`presentRow`), as the active part
  (`levelParts`), in a balanced history the condition is one on the World's records: at any two
  steps alike on its level, its admission, the levels coupled into it and its act, what the relata
  present give to it at one step plus what they take from it at the other is the same with the
  steps exchanged, and its next acts agree, pairwise, with no subtraction (`next_level_alike_iff`,
  `levelParts_admitted_iff`). A drain in three phases from what does not couple in fails it
  (`PhasedDrain.not_admitted`), and a drain and feed in two phases from the same kind of source
  meets it, the level recurring (`Alternating.admitted`, `Alternating.recurs`): whether what moves
  the level couples in does not decide the condition. Across a family of runs, or with the step off
  the world's side, the world's half becomes a condition, not stated here; the formation's other
  records are not in the internal part.

Modelling choices: discrete synchronous steps; determined laws, as `Blanketed` is; the four parts
of types in `Type`; a law the same at every step, read by one map at every step; the blanket as
sparse coupling, not conditional independence of a stationary density (`BlanketWeights` joins the
two where it can). In the join, admission is given by the web and the couplings by level `obs` are
supplied, as in `Testing`; their values are given by `Web.ValuesThrough`. Which map a thing's
partition is read by is not derived. For a formation's level: one run with the step as the external
part; the value and act courses supplied, the World's reading taking a value across steps, which
tells two steps apart only by admission at each and the levels coupled in, and the act as its rows at
the steps a presence course marks; amounts in `Nat` under balance. No `simp`, `omega` or
generated injectivity equations, which bring `propext`; parts and pairs are compared by matching,
`congrArg` and `Prod.mk.inj`, and a reflex to replace `parts_eq` by `Parts.mk.injEq` would bring
`propext`. The steps of `Assurance.ofMap` are read as
`t = f s a`, and `course (n + 1)` unfolds to `step (course n)` (`Law.orbit`). A leaf importing
`Blanket`, `Histories` and `IdentificationRuns`.
-/

namespace Becoming

namespace BlanketCouplings

open Generative Blanket

universe u v w w'

/-! ## Parts and pairs -/

section Parts

variable {I S A E : Type}

/-- Two configurations agreeing on every part are one. -/
theorem parts_eq : ∀ {x y : Parts I S A E}, x.internal = y.internal → x.sensory = y.sensory →
    x.active = y.active → x.external = y.external → x = y
  | ⟨_, _, _, _⟩, ⟨_, _, _, _⟩, rfl, rfl, rfl, rfl => rfl

/-- Two pairs agreeing on each side are one. -/
theorem pair_eq {α β : Type} : ∀ {a a' : α} {b b' : β}, a = a' → b = b' → (a, b) = (a', b')
  | _, _, _, _, rfl, rfl => rfl

/-- Any two values of `Unit` are one. -/
theorem unit_eq : ∀ a b : Unit, a = b
  | (), () => rfl

/-- What the agent's next state reads: the internal, sensory and active parts. -/
def agentReads (x : Parts I S A E) : I × S × A := (x.internal, x.sensory, x.active)

/-- The agent's parts: the internal and active parts. -/
def agentParts (x : Parts I S A E) : I × A := (x.internal, x.active)

/-- What the world's next state reads: the sensory, active and external parts. -/
def worldReads (x : Parts I S A E) : S × A × E := (x.sensory, x.active, x.external)

/-- The world's parts: the sensory and external parts. -/
def worldParts (x : Parts I S A E) : S × E := (x.sensory, x.external)

end Parts

/-! ## The law a family shows, part by part -/

section Part

variable {S : Type u} {M : Type v} {K : Type w} {K' : Type w'}

/-- **A part of the next configuration depending only on a reading**: wherever two configurations
agree under `π`, one move takes them to configurations agreeing under `ρ`. `DependsOnlyOn P π` is
the case `ρ := id` and `GoAlike P π` the case `ρ := π`, both by definition; `Determined P` is
equivalent to the case where both are the identity (`partDependsOnlyOn_id_iff`). -/
def PartDependsOnlyOn (P : Process S M) (π : S → K) (ρ : S → K') : Prop :=
  ∀ s s' a u u', π s = π s' → P.step s a u → P.step s' a u' → ρ u = ρ u'

/-- **Determined is depending only on the whole configuration, for the whole configuration.** -/
theorem partDependsOnlyOn_id_iff {P : Process S M} : PartDependsOnlyOn P id id ↔ Determined P :=
  ⟨fun only s a t t' step step' => only s s a t t' rfl step step',
   fun det s s' a u u' (same : s = s') step step' =>
    match s', same, step' with
    | _, rfl, step' => det s a u u' step step'⟩

/-- **A family consistent under two readings**: wherever two of its histories agree under `π` at
steps taken by one move, they agree under `ρ` at the next steps. `ConsistentFamily` is the case
where both are the identity. -/
def PartConsistentFamily (H : (Nat → S) → (Nat → M) → Prop) (π : S → K) (ρ : S → K') : Prop :=
  ∀ g m g' m' i j, H g m → H g' m' → π (g i) = π (g' j) → m i = m' j →
    ρ (g (i + 1)) = ρ (g' (j + 1))

/-- **The law a family shows has a part depending only on a reading exactly where the family is
consistent under the two readings**, the part-by-part form of `shownBy_determined_iff`. -/
theorem shownBy_partDependsOnlyOn_iff {H : (Nat → S) → (Nat → M) → Prop} {π : S → K}
    {ρ : S → K'} : PartDependsOnlyOn (ShownBy H) π ρ ↔ PartConsistentFamily H π ρ :=
  ⟨fun only g m g' m' i j held held' same same' =>
    only (g i) (g' j) (m i) (g (i + 1)) (g' (j + 1)) same ⟨g, m, i, held, rfl, rfl, rfl⟩
      ⟨g', m', j, held', rfl, same'.symm, rfl⟩,
   fun cons _ _ _ _ _ same ⟨g, m, i, held, at_s, by_a, to_t⟩ ⟨g', m', j, held', at_s', by_a', to_t'⟩ =>
    (congrArg ρ to_t).symm.trans
      ((cons g m g' m' i j held held'
          ((congrArg π at_s).trans (same.trans (congrArg π at_s').symm))
          (by_a.trans by_a'.symm)).trans
        (congrArg ρ to_t'))⟩

/-- A law below one with a part depending only on a reading has that part too. -/
theorem PartDependsOnlyOn.of_le {P Q : Process S M} {π : S → K} {ρ : S → K'}
    (le : ∀ s a t, Q.step s a t → P.step s a t) (only : PartDependsOnlyOn P π ρ) :
    PartDependsOnlyOn Q π ρ :=
  fun s s' a u u' same step step' => only s s' a u u' same (le s a u step) (le s' a u' step')

/-- A family within one consistent under two readings is consistent under them. -/
theorem PartConsistentFamily.mono {H H' : (Nat → S) → (Nat → M) → Prop} {π : S → K}
    {ρ : S → K'} (sub : ∀ g m, H g m → H' g m) (cons : PartConsistentFamily H' π ρ) :
    PartConsistentFamily H π ρ :=
  fun g m g' m' i j held held' => cons g m g' m' i j (sub g m held) (sub g' m' held')

end Part

section Blanket

variable {I S A E M : Type}

/-- **A law determined part by part**: under one move, the agent's parts of the next configuration
depend only on the internal, sensory and active parts, and the world's parts only on the sensory,
active and external parts. The blanket's form on any law with moves, partial or not; moves are
kept, as in `Determined`. -/
def BlanketDetermined (P : Process (Parts I S A E) M) : Prop :=
  PartDependsOnlyOn P agentReads agentParts ∧ PartDependsOnlyOn P worldReads worldParts

/-- **A family consistent part by part**: consistent under the agent's two readings and under the
world's. -/
def BlanketConsistentFamily (H : (Nat → Parts I S A E) → (Nat → M) → Prop) : Prop :=
  PartConsistentFamily H agentReads agentParts ∧ PartConsistentFamily H worldReads worldParts

/-- **The law a family shows is determined part by part exactly where the family is consistent
part by part.** -/
theorem shownBy_blanketDetermined_iff {H : (Nat → Parts I S A E) → (Nat → M) → Prop} :
    BlanketDetermined (ShownBy H) ↔ BlanketConsistentFamily H :=
  ⟨fun det => ⟨shownBy_partDependsOnlyOn_iff.mp det.1, shownBy_partDependsOnlyOn_iff.mp det.2⟩,
   fun cons => ⟨shownBy_partDependsOnlyOn_iff.mpr cons.1, shownBy_partDependsOnlyOn_iff.mpr cons.2⟩⟩

/-- A law below one determined part by part is determined part by part. -/
theorem BlanketDetermined.of_le {P Q : Process (Parts I S A E) M}
    (le : ∀ s a t, Q.step s a t → P.step s a t) (det : BlanketDetermined P) : BlanketDetermined Q :=
  ⟨det.1.of_le le, det.2.of_le le⟩

/-- A family within one consistent part by part is consistent part by part. -/
theorem BlanketConsistentFamily.mono {H H' : (Nat → Parts I S A E) → (Nat → M) → Prop}
    (sub : ∀ g m, H g m → H' g m) (cons : BlanketConsistentFamily H') : BlanketConsistentFamily H :=
  ⟨cons.1.mono sub, cons.2.mono sub⟩

/-- **A family is admitted by some law determined part by part exactly where it is consistent part
by part.** -/
theorem admitted_iff {H : (Nat → Parts I S A E) → (Nat → M) → Prop} :
    (∃ Q : Process (Parts I S A E) M, BlanketDetermined Q ∧ ∀ g m, H g m → Admits Q g m) ↔
      BlanketConsistentFamily H :=
  ⟨fun ⟨_, det, admits⟩ => shownBy_blanketDetermined_iff.mp (det.of_le (shownBy_le_iff.mpr admits)),
   fun cons => ⟨ShownBy H, shownBy_blanketDetermined_iff.mpr cons, fun _ _ held => ShownBy.admits held⟩⟩

/-- **A law determined part by part is determined**: two steps from one configuration under one
move meet both cases, so all four parts of their ends agree. -/
theorem BlanketDetermined.determined {P : Process (Parts I S A E) M} (det : BlanketDetermined P) :
    Determined P :=
  fun x m y y' step step' =>
    have agent : agentParts y = agentParts y' := det.1 x x m y y' rfl step step'
    have world : worldParts y = worldParts y' := det.2 x x m y y' rfl step step'
    parts_eq (congrArg Prod.fst agent) (congrArg Prod.fst world) (congrArg Prod.snd agent)
      (congrArg Prod.snd world)

/-- **A blanketed law, read as a process with the trivial move, is determined part by part.** The
steps of `Assurance.ofMap` are read as `t = f s a`. -/
theorem blanketed_determined (b : Blanketed I S A E) :
    BlanketDetermined (Assurance.ofMap (fun x (_ : Unit) => b.step x)) :=
  ⟨fun x x' _ y y' same (step : y = b.step x) (step' : y' = b.step x') =>
    match y, y', step, step' with
    | _, _, rfl, rfl =>
      have i : x.internal = x'.internal := congrArg Prod.fst same
      have s : x.sensory = x'.sensory := congrArg (fun v : I × S × A => v.2.1) same
      have a : x.active = x'.active := congrArg (fun v : I × S × A => v.2.2) same
      pair_eq (congr3 b.nextInternal i s a) (congr3 b.nextActive i s a),
   fun x x' _ y y' same (step : y = b.step x) (step' : y' = b.step x') =>
    match y, y', step, step' with
    | _, _, rfl, rfl =>
      have s : x.sensory = x'.sensory := congrArg Prod.fst same
      have a : x.active = x'.active := congrArg (fun v : S × A × E => v.2.1) same
      have e : x.external = x'.external := congrArg (fun v : S × A × E => v.2.2) same
      pair_eq (congr3 b.nextSensory s a e) (congr3 b.nextExternal s a e)⟩

/-- **The step congruence of a blanketed law's courses**: courses agreeing on what the agent reads
at two steps agree on the agent's parts at the steps after, and likewise on the world's side. -/
theorem blanketed_step_alike (b : Blanketed I S A E) {x y : Parts I S A E} {n n' : Nat} :
    (agentReads (b.course x n) = agentReads (b.course y n') →
        agentParts (b.course x (n + 1)) = agentParts (b.course y (n' + 1))) ∧
      (worldReads (b.course x n) = worldReads (b.course y n') →
        worldParts (b.course x (n + 1)) = worldParts (b.course y (n' + 1))) :=
  ⟨fun same => (blanketed_determined b).1 _ _ () _ _ same rfl rfl,
   fun same => (blanketed_determined b).2 _ _ () _ _ same rfl rfl⟩

/-- **The courses of a blanketed law form a family consistent part by part.** The converse, a
blanketed law for every family consistent part by part, needs a next state chosen at every
reading the family never shows, and is not stated. -/
theorem blanketed_courses_consistent (b : Blanketed I S A E) :
    BlanketConsistentFamily
      (fun (h : Nat → Parts I S A E) (_ : Nat → Unit) => ∃ x, ∀ n, h n = b.course x n) :=
  ⟨fun _ _ _ _ i j ⟨_, on⟩ ⟨_, on'⟩ same _ =>
    (congrArg agentParts (on (i + 1))).trans
      (((blanketed_step_alike b).1
          ((congrArg agentReads (on i)).symm.trans (same.trans (congrArg agentReads (on' j))))).trans
        (congrArg agentParts (on' (j + 1))).symm),
   fun _ _ _ _ i j ⟨_, on⟩ ⟨_, on'⟩ same _ =>
    (congrArg worldParts (on (i + 1))).trans
      (((blanketed_step_alike b).2
          ((congrArg worldReads (on i)).symm.trans (same.trans (congrArg worldReads (on' j))))).trans
        (congrArg worldParts (on' (j + 1))).symm)⟩

end Blanket

/-! ## A formation's couplings as its blanket -/

section Couplings

variable {F C O M A X : Type} {W : Web F C} {obs : F → C → Prop} {g : F}
  (update : M → O → A → M) (policy : M → O → A → A) (value : Nat → (C → Nat) → O)
  (lev : Nat → X → C → Nat) (env : O → A → Nat → X → X)

/-- **The coupling law.** The internal part moves by the model `update`, the active part by the
policy. The external part is a step and an environment state `x`: it moves to the next step and
to `env o a t x`, which may read the formation's sensory part and its act. The sensory part's next
state is the value of what couples into the formation at the levels `lev t x`. The clock is on the
world's side; the agent reads none. -/
def couplingLaw : Blanketed M O A (Nat × X) where
  nextInternal m o a := update m o a
  nextSensory _ _ e := value e.1 (lev e.1 e.2)
  nextActive m o a := policy m o a
  nextExternal o a e := (e.1 + 1, env o a e.1 e.2)

/-- Starting at step zero with environment state `x`. -/
def startAt (m : M) (o : O) (a : A) (x : X) : Parts M O A (Nat × X) :=
  ⟨m, o, a, (0, x)⟩

/-- The external part's step is the course's step. -/
theorem clock (m : M) (o : O) (a : A) (x : X) :
    ∀ n, ((couplingLaw update policy value lev env).course (startAt m o a x) n).external.1 = n
  | 0 => rfl
  | n + 1 => congrArg (· + 1) (clock m o a x n)

/-- A course's own level history: at each step, the levels its environment state gives. -/
def ownLevels (m : M) (o : O) (a : A) (x : X) : Nat → C → Nat :=
  fun n => lev n ((couplingLaw update policy value lev env).course (startAt m o a x) n).external.2

/-- **Its sensory course is the formation's own course through its couplings**, one step on,
under the course's own level history, whatever the model, the policy and the environment. -/
theorem sensory_course (m : M) (o : O) (a : A) (x : X) (n : Nat) :
    ((couplingLaw update policy value lev env).course (startAt m o a x) (n + 1)).sensory =
      Web.courseThrough value (ownLevels update policy value lev env m o a x) n :=
  congrArg
    (fun t => value t (lev t ((couplingLaw update policy value lev env).course (startAt m o a x) n).external.2))
    (clock update policy value lev env m o a x n)

/-- **Alike on the blanket exactly where alike through the formation's couplings.** Two courses
from one internal, sensory and active start and two environment states are alike on the blanket
before `n + 2` exactly where their own level histories are alike through `g`'s couplings up to
`n`, the environment reading the act or not. -/
theorem blanket_iff_through (values : W.ValuesThrough obs g value) (m : M) (o : O) (a : A)
    (x x' : X) (n : Nat) :
    (couplingLaw update policy value lev env).BlanketAlike (startAt m o a x) (startAt m o a x')
        (n + 2) ↔
      W.AlikeThroughUpTo obs g (ownLevels update policy value lev env m o a x)
        (ownLevels update policy value lev env m o a x') n :=
  have sensed : W.AlikeThroughUpTo obs g (ownLevels update policy value lev env m o a x)
        (ownLevels update policy value lev env m o a x') n → ∀ k, k < n + 2 →
      ((couplingLaw update policy value lev env).course (startAt m o a x) k).sensory =
        ((couplingLaw update policy value lev env).course (startAt m o a x') k).sensory :=
    fun through k lt => match k, lt with
      | 0, _ => rfl
      | s + 1, lt =>
        (sensory_course update policy value lev env m o a x s).trans
          (((Web.alikeThrough_iff values).mp
              (through s (Nat.le_of_lt_succ (Nat.lt_of_succ_lt_succ lt)))).trans
            (sensory_course update policy value lev env m o a x' s).symm)
  ⟨fun alike s le =>
    (Web.alikeThrough_iff values).mpr
      ((sensory_course update policy value lev env m o a x s).symm.trans
        ((alike (s + 1) (Nat.succ_lt_succ (Nat.lt_succ_of_le le))).1.trans
          (sensory_course update policy value lev env m o a x' s))),
   fun through k lt =>
    ⟨sensed through k lt,
     ((couplingLaw update policy value lev env).agent_through_sensory (x := startAt m o a x)
        (y := startAt m o a x') rfl rfl k
        fun j lt' => sensed through j (Nat.lt_trans lt' lt)).2⟩⟩

/-- **What the internal course tells apart, the couplings tell apart**: two courses from one agent
whose own level histories are alike through `g`'s couplings up to `n` have one internal state at
every step up to `n + 2`. -/
theorem internal_through_couplings (values : W.ValuesThrough obs g value) (m : M) (o : O) (a : A)
    (x x' : X) (n : Nat)
    (through : W.AlikeThroughUpTo obs g (ownLevels update policy value lev env m o a x)
      (ownLevels update policy value lev env m o a x') n) :
    ∀ k, k ≤ n + 2 →
      ((couplingLaw update policy value lev env).course (startAt m o a x) k).internal =
        ((couplingLaw update policy value lev env).course (startAt m o a x') k).internal :=
  fun k le =>
    (couplingLaw update policy value lev env).internal_through_blanket (x := startAt m o a x)
      (y := startAt m o a x') rfl k
      fun j lt => (blanket_iff_through update policy value lev env values m o a x x' n).mpr through j
        (Nat.lt_of_lt_of_le lt le)

/-- A level history's levels at a step. -/
def levelsAt (t : Nat) (l : Nat → C → Nat) : C → Nat := l t

/-- An environment step under which the level history stays as it is, whatever the formation
senses and does. -/
def levelsStay (_ : O) (_ : A) (_ : Nat) (l : Nat → C → Nat) : Nat → C → Nat := l

/-- The open loop: the environment state a level history, which the formation's act does not
move. -/
def openLoop : Blanketed M O A (Nat × (Nat → C → Nat)) :=
  couplingLaw update policy value levelsAt levelsStay

/-- In the open loop the external part at step `n` is the step and the given level history. -/
theorem open_external (m : M) (o : O) (a : A) (l : Nat → C → Nat) :
    ∀ n, ((openLoop update policy value).course (startAt m o a l) n).external = (n, l)
  | 0 => rfl
  | n + 1 => congrArg (fun e : Nat × (Nat → C → Nat) => (e.1 + 1, e.2)) (open_external m o a l n)

/-- In the open loop a course's own level history is the given one. -/
theorem open_levels (m : M) (o : O) (a : A) (l : Nat → C → Nat) (n : Nat) :
    ownLevels update policy value levelsAt levelsStay m o a l n = l n :=
  congrArg (fun e : Nat × (Nat → C → Nat) => e.2 n) (open_external update policy value m o a l n)

/-- **Every reading of its internal course is a selection through the formation's couplings**, in
the open loop: whatever the model and the policy, a claim about level histories that reads the
internal course up to `n + 2` is a selection through `g`'s couplings up to `n`. -/
theorem internal_selectsThrough (values : W.ValuesThrough obs g value) (m : M) (o : O) (a : A)
    (n : Nat) (select : (Nat → M) → Prop)
    (reads : ∀ f f' : Nat → M, (∀ k, k ≤ n + 2 → f k = f' k) → (select f ↔ select f')) :
    W.SelectsThrough obs g n
      (fun l => select fun k => ((openLoop update policy value).course (startAt m o a l) k).internal) :=
  fun l l' through =>
    reads _ _
      (internal_through_couplings update policy value levelsAt levelsStay values
        m o a l l' n fun s le =>
          (Web.alikeThrough_iff values).mpr
            ((congrArg (value s) (open_levels update policy value m o a l s)).trans
              (((Web.alikeThrough_iff values).mp (through s le)).trans
                (congrArg (value s) (open_levels update policy value m o a l' s)).symm)))

end Couplings

/-! ### The threshold witness as a case

`ThresholdDrain`'s blanketed law, with the supply as its external part, is the coupling law at the
witness's web with the supply as the environment state beside the step: the two courses correspond
part by part, and `ThresholdDrain.blanket_iff_through` follows from `blanket_iff_through`. -/

namespace ThresholdCase

/-- The value of what couples into the witness's formation: whether the supply is positive. -/
def value : Nat → (Unit → Nat) → Bool := fun _ l => Nat.blt 0 (l ())

/-- The supply as the levels. -/
def lev : Nat → Nat → Unit → Nat := fun _ x _ => x

/-- The supply drains by one each step, no act changing it. -/
def env : Bool → Unit → Nat → Nat → Nat := fun _ _ _ x => x - 1

/-- Going on while the supply is positive. -/
def update : Bool → Bool → Unit → Bool := fun m o _ => m && o

/-- The trivial policy. -/
def policy : Bool → Bool → Unit → Unit := fun _ _ a => a

theorem admits_iff (x : Unit → Nat) (t : Nat) :
    ThresholdDrain.web.Admits x t () ↔ Nat.blt 0 (x ()) = true :=
  ⟨fun admits => Nat.ble_eq_true_of_le (admits () trivial),
   fun reads c _ => match c with | () => Nat.le_of_ble_eq_true reads⟩

/-- The threshold gives the values of what couples into the witness's formation. -/
theorem values : ThresholdDrain.web.ValuesThrough (fun _ _ => False) () value :=
  fun t x y =>
    ⟨fun same =>
      ⟨(admits_iff x t).trans
        ((⟨fun h => same.symm.trans h, fun h => same.trans h⟩ :
            Nat.blt 0 (x ()) = true ↔ Nat.blt 0 (y ()) = true).trans (admits_iff y t).symm),
       fun _ never => never.elim⟩,
     fun ⟨admitted, _⟩ =>
      bool_eq_of_iff (((admits_iff x t).symm.trans admitted).trans (admits_iff y t))⟩

/-- The coupling law's course from supply `e` matches `ThresholdDrain.law`'s part by part, with the
step beside the supply in the external part. -/
theorem corr (e : Nat) : ∀ n,
    ((couplingLaw update policy value lev env).course (startAt true true () e) n).internal =
        (ThresholdDrain.law.course ⟨true, true, (), e⟩ n).internal ∧
      ((couplingLaw update policy value lev env).course (startAt true true () e) n).sensory =
        (ThresholdDrain.law.course ⟨true, true, (), e⟩ n).sensory ∧
      ((couplingLaw update policy value lev env).course (startAt true true () e) n).active =
        (ThresholdDrain.law.course ⟨true, true, (), e⟩ n).active ∧
      ((couplingLaw update policy value lev env).course (startAt true true () e) n).external =
        (n, (ThresholdDrain.law.course ⟨true, true, (), e⟩ n).external)
  | 0 => ⟨rfl, rfl, rfl, rfl⟩
  | n + 1 =>
    match corr e n with
    | ⟨i, s, a, x⟩ =>
      ⟨Limit.and_congr2 i s,
       congrArg (fun p : Nat × Nat => Nat.blt 0 p.2) x,
       a,
       congrArg (fun p : Nat × Nat => (p.1 + 1, p.2 - 1)) x⟩

/-- Its own level history is the draining supply. -/
theorem own_eq (e s : Nat) :
    ownLevels update policy value lev env true true () e s = fun _ => e - s :=
  congrArg (fun v : Nat => fun (_ : Unit) => v)
    ((congrArg Prod.snd (corr e s).2.2.2).trans (ThresholdDrain.external_course _ s))

/-- **`ThresholdDrain.blanket_iff_through` follows from the general join.** -/
theorem threshold_case (e e' n : Nat) :
    ThresholdDrain.law.BlanketAlike ⟨true, true, (), e⟩ ⟨true, true, (), e'⟩ (n + 2) ↔
      ThresholdDrain.web.AlikeThroughUpTo (fun _ _ => False) () (fun t _ => e - t)
        (fun t _ => e' - t) n :=
  have blanket :
      ThresholdDrain.law.BlanketAlike ⟨true, true, (), e⟩ ⟨true, true, (), e'⟩ (n + 2) ↔
        (couplingLaw update policy value lev env).BlanketAlike (startAt true true () e)
          (startAt true true () e') (n + 2) :=
    ⟨fun h j lt => ⟨(corr e j).2.1.trans ((h j lt).1.trans (corr e' j).2.1.symm),
                    (corr e j).2.2.1.trans ((h j lt).2.trans (corr e' j).2.2.1.symm)⟩,
     fun h j lt => ⟨(corr e j).2.1.symm.trans ((h j lt).1.trans (corr e' j).2.1),
                    (corr e j).2.2.1.symm.trans ((h j lt).2.trans (corr e' j).2.2.1)⟩⟩
  have through :
      ThresholdDrain.web.AlikeThroughUpTo (fun _ _ => False) ()
          (ownLevels update policy value lev env true true () e)
          (ownLevels update policy value lev env true true () e') n ↔
        ThresholdDrain.web.AlikeThroughUpTo (fun _ _ => False) () (fun t _ => e - t)
          (fun t _ => e' - t) n :=
    ⟨fun h s le => (Web.alikeThrough_iff values).mpr
        ((congrArg (value s) (own_eq e s)).symm.trans
          (((Web.alikeThrough_iff values).mp (h s le)).trans (congrArg (value s) (own_eq e' s)))),
     fun h s le => (Web.alikeThrough_iff values).mpr
        ((congrArg (value s) (own_eq e s)).trans
          (((Web.alikeThrough_iff values).mp (h s le)).trans
            (congrArg (value s) (own_eq e' s)).symm))⟩
  blanket.trans
    ((blanket_iff_through update policy value lev env values true true () e e' n).trans through)

end ThresholdCase

/-! ## When the existence of a blanket constrains -/

/-! ### Readings of the course -/

section Course

variable {α ρ : Type}

/-- **The clocked reading of a family of courses**: the internal part is a course's present value,
the sensory part its next, the external part which course and the step; the sensory part's next
state is the course's value two steps on. -/
def clocked (x : ρ → Nat → α) : Blanketed α α Unit (ρ × Nat) where
  nextInternal _ s _ := s
  nextSensory _ _ e := x e.1 (e.2 + 2)
  nextActive _ _ _ := ()
  nextExternal _ _ e := (e.1, e.2 + 1)

/-- **Every family's clocked reading is the course family of a blanketed law.** -/
theorem clocked_course (x : ρ → Nat → α) (r : ρ) :
    ∀ n, (clocked x).course ⟨x r 0, x r 1, (), (r, 0)⟩ n = ⟨x r n, x r (n + 1), (), (r, n)⟩
  | 0 => rfl
  | n + 1 => congrArg (clocked x).step (clocked_course x r n)

/-- **Every family's clocked reading is consistent part by part.** -/
theorem clocked_consistent (x : ρ → Nat → α) :
    BlanketConsistentFamily (fun (h : Nat → Parts α α Unit (ρ × Nat)) (_ : Nat → Unit) =>
      ∃ r, ∀ n, h n = ⟨x r n, x r (n + 1), (), (r, n)⟩) :=
  (blanketed_courses_consistent (clocked x)).mono fun _ _ ⟨r, on⟩ =>
    ⟨_, fun n => (on n).trans (clocked_course x r n).symm⟩

/-- Two courses from one value that part at their first step. -/
def parting (r : Bool) : Nat → Bool
  | 0 => false
  | _ + 1 => r

/-- **The clocked reading holds where the family is not consistent**: a family of two courses from
one value parting at their first step is not consistent, and its clocked reading is consistent part
by part. -/
theorem clocked_witness :
    ¬ ConsistentFamily (fun (h : Nat → Bool) (_ : Nat → Unit) => ∃ r, ∀ n, h n = parting r n) ∧
      BlanketConsistentFamily (fun (h : Nat → Parts Bool Bool Unit (Bool × Nat)) (_ : Nat → Unit) =>
        ∃ r, ∀ n, h n = ⟨parting r n, parting r (n + 1), (), (r, n)⟩) :=
  ⟨fun cons => Bool.noConfusion (show false = true from
      cons (parting false) (fun _ => ()) (parting true) (fun _ => ()) 0 0 ⟨false, fun _ => rfl⟩
        ⟨true, fun _ => rfl⟩ rfl rfl),
   clocked_consistent parting⟩

/-- Two courses alike at steps 0 and 1 that part at step 2. -/
def partingLate (r : Bool) : Nat → Bool
  | 0 => false
  | 1 => false
  | _ + 2 => r

/-- **The step alone is not enough for a family**: with the step but not which course in the
external part, the clocked reading's shape gives this family no law determined part by part. -/
theorem clock_only_fails :
    ¬ BlanketConsistentFamily (fun (h : Nat → Parts Bool Bool Unit Nat) (_ : Nat → Unit) =>
      ∃ r, ∀ n, h n = ⟨partingLate r n, partingLate r (n + 1), (), n⟩) :=
  fun cons => Bool.noConfusion (show false = true from
    congrArg Prod.fst
      (cons.2 (fun n => ⟨partingLate false n, partingLate false (n + 1), (), n⟩) (fun _ => ())
        (fun n => ⟨partingLate true n, partingLate true (n + 1), (), n⟩) (fun _ => ()) 0 0
        ⟨false, fun _ => rfl⟩ ⟨true, fun _ => rfl⟩ rfl rfl))

/-- A sequence after its first entry. -/
def shift (f : Nat → α) : Nat → α := fun k => f (k + 1)

/-- A sequence after its first `n` entries. -/
def suffix : Nat → (Nat → α) → Nat → α
  | 0, f => f
  | n + 1, f => shift (suffix n f)

theorem suffix_apply (f : Nat → α) : ∀ n k, suffix n f k = f (k + n)
  | 0, _ => rfl
  | n + 1, k => (suffix_apply f n (k + 1)).trans (congrArg f (Nat.succ_add k n))

theorem suffix_zero (f : Nat → α) (n : Nat) : suffix n f 0 = f n :=
  (suffix_apply f n 0).trans (congrArg f (Nat.zero_add n))

/-- **A reading of the course's future**, with no clock and no label: the sensory part holds the
course's future, shifted each step, the internal part takes its first entry, the external part is
`Unit`. -/
def future : Blanketed α (Nat → α) Unit Unit where
  nextInternal _ s _ := s 0
  nextSensory s _ _ := shift s
  nextActive _ _ _ := ()
  nextExternal _ _ _ := ()

/-- **Every course is the internal course of the future's blanketed law.** -/
theorem future_course (x : Nat → α) :
    ∀ n, ((future (α := α)).course ⟨x 0, suffix 1 x, (), ()⟩ n).internal = x n ∧
      ((future (α := α)).course ⟨x 0, suffix 1 x, (), ()⟩ n).sensory = suffix (n + 1) x
  | 0 => ⟨rfl, rfl⟩
  | n + 1 =>
    match future_course x n with
    | ⟨_, s⟩ =>
      ⟨(congrArg (fun f : Nat → α => f 0) s).trans (suffix_zero x (n + 1)),
       congrArg shift s⟩

end Course

/-! ### Readings of the configuration -/

section Configuration

variable {X M I S A E : Type}

/-- A family read by `π`: the histories `π` makes of its histories, step by step. -/
def readFamily (π : X → Parts I S A E) (H : (Nat → X) → (Nat → M) → Prop) :
    (Nat → Parts I S A E) → (Nat → M) → Prop :=
  fun g m => ∃ h, H h m ∧ ∀ n, g n = π (h n)

/-- **Under a constant reading every family is consistent part by part.** -/
theorem const_consistent (H : (Nat → X) → (Nat → M) → Prop) :
    BlanketConsistentFamily
      (readFamily (fun _ => (⟨(), (), (), ()⟩ : Parts Unit Unit Unit Unit)) H) :=
  ⟨fun _ _ _ _ _ _ _ _ _ _ => pair_eq (unit_eq _ _) (unit_eq _ _),
   fun _ _ _ _ _ _ _ _ _ _ => pair_eq (unit_eq _ _) (unit_eq _ _)⟩

/-- **Under an injective reading, consistent part by part is consistent.** -/
theorem injective_consistent {π : X → Parts I S A E} (inj : ∀ x x', π x = π x' → x = x')
    {H : (Nat → X) → (Nat → M) → Prop} (cons : BlanketConsistentFamily (readFamily π H)) :
    ConsistentFamily H :=
  fun h m h' m' i j held held' same same' =>
    have read : readFamily π H (fun n => π (h n)) m := ⟨h, held, fun _ => rfl⟩
    have read' : readFamily π H (fun n => π (h' n)) m' := ⟨h', held', fun _ => rfl⟩
    have at_i : π (h i) = π (h' j) := congrArg π same
    have agent : agentParts (π (h (i + 1))) = agentParts (π (h' (j + 1))) :=
      cons.1 _ m _ m' i j read read' (congrArg agentReads at_i) same'
    have world : worldParts (π (h (i + 1))) = worldParts (π (h' (j + 1))) :=
      cons.2 _ m _ m' i j read read' (congrArg worldReads at_i) same'
    inj _ _ (parts_eq (congrArg Prod.fst agent) (congrArg Prod.fst world) (congrArg Prod.snd agent)
      (congrArg Prod.snd world))

/-- The whole-configuration reading: the configuration as the internal part, the other parts
`Unit`. -/
def whole (x : X) : Parts X Unit Unit Unit := ⟨x, (), (), ()⟩

/-- **Under the whole-configuration reading a family is consistent part by part exactly where it is
consistent**, so exactly where the law it shows is determined (`shownBy_determined_iff`). -/
theorem whole_iff {H : (Nat → X) → (Nat → M) → Prop} :
    BlanketConsistentFamily (readFamily whole H) ↔ ConsistentFamily H :=
  ⟨injective_consistent fun _ _ same => congrArg Parts.internal same,
   fun cons =>
    ⟨fun _ _ _ _ i j ⟨h, held, read⟩ ⟨h', held', read'⟩ same same' =>
      have at_i : h i = h' j :=
        (congrArg Parts.internal (read i)).symm.trans
          ((congrArg Prod.fst same).trans (congrArg Parts.internal (read' j)))
      pair_eq
        ((congrArg Parts.internal (read (i + 1))).trans
          ((cons h _ h' _ i j held held' at_i same').trans
            (congrArg Parts.internal (read' (j + 1))).symm))
        (unit_eq _ _),
     fun _ _ _ _ _ _ _ _ _ _ => pair_eq (unit_eq _ _) (unit_eq _ _)⟩⟩

end Configuration

/-! ### A sparse partition fixed apart from the course can refute a blanket on one run

The internal part's next state is whether the external part, cycling through three values, is at
its first; the sensory and active parts are trivial. -/

namespace ReadsExternal

/-- Three values in a cycle. -/
inductive Three where
  | first
  | second
  | third

/-- The next value of the cycle. -/
def next : Three → Three
  | .first => .second
  | .second => .third
  | .third => .first

/-- Whether a value is the first. -/
def isFirst : Three → Bool
  | .first => true
  | .second => false
  | .third => false

/-- The internal part's next state reads the external part. -/
def step (x : Parts Bool Unit Unit Three) : Parts Bool Unit Unit Three :=
  ⟨isFirst x.external, (), (), next x.external⟩

/-- The start: not first, at the first value. -/
def start : Parts Bool Unit Unit Three := ⟨false, (), (), .first⟩

/-- The one run. -/
def run : Nat → Parts Bool Unit Unit Three := Law.orbit step start

/-- Its internal course, by computation: false, true, false, false, true. -/
theorem internal_course :
    (run 0).internal = false ∧ (run 1).internal = true ∧ (run 2).internal = false ∧
      (run 3).internal = false ∧ (run 4).internal = true :=
  ⟨rfl, rfl, rfl, rfl, rfl⟩

/-- **Under its own partition its one run is not consistent part by part**: at steps 2 and 3 the
internal, sensory and active parts agree, and the internal parts after them do not. -/
theorem not_consistent :
    ¬ BlanketConsistentFamily
      (fun (h : Nat → Parts Bool Unit Unit Three) (_ : Nat → Unit) => h = run) :=
  fun cons => Bool.noConfusion (show false = true from
    congrArg Prod.fst (cons.1 run (fun _ => ()) run (fun _ => ()) 2 3 rfl rfl rfl rfl))

/-- **Its run is the course of no blanketed law on these four types.** -/
theorem not_blanketed :
    ¬ ∃ (b : Blanketed Bool Unit Unit Three) (x : Parts Bool Unit Unit Three),
      ∀ n, b.course x n = run n :=
  fun ⟨b, x, on⟩ =>
    not_consistent ((blanketed_courses_consistent b).mono fun _ _ held =>
      ⟨x, fun n => (congrArg (fun f : Nat → Parts Bool Unit Unit Three => f n) held).trans (on n).symm⟩)

/-- **Under the whole-configuration reading the same run is consistent part by part**: its run is
an orbit. -/
theorem whole_consistent :
    BlanketConsistentFamily
      (readFamily whole (fun (h : Nat → Parts Bool Unit Unit Three) (_ : Nat → Unit) => h = run)) :=
  whole_iff.mpr fun h _ h' _ _ _ (held : h = run) (held' : h' = run) same _ =>
    match h, h', held, held', same with
    | _, _, rfl, rfl, same => congrArg step same

end ReadsExternal

/-- **An injective reading need not give a blanket where the law is determined**: under the
identity reading, which is injective, the run of `ReadsExternal` is consistent and not consistent
part by part. -/
theorem injective_converse_fails :
    ConsistentFamily
        (fun (h : Nat → Parts Bool Unit Unit ReadsExternal.Three) (_ : Nat → Unit) =>
          h = ReadsExternal.run) ∧
      ¬ BlanketConsistentFamily
        (fun (h : Nat → Parts Bool Unit Unit ReadsExternal.Three) (_ : Nat → Unit) =>
          h = ReadsExternal.run) :=
  ⟨whole_iff.mp ReadsExternal.whole_consistent, ReadsExternal.not_consistent⟩

/-! ## A formation's level as the internal part, along one run -/

section Along

variable {I S A : Type}

/-- **A course with the step as its external part**: an internal course `i`, a sensory course `s`
and an active course `a`, the step external. -/
def stepExternal (i : Nat → I) (s : Nat → S) (a : Nat → A) (n : Nat) : Parts I S A Nat :=
  ⟨i n, s n, a n, n⟩

/-- **The agent consistent along a course**: at any two steps where the internal, sensory and
active states agree, the next internal states agree and the next active states agree. A law the
same at every step on the agent's side, with no clock beyond what the three courses carry: a course
carrying the step meets it at every pair of steps. It is tested only at steps where the three states
recur. -/
def AgentConsistent (i : Nat → I) (s : Nat → S) (a : Nat → A) : Prop :=
  ∀ j k, i j = i k → s j = s k → a j = a k → i (j + 1) = i (k + 1) ∧ a (j + 1) = a (k + 1)

/-- **With the step external, a course is consistent part by part exactly where its agent is
consistent.** The world's half holds of every such course, since the step tells any two of its
steps apart. The condition is tested only at steps where the internal, sensory and active states
recur; a course where they never recur meets it, whatever moves it. -/
theorem stepExternal_consistent_iff {i : Nat → I} {s : Nat → S} {a : Nat → A} :
    BlanketConsistentFamily
        (fun (r : Nat → Parts I S A Nat) (_ : Nat → Unit) => r = stepExternal i s a) ↔
      AgentConsistent i s a :=
  ⟨fun cons j k si ss sa =>
    have next : agentParts (stepExternal i s a (j + 1)) = agentParts (stepExternal i s a (k + 1)) :=
      cons.1 (stepExternal i s a) (fun _ => ()) (stepExternal i s a) (fun _ => ()) j k rfl rfl
        (BlanketCouplings.pair_eq si (BlanketCouplings.pair_eq ss sa)) rfl
    ⟨congrArg (fun v : I × A => v.1) next, congrArg (fun v : I × A => v.2) next⟩,
   fun cons =>
    ⟨fun r _ r' _ j k (held : r = stepExternal i s a) (held' : r' = stepExternal i s a) same _ =>
      match r, r', held, held', same with
      | _, _, rfl, rfl, same =>
        have d := cons j k (congrArg (fun v : I × S × A => v.1) same)
          (congrArg (fun v : I × S × A => v.2.1) same) (congrArg (fun v : I × S × A => v.2.2) same)
        BlanketCouplings.pair_eq d.1 d.2,
     fun r _ r' _ _ _ (held : r = stepExternal i s a) (held' : r' = stepExternal i s a) same _ =>
      match r, r', held, held', same with
      | _, _, rfl, rfl, same =>
        congrArg (fun t => worldParts (stepExternal i s a (t + 1)))
          (congrArg (fun v : S × A × Nat => v.2.2) same)⟩⟩

/-- **Some law determined part by part admits a course with the step external exactly where its
agent is consistent.** -/
theorem stepExternal_admitted_iff {i : Nat → I} {s : Nat → S} {a : Nat → A} :
    (∃ Q : Process (Parts I S A Nat) Unit, BlanketDetermined Q ∧
        ∀ r (m : Nat → Unit), r = stepExternal i s a → Admits Q r m) ↔
      AgentConsistent i s a :=
  admitted_iff.trans stepExternal_consistent_iff

/-- **The law with the step external, given its functions**: the internal and active parts by
`own` and `policy`, the sensory part the sensory course at the external part's next step, the
external part the step. The internal part moves by the sensory state at its own step, as a
balanced level does. Its world's side reads only the step: the sensory part's next state
is the given course at the next step, the act moving nothing there. It is the open loop at that
course, it admits every sensory course, and the law's content is its agent's side. -/
def stepLaw (own : I → S → A → I) (policy : I → S → A → A) (s : Nat → S) :
    Blanketed I S A Nat where
  nextInternal m o a := own m o a
  nextSensory _ _ t := s (t + 1)
  nextActive m o a := policy m o a
  nextExternal _ _ t := t + 1

/-- **Where the functions give the next internal and active states at every step, the law's course
is the course with the step external.** The converse, functions from `AgentConsistent` alone, needs
a next state at every reading the course never shows and a search over its steps for those it does,
and is not stated. -/
theorem stepLaw_course {i : Nat → I} {s : Nat → S} {a : Nat → A} {own : I → S → A → I}
    {policy : I → S → A → A} (moves : ∀ t, i (t + 1) = own (i t) (s t) (a t))
    (acts : ∀ t, a (t + 1) = policy (i t) (s t) (a t)) :
    ∀ n, (stepLaw own policy s).course (stepExternal i s a 0) n = stepExternal i s a n
  | 0 => rfl
  | n + 1 =>
    (congrArg (stepLaw own policy s).step (stepLaw_course moves acts n)).trans
      (parts_eq (moves n).symm rfl (acts n).symm rfl)

end Along

/-! ### The World's reading -/

section Level

variable {F C R O A : Type}

/-- **The level's half under balance**: in a balanced history, at two steps alike on a condition's
level, the next levels agree exactly where what is given to it at one step plus what is taken from
it at the other is the same with the steps exchanged. Pairwise, with no subtraction. -/
theorem next_level_alike_iff {L : Flow F C} {l : Nat → C → Nat} (history : L.BalancedHistory l)
    {g : C} {j k : Nat} (same : l j g = l k g) :
    l (j + 1) g = l (k + 1) g ↔ L.given j g + L.taken k g = L.given k g + L.taken j g :=
  ⟨fun next => Naturals.add_left_cancel (k := l j g)
    ((Nat.add_assoc (l j g) (L.given j g) (L.taken k g)).symm.trans
      ((congrArg (· + L.taken k g) (history j g).symm).trans
        ((congrArg (fun v => v + L.taken j g + L.taken k g) next).trans
          ((Nat.add_right_comm (l (k + 1) g) (L.taken j g) (L.taken k g)).trans
            ((congrArg (· + L.taken j g) (history k g)).trans
              ((congrArg (fun v => v + L.given k g + L.taken j g) same.symm).trans
                (Nat.add_assoc (l j g) (L.given k g) (L.taken j g)))))))),
   fun net => add_right_cancel (L.taken j g + L.taken k g)
    ((Nat.add_assoc (l (j + 1) g) (L.taken j g) (L.taken k g)).symm.trans
      ((congrArg (· + L.taken k g) (history j g)).trans
        ((Nat.add_assoc (l j g) (L.given j g) (L.taken k g)).trans
          ((congrArg (l j g + ·) net).trans
            ((Nat.add_assoc (l j g) (L.given k g) (L.taken j g)).symm.trans
              ((congrArg (fun v => v + L.given k g + L.taken j g) same).trans
                ((congrArg (· + L.taken j g) (history k g)).symm.trans
                  ((Nat.add_assoc (l (k + 1) g) (L.taken k g) (L.taken j g)).trans
                    (congrArg (l (k + 1) g + ·) (Nat.add_comm (L.taken k g) (L.taken j g)))))))))))⟩

/-- **A formation's level read along one run**: its own level internal, a value of the levels at
each step sensory, an act course active, the step external; the World is `World.of R L W`, balance
a hypothesis where it is used. Where `g`'s own level couples into it, by level or through support
where it bears on itself (`Web.SelfBearing`), the sensory part reads the internal part at the same
step; nothing beyond one run with the step external is shown for it. -/
def levelParts (W : Web R R) (g : R) (value : Nat → (R → Nat) → O) (act : Nat → A) :
    Nat → Parts Nat O A Nat :=
  stepExternal (fun t => W.level t g) (fun t => value t (W.level t)) act

/-- A formation's rows on listed relata: what it takes from and gives to each, as lists. -/
def rowAct (cs : List R) (L : Flow R R) (g : R) (t : Nat) : List Nat × List Nat :=
  (cs.map (L.take t g), cs.map (L.give t g))

/-- **The formation's act**: its rows on listed relata at a step where it takes part, nothing where
it does not, `presence` saying which (`DecidesPresence`). -/
def presentRow (presence : Nat → Bool) (cs : List R) (L : Flow R R) (g : R) (t : Nat) :
    List Nat × List Nat :=
  match presence t with
  | true => rowAct cs L g t
  | false => ([], [])

/-- `presence` decides whether `g` takes part in each step. -/
def DecidesPresence (presence : Nat → Bool) (L : Flow R R) (g : R) : Prop :=
  ∀ t, presence t = true ↔ g ∈ L.present t

/-- **In exchange terms**: along a balanced run, a formation's level and an act course are
consistent exactly where, at any two steps alike on its level, the value and the act, what the
relata present give to it at one step plus what they take from it at the other is the same with the
steps exchanged, and the next acts agree. -/
theorem agentConsistent_iff_exchange {L : Flow R R} {W : Web R R}
    (history : L.BalancedHistory W.level) {g : R} {value : Nat → (R → Nat) → O}
    {act : Nat → A} :
    AgentConsistent (fun t => W.level t g) (fun t => value t (W.level t)) act ↔
      ∀ j k, W.level j g = W.level k g → value j (W.level j) = value k (W.level k) →
        act j = act k → L.given j g + L.taken k g = L.given k g + L.taken j g ∧
          act (j + 1) = act (k + 1) :=
  ⟨fun cons j k sl sv sa =>
    ⟨(next_level_alike_iff history sl).mp (cons j k sl sv sa).1, (cons j k sl sv sa).2⟩,
   fun ex j k sl sv sa =>
    ⟨(next_level_alike_iff history sl).mpr (ex j k sl sv sa).1, (ex j k sl sv sa).2⟩⟩

/-- **The values of what couples into a formation, across steps**: two levels at any two steps
have one value exactly where they admit `g` alike, each at its step, and agree on what couples into
`g` by level. `Web.ValuesThrough` compares values at one step only, and a value carrying the step
meets it (`Web.states_by_reading`), under which every run passes; across steps a value tells two
steps apart only by what couples in. -/
def ValuesAcross (W : Web R C) (obs : R → C → Prop) (g : R) (value : Nat → (C → Nat) → O) :
    Prop :=
  ∀ j k x y, value j x = value k y ↔ (W.Admits x j g ↔ W.Admits y k g) ∧ ∀ c, obs g c → x c = y c

/-- Across steps is at every step. -/
theorem ValuesAcross.through {W : Web R C} {obs : R → C → Prop} {g : R}
    {value : Nat → (C → Nat) → O} (across : ValuesAcross W obs g value) :
    W.ValuesThrough obs g value :=
  fun t x y => across t t x y

/-- **`listed_values`' value gives the values across steps**: whether the levels admit `g` at the
step, decided, and the listed levels; the step enters only through admission. -/
theorem listed_valuesAcross {W : Web R C} {obs : R → C → Prop} {g : R}
    {admits : Nat → (C → Nat) → Bool} (decides : ∀ t x, admits t x = true ↔ W.Admits x t g)
    {cs : List C} (listed : ∀ c, obs g c ↔ c ∈ cs) :
    ValuesAcross W obs g (fun t x => (admits t x, cs.map x)) :=
  fun j k x y =>
    ⟨fun same =>
      match Prod.mk.inj same with
      | ⟨admitted, levels⟩ =>
        ⟨(decides j x).symm.trans
          ((Eq.subst (motive := fun b => admits j x = true ↔ b = true) admitted Iff.rfl).trans
            (decides k y)),
         fun c observed => map_eq_at levels ((listed c).mp observed)⟩,
     fun ⟨admitted, levels⟩ =>
      (congrArg (Prod.mk · (cs.map x))
          (Becoming.bool_eq_of_iff ((decides j x).trans (admitted.trans (decides k y).symm)))).trans
        (congrArg (Prod.mk (admits k y))
          (map_eq_on fun c mem => levels c ((listed c).mpr mem)))⟩

/-- **On the World's records, a formation's level is the internal part of a law determined part by
part, along one balanced run with the step external, exactly where**, at any two steps alike on its
level, alike in admitting it, each at its step, alike on the conditions coupled into it by level and
alike in its act (its rows at the steps `presence` marks), what the relata present give to it at
one step plus what they take from it at the other is the same with the steps exchanged, and its next
acts agree. For a value giving the values across steps, so the statement names no value. Tested only
where these recur. -/
theorem levelParts_admitted_iff {L : Flow R R} {W : Web R R} (history : L.BalancedHistory W.level)
    {g : R} {obs : R → R → Prop} {value : Nat → (R → Nat) → O}
    (across : ValuesAcross W obs g value) (presence : Nat → Bool) (cs : List R) :
    (∃ Q : Process (Parts Nat O (List Nat × List Nat) Nat) Unit, BlanketDetermined Q ∧
        ∀ r (m : Nat → Unit), r = levelParts W g value (presentRow presence cs L g) →
          Admits Q r m) ↔
      ∀ j k, W.level j g = W.level k g →
        (W.Admits (W.level j) j g ↔ W.Admits (W.level k) k g) →
        (∀ c, obs g c → W.level j c = W.level k c) →
        presentRow presence cs L g j = presentRow presence cs L g k →
        L.given j g + L.taken k g = L.given k g + L.taken j g ∧
          presentRow presence cs L g (j + 1) = presentRow presence cs L g (k + 1) :=
  stepExternal_admitted_iff.trans ((agentConsistent_iff_exchange history).trans
    ⟨fun ex j k sl sa so sact => ex j k sl ((across j k _ _).mpr ⟨sa, so⟩) sact,
     fun ex j k sl sv sact =>
      match (across j k _ _).mp sv with
      | ⟨sa, so⟩ => ex j k sl sa so sact⟩)

end Level

/-- Two relata, for the two witnesses below. -/
inductive TwoRelata where
  | g
  | h

/-- `g` is not among the relata `[h]`. -/
theorem TwoRelata.g_not_mem_h : ¬ TwoRelata.g ∈ [TwoRelata.h] :=
  fun mem => match mem with
    | List.Mem.tail _ rest => nomatch rest

/-! ### A drain in three phases: the level is not the internal part -/

namespace PhasedDrain

open ReadsExternal

/-- `h`'s phase at each step: first, second, third, first, … -/
def phase : Nat → Three := Law.orbit ReadsExternal.next .first

/-- `g`'s level by phase: one, nothing after the draw, one after the give. -/
def gLevel : Three → Nat
  | .first => 1
  | .second => 0
  | .third => 1

/-- `h`'s level is its phase, kept by giving to and taking from itself. -/
def hLevel : Three → Nat
  | .first => 0
  | .second => 1
  | .third => 2

def hTakesG : Three → Nat
  | .first => 1
  | .second => 0
  | .third => 0

def hGivesG : Three → Nat
  | .first => 0
  | .second => 1
  | .third => 0

def hTakesH : Three → Nat
  | .first => 0
  | .second => 0
  | .third => 2

def hGivesH : Three → Nat
  | .first => 1
  | .second => 1
  | .third => 0

/-- What each relatum takes: `h` one unit from `g` at its first phase, from itself at its third. -/
def take : Nat → TwoRelata → TwoRelata → Nat
  | t, .h, .g => hTakesG (phase t)
  | t, .h, .h => hTakesH (phase t)
  | _, .g, .g => 0
  | _, .g, .h => 0

/-- What each relatum gives: `h` one unit to `g` at its second phase, to itself at its first and
second. -/
def give : Nat → TwoRelata → TwoRelata → Nat
  | t, .h, .g => hGivesG (phase t)
  | t, .h, .h => hGivesH (phase t)
  | _, .g, .g => 0
  | _, .g, .h => 0

/-- Only `h` takes part, at every step. -/
def flow : Flow TwoRelata TwoRelata := ⟨fun _ => [TwoRelata.h], take, give⟩

def level : Nat → TwoRelata → Nat
  | t, .g => gLevel (phase t)
  | t, .h => hLevel (phase t)

/-- Nothing is required, at need nothing; every relatum active; nothing drawn on. -/
def web : Web TwoRelata TwoRelata :=
  ⟨level, fun _ _ => True, fun _ _ _ => False, fun _ _ _ => 0, fun _ _ _ => False⟩

theorem balance_g :
    ∀ p, gLevel (ReadsExternal.next p) + (hTakesG p + 0) = gLevel p + (hGivesG p + 0)
  | .first => rfl
  | .second => rfl
  | .third => rfl

theorem balance_h :
    ∀ p, hLevel (ReadsExternal.next p) + (hTakesH p + 0) = hLevel p + (hGivesH p + 0)
  | .first => rfl
  | .second => rfl
  | .third => rfl

/-- **The flow balances at every step.** -/
theorem balances : flow.BalancedHistory web.level := fun t c => match c with
  | .g => balance_g (phase t)
  | .h => balance_h (phase t)

/-- **`h` does not couple into `g`**: `g` depends on nothing and observes nothing. -/
theorem uncoupled : ¬ web.CoupledInto (fun _ _ => False) TwoRelata.g TwoRelata.h :=
  fun coupled => match coupled with
    | .inl ⟨_, never⟩ => never
    | .inr never => never

/-- Nothing couples into `g`, so any value giving the values across steps is one value at every
step. -/
theorem one_value {O : Type} {value : Nat → (TwoRelata → Nat) → O}
    (across : ValuesAcross web (fun _ _ => False) TwoRelata.g value) (j k : Nat) :
    value j (web.level j) = value k (web.level k) :=
  (across j k _ _).mpr
    ⟨⟨fun _ _ req => False.elim req, fun _ _ req => False.elim req⟩, fun _ never => False.elim never⟩

/-- The one value gives the values of what couples into `g` across steps. -/
theorem values : ValuesAcross web (fun _ _ => False) TwoRelata.g (fun _ _ => ()) :=
  fun _ _ _ _ => ⟨fun _ => ⟨⟨fun _ _ req => False.elim req, fun _ _ req => False.elim req⟩,
    fun _ never => False.elim never⟩, fun _ => rfl⟩

/-- `g` takes part in no step. -/
def presence : Nat → Bool := fun _ => false

theorem presence_decides : DecidesPresence presence flow TwoRelata.g :=
  fun _ => ⟨fun no => (nomatch no), fun mem => (TwoRelata.g_not_mem_h mem).elim⟩

/-- `g`'s act: nothing, since it takes part in no step. -/
def act : Nat → List Nat × List Nat := presentRow presence [TwoRelata.g, TwoRelata.h] flow TwoRelata.g

/-- **No law determined part by part admits the run read with `g`'s level internal**, for any
value giving the values of what couples into `g` across steps: at steps 2 and 3 its level, its
value and its act agree, and its next levels are one and nothing. -/
theorem not_admitted {O : Type} {value : Nat → (TwoRelata → Nat) → O}
    (across : ValuesAcross web (fun _ _ => False) TwoRelata.g value) :
    ¬ ∃ Q : Process (Parts Nat O (List Nat × List Nat) Nat) Unit, BlanketDetermined Q ∧
        ∀ r (m : Nat → Unit), r = levelParts web TwoRelata.g value act → Admits Q r m :=
  fun admitted =>
    Naturals.succ_ne_zero 0 ((stepExternal_admitted_iff.mp admitted) 2 3 rfl (one_value across 2 3) rfl).1

end PhasedDrain

/-! ### A drain and feed in two phases: the level is the internal part, tested -/

namespace Alternating

/-- `h`'s phase: on, off, on, … -/
def phase : Nat → Bool
  | 0 => true
  | n + 1 => !(phase n)

/-- `g`'s level by phase: one while on, nothing while off. -/
def gLevel : Bool → Nat
  | true => 1
  | false => 0

/-- `h`'s level is its phase, kept by giving to and taking from itself. -/
def hLevel : Bool → Nat
  | true => 0
  | false => 1

def hTakesG : Bool → Nat
  | true => 1
  | false => 0

def hGivesG : Bool → Nat
  | true => 0
  | false => 1

def hTakesH : Bool → Nat
  | true => 0
  | false => 1

def hGivesH : Bool → Nat
  | true => 1
  | false => 0

/-- `h` takes one unit from `g` when on and from itself when off. -/
def take : Nat → TwoRelata → TwoRelata → Nat
  | t, .h, .g => hTakesG (phase t)
  | t, .h, .h => hTakesH (phase t)
  | _, .g, .g => 0
  | _, .g, .h => 0

/-- `h` gives one unit to `g` when off and to itself when on. -/
def give : Nat → TwoRelata → TwoRelata → Nat
  | t, .h, .g => hGivesG (phase t)
  | t, .h, .h => hGivesH (phase t)
  | _, .g, .g => 0
  | _, .g, .h => 0

/-- Only `h` takes part, at every step. -/
def flow : Flow TwoRelata TwoRelata := ⟨fun _ => [TwoRelata.h], take, give⟩

def level : Nat → TwoRelata → Nat
  | t, .g => gLevel (phase t)
  | t, .h => hLevel (phase t)

/-- Nothing is required, at need nothing; every relatum active; nothing drawn on. -/
def web : Web TwoRelata TwoRelata :=
  ⟨level, fun _ _ => True, fun _ _ _ => False, fun _ _ _ => 0, fun _ _ _ => False⟩

theorem balance_g : ∀ p, gLevel (!p) + (hTakesG p + 0) = gLevel p + (hGivesG p + 0)
  | true => rfl
  | false => rfl

theorem balance_h : ∀ p, hLevel (!p) + (hTakesH p + 0) = hLevel p + (hGivesH p + 0)
  | true => rfl
  | false => rfl

/-- **The flow balances at every step.** -/
theorem balances : flow.BalancedHistory web.level := fun t c => match c with
  | .g => balance_g (phase t)
  | .h => balance_h (phase t)

/-- **`h` does not couple into `g`.** -/
theorem uncoupled : ¬ web.CoupledInto (fun _ _ => False) TwoRelata.g TwoRelata.h :=
  fun coupled => match coupled with
    | .inl ⟨_, never⟩ => never
    | .inr never => never

/-- The one value gives the values of what couples into `g` across steps. -/
theorem values : ValuesAcross web (fun _ _ => False) TwoRelata.g (fun _ _ => ()) :=
  fun _ _ _ _ => ⟨fun _ => ⟨⟨fun _ _ req => False.elim req, fun _ _ req => False.elim req⟩,
    fun _ never => False.elim never⟩, fun _ => rfl⟩

/-- `g` takes part in no step. -/
def presence : Nat → Bool := fun _ => false

theorem presence_decides : DecidesPresence presence flow TwoRelata.g :=
  fun _ => ⟨fun no => (nomatch no), fun mem => (TwoRelata.g_not_mem_h mem).elim⟩

/-- `g`'s act: nothing, since it takes part in no step. -/
def act : Nat → List Nat × List Nat := presentRow presence [TwoRelata.g, TwoRelata.h] flow TwoRelata.g

theorem gLevel_inj : ∀ (p q : Bool), gLevel p = gLevel q → p = q
  | true, true, _ => rfl
  | false, false, _ => rfl
  | true, false, same => (Naturals.succ_ne_zero 0 same).elim
  | false, true, same => (Naturals.succ_ne_zero 0 same.symm).elim

/-- **The level recurs**: steps 0 and 2 are alike on it, so the condition is tested. -/
theorem recurs : web.level 0 TwoRelata.g = web.level 2 TwoRelata.g := rfl

/-- **The agent is consistent, for any value**: the next level is fixed by the level, the act is
nothing throughout. -/
theorem agentConsistent {O : Type} (value : Nat → (TwoRelata → Nat) → O) :
    AgentConsistent (fun t => web.level t TwoRelata.g) (fun t => value t (web.level t)) act :=
  fun j k sl _ _ => ⟨congrArg (fun p => gLevel (!p)) (gLevel_inj (phase j) (phase k) sl), rfl⟩

/-- **Some law determined part by part admits the run read with `g`'s level internal**, for any
value, though what drains and feeds it does not couple into it. -/
theorem admitted {O : Type} (value : Nat → (TwoRelata → Nat) → O) :
    ∃ Q : Process (Parts Nat O (List Nat × List Nat) Nat) Unit, BlanketDetermined Q ∧
      ∀ r (m : Nat → Unit), r = levelParts web TwoRelata.g value act → Admits Q r m :=
  stepExternal_admitted_iff.mpr (agentConsistent value)

end Alternating

end BlanketCouplings

end Becoming
