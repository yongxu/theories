# ListFootprints

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ListFootprints.lean`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-10, as "ListFootprints.lean: realizes_iff_supports, realizes_iff_of_perm, realizes_reassociate" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-10.md.txt)); pass b: reader whole-b-37, as "ListFootprints.lean: realizes_iff_supports, realizes_of_supports, realizes_iff_of_draws, realizes_reassociate, realizes_iff_of_perm, joint, support" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-37.md.txt)); the third pass, where the two differed: reader whole-c-settle-14, as "ListFootprints.lean: settled fields both_outcomes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-14.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* Support of the leaves' combined draws characterizes realization of every `JointPlan` in the list model with disjoint parts inside their whole (`realizes_iff_supports`, l. 99). Permuting those draws preserves realization at every list (`realizes_iff_of_perm`, l. 117).
  - *pass b:* S: A built instance, with lists as configurations, of the general `JointPlan` footprint laws. `realizes_iff_supports` (l.99): a list realizes a plan iff it supports what the plan's leaves draw on (the draws repeat nothing and lie within the list). It follows that plans with the same, reassociated or reordered draws are realized at the same lists (l.104, l.111, l.117).
- **moves**
  - *pass a:* S: `realizes_reassociate` (l. 111) preserves realizability under either bracketing of three plans at any root list. The choices here are joint plans.
  - *pass b:* S: Plans are present (`JointPlan (List R)`, leaves and pairs). `realizes_iff_supports` (l.99) says where a plan is realized, not what a choice keeps. There is no stepwise process.
- **a reading**
  - *pass a:* S: `realizes_iff_of_draws` (l. 104) equates realization of two plans at the same root list whenever their lists of leaf draws agree.
  - *pass b:* S: `realizes_iff_of_draws` (l.104): plans with equal `draws` are realized at the same lists. Realization reads only what the leaves draw on.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: none found. S, for what is nearest: `joint` (l.39) and `parts_apart` (l.47) say the two parts share no member, and `realizes_of_supports` (l.85) needs draws without repetition. A member drawn on twice is supported nowhere. This is exclusivity, not a cost to a doer.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **both outcomes**
  - *settled by the third pass:* N. `realizes_iff_supports` (l.99), variable `{R : Type u}` (l.32): for every `p : JointPlan (List R)` and `s : List R`, `JointPlan.Realizes joint (Supports support) s p ↔ Supports support s p.draws`. It is an exact criterion for whether a list realizes a plan; no step, course, going on, ending, keeping or losing is in it or in any other statement of the module. Opened to rule out: the whole module (all eleven declarations). [which pass was right: b; opened: support l.35; joint l.39; parts_within l.43; parts_apart l.47; nodup_split l.51; nodup_of_perm l.66; realizes_of_supports l.85; realizes_iff_supports l.99; realizes_iff_of_draws l.104; realizes_reassociate l.111; realizes_iff_of_perm l.117]
  - *pass a:* S: `realizes_iff_supports` (l. 99) is an exact feasibility criterion for any plan in this list model: it is realized at s iff s supports its draws. This is a single plan, without a temporal continuation law.
  - *pass b:* N: `realizes_iff_supports` is an iff of realized and supported, not of going on and ending.
- **a comparison between two**
  - *pass a:* S: `realizes_iff_of_perm` (l. 117) transfers realization in both directions between plans whenever their draws are permutations.
  - *pass b:* S: `realizes_iff_of_draws` (l.104), `realizes_reassociate` (l.111) and `realizes_iff_of_perm` (l.117) carry realization between two plans with equal, reassociated or permuted draws. `nodup_of_perm` (l.66): reordering keeps a list free of repetition.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a closed region**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* Surveyed the opening account and every declaration's statement and docstring. General statements answer moves, reading, both_outcomes, comparison. The headline is from statements. No matching result was found for share, level, giving, cost, multiplying, no_return, rank, closed_region, forms_change. All questions were reached.
  - *pass b:* All statements and docstrings read (130 lines), with the account. All fourteen answered from statements.
