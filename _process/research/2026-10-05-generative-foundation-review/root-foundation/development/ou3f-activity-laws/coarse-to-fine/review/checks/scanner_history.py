#!/usr/bin/env python3
"""Review of OU3f's coarse-to-fine pair, check 3e: would blank_comments make any audit that passed fail, or any that
failed pass? For every first-parent commit on main since 15 October 2026 that changed a module of the package, the
comparison the signature kits make (definitions() of the module before and after: rewritten, gone, added) is run with
the scanner before the change (c9d47a06f~1) and after it, and the results are compared (read-only; git cat-file only).
usage (from the worktree root): python3 -B <this> [SINCE]"""
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
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming'
SINCE = sys.argv[1] if len(sys.argv) > 1 else '2026-10-15'

spec = importlib.util.spec_from_file_location('s3b_new', ROOT / REL)
new = importlib.util.module_from_spec(spec)
spec.loader.exec_module(new)
old = types.ModuleType('s3b_old')
exec(compile(subprocess.run(['git', 'show', f'c9d47a06f~1:{REL}'], cwd=ROOT, capture_output=True, text=True,
                            check=True).stdout, 's3b_old', 'exec'), old.__dict__)

batch = subprocess.Popen(['git', 'cat-file', '--batch'], cwd=ROOT, stdin=subprocess.PIPE, stdout=subprocess.PIPE)


def blob(spec_):
    batch.stdin.write((spec_ + '\n').encode())
    batch.stdin.flush()
    header = batch.stdout.readline().decode().split()
    if len(header) < 3 or header[1] == 'missing':
        return None
    data = batch.stdout.read(int(header[2]))
    batch.stdout.read(1)
    return data.decode('utf-8')


def compare(scanner, a, b):
    da, db = scanner.definitions(a), scanner.definitions(b)
    return {'rewritten': {n for n in da if n in db and da[n] != db[n]},
            'gone': {n for n in da if n not in db}, 'added': {n for n in db if n not in da}}


commits = subprocess.run(['git', 'log', '--first-parent', '--format=%H', 'main', f'--since={SINCE}', '--', PKG],
                         cwd=ROOT, capture_output=True, text=True, check=True).stdout.split()
pairs = 0
only_new = []   # flagged by the new scanner, not by the old: an audit that passed could now fail
only_old = []   # flagged by the old scanner only: what the change removes
for c in commits:
    files = subprocess.run(['git', 'diff-tree', '--no-commit-id', '--name-only', '-r', f'{c}^1', c, '--', PKG],
                           cwd=ROOT, capture_output=True, text=True, check=True).stdout.split()
    for f in files:
        if not f.endswith('.lean'):
            continue
        a, b = blob(f'{c}^1:{f}'), blob(f'{c}:{f}')
        if a is None or b is None:
            continue
        pairs += 1
        ro, rn = compare(old, a, b), compare(new, a, b)
        for k in ro:
            for n in sorted(rn[k] - ro[k]):
                only_new.append((c[:9], f.rsplit('/', 1)[1], k, n))
            for n in sorted(ro[k] - rn[k]):
                only_old.append((c[:9], f.rsplit('/', 1)[1], k, n))
print(json.dumps({'since': SINCE, 'commits': len(commits), 'module_pairs': pairs,
                  'flagged_only_by_new': only_new, 'flagged_only_by_old': only_old}, indent=1, ensure_ascii=False))
