#!/usr/bin/env python3
"""Commit an edit of the work board onto main with plumbing, then fast-forward the shared checkout.
usage: python3 -B board_commit.py EDIT.py "message"   EDIT.py defines edit(text) -> text."""
import os, subprocess, sys, tempfile, runpy
SHARED = '/Users/ren/theories'
PATH = '_process/BECOMING-WORKBOARD.md'
def git(*a, inp=None, env=None):
    return subprocess.run(['git', '-C', SHARED, *a], input=inp, capture_output=True, text=True, check=True,
                          env=env).stdout.strip()
edit = runpy.run_path(sys.argv[1])['edit']
main = git('rev-parse', 'main')
old = git('show', f'{main}:{PATH}')
new = edit(old + '\n')
assert new != old + '\n'
blob = git('hash-object', '-w', '--stdin', inp=new)
with tempfile.TemporaryDirectory() as d:
    env = dict(os.environ, GIT_INDEX_FILE=os.path.join(d, 'index'))
    git('read-tree', main, env=env)
    git('update-index', '--cacheinfo', f'100644,{blob},{PATH}', env=env)
    tree = git('write-tree', env=env)
commit = git('commit-tree', tree, '-p', main, '-m', sys.argv[2])
assert git('rev-parse', 'main') == main, 'main moved'
print(git('merge', '--ff-only', commit))
print(commit)
