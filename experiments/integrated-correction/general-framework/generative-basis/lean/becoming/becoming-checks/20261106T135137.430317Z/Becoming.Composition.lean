import Becoming.Likeness
import Becoming.JointPlans
import Becoming.Witnesses

/-!
# Composition: a whole and the parts it holds together

`Becoming.Unfolding` reads a configuration by how it relates to its continuations (`Alike`), and
`Becoming.Likeness` by the branching tests it passes. Neither says which configurations a
configuration holds together as its parts. This module adds that relation and states what it
carries, with no premise beyond what each theorem names.

A joint frame is a frame with one more relation among its configurations: `joint s l r` says that
`s` realizes `l` and `r` together (`JointFrame`). Whole and parts are configurations of the same
unfolding, so no second kind of thing is posited; the relation is not assumed associative,
ordered, unital or free to repeat a part. Which configurations are read as parts of which is a
representational commitment, as `Becoming.Wholes` says of its part–whole relation.

* **Likeness respecting the parts.** A joint bisimulation is a bisimulation that also matches the
  parts each whole holds together, part by part (`MatchesParts`, `JointBisimulation`). It is the
  case of one relation of the bisimulations of `Becoming.Likeness` that match a family of such
  relations (`BisimulationWith`, `AlikeWith`, `TestWith`), whose laws joint likeness and joint
  tests inherit through abbreviations. Joint likeness (`JointAlike`) is an equivalence (`AlikeWith.refl`, `AlikeWith.symm`,
  `AlikeWith.trans`) and is likeness of the frames with the parts forgotten, and more
  (`AlikeWith.alike`). A joint test adds to the branching tests that a configuration holds
  together two parts passing two tests (`JointTest`, `together`); jointly alike configurations
  pass the same joint tests, with no premise (`AlikeWith.sameTestsWith`), and passing the same
  joint tests is passing the same branching tests, and more (`BranchingTest.holds_toWith`,
  `SameTestsWith.sameBranchingTests`). The parts add distinctions: two configurations with no
  move and no claim are alike, while only one holds a pair of parts, which `together` sees
  (`Pairing.alike`, `Pairing.not_jointAlike`). Where joint tests or joint likeness tell a frame's
  configurations apart, a configuration passes the same tests as at most one of them
  (`SameTestsWith.functional`, `AlikeWith.functional`).
* **Joint tests fix joint likeness where every family of tests met finitely is met, and the tests
  are stable.** A domain is compact for a reading of questions where every family of questions,
  each finitely many of which some member of the domain meets, is met by one member
  (`Compact`); a domain with no member, or with a member meeting every question any member meets,
  is compact with no principle (`Compact.of_empty`, `Compact.of_greatest`). Where the outcomes of
  the other configuration's move are compact for the joint tests (`JointFrame.StepCompact`), a step
  is matched by a step into a configuration passing every joint test the outcome passes
  (`SameJointTests.step_passing`); where the pairs the other holds together are compact
  (`JointFrame.JointCompact`), a pair of parts is matched by a pair, each part passing every test
  the part it matches passes (`SameJointTests.parts_passing`): one `together` question carries
  each finite family of requirements on both parts at once. Neither needs a principle. Passing at
  least the tests becomes passing the same tests where the tests are stable, holding wherever they
  cannot fail (`JointFrame.TestsStable`, `SameJointTests.of_passes`), since the failure of a test
  is a test. So where both frames' moves and pairs of parts are compact and their tests stable,
  configurations are jointly alike exactly where they pass the same joint tests
  (`jointAlike_iff_sameJointTests`). Excluded middle gives stability
  (`JointFrame.TestsStable.of_em`) and makes every listed domain compact (`Compact.of_listed`), so
  under it, where each move's outcomes and each whole's pairs of parts are listed, configurations
  are jointly alike exactly where they pass the same joint tests
  (`jointAlike_iff_sameJointTests_of_listed`).
* **Stability cannot be dropped: without it, excluded middle is exactly what is needed.** In
  `DoubleNegation` one configuration holds `plain` and `rest` together and `doubled` and `rest`,
  another holds only `doubled` and `rest`; a claim is realized at `plain` where a proposition
  holds and at `doubled` where it cannot fail. Whatever `doubled` passes `plain` cannot fail to
  pass and whatever `plain` passes `doubled` passes (`DoubleNegation.plain_doubled`), so the two
  wholes pass the same joint tests (`DoubleNegation.sameJointTests`) and the pairs are compact
  (`DoubleNegation.jointCompact`), with no principle; `plain` passes the same tests as `doubled`
  only where the proposition holds wherever it cannot fail (`DoubleNegation.stable_of_parts`).
  So that passing the same joint tests matches parts in every frame whose pairs of parts are
  compact holds exactly under excluded middle (`matchesParts_of_compact_iff_em`), and so does
  that it gives joint likeness in every frame whose moves and pairs are compact
  (`jointAlike_of_sameJointTests_iff_em`).
* **Reading the parts through a description.** A description `π` reads the joint relation as
  holding among descriptions (`jointImage`). The parts it reads at a description lift from every
  configuration so described, with parts so described, exactly where configurations it
  identifies match parts into configurations it identifies (`liftsFromEach_iff`); where it
  identifies exactly the configurations some relation relates, exactly where that relation
  matches parts (`liftsFromEach_iff_of_kernel`). So the parts lift wherever the description
  identifies exactly the jointly alike configurations, with no premise
  (`IdentifiesJointAlike.lifts`), and wherever it identifies exactly the configurations passing
  the same joint tests, the pairs of parts being compact and the tests stable
  (`liftsFromEach_of_sameJointTests`); there, lifting is passing the same joint tests matching
  parts, which without stability needs excluded middle.
* **Nested decompositions.** A joint plan is a finite binary nesting of leaves
  (`JointPlan`); a configuration realizes it where it holds together parts realizing its two
  sides, down to leaves read at the parts (`JointPlan.Realizes`). Where configurations a
  description identifies match parts into configurations it identifies, and the leaves are read
  correctly through the description, a description realizes a plan exactly where every
  configuration it describes does (`JointPlan.realizes_image_iff`); conversely, plans lifting from
  every configuration is matching parts (`JointPlan.plans_lift_iff`). Each node keeps its own
  witness: nothing fixes which particular parts are used, or shared across branches.
