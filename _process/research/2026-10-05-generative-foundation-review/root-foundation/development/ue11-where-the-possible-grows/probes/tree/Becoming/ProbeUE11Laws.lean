import Becoming.HeldPossible
import Becoming.Gated
import Becoming.Junctures
import Becoming.Onward

/-!
# UE11 review probes: the laws

Probes for the independent review of `Becoming.HeldPossible` (board item UE11). Evidence for the
review, not proposed for landing as written. Index (REVIEW-UE11.md):

* P1 `exists_not_of_not_forall_lt`: bounded search over a decided predicate.
* P2 (question a) `plain_of_bounded`, `markov_of_plain_gives_bounded`: the bounded-stretch form
  gives the plain form, and the plain form giving the bounded one for every process is Markov's
  principle.
* P3 (question b) `Run.held_change_located`, `Run.held_change_of_keepsWidening`,
  `Climbing.change_of_keepsWidening`, `Run.adaptive_rule_change_of_keepsWidening`: with the part
  decided, a step changing it is located within the stretch, with no axiom.
* P4 (question c) `possible_iff_held_of_bounded`, `tower_bounded`, `Sync.not_held`: the tower law
  holds for any process whose every move keeps the levels from some height up, and fails for a
  synchronous tower.
* P5 (question d) `Run.ruleTower_moves_above_of_keepsWidening`, `RuleTower.reflected`,
  `RuleTower.held_origin`: the positive tower law through the gate on moves, and the held
  possible as an instance of `Gated.origin`.
* P6 `within_eq_keeping`, `branching_keeping_eq`: Onward's `within` and Junctures' `keeping` are
  instances of the module's `keeping`.
* P7 `Oscillating.converse_fails`: endless change of the held part and an unlisted whole possible
  do not suffice for keeping widening.
* P8 `Run.not_heldKeepsWidening_from`: from the step at which the part stays for good, nothing is
  added to the held possible.
-/

namespace Becoming.ProbeUE11

open Generative

universe u v w

/-! ## P1. Bounded search -/

/-- Where `p` is decided at each index, a refutation of `p` throughout the first `d` indices
gives an index below `d` where `p` fails. -/
theorem exists_not_of_not_forall_lt {p : Nat → Prop} (dec : ∀ i, Decidable (p i)) :
    ∀ d, ¬ (∀ i, i < d → p i) → ∃ i, i < d ∧ ¬ p i
  | 0, notAll => absurd (fun j lt => absurd lt (Nat.not_lt_zero j)) notAll
  | d + 1, notAll =>
    match dec d with
    | isFalse fails => ⟨d, Nat.lt_succ_self d, fails⟩
    | isTrue holds =>
      match exists_not_of_not_forall_lt dec d (fun below => notAll (fun i lt =>
          match Nat.lt_or_ge i d with
          | .inl lt' => below i lt'
          | .inr ge => Eq.subst (motive := p)
              (Nat.le_antisymm (Nat.le_of_lt_succ lt) ge).symm holds)) with
      | ⟨i, lt, fails⟩ => ⟨i, Nat.lt_succ_of_lt lt, fails⟩

theorem true_of_not_false : ∀ {b : Bool}, ¬ b = false → b = true
  | true, _ => rfl
  | false, notFalse => absurd rfl notFalse

/-! ## P2. The bounded-stretch form against the plain form -/

/-- The bounded-stretch form gives the plain form. -/
theorem plain_of_bounded {p : Nat → Prop} {N : Nat}
    (bounded : ∃ d, ¬ ∀ i, i < d → p (N + i)) : ¬ ∀ n, N ≤ n → p n :=
  fun all => match bounded with
    | ⟨_, notAll⟩ => notAll (fun i _ => all (N + i) (Nat.le_add_right N i))

/-- Counting up on the naturals. -/
def countUp : Process Nat Unit := ⟨fun m _ m' => m' = m + 1⟩

/-- Its course from `0`. -/
def countRun : Run countUp := ⟨fun n => n, fun _ => (), fun _ => rfl⟩

