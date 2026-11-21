# JointCorrespondence

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/JointCorrespondence.lean`
- *result records that name this place's file as a source* (computed; not a link): `code-plan-global-support`, `joint-code-plan-lifting`, `joint-decomposition-lifting`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-08, as "JointCorrespondence.lean: JointBisimulation.reach, SameJointTests.correspondence, JointPlan.realizes_code_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-08.md.txt)); pass b: reader whole-b-31, as "JointCorrespondence.lean: JointFrame.Reach, JointBisimulation.reach, SameJointTests.joint_iff, SameJointTests.step_iff, SameJointTests.correspondence, liftsFromEach_of_exact, JointPlan.realizes_code_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-31.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: Two joint frames with compact steps and pairs, stable separating tests, and every configuration reachable from matching roots have a unique test match for each configuration in either direction (SameJointTests.correspondence, l. 123). For compact pairs and stable tests, exact reduced codes with correct leaf readings preserve and reflect realization of each joint plan (JointPlan.realizes_code_iff, l. 167).
  - *pass b:* The module gives general laws for any two joint frames (a process with a ternary relation of whole and parts). A joint bisimulation matches what each frame reaches by steps and parts. Under compactness, stable tests and configurations told apart by the tests, the joint tests carry pairs of parts and steps exactly and match reachable configurations one to one; a code reading the joint tests exactly lets parts lift and realizes plans exactly where the configurations do. There is no built model.
- **moves**
  - *pass a:* S: SameJointTests.step_iff (l. 107) preserves each action's transition between test-matched endpoints under step compactness and stable separating tests in both frames. JointPlan.supports_of_code (l. 178) gives support for a realized coded plan given correct leaves, within/apart footprints, compact pairs and stable, exact, reduced readings.
  - *pass b:* S: `SameJointTests.step_iff` (l. 107): under compact moves, stable and separating tests, for every move a, a step holds in one frame exactly where the matched step holds in the other. N: no law about what some choice or every choice keeps.
- **a reading**
  - *pass a:* S: SameJointTests.joint_iff (l. 86) determines whether a matched whole holds a matched pair when both frames have compact pairs and stable separating joint tests.
  - *pass b:* S: `SameJointTests.correspondence` (l. 123): roots passing the same joint tests make the reachable configurations correspond one to one. `liftsFromEach_of_exact` (l. 150): a code reading the joint tests exactly and reduced lets parts lift from each configuration it describes. `JointPlan.realizes_code_iff` (l. 167): a code realizes a plan exactly where each configuration it describes does. `JointPlan.supports_of_code` (l. 178).
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a comparison between two**
  - *pass a:* S: JointBisimulation.reach (l. 51) matches each configuration reachable by steps and taking parts from one root with a related configuration reachable from the related root.
  - *pass b:* S: `JointBisimulation.reach` (l. 51): from related roots, each configuration one frame reaches is related to one the other reaches. `SameJointTests.joint_iff` (l. 86) and `step_iff` (l. 107) carry pairs of parts and steps exactly. `SameJointTests.inverse_functional` (l. 78).
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a closed region**
  - *pass a:* S: JointFrame.Reach (l. 43) generates a region from the root closed under process steps and passage to either held part.
  - *pass b:* S: `JointFrame.Reach` (l. 43) is defined as the least set containing the root and closed under steps and under taking either part. The only law about it is its carrying under bisimulation (l. 51). N: no invariant or kernel law.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. General statements support states, moves, reading, comparison, closed_region. I found no matching statement for share, level, giving, cost, multiplying, no_return, both_outcomes, rank, forms_change. No answer rests on prose alone or was unreached.
  - *pass b:* All answered from statements. Read whole (191 lines, all statements).
