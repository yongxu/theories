# AJ4: the alignment dossier, kit

Board item AJ4, 25 October 2026 ([Ren's choice](../../../../../../sources/15-codex-theory-conversations/2026-10-25-alignment-dossier.md); [the objective](../../../../../../sources/15-codex-theory-conversations/2026-10-24-alignment-community-objective.md)). The dossier is [`theories/becoming/review/ALIGNMENT.md`](../../../../../../theories/becoming/review/ALIGNMENT.md), the packet's fifth, in the format of the [philosophy dossier](../../../../../../theories/becoming/review/PHILOSOPHY.md). AI-authored throughout. The plan is [PLAN.md](PLAN.md), and the page it grew from is [DRAFT-ONE-PAGE.md](DRAFT-ONE-PAGE.md).

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
