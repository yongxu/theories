# RenewalBound

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/RenewalBound.lean`
- *result records that name this place's file as a source* (computed; not a link): `open-form-realization-under-revision`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-16, as "RenewalBound.lean: no_renewal_free_tail, run_renewal_within_rank, period_two" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-16.md.txt)); pass b: reader whole-b-60, as "RenewalBound.lean: no_unrenewed_tail_of_accessible, no_renewal_free_tail, renewal_arbitrarily_late, renewal_within_rank_bound, run_renewal_arbitrarily_late, run_renewal_within_rank, alternation, every_score_bounded" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-60.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `no_renewal_free_tail` (l. 59) excludes an infinite tail without renewal if every unrenewed step descends a well-founded relation. `renewal_arbitrarily_late` (l. 83) constructs a renewal after every start given the positive disjunction of renewal or descent at each step.
  - *pass b:* For any sequence of configurations and for every run of every Process S A (general): where every step without renewal descends a well-founded relation, no tail is free of renewal and renewal recurs arbitrarily late. With a Nat rank and a decided renewal event, renewal comes from start within start + rank start. The built alternation (the run of Bool.not from true) restores arbitrarily late, has period two, passes through only its first two configurations, and keeps every score of configurations bounded.
- **moves**
  - *pass a:* S: `run_renewal_arbitrarily_late` (l. 146) gives a renewing state-action-state step arbitrarily late on any run on which every step outside the decidable renewal class descends a well-founded relation.
  - *pass b:* S: `run_no_renewal_free_tail` (l. 136), `run_renewal_arbitrarily_late` (l. 146) and `run_renewal_within_rank` (l. 157): for any run r : Run P of any Process S A and any class of steps renews, if every step of r outside the class descends a well-founded relation (or a rank), the run's steps fall in the class arbitrarily late (within the rank). This is a law about every run that meets the premise, not about a choice among steps.
- **a reading**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no law in which what is registered decides. `every_score_bounded` (l. 240, built): every score : Bool → Nat is bounded along the alternation.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* B: `restoration_raises_rank` (l. 219) shows a rise from zero to one at each restoring step of the Boolean run, and `unrenewed_first_step` (l. 227) exhibits a strict fall.
  - *pass b:* S: `renewal_within_rank_bound` (l. 101): with renewal decided and rank (n+1) \< rank n at every step without renewal, from start with rank start \<= bound, renewal occurs at some n with start \<= n \<= start + bound. The account (l. 10) says the rank is a certificate, 'not a universal stock'. B: `restoration_raises_rank` (l. 219): in the alternation, each restoration raises the rank from 0 to 1. N: nothing general in which what comes back depends on what is left.
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
  - *pass b:* N
- **a comparison between two**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a rank (an ending within a bound)**
  - *pass a:* S: `run_renewal_within_rank` (l. 157) places a decidable renewing step between start and start plus its state’s natural rank, endpoints included, if every unrenewed step on that run strictly lowers the rank.
  - *pass b:* S: `no_unrenewed_tail_of_accessible` (l. 47): from an Acc configuration no infinite unrenewed tail starts. `no_renewal_free_tail` (l. 59): with unrenewed well-founded and every non-renewal step descending, no tail is free of renewal. `renewal_arbitrarily_late` (l. 83), `renewal_arbitrarily_late_of_decidable` (l. 90), `renewal_within_rank_bound` (l. 101), `renewal_within_rank_plus_one_steps` (l. 117), `run_renewal_within_rank` (l. 157): a falling rank gives renewal within start + rank start. B: `nonrestoring_decreases` (l. 196), `unrenewed_first_step` (l. 227).
- **a closed region**
  - *pass a:* B: `no_new_configurations` (l. 232) puts every state on the alternation in the set of the first two states.
  - *pass b:* B: `no_new_configurations` (l. 232): the alternation stays among its first two configurations. `period_two` (l. 209): state (n+2) = state n. N: no general invariant or closed region.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* B: `actual_steps` (l. 188), `restores_arbitrarily_late` (l. 204) and `period_two` (l. 209) exhibit one continuing run alternating the two configurations, always with the same restoring edge.
  - *pass b:* B: `alternation` (l. 173) with `actual_steps` (l. 188), `restores_arbitrarily_late` (l. 204) and `period_two` (l. 209): the run goes on forever, alternating between a consuming step and a restoring step. `every_score_bounded` (l. 240) and the account (l. 24-28) say that this recurrence gives no unbounded novelty by any fixed score, so nothing more goes on after.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. I used statements for states, moves, rank. Built cases support level, closed_region, forms_change. No answer depends on the opening account or docstrings alone. I found no matching result for reading, share, giving, cost, multiplying, no_return, both_outcomes, comparison. I reached every question.
  - *pass b:* All statements and docstrings read (249 lines), and the account. Answered from statements: moves, level, rank. Built only: closed_region, forms_change. Not found: reading, share, giving, cost, multiplying, no_return, both_outcomes, comparison.
