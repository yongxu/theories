#!/usr/bin/env python3
"""U4e: Identity's covering laws finished. Applies the Lean edits to the tree given as argv[1]."""
import sys
from pathlib import Path

ROOT = Path(sys.argv[1])
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming'


def edit(path, pairs):
    text = path.read_text()
    for old, new in pairs:
        assert text.count(old) == 1, (path.name, old[:80], text.count(old))
        text = text.replace(old, new)
    path.write_text(text)


edit(PKG / 'Identity.lean', [
    ("""  (`not_not_arisingFrom_covered`, `ceasingFrom_not_stopping_covered`, from `«所覆后亡屡则生未否»`
  and `«有界覆而生屡则亡不止»`). With whether a formation continues (is continued) decided, their
  exact forms conclude recurrence (`arisingFrom_of_ceasingFrom_covered`,
  `ceasingFrom_of_arisingFrom_covered`, from `«有覆而亡屡则生屡»` and `«有界覆而生屡则亡屡»`), and the
  census laws under a continuation are their cases (`Census.arisingFrom_of_ceasingFrom_from`,
  `Census.ceasingFrom_of_arisingFrom_from`).""",
     """  (`not_not_arisingFrom_covered`, `ceasingFrom_not_stopping_covered`, from `«所覆后亡屡则生未否»`
  and `«有界覆而生屡则亡不止»`); from lists at arbitrarily late steps, arising does not stop
  (`arisingFrom_not_stopping_covered`, from `«有覆而亡屡则生不止»`). With whether a formation
  continues (is continued) decided, their exact forms conclude recurrence
  (`arisingFrom_of_ceasingFrom_covered`, `ceasingFrom_of_arisingFrom_covered`, from
  `«有覆而亡屡则生屡»` and `«有界覆而生屡则亡屡»`), and the census laws under a continuation are
  their cases, each taking that one decision (`Census.arisingFrom_of_ceasingFrom_from`,
  `Census.ceasingFrom_of_arisingFrom_from`)."""),
    ("""/-- So, with covering lists at arbitrarily late steps and no splits from some step on,
ceasing under the continuation recurring leaves no step from which nothing arises under
it. -/
theorem arisingFrom_not_stopping_covered {T : Nat}
    (covered : ∀ N, ∃ M, ∃ l : List F, N ≤ M ∧ ∀ f, W.active M f → f ∈ l)
    (noSplit : ∀ s, T ≤ s → ∀ g f f', W.active s g → R s g f → R s g f' →
      W.active (s + 1) f → W.active (s + 1) f' → f = f')
    (ceasing : ∀ N, ∃ t g, N ≤ t ∧ W.CeasesFrom R t g) :
    ¬ ∃ N, ∀ t f, N ≤ t → ¬ W.ArisesFrom R t f :=
  fun ⟨N, quiet⟩ => match covered (N + T) with
  | ⟨_, _, later, covers⟩ =>
    not_not_arisingFrom_covered covers
      (fun s from_ => noSplit s (Nat.le_trans (Nat.le_trans (Nat.le_add_left T N) later) from_))
      ceasing fun ⟨s, f, from_, arises⟩ =>
        quiet s f (Nat.le_trans (Nat.le_trans (Nat.le_add_right N T) later) from_) arises
""",
     """/-- With covering lists at arbitrarily late steps and no splits from `T` on, ceasing under the
continuation recurring leaves no step from which nothing arises under it. No census and no
decision is used: it is the root's `«有覆而亡屡则生不止»` at the formations' occurrences within
activity onward from `T`. -/
theorem arisingFrom_not_stopping_covered {T : Nat}
    (covered : ∀ N, ∃ M, ∃ l : List F, N ≤ M ∧ ∀ f, W.active M f → f ∈ l)
    (noSplit : ∀ s, T ≤ s → ∀ g f f', W.active s g → R s g f → R s g f' →
      W.active (s + 1) f → W.active (s + 1) f' → f = f')
    (ceasing : ∀ N, ∃ t g, N ≤ t ∧ W.CeasesFrom R t g) :
    ¬ ∃ N, ∀ t f, N ≤ t → ¬ W.ArisesFrom R t f :=
  fun ⟨N, quiet⟩ => «有覆而亡屡则生不止» (R := continuationStep R) (E := W.activityOnward T)
    (τ := Prod.fst) (P := fun x => W.active x.1 x.2)
    continuation_stage continuation_back (continuation_noSplit noSplit)
    (fun K => match covered K with
      | ⟨M, l, later, covers⟩ => ⟨M, l.map (fun f => (M, f)), later, continuation_covers covers⟩)
    (fun K no => no (continuation_ending ceasing K))
    ⟨N + T, fun y late h b => match y, late, h, b with
      | (0, _), late, _, _ => Nat.not_lt_zero _ late
      | (t + 1, f), late, h, b =>
        quiet t f (Nat.le_trans (Nat.le_add_right N T) (Nat.le_of_lt_succ late))
          (continuation_arises (Nat.le_trans (Nat.le_add_left T N) (Nat.le_of_lt_succ late)) h b)⟩
"""),
    ("""/-- The census law under a continuation, from a step on: where from `T` on the active
formations are listed at each step and no formation continues as two, ceasing at arbitrarily
late steps needs arising at arbitrarily late steps. Nothing is asked of the steps before
`T`. The listing at each step covers it (`arisingFrom_of_ceasingFrom_covered`). -/
theorem Census.arisingFrom_of_ceasingFrom_from [∀ t f, Decidable (W.active t f)]
    [∀ t f, Decidable (W.Continues R t f)] [∀ t g, Decidable (W.Continued R t g)]
    {alive : Nat → List F} {T : Nat}""",
     """/-- The census law under a continuation, from a step on: where from `T` on the active
formations are listed at each step and no formation continues as two, with whether a formation
continues one active before decided, ceasing at arbitrarily late steps needs arising at
arbitrarily late steps. Nothing is asked of the steps before `T`. The listing at each step
covers it (`arisingFrom_of_ceasingFrom_covered`). -/
theorem Census.arisingFrom_of_ceasingFrom_from [∀ t f, Decidable (W.Continues R t f)]
    {alive : Nat → List F} {T : Nat}"""),
    ("""late steps (`arising_of_ceasing`). -/
theorem Census.arisingFrom_of_ceasingFrom [∀ t f, Decidable (W.active t f)]
    [∀ t f, Decidable (W.Continues R t f)] [∀ t g, Decidable (W.Continued R t g)]
    {alive : Nat → List F} (census : W.Census alive)""",
     """late steps (`arising_of_ceasing`). -/
theorem Census.arisingFrom_of_ceasingFrom [∀ t f, Decidable (W.Continues R t f)]
    {alive : Nat → List F} (census : W.Census alive)"""),
    ("""/-- And from a step on: where from `T` on the active formations are listed at each step, at
most `B` of them, and no formation continues two, arising at arbitrarily late steps needs
ceasing at arbitrarily late steps. The listings cover each step from `T`
(`ceasingFrom_of_arisingFrom_covered`). -/
theorem Census.ceasingFrom_of_arisingFrom_from [∀ t f, Decidable (W.active t f)]
    [∀ t f, Decidable (W.Continues R t f)] [∀ t g, Decidable (W.Continued R t g)]
    {alive : Nat → List F} {T B : Nat}""",
     """/-- And from a step on: where from `T` on the active formations are listed at each step, at
most `B` of them, and no formation continues two, with whether a formation is continued by one
active after decided, arising at arbitrarily late steps needs ceasing at arbitrarily late
steps. The listings cover each step from `T` (`ceasingFrom_of_arisingFrom_covered`). -/
theorem Census.ceasingFrom_of_arisingFrom_from [∀ t g, Decidable (W.Continued R t g)]
    {alive : Nat → List F} {T B : Nat}"""),
    ("""steps needs ceasing at arbitrarily late steps (`ceasing_of_arising`). -/
theorem Census.ceasingFrom_of_arisingFrom [∀ t f, Decidable (W.active t f)]
    [∀ t f, Decidable (W.Continues R t f)] [∀ t g, Decidable (W.Continued R t g)]
    {alive : Nat → List F} (census : W.Census alive)""",
     """steps needs ceasing at arbitrarily late steps (`ceasing_of_arising`). -/
theorem Census.ceasingFrom_of_arisingFrom [∀ t g, Decidable (W.Continued R t g)]
    {alive : Nat → List F} (census : W.Census alive)"""),
])

edit(PKG / 'Persistence.lean', [
    ("""theorem persisting_census {R : Nat → F → F → Prop}
    [∀ t f, Decidable ((W.persisting h).active t f)]
    [∀ t f, Decidable ((W.persisting h).Continues R t f)]
    [∀ t g, Decidable ((W.persisting h).Continued R t g)] [∀ t g f, Decidable (R t g f)]
    {alive : Nat → List F}""",
     """theorem persisting_census {R : Nat → F → F → Prop}
    [∀ t f, Decidable ((W.persisting h).Continues R t f)]
    [∀ t g, Decidable ((W.persisting h).Continued R t g)]
    {alive : Nat → List F}"""),
])
print('edited')
