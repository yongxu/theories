# IntegerOrder

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/IntegerOrder.lean`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-08, as "IntegerOrder.lean: le_iff, lt_or_le, add_le_add_right" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-08.md.txt)); pass b: reader whole-b-29, as "IntegerOrder.lean: nonneg_add, nonneg_or_neg, nonneg_pred_or, lt_or_le, le_trans, le_antisymm, add_le_add, le_of_add_le_add_left" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-29.md.txt)); the third pass, where the two differed: reader whole-c-settle-10, as "IntegerOrder.lean: settled fields comparison" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-10.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: For any integers a and b, a ≤ b iff b + (−a) is nonnegative, and either a \< b or b ≤ a (le_iff, l. 66, lt_or_le, l. 137). Addition preserves and reflects order under a common summand (add_le_add_right, l. 168, le_of_add_le_add_right, l. 176).
  - *pass b:* The module states the order laws of Int constructively, with no premise: a ≤ b as Int.NonNeg (b + -a), resting on a sum of naturals being natural (nonneg_add), an integer or its negative being natural (nonneg_or_neg) and one step down staying natural (nonneg_pred_or). These are general arithmetic laws (reflexivity, transitivity, antisymmetry, lt_or_le, le_total, the addition and difference laws), not of any process or built model.
- **moves**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no process or choice among steps.
- **a reading**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no reading or observation.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no share.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no level that runs down.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: nothing gives.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no cost.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no units leaving units.
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no irreversibility.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: `lt_or_le` (l. 137) is a dichotomy of integer order (a \< b or b ≤ a), not of going on and ending, or of keeping and losing.
- **a comparison between two**
  - *settled by the third pass:* N: opened `add_le_add` (l. 160), `add_le_add_left` (l. 165), `le_of_add_le_add_left` (l. 171), `le_trans` (l. 103), `sub_le_sub_left` (l. 192). `add_le_add` states `a ≤ b → c ≤ d → a + c ≤ b + d` for `Int`. The module has no process, start or step; nothing is carried between two processes, two starts or two ways. Both passes read the same statement the same way and differ only in the letter. [which pass was right: b; opened: add_le_add l.160; add_le_add_left l.165; add_le_add_right l.168; le_of_add_le_add_left l.171; le_trans l.103; le_total l.153; sub_le_sub_left l.192; opening account l.3-25]
  - *pass a:* S: add_le_add (l. 160) carries a ≤ b and c ≤ d to a+c ≤ b+d for arbitrary integers. This comparison is arithmetic.
  - *pass b:* N: no law carries anything between two processes; the order laws `add_le_add` (l. 160) and `le_of_add_le_add_left` (l. 171) are arithmetic.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no rank, variant or bound on ending.
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: no region closed under steps.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: nothing continues while what is present changes.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. General statements support states, comparison. I found no matching statement for moves, reading, share, level, giving, cost, multiplying, no_return, both_outcomes, rank, closed_region, forms_change. No answer rests on prose alone or was unreached.
  - *pass b:* All 211 lines and every statement read. Only states is answered, from statements; all the rest are N.
