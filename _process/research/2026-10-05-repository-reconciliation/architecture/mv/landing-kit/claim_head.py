"""Claim the head of the landing queue for MV's follow-up and README's first screen, touching no checkout:
build a commit on main whose only change is the board's Queue line with the head clause first, then print it.
Refuses if any clause on the Queue line already holds the head. The fast-forward is done by hand after checking
the shared checkout: git -C /Users/ren/theories merge --ff-only <commit>."""
import os, subprocess, sys, tempfile
REPO, BOARD = '/Users/ren/theories', '_process/BECOMING-WORKBOARD.md'
CLAUSE = ("MV's follow-up and the README's first screen at the head of the queue (landing now: the attachment rule's third "
          "and fourth re-checks in both copies, no Lean in the package, no record statement and no core run; README's first "
          "screen before the opening, the opening's first-person body unchanged, one line before its notes saying they are "
          "written apart from it, its notes [^ethics], [^good-evil], [^transitions], [^axiom] and [^own] brought to the "
          "current account and to front pages naming no one, the v13 proposal for Ren; eight records re-pointed; two "
          "study sections; then "
          "render, strict check, links and tests, then the fast-forward); ")
def git(*a, **k):
    return subprocess.run(['git', '-C', REPO, *a], check=True, capture_output=True, text=True, **k).stdout
main = git('rev-parse', 'main').strip()
board = git('show', f'{main}:{BOARD}')
lines = board.split('\n')
i = next(n for n, l in enumerate(lines) if l.startswith('- **Queue:** '))
rest = lines[i][len('- **Queue:** '):]
head = rest.split('; ')[0]
if 'at the head' in head:
    sys.exit(f'the head is held: {head[:160]}')
lines[i] = '- **Queue:** ' + CLAUSE + rest
blob = subprocess.run(['git', '-C', REPO, 'hash-object', '-w', '--stdin'], input='\n'.join(lines), check=True,
                      capture_output=True, text=True).stdout.strip()
with tempfile.TemporaryDirectory() as d:
    env = dict(os.environ, GIT_INDEX_FILE=os.path.join(d, 'index'))
    subprocess.run(['git', '-C', REPO, 'read-tree', main], check=True, env=env)
    subprocess.run(['git', '-C', REPO, 'update-index', '--cacheinfo', f'100644,{blob},{BOARD}'], check=True, env=env)
    tree = subprocess.run(['git', '-C', REPO, 'write-tree'], check=True, env=env, capture_output=True, text=True).stdout.strip()
msg = "Board: " + CLAUSE.rstrip('; ')
commit = git('commit-tree', tree, '-p', main, '-m', msg).strip()
changed = git('diff', '--name-only', main, commit).split()
assert changed == [BOARD], changed
print(commit)
