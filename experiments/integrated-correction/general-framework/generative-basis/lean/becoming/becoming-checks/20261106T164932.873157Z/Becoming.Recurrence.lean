import Becoming.Frame
/-!
# Recurrence: what every law of change keeps, loses and returns to

The other modules state laws of amounts, flows and webs. This module states what holds of
every law of change on configurations of any kind, with no premise about it: no balance, no
dissipation, no enclosure and no decidability. A configuration is whatever an unfolding is at
a step. A law is a process of the spine (`Becoming.Frame`) or, where the change is a function
of the configuration, a determined law `next`. That a list holds the configurations is not
assumed of any unfolding; it is the condition written into each law that uses it.

* **Revisiting, with no decidability.** If a list holds the first `l.length + 1`
  configurations of a sequence, two of them coincide (`revisits_within`); membership is used
  as given and nothing about the configurations is decided. A sequence held by a list
  revisits from every step on (`revisits_from`), and so does every run of every process
  whose configurations a list holds (`Run.revisits_from`). Never revisiting needs openness:
  no list holds a sequence that never revisits (`unheld_of_new`, `unlisted_of_new`).
* **A marked change does not recur.** Where a quantity of the configuration never falls and rises
  across every change (`Marks`), change within finitely many configurations does not recur
  (`Marks.change_not_recurring`, `Run.change_not_recurring`); while change recurs there, no quantity
  marks it (`not_marks`).
* **What every law keeps and loses.** Under a determined law a possibility lost stays lost
  (`lost_stays`), and under every process a configuration no longer reachable stays so along
  every continuation (`Reach.lost_stays`). Every configuration reachable from `s` stays
  reachable from `t` exactly when `t` leads back to `s` (`keeps_reach_iff_returns`,
  `same_reach_iff_returns`), and no way back is a lost possibility, `s` itself being one
  (`not_returns_iff_loses`). Configurations merged stay merged: no later step
  tells them apart (`merged_stays`). A law under which every configuration returns merges
  nothing (`lossless_of_returns`), and a configuration that returns can be had at every step
  (`Branching.Returns.reachable`). Undoing is going on: where `s` returns, further steps of the same
  law lead from `next s` back to `s` (`Returns.undo`).
* **What can be realized together, and within how many moves.** A bundle of claims is realized
  together within `n` moves where a course of at most `n` moves ends at a configuration
  realizing every claim of it (`WithinMoves`). A course carries every such bound, its own
  moves counted (`WithinMoves.after_course`); some bound exists exactly where a configuration
  realizing the bundle is reachable (`withinMoves_iff_reach`), so along a course nothing becomes
  realizable together that was not before (`together_after_reach`), and a bundle no longer
  realizable together marks a course with no way back (`lost_together_not_returns`). The bound
  is not kept: a step can shorten it, as the bridge's joint-activation instance shows.
* **Within finitely many configurations, losing nothing is returning.** Where a list holds
  every configuration, three are one: the law merges nothing (`Lossless`), every
  configuration returns, and every configuration can be had at every step
  (`lossless_iff_returns`, `returns_iff_keeps`, `Lossless.returns`, `returns_of_reachable`).
  So a merge loses a possibility for good (`Merges.loses`), and a law that merges nothing
  while some configuration never returns has no list holding every configuration
  (`Lossless.unlisted`). Losing nothing, no quantity that never falls along an orbit rises on
  it (`Lossless.no_rise`), so a quantity that never falls along an orbit and rises at some
  step of it, an arrow, needs a law that merges (`rise_not_lossless`). These laws are the
  grammar's law of finite runs (`Becoming.GrammarLaws`) at the law's relation `next x = y`, whose
  successor is fixed and total (`Law.next_fixed`, `Law.next_total`), where returning is reaching
  itself and merging nothing is a fixed predecessor (`Law.returns_iff_reaches`,
  `Law.lossless_iff_fixedBefore`): `lossless_iff_returns`, `Lossless.returns` and
  `lossless_of_returns` are proved from it. Under every process, the same law at the steps gives
  every configuration returning from a step out of each, with no run supplied
  (`Branching.Lossless.returns_of_total`).
* **Open worlds separate the three.** Counting on (`Nat.succ`) merges nothing, never returns,
  cannot have its beginning again after one step, and rises at every step: an arrow without
  loss (`succ_open`). Counting down (`Nat.pred`) merges zero and one, yet every number can be
  had at every step (`pred_open`).
* **The history kept.** Keeping its history (`withHistory`: the present goes on by the law
  and passes into the past), every law merges nothing (`withHistory_lossless`), never
  revisits (`withHistory_new`) and never returns (`withHistory_never_returns`); its
  beginning cannot be had again after the first step (`withHistory_loses_beginning`), and no
  list holds the kept history of an unfolding (`withHistory_unlisted`). The present of the
  kept history goes on by the law itself (`present_orbit`). Where the present returns, it
  comes back with another history (`return_keeps_history`). Where a list holds the
  configurations an unfolding passes through, the present forgets: from every step on, two
  different histories share one present (`present_forgets`).
* **The law as a process.** A determined law is a process of the spine with one action
  (`Law.process`), and its orbit is a run of it (`Law.run`, `Becoming.Labelled`). Merging,
  merging nothing, returning, being reachable and keeping every possibility are stated once for
  every process (`Branching.Merges`, `Branching.Lossless`, `Branching.Returns`,
  `Branching.Reachable`, `Branching.KeepsPossibilities`); a determined law's are these at its
  process, by definition (`Law.Merges` and the others are abbreviations), and read on the orbit
  they are the familiar forms (`Law.lossless_iff`, `Law.merges_iff`, `Law.returns_iff`,
  `Law.reachable_iff`, `Law.keeps_iff`), a course being an orbit (`Branching.law_trace_iff`,
  `Branching.law_reach_iff`).

So, with no premise: within finitely many configurations a law that merges nothing returns
every configuration and raises nothing, an arrow needs a merge, a merge loses a possibility
for good, and a marked change does not recur. What is merged stays merged and what is lost stays
lost. Becoming that keeps what it passes through loses nothing, never returns and needs an
open world, while its present, held within finitely many configurations, forgets. Readings
of these laws as entropy, as the passing Ren names, or as thermodynamic recurrence belong to
the study, not to this module.

