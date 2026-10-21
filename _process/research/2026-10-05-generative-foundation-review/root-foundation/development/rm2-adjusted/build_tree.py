#!/usr/bin/env python3
"""Build RM2's tree: the package's Becoming.RegimeMargin (RM1's) with its laws generalized below to a
condition whose giving adjusts (adjusted_section.lean, `RegimeMargin.Adjusted`, inserted before the
section below the point of no return), the regime's laws on ending and holding restated as the case
whose giving reads what is left alone (their statements unchanged, their proofs through the general
laws), the lemmas no law reads any more in the regime's form removed, and the crossing witness
(crossing_section.lean) appended before the module's end.
usage: python3 -B build_tree.py   (RM2_ROOT names the checkout to read, one whose RegimeMargin is RM1's; default
this repository)"""
import os
import re
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['RM2_ROOT']).resolve() if os.environ.get('RM2_ROOT') else HERE.parents[5]
REL = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/RegimeMargin.lean'
s = (ROOT / REL).read_text(encoding='utf-8')
assert 'namespace Adjusted' not in s, 'not RM1\'s RegimeMargin'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


def drop(text, name, kind='theorem'):
    m = re.search(r'\n' + kind + ' ' + re.escape(name) + r'\b', text)
    assert m, name
    start = m.start() + 1
    doc = text.rfind('\n/--', 0, start)
    assert doc >= 0 and text[text.index('-/', doc) + 2:start].strip() == '', ('docstring', name)
    end = text.index('\n\n', start) + 2
    return text[:doc + 1] + text[end:]


def reprove(text, name, proof):
    m = re.search(r'\ntheorem ' + re.escape(name) + r'\b', text)
    assert m, name
    assert not re.search(r'\ntheorem ' + re.escape(name) + r'\b', text[m.end():]), ('twice', name)
    start = m.start() + 1
    end = text.index('\n\n', start)
    lines = text[start:end].split('\n')
    head = None
    for i, ln in enumerate(lines):
        if i > 0 and ln.startswith('  |'):
            head = lines[:i]
            break
        if ln.rstrip().endswith(':=') or ln.rstrip().endswith(':= by'):
            head = lines[:i] + [re.sub(r'\s*:=( by)?\s*$', '', ln)]
            break
    assert head is not None, name
    return text[:start] + '\n'.join(head) + ' :=\n' + proof + text[end:]


# The regime's laws, the case whose giving reads what is left alone.
CASES = {
    'ends_below': '''  (Adjusted.orbit_regime g H (x, 0) x).symm.trans
    (Adjusted.ends_below short (Adjusted.regime_staysShort g H) (Adjusted.regime_fromNothing nothing)
      below (Adjusted.draw_pos short below))''',
    'stays_ended': '''  (Adjusted.orbit_regime g H (x, 0) (x + k)).symm.trans
    (Adjusted.stays_ended short (Adjusted.regime_staysShort g H) (Adjusted.regime_fromNothing nothing)
      below (Adjusted.draw_pos short below) k)''',
    'holds': '''  fun n =>
    have h := Adjusted.holds (r := H) meets (Adjusted.regime_staysMet g H) (Adjusted.regime_keeps keeps)
      low high (Nat.le_refl H) n
    ⟨Nat.le_trans h.1 (Nat.le_of_eq (Adjusted.orbit_regime g H (x, H) n)),
     Nat.le_trans (Nat.le_of_eq (Adjusted.orbit_regime g H (x, H) n).symm) h.2.1⟩''',
    'ends_iff_below': '''  have transfer : ∀ r, (∃ n, ((Law.run (Adjusted.step (fun e _ => g e) H) (x, r)).state n).1 = 0) ↔
      ∃ n, (Law.run (step g H) x).state n = 0 := fun r =>
    ⟨fun ⟨n, zero⟩ => ⟨n, (Adjusted.orbit_regime g H (x, r) n).symm.trans zero⟩,
     fun ⟨n, zero⟩ => ⟨n, (Adjusted.orbit_regime g H (x, r) n).trans zero⟩⟩
  (Nat.lt_or_ge x (H + y)).elim
    (fun below => (transfer 0).symm.trans
      (Adjusted.ends_iff_below pos short (Adjusted.regime_staysShort g H)
        (Adjusted.regime_fromNothing nothing) meets (Adjusted.regime_staysMet g H)
        (Adjusted.regime_keeps keeps) high ⟨fun _ => below, fun _ => Adjusted.draw_pos short below⟩))
    (fun ge => (transfer H).symm.trans
      (Adjusted.ends_iff_below pos short (Adjusted.regime_staysShort g H)
        (Adjusted.regime_fromNothing nothing) meets (Adjusted.regime_staysMet g H)
        (Adjusted.regime_keeps keeps) high
        ⟨fun lt => absurd lt (Nat.lt_irrefl H),
         fun lt => absurd (Nat.lt_of_lt_of_le lt ge) (Nat.lt_irrefl x)⟩))''',
}
for name, proof in CASES.items():
    s = reprove(s, name, proof)
# The regime's forms of lemmas the laws above no longer read: their general forms in `Adjusted` replace them.
GONE = ['step_zero', 'step_of_lt', 'step_falls', 'step_below', 'orbit_bound', 'orbit_from_zero', 'step_holds']
for name in GONE:
    s = drop(s, name)

# The general section goes in after the regime's laws are restated, below them in the file's order of reading.
BELOW = '/-! ## Below the point of no return -/'
s = once(s, BELOW, (HERE / 'adjusted_section.lean').read_text(encoding='utf-8') + '\n' + BELOW)

END = '\nend RegimeMargin\n'
s = once(s, END, '\n' + (HERE / 'crossing_section.lean').read_text(encoding='utf-8') + END)

exec((HERE / 'docstring_edits.py').read_text(encoding='utf-8'))

out = HERE / 'tree' / 'Becoming' / 'RegimeMargin.lean'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(s, encoding='utf-8')
print('wrote', out, len(s.splitlines()), 'lines')
