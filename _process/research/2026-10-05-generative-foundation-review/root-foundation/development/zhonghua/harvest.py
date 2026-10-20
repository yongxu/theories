"""Harvest a workflow journal into per-agent JSON files: out/<label>.json (read-only on the journal)."""
import json
import os
import sys

journal, out = sys.argv[1], sys.argv[2]
os.makedirs(out, exist_ok=True)
labels = {}
n = 0
for line in open(journal, encoding='utf-8'):
    d = json.loads(line)
    if d['type'] == 'started':
        labels[d['key']] = d['label']
    elif d['type'] == 'result':
        r = d.get('result')
        if isinstance(r, str):
            try:
                r = json.loads(r)
            except ValueError:
                pass
        lab = labels.get(d.get('key'), d.get('key'))
        json.dump(r, open(os.path.join(out, lab.replace(':', '-') + '.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
        n += 1
print(n, 'results harvested to', out)
