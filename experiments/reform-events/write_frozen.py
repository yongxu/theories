#!/usr/bin/env python3
"""Write experiments/reform-events/FROZEN.sha256, T7F's freeze (DESIGN.md §12): the sha-256 of every file the freeze
fixes, paths repository-relative, sorted: the rule, the dry run, this writer, the codebook the coders read, and the dry
run's result. It refuses unless the dry run passed and recorded the hashes these files have now, so that the result
hashed is the one the hashed code gives. Run on the merged tree, after the reader rounds; FROZEN.sha256 is then
committed once, last. AI-written (a Claude Code session), not yet reviewed by a person.

    python3 -B write_frozen.py REPO       # REPO: the repository's root
"""
import hashlib
import json
import sys
from pathlib import Path

if sys.flags.optimize:
    raise SystemExit('refused: python3 -O')
REPO = Path(sys.argv[1]).resolve()
D = 'experiments/reform-events/'
OUT = D + 'results/dry-run.json'
FILES = [D + f for f in ('reform_rule.py', 'reform_dry_run.py', 'write_frozen.py', 'CODEBOOK.md')] + [OUT]


def sha(p):
    return hashlib.sha256((REPO / p).read_bytes()).hexdigest()


sys.path.insert(0, str(REPO / D))
import reform_rule  # noqa: E402

if sorted(FILES) != sorted(reform_rule.REQUIRED):
    raise SystemExit('this writer and reform_rule.REQUIRED name different files')
if (REPO / D / 'FROZEN.sha256').exists():
    raise SystemExit('FROZEN.sha256 is already there; it is written once')
run = json.loads((REPO / OUT).read_text(encoding='utf-8'))
if not (run['ok'] and run['code_unchanged_during_the_run']):
    raise SystemExit('the dry run did not pass')
if run['code_hashes'] != {p: sha(p) for p in FILES if p != OUT}:
    raise SystemExit('the dry run was made on other files than these')
lines = [sha(p) + '  ' + p for p in sorted(FILES)]
(REPO / D / 'FROZEN.sha256').write_text('\n'.join(lines) + '\n', encoding='utf-8')
print('\n'.join(lines))