/-- **If the plain form gave the bounded-stretch form for every process `Q` along one course,
Markov's principle would follow**: the bounded form is strictly stronger constructively. -/
theorem markov_of_plain_gives_bounded
    (gives : ∀ (Q : Process Nat Unit) (N : Nat),
      ¬ (∀ n, N ≤ n → Q.step (countRun.state n) (countRun.act n) (countRun.state (n + 1))) →
      ∃ d, ¬ ∀ i, i < d → Q.step (countRun.state (N + i)) (countRun.act (N + i))
        (countRun.state (N + i + 1))) :
    Markov :=
  fun s notFalse =>
    match gives ⟨fun m _ _ => s m = false⟩ 0
        (fun all => notFalse (fun n => all n (Nat.zero_le n))) with
    | ⟨d, notAll⟩ =>
      match exists_not_of_not_forall_lt (p := fun i => s (0 + i) = false)
          (fun i => instDecidableEqBool (s (0 + i)) false) d notAll with
      | ⟨i, _, fails⟩ => ⟨0 + i, true_of_not_false fails⟩

/-! ## P3. With the part decided, the change is located -/

section Located

variable {S : Type u} {A : Type v} {X : Type} {P : Process S A} {Same : S → S → Prop}
  {adm : S → X → Prop}

/-- **Growth of the held possible across a stretch, located.** With the part decided, where
something possible with the part held at step `N + d` is not possible so at step `N`, some step
of the stretch changes the part. -/
theorem Run.held_change_located (r : Run P) (dec : ∀ s t, Decidable (Same s t)) {N d : Nat}
    {x : X} (later : Reaching.PossibleHeld P Same adm (r.state (N + d)) x)
    (notNow : ¬ Reaching.PossibleHeld P Same adm (r.state N) x) :
    ∃ i, i < d ∧ ¬ Same (r.state (N + i)) (r.state (N + i + 1)) :=
  exists_not_of_not_forall_lt (fun _ => dec _ _) d
    (fun stays => notNow (r.possible_of_stretch (Q := keeping P Same) N d
      (fun i before => ⟨r.step (N + i), stays i before⟩) later))

/-- **With the part decided, keeping widening needs a change of it after every step**, located. -/
theorem Run.held_change_of_keepsWidening (r : Run P) (dec : ∀ s t, Decidable (Same s t))
    (keeps : Reaching.KeepsWidening (fun n => Reaching.PossibleHeld P Same adm (r.state n)))
    (N : Nat) : ∃ i, N ≤ i ∧ ¬ Same (r.state i) (r.state (i + 1)) :=
  match keeps.2 N with
  | ⟨_, _, later, notNow⟩ => match Run.held_change_located r dec later notNow with
    | ⟨i, _, changes⟩ => ⟨N + i, Nat.le_add_right N i, changes⟩

end Located

/-- On `Climbing` the rule is decided, so every course keeping the held possible widening changes
the rule after every step, located (here: at every step). -/
theorem Climbing.change_of_keepsWidening (r : Run Climbing.process)
    (keeps : Reaching.KeepsWidening
      (fun n => Reaching.PossibleHeld Climbing.process Climbing.Same Climbing.adm (r.state n)))
    (N : Nat) : ∃ i, N ≤ i ∧ ¬ (r.state (i + 1)).1 = (r.state i).1 :=
  Run.held_change_of_keepsWidening r (fun s t => Nat.decEq t.1 s.1) keeps N

/-- **With the rule decided, a system changing its own rule changes it after every step** where
the possible with the rule held keeps widening: some step from `N` on where `G` does not leave the
rule as it is. -/
theorem Run.adaptive_rule_change_of_keepsWidening {Z : Type u} {R : Type v} {U : Type w}
    {X : Type} [DecidableEq R] {F : R → Z → U → Z} {G : R → Z → R} (r : Run (adaptive F G))
    {adm : Z × R → X → Prop}
    (keeps : Reaching.KeepsWidening
      (fun n => Reaching.PossibleHeld (adaptive F G) (fun s t => t.2 = s.2) adm (r.state n)))
    (N : Nat) : ∃ i, N ≤ i ∧ ¬ G (r.state i).2 (r.state i).1 = (r.state i).2 :=
  match Run.held_change_of_keepsWidening r (Same := fun s t => t.2 = s.2)
      (fun s t => decEq t.2 s.2) keeps N with
  | ⟨i, le, changes⟩ =>
    ⟨i, le, fun leaves => changes ((adaptive_keeps_rule_iff (r.step i)).mpr leaves)⟩

