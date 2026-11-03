import Becoming.Cascade

/-!
# A cascade at the histories reached (级联之所及)

`Becoming.Cascade` states where a pool's reach stops: where every member from `k` on acts alike
whatever its own coupling on every list of earlier acts (`Turns.ReadsOnlyActsFrom`), worlds alike
through the couplings of the members before `k` give every member the same act. That premise also
covers histories no run reaches. This module asks for it only where a run goes.

* **The premise at the histories reached, for two worlds.** From member `k` on, every member gives
  one act for the couplings of two worlds `w` and `w'` at the list of acts `w` gives it
  (`Turns.LawAlikeAlong`): the premise is asked at `w`'s history and at the two couplings compared
  alone. Acting alike whatever its coupling at the list of acts `w` gives it
  (`Turns.ReadsOnlyActsAlong`) gives it for every `w'` (`Turns.lawAlikeAlong_of_along`), and the
  premise on every list gives that at every world (`Turns.readsOnlyActsAlong_of_from`).
* **Reach stops along the run.** Where the pair meets it, and `w'` is alike with `w` through the
  couplings of the members before `k`, the two give the same acts to every number of members and
  the same act to every member (`Turns.acts_alike_along`, `Turns.act_alike_along`). Where
  `ReadsOnlyActsAlong` holds at every world, every selection through the acts is a selection
  through the first `k` couplings (`Turns.cascade_through_along`).
* **A weaker premise.** A member `0` that reads its coupling only after a non-empty list of earlier
  acts, which no world gives it, meets `ReadsOnlyActsAlong 0` at every world while `Cascade`'s
  premise from member `0` fails (`Turns.Unreached.along`, `Turns.Unreached.not_from`); from member
  `1` on, `Cascade`'s premise holds in the witness.

**Readings** (the AI's; correspondences, not theorems).
- *A natural cascade:* a chooser who stops reading a private signal only once the public acts it
  is shown outweigh it need not ignore that signal on lists of acts it never sees. Such a chooser
  meets the premise at a world whose acts before `k` already outweigh the signal, so the laws for
  two worlds apply there; at every world, as the selection law needs, it meets it for no fixed `k`
  unless the acts before `k` are fixed (as by a scripted prefix).

**What is not derived.** When an actual member stops reading its coupling, which is a premise here;
a position `k` that depends on the world (a stopping time), with or without persistence; the
premise at every world for a natural chooser with no fixed prefix; a probabilistic or
total-variation form; that a pool's later selection keeps a coupling one member's act carries. Members are indexed by the natural numbers.

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

/-- From member `k` on, every member gives one act for the couplings of worlds `w` and `w'` at the
list of acts `w` gives it: the premise at `w`'s history and at the two couplings compared alone. -/
def LawAlikeAlong (k : Nat) (w w' : W) : Prop :=
  ∀ n, k ≤ n → T.law n (T.coupling n w) (T.acts w n) = T.law n (T.coupling n w') (T.acts w n)

variable {T}

/-- The premise on every list of earlier acts gives it at the histories every world reaches. -/
theorem readsOnlyActsAlong_of_from {k : Nat} (cascade : T.ReadsOnlyActsFrom k) (w : W) :
    T.ReadsOnlyActsAlong k w :=
  fun n late o o' => cascade n late o o' (T.acts w n)

/-- Acting alike whatever its coupling at the history `w` reaches gives one act for the couplings
of `w` and of every other world there. -/
theorem lawAlikeAlong_of_along {k : Nat} {w : W} (along : T.ReadsOnlyActsAlong k w) (w' : W) :
    T.LawAlikeAlong k w w' :=
  fun n late => along n late (T.coupling n w) (T.coupling n w')

/-- Where the pair meets the premise at member `n`'s history in `w`, and two worlds alike before
`k` give the same acts before member `n`, they give member `n` the same act. -/
theorem law_alike_along {k : Nat} {w w' : W} (along : T.LawAlikeAlong k w w')
    (alike : T.AlikeBefore k w w') {n : Nat} (before : T.acts w n = T.acts w' n) :
    T.law n (T.coupling n w) (T.acts w n) = T.law n (T.coupling n w') (T.acts w' n) :=
  match Nat.decLt n k with
  | isTrue early => congr (congrArg (T.law n) (alike n early)) before
  | isFalse late =>
    (along n (Nat.le_of_not_lt late)).trans (congrArg (T.law n (T.coupling n w')) before)

/-- **Reach stops along the run.** Where, from member `k` on, every member gives one act for the
couplings of `w` and `w'` at the histories `w` reaches, and the two are alike through the couplings
of the members before `k`, they give the same acts to every number of members. -/
theorem acts_alike_along {k : Nat} {w w' : W} (along : T.LawAlikeAlong k w w')
    (alike : T.AlikeBefore k w w') : ∀ n, T.acts w n = T.acts w' n
  | 0 => rfl
  | n + 1 =>
    have before := acts_alike_along along alike n
    show T.acts w n ++ [T.law n (T.coupling n w) (T.acts w n)] =
        T.acts w' n ++ [T.law n (T.coupling n w') (T.acts w' n)] from
      congr (congrArg HAppend.hAppend before)
        (congrArg (fun a => [a]) (law_alike_along along alike before))

/-- Every member's act, under the premise at the histories `w` reaches for the pair, is alike across
`w` and `w'` where they are alike before `k`. -/
theorem act_alike_along {k : Nat} {w w' : W} (along : T.LawAlikeAlong k w w')
    (alike : T.AlikeBefore k w w') (n : Nat) : T.act w n = T.act w' n :=
  law_alike_along along alike (acts_alike_along along alike n)

/-- **A selection through the acts is a selection through the first couplings**, where the premise
holds at the histories every world reaches. -/
theorem cascade_through_along {k : Nat} (along : ∀ w, T.ReadsOnlyActsAlong k w) (N : Nat)
    (select : List A → Prop) :
    Learning.Training.Through (T.AlikeBefore k) (fun w => select (T.acts w N)) :=
  fun x x' alike =>
    show select (T.acts x N) ↔ select (T.acts x' N) from
      (acts_alike_along (lawAlikeAlong_of_along (along x) x') alike N) ▸ Iff.rfl

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
