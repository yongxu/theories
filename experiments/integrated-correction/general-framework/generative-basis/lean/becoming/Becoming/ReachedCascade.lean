import Becoming.Cascade

/-!
# A cascade at the histories reached (级联之所及)

`Becoming.Cascade` states where a pool's reach stops: where every member from `k` on acts alike
whatever its own coupling on every list of earlier acts (`Turns.ReadsOnlyActsFrom`), worlds alike
through the couplings of the members before `k` give every member the same act. That premise also
covers histories no run reaches. This module asks for it only where a run goes.

* **The premise at the histories a world reaches.** From member `k` on, every member acts alike
  whatever its own coupling at the list of acts world `w` gives it (`Turns.ReadsOnlyActsAlong`).
  The premise on every list gives it at every world (`Turns.readsOnlyActsAlong_of_from`).
* **Reach stops along the run.** Where that holds at one world `w`, every world alike with `w`
  through the couplings of the members before `k` gives the same acts to every number of members
  and the same act to every member (`Turns.acts_alike_along`, `Turns.act_alike_along`); the premise
  is needed at `w` alone, not at the other world. Where it holds at every world, every selection
  through the acts is a selection through the first `k` couplings (`Turns.cascade_through_along`).
* **A weaker premise.** A member that reads its coupling only after a history no run gives it meets
  the premise at every world's reached histories and not on every list (`Turns.Unreached.along`,
  `Turns.Unreached.not_from`), so the module's laws hold where `Cascade`'s premise fails.

**Readings** (the AI's; correspondences, not theorems).
- *A natural cascade:* a chooser who stops reading a private signal only once the public acts it
  is shown outweigh it need not ignore that signal on lists of acts it never sees. The reached form
  is the premise such a chooser can meet; which histories a run reaches is fixed by the run.

**What is not derived.** When an actual member stops reading its coupling, which is a premise here;
a position `k` that depends on the world (a stopping time), with or without persistence; a
probabilistic or total-variation form. Members are indexed by the natural numbers.

Every declaration has an empty axiom report. No ethical predicate or normative premise is
introduced.
-/

namespace Becoming

universe u v w

namespace Turns

variable {W : Type u} {O : Type v} {A : Type w} (T : Turns W O A)

/-- From member `k` on, every member acts alike whatever its own coupling at the list of acts world
`w` gives it: at the histories `w` reaches, not on every list. -/
def ReadsOnlyActsAlong (k : Nat) (w : W) : Prop :=
  ∀ n, k ≤ n → ∀ o o', T.law n o (T.acts w n) = T.law n o' (T.acts w n)

variable {T}

/-- The premise on every list of earlier acts gives it at the histories every world reaches. -/
theorem readsOnlyActsAlong_of_from {k : Nat} (cascade : T.ReadsOnlyActsFrom k) (w : W) :
    T.ReadsOnlyActsAlong k w :=
  fun n late o o' => cascade n late o o' (T.acts w n)

/-- Where member `n` acts alike whatever its coupling at the history `w` reaches, and two worlds
alike before `k` give the same acts before member `n`, they give member `n` the same act. -/
theorem law_alike_along {k : Nat} {w w' : W} (along : T.ReadsOnlyActsAlong k w)
    (alike : T.AlikeBefore k w w') {n : Nat} (before : T.acts w n = T.acts w' n) :
    T.law n (T.coupling n w) (T.acts w n) = T.law n (T.coupling n w') (T.acts w' n) :=
  match Nat.decLt n k with
  | isTrue early => congr (congrArg (T.law n) (alike n early)) before
  | isFalse late =>
    (along n (Nat.le_of_not_lt late) (T.coupling n w) (T.coupling n w')).trans
      (congrArg (T.law n (T.coupling n w')) before)

/-- **Reach stops along the run.** Where every member from `k` on acts alike whatever its coupling
at the histories world `w` reaches, every world alike with `w` through the couplings of the members
before `k` gives the same acts to every number of members. -/
theorem acts_alike_along {k : Nat} {w w' : W} (along : T.ReadsOnlyActsAlong k w)
    (alike : T.AlikeBefore k w w') : ∀ n, T.acts w n = T.acts w' n
  | 0 => rfl
  | n + 1 =>
    have before := acts_alike_along along alike n
    show T.acts w n ++ [T.law n (T.coupling n w) (T.acts w n)] =
        T.acts w' n ++ [T.law n (T.coupling n w') (T.acts w' n)] from
      congr (congrArg HAppend.hAppend before)
        (congrArg (fun a => [a]) (law_alike_along along alike before))

/-- Every member's act, under the premise at the histories `w` reaches, is alike across `w` and
every world alike with it before `k`. -/
theorem act_alike_along {k : Nat} {w w' : W} (along : T.ReadsOnlyActsAlong k w)
    (alike : T.AlikeBefore k w w') (n : Nat) : T.act w n = T.act w' n :=
  law_alike_along along alike (acts_alike_along along alike n)

/-- **A selection through the acts is a selection through the first couplings**, where the premise
holds at the histories every world reaches. -/
theorem cascade_through_along {k : Nat} (along : ∀ w, T.ReadsOnlyActsAlong k w) (N : Nat)
    (select : List A → Prop) :
    Learning.Training.Through (T.AlikeBefore k) (fun w => select (T.acts w N)) :=
  fun x x' alike =>
    show select (T.acts x N) ↔ select (T.acts x' N) from
      (acts_alike_along (along x) alike N) ▸ Iff.rfl

end Turns

namespace Turns.Unreached

/-- Member `0` reads its coupling only after a non-empty list of earlier acts, which no run gives
it; every later member acts `false`. -/
def law : Nat → Bool → List Bool → Bool
  | 0, _, [] => false
  | 0, o, _ :: _ => o
  | _ + 1, _, _ => false

/-- The members in turn, each coupled to the world itself. -/
def turns : Turns Bool Bool Bool where
  coupling := fun _ w => w
  law := law

/-- At the histories every world reaches, every member acts alike whatever its coupling. -/
theorem along (w : Bool) : turns.ReadsOnlyActsAlong 0 w
  | 0, _, _, _ => rfl
  | _ + 1, _, _, _ => rfl

/-- On a list no run gives member `0`, it reads its coupling: the premise on every list fails. -/
theorem not_from : ¬ turns.ReadsOnlyActsFrom 0 :=
  fun cascade => absurd (cascade 0 (Nat.le_refl 0) true false [false]) (by decide)

end Turns.Unreached

end Becoming
