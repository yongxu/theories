#!/usr/bin/env python3
"""OU3b: write the patches of the fourteen changed modules, each against the checkout version the kit's tree copy
was made from (its base: the file's last commit before 26 October 2026 00:00 +08:00, checked by the OU3b-2 review
and again here, and since then unchanged on main when the kit was rehearsed). Each patch is a git diff with full
blob ids (`git diff --no-index --full-index`), so `git apply --3way` can merge it onto a main that has changed the
file meanwhile. Reads only the object database and the kit's tree; writes only kit/patches/.
usage (from the root of any checkout of the repository): python3 -B <kit>/make_patches_ou3b.py"""
import subprocess
import tempfile
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
TREE = HERE.parent / 'tree/Becoming'
OUT = HERE / 'patches'
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
# module -> base commit (the file's last commit before the tree copy; REVIEW-OU3b2 "Bases", OU3b2-NOTES round 3)
BASES = {
    'Frame': '9d718f04e', 'Recurrence': 'e71cb8993', 'Attraction': 'c05d509af', 'Laws': '866370911',
    'Mechanism': '866370911', 'IdentificationRuns': 'bd4e80ee7', 'GrammarRegularity': '826434dc4',
    'GrammarScope': 'f41c7069e', 'Regions': '395bfa9e5', 'Admission': '4686bcdf6', 'Flow': 'df26acbc8',
    'Amounts': '423800365', 'InAmounts': '1af8e0949', 'Weightings': '67338f174',
}


def git(*args, **kw):
    return subprocess.run(['git', *args], cwd=ROOT, check=kw.pop('check', True), capture_output=True, **kw)


OUT.mkdir(exist_ok=True)
for name, base in BASES.items():
    path = f'{PKG}/Becoming/{name}.lean'
    # the base is the file's last commit before the copy: nothing touched it between the base and the cutoff
    last = git('log', '-1', '--format=%h', '--before=2026-10-26T00:00:00+08:00', '--', path).stdout.decode().strip()
    assert git('rev-parse', last).stdout == git('rev-parse', base).stdout, (name, base, last)
    with tempfile.TemporaryDirectory() as tmp:
        a, b = Path(tmp, 'a', path), Path(tmp, 'b', path)
        a.parent.mkdir(parents=True)
        b.parent.mkdir(parents=True)
        a.write_bytes(git('show', f'{base}:{path}').stdout)
        b.write_bytes((TREE / f'{name}.lean').read_bytes())
        r = subprocess.run(['git', 'diff', '--no-index', '--full-index', '--no-prefix', f'a/{path}', f'b/{path}'],
                           cwd=tmp, capture_output=True)
        assert r.returncode == 1, (name, r.returncode, r.stderr)
        patch = r.stdout.decode()
    head = patch.split('\n', 4)
    assert head[0] == f'diff --git a/{path} b/{path}', head[0]
    blob = git('rev-parse', f'{base}:{path}').stdout.decode().strip()
    assert head[1].startswith(f'index {blob}..'), (name, head[1])
    (OUT / f'{name}.patch').write_text(patch, encoding='utf-8')
    plus = sum(1 for line in patch.split('\n') if line.startswith('+') and not line.startswith('+++'))
    minus = sum(1 for line in patch.split('\n') if line.startswith('-') and not line.startswith('---'))
    print(f'{name}: base {base}, +{plus} -{minus}')
