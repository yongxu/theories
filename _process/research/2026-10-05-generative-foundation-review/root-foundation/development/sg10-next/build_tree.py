#!/usr/bin/env python3
"""Build SG10's tree: the package's Becoming.Optimum (SG9's) with SG8's and SG9's laws generalized below to any
law of what stands (next_section.lean, `Optimum.Next` and `Web.Next`, inserted before the section on an order
weighting later draws less), SG8's and SG9's definitions and laws restated as the case where what stands is the
level with its renewal (their statements unchanged, their proofs one line), and the section on others drawing
first (shared_section.lean) appended before the module's end.
usage: python3 -B build_tree.py   (SG10_ROOT names the checkout to read, one whose Optimum is SG9's; default this
repository)"""
import os
import re
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ['SG10_ROOT']).resolve() if os.environ.get('SG10_ROOT') else HERE.parents[5]
REL = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Optimum.lean'
s = (ROOT / REL).read_text(encoding='utf-8')
assert 'GainsMost' in s and 'namespace Next' not in s, 'not SG9\'s Optimum'


def once(text, old, new):
    assert text.count(old) == 1, ('edit does not match once', old[:90], text.count(old))
    return text.replace(old, new)


G = '(G := fun _ z => z + R z)'
REST = '(fun _ => Nat.le_trans (Nat.le_of_eq (Nat.zero_add (R 0))) rests)'
KEEP = '(fun _ => Nat.le_add_right y (R y))'
EMPTY = '(fun _ => (Nat.zero_add (R 0)).trans empty)'

SG8 = '/-! ## An order weighting later draws less'
SG9 = '/-! ## Rebuilding from below'
a = s.index(SG8)
b = s.index('\nnamespace Web\n', a)
c = s.index('\nnamespace Optimum\n', b)
d = s.index(SG9, c)
e = s.index('\nnamespace Web\n', d)
f = s.index('\nnamespace Optimum\n', e)
regions = [s[:a], s[a:b], s[b:c], s[c:d], s[d:e], s[e:f], s[f:]]

PROOFS = {
    1: {
        'gainsMost_of_greatest': f'Next.gainsMost_of_greatest {G} greatest',
        'frontier_of_gainsMost': f'Next.frontier_of_gainsMost {G} opens ends most',
        'frontier_gains_of_most': f'Next.frontier_gains_of_most {G} rising opens ends most front',
        'frontier_below_weighted': f'Next.frontier_below {G} rising opens ends greatest above front',
        'holding_open_at': f'Next.holding_open {G} reach drawsDown {KEEP} (fun _ => holds) {REST} long',
        'exhausting_frontier': f'Next.exhausting_frontier {G} outpaced drawsDown {REST} long',
        'frontier_exhausts': f'Next.frontier_exhausts {G} rising strictly drawsDown {REST} long front',
        'frontier_leaves':
            f'Next.frontier_leaves {G} rising {EMPTY} outgrows reach drawsDown {KEEP} (fun _ => holds) long front',
    },
    4: {
        'rise_stays': f'Next.rise_stays {G} {KEEP} top',
        'rebuilding_frontier':
            f'Next.rebuilding_frontier {G} low (fun _ => grows) {KEEP} rises top (fun _ => holds) {REST}',
        'frontier_rebuilds': f'Next.frontier_rebuilds {G} rising low (fun _ => grows) {KEEP} rises strictly top '
                             f'(fun _ => holds) {REST} front',
        'frontier_rebuilt': f'Next.frontier_rebuilt {G} rising low (fun _ => grows) {KEEP} rises above '
                            f'(fun _ => holds) {REST} front',
    },
}

# The renewal-law forms of lemmas the laws above no longer use: their general forms in `Optimum.Next` replace them.
DROPPED = {
    1: ['weighted_add_left', 'drawable_step', 'drawable_le_of_gains', 'drawable_lt_of_gains', 'weighted_of_ends',
        'weighted_le_of_gains', 'weighted_lt_of_gains', 'outpaced_greatest', 'outpaced_above', 'ended_outdrawn',
        'stays_empty'],
    4: ['rise_succ', 'rise_le', 'rise_le_top', 'rise_within', 'rise_of_below', 'rise_at_top', 'rise_below_before',
        'le_rise', 'rebuilding_before', 'rebuilding_after', 'rebuilding_at', 'rebuilding_within', 'rebuilding_le_cap',
        'rebuilding_open', 'rebuilding_gainsMost'],
}


def drop(text, name, kind='theorem'):
    m = re.search(r'\n' + kind + ' ' + re.escape(name) + r'\b', text)
    assert m, name
    start = m.start() + 1
    doc = text.rfind('\n/--', 0, start)
    assert doc >= 0 and text[text.index('-/', doc) + 2:start].strip() == '', ('docstring', name)
    end = text.index('\n\n', start) + 2
    return text[:doc + 1] + text[end:]


def wrap(proof):
    """Break a one-line proof at spaces outside parentheses to keep lines within 100 columns."""
    words, lines, line = proof.split(' '), [], '  '
    depth = 0
    for wd in words:
        piece = (' ' if line.strip() else '') + wd
        if len(line) + len(piece) > 100 and line.strip():
            lines.append(line)
            line = '    ' + wd
        else:
            line += piece
    lines.append(line)
    return '\n'.join(lines)


