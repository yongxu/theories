#!/usr/bin/env python3
"""A dry run of OU7's landing in a throwaway git tree, with no Lean. The tree holds main's files that the kit reads or
writes, and the study folder as this checkout has it. The run takes the land script's prepare stage and its apply
stage twice. It then takes the post stage's own steps against a synthetic receipt and connectivity log:
  - record, twice;
  - register, after a refused log, then once more;
  - study, twice.
Last, both records go through the registry's own validation and the lint. Nothing in the repository is written.

  python3 -B <kit>/dry_run.py OUT [MAIN]     OUT: a new folder outside the repository; MAIN: the commit, by default
                                             refs/heads/main

The synthetic receipt is MAIN's latest receipt with the patched sources' hashes, the patches' three laws and the
three leaves added as they would be checked (every axiom report empty). It stands in for the core run, which only
the rehearsal and the landing make. The steps that need the run itself (master laws, the re-point, render and the
checks) are left to them.
"""
import hashlib
import importlib.util
import json
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

REPO = Path(subprocess.run(['git', 'rev-parse', '--show-toplevel'], capture_output=True, text=True,
                           check=True).stdout.strip())
HERE = Path(__file__).resolve().parent
OUT = Path(sys.argv[1]).resolve()
MAIN = sys.argv[2] if len(sys.argv) > 2 else 'refs/heads/main'
assert not OUT.exists() and REPO not in OUT.parents, 'OUT must be a new folder outside the repository'
TREE, LOG = OUT / 'tree', OUT / 'log'
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = HERE.parent.relative_to(REPO).as_posix() + '/'
KIT = STUDY + 'kit/'
STAMP = '20261101T000000.000000Z'
RECEIPT = PKG + f'becoming-checks/{STAMP}/verification.json'


def run(*args, cwd=None, ok=True, **kw):
    p = subprocess.run(list(args), cwd=cwd or TREE, capture_output=True, text=True, **kw)
    if ok and p.returncode:
        sys.exit(f'FAILED: {" ".join(map(str, args))}\n{p.stdout[-3000:]}\n{p.stderr[-3000:]}')
    return p


def show(title, p, lines=40):
    print(f'== {title}')
    print('\n'.join((p.stdout + p.stderr).rstrip().splitlines()[-lines:]))


# ------------------------------------------------------------------------------------------------- the tree

latest = json.loads(run('git', 'show', f'{MAIN}:{PKG}becoming-verification.json', cwd=REPO).stdout)['utc']
paths = [PKG + n for n in ('Becoming.lean', 'check_becoming.py', 'README.md', 'README.zh.md', 'becoming-verification.json',
                           'Becoming/Grammar.lean', 'Becoming/GrammarReadings.lean', 'Becoming/GrammarTesting.lean',
                           'Becoming/GrammarLaws.lean', f'becoming-checks/{latest}/verification.json')]
paths += ['_process/research-config.json', RF + 'development/one-unfolding-root/PLAN.md',
          RF + 'THEOREM-CONNECTIVITY-APART.json', RF + 'BECOMING-RENEWAL-READING.md', 'theories/becoming/chapters',
          'theories/becoming/results/records', 'theories/becoming/results/data', 'theories/becoming/results/completion',
          'tools/research']
TREE.mkdir(parents=True)
LOG.mkdir()
archive = subprocess.run(['git', 'archive', MAIN, '--', *paths], cwd=REPO, capture_output=True, check=True).stdout
subprocess.run(['tar', '-x', '-C', str(TREE)], input=archive, check=True)
shutil.copytree(REPO / STUDY, TREE / STUDY, ignore=shutil.ignore_patterns('__pycache__', '.lake', '.build'))
run('git', 'init', '-q')
run('git', 'add', '-A')
run('git', '-c', 'user.name=dry', '-c', 'user.email=dry@invalid', 'commit', '-q', '-m', 'base')
run('git', 'branch', '-M', 'main')
run('git', 'checkout', '-q', '-b', 'land')
print('tree', TREE, 'from', run('git', 'rev-parse', '--short', MAIN, cwd=REPO).stdout.strip(), 'and', STUDY)

# ------------------------------------------------------------------------------------------------- prepare, apply

env = {**os.environ, 'LOG': str(LOG)}
show('prepare', run('zsh', KIT + 'land_ou7.sh', 'prepare', env=env))
show('apply', run('zsh', KIT + 'land_ou7.sh', 'apply', env=env), 60)
again = run('zsh', KIT + 'land_ou7.sh', 'apply', env=env)
applied = [l for l in (LOG / 'apply.log').read_text().splitlines() if l.endswith(': applied')]
assert not applied, ('the second apply applied again', applied)
show('apply, a second time: nothing applied again', again, 3)

# ------------------------------------------------------------------------------------------------- the receipt


