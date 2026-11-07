# A state named in advance, against the field's (UE31)

AI-written (a Claude Code session), 3 November 2026. Board item UE31.

Thesis T2 ([02 §5](../../theories/becoming/chapters/02-MAP.md#t2)) names the state of every renewable condition under a draw in advance: its level, its recent giving and one lag, the lag's place named before the data. The flour beetle's field names its life stages instead (the LPA model). This folder holds a test that sets the two against each other. It uses the Beetle Team archive's complete biweekly censuses of laboratory cultures whose adult loss was set by hand. The test is the route [08 §9](../../theories/becoming/chapters/08-METHOD.md#what-would-defeat-the-reading) leaves for showing that the explanatory reading does more than tie a field's state.

**The answer expected, stated before the run.**
- **On the next giving,** the field's state does better, by the life cycle alone. The pupae counted now are the next recruits, so T2's class as worded is defeated by a class of fewer variables.
- **On the adults' own course,** T2's three numbers, with the lag at the delay of renewal, tie the field's state by construction.
- **The one place where they predict differently** is the lag's sign. T2 forbids it to change; the field's model changes it with density, turning between about 76 and 91 adults by two sets of estimates, one read and one recalled. At the archive's likely size this is mostly not expected to decide in the field's world, and if it decides there, to go to the field.

If it comes out so, the reading has not shown a class named in advance that does better than a field's state. That is a finding, not a failure.

- [DESIGN.md](DESIGN.md): the design, rules, dry runs and what each outcome means (about 45 minutes to read; §1 and §10 in nine).
- [`state_rules.py`](state_rules.py): the rules, used by both the dry runs and the run.
- [`dry_runs.py`](dry_runs.py): synthetic cultures under the rival's model, its refinements and T2's law (`python3 -I -B dry_runs.py`, about 30 seconds of CPU), with output in [`results/`](results/).

**Status.** Designed and frozen on 3 November 2026, before any value of the data was read, and run the same day on Ren's yes ([his words](../../sources/15-codex-theory-conversations/2026-11-03-ue31-download-and-run.md)). It decided nothing: the cultures of the archive's adult-loss experiment, with the loss set and recruitment left to them, are too short for the frozen rules ([the result](#the-result)).

- [LAYOUT.md](LAYOUT.md): the run's first step, the archive's layout, committed before any census value was read.
- [`reader.py`](reader.py) and [`check_reader.py`](check_reader.py): the second, the reader and its check ([output](run/reader-check.out)).
- [`run/run.py`](run/run.py): the third, the frozen rules on both groups at both grains ([output](results/run.out), [every number](results/run.json)).

## The result

*About 5 minutes to read.*

**On the primary group, nothing is decided.** The archive's adult-loss experiment (its Data Set 2) holds 40 cultures: five set losses, two strains, four replicates. They run to week 36, 19 censuses, and the loss is set from week 12, so each has 13 censuses under the loss. The frozen rules read a culture from its fifth census and need 20 rows, so 25 censuses (DESIGN §5). Each of these has 8 rows. All 40 are counted too short, and every verdict on the group is *not testable*, at both grains. LAYOUT.md found this from the workbook's structure, before any census value was read, and the run confirmed it.

So the answer expected above is neither borne out nor refuted. T2's three numbers and the field's state are not compared on any culture under a draw. Each expectation stated in T2's home ([02 §5](../../theories/becoming/chapters/02-MAP.md#t2)) stands untested.

**Why.** The design assumed 41 censuses, the length of the 1997 experiment's cultures (Data Set 3), and its dry runs measured power at that length. Data Set 3 sets recruitment by hand, so the design excludes its 21 treated cultures (its 3 controls are in the control group). The archive's README and workbook were not read before the design was frozen (DESIGN §9), so the adult-loss cultures' length was first seen at the layout. This is a finding about the test, and it is recorded as one.

**One fact about the primary cultures' values.** Each was read through census 12, its last, so each had animals at the end. The run wrote no other number of theirs.

**The control group, reported only.** The design draws no verdict from it, for two reasons (DESIGN §5): an experiment holds few controls, and pooling mixes strains and parameters. With no set loss, too, a control's giving is the adults' net change, not the recruits (§4).

It has 25 cultures, with neither the loss nor recruitment set, from five experiments. Data Sets 1 and 2's 12 controls are too short. The 13 others, from Data Sets 3, 7 and 8, are read. At the census grain the rules read as the design expected of the primary group:
- **W, "the wording fails".** Beyond chance, the pupae remove a median 0.51 of the residual that T2's state leaves of the next change, against T2's bound of 0.10. They are detected in 9 of 13 cultures.
- **V2, "the rival holds".** Beyond chance, T2's numbers remove a median 0.02 of the residual that the pupae and the adults leave, detected in 1.
- **H1, "T2 holds".** A further lag removes nothing beyond chance (median −0.03), detected in none.
- **The sign, "not separated on the sign: the rival's turning point does not split the cultures".** The field's model predicts a negative lag effect in 12 cultures and none in the 13th. T2's one sign, the majority of the fitted signs, is also negative, so the two rules differ in no culture. The design's control world reached "not separated" by another route: there the rules differed in every culture, with fitted signs close to a coin's. The design says a control result beside the run says little about the sign (§8).
- **V5, not testable.** 5 cultures detected, fewer than 6.
- **V4, not decided.** T2's lean law forecast better than the level alone in 9 cultures and worse in 4 (p = 0.27).
- **Reported (V3).** The rival's error on the next change is a median 0.45 of T2's lean law's, lower in 12 of 13 cultures (p = 0.003).

The excess is the share of the residual removed, less the chance level of the columns added (DESIGN §6). The combined reading, from W, V2 and H1, is the one the design expected of the primary group: "separated on the next step: the rival's state; three numbers suffice on the course".

At the coarser grain every rule is reported only, at any threshold (DESIGN §6). At the frozen threshold 2 controls are long enough, so it is not testable. The run script also reports a threshold of 15 rows, which is not a frozen rule: it is the one `dry_runs.py` used at that grain, added to the run script after the layout gave the cultures' lengths and before any value was read. At it 9 controls are read, with the same reading on the next step and the course; the sign is not computed at that grain.

None of this tests T2. The controls are not the primary group, and the design's verdicts are on that group alone. The 13 read, at the census grain, show that the rules and the reader run on the archive's own cultures and give the shape the design expected. They do not show that cultures under a set loss would give it.

**The recording.** The reader takes a week entered twice at its second entry, after the manipulation. That choice touches only cultures too short to read, those of Data Sets 1 and 2. Data Set 10's four constant cultures equal Data Set 7's, as the reader checked, and are taken once. The reader was checked first on 55 dry-run cultures written in the archive's layout, and read every one back exactly.

**The data.** Desharnais, Robert (2023), Beetle Team Tribolium Data Archive, Dryad, [doi 10.5061/dryad.qjq2bvqmp](https://doi.org/10.5061/dryad.qjq2bvqmp). Its terms are CC0. The two files were downloaded by hand, since Dryad refuses automated download, and their sha-256 digests equal those Dryad publishes (LAYOUT.md). They are not copied into the repository. They keep their own terms, as [COMMONS.md](../../COMMONS.md) has it for datasets made by others.

**What follows.** A design that reads these cultures, made before any of their values is seen, is [UE31b](cells/DESIGN.md): the four replicates of one strain at one loss read together as one cell, ten cells, with UE31's rules at that unit and dry runs at the archive's own shape. It is not part of UE31. It ran on 6 November 2026: [below](#ue31bs-result).

<a id="ue31bs-result"></a>
## UE31b's result

*About 4 minutes to read. AI-written (a Claude Code session); no person has checked it.*

Run once on 6 November 2026, on Ren's yes ([his words](../../sources/15-codex-theory-conversations/2026-11-06-go-ahead-with-everything.md)), by its frozen script: [`cells/results/run-cells.json`](cells/results/run-cells.json) and [`run-cells.out`](cells/results/run-cells.out). The workbook's sha-256 was checked before anything was read, and the recording check let it through: 8 of 360 rows have more recruits than pupae, against the 12.5% that would stop the reading.

**The reading is the one expected, stated before the run:** "separated on the next step: the rival's state; three numbers suffice on the course", with the sign not separated. A cell is one strain at one set loss, its four replicates under one law; there are ten. "The rival" is the field's state, the pupae and the adults. "Excess" below is the share of the residual variance removed beyond chance, the median across the five set losses of each loss's median cell.

| Verdict | What it read | Result |
|---|---|---|
| W, the wording | the pupae and the adults beyond T2's three numbers | **fails**: excess 0.83 (by loss, low to high: 0.36, 0.54, 0.83, 0.83, 0.91), detected in 8 of 10 cells |
| V2, the rival's refuter | T2's numbers beyond the pupae and the adults | **the rival holds**: excess 0.004, detected in none |
| H1, the course | a further lag beyond T2's three numbers, bound 0.10 | **T2 holds**: excess 0.05 (by loss: −0.01, 0.18, 0.08, −0.00, 0.05), detected in one cell |
| The sign | the lag's sign against the rival's turning point | **not separated**: the two rules differ in 4 cells, 6 needed (each right in 2); the lag's effect positive in 8 of 10 |
| V5, the lag's sign between series | the detected cells' signs | **not testable**: 3 detected, 6 needed |
| V4, the level alone at five steps | forecasts from the cell-mates' law | **not decided**: T2 better in 5, worse in 5; median error 0.27, the level alone's 0.23 |

Reported, not verdicts: out of sample the rival's squared error was 0.06 of T2's in the median cell, smaller in all 10 (p = 0.002), and a difference between replicates that neither law carries moves this and W toward the rival, since four replicates share one law a cell (cells DESIGN §3, §8); residuals stood at 54 times the measured floor for T2's law and 7.8 times for the rival's; the lag placed one census back instead left 0.10 to a further variable, at the bound, where two censuses back left 0.05.

**What it says, in the design's own terms (§1, §8), fixed before the run.**
- T2's wording "as far as anything measured does" fails to the pupae and the adults, a class of fewer variables. That is 08 §9's defeater, met in this domain. A failure here counts against the claim for every renewable condition under a draw; it does not defeat T2 in the fisheries, nor the reading 08 §9 names.
- T2's three numbers, with the lag at the delay, suffice on the adults' own course. That is the field's own state seen from the course, a tie by construction. It is a prediction that could fail, as it does in the dry runs where the life cycle is longer, and did not. The field's model makes the same prediction, so it shows nothing the field does not. It rests on H1 and on V5 not failing, here by not being testable; it is not T2 passed.
- Their one contrary prediction is not decided by this archive, which says nothing for T2's sign. At this shape the sign could not go to the rival, and V4 never failed T2 in the field's simulated worlds (cells DESIGN §5, §6), so neither not-deciding counts for T2.
- Read after the run, not frozen: the lag's effect was detected in three cells, two negative and one positive, each the sign the rival predicts there; of the four cells where the two rules differ, the rival's two right calls are detected cells and T2's two are not. The 8 of 10 positive effects lean toward T2 only where nothing was detected.

**What it changed.** [UE32's third proposal](../state-against-embedding/T2-PROPOSALS.md#3-as-far-as-anything-measured-does-once-a-frozen-test-fails-it) waited on a frozen run that failed this wording. This is that run, so T2 in [02 §5](../../theories/becoming/chapters/02-MAP.md#t2) now says "as far as the level's own history does", with the failure kept beside it, and its first forbidden item reads a fourth variable from the level's own history. That forbids less; the loss of the broader claim stays on record.

**What it does not show.** T2's numbers doing better than a field's state: they did worse on the next giving by a wide margin, and tied on the course by construction. Anything about a condition in the field. The one contrary prediction either way. And the rival's constants come from other analyses, the unit is four replicates under one law, and the model that wrote the design may have met these cultures' series in its training text ([DESIGN §9, §10](cells/DESIGN.md#9-data-what-has-been-seen-and-the-runs-order)).