**Classical sources.** `revisits_within` is the pigeonhole principle, a lemma on numbers and lists
proved once in `Becoming.GrammarLaws`, where the law of finite runs needs it below the frame; the
declarations here are its aliases. `lossless_iff_returns`
is the classical fact that an injective self-map of a finite set is a permutation, every point
lying on a cycle; `returns_iff_keeps` adds that it is then surjective at every step. What is the
spine's own is the form: no decidable equality and no choice is used, a list holding the
configurations being the only finiteness.

No ethical predicate, ranking or axiom occurs.

This module imports the frame (`Becoming.Frame`), so that a determined law's notions are those
of its process (one base, board item R28): `Law.process`, the five notions of every process and
the four lemmas reading a course as an orbit are stated here, moved unchanged with their names
from `Becoming.Labelled` and `Becoming.Branching`. The laws of reach along runs (`Law.run`,
`Run.revisits_from`, `keeps_reach_iff_returns`, `not_returns_iff_loses`, `WithinMoves` and what
follows from it) stay in `Becoming.Labelled` (board item W). `Law.SameFuture`, from
`Becoming.Unfolding`, and `trajectory`, from `Becoming.Mechanism`, are stated here (see the
sections so headed).
-/

namespace Becoming

universe u v w

open Generative

namespace Branching

variable {S : Type u} {A : Type v}

/-- `s` can be had `n` steps on: some course of `n` moves leads to it. -/
def Reachable (P : Process S A) (n : Nat) (s : S) : Prop :=
  ∃ x as, as.length = n ∧ Trace P x as s

/-- Every configuration can be had at every step: no possibility is ever lost. -/
def KeepsPossibilities (P : Process S A) : Prop := ∀ n s, Reachable P n s

/-- `s` returns: some step from `s` leads to a configuration from which `s` can be had
again. Under a determined law this is `Law.Returns`, by definition; read on the orbit it is a
period (`Law.returns_iff`). `Web.Restored` (`Becoming.Restoration`, a dependence met again) and
`Becoming.Returns` (`Becoming.Frequency`, a loop of couplings in time order) are other senses. -/
def Returns (P : Process S A) (s : S) : Prop := ∃ a t, P.step s a t ∧ Reach P t s

/-- `P` merges nothing: no configuration is had in one step from two distinct ones. -/
def Lossless (P : Process S A) : Prop := ∀ x y a b t, P.step x a t → P.step y b t → x = y

/-- `P` takes two distinct configurations to one. -/
def Merges (P : Process S A) : Prop := ∃ x y a b t, x ≠ y ∧ P.step x a t ∧ P.step y b t

end Branching

namespace Law

variable {S : Type u}

/-- A determined law as a process of the spine: one action, the step to `next s`. -/
def process (next : S → S) : Process S Unit := ⟨fun s _ t => t = next s⟩

end Law

section Sequences

variable {S : Type u}

/-! ## Revisiting, with no decidability

Pigeonhole, a lemma on numbers and lists, is proved once in `Becoming.GrammarLaws`, where the law
of finite runs needs it below the frame; the declarations here are its aliases, each with its
statement there. -/

/-- Two steps of a sequence at one configuration. -/
def Revisits (g : Nat → S) : Prop := ∃ i j, i < j ∧ g i = g j

/-- A sequence held by a list revisits. -/
theorem revisits_of_held {g : Nat → S} {l : List S} (held : ∀ n, g n ∈ l) : Revisits g :=
  let ⟨i, j, lt, _, same⟩ := revisits_within l g (fun n _ => held n)
  ⟨i, j, lt, same⟩

/-- A sequence held by a list revisits from every step on. -/
theorem revisits_from {g : Nat → S} {l : List S} (held : ∀ n, g n ∈ l) (T : Nat) :
    ∃ i j, T ≤ i ∧ i < j ∧ g i = g j :=
  let ⟨i, j, lt, same⟩ := revisits_of_held (g := fun n => g (T + n)) (fun n => held (T + n))
  ⟨T + i, T + j, Nat.le_add_right T i, Nat.add_lt_add_left lt T, same⟩

/-- **Never revisiting needs openness.** A sequence that never revisits a configuration has
no list holding its first `l.length + 1` values, for any list `l`. -/
theorem unheld_of_new {g : Nat → S} (new : ∀ i j, i < j → g i ≠ g j) (l : List S) :
    ¬ ∀ n, n ≤ l.length → g n ∈ l := fun held =>
  let ⟨i, j, lt, _, same⟩ := revisits_within l g held
  new i j lt same

/-- No list holds a sequence that never revisits. -/
theorem unlisted_of_new {g : Nat → S} (new : ∀ i j, i < j → g i ≠ g j) :
    ¬ ∃ l : List S, ∀ n, g n ∈ l := fun ⟨l, held⟩ =>
  unheld_of_new new l (fun n _ => held n)

/-! ## A mark of every change -/

/-- `q` marks the changes of `g`: a quantity of the configuration that never falls along `g`
and rises across every step at which the configuration changes. -/
def Marks (q : S → Nat) (g : Nat → S) : Prop :=
  ∀ n, q (g n) ≤ q (g (n + 1)) ∧ (g (n + 1) ≠ g n → q (g n) < q (g (n + 1)))

/-- The sum of `q` over a list, which bounds `q` on its members. -/
def sumOver (q : S → Nat) : List S → Nat
  | [] => 0
  | a :: l => q a + sumOver q l

theorem le_sumOver (q : S → Nat) {s : S} {l : List S} (mem : s ∈ l) : q s ≤ sumOver q l := by
  induction mem with
  | head => exact Nat.le_add_right _ _
  | tail _ _ ih => exact Nat.le_trans ih (Nat.le_add_left _ _)

/-- A quantity that never falls along a sequence never falls over any stretch. -/
theorem never_falls_over {q : S → Nat} {g : Nat → S} (step : ∀ n, q (g n) ≤ q (g (n + 1)))
    (T : Nat) : ∀ k, q (g T) ≤ q (g (T + k))
  | 0 => Nat.le_refl _
  | k + 1 => Nat.le_trans (never_falls_over step T k) (step (T + k))

