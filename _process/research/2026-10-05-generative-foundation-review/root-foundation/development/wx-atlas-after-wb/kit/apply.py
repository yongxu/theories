#!/usr/bin/env python3
"""WX: apply the atlas re-sayings after WB. Each edit names the entries it may touch (or '*'), an exact old text, the new
text and the number of fields it must change; the run stops if any count differs. The three entry files (the crosswalk,
its groups, the dynamics atlas) round-trip with indent=1.

usage: python3 -B apply.py [ROOT] [--dry] [--from=COMMIT]   (--from reads both files at COMMIT first, e.g. main)"""
import json
import pathlib
import subprocess
import sys

sys.path.insert(0, str(pathlib.Path(__file__).parent))
from edits import EDITS  # noqa: E402

ROOT = pathlib.Path(next((a for a in sys.argv[1:] if not a.startswith('--')), '.'))
DRY = '--dry' in sys.argv
E = ROOT / 'theories/becoming/results/atlas/entries'


def leaves(x, path):
    if isinstance(x, str):
        yield path, x
    elif isinstance(x, dict):
        for k, v in x.items():
            yield from leaves(v, path + [k])
    elif isinstance(x, list):
        for i, v in enumerate(x):
            yield from leaves(v, path + [i])


def setp(obj, path, val):
    for k in path[:-1]:
        obj = obj[k]
    obj[path[-1]] = val


FROM = next((a.split('=', 1)[1] for a in sys.argv[1:] if a.startswith('--from=')), None)


def load(fn):
    if FROM:
        rel = (E / fn).resolve().relative_to(ROOT.resolve())
        return json.loads(subprocess.check_output(['git', '-C', str(ROOT), 'show', f'{FROM}:{rel}']).decode('utf-8'))
    return json.loads((E / fn).read_text(encoding='utf-8'))


data = {fn: load(fn) for fn in ('correspondences.json', 'dynamics.json', 'correspondence_groups.json')}
byid = {e['id']: e for d in data.values() for e in d}
total = 0
for k, ed in enumerate(EDITS):
    ids, old, new, n = ed
    assert old != new, k
    scope = list(byid.values()) if ids == '*' else [byid[i] for i in ids]
    hit = []
    for e in scope:
        for p, s in leaves(e, []):
            c = s.count(old)
            if c > 1:
                raise SystemExit(f'edit {k}: {e["id"]} {p}: {c} occurrences of {old[:60]!r}')
            if c == 1:
                hit.append((e, p, s))
    if len(hit) != n:
        raise SystemExit(f'edit {k}: {len(hit)} fields, expected {n}: {old[:80]!r} {[h[0]["id"] for h in hit]}')
    for e, p, s in hit:
        setp(e, p, s.replace(old, new))
    total += len(hit)
for fn, d in data.items():
    raw = json.dumps(d, ensure_ascii=False, indent=1) + '\n'
    json.loads(raw)
    if not DRY:
        (E / fn).write_text(raw, encoding='utf-8')
print(('dry: ' if DRY else '') + f'{len(EDITS)} edits, {total} field changes')
