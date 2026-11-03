# UE31b: T2's state on the adult-loss cultures, read by cell (design)

Board item UE31b, 3 November 2026. AI-written (a Claude Code session). The rules ([`cell_rules.py`](cell_rules.py)), the dry runs ([`dry_runs_cells.py`](dry_runs_cells.py), [`results/dry-runs-cells.json`](results/dry-runs-cells.json), [`results/dry-cells.out`](results/dry-cells.out)), the run's script ([`run_cells.py`](run_cells.py)) with its check ([`check_cells.py`](check_cells.py), [`results/check-cells.out`](results/check-cells.out)) and this file are committed together, before any value of these cultures is read. The archive is already on this machine, from UE31's download on Ren's yes. UE31b's run is a new run, and it waits on his yes (§11).

*About 20 minutes to read; §1 and §5 in five.*

## 1. What is tested, and the answer expected

UE31 ([design](../DESIGN.md), [result](../README.md#the-result)) asks whether T2's three numbers do as well as the flour beetle's life stages, the field's state, on cultures whose adult loss is set by hand. On its primary group it decided nothing. The archive's adult-loss experiment (its Data Set 2) holds 40 cultures: two strains, five set losses and four replicates. Each has 13 censuses under the loss, which gives 8 rows of data, against the 20 that UE31's rules need to fit a culture alone.

UE31b asks UE31's questions of the same 40 cultures with one change. The four replicates of one strain at one set loss are read together under one law: one *cell*, ten cells in all. A cell has 36 rows (§3).
- The questions, the models, the statistics, the bounds and the way the verdicts combine are UE31's, imported unchanged from [`state_rules.py`](../state_rules.py). Where UE31 has a culture, UE31b has a cell.
- The out-of-sample comparisons leave one culture out of its cell (§4).
- Nothing else differs (§2).

**The answer expected, stated before the run** (from the dry runs, §6):

In the field's worlds, at this shape:
- **The next step: separated, the rival's state.** W fails in every archive where the pupae are the recruits to be, T2's own law included, and V2 holds in at least 96.5%. The reading is "separated on the next step: the rival's state" in 99.2% to 99.6% of archives under the four three-stage field worlds (lpa, lpa-two, lpa-recalled, lpa-env), and in 96.5% under lpaa.
- **The course: three numbers suffice.** H1 holds in 96% to 99.9% of archives under the three-stage field worlds, and in 83% under lpaa, whose new adults are an age class. This could fail: where the life cycle is longer (lpa-long), H1 fails in 94% of archives.
- **The sign: not separated.** At this shape it cannot go to the rival, by counting (§5). In 6,000 archives of the field's six worlds (lpa to lpa-long, §6) it never went falsely to T2. Under T2's own law at the field's densities it would go to T2 in 21% of archives.
- **V5: not testable,** in 91% to 99% of archives.
- **V4: not decided, or T2 holds** (in 7% to 43%). It never fails T2 in the field's worlds.

So the reading expected is the one UE31 expected: "separated on the next step: the rival's state; three numbers suffice on the course", with the sign not separated. It would be the first reading of T2's three numbers on cultures under a draw. It would say three things:
- T2's wording, "as far as anything measured does", fails to the pupae and the adults, a class of fewer variables. That is 08 §9's defeater, met in this domain.
- T2's three numbers, with the lag at the delay, suffice on the adults' own course, where the field's state ties them.
- Their one contrary prediction is not decided by this archive.

Two outcomes would say more:
- **The course needs more than three numbers** (H1 fails). T2's universal clause then fails in this domain even narrowed to the course, and the field's three-stage model fails the course too (UE31 §10).
- **The sign separates for T2.** T2's one contrary prediction would be borne out against the field's model, which never gave it falsely in the field's worlds.

## 2. What is UE31's and what is new

| | UE31 | UE31b |
|---|---|---|
| The reading in T2's terms (level, draw, escapement, giving; the lag at the delay) | DESIGN §4 | the same |
| The models (`T2`, `H1`, `W`, `RB`, `V2`, `NOLAG`, `T2F`, `M1` and those reported) | §5 | the same, imported |
| The excess, its chance level, the robust test, the bound 0.10, α = 0.05 | §6 | the same, imported |
| The rival's sign, its weights and its band of constants | §3 | the same, imported, summed over the cell's rows |
| The median of per-loss medians; at least 6 units for a verdict; V5's and the sign's minimum of 6 | §5, §6 | the same, the unit a cell |
| The gate on H1 and its detections | §6 | the same, over cells |
| How the verdicts combine, and what each outcome means | §6, §10 | the same (§8 says what the unit changes) |
| The measured error and the protocol check | §7 | the same, reported |
| The unit | a culture | a cell: one strain at one set loss, its four replicates under one law (§3) |
| Rows | t = 4 to T − 1, at least 20 a culture | t = 3 to 11, 9 a culture, at least 24 a cell (§3) |
| Scale | the culture's largest adult count over its training censuses | the cell's largest adult count (§3) |
| Out of sample (V4, V3) | each culture's last 40% of rows | each culture left out of its cell in turn (§4) |
| The coarser grain | reported | not computed: 7 censuses under the loss at four weeks |
| The control group | reported | not read: UE31's run reported it |

## 3. The cell

**Why the cell.** T2 claims a state, the same three numbers for every renewable condition under a draw. It does not claim that its law's coefficients are the same between conditions. The four replicates of one strain at one loss share the strain, the loss, the medium and the incubator, so they are one condition four times, and one law for the four is what T2's claim and the field's model both expect.
- **Not pooled across strains.** The strains (RR and SS, the archive's README) may differ in their parameters. One law for both would count that difference against both states, as a misspecified form. Pooled per loss, there would also be 5 units, fewer than the 6 a verdict needs.
- **Not pooled across losses.** The draw enters both states' laws, and the field's turning point (§5) moves the lag's sign with density, which the loss sets.

**What pooling assumes.** One law for the four replicates. A difference between replicates that neither state reads, a jar or a batch of medium, stays in the residual of both states alike. The excess's chance level treats rows as independent, as in UE31: rows of different cultures are independent, and rows within a culture are serially dependent, as there.

**Rows.** A culture's rows are t = 3 to 11, with t + 1 in its run: 9 rows, 36 a cell.
- At t = 3 every lag the rules read, E_{t−3} in H1 included, is the escapement at a census under the loss.
- UE31 began at t = 4 to drop the start's transient, from a start of counts the experimenter chose. Here t = 0 is 12 weeks after the start, at the census at which the loss is first set, and the stages then are the culture's own. The transient from the onset is part of each culture's course under the draw, which T2's state claims to fix.
- In a pilot of 60 archives, starting at t = 4 took about half of V4's power and added power to no verdict (§6).

**Scale.** A cell's counts are divided by its cultures' largest adult count. Every column of every model is a monomial in the counts and the giving is a count, so a common scale changes no fit and no excess. The scale only sets the forecasts' floor, 1% of it (UE31 §5).

**Size.** A cell needs at least 24 rows, twice the columns of the largest model. A culture is read through its last census with any animal, as in UE31. Every culture had animals at its last census (UE31's result), so each cell has 36 rows.

## 4. Out of sample, across replicates

UE31's forecasts trained on a culture's first 60% of rows and tested on the rest. At 9 rows a culture that leaves no five-step forecast. Here each culture is left out of its cell in turn:
- T2's lean law (`T2F`), the level alone (`M1`) and the rival's state (`RB`) are fitted on the cell's other three cultures (27 rows), at their own scale;
- the culture left out is forecast from every origin with two censuses behind it and five ahead, t = 2 to 7, its level iterated five steps with the set loss known (V4);
- its next giving is predicted on each of its rows (V3, reported).

The cell's errors are those of its four cultures. V4's two criteria are UE31's: the pooled median |log error|, and a sign test over the units, here the cells. A cell's errors enter the sign test as one unit, their mean, since any two of its cultures' forecasts share two of their three training cultures.

## 5. The sign at this shape

The two rules are UE31's (its §3, §6). T2's rule is one sign for every series, the majority of the fitted signs, here over the cells. The rival's rule gives each cell its sign from its counts and the field's constants, where both sets of constants agree. The two are compared on the cells where they differ, and the comparison needs at least 6 of them.

**At this shape the comparison is one-sided.**
- The set loss sets the density. The rival predicts a negative sign in the dense cells, at the low losses, and a positive sign in the sparse cells, at the high losses.
- **Toward the rival, never.** This is exact, by counting. Where the two rules differ, the rival is right only in a cell whose fitted sign is the less common one, since T2's rule takes the more common. With ten cells the less common sign has at most five, and a decision at p < 0.05 needs at least six cells right. So the sign cannot go to the rival here, whatever the data. In 6,000 archives of the field's six worlds it went to neither rule. In 45% (lpaa) to 99% (lpa-env) the turning point did not split the cells, fewer than six of them differing, and the rest were not separated or not read (§6).
- **Toward T2, sometimes.** With one sign everywhere, as T2's law has it, the rules differ in every cell that the rival predicts negative. Where at least six are, the comparison can go to T2. In the dry runs' first six T2 worlds every cell is dense. In t2-field, at the field's densities, fewer are (§6). Under t2-field the rival predicts the negative sign in a median 5 cells, and the sign goes to T2 in 21% of archives. In the dense T2 worlds it goes to T2 in 34% to 72%.
- So at this shape the sign can decide only for T2, and only where the rival predicts the negative sign in at least six cells. It cannot go to the rival. A result for T2 would be T2's one contrary prediction borne out (UE31 §10). In the field's six worlds it never came falsely, in 0 of 6,000 archives.
- V5, T2's own item on the sign, reads the signs of the cells where the lag is detected (UE31 §6). Few cells' lags are detected at this shape, so it is not testable in 91% or more of archives in every world but lpa-long.

## 6. Dry runs

Each draw is one synthetic archive of the adult-loss experiment's shape: 2 strains × 5 set losses × 4 replicates, 40 cultures ([`dry_runs_cells.py`](dry_runs_cells.py), seed 2026110302, 1,000 draws a generator).
- Each culture starts at 250 larvae, 5 pupae and 100 adults, Dennis et al. 2001's start, since Data Set 2's own start is not read.
- It runs six census steps with the adults' natural loss (weeks 0 to 12).
- The loss is then set from the census at week 12 on. The adults returned there are the recruits since week 10 plus the set share of the adults returned at week 10.
- The rules read the 13 censuses from week 12 to week 36.
- Under T2's own law there is no natural loss to run, so its cultures run under the set loss from the start, and the rules read their last 13 censuses.

Beside the draws, one archive per generator with 30 replicates a cell shows where each rule goes when power is ample.

**The generators.** UE31's (its §8), at this shape, with two added:
- **lpa:** the demographic LPA model at Dennis et al. 2001's estimates, both strains.
- **lpa-two (added):** strain 1 at the 2001 estimates, strain 2 at the recalled set (UE31 §3, of uncertain source). These are two strains of different parameters, as the archive's two may be.
- **lpa-recalled:** both strains at the recalled set.
- **lpa-env:** lpa with the egg rate varying lognormally, sd 0.3, from step to step.
- **lpaa:** adults that matured in the last step lay and eat at half the rate.
- **lpa-long:** the feeding larvae take two census steps, so the course needs four numbers (H1's power).
- **t2-stage-\*, t2-copy-\*:** T2's law with the lag at the delay, the pupae either the recruits to be or a noisy copy of the mean, at MQ5's rates (φ, λ) = (0.96, 0.55) and at (0.9, 0.3) and (0.5, 0.4) (UE31 §8). In these worlds every cell is dense: T2's level law, 30 E e^(−E/50), puts the adults' equilibrium between about 280 and 450 at every loss, above the field's turning point of about 76 to 91.
- **t2-field-mq5 (added):** T2's law at MQ5's rates with the pupae the recruits to be, at the field's densities. At each loss the level law's constant is set so that the adults' equilibrium equals lpa's mean adults at that loss, from a calibration batch. Dense and sparse cells then fall where the field's model puts them (§5).

**How to read the table.** Each entry is the share of 1,000 archives with that verdict. *Not split* is the frozen label "not separated on the sign: the rival's turning point does not split the cultures", fewer than six cells where the two rules differ. *Not read* is the gate: H1 failing, or the further lag detected in more cells than chance gives. The sign never went to the rival, as §5 says it cannot. The medians are those of the per-archive statistics.

| Generator | W: the wording fails | V2: the rival holds | H1: T2 holds | V5: not testable; T2 fails | The sign: T2's; not split; not separated; not read | V4: T2 holds; T2 fails | Medians of W, V2, H1 | At 30 replicates a cell: the reading; the sign |
|---|---|---|---|---|---|---|---|---|
| lpa | 100.0% | 99.6% | 96.2% | 91.1%; 8.3% | 0; 90.6%; 2.7%; 6.7% | 42.5%; 0 | 0.74, -0.01, 0.02 | the rival's; three suffice; not read (the gate) |
| lpa-two | 100.0% | 99.3% | 96.8% | 96.6%; 2.5% | 0; 90.7%; 4.0%; 5.3% | 41.0%; 0 | 0.65, -0.00, 0.02 | the rival's; three suffice; not read (the gate) |
| lpa-recalled | 100.0% | 99.2% | 99.1% | 96.5%; 2.3% | 0; 96.8%; 1.3%; 1.9% | 41.8%; 0 | 0.55, -0.00, 0.01 | the rival's; three suffice; not read (the gate) |
| lpa-env | 100.0% | 99.5% | 99.9% | 99.2%; 0.8% | 0; 99.0%; 0.9%; 0.1% | 6.8%; 0 | 0.90, -0.01, -0.01 | the rival's; three suffice; not read (the gate) |
| lpaa | 100.0% | 96.5% | 83.0% | 95.3%; 4.7% | 0; 44.7%; 13.2%; 42.1% | 14.5%; 0 | 0.80, 0.02, 0.05 | the rival's; three suffice; not read (the gate) |
| lpa-long | 100.0% | 100.0% | 6.4% | 5.0%; 48.2% | 0; 2.2%; 0; 97.8% | 7.6%; 0 | 0.79, -0.05, 0.23 | the rival's; needs more; not read (H1) |
| t2-stage-mq5 | 100.0% | 99.9% | 100.0% | 99.0%; 0 | 72.0%; 0; 27.8%; 0.2% | 0.8%; 1.2% | 0.73, -0.01, -0.01 | the rival's; three suffice; T2's |
| t2-stage-b | 100.0% | 99.7% | 100.0% | 99.9%; 0 | 42.5%; 0.2%; 57.3%; 0 | 0.2%; 2.8% | 0.73, -0.01, -0.01 | the rival's; three suffice; T2's |
| t2-stage-c | 100.0% | 99.9% | 99.9% | 100.0%; 0 | 34.1%; 0.1%; 65.5%; 0.3% | 0.4%; 2.0% | 0.73, -0.01, -0.01 | the rival's; three suffice; not separated |
| t2-copy-mq5 | 0.1% | 75.9% | 100.0% | 98.8%; 0 | 71.8%; 0; 28.1%; 0.1% | 0.4%; 0.9% | -0.01, 0.07, -0.01 | tie; three suffice; T2's |
| t2-copy-b | 0 | 84.6% | 99.9% | 100.0%; 0 | 44.3%; 0.1%; 55.5%; 0.1% | 0.1%; 2.3% | -0.01, 0.05, -0.01 | tie; three suffice; T2's |
| t2-copy-c | 0 | 88.1% | 100.0% | 100.0%; 0 | 35.7%; 0.3%; 63.9%; 0.1% | 0.1%; 1.2% | -0.01, 0.05, -0.01 | tie; three suffice; T2's |
| t2-field-mq5 | 100.0% | 99.8% | 100.0% | 99.5%; 0 | 21.3%; 70.8%; 7.7%; 0.2% | 0.6%; 1.4% | 0.73, -0.01, -0.01 | the rival's; three suffice; not split |

No cell was too short or left out of a comparison in any archive, and no column was dropped. Recruits above the pupae occur only under t2-copy (a median of 1 or 2 rows an archive), where the pupae are not the recruits' source. The dry runs took about 29 minutes of CPU, about 2 minutes a generator.

**What the dry runs show.**
- **The next step goes to the field by the life cycle, as in UE31.** W fails in every archive where the pupae are the recruits to be, T2's own law included (medians 0.55 to 0.90). It holds where they are not (t2-copy). V2 holds in at least 96.5% of the field's archives.
- **H1 has power.** Three numbers suffice in 96% to 99.9% of archives under the three-stage field worlds, and in 83% under lpaa, whose new adults are an age class within the adults. Under lpa-long, where the life cycle is longer, H1 fails in 94%.
- **The sign decides only for T2, and never falsely in the field's worlds.** In 6,000 archives of the field's six worlds it went neither way. Under T2's law at the field's densities (t2-field) it went to T2 in 21%, the rival predicting a negative sign in a median 5 cells. In the dense T2 worlds it went to T2 in 34% to 72%.
- **V5 has no power at this shape.** It is not testable in 91% or more of archives in every world but lpa-long, since the lag is detected in a median of 1 to 4 of the ten cells. At 30 replicates a cell it fails T2 in every field world.
- **V4 does not fail T2 in the field's worlds.** T2's lean law forecasts better than the level alone in 7% to 43% of their archives, and the rest are not decided. In T2's own worlds it is not decided in at least 97%, and fails T2 in at most 2.8%.
- **V3, reported, favours the field's state out of sample** wherever the pupae are the source: a median ratio of the field's error to T2's of 0.01 to 0.29. Under t2-copy it is 0.87 to 0.94.
- **The measured error.** Under lpa, T2's residual is a median 3.8 times the demographic floor and the field's 0.90 times. Under lpa-env these are 25 and 0.85.
- **The gate at full size.** At 30 replicates a cell, under every field world but lpa-long, the further lag is detected in more cells than chance gives, and the gate stops the sign. That is the transient from the onset, which T2's cubic level law fits less well (§10); under lpa, H1's median at the highest loss is then 0.14. At the archive's size the gate stops the sign in at most 25% of archives (lpaa).

**Changes made after dry runs, before any value was read:**
- **The first row.** A pilot of 60 archives of five generators, with the rows from t = 3 and from t = 4 ([`pilot_first.py`](pilot_first.py), [`results/pilot-first.out`](results/pilot-first.out)), chose t = 3. At t = 4, V4's *T2 holds* fell from 43% to 20% of archives under lpa and from 28% to 12% under lpa-two. H1 held in 97% and 98% at t = 3, against 98% and 92% at t = 4. W, V2 and the T2 worlds' sign changed by at most 3 points.
- **t2-field was added** after the pilot showed every cell dense in the T2 worlds, so that the sign's power for T2 is also stated at the field's densities.

## 7. The measured error

As in UE31 §7, reported and not a verdict: each cell's floor is the mean binomial variance of recruitment given the pupae over its rows, and each state's in-sample residual is reported as a multiple of it. Censuses where the recruits exceed the pupae by more than half an animal are counted.

## 8. What each outcome means

UE31 §10's tables are fixed and hold here, read with a cell where they have a culture: the next step from W and V2, the course from H1, the sign beside them, and V5 and V4 as T2's own items. What the unit changes:

- **W, V2 and H1** are read on ten laws, each fitted to four replicates. A difference between replicates that no state reads stays in the residual of both states, so it does not by itself fail W, V2 or H1. It could fail one of them only if the columns added there happened to carry it.
- **The sign** can decide only for T2 at this shape (§5). *Not separated: the rival's turning point does not split the cells* is the expected reading in the field's worlds. It says that the archive cannot decide T2's one contrary prediction, not that T2's sign holds.
- **V5** reads cells, not cultures. A split of the detected cells' signs is T2's third forbidden item met in this domain, as in UE31.
- **V4** reads forecasts of a culture from its cell-mates' law. A culture's own difference from its cell-mates counts against both laws alike.

**Recorded now, so that no outcome can be reread afterwards** (UE31 §10's, all of which stand):
- **A failure counts.** A culture under a set adult loss is a renewable condition under a draw, and T2 claims its three numbers for every one. A failure here counts against that clause in this domain. It does not defeat T2 in the fisheries, nor the reading 08 §9 names.
- **W tests T2's wording as it stands at this freeze**, "as far as anything measured does". UE32 carries a proposal to narrow it to "as far as anything in the condition's own course does", which H1 reads. If the wording is narrowed before the run, W still reports the old wording's fate, and the narrowed claim is read from H1.
- **H1 holding** is a prediction that could fail and did not: under lpa-long it fails in most archives (§6). But the field's model makes the same prediction at this life cycle, so it shows nothing the field does not (UE31 §10).
- **A sign for T2** would be the one place where T2 named in advance would do better than the field's model, here (UE31 §10). It would change 08 §8's verdicts for this domain.

## 9. Data, what has been seen, and the run's order

**The workbook.** It is the one UE31 downloaded by hand on Ren's yes of 3 November, `BeetleTeamTriboliumDataArchive.xlsx` (sha-256 `5ce9ae436bf2…`, Desharnais 2023, Dryad, doi 10.5061/dryad.qjq2bvqmp, CC0). It is kept outside the repository, and its README was read in full at UE31's layout (../LAYOUT.md). The strains are coded 1 for RR and 2 for SS.

**What has been seen of the 40 cultures:**
- their layout: codes, weeks and lengths (../LAYOUT.md);
- one fact about their values: each had animals at its last census (UE31's result).

UE31's run read their counts in memory, to count rows and to find each culture's last census with any animal. It wrote none of them: its output gives for this group only how many cultures were read (none). The layout's probe printed no census count. No number of theirs has been printed in this session.

**The literature.**
- Costantino et al. 1995's abstract was read for UE31. It reports that the dynamics changed with the set loss. No figure of this experiment's series has been opened.
- Dennis et al. 1997, which analyses these cultures, is not read. Its estimates are fitted to these cultures, so a sign from them would not be a prediction. The rival's sign keeps UE31's band of constants, which come from other analyses.

**The run's order.** One step, run with `python3 -I -B run_cells.py XLSX OUT_JSON`:
1. the digest is checked;
2. UE31's reader reads the cultures (checked on 55 synthetic cultures, ../run/reader-check.out);
3. the cells are asserted, 10 cells of 4 cultures of 13 censuses;
4. the rules are run;
5. the output is kept whatever it is.

[`check_cells.py`](check_cells.py) checks that path from a workbook in Data Set 2's layout to the verdicts, on synthetic cultures ([`results/check-cells.out`](results/check-cells.out)). Every cell's numbers are written, since no later design on these cultures is planned.

## 10. Limits

UE31 §12's limits all apply. Beyond them:
- **One law a cell.** Four replicates share it. A difference between them that no state reads stays in both residuals.
- **The transient from the onset.** The rows begin three censuses after the loss is first set, and in the cultures at the highest loss the adults are still falling then. T2's law, cubic in the level, fits that fall less well than the field's state does. Under lpa, at 30 replicates a cell, H1's median at the highest loss is 0.14 (§6). The median of per-loss medians still holds H1 in 96% of lpa's archives. With many rows, though, the further lag is detected in more cells than chance gives, and the gate then stops the sign (§6, the column at 30 replicates).
- **The sign is one-sided at this shape** (§5).
- **V4 reads across replicates.** Each forecast uses a law fitted to three other cultures.
- **The rival's constants.** They come from other analyses: the 2001 estimates of another experiment's RR cultures, and the recalled set of uncertain source. Data Set 2's two strains may differ from both.
- **Ten units.** V5 is not testable in most archives, and V4 decides in at most 43% of the field's archives.
- **The start.** The dry runs start every culture at Dennis et al. 2001's counts; Data Set 2's start is not read. Only the state at the onset depends on it.

## 11. What waits on Ren

- **The run:** a few seconds of CPU on the workbook already on this machine, the one UE31 downloaded on his yes of 3 November (sha-256 `5ce9ae43…`). Nothing is downloaded.

Freezing is done by this commit and waits on no one: designs are prepared fully, freezing included, and only their release waits for him (AGENTS.md).

## 12. Review

REVIEW