theorem Marks.mono {q : S → Nat} {g : Nat → S} (marks : Marks q g) (T : Nat) :
    ∀ k, q (g T) ≤ q (g (T + k)) :=
  never_falls_over (fun n => (marks n).1) T

/-- **Within finitely many configurations, a marked change does not recur.** Where a list holds the
configurations of `g` and a quantity marks each of its changes, change does not recur. -/
theorem Marks.change_not_recurring {q : S → Nat} {g : Nat → S} (marks : Marks q g) {l : List S}
    (held : ∀ n, g n ∈ l) : ¬ ∀ T, ∃ k, T ≤ k ∧ g (k + 1) ≠ g k := fun recurs =>
  have climb : ∀ m, ∃ t, m ≤ q (g t) := fun m => by
    induction m with
    | zero => exact ⟨0, Nat.zero_le _⟩
    | succ m ih =>
      let ⟨t, le⟩ := ih
      let ⟨k, after, change⟩ := recurs t
      let ⟨d, same⟩ := le_dest after
      have up : q (g t) ≤ q (g k) := by rw [same]; exact marks.mono t d
      exact ⟨k + 1, Nat.lt_of_le_of_lt (Nat.le_trans le up) ((marks k).2 change)⟩
  let ⟨t, above⟩ := climb (sumOver q l + 1)
  Nat.lt_irrefl _ (Nat.lt_of_lt_of_le above (le_sumOver q (held t)))

/-- While change recurs within finitely many configurations, no quantity marks it. -/
theorem not_marks {g : Nat → S} {l : List S} (held : ∀ n, g n ∈ l)
    (recurs : ∀ T, ∃ k, T ≤ k ∧ g (k + 1) ≠ g k) (q : S → Nat) : ¬ Marks q g :=
  fun marks => marks.change_not_recurring held recurs

end Sequences

/-! ## A determined law -/

namespace Law

variable {S : Type u}

/-- The configuration `n` steps after `s` under the law `next`. -/
def orbit (next : S → S) (s : S) : Nat → S
  | 0 => s
  | n + 1 => next (orbit next s n)

theorem orbit_add (next : S → S) (s : S) (m : Nat) :
    ∀ n, orbit next s (m + n) = orbit next (orbit next s m) n
  | 0 => rfl
  | n + 1 => congrArg next (orbit_add next s m n)

theorem orbit_shift (next : S → S) (s : S) (n : Nat) :
    orbit next s (n + 1) = orbit next (next s) n :=
  (congrArg (orbit next s) (Nat.add_comm n 1)).trans (orbit_add next s 1 n)

/-- A determined law's orbit is its `n` steps: `orbit next s n` is had from `s` by `n` steps of the
law's process. -/
theorem steps_orbit (next : S → S) : ∀ (n : Nat) (s : S),
    «迭» (fun x y => (process next).step x () y) n s (orbit next s n)
  | 0, _ => rfl
  | n + 1, s => ⟨next s, rfl,
      Eq.subst (motive := fun z => «迭» (fun x y => (process next).step x () y) n (next s) z)
        (orbit_shift next s n).symm (steps_orbit next n (next s))⟩

/-- The steps of a determined law's process have a fixed successor. -/
theorem step_fixed (next : S → S) : «定后» (fun x y => (process next).step x () y) :=
  fun _ _ ⟨_, e₁, e₂⟩ => e₁.trans e₂.symm

/-- A configuration had again after `p` steps is had again after every multiple of `p`: the
grammar's law of loops (`«迭之周»`) at the law's steps, read back on the orbit by the fixed
successor (`«迭之定»`). -/
theorem orbit_mul {next : S → S} {s : S} {p : Nat} (back : orbit next s p = s) :
    ∀ k, orbit next s (p * k) = s :=
  fun k => «迭之定» (step_fixed next) (p * k) (steps_orbit next (p * k) s)
    («迭之周» (Eq.subst (motive := fun w => «迭» (fun x y => (process next).step x () y) p s w) back
      (steps_orbit next p s)) k)

end Law

namespace Branching

variable {S : Type u}

theorem units_length : ∀ n, (List.replicate n ()).length = n
  | 0 => rfl
  | n + 1 => congrArg Nat.succ (units_length n)

theorem law_trace_of {next : S → S} :
    ∀ (as : List Unit) (x t : S), Law.orbit next x as.length = t →
      Trace (Law.process next) x as t
  | [], x, _, to => Eq.subst (motive := fun z => Trace (Law.process next) x [] z) to (.nil x)
  | _ :: as, x, t, to =>
    .cons (rfl : next x = next x)
      (law_trace_of as (next x) t ((Law.orbit_shift next x as.length).symm.trans to))

/-- A course of a determined law is its orbit. -/
theorem law_trace_iff {next : S → S} {x t : S} {as : List Unit} :
    Trace (Law.process next) x as t ↔ Law.orbit next x as.length = t :=
  ⟨fun path => by
    induction path with
    | nil => rfl
    | @cons s _ _ _ as step _ ih =>
      exact (Law.orbit_shift next s as.length).trans
        ((congrArg (fun z => Law.orbit next z as.length) step.symm).trans ih),
   law_trace_of as x t⟩

theorem law_reach_iff {next : S → S} {x t : S} :
    Reach (Law.process next) x t ↔ ∃ n, Law.orbit next x n = t :=
  ⟨fun ⟨as, path⟩ => ⟨as.length, law_trace_iff.mp path⟩,
   fun ⟨n, to⟩ => ⟨List.replicate n (), law_trace_iff.mpr
     (Eq.subst (motive := fun k => Law.orbit next x k = t) (units_length n).symm to)⟩⟩

end Branching

/-! ### What every process keeps and loses (moved from `Becoming.Branching`)

Stated once for every process; a determined law's forms are these at `Law.process next`, by the
abbreviations below, or along its run (`Law.run`). -/

namespace Law

variable {S : Type u}

/-- The run of a determined law from `s`. -/
def run (next : S → S) (s : S) : Run (process next) :=
  ⟨orbit next s, fun _ => (), fun _ => rfl⟩

theorem run_state (next : S → S) (s : S) : (run next s).state = orbit next s := rfl

