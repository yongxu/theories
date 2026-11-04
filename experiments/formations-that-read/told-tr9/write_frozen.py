#!/usr/bin/env python3
"""Write told-tr9/FROZEN.sha256, the base link of TR9's chain (FREEZE-8.md, section 14): the sha-256 of
every file TR9's freeze fixes, paths repository-relative, sorted. They are TR9's own code, this writer
and the dry run's result; its Stage 0 (tr9.py and tr9.json, and tr8.py, whose constants it takes); and
every freeze 1 file it imports or reads (run, verdicts, client, rule, conditions, prompts, PINS.json,
and tr_rr.py, which conditions imports). It refuses unless the dry run passed and recorded, at its
start and its end, the hashes these files have now, so that the result hashed is the one the hashed
code gives.

    python3 -B write_frozen.py REPO       # REPO: the repository's root, on the merged tree
"""
import hashlib
import json
import sys
from pathlib import Path

REPO = Path(sys.argv[1]).resolve()
D = 'experiments/formations-that-read/'
OUT = D + 'told-tr9/results/dry-run.json'
FILES = [D + f for f in ('tr9.py', 'tr9.json', 'tr8.py', 'tr_rr.py')] + \
        [D + 'told/' + f for f in ('client.py', 'conditions.py', 'prompts.py', 'rule.py', 'run.py', 'verdicts.py',
                                   'PINS.json')] + \
        [D + 'told-tr9/' + f for f in ('tr9_design.py', 'tr9_rule.py', 'tr9_run.py', 'tr9_dry_run.py', 'write_frozen.py',
                                       'results/dry-run.json')]


def sha(p):
    return hashlib.sha256((REPO / p).read_bytes()).hexdigest()


run = json.loads((REPO / OUT).read_text(encoding='utf-8'))
if not (run['ok'] and run['code_unchanged_during_the_run']):
    raise SystemExit('the dry run did not pass')
if run['code_hashes'] != {p: sha(p) for p in FILES if p != OUT}:
    raise SystemExit('the dry run was made on other files than these')
lines = [sha(p) + '  ' + p for p in sorted(FILES)]
(REPO / D / 'told-tr9' / 'FROZEN.sha256').write_text('\n'.join(lines) + '\n', encoding='utf-8')
print('\n'.join(lines))