* **Exclusive footprints.** Where the footprint of each part a whole holds lies within the
  whole's (`PartsWithin`) and the two parts' footprints share nothing (`PartsApart`), what the
  leaves of a realized plan draw on, joined (`JointPlan.draws`), repeats nothing and lies within
  the root's footprint (`JointPlan.supports_of_realizes`), and so wherever the plan is realized at
  a description whose parts lift (`JointPlan.supports_of_image`). The converse fails with nothing
  more: the root's footprint can support every leaf where no whole holds any part
  (`Unjoined.supports_not_realizes`). That nothing repeats is the core's `Distinct`
  (`nodup_iff_distinct`).

What is not derived: which relation describes the parts of anything, and that footprints are
exclusive; these are supplied and local. Compactness is a hypothesis, as in the periphery; whether
a listed domain is compact without excluded middle is left open. Where the tests are decided,
stability holds outright; whether a principle weaker than excluded middle suffices for some
narrower class of frames is left open. That a description identifying exactly the configurations
passing the same joint tests exists is not derived: the description by answer sets needs
propositional and function extensionality. Nor is it derived that a realized plan's leaves can be
realized at once, or that a part with the same tests can stand in for a designated part.
`Becoming.CompositionBridge` reads `ExplanatoryJointness` and `ExplanatoryFootprints` as
instances; the counterexamples of their study stay with them.

**Reading.** Two tests both holding at a configuration is not one configuration holding together
two parts that pass them: `both` asks the first, `together` the second, and what can hold together
is a relation of the unfolding, not a sum of what holds separately. The readings are the AI's,
adopted on Ren's delegation of 15 October 2026 (DELEGATED-CHOICES D33). No ethical predicate,
ranking or axiom occurs.

Joint plans and exclusive footprints for any ternary relation (`JointPlan`, `JointPlan.Realizes`,
`JointPlan.draws`, `PartsWithin`, `PartsApart`, `Supports`, `JointPlan.within_of_realizes`,
`JointPlan.nodup_of_realizes`, `JointPlan.supports_of_realizes`, `nodup_append_of_apart`) are in `Becoming.JointPlans`, so the modules using them do not import the
frame (board item W).
-/

namespace Becoming

open Generative

universe u v w u' u'' w' x'

/-! ## Joint frames and joint tests -/

/-- A frame in which a configuration may hold two configurations together as its parts:
`joint s l r` says that `s` realizes `l` and `r` together. The parts are configurations of the
same unfolding; no associativity, order, unit or repetition of parts is assumed. -/
structure JointFrame (S : Type u) (A : Type v) (C : Type w) extends Frame S A C where
  joint : S → S → S → Prop

/-- A joint test: a test with parts (`TestWith` of `Becoming.Likeness`) for the one relation of a
joint frame. It is nothing, a claim, the failure of a test, two tests together, that some step by
a move leads to where a test holds, or that the configuration holds together two parts, the first
passing one test and the second the other (`.together () φ ψ`). -/
abbrev JointTest (A : Type v) (C : Type w) := TestWith Unit A C

section Tests

variable {S : Type u} {S' : Type u'} {A : Type v} {C : Type w}

/-- Where a joint test holds in a joint frame: `TestWith.Holds` at its relation `joint`. -/
abbrev JointTest.Holds (F : JointFrame S A C) : S → JointTest A C → Prop :=
  TestWith.Holds (I := Unit) F.toFrame fun _ => F.joint

