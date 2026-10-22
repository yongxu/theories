#!/usr/bin/env python3
"""After land_xl1.py and land_xl2.py: bind the two new records' references to the files as both landings left them
(land_xl2.py edits the chapter, the study and COVERAGE.json after land_xl1.py wrote its record). Only these two
records, written in this landing, are touched. usage (from the checkout root): python3 -I <kit>/own_refs.py"""
import hashlib, json
from pathlib import Path
ROOT = Path.cwd()
for rid in ('central-laws-over-every-exchange', 'what-discrete-steps-and-whole-amounts-represent'):
    p = ROOT / 'theories/becoming/results/records' / f'{rid}.json'
    r = json.loads(p.read_text(encoding='utf-8'))
    for ref in r['references']:
        if 'sha256' in ref:
            ref['sha256'] = hashlib.sha256((ROOT / ref['path']).read_bytes()).hexdigest()
    p.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print('bound', rid)
