#!/usr/bin/env python3
"""Build RM7's tree: RegimeMargin with a web of coupled conditions (Coupled.Indexed) placed below the pair laws, and the
pair's laws of order, ending and dependence re-derived from it (board rule 9).
usage: python3 -B build_tree.py   (RM7_ROOT names the checkout to read, one whose RegimeMargin is RM6's; default the
checkout holding this kit; RM7_BASE, a git ref of that checkout, reads it at that ref instead).
Writes tree/Becoming/RegimeMargin.lean."""
import os
import re
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['RM7_ROOT']).resolve() if os.environ.get('RM7_ROOT') else HERE.parents[5]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


def read(name):
    if os.environ.get('RM7_BASE'):
        rel = (PKG / 'Becoming' / f'{name}.lean').relative_to(ROOT)
        return subprocess.run(['git', '-C', str(ROOT), 'show', f"{os.environ['RM7_BASE']}:{rel}"], check=True,
                              capture_output=True, text=True).stdout
    return (PKG / 'Becoming' / f'{name}.lean').read_text(encoding='utf-8')


rm = read('RegimeMargin')
assert 'namespace Indexed' not in rm, 'already built'
start = rm.index('\nnamespace Coupled\n')
head, coupled = rm[:start], rm[start:]
ANCHOR = 'variable {D}\n\n/-- The coupled step reads a state only through what the draws leave of it. -/'
coupled = once(coupled, ANCHOR, 'variable {D}\n\n' + (HERE / 'web_section.lean').read_text(encoding='utf-8').rstrip('\n')
               + '\n\n/-- The coupled step reads a state only through what the draws leave of it. -/')


def block(text, name):
    m = re.search(r'\ntheorem ' + re.escape(name) + r' ', text)
    assert m and len(re.findall(r'\ntheorem ' + re.escape(name) + r' ', text)) == 1, name
    s = text.rindex('\n/--', 0, m.start()) + 1
    e = re.search(r'\n\n(?=/--|/-!|theorem |def |namespace |end )', text[m.end():])
    return s, m.end() + e.start() + 1


parts = (HERE / 'pair_corollaries.lean').read_text(encoding='utf-8').split('@@')
news = {'step_mono': parts[0]}
for k in range(1, len(parts), 2):
    news[{'ENDS_OF_BELOW': 'ends_of_below', 'DRAINS': 'drains', 'ENDS_AFTER': 'ends_after',
          'ENDS_OF_PARTNER': 'ends_of_partner', 'ENDS_TOGETHER': 'ends_together'}[parts[k]]] = parts[k + 1]
# the pair laws live after the web section's end, in the pair's part of namespace Coupled
cut = coupled.index('/-- The coupled step reads a state only through what the draws leave of it. -/')
web_part, pair_part = coupled[:cut], coupled[cut:]
for name, new in news.items():
    s, e = block(pair_part, name)
    pair_part = pair_part[:s] + new.strip('\n') + '\n' + pair_part[e:]
# Relay's dependent second drains by the pair's law of draining (which keeps Coupled.drains read by a law on the run)
OLD_SECOND = """/-- With the first at nothing, the second falls by one at every step and the first stays nothing. -/
theorem second_alone (y : Nat) :
    ∀ n, (Law.run (step Drawn.whole first second 1 1) (0, y)).state n = (0, y - n)
  | 0 => rfl
  | n + 1 => (congrArg (step Drawn.whole first second 1 1) (second_alone y n)).trans
    (congr (congrArg Prod.mk (congrArg (0 + ·) (first_of_zero (y - n - 1))))
      (congrArg (y - n - 1 + ·) (second_of_zero (y - n - 1))))"""
NEW_SECOND = """/-- With the first at nothing, the second drains by one at every step, by the pair's law of draining,
and the first stays nothing. -/
theorem second_alone (y : Nat) :
    ∀ n, (Law.run (step Drawn.whole first second 1 1) (0, y)).state n = (0, y - n)
  | 0 => rfl
  | n + 1 => (congrArg (step Drawn.whole first second 1 1) (second_alone y n)).trans
    (congr (congrArg Prod.mk (congrArg (0 + ·) (first_of_zero (y - n - 1))))
      (drains (D := Drawn.whole) (g₁ := first) (H₁ := 1) (H₂ := 1) second_of_zero (p := (0, y - n))
        (Nat.zero_le 1)))"""
pair_part = once(pair_part, OLD_SECOND, NEW_SECOND)
rm = head + web_part + pair_part
if (HERE / 'regime_doc.py').exists():
    exec((HERE / 'regime_doc.py').read_text(encoding='utf-8'))
out = HERE / 'tree' / 'Becoming' / 'RegimeMargin.lean'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(rm, encoding='utf-8')
print('wrote', out, len(rm.splitlines()), 'lines')