end Law

namespace Run

variable {S : Type u} {A : Type v} {P : Process S A}

/-- A run read from step `i` on. `Parting.after` is this (`Parting.after_eq_onward`). -/
def onward (r : Run P) (i : Nat) : Run P :=
  ⟨fun n => r.state (i + n), fun n => r.act (i + n), fun n => r.step (i + n)⟩

end Run

namespace Branching

variable {S : Type u} {A : Type v} {P : Process S A}

theorem Merges.not_lossless (merges : Merges P) : ¬ Lossless P :=
  fun lossless => match merges with
  | ⟨_, _, _, _, _, apart, step, step'⟩ => apart (lossless _ _ _ _ _ step step')

/-- A course of one step more is, without its first step, a course of `n` steps. -/
theorem Reachable.earlier {n : Nat} {s : S} : Reachable P (n + 1) s → Reachable P n s
  | ⟨_, [], len, _⟩ => nomatch len
  | ⟨_, _ :: as, len, .cons _ rest⟩ => ⟨_, as, Nat.succ.inj len, rest⟩

/-- **A possibility lost stays lost**, under every process. -/
theorem lost_stays {n : Nat} {s : S} (lost : ¬ Reachable P n s) : ∀ k, ¬ Reachable P (n + k) s
  | 0 => lost
  | k + 1 => fun reach => lost_stays lost k reach.earlier

/-- A course ending at `s` is empty or ends by a step into `s`. -/
theorem trace_last {x s : S} {as : List A} (path : Trace P x as s) :
    x = s ∨ ∃ y a, Reach P x y ∧ P.step y a s := by
  induction path with
  | nil => exact .inl rfl
  | cons step _ ih =>
    match ih with
    | .inl same =>
      exact .inr ⟨_, _, Reach.refl P _, Eq.subst (motive := fun z => P.step _ _ z) same step⟩
    | .inr ⟨y, a, reach, last⟩ => exact .inr ⟨y, a, (Reach.of_step step).trans reach, last⟩

/-- A configuration that returns is had at the next step from a configuration that returns. -/
theorem Returns.pred {s : S} : Returns P s → ∃ x a, P.step x a s ∧ Returns P x
  | ⟨a, t, step, _, path⟩ => match trace_last path with
    | .inl same =>
      ⟨s, a, Eq.subst (motive := fun z => P.step s a z) same step, a, t, step, _, path⟩
    | .inr ⟨y, b, reach, last⟩ => ⟨y, b, last, b, s, last, (Reach.of_step step).trans reach⟩

/-- Courses of every length end at a configuration that returns, from configurations that
return. -/
theorem Returns.reachable_from {s : S} (returns : Returns P s) :
    ∀ n, ∃ x as, as.length = n ∧ Trace P x as s ∧ Returns P x
  | 0 => ⟨s, [], rfl, .nil s, returns⟩
  | n + 1 => match Returns.reachable_from returns n with
    | ⟨_, as, len, path, back⟩ => match back.pred with
      | ⟨y, a, step, back'⟩ => ⟨y, a :: as, congrArg Nat.succ len, .cons step path, back'⟩

/-- **A configuration that returns can be had at every step**, under every process. -/
theorem Returns.reachable {s : S} (returns : Returns P s) (n : Nat) : Reachable P n s :=
  match returns.reachable_from n with
  | ⟨x, as, len, path, _⟩ => ⟨x, as, len, path⟩

/-- **Returning is reaching itself along the steps**, under every process: a first step, then
lying within the closure of the steps (`«及当且仅当一步而所闭»`, `reach_iff_withinClosure`). -/
theorem returns_iff_reaches {s : S} : Returns P s ↔ «及» (Steps P) s s :=
  ⟨fun ⟨a, t, step, reach⟩ => «及当且仅当一步而所闭».mpr ⟨t, ⟨a, step⟩, reach_iff_withinClosure.mp reach⟩,
   fun reach => match «及当且仅当一步而所闭».mp reach with
    | ⟨t, ⟨a, step⟩, within⟩ => ⟨a, t, step, reach_iff_withinClosure.mpr within⟩⟩

/-- **Merging nothing is a fixed predecessor of the steps**, under every process. -/
theorem lossless_iff_fixedBefore : Lossless P ↔ «定前» (Steps P) :=
  ⟨fun lossless x y ⟨_, ⟨a, s₁⟩, ⟨b, s₂⟩⟩ => lossless x y a b _ s₁ s₂,
   fun fixed x y a b _ s₁ s₂ => fixed x y ⟨_, ⟨a, s₁⟩, ⟨b, s₂⟩⟩⟩

/-- Merging nothing, where two steps of a run are at one configuration, so are the steps as
many before them, back to the beginning: the grammar's law (`«定前则线可退»`) at the steps, the run
being the line, up to the later of the two steps. -/
theorem Lossless.cancel (lossless : Lossless P) (r : Run P) :
    ∀ i d, r.state i = r.state (i + d) → r.state 0 = r.state d :=
  fun i d same => «定前则线可退» (N := i + d) (lossless_iff_fixedBefore.mp lossless)
    (fun k _ => ⟨r.act k, r.step k⟩) i d (Nat.le_refl _) same

/-- **Merging nothing within finitely many configurations, a run comes back to where it
began.** Where a list holds the configurations of a run of a process that merges nothing, the
run is at its first configuration again after some steps: the grammar's line law
(`«线有限不并则回»`) at the steps, the run being the line. -/
theorem Lossless.comes_back (lossless : Lossless P) (r : Run P) {l : List S}
    (held : ∀ n, r.state n ∈ l) : ∃ d, 0 < d ∧ r.state d = r.state 0 :=
  match «线有限不并则回» («定前则线不并» (lossless_iff_fixedBefore.mp lossless) r.state l.length)
      (fun i _ => ⟨r.act i, r.step i⟩) (fun n _ => held n) with
  | ⟨d, pos, _, back⟩ => ⟨d, pos, back⟩

/-- **Merging nothing within finitely many configurations, every configuration of a run comes
back on the run itself.** -/
theorem Lossless.recurs (lossless : Lossless P) (r : Run P) {l : List S}
    (held : ∀ n, r.state n ∈ l) (i : Nat) : ∃ d, 0 < d ∧ r.state (i + d) = r.state i :=
  lossless.comes_back (r.onward i) (fun n => held (i + n))

