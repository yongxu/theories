# Composition

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Composition.lean`
- *result records that name this place's file as a source* (computed; not a link): `code-plan-global-support`, `exclusive-footprint-support`, `joint-code-plan-lifting`, `joint-decomposition-lifting`, `joint-target-uniqueness`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-02, as "Composition.lean: jointAlike_iff_sameJointTests, SameJointTests.step, JointPlan.plans_lift_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-02.md.txt)); pass b: reader whole-b-06, as "Composition.lean: JointFrame, JointAlike, SameJointTests, jointAlike_iff_sameJointTests, matchesParts_of_compact_iff_em, jointAlike_of_sameJointTests_iff_em, liftsFromEach_iff, JointPlan.realizes_image_iff, JointPlan.plans_lift_iff, JointPlan.supports_of_image" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-06.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `jointAlike_iff_sameJointTests` (l. 374) equates joint likeness with passing the same joint tests when both frames have compact outcomes and pairs of parts and stable tests. `JointPlan.plans_lift_iff` (l. 679) characterizes lifting every nested plan by matching parts between states with equal descriptions.
  - *pass b:* For every joint frame (a frame with a relation joint s l r: s holds l and r together as parts), if both frames' moves and pairs of parts are compact and their tests stable, configurations are jointly alike exactly when they pass the same joint tests (jointAlike_iff_sameJointTests, l. 374). Dropping stability needs exactly excluded middle (matchesParts_of_compact_iff_em, l. 554; jointAlike_of_sameJointTests_iff_em, l. 567). Further general laws: parts read through a description lift exactly when the configurations it identifies match parts (liftsFromEach_iff, l. 598), and nested plans are realized at a description exactly when they are realized at every configuration it describes (JointPlan.realizes_image_iff, l. 645; plans_lift_iff, l. 679). Built: Pairing, DoubleNegation, Unjoined.
- **moves**
  - *pass a:* S: `SameJointTests.step` (l. 309) matches any given action and successor in the other frame with a same-test successor, given equal tests at the starts, compact target outcomes and stable tests at the source successor.
  - *pass b:* S: a JointFrame extends a Frame with a Process (F.P.step s a t). SameJointTests.step_passing (l. 299): where the other's move outcomes are compact, each step is matched by a step of the other into a configuration passing every joint test the outcome passes. sameJointTests_bisimulation (l. 357) matches each step both ways. No law says what a choice keeps.
- **a reading**
  - *pass a:* S: `liftsFromEach_iff` (l. 598) equates lifting described parts from every representative with matching parts across equal descriptions.
  - *pass b:* S: a description π reads the joint relation (jointImage, l. 588). liftsFromEach_iff (l. 598): parts read at a description lift from every configuration so described exactly when configurations π identifies match parts into configurations π identifies. IdentifiesJointAlike.lifts (l. 622): with no premise, where π identifies exactly the jointly alike configurations. JointPlan.realizes_image_iff (l. 645): with matching and correct leaf reading, π realizes a plan exactly when every configuration π describes does. S: jointAlike_iff_sameJointTests (l. 374): under compactness and stability, the joint tests passed decide joint likeness.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: footprints (PartsWithin, PartsApart, Supports, from JointPlans) are exclusive sets of resources drawn on. They carry no amount that runs down. JointPlan.supports_of_image (l. 706): a plan realized at a description has leaves whose draws repeat nothing and lie within each described root's footprint.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: the iff laws (l. 374, l. 554, l. 567, l. 598, l. 679) concern likeness, tests and parts, not going on and ending.
- **a comparison between two**
  - *pass a:* S: `sameJointTests_bisimulation` (l. 357) gives a joint bisimulation between the frames under step and pair compactness and test stability on both sides.
  - *pass b:* S: JointBisimulation (l. 161): a bisimulation between two joint frames F, G that also matches parts. sameJointTests_bisimulation (l. 357) and jointAlike_iff_sameJointTests (l. 374) carry between the two frames. SameJointTests.parts_passing (l. 320): a pair of parts in one frame is matched by a pair in the other, each passing every test its counterpart passes, where pairs are compact. B: Pairing.not_jointAlike (l. 204): two configurations alike with parts forgotten are not jointly alike.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statement answers cover states, moves, reading, comparison. I reached all fourteen questions.
  - *pass b:* All statements and docstrings read (whole file, including the JointPlanFrames section). Answered from statements: states, moves, reading, comparison. Level has an S part about footprints. The rest are N.
