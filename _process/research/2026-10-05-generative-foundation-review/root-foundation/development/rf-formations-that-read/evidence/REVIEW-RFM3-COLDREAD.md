# The cold read of RF-M.3's texts

RF round 2, third part, RF-M.3: the valuation as state; informing and revaluing (plan §4.8). Before RF-M.3's landing, its texts were cold-read against the Lean of `Becoming.ListingValuation` (`kit/round2c/tree/Becoming/ListingValuation.lean`, 138 theorems in 186 declarations, every axiom report empty), as the kit's integration applied them to main in a rehearsal worktree (for the cross-model reader the kit at `07a24e169` with main at `1ec20513d`; for the lenses, after its points and its first re-check were taken, the kit at `3f43eefcf` with main at `8a8b0df82`): 03 §12's opening, its new theorem paragraph with its Reading, the pointer in the acts-alike reading and the Open bullet; 07 §7's sentences on moving the reading that gives the stop; 08 §8's bullet; the overview's paragraph; the dossier's scope box, its paragraph on RF's rounds and its account of how it was made; the package's root bullets, both READMEs and the checker's scope sentence; the module's header and docstrings; the record in both languages and the amendments to two related records; the study section's template; PLAN §4.8, §12, §13 and the Evidence list, and for the lenses also its §5 and §8 rows; regions; and the opening and the tables of what was taken in [REVIEW-RFM3-LEAN](REVIEW-RFM3-LEAN.md). Two reads ran on 31 October 2026: the cross-model reader (GPT astra, high effort, read-only, a fresh session `01a18ddb-e3da-78a0-ab08-f6fec1f4bf57`) and a workflow of three Opus readers, one per lens (exactness, readings, fit), each lens's findings given to one reader asked to refute them against the files. The prompts are in [the brief](BRIEF.md#round-2-third-part). The findings and verdicts are verbatim, with the rehearsal worktree's absolute paths made repository-relative and links made to resolve from this folder, since it is link-checked as live: a line number kept in a link's text and dropped from its target, and a link that does not resolve here (an anchor of the page a quotation came from, a path of the rehearsal alone) shown as its text with its target as code.

The cross-model reader reported 6 points, every one taken. The lenses reported 64 findings, 54 confirmed and 10 refuted by their refuters; what each became is in [the table](#what-was-taken-from-the-lenses), and what the checks after it changed, in theirs ([the check's](#what-was-taken-from-the-check-of-how-the-lenses-findings-were-taken), [the last check's](#what-was-taken-from-the-check-of-the-checks-changes)). For the lenses' findings the module's statements did not change: its header, the docstring of `WeightsApart.not_splitsKeep` and one section heading were revised, and it was rebuilt, 138 theorems in 186 declarations, every axiom report empty ([build-6](../kit/round2c/logs/build-6.log)). For the check of how they were taken, the header's bullet on the carrier and its Readings were revised again, and it was rebuilt, the same counts, every axiom report empty ([build-7](../kit/round2c/logs/build-7.log)). For the last check, the header's bullets on amounts forgone and revaluing and on the carrier, its Readings and the docstring of `outcome_least` were revised, and it was rebuilt again, the same counts, every axiom report empty ([build-8](../kit/round2c/logs/build-8.log)).

Before the lenses ran, the cross-model reader re-checked, in the session of its cold read, how its six points were taken and the texts cut or added since: one point, the reason to keep the valuation stated on a shared model wherever it is stated, taken ([the first re-check](#the-re-check-of-the-cross-model-readers-points)). After the lenses' findings were taken, it re-checked them in the same session: one omission, the incentive to revise read in PLAN §5's row without costs and the supplied update's reach, taken ([the second re-check](#the-re-check-of-the-lenses-findings)). Beside it, three Opus readers, one per lens, checked how every finding was taken, each reader's gaps given to a refuter: 14 gaps, every one judged real; with the second re-check's point, 12 distinct points, all taken ([the check](#the-check-of-how-the-lenses-findings-were-taken)). After those 12 points were taken, it re-checked them in the same session, finding nothing ([the third re-check](#the-third-re-check)). Beside it, two Opus readers, one checking how every point was taken and one reading the changed passages cold, each reader's gaps given to a refuter, found 11 gaps, every one judged real: 9 distinct points, all taken ([the last check](#the-check-of-the-checks-changes)).

## The cross-model reader

1. **Decision changes are repeatedly mistaken for strict losses.**

   Locations:
   - [03-KNOWING.md:519](../../../../../../../theories/becoming/chapters/03-KNOWING.md): “a decision-changing revision counts as a loss”.
   - [07-SIGNIFICANCE.md:623](../../../../../../../theories/becoming/chapters/07-SIGNIFICANCE.md), [08-METHOD.md:488](../../../../../../../theories/becoming/chapters/08-METHOD.md), [ALIGNMENT.md:28](../../../../../../../theories/becoming/review/ALIGNMENT.md), and [study_rfm3.txt:159](../kit/round2c/study_rfm3.txt): “one that changes a decision loses”.
   - [THE-THEORY-OF-BECOMING.md:101](../../../../../../../theories/becoming/THE-THEORY-OF-BECOMING.md): “any revision that changes a decision”.
   - [PLAN.md:231](../PLAN.md): “a decision-changing revision counts as a loss”.
   - [make_records_rfm3.py:469](../kit/round2c/make_records_rfm3.py), and line 473: “a decision-changing revision”; “有护值免于改断之由”.

   **Problem:** `revalued_lowers_iff` requires a revised decision against the current valuation’s **strict weighted preference at a listed cell**. A decision can change at a tie without losing worth. For example, one unit-weight candidate with current values `(1,1)` releases; revised values `(0,1)` stop; both answers have current worth 1. The module’s own reading preserves the qualification. The source’s preservation claim also concerns preserving optimal policies, not every decision unchanged. [Everitt et al., Claim 2 and footnote 11](https://arxiv.org/html/1908.04734).

   **Exact replacements**, respectively:
   - Replace “a decision-changing revision counts as a loss” with “a revision deciding a listed cell against the current valuation’s strict weighted preference counts as a loss”.
   - Replace “one that changes a decision loses” with “one that decides a listed cell against the current valuation’s strict weighted preference loses”.
   - Replace “any revision that changes a decision” with “any revision that decides a listed cell against that valuation’s strict weighted preference”.
   - In the record’s English correspondence, replace “a decision-changing revision” with “a revision deciding a listed cell against its current strict weighted preference”.
   - In its Chinese correspondence, replace “有护值免于改断之由” with “有护值免于使某列格之断逆当下严格加权之偏之改值之由”.

2. **The Chinese record reverses an inequality.**

   [make_records_rfm3.py:246](../kit/round2c/make_records_rfm3.py):

   > “整断一格不逊于分之，当所移之部有得。”

   **Problem:** “不逊于” says deciding the whole cell is at least as good. The English says “at most”, and `split_cell_le` proves whole-cell worth **≤** split worth.

   **Exact replacement:**

   > 整断一格之值不高于分之，当所移之部有得。

3. **Two summaries incorrectly make every holding-formation act inert.**

   [make_records_rfm3.py:413](../kit/round2c/make_records_rfm3.py), line 415, and [study_rfm3.txt:132](../kit/round2c/study_rfm3.txt):

   > “the holding formation’s moves change neither the world nor the reading formation”

   **Problem:** Demonstrating and presenting are also its acts. Their sensed inputs can change the listing and valuation through `Reader.update`. The module and plan correctly restrict this statement to going on, switching off and holding.

   **Exact replacements:**
   - Record English: “the holding formation’s going on, switching off and holding change neither the candidate world nor the reading formation”.
   - Record Chinese: replace “持之形成之行不改世界亦不改读之形成” with “持之形成之续、止与持不改候选世界亦不改读之形成”.
   - Study: “the holding formation’s going on, switching off and holding changing neither the candidate world nor the reading formation”.

4. **The record attributes unnecessary listing hypotheses to the residual criteria.**

   [make_records_rfm3.py:392](../kit/round2c/make_records_rfm3.py):

   > “For the split and its criteria … cells listed once each, covering every listed candidate’s cell”

   **Problem:** The split needs distinctness and coverage. `residual_zero_iff`, `residual_pos_iff` and `answer_residual_zero_iff` need neither; `told_residual_zero_iff` needs coverage but not distinctness. This is an inaccurate dependency account, although adding those hypotheses would not make the conclusions false.

   **Exact replacement for this bilingual hypothesis:**

   **English:**
   > Cell equality decidable. The split needs distinct cells covering the holding listing; the residual cell criteria need neither, and the told residual criterion needs coverage only. Informing factors on the holding listing; the all-refinements criterion factors on both, with distinct coarse cells covering the holding listing and distinct fine cells covering both.

   **Chinese:**
   > 格之等可判。分需诸格不重且覆持之列；余缺之格判无需此二条件，辨候选之余缺判唯需覆盖。告之于持之列上分解；于每一细分之判于二列皆分解，粗格不重且覆持之列，细格不重且覆二列。

5. **The re-check table’s R5 description is stale after the strict comparison was added.**

   [REVIEW-RFM3-LEAN.md:1429](REVIEW-RFM3-LEAN.md):

   > “the coarser map’s cells are named only for the criterion over every refinement and for `refined_lt_iff`”

   **Problem:** The current header explicitly names them for `informed_lt_iff` too. The delta table correctly records that addition.

   **Exact replacement for R5’s “How” cell:**

   > The header’s informing bullet asks only for `π'`’s cells, listed once each and covering the holding formation’s listing, for the weak comparison. It additionally names the coarser map’s distinct covering cells for `informed_lt_iff` and the cell-list conditions for the criterion over every refinement; `refined_lt_iff` also requires distinct covering cell lists for both maps.

6. **The dossier retains an unresolved evidence placeholder.**

   [ALIGNMENT.md:41](../../../../../../../theories/becoming/review/ALIGNMENT.md):

   > “the works they cite were checked against their texts (WORKS_CHECKED)”

   **Problem:** This supplies no identifiable evidence for the sentence’s three RF-M.3 citations.

   **Exact replacement for `(WORKS_CHECKED)`:**

   > (Kamenica and Gentzkow 2011, DOI 10.1257/aer.101.6.2590; Everitt, Hutter, Kumar and Krakovna 2021, arXiv 1908.04734, Claim 2; Carroll, Dragan, Russell and Hadfield-Menell 2022, PMLR 162:2686–2708)

For the remaining requested passages: **none** in the section-12 opening, acts-alike pointer or Open bullet; **none** in the package root bullets, either package README row or checker scope sentence; **none** in the module header and docstrings beyond the distinctions already correctly stated there; **none** in the record’s AMEND texts; **none** in the plan’s order, review paragraphs or Evidence list; **none** in either region entry; **none** in the review evidence’s opening or other “How” rows. The other citation correspondences checked are appropriately bounded as readings. The missing generated record page and future cold-read evidence are landing dependencies in this rehearsal, not proposed text corrections; the declared study-template placeholders are likewise expected.

**Verdict:** The integrated account substantially matches the Lean: model separation, positive-scale agreement, refinement factorization, cost directions, unrestricted replacement valuations, timing and different-start route witnesses are preserved. The principal correction is to carry the strict-preference qualification into every preservation summary; the reversed Chinese inequality and overbroad inert-act statement also need correction. The source count is 138 theorems, and the script cites 186 declarations in 37 law items; the saved build log reports empty axiom dependencies. This was a read-only source review, with no edits, rendering, `make` or Lean build.

### What was taken from the cross-model reader

| # | Finding | Taken |
|---|---|---|
| A1 | a revision that changes a decision is said to lose, where `revalued_lowers_iff` needs a listed cell decided against the current valuation's strict weighted preference (a change at a tie loses nothing) | deciding “a listed cell against the current valuation's strict weighted preference” (or “its”, or “that valuation's”) wherever the loss is stated: 03 §12's Reading (twice), 07 §7 (with “keep the valuation from such a revision”), 08 §8, the overview, the dossier, the study, PLAN §4.8 and the record's correspondence, English and Chinese (有护值免于使某列格之断逆当下严格加权之偏之改值之由) |
| A2 | the record's Chinese law on deciding a whole cell reverses `split_cell_le`'s inequality | 整断一格之值不高于分之，当所移之部有得 |
| A3 | the record and the study make every act of the holding formation leave the world and the reading formation unchanged, though demonstrating and presenting change the reading formation | “the holding formation's going on, switching off and holding change neither the candidate world nor the reading formation” in the record's premise (zh 持之形成之续、止与持不改候选世界亦不改读之形成) and the study, as the module and the plan say |
| A4 | the record gives every criterion the split's cell-list hypotheses | the record's hypothesis in two items, each law's lists as it takes them: the split needs the cells listed once each and covering; the residual's criteria need neither; the told criterion only its cell list covering the holding formation's listing; informing the factoring and the finer map's cells, the strict comparison the coarser map's as well; the criterion over every refinement the factoring on both listings, the coarse cells covering the holding formation's listing and the fine cells covering both, each listed once |
| A5 | REVIEW-RFM3-LEAN's row R5 says the coarser map's cells are named only for the criterion over every refinement and for `refined_lt_iff`, stale after `informed_lt_iff` | the row now says that after the check of the delta (its point 1) the bullet also names the coarser map's cells, listed once each and covering, for `informed_lt_iff`; the page regenerated from its script |
| A6 | the dossier keeps the placeholder `(WORKS_CHECKED)` | the works named as the design's and the Lean's cross-model reviews read them: Kamenica and Gentzkow's paper in the American Economic Review, 2011, and arXiv 1908.04734 and 2204.11966; the entry's date is the landing's |

## The three lenses

### X1 (exactness, medium, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:517 (source kit/round2c/s12_rfm3.txt:2); _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/study_rfm3.txt:51; _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/make_records_rfm3.py:271 (EN), :274 (ZH); optionally experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ListingValuation.lean:69 and :1663

**Quoted.** they keep it with a shared model and net agreement, and wherever the reading formation's value of switching off is nowhere above that of going on (`ListingValuation.splitsKeep_of_net`, `ListingValuation.splitsKeep_of_off_le_go`), not with the weights apart (`ListingValuation.WeightsApart.not_splitsKeep`) | study: the weights apart break it (WeightsApart.not_splitsKeep) | record law: The weights apart break the criterion: ... so splits do not keep the worth. / 权相异则破其判 | header: a shared valuation with the weights apart breaks it

**Problem.** WeightsApart.not_splitsKeep is one instance: ¬ SplitsKeep holding reading gain loss gain loss, with holding weights (2,1,1), reading weights (1,2,2) and the valuation equal to the reference. Three texts read as 'with the weights apart, splits never keep the worth': 03's 'not with the weights apart', the study's 'the weights apart break it', and the Chinese conditional 权相异则破其判 ('where the weights differ, the criterion breaks'). That is false in this module. splitsKeep_of_off_le_go proves SplitsKeep m pm ... for any two models, weights apart included, and any reference, wherever l c ≤ g c on pm.listed. 03 cites that theorem in the clause just before, so the sentence contradicts itself. release_keeps is an instance where splits keep the worth even though the answer has a residual. PLAN item 6 already says 'the weights apart can break it', so the texts also disagree with each other.

**Replacement.** 03: '…(`ListingValuation.splitsKeep_of_net`, `ListingValuation.splitsKeep_of_off_le_go`), and a shared valuation with the weights apart can break it (`ListingValuation.WeightsApart.not_splitsKeep`)'. Study: 'a shared valuation with the weights apart can break it (WeightsApart.not_splitsKeep)'. Record law: 'With the weights apart, a shared valuation can break the criterion: by its weights … so splits do not keep the worth.' / '权相异，共值亦可破其判：依其权……故分之不守其值。'. Optionally, with a rebuild: header 'can break it', and docstring title '**With the weights apart the criterion can fail**'.

**Verdict: real.** `WeightsApart.not_splitsKeep` (ListingValuation.lean:1667) is a single instance. `splitsKeep_of_off_le_go` (:1513) proves SplitsKeep for any two models wherever l ≤ g on the reading listing, so a general claim that the weights apart break the criterion is false in the module. 03 §12 says 'not with the weights apart' right after citing splitsKeep_of_off_le_go, and the study (:51) and the record's Chinese conditional 权相异则破其判 (:274) read the same way, while PLAN item 6 says 'can break it'.

**Better replacement.** Use the proposed wording, but in 03 put it after a semicolon so the clauses stay apart: '…(`ListingValuation.splitsKeep_of_net`, `ListingValuation.splitsKeep_of_off_le_go`); a shared valuation with the weights apart can break it (`ListingValuation.WeightsApart.not_splitsKeep`), and factoring on the holding formation's listing alone does not suffice (`ListingValuation.OneListing.refined_lowers`)'. The record's English law stays inside its 420-character cap (256 to about 285).

### X2 (exactness, medium, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming.lean:2877; experiments/integrated-correction/general-framework/generative-basis/lean/becoming/check_becoming.py:2965 (sources: _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/integrate_rfm3.py:86 and :70)

**Quoted.** Becoming.lean: a rule with no residual through a finer map falls short by at most any rule through a coarser one (`ListingValuation.informed_le`), and over every refinement holding for the answer never stands lower exactly where splits keep the worth (`ListingValuation.refining_never_lowers_iff`) | check_becoming.py: and holding for the answer never stands lower through every refinement exactly where splits keep the worth

**Problem.** refining_never_lowers_iff quantifies only over pairs of maps that factor on both formations' listings: π c = f (π' c) for c ∈ m.listed and for c ∈ pm.listed. It also requires zs listed once and covering m.listed, and zs' listed once and covering both listings. Both sentences put 'every refinement' right after informed_le's 'finer map', which factors on the holding formation's listing alone, so they read as including such maps. Under that reading the iff is false: in OneListing.refined_lowers, SplitsKeep holds, yet a refinement that factors on the holding listing alone lowers the worth from 1 (identity) to 0 (one cell). 03 §12, the module header, the record's law 11 and PLAN item 6 all say 'on both listings'; these two summaries drop it. A secondary omission: both state shortfall_split ('falls short by the least shortfall through it plus a residual') without the split's cell condition (cells listed once each and covering).

**Replacement.** Becoming.lean: '…and over every refinement factoring on both formations' listings, holding for the answer never stands lower exactly where splits keep the worth (`ListingValuation.refining_never_lowers_iff`)'. check_becoming.py: 'and holding for the answer never stands lower through every refinement factoring on both listings exactly where splits keep the worth'. Optionally also 'over cells listed once each and covering, any rule through the map falls short by …'.

**Verdict: real.** `refining_never_lowers_iff` (:1528) quantifies only over maps that factor on both listings, with zs listed once and covering m.listed and zs' covering both. The module itself calls factoring on the holding listing alone 'a refinement' (the least_falls, refined_lt_iff and coarser_not_above docstrings), and over those maps the iff fails: in `OneListing.refined_lowers` SplitsKeep holds, yet the worth falls from 1 through id to 0 through one cell. Becoming.lean:2877 and check_becoming.py:2965 say 'every refinement' without the 'both listings' qualifier that 03 §12, the header, the record's law on the criterion and PLAN item 6 all carry.

### X3 (exactness, medium, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:517 (source kit/round2c/s12_rfm3.txt:2); _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/study_rfm3.txt:69 and :72

**Quoted.** by the reading formation's own current valuation, on the holding formation's model, no rule through the map stands higher than its answer, and a revaluation lowers it exactly where it decides some listed cell against the current valuation's strict weighted preference (`ListingValuation.own_least`, `ListingValuation.revalued_lowers_iff`); by the revised valuation the revised answer has no residual (`ListingValuation.outcome_least`)

**Problem.** own_least, revalued_lowers_iff and outcome_least use one model m both to form the answer (answer m g l π) and to evaluate it. Their hypothesis is therefore that the reading formation's model is the holding formation's. The text says only 'on the holding formation's model', and the same paragraph has just used that phrase for where the evaluation is made ('By a supplied reference valuation on the holding formation's model, a rule through the map falls short …'), not as a condition on the reading formation's model. Read that way, the claim is refuted in this module. In WeightsApart (models apart, valuation = reference = gain/loss), the answer through the cells {0, 1} and {2} has residual 1 (WeightsApart.weights_split). So, by the reading formation's own valuation evaluated on the holding formation's model, leastThrough through that map stands strictly higher (worth 3 against the answer's 2), and the revised answer's residual need not be 0. The record's law 23, the module header and the docstrings all say 'its model the holding formation's'.

**Replacement.** 'with the reference the reading formation's own current valuation and its model the holding formation's, no rule through the map stands higher than its answer, and a revaluation lowers it exactly where … (`ListingValuation.own_least`, `ListingValuation.revalued_lowers_iff`); with that shared model, by the revised valuation the revised answer has no residual (`ListingValuation.outcome_least`)'. Change the study's lines 69 and 72 the same way: 'by the reading formation's own current valuation, its model the holding formation's, …'.

**Verdict: real.** own_least (:998), revalued_lowers_iff (:1010) and outcome_least (:1024) form the answer on the same model m they evaluate on, so they need the reading formation's model to be the holding formation's. 03 §12 says only 'on the holding formation's model', a phrase its own paragraph uses for where the reference evaluates, and it gives outcome_least no model condition; study lines 68–72 do the same. With the models apart this fails: in WeightsApart, with valuation equal to reference, the answer through {0, 1} and {2} has residual 1 (weights_split) and is worth 2, against 3 for leastThrough.

### X4 (exactness, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/make_records_rfm3.py:305 (EN), :308 (ZH), :403–406 (hypothesis, EN and ZH)

**Quoted.** By the valuation after a revaluation, the revised answer has no residual, which endorses no revaluation, … / 依改后之值，改后之答无余缺 | own_least, revalued_lowers_iff, revaluing_gain and revaluing_gains_iff take its model to be the holding formation's, residual_pos_of_gains any model.

**Problem.** outcome_least is stated with one model m for both formations: residual m g' l' π zs (answer m g' l' π) = 0. It therefore needs the reading formation's model to be the holding formation's. The record's law gives it no model condition, and the hypothesis listing which theorems take the shared model leaves it out. The record therefore reads as if outcome_least held for any model, like residual_pos_of_gains. With the models apart it fails: in WeightsApart.weights_split, through the cells {0, 1} and {2}, the reading formation's answer has residual 1 by a reference equal to its own valuation (gain, loss).

**Replacement.** Law: 'With the reading formation's model the holding formation's, by the valuation after a revaluation the revised answer has no residual, …' / '读之形成之模型即持之形成之模型，则依改后之值，改后之答无余缺……'. Hypothesis: 'own_least, revalued_lowers_iff, outcome_least, revaluing_gain and revaluing_gains_iff take its model to be the holding formation's, residual_pos_of_gains any model.' / 'own_least、revalued_lowers_iff、outcome_least、revaluing_gain 与 revaluing_gains_iff 取其模型为持之形成之模型，residual_pos_of_gains 取任一模型。'

**Verdict: real.** outcome_least (:1024) states residual m g' l' π zs (answer m g' l' π) = 0, with one model for both formations. The record's law (:305/:308) gives no model condition. Its hypothesis (:403–406) lists own_least, revalued_lowers_iff, revaluing_gain and revaluing_gains_iff as taking the shared model and leaves outcome_least out, although with the models apart the claim fails (WeightsApart.weights_split: residual 1 with valuation equal to reference).

### X5 (exactness, low, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ListingValuation.lean:79; theories/becoming/chapters/03-KNOWING.md:517; _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/make_records_rfm3.py:285 (EN), :287 (ZH); _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/study_rfm3.txt:63; _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:397

**Quoted.** with both answers least, the least shortfalls and the amounts alone decide (`forgone_least_iff`), so through a refinement holding for the coarser answer, forgoing no less, never stands above holding for the finer (`coarser_not_above`) | ZH: 二答皆最少，则最少所缺与其量定之 | PLAN: through a refinement, with both answers least, the coarser answer forgoing no less never stands above the finer

**Problem.** forgone_least_iff and coarser_not_above assume a shared model m (the answers are answer m g l π and answer m g l π') and net agreement at every listed candidate of positive weight. That both answers are least follows from these (answer_least_of_net); it is not the theorems' hypothesis. The weaker statement does follow in a line from forgone_through_lt_iff (with least_falls), but the cited theorems do not state it. Their docstrings and PLAN item 7 ('a shared model and net agreement') give the actual hypotheses.

**Replacement.** 'with a shared model and net agreement, so both answers least, the least shortfalls and the amounts alone decide (`forgone_least_iff`), so …'. ZH: '共模型且净相合（故二答皆最少），则最少所缺与其量定之'. PLAN §13: 'through a refinement, with a shared model and net agreement, the coarser answer forgoing no less never stands above the finer'.

**Verdict: real.** forgone_least_iff (:924) and coarser_not_above (:946) take a shared model m and `net` as hypotheses, not 'both answers least'. The weaker form does follow from forgone_through_lt_iff and least_falls, but it is not what the cited theorems state. PLAN item 7 already gives '(a shared model and net agreement)'.

**Better replacement.** Use the proposed wording for 03, the header, the study and PLAN §13, but not in the record's English law (:285), which is at 404 of its 420-character cap: the proposed insertion would bring it to about 442 and fail capped(). There, replace 'with both answers least' with 'with a shared model and net agreement' (about 418 characters). Chinese: '共模型且净相合（故二答皆最少），则最少所缺与其量定之'.

### X6 (exactness, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:517; _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/make_records_rfm3.py:294 (EN), :298 (ZH); _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/study_rfm3.txt:66; _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:211 (source kit/round2c/plan_rfm3.py:100)

**Quoted.** *Revaluing*: at one model and map, two valuations' answers fall short by amounts that differ exactly as their residuals do | Revaluing: at one model and one map / 改值：于一模型一映射 | At one model and one map, two valuations' answers have shortfalls that differ exactly as their residuals do

**Problem.** revalued_split and revalued_forgone_lt_iff take two models, m (holding) and pm (reading), with the reference and the map fixed. The answers are answer pm g l π and answer pm g' l' π, evaluated on m. 'At one model' either suggests a shared model, which narrows a result that holds with the models apart, or leaves the reading formation's model unstated. The header and both docstrings say 'With the holding formation's model, the reading formation's model, the reference and the map fixed'.

**Replacement.** 'with the holding formation's model, the reading formation's model, the reference and the map fixed, two valuations' answers …' / '持之形成之模型、读之形成之模型、参照与映射皆定，二值之答……'

**Verdict: real.** revalued_split (:982) and revalued_forgone_lt_iff (:1092) take two models (the answers are formed on pm, the shortfalls measured on m) and hold with the models apart. The header (:81–83) and the docstrings say exactly that: 'the holding formation's model, the reading formation's model, the reference and the map fixed'. 'At one model and map' in 03, the study (:66), the record (:294/:298) and PLAN item 8 either suggests a shared model, which narrows the result, or leaves the reading model unstated; nothing in it is false, but the hypotheses are stated inexactly.

**Better replacement.** Use the proposed wording in 03, the study and PLAN. The record's English law (:294) is at 356 of its 420-character cap, and the proposed phrase would bring it to about 431 and fail the cap. Use 'Revaluing: with both models, the reference and the map fixed, two valuations' answers have shortfalls differing exactly as their residuals do…' (about 381 characters) / '改值：二模型、参照与映射皆定，二值之答之所缺之差恰如其余缺之差；…'.

### X7 (exactness, low, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ListingValuation.lean:40–44 and :76–79; _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM3-LEAN.md:1429 (R5)

**Quoted.** Told the candidate, with net agreement where the reading formation gives positive weight, the residual is nothing exactly where … | Forgoing the same amount through a refinement, holding for the coarser rule stands above holding for the finer exactly where the finer rule's residual exceeds the coarser's by more than the least shortfall falls (`refined_lt_iff`) | R5: the coarser map's cells are named only for the criterion over every refinement and for `refined_lt_iff`

**Problem.** told_residual_zero_iff needs its cell list to cover the holding formation's listing (covers : ∀ c ∈ m.listed, c ∈ zs). refined_lt_iff needs both maps' cells listed once each and covering (once, covers, once', covers'). The header's Informing bullet supplies only π''s cells, and the coarser map's cells only for informed_lt_iff. Neither the told sentence nor the refined_lt_iff sentence states its cell condition, although the record's hypotheses H2 and H3 and the docstrings do. Evidence row R5 says the header names the coarser cells for refined_lt_iff, which it does not.

**Replacement.** 'Told the candidate, over cells covering the holding formation's listing, with net agreement …'; 'Forgoing the same amount through a refinement, both maps' cells listed once each and covering the holding formation's listing, holding for the coarser rule …'. Then correct R5 to match what the header states.

**Verdict: real.** told_residual_zero_iff (:637–638) needs `covers`, and refined_lt_iff (:903–907) needs both maps' cells listed once each and covering. The header's sentences on them (:40–44, :76–79) state neither condition; the header names the coarser map's cells only for informed_lt_iff (:54–56). So R5's row (REVIEW-RFM3-LEAN.md:1429), which says they are named 'for refined_lt_iff', does not match the header.

**Better replacement.** Edit the header as proposed (this needs a rebuild). R5's text is generated from evidence_rfm3_lean.py's RECHECK (:166), so correct it there and regenerate the page, e.g. '…the coarser map's cells are named only for the criterion over every refinement. Updated after the check of the delta (its point 1): the bullet also names them, listed once each and covering, for `informed_lt_iff`'. If the header gains the condition for refined_lt_iff, R5 can stay as it is.

### X8 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/make_records_rfm3.py:327 (EN), :331 (ZH)

**Quoted.** sensory, nothing, a world shown, a valuation input presented, or asked / 感为无、示一世界、呈一值之入或问

**Problem.** Input.shown carries o : O, what a demonstration shows (Reader.input w .demonstrate = .shown (rd.reveal w)), not a world. The update filters the listing to the worlds that show the same o. 'A world shown' says the world itself is sensed, which holds only where reveal is injective. The joint docstring, the study and the carrier's other laws say what a demonstration shows.

**Replacement.** 'sensory, nothing, what a demonstration shows, an input presented, or asked' / '感为无、示之所显、所呈之入或问'

**Verdict: real.** Input.shown carries o : O, and Reader.input w .demonstrate = .shown (rd.reveal w) (:1773–1828); the update filters the listing by that o. So the sensory part holds what a demonstration shows, which is a world only where reveal is the identity, as in TwoWorlds. The record's carrier law (:327/:331) says 'a world shown' / 示一世界, while the Input docstring and the study (:82–83) say 'what a demonstration shows'.

### X9 (exactness, low, confirmed)

**Location.** theories/becoming/review/ALIGNMENT.md:28 (source _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/integrate_rfm3.py:223)

**Quoted.** From different starts the answers and the final state do not tell whether the valuation changed, and no criterion of legitimate change is supplied (Carroll, Dragan, Russell and Hadfield-Menell 2022).

**Problem.** TwoWorlds.not_lumped is one witness. From two particular starts (TwoWorlds.starts_apart), the record of the answers and the state at T are alike while the valuation changed on one route alone. It does not show that, from different starts, the answers and the final state never tell. The header itself says neither an ambiguity from one start nor a test of legitimate change is shown, and 03 §12 states the result as a witness.

**Replacement.** 'From different starts, the answers and the final state can fail to tell whether the valuation changed (one witness), and no criterion of legitimate change is supplied (…)'.

**Verdict: real.** TwoWorlds.not_lumped (:2408) is about two particular executable routes from two particular starts. The header (:143–148) and 03 §12's Reading ('The witness shows only that, across two starts…') present it as a witness, and 07 §7 and the overview say 'can'. ALIGNMENT.md:28's 'From different starts the answers and the final state do not tell whether the valuation changed' reads as a general claim.

**Better replacement.** Either the proposed wording or, in 07's and the overview's terms: 'From different starts a route informing and one revaluing can answer alike and end in one state, so these need not tell whether the valuation changed, and no criterion of legitimate change is supplied (Carroll, Dragan, Russell and Hadfield-Menell 2022).'

### X10 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/make_records_rfm3.py:217–222

**Quoted.** EN: so a rule with no residual stands at least as high, and so does the reading formation's answer where its model is the holding formation's and it agrees in net. | ZH: 故无余缺之规则不低，其所缺不逾经较粗映射之任一规则；读之形成之模型即持之形成之模型且净相合时，其答亦然。

**Problem.** The Chinese adds 其所缺不逾经较粗映射之任一规则 ('its shortfall is at most any rule's through the coarser map'), which the English lacks. The clause is equivalent through after_le_iff_shortfall and matches informed_le's statement, so nothing in it is false, but the two languages state different content.

**Replacement.** EN: 'so a rule with no residual falls short by at most any rule through the coarser map and stands at least as high, and so does …'. Alternatively, drop the clause from the Chinese.

**Verdict: real.** The Chinese law (:222) adds 其所缺不逾经较粗映射之任一规则, informed_le's shortfall conjunct, which the English (:217–221) lacks. Nothing in it is false, since the two forms are equivalent through after_le_iff_shortfall, but the two languages of one law item say different things.

**Better replacement.** Drop the clause from the Chinese ('…故无余缺之规则不低；读之形成之模型即持之形成之模型且净相合时，其答亦然。'). The English item is at 410 of its 420-character cap, so the proposed English addition (about 55 characters) would fail capped().

### X11 (exactness, low, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/README.zh.md:129 (source _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/integrate_rfm3.py:124); _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/make_records_rfm3.py:481 (alias)

**Quoted.** 值为态：告与改读之形成之值 | alias '告与改读之形成之值'

**Problem.** The English has 'informing and revaluing a reading formation' in both the row and the alias. The Chinese most readily parses as 告与改[读之形成之值], 'informing and revising the reading formation's valuation', which makes informing act on the valuation. In the Lean (Reader.update), a demonstration filters the listing, and only a presented input revises the valuation.

**Replacement.** '告读之形成与改其值': row '值为态：告读之形成与改其值，以自然数计…', and the alias likewise.

**Verdict: real.** In the Lean a demonstration filters the listing, and only a presented input revises the valuation (Reader.update, :1811–1815). 告与改读之形成之值 most naturally parses as informing and revising the reading formation's valuation, while the English row and alias (make_records_rfm3.py:481) say 'informing and revaluing a reading formation'.

### X12 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:211 and :213 (source kit/round2c/plan_rfm3.py:105)

**Quoted.** in 10 it rises from 0 to 1 from one cell to the cells {1, 2} and {3} | 2 through the cells {1, 2} and {3}

**Problem.** WeightsApart's candidates are 0, 1 and 2, and the map decide (c = 2) gives the cells {0, 1} and {2}. The plan counts from one and names a cell {3} that does not exist in the Lean; a reader checking against the Lean finds {2} as the singleton. The record and the header say 'the cells of the first two candidates and of the third'.

**Replacement.** 'the cells {0, 1} and {2}', or 'the cells of the first two candidates and of the third'.

**Verdict: real.** WeightsApart's candidates are the naturals 0, 1 and 2 (:1627), and the middle map decide (c = 2) has cells {0, 1} and {2} (:1645, :1656). PLAN items 8 and 10 (:211, :213) count from one, although §4.8 says it states the design under the Lean's names. Read with the Lean's names, cells {0} and {1, 2} give a worth of 3, not 2.

**Better replacement.** Write 'the cells of the first two candidates and of the third', as the header and the record do; or name the candidates 0, 1 and 2 in item 10 and write {0, 1} and {2}.

### X13 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:200

**Quoted.** its *listing* (candidate worlds with weights)

**Problem.** In the carrier, the listing component of the state is List W only. The weights belong to the law (Reader.weight) and are fixed, never revised. A demonstration filters the list and leaves the weights unchanged (answer_shown; the record says 'weights and valuation unchanged'). 'With weights' makes the weights part of the revisable state.

**Replacement.** 'its *listing* (the candidate worlds it keeps, weighted by its law's fixed weights)'

**Verdict: real.** The carrier's state is List W × V (joint, :1853–1854), and the weights belong to the law (Reader.weight) and are never updated. E17 changed the header to '(candidates, weighted by its law)' (:15), but PLAN §4.8's opening (:200) still says '(candidate worlds with weights)', in a sentence saying each component is changed only by its own update.

**Better replacement.** Use the header's words: 'its *listing* (candidate worlds, weighted by its law)'.

### X14 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:207

**Quoted.** *Told the candidate, the answer has a residual, and falls short, exactly where an unweighted candidate is one to stop* … Through the identity map, with the reading formation's valuation agreeing in net

**Problem.** By told_residual_zero_iff and told_shortfall_zero_iff, the residual (and the shortfall) is positive exactly where some candidate meets three conditions: the holding formation lists it with positive weight, its loss exceeds its gain, and it has zero total weight in the reading formation's listing. An unweighted candidate that the holding formation does not weigh adds nothing. The title drops that condition; the docstring title keeps it ('a candidate the holding formation weighs, unweighted by the reading formation'). The body also omits that, for the residual form, the cell list must cover the holding formation's listing.

**Replacement.** Title: '*Told the candidate, the answer has a residual, and falls short, exactly where a candidate the holding formation weighs, unweighted by the reading formation, is one to stop*'. Body: 'Through the identity map, over cells covering the holding formation's listing, with …'.

**Verdict: real.** told_residual_zero_iff and told_shortfall_zero_iff (:637–641, :687–690) make the residual and the shortfall positive exactly where some candidate the holding formation lists with positive weight, with loss above gain, has zero total weight in the reading listing. The PLAN title (:207) drops the holding formation's weighing, which the docstring title (:629–630) keeps. The body's cover condition is already supplied by Part 1's heading (:202, 'cells listed once and covering every listed candidate's cell'), so only the half of the finding about the title holds.

**Better replacement.** Change the title as proposed. The body can stay, since Part 1's heading gives the cover.

### X15 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:209 (source kit/round2c/plan_rfm3.py:82)

**Quoted.** a criterion of monotonicity under refinement, not of agreement with the reference, and weaker than the answer being least at every cell

**Problem.** 'Weaker than' claims two things: that the answer being least implies SplitsKeep, and that the converse fails. The Lean proves only the second, through release_keeps (SplitsKeep with a residual). No theorem states the first, and 'least at every cell' names no map. The header and the docstrings stop at 'not of agreement with the reference'.

**Replacement.** 'a criterion of monotonicity under refinement, not of agreement with the reference: it can hold where the answer has a residual (`release_keeps`)'

**Verdict: real.** The module shows only that SplitsKeep can hold where the answer has a residual (release_keeps, :1584); no theorem states that the answer being least implies SplitsKeep. 'Least at every cell' also names no map: in WeightsApart the answer has residual 0 through the identity and through one cell (weights_split), yet SplitsKeep fails (not_splitsKeep). The implication holds only for 'least through every map', by composing informed_le with refining_never_lowers_iff.

### X16 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:397

**Quoted.** the course forms of the four cases

**Problem.** The added course forms are TwoWorlds.shown_course and TwoWorlds.presented_course. They cover only the two cases in which the act turns the answer: shown, from both worlds listed, and presented, from the first world alone. They do not cover all four cases.

**Replacement.** 'the course forms of the two turning cases (`TwoWorlds.shown_course`, `TwoWorlds.presented_course`)'

**Verdict: real.** Only TwoWorlds.shown_course (:2279) and TwoWorlds.presented_course (:2306) were added, as F8 asked; they cover the two cases in which the act turns the answer ((a) shown, (b) presented). PLAN:397's 'the course forms of the four cases' reads as one course form per case, while the study says just 'the course forms'.

### X17 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM3-LEAN.md:1229 (A10), :1265 (F14), :1280 (L9), :1425 (R1)

**Quoted.** A10: (the study leaves their extraction to the owners) | F14: joint's docstring says the same | L9: `informed_le` (with `informed_le_add_residual`, `refined_lt_iff`) composes `finer_least_le` with the split | R1: the record's laws and correspondence, 03 §12's paragraph and the study likewise

**Problem.** The rows do not match the texts as they now stand. A10: the study (line 189) leaves only total_lt_of_mem to Flow's owner and says nothing of cond_zero_le or Weighting.term_le_of. F14: joint's docstring says the answer is exposed at every step and that going on and switching off are sensed as nothing and change no world; it does not say that holding changes neither the world nor the reading formation, nor that holding's worth is counted in Part 1. L9: the Standing now groups refined_lt_iff with informed_lt_iff and coarser_not_above, as composing least_falls with the split. R1: the phrase 'from one state of each formation' appears in the record's laws (line 349) but not in its correspondence.

**Replacement.** A10: '(the study leaves `total_lt_of_mem`'s extraction to `Flow`'s owner)', or add cond_zero_le to the study's sentence. F14: 'joint's docstring says the answer is exposed at every step, asked or not, and that going on and switching off are sensed as nothing and change no world'. L9: '`informed_le` and `informed_le_add_residual` compose `finer_least_le` with the split, and `informed_lt_iff`, `refined_lt_iff` and `coarser_not_above` compose `least_falls` with it'. R1: 'the record's laws, 03 §12's paragraph and the study likewise'.

**Verdict: real.** A10 (:1229) says the study leaves both lemmas' extraction to the owners, but study_rfm3.txt:189 leaves only total_lt_of_mem to Flow's owner. F14 (:1265) says joint's docstring 'says the same', but that docstring (:1850–1852) says only that the answer is exposed asked or not and that going on and switching off are sensed as nothing and change no world. L9 (:1280) groups refined_lt_iff with finer_least_le, while the Standing (:163–164) now groups it with least_falls; R1 (:1425) names the record's correspondence, which lacks 'from one state of each formation' (only the law at make_records_rfm3.py:349 has it).

**Better replacement.** Use the proposed wording, but make the change in the generator rather than on the page. A10 and R1 are in evidence_rfm3_lean.py's TAKEN_A (:84) and RECHECK (:151). F14 and L9 come from the check's data, so correct them through AFTER entries, then regenerate REVIEW-RFM3-LEAN.md.

### X18 (exactness, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/make_records_rfm3.py:30; _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:402

**Quoted.** KITD + 'evidence/REVIEW-RFM3-COLDREAD.md' | kit/round2c/ (`kit/round2c/`): the third part's, with the design's review in REVIEW-RFM3 (`evidence/REVIEW-RFM3.md`) and the Lean's in REVIEW-RFM3-LEAN (`evidence/REVIEW-RFM3-LEAN.md`).

**Problem.** The record's references cite evidence/REVIEW-RFM3-COLDREAD.md, which does not yet exist in evidence/; the study's paragraph is still the {COLDREAD} placeholder (study_rfm3.txt:185). PLAN's evidence list does not name the file, although its RF-M.2 entry names REVIEW-RFM2-COLDREAD. Unless the file is written before registration, the record's reference dangles and the two texts disagree.

**Replacement.** Before registering, write evidence/REVIEW-RFM3-COLDREAD.md (evidence_rfm3_coldread.py) and fill the study's {COLDREAD}. Add to PLAN.md:402: '…and the Lean's in REVIEW-RFM3-LEAN (`evidence/REVIEW-RFM3-LEAN.md`), and the cold read of its texts in REVIEW-RFM3-COLDREAD (`evidence/REVIEW-RFM3-COLDREAD.md`).'

**Verdict: real.** This holds only in part. PLAN's Evidence list (:402) names RF-M.2's cold-read file but not REVIEW-RFM3-COLDREAD, and §13 has no paragraph on the third part's cold read, although board_rfm3.py's row says what each finding became is in plan §13 and no kit script (plan_rfm3.py included) adds either. The rest is by design: evidence_rfm3_coldread.py writes the file and {COLDREAD} is filled at landing, and make_records_rfm3.py's sha() would fail rather than leave a dangling reference.

**Better replacement.** Leave the record's references as they are. At landing, add to PLAN.md:402 '…and the Lean's in REVIEW-RFM3-LEAN (`evidence/REVIEW-RFM3-LEAN.md`) and the cold read of its texts in REVIEW-RFM3-COLDREAD (`evidence/REVIEW-RFM3-COLDREAD.md`)', and add a §13 paragraph 'The cold read of the third part's texts', as RF-M.2 has.

### X19 (exactness, low, confirmed)

**Location.** theories/becoming/chapters/08-METHOD.md:486

**Quoted.** The off-switch game's information value (Hadfield-Menell, Dragan, Abbeel and Russell 2017) is not represented here: holding an act for a reading is the bullet above's.

**Problem.** The bullet on holding an act for a reading ('What holding an act for a reading is worth', 03 §12) is at line 487, below RR's bullet at line 486; RF-M.3's bullet follows at line 488. This is already wrong in main, but it sits next to RF-M.3's insertion.

**Replacement.** '…is not represented here: holding an act for a reading is the next bullet's.'

**Verdict: real.** In 08 §8 the RR bullet (line 486) says 'holding an act for a reading is the bullet above's', but the bullet on what holding an act for a reading is worth is the next one (487); the bullet above (485) is about complying when read. Main has the same order (RR at 487, holding at 488), so the slip predates RF-M.3 and lies in RR's bullet, not in RF-M.3's text.

### R1 (readings, medium, confirmed)

**Location.** theories/becoming/review/ALIGNMENT.md:28 (account at :41)

**Quoted.** evaluated by the current valuation on a shared model, there is none against informing and a reason to keep the valuation from any revision deciding a listed cell against its strict weighted preference, beside the preservation incentive of current-reward-function evaluation (Everitt, Hutter, Kumar and Krakovna 2021, Claim 2).

**Problem.** Everitt et al. do not give the preservation incentive to current-reward-function evaluation as such.
- Their Claim 2 says that, under Assumptions 1–3, preserving the implemented reward function is the only instrumental goal a current-RF agent that anticipates time inconsistency (TI-considering) may have for it.
- Their Claim 3 says the current-RF agent that ignores time inconsistency has no instrumental goal to influence that function. They present this as sidestepping Omohundro's preservation argument.

The module, 03 §12 and plan §8 name the TI-considering agent; the dossier, the most-read text, drops it. Line 41 says these works, arXiv 1908.04734 among them, were checked against their texts.

**Replacement.** …, beside the preservation incentive their Claim 2 permits a current-reward-function agent that anticipates time inconsistency (Everitt, Hutter, Kumar and Krakovna 2021).

**Verdict: real.** ALIGNMENT.md:28 says "the preservation incentive of current-reward-function evaluation (… Claim 2)", and :41 says arXiv 1908.04734 was checked. The repository's own source checks say Claim 2 permits a preservation incentive only to the agent anticipating time inconsistency, and Claim 3 removes the influence incentive for the agent ignoring it (REVIEW-RFM3.md finding 21; REVIEW-RFM3-LEAN.md L2: the ignoring agent's counterpart in counts would be indifference to revaluation). The module's Readings (:221-230) and 03 §12 name that agent; plan §4.8 does too (§8's row only says "their Claim 2 permits"). In the proposed replacement, "their Claim 2" follows Kamenica and Gentzkow in the same sentence, so it could be read as theirs.

