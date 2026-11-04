#!/usr/bin/env python3
"""Write told-tr1/FROZEN.sha256, the base link of TR1's chain (FREEZE-5.md, section 15): the sha-256 of
every file TR1's freeze fixes, paths repository-relative, sorted. They are TR1's own code, this writer
and the dry run's result; its Stage 0; and every freeze 1 file it imports or reads (client, conditions,
prompts, rule, run, verdicts, PINS.json, and tr8.py and tr_rr.py, which conditions imports), each with
the hash freeze 1's own FROZEN.sha256 lists (tr8.py and tr_rr.py among them). It refuses unless the dry run passed and recorded, at its
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
OUT = D + 'told-tr1/results/dry-run.json'
FILES = [D + f for f in ('tr1.py', 'tr1.json', 'tr8.py', 'tr_rr.py')] + \
        [D + 'told/' + f for f in ('client.py', 'conditions.py', 'prompts.py', 'rule.py', 'run.py', 'verdicts.py',
                                   'PINS.json')] + \
        [D + 'told-tr1/' + f for f in ('tr1_design.py', 'tr1_rule.py', 'tr1_run.py', 'tr1_dry_run.py', 'write_frozen.py',
                                       'results/dry-run.json')]


def sha(p):
    return hashlib.sha256((REPO / p).read_bytes()).hexdigest()


run = json.loads((REPO / OUT).read_text(encoding='utf-8'))
if not (run['ok'] and run['code_unchanged_during_the_run']):
    raise SystemExit('the dry run did not pass')
if run['code_hashes'] != {p: sha(p) for p in FILES if p != OUT}:
    raise SystemExit('the dry run was made on other files than these')
told = dict(reversed(l.split()) for l in (REPO / D / 'told' / 'FROZEN.sha256').read_text().splitlines() if l.strip())
if any(p not in told for p in FILES if p.startswith(D + 'told/')) or any(told[p] != sha(p) for p in FILES if p in told):
    raise SystemExit("a freeze 1 file differs from freeze 1's own hash")
lines = [sha(p) + '  ' + p for p in sorted(FILES)]
(REPO / D / 'told-tr1' / 'FROZEN.sha256').write_text('\n'.join(lines) + '\n', encoding='utf-8')
print('\n'.join(lines))
