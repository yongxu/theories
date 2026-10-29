import Becoming.Learning

/-!
# Readers reading readers: where a pool's reach stops (级联)

Members act in turn. Each reads what couples into it of the world, its own coupling, and the acts
of the members before it. Sequential acts can discard distinctions available in the members'
couplings. This module states where that happens: if every member from `k` on ignores its own
coupling (a cascade), every finite list of acts is alike between worlds agreeing on the first `k`
couplings, however many members follow.

* **The acts in turn.** Member `n` acts by its law on its own coupling and on the list of the acts
  before it (`Turns.acts`, `Turns.act`). A law can ignore any entries of that list, so restricted
  access to earlier acts is represented; no separate graph of who reads whom is developed.
* **Reach stops where acts read only acts.** Where every member from `k` on acts alike whatever its
  own coupling (`ReadsOnlyActsFrom`, independence on all of the law's inputs, including histories no
  run reaches), two worlds alike through the couplings of the members before `k` give every member
  the same act (`acts_alike_of_cascade`, `act_alike_of_cascade`). So every selection through the
  acts, however long the list it reads, is a selection through the first `k` couplings
  (`cascade_through`, a `Learning.Training.Through`). This is an upper bound on what the acts carry,
  not the pool's exact reach.
* **A distinction in the law gives distinct acts at a shared history.** After the same earlier acts,
  a member acts differently in two worlds exactly where its law tells apart the values they give its
  coupling (`separates_at`). That one member carries its coupling does not make a later selection
  keep it, and nothing here acquires or restores a distinction.
* **Copying.** Every member after the first copying the first act is a cascade from member `1`: the
  pool's acts are alike across worlds alike through the first member's coupling
  (`Copying.reaches_first_only`).

