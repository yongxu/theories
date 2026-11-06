import Becoming.Inquiry
import Becoming.Recurrence
import Becoming.Witnesses

/-!
# The outcomes of one move from a configuration

One move from `s` completes a goal where it is enabled and every next configuration meets it (the
foundation's `Completes` on a one-move word); `Ensures P s goal` says some move does
(`ensures_iff`). The moves of `Q` at `t` cover those of `P` at `s` where every enabled move of `P`
at `s` is matched by an enabled move of `Q` at `t` whose outcomes are among its own (`Covers`), and
they do exactly where every goal that one move of `P` from `s` completes, one move of `Q` from `t`
completes (`covers_iff`). Covering is a preorder (`covers_refl`, `covers_trans`).

* **Laws of every process.** Completion by one move carries to every weaker goal
  (`completes_mono`); no move completes the empty goal (`not_ensures_false`), and the full goal is
  completed exactly where some move is enabled (`ensures_true_iff`); where some move of `P` is
  enabled at `s` and `Q` at `t` covers it, some goal is ensured by both (`common_goal`); no process
  ensures every goal that another does not (`no_strict_gain_everywhere`); revisions of a process
  each covering the last cover the first at every stage (`covers_along`); a cover fails exactly
  where not every goal is carried (`not_covers_iff`), and under double-negation elimination, taken
  as a hypothesis, it names a lost goal (`lost_goal_of_not_covers_of_dne`); a goal on a summary
  of the outcomes is ensured exactly where its pullback is (`summary_ensures_iff`).
* **Four processes on two configurations.** The constant law sending every configuration to
  `false` (`toFalse`), the free process whose move may go anywhere (`free`), the setting process
  whose move names the next configuration (`setting`) and the halted process with no move
  (`halted`) witness that more possible outcomes need not cover (`free_wider_not_covering`), that
  covering can remove a possibility (`law_covers_free_and_loses`), that a cover can ensure a new
  goal (`setting_covers_and_gains`) and open what was closed (`setting_covers_and_opens`), that
  goals ensured separately need not be ensured jointly (`setting_separate_not_joint`), that where
  no move is enabled nothing is ensured though every outcome meets every goal
  (`halted_ensures_nothing`), and that a summary can hide a loss (`summary_hides_loss`).
* **Common responses.** A common response for a belief completes from every configuration the
  belief holds (`common_completes`).

`PracticalReach` states these laws of a relation from responses to outcomes; the relation is the
step of a process from a configuration, its responses the labels and its outcomes the next
configurations. Its readings as these laws (`canEnsure_iff`, `summary_iff`, `steps_eq`) and the
classical form of `not_covers_iff` naming the lost goal (`lost_goal_of_not_covers`) are in
`Becoming.MoveOutcomeProcessesInherited`; this module imports nothing outside the core.

No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

open Generative Generative.InquirySufficiency

namespace MoveOutcomeProcesses

section Laws

variable {S A B C : Type}

/-- Some one move of `P` from `s` completes `goal`. -/
def Ensures (P : Process S A) (s : S) (goal : S → Prop) : Prop :=
  ∃ a, Completes P (fun _ _ _ => True) goal s [a]

/-- The moves of `Q` at `t` cover those of `P` at `s`: every enabled move of `P` at `s` is matched
by an enabled move of `Q` at `t` whose outcomes are among its own. -/
def Covers (P : Process S A) (s : S) (Q : Process S B) (t : S) : Prop :=
  ∀ a, Enabled P s a → ∃ b, Enabled Q t b ∧ ∀ o, Q.step t b o → P.step s a o

/-- **One move completes a goal exactly where it is enabled and every next configuration meets
the goal.** -/
theorem completes_one_iff {P : Process S A} {s : S} {a : A} {goal : S → Prop} :
    Completes P (fun _ _ _ => True) goal s [a] ↔ Enabled P s a ∧ ∀ o, P.step s a o → goal o :=
  ⟨fun ⟨live, all⟩ => ⟨live, fun o step => (all o step).2⟩,
   fun ⟨live, all⟩ => ⟨live, fun o step => ⟨trivial, all o step⟩⟩⟩

/-- **Some move ensures a goal exactly where some enabled move's next configurations all meet
it.** -/
theorem ensures_iff {P : Process S A} {s : S} {goal : S → Prop} :
    Ensures P s goal ↔ ∃ a, Enabled P s a ∧ ∀ o, P.step s a o → goal o :=
  ⟨fun ⟨a, done⟩ => ⟨a, completes_one_iff.mp done⟩,
   fun ⟨a, done⟩ => ⟨a, completes_one_iff.mpr done⟩⟩

/-- The cover in the core's terms: every enabled move of `P` at `s` has an enabled move of `Q` at
`t` with no further outcome. -/
theorem covers_iff_moves {P : Process S A} {s : S} {Q : Process S B} {t : S} :
    Covers P s Q t ↔
      ∀ a, Enabled P s a → ∃ b, Enabled Q t b ∧ ∀ o, Q.step t b o → P.step s a o :=
  Iff.rfl

/-- **A cover carries every goal one move completes.** -/
theorem Covers.ensures {P : Process S A} {s : S} {Q : Process S B} {t : S}
    (covers : Covers P s Q t) {goal : S → Prop} (ensured : Ensures P s goal) : Ensures Q t goal :=
  match ensures_iff.mp ensured with
  | ⟨a, live, all⟩ => match covers a live with
    | ⟨b, live', inside⟩ => ensures_iff.mpr ⟨b, live', fun o step => all o (inside o step)⟩

/-- **Exactly.** The moves of `Q` at `t` cover those of `P` at `s` exactly where every goal one move
of `P` from `s` completes, one move of `Q` from `t` completes. The converse tests each enabled
move's own outcomes as the goal. -/
theorem covers_iff {P : Process S A} {s : S} {Q : Process S B} {t : S} :
    Covers P s Q t ↔ ∀ goal, Ensures P s goal → Ensures Q t goal :=
  ⟨fun covers _ ensured => covers.ensures ensured,
   fun all a live =>
    match ensures_iff.mp (all (fun o => P.step s a o) (ensures_iff.mpr ⟨a, live, fun _ step => step⟩))
    with
    | ⟨b, live', inside⟩ => ⟨b, live', inside⟩⟩

/-- **Every process's moves cover their own.** -/
theorem covers_refl (P : Process S A) (s : S) : Covers P s P s :=
  fun a live => ⟨a, live, fun _ step => step⟩

/-- **Covering composes.** -/
theorem covers_trans {P : Process S A} {s : S} {Q : Process S B} {t : S} {R : Process S C} {u : S}
    (first : Covers P s Q t) (second : Covers Q t R u) : Covers P s R u :=
  fun a live => match first a live with
  | ⟨b, live', inside⟩ => match second b live' with
    | ⟨c, live'', inside'⟩ => ⟨c, live'', fun o step => inside o (inside' o step)⟩