/-! ## P4. The tower law needs each move to keep the levels from some height up -/

section Levels

variable {Z : Type u} {R : Type v} {A : Type w} {X : Type}

/-- What a process reaches it reaches with the levels from some height up held, wherever every
move keeps the levels from some height up. -/
theorem trace_held_of_bounded {P : Process (Z × (Nat → R)) A}
    (bounded : ∀ s a t, P.step s a t → ∃ n, RuleTower.SameFrom n s t) :
    ∀ (as : List A) (s t : Z × (Nat → R)), Trace P s as t →
      ∃ n, Reach (keeping P (RuleTower.SameFrom n)) s t
  | [], _, _, .nil s => ⟨0, Reach.refl _ s⟩
  | a :: as, _, t, .cons step rest =>
    match trace_held_of_bounded bounded as _ t rest, bounded _ _ _ step with
    | ⟨n, reach⟩, ⟨k, same⟩ => ⟨k + n, Reach.trans
        (Reach.of_step (a := a) ⟨step, same.mono (Nat.le_add_right k n)⟩)
        (Reach.keeping_mono (fun _ _ same' => RuleTower.SameFrom.mono same' (Nat.le_add_left n k))
          reach)⟩

/-- **The tower law for any process whose every move keeps the levels from some height up.** -/
theorem possible_iff_held_of_bounded {P : Process (Z × (Nat → R)) A}
    (bounded : ∀ s a t, P.step s a t → ∃ n, RuleTower.SameFrom n s t)
    {adm : Z × (Nat → R) → X → Prop} {s : Z × (Nat → R)} {x : X} :
    Reaching.Possible P adm s x ↔ ∃ n, Reaching.PossibleHeld P (RuleTower.SameFrom n) adm s x :=
  ⟨fun ⟨t, ⟨as, trace⟩, admitted⟩ => match trace_held_of_bounded bounded as s t trace with
     | ⟨n, reach⟩ => ⟨n, t, reach, admitted⟩,
   fun ⟨_, held⟩ => Reaching.PossibleHeld.possible held⟩

/-- The tower's moves meet the premise: the move `a` keeps the levels from `a` up. -/
theorem tower_bounded {base : R → Z → Z → Prop} {up : Nat → R → R → R → Prop} :
    ∀ s a t, (RuleTower.process base up).step s a t → ∃ n, RuleTower.SameFrom n s t :=
  fun _ a _ step => ⟨a, RuleTower.step_sameFrom a step⟩

/-- **A synchronous tower**: at every move the state changes as the level `0` allows and every
level `k` changes as the level `k + 1` allows, all at once. Every level is changed by the one
above it, and none is the last. -/
def syncProcess (base : R → Z → Z → Prop) (up : Nat → R → R → R → Prop) :
    Process (Z × (Nat → R)) Unit :=
  ⟨fun s _ t => base (s.2 0) s.1 t.1 ∧ ∀ k, up k (s.2 (k + 1)) (s.2 k) (t.2 k)⟩

end Levels

/-- Held moves along a process keeping the levels from `n` up keep them along any trace. -/
theorem sameFrom_of_reach {Z : Type u} {R : Type v} {A : Type w}
    {P : Process (Z × (Nat → R)) A} {n : Nat} :
    ∀ {as : List A} {s t : Z × (Nat → R)}, Trace (keeping P (RuleTower.SameFrom n)) s as t →
      RuleTower.SameFrom n s t
  | [], _, _, .nil _ => fun _ _ => rfl
  | _ :: _, _, _, .cons kept rest => fun m le => ((sameFrom_of_reach rest) m le).trans (kept.2 m le)

namespace Sync

/-- Each level grows by the value of the one above; the state stays. -/
def process : Process (Unit × (Nat → Nat)) Unit :=
  syncProcess (fun _ z z' => z' = z) (fun _ above ρ ρ' => ρ' = ρ + above)

/-- A configuration admits its level `0`. -/
def adm (s : Unit × (Nat → Nat)) (y : Nat) : Prop := y = s.2 0

