# HistorySums

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HistorySums.lean`
- *result records that name this place's file as a source* (computed; not a link): `sums-over-histories-by-support-horizon-and-order`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-07, as "HistorySums.lean: Weights.transfer_split, Weights.transfer_eq_sum_exactly, Weights.transfer_between_traces, labelled_trace_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-07.md.txt)); pass b: reader whole-b-26, as "HistorySums.lean: Weights.transfer_zero_of_impossible, Weights.transfer_split, Weights.exactly, Weights.exactly_eq_courses, grouping_needs_commuting, Weights.transfer_between, Weights.transfer_between_traces" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-26.md.txt)); the third pass, where the two differed: reader whole-c-settle-10, as "HistorySums.lean: settled fields rank" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-10.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `Weights.transfer_split` (l. 211) splits transfer at any intermediate horizon for any weighting, and `Weights.transfer_eq_sum_exactly` (l. 315) sums exact response orders to total transfer when addition of alternatives commutes. `Weights.transfer_between_traces` (l. 813), with complete listings, a Boolean step reading and weights and terminal reading zero off their supports, equates transfers for weights agreeing on the steps of length-n traces to the terminal test.
  - *pass b:* S, general for every weighting of a sum over histories: support (`transfer_zero_of_impossible`, l. 186), splitting at every horizon (`transfer_split`, l. 211) and locality, in that only the steps lying between count (`transfer_between`, l. 591). The exact orders are sums over courses with exactly i responses where alternatives commute (`exactly_eq_courses`, l. 420), and the whole sum is the sum of all of them (`transfer_eq_sum_exactly`, l. 315). The same laws are stated on the traces of a process. B: a built self-loop gives binomial orders, and the built `firstListed` shows the commuting premise is needed.
- **moves**
  - *pass a:* S: `exactly_responses_trace` (l. 748) extracts from a nonzero exact count a listed course with exactly i responses, giving a legal labelled-move trace ending where the terminal count is nonzero.
  - *pass b:* S: moves and configurations are listed, and possibility weights read the steps of a `Process` P. `trace_split_iff` (l. 690) and `labelled_trace_iff` (l. 771): the process of the parts has a trace exactly when P has one. No law says what some choice or every choice keeps.
- **a reading**
  - *pass a:* S: `Weights.Hom.exactly` (l. 326) commutes a homomorphism of weight structures with each exact-order reading, mapping the two step weights and terminal reading. `Weights.transfer_zero_of_no_trace` (l. 796) makes the transfer zero if no trace of the specified length reaches the Boolean reading, with exact step tests, complete lists and off-support vanishing.
  - *pass b:* S: `Weights.Hom.exactly` (l. 326): a reading that keeps the laws of the weights can be taken exact order by exact order. `transfer_between_traces` (l. 813): two weightings that agree on every step lying on a trace from the start to where g holds give the same transfer, so steps off those traces make no difference to what is carried.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: `responses` (l. 359) counts the steps taken through the response part, but no rule is set again from that count.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a cost to the one that keeps or gives**
  - *pass a:* N: `firstMul` (l. 512) adds the costs of successive possible steps, and `firstResponse` (l. 552) assigns one specified response cost one. No giver's standing or alternatives are debited by keeping a condition met.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: `Routes.SelfLoop.exactly_eq` (l. 484) gives `binom n i * M ^ i` as a weight of courses. It is not units leaving units.
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a comparison between two**
  - *pass a:* S: `labelled_trace_iff` (l. 771) preserves existence of a length-n trace to a nonzero terminal reading between the labelled parts process and P, when nonzero summed counts exactly recognize P's steps and the state and move lists cover their carriers.
  - *pass b:* S: `transfer_between` (l. 591) and `transfer_between_traces` (l. 813) carry equality of transfer between two weightings that agree on the steps between. `Hom.exactly` (l. 326) carries exact orders between weight structures. `transfer_labelled` (l. 387) and `labelled_trace_iff` (l. 771) carry between a process and its process of parts.
- **a rank (an ending within a bound)**
  - *settled by the third pass:* N: opened `Weights.exactly` (l. 238), `Weights.exactly_above` (l. 250), `exactly_le_transfer` (l. 705), `exactly_responses_trace` (l. 748), `Leads` (l. 574), `Weights.transfer_zero_of_no_trace` (l. 796). `exactly_above` states, for every weighting W and all ground, response, moves, all, f: `∀ i n, n < i → ∀ s, W.exactly ground response moves all f i n s = W.zero`. That bounds the order (number of responses) by the horizon n, which is a parameter; it does not say that a course ends, and no rank, variant, drain or deadline is stated. [which pass was right: b; opened: Weights.exactly l.238; exactly_above l.250; exactly_le_transfer l.705; exactly_trace l.724; exactly_responses_trace l.748; Leads l.574; transfer_between l.591; transfer_zero_of_no_trace l.796; section variables l.233]
  - *pass a:* S: `Weights.exactly_above` (l. 250) forces every order i above a horizon n to have zero weight for every weighting. This bounds the number of responses in the course.
  - *pass b:* N: `exactly_above` (l. 250) says only that an exact order vanishes above the horizon. It is not a rank of ending.
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: I read the opening account, all statements and their docstrings. General statements cover states, moves, reading, comparison, rank. I found no matching claim for share, level, giving, cost, multiplying, no_return, both_outcomes, closed_region, forms_change. I reached all fourteen questions.
  - *pass b:* All 14 answered from statements; all statements read, lines 1-829.
