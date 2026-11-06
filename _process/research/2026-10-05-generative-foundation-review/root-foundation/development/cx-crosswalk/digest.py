#!/usr/bin/env python3
"""Print a compact digest of the crosswalk's reads, one line per entry, for a reader of the whole.

usage: python3 -B digest.py [--stage 3-check] [--counts]

Each line: item, entry id, carried, relation, the targets' record ids, and the entry's name. `--counts` prints only the
per-item counts by `carried` and by `relation`. The entries themselves stay in reads/.
"""
import argparse
import collections
import json
from pathlib import Path

READS = Path(__file__).resolve().parent / 'reads'


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--stage', default='3-check')
    parser.add_argument('--counts', action='store_true')
    args = parser.parse_args()
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
            print(f'  {e["id"]} | {e["carried"]} | {e["relation"]} | {targets} | {e["name"]["en"]}')
    print(f'TOTAL carried {dict(total_c)}; relation {dict(total_r)}')


if __name__ == '__main__':
    main()