/-- **A move completing a goal completes every weaker goal.** -/
theorem completes_mono {P : Process S A} {s : S} {a : A} {g h : S → Prop}
    (completes : Completes P (fun _ _ _ => True) g s [a]) (weaker : ∀ o, g o → h o) :
    Completes P (fun _ _ _ => True) h s [a] :=
  match completes_one_iff.mp completes with
  | ⟨live, all⟩ => completes_one_iff.mpr ⟨live, fun o step => weaker o (all o step)⟩

/-- **No move completes the empty goal**: an enabled move has a next configuration. -/
theorem not_ensures_false (P : Process S A) (s : S) : ¬ Ensures P s (fun _ => False) :=
  fun ensured => match ensures_iff.mp ensured with
  | ⟨_, ⟨o, step⟩, all⟩ => all o step

/-- **The full goal is completed exactly where some move is enabled.** -/
theorem ensures_true_iff (P : Process S A) (s : S) :
    Ensures P s (fun _ => True) ↔ ∃ a, Enabled P s a :=
  ⟨fun ensured => match ensures_iff.mp ensured with | ⟨a, live, _⟩ => ⟨a, live⟩,
   fun ⟨a, live⟩ => ensures_iff.mpr ⟨a, live, fun _ _ => trivial⟩⟩

/-- **Where some move is enabled and another process's moves cover it, some goal is ensured by
both.** -/
theorem common_goal {P : Process S A} {s : S} {Q : Process S B} {t : S}
    (enabled : ∃ a, Enabled P s a) (covers : Covers P s Q t) :
    ∃ goal, Ensures P s goal ∧ Ensures Q t goal :=
  have here := (ensures_true_iff P s).mpr enabled
  ⟨fun _ => True, here, covers.ensures here⟩

/-- **No process ensures every goal that another does not.** -/
theorem no_strict_gain_everywhere (P : Process S A) (s : S) (Q : Process S B) (t : S) :
    ¬ ∀ goal, Ensures Q t goal ∧ ¬ Ensures P s goal :=
  fun all => not_ensures_false Q t (all (fun _ => False)).1

