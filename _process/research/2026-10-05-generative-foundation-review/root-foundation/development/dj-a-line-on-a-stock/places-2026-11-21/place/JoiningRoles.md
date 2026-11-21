# JoiningRoles

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/JoiningRoles.lean`
- *result records that name this place's file as a source* (computed; not a link): `incidence-common-refinement`, `joining-open-map-factor`, `retained-reference-joining-recovery`, `unanchored-incidence-collapse`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-08, as "JoiningRoles.lean: HasUnits.collapse, retained_step_extends, retained_pair_matches_of_em, once_roles_hide_ends" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-08.md.txt)); pass b: reader whole-b-31, as "JoiningRoles.lean: roleFrame_leave_holds, slots_sameBranchingTests, match_incident_of_em, retained_pair_matches_of_em, HasUnits.collapse, once_codes_apart" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-31.md.txt)); the third pass, where the two differed: reader whole-c-settle-11, as "JoiningRoles.lean: settled fields no_return, closed_region, forms_change" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-11.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: For any joining with local units the constant map to one fragment is open and each fragment passes the same role tests as its image (HasUnits.collapse, l. 151). B: On the process that moves once, role tests merge its two idle traces, probes distinguish their ends, and exact retained-test codes separate the start from the passage (Fragment.once_roles_hide_ends, l. 234, Fragment.once_codes_apart, l. 264).
  - *pass b:* The module gives general laws for any joining (a ternary relation on fragments) read through roles (roleFrame) and through retained references (retainedFrame). Occurrences that pass the same branching tests hold fragments that pass the same tests; under excluded middle, matches carry between two joinings; a joining with local units collapses, read through roles, onto the one fragment. Built cases on the traced fragments of the process `once` show that roles hide what retained references and probes tell apart.
- **moves**
  - *pass a:* S: retained_step_extends (l. 173) appends one fragment on every successful slot-pair move. Fragment.idle_self_retained (l. 248) permits the self-pair move for every idle trace of any process.
  - *pass b:* S: `placeMap_step` (l. 120): a map keeping a joining carries every step of the role frame (moves `RoleMove`, enter or leave a role) to a step of the other joining's role frame. N: no law about what some choice or every choice of move keeps.
- **a reading**
  - *pass a:* S: collapsed_exact (l. 161) makes a single code exact for role tests under HasUnits. B: Fragment.once_retained_apart (l. 254) distinguishes the traced passage from the coarse fragment by the retained self-join test.
  - *pass b:* S: `slots_sameBranchingTests` (l. 69): occurrences passing the same branching tests of roles hold fragments passing the same tests in every role. `collapsed_exact` (l. 161): where the joining has local units, one code reads every role test exactly. `once_codes_apart` (l. 264): every code reading the retained tests exactly gives the traced start and the traced passage different codes. B: `once_roles_hide_ends` (l. 234): two idle configurations pass the same role tests while the probes tell them apart. `once_roles_hide_failure` (l. 220): roles hide that the passage cannot join itself.
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
  - *pass a:* S: retained_pair_matches_of_em (l. 182) displays both input slots and the newly appended join result in each retained configuration for matching test readings, equal lengths, finite target outcomes and excluded middle.
  - *pass b:* S: `retained_step_extends` (l. 173): each move of retained references extends a configuration (a list) by exactly one fragment, formed by joining two listed ones. N: no law about how the number of a kind changes.
- **a point of no return**
  - *settled by the third pass:* S (weaker than the yes side said): `retained_step_extends` (l. 173): for every `J : Joining F`, `J.retainedFrame.P.step xs ij ys → ∃ z, ys = xs ++ [z]`; concluded from the step alone. It states that each move appends one fragment; that no step returns to the earlier list follows but is not stated, nothing is lost, and there is no point of no return. `Fragment.passageTrace_alone` (l. 215) states only `¬ (joining once).SelfJoinable passageTrace`, which is not an irreversibility. [which pass was right: both in part; opened: retained_step_extends l.173; retained_pair_matches_of_em l.182; Fragment.passageTrace l.212; Fragment.passageTrace_alone l.215; once_retained_apart l.254]
  - *pass a:* S: retained_step_extends (l. 173) concludes every actual step increases list length by one. B: Fragment.passageTrace_alone (l. 215) excludes joining the once-passage with itself.
  - *pass b:* N. (B: `passageTrace_alone` (l. 215), that the traced passage cannot join itself, is not an irreversibility.)
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a comparison between two**
  - *pass a:* S: placeMap_step (l. 120) carries each labeled role step along a joining-preserving map. retained_pair_matches_of_em (l. 182) preserves retained test agreement at extended lists under its matching hypotheses.
  - *pass b:* S: `match_incident_of_em` (l. 86): under excluded middle and local finiteness, an occurrence at a fragment of J is matched in K at a fragment passing the same tests. `covers_of_em` (l. 98): roots passing the same tests cover what they connect. `retained_pair_matches_of_em` (l. 182): a joined pair in one retained configuration is matched in any configuration passing the same tests with equally many slots. `placeMap_step` (l. 120). `factor_unique_of_ext` (l. 131): with extensionality, the factor of two open maps is unique.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a closed region**
  - *settled by the third pass:* S (weaker, and not stated as a region): `retained_step_extends` (l. 173): every step of `J.retainedFrame` from `xs` reaches `xs ++ [z]` for some `z`, so the earlier list is kept as a prefix across the step. No declaration names a set of configurations closed under steps, an invariant, a kernel or a fixed point; the closure of 'lists extending a given list' is a consequence the module does not state (the trace form is `Joining.retained_extends`, in Joining.lean l. 864). [which pass was right: both in part; opened: retained_step_extends l.173; retained_pair_matches_of_em l.182; collapsed_exact l.161; collapsed_reduced l.166; idle_self_retained l.248]
  - *pass a:* S: retained_step_extends (l. 173) preserves all prior slots and hence membership in any fixed-prefix region.
  - *pass b:* N.
- **forms change while the going on continues, or more can go on after**
  - *settled by the third pass:* N: `retained_step_extends` (l. 173) states only `ys = xs ++ [z]` for a step of the retained frame: one more slot after a move. No statement says the course continues while something present leaves, that kinds come and go, or that more moves are possible after the step. Opened to rule it out: `retained_step_extends` (l. 173), `retained_pair_matches_of_em` (l. 182), `idle_self_retained` (l. 248), `once_retained_apart` (l. 254), `once_roles_hide_ends` (l. 234). [which pass was right: b; opened: retained_step_extends l.173; retained_pair_matches_of_em l.182; once_roles_hide_ends l.234; idle_self_retained l.248; once_retained_apart l.254]
  - *pass a:* S: retained_step_extends (l. 173) gives one more retained fragment after every actual move.
  - *pass b:* N.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. General statements support states, moves, reading, multiplying, no_return, comparison, closed_region, forms_change. Built cases support states, reading, no_return. I found no matching statement for share, level, giving, cost, both_outcomes, rank. No answer rests on prose alone or was unreached.
  - *pass b:* All 14 answered from statements where the answer is not N; nothing taken from the account only. Read whole (273 lines, all statements).
