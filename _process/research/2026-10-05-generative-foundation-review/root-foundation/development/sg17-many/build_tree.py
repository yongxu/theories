#!/usr/bin/env python3
"""Build SG17's tree: Optimum with any number of drawers in turn, SG14's two drawers its case.
usage: python3 -B build_tree.py   (SG17_ROOT names the checkout to read; SG17_BASE, a git ref of it, reads it at that ref).
Writes tree/Becoming/Optimum.lean."""
import os
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG17_ROOT']).resolve() if os.environ.get('SG17_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


def read(name):
    if os.environ.get('SG17_BASE'):
        rel = (PKG / 'Becoming' / f'{name}.lean').relative_to(ROOT)
        return subprocess.run(['git', '-C', str(ROOT), 'show', f"{os.environ['SG17_BASE']}:{rel}"], check=True,
                              capture_output=True, text=True).stdout
    return (PKG / 'Becoming' / f'{name}.lean').read_text(encoding='utf-8')


op = read('Optimum')
assert 'namespace Many' not in op, 'already built'
# Rule 9: SG14's step and induction laws removed; its two drawers the case k = 2 of the Many laws.
start = op.index('/-- **One step back from the horizon.** Where each leaves at most what it is given and the second')
stop = op.index('/-- **Leaving nothing ends the base at once.**')
assert op.count('/-- **One step back from the horizon.** Where each leaves at most what it is given and the second') == 1
op = op[:start] + (HERE / 'many.lean').read_text(encoding='utf-8') + op[stop:]
# SG14's perfect_levels removed too: the case k = 2 of Many.perfect_levels, no law reads it.
op = once(op, '''/-- **The base stands at what stands at nothing.** Along every profile perfect over `N` steps, at
every step from the first to the `N`-th the base stands at what stands at nothing; where nothing
stands at nothing, the base ends at once. -/
theorem perfect_levels {N : Nat} (perfect : Perfect G first second N) (s : Nat) {t : Nat}
    (before : t < N) : levels G first second s (t + 1) = G t 0 :=
  levels_of_zero (fun _ lt => perfect_ends perfect lt) s before

''', '')
op = once(op, '''perfect within the capacities exactly where it is perfect, so every such profile draws everything
(`perfect_ends`). -/''', '''perfect within the capacities exactly where it is perfect, so every such profile draws everything
(`Many.perfect_ends`, `Many.perfect_pair`). -/''')
# The web law for any number of drawers; the two drawers' web law derived from it.
old_web = '''theorem perfect_broken {G first second : Nat → Nat → Nat} {N s : Nat}
    (perfect : Optimum.InTurn.Perfect G first second N)
    (follows : ∀ t, t ≤ N → W.level t c = Optimum.InTurn.levels G first second s t)
    (long : 0 < N) (depends : W.requires 0 f c) (low : G 0 0 < W.need 0 f c)
    (start : W.need 0 f c ≤ W.level 0 c) :
    W.Broken 0 f c ∧ ∀ t, t < N → W.level (t + 1) c = G t 0 :=
  have stands : ∀ t, t < N → W.level (t + 1) c = G t 0 := fun t before =>
    (follows (t + 1) before).trans (Optimum.InTurn.perfect_levels perfect s before)
  ⟨⟨depends, start, Nat.lt_of_le_of_lt (Nat.le_of_eq (stands 0 long)) low⟩, stands⟩
'''
new_web = '''theorem perfect_broken {G first second : Nat → Nat → Nat} {N s : Nat}
    (perfect : Optimum.InTurn.Perfect G first second N)
    (follows : ∀ t, t ≤ N → W.level t c = Optimum.InTurn.levels G first second s t)
    (long : 0 < N) (depends : W.requires 0 f c) (low : G 0 0 < W.need 0 f c)
    (start : W.need 0 f c ≤ W.level 0 c) :
    W.Broken 0 f c ∧ ∀ t, t < N → W.level (t + 1) c = G t 0 :=
  turns_broken (Nat.le_refl 2) (Optimum.InTurn.Many.perfect_pair perfect)
    (fun t le => (follows t le).trans (Optimum.InTurn.Many.levels_pair s t).symm) long depends low start
'''
WEB = (HERE / 'web.lean').read_text(encoding='utf-8')
i = op.index(old_web)
doc = op.rindex('/--', 0, i)
op = op[:doc] + WEB + op[doc:i] + new_web + op[i + len(old_web):]
assert op.count(new_web) == 1
anchor = '''      trivial (Nat.succ_pos 1) (Nat.le_refl 2)).1⟩

'''
k = op.index('theorem gated_in_turn (n : Nat) :')
j = op.index(anchor, k)
op = op[:j + len(anchor) - 1] + (HERE / 'witness.lean').read_text(encoding='utf-8') + op[j + len(anchor) - 1:]
if (HERE / 'optimum_doc.py').exists():
    exec((HERE / 'optimum_doc.py').read_text(encoding='utf-8'))
out = HERE / 'tree' / 'Becoming' / 'Optimum.lean'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(op, encoding='utf-8')
print('wrote', out.name, len(op.splitlines()), 'lines')
