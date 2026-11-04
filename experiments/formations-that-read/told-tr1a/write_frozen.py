#!/usr/bin/env python3
"""Write told-tr1a/FROZEN.sha256, the base link of TR1A's chain (FREEZE-10.md, section 15): the sha-256 of
every file TR1A's freeze fixes, paths repository-relative, sorted. They are TR1A's own code, this writer
and the dry run's result; Stage 0; every freeze 1 file it imports or reads (client, conditions, prompts,
rule, run, verdicts, PINS.json, and tr8.py and tr_rr.py, which conditions imports), each with the hash
freeze 1's own FROZEN.sha256 lists; and FREEZE-5's files it imports (tr1_design, tr1_rule and tr1_run),
each with the hash FREEZE-5's FROZEN.sha256 lists. It refuses unless the dry run passed and
recorded, at its start and its end, the hashes these files have now, so that the result hashed is the one
the hashed code gives.

    python3 -B write_frozen.py REPO       # REPO: the repository's root, on the merged tree
"""
import hashlib
import json
import sys
from pathlib import Path

REPO = Path(sys.argv[1]).resolve()
D = 'experiments/formations-that-read/'
OUT = D + 'told-tr1a/results/dry-run.json'
FILES = [D + f for f in ('tr1.py', 'tr1.json', 'tr8.py', 'tr_rr.py')] + \
        [D + 'told/' + f for f in ('client.py', 'conditions.py', 'prompts.py', 'rule.py', 'run.py', 'verdicts.py',
                                   'PINS.json')] + \
        [D + 'told-tr1/' + f for f in ('tr1_design.py', 'tr1_rule.py', 'tr1_run.py')] + \
        [D + 'told-tr1a/' + f for f in ('tr1a_design.py', 'tr1a_rule.py', 'tr1a_run.py', 'tr1a_stage_a.py',
                                        'tr1a_dry_run.py', 'write_frozen.py', 'results/dry-run.json')]


def sha(p):
    return hashlib.sha256((REPO / p).read_bytes()).hexdigest()


def listed(folder):
    return dict(reversed(l.split()) for l in (REPO / D / folder / 'FROZEN.sha256').read_text().splitlines() if l.strip())


run = json.loads((REPO / OUT).read_text(encoding='utf-8'))
if not (run['ok'] and run['code_unchanged_during_the_run']):
    raise SystemExit('the dry run did not pass')
if run['code_hashes'] != {p: sha(p) for p in FILES if p != OUT}:
    raise SystemExit('the dry run was made on other files than these')
told, tr1 = listed('told'), listed('told-tr1')
if any(p not in told for p in FILES if p.startswith(D + 'told/')) or any(told[p] != sha(p) for p in FILES if p in told):
    raise SystemExit("a freeze 1 file differs from freeze 1's own hash")
if any(p not in tr1 for p in FILES if p.startswith(D + 'told-tr1/')) or any(tr1[p] != sha(p) for p in FILES if p in tr1):
    raise SystemExit("a FREEZE-5 file differs from FREEZE-5's own hash")
lines = [sha(p) + '  ' + p for p in sorted(FILES)]
(REPO / D / 'told-tr1a' / 'FROZEN.sha256').write_text('\n'.join(lines) + '\n', encoding='utf-8')
print('\n'.join(lines))
