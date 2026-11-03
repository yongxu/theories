# UE31: the archive's layout (the run's first step)

AI-written (a Claude Code session), 3 November 2026. Step 1 of the run's order ([DESIGN §9](DESIGN.md#9-data-and-what-has-been-seen)), committed before any census value is read. *About 8 minutes to read.*

## What was read

- **The files.** `BeetleTeamTriboliumDataArchive.xlsx` (224,638 bytes) and `README.md` (13,712 bytes), downloaded by hand from Dryad on 3 November 2026 (doi [10.5061/dryad.qjq2bvqmp](https://doi.org/10.5061/dryad.qjq2bvqmp), CC0). Their sha-256 digests equal the ones Dryad's API publishes (`5ce9ae43…` and `05aec05f…`). Dryad refuses automated download: its API needs a sign-in token, and its web links answer scripts with a bot check. The data keep their own terms, CC0.
- **The README**, in full.
- **The workbook's structure**, by [`run/layout_probe.py`](run/layout_probe.py), output in [`run/layout-structure.txt`](run/layout-structure.txt). It read:
  - the sheet names and each sheet's header row;
  - per culture, its identifying columns (strain, treatment and replicate codes) and its weeks.

  It counted records and blank cells. It printed no census count (L, P, A), habitat size or parameter value, and none was read.

## The worksheets

The workbook has a "Read Me" sheet with no cells and ten data sheets, "Data Set 1" to "Data Set 10". Their header rows match the README's column lists. Every sheet records one census a row, every two weeks.

| Data set | Experiment (README) | Cultures, censuses | Set by hand | Group (DESIGN §5) |
|---|---|---|---|---|
| 1 | Demographic perturbations at week 10 (Dennis et al. 1995; Desharnais and Costantino 1980) | 13: control 4, three perturbations of 3; 21 records, weeks 0–38, week 10 twice | perturbations: adults added or removed, or immatures removed, once at week 10 | control: the 4 controls; excluded: the 9 perturbed |
| 2 | **Adult mortality set from week 12** (Costantino et al. 1995; Dennis et al. 1997) | 48: 2 strains (RR, SS) × control and 5 losses (0.04, 0.27, 0.50, 0.73, 0.96) × **4 replicates**; 20 records, weeks 0–36, week 12 twice (before and after the treatment) | the adult loss, recruitment left to the culture | **primary: the 40 cultures with a loss set**; control: the 8 controls |
| 3 | c_pa set, µ_a = 0.96 (Costantino et al. 1997; Dennis et al. 2001) | 24: control 3, seven c_pa treatments of 3; 41 records, weeks 0–80 | recruitment and the adult loss | control: the 3 controls; excluded: the 21 treated (recruitment the experimenter's) |
| 4 | Chaos control (Desharnais et al. 2001) | 9: control 3, in-box 3, out-box 3; 106 records, weeks 0–210 | the control's replicate numbers (2, 13, 22) are those of Data Set 6, the c_pa = 0.35 treatment of Data Set 3; the in-box and out-box add adults | excluded, all 9 |
| 5 | Scaling of demographic noise, 20 g and 60 g (Desharnais et al. 2006) | 6; 55 records, weeks 0–108 | not stated; the dynamics are called chaotic, which in this programme came from set treatments | excluded, all 6: neither group can be read from the layout |
| 6 | The c_pa = 0.35 cultures of Data Set 3, continued (King et al. 2004) | 3; 213 records, weeks 0–424 | recruitment and the adult loss | excluded, all 3 |
| 7 | Habitat size, constant 20 g or alternating 32 g and 8 g (Costantino et al. 1998; Jillson 1980) | 8: 4 constant, 4 alternating; 36 records, weeks 0–70 | the habitat, in the alternating cultures | control: the 4 constant; excluded: the 4 alternating |
| 8 | Habitat sequence × initial condition (Henson et al. 1999, Table 1) | 18: 3 sequences × 2 initial conditions × 3; 39 records (weeks 0–76), or 71 (weeks 0–140) for one of each three | the habitat, in sequences 2 and 3 | control: the 6 at constant 20 g; excluded: the 12 cycling |
| 9 | Habitat 28 g and 12 g, three initial conditions (Henson et al. 1999, Table 2) | 12; 33 records, weeks 0–64 | the habitat, in all | excluded, all 12 |
| 10 | Habitat constant or period four (Henson et al. 2002; Jillson 1980) | 10: 4 constant, 6 period four; 36 records, weeks 0–70 | the habitat, in the period-four cultures | the 4 constant have Data Set 7's replicate numbers (13, 18, 20, 23) and length, both subsets of Jillson 1980: taken once, from Data Set 7, and the reader checks the two copies agree; excluded: the 6 period four |

## The primary group, and what the frozen rules can read of it

**The cultures.** Data Set 2's 40 cultures with a loss set: 5 losses × 2 strains × 4 replicates, so 8 at each loss. The README says three replicates; the workbook holds four.

**The recording.** One adult count a census, and week 12 twice, before and after the treatment. The adults are read as those returned to the culture after the census's manipulation (the returned form of §9). The week-12 entry after the treatment is t = 0, since the loss is set only from there. What remains open does not change the outcome below:
- the protocol's rounding;
- whether adults came from stock cultures;
- whether a count is the returned one, which the frozen protocol check of §7 would test.

**The length.** Weeks 12 to 36 give 13 censuses, t = 0 to 12. The in-sample rows run from t = 4, with t + 1 in the run, so there are 8 rows, t = 4 to 11. The frozen rules need 20 rows a culture (§5). Even the whole series from week 0, which the rules do not allow, since no loss is set before week 12, would give 14.

**So, by the frozen rules, before any value is read:**
- Every primary culture is too short and is counted, not read.
- The primary group has fewer than 6 cultures to read, so every verdict on it, and the reading, is *not testable*.
- At the coarser grain the cultures are shorter still: 7 censuses.

**The power at that shape is none.** The design's dry runs used 41 censuses, the length of Data Set 3. At 8 rows a culture no per-culture fit is possible: T2's law has 10 columns and W's and H1's 12.

**The control group.** It has 25 cultures: Data Sets 1 (4), 2 (8), 3 (3), 7 (4) and 8 (6).
- Data Sets 1 and 2's controls are too short: 20 and 19 censuses, 15 and 14 rows.
- The 13 others can be read: Data Set 3's 3 (36 rows), Data Set 7's 4 (31 rows) and Data Set 8's 6 (34 or 66 rows).
- Its rules are reported only (§5, §6). A control has no draw, so its giving is the level's net change (§4).

## What follows

The frozen design asks for this to be recorded before any value is read, with the dry runs' power at that shape (§9). The run's next two steps go on as frozen:
- the reader, checked on synthetic cultures written in this layout;
- the rules, on the primary and control groups at both grains, the output kept whatever it is.

The design's expected answer (§1, §10) is then neither borne out nor refuted on the primary group. This archive's adult-loss cultures are too short to read. That is a finding about the test, recorded as one: the frozen design assumed 41 censuses, and the experiment it chose holds 13 after the loss is set.

A design that reads these cultures would be a new frozen test with its own dry runs at this shape: for example, one fitting each loss's eight cultures together. It would be designed before any of their values is read. It is not part of UE31.
