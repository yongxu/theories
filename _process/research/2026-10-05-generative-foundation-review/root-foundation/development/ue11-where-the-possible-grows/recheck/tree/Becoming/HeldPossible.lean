import Becoming.ReachableRanges
import Becoming.Mechanism
import Becoming.Gated
import Becoming.Junctures

/-!
# Where the possible grows: relative to what is held

Along a course of one fixed process nothing is added to the whole possible
(`Run.possible_of_next`), so growth of the possible needs something that changes. Here the
possible is read relative to what is held, on processes and on the root (the grammar), and a rule
changing its own rule and a tower of rules with no top are read as processes.

* **A move adds nothing to the possible under its process.** For any process `Q`, what is possible
  under `Q` from a configuration `Q` reaches is possible from the first
  (`Reaching.Possible.of_reach`). So where something possible under `Q` from `t` is not possible
  from `s`, `Q` does not reach `t` from `s`, and a step from `s` to `t` is not a move of `Q`
  (`Reaching.not_reach_of_grows`, `Reaching.not_step_of_grows`).
* **Keeping widening needs departures without end.** Along a course, where every step of a stretch
  is a move of `Q`, what is possible under `Q` at the stretch's end is possible at its start
  (`Run.possible_of_stretch`). So where the possible under `Q` keeps widening, in 07's form read
  from the course's first step, from every step some bounded stretch is not made of moves of `Q`
  throughout (`Run.departs_of_keepsWidening`), and where every step from some step on is a move of
  `Q` it does not keep widening (`Run.not_keepsWidening_of_within`).
* **The possible with a part held.** For a relation `Same` on configurations, read as a part held
  unchanged, the moves holding it (`Reaching.heldMoves`) give the possible with the part held
  (`Reaching.PossibleHeld`), included in the whole possible (`Reaching.PossibleHeld.possible`).
  Onward's steps within a family and Junctures' steps after which a configuration can still be had
  are instances (`Onward.within_eq_heldMoves`, `Branching.keeping_eq_heldMoves`).
* **On the root.** With `Same` read as the grammar's class, a move holding the part is a
  continuation under it (`«续»`, `Reaching.steps_heldMoves_iff`); what the moves holding it reach
  is the start or the start's line under it (`«相续»`, `Reaching.reach_heldMoves_iff`); and the
  possible with the part held is what the start or its line under the part admits
  (`Reaching.possibleHeld_iff_line`). Holding a weaker part is coarsening (`«粗化»`) read on
  processes (`Reach.heldMoves_mono`). Where `Same` is a class, what the moves holding it reach is
  the same as the start in the part (`Reach.same_of_heldMoves`, from `«线内同类»`).
* **Where it grows.** Where something possible with the part held at the next step is not possible
  so at the present one, the step changes the part (`Run.changes_of_heldGrows`); from the step at
  which the part stays for good, nothing is added to the possible with it held
  (`Run.possibleHeld_of_stays`). It keeps widening only where the part changes without end: from
  every step some bounded stretch does not hold the part throughout
  (`Run.changes_of_heldKeepsWidening`), so it does not keep widening along a course whose steps
  hold the part from some step on (`Run.not_heldKeepsWidening_of_stays`). Where whether each step
  holds the part is decided, a step changing it is located within any stretch across which the
  possible with it held grows (`Run.held_change_located`), and from every step on
  (`Run.held_change_recurs_of_keepsWidening`). Read on the course's moments in the grammar, from
  no moment is the course's line under the part unending (`«不穷»`,
  `Run.not_unending_of_heldKeepsWidening`), and where holding is decided, a line under the part
  begins (`«生»`) after every moment (`Run.begins_of_heldKeepsWidening`). It keeps widening only
  where no list holds the whole possible from the course's start
  (`Run.not_heldKeepsWidening_of_listed`). Endless change of the part with an unlisted whole
  possible does not suffice for keeping widening (`Oscillating.converse_fails`).
* **A rule changing its own rule** (`adaptive F G`, `Becoming.Mechanism`). A step keeps the rule
  exactly where `G` leaves it as it is (`adaptive_keeps_rule_iff`); so along a course the possible
  with the rule held keeps widening only where `G` changes the rule without end
  (`Run.adaptive_rule_changes_of_keepsWidening`; located where rules are decided,
  `Run.adaptive_rule_change_recurs_of_keepsWidening`), while nothing is added to the whole possible
  (`Run.possible_of_next` at `adaptive F G`).
* **Every possibility with some member of a sequence held.** On the root, for every carrier and
  relation: on a sequence of relations growing coarser, where every step of a relation is alike
  under some member, whatever the relation reaches lies on a line under some member
  (`«及在渐粗列之相续»`). So, for any process whose every move holds some member of such a
  sequence, every possibility is possible with some member held, and conversely
  (`Reaching.possible_iff_held_of_sequence`).
* **A tower of rules with no top.** A configuration is a state and a sequence of rules; the move
  `0` changes the state as the rule at height `0` allows, and the move `k + 1` changes the rule at
  height `k` as the rule at height `k + 1` allows, the state and every other rule kept
  (`RuleTower.process`). Every rule is changed by the one above it, and none is the last; the
  scheme (`base`, `up`) is fixed, as the law of any stated process is. The move `a` keeps the
  rules from height `a` up (`RuleTower.step_sameFrom`), so every possibility of the tower is
  possible with the rules from some height up held, and conversely (`RuleTower.possible_iff_held`):
  each is had by changing only the rules below some height. The tower changing every rule at once
  has a possibility needing the whole tower (`Synchronous.tower_law_fails`). Along a course, where
  the possible with the rules from height `n` up held keeps widening, moves above `n` recur from
  every step on, located with no decision of the rules
  (`Run.ruleTower_move_above_recurs_of_keepsWidening`); the moves at most `n` reflect it, so a
  trace ending where it holds started where it held or passes a move above `n` after which it
  holds (`RuleTower.held_origin`, an instance of `Gated.origin`). Where from some step on the rules
  from height `N` up stay, so do the rules from any height `n ≥ N` up (`RuleTower.SameFrom.mono`),
  and from that step nothing is added to the possible with them held (`Run.possibleHeld_of_stays`):
  a top fixed for good stops the growth relative to it. Nothing is added to the whole possible
  (`Run.possible_of_next` at `RuleTower.process base up`).
