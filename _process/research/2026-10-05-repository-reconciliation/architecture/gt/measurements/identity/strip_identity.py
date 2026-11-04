"""Identity of completion._strip_comments (and so of parse_module and sources()) with the original
character-by-character scan, copied aside before the change: every string over the marks' alphabet up
to length 7, random longer strings, every .lean file tracked in the worktree, and parse_module and
sources() over the receipt's modules.

usage: python3 -B strip_identity.py <worktree> <original completion.py>
"""
import importlib.util
import itertools
import random
import subprocess
import sys
import time
from pathlib import Path

worktree, original = Path(sys.argv[1]), Path(sys.argv[2])
sys.path.insert(0, str(worktree))
from tools.research import completion as new  # noqa: E402

spec = importlib.util.spec_from_file_location('completion_original', original)
old = importlib.util.module_from_spec(spec)
spec.loader.exec_module(old)
old.ROOT = new.ROOT
assert new.ROOT == worktree.resolve()


def same(text, where):
    a, b = old._strip_comments(text), new._strip_comments(text)
    if a != b:
        raise SystemExit(f'differs at {where}: {text!r}: {a!r} != {b!r}')


alphabet = '-/"\\\'\na'
count = 0
for n in range(8):
    for t in itertools.product(alphabet, repeat=n):
        same(''.join(t), 'exhaustive')
        count += 1
print(f'exhaustive: {count} strings over {alphabet!r} up to length 7, all equal')

rng = random.Random(20261104)
wide = alphabet + ' x\t\r'
for k in range(200_000):
    same(''.join(rng.choice(wide) for _ in range(rng.randrange(8, 80))), f'random {k}')
print('random: 200000 strings of length 8-79, all equal')

files = subprocess.check_output(['git', 'ls-files', '*.lean'], cwd=worktree, text=True).split()
total = 0
t_old = t_new = 0.0
for rel in files:
    text = (worktree / rel).read_text(encoding='utf-8')
    total += len(text)
    t = time.perf_counter(); a = old._strip_comments(text); t_old += time.perf_counter() - t
    t = time.perf_counter(); b = new._strip_comments(text); t_new += time.perf_counter() - t
    if a != b:
        raise SystemExit(f'differs at {rel}')
print(f'tracked .lean files: {len(files)} ({total} characters), all equal; original {t_old:.2f} s, new {t_new:.2f} s')

receipt = new._json(new.RECEIPT)
layer = {m['module']: m['layer'] for m in receipt['modules']}
paths = [new.ROOT / new.LEAN_ROOT / rel for module, rel in receipt['source_paths'].items() if layer.get(module) in new.PURE]
for p in paths:
    if old.parse_module(p) != new.parse_module(p):
        raise SystemExit(f'parse_module differs at {p}')
print(f'parse_module: {len(paths)} pure modules of the receipt, all equal')
a, b = old.sources(), new.sources()
assert a == b and list(a) == list(b), 'sources() differs'
print(f'sources(): {len(a)} declarations, equal (order too)')
