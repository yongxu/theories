#!/usr/bin/env python3
"""Write the crosswalk's checks, as the atlas reads them: what the two critics found, and the second's estimate.

usage: python3 -B sample_summary.py

Reads reads/sample.json (the random draw by stratum) and reads/critic2-share-*.json (a verdict for each drawn entry), and
writes theories/becoming/results/atlas/crosswalk-checks.json: the draw, the verdicts, and an estimate over all entries
weighting each stratum's share by its size. The first critic's sample was aimed at suspects and gives no rate; it is
listed with that said. The verdicts are the second critic's, on the reads before its fixes.
"""
import glob
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = next(p for p in HERE.parents if (p / 'AGENTS.md').is_file())
OUT = ROOT / 'theories/becoming/results/atlas/crosswalk-checks.json'
KINDS = ('holds', 'label', 'fails')

sample = json.loads((HERE / 'reads/sample.json').read_text(encoding='utf-8'))
verdict = {}
for path in sorted(glob.glob(str(HERE / 'reads/critic2-share-*.json'))):
    for v in json.loads(Path(path).read_text(encoding='utf-8'))['verdicts']:
        verdict[v['id']] = v['verdict']
counts = {k: 0 for k in KINDS}
weighted = {k: 0.0 for k in KINDS}
strata = []
for key, ids in sorted(sample['drawn'].items()):
    size = sample['sizes'][key]
    c = {k: sum(verdict[i] == k for i in ids) for k in KINDS}
    for k in KINDS:
        counts[k] += c[k]
        weighted[k] += size * c[k] / len(ids)
    strata.append({'stratum': key, 'size': size, 'drawn': len(ids), **c})
total = sum(sample['sizes'].values())
out = {
    'about': 'Checks of the crosswalk: AI critics, no person. Written by ' + str((HERE / 'sample_summary.py').relative_to(ROOT)) + '; do not edit.',
    'first_critic': {'date': '2026-11-07', 'sampled': 59, 'held': 32, 'partly': 12, 'failed': 15, 'aimed': True,
                     'report': str((HERE / 'reads/CRITIC.md').relative_to(ROOT)),
                     'note': 'aimed at suspects, so not an error rate; its findings led to the repair and the comparison across items'},
    'second_critic': {'date': '2026-11-07', 'seed': sample['seed'], 'per_stratum': sample['per'], 'stage': sample['stage'],
                      'entries': total, 'sampled': sum(len(v) for v in sample['drawn'].values()), 'verdicts': counts,
                      'estimate_percent': {k: round(100 * weighted[k] / total, 1) for k in KINDS}, 'strata': strata,
                      'fixed': 'every fix the critic gave was applied; the rest of the entries were not re-read',
                      'source': str((HERE / 'reads').relative_to(ROOT))},
}
OUT.write_text(json.dumps(out, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print(json.dumps(out['second_critic']['estimate_percent']), counts)
