# CopyCourses

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/CopyCourses.lean`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-03, as "CopyCourses.lean: run_copies, inspection_step_matches_iff, inspection_course_keeps_template, doubling_course_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-03.md.txt)); pass b: reader whole-b-08, as "CopyCourses.lean: swap_course_iff, run_copies, run_drawn, runs_draw_lt_iff, runs_draw_midpoint, inspection_step_matches_iff, inspection_course_keeps_counts, inspection_course_keeps_template, doubling_course_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-08.md.txt)); the third pass, where the two differed: reader whole-c-settle-03, as "CopyCourses.lean: settled fields no_return, forms_change" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-03.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `run_copies` (l. 65) gives the completed word, remaining pool and exact support debit after the word's length in any run from a supplied, covered word. `doubling_course_iff` (l. 209) characterizes the possible endpoint of any prescribed number of doubling rounds by initial stock and required new units.
  - *pass b:* General, for every alphabet with decidable equality and every law of draws, Copying's laws are read on the courses and runs of its processes. The order of words does not decide whether they are a course of the release law (`swap_course_iff`). A run of the copy completes after as many moves as the word has tokens (`run_copies`, `run_drawn`), and under local draws, runs are compared by their unlike pairs (`runs_draw_lt_iff`, `runs_draw_midpoint`). Courses of inspection keep token counts, the product's length and a template (`inspection_course_keeps_counts`, `inspection_course_keeps_template`). A course of doubling runs exactly when the stock covers its draws (`doubling_course_iff`).
- **moves**
  - *pass a:* S: `inspection_course_keeps_template` (l. 193) keeps an initially exact template along any inspection trace whose chosen sites all have a faithful reference.
  - *pass b:* S: `inspection_course_keeps_counts` (l.154) and `inspection_course_length` (l.182): every course of `Courses.inspection` (any list of sites) keeps the count of every token across product and pool, and keeps the product's length. `inspection_course_keeps_template` (l.193): every course at faithful sites from the template keeps the product the template. `swap_course_iff` (l.52): exchanging two adjacent words leaves whether the list is a course of the release law.
- **a reading**
  - *pass a:* S: `inspection_step_matches_iff` (l. 144) uses the reference and built token at the site. Given a step and two present, unequal tokens, the result matches the reference exactly when free support covers inspection plus exchange and the desired token occurs in the pool.
  - *pass b:* S: `inspection_step_matches_iff` (l.144): at a defective site, a step of inspection leaves the reference's token exactly when the support covers ci + ce and the pool holds the token. `inspection_course_keeps_template` (l.193) needs the reference `ref` to be `FaithfulAt` the template at every inspected site.
- **a share**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a level that runs down**
  - *pass a:* S: `doubling_course_iff` (l. 209) requires stock covering the prescribed rounds and subtracts their draw. `inspection_step_matches_iff` (l. 144) makes correction conditional on remaining free support and pool count.
  - *pass b:* S: `run_copies` (l.65): from a supplied word whose use is at most `free`, the run ends with free - use. `doubling_course_iff` (l.209): n rounds from k units with stock m run exactly when d * required n k \<= m, leaving m - d * required n k. N: nothing comes back depending on what is left.
- **a giving that is itself a going-on**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: the stock m and the support `free` are numbers handed in.
- **a cost to the one that keeps or gives**
  - *pass a:* S: `run_drawn` (l. 77) adds the supplied and covered word's use to used support. `inspection_step_matches_iff` (l. 144) requires coverage of both costs for an effective repair.
  - *pass b:* S: `run_drawn` (l.77): a completed run has drawn the word's use from the copy's own support (`Scan.free`/`used`). `doubling_course_iff` (l.209): every unit draws d from the one stock. N: no offspring forgone or standing of the doer drawn on.
- **multiplying**
  - *pass a:* S: `doubling_course_iff` (l. 209) gives the final population as initial k plus required n k on every executable n-round course.
  - *pass b:* S: `doubling_course_iff` (l.209): a course of n rounds from k units ends with required n k + k units.
- **a point of no return**
  - *settled by the third pass:* N: `doubling_course_iff` (l. 209) states `Trace (doubling d) (k, m) (rounds n) t ↔ d * required n k ≤ m ∧ t = (required n k + k, m - d * required n k)`: a course of n rounds runs exactly when the stock covers its draw. It is a feasibility criterion with its endpoint; nothing is stated lost and not regained. Opened to rule it out: `doubling_course_iff` (l. 209), `swap_course_iff` (l. 52), `run_copies` (l. 65), `inspection_course_keeps_template` (l. 193). [which pass was right: b; opened: doubling_course_iff l. 209; swap_course_iff l. 52; run_copies l. 65; inspection_course_keeps_template l. 193]
  - *pass a:* S: `doubling_course_iff` (l. 209) excludes every endpoint of the prescribed n rounds if their draw exceeds stock. For one round this blocks the only move when d*k exceeds m.
  - *pass b:* N
- **both outcomes**
  - *pass a:* S: `doubling_course_iff` (l. 209) gives feasibility and exact endpoint in one equivalence for the doubling process. `inspection_step_matches_iff` (l. 144) gives both outcomes of a defective-site repair.
  - *pass b:* S: `doubling_course_iff` (l.209): for every d, n, k and m, the course runs exactly when the stock covers d * required n k, and is otherwise no course.
- **a comparison between two**
  - *pass a:* S: `swap_course_iff` (l. 52) carries feasibility both ways across an adjacent exchange of words. `runs_draw_lt_iff` (l. 87) compares supplied, covered equal-length nonempty words from equal used support and a positive difference in unlike-pair count.
  - *pass b:* S: `runs_draw_lt_iff` (l.87): of two runs copying words of one length from the same support used, the run copying the word with more unlike pairs draws less exactly when differ \< same. `runs_draw_midpoint` (l.112): three runs whose unlike pairs are in arithmetic progression draw in arithmetic progression. `swap_course_iff` (l.52): two orders of words.
- **a rank (an ending within a bound)**
  - *pass a:* S: `run_copies` (l. 65) concludes completion at word.length given token supply and cost coverage.
  - *pass b:* S (only of completion): `run_copies` (l.65): the run reaches the completed copy at date word.length. N: no rank or variant law.
- **a closed region**
  - *pass a:* S: `inspection_course_keeps_counts` (l. 154) and `inspection_course_length` (l. 182) preserve each combined product-pool count and product length on every inspection trace.
  - *pass b:* S: `inspection_course_keeps_counts` (l.154) and `inspection_course_length` (l.182) are invariants of every course of inspection. `inspection_course_keeps_template` (l.193): the template is kept by every course at faithful sites.
- **forms change while the going on continues, or more can go on after**
  - *settled by the third pass:* S, in a weaker form: `inspection_step_matches_iff` (l. 144, variables `{α} [DecidableEq α]`), premises a step `(Courses.inspection ci ce ref).step s i u`, `ref i = some x`, `nth s.built i = some old`, `old ≠ x`, states `nth u.built i = some x ↔ ci + ce ≤ s.free ∧ 0 < countOf x s.pool`: the token at a site is replaced exactly when the support covers and the pool holds it. `inspection_course_keeps_counts` (l. 154) states that every course of inspections keeps `countOf a (built ++ pool)`. A token changes at a site while counts are kept; no relay, alternation or widening is stated. [which pass was right: both in part; opened: inspection_step_matches_iff l. 144; inspection_course_keeps_counts l. 154; inspection_course_length l. 182; inspection_course_keeps_template l. 193; doubling_course_iff l. 209]
  - *pass a:* S: `inspection_step_matches_iff` (l. 144) gives a token change at a defective site under coverage and availability, while `inspection_course_keeps_counts` (l. 154) conserves each combined count.
  - *pass b:* N: no case where what is present changes while the going on continues. Units grow in number in `doubling_course_iff` (l.209), as counts only.
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statements (1, 2, 3, 5, 7, 8, 9, 10, 11, 12, 13, 14). Not found (4, 6). I reached all fourteen questions.
  - *pass b:* All 14 questions were answered from statements. I read all statements, l.1-220.
