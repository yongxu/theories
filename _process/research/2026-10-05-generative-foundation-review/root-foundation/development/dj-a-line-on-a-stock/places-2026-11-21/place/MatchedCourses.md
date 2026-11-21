# MatchedCourses

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/MatchedCourses.lean`
- *result records that name this place's file as a source* (computed; not a link): `finite-aggregation-within-restorable-basic-losses`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-11, as "MatchedCourses.lean: matches_iff, reads_at_time, first_losses_retained" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-11.md.txt)); pass b: reader whole-b-40, as "MatchedCourses.lean: process, frame, a_matches_b1, b3_matches_a, matches_iff, lost_counts, conditional_outer_order, fragile_b3_matches_nothing, reads_at_time, first_losses_retained" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-40.md.txt)); the third pass, where the two differed: reader whole-c-settle-15, as "MatchedCourses.lean: settled fields both_outcomes, closed_region" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-15.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* B: In the four-move process `matches_iff` (l. 326) identifies strict matching of final states with a smaller loss count when the base is nonfragile and all non-base claims are read alike. `reads_at_time` (l. 379) ties each position claim on each course to the support of its position when due.
  - *pass b:* A built process: four moves, each installed once from one start, cover claims of four positions resting on a base, and a claim is realized once its time has come while the base holds and the move covers it. Under the premise BasicAlike, a strictly matches b1 and b3 strictly matches a, and a strict match between courses exists exactly when the better loses fewer claims (3, 4, 3, 2). The fragile b3 loses the base and matches nothing, and claims missed at their time stay missed after support returns. Everything is of this one model, with the content relation and the sufficiency of matching as premises.
- **moves**
  - *pass a:* B: `process` (l. 90) installs a move once. `fragile_a_keeps_base` (l. 284) and `fragile_b3_loses_base` (l. 282) distinguish two choices from the common start under the fragile law.
  - *pass b:* B: `process` (l. 90) is a Process State Move with four moves. `advance` (l. 85) installs the first move once and later steps keep it. Each course `run fragile m` (l. 96) takes one move throughout. `lost_counts` (l. 330): a loses 3 claims, b1 4, b2 3, b3 2. `conditional_outer_order` (l. 272): under sufficiency and transitivity, the b3 course is strictly above b1.
- **a reading**
  - *pass a:* B: `claim_iff_support` (l. 189) makes final realization of a position claim equivalent to support at its own time in that course.
  - *pass b:* B: `BasicAlike` (l. 165), a premise reading the non-base claims as alike. `matches_iff` (l. 326): under it, a strict match between courses x and y iff lostCount x \< lostCount y. `reads_at_time` (l. 379): every claim of a position is read at its time by `Supported`.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: `lostCount` (l. 312) is a count; nothing is set again from it.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no amount. B: the base is a Bool (l. 73), cut by b3 under the fragile law (`baseAfter` l. 78, `fragile_b3_loses_base` l. 282) and not restored afterwards (`advance` keeps s.base).
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: the base is a field of the state, not a going-on of the model.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a point of no return**
  - *pass a:* B: `first_losses_retained` (l. 393) concludes that both p claims remain unrealized from time 3 on the nonfragile b3 course. `support_restored` (l. 185) gives final support even there.
  - *pass b:* B: `first_losses_retained` (l. 393): under b3, non-fragile, claims first and second are not realized at any t ≥ 3. `recovery_retains_loss` (l. 194): support for p has returned at the end, yet both are missed. This is concluded in the model from `reads_at_time` (l. 379). It is at the level of claims. B: `fragile_b3_matches_nothing` (l. 347): losing the base, on which every claim rests, leaves b3 matching no course under any content relation.
- **both outcomes**
  - *settled by the third pass:* B: `realized_succ` (l. 361): for every `fragile`, `m`, `c`, `t`, `(frame fragile).realized (states fragile m (t + 1)) c ↔ (time c ≤ t + 1 ∧ baseAfter fragile m = true ∧ covers (some m) c = true)`; an exactly-when of a claim being realized or not along each built course. With `reads_at_time` (l. 379) and `first_losses_retained` (l. 393). `matches_iff` (l. 326) is of matching. [which pass was right: a; opened: frame l. 133; claim_iff_support l. 189; recovery_retains_loss l. 194; matches_iff l. 326; states_succ l. 356; realized_succ l. 361; reads_at_time l. 379; first_losses_retained l. 393.]
  - *pass a:* B: `realized_succ` (l. 361) characterizes realization at every positive time by the deadline having been reached, the base holding after installation, and the installed move covering the claim.
  - *pass b:* N: no dichotomy of going on and ending. `matches_iff` (l. 326) is an exactly-when of matching.
- **a comparison between two**
  - *pass a:* B: `b2_loss_correspondence` (l. 250) carries each loss under a to exactly the corresponding loss under b2 by swapB2 with the nonfragile base.
  - *pass b:* B: strict loss matches between courses of one process: `a_matches_b1` (l. 209), `b3_matches_a` (l. 230), `b2_a_neither` (l. 334), `fragile_b3_not_matching` (l. 287) under BaseApart, and `a_b1_not_extension` (l. 341), a match without extension. `conditional_lower_anchor` (l. 259) and `conditional_upper_anchor` (l. 265) hold under `SufficientMatching`.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a closed region**
  - *settled by the third pass:* B: `states_succ` (l. 356): for every `fragile`, `m`, `t`, `states fragile m (t + 1) = ⟨t + 1, some m, baseAfter fragile m⟩`; the installed move and the base flag are the same at every positive time of the built course. Stated as an explicit formula for the state, not as closure of a region under `advance` for every move. [which pass was right: a; opened: advance l. 85; process l. 90; states l. 92; states_succ l. 356.]
  - *pass a:* B: `states_succ` (l. 356) proves installation and the base flag stay fixed for all positive times on each course.
  - *pass b:* N
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: I read the opening account, every declaration statement and the docstrings. Built cases — states, moves, reading, no_return, both_outcomes, comparison, closed_region. Not found — share, level, giving, cost, multiplying, rank, forms_change. No commentary-only answers. All questions were reached.
  - *pass b:* All statements and docstrings read to the end (l. 401). moves, reading, no_return and comparison are answered from built statements (B); the rest are N.
