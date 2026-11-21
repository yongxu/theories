# Centers

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Centers.lean`
- *result records that name this place's file as a source* (computed; not a link): `where-a-formations-acts-return`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-02, as "Centers.lean: exists_reachReturns, reachReturns_iff_closed, InOneLoop.mono" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-02.md.txt)); pass b: reader whole-b-04, as "Centers.lean: Flow.InOneLoop, Flow.ReachReturns, Flow.reachReturns_iff_closed, Flow.ReachReturns.represented, Flow.reachReturns_iff_represented, Flow.InOneLoop.mono, Flow.exists_reachReturns, Line.open_not_returns, Line.closed_returns" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-04.md.txt)); the third pass, where the two differed: reader whole-c-settle-02, as "Centers.lean: settled fields giving, both_outcomes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-02.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `exists_reachReturns` (l. 153) gives a reachable returning formation from every formation if a list covers all formations and reach is decidable. `reachReturns_iff_closed` (l. 77) characterizes return by closure of the mutual-reach loop under affecting.
  - *pass b:* General for any flow and web: being in one loop (each within the other's reach) is an equivalence; a formation's acts return exactly where its loop is closed under affecting; where acts return, what it acts on lies within its coupling closure (exactly so with threshold coupling); loops only merge as exchange grows; and with finitely many formations listed and reach decided, every formation's reach holds one whose acts return. Built: Line, an open two-formation line in which a's acts do not return, and the same line closed, in which they do.
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: one flow, with no choice among steps.
- **a reading**
  - *pass a:* S: `reachReturns_iff_represented` (l. 97) equates return with every reachable formation lying within threshold-only coupling.
  - *pass b:* S: ReachReturns.represented (l. 91): where f's acts return, every g in f's reach is within the coupling closure (L.WithinCoupling W obs f g) for every obs. reachReturns_iff_represented (l. 97): with thresholdOnly, acts return exactly where everything in reach can be represented.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: Line.web has constant level 1, and nothing runs down.
- **a giving that is itself a going-on**
  - *settled by the third pass:* B: Line.flow (l. 215) with Line.a_affects_b (l. 224) and Line.closed_b_affects_a (l. 252): formation a gives one unit to the condition b requires, and with back = true b gives to the condition a requires. The giver is a formation of the model, but Line.web (l. 203) has active True and level 1 at every step, so what gives cannot be lost and no level runs down. [which pass was right: both in part; opened: Line.web l. 203; Line.flow l. 215; a_affects_b l. 224; open_b_inert l. 228; closed_b_affects_a l. 252]
  - *pass a:* B: `Line.flow` (l. 215) makes formation a give to b’s condition and lets b give back according to a Boolean; both stay present in both flows.
  - *pass b:* N.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N. D: the account says that where acts do not return, some formation acted on can never affect it (l. 26); this is the negation of the definition, not a stated law.
- **both outcomes**
  - *settled by the third pass:* N: opened reachReturns_iff_closed (l. 77), reachReturns_iff_loop (l. 73), reachReturns_iff_represented (l. 97), Line.open_not_returns (l. 243), Line.closed_returns (l. 260). The general iff (any Flow F C, Web F C, f) says L.ReachReturns W f exactly when InOneLoop W f is ClosedUnder Affects; the Line pair gives a's acts not returning in flow false and returning in flow true. These are two outcomes of returning, on two flows, not of going on and ending or keeping and losing. [which pass was right: a; opened: ll. 73, 77, 97, 153, 243, 247, 256, 260]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* S: reachReturns_iff_closed (l. 77): acts return exactly where the loop is closed under affecting. B: Line.open_not_returns (l. 243) against Line.closed_returns (l. 260): the same a in two flows (back false or true). Not going on and ending.
- **a comparison between two**
  - *pass a:* S: `InOneLoop.mono` (l. 104) carries mutual reach to a flow containing every old exchange on the same web.
  - *pass b:* S: InOneLoop.mono (l. 104): where every exchange of L is one of L', every loop of L is a loop of L'. ReachReturns.of_loop (l. 85): returning carries to every formation in the loop.
- **a rank (an ending within a bound)**
  - *pass a:* D: The opening account describes a strict decrease of reach along a nonreturning link in the finite existence argument; `exists_reachReturns` states existence.
  - *pass b:* S: holdsCount_lt (l. 123): a test implied by another, and holding where the other fails, counts strictly less on the list. exists_reachReturns (l. 153) is proved by this strictly falling count of reach until a returning formation is found.
- **a closed region**
  - *pass a:* S: `reachReturns_iff_closed` (l. 77) gives closure under the Affects relation exactly when the formation’s acts return.
  - *pass b:* S: reachReturns_iff_closed (l. 77): ReachReturns iff ClosedUnder (L.Affects W) (L.InOneLoop W f). exists_reachReturns (l. 153): with members listed and reach decided, every f reaches some c whose acts return.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N. B (on loops only): Line.closed_one_loop (l. 256): when b comes to give to what a depends on, a and b become one loop.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statement answers cover states, reading, comparison, closed_region. Built-case answers cover giving. Account or docstring evidence covers rank. I reached all fourteen questions.
  - *pass b:* All statements read (267 lines). reading, both_outcomes, comparison, rank and closed_region answered from statements; no_return has only a D note; the rest are N.
