#!/usr/bin/env python3
"""Build SG15's tree: Optimum with drawers in turn whose capacity limits a draw.
usage: python3 -B build_tree.py   (SG15_ROOT names the checkout to read; SG15_BASE, a git ref of it, reads it at that ref).
Writes tree/Becoming/Optimum.lean."""
import os
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG15_ROOT']).resolve() if os.environ.get('SG15_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


def read(name):
    if os.environ.get('SG15_BASE'):
        rel = (PKG / 'Becoming' / f'{name}.lean').relative_to(ROOT)
        return subprocess.run(['git', '-C', str(ROOT), 'show', f"{os.environ['SG15_BASE']}:{rel}"], check=True,
                              capture_output=True, text=True).stdout
    return (PKG / 'Becoming' / f'{name}.lean').read_text(encoding='utf-8')


op = read('Optimum')
assert 'def PerfectWithin' not in op, 'already built'
# Rule 9: the step of leaving no more than a floor, of which leaving nothing is the case.
op = once(op, """/-- What leaves no less than the whole when taken from it is nothing. -/
theorem zero_of_le_sub {z f : Nat} (le : f ≤ z) (ge : z ≤ z - f) : f = 0 :=
  match f, le, ge with
  | 0, _, _ => rfl
  | f + 1, le, ge => absurd (Nat.le_trans (Nat.add_le_add_right ge (f + 1))
      (Nat.le_of_eq (Naturals.sub_add_cancel le))) (Nat.not_le_of_gt
        (Nat.lt_of_lt_of_le (Nat.lt_succ_self z) (Nat.add_le_add_left (Nat.succ_le_succ (Nat.zero_le f)) z)))
""", (HERE / 'floor.lean').read_text(encoding='utf-8') + """/-- What leaves no less than the whole when taken from it is nothing: the floor at nothing. -/
theorem zero_of_le_sub {z f : Nat} (le : f ≤ z) (ge : z ≤ z - f) : f = 0 :=
  eq_of_sub_le_sub (Nat.zero_le f) le ge
""")
op = once(op, '\nend InTurn\n', (HERE / 'capacity.lean').read_text(encoding='utf-8') + '\nend InTurn\n')
WIT = (HERE / 'witness.lean').read_text(encoding='utf-8')
anchor = """     (Nat.succ_pos 1) (Nat.le_refl 2)⟩

end Holding

end Optimum"""
op = once(op, anchor, """     (Nat.succ_pos 1) (Nat.le_refl 2)⟩""" + WIT + """

end Holding

end Optimum""")
if (HERE / 'optimum_doc.py').exists():
    exec((HERE / 'optimum_doc.py').read_text(encoding='utf-8'))
out = HERE / 'tree' / 'Becoming' / 'Optimum.lean'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(op, encoding='utf-8')
print('wrote', out.name, len(op.splitlines()), 'lines')
