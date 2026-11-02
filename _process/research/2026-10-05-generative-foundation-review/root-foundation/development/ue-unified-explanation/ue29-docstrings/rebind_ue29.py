#!/usr/bin/env python3
"""UE29's records and 08's counts after its three checker runs (repoint_ue22.py's and reland_ue28.py's patterns).

Each run is read first: the core receipt passed, with the four changed modules at their current bytes and every
axiom report empty; each periphery receipt passed at the current bytes of its module, every axiom it reports among
Lean's three standard ones. Then the proof bindings of FreeEnergyCounting, Ranking, MapRegions and BlanketCouplings
move to the core receipt, of
FreeEnergyReals and ExpectedFreeEnergyReals to theirs, through tools/research/repoint.py, and the records touched must
be exactly the eleven read for this landing (each cites these modules for what their declarations prove; a docstring
changes none of it). 08's sentence on the core receipt takes its counts from the new receipt. Without --apply,
everything is checked and nothing written.
usage (from the checkout root of the landing worktree): python3 -B rebind_ue29.py CORE FE EFE [--apply]"""
import json
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path.cwd()
args = [a for a in sys.argv[1:] if a != '--apply']
APPLY = '--apply' in sys.argv[1:]
CORE, FE, EFE = args
LEANR = 'experiments/integrated-correction/general-framework/generative-basis/lean'
PKG = f'{LEANR}/becoming'
FEDIR = f'{LEANR}/free-energy'
FEC, RANKING = f'{PKG}/Becoming/FreeEnergyCounting.lean', f'{PKG}/Becoming/Ranking.lean'
MAPREGIONS, BLANKET = f'{PKG}/Becoming/MapRegions.lean', f'{PKG}/Becoming/BlanketCouplings.lean'
FER, EFER = f'{FEDIR}/FreeEnergyReals.lean', f'{FEDIR}/ExpectedFreeEnergyReals.lean'
CORE_R = f'{PKG}/becoming-checks/{CORE}/verification.json'
FE_R = f'{FEDIR}/free-energy-reals-checks/{FE}/verification.json'
EFE_R = f'{FEDIR}/expected-free-energy-reals-checks/{EFE}/verification.json'
STANDARD = {'propext', 'Classical.choice', 'Quot.sound'}
REASON = ("UE29: docstrings only, no statement changed (FreeEnergyCounting's off-support docstrings, RECHECK-UE22 N2; "
          "Ranking's four J1/J2 labels; the second Lean review's narrowing in MapRegions and BlanketCouplings); each record citing these modules was read against the change, a docstring "
          "changing nothing its declarations prove, and nothing any of them says changed")
EXPECTED = {
    'core': {'basic-priority-step-by-step', 'becoming-renewal-reading', 'ranking-under-readings',
             'relation-level-law-of-easing', 'relational-reading-comparison', 'stepwise-law-of-easing',
             'free-energy-bound-in-counts', 'free-energy-bounds-surprisal',
             'a-formations-couplings-as-its-blanket', 'generation-and-degeneration-at-two-grains'},
    'fe': {'free-energy-bounds-surprisal', 'expected-free-energy-and-its-terms'},
    'efe': {'expected-free-energy-and-its-terms'},
}


def sha(path):
    import hashlib
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


core = json.loads((ROOT / CORE_R).read_text())
assert core['status'] == 'passed', CORE_R
for name, path in (('Becoming.FreeEnergyCounting', FEC), ('Becoming.Ranking', RANKING),
                   ('Becoming.MapRegions', MAPREGIONS), ('Becoming.BlanketCouplings', BLANKET)):
    assert core['source_sha256'][name] == sha(path), f'{CORE} does not bind the current {path}'
    module = next(m for m in core['modules'] if m['module'] == name)
    assert not any(module['axiom_dependencies'].values()), f'{name} has a nonempty axiom report'
