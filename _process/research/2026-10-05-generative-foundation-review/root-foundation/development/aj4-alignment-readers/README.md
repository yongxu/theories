# AJ4: the alignment dossier, kit

Board item AJ4, 25 October 2026 ([Ren's choice](../../../../../../sources/15-codex-theory-conversations/2026-10-25-alignment-dossier.md); [the objective](../../../../../../sources/15-codex-theory-conversations/2026-10-24-alignment-community-objective.md)). The dossier is [`theories/becoming/review/ALIGNMENT.md`](../../../../../../theories/becoming/review/ALIGNMENT.md), the packet's fifth, in the format of the [philosophy dossier](../../../../../../theories/becoming/review/PHILOSOPHY.md). AI-authored throughout. The plan is [PLAN.md](PLAN.md), and the page it grew from is [DRAFT-ONE-PAGE.md](history/DRAFT-ONE-PAGE.md).

## How it was built

- **Sources.** Chapters 02, 03, 05, 07 and 08 as they stood on 25 October 2026, after MA2 (`7bdacfc28`), MA3 (`f2892e2fb`), AJ2 (`5f3e932d3`) and LA1 (`0c2163ae3`); the records each item links; LA1's README.
- **Lean.** RP2's [`lean_statements.py`](../rp2-philosophy/lean_statements.py) copied the statements. After writing, every block in the dossier was compared with the core sources by script, whitespace ignored, and none mismatched.
- **Quotations and names.** The packet's [`check_dossiers.py`](../review-packet/check_dossiers.py) checks every `Quote [path]: "…"` against its file and every backticked Lean name. It reported 0 problems once two witness names were given as the theorems inside their namespaces (`RuleShaping.SharedFlips.without_falls` and `with_rises`; `RuleShaping.Split.favours` and `shared_disfavours`). The same fix was made in 07 §6 and in D68.
- **Review.** An independent AI reader, with no part in writing the dossier, checked it against the chapters, records and Lean. Its findings, and what was taken from them, are [below](#review).

## References, as checked on 25 October 2026

Each against a publisher, catalogue, proceedings or repository record found by web search. Page ranges are given only where the record gave them.

| Work | Record checked | Note |
|---|---|---|
| Acemoglu and Robinson 2008 | *American Economic Review* 98(1):267–293, doi 10.1257/aer.98.1.267; NBER working paper 12108 (2006) | end page given as 293 or 93 across records |
| Campbell 1979 | first circulated as a Dartmouth Public Affairs Center occasional paper (1976); reprinted in *Journal of MultiDisciplinary Evaluation*; the 1979 *Evaluation and Program Planning* version only by its ScienceDirect record | pages of the 1979 version not confirmed |
| Christiano 2019, "What failure looks like" | Alignment Forum post of 17 March 2019 | an essay, not a paper |
| Cieslak, Desclaux, Fawaz and Varaiya 1988 | *IEEE Transactions on Automatic Control* 33(3):249–260; earlier as Berkeley ERL memo M86/63 (1986) | added after the review: control under partial observation |
| Clark 1976, *Mathematical Bioeconomics* | library catalogues: Wiley-Interscience, New York, 1976, xi+352 pp., ISBN 0471158569 | |
| Collingridge 1980, *The Social Control of Technology* | library catalogues (CiNii; Texas A&M): Frances Pinter, London, and St. Martin's Press, New York, 1980, 200 pp. | added after the third pass (27 October 2026), for A-10c and the page's result 9 |
| Dempster 1955 | *Cold Spring Harbor Symposia on Quantitative Biology* 20:25–31, doi 10.1101/sqb.1955.020.01.005 | added after the review; its geometric-mean result known here through secondary sources |
| Haldane and Jayakar 1963 | *Journal of Genetics* 58:237–242, doi 10.1007/BF02986143 | checked after the first pass; not cited after the second, since it treats polymorphism at a diploid locus and the two-kind model has no counterpart |
| Hendrycks 2023 | arXiv 2303.16200 (v4, July 2023) | |
| Kandori, Mailath and Rob 1993, "Learning, Mutation, and Long Run Equilibria in Games" | *Econometrica* 61(1):29–56 (Econometric Society; RePEc) | added after the third pass, for A-10b's noise bound and the page's result 8 |
| Krueger 1974 | *American Economic Review* 64:291–303 | |
| Kulveit, Douglas, Ammann, Turan, Krueger and Duvenaud 2025 | arXiv 2501.16946; a position version at ICML 2025 | |
| Lin and Wonham 1988 | *Information Sciences* 44(3):173–198 | added after the review: observability under partial observation |
| Manheim and Garrabrant 2018 | arXiv 1803.04585 (revised February 2019) | |
| Olson 1965, *The Logic of Collective Action* | Harvard University Press, Harvard Economic Studies 124; De Gruyter record | |
| Omohundro 2008, "The Basic AI Drives" | *Artificial General Intelligence 2008*, IOS Press, Frontiers in Artificial Intelligence and Applications 171, pp. 483–492 | posted online November 2007 |
| Piatti and others 2024, GovSim | NeurIPS 2024 (proceedings and poster pages); arXiv 2404.16698 | added after the review |
| Price 1970, "Selection and covariance" | *Nature* 227:520–521, doi 10.1038/227520a0 | |
| Ramadge and Wonham 1987 | *SIAM Journal on Control and Optimization* 25(1):206–230, doi 10.1137/0325013 | |
| Rankin, Bargum and Kokko 2007 | *Trends in Ecology & Evolution* 22(12):643–651, doi 10.1016/j.tree.2007.07.009 | |
| Schaefer 1954 | *Bulletin of the Inter-American Tropical Tuna Commission* 1(2):27–56 (IATTC copy); reprinted in *Bulletin of Mathematical Biology* 1991 | |
| Stigler 1971 | *Bell Journal of Economics and Management Science* 2(1):3–21 (RePEc) | |
| Tullock 1967 | *Western Economic Journal* 5:224–232 | |
| Turner, Smith, Shah, Critch and Tadepalli 2021 | as checked for the philosophy dossier: NeurIPS 2021; arXiv 1912.01683 | |
| Young 1993, "The Evolution of Conventions" | *Econometrica* 61(1):57–84, doi 10.2307/2951778 (Econometric Society; RePEc) | added after the third pass, as for Kandori, Mailath and Rob |
| Zhuang and Hadfield-Menell 2020, "Consequences of Misaligned AI" | NeurIPS 2020 (proceedings reviews page); arXiv 2102.03896 | |

The draft page also cites Critch 2021, "What Multipolar Failure Looks Like, and Robust Agent-Agnostic Processes". The Alignment Forum post was found, but its date was not shown in the records. The dossier does not cite it.

<a id="references-as-checked-on-31-october-2026"></a>
### Checked on 31 October 2026

For the credits the edition of that day lists outside quotations (the fourth pass's F15 and F16), each against a publisher, catalogue, journal or repository record found by web search. The works RF's sentences cite were checked by RF against their texts ([provenance](#provenance-of-the-dossiers-additions)).

| Work | Record checked | Item |
|---|---|---|
| Alboszta and Miękisz 2004, "Stability of evolutionarily stable strategies in discrete replicator dynamics with time delay" | *Journal of Theoretical Biology* 231:175–179, doi 10.1016/j.jtbi.2004.06.012; arXiv q-bio/0409024 | A-10c |
| Arthur 1989, "Competing Technologies, Increasing Returns, and Lock-In by Historical Events" | *Economic Journal* 99(394):116–131 (RePEc) | A-10b, A-10c |
| Aumann, Hart and Perry 1997, "The Absent-Minded Driver" | *Games and Economic Behavior* 20(1):102–116 (RePEc; the second author's page) | A-20 |
| Biggs, Carpenter and Brock 2009, "Turning back from the brink: detecting an impending regime shift in time to avert it" | *PNAS* 106(3):826–831, doi 10.1073/pnas.0811729106 | A-10c |
| Cowan 1991, "Tortoises and Hares: Choice among Technologies of Unknown Merit" | *Economic Journal* 101(407):801–814 (RePEc) | A-10c |
| David 1985, "Clio and the Economics of QWERTY" | *American Economic Review* 75(2):332–337, Papers and Proceedings | A-10c |
| Gardner and West 2010, "Greenbeards" | *Evolution* 64(1):25–38, doi 10.1111/j.1558-5646.2009.00842.x | A-10b |
| Granovetter 1978, "Threshold Models of Collective Behavior" | *American Journal of Sociology* 83(6):1420–1443, doi 10.1086/226707 | A-10b, A-10c |
| Harsanyi and Selten 1988, *A General Theory of Equilibrium Selection in Games* | MIT Press, xiii+378 pp. (CiNii; RePEc) | A-10b |
| Hofbauer and Sigmund 1998, *Evolutionary Games and Population Dynamics* | Cambridge University Press, doi 10.1017/CBO9781139173179 | A-10b |
| Odling-Smee, Laland and Feldman 2003, *Niche Construction: The Neglected Process in Evolution* | library catalogues: Princeton University Press, Monographs in Population Biology 37 | A-10 |
| Oliver, Marwell and Teixeira 1985, "A Theory of the Critical Mass. I." | *American Journal of Sociology* 91(3):522–556 | A-10b |
| Piccione and Rubinstein 1997, "On the Interpretation of Decision Problems with Imperfect Recall" | *Games and Economic Behavior* 20(1):3–24 (RePEc; LSE repository) | A-20 |
| Schelling 1973, "Hockey Helmets, Concealed Weapons, and Daylight Saving" | *Journal of Conflict Resolution* 17(3):381–428 (RePEc) | A-10b |
| Schelling 1978, *Micromotives and Macrobehavior* | library catalogues: W. W. Norton, New York, 252 pp. | A-10b, A-10c |
| Skyrms 2004, *The Stag Hunt and the Evolution of Social Structure* | Cambridge University Press, ISBN 9780521826518 | A-10b |
| Soares, Fallenstein, Yudkowsky and Armstrong 2015, "Corrigibility" | Workshops at the Twenty-Ninth AAAI Conference on Artificial Intelligence (AI and Ethics), Austin, January 2015 (MIRI; FHI) | A-20 |

<a id="references-as-checked-on-4-november-2026"></a>
### Checked on 4 November 2026

For the two credits A-10b lists outside quotations since 3 November 2026 (board item AJ8), at edition 2 (board item ED2), each against a journal or repository record found by web search.

| Work | Record checked | Item |
|---|---|---|
| Fudenberg and Imhof 2006, "Imitation processes with small mutations" | *Journal of Economic Theory* 131(1):251–262, doi 10.1016/j.jet.2005.04.006 (RePEc; Harvard DASH) | A-10b |
| Nowak, Sasaki, Taylor and Fudenberg 2004, "Emergence of cooperation and evolutionary stability in finite populations" | *Nature* 428(6983):646–650, doi 10.1038/nature02414 (RePEc; Harvard DASH) | A-10b |

<a id="review"></a>
## Review

An independent AI reader, a separate agent with no part in writing the dossier, made two passes on 25 October 2026. A third, on 27 October, read what was added after them.

**First pass: 44 findings** (14 errors, 24 imprecisions, 6 style points), all taken. The commonest kinds were these.
- **Hypotheses dropped:** start conditions, "the shapers present", "met before the step", eligibility, balance on what couples in.
- **Witnesses stated as laws:** `Alternating`, `Split`.
- **Theorems cited above their strength:** "raises" where the theorem gives "not lower"; "derived" for an equivalence.
- **A reading stated as a theorem:** the meta-attractor link.
- **Evidence given selectively:**
  - SE1's verdict was softened;
  - CG1's failure of D2b in both rounds was missing;
  - the seed count was wrong.
- **A wrong credit:** partial observation in supervisory control.

The same faults in 07 §6's readings and in D68 were fixed there too.

**Second pass: 23 findings remaining or new** (6 errors), taken in the dossier, 07 §6 and D68.
- **Errors:**
  - locked and open settings classed by best response, not by whether the rest empties the resource;
  - the second-order sentence proved only in its conditional form, at a step;
  - the counter-rule stated in its two cases: every rule read favours, or the reading favours above a threshold;
  - the opening of 07 §6's block, where the lock needs every rule read to favour.
- **The assistance reading's laws cited exactly:** `lower_c_raises` with `favours_iff`; `shared_lowers` with `shared_raises`; `SharedFlips.with_rises` for a stretch.
- **Credits:**
  - Clark and Pikitch quoted from the horizon record;
  - Arthur placed in the reading where 02 §9 gives him;
  - A-10's known forms quoted from its record;
  - the stretch law credited as the haploid case of the geometric-mean rule, to Dempster alone.

**Fixed by their owners:**
- 02 §9's "a smaller cost raises it" in MA3's home section, fixed by MA3's owner the same day ("a smaller cost gives a rule not lower", landed with `bf2576f19`);
- 08's credit for partial observation, and its T7 row that predated LA2, corrected by the board's coordinator the same day (`456e0a3b7`), with the three lines of the dossier that quoted them.

**Third pass, 27 October 2026: 46 findings** (12 errors, 25 imprecisions, 9 style), on what was added after the second pass alone: A-10b, A-10c, A-19 with its lines in A-09 and A-10, and the page draft's results 8 and 9 with the lines resting on them and its LA2 and LA3 bullets. The reader was a separate agent with no part in writing them, read-only, checking against the records, the home sections, the Lean and the tests' frozen predictions and results files ([its report](REVIEW-THIRD-PASS.md)). All taken, a few in other words, in the dossier, the page draft and chapter 7's *The two joined*, *Read in time* and *Tests*; the same faults in this session's lines on LA2 in 02's T7 paragraph and 08's table of theses, and LA3's call count and failure heading in its README, were fixed with them. The commonest kinds:
- **Evidence above its strength:**
  - LA2's in-time pass came from the readers' counts, its control turning in 4 of 5 seeds with nothing reading the loss;
  - two contrasts, not only the late verdict, rest on the late course's tie;
  - "the third forbidden case occurs" was given without the frozen rule that printed it as not supported;
  - LA3's free-rider framing was named as the cause of the seeds that never tried shaping, though every seed gave it and the run does not say why;
  - post hoc readings were unlabelled.
- **Wrong:**
  - LA2, run before MA4b existed, was presented as a failed test of A-10c's law, where it tested A-09's;
  - the page put the late course's end share against its start, where it equals the share at step 4;
  - the page gave D68 the readings of results 8 and 9.
- **Hypotheses dropped:** `lo ≤ hi` in result 8's headline and the lines resting on it; shapers present; the deadline's hypotheses; ties; a law cited by its witness alone.
- **Credits:** risk dominance, discrete-time replicator selection, with and without a lag, path dependence and the greenbeard, quoted from the records; Collingridge moved inside the record's quotation, and checked with Kandori, Mailath and Rob and with Young into the table above.
- **Limits left out:** the records' other not-shown items, for A-10b learning readers and starts not under the rule read there, for A-10c noise and learning readers; that the lock half is near-definitional; that the claims about late readings of other forms are not in the Lean.
- **After the pass, 30 October 2026:** AJ5 restated the joint selection's first condition on 29 October, from "control is not selected" to "control of the rule is not captured", telling capture from accountable revision. The texts that called the four combinations of control selected or not with a lock left or not "the two conditions" now name them so and say that the models do not tell capture from accountable revision: 07 §6's *Read in time*, the dossier's Part 2 opening, A-10b, A-10c (its weakness, its standing and a third question) and the page (its reading on control, results 8 and 9, question 6). No independent reader has read them.
- **"The converse":** the two records used the word for opposite cases. The records' owner took it in MA4b's record (`047b090f7`), and MA4's record keeps the word in one sense. The owner also noted that the case not shown depends on how condition 2 is read. Read for the shapers' capture alone, it is control left unselected with that capture kept. Read for any lock that forms, as the plan states the condition, it is both conditions together. Either way three of the four combinations occur. The dossier (A-10b, A-10c and a third question there), the page (results 8 and 9, the bullet on getting out of a lock, a sixth question) and chapter 7 §6 now name both (27 October 2026).

**Fourth pass, 31 October 2026: 42 findings** (16 errors, 20 imprecisions, 6 points of readability), on the edition sized for a person: its ten-minute section, the cut items, A-18 to A-20 and its provenance. Most were hypotheses dropped in the cut, or regressions of the third pass's fixes. How they were taken is [below](#the-fourth-pass-taken). **Its re-check, the same day:** no error; 38 findings resolved and 4 in part, the fixes adding no error; 12 smaller points (7 imprecisions, 5 of readability, style or timing), all taken ([below](#the-re-check-taken)).

## The edition of 31 October 2026: sized for a person

Ren, 31 October 2026, on whether the dossier's latest additions should be checked before the packet is sent: "let's get everything ready before presenting to humans. you can easily read 100k tokens, but we as human can not. please" ([source](../../../../../../sources/15-codex-theory-conversations/2026-10-31-ready-for-human-readers.md)).

**What a reader met before.** The dossier was 14,817 words, 3,016 of them before its first item: a summary, a box of 1,100 words on what the theory does not address, which had grown with each landing of RF and RR, a provenance list of 900 words and the terms. Five items (A-10, A-10b, A-10c, A-18, A-19) held 6,437 words between them, much of it chains of quotations crediting known forms and the history of each review. The page this kit drafted for alignment readers, [DRAFT-ONE-PAGE.md](history/DRAFT-ONE-PAGE.md), had grown from "one page, readable in ten minutes" ([PLAN](PLAN.md)) to 5,503 words.

**What changed** (AI-authored, no result, chapter or record changed):
- **The dossier in ten minutes** opens the dossier: the question with the joint selection's three conditions, the terms its results use, seven results with the hypotheses that decide them, readings for alignment, what is not claimed, and the times. **The tests, as they fell** follow in three minutes: what failed, what held and what is untested. Together they replace the draft page, which moved to [history/](history/) by `research.py move`: one text, not two. The questions for the whole close the response form.
- **The items** and compact **terms** follow; the box became item **A-20** (complying when read, holding an act for a stop, letting a revision through), with its claims as RF and RR wrote them and their records' limits, so that a reviewer can give it a verdict.
- **A-10, A-10b, A-10c, A-18 and A-19** were cut to their statement, meaning, standing, weaknesses and questions. Credits keep each record's own sentence on what is new; the names it credits are listed, not quoted. A-10c keeps one Lean block. Each landing's history left the items for this section.
- **Provenance** moved to the end of the dossier, with the full list below, verbatim.
- **Reading times**, by [the kit's measure](kit/measure_layers.py) at 100 to 130 words a minute, after the fourth pass and its re-check were taken and RF-M.3's passage and RR2's sentence placed: the front with the title, 1,100 words, 8.5 to 11 minutes; the tests, 358 words, 2.8 to 3.6; the one-hour path with both, 5,357 words, 41.2 to 53.6; A-20, for deception or corrigibility, 1,836 words, 14.1 to 18.4 more, stated on the front as eighteen; the whole dossier, 14,076 words and 50 lines of Lean, 108.3 to 140.8 minutes, stated on the front as 105 to 145, the range the packet's cover gives since RP's reading times. After the re-sync of 3 November 2026: the front 1,098 words, 8.4 to 11; the tests 388 words, 3.0 to 3.9; the one-hour path, now without A-14, 5,999 words, 46.1 to 60; the whole dossier 16,417 words and 50 lines of Lean, 126 to 164 minutes, stated on the front and the cover as 125 to 165. After A-18 took LA4's results, HP, AF1 and AJ8 (all 3 November 2026): the front 1,170 words, 9.0 to 11.7, 70 over; the one-hour path, now without the tests' summary, which A-18 and A-19 give in full, 6,069 words, 46.7 to 60.7, 69 over, both excesses recorded in [READING-BUDGETS](READING-BUDGETS.md); the whole dossier 17,471 words and 50 lines of Lean, 134.4 to 174.8 minutes, stated on the front and the covers as 130 to 175. With A-10's limits on groups (AJ8b, 3 November 2026): the one-hour path 6,104 words, 47.0 to 61.0, 104 over; the whole 17,506 words and 50 lines of Lean, 134.7 to 175.1 minutes, stated on the front and the covers as 130 to 180. Toward its ten minutes (AT, 4 November 2026): the front 1,193 words, 9.2 to 11.9, 93 over, stating nine to twelve minutes; the one-hour path 6,127 words, 47.1 to 61.3, 127 over; the whole 17,563 words and 50 lines of Lean, 135.1 to 175.7 minutes, still within 130 to 180. With A-10's groups of unequal size (US, 4 November 2026): the one-hour path 6,176 words, 47.5 to 61.8, 176 over; the whole 17,612 words and 50 lines of Lean, 135.5 to 176.2 minutes, still within 130 to 180. For edition 2 (ED2, 4 November 2026), after its reader's five rounds: the front 1,201 words, 9.2 to 12.0, 101 over, still stating nine to twelve minutes; the one-hour path 6,693 words, 51.5 to 66.9, 693 over, by A-02's re-reading law and limits, A-10's "without noise" and A-19's account of what LA2 does to T7 with its qualifiers, recorded in [READING-BUDGETS](READING-BUDGETS.md), and stated on the front as 50 to 70 minutes; the whole 19,004 words and 50 lines of Lean, 146.2 to 190.1 minutes, stated on the front and the covers as 145 to 195.

**Landing notes dropped from the items' standings:**
- A-10: "Theorem (counts), landed 25 October 2026 after an independent AI review narrowed three claims: p does not change the direction *at a step* only; `byBack_reads_iff` is an equivalence, not a derivation of `ReadsShare`; only the numbers of steps matter, and the verdict depends on a."
- A-10b: "Theorem (counts), landed on 26 October 2026 (board item MA4), after both of this dossier's review passes."
- A-10c: "Theorem (counts), landed on 26 October 2026 (board item MA4b), after both of this dossier's review passes."

<a id="the-fourth-pass-taken"></a>
### The fourth pass, taken

An independent AI reader read the edition at `b61aa5bbd` on 31 October 2026 ([its report](REVIEW-FOURTH-PASS.md)) and found 42 problems, 16 of them errors. Most lay in the ten-minute section, which had dropped hypotheses that decide its results and misreported the tests, and in the provenance, which claimed citation checks not made; the cut items' faults were mostly regressions of fixes the third pass had made. Each finding was checked against its source (the Lean statement, the chapter, the record or the experiment's README) and held. All were taken, as proposed except where said:
- **The ten-minute section** (F1, F3 to F8, F17 to F22, F37, F38, F41, and F42's first point): each result states the hypotheses that decide it, the terms its results use are defined where it begins, and the question names the joint selection's three conditions. To keep ten minutes with these, the tests became a section of their own after it, and the five questions for the whole moved, with Q3 completed, to the response form. A-03's half of result 2 (F3, F17) stays in its item, which states it with its hypotheses, and the dossier's note on instrumental convergence moved to A-03.
- **The tests** (F9 to F13, F23, F29, F30): taken in the new section and in A-18. F9's "no language model was trained" holds: IN2, which would have fine-tuned one, was dropped before any training job ran. One correction beyond the findings: IN1's own frozen predictions, on installing the direction by instruction, mostly failed (H1 to H3, H5 and D1 in its first round; with talk, R1 to R4 held for gpt-5.4-mini and R2 alone for gpt-4.1-mini), which neither the edition nor the finding reported; both the tests and A-18, whose IN1 row now links its README, say so. F11's flaw was also in chapter 5's T3 ("no frozen test on a trained system yet does"); its owner corrected it in AJ6b (`2c8aa0fb3`), and A-18 follows the corrected text.
- **Provenance** (F15, F36): the seventeen works the edition listed outside quotations unchecked were checked against publication records ([above](#references-as-checked-on-31-october-2026)); the works RF's sentences cite had been checked by RF against their texts. F36's wording was taken.
- **The items** (F2, F14, F16, F24 to F28, F31 to F35, F39, F40, F42): taken. For F33 the theorems are named (`ChoiceOccasions.above_in_every_iff_reach`, `ChoiceOccasions.both_ways_of_unreached`, `Learning.free_lumped`, `Learning.twin_selected`, `ReadingLoop.alike_within`, `ReadingLoop.Untested.model_or_order`); for F31 the label is the home sections' (natural-number weights and values, read as probabilities where valid; near-definitional, with witnesses; for holding, none claimed new as mathematics).
- **Restored**, a never-cut item the edition had dropped: that assistance informing the principal adds coupling, which A-12's law does not model, and that the principal's own state and learning are not represented (A-12's weaknesses).

<a id="the-re-check-taken"></a>
### The re-check, taken

The same reader re-checked the fixes at `13367d5f5` ([its report](REVIEW-FOURTH-PASS.md#the-re-check-at-13367d5f5)): no error, 38 findings resolved and 4 in part (F1, F28, F31, F36), and 12 smaller points. Each point was checked against its source and taken, as proposed except where said:
- **The ten-minute section** (R1, R11, R12): result 1's "exactly when" is said of every selection through the couplings together, as `Web.selects_alike_iff` states it; result 7's list is of formations at steps, as `Becoming.Weightings` lists its items; A-20 is said to add ten minutes beyond the hour (fifteen since RF-M.3's passage was placed in it, eighteen since RR2's). To stay within 1,100 words, the question's list of selections lost three articles.
- **The tests** (R6, R8): LA2's exact ties, and the counts that turned its control, moved to Held, where they qualify its verdicts; the fishers' keeping nothing unseen is traced to IN1's R2 and H3's first clause, and A-18's IN1 row says that H3 failed on its gap clause only.
- **A-18** (R3, R5): R3 was settled at its source, AJ6b (`2c8aa0fb3`) correcting chapter 5's T3, so the first weakness follows the chapter as it now reads: CG1 (C1, its second round) and IN1 show the drain beyond the reward's couplings, and no test yet varies how near a trained system comes to its reward's optimum. EM1's row draws CG2's limit from X2 (`k3s1_lam32`, weighted sixteenfold, kept the stock), not from E1.
- **A-10, A-10c and A-20** (R2, R4, R9, R10): A-20's standing gives the first three results' labels and, apart, those of what acts show as 03 §11 and §12 give them (any types, near-definitional or by a witness), and the choice laws keep their hypothesis, no cycle shown; A-10c's last weakness says "with the readings it was shown", as A-10b does; K4 is glossed where A-10 first names it; A-10c's standing said once that only the first condition was reworded, until MA4c's wording, which quotes chapter 2's reading of both conditions, replaced it when MA4c landed (`485c6f87c`).
- **Provenance and times** (R7, R12): the dossier's line says that the fourth reader read the edition before and after its findings were taken, and that the last one-line edits have not been read again; the 31 October table has its own anchor; the reading times above were measured again, the tests' 2.8 to 3.6 minutes as measured in place of the proposed "3 to 3.5".

<a id="rf-m3s-placement-checked-by-its-owner"></a>
### RF-M.3's placement, checked by its owner

RF-M.3's dossier text was placed by role when AJ4 merged its landing (`4b33fce37`; [provenance](#provenance-of-the-dossiers-additions), RF's line). RF-M.3's owner checked the placement against the Lean, the record and 03 §12 on 31 October 2026; its report, verbatim:

> I checked AJ4's placements of RF-M.3 on aj4-human (4b33fce37) against the Lean, the record and 03 §12, and none misstates the result.
> - A-20's bullet: the four names exist and carry what the bullet says (shortfall_split, least_falls, revalued_split, TwoWorlds.not_lumped). "From different starts … need not tell whether the valuation changed" keeps not_lumped's scope: for T ≥ 2, the record, the start left out, does not determine `changed`. "A route informing and one revaluing" fits the witness: on route false the valuation stays `agree`, and on route true it changes from `reversed`.
> - The standing's "with the valuation's scale supplied … executable witnesses on one blanketed law" is 03 §12's label.
> - The new weakness is supported. Its first sentence is 03 §12's Reading ("with no choice by the holding formation among them represented") with the record's Does-not-show item on planning over several steps. Its second is the record's item "A criterion of legitimate, desired or autonomous change of a valuation …". Carroll, Dragan, Russell and Hadfield-Menell (2022) is the work RF's plan §8 cites for induced preference shifts.
> - A-12's clause, "the principal's learning beyond filtering by what it is shown is not represented", is the record's own item, said of the reading formation.
> Nothing to fix from my side.

<a id="rr2s-placement-checked-by-its-owner"></a>
### RR2's placement, checked by its owner

RR2's sentence was placed by role when AJ4 merged its landing (`415ae7556`; [provenance](#provenance-of-the-dossiers-additions), RR2's line); the bullet was then revised to say that a plan's excess is its distance from the pointwise best only where the plan splits the weights. RR2's owner checked both against the Lean, the record and 07 §7 on 31 October 2026; its reports, verbatim:

> RR2 owner on AJ4's placement (415ae7556, ALIGNMENT.md A-20): nothing misstated.
> - Lean names: the three names exist on main with the meanings the bullet gives. `RevisionPlans.above_iff` takes two plans each splitting the weights. `HeldForReading.excess_held` makes holding for a rule a plan whose excess is the rule's shortfall. `RevisionPlans.above_iff_routes` puts RR's order at one candidate of value V and gain-loss 0.
> - Splitting the weights is the deciding hypothesis, and the bullet states it.
> - The 07 §7 quote matches main verbatim, and the [AI reading, RR2] label is right.
> - The limit is right: Maximal is not choice, and the reviser's rule is supplied, so neither the plan taken nor an actual reviser's shortfall is shown.
> - Question 2's wording and the Standing line ("near-definitional, with witnesses", none claimed new as mathematics) fit the record.
> Record it as checked.

> RR2 owner on the revised A-20 item 1: both claims hold, and nothing is misstated.
> - "Such a plan" holds by `RevisionPlans.splits_held`: holding for any rule, forgoing any amount, splits the weights, with no hypothesis.
> - "Splitting its weight where read as probabilities" holds by `RevisionPlans.splits_ofRoutes (valid : s.Valid)`: the revision and every route split the candidate's weight T, as k and T − k, exactly under RR's Valid. The order is the same without Valid (`above_iff_routes` takes no hypothesis), so placing the qualifier on the splitting alone is right.
> - The fifth reader's point is right too: the excess is the distance from the pointwise best only for a plan that splits the weights. That is `gainOf_reading` at amount 0, with `balance` and `above_iff` both taking Splits for each plan.
> Record it as checked.

<a id="provenance-of-the-dossiers-additions"></a>
## Provenance of the dossier's additions

The dossier's list as it stood at `549d7c7ee`, before the edition of 31 October 2026, moved here verbatim with its links rebased; MA4c's line, added to the dossier's list on main after that, was moved here when MA4c landed, RF-M.3's changes to RF's line when RF-M.3 landed, and RR2's line when RR2 landed. "The box above" and "below" refer to that earlier layout, in which the box on what the theory does not address stood at the dossier's front; its sentences on RF and RR are now A-20, and its caveat on assistance that informs the principal is one of A-12's weaknesses.

**How it was made.** Everything in the theory was made with AI: the Lean proofs, the chapters, the readings, the tests and this dossier. No human has reviewed any of it.
- A script copied the Lean statements from the source files ([`lean_statements.py`](../rp2-philosophy/lean_statements.py)).
- The packet's script checks every quotation against the file it names and every Lean name against the sources.
- The prose is AI-written and may be wrong. An independent AI reader reviewed the dossier in two passes. It found 44 problems, then 23 remaining or new ones. They were taken, in this dossier, in the readings it quotes and, by their owners, in A-10's home section and in the method chapter.
- Two results here (A-09, A-10) landed on 25 October 2026, the day this dossier was written. A-10 was revised after its own independent AI review before landing: three of its claims were narrowed and its names changed.
- Added after both review passes: A-10b and A-10c (MA4 and MA4b, landed on 26 October 2026, each after its own independent AI review), and A-19's results with the lines on them in A-09 and A-10 (LA2 and LA3, run on 25 and 26 October 2026). A third pass by an independent AI reader read these alone on 27 October 2026 and found 46 problems (12 errors), all taken ([the kit](README.md#review)). LA1b's and LA1c's rows and lines in A-18 (run on 27 and 28 October 2026) were added after that pass, and no independent reader has read them.
- Added on 29 October 2026 (board item AJ5), after the twenty-first review, an AI review: the box on what the theory does not address, the link to the collective page, and A-18's note on what the LA1 series tests. No independent reader has read the link or A-18's note; RF7's cold read read the box whole (below).
- Added on 29, 30 and 31 October 2026 (board item RF, formations that read): the paragraph on RF's rounds in the box above, its clauses on deception, assistance games and corrigibility as an incentive, "or addresses only in part" in its title and "or only part" in its lead, and its quotation of chapter 7, shortened where chapter 7's row changed. Round 1's sentence was drafted from a finding of the cold read of round 1's texts and written at RF's merge with main; round 2's first sentence was cold-read before its landing; RF7's cold read, by AI readers, one of them an independent cross-model reader, read the whole box ([RF's reviews](../rf-formations-that-read/PLAN.md#13-the-review-and-what-was-taken)). The work RF7's sentences cite, Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant (2019), was checked against the paper's text (arXiv 1906.01820). RF-M.2's sentences, added on 30 October 2026, were cold-read before its landing, and the works they cite were checked against their texts (arXiv 1611.08219 and 1709.06275, and Good's note in the British Journal for the Philosophy of Science, 1967). RF-M.3's sentences and its changes to the assistance-games clause, to round 2's first sentence and to RF-M.2's last sentence, made on 31 October 2026, were cold-read before its landing, and the works they cite were checked against their texts (Kamenica and Gentzkow's paper in the American Economic Review, 2011, and arXiv 1908.04734 and 2204.11966). AJ4 placed them by role in the edition when it merged RF-M.3's landing, their words kept: the assistance clause in A-12's weaknesses, the result in A-20's meaning, with A-20's title, its reading in A-20's standing and its limits in A-20's weaknesses, where a limit from 03 §12 was added (no choice among informing, revaluing and holding represented); round 2's first sentence has no counterpart in the edition. RF-M.3's owner checked the placement against the Lean, the record and 03 §12 and found nothing misstated ([its report](#rf-m3s-placement-checked-by-its-owner)); no independent reader has read it.
- Reframed on 30 October 2026 (board item AJ4), for the first condition as restated on 29 October: Part 2's opening, A-10b's and A-10c's lines on control left unselected and a lock left in time, the note on the first condition in A-10c's standing, and A-10c's third question. No independent reader has read them.
- Added on 30 October 2026 (board item RR, corrigibility on the map): in the box above, the corrigibility bullet's "in part", its first sentence, the lead of RF's sentence naming the part it reaches, and the clause on trained systems, after a cross-model review of the Lean and the texts, every finding taken ([RR's review](../rr-revision-routes/REVIEW.md)).
- Reworded on 30 October 2026, after AJ4's reframing above (board item MA4c, by the records' owner): chapter 2's reading of A-10c's result and its record's scope item, for the restated first condition; A-10c's standing follows that reading, quoting it, and drops the note on the earlier wording. No independent reader has read them.
- Added on 31 October 2026 (board item RR2, the routes of keeping and holding for a reading on one order): in the box above, the corrigibility bullet's sentence joining the two, after a cross-model review of the Lean and the study, every finding taken ([RR's review](../rr-revision-routes/REVIEW.md#rr2-the-independent-review-of-the-join-and-its-re-check)). AJ4 placed it by role in the edition when it merged RR2's landing, its words kept: the sentence in A-20's meaning, followed by 07 §7's statement of the order with the hypothesis that decides it, plans splitting the weights, for which alone a plan's excess is its distance from the pointwise best (a point fm-rf3's fifth reader made of the same result in the failure-mode map), and what joins the two; the label (near-definitional, with witnesses; none claimed new as mathematics) and chapter 7's reading in A-20's standing; the record's limit in A-20's weaknesses; and the routes of keeping in A-20's second question. RR2's owner checked the placement, and its revision for the splitting, against the Lean, the record and 07 §7 and found nothing misstated ([its reports](#rr2s-placement-checked-by-its-owner)); no independent reader has read it.
- Re-synced on 3 November 2026 (way now's item 5; [the steps](../review-packet/FREEZE-STEPS.md), steps 1 to 4), from the edition's pin `3ada8819f`; much of what A-05, A-15 and A-18 gained is older than the pin, found by reading. Added: in A-16 the condition's whole gloss, C's exact role ("in general alone", from PF3), the one case self-concern ranks with no C and self-concern under the condition, with their limits; in A-17 the law of a common response, which 07 §5 joins to the direction's premises, and a question on it; in A-18 what T3 forbids and what refutes it, the second case's partial proof, when T3 was first worded relative to the tests, a row for CG3, LA4 not run and how the forbidden list has moved, with a question on units against couplings; in A-15 T5's tests, VD1 having failed; in A-05 a note that an unread choice can still move under gradient; in the tests, CG3's failed forms and LA4 frozen on nothing; in the labels, *Root*. Corrected: Part 2's opening, where the goal's wording had changed on 1 November; the front's sentence on the collective question, to the page's strength; and two sentences on which results use a premise, since A-16 now reports one that takes the condition as a hypothesis. The hour's path dropped A-14, most of whose formal content A-10 states and whose reading Part 3 keeps, to stay within its budget. Read and left out, none bearing on what an item asks: the three laws on a formation's blanket, the rooms tested by a window, the three on giving that waits, degeneration from a horizon, the lumping change, 07 §4.1's wording of regions, and P-21's J1 to J2. A-20 is unchanged: what it states of 03 §11 and §12 still holds. The one argument's step 6 gained a passage on the direction and its rivals, a cold reader's question, and its stated time moved to 25 to 35 minutes; LA4's design took corrections to F2's line and to what P3's outcome would refute. The independent read, its re-check, a narrow last check and how each finding was taken: [the read](REVIEW-RESYNC.md).
- Shortened on 3 November 2026 (board item HP), the hour having run past an hour at 100 words a minute since A-18 took LA4's results: the hour's path leaves off the tests' summary, which A-18 and A-19 give in full, and A-18 took what the summary said that they did not: what is untested, two clauses of LA4's row and its nesting site, and EM1's linear learners. An independent AI reader, read-only, read the change; its findings were checked against the sources and taken, among them A-18's and the summary's "the arms' landings" rising, now the unanchored arms', since the anchored arm's stayed at 0.10. AJ8's results and AF1's, landed that evening, took the hour and the front past their budgets; HP shortened the front's sentence on groups to words, A-10 giving its condition and now the definition of ρ, and kept the rest, its excess recorded ([HP's record](../review-packet/HOUR-PATHS.md)).
- Timed on 3 November 2026 (board item AH), after TS2 had given the sciences front's hour sentence its path's time: the hour sentence names its six items and gives them, with the front's section, the measured time rounded out to five minutes, as READING-BUDGETS' stated times are, rather than cutting the path further. No reader has read the sentence; its figures are the measure's ([HP's record](../review-packet/HOUR-PATHS.md#the-times-stated)).
- Brought toward its ten minutes on 4 November 2026 (board item AT, the coordinator's item): one sentence cut that the list of items says in the same terms, a pointer to Part 3's other two readings, and the front's section given its measured time, nine to twelve minutes. An independent AI reader, read-only, checked the front against the dossier's fuller part. It found nothing false and nothing more to cut that was only repetition. It found three hypotheses the front had dropped, all put back: groups of equal size in item 4's sentence on groups, a reading formed monotonically in item 3, and readers counted as the population counts them in item 5. Of its five smaller points, four were taken: the AI label on locating goal misgeneralization, A-04 beside A-12 as what that reading rests on, the reason clause of the capture bullet, now quoted in Part 2's opening from 07, and an ambiguous "with it" restored to "with this section". One was left: A-11's "at a step", which item 4 states. A narrow re-check found the fixes match their sources. The excess is recorded in [READING-BUDGETS](READING-BUDGETS.md).
- Re-synced for edition 2 on 4 November 2026 (board item ED2; [the steps](../review-packet/FREEZE-STEPS.md), steps 1 to 5), from edition 1's frozen commit `0f1d9aa13`. Added: in A-02 the re-reading deadline, read by analogy as the timing of Zhuang and Hadfield-Menell's remedy, and the four limits 05 gives; in A-04 drawers in turn, with the profiles shown perfect and the record's credits; in A-08 T7's scope without noise, its new forbidden case and its *Refuted by*; "without noise" in A-09, A-10, A-10c and the front's items 3 and 6, as their homes say; in A-10b the drawn chain's premises and `lost_ge`'s bound; in A-14 the groups' equal size; in A-19 the case LA2 met, by LA2's number and 02's, and, once T7C landed that day, what LA2 does to T7 in 02's words, in A-19 and the tests' Failed line; A-04's credits inside quotations of their record. An independent AI reader, read-only, read the changes and the flagged items left unchanged in five rounds, the last two on T7C's change and its fixes; its findings were checked against the sources and taken, but for the plan's restatements of the group law (their owner's), 02's and 08's wording of the case LA2 met (passed to its owner) and the reading time (set by the measure).
- Re-synced for edition 3 on 5 November 2026 (board item ED3; [the steps](../review-packet/FREEZE-STEPS.md), steps 1 to 5), from edition 2's frozen commit `7735fa07a`. AA's errata had corrected chapter 5 §7's first limit that day (E12), and their landing gave A-02 the one-step law of exchange in place of the drain falling only where units are shared, read by that landing's own reader. This pass added the record's conditions to A-02's quotation; named the earlier work's meta-attractor apart from the theory's in A-07, A-10b and the Terms, the glossary keeping the bare term for closed capture; said in the Labels what [AI reading, new] means; and made six labels follow their homes (the ten-minute section, A-17, A-18 and A-20), the batched ALIGNMENT:549 among them. An independent AI reader, read-only, read the changes in two rounds; its findings were checked against the sources and taken, but for one on chapter 2's wording of the meta-attractor's second order, passed to its owner.
- Re-synced for edition 4 on 6 November 2026 (board item ED4; [the steps](../review-packet/FREEZE-STEPS.md), steps 1 to 5), from edition 3's frozen commit `6d221555a`. This pass added to A-19 that T7's field test of reform events was designed and could not be frozen as designed (T7F), and to A-20 what has run on its laws, the Stage A of TR7, TR1 and TR2 on small learners, in the words of [the runs' account](../../../../../../../experiments/formations-that-read/README.md#the-runs-made).
- Under **Known weaknesses**, a bullet quoting a chapter, a record or a study reports a recorded weakness. One marked [this dossier, AI] is this dossier's own assessment, recorded nowhere else, for the reviewer to confirm or reject.
- Works cited outside quotations before RF's additions were checked against a publication record ([the kit](README.md)); the ones RF's sentences add were checked as RF's entry above says. Works named inside a quotation are the quoted text's citations.