/-- **Revisions of a process, each covering the last, cover the first at every stage.** The labels
may change at every revision. -/
theorem covers_along {L : Nat → Type} (P : (n : Nat) → Process S (L n)) (s : Nat → S)
    (each : ∀ n, Covers (P n) (s n) (P (n + 1)) (s (n + 1))) :
    ∀ n, Covers (P 0) (s 0) (P n) (s n)
  | 0 => covers_refl (P 0) (s 0)
  | n + 1 => covers_trans (covers_along P s each n) (each n)

/-- **A cover fails exactly where not every goal one move of `P` from `s` completes is completed
by one move of `Q` from `t`.** Naming a goal that is lost is
`MoveOutcomeProcessesInherited.lost_goal_of_not_covers`, by classical contradiction: from a failed
cover alone a lost goal is not found constructively, since each enabled move's own goal is only
refuted to be lost. -/
theorem not_covers_iff {P : Process S A} {s : S} {Q : Process S B} {t : S} :
    ¬ Covers P s Q t ↔ ¬ ∀ goal, Ensures P s goal → Ensures Q t goal :=
  ⟨fun fails all => fails (covers_iff.mpr all), fun fails covers => fails (covers_iff.mp covers)⟩

/-- **Under double-negation elimination, a failed cover names a lost goal**: the goal of reaching
one of an uncovered move's own outcomes. The principle is a hypothesis; without it the core states
`not_covers_iff`. -/
theorem lost_goal_of_not_covers_of_dne (dne : ∀ p : Prop, ¬ ¬ p → p)
    {P : Process S A} {s : S} {Q : Process S B} {t : S} (fails : ¬ Covers P s Q t) :
    ∃ goal, Ensures P s goal ∧ ¬ Ensures Q t goal :=
  dne _ fun none => fails fun a live =>
    match ensures_iff.mp (dne _ fun lacks =>
      none ⟨fun o => P.step s a o, ensures_iff.mpr ⟨a, live, fun _ step => step⟩, lacks⟩) with
    | ⟨b, live', inside⟩ => ⟨b, live', inside⟩

/-- **A goal on a summary of the outcomes is ensured exactly where its pullback is**: some enabled
move's outcomes all have summaries meeting the goal exactly where one move completes the goal read
back along the summary. -/
theorem summary_ensures_iff {T : Type} (f : S → T) {P : Process S A} {s : S} {goal : T → Prop} :
    (∃ a, Enabled P s a ∧ ∀ p, (∃ o, P.step s a o ∧ f o = p) → goal p) ↔
      Ensures P s (fun o => goal (f o)) :=
  ⟨fun ⟨a, live, all⟩ => ensures_iff.mpr ⟨a, live, fun o step => all (f o) ⟨o, step, rfl⟩⟩,
   fun ensured => match ensures_iff.mp ensured with
    | ⟨a, live, all⟩ => ⟨a, live, fun _ ⟨o, step, same⟩ => same ▸ all o step⟩⟩

/-- **A common response for a belief completes from every configuration the belief holds.** -/
theorem common_completes {R : Type} {P : Process S A} {safe : S → A → S → Prop}
    {goal : S → Prop} {response : R → List A} {belief : S → Prop} {r : R} {s : S}
    (common : CommonResponse P safe goal response belief r) (held : belief s) :
    Completes P safe goal s (response r) :=
  common s held

end Laws

/-! ## Four processes on two configurations -/

/-- The constant law: every configuration goes to `false`. -/
abbrev toFalse : Process Bool Unit := Law.process (fun _ => false)

/-- The free process: a move may go to any configuration. -/
def free : Process Bool Unit := everyStep Bool Unit

/-- The setting process: a move names the next configuration. -/
def setting : Process Bool Bool := ⟨fun _ a o => o = a⟩

/-- The halted process: no move is enabled. -/
def halted : Process Bool Unit := Witnesses.halted Bool Unit

/-- The constant law's move completes reaching `false`. -/
theorem toFalse_ensures_false (s : Bool) : Ensures toFalse s (fun o => o = false) :=
  ensures_iff.mpr ⟨(), ⟨false, rfl⟩, fun _ h => h⟩

/-- Each configuration is reached for certain by the setting process's move naming it. -/
theorem setting_ensures_each (s b : Bool) : Ensures setting s (fun o => o = b) :=
  ensures_iff.mpr ⟨b, ⟨b, rfl⟩, fun _ h => h⟩

/-- The constant law cannot go to `true`. -/
theorem toFalse_not_true (s : Bool) : ¬ ∃ a, toFalse.step s a true :=
  fun ⟨_, (h : true = false)⟩ => Bool.noConfusion h

/-- The setting process's moves cover the constant law's: its move `false` has the law's one
outcome. -/
theorem setting_covers_toFalse (s : Bool) : Covers toFalse s setting s :=
  fun _ _ => ⟨false, ⟨false, rfl⟩, fun _ h => h⟩

