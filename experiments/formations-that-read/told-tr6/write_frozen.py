#!/usr/bin/env python3
"""Write told-tr6/FROZEN.sha256, the base link of TR6's chain (FREEZE-6.md, section 14): the sha-256 of
every file TR6's freeze fixes, paths repository-relative, sorted. They are TR6's own code, this writer
and the dry run's result; its Stage 0; every freeze 1 file it imports or reads (run, verdicts, client,
rule, conditions, prompts, PINS.json, and tr8.py and tr_rr.py, which conditions imports); and every
freeze 3 file it imports or reads (freeze 3's client and the endpoint lists it reads, and freeze 3's
run with its design and rule, whose chain check TR6's run calls). It refuses unless the dry run
passed and recorded, at its start and its end, the hashes these files have now, so that the result
hashed is the one the hashed code gives.

    python3 -B write_frozen.py REPO       # REPO: the repository's root, on the merged tree
"""
import hashlib
import json
import sys
from pathlib import Path

REPO = Path(sys.argv[1]).resolve()
D = 'experiments/formations-that-read/'
OUT = D + 'told-tr6/results/dry-run.json'
FILES = [D + f for f in ('tr6.py', 'tr6.json', 'tr8.py', 'tr_rr.py')] + \
        [D + 'told/' + f for f in ('client.py', 'conditions.py', 'prompts.py', 'rule.py', 'run.py', 'verdicts.py',
                                   'PINS.json')] + \
        [D + 'told-tr3/' + f for f in ('tr3_client.py', 'tr3_design.py', 'tr3_rule.py', 'tr3_run.py', 'ENDPOINTS.json')] + \
        [D + 'told-tr6/' + f for f in ('tr6_design.py', 'tr6_rule.py', 'tr6_run.py', 'tr6_dry_run.py', 'write_frozen.py',
                                       'results/dry-run.json')]


def sha(p):
    return hashlib.sha256((REPO / p).read_bytes()).hexdigest()


run = json.loads((REPO / OUT).read_text(encoding='utf-8'))
if not (run['ok'] and run['code_unchanged_during_the_run']):
    raise SystemExit('the dry run did not pass')
if run['code_hashes'] != {p: sha(p) for p in FILES if p != OUT}:
    raise SystemExit('the dry run was made on other files than these')
lines = [sha(p) + '  ' + p for p in sorted(FILES)]
(REPO / D / 'told-tr6' / 'FROZEN.sha256').write_text('\n'.join(lines) + '\n', encoding='utf-8')
print('\n'.join(lines))