/-- Every level at `1`. -/
def start : Unit × (Nat → Nat) := ((), fun _ => 1)

/-- From the start, `2` is possible: one move. -/
theorem possible_two : Reaching.Possible process adm start 2 :=
  ⟨((), fun _ => 2), Reach.of_step (a := ()) ⟨rfl, fun _ => rfl⟩, rfl⟩

/-- With the levels from any height up held, `2` is not possible from the start: each move
changes every level. -/
theorem not_held (n : Nat) : ¬ Reaching.PossibleHeld process (RuleTower.SameFrom n) adm start 2 :=
  fun ⟨_, ⟨as, trace⟩, admitted⟩ => match as, trace with
    | [], .nil _ => Nat.succ_ne_self 1 admitted
    | _ :: _, .cons kept _ =>
      Nat.not_succ_le_self (start.2 n)
        (Nat.le_of_eq ((kept.1.2 n).symm.trans (kept.2 n (Nat.le_refl n))))

/-- **The tower law fails for the synchronous tower.** -/
theorem tower_law_fails :
    ¬ (Reaching.Possible process adm start 2 →
        ∃ n, Reaching.PossibleHeld process (RuleTower.SameFrom n) adm start 2) :=
  fun law => match law possible_two with
    | ⟨n, held⟩ => not_held n held

end Sync

/-! ## P5. The positive tower law through the gate on moves -/

section TowerGate

variable {Z : Type u} {R : Type v} {X : Type} {base : R → Z → Z → Prop}
  {up : Nat → R → R → R → Prop} {adm : Z × (Nat → R) → X → Prop}

/-- **Along a course of the tower, where the possible with the levels from `n` up held keeps
widening, moves above `n` recur without end**: from every step on some move changes a level from
`n` up, located, with no decision of the levels. -/
theorem Run.ruleTower_moves_above_of_keepsWidening (r : Run (RuleTower.process base up))
    {n : Nat}
    (keeps : Reaching.KeepsWidening (fun k => Reaching.PossibleHeld (RuleTower.process base up)
      (RuleTower.SameFrom n) adm (r.state k))) (N : Nat) :
    ∃ i, N ≤ i ∧ n < r.act i :=
  match r.changes_of_heldKeepsWidening keeps N with
  | ⟨d, notAll⟩ =>
    match exists_not_of_not_forall_lt (p := fun i => r.act (N + i) ≤ n)
        (fun i => Nat.decLe (r.act (N + i)) n) d
        (fun below => notAll (fun i lt =>
          (RuleTower.step_sameFrom (r.act (N + i)) (r.step (N + i))).mono (below i lt))) with
    | ⟨i, _, above⟩ => ⟨N + i, Nat.le_add_right N i, Nat.gt_of_not_le above⟩

/-- The moves of the tower at most `n`, the ungated ones, reflect what is possible with the levels
from `n` up held. -/
theorem RuleTower.reflected (n : Nat) (x : X) :
    Gated.ReflectedBy (RuleTower.process base up) (fun a => decide (n < a))
      (fun s => Reaching.PossibleHeld (RuleTower.process base up) (RuleTower.SameFrom n) adm s x) :=
  fun _ a _ step ungated held =>
    Reaching.Possible.of_reach
      (Reach.of_step (P := keeping (RuleTower.process base up) (RuleTower.SameFrom n)) (a := a)
        ⟨step, (RuleTower.step_sameFrom a step).mono
          (Nat.ge_of_not_lt (of_decide_eq_false ungated))⟩)
      held

/-- **The held possible of the tower is an instance of the landed gate law** (`Gated.origin`): a
trace ending where `x` is possible with the levels from `n` up held started where it was, or splits
at a move above `n` after which it is. -/
theorem RuleTower.held_origin (n : Nat) (x : X) {s t : Z × (Nat → R)} {plan : List Nat}
    (trace : Trace (RuleTower.process base up) s plan t)
    (held : Reaching.PossibleHeld (RuleTower.process base up) (RuleTower.SameFrom n) adm t x) :
    Reaching.PossibleHeld (RuleTower.process base up) (RuleTower.SameFrom n) adm s x ∨
      ∃ pre a post m m', plan = pre ++ a :: post ∧ Trace (RuleTower.process base up) s pre m ∧
        (RuleTower.process base up).step m a m' ∧ decide (n < a) = true ∧
        Reaching.PossibleHeld (RuleTower.process base up) (RuleTower.SameFrom n) adm m' x ∧
        Trace (RuleTower.process base up) m' post t :=
  Gated.origin (RuleTower.reflected n x) trace held

