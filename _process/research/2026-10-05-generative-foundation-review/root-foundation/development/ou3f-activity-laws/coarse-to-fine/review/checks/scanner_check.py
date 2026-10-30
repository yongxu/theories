#!/usr/bin/env python3
"""Review of OU3f's coarse-to-fine pair, check 3: OU3b's definitions() before and after blank_comments, over every module
of HEAD's core receipt, against the receipt's declaration lists (read-only; git show only).

For each module: the names the scanner reads as definitions before and after; the names dropped or added; whether a
dropped or added name is a declaration of the receipt; and whether every declaration of a kind the scanner looks for
(def, abbrev, structure, inductive; the receipt has no class) is found, before and after.
usage (from the worktree root): python3 -B <this>"""
import hashlib
import importlib.util
import json
import subprocess
import sys
import types
from pathlib import Path

sys.dont_write_bytecode = True
ROOT = Path.cwd()
REL = ('_process/research/2026-10-05-generative-foundation-review/root-foundation/development/'
       'ou3b-master-laws-on-the-grammar/kit/signatures_ou3b.py')
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
LEAN_ROOT = PKG.parent

spec = importlib.util.spec_from_file_location('s3b_new', ROOT / REL)
new = importlib.util.module_from_spec(spec)
spec.loader.exec_module(new)
old = types.ModuleType('s3b_old')
exec(compile(subprocess.run(['git', 'show', f'c9d47a06f~1:{REL}'], cwd=ROOT, capture_output=True, text=True,
                            check=True).stdout, 's3b_old', 'exec'), old.__dict__)
assert not hasattr(old, 'blank_comments') and hasattr(new, 'blank_comments')

receipt = json.loads((PKG / 'becoming-verification.json').read_text())
KINDS = {'def', 'abbrev', 'structure', 'inductive', 'class'}
real_all = {d['name'] for m in receipt['modules'] for d in m['declarations']}
report = {'receipt': receipt['utc'], 'modules': 0, 'hash_mismatch': [], 'dropped': {}, 'added': {},
          'dropped_real': [], 'added_real': [], 'missing_before': {}, 'missing_after': {},
          'found_before': 0, 'found_after': 0, 'expected': 0, 'bodies_differ': 0, 'common': 0}
for m in receipt['modules']:
    name = m['module']
    path = LEAN_ROOT / receipt['source_paths'][name]
    data = path.read_bytes()
    want = receipt['source_sha256'].get(receipt['source_paths'][name]) or receipt['source_sha256'].get(name)
    if want and hashlib.sha256(data).hexdigest() != want:
        report['hash_mismatch'].append(name)
    text = data.decode('utf-8')
    before, after = old.definitions(text), new.definitions(text)
    report['modules'] += 1
    dropped = sorted(set(before) - set(after))
    added = sorted(set(after) - set(before))
    if dropped:
        report['dropped'][name] = dropped
    if added:
        report['added'][name] = added
    report['dropped_real'] += [n for n in dropped if n in real_all]
    report['added_real'] += [n for n in added if n in real_all]
    expected = [d['name'] for d in m['declarations'] if d['kind'] in KINDS]
    report['expected'] += len(expected)
    miss_b = [n for n in expected if n not in before]
    miss_a = [n for n in expected if n not in after]
    report['found_before'] += len(expected) - len(miss_b)
    report['found_after'] += len(expected) - len(miss_a)
    if miss_b:
        report['missing_before'][name] = miss_b
    if miss_a:
        report['missing_after'][name] = miss_a
    common = set(before) & set(after)
    report['common'] += len(common)
    report['bodies_differ'] += sum(before[n] != after[n] for n in common)
report['dropped_count'] = sum(len(v) for v in report['dropped'].values())
report['added_count'] = sum(len(v) for v in report['added'].values())
print(json.dumps(report, indent=1, ensure_ascii=False))
