# UnitMatchings

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/UnitMatchings.lean`
- *result records that name this place's file as a source* (computed; not a link): `amounts-by-unit-matchings`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-20, as "UnitMatchings.lean: frameMatchings_iff_balances, FrameMatchings.next, rise_crossing_strong, leaving_and_endings_count" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-20.md.txt)); pass b: reader whole-b-78, as "UnitMatchings.lean: FrameMatch.eq, frameMatchings_iff_balances, FrameMatchings.next, crossing_edge, rise_crossing_weak, rise_crossing_strong, endings_count, residual_pos_of_dissipates" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-78.md.txt)); the third pass, where the two differed: reader whole-c-settle-29, as "UnitMatchings.lean: settled fields giving, comparison, rank" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-29.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `frameMatchings_iff_balances` (l. 156) identifies balance with existence of bijections between standing-plus-given and next-standing-plus-taken positions at every condition and step. `rise_crossing_strong` (l. 260) finds a present formation for which every specified source-minimal pairing sends some unit taken from the rest to the risen family, given balance, a distinct risen family and a stock rise exceeding inflow to the combined list.
  - *pass b:* General laws for any flow over a web: a flow has a selected bijection of in-positions with out-positions at every step and condition exactly where it balances (frameMatchings_iff_balances); a standing unit goes on standing or is taken (FrameMatchings.next); where a family's stock rises past the inflow of a containing family, some present formation has, at every pairing, a unit it gives the risen family continuing another input (rise_crossing_weak, rise_crossing_strong). Residual counts: with beyond's units source-minimal, endings number taken beyond given (endings_count), zero beyond-count and a positive residual where a formation dissipates; there is no built model.
- **moves**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N.
- **a reading**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N.
- **a share**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N.
- **a level that runs down**
  - *pass a:* S: `FrameMatchings` (l. 139) matches standing plus gifts against next standing plus takes. `residual_pos_of_dissipates` (l. 315) gives strictly positive taken excess for a present formation taking positively on a dissipating family, without a renewal function of residual stock.
  - *pass b:* S: `rise_crossing_weak` (l. 242) takes as premise a family's stock rising past the inflow of a containing family. `residual_pos_of_dissipates` (l. 315): on a family a present formation dissipates on and takes from, taken beyond given is positive. `FrameMatchings.next` (l. 163) places standing units. No law in which what comes back depends on what is left.
- **a giving that is itself a going-on**
  - *settled by the third pass:* S (weaker): `rise_crossing_weak` (l. 242): given `L.Balances W`, `Distinct ds`, ds within es, and `W.stock ds t + L.inflow es t < W.stock ds (t+1)`, there is a formation `f ∈ L.present t` such that in every pairing of what f takes from ds (plus any other inputs) with what f gives ds (plus any other outputs), some unit f gives ds continues one of the other inputs. The giver is a formation in the Flow's present list at step t, not a function of the level; no statement says the giver can be lost or is lost, and the present list is the Flow's data. [which pass was right: both in part; opened: rise_crossing_weak (l. 242), rise_crossing_strong (l. 260), takenUnits (l. 219), givenUnits (l. 223), Exchange (l. 212); variable {F C : Type} (l. 134).]
  - *pass a:* S: `rise_crossing_weak` (l. 242) identifies a formation among those present at the step whose gifts to the risen family must include a crossing from another input in any such pairing, given balance, containment, distinctness and the strict rise. No subsequent loss of that giver is concluded.
  - *pass b:* N: the givers are formations in the Flow's supplied present list (rise_crossing_weak concludes some f ∈ L.present t); no statement makes a giver a going-on that can be lost.
- **a cost to the one that keeps or gives**
  - *pass a:* N: `rise_crossing_strong` (l. 260) requires a transfer from units the formation took from the rest under the specified pairing. The theorem identifies the source family without requiring the formation to spend its own standing.
  - *pass b:* N.
- **multiplying**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N: units are positions paired one to one (FrameMatch); none leaves further units.
- **a point of no return**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N.
- **both outcomes**
  - *pass a:* S: `FrameMatchings.next` (l. 163) gives disjoint alternatives for a standing position under a supplied matching: its image stands at the next step or belongs to the taken block.
  - *pass b:* S: `frameMatchings_iff_balances` (l. 156): Nonempty (FrameMatchings L W) iff L.Balances W. `FrameMatchings.next` (l. 163): a unit standing at t goes, by the matching, to a standing position at t+1 or to a taken position (a unit kept or taken), general.
- **a comparison between two**
  - *settled by the third pass:* N: opened `FrameMatch.symm` (l. 107: the same bijection of positions i \< N with j \< M read backward), `FrameMatch.predecessor_unique` (l. 130: within one matching, fwd i = j gives i = bwd j), `FrameMatchings` (l. 139), `frameMatchings_iff_balances` (l. 156), `FrameMatchings.next` (l. 163: a standing unit of one flow goes by the matching to a standing position at t+1 or a taken one), `crossing_edge` (l. 183: one pairing of two lists). Each is about the in- and out-positions of one frame of one flow at one step or one pairing; none carries anything between two processes, two starts or two ways. [which pass was right: b; opened: FrameMatch (l. 84), FrameMatch.symm (l. 107), FrameMatch.eq (l. 116), FrameMatch.predecessor_unique (l. 130), FrameMatchings (l. 139), frameMatchings_iff_balances (l. 156), FrameMatchings.next (l. 163), crossing_edge (l. 183).]
  - *pass a:* S: `FrameMatch.symm` (l. 107) reverses a supplied bijection and `FrameMatch.predecessor_unique` (l. 130) identifies its in-range predecessor with the backward image. This compares positions of adjacent frames.
  - *pass b:* N: `crossing_edge` (l. 183) concerns one pairing of two lists (if b₁ is longer than a₁ under a one-to-one pairing of b₁++b₂ with a₁++a₂, some member of a₂ is related to one of b₁), not two processes. D: the docstring of FrameMatchings (l. 136) says the frames compose across steps.
- **a rank (an ending within a bound)**
  - *settled by the third pass:* N: opened `residual_pos_of_dissipates` (l. 315: with `L.DissipatesOn cs t`, `f ∈ L.present t` and `0 < total cs (L.take t f)`, the excess of taken over given at f is positive, at one step), `leaving_and_endings_count` (l. 295: for one pairing with beyond's units source-minimal, leaveL.length + endedL.length equals taken beyond given), `endings_count` (l. 282), `source_minimal_zero_of_dissipates` (l. 307), `lossless_not_dissipative` (l. 329). All are counts at one formation and one step; none states an ending within a bound, a quantity falling along steps, or a deadline. [which pass was right: b; opened: endings_count (l. 282), leaving_and_endings_count (l. 295), source_minimal_zero_of_dissipates (l. 307), residual_pos_of_dissipates (l. 315), lossless_not_dissipative (l. 329).]
  - *pass a:* S: `residual_pos_of_dissipates` (l. 315) gives a strictly positive one-step residual count from dissipation, presence and positive taking. `leaving_and_endings_count` (l. 295) counts leaving and ending together for a pairing with minimal beyond input; it gives no deadline for an individual line.
  - *pass b:* N.
- **a closed region**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statement answers cover states, level, giving, both_outcomes, comparison, rank. No answer relies on prose alone. The remaining questions are N, and I reached all fourteen.
  - *pass b:* All statements and docstrings read, to line 339; level and both_outcomes are from statements; comparison is N with a docstring note; the rest are N.