end TowerGate

/-! ## P6. Landed restrictions of a process are instances of `keeping` -/

section Instances

variable {S : Type u} {A : Type v} {P : Process S A}

/-- Onward's steps within a family are the moves keeping both ends in it. -/
theorem within_eq_keeping {K : S → Prop} :
    Onward.within P K = keeping P (fun s t => K s ∧ K t) := rfl

/-- Junctures' steps after which `s` can still be had are the moves keeping that. -/
theorem branching_keeping_eq {s : S} :
    Branching.keeping P s = keeping P (fun _ t => Reach P t s) := rfl

end Instances

/-! ## P7. Endless change and an unlisted whole possible do not suffice -/

namespace Oscillating

/-- A configuration is a rule and a position: a move sets the rule to any value, the position
kept, or moves the position to any value at most the rule. -/
def process : Process (Nat × Nat) Unit :=
  ⟨fun s _ t => t.2 = s.2 ∨ (t.1 = s.1 ∧ t.2 ≤ s.1)⟩

/-- A configuration admits its position. -/
def adm (s : Nat × Nat) (y : Nat) : Prop := y = s.2

/-- The rule the same. -/
def Same (s t : Nat × Nat) : Prop := t.1 = s.1

/-- A Boolean alternating `false, true, false, …`. -/
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
  ⟨(y, y), Reach.trans (Reach.of_step (P := process) (s := s) (t := (y, s.2)) (a := ()) (Or.inl rfl))
      (Reach.of_step (a := ()) (Or.inr ⟨rfl, Nat.le_refl y⟩)), rfl⟩

/-- With the rule held at `0`, the position stays `0`. -/
theorem held_zero : ∀ {as : List Unit} {s t : Nat × Nat}, Trace (keeping process Same) s as t →
    s.1 = 0 → s.2 = 0 → t.2 = 0
  | [], _, _, .nil _, _, position => position
  | _ :: _, _, _, .cons (m := m) kept rest, rule0, position =>
    held_zero rest (kept.2.trans rule0) (match kept.1 with
      | .inl same => same.trans position
      | .inr move => Nat.eq_zero_of_le_zero (Eq.subst (motive := fun z => m.2 ≤ z) rule0 move.2))

/-- **The converse fails**: the rule changes at every step and no list holds the whole possible,
yet the possible with the rule held does not keep widening; what it opens with the rule at `1` it
loses with the rule back at `0`. -/
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
     match keeps.1 1 1 1 ⟨(1, 1), Reach.of_step (a := ()) ⟨Or.inr ⟨rfl, Nat.le_refl 1⟩, rfl⟩, rfl⟩ with
     | ⟨_, ⟨_, trace⟩, admitted⟩ => Nat.noConfusion (admitted.trans (held_zero trace rfl rfl))⟩

end Oscillating

/-! ## P8. From the step at which the part stays for good, nothing is added -/

/-- **From the step at which the part stays for good, nothing is added to the held possible**:
where every step from `T` on keeps the part, what is possible with it held at any later step is
possible so at `T` (the stronger reading of `Run.ruleTower_not_keepsWidening_of_top`'s
"stops the growth"). -/
theorem Run.not_heldKeepsWidening_from {S : Type u} {A : Type v} {X : Type} {P : Process S A}
    {Same : S → S → Prop} {adm : S → X → Prop} (r : Run P) {T : Nat}
    (stays : ∀ n, T ≤ n → Same (r.state n) (r.state (n + 1))) (d : Nat) {x : X}
    (later : Reaching.PossibleHeld P Same adm (r.state (T + d)) x) :
    Reaching.PossibleHeld P Same adm (r.state T) x :=
  r.possible_of_stretch (Q := keeping P Same) T d
    (fun i _ => ⟨r.step (T + i), stays (T + i) (Nat.le_add_right T i)⟩) later

end Becoming.ProbeUE11
