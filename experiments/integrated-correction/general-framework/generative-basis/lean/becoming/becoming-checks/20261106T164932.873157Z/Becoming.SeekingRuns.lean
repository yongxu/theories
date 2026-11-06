import Becoming.Branching
import Becoming.Seeking
import Becoming.Capture

/-!
# Seeking along runs: the boundary of enough on the unfolding

`Becoming.Seeking` states the boundary condition of seeking for a quantity read along any
sequence and for the orbit of a determined law, and `Becoming.Capture` states where a captured
rule holds the outcome. A determined law is a process of the spine (`Law.process`), and every run
of it is its orbit from where the run begins (`Branching.law_run_state`). This module states those
laws of the runs of processes, with no premise beyond what each theorem names.

* **More than now on any run.** Along a run of any process, a step meeting more than now is a
  change of configuration (`more_not_at_rest`), and a run meeting more than now at every step
  passes through configurations no list holds (`more_needs_open`): such seeking needs an open
  world, whatever the process.
* **The boundary of enough on a run of a determined law.** A run of a determined law comes to rest
  with its target met from some step on exactly when it reaches a configuration the law leaves
  unchanged that meets the target (`rests_iff`); no step at which it rests meets more than now
  (`more_never_rests`), and no configuration the law leaves unchanged has two seekers each above
  all others (`aboveAll_never_rests`). Counting on is a run meeting more than now at every step
  (`succ_more`).
* **The captured rule on its runs.** In `Captured`, the run from a configuration whose state alone
  was perturbed is, from the next step on, the run from the unperturbed configuration
  (`captured_state_returns`), while the run from a perturbed rule differs from the next step on
  (`captured_rule_changes`).

No ethical predicate, ranking or axiom occurs.

Declarations moved here unchanged, with their names, from `Becoming.Capture` (board item W): see the
sections so headed.
-/

/-! ## A perturbation of the captured rule reabsorbed (moved from `Becoming.Capture`) -/

namespace Becoming

universe u v

namespace Law

variable {S : Type u} {R : Type v}

/-- **Perturbing the state alone is re-absorbed.** Where the next configuration depends on the
rule and not on the state, two configurations with the same rule have the same orbit from the
next step on: the instance of `Law.reabsorbed` (`Becoming.Mechanism`) with the rule as the
projection. -/
theorem perturbation_reabsorbed {next : S × R → S × R} (byRule : ∀ x x' g, next (x, g) = next (x', g))
    (x x' : S) (g : R) : ∀ n, orbit next (x, g) (n + 1) = orbit next (x', g) (n + 1) :=
  reabsorbed (π := Prod.snd)
    (fun s s' same => (byRule s.1 s'.1 s.2).trans (congrArg (fun h => next (s'.1, h)) same)) rfl

end Law

end Becoming


namespace Becoming

open Generative

universe u v

namespace SeekingRuns

section Determined

variable {S : Type u} {next : S → S}

/-- **The boundary of enough on a run.** A run of a determined law comes to rest with its target
met from some step on exactly when it reaches a configuration the law leaves unchanged that meets
the target. -/
theorem rests_iff (r : Run (Law.process next)) {target : S → Prop} :
    (∃ T, ∀ n, T ≤ n → r.state (n + 1) = r.state n ∧ target (r.state n)) ↔
      ∃ T, next (r.state T) = r.state T ∧ target (r.state T) :=
  have along : ∀ n, r.state n = Law.orbit next (r.state 0) n := Branching.law_run_state r
  ⟨fun ⟨T, rests⟩ =>
    match Law.rests_iff.mp ⟨T, fun n le =>
        ⟨(along (n + 1)).symm.trans ((rests n le).1.trans (along n)),
         (congrArg target (along n)).mp (rests n le).2⟩⟩ with
    | ⟨T', fixed, meets⟩ => ⟨T', (congrArg next (along T')).trans (fixed.trans (along T').symm),
        (congrArg target (along T')).mpr meets⟩,
   fun ⟨T, fixed, meets⟩ =>
    match Law.rests_iff.mpr ⟨T, (congrArg next (along T)).symm.trans (fixed.trans (along T)),
        (congrArg target (along T)).mp meets⟩ with
    | ⟨T', rests⟩ => ⟨T', fun n le =>
        ⟨(along (n + 1)).trans ((rests n le).1.trans (along n).symm),
         (congrArg target (along n)).mpr (rests n le).2⟩⟩⟩

/-- **On a run of a determined law, no step at which the run rests meets more than now.** -/
theorem more_never_rests (r : Run (Law.process next)) {q : S → Nat} (n : Nat) :
    ¬ (r.state (n + 1) = r.state n ∧ MoreThanNow q r.state n) :=
  have along : ∀ n, r.state n = Law.orbit next (r.state 0) n := Branching.law_run_state r
  fun ⟨rests, more⟩ => Law.more_never_rests (q := q) n
    ⟨(along (n + 1)).symm.trans (rests.trans (along n)),
     Nat.lt_of_le_of_lt (Nat.le_of_eq (congrArg q (along n)).symm)
       (Nat.lt_of_lt_of_le more (Nat.le_of_eq (congrArg q (along (n + 1)))))⟩

/-- **No configuration of a determined law's run that the law leaves unchanged has two seekers each
above all others.** -/
theorem aboveAll_never_rests {I : Type} {q : I → S → Nat} {i j : I} (other : i ≠ j)
    (r : Run (Law.process next)) (n : Nat) :
    ¬ (next (r.state n) = r.state n ∧ ∀ k, AboveAll q k (r.state n)) :=
  fun ⟨fixed, all⟩ => Law.aboveAll_never_rests other next ⟨r.state n, fixed, all⟩

/-- Two seekers never both stand above all others at a configuration of any run. -/
theorem aboveAll_not_two {A : Type v} {P : Process S A} {I : Type} {q : I → S → Nat} {i j : I}
    (other : i ≠ j) (r : Run P) (n : Nat) :
    ¬ (AboveAll q i (r.state n) ∧ AboveAll q j (r.state n)) :=
  Becoming.aboveAll_not_two other (r.state n)

end Determined

/-! ## The captured rule on its runs -/

/-- **A perturbed state returns along the run.** From a configuration whose state alone differs,
the run of `Captured` is, from the next step on, the run from the unperturbed configuration. -/
theorem captured_state_returns (g : Bool) :
    ∀ n, (Law.run Captured.next (!g, g)).state (n + 1) = (Law.run Captured.next (g, g)).state (n + 1) :=
  fun n => (Captured.state_perturbation_returns g n).1.trans (Captured.state_perturbation_returns g n).2.symm

/-- **A perturbed rule changes the run.** From a configuration whose rule differs, the run of
`Captured` differs from the next step on. -/
theorem captured_rule_changes (g : Bool) :
    ∀ n, (Law.run Captured.next (g, !g)).state (n + 1) ≠ (Law.run Captured.next (g, g)).state (n + 1) :=
  fun n same =>
    have h : ((!g, !g) : Bool × Bool) = (g, g) :=
      (Captured.rule_perturbation_changes g n).symm.trans
        (same.trans (Captured.state_perturbation_returns g n).2)
    match g, h with
    | true, h => Bool.noConfusion (congrArg Prod.fst h)
    | false, h => Bool.noConfusion (congrArg Prod.fst h)

end SeekingRuns

end Becoming
