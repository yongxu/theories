#!/usr/bin/env python3
"""A dry run of OU7's landing in a throwaway git tree, with no Lean. The tree holds main's files that the kit reads or
writes, and the study folder as this checkout has it. The run takes the land script's prepare stage and its apply
stage twice. It then takes the post stage's own steps against a synthetic receipt and connectivity log:
  - record, twice (the two general laws in the two records of the laws they generalize, the one record whose words
    the joins make false, and the two records the owner's patches change, included);
  - the re-point of those five records and of the one whose cut the owner's patches write anew, as the post stage
    makes it from the drift;
  - register, after a refused log, then once more;
  - study, twice.
Last, OU7's two records and those six go through the registry's own validation and the lint. Nothing in the
repository is written. Each stage in the kit's stages/ rides along as the landing takes it (a SKIP file or OU7_STAGES
leaves one out): the tree holds the files its patches change, the synthetic receipt its declarations, and the records
its patches change are re-pointed and validated with the rest.

  python3 -B <kit>/dry_run.py OUT [MAIN]     OUT: a new folder outside the repository; MAIN: the commit, by default
                                             refs/heads/main

The synthetic receipt is MAIN's latest receipt with the patched sources' hashes, the patches' three laws, the owner's
moved and added declarations and the three leaves as they would be checked (every axiom report empty; part A's leaf in
the core, part B's two in the instance ring). It stands in for the core run, which only the rehearsal and the landing make. The steps that need the run itself (master laws, the re-point, render and the
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
GENERALIZED = ('continuation-relative-to-a-class', 'classical-definitions-in-the-grammar')
WORDS = ('generation-and-degeneration-at-two-grains',)     # pins MapRegions; the record stage corrects its words
OWNER = ('master-laws-on-the-grammar', 'not-going-out-of-a-region')   # the record stage applies the owner's items
CUT = ('conveyance-crosses-the-boundary',)                 # pins Standpoints, whose cut the owner's patch writes anew
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
                           'Becoming/GrammarLaws.lean', 'Becoming/MapRegions.lean', 'Becoming/GrammarCrossing.lean',
                           'Becoming/Standpoints.lean', 'Becoming/ConveyanceBoundaries.lean',
                           f'becoming-checks/{latest}/verification.json')]
paths += ['_process/research-config.json', RF + 'development/one-unfolding-root/PLAN.md',
          RF + 'THEOREM-CONNECTIVITY-APART.json', RF + 'BECOMING-RENEWAL-READING.md', 'theories/becoming/chapters',
          'theories/becoming/results/records', 'theories/becoming/results/data', 'theories/becoming/results/completion',
          'tools/research', '_process/architecture/rebinds.jsonl']
# Each stage's patches: the files they change that MAIN holds, and the records among them.
STAGE_DIRS = sorted(d for d in (REPO / KIT / 'stages').iterdir() if d.is_dir()) if (REPO / KIT / 'stages').is_dir() else []
touched = sorted({m.group(1) for d in STAGE_DIRS for x in sorted(d.glob('*.patch'))
                  for m in re.finditer(r'^diff --git a/(\S+) b/', x.read_text(encoding='utf-8'), re.M)})
held = set(run('git', 'ls-tree', '-r', '--name-only', MAIN, '--', *touched, cwd=REPO).stdout.split()) if touched else set()
paths += [x for x in touched if x in held and not any(x == q or x.startswith(q + '/') for q in paths)]
STAGE_RECORDS = tuple(Path(x).stem for x in touched
                      if x.startswith('theories/becoming/results/records/') and x.endswith('.json'))
STAGE_LEAN = [x for x in touched if x.startswith(PKG + 'Becoming/') and x.endswith('.lean')]
# Every file the records the kit and the stages change reference or keep a text version in, so that they validate in
# the tree as in the checkout.
for rid in GENERALIZED + WORDS + OWNER + CUT + tuple(r for r in STAGE_RECORDS
                                                    if f'theories/becoming/results/records/{r}.json' in held):
    rec = json.loads(run('git', 'show', f'{MAIN}:theories/becoming/results/records/{rid}.json', cwd=REPO).stdout)
    paths += [x['path'] for x in rec['references'] + rec.get('text_versions', []) if x['path'] not in paths]
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
    """MAIN's latest receipt with the patched sources' hashes, the patches' three laws, the owner's declarations and
    the three leaves."""
    mods, cwd = {}, Path.cwd()
    os.chdir(TREE)      # the record makers read the tree from the working folder
    try:
        for name in ('make_record_ou7', 'make_record_ou7b', 'integrate_ou7'):
            spec = importlib.util.spec_from_file_location(name, TREE / KIT / f'{name}.py')
            mods[name] = sys.modules[name] = importlib.util.module_from_spec(spec)
            spec.loader.exec_module(mods[name])
    finally:
        os.chdir(cwd)
    mr, mb, kit = mods['make_record_ou7'], mods['make_record_ou7b'], mods['integrate_ou7']
    r = json.loads((TREE / PKG / f'becoming-checks/{latest}/verification.json').read_text(encoding='utf-8'))
    r['utc'], r['status'], r['retained_run'] = STAMP, 'passed', f'becoming-checks/{STAMP}'
    by = {m['module']: m for m in r['modules']}
    # Every package source the patches and the stages changed, at its new hash.
    for path in run('git', 'diff', '--name-only', 'HEAD', '--', PKG + 'Becoming/').stdout.split():
        if path.endswith('.lean'):
            module = 'Becoming.' + path[len(PKG + 'Becoming/'):-len('.lean')].replace('/', '.')
            r['source_sha256'][module] = hashlib.sha256((TREE / path).read_bytes()).hexdigest()
    for module in mr.BELOW:     # exactly the declarations the patches add, as the audit checks
        for name in sorted((mr.PATCHED & mr.BELOW_NAMES[module]) - {d['name'] for d in by[module]['declarations']}):
            by[module]['declarations'].append({'kind': 'theorem', 'name': name})
            by[module]['axiom_dependencies'][name] = []
            by[module]['theorems'] += 1
    # The owner's: MOVED leave GrammarCrossing for GrammarLaws, which gains the two readings of a region not crossed.
    for name, (source, target) in kit.MOVED.items():
        entry = next(d for d in by[source]['declarations'] if d['name'] == name)
        by[source]['declarations'].remove(entry)
        del by[source]['axiom_dependencies'][name]
        by[target]['declarations'].append(entry)
        by[target]['axiom_dependencies'][name] = []
        if entry['kind'] == 'theorem':
            by[source]['theorems'] -= 1
            by[target]['theorems'] += 1
    for name in kit.NOT_CROSSED:
        by['Becoming.GrammarLaws']['declarations'].append({'kind': 'theorem', 'name': name})
        by['Becoming.GrammarLaws']['axiom_dependencies'][name] = []
        by['Becoming.GrammarLaws']['theorems'] += 1
    # Each stage in place: what its EXPECTED.json adds (a theorem or not, read from the source), moves and renames,
    # each found in the receipt by its name or, for a name the audit keys without its namespace, by its last part. A
    # module a stage adds is not modelled here.
    def find(module, name):
        return next((d for d in by[module]['declarations'] if d['name'] == name), None) or \
            next((d for d in by[module]['declarations'] if d['name'].endswith('.' + name.split('.')[-1])), None)
    for stage, data in kit.stage_data():
        for module, names in data.get('added', {}).items():
            whole = kit.statements((TREE / kit.source_of(module)).read_text(encoding='utf-8'))[1]
            for name in names:
                if name in data.get('moved', {}) or find(module, name):
                    continue
                theorem = whole.get(name, '').startswith('theorem ')
                by[module]['declarations'].append({'kind': 'theorem' if theorem else 'def', 'name': name})
                by[module]['axiom_dependencies'][name] = []
                by[module]['theorems'] += theorem
        for name, (source, target) in data.get('moved', {}).items():
            entry = find(source, name)
            assert entry, (stage.name, 'moves a declaration the receipt does not hold', name, source)
            by[source]['declarations'].remove(entry)
            by[target]['declarations'].append(entry)
            by[target]['axiom_dependencies'][entry['name']] = by[source]['axiom_dependencies'].pop(entry['name'], [])
            if entry['kind'] == 'theorem':
                by[source]['theorems'] -= 1
                by[target]['theorems'] += 1
        for old, new in data.get('renamed', {}).items():
            for module in by.values():
                entry = next((d for d in module['declarations'] if d['name'] == old), None)
                if entry:
                    entry['name'] = new
                    module['axiom_dependencies'][new] = module['axiom_dependencies'].pop(old, [])
    leaves = [(mr.MODULE, mr.SOURCE, mr.LEAF, mr.THEOREMS, 'core', 'core_modules')] + \
             [(m, p, mb.LEAVES[m], mb.THEOREMS[m], 'instance', 'instance_modules') for m, p in mb.MODULES.items()]
    for module, path, names, theorems, layer, listed in leaves:
        assert module not in by, module
        r['source_sha256'][module] = hashlib.sha256((TREE / path).read_bytes()).hexdigest()
        r['source_paths'][module] = 'becoming/' + path[len(PKG):]
        r['modules'].append({'module': module, 'spine': True, 'layer': layer, 'theorems': theorems,
                             'declarations': [{'kind': 'declaration', 'name': n} for n in names],
                             'axiom_dependencies': {n: [] for n in names}, 'kernel_checked': True})
        for key in ('spine_modules', listed, 'core_closure', 'compile_order'):
            r[key].append(module)
    (TREE / RECEIPT).parent.mkdir(parents=True)
    (TREE / RECEIPT).write_text(json.dumps(r, ensure_ascii=False, indent=1), encoding='utf-8')
    top = json.loads((TREE / PKG / 'becoming-verification.json').read_text(encoding='utf-8'))
    top.update(utc=STAMP, retained_run=f'becoming-checks/{STAMP}')
    (TREE / PKG / 'becoming-verification.json').write_text(json.dumps(top, ensure_ascii=False, indent=1), encoding='utf-8')
    return mr, mb, kit


mr, mb, kit = synthetic_receipt()
print('== synthetic receipt', RECEIPT)

# ------------------------------------------------------------------------------------------------- post's own steps

text = (TREE / RF / 'BECOMING-RENEWAL-READING.md').read_text(encoding='utf-8')
N = str(max(int(x) for x in re.findall(r'^## (\d+)\. ', text, re.M)) + 1)
integrate = ['python3', '-B', KIT + 'integrate_ou7.py']
show('record', run(*integrate, 'record', RECEIPT, N), 30)
second = run(*integrate, 'record', RECEIPT, N)
assert 'applied' not in second.stdout.replace('already in place', ''), second.stdout
show('record, a second time', second, 6)

# The post stage re-points the records whose pinned sources the patches changed, from the drift; here, the two
# generalized records, the one whose words changed, the owner's two and the one pinning Standpoints, bound to the
# synthetic receipt as the landing binds them to the run's.
lean = [mr.BELOW[m] for m in ('Becoming.Grammar', 'Becoming.GrammarReadings')] + \
       [PKG + f'Becoming/{n}.lean' for n in ('MapRegions', 'GrammarLaws', 'GrammarCrossing', 'Standpoints',
                                            'ConveyanceBoundaries')]
lean += [x for x in STAGE_LEAN if x not in lean and (TREE / x).exists()]
STAGE_IDS = tuple(r for r in STAGE_RECORDS if (TREE / f'theories/becoming/results/records/{r}.json').exists())
show('re-point of the six records the record stage changed or whose sources the patches changed', run(
    'python3', '-B', 'tools/research/repoint.py', '--reason', 'OU7 dry run', '--ids', *GENERALIZED, *WORDS, *OWNER,
    *CUT, *STAGE_IDS, '--paths', *lean, RF + 'development/one-unfolding-root/PLAN.md', '--receipt', RECEIPT, '--lean', *lean,
    '--apply'), 8)

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
listed = sorted(part_b['roots']) + witnesses + sorted(kit.OWNER_ROOTS) + sorted(kit.stage_roots()[0]) + \
    ['Becoming.SomeoneElse.root']
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
            'print(len(mine), "findings on the", len(ids), "records;", len(findings) - len(mine), "elsewhere (this tree holds "'
            '"only the files the kit touches)")')
show('the records through the registry and the lint', run('python3', '-B', '-c', validate, mr.RID, mb.RID,
                                                          *GENERALIZED, *WORDS, *OWNER, *CUT, *STAGE_IDS), 40)
show('what the dry run changed in the tree', run('git', 'status', '--short'), 40)
print('dry run done:', TREE)
