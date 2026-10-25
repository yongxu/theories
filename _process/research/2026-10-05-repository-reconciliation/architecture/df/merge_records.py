#!/usr/bin/env python3
"""Three-way merge of DF's record changes onto a newer main, field by field (run from the checkout root).

usage: merge_records.py BASE OURS THEIRS [--write]

For every record OURS changed since BASE, applies those changes to THEIRS's version: history entries OURS added are
appended after THEIRS's; references and proof bindings are merged by source path; other lists element by element
when no side changed their length; a field both sides changed differently is a conflict, reported and not written.
reviewed_at_utc takes the later time. Writes in the records' own format (indent 2, UTF-8)."""
import json
import subprocess
import sys

BASE, OURS, THEIRS = sys.argv[1:4]
WRITE = '--write' in sys.argv
MISSING = object()


def show(rev, path):
    r = subprocess.run(['git', 'show', f'{rev}:{path}'], capture_output=True, text=True)
    return r.stdout if r.returncode == 0 else None


class Conflict(Exception):
    pass


def keyed(items, key):
    return all(isinstance(x, dict) and key in x for x in items)


def merge(b, o, m, where):
    if o == b:
        return m
    if m == b or o == m:
        return o
    if where.endswith('.reviewed_at_utc'):
        return max(o, m)
    if isinstance(b, dict) and isinstance(o, dict) and isinstance(m, dict):
        out = {}
        for k in list(m) + [k for k in o if k not in m]:
            v = merge(b.get(k, MISSING), o.get(k, MISSING), m.get(k, MISSING), f'{where}.{k}')
            if v is not MISSING:
                out[k] = v
        return out
    if isinstance(b, list) and isinstance(o, list) and isinstance(m, list):
        if where.endswith('.history'):
            assert o[:len(b)] == b, where
            return m + [x for x in o[len(b):] if x not in m]
        for key in ('path', 'source'):
            if keyed(b + o + m, key):
                bk = {x[key]: x for x in b}
                ok = {x[key]: x for x in o}
                mk = {x[key]: x for x in m}
                if len(bk) != len(b) or len(ok) != len(o) or len(mk) != len(m):
                    break
                out = []
                for x in m:
                    k = x[key]
                    v = merge(bk.get(k, MISSING), ok.get(k, MISSING), x, f'{where}[{k}]')
                    if v is not MISSING:
                        out.append(v)
                out += [x for x in o if x[key] not in mk and x[key] not in bk]
                return out
        if len(b) == len(o) == len(m):
            return [merge(x, y, z, f'{where}[{i}]') for i, (x, y, z) in enumerate(zip(b, o, m))]
    raise Conflict(where)


changed = subprocess.run(['git', 'diff', '--name-only', BASE, OURS, '--', 'theories/becoming/results/records/'],
                         capture_output=True, text=True, check=True).stdout.split()
conflicts = []
done = 0
for path in changed:
    if not path.endswith('.json'):
        continue
    b, o, m = (show(r, path) for r in (BASE, OURS, THEIRS))
    if m is None or b is None:
        conflicts.append((path, 'missing on one side'))
        continue
    try:
        merged = merge(json.loads(b), json.loads(o), json.loads(m), '')
    except Conflict as e:
        conflicts.append((path, str(e)))
        continue
    done += 1
    if WRITE:
        with open(path, 'w', encoding='utf-8') as f:
            f.write(json.dumps(merged, indent=2, ensure_ascii=False) + '\n')
print('merged', done, 'conflicts', len(conflicts))
for c in conflicts:
    print('CONFLICT', *c)
