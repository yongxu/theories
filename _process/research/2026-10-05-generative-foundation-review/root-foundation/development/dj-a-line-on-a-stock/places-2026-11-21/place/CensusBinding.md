# CensusBinding

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/CensusBinding.lean`
- *result records that name this place's file as a source* (computed; not a link): `counting-where-the-counts-exist`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-02, as "CensusBinding.lean: binding_counting_under_counted, counting_binds_jointly_counted, enclosed_iff_finite_counting_under_counted" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-02.md.txt)); pass b: reader whole-b-04, as "CensusBinding.lean: World.binding_counting_counted, World.binding_counting_under_counted, World.binding_activity_iff_counted, World.binding_arising_iff_counted, World.enclosed_binding_counting_counted, World.counting_binds_jointly_counted, World.enclosed_iff_finite_counting_under_counted, World.standing_iff_counting_counted" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-04.md.txt)); the third pass, where the two differed: reader whole-c-settle-02, as "CensusBinding.lean: settled fields giving, no_return, both_outcomes, closed_region" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-02.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `binding_counting_counted` (l. 70) characterizes all count properties under Premised and Binds by tallies with some arising and with activity whenever something arises. `binding_counting_under_counted` (l. 81) gives the corresponding general characterization for each selection of binding premises.
  - *pass b:* General over every World with no decidedness: for every property Q of a census's counts (n active, c ceasing, a arising), Q holds of every counted census of every world meeting a selection whose premises bind exactly when Q holds of every tally meeting the listed conditions, in plain, finite and enclosed-from-some-step forms. Equivalences say exactly which selections make activity, arising, or arising with something active a law. The witnesses are built queues; balance and embodiment bind the counts jointly and neither does alone.
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: selections S : Premise → Bool are choices of premises, not moves of a process.
- **a reading**
  - *pass a:* S: `standing_iff_counting_counted` (l. 352) equates the universal standing and counted readings of any pointwise property under the same selection.
  - *pass b:* S: binding_counting_under_counted (l. 81): Q holds of every counted census (CountsHold) of every world meeting S with selected premises binding exactly when Q holds of every tally meeting the conditions. standing_iff_counting_counted (l. 352): for pointwise Q, read on what stands equals read on counted censuses under each selection.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: counts n, c and a, but no share among kinds and no rule set from one.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no level running down is stated here. The reading on what stands (l. 352) is a listing of 0 \< level, but no running down is stated of it.
- **a giving that is itself a going-on**
  - *settled by the third pass:* S: counting_binds_jointly_counted (l. 314): for every World with w.Balanced, w.Acting and w.ArisingEmbodied, every counted census has 0 \< a t -> 0 \< n t (something arising across a step needs something active at it), and two queues (all premises but embodiment; all but balance) fail it. What arising rests on is the count of active relata, which the same census counts as ceasing; that only active relata give (w.Acting) is a premise, and no level is in the statement. [which pass was right: both in part; opened: counting_binds_jointly_counted l. 314; binding_counting_counted l. 70; binding_counting_under_counted l. 81; active_of_coming_jointly (Counting l. 357)]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* S: counting_binds_jointly_counted (l. 314): where w.Balanced, w.Acting (only active relata give) and w.ArisingEmbodied, every counted census has 0 \< a t → 0 \< n t. Queues meeting every premise but embodiment, or every premise but balance, fail it. The givers are the world's active relata; that only they give is a premise.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **multiplying**
  - *pass a:* S: `counting_binds_jointly_counted` (l. 314) gives the aggregate constraint that positive arising requires prior activity under balance, active giving and embodied arising. It exhibits two queues violating the constraint with a premise missing.
  - *pass b:* S: counts of arising and ceasing per step under Tally. binding_arising_iff_counted (l. 110): something arising is a law, where the selected premises bind, exactly where embodiment is selected. N: no law of units leaving units.
- **a point of no return**
  - *settled by the third pass:* S: counting_binds_jointly_counted (l. 314), also the tally side of binding_counting_counted (l. 70): under Balanced, Acting, ArisingEmbodied (l. 314) or Premised and Binds (l. 70), nothing arises across a step at which nothing is active, concluded for every counted census. It is stated per step, at the loss of everything active; that zero activity then stays zero for good is not stated (it needs Tally combined by the reader). [which pass was right: both in part; opened: binding_counting_counted l. 70; counting_binds_jointly_counted l. 314; Tally (Population l. 676)]
  - *pass a:* S: `binding_counting_counted` (l. 70) characterizes the laws by a tally in which zero activity permits zero arrivals only, so extinction is absorbing in those tallies.
  - *pass b:* N.
- **both outcomes**
  - *settled by the third pass:* N: opened binding_activity_iff_counted (l. 99), binding_arising_iff_counted (l. 110), binding_joint_iff_counted (l. 121), their finite and enclosed forms (ll. 194-277), enclosed_iff_finite_counting_under_counted (l. 337). Each is an 'exactly when' saying for which selections S : Premise -> Bool a property of the counts holds in every world meeting S where its premises bind; none gives going on and ending, or keeping and losing, of one model. [which pass was right: a; opened: ll. 99, 110, 121, 194, 205, 217, 254, 265, 277, 314, 337]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* S: binding_activity_iff_counted (l. 99), binding_arising_iff_counted (l. 110), binding_joint_iff_counted (l. 121) and their finite and enclosed forms: each says exactly which selections make the property a law. These are laws over classes of worlds, not going on and ending for one model.
- **a comparison between two**
  - *pass a:* S: `enclosed_iff_finite_counting_under_counted` (l. 337) equates all universal count laws of eventually enclosed and finite worlds precisely for selections bounding change and binding counting.
  - *pass b:* S: enclosed_iff_finite_counting_counted (l. 329): under the eight premises, enclosed-from-some-step worlds and finite worlds have the same laws of counting. enclosed_iff_finite_counting_under_counted (l. 337): under a selection, the two classes have the same laws exactly when BoundsChange S and BindsCounting S hold. These compare classes of worlds, not two processes.
- **a rank (an ending within a bound)**
  - *pass a:* S: `finite_binding_counting_counted` (l. 135) includes a ChangeBound from time zero in the tally characterization for finite premised worlds binding all premises except the census.
  - *pass b:* S: enclosed_binding_counting_counted (l. 150) and finite_binding_counting_counted (l. 135): under enclosure from some step on (or finiteness) with binding, the laws include ∃ B, ChangeBound 0 B n c a. ChangeBound (Population l. 949) means that, from step T, the count plus the number of steps of change stays within B.
- **a closed region**
  - *settled by the third pass:* N: opened binding_counting_counted (l. 70), enclosed_binding_counting_counted (l. 150), counting_binds_jointly_counted (l. 314), standing_iff_counting_counted (l. 352). They state 0 \< a t -> 0 \< n t and a ChangeBound; no statement says a set of counts or states is closed under the step. Enclosure (w.flow.Enclosed t from some T on) appears only as a premise. [which pass was right: b; opened: ll. 70, 135, 150, 314, 329, 352]
  - *pass a:* S: `binding_counting_counted` (l. 70) characterizes counts by Tally, positive arrivals implying current activity, and some arrival. In particular the tally cannot leave zero activity across a step.
  - *pass b:* N: enclosure appears only as a premise (w.flow.Enclosed).
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: arising and ceasing are counted, but no statement has going on continue while what is present changes.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statement answers cover states, reading, multiplying, no_return, comparison, rank, closed_region. I reached all fourteen questions.
  - *pass b:* All statements read (359 lines). reading, giving, multiplying, both_outcomes, comparison and rank answered from statements; the rest are N.
