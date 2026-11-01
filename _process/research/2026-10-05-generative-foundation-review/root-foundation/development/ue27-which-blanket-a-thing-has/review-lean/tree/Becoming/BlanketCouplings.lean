import Becoming.Blanket
import Becoming.Histories
import Becoming.IdentificationRuns

/-!
# A formation's couplings as its blanket, and when a blanket constrains

AI-written, 1 November 2026 (board item UE27). `Blanket` states the principle's Markov blanket as
a coupling structure, a determined law on four parts, and joins it to the World at one witness
(`ThresholdDrain.blanket_iff_through`). Its header leaves out which blanket a thing has, and its
record leaves open a World formation in general as the agent of a blanketed law. This module
answers both, in the pure core.

* **A formation's couplings as its blanket.** For any web, any formation `g` whose couplings
  `obs` give the values of what couples into it (`Web.ValuesThrough`), any model `update`, any
  policy and any environment `env`, which may read the formation's act, the coupling law
  (`couplingLaw`) is blanketed. Its sensory part's next state is the value of what couples into
  `g` at the step. Its sensory course is the formation's own course through its couplings under
  the course's own level history (`sensory_course`). Two of its courses from one agent are alike
  on the blanket before `n + 2` exactly where their level histories are alike through `g`'s
  couplings up to `n` (`blanket_iff_through`). So its internal course tells apart only what the
  couplings tell apart (`internal_through_couplings`), and where the act does not move the levels
  every reading of the internal course is a selection through them (`selectsThrough`). Where
  admission at `g` is decided and the conditions coupled in by level are listed, the values
  exist (`Web.listed_values`); a World's web is a web (`World.web`), so this covers every such
  World formation. `ThresholdDrain`'s join is the case of its witness's web, with the external
  part a supply in place of a step and a level history.
* **The law a family shows, part by part.** A part of the next configuration depends only on a
  reading (`PartDependsOnlyOn`) where configurations agreeing under one map go, under one move,
  to configurations agreeing under another. `Mechanism.DependsOnlyOn` is the case where the
  second map is the identity, `GoAlike` the case of one map, and `Determined` the case where
  both are the identity. The law a family shows has such a part exactly where the family is
  consistent under the two maps (`shownBy_partDependsOnlyOn_iff`). A law determined part by part
  (`BlanketDetermined`) is two cases, one for the agent and one for the world. A family is
  admitted by such a law exactly where it is consistent part by part (`admitted_iff`), such a law
  is determined (`BlanketDetermined.determined`), and the courses of every blanketed law form a
  family consistent part by part (`Blanketed.courses_consistent`).
* **When the existence of a blanket constrains.** With parts that may read the step, every
  family of courses has a blanket: its clocked reading is the course of a blanketed law
  (`ofFamily_course`), consistent part by part though the family need not be consistent
  (`clocked_witness`). With parts read off configurations by a map chosen after the family, a
  constant map always gives one (`const_consistent`), an injective map only where the family is
  consistent (`injective_consistent`), and the whole-configuration map exactly there
  (`inner_iff`), that is where the law the family shows is determined (`shownBy_determined_iff`).
  With a map fixed apart from the family, on a law the same at every step, one run can refute it
  (`ReadsExternal.not_consistent`, `ReadsExternal.not_blanketed`), while the whole-configuration
  map reads the same run as a blanketed course (`ReadsExternal.inner_consistent`).
  `HexagramSequences.runsOrder_reads` makes the same kind of refutation for a line-by-line
  reading of an autonomous law.

Modelling choices: discrete synchronous steps; determined laws, as `Blanketed` is; the four parts
of types in `Type`; a law the same at every step, read by one map at every step; the blanket as
sparse coupling, not conditional independence of a stationary density (`BlanketWeights` joins
the two where it can); in the join, the values of what couples in given by `Web.ValuesThrough`.
Which map a thing's partition is read by is not derived: the join takes the formation's
couplings, given by the web. No `simp`, `omega` or generated injectivity equations, which bring
`propext`; parts and pairs are compared by matching and `congrArg`. A leaf importing `Blanket`,
`Histories` and `IdentificationRuns`.
-/