**Readings** (the AI's; correspondences, not theorems).
- *Information cascades and herding* (Bikhchandani, Hirshleifer and Welch 1992; Banerjee 1992), in
  the deterministic form in which the act has stopped reading the member's own signal: after that
  step, repeated agreement adds no distinction of the later members' couplings. A cascade suppresses
  information; it can be accurate.
- *Condorcet's jury theorem and dependence:* copying illustrates dependence that adds no distinction
  beyond the first member's signal. This module proves no probabilistic accuracy or majority
  convergence. `WitnessRefinementRuns.copied_witnesses_same` is a neighbour in the witnesses'
  setting, under its further hypotheses (the copy matching the original's support and its membership
  of every fault set a candidate admits).
- *Echo chambers, and evaluators trained on one another's verdicts:* under the cascade premise,
  more members need not add distinctions beyond the first couplings.

**What is not derived.** When an actual member stops reading its own coupling (in the probabilistic
model, once the public evidence outweighs any private signal), which is a premise here; weighted
averaging (DeGroot) and its wisdom condition (Golub and Jackson), which need real weights; members in
no well-founded order. Members are indexed by the natural numbers.

Every declaration has an empty axiom report. No ethical predicate or normative premise is
introduced.
-/

namespace Becoming

universe u v w

/-- Members acting in turn: member `n`'s coupling of the world (`coupling n`) and its law of acting
on its own coupling and on the list of acts before it (`law n`). -/
structure Turns (W : Type u) (O : Type v) (A : Type w) where
  /-- What couples into member `n` of the world. -/
  coupling : Nat → W → O
  /-- How member `n` acts on its own coupling and the acts before it. -/
  law : Nat → O → List A → A

namespace Turns

variable {W : Type u} {O : Type v} {A : Type w} (T : Turns W O A)

/-- The acts of the first `n` members in a world, in turn. -/
def acts (w : W) : Nat → List A
  | 0 => []
  | n + 1 => acts w n ++ [T.law n (T.coupling n w) (acts w n)]

/-- Member `n`'s act in a world. -/
def act (w : W) (n : Nat) : A := T.law n (T.coupling n w) (T.acts w n)

/-- From member `k` on, every member acts alike whatever its own coupling: it reads only the acts
before it. This is independence on all of the law's inputs, including histories no run reaches,
not only on the runs that occur. -/
def ReadsOnlyActsFrom (k : Nat) : Prop :=
  ∀ n, k ≤ n → ∀ o o' (before : List A), T.law n o before = T.law n o' before

/-- Two worlds alike through the couplings of the members before `k`. -/
def AlikeBefore (k : Nat) (w w' : W) : Prop := ∀ j, j < k → T.coupling j w = T.coupling j w'

variable {T}

/-- In a cascade from `k`, where two worlds alike before `k` give the same acts before member
`n`, they give member `n` the same act. -/
theorem law_alike_of_cascade {k : Nat} (cascade : T.ReadsOnlyActsFrom k) {w w' : W}
    (alike : T.AlikeBefore k w w') {n : Nat} (before : T.acts w n = T.acts w' n) :
    T.law n (T.coupling n w) (T.acts w n) = T.law n (T.coupling n w') (T.acts w' n) :=
  match Nat.decLt n k with
  | isTrue early => congr (congrArg (T.law n) (alike n early)) before
  | isFalse late =>
    (cascade n (Nat.le_of_not_lt late) (T.coupling n w) (T.coupling n w') (T.acts w n)).trans
      (congrArg (T.law n (T.coupling n w')) before)

/-- **Reach stops where acts read only acts.** Where every member from `k` on reads only the acts
before it, two worlds alike through the couplings of the members before `k` give the same acts to
every number of members. -/
theorem acts_alike_of_cascade {k : Nat} (cascade : T.ReadsOnlyActsFrom k) {w w' : W}
    (alike : T.AlikeBefore k w w') : ∀ n, T.acts w n = T.acts w' n
  | 0 => rfl
  | n + 1 =>
    have before := acts_alike_of_cascade cascade alike n
    show T.acts w n ++ [T.law n (T.coupling n w) (T.acts w n)] =
        T.acts w' n ++ [T.law n (T.coupling n w') (T.acts w' n)] from
      congr (congrArg HAppend.hAppend before)
        (congrArg (fun a => [a]) (law_alike_of_cascade cascade alike before))

/-- Every member's act, in a cascade from `k`, is alike across worlds alike before `k`. -/
theorem act_alike_of_cascade {k : Nat} (cascade : T.ReadsOnlyActsFrom k) {w w' : W}
    (alike : T.AlikeBefore k w w') (n : Nat) : T.act w n = T.act w' n :=
  law_alike_of_cascade cascade alike (acts_alike_of_cascade cascade alike n)

/-- **A selection through the acts is a selection through the first couplings.** In a cascade from
`k`, every selection reading the list of the first `N` acts, for any `N`, selects alike any two
worlds alike through the couplings of the members before `k`. -/
theorem cascade_through {k : Nat} (cascade : T.ReadsOnlyActsFrom k) (N : Nat)
    (select : List A → Prop) :
    Learning.Training.Through (T.AlikeBefore k) (fun w => select (T.acts w N)) :=
  fun x x' alike =>
    show select (T.acts x N) ↔ select (T.acts x' N) from
      (acts_alike_of_cascade cascade alike N) ▸ Iff.rfl

/-- **A distinction in the law gives distinct acts at a shared history.** After the same earlier
acts, member `n` acts differently in two worlds exactly where its law tells apart the values they
give its coupling there. -/
theorem separates_at {w w' : W} {n : Nat} (before : T.acts w n = T.acts w' n) :
    T.act w n ≠ T.act w' n ↔
      T.law n (T.coupling n w) (T.acts w n) ≠ T.law n (T.coupling n w') (T.acts w n) :=
  ⟨fun apart same => apart (same.trans (congrArg (T.law n (T.coupling n w')) before)),
   fun apart same => apart (same.trans (congrArg (T.law n (T.coupling n w')) before.symm))⟩

end Turns

/-! ## Copying: every member after the first copies the first act -/

namespace Turns.Copying

variable {W : Type u} {O : Type v}

/-- The first member acts on its own coupling; every later member copies the first act before
it, or gives a fixed value where it hears none. -/
def turns (coupling : Nat → W → O) (fallback : O) : Turns W O O where
  coupling := coupling
  law := fun n o before => match n, before with
    | 0, _ => o
    | _ + 1, first :: _ => first
    | _ + 1, [] => fallback

/-- Copying is a cascade from the second member. -/
theorem readsOnlyActs (coupling : Nat → W → O) (fallback : O) :
    (turns coupling fallback).ReadsOnlyActsFrom 1 :=
  fun n late _ _ before => match n, late, before with
    | 0, late, _ => (Nat.not_succ_le_zero 0 late).elim
    | _ + 1, _, _ :: _ => rfl
    | _ + 1, _, [] => rfl

/-- **Copying reaches only the first member.** Two worlds alike through the first member's
coupling give every member the same act, whatever couples into the others. -/
theorem reaches_first_only (coupling : Nat → W → O) (fallback : O) {w w' : W}
    (first : coupling 0 w = coupling 0 w') (n : Nat) :
    (turns coupling fallback).act w n = (turns coupling fallback).act w' n :=
  act_alike_of_cascade (readsOnlyActs coupling fallback)
    (fun j before => match j, before with
      | 0, _ => first
      | _ + 1, before => (Nat.not_lt_zero _ (Nat.lt_of_succ_lt_succ before)).elim) n

end Turns.Copying

end Becoming
