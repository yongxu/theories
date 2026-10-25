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
| Dempster 1955 | *Cold Spring Harbor Symposia on Quantitative Biology* 20:25–31, doi 10.1101/sqb.1955.020.01.005 | added after the review; its geometric-mean result known here through secondary sources |
| Haldane and Jayakar 1963 | *Journal of Genetics* 58:237–242, doi 10.1007/BF02986143 | checked after the first pass; not cited after the second, since it treats polymorphism at a diploid locus and the two-kind model has no counterpart |
| Hendrycks 2023 | arXiv 2303.16200 (v4, July 2023) | |
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
| Zhuang and Hadfield-Menell 2020, "Consequences of Misaligned AI" | NeurIPS 2020 (proceedings reviews page); arXiv 2102.03896 | |

The draft page also cites Critch 2021, "What Multipolar Failure Looks Like, and Robust Agent-Agnostic Processes". The Alignment Forum post was found, but its date was not shown in the records. The dossier does not cite it.

<a id="review"></a>
## Review

An independent AI reader, a separate agent with no part in writing the dossier, made two passes on 25 October 2026.

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

**Left to their owners:**
- 02 §9's "a smaller cost raises it" in MA3's home section, fixed by MA3's owner the same day ("a smaller cost gives a rule not lower", landed with `bf2576f19`);
- 08's credit for partial observation, and its T7 row that predates LA2, for the board's coordinator.

The dossier reports both as known weaknesses where they bear.
