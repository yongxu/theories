import Becoming.Lexical
import Becoming.Frame
import Becoming.Extension
import Becoming.Witnesses

/-!
# Joint bundles: what a region of configurations can realize together

A region of a frame's configurations (`here : S → Prop`) is a scope of continuations at one
declared scope. A bundle of claims is jointly realizable there where one configuration of the
region realizes all of it (`Jointly`). One region carries another's profiles where every
configuration of the first has a configuration of the second realizing everything it realizes
(`CarriesProfiles`), and preserves its bundles where every bundle jointly realizable in the first
is jointly realizable in the second (`PreservesBundles`). No ranking, relevance, reason or
obligation is a parameter or conclusion of the first part.

Ported from `JointContinuationClassification` and `RelationalGrounding` (F3J, 18 October 2026),
with the bridge's `Frame.continuations`, `Frame.map_preserves_bundles`,
`Frame.lift_reflects_bundles`, `Frame.ofInventory`, `strict_comparison_through_marginals_by_core`
and `ClassificationRobustJudgment`'s joint enrichment, stated on frames. Every declaration has an
empty axiom report; the periphery's proofs of the event law used `propext`.

* **Profiles and bundles.** Carrying whole profiles is preserving joint bundles, for any profile,
  infinite ones included (`carries_iff_preserves`). Carrying composes through the same
  intermediate configuration (`CarriesProfiles.trans`); a transport sending each configuration of
  the region into the other region and keeping every realization preserves bundles
  (`preserves_of_transport`). On reachable configurations, a step- and claim-preserving map
  preserves bundles and a map whose steps lift and whose claims reflect loses none
  (`Frame.map_preserves`, `Frame.lift_reflects`). Where both descriptions are closed under exact
  complements, carrying a profile admits no newly realized claim (`no_new_of_complement`): a
  complete signed description and a selected description of realizations do different work.
* **The activation law** (`Activation`). From one initial configuration a coupling is retained or
  released; the retained coupling permits activating the left, the right or both together, the
  released one only one side. Retaining and releasing have the same marginal realizations, while
  only retaining realizes both together (`Activation.same_marginals_lose_bundle`): marginal lists
  cannot certify joint preservation.
* **What C needs to see** (`Regimes`). As configurations of a frame whose claims are bundles, with
  the bundles realizing every claim living, retaining extends releasing
  (`Regimes.extension`): the released profiles are carried and a joint bundle is gained. The two
  agree on every marginal possibility (`Regimes.marginals_agree`), so no comparison read off a
  summary that marginals determine, comparing no summary with itself, satisfies C
  (`Regimes.no_comparison_through_marginals`, an instance of `Comparison.separates`); the joint
  description separates them (`Regimes.joint_separates`). Retaining the possibility does not
  force its realization: a retained history realizes only the left claim
  (`Regimes.possibility_not_realization`).
* **Joint enrichment under every classification.** The fresh joint possibility is a strict
  enrichment (`Regimes.joint_enrichment_strict`); retaining is above releasing under every
  classification of the fresh bundles, where it is decided whether the classification makes a
  fresh bundle basic (`Regimes.joint_enrichment_classified`).
-/

namespace Becoming

open Generative Lexical

section Bundles

variable {S S' A A' C : Type}

/-- One configuration of the region realizes every claim of the bundle. -/
def Jointly (F : Frame S A C) (here : S → Prop) (bundle : C → Prop) : Prop :=
  ∃ s, here s ∧ ∀ c, bundle c → F.realized s c

