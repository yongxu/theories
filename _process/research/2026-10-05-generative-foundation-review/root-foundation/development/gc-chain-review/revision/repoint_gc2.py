#!/usr/bin/env python3
"""GC2's re-point (repoint_nd_final.py's pattern, smaller): the records drifting by the two id renames only.

Reads the source_drift of a `research.py render` or `check` output (DRIFT_LOG, the JSON with make's lines around it),
keeps the pairs whose path this branch changed against main, and for each such path checks that its text with the new
ids mapped back to the old equals main's text, so the drift is the rewritten link paths and nothing else. Any other
difference stops the script. Then it hands the kept pairs to tools/research/repoint.py with the reason below.
usage (from the checkout root): python3 -B <kit>/repoint_gc2.py DRIFT_LOG [--apply]"""
import json, subprocess, sys, tempfile
from pathlib import Path

ROOT = Path.cwd()
APPLY = '--apply' in sys.argv[2:]
MAP = [('selection-when-the-lumping-changes', 'selection-under-registration-revision'),
       ('formed-contacts-change-copying-fidelity', 'formed-copying-registration')]
REASON = ("GC2: the record ids selection-under-registration-revision and formed-copying-registration renamed "
          "selection-when-the-lumping-changes and formed-contacts-change-copying-fidelity by research.py rename-id "
          "(batch gc2-registration-ids), which rewrote the record links in the cited sections; link paths only, "
          "nothing the records say changed; each section read before re-pointing")


def git(*a):
    return subprocess.run(['git', *a], cwd=ROOT, capture_output=True, text=True, check=True).stdout


text = Path(sys.argv[1]).read_text(encoding='utf-8')
report = json.loads(text[text.index('\n{') + 1:text.rindex('\n}') + 2])
base = git('merge-base', 'HEAD', 'main').strip()
mine = set(git('diff', '--name-only', base, '--').split())
kept, other = [], []
for d in report['source_drift']:
    (kept if d['path'] in mine else other).append(d)
for d in other:
    print('NOT THIS BRANCH (left to its owner):', d['id'], d['path'])
for path in sorted({d['path'] for d in kept}):
    new = (ROOT / path).read_text(encoding='utf-8')
    for n, o in MAP:
        new = new.replace(n, o)
    if new != git('show', f'{base}:{path}'):
        raise SystemExit(f'STOP: {path} differs from main beyond the two ids')
    print('ids only:', path)
for d in kept:
    print('re-point:', d['id'], d['path'], d['changed_sections'])
with tempfile.NamedTemporaryFile('w', suffix='.json', delete=False) as f:
    json.dump({'source_drift': kept}, f)
cmd = ['python3', '-B', 'tools/research/repoint.py', '--reason', REASON, '--drift-json', f.name]
subprocess.run(cmd + (['--apply'] if APPLY else []), cwd=ROOT, check=True)
