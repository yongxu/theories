#!/usr/bin/env python3
"""Write experiments/critical-mass-located/FROZEN.sha256 (DESIGN.md section 15): the sha-256 of every file CMT's freeze
fixes, paths repository-relative, sorted. They are the rule, the dry run, the closed list, this writer and the dry run's
result. It refuses unless the dry run passed and recorded the hashes the code files have now, so that the result hashed is
the one the hashed code gives, and unless no FROZEN.sha256 is there (it is committed once, last, on the merged tree).

    python3 -B write_frozen.py REPO       # REPO: the repository's root, on the merged tree, after the reader rounds
"""
import hashlib
import json
import sys
from pathlib import Path

REPO = Path(sys.argv[1]).resolve()
D = 'experiments/critical-mass-located/'
OUT = D + 'results/dry-run.json'
CODE = ['cmt_rule.py', 'cmt_dry_run.py', 'studies.json', 'write_frozen.py']
FILES = [D + f for f in CODE] + [OUT]
TARGET = REPO / D / 'FROZEN.sha256'


def sha(p):
    return hashlib.sha256((REPO / p).read_bytes()).hexdigest()


if TARGET.exists():
    raise SystemExit('FROZEN.sha256 is there; a freeze is written once')
run = json.loads((REPO / OUT).read_text(encoding='utf-8'))
if run.get('ok') is not True:
    raise SystemExit('the dry run did not pass')
if run['code sha256'] != {f: sha(D + f) for f in CODE}:
    raise SystemExit('the dry run was made on other files than these')
lines = [sha(p) + '  ' + p for p in sorted(FILES)]
TARGET.write_text('\n'.join(lines) + '\n', encoding='utf-8')
print('\n'.join(lines))
