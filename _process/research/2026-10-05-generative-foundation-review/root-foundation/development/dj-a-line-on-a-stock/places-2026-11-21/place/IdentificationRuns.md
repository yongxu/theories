# IdentificationRuns

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/IdentificationRuns.lean`
- *result records that name this place's file as a source* (computed; not a link): `a-code-formed-between-formations`, `a-formations-own-course`, `capture-by-counted-choices`, `closed-capture`, `identification-where-bounded`, `shared-laws-on-the-grammar`, `the-split-that-makes-sense`
- *dynamics in the atlas that name one of those records* (computed; not a link): `a-code-formed-between-formations`, `capture-by-counted-choices`, `closed-capture`, `falls-that-end-do-not-recur`, `merged-distinctions-stay-merged`, `recurrence-without-premise`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-08, as "IdentificationRuns.lean: prefix_fixes, sameFuture_coarsest, selectsThrough_iff_prefix, states_by_reading" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-08.md.txt)); pass b: reader whole-b-27, as "IdentificationRuns.lean: prefix_fixes, Law.sameFuture_coarsest, Law.coarsest_iff, Law.coarsest_class, Law.KeepsRelation.run, Law.name_identifiesAlike, sameAhead_iff_alike, Web.selectsThrough_iff_prefix, Web.alike_of_bounded, Web.states_by_reading, negation_two_states, parity_reached_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-27.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: For two runs of any process with at most N and N′ observed states, agreement before N + N′ − 1 fixes their observations forever (prefix_fixes, l. 434). For any determined law, SameFuture is the largest relation that the step preserves and on which present observations agree (Law.sameFuture_coarsest, l. 328).
  - *pass b:* The module carries Identification's laws to runs. It covers runs of any `Process S A` (`prefix_fixes`), runs of free branching (exactness and the earliest-rest laws) and runs of a determined law (`sameAhead_iff_alike`, `classes_unrefuted_runs`). It also states with no premise that the same future through the map is the coarsest relation keeping the map's values and kept by the law (`Law.sameFuture_coarsest`, `Law.coarsest_iff`). For a formation in a `Web`, a selection through its couplings selects by the prefix of its own course, and bounded own courses fix this within N+N'-1 steps. The laws are general; the built cases are negation, copying, `parity` and the web `oneCondition`.
- **moves**
  - *pass a:* S: prefix_fixes (l. 434) covers any pair of runs of Process S A, regardless of moves taken, under the state bounds and prefix agreement.
  - *pass b:* S: `prefix_fixes` (l. 434): for any process `P : Process S A` and runs r, r', if their courses through `reg` have at most N and N' states and agree before N+N'-1, they agree at every step. `withBound_earliest` (l. 461) and `rest_without_bound_missed` (l. 469) quantify over every run of free branching `Parting.free O`. These are laws over every run, with no move singled out as kept.
- **a reading**
  - *pass a:* S: Web.selectsThrough_iff_prefix (l. 753) identifies selection through couplings with a predicate on the observed prefix, given ValuesThrough. B: Web.states_by_reading (l. 847) gives one constant level history with one state read by level and unboundedly many read with the time.
  - *pass b:* S: `Web.selectsThrough_iff_prefix` (l. 753): a selection is through g's couplings up to t exactly where it selects each history by the prefix of g's own course before t+1. `Web.selects_alike_iff_prefix` (l. 772). `Law.sameFuture_coarsest` (l. 328): SameFuture keeps the map's values, is kept by the law, and holds every relation that does both. `Law.coarsest_iff` (l. 356). `Law.name_identifiesAlike` (l. 270): in a world a list holds, naming each configuration by its future before N+N-1 makes sense. `Law.now_identifiesAlike_iff_goAlike` (l. 170) and `Law.part_identifiesAlike_iff_step` (l. 177). `Web.states_by_reading` (l. 847): the number of states of an own course depends on the reading.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: level histories `l : Nat → C → Nat` occur in `Web.ValuesThrough` (l. 701) and `Web.courseThrough` (l. 707), but no statement has a level running down or a return depending on what is left.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: a formation g, its admission `W.Admits x t g` and the conditions coupled into it occur (`Web.ValuesThrough`, l. 701), but no statement has a giver that is itself lost.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: `classes_unrefuted_runs` (l. 534) is a double-negation statement and `KeepsRelation.run` (l. 313) is an invariant; neither states an irreversibility.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N for going on and ending, or keeping and losing. The iff statements (`Law.coarsest_iff` l. 356, `Law.coarsest_class` l. 376, `sameAhead_iff_alike` l. 506) concern classes and identification.
- **a comparison between two**
  - *pass a:* S: Law.KeepsRelation.run (l. 313) propagates any step-preserved relation on two starts to all matching run times.
  - *pass b:* S: `Law.KeepsRelation.run` (l. 313): a relation the step keeps holds at every step of the runs from two related configurations. `Law.kernel_bisimulation` (l. 102): a split that keeps the map's value and carries the law relates configurations by a bisimulation. `Law.coarser_of_exact` (l. 347): a class merging exactly the same-future configurations is coarser than every class that keeps the values and carries the law. `prefix_fixes` (l. 434) for two runs. `Web.alike_of_bounded` (l. 782) and `Web.alike_of_joint_bounded` (l. 803) for two histories.
- **a rank (an ending within a bound)**
  - *pass a:* S: Web.alike_of_bounded (l. 782) gives a deadline for distinguishing two histories under ValuesThrough and the two course-state bounds. B: Web.bounded_exact (l. 828) attains the last possible distinguishing step.
  - *pass b:* S, bounds on identification only; no falling variant. `Web.alike_of_bounded` (l. 782): what a formation ever tells apart along own courses with at most N and N' states it tells apart within N+N'-1 steps. `IdentificationRuns.joint_agree` (l. 686): within P for a joint course of at most P states. `byElimination_rest_cubic` (l. 480): a lower bound on elimination's rest step along runs of free branching.
- **a closed region**
  - *pass a:* S: Law.sameFuture_coarsest (l. 328) gives a step-closed relation on pairs, maximal among those preserving the observed value.
  - *pass b:* S: `Law.sameFuture_coarsest` (l. 328): SameFuture is the largest relation that keeps the map's values and is kept by the law. `Law.KeepsRelation.run` (l. 313): a kept relation as an invariant along runs. B: `parity_fixed` (l. 633): the even triples are fixed by `parity`. `parity_reached_iff` (l. 644): one move of `parity` reaches exactly the even triples.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* B: negation_two_states and negation_each_through_other (ll. 566, 580) give two distinct observed states and alternation forever on any negation run from true.
  - *pass b:* B: `negation_two_states` (l. 566) and `negation_each_through_other` (l. 580): along the run of negation from true there are exactly two states, each going into the other, an alternation. `negation_derived` (l. 595). No general statement of a going on continuing while what is present changes.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. General statements support states, moves, reading, comparison, rank, closed_region. Built cases support reading, rank, forms_change. I found no matching statement for share, level, giving, cost, multiplying, no_return, both_outcomes. No answer rests on prose alone or was unreached.
  - *pass b:* All statements and docstrings of the module read (l. 1-863). Answered from statements: moves, reading, comparison, rank, closed_region (with a built part). Answered from built cases: forms_change. Answered N after reading every statement: share, level, giving, cost, multiplying, no_return, both_outcomes. Nothing left unreached.
