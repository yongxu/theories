#!/usr/bin/env python3
"""Write lock-scl/FROZEN.sha256, the base link of SCL's chain (FREEZE-12.md, section 15): the sha-256 of every file
SCL's freeze fixes, paths repository-relative, sorted. They are SCL's own code, this writer and the dry run's result;
and every file of the earlier freezes it imports or reads (FREEZE-10's tr1a_design, tr1a_rule and tr1a_run;
FREEZE-5's tr1_design, tr1_rule and tr1_run; freeze 1's client, conditions, prompts, rule, run, verdicts and
PINS.json; Stage 0's tr1.py and tr1.json, and tr8.py and tr_rr.py, which conditions imports). It refuses unless the
dry run passed and recorded, at its start and its end, the hashes these files have now, so that the result hashed is
the one the hashed code gives; unless each imported file has the hash of FREEZE-10's newest link and of the newest
link of the freeze that owns it (freeze 1, told/FROZEN.sha256 and its addenda, for told/'s files, tr8.py and
tr_rr.py; FREEZE-5, told-tr1/'s, for told-tr1/'s files, tr1.py and tr1.json; FREEZE-10 for told-tr1a/'s); and where
FROZEN.sha256 is already there (a second commit of it would cut the chain). The newest link is read from the files
there (the base, then addenda/FROZEN-k.sha256 while each exists); the chains themselves are checked at run time by
freeze 1's frozen_check.

    python3 -B write_frozen.py REPO       # REPO: the repository's root, on the merged tree; not before the gate passes
"""
import hashlib
import json
import sys
from pathlib import Path

REPO = Path(sys.argv[1]).resolve()
D = 'experiments/formations-that-read/'
OUT = D + 'lock-scl/results/dry-run.json'
OWN = [D + 'lock-scl/' + f for f in ('scl_design.py', 'scl_rule.py', 'scl_stage0.py', 'scl_run.py', 'scl_dry_run.py',
                                     'write_frozen.py', 'results/dry-run.json')]
IMPORTED = [D + f for f in ('tr1.py', 'tr1.json', 'tr8.py', 'tr_rr.py')] + \
           [D + 'told/' + f for f in ('client.py', 'conditions.py', 'prompts.py', 'rule.py', 'run.py', 'verdicts.py',
                                      'PINS.json')] + \
           [D + 'told-tr1/' + f for f in ('tr1_design.py', 'tr1_rule.py', 'tr1_run.py')] + \
           [D + 'told-tr1a/' + f for f in ('tr1a_design.py', 'tr1a_rule.py', 'tr1a_run.py')]
FILES = sorted(OWN + IMPORTED)


def sha(p):
    return hashlib.sha256((REPO / p).read_bytes()).hexdigest()


def listed(folder):
    """The newest link of the freeze in folder: the base FROZEN.sha256, then addenda/FROZEN-k.sha256 while it exists."""
    f = REPO / D / folder
    link, k = f / 'FROZEN.sha256', 1
    while (f / 'addenda' / f'FROZEN-{k}.sha256').exists():
        link, k = f / 'addenda' / f'FROZEN-{k}.sha256', k + 1
    return dict(reversed(l.split()) for l in link.read_text().splitlines() if l.strip())


def owner(p):
    rel = p[len(D):]
    if rel.startswith('told/') or rel in ('tr8.py', 'tr_rr.py'):
        return 'told', "freeze 1's"
    if rel.startswith('told-tr1/') or rel in ('tr1.py', 'tr1.json'):
        return 'told-tr1', "FREEZE-5's"
    return 'told-tr1a', "FREEZE-10's"


target = REPO / D / 'lock-scl' / 'FROZEN.sha256'
if target.exists():
    raise SystemExit('FROZEN.sha256 is there: SCL is frozen once; a fault is mended by an addendum or a new freeze')
run = json.loads((REPO / OUT).read_text(encoding='utf-8'))
if not (run['ok'] and run['code_unchanged_during_the_run']):
    raise SystemExit('the dry run did not pass')
if run['code_hashes'] != {p: sha(p) for p in FILES if p != OUT}:
    raise SystemExit('the dry run was made on other files than these')
links = {f: listed(f) for f in ('told', 'told-tr1', 'told-tr1a')}
for p in IMPORTED:
    if links['told-tr1a'].get(p) != sha(p):
        raise SystemExit(f"{p} differs from FREEZE-10's newest link")
    folder, whose = owner(p)
    if links[folder].get(p) != sha(p):
        raise SystemExit(f"{p} differs from {whose} newest link, the freeze that owns it")
lines = [sha(p) + '  ' + p for p in FILES]
target.write_text('\n'.join(lines) + '\n', encoding='utf-8')
print('\n'.join(lines))