/-- **Merging nothing within finitely many configurations, a configuration with a run returns**,
where some run begins at the configuration: the grammar's line law (`«线有限定前则返»`) at the
steps, the run being the line. -/
theorem Lossless.returns (lossless : Lossless P) {all : List S} (every : ∀ s, s ∈ all)
    (r : Run P) : Returns P (r.state 0) :=
  returns_iff_reaches.mpr
    («线有限定前则返» (l := all) (lossless_iff_fixedBefore.mp lossless)
      (fun i _ => ⟨r.act i, r.step i⟩) (fun _ _ => every _))

/-- **Merging nothing within finitely many configurations, with a step from each, every
configuration returns**, under every process, with no run supplied: the grammar's law of finite
runs (`«有限遍后定前则皆返»`) at the steps. `Lossless.returns` supplies a run from the configuration;
here a step from every configuration supplies it. -/
theorem Lossless.returns_of_total (lossless : Lossless P) {all : List S}
    (every : ∀ s, s ∈ all) (total : ∀ s, ∃ a t, P.step s a t) (s : S) : Returns P s :=
  returns_iff_reaches.mpr
    («有限遍后定前则皆返» every (fun x => match total x with | ⟨a, t, step⟩ => ⟨t, a, step⟩)
      (lossless_iff_fixedBefore.mp lossless) s)

/-- **Merging nothing within finitely many configurations, nothing rises along a run.** A
quantity that never falls along a run keeps its value across every step. -/
theorem Lossless.no_rise (lossless : Lossless P) (r : Run P) {l : List S}
    (held : ∀ n, r.state n ∈ l) {q : S → Nat}
    (step : ∀ n, q (r.state n) ≤ q (r.state (n + 1))) (n : Nat) :
    q (r.state (n + 1)) = q (r.state n) :=
  match lossless.recurs r held n with
  | ⟨0, pos, _⟩ => absurd pos (Nat.lt_irrefl 0)
  | ⟨e + 1, _, back⟩ =>
    have far : q (r.state (n + 1)) ≤ q (r.state (n + 1 + e)) :=
      never_falls_over (g := r.state) step (n + 1) e
    have same : r.state (n + 1 + e) = r.state n :=
      (congrArg r.state (Nat.succ_add n e)).trans back
    Nat.le_antisymm (Nat.le_trans far (Nat.le_of_eq (congrArg q same))) (step n)

/-- **Within finitely many configurations, a rise along a run needs a merge.** -/
theorem rise_not_lossless (r : Run P) {l : List S} (held : ∀ n, r.state n ∈ l) {q : S → Nat}
    (step : ∀ n, q (r.state n) ≤ q (r.state (n + 1))) {n : Nat}
    (rises : q (r.state n) < q (r.state (n + 1))) : ¬ Lossless P :=
  fun lossless => Nat.ne_of_lt rises (lossless.no_rise r held step n).symm

/-- **Merging nothing, a run from a configuration that never returns needs openness.** -/
theorem Lossless.unlisted (lossless : Lossless P) (r : Run P) (never : ¬ Returns P (r.state 0)) :
    ¬ ∃ all : List S, ∀ s, s ∈ all :=
  fun ⟨_, every⟩ => never (lossless.returns every r)

end Branching

namespace Law

variable {S : Type u}

/-- `next` merges nothing: distinct configurations go on to distinct configurations
(`lossless_iff`); merging nothing as a process (`Branching.Lossless`) at `process next`. -/
abbrev Lossless (next : S → S) : Prop := Branching.Lossless (process next)

/-- `next` takes two distinct configurations to one (`merges_iff`); merging as a process at
`process next`. -/
abbrev Merges (next : S → S) : Prop := Branching.Merges (process next)

/-- `s` comes back after some steps (`returns_iff`): returning as a process
(`Branching.Returns`, read on reach) at `process next`. Other senses of the name: `Web.Restored` of
`Becoming.Restoration` is a dependence met again at a later step, and `Becoming.Returns` of
`Becoming.Frequency` is a loop of couplings in time order, neither a configuration coming back. -/
abbrev Returns (next : S → S) (s : S) : Prop := Branching.Returns (process next) s

/-- `s` can still be had `n` steps on: some configuration leads to it in `n` steps
(`reachable_iff`); `Branching.Reachable` at `process next`. -/
abbrev Reachable (next : S → S) (n : Nat) (s : S) : Prop := Branching.Reachable (process next) n s

/-- Every configuration can be had at every step: no possibility is ever lost (`keeps_iff`);
`Branching.KeepsPossibilities` at `process next`. -/
abbrev KeepsPossibilities (next : S → S) : Prop := Branching.KeepsPossibilities (process next)

/-- Merging nothing, read on the orbit. -/
theorem lossless_iff {next : S → S} : Lossless next ↔ ∀ x y, next x = next y → x = y :=
  ⟨fun lossless x y same => lossless x y () () (next x) rfl same,
   fun lossless x y _ _ _ step step' => lossless x y (step.symm.trans step')⟩

/-- Merging, read on the orbit. -/
theorem merges_iff {next : S → S} : Merges next ↔ ∃ x y, x ≠ y ∧ next x = next y :=
  ⟨fun ⟨x, y, _, _, _, apart, step, step'⟩ => ⟨x, y, apart, step.symm.trans step'⟩,
   fun ⟨x, y, apart, same⟩ => ⟨x, y, (), (), next x, apart, rfl, same⟩⟩

/-- Being reachable, read on the orbit. -/
theorem reachable_iff {next : S → S} {n : Nat} {s : S} :
    Reachable next n s ↔ ∃ x, orbit next x n = s :=
  ⟨fun ⟨x, _, len, path⟩ =>
    ⟨x, Eq.subst (motive := fun k => orbit next x k = s) len (Branching.law_trace_iff.mp path)⟩,
   fun ⟨x, to⟩ => ⟨x, List.replicate n (), Branching.units_length n, Branching.law_trace_iff.mpr
     (Eq.subst (motive := fun k => orbit next x k = s) (Branching.units_length n).symm to)⟩⟩