* **Witnesses.** In `RaisedRule`, along the course raising the rule at every step, the possible
  with the rule held keeps widening, in 07's form read from the course's first step
  (`RaisedRule.held_keeps_widening`), while from every configuration of the course every formation
  is possible (`RaisedRule.whole_every`); the rule changes at every step
  (`RaisedRule.rule_changes`), and the held laws require only that it change without end. In
  `CopyDown`, a tower whose moves copy a rule down one height, the possible with the rules from
  every height up held keeps widening while every formation stays possible; each rule changes once,
  and the change climbs (`CopyDown.held_keeps_widening`, `CopyDown.whole_every`,
  `CopyDown.changes_iff`).

Each law is near-definitional or a witness; no choice principle enters, and runs are built, never
chosen. What is read: growth of the possible is relative to what is held; keeping it growing needs
what is held to change without end; and a tower of rules with no top, read as one process, adds
nothing to its whole possible. What the report does not catch lies in the modelling: discrete
steps; the held part read by a relation on configurations, held move by move (for a class, the same
as holding it as it is at the start); formations compared by name over one type fixed across steps;
the tower's rules a sequence of one type indexed by the natural numbers, each move keeping the rules
from some height up (one rule per move in `RuleTower.process`); the scheme fixed. A change with no
fixed scheme, and a space of rules not given with the carrier, are not stated.
-/

namespace Becoming

open Generative

universe u v w

/-! ## A move adds nothing to the possible under its process -/

section Grows

variable {S : Type u} {A : Type v} {X : Type} {adm : S → X → Prop}

/-- **Where something possible under `Q` from `t` is not possible from `s`, `Q` does not reach `t`
from `s`** (`Reaching.Possible.of_reach`). -/
theorem Reaching.not_reach_of_grows {Q : Process S A} {s t : S} {x : X}
    (grows : Reaching.Possible Q adm t x ∧ ¬ Reaching.Possible Q adm s x) : ¬ Reach Q s t :=
  fun reach => grows.2 (Reaching.Possible.of_reach reach grows.1)

/-- **A step from `s` to `t`, where something possible under `Q` from `t` is not possible from
`s`, is not a move of `Q`.** -/
theorem Reaching.not_step_of_grows {Q : Process S A} {s t : S} {a : A} {x : X}
    (grows : Reaching.Possible Q adm t x ∧ ¬ Reaching.Possible Q adm s x) : ¬ Q.step s a t :=
  fun step => Reaching.not_reach_of_grows grows (Reach.of_step step)

end Grows

/-! ## Keeping widening needs departures without end -/

section Along

variable {S : Type u} {A : Type v} {X : Type} {P : Process S A} {adm : S → X → Prop}

/-- **Along a stretch of moves of `Q`, the possible under `Q` does not grow**: where the `d` steps
of a course from step `N` are moves of `Q`, what is possible under `Q` at step `N + d` is possible
at step `N`. -/
theorem Run.possible_of_stretch (r : Run P) {Q : Process S A} (N : Nat) {x : X} :
    ∀ d, (∀ i, i < d → Q.step (r.state (N + i)) (r.act (N + i)) (r.state (N + i + 1))) →
      Reaching.Possible Q adm (r.state (N + d)) x → Reaching.Possible Q adm (r.state N) x
  | 0, _, possible => possible
  | d + 1, moves, possible => Run.possible_of_stretch r N d
      (fun i before => moves i (Nat.lt_succ_of_lt before))
      (Reaching.Possible.of_reach (Reach.of_step (moves d (Nat.lt_succ_self d))) possible)

/-- **Keeping widening needs departures without end**: where the possible under `Q` keeps widening
along a course, from every step some bounded stretch of the course is not made of moves of `Q`
throughout. -/
theorem Run.departs_of_keepsWidening (r : Run P) {Q : Process S A}
    (keeps : Reaching.KeepsWidening (fun n => Reaching.Possible Q adm (r.state n))) (N : Nat) :
    ∃ d, ¬ ∀ i, i < d → Q.step (r.state (N + i)) (r.act (N + i)) (r.state (N + i + 1)) :=
  match keeps.2 N with
  | ⟨d, _, later, notNow⟩ => ⟨d, fun moves => notNow (r.possible_of_stretch N d moves later)⟩

/-- **Where every step from some step on is a move of `Q`, the possible under `Q` does not keep
widening along the course.** -/
theorem Run.not_keepsWidening_of_within (r : Run P) {Q : Process S A} {N : Nat}
    (within : ∀ n, N ≤ n → Q.step (r.state n) (r.act n) (r.state (n + 1))) :
    ¬ Reaching.KeepsWidening (fun n => Reaching.Possible Q adm (r.state n)) :=
  fun keeps => match r.departs_of_keepsWidening keeps N with
    | ⟨_, notAll⟩ => notAll (fun i _ => within (N + i) (Nat.le_add_right N i))

end Along

/-! ## The possible with a part held -/

section Held

variable {S : Type u} {A : Type v} {X : Type}

/-- **The moves holding a part**: the moves of `P` whose two configurations are related by `Same`,
read as a part held unchanged. -/
def Reaching.heldMoves (P : Process S A) (Same : S → S → Prop) : Process S A :=
  ⟨fun s a t => P.step s a t ∧ Same s t⟩

/-- **The possible with a part held**: what is possible from `s` under the moves of `P` holding the
part read by `Same`. -/
def Reaching.PossibleHeld (P : Process S A) (Same : S → S → Prop) (adm : S → X → Prop) (s : S)
    (x : X) : Prop :=
  Reaching.Possible (Reaching.heldMoves P Same) adm s x

variable {P : Process S A} {Same : S → S → Prop} {adm : S → X → Prop}

/-- What the moves holding a part reach, the process reaches. -/
theorem Reach.of_heldMoves {s t : S} (reach : Reach (Reaching.heldMoves P Same) s t) :
    Reach P s t :=
  Reach.map (P := Reaching.heldMoves P Same) (Q := P) (f := id) (fun _ _ _ held => held.1) reach

