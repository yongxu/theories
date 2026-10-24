"""Save a Claude coding workflow's output (one result per packet) into data/coded/claude/{pass}_{set}/.

    python3 -I fidelity/save_claude.py WORKFLOW_OUTPUT_JSON
"""
import json, sys
from pathlib import Path
HERE = Path(__file__).resolve().parent
out = json.load(open(sys.argv[1]))
if isinstance(out, dict):
    out = out.get('result', out)
n = 0
for x in out:
    if not x or not x.get('result'):
        print('MISSING', x and x.get('packet'))
        continue
    d = HERE / 'data/coded/claude' / Path(x['packet']).parent.name
    d.mkdir(parents=True, exist_ok=True)
    (d / Path(x['packet']).name).write_text(json.dumps(x['result'], ensure_ascii=False, indent=1))
    n += len(x['result']['segments'])
print(n, 'segments saved')