/-- Every configuration of the first region has one in the second realizing all it realizes. -/
def CarriesProfiles (F : Frame S A C) (here : S → Prop) (G : Frame S' A' C) (there : S' → Prop) :
    Prop :=
  ∀ s, here s → ∃ t, there t ∧ ∀ c, F.realized s c → G.realized t c

/-- Every bundle jointly realizable in the first region is jointly realizable in the second. -/
def PreservesBundles (F : Frame S A C) (here : S → Prop) (G : Frame S' A' C) (there : S' → Prop) :
    Prop :=
  ∀ bundle, Jointly F here bundle → Jointly G there bundle

variable {F : Frame S A C} {G : Frame S' A' C} {here : S → Prop} {there : S' → Prop}

/-- **Carrying whole profiles is preserving joint bundles.** The backward direction uses the whole
profile of one configuration, which that configuration itself realizes. -/
theorem carries_iff_preserves : CarriesProfiles F here G there ↔ PreservesBundles F here G there :=
  ⟨fun carries _ ⟨s, inHere, all⟩ => match carries s inHere with
    | ⟨t, inThere, keeps⟩ => ⟨t, inThere, fun c held => keeps c (all c held)⟩,
   fun preserves s inHere => preserves (F.realized s) ⟨s, inHere, fun _ held => held⟩⟩

/-- Carrying composes through the same intermediate configuration. -/
theorem CarriesProfiles.trans {S'' A'' : Type} {K : Frame S'' A'' C} {third : S'' → Prop}
    (first : CarriesProfiles F here G there) (second : CarriesProfiles G there K third) :
    CarriesProfiles F here K third :=
  fun s inHere => match first s inHere with
  | ⟨t, inThere, keeps⟩ => match second t inThere with
    | ⟨u, inThird, keeps'⟩ => ⟨u, inThird, fun c held => keeps' c (keeps c held)⟩

/-- A transport sending the region into the other and keeping every realization preserves
bundles. It is a sufficient certificate; no converse uniform map is claimed. -/
theorem preserves_of_transport (transport : S → S') (into : ∀ s, here s → there (transport s))
    (faithful : ∀ s c, here s → F.realized s c → G.realized (transport s) c) :
    PreservesBundles F here G there :=
  carries_iff_preserves.mp fun s inHere =>
    ⟨transport s, into s inHere, fun c held => faithful s c inHere held⟩

/-- **Closed under exact complements, carrying a profile admits no newly realized claim.**
Constructively this forbids an explicit witness of strict extension. -/
theorem no_new_of_complement (complement : C → C) {s : S} {t : S'} (inHere : here s)
    (inThere : there t)
    (closedHere : ∀ x, here x → ∀ c, F.realized x (complement c) ↔ ¬ F.realized x c)
    (closedThere : ∀ x, there x → ∀ c, G.realized x (complement c) ↔ ¬ G.realized x c)
    (keeps : ∀ c, F.realized s c → G.realized t c) :
    ¬ ∃ c, G.realized t c ∧ ¬ F.realized s c :=
  fun ⟨c, now, before⟩ =>
    (closedThere t inThere c).mp (keeps _ ((closedHere s inHere c).mpr before)) now

/-- **On reachable configurations, a step- and claim-preserving map preserves bundles.** -/
theorem Frame.map_preserves {S₂ : Type} (F : Frame S A C) (G : Frame S₂ A C) (q : S → S₂)
    (step : ∀ s a t, F.P.step s a t → G.P.step (q s) a (q t))
    (claim : ∀ s c, F.realized s c → G.realized (q s) c) (root : S) :
    PreservesBundles F (Reach F.P root) G (Reach G.P (q root)) :=
  preserves_of_transport q (fun _ reached => reached.map step) (fun s c _ held => claim s c held)

/-- **A map whose steps lift and whose claims reflect loses no bundle.** -/
theorem Frame.lift_reflects {S₂ : Type} (F : Frame S A C) (G : Frame S₂ A C) (q : S → S₂)
    (lift : ∀ s a r, G.P.step (q s) a r → ∃ t, F.P.step s a t ∧ q t = r)
    (claim : ∀ s c, G.realized (q s) c → F.realized s c) (root : S) :
    PreservesBundles G (Reach G.P (q root)) F (Reach F.P root)
  | _, ⟨_, reached, all⟩ => match Reach.lift lift reached with
    | ⟨t, path, same⟩ => ⟨t, path, fun c held => claim t c (same ▸ all c held)⟩

/-- **Complement-closed claims admit no extension within a region.** Where each claim's complement
is realized exactly where the claim is not, at every configuration of a region (for example those
reachable from a root), no configuration of the region generatively extends another, whatever
counts as living. From the join `ReachableFrames`, stated for any region. -/
theorem complement_closed_no_extension (F : Frame S A C) (here : S → Prop) (complement : C → C)
    (closed : ∀ x, here x → ∀ c, F.realized x (complement c) ↔ ¬ F.realized x c)
    (living : C → Prop) {s t : S} (inS : here s) (inT : here t) : ¬ Extension F living s t
  | ⟨keeps, c, _, now, before⟩ =>
    no_new_of_complement (G := F) complement inS inT closed closed keeps ⟨c, now, before⟩

end Bundles

namespace Activation

/-- The configurations of one activation law: positions in one configuration, not agents. -/
inductive Configuration where
  | initial | coupled | released | leftActive | rightActive | bothActive

inductive Event where
  | retain | release | activateLeft | activateRight | activateTogether

/-- The supplied event law: retaining or releasing the coupling, then activation. -/
inductive Step : Configuration → Event → Configuration → Prop where
  | retainCoupling : Step .initial .retain .coupled
  | releaseCoupling : Step .initial .release .released
  | activateLeftCoupled : Step .coupled .activateLeft .leftActive
  | activateRightCoupled : Step .coupled .activateRight .rightActive
  | activateTogether : Step .coupled .activateTogether .bothActive
  | activateLeftReleased : Step .released .activateLeft .leftActive
  | activateRightReleased : Step .released .activateRight .rightActive

/-- The activation law as a process. -/
def law : Process Configuration Event := ⟨Step⟩

/-- A complete history: two steps from the initial configuration. -/
structure TwoSteps where
  first : Event
  middle : Configuration
  second : Event
  final : Configuration

def Admissible (h : TwoSteps) : Prop :=
  Step .initial h.first h.middle ∧ Step h.middle h.second h.final

inductive Claim where
  | leftRealized | rightRealized

def realized (h : TwoSteps) : Claim → Prop
  | .leftRealized => h.final = .leftActive ∨ h.final = .bothActive
  | .rightRealized => h.final = .rightActive ∨ h.final = .bothActive

/-- Complete histories as the configurations of a frame with no moves. -/
def frame : Frame TwoSteps Unit Claim := ⟨Witnesses.halted _ _, realized⟩

/-- The histories that retain, and those that release, the coupling. -/
def retained (h : TwoSteps) : Prop := Admissible h ∧ h.first = .retain
def released (h : TwoSteps) : Prop := Admissible h ∧ h.first = .release

def together : TwoSteps := ⟨.retain, .coupled, .activateTogether, .bothActive⟩
def leftOnly : TwoSteps := ⟨.release, .released, .activateLeft, .leftActive⟩
def rightOnly : TwoSteps := ⟨.release, .released, .activateRight, .rightActive⟩
def retainedLeft : TwoSteps := ⟨.retain, .coupled, .activateLeft, .leftActive⟩

theorem together_retained : retained together := ⟨⟨.retainCoupling, .activateTogether⟩, rfl⟩

theorem together_all : ∀ c, realized together c
  | .leftRealized => .inr rfl
  | .rightRealized => .inr rfl

/-- After releasing, no history realizes both claims. -/
theorem released_not_both {h : TwoSteps} (inReleased : released h)
    (both : ∀ c, realized h c) : False := by
  obtain ⟨first, middle, second, final⟩ := h
  obtain ⟨⟨firstStep, secondStep⟩, isRelease⟩ := inReleased
  cases isRelease
  cases firstStep
  cases secondStep
  · exact (both .rightRealized).elim (fun e => Configuration.noConfusion e)
      (fun e => Configuration.noConfusion e)
  · exact (both .leftRealized).elim (fun e => Configuration.noConfusion e)
      (fun e => Configuration.noConfusion e)

/-- **The same marginal realizations can lose a joint bundle**: retaining and releasing realize
each claim somewhere, and only retaining realizes both together. -/
theorem same_marginals_lose_bundle :
    (∀ c, (∃ h, retained h ∧ realized h c) ↔ (∃ h, released h ∧ realized h c)) ∧
      Jointly frame retained (fun _ => True) ∧ ¬ Jointly frame released (fun _ => True) :=
  ⟨fun c => ⟨fun _ => match c with
      | .leftRealized => ⟨leftOnly, ⟨⟨.releaseCoupling, .activateLeftReleased⟩, rfl⟩, .inl rfl⟩
      | .rightRealized => ⟨rightOnly, ⟨⟨.releaseCoupling, .activateRightReleased⟩, rfl⟩, .inl rfl⟩,
    fun _ => ⟨together, together_retained, together_all c⟩⟩,
   ⟨together, together_retained, fun c _ => together_all c⟩,
   fun ⟨_, inReleased, all⟩ => released_not_both inReleased fun c => all c True.intro⟩

/-- A retained history realizing only the left claim. -/
theorem retainedLeft_only :
    retained retainedLeft ∧ realized retainedLeft .leftRealized ∧
      ¬ realized retainedLeft .rightRealized :=
  ⟨⟨⟨.retainCoupling, .activateLeftCoupled⟩, rfl⟩, .inl rfl,
   fun held => held.elim (fun e => Configuration.noConfusion e)
     (fun e => Configuration.noConfusion e)⟩

/-! ### The histories as traces of the law

From the join `CouplingHistoryFrames`: the law with the claims realized at each configuration is
one frame, and its admissible histories are its two-step traces from the initial
configuration. -/

/-- The claims realized at a configuration. -/
def realizedAt (s : Configuration) : Claim → Prop
  | .leftRealized => s = .leftActive ∨ s = .bothActive
  | .rightRealized => s = .rightActive ∨ s = .bothActive

/-- The activation law with the claims realized at each configuration. -/
def lawFrame : Frame Configuration Event Claim := ⟨law, realizedAt⟩

/-- **A history realizes exactly the claims the frame realizes at its final configuration.** -/
theorem twoSteps_meaning (h : TwoSteps) : ∀ c, realized h c ↔ lawFrame.realized h.final c
  | .leftRealized => Iff.rfl
  | .rightRealized => Iff.rfl

/-- An admissible history is a two-step trace of the law from the initial configuration. -/
theorem admissible_trace {h : TwoSteps} (admissible : Admissible h) :
    Trace lawFrame.P .initial [h.first, h.second] h.final :=
  .cons admissible.1 (.cons admissible.2 (.nil _))

/-- Every two-step trace of the law from the initial configuration is an admissible history
through some middle configuration. -/
theorem trace_admissible {first second : Event} {final : Configuration}
    (trace : Trace lawFrame.P .initial [first, second] final) :
    ∃ middle, Admissible ⟨first, middle, second, final⟩ :=
  match trace_cons_iff.mp trace with
  | ⟨middle, step, rest⟩ => ⟨middle, step, trace_singleton_iff.mp rest⟩

/-- **Retaining the coupling does not force joint activation.** Some trace from the initial
configuration beginning with retaining ends where every claim is realized, and the trace
retaining then activating the left ends where the left claim is realized and the right is
not. -/
theorem retained_left_only :
    (∃ second final, Trace lawFrame.P .initial [.retain, second] final ∧
      ∀ c, lawFrame.realized final c) ∧
    Trace lawFrame.P .initial [.retain, .activateLeft] .leftActive ∧
    lawFrame.realized .leftActive .leftRealized ∧
      ¬ lawFrame.realized .leftActive .rightRealized :=
  ⟨⟨.activateTogether, .bothActive, admissible_trace (h := together) together_retained.1,
     fun c => (twoSteps_meaning together c).mp (together_all c)⟩,
   admissible_trace (h := retainedLeft) retainedLeft_only.1.1,
   (twoSteps_meaning retainedLeft _).mp retainedLeft_only.2.1,
   fun right => retainedLeft_only.2.2 ((twoSteps_meaning retainedLeft _).mpr right)⟩

/-- **The joint content of the law is the configuration with both active**: a configuration
realizing both claims is `bothActive`. From the bridge's reading of the law. -/
theorem joint_content_both {s : Configuration} (content : ∀ c, realizedAt s c) :
    s = .bothActive :=
  match content .leftRealized, content .rightRealized with
  | .inl left, .inl right => Configuration.noConfusion (left.symm.trans right)
  | _, .inr both => both
  | .inr both, _ => both

/-- Configurations past the release: released, or one side active. -/
def PastRelease (s : Configuration) : Prop :=
  s = .released ∨ s = .leftActive ∨ s = .rightActive

/-- A step keeps a configuration past the release. -/
theorem PastRelease.step {s m : Configuration} {a : Event} (step : Step s a m)
    (past : PastRelease s) : PastRelease m :=
  match step, past with
  | .retainCoupling, .inl e => Configuration.noConfusion e
  | .retainCoupling, .inr (.inl e) => Configuration.noConfusion e
  | .retainCoupling, .inr (.inr e) => Configuration.noConfusion e
  | .releaseCoupling, .inl e => Configuration.noConfusion e
  | .releaseCoupling, .inr (.inl e) => Configuration.noConfusion e
  | .releaseCoupling, .inr (.inr e) => Configuration.noConfusion e
  | .activateLeftCoupled, .inl e => Configuration.noConfusion e
  | .activateLeftCoupled, .inr (.inl e) => Configuration.noConfusion e
  | .activateLeftCoupled, .inr (.inr e) => Configuration.noConfusion e
  | .activateRightCoupled, .inl e => Configuration.noConfusion e
  | .activateRightCoupled, .inr (.inl e) => Configuration.noConfusion e
  | .activateRightCoupled, .inr (.inr e) => Configuration.noConfusion e
  | .activateTogether, .inl e => Configuration.noConfusion e
  | .activateTogether, .inr (.inl e) => Configuration.noConfusion e
  | .activateTogether, .inr (.inr e) => Configuration.noConfusion e
  | .activateLeftReleased, _ => .inr (.inl rfl)
  | .activateRightReleased, _ => .inr (.inr rfl)

/-- **Every trace of the law keeps a configuration past the release.** -/
theorem PastRelease.trace : ∀ {s t : Configuration} {word : List Event},
    Trace law s word t → PastRelease s → PastRelease t
  | _, _, _, .nil _, past => past
  | _, _, _, .cons step path, past => PastRelease.trace path (PastRelease.step step past)

/-- Both active is not past the release. -/
theorem PastRelease.not_both : ¬ PastRelease .bothActive
  | .inl e => Configuration.noConfusion e
  | .inr (.inl e) => Configuration.noConfusion e
  | .inr (.inr e) => Configuration.noConfusion e

/-- **After the release no trace reaches the joint content.** -/
theorem PastRelease.no_joint {s t : Configuration} {word : List Event} (past : PastRelease s)
    (path : Trace law s word t) : ¬ ∀ c, realizedAt t c :=
  fun content => PastRelease.not_both
    (Eq.subst (motive := PastRelease) (joint_content_both content) (PastRelease.trace path past))

end Activation

namespace Regimes

open Activation

inductive Regime where
  | released | retained

def histories : Regime → TwoSteps → Prop
  | .released => Activation.released
  | .retained => Activation.retained

/-- Some history of the regime realizes the claim. -/
def marginal (r : Regime) (c : Claim) : Prop := ∃ h, histories r h ∧ realized h c

/-- The bundle of every claim. -/
def allBundle (_ : Claim) : Prop := True

/-- A bundle is living where it holds every claim: the joint possibility. -/
def living (bundle : Claim → Prop) : Prop := ∀ c, bundle c

/-- The regimes as configurations of a frame with no moves, realizing the bundles jointly
realizable under them. It records possible joint realization, not actual realization. -/
def frame : Frame Regime Unit (Claim → Prop) :=
  ⟨Witnesses.halted _ _, fun r bundle => Jointly Activation.frame (histories r) bundle⟩

/-- Every released profile is carried under retaining, by one common history. -/
theorem released_carried :
    CarriesProfiles Activation.frame Activation.released Activation.frame Activation.retained :=
  fun _ _ => ⟨together, together_retained, fun c _ => together_all c⟩

/-- **Retaining extends releasing**: the released profiles are carried, and the joint bundle is
gained. -/
theorem extension : Extension frame living .released .retained :=
  ⟨carries_iff_preserves.mp released_carried, allBundle, fun _ => True.intro,
   same_marginals_lose_bundle.2.1, same_marginals_lose_bundle.2.2⟩

/-- **The marginals agree and the joint descriptions differ.** -/
theorem marginals_agree :
    (∀ c, marginal .released c ↔ marginal .retained c) ∧ frame.realized .retained allBundle ∧
      ¬ frame.realized .released allBundle :=
  ⟨fun c => (same_marginals_lose_bundle.1 c).symm, same_marginals_lose_bundle.2.1,
   same_marginals_lose_bundle.2.2⟩

/-- **No comparison read off marginals satisfies C**: where identical marginals give identical
summaries, no comparison of summaries comparing none with itself satisfies C, by
`Comparison.separates`. This is an obstruction of information conditional on C: it says what a
comparison satisfying C must tell apart, and requires C of no comparison. -/
theorem no_comparison_through_marginals {Summary : Type} (summary : Regime → Summary)
    (determines : ∀ a b, (∀ c, marginal a c ↔ marginal b c) → summary a = summary b)
    (compare : Summary → Summary → Prop) (irreflexive : ∀ s, ¬ compare s s) :
    ¬ Comparison frame living fun a b => compare (summary a) (summary b) :=
  fun comparison => Comparison.separates irreflexive comparison extension
    (determines _ _ marginals_agree.1)

/-- **The joint description separates the regimes.** -/
theorem joint_separates :
    (fun bundle => frame.realized .released bundle) ≠ (fun bundle => frame.realized .retained bundle) :=
  fun same => marginals_agree.2.2
    (Eq.mp (congrFun same allBundle).symm marginals_agree.2.1)

/-- **Retaining the possibility does not force its realization.** -/
theorem possibility_not_realization :
    retained retainedLeft ∧ realized retainedLeft .leftRealized ∧
      ¬ realized retainedLeft .rightRealized ∧ frame.realized .retained allBundle :=
  ⟨retainedLeft_only.1, retainedLeft_only.2.1, retainedLeft_only.2.2, marginals_agree.2.1⟩

/-- The fresh joint possibilities of a regime: living bundles jointly realizable under it. -/
def freshJoint (r : Regime) (bundle : Claim → Prop) : Prop :=
  living bundle ∧ frame.realized r bundle

/-- **The joint enrichment is strict.** -/
theorem joint_enrichment_strict : StrictIncluded (freshJoint .released) (freshJoint .retained) :=
  ⟨fun bundle held => ⟨held.1, extension.1 bundle held.2⟩,
   fun back => same_marginals_lose_bundle.2.2
     (back allBundle ⟨fun _ => True.intro, same_marginals_lose_bundle.2.1⟩).2⟩

/-- No fresh joint possibility under releasing. -/
theorem no_fresh_released (bundle : Claim → Prop) : ¬ freshJoint .released bundle :=
  fun ⟨alive, ⟨_, inReleased, all⟩⟩ => released_not_both inReleased fun c => all c (alive c)

/-- **Retaining is above releasing under every classification of the fresh bundles**, with no
basic or gain content otherwise, where it is decided whether the classification makes a fresh
bundle basic. The event law supplies neither the basic/gain reading nor that the real losses are
represented. -/
theorem joint_enrichment_classified (q : (Claim → Prop) → Prop)
    (tie : Decided (∀ bundle, freshJoint .retained bundle → q bundle → freshJoint .released bundle)) :
    classified (fun (_ : Regime) (_ : Unit) => True) (fun (_ : Regime) (_ : Unit) => False)
      freshJoint q .retained .released :=
  classified_of_fresh (a := Regime.retained) (b := Regime.released) (fun _ held => held) (fun _ held => held) (fun _ held => held)
    joint_enrichment_strict q (fun bundle => .inr (no_fresh_released bundle)) tie

end Regimes

end Becoming
