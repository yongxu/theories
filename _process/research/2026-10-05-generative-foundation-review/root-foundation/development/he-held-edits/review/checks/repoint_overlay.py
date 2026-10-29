"""Apply tools/research/repoint.repoint_record (the landing's re-point with --receipt and --lean) to records of the
overlay copy, reading current bytes overlay-first. Writes only into the overlay copy."""
import json, sys, hashlib
from pathlib import Path
BASE, OVER = Path(sys.argv[1]).resolve(), Path(sys.argv[2]).resolve()
receipt = sys.argv[3]
lean = sys.argv[4].split(',')
ids = sys.argv[5:]
sys.path.insert(0, str(BASE)); sys.dont_write_bytecode = True
from tools.research import repoint
def current(p):
    for root in (OVER, BASE):
        q = root / p
        if q.is_file():
            return hashlib.sha256(q.read_bytes()).hexdigest()
    return None
data = json.loads((OVER / receipt).read_text())
for rid in ids:
    f = OVER / 'theories/becoming/results/records' / f'{rid}.json'
    if not f.is_file():
        f.parent.mkdir(parents=True, exist_ok=True)
        f.write_text((BASE / 'theories/becoming/results/records' / f'{rid}.json').read_text())
    d = json.loads(f.read_text())
    touched, rebound = repoint.repoint_record(d, current, None, receipt, lean, data)
    f.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
    print(rid, 'rebound', [x.split('/')[-1] for x in rebound], 'touched', len(touched))
