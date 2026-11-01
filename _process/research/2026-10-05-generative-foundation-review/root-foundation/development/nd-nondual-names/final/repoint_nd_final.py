#!/usr/bin/env python3
"""ND's final stage (repoint_bd4.py's pattern): re-point the records drifting by this stage's edits only.

The drift list of `research.py check` is filtered to the paths this stage changes (the tree's diff against main), so
another session's drift stays with its owner and is printed for it. Every pair kept is printed with its changed
sections, to be read against the new text before --apply; the stage changes names only (the record id in links and
mentions, the generator's and the data's file names, the shared law's name in prose), so a changed section whose diff
holds anything else stops the script.
usage (from the checkout root, after render): python3 -B <kit>/repoint_nd_final.py [--apply]"""
import difflib, functools, json, re, subprocess, sys, tempfile
from pathlib import Path

ROOT = Path.cwd()
APPLY = '--apply' in sys.argv[1:]
REASON = ("ND's final stage: the record id master-laws-on-the-grammar renamed shared-laws-on-the-grammar (links and "
          "mentions rewritten by research.py rename-id), the view's generator and data renamed shared_laws.py and "
          "shared-laws.json, and the shared law's name in prose where master law stood; names only, nothing the "
          "records say changed; read before re-pointing")
NAMES = [(r'(?<![\w-])master-laws-on-the-grammar(?![\w-])', 'shared-laws-on-the-grammar'), (r'master_law', 'shared_law'),
         (r'MASTER_LAW', 'SHARED_LAW'), (r'MasterLaw', 'SharedLaw'), (r'\bmaster_rows\b', 'shared_rows'),
         (r'(?<![\w-])master-laws\.json', 'shared-laws.json'), (r"'master-laws-'", "'shared-laws-'"),
         (r'(?<![\w-])master law', 'shared law'), (r'(?<![\w-])Master law', 'Shared law'),
         (r'harms_superadditive', 'rises_superadditive')]
# Edits that are more than a mapped name, each made by nd_final.py and read there: the glossary's note on where the
# former name is kept, the Lean README's row on no shared law's anchor, and 08 §10's sentence on where the old name
# stays (FIXES, applied to the old text before the comparison, so the rest of 08 is still compared).
FIXES = {'theories/becoming/chapters/08-METHOD.md': [(
    'and the old name stays only in keys (the record id `master-laws-on-the-grammar`, anchors, data fields, tools), '
    'which are matched, not read.',
    "and the old name stays only where it is matched, not read: the record's former id "
    '(`master-laws-on-the-grammar`), anchors kept beside the new ones, and the paths of the studies of its time.')]}
MORE = {'GLOSSARY.md', '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aj4-alignment-readers/FAILURE-MODE-MAP.md', 'theories/becoming/results/data/arguments-a-l.json', 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/README.md'}


def git(*a):
    return subprocess.run(['git', *a], cwd=ROOT, capture_output=True, text=True, check=True).stdout


KIT_MAP = [(r'(?<![\w-])master_laws\.py', 'shared_laws.py'), (r'(?<![\w-])test_master_laws', 'test_shared_laws'),
           (r'(?<![\w-])master-laws\.json', 'shared-laws.json')]
BASE = git('merge-base', 'HEAD', 'main').strip()
mine = set(git('diff', '--name-only', BASE, '--').split()) | set(git('ls-files', '--others', '--exclude-standard').split())
# Each changed text the stage writes by hand or by rename-id, with the names mapped, equals its old text; a record
# also gains one history note (and the renamed one its former id). The generated files are compared by
# nd_final_verify.py, the study's own files not at all.
beyond = []
for path in sorted(mine):
    p = ROOT / path
    if not p.is_file() or path in MORE or 'nd-nondual-names/' in path or path.startswith('_process/architecture/renames/'):
        continue
    new = p.read_text(encoding='utf-8')
    if 'Generated' in new[:400] or path.endswith(('shared-laws.json', 'THEOREM-CONNECTIVITY.json')):
        continue
    src = 'theories/becoming/results/records/master-laws-on-the-grammar.json' if path.endswith('/shared-laws-on-the-grammar.json') else path
    src = {'tools/research/shared_laws.py': 'tools/research/master_laws.py',
           'tools/research/tests/test_shared_laws.py': 'tools/research/tests/test_master_laws.py'}.get(src, src)
    try:
        old = git('show', f'{BASE}:{src}')
    except subprocess.CalledProcessError:
        beyond.append((path, 'new file'))
        continue
    for a, b in FIXES.get(path, []):
        assert old.count(a) == 1, (path, a)
        old = old.replace(a, b)
    raw = old
    record = path.startswith('theories/becoming/results/records/')
    # a kit script on main takes the paths only (nd_final.py's KIT_MAP); the measure and connectivity scripts all names
    kit = path.endswith(('.sh', '.py')) and ('/development/' in path or '/architecture/' in path) \
        and not path.endswith(('measure_grammar.py', 'ec-elegant-completion/measure.py'))
    if kit:
        for a, b in KIT_MAP:
            old = re.sub(a, b, old)
        if old != new:
            beyond.append((path, ''.join(list(difflib.unified_diff(old.splitlines(True), new.splitlines(True), n=0))[:12])))
        continue
    keep = re.compile(r'formerly|主律|replaced')   # a line telling the former name keeps it, as nd_final.py's GUARD
    old = ''.join(line if keep.search(line) else
                  functools.reduce(lambda s, ab: re.sub(ab[0], ab[1], s), NAMES[:4] if record else NAMES, line)
                  for line in old.splitlines(True))   # a record's aliases keep the former name
    if path.startswith('theories/becoming/results/records/') and path.endswith('.json'):
        # history keeps its words: the new history is the old one, unmapped, and at most one note more
        h0, n = json.loads(raw).get('history', []), json.loads(new)
        o = json.loads(old)
        for d in (o, n):
            d.pop('former_ids', None)
            d.pop('id', None)
        h1 = n.pop('history', [])
        o.pop('history', None)
        same = o == n and h1[:len(h0)] == h0 and len(h1) - len(h0) <= 1
    elif path.endswith('/BECOMING-RENEWAL-READING.md'):
        same = new.startswith(raw.rstrip('\n'))   # the study keeps its words and gains this stage's section
    else:
        same = old == new
    if not same:
        beyond.append((path, ''.join(list(difflib.unified_diff(old.splitlines(True), new.splitlines(True), n=0))[:12])))
for x in beyond:
    print('beyond the names:', *x)
if beyond:
    sys.exit('a change beyond the names: read it, then settle it in nd_final.py')

out = subprocess.run([sys.executable, '-B', 'tools/research/research.py', 'check'], cwd=ROOT, capture_output=True,
                     text=True).stdout
data = json.loads(out[out.index('{'):out.rindex('}') + 1])
drift = data.get('source_drift', [])
kept = [x for x in drift if x['path'] in mine]
left = [(x['id'], x['path']) for x in drift if x['path'] not in mine]
print(f're-pointing {len(kept)} pairs in {len({x["id"] for x in kept})} records:')
for x in kept:
    print('  ', x['id'], x['path'], x.get('changed_sections'))
print('left to their owners:', left)
if kept:
    with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
        json.dump({'source_drift': kept}, f)
    r = subprocess.run([sys.executable, '-B', 'tools/research/repoint.py', '--reason', REASON, '--drift-json', f.name]
                       + (['--apply'] if APPLY else []), cwd=ROOT, capture_output=True, text=True)
    Path(f.name).unlink()
    print(r.stdout[-4000:], r.stderr[-2000:])
    assert r.returncode == 0, r.returncode
