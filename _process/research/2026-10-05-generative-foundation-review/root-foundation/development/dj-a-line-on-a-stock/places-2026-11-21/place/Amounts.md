# Amounts

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Amounts.lean`
- *result records that name this place's file as a source* (computed; not a link): `a-step-coupling-keeps-at-every-horizon`, `a-weighting-faster-than-renewal-ends-the-base`, `coupled-regimes`, `coupled-webs`, `horizon-optima-hold-the-greatest-renewal`, `keeping-forgoes-the-renewal-at-the-need`, `least-loss-rest`, `merge-of-a-part-kept-by-the-rest`, `more-needs-renewers`, `others-drawing-first-end-the-base`, `re-optimizing-above-a-renewal-ends-it`, `regime-in-any-amounts`, `rest-by-balance`, `rest-exactly-where-falls-stop`, `rest-from-a-finite-reading`, `rest-theorem-in-any-amounts`, `shared-laws-on-the-grammar`, `the-world-represented-both-ways`, `where-the-possible-grows`
- *dynamics in the atlas that name one of those records* (computed; not a link): `a-cascade-along-total-dependence`, `a-course-that-only-returns`, `a-step-coupling-keeps-at-every-horizon`, `a-weighting-faster-than-renewal-ends-the-base`, `falls-that-end-do-not-recur`, `horizon-optima-hold-the-greatest-renewal`, `keeping-forgoes-the-renewal-at-the-need`, `least-loss-rest`, `more-needs-renewers`, `others-drawing-first-end-the-base`, `overcompensating-giving-cycles`, `re-optimizing-above-a-renewal-ends-it`, `regime-in-any-amounts`, `rest-exactly-where-falls-stop`, `rule-raised-every-other-step`, `support-beyond-a-band-can-cycle`, `where-the-possible-grows`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-01, as "Amounts.lean: losses_within, approaches_rest, unmarked_within, le_by_exchange" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-01.md.txt)); pass b: reader whole-b-01, as "Amounts.lean: Amounts, losses_within, falls_end, rests_unrefuted, rests, rests_of_archimedean, family_rests, replenishment_unbounded, approaches_rest, falls_by_stretch, unmarked_within, le_by_exchange" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-01.md.txt)); the third pass, where the two differed: reader whole-c-settle-01, as "Amounts.lean: settled fields multiplying, no_return, closed_region" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-01.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* For any Amounts, stock remaining plus accumulated losses is bounded by initial stock if each step obeys the loss inequality (`losses_within`, l. 158). For Archimedean amounts, losses above each fixed positive threshold cannot recur under that inequality (`approaches_rest`, l. 381).
  - *pass b:* General laws over any ordered additive amounts (`Amounts A`, possibly dense). Losses of a falling stock are summable within it. A least loss ε with the stock within fewer than m copies of ε brings rest (marked steps do not recur), and in Archimedean amounts a least loss alone does, with the same for a family balanced and dissipated on. More without end needs replenishment beyond every multiple of a least take. In whole numbers: falls by a stretch's length, an unmarked step within S + q S, and two balanced counts comparing by their exchanges.
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a reading**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* S: `family_loses` (l. 247) derives a fall of at least ε on marked steps from the balance inequality and replenishment plus ε within uptake. Replenishment is supplied as a time series.
  - *pass b:* S: `family_rests` (l.263): stock s, uptake u, replenishment r; balance s(t+1)+u ≤ s t + r, dissipation r ≤ u, at P-steps r+ε ≤ u, and s T within fewer than m copies of ε give: P-steps do not recur. `losses_within` (l.158): the losses added are within the stock at T. The stock runs down, but what comes back (r) is a handed-in sequence: no statement makes return depend on what is left.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: the replenishment r and uptake u are handed-in functions.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **multiplying**
  - *settled by the third pass:* N: opened `replenishment_unbounded` (l.290): in Archimedean amounts with `¬ M.le ε M.zero`, balance from T₀ and `∀ m, ∃ T, ∀ t, T ≤ t → M.le (M.times m ε) (u t)`, no b has `∀ t, T₀ ≤ t → M.le (r t) (M.times b ε)`. The statement is about amounts s, u, r only; 'at least m formations take at least ε each' is in the docstring alone (D), and no units leave units. Also opened `family_rests` (l.263). [which pass was right: a; opened: replenishment_unbounded l.290, family_rests l.263, family_rests_of_archimedean l.273, structure Amounts l.85]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* D/S: `replenishment_unbounded` (l.290) states that where the uptake from some step on is at least m copies of ε for every m, no bound of b copies of ε holds of the replenishment. Only its docstring reads this as 'at least m formations take at least ε each'. No units leave units.
- **a point of no return**
  - *settled by the third pass:* S (different form): `rests` (l.219): with `still : ∀ t, T ≤ t → M.le (s (t + 1)) (s t)`, `loses : ∀ t, T ≤ t → P t → M.le (M.add (s (t + 1)) ε) (s t)` and `¬ M.le (M.times m ε) (s T)`, it concludes `¬ ∀ N, ∃ t, N ≤ t ∧ P t`; `rests_of_archimedean` (l.229) needs only `¬ M.le ε M.zero`. What is concluded is that steps at which P holds do not recur (a rest); the not rising again is the premise `still`, and no point from which something cannot be kept is stated. [which pass was right: both in part; opened: rests_unrefuted l.208, rests l.219, rests_of_archimedean l.229, falls_end l.195, loses_times l.171, family_rests l.263, approaches_rest l.381]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* S (concluded, at a low level): `rests` (l.219) and `rests_unrefuted` (l.208): under no rise, a least fall ε at P-steps and the stock within fewer than m copies of ε, steps at which P holds do not recur. `rests_of_archimedean` (l.229) needs only ε above nothing. It is rest of the stock, not the loss of a giver.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no exactly-when of going on and ending. `unmarked_or_marked` (l.506) is a decided dichotomy of marks only.
- **a comparison between two**
  - *pass a:* S: `le_by_exchange` (l. 537) carries the initial ordering of two balanced natural counts across a stretch if at every step first gain plus second loss ≤ second gain plus first loss.
  - *pass b:* S: `le_by_exchange` (l.537): two counts balanced across a stretch, the first starting within the second, where at each step the first's gain with the second's loss is within the second's gain with the first's loss: the first ends within the second. `times_le` (l.142).
- **a rank (an ending within a bound)**
  - *pass a:* S: `falls_end` (l. 195) concludes ending of nonrise-then-least-fall courses when m copies of ε do not fit the start. `unmarked_within` (l. 522) gives an unmarked step by S + q S for decidable marks, natural balance and unit excess loss at every mark.
  - *pass b:* S: `falls_end` (l.195): within fewer than m least losses every course of no rise then a fall by ε ends («尽»). `few_large_losses` (l.363): fewer than m steps lose at least ε. `whole_losing_steps` (l.425): k ≤ s T. `falls_by_stretch` (l.493): q(S+n) + n ≤ q S. `unmarked_within` (l.522): an unmarked step N with S ≤ N ≤ S + q S, a deadline.
- **a closed region**
  - *settled by the third pass:* S (weaker form): `still_within` (l.310): where `∀ t, T ≤ t → M.le (s (t + 1)) (s t)`, then `∀ k u, T ≤ u → M.le (s (u + k)) (s u)`: from stepwise not rising, the amount stays within its value at every earlier step from T on. It is an order kept along one course, from a stepwise premise; no region is named as closed, and there is no kernel, certificate or fixed point. [which pass was right: both in part; opened: still_within l.310, still_le l.148, still_of_falls l.317, losses_within l.158]
  - *pass a:* S: `still_within` (l. 310) keeps every later stock below each earlier stock from T under stepwise nonrise.
  - *pass b:* N
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* Read the opening account, all docstrings and all declaration statements. Statements support states and level, comparison, rank, closed_region. The remaining fields are N. None were unreached.
  - *pass b:* Answered from statements, except the units reading under multiplying (D, its docstring). All statements were read, the whole module (564 lines).
