#!/usr/bin/env python3
"""A dry run of OU7's landing in a throwaway git tree, with no Lean. The tree holds main's files that the kit reads or
writes, every file the kit's patches and the stages' change, every record pinning a file the tree holds with every
file it references, and the study folder as this checkout has it; its one commit has MAIN for its parent, so that the
registry reads every version a record was reviewed against, as in the checkout. The run takes the land script's prepare stage and
its apply stage twice. It then takes the post stage's own steps against a synthetic receipt and connectivity log:
  - record, twice (the two general laws in the two records of the laws they generalize, the two records whose words
    the joins and patches make false, and the two records the owner's patches change, included);
  - the re-point, as the post stage makes it: exactly the registry's drift, the Lean files' proof bindings rebound;
  - register, after a refused log, then once more;
  - study, twice.
Last, OU7's two records, those the record stage changes, every re-pointed record and the stages' go through the
registry's own validation and the lint, and no record is left drifting. Nothing in the repository is written. Each
stage in the kit's stages/ rides along as the landing takes it (a SKIP file or OU7_STAGES leaves one out): the tree
holds the files its patches change, the synthetic receipt its declarations, and the records its patches change are
re-pointed and validated with the rest. A stage that is empty or does not apply is dropped, named, and the run goes
on without it, as the landing would with OU7_STAGES set to the stages left.

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
from datetime import datetime, timezone
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
STAMP = datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S.%fZ')   # the synthetic receipt's, after every receipt of MAIN's
GENERALIZED = ('continuation-relative-to-a-class', 'classical-definitions-in-the-grammar')
WORDS = ('generation-and-degeneration-at-two-grains',     # pins MapRegions; the record stage corrects its words
         'balance-from-conservation-along-a-relation')     # pins BalanceRegions; reuses «不出», now GrammarLaws'
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
          'tools/research', '_process/architecture/rebinds.jsonl', '_process/architecture/moves']


def patch_paths(patches):
    """The paths the patches change, as git reads them (a rename gives both)."""
    out = set()
    for p in patches:
        fields = run('git', 'apply', '--numstat', '-z', str(p), cwd=REPO).stdout.split('\0')
        i = 0
        while i < len(fields) and fields[i]:
            path = fields[i].split('\t', 2)[2]
            if path:
                out.add(path)
                i += 1
            else:
                out.update(fields[i + 1:i + 3])
                i += 3
    return out


def selected_stages():
    """The stages the landing takes, as integrate_ou7.py selects them (a SKIP file, OU7_STAGES)."""
    found = sorted(d for d in (REPO / KIT / 'stages').iterdir() if d.is_dir()) if (REPO / KIT / 'stages').is_dir() else []
    wanted = os.environ.get('OU7_STAGES')
    if wanted is not None:
        names = set(wanted.replace(',', ' ').split()) - {'none'}
        assert names <= {d.name for d in found}, ('OU7_STAGES names no stage', sorted(names - {d.name for d in found}))
        found = [d for d in found if d.name in names]
    return [d for d in found if not (d / 'SKIP').exists()]


def held_by_main(names):
    """Of `names`, those MAIN holds (read NUL-separated, so that no path is quoted)."""
    listed = run('git', 'ls-tree', '-r', '-z', '--name-only', MAIN, '--', *names, cwd=REPO).stdout if names else ''
    return set(listed.split('\0')) - {''}


def extract(names):
    archive = subprocess.run(['git', 'archive', MAIN, '--', *names], cwd=REPO, capture_output=True, check=True).stdout
    subprocess.run(['tar', '-x', '-C', str(TREE)], input=archive, check=True)


# The kit's patches and the selected stages': every file they change that MAIN holds, and the stages' records.
STAGE_DIRS = selected_stages()
KIT_PATCHES = [REPO / KIT / 'patches' / n for n in ('Grammar.patch', 'GrammarReadings.patch', 'MapRegions.patch',
                                                    'PLAN.patch')] + [REPO / STUDY / 'check/kit/GrammarTesting.patch'] + \
    sorted((REPO / KIT / 'patches/owner').glob('*.patch'))
STAGE_TOUCHED = patch_paths([p for d in STAGE_DIRS for p in sorted(d.glob('*.patch'))])
touched = sorted(patch_paths(KIT_PATCHES) | STAGE_TOUCHED)
held = held_by_main(touched)
paths += [x for x in touched if x in held and not any(x == q or x.startswith(q + '/') for q in paths)]
TREE.mkdir(parents=True)
LOG.mkdir()
extract(paths)
# Every record pinning a file the tree holds, which the landing may change, with every file it references or keeps a
# text version in, so that its drift and its validation run in the tree as in the checkout.
extra = set()
for f in sorted((TREE / 'theories/becoming/results/records').glob('*.json')):
    rec = json.loads(f.read_text(encoding='utf-8'))
    if any(x.get('sha256') and (TREE / x['path']).is_file() for x in rec.get('references', [])):
        extra |= {x['path'] for x in rec.get('references', []) + rec.get('text_versions', [])
                  if not (TREE / x['path']).exists()}
extra = held_by_main(sorted(extra))
if extra:
    extract(sorted(extra))
print('tree: the kit\'s files,', len(touched), 'files the patches change, and', len(extra), 'more that the records '
      'pinning those reference')
shutil.copytree(REPO / STUDY, TREE / STUDY, ignore=shutil.ignore_patterns('__pycache__', '.lake', '.build'))
# The tree's one commit has MAIN for its parent, read through the repository's objects, so that the registry finds in
# HEAD's history every version a record was reviewed against, as in the checkout: a source grown only outside what a
# record cites stays grown, not drift. Nothing is written to the repository's objects.
run('git', 'init', '-q')
common = Path(run('git', 'rev-parse', '--path-format=absolute', '--git-common-dir', cwd=REPO).stdout.strip())
(TREE / '.git/objects/info/alternates').write_text(f'{common / "objects"}\n', encoding='utf-8')
run('git', 'add', '-A')
base = run('git', '-c', 'user.name=dry', '-c', 'user.email=dry@invalid', 'commit-tree', '-m', 'base',
           '-p', run('git', 'rev-parse', MAIN, cwd=REPO).stdout.strip(), run('git', 'write-tree').stdout.strip())
run('git', 'update-ref', 'refs/heads/main', base.stdout.strip())
run('git', 'symbolic-ref', 'HEAD', 'refs/heads/main')
run('git', 'checkout', '-q', '-b', 'land')
print('tree', TREE, 'from', run('git', 'rev-parse', '--short', MAIN, cwd=REPO).stdout.strip(), 'and', STUDY)

# ------------------------------------------------------------------------------------------------- prepare, apply

env = {**os.environ, 'LOG': str(LOG)}
show('prepare', run('zsh', KIT + 'land_ou7.sh', 'prepare', env=env))
# A stage that is empty or does not apply stops `apply`, nothing of it written. The dry run drops it, says so, and goes
# on without it, so that a failed stage never holds up OU7's own patches; every later step takes the stages left, as
# the landing does with OU7_STAGES set to them (or a SKIP file in each dropped stage).
DROPPED = []
FAILED_STAGE = re.compile(r'^stage (\S+?)(?:: \S+ does not apply| has no patch)', re.M)
while True:
    applied = run('zsh', KIT + 'land_ou7.sh', 'apply', env=env, ok=False)
    failed = FAILED_STAGE.search(applied.stdout + applied.stderr) if applied.returncode else None
    if failed and failed.group(1) in {d.name for d in STAGE_DIRS} - set(DROPPED):
        DROPPED.append(failed.group(1))
        env['OU7_STAGES'] = os.environ['OU7_STAGES'] = \
            ' '.join(d.name for d in STAGE_DIRS if d.name not in DROPPED) or 'none'
        print(f'== stage {failed.group(1)} dropped, nothing of it written: {failed.group(0)}; the landing takes '
              f'OU7_STAGES="{env["OU7_STAGES"]}" or a SKIP file in stages/{failed.group(1)}/, and OU7 lands without it')
        continue
    if applied.returncode:
        sys.exit(f'FAILED: apply\n{applied.stdout[-3000:]}\n{applied.stderr[-3000:]}')
    break
show('apply', applied, 60)
STAGE_DIRS = [d for d in STAGE_DIRS if d.name not in DROPPED]
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

# The post stage re-points exactly the registry's drift, the Lean files the patches changed rebound to the receipt;
# here the synthetic one, as the landing binds them to the run's.
registry_probe = ('import sys, json; from pathlib import Path; sys.path.insert(0, ".");'
                  'from tools.research import registry, reading_catalogue as rc; real = rc.anchors;'
                  'rc.anchors = lambda p: real(p) if Path(p).exists() else set();'
                  'loaded, errors = registry.load_records(); assert not errors, errors[:3];'
                  'findings, drift = registry.validate(loaded);'
                  'print(json.dumps([{"id": d["id"], "path": d["path"]} for d in drift]))')
drift = json.loads(run('python3', '-B', '-c', registry_probe).stdout)
(LOG / 'drift.json').write_text(json.dumps({'source_drift': drift}, ensure_ascii=False, indent=1), encoding='utf-8')
DRIFTED = tuple(sorted({d['id'] for d in drift}))
lean = [x for x in run('git', 'diff', '--name-only', 'HEAD', '--', PKG + 'Becoming').stdout.split() if x.endswith('.lean')]
STAGE_IDS = tuple(sorted(Path(x).stem for x in patch_paths([p for d in STAGE_DIRS for p in sorted(d.glob('*.patch'))])
                         if x.startswith('theories/becoming/results/records/') and x.endswith('.json')
                         and (TREE / x).exists()))   # the records of the stages taken
show(f're-point of the drift: {len(drift)} pairs in {len(DRIFTED)} records, {len(lean)} Lean files rebound', run(
    'python3', '-B', 'tools/research/repoint.py', '--reason', 'OU7 dry run', '--drift-json', str(LOG / 'drift.json'),
    '--receipt', RECEIPT, '--lean', *lean, '--apply'), 4)
left = json.loads(run('python3', '-B', '-c', registry_probe).stdout)
assert not left, ('drift left after the re-point', left[:5])
print('no drift left after the re-point; re-pointed:', ', '.join(DRIFTED))

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
CHECKED = tuple(dict.fromkeys((mr.RID, mb.RID) + GENERALIZED + WORDS + OWNER + CUT + DRIFTED + STAGE_IDS))
show(f'the {len(CHECKED)} records through the registry and the lint', run('python3', '-B', '-c', validate, *CHECKED), 60)
show('what the dry run changed in the tree', run('git', 'status', '--short'), 40)
print('stages taken:', ' '.join(d.name for d in STAGE_DIRS) or 'none', '| dropped:', ' '.join(DROPPED) or 'none')
print('dry run done:', TREE)
