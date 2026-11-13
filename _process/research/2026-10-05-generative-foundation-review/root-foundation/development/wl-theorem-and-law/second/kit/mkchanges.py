#!/usr/bin/env python3
"""mkchanges <tree> <base> <outdir>: changes.json (old line, new line, file, line) for every Markdown line changed since base."""
import sys, subprocess, difflib, json
tree, base, out = sys.argv[1:4]
files = subprocess.run(['git', '-C', tree, 'diff', '--name-only', base, '--', '*.md'], capture_output=True, text=True).stdout.split()
ch = []
for f in files:
    if f.endswith('.zh.md') or f.startswith(('_process/research', 'theories/becoming/results/', 'README.md', 'RESULTS.md', 'GOALS.md')): continue
    old = subprocess.run(['git', '-C', tree, 'show', f'{base}:{f}'], capture_output=True, text=True).stdout.split('\n')
    new = open(f'{tree}/{f}', encoding='utf-8').read().split('\n')
    for tag, i1, i2, j1, j2 in difflib.SequenceMatcher(None, old, new, autojunk=False).get_opcodes():
        if tag == 'replace' and i2 - i1 == j2 - j1:
            for k in range(i2 - i1):
                ch.append({'piece': f, 'file': f, 'line': j1 + k + 1, 'old': old[i1 + k], 'new': new[j1 + k]})
        elif tag == 'replace':  # a heading given an anchor line: pair the heading lines by position from the end
            for k in range(1, min(i2 - i1, j2 - j1) + 1):
                ch.append({'piece': f, 'file': f, 'line': j2 - k + 1, 'old': old[i2 - k], 'new': new[j2 - k]})
json.dump(ch, open(out + '/changes.json', 'w'), ensure_ascii=False, indent=0)
print('changed lines', len(ch), 'in', len({c['file'] for c in ch}), 'files')