/-- Two configurations pass the same joint tests: `SameTestsWith` at the relations `joint`. Its
laws are those of `SameTestsWith` (`refl`, `symm`, `trans`, `functional`,
`sameBranchingTests`). -/
abbrev SameJointTests (F : JointFrame S A C) (G : JointFrame S' A C) (s : S) (s' : S') : Prop :=
  SameTestsWith F.toFrame G.toFrame (fun _ : Unit => F.joint) (fun _ => G.joint) s s'

end Tests

/-! ## Likeness respecting the parts -/

section JointLikeness

variable {S : Type u} {S' : Type u'} {A : Type v} {C : Type w}

/-- A joint bisimulation: a bisimulation of the frames that matches, both ways, the parts each
whole holds together; `BisimulationWith` at the relations `joint`. -/
abbrev JointBisimulation (F : JointFrame S A C) (G : JointFrame S' A C) (B : S → S' → Prop) :
    Prop :=
  BisimulationWith F.toFrame G.toFrame (fun _ : Unit => F.joint) (fun _ => G.joint) B

/-- Two configurations are jointly alike where some joint bisimulation relates them: they relate
alike to every continuation and to every pair of parts; `AlikeWith` at the relations `joint`. Its
laws are those of `AlikeWith`: an equivalence (`refl`, `symm`, `trans`), likeness of the frames
with the parts forgotten and more (`alike`), the same claims, steps and parts (`realized`, `step`,
`parts`), the same joint tests (`holds_iff`, `sameTestsWith`) and `functional`. -/
abbrev JointAlike (F : JointFrame S A C) (G : JointFrame S' A C) (s : S) (s' : S') : Prop :=
  AlikeWith F.toFrame G.toFrame (fun _ : Unit => F.joint) (fun _ => G.joint) s s'

end JointLikeness

/-! ## The parts add distinctions -/

namespace Pairing

/-- `true` holds `false` and `false` together; nothing else holds parts. -/
inductive Pairs : Bool → Bool → Bool → Prop where
  | whole : Pairs true false false

/-- No move, no claim, and one pair of parts. -/
def frame : JointFrame Bool Unit Empty where
  P := Witnesses.halted _ _
  realized := fun _ c => nomatch c
  joint := Pairs

/-- **With the parts forgotten, the two configurations are alike**: neither moves nor realizes a
claim. -/
theorem alike : Alike frame.toFrame frame.toFrame true false :=
  ⟨fun _ _ => True, fun _ _ _ =>
    ⟨fun c => (nomatch c), fun _ _ step => False.elim step, fun _ _ step => False.elim step⟩,
   True.intro⟩

/-- `together` tells them apart: `true` holds a pair of parts and `false` holds none. -/
theorem apart :
    JointTest.Holds frame true (.together () .top .top) ∧
      ¬ JointTest.Holds frame false (.together () .top .top) :=
  ⟨⟨false, false, Pairs.whole, True.intro, True.intro⟩,
   fun ⟨_, _, (pairs : Pairs false _ _), _⟩ => nomatch pairs⟩

/-- **So they are not jointly alike.** -/
theorem not_jointAlike : ¬ JointAlike frame frame true false :=
  fun alike => apart.2 ((AlikeWith.holds_iff (.together () .top .top) alike).mp apart.1)

end Pairing

/-! ## Joint tests fix joint likeness under compactness and stability -/

section Compactness

variable {S : Type u} {S' : Type u'} {A : Type v} {C : Type w}

/-- A domain is compact for a reading of questions where every family of questions, each finitely
many of which some member of the domain meets, is met by one member. -/
def Compact {X : Type u} {Q : Type v} (domain : X → Prop) (truth : X → Q → Prop) : Prop :=
  ∀ Γ : Q → Prop,
    (∀ qs : List Q, (∀ q, q ∈ qs → Γ q) → ∃ x, domain x ∧ ∀ q, q ∈ qs → truth x q) →
      ∃ x, domain x ∧ ∀ q, Γ q → truth x q

/-- The outcomes of each move of each configuration are compact for the joint tests. -/
def JointFrame.StepCompact (F : JointFrame S A C) : Prop :=
  ∀ s a, Compact (F.P.step s a) (JointTest.Holds F)

/-- The pairs of parts each configuration holds together are compact for pairs of joint tests,
read part by part. Compactness is of the pairs held together, not of each side apart. -/
def JointFrame.JointCompact (F : JointFrame S A C) : Prop :=
  ∀ s, Compact (fun p : S × S => F.joint s p.1 p.2)
    (fun (p : S × S) (q : JointTest A C × JointTest A C) =>
      JointTest.Holds F p.1 q.1 ∧ JointTest.Holds F p.2 q.2)

/-- Every joint test is stable: it holds wherever it cannot fail. -/
def JointFrame.TestsStable (F : JointFrame S A C) : Prop :=
  ∀ s φ, ¬ ¬ JointTest.Holds F s φ → JointTest.Holds F s φ

/-- Excluded middle makes every joint test stable. -/
theorem JointFrame.TestsStable.of_em (em : ∀ p : Prop, Decided p) (F : JointFrame S A C) :
    F.TestsStable :=
  fun _ _ cannotFail => (em _).of_not_not cannotFail

/-- All tests of a list together. -/
def JointTest.all : List (JointTest A C) → JointTest A C
  | [] => .top
  | φ :: φs => .both φ (JointTest.all φs)

/-- All tests of a list hold together exactly where each holds. -/
theorem JointTest.holds_all {F : JointFrame S A C} {s : S} :
    ∀ φs : List (JointTest A C),
      JointTest.Holds F s (JointTest.all φs) ↔ ∀ φ, φ ∈ φs → JointTest.Holds F s φ
  | [] => ⟨fun _ _ mem => (nomatch mem), fun _ => True.intro⟩
  | φ :: φs =>
    ⟨fun ⟨first, rest⟩ ψ mem => match mem_cons_cases mem with
      | .inl same => Eq.subst (motive := fun χ => JointTest.Holds F s χ) same.symm first
      | .inr mem => (JointTest.holds_all φs).mp rest ψ mem,
     fun all => ⟨all φ (.head φs), (JointTest.holds_all φs).mpr fun ψ mem => all ψ (.tail φ mem)⟩⟩

/-- The first tests of a list of pairs, together. -/
def JointTest.firsts : List (JointTest A C × JointTest A C) → JointTest A C
  | [] => .top
  | q :: qs => .both q.1 (JointTest.firsts qs)

/-- The second tests of a list of pairs, together. -/
def JointTest.seconds : List (JointTest A C × JointTest A C) → JointTest A C
  | [] => .top
  | q :: qs => .both q.2 (JointTest.seconds qs)

/-- The first tests hold together exactly where each holds. -/
theorem JointTest.holds_firsts {F : JointFrame S A C} {s : S} :
    ∀ qs : List (JointTest A C × JointTest A C),
      JointTest.Holds F s (JointTest.firsts qs) ↔ ∀ q, q ∈ qs → JointTest.Holds F s q.1
  | [] => ⟨fun _ _ mem => (nomatch mem), fun _ => True.intro⟩
  | q :: qs =>
    ⟨fun ⟨first, rest⟩ q' mem => match mem_cons_cases mem with
      | .inl same => Eq.subst (motive := fun χ => JointTest.Holds F s χ.1) same.symm first
      | .inr mem => (JointTest.holds_firsts qs).mp rest q' mem,
     fun all => ⟨all q (.head qs), (JointTest.holds_firsts qs).mpr fun q' mem => all q' (.tail q mem)⟩⟩

/-- The second tests hold together exactly where each holds. -/
theorem JointTest.holds_seconds {F : JointFrame S A C} {s : S} :
    ∀ qs : List (JointTest A C × JointTest A C),
      JointTest.Holds F s (JointTest.seconds qs) ↔ ∀ q, q ∈ qs → JointTest.Holds F s q.2
  | [] => ⟨fun _ _ mem => (nomatch mem), fun _ => True.intro⟩
  | q :: qs =>
    ⟨fun ⟨first, rest⟩ q' mem => match mem_cons_cases mem with
      | .inl same => Eq.subst (motive := fun χ => JointTest.Holds F s χ.2) same.symm first
      | .inr mem => (JointTest.holds_seconds qs).mp rest q' mem,
     fun all => ⟨all q (.head qs), (JointTest.holds_seconds qs).mpr fun q' mem => all q' (.tail q mem)⟩⟩

/-- **Where the tests are stable at a configuration, one passing every test it passes passes the
same tests**: the failure of a test is a test. -/
theorem SameJointTests.of_passes {F : JointFrame S A C} {G : JointFrame S' A C} {s : S} {s' : S'}
    (stable : ∀ φ, ¬ ¬ JointTest.Holds F s φ → JointTest.Holds F s φ)
    (passes : ∀ φ, JointTest.Holds F s φ → JointTest.Holds G s' φ) : SameJointTests F G s s' :=
  fun φ => ⟨passes φ, fun holds' => stable φ fun fails => passes (.not φ) fails holds'⟩

/-- **A step is matched by a step into a configuration passing every joint test the step's
outcome passes**, where the outcomes of the other's move are compact; no stability is needed. -/
theorem SameJointTests.step_passing {F : JointFrame S A C} {G : JointFrame S' A C}
    (compact : G.StepCompact) {s : S} {s' : S'} (same : SameJointTests F G s s') {a : A} {t : S}
    (step : F.P.step s a t) :
    ∃ t', G.P.step s' a t' ∧ ∀ φ, JointTest.Holds F t φ → JointTest.Holds G t' φ :=
  compact s' a (fun φ => JointTest.Holds F t φ) fun φs all =>
    match (same (.can a (JointTest.all φs))).mp ⟨t, step, (JointTest.holds_all φs).mpr all⟩ with
    | ⟨t', step', holds⟩ => ⟨t', step', (JointTest.holds_all φs).mp holds⟩

/-- **A step is matched into configurations passing the same joint tests**, where the outcomes of
the other's move are compact and the tests are stable at the step's outcome. -/
theorem SameJointTests.step {F : JointFrame S A C} {G : JointFrame S' A C}
    (compact : G.StepCompact) {s : S} {s' : S'} (same : SameJointTests F G s s') {a : A} {t : S}
    (step : F.P.step s a t) (stable : ∀ φ, ¬ ¬ JointTest.Holds F t φ → JointTest.Holds F t φ) :
    ∃ t', G.P.step s' a t' ∧ SameJointTests F G t t' :=
  match SameJointTests.step_passing compact same step with
  | ⟨t', step', passes⟩ => ⟨t', step', SameJointTests.of_passes stable passes⟩

/-- **A pair of parts one holds together is matched by a pair the other holds together, each part
passing every joint test the part it matches passes**, where the pairs the other holds together are
compact; no stability is needed. One `together` question carries each finite family of
requirements on the two parts at once. -/
theorem SameJointTests.parts_passing {F : JointFrame S A C} {G : JointFrame S' A C}
    (compact : G.JointCompact) {s : S} {s' : S'} (same : SameJointTests F G s s') {l r : S}
    (joint : F.joint s l r) :
    ∃ l' r', G.joint s' l' r' ∧ (∀ φ, JointTest.Holds F l φ → JointTest.Holds G l' φ) ∧
      ∀ φ, JointTest.Holds F r φ → JointTest.Holds G r' φ :=
  match compact s' (fun q => JointTest.Holds F l q.1 ∧ JointTest.Holds F r q.2) (fun qs all =>
      match (same (.together () (JointTest.firsts qs) (JointTest.seconds qs))).mp
          ⟨l, r, joint, (JointTest.holds_firsts qs).mpr fun q mem => (all q mem).1,
            (JointTest.holds_seconds qs).mpr fun q mem => (all q mem).2⟩ with
      | ⟨l', r', joint', left, right⟩ =>
        ⟨(l', r'), joint', fun q mem =>
          ⟨(JointTest.holds_firsts qs).mp left q mem, (JointTest.holds_seconds qs).mp right q mem⟩⟩)
  with
  | ⟨p, joint', passes⟩ =>
    ⟨p.1, p.2, joint', fun φ holds => (passes (φ, .top) ⟨holds, True.intro⟩).1,
     fun φ holds => (passes (.top, φ) ⟨True.intro, holds⟩).2⟩

/-- **A pair of parts one holds together is matched by a pair the other holds together, passing
the same joint tests part by part**, where the pairs the other holds together are compact and the
tests are stable at the parts. -/
theorem SameJointTests.parts {F : JointFrame S A C} {G : JointFrame S' A C}
    (compact : G.JointCompact) {s : S} {s' : S'} (same : SameJointTests F G s s') {l r : S}
    (joint : F.joint s l r) (stableL : ∀ φ, ¬ ¬ JointTest.Holds F l φ → JointTest.Holds F l φ)
    (stableR : ∀ φ, ¬ ¬ JointTest.Holds F r φ → JointTest.Holds F r φ) :
    ∃ l' r', G.joint s' l' r' ∧ SameJointTests F G l l' ∧ SameJointTests F G r r' :=
  match SameJointTests.parts_passing compact same joint with
  | ⟨l', r', joint', left, right⟩ =>
    ⟨l', r', joint', SameJointTests.of_passes stableL left, SameJointTests.of_passes stableR right⟩

/-- **Passing the same joint tests matches parts**, in one frame whose pairs of parts are compact
and whose tests are stable. -/
theorem SameJointTests.matchesParts {F : JointFrame S A C} (compact : F.JointCompact)
    (stable : F.TestsStable) : MatchesParts F.joint F.joint (SameJointTests F F) :=
  fun _ _ same _ _ joint => SameJointTests.parts compact same joint (stable _) (stable _)

/-- **Passing the same joint tests is a joint bisimulation** where both frames' moves and pairs of
parts are compact and both frames' tests are stable. -/
theorem sameJointTests_bisimulation {F : JointFrame S A C} {G : JointFrame S' A C}
    (steps : F.StepCompact) (steps' : G.StepCompact) (joints : F.JointCompact)
    (joints' : G.JointCompact) (stable : F.TestsStable) (stable' : G.TestsStable) :
    JointBisimulation F G (SameJointTests F G) :=
  ⟨fun _ _ same =>
    ⟨fun c => same (.claim c),
     fun _ t step => SameJointTests.step steps' same step (stable t),
     fun _ t' step' => match SameJointTests.step steps same.symm step' (stable' t') with
       | ⟨t, step, same'⟩ => ⟨t, step, same'.symm⟩⟩,
   fun _ => ⟨fun _ _ same _ _ joint => SameJointTests.parts joints' same joint (stable _) (stable _),
   fun _ _ same _ _ joint' =>
     match SameJointTests.parts joints same.symm joint' (stable' _) (stable' _) with
     | ⟨l, r, joint, left, right⟩ => ⟨l, r, joint, left.symm, right.symm⟩⟩⟩

/-- **Joint tests fix joint likeness under compactness and stability.** Where both frames' moves
and pairs of parts are compact and both frames' tests are stable, configurations are jointly alike
exactly where they pass the same joint tests. -/
theorem jointAlike_iff_sameJointTests {F : JointFrame S A C} {G : JointFrame S' A C}
    (steps : F.StepCompact) (steps' : G.StepCompact) (joints : F.JointCompact)
    (joints' : G.JointCompact) (stable : F.TestsStable) (stable' : G.TestsStable) {s : S}
    {s' : S'} : JointAlike F G s s' ↔ SameJointTests F G s s' :=
  ⟨AlikeWith.sameTestsWith, fun same =>
    ⟨_, sameJointTests_bisimulation steps steps' joints joints' stable stable', same⟩⟩

/-- For each listed member failing some question of a family, finitely many questions of the
family leave each listed member failing one. -/
theorem Compact.exclusions {X : Type u} {Q : Type v} {truth : X → Q → Prop} {Γ : Q → Prop} :
    ∀ xs : List X, (∀ x, x ∈ xs → ∃ q, Γ q ∧ ¬ truth x q) →
      ∃ qs : List Q, (∀ q, q ∈ qs → Γ q) ∧ ∀ x, x ∈ xs → ∃ q, q ∈ qs ∧ ¬ truth x q
  | [], _ => ⟨[], fun _ mem => (nomatch mem), fun _ mem => (nomatch mem)⟩
  | x :: xs, fail => match fail x (.head xs), Compact.exclusions xs fun y mem => fail y (.tail x mem) with
    | ⟨q, member, fails⟩, ⟨qs, members, exclude⟩ =>
      ⟨q :: qs, fun q' mem => match mem_cons_cases mem with
        | .inl same => Eq.subst (motive := Γ) same.symm member
        | .inr mem => members q' mem,
       fun y mem => match mem_cons_cases mem with
        | .inl same => ⟨q, .head qs, Eq.subst (motive := fun z => ¬ truth z q) same.symm fails⟩
        | .inr mem => match exclude y mem with
          | ⟨q', inside, fails'⟩ => ⟨q', .tail q inside, fails'⟩⟩

/-- **Under excluded middle, a listed domain is compact**: were no member to meet the whole family,
each would fail one of finitely many of its questions, which some member meets. -/
theorem Compact.of_listed (em : ∀ p : Prop, Decided p) {X : Type u} {Q : Type v}
    {domain : X → Prop} {truth : X → Q → Prop} {xs : List X} (listed : ∀ x, domain x ↔ x ∈ xs) :
    Compact domain truth :=
  fun Γ finite => match em (∃ x, domain x ∧ ∀ q, Γ q → truth x q) with
  | .inl found => found
  | .inr absent =>
    match Compact.exclusions (truth := truth) (Γ := Γ) xs fun x mem =>
        match em (∃ q, Γ q ∧ ¬ truth x q) with
        | .inl failing => failing
        | .inr meets => False.elim (absent ⟨x, (listed x).mpr mem, fun q member =>
            (em (truth x q)).of_not_not fun fails => meets ⟨q, member, fails⟩⟩) with
    | ⟨qs, members, exclude⟩ => match finite qs members with
      | ⟨x, inside, meets⟩ => match exclude x ((listed x).mp inside) with
        | ⟨q, mem, fails⟩ => absurd (meets q mem) fails

/-- **Under excluded middle, where each move's outcomes and each configuration's pairs of parts
are listed, configurations are jointly alike exactly where they pass the same joint tests**:
`alike_iff_sameBranchingTests_of_em` of `Becoming.Likeness` with the parts. -/
theorem jointAlike_iff_sameJointTests_of_listed (em : ∀ p : Prop, Decided p)
    {F : JointFrame S A C} {G : JointFrame S' A C}
    (outcomes : ∀ s a, ∃ l : List S, ∀ t, F.P.step s a t ↔ t ∈ l)
    (outcomes' : ∀ s a, ∃ l : List S', ∀ t, G.P.step s a t ↔ t ∈ l)
    (pairs : ∀ s, ∃ l : List (S × S), ∀ p, F.joint s p.1 p.2 ↔ p ∈ l)
    (pairs' : ∀ s, ∃ l : List (S' × S'), ∀ p, G.joint s p.1 p.2 ↔ p ∈ l) {s : S} {s' : S'} :
    JointAlike F G s s' ↔ SameJointTests F G s s' :=
  jointAlike_iff_sameJointTests
    (fun s a => match outcomes s a with | ⟨_, listed⟩ => Compact.of_listed em listed)
    (fun s a => match outcomes' s a with | ⟨_, listed⟩ => Compact.of_listed em listed)
    (fun s => match pairs s with | ⟨_, listed⟩ => Compact.of_listed em listed)
    (fun s => match pairs' s with | ⟨_, listed⟩ => Compact.of_listed em listed)
    (JointFrame.TestsStable.of_em em F) (JointFrame.TestsStable.of_em em G)

/-- **A domain with no member is compact**, with no principle. -/
theorem Compact.of_empty {X : Type u} {Q : Type v} {domain : X → Prop} {truth : X → Q → Prop}
    (empty : ∀ x, ¬ domain x) : Compact domain truth :=
  fun _ finite => match finite [] (fun _ mem => (nomatch mem)) with
    | ⟨x, inside, _⟩ => absurd inside (empty x)

/-- **A domain with a member meeting every question any member meets is compact**, with no
principle: each question of the family is met by some member, and so by that one. -/
theorem Compact.of_greatest {X : Type u} {Q : Type v} {domain : X → Prop} {truth : X → Q → Prop}
    {d : X} (member : domain d) (greatest : ∀ x, domain x → ∀ q, truth x q → truth d q) :
    Compact domain truth :=
  fun Γ finite => ⟨d, member, fun q inside =>
    match finite [q] (fun _ mem => match mem_cons_cases mem with
        | .inl same => Eq.subst (motive := Γ) same.symm inside
        | .inr mem => (nomatch mem)) with
    | ⟨x, inside', meets⟩ => greatest x inside' q (meets q (.head []))⟩

end Compactness

/-! ## Without stability, excluded middle is exactly what is needed -/

namespace DoubleNegation

/-- Configurations: `two` holds two pairs of parts, `one` holds one; `plain`, `doubled` and `rest`
are parts. -/
inductive Pos where
  | two
  | one
  | plain
  | doubled
  | rest

/-- `two` holds `plain` and `rest` together, and `doubled` and `rest`; `one` holds only `doubled`
and `rest`. -/
inductive Joint : Pos → Pos → Pos → Prop where
  | plain : Joint .two .plain .rest
  | doubled : Joint .two .doubled .rest
  | one : Joint .one .doubled .rest

/-- The one claim: realized at `plain` where `p` holds, and at `doubled` where `p` cannot fail. -/
def Marked (p : Prop) : Pos → Unit → Prop
  | .two, _ => False
  | .one, _ => False
  | .plain, _ => p
  | .doubled, _ => ¬ ¬ p
  | .rest, _ => False

/-- No move; the claim; the pairs of parts. -/
def frame (p : Prop) : JointFrame Pos Unit Unit where
  P := Witnesses.halted _ _
  realized := Marked p
  joint := Joint

/-- Every joint test `plain` passes, `doubled` passes, and every joint test `doubled` passes cannot
fail at `plain`. -/
theorem plain_doubled (p : Prop) : ∀ φ : JointTest Unit Unit,
    (JointTest.Holds (frame p) .plain φ → JointTest.Holds (frame p) .doubled φ) ∧
      (JointTest.Holds (frame p) .doubled φ → ¬ ¬ JointTest.Holds (frame p) .plain φ)
  | .top => ⟨fun _ => True.intro, fun _ fails => fails True.intro⟩
  | .claim _ => ⟨fun holds fails => fails holds, fun holds => holds⟩
  | .not φ => match plain_doubled p φ with
    | ⟨forth, back⟩ =>
      ⟨fun fails holds => back holds fails, fun fails cannot => cannot fun holds => fails (forth holds)⟩
  | .both φ ψ => match plain_doubled p φ, plain_doubled p ψ with
    | ⟨forth, back⟩, ⟨forth', back'⟩ =>
      ⟨fun ⟨holds, holds'⟩ => ⟨forth holds, forth' holds'⟩,
       fun ⟨holds, holds'⟩ fails => back holds fun first => back' holds' fun second =>
         fails ⟨first, second⟩⟩
  | .can _ _ => ⟨fun ⟨_, never, _⟩ => False.elim never, fun ⟨_, never, _⟩ => False.elim never⟩
  | .together _ _ _ =>
    ⟨fun ⟨_, _, (joint : Joint .plain _ _), _⟩ => (nomatch joint),
     fun ⟨_, _, (joint : Joint .doubled _ _), _⟩ => (nomatch joint)⟩

/-- **`two` and `one` pass the same joint tests, whatever `p` is**: what `plain` passes, `doubled`
passes. -/
theorem sameJointTests (p : Prop) : SameJointTests (frame p) (frame p) .two .one
  | .top => Iff.rfl
  | .claim _ => Iff.rfl
  | .not φ => ⟨fun fails holds => fails ((sameJointTests p φ).mpr holds),
      fun fails holds => fails ((sameJointTests p φ).mp holds)⟩
  | .both φ ψ => ⟨fun ⟨holds, holds'⟩ => ⟨(sameJointTests p φ).mp holds, (sameJointTests p ψ).mp holds'⟩,
      fun ⟨holds, holds'⟩ => ⟨(sameJointTests p φ).mpr holds, (sameJointTests p ψ).mpr holds'⟩⟩
  | .can _ _ => ⟨fun ⟨_, never, _⟩ => False.elim never, fun ⟨_, never, _⟩ => False.elim never⟩
  | .together _ φ _ =>
    ⟨fun ⟨l, r, joint, left, right⟩ => match l, r, joint, left, right with
      | _, _, .plain, left, right => ⟨.doubled, .rest, .one, (plain_doubled p φ).1 left, right⟩
      | _, _, .doubled, left, right => ⟨.doubled, .rest, .one, left, right⟩,
     fun ⟨l, r, joint, left, right⟩ => match l, r, joint, left, right with
      | _, _, .one, left, right => ⟨.doubled, .rest, .doubled, left, right⟩⟩

/-- No configuration moves, so the outcomes of each move are compact. -/
theorem stepCompact (p : Prop) : (frame p).StepCompact :=
  fun _ _ => Compact.of_empty fun _ never => never

/-- **The pairs of parts are compact, with no principle**: `doubled` and `rest` meet every pair of
tests either pair `two` holds meets. -/
theorem jointCompact (p : Prop) : (frame p).JointCompact
  | .two => Compact.of_greatest (d := (Pos.doubled, Pos.rest)) Joint.doubled
      fun ⟨_, _⟩ joint q ⟨left, right⟩ => match joint, left, right with
        | .plain, left, right => ⟨(plain_doubled p q.1).1 left, right⟩
        | .doubled, left, right => ⟨left, right⟩
  | .one => Compact.of_greatest (d := (Pos.doubled, Pos.rest)) Joint.one
      fun ⟨_, _⟩ joint _ both => match joint, both with
        | .one, both => both
  | .plain => Compact.of_empty fun ⟨_, _⟩ (joint : Joint .plain _ _) => nomatch joint
  | .doubled => Compact.of_empty fun ⟨_, _⟩ (joint : Joint .doubled _ _) => nomatch joint
  | .rest => Compact.of_empty fun ⟨_, _⟩ (joint : Joint .rest _ _) => nomatch joint

/-- Where `plain` passes the same joint tests as the part `one` holds first, `p` holds wherever it
cannot fail. -/
theorem stable_of_parts {p : Prop} {l r : Pos} (joint : Joint .one l r)
    (same : SameJointTests (frame p) (frame p) .plain l) : ¬ ¬ p → p :=
  match l, r, joint, same with
  | _, _, .one, same => (same (.claim ())).mpr

end DoubleNegation

/-- **Without stability, matching parts by joint tests needs exactly excluded middle.** In every
joint frame whose pairs of parts are compact, configurations passing the same joint tests match
parts into configurations passing the same joint tests exactly where every proposition is decided:
in `DoubleNegation`'s frame the pairs are compact and `two` and `one` pass the same tests with no
principle, and the part `plain` passes the same tests as the part `doubled` only where `p` holds
wherever it cannot fail. Stability of `SameJointTests.parts` cannot be dropped. -/
theorem matchesParts_of_compact_iff_em :
    (∀ (S : Type) (F : JointFrame S Unit Unit), F.JointCompact →
        MatchesParts F.joint F.joint (SameJointTests F F)) ↔ ∀ p : Prop, Decided p :=
  ⟨fun matching p =>
    match matching _ (DoubleNegation.frame (Decided p)) (DoubleNegation.jointCompact _) .two .one
        (DoubleNegation.sameJointTests _) .plain .rest .plain with
    | ⟨_, _, joint, same, _⟩ => DoubleNegation.stable_of_parts joint same (not_not_decided p),
   fun em _ F compact => SameJointTests.matchesParts compact (JointFrame.TestsStable.of_em em F)⟩

/-- **Without stability, joint tests fix joint likeness exactly under excluded middle.** That
configurations passing the same joint tests are jointly alike, in every joint frame whose moves
and pairs of parts are compact, holds exactly where every proposition is decided: the stability in
`jointAlike_iff_sameJointTests` cannot be dropped. -/
theorem jointAlike_of_sameJointTests_iff_em :
    (∀ (S : Type) (F : JointFrame S Unit Unit), F.StepCompact → F.JointCompact →
        ∀ s s', SameJointTests F F s s' → JointAlike F F s s') ↔ ∀ p : Prop, Decided p :=
  ⟨fun fixes p =>
    match (fixes _ (DoubleNegation.frame (Decided p)) (DoubleNegation.stepCompact _)
        (DoubleNegation.jointCompact _) .two .one (DoubleNegation.sameJointTests _)).parts ()
        DoubleNegation.Joint.plain with
    | ⟨_, _, joint, alike, _⟩ =>
      DoubleNegation.stable_of_parts joint alike.sameTestsWith (not_not_decided p),
   fun em _ F steps joints _ _ =>
    (jointAlike_iff_sameJointTests steps steps joints joints (JointFrame.TestsStable.of_em em F)
      (JointFrame.TestsStable.of_em em F)).mpr⟩

/-! ## Reading the parts through a description -/

section Descriptions

variable {S : Type u} {A : Type v} {C : Type w} {K : Type w'}

/-- The joint relation read through a description: `k` holds `l` and `r` together where some
configuration described by `k` holds together parts described by `l` and `r`. -/
def jointImage (J : S → S → S → Prop) (π : S → K) (k l r : K) : Prop :=
  ∃ s x y, π s = k ∧ π x = l ∧ π y = r ∧ J s x y

/-- The parts read together at a description lift from every configuration it describes, with
parts it describes alike. -/
def LiftsFromEach (J : S → S → S → Prop) (π : S → K) : Prop :=
  ∀ s l r, jointImage J π (π s) l r ↔ ∃ x y, J s x y ∧ π x = l ∧ π y = r

/-- **The parts read through a description lift from every configuration it describes exactly
where configurations it identifies match parts into configurations it identifies.** -/
theorem liftsFromEach_iff {J : S → S → S → Prop} {π : S → K} :
    LiftsFromEach J π ↔ MatchesParts J J fun s s' => π s = π s' :=
  ⟨fun lifts s s' same l r joint =>
    match (lifts s' (π l) (π r)).mp ⟨s, l, r, same, rfl, rfl, joint⟩ with
    | ⟨x, y, joint', left, right⟩ => ⟨x, y, joint', left.symm, right.symm⟩,
   fun matching s _ _ =>
    ⟨fun ⟨s', x', y', same, left, right, joint⟩ => match matching s' s same x' y' joint with
      | ⟨x, y, joint', left', right'⟩ => ⟨x, y, joint', left'.symm.trans left, right'.symm.trans right⟩,
     fun ⟨x, y, joint, left, right⟩ => ⟨s, x, y, rfl, left, right, joint⟩⟩⟩

/-- **Through a description identifying exactly the configurations a relation relates, the parts
lift from every configuration it describes exactly where that relation matches parts.** -/
theorem liftsFromEach_iff_of_kernel {J : S → S → S → Prop} {π : S → K} {R : S → S → Prop}
    (kernel : ∀ s s', π s = π s' ↔ R s s') : LiftsFromEach J π ↔ MatchesParts J J R :=
  liftsFromEach_iff.trans
    ⟨fun matching => matching.transport kernel,
     fun matching => matching.transport fun s s' => (kernel s s').symm⟩

/-- A description identifies exactly the jointly alike configurations. -/
def IdentifiesJointAlike (F : JointFrame S A C) (π : S → K) : Prop :=
  ∀ s s', π s = π s' ↔ JointAlike F F s s'

/-- **Through a description identifying exactly the jointly alike configurations, the parts lift
from every configuration it describes**, with no premise. -/
theorem IdentifiesJointAlike.lifts {F : JointFrame S A C} {π : S → K}
    (sense : IdentifiesJointAlike F π) : LiftsFromEach F.joint π :=
  (liftsFromEach_iff_of_kernel sense).mpr (AlikeWith.matchesParts F.toFrame (fun _ => F.joint) ())

/-- **Through a description identifying exactly the configurations passing the same joint tests,
the parts lift from every configuration it describes**, where the pairs of parts are compact and
the tests stable. -/
theorem liftsFromEach_of_sameJointTests {F : JointFrame S A C} {π : S → K}
    (kernel : ∀ s s', π s = π s' ↔ SameJointTests F F s s') (compact : F.JointCompact)
    (stable : F.TestsStable) : LiftsFromEach F.joint π :=
  (liftsFromEach_iff_of_kernel kernel).mpr (SameJointTests.matchesParts compact stable)

end Descriptions

/-! ## Nested decompositions -/

section Plans

variable {S : Type u} {K : Type w'} {Q : Type w}

/-- **A description realizes a plan exactly where each configuration it describes does**, where
configurations it identifies match parts into configurations it identifies and the leaves are read
correctly through it. -/
theorem JointPlan.realizes_image_iff {J : S → S → S → Prop} {π : S → K}
    (matching : MatchesParts J J fun s s' => π s = π s') {leaf : S → Q → Prop}
    {read : K → Q → Prop} (correct : ∀ s q, read (π s) q ↔ leaf s q) :
    ∀ (plan : JointPlan Q) (s : S),
      JointPlan.Realizes (jointImage J π) read (π s) plan ↔ JointPlan.Realizes J leaf s plan
  | .leaf q, s => correct s q
  | .pair p q, s =>
    ⟨fun ⟨l, r, image, left, right⟩ => match (liftsFromEach_iff.mpr matching s l r).mp image with
      | ⟨x, y, joint, atX, atY⟩ =>
        ⟨x, y, joint,
         (JointPlan.realizes_image_iff matching correct p x).mp
           (Eq.subst (motive := fun k => JointPlan.Realizes (jointImage J π) read k p) atX.symm left),
         (JointPlan.realizes_image_iff matching correct q y).mp
           (Eq.subst (motive := fun k => JointPlan.Realizes (jointImage J π) read k q) atY.symm right)⟩,
     fun ⟨x, y, joint, left, right⟩ =>
      ⟨π x, π y, ⟨s, x, y, rfl, rfl, rfl, joint⟩,
       (JointPlan.realizes_image_iff matching correct p x).mpr left,
       (JointPlan.realizes_image_iff matching correct q y).mpr right⟩⟩

/-- Where every plan whose leaves are descriptions, realized at a description, is realized at each
configuration it describes, configurations the description identifies match parts. -/
theorem JointPlan.matchesParts_of_lifts {J : S → S → S → Prop} {π : S → K}
    (lifts : ∀ (s : S) (plan : JointPlan K),
      JointPlan.Realizes (jointImage J π) (fun k k' => k = k') (π s) plan →
        JointPlan.Realizes J (fun x k => π x = k) s plan) :
    MatchesParts J J fun s s' => π s = π s' :=
  fun s s' same l r joint =>
    match lifts s' (.pair (.leaf (π l)) (.leaf (π r)))
        ⟨π l, π r, ⟨s, l, r, same, rfl, rfl, joint⟩, rfl, rfl⟩ with
    | ⟨x, y, joint', atX, atY⟩ => ⟨x, y, joint', atX.symm, atY.symm⟩

/-- **Plans lift through a description exactly where configurations it identifies match parts
into configurations it identifies**: every plan whose leaves are descriptions is realized at a
description exactly where it is realized at each configuration so described. -/
theorem JointPlan.plans_lift_iff {J : S → S → S → Prop} {π : S → K} :
    (∀ (s : S) (plan : JointPlan K),
      JointPlan.Realizes (jointImage J π) (fun k k' => k = k') (π s) plan ↔
        JointPlan.Realizes J (fun x k => π x = k) s plan) ↔
      MatchesParts J J fun s s' => π s = π s' :=
  ⟨fun lifts => JointPlan.matchesParts_of_lifts fun s plan => (lifts s plan).mp,
   fun matching s plan => JointPlan.realizes_image_iff matching (fun _ _ => Iff.rfl) plan s⟩

end Plans

/-! ## Exclusive footprints -/

section Footprints

variable {S : Type u} {K : Type w'} {R : Type x'}

/-- **A list repeats nothing exactly where it is `Distinct`** (`Becoming.Population`). -/
theorem nodup_iff_distinct {α : Type} : ∀ l : List α, l.Nodup ↔ Distinct l
  | [] => ⟨fun _ => True.intro, fun _ => .nil⟩
  | a :: l =>
    ⟨fun | .cons fresh rest => ⟨fun mem => fresh a mem rfl, (nodup_iff_distinct l).mp rest⟩,
     fun ⟨fresh, rest⟩ => .cons (fun _ mem same =>
        fresh (Eq.subst (motive := fun x => x ∈ l) same.symm mem)) ((nodup_iff_distinct l).mpr rest)⟩

/-- **A plan realized at a description is supported at every configuration it describes**, where
configurations the description identifies match parts into configurations it identifies, the
leaves are read correctly through it, and footprints are within and apart. -/
theorem JointPlan.supports_of_image {footprint : S → R → Prop} {J : S → S → S → Prop}
    {π : S → K} (matching : MatchesParts J J fun s s' => π s = π s')
    (within : PartsWithin footprint J) (apart : PartsApart footprint J)
    {read : K → List R → Prop} (correct : ∀ s xs, read (π s) xs ↔ Supports footprint s xs)
    (p : JointPlan (List R)) (s : S) (realizes : JointPlan.Realizes (jointImage J π) read (π s) p) :
    Supports footprint s p.draws :=
  JointPlan.supports_of_realizes within apart p s
    ((JointPlan.realizes_image_iff matching correct p s).mp realizes)

end Footprints

namespace Unjoined

/-- **Support at the root does not give realization.** Where no whole holds any part, the root's
footprint supports what the leaves of a plan of two empty leaves draw on, and the plan is not
realized. -/
theorem supports_not_realizes :
    Supports (fun (_ : Unit) (_ : Unit) => True) ()
        (JointPlan.pair (.leaf ([] : List Unit)) (.leaf [])).draws ∧
      ¬ JointPlan.Realizes (fun (_ _ _ : Unit) => False)
        (Supports fun (_ : Unit) (_ : Unit) => True) ()
        (JointPlan.pair (.leaf ([] : List Unit)) (.leaf [])) :=
  ⟨⟨.nil, fun _ mem => (nomatch mem)⟩, fun ⟨_, _, never, _⟩ => never⟩

end Unjoined

end Becoming

section JointPlanFrames

/-!
## Joint plans of joint frames: nested decompositions read through a description

`Becoming.Composition` states that plans whose leaves are descriptions lift through a description
exactly where configurations it identifies match parts into configurations it identifies
(`JointPlan.plans_lift_iff`), for any ternary relation. A joint frame is a frame of the spine with
the relation of a configuration holding two parts together (`JointFrame`). This section states that
law of the parts of a joint frame, and its two cases where the description identifies exactly the
jointly alike configurations or exactly those passing the same joint tests.

* **Exactly where the identified relation matches parts.** Through a description identifying
  exactly the configurations a relation relates, every plan is realized at a description exactly
  where it is realized at each configuration so described, exactly where that relation matches the
  frame's parts (`plans_lift_iff_of_kernel`).
* **Through joint likeness, with no premise.** Through a description identifying exactly the
  jointly alike configurations, every plan lifts (`plans_lift_of_jointAlike`).
* **Through the joint tests, where the pairs are compact and the tests stable**
  (`plans_lift_of_sameJointTests`).

No ethical predicate, ranking or axiom occurs.
-/

namespace Becoming

open Generative

universe u v w w'

namespace JointPlanFrames

variable {S : Type u} {A : Type v} {C : Type w} {K : Type w'}

/-- **Through a description identifying exactly the configurations a relation relates, plans lift
from every configuration of a joint frame exactly where that relation matches the frame's
parts.** -/
theorem plans_lift_iff_of_kernel (F : JointFrame S A C) {π : S → K} {R : S → S → Prop}
    (kernel : ∀ s s', π s = π s' ↔ R s s') :
    (∀ (s : S) (plan : JointPlan K),
      JointPlan.Realizes (jointImage F.joint π) (fun k k' => k = k') (π s) plan ↔
        JointPlan.Realizes F.joint (fun x k => π x = k) s plan) ↔
      MatchesParts F.joint F.joint R :=
  JointPlan.plans_lift_iff.trans
    ⟨fun matching => matching.transport kernel,
     fun matching => matching.transport fun s s' => (kernel s s').symm⟩

/-- **Through a description identifying exactly the jointly alike configurations, every plan is
realized at a description exactly where it is realized at each configuration so described**, with
no premise. -/
theorem plans_lift_of_jointAlike {F : JointFrame S A C} {π : S → K}
    (sense : IdentifiesJointAlike F π) :
    ∀ (s : S) (plan : JointPlan K),
      JointPlan.Realizes (jointImage F.joint π) (fun k k' => k = k') (π s) plan ↔
        JointPlan.Realizes F.joint (fun x k => π x = k) s plan :=
  (plans_lift_iff_of_kernel F sense).mpr (AlikeWith.matchesParts F.toFrame (fun _ => F.joint) ())

/-- **Through a description identifying exactly the configurations passing the same joint tests,
every plan lifts**, where the frame's pairs of parts are compact and its tests stable. -/
theorem plans_lift_of_sameJointTests {F : JointFrame S A C} {π : S → K}
    (kernel : ∀ s s', π s = π s' ↔ SameJointTests F F s s') (compact : F.JointCompact)
    (stable : F.TestsStable) :
    ∀ (s : S) (plan : JointPlan K),
      JointPlan.Realizes (jointImage F.joint π) (fun k k' => k = k') (π s) plan ↔
        JointPlan.Realizes F.joint (fun x k => π x = k) s plan :=
  (plans_lift_iff_of_kernel F kernel).mpr (SameJointTests.matchesParts compact stable)

end JointPlanFrames

end Becoming

end JointPlanFrames