namespace Becoming

namespace BlanketCouplings

open Generative Blanket

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

/-- The agent's next state: the internal and active parts. -/
def agentNext (x : Parts I S A E) : I × A := (x.internal, x.active)

/-- What the world's next state reads: the sensory, active and external parts. -/
def worldReads (x : Parts I S A E) : S × A × E := (x.sensory, x.active, x.external)

/-- The world's next state: the sensory and external parts. -/
def worldNext (x : Parts I S A E) : S × E := (x.sensory, x.external)

end Parts

/-! ## The law a family shows, part by part -/

section Part

variable {S M K K' : Type}

/-- **A part of the next configuration depending only on a reading**: wherever two configurations
agree under `π`, one move takes them to configurations agreeing under `ρ`. `DependsOnlyOn P π` is
the case where `ρ` is the identity, `GoAlike P π` the case `ρ = π`, and `Determined P` the case
where both are the identity. -/
def PartDependsOnlyOn (P : Process S M) (π : S → K) (ρ : S → K') : Prop :=
  ∀ s s' a u u', π s = π s' → P.step s a u → P.step s' a u' → ρ u = ρ u'

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

/-- **A law determined part by part**: under one move, the internal and active parts of the next
configuration depend only on the internal, sensory and active parts, and the sensory and external
parts only on the sensory, active and external parts. Moves are kept, as in `Determined`. -/
def BlanketDetermined (P : Process (Parts I S A E) M) : Prop :=
  PartDependsOnlyOn P agentReads agentNext ∧ PartDependsOnlyOn P worldReads worldNext

/-- **A family consistent part by part**: consistent under the agent's two readings and under the
world's. -/
def BlanketConsistentFamily (H : (Nat → Parts I S A E) → (Nat → M) → Prop) : Prop :=
  PartConsistentFamily H agentReads agentNext ∧ PartConsistentFamily H worldReads worldNext

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
    have agent : agentNext y = agentNext y' := det.1 x x m y y' rfl step step'
    have world : worldNext y = worldNext y' := det.2 x x m y y' rfl step step'
    parts_eq (congrArg Prod.fst agent) (congrArg Prod.fst world) (congrArg Prod.snd agent)
      (congrArg Prod.snd world)

/-- **A blanketed law, read as a process with the trivial move, is determined part by part.** -/
theorem Blanketed.blanketDetermined (b : Blanketed I S A E) :
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
at two steps agree on the agent's next state at the steps after, and likewise on the world's
side. -/
theorem Blanketed.step_alike (b : Blanketed I S A E) {x y : Parts I S A E} {n n' : Nat} :
    (agentReads (b.course x n) = agentReads (b.course y n') →
        agentNext (b.course x (n + 1)) = agentNext (b.course y (n' + 1))) ∧
      (worldReads (b.course x n) = worldReads (b.course y n') →
        worldNext (b.course x (n + 1)) = worldNext (b.course y (n' + 1))) :=
  ⟨fun same => (Blanketed.blanketDetermined b).1 _ _ () _ _ same rfl rfl,
   fun same => (Blanketed.blanketDetermined b).2 _ _ () _ _ same rfl rfl⟩

/-- **The courses of a blanketed law form a family consistent part by part.** The converse, a
blanketed law for every family consistent part by part, needs a next state chosen at every
reading the family never shows, and is not stated. -/
theorem Blanketed.courses_consistent (b : Blanketed I S A E) :
    BlanketConsistentFamily
      (fun (h : Nat → Parts I S A E) (_ : Nat → Unit) => ∃ x, ∀ n, h n = b.course x n) :=
  ⟨fun _ _ _ _ i j ⟨_, on⟩ ⟨_, on'⟩ same _ =>
    (congrArg agentNext (on (i + 1))).trans
      (((Blanketed.step_alike b).1
          ((congrArg agentReads (on i)).symm.trans (same.trans (congrArg agentReads (on' j))))).trans
        (congrArg agentNext (on' (j + 1))).symm),
   fun _ _ _ _ i j ⟨_, on⟩ ⟨_, on'⟩ same _ =>
    (congrArg worldNext (on (i + 1))).trans
      (((Blanketed.step_alike b).2
          ((congrArg worldReads (on i)).symm.trans (same.trans (congrArg worldReads (on' j))))).trans
        (congrArg worldNext (on' (j + 1))).symm)⟩

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
every step up to `n + 1`. -/
theorem internal_through_couplings (values : W.ValuesThrough obs g value) (m : M) (o : O) (a : A)
    (x x' : X) (n : Nat)
    (through : W.AlikeThroughUpTo obs g (ownLevels update policy value lev env m o a x)
      (ownLevels update policy value lev env m o a x') n) :
    ∀ k, k ≤ n + 1 →
      ((couplingLaw update policy value lev env).course (startAt m o a x) k).internal =
        ((couplingLaw update policy value lev env).course (startAt m o a x') k).internal :=
  fun k le =>
    (couplingLaw update policy value lev env).internal_through_blanket (x := startAt m o a x)
      (y := startAt m o a x') rfl k
      fun j lt => (blanket_iff_through update policy value lev env values m o a x x' n).mpr through j
        (Nat.lt_of_lt_of_le lt (Nat.le_succ_of_le le))

/-- A level history's levels at a step. -/
def levelsAt (t : Nat) (l : Nat → C → Nat) : C → Nat := l t

/-- An environment the formation's act does not move: the level history stays. -/
def unmoved (_ : O) (_ : A) (_ : Nat) (l : Nat → C → Nat) : Nat → C → Nat := l

/-- The open loop: the environment state a level history, which the formation's act does not
move. -/
def openLaw : Blanketed M O A (Nat × (Nat → C → Nat)) :=
  couplingLaw update policy value levelsAt unmoved

theorem open_external (m : M) (o : O) (a : A) (l : Nat → C → Nat) :
    ∀ n, ((openLaw update policy value).course (startAt m o a l) n).external = (n, l)
  | 0 => rfl
  | n + 1 => congrArg (fun e : Nat × (Nat → C → Nat) => (e.1 + 1, e.2)) (open_external m o a l n)

/-- In the open loop a course's own level history is the given one. -/
theorem open_levels (m : M) (o : O) (a : A) (l : Nat → C → Nat) (n : Nat) :
    ownLevels update policy value levelsAt unmoved m o a l n = l n :=
  congrArg (fun e : Nat × (Nat → C → Nat) => e.2 n) (open_external update policy value m o a l n)

/-- **Every reading of its internal course is a selection through the formation's couplings**, in
the open loop: whatever the model and the policy, a claim about level histories that reads the
internal course up to `n + 1` is a selection through `g`'s couplings up to `n`. -/
theorem selectsThrough (values : W.ValuesThrough obs g value) (m : M) (o : O) (a : A) (n : Nat)
    (select : (Nat → M) → Prop)
    (reads : ∀ f f' : Nat → M, (∀ k, k ≤ n + 1 → f k = f' k) → (select f ↔ select f')) :
    W.SelectsThrough obs g n
      (fun l => select fun k => ((openLaw update policy value).course (startAt m o a l) k).internal) :=
  fun l l' through =>
    reads _ _
      (internal_through_couplings update policy value levelsAt unmoved values
        m o a l l' n fun s le =>
          (Web.alikeThrough_iff values).mpr
            ((congrArg (value s) (open_levels update policy value m o a l s)).trans
              (((Web.alikeThrough_iff values).mp (through s le)).trans
                (congrArg (value s) (open_levels update policy value m o a l' s)).symm)))

end Couplings

/-! ## When the existence of a blanket constrains -/

section Clocked

variable {α ρ : Type}

/-- **A clocked reading of a family of courses**: the internal part is a course's present value,
the sensory part its next, the external part which course and the step; the sensory part's next
state is the course's value two steps on. -/
def ofFamily (x : ρ → Nat → α) : Blanketed α α Unit (ρ × Nat) where
  nextInternal _ s _ := s
  nextSensory _ _ e := x e.1 (e.2 + 2)
  nextActive _ _ _ := ()
  nextExternal _ _ e := (e.1, e.2 + 1)

/-- **Every family's clocked reading is the course of a blanketed law.** -/
theorem ofFamily_course (x : ρ → Nat → α) (r : ρ) :
    ∀ n, (ofFamily x).course ⟨x r 0, x r 1, (), (r, 0)⟩ n = ⟨x r n, x r (n + 1), (), (r, n)⟩
  | 0 => rfl
  | n + 1 => congrArg (ofFamily x).step (ofFamily_course x r n)

/-- **Every family's clocked reading is consistent part by part.** -/
theorem clocked_consistent (x : ρ → Nat → α) :
    BlanketConsistentFamily (fun (h : Nat → Parts α α Unit (ρ × Nat)) (_ : Nat → Unit) =>
      ∃ r, ∀ n, h n = ⟨x r n, x r (n + 1), (), (r, n)⟩) :=
  (Blanketed.courses_consistent (ofFamily x)).mono fun _ _ ⟨r, on⟩ =>
    ⟨_, fun n => (on n).trans (ofFamily_course x r n).symm⟩

/-- Two courses from one value that part at their first step. -/
def parting (r : Bool) : Nat → Bool
  | 0 => false
  | _ + 1 => r

/-- **The clocked reading forbids nothing**: a family of two courses from one value parting at
their first step is not consistent, and its clocked reading is consistent part by part. -/
theorem clocked_witness :
    ¬ ConsistentFamily (fun (h : Nat → Bool) (_ : Nat → Unit) => ∃ r, ∀ n, h n = parting r n) ∧
      BlanketConsistentFamily (fun (h : Nat → Parts Bool Bool Unit (Bool × Nat)) (_ : Nat → Unit) =>
        ∃ r, ∀ n, h n = ⟨parting r n, parting r (n + 1), (), (r, n)⟩) :=
  ⟨fun cons => Bool.noConfusion (show false = true from
      cons (parting false) (fun _ => ()) (parting true) (fun _ => ()) 0 0 ⟨false, fun _ => rfl⟩
        ⟨true, fun _ => rfl⟩ rfl rfl),
   clocked_consistent parting⟩

end Clocked

section Readings

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
    have agent : agentNext (π (h (i + 1))) = agentNext (π (h' (j + 1))) :=
      cons.1 _ m _ m' i j read read' (congrArg agentReads at_i) same'
    have world : worldNext (π (h (i + 1))) = worldNext (π (h' (j + 1))) :=
      cons.2 _ m _ m' i j read read' (congrArg worldReads at_i) same'
    inj _ _ (parts_eq (congrArg Prod.fst agent) (congrArg Prod.fst world) (congrArg Prod.snd agent)
      (congrArg Prod.snd world))

/-- The whole-configuration reading: the configuration as the internal part, the other parts
`Unit`. -/
def inner (x : X) : Parts X Unit Unit Unit := ⟨x, (), (), ()⟩

/-- **Under the whole-configuration reading a family is consistent part by part exactly where it is
consistent**, so exactly where the law it shows is determined (`shownBy_determined_iff`). -/
theorem inner_iff {H : (Nat → X) → (Nat → M) → Prop} :
    BlanketConsistentFamily (readFamily inner H) ↔ ConsistentFamily H :=
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

end Readings

/-! ### A reading fixed apart from the course refutes a blanket on one run

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

/-- Its internal course: false, true, false, false, true. -/
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
    not_consistent ((Blanketed.courses_consistent b).mono fun _ _ held =>
      ⟨x, fun n => (congrArg (fun f : Nat → Parts Bool Unit Unit Three => f n) held).trans (on n).symm⟩)

/-- **Under the whole-configuration reading the same run is consistent part by part**: its run is
an orbit. -/
theorem inner_consistent :
    BlanketConsistentFamily
      (readFamily inner (fun (h : Nat → Parts Bool Unit Unit Three) (_ : Nat → Unit) => h = run)) :=
  inner_iff.mpr fun h _ h' _ _ _ (held : h = run) (held' : h' = run) same _ =>
    match h, h', held, held', same with
    | _, _, rfl, rfl, same => congrArg step same

end ReadsExternal

end BlanketCouplings

end Becoming
