# HistoryLanguages

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/HistoryLanguages.lean`
- *result records that name this place's file as a source* (computed; not a link): `a-history-read-off-its-finite-stretches`, `derived-history-law-exactness`, `what-a-summary-keeps`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-07, as "HistoryLanguages.lean: trace_iff, realizes_feasible, stable_iff_letterwise, latch_obstruction, gate_formation" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-07.md.txt)); pass b: reader whole-b-26, as "HistoryLanguages.lean: PrefixClosed, law, feasible_iff, realizes_feasible, SameFuture, stable_iff_letterwise, latch_changes_profile_and_continues, gate_gains_profile" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-26.md.txt)); the third pass, where the two differed: reader whole-c-settle-10, as "HistoryLanguages.lean: settled fields rank" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-10.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `realizes_feasible` (l. 113) realizes the feasible language of any process from any start by using its feasible histories as configurations. `stable_iff_letterwise` (l. 212) says that a prefix-closed language admitting the empty word keeps its future profile after every admitted history exactly when it admits precisely the words whose individual letters it admits.
  - *pass b:* S, general: a prefix-closed language that admits the empty word is realized from the empty history by the law of its histories (`feasible_iff`, l. 97). Every process's feasible words are such a language, realized this way (`realizes_feasible`, l. 113). A history's continuation profile updates by concatenation alone. A language is stable exactly when it is letterwise (`stable_iff_letterwise`, l. 212), a joint obstruction refutes stability, and a decided obstruction locates a changed profile. B: `Bounded`, `latch`, `gate`, `unrestricted`.
- **moves**
  - *pass a:* S: `trace_iff` (l. 66) says that from an admitted history in the process of a prefix-closed language, a chosen word leads to an endpoint exactly when the endpoint is the appended word and is admitted.
  - *pass b:* S: `law` (l. 61) is a `Process (List A) A` that extends a history by an admitted move, with `trace_iff` (l. 66). `same_future_extends` (l. 177): histories with one profile keep one profile after every common extension. B: `latch` (l. 319) and `gate` (l. 344).
- **a reading**
  - *pass a:* S: `future_update` (l. 171) gives the continuation profile after an extension by testing the concatenated extension and suffix against the preceding profile. `obstruction_locates_changed_profile` (l. 256) locates an admitted prefix with a newly blocked individual letter for a decidable language admitting the empty word and rejecting a letterwise-admitted word.
  - *pass b:* S: `Future` and `SameFuture` (l. 154, l. 158): histories are read alike by the continuations admitted after them. `same_future_extends` (l. 177). `obstruction_locates_changed_profile` (l. 256): where the language is decided, an admitted prefix is located after which a letter admitted alone is blocked, and that prefix's profile differs from the start's.
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
  - *pass b:* N
- **multiplying**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a point of no return**
  - *pass a:* S: `feasible_prefixClosed` (l. 103) concludes that an infeasible prefix from a start cannot be extended to a feasible word from that start. B: `latch` (l. 319) makes true absorbing and allows only the true move there, and `latch_obstruction` (l. 322) witnesses the lost false continuation.
  - *pass b:* S: `blocked_extension_separates` (l. 224): a continuation admitted at the start and blocked after `past` separates that profile from the start's. B: `latch_obstruction` (l. 322): after `true`, `false` is no longer feasible. This is concluded in the built case. It is not stated for ever, and the loss is not of something that gives.
- **both outcomes**
  - *pass a:* S: `Feasible.stable_iff_letterwise` (l. 279) characterizes retention of the starting continuation profile after every feasible history exactly by letterwise feasibility of all words.
  - *pass b:* S: `stable_iff_letterwise` (l. 212) and `Feasible.stable_iff_letterwise` (l. 279), for every process: the profile is kept after every admitted history exactly when a word is admitted exactly where each of its letters is. B: `latch` loses a route (l. 338); `gate` gains one (l. 357).
- **a comparison between two**
  - *pass a:* S: `same_future_extends` (l. 177) carries equality of two histories' continuation profiles through any common extension.
  - *pass b:* S: `same_future_extends` (l. 177) carries sameness of profile across a common extension. `Feasible.stable_of_same` (l. 272) carries stability between languages with the same words. `realizes_feasible` (l. 113): the law of a process's feasible words takes the same words as the process.
- **a rank (an ending within a bound)**
  - *settled by the third pass:* B: `Bounded.lang` (l. 122) is `word = [] ∨ ∃ a, word = [a]` on `List Unit`; `Bounded.history_realizes` (l. 146): `Feasible (law lang) [] word ↔ lang word`, and `Bounded.not_double` (l. 128): `¬ lang [(), ()]`. So in the built law of this language every course feasible from the empty history has at most one move. No general law of ending within a bound is in the module. [which pass was right: a; opened: law l.61; feasible_iff l.97; Bounded.lang l.122; not_double l.128; prefixClosed l.132; no_one_point_law l.139; history_realizes l.146; latch l.319; latch_obstruction l.322]
  - *pass a:* B: `Bounded.lang` (l. 122) and `Bounded.history_realizes` (l. 146) bound every feasible word from the empty history of that law to at most one move.
  - *pass b:* N
- **a closed region**
  - *pass a:* S: `law` (l. 61) requires every step to end at an admitted history. `same_future_extends` (l. 177) gives closure of profile-equivalent pairs under common extensions.
  - *pass b:* S: `feasible_prefixClosed` (l. 103): the feasible words of every process are closed under prefixes. `Stable` (l. 162): the profile is invariant across admitted histories. Both are closures of a language, not regions closed under steps.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* B: `gate_formation` (l. 347) exhibits false becoming feasible after true from the false start. `latch_changes_profile_and_continues` (l. 338) gives a changed profile with the two-move word [true,true] still feasible.
  - *pass b:* B: `latch_changes_profile_and_continues` (l. 338): the profile changes (the route by `false` is lost) while the course goes on (`[true, true]` is feasible). `gate_gains_profile` (l. 357): a move opens a route, so more can go on after. S: `enabled_extension_separates` (l. 229): in general, a continuation that is formed separates the profile from the start's.
- **how it was read**
  - *pass a:* S: I read the opening account, all statements and their docstrings. General statements cover states, moves, reading, no_return, both_outcomes, comparison, closed_region. Built cases cover no_return, rank, forms_change. I found no matching claim for share, level, giving, cost, multiplying. I reached all fourteen questions.
  - *pass b:* All 14 answered from statements; all statements read, lines 1-362.
