# Typicality

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Typicality.lean`
- *result records that name this place's file as a source* (computed; not a link): `drift-offspring-sampled`, `exit-from-a-margin`, `fixation-by-drift`, `typicality-by-counting`, `weights-count-situations`
- *dynamics in the atlas that name one of those records* (computed; not a link): `exit-from-a-margin`, `fixation-by-drift`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-20, as "Typicality.lean: spread, typical_throughout, concentrated, stopped_spec" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-20.md.txt)); pass b: reader whole-b-77, as "Typicality.lean: total_weight, spread, typical, typical_throughout, stopped_spec, stopped_spread, concentrated, few_far_ahead, sum_courses_weight" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-77.md.txt)); the third pass, where the two differed: reader whole-c-settle-28, as "Typicality.lean: settled fields moves, share, both_outcomes" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-28.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `spread` (l. 311) gives the exact weighted squared deviation n·p·q·(p+q)^n over all length-n Boolean courses, with natural weights. `typical_throughout` (l. 537) bounds the weight reaching deviation d at any prefix times d by that quantity, and `concentrated` (l. 641) gives the exponential tilt bound for v ≤ u.
  - *pass b:* Over the courses of n steps on two values (`courses`), weighted by natural weights p and q (`weight`), the module states: total weight (p + q)^n (`total_weight`); an exact spread, where Σ weight·(x² + y²) equals Σ weight·2xy plus n·p·q·(p + q)^n (`spread`); the counting Chebyshev bound (`typical`) and the Kolmogorov maximal bound by stopping (`typical_throughout`); the counting Chernoff bound (`concentrated`, `few_far_ahead`); and that these weights are `Becoming.Weighted`'s sum over histories (`sum_courses_weight`). These are general in p, q, n, d, k, u and v, about one model of free branching on two values.
- **moves**
  - *settled by the third pass:* N: opened `courses` (l. 112), `stopStep` (l. 359), `stopped` (l. 368), `stopped_spec` (l. 385), `stopped_go` (l. 434), `stepWeight` (l. 660), `along_weight` (l. 665), `sum_courses_weight` (l. 683). There is no `Process`, policy, plan or allowed set in a statement of this module. The Boolean in `stopStep` is the value a course takes at a step, and that the pair stays under either value once `d + pairCross s ≤ pairSquare s` is the body of that def, not a theorem; `stopped_go` says, where the pair has not stopped, that for every b the pair after one more step is the course's own. `stepWeight` weights the single move `()` of free branching (`sum_courses_weight` is over `Becoming.courses [()] [true, false] n`). No law of what a choice keeps. [which pass was right: b; opened: extend l.107; courses l.112; stopStep l.359; stopped l.368; reachesBy l.373; stopped_spec l.385; stopped_go l.434; stepWeight l.660; along_weight l.665; sum_courses_weight l.683]
  - *pass a:* S: `stopStep` (l. 359) takes either Boolean step and keeps the stopped pair fixed under both choices once the deviation threshold is reached.
  - *pass b:* N: courses are all lists of n values (`mem_courses_iff`, l. 135). `stepWeight` (l. 660) weights free branching with the single move `()`. No law says what a choice keeps.
- **a reading**
  - *pass a:* S: `weight_pow` (l. 576) makes the two observed counts sufficient for course weight at given p,q. `stopped_spec` (l. 385) distinguishes an untouched count pair from one stopped at a threshold crossing.
  - *pass b:* S: `stopStep` (l. 359) and `stopped` (l. 368) stop the pair (x, y) = (q·ones, p·zeros) at the first step its squared deviation reaches d. `stopped_spec` (l. 385) states that until then the stopped pair is the course's own pair and `reachesBy` is false, and that once it is reached `reachesBy` is true and the pair has reached d. So what is registered (the deviation reached) decides whether the pair moves. D: the account (l. 8-11) says a record shows one course, never a weight; (l. 50-54) says that the course which happens is typical is not a theorem of the core.
- **a share**
  - *settled by the third pass:* S: the counts of each value are the defs `ones` (l. 89), `zeros` (l. 95), `ahead` (l. 218), `behind` (l. 221), and they stand in statements: `typical` (l. 562), `total (courses n) (offBy p q d) * d ≤ n * (p * q * (p + q) ^ n)`, of courses whose squared deviation is at least d; `typical_throughout` (l. 537), the same bound for courses reaching d at some step; `atLeast` (l. 612) with `atLeast_le` (l. 615), of courses with at least k ones. The second half of the field is absent: p and q are parameters throughout and no weight, rule or favouring is set again from the count. The stop in `stopStep` (l. 359) is read from the pair at each step but changes only the pair used in the proof of `typical_throughout`, not the weights. The two passes say the same in substance. [which pass was right: both in part; opened: ones l.89; zeros l.95; weight l.101; ahead l.218; behind l.221; offBy l.346; stopStep l.359; typical_throughout l.537; typical l.562; atLeast l.612; atLeast_le l.615]
  - *pass a:* N: `ones_add_zeros` (l. 570) counts both kinds, but `weight_pow` (l. 576) takes p,q as parameters throughout. No feedback resetting them from observed counts was found.
  - *pass b:* S: `ones`/`zeros` (l. 89, 95) and `ahead`/`behind` (l. 218, 221) give the counts of each value. `offBy` (l. 346) and `atLeast` (l. 612) select courses by deviation and by count of ones, and the stop in `stopStep` (l. 359) is set at each step from the pair. N: no favouring or selection rule is set again from the share.
- **a level that runs down**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **a giving that is itself a going-on**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **a cost to the one that keeps or gives**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **multiplying**
  - *pass a:* N: `extend_length` (l. 152) doubles the list of alternative histories on extending both ways. The entries being counted are courses, with no reproducing population inside a course.
  - *pass b:* N: `extend` (l. 107) gives each course two successors, and `courses_length` (l. 157) states 2^n courses. These are counts of courses, not units leaving units.
- **a point of no return**
  - *pass a:* S: `stopStep` (l. 359) fixes a pair meeting its threshold for either next bit. This absorption is built into the update of the statistic.
  - *pass b:* S, by construction: in `stopStep` (l. 359) a pair whose squared deviation has reached d stays, and `stopped_spec` (l. 385) states that once reached it stays reached. This is a stopping device, not the loss of anything that gives. D: the account (l. 50-53) cites `Parting.free_parts_after`; it is not stated here.
- **both outcomes**
  - *settled by the third pass:* S: `stopped_spec` (l. 385), no premise, for all p q d and every `w : List Bool`: either `reachesBy p q d w = false ∧ stopped p q d w = (ahead q w, behind p w) ∧ ¬ d + cross p q w ≤ square p q w`, or `reachesBy p q d w = true ∧ d + pairCross (stopped p q d w) ≤ pairSquare (stopped p q d w)`. A dichotomy for every course of the module's one model (courses on two values): the stopped pair still follows the course, or it has reached d. It is a disjunction of not yet reached and reached, of a pair defined for the proof; the course itself neither goes on nor ends by it, and nothing is kept or lost. That a stopped pair stays stopped is in the def `stopStep` (l. 359). So it has the form the field asks, for a different thing than going on against ending. [which pass was right: both in part; opened: stopStep l.359; stopped l.368; reachesBy l.373; reachesBy_of_end l.378; stopped_spec l.385; moving l.417; stopped_go l.434; offByWithin_le l.521]
  - *pass a:* S: `stopped_spec` (l. 385) gives a dichotomy for every Boolean course: its deviation has never crossed and the pair still tracks its counts, or it has crossed and its stopped pair meets the threshold.
  - *pass b:* N for going on or ending, keeping or losing. `stopped_spec` (l. 385) is a dichotomy only between the deviation not yet reached and reached.
- **a comparison between two**
  - *pass a:* S: `stopped_go` (l. 434) identifies the stopped pair and both of its next updates with the raw count pairs if the present stopped pair is below threshold. `along_weight` (l. 665) equates path composition with the product weight of the recorded values.
  - *pass b:* S: `sum_courses_weight` (l. 683) states that the sum over histories of n steps in `Becoming.Weighted`, weighted by `stepWeight`, equals `total (courses n) (weight p q)`. `along_weight` (l. 665) and `transfer_weight` (l. 671) are steps toward it. `stopped_spread` (l. 494) states that the stopped spread is at most the spread bound. `offBy_le_within` (l. 547) states that deviating at the end is counted within deviating at some step, so `typical` is a case of `typical_throughout`. `weight_mul` (l. 586) states that weights multiply step by step.
- **a rank (an ending within a bound)**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N: the bounds are on weights. D: the account (l. 24-29, 48-49) reads them as falling as 1/n and as 0.88^n.
- **a closed region**
  - *pass a:* S: `stopStep` (l. 359) makes every threshold-reaching pair a fixed point for either bit.
  - *pass b:* S, by construction only: `stopStep` (l. 359) leaves a pair whose deviation has reached d where it is, so the reached pairs are closed under the step. N: no other invariant, kernel or closed region.
- **forms change while the going on continues, or more can go on after**
  - *pass a:* N: No such law found in the statements read.
  - *pass b:* N
- **how it was read**
  - *pass a:* S: I read the opening account, all declaration statements and their docstrings. Statement answers cover states, moves, reading, no_return, both_outcomes, comparison, closed_region. No answer relies on prose alone. The remaining questions are N, and I reached all fourteen.
  - *pass b:* All 692 lines read: the account and every statement and docstring. Questions 1, 3, 4, 9, 11 and 13 are answered from statements, with 9 and 13 holding only by construction of `stopStep`; the rest found nothing (N), with the account cited where noted.
