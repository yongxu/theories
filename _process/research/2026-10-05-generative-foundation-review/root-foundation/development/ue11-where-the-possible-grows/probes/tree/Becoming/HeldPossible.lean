import Becoming.ReachableRanges
import Becoming.Mechanism

/-!
# Where the possible grows: relative to what is held

Along a course of one fixed process nothing is added to the whole possible
(`Run.possible_of_next`), so growth of the possible needs something that changes. Here the
possible is read relative to a part held, and a rule changing its own rule and a tower of rules
with no top level are read as processes.

* **A move adds nothing to the possible under its process.** For any processes `P` and `Q` on one
  configuration type, what is possible under `Q` from a configuration `Q` reaches is possible from
  the first (`Reaching.Possible.of_reach`). So where the possible under `Q` grows from one
  configuration to another, `Q` does not reach the second from the first, and a step across which
  it grows is not a move of `Q` (`Reaching.not_reach_of_grows`, `Reaching.not_step_of_grows`).
* **Keeping widening needs departures without end.** Along a course of `P`, where every step of a
  stretch is a move of `Q`, what is possible under `Q` at the stretch's end is possible at its
  start (`Run.possible_of_stretch`); so where every step from some step on is a move of `Q`, the
  possible under `Q` does not keep widening in 07's form (`Run.not_keepsWidening_of_within`).
  Where it keeps widening, after every step some bounded stretch is not made of moves of `Q`
  throughout (`Run.departs_of_keepsWidening`). The law is a negation: locating the departure would
  need deciding the moves.
* **The possible with a part held.** For a relation `Same` on configurations, read as a part held
  unchanged, the moves of `P` keeping it (`keeping P Same`) give the possible with the part held
  (`Reaching.PossibleHeld`), included in the whole possible (`Reaching.PossibleHeld.possible`).
  Along a course it grows across a step only where the step changes the part
  (`Run.changes_of_heldGrows`). It keeps widening only where the part changes without end: after
  every step some bounded stretch does not keep the part throughout
  (`Run.changes_of_heldKeepsWidening`), so it keeps widening nowhere along a course whose steps
  keep the part from some step on (`Run.not_heldKeepsWidening_of_stays`). And it keeps widening
  only where no list holds the whole possible from the course's start
  (`Run.not_heldKeepsWidening_of_listed`).
* **A rule changing its own rule** (`adaptive F G`, `Becoming.Mechanism`). A step keeps the rule
  exactly where `G` leaves it as it is (`adaptive_keeps_rule_iff`); so along a course the possible
  with the rule held keeps widening only where `G` changes the rule without end
  (`Run.adaptive_rule_changes_of_keepsWidening`), while nothing is added to the whole possible
  (`Run.possible_of_next` at `adaptive F G`).
* **A tower of rules with no top level.** On a state and a sequence of levels, a move changes the
  state as the level `0` allows, or changes the level `k` as the level `k + 1` allows, the state
  and every other level kept (`RuleTower.process`): every level is changed by the one above it,
  and none is the last. The move `a` keeps the levels from `a` up (`RuleTower.step_sameFrom`), so
  what the tower reaches it reaches with the levels from some height up held
  (`RuleTower.trace_held`), and every possibility of the tower is possible with the levels from
  some height up held (`RuleTower.possible_iff_held`): no single possibility needs the tower to
  have no top. Along a course, where from some step on the levels from `N` up stay, the possible
  with the levels from any `n ≥ N` up held keeps widening nowhere
  (`Run.ruleTower_not_keepsWidening_of_top`); nothing is added to the whole possible
  (`Run.possible_of_next` at `RuleTower.process`).
* **Open-ended relative to its rule, with the whole possible fixed** (`Climbing`). A configuration
  is a rule `n` and a position `x`; a move raises the rule by one or moves the position to any
  `x' ≤ n`; `(n, x)` admits `x`. Along the course raising the rule at every step, the possible
  with the rule held at step `k` is what lies at most `k` (`Climbing.held_iff`), so it keeps
  widening in 07's form (`Climbing.held_keeps_widening`), while from every configuration of the
  course every formation is possible (`Climbing.whole_every`). The rule changes at every step
  (`Climbing.rule_changes`), as the held laws require.