/-- Keeping every possibility, read on the orbit. -/
theorem keeps_iff {next : S → S} : KeepsPossibilities next ↔ ∀ n s, ∃ x, orbit next x n = s :=
  ⟨fun keeps n s => reachable_iff.mp (keeps n s), fun keeps n s => reachable_iff.mpr (keeps n s)⟩

/-- Returning, read on the orbit. -/
theorem returns_iff {next : S → S} {s : S} : Returns next s ↔ ∃ p, 0 < p ∧ orbit next s p = s :=
  ⟨fun ⟨_, _, step, reach⟩ => match Branching.law_reach_iff.mp reach with
    | ⟨k, back⟩ => ⟨k + 1, Nat.succ_pos k, (orbit_shift next s k).trans
        ((congrArg (fun z => orbit next z k) step.symm).trans back)⟩,
   fun ⟨p, pos, back⟩ => match p, pos, back with
    | k + 1, _, back => ⟨(), next s, rfl,
        Branching.law_reach_iff.mpr ⟨k, (orbit_shift next s k).symm.trans back⟩⟩⟩

/-! ### The law as a relation of the grammar

A determined law is the relation `next x = y`: its successor is fixed and every configuration has
one. Read so, returning is reaching itself and merging nothing is a fixed predecessor, and the
laws of finite runs below are the grammar's (`Becoming.GrammarLaws`) at this relation. -/

/-- A determined law has a fixed successor. -/
theorem next_fixed (next : S → S) : «定后» (fun x y => next x = y) :=
  fun _ _ ⟨_, e₁, e₂⟩ => e₁.symm.trans e₂

/-- Under a determined law every configuration has a successor. -/
theorem next_total (next : S → S) : ∀ x, ∃ y, next x = y := fun x => ⟨next x, rfl⟩

/-- What is had `n + 1` steps on is reached. -/
theorem reaches_of_orbit {next : S → S} : ∀ (n : Nat) {s y : S}, orbit next s (n + 1) = y →
    «及» (fun x y => next x = y) s y
  | 0, _, _, to => .one to
  | n + 1, s, _, to => .more rfl (reaches_of_orbit n ((orbit_shift next s (n + 1)).symm.trans to))

/-- Reaching along a law is being had some positive number of steps on its orbit. -/
theorem reaches_iff_orbit {next : S → S} {s y : S} :
    «及» (fun x y => next x = y) s y ↔ ∃ n, orbit next s (n + 1) = y :=
  ⟨fun reach => by
    induction reach with
    | one e => exact ⟨0, e⟩
    | @more x _ _ e _ ih => exact match ih with
      | ⟨n, to⟩ => ⟨n + 1, (orbit_shift next x (n + 1)).trans (by cases e; exact to)⟩,
   fun ⟨n, to⟩ => reaches_of_orbit n to⟩

/-- **Returning is reaching itself.** -/
theorem returns_iff_reaches {next : S → S} {s : S} :
    Returns next s ↔ «及» (fun x y => next x = y) s s :=
  returns_iff.trans
    ⟨fun ⟨p, pos, back⟩ => match p, pos, back with
      | n + 1, _, back => reaches_iff_orbit.mpr ⟨n, back⟩,
     fun reach => match reaches_iff_orbit.mp reach with
      | ⟨n, back⟩ => ⟨n + 1, Nat.succ_pos n, back⟩⟩

/-- **Merging nothing is the grammar's fixed predecessor.** -/
theorem lossless_iff_fixedBefore {next : S → S} : Lossless next ↔ «定前» (fun x y => next x = y) :=
  lossless_iff.trans
    ⟨fun lossless x y ⟨_, e₁, e₂⟩ => lossless x y (e₁.trans e₂.symm),
     fun fixed x y same => fixed x y ⟨next x, rfl, same.symm⟩⟩

/-! ### What every law keeps and loses -/

/-- **A possibility lost stays lost**, under every law: the case of `Branching.lost_stays` at the
law's process. -/
theorem lost_stays {next : S → S} {n : Nat} {s : S} (lost : ¬ Reachable next n s) :
    ∀ k, ¬ Reachable next (n + k) s :=
  Branching.lost_stays lost

/-- **Configurations merged stay merged**: no later step tells them apart. -/
theorem merged_stays {next : S → S} {x y : S} (merged : next x = next y) (n : Nat) :
    orbit next x (n + 1) = orbit next y (n + 1) :=
  (orbit_shift next x n).trans
    ((congrArg (fun z => orbit next z n) merged).trans (orbit_shift next y n).symm)

/-- Merging nothing at a step, a law merges nothing over any number of steps: the grammar's law
(`«迭之定前»`) at the law's steps. -/
theorem Lossless.cancel {next : S → S} (lossless : Lossless next) {x y : S} :
    ∀ n, orbit next x n = orbit next y n → x = y :=
  fun n same => «迭之定前» (fun a b ⟨z, e₁, e₂⟩ => lossless a b () () z e₁ e₂) n
    (steps_orbit next n x)
    (Eq.subst (motive := fun w => «迭» (fun x y => (process next).step x () y) n y w) same.symm
      (steps_orbit next n y))

/-- A law under which every configuration returns merges nothing: the grammar's law for a fixed
successor (`«皆返定后则定前»`) at the law's relation. -/
theorem lossless_of_returns {next : S → S} (returns : ∀ s, Returns next s) : Lossless next :=
  lossless_iff_fixedBefore.mpr
    («皆返定后则定前» (next_fixed next) fun s => returns_iff_reaches.mp (returns s))

/-- **Undoing is going on.** Where `s` returns, the step from `s` is undone only by going on
under the same law: further steps lead from `next s` back to `s`. -/
theorem Returns.undo {next : S → S} {s : S} (returns : Returns next s) :
    ∃ k, orbit next (next s) k = s :=
  match returns_iff.mp returns with
  | ⟨0, pos, _⟩ => absurd pos (Nat.lt_irrefl 0)
  | ⟨k + 1, _, back⟩ => ⟨k, (orbit_shift next s k).symm.trans back⟩

/-! ### Finitely many configurations -/

