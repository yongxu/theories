#!/usr/bin/env python3
"""Print a compact digest of the crosswalk's reads, one line per entry, for a reader of the whole.

usage: python3 -B digest.py [--stage 3-check] [--counts] [--target A,B] [--ids a,b]

Each line: item, entry id, carried, relation and what agreement is with, the targets' record ids, and the entry's name.
`--counts` prints only the per-item counts by `carried` and by `relation`. `--target` prints each entry citing a record or
anchor containing one of the strings, with the target's role, and the entry's sense and reading; `--ids` prints the named
entries the same way. The entries themselves stay in reads/.
"""
import argparse
import collections
import json
from pathlib import Path

READS = Path(__file__).resolve().parent / 'reads'


def closer(args):
    """The entries a reader across items compares: labels, the target's role, and the entry's own sense and reading."""
    wanted = [t for t in (args.target or '').split(',') if t]
    ids = {i for i in (args.ids or '').split(',') if i}
    shown = 0
    for path in sorted(READS.glob(f'*.{args.stage}.json')):
        for e in json.loads(path.read_text(encoding='utf-8'))['entries']:
            hit = [t for t in e['targets'] if any(w in (t.get('record') or '') or w in (t.get('anchor') or '') for w in wanted)]
            if not hit and e['id'] not in ids:
                continue
            shown += 1
            of = f' of {e["agreement_of"]}' if e.get('agreement_of') else ''
            print(f'### {e["id"]} [{path.name.split(".")[0]}] {e["carried"]} / {e["relation"]}{of}: {e["name"]["en"]}')
            print('sense: ' + e['sense']['en'])
            print('reading: ' + e['reading']['en'])
            if e.get('source_adds'):
                print('source adds: ' + e['source_adds']['en'])
            for t in hit or e['targets']:
                part = f' ({t["part"]})' if t.get('part') else ''
                print(f'  [{t["role"]}] {t.get("record") or t.get("anchor")}{part}: {t["says"]["en"]}')
            print()
    print(f'{shown} entries')


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--stage', default='3-check')
    parser.add_argument('--counts', action='store_true')
    parser.add_argument('--target')
    parser.add_argument('--ids')
    args = parser.parse_args()
    if args.target or args.ids:
        return closer(args)
    total_c, total_r = collections.Counter(), collections.Counter()
    for path in sorted(READS.glob(f'*.{args.stage}.json')):
        data = json.loads(path.read_text(encoding='utf-8'))
        group = data['group']
        entries = data['entries']
        c = collections.Counter(e['carried'] for e in entries)
        r = collections.Counter(e['relation'] or 'none' for e in entries)
        total_c.update(c)
        total_r.update(r)
        print(f'## {group["id"]} [{group["domain"]}; {group["kind"]}] {len(entries)} entries; carried {dict(c)}; relation {dict(r)}')
        if args.counts:
            continue
        print(group['summary']['en'])
        for item in group.get('not_mapped') or []:
            print(f'  not mapped: {item.get("en", "")[:120]} ({item.get("why", "")[:80]})')
        for e in entries:
            targets = ','.join(t.get('record') or t.get('anchor', '') for t in e['targets'])
            relation = e['relation'] if not e.get('agreement_of') else f'{e["relation"]} of {e["agreement_of"]}'
            print(f'  {e["id"]} | {e["carried"]} | {relation} | {targets} | {e["name"]["en"]}')
    print(f'TOTAL carried {dict(total_c)}; relation {dict(total_r)}')


if __name__ == '__main__':
    main()