Each law is near-definitional or a witness; no choice principle enters, and runs are built, never
chosen. What is read: growth of the possible is relative to what is held; keeping it growing needs
the held part to keep changing; and a law of change at every level, read as one process, adds
nothing to its whole possible. What the report does not catch lies in the modelling: discrete
steps; the held part read by a relation on configurations; formations compared by name over one
type fixed across steps; the tower's levels a sequence of one type indexed by the natural
numbers, one level changed per move, and its scheme (`base`, `up`) fixed, as the law of any stated
process is. A space of rules not given with the carrier is not stated, and neither is whether
endless change of the held part with an unlisted whole possible suffices for keeping widening.
-/

namespace Becoming

open Generative

universe u v w

/-! ## A move adds nothing to the possible under its process -/

section Grows

variable {S : Type u} {A : Type v} {X : Type} {adm : S → X → Prop}

/-- **Where the possible under `Q` grows from one configuration to another, `Q` does not reach the
second from the first** (`Reaching.Possible.of_reach`). -/
theorem Reaching.not_reach_of_grows {Q : Process S A} {s t : S} {x : X}
    (grows : Reaching.Possible Q adm t x ∧ ¬ Reaching.Possible Q adm s x) : ¬ Reach Q s t :=
  fun reach => grows.2 (Reaching.Possible.of_reach reach grows.1)

/-- **A step across which the possible under `Q` grows is not a move of `Q`.** -/
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
along a course, after every step some bounded stretch of the course is not made of moves of `Q`
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

/-- **The moves keeping a part**: the moves of `P` whose two configurations are the same in the
part, read by `Same`. -/
def keeping (P : Process S A) (Same : S → S → Prop) : Process S A :=
  ⟨fun s a t => P.step s a t ∧ Same s t⟩

/-- **The possible with a part held**: what is possible from `s` under the moves of `P` keeping the
part read by `Same`. -/
def Reaching.PossibleHeld (P : Process S A) (Same : S → S → Prop) (adm : S → X → Prop) (s : S)
    (x : X) : Prop :=
  Reaching.Possible (keeping P Same) adm s x

variable {P : Process S A} {Same : S → S → Prop} {adm : S → X → Prop}

/-- What the moves keeping a part reach, the process reaches. -/
theorem Reach.of_keeping {s t : S} (reach : Reach (keeping P Same) s t) : Reach P s t :=
  Reach.map (P := keeping P Same) (Q := P) (f := id) (fun _ _ _ kept => kept.1) reach

