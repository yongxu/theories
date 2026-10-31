"""Assemble experiments/formations-that-read/ from the builders' drafts.

Writes DESIGN.md (the ten-minute part, the hour part, the rest's index and the
shared sections) and the REST-*.md files, with headings normalized, into OUT.
"""
import re, shutil, sys
from pathlib import Path

B = Path(__file__).resolve().parent.parent
A = B / '_assemble'
OUT = Path(sys.argv[1])
OUT.mkdir(parents=True, exist_ok=True)

GROUPS = {'tr1': ['TR1'], 'tr2': ['TR2', 'TR7'], 'tr3': ['TR3', 'TR6'],
          'tr45': ['TR4', 'TR5'], 'm23': ['TR8', 'TR9']}
REST = {'tr1': 'REST-TR1.md', 'tr2': 'REST-TR2-TR7.md', 'tr3': 'REST-TR3-TR6.md',
        'tr45': 'REST-TR4-TR5.md', 'm23': 'REST-TR8-TR9.md'}
SCRIPTS = {'tr1': ['tr1'], 'tr2': ['tr2', 'tr7'], 'tr3': ['tr3', 'tr6'],
           'tr45': ['tr4', 'tr5'], 'm23': ['tr8', 'tr9']}
ORDER = ['TR1', 'TR2', 'TR3', 'TR4', 'TR5', 'TR6', 'TR7', 'TR8', 'TR9']


def test_id(text):
    m = re.search(r'\bTR(\d)\b', text)
    return 'TR' + m.group(1)


def fronts():
    out = {}
    for k in GROUPS:
        paras = [p.strip() for p in (B / k / 'front.md').read_text().split('\n\n') if p.strip()]
        for p in paras:
            out[test_id(p[:40])] = p
    return out


def hours():
    out = {}
    for k in GROUPS:
        text = (B / k / 'hour.md').read_text()
        parts = re.split(r'(?m)^#{2,4} ', text)
        for part in parts:
            if not part.strip():
                continue
            title, _, body = part.partition('\n')
            out[test_id(title)] = (title.strip(), body.strip(), k)
    return out


def shift(text, top):
    """Shift headings so that the shallowest becomes level `top`."""
    levels = [len(m.group(1)) for m in re.finditer(r'(?m)^(#+) ', text)]
    d = min(levels) - top
    return re.sub(r'(?m)^(#+) ', lambda m: '#' * (len(m.group(1)) - d) + ' ', text)


F, H = fronts(), hours()
assert sorted(F) == ORDER and sorted(H) == ORDER, (sorted(F), sorted(H))

parts = [(A / 'header.md').read_text().strip(), '## The tests in ten minutes',
         (A / 'opening.md').read_text().strip()]
parts += [F[t] for t in ORDER]
parts += ['## The tests in an hour', (A / 'frame.md').read_text().strip()]
for t in ORDER:
    title, body, k = H[t]
    parts.append(f'### {title}\n\n{body}\n\nIn full: [{REST[k]}]({REST[k]}).')
parts.append((A / 'rest-index.md').read_text().strip())
(OUT / 'DESIGN.md').write_text('\n\n'.join(parts) + '\n')

for k, name in REST.items():
    text = shift((B / k / 'rest.md').read_text().strip(), 1)
    tests = ' and '.join(GROUPS[k])
    lines = text.split('\n')
    if not lines[0].startswith('# '):
        raise SystemExit(f'{k}: rest does not start with a heading')
    lines[0] = f'# {tests}: the full design'
    intro = (f'*Part of [the designs of RF\'s tests](DESIGN.md): the exact tables, the power check, '
             f'rivals, usage and references for {tests}. AI-written, not yet reviewed by a person; '
             f'nothing is frozen or run.*')
    text = '\n'.join([lines[0], '', intro] + lines[1:])
    (OUT / name).write_text(text + '\n')
    for s in SCRIPTS[k]:
        for ext in ('.py', '.json'):
            shutil.copyfile(B / k / (s + ext), OUT / (s + ext))
print('wrote', OUT)