**Better replacement.** …, beside the preservation incentive of current-reward-function evaluation by an agent that anticipates time inconsistency (Everitt, Hutter, Kumar and Krakovna 2021, Claim 2).

### R2 (readings, medium, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/make_records_rfm3.py:472-473 (en) and :479 (zh), record a-reading-informed-and-revalued, correspondence

**Quoted.** own_least with revalued_lowers_iff is a one-decision counterpart of current-reward-function evaluation's preservation incentive (Everitt et al. 2021, Claim 2) / own_least 与 revalued_lowers_iff 为以当下奖励函数评估之保存之诱因（Everitt 等 2021，Claim 2）于一次抉择之对应

**Problem.** Same misattribution as R1, in the result's home record, which research-find and the generated pages show. Claim 2's incentive belongs to the TI-considering agent only; Claim 3 gives the TI-ignoring current-RF agent none.

**Replacement.** en: "own_least with revalued_lowers_iff is a one-decision counterpart of current-reward-function evaluation's preservation incentive for an agent anticipating time inconsistency (Everitt et al. 2021, Claim 2)". Adds 44 characters; with R7 and R9 the correspondence is 1196 of the 1200 cap.

zh: "own_least 与 revalued_lowers_iff 为以当下奖励函数评估而顾及时间不一致者之保存之诱因（Everitt 等 2021，Claim 2）于一次抉择之对应". With R7 and R9, 462 of 500.

**Verdict: real.** The record's correspondence (make_records_rfm3.py:472-473; zh :479) has the same unqualified "current-reward-function evaluation's preservation incentive (Everitt et al. 2021, Claim 2)". The module's Readings and the reviews' account of Claims 2 and 3 tie that incentive to the agent that anticipates time inconsistency. The replacement fits the caps: the en field is 1110 characters now; R2 adds 45 (not 44), R7 14 and R9 27, giving 1196 of 1200. The zh field comes to 462 of 500.

### R3 (readings, low, confirmed)

**Location.** theories/becoming/chapters/08-METHOD.md:488; _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/study_rfm3.txt:158-160

**Quoted.** evaluating by the reading formation's current valuation on a shared model is a one-decision counterpart of current-reward-function evaluation (Everitt, Hutter, Kumar and Krakovna 2021): no revaluation gains, and one that decides a listed cell against the current strict weighted preference loses, the preservation incentive their Claim 2 permits

**Problem.** "their Claim 2 permits" is accurate, but the counterpart is named as current-reward-function evaluation in general. Only the TI-considering agent fits, because the answer held for is the revised valuation's; Claim 3's TI-ignoring current-RF agent has no such incentive. The module (Readings) and 03 §12 name that agent; 08 §8 and the study do not, so the texts differ.

**Replacement.** 08: "…is a one-decision counterpart of current-reward-function evaluation by an agent that anticipates time inconsistency (Everitt, Hutter, Kumar and Krakovna 2021): no revaluation gains, and one that decides a listed cell against the current strict weighted preference loses, the preservation incentive their Claim 2 permits that agent;"

Study: "own_least with revalued_lowers_iff is a one-decision counterpart of current-reward-function evaluation by an agent that anticipates time inconsistency (Everitt, Hutter, Kumar and Krakovna 2021), the preservation incentive their Claim 2 permits it:"

**Verdict: real.** 08 §8 (:488) and the study (:157-160) call the result "a one-decision counterpart of current-reward-function evaluation" and then list the loss from a deciding revision. By the module's own account (:223-227) and L2's verdict, only the anticipating agent fits, because the answer held for is the revised valuation's; the ignoring agent (Claim 3) would be indifferent. "their Claim 2 permits" is accurate, but the counterpart's object is too general, and these two texts differ from the module and 03 §12, which name the agent. Low.

### R4 (readings, medium, refuted)

**Location.** theories/becoming/review/ALIGNMENT.md:28

**Quoted.** From different starts the answers and the final state do not tell whether the valuation changed, and no criterion of legitimate change is supplied (Carroll, Dragan, Russell and Hadfield-Menell 2022).

**Problem.** An unlabelled general law built on one witness. TwoWorlds.not_lumped shows two particular routes, one shown and one presented, from two particular starts whose answers and final state agree; it says nothing about every pair of starts.

The sentence also drops what the module header, 03 §12 and the record's law (starts_apart, lumped_with_start) keep:
- the starts differ, and with the start added the record determines whether the valuation changed;
- no case from one start is reached.

The overview says "can"; the dossier does not.

**Replacement.** From different starts a route informing and one revaluing can answer alike and end in one state while only one changes the valuation, the start telling them apart; no criterion of legitimate change is supplied (Carroll, Dragan, Russell and Hadfield-Menell 2022).

**Verdict: not real.** "Do not tell whether the valuation changed" denies a determination (`Learning.Lumped π g := ∀ i i', π i = π i' → g i = g i'`, Learning.lean:834), and one colliding pair establishes that, exactly as `TwoWorlds.not_lumped` does. The sentence asserts nothing about every pair of starts. Its "From different starts" keeps the difference of the starts, which the finding says was dropped. Leaving out "with the start added it does" in a summary cut for length removes a detail but states nothing the Lean does not prove; "can" is needed only in the overview's positive form.

### R5 (readings, low, refuted)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:289

**Quoted.** from different starts a route informing and one revaluing answer alike and end in one state, so the answers and the final state do not tell whether it changed

**Problem.** Plan §8's row generalizes the same way as R4. It drops "can", the restriction to these routes, and the fact that with the start added the record determines the property. Item 21 (line 227) keeps all three.

**Replacement.** from different starts a route informing and one revaluing can answer alike and end in one state, so on those routes the answers and the final state do not tell whether it changed (with the start added they do)

**Verdict: not real.** In this row, "a route informing and one revaluing answer alike and end in one state" reads as a description of the witness routes (`route_answers`, `routes_rest`). "So the answers and the final state do not tell whether it changed" denies a determination, which `not_lumped` proves. A literature-table row compresses, and item 21 of the same plan (:227) carries the full boundary. Adding "can" would be harmless, but nothing stated is wrong.

### R6 (readings, medium, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ListingValuation.lean:191-194; theories/becoming/chapters/03-KNOWING.md:519; _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:231

**Quoted.** The holding formation's choice among these is represented only by the comparisons of `forgone_lt_iff`, `refined_lt_iff` and `revalued_forgone_lt_iff` and the four alternatives of `Revaluing.revaluing_best`. (03: "the holding formation's choice among them represented only by the comparisons with amounts forgone and the four one-decision alternatives"; plan: "the holding formation's choice among these is represented only by the comparisons of 7, 8 and 13 and the alternatives of 14")

**Problem.** These say the holding formation's choice is represented, by the comparisons and the four alternatives. Revaluing.revaluing_best's own docstring and plan item 14 say no choice among them is represented. The witness is one decision with four valued alternatives and no formation choosing among them, and the comparisons order worth; they are not a choice rule.

The plan also lists 13 (revaluing_gain, revaluing_gains_iff, residual_pos_of_gains). These are not comparisons with amounts forgone; the module and 03 name only the theorems of items 7 and 8.

**Replacement.** Module: "No choice by the holding formation among these is represented: only the worth comparisons of `forgone_lt_iff`, `refined_lt_iff` and `revalued_forgone_lt_iff`, and the four valued alternatives of `Revaluing.revaluing_best`, relate them."

03: "…, with no choice by the holding formation among them represented, only the comparisons with amounts forgone and the four one-decision alternatives."

Plan: "no choice by the holding formation among these is represented, only the comparisons of 7 and 8 and the alternatives of 14"

**Verdict: real.** The module's Readings (:191-194) say the holding formation's choice "is represented only by" the comparisons and "the four alternatives of `Revaluing.revaluing_best`". That theorem's docstring (:1754-1756) and plan item 14 say "no choice among them is represented", and REVIEW-RFM3's row 18 records that the minimization is not represented as a choice. 03 §12 and plan §4.8 repeat the tension, and the plan adds 13, which the module and 03 do not list. This is a wording inconsistency, not a mathematical error. The replacements are right.

### R7 (readings, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/make_records_rfm3.py:476 (en) and :479 (zh)

**Quoted.** answer_constant is the off-switch game's Equation 1 for a constant policy (Hadfield-Menell et al. 2017) / answer_constant 为关机博弈之 Equation 1 于恒定之策（Hadfield-Menell 等 2017）

**Problem.** Equation 1 holds for any policy of the human, randomized ones included. A randomized policy constant in the utility gives waiting a mixture of the two moves, not the one committed move answer_constant states. The module, 03 §12 and the study say "a deterministic policy constant in the utility"; the record drops "deterministic", so it is looser than the other three texts.

**Replacement.** en: "answer_constant is the off-switch game's Equation 1 for a deterministic constant policy (Hadfield-Menell et al. 2017)"

zh: "answer_constant 为关机博弈之 Equation 1 于确定且恒定之策（Hadfield-Menell 等 2017）"

**Verdict: real.** The record (:476; zh :479) says "Equation 1 for a constant policy". The module (:243-245) notes that Equation 1 holds for any policy and that a randomized constant one gives a mixture of the two moves; 03 §12 and the study say "a deterministic policy constant in the utility". `answer_constant` states one committed move. The proposed "deterministic constant policy" (+14) fits the cap with R2 and R9 (1196/1200); the fuller wording used elsewhere (+29) would reach 1211 and break it.

### R8 (readings, low, confirmed)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/evidence/REVIEW-RFM3-LEAN.md:1425 (re-check table, row R1)

