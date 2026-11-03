# UE31b: T2's state on the adult-loss cultures, read by cell (design)

Board item UE31b, 3 November 2026. AI-written (a Claude Code session). The rules ([`cell_rules.py`](cell_rules.py)), the dry runs ([`dry_runs_cells.py`](dry_runs_cells.py), [`results/dry-runs-cells.json`](results/dry-runs-cells.json), [`results/dry-cells.out`](results/dry-cells.out)), the run's script ([`run_cells.py`](run_cells.py)) with its check ([`check_cells.py`](check_cells.py), [`results/check-cells.out`](results/check-cells.out)), the pilot ([`pilot_first.py`](pilot_first.py)), the first reader's probe ([`probe_transient.py`](probe_transient.py)) and this file are committed together, before any value of these cultures is read. The archive is already on this machine, from UE31's download on Ren's yes. UE31b's run is a new run, and it waits on his yes (§11).

*About 20 minutes to read; §1 and §5 in five.*

## 1. What is tested, and the answer expected

UE31 ([design](../DESIGN.md), [result](../README.md#the-result)) asks whether T2's three numbers do as well as the flour beetle's life stages, the field's state, on cultures whose adult loss is set by hand. On its primary group it decided nothing. The archive's adult-loss experiment (its Data Set 2) holds 40 cultures: two strains, five set losses and four replicates. Each has 13 censuses under the loss, which gives 8 rows of data, against the 20 that UE31's rules need to fit a culture alone.

UE31b asks UE31's questions of the same 40 cultures with one change. The four replicates of one strain at one set loss are read together under one law: one *cell*, ten cells in all. A cell has 36 rows (§3).
- The questions, the models, the statistics, the bounds and the way the verdicts combine are UE31's, imported unchanged from [`state_rules.py`](../state_rules.py). Where UE31 has a culture, UE31b has a cell.
- The out-of-sample comparisons leave one culture out of its cell (§4).
- Nothing else differs (§2).

**The answer expected, stated before the run** (from the dry runs, §6):

In the field's worlds, the eight in which the field's model holds (lpa to lpa-offband, §6), at this shape:
- **The next step: separated, the rival's state.** W fails in every archive where the pupae are the recruits to be, T2's own law included. The reading is "separated on the next step: the rival's state" in 99.2% to 99.6% of archives under the four three-stage worlds whose replicates are alike (lpa, lpa-two, lpa-recalled, lpa-env), 99.1% under lpa-offband, 96.5% under lpaa, and 90.2% under lpa-jars, whose replicates differ. In the rest V2 fails.
- **The course: three numbers suffice.** H1 holds in 96% to 99.9% of archives under the three-stage worlds, and in 83% under lpaa, whose new adults are an age class. This could fail: where the life cycle is longer (lpa-long), H1 fails in 94% of archives.
- **The sign: not separated.** It cannot go to the rival, by counting (§5). Where the field's turning point lies within the rival's band of constants, it never went falsely to T2: of the 225 archives of those seven worlds in which it was read with at least six cells differing, none went to T2. Where the turning point lies outside the band (lpa-offband), it went falsely to T2 in 2 of 1,000 archives. Under T2's own law at the field's densities it would go to T2 in 61% of archives.
- **V5: not testable,** in 72% to 99% of archives in every field world but lpa-long.
- **V4: not decided, or T2 holds** (in 7% to 43%). It never fails T2 in the field's worlds.
- **The recording checks** (§7) never stopped a reading in the field's worlds, and stopped every one where the adults were recorded as counted (lpa-counted).

So the reading expected is the one UE31 expected: "separated on the next step: the rival's state; three numbers suffice on the course", with the sign not separated. It would be the first reading of T2's three numbers on cultures under a draw. It would say three things:
- T2's wording, "as far as anything measured does", fails to the pupae and the adults, a class of fewer variables. That is 08 §9's defeater, met in this domain.
- T2's three numbers, with the lag at the delay, suffice on the adults' own course, where the field's state ties them. At this shape that rests on H1 alone, a prediction the field's model makes the same way (§8).
- Their one contrary prediction is not decided by this archive.

Two outcomes would say more:
- **The course needs more than three numbers** (H1 fails). T2's universal clause then fails in this domain even narrowed to the course. The cause could be a longer life cycle, which the field's three-stage model would miss too (UE31 §10), or T2's law form, polynomial in the level, against the field's exponential terms (§10).
- **The sign separates for T2.** T2's one contrary prediction would be borne out against the field's model at constants from other analyses (§8), in a comparison that could not have gone the field's way at this shape (§5). The field's model gave it falsely in 2 of 1,000 archives where its turning point lies outside the band, and never where it lies within.

## 2. What is UE31's and what is new

| | UE31 | UE31b |
|---|---|---|
| The reading in T2's terms (level, draw, escapement, giving; the lag at the delay) | DESIGN §4 | the same |
| The models (`T2`, `H1`, `W`, `RB`, `V2`, `NOLAG`, `T2F`, `M1` and those reported) | §5 | the same, imported |
| The excess, its chance level, the robust test, the bound 0.10, α = 0.05 | §6 | the same, imported |
| The rival's sign, its weights and its band of constants | §3 | the same, imported, summed over the cell's rows |
| The median of per-loss medians; at least 6 units for a verdict; V5's and the sign's minimum of 6 | §5, §6 | the same, the unit a cell |
| The gate on H1 and its detections | §6 | the same, over cells |
| How the verdicts combine, and what each outcome means | §6, §10 | the same (§8 says what the unit changes, and what T2 narrowed would rest on here) |
| The measured error | §7 | the same, reported |
| The protocol check: recruits above the pupae | §7, reported | frozen with a consequence: in more than 2% of the cells' rows, no verdict is read (§7) |
| Week 12's two entries | the later read as the one after the treatment, unchecked, since it touched only cultures too short to read | the one that shows the treatment at the largest losses read, the later or the earlier; if neither does, no verdict is read (§7) |
| The unit | a culture | a cell: one strain at one set loss, its four replicates under one law (§3) |
| Rows | t = 4 to T − 1, at least 20 a culture | t = 3 to 11, 9 a culture, at least 24 a cell (§3) |
| Scale | the culture's largest adult count over its training censuses | the cell's largest adult count (§3) |
| Out of sample (V4, V3) | each culture's last 40% of rows | each culture left out of its cell in turn (§4) |
| Test rows a culture | at least 8 | no minimum: each culture left out is forecast from its six origins (§4) |
| The size test | a culture's rows | a cell's total rows, so a culture that died early would still enter its cell; none can here (§3) |
| The coarser grain | reported | not computed: 7 censuses under the loss at four weeks |
| The control group | reported | not read: UE31's run reported it |

## 3. The cell

**Why the cell.** T2 claims a state, the same three numbers for every renewable condition under a draw. It does not claim that its law's coefficients are the same between conditions, nor between jars of one condition. The four replicates of one strain at one loss share the strain, the loss, the medium and the incubator. One law for the four is an assumption, made for both states alike, so that each cell has rows enough to read.
- **Not pooled across strains.** The strains (RR and SS, the archive's README) may differ in their parameters. One law for both would count that difference against both states, as a misspecified form. Pooled per loss, there would also be 5 units, fewer than the 6 a verdict needs.
- **Not pooled across losses.** The draw enters both states' laws, and the field's turning point (§5) moves the lag's sign with density, which the loss sets.

**What pooling assumes, and what it costs.** One law for the four replicates. A difference between replicates that neither law's coefficients carry, a jar's own fecundity or larval survival, is not neutral between the states. It shows in the jar's pupae, which the rival's state reads and T2's adult lags do not. So such differences move W toward the rival, can push V2 toward failing, and lower V4's power. The dry runs measure this with a world whose cultures differ in four parameters (lpa-jars, §6). The excess's chance level treats rows as independent, as in UE31: rows of different cultures are independent, and rows within a culture are serially dependent, as there.

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

Leaving one out is neutral for V4, since both laws it compares read only the adults. Where replicates differ, it favours the rival's state on V3, which reads the pupae; V3 is reported only.

## 5. The sign at this shape

The two rules are UE31's (its §3, §6). T2's rule is one sign for every series, the majority of the fitted signs, here over the cells. The rival's rule gives each cell its sign from its counts and the field's constants, where both sets of constants agree. The two are compared on the cells where they differ, and the comparison needs at least 6 of them.

**At this shape the comparison is one-sided.**
- The set loss sets the density. The rival predicts a negative sign in the dense cells, at the low losses, and a positive sign in the sparse cells, at the high losses.
- **Toward the rival, never.** This is exact, by counting. Where the two rules differ, the rival is right only in a cell whose fitted sign is the one T2's rule did not take; at a 5–5 split, ties going to the positive sign, that is the five negative cells. So the rival can be right in at most five cells, and a decision at p < 0.05 needs at least six right: 6 of 6, 7 of 7, 8 of 8, 8 of 9 or 9 of 10 of the cells where the rules differ. So the sign cannot go to the rival here, whatever the data.
- **The cause is UE31's rule for T2's sign,** the majority of the fitted signs, which UE31 already notes favours T2 (its §6 and §12). With six differing cells needed and only ten units, that leniency decides the direction. In UE31's own dry runs, at the archive's likely size, the sign went to the rival in up to 21.7% of groups (its §1). UE31b keeps the rule unchanged and states the cost: here the sign cannot tell against T2.
- **Toward T2, sometimes.** With one sign everywhere, as T2's law has it, the rules differ in every cell that the rival predicts negative. Where at least six are, the comparison can go to T2. In the dense T2 worlds the rival predicts the negative sign in a median 10 cells, and the sign goes to T2 in 41% to 76% of archives. Under t2-field, at the field's densities, the median is 6 cells and the sign goes to T2 in 61%.
- **How often T2 gets it falsely.** In the field's worlds the turning point mostly does not split the cells: fewer than six differ in 45% (lpaa) to 99% (lpa-env) of archives in every world but lpa-long and lpa-offband, where H1's failure stops the sign (lpa-long) or the band misplaces the turning point (lpa-offband). Of the 225 archives of the seven worlds whose turning point lies within the band in which the sign was read with at least six cells differing (lpa 27, lpa-two 40, lpa-recalled 13, lpa-env 9, lpaa 132, lpa-long 0, lpa-jars 4), none went to T2. Under lpa-offband the rival predicts the negative sign in a median 6 cells, the sign was read with at least six differing in 916 of 1,000 archives, and went to T2 in 2.
- So at this shape the sign can decide only for T2, and only where the rival predicts the negative sign in at least six cells. A result for T2 would be T2's one contrary prediction borne out (UE31 §10), with the qualifications of §8.
- V5, T2's own item on the sign, reads the signs of the cells where the lag is detected (UE31 §6). Few cells' lags are detected at this shape, so it is not testable in 72% or more of archives in every field world but lpa-long.

## 6. Dry runs

Each draw is one synthetic archive of the adult-loss experiment's shape: 2 strains × 5 set losses × 4 replicates, 40 cultures ([`dry_runs_cells.py`](dry_runs_cells.py), seed 2026110302, 1,000 draws a generator).
- Each culture starts at 250 larvae, 5 pupae and 100 adults, Dennis et al. 2001's start, since Data Set 2's own start is not read.
- It runs six census steps with the adults' natural loss (weeks 0 to 12).
- The loss is then set from the census at week 12 on. The adults returned there are the recruits since week 10 plus the set share of the adults returned at week 10.
- The rules read the 13 censuses from week 12 to week 36.
- Under T2's own law the escapement is the adults' natural share, 1 − 0.007629 a step (Dennis et al. 2001's estimate), until week 10's adults, and the set share from them on, so that week 12's adults are the first returned under the loss, as in the LPA worlds.

Beside the draws, one archive per generator with 30 replicates a cell shows where each rule goes when power is ample.

**The generators.** UE31's (its §8), at this shape, with five added:
- **lpa:** the demographic LPA model at Dennis et al. 2001's estimates, both strains.
- **lpa-two (added):** strain 1 at the 2001 estimates, strain 2 at the recalled set (UE31 §3, of uncertain source). These are two strains of different parameters, as the archive's two may be.
- **lpa-recalled:** both strains at the recalled set.
- **lpa-env:** lpa with the egg rate varying lognormally, sd 0.3, from step to step.
- **lpaa:** adults that matured in the last step lay and eat at half the rate.
- **lpa-long:** the feeding larvae take two census steps, so the course needs four numbers (H1's power).
- **lpa-jars (added):** lpa with each culture's egg rate and three cannibalism rates (b, c_el, c_ea, c_pa) varying lognormally, sd 0.2, about the 2001 estimates: replicates that differ in what neither law carries (§3).
- **lpa-offband (added):** lpa with c_ea halved, so that the turning point, about 153 adults, lies outside the rival's band of about 76 to 91.
- **t2-stage-\*, t2-copy-\*:** T2's law with the lag at the delay, the pupae either the recruits to be or a noisy copy of the mean, at MQ5's rates (φ, λ) = (0.96, 0.55) and at (0.9, 0.3) and (0.5, 0.4) (UE31 §8). In these worlds every cell is dense: T2's level law, 30 E e^(−E/50), puts the adults' equilibrium between about 280 and 450 at every loss, above the field's turning point.
- **t2-field-mq5 (added):** T2's law at MQ5's rates with the pupae the recruits to be, at the field's densities. At each loss the level law's constant is set, by bisection on calibration batches, so that T2's cultures hold on average lpa's mean adults over the 13 censuses read ([`results/dry-runs-cells.json`](results/dry-runs-cells.json), `t2_field_mean_adults`). At the three lower losses it does so; at 0.73 and 0.96 no constant does, since T2's law at these rates answers the onset's fall with giving through its lag's term, and there T2's cultures hold a mean of 87 and 85 adults against lpa's 75 and 52. Dense and sparse cells then fall about where the field's model puts them, the two highest losses a little denser (§5).
- **lpa-counted (added):** lpa with the adults recorded as counted before the manipulation from week 14 on, not as returned: the recording the frozen check of §7 must catch.

**How to read the table.** Each entry is the share of 1,000 archives with that verdict. *Not split* is the frozen label "not separated on the sign: the rival's turning point does not split the cultures", fewer than six cells where the two rules differ. *Not read* is the gate: H1 failing, or the further lag detected in more cells than chance gives. The sign never went to the rival, as §5 says it cannot; under lpa-offband its 0.2% to T2 are false. Under t2-copy-c one archive in 1,000 was not read for the recording (§7), so its row sums to 99.9%. The medians are those of the per-archive statistics.

| Generator | W: the wording fails | V2: the rival holds | H1: T2 holds | V5: not testable; T2 fails | The sign: T2's; not split; not separated; not read | V4: T2 holds; T2 fails | Medians of W, V2, H1 | At 30 replicates a cell: the reading; the sign |
|---|---|---|---|---|---|---|---|---|
| lpa | 100.0% | 99.6% | 96.2% | 91.1%; 8.3% | 0; 90.6%; 2.7%; 6.7% | 42.5%; 0 | 0.74, -0.01, 0.02 | the rival's; three suffice; not read (the gate) |
| lpa-two | 100.0% | 99.3% | 96.8% | 96.6%; 2.5% | 0; 90.7%; 4.0%; 5.3% | 41.0%; 0 | 0.65, -0.00, 0.02 | the rival's; three suffice; not read (the gate) |
| lpa-recalled | 100.0% | 99.2% | 99.1% | 96.5%; 2.3% | 0; 96.8%; 1.3%; 1.9% | 41.8%; 0 | 0.55, -0.00, 0.01 | the rival's; three suffice; not read (the gate) |
| lpa-env | 100.0% | 99.5% | 99.9% | 99.2%; 0.8% | 0; 99.0%; 0.9%; 0.1% | 6.8%; 0 | 0.90, -0.01, -0.01 | the rival's; three suffice; not read (the gate) |
| lpaa | 100.0% | 96.5% | 83.0% | 95.3%; 4.7% | 0; 44.7%; 13.2%; 42.1% | 14.5%; 0 | 0.80, 0.02, 0.05 | the rival's; three suffice; not read (the gate) |
| lpa-long | 100.0% | 100.0% | 6.4% | 5.0%; 48.2% | 0; 2.2%; 0; 97.8% | 7.6%; 0 | 0.79, -0.05, 0.23 | the rival's; needs more; not read (H1) |
| lpa-jars | 100.0% | 90.2% | 98.7% | 86.3%; 11.5% | 0; 97.9%; 0.4%; 1.7% | 19.6%; 0 | 0.77, 0.03, 0.01 | the rival's; three suffice; not read (the gate) |
| lpa-offband | 100.0% | 99.1% | 99.6% | 72.1%; 13.5% | 0.2%; 7.7%; 91.4%; 0.7% | 6.2%; 0 | 0.55, -0.01, -0.01 | the rival's; three suffice; not read (the gate) |
| t2-stage-mq5 | 100.0% | 99.6% | 100.0% | 94.4%; 0 | 75.7%; 0; 24.2%; 0.1% | 1.4%; 1.0% | 0.73, -0.01, -0.01 | the rival's; three suffice; T2's |
| t2-stage-b | 100.0% | 100.0% | 99.9% | 99.9%; 0 | 41.5%; 0.3%; 58.1%; 0.1% | 0.2%; 6.0% | 0.73, -0.01, -0.01 | the rival's; three suffice; not separated |
| t2-stage-c | 100.0% | 100.0% | 100.0% | 98.8%; 0 | 63.0%; 0.1%; 36.8%; 0.1% | 0.9%; 1.2% | 0.73, -0.01, -0.01 | the rival's; three suffice; T2's |
| t2-copy-mq5 | 0.2% | 42.6% | 100.0% | 93.1%; 0 | 73.1%; 0; 26.6%; 0.3% | 1.7%; 0.7% | -0.01, 0.11, -0.01 | T2's; three suffice; T2's |
| t2-copy-b | 0 | 84.1% | 99.6% | 100.0%; 0 | 44.1%; 0; 55.4%; 0.5% | 0; 6.4% | -0.01, 0.05, -0.01 | tie; three suffice; T2's |
| t2-copy-c | 0 | 70.8% | 99.9% | 98.7%; 0 | 66.6%; 0; 33.3%; 0 | 0.4%; 0.7% | -0.01, 0.08, -0.01 | T2's; three suffice; T2's |
| t2-field-mq5 | 100.0% | 99.9% | 100.0% | 99.3%; 0 | 61.3%; 10.5%; 28.1%; 0.1% | 0.4%; 1.1% | 0.73, -0.01, -0.01 | the rival's; three suffice; T2's |
| lpa-counted | every archive not read: the recording disagrees with the protocol | | | | | | | not read: the recording disagrees with the protocol |

No cell was too short and no column was dropped in any archive, and in the field's worlds no comparison went uncomputed; under T2's worlds a comparison could not be computed in at most 4 cells of an archive (t2-stage-b, t2-copy-b). The recruits exceed the pupae in no row of any archive where the pupae are the recruits' source, in at most 9 rows of 360 under t2-copy, and in up to 176 under lpa-counted. These maxima are in the JSON (`most_*`). The dry runs took about 36 minutes of CPU, about 2.3 minutes a generator.

**What the dry runs show.**
- **The next step goes to the field by the life cycle, as in UE31.** W fails in every archive where the pupae are the recruits to be, T2's own law included (medians 0.55 to 0.90). It holds where they are not (t2-copy). V2 holds in at least 96.5% of the archives of the field's worlds whose replicates are alike, and in 90.2% under lpa-jars.
- **Replicates that differ lean toward the rival, as §3 says.** Under lpa-jars V2's median rises from −0.01 to 0.03 and V2 fails in 9.8% of archives; V4's *T2 holds* falls from 43% to 20%; H1 holds in 98.7%.
- **H1 has power.** Three numbers suffice in 96% to 99.9% of archives under the three-stage field worlds, and in 83% under lpaa, whose new adults are an age class within the adults. Under lpa-long, where the life cycle is longer, H1 fails in 94%.
- **The sign decides only for T2, and falsely only off the band.** Of the field's archives in which it was read with at least six cells differing, none within the band went to T2, and 2 of 1,000 under lpa-offband did (§5). Under T2's law at the field's densities (t2-field) it went to T2 in 61%, the rival predicting a negative sign in a median 6 cells. In the dense T2 worlds it went to T2 in 41% to 76%.
- **V5 has little power at this shape.** It is not testable in 72% or more of archives in every world but lpa-long, since the lag is detected in a median of 1 to 5 of the ten cells. At 30 replicates a cell it fails T2 in every field world.
- **V4 does not fail T2 in the field's worlds.** T2's lean law forecasts better than the level alone in 7% to 43% of their archives, and the rest are not decided. In T2's own worlds it is not decided in at least 93%, and fails T2 in at most 6.4%.
- **V3, reported, favours the field's state out of sample** wherever the pupae are the source: a median ratio of the field's error to T2's of 0.01 to 0.29. Under t2-copy it is 0.93 to 0.98.
- **The measured error.** Under lpa, T2's residual is a median 3.8 times the demographic floor and the field's 0.90 times. Under lpa-env these are 25 and 0.85.
- **The recording check.** It never fired in the field's worlds, where no row's recruits exceed the pupae, and fired in every archive of lpa-counted (up to 176 of 360 rows above, against the 8 that stop a reading). Under t2-copy, where the pupae are not the recruits' source, it fired in 1 archive of 3,000.
- **The gate at full size.** At 30 replicates a cell, under every field world but lpa-long, the further lag is detected in more cells than chance gives, and the gate stops the sign. The main cause is T2's law form: polynomial in the level, it misfits the field's exponential terms, which 1,080 rows a cell detect. The first reader's probe ([`probe_transient.py`](probe_transient.py), [`results/probe-transient.out`](results/probe-transient.out)) shows it: with the loss set from week 0, so that no onset falls in the window read, the further lag is still detected in 4 or 5 of the ten cells and the gate still fires. The onset adds to it at the highest loss, where H1's median is 0.12 to 0.20 with it and 0.05 to 0.09 without. At the archive's size the gate, H1's failure included, stops the sign in 0.1% (lpa-env) to 42.1% (lpaa) of the field's archives, and in 97.8% under lpa-long.

**Changes made before any value was read:**
- **The first row,** before the dry runs. A pilot of 60 archives of five generators, with the rows from t = 3 and from t = 4 ([`pilot_first.py`](pilot_first.py), [`results/pilot-first.out`](results/pilot-first.out)), chose t = 3. At t = 4, V4's *T2 holds* fell from 43% to 20% of archives under lpa and from 28% to 12% under lpa-two. H1 held in 97% and 98% at t = 3, against 98% and 92% at t = 4, and failed under lpa-long in 92% against 90%. The pilot's output is from the code as frozen, rerun after T2's worlds were given an onset (below); at t = 4, V2 under t2-copy-mq5 held, wrongly, in 77% of archives against 37% at t = 3, and the sign went to T2 in 73% and 63% under the two T2 worlds against 77% and 72%. W changed in no world. Before the onset was added, the T2 worlds' figures had changed by at most 3 points; the choice of t = 3 stands either way.
- **t2-field was added** after single archives of the dense T2 worlds showed the rival predicting a negative sign in 9 of 10 cells (the full runs give a median of 10), so that the sign's power for T2 is also stated at the field's densities.
- **After the first reader's review (§12):** the frozen recording check and week 12's reading (§7); T2's worlds given an onset, as the LPA worlds and the archive have; lpa-jars, lpa-offband and lpa-counted added; the draws' default set to the 1,000 run; maxima stored. With the onset, t2-field's first calibration, which set the equilibrium under the set loss, left its cultures denser than lpa's before and after the onset (the rival predicting the negative sign in a median 9 cells against lpa's 4). Its constant is now set on the censuses read, as above.

## 7. The measured error and the recording

**The measured error.** As in UE31 §7, reported and not a verdict: each cell's floor is the mean binomial variance of recruitment given the pupae over its rows, and each state's in-sample residual is reported as a multiple of it.

**The recording, checked before any verdict is read.** UE31 left two choices open because they touched only cultures too short to read (../LAYOUT.md, the recording; ../README.md). Here they set every value read: t = 0, and every escapement and giving after it.
- **Which census's adults.** The reading takes each census's adults as those returned to the culture after the manipulation. The archive's README does not say whether a count is that one or the one counted before it. Under the counted form the recruits read would often exceed the pupae, which a recruit cannot. So the check is frozen with a consequence: **where the recruits exceed the pupae by more than half an animal in more than 2% of the cells' rows (8 or more of 360), the reading is "the recording disagrees with the protocol" and no verdict is read** ([`cell_rules.py`](cell_rules.py), `PROTOCOL_SHARE`). Half an animal allows for the protocol's rounding.
- **Which of week 12's entries.** The README says the two week-12 entries "are pre- and post-treatment". UE31's reader keeps the later one in the sheet's order. At the three largest losses the treatment removes half or more of the adults, so the entry after it must hold fewer. Frozen ([`run_cells.py`](run_cells.py), `week12_order`): **if the later entry holds no more adults than the earlier in all 24 cultures at those losses and fewer in at least 20, it is read; if instead the earlier one does, the earlier is read at t = 0 in every culture; if neither does, no verdict is read.** How many cultures hold the same larvae and pupae in both entries is reported.

## 8. What each outcome means

UE31 §10's tables are fixed and hold here, read with a cell where they have a culture: the next step from W and V2, the course from H1, the sign beside them, and V5 and V4 as T2's own items. What the unit changes:

- **The labels.** The run prints UE31's frozen labels, which say "cultures". Here each means cells.
- **W, V2 and H1** are read on ten laws, each fitted to four replicates. A difference between replicates that neither law carries is not neutral (§3): it moves W toward the rival and can push V2 toward failing.
- **The sign** can decide only for T2 at this shape (§5). *Not separated: the rival's turning point does not split the cultures* is the expected reading in the field's worlds. It says that the archive cannot decide T2's one contrary prediction, not that T2's sign holds.
- **T2 narrowed to the condition's own course.** UE31's rule reads it as holding only if H1 holds, neither V5 nor V4 fails, and the sign does not separate for the rival (UE31 §6). At this shape the last three can hardly fail: the sign cannot go to the rival (§5), V5 is not testable in most archives, and V4 never failed T2 in the field's worlds (§6). So a reading that T2 narrowed holds would rest on H1 alone, a prediction the field's model makes the same way. It is not T2 passing its sign test or its own items.
- **V5** reads cells, not cultures. A split of the detected cells' signs is T2's third forbidden item met in this domain, as in UE31.
- **V4** reads forecasts of a culture from its cell-mates' law. A culture's own difference from its cell-mates counts against both laws alike.

**Recorded now, so that no outcome can be reread afterwards** (UE31 §10's, all of which stand):
- **A failure counts.** A culture under a set adult loss is a renewable condition under a draw, and T2 claims its three numbers for every one. A failure here counts against that clause in this domain. It does not defeat T2 in the fisheries, nor the reading 08 §9 names.
- **W tests T2's wording as it stands at this freeze**, "as far as anything measured does". UE32 carries a proposal to narrow it to "as far as anything in the condition's own course does", which H1 reads. If the wording is narrowed before the run, W still reports the old wording's fate, and the narrowed claim is read from H1.
- **H1 holding** would be a prediction that could fail and did not: under lpa-long it fails in most archives (§6). But the field's model makes the same prediction at this life cycle, so it shows nothing the field does not (UE31 §10).
- **H1 failing** can come from a longer life cycle, and also from T2's law form: its law, polynomial in the level, misfits the field's exponential terms, which enough rows detect (§10). Under lpa itself H1 fails in some archives (§6).
- **A sign for T2** would be the one place where T2 named in advance would do better than the field's model here (UE31 §10): against the rival at constants from other analyses, in a comparison that could not have gone the rival's way at this shape (§5), and which the field's model got falsely in 2 of 1,000 archives when its turning point lay outside the band. With these qualifications stated, it would change 08 §8's verdicts for this domain.

## 9. Data, what has been seen, and the run's order

**The workbook.** It is the one UE31 downloaded by hand on Ren's yes of 3 November, `BeetleTeamTriboliumDataArchive.xlsx` (sha-256 `5ce9ae436bf2…`, Desharnais 2023, Dryad, doi 10.5061/dryad.qjq2bvqmp, CC0). It is kept outside the repository, and its README was read in full at UE31's layout (../LAYOUT.md). The strains are coded 1 for RR and 2 for SS.

**What has been seen of the 40 cultures:**
- their layout: codes, weeks and lengths, and no blank cell (../LAYOUT.md);
- one fact about their values: each had animals at its last census (UE31's result: 8 rows a culture, so animals at t = 12 in all 40);
- the archive's README, read in full: it names the five losses, the two strains and the two week-12 entries, "pre- and post-treatment", and says that the loss was set from week 12;
- Costantino et al. 1995's abstract, read for UE31: the dynamics changed with the set loss.

UE31's run read their counts in memory, to count rows and to find each culture's last census with any animal. It wrote none of them: its output gives for this group only how many cultures were read (none). The layout's probe printed no census count. No number of theirs has been printed in this session. The model that wrote this design may have met these cultures' published series in its training text. That cannot be ruled out; it recalls no value of them, and the design's choices were made from the dry runs.

**The literature.**
- No figure of this experiment's series has been opened.
- Dennis et al. 1997, which analyses these cultures, is not read. Its estimates are fitted to these cultures, so a sign from them would not be a prediction. The rival's sign keeps UE31's band of constants, which come from other analyses.

**The run's order.** One step, run with `python3 -I -B run_cells.py XLSX OUT_JSON`:
1. the digest is checked;
2. UE31's reader reads the cultures (checked on 55 synthetic cultures, ../run/reader-check.out);
3. the cells are asserted, 10 cells of 4 cultures of 13 censuses;
4. week 12's order is checked (§7);
5. the rules are run, with the recording check (§7);
6. the output is kept whatever it is.

[`check_cells.py`](check_cells.py) checks that path from a workbook in Data Set 2's layout to the verdicts, on synthetic cultures ([`results/check-cells.out`](results/check-cells.out)). It also checks the reading of week 12: with its two entries the other way round in every culture, the earlier is read and the verdicts are the same; with them the other way round in half the cultures, no verdict is read. Every cell's numbers are written, since no later design on these cultures is planned.

## 10. Limits

UE31 §12's limits all apply. Beyond them:
- **One law a cell.** Four replicates share it. A difference between them that neither law carries leans toward the rival's state (§3, §6).
- **T2's law form.** T2's law is polynomial in the level, the field's has exponential terms. With many rows the misfit is detected: at 30 replicates a cell the further lag is detected in more cells than chance gives in every field world but lpa-long, with or without an onset in the window, and the gate stops the sign (§6). At the archive's size it shows as H1 failing in some archives, 4% under lpa, 17% under lpaa.
- **The transient from the onset.** The rows begin three censuses after the loss is first set, and in the cultures at the highest loss the adults are still falling then. That adds to the misfit at the highest loss: under lpa at 30 replicates a cell, H1's median there is 0.12 to 0.20 with the onset and 0.05 to 0.09 without (the first reader's probe, §6). The median of per-loss medians still holds H1 in 96% of lpa's archives.
- **The sign is one-sided at this shape** (§5).
- **V4 reads across replicates.** Each forecast uses a law fitted to three other cultures.
- **The rival's constants.** They come from other analyses: the 2001 estimates of another experiment's RR cultures, and the recalled set of uncertain source. Data Set 2's two strains may differ from both. A world whose turning point lies outside the band (lpa-offband, §6) gives the cost of that.
- **Ten units.** V5 is not testable in most archives, and V4 decides in at most 43% of the field's archives. The sign cannot go to the rival (§5).
- **The recording.** Two frozen checks stand between the workbook and the verdicts (§7). If either stops the reading, UE31b decides nothing, as UE31 did.
- **The start.** The dry runs start every culture at Dennis et al. 2001's counts; Data Set 2's start is not read. Only the state at the onset depends on it.

## 11. What waits on Ren

- **The run:** a few seconds of CPU on the workbook already on this machine, the one UE31 downloaded on his yes of 3 November (sha-256 `5ce9ae43…`). Nothing is downloaded.

Freezing is done by this commit and waits on no one: designs are prepared fully, freezing included, and only their release waits for him (AGENTS.md).

## 12. Review

**The first reader.** One independent reader, a Claude Code subagent that did not write the design, read it at `da1f32aa6`: all of `cells/`, UE31's rules, reader and reader check, its layout, README and run, its design but for §8 and §13, and the board's rows. It recomputed the §6 table from the JSON, enumerated the sign test, ran the cell check, and ran two probes of its own (three synthetic worlds of 100 archives; six archives at 30 replicates a cell). It did not open the workbook. Its verdict: the rival's state is fairly stated at the cell, the port is faithful, the one-sidedness is exact, and every number it checked matched but seven. It gave 21 findings, two of them errors. All were taken:
- **The recording (an error).** The returned form and week 12's order, left open in UE31 since they did not matter there, set every value read here, and the protocol check had no consequence. Both now have frozen checks with consequences (§7); the cell check covers week 12 both ways round and mixed (§9), and lpa-counted shows the recording check firing (§6). The reader proposed stopping on a reversed order; the design reads the entry that shows the treatment instead, and stops only if neither does.
- **T2 narrowed (an error).** At this shape it would rest on H1 alone; §1 and §8 say so.
- **Pooling is not neutral** (§3, §8, §10), measured by lpa-jars (§6).
- **The sign's fairness.** §5 names the cause, UE31's majority rule, and counts the archives where the sign could decide; lpa-offband was added, and in it the sign went falsely to T2 in 2 of 1,000 archives (§5).
- **T2's worlds had no onset.** They now have one (§6). That changed t2-field's calibration, as §6 says.
- **The gate at full size** comes mainly from T2's law form, not from the onset (§6, §10); the reader's probe is kept.
- **The numbers:** the draws' default, maxima stored, the gate's share with H1's failure included, the ranges in §1, §5 and §6, and the pilot's place and t2-field's reason corrected.
- **The text:** §2's two unlisted differences, the counting's wording and the counts T2 needs (§5), H1 failing from T2's law form (§1, §8), the sign for T2 qualified (§1, §8), the labels' "cultures" (§8), the cell's law an assumption (§3), and what is known of the cultures beyond their values (§9).

The dry runs, the pilot and the cell check were rerun after these changes, and every number in §1 to §10 is from those runs or from the reader's probe.

⟦SECOND⟧
