#!/usr/bin/env python3
"""WB: the branch's changes against a base, sentence by sentence, for readers.

The repository writes a paragraph on one line, so a line diff prints whole paragraphs. This prints, for each changed
line of each Markdown, Python or JSON-text file, only the sentences that changed, with the line number in the new file
and one unchanged sentence either side as context.

    python3 sentence_diff.py [BASE] [HEAD] [-- PATHS...]   (defaults: main, HEAD, the review's paths)
"""
import difflib
import re
import subprocess
import sys

DEFAULT_PATHS = ['theories', 'GLOSSARY.md', 'GLOSSARY.zh.md', 'AGENTS.md', 'MAP.md', '_process/navigation',
                 'tools/research']
EXCLUDE = ['theories/becoming/history', 'theories/becoming/results/atlas', 'theories/becoming/results/data/atlas.json',
           'theories/becoming/results/data/source-index.json', 'theories/becoming/results/data/lean-index.json',
           'theories/becoming/results/records']
SPLIT = re.compile(r'(?<=[.;:?!。；：？！])\s+(?=[*\[(A-Z`“"「（一-鿿])|(?<=[。；？！])')


def git(*args):
    return subprocess.run(['git', *args], capture_output=True, text=True, check=False).stdout


def sentences(line):
    return [s for s in SPLIT.split(line) if s and s.strip()]


def changed_files(base, head, paths):
    spec = paths + [f':(exclude){p}' for p in EXCLUDE]
    return [f for f in git('diff', '--name-only', base, head, '--', *spec).split() if f]


def show(base, head, path):
    old = git('show', f'{base}:{path}').splitlines()
    new = git('show', f'{head}:{path}').splitlines()
    out = []
    for tag, i1, i2, j1, j2 in difflib.SequenceMatcher(None, old, new, autojunk=False).get_opcodes():
        if tag == 'equal':
            continue
        a, b = sentences(' \n'.join(old[i1:i2])), sentences(' \n'.join(new[j1:j2]))
        if not b:
            out.append(f'{path}:{j1} (removed)\n' + '\n'.join(f'  - {s}' for s in a))
            continue
        lines = []
        sm = difflib.SequenceMatcher(None, a, b, autojunk=False)
        for t2, x1, x2, y1, y2 in sm.get_opcodes():
            if t2 == 'equal':
                continue
            if y1 > 0:
                lines.append(f'    … {b[y1 - 1][:160]}')
            lines += [f'  - {s}' for s in a[x1:x2]] + [f'  + {s}' for s in b[y1:y2]]
            if y2 < len(b):
                lines.append(f'    … {b[y2][:160]}')
        if lines:
            out.append(f'{path}:{j1 + 1}\n' + '\n'.join(lines))
    return out


def main(argv):
    if '--' in argv:
        k = argv.index('--')
        refs, paths = argv[:k], argv[k + 1:]
    else:
        refs, paths = argv, DEFAULT_PATHS
    base, head = (refs + ['main', 'HEAD'])[:2] if len(refs) < 2 else refs[:2]
    for path in changed_files(base, head, paths):
        if not path.endswith(('.md', '.py', '.json', '.svg')) or path.endswith('.svg'):
            continue
        blocks = show(base, head, path)
        if blocks:
            print(f'\n=== {path}\n')
            print('\n\n'.join(blocks))


if __name__ == '__main__':
    main(sys.argv[1:])
