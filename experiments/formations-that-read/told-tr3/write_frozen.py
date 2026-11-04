#!/usr/bin/env python3
"""Write told-tr3/FROZEN.sha256, the base link of TR3's chain (FREEZE-3.md, section 14): the sha-256 of
every file TR3's freeze fixes, paths repository-relative, sorted. They are TR3's own code, its endpoint
lists, this writer and the dry run's result; its Stage 0; and every freeze 1 file it imports or reads
(run, verdicts, client, rule, conditions, prompts, PINS.json, and tr8.py and tr_rr.py, which conditions
imports). It refuses unless the dry run passed and recorded, at its start and its end, the hashes these
files have now, so that the result hashed is the one the hashed code gives.

    python3 -B write_frozen.py REPO       # REPO: the repository's root, on the merged tree
"""
import hashlib
import json
import sys
from pathlib import Path

REPO = Path(sys.argv[1]).resolve()
D = 'experiments/formations-that-read/'
OUT = D + 'told-tr3/results/dry-run.json'
FILES = [D + f for f in ('tr3.py', 'tr3.json', 'tr8.py', 'tr_rr.py')] + \
        [D + 'told/' + f for f in ('client.py', 'conditions.py', 'prompts.py', 'rule.py', 'run.py', 'verdicts.py',
                                   'PINS.json')] + \
        [D + 'told-tr3/' + f for f in ('tr3_client.py', 'tr3_design.py', 'tr3_rule.py', 'tr3_run.py', 'tr3_dry_run.py',
                                       'ENDPOINTS.json', 'write_frozen.py', 'results/dry-run.json')]


def sha(p):
    return hashlib.sha256((REPO / p).read_bytes()).hexdigest()


run = json.loads((REPO / OUT).read_text(encoding='utf-8'))
if not (run['ok'] and run['code_unchanged_during_the_run']):
    raise SystemExit('the dry run did not pass')
if run['code_hashes'] != {p: sha(p) for p in FILES if p != OUT}:
    raise SystemExit('the dry run was made on other files than these')
lines = [sha(p) + '  ' + p for p in sorted(FILES)]
(REPO / D / 'told-tr3' / 'FROZEN.sha256').write_text('\n'.join(lines) + '\n', encoding='utf-8')
print('\n'.join(lines))
