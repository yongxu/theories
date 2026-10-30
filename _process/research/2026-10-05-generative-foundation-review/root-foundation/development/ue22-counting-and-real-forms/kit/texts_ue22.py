#!/usr/bin/env python3
"""UE22 texts: 03 §6, the home sections of free-energy-bounds-surprisal (the join to the bound in counts, its standing
and the closing sentence) and of free-energy-bound-in-counts (the identity named where the bound is read as the real
one exponentiated, and the equivalence with Gibbs' inequality); 08 §8's bullet on free energy; the principle's page (In
brief, the table row, §1 and Standing); the study section; the UE plan's owners and FEP-INTEGRATION's item 7; the region
note of free-energy-bounds-surprisal. Every FreeEnergy name the texts cite is checked against the receipt's
declarations. Mirrors UE21's texts_ue21.py; every edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree, after the periphery checkers):
  python3 -B <kit>/texts_ue22.py RECEIPT_FE N"""
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
RIDFE, RIDC = 'free-energy-bounds-surprisal', 'free-energy-bound-in-counts'
R = json.loads((ROOT / FE / 'free-energy-reals-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed' and R['bridge_module'] == 'FreeEnergyReals'
MOD = R['modules'][0]
NAMES = {d['name'] for d in MOD['declarations']}
assert len(NAMES) == 76, len(NAMES)


def cited(text):
    """Every backticked FreeEnergy name the text cites is a declaration of the module."""
    found = set(re.findall(r'`FreeEnergy\.([A-Za-z_.]+)`', text))
    missing = sorted(n for n in found if 'Becoming.FreeEnergy.' + n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


C03 = CH / '03-KNOWING.md'
edit(C03, "at free energy the record's surprisal (`FreeEnergy.freeEnergy_givenShare`, `FreeEnergy.minimizes_iff_givenShare`). ",
     "at free energy the record's surprisal (`FreeEnergy.freeEnergy_givenShare`, `FreeEnergy.minimizes_iff_givenShare`). "
     f"Joined to [the bound in counts](#r-{RIDC}): for a belief in counts `n / N` over hypotheses listed once, with `N` "
     "positive and no count where a natural weight `a` is nothing, `N` times the free energy less the surprisal of the "
     "total weight is the logarithm of the ratio of the counting bound's two sides, `log (A ^ N * ∏ n ^ n) − "
     "log (N ^ N * ∏ a ^ n)` (`FreeEnergy.gap_counts`), so there the two bounds hold exactly together "
     "(`FreeEnergy.surprisal_le_freeEnergy_iff_bound`), and the bound, its equality exactly where the counts are in "
     "proportion to the weights, which is the posterior, and its strictness elsewhere follow from the core's counting "
     "laws, by proofs that do not pass through the Gibbs argument above (`FreeEnergy.surprisal_le_freeEnergy_of_counts`, "
     "`FreeEnergy.freeEnergy_eq_surprisal_iff_of_counts`, `FreeEnergy.proportional_iff_posterior`, "
     "`FreeEnergy.surprisal_lt_freeEnergy_of_counts`); the log ratio is `N` times the divergence from the posterior "
     "(`FreeEnergy.divergence_counts`); in a core generative model, against the joint shares and the record's share, the "
     "identity holds with the whole weight dropping out, and the bound, its equality at the share given the record and "
     "its strictness elsewhere follow from the core's (`FreeEnergy.gap_counts_given_record`, "
     "`FreeEnergy.record_surprisal_le_freeEnergy_of_counts`, "
     "`FreeEnergy.freeEnergy_eq_record_surprisal_iff_toReal_of_counts`, "
     "`FreeEnergy.record_surprisal_lt_freeEnergy_of_counts`). The identity can fail with a hypothesis listed twice "
     "(`FreeEnergy.Witness.gap_counts_duplicate`) or off the support (`FreeEnergy.Witness.gap_counts_off_support`). ")
edit(C03, "and new is the join: the core states the posterior by counting, and the periphery characterizes it as the one "
          "minimizer of free energy. The law is in the periphery; its counting form, with its case of equality, is in the "
          f"pure core ([below](#r-{RIDC})); no process",
     "and new is the join: the core states the posterior by counting, and the periphery characterizes it as the one "
     "minimizer of free energy. The counting identity is near-definitional as well; new with it is that, for beliefs in "
     "counts, the bound is a consequence of a law of the pure core. The law is in the periphery; its counting form, with "
     f"its case of equality, is in the pure core ([below](#r-{RIDC})), the two one law on beliefs in counts over "
     "hypotheses listed once, on the support; no process")
edit(C03, "off that support the bound fails under Mathlib's `log 0 = 0`, `FreeEnergy.Witness.bound_fails_off_support`)",
     "off that support the bound can fail under Mathlib's `log 0 = 0`, `FreeEnergy.Witness.bound_fails_off_support`)")
edit(C03, "while the real form under `log 0 = 0` fails there, so off the support the two laws are not one",
     "while the real form under `log 0 = 0` can fail there (`FreeEnergy.Witness.gap_counts_off_support`), and where the "
     "identity joining them holds off the support, at one count, the real form can be at equality while this bound is strict "
     "(`FreeEnergy.Witness.one_count_off_support`), so off the support the two laws are not one")
edit(C03, "for the belief whose shares are `n / N`, with `N` positive and on the support, the "
          "[free-energy bound](#r-free-energy-bounds-surprisal) exponentiated.",
     "for the belief whose shares are `n / N`, with `N` positive, on the support and with the hypotheses listed once, the "
     "[free-energy bound](#r-free-energy-bounds-surprisal) exponentiated, `N` times the free energy less the surprisal "
     "being the logarithm of the ratio of the two sides (`FreeEnergy.gap_counts`).")
edit(C03, "In counts the bound is Cauchy's arithmetic–geometric mean inequality (1821), equivalently Gibbs' inequality for "
          "rational shares;",
     "In counts the bound is Cauchy's arithmetic–geometric mean inequality (1821), equivalently, through that identity, "
     "Gibbs' inequality for rational shares;")

C08 = CH / '08-METHOD.md'
edit(C08, "stated in the pure core with its case of equality ([03 §6](03-KNOWING.md#r-free-energy-bound-in-counts)).",
     "stated in the pure core with its case of equality ([03 §6](03-KNOWING.md#r-free-energy-bound-in-counts)); for "
     "beliefs in counts over hypotheses listed once, on the support, the real form is its logarithm, `N` times the free energy less the surprisal being the logarithm "
     "of the ratio of its two sides, an identity that is near-definitional, so that there the real bound follows from the "
     "core's ([03 §6](03-KNOWING.md#r-free-energy-bounds-surprisal)).")

# the principle's page
LINK = f'[03 §6](chapters/03-KNOWING.md#r-{RIDC})'
edit(PAGE, "and for beliefs in counts the bound and its equality hold in the pure core;",
     "and for beliefs in counts the bound and its equality hold in the pure core, the real form being their logarithm "
     "over hypotheses listed once, on the support;")
edit(PAGE, f"in counts, with its equality, pure core ({LINK}) |",
     f"in counts, with its equality, pure core ({LINK}), the real form its logarithm on the support |")
edit(PAGE, "exactly at the shares given the record (*any type*; [03 §6](chapters/03-KNOWING.md#r-free-energy-bound-in-counts); "
           "`FreeEnergyCounting.bound_eq_iff`, `FreeEnergyCounting.given_record_eq_iff_share`).",
     "exactly at the shares given the record (*any type*; [03 §6](chapters/03-KNOWING.md#r-free-energy-bound-in-counts); "
     "`FreeEnergyCounting.bound_eq_iff`, `FreeEnergyCounting.given_record_eq_iff_share`). The two forms are one law on "
     "beliefs in counts over hypotheses listed once, on the support: the free energy less the surprisal, times the total "
     "count, is the logarithm of the ratio of the counting bound's two sides, so the two bounds hold there exactly "
     "together, and the core's laws give the real bound, its equality at the posterior and its strictness elsewhere, "
     "also in a core generative model, where the whole weight drops out (*periphery*; `FreeEnergy.gap_counts`, "
     "`FreeEnergy.surprisal_le_freeEnergy_iff_bound`, `FreeEnergy.surprisal_le_freeEnergy_of_counts`, "
     "`FreeEnergy.gap_counts_given_record`). Off the support or with a hypothesis listed twice the identity can fail "
     "(`FreeEnergy.Witness.gap_counts_off_support`, `FreeEnergy.Witness.gap_counts_duplicate`).")
edit(PAGE, "and the bound with its equality in the pure core for beliefs in counts;",
     "the bound with its equality in the pure core for beliefs in counts, and the real form read from it through the "
     "logarithm on the support;")

# the study section
section = (HERE / 'study_ue22.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
section = section.replace('(COUNTS)', f"({MOD['theorems']} theorems in {len(MOD['declarations'])} declarations)")
assert not any(x in section for x in ('{', 'TODO', 'COUNTS', 'REVIEW-PARAGRAPH')), 'a placeholder left'
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# the UE plan and the plan for the principle
UE = ROOT / RF / 'development/ue-unified-explanation'
REC = '../../../../../../theories/becoming/results/records/'
edit(UE / 'PLAN.md', "UE16, UE17, UE18, UE19, UE20 and UE21, and holds UE8.",
     "UE16, UE17, UE18, UE19, UE20, UE21 and UE22, and holds UE8.")
ITEM6 = ("The periphery keeps the real form (UE17); the core then states the bound itself.\n")
edit(UE / 'FEP-INTEGRATION.md', ITEM6,
     ITEM6 + f"7. **UE22. The counting form and the real form, joined** (landed as a section of `FreeEnergyReals`, with "
     f"laws in [the bound's record]({REC}{RIDFE}.md), study section {N}). For a belief in counts over hypotheses listed "
     "once, with a positive total and no count where a weight is nothing, the total times the free energy less the "
     "surprisal is the logarithm of the ratio of the counting bound's two sides; so the two bounds hold there exactly "
     "together, the real bound at such beliefs, its equality at the posterior and its strictness elsewhere follow from the "
     "core's counting laws, the log ratio is the total times the divergence from the posterior, and in a core generative "
     "model the same holds with the whole weight dropping out. The identity can fail off the support or with a "
     "hypothesis listed twice.\n")

# regions: the note of free-energy-bounds-surprisal
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
note = reg['records'][RIDFE]['note']
assert 'UE22' not in note
reg['records'][RIDFE]['note'] = note + '; UE22: for beliefs in counts, the bound in counts through the logarithm'
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 03 §6 (two home sections), 08 §8, the page, study section', N, ', UE plan and FEP-INTEGRATION, regions')