/-- **More possible outcomes need not cover.** From every configuration, every configuration the
constant law can go to the free process can go to, and the free process can go to `true`, which
the law cannot, yet the free process's moves do not cover the law's. -/
theorem free_wider_not_covering (s : Bool) :
    (∀ o, (∃ a, toFalse.step s a o) → ∃ a, free.step s a o) ∧
      ((∃ a, free.step s a true) ∧ ¬ ∃ a, toFalse.step s a true) ∧ ¬ Covers toFalse s free s :=
  ⟨fun _ _ => ⟨(), trivial⟩, ⟨⟨(), trivial⟩, toFalse_not_true s⟩,
   fun covers => match covers () ⟨false, rfl⟩ with
    | ⟨_, _, inside⟩ => toFalse_not_true s ⟨(), inside true trivial⟩⟩

/-- **Covering can remove a possibility.** From every configuration, the constant law's moves cover
the free process's, and the free process can go to `true`, which the law cannot. -/
theorem law_covers_free_and_loses (s : Bool) :
    Covers free s toFalse s ∧ (∃ a, free.step s a true) ∧ ¬ ∃ a, toFalse.step s a true :=
  ⟨fun _ _ => ⟨(), ⟨false, rfl⟩, fun _ _ => trivial⟩, ⟨(), trivial⟩, toFalse_not_true s⟩

/-- **A cover can ensure a new goal.** From every configuration, the setting process's moves cover
the constant law's, and one of its moves completes reaching `true`, which no move of the law does. -/
theorem setting_covers_and_gains (s : Bool) :
    Covers toFalse s setting s ∧ Ensures setting s (fun o => o = true) ∧
      ¬ Ensures toFalse s (fun o => o = true) :=
  ⟨setting_covers_toFalse s, ensures_iff.mpr ⟨true, ⟨true, rfl⟩, fun _ h => h⟩,
   fun ensured => match ensures_iff.mp ensured with
    | ⟨_, _, all⟩ => Bool.noConfusion (all false rfl)⟩

/-- **A cover can open what was closed.** From every configuration, the setting process's moves
cover the constant law's; the law cannot go to `true`, and that the setting process cannot is
refuted. -/
theorem setting_covers_and_opens (s : Bool) :
    Covers toFalse s setting s ∧ (¬ ∃ a, toFalse.step s a true) ∧
      ¬ ¬ ∃ a, setting.step s a true :=
  ⟨setting_covers_toFalse s, toFalse_not_true s, fun closed => closed ⟨true, rfl⟩⟩

/-- **Goals ensured separately need not be ensured jointly.** From every configuration, one move of
the setting process completes reaching `false` and one reaching `true`, and no move completes
both. -/
theorem setting_separate_not_joint (s : Bool) :
    Ensures setting s (fun o => o = false) ∧ Ensures setting s (fun o => o = true) ∧
      ¬ Ensures setting s (fun o => o = false ∧ o = true) :=
  ⟨ensures_iff.mpr ⟨false, ⟨false, rfl⟩, fun _ h => h⟩,
   ensures_iff.mpr ⟨true, ⟨true, rfl⟩, fun _ h => h⟩,
   fun ensured => match ensures_iff.mp ensured with
    | ⟨_, ⟨o, step⟩, all⟩ => match all o step with
      | ⟨atFalse, atTrue⟩ => Bool.noConfusion (atFalse.symm.trans atTrue)⟩

/-- **Where no move is enabled, nothing is ensured.** At every configuration of the halted process
every outcome of its move meets the goal `false`, and no move completes it. -/
theorem halted_ensures_nothing (s : Bool) :
    (∀ o, halted.step s () o → o = false) ∧ ¬ Ensures halted s (fun o => o = false) :=
  ⟨fun _ h => False.elim h,
   fun ensured => match ensures_iff.mp ensured with
    | ⟨_, ⟨_, h⟩, _⟩ => h⟩

/-- **A summary can hide a loss.** From every configuration, read through the summary sending every
configuration to `false`, one move of the free process meets `false`; read whole, no move
completes `false`. -/
theorem summary_hides_loss (s : Bool) :
    Ensures free s (fun o => (fun _ : Bool => false) o = false) ∧
      ¬ Ensures free s (fun o => o = false) :=
  ⟨ensures_iff.mpr ⟨(), ⟨false, trivial⟩, fun _ _ => rfl⟩,
   fun ensured => match ensures_iff.mp ensured with
    | ⟨_, _, all⟩ => Bool.noConfusion (all true trivial)⟩

end MoveOutcomeProcesses

end Becoming