/-- **Losing nothing, everything returns**, where a list holds every configuration: the grammar's
law of finite runs (`«有限遍后定前则皆返»`) at the law's relation. -/
theorem Lossless.returns {next : S → S} (lossless : Lossless next) {all : List S}
    (every : ∀ s, s ∈ all) (s : S) : Returns next s :=
  returns_iff_reaches.mpr
    («有限遍后定前则皆返» every (next_total next) (lossless_iff_fixedBefore.mp lossless) s)

/-- Where a list holds every configuration, a configuration that can be had as many steps on
as the list is long returns: the grammar's law (`«定后于线有限则末返»`) at the law's relation, the
orbit being the line. -/
theorem returns_of_reachable {next : S → S} {all : List S} (every : ∀ s, s ∈ all) {s : S}
    (reach : Reachable next all.length s) : Returns next s :=
  match reachable_iff.mp reach with
  | ⟨x, to⟩ => returns_iff_reaches.mpr
      (Eq.subst (motive := fun w => «及» (fun x y => next x = y) w w) to
        («定后于线有限则末返» (g := orbit next x) («定后则定后于» (next_fixed next) x)
          (fun _ _ => rfl) (fun _ _ => every _)))

/-- **Losing nothing within finitely many configurations, nothing rises.** Where a list holds
every configuration and the law merges nothing, a quantity that never falls along an orbit
keeps its value along it: step by step, the law of every process
(`Branching.Lossless.no_rise`) along the law's run from `s`. -/
theorem Lossless.no_rise {next : S → S} (lossless : Lossless next) {all : List S}
    (every : ∀ s, s ∈ all) {q : S → Nat} {s : S}
    (step : ∀ n, q (orbit next s n) ≤ q (orbit next s (n + 1))) :
    ∀ n, q (orbit next s n) = q s
  | 0 => rfl
  | n + 1 => (Branching.Lossless.no_rise lossless (run next s) (fun _ => every _) step n).trans
      (Lossless.no_rise lossless every step n)

/-- **Within finitely many configurations, a rise needs a merge.** Where a list holds every
configuration and a quantity never falls along an orbit yet rises at some step of it, the law
does not merge nothing: the law of every process (`Branching.rise_not_lossless`) along the
law's run from `s`. -/
theorem rise_not_lossless {next : S → S} {all : List S} (every : ∀ s, s ∈ all) {q : S → Nat}
    {s : S} (step : ∀ n, q (orbit next s n) ≤ q (orbit next s (n + 1))) {n : Nat}
    (rises : q (orbit next s n) < q (orbit next s (n + 1))) : ¬ Lossless next :=
  Branching.rise_not_lossless (run next s) (fun _ => every _) step rises

/-- **Within finitely many configurations, losing nothing is returning.** Where a list holds
every configuration, a law merges nothing exactly where every configuration returns: the grammar's
law of finite runs (`«有限遍后定后则定前当且仅当皆返»`) at the law's relation. -/
theorem lossless_iff_returns {next : S → S} {all : List S} (every : ∀ s, s ∈ all) :
    Lossless next ↔ ∀ s, Returns next s :=
  lossless_iff_fixedBefore.trans
    ((«有限遍后定后则定前当且仅当皆返» every (next_total next) (next_fixed next)).trans
      ⟨fun loops s => returns_iff_reaches.mpr (loops s),
       fun returns s => returns_iff_reaches.mp (returns s)⟩)

/-- **Within finitely many configurations, returning is keeping every possibility.** -/
theorem returns_iff_keeps {next : S → S} {all : List S} (every : ∀ s, s ∈ all) :
    (∀ s, Returns next s) ↔ KeepsPossibilities next :=
  ⟨fun returns n s => (returns s).reachable n,
    fun keeps s => returns_of_reachable every (keeps all.length s)⟩

/-- Within finitely many configurations, keeping the possibilities of one more step than
there are configurations already keeps every possibility, and merges nothing. -/
theorem lossless_of_reachable {next : S → S} {all : List S} (every : ∀ s, s ∈ all)
    (reach : ∀ s, Reachable next all.length s) : Lossless next :=
  lossless_of_returns fun s => returns_of_reachable every (reach s)

/-- **Within finitely many configurations, a merge loses a possibility for good**: some
configuration cannot be had as many steps on as there are configurations, nor at any later
step (`lost_stays`). -/
theorem Merges.loses {next : S → S} (merges : Merges next) {all : List S}
    (every : ∀ s, s ∈ all) : ¬ ∀ s, Reachable next all.length s :=
  fun reach => merges.not_lossless (lossless_of_reachable every reach)

/-- **Losing nothing without return needs openness.** A law that merges nothing and under
which some configuration never returns has no list holding every configuration: the law of every
process (`Branching.Lossless.unlisted`) along the law's run from `s`. -/
theorem Lossless.unlisted {next : S → S} (lossless : Lossless next) {s : S}
    (never : ¬ Returns next s) : ¬ ∃ all : List S, ∀ x, x ∈ all :=
  Branching.Lossless.unlisted lossless (run next s) never

/-! ### Open witnesses -/

theorem succ_orbit (s : Nat) : ∀ n, orbit Nat.succ s n = s + n
  | 0 => rfl
  | n + 1 => congrArg Nat.succ (succ_orbit s n)

/-- **Counting on loses nothing and never returns.** Under `Nat.succ` nothing merges, nothing
returns, and the beginning can no longer be had after one step. -/
theorem succ_open :
    Lossless Nat.succ ∧ (∀ s, ¬ Returns Nat.succ s) ∧ ¬ Reachable Nat.succ 1 0 ∧
      ∀ s n, orbit Nat.succ s n < orbit Nat.succ s (n + 1) :=
  ⟨lossless_iff.mpr fun _ _ same => Nat.succ.inj same,
    fun s returns => let ⟨p, pos, back⟩ := returns_iff.mp returns; Nat.lt_irrefl s (Nat.lt_of_lt_of_le (Nat.lt_add_of_pos_right pos)
      (Nat.le_of_eq ((succ_orbit s p).symm.trans back))),
    fun reach => let ⟨x, to⟩ := reachable_iff.mp reach; Nat.add_one_ne_zero x to,
    fun _ _ => Nat.lt_succ_self _⟩

