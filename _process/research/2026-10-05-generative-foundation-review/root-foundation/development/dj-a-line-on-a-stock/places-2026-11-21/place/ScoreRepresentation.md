# ScoreRepresentation

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ScoreRepresentation.lean`
- *result records that name this place's file as a source* (computed; not a link): `protection-priority-excludes-uniform-aggregation`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-18, as "ScoreRepresentation.lean: every_nat_score_outranks, ratio_agrees, livingSignificance_leaves_ordering_open" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-18.md.txt)); pass b: reader whole-b-67, as "ScoreRepresentation.lean: above_iff, above_satisfies_comparison, never_outranked, comparison_does_not_yield_priority, every_nat_score_outranks, no_nat_score_represents, ratio_agrees, bounded_score_represents" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-67.md.txt)); the third pass, where the two differed: reader whole-c-settle-25, as "ScoreRepresentation.lean: settled fields reading, cost, rank, forms_change" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-25.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* B: `every_nat_score_outranks` (l. 148) shows that, on this frame, a natural-valued score strictly increasing on living extensions puts the alternative with score(0) + 2 gains above protection. `ratio_agrees` (l. 195) represents lexical priority on every pair by a bounded ratio.
  - *pass b:* In one built situation (alternative 0 keeps a protected basic condition, alternative k > 0 loses it and realizes k gains, as a frame with no moves), the lexical order satisfies the comparison condition C and never ranks gains above protection. Every natural-number score satisfying C ranks the alternative with score 0 + 2 gains above protection, so no such score represents the lexical order, while a bounded score (1 for protection, k/(k+1) for k gains) satisfies C and agrees with the lexical order on every pair; this is a built model, using the general Comparison.outgrows.
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: `frame` (l. 57) has no moves.
- **a reading**
  - *settled by the third pass:* N: every statement opened. `livingSignificance_recognizes_gains` (l.86): given `LivingSignificance frame living relevance`, `∀ k i, i < k → relevance k (.gain i)`; `relevance : Nat → Claim → Prop` is a parameter that `LivingSignificance` (Extension.lean l.55) requires to contain realized living claims. `livingSignificance_leaves_ordering_open` (l.162) states it holds beside two opposed orders, so nothing is decided by it. No observation or class read alike. [which pass was right: b; opened: `livingSignificance_recognizes_gains` (l.86), `livingSignificance_leaves_ordering_open` (l.162), `comparison_does_not_yield_priority` (l.139); `LivingSignificance` in Extension.lean (l.55).]
  - *pass a:* B: `livingSignificance_recognizes_gains` (l. 86) requires each realized gain to be relevant given living significance. `livingSignificance_leaves_ordering_open` (l. 162) admits opposed rankings with the same relevance.
  - *pass b:* N: no observation or rule made from what is registered. Scores (Nat → Nat) rank alternatives, and `no_nat_score_represents` (l. 154) says no natural-number score satisfying C represents the lexical order. That concerns representing an order, not registering.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: the protected basic condition is kept or lost (`realized`, l. 48), with no amount.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a cost to the one that keeps or gives**
  - *settled by the third pass:* N: opened `realized` (l.48): alternative `k` realizes `.basic` iff `k = 0` and `.gain i` iff `i < k`; so an alternative with gains lacks the protected condition. That is a trade between alternatives of a `frame` (l.57) whose step is `False`; no one keeps or gives, and nothing is spent by a doer. `never_outranked` (l.118) and `weighted` (l.123) are orders on the alternatives. [which pass was right: a; opened: `Claim` (l.44), `realized` (l.48), `frame` (l.57), `protect`/`gain` (l.59-60), `above_iff` (l.92), `never_outranked` (l.118), `weighted` (l.123).]
  - *pass a:* N: `realized` (l. 48) trades protection against gains across alternatives. No giver spends its standing or offspring on a step.
  - *pass b:* B: `realized` (l. 48): alternative k > 0 loses the basic condition and realizes k gains, a trade within the built situation. It is not a cost to an agent that does the keeping.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N for going on and ending. `above_iff` (l. 92) and `ratio_agrees` (l. 195) are exactly-whens of the order.
- **a comparison between two**
  - *pass a:* B: `ratio_agrees` (l. 195) transfers strict comparisons in both directions between the bounded score and the lexical order on these alternatives.
  - *pass b:* S: `Comparison` (C) ranks every generative extension above its base. `successor_extends` (l. 79): k+1 → k+2 is an extension. `above_satisfies_comparison` (l. 112). `weighted_satisfies_comparison` (l. 127). `ratio_agrees` (l. 195): the bounded score agrees with the lexical order on every pair.
- **a rank (an ending within a bound)**
  - *settled by the third pass:* S, in a different form (a rising score with a bound, nothing ending): `every_nat_score_outranks` (l.148): for `score : Nat → Nat` with `Comparison frame living fun s t => score s < score t`: `0 < score 0 + 2 ∧ score 0 < score (score 0 + 2)`, by `Comparison.outgrows` (Extension.lean l.100) along `successor_extends`. The bound is on which alternative outranks, not on steps of a course: the frame has no moves, no variant falls and nothing ends. `no_nat_score_represents` (l.154) follows. [which pass was right: both in part; opened: `successor_extends` (l.79), `every_nat_score_outranks` (l.148), `no_nat_score_represents` (l.154), `bounded_score_represents` (l.214); `Comparison.outgrows` in Extension.lean (l.100).]
  - *pass a:* N: Not found in the statements read.
  - *pass b:* S: `every_nat_score_outranks` (l. 148): every score : Nat → Nat satisfying C has score 0 \< score (score 0 + 2), by Comparison.outgrows along successor extensions, so gains outrank protection within the bound score 0 + 2.
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N.
- **forms change while the going on continues, or more can go on after**
  - *settled by the third pass:* B, in a weak form: `successor_extends` (l.79): `Extension frame living (k + 1) (k + 1 + 1)` for every `k`, where `Extension` (Extension.lean l.45) says the second configuration realizes every claim of the first and some living claim the first does not. An endless chain of widenings among alternatives; but `frame` (l.57) has step `fun _ _ _ => False`, so no course goes from one alternative to the next and nothing is said to go on. [which pass was right: both in part; opened: `frame` (l.57), `extension_shape` (l.63), `successor_extends` (l.79); `Extension` in Extension.lean (l.45).]
  - *pass a:* B: `successor_extends` (l. 79) gives a living extension from each k+1 to k+2. These are alternatives in the move-free `frame` (l. 57).
  - *pass b:* N.
- **how it was read**
  - *pass a:* Statements, their docstrings and the opening account were read throughout. Built cases for states, reading, comparison, forms_change. Not found for moves, share, level, giving, cost, multiplying, no_return, both_outcomes, rank, closed_region. All questions were reached.
  - *pass b:* Answered from statements: comparison and rank. Built cases: cost. N after reading every statement: the rest. Nothing unreached. Read: the whole module, lines 1–221.