def synthetic_receipt():
    """MAIN's latest receipt with the patched sources' hashes, the patches' three laws and the three leaves."""
    mods, cwd = {}, Path.cwd()
    os.chdir(TREE)      # the record makers read the tree from the working folder
    try:
        for name in ('make_record_ou7', 'make_record_ou7b'):
            spec = importlib.util.spec_from_file_location(name, TREE / KIT / f'{name}.py')
            mods[name] = sys.modules[name] = importlib.util.module_from_spec(spec)
            spec.loader.exec_module(mods[name])
    finally:
        os.chdir(cwd)
    mr, mb = mods['make_record_ou7'], mods['make_record_ou7b']
    r = json.loads((TREE / PKG / f'becoming-checks/{latest}/verification.json').read_text(encoding='utf-8'))
    r['utc'], r['status'], r['retained_run'] = STAMP, 'passed', f'becoming-checks/{STAMP}'
    by = {m['module']: m for m in r['modules']}
    for module in ('Becoming.Grammar', 'Becoming.GrammarReadings', 'Becoming.GrammarTesting', 'Becoming.GrammarLaws'):
        r['source_sha256'][module] = hashlib.sha256((TREE / PKG / f'Becoming/{module[9:]}.lean').read_bytes()).hexdigest()
    for module in mr.BELOW:
        for name in sorted(mr.BELOW_NAMES[module] - {d['name'] for d in by[module]['declarations']}):
            by[module]['declarations'].append({'kind': 'theorem', 'name': name})
            by[module]['axiom_dependencies'][name] = []
            by[module]['theorems'] += 1
    leaves = [(mr.MODULE, mr.SOURCE, mr.LEAF, mr.THEOREMS)] + \
             [(m, p, mb.LEAVES[m], mb.THEOREMS[m]) for m, p in mb.MODULES.items()]
    for module, path, names, theorems in leaves:
        assert module not in by, module
        r['source_sha256'][module] = hashlib.sha256((TREE / path).read_bytes()).hexdigest()
        r['modules'].append({'module': module, 'spine': True, 'layer': 'core', 'theorems': theorems,
                             'declarations': [{'kind': 'declaration', 'name': n} for n in names],
                             'axiom_dependencies': {n: [] for n in names}, 'kernel_checked': True})
        r['core_closure'].append(module)
    (TREE / RECEIPT).parent.mkdir(parents=True)
    (TREE / RECEIPT).write_text(json.dumps(r, ensure_ascii=False, indent=1), encoding='utf-8')
    top = json.loads((TREE / PKG / 'becoming-verification.json').read_text(encoding='utf-8'))
    top.update(utc=STAMP, retained_run=f'becoming-checks/{STAMP}')
    (TREE / PKG / 'becoming-verification.json').write_text(json.dumps(top, ensure_ascii=False, indent=1), encoding='utf-8')
    return mr, mb


mr, mb = synthetic_receipt()
print('== synthetic receipt', RECEIPT)

# ------------------------------------------------------------------------------------------------- post's own steps

text = (TREE / RF / 'BECOMING-RENEWAL-READING.md').read_text(encoding='utf-8')
N = str(max(int(x) for x in re.findall(r'^## (\d+)\. ', text, re.M)) + 1)
integrate = ['python3', '-B', KIT + 'integrate_ou7.py']
show('record', run(*integrate, 'record', RECEIPT, N), 30)
second = run(*integrate, 'record', RECEIPT, N)
assert 'applied' not in second.stdout.replace('already in place', ''), second.stdout
show('record, a second time', second, 6)

APART = RF + 'THEOREM-CONNECTIVITY-APART.json'
part_b = json.loads((TREE / STUDY / 'check/kit/apart-reasons.json').read_text(encoding='utf-8'))
probe = ('import sys, json; sys.path.insert(0, ".");'
         'import importlib.util; s = importlib.util.spec_from_file_location("i", sys.argv[1]);'
         'i = importlib.util.module_from_spec(s); s.loader.exec_module(i); print(json.dumps(sorted(i.leaf_uses())))')
used = json.loads(run('python3', '-B', '-c', probe, KIT + 'integrate_ou7.py').stdout)
missing = [n for n in part_b['now_used'] if n not in used]
assert not missing, ('part B\'s now-used roots the leaves\' code does not name', missing)
witnesses = [n for n in mr.LEAF if n.endswith('之例»')][:2]


def log(name, listed, gone):
    path = LOG / name
    path.write_text(f'apart roots without a reason in {APART}: {listed}\n'
                    f'register entries no longer apart roots: {gone}\n', encoding='utf-8')
    return str(path)


short = sorted(part_b['roots'])[1:]
refused = run(*integrate, 'register', log('conn-refused.log', short + witnesses, used), ok=False)
assert refused.returncode and 'part B\'s roots differ' in refused.stderr, refused.stderr[-800:]
assert not run('git', 'status', '--porcelain', '--', APART).stdout, 'a refused log changed the register'
show('register refuses a log missing a predicted root of part B, the register untouched', refused, 2)
listed = sorted(part_b['roots']) + witnesses + ['Becoming.SomeoneElse.root']
show('register', run(*integrate, 'register', log('conn.log', listed, used)), 6)
show('register, a second time', run(*integrate, 'register', log('conn-again.log', [], [])), 6)

show('study', run(*integrate, 'study', N, RECEIPT), 3)
show('study, a second time', run(*integrate, 'study', N, RECEIPT), 3)

# ------------------------------------------------------------------------------------------------- the records

# The tree holds only the files the kit touches, so an anchor in a file it lacks reads as none (other records only).
validate = ('import sys, json; from pathlib import Path; sys.path.insert(0, ".");'
            'from tools.research import registry, style, reading_catalogue as rc; real = rc.anchors;'
            'rc.anchors = lambda p: real(p) if Path(p).exists() else set();'
            'loaded, errors = registry.load_records(); assert not errors, errors[:3];'
            'findings, drift = registry.validate(loaded);'
            'ids = sys.argv[1:];'
            'mine = [f for f in findings if any(f.startswith(i + ":") for i in ids)];'
            '[print("FINDING", f[:300]) for f in mine];'
            'rs = [r for r in loaded if r["id"] in ids];'
            '[print("lint", r["id"], f["severity"], f["field"], f["rule"], str(f["detail"])[:120]) for r in rs for f in style.lint(r)];'
            'print(len(mine), "findings on the two records;", len(findings) - len(mine), "elsewhere (this tree holds only "'
            '"the files the kit touches)")')
show('the records through the registry and the lint', run('python3', '-B', '-c', validate, mr.RID, mb.RID), 20)
show('what the dry run changed in the tree', run('git', 'status', '--short'), 40)
print('dry run done:', TREE)