/-- What the moves holding a part reach, the moves holding any weaker reading of it reach: holding
a weaker part is coarsening (`«粗化»`) read on processes. -/
theorem Reach.heldMoves_mono {Same' : S → S → Prop} (weaker : ∀ s t, Same s t → Same' s t)
    {s t : S} (reach : Reach (Reaching.heldMoves P Same) s t) :
    Reach (Reaching.heldMoves P Same') s t :=
  Reach.map (P := Reaching.heldMoves P Same) (Q := Reaching.heldMoves P Same') (f := id)
    (fun _ _ _ held => ⟨held.1, weaker _ _ held.2⟩) reach

/-- **The possible with a part held is included in the whole possible.** -/
theorem Reaching.PossibleHeld.possible {s : S} {x : X}
    (held : Reaching.PossibleHeld P Same adm s x) : Reaching.Possible P adm s x :=
  match held with
  | ⟨t, reach, admitted⟩ => ⟨t, Reach.of_heldMoves reach, admitted⟩

/-- Onward's steps within a family are the moves holding both ends in it. -/
theorem Onward.within_eq_heldMoves {K : S → Prop} :
    Onward.within P K = Reaching.heldMoves P (fun s t => K s ∧ K t) := rfl

/-- Junctures' steps after which `s` can still be had are the moves holding that. -/
theorem Branching.keeping_eq_heldMoves {s : S} :
    Branching.keeping P s = Reaching.heldMoves P (fun _ t => Reach P t s) := rfl

/-! ### On the root -/

/-- **A move holding a part is a continuation under it** (`«续»`): one step of the moves holding
the part is one step of the process continuing under `Same`. -/
theorem Reaching.steps_heldMoves_iff {s t : S} :
    Steps (Reaching.heldMoves P Same) s t ↔ «续» (Steps P) Same s t :=
  ⟨fun ⟨a, held⟩ => ⟨⟨a, held.1⟩, held.2⟩, fun ⟨⟨a, step⟩, same⟩ => ⟨a, step, same⟩⟩

/-- **What the moves holding a part reach is the start or the start's line under it** (`«相续»`;
`reach_iff_withinClosure`, `«所闭当且仅当同一或及»`). -/
theorem Reaching.reach_heldMoves_iff {s t : S} :
    Reach (Reaching.heldMoves P Same) s t ↔ s = t ∨ «相续» (Steps P) Same s t :=
  reach_iff_withinClosure.trans («所闭当且仅当同一或及».trans
    ⟨fun reach => reach.imp_right
       («及之单调» (fun _ _ step => Reaching.steps_heldMoves_iff.mp step) _ _),
     fun line => line.imp_right
       («及之单调» (fun _ _ cont => Reaching.steps_heldMoves_iff.mpr cont) _ _)⟩)

/-- **The possible with a part held is what the start admits or what its line under the part
admits.** -/
theorem Reaching.possibleHeld_iff_line {s : S} {x : X} :
    Reaching.PossibleHeld P Same adm s x ↔ adm s x ∨ ∃ t, «相续» (Steps P) Same s t ∧ adm t x :=
  ⟨fun ⟨t, reach, admitted⟩ => match Reaching.reach_heldMoves_iff.mp reach with
     | .inl same => .inl (Eq.subst (motive := fun y => adm y x) same.symm admitted)
     | .inr line => .inr ⟨t, line, admitted⟩,
   fun held => match held with
     | .inl admitted => ⟨s, Reach.refl _ s, admitted⟩
     | .inr ⟨t, line, admitted⟩ => ⟨t, Reaching.reach_heldMoves_iff.mpr (.inr line), admitted⟩⟩

/-- **Where the part is a class, what the moves holding it reach is the same as the start in the
part** (`«线内同类»`): holding it move by move is holding it as it is at the start. -/
theorem Reach.same_of_heldMoves (sameClass : «类» Same) {s t : S}
    (reach : Reach (Reaching.heldMoves P Same) s t) : Same s t :=
  match Reaching.reach_heldMoves_iff.mp reach with
  | .inl same => Eq.subst (motive := fun y => Same s y) same (sameClass.refl s)
  | .inr line => «线内同类» sameClass line

/-! ### Where it grows -/

/-- **Where something possible with a part held at the next step is not possible so at the present
one, the step changes the part.** -/
theorem Run.changes_of_heldGrows (r : Run P) (n : Nat) {x : X}
    (grows : Reaching.PossibleHeld P Same adm (r.state (n + 1)) x ∧
      ¬ Reaching.PossibleHeld P Same adm (r.state n) x) :
    ¬ Same (r.state n) (r.state (n + 1)) :=
  fun same => Reaching.not_step_of_grows (Q := Reaching.heldMoves P Same) (a := r.act n) grows
    ⟨r.step n, same⟩

/-- **From the step at which the part stays for good, nothing is added to the possible with it
held**: where every step from `T` on holds the part, what is possible with it held at step `T + d`
is possible so at step `T`. -/
theorem Run.possibleHeld_of_stays (r : Run P) {T : Nat}
    (stays : ∀ n, T ≤ n → Same (r.state n) (r.state (n + 1))) (d : Nat) {x : X}
    (later : Reaching.PossibleHeld P Same adm (r.state (T + d)) x) :
    Reaching.PossibleHeld P Same adm (r.state T) x :=
  r.possible_of_stretch (Q := Reaching.heldMoves P Same) T d
    (fun i _ => ⟨r.step (T + i), stays (T + i) (Nat.le_add_right T i)⟩) later

/-- **The possible with a part held keeps widening only where the part changes without end**:
from every step some bounded stretch of the course does not hold the part throughout. -/
theorem Run.changes_of_heldKeepsWidening (r : Run P)
    (keeps : Reaching.KeepsWidening (fun n => Reaching.PossibleHeld P Same adm (r.state n)))
    (N : Nat) : ∃ d, ¬ ∀ i, i < d → Same (r.state (N + i)) (r.state (N + i + 1)) :=
  match r.departs_of_keepsWidening (Q := Reaching.heldMoves P Same) keeps N with
  | ⟨d, notAll⟩ => ⟨d, fun stays => notAll (fun i before => ⟨r.step (N + i), stays i before⟩)⟩

/-- **Where the steps hold the part from some step on, the possible with the part held does not
keep widening.** -/
theorem Run.not_heldKeepsWidening_of_stays (r : Run P) {N : Nat}
    (stays : ∀ n, N ≤ n → Same (r.state n) (r.state (n + 1))) :
    ¬ Reaching.KeepsWidening (fun n => Reaching.PossibleHeld P Same adm (r.state n)) :=
  r.not_keepsWidening_of_within (Q := Reaching.heldMoves P Same)
    (fun n later => ⟨r.step n, stays n later⟩)

/-- **Growth of the possible with a part held across a stretch, located.** Where whether each step
of the course holds the part is decided, and something possible with it held at step `N + d` is
not possible so at step `N`, some step from `N` before `N + d` changes the part. -/
theorem Run.held_change_located (r : Run P)
    (decided : ∀ n, Same (r.state n) (r.state (n + 1)) ∨ ¬ Same (r.state n) (r.state (n + 1)))
    {N d : Nat} {x : X} (later : Reaching.PossibleHeld P Same adm (r.state (N + d)) x)
    (notNow : ¬ Reaching.PossibleHeld P Same adm (r.state N) x) :
    ∃ n, N ≤ n ∧ n < N + d ∧ ¬ Same (r.state n) (r.state (n + 1)) :=
  match Amounts.unmarked_or_marked decided N d with
  | .inl found => found
  | .inr all => absurd (r.possible_of_stretch (Q := Reaching.heldMoves P Same) N d
      (fun i before => ⟨r.step (N + i),
        all (N + i) (Nat.le_add_right N i) (Nat.add_lt_add_left before N)⟩) later) notNow

/-- **Where holding is decided, keeping widening needs a step changing the part from every step
on**, located. -/
theorem Run.held_change_recurs_of_keepsWidening (r : Run P)
    (decided : ∀ n, Same (r.state n) (r.state (n + 1)) ∨ ¬ Same (r.state n) (r.state (n + 1)))
    (keeps : Reaching.KeepsWidening (fun n => Reaching.PossibleHeld P Same adm (r.state n)))
    (N : Nat) : ∃ n, N ≤ n ∧ ¬ Same (r.state n) (r.state (n + 1)) :=
  match keeps.2 N with
  | ⟨_, _, later, notNow⟩ => match r.held_change_located decided later notNow with
    | ⟨n, from_, _, changes⟩ => ⟨n, from_, changes⟩

/-- **Along a course, the possible with a part held keeps widening only where no line under the
part, read on the course's moments, is unending** (`«不穷»`, `Steps.buqiong_iff`): from no moment
does the course continue under the part without end. -/
theorem Run.not_unending_of_heldKeepsWidening (r : Run P)
    (keeps : Reaching.KeepsWidening (fun n => Reaching.PossibleHeld P Same adm (r.state n)))
    (N : Nat) : ¬ «不穷» Steps.next (fun n m => Same (r.state n) (r.state m)) N :=
  fun unending => match r.changes_of_heldKeepsWidening keeps N with
    | ⟨_, notAll⟩ => notAll (fun i _ => Steps.buqiong_iff.mp unending i)

/-- **Where holding is decided, keeping widening needs beginnings under the part at arbitrarily
late moments**: read on the course's moments, after every moment `N` a line under the part begins
(`«生»`, `Steps.hasPred_iff`). -/
theorem Run.begins_of_heldKeepsWidening (r : Run P)
    (decided : ∀ n, Same (r.state n) (r.state (n + 1)) ∨ ¬ Same (r.state n) (r.state (n + 1)))
    (keeps : Reaching.KeepsWidening (fun n => Reaching.PossibleHeld P Same adm (r.state n)))
    (N : Nat) : ∃ n, N ≤ n ∧ «生» Steps.next (fun n m => Same (r.state n) (r.state m)) (n + 1) :=
  match r.held_change_recurs_of_keepsWidening decided keeps N with
  | ⟨n, from_, changes⟩ => ⟨n, from_, fun before => changes (Steps.hasPred_iff.mp before)⟩

/-- **The possible with a part held keeps widening only where no list holds the whole possible
from the course's start** (`Reaching.KeepsWidening.not_listed`). -/
theorem Run.not_heldKeepsWidening_of_listed (r : Run P)
    (listed : ∃ ys : List X, ∀ x, Reaching.Possible P adm (r.state 0) x → x ∈ ys) :
    ¬ Reaching.KeepsWidening (fun n => Reaching.PossibleHeld P Same adm (r.state n)) :=
  fun keeps => match listed with
    | ⟨ys, holds⟩ => keeps.not_listed
        ⟨ys, fun n x held =>
          holds x (r.possible_from_start n (Reaching.PossibleHeld.possible held))⟩

end Held

/-! ## A rule changing its own rule -/

section Adaptive

variable {Z : Type u} {R : Type v} {U : Type w} {X : Type}

/-- **A step of a system changing its own rule keeps the rule exactly where `G` leaves it as it
is.** -/
theorem adaptive_keeps_rule_iff {F : R → Z → U → Z} {G : R → Z → R} {s t : Z × R} {u : U}
    (step : (adaptive F G).step s u t) : t.2 = s.2 ↔ G s.2 s.1 = s.2 :=
  ⟨fun same => (congrArg Prod.snd step).symm.trans same,
   fun leaves => (congrArg Prod.snd step).trans leaves⟩

/-- **With the rule held, the possible keeps widening only where the rule changes without end**:
along a course of a system changing its own rule, from every step some bounded stretch is not one
where `G` leaves the rule as it is throughout. -/
theorem Run.adaptive_rule_changes_of_keepsWidening {F : R → Z → U → Z} {G : R → Z → R}
    (r : Run (adaptive F G)) {adm : Z × R → X → Prop}
    (keeps : Reaching.KeepsWidening
      (fun n => Reaching.PossibleHeld (adaptive F G) (fun s t => t.2 = s.2) adm (r.state n)))
    (N : Nat) :
    ∃ d, ¬ ∀ i, i < d → G (r.state (N + i)).2 (r.state (N + i)).1 = (r.state (N + i)).2 :=
  match r.changes_of_heldKeepsWidening keeps N with
  | ⟨d, notAll⟩ => ⟨d, fun leaves => notAll (fun i before =>
      (adaptive_keeps_rule_iff (r.step (N + i))).mpr (leaves i before))⟩

/-- **With rules decided, the possible with the rule held keeps widening only where `G` changes the
rule from every step on**, located: from every step on some step where `G` does not leave the rule
as it is. -/
theorem Run.adaptive_rule_change_recurs_of_keepsWidening [DecidableEq R] {F : R → Z → U → Z}
    {G : R → Z → R} (r : Run (adaptive F G)) {adm : Z × R → X → Prop}
    (keeps : Reaching.KeepsWidening
      (fun n => Reaching.PossibleHeld (adaptive F G) (fun s t => t.2 = s.2) adm (r.state n)))
    (N : Nat) : ∃ n, N ≤ n ∧ ¬ G (r.state n).2 (r.state n).1 = (r.state n).2 :=
  match r.held_change_recurs_of_keepsWidening (Same := fun s t => t.2 = s.2)
      (fun n => match decEq (r.state (n + 1)).2 (r.state n).2 with
        | isTrue same => Or.inl same
        | isFalse changes => Or.inr changes) keeps N with
  | ⟨n, from_, changes⟩ =>
    ⟨n, from_, fun leaves => changes ((adaptive_keeps_rule_iff (r.step n)).mpr leaves)⟩

end Adaptive

/-! ## Every possibility with some member of a sequence held -/

/-- **Reach over a sequence growing coarser lies on a line under some member** (及在渐粗列之相续),
for every carrier and relation: where each member of `E` is included in every later one and every
step of `R` is alike under some member, whatever `R` reaches lies on a line (`«相续»`) under some
member. -/
theorem «及在渐粗列之相续» {α : Type u} {R : «际» α} {E : Nat → «际» α}
    (coarser : ∀ n m, n ≤ m → «则» (E n) (E m)) (each : ∀ x y, R x y → ∃ n, E n x y) :
    ∀ {x y : α}, «及» R x y → ∃ n, «相续» R (E n) x y
  | _, _, .one h => match each _ _ h with
    | ⟨n, e⟩ => ⟨n, .one ⟨h, e⟩⟩
  | _, _, .more h rest => match each _ _ h, «及在渐粗列之相续» coarser each rest with
    | ⟨k, e⟩, ⟨n, line⟩ => ⟨k + n, .more ⟨h, coarser k (k + n) (Nat.le_add_right k n) _ _ e⟩
        («及之单调» («粗化» R (coarser n (k + n) (Nat.le_add_left n k))) _ _ line)⟩

section Sequence

variable {S : Type u} {A : Type v} {X : Type} {P : Process S A} {E : Nat → S → S → Prop}

/-- **What a process reaches it reaches with some member of a sequence held**, wherever each member
of `E` is included in every later one and every move holds some member (`«及在渐粗列之相续»`). -/
theorem Reaching.reach_held_of_sequence (coarser : ∀ n m, n ≤ m → ∀ s t, E n s t → E m s t)
    (each : ∀ s a t, P.step s a t → ∃ n, E n s t) {s t : S} (reach : Reach P s t) :
    ∃ n, Reach (Reaching.heldMoves P (E n)) s t :=
  match «所闭当且仅当同一或及».mp (reach_iff_withinClosure.mp reach) with
  | .inl same => ⟨0, Eq.subst (motive := fun y => Reach (Reaching.heldMoves P (E 0)) s y) same
      (Reach.refl _ s)⟩
  | .inr ji => match «及在渐粗列之相续» (R := Steps P) coarser
      (fun _ _ ⟨a, step⟩ => each _ a _ step) ji with
    | ⟨n, line⟩ => ⟨n, Reaching.reach_heldMoves_iff.mpr (.inr line)⟩

/-- **Every possibility is possible with some member of a sequence held**, and conversely, for any
process whose every move holds some member of a sequence growing coarser. -/
theorem Reaching.possible_iff_held_of_sequence
    (coarser : ∀ n m, n ≤ m → ∀ s t, E n s t → E m s t)
    (each : ∀ s a t, P.step s a t → ∃ n, E n s t) {adm : S → X → Prop} {s : S} {x : X} :
    Reaching.Possible P adm s x ↔ ∃ n, Reaching.PossibleHeld P (E n) adm s x :=
  ⟨fun ⟨t, reach, admitted⟩ => match Reaching.reach_held_of_sequence coarser each reach with
     | ⟨n, held⟩ => ⟨n, t, held, admitted⟩,
   fun ⟨_, held⟩ => Reaching.PossibleHeld.possible held⟩

end Sequence

/-! ## A tower of rules with no top -/

namespace RuleTower

variable {Z : Type u} {R : Type v} {X : Type}

/-- **A tower of rules with no top**: a configuration is a state and a sequence of rules, the rule
at height `k` its `k`-th entry. The move `0` changes the state as the rule at height `0` allows
(`base`), every rule kept; the move `k + 1` changes the rule at height `k` as the rule at height
`k + 1` allows (`up k`), the state and every other rule kept. Every rule is changed by the one
above it, and none is the last. -/
def process (base : R → Z → Z → Prop) (up : Nat → R → R → R → Prop) :
    Process (Z × (Nat → R)) Nat :=
  ⟨fun s a t => match a with
    | 0 => base (s.2 0) s.1 t.1 ∧ ∀ m, t.2 m = s.2 m
    | k + 1 => up k (s.2 (k + 1)) (s.2 k) (t.2 k) ∧ t.1 = s.1 ∧ ∀ m, m ≠ k → t.2 m = s.2 m⟩

/-- **The tower changing every rule at once**: at every move the state changes as the rule at
height `0` allows and the rule at every height `k` as the rule at height `k + 1` allows, all at
once. -/
def synchronous (base : R → Z → Z → Prop) (up : Nat → R → R → R → Prop) :
    Process (Z × (Nat → R)) Unit :=
  ⟨fun s _ t => base (s.2 0) s.1 t.1 ∧ ∀ k, up k (s.2 (k + 1)) (s.2 k) (t.2 k)⟩

/-- The rules from height `n` up the same in two configurations. -/
def SameFrom (n : Nat) (s t : Z × (Nat → R)) : Prop := ∀ m, n ≤ m → t.2 m = s.2 m

/-- The rules the same from height `n` up are the same from any height `n' ≥ n` up. -/
theorem SameFrom.mono {n n' : Nat} {s t : Z × (Nat → R)} (same : SameFrom n s t) (le : n ≤ n') :
    SameFrom n' s t :=
  fun m above => same m (Nat.le_trans le above)

/-- The rules from height `n` up the same is a class (`«类»`). -/
theorem sameFrom_class (n : Nat) : «类» (SameFrom (Z := Z) (R := R) n) :=
  ⟨fun _ _ _ => rfl, fun same m le => (same m le).symm,
   fun first second m le => (second m le).trans (first m le)⟩

variable {base : R → Z → Z → Prop} {up : Nat → R → R → R → Prop}

/-- **Every move keeps the rules from some height up**: the move `a` keeps the rules from height
`a` up. -/
theorem step_sameFrom {s t : Z × (Nat → R)} : ∀ a, (process base up).step s a t → SameFrom a s t
  | 0, step => fun m _ => step.2 m
  | k + 1, step => fun m above => step.2.2 m (fun same =>
      Nat.not_succ_le_self k (Eq.subst (motive := fun j => k + 1 ≤ j) same above))

/-- **Every possibility of the tower is possible with the rules from some height up held**, and
conversely (`Reaching.possible_iff_held_of_sequence`): each is had by changing only the rules
below some height. -/
theorem possible_iff_held {adm : Z × (Nat → R) → X → Prop} {s : Z × (Nat → R)} {x : X} :
    Reaching.Possible (process base up) adm s x ↔
      ∃ n, Reaching.PossibleHeld (process base up) (SameFrom n) adm s x :=
  Reaching.possible_iff_held_of_sequence (P := process base up) (E := fun n => SameFrom n)
    (fun _ _ le _ _ same => SameFrom.mono same le) (fun _ a _ step => ⟨a, step_sameFrom a step⟩)

/-- The moves of the tower at most `n` reflect what is possible with the rules from height `n` up
held. -/
theorem reflected (n : Nat) (x : X) {adm : Z × (Nat → R) → X → Prop} :
    Gated.ReflectedBy (process base up) (fun a => decide (n < a))
      (fun s => Reaching.PossibleHeld (process base up) (SameFrom n) adm s x) :=
  fun _ a _ step ungated held =>
    Reaching.Possible.of_reach
      (Reach.of_step (P := Reaching.heldMoves (process base up) (SameFrom n)) (a := a)
        ⟨step, (step_sameFrom a step).mono (Nat.ge_of_not_lt (of_decide_eq_false ungated))⟩)
      held

/-- **Every origin of the possible held from height `n` up passes a move above `n`**
(`Gated.origin`): a trace ending where `x` is possible with the rules from height `n` up held
started where it was, or passes a move above `n` after which it is. -/
theorem held_origin (n : Nat) (x : X) {adm : Z × (Nat → R) → X → Prop} {s t : Z × (Nat → R)}
    {plan : List Nat} (trace : Trace (process base up) s plan t)
    (held : Reaching.PossibleHeld (process base up) (SameFrom n) adm t x) :
    Reaching.PossibleHeld (process base up) (SameFrom n) adm s x ∨
      ∃ pre a post m m', plan = pre ++ a :: post ∧ Trace (process base up) s pre m ∧
        (process base up).step m a m' ∧ decide (n < a) = true ∧
        Reaching.PossibleHeld (process base up) (SameFrom n) adm m' x ∧
        Trace (process base up) m' post t :=
  Gated.origin (reflected n x) trace held

end RuleTower

section TowerAlong

variable {Z : Type u} {R : Type v} {X : Type} {base : R → Z → Z → Prop}
  {up : Nat → R → R → R → Prop} {adm : Z × (Nat → R) → X → Prop}

/-- **Along a course of the tower, where the possible with the rules from height `n` up held keeps
widening, moves above `n` recur**: from every step on some move changes a rule from height `n` up,
located with no decision of the rules, since each move names the height it changes. -/
theorem Run.ruleTower_move_above_recurs_of_keepsWidening (r : Run (RuleTower.process base up))
    {n : Nat}
    (keeps : Reaching.KeepsWidening (fun k => Reaching.PossibleHeld (RuleTower.process base up)
      (RuleTower.SameFrom n) adm (r.state k))) (N : Nat) :
    ∃ i, N ≤ i ∧ n < r.act i :=
  match r.changes_of_heldKeepsWidening keeps N with
  | ⟨d, notAll⟩ =>
    match Amounts.unmarked_or_marked (P := fun i => r.act i ≤ n)
        (fun i => (Nat.lt_or_ge n (r.act i)).elim (fun above => Or.inr (Nat.not_le_of_gt above))
          Or.inl) N d with
    | .inl ⟨i, from_, _, above⟩ => ⟨i, from_, Nat.gt_of_not_le above⟩
    | .inr below => absurd (fun i before =>
        (RuleTower.step_sameFrom (r.act (N + i)) (r.step (N + i))).mono
          (below (N + i) (Nat.le_add_right N i) (Nat.add_lt_add_left before N))) notAll

end TowerAlong

/-! ## Witnesses -/

/-! ### Open-ended relative to its rule, with the whole possible fixed -/

namespace RaisedRule

/-- A configuration is a rule `n` and a position `x`: a move raises the rule by one, the position
kept, or moves the position to any `x' ≤ n`, the rule kept. -/
def process : Process (Nat × Nat) Unit :=
  ⟨fun s _ t => (t.1 = s.1 + 1 ∧ t.2 = s.2) ∨ (t.1 = s.1 ∧ t.2 ≤ s.1)⟩

/-- A configuration admits its position. -/
def adm (s : Nat × Nat) (y : Nat) : Prop := y = s.2

/-- The rule the same. -/
def Same (s t : Nat × Nat) : Prop := t.1 = s.1

/-- The course raising the rule at every step, from rule `0` at position `0`. -/
def course : Run process := ⟨fun k => (k, 0), fun _ => (), fun _ => Or.inl ⟨rfl, rfl⟩⟩

/-- The rule changes at every step of the course. -/
theorem rule_changes (k : Nat) : ¬ Same (course.state k) (course.state (k + 1)) :=
  fun same => Nat.not_succ_le_self k (Nat.le_of_eq same)

/-- With the rule held, what a configuration reaches has its rule, and its position or one at most
its rule. -/
theorem held_trace : ∀ (as : List Unit) (s t : Nat × Nat),
    Trace (Reaching.heldMoves process Same) s as t → t.1 = s.1 ∧ (t.2 = s.2 ∨ t.2 ≤ s.1)
  | [], _, _, .nil _ => ⟨rfl, Or.inl rfl⟩
  | _ :: as, s, t, .cons held rest => match held_trace as _ t rest with
    | ⟨rule, position⟩ => match held.1 with
      | .inl raise =>
        absurd (Nat.le_of_eq (raise.1.symm.trans held.2)) (Nat.not_succ_le_self s.1)
      | .inr move => ⟨rule.trans held.2, Or.inr (match position with
        | .inl same => Eq.subst (motive := fun y => y ≤ s.1) same.symm move.2
        | .inr le => Eq.subst (motive := fun y => t.2 ≤ y) move.1 le)⟩

/-- **With the rule held, the possible at the course's step `k` is what lies at most `k`.** -/
theorem held_iff (k y : Nat) : Reaching.PossibleHeld process Same adm (course.state k) y ↔ y ≤ k :=
  ⟨fun ⟨t, ⟨as, trace⟩, admitted⟩ => match held_trace as _ t trace with
     | ⟨_, .inl same⟩ =>
       Eq.subst (motive := fun z => z ≤ k) (admitted.trans same).symm (Nat.zero_le k)
     | ⟨_, .inr le⟩ => Eq.subst (motive := fun z => z ≤ k) admitted.symm le,
   fun le => ⟨(k, y), Reach.of_step (a := ()) ⟨Or.inr ⟨rfl, le⟩, rfl⟩, rfl⟩⟩

/-- **With the rule held, the possible keeps widening along the course**, in 07's form read from
the course's first step. -/
theorem held_keeps_widening :
    Reaching.KeepsWidening (fun k => Reaching.PossibleHeld process Same adm (course.state k)) :=
  ⟨fun n d y held => (held_iff (n + d) y).mpr
     (Nat.le_trans ((held_iff n y).mp held) (Nat.le_add_right n d)),
   fun n => ⟨1, n + 1, (held_iff (n + 1) (n + 1)).mpr (Nat.le_refl _),
     fun held => Nat.not_succ_le_self n ((held_iff n (n + 1)).mp held)⟩⟩

/-- Raising the rule `y` times from `(k, 0)` reaches `(k + y, 0)`. -/
theorem reach_raise (k : Nat) : ∀ y, Reach process (k, 0) (k + y, 0)
  | 0 => Reach.refl process (k, 0)
  | y + 1 => (reach_raise k y).trans (Reach.of_step (a := ()) (Or.inl ⟨rfl, rfl⟩))

/-- **From every configuration of the course every formation is possible**: the whole possible
is fixed along the course while the possible with the rule held keeps widening. -/
theorem whole_every (k y : Nat) : Reaching.Possible process adm (course.state k) y :=
  ⟨(k + y, y),
   (reach_raise k y).trans (Reach.of_step (a := ()) (Or.inr ⟨rfl, Nat.le_add_left y k⟩)), rfl⟩

end RaisedRule

/-! ### Endless change of the part does not suffice -/

namespace Oscillating

/-- A configuration is a rule and a position: a move sets the rule to any value, the position
kept, or moves the position to any value at most the rule, the rule kept. -/
def process : Process (Nat × Nat) Unit :=
  ⟨fun s _ t => t.2 = s.2 ∨ (t.1 = s.1 ∧ t.2 ≤ s.1)⟩

/-- A configuration admits its position. -/
def adm (s : Nat × Nat) (y : Nat) : Prop := y = s.2

/-- The rule the same. -/
def Same (s t : Nat × Nat) : Prop := t.1 = s.1

/-- Alternating `false, true, false, …`. -/
def flip : Nat → Bool
  | 0 => false
  | k + 1 => !flip k

/-- The rule alternating `0, 1, 0, 1, …`. -/
def rule (k : Nat) : Nat := cond (flip k) 1 0

/-- The course alternating the rule, the position `0`. -/
def course : Run process := ⟨fun k => (rule k, 0), fun _ => (), fun _ => Or.inl rfl⟩

theorem cond_not_ne : ∀ b : Bool, ¬ cond (!b) 1 0 = cond b 1 0
  | true => fun same => Nat.noConfusion same
  | false => fun same => Nat.noConfusion same

/-- The rule changes at every step. -/
theorem rule_changes (k : Nat) : ¬ Same (course.state k) (course.state (k + 1)) :=
  cond_not_ne (flip k)

/-- From every configuration every formation is possible. -/
theorem every (s : Nat × Nat) (y : Nat) : Reaching.Possible process adm s y :=
  ⟨(y, y), Reach.trans
      (Reach.of_step (P := process) (s := s) (t := (y, s.2)) (a := ()) (Or.inl rfl))
      (Reach.of_step (a := ()) (Or.inr ⟨rfl, Nat.le_refl y⟩)), rfl⟩

/-- With the rule held at `0`, the position stays `0`. -/
theorem held_zero : ∀ {as : List Unit} {s t : Nat × Nat},
    Trace (Reaching.heldMoves process Same) s as t → s.1 = 0 → s.2 = 0 → t.2 = 0
  | [], _, _, .nil _, _, position => position
  | _ :: _, _, _, .cons (m := m) held rest, rule0, position =>
    held_zero rest (held.2.trans rule0) (match held.1 with
      | .inl same => same.trans position
      | .inr move => Nat.eq_zero_of_le_zero (Eq.subst (motive := fun z => m.2 ≤ z) rule0 move.2))

/-- **Endless change of the part with an unlisted whole possible does not suffice for keeping
widening**: the rule changes at every step and no list holds the whole possible, yet the possible
with the rule held does not keep widening; what it opens with the rule at `1` it loses with the
rule back at `0`. -/
theorem converse_fails :
    (∀ k, ¬ Same (course.state k) (course.state (k + 1))) ∧
      (¬ ∃ ys : List Nat, ∀ y, Reaching.Possible process adm (course.state 0) y → y ∈ ys) ∧
      ¬ Reaching.KeepsWidening
        (fun k => Reaching.PossibleHeld process Same adm (course.state k)) :=
  ⟨rule_changes,
   fun ⟨ys, holds⟩ => Reaching.KeepsWidening.not_listed (Q := fun n (y : Nat) => y ≤ n)
      ⟨fun n d _ le => Nat.le_trans le (Nat.le_add_right n d),
       fun n => ⟨1, n + 1, Nat.le_refl _, Nat.not_succ_le_self n⟩⟩
      ⟨ys, fun _ y _ => holds y (every _ y)⟩,
   fun keeps =>
     match keeps.1 1 1 1
         ⟨(1, 1), Reach.of_step (a := ()) ⟨Or.inr ⟨rfl, Nat.le_refl 1⟩, rfl⟩, rfl⟩ with
     | ⟨_, ⟨_, trace⟩, admitted⟩ => Nat.noConfusion (admitted.trans (held_zero trace rfl rfl))⟩

end Oscillating

/-! ### The tower law needs each move to keep the rules from some height up -/

namespace Synchronous

/-- Each rule grows by the one above it, all at once; the state stays. -/
def process : Process (Unit × (Nat → Nat)) Unit :=
  RuleTower.synchronous (fun _ z z' => z' = z) (fun _ above ρ ρ' => ρ' = ρ + above)

/-- A configuration admits its rule at height `0`. -/
def adm (s : Unit × (Nat → Nat)) (y : Nat) : Prop := y = s.2 0

/-- Every rule at `1`. -/
def start : Unit × (Nat → Nat) := ((), fun _ => 1)

/-- From the start, `2` is possible: one move. -/
theorem possible_two : Reaching.Possible process adm start 2 :=
  ⟨((), fun _ => 2), Reach.of_step (a := ()) ⟨rfl, fun _ => rfl⟩, rfl⟩

/-- With the rules from any height up held, `2` is not possible from the start: each move changes
every rule. -/
theorem not_held (n : Nat) : ¬ Reaching.PossibleHeld process (RuleTower.SameFrom n) adm start 2 :=
  fun ⟨_, ⟨as, trace⟩, admitted⟩ => match as, trace with
    | [], .nil _ => Nat.succ_ne_self 1 admitted
    | _ :: _, .cons held _ =>
      Nat.not_succ_le_self (start.2 n)
        (Nat.le_of_eq ((held.1.2 n).symm.trans (held.2 n (Nat.le_refl n))))

/-- **The tower law fails for the tower changing every rule at once**: `2` is possible from the
start, but not with the rules from any height up held. -/
theorem tower_law_fails :
    Reaching.Possible process adm start 2 ∧
      ¬ ∃ n, Reaching.PossibleHeld process (RuleTower.SameFrom n) adm start 2 :=
  ⟨possible_two, fun ⟨n, held⟩ => not_held n held⟩

end Synchronous

/-! ### Open-ended relative to every height of a tower, with the whole possible fixed -/

namespace CopyDown

/-- Each move copies a rule down one height; the state stays. -/
def process : Process (Unit × (Nat → Nat)) Nat :=
  RuleTower.process (fun _ z z' => z' = z) (fun _ above _ new => new = above)

/-- A configuration admits `x` where its rule at height `x` stands above `x + 1`, the value it has
at the start. -/
def adm (s : Unit × (Nat → Nat)) (x : Nat) : Prop := x + 1 < s.2 x

/-- The rule at height `m` at step `k` of the course: `m + 2` below `k`, `m + 1` from `k` up. -/
def rule (k m : Nat) : Nat := if m < k then m + 2 else m + 1

theorem rule_below {k m : Nat} (below : m < k) : rule k m = m + 2 := if_pos below

theorem rule_above {k m : Nat} (above : ¬ m < k) : rule k m = m + 1 := if_neg above

/-- The course copying down to height `k` at step `k`. -/
def course : Run process :=
  ⟨fun k => ((), rule k), fun k => k + 1, fun k =>
    ⟨(rule_below (Nat.lt_succ_self k)).trans
        (rule_above (fun lt => Nat.lt_irrefl k (Nat.lt_trans (Nat.lt_succ_self k) lt))).symm,
     rfl,
     fun m ne => match Nat.lt_or_ge m k with
      | .inl lt => (rule_below (Nat.lt_succ_of_lt lt)).trans (rule_below lt).symm
      | .inr ge =>
        have after : k + 1 ≤ m := Nat.lt_of_le_of_ne ge (fun same => ne same.symm)
        (rule_above (Nat.not_lt_of_le after)).trans (rule_above (Nat.not_lt_of_le ge)).symm⟩⟩

/-- **Each rule changes once, and the change climbs**: the step `k` of the course changes the rule
at height `k` and no other. -/
theorem changes_iff (k m : Nat) :
    ¬ (course.state (k + 1)).2 m = (course.state k).2 m ↔ m = k :=
  ⟨fun changes => match Nat.decEq m k with
     | isTrue same => same
     | isFalse ne => absurd ((course.step k).2.2 m ne) changes,
   fun same => Eq.subst (motive := fun j => ¬ (course.state (k + 1)).2 j = (course.state k).2 j)
     same.symm (fun eq => Nat.succ_ne_self (k + 1) ((rule_below (Nat.lt_succ_self k)).symm.trans
       (eq.trans (rule_above (Nat.lt_irrefl k)))))⟩

/-- The rule at height `x + 1` at any step of the course stands above `x + 1`. -/
theorem rule_next (k x : Nat) : x + 1 < rule k (x + 1) :=
  match Nat.lt_or_ge (x + 1) k with
  | .inl lt => Eq.subst (motive := fun v => x + 1 < v) (rule_below lt).symm
      (Nat.lt_trans (Nat.lt_succ_self (x + 1)) (Nat.lt_succ_self (x + 1 + 1)))
  | .inr ge => Eq.subst (motive := fun v => x + 1 < v) (rule_above (Nat.not_lt_of_le ge)).symm
      (Nat.lt_succ_self (x + 1))

/-- The configuration after the move `x + 1` from the course's step `k`. -/
def copied (k x : Nat) : Unit × (Nat → Nat) :=
  ((), fun m => if m = x then rule k (x + 1) else rule k m)

/-- **With the rules from height `n` up held, the possible at step `k` is what lies below `n` or
below `k`.** -/
theorem held_iff (n k x : Nat) :
    Reaching.PossibleHeld process (RuleTower.SameFrom n) adm (course.state k) x ↔ x < n ∨ x < k :=
  ⟨fun ⟨t, reach, admitted⟩ => match Nat.lt_or_ge x n with
    | .inl below => .inl below
    | .inr notBelow =>
      have same : t.2 x = rule k x :=
        Reach.same_of_heldMoves (RuleTower.sameFrom_class n) reach x notBelow
      .inr (match Nat.lt_or_ge x k with
        | .inl lt => lt
        | .inr ge => absurd (Eq.subst (motive := fun v => x + 1 < v)
            (same.trans (rule_above (Nat.not_lt_of_le ge))) admitted) (Nat.lt_irrefl (x + 1))),
   fun either => match Nat.lt_or_ge x k with
    | .inl lt => ⟨course.state k, Reach.refl _ _,
        Eq.subst (motive := fun v => x + 1 < v) (rule_below lt).symm (Nat.lt_succ_self (x + 1))⟩
    | .inr ge => match either with
      | .inr lt => absurd lt (Nat.not_lt_of_le ge)
      | .inl below =>
        have move : process.step (course.state k) (x + 1) (copied k x) :=
          ⟨if_pos rfl, rfl, fun _ ne => if_neg ne⟩
        ⟨copied k x, Reach.of_step (a := x + 1)
            ⟨move, (RuleTower.step_sameFrom (x + 1) move).mono below⟩,
          Eq.subst (motive := fun v => x + 1 < v)
            (if_pos rfl : (copied k x).2 x = rule k (x + 1)).symm (rule_next k x)⟩⟩

/-- **With the rules from any height `n` up held, the possible keeps widening along the course**,
in 07's form read from the course's first step. -/
theorem held_keeps_widening (n : Nat) :
    Reaching.KeepsWidening
      (fun k => Reaching.PossibleHeld process (RuleTower.SameFrom n) adm (course.state k)) :=
  ⟨fun k d x held => (held_iff n (k + d) x).mpr (match (held_iff n k x).mp held with
      | .inl below => .inl below
      | .inr lt => .inr (Nat.lt_of_lt_of_le lt (Nat.le_add_right k d))),
   fun k => ⟨n + 1, n + k,
     (held_iff n (k + (n + 1)) (n + k)).mpr
       (.inr (Eq.subst (motive := fun v => n + k < v) (Nat.add_assoc k n 1)
         (Eq.subst (motive := fun v => n + k < v + 1) (Nat.add_comm n k)
           (Nat.lt_succ_self (n + k))))),
     fun held => match (held_iff n k (n + k)).mp held with
      | .inl below => Nat.not_lt_of_le (Nat.le_add_right n k) below
      | .inr lt => Nat.not_lt_of_le (Nat.le_add_left k n) lt⟩⟩

/-- **From every configuration of the course every formation is possible**: the whole possible is
fixed while the possible held from every height keeps widening. -/
theorem whole_every (k x : Nat) : Reaching.Possible process adm (course.state k) x :=
  Reaching.PossibleHeld.possible ((held_iff (x + 1) k x).mpr (.inl (Nat.lt_succ_self x)))

end CopyDown

end Becoming