/-- What the moves keeping a part reach, the moves keeping any weaker reading of it reach. -/
theorem Reach.keeping_mono {Same' : S → S → Prop} (weaker : ∀ s t, Same s t → Same' s t)
    {s t : S} (reach : Reach (keeping P Same) s t) : Reach (keeping P Same') s t :=
  Reach.map (P := keeping P Same) (Q := keeping P Same') (f := id)
    (fun _ _ _ kept => ⟨kept.1, weaker _ _ kept.2⟩) reach

/-- **The possible with a part held is included in the whole possible.** -/
theorem Reaching.PossibleHeld.possible {s : S} {x : X}
    (held : Reaching.PossibleHeld P Same adm s x) : Reaching.Possible P adm s x :=
  match held with
  | ⟨t, reach, admitted⟩ => ⟨t, Reach.of_keeping reach, admitted⟩

/-- **The possible with a part held grows across a step only where the step changes the part.** -/
theorem Run.changes_of_heldGrows (r : Run P) (n : Nat) {x : X}
    (grows : Reaching.PossibleHeld P Same adm (r.state (n + 1)) x ∧
      ¬ Reaching.PossibleHeld P Same adm (r.state n) x) :
    ¬ Same (r.state n) (r.state (n + 1)) :=
  fun same => Reaching.not_step_of_grows (Q := keeping P Same) (a := r.act n) grows
    ⟨r.step n, same⟩

/-- **The possible with a part held keeps widening only where the part changes without end**:
after every step some bounded stretch of the course does not keep the part throughout. -/
theorem Run.changes_of_heldKeepsWidening (r : Run P)
    (keeps : Reaching.KeepsWidening (fun n => Reaching.PossibleHeld P Same adm (r.state n)))
    (N : Nat) : ∃ d, ¬ ∀ i, i < d → Same (r.state (N + i)) (r.state (N + i + 1)) :=
  match r.departs_of_keepsWidening (Q := keeping P Same) keeps N with
  | ⟨d, notAll⟩ => ⟨d, fun stays => notAll (fun i before => ⟨r.step (N + i), stays i before⟩)⟩

/-- **Where the steps keep the part from some step on, the possible with the part held does not
keep widening.** -/
theorem Run.not_heldKeepsWidening_of_stays (r : Run P) {N : Nat}
    (stays : ∀ n, N ≤ n → Same (r.state n) (r.state (n + 1))) :
    ¬ Reaching.KeepsWidening (fun n => Reaching.PossibleHeld P Same adm (r.state n)) :=
  r.not_keepsWidening_of_within (Q := keeping P Same) (fun n later => ⟨r.step n, stays n later⟩)

/-- **The possible with a part held keeps widening only where no list holds the whole possible
from the course's start** (`Reaching.KeepsWidening.not_listed`). -/
theorem Run.not_heldKeepsWidening_of_listed (r : Run P)
    (listed : ∃ ys : List X, ∀ x, Reaching.Possible P adm (r.state 0) x → x ∈ ys) :
    ¬ Reaching.KeepsWidening (fun n => Reaching.PossibleHeld P Same adm (r.state n)) :=
  fun keeps => match listed with
    | ⟨ys, holds⟩ => keeps.not_listed
        ⟨ys, fun n x held => holds x (r.possible_from_start n (Reaching.PossibleHeld.possible held))⟩

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
along a course of a system changing its own rule, after every step some bounded stretch is not
one where `G` leaves the rule as it is throughout. -/
theorem Run.adaptive_rule_changes_of_keepsWidening {F : R → Z → U → Z} {G : R → Z → R}
    (r : Run (adaptive F G)) {adm : Z × R → X → Prop}
    (keeps : Reaching.KeepsWidening
      (fun n => Reaching.PossibleHeld (adaptive F G) (fun s t => t.2 = s.2) adm (r.state n)))
    (N : Nat) :
    ∃ d, ¬ ∀ i, i < d → G (r.state (N + i)).2 (r.state (N + i)).1 = (r.state (N + i)).2 :=
  match r.changes_of_heldKeepsWidening keeps N with
  | ⟨d, notAll⟩ => ⟨d, fun leaves => notAll (fun i before =>
      (adaptive_keeps_rule_iff (r.step (N + i))).mpr (leaves i before))⟩

end Adaptive

/-! ## A tower of rules with no top level -/

namespace RuleTower

variable {Z : Type u} {R : Type v} {X : Type}

/-- **A tower of rules with no top level**: a configuration is a state and a sequence of levels.
The move `0` changes the state as the level `0` allows (`base`), every level kept; the move
`k + 1` changes the level `k` as the level `k + 1` allows (`up k`), the state and every other
level kept. Every level is changed by the one above it, and none is the last. -/
def process (base : R → Z → Z → Prop) (up : Nat → R → R → R → Prop) :
    Process (Z × (Nat → R)) Nat :=
  ⟨fun s a t => match a with
    | 0 => base (s.2 0) s.1 t.1 ∧ ∀ m, t.2 m = s.2 m
    | k + 1 => up k (s.2 (k + 1)) (s.2 k) (t.2 k) ∧ t.1 = s.1 ∧ ∀ m, m ≠ k → t.2 m = s.2 m⟩

/-- The levels from `n` up the same in two configurations. -/
def SameFrom (n : Nat) (s t : Z × (Nat → R)) : Prop := ∀ m, n ≤ m → t.2 m = s.2 m

/-- Levels the same from `n` up are the same from any `n' ≥ n` up. -/
theorem SameFrom.mono {n n' : Nat} {s t : Z × (Nat → R)} (same : SameFrom n s t) (le : n ≤ n') :
    SameFrom n' s t :=
  fun m above => same m (Nat.le_trans le above)

variable {base : R → Z → Z → Prop} {up : Nat → R → R → R → Prop}

/-- **Every move keeps the levels from some height up**: the move `a` keeps the levels from `a`
up. -/
theorem step_sameFrom {s t : Z × (Nat → R)} : ∀ a, (process base up).step s a t → SameFrom a s t
  | 0, step => fun m _ => step.2 m
  | k + 1, step => fun m above => step.2.2 m (fun same =>
      Nat.not_succ_le_self k (Eq.subst (motive := fun j => k + 1 ≤ j) same above))

/-- **What the tower reaches it reaches with the levels from some height up held**: a trace keeps
the levels from the sum of its moves up at every move. -/
theorem trace_held : ∀ (as : List Nat) (s t : Z × (Nat → R)), Trace (process base up) s as t →
    ∃ n, Reach (keeping (process base up) (SameFrom n)) s t
  | [], _, _, .nil s => ⟨0, Reach.refl _ s⟩
  | a :: as, _, t, .cons step rest => match trace_held as _ t rest with
    | ⟨n, reach⟩ => ⟨a + n, Reach.trans
        (Reach.of_step (a := a) ⟨step, (step_sameFrom a step).mono (Nat.le_add_right a n)⟩)
        (Reach.keeping_mono (fun _ _ same => SameFrom.mono same (Nat.le_add_left n a)) reach)⟩

/-- **Every possibility of the tower is possible with the levels from some height up held**, and
conversely: no single possibility needs the tower to have no top. -/
theorem possible_iff_held {adm : Z × (Nat → R) → X → Prop} {s : Z × (Nat → R)} {x : X} :
    Reaching.Possible (process base up) adm s x ↔
      ∃ n, Reaching.PossibleHeld (process base up) (SameFrom n) adm s x :=
  ⟨fun ⟨t, ⟨as, trace⟩, admitted⟩ => match trace_held as s t trace with
     | ⟨n, reach⟩ => ⟨n, t, reach, admitted⟩,
   fun ⟨_, held⟩ => Reaching.PossibleHeld.possible held⟩

end RuleTower

section TowerAlong

variable {Z : Type u} {R : Type v} {X : Type} {base : R → Z → Z → Prop}
  {up : Nat → R → R → R → Prop} {adm : Z × (Nat → R) → X → Prop}

/-- **A top fixed for good stops the growth relative to it**: where from step `T` on the levels from
`N` up stay, the possible with the levels from any `n ≥ N` up held does not keep widening. -/
theorem Run.ruleTower_not_keepsWidening_of_top (r : Run (RuleTower.process base up)) {N T : Nat}
    (top : ∀ k, T ≤ k → RuleTower.SameFrom N (r.state k) (r.state (k + 1))) {n : Nat}
    (le : N ≤ n) :
    ¬ Reaching.KeepsWidening (fun k => Reaching.PossibleHeld (RuleTower.process base up)
      (RuleTower.SameFrom n) adm (r.state k)) :=
  r.not_heldKeepsWidening_of_stays (fun k later => (top k later).mono le)

end TowerAlong

/-! ## Witness: open-ended relative to its rule, with the whole possible fixed -/

namespace Climbing

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

/-- With the rule held, a configuration reaches its rule and its own position or one at most its
rule. -/
theorem held_trace : ∀ (as : List Unit) (s t : Nat × Nat), Trace (keeping process Same) s as t →
    t.1 = s.1 ∧ (t.2 = s.2 ∨ t.2 ≤ s.1)
  | [], _, _, .nil _ => ⟨rfl, Or.inl rfl⟩
  | _ :: as, s, t, .cons kept rest => match held_trace as _ t rest with
    | ⟨rule, position⟩ => match kept.1 with
      | .inl raise =>
        absurd (Nat.le_of_eq (raise.1.symm.trans kept.2)) (Nat.not_succ_le_self s.1)
      | .inr move => ⟨rule.trans kept.2, Or.inr (match position with
        | .inl same => Eq.subst (motive := fun y => y ≤ s.1) same.symm move.2
        | .inr le => Eq.subst (motive := fun y => t.2 ≤ y) move.1 le)⟩

/-- **With the rule held, the possible at the course's step `k` is what lies at most `k`.** -/
theorem held_iff (k y : Nat) : Reaching.PossibleHeld process Same adm (course.state k) y ↔ y ≤ k :=
  ⟨fun ⟨t, ⟨as, trace⟩, admitted⟩ => match held_trace as _ t trace with
     | ⟨_, .inl same⟩ =>
       Eq.subst (motive := fun z => z ≤ k) (admitted.trans same).symm (Nat.zero_le k)
     | ⟨_, .inr le⟩ => Eq.subst (motive := fun z => z ≤ k) admitted.symm le,
   fun le => ⟨(k, y), Reach.of_step (a := ()) ⟨Or.inr ⟨rfl, le⟩, rfl⟩, rfl⟩⟩

/-- **With the rule held, the possible keeps widening along the course**, in 07's form. -/
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

end Climbing

end Becoming
