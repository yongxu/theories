#!/usr/bin/env python3
"""Cut the record, chapter and design patches of U4c's stage from the main the landing merges.

From any checkout of the repository:
  python3 -B <dir>/cut_u4c_patches.py TREE STAGE [BASE] [--draft]

TREE is a new folder outside the repository: a throwaway worktree of BASE (default main) is made there, the design
folder is taken from branch u4c into it, and make_u4c_records.py writes the records and chapters. STAGE is the stage
folder (10-u4c): its patches from 08 on are replaced by
  08-u4c-design.patch          the design folder as on branch u4c, less the stage folder itself;
  09-… on                      one patch per record, chapter or process file the script changes, in path
                               order (WHAT-REMAINS's line on the census rows among them).
The Lean patches 01-07 (make_u4c_stage.py, on the tree after the kit's apply) are left as they are. The worktree is left
for reading; remove it with `git worktree remove TREE` (it holds nothing the repository cannot regenerate).
"""
import subprocess
import sys
from pathlib import Path

args = [a for a in sys.argv[1:] if not a.startswith('--')]
DRAFT = '--draft' in sys.argv
TREE, STAGE = Path(args[0]).resolve(), Path(args[1]).resolve()
BASE = args[2] if len(args) > 2 else 'main'
BRANCH = 'u4c'
DEV = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u4-one-root-to-its-edge'
REMAINS = ('_process/research/2026-10-05-generative-foundation-review/root-foundation/development/'
           'ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md')
REPO = Path(subprocess.run(['git', 'rev-parse', '--show-toplevel'], capture_output=True, text=True,
                           check=True).stdout.strip())
assert not TREE.exists(), 'TREE must be a new folder'


def git(*a, cwd=TREE, out=False):
    p = subprocess.run(['git', *a], cwd=cwd, capture_output=True, text=True)
    if p.returncode:
        sys.exit(f'git {" ".join(a)}: {p.stderr}')
    return p.stdout


git('worktree', 'add', '--detach', str(TREE), BASE, cwd=REPO)
base = git('rev-parse', 'HEAD').strip()
git('checkout', BRANCH, '--', DEV)
run = subprocess.run([sys.executable, '-B', f'{DEV}/u4c-stage/make_u4c_records.py', base] + (['--draft'] if DRAFT else []),
                     cwd=TREE, capture_output=True, text=True)
print(run.stdout[-1500:], run.stderr[-3000:])
assert run.returncode == 0, 'make_u4c_records.py failed'
git('add', '-A', '--', DEV, 'theories', REMAINS)
for old in STAGE.glob('*.patch'):
    if int(old.name[:2]) >= 8:
        old.unlink()
design = git('diff', '--cached', base, '--', DEV, f':(exclude){DEV}/u4c-stage/10-u4c')
(STAGE / '08-u4c-design.patch').write_text(design, encoding='utf-8')
changed = sorted(git('diff', '--cached', '--name-only', base, '--', 'theories', REMAINS).split())
for i, path in enumerate(changed, 9):
    (STAGE / f'{i:02d}-{Path(path).stem}.patch').write_text(git('diff', '--cached', base, '--', path), encoding='utf-8')
print(f'base {base[:9]}: 08-u4c-design.patch and {len(changed)} record and chapter patches, 09 to {8 + len(changed):02d}')
