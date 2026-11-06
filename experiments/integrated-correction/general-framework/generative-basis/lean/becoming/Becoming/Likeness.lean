import Becoming.Branching
import Becoming.Histories
import Becoming.Decidedness
import Becoming.Refinement

/-!
# Likeness: the laws stated with equality, completed up to likeness

`Becoming.Unfolding` (P69) identifies configurations by how they relate (`Alike`) and names
determinacy up to likeness (`DeterminedAt`). `Becoming.Branching` (P81) restated the main theorems
of `Becoming.Experiment` and `Becoming.Mechanism` up to likeness and named, with witnesses, those
needing equality. This module completes that list: the exact form of `carries_law_iff`, the
image's determinacy, `Run.not_fixes_other_of_new`, the theorems on what a record through a
projection does not fix and `Dependence.determined_dichotomy`, each up to likeness, with the
theorem stated with equality as its named instance. It shows that branching tests fix likeness
constructively where frames are finite and decided, that neither decision can be dropped, and
which principle the finitely many configurations save where only each move's outcomes are listed.
No premise is added; every declaration has an empty axiom report.

* **A description carries a law up to likeness exactly where some equivalence respecting the
  claims makes configurations go alike** (`carries_law_alike_iff`). Some process on the
  descriptions, determined up to likeness under the claims, admits every step read through `π`
  exactly when some equivalence on descriptions relates only descriptions realizing the same
  claims (`RespectsClaims`) and takes configurations whose descriptions it relates, by one move, to
  configurations whose descriptions it relates (`GoAlikeUnder`). The process is the image closed
  under the equivalence (`imageUnder`); the equivalence, from a carrying process, is likeness in
  it. Where the claims name the descriptions, the only such equivalence is equality, and this is
  `carries_law_iff` (`carries_law_named_iff`); with nothing claimed every description carries a
  law (`carries_unregistered` of `Becoming.Branching`).
* **The image is no longer the least carrier.** Its frame is determined up to likeness exactly
  where configurations whose descriptions are alike in it go alike under it
  (`image_determinedAt_iff`), and a description can carry a law up to likeness while its image is
  not determined up to likeness (`Likeness.Parting.image_not_determinedAt`, `Likeness.Parting.carries`): with
  equality the image is the least process the step factors through (`Image.least`), and up to
  likeness a larger process can make alike what the image tells apart.
* **A run that never returns up to likeness fixes no other move up to likeness**
  (`Run.not_fixesAlike_other_of_new`): `Run.not_fixes_other_of_new` with returning read as coming
  back to an alike configuration. Read through a projection, a move the run has not taken at a
  description alike to the one named is not fixed up to likeness, under any process on the
  descriptions determined up to likeness that admits the steps so read
  (`Run.not_fixesThroughAlike_of_untaken`), and so wherever an equivalence respecting the
  claims makes configurations go alike (`Run.not_fixesThroughAlike_of_goAlikeUnder`):
  `Run.not_fixesThrough_of_untaken` and `Run.not_fixesThrough_of_goAlike` up to likeness.
* **The dichotomy of difference-making needs only the level after the move to be one**
  (`Dependence.dichotomy_of_same_level`). Where every step by the move from the withheld
  configuration reaches the same level of the condition, either the part makes the difference or
  the same move still breaks the dependence. Determinacy up to likeness under claims that tell apart
  the level is a case of it (`Dependence.dichotomy_of_determinedAt`), and so is determinacy,
  at the claims that read the level (`Dependence.level_registers`): `Dependence.determined_dichotomy`
  of `Becoming.Joint`. In
  every process the part makes the difference exactly when the same move no longer breaks the
  dependence (`makesDifference_iff`); what the condition adds is the decision between the two.
* **Branching tests fix likeness, constructively, where both frames are finite and decided.** A
  branching test is a claim, the failure of a test, two tests together, or that some step by a
  move leads to where a test holds (`BranchingTest`, `BranchingTest.Holds`). Alike configurations
  pass the same branching tests, with no premise (`Alike.sameBranchingTests`). Where the moves and
  claims are listed, some list holds the configurations of each frame, and whether a move takes
  one configuration to another and whether a configuration realizes a claim are decided
  (`FiniteDecided`), configurations passing the same branching tests are alike
  (`alike_iff_sameBranchingTests`). Each step is built from the decisions: likeness to depth `k`
  (`AlikeTo`) is decided (`AlikeTo.decided`); where it fails, a branching test holding at one
  configuration and failing at the other is built (`apart_of_not_alikeTo`); likeness to depth
  stops refining at a depth no greater than the number of pairs of configurations
  (`AlikeTo.steady_within`, by `stops_decreasing`), and there it is a bisimulation
  (`AlikeTo.bisimulation`). So likeness of finite decided frames is decided (`Alike.decided`), is
  likeness to every depth (`alike_iff_alikeTo`) and is likeness to the depth of the number of
  pairs (`alike_iff_alikeTo_pairs`). This answers, for
  frames with finitely many configurations, the question `Becoming.Histories` left open: the
  periphery's `ExplanatoryBranching.same_iff_bisimilar` reasons classically, for frames with
  finitely many outcomes of each move.
* **Within the classes** (Moore, 1956). Within one frame, likeness to depth is a chain of
  equivalences, each finer than the one before (`AlikeTo.refining`). Where a list of `N`
  configurations holds a finite decided frame, it stops refining at a depth `k` with `k + c ≤ N`,
  `c` configurations realizing pairwise different claims (`AlikeTo.steady_within_classes`, by
  `Refining.steady_within` of `Becoming.Refinement`): each strict refinement adds a class. So
  configurations are alike exactly where they are alike to depth `N - 1`
  (`alike_iff_alikeTo_classes`). Two frames held by lists of `N` and `N'` configurations, read as
  one (`AlikeAcross`), stop refining at a depth `k` with `k + c ≤ N + N'`
  (`AlikeTo.steady_within_across`), and their configurations are alike exactly where they are
  alike to depth `N + N' - 1` (`alike_iff_alikeTo_across`). This sharpens the earlier bound by the
  number of pairs, `N · N'` (`AlikeTo.steady_within`, `alike_iff_alikeTo_pairs`, kept). Within
  one frame `N - 1` is exact: on a path of `N` places ending where nothing steps, the first two
  places are alike to depth `N - 2` and are not alike (`EndOfPath.classes_exact`). For determined
  laws read through maps, likeness to depth `k` is agreement for `k + 1` steps
  (`alikeTo_frameBy_iff`). There one step less suffices: `N - 2` within one world
  (`Law.sameFuture_iff_classes` of `Becoming.Identification`) and `N + N' - 2` across two
  (`Identification.bounded_agree`), each exact for laws and courses
  (`Law.sameFuture_classes_exact`, `Identification.bounded_agree_exact`). A frame's extra step is
  where whether a move can be taken at all makes a difference. Whether `N + N' - 1` is exact across two
  frames is not stated here.
* **The decisions cannot be dropped from deciding likeness.** Asked of every pair of frames with
  one configuration, one move and no claims, whether their configurations are alike is decided
  exactly under excluded middle (`alike_decided_iff_em`, through `OneLoop`).
* **Nor from the equivalence.** That configurations passing the same branching tests are alike
  holds, for every frame on a listed type of configurations with one move and no claims, exactly
  under excluded middle (`alike_of_sameBranchingTests_iff_em`, through `EitherStep`), and so for
  every such frame with one claim and decided steps
  (`alike_of_sameBranchingTests_decided_steps_iff_em`, through `EitherClaim`). In both, a
  configuration with three successors and one with two pass the same tests whatever a
  proposition is, the third successor passing what one of the other two passes; they are alike
  only where the proposition is decided.
* **Where only each move's outcomes are listed, branching tests fix likeness exactly under a
  principle.** Where the moves and claims are listed, the claims are decided and each move of each
  configuration has a listed set of outcomes (`OutcomesListed`), configurations passing the same
  branching tests are alike given `EitherThroughout`: of two decided families, each holding at a
  step where it holds at the next, one of which holds at each step, one holds at every step
  (`OutcomesListed.alike_iff_sameBranchingTests`). Likeness to every depth is then a bisimulation,
  the principle choosing, among a step's listed outcomes, one alike to it at every depth
  (`EitherThroughout.list`). Conversely the theorem for every such frame gives the principle
  (`alike_of_sameBranchingTests_outcomes_iff`, through `Chains`): a configuration stepping to two
  chains, each going on while its family holds, and one stepping to these and to a chain that
  always goes on pass the same tests, and are alike only where one family holds at every step.
  Excluded middle gives the principle (`EitherThroughout.of_em`). The principle is `EitherNever`:
  of two decided families not both holding somewhere, one holds nowhere
  (`eitherThroughout_iff_eitherNever`); `NowhereDecided`, that whether a decided family holds
  nowhere is decided, gives it (`EitherThroughout.of_nowhereDecided`), and excluded middle gives
  `NowhereDecided` (`NowhereDecided.of_em`). The principle is, exactly, the lesser limited
  principle of omniscience for decided families (`eitherThroughout_iff_llpoForDecided`,
  `LLPOForDecided`); it gives `LLPO` in its standard form, for Boolean sequences with at most one
  `true` (`LLPO.of_eitherThroughout`), and `LLPO` gives the family form wherever the decisions are
  given as data (`LLPO.decidable`); `LPO` gives `LLPO` (`LLPO.of_lpo`). Weak König's lemma is
  equivalent to `LLPO` (Ishihara 1990; Bridges and Richman 1987). Where neither the moves nor the claims are listed,
  excluded middle suffices (`alike_iff_sameBranchingTests_of_em`): this is the periphery's
  `ExplanatoryBranching.same_iff_bisimilar`, with the principle its proof uses as a hypothesis.
  Where a move has infinitely many outcomes, branching
  tests need not fix likeness, with no principle needed to show it: a configuration stepping to
  chains of every length and one stepping also to a chain that never ends pass the same tests and
  are not alike (`Unbounded.sameBranchingTests`, `Unbounded.not_alike`).
* **Where likeness tells a frame's configurations apart, a configuration is alike to at most one
  of them** (`Alike.functional`), and so for branching tests (`SameBranchingTests.functional`).
* **Likeness and its tests are stated once for any family of relations among configurations.**
  A bisimulation may also match, both ways, the parts each whole holds together under each of a
  family of relations (`MatchesParts`, `BisimulationWith`, `AlikeWith`), and a test may ask that a
  configuration hold together, under one of them, two parts passing two tests (`TestWith`).
  Configurations alike in this sense pass the same tests, with no premise
  (`AlikeWith.holds_iff`). With no relation this is `Alike` and the branching tests
  (`alikeWith_empty_iff`, `BranchingTest.holds_toWith`), and `Alike.holds_iff` is proved as that
  case; the joint frame of `Becoming.Composition` is the case of one relation.
* **A branching test sees when a choice is made.** The starts of `Choosing.late` and
  `Choosing.early` pass the same tests and are not alike (`Becoming.Histories`); that the first
  move can lead to a configuration where both `b` and `c` can be taken holds at the one and fails
  at the other (`Choosing.branching_apart`).

What is not derived: whether `LLPO` for Boolean sequences gives the family form where the
decisions are propositions only (that would turn a decided proposition into a Boolean value, a
unique choice the core does not make); whether `EitherThroughout` gives `NowhereDecided` or excluded middle, since
showing that it does not would take a model outside the core; and whether a principle weaker than
excluded middle suffices where the moves or the claims are not listed. `Becoming.Bridge` reads `BranchingTest` as the
periphery's `Test` (`sameBranchingTests_iff_same`).

The readings are the AI's, adopted on Ren's delegation of 15 October 2026 (DELEGATED-CHOICES D23).

`Decided.exists_listed` and `Decided.exists_not_in` are in `Becoming.Decidedness` (board item W).
-/

namespace Becoming

open Generative

universe u v w u' w'

/-! ## A description carries a law up to likeness -/

section Carrying

variable {S : Type u} {A : Type v} {K : Type u'} {D : Type w'}

/-- `E` respects the claims: descriptions it relates realize the same claims. `Web.CoupledInto`
of `Becoming.Testing` is another sense, a condition coupling into a formation, by threshold (its
dependence) or by level. -/
def RespectsClaims (claims : K → D → Prop) (E : K → K → Prop) : Prop :=
  ∀ k k', E k k' → ∀ d, claims k d ↔ claims k' d

/-- The image of `P` through `π` closed under `E`: `a` goes from `k` to `κ` where some step of
`P` by `a` goes from a configuration whose description `E` relates to `k` to one whose description
`E` relates to `κ`. -/
def imageUnder (P : Process S A) (π : S → K) (E : K → K → Prop) : Process K A :=
  ⟨fun k a κ => ∃ s u, E k (π s) ∧ P.step s a u ∧ E (π u) κ⟩

/-- The step factors through `π` into the image closed under a reflexive relation. -/
theorem factors_imageUnder (P : Process S A) (π : S → K) {E : K → K → Prop}
    (eqv : Equivalence E) : FactorsThrough P π (imageUnder P π E) :=
  fun s _ u step => ⟨s, u, eqv.refl _, step, eqv.refl _⟩

/-- An equivalence respecting the claims is a bisimulation of the image closed under it. -/
theorem imageUnder_bisimulation (P : Process S A) (π : S → K) {claims : K → D → Prop}
    {E : K → K → Prop} (eqv : Equivalence E) (registers : RespectsClaims claims E) :
    Bisimulation (⟨imageUnder P π E, claims⟩ : Frame K A D) ⟨imageUnder P π E, claims⟩ E :=
  fun k k' related =>
    ⟨registers k k' related,
     fun _ κ ⟨s, u, at_k, step, to⟩ =>
       ⟨κ, ⟨s, u, eqv.trans (eqv.symm related) at_k, step, to⟩, eqv.refl κ⟩,
     fun _ κ ⟨s, u, at_k, step, to⟩ =>
       ⟨κ, ⟨s, u, eqv.trans related at_k, step, to⟩, eqv.refl κ⟩⟩

