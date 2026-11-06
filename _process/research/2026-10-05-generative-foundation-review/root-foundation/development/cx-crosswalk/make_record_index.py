#!/usr/bin/env python3
"""Write record-index.tsv beside this file: every result's id, status, kind, region, home anchor and title, read from the
generated theory graph, for the crosswalk's readers to grep. usage: python3 -B make_record_index.py"""
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = next(p for p in HERE.parents if (p / 'AGENTS.md').is_file())
graph = json.loads((ROOT / 'theories/becoming/results/data/theory-graph.json').read_text(encoding='utf-8'))
homes = {}
for e in graph['edges']:
    if e['type'] == 'states':
        homes.setdefault(e['to'], []).append(e['from'].removeprefix('section:'))
rows = ['id\tstatus\tkind\tregion\thome\ttitle']
for n in sorted((n for n in graph['nodes'] if n['type'] == 'result'), key=lambda n: n['record']):
    home = ' '.join(sorted(homes.get(n['id'], []))) or '-'
    rows.append('\t'.join([n['record'], n.get('status', ''), n.get('kind', ''), n.get('region', ''), home,
                           (n.get('title') or '').replace('\t', ' ')]))
(HERE / 'record-index.tsv').write_text('\n'.join(rows) + '\n', encoding='utf-8')
print(f'{len(rows) - 1} records written')
