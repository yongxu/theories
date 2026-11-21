# PairChance

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/PairChance.lean`
- *result records that name this place's file as a source* (computed; not a link): `errors-by-chance-in-a-pair-keeping-mutual-withholding`
- *dynamics in the atlas that name one of those records* (computed; not a link): `errors-by-chance-in-a-pair-keeping-mutual-withholding`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-13, as "PairChance.lean: burst_absorbs, absorbed_share, dead_stays" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-13.md.txt)); pass b: reader whole-b-47, as "PairChance.lean: PairChance.KeepsWithheld, PairChance.burst_absorbs, PairChance.dead_stays, PairChance.err_withholds, PairChance.still_gives_free, PairChance.absorbed_share, PairChance.window_witness" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-47.md.txt)); the third pass, where the two differed: reader whole-c-settle-18, as "PairChance.lean: settled fields moves, giving, both_outcomes, comparison" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-18.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: For any two laws preserving mutual withholding, four errors across two consecutive steps end giving from the first of those steps (l. 93). With natural error and non-error weights p and q, `absorbed_share` (l. 342) bounds the weight of courses still giving after k blocks.
  - *pass b:* S: For every pair of laws of giving that keep mutual withholding (`KeepsWithheld`, l. 55), in PairSelection's pair run with one-way errors, two consecutive steps at which both formations err make the pair withhold at every step from then on, whatever the later errors (`burst_absorbs`, l. 93). With errors read from a weighted course of `4k` Booleans, the courses under which a formation still gives at step `2k` weigh at most `((p + q)^4 - p^4)^k` out of `((p + q)^4)^k` (`absorbed_share`, l. 342). These are general over that class of laws within one run model, with a built count (`window_witness`).
- **moves**
  - *settled by the third pass:* S, in a weaker form: `burst_absorbs_from` (l.112): for every `f g : PairLaw` with `KeepsWithheld f`, `KeepsWithheld g`, every `e : Errors` with both formations erring at `t + 1` and `t + 2`, and every `m ≥ t + 1`, `∀ a, gives f g e a m = false`. A `PairLaw` (PairSelection l.216, `Lags → Lags → Bool`) is a rule of giving read from the last two steps, and the law holds of every pair of such rules in the class; but the rule is a parameter fixed for the run, the course is `Run (Law.process (step f g e))` (PairSelection l.243), and there is no choice among steps and no `Process S A` with moves. [which pass was right: both in part; opened: KeepsWithheld l.55, dead_stays l.83, burst_absorbs l.93, burst_absorbs_from l.112, PairSelection.PairLaw l.216, step l.238, course l.243]
  - *pass a:* S: `burst_absorbs_from` (l. 112) covers all pairs of giving policies satisfying `KeepsWithheld` and all errors after a joint two-step burst. Both withhold from the first burst step onward.
  - *pass b:* N: The pair laws (`PairLaw`) are deterministic functions of lags, and errors are supplied. There is no choice among steps. The laws are quantified over the class `KeepsWithheld`, not chosen in a run.
- **a reading**
  - *pass a:* S: `KeepsWithheld` (l. 55) specifies the law’s output on two all-false histories. `dead_stays` (l. 83) proves that reading those histories preserves them for such laws.
  - *pass b:* S: `KeepsWithheld` (l. 55): a law is read on the registered lags of the last two steps, and on `(false, false) (false, false)` it withholds. `dead_stays` (l. 83): where both formations withheld at their last two steps, laws keeping mutual withholding keep it, for any errors. `not_keeps_agreeing`/`sparing`/`alternating` (l. 63-65): those laws give after mutual withholding.
- **a share**
  - *pass a:* S: `absorbed_share` (l. 342) bounds the weighted share still giving using fixed p,q and fixed laws. No rule update from that share is stated.
  - *pass b:* S: `absorbed_share` (l. 342) and `still_giving_le` (l. 314): the weighted share of courses still giving at step `2k` is bounded by `S^k`, with `S = total (courses 4) (survive p q) = (p + q)^4 - p^4` (`block_free_weight`, l. 303). N: no rule or favouring is set again from this share.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: No stock or reserve that runs down.
- **a giving that is itself a going-on**
  - *settled by the third pass:* S, in part: `burst_absorbs` (l.93): under `KeepsWithheld f`, `KeepsWithheld g` and both formations erring at `t + 1` and `t + 2`, `∀ k, gives f g e first (t + 1 + k) = false ∧ gives f g e second (t + 1 + k) = false`. The giving is done by the two formations of the pair (`first`, `second`) and is lost for every later step, concluded. But this module has no level or condition that the giving feeds (the tallies `received`, `offspring` are PairSelection's), the formations themselves are not lost, and the laws `f`, `g` and the errors `e` are handed in. [which pass was right: both in part; opened: err_withholds l.68, dead_stays l.83, burst_absorbs l.93, stillGives l.308, absorbed_share l.342]
  - *pass a:* S: `burst_absorbs` (l. 93) proves permanent loss of both formations’ giving after the burst for withholding-preserving laws. The pair itself persists.
  - *pass b:* N: Nothing gives to a level. The errors and laws are handed in.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: No cost to the one that keeps or gives.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: No units leaving units.
- **a point of no return**
  - *pass a:* S: `burst_absorbs` (l. 93) concludes irreversibility of lost giving from the two-law and four-error premises.
  - *pass b:* S: `burst_absorbs` (l. 93) / `burst_absorbs_from` (l. 112): where both formations err at `t + 1` and `t + 2`, a pair of `KeepsWithheld` laws withholds at every step from `t + 1` on, whatever the errors after. This is concluded from the premise `KeepsWithheld` and from `err_withholds` (l. 68, concluded: an error only withholds). The loss is of the pair's mutual giving itself, the giving between them.
- **both outcomes**
  - *settled by the third pass:* N: `still_gives_free` (l.173; premises `KeepsWithheld f`, `KeepsWithheld g`, `w.length = 4 * k`, `gives f g (errorsOf w) a (2 * k) = true`) concludes `burstFree w = true`: one direction only, the contrapositive of `burst_absorbs_from` on errors read from a course. `window_witness` (l.359) states the two totals 12 and 15 for the pair of windows, which shows the converse fails in that case. `absorbed_share` (l.342) is an upper bound on a weight. No exactly-when and no dichotomy was found. [which pass was right: b; opened: still_gives_free l.173, burst_of_not_free l.151, still_giving_le l.314, absorbed_share l.342, window_witness l.359, block_total l.286]
  - *pass a:* B: `window_witness` (l. 359) counts 12 unit-weight four-bit words with giving at step two for a window pair. The survival bound counts 15 burst-free words, so burst-freedom alone does not characterize continued giving.
  - *pass b:* N: No exactly-when of going on versus ending. `still_gives_free` (l. 173) is one direction only: still giving at `2k` implies no block is all errors.
- **a comparison between two**
  - *settled by the third pass:* N: `still_gives_free` (l.173) is an implication from still giving at step `2 k` to `burstFree w`, for one pair of laws and one course of errors; it carries nothing between two processes, two starts or two ways. `burst_absorbs` (l.93) holds 'whatever the errors after' by quantifying over `e`, not by comparing two runs. `still_giving_le` (l.314) and `absorbed_share` (l.342) bound a total weight. No simulation, kept order, covering or dominating move was found. [which pass was right: b; opened: still_gives_free l.173, burst_absorbs l.93, burst_absorbs_from l.112, still_giving_le l.314, absorbed_share l.342]
  - *pass a:* S: `still_gives_free` (l. 173) includes the length-4k error words under which a member still gives at 2k within the burst-free words, for both laws keeping withholding.
  - *pass b:* N: No law carrying something between two processes or starts.
- **a rank (an ending within a bound)**
  - *pass a:* S: `absorbed_share` (l. 342) bounds surviving weight by ((p+q)^4−p^4)^k, out of ((p+q)^4)^k. This bounds weight, with no finite deadline for every course.
  - *pass b:* S (partly): `absorbed_share` (l. 342): the bound `((p + q)^4 - p^4)^k` on the still-giving weight, with `(p + q)^4 - p^4 < (p + q)^4` where `0 < p`, so the bound on the share falls geometrically in `k`. D: the account says that 'read as a share, at most (1 - r^4)^k' is by hand. N: no rank or variant that falls along a run.
- **a closed region**
  - *pass a:* S: `dead_stays` (l. 83) proves the all-withheld memory region closed under every error when both laws keep mutual withholding.
  - *pass b:* S: `dead_stays` (l. 83): the states whose two lags are both `(false, false)` are mapped into themselves by `step f g e` for `KeepsWithheld` laws and any errors, an absorbing region. `burst_absorbs` (l. 93) shows it is entered after a two-step burst.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: No statement or built case of the going on continuing while what is present changes, or of widening.
- **how it was read**
  - *pass a:* S: Read the opening account, every declaration statement and its docstring. Statements — states, moves, reading, share, giving, no_return, comparison, rank, closed_region. Built cases — both_outcomes. Not found — level, cost, multiplying, forms_change. No answer rests on commentary alone or was left unreached.
  - *pass b:* Read the whole module: the account and every statement, with PairSelection's `PairLaw`, `Errors` and `gives` looked up. Q3, 4, 9, 12 and 13 are answered from statements, Q12 in part from the account, and the rest are N.