**Quoted.** Where two courses differ only in the world, the docstrings and the header say 'from one state of each formation'; the record's laws and correspondence, 03 §12's paragraph and the study likewise.

**Problem.** The "how" row claims more than the files show. The record's law (make_records_rfm3.py:349) carries "from one state of each formation", but its correspondence does not. The correspondence touches these courses only in "answer_constant is the off-switch game's Equation 1 for a constant policy", with no such condition.

**Replacement.** … Where two courses differ only in the world, the docstrings and the header say 'from one state of each formation'; the record's laws, 03 §12's paragraph and the study likewise.

**Verdict: real.** The re-check table's R1 row (REVIEW-RFM3-LEAN.md:1425) says "the record's laws and correspondence … likewise". The correspondence (make_records_rfm3.py:467-479) has neither "from one state of each formation" nor the order witness; it touches these courses only in "answer_constant is the off-switch game's Equation 1 for a constant policy". The record's laws do carry them (the law at :349 and the orders law), as do 03 §12's paragraph and the study. Dropping "and correspondence" makes the row accurate.

### R9 (readings, low, confirmed)

**Location.** theories/becoming/THE-THEORY-OF-BECOMING.md:102; theories/becoming/review/ALIGNMENT.md:28; _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/make_records_rfm3.py:470-471 and :479

**Quoted.** Read [AI reading]: under a reference it does not share, incentives to withhold and to revise; (dossier: "incentives to withhold and to revise before costs"; record: "AI reading: under a reference the valuation differs from, incentives to withhold and to revise, before costs;")

**Problem.** The module's Readings, 03 §12 and plan §4.8 say the incentive to revise holds only where the supplied update reaches such a valuation, which is not asserted:
- revaluing_gains_iff is an existence claim over unrestricted value functions;
- presented_forgone_lt_iff compares only a given input.

The re-check's R3 row says this was taken. The overview, the dossier and the record state the incentive to revise without it, and the overview also drops "before costs".

**Replacement.** Overview: "Read [AI reading]: under a reference it does not share, incentives before costs to withhold and, where the supplied update reaches such a valuation, to revise;"

Dossier: "incentives, before costs, to withhold and, where the supplied update reaches such a valuation, to revise"

Record en: "incentives to withhold and to revise (if the update reaches it), before costs;"

Record zh: "读为扣告与改（若所予之更新可达）之诱因，未计其费"

**Verdict: real.** The module's Readings (:189-191) read "incentives to withhold and to revise, in counts and before costs, the second only where the supplied update reaches such a valuation, which is not asserted". That limit was taken in on the re-check (its R3 row), and `revaluing_gains_iff` quantifies over an unrestricted pair of value functions. The overview (:102) drops both "before costs" and the limit. The dossier (:28) and the record's "AI reading" (:470-471, :479) keep "before costs" but drop the limit, so all three state a broader reading than the module gives. The replacements are right, and the record's fits the caps (see R2).

### R10 (readings, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:519

**Quoted.** their receiver breaks ties in the sender's favour and their prior is common, so the weights apart lie outside their model (Alonso and Câmara 2016)

**Problem.** The "so" makes the sender-favouring tie-break a reason the weights apart lie outside Kamenica and Gentzkow's model. Only the common prior is that reason; heterogeneous priors are Alonso and Câmara's extension. The tie-break is a separate difference: the answer here releases on ties, as the module and the plan say.

**Replacement.** their receiver breaks ties in the sender's favour, where the answer here releases; their prior is common, so the weights apart lie outside their model (heterogeneous priors: Alonso and Câmara 2016)

**Verdict: real.** In 03 §12's Reading, "their receiver breaks ties in the sender's favour and their prior is common, so the weights apart lie outside their model" makes the tie-break part of the reason. The module (:205-208) and plan §4.8 state the tie-break as a separate difference ("where the answer here releases") and give only the common prior as the reason, citing Alonso and Câmara for heterogeneous priors. 03 also drops the release at ties that makes the tie-break worth mentioning. The replacement is right.

### R11 (readings, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:519 (paraphrase also at study_rfm3.txt:165 and PLAN.md:289)

**Quoted.** who call frozen initial preferences a very crude baseline: by them a revision deciding a listed cell against the current valuation's strict weighted preference counts as a loss, wanted or not

**Problem.** "by them" can be read as "by Carroll and others", who say the opposite: not all preference shifts are unwanted, which is why they propose natural preference shifts. Their own description of initial preferences is "a first (very crude) proposal for safe shifts", not a baseline, and "frozen" is not their word. The module's "by it" (the evaluation) is unambiguous; 03 loses that.

**Replacement.** who call using the initial preferences as safe shifts a first, very crude proposal: evaluated by the current valuation, a revision deciding a listed cell against its strict weighted preference counts as a loss, wanted or not, and no criterion of legitimate, desired or autonomous change is supplied here

**Verdict: real.** Only the pronoun is confirmed. In 03 §12, "who call frozen initial preferences a very crude baseline: by them a revision … counts as a loss, wanted or not" lets "them" be read as Carroll and others, which would misattribute the view; the module's and plan §4.8's "by it" (the evaluation) are unambiguous. The wording claim cannot be confirmed from the files. The repository's checks against the paper themselves say Carroll and others "call frozen initial preferences a 'very crude' baseline" (REVIEW-RFM2.md:132) and the "frozen-initial-preference proposal 'very crude'" (REVIEW-RFM3.md:307), so the paraphrase need not change.

**Better replacement.** who call frozen initial preferences a very crude baseline: evaluated by the current valuation, a revision deciding a listed cell against its strict weighted preference counts as a loss, wanted or not, and no criterion of legitimate, desired or autonomous change is supplied here

### R12 (readings, low, refuted)

**Location.** theories/becoming/chapters/03-KNOWING.md:519

**Quoted.** What a reader of the answers alone leaves open is how the state that answered came to be, the route form of §11 (`#what-the-acts-show`)'s obstruction.

**Problem.** A general claim drawn from the witness, right after the sentence that limits it to two starts and says no case from one start is reached. On the two routes the answers alone leave it open; they need not always.

**Replacement.** What a reader of the answers alone can leave open is how the state that answered came to be, the route form of §11 (`#what-the-acts-show`)'s obstruction.

**Verdict: not real.** The sentence is in the labelled Reading paragraph, directly after "The witness shows only that, across two starts, the answers and the final state do not determine whether the valuation changed, while the record with the start does; a case of one start is not reached". Its scope is therefore given in place. "Leaves open" denies a determination, which the witness establishes (answers alike on both routes: `route_answers`, `routes_alike`), so it reads what the witness shows and is not a law.

### R13 (readings, low, confirmed)

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/ListingValuation.lean:155 (also :572); theories/becoming/chapters/08-METHOD.md:488; _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:229; _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/study_rfm3.txt:151

**Quoted.** thresholds of withholding against informing and of revaluing (`forgone_lt_iff`, `forgone_through_lt_iff`, `refined_lt_iff`, `coarser_not_above`, `revalued_forgone_lt_iff`)

**Problem.** The contribution is stated in the reading's words without its label. The theorems compare holding for a rule through a coarser map with one through a finer, each forgoing an amount. The module's own bullet (line 73) and docstrings (lines 851, 898, 918, 940) mark "withholding against informing" as a reading. The module's Standing, 08 §8, the plan's Standing and the study do not.

**Replacement.** Module: "thresholds of holding through a coarser map against a finer one (read as withholding against informing) and of revaluing (`forgone_lt_iff`, …)". Elsewhere: "the thresholds of a coarser map against a finer (read as withholding against informing) and of revaluing".

**Verdict: real.** The lens reviews judged that `forgone_lt_iff` and `forgone_through_lt_iff` compare any two rules or maps, so "withholding against informing" is a reading of one case (REVIEW-RFM3-LEAN E13, L13). The module's header bullet (:73) and docstrings (:851, :898, :918, :940) mark it so, but the module's Standing (:155), 08 §8 (:488), the plan's Standing (:229) and the study (:151) use those words unmarked to name the contribution. The proposed "holding through a coarser map against a finer one" misdescribes `forgone_lt_iff` and `forgone_through_lt_iff`, which assume no refinement.

**Better replacement.** Module: "the thresholds with amounts forgone (read as withholding against informing) and of revaluing (`forgone_lt_iff`, `forgone_through_lt_iff`, `refined_lt_iff`, `coarser_not_above`, `revalued_forgone_lt_iff`)". In 08 §8, the plan's Standing and the study: "the thresholds with amounts forgone (read as withholding against informing) and of revaluing".

### R14 (readings, low, refuted)

**Location.** theories/becoming/chapters/08-METHOD.md:488; _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/make_records_rfm3.py:467-470 ("In counts:")

**Quoted.** with a shared model, its criterion over every refinement is the counterpart, along the cells of the listing's partitions, of the convexity condition for full disclosure in Bayesian persuasion (Kamenica and Gentzkow 2011), no optimal signal or equilibrium represented

**Problem.** One claim carries two standings:
- 03 §12 and the study label the Kamenica–Gentzkow correspondence an AI reading ("Read so, this is a deterministic-partition comparison related to Bayesian persuasion").
- 08 §8 states it, unlabelled, as what the result "restates".
- The record puts it under "In counts:", before its "AI reading:".

**Replacement.** 08: "…; read [AI reading], with a shared model, its criterion over every refinement is the counterpart, along the cells of the listing's partitions, of the convexity condition for full disclosure in Bayesian persuasion (Kamenica and Gentzkow 2011), no optimal signal or equilibrium represented."

Record: move the SplitsKeep clause after "AI reading:". The length does not change.

**Verdict: not real.** This follows the landed convention. For RF-M.2, 03's labelled Reading holds Theorem 1 and Blackwell's partition case, 08 §8 states them as restatements, and the record lists them under "In counts:" before "AI reading:". The module's own Standing (:153-154) also states the Kamenica–Gentzkow counterpart as part of the contribution. The counterpart is mathematical: `SplitsKeep` unfolded is subadditivity of worth over splits into released and stopped parts, i.e. convexity of the indirect value along those splits once the weights are normalized. The cross-model re-check found it "appropriately restricted to deterministic partition splits". No reading is presented as a theorem beyond that convention.

### T1 (fit, medium, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:517; also rf-formations-that-read/kit/round2c/study_rfm3.txt:51, rf-formations-that-read/kit/round2c/make_records_rfm3.py:271-274 (law, en and zh), becoming/Becoming/ListingValuation.lean:69-70 and :1663

**Quoted.** not with the weights apart (`ListingValuation.WeightsApart.not_splitsKeep`)

**Problem.** Read plainly, this says splits never keep the worth when the weights are apart. That contradicts the clause just before it: splitsKeep_of_off_le_go takes the two formations' models as arbitrary (m pm) and holds whatever the weights. not_splitsKeep is a single witness, so the Lean shows only that the weights apart can break it, as plan §4.8 item 6 says ("the weights apart can break it"). The same universal appears in four more places: the study ("the weights apart break it"), the record's law ("The weights apart break the criterion" / "权相异则破其判"), the module header ("a shared valuation with the weights apart breaks it") and not_splitsKeep's title. "Break the criterion" also reads as the iff failing, when what fails is SplitsKeep.

**Replacement.** 03: "…(`ListingValuation.splitsKeep_of_net`, `ListingValuation.splitsKeep_of_off_le_go`), whatever the weights, and with the weights apart a shared valuation can fail it (`ListingValuation.WeightsApart.not_splitsKeep`); factoring on the holding formation's listing alone does not suffice (…)". Study: "the weights apart can break it (WeightsApart.not_splitsKeep)". Record: "With the weights apart, splits can fail to keep the worth: by its weights …" / zh "权相异，分可不守其值：依其权……". Module header: "a shared valuation with the weights apart can break it". Title at 1663: "**With the weights apart, splits can fail to keep the worth**".

**Verdict: real.** `WeightsApart.not_splitsKeep` (ListingValuation.lean:1667) proves ¬SplitsKeep for one witness only: shared gain/loss, holding weights 2,1,1 against reading weights 1,2,2. `splitsKeep_of_off_le_go` (L1513) takes `m` and `pm` arbitrary, so splits do keep the worth with the weights apart wherever off ≤ go. 03:517 lists "not with the weights apart" right after that clause, so read plainly it is a universal the Lean contradicts. The study (L51), the record's law (make_records_rfm3.py:271-274), the header (L69-70) and the docstring title (L1663) also state the witness generically, while plan item 6 correctly says "can break it".

**Better replacement.** 03: "…they keep it with a shared model and net agreement (`ListingValuation.splitsKeep_of_net`) and, whatever the models, wherever the reading formation's value of switching off is nowhere above that of going on (`ListingValuation.splitsKeep_of_off_le_go`); with the weights apart a shared valuation can fail it (`ListingValuation.WeightsApart.not_splitsKeep`), and factoring on the holding formation's listing alone does not suffice (…)". The proposal's "whatever the weights" after both citations would wrongly attach to splitsKeep_of_net, which needs a shared model. The study, record (en/zh), header and title take the proposal's "can fail/can break" wording.

### T2 (fit, medium, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:519; theories/becoming/chapters/07-SIGNIFICANCE.md:623

**Quoted.** some replacement valuation gains exactly where its answer decides a listed cell against the reference's strict weighted preference

**Problem.** In 03, "its" binds to "some replacement valuation". revaluing_gains_iff's condition is the current answer's residual, and the module's Readings say "its current answer". As written, the condition concerns the replacement's own answer, which is a different claim. 07's "gains exactly where its answer decides a listed cell against that reference's strict weighted preference" has the same gap. Its nearest antecedent is the valuation revalued to the reference, whose own answer has no residual by that reference (outcome_least), so on that reading the condition never holds.

**Replacement.** 03: "some replacement valuation gains exactly where the current answer decides a listed cell against the reference's strict weighted preference". 07: "gains exactly where its current answer decides a listed cell against that reference's strict weighted preference".

**Verdict: real.** `revaluing_gains_iff` (L1051-1055) conditions on `0 < residual … (answer m g l π)`, the current answer's residual. In 03:519, "some replacement valuation gains exactly where its answer decides…" binds "its" to the replacement. Yet the replacement revalued to the reference gains while its own answer has no residual (`revaluing_gain`, `answer_least_of_net`). 07:623 is ambiguous rather than clearly misbound, since "its" is most naturally the reading formation's. "Current" fixes both, as the module's Readings (L188) and plan §4.8 Readings (L231) already say.

### T3 (fit, medium, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:517; also rf-formations-that-read/kit/round2c/make_records_rfm3.py:294 and :298 (law, en and zh), rf-formations-that-read/kit/round2c/study_rfm3.txt:66, rf-formations-that-read/PLAN.md:211 (§4.8 item 8)

**Quoted.** *Revaluing*: at one model and map, two valuations' answers fall short by amounts that differ exactly as their residuals do

**Problem.** "At one model" reads as a shared model. revalued_split and revalued_forgone_lt_iff take the holding formation's model m and the reading formation's model pm apart, both fixed. The cross-model reader's A1 was taken on exactly this point: the module header (L81-83) and revalued_split's docstring now say "with the holding formation's model, the reading formation's model, the reference and the map fixed". The texts keep the wording A1 corrected: the record's law ("at one model and one map" / "于一模型一映射"), the study's Revaluing bullet and plan item 8 ("At one model and one map", though its next clause names both models). A reader would take revaluing's split to need a shared model, which the Lean does not assume.

**Replacement.** 03 and the study: "*Revaluing*: with both formations' models, the reference and the map fixed, two valuations' answers fall short by amounts that differ exactly as their residuals do". Record: "Revaluing: with both formations' models, the reference and the map fixed, …" / zh "改值：二形成之模型、参照与映射皆定，…". Plan item 8: "With both formations' models, the reference and the map fixed, …".

**Verdict: real.** `revalued_split` (L982) and `revalued_forgone_lt_iff` (L1092) take the holding model `m` and the reading model `pm` separately. The cross-model reader's A1 asked to name both fixed models precisely so that m ≠ pm is visible, and the header (L81-83) and docstring now do. 03:517 ("at one model and map"), the study (L66), the record's law (make_records_rfm3.py:294 and 298, "于一模型一映射") and plan item 8 (L211) keep "one model", which suggests a shared model the Lean does not assume. The plan's next clause names only the holding formation's model, not both as the finding says; that slip does not change the finding.

**Better replacement.** As proposed. Plan item 8: "With both formations' models, the reference and the map fixed, two valuations' answers have shortfalls that differ exactly as their residuals do: the least shortfall reads only the holding formation's model, the reference and the map; …". The record's law with this wording is 393/86 characters, within the 420/190 caps.

### T4 (fit, medium, refuted)

**Location.** theories/becoming/review/ALIGNMENT.md:28; also rf-formations-that-read/PLAN.md:289 (§8 row)

**Quoted.** From different starts the answers and the final state do not tell whether the valuation changed

**Problem.** The budget cut dropped the witness qualifier. TwoWorlds.not_lumped is one pair of executable routes, so the Lean shows only that the answers and the final state can fail to tell whether the valuation changed. As written, this is a universal the Lean does not prove; 03 §12 and the overview say "can". Plan §8's row says the same: "so the answers and the final state do not tell whether it changed".

**Replacement.** Dossier: "From different starts the answers and the final state can fail to tell whether the valuation changed (one pair of executable routes), and no criterion of legitimate change is supplied (…)". Plan row: "…so the answers and the final state need not tell whether it changed;".

**Verdict: not real.** `TwoWorlds.not_lumped` (L2408) is `¬ Learning.Lumped (record T) (changed T)`: the record does not determine the property. Non-determination is refuted by a single pair, so for routes from different starts, "the answers and the final state do not tell whether the valuation changed" says exactly what is proved. 03's Reading and the docstring use "do not determine" in the same sense. The plan row's "so" is scoped by its preceding clause, which names the two routes. Reading "do not tell" as "never tell" is not the natural reading.

### T5 (fit, medium, confirmed)

**Location.** theories/becoming/THE-THEORY-OF-BECOMING.md:102

**Quoted.** a finer map never raises the first, a revaluation moves only the second, and from different starts a route informing it and one revaluing it can answer alike and end in one state. Read [AI reading]: under a reference it does not share, incentives to withhold and to revise;

**Problem.** The cut kept that a finer map never raises the least shortfall but dropped that it can raise the residual by more. The paragraph then gives no basis for an incentive to withhold. A reader infers that informing never hurts, and the reading appears to contradict the law just stated (the dossier keeps "informing can lower the worth of holding"). The paragraph also opens "In natural-number counts" where its neighbours (L92-L100) state their standing ("Proved …"). "Least shortfall" and "residual" appear nowhere else on the page and are not glossed.

**Replacement.** "Proved in natural-number counts: by a reference valuation, holding for a reading formation's answer through a map falls short by the least any rule through the map falls short by, plus a residual where the answer decides cells against the reference; a finer map never raises the first but can raise the second by more, so informing can lower the worth; a revaluation moves only the second; and from different starts a route informing it and one revaluing it can answer alike and end in one state. Read [AI reading]: …" (the rest unchanged).

**Verdict: real.** L102 states only that a finer map never raises the least shortfall and that a revaluation moves only the residual, then reads "incentives to withhold". Nothing the paragraph states supports withholding. A finer map can raise the residual by more than the least shortfall falls (`Informing.informing_lowers`: least 1→0, residual 0→11), and the paragraph omits it, so it implies the separation the module calls "not general" (L138-139). The neighbouring paragraphs L92-L100 open "Proved …", and "least shortfall" and "residual" occur nowhere else on the page.

**Better replacement.** Closer to the reading budget: "…Proved in natural-number counts: by a reference valuation, holding for a reading formation's answer through a map falls short by the least shortfall through the map plus a residual where the answer decides listed cells against the reference's strict weighted preference; a finer map never raises the first but can raise the second by more, a revaluation moves only the second, and from different starts a route informing it and one revaluing it can answer alike and end in one state. Read [AI reading]: …" (the rest unchanged).

### T6 (fit, medium, confirmed)

**Location.** rf-formations-that-read/PLAN.md:342 (§12 item 2); also PLAN.md §13 (L395-397), Evidence (L402); rf-formations-that-read/kit/round2c/integrate_rfm3.py, evidence_rfm3_coldread.py

**Quoted.** then the valuation as state (§4.8, built in the kit, its design and its Lean reviewed);

**Problem.** No kit step brings the plan up to the landing:
- integrate_rfm3.py leaves the plan alone, whereas integrate_rfm2.py set RF-M.2's entry to "(§4.7, landed)".
- Neither plan_rfm3.py nor evidence_rfm3_coldread.py adds anything for the cold read.
After the landing:
- §12 still says "built in the kit".
- §13 has no paragraph on the cold read of the third part's texts; RF-M.2 has one at L393.
- The Evidence list does not link REVIEW-RFM3-COLDREAD, although the record references it and the study links it.
Yet board_rfm3.py's landing text, and the plan's own L403, say what each finding became "is in plan §13".

**Replacement.** In the landing step:
- §12: "then the valuation as state (§4.8, landed);".
- §13: add "**The cold read of the third part's texts.** Before the landing, RF-M.3's texts were cold-read against the module (REVIEW-RFM3-COLDREAD (`evidence/REVIEW-RFM3-COLDREAD.md`)): …, what each finding became in its table."
- Evidence: after the Lean's review add "and the cold read of its texts in REVIEW-RFM3-COLDREAD (`evidence/REVIEW-RFM3-COLDREAD.md`)".

**Verdict: real.** integrate_rfm3.py's docstring says "RF's plan is brought to the landing by plan_rfm3.py". But plan_rfm3.py is a pre-cold-read step that exits if run twice. It sets §12 to "(§4.8, built in the kit, its design and its Lean reviewed)", and no kit step sets "landed", whereas integrate_rfm2.py:265-267 did for RF-M.2. §13 has no cold-read paragraph for the third part (RF-M.2's is at L393), and the Evidence list (L402) omits REVIEW-RFM3-COLDREAD. make_records_rfm3.py's REVIEWS and the study cite that file, and board_rfm3.py's landing text says what each finding became "is in plan §13".

**Better replacement.** As proposed, with the §12 edit made in integrate_rfm3.py, as integrate_rfm2.py did. Also correct integrate_rfm3.py's docstring sentence about plan_rfm3.py.

### T7 (fit, low, refuted)

**Location.** theories/becoming/chapters/03-KNOWING.md:519

**Quoted.** who call frozen initial preferences a very crude baseline: by them a revision deciding a listed cell against the current valuation's strict weighted preference counts as a loss, wanted or not

**Problem.** "Them" can bind to the authors (the "who"), which makes the loss Carroll et al.'s verdict rather than what the baseline counts. The module and plan say "by it", meaning the baseline. The 03 sentence also no longer says that evaluating by the current valuation is that baseline; it says only that it relates to their work.

**Replacement.** "…(Carroll, Dragan, Russell and Hadfield-Menell 2022), who call evaluation by frozen initial preferences, which evaluating by the current valuation is, a very crude baseline: by that baseline a revision deciding a listed cell against the current valuation's strict weighted preference counts as a loss, wanted or not, …"

**Verdict: not real.** In these texts "by X" consistently means evaluated by a valuation ("by the reference", "by its own current valuation"). "Them" most naturally takes the nearer plural, "frozen initial preferences", and read that way the sentence says what that baseline counts. The phrase "against the current valuation's strict weighted preference" ties the baseline to the current valuation. The rewording is clearer, but nothing stated is wrong.

### T8 (fit, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:517

**Quoted.** Where the acts taken give two worlds one input, from one state of each formation the courses are alike, so wherever no demonstration is emitted, and holding for the answer is worth one committed move (`ListingValuation.inputs_alike_before`, `ListingValuation.undemonstrated_worth`, `ListingValuation.answer_constant`).

**Problem.** "so wherever no demonstration is emitted, and holding for the answer is worth one committed move" does not parse. The sentence cites answer_constant but leaves out its case, every listed world showing what w₀ shows (inputs_alike). The record's law and the study both state that case ("where no demonstration tells them apart").

**Replacement.** "Where the acts taken give two worlds one input, from one state of each formation the courses are alike, so they are alike wherever no demonstration is emitted or none tells the listed worlds apart; there holding for the answer is worth one committed move (`ListingValuation.inputs_alike_before`, `ListingValuation.undemonstrated_worth`, `ListingValuation.answer_constant`)."

**Verdict: real.** "So wherever no demonstration is emitted, and holding for the answer is worth one committed move" is an elliptical clause joined by "and". The sentence also cites `answer_constant` (L2117) without stating its case: every listed world shows what w₀ shows. The module header (L123-126), the record's law (make_records_rfm3.py:349-351) and the study (L98-101) state both cases.

### T9 (fit, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:517; rf-formations-that-read/kit/round2c/study_rfm3.txt:109-110

**Quoted.** by the reference with the holding formation listing both worlds in the first and the first world alone in the second

**Problem.** "The first" and "the second" mean the two witnesses, but in a clause about "the first world" they read as worlds. The study's version uses "(a)" and "(b)" without ever introducing them; the plan introduces them and the study does not.

**Replacement.** 03: "by the reference with the holding formation listing both worlds where the world is shown and the first world alone where a valuation is presented". Study: the same, or label the two starts (a) and (b) where the four cases are introduced.

**Verdict: real.** In the study, "(a)" and "(b)" occur only at L109-110: a grep finds no other use, so the labels are undefined there. They come from the Lean's shownStart/presentedStart docstrings and plan item 20. In 03:517, "listing both worlds in the first and the first world alone in the second" is parseable but puts "the first" case next to "the first world".

### T10 (fit, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:517; rf-formations-that-read/kit/round2c/study_rfm3.txt:101-102

**Quoted.** one presented input compares with the current valuation by the residuals (`ListingValuation.presented_forgone_lt_iff`)

**Problem.** The law does not compare an input with a valuation. It compares holding for the answer after one presented input, forgoing k', with holding for the current answer, forgoing k, by the residuals and the amounts together. The study has the same wording: "One presented input is compared with the current valuation by the residuals".

**Replacement.** "holding for the answer after one presented input, forgoing an amount, stands above holding for the current answer, forgoing another, exactly where its residual and amount together fall below the other's (`ListingValuation.presented_forgone_lt_iff`)"

**Verdict: real.** `presented_forgone_lt_iff` (L2132-2138) compares holding for the answer after one presented input, forgoing k', with holding for the current answer, forgoing k, exactly where residual' + k' < residual + k. 03:517 and the study (L101-102) say instead that the input "compares with the current valuation by the residuals". That misnames what is compared and drops the amounts, which are the theorem's point (its docstring: "at a cost, exactly").

### T11 (fit, low, refuted)

**Location.** theories/becoming/chapters/03-KNOWING.md:517 (the Theorem's parenthesis)

**Quoted.** one decision, worth before any amount forgone;

**Problem.** The body states laws about amounts forgone (forgone_lt_iff, refined_lt_iff, coarser_not_above, presented_forgone_lt_iff), so this premise alone reads as if costs were outside the theorem. The module's modelling choices (L276-277), the record's hypothesis and the study all add "costs entering as amounts forgone".

**Replacement.** "one decision, worth before any amount forgone, costs entering as amounts forgone;"

**Verdict: not real.** "Worth before any amount forgone" is accurate: Model.after is worth before amounts, and the body's laws add amounts explicitly ("forgoing an amount …"). "Costs entering as amounts forgone" appears in the module, record and study, but its absence from 03's parenthesis states nothing false.

### T12 (fit, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:519

**Quoted.** their receiver breaks ties in the sender's favour and their prior is common, so the weights apart lie outside their model

**Problem.** The cut lost the contrast that makes the tie-breaking relevant: the answer here releases on ties (the module says "where the answer here releases"). Joined by "so", the tie-breaking now reads as a reason the weights apart lie outside their model, which only the common prior gives.

**Replacement.** "their receiver breaks ties in the sender's favour, where the answer here releases, and their prior is common, so the weights apart lie outside their model"

**Verdict: real.** The module (L205-208) separates the two points: "Their receiver breaks ties in the sender's favour, where the answer here releases. Their prior is common, so … lies outside their model." 03:519 joins both clauses before "so", so tie-breaking reads as a reason the weights apart lie outside their model; only the common prior gives that (Alonso and Câmara). The cut also drops the contrast that made the tie-breaking relevant.

**Better replacement.** "…their receiver breaks ties in the sender's favour, where the answer here releases; their prior is common, so the weights apart lie outside their model (Alonso and Câmara 2016), and no optimal signal or equilibrium is represented." The semicolon keeps tie-breaking from reading as a reason.

### T13 (fit, low, confirmed)

**Location.** theories/becoming/chapters/03-KNOWING.md:519

**Quoted.** By a reference, the least shortfall reads only the map and the residual only the deciding, so revaluing moves the residual alone, while a finer map never raises the least shortfall and can move the residual either way

**Problem.** If the residual read only the deciding, a finer map could not move it, yet the same sentence says it can. The least shortfall also reads the holding formation's model and the reference, not the map alone (revalued_split's docstring; plan item 8).