theorem pred_orbit : ∀ n t, orbit Nat.pred (t + n) n = t
  | 0, _ => rfl
  | n + 1, t => congrArg Nat.pred
      ((congrArg (fun x => orbit Nat.pred x n) (Nat.succ_add t n).symm).trans
        (pred_orbit n (t + 1)))

/-- **Counting down merges and keeps every possibility.** Under `Nat.pred` zero and one go to
zero, yet every number can be had at every step: in an open world a merge need not lose a
possibility. -/
theorem pred_open : Merges Nat.pred ∧ KeepsPossibilities Nat.pred :=
  ⟨merges_iff.mpr ⟨0, 1, fun same => Nat.noConfusion same, rfl⟩,
    keeps_iff.mpr fun n t => ⟨t + n, pred_orbit n t⟩⟩

/-! ### The history kept -/

/-- The law with its history kept: the present goes on by `next` and passes into the past. -/
def withHistory (next : S → S) (h : S × List S) : S × List S := (next h.1, h.1 :: h.2)

/-- **Keeping its history, every law loses nothing.** -/
theorem withHistory_lossless (next : S → S) : Lossless (withHistory next) := by
  refine lossless_iff.mpr ?_
  intro ⟨a, p⟩ ⟨b, q⟩ same
  have tails : a :: p = b :: q := congrArg Prod.snd same
  have ⟨ha, hp⟩ := List.cons.inj tails
  subst ha
  subst hp
  rfl

theorem past_length (next : S → S) (h : S × List S) :
    ∀ n, (orbit (withHistory next) h n).2.length = h.2.length + n
  | 0 => rfl
  | n + 1 => congrArg Nat.succ (past_length next h n)

/-- The present of the kept history goes on by the law itself. -/
theorem present_orbit (next : S → S) (h : S × List S) :
    ∀ n, (orbit (withHistory next) h n).1 = orbit next h.1 n
  | 0 => rfl
  | n + 1 => congrArg next (present_orbit next h n)

/-- **The kept history never revisits.** -/
theorem withHistory_new (next : S → S) (h : S × List S) {i j : Nat} (lt : i < j) :
    orbit (withHistory next) h i ≠ orbit (withHistory next) h j := fun same =>
  Nat.ne_of_lt (Nat.add_lt_add_left lt h.2.length)
    ((past_length next h i).symm.trans
      ((congrArg (fun x => x.2.length) same).trans (past_length next h j)))

/-- **Keeping its history, nothing returns.** -/
theorem withHistory_never_returns (next : S → S) (h : S × List S) :
    ¬ Returns (withHistory next) h :=
  fun returns => let ⟨_, pos, back⟩ := returns_iff.mp returns; withHistory_new next h pos back.symm

/-- **Keeping its history, the beginning is lost at the first step.** No kept history with
nothing past can be had one or more steps on. -/
theorem withHistory_loses_beginning (next : S → S) (s : S) (n : Nat) :
    ¬ Reachable (withHistory next) (n + 1) (s, []) := fun reach => let ⟨x, to⟩ := reachable_iff.mp reach
  Nat.add_one_ne_zero (x.2.length + n)
    ((past_length next x (n + 1)).symm.trans (congrArg (fun y => y.2.length) to))

/-- **Keeping its history needs openness.** No list holds the kept history of an unfolding. -/
theorem withHistory_unlisted (next : S → S) (h : S × List S) :
    ¬ ∃ l : List (S × List S), ∀ n, orbit (withHistory next) h n ∈ l :=
  fun ⟨_, held⟩ =>
    let ⟨_, _, lt, same⟩ := revisits_of_held held
    withHistory_new next h lt same

/-- **A finite present forgets.** Where a list holds the configurations an unfolding passes
through, from every step on two different kept histories share one present. -/
theorem present_forgets (next : S → S) {s : S} {l : List S} (held : ∀ n, orbit next s n ∈ l)
    (T : Nat) :
    ∃ i j, T ≤ i ∧ i < j ∧
      (orbit (withHistory next) (s, []) i).1 = (orbit (withHistory next) (s, []) j).1 ∧
      orbit (withHistory next) (s, []) i ≠ orbit (withHistory next) (s, []) j :=
  let ⟨i, j, le, lt, same⟩ := revisits_from held T
  ⟨i, j, le, lt,
    (present_orbit next (s, []) i).trans (same.trans (present_orbit next (s, []) j).symm),
    withHistory_new next (s, []) lt⟩

/-- **The present comes back; the history does not.** Where `s` returns after `p` steps, the
kept history from `s` with any past has, `p` steps on, the present `s` again and another
history. -/
theorem return_keeps_history {next : S → S} {s : S} {p : Nat} (pos : 0 < p)
    (back : orbit next s p = s) (past : List S) :
    (orbit (withHistory next) (s, past) p).1 = s ∧
      orbit (withHistory next) (s, past) p ≠ (s, past) :=
  ⟨(present_orbit next (s, past) p).trans back,
    fun same => withHistory_new next (s, past) pos same.symm⟩

end Law

end Becoming

/-! ## The same future under a law (moved from `Becoming.Unfolding`) -/

namespace Becoming

universe u v w u' u''

section Likeness

variable {S : Type u} {S' : Type u'} {S'' : Type u''} {A : Type v} {C : Type w}

section Registered

variable {R : Type w}

/-- Two configurations have the same future through the map under a law. -/
def Law.SameFuture (next : S → S) (o : S → R) (s s' : S) : Prop :=
  ∀ n, o (Law.orbit next s n) = o (Law.orbit next s' n)

end Registered

end Likeness

end Becoming

/-! ## The trajectory of the standard model (moved from `Becoming.Mechanism`) -/

namespace Becoming

universe u v w u'

variable {S : Type u} {A : Type v} {K : Type w}

section Inputs

variable {X : Type u} {U : Type v} {E : Type w}

/-- The trajectory of the standard model from `x₀` under inputs `u` and noise `e`. -/
def trajectory (F : X → U → E → X) (x₀ : X) (u : Nat → U) (e : Nat → E) : Nat → X
  | 0 => x₀
  | n + 1 => F (trajectory F x₀ u e n) (u n) (e n)

end Inputs

end Becoming
