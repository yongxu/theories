# JoiningContexts

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/JoiningContexts.lean`
- *result records that name this place's file as a source* (computed; not a link): `functional-joining-common-structure`, `wisdom-root`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-08, as "JoiningContexts.lean: ContextSame.iff_sameTests, Compatible.realizes, contextSame_iff_compatible" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-08.md.txt)); pass b: reader whole-b-30, as "JoiningContexts.lean: Context, Context.Realizes, ContextSame, ContextSame.iff_sameTests, Context.realizes_splice, ContextSame.composable_iff, ContextSame.joined, Compatible.realizes, contextSame_iff_compatible" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-30.md.txt)); the third pass, where the two differed: reader whole-c-settle-11, as "JoiningContexts.lean: settled fields both_outcomes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-11.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: For any joining, agreement about which finite joining contexts are possible equals agreement on the frame's tests (ContextSame.iff_sameTests, l. 247). For functional joinings, two fragments agree on contexts iff some compatible relation relates them (contextSame_iff_compatible, l. 211).
  - *pass b:* For every joining, a context (an arrangement of partners around a hole) is a course of moves of the joining's frame, and two fragments agree on contexts exactly where they pass the same tests of the frame (`ContextSame.iff_sameTests`). Contexts compose (`Context.realizes_splice`); fragments agreeing on contexts join alike (`ContextSame.composable_iff`); and, where joining is functional, agreeing on contexts is the largest relation compatible with the joining (`contextSame_iff_compatible`). General; the account says the module is a port, a restatement and not a new result.
- **moves**
  - *pass a:* S: Context.realizes_extend (l. 224) equates realizing an extended context with a trace of the chosen partner moves from an intermediate outcome.
  - *pass b:* S: `Context.course` (l. 49) is a course of `Move F` of the frame; `Context.Realizes` (l. 55) is a trace of it. `Compatible.realizes` (l. 180): a relation compatible with the joining carries every context both ways, matching what each related fragment realizes with related results. `Context.realizes_functional` (l. 112): where functional, a context realizes at most one fragment.
- **a reading**
  - *pass a:* S: ContextSame.composable_iff (l. 151) says substituting context-equivalent fragments at both inputs preserves and reflects composability.
  - *pass b:* S: `ContextSame` (l. 61) classes fragments by which contexts are possible. `ContextSame.composable_iff` (l. 151): fragments agreeing on contexts are composable alike. `ContextSame.joined` (l. 167) and `ContextSame.realized` (l. 159), both where functional: what they join into or what one context realizes from them agrees on contexts. `ContextSame.iff_sameTests` (l. 247).
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a level that runs down**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a cost to the one that keeps or gives**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a point of no return**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **both outcomes**
  - *settled by the third pass:* N: `Context.possible_splice` (l. 105), for every `J : Joining F`, contexts `outer inner` and `x`, states `(outer.splice inner).Possible J x ↔ ∃ y, inner.Realizes J x y ∧ outer.Possible J y`; a law of composing contexts (whether a finite course of joinings realizes something), not a dichotomy of going on and ending or keeping and losing. Opened to rule it out: `Context.possible_splice` (l. 105), `Context.realizes_splice` (l. 98), `Context.possible_splice_of_realizes` (l. 118), `Context.possible_right` (l. 137), `Context.possible_left` (l. 144). [which pass was right: b; opened: Context.Possible l.58; Context.realizes_splice l.98; Context.possible_splice l.105; Context.possible_splice_of_realizes l.118; Context.possible_right l.137; Context.possible_left l.144]
  - *pass a:* S: Context.possible_splice (l. 105) gives feasibility of continuing a specified inner context with a specified outer context iff some inner outcome admits the outer.
  - *pass b:* N: no exactly-when of going on and ending; the exactly-whens are about contexts (`Context.possible_right` l. 137, `Context.possible_left` l. 144, `ContextSame.iff_sameTests` l. 247).
- **a comparison between two**
  - *pass a:* S: Compatible.realizes (l. 180) matches every realized outcome in either direction across compatible starts by a related outcome in the same context.
  - *pass b:* S: `Compatible.realizes` (l. 180) carries contexts between related fragments. `Compatible.contextSame` (l. 190): a compatible relation relates only fragments agreeing on contexts. `contextSame_iff_compatible` (l. 211): where functional, fragments agree on contexts iff some compatible relation relates them. `Context.realizes_splice` (l. 98) and `Context.possible_splice_of_realizes` (l. 118) compose contexts.
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **a closed region**
  - *pass a:* S: ContextSame.joined (l. 167) preserves context agreement under paired actual joins when both input pairs agree and joining is functional.
  - *pass b:* S: `ContextSame.compatible` (l. 198): where joining is functional, `ContextSame J` is compatible with the joining (closed under joining a partner on either side), and by `contextSame_iff_compatible` (l. 211) it contains every compatible relation. A largest closed relation, not a region of configurations.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: not found.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. General statements support states, moves, reading, both_outcomes, comparison, closed_region. I found no matching statement for share, level, giving, cost, multiplying, no_return, rank, forms_change. No answer rests on prose alone or was unreached.
  - *pass b:* Whole module read, all statements and proofs; all fourteen answered from statements; nothing unreached.
