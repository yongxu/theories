# ConveyanceBoundaries

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ConveyanceBoundaries.lean`
- *result records that name this place's file as a source* (computed; not a link): `conveyance-crosses-the-boundary`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-03, as "ConveyanceBoundaries.lean: Flow.region_no_boundary, Flow.closures_not_within_region, Flow.closedUnder_of_cut" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-03.md.txt)); pass b: reader whole-b-08, as "ConveyanceBoundaries.lean: cut_iff_notGoingOut, cut_of_closedUnder, closedUnder_of_cut, conveyance_symm, cut_iff_notComingIn, region_no_boundary, closures_not_within_region, Clearing.resource_no_boundary" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-08.md.txt)); the third pass, where the two differed: reader whole-c-settle-03, as "ConveyanceBoundaries.lean: settled fields level" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-03.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `Flow.region_no_boundary` (l. 82) excludes the family's event region as any event's boundary under conveyance, given decidable equality, balance, dissipation, distinct members, eventual enclosure and arbitrarily late positive taking. Under the same premises `Flow.closures_not_within_region` (l. 92) rules out every member event's closure lying inside the family.
  - *pass b:* General: a valuation's Cut is the grammar's 不出 at its relation (by definition). A region closed under the relation is a cut, and a cut is closed where membership is stable. Conveyance is symmetric, so along it nothing goes out exactly when nothing comes in. Under balance, dissipation, a list of the family's relata without repetition, enclosure around the family from some step, and takers recurring at arbitrarily late steps, the family's region is no Boundary along conveyance of any event (`region_no_boundary`), and not every member's closure lies within it. Built: in the Clearing, the resource's region is no boundary along conveyance nor along living on.
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a reading**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: `own` and `sig` enter as parameters of conveyance, and no statement here makes what is registered decide anything.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *settled by the third pass:* N: `region_no_boundary` (l. 82, section Crossing, variables `{X Pos} {L : Flow X X} {W : Web X X} {own sig}`, with `[DecidableEq X]`) takes `L.Balances W`, `L.Dissipative`, `Distinct ds`, `around` from `T₀` on and `recurs : ∀ N, ∃ t, N ≤ t ∧ 0 < L.takers ds t`, and concludes `¬ Boundary (L.conveyance W own sig).related e (fun e => e.1 ∈ ds)`. A level enters only inside the premises `Balances` and `Dissipative`; no statement here says a level runs down or what comes back. Opened to rule it out: all eight statements, ll. 44, 49, 54, 66, 73, 82, 92, 108. [which pass was right: a; opened: cut_iff_notGoingOut l. 44; cut_of_closedUnder l. 49; closedUnder_of_cut l. 54; conveyance_symm l. 66; cut_iff_notComingIn l. 73; region_no_boundary l. 82; closures_not_within_region l. 92; resource_no_boundary l. 108]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* S: `region_no_boundary` (l.82) takes as premises `L.Balances W`, `L.Dissipative`, and `recurs`: something takes from the family at arbitrarily late steps. It concludes that the family's region is not closed under conveyance. N: nothing on what comes back depending on what is left.
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
  - *pass b:* N for going on and ending. S: `cut_iff_notComingIn` (l.73) is an exactly-when between not going out and not coming in.
- **a comparison between two**
  - *pass a:* S: `Flow.cut_iff_notComingIn` (l. 73) carries the cut condition to the converse conveyance relation and back, using symmetry of conveyance (`Flow.conveyance_symm`, l. 66).
  - *pass b:* S: `conveyance_symm` (l.66): conveyance's relation is contained in its inverse. `cut_iff_notComingIn` (l.73) carries a cut between the relation and its inverse.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a closed region**
  - *pass a:* S: `Flow.cut_of_closedUnder` (l. 49) makes a closed region a cut for any valuation, and `Flow.closedUnder_of_cut` (l. 54) recovers closure from a cut given stable membership. The relation here is between events.
  - *pass b:* S: `cut_of_closedUnder` (l.49): a region closed under the valuation's relation is a cut. `closedUnder_of_cut` (l.54) is the converse under stable membership. `region_no_boundary` (l.82) and `closures_not_within_region` (l.92): under the premises above, a continuing family's region is not closed under conveyance. B: `Clearing.resource_no_boundary` (l.108).
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statements (1, 11, 13). Not found (2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 14). I reached all fourteen questions.
  - *pass b:* All 14 questions were answered from statements or built cases. I read all statements, l.1-119, and Standpoints.lean l.300 for region_not_a_cut.