**Replacement.** "By a reference on the holding formation's model, the least shortfall is fixed by the map and the residual is what the deciding adds through it, so revaluing moves the residual alone, while a finer map never raises the least shortfall and can move the residual either way"

**Verdict: real.** `residual` (L418) totals per-cell terms of goExcessWithin/offExcessWithin through π, so it reads the map's cells as well as the deciding. "The residual only the deciding" is therefore inexact, and it sits against the same sentence's "a finer map … can move the residual either way" (`WeightsApart.weights_split`). `revalued_split`'s docstring also says the least shortfall reads the holding formation's model, the reference and the map.

### T14 (fit, low, refuted)

**Location.** theories/becoming/chapters/03-KNOWING.md:489; also :517

**Quoted.** and what informing the reading formation and revaluing it do to that worth.

**Problem.** §12's opening uses "the reading formation" before the section introduces the role (L517), and in the preceding clause "the formation" is the one that holds. At L517, "the least shortfall through it" is not tied to the quantity the RF-M.2 law already names, "the total over the cells of the smaller excess within each" (L512). A reader meets a new term for a known quantity.

**Replacement.** L489: "…and what informing and revaluing the formation whose reading is held for do to that worth." L517: "…falls short by the least shortfall through it (the total over the cells of the smaller excess within each, as above (`#r-what-holding-for-a-reading-is-worth`)) and its residual, …"

**Verdict: not real.** In the opening's list of six laws, "the reading formation" is inferable as the formation whose reading is held for, and the theorem paragraph defines the role. "The least shortfall through it" describes itself (the least any rule through the map falls short by), with HeldForReading's laws cited. This is a clarity preference with nothing wrong.

### T15 (fit, low, refuted)

**Location.** theories/becoming/chapters/07-SIGNIFICANCE.md:623

**Quoted.** a reason to keep the valuation from such a revision, wanted or not; and from different starts a route informing it and one revaluing it can give the same answers and end in the same state

**Problem.** The sentence runs to 115 words, with three subordinate layers before its main verb. "Wanted or not" has nothing to attach to in 07; it comes from the Carroll et al. point in 03. In "informing it" and "revaluing it", "it" points to "the reading", but what is informed and revalued is the reading formation.

**Replacement.** End the sentence "…loses: a reason to keep the valuation from such a revision (03 §12 (`03-KNOWING.md#r-a-reading-informed-and-revalued`))." Then add "From different starts, a route informing the reading formation and one revaluing it can give the same answers and end in the same state."

**Verdict: not real.** Sentence length is a matter of style. "Wanted or not" qualifies "such a revision" meaningfully on its own: whether or not the revision is wanted. "Informing it" and "revaluing it", with "it" the reading, follow the overview's own usage ("What another's reading answers can be moved by informing it and, apart, by revaluing it"). Nothing stated is wrong.

### T16 (fit, low, confirmed)

**Location.** theories/becoming/review/ALIGNMENT.md:23

**Quoted.** RF carries the principal's listing and valuation as state that informing and revaluing move within one law (below), and the principal's learning beyond what it is shown is not represented;

**Problem.** L28 (the "below") calls the same state "the reading formation's listing and valuation", and nothing ties the principal to the reading formation's role. 03's Open says "the reading formation's learning beyond filtering by what it is shown". "Learning beyond what it is shown" is wider, and it leaves unclear whether revising by a presented input counts.

**Replacement.** "RF carries the listing and valuation of the reading formation (the principal's role) as state that informing and revaluing move within one law (below), and its learning beyond filtering by what it is shown is not represented;"

**Verdict: real.** The tie point is weak. L28's parallel "carries the … listing and valuation as state", together with "(below)", connects the principal to the reading formation. The same clause also says revaluing is represented, so presented inputs are not in doubt. The wording drift is real. 03's Open, the record's does_not_show (make_records_rfm3.py:434-435) and the study say "beyond filtering by what it is shown". The dossier's "beyond what it is shown" implies that all learning from what it is shown is represented, whereas only true filtering is.

**Better replacement.** "…RF carries the principal's listing and valuation as state that informing and revaluing move within one law (below, as the reading formation's), and the principal's learning beyond filtering by what it is shown is not represented;"

### T17 (fit, low, confirmed)

**Location.** theories/becoming/review/ALIGNMENT.md:41

**Quoted.** RF-M.3's sentences, added on 31 October 2026, were cold-read before its landing

**Problem.** RF-M.3 also rewrote the box's assistance-games clause (L23) and removed "a principal's valuation as state is a later item" from round 2's sentence (L28). The entry's first sentence still dates the assistance-games clause to 29 and 30 October, and this sentence names only added sentences.

**Replacement.** "RF-M.3's sentences and its changes to the assistance-games clause and round 2's sentence, made on 31 October 2026, were cold-read before its landing, …"

**Verdict: real.** The first sentence of L41 dates the assistance-games clause to 29 and 30 October. integrate_rfm3.py rewrites that clause (L23) and removes "a principal's valuation as state is a later item" from round 2's sentence, yet the RF-M.3 entry names only "RF-M.3's sentences, added on …". Other entries list the clauses they changed, for example the RR entry at L43.

### T18 (fit, low, confirmed)

**Location.** rf-formations-that-read/kit/round2c/make_records_rfm3.py:462 (next_delta, en and zh); also :526-555 (AMEND)

**Quoted.** A holding formation planning over several steps among informing, revaluing and holding, and its learning about the reading formation;

**Problem.** The new record's next step leaves out the reading formation's learning beyond filtering by what it is shown. The AMEND gives exactly that step to both related records, as the step after RF-M.3's carrier, and 03's Open lists it, so the record the step is deferred to does not name it. The wording also drifts: "beyond what it is shown" in the AMEND and the dossier, "beyond filtering by what it is shown" in 03.

**Replacement.** Prepend "The reading formation's learning beyond filtering by what it is shown;" (zh "读之形成依所示而滤以外之学；"), and use that phrase in the AMEND's next steps and history lines.

**Verdict: real.** The next_delta at make_records_rfm3.py:462 lacks the reading formation's learning beyond filtering. The AMEND (L533-534, L547-548) defers that step to after RF-M.3's carrier, and 03's Open lists it. The record names it only in does_not_show (L434-435) as scope, not as a next step. The AMEND, the history lines and register_rfm3.py say "beyond what it is shown". The proposed prepend makes next_delta.en 403 characters, over the hard cap of 400 (style.CAPS_V2 'next_delta': (400, 180), HARD_CAPS), so `capped` would fail.

**Better replacement.** Use a version within the cap (384 characters): "A holding formation planning over several steps among informing, revaluing and holding, and its learning about the reading formation; the reading formation's learning beyond filtering by what it is shown; a misleading demonstration and a recipient's belief, toward deception; noisy answers and continuous beliefs in the periphery; an institution's rule of reading; review by a person." zh: "持之形成于告、改值与持之间多步之谋，及其于读之形成之学；读之形成依所示而滤以外之学；误导之示与受者之信，以向欺；外围之有噪之答与连续之信；制度之读之规则；人之审查。" Use "beyond filtering by what it is shown" (依所示而滤以外) in the AMEND's next steps and history lines.

### T19 (fit, low, confirmed)

**Location.** rf-formations-that-read/kit/round2c/make_records_rfm3.py:494-495 (related detail, en and zh)

**Quoted.** Informing within one law: a demonstration filtering the reading formation's listing and an input revising its valuation

**Problem.** This files revaluing (an input presented revising the valuation) under "Informing". Everywhere else the two acts are named apart, including the record's own laws and the AMEND line for the same pair of records ("Informing as an act within one law: …; and revaluing, an input revising its valuation"). The zh "一律之内之告：示滤读之形成之列，呈改其值" does the same.

**Replacement.** "Informing and revaluing within one law: a demonstration filtering the reading formation's listing and an input presented revising its valuation, beside …" / zh "一律之内之告与改值：示滤读之形成之列，呈一入改其值，…"

**Verdict: real.** The related detail (make_records_rfm3.py:494-497) is headed "Informing" but lists "an input revising its valuation", which is revaluing. The module, the record's own laws and the AMEND for the same pair (L541-544: "…; and revaluing, an input revising its valuation") keep the two acts apart. The zh line (一律之内之告：…呈改其值) conflates them the same way.

### T20 (fit, low, confirmed)

**Location.** becoming/check_becoming.py:2967; also becoming/Becoming.lean:2881-2882, rf-formations-that-read/kit/round2c/board_rfm3.py:42-43, integrate_rfm3.py:72

**Quoted.** a route shown and a route revalued answer alike and end in one state

**Problem.** The module, 03, the record, the study and the plan call this route "the route presented"; "route revalued" is a third name for it. The checker's scope sentence also leaves out revaluing's law (revalued_split), which the root bullet states. Its "never stands lower through every refinement exactly where splits keep the worth" no longer says through which map.

**Replacement.** "a route shown and a route presented answer alike and end in one state" in all four. Scope: "…and, over every refinement, holding for the answer never stands lower through the finer map exactly where splits keep the worth; revaluing changes only the residual; on one blanketed law …"

**Verdict: real.** The module (`TwoWorlds.route` docstring, L2217: "`true` the route presented"), 03, the record's law (L374), the study (L114) and plan item 21 all say "the route presented". check_becoming.py:2967, Becoming.lean:2881-2882, board_rfm3.py and integrate_rfm3.py say "a route revalued", a third name. The checker's "never stands lower through every refinement" also loses "through the finer map".

### T21 (fit, low, confirmed)

**Location.** becoming/README.md:225; becoming/README.zh.md:129; theories/becoming/chapters/08-METHOD.md:488

**Quoted.** withholding against informing (`ListingValuation.forgone_lt_iff`, `ListingValuation.refined_lt_iff`)

**Problem.** The README names the group by its reading, unmarked. The module renamed these laws structurally and marks the reading (lens finding L13), and the record's title says "amounts forgone, read as withholding against informing". The zh "扣告与告" does the same. So does 08 §8's "the thresholds of withholding against informing and of revaluing", which sits in the list of what the counts add, before that bullet's [AI reading] marker.

**Replacement.** README: "amounts forgone, read as withholding against informing (…)". zh: "舍量，读为扣告与告（…）". 08: "the thresholds of amounts forgone (read as withholding against informing) and of revaluing".

**Verdict: real.** L13 was judged real because `forgone_lt_iff` holds for any two rules with amounts, so naming it by withholding states a reading. The laws were renamed, and the header bullet now marks "(read as withholding against informing…)". README.md:225 and README.zh.md:129 still group `forgone_lt_iff` under "withholding against informing" / "扣告与告", unmarked. 08:488 lists "the thresholds of withholding against informing" among what the counts add, before its [AI reading] marker. The module's own Standing (L155), the study's Standing (L151) and the plan's Standing (L229) use the same unmarked phrase.

**Better replacement.** As proposed for README, README.zh and 08. Apply the same change to the module's Standing ("the thresholds of amounts forgone, read as withholding against informing, and of revaluing") and the study's and plan's Standing, so the texts agree.

### T22 (fit, low, confirmed)

**Location.** rf-formations-that-read/PLAN.md:194 (and heading at :181)

**Quoted.** **RF-M.3 The valuation as state; informing and shaping** (not built; the carrier first).

**Problem.** Stale. §4.8 builds RF-M.3, and "shaping" was renamed "revaluing" (the study says so). §4.7's heading still includes "and the valuation as state", which is also §4.8's heading. A reader of §4.7 is told the item is unbuilt and sees it under its old name.

**Replacement.** Heading: "### 4.7 Round 2, second part: an act held for a reading". Paragraph: "**RF-M.3 The valuation as state; informing and shaping** (the redesign §4.8 builds on; built there, 'shaping' renamed 'revaluing')."

**Verdict: real.** §4.7's "(not built; the carrier first)" and "informing and shaping" (PLAN.md:194) are stale: §4.8 builds RF-M.3 and renames shaping to revaluing. But the proposed heading change would break a live link. The study (BECOMING-RENEWAL-READING.md:21780) links #47-round-2-second-part-an-act-held-for-a-reading-and-the-valuation-as-state, and research-links would fail.

**Better replacement.** Keep §4.7's heading, since its anchor is linked from RF-M.2's study section, or keep the old slug with an explicit <a id> if the heading must change. Change only the paragraph: "**RF-M.3 The valuation as state; informing and shaping** (the redesign §4.8 builds on; built there, 'shaping' renamed 'revaluing')."

### T23 (fit, low, confirmed)

**Location.** rf-formations-that-read/kit/round2c/study_rfm3.txt:178-179

**Quoted.** (§4.8, §12, §13 and Evidence)

**Problem.** RF-M.3 also changes the plan's §5 row and its §8 rows, which repoint_rfm3.py's REASON lists. The study's output→input list leaves them out.

**Replacement.** "(§4.8, §5's and §8's rows, §12, §13 and Evidence)"

**Verdict: real.** repoint_rfm3.py's REASON and EXPECTED list "§5's and §8's rows" among RF-M.3's changes to the plan, and commit 6837be33a changed those rows. The study's Output → input (study_rfm3.txt:179) lists only "§4.8, §12, §13 and Evidence".

### T24 (fit, low, confirmed)

**Location.** rf-formations-that-read/kit/round2c/study_rfm3.txt:183; also rf-formations-that-read/PLAN.md:397, rf-formations-that-read/evidence/REVIEW-RFM3-LEAN.md:5