/-- Where an equivalence respecting the claims makes configurations go alike, the image closed
under it is determined up to likeness everywhere. -/
theorem imageUnder_determinedAt (P : Process S A) (π : S → K) {claims : K → D → Prop}
    {E : K → K → Prop} (eqv : Equivalence E) (registers : RespectsClaims claims E)
    (go : GoAlikeUnder P π E) : ∀ k, DeterminedAt (⟨imageUnder P π E, claims⟩ : Frame K A D) k :=
  fun _ a _ _ ⟨s, u, at_k, step, to⟩ ⟨s', u', at_k', step', to'⟩ =>
    ⟨E, imageUnder_bisimulation P π eqv registers,
      eqv.trans (eqv.symm to)
        (eqv.trans (go s s' a u u' (eqv.trans (eqv.symm at_k) at_k') step step') to')⟩

/-- Likeness in a frame is an equivalence. -/
theorem alike_equivalence (F : Frame K A D) : Equivalence (Alike F F) :=
  ⟨Alike.refl F, Alike.symm, Alike.trans⟩

/-- Likeness in a frame respects its claims. -/
theorem alike_respectsClaims (F : Frame K A D) : RespectsClaims F.realized (Alike F F) :=
  fun _ _ alike => alike.realized

/-- **A description carries a law up to likeness exactly where some equivalence respecting the
claims makes configurations go alike.** Some process on the descriptions, determined up to
likeness under `claims`, admits every step of `P` read through `π` if and only if some equivalence
on the descriptions relates only descriptions realizing the same claims and takes configurations
whose descriptions it relates, by one move, to configurations whose descriptions it relates. -/
theorem carries_law_alike_iff {P : Process S A} {π : S → K} {claims : K → D → Prop} :
    (∃ Q : Process K A, (∀ k, DeterminedAt (⟨Q, claims⟩ : Frame K A D) k) ∧
        FactorsThrough P π Q) ↔
      ∃ E : K → K → Prop, Equivalence E ∧ RespectsClaims claims E ∧ GoAlikeUnder P π E :=
  ⟨fun ⟨Q, determined, factors⟩ =>
    ⟨Alike (⟨Q, claims⟩ : Frame K A D) ⟨Q, claims⟩, alike_equivalence _, alike_respectsClaims _,
     fun s s' a u u' alike step step' =>
       match alike.step (factors s a u step) with
       | ⟨κ, to, joined⟩ => joined.trans (determined (π s') a κ (π u') to (factors s' a u' step'))⟩,
   fun ⟨E, eqv, registers, go⟩ =>
    ⟨imageUnder P π E, imageUnder_determinedAt P π eqv registers go,
     factors_imageUnder P π eqv⟩⟩

/-- Equality is an equivalence. -/
theorem eq_equivalence : Equivalence (fun k k' : K => k = k') :=
  ⟨fun _ => rfl, fun same => same.symm, fun same same' => same.trans same'⟩

/-- **Where the claims name the descriptions, carrying a law up to likeness is
`carries_law_iff`.** With each description its own claim, the only equivalence respecting the
claims is equality, and some process determined up to likeness admits every step read through
`π` exactly when configurations alike under `π` go alike under `π`. -/
theorem carries_law_named_iff {P : Process S A} {π : S → K} :
    (∃ Q : Process K A, (∀ k, DeterminedAt (⟨Q, fun k k' => k = k'⟩ : Frame K A K) k) ∧
        FactorsThrough P π Q) ↔ GoAlike P π :=
  carries_law_alike_iff.trans
    ⟨fun ⟨E, eqv, registers, go⟩ s s' a u u' same step step' =>
      have related : E (π s) (π s') :=
        Eq.subst (motive := fun k => E (π s) k) same (eqv.refl (π s))
      ((registers _ _ (go s s' a u u' related step step') (π u)).mp rfl).symm,
     fun alike => ⟨fun k k' => k = k', eq_equivalence,
       fun k _ same d => Eq.subst (motive := fun x => (k = d ↔ x = d)) same Iff.rfl,
       fun s s' a u u' same step step' => alike s s' a u u' same step step'⟩⟩

end Carrying

/-! ## The image up to likeness -/

section ImageAlike

variable {S : Type u} {A : Type v} {K : Type u'} {D : Type w'}

/-- **The image is determined up to likeness exactly where configurations whose descriptions are
alike in it go alike under it**: `image_determined_iff` up to likeness. -/
theorem image_determinedAt_iff {P : Process S A} {π : S → K} {claims : K → D → Prop} :
    (∀ k, DeterminedAt (⟨Image P π, claims⟩ : Frame K A D) k) ↔
      GoAlikeUnder P π (Alike (⟨Image P π, claims⟩ : Frame K A D) ⟨Image P π, claims⟩) :=
  ⟨fun determined s s' a u u' alike step step' =>
    match alike.step (factors_image P π s a u step) with
    | ⟨κ, to, joined⟩ =>
      joined.trans (determined (π s') a κ (π u') to (factors_image P π s' a u' step')),
   fun go _ a _ κ' ⟨s, u, at_k, step, to⟩ ⟨s', u', at_k', step', to'⟩ =>
    have alike : Alike (⟨Image P π, claims⟩ : Frame K A D) ⟨Image P π, claims⟩ (π s) (π s') :=
      Eq.subst (motive := fun k' => Alike (⟨Image P π, claims⟩ : Frame K A D)
          ⟨Image P π, claims⟩ (π s) k') (at_k.trans at_k'.symm) (Alike.refl _ (π s))
    Eq.subst (motive := fun x => Alike (⟨Image P π, claims⟩ : Frame K A D)
        ⟨Image P π, claims⟩ x κ') to
      (Eq.subst (motive := fun y => Alike (⟨Image P π, claims⟩ : Frame K A D)
          ⟨Image P π, claims⟩ (π u) y) to' (go s s' a u u' alike step step'))⟩

end ImageAlike

/-! ## A configuration whose one move parts it into one that can go on and one that cannot -/

namespace Likeness.Parting

/-- The three configurations. -/
inductive Pos where
  | start
  | going
  | stopped

/-- From the start the move `true` leads to `going` and to `stopped`; `going` moves by `false`
to itself; `stopped` has no move. -/
inductive Step : Pos → Bool → Pos → Prop
  | go : Step .start true .going
  | stop : Step .start true .stopped
  | stay : Step .going false .going

/-- The process of these steps. -/
def process : Process Pos Bool := ⟨Step⟩

/-- Nothing claimed. -/
def claims (_ : Pos) (_ : Unit) : Prop := True

/-- `going` and `stopped` are not alike in the image through the identity: one can move, the
other cannot. -/
theorem going_not_stopped :
    ¬ Alike (⟨Image process id, claims⟩ : Frame Pos Bool Unit) ⟨Image process id, claims⟩
      .going .stopped :=
  fun alike => match alike.step (show (Image process id).step .going false .going from
      ⟨.going, .going, rfl, Step.stay, rfl⟩) with
    | ⟨_, ⟨_, u, at_k, step, _⟩, _⟩ =>
      (fun (none : Step .stopped false u) => nomatch none)
        (Eq.subst (motive := fun x => process.step x false u) at_k step)

/-- **The image is not determined up to likeness at the start**: the move `true` takes it to two
configurations that are not alike. -/
theorem image_not_determinedAt :
    ¬ DeterminedAt (⟨Image process id, claims⟩ : Frame Pos Bool Unit) .start :=
  fun determined => going_not_stopped
    (determined true .going .stopped ⟨.start, .going, rfl, Step.go, rfl⟩
      ⟨.start, .stopped, rfl, Step.stop, rfl⟩)

/-- **Yet the identity carries a law up to likeness**: with nothing claimed, every description
does (`carries_unregistered`). -/
theorem carries :
    ∃ Q : Process Pos Bool, (∀ k, DeterminedAt (⟨Q, claims⟩ : Frame Pos Bool Unit) k) ∧
      FactorsThrough process id Q :=
  carries_unregistered process id

end Likeness.Parting

/-! ## A run that never returns up to likeness -/

section NeverReturning

variable {S : Type u} {A : Type v} {C : Type w}

/-- **A run that never returns up to likeness fixes no other move up to likeness.** Where the
frame is determined up to likeness and no configuration of the run is alike to an earlier one, at
each configuration the run passes the record fixes up to likeness the outcome of no move other than
the one the run takes there, for any two configurations that differ in a claim:
`Run.not_fixes_other_of_new` up to likeness. -/
theorem Run.not_fixesAlike_other_of_new {F : Frame S A C} (determined : ∀ x, DeterminedAt F x)
    (r : Run F.P) (new : ∀ i j, i < j → ¬ Alike F F (r.state i) (r.state j)) {n t : Nat} {b : A}
    (other : b ≠ r.act n) {x y : S} {c : C} (here : F.realized x c)
    (not_here : ¬ F.realized y c) : ¬ ∃ u, r.FixesAlike F.realized t (r.state n) b u :=
  r.not_fixesAlike_of_untaken determined (fun ⟨m, _, like, takes⟩ =>
    have distinct : m ≠ n := fun same => other (takes.symm.trans (congrArg r.act same))
    match Run.ordered_of_ne distinct with
    | .inl lt => new m n lt like
    | .inr gt => new n m gt like.symm) here not_here

/-- Never returning up to likeness is never returning, and more. -/
theorem Run.new_of_newAlike {F : Frame S A C} (r : Run F.P)
    (new : ∀ i j, i < j → ¬ Alike F F (r.state i) (r.state j)) :
    ∀ i j, i < j → r.state i ≠ r.state j :=
  fun i j lt same => new i j lt (Eq.subst (motive := fun y => Alike F F (r.state i) y) same
    (Alike.refl F (r.state i)))

/-- Before step `t` the run takes `a` at a configuration whose description is alike to `k` in the
frame of `Q` under `claims`. -/
def Run.TakesThroughAlike {K : Type u'} {D : Type w'} {P : Process S A} (r : Run P) (π : S → K)
    (Q : Process K A) (claims : K → D → Prop) (t : Nat) (k : K) (a : A) : Prop :=
  ∃ n, n < t ∧ Alike (⟨Q, claims⟩ : Frame K A D) ⟨Q, claims⟩ (π (r.state n)) k ∧ r.act n = a

/-- **A law through a projection is not fixed up to likeness where not yet taken.** Where a
process on the description, determined up to likeness under `claims`, admits the run's steps
before `t` read through `π`, and the run has not taken `a` at a configuration whose description
is alike to `k` there, the record fixes up to likeness no outcome of `a` at `k`, for any two
descriptions that differ in a claim: `Run.not_fixesThrough_of_untaken` up to likeness. -/
theorem Run.not_fixesThroughAlike_of_untaken {K : Type u'} {D : Type w'} {P : Process S A}
    (r : Run P) {π : S → K} {claims : K → D → Prop} {Q : Process K A}
    (determined : ∀ k, DeterminedAt (⟨Q, claims⟩ : Frame K A D) k) {t : Nat}
    (steps : r.StepsThrough π Q t) {k : K} {a : A} (untaken : ¬ r.TakesThroughAlike π Q claims t k a)
    {x y : K} {d : D} (here : claims x d) (not_here : ¬ claims y d) :
    ¬ ∃ κ, r.FixesThroughAlike π claims t k a κ :=
  fun ⟨_, fixes⟩ =>
    have retargeted : ∀ κ₀, r.StepsThrough π (retargetAlike ⟨Q, claims⟩ k a κ₀).P t :=
      fun _ n before => .inl ⟨fun ⟨like, same⟩ => untaken ⟨n, before, like, same⟩, steps n before⟩
    have to_x := fixes (retargetAlike ⟨Q, claims⟩ k a x).P
      (retargetAlike_determinedAt determined k a x k) (retargeted x) x
      (retargetAlike_step ⟨Q, claims⟩ k a x)
    have to_y := fixes (retargetAlike ⟨Q, claims⟩ k a y).P
      (retargetAlike_determinedAt determined k a y k) (retargeted y) y
      (retargetAlike_step ⟨Q, claims⟩ k a y)
    not_here ((to_y.realized d).mpr ((to_x.realized d).mp here))

/-- **A law carried up to likeness is not fixed where not yet taken either.** Where an
equivalence respecting the claims makes configurations go alike under `π`, the record fixes up
to likeness no outcome of a move at a description the run has not taken it at, up to likeness in
the image closed under the equivalence: `Run.not_fixesThrough_of_goAlike` up to likeness. -/
theorem Run.not_fixesThroughAlike_of_goAlikeUnder {K : Type u'} {D : Type w'} {P : Process S A}
    (r : Run P) {π : S → K} {claims : K → D → Prop} {E : K → K → Prop} (eqv : Equivalence E)
    (registers : RespectsClaims claims E) (go : GoAlikeUnder P π E) {t : Nat} {k : K} {a : A}
    (untaken : ¬ r.TakesThroughAlike π (imageUnder P π E) claims t k a) {x y : K} {d : D}
    (here : claims x d) (not_here : ¬ claims y d) : ¬ ∃ κ, r.FixesThroughAlike π claims t k a κ :=
  r.not_fixesThroughAlike_of_untaken (imageUnder_determinedAt P π eqv registers go)
    (r.stepsThrough_of_factors (factors_imageUnder P π eqv) t) untaken here not_here

end NeverReturning

/-! ## Branching tests fix likeness, constructively, where a frame is finite and decided -/

section BranchingTests

variable {S : Type u} {S' : Type u'} {A : Type v} {C : Type w}

/-- Over a type some list holds all of, whether a decided determination holds of something is
decided. -/
theorem Decided.exists_of_listed {β : Type u} {P : β → Prop} {l : List β} (listed : ∀ b, b ∈ l)
    (decided : ∀ b, Decided (P b)) : Decided (∃ b, P b) :=
  match Decided.exists_listed (l := l) fun b _ => decided b with
  | .inl ⟨b, _, holds⟩ => .inl ⟨b, holds⟩
  | .inr absent => .inr fun ⟨b, holds⟩ => absent ⟨b, listed b, holds⟩

/-- Over a type some list holds all of, whether a decided determination holds of everything is
decided. -/
theorem Decided.forall_of_listed {β : Type u} {P : β → Prop} {l : List β} (listed : ∀ b, b ∈ l)
    (decided : ∀ b, Decided (P b)) : Decided (∀ b, P b) :=
  match Decided.exists_of_listed listed fun b => (decided b).not with
  | .inl ⟨b, fails⟩ => .inr fun all => fails (all b)
  | .inr absent => .inl fun b => (decided b).of_not_not fun fails => absent ⟨b, fails⟩

/-- Over a type some list holds all of, a decided determination that does not hold of everything
fails of something. -/
theorem Decided.exists_not_of_listed {β : Type u} {P : β → Prop} {l : List β}
    (listed : ∀ b, b ∈ l) (decided : ∀ b, Decided (P b)) (fails : ¬ ∀ b, P b) : ∃ b, ¬ P b :=
  match Decided.exists_of_listed listed fun b => (decided b).not with
  | .inl found => found
  | .inr absent => absurd (fun b => (decided b).of_not_not fun fails' => absent ⟨b, fails'⟩) fails

/-- Where two propositions are decided, so is whether one implies the other. -/
theorem Decided.imp {p q : Prop} (first : Decided p) (second : Decided q) : Decided (p → q) :=
  match second with
  | .inl holds => .inl fun _ => holds
  | .inr fails => match first with
    | .inl holds => .inr fun imp => fails (imp holds)
    | .inr fails' => .inl fun holds => absurd holds fails'

/-- Where two propositions are decided, so is whether they are equivalent. -/
theorem Decided.iff {p q : Prop} (first : Decided p) (second : Decided q) : Decided (p ↔ q) :=
  match first, second with
  | .inl holds, .inl holds' => .inl ⟨fun _ => holds', fun _ => holds⟩
  | .inl holds, .inr fails => .inr fun same => fails (same.mp holds)
  | .inr fails, .inl holds => .inr fun same => fails (same.mpr holds)
  | .inr fails, .inr fails' => .inl ⟨fun holds => absurd holds fails, fun holds => absurd holds fails'⟩

/-- Each member of a list paired with `b`, before `rest`. -/
def pairedWith {β : Type u} {γ : Type u'} (b : β) : List γ → List (β × γ) → List (β × γ)
  | [], rest => rest
  | c :: m, rest => (b, c) :: pairedWith b m rest

/-- Every pair of a member of one list and a member of another. -/
def pairsOf {β : Type u} {γ : Type u'} : List β → List γ → List (β × γ)
  | [], _ => []
  | b :: l, m => pairedWith b m (pairsOf l m)

theorem mem_pairedWith_left {β : Type u} {γ : Type u'} {b : β} {c : γ} {rest : List (β × γ)} :
    ∀ {m : List γ}, c ∈ m → (b, c) ∈ pairedWith b m rest
  | _, .head _ => .head _
  | _, .tail _ mem => .tail _ (mem_pairedWith_left mem)

theorem mem_pairedWith_right {β : Type u} {γ : Type u'} {b : β} {x : β × γ}
    {rest : List (β × γ)} : ∀ (m : List γ), x ∈ rest → x ∈ pairedWith b m rest
  | [], mem => mem
  | _ :: m, mem => .tail _ (mem_pairedWith_right m mem)

theorem mem_pairsOf {β : Type u} {γ : Type u'} {b : β} {c : γ} :
    ∀ {l : List β} {m : List γ}, b ∈ l → c ∈ m → (b, c) ∈ pairsOf l m
  | _, _, .head _, mem => mem_pairedWith_left mem
  | _, m, .tail _ listed, mem => mem_pairedWith_right m (mem_pairsOf listed mem)

/-- The length of the pairs of `b` before `rest`. -/
theorem length_pairedWith {β : Type u} {γ : Type u'} {b : β} {rest : List (β × γ)} :
    ∀ m : List γ, (pairedWith b m rest).length = rest.length + m.length
  | [] => rfl
  | _ :: m => congrArg (· + 1) (length_pairedWith m)

/-- The number of pairs is the product of the lengths. -/
theorem length_pairsOf {β : Type u} {γ : Type u'} (m : List γ) :
    ∀ l : List β, (pairsOf l m).length = m.length * l.length
  | [] => rfl
  | _ :: l => (length_pairedWith m).trans (congrArg (· + m.length) (length_pairsOf m l))

/-- What holds at a step of a decreasing family holds at every earlier step. -/
theorem holds_below {X : Type u} {P : Nat → X → Prop} (down : ∀ k x, P (k + 1) x → P k x)
    {x : X} {b : Nat} : ∀ {a : Nat}, b ≤ a → P a x → P b x := by
  intro a le
  induction le with
  | refl => exact fun holds => holds
  | step _ ih => exact fun holds => ih (down _ x holds)

/-- Where something holds at the first step of a decreasing family and fails at step `N`, it holds
at some step and fails at the next. -/
theorem drops_somewhere {X : Type u} {P : Nat → X → Prop} {x : X}
    (decided : ∀ k, Decided (P k x)) (first : P 0 x) :
    ∀ N, ¬ P N x → ∃ m, P m x ∧ ¬ P (m + 1) x
  | 0, fails => absurd first fails
  | N + 1, fails => match decided N with
    | .inl holds => ⟨N, holds, fails⟩
    | .inr fails' => drops_somewhere decided first N fails'

/-- Leaving out step `m` lands below `m` or above it. -/
theorem skip_side : ∀ m j, skipAt m j < m ∨ m + 1 ≤ skipAt m j
  | 0, j => .inr (Nat.succ_le_succ (Nat.zero_le j))
  | m + 1, 0 => .inl (Nat.succ_pos m)
  | m + 1, j + 1 => match skip_side m j with
    | .inl below => .inl (Nat.succ_lt_succ below)
    | .inr above => .inr (Nat.succ_le_succ above)

/-- Leaving out one step moves on by one step or, across the step left out, by two. -/
theorem skip_succ : ∀ m j, skipAt m (j + 1) = skipAt m j + 1 ∨ skipAt m (j + 1) = skipAt m j + 2
  | 0, _ => .inl rfl
  | 1, 0 => .inr rfl
  | _ + 2, 0 => .inl rfl
  | m + 1, j + 1 => match skip_succ m j with
    | .inl one => .inl (congrArg (· + 1) one)
    | .inr two => .inr (congrArg (· + 1) two)

/-- **A decreasing family decided at each step stops decreasing on a list within its length.**
Where what holds at a step held at the step before, and whether it holds is decided, at some step
no later than the length of the list nothing in it that holds there fails at the next. Each
member fails at most once, at the step after the last at which it holds; leaving that step out of
the family, the rest of the list stops decreasing within its own length. -/
theorem stops_decreasing {X : Type u} :
    ∀ (l : List X) (P : Nat → X → Prop), (∀ k x, P (k + 1) x → P k x) →
      (∀ k x, Decided (P k x)) → ∃ k, k ≤ l.length ∧ ∀ x, x ∈ l → P k x → P (k + 1) x
  | [], _, _, _ => ⟨0, Nat.le_refl 0, fun _ mem => nomatch mem⟩
  | y :: l, P, down, decided =>
    match decided (l.length + 1) y with
    | .inl lasting =>
      match stops_decreasing l P down decided with
      | ⟨k, within, steady⟩ => ⟨k, Nat.le_succ_of_le within, fun x mem => match mem_cons_cases mem with
          | .inl same => fun _ => Eq.subst (motive := fun z => P (k + 1) z) same.symm
              (holds_below down (Nat.succ_le_succ within) lasting)
          | .inr mem => steady x mem⟩
    | .inr ends =>
      match decided 0 y with
      | .inr never =>
        match stops_decreasing l P down decided with
        | ⟨k, within, steady⟩ => ⟨k, Nat.le_succ_of_le within, fun x mem =>
            match mem_cons_cases mem with
            | .inl same => fun holds => absurd (holds_below down (Nat.zero_le k)
                (Eq.subst (motive := fun z => P k z) same holds)) never
            | .inr mem => steady x mem⟩
      | .inl first =>
        match drops_somewhere (fun k => decided k y) first (l.length + 1) ends with
        | ⟨m, last, after⟩ =>
          match stops_decreasing l (fun j => P (skipAt m j))
              (fun j x holds => match skip_succ m j with
                | .inl one => down _ x (Eq.subst (motive := fun z => P z x) one holds)
                | .inr two => down _ x (down _ x (Eq.subst (motive := fun z => P z x) two holds)))
              (fun j x => decided (skipAt m j) x) with
          | ⟨k, within, steady⟩ =>
            ⟨skipAt m k, Nat.le_trans (skipAt_le m k) (Nat.succ_le_succ within), fun x mem =>
              match mem_cons_cases mem with
              | .inl same => match skip_side m k with
                | .inl below => fun _ => Eq.subst (motive := fun z => P (skipAt m k + 1) z)
                    same.symm (holds_below down below last)
                | .inr above => fun holds => absurd (holds_below down above
                    (Eq.subst (motive := fun z => P (skipAt m k) z) same holds)) after
              | .inr mem => fun holds => match skip_succ m k with
                | .inl one => Eq.subst (motive := fun z => P z x) one (steady x mem holds)
                | .inr two => down _ x
                    (Eq.subst (motive := fun z => P z x) two (steady x mem holds))⟩

/-- A branching test: nothing, a claim, the failure of a test, two tests together, or that some
step by a move leads to where a test holds. -/
inductive BranchingTest (A : Type v) (C : Type w) where
  | top
  | claim (c : C)
  | not (φ : BranchingTest A C)
  | both (φ ψ : BranchingTest A C)
  | can (a : A) (φ : BranchingTest A C)

/-- Where a branching test holds in a frame. -/
def BranchingTest.Holds (F : Frame S A C) : S → BranchingTest A C → Prop
  | _, .top => True
  | s, .claim c => F.realized s c
  | s, .not φ => ¬ BranchingTest.Holds F s φ
  | s, .both φ ψ => BranchingTest.Holds F s φ ∧ BranchingTest.Holds F s ψ
  | s, .can a φ => ∃ t, F.P.step s a t ∧ BranchingTest.Holds F t φ

/-- Two configurations pass the same branching tests. -/
def SameBranchingTests (F : Frame S A C) (G : Frame S' A C) (s : S) (s' : S') : Prop :=
  ∀ φ, BranchingTest.Holds F s φ ↔ BranchingTest.Holds G s' φ

/-! ### Likeness with relations among configurations

A frame may hold, beside its steps, a family of relations among its configurations, indexed by
`I`: `J i s l r` says that `s` holds `l` and `r` together under the `i`-th relation. Likeness, its
bisimulations and the tests are stated here once for any family. The frame with no relation (an
empty family) gives `Alike` and the branching tests (`alikeWith_empty_iff`,
`BranchingTest.holds_toWith`, and `Alike.holds_iff` below, proved from `AlikeWith.holds_iff`); the
joint frame of `Becoming.Composition` (a family of one) gives joint likeness and the joint tests. -/

section RelationsAmong

universe u'' x

variable {S'' : Type u''} {I : Type x}

/-- `B` matches the parts the wholes hold together: where `B` relates two configurations, each pair
of parts the first holds together under `J` is matched by a pair the second holds together under
`K`, related part by part. -/
def MatchesParts (J : S → S → S → Prop) (K : S' → S' → S' → Prop) (B : S → S' → Prop) : Prop :=
  ∀ s s', B s s' → ∀ l r, J s l r → ∃ l' r', K s' l' r' ∧ B l l' ∧ B r r'

/-- Matching parts passes to any relation holding exactly where the first does. -/
theorem MatchesParts.transport {J : S → S → S → Prop} {K : S' → S' → S' → Prop}
    {B B' : S → S' → Prop} (same : ∀ s s', B s s' ↔ B' s s') (matching : MatchesParts J K B) :
    MatchesParts J K B' :=
  fun s s' related l r joint =>
    match matching s s' ((same s s').mpr related) l r joint with
    | ⟨l', r', joint', left, right⟩ =>
      ⟨l', r', joint', (same l l').mp left, (same r r').mp right⟩

/-- Matching parts composes. -/
theorem MatchesParts.comp {J : S → S → S → Prop} {K : S' → S' → S' → Prop}
    {L : S'' → S'' → S'' → Prop} {B : S → S' → Prop} {B' : S' → S'' → Prop}
    (matching : MatchesParts J K B) (matching' : MatchesParts K L B') :
    MatchesParts J L fun s s'' => ∃ s', B s s' ∧ B' s' s'' :=
  fun s s'' ⟨s', related, related'⟩ l r joint =>
    match matching s s' related l r joint with
    | ⟨l', r', joint', left, right⟩ => match matching' s' s'' related' l' r' joint' with
      | ⟨l'', r'', joint'', left', right'⟩ =>
        ⟨l'', r'', joint'', ⟨l', left, left'⟩, ⟨r', right, right'⟩⟩

/-- A bisimulation with the relations: a bisimulation of the frames that matches, both ways and
relation by relation, the parts each whole holds together. -/
def BisimulationWith (F : Frame S A C) (G : Frame S' A C) (J : I → S → S → S → Prop)
    (K : I → S' → S' → S' → Prop) (B : S → S' → Prop) : Prop :=
  Bisimulation F G B ∧ ∀ i, MatchesParts (J i) (K i) B ∧ MatchesParts (K i) (J i) fun s' s => B s s'

/-- Sameness is a bisimulation with the relations. -/
theorem BisimulationWith.eq (F : Frame S A C) (J : I → S → S → S → Prop) :
    BisimulationWith F F J J fun s s' => s = s' :=
  ⟨Bisimulation.eq F, fun i =>
   ⟨fun _ _ same l r joint =>
     ⟨l, r, Eq.subst (motive := fun x => J i x l r) same joint, rfl, rfl⟩,
    fun _ _ same l r joint =>
     ⟨l, r, Eq.subst (motive := fun x => J i x l r) same.symm joint, rfl, rfl⟩⟩⟩

/-- The converse of a bisimulation with the relations is one. -/
theorem BisimulationWith.converse {F : Frame S A C} {G : Frame S' A C}
    {J : I → S → S → S → Prop} {K : I → S' → S' → S' → Prop} {B : S → S' → Prop}
    (bisim : BisimulationWith F G J K B) : BisimulationWith G F K J fun s' s => B s s' :=
  ⟨bisim.1.converse, fun i => ⟨(bisim.2 i).2, (bisim.2 i).1⟩⟩

/-- Bisimulations with the relations compose. -/
theorem BisimulationWith.comp {F : Frame S A C} {G : Frame S' A C} {H : Frame S'' A C}
    {J : I → S → S → S → Prop} {K : I → S' → S' → S' → Prop} {L : I → S'' → S'' → S'' → Prop}
    {B : S → S' → Prop} {B' : S' → S'' → Prop}
    (bisim : BisimulationWith F G J K B) (bisim' : BisimulationWith G H K L B') :
    BisimulationWith F H J L fun s s'' => ∃ s', B s s' ∧ B' s' s'' :=
  ⟨bisim.1.comp bisim'.1, fun i => ⟨(bisim.2 i).1.comp (bisim'.2 i).1,
   MatchesParts.transport
     (fun _ _ => ⟨fun ⟨s', related', related⟩ => ⟨s', related, related'⟩,
       fun ⟨s', related, related'⟩ => ⟨s', related', related⟩⟩)
     ((bisim'.2 i).2.comp (bisim.2 i).2)⟩⟩

/-- Two configurations are alike with the relations where some bisimulation with the relations
relates them: they relate alike to every continuation and to every pair of parts. -/
def AlikeWith (F : Frame S A C) (G : Frame S' A C) (J : I → S → S → S → Prop)
    (K : I → S' → S' → S' → Prop) (s : S) (s' : S') : Prop :=
  ∃ B, BisimulationWith F G J K B ∧ B s s'

/-- **Likeness with the relations is an equivalence:** every configuration is alike to itself, -/
theorem AlikeWith.refl (F : Frame S A C) (J : I → S → S → S → Prop) (s : S) :
    AlikeWith F F J J s s :=
  ⟨_, BisimulationWith.eq F J, rfl⟩

/-- it runs both ways, -/
theorem AlikeWith.symm {F : Frame S A C} {G : Frame S' A C} {J : I → S → S → S → Prop}
    {K : I → S' → S' → S' → Prop} {s : S} {s' : S'} : AlikeWith F G J K s s' → AlikeWith G F K J s' s
  | ⟨_, bisim, related⟩ => ⟨_, bisim.converse, related⟩

/-- and passes along. -/
theorem AlikeWith.trans {F : Frame S A C} {G : Frame S' A C} {H : Frame S'' A C}
    {J : I → S → S → S → Prop} {K : I → S' → S' → S' → Prop} {L : I → S'' → S'' → S'' → Prop}
    {s : S} {s' : S'} {s'' : S''} :
    AlikeWith F G J K s s' → AlikeWith G H K L s' s'' → AlikeWith F H J L s s''
  | ⟨_, bisim, related⟩, ⟨_, bisim', related'⟩ => ⟨_, bisim.comp bisim', s', related, related'⟩

/-- **Configurations alike with the relations are alike in the frames with the relations
forgotten.** -/
theorem AlikeWith.alike {F : Frame S A C} {G : Frame S' A C} {J : I → S → S → S → Prop}
    {K : I → S' → S' → S' → Prop} {s : S} {s' : S'} : AlikeWith F G J K s s' → Alike F G s s'
  | ⟨B, bisim, related⟩ => ⟨B, bisim.1, related⟩

/-- **With no relation, likeness with the relations is likeness.** -/
theorem alikeWith_empty_iff {F : Frame S A C} {G : Frame S' A C} {J : Empty → S → S → S → Prop}
    {K : Empty → S' → S' → S' → Prop} {s : S} {s' : S'} : AlikeWith F G J K s s' ↔ Alike F G s s' :=
  ⟨AlikeWith.alike, fun ⟨B, bisim, related⟩ => ⟨B, ⟨bisim, fun i => nomatch i⟩, related⟩⟩

/-- Configurations alike with the relations realize the same claims. -/
theorem AlikeWith.realized {F : Frame S A C} {G : Frame S' A C} {J : I → S → S → S → Prop}
    {K : I → S' → S' → S' → Prop} {s : S} {s' : S'} (alike : AlikeWith F G J K s s') (c : C) :
    F.realized s c ↔ G.realized s' c :=
  alike.alike.realized c

/-- A step of one is matched by a step of the other by the same move into configurations alike
with the relations. -/
theorem AlikeWith.step {F : Frame S A C} {G : Frame S' A C} {J : I → S → S → S → Prop}
    {K : I → S' → S' → S' → Prop} {s : S} {s' : S'} (alike : AlikeWith F G J K s s') {a : A} {t : S}
    (step : F.P.step s a t) : ∃ t', G.P.step s' a t' ∧ AlikeWith F G J K t t' :=
  match alike with
  | ⟨B, bisim, related⟩ => match (bisim.1 s s' related).2.1 a t step with
    | ⟨t', step', joined⟩ => ⟨t', step', B, bisim, joined⟩

/-- **A pair of parts one holds together under a relation is matched by a pair the other holds
together under it, alike part by part.** -/
theorem AlikeWith.parts {F : Frame S A C} {G : Frame S' A C} {J : I → S → S → S → Prop}
    {K : I → S' → S' → S' → Prop} {s : S} {s' : S'} (alike : AlikeWith F G J K s s') (i : I)
    {l r : S} (joint : J i s l r) :
    ∃ l' r', K i s' l' r' ∧ AlikeWith F G J K l l' ∧ AlikeWith F G J K r r' :=
  match alike with
  | ⟨B, bisim, related⟩ => match (bisim.2 i).1 s s' related l r joint with
    | ⟨l', r', joint', left, right⟩ => ⟨l', r', joint', ⟨B, bisim, left⟩, ⟨B, bisim, right⟩⟩

/-- Likeness with the relations in a frame matches the parts of each relation. -/
theorem AlikeWith.matchesParts (F : Frame S A C) (J : I → S → S → S → Prop) (i : I) :
    MatchesParts (J i) (J i) (AlikeWith F F J J) :=
  fun _ _ alike _ _ joint => alike.parts i joint

/-- **Where likeness with the relations tells apart the configurations of a frame, a configuration
is so alike to at most one of them.** -/
theorem AlikeWith.functional {F : Frame S A C} {G : Frame S' A C} {J : I → S → S → S → Prop}
    {K : I → S' → S' → S' → Prop} (separated : ∀ t t', AlikeWith G G K K t t' → t = t') {s : S}
    {t t' : S'} (alike : AlikeWith F G J K s t) (alike' : AlikeWith F G J K s t') : t = t' :=
  separated t t' (alike.symm.trans alike')

/-- A test with parts: nothing, a claim, the failure of a test, two tests together, that some step
by a move leads to where a test holds, or that the configuration holds together, under the `i`-th
relation, two parts, the first passing one test and the second the other. -/
inductive TestWith (I : Type x) (A : Type v) (C : Type w) where
  | top
  | claim (c : C)
  | not (φ : TestWith I A C)
  | both (φ ψ : TestWith I A C)
  | can (a : A) (φ : TestWith I A C)
  | together (i : I) (φ ψ : TestWith I A C)

/-- Where a test with parts holds in a frame with relations `J`. -/
def TestWith.Holds (F : Frame S A C) (J : I → S → S → S → Prop) : S → TestWith I A C → Prop
  | _, .top => True
  | s, .claim c => F.realized s c
  | s, .not φ => ¬ TestWith.Holds F J s φ
  | s, .both φ ψ => TestWith.Holds F J s φ ∧ TestWith.Holds F J s ψ
  | s, .can a φ => ∃ t, F.P.step s a t ∧ TestWith.Holds F J t φ
  | s, .together i φ ψ => ∃ l r, J i s l r ∧ TestWith.Holds F J l φ ∧ TestWith.Holds F J r ψ

/-- Two configurations pass the same tests with parts. -/
def SameTestsWith (F : Frame S A C) (G : Frame S' A C) (J : I → S → S → S → Prop)
    (K : I → S' → S' → S' → Prop) (s : S) (s' : S') : Prop :=
  ∀ φ, TestWith.Holds F J s φ ↔ TestWith.Holds G K s' φ

/-- Passing the same tests with parts is an equivalence: every configuration passes its own, -/
theorem SameTestsWith.refl (F : Frame S A C) (J : I → S → S → S → Prop) (s : S) :
    SameTestsWith F F J J s s :=
  fun _ => Iff.rfl

/-- both ways, -/
theorem SameTestsWith.symm {F : Frame S A C} {G : Frame S' A C} {J : I → S → S → S → Prop}
    {K : I → S' → S' → S' → Prop} {s : S} {s' : S'} (same : SameTestsWith F G J K s s') :
    SameTestsWith G F K J s' s :=
  fun φ => (same φ).symm

/-- and along. -/
theorem SameTestsWith.trans {F : Frame S A C} {G : Frame S' A C} {H : Frame S'' A C}
    {J : I → S → S → S → Prop} {K : I → S' → S' → S' → Prop} {L : I → S'' → S'' → S'' → Prop}
    {s : S} {s' : S'} {s'' : S''} (same : SameTestsWith F G J K s s')
    (same' : SameTestsWith G H K L s' s'') : SameTestsWith F H J L s s'' :=
  fun φ => (same φ).trans (same' φ)

/-- **Where the tests with parts tell apart the configurations of a frame, a configuration passes
the same tests as at most one of them.** -/
theorem SameTestsWith.functional {F : Frame S A C} {G : Frame S' A C} {J : I → S → S → S → Prop}
    {K : I → S' → S' → S' → Prop} (separated : ∀ t t', SameTestsWith G G K K t t' → t = t') {s : S}
    {t t' : S'} (same : SameTestsWith F G J K s t) (same' : SameTestsWith F G J K s t') : t = t' :=
  separated t t' (same.symm.trans same')

/-- Configurations alike with the relations agree on each test with parts. -/
theorem AlikeWith.holds_iff {F : Frame S A C} {G : Frame S' A C} {J : I → S → S → S → Prop}
    {K : I → S' → S' → S' → Prop} :
    ∀ (φ : TestWith I A C) {s : S} {s' : S'}, AlikeWith F G J K s s' →
      (TestWith.Holds F J s φ ↔ TestWith.Holds G K s' φ)
  | .top, _, _, _ => Iff.rfl
  | .claim c, _, _, alike => alike.realized c
  | .not φ, _, _, alike =>
    ⟨fun fails holds => fails ((AlikeWith.holds_iff φ alike).mpr holds),
     fun fails holds => fails ((AlikeWith.holds_iff φ alike).mp holds)⟩
  | .both φ ψ, _, _, alike =>
    ⟨fun ⟨holds, holds'⟩ =>
      ⟨(AlikeWith.holds_iff φ alike).mp holds, (AlikeWith.holds_iff ψ alike).mp holds'⟩,
     fun ⟨holds, holds'⟩ =>
      ⟨(AlikeWith.holds_iff φ alike).mpr holds, (AlikeWith.holds_iff ψ alike).mpr holds'⟩⟩
  | .can _ φ, _, _, alike =>
    ⟨fun ⟨_, step, holds⟩ => match alike.step step with
      | ⟨t', step', joined⟩ => ⟨t', step', (AlikeWith.holds_iff φ joined).mp holds⟩,
     fun ⟨_, step', holds⟩ => match alike.symm.step step' with
      | ⟨t, step, joined⟩ => ⟨t, step, (AlikeWith.holds_iff φ joined.symm).mpr holds⟩⟩
  | .together i φ ψ, _, _, alike =>
    ⟨fun ⟨_, _, joint, left, right⟩ => match alike.parts i joint with
      | ⟨l', r', joint', alikeL, alikeR⟩ =>
        ⟨l', r', joint', (AlikeWith.holds_iff φ alikeL).mp left,
          (AlikeWith.holds_iff ψ alikeR).mp right⟩,
     fun ⟨_, _, joint', left, right⟩ => match alike.symm.parts i joint' with
      | ⟨l, r, joint, alikeL, alikeR⟩ =>
        ⟨l, r, joint, (AlikeWith.holds_iff φ alikeL.symm).mpr left,
          (AlikeWith.holds_iff ψ alikeR.symm).mpr right⟩⟩

/-- **Configurations alike with the relations pass the same tests with parts.** -/
theorem AlikeWith.sameTestsWith {F : Frame S A C} {G : Frame S' A C} {J : I → S → S → S → Prop}
    {K : I → S' → S' → S' → Prop} {s : S} {s' : S'} (alike : AlikeWith F G J K s s') :
    SameTestsWith F G J K s s' :=
  fun φ => AlikeWith.holds_iff φ alike

/-- A branching test read as a test with parts that never asks for parts. -/
def BranchingTest.toWith : BranchingTest A C → TestWith I A C
  | .top => .top
  | .claim c => .claim c
  | .not φ => .not φ.toWith
  | .both φ ψ => .both φ.toWith ψ.toWith
  | .can a φ => .can a φ.toWith

/-- **A branching test holds in a frame exactly where its reading as a test with parts holds**,
whatever the relations. -/
theorem BranchingTest.holds_toWith {F : Frame S A C} {J : I → S → S → S → Prop} :
    ∀ (φ : BranchingTest A C) (s : S),
      BranchingTest.Holds F s φ ↔ TestWith.Holds F J s (φ.toWith (I := I))
  | .top, _ => Iff.rfl
  | .claim _, _ => Iff.rfl
  | .not φ, s => ⟨fun fails holds => fails ((BranchingTest.holds_toWith φ s).mpr holds),
      fun fails holds => fails ((BranchingTest.holds_toWith φ s).mp holds)⟩
  | .both φ ψ, s => ⟨fun ⟨first, second⟩ => ⟨(BranchingTest.holds_toWith φ s).mp first,
        (BranchingTest.holds_toWith ψ s).mp second⟩,
      fun ⟨first, second⟩ => ⟨(BranchingTest.holds_toWith φ s).mpr first,
        (BranchingTest.holds_toWith ψ s).mpr second⟩⟩
  | .can _ φ, _ => ⟨fun ⟨t, step, holds⟩ => ⟨t, step, (BranchingTest.holds_toWith φ t).mp holds⟩,
      fun ⟨t, step, holds⟩ => ⟨t, step, (BranchingTest.holds_toWith φ t).mpr holds⟩⟩

/-- **Configurations passing the same tests with parts pass the same branching tests.** -/
theorem SameTestsWith.sameBranchingTests {F : Frame S A C} {G : Frame S' A C}
    {J : I → S → S → S → Prop} {K : I → S' → S' → S' → Prop} {s : S} {s' : S'}
    (same : SameTestsWith F G J K s s') : SameBranchingTests F G s s' :=
  fun φ => (BranchingTest.holds_toWith φ s).trans
    ((same φ.toWith).trans (BranchingTest.holds_toWith φ s').symm)

end RelationsAmong

/-- Alike configurations agree on each branching test: the case of no relation of
`AlikeWith.holds_iff`. -/
theorem Alike.holds_iff {F : Frame S A C} {G : Frame S' A C} :
    ∀ (φ : BranchingTest A C) {s : S} {s' : S'}, Alike F G s s' →
      (BranchingTest.Holds F s φ ↔ BranchingTest.Holds G s' φ) :=
  fun φ {s} {s'} alike =>
    (BranchingTest.holds_toWith (J := fun i : Empty => nomatch i) φ s).trans
      ((AlikeWith.holds_iff φ.toWith (alikeWith_empty_iff.mpr alike)).trans
        (BranchingTest.holds_toWith (J := fun i : Empty => nomatch i) φ s').symm)

/-- **Alike configurations pass the same branching tests.** -/
theorem Alike.sameBranchingTests {F : Frame S A C} {G : Frame S' A C} {s : S} {s' : S'}
    (alike : Alike F G s s') : SameBranchingTests F G s s' :=
  fun φ => Alike.holds_iff φ alike

/-- **Where likeness tells apart the configurations of a frame, a configuration is alike to at most
one of them.** -/
theorem Alike.functional {F : Frame S A C} {G : Frame S' A C}
    (separated : ∀ t t', Alike G G t t' → t = t') {s : S} {t t' : S'} (alike : Alike F G s t)
    (alike' : Alike F G s t') : t = t' :=
  separated t t' (Alike.trans alike.symm alike')

/-- **Where branching tests tell apart the configurations of a frame, a configuration passes the
same tests as at most one of them.** -/
theorem SameBranchingTests.functional {F : Frame S A C} {G : Frame S' A C}
    (separated : ∀ t t', SameBranchingTests G G t t' → t = t') {s : S} {t t' : S'}
    (same : SameBranchingTests F G s t) (same' : SameBranchingTests F G s t') : t = t' :=
  separated t t' fun φ => (same φ).symm.trans (same' φ)

/-- Alike to depth `k`: the same claims, and for `k + 1` each step of either matched by a step of
the other by the same move into configurations alike to depth `k`. -/
def AlikeTo (F : Frame S A C) (G : Frame S' A C) : Nat → S → S' → Prop
  | 0, s, s' => ∀ c, F.realized s c ↔ G.realized s' c
  | k + 1, s, s' => (∀ c, F.realized s c ↔ G.realized s' c) ∧
      (∀ a t, F.P.step s a t → ∃ t', G.P.step s' a t' ∧ AlikeTo F G k t t') ∧
      (∀ a t', G.P.step s' a t' → ∃ t, F.P.step s a t ∧ AlikeTo F G k t t')

/-- Configurations alike to some depth realize the same claims. -/
theorem AlikeTo.realized {F : Frame S A C} {G : Frame S' A C} {s : S} {s' : S'} :
    ∀ {k : Nat}, AlikeTo F G k s s' → ∀ c, F.realized s c ↔ G.realized s' c
  | 0, alike => alike
  | _ + 1, alike => alike.1

/-- Alike to one depth more is alike to depth `k`. -/
theorem AlikeTo.of_succ {F : Frame S A C} {G : Frame S' A C} :
    ∀ {k : Nat} {s : S} {s' : S'}, AlikeTo F G (k + 1) s s' → AlikeTo F G k s s'
  | 0, _, _, alike => alike.1
  | _ + 1, _, _, ⟨claims, forth, back⟩ =>
    ⟨claims,
     fun a t step => match forth a t step with
      | ⟨t', step', joined⟩ => ⟨t', step', AlikeTo.of_succ joined⟩,
     fun a t' step' => match back a t' step' with
      | ⟨t, step, joined⟩ => ⟨t, step, AlikeTo.of_succ joined⟩⟩

/-- Alike to a depth is alike to every lower depth. -/
theorem AlikeTo.down_to {F : Frame S A C} {G : Frame S' A C} {s : S} {s' : S'} {b : Nat} :
    ∀ {a : Nat}, b ≤ a → AlikeTo F G a s s' → AlikeTo F G b s s' :=
  fun le => holds_below (P := fun k (x : S × S') => AlikeTo F G k x.1 x.2)
    (fun _ _ alike => AlikeTo.of_succ alike) (x := (s, s')) le

/-- Alike configurations are alike to every depth. -/
theorem Alike.alikeTo {F : Frame S A C} {G : Frame S' A C} :
    ∀ (k : Nat) {s : S} {s' : S'}, Alike F G s s' → AlikeTo F G k s s'
  | 0, _, _, alike => alike.realized
  | k + 1, _, _, alike =>
    ⟨alike.realized,
     fun _ _ step => match alike.step step with
      | ⟨t', step', joined⟩ => ⟨t', step', Alike.alikeTo k joined⟩,
     fun _ _ step' => match alike.symm.step step' with
      | ⟨t, step, joined⟩ => ⟨t, step, Alike.alikeTo k joined.symm⟩⟩

/-- A frame is finite and decided: some list holds every configuration, and whether a move takes
one configuration to another and whether a configuration realizes a claim are decided. -/
structure FiniteDecided (F : Frame S A C) : Prop where
  listed : ∃ l : List S, ∀ s, s ∈ l
  step : ∀ s a t, Decided (F.P.step s a t)
  realized : ∀ s c, Decided (F.realized s c)

variable {F : Frame S A C} {G : Frame S' A C}

/-- Whether two configurations realize the same claims is decided where the claims are listed
and decided. -/
theorem sameClaims_decided (claims : ∃ l : List C, ∀ c, c ∈ l) (finite : FiniteDecided F)
    (finite' : FiniteDecided G) (s : S) (s' : S') :
    Decided (∀ c, F.realized s c ↔ G.realized s' c) :=
  match claims with
  | ⟨_, allClaims⟩ => Decided.forall_of_listed allClaims fun c =>
    (finite.realized s c).iff (finite'.realized s' c)

/-- Whether each step of one configuration is matched by a step of the other into a decided
relation is decided where the moves are listed and both frames are finite and decided. -/
theorem forth_decided {R : S → S' → Prop} (moves : ∃ l : List A, ∀ a, a ∈ l)
    (finite : FiniteDecided F) (finite' : FiniteDecided G) (decided : ∀ t t', Decided (R t t'))
    (s : S) (s' : S') : Decided (∀ a t, F.P.step s a t → ∃ t', G.P.step s' a t' ∧ R t t') :=
  match moves, finite.listed, finite'.listed with
  | ⟨_, allMoves⟩, ⟨_, all⟩, ⟨_, all'⟩ =>
    Decided.forall_of_listed allMoves fun a => Decided.forall_of_listed all fun t =>
      (finite.step s a t).imp (Decided.exists_of_listed all' fun t' =>
        (finite'.step s' a t').and (decided t t'))

/-- Where not every step of one configuration is matched, some step by some move is matched by
no step of the other by that move. -/
theorem unmatched_of_not_forth {R : S → S' → Prop} (moves : ∃ l : List A, ∀ a, a ∈ l)
    (finite : FiniteDecided F) (finite' : FiniteDecided G) (decided : ∀ t t', Decided (R t t'))
    {s : S} {s' : S'} (fails : ¬ ∀ a t, F.P.step s a t → ∃ t', G.P.step s' a t' ∧ R t t') :
    ∃ a t, F.P.step s a t ∧ ∀ t', G.P.step s' a t' → ¬ R t t' :=
  match moves, finite.listed, finite'.listed with
  | ⟨_, allMoves⟩, ⟨_, all⟩, ⟨_, all'⟩ =>
    have matched : ∀ a t, Decided (∃ t', G.P.step s' a t' ∧ R t t') := fun a t =>
      Decided.exists_of_listed all' fun t' => (finite'.step s' a t').and (decided t t')
    match Decided.exists_not_of_listed allMoves (fun a => Decided.forall_of_listed all fun t =>
        (finite.step s a t).imp (matched a t)) fails with
    | ⟨a, failsAt⟩ =>
      match Decided.exists_not_of_listed all (fun t => (finite.step s a t).imp (matched a t))
          failsAt with
      | ⟨t, failsFrom⟩ =>
        ⟨a, t, (finite.step s a t).of_not_not fun stuck => failsFrom fun step => absurd step stuck,
         fun t' step' related => failsFrom fun _ => ⟨t', step', related⟩⟩

/-- **Alike to every depth is decided** where the moves and claims are listed and both frames are
finite and decided. -/
theorem AlikeTo.decided (moves : ∃ l : List A, ∀ a, a ∈ l) (claims : ∃ l : List C, ∀ c, c ∈ l)
    (finite : FiniteDecided F) (finite' : FiniteDecided G) :
    ∀ k s s', Decided (AlikeTo F G k s s')
  | 0, s, s' => sameClaims_decided claims finite finite' s s'
  | k + 1, s, s' =>
    (sameClaims_decided claims finite finite' s s').and
      ((forth_decided moves finite finite' (AlikeTo.decided moves claims finite finite' k) s s').and
        (forth_decided (R := fun t' t => AlikeTo F G k t t') moves finite' finite
          (fun t' t => AlikeTo.decided moves claims finite finite' k t t') s' s))

/-- One branching test holding at `x` and failing at every listed configuration of which `q`
holds, where for each such configuration some test holds at `x` and fails there. -/
theorem BranchingTest.apart_from_listed {S : Type u} {S' : Type u'} (F : Frame S A C)
    (G : Frame S' A C) {x : S} {q : S' → Prop} (decided : ∀ y, Decided (q y))
    (apart : ∀ y, q y → ∃ φ, BranchingTest.Holds F x φ ∧ ¬ BranchingTest.Holds G y φ) :
    ∀ l : List S', ∃ φ, BranchingTest.Holds F x φ ∧
      ∀ y, y ∈ l → q y → ¬ BranchingTest.Holds G y φ
  | [] => ⟨.top, True.intro, fun _ mem => nomatch mem⟩
  | y :: l => match BranchingTest.apart_from_listed F G decided apart l with
    | ⟨ψ, holds, fails⟩ => match decided y with
      | .inl here => match apart y here with
        | ⟨χ, holds', fails'⟩ =>
          ⟨.both χ ψ, ⟨holds', holds⟩, fun z mem at_z both =>
            match mem_cons_cases mem with
            | .inl same => fails' (Eq.subst (motive := fun w => BranchingTest.Holds G w χ) same
                (show BranchingTest.Holds G z χ ∧ BranchingTest.Holds G z ψ from both).1)
            | .inr mem => fails z mem at_z
                (show BranchingTest.Holds G z χ ∧ BranchingTest.Holds G z ψ from both).2⟩
      | .inr absent => ⟨ψ, holds, fun z mem at_z => match mem_cons_cases mem with
          | .inl same => absurd (Eq.subst (motive := q) same at_z) absent
          | .inr mem => fails z mem at_z⟩

/-- Where configurations differ in a claim, a claim or its failure tells them apart. -/
theorem apart_of_claims (claims : ∃ l : List C, ∀ c, c ∈ l) (finite : FiniteDecided F)
    (finite' : FiniteDecided G) {s : S} {s' : S'}
    (differ : ¬ ∀ c, F.realized s c ↔ G.realized s' c) :
    ∃ φ, BranchingTest.Holds F s φ ∧ ¬ BranchingTest.Holds G s' φ :=
  match claims with
  | ⟨_, allClaims⟩ =>
    match Decided.exists_not_of_listed allClaims
        (fun c => (finite.realized s c).iff (finite'.realized s' c)) differ with
    | ⟨c, not_same⟩ => match finite.realized s c with
      | .inl real => ⟨.claim c, real, fun real' => not_same ⟨fun _ => real', fun _ => real⟩⟩
      | .inr unreal => ⟨.not (.claim c), unreal, fun unreal' =>
          not_same ⟨fun real => absurd real unreal, fun real' => absurd real' unreal'⟩⟩

/-- **Where configurations are not alike to depth `k`, a branching test holds at one and fails at
the other.** The test is built from the decisions: a claim where the claims differ; where a step
of one is matched by no step of the other into configurations alike to depth `k - 1`, that the
move can lead to where the tests telling its outcome apart from each outcome of the other hold
together, or the failure of it. -/
theorem apart_of_not_alikeTo (moves : ∃ l : List A, ∀ a, a ∈ l)
    (claims : ∃ l : List C, ∀ c, c ∈ l) (finite : FiniteDecided F) (finite' : FiniteDecided G) :
    ∀ (k : Nat) {s : S} {s' : S'}, ¬ AlikeTo F G k s s' →
      ∃ φ, BranchingTest.Holds F s φ ∧ ¬ BranchingTest.Holds G s' φ
  | 0, _, _, fails => apart_of_claims claims finite finite' fails
  | k + 1, s, s', fails =>
    have below := AlikeTo.decided moves claims finite finite' k
    match sameClaims_decided claims finite finite' s s' with
    | .inr differ => apart_of_claims claims finite finite' differ
    | .inl same =>
      match forth_decided moves finite finite' below s s' with
      | .inr unmatched =>
        match unmatched_of_not_forth moves finite finite' below unmatched, finite'.listed with
        | ⟨a, t, step, unmet⟩, ⟨l', all'⟩ =>
          match BranchingTest.apart_from_listed F G (x := t) (q := fun t' => G.P.step s' a t')
              (fun t' => finite'.step s' a t')
              (fun t' step' => apart_of_not_alikeTo moves claims finite finite' k (unmet t' step'))
              l' with
          | ⟨φ, holds, fails'⟩ =>
            ⟨.can a φ, ⟨t, step, holds⟩, fun ⟨t', step', holds'⟩ =>
              fails' t' (all' t') step' holds'⟩
      | .inl forth =>
        match forth_decided (R := fun t' t => AlikeTo F G k t t') moves finite' finite
            (fun t' t => below t t') s' s with
        | .inl back => absurd ⟨same, forth, back⟩ fails
        | .inr unmatched =>
          match unmatched_of_not_forth (R := fun t' t => AlikeTo F G k t t') moves finite' finite
              (fun t' t => below t t') unmatched, finite.listed with
          | ⟨a, t', step', unmet⟩, ⟨l, all⟩ =>
            match BranchingTest.apart_from_listed G F (x := t') (q := fun t => F.P.step s a t)
                (fun t => finite.step s a t)
                (fun t step => match apart_of_not_alikeTo moves claims finite finite' k
                    (unmet t step) with
                  | ⟨φ, holds, fails'⟩ => ⟨.not φ, fails', fun refuted => refuted holds⟩)
                l with
            | ⟨φ, holds, fails'⟩ =>
              ⟨.not (.can a φ), fun ⟨t, step, holds'⟩ => fails' t (all t) step holds',
               fun refuted => refuted ⟨t', step', holds⟩⟩

/-- Configurations passing the same branching tests are alike to every depth. -/
theorem SameBranchingTests.alikeTo (moves : ∃ l : List A, ∀ a, a ∈ l)
    (claims : ∃ l : List C, ∀ c, c ∈ l) (finite : FiniteDecided F) (finite' : FiniteDecided G)
    {s : S} {s' : S'} (same : SameBranchingTests F G s s') (k : Nat) : AlikeTo F G k s s' :=
  (AlikeTo.decided moves claims finite finite' k s s').of_not_not fun fails =>
    match apart_of_not_alikeTo moves claims finite finite' k fails with
    | ⟨φ, holds, fails'⟩ => fails' ((same φ).mp holds)

/-- **Likeness to depth stops refining within the number of pairs**: where lists hold the
configurations of each frame, at some depth no greater than the number of pairs of their members,
configurations alike to it are alike to the next. -/
theorem AlikeTo.steady_within (moves : ∃ l : List A, ∀ a, a ∈ l)
    (claims : ∃ l : List C, ∀ c, c ∈ l) (finite : FiniteDecided F) (finite' : FiniteDecided G)
    {l : List S} {l' : List S'} (all : ∀ s, s ∈ l) (all' : ∀ s', s' ∈ l') :
    ∃ N, N ≤ l'.length * l.length ∧ ∀ s s', AlikeTo F G N s s' → AlikeTo F G (N + 1) s s' :=
  match stops_decreasing (pairsOf l l') (fun k x => AlikeTo F G k x.1 x.2)
      (fun _ _ alike => AlikeTo.of_succ alike)
      (fun k x => AlikeTo.decided moves claims finite finite' k x.1 x.2) with
  | ⟨N, within, steady⟩ =>
    ⟨N, Eq.subst (motive := fun n => N ≤ n) (length_pairsOf l' l) within,
     fun s s' => steady (s, s') (mem_pairsOf (all s) (all' s'))⟩

/-- **Likeness to depth stops refining**: at some depth, configurations alike to it are alike to
the next. -/
theorem AlikeTo.steady (moves : ∃ l : List A, ∀ a, a ∈ l) (claims : ∃ l : List C, ∀ c, c ∈ l)
    (finite : FiniteDecided F) (finite' : FiniteDecided G) :
    ∃ N, ∀ s s', AlikeTo F G N s s' → AlikeTo F G (N + 1) s s' :=
  match finite.listed, finite'.listed with
  | ⟨_, all⟩, ⟨_, all'⟩ =>
    match AlikeTo.steady_within moves claims finite finite' all all' with
    | ⟨N, _, steady⟩ => ⟨N, steady⟩

/-- Where likeness to depth `N` does not refine, it is a bisimulation. -/
theorem AlikeTo.bisimulation {N : Nat} (steady : ∀ s s', AlikeTo F G N s s' → AlikeTo F G (N + 1) s s') :
    Bisimulation F G (AlikeTo F G N) :=
  fun s s' alike => steady s s' alike

/-- **Branching tests fix likeness, constructively, where both frames are finite and decided.**
Where the moves and claims are listed, some list holds the configurations of each frame, and
whether a move steps and whether a claim is realized are decided, configurations are alike
exactly where they pass the same branching tests. -/
theorem alike_iff_sameBranchingTests (moves : ∃ l : List A, ∀ a, a ∈ l)
    (claims : ∃ l : List C, ∀ c, c ∈ l) (finite : FiniteDecided F) (finite' : FiniteDecided G)
    {s : S} {s' : S'} : Alike F G s s' ↔ SameBranchingTests F G s s' :=
  ⟨Alike.sameBranchingTests, fun same =>
    match AlikeTo.steady moves claims finite finite' with
    | ⟨N, steady⟩ =>
      ⟨AlikeTo F G N, AlikeTo.bisimulation steady,
       same.alikeTo moves claims finite finite' N⟩⟩

/-- **Likeness is decided where both frames are finite and decided**: it is likeness to the depth
at which likeness to depth stops refining. -/
theorem Alike.decided (moves : ∃ l : List A, ∀ a, a ∈ l) (claims : ∃ l : List C, ∀ c, c ∈ l)
    (finite : FiniteDecided F) (finite' : FiniteDecided G) (s : S) (s' : S') :
    Decided (Alike F G s s') :=
  match AlikeTo.steady moves claims finite finite' with
  | ⟨N, steady⟩ => match AlikeTo.decided moves claims finite finite' N s s' with
    | .inl alike => .inl ⟨AlikeTo F G N, AlikeTo.bisimulation steady, alike⟩
    | .inr fails => .inr fun alike => fails (alike.alikeTo N)

/-- **Where both frames are finite and decided, configurations are alike exactly where they are
alike to every depth.** -/
theorem alike_iff_alikeTo (moves : ∃ l : List A, ∀ a, a ∈ l)
    (claims : ∃ l : List C, ∀ c, c ∈ l) (finite : FiniteDecided F) (finite' : FiniteDecided G)
    {s : S} {s' : S'} : Alike F G s s' ↔ ∀ k, AlikeTo F G k s s' :=
  ⟨fun alike k => alike.alikeTo k, fun alike =>
    match AlikeTo.steady moves claims finite finite' with
    | ⟨N, steady⟩ => ⟨AlikeTo F G N, AlikeTo.bisimulation steady, alike N⟩⟩

/-- **Likeness is likeness to the depth of the number of pairs.** Where lists hold the
configurations of each frame, configurations are alike exactly where they are alike to the depth
given by the number of pairs of their members. -/
theorem alike_iff_alikeTo_pairs (moves : ∃ l : List A, ∀ a, a ∈ l)
    (claims : ∃ l : List C, ∀ c, c ∈ l) (finite : FiniteDecided F) (finite' : FiniteDecided G)
    {l : List S} {l' : List S'} (all : ∀ s, s ∈ l) (all' : ∀ s', s' ∈ l') {s : S} {s' : S'} :
    Alike F G s s' ↔ AlikeTo F G (l'.length * l.length) s s' :=
  ⟨fun alike => alike.alikeTo _, fun alike =>
    match AlikeTo.steady_within moves claims finite finite' all all' with
    | ⟨N, within, steady⟩ =>
      ⟨AlikeTo F G N, AlikeTo.bisimulation steady, AlikeTo.down_to within alike⟩⟩

end BranchingTests

/-! ## Within the classes -/

section Classes

variable {S : Type u} {S' : Type u'} {A : Type v} {C : Type w}

/-- A configuration is alike to itself to every depth. -/
theorem AlikeTo.self (F : Frame S A C) : ∀ (k : Nat) (s : S), AlikeTo F F k s s
  | 0, _ => fun _ => Iff.rfl
  | k + 1, _ =>
    ⟨fun _ => Iff.rfl, fun _ t step => ⟨t, step, AlikeTo.self F k t⟩,
     fun _ t step => ⟨t, step, AlikeTo.self F k t⟩⟩

/-- Alike to a depth, read the other way. -/
theorem AlikeTo.symm {F : Frame S A C} {G : Frame S' A C} :
    ∀ {k : Nat} {s : S} {s' : S'}, AlikeTo F G k s s' → AlikeTo G F k s' s
  | 0, _, _, alike => fun c => Iff.symm (alike c)
  | _ + 1, _, _, ⟨claims, forth, back⟩ =>
    ⟨fun c => Iff.symm (claims c),
     fun a t' step' => match back a t' step' with
      | ⟨t, step, joined⟩ => ⟨t, step, AlikeTo.symm joined⟩,
     fun a t step => match forth a t step with
      | ⟨t', step', joined⟩ => ⟨t', step', AlikeTo.symm joined⟩⟩

/-- Alike to a depth, through a third frame. -/
theorem AlikeTo.trans {S'' : Type w'} {F : Frame S A C} {G : Frame S' A C} {H : Frame S'' A C} :
    ∀ {k : Nat} {s : S} {s' : S'} {s'' : S''},
      AlikeTo F G k s s' → AlikeTo G H k s' s'' → AlikeTo F H k s s''
  | 0, _, _, _, alike, alike' => fun c => Iff.trans (alike c) (alike' c)
  | _ + 1, _, _, _, ⟨claims, forth, back⟩, ⟨claims', forth', back'⟩ =>
    ⟨fun c => Iff.trans (claims c) (claims' c),
     fun a t step => match forth a t step with
      | ⟨t', step', joined⟩ => match forth' a t' step' with
        | ⟨t'', step'', joined'⟩ => ⟨t'', step'', AlikeTo.trans joined joined'⟩,
     fun a t'' step'' => match back' a t'' step'' with
      | ⟨t', step', joined'⟩ => match back a t' step' with
        | ⟨t, step, joined⟩ => ⟨t, step, AlikeTo.trans joined joined'⟩⟩

/-- Within one frame, likeness to depth is a chain of equivalences, each finer than the one
before. -/
theorem AlikeTo.refining (F : Frame S A C) : Refining (AlikeTo F F) :=
  ⟨AlikeTo.self F, AlikeTo.symm, AlikeTo.trans, AlikeTo.of_succ⟩

/-- Alike to depth `k` across two frames read as one: a configuration of either with a
configuration of either. -/
def AlikeAcross (F : Frame S A C) (G : Frame S' A C) (k : Nat) : Sum S S' → Sum S S' → Prop
  | .inl s, .inl t => AlikeTo F F k s t
  | .inl s, .inr t' => AlikeTo F G k s t'
  | .inr s', .inl t => AlikeTo G F k s' t
  | .inr s', .inr t' => AlikeTo G G k s' t'

/-- Across two frames, likeness to depth is a chain of equivalences, each finer than the one
before. -/
theorem AlikeAcross.refining (F : Frame S A C) (G : Frame S' A C) : Refining (AlikeAcross F G) :=
  ⟨fun k x => match x with
    | .inl s => AlikeTo.self F k s
    | .inr s' => AlikeTo.self G k s',
   fun {_ x y} => match x, y with
    | .inl _, .inl _ => AlikeTo.symm
    | .inl _, .inr _ => AlikeTo.symm
    | .inr _, .inl _ => AlikeTo.symm
    | .inr _, .inr _ => AlikeTo.symm,
   fun {_ x y z} => match x, y, z with
    | .inl _, .inl _, .inl _ => AlikeTo.trans
    | .inl _, .inl _, .inr _ => AlikeTo.trans
    | .inl _, .inr _, .inl _ => AlikeTo.trans
    | .inl _, .inr _, .inr _ => AlikeTo.trans
    | .inr _, .inl _, .inl _ => AlikeTo.trans
    | .inr _, .inl _, .inr _ => AlikeTo.trans
    | .inr _, .inr _, .inl _ => AlikeTo.trans
    | .inr _, .inr _, .inr _ => AlikeTo.trans,
   fun {_ x y} => match x, y with
    | .inl _, .inl _ => AlikeTo.of_succ
    | .inl _, .inr _ => AlikeTo.of_succ
    | .inr _, .inl _ => AlikeTo.of_succ
    | .inr _, .inr _ => AlikeTo.of_succ⟩

/-- The members of a list, as members of either. -/
def rightsOf {β : Type u} {γ : Type u'} : List γ → List (Sum β γ)
  | [] => []
  | c :: l' => .inr c :: rightsOf l'

/-- The members of two lists, as one list of either. -/
def bothOf {β : Type u} {γ : Type u'} (l' : List γ) : List β → List (Sum β γ)
  | [] => rightsOf l'
  | b :: l => .inl b :: bothOf l' l

theorem length_rightsOf {β : Type u} {γ : Type u'} :
    ∀ l' : List γ, (rightsOf (β := β) l').length = l'.length
  | [] => rfl
  | _ :: l' => congrArg (· + 1) (length_rightsOf l')

theorem length_bothOf {β : Type u} {γ : Type u'} (l' : List γ) :
    ∀ l : List β, (bothOf l' l).length = l.length + l'.length
  | [] => (length_rightsOf l').trans (Nat.zero_add _).symm
  | _ :: l => (congrArg (· + 1) (length_bothOf l' l)).trans (Nat.succ_add _ _).symm

theorem mem_rightsOf {β : Type u} {γ : Type u'} {c : γ} :
    ∀ {l' : List γ}, c ∈ l' → (Sum.inr c : Sum β γ) ∈ rightsOf l'
  | [], mem => nomatch mem
  | d :: l', mem => match mem_cons_cases mem with
    | .inl here => Eq.subst (motive := fun w => (Sum.inr w : Sum β γ) ∈ rightsOf (d :: l'))
        here.symm (List.Mem.head _)
    | .inr later => List.Mem.tail _ (mem_rightsOf later)

theorem mem_bothOf_right {β : Type u} {γ : Type u'} {c : γ} {l' : List γ} (mem : c ∈ l') :
    ∀ l : List β, (Sum.inr c : Sum β γ) ∈ bothOf l' l
  | [] => mem_rightsOf mem
  | _ :: l => List.Mem.tail _ (mem_bothOf_right mem l)

theorem mem_bothOf_left {β : Type u} {γ : Type u'} {l' : List γ} {b : β} :
    ∀ {l : List β}, b ∈ l → (Sum.inl b : Sum β γ) ∈ bothOf l' l
  | [], mem => nomatch mem
  | d :: l, mem => match mem_cons_cases mem with
    | .inl here => Eq.subst (motive := fun w => (Sum.inl w : Sum β γ) ∈ bothOf l' (d :: l))
        here.symm (List.Mem.head _)
    | .inr later => List.Mem.tail _ (mem_bothOf_left later)

variable {F : Frame S A C} {G : Frame S' A C}

/-- Across two finite decided frames, likeness to every depth is decided. -/
theorem AlikeAcross.decided (moves : ∃ l : List A, ∀ a, a ∈ l)
    (claims : ∃ l : List C, ∀ c, c ∈ l) (finite : FiniteDecided F) (finite' : FiniteDecided G) :
    ∀ k x y, Decided (AlikeAcross F G k x y)
  | k, .inl s, .inl t => AlikeTo.decided moves claims finite finite k s t
  | k, .inl s, .inr t' => AlikeTo.decided moves claims finite finite' k s t'
  | k, .inr s', .inl t => AlikeTo.decided moves claims finite' finite k s' t
  | k, .inr s', .inr t' => AlikeTo.decided moves claims finite' finite' k s' t'

/-- **Within one frame, likeness to depth stops refining within its classes** (Moore, 1956).
Where a list of `N` configurations holds a finite decided frame and `c` configurations realize
pairwise different claims, at some depth `k` with `k + c ≤ N` configurations alike to it are
alike to the next: each strict refinement adds a class (`Refining.steady_within`).
`AlikeTo.steady_within` bounds the depth by the number of pairs. -/
theorem AlikeTo.steady_within_classes (moves : ∃ l : List A, ∀ a, a ∈ l)
    (claims : ∃ l : List C, ∀ c, c ∈ l) (finite : FiniteDecided F) {l : List S}
    (all : ∀ s, s ∈ l) {apart : List S} (distinct : DistinctUnder (AlikeTo F F 0) apart) :
    ∃ N, N + apart.length ≤ l.length ∧ ∀ s s', AlikeTo F F N s s' → AlikeTo F F (N + 1) s s' :=
  match (AlikeTo.refining F).steady_within (l := l)
      (fun k s s' _ _ => AlikeTo.decided moves claims finite finite k s s') distinct
      (fun s _ => all s) with
  | ⟨N, within, steady⟩ => ⟨N, within, fun s s' => steady s s' (all s) (all s')⟩

/-- **Within one frame of `N` configurations, likeness is likeness to depth `N - 1`.** -/
theorem alike_iff_alikeTo_classes (moves : ∃ l : List A, ∀ a, a ∈ l)
    (claims : ∃ l : List C, ∀ c, c ∈ l) (finite : FiniteDecided F) {l : List S}
    (all : ∀ s, s ∈ l) {s s' : S} : Alike F F s s' ↔ AlikeTo F F (l.length - 1) s s' :=
  ⟨fun alike => alike.alikeTo _, fun alike =>
    match AlikeTo.steady_within_classes moves claims finite all (DistinctUnder.single s) with
    | ⟨N, within, steady⟩ =>
      ⟨AlikeTo F F N, AlikeTo.bisimulation steady, AlikeTo.down_to (le_pred_of_succ_le within) alike⟩⟩

/-- **Across two frames, likeness to depth stops refining within their classes.** Where lists of
`N` and `N'` configurations hold two finite decided frames and `c` configurations of either
realize pairwise different claims, at some depth `k` with `k + c ≤ N + N'` configurations alike
to it are alike to the next: the two frames are read as one. -/
theorem AlikeTo.steady_within_across (moves : ∃ l : List A, ∀ a, a ∈ l)
    (claims : ∃ l : List C, ∀ c, c ∈ l) (finite : FiniteDecided F) (finite' : FiniteDecided G)
    {l : List S} {l' : List S'} (all : ∀ s, s ∈ l) (all' : ∀ s', s' ∈ l')
    {apart : List (Sum S S')} (distinct : DistinctUnder (AlikeAcross F G 0) apart) :
    ∃ N, N + apart.length ≤ l.length + l'.length ∧
      ∀ s s', AlikeTo F G N s s' → AlikeTo F G (N + 1) s s' :=
  have every : ∀ x : Sum S S', x ∈ bothOf l' l := fun x => match x with
    | .inl s => mem_bothOf_left (all s)
    | .inr s' => mem_bothOf_right (all' s') l
  match (AlikeAcross.refining F G).steady_within (l := bothOf l' l)
      (fun k x y _ _ => AlikeAcross.decided moves claims finite finite' k x y) distinct
      (fun x _ => every x) with
  | ⟨N, within, steady⟩ =>
    ⟨N, Eq.subst (motive := fun n => N + apart.length ≤ n) (length_bothOf l' l) within,
     fun s s' => steady (.inl s) (.inr s') (every _) (every _)⟩

/-- **Across two frames of `N` and `N'` configurations, likeness is likeness to depth
`N + N' - 1`.** -/
theorem alike_iff_alikeTo_across (moves : ∃ l : List A, ∀ a, a ∈ l)
    (claims : ∃ l : List C, ∀ c, c ∈ l) (finite : FiniteDecided F) (finite' : FiniteDecided G)
    {l : List S} {l' : List S'} (all : ∀ s, s ∈ l) (all' : ∀ s', s' ∈ l') {s : S} {s' : S'} :
    Alike F G s s' ↔ AlikeTo F G (l.length + l'.length - 1) s s' :=
  ⟨fun alike => alike.alikeTo _, fun alike =>
    match AlikeTo.steady_within_across moves claims finite finite' all all'
        (DistinctUnder.single (Sum.inl s)) with
    | ⟨N, within, steady⟩ =>
      ⟨AlikeTo F G N, AlikeTo.bisimulation steady, AlikeTo.down_to (le_pred_of_succ_le within) alike⟩⟩

/-- **For determined laws read through maps, likeness to depth `k` is agreement for
`k + 1` steps.** -/
theorem alikeTo_frameBy_iff {R : Type w} {next : S → S} {next' : S' → S'} {o : S → R}
    {o' : S' → R} : ∀ {k : Nat} {s : S} {s' : S'},
    AlikeTo (Law.frameBy next o) (Law.frameBy next' o') k s s' ↔
      ∀ n, n ≤ k → o (Law.orbit next s n) = o' (Law.orbit next' s' n)
  | 0, s, _ =>
    ⟨fun alike n le => match n, le with
      | 0, _ => ((alike (o s)).mp rfl).symm
      | m + 1, le => absurd le (Nat.not_succ_le_zero m),
     fun agree _ => ⟨fun at_s => (agree 0 (Nat.le_refl 0)).symm.trans at_s,
       fun at_s' => (agree 0 (Nat.le_refl 0)).trans at_s'⟩⟩
  | k + 1, s, s' =>
    ⟨fun ⟨claims, forth, _⟩ n le => match n, le with
      | 0, _ => ((claims (o s)).mp rfl).symm
      | m + 1, le => match forth () (next s) rfl with
        | ⟨_, step', joined⟩ =>
          (congrArg o (Law.orbit_shift next s m)).trans
            ((alikeTo_frameBy_iff.mp
                (Eq.subst (motive := fun t' => AlikeTo (Law.frameBy next o)
                  (Law.frameBy next' o') k (next s) t') (step' : _ = next' s') joined)
                m (Nat.le_of_succ_le_succ le)).trans
              (congrArg o' (Law.orbit_shift next' s' m)).symm),
     fun agree =>
      have ahead : AlikeTo (Law.frameBy next o) (Law.frameBy next' o') k (next s) (next' s') :=
        alikeTo_frameBy_iff.mpr fun m le =>
          (congrArg o (Law.orbit_shift next s m)).symm.trans
            ((agree (m + 1) (Nat.succ_le_succ le)).trans (congrArg o' (Law.orbit_shift next' s' m)))
      ⟨fun _ => ⟨fun at_s => (agree 0 (Nat.zero_le _)).symm.trans at_s,
         fun at_s' => (agree 0 (Nat.zero_le _)).trans at_s'⟩,
       fun _ t step => ⟨next' s', rfl, Eq.subst (motive := fun v => AlikeTo (Law.frameBy next o)
         (Law.frameBy next' o') k v (next' s')) (step : t = next s).symm ahead⟩,
       fun _ t' step' => ⟨next s, rfl, Eq.subst (motive := fun v => AlikeTo (Law.frameBy next o)
         (Law.frameBy next' o') k (next s) v) (step' : t' = next' s').symm ahead⟩⟩⟩

end Classes

/-! ### Within one frame the depth `N - 1` is exact -/

/-- The places below `k` among `n`, latest first. -/
def finBelow (n : Nat) : (k : Nat) → k ≤ n → List (Fin n)
  | 0, _ => []
  | k + 1, le => ⟨k, le⟩ :: finBelow n k (Nat.le_of_succ_le le)

theorem length_finBelow (n : Nat) : ∀ k (le : k ≤ n), (finBelow n k le).length = k
  | 0, _ => rfl
  | k + 1, le => congrArg (· + 1) (length_finBelow n k (Nat.le_of_succ_le le))

theorem mem_finBelow {n : Nat} (i : Fin n) : ∀ k (le : k ≤ n), i.val < k → i ∈ finBelow n k le
  | 0, _, lt => absurd lt (Nat.not_lt_zero _)
  | k + 1, le, lt => match Nat.lt_or_ge i.val k with
    | .inl below => List.Mem.tail _ (mem_finBelow i k (Nat.le_of_succ_le le) below)
    | .inr above => Eq.subst (motive := fun j => j ∈ finBelow n (k + 1) le)
        (Fin.eq_of_val_eq (i := ⟨k, le⟩) (j := i)
          (Nat.le_antisymm (Nat.le_of_lt_succ lt) above).symm) (List.Mem.head _)

/-- Room for one step and `k` more is room for `k` more after the step. -/
theorem room_after {a k n : Nat} (room : a + (k + 1) ≤ n) : a + 1 + k ≤ n :=
  Eq.subst (motive := fun v => v ≤ n) (Nat.succ_add a k).symm room

namespace EndOfPath

/-- A path of `M + 2` places, each stepping to the next and the last stepping nowhere, with
nothing claimed. -/
def frame (M : Nat) : Frame (Fin (M + 2)) Unit Empty :=
  ⟨⟨fun s _ t => t.val = s.val + 1⟩, fun _ c => nomatch c⟩

/-- The path is finite and decided. -/
theorem finite (M : Nat) : FiniteDecided (frame M) :=
  ⟨⟨finBelow (M + 2) (M + 2) (Nat.le_refl _), fun i => mem_finBelow i (M + 2) _ i.isLt⟩,
   fun s _ t => match Nat.decEq t.val (s.val + 1) with
    | isTrue same => .inl same
    | isFalse differ => .inr differ,
   fun _ c => nomatch c⟩

/-- Places with room for `k` steps are alike to depth `k`. -/
theorem alikeTo_room (M : Nat) : ∀ k (s t : Fin (M + 2)), s.val + k ≤ M + 1 → t.val + k ≤ M + 1 →
    AlikeTo (frame M) (frame M) k s t
  | 0, _, _, _, _ => fun c => nomatch c
  | k + 1, s, t, room, room' =>
    ⟨fun c => (nomatch c),
     fun _ s' step =>
      ⟨⟨t.val + 1, Nat.lt_succ_of_le (Nat.le_trans (Nat.succ_le_succ (Nat.le_add_right t.val k)) room')⟩,
       rfl, alikeTo_room M k s' _
        (Eq.subst (motive := fun v => v + k ≤ M + 1) (step : s'.val = s.val + 1).symm (room_after room))
        (room_after room')⟩,
     fun _ t' step' =>
      ⟨⟨s.val + 1, Nat.lt_succ_of_le (Nat.le_trans (Nat.succ_le_succ (Nat.le_add_right s.val k)) room)⟩,
       rfl, alikeTo_room M k _ t' (room_after room)
        (Eq.subst (motive := fun v => v + k ≤ M + 1) (step' : t'.val = t.val + 1).symm (room_after room'))⟩⟩

/-- A place with room for more than `k` steps and one with room for exactly `k` are not alike to
depth `k + 1`. -/
theorem not_alikeTo_past (M : Nat) : ∀ k (s t : Fin (M + 2)), s.val + k < M + 1 →
    t.val + k = M + 1 → ¬ AlikeTo (frame M) (frame M) (k + 1) s t
  | 0, s, t, room, last, ⟨_, forth, _⟩ =>
    match forth () ⟨s.val + 1, Nat.succ_lt_succ room⟩ rfl with
    | ⟨t', step', _⟩ => Nat.lt_irrefl (M + 2) (Eq.subst (motive := fun v => v < M + 2)
        ((step' : t'.val = t.val + 1).trans (congrArg (· + 1) last)) t'.isLt)
  | k + 1, s, t, room, last, ⟨_, forth, _⟩ =>
    have inside : s.val + 1 < M + 2 := Nat.lt_trans
      (Nat.lt_of_le_of_lt (Nat.succ_le_succ (Nat.le_add_right s.val k)) room) (Nat.lt_succ_self _)
    match forth () ⟨s.val + 1, inside⟩ rfl with
    | ⟨t', step', joined⟩ =>
      not_alikeTo_past M k ⟨s.val + 1, inside⟩ t'
        (Eq.subst (motive := fun v => v < M + 1) (Nat.succ_add s.val k).symm room)
        (Eq.subst (motive := fun v => v + k = M + 1) (step' : t'.val = t.val + 1).symm
          ((Nat.succ_add t.val k).trans last)) joined

/-- The first place. -/
def first (M : Nat) : Fin (M + 2) := ⟨0, Nat.zero_lt_succ _⟩

/-- The second place. -/
def second (M : Nat) : Fin (M + 2) := ⟨1, Nat.succ_lt_succ (Nat.zero_lt_succ M)⟩

/-- **Within one frame the depth `N - 1` is exact.** On the path of `N = M + 2` places, which a
list of `N` members holds, the first two places are alike to depth `N - 2` and are not alike:
likeness is likeness to depth `N - 1` (`alike_iff_alikeTo_classes`) and to no lower depth. -/
theorem classes_exact (M : Nat) :
    FiniteDecided (frame M) ∧ (finBelow (M + 2) (M + 2) (Nat.le_refl _)).length = M + 2 ∧
      AlikeTo (frame M) (frame M) M (first M) (second M) ∧
      ¬ Alike (frame M) (frame M) (first M) (second M) :=
  ⟨finite M, length_finBelow (M + 2) (M + 2) _,
   alikeTo_room M M (first M) (second M)
    (Eq.subst (motive := fun v => v ≤ M + 1) (Nat.zero_add M).symm (Nat.le_succ M))
    (Eq.subst (motive := fun v => v ≤ M + 1) (Nat.add_comm M 1) (Nat.le_refl (M + 1))),
   fun alike => not_alikeTo_past M M (first M) (second M)
    (Eq.subst (motive := fun v => v < M + 1) (Nat.zero_add M).symm (Nat.lt_succ_self M))
    (Nat.add_comm 1 M) (alike.alikeTo (M + 1))⟩

end EndOfPath

/-! ## Where likeness is not decided -/

namespace OneLoop

/-- One configuration with a step to itself exactly where `p` holds, and no claims. -/
def frame (p : Prop) : Frame Unit Unit Empty :=
  ⟨⟨fun _ _ _ => p⟩, fun _ c => nomatch c⟩

/-- The configuration of the frame of `p` is alike to that of the frame stepping always exactly
where `p` holds. -/
theorem alike_iff (p : Prop) : Alike (frame p) (frame True) () () ↔ p :=
  ⟨fun alike => match alike.symm.step (a := ()) (t := ()) True.intro with
    | ⟨_, step, _⟩ => step,
   fun holds => ⟨fun _ _ => True,
     fun _ _ _ => ⟨(fun c => nomatch c), fun _ _ _ => ⟨(), True.intro, True.intro⟩,
       fun _ _ _ => ⟨(), holds, True.intro⟩⟩, True.intro⟩⟩

end OneLoop

/-- **Likeness of finite frames is decided exactly under excluded middle.** Asked of every pair of
frames on one configuration, one move and no claims, whether two configurations are alike is
decided exactly where every proposition is: what the decided steps of `FiniteDecided` supply, at
the steps, cannot be dropped. -/
theorem alike_decided_iff_em :
    (∀ F G : Frame Unit Unit Empty, Decided (Alike F G () ())) ↔ ∀ p : Prop, Decided p :=
  ⟨fun decided p => match decided (OneLoop.frame p) (OneLoop.frame True) with
    | .inl alike => .inl ((OneLoop.alike_iff p).mp alike)
    | .inr fails => .inr fun holds => fails ((OneLoop.alike_iff p).mpr holds),
   fun em _ _ => em _⟩

/-! ## Where each move has listed outcomes -/

/-- **Of two decided families, each holding at a step where it holds at the next, one of which
holds at every step, one holds at every step.** A principle of reasoning, not a law of the
unfolding: excluded middle gives it, and the frames whose configurations are infinitely many and
whose moves have finitely many outcomes need it (`alike_of_sameBranchingTests_outcomes_iff`). It is
the lesser limited principle of omniscience for decided families
(`eitherThroughout_iff_llpoForDecided`), and gives `LLPO` (`LLPO.of_eitherThroughout`); weak
König's lemma is equivalent to `LLPO` (Ishihara 1990; Bridges and Richman 1987). -/
def EitherThroughout : Prop :=
  ∀ α β : Nat → Prop, (∀ k, Decided (α k)) → (∀ k, Decided (β k)) →
    (∀ k, α (k + 1) → α k) → (∀ k, β (k + 1) → β k) → (∀ k, α k ∨ β k) →
      (∀ k, α k) ∨ (∀ k, β k)

/-- **Excluded middle gives `EitherThroughout`**: where the first family fails somewhere, the
second holds at every later step and so at every step; where it fails nowhere, it holds at every
step. -/
theorem EitherThroughout.of_em (em : ∀ p : Prop, Decided p) : EitherThroughout :=
  fun α β decided _ down down' each => match em (∃ k, ¬ α k) with
  | .inl ⟨k, fails⟩ => .inr fun m => match each (m + k) with
    | .inl holds => absurd (holds_below (P := fun j (_ : Unit) => α j) (x := ())
        (fun j _ holds => down j holds) (Nat.le_add_left k m) holds) fails
    | .inr holds => holds_below (P := fun j (_ : Unit) => β j) (x := ())
        (fun j _ holds => down' j holds) (Nat.le_add_right m k) holds
  | .inr absent => .inl fun k => (decided k).of_not_not fun fails => absent ⟨k, fails⟩

/-- **Of two decided families that do not both hold somewhere, one holds nowhere.** A principle of
reasoning: `EitherThroughout` in another form (`eitherThroughout_iff_eitherNever`). -/
def EitherNever : Prop :=
  ∀ α β : Nat → Prop, (∀ k, Decided (α k)) → (∀ k, Decided (β k)) →
    ¬ ((∃ k, α k) ∧ (∃ k, β k)) → (∀ k, ¬ α k) ∨ (∀ k, ¬ β k)

/-- **Whether a decided family holds nowhere is decided.** A principle of reasoning that excluded
middle gives (`NowhereDecided.of_em`) and that gives `EitherNever`. -/
def NowhereDecided : Prop :=
  ∀ α : Nat → Prop, (∀ k, Decided (α k)) → Decided (∀ k, ¬ α k)

/-- **`EitherThroughout` is `EitherNever`.** Given `EitherThroughout`, the families "the first
family has not yet held" and "the second has not yet held" are decided and decreasing, and one of
them holds at each step, since both failing would give both families holding somewhere; so one
holds throughout. Given `EitherNever`, where two decreasing families hold one at each step, their
failures do not both occur somewhere, since failing at `k` and at `j` both fail at `k + j`. -/
theorem eitherThroughout_iff_eitherNever : EitherThroughout ↔ EitherNever :=
  ⟨fun either α β decided decided' apart =>
    let below := fun (γ : Nat → Prop) (decided : ∀ k, Decided (γ k)) k =>
      Decided.exists_below (P := γ) (M := 0) (U := k + 1) fun t _ _ => decided t
    match either (fun k => ¬ ∃ t, 0 ≤ t ∧ t < k + 1 ∧ α t)
        (fun k => ¬ ∃ t, 0 ≤ t ∧ t < k + 1 ∧ β t) (fun k => (below α decided k).not)
        (fun k => (below β decided' k).not)
        (fun _ absent ⟨t, from_, early, holds⟩ => absent ⟨t, from_, Nat.lt_succ_of_lt early, holds⟩)
        (fun _ absent ⟨t, from_, early, holds⟩ => absent ⟨t, from_, Nat.lt_succ_of_lt early, holds⟩)
        (fun k => match below α decided k, below β decided' k with
          | .inl ⟨t, _, _, holds⟩, .inl ⟨t', _, _, holds'⟩ =>
            absurd ⟨⟨t, holds⟩, ⟨t', holds'⟩⟩ apart
          | .inr absent, _ => .inl absent
          | _, .inr absent => .inr absent) with
    | .inl absent => .inl fun k holds => absent k ⟨k, Nat.zero_le k, Nat.lt_succ_self k, holds⟩
    | .inr absent => .inr fun k holds => absent k ⟨k, Nat.zero_le k, Nat.lt_succ_self k, holds⟩,
   fun never α β decided decided' down down' each =>
    match never (fun k => ¬ α k) (fun k => ¬ β k) (fun k => (decided k).not)
        (fun k => (decided' k).not) (fun ⟨⟨k, fails⟩, ⟨j, fails'⟩⟩ => match each (k + j) with
          | .inl holds => fails (holds_below (P := fun i (_ : Unit) => α i) (x := ())
              (fun i _ holds => down i holds) (Nat.le_add_right k j) holds)
          | .inr holds => fails' (holds_below (P := fun i (_ : Unit) => β i) (x := ())
              (fun i _ holds => down' i holds) (Nat.le_add_left j k) holds)) with
    | .inl never => .inl fun k => (decided k).of_not_not (never k)
    | .inr never => .inr fun k => (decided' k).of_not_not (never k)⟩

/-- **`NowhereDecided` gives `EitherNever`**: where the first family holds nowhere, done; where it
does not hold nowhere, the second holding somewhere would make both hold somewhere. -/
theorem EitherNever.of_nowhereDecided (nowhere : NowhereDecided) : EitherNever :=
  fun α _ decided _ apart => match nowhere α decided with
  | .inl absent => .inl absent
  | .inr present => .inr fun k holds => present fun k' holds' => apart ⟨⟨k', holds'⟩, ⟨k, holds⟩⟩

/-- Excluded middle gives `NowhereDecided`. -/
theorem NowhereDecided.of_em (em : ∀ p : Prop, Decided p) : NowhereDecided :=
  fun _ _ => em _

/-- **`NowhereDecided` gives `EitherThroughout`.** -/
theorem EitherThroughout.of_nowhereDecided (nowhere : NowhereDecided) : EitherThroughout :=
  eitherThroughout_iff_eitherNever.mpr (EitherNever.of_nowhereDecided nowhere)

/-! ## `EitherThroughout` is the lesser limited principle of omniscience

Beside `LPO` (`Becoming.Change`) and `WLPO` (`Becoming.Sensitivity`), the lesser limited principle
in its standard form, for Boolean sequences with at most one `true`. `EitherThroughout` is that
principle for decided families, exactly; for Boolean sequences it gives the standard form, and the
standard form gives the family form wherever the decisions are given as data. -/

/-- **The lesser limited principle of omniscience** (`LLPO`), in its standard form: of a Boolean
sequence with at most one `true`, the even places are all `false` or the odd places are. The
limited principle gives it (`LLPO.of_lpo`); it has no constructive proof. -/
def LLPO : Prop :=
  ∀ s : Nat → Bool, (∀ m n, s m = true → s n = true → m = n) →
    (∀ n, s (2 * n) = false) ∨ ∀ n, s (2 * n + 1) = false

/-- **`LLPO` for decided families**: a family decided at each place and holding at most once
fails at every even place or at every odd place. -/
def LLPOForDecided : Prop :=
  ∀ γ : Nat → Prop, (∀ n, Decided (γ n)) → (∀ m n, γ m → γ n → m = n) →
    (∀ n, ¬ γ (2 * n)) ∨ ∀ n, ¬ γ (2 * n + 1)

namespace LLPO

/-- The successor is one to one, read through the predecessor. -/
theorem succ_inj {m n : Nat} (same : m + 1 = n + 1) : m = n :=
  congrArg Nat.pred same

/-- No even number is odd. -/
theorem two_mul_ne_succ : ∀ m n : Nat, 2 * m ≠ 2 * n + 1
  | 0, n, same => Naturals.succ_ne_zero (2 * n) same.symm
  | m + 1, 0, same => Naturals.succ_ne_zero (2 * m) (succ_inj same)
  | m + 1, n + 1, same => two_mul_ne_succ m n (succ_inj (succ_inj same))

/-- Twice is one to one. -/
theorem two_mul_inj : ∀ m n : Nat, 2 * m = 2 * n → m = n
  | 0, 0, _ => rfl
  | 0, n + 1, same => absurd same.symm (Naturals.succ_ne_zero (2 * n + 1))
  | m + 1, 0, same => absurd same (Naturals.succ_ne_zero (2 * m + 1))
  | m + 1, n + 1, same =>
    congrArg (· + 1) (two_mul_inj m n (succ_inj (succ_inj same)))

/-- Whether a Boolean value is `true` is decided. -/
theorem decided_true (b : Bool) : Decided (b = true) :=
  match b with
  | true => .inl rfl
  | false => .inr fun no => Bool.noConfusion no

/-- A Boolean value not `true` is `false`. -/
theorem eq_false_of_not : ∀ (b : Bool), ¬ b = true → b = false
  | true, no => absurd rfl no
  | false, _ => rfl

/-- **The limited principle gives the lesser one.** Where some even place is `true`, every odd
place is `false`, since a sequence with at most one `true` has no other. -/
theorem of_lpo (lpo : LPO) : LLPO :=
  fun s once => match lpo (fun n => s (2 * n)) with
  | .inl ⟨n, yes⟩ => .inr fun m =>
      eq_false_of_not _ fun yes' => two_mul_ne_succ n m (once _ _ yes yes')
  | .inr evens => .inl evens

/-- **The family form gives the standard form**: a Boolean sequence is a decided family. -/
theorem of_forDecided (family : LLPOForDecided) : LLPO :=
  fun s once => match family (fun n => s n = true) (fun n => decided_true (s n)) once with
  | .inl evens => .inl fun n => eq_false_of_not _ (evens n)
  | .inr odds => .inr fun n => eq_false_of_not _ (odds n)

/-- **The standard form gives the family form where the decisions are data**: a family decided
by `Decidable` at each place is read as the Boolean sequence of its decisions. -/
theorem decidable (llpo : LLPO) (γ : Nat → Prop) (dec : ∀ n, Decidable (γ n))
    (once : ∀ m n, γ m → γ n → m = n) : (∀ n, ¬ γ (2 * n)) ∨ ∀ n, ¬ γ (2 * n + 1) :=
  match llpo (fun n => @Decidable.decide (γ n) (dec n))
      (fun m n yes yes' => once m n (@of_decide_eq_true _ (dec m) yes)
        (@of_decide_eq_true _ (dec n) yes')) with
  | .inl evens => .inl fun n holds =>
      Bool.noConfusion ((@decide_eq_true _ (dec (2 * n)) holds).symm.trans (evens n))
  | .inr odds => .inr fun n holds =>
      Bool.noConfusion ((@decide_eq_true _ (dec (2 * n + 1)) holds).symm.trans (odds n))

/-- `k` is the first place at which `α` holds. -/
def FirstAt (α : Nat → Prop) (k : Nat) : Prop :=
  α k ∧ ¬ ∃ t, 0 ≤ t ∧ t < k ∧ α t

theorem FirstAt.decided {α : Nat → Prop} (decided : ∀ k, Decided (α k)) (k : Nat) :
    Decided (FirstAt α k) :=
  (decided k).and (Decided.exists_below (P := α) (M := 0) (U := k) fun t _ _ => decided t).not

/-- A family holds first at one place at most. -/
theorem FirstAt.unique {α : Nat → Prop} {i j : Nat} (first : FirstAt α i) (first' : FirstAt α j) :
    i = j :=
  match Nat.lt_or_ge i j with
  | .inl lt => absurd ⟨i, Nat.zero_le i, lt, first.1⟩ first'.2
  | .inr ge => match Nat.lt_or_ge j i with
    | .inl lt => absurd ⟨j, Nat.zero_le j, lt, first'.1⟩ first.2
    | .inr ge' => Nat.le_antisymm ge' ge

/-- A decided family holding somewhere below `N` holds first somewhere. -/
theorem FirstAt.of_holds {α : Nat → Prop} (decided : ∀ k, Decided (α k)) :
    ∀ N k, k < N → α k → ∃ i, FirstAt α i
  | 0, k, lt, _ => absurd lt (Nat.not_lt_zero k)
  | N + 1, k, lt, holds =>
    match Decided.exists_below (P := α) (M := 0) (U := k) (fun t _ _ => decided t) with
    | .inr absent => ⟨k, holds, absent⟩
    | .inl ⟨t, _, below, holds'⟩ =>
      FirstAt.of_holds decided N t (Nat.lt_of_lt_of_le below (Nat.le_of_lt_succ lt)) holds'

/-- Two families read at the even and the odd places. -/
def Interleave (α β : Nat → Prop) (n : Nat) : Prop :=
  (∃ k, n = 2 * k ∧ α k) ∨ ∃ k, n = 2 * k + 1 ∧ β k

theorem Interleave.even {α β : Nat → Prop} {k : Nat} : Interleave α β (2 * k) ↔ α k :=
  ⟨fun
    | .inl ⟨j, same, holds⟩ => Eq.subst (motive := α) (two_mul_inj k j same).symm holds
    | .inr ⟨j, same, _⟩ => absurd same (two_mul_ne_succ k j),
   fun holds => .inl ⟨k, rfl, holds⟩⟩

theorem Interleave.odd {α β : Nat → Prop} {k : Nat} : Interleave α β (2 * k + 1) ↔ β k :=
  ⟨fun
    | .inl ⟨j, same, _⟩ => absurd same.symm (two_mul_ne_succ j k)
    | .inr ⟨j, same, holds⟩ =>
      Eq.subst (motive := β) (two_mul_inj k j (succ_inj same)).symm holds,
   fun holds => .inr ⟨k, rfl, holds⟩⟩

theorem Interleave.decided {α β : Nat → Prop} (decided : ∀ k, Decided (α k))
    (decided' : ∀ k, Decided (β k)) (n : Nat) : Decided (Interleave α β n) :=
  match Pulse.parity n with
  | .inl ⟨k, e⟩ => Eq.subst (motive := fun x => Decided (Interleave α β x)) e.symm
      (match decided k with
       | .inl holds => .inl (Interleave.even.mpr holds)
       | .inr fails => .inr fun holds => fails (Interleave.even.mp holds))
  | .inr ⟨k, e⟩ => Eq.subst (motive := fun x => Decided (Interleave α β x)) e.symm
      (match decided' k with
       | .inl holds => .inl (Interleave.odd.mpr holds)
       | .inr fails => .inr fun holds => fails (Interleave.odd.mp holds))

end LLPO

/-- **`EitherNever` is the lesser limited principle for decided families.** Given `EitherNever`,
the even and the odd places of a family holding at most once do not both hold somewhere. Given
the principle, the first places at which two families hold, read at the even and the odd places,
hold at most once where the families do not both hold somewhere; where no first place of one
holds, the family holds nowhere. -/
theorem eitherNever_iff_llpoForDecided : EitherNever ↔ LLPOForDecided :=
  ⟨fun never γ decided once =>
    never (fun n => γ (2 * n)) (fun n => γ (2 * n + 1)) (fun _ => decided _) (fun _ => decided _)
      (fun ⟨⟨m, even⟩, ⟨n, odd⟩⟩ => LLPO.two_mul_ne_succ m n (once _ _ even odd)),
   fun llpo α β decided decided' apart =>
    match llpo (LLPO.Interleave (LLPO.FirstAt α) (LLPO.FirstAt β))
        (LLPO.Interleave.decided (LLPO.FirstAt.decided decided) (LLPO.FirstAt.decided decided'))
        (fun _ _ holds holds' => match holds, holds' with
          | .inl ⟨_, e, first⟩, .inl ⟨_, e', first'⟩ =>
            e.trans ((congrArg (2 * ·) (LLPO.FirstAt.unique first first')).trans e'.symm)
          | .inl ⟨i, _, first⟩, .inr ⟨j, _, first'⟩ => absurd ⟨⟨i, first.1⟩, ⟨j, first'.1⟩⟩ apart
          | .inr ⟨i, _, first⟩, .inl ⟨j, _, first'⟩ => absurd ⟨⟨j, first'.1⟩, ⟨i, first.1⟩⟩ apart
          | .inr ⟨_, e, first⟩, .inr ⟨_, e', first'⟩ =>
            e.trans ((congrArg (2 * · + 1) (LLPO.FirstAt.unique first first')).trans e'.symm)) with
    | .inl evens => .inl fun k holds =>
        match LLPO.FirstAt.of_holds decided (k + 1) k (Nat.lt_succ_self k) holds with
        | ⟨i, first⟩ => evens i (LLPO.Interleave.even.mpr first)
    | .inr odds => .inr fun k holds =>
        match LLPO.FirstAt.of_holds decided' (k + 1) k (Nat.lt_succ_self k) holds with
        | ⟨i, first⟩ => odds i (LLPO.Interleave.odd.mpr first)⟩

/-- **`EitherThroughout` is the lesser limited principle of omniscience**, for decided families:
of two decided, decreasing families one of which holds at each step, one holds at every step,
exactly where every decided family holding at most once fails at every even place or at every odd
place. -/
theorem eitherThroughout_iff_llpoForDecided : EitherThroughout ↔ LLPOForDecided :=
  eitherThroughout_iff_eitherNever.trans eitherNever_iff_llpoForDecided

/-- **`EitherThroughout` gives `LLPO`** in its standard form, for Boolean sequences. -/
theorem LLPO.of_eitherThroughout (either : EitherThroughout) : LLPO :=
  LLPO.of_forDecided (eitherThroughout_iff_llpoForDecided.mp either)

section Outcomes

variable {S : Type u} {S' : Type u'} {A : Type v} {C : Type w}

/-- Whether a decided determination holds of every member of a list is decided. -/
theorem Decided.forall_in {β : Type u} {P : β → Prop} {l : List β}
    (decided : ∀ b, b ∈ l → Decided (P b)) : Decided (∀ b, b ∈ l → P b) :=
  match Decided.exists_listed (l := l) fun b mem => (decided b mem).not with
  | .inl ⟨b, mem, fails⟩ => .inr fun all => fails (all b mem)
  | .inr absent => .inl fun b mem => (decided b mem).of_not_not fun fails => absent ⟨b, mem, fails⟩

/-- **One member of a list holds a decreasing family throughout, where one member holds it at
each step**, given `EitherThroughout`: the first member holds it throughout, or the rest hold it
at each step, since where both failed at some steps they would fail together at the later. -/
theorem EitherThroughout.list (either : EitherThroughout) {β : Type u} {P : Nat → β → Prop}
    (decided : ∀ k b, Decided (P k b)) (down : ∀ k b, P (k + 1) b → P k b) :
    ∀ l : List β, (∀ k, ∃ b, b ∈ l ∧ P k b) → ∃ b, b ∈ l ∧ ∀ k, P k b
  | [], each => match each 0 with
    | ⟨_, mem, _⟩ => nomatch mem
  | b :: l, each =>
    match either (fun k => P k b) (fun k => ∃ c, c ∈ l ∧ P k c) (fun k => decided k b)
        (fun k => Decided.exists_listed fun c _ => decided k c) (fun k => down k b)
        (fun k ⟨c, mem, holds⟩ => ⟨c, mem, down k c holds⟩)
        (fun k => match each k with
          | ⟨c, mem, holds⟩ => match mem_cons_cases mem with
            | .inl same => .inl (Eq.subst (motive := P k) same holds)
            | .inr mem => .inr ⟨c, mem, holds⟩) with
    | .inl first => ⟨b, .head l, first⟩
    | .inr rest => match EitherThroughout.list either decided down l rest with
      | ⟨c, mem, holds⟩ => ⟨c, .tail b mem, holds⟩

/-- A frame whose moves each have listed outcomes and whose claims are decided. -/
structure OutcomesListed (F : Frame S A C) : Prop where
  outcomes : ∀ s a, ∃ l : List S, ∀ t, F.P.step s a t ↔ t ∈ l
  realized : ∀ s c, Decided (F.realized s c)

variable {F : Frame S A C} {G : Frame S' A C}

/-- Whether two configurations realize the same claims is decided where the claims are listed
and decided. -/
theorem OutcomesListed.sameClaims_decided (claims : ∃ l : List C, ∀ c, c ∈ l)
    (listed : OutcomesListed F) (listed' : OutcomesListed G) (s : S) (s' : S') :
    Decided (∀ c, F.realized s c ↔ G.realized s' c) :=
  match claims with
  | ⟨_, allClaims⟩ => Decided.forall_of_listed allClaims fun c =>
    (listed.realized s c).iff (listed'.realized s' c)

/-- Whether an outcome of a move is matched by an outcome of the other configuration's move into a
decided relation is decided where the outcomes are listed. -/
theorem OutcomesListed.matched_decided {R : S → S' → Prop} (listed' : OutcomesListed G)
    (decided : ∀ t t', Decided (R t t')) (s' : S') (a : A) (t : S) :
    Decided (∃ t', G.P.step s' a t' ∧ R t t') :=
  match listed'.outcomes s' a with
  | ⟨_, outcome'⟩ =>
    match Decided.exists_listed fun t' _ => decided t t' with
    | .inl ⟨t', mem, related⟩ => .inl ⟨t', (outcome' t').mpr mem, related⟩
    | .inr absent => .inr fun ⟨t', step, related⟩ => absent ⟨t', (outcome' t').mp step, related⟩

/-- Whether each outcome of one configuration is matched is decided where the moves are listed
and the outcomes of both frames are listed. -/
theorem OutcomesListed.forth_decided {R : S → S' → Prop} (moves : ∃ l : List A, ∀ a, a ∈ l)
    (listed : OutcomesListed F) (listed' : OutcomesListed G) (decided : ∀ t t', Decided (R t t'))
    (s : S) (s' : S') : Decided (∀ a t, F.P.step s a t → ∃ t', G.P.step s' a t' ∧ R t t') :=
  match moves with
  | ⟨_, allMoves⟩ => Decided.forall_of_listed allMoves fun a =>
    match listed.outcomes s a with
    | ⟨_, outcome⟩ =>
      match Decided.forall_in fun t _ => listed'.matched_decided decided s' a t with
      | .inl all => .inl fun t step => all t ((outcome t).mp step)
      | .inr fails => .inr fun all => fails fun t mem => all t ((outcome t).mpr mem)

/-- Where not every outcome of one configuration is matched, some outcome of some move is matched
by no outcome of the other's move. -/
theorem OutcomesListed.unmatched {R : S → S' → Prop} (moves : ∃ l : List A, ∀ a, a ∈ l)
    (listed : OutcomesListed F) (listed' : OutcomesListed G) (decided : ∀ t t', Decided (R t t'))
    {s : S} {s' : S'} (fails : ¬ ∀ a t, F.P.step s a t → ∃ t', G.P.step s' a t' ∧ R t t') :
    ∃ a t, F.P.step s a t ∧ ∀ t', G.P.step s' a t' → ¬ R t t' :=
  match moves with
  | ⟨_, allMoves⟩ =>
    match Decided.exists_not_of_listed allMoves (fun a => match listed.outcomes s a with
        | ⟨_, outcome⟩ =>
          match Decided.forall_in fun t _ => listed'.matched_decided decided s' a t with
          | .inl all => .inl fun t step => all t ((outcome t).mp step)
          | .inr fails => .inr fun all => fails fun t mem => all t ((outcome t).mpr mem))
        fails with
    | ⟨a, failsAt⟩ => match listed.outcomes s a with
      | ⟨_, outcome⟩ =>
        match Decided.exists_not_in (fun t _ => listed'.matched_decided decided s' a t)
            fun all => failsAt fun t step => all t ((outcome t).mp step) with
        | ⟨t, mem, unmet⟩ =>
          ⟨a, t, (outcome t).mpr mem, fun t' step' related => unmet ⟨t', step', related⟩⟩

/-- **Alike to every depth is decided** where the moves and claims are listed and each move's
outcomes are listed in both frames. -/
theorem OutcomesListed.alikeTo_decided (moves : ∃ l : List A, ∀ a, a ∈ l)
    (claims : ∃ l : List C, ∀ c, c ∈ l) (listed : OutcomesListed F) (listed' : OutcomesListed G) :
    ∀ k s s', Decided (AlikeTo F G k s s')
  | 0, s, s' => listed.sameClaims_decided claims listed' s s'
  | k + 1, s, s' =>
    (listed.sameClaims_decided claims listed' s s').and
      ((OutcomesListed.forth_decided moves listed listed'
          (OutcomesListed.alikeTo_decided moves claims listed listed' k) s s').and
        (OutcomesListed.forth_decided (R := fun t' t => AlikeTo F G k t t') moves listed' listed
          (fun t' t => OutcomesListed.alikeTo_decided moves claims listed listed' k t t') s' s))

/-- One branching test holding at `x` and failing at every member of a list, where for each
member some test holds at `x` and fails there. -/
theorem BranchingTest.apart_from_list {S : Type u} {S' : Type u'} (F : Frame S A C)
    (G : Frame S' A C) {x : S}
    : ∀ l : List S', (∀ y, y ∈ l → ∃ φ, BranchingTest.Holds F x φ ∧ ¬ BranchingTest.Holds G y φ) →
      ∃ φ, BranchingTest.Holds F x φ ∧ ∀ y, y ∈ l → ¬ BranchingTest.Holds G y φ
  | [], _ => ⟨.top, True.intro, fun _ mem => nomatch mem⟩
  | y :: l, apart =>
    match BranchingTest.apart_from_list F G l (fun z mem => apart z (.tail y mem)),
        apart y (.head l) with
    | ⟨ψ, holds, fails⟩, ⟨χ, holds', fails'⟩ =>
      ⟨.both χ ψ, ⟨holds', holds⟩, fun z mem both =>
        match mem_cons_cases mem with
        | .inl same => fails' (Eq.subst (motive := fun w => BranchingTest.Holds G w χ) same
            (show BranchingTest.Holds G z χ ∧ BranchingTest.Holds G z ψ from both).1)
        | .inr mem => fails z mem
            (show BranchingTest.Holds G z χ ∧ BranchingTest.Holds G z ψ from both).2⟩

/-- Where configurations differ in a claim, a claim or its failure tells them apart. -/
theorem OutcomesListed.apart_of_claims (claims : ∃ l : List C, ∀ c, c ∈ l)
    (listed : OutcomesListed F) (listed' : OutcomesListed G) {s : S} {s' : S'}
    (differ : ¬ ∀ c, F.realized s c ↔ G.realized s' c) :
    ∃ φ, BranchingTest.Holds F s φ ∧ ¬ BranchingTest.Holds G s' φ :=
  match claims with
  | ⟨_, allClaims⟩ =>
    match Decided.exists_not_of_listed allClaims
        (fun c => (listed.realized s c).iff (listed'.realized s' c)) differ with
    | ⟨c, not_same⟩ => match listed.realized s c with
      | .inl real => ⟨.claim c, real, fun real' => not_same ⟨fun _ => real', fun _ => real⟩⟩
      | .inr unreal => ⟨.not (.claim c), unreal, fun unreal' =>
          not_same ⟨fun real => absurd real unreal, fun real' => absurd real' unreal'⟩⟩

/-- **Where configurations are not alike to depth `k`, a branching test holds at one and fails at
the other**, on frames whose moves have listed outcomes: `apart_of_not_alikeTo` with the outcomes
listed in place of the configurations. -/
theorem OutcomesListed.apart_of_not_alikeTo (moves : ∃ l : List A, ∀ a, a ∈ l)
    (claims : ∃ l : List C, ∀ c, c ∈ l) (listed : OutcomesListed F) (listed' : OutcomesListed G) :
    ∀ (k : Nat) {s : S} {s' : S'}, ¬ AlikeTo F G k s s' →
      ∃ φ, BranchingTest.Holds F s φ ∧ ¬ BranchingTest.Holds G s' φ
  | 0, _, _, fails => listed.apart_of_claims claims listed' fails
  | k + 1, s, s', fails =>
    have below := OutcomesListed.alikeTo_decided moves claims listed listed' k
    match listed.sameClaims_decided claims listed' s s' with
    | .inr differ => listed.apart_of_claims claims listed' differ
    | .inl same =>
      match OutcomesListed.forth_decided moves listed listed' below s s' with
      | .inr unmatched =>
        match OutcomesListed.unmatched moves listed listed' below unmatched with
        | ⟨a, t, step, unmet⟩ => match listed'.outcomes s' a with
          | ⟨l', outcome'⟩ =>
            match BranchingTest.apart_from_list F G (x := t) l' fun t' mem =>
                OutcomesListed.apart_of_not_alikeTo moves claims listed listed' k
                  (unmet t' ((outcome' t').mpr mem)) with
            | ⟨φ, holds, fails'⟩ =>
              ⟨.can a φ, ⟨t, step, holds⟩, fun ⟨t', step', holds'⟩ =>
                fails' t' ((outcome' t').mp step') holds'⟩
      | .inl forth =>
        match OutcomesListed.forth_decided (R := fun t' t => AlikeTo F G k t t') moves listed'
            listed (fun t' t => below t t') s' s with
        | .inl back => absurd ⟨same, forth, back⟩ fails
        | .inr unmatched =>
          match OutcomesListed.unmatched (R := fun t' t => AlikeTo F G k t t') moves listed' listed
              (fun t' t => below t t') unmatched with
          | ⟨a, t', step', unmet⟩ => match listed.outcomes s a with
            | ⟨l, outcome⟩ =>
              match BranchingTest.apart_from_list G F (x := t') l fun t mem =>
                  match OutcomesListed.apart_of_not_alikeTo moves claims listed listed' k
                      (unmet t ((outcome t).mpr mem)) with
                  | ⟨φ, holds, fails'⟩ => ⟨.not φ, fails', fun refuted => refuted holds⟩ with
              | ⟨φ, holds, fails'⟩ =>
                ⟨.not (.can a φ), fun ⟨t, step, holds'⟩ => fails' t ((outcome t).mp step) holds',
                 fun refuted => refuted ⟨t', step', holds⟩⟩

/-- Configurations passing the same branching tests are alike to every depth, where each move's
outcomes are listed. -/
theorem OutcomesListed.alikeTo_of_same (moves : ∃ l : List A, ∀ a, a ∈ l)
    (claims : ∃ l : List C, ∀ c, c ∈ l) (listed : OutcomesListed F) (listed' : OutcomesListed G)
    {s : S} {s' : S'} (same : SameBranchingTests F G s s') (k : Nat) : AlikeTo F G k s s' :=
  (OutcomesListed.alikeTo_decided moves claims listed listed' k s s').of_not_not fun fails =>
    match OutcomesListed.apart_of_not_alikeTo moves claims listed listed' k fails with
    | ⟨φ, holds, fails'⟩ => fails' ((same φ).mp holds)

/-- **Alike to every depth is a bisimulation where each move's outcomes are listed, given
`EitherThroughout`**: among the listed outcomes matching a step to each depth, one matches it to
every depth. -/
theorem OutcomesListed.alikeTo_bisimulation (either : EitherThroughout)
    (moves : ∃ l : List A, ∀ a, a ∈ l) (claims : ∃ l : List C, ∀ c, c ∈ l)
    (listed : OutcomesListed F) (listed' : OutcomesListed G) :
    Bisimulation F G (fun s s' => ∀ k, AlikeTo F G k s s') :=
  fun s s' alike =>
    ⟨(alike 0),
     fun a t step => match listed'.outcomes s' a with
      | ⟨l', outcome'⟩ =>
        match either.list (P := fun k t' => AlikeTo F G k t t')
            (fun k t' => OutcomesListed.alikeTo_decided moves claims listed listed' k t t')
            (fun _ _ joined => AlikeTo.of_succ joined) l'
            (fun k => match (alike (k + 1)).2.1 a t step with
              | ⟨t', step', joined⟩ => ⟨t', (outcome' t').mp step', joined⟩) with
        | ⟨t', mem, joined⟩ => ⟨t', (outcome' t').mpr mem, joined⟩,
     fun a t' step' => match listed.outcomes s a with
      | ⟨l, outcome⟩ =>
        match either.list (P := fun k t => AlikeTo F G k t t')
            (fun k t => OutcomesListed.alikeTo_decided moves claims listed listed' k t t')
            (fun _ _ joined => AlikeTo.of_succ joined) l
            (fun k => match (alike (k + 1)).2.2 a t' step' with
              | ⟨t, step, joined⟩ => ⟨t, (outcome t).mp step, joined⟩) with
        | ⟨t, mem, joined⟩ => ⟨t, (outcome t).mpr mem, joined⟩⟩

/-- **Branching tests fix likeness where each move's outcomes are listed, given
`EitherThroughout`.** Where the moves and claims are listed, the claims are decided and each move
of each configuration has a listed set of outcomes, configurations are alike exactly where they
pass the same branching tests; the configurations may be infinitely many. -/
theorem OutcomesListed.alike_iff_sameBranchingTests (either : EitherThroughout)
    (moves : ∃ l : List A, ∀ a, a ∈ l) (claims : ∃ l : List C, ∀ c, c ∈ l)
    (listed : OutcomesListed F) (listed' : OutcomesListed G) {s : S} {s' : S'} :
    Alike F G s s' ↔ SameBranchingTests F G s s' :=
  ⟨Alike.sameBranchingTests, fun same =>
    ⟨_, OutcomesListed.alikeTo_bisimulation either moves claims listed listed',
     OutcomesListed.alikeTo_of_same moves claims listed listed' same⟩⟩

/-! ### Under excluded middle -/

/-- Under excluded middle, configurations not passing the same branching tests are told apart by
one: it holds at the first and fails at the second. -/
theorem apart_of_not_sameBranchingTests (em : ∀ p : Prop, Decided p) {s : S} {s' : S'}
    (differ : ¬ SameBranchingTests F G s s') :
    ∃ φ, BranchingTest.Holds F s φ ∧ ¬ BranchingTest.Holds G s' φ :=
  match em (∃ φ, BranchingTest.Holds F s φ ∧ ¬ BranchingTest.Holds G s' φ) with
  | .inl apart => apart
  | .inr absent => match em (∃ φ, BranchingTest.Holds G s' φ ∧ ¬ BranchingTest.Holds F s φ) with
    | .inl ⟨φ, holds', fails⟩ => ⟨.not φ, fails, fun refuted => refuted holds'⟩
    | .inr absent' => absurd (fun φ =>
        ⟨fun holds => Decided.of_not_not (em _) fun fails => absent ⟨φ, holds, fails⟩,
         fun holds' => Decided.of_not_not (em _) fun fails => absent' ⟨φ, holds', fails⟩⟩) differ

/-- **Under excluded middle, branching tests fix likeness where each move's outcomes are listed**,
with neither the moves nor the claims listed. Passing the same tests is a bisimulation: among the
listed outcomes of the other configuration by the move, one passes the tests the step's outcome
passes, or one test, telling the outcome apart from each of them, tells the two configurations
apart after the move. -/
theorem alike_of_sameBranchingTests_of_em (em : ∀ p : Prop, Decided p)
    (outcomes : ∀ s a, ∃ l : List S, ∀ t, F.P.step s a t ↔ t ∈ l)
    (outcomes' : ∀ s a, ∃ l : List S', ∀ t, G.P.step s a t ↔ t ∈ l) {s : S} {s' : S'}
    (same : SameBranchingTests F G s s') : Alike F G s s' :=
  ⟨SameBranchingTests F G, fun s s' same =>
    ⟨fun c => same (.claim c),
     fun a t step => match outcomes' s' a with
      | ⟨l', outcome'⟩ => match em (∃ t', t' ∈ l' ∧ SameBranchingTests F G t t') with
        | .inl ⟨t', mem, joined⟩ => ⟨t', (outcome' t').mpr mem, joined⟩
        | .inr absent =>
          match BranchingTest.apart_from_list F G (x := t) l' fun t' mem =>
              apart_of_not_sameBranchingTests em fun joined => absent ⟨t', mem, joined⟩ with
          | ⟨φ, holds, fails⟩ => absurd ((same (.can a φ)).mp ⟨t, step, holds⟩)
              fun ⟨t', step', holds'⟩ => fails t' ((outcome' t').mp step') holds',
     fun a t' step' => match outcomes s a with
      | ⟨l, outcome⟩ => match em (∃ t, t ∈ l ∧ SameBranchingTests F G t t') with
        | .inl ⟨t, mem, joined⟩ => ⟨t, (outcome t).mpr mem, joined⟩
        | .inr absent =>
          match BranchingTest.apart_from_list G F (x := t') l fun t mem =>
              match apart_of_not_sameBranchingTests em fun joined => absent ⟨t, mem, joined⟩ with
              | ⟨φ, holds, fails⟩ => ⟨.not φ, fails, fun refuted => refuted holds⟩ with
          | ⟨φ, holds, fails⟩ => absurd ((same (.can a φ)).mpr ⟨t', step', holds⟩)
              fun ⟨t, step, holds⟩ => fails t ((outcome t).mp step) holds⟩,
   same⟩

/-- Under excluded middle, configurations are alike exactly where they pass the same branching
tests, where each move's outcomes are listed. -/
theorem alike_iff_sameBranchingTests_of_em (em : ∀ p : Prop, Decided p)
    (outcomes : ∀ s a, ∃ l : List S, ∀ t, F.P.step s a t ↔ t ∈ l)
    (outcomes' : ∀ s a, ∃ l : List S', ∀ t, G.P.step s a t ↔ t ∈ l) {s : S} {s' : S'} :
    Alike F G s s' ↔ SameBranchingTests F G s s' :=
  ⟨Alike.sameBranchingTests, alike_of_sameBranchingTests_of_em em outcomes outcomes'⟩

end Outcomes

/-! ## Where the decisions or the finiteness are dropped -/

namespace EitherStep

/-- Configurations: `three` steps to `goes`, `halts` and `either`; `two` steps to `goes` and
`halts`; `goes` steps to `after`; `either` steps to `after` exactly where `p` holds. -/
inductive Pos where
  | three
  | two
  | goes
  | halts
  | either
  | after

/-- The steps of the one move. -/
inductive Step (p : Prop) : Pos → Pos → Prop where
  | threeGoes : Step p .three .goes
  | threeHalts : Step p .three .halts
  | threeEither : Step p .three .either
  | twoGoes : Step p .two .goes
  | twoHalts : Step p .two .halts
  | goesAfter : Step p .goes .after
  | eitherAfter : p → Step p .either .after

/-- The frame of `p`, with no claims. -/
def frame (p : Prop) : Frame Pos Unit Empty :=
  ⟨⟨fun s _ t => Step p s t⟩, fun _ c => nomatch c⟩

/-- A list holds every configuration. -/
theorem listed : ∀ s : Pos, s ∈ [Pos.three, .two, .goes, .halts, .either, .after]
  | .three => .head _
  | .two => .tail _ (.head _)
  | .goes => .tail _ (.tail _ (.head _))
  | .halts => .tail _ (.tail _ (.tail _ (.head _)))
  | .either => .tail _ (.tail _ (.tail _ (.tail _ (.head _))))
  | .after => .tail _ (.tail _ (.tail _ (.tail _ (.tail _ (.head _)))))

variable {p : Prop}

/-- At `goes`, `halts` and `after`, whether a branching test holds is decided. -/
theorem settled_decided : ∀ φ : BranchingTest Unit Empty,
    Decided (BranchingTest.Holds (frame p) .goes φ) ∧
      Decided (BranchingTest.Holds (frame p) .halts φ) ∧
        Decided (BranchingTest.Holds (frame p) .after φ)
  | .top => ⟨.inl True.intro, .inl True.intro, .inl True.intro⟩
  | .claim c => nomatch c
  | .not φ => match settled_decided φ with
    | ⟨goes, halts, after⟩ => ⟨goes.not, halts.not, after.not⟩
  | .both φ ψ => match settled_decided φ, settled_decided ψ with
    | ⟨goes, halts, after⟩, ⟨goes', halts', after'⟩ =>
      ⟨goes.and goes', halts.and halts', after.and after'⟩
  | .can _ φ =>
    ⟨(match (settled_decided φ).2.2 with
      | .inl holds => .inl ⟨.after, .goesAfter, holds⟩
      | .inr fails => .inr fun ⟨_, step, holds⟩ => match step with
        | .goesAfter => fails holds),
     .inr (fun ⟨_, step, _⟩ => nomatch step),
     .inr (fun ⟨_, step, _⟩ => nomatch step)⟩

/-- Where `p` holds, `either` passes the tests `goes` passes. -/
theorem either_holds_of (holds : p) : ∀ φ : BranchingTest Unit Empty,
    BranchingTest.Holds (frame p) .either φ ↔ BranchingTest.Holds (frame p) .goes φ
  | .top => Iff.rfl
  | .claim c => nomatch c
  | .not φ => ⟨fun fails passes => fails ((either_holds_of holds φ).mpr passes),
      fun fails passes => fails ((either_holds_of holds φ).mp passes)⟩
  | .both φ ψ => ⟨fun ⟨first, second⟩ =>
        ⟨(either_holds_of holds φ).mp first, (either_holds_of holds ψ).mp second⟩,
      fun ⟨first, second⟩ =>
        ⟨(either_holds_of holds φ).mpr first, (either_holds_of holds ψ).mpr second⟩⟩
  | .can _ _ => ⟨fun ⟨_, step, passes⟩ => match step with
        | .eitherAfter _ => ⟨.after, .goesAfter, passes⟩,
      fun ⟨_, step, passes⟩ => match step with
        | .goesAfter => ⟨.after, .eitherAfter holds, passes⟩⟩

/-- Where `p` fails, `either` passes the tests `halts` passes. -/
theorem either_holds_of_not (fails : ¬ p) : ∀ φ : BranchingTest Unit Empty,
    BranchingTest.Holds (frame p) .either φ ↔ BranchingTest.Holds (frame p) .halts φ
  | .top => Iff.rfl
  | .claim c => nomatch c
  | .not φ => ⟨fun fails' passes => fails' ((either_holds_of_not fails φ).mpr passes),
      fun fails' passes => fails' ((either_holds_of_not fails φ).mp passes)⟩
  | .both φ ψ => ⟨fun ⟨first, second⟩ =>
        ⟨(either_holds_of_not fails φ).mp first, (either_holds_of_not fails ψ).mp second⟩,
      fun ⟨first, second⟩ =>
        ⟨(either_holds_of_not fails φ).mpr first, (either_holds_of_not fails ψ).mpr second⟩⟩
  | .can _ _ => ⟨fun ⟨_, step, _⟩ => match step with
        | .eitherAfter holds => absurd holds fails,
      (fun ⟨_, step, _⟩ => nomatch step)⟩

/-- What `either` passes, `goes` or `halts` passes: not deciding `p`, but because `p` is not
refuted to be decided and each test is decided at `goes` and at `halts`. -/
theorem either_settles (φ : BranchingTest Unit Empty)
    (passes : BranchingTest.Holds (frame p) .either φ) :
    BranchingTest.Holds (frame p) .goes φ ∨ BranchingTest.Holds (frame p) .halts φ :=
  match (settled_decided (p := p) φ).1, (settled_decided (p := p) φ).2.1 with
  | .inl goes, _ => .inl goes
  | _, .inl halts => .inr halts
  | .inr not_goes, .inr not_halts =>
    False.elim (not_not_decided p fun settled => match settled with
        | .inl holds => not_goes ((either_holds_of holds φ).mp passes)
        | .inr fails => not_halts ((either_holds_of_not fails φ).mp passes))

/-- **`three` and `two` pass the same branching tests**, whatever `p` is. -/
theorem sameBranchingTests : SameBranchingTests (frame p) (frame p) .three .two
  | .top => Iff.rfl
  | .claim c => nomatch c
  | .not φ => ⟨fun fails passes => fails ((sameBranchingTests φ).mpr passes),
      fun fails passes => fails ((sameBranchingTests φ).mp passes)⟩
  | .both φ ψ => ⟨fun ⟨first, second⟩ =>
        ⟨(sameBranchingTests φ).mp first, (sameBranchingTests ψ).mp second⟩,
      fun ⟨first, second⟩ =>
        ⟨(sameBranchingTests φ).mpr first, (sameBranchingTests ψ).mpr second⟩⟩
  | .can _ φ => ⟨fun ⟨_, step, passes⟩ => match step with
        | .threeGoes => ⟨.goes, .twoGoes, passes⟩
        | .threeHalts => ⟨.halts, .twoHalts, passes⟩
        | .threeEither => match either_settles φ passes with
          | .inl goes => ⟨.goes, .twoGoes, goes⟩
          | .inr halts => ⟨.halts, .twoHalts, halts⟩,
      fun ⟨_, step, passes⟩ => match step with
        | .twoGoes => ⟨.goes, .threeGoes, passes⟩
        | .twoHalts => ⟨.halts, .threeHalts, passes⟩⟩

/-- **Where `three` and `two` are alike, `p` is decided**: the step from `three` to `either` is
met from `two` at `goes`, where `p` holds, or at `halts`, where it fails. -/
theorem decided_of_alike (alike : Alike (frame p) (frame p) .three .two) : Decided p :=
  match alike.step (a := ()) (t := .either) .threeEither with
  | ⟨_, .twoGoes, joined⟩ =>
    .inl (match joined.symm.step (a := ()) (t := .after) .goesAfter with
      | ⟨_, .eitherAfter holds, _⟩ => holds)
  | ⟨_, .twoHalts, joined⟩ =>
    .inr fun holds => match joined.step (a := ()) (t := .after) (.eitherAfter holds) with
      | ⟨_, step, _⟩ => nomatch step

end EitherStep

namespace EitherClaim

/-- Configurations: `three` steps to `marked`, `unmarked` and `either`; `two` steps to `marked`
and `unmarked`. -/
inductive Pos where
  | three
  | two
  | marked
  | unmarked
  | either

/-- The steps of the one move. -/
inductive Step : Pos → Pos → Prop where
  | threeMarked : Step .three .marked
  | threeUnmarked : Step .three .unmarked
  | threeEither : Step .three .either
  | twoMarked : Step .two .marked
  | twoUnmarked : Step .two .unmarked

/-- Where the one claim is realized: always at `marked`, exactly where `p` holds at `either`. -/
def Marked (p : Prop) : Pos → Prop
  | .three => False
  | .two => False
  | .marked => True
  | .unmarked => False
  | .either => p

/-- The frame of `p`, with one claim. -/
def frame (p : Prop) : Frame Pos Unit Unit :=
  ⟨⟨fun s _ t => Step s t⟩, fun s _ => Marked p s⟩

/-- A list holds every configuration. -/
theorem listed : ∀ s : Pos, s ∈ [Pos.three, .two, .marked, .unmarked, .either]
  | .three => .head _
  | .two => .tail _ (.head _)
  | .marked => .tail _ (.tail _ (.head _))
  | .unmarked => .tail _ (.tail _ (.tail _ (.head _)))
  | .either => .tail _ (.tail _ (.tail _ (.tail _ (.head _))))

/-- Whether one configuration steps to another is decided. -/
theorem step_decided : ∀ s t : Pos, Decided (Step s t)
  | .three, .marked => .inl .threeMarked
  | .three, .unmarked => .inl .threeUnmarked
  | .three, .either => .inl .threeEither
  | .two, .marked => .inl .twoMarked
  | .two, .unmarked => .inl .twoUnmarked
  | .three, .three => .inr fun step => nomatch step
  | .three, .two => .inr fun step => nomatch step
  | .two, .three => .inr fun step => nomatch step
  | .two, .two => .inr fun step => nomatch step
  | .two, .either => .inr fun step => nomatch step
  | .marked, _ => .inr fun step => nomatch step
  | .unmarked, _ => .inr fun step => nomatch step
  | .either, _ => .inr fun step => nomatch step

variable {p : Prop}

/-- At `marked` and `unmarked`, whether a branching test holds is decided. -/
theorem settled_decided : ∀ φ : BranchingTest Unit Unit,
    Decided (BranchingTest.Holds (frame p) .marked φ) ∧
      Decided (BranchingTest.Holds (frame p) .unmarked φ)
  | .top => ⟨.inl True.intro, .inl True.intro⟩
  | .claim _ => ⟨.inl True.intro, .inr id⟩
  | .not φ => match settled_decided φ with
    | ⟨marked, unmarked⟩ => ⟨marked.not, unmarked.not⟩
  | .both φ ψ => match settled_decided φ, settled_decided ψ with
    | ⟨marked, unmarked⟩, ⟨marked', unmarked'⟩ => ⟨marked.and marked', unmarked.and unmarked'⟩
  | .can _ _ => ⟨.inr (fun ⟨_, step, _⟩ => nomatch step), .inr (fun ⟨_, step, _⟩ => nomatch step)⟩

/-- Where `p` holds, `either` passes the tests `marked` passes. -/
theorem either_holds_of (holds : p) : ∀ φ : BranchingTest Unit Unit,
    BranchingTest.Holds (frame p) .either φ ↔ BranchingTest.Holds (frame p) .marked φ
  | .top => Iff.rfl
  | .claim _ => ⟨fun _ => True.intro, fun _ => holds⟩
  | .not φ => ⟨fun fails passes => fails ((either_holds_of holds φ).mpr passes),
      fun fails passes => fails ((either_holds_of holds φ).mp passes)⟩
  | .both φ ψ => ⟨fun ⟨first, second⟩ =>
        ⟨(either_holds_of holds φ).mp first, (either_holds_of holds ψ).mp second⟩,
      fun ⟨first, second⟩ =>
        ⟨(either_holds_of holds φ).mpr first, (either_holds_of holds ψ).mpr second⟩⟩
  | .can _ _ => ⟨(fun ⟨_, step, _⟩ => nomatch step), (fun ⟨_, step, _⟩ => nomatch step)⟩

/-- Where `p` fails, `either` passes the tests `unmarked` passes. -/
theorem either_holds_of_not (fails : ¬ p) : ∀ φ : BranchingTest Unit Unit,
    BranchingTest.Holds (frame p) .either φ ↔ BranchingTest.Holds (frame p) .unmarked φ
  | .top => Iff.rfl
  | .claim _ => ⟨fun holds => fails holds, fun absent => nomatch absent⟩
  | .not φ => ⟨fun fails' passes => fails' ((either_holds_of_not fails φ).mpr passes),
      fun fails' passes => fails' ((either_holds_of_not fails φ).mp passes)⟩
  | .both φ ψ => ⟨fun ⟨first, second⟩ =>
        ⟨(either_holds_of_not fails φ).mp first, (either_holds_of_not fails ψ).mp second⟩,
      fun ⟨first, second⟩ =>
        ⟨(either_holds_of_not fails φ).mpr first, (either_holds_of_not fails ψ).mpr second⟩⟩
  | .can _ _ => ⟨(fun ⟨_, step, _⟩ => nomatch step), (fun ⟨_, step, _⟩ => nomatch step)⟩

/-- What `either` passes, `marked` or `unmarked` passes. -/
theorem either_settles (φ : BranchingTest Unit Unit)
    (passes : BranchingTest.Holds (frame p) .either φ) :
    BranchingTest.Holds (frame p) .marked φ ∨ BranchingTest.Holds (frame p) .unmarked φ :=
  match (settled_decided (p := p) φ).1, (settled_decided (p := p) φ).2 with
  | .inl marked, _ => .inl marked
  | _, .inl unmarked => .inr unmarked
  | .inr not_marked, .inr not_unmarked =>
    False.elim (not_not_decided p fun settled => match settled with
        | .inl holds => not_marked ((either_holds_of holds φ).mp passes)
        | .inr fails => not_unmarked ((either_holds_of_not fails φ).mp passes))

/-- **`three` and `two` pass the same branching tests**, whatever `p` is. -/
theorem sameBranchingTests : SameBranchingTests (frame p) (frame p) .three .two
  | .top => Iff.rfl
  | .claim _ => Iff.rfl
  | .not φ => ⟨fun fails passes => fails ((sameBranchingTests φ).mpr passes),
      fun fails passes => fails ((sameBranchingTests φ).mp passes)⟩
  | .both φ ψ => ⟨fun ⟨first, second⟩ =>
        ⟨(sameBranchingTests φ).mp first, (sameBranchingTests ψ).mp second⟩,
      fun ⟨first, second⟩ =>
        ⟨(sameBranchingTests φ).mpr first, (sameBranchingTests ψ).mpr second⟩⟩
  | .can _ φ => ⟨fun ⟨_, step, passes⟩ => match step with
        | .threeMarked => ⟨.marked, .twoMarked, passes⟩
        | .threeUnmarked => ⟨.unmarked, .twoUnmarked, passes⟩
        | .threeEither => match either_settles φ passes with
          | .inl marked => ⟨.marked, .twoMarked, marked⟩
          | .inr unmarked => ⟨.unmarked, .twoUnmarked, unmarked⟩,
      fun ⟨_, step, passes⟩ => match step with
        | .twoMarked => ⟨.marked, .threeMarked, passes⟩
        | .twoUnmarked => ⟨.unmarked, .threeUnmarked, passes⟩⟩

/-- **Where `three` and `two` are alike, `p` is decided**: the step from `three` to `either` is
met from `two` at `marked`, where the claim is realized, or at `unmarked`, where it is not. -/
theorem decided_of_alike (alike : Alike (frame p) (frame p) .three .two) : Decided p :=
  match alike.step (a := ()) (t := .either) .threeEither with
  | ⟨_, .twoMarked, joined⟩ => .inl ((joined.realized ()).mpr True.intro)
  | ⟨_, .twoUnmarked, joined⟩ => .inr fun holds => (joined.realized ()).mp holds

end EitherClaim

/-- **Without decided steps, branching tests fix likeness of finite frames exactly under excluded
middle.** That configurations passing the same branching tests are alike, for every frame on a
listed type of configurations with one move and no claims, holds exactly where every proposition
is decided: the decided steps of `FiniteDecided` cannot be dropped from
`alike_iff_sameBranchingTests`. -/
theorem alike_of_sameBranchingTests_iff_em :
    (∀ (S : Type) (F G : Frame S Unit Empty) (s s' : S), (∃ l : List S, ∀ x, x ∈ l) →
        SameBranchingTests F G s s' → Alike F G s s') ↔ ∀ p : Prop, Decided p :=
  ⟨fun fixes p => EitherStep.decided_of_alike (fixes _ (EitherStep.frame p) (EitherStep.frame p)
      .three .two ⟨_, EitherStep.listed⟩ EitherStep.sameBranchingTests),
   fun em _ _ _ _ _ listed same =>
    (alike_iff_sameBranchingTests ⟨[()], fun _ => .head _⟩ ⟨[], fun c => nomatch c⟩
      ⟨listed, fun _ _ _ => em _, fun _ _ => em _⟩ ⟨listed, fun _ _ _ => em _, fun _ _ => em _⟩).mpr
      same⟩

/-- **Without decided claims, branching tests fix likeness of finite frames with decided steps
exactly under excluded middle**: the decided claims of `FiniteDecided` cannot be dropped either. -/
theorem alike_of_sameBranchingTests_decided_steps_iff_em :
    (∀ (S : Type) (F G : Frame S Unit Unit) (s s' : S), (∃ l : List S, ∀ x, x ∈ l) →
        (∀ x a y, Decided (F.P.step x a y)) → (∀ x a y, Decided (G.P.step x a y)) →
        SameBranchingTests F G s s' → Alike F G s s') ↔ ∀ p : Prop, Decided p :=
  ⟨fun fixes p => EitherClaim.decided_of_alike (fixes _ (EitherClaim.frame p) (EitherClaim.frame p)
      .three .two ⟨_, EitherClaim.listed⟩ (fun x _ y => EitherClaim.step_decided x y)
      (fun x _ y => EitherClaim.step_decided x y) EitherClaim.sameBranchingTests),
   fun em _ _ _ _ _ listed _ _ same =>
    (alike_iff_sameBranchingTests ⟨[()], fun _ => .head _⟩ ⟨[()], fun _ => .head _⟩
      ⟨listed, fun _ _ _ => em _, fun _ _ => em _⟩ ⟨listed, fun _ _ _ => em _, fun _ _ => em _⟩).mpr
      same⟩

namespace Chains

/-- Configurations: `three` steps to the starts of the two chains `on true` and `on false` and
of the endless chain; `two` steps to the starts of the two chains. -/
inductive Pos where
  | three
  | two
  | on (b : Bool) (n : Nat)
  | endless (n : Nat)

/-- The family a chain goes on along: `α` for `on true`, `β` for `on false`. -/
def Side (α β : Nat → Prop) : Bool → Nat → Prop
  | true => α
  | false => β

/-- The steps of the one move: the chain `on b` goes on from `n` exactly where its family holds
at `n`; the endless chain always goes on. -/
inductive Step (α β : Nat → Prop) : Pos → Pos → Prop where
  | threeOn (b : Bool) : Step α β .three (.on b 0)
  | threeEndless : Step α β .three (.endless 0)
  | twoOn (b : Bool) : Step α β .two (.on b 0)
  | onward (b : Bool) (n : Nat) : Side α β b n → Step α β (.on b n) (.on b (n + 1))
  | endlessOnward (n : Nat) : Step α β (.endless n) (.endless (n + 1))

/-- The frame of `α` and `β`, with no claims. -/
def frame (α β : Nat → Prop) : Frame Pos Unit Empty :=
  ⟨⟨fun s _ t => Step α β s t⟩, fun _ c => nomatch c⟩

/-- How deep a branching test looks: the most moves it follows in a row. -/
def depth {A : Type v} {C : Type w} : BranchingTest A C → Nat
  | .top => 0
  | .claim _ => 0
  | .not φ => depth φ
  | .both φ ψ => depth φ + depth ψ
  | .can _ φ => depth φ + 1

variable {α β : Nat → Prop}

/-- Where both families are decided, the outcomes of each configuration are listed. -/
theorem outcomes (decided : ∀ k, Decided (α k)) (decided' : ∀ k, Decided (β k)) :
    ∀ s : Pos, ∃ l : List Pos, ∀ t, Step α β s t ↔ t ∈ l
  | .three => ⟨[.on true 0, .on false 0, .endless 0], fun _ =>
      ⟨fun step => match step with
        | .threeOn true => .head _
        | .threeOn false => .tail _ (.head _)
        | .threeEndless => .tail _ (.tail _ (.head _)),
       fun mem => match mem_cons_cases mem with
        | .inl same => Eq.subst (motive := Step α β .three) same.symm (.threeOn true)
        | .inr mem => match mem_cons_cases mem with
          | .inl same => Eq.subst (motive := Step α β .three) same.symm (.threeOn false)
          | .inr mem => match mem_cons_cases mem with
            | .inl same => Eq.subst (motive := Step α β .three) same.symm .threeEndless
            | .inr mem => nomatch mem⟩⟩
  | .two => ⟨[.on true 0, .on false 0], fun _ =>
      ⟨fun step => match step with
        | .twoOn true => .head _
        | .twoOn false => .tail _ (.head _),
       fun mem => match mem_cons_cases mem with
        | .inl same => Eq.subst (motive := Step α β .two) same.symm (.twoOn true)
        | .inr mem => match mem_cons_cases mem with
          | .inl same => Eq.subst (motive := Step α β .two) same.symm (.twoOn false)
          | .inr mem => nomatch mem⟩⟩
  | .on b n =>
    match (show Decided (Side α β b n) from match b with
        | true => decided n
        | false => decided' n) with
    | .inl goes => ⟨[.on b (n + 1)], fun _ =>
        ⟨fun step => match step with
          | .onward _ _ _ => .head _,
         fun mem => match mem_cons_cases mem with
          | .inl same => Eq.subst (motive := Step α β (.on b n)) same.symm (.onward b n goes)
          | .inr mem => nomatch mem⟩⟩
    | .inr stops => ⟨[], fun _ =>
        ⟨fun step => match step with
          | .onward _ _ goes => absurd goes stops,
         fun mem => nomatch mem⟩⟩
  | .endless n => ⟨[.endless (n + 1)], fun _ =>
      ⟨fun step => match step with
        | .endlessOnward _ => .head _,
       fun mem => match mem_cons_cases mem with
        | .inl same => Eq.subst (motive := Step α β (.endless n)) same.symm (.endlessOnward n)
        | .inr mem => nomatch mem⟩⟩

/-- Where both families are decided, each move has listed outcomes. -/
theorem outcomesListed (decided : ∀ k, Decided (α k)) (decided' : ∀ k, Decided (β k)) :
    OutcomesListed (frame α β) :=
  ⟨fun s _ => outcomes decided decided' s, fun _ c => nomatch c⟩

/-- Where its family holds as deep as a test looks, a chain passes the test exactly where the
endless chain does. -/
theorem on_holds_iff (down : ∀ k, α (k + 1) → α k) (down' : ∀ k, β (k + 1) → β k) (b : Bool) :
    ∀ (φ : BranchingTest Unit Empty) (n : Nat), Side α β b (n + depth φ) →
      (BranchingTest.Holds (frame α β) (.on b n) φ ↔ BranchingTest.Holds (frame α β) (.endless n) φ)
  | .top, _, _ => Iff.rfl
  | .claim c, _, _ => nomatch c
  | .not φ, n, deep => match on_holds_iff down down' b φ n deep with
    | same => ⟨fun fails passes => fails (same.mpr passes),
        fun fails passes => fails (same.mp passes)⟩
  | .both φ ψ, n, deep =>
    have below : ∀ {m}, m ≤ n + (depth φ + depth ψ) → Side α β b m := fun le =>
      holds_below (P := fun k (_ : Unit) => Side α β b k) (x := ())
        (fun k _ holds => match b with
          | true => down k holds
          | false => down' k holds) le deep
    match on_holds_iff down down' b φ n (below (Nat.add_le_add_left (Nat.le_add_right _ _) n)),
        on_holds_iff down down' b ψ n (below (Nat.add_le_add_left (Nat.le_add_left _ _) n)) with
    | first, second => ⟨fun ⟨holds, holds'⟩ => ⟨first.mp holds, second.mp holds'⟩,
        fun ⟨holds, holds'⟩ => ⟨first.mpr holds, second.mpr holds'⟩⟩
  | .can _ φ, n, deep =>
    have next : Side α β b (n + 1 + depth φ) :=
      Eq.subst (motive := Side α β b) (Nat.succ_add n (depth φ)).symm deep
    have here : Side α β b n :=
      holds_below (P := fun k (_ : Unit) => Side α β b k) (x := ())
        (fun k _ holds => match b with
          | true => down k holds
          | false => down' k holds) (Nat.le_add_right n (depth φ + 1)) deep
    match on_holds_iff down down' b φ (n + 1) next with
    | same => ⟨fun ⟨_, step, holds⟩ => match step with
        | .onward _ _ _ => ⟨.endless (n + 1), .endlessOnward n, same.mp holds⟩,
      fun ⟨_, step, holds⟩ => match step with
        | .endlessOnward _ => ⟨.on b (n + 1), .onward b n here, same.mpr holds⟩⟩

/-- **`three` and `two` pass the same branching tests** where the families are decided and
decreasing and one of them holds at each step: what the endless chain passes, one of the two
chains passes, since one of them goes on as deep as the test looks. -/
theorem sameBranchingTests (down : ∀ k, α (k + 1) → α k) (down' : ∀ k, β (k + 1) → β k)
    (each : ∀ k, α k ∨ β k) : SameBranchingTests (frame α β) (frame α β) .three .two
  | .top => Iff.rfl
  | .claim c => nomatch c
  | .not φ => ⟨fun fails passes => fails ((sameBranchingTests down down' each φ).mpr passes),
      fun fails passes => fails ((sameBranchingTests down down' each φ).mp passes)⟩
  | .both φ ψ => ⟨fun ⟨first, second⟩ =>
        ⟨(sameBranchingTests down down' each φ).mp first,
         (sameBranchingTests down down' each ψ).mp second⟩,
      fun ⟨first, second⟩ =>
        ⟨(sameBranchingTests down down' each φ).mpr first,
         (sameBranchingTests down down' each ψ).mpr second⟩⟩
  | .can _ φ => ⟨fun ⟨_, step, passes⟩ => match step with
        | .threeOn b => ⟨.on b 0, .twoOn b, passes⟩
        | .threeEndless => match each (0 + depth φ) with
          | .inl deep =>
            ⟨.on true 0, .twoOn true, (on_holds_iff down down' true φ 0 deep).mpr passes⟩
          | .inr deep =>
            ⟨.on false 0, .twoOn false, (on_holds_iff down down' false φ 0 deep).mpr passes⟩,
      fun ⟨_, step, passes⟩ => match step with
        | .twoOn b => ⟨.on b 0, .threeOn b, passes⟩⟩

/-- Where the endless chain is alike to a chain at some step, the chain's family holds there and
the two are alike at the next step. -/
theorem endless_alike_on {b : Bool} {n : Nat}
    (alike : Alike (frame α β) (frame α β) (.endless n) (.on b n)) :
    Side α β b n ∧ Alike (frame α β) (frame α β) (.endless (n + 1)) (.on b (n + 1)) :=
  match alike.step (a := ()) (t := .endless (n + 1)) (.endlessOnward n) with
  | ⟨_, .onward _ _ goes, joined⟩ => ⟨goes, joined⟩

/-- Where the endless chain is alike to a chain at its start, the chain's family holds at every
step. -/
theorem side_throughout {b : Bool} (alike : Alike (frame α β) (frame α β) (.endless 0) (.on b 0)) :
    ∀ n, Side α β b n ∧ Alike (frame α β) (frame α β) (.endless (n + 1)) (.on b (n + 1))
  | 0 => endless_alike_on alike
  | n + 1 => endless_alike_on (side_throughout alike n).2

/-- **Where `three` and `two` are alike, one family holds throughout**: the step from `three` to
the endless chain is met from `two` at the start of one of the two chains. -/
theorem throughout_of_alike (alike : Alike (frame α β) (frame α β) .three .two) :
    (∀ k, α k) ∨ (∀ k, β k) :=
  match alike.step (a := ()) (t := .endless 0) .threeEndless with
  | ⟨_, .twoOn true, joined⟩ => .inl fun k => (side_throughout (α := α) (β := β) joined k).1
  | ⟨_, .twoOn false, joined⟩ => .inr fun k => (side_throughout (α := α) (β := β) joined k).1

end Chains

namespace Unbounded

/-- Configurations: `bounded` steps to every `rest n`; `unbounded` steps to every `rest n` and to
`endless`; `rest (k + 1)` steps to `rest k`, and `rest 0` nowhere; `endless` steps to itself. -/
inductive Pos where
  | bounded
  | unbounded
  | rest (k : Nat)
  | endless

/-- The steps of the one move. -/
inductive Step : Pos → Pos → Prop where
  | boundedRest (n : Nat) : Step .bounded (.rest n)
  | unboundedRest (n : Nat) : Step .unbounded (.rest n)
  | unboundedEndless : Step .unbounded .endless
  | down (k j : Nat) : k = j + 1 → Step (.rest k) (.rest j)
  | endlessOnward : Step .endless .endless

/-- The frame, with no claims: the first move of `bounded` and of `unbounded` has infinitely many
outcomes. -/
def frame : Frame Pos Unit Empty :=
  ⟨⟨fun s _ t => Step s t⟩, fun _ c => nomatch c⟩

/-- A chain with at least as many steps left as a test looks deep passes it exactly where the
endless configuration does. -/
theorem rest_holds_iff : ∀ (φ : BranchingTest Unit Empty) (k : Nat), Chains.depth φ ≤ k →
    (BranchingTest.Holds frame (.rest k) φ ↔ BranchingTest.Holds frame .endless φ)
  | .top, _, _ => Iff.rfl
  | .claim c, _, _ => nomatch c
  | .not φ, k, deep => match rest_holds_iff φ k deep with
    | same => ⟨fun fails passes => fails (same.mpr passes),
        fun fails passes => fails (same.mp passes)⟩
  | .both φ ψ, k, deep =>
    match rest_holds_iff φ k (Nat.le_trans (Nat.le_add_right _ _) deep),
        rest_holds_iff ψ k (Nat.le_trans (Nat.le_add_left _ _) deep) with
    | first, second => ⟨fun ⟨holds, holds'⟩ => ⟨first.mp holds, second.mp holds'⟩,
        fun ⟨holds, holds'⟩ => ⟨first.mpr holds, second.mpr holds'⟩⟩
  | .can _ _, 0, deep => absurd deep (Nat.not_succ_le_zero _)
  | .can _ φ, k + 1, deep =>
    match rest_holds_iff φ k (Nat.le_of_succ_le_succ deep) with
    | same => ⟨fun ⟨_, step, holds⟩ => match step with
        | .down _ j one => ⟨.endless, .endlessOnward,
            same.mp (Eq.subst (motive := fun i => BranchingTest.Holds frame (.rest i) φ)
              (Nat.succ.inj one).symm holds)⟩,
      fun ⟨_, step, holds⟩ => match step with
        | .endlessOnward => ⟨.rest k, .down (k + 1) k rfl, same.mpr holds⟩⟩

/-- **`bounded` and `unbounded` pass the same branching tests**: what `endless` passes, the chain
with as many steps left as the test looks deep passes. -/
theorem sameBranchingTests : SameBranchingTests frame frame .bounded .unbounded
  | .top => Iff.rfl
  | .claim c => nomatch c
  | .not φ => ⟨fun fails passes => fails ((sameBranchingTests φ).mpr passes),
      fun fails passes => fails ((sameBranchingTests φ).mp passes)⟩
  | .both φ ψ => ⟨fun ⟨first, second⟩ =>
        ⟨(sameBranchingTests φ).mp first, (sameBranchingTests ψ).mp second⟩,
      fun ⟨first, second⟩ =>
        ⟨(sameBranchingTests φ).mpr first, (sameBranchingTests ψ).mpr second⟩⟩
  | .can _ φ => ⟨fun ⟨_, step, passes⟩ => match step with
        | .boundedRest n => ⟨.rest n, .unboundedRest n, passes⟩,
      fun ⟨_, step, passes⟩ => match step with
        | .unboundedRest n => ⟨.rest n, .boundedRest n, passes⟩
        | .unboundedEndless => ⟨.rest (Chains.depth φ), .boundedRest _,
            (rest_holds_iff φ (Chains.depth φ) (Nat.le_refl _)).mpr passes⟩⟩

/-- No chain is alike to `endless`: the chain runs out of steps. -/
theorem endless_not_alike_rest : ∀ k, ¬ Alike frame frame .endless (.rest k)
  | 0, alike => match alike.step (a := ()) (t := .endless) .endlessOnward with
    | ⟨_, .down _ _ one, _⟩ => Nat.noConfusion one
  | k + 1, alike => match alike.step (a := ()) (t := .endless) .endlessOnward with
    | ⟨_, .down _ j one, joined⟩ => endless_not_alike_rest k
        (Eq.subst (motive := fun i => Alike frame frame .endless (.rest i)) (Nat.succ.inj one).symm
          joined)

/-- **`bounded` and `unbounded` are not alike**: the step of `unbounded` to `endless` is met by no
step of `bounded`. -/
theorem not_alike : ¬ Alike frame frame .bounded .unbounded :=
  fun alike => match alike.symm.step (a := ()) (t := .endless) .unboundedEndless with
  | ⟨_, .boundedRest k, joined⟩ => endless_not_alike_rest k joined

end Unbounded

/-- **Where each move has listed outcomes, branching tests fix likeness exactly under
`EitherThroughout`.** That configurations passing the same branching tests are alike, for every
frame with one move and no claims whose moves have listed outcomes, holds exactly where of two
decided decreasing families one of which holds at each step, one holds throughout: the finitely
many configurations of `FiniteDecided` cannot be replaced by finitely many outcomes without it. -/
theorem alike_of_sameBranchingTests_outcomes_iff :
    (∀ (S : Type) (F G : Frame S Unit Empty) (s s' : S), OutcomesListed F → OutcomesListed G →
        SameBranchingTests F G s s' → Alike F G s s') ↔ EitherThroughout :=
  ⟨fun fixes _ _ decided decided' down down' each =>
    Chains.throughout_of_alike (fixes _ (Chains.frame _ _) (Chains.frame _ _) .three .two
      (Chains.outcomesListed decided decided') (Chains.outcomesListed decided decided')
      (Chains.sameBranchingTests down down' each)),
   fun either _ _ _ _ _ listed listed' same =>
    (OutcomesListed.alike_iff_sameBranchingTests either ⟨[()], fun _ => .head _⟩
      ⟨[], fun c => nomatch c⟩ listed listed').mpr same⟩

/-! ## A branching test sees when a choice is made -/

namespace Choosing

/-- That the first move can lead to a configuration where both `b` and `c` can be taken. -/
def bothOpen : BranchingTest Move Empty :=
  .can .a (.both (.can .b .top) (.can .c .top))

/-- **A branching test tells apart the two starts that pass the same tests**: it holds where the
choice comes after the first move and fails where it is made at it. -/
theorem branching_apart :
    BranchingTest.Holds late .p0 bothOpen ∧ ¬ BranchingTest.Holds early .p0 bothOpen :=
  ⟨⟨.p1, .first, ⟨.p2, .left, True.intro⟩, ⟨.p3, .right, True.intro⟩⟩,
   fun ⟨_, step, ⟨_, toB, _⟩, ⟨_, toC, _⟩⟩ => match step, toB, toC with
    | .toLeft, _, toC => nomatch toC
    | .toRight, toB, _ => nomatch toB⟩

end Choosing

/-! ## The dichotomy of difference-making -/

namespace Dependence

variable {S : Type u} {A : Type v} {F C : Type} {K : Dependence S F C}

/-- **The dichotomy needs only the level after the move to be one.** Where the move can be taken
with `f`'s part withheld, the dependence still holds and is met there, and every step by the move
from the withheld configuration reaches the same level of the condition, either `f`'s part makes
the difference or the same move still breaks the dependence. -/
theorem dichotomy_of_same_level {P : Process S A} {withhold : F → S → S} {f : F} {s : S} {a : A}
    {g : F} {c : C} (same : ∀ t t', P.step (withhold f s) a t → P.step (withhold f s) a t' →
      K.level t c = K.level t' c)
    (breaks : K.BreaksBy P s a g c) {t₀ : S} (available : P.step (withhold f s) a t₀)
    (depends : K.requires (withhold f s) g c)
    (met : K.need (withhold f s) g c ≤ K.level (withhold f s) c) :
    K.MakesDifference P withhold f s a g c ∨ K.BreaksBy P (withhold f s) a g c :=
  match Nat.lt_or_ge (K.level t₀ c) (K.need (withhold f s) g c) with
  | .inl fell => .inr ⟨t₀, available, depends, met, fell⟩
  | .inr held => .inl ⟨breaks, ⟨t₀, available⟩, fun t step =>
      ⟨met, Eq.subst (motive := fun n => K.need (withhold f s) g c ≤ n)
        (same t₀ t available step) held⟩⟩

/-- **Determinacy up to likeness under claims telling the level apart suffices.** Where alike
configurations, read by `claims`, are at the same level of the condition and the frame is
determined up to likeness at the withheld configuration, the dichotomy holds. -/
theorem dichotomy_of_determinedAt {D : Type w} {P : Process S A} {claims : S → D → Prop}
    {withhold : F → S → S} {f : F} {s : S} {a : A} {g : F} {c : C}
    (registers : ∀ x y, (∀ d, claims x d ↔ claims y d) → K.level x c = K.level y c)
    (determined : DeterminedAt (⟨P, claims⟩ : Frame S A D) (withhold f s))
    (breaks : K.BreaksBy P s a g c) {t₀ : S} (available : P.step (withhold f s) a t₀)
    (depends : K.requires (withhold f s) g c)
    (met : K.need (withhold f s) g c ≤ K.level (withhold f s) c) :
    K.MakesDifference P withhold f s a g c ∨ K.BreaksBy P (withhold f s) a g c :=
  dichotomy_of_same_level
    (fun t t' step step' => registers t t' (determined a t t' step step').realized)
    breaks available depends met

/-- The claims reading the level of the condition tell it apart. -/
theorem level_registers (c : C) :
    ∀ x y : S, (∀ n, K.level x c = n ↔ K.level y c = n) → K.level x c = K.level y c :=
  fun _ y same => (same (K.level y c)).mpr rfl

end Dependence

end Becoming

section ListedOutcomeFrames

/-!
## Listed-outcome frames: what fixes likeness where each move has listed outcomes

`Becoming.Likeness` states that branching tests fix likeness in frames whose moves each have
listed outcomes exactly under `EitherThroughout`, a principle of reasoning
(`alike_of_sameBranchingTests_outcomes_iff`), and that this principle is the lesser limited
principle of omniscience for decided families (`eitherThroughout_iff_llpoForDecided`), gives it
in its standard form (`LLPO.of_eitherThroughout`) and follows from `NowhereDecided`
(`EitherThroughout.of_nowhereDecided`). This section states those strengths of the frames
themselves: what it takes for configurations of a frame passing the same branching tests to be
alike.

* **Branching tests fix likeness in every listed-outcome frame exactly under the lesser limited
  principle for decided families** (`sameBranchingTests_fix_iff_llpoForDecided`), and so give
  `LLPO` in its standard form (`llpo_of_sameBranchingTests_fix`).
* **Where whether a decided family holds nowhere is decided, branching tests fix likeness** in
  every pair of frames with listed moves, listed claims and listed outcomes
  (`alike_iff_sameBranchingTests_of_nowhereDecided`).

No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

open Generative

universe u u' v w

namespace ListedOutcomeFrames

/-- **Branching tests fix likeness in every frame with listed outcomes exactly under the lesser
limited principle of omniscience for decided families.** That configurations passing the same
branching tests are alike, for every frame with one move and no claims whose moves have listed
outcomes, holds exactly where every decided family holding at most once fails at every even place
or at every odd place. -/
theorem sameBranchingTests_fix_iff_llpoForDecided :
    (∀ (S : Type) (F G : Frame S Unit Empty) (s s' : S), OutcomesListed F → OutcomesListed G →
        SameBranchingTests F G s s' → Alike F G s s') ↔ LLPOForDecided :=
  alike_of_sameBranchingTests_outcomes_iff.trans eitherThroughout_iff_llpoForDecided

/-- **Where branching tests fix likeness in every frame with listed outcomes, `LLPO` holds** in its
standard form, for Boolean sequences with at most one `true`. -/
theorem llpo_of_sameBranchingTests_fix
    (fixes : ∀ (S : Type) (F G : Frame S Unit Empty) (s s' : S), OutcomesListed F →
      OutcomesListed G → SameBranchingTests F G s s' → Alike F G s s') : LLPO :=
  LLPO.of_eitherThroughout (alike_of_sameBranchingTests_outcomes_iff.mp fixes)

section Frames

variable {S : Type u} {S' : Type u'} {A : Type v} {C : Type w}
  {F : Frame S A C} {G : Frame S' A C}

/-- **Where whether a decided family holds nowhere is decided, branching tests fix likeness in
frames with listed outcomes.** Where the moves and claims are listed, the claims are decided and
each move of each configuration has listed outcomes, configurations are alike exactly where they
pass the same branching tests. -/
theorem alike_iff_sameBranchingTests_of_nowhereDecided (nowhere : NowhereDecided)
    (moves : ∃ l : List A, ∀ a, a ∈ l) (claims : ∃ l : List C, ∀ c, c ∈ l)
    (listed : OutcomesListed F) (listed' : OutcomesListed G) {s : S} {s' : S'} :
    Alike F G s s' ↔ SameBranchingTests F G s s' :=
  OutcomesListed.alike_iff_sameBranchingTests (EitherThroughout.of_nowhereDecided nowhere) moves
    claims listed listed'

end Frames

end ListedOutcomeFrames

end Becoming

end ListedOutcomeFrames
