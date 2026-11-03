# UE8: the sciences dossier, kit

Board item UE8, 26 October 2026, under [UE](../ue-unified-explanation/PLAN.md) (a unified explanation of reality). The dossier is [SCIENCES.md](../../../../../../theories/becoming/review/SCIENCES.md), in the format of the packet's [alignment](../../../../../../theories/becoming/review/ALIGNMENT.md) and [philosophy](../../../../../../theories/becoming/review/PHILOSOPHY.md) dossiers, for physicists, evolutionary biologists and population geneticists, ecologists and resource economists, computational neuroscientists working on the free-energy principle, and control and complex-systems researchers. AI-authored throughout. The plan is [PLAN.md](PLAN.md). Where the dossier goes, and who decides, is set in the plan's [last section](PLAN.md#where-it-goes); it joined the first edition at the freeze of 3 November 2026 and is in the review folder.

<a id="lean"></a>
## How it was built

- **Sources.** Chapters 01–05, 07 and 08; the records each item quotes; the test accounts [margin-measured](../../../../../../experiments/margin-measured/README.md), [commons-gated-renewal](../../../../../../experiments/commons-gated-renewal/README.md), [commons-outrun](../../../../../../experiments/commons-outrun/README.md) and [break-warnings](../../../../../../experiments/break-warnings/README.md); the studies [UE0](../ue0-third-parts/AUDIT.md), [UE1](../ue1-fep-bridge/NOTE.md), [UE5](../ue5-pace-of-selection/REVIEW-UE5.md) and [UE6](../ue6-beyond-the-sciences/VERDICT.md); the pure core and the `physics` and `warning` periphery. Drafted from `5d4941161`; DF1 (`64c11b8ed`, record and docstring corrections) landed meanwhile, and every check below was run again on the tree at `8460f56c0` (26 October 2026), whose core receipt is DF1's, `20261025T184500.197330Z`, with no uncommitted change to the core or to `theories/`. After UE7 landed (`d299d86af`), the checker and the comparison were run again on main at `ee795993a`, and UE7's item was added (S-22).
- **Outline.** The plan's six parts are kept, in 23 items (634 lines as reviewed, 659 after the first review's fixes, 661 after the second's). Refinements:
  - Part 1 has three items: 08 §8's verdict (S-01); the third parts, with UE6's verdict (S-02); and strength as content, with 08 §9's unifications (S-03), which also routes T3's clause on trained systems, T4, T5, T7, T8 and IN1 to the alignment and philosophy dossiers.
  - Balance from the first law and the least loss read in available work share one item (S-04); recurrence and Landauer's count share another (S-05).
  - Fed from beyond moved from evolution to physics, beside rest (S-06): it is the rest theorem's other side, and its closest prior results are Schrödinger's and Prigogine's.
  - Coming and ceasing keep pace is joined by the classical laws in counts (S-07: Price, Fisher, drift and fixation, mutation), since the evolution line has no row in 08 §8 and needed a place for its verdict.
  - Conditioning by restriction and the exit from a margin share one item (S-18).
  - T3's law for optima is read with the optimum laws (S-13) and selection through couplings (S-20).
  - What keeping widening needs (UE7) is S-22, added after it landed; the root's laws moved to S-23.
- **Lean.** RP2's [`lean_statements.py`](../rp2-philosophy/lean_statements.py) copied the statements of the first ten blocks (eleven declarations); S-22's block, two declarations, was added after UE7 landed. It reads the pure core only, so the periphery's laws (S-04 in `lean/physics`, S-16's seen half in `lean/warning`) are named, not copied. After the last edit (the second review's fixes, on main at `8548c5896`), the script below compared every block with its source. It splits each block at `theorem` and `def`, finds every declaration of that kind and name in the core, `lean/physics` and `lean/warning` (check snapshots excluded), cuts it as `lean_statements.py` does (theorems at the first `:=`, definitions at the first blank line), squashes whitespace and compares, then checks the file named under the block. A deliberately altered statement was reported as a mismatch. Result: **13 of 13 declarations in 11 blocks match**, each in the file the dossier names.

  | Item | Declaration | Source (relative to the core) |
  |---|---|---|
  | S-05 | `Lossless.reset_unlisted` | `Becoming/LeastLoss.lean:642` |
  | S-06 | `fed_from_beyond` | `Becoming/Continuation.lean:180` |
  | S-08 | `closed_lineage_lowered` | `Becoming/Reproduction.lean:684` |
  | S-09 | `whole_within_power` | `Becoming/SelectionPace.lean:781` |
  | S-11 | `joint_excess_ends` | `Becoming/Continuation.lean:542` |
  | S-12 | `ends_iff_below` (the plain one of four in the file) | `Becoming/RegimeMargin.lean:739` |
  | S-13 | `frontier_holds` | `Becoming/Optimum.lean:3667` |
  | S-16 | `break_not_bounded` | `Becoming/Runaway.lean:193` |
  | S-18 | `fallsWithin_share` | `Becoming/ConditionalWeights.lean:890` |
  | S-21 | `EventuallyWidens` (definition) | `Becoming/EventualWidening.lean:98` |
  | S-21 | `eventually_neither` | `Becoming/EventualWideningInstances.lean:124` |
  | S-22 | `KeepsWidening.passes_every_bound` | `Becoming/KeepingWidening.lean:193` |
  | S-22 | `not_keepsWidening_along_passings` | `Becoming/KeepingWidening.lean:682` |

  Every law named in a **Meaning** without a block was read against its statement and docstring before it was described.
- **Quotations and names.** The packet's [`check_dossiers.py`](../review-packet/check_dossiers.py) reports **0 problems**, also after UE7 landed, when one quotation of 07 that UE7 narrowed was replaced (S-21), and after the second review's fixes and UE9's landing, when S-21's quotations of 07's Open item were replaced. Its first run found five:
  - a quotation of the audit crossed its bold markup, and was split at the markup into two;
  - `Closing.Onset` is a namespace, so the witness's theorem `Closing.Onset.unforeseen` is cited instead;
  - three names of the slowing-down law live in `lean/warning`, which the checker did not then search, so they were written without backticks and the file cited; once it searched `lean/warning` (`e86202d77`), the one name still cited, `SlowingDown.need_margin_read`, was backticked and checked.

  Quotations of 08 §8's rows were also split at the cells, so that no `|` falls inside a table cell: the checker passes such a quotation, but it breaks the Markdown table.
- **Links.** All 103 relative links and anchors in SCIENCES.md and this file resolve, rechecked after the second review's fixes and UE9's landing (a scratch checker: the file must exist relative to the linking file, and an anchor must be an `id` in it or a heading's slug).
- **Not yet in the dossier.** UE9 (comparing two courses on what they admit) landed after the second review (`8548c5896`, 26 October), narrowing 07's Open item; S-21 now quotes the item as narrowed, with the new record's link, and `check_dossiers.py` passes on it. An item of UE9's own, in Part 6 beside S-21 and S-22, is left for a later round with its own review; the re-sync of 3 November 2026 added none. UE2's free energy with its variational bound, then drafted for the periphery with no receipt (UE2's landed parts are S-18), has since landed ([03 §6](../../../../../../theories/becoming/chapters/03-KNOWING.md#r-free-energy-bounds-surprisal), 29 October 2026; its counting form in the core, 30 October): S-17 states both through the free-energy page, with no item of their own.
- **Re-synced after DF1b** (27 October 2026, on main at `ee8b440b6`). DF1b fixed the ten weak points below that change the account, and nine quotations of changed sentences no longer matched. They were replaced, and the dossier's notes the fixes answered were dropped or rewritten: S-04 (thermodynamics' second law in available work gives the spine's first law, `EntropyProduction.gainless_of_secondLaw`; a floor of destroyed exergy at every finer unit; Landauer's bound no such floor by itself, Bennett 2003 and Sagawa 2014; thermodynamics' first law named in full, also in the glossary line), S-07 (the fixation record gives the finite bounds and reads the limit from them), S-09 (Nei and Felsenstein cited apart in 04, the note dropped), S-14 (08's T1 evidence with MQ6's verdicts, MQ6 measured at constant regimes and past the fold, the note on its timing dropped), S-15 (T2's standing the same in both chapters, untested outside fisheries; MQ6 placed outside the settings that could refute T2 in both) and S-22 (Steel 2000; Hordijk and Steel 2004). `check_dossiers.py` reports 0 problems, and the comparison script finds 13 of 13 declarations in 11 blocks matching their sources.
- **Files.** No fetch saved a file, and no PDF was opened.

<details>
<summary>The comparison script (run from anywhere: <code>python3 -B compare_blocks.py SCIENCES.md</code>)</summary>

```python
#!/usr/bin/env python3
"""Compare every Lean block in a dossier with its source declaration, whitespace ignored.

For each ```lean block, split it into declarations at lines starting with theorem/lemma/def/abbrev;
find every declaration of that kind and name in the pure core (and the physics and warning periphery,
check snapshots excluded); extract it as lean_statements.py does (theorems to the first `:=`,
definitions to the first blank line); squash whitespace and compare. Also check that the file the
dossier names after the block (File:/Files:) holds the match.
usage: python3 -B compare_blocks.py DOSSIER.md"""
import re, sys
from pathlib import Path

ROOT = Path('/Users/ren/theories')
LEAN = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean'
CORE = LEAN / 'becoming'
SOURCES = sorted((CORE / 'Becoming').rglob('*.lean')) + \
    [p for d in ('physics', 'warning') for p in sorted((LEAN / d).glob('*.lean'))]

def squash(s):
    return ' '.join(s.split())

def extract(text, m, kind):
    start = m.start()
    if kind in ('theorem', 'lemma'):
        end = text.find(':=', m.end())
    else:
        end = text.find('\n\n', m.end())
        end = end if end > 0 else len(text)
    return text[start:end].rstrip()

def candidates(kind, name):
    pat = re.compile(r'^(?:@\[[^\]]*\]\s*)?(?:private\s+|protected\s+|noncomputable\s+)*(' + kind + r')\s+(' + re.escape(name) + r')(?=[\s(:{\[])', re.M)
    out = []
    for p in SOURCES:
        t = p.read_text(encoding='utf-8')
        for m in pat.finditer(t):
            line = t.count('\n', 0, m.start()) + 1
            out.append((p, line, extract(t, m, kind)))
    return out

doc = Path(sys.argv[1]).read_text(encoding='utf-8')
blocks = [(m.start(), m.group(1)) for m in re.finditer(r'```lean\n(.*?)```', doc, re.S)]
total = ok = 0
for pos, body in blocks:
    after = doc[pos:pos + len(body) + 400]
    fm = re.search(r'\nFiles?: (.*)\n', after)
    named = re.findall(r'`([^`]+\.lean)`', fm.group(1)) if fm else []
    parts = re.split(r'\n(?=(?:theorem|lemma|def|abbrev) )', body.strip('\n'))
    for part in parts:
        hm = re.match(r'(theorem|lemma|def|abbrev)\s+(\S+)', part)
        if not hm:
            print('UNPARSED', part[:60]); continue
        kind, name = hm.groups()
        total += 1
        cands = candidates(kind, name)
        hits = [(p, l) for p, l, s in cands if squash(s) == squash(part)]
        if hits:
            ok += 1
            p, l = hits[0]
            rel = p.relative_to(CORE) if CORE in p.parents else p.relative_to(LEAN)
            filed = any(str(rel).endswith(n) for n in named)
            print(f'MATCH {name}  {rel}:{l}  named file {"agrees" if filed else "DIFFERS: " + str(named)}'
                  + (f'  ({len(hits)} identical copies)' if len(hits) > 1 else ''))
        else:
            print(f'MISMATCH {name}: {len(cands)} candidate(s)')
            for p, l, s in cands:
                print('   ', p.relative_to(LEAN), l, squash(s)[:160])
print(f'{ok} of {total} declarations in {len(blocks)} blocks match their sources')
```

</details>

## Found in the account while drafting

This item edits no other file, so these were left for their owners, each stated in the dossier where it bore. DF1b (`ee8b440b6`, study §422; [DEFECTS-FOUND](../../../../2026-10-05-repository-reconciliation/architecture/DEFECTS-FOUND.md#found-while-drafting-the-sciences-dossier-26-october-2026-ue8)) fixed the ten that change the account, and the dossier was re-synced against the changed sentences (How it was built); the evolution line's row in 08 §8 is left for 08's owner, and the packet's checker has searched `lean/warning` since `e86202d77`.

- 02 §4 gives Landauer's bound as a floor at least the unit (`EntropyProduction.dissipative_of_floor`), while UE6's first round found that Landauer's bound alone does not supply the World's least loss, since heat exported is not exergy destroyed (S-04). *Fixed in DF1b (study §422).*
- The name *first law* has two senses: `Flow.Gainless` is called the spine's first law and is the second law read in available work, while 01's balance theorem reads thermodynamics' first law (S-04). *Fixed in DF1b (study §422).*
- 02 §7 cites `Closing.Onset`, a namespace, for "the amounts do not show whether one will"; the Lean is a witness (`Closing.Onset.unforeseen`), so its strength is that the amounts need not show it (S-10). *Fixed in DF1b (study §422).*
- The fixation-by-drift record's summary says "in the limit"; the Lean gives finite two-sided bounds, and 04 reads the limit from them (S-07). *Fixed in DF1b (study §422).*
- 04's reading of the pace of selection writes "Nei and Felsenstein (1971)" as one work; 08 cites them apart (S-09). *Fixed in DF1b (study §422).*
- 08 §8's table has no row for the evolution line, as UE0 noted (S-01, S-07).
- 08 §9's T1 standing names, of MQ6, only the timing; MQ6 passed 3 of its 10 frozen predictions, failing also A1 (the fate reading at the instrument's floor) and A2 (the held-out need 1.7 times too low next to the fold) (S-14). *Fixed in DF1b (study §422).*
- T2's standing differs between 08 §9 ("and one in yeast past its fold; untested on grassland and forests") and 02 ("untested outside fisheries"), and the tests' account says MQ6 did not measure T2's forbidden items (S-15). Found by the second review: 08 §9 counts MQ6 among T2's tests, though T2's refutation clause names yeast only in deteriorating environments and MQ6's L was measured at a constant dilution, so the result cannot refute T2. *Fixed in DF1b (study §422).*
- The margin-measured and break-warnings accounts link T1, T2 and T6 to a history copy of the overview (`theories/becoming/history/THE-THEORY-OF-BECOMING.md`), not to their home chapters (02, 03). *Fixed in DF1b (study §422).*
- The Gao, Schulman and Hilton year is 2023 in 05 and in one record, 2022 in another (`coupling-closures-of-training-pipelines`); not used here. *Fixed in DF1b (study §422).*
- The packet's checker does not search `lean/warning`, where the slowing-down law lives. *Fixed in `e86202d77`: the checker searches it, and S-16's name is backticked.*
- Found by the first review: 07 §2, its reading and the record what-keeping-widening-needs (law 9) say "Under the World premises" before the passing laws, which also need requirements never loosening (`Unloosened`), a local hypothesis, not one of the World's eight premises (S-22). Corrected at UE9's landing (`8548c5896`): 07 §2's theorem and reading, the Open items of 07 and 02 and the record (statement, law 9, premises) now say so.
- Found by the first review: 08 §9's T2 evidence says "in yeast past its fold (MQ6) residuals carry nothing day to day"; the result was measured at constant dilution, as 02 says (S-15). *Fixed in DF1b (study §422).*
- Found by the second review: 08 credits food-generated autocatalytic sets to Hordijk and Steel 2012 (S-22). Food-generated sets, the F of RAF sets, were formalized by Hordijk and Steel in 2004 (*Journal of Theoretical Biology* 227:451–461, from a mirror listing); their 2012 papers extend the framework, so the year may point to an extension rather than the definition. *Fixed in DF1b (study §422), citing Steel 2000 with it; the dossier quotes the corrected line.*

<a id="references"></a>
## References, as checked on 26 October 2026

Every work the dossier cites outside a quotation, and the works behind its own [this dossier, AI] statements, each against a publisher, journal, proceedings, catalogue or repository record found by web search. Page ranges are given only where a record gave them. None was dropped. Results named after their authors (Price's equation, Fisher's theorem, Bayes's rule, the Moran probability, Kolmogorov's inequality) are named, not cited; where a quotation cites the work, it is the quotation's citation.

| Work | Record checked | Note |
|---|---|---|
| Aguilera, Millidge, Tschantz and Buckley 2022 | *Physics of Life Reviews* 40:24–50, doi 10.1016/j.plrev.2021.11.001 (PubMed Central PMC8902446) | S-17 |
| Bennett 1973, "Logical reversibility of computation" | *IBM Journal of Research and Development* 17(6):525–532 | S-03, S-05; no publisher page found, the details agree across a course-hosted copy of the article and a MaRDI portal entry |
| Biehl, Pollock and Kanai 2021 | *Entropy* 23(3):293, doi 10.3390/e23030293 (PubMed Central PMC7997279) | S-17 |
| Boerlijst, Oudman and de Roos 2013, "Catastrophic collapse can occur without early warning" | *PLoS ONE* 8(4):e62033, doi 10.1371/journal.pone.0062033 (PubMed Central PMC3623932) | S-16, the coupled side in eigenvector form, as the early-warning check reads it |
| Bruineberg, Dołęga, Dewhurst and Baltieri 2022 | *Behavioral and Brain Sciences* 45:e183, doi 10.1017/S0140525X21002351 (Cambridge Core) | S-17 |
| Clark 1973, "Profit maximization and the extinction of animal species" | *Journal of Political Economy* 81(4):950–961 (RePEc listing; reference lists) | S-13 |
| Clark 1976, *Mathematical Bioeconomics* | Wiley, New York (library catalogues: CiNii, HathiTrust) | S-13 |
| Crutchfield and Young 1989, "Inferring statistical complexity" | *Physical Review Letters* 63(2):105–108, doi 10.1103/PhysRevLett.63.105 (APS issue listing) | S-23, question 1: causal states |
| Dai, Vorselen, Korolev and Gore 2012 | *Science* 336:1175, doi 10.1126/science.1219805 (DSpace@MIT; its data set, Dryad doi 10.5061/dryad.p2481134) | S-14 |
| Dai, Korolev and Gore 2015 | *Proceedings of the National Academy of Sciences* 112(32):10056–10061, doi 10.1073/pnas.1418415112 (DSpace@MIT) | S-14 |
| Dekker, von der Heydt and Dijkstra 2018, "Cascading transitions in the climate system" | *Earth System Dynamics* 9(4):1243–1260, doi 10.5194/esd-9-1243-2018 (the journal's article page) | S-16, the closest prior form of the uncoupled side, as the early-warning check reads it |
| Eigen 1971, "Selforganization of matter and the evolution of biological macromolecules" | *Naturwissenschaften* 58(10):465–523, doi 10.1007/BF00623322 (PubMed 4942363) | S-07, the error threshold |
| Felsenstein 1971 | *American Naturalist* 105(941):1–11, doi 10.1086/282698 (University of Chicago Press record) | S-09, that Nei and Felsenstein are two papers; records give the title with "substitution" and with "substitutions" |
| Friston, Levin, Sengupta and Pezzulo 2015 | *Journal of the Royal Society Interface* 12:20141383, doi 10.1098/rsif.2014.1383 (PubMed Central PMC4387527) | S-17 |
| Gordon 1954, "The economic theory of a common-property resource: the fishery" | *Journal of Political Economy* 62(2):124–142, doi 10.1086/257497 (reference lists; the AERE's page on the article) | S-13, open access and the bionomic equilibrium; added at the second review |
| Haldane 1957, "The cost of natural selection" | *Journal of Genetics* 55:511–524, doi 10.1007/BF02984069 (DOI record; pages from a reprint listing) | S-09, question 1 |
| Keith and Hutchings 2012 | *Canadian Journal of Fisheries and Aquatic Sciences* 69(7):1150–1163, doi 10.1139/f2012-055 (journal page; a research-portal record) | S-11: 207 stocks of 104 species, strong compensation in many species and much weaker than expected in others, evidence of depensation in some (Atlantic cod, Alaskan walleye pollock), as records of the abstract give it; the first review found the earlier wording, compensation weaker than expected in many, overstated, and the search records of 26 October bear it out |
| Kemeny and Snell 1960, *Finite Markov Chains* | Van Nostrand, Princeton, viii+210 pp. (library catalogues; Springer's 1976 reprint names the 1960 edition) | S-23 |
| Landauer 1961, "Irreversibility and heat generation in the computing process" | *IBM Journal of Research and Development* 5(3):183–191, doi 10.1147/rd.53.0183 (IEEE Xplore document 5389195) | S-03, S-05; the Xplore page gave no text to a fetch, so volume and pages are from reference lists |
| Milner 1989, *Communication and Concurrency* | Prentice Hall, New York, xi+260 pp., ISBN 0131150073 (library catalogues) | S-23 |
| Myers, Barrowman, Hutchings and Rosenberg 1995 | *Science* 269(5227):1106–1108 (a research-portal record; the VLIZ marine bibliography) | S-11: 3 of 128 stocks with significant depensation, as the abstract gives it |
| Nei 1971, "Fertility excess necessary for gene substitution in regulated populations" | *Genetics* 68(1):169–184, doi 10.1093/genetics/68.1.169 (Oxford Academic issue page) | S-09, as for Felsenstein |
| Paige and Tarjan 1987, "Three partition refinement algorithms" | *SIAM Journal on Computing* 16(6):973–989, doi 10.1137/0216062 (SIAM record; Princeton technical report TR-038-86) | S-23 |
| Park 1981, "Concurrency and automata on infinite sequences" | *Theoretical Computer Science, 5th GI-Conference*, LNCS 104:167–183, doi 10.1007/BFb0017309 (Crossref, DBLP) | S-23 |
| Ricard, Minto, Jensen and Baum 2012 | *Fish and Fisheries* 13(4):380–398, doi 10.1111/j.1467-2979.2011.00435.x (BibSonomy record; the database's site) | the RAM Legacy database, S-14; some pages give "Evaluating" for "Examining" in its title |
| Zhuang and Hadfield-Menell 2020, "Consequences of Misaligned AI" | NeurIPS 2020 (proceedings review pages); arXiv 2102.03896 | S-03 |

<a id="review"></a>
## Review

An independent AI reader, with no part in writing the dossier, reviews it in two passes against the chapters, records, tests and Lean before it is offered.

**First pass** ([REVIEW-UE8.md](REVIEW-UE8.md), 26 October 2026, on the dossier as it stood at 04:06, 634 lines). 50 findings: 3 errors, 29 imprecisions (11 major), 12 credit (3 major), 6 style. Its verdict: the dossier can be offered after the fixes and a second pass. Every finding was taken; none needed new Lean or changes a verdict of the theory.
- *Errors.* E1 (S-06): the rest theorem now carries both censuses and enclosure around what stands, `World.arising_opens` every relatum embodied, and `World.rest_needs_standing` is cited as the witness that each is needed; fed from beyond holds with equality of conditions decided. E2 (S-14): T1's quotation keeps its parenthesis (not the withheld-levels margin); the fish-stock ranking is given as the frozen-rest margin's, which T1 excludes, and MQ3's F3 failure is given with its number. E3 (S-17): the counted lock carries its in-sync start, and the stale witness is a known weakness.
- *The tests as they fell* (I1, I16–I20, I22). S-14 has a ledger line for every test bearing on T1, with its frozen count, each failure by name and, where its ledger classes them, the class of each pass; the note that laid two floor failures on the measurement is replaced by the account's own reading and lesson; the salt-shock facts are given and the question asked neutrally. S-15 gives MQ4's, MQ5's and MQ7's counts and quotes 02's exact statement of MQ6's constant-dilution result. S-16 gives EW2's frozen p, its post hoc partial correlation and EW3's new-row estimates, all marked reported only.
- *Dropped conditions* (I2, I8–I10, I13, I23, I25–I27, I29), restored from the chapters and the Lean: the nine modelling commitments (identity by naming among them), the almost-sure rest's integrability, the amount carried against offspring number, the standard bounds and the self-loop, room as an equivalence with its one-step hypotheses and the weighted law's converse, the slowing-down law's conditions with SlowingDown.need_margin_read and T6's conjectured scope, the exit's record conditions, the set-point laws' room and balance, the blindness law's counterfactual, and requirements never loosening as a local hypothesis in S-22.
- *Readings and the theory's own terms* (I3, I5–I7, I11, I14, I15, I21, I24, I28). A term for the theory's first law; 08's qualifiers on its survivors and unifications; the least loss's refinement; the gate as the limiting form of critical depensation, which the cited frequencies bound from above; the Gordon quotation attached to its witness; the missing cost of drawing ([this dossier, AI]); T6's refuted first wording and 08's "general claim false"; the record's caveats on active inference's scheme; and the lag's theorem told apart from 07's reading.
- *Credit* (C1–C12). Named from the records and studies where they already were, by quotation: the physics behind S-04, the later thermodynamics of computation, the bioeconomics behind S-13, the early-warning prior work, the set-point neighbours, liveness and overtaking, autocatalytic sets, computational closure and probabilistic bisimulation; outside quotations Eigen (1971), Dekker and others (2018), Boerlijst and others (2013) and Crutchfield and Young (1989), each checked (references above). Keith and Hutchings's wording follows the abstract.
- *Regulation* (I4): S-10 is now *Loops and regulation*, with the late reading's band, 08's verdict and CG1's E rows, so the control theorists the opening names have an item.
- *Style* (St1–St6): the checker's scope stated, row labels restored, the audit's sentence quoted whole, three questions put neutrally, and this file's counts brought up to date.

Of the [this dossier, AI] statements resting on field knowledge, the second pass found Clark's and Gordon's costs and the Azuma–Hoeffding comparison right, and corrected the third, depensation against critical depensation (I34); they remain for the readers to confirm.

**Second pass** ([REVIEW-UE8.md](REVIEW-UE8.md#second-pass), 26 October 2026, on the dossier at 659 lines and this file at 189). 15 findings: 1 error, 8 imprecisions (1 major), 3 credit, 3 style; four go back to the first pass's own wording (E4, I31 in part, I34, St7). E1–E3 were found corrected, every added credit attached to the right claim, and the four new references agreeing with their records. Its verdict: offer after the named fixes, which can be checked against the lines it gives without a third pass. Every finding was taken, C15 as a note for 08's owner (above).
- *E4* (S-14): MQ3's F3 counts episodes; of 754 below the regime's point 63% fell, against the frozen 80%, and 99.5% of 425 above it held.
- *The tests named* (I30, I32): every failure is named (MQ3's F0 to F2, MQ6's five forecast and timing predictions and its three passes, MQ7's C1), MQ4's "T2" is marked as a test label, S-16 gives its counts, and the opening and this file claim the class of a pass only where a ledger classes it.
- *I31* (S-15): the bullet on MQ6 now says the result is consistent with T2 and tests none of what it forbids, T2's refutation clause naming yeast only in deteriorating environments, and that the method chapter counts it among T2's tests while the home chapter does not; the discrepancy is listed for 08's owner (above).
- *Conditions and readings* (I33 to I37): the posterior contrast carries carriers present and, for every step, a positive fixed scale; how often depensation occurs, not how often it is detected, bounds the law's reach; S-10's regulation laws have the record's does-not-show and CG1's E setting as known weaknesses; `World.rest_needs_census` is cited for the rest theorem's census of what is active; and the harms are said to be unmeasured by the theory's tests, not unmeasured.
- *Credit and style* (C13, C14, St7 to St9): Gordon 1954 in the references; S-05's credit quotation begins at Bennett's 2003 notes; one slowing-down name, not three; S-14's repeated MQ6 bullet merged into its ledger line; the line count and the order of the references.

After the second pass, UE9 landed (`8548c5896`), and S-21's quotations of 07's Open item were replaced by the item as narrowed; the new quotations are 07's text, found by `check_dossiers.py`, and were not read by the reviewer.

**The revision of 2 November 2026** (board item UE30, [note](../ue-unified-explanation/ue30-hang-off/NOTE.md)): a ten-minute part, what a law here is, what would refute what, S-17 brought to the principle's page, how it was made moved to the end. An independent AI reader read the revision against its homes and reported on strength, counts, S-17 and terms an outside reader cannot place. Every finding on these texts was taken: the column of the theses is headed Forbids, since an item's home has more than 08 §9's cell; most laws are in whole numbers and the periphery's over the reals; the sentence on what a failed conclusion shows is an AI reading, not stated in 08 §10; S-17 says how the first study's seven claims are the page's five, and its third question no longer says a third part could not exist.

## The re-sync of 3 November 2026

The dossier was read as a whole against what had moved since `b7b36ab74` (27 October). On 2 November its front and S-17 had been brought to the free-energy page. [`resync_report.py`](../review-packet/resync_report.py) flagged 23 of 23 items, 75 quotation paragraphs changed and 13 new. Most stayed true.

- **What changed.**
  - S-01: the evolution line has rows in 08 §8's table since 27 October 2026 (`2be4aa00f`); the table here gains them, the known weakness says so, and S-07's third question asks whether their verdicts are right.
  - S-02: the last two rows' third parts and the free-energy principle's five. S-03: a frozen rule fixes how a verdict is scored, not that the rule reads the construct. S-05: a quantity that never falls rules out a law that merges nothing only where it rises at some step, as 01 now states it.
  - S-07: the selection term and a lineage's fate. S-21: what a course keeps reachable, causal-set growth, and the possible's growth read as innovation. S-22: what keeping opening needs (a beginning after every step) and the kind relay, with its Q3. S-23: the core against going alike.
  - The conventions count ten modelling commitments, 08 §4's *finite presence* added.
- **Left alone on reading.** S-13's LA4 season: the alignment dossier carries it. No new result otherwise changes what an item's reader should be told.
- **Measures.** The kit's counting, on this text: the whole 16,805 words and 27 characters and 82 lines of Lean, 129.4 to 168.2 minutes, stated as 125 to 170, rounded out to five minutes (it had read 120 to 160).
- **Review.** One independent AI reader, read-only and with no part in the writing, read the change and the flagged items against the chapters and the Lean. Every finding was checked against the source and taken:
  - errors: a law of dissipated requirements stated along passing, when it holds along any continuation containing carrying on of the supported, so that as written it followed from the clause before it; "under the same premises" pointing at the wrong theorem after the re-sync's rewording, and "names it did not admit before", which is false of opening; S-13 and S-09, unchanged sentences dropping hypotheses (what others leave with its renewal, the capacity; a population not shrinking, the amount's spread);
  - misleading: the kind relay shown without "the kind chosen so that the passings across kinds begin", beside a law that a finite closed balanced world has none, which is by name; "which side" with one side given; evolutionary suicide's witness, whose mark is a label; Hamilton's rule and coupled groups under "any type"; "each" reaching over the free-energy principle's five; S-11 silent on generalizing learners; S-23 silent on the core against going alike;
  - terms and minor: *renewal one grain up*, continuation and passing of support unglossed; distinct offspring in S-08; *for beliefs in counts* in S-18; "the rule's print".
  - 08 §8's sentence on a finite, closed, balanced world omits "by name" too. That is left for the chapter's owner; the dossier now says the bar is by name.
