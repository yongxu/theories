#!/usr/bin/env python3
"""WB: what changed between two reader rounds, sentence by sentence, without what a merge of main brought in.

    python3 sentence_diff_round.py ROUND_TIP HEAD MAIN [-- PATHS...]

It runs sentence_diff.py's comparison from ROUND_TIP to HEAD and keeps a block only where one of its new sentences is
not in MAIN's version of the file, so a block that only takes main's text (another landing's change) is left out."""
import pathlib
import re
import sys

sys.path.insert(0, str(pathlib.Path(__file__).parent))
import sentence_diff as d  # noqa: E402


def main(argv):
    if '--' in argv:
        k = argv.index('--')
        refs, paths = argv[:k], argv[k + 1:]
    else:
        refs, paths = argv, d.DEFAULT_PATHS
    refs = [r for r in refs if r != '--all']
    tip, head, base = refs[:3]
    files = d.changed_files(tip, head, paths) if '--all' not in argv else \
        [f for f in d.git('diff', '--name-only', tip, head, '--', *paths).split() if f]
    for path in files:
        if not path.endswith(('.md', '.py', '.json')):
            continue
        in_main = d.git('show', f'{base}:{path}')
        if in_main == d.git('show', f'{head}:{path}'):
            continue  # the file is main's: every change in it came with the merge
        kept = []
        for block in d.show(tip, head, path):
            news = [l[4:] for l in block.split('\n') if l.startswith('  + ')]
            if any(s not in in_main for s in news) or not news:
                kept.append(block)
        if kept:
            print(f'\n=== {path}\n')
            print('\n\n'.join(kept))


if __name__ == '__main__':
    main(sys.argv[1:])
