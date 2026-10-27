#!/usr/bin/env python3
"""The receipt that binds a Lean source's current bytes (run from the checkout root).

usage: binding_for.py PATH [PATH ...] [--decls]

For each PATH, finds every passing receipt under experiments/ (verification.json, receipt.json, *-verification.json;
not history/) holding the file's current SHA-256 at some field and prints, for the newest (run-folder receipts first), the record's `references` entries (proof and receipt, with their sha256) and the
`proof_bindings` entry, as JSON. With --decls it also prints the declarations the receipt lists for the module, the
names a record may cite. A file no passing receipt binds is reported as unbound: its record cannot be
recorded-checked until a checker binds it."""
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
LEAN = ROOT / 'experiments'
args = [a for a in sys.argv[1:] if not a.startswith('--')]
DECLS = '--decls' in sys.argv


def sha(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()


def pointers(x, digest, at=''):
    """JSON pointers in x whose value is digest."""
    if isinstance(x, dict):
        for k, v in x.items():
            yield from pointers(v, digest, f'{at}/{k}')
    elif isinstance(x, list):
        for i, v in enumerate(x):
            yield from pointers(v, digest, f'{at}/{i}')
    elif x == digest:
        yield at


receipts = []
for p in LEAN.rglob('*.json'):
    s = str(p)
    if '/history/' in s or not (p.name in ('verification.json', 'receipt.json') or p.name.endswith('-verification.json')):
        continue
    try:
        d = json.loads(p.read_text(encoding='utf-8'))
    except (OSError, ValueError):
        continue
    if isinstance(d, dict) and d.get('status') == 'passed':
        receipts.append((p, d))


def module_of(d, pointer):
    """The module a pointer names, for listing its declarations."""
    parts = pointer.strip('/').split('/')
    if parts[0] == 'source_sha256':
        return parts[1]
    if parts[0] == 'modules' and parts[1].isdigit():
        m = d['modules'][int(parts[1])]
        return m.get('module') if isinstance(m, dict) else None
    return parts[-1]


out = {}
for a in args:
    src = ROOT / a
    digest = sha(src)
    hits = [(('-checks/' in str(p)), d.get('utc') or d.get('checked_at_utc') or '', str(p), p, d, ptr)
            for p, d in receipts for ptr in pointers(d, digest)]
    if not hits:
        out[a] = {'unbound': True, 'sha256': digest}
        continue
    _, _, _, p, d, ptr = max(hits, key=lambda x: x[:3])
    rel = str(p.relative_to(ROOT))
    entry = {
        'references': [
            {'path': a, 'role': 'proof', 'declarations': [], 'sha256': digest},
            {'path': rel, 'role': 'receipt', 'sha256': sha(p)},
        ],
        'proof_binding': {'source': a, 'receipt': rel, 'sha256_pointer': ptr,
                          'success_pointer': '/status', 'success_value': 'passed'},
        'other_passing_receipts': len(hits) - 1,
    }
    if DECLS:
        module = module_of(d, ptr)
        entry['module'] = module
        entry['declarations'] = sorted({x.get('name') for m in d.get('modules', []) if isinstance(m, dict)
                                        and m.get('module') == module for x in m.get('declarations', [])
                                        if isinstance(x, dict) and x.get('name')})
    out[a] = entry
print(json.dumps(out, indent=1, ensure_ascii=False))
