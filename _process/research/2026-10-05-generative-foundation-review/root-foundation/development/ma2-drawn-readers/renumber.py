#!/usr/bin/env python3
"""Move MA2's study section to the next free number after another landing took its number.

usage (from the checkout root, mid-merge, the study conflicted): python3 -B renumber.py OLD NEW SOURCE_COMMIT
Takes main's study and appends MA2's section from SOURCE_COMMIT renumbered NEW; moves every pointer to the section
(the delegated choices EN and ZH, the source record, land.py) from OLD to NEW."""
import subprocess
import sys
from pathlib import Path

ROOT = Path.cwd()
OLD, NEW, SOURCE = sys.argv[1], sys.argv[2], sys.argv[3]
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
HEAD = f'## {OLD}. Readers drawn from the selected (MA2)'

ours = subprocess.run(['git', 'show', f'{SOURCE}:{STUDY}'], capture_output=True, text=True, check=True).stdout
start = ours.index(HEAD)
section = ours[start:].rstrip('\n')
assert '\n## ' not in section[3:], 'the section is not the last one'
main = subprocess.run(['git', 'show', f'main:{STUDY}'], capture_output=True, text=True, check=True).stdout
assert f'## {NEW}.' not in main and f'## {int(NEW) + 1}.' not in main, 'NEW is not the next free number'
assert f'## {int(NEW) - 1}.' in main, 'NEW does not follow main\'s last section'
section = section.replace(HEAD, f'## {NEW}. Readers drawn from the selected (MA2)', 1)
section = section.replace(f'This section moves from 355 to {OLD}.', f'This section moves from 355 to {NEW}.')
assert f'from 355 to {NEW}' in section
(ROOT / STUDY).write_text(main.rstrip('\n') + '\n\n' + section + '\n', encoding='utf-8')

pairs = [(f'study section {OLD}', f'study section {NEW}'),
         (f'#{OLD}-readers-drawn-from-the-selected-ma2', f'#{NEW}-readers-drawn-from-the-selected-ma2'),
         (f'研究第 {OLD} 节', f'研究第 {NEW} 节')]
for path in [RF + 'DELEGATED-CHOICES.md', RF + 'DELEGATED-CHOICES.zh.md',
             'sources/15-codex-theory-conversations/2026-10-24-alignment-of-the-joint-selection.md',
             RF + 'development/ma2-drawn-readers/land.py']:
    p = ROOT / path
    s = p.read_text(encoding='utf-8')
    n = 0
    for a, b in pairs:
        n += s.count(a)
        s = s.replace(a, b)
    p.write_text(s, encoding='utf-8')
    print(path, n, 'pointers moved')
