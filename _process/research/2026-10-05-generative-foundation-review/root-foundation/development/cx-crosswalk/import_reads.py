#!/usr/bin/env python3
"""Write the atlas's correspondence entries from the crosswalk's checked reads.

usage: python3 -B import_reads.py [--dry-run]

Reads reads/<item>.5-compare.json, each item's final file (map, revise, check, repair, compare), and writes
theories/becoming/results/atlas/entries/correspondences.json and correspondence_groups.json, in the order of ORDER below:
the earlier folders as MAP.md lists them, then the domains. A group id takes the prefix cxg-, since ids are unique across
the atlas and a folder or domain may share a name with a dynamic. Stops on a missing item or a repeated id, and writes
nothing then. It changes no reading; validation is the atlas's own (`python3 -B tools/research/atlas.py`).
"""
import argparse
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = next(p for p in HERE.parents if (p / 'AGENTS.md').is_file())
READS = HERE / 'reads'
ENTRIES = ROOT / 'theories/becoming/results/atlas/entries'
READ_BY = ['map', 'revise', 'check', 'repair', 'compare']
STAGE = '5-compare'
FOLDERS = ('alignment-selection-on-cognition', 'architecture-for-a-living-earth', 'context-as-existence-runtimes',
           'drives-narrative-attractors-and-mind', 'evolving-community-swarms', 'human-solutions-museum',
           'jian-and-wenyan-as-formal-language', 'keep-the-possibility-space-open', 'memories-and-working-style',
           'meta-attractor', 'relational-self-and-datong', 'selfishness-spiral-and-narrative-value-frames',
           'spirit-space-token-and-yi-substrate', 'the-fork-and-cooperative-infrastructure',
           'wamotopia-and-the-wamo-protocol', 'zhishan-intelligence-must-be-good')
DOMAINS = ('chinese-classical', 'buddhist', 'other-indian', 'greek-roman', 'abrahamic-islamic', 'indigenous-african',
           'modern-philosophy', 'systems-cybernetics', 'dynamics-physics-complexity', 'ecology-evolution',
           'economics-politics-sociology', 'psychology-alignment-logic')
ORDER = FOLDERS + DOMAINS


def main(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument('--dry-run', action='store_true')
    args = parser.parse_args(argv)
    groups, entries, problems = [], [], []
    for item in ORDER:
        path = READS / f'{item}.{STAGE}.json'
        if not path.is_file():
            problems.append(f'no {path.name}')
            continue
        data = json.loads(path.read_text(encoding='utf-8'))
        group = dict(data['group'])
        group_id = 'cxg-' + group['id']
        group.update(id=group_id, reads=READ_BY, source=str(path.relative_to(ROOT)))
        groups.append(group)
        entries += [{**e, 'group': group_id, 'reads': READ_BY} for e in data['entries']]
    stray = sorted(p.name for p in READS.glob(f'*.{STAGE}.json') if p.name.removesuffix(f'.{STAGE}.json') not in ORDER)
    problems += [f'{name} is not in ORDER' for name in stray]
    seen = set()
    for e in entries:
        if e['id'] in seen:
            problems.append(f'{e["id"]} is listed twice')
        seen.add(e['id'])
    if problems:
        print('\n'.join(problems))
        return 1
    print(f'{len(groups)} groups, {len(entries)} correspondences')
    if not args.dry_run:
        for name, value in (('correspondence_groups', groups), ('correspondences', entries)):
            (ENTRIES / f'{name}.json').write_text(json.dumps(value, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
    return 0


if __name__ == '__main__':
    sys.exit(main())
