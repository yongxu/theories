# Joining

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Joining.lean`
- *result records that name this place's file as a source* (computed; not a link): `finite-joining-tree-lifting`, `functional-joining-common-structure`, `incidence-common-refinement`, `joining-open-map-factor`, `joining-questions-survive-encoding`, `multivalued-joining-common-structure`, `retained-reference-joining-recovery`, `unanchored-incidence-collapse`, `wisdom-root`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-08, as "Joining.lean: lifts_iff, common_refinement, retained_extends, retained_self_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-08.md.txt)); pass b: reader whole-b-30, as "Joining.lean: lifts_iff, holds_image_iff, tree_lifts, common_structure, openMap_iff, common_refinement, universal_factor, RoleTotal.collapse, retained_history_matches, retained_codes_apart, Once" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-30.md.txt)); the third pass, where the two differed: reader whole-c-settle-11, as "Joining.lean: settled fields no_return" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-11.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: For any joining and code, lifting joins at the actual inputs is equivalent to code equality being a bisimulation of the partner frame (lifts_iff, l. 252). Two joinings with role-alike roots covering their respective fragments have a common refinement with open, surjective projections (common_refinement, l. 712).
  - *pass b:* For every joining (a ternary relation `Joining F`) read through a description, the description lifts the joining exactly where having one code is a bisimulation of the partner frame (`lifts_iff`). Where it lifts, trees and branching tests survive (`tree_lifts`, `holds_image_iff`). Read through roles, open maps of joinings are the open maps of role frames (`openMap_iff`), two joinings with alike connecting roots have a common refinement (`common_refinement`), and open maps factor uniquely (`universal_factor`); read through retained references, alike configurations match every course of formation (`retained_history_matches`). All general; `Once` is a built witness that roles hide what retained references keep.
- **moves**
  - *pass a:* S: retained_extends (l. 864) says every trace of slot-pair choices keeps its starting list as a prefix, appending one result for each command.
  - *pass b:* S: `Joining.frame` (l. 187): a fragment moves by joining a partner `withLeft p` or `withRight p` to what they join into; `retainedFrame` (l. 858): a move names two slots and appends what they join into. `retained_history_matches` (l. 877): alike retained configurations of equally many slots match every course of formation with the same moves, ending alike, keeping the slots aligned. `alike_substitute` (l. 226): a joining of a and b into z is matched for alike inputs by a joining into a fragment alike to z.
- **a reading**
  - *pass a:* S: retained_self_iff (l. 895) tests self-joinability with one reference used twice. B: Once.roles_alike and Once.retained_apart (ll. 1003, 1016) equate start and passage through roles but separate them through retained tests.
  - *pass b:* S: `image` (l. 237) reads a joining through a description π. `lifts_iff` (l. 252): `J.Lifts π ↔ Bisimulation J.frame J.frame (π x = π y)`. `holds_image_iff` (l. 434): where π lifts J, a branching test with partners read through π holds at the code exactly where it holds at the fragment. `RoleTotal.collapse` (l. 789): where every fragment takes every role and some fragment cannot join itself, the one-code description identifies exactly the fragments alike in roles, the one-fragment joining self-joins, and that fragment does not. `retained_codes_apart` (l. 913): every description whose equal codes pass the same retained tests gives a self-joining and a non-self-joining fragment different codes.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **multiplying**
  - *pass a:* S: retainedFrame and retained_extends (ll. 858, 864) let two existing slots form another fragment and retain all three references, with the number appended equal to the move count.
  - *pass b:* S: `retained_extends` (l. 864): along every course of the retained frame, the configuration is the start with exactly one added fragment per move (`added.length = cmds.length`). Fragments join into fragments, but no units leave units and no count of kinds changes by a law of the step.
- **a point of no return**
  - *settled by the third pass:* S (weaker than the yes side said): `retained_extends` (l. 864): for every `J : Joining F` and every `Trace J.retainedFrame.P xs cmds ys`, `∃ added, ys = xs ++ added ∧ added.length = cmds.length`; concluded, with no premise beyond the trace. It states that the configuration is only extended, one fragment per move; that no course returns to `xs` or to a shorter list follows but is not stated, and nothing is lost, so there is no 'once lost not regained' and no point from which no course keeps something. `Once.passage_alone` (l. 999) states only `¬ joining.SelfJoinable .passage`. [which pass was right: both in part; opened: retainedFrame l.858; retained_extends l.864; retained_history_matches l.877; Once.Piece l.967; Once.Joins l.974; Once.passage_alone l.999; Once.retained_apart l.1016]
  - *pass a:* S: retained_extends (l. 864) concludes an append-only history on every retained trace, excluding return to a shorter list.
  - *pass b:* N: no irreversibility law. B: `Once` (l. 963-1020) is docstringed as a process that can make one passage and no more; its statement `passage_alone` (l. 999) says only that the passage cannot join with itself.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no exactly-when of going on and ending or keeping and losing. S: the exactly-whens are about lifting and likeness: `lifts_iff` (l. 252), `openMap_iff` (l. 125, 607), `FiniteOutcomes.alike_iff_sameBranchingTests` (l. 349, under the named `em`).
- **a comparison between two**
  - *pass a:* S: retained_history_matches (l. 877) matches every trace from alike, equal-length retained starts with the same commands, alike endpoints and equal final lengths.
  - *pass b:* S: `OpenMap` (l. 120) and `openMap_iff` (l. 125), `OpenMap.alike_iff` (l. 144, keeps and reflects likeness), `OpenMap.comp` (l. 150); `Joining.openMap_iff` (l. 607); `common_structure` (l. 309) and `aligned_image_iff` (l. 291), where two descriptions with one kernel carry one reading of the joining onto the other; `common_refinement` (l. 712, open projections of the span covering both joinings); `universal_factor` (l. 731); `retained_history_matches` (l. 877).
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a closed region**
  - *pass a:* S: retained_extends (l. 864) preserves the region of configurations extending a given prefix under all retained traces.
  - *pass b:* S: `bisimulation_iff_compatible` (l. 198): the bisimulations of a joining's frame are exactly the relations `Compatible` with it (closed under joining a partner on either side). This is a relation closed under steps; no invariant set of fragments or largest closed region of configurations is stated.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* S: retained_extends (l. 864) grows the available slots by one at each executed formation. It requires an actual trace and asserts no infinite trace.
  - *pass b:* S: `retained_extends` (l. 864): a retained configuration keeps every fragment formed and is extended by one each move, which is accumulation rather than forms coming and going. B: `Once.Joins` (l. 974): start joins passage into passage, and passage joins finish into passage. N: no statement that a going on continues while what is present changes.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. General statements support states, moves, reading, multiplying, no_return, comparison, closed_region, forms_change. Built cases support reading. I found no matching statement for share, level, giving, cost, both_outcomes, rank. No answer rests on prose alone or was unreached.
  - *pass b:* All fourteen answered from statements (with Once as built). Lines 1-260 and 960-990 read in full; every other statement and docstring read up to `:=`, without proof bodies.
