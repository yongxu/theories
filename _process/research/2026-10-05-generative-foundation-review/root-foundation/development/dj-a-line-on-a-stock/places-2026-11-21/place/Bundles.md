# Bundles

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Bundles.lean`
- *result records that name this place's file as a source* (computed; not a link): `becoming-spine-instances`, `classification-robust-generative-comparison`, `effective-capacity-and-eventual-reachability`, `positive-ground-open-futures`, `relational-generative-comparison`, `what-a-course-keeps-reachable`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-01, as "Bundles.lean: carries_iff_preserves, Activation.same_marginals_lose_bundle, Activation.PastRelease.no_joint, Regimes.extension" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-01.md.txt)); pass b: reader whole-b-03, as "Bundles.lean: Jointly, CarriesProfiles, PreservesBundles, carries_iff_preserves, Frame.map_preserves, complement_closed_no_extension, Activation.same_marginals_lose_bundle, Activation.PastRelease.no_joint, Regimes.extension, Regimes.no_comparison_through_marginals, Regimes.joint_enrichment_strict" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-03.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* For any two frame regions, carrying every configuration's whole profile is equivalent to preserving every jointly realizable bundle (`carries_iff_preserves`, l. 78). In the activation law, retain and release have the same marginal possibilities and only retain permits joint realization (`same_marginals_lose_bundle`, l. 209).
  - *pass b:* S: General for regions of any frames' configurations. Carrying whole profiles is preserving jointly realizable bundles (`carries_iff_preserves` l.78), and carrying composes (l.84). Transports and step- and claim-preserving maps preserve bundles (l.93, l.111), and maps whose steps lift and claims reflect lose none (l.118). Complement-closed claims admit no extension within a region (l.129). B: in the built Activation law, retaining and releasing a coupling have the same marginal realizations while only retaining realizes both claims together (`same_marginals_lose_bundle` l.209), and after the release no trace reaches the joint content (`PastRelease.no_joint` l.323). In Regimes, no comparison read off marginals satisfies C (l.377).
- **moves**
  - *pass a:* B: `retained_left_only` (l. 263) gives both a joint trace beginning with retain and a retain-then-left trace realizing only the left claim.
  - *pass b:* S: `Frame.map_preserves` (l.111): a map preserving steps and claims preserves the bundles of configurations reachable from a root. `Frame.lift_reflects` (l.118). B: `Activation.law` (l.157) is a process with moves retain, release and activate. `Activation.retained_left_only` (l.263): after retaining, one choice of second move realizes both claims and another only the left. `Activation.PastRelease.trace` (l.311): every trace keeps a configuration past the release.
- **a reading**
  - *pass a:* B: `Regimes.no_comparison_through_marginals` (l. 377) excludes any irreflexive comparison satisfying Comparison through a summary determined by marginal agreement.
  - *pass b:* S: `F.realized` claims, and `no_new_of_complement` (l.101): closed under exact complements, carrying a profile admits no newly realized claim. B: `Regimes.no_comparison_through_marginals` (l.377), for any summary of the two built regimes that identical marginals make identical: no irreflexive comparison of summaries satisfies C, so the marginals registered cannot decide it. `Regimes.joint_separates` (l.385).
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a giving that is itself a going-on**
  - *pass a:* B: `Activation.Step` (l. 147) models the coupling as retained or released; only coupled has an activateTogether step.
  - *pass b:* B: in `Activation`, the joint content `bothActive` is reached only from `.coupled` (`joint_content_both` l.277). After the release no trace reaches it (`PastRelease.no_joint` l.323), so the coupling that permits joint activation is a configuration of the built law that can be lost, not a premise handed in.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a point of no return**
  - *pass a:* B: `PastRelease.no_joint` (l. 323) concludes no trace from a PastRelease state reaches jointly realized content.
  - *pass b:* B, concluded: `Activation.PastRelease.trace` (l.311) and `PastRelease.no_joint` (l.323): once past the release, every trace stays past the release and never reaches the configuration realizing both claims. This is at the loss of the coupling.
- **both outcomes**
  - *pass a:* B: `same_marginals_lose_bundle` (l. 209) proves joint feasibility under retention and its loss under release for the same activation model.
  - *pass b:* B: `Activation.same_marginals_lose_bundle` (l.209): from one initial configuration, retaining realizes the joint bundle and releasing does not, with the same marginals. `Regimes.marginals_agree` (l.367). N: no general exactly-when.
- **a comparison between two**
  - *pass a:* S: `Frame.map_preserves` (l. 111) carries reachable bundles along a step- and claim-preserving map; `Frame.lift_reflects` (l. 118) carries them back when steps lift and claims reflect.
  - *pass b:* S: `carries_iff_preserves` (l.78), `CarriesProfiles.trans` (l.84), `preserves_of_transport` (l.93), `Frame.map_preserves` (l.111) and `Frame.lift_reflects` (l.118) carry profiles and bundles between two regions or frames. B: `Regimes.extension` (l.362): retaining extends releasing. `Regimes.joint_enrichment_strict` (l.401), `Regimes.joint_enrichment_classified` (l.414).
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a closed region**
  - *pass a:* B: `PastRelease.step` (l. 289) proves the released and one-sided states form a step-closed region.
  - *pass b:* B: `Activation.PastRelease` (l.285) is a region of the built law closed under steps (`PastRelease.step` l.289, `PastRelease.trace` l.311).
- **forms change while the going on continues, or more can go on after**
  - *pass a:* B: `Regimes.joint_enrichment_strict` (l. 401) proves strict inclusion of fresh joint possibilities for retained over released.
  - *pass b:* B: `Regimes.extension` (l.362) and `Regimes.joint_enrichment_strict` (l.401): under retaining, the fresh joint possibilities strictly include those under releasing, so more is possible after. `Regimes.possibility_not_realization` (l.391): retaining the possibility does not force its realization.
- **how it was read**
  - *pass a:* Read the opening account, all docstrings and all declaration statements. Statements support states and comparison. Built statements supply moves, reading, giving, no_return, both_outcomes, closed_region, forms_change. The remaining fields are N. None were unreached.
  - *pass b:* Statements and docstrings read in full (l.423). Answers come from statements and the Activation and Regimes built cases.

## 22 November, the third pass on an exact edge between both outcomes: reader whole-c-edge2-02

*As "Bundles.lean: the edge". A reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md), [report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-edge2-02.md.txt).*

- **an exact statement of both outcomes**: B. `Activation.same_marginals_lose_bundle` (l.209, no premises): `(∀ c, (∃ h, retained h ∧ realized h c) ↔ (∃ h, released h ∧ realized h c)) ∧ Jointly frame retained (fun _ => True) ∧ ¬ Jointly frame released (fun _ => True)`. On traces its two halves are `retained_left_only` (l.263): some trace `[.retain, second]` from `.initial` ends where every claim is realized, and `PastRelease.no_joint` (l.323): from any `PastRelease s` no trace of `law` reaches a t with every claim realized. The condition is the first event (retain or release) of one built law; no general exactly-when, and no iff over all configurations.
- **the side that keeps**: The region closed under the step is on the LOSING side: `PastRelease` (l.285), kept by every `Step` (`PastRelease.step` l.289) and every trace (`PastRelease.trace` l.311). On the keeping side the statement only asserts that some history or trace realizes both (`Jointly frame retained`, l.209; l.263), and `retainedLeft_only` (l.220) shows retaining does not force it.
- **the side that ends**: N. Nothing is bounded and nothing falls. The loss is stated by the invariant: `PastRelease.no_joint` (l.323) with `PastRelease.not_both` (l.317). Histories are two steps by the type `TwoSteps` (l.160), not by a law.
- **moves in that statement**: B. Moves are `Event` of `Activation.law : Process Configuration Event` (l.157). `retained_left_only` (l.263) has `∃ second final` after `.retain` and a second trace `[.retain, .activateLeft]` that realizes only the left; `PastRelease.no_joint` (l.323) is for every `word : List Event`. The dividing choice is the first move.
- **a reading in that statement**: B. The first conjunct of l.209 says the marginal realizations of each claim are the same under retaining and releasing, so what the marginals register does not tell the two outcomes apart; the condition is on the first event, not on a reading. `Regimes.marginals_agree` (l.367) and `Regimes.no_comparison_through_marginals` (l.377) say this of any summary the marginals determine.
- **the carrier**: `Activation.law : Process Configuration Event` and `lawFrame : Frame Configuration Event Claim`; the histories as `Activation.frame : Frame TwoSteps Unit Claim` with no moves (`Witnesses.halted`); `Regimes.frame : Frame Regime Unit (Claim → Prop)`. The general part is on any `Frame S A C` with a region `here : S → Prop`.
- **what is handed in**: No level, giving, share or favouring: no amounts in the module. The event law `Step` (l.147) is supplied; the choice is the first event; that the marginals agree and the joint bundle is lost is concluded; no turn (no return from `PastRelease` is concluded, l.311).
- **links to other modules**: `Regimes.no_comparison_through_marginals` (l.377): `Comparison` (Extension), no comparison read off marginals satisfies C, an instance of `Comparison.separates`. `Regimes.extension` (l.362): `Extension frame living .released .retained`, an instance. `complement_closed_no_extension` (l.129): `¬ Extension F living s t` for any frame and region with complement-closed claims. `Frame.map_preserves` (l.111) and `Frame.lift_reflects` (l.118): `Reach F.P root` (Frame), bundles carried along a step-preserving or step-lifting map. `Regimes.joint_enrichment_classified` (l.414): `classified`, `Decided` (Lexical).
- **standing**: None seen. Opening account: "Every declaration has an empty axiom report; the periphery's proofs of the event law used `propext`" (said of the periphery, not of this module). `joint_enrichment_classified` (l.414) takes `Decided …` as a hypothesis.
- **note**: This is the one module of the batch with both outcomes, moves and what is registered in one statement, and it is a built six-configuration law. It runs against the pattern in a second way: the closed region is where the bundle is lost, and the keeping side has no closed region and no certificate, only an existing trace.