**Quoted.** six of which were completed with nine declarations (informing's strict form, the coarser answer forgoing no less never above the finer, the told criterion with no cell list, the least shortfall through what is shown, the course forms)

**Problem.** In the evidence table, four of the six (F8, F9, F17, F20) were completed with the nine declarations. The other two (F4, L13) were completed in prose: the off-switch Readings now cite undemonstrated_worth, and titles were made structural. The evidence opening's "Six of the seven were then completed, with nine more declarations" has the same slip. The plan's version says "the course forms of the four cases", but shown_course and presented_course cover only the two cases in which an act turns the answer.

**Replacement.** "six of which were completed, four with nine declarations (…) and two in prose (the off-switch Readings citing undemonstrated_worth; structural titles)". Plan: the same, with "the course forms of the two turning cases".

**Verdict: real.** Diffing declarations at the reviewed commit 4843dd795 against the current module gives exactly nine new ones. They are shown_least_le, TwoWorlds.shown_course and TwoWorlds.presented_course (F8); unweighted_released, weighed_stops_iff and told_shortfall_zero_iff (F9); informed_lt_iff and least_falls (F17); and coarser_not_above (F20). F4 and L13 were completed in prose, as their rows say. shown_course and presented_course cover the (a)-shown and (b)-presented courses, the two turning cases, not "the four cases" (plan L397).

### T25 (fit, low, confirmed)

**Location.** rf-formations-that-read/PLAN.md:211 and :213 (§4.8 items 8 and 10)

**Quoted.** from one cell to the cells {1, 2} and {3}

**Problem.** The Lean's candidates are 0, 1 and 2, and its cells are {0, 1} and {2} (`decide (c = 2)`), as E16 and F3 on the evidence page write. 03 and the record say "the cells of the first two candidates and of the third". The plan's one-based sets match none of these.

**Replacement.** "from one cell to the cells of the first two candidates and of the third", and the same in item 10.

**Verdict: real.** WeightsApart's candidates are the naturals 0, 1 and 2, and its finer map is `decide (c = 2)`, giving cells {0, 1} and {2} (L1645, L1656-1658), as E16 and F3 on the evidence page write. Plan items 8 and 10 (L211, L213) write "{1, 2} and {3}". Read against the Lean's candidate names, which the plan cites, those sets denote other cells. 03 and the record say "the cells of the first two candidates and of the third".

### T26 (fit, low, confirmed)

**Location.** rf-formations-that-read/PLAN.md:247 (§5 row)

**Quoted.** its gain under a reference the valuation does not share, and by the reading formation's current valuation on a shared model a reason to keep it from a revision deciding a listed cell against its strict weighted preference, are readings of its laws

**Problem.** The gain under a reference is itself a law (revaluing_gain, revaluing_gains_iff). Only reading it as an incentive to revise is a reading.

**Replacement.** "its gain under a reference the valuation does not share, read as an incentive to revise, and by the reading formation's current valuation on a shared model a reason to keep it from …, are readings of its laws"

**Verdict: real.** `revaluing_gain` (L1067) and `revaluing_gains_iff` (L1051) prove the gain, with a shared model; only reading it as an incentive to revise is a reading. Plan §5's row (L247) files "its gain under a reference the valuation does not share" among "readings of its laws".

### T27 (fit, low, confirmed)

**Location.** rf-formations-that-read/evidence/REVIEW-RFM3-LEAN.md:1244 (E10) and :1267 (F16); also :5

**Quoted.** Judged not real by the verifier. Verifier: not real.

**Problem.** The generator's prefix (evidence_rfm3_lean.py:257) repeats what the E10 and F16 rows already say. The opening says the module "was revised on the forty-nine real findings and the cross-model reader's fifteen", but E10 and F16 show that the two findings judged not real were taken as well; the plan and the study say "revised on all of them".

**Replacement.** Skip the prefix where the row already says it (E10: "Verifier: not real. The module changed anyway: …"; F16: "The verifier judged it not real …"). Opening: "revised on all fifty-one lens findings (the two judged not real taken anyway) and the cross-model reader's fifteen".

**Verdict: real.** evidence_rfm3_lean.py prefixes "Judged not real by the verifier." to rows that already say "Verifier: not real." (E10, L1244) or "The verifier judged it not real" (F16, L1267). The opening (L5) says the module was revised "on the forty-nine real findings and the cross-model reader's fifteen". E10 and F16 show the two refuted findings were taken too, and plan L397 and the study say "revised on all of them".

### T28 (fit, low, confirmed)

**Location.** rf-formations-that-read/evidence/REVIEW-RFM3-LEAN.md:1265 (F14)

**Quoted.** joint's docstring says the same.

**Problem.** joint's docstring (ListingValuation.lean:1844-1852) says only that the answer is exposed at every step, asked or not, and that going on and switching off are sensed as nothing and change no world. It does not say that asked and none update alike, that holding changes neither the world nor the reading formation, or that holding's worth is counted in Part 1.

**Replacement.** "joint's docstring says that the answer is exposed at every step, asked or not, and that going on and switching off are sensed as nothing and change no world."

**Verdict: real.** joint's docstring (L1844-1852) says only that the answer is exposed at every step, asked or not, and that going on and switching off are sensed as nothing and change no world. It does not say that asked and none update alike, that holding changes neither the world nor the reading formation, or that holding's worth is counted in Part 1. F14's "joint's docstring says the same" (L1265) therefore overstates.

### T29 (fit, low, confirmed)

**Location.** rf-formations-that-read/evidence/REVIEW-RFM3-LEAN.md:1229 (A10)

**Quoted.** (the study leaves their extraction to the owners)

**Problem.** The study's self-review (item 2) names only total_lt_of_mem repeating Loops.total_lt. It says nothing of cond_zero_le repeating Weighting.term_le_of.

**Replacement.** Either add to the study's self-review "and cond_zero_le repeats Weighting.term_le_of, outside the import closure; one statement of each is left to its module's owner", or narrow A10 to "(the study leaves total_lt_of_mem's extraction to Flow's owner)".

**Verdict: real.** The study's self-review item 2 mentions only that `total_lt_of_mem` repeats `Loops.total_lt`, with one statement left to Flow's owner. `cond_zero_le` (L1235, whose docstring says "as `Weighting.term_le_of`") is not mentioned. A10's "the study leaves their extraction to the owners" (L1229) therefore holds for only one of the two.

### T30 (fit, low, confirmed)

**Location.** rf-formations-that-read/evidence/REVIEW-RFM3-LEAN.md:1425 (R1)

**Quoted.** the record's laws and correspondence, 03 §12's paragraph and the study likewise.

**Problem.** The record's correspondence is its literature mapping and never says "from one state of each formation". Only its law on courses alike says it (make_records_rfm3.py:349).

**Replacement.** "the record's law on courses alike, 03 §12's paragraph and the study likewise."

**Verdict: real.** The record's correspondence (make_records_rfm3.py:467-479) is the literature mapping and never says "from one state of each formation". That phrase is only in the law on courses alike (L349-352). R1 (L1425) says "the record's laws and correspondence … likewise".

### T31 (fit, low, refuted)

**Location.** rf-formations-that-read/evidence/REVIEW-RFM3-LEAN.md:9-10; rf-formations-that-read/kit/round2c/evidence_rfm3_lean.py:217

**Quoted.** ## The cross-model review

**Problem.** INTRO ends without a newline and the parts are joined with a single '\n', so this heading follows the opening's last paragraph with no blank line. RF-M.2's page has the blank line. The heading still renders in CommonMark, but the source differs from its sibling page.

**Replacement.** parts = [INTRO + '\n', '## The cross-model review\n', review + '\n']

**Verdict: not real.** The missing blank line before "## The cross-model review" (L9-10) is a source-only difference. In CommonMark/GFM an ATX heading interrupts a paragraph, and the repository's anchor extraction (tools/research/moves.py `anchors`, reading_catalogue `HEADING`) matches headings line by line. The page renders and its anchors resolve, so nothing is wrong beyond the difference from the RF-M.2 page.

### What was taken from the lenses

| # | Lens | Verdict | Finding | Taken |
|---|---|---|---|---|
| X1 | exactness | confirmed | with the weights apart, splits read as never keeping the worth, where `WeightsApart.not_splitsKeep` is one witness and `splitsKeep_of_off_le_go` holds whatever the models | 03 §12: “with the weights apart, a shared valuation can fail to keep it”, after a semicolon, `splitsKeep_of_off_le_go` said to hold whatever the models; the header and the study: “can break it”; the record's law: “With the weights apart, splits can fail to keep the worth even with a shared valuation” (zh 权相异，即共值，分亦可不守其值); the docstring title of `WeightsApart.not_splitsKeep` the same |
| X2 | exactness | confirmed | the root bullet and the checker's scope say “every refinement” without the factoring on both listings that `refining_never_lowers_iff` takes | both: “over every refinement factoring on both (formations') listings” and “through the finer map”; both also give the split its cells, listed once each and covering |
| X3 | exactness | confirmed | 03 §12 and the study say “on the holding formation's model” where `own_least`, `revalued_lowers_iff` and `outcome_least` need the reading formation's model to be the holding formation's | “with the reference the reading formation's own current valuation and its model the holding formation's”, as the header and the record say, and “with that shared model” before `outcome_least`, in both |
| X4 | exactness | confirmed | the record's law on `outcome_least` states no model condition, and its hypothesis leaves it out of the theorems taking the shared model | the law opens “With the reading formation's model the holding formation's” (zh 读之形成之模型即持之形成之模型，则), and the hypothesis lists `outcome_least` with `own_least`, `revalued_lowers_iff`, `revaluing_gain` and `revaluing_gains_iff`, in both languages |
| X5 | exactness | confirmed | “with both answers least” given as the hypothesis of `forgone_least_iff` and `coarser_not_above`, which assume a shared model and net agreement | “with a shared model and net agreement” (and “so both answers least” where it fits) in 03 §12, the header, the study, the record's law (zh 共模型且净相合（故二答皆最少）, the English at 418 of its 420 characters), the plan's item 7 and §13, and the Lean review's row F20 |
| X6 | exactness | confirmed | “at one model” for `revalued_split` and `revalued_forgone_lt_iff`, which take the two formations' models apart | “with both formations' models, the reference and the map fixed” in 03 §12, the study, the record's law (zh 二形成之模型、参照与映射皆定) and the plan's item 8 |
| X7 | exactness | confirmed | the header's told sentence and its sentence on `refined_lt_iff` omit their cell conditions, and the Lean review's row R5 says the header names the coarser cells for `refined_lt_iff` | the header: “over cells covering the holding formation's listing” for the told criterion and “both maps' cells listed once each and covering the holding formation's listing” for `refined_lt_iff`; R5 says what was named when, its page regenerated |
| X8 | exactness | confirmed | the record's carrier law says a world is sensed, where a demonstration gives what it shows | “what a demonstration shows, an input presented, or asked” (zh 示之所显、所呈之入或问) |
| X9 | exactness | confirmed | the dossier's “From different starts the answers and the final state do not tell” reads as general from one witness | “From different starts a route informing and one revaluing can answer alike and end in one state, so the answers and the final state need not tell whether the valuation changed”, in 07's and the overview's terms |
| X10 | exactness | confirmed | the record's Chinese law on informing has a clause the English lacks | the clause dropped from the Chinese, the English, at 410 of its 420 characters, having no room for it |
| X11 | exactness | confirmed | the Chinese README row and alias parse as informing acting on the valuation | 告读之形成与改其值, in the row and in the alias |
| X12 | exactness | confirmed | the plan's cells {1, 2} and {3} count from one, where the candidates are 0, 1 and 2 | “the cells of the first two candidates and of the third” in items 8 and 10, as the header and the record say |
| X13 | exactness | confirmed | the plan makes the weights part of the revisable listing | “its *listing* (candidate worlds, weighted by its law)”, the header's words |
| X14 | exactness | confirmed | the plan's item 4 title drops that the unweighted candidate is one the holding formation weighs | “exactly where a candidate the holding formation weighs, unweighted by the reading formation, is one to stop” |
| X15 | exactness | confirmed | the plan's “weaker than the answer being least at every cell” claims an implication no theorem states | dropped; the next sentence already says splits keep the worth even where the answer has a residual (`release_keeps`) |
| X16 | exactness | confirmed | the plan's “the course forms of the four cases”, which cover the two turning cases | “the course forms of the two turning cases, `TwoWorlds.shown_course` and `TwoWorlds.presented_course`” |
| X17 | exactness | confirmed | rows A10, F14, L9 and R1 of the Lean review do not match the texts as they stand | in the generator, and the page regenerated: A10 holds once the study names `cond_zero_le` beside `total_lt_of_mem` (T29) and says so; F14 and L9 corrected through entries made after the check; R1 without “and correspondence” |
| X18 | exactness | confirmed | the record cites this page before it exists, and the plan's Evidence does not name it | this page written and the study's paragraph filled before registration; the plan's Evidence names the page, and §13 has a paragraph on the cold read of the third part's texts |
| X19 | exactness | confirmed | 08 §8's bullet on RR says holding an act for a reading is the bullet above's, where it is the next one | RR's text, already on main: given to RR's second item, whose landing, after RF-M.3's, makes it “the next bullet's” |
| R1 | readings | confirmed | the dossier gives the preservation incentive to current-reward-function evaluation as such, where their Claim 2 gives it to the agent that anticipates time inconsistency and their Claim 3 none to the one that ignores it | “the preservation incentive of current-reward-function evaluation by an agent that anticipates time inconsistency (Everitt, Hutter, Kumar and Krakovna 2021, Claim 2)” |
| R2 | readings | confirmed | the same in the record's correspondence | “preservation incentive for an agent anticipating time inconsistency (Everitt et al. 2021, Claim 2)” (zh 以当下奖励函数评估而顾及时间不一致者之保存之诱因), within the cap |
| R3 | readings | confirmed | 08 §8 and the study name current-reward-function evaluation in general | “current-reward-function evaluation by an agent that anticipates time inconsistency”, and “their Claim 2 permits that agent”, in both |
| R4 | readings | refuted | the dossier's sentence on different starts generalizes one witness and drops that the start tells the routes apart | refuted (one colliding pair shows the record does not determine the property); met all the same by X9's wording |
| R5 | readings | refuted | the plan's §8 row drops “can” and that with the start the record determines the property | refuted; the row brought to the dossier's wording all the same, as clearer and harmless: “can answer alike and end in one state, so the answers and the final state need not tell whether it changed” |
| R6 | readings | confirmed | the module, 03 §12 and the plan say the holding formation's choice is represented by the comparisons, where `Revaluing.revaluing_best` represents no choice; the plan adds 13 | the module: “No choice by the holding formation among these is represented: only the worth comparisons of … and the four valued alternatives of `Revaluing.revaluing_best`, relate them”; 03 §12 and the plan likewise, the plan naming 7, 8 and 14 |
| R7 | readings | confirmed | the record drops “deterministic” from the off-switch reading | “for a deterministic constant policy” (zh 于确定且恒定之策) |
| R8 | readings | confirmed | the Lean review's re-check row R1 says the record's correspondence says “from one state of each formation” | “the record's laws, 03 §12's paragraph and the study likewise”, the page regenerated |
| R9 | readings | confirmed | the overview, the dossier and the record state the incentive to revise without the supplied update's reach, the overview also without costs | the overview and the dossier: “incentives, before costs, to withhold and, where the supplied update reaches such a valuation, to revise”; the record: “(if the update reaches it), before costs” (zh 若所予之更新可达) |
| R10 | readings | confirmed | in 03 §12 the sender-favouring tie-break reads as a reason the weights apart lie outside their model | “their receiver breaks ties in the sender's favour, where the answer here releases; their prior is common, so the weights apart lie outside their model” |
| R11 | readings | confirmed | “by them” in 03 §12 can be read as Carroll and others' own verdict | “evaluated by the current valuation, a revision deciding a listed cell against its strict weighted preference counts as a loss”; their very crude baseline kept as the design's and the Lean's checks of the paper read it |
| R12 | readings | refuted | 03 §12's “what a reader of the answers alone leaves open” generalizes the witness | refuted (the labelled Reading scopes it to the witness just stated); not changed |
| R13 | readings | confirmed | the module's Standing, 08 §8, the plan's Standing and the study name the contribution by its reading, withholding against informing, unmarked | “the thresholds with amounts forgone (read as withholding against informing) and of revaluing” in all four; the module's section heading and the plan's item 7 title likewise |
| R14 | readings | refuted | 08 §8 and the record state the counterpart of Kamenica and Gentzkow's condition without the reading label | refuted (RF-M.2's landed convention: restatements in 08 §8 and the record's counts, readings labelled); not changed |
| T1 | fit | confirmed | the weights apart said to break the criterion in 03 §12, the study, the record and the header | as X1 |
| T2 | fit | confirmed | “its answer” in 03 §12 and 07 §7 binds to the replacement valuation, where `revaluing_gains_iff`'s condition is the current answer's residual | “the current answer” in 03 §12, “its current answer” in 07 §7 |
| T3 | fit | confirmed | “at one model” in 03 §12, the record, the study and the plan's item 8 | as X6 |
| T4 | fit | refuted | the dossier's sentence on different starts and the plan's §8 row drop the witness qualifier | refuted; met all the same by X9's and R5's wording |
| T5 | fit | confirmed | the overview's paragraph, cut for a reading budget, keeps that a finer map never raises the least shortfall but drops that it can raise the residual by more, states no standing and glosses no residual | “Proved in natural-number counts: … plus a residual, positive exactly where the answer decides a listed cell against the reference's strict weighted preference; a finer map never raises the first but can raise the second by more than it lowers the first” |
| T6 | fit | confirmed | no kit step brings the plan to the landing: §12 says built in the kit, §13 has no paragraph on the cold read, the Evidence omits this page | integrate_rfm3.py sets §12's entry to “(§4.8, landed)” at the landing, as integrate_rfm2.py did, and its docstring says so; §13's paragraph and the Evidence entry added |
| T7 | fit | refuted | “them” in 03 §12 can bind to the authors | refuted; met all the same by R11's change |
| T8 | fit | confirmed | 03 §12's sentence on courses alike does not parse and leaves out `answer_constant`'s case | “so they are alike wherever no demonstration is emitted or none tells the listed worlds apart, and there holding for the answer is worth one committed move”; the study and the header likewise |
| T9 | fit | confirmed | “the first” and “the second” read as worlds, and the study's (a) and (b) are never introduced | “in the course shown” and “in the course presented”, in 03 §12 and the study |
| T10 | fit | confirmed | 03 §12 and the study say an input is compared with a valuation by the residuals | “holding for the answer after one presented input, forgoing an amount, stands above holding for the current answer, forgoing another, exactly where its residual through the one cell and its amount together fall below the other's”, in both |
| T11 | fit | refuted | 03 §12's premises omit costs entering as amounts forgone | refuted (worth before any amount forgone is accurate, the laws adding the amounts); not changed |
| T12 | fit | confirmed | the tie-break joined by “so” to the common prior in 03 §12 | as R10, with the semicolon |
| T13 | fit | confirmed | “the least shortfall reads only the map and the residual only the deciding” would keep the residual from moving with the map | “By a reference on the holding formation's model, the least shortfall is fixed by the map and the residual is what the deciding adds through it” |
| T14 | fit | refuted | §12's opening uses “the reading formation” before the section introduces it, and “the least shortfall through it” is not tied to RF-M.2's quantity | refuted; not changed |
| T15 | fit | refuted | 07 §7's sentence runs to 115 words | refuted (a matter of style, each clause attached); not changed but for T2's word |
| T16 | fit | confirmed | the dossier's scope box ties the principal to no role, and its “learning beyond what it is shown” is wider than 03's | “move within one law (below, as the reading formation's), and the principal's learning beyond filtering by what it is shown is not represented” |
| T17 | fit | confirmed | the dossier's account of how it was made names only the sentences added | “RF-M.3's sentences and its changes to the assistance-games clause and round 2's sentence, made on …” |
| T18 | fit | confirmed | the record's next step omits the reading formation's learning beyond filtering by what it is shown, and the amendments say “beyond what it is shown” | the next step names it (384 of its 400 characters; zh 读之形成依所示而滤以外之学), and the amendments' next steps and history lines and the register's reason say “beyond filtering by what it is shown” |
| T19 | fit | confirmed | the related detail files revaluing under informing | “Informing and revaluing within one law: … and an input presented revising its valuation” (zh 一律之内之告与改值：…呈一入改其值) |
| T20 | fit | confirmed | “a route revalued” in the checker's scope, the root bullet and the board's text; the scope without revaluing's law or the map | “a route presented” in all three; the scope adds “revaluing changes only the residual” and “through the finer map” |
| T21 | fit | confirmed | the READMEs and 08 §8 name the group by its reading, unmarked | the README: “amounts forgone, read as withholding against informing” (zh 舍量，读为扣告与告); 08 §8 and the module's, the study's and the plan's Standing as R13 |
| T22 | fit | confirmed | the plan's §4.7 paragraph on RF-M.3 says not built and keeps the old name | “(redesigned and built in §4.8, where 'shaping' became 'revaluing')”; §4.7's heading kept, since it is linked |
| T23 | fit | confirmed | the study's output and input omit the plan's §5 and §8 rows | “(§4.8, §5's and §8's rows, §12, §13 and Evidence)” |
| T24 | fit | confirmed | the study, the plan and the Lean review say six were completed with nine declarations, where four were and two in prose; the plan's “four cases” | “six … completed, four with nine declarations (…) and two in prose (…)” in the study, the plan and the Lean review's opening; the plan's “the two turning cases” |
| T25 | fit | confirmed | the plan's cells counted from one | as X12 |
| T26 | fit | confirmed | the plan's §5 row calls the gain under a reference a reading, where it is a law | “its laws read as an incentive to revise under a reference the valuation does not share and, by the reading formation's current valuation on a shared model, a reason to keep it from a revision …” |
| T27 | fit | confirmed | the Lean review's prefix repeats “not real” in E10 and F16, and its opening says revised on the forty-nine real findings | the prefix only where the row does not say so; the opening: “revised on all fifty-one lens findings (the two judged not real taken anyway)” |
| T28 | fit | confirmed | the Lean review's row F14 says `joint`'s docstring says more than it does | as X17: the row says what the docstring says |
| T29 | fit | confirmed | A10 says the study leaves both lemmas' extraction to their owners, where it names only `total_lt_of_mem` | the study's self-review names `cond_zero_le`, repeating `Weighting.term_le_of`, beside it, one statement of each left to its module's owner, and A10 says so |
| T30 | fit | confirmed | the Lean review's re-check row R1 names the record's correspondence | as R8 |
| T31 | fit | refuted | no blank line before the Lean review's first heading | refuted (it renders); taken all the same: a blank line |

## The re-check of the cross-model reader's points

The cross-model reader, in the session of its cold read, read how its six points were taken and, as new text, the overview's paragraph and the dossier's sentences cut for reading budgets, the plan's §5 and §8 rows and the study's paragraph on the reviews, read-only, in a rehearsal rebuilt at the same path on the kit at `18001d918` with main at `8a8b0df82`. Verbatim; its line numbers are those of the version it read.

All six corrections are taken correctly; one new issue remains in two PLAN table summaries.

1. **The new preservation summaries omit the shared-model condition; one also drops the strict-preference qualification.**

   **Locations and quotes:**
   - [PLAN.md:247](../PLAN.md): “by the current valuation a reason to keep it from a revision deciding a listed cell against its strict weighted preference”.
   - [PLAN.md:291](../PLAN.md): “evaluated by the current valuation, a reason to keep a valuation from revision”.

   **Problem:** `own_least` and `revalued_lowers_iff` use the same model for producing and evaluating the answer. Evaluating by the reading formation’s current valuation alone does not supply that condition. The second summary also broadens the preservation reason beyond revisions that decide a listed cell against the current strict weighted preference; changes at ties need not lose worth.

   **Exact replacements for the quoted clauses:**

   At line 247:
   > by the reading formation's current valuation on a shared model, a reason to keep it from a revision deciding a listed cell against its strict weighted preference

   At line 291:
   > evaluated by the reading formation's current valuation on a shared model, a reason to keep it from a revision deciding a listed cell against its strict weighted preference

No other findings in the requested corrections or new passages.

### What was taken from the re-check of the cross-model reader's points

| Point | Status | How |
|---|---|---|
| 1 | taken | the two rows as it gives them (§5's “by the reading formation's current valuation on a shared model a reason to keep it from a revision deciding a listed cell against its strict weighted preference”, §8's corrigibility row the same); and, where the same claim is stated without the shared model, 08 §8's bullet (“evaluating by the reading formation's current valuation on a shared model”), the study's standing (“by the current valuation on a shared model no revaluation gains”) and the record's correspondence (“on a shared model, a reason to keep the valuation”, zh 共模型时), `own_least` and `revalued_lowers_iff` both evaluating on the holding formation's model; kit `6837be33a`, the record's caps passing |

## The re-check of the lenses' findings

The cross-model reader, in the session of its cold read, read how the lenses' findings were taken and, as new text, the passages they changed, read-only, in a rehearsal rebuilt at the same path on the kit at `22a113c0c` with main at `2f4a5bd96`, the diff of the study folder since `18001d918` at its root. Verbatim; its line numbers are those of the version it read.

The lens changes are correctly taken, with X19 explicitly deferred to RR; one omission remains in the revised PLAN §5 summary.

1. **[PLAN.md:247](../PLAN.md)**

   **Quote:** “its laws read as an incentive to revise under a reference the valuation does not share”

   **Problem:** This still omits R9’s reachability and cost qualifications. `revaluing_gains_iff` quantifies over unrestricted value functions; it does not guarantee that the supplied update reaches an improving valuation. `presented_forgone_lt_iff` compares a given input with amounts forgone. It also contradicts §13’s new claim that these qualifications appear wherever the incentive is read.

   **Exact replacement for the quoted clause:**

   > its laws read, before costs, as an incentive to revise under a reference the valuation does not share, where the supplied update reaches a valuation whose answer raises the worth of holding by that reference

### What was taken from the re-check of the lenses' findings

| Point | Status | How |
|---|---|---|
| 1 | taken | PLAN §5's row on preference shaping, in one wording with the check's RC1 and TC3: “its laws read as an incentive, before costs, to revise under a reference the valuation does not share, only where the supplied update reaches a valuation whose answer stands above the current one by that reference, which is not asserted”; the other places the incentive is read carry both qualifications (03 §12's Reading, PLAN §4.8's Readings, the module's header, the overview, the dossier and the record's correspondence), the overview's and the record's given what gains (RC2, RC3) |

## The check of how the lenses' findings were taken

Beside the second re-check, a workflow of three Opus readers, one per lens, read-only in the same rehearsal, checked every finding of its lens against the table of what was taken, the texts and the Lean, giving each id a status (taken, in part, not taken, or taken with a new problem), and reported new problems in the passages the findings touch; each reader's gaps were given to one refuter asked to refute them against the files. The prompts are in [the brief](BRIEF.md#round-2-third-part). Verbatim: each reader's summary, the ids it found taken, and each gap with its refuter's verdict, numbered by lens (XC, RC and TC) in the order reported; the line numbers are those of the rehearsal.

### Exactness

**Summary.** Of X1 to X19, 16 were taken correctly (X19 counted as taken: it was handed to RR's second item). X5 and X7 were taken but their changes added small defects (problem). X8 is in part: law 31 still says 'Shown a world'. Two new low-severity problems: three sentences in 03 §12 and PLAN §4.8 drop the shared model, and the X10 row of the table says 'at its cap' for an item at 410 of 420.

**Taken as the table says.** X1, X2, X3, X4, X6, X9, X10, X11, X12, X13, X14, X15, X16, X17, X18, X19.

#### XC1: X5 (taken, with a new problem)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/make_records_rfm3.py:287, record a-reading-informed-and-revalued, the law 'Amounts forgone' (Chinese). The same text is quoted in the table row X5, kit/round2c/evidence_rfm3_coldread.py:116-119, which renders at evidence/REVIEW-RFM3-COLDREAD.md:980.

**Quoted.** 共模型且净相合（故二答皆最少），则最少所缺与其量定之

**Problem.** The hypothesis is now stated correctly in all eight places: 03 §12, the header, the study, the record's English, PLAN item 7, PLAN §13 and row F20. In the Lean, forgone_least_iff and coarser_not_above take one model m and `net : ∀ c, c ∈ m.listed → 0 < m.weight c → g c + loss c = l c + gain c`. The fault is in the record's Chinese law. It keeps the parenthesis （故二答皆最少） ('so both answers least'), which its English does not have: 'with a shared model and net agreement, the least shortfalls and the amounts decide', 418 of 420 characters. One law item therefore says different things in its two languages. This is the defect X10 removed from the law on informing. The parenthesis is not false (it follows by answer_least_of_net). But the English cannot take it within the cap: adding ', so both answers least' brings it to 441 characters, and a trimmed version is still 425.

**Replacement.** Record's Chinese law, all of it: 舍量：为一规则而持、舍一量，高于为他规则而持、舍他量，恰当前者之所缺与其量合少于后者；经映射，以分之项言之；共模型且净相合，则最少所缺与其量定之，故经细分，为较粗之答而持、所舍不少，永不高于为较细者而持。 (102 of 190 characters). The English is unchanged. In the X5 row of the table, replace '(zh 共模型且净相合（故二答皆最少）, the English at 418 of its 420 characters)' with '(zh 共模型且净相合, the English at 418 of its 420 characters)', then regenerate the page.

**Verdict: real.** The checker is right about the files. The English law (418 of 420 characters, counted) reads 'with a shared model and net agreement, the least shortfalls and the amounts decide'. The Chinese reads 共模型且净相合（故二答皆最少），则最少所缺与其量定之, so it adds 'so both answers least'. forgone_least_iff and coarser_not_above take one model m and `(net : ∀ c, c ∈ m.listed → 0 < m.weight c → g c + loss c = l c + gain c)`, and their proofs rewrite with answer_least_of_net. So the parenthesis is true but appears in one language only. X10 judged exactly this a defect in the same record ('nothing in it is false … but the two languages of one law item say different things') and dropped the Chinese clause because the English had no room for it. The X5 row's 'where it fits' is a stated choice, but it reverses X10's decision for the same case, so it does not excuse the mismatch. The English cannot take the clause: 441 characters with ', so both answers least'. The checker's Chinese is right: 102 of 190 characters, and it matches the English. Its row edit is right too, but under 'where it fits' it leaves open why the Chinese, which has room, lacks the clause. Saying so explicitly, as the X10 row does, is more exact.

**Refuter's replacement.** Record's Chinese law, all of it: 舍量：为一规则而持、舍一量，高于为他规则而持、舍他量，恰当前者之所缺与其量合少于后者；经映射，以分之项言之；共模型且净相合，则最少所缺与其量定之，故经细分，为较粗之答而持、所舍不少，永不高于为较细者而持。 (102 of 190 characters). The English is unchanged (418 of 420). In the X5 row of TAKEN_LENS, replace '(zh 共模型且净相合（故二答皆最少）, the English at 418 of its 420 characters)' with '(zh 共模型且净相合, “so both answers least” in neither language, the English, at 418 of its 420 characters, having no room for it)', then regenerate REVIEW-RFM3-COLDREAD.md.

#### XC2: X7 (taken, with a new problem)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/evidence_rfm3_lean.py:175 (RECHECK, 'R5'). It renders at evidence/REVIEW-RFM3-LEAN.md:1430, in the table 'What was taken from the re-check'.

**Quoted.** and after the cold read of the texts (its finding X7), the bullet on amounts forgone names both maps' cells, listed once each and covering the holding formation's listing, for `refined_lt_iff`, and the told criterion its cells covering that listing.

**Problem.** The header's changes are right. The told sentence now has 'over cells covering the holding formation's listing', matching told_residual_zero_iff's `(covers : ∀ c, c ∈ m.listed → c ∈ zs)`. The refined_lt_iff sentence now has 'both maps' cells listed once each and covering the holding formation's listing', matching its once, covers, once' and covers'. R5's history is also accurate: at the re-check (81009073d) the header named no cells for refined_lt_iff. The fault is R5's new last clause. Read with its elided verb, it says the bullet on amounts forgone names the told criterion's cells. The told sentence is in the bullet 'When the answer is least'. R5 is meant to say what was named, when and where.

**Replacement.** and after the cold read of the texts (its finding X7), the bullet on amounts forgone names both maps' cells, listed once each and covering the holding formation's listing, for `refined_lt_iff`, and the bullet on when the answer is least names the told criterion's cells, covering that listing. (Change it in RECHECK and regenerate REVIEW-RFM3-LEAN.md.)

**Verdict: real.** The header's changes are right. In the bullet 'When the answer is least' it now has 'Told the candidate, over cells covering the holding formation's listing', which is told_residual_zero_iff's `(covers : ∀ c, c ∈ m.listed → c ∈ zs)`. In 'Amounts forgone, and revaluing' it has 'both maps' cells listed once each and covering the holding formation's listing' for refined_lt_iff (once, covers, once', covers'). R5's history also checks out: at 81009073d the header's refined_lt_iff sentence (its lines 71-73) named no cells. The fault is R5's last clause, 'and the told criterion its cells covering that listing'. It hangs on 'the bullet on amounts forgone names …', and the natural reading ('names [for] the told criterion its cells', as X2's row has 'give the split its cells') puts the told criterion's cells in the amounts-forgone bullet. They are in the bullet 'When the answer is least'. Read as gapping, with 'the told criterion' as a new subject, the clause says nowhere where they are named, while every other clause of R5 names its bullet. The checker's replacement is accurate.

**Refuter's replacement.** In RECHECK's R5, replace 'and the told criterion its cells covering that listing.' with 'and the bullet on when the answer is least names the told criterion's cells, covering that listing.' The clause then reads: 'and after the cold read of the texts (its finding X7), the bullet on amounts forgone names both maps' cells, listed once each and covering the holding formation's listing, for `refined_lt_iff`, and the bullet on when the answer is least names the told criterion's cells, covering that listing.' Then regenerate REVIEW-RFM3-LEAN.md.

#### XC3: X8 (in part)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/make_records_rfm3.py:342 (English) and :346 (Chinese). Record a-reading-informed-and-revalued, the law citing total_filter_shows, within_shown, answer_shown, shown_split, shown_least_le and shown_never_lowers.

**Quoted.** Shown a world, the listing is filtered to the worlds showing what it shows / 示一世界，则其列滤为所示同者之诸世界

**Problem.** The carrier law is fixed as the row says: 'what a demonstration shows, an input presented, or asked' / 示之所显、所呈之入或问. The same claim recurs uncorrected in the record's law on a demonstration, which opens 'Shown a world' / 示一世界, as if the world itself were sensed. In the Lean, `Reader.input w .demonstrate = .shown (rd.reveal w)`. answer_shown states `rd.update (L, v) (.shown (rd.reveal w)) = (L.filter fun c => decide (rd.reveal c = rd.reveal w), v)`. So the sensed input is reveal w : O, which is a world only where reveal is injective, as in TwoWorlds. The law's own clause 'filtered to the worlds showing what it shows' is right.

**Replacement.** English: 'Shown what a world shows, the listing is filtered to the worlds showing it, weights and valuation unchanged, and the answer is the answer through what is shown at that world's cell; its shortfall splits through what is shown, the least shortfall at most that through one cell, and, with the holding formation's model the reading formation's before and net agreement, holding for it never stands lower than before.' (413 of 420 characters, as now). Chinese: '示一世界之所显，则其列滤为所显同者之诸世界，权与值不变，其答即经所示之映射于此世界之格之答；其所缺经所示而分，最少所缺不逾经单格者；持之形成之模型即读之形成示前之模型且净相合，则为之而持永不低于示前。' (100 of 190).

**Verdict: real.** The carrier law is fixed ('what a demonstration shows, an input presented, or asked' / 示之所显、所呈之入或问). But the law on a demonstration still opens 'Shown a world' / 示一世界, and it is the only text that does: 03 §12, the header, the study and PLAN item 18 all say 'what is shown' or 'the demonstration at w'. In the Lean, `Reader.input` has `| .demonstrate => .shown (rd.reveal w)`. answer_shown states `rd.update (L, v) (.shown (rd.reveal w)) = (L.filter fun c => decide (rd.reveal c = rd.reveal w), v)` and gives the answer as `answer ⟨L, rd.weight⟩ (rd.goVal v) (rd.offVal v) rd.reveal (rd.reveal w)`. So what is shown is `reveal w`, which is the world only where reveal tells the worlds apart (TwoWorlds, where reveal is the identity). That is the inexactness X8 judged real in the carrier law. X8 named only lines 327 and 331, so the take was partial. Within this same law, 'what is shown' also means reveal, so the opening disagrees with the rest of its own sentence. The law's other clauses are right. The checker's English is 413 of 420 characters and its Chinese 100 of 190 (counted), and both state answer_shown's filter exactly. X8's row should then also name this law.

**Refuter's replacement.** English: 'Shown what a world shows, the listing is filtered to the worlds showing it, weights and valuation unchanged, and the answer is the answer through what is shown at that world's cell; its shortfall splits through what is shown, the least shortfall at most that through one cell, and, with the holding formation's model the reading formation's before and net agreement, holding for it never stands lower than before.' (413 of 420). Chinese: '示一世界之所显，则其列滤为所显同者之诸世界，权与值不变，其答即经所示之映射于此世界之格之答；其所缺经所示而分，最少所缺不逾经单格者；持之形成之模型即读之形成示前之模型且净相合，则为之而持永不低于示前。' (100 of 190). In the X8 row of TAKEN_LENS, after '(zh 示之所显、所呈之入或问)' add ', and the law on a demonstration “Shown what a world shows, the listing is filtered to the worlds showing it” (zh 示一世界之所显，则其列滤为所显同者之诸世界)', then regenerate REVIEW-RFM3-COLDREAD.md.

#### XC4: a new problem

**Location.** theories/becoming/chapters/03-KNOWING.md §12, the Reading [AI reading, new] at line 519 (source kit/round2c/s12_rfm3.txt line 4). _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md §4.8: the Readings at line 231 and item 12 at line 215.

**Quoted.** 03 §12: 'evaluated by the current valuation, a revision deciding a listed cell against its strict weighted preference counts as a loss, wanted or not' | PLAN Readings: 'by it a revision deciding a listed cell against the current valuation's strict weighted preference counts as a loss, wanted or not' | PLAN item 12: 'With the reference the revised valuation, the revised answer has no residual through the same map (11 at the revised valuation).'

**Problem.** These sentences restate the claims of X3 and X4 without the shared model. In 03 and the PLAN Readings it is stated only in the paragraph's opening sentence, several sentences earlier. In PLAN item 12 it comes only through the pointer to item 11. In the Lean, `revalued_lowers_iff (m : Model C) (g l g' l' : C → Nat) …` compares `m.after (shifted g l) (byRule fun c => answer m g' l' π (π c))` with the same expression for answer m g l π, and `outcome_least (m) (g' l') (π) (zs) : residual m g' l' π zs (answer m g' l' π) = 0`. Both use one model for forming and for evaluating the answer. With the models apart both claims fail: in WeightsApart, with the valuation equal to the reference, the answer has residual 1 (weights_split), and a revision that leaves that answer unchanged decides a listed cell against the strict preference and loses nothing. PLAN §13's cold-read paragraph (line 399) says the model is stated 'wherever the evaluation by its own current valuation is stated, `outcome_least` included'. That holds only once these sentences carry it. The Lean header's parallel sentence (line 233) sits in the paragraph on `own_least` and `revalued_lowers_iff` and can stay. The board's landing text in board_rfm3.py ('so with a shared model and agreement in net informing never lowers the worth, and by the reading formation's own current valuation no revaluation gains …') is ambiguous on whether the shared model covers the second clause.

**Replacement.** 03 §12, and s12_rfm3.txt: 'evaluated by the current valuation on a shared model, a revision deciding a listed cell against its strict weighted preference counts as a loss, wanted or not' | PLAN Readings: 'by it, on a shared model, a revision deciding a listed cell against the current valuation's strict weighted preference counts as a loss, wanted or not' | PLAN item 12: 'With the reference the revised valuation and the reading formation's model the holding formation's, the revised answer has no residual through the same map (11 at the revised valuation).' | Board text, optional: 'and, on a shared model, by the reading formation's own current valuation no revaluation gains and one deciding a listed cell against its strict weighted preference loses'.

**Verdict: real.** The quoted sentences are as the checker says. In the Lean, revalued_lowers_iff compares `m.after (shifted g l) (byRule fun c => answer m g' l' π (π c)) < m.after (shifted g l) (byRule fun c => answer m g l π (π c))` on one model m, and outcome_least is `residual m g' l' π zs (answer m g' l' π) = 0`. Both form and evaluate the answer on the same model. With the models apart, WeightsApart.weights_split has `residual holding gain loss (fun c => decide (c = 2)) [false, true] (answer reading gain loss (fun c => decide (c = 2))) = 1` with the valuation equal to the reference. So a revision that leaves that answer unchanged decides a listed cell against the strict preference and loses nothing, and the revised answer's residual by the revised valuation need not be 0. In 03, the opening's 'with a shared model' does not plainly carry to the Carroll sentence: the sentences in between switch to 'a reference the valuation does not share' and repeat 'with a shared model' for the gain from revaluing, which signals that the qualifier goes claim by claim. Everywhere else the same claim is stated (overview, dossier, 07 §7, 08 §8, the study's standing, the record's correspondence), the qualifier sits next to it. PLAN item 12 gets the shared model only through '(11 at the revised valuation)'. PLAN §13 claims the model is said 'wherever the evaluation by its own current valuation is stated, `outcome_least` included', which holds only once these sentences carry it. Nothing in the table decided otherwise: re-check point 1 listed specific places, and R11 changed only the attribution. The checker's replacements are right and match the dossier's 'evaluated by the current valuation on a shared model' and item 11's wording. The header's sentence (lines 232-234) sits in the paragraph that names own_least and revalued_lowers_iff and can stay without a rebuild. One addition: the R11 row of the cold read page quotes the 03 sentence as it now stands, so give it the new wording or record the change in the second re-check's table.

**Refuter's replacement.** 03 §12 and s12_rfm3.txt: 'evaluated by the current valuation on a shared model, a revision deciding a listed cell against its strict weighted preference counts as a loss, wanted or not'. PLAN Readings: 'by it, on a shared model, a revision deciding a listed cell against the current valuation's strict weighted preference counts as a loss, wanted or not'. PLAN item 12: 'With the reference the revised valuation and the reading formation's model the holding formation's, the revised answer has no residual through the same map (11 at the revised valuation).' Then either change the R11 row of TAKEN_LENS to quote '“evaluated by the current valuation on a shared model, a revision deciding a listed cell against its strict weighted preference counts as a loss”', or record this change in the table of the re-check of what was taken from the lenses (RECHECKS[1]), and regenerate the page. Board text in board_rfm3.py, optional: 'and, on a shared model, by the reading formation's own current valuation no revaluation gains and one deciding a listed cell against its strict weighted preference loses'.

#### XC5: a new problem

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/evidence_rfm3_coldread.py:136-137, the 'X10' row. It renders at evidence/REVIEW-RFM3-COLDREAD.md:985, in the table 'What was taken from the lenses'.

**Quoted.** the clause dropped from the Chinese, the English being at its cap

**Problem.** The table says the English law on informing is 'at its cap'. It is at 410 of its 420 characters. The reason still holds: the proposed English addition, about 55 characters, would exceed the cap, as the judge said. The same table gives exact counts elsewhere (X5: '418 of its 420 characters').

**Replacement.** the clause dropped from the Chinese, the English, at 410 of its 420 characters, having no room for it (then regenerate the page)

**Verdict: real.** The row says 'the English being at its cap'. The English law on informing (make_records_rfm3.py:217) is 410 characters (counted) against a cap of 420. The judge wrote 'at 410 of its 420-character cap', and the row shortened that into something literally false. The reason still holds: the proposed English addition of about 55 characters would bring the law to about 465, so dropping the Chinese clause was right. The fix is one of precision only, and it matches the exact count the X5 row gives ('418 of its 420 characters'). The Lean has no bearing on it.

**Refuter's replacement.** In the X10 row of TAKEN_LENS: 'the clause dropped from the Chinese, the English, at 410 of its 420 characters, having no room for it'. Then regenerate REVIEW-RFM3-COLDREAD.md.

### Readings

**Summary.** Readings lens: 13 of 14 handled correctly. R1-R3, R6-R8, R10, R11 and R13 were taken as the table says and agree with the Lean; R4 and R5 were met harmlessly; R12 and R14 were rightly left. R9 is in part: the plan's §5 row still reads the incentive to revise without the supplied update's reach or costs, so the plan's §13 claim 'wherever it is read' is not yet true. There are 3 new low-severity problems: the overview's 'such a valuation' and the record's '(if the update reaches it)' refer to nothing that gains, and the routes sentence has no 'can' in the root bullet and the checker's scope.

**Taken as the table says.** R1, R2, R3, R4, R5, R6, R7, R8, R10, R11, R12, R13, R14.

#### RC1: R9 (in part)

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md:247, §5 table, row 'preference shaping, deceptive alignment' (and through it the plan's §13, line 399)

**Quoted.** its laws read as an incentive to revise under a reference the valuation does not share and, by the reading formation's current valuation on a shared model, a reason to keep it from a revision deciding a listed cell against its strict weighted preference, no criterion of legitimate change supplied

**Problem.** The overview, the dossier and the record were changed as the table says. The same reading recurs in the plan's §5 row, rewritten in this round for T26, and there it has neither the supplied update's reach nor costs. In the Lean, `revaluing_gains_iff` says only that some unrestricted value pair gains exactly where the residual is positive: `(∃ g' l' : C → Nat, m.after (shifted gain loss) (byRule fun c => answer m g l π (π c)) < m.after (shifted gain loss) (byRule fun c => answer m g' l' π (π c))) ↔ 0 < residual m gain loss π zs (answer m g l π)`. It asserts no reachability. The module reads the incentive 'in counts and before costs, the second only where the supplied update reaches such a valuation, which is not asserted', and 03 §12 and §4.8 say the same. The row is therefore a wider reading than theirs. The plan's own §13 sentence, 'the incentive to revise qualified, wherever it is read, by the supplied update's reach and by costs', is not yet true.

**Replacement.** its laws read as an incentive, before costs, to revise under a reference the valuation does not share, only where the supplied update reaches a valuation whose answer stands above the current one by that reference, and, by the reading formation's current valuation on a shared model, a reason to keep the valuation from a revision deciding a listed cell against its strict weighted preference, no criterion of legitimate change supplied

**Verdict: real.** Line 247 reads exactly as quoted. The delta diff shows it was rewritten in this round for T26, from 'its gain under a reference … are readings of its laws' to 'its laws read as an incentive to revise under a reference the valuation does not share …'. The rewrite carries neither the update's reach nor 'before costs'. The Lean asserts no reach. `revaluing_gains_iff` states `(∃ g' l' : C → Nat, m.after (shifted gain loss) (byRule fun c => answer m g l π (π c)) < m.after (shifted gain loss) (byRule fun c => answer m g' l' π (π c))) ↔ 0 < residual m gain loss π zs (answer m g l π)`, and its docstring says 'Reachability under a supplied update is not asserted'. The module's Readings say 'in counts and before costs, the second only where the supplied update reaches such a valuation, which is not asserted'; the plan's §4.8 Readings (:231) say the same, and 03 §12 says 'whether the supplied update reaches it not asserted … before costs'. Nothing in the table decides otherwise: R9's 'Taken' names only the overview, the dossier and the record, and T26's gives the row's present words with no reason for dropping the limits. R5's defence, that a table row compresses, does not hold here, for two reasons. First, §13 (:399) claims 'the incentive to revise qualified, wherever it is read, by the supplied update's reach and by costs', and that is false while this row stands. Second, R9 was confirmed for the same omission in the overview, which is also a compressed summary. No other row in §5 or §8 reads an incentive to revise. The replacement is right. 'A valuation whose answer stands above the current one by that reference' is the plan's own wording in item 13 ('an answer through π standing strictly above the current answer by the reference'). It spells out the module's 'such a valuation' and needs no shared model. 'Keep the valuation' resolves the 'it' that the inserted clause would leave unclear. It agrees with the overview and the dossier ('where the supplied update reaches such a valuation') and with the record as corrected below. The plan has no cap.

#### RC2: a new problem

**Location.** theories/becoming/THE-THEORY-OF-BECOMING.md:102, the paragraph 'What another's reading answers can be moved…', its Read [AI reading] sentence (R9's change)

**Quoted.** Read [AI reading]: under a reference it does not share, incentives, before costs, to withhold and, where the supplied update reaches such a valuation, to revise;

**Problem.** 'such a valuation' has no antecedent in the overview. The dossier's version gives it one ('informing can lower the worth of holding and revaluing raise it'), and so does the module's ('some replacement valuation gains … the second only where the supplied update reaches such a valuation'). The overview names no valuation that gains, so 'such a valuation' binds to 'a reference it does not share'. The reading then gives an incentive to revise wherever the update reaches the reference. That is wider than the Lean: `revaluing_gain` says revaluing to the reference gains exactly the current answer's residual. That residual is nothing for a valuation that differs from the reference but agrees with it on another positive scale (`answer_least_of_scaled`). The flat 'incentives … to withhold' also drops the 'can' of `Informing.informing_lowers`, which the dossier keeps for the same claim.

**Replacement.** Read [AI reading]: under a reference it does not share, informing can lower the worth of holding and revaluing raise that worth, incentives, before costs, to withhold and, where the supplied update reaches such a valuation, to revise;

**Verdict: real.** The text is as quoted. The paragraph's only valuations are 'a reference valuation' and 'a reference it does not share', and 'a revaluation moves only the second' names no gain. So 'such a valuation' binds to the reference, and the reading becomes an incentive to revise wherever the update reaches the reference. That is wider than the Lean. `revaluing_gain` states `m.after (shifted gain loss) (byRule fun c => answer m g l π (π c)) + residual m gain loss π zs (answer m g l π) = m.after (shifted gain loss) (byRule fun c => answer m gain loss π (π c))`, so revaluing to the reference gains exactly the residual. That residual is nothing for valuations that differ from the reference: `answer_least_of_scaled` covers one positive scale, and `answer_least_of_net` covers an offset such as g = gain + 1, l = loss + 1. The flat 'incentives … to withhold' also loses the 'can' of `Informing.informing_lowers` ('informing can lower the worth below both moves', a witness). `informed_answer_le` shows informing never lowers the worth with a shared model and net agreement, which an unshared reference with an offset satisfies. In the same round the delta changed the dossier from 'these are incentives' to 'informing can lower the worth of holding and revaluing raise it, incentives, …', which gives its 'such a valuation' an antecedent; the overview got only R9's phrase. R9's table row gives both the same phrase and states no reason for the difference. The replacement is right. It is the dossier's accepted form, and 'raise that worth' avoids an 'it' that in this paragraph names the reading formation. The change also has to go into integrate_rfm3.py:193. There is no cap; the paragraph goes from 163 to 175 words.

#### RC3: a new problem

**Location.** _process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/kit/round2c/make_records_rfm3.py:467 (en) and :475 (zh), record a-reading-informed-and-revalued, correspondence, its AI reading (R9's change)

**Quoted.** AI reading: under a reference the valuation differs from, incentives to withhold and to revise (if the update reaches it), before costs; / AI 解读：参照与值相异时，读为扣告与改（若所予之更新可达）之诱因，未计其费；

**Problem.** In English, 'it' can only bind to 'a reference' (the update does not 'reach' the valuation it updates). The reading then gives an incentive to revise whenever the update reaches the reference. That is wider than `revaluing_gain`, whose gain is exactly the current answer's residual: nothing where a differing valuation decides no listed cell against the reference's strict weighted preference (for example `answer_least_of_scaled`). It is also not the module's condition, which is reaching a valuation that gains. The replacement fits the caps: the English field comes to 1197 of 1200 characters and the Chinese to 466 of 500.

**Replacement.** AI reading: under a reference not shared, incentives to withhold and to revise (if the update reaches a gaining valuation), before costs; / AI 解读：参照与值相异时，读为扣告与改（若所予之更新可达有得之值）之诱因，未计其费；

**Verdict: real.** The text is as quoted. 'It' is singular, and the update cannot 'reach' the valuation it updates, so 'it' binds to 'a reference', and the reading is an incentive to revise whenever the update reaches the reference. `revaluing_gain` (quoted under the previous item) makes that gain exactly the current answer's residual. The residual is zero for a valuation that differs from the reference but agrees with it on a positive scale (`answer_least_of_scaled`) or in net with an offset (`answer_least_of_net`). The record's own law item (:311-313) states the module's condition: 'some unrestricted pair of value functions gives an answer strictly above the current one by the reference exactly where that residual is positive … such a gain needs a positive residual'. The correspondence's reading is wider than that law. The Chinese '若所予之更新可达' has no object at all. R9's judge accepted '(if the update reaches it)' for the cap without addressing what 'it' refers to, which is not a stated reason. I measured the field by parsing the script with ast, without running it: English 1196, becoming 1197 of 1200; Chinese 462, becoming 466 of 500. 'Under a reference not shared' is needed to stay within the cap, means the same as 'does not share' elsewhere, and matches the Chinese 参照与值相异. 'A gaining valuation' reads against the record's own 'such a gain'. '有得之值' uses the record's 得 and 值. The wording agrees with the corrected plan row and the overview.

#### RC4: a new problem

**Location.** experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming.lean:2882-2884 (root bullet on ListingValuation) and check_becoming.py:2968 (scope sentence), both written by kit/round2c/integrate_rfm3.py (:73 and :93); the same words in kit/round2c/board_rfm3.py's landing text

**Quoted.** from different starts, a route shown and a route presented answer alike and end in one state while the valuation changed on one alone

**Problem.** This is the same witness claim as R4 and R5, stated positively and without 'can'. The Lean concerns two particular routes from `TwoWorlds.shownStart` and `TwoWorlds.presentedStart` (`route_answers`, `routes_rest`, `changed_apart`): `theorem not_lumped (T : Nat) (le : 2 ≤ T) : ¬ Learning.Lumped (record T) (changed T)`. Read generically, as the bullet's other clauses are, the sentence says any route shown and any route presented from different starts answer alike and end in one state. The overview, 07 §7, the dossier and the plan's §8 row say 'can' (X9, R5), and R4's verdict holds 'can' needed in the positive form.

**Replacement.** from different starts, a route shown and a route presented can answer alike and end in one state while the valuation changed on one alone (Becoming.lean's second line becomes '  presented can answer alike and end in one state while the valuation changed on one alone'; check_becoming.py's string 'senses, and, from different starts, a route shown and a route presented can answer alike and end in one state while '; the same in integrate_rfm3.py's two strings, and 'a route shown and a route presented can answer alike and end in one state' in board_rfm3.py)

**Verdict: real.** The text is as quoted in all three places; the board's version is shorter and has no 'while' clause. The Lean concerns two particular routes: `def route (b : Bool) := cond b presentedStart shownStart`, `theorem not_lumped (T : Nat) (le : 2 ≤ T) : ¬ Learning.Lumped (record T) (changed T)`, `route_answers (b : Bool)` and `routes_rest (b : Bool)`, all on those routes only. The bullet's other clauses use the indefinite generically ('a rule with no residual through a finer map falls short by at most any rule through a coarser one'). Read the same way, this clause claims that any route shown and any route presented from different starts answer alike, which is wider than proved. R4's verdict says ''can' is needed only in the overview's positive form', and this clause is a positive form. Every other positive statement of it now says 'can': the overview, 07 §7 (integrate :165), the dossier and the plan's §8 row. The best case against this finding is R5's refuter, who read the identical §8 phrasing as a description of the witness. Even so, that row was brought to 'can' as clearer and harmless, and a list of laws invites the description reading less than a literature table does. Nothing was decided otherwise: T20 changed only the noun ('revalued' to 'presented'), and the cross-model reader reported nothing here. The replacement is right and minimal. One timing constraint: SCOPE is written into each run's verification.json (check_becoming.py:3956, "scope": SCOPE), so the scope string must change before the landing's core run.

**Refuter's replacement.** In both texts: 'from different starts, a route shown and a route presented can answer alike and end in one state while the valuation changed on one alone'. Concretely, Becoming.lean:2883 and integrate_rfm3.py:93 become '  presented can answer alike and end in one state while the valuation changed on one alone'. check_becoming.py:2968 and integrate_rfm3.py:73 become '    "senses, and, from different starts, a route shown and a route presented can answer alike and end in one state while "'. In board_rfm3.py:42, 'a route shown and a route presented can answer alike and end in one state'.

### Fit

**Summary.** Fit lens T1-T31: 29 taken correctly. 2 only in part: T8, where the study and the module header still claim the worth where two worlds alone are not told apart, and T17, where the dossier's account still leaves out RF-M.3's change to RF-M.2's last sentence. 3 new problems in touched passages: the plan's §5 row reads the incentive to revise without reach or costs; the loss by the current valuation is stated without the shared model; the study and re-point reason omit §4.7.

**Taken as the table says.** T1, T2, T3, T4, T5, T6, T7, T9, T10, T11, T12, T13, T14, T15, T16, T18, T19, T20, T21, T22, T23, T24, T25, T26, T27, T28, T29, T30, T31.

#### TC1: T8 (in part)

**Location.** rf-formations-that-read/kit/round2c/study_rfm3.txt, Delta, bullet 'The carrier, on Blanket.Blanketed' (wrapped over lines 100-102); Becoming/ListingValuation.lean module header, bullet '**The carrier**' (lines 124-126; the kit's tree/Becoming copy and the package copy are identical)

**Quoted.** study: "so they are alike where no demonstration tells them apart (input_eq_of_reveal_eq, inputs_alike) or none is emitted (input_eq_of_ne_demonstrate, undemonstrated_alike), and there holding for the answer is worth one committed move (undemonstrated_worth, answer_constant)"; header: "so they are alike wherever no demonstration is emitted (`undemonstrated_alike`) or none tells the worlds apart (`inputs_alike`), and there holding for the answer is worth one committed move (`undemonstrated_worth`, `answer_constant`)."

**Problem.** The row says 'the study and the header likewise', and 03 §12 now says 'none tells the listed worlds apart'. The record's law already says 'at listed worlds all showing one value or with no demonstration emitted'. The study and the header got only the parse fix. Their 'there' is still where no demonstration tells two worlds apart, a wider case than answer_constant proves. Lean: `theorem answer_constant ... (shows : ∀ w, w ∈ m.listed → rd.reveal w = o) (w₀ : W) (shows₀ : rd.reveal w₀ = o) (n : Nat) : m.after (shifted gain loss) (byRule fun w => ((joint rd hd).course ⟨i, s, a, (w, h)⟩ n).active) = m.committed (shifted gain loss) (cond ((joint rd hd).course ⟨i, s, a, (w₀, h)⟩ n).active .off .go)`. answer_constant needs every listed world to show what w₀ shows. inputs_alike needs only `(same : rd.reveal w = rd.reveal w')` for two worlds. So if two worlds are not told apart but a third listed world is, the answer need not be constant. The worth claim is wider than the Lean in the study and the header, and narrower in 03 and the record.

**Replacement.** study: "so they are alike where no demonstration tells them apart (input_eq_of_reveal_eq, inputs_alike) or none is emitted (input_eq_of_ne_demonstrate, undemonstrated_alike), and, where none tells the listed worlds apart or none is emitted, holding for the answer is worth one committed move (undemonstrated_worth, answer_constant)"; header (a docstring only, no statement changes; needs the same rebuild as the other header revisions): "so they are alike wherever no demonstration is emitted (`undemonstrated_alike`) or none tells the worlds apart (`inputs_alike`), and, wherever none is emitted or none tells the listed worlds apart, holding for the answer is worth one committed move (`undemonstrated_worth`, `answer_constant`)."

**Verdict: real.** Real, in part. In the study, 'them' takes 'two worlds' as its antecedent: 'so they are alike where no demonstration tells them apart (input_eq_of_reveal_eq, inputs_alike) or none is emitted (...), and there holding for the answer is worth one committed move (undemonstrated_worth, answer_constant)'. In the header, 'the worlds' does the same: '... or none tells the worlds apart (`inputs_alike`), and there holding ...'. So 'there' includes the case of `inputs_alike`, which needs only `(same : rd.reveal w = rd.reveal w')` for two worlds. The worth law `answer_constant` needs `(shows : ∀ w, w ∈ m.listed → rd.reveal w = o) (w₀ : W) (shows₀ : rd.reveal w₀ = o)`: every listed world shows one value. Take two listed worlds alike and a third told apart: once a demonstration is emitted the answer can differ there and be informative. So the study and the header claim the worth more widely than proved. The delta diff shows they got only the parse change ("so they are alike ...", "and there"). 03 §12 ('none tells the listed worlds apart') and the record's law ('at listed worlds all showing one value or with no demonstration emitted') were narrowed. So the table's 'the study and the header likewise' holds only for the parse. The T8 judge's 'state both cases' is true of the alike claims, not of the scope of the worth claim. The replacement is right, and it agrees with the record's split: alike for two worlds, worth for the listed worlds. In the study version, though, the citations '(undemonstrated_worth, answer_constant)' run against its clause order ('listed worlds ... or none is emitted'); corrected below. No cap applies: the study is a template and the header is a docstring. The header change touches no statement, but it changes both module copies and needs a rebuild.

**Refuter's replacement.** study_rfm3.txt: "so they are alike where no demonstration tells them apart (input_eq_of_reveal_eq, inputs_alike) or none is emitted (input_eq_of_ne_demonstrate, undemonstrated_alike), and holding for the answer is worth one committed move where none tells the listed worlds apart (answer_constant) or none is emitted (undemonstrated_worth)". Module header, both copies (kit/round2c/tree/Becoming/ListingValuation.lean and the package's), docstring only, one rebuild: "so they are alike wherever no demonstration is emitted (`undemonstrated_alike`) or none tells the worlds apart (`inputs_alike`), and, wherever none is emitted or none tells the listed worlds apart, holding for the answer is worth one committed move (`undemonstrated_worth`, `answer_constant`)." T8's row ('the study and the header likewise') then holds. The cold read page's build link moves to the new build log.

#### TC2: T17 (in part)

**Location.** theories/becoming/review/ALIGNMENT.md, 'How it was made', the last RF bullet (line 41), written by the fourth dossier edit in rf-formations-that-read/kit/round2c/integrate_rfm3.py (lines 216-219)

**Quoted.** "RF-M.3's sentences and its changes to the assistance-games clause and round 2's sentence, made on 31 October 2026, were cold-read before its landing" (in integrate_rfm3.py: "and Good's note in the British Journal for the Philosophy of Science, 1967). RF-M.3's sentences and its changes to the assistance-games clause and round 2's sentence, made on " followed by f"{TODAY.day} {TODAY:%B} {TODAY.year}, were cold-read before its landing, ...")

**Problem.** T17's replacement was applied as proposed. But RF-M.3 also changes a third piece of existing text that the entry still does not name. The script's third dossier edit cuts RF-M.2's last sentence, 'The reading formation's own state, a noisy reading and continuous beliefs are not represented.', to 'A noisy reading and continuous beliefs are not represented.' That edit was already in the texts the lenses read (kit at 3f43eefcf, integrate_rfm3.py:213). Also, 'round 2's sentence' does not say which of round 2's several sentences is meant. The changed one is the reading loop's sentence, the one that lost '; a principal's valuation as state is a later item', and the same bullet calls it 'round 2's first sentence'.

**Replacement.** dossier: "RF-M.3's sentences and its changes to the assistance-games clause, to round 2's first sentence and to RF-M.2's last sentence, made on 31 October 2026, were cold-read before its landing"; integrate_rfm3.py (both the edit's string and the f-string line after it unchanged otherwise): "and Good's note in the British Journal for the Philosophy of Science, 1967). RF-M.3's sentences and its changes to the assistance-games clause, to round 2's first sentence and to RF-M.2's last sentence, made on "

**Verdict: real.** Real, in part. `git diff --word-diff` of ALIGNMENT.md shows that RF-M.3 changes three pieces of existing text. (1) The assistance-games clause (edit 1). (2) The reading loop's sentence loses '; a principal's valuation as state is a later item' (edit 2). (3) RF-M.2's last sentence goes from 'The reading formation's own state, a noisy reading and continuous beliefs are not represented.' to 'A noisy reading and continuous beliefs are not represented.' (edit 3, already at integrate_rfm3.py:213 in the kit at 3f43eefcf, so in the texts the lenses read). `git log -S` puts both cut phrases in RF-M.2's landing bccab518f, so (3) is a change to RF-M.2's text, not one of RF-M.3's own sentences. The entry names only two changes. Its 'round 2's sentence' is singular and does not say which: the paragraph holds the reading loop's, RF7's and RF-M.2's sentences, and the same bullet already calls the reading loop's sentence 'round 2's first sentence'. T17's row gives no reason for leaving (3) out. The replacement is right, and the f-string date line after the edit stays unchanged. No cap applies (the dossier's prose).

**Refuter's replacement.** ALIGNMENT.md: "RF-M.3's sentences and its changes to the assistance-games clause, to round 2's first sentence and to RF-M.2's last sentence, made on 31 October 2026, were cold-read before its landing". integrate_rfm3.py, the edit's string: "and Good's note in the British Journal for the Philosophy of Science, 1967). RF-M.3's sentences and its changes to the assistance-games clause, to round 2's first sentence and to RF-M.2's last sentence, made on " (the f-string line after it unchanged). For the page to match, T17's 'Taken' cell in evidence_rfm3_coldread.py becomes: “RF-M.3's sentences and its changes to the assistance-games clause, to round 2's first sentence and to RF-M.2's last sentence, made on …”, and the page is regenerated.

#### TC3: a new problem

**Location.** rf-formations-that-read/PLAN.md, §5 'A shared obstruction pattern', table row 'preference shaping, deceptive alignment' (line 247), the row T26 changed

**Quoted.** its laws read as an incentive to revise under a reference the valuation does not share and, by the reading formation's current valuation on a shared model, a reason to keep it from a revision deciding a listed cell against its strict weighted preference, no criterion of legitimate change supplied

**Problem.** T26 was taken: the gain is now a law, read as an incentive. But this reading drops both qualifiers the cold read put on the incentive to revise everywhere else. R9's row, the overview, the dossier, the record, 03 §12 and this plan's own §4.8 Readings all carry them: 'in counts and before costs, the second only where the supplied update reaches such a valuation, which is not asserted'. This plan's §13 also says the incentive to revise was 'qualified, wherever it is read, by the supplied update's reach and by costs'. The Lean: revaluing_gains_iff's docstring says 'Reachability under a supplied update is not asserted'. Its statement ranges over unrestricted value functions and is worth before any cost: `(∃ g' l' : C → Nat, m.after (shifted gain loss) (byRule fun c => answer m g l π (π c)) < m.after (shifted gain loss) (byRule fun c => answer m g' l' π (π c))) ↔ 0 < residual m gain loss π zs (answer m g l π)`.

**Replacement.** its laws read as an incentive, before costs, to revise under a reference the valuation does not share, only where the supplied update reaches a valuation that gains, which is not asserted, and, by the reading formation's current valuation on a shared model, a reason to keep it from a revision deciding a listed cell against its strict weighted preference, no criterion of legitimate change supplied

**Verdict: real.** Real. The row reads: 'its laws read as an incentive to revise under a reference the valuation does not share and, by the reading formation's current valuation on a shared model, a reason to keep it ...'. It gives neither costs nor reach. Every other reading of the incentive to revise carries both. The plan's §4.8 Readings (PLAN.md:231): 'in counts and before costs, the second only where the supplied update reaches such a valuation, which is not asserted'. 03 §12: 'whether the supplied update reaches it not asserted ... in counts and before costs'. The module's Readings say the same. The overview and the dossier: 'incentives, before costs, to withhold and, where the supplied update reaches such a valuation, to revise'. The record: '(if the update reaches it), before costs'. The plan's own §13 says 'the incentive to revise qualified, wherever it is read, by the supplied update's reach and by costs', and this row makes that sentence false. R9 located only the overview, the dossier and the record, and T26's row gives no reason for dropping the qualifiers. Lean: `revaluing_gains_iff` ranges over unrestricted value functions: `(∃ g' l' : C → Nat, m.after (shifted gain loss) (byRule fun c => answer m g l π (π c)) < m.after (shifted gain loss) (byRule fun c => answer m g' l' π (π c))) ↔ 0 < residual m gain loss π zs (answer m g l π)`. Its docstring says 'Reachability under a supplied update is not asserted', and the worth is before any amount forgone. The replacement is right and uses §4.8's own words. 'Keep it' still binds to the current valuation. No cap applies: a plan table cell, not a record field.

**Refuter's replacement.** "its laws read as an incentive, before costs, to revise under a reference the valuation does not share, only where the supplied update reaches a valuation that gains, which is not asserted, and, by the reading formation's current valuation on a shared model, a reason to keep it from a revision deciding a listed cell against its strict weighted preference, no criterion of legitimate change supplied". For the page to match, T26's 'Taken' quotation in evidence_rfm3_coldread.py becomes these words (or R9's row names the plan's §5 row), and the page is regenerated.

#### TC4: a new problem

**Location.** theories/becoming/chapters/03-KNOWING.md, §12 The reading loop, 'Reading [AI reading, new]', the Carroll sentence (line 519; source rf-formations-that-read/kit/round2c/s12_rfm3.txt line 4). The same sentence recurs in rf-formations-that-read/PLAN.md §4.8 'Readings' (line 231) and in Becoming/ListingValuation.lean, Readings (lines 232-234)

**Quoted.** 03 §12 and s12_rfm3.txt: "evaluated by the current valuation, a revision deciding a listed cell against its strict weighted preference counts as a loss, wanted or not"; plan §4.8: "by it a revision deciding a listed cell against the current valuation's strict weighted preference counts as a loss, wanted or not"; module Readings: "by it, a revision that changes a decision against the current strict preference counts as a loss, wanted or not"

**Problem.** This is the passage T7 touches; R11's change rewrote it. It restates the loss by the current valuation as a law of its own with no shared model, several sentences after the paragraph's opening 'with a shared model'. The plan's §13 says the shared model was stated 'wherever the evaluation by its own current valuation is stated'. Every other statement of the reason to keep carries it: 07 §7, the overview, the dossier, 08 §8 and the record. Lean: `theorem revalued_lowers_iff (m : Model C) (g l g' l' : C → Nat) (π : C → K) {zs : List K} (once : List.Pairwise (fun a b => a ≠ b) zs) (covers : ∀ c, c ∈ m.listed → π c ∈ zs) : m.after (shifted g l) (byRule fun c => answer m g' l' π (π c)) < m.after (shifted g l) (byRule fun c => answer m g l π (π c)) ↔ ∃ z, z ∈ zs ∧ (...)`. One model m serves the holding formation's evaluation and both answers. With the models apart, the current answer need not be least, so a revision against its preference need not lose. The plan's and the module's Readings carry the same unqualified sentence ('by it ...').

**Replacement.** 03 §12 and s12_rfm3.txt: "evaluated by the current valuation on a shared model, a revision deciding a listed cell against its strict weighted preference counts as a loss, wanted or not"; plan §4.8: "by it, on a shared model, a revision deciding a listed cell against the current valuation's strict weighted preference counts as a loss, wanted or not"; module Readings (a docstring only, in the same rebuild as T8's header change): "by it, on a shared model, a revision that changes a decision against the current strict preference counts as a loss, wanted or not"

**Verdict: real.** Real. 03 §12 now reads '... a very crude baseline: evaluated by the current valuation, a revision deciding a listed cell against its strict weighted preference counts as a loss, wanted or not'. That restates `revalued_lowers_iff` with no model condition. The shared model appears only in the paragraph's third sentence, and the sentences in between turn to a reference the valuation does not share and to the weights apart. The plan's §4.8 Readings ('by it a revision deciding a listed cell against the current valuation's strict weighted preference counts as a loss') and the module's Readings ('by it, a revision that changes a decision against the current strict preference counts as a loss') do the same. Lean: `theorem revalued_lowers_iff (m : Model C) (g l g' l' : C → Nat) (π : C → K) ... : m.after (shifted g l) (byRule fun c => answer m g' l' π (π c)) < m.after (shifted g l) (byRule fun c => answer m g l π (π c)) ↔ ∃ z, z ∈ zs ∧ ...`. One model `m` serves the evaluation and both answers. With the models apart, the current answer can carry a residual by the holding formation's model, so a revision against the reading formation's strict preference need not lose. A grep shows every other statement of the evaluation by the current valuation carries the shared model: 03 §12's theorem and its third Reading sentence, 07 §7, the overview, the dossier, 08 §8, the study's Read and the record's correspondence. The plan's §13 says the model condition was stated 'wherever the evaluation by its own current valuation is stated'. The re-check point taken before the lenses rejected the same context-free form at PLAN.md:291. R11's row gives no reason for leaving it out. The neighbouring Everitt sentences need no change: each hangs on the shared-model sentence or on named theorems ('This', item 11, `own_least` and `revalued_lowers_iff`). The replacement is right and matches the dossier's 'evaluated by the current valuation on a shared model'. No cap applies. The module change is a docstring in both copies and goes in the same rebuild as T8's.

**Refuter's replacement.** 03 §12 and s12_rfm3.txt: "evaluated by the current valuation on a shared model, a revision deciding a listed cell against its strict weighted preference counts as a loss, wanted or not". Plan §4.8: "by it, on a shared model, a revision deciding a listed cell against the current valuation's strict weighted preference counts as a loss, wanted or not". Module Readings, both copies, docstring only, in the rebuild for T8: "by it, on a shared model, a revision that changes a decision against the current strict preference counts as a loss, wanted or not". For the page to match, R11's 'Taken' quotation in evidence_rfm3_coldread.py gains 'on a shared model', and the page is regenerated.

#### TC5: a new problem

**Location.** rf-formations-that-read/kit/round2c/study_rfm3.txt, 'Output → input' (lines 178-183, the list T23 completed); rf-formations-that-read/kit/round2c/repoint_rfm3.py, REASON (lines 58-67)

**Quoted.** study: "RF's plan (§4.8, §5's and §8's rows, §12, §13 and Evidence)"; REASON: "RF's plan (§4.8, §5's and §8's rows, §12, §13's reviews and the Evidence list)"

**Problem.** Taking T22 changed the plan's §4.7 paragraph on RF-M.3, which now reads '(redesigned and built in §4.8, where 'shaping' became 'revaluing')' (commit 22a113c0c). Two lists of the plan's changed places still leave §4.7 out: the study's list of what RF-M.3 changes, which T23 completed, and the re-point reason T23 checked that list against. So both name fewer of the plan's changed places than RF-M.3 makes. The guard itself is unaffected, since EXPECTED's '4. The new laws' covers the §4.7 lines.

**Replacement.** study: "RF's plan (§4.7's paragraph on RF-M.3, §4.8, §5's and §8's rows, §12, §13 and Evidence)"; REASON: "RF's plan (§4.7's paragraph on RF-M.3, §4.8, §5's and §8's rows, §12, §13's reviews and the Evidence list)"

**Verdict: real.** Real, minor. Taking T22 (commit 22a113c0c) changed the plan's §4.7 paragraph on RF-M.3 from '(not built; the carrier first)' to '(redesigned and built in §4.8, where 'shaping' became 'revaluing')'. The delta diff and `git diff HEAD^2` against main both show it. Against main, RF-M.3 changes the plan in §4.7's paragraph, §4.8, §5's row, §8's rows, §12's item 2, §13's paragraphs and the Evidence list. Both lists name all of these except §4.7's paragraph. The study's: 'RF's plan (§4.8, §5's and §8's rows, §12, §13 and Evidence)'. REASON's: 'RF's plan (§4.8, §5's and §8's rows, §12, §13's reviews and the Evidence list)'. That is the incompleteness T23 confirmed for §5 and §8, introduced again by a change made alongside it. The guard is unaffected: research.py check names the level-2 heading, and EXPECTED's '4. The new laws' covers §4.7. REASON is written to _process/architecture/rebinds.jsonl, not to a capped record field. T22's row explains only why the heading was kept. The replacement is right.

**Refuter's replacement.** study_rfm3.txt: "RF's plan (§4.7's paragraph on RF-M.3, §4.8, §5's and §8's rows, §12, §13 and Evidence)". repoint_rfm3.py REASON: "RF's plan (§4.7's paragraph on RF-M.3, §4.8, §5's and §8's rows, §12, §13's reviews and the Evidence list)". For the page to match, T23's 'Taken' quotation in evidence_rfm3_coldread.py names §4.7's paragraph too (or T22's row notes the lists), and the page is regenerated.

### What was taken from the check of how the lenses' findings were taken

| Gap | Id | Verdict | Finding | Taken |
|---|---|---|---|---|
| XC1 | X5 | real | the record's Chinese law on amounts forgone keeps “so both answers least”, which its English lacks | the Chinese law without （故二答皆最少）, so neither language states it, the English, at 418 of its 420 characters, having no room for it |
| XC2 | X7 | real | the Lean review's re-check row R5 puts the told criterion's cells in the bullet on amounts forgone | R5's last clause: “and the bullet on when the answer is least names the told criterion's cells, covering that listing”, the Lean review's page regenerated |
| XC3 | X8 | real | in part: the record's law on a demonstration still opens “Shown a world” | “Shown what a world shows, the listing is filtered to the worlds showing it” (zh 示一世界之所显，则其列滤为所显同者之诸世界), 413 and 100 of their 420 and 190 characters |
| XC4 | new | real | 03 §12's Reading, PLAN §4.8's Readings and its item 12 state the loss by the current valuation and the revised answer's lack of residual without the shared model | 03 §12: “evaluated by the current valuation on a shared model, a revision deciding a listed cell against its strict weighted preference counts as a loss”; PLAN §4.8's Readings: “by it, on a shared model, a revision deciding …”; its item 12: “With the reference the revised valuation and the reading formation's model the holding formation's, the revised answer has no residual through the same map”; the module's Readings (TC4); and the board's landing text: “and, on a shared model, by the reading formation's own current valuation no revaluation gains …” |
| XC5 | new | real | the X10 row says the English law on informing is at its cap; it is at 410 of 420 | the X10 row: “the English, at 410 of its 420 characters, having no room for it” |
| RC1 | R9 | real | in part: PLAN §5's row reads the incentive to revise without the supplied update's reach or costs | in one wording with the second re-check's point and TC3: “its laws read as an incentive, before costs, to revise under a reference the valuation does not share, only where the supplied update reaches a valuation whose answer stands above the current one by that reference, which is not asserted, and, by the reading formation's current valuation on a shared model, a reason to keep the valuation from a revision …” |
| RC2 | new | real | the overview's “such a valuation” has no antecedent, so binds to the reference | in the dossier's form: “under a reference it does not share, informing can lower the worth of holding and revaluing raise that worth, incentives, before costs, to withhold and, where the supplied update reaches such a valuation, to revise” |
| RC3 | new | real | the record's “(if the update reaches it)” binds to the reference | “under a reference unlike the valuation, incentives to withhold and to revise (if the update reaches a gaining valuation), before costs” (zh 若所予之更新可达有得之值), the room made by citing “Farquhar et al. 2022” as the field cites its other works: 1195 and 466 of 1200 and 500 characters |
| RC4 | new | real | the root bullet and the checker's scope state the routes' witness without “can” | “a route shown and a route presented can answer alike and end in one state” in the root bullet, the checker's scope (changed before the landing's core run, whose receipt records it) and the board's landing text |
| TC1 | T8 | real | in part: the study and the header claim the worth wherever two worlds alone are not told apart | the study: “and holding for the answer is worth one committed move where none tells the listed worlds apart (answer_constant) or none is emitted (undemonstrated_worth)”; the header: “and, wherever none is emitted or none tells the listed worlds apart, holding for the answer is worth one committed move”, the module rebuilt, 138 theorems in 186 declarations, every axiom report empty ([build-7](../kit/round2c/logs/build-7.log)) |
| TC2 | T17 | real | in part: the dossier's account omits RF-M.3's change to RF-M.2's last sentence, and “round 2's sentence” names none | “RF-M.3's sentences and its changes to the assistance-games clause, to round 2's first sentence and to RF-M.2's last sentence, made on …” |
| TC3 | new | real | PLAN §5's row reads the incentive to revise without reach or costs | as RC1 |
| TC4 | new | real | the loss by the current valuation without the shared model in 03 §12, PLAN §4.8's Readings and the module's Readings | as XC4, and the module's Readings: “by it, on a shared model, a revision that changes a decision against the current strict preference counts as a loss”, in TC1's rebuild |
| TC5 | new | real | the study's and the re-point's lists of the plan's places omit §4.7's paragraph on RF-M.3 | both: “RF's plan (§4.7's paragraph on RF-M.3, §4.8, …” |

## The third re-check

The cross-model reader, in the session of its cold read, read how its second re-check's point and the check's gaps were taken and, as new text, the passages they changed, read-only, in a rehearsal rebuilt at the same path on the kit at `539078292` with main at `485c6f87c`, the diff of the study folder since `22a113c0c` at its root. Verbatim.

My second re-check’s point and all 14 gaps are correctly taken; I found no new mismatch with the Lean, cited readings or Chinese texts.

Remaining findings: **none**.

Nothing was found, so nothing was taken.

## The check of the check's changes

Beside the third re-check, a workflow of two Opus readers, read-only in the same rehearsal: one checked the 12 points of the second re-check and the check against the tables of what was taken, the texts and the Lean, giving each id a status (taken, in part, not taken, or taken with a new problem) and reporting new problems where the same claim recurs; the other read the passages changed in that round cold, against the Lean and the cited works. Each reader's gaps were given to one refuter asked to refute them against the files. The prompts are in [the brief](BRIEF.md#round-2-third-part). Verbatim: each reader's summary, the ids it found taken, and each gap with its refuter's verdict, numbered by reader (FT for the first, FC for the second) in the order reported; the line numbers are those of the rehearsal.

### The reader of how they were taken

**Summary.** I checked all 15 reports (12 distinct points), read-only, in the rehearsal at /private/tmp/claude-501/-Users-ren-theories/50635de9-b91e-4f4c-a63c-8413ce8c4652/scratchpad/rfm3-rehearsal. For each one I checked the places it names and every other place the same claim recurs, using grep across the integrated texts, the kit templates and the module (both module copies are byte-identical). Each change was compared with the Lean, and each record field was counted by parsing make_records_rfm3.py with ast.

Results: 12 ids are taken as their rows say and are right against the Lean: 1, XC1, XC2, XC3, XC5, RC1, RC3, RC4, TC1, TC2, TC3 and TC5. No change made in this round introduced an error, and none states more than the Lean proves. Every record field changed in this round is within its cap: the law on amounts forgone is 418/420 and 102/190, the law on a demonstration 413/420 and 100/190, and the correspondence 1195/1200 and 466/500.

Three ids are taken only in part. Each time the places named are fixed, but the same claim recurs somewhere else unfixed.
- XC4: `outcome_least`'s docstring still uses the old wording of item 12, which it cites, so it states no model condition. The header bullet's `outcome_least` clause is the same (optional).
- TC4: PLAN §8's Everitt row and `revalued_lowers_iff`'s docstring still state the loss by the current valuation without the shared model.
- RC2: the record's correspondence still reads a flat 'incentives to withhold', which RC2's refuter judged wider than the Lean (`informed_answer_le` with an offset in net agreement). RC3 changed only the revise clause.

There is also one new low item: 03 §12's alike clause says 'none tells the listed worlds apart', where `inputs_alike` needs only the two worlds not to be told apart. After TC1, the header, the study and the record all state it of the two worlds.

The docstring fixes change no statement, but they need one more rebuild. That rebuild changes the record's source hash.

The X5, X8, R11, T17, T23 and T26 rows on the cold-read page still describe the earlier takes. The CHECK table records each later change, so the page's history stays consistent; I do not report them.

**Taken as the table says.** 1, XC1, XC2, XC3, XC5, RC1, RC3, RC4, TC1, TC2, TC3, TC5.

#### FT1: XC4 (in part)

**Location.** Taken in the places XC4 names: 03 §12's Reading and s12_rfm3.txt, PLAN §4.8's Readings and item 12, the module's Readings, and the board. Not taken in the module: outcome_least's docstring (ListingValuation.lean:1024-1025, both copies) and the header bullet 'Amounts forgone, and revaluing' (lines 91-92).

**Quoted.** /-- **By the valuation after a revaluation, its answer has no residual** (item 12): with the reference the revised valuation, the revised answer has none through the same map. -/ | header: "after a revaluation, the revised answer has no residual by the revised valuation (`outcome_least`)"

**Problem.** The docstring cites item 12 but keeps the old wording of item 12 that XC4 corrected, so it states no model condition. The Lean is `theorem outcome_least (m : Model C) (g' l' : C → Nat) (π : C → K) (zs : List K) : residual m g' l' π zs (answer m g' l' π) = 0`. One `m` both evaluates (residual) and forms the answer. With the models apart the claim fails: WeightsApart.weights_split has residual 1 with the valuation equal to the reference. In the header bullet the clause comes after a semicolon, beyond the shared-model opening, and its reference has changed. 03 §12 and the study repeat 'with that shared model' at this clause (X3); the header does not. PLAN §13 says the model is stated 'wherever the evaluation by its own current valuation is stated, `outcome_least` included'. Both changes are prose only and no statement changes, but both module copies change and the module needs one more rebuild, which also changes the record's source hash.

**Replacement.** outcome_least's docstring, both copies: "/-- **By the valuation after a revaluation, its answer has no residual** (item 12): with the reference the revised valuation and the reading formation's model the holding formation's, the revised answer has none through the same map. -/". Header bullet, rewrapped (optional, for consistency with 03 §12 and the study): "…(`revalued_lowers_iff`); after a revaluation, with that shared model, the revised answer has no residual by the revised valuation (`outcome_least`), which endorses no revaluation, …". Then rebuild, and record the change in XC4's CHECK row.

**Verdict: real.** The case holds on the files.

**The docstring.** outcome_least's docstring reads "with the reference the revised valuation, the revised answer has none through the same map". That is item 12's wording before XC4. PLAN item 12 (:215) now reads "With the reference the revised valuation and the reading formation's model the holding formation's".

**The Lean.** `theorem outcome_least (m : Model C) (g' l' : C → Nat) (π : C → K) (zs : List K) : residual m g' l' π zs (answer m g' l' π) = 0`. One m forms the answer and also measures its residual. With the models apart the claim fails: `WeightsApart.weights_split` has `residual holding gain loss (fun c : Nat => decide (c = 2)) [false, true] (answer reading gain loss (fun c : Nat => decide (c = 2))) = 1`, with the valuation equal to the reference.

**Why the docstring cannot rely on the statement below it.** X4 rejected that defence for the record's law, which cites the theorem. Every other docstring of a one-model law in the module states the shared model: own_least, answer_shortfall_least, revaluing_gain, revaluing_gains_iff, informed_answer_le, forgone_least_iff, coarser_not_above and shown_never_lowers. residual_pos_of_gains says "for any model". This docstring names a reference of its own, different from own_least's, so nothing from own_least's docstring carries into it.

**The header bullet.** It has the structure X3 judged to give outcome_least no model condition in 03 and the study: the model is named in the opening, then comes a semicolon, then a clause with a new reference. X3 added "with that shared model" only "in both", meaning 03 and the study.

**Nothing in the tables decides otherwise.** X3's "as the header … say" refers to the opening phrase. XC4's row lists only the places it changed. The cross-model reader's "none in the module header and docstrings" is a report, not a stated reason. PLAN §13's "`outcome_least` included" is untrue while these two passages stand.

**Status.** "In part" is fair: XC4 was taken where it pointed, and this is the same claim in places it missed.

**The replacement.** It is right and uses item 12's own words. Two corrections:
- The header change is needed, not optional: it is X3's correction applied to the same structure.
- A further rebuild makes some existing sentences incomplete. The page's opening says only the carrier bullet and the Readings were revised again, at build-7. PLAN §13 and the study say only "the header was revised again".

**Refuter's replacement.** **outcome_least's docstring**, both copies (the kit's tree and the package's), the reader's text:
"/-- **By the valuation after a revaluation, its answer has no residual** (item 12): with the reference the revised valuation and the reading formation's model the holding formation's, the revised answer has none through the same map. -/"

**The header bullet 'Amounts forgone, and revaluing'**, both copies, rewrapped. This change is needed, not optional:
"…(`revalued_lowers_iff`); after a revaluation, with that shared model, the revised answer has no residual by the revised valuation (`outcome_least`), which endorses no revaluation, …"

**Rebuild once.** No statement changes; the counts should stay 138 theorems in 186 declarations, every axiom report empty.

**Record the change in four places:**
1. XC4's CHECK row.
2. BUILD_SENTENCE in evidence_rfm3_coldread.py. Its second sentence becomes: "For the check of how they were taken, the header's bullets on the carrier and on amounts forgone and revaluing, its Readings and the docstring of `outcome_least` were revised, and it was rebuilt, the same counts, every axiom report empty ([build-8](../kit/round2c/logs/build-8.log))."
3. PLAN §13's last sentence: "The header and the docstring of `outcome_least` were revised and the module rebuilt again, the same counts."
4. The study's paragraph on the cold read: "the header and the docstring of `outcome_least` were revised and the module rebuilt again, the same counts".

Then regenerate the page.

#### FT2: RC2 (in part)

**Location.** Taken in the overview (THE-THEORY-OF-BECOMING.md:102 and its source string in integrate_rfm3.py:193). Not taken in the record's correspondence, kit/round2c/make_records_rfm3.py:466 (en) and :472 (zh), record a-reading-informed-and-revalued.

**Quoted.** AI reading: under a reference unlike the valuation, incentives to withhold and to revise (if the update reaches a gaining valuation), before costs; / AI 解读：参照与值相异时，读为扣告与改（若所予之更新可达有得之值）之诱因，未计其费；

**Problem.** RC2's refuter judged the flat 'incentives … to withhold' wider than the Lean. That form recurs in the record's correspondence, the only other place the incentive to withhold is read; RC3 changed only the revise clause. Informing.informing_lowers is a witness: informing can lower the worth. informed_answer_le gives the converse wherever the model is shared and the valuation agrees in net: `(net : ∀ c, c ∈ m.listed → 0 < m.weight c → g c + loss c = l c + gain c) … : m.after (shifted gain loss) (byRule fun c => s (π c)) ≤ m.after (shifted gain loss) (byRule fun c => answer m g l π' (π' c))`. A reference unlike the valuation satisfies this with a common offset (g = gain + 1, l = loss + 1), and there no incentive to withhold exists. The overview and the dossier say 'informing can lower the worth of holding'. 03 §12, PLAN §4.8 and the module read the incentives from 'can be worth more'. The English field is at 1195/1200, so the qualifier needs room. The room comes from dropping 'represented' after 'no optimal signal or equilibrium', the bare form PLAN §8's Blackwell row already uses.

**Replacement.** English: replace "no optimal signal or equilibrium represented. AI reading: under a reference unlike the valuation, incentives to withhold and to revise (if the update reaches a gaining valuation), before costs;" with "no optimal signal or equilibrium. AI reading: under a reference unlike the valuation, possible incentives to withhold and to revise (if the update reaches a gaining valuation), before costs;" (field 1192 of 1200). Chinese: replace "读为扣告与改（若所予之更新可达有得之值）之诱因" with "读为扣告与改（若所予之更新可达有得之值）之或有之诱因" (field 469 of 500). Record the change in the CHECK table.

**Verdict: real.** The case holds on the files.

**The text.** The correspondence reads "AI reading: under a reference unlike the valuation, incentives to withhold and to revise (if the update reaches a gaining valuation), before costs" (zh 参照与值相异时，读为扣告与改（若所予之更新可达有得之值）之诱因).

**The precedent.** RC2's refuter found this same flat withhold clause wider than the Lean in the overview: it drops the "can" of the witness Informing.informing_lowers.

**The Lean.** `informed_answer_le … (net : ∀ c, c ∈ m.listed → 0 < m.weight c → g c + loss c = l c + gain c) … : m.after (shifted gain loss) (byRule fun c => s (π c)) ≤ m.after (shifted gain loss) (byRule fun c => answer m g l π' (π' c))`. A valuation unlike the reference by a common offset (g = gain + 1, l = loss + 1) satisfies `net`. There withholding never gains before costs, so no incentive to withhold exists.

**Nothing in the tables decides otherwise.** RC2's row changed the overview only. RC3's row rewrote the reference phrase and the revise clause and gives only room as a reason; it says nothing about the withhold clause.

**The other places.** Every other reading of withholding goes through "can". 03 §12, PLAN §4.8 and the module say "can be worth more … read as incentives". The overview and the dossier say "informing can lower the worth of holding".

**Two small inexactnesses in the reader's case**, neither affecting the gap:
- "The only other place" holds only for the flat form; the places above also read the incentive to withhold, through "can".
- RC3 changed the reference phrase as well as the revise clause, not only the revise clause.

**Caps.** Measured by parsing the script with ast, not running it (style.py counts characters with len). English goes from 1195 to 1192 of 1200; Chinese from 466 to 469 of 500. Each old string occurs once, inside a single literal.

**The replacement is right.** "Possible" carries the "can". The bare "no optimal signal or equilibrium" is the form PLAN §8's Blackwell row uses. The Chinese keeps 最优之信号与均衡未表, which means the same.

**Refuter's replacement.** The reader's text, as given.

**English (:466).** Replace "no optimal signal or equilibrium represented. AI reading: under a reference unlike the valuation, incentives to withhold and to revise (if the update reaches a gaining valuation), before costs;" with "no optimal signal or equilibrium. AI reading: under a reference unlike the valuation, possible incentives to withhold and to revise (if the update reaches a gaining valuation), before costs;". The field becomes 1192 of 1200.

**Chinese (:472).** Replace "读为扣告与改（若所予之更新可达有得之值）之诱因" with "读为扣告与改（若所予之更新可达有得之值）之或有之诱因". The field becomes 469 of 500.

**The CHECK table.**
- In RC2's row, add the record's "possible incentives" (zh 或有之诱因).
- In RC3's row, change the counts to 1192 and 469, with the room made by dropping "represented".

Then regenerate the page.

#### FT3: TC4 (in part)

**Location.** Taken in the places TC4 names: 03 §12's Reading, PLAN §4.8's Readings and the module's Readings (ListingValuation.lean:235). Not taken: PLAN.md:293 (§8, the row on reward tampering and current-reward-function evaluation, standing cell) and revalued_lowers_iff's docstring (ListingValuation.lean:1010-1011, both copies).

**Quoted.** PLAN.md:293: "a one-decision counterpart in counts of the preservation incentive their Claim 2 permits, a reading; their diagrams, several steps and the reward input not represented; no path-specific objective constructed" | "/-- **A revaluation lowers it exactly where it decides some listed cell against the current valuation's strict weighted preference.** -/"

**Problem.** Both places state the loss by the current valuation, and its preservation-incentive reading, without the shared model. The corrigibility row just above (:291, from the first re-check), 08 §8, the record's correspondence, the dossier and the study all state the same counterpart on a shared model. The docstring is only a title, whose 'it' and model come from own_least's docstring. Lean: `theorem revalued_lowers_iff (m : Model C) (g l g' l' : C → Nat) (π : C → K) {zs : List K} (once : List.Pairwise (fun a b => a ≠ b) zs) (covers : ∀ c, c ∈ m.listed → π c ∈ zs) : m.after (shifted g l) (byRule fun c => answer m g' l' π (π c)) < m.after (shifted g l) (byRule fun c => answer m g l π (π c)) ↔ ∃ z, z ∈ zs ∧ (…)`. One `m` serves the evaluation and both answers. With the models apart, the current answer can carry a residual (WeightsApart.weights_split), so a revision against its strict preference need not lose.

**Replacement.** PLAN.md:293, standing cell: "a one-decision counterpart in counts, on a shared model, of the preservation incentive their Claim 2 permits, a reading; their diagrams, several steps and the reward input not represented; no path-specific objective constructed". revalued_lowers_iff's docstring, both copies, in the same rebuild as XC4: "/-- **A revaluation lowers it exactly where it decides some listed cell against the current valuation's strict weighted preference**: with the reference the reading formation's own current valuation and its model the holding formation's, holding for another valuation's answer through `π` stands strictly below holding for the current answer exactly there. -/"

**Verdict: real.** Real for PLAN.md:293. The docstring part does not hold.

**The plan's row.** Its standing cell reads "a one-decision counterpart in counts of the preservation incentive their Claim 2 permits, a reading", with no model condition. Strictly, the row states the incentive's reading, not the loss itself. The counterpart is own_least with revalued_lowers_iff, each on one model: `revalued_lowers_iff (m : Model C) (g l g' l' : C → Nat) … : m.after (shifted g l) (byRule fun c => answer m g' l' π (π c)) < m.after (shifted g l) (byRule fun c => answer m g l π (π c)) ↔ ∃ z, z ∈ zs ∧ (…)`.

**With the models apart there is no preservation incentive.** Take WeightsApart through decide (c = 2), with the valuation equal to the reference. The reading formation's answer stops the first cell and has residual 1 (weights_split); holding for it is worth 2. A revision that releases both cells has residual 0 and is worth 3 (weights_matter). So by the current valuation that revision gains.

**Every other statement of this counterpart carries the shared model.**
- 08 §8, the study's Read, the record's correspondence and the dossier state it next to the counterpart.
- 03 §12 ("This"), PLAN §4.8 ("11") and the module (the named theorems) carry it through what they hang on, as TC4's own verdict says.
- In §8 itself, the Blackwell row ("with a shared model") and the corrigibility row (:291) have it. The first re-check's point 1 required it at :291, although that row too points to RF-M.3.

**Nothing in the tables decides otherwise.** The first re-check's row lists the places given the model and gives no reason for leaving :293 out. R1's verdict looked at :293 only for Claim 2's attribution.

**Why the docstring part does not hold.** revalued_lowers_iff's docstring is a title that continues own_least's docstring, which says "with the reference the reading formation's own current valuation and its model the holding formation's". The title's "it" and "the current valuation" carry that context, as the reader concedes, and nothing in between changes it. Unlike outcome_least's docstring, it states no condition of its own. TC4's verdict holds that sentences hanging on the shared-model statement or on named theorems need no change.

**Refuter's replacement.** **PLAN.md:293, the standing cell:** "a one-decision counterpart in counts, on a shared model, of the preservation incentive their Claim 2 permits, a reading; their diagrams, several steps and the reward input not represented; no path-specific objective constructed". Record it in TC4's CHECK row.

**revalued_lowers_iff's docstring:** no change needed. If it is made self-contained anyway, the reader's wording is right. It then goes into XC4's single rebuild, and XC4's sentences on what was revised name both docstrings ("the docstrings of `revalued_lowers_iff` and `outcome_least`").

#### FT4: a new problem

**Location.** theories/becoming/chapters/03-KNOWING.md:517 (§12, theorem paragraph) and kit/round2c/s12_rfm3.txt line 2

**Quoted.** Where the acts taken give two worlds one input, from one state of each formation the courses are alike, so they are alike wherever no demonstration is emitted or none tells the listed worlds apart, and there holding for the answer is worth one committed move

**Problem.** Low severity; the wording comes from T8. The alike clause is stated over the listed worlds, but inputs_alike needs only the two worlds not to be told apart, listed or not: `{w w' : W} (same : rd.reveal w = rd.reveal w') (n : Nat) : ((joint rd hd).course ⟨i, s, a, (w, h)⟩ n).internal = ((joint rd hd).course ⟨i, s, a, (w', h)⟩ n).internal ∧ …`. The listed worlds are the condition of answer_constant (`(shows : ∀ w, w ∈ m.listed → rd.reveal w = o)`), which governs the worth. So 03's alike clause is narrower than the law where the two worlds are listed, and it does not follow where they are not. After TC1, the header ('none tells the worlds apart'), the study ('tells them apart') and the record ('tells the worlds apart') all state the alike clause of the two worlds and the worth of the listed worlds. Only 03 uses the listed worlds in both clauses.

**Replacement.** so they are alike wherever no demonstration is emitted or none tells the two worlds apart, and, wherever none is emitted or none tells the listed worlds apart, holding for the answer is worth one committed move (`ListingValuation.inputs_alike_before`, `ListingValuation.undemonstrated_worth`, `ListingValuation.answer_constant`)

**Verdict: real.** The case holds on the files; low severity.

**The text.** Both copies read "so they are alike wherever no demonstration is emitted or none tells the listed worlds apart, and there holding for the answer is worth one committed move".

**The Lean.** `inputs_alike … {w w' : W} (same : rd.reveal w = rd.reveal w') (n : Nat) : ((joint rd hd).course ⟨i, s, a, (w, h)⟩ n).internal = ((joint rd hd).course ⟨i, s, a, (w', h)⟩ n).internal ∧ …` asks only that the two worlds show alike. The listed worlds enter only through answer_constant's `(shows : ∀ w, w ∈ m.listed → rd.reveal w = o)`, which governs the worth.

**What follows for 03's alike clause.**
- For two listed worlds, 03's condition is stronger than the law needs, so the clause is narrower than proved.
- For worlds not listed, it does not give the courses alike. `Reader.input w .demonstrate = .shown (rd.reveal w)`, so once a demonstration is emitted, two unlisted worlds showing different values sense different inputs, even if every listed world shows one value.

**The other places.** After TC1, the header (:124-128), the study (:99-103), the record's law and PLAN item 19 state the alike clause of the two worlds and the worth of the listed worlds. 03 alone uses the listed worlds in both clauses.

**Nothing in the tables decides otherwise.** The wording came from T8's replacement, which put answer_constant's case into the alike clause. TC1's verdict calls 03 narrowed for the worth claim and says nothing of its alike clause.

**The replacement is right.** It takes the header's split, with "the two worlds" binding to the sentence's opening. The cited inputs_alike_before gives both alike cases. No cap applies.

**Refuter's replacement.** In 03-KNOWING.md:517 and kit/round2c/s12_rfm3.txt line 2, use the reader's text:
"so they are alike wherever no demonstration is emitted or none tells the two worlds apart, and, wherever none is emitted or none tells the listed worlds apart, holding for the answer is worth one committed move (`ListingValuation.inputs_alike_before`, `ListingValuation.undemonstrated_worth`, `ListingValuation.answer_constant`)"

It replaces "so they are alike wherever no demonstration is emitted or none tells the listed worlds apart, and there holding for the answer is worth one committed move (…)". Record it with this round's points, since T8's row quotes the wording it replaces.

### The cold reader

**Summary.** Every fix from the last round is applied and exact, and every count and cap holds. Seven items below cover four low-severity problems. (1) The worth claim of answer_constant says "the listed worlds" without saying whose listing. Its hypothesis is on the holding formation's listing, but in the same passages "the listing" means the reading formation's, and read that way the claim is false (a two-world counterexample on joint). This appears in the record's law (en and zh), 03 §12 with its kit source, the module header's carrier bullet and its Readings, the study's carrier bullet, and the summaries in PLAN §13 and the study. (2) The record's correspondence states incentives to withhold under any reference unlike the valuation. The Lean gives only a witness, plus two sufficient conditions under which informing never lowers the worth. Every other place keeps the "can". (3) The lead of the dossier's RF bullet still gives 29 and 30 October, though the bullet now records changes made on 31 October. (4) The cold-read page says the lens table shows what each finding became, but six of its rows predate the changes made by the check. Every replacement fits its cap.

#### FC1: a new problem

**Location.** kit/round2c/make_records_rfm3.py, record a-reading-informed-and-revalued, the courses-alike law (en and zh); the record page in the rehearsal

**Quoted.** en: "so holding for the answer, at listed worlds all showing one value or with no demonstration emitted, is worth one committed move." zh: "故于所示皆同之列世界，或未发示时，为答而持值一所守之行。"

**Problem.** The hypothesis of the worth is on the holding formation's listing, the model the worth is counted on: `theorem answer_constant … (m : Model W) (gain loss : W → Nat) {o : O} (shows : ∀ w, w ∈ m.listed → rd.reveal w = o) (w₀ : W) (shows₀ : rd.reveal w₀ = o) (n : Nat) : m.after (shifted gain loss) (byRule fun w => ((joint rd hd).course ⟨i, s, a, (w, h)⟩ n).active) = m.committed (shifted gain loss) (cond ((joint rd hd).course ⟨i, s, a, (w₀, h)⟩ n).active .off .go)` (docstring: "every world the holding formation lists"). Two laws earlier, "the listing" is the reading formation's ("the listing is filtered to the worlds showing it"), so "listed worlds" reads as the reading formation's, and on that reading the law is false. Counterexample on `joint`: the reading listing is [a], with weight 1 and a valuation giving going on 0 and switching off 1 at a; reveal a ≠ reveal b. The holding model lists a and b at weight 1, with reference gain a = 0, loss a = 1, gain b = 1, loss b = 0. The holding formation demonstrates at step 0 and holds after. At step 2 the answer stops at a (listing [a], 0 < 1) and releases at b (listing empty, a tie). So holding for it is worth 1 + 1 = 2, against 1 for switching off and 1 for going on, yet the reading formation lists one world and nothing shown tells its listed worlds apart.

**Replacement.** en: "so holding for the answer, where the worlds the holding formation lists all show one value or no demonstration is emitted, is worth one committed move." (the law 360 of 420 characters). zh: "故于持之形成所列之诸世界所示皆同处，或未发示时，为答而持值一所守之行。" (the law 86 of 190)

**Verdict: real.** The law does not say which formation's listing its 'listed worlds' are. The record's carrier laws make 'the listing' the reading formation's: 'internal, the reading formation's listing and valuation state', and the law just before this one (one law earlier, not two) says 'the listing is filtered to the worlds showing it'. The Lean instead puts the hypothesis on the model the worth is counted on: `theorem answer_constant … (m : Model W) (gain loss : W → Nat) {o : O} (shows : ∀ w, w ∈ m.listed → rd.reveal w = o) (w₀ : W) (shows₀ : rd.reveal w₀ = o) (n : Nat) : m.after (shifted gain loss) (byRule fun w => ((joint rd hd).course ⟨i, s, a, (w, h)⟩ n).active) = m.committed (shifted gain loss) (cond ((joint rd hd).course ⟨i, s, a, (w₀, h)⟩ n).active .off .go)`. Its docstring says 'every world the holding formation lists'. The reading formation's listing `i.1` is left unconstrained. The counterexample holds on the definitions. `Reader.update` filters `[a]` by `reveal c = reveal w`, which leaves `[a]` at a and `[]` at b. `answer` is `decide (within pm π g z < within pm π l z)`, so at step 2 it stops at a (0 < 1) and releases at b (0 < 0 is false). `shifted` values going on at the gain and switching off at the loss, so `m.after` = loss a + gain b = 2, while `committed .off` = 1 and `committed .go` = 1. So if 'listed worlds' means the reading formation's listing ([a]: one world, nothing to tell apart), the law is false. No table settles whose listing is meant: TC1 narrowed the claim from two worlds to 'listed worlds' without saying whose. The replacement is right. It states `shows` as the docstring does and keeps undemonstrated_worth's case. Counted by parsing the script with ast, it is 360 of 420 characters in English and 86 of 190 in Chinese, and 持之形成 and 列 are the record's own terms.

#### FC2: a new problem

**Location.** theories/becoming/chapters/03-KNOWING.md §12, the theorem paragraph on informing and revaluing (the carrier part), from kit/round2c/s12_rfm3.txt

**Quoted.** "so they are alike wherever no demonstration is emitted or none tells the listed worlds apart, and there holding for the answer is worth one committed move"

**Problem.** This is the same scope gap. The sentence just before reads "a demonstration filters the listing by what it shows", and that listing is the reading formation's (the internal part). So "the listed worlds" binds to it, while answer_constant needs `(shows : ∀ w, w ∈ m.listed → rd.reveal w = o)` on the holding formation's model. The two-world counterexample in the record's item fails the claim on that reading. The alike half holds for any worlds and is unaffected.

**Replacement.** "so they are alike wherever no demonstration is emitted or none tells apart the worlds the holding formation lists, and there holding for the answer is worth one committed move" (in s12_rfm3.txt, and so in 03 §12)

**Verdict: real.** The sentence's 'the listed worlds' comes after the carrier sentence, two sentences back, where the internal part is 'the reading formation's listing and valuation' and 'a demonstration filters the listing by what it shows'. So it can bind to the reading formation's listing, while `answer_constant` needs `(shows : ∀ w, w ∈ m.listed → rd.reveal w = o)` on the model the worth is counted on. The record item's counterexample makes the worth claim false on the first reading, and no table decided otherwise. The reader's replacement fixes the worth half but keeps 03's structure for the alike half. That half then says the courses at the sentence's 'two worlds' are alike wherever none tells apart the worlds the holding formation lists. This follows only if the two worlds are among those listed, which the sentence does not say: `inputs_alike` takes `(same : rd.reveal w = rd.reveal w')` for the two worlds themselves. Naming the listing makes this gap plain. The reader's 'the alike half holds for any worlds' is true of the Lean, not of this wording. The record's law, the header's bullet and the study all state the alike half on the two worlds and the worth on the listed worlds. Giving 03 the same split makes both halves exact and matches those three places. There is no cap.

**Refuter's replacement.** In s12_rfm3.txt, and so in 03 §12: "so they are alike wherever no demonstration is emitted or none tells the two worlds apart, and, wherever none is emitted or none tells apart the worlds the holding formation lists, holding for the answer is worth one committed move" (the citations after it unchanged)

#### FC3: a new problem

**Location.** Becoming/ListingValuation.lean module header, both copies (kit/round2c/tree and the package): the carrier bullet, and the Readings paragraph on the off-switch game

**Quoted.** Carrier bullet: "and, wherever none is emitted or none tells the listed worlds apart, holding for the answer is worth one committed move (`undemonstrated_worth`, `answer_constant`)." Readings: "`answer_constant` takes one state of each formation at every world, nothing shown telling the listed worlds apart,"

**Problem.** The bullet itself defines the internal part as "the reading formation's listing and valuation state" and says "A demonstration filters the listing by what it shows", so "the listed worlds" reads as the reading formation's listing. The theorem's statement and docstring are on the holding formation's: `(shows : ∀ w, w ∈ m.listed → rd.reveal w = o)`, "where every world the holding formation lists shows what a world `w₀` shows". Read the first way, both sentences are false (counterexample in the record's item).

**Replacement.** Carrier bullet: "and, wherever none is emitted or none tells apart the worlds the holding formation lists, holding for the answer is worth one committed move (`undemonstrated_worth`, `answer_constant`)." Readings: "`answer_constant` takes one state of each formation at every world, nothing shown telling apart the worlds the holding formation lists," (docstrings only, in both copies; the module rebuilt as for TC1)

**Verdict: real.** The two copies are identical (checked with cmp). The carrier bullet defines the internal part as 'the reading formation's listing and valuation state' and says 'A demonstration filters the listing by what it shows', so 'the listed worlds' can bind to that listing. In the Readings, the phrase comes right after 'here the reading formation senses the candidate world only through what is shown'. `answer_constant`'s hypothesis is `(shows : ∀ w, w ∈ m.listed → rd.reveal w = o)` on the worth's model, and its docstring says 'where every world the holding formation lists shows what a world `w₀` shows'. On the first reading both sentences are false, by the record item's counterexample. The reader's replacements are exact and match the docstring. They change docstrings only and need a rebuild as TC1 did; the pages that name build-7 for the check then name the new build. They are incomplete in one place. The Lean review's re-check row R2 (kit/round2c/evidence_rfm3_lean.py, RECHECK 'R2') quotes the Readings' 'nothing shown telling the listed worlds apart'. X17 established that that page's rows follow the texts as they stand, and XC2 updated R5 the same way, so R2 changes with the Readings.

**Refuter's replacement.** Carrier bullet: "and, wherever none is emitted or none tells apart the worlds the holding formation lists, holding for the answer is worth one committed move (`undemonstrated_worth`, `answer_constant`)." Readings: "`answer_constant` takes one state of each formation at every world, nothing shown telling apart the worlds the holding formation lists," (docstrings only, in both copies; the module rebuilt as for TC1, the pages naming build-7 for the check then naming the new build). And in evidence_rfm3_lean.py's RECHECK row R2, "nothing shown telling the listed worlds apart" becomes "nothing shown telling apart the worlds the holding formation lists", REVIEW-RFM3-LEAN.md regenerated.

#### FC4: a new problem

**Location.** kit/round2c/study_rfm3.txt, the carrier bullet and the paragraph "The cold read of the texts"; PLAN.md §13, the paragraph "The cold read of the third part's texts"

**Quoted.** Study carrier bullet: "and holding for the answer is worth one committed move where none tells the listed worlds apart (answer_constant) or none is emitted (undemonstrated_worth)." Both summaries: "the worth of an answer alike stated only where no demonstration tells the listed worlds apart or none is emitted"

**Problem.** This is the same scope gap. The study's carrier bullet follows its account of the reading formation's listing being filtered, and answer_constant's hypothesis is `∀ w, w ∈ m.listed → rd.reveal w = o` on the holding formation's model. The two summaries repeat the wording and should follow the fixed texts.

**Replacement.** Study carrier bullet: "and holding for the answer is worth one committed move where none tells apart the worlds the holding formation lists (answer_constant) or none is emitted (undemonstrated_worth)." PLAN §13 and the study's paragraph: "the worth of an answer alike stated only where no demonstration tells apart the worlds the holding formation lists or none is emitted"

**Verdict: real.** The study's carrier bullet calls the reading formation's update 'filtering the listing by what a demonstration shows' and the internal part 'the listing and valuation'. Its 'where none tells the listed worlds apart (answer_constant)' therefore has the same gap against `(shows : ∀ w, w ∈ m.listed → rd.reveal w = o)`, and the record item's counterexample applies. The two summaries (study line 189, PLAN §13) repeat the words and should follow the fixed texts. The replacements are right. The study's keeps TC1's split: alike for the two worlds, worth for the listed ones. None of these texts has a cap.

#### FC5: a new problem

**Location.** kit/round2c/make_records_rfm3.py, record a-reading-informed-and-revalued, correspondence (en and zh)

**Quoted.** en: "AI reading: under a reference unlike the valuation, incentives to withhold and to revise (if the update reaches a gaining valuation), before costs;" zh: "AI 解读：参照与值相异时，读为扣告与改（若所予之更新可达有得之值）之诱因，未计其费；"

**Problem.** The reading of revising carries its condition, but withholding is read as an incentive under every reference unlike the valuation. The Lean gives only a witness (`Informing.informing_lowers`: told nothing, worth 10; told the candidate, worth 0). It also gives two cases where the valuation is unlike the reference and informing never lowers the worth. First, `informed_answer_le … (net : ∀ c, c ∈ m.listed → 0 < m.weight c → g c + loss c = l c + gain c) … : m.after (shifted gain loss) (byRule fun c => s (π c)) ≤ m.after (shifted gain loss) (byRule fun c => answer m g l π' (π' c))`; net agreement admits g = gain + k, l = loss + k. Second, `splitsKeep_of_off_le_go (m pm : Model C) (gain loss g l : C → Nat) (never : ∀ c, c ∈ pm.listed → l c ≤ g c) : SplitsKeep m pm gain loss g l`, "whatever the reference". The overview, the dossier and 03 §12 keep the modality ("informing can lower the worth"); the record is the one place that drops it.

**Replacement.** en: "AI reading: under a reference unlike the valuation, possible incentives to withhold and to revise (if the update reaches a gaining valuation), before costs;" To keep the field within its cap, also write "of Bayesian persuasion's convexity condition for full disclosure (Kamenica and Gentzkow 2011)" in place of "of the convexity condition for full disclosure in Bayesian persuasion (Kamenica and Gentzkow 2011)" earlier in the same field: 1199 of 1200 characters. zh: "AI 解读：参照与值相异时，读为扣告与改（若所予之更新可达有得之值）之或有诱因，未计其费；" (468 of 500)

**Verdict: real.** The record's reading of withholding is unconditional: 'under a reference unlike the valuation, incentives to withhold'. The Lean gives only a witness: `Informing.informing_lowers` (told nothing, worth 10; told the candidate, worth 0), whose docstring says 'informing can lower the worth below both moves'. It also has two cases where the valuation is unlike the reference and informing never lowers the worth. One is `informed_answer_le … (net : ∀ c, c ∈ m.listed → 0 < m.weight c → g c + loss c = l c + gain c) … : m.after (shifted gain loss) (byRule fun c => s (π c)) ≤ m.after (shifted gain loss) (byRule fun c => answer m g l π' (π' c))`, which g = gain + k, l = loss + k satisfies. The other is `splitsKeep_of_off_le_go (m pm : Model C) (gain loss g l : C → Nat) (never : ∀ c, c ∈ pm.listed → l c ≤ g c) : SplitsKeep m pm gain loss g l`, 'whatever the reference', which with `refining_never_lowers_iff` keeps every refinement on both listings from lowering the worth. Every other place that reads the incentive keeps the modality: the overview and the dossier ('informing can lower the worth'), and 03 §12, the module's Readings and PLAN §4.8 ('can be worth more'). RC2 judged the same flat wording real in the overview. RC3 changed only the record's 'it', so no table gives a reason to keep it. The replacement is right. 'Possible' gives withholding the 'can' of the other places, and it does no harm to revising, which keeps its condition. The reworded Kamenica and Gentzkow phrase means the same. Counted by parsing the script, the English field comes to 1199 of 1200 characters (1204 without the shortening) and the Chinese to 468 of 500.

**Refuter's replacement.** en: "AI reading: under a reference unlike the valuation, possible incentives to withhold and to revise (if the update reaches a gaining valuation), before costs;" and, earlier in the same field, "of Bayesian persuasion's convexity condition for full disclosure (Kamenica and Gentzkow 2011)" in place of "of the convexity condition for full disclosure in Bayesian persuasion (Kamenica and Gentzkow 2011)": 1199 of 1200 characters. zh: "AI 解读：参照与值相异时，读为扣告与改（若所予之更新可达有得之值）之或有诱因，未计其费；" (468 of 500)

#### FC6: a new problem

**Location.** theories/becoming/review/ALIGNMENT.md, the account of how it was made, the lead of the RF bullet (the bullet is written by kit/round2c/integrate_rfm3.py's dossier edit)

**Quoted.** "- Added on 29 and 30 October 2026 (board item RF, formations that read):"

**Problem.** The same bullet now ends "RF-M.3's sentences and its changes to the assistance-games clause, to round 2's first sentence and to RF-M.2's last sentence, made on 31 October 2026". Those sentences and changes sit in the paragraph and the clause the lead lists, so the lead's dates no longer cover what the bullet records. RF7's landing (75be744fb) extended this lead to 30 October when it added that day's text.

**Replacement.** "- Added on 29, 30 and 31 October 2026 (board item RF, formations that read):", written by integrate_rfm3.py's dossier edit with its last date taken from TODAY, as the RF-M.3 sentence's "made on" date is (on a later day: "29 and 30 October and {TODAY.day} {TODAY:%B} 2026")

**Verdict: real.** The lead says 'Added on 29 and 30 October 2026' and lists 'the paragraph on RF's rounds in the box above' and the box's assistance-games clause. RF-M.3's sentences go into that paragraph and its changes into that clause (integrate_rfm3.py's dossier edits 1 to 3). The same bullet's last sentence dates them 'made on 31 October 2026', so the lead's dates no longer cover what the bullet records; RF-M.2's 30 October sentences fell inside the range. One detail of the reader's history is off. 75be744fb did not extend the lead; it created the bullet with '29 and 30' (git log -S finds no earlier RF lead). That still bears out the convention that the lead spans the dates of RF's text. T17's problem named the lead's dating, but its take changed only the RF-M.3 sentence and gave no reason for keeping the lead. Nothing quotes the lead (checked with grep). The replacement is right, and taking its last date from TODAY keeps it in step with the 'made on' date.

#### FC7: a new problem

**Location.** evidence/REVIEW-RFM3-COLDREAD.md, the opening's second paragraph (kit/round2c/evidence_rfm3_coldread.py, line 442)

**Quoted.** "The lenses reported 64 findings, 54 confirmed and 10 refuted by their refuters; what each became is in the table (`#what-was-taken-from-the-lenses`)."

**Problem.** That table shows the lenses' findings as taken before the check of how they were taken, and the check changed six of them since: X5 (its zh "共模型且净相合（故二答皆最少）" now reads "共模型且净相合，则最少所缺与其量定之"); R9 (the record's "(if the update reaches it)" is now "(if the update reaches a gaining valuation)", RC3); R11 (03 §12's sentence now says "on a shared model"); T17 (now "to the assistance-games clause, to round 2's first sentence and to RF-M.2's last sentence"); T23 (the Output → input now names §4.7); T26 (PLAN §5's row is now in RC1's wording). So what each finding became is not in that table alone.

**Replacement.** Line 442: `+ "; what each became is in the table (`#what-was-taken-from-the-lenses`), and what the check of how they were taken changed since in its table (`#what-was-taken-from-the-check-of-how-the-lenses-findings-were-taken`).")`, and the page regenerated by the script

**Verdict: real.** The opening says 'what each became is in the table (`#what-was-taken-from-the-lenses`)', but six rows of that table now quote words the check replaced. X5's zh （故二答皆最少） is gone (XC1). R9's '(if the update reaches it)' is replaced (RC3). R11's sentence now has 'on a shared model' (XC4, TC4). T17's 'and round 2's sentence' is replaced (TC2). T23's list now names §4.7 (TC5). T26's §5 row is replaced (RC1, TC3). The check also extended X8 (XC3) and T8 (TC1). The refuters offered either editing those rows or recording the changes in the later table. The kit recorded them in the later table and edited only X10's row in place (XC5), so the outcome of these findings is no longer in the lenses table alone. The opening's third paragraph links the check, but not as the place where these outcomes now stand. The replacement is right. The anchor matches github_slug of the heading ('what-was-taken-from-the-check-of-how-the-lenses-findings-were-taken'), and RECHECK_SENTENCE already links the check unconditionally. One addition: taking this round's gaps changes the outcomes of T8/TC1, R9/RC3 and T17/TC2 again, so once this round is recorded the sentence must also name its table.

**Refuter's replacement.** Line 442: `+ "; what each became is in the table (`#what-was-taken-from-the-lenses`), and what the check of how they were taken changed since in its table (`#what-was-taken-from-the-check-of-how-the-lenses-findings-were-taken`).")`, and the page regenerated by the script. When this round's gaps are recorded in a further section, the same sentence also names that section's table (for example "… changed since in their tables (the check's (`#what-was-taken-from-the-check-of-how-the-lenses-findings-were-taken`), the next (`#<that table's anchor>`))").

### What was taken from the check of the check's changes

| Gap | Id | Verdict | Finding | Taken |
|---|---|---|---|---|
| FT1 | XC4 | real | in part: `outcome_least`'s docstring and the header's bullet on amounts forgone and revaluing state the revised answer's lack of residual without the shared model | the docstring: “with the reference the revised valuation and the reading formation's model the holding formation's, the revised answer has none through the same map”; the bullet: “after a revaluation, with that shared model, the revised answer has no residual by the revised valuation”; rebuilt, the same counts ([build-8](../kit/round2c/logs/build-8.log)) |
| FT2 | RC2 | real | in part: the record's correspondence reads the incentive to withhold without “can” | as FC5 |
| FT3 | TC4 | real | in part: PLAN §8's row on current-reward-function evaluation reads the counterpart without the shared model, and `revalued_lowers_iff`'s docstring states the loss without it | the row: “a one-decision counterpart in counts, on a shared model, of the preservation incentive their Claim 2 permits, a reading”; the docstring unchanged, its refuter judging that part not real (a title continuing `own_least`'s docstring, which states the shared model) |
| FT4 | new | real | 03 §12 states the courses alike where none tells the listed worlds apart, where `inputs_alike` needs only the two worlds | as FC2 |
| FC1 | new | real | the record's law gives the worth at “listed worlds”, readable as the reading formation's listing, where `answer_constant` lists by the holding formation's model | “so holding for the answer, where the worlds the holding formation lists all show one value or no demonstration is emitted, is worth one committed move” (zh 故于持之形成所列之诸世界所示皆同处，或未发示时，为答而持值一所守之行), 360 and 86 of 420 and 190 characters |
| FC2 | new | real | 03 §12's sentence has the same gap | the refuter's text, which also takes FT4: “so they are alike wherever no demonstration is emitted or none tells the two worlds apart, and, wherever none is emitted or none tells apart the worlds the holding formation lists, holding for the answer is worth one committed move” |
| FC3 | new | real | the module header's bullet on the carrier and its Readings have the same gap | the bullet: “wherever none is emitted or none tells apart the worlds the holding formation lists”; the Readings: “nothing shown telling apart the worlds the holding formation lists”; the Lean review's row R2 the same, its page regenerated; rebuilt with FT1 |
| FC4 | new | real | the study's bullet on the carrier and the summaries in PLAN §13 and the study have the same gap | the bullet: “where none tells apart the worlds the holding formation lists (answer_constant)”; both summaries: “the worth of an answer alike stated only where no demonstration tells apart the worlds the holding formation lists or none is emitted”; and PLAN's item 19 the same: “where no demonstration is emitted or none tells apart the worlds the holding formation lists, holding for it is worth exactly one committed move” |
| FC5 | new | real | the record's correspondence reads the incentive to withhold under every reference unlike the valuation | “possible incentives to withhold and to revise”, the room made as the reader gives it (“of Bayesian persuasion's convexity condition for full disclosure”), 1199 of 1200 characters; zh 之或有之诱因, 469 of 500 |
| FC6 | new | real | the dossier's lead dates RF's text 29 and 30 October, while RF-M.3's sentences in the same bullet were made later | the integration writes the lead's last date from the day it runs: “- Added on 29, 30 and 31 October 2026 (board item RF, formations that read):” (on a later day, “29 and 30 October and …”) |
| FC7 | new | real | the page's opening points to the lenses' table alone, while the check changed six of its rows since | the opening: “what each became is in the table, and what the checks after it changed, in theirs”, linking the check's table and this one |
