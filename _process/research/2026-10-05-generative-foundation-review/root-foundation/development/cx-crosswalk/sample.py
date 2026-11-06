#!/usr/bin/env python3
"""Draw the second critic's random sample from the final reads, stratified by what an entry claims.

usage: python3 -B sample.py [--seed 20261107] [--per 8]

Strata: each `carried` value, and within those with a relation, each relation; agreement is split by `agreement_of`.
From each stratum `--per` entries are drawn (all of it if smaller), by Python's random with the seed, over ids sorted,
so the draw is reproducible. Writes reads/sample.json with the seed, the strata and their sizes.
"""
import argparse
import json
import random
from collections import defaultdict
from pathlib import Path

READS = Path(__file__).resolve().parent / 'reads'


def main(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument('--seed', type=int, default=20261107)
    parser.add_argument('--per', type=int, default=8)
    parser.add_argument('--stage', default='5-compare')
    args = parser.parse_args(argv)
    strata = defaultdict(list)
    for path in sorted(READS.glob(f'*.{args.stage}.json')):
        for e in json.loads(path.read_text(encoding='utf-8'))['entries']:
            key = e['carried'] + ('/' + e['relation'] if e['relation'] else '') + ('/' + e['agreement_of'] if e.get('agreement_of') else '')
            strata[key].append(e['id'])
    rng = random.Random(args.seed)
    drawn = {k: sorted(rng.sample(sorted(v), min(args.per, len(v)))) for k, v in sorted(strata.items())}
    out = {'seed': args.seed, 'per': args.per, 'stage': args.stage, 'sizes': {k: len(v) for k, v in sorted(strata.items())}, 'drawn': drawn}
    (READS / 'sample.json').write_text(json.dumps(out, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
    print(f'{sum(len(v) for v in drawn.values())} entries from {len(drawn)} strata')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
