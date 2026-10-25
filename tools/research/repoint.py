#!/usr/bin/env python3
"""Re-point records to sources reread after a change, with no history note.

A re-point that changes nothing a record says (only a reviewed source hash, a proof binding's receipt, or the
receipt reference that goes with it) is bookkeeping. It is logged once per landing, as one line of
`_process/architecture/rebinds.jsonl` (date, base commit, reason, record ids, paths, receipt), not as a history
note in every record it touches (twentieth review, finding E3). A change to the claim, the premises, the scope or a
declaration list still takes a history note in the record, written by the author.

usage (from the checkout root):
  python3 -B tools/research/repoint.py --reason TEXT [--paths P ...] [--ids ID ...] [--receipt RECEIPT --lean P ...] [--apply]

  --paths    sources the author has reread; references to them are set to the current bytes. Without --paths,
             every reference whose bytes changed is a candidate, so give --ids to bound it.
  --ids      only these records (default: every record); --ids-file reads them from a file.
  --drift-json  the output of research.py check or render; re-points exactly the (record, path) pairs of its source_drift,
             and nothing when it lists none.
  --receipt  a passing receipt (path to verification.json); with --lean, the proof bindings of those Lean files are
             rebound to it, after checking that it binds the file's current sha256 and records success.
  --apply    write the records and the log line; without it, print what would change (dry run).

Never run it to silence a check: read each changed source first (RESULT-WORKFLOW, "Hashes").
"""
from __future__ import annotations

import argparse
import datetime as _dt
import hashlib
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
from tools.research import registry  # noqa: E402

LOG = '_process/architecture/rebinds.jsonl'


def digest(path: str) -> str | None:
    p = ROOT / path
    return hashlib.sha256(p.read_bytes()).hexdigest() if p.is_file() else None


def at_pointer(data, pointer):
    for part in pointer.strip('/').split('/'):
        data = data[part.replace('~1', '/').replace('~0', '~')]
    return data


def repoint_record(d: dict, current, paths=None, receipt=None, lean=(), receipt_data=None):
    """Return (changed paths, rebound sources) after editing `d` in place. `current(path)` gives the current
    sha256; `paths` limits the references re-pointed (None: every changed reference)."""
    touched, rebound = [], []
    lean = set(lean)
    refs = d.get('references', [])
    for b in d.get('proof_bindings', []):
        if receipt and b.get('source') in lean and b.get('receipt') != receipt:
            sha = current(b['source'])
            if at_pointer(receipt_data, b['sha256_pointer']) != sha:
                raise ValueError(f'{d["id"]}: {receipt} does not bind the current {b["source"]}')
            if at_pointer(receipt_data, b.get('success_pointer', '/status')) != b.get('success_value', 'passed'):
                raise ValueError(f'{d["id"]}: {receipt} records no success')
            b['receipt'] = receipt
            rebound.append(b['source'])
    if rebound and not any(r.get('path') == receipt for r in refs):
        refs.append({'path': receipt, 'role': 'receipt', 'sha256': current(receipt), 'declarations': []})
        touched.append(receipt)
    for r in refs:
        p = r.get('path')
        if paths is not None and p not in paths and p not in rebound:
            continue
        sha = current(p)
        if sha and r.get('sha256') != sha:
            r['sha256'] = sha
            touched.append(p)
    return touched, rebound


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('--reason', required=True)
    ap.add_argument('--paths', nargs='+')
    ap.add_argument('--ids', nargs='+')
    ap.add_argument('--ids-file', help='a file of record ids, separated by white space')
    ap.add_argument('--drift-json', help='the JSON output of research.py check or render: re-point exactly its source_drift pairs')
    ap.add_argument('--receipt')
    ap.add_argument('--lean', nargs='+', default=[])
    ap.add_argument('--apply', action='store_true')
    a = ap.parse_args(argv)
    if a.ids_file:
        a.ids = (a.ids or []) + Path(a.ids_file).read_text().split()
    per = None
    if a.drift_json:
        per = {}
        for x in json.loads(Path(a.drift_json).read_text()).get('source_drift', []):
            per.setdefault(x['id'], set()).add(x['path'])
        if not per:
            # No pair: without this, a.ids stays empty and every changed reference of every record is re-pointed.
            print(json.dumps({'records': 0, 'apply': a.apply, 'by_record': {}}, ensure_ascii=False, indent=1))
            return 0
        a.ids = (a.ids or []) + sorted(per)
    if a.lean and not a.receipt:
        ap.error('--lean needs --receipt')
    receipt_data = json.loads((ROOT / a.receipt).read_text()) if a.receipt else None
    paths = set(a.paths) | set(a.lean) if a.paths else None
    if paths is not None and a.receipt:
        paths.add(a.receipt)
    cache = {}

    def current(p):
        if p not in cache:
            cache[p] = digest(p)
        return cache[p]

    changed = {}
    for directory in registry.config()['record_directories']:
        for f in sorted((ROOT / directory).glob('*.json')):
            raw = f.read_text()
            d = json.loads(raw)
            if a.ids and d.get('id') not in a.ids:
                continue
            these = per[d['id']] if per is not None and d['id'] in per else paths
            touched, rebound = repoint_record(d, current, these, a.receipt, a.lean, receipt_data)
            if touched or rebound:
                changed[d['id']] = (f, d, sorted(set(touched)), sorted(set(rebound)))
    summary = {'records': len(changed), 'apply': a.apply,
               'by_record': {k: {'paths': v[2], 'rebound': v[3]} for k, v in sorted(changed.items())}}
    if a.apply and changed:
        for f, d, _, _ in changed.values():
            f.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
        base = subprocess.run(['git', 'rev-parse', '--short=9', 'HEAD'], cwd=ROOT, capture_output=True, text=True).stdout.strip()
        line = {'date': _dt.datetime.now(_dt.timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ'), 'base': base, 'reason': a.reason,
                'records': sorted(changed), 'paths': sorted({p for v in changed.values() for p in v[2]}),
                'receipt': a.receipt, 'rebound': sorted({p for v in changed.values() for p in v[3]})}
        log = ROOT / LOG
        log.parent.mkdir(parents=True, exist_ok=True)
        with log.open('a') as stream:
            stream.write(json.dumps(line, ensure_ascii=False) + '\n')
        summary['log'] = LOG
    print(json.dumps(summary, ensure_ascii=False, indent=1))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
