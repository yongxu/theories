# Copying

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Copying.lean`
- *table of 20 November:* Copying, letters `YYPYNNYY`, standing core, told in chapter 4 section 2 (04-LIFE.md lines 99-112, Passing and transmission)
- *result records that name this place's file as a source* (computed; not a link): `copying-b-fold`, `formed-contacts-change-copying-fidelity`, `formed-copying-correction`, `inherited-structural-copying`, `learned-procedure-transmission`, `material-preparation-output`, `recurrent-chain-assembly`
- *dynamics in the atlas that name one of those records* (computed; not a link): `copying-from-a-stock`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-03, as "Copying.lean: reading_iff, inspect_le_iff, batch_all_iff, copying_iff, steps_fixed" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-03.md.txt)); pass b: reader whole-b-08, as "Copying.lean: Supplies, tick, completes_iff, copies, empties_iff, releases_iff, batch_all_iff, batch_all_swap, lineage_all_iff, use_word, use_lt_iff, reading_iff, extends_along_iff, inspect_le_iff, inspect_matches_iff, defects_zero_iff, copying_iff, doubling_iff, tenfold" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-08.md.txt)); the third pass, where the two differed: reader whole-c-settle-03, as "Copying.lean: settled fields rank" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-03.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `reading_iff` (l. 768) characterizes exact copying at the pending word's length by faithful site readings, token supply and coverage of draws, and `batch_all_iff` (l. 502) characterizes release of every word from one pool. `copying_iff` (l. 1170) gives exact feasibility, population and stock after n rounds for arbitrary initial population, fold factor and per-unit draw.
  - *pass b:* General, for every alphabet with decidable equality and every law of draws: a copy of a word from a pool completes exactly when the pool supplies the word and the support covers its draws (`completes_iff`, `built_iff`, `copies`), with versions for emptying the pool and for release. Copies from one shared pool are all released exactly when the pool supplies all the words together and the support covers all their draws and releases, whatever the order (`batch_all_iff`, `batch_all_swap`, `lineage_all_iff`). The module also gives laws of local draws, reading through contacts, and inspection against a reference, and `extends_along_iff` for every process. Where each unit draws d and becomes b, n rounds from k units run exactly when the stock covers d * requiredBy b n k, ending with k * b^n units (`copying_iff`, `doubling_iff`), with a built case `tenfold`.
- **moves**
  - *pass a:* S: `extends_along_iff` (l. 134) equates preservation as a prefix on every trace with extension at every step of any process. `scan_le` (l. 1005) bounds defects for every list of faithful inspection sites.
  - *pass b:* S: `extends_along_iff` (l.134): for every Process P and output, the output is extended along every course exactly when every step extends it. `scan_le` (l.1005): every scan of faithful sites (any list of sites) never increases the defects. `copying b d` (l.158) is a Process with a single Unit move.
- **a reading**
  - *pass a:* S: `reading_iff` (l. 768) requires each site to read the desired token along with sufficient tokens and support. `inspect_le_iff` (l. 978) characterizes universal nonincrease of defects by faithfulness at the inspected site.
  - *pass b:* S: `reading_iff` (l.768): a copy attaching at each site what `read` gives there reproduces a word exactly when every site reads the word's token, the pool supplies the word and the support covers its draws. `inspect_le_iff` (l.978): for every scan, inspecting site i never increases the defects exactly when the reference is `FaithfulAt` the template at i. `inspect_matches_iff` (l.1016).
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: token counts appear (`countOf`, `Supplies` l.157; `lineage_all_iff` l.592 needs n * countOf a word \<= countOf a pool), but there is no fraction and no rule set again from one.
- **a level that runs down**
  - *pass a:* S: `tick_cons` (l. 288) debits free support and removes the next token if both are available, otherwise it keeps the state. `copying_iff` (l. 1170) gives the exact stock left after feasible rounds.
  - *pass b:* S: `tick` (l.259) attaches only where the copy's free support covers the draw. `releases_iff` (l.386), `batch_all_iff` (l.502) and `copying_iff` (l.170): the stock m is drawn down by d * requiredBy b n k. N: nothing comes back depending on what is left.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: the pool, the support and the stock are handed in.
- **a cost to the one that keeps or gives**
  - *pass a:* S: `inspectAt` (l. 877) charges the scan's free support to inspect two present tokens, and `exchangeAt` (l. 865) draws again for a feasible replacement. `inspect_matches_iff` (l. 1016) needs their sum at a mismatched site.
  - *pass b:* S: `tick` (l.259): each attachment draws `draw prev x` from the copy's own free support. `copying` (l.158): every unit draws d from the stock to become b. N: no offspring forgone.
- **multiplying**
  - *pass a:* S: `copying` (l. 1158) replaces k units by b*k when stock covers d*k. `copying_iff` (l. 1170) gives k*b^n after n executable rounds.
  - *pass b:* S: `copying_iff` (l.170): where every unit draws d and becomes b, n rounds from k units with stock m run exactly when d * requiredBy b n k \<= m, and end with k * b^n units. `requiredBy_add` (l.1137), `doubling_iff` (l.1205), `lineage_all_iff` (l.592). B: `tenfold` (l.1218): one unit, tenfold, five rounds, stock 11111 gives 100000 units and 0 left.
- **a point of no return**
  - *pass a:* S: `steps_fixed` (l. 295) concludes all later iterations stay given a one-step fixed point. `tick_cons` (l. 288) supplies that premise for an unavailable next token or insufficient free support.
  - *pass b:* S (concluded from a premise): `steps_fixed` (l.295) and `readSteps_fixed` (l.738): where one move leaves a copy unchanged (the pool lacks the token or the support does not cover the draw), it stays so for every number of moves.
- **both outcomes**
  - *pass a:* S: `completes_iff` (l. 346) characterizes completion after the word's length by supply and draw coverage. `copying_iff` (l. 1170) characterizes feasibility of n population rounds by stock coverage and the specified endpoint.
  - *pass b:* S: `completes_iff` (l.346), `built_iff` (l.354), `empties_iff` (l.426) and `releases_iff` (l.386): a copy completes or stalls, exactly when the pool supplies and the support covers. `batch_all_iff` (l.502) and `lineage_all_iff` (l.592). `copying_iff` (l.170): n rounds run exactly when the stock covers.
- **a comparison between two**
  - *pass a:* S: `batch_all_swap` (l. 560) keeps all-released feasibility under adjacent word exchange. `use_lt_iff` (l. 677) orders two equal-length words with strictly different unlike-pair counts exactly according to the local cost inequality.
  - *pass b:* S: `batch_all_swap` (l.560): exchanging adjacent words leaves whether all are released. `use_lt_iff` (l.677): among words of one length, the word with more unlike pairs draws less exactly when differ \< same. `use_midpoint` (l.662). `extends_along_iff` (l.134) carries a property of steps to every course.
- **a rank (an ending within a bound)**
  - *settled by the third pass:* S: `copies` (l. 301, variable `draw : Option α → α → Nat`), premises `Supplies word pool` and `use draw prev word ≤ free`, states that `steps draw word.length ⟨prev, word, built, pool, free, used⟩` has pending `[]`, product `built ++ word`, and free support `free - use draw prev word`: the copy is complete at `word.length` moves, the pending list emptied and the support drawn down. `copying_iff` (l. 1170) states that n rounds from `(k, m)` run exactly when `d * requiredBy b n k ≤ m` and leave stock `m - d * requiredBy b n k`, a drain of one stock. `defects_fix` (l. 898) states a count of defects falling by one at a fix. [which pass was right: a; opened: tick l. 259; steps_fixed l. 295; copies l. 301; completes_iff l. 346; defects_fix l. 898; scan_le l. 1005; copying_iff l. 1170; copying_runs l. 1198]
  - *pass a:* S: `copies` (l. 301) gives completion by the word's length when tokens and support cover the copy. `copying_iff` (l. 1170) rules out an n-round trace when its required draw exceeds stock.
  - *pass b:* N: no falling rank or variant. Completion comes at word.length moves (`copies` l.301).
- **a closed region**
  - *pass a:* S: `inspect_keeps_counts` (l. 1109) keeps every combined product-pool count at each inspection. `scan_le` (l. 1005) keeps every upper bound on defect count for scans of faithful sites.
  - *pass b:* S: `steps_fixed` (l.295) is a fixed point of the copy's law. `exchange_keeps_counts` (l.1093) and `inspect_keeps_counts` (l.1109): token counts across product and pool are invariant. `scan_le` (l.1005): defects never increase under faithful scans. `defects_zero_iff` (l.1048).
- **forms change while the going on continues, or more can go on after**
  - *pass a:* S: `inspect_matches_iff` (l. 1016) gives a changed token under the two resource conditions, with all combined counts preserved by `inspect_keeps_counts` (l. 1109). `readSteps_extends` (l. 757) preserves the old product as a prefix during further copying.
  - *pass b:* S: `readSteps_extends` (l.757) and `extends_along_iff` (l.134): the product only grows along every course. `copying_iff` (l.170): units grow to k * b^n. N: no kinds coming and going while the going on continues.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statements (1, 2, 3, 5, 7, 8, 9, 10, 11, 12, 13, 14). Not found (4, 6). I reached all fourteen questions.
  - *pass b:* All 14 questions were answered from statements or built cases. I read all statements, l.1-1221, in two parts.