for receipt_path, name, path in ((FE_R, 'FreeEnergyReals', FER), (EFE_R, 'ExpectedFreeEnergyReals', EFER)):
    r = json.loads((ROOT / receipt_path).read_text())
    assert r['status'] == 'passed', receipt_path
    assert r['source_sha256'][name] == sha(path), f'{receipt_path} does not bind the current {path}'
    assert r['source_sha256'].get('Becoming.FreeEnergyCounting', sha(FEC)) == sha(FEC), f'{receipt_path}: an older FreeEnergyCounting'
    reported = set()

    def axioms(o):
        if isinstance(o, dict):
            for k, v in o.items():
                if 'axiom' in k and isinstance(v, dict):
                    for deps in v.values():
                        if isinstance(deps, list):
                            reported.update(deps)
                axioms(v)
        elif isinstance(o, list):
            for v in o:
                axioms(v)
    axioms(r)
    assert reported <= STANDARD, (receipt_path, sorted(reported - STANDARD))


def repoint(extra, key):
    run = subprocess.run([sys.executable, '-B', 'tools/research/repoint.py', '--reason', REASON] + extra
                         + (['--apply'] if APPLY else []), cwd=ROOT, capture_output=True, text=True)
    assert run.returncode == 0, run.stderr[-2000:]
    summary = json.loads(run.stdout)
    got = set(summary['by_record'])
    assert got == EXPECTED[key], (key, sorted(got ^ EXPECTED[key]))
    print(key, summary['records'], 'records', 'written' if APPLY else '(dry run)', sorted(got))


repoint(['--paths', FEC, RANKING, MAPREGIONS, BLANKET, '--receipt', CORE_R, '--lean', FEC, RANKING, MAPREGIONS, BLANKET],
        'core')
repoint(['--ids', *sorted(EXPECTED['fe']), '--paths', FER, '--receipt', FE_R, '--lean', FER], 'fe')
repoint(['--ids', *sorted(EXPECTED['efe']), '--paths', EFER, '--receipt', EFE_R, '--lean', EFER], 'efe')

# 08: receipt and counts, every count read from the receipt (reland_ue28.py's sentence)
layers = {}
for module in core['modules']:
    count = layers.setdefault(module['layer'], [0, 0])
    count[0] += 1
    count[1] += module['theorems']
assert set(layers) <= {'foundation', 'core', 'instance', 'application'}, set(layers)
modules = sum(v[0] for v in layers.values())
theorems = sum(v[1] for v in layers.values())
assert modules == len(core['core_closure']), (modules, len(core['core_closure']))
ring = layers.get('instance', [0, 0])[0] + layers.get('application', [0, 0])[0]
declarations = sum(len(m['declarations']) for m in core['modules'])
injeq = sum(1 for name, axioms in core['generated_axiom_dependencies'].items()
            if name.endswith('.injEq') and axioms == ['propext'])
assert injeq == len(core['generated_axiom_dependencies']), 'a generated dependency other than injEq on propext'
link = f'../../../{PKG}/becoming-checks/{CORE}/verification.json'
counts = (f"At core receipt [`{CORE}`]({link}) (Lean 4.29.1), the closure held {modules} modules "
          f"({layers['foundation'][0]} foundation, {layers['core'][0]} core, {ring} in the instance and application ring) "
          f"and {theorems:,} theorems; the {layers['core'][0]} core modules held {layers['core'][1]:,} of them; "
          f"{declarations:,} declarations were audited; {injeq} generated `injEq` lemmas depend on `propext`; "
          f"{len(core['superseded_modules'])} superseded modules were kept out of the run.")
path = ROOT / 'theories/becoming/chapters/08-METHOD.md'
s = path.read_text(encoding='utf-8')
s2, k = re.subn(r"At core receipt \[`[0-9TZ.]+`\]\([^)]*\) \(Lean 4\.29\.1\), the closure held \d+ modules \(\d+ foundation, "
                r"\d+ core, \d+ in the instance and application ring\) and [\d,]+ theorems; the \d+ core modules held [\d,]+ of "
                r"them; [\d,]+ declarations were audited; \d+ generated `injEq` lemmas depend on `propext`; \d+ superseded "
                r"modules were kept out of the run\.", lambda m: counts, s)
assert k == 1, k
if APPLY:
    path.write_text(s2, encoding='utf-8')
print('08:', counts[:160], '...', 'written' if APPLY else '(dry run)')
