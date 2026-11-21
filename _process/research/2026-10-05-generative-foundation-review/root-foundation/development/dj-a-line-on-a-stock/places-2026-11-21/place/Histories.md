# Histories

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Histories.lean`
- *result records that name this place's file as a source* (computed; not a link): `histories-fix-law-up-to-dead-ends`, `tests-fix-likeness-where-determined`, `wisdom-root`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-07, as "Histories.lean: family_iff, same_histories_iff, same_finite_histories_iff, alike_iff_sameTests" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-07.md.txt)); pass b: reader whole-b-26, as "Histories.lean: family_iff, SpliceClosed, same_histories_iff, live, same_finite_histories_iff, alike_iff_sameTests, Choosing.not_alike" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-26.md.txt)); the third pass, where the two differed: reader whole-c-settle-10, as "Histories.lean: settled fields no_return, both_outcomes, rank" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-10.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `family_iff` (l. 107) characterizes the families of infinite histories admitted by a process as exactly the splice-closed families. `same_histories_iff` (l. 164) identifies processes with identical infinite histories by equality of their live steps, while `same_finite_histories_iff` (l. 199) identifies those with identical finite histories by equality of all steps.
  - *pass b:* S, general: a family of unending histories is the family of some law's histories exactly when it is closed under splicing (`family_iff`, l. 107), and of a determined law exactly when it is also consistent. Two laws have the same histories exactly when they have the same live steps (`same_histories_iff`, l. 164), and the same finite histories exactly when they have the same steps (`same_finite_histories_iff`, l. 199). Where both frames are determined up to likeness, configurations are alike exactly when they pass the same tests (`alike_iff_sameTests`, l. 302). A built pair, `Choosing`, shows that the tests do not fix likeness without that premise.
- **moves**
  - *pass a:* S: `SameTests.after` (l. 259) preserves equality of tests across any two outcomes of the same move from starts passing the same tests, provided each start determines its outcomes up to likeness.
  - *pass b:* S: `Admits` (l. 77) and `ShownBy` (l. 81) for every `Process S A`. `same_histories_iff` (l. 164) and `SameTests.after` (l. 259): passing the same tests survives a move into outcomes that are determined up to likeness. No law says what some choice or every choice keeps. B: `Choosing.late` and `Choosing.early` (l. 347, l. 351) choose after the first move and at it; `Choosing.early_not_determined` (l. 415).
- **a reading**
  - *pass a:* S: `alike_iff_sameTests` (l. 302) characterizes likeness by agreement on open move lists and claims realizable after each, if both frames are determined up to likeness everywhere. B: `Choosing.sameTests` (l. 400) and `Choosing.not_alike` (l. 407) separate those criteria when the first choice branches.
  - *pass b:* S: `SameTests` (l. 244): two configurations are read alike when the same courses are open from each and the same claims can be realized after each. `alike_iff_sameTests` (l. 302): where both frames are determined up to likeness, what the tests register decides likeness. B: `Choosing.sameTests` and `Choosing.not_alike` (l. 400, l. 407): where branching is not determined, the tests do not decide it.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
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
  - *settled by the third pass:* N: opened `DeadEnd.not_live` (l. 180), `live` (l. 150), `live_live` (l. 174), `Choosing.Early` (l. 340), `Choosing.not_alike` (l. 407). `DeadEnd.not_live` states `¬ (live DeadEnd.law).step s i t` for the one built law (`DeadEnd.law`, Labelled.lean l. 244, one step false to true with no continuation): no unending history shows any of its steps. That is a step with no history, an ending; nothing is said to be lost and not regained, and no 'from here no course keeps it' is stated. In `Early`, after `toRight` only `c` remains, but that is in the constructors and used inside the proof of `not_alike`; no statement says it. [which pass was right: b; opened: DeadEnd.not_live l.180; live l.150; live_live l.174; Choosing.Early l.340; Choosing.not_alike l.407; Labelled.lean DeadEnd.law l.244, DeadEnd.no_history l.247]
  - *pass a:* B: `DeadEnd.not_live` (l. 180) excludes every step of the concrete dead-end law from its live part, so no unending history takes such a step.
  - *pass b:* N: `DeadEnd.not_live` (l. 180) says only that a dead end's step is shown by no history. That is not an irreversibility.
- **both outcomes**
  - *settled by the third pass:* N: opened `Choosing.Early` (l. 340), `early_open` (l. 373), `early_of_open` (l. 393), `late_open` (l. 361), `late_of_open` (l. 387), `sameTests` (l. 400), `not_alike` (l. 407). `early_open` with `early_of_open` are two halves of `Trace early.P .p0 as t` (for some t) exactly when `Open as`: an exact list of the finite courses from p0 of one built frame, not a dichotomy of going on and ending or of keeping and losing. The two branches of `Early` are constructors of an inductive, not a statement with a condition. [which pass was right: b; opened: Choosing.Early l.340; Choosing.Open l.355; late_open l.361; early_open l.373; late_of_open l.387; early_of_open l.393; sameTests l.400; not_alike l.407]
  - *pass a:* B: `Choosing.Early` (l. 340) has two outcomes of the first a move. From p1 the b continuation is available and from p2 only c is available. `Choosing.early_open` (l. 373) and `early_of_open` (l. 393) characterize the finite move lists from p0.
  - *pass b:* N
- **a comparison between two**
  - *pass a:* S: `Trace.of_same` (l. 192) carries every finite trace to a second process when all first-process steps are second-process steps. `sameTests_bisimulation` (l. 285) gives a bisimulation for frames determined up to likeness everywhere.
  - *pass b:* S: `sameTests_bisimulation` (l. 285): where both frames are determined up to likeness, `SameTests` is a `Bisimulation` between F and G. `Alike.sameTests` (l. 249). `shownBy_le_iff` (l. 91): the law a family shows is the least law admitting its histories. `Trace.of_same` (l. 192): a law whose steps are included in another's carries its finite histories to it.
- **a rank (an ending within a bound)**
  - *settled by the third pass:* B (weaker than a said): `Choosing.late_open` (l. 361) and `Choosing.early_open` (l. 373): every `Trace late.P .p0 as t` (resp. `early.P`) has `Open as`, where `Open` (l. 355) is the inductive of the four lists [], [a], [a,b], [a,c]. So in these two built frames every course from p0 has at most two moves, but only by reading the four constructors: no statement names a bound, a rank, a variant or a deadline. [which pass was right: both in part; opened: Choosing.Open l.355; late_open l.361; early_open l.373; late_of_open l.387; early_of_open l.393]
  - *pass a:* B: `Choosing.late_open` (l. 361) and `Choosing.early_open` (l. 373) restrict every trace from the specified starts to `Choosing.Open` (l. 355), whose longest lists have length two.
  - *pass b:* N
- **a closed region**
  - *pass a:* S: `live_live` (l. 174) gives a fixed point of taking live steps, and `admits_spliceClosed` (l. 101) gives closure of every process's admitted histories under splicing.
  - *pass b:* S: `admits_spliceClosed` (l. 101): the histories of every law are closed under splicing, a closure of a family rather than a region closed under steps. `live_live` (l. 174): `live` is a fixed point; the live law has no dead end.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: I read the opening account, all statements and their docstrings. General statements cover states, moves, reading, comparison, closed_region. Built cases cover reading, no_return, both_outcomes, rank. I found no matching claim for share, level, giving, cost, multiplying, forms_change. I reached all fourteen questions.
  - *pass b:* All 14 answered from statements; all statements read, lines 1-420.
