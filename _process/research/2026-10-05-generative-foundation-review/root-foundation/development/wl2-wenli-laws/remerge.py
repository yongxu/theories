"""WL2: resolve a merge of main whose landings took the study section WL2 had, and renumber WL2's section and its
citations. usage (from the checkout root, merge in progress): python3 -B remerge.py OLD NEW"""
import json
import re
import subprocess
import sys
from pathlib import Path

old, new = sys.argv[1], sys.argv[2]
RX = re.compile(r'<<<<<<< [^\n]*\n(.*?)=======\n(.*?)>>>>>>> [^\n]*\n', re.S)
S = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
B = '_process/BECOMING-WORKBOARD.md'
H = '_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md'
GEN = ['DEPENDENCIES.md', '_process/architecture/generated-manifest.json']

# the study: main's sections, then WL2's renumbered
s = Path(S).read_text(encoding='utf-8')
m = RX.search(s)
mine, theirs = m.group(1), m.group(2)
assert mine.startswith(f'## {old}. The laws of 文'), mine[:60]
top = max(int(x) for x in re.findall(r'^## (\d+)\. ', theirs, re.M))
assert int(new) == top + 1, (new, top)
mine = mine.replace(f'## {old}. The laws of 文', f'## {new}. The laws of 文', 1)
s = s[:m.start()] + theirs.rstrip('\n') + '\n\n' + mine + s[m.end():]
assert not RX.search(s)
Path(S).write_text(s, encoding='utf-8')

# the board: main's lines with WL2's receipt and landing; rows moved on both sides dropped
b = Path(B).read_text(encoding='utf-8')
blocks = list(RX.finditer(b))
out, pos = [], 0
for k in blocks:
    out.append(b[pos:k.start()])
    mine_b, theirs_b = k.group(1), k.group(2)
    if theirs_b.startswith('- **Main and receipts:**'):
        ml = theirs_b.rstrip('\n').split('\n')
        r = re.search(r"the latest core receipt is [^;]*?`(\d{8}T\d{6}\.\d+Z)` \(2\d October 2026\)", ml[0])
        ml[0] = ml[0].replace(r.group(0), "the latest core receipt is WL2's `20261022T110022.458880Z` (22 October 2026)")
        mq = [l for l in mine_b.split('\n') if l.startswith('- **Queue:** ')][0]
        landed = re.match(r'- \*\*Queue:\*\* (WL2 landed \(.*?\));', mq).group(1).replace(f'study §{old};', f'study §{new};')
        assert ml[1].startswith('- **Queue:** ')
        ml[1] = '- **Queue:** ' + landed + '; ' + ml[1][len('- **Queue:** '):]
        out.append('\n'.join(ml) + '\n')
    else:
        assert all(l.startswith('| **') for l in (mine_b + theirs_b).strip('\n').split('\n')), 'rows only'
    pos = k.end()
out.append(b[pos:])
b = ''.join(out)
assert '<<<<<<<' not in b
Path(B).write_text(b, encoding='utf-8')

# the history file: main's rows, then WL2's
h = Path(H).read_text(encoding='utf-8')
m = RX.search(h)
h = h[:m.start()] + m.group(2) + m.group(1).replace(f'study §{old};', f'study §{new};') + h[m.end():]
assert not RX.search(h)
Path(H).write_text(h, encoding='utf-8')

# the rebind log: the union by date
p = '_process/architecture/rebinds.jsonl'
t = Path(p).read_text(encoding='utf-8')
m = RX.search(t)
lines = {l for l in (m.group(1) + m.group(2)).split('\n') if l}
t = t[:m.start()] + '\n'.join(sorted(lines, key=lambda l: json.loads(l)['date'])) + '\n' + t[m.end():]
Path(p).write_text(t, encoding='utf-8')

# generated views and re-pointed records: main's (rendered and re-pointed again after)
conflicted = subprocess.run(['git', 'diff', '--name-only', '--diff-filter=U'], capture_output=True, text=True).stdout.split()
for f in conflicted:
    if f in GEN or f.startswith('theories/becoming/results/records/'):
        subprocess.run(['git', 'checkout', '--theirs', '--', f], check=True)

# WL2's citations of its study section
WL2 = ['theories/becoming/chapters/THE-THEORY-OF-BECOMING.md', 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md',
       '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/zhonghua/wenli/centre.fragment',
       '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/zhonghua/wenli/head.fragment',
       '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/zhonghua/work/round8-edits.json',
       'theories/becoming/results/records/the-split-that-makes-sense.json',
       'theories/becoming/results/records/a-code-formed-between-formations.json',
       'theories/becoming/results/records/a-formations-own-course.json', 'theories/becoming/results/records/wenli-on-the-spine.json']
for f in WL2:
    x = Path(f).read_text(encoding='utf-8')
    y = x.replace(f'#{old}-the-laws-of-文-as-theorems', f'#{new}-the-laws-of-文-as-theorems')
    y = re.sub(rf'\[study §{old}\]\(([^)]*#{new}-the-laws-of-文)', rf'[study §{new}](\1', y)
    y = re.sub(rf'\[研究第 {old} 节\]\(([^)]*#{new}-the-laws-of-文)', rf'[研究第 {new} 节](\1', y)
    if f.endswith('.json'):
        y = y.replace(f'study section {old}', f'study section {new}').replace(f'研究第 {old} 节', f'研究第 {new} 节')
    Path(f).write_text(y, encoding='utf-8')
    print(f.split('/')[-1], y.count(f'#{new}-the-laws'), x != y)
subprocess.run(['git', 'add', S, B, H, p] + GEN + [f for f in conflicted if f.startswith('theories/becoming/results/records/')],
               check=True)
print('resolved; study section', new)
