# CensusTable

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/CensusTable.lean`
- *result records that name this place's file as a source* (computed; not a link): `counting-standing-and-dependence`, `counting-under-enclosure`, `counting-where-the-counts-exist`, `whole-law-of-counting`
- *dynamics in the atlas that name one of those records* (computed; not a link): `continued-change-needs-openness`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-02, as "CensusTable.lean: FamilyCounts.tally, table_holds, WitnessedAt.congr" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-02.md.txt)); pass b: reader whole-b-04, as "CensusTable.lean: FamilyCounts, FamilyCounts.tally, FamilyCounts.company, World.table_holds, World.table_marks_hold, World.Witnessed, World.WitnessedAt.congr, World.CountsHold" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-04.md.txt)); the third pass, where the two differed: reader whole-c-settle-02, as "CensusTable.lean: settled fields level, giving, no_return" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-02.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `table_holds` (l. 234) equates universal listing properties with properties of all tallies satisfying C when C is sound and every such tally has a witness in the class. `table_marks_hold` (l. 246) gives the decided-marks version for pointwise properties.
  - *pass b:* General for any class of worlds and any listing L w : X w → Nat → Prop. The counts of a listed family (FamilyCounts) are a tally. Where every listed family of every world of the class has counts meeting C, and every tally meeting C is witnessed in the class, a property holds of every listing of every world of the class exactly when it holds of every tally meeting C (table_holds), with a decided form for pointwise properties (table_marks_hold).
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a reading**
  - *pass a:* S: `listingMarksHold_of_marksHold` (l. 222) transfers pointwise properties between two procedures deciding the same listing.
  - *pass b:* S: a listing L is what is registered of a world. table_holds (l. 234): Q holds of every listing of every world in Class exactly when it holds of every tally meeting C, given soundness and witnessing. Listed.congr (l. 137) and FamilyCounts.congr (l. 142): agreeing determinations list and count alike. listingMarksHold_of_marksHold (l. 222): two procedures deciding one listing satisfy the same pointwise properties.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a level that runs down**
  - *settled by the third pass:* N: opened FamilyCounts (l. 64), FamilyCounts.tally (l. 69), FamilyCounts.company (l. 151), ListingHolds (l. 167). The statements are about lengths of listings and counts of ceasing and coming to be; 0 \< w.web.level t x appears only in the account (l. 43) as a listing that Becoming.Standing reads, and no level running down is stated. [which pass was right: a; opened: ll. 54, 64, 69, 80, 86, 151, 167; account ll. 39-44]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* D: the account names what stands (0 \< w.web.level t x) as a listing read in Becoming.Standing. N: no level is stated here.
- **a giving that is itself a going-on**
  - *settled by the third pass:* N: opened FamilyCounts.company (l. 151): given FamilyCounts p l n c a and the hypothesis ground (every x in l (t+1) that ComesToBe across t has 0 \< (l t).length), 0 \< a t -> 0 \< n t. What coming to be rests on is the hypothesis ground, handed in; nothing in the statement makes the giver a going-on that can be lost. [which pass was right: a; opened: FamilyCounts.company l. 151; FamilyCounts l. 64]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* S: FamilyCounts.company (l. 151): where whatever comes to be across step t needs something held at it (the premise ground), 0 \< a t → 0 \< n t. The ground is handed in.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **multiplying**
  - *pass a:* S: `FamilyCounts.tally` (l. 69) gives the step balance for counts of a listed family, with ceasing and arising counted as in `FamilyCounts` (l. 64); it supplies no reproduction relation.
  - *pass b:* S: tally_step (l. 54) and FamilyCounts.tally (l. 69): ceasing c and coming a balance across each step, with n t = k + c t and n (t+1) = k + a t. N: no units leave units.
- **a point of no return**
  - *settled by the third pass:* S: FamilyCounts.company (l. 151): for a counted listed family, where whatever comes to be across step t needs a non-empty listing at t (hypothesis ground), nothing comes to be across a step at which nothing is counted (0 \< a t -> 0 \< n t). The irreversibility is at one step, at the loss of everything listed, and is the hypothesis ground restated in counts, so it is a premise more than a conclusion; not stated as 'for good'. [which pass was right: both in part; opened: FamilyCounts.company l. 151; FamilyCounts.tally l. 69]
  - *pass a:* S: `FamilyCounts.company` (l. 151) concludes positive arrivals require a positive prior count at the specified step, given that each listed arrival needs prior nonemptiness.
  - *pass b:* N.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a comparison between two**
  - *pass a:* S: `WitnessedAt.congr` (l. 213) transports a tally witness to any listing agreeing pointwise in every world of the class.
  - *pass b:* S: WitnessedAt.congr (l. 213) and witnessedAt_of (l. 194): a witness under one listing is one under any listing agreeing with it in the worlds of the class. census_table_holds₂ (l. 349) and census_table_holds₃ (l. 377) are the census forms.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statement answers cover states, reading, multiplying, no_return, comparison. I reached all fourteen questions.
  - *pass b:* All statements read (407 lines). reading, giving, multiplying and comparison answered from statements; level is D (account only); the rest are N.
