# Mechanism

*Made by `build_places.py`; never edited by hand. One place of [the listing of places](../PLACES.md). Each field under a read is a reader's return, unchecked; what the note mended is in the note. Line breaks in a return are shown as spaces. Where an answer begins with a letter: **S** from a statement read; **D** from a docstring or the opening account only; **B** only in a built case; **N** one reader's "not found in what was read"; **U** not reached; a `+` after a letter: the answer goes on with another lettered part, which is on the place's page (an `N+` is not an absence); two letters in brackets, as `[D/S]`: the reader gave both; `·` the read has no answer for that field at this place; `?` the answer does not begin with one of the five. The third pass tried only the cells where the two passes differed; a cell that both passes left as not found was tried by nobody else. An S says where a statement is and what it concludes; it is not a list of its premises. The page proves nothing, ranks nothing and holds no link of the atlas. [The note](../NOTE.md) says what the listing is and is not.*

- *file:* `experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Mechanism.lean`
- *result records that name this place's file as a source* (computed; not a link): `a-code-formed-between-formations`, `a-law-through-a-projection-along-one-run`, `causal-models-as-processes`, `configurations-alike-by-relation`, `counterfactual-is-the-course`, `derived-history-law-exactness`, `determinacy-up-to-likeness`, `fixed-places-and-sole-lines`, `generalization-through-lumping`, `hexagram-arrangements-and-laws`, `hexagram-world-laws`, `place-relations-in-context`, `process-and-frame-as-readings`, `projection-carrying-a-law`, `shared-laws-on-the-grammar`, `sum-over-histories-exact`, `target-capture`, `the-split-that-makes-sense`, `where-a-move-is-formed`, `where-the-possible-grows`, `wisdom-root`, `wisdom-root-without-axiom`
- *dynamics in the atlas that name one of those records* (computed; not a link): `a-code-formed-between-formations`, `a-course-that-only-returns`, `falls-that-end-do-not-recur`, `merged-distinctions-stay-merged`, `recurrence-without-premise`, `rule-raised-every-other-step`, `target-capture`, `waxing-and-waning-returns`, `where-the-possible-grows`

## 22 November, every module by fifteen questions

*pass a: reader whole-a-11, as "Mechanism.lean: carries_law_iff, GoAlike.runs_agree, DependsOnlyOn.reabsorbed, adaptive_state_carries_iff" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-a-11.md.txt)); pass b: reader whole-b-40, as "Mechanism.lean: carries_law_iff, Image, Image.least, image_determined_iff, GoAlike.runs_agree, DependsOnlyOn.reabsorbed, adaptive, adaptive_state_law_iff, Run.not_fixesThrough_of_untaken, forget_inputs_determined_iff, Coarse.carries, Switching.no_state_law" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-b-40.md.txt)); the third pass, where the two differed: reader whole-c-settle-15, as "Mechanism.lean: settled fields no_return, closed_region" ([report](../../../fm-whole-read-2026-11-22/reports/read-whole-c-settle-15.md.txt)). Each is a reader's return, unchecked; what the note mended is in the note: [note](../../../fm-whole-read-2026-11-22/NOTE.md). Under each question the third pass's settled answer stands first where there is one, then pass a, then pass b.*

- **what the module states**
  - *pass a:* S: `carries_law_iff` (l. 134) characterizes the existence of a determined process admitting all projected steps by agreement of projected successors for equal projections and the same move. For the joint state and rule process, `adaptive_state_carries_iff` (l. 243) specializes this to independence of the state update from the rule.
  - *pass b:* For every process and projection π, some determined process on the description admits every step read through π exactly when configurations alike under π go alike (`carries_law_iff`), and the image is the least such process. A step that depends only on π re-absorbs every other difference in one step, and a system that changes its own rule is one determined process on state and rule, with a law at the state alone only where the rule makes no difference. A law through π is not fixed by the record at a projected configuration not yet taken, and in the standard model x' = F(x, u, ε) an intervention is a move not taken and noise a move not represented. These are general laws; Coarse and Switching are the built cases.
- **moves**
  - *pass a:* S: `GoAlike.runs_agree` (l. 166) preserves equal projections at every step of any two runs from equal projections taking the same moves, assuming GoAlike.
  - *pass b:* S: `GoAlike.runs_agree` (l. 166): where GoAlike P π holds, two runs taking the same moves from starts alike under π are alike at every step. `DependsOnlyOn.reabsorbed` (l. 191): if the next configuration depends only on π, such runs are equal from step 1 on. `Run.not_fixesThrough_of_untaken` (l. 289): if some determined Q admits the run's steps through π before t and the run has not taken a at a configuration projecting to k, the record fixes no outcome of a at k (given two distinct κ). `inputs_intervention_unfixed` (l. 334).
