# FreeEnergyCounting

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/FreeEnergyCounting.lean`
- *result records that name this place's file as a source* (computed; not a link): `free-energy-bound-in-counts`, `free-energy-bounds-surprisal`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-05, as "FreeEnergyCounting.lean: bound, bound_eq_iff, given_record_eq_iff_share" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-05.md.txt)); pass b: reader whole-b-18, as "FreeEnergyCounting.lean: bound, bound_eq_iff, bound_lt_of_not_proportional, bound_given_record, given_record_eq_iff_share, Witness.total_two_unreached" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-18.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `bound` (l. 419) bounds N^N times the product of joint weights raised to their counts by A^N times the corresponding self-power product for arbitrary natural counts and weights on a list. `bound_eq_iff` (l. 516) characterizes equality exactly by each count times total weight equaling its weight times total count.
  - *pass b:* General: for natural counts n and weights a over any listed hypotheses, `N^N * ∏ a^n ≤ A^N * ∏ n^n` (`bound`), with equality exactly where the counts are proportional to the weights (`bound_eq_iff`) and strictness otherwise. This is the free-energy bound in counting form, an AM-GM inequality. Joined to the core's generative model: the total joint weight is the record's weight (`record_total`), and with hypotheses listed once, the count beliefs at the bound are exactly those matching each hypothesis's share given the record (`given_record_eq_iff_share`). The witnesses are built.
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a reading**
  - *pass a:* S: `given_record_eq_iff` (l. 569) identifies equality with proportionality to record-restricted joint weights for the supplied prior, likelihood, lists and record; `nothing_record_reach_all` (l. 582) gives equality for every belief when evidence is zero.
  - *pass b:* S: `given_record_eq_iff_share` (l. 598): with `Distinct hs`, the count belief n reaches the bound iff at every listed hypothesis n h over the total is the same ratio as the hypothesis's share given the record `rec`. `given_record_eq_iff` (l. 569): reaching the bound iff `n h * E = joint h * N`, E the record's weight. So the registered record decides which beliefs reach the bound. B: `Witness.duplicate_share` (l. 710): a hypothesis listed twice breaks the join.
- **a share**
  - *pass a:* S: `given_record_eq_iff_share` (l. 598) equates achieving the bound with matching each posterior share by count over total given distinct listed hypotheses and decidable equality. The posterior is determined by restriction to the record; there is no step resetting a rule from the attained shares.
  - *pass b:* S: counts over a total stand for shares n h / N (account l. 52), and the share given the record appears in `given_record_eq_iff_share` (l. 598). N: no rule or favouring is set again from the share; there is no step.
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
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N for going on or ending, keeping or losing. S: `bound_eq_iff` (l. 516) is an exactly-when of equality at the bound, and `bound_lt_of_not_proportional` (l. 522) gives strictness off proportion.
- **a comparison between two**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: `rearrange` (l. 103) is a rearrangement inequality of numbers, not a law carrying something between processes or starts.
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
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statements — states, reading, share. Not found — moves, level, giving, cost, multiplying, no_return, both_outcomes, comparison, rank, closed_region, forms_change. No answer rests on commentary alone; all questions were reached.
  - *pass b:* Every question was answered from statements (S or N). I read all statements and the opening account (729 lines); arithmetic proof bodies were not followed.
