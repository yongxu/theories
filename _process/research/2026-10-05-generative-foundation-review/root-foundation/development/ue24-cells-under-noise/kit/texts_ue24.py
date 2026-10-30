#!/usr/bin/env python3
"""UE24 texts: 05's thesis and the home section of identical-cells-under-noise in 05 §9, after the identical-cells law;
08 §8's bullet on identical cells; the principle's page (In brief, the identical-cells row, §3's first law, §5 and
Standing); the study section; the UE plan's owners and FEP-INTEGRATION's item 9; the regions of the new record and the
note of the identical-cells record. Every CellsUnderNoise name the texts cite is checked against the receipt's
declarations. Mirrors UE23's texts_ue23.py; every edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree, after the periphery checker):
  python3 -B <kit>/texts_ue24.py RECEIPT N"""
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
RECEIPT, N = sys.argv[1], int(sys.argv[2])
FE = 'experiments/integrated-correction/general-framework/generative-basis/lean/free-energy'
CH = ROOT / 'theories/becoming/chapters'
PAGE = ROOT / 'theories/becoming/FREE-ENERGY-PRINCIPLE.md'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
STUDY = ROOT / RF / 'BECOMING-RENEWAL-READING.md'
REGIONS = ROOT / 'theories/becoming/results/data/regions.json'
RID, RIDI = 'identical-cells-under-noise', 'identical-cells-under-a-descent-treating-them-alike'
R = json.loads((ROOT / FE / 'cells-under-noise-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed' and R['bridge_module'] == 'CellsUnderNoise'
MOD = next(x for x in R['modules'] if x['module'] == 'CellsUnderNoise')
NAMES = {d['name'] for d in MOD['declarations']}
COUNT = len(NAMES)


def cited(text):
    """Every backticked CellsUnderNoise name the text cites is a declaration of the module."""
    found = set(re.findall(r'`CellsUnderNoise\.([A-Za-z_.]+)`', text))
    missing = sorted(n for n in found if 'Becoming.CellsUnderNoise.' + n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


C05 = CH / '05-COLLECTIVES.md'
edit(C05, "or parts identical cells under a descent that treats them alike. Claimed, not proved:",
     "or parts identical cells under a descent that treats them alike, and under noise of one law at every cell "
     "an exchangeable law stays exchangeable, deciding nothing of which cell takes which place. Claimed, not "
     "proved:")
ANCHOR = '<a id="r-synonyms-and-coined-forms"></a>'
SECTION = (
    f'<a id="r-{RID}"></a>\n'
    "**Theorem** (*periphery*, on Mathlib's reals; finitely many cells and states, weights on configurations moved "
    "by kernels in discrete steps, one for each step). Under noise the never-parting law does not apply, and what holds "
    "instead is a law of the whole distribution. A kernel commuting with a rearrangement of the cells keeps a law "
    "that rearrangement leaves unchanged unchanged, so under kernels commuting with every rearrangement an "
    "exchangeable start, a law no rearrangement changes, gives an exchangeable law at every step "
    "(`CellsUnderNoise.weightsAt_exchangeable`); under an exchangeable law every cell has the law of every other, and, "
    "where it is nonnegative with total one, each assignment of distinct states to the cells has weight at most one "
    "over the number of orderings of the cells (`CellsUnderNoise.marginal_eq`, `CellsUnderNoise.distinct_le`). The "
    "law of one configuration is exchangeable only with all its cells alike "
    "(`CellsUnderNoise.pointMass_exchangeable_alike`), and a unique stationary law is exchangeable "
    "(`CellsUnderNoise.unique_stationary_exchangeable`). Joined to the core: the exchanges of neighbouring cells "
    "generate every rearrangement (`CellsUnderNoise.ofFn_rearranged`); the core's descent, read cell by cell, has "
    "the core's run as its run, so with no noise the law weighs one exactly the configuration the core's run reaches "
    "(`CellsUnderNoise.ofFn_iterate_cellwise`, `CellsUnderNoise.noiseless_run`); with an exchangeable field it "
    "commutes with every rearrangement, and its run from a rearranged start is the rearranged run "
    "(`CellsUnderNoise.cellwise_commutes`, `CellsUnderNoise.run_rearranged`). With noise of one law at every cell, "
    "each cell going independently from its own state and the field it senses, the law from an exchangeable start, "
    "all cells in one state or the cells independent and each of one law, stays exchangeable, and where noise and "
    "start are laws each assignment of distinct states to the `m` cells has weight at most `1/m!` "
    "(`CellsUnderNoise.noisyDescent_exchangeable`, `CellsUnderNoise.noisyDescent_distinct_le`); from all cells in one "
    "state some configuration of all cells alike has positive weight at every step "
    "(`CellsUnderNoise.alike_positive`), while independent noise can part them "
    "(`CellsUnderNoise.Witness.independentNoise_parts`). In a witness on two cells a kernel commuting with the "
    "exchange parts alike cells with certainty, but it is the fair mixture of two rules assigning the places by the "
    "cells' numbers and no noise of one law at every cell (`CellsUnderNoise.Witness.alike_none`, "
    "`CellsUnderNoise.Witness.toParted_eq_mixture`, `CellsUnderNoise.Witness.toParted_not_noisyDescent`); and a "
    "field reading the state of the first cell, which reads no cell's number but reads the places through the "
    "list's order and is not exchangeable, assigns the places from an exchangeable start "
    "(`CellsUnderNoise.Witness.firstCell_assigns`). So noise of one law at every cell decides nothing of which cell "
    "takes which place: every rearrangement of an assignment keeps its weight. It is Curie's principle in its form for indeterministic "
    "laws (Ismael 1997), a symmetry the law keeps being broken only in realizations (Earman 2004); the 2015 paper's "
    "scheme, initial expectations independent and of one law and a signal symmetric in the cells, has the law's "
    "form, and the paper never claims which cell takes which place, so the law forbids nothing of it "
    f"([record](../results/records/{RID}.md)).\n\n"
    "**Reading** [AI reading, D45]. That identical cells come to know their place stands if it says each cell "
    "infers which place it has reached, as the 2015 simulation shows. Read as the scheme deciding which place a "
    "given cell takes, it fails for every exchangeable scheme: there chance decides, the start's and the noise's, "
    "and the law gives each "
    "rearrangement of the outcome one weight.\n\n")
edit(C05, ANCHOR, SECTION + ANCHOR)

C08 = CH / '08-METHOD.md'
edit(C08, "not the papers' simulations, which break the symmetry by random starts and have no shared draw. Each law is "
          "near-definitional, an application or a witness.",
     "not the papers' simulations, which break the symmetry by random starts and have no shared draw. Each law is "
     "near-definitional, an application or a witness. Identical cells under noise "
     f"([05 §9](05-COLLECTIVES.md#r-{RID}), periphery) state Curie's principle in its form for indeterministic laws "
     "(Ismael 1997) in the same terms, joined to the core's descent: under noise of one law at every cell an "
     "exchangeable law stays exchangeable, which forbids nothing of the 2015 paper, whose scheme has that form.")

# the principle's page
LINK = f'(chapters/05-COLLECTIVES.md#r-{RID})'
edit(PAGE, "Two further laws forbid no sentence of the literature but state what it leaves open: expected free energy",
     "Three further laws forbid no sentence of the literature but state what it leaves open: under noise of one law "
     "at every cell the law on identical cells stays exchangeable, deciding nothing of which cell takes which "
     "place; expected free energy")
edit(PAGE, "- **Where the principle says more.** Densities and continuous time, noise and random dynamics, Langevin",
     "- **Where the principle says more.** Densities and continuous time, noise and random dynamics beyond finite "
     "chains with noise of one law at every cell, Langevin")
edit(PAGE, "| forbidden as a guarantee for a deterministic descent from a symmetric start; the simulation, from random "
           "initial expectations, stands |",
     "| forbidden as a guarantee for a deterministic descent from a symmetric start; the simulation, from random "
     f"initial expectations, stands; under noise of one law at every cell the law stays exchangeable ([05 §9]{LINK}, "
     "periphery), which forbids nothing of the paper |")
edit(PAGE, "morphogenesis from a homogeneous state needs disturbances an instability amplifies (Turing 1952), and its "
           "uniqueness clause is the symmetric choice that singles out none (Angluin 1980).",
     "morphogenesis from a homogeneous state needs disturbances an instability amplifies (Turing 1952), and its "
     "uniqueness clause is the symmetric choice that singles out none (Angluin 1980). Under noise the law does not "
     "apply. For finite chains with noise of one law at every cell, each cell reading its own state and the field it "
     "senses, an exchangeable start stays exchangeable, deciding nothing of which cell takes which place, "
     f"every rearrangement of an assignment keeping its weight ([05 §9]{LINK}; *periphery*; "
     "`CellsUnderNoise.noisyDescent_exchangeable`, `CellsUnderNoise.noisyDescent_distinct_le`); the 2015 scheme has "
     "that form, so this forbids nothing of the paper. Known: Curie's principle in its form for indeterministic laws "
     "(Ismael 1997).")
edit(PAGE, "noise and random dynamical systems, under which the law on identical cells does not apply;",
     "noise and random dynamical systems beyond finite chains with noise of one law at every cell, under which the "
     f"law on identical cells gives way to an exchangeable law ([05 §9]{LINK});")
edit(PAGE, "and expected free energy read through the lumping at every step of a course.",
     "and expected free energy read through the lumping at every step of a course, and the law on identical cells "
     "under noise, joined to the core's descent.")

# the study section
section = (HERE / 'study_ue24.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
section = section.replace('(COUNTS)', f"({MOD['theorems']} theorems in {COUNT} declarations)")
assert not any(x in section for x in ('{', 'TODO', 'COUNTS', 'PARAGRAPH')), 'a placeholder left'
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# the UE plan and the plan for the principle
UE = ROOT / RF / 'development/ue-unified-explanation'
REC = '../../../../../../theories/becoming/results/records/'
edit(UE / 'PLAN.md', "UE16, UE17, UE18, UE19, UE20, UE21, UE22 and UE23, and holds UE8.",
     "UE16, UE17, UE18, UE19, UE20, UE21, UE22, UE23 and UE24, and holds UE8.")
ITEM8 = ("Whether, or how often, such an agent chooses an experiment that separates turns on its preferences, its "
         "posterior and the experiments' information.\n")
edit(UE / 'FEP-INTEGRATION.md', ITEM8,
     ITEM8 + f"9. **UE24. Identical cells under noise** (landed as the periphery module `CellsUnderNoise`, with "
     f"[its record]({REC}{RID}.md), study section {N}). For finitely many cells and states, weights on configurations "
     "moved by kernels in discrete steps: kernels commuting with every rearrangement of the cells keep an "
     "exchangeable law exchangeable, so every cell has the law of every other and each assignment of distinct states "
     "has weight at most one over the number of orderings of the cells. Joined to the core's descent: the exchanges "
     "of neighbouring cells generate every rearrangement, the descent read cell by cell has the core's run as its run, "
     "and with noise of one law at every cell, reading the cell's own state and the field it senses, the law stays "
     "exchangeable from an exchangeable start, deciding nothing of which cell takes which place; the 2015 scheme has "
     "the law's form, so it forbids nothing of the paper. Independent noise parts identical cells with positive "
     "weight, never with certainty; a kernel parting two cells with certainty is a mixture of rules reading the "
     "cells' numbers; a field reading the first cell assigns the places.\n")

# regions: the new record, and the note of the identical-cells record
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert RID not in reg['records']
reg['records'][RID] = {'region': 'collective', 'base': 'periphery', 'note': (
    "CellsUnderNoise UE24: under kernels commuting with every rearrangement an exchangeable law stays exchangeable; "
    "the core's descent with an exchangeable field and noise of one law at every cell keeps it, which cell takes "
    "which place undecided (periphery)")}
note = reg['records'][RIDI]['note']
assert 'UE24' not in note
reg['records'][RIDI]['note'] = note + '; UE24: under noise, in the periphery, the law stays exchangeable (identical-cells-under-noise)'
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 05 thesis and §9, 08 §8, the page, study section', N, ', UE plan and FEP-INTEGRATION, regions')
