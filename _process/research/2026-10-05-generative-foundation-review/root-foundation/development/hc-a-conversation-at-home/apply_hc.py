"""HC's text changes P1-P4 and its board row, applied by exact anchored insertion.

Usage: python3 -I apply_hc.py [--apply] [ROOT]. Without --apply it is a dry run. Each anchor must occur
exactly once and each insertion must be absent, so a second run, or a run on moved text, stops
before writing anything. The texts are read from NOTE.md §5, so the note stays their one source.
"""
import re
import sys
from pathlib import Path

args = [a for a in sys.argv[1:] if not a.startswith('--')]
ROOT = Path(args[0]) if args else Path(__file__).resolve().parents[6]
KIT = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/hc-a-conversation-at-home'
APPLY = '--apply' in sys.argv

note = (KIT / 'NOTE.md').read_text(encoding='utf-8')
blocks = re.findall(r'```markdown\n(.*?)\n```', note, re.S)
assert len(blocks) == 6, len(blocks)
p1, p2, p3, p4_part, p4_reason, p4_change = blocks
writes = {}


def once(text, needle, where):
    n = text.count(needle)
    assert n == 1, f'{where}: {n} occurrences of {needle[:70]!r}'


def after(text, anchor, insert, sep, where, absent):
    once(text, anchor, where)
    assert absent not in text, f'{where}: already applied ({absent[:50]!r})'
    return text.replace(anchor, anchor + sep + insert)


m = ROOT / 'theories/becoming/chapters/08-METHOD.md'
s = m.read_text(encoding='utf-8')
s = after(s, 'A relation that a weaker representation omits is not an explanatory failure of the fuller account.',
          p1, '\n\n', m, 'An objection is answered on what it says')
s = after(s, 'For that reason an item is weighed by which of these it serves before it is claimed, and a refinement that serves none waits.',
          p2, '\n', m, '*What the work draws on.*')
writes[m] = s

c = ROOT / 'theories/becoming/chapters/07-SIGNIFICANCE.md'
lines = c.read_text(encoding='utf-8').split('\n')
at = [i for i, line in enumerate(lines) if line.startswith('| Graded status, priority, sufficiency, constraints |')]
assert len(at) == 1, at
assert not any(line.startswith('| An expansion producing ever more novelty is generative |') for line in lines)
lines.insert(at[0] + 1, p3)
writes[c] = '\n'.join(lines)

r = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/DELEGATED-CHOICES.md'
u = r.read_text(encoding='utf-8')
start = u.index('<a id="d66-the-work-read-by-its-own-laws"></a>')
end = u.find('<a id=', start + 10)
end = len(u) if end < 0 else end
seg = u[start:end].split('\n')
assert not any('What the work draws on, and what it takes in from objections' in line for line in seg), 'P4 already applied'


def after_line(lines, prefix, insert, blank):
    hits = [i for i, line in enumerate(lines) if line.startswith(prefix)]
    assert len(hits) == 1, f'D66: {len(hits)} lines starting {prefix!r}'
    lines[hits[0] + 1:hits[0] + 1] = ([''] if blank else []) + [insert]


after_line(seg, '3. **Where the ethics', p4_part, False)
after_line(seg, '**Reasons.** Part 1 applies', p4_reason, True)
after_line(seg, '**What would change it.** A selector inside the work', p4_change, True)
writes[r] = u[:start] + '\n'.join(seg) + u[end:]

b = ROOT / '_process/BECOMING-WORKBOARD.md'
t = b.read_text(encoding='utf-8')
row = [line for line in t.split('\n') if line.startswith('| **HC:')]
assert len(row) == 1, len(row)
new = row[0]
for old, rep in [
    ('Text changes, applied after IV3j lands and outside the lines IV3j and GS2 write: ',
     'Text changes, outside the lines IV3j and GS2 write, landed by order of readiness: '),
    ('what renews its carriers, [AI reading, new]; it bears on this page\'s "Purpose first" bullet, whose keeper decides)',
     'what renews its carriers; accepted by WR\'s author, and the keeper of the way takes its pace sentence into this page\'s "Purpose first" bullet)'),
    (') and P3 (07 §9: one row). ', '), P3 (07 §9: one row) and P4 (D66 gains P1 and P2 as its fourth part). '),
    ('study and source record landed; P1–P3 waiting for IV3j ',
     'study, source record and sources entry landed (`6df140195`, `3bf5b2109`); P1–P4 landed; open only for GS3\'s owner, who decides on the two candidates (rule 2) '),
]:
    once(new, old, 'board row')
    new = new.replace(old, rep)
writes[b] = t.replace(row[0], new)

if APPLY:
    for path, text in writes.items():
        path.write_text(text, encoding='utf-8')
print(('applied' if APPLY else 'dry run ok') + ': ' + ', '.join(str(p.relative_to(ROOT)) for p in writes))