- **a reading**
  - *pass a:* S: `image_determined_iff` (l. 122) characterizes a determined image process by GoAlike under its projection. `Run.not_fixesThrough_of_goAlike` (l. 303) still excludes record identification for an untaken projected state/move pair when two projected values differ.
  - *pass b:* S: `carries_law_iff` (l. 134): (∃ Q, Determined Q ∧ FactorsThrough P π Q) ↔ GoAlike P π. What the description registers decides whether a law is carried. `goAlike_id_iff` (l. 142): through id this is determinacy. `goAlike_const` (l. 149): the constant description always carries one. `forget_inputs_determined_iff` (l. 356): with the noise forgotten, the model is determined iff F x u e = F x u e' for all e, e'.
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
  - *settled by the third pass:* S (a different form): `DependsOnlyOn.reabsorbed` (l. 191): for any `P : Process S A` and `π`, with `DependsOnlyOn P π`, two runs with the same moves at every step and `π (r.state 0) = π (r'.state 0)` have `r.state (n + 1) = r'.state (n + 1)` for every n. Concluded; it is a difference between two runs gone from step 1 on, not a level, a giver, or a point from which no course keeps something. [which pass was right: both in part; opened: DependsOnlyOn l. 180; DependsOnlyOn.goAlike l. 184; DependsOnlyOn.reabsorbed l. 191; Law.reabsorbed l. 211.]
  - *pass a:* S: `DependsOnlyOn.reabsorbed` (l. 191) concludes full equality from step one onward when the next state depends only on the projection, initial projections agree and the two move sequences agree.
  - *pass b:* N for a loss of a level or giver. S (of information only): `DependsOnlyOn.reabsorbed` (l. 191): whatever differed at the start apart from π is gone from step 1 on. This is concluded from DependsOnlyOn.
- **both outcomes**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N: the iffs are about carrying a law, not about going on and ending.
- **a comparison between two**
  - *pass a:* S: `Image.least` (l. 105) transports every image step into any process through which the original steps factor by that projection.
  - *pass b:* S: `FactorsThrough P π Q`. `factors_image` (l. 98) and `Image.least` (l. 105): every process Q into which P factors through π admits every step of Image P π. `goAlike_image_iff` (l. 154): a description ρ of the image carries a law iff ρ ∘ π does for P. `GoAlike.runs_agree` (l. 166) carries alikeness between two runs. `Run.stepsThrough_retarget` (l. 278).
- **a rank (an ending within a bound)**
  - *pass a:* N: Not found in the statements read.
  - *pass b:* N
- **a closed region**
  - *settled by the third pass:* S: `GoAlike.runs_agree` (l. 166): for any process and projection with `GoAlike P π`, two runs with the same moves and `π (r.state 0) = π (r'.state 0)` have `π (r.state n) = π (r'.state n)` at every n. An invariant kept by every step; it is the relation 'alike under π' between two runs, not a subset of S closed under `P.step`. [which pass was right: a; opened: Image l. 92; image_determined_iff l. 122; carries_law_iff l. 134; goAlike_const l. 149; GoAlike.runs_agree l. 166.]
  - *pass a:* S: `GoAlike.runs_agree` (l. 166) makes equality under the projection invariant for synchronized moves under GoAlike.
  - *pass b:* N
- **forms change while the going on continues, or more can go on after**
  - *pass a:* B: `Switching.next` (l. 408) and `Switching.run` (l. 411) exhibit an infinite joint run in which the rule flips each step and the state takes its former value.
  - *pass b:* S: `adaptive` (l. 225) and `adaptive_determined` (l. 229): a state under a rule that itself goes on is one determined process on the pair. `Run.steps_by_rule` (l. 258): on a stretch where the rule stays g, the state's steps are those of ruleLaw F g. B: `Switching.no_state_law` (l. 424): the rule alternates, no determined process on the state admits two steps read through it, and the joint process is determined (`Switching.determined` l. 414).
- **how it was read**
  - *pass a:* S: I read the opening account, every declaration statement and the docstrings. General statements — states, moves, reading, no_return, comparison, closed_region. Built cases — forms_change. Not found — share, level, giving, cost, multiplying, both_outcomes, rank. No commentary-only answers. All questions were reached.
  - *pass b:* All statements and docstrings read to the end (l. 432). moves, reading, no_return (information only), comparison and forms_change are answered from statements, with built cases; the rest are N.