def reprove(text, name, proof):
    m = re.search(r'\ntheorem ' + re.escape(name) + r'\b', text)
    assert m, name
    assert not re.search(r'\ntheorem ' + re.escape(name) + r'\b', text[m.end():]), ('twice', name)
    start = m.start() + 1
    end = text.index('\n\n', start)
    decl = text[start:end]
    lines = decl.split('\n')
    sig_end = None
    for i, ln in enumerate(lines):
        if i > 0 and ln.startswith('  |'):
            sig_end = i
            head = lines[:i]
            break
        if ln.rstrip().endswith(':=') or ln.rstrip().endswith(':= by'):
            sig_end = i + 1
            last = re.sub(r'\s*:=( by)?\s*$', '', ln)
            head = lines[:i] + [last]
            break
    assert sig_end is not None, name
    new = '\n'.join(head) + ' :=\n' + wrap(proof)
    return text[:start] + new + text[end:]


for i, table in PROOFS.items():
    for name, proof in table.items():
        regions[i] = reprove(regions[i], name, proof)
for i, names in DROPPED.items():
    for name in names:
        regions[i] = drop(regions[i], name)

# SG8's definitions, the case of the law where what stands is the level with its renewal.
regions[1] = once(regions[1], '''def weightedOver (w R : Nat → Nat) (x : Nat → Nat) (n : Nat) : Nat :=
  Amounts.whole.sum (fun t => w t * drawnAt x (fun t => R (x t)) t) 0 n''',
'''def weightedOver (w R : Nat → Nat) (x : Nat → Nat) (n : Nat) : Nat :=
  Next.weighted w (fun _ z => z + R z) x n''')
regions[1] = drop(regions[1], 'drawable', 'def')
regions[1] = once(regions[1], '''def GainsMost (w R : Nat → Nat) (k s n : Nat) (h : Nat → Nat) : Prop :=
  ∀ x, OpenCourse R k s x → ∀ t, t < n →
    w (t + 1) * (x (t + 1) + R (x (t + 1))) + w t * h (t + 1) ≤
      w (t + 1) * (h (t + 1) + R (h (t + 1))) + w t * x (t + 1)''',
'''def GainsMost (w R : Nat → Nat) (k s n : Nat) (h : Nat → Nat) : Prop :=
  Next.GainsMost w (fun _ z => z + R z) k s n h''')
# Two lemmas without the renewal move up, before the general section that uses them.
regions[1] = once(regions[1], '''/-- Two steps set side by side. -/
theorem add_steps {P P' H H' a b u v : Nat} (stepP : P' + a = P + u) (stepH : H' + b = H + v) :
    P' + (a + b) = P + (u + b) ∧ H' + (a + b) = H + (v + a) :=
  ⟨by rw [← Nat.add_assoc P' a b, stepP, Nat.add_assoc P u b],
   by rw [Nat.add_comm a b, ← Nat.add_assoc H' b a, stepH, Nat.add_assoc H v a]⟩

''', '')
regions[1] = once(regions[1], '''/-- What `y` gains at each step, said of the course holding it. -/
theorem holding_gains {P : Nat → Nat → Prop} (at_y : ∀ t, t < n → P t y) :
    ∀ t, t < n → P t (holding s y n (t + 1)) :=
  fun t lt => Eq.subst (motive := P t) (holding_before lt).symm (at_y t lt)

''', '')
regions[4] = once(regions[4], '''def rise (R : Nat → Nat) (y s : Nat) : Nat → Nat
  | 0 => s
  | t + 1 => if rise R y s t + R (rise R y s t) ≤ y then rise R y s t + R (rise R y s t) else y''',
'''def rise (R : Nat → Nat) (y s : Nat) : Nat → Nat :=
  Next.rise (fun _ z => z + R z) y s''')
regions[4] = once(regions[4], '''def rebuilding (R : Nat → Nat) (y s n : Nat) : Nat → Nat
  | 0 => s
  | t + 1 => if t < n then rise R y s (t + 1) else 0''',
'''def rebuilding (R : Nat → Nat) (y s n : Nat) : Nat → Nat :=
  Next.rebuilding (fun _ z => z + R z) y s n''')

s = ''.join(regions)
head_end = s.index('namespace Becoming')
gone = sorted({n for names in DROPPED.values() for n in names} | {'drawable'}, key=len, reverse=True)
head = re.sub(r'`Optimum\.(' + '|'.join(map(re.escape, gone)) + r')`', r'`Optimum.Next.\1`', s[:head_end])
s = head + s[head_end:]
s = once(s, SG8, (HERE / 'next_section.lean').read_text(encoding='utf-8') + SG8)
assert s.endswith('end Becoming\n')
s = s[:-len('end Becoming\n')] + (HERE / 'shared_section.lean').read_text(encoding='utf-8').lstrip('\n') + \
    '\nend Becoming\n'

# The module docstring: the bullet, the reading and what is not derived.
exec((HERE / 'docstring_edits.py').read_text(encoding='utf-8'))

out = HERE / 'tree' / 'Becoming' / 'Optimum.lean'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(s, encoding='utf-8')
print('wrote', out, len(s.splitlines()), 'lines')
