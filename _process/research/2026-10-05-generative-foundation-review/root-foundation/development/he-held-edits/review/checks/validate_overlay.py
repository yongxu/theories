"""Run the repository's own record validation (tools/research/registry.validate) on every record, with the
records and files of an overlay copy taking precedence over the scratch tree. Read-only on both trees."""
import json, sys
from pathlib import Path
BASE, OVER = Path(sys.argv[1]).resolve(), Path(sys.argv[2]).resolve()
ids = set(sys.argv[3:])
sys.path.insert(0, str(BASE))
sys.dont_write_bytecode = True
from tools.research import registry
def path_in_repo(value):
    if not isinstance(value, str) or not value or Path(value).is_absolute():
        return None
    for root in (OVER, BASE):
        p = (root / value).resolve()
        if p.is_relative_to(root) and p.is_file():
            return p
    return None
registry.path_in_repo = path_in_repo
orig_receipt = registry.Sources.receipt
def receipt(self, path):
    if path not in self.receipts:
        q = OVER / path
        self.receipts[path] = json.loads((q if q.is_file() else BASE / path).read_text())
    return self.receipts[path]
registry.Sources.receipt = receipt
records = []
for f in sorted((BASE / 'theories/becoming/results/records').glob('*.json')):
    o = OVER / 'theories/becoming/results/records' / f.name
    records.append(json.loads((o if o.is_file() else f).read_text()))
errors, drift = registry.validate(records)[:2] if isinstance(registry.validate(records), tuple) else (registry.validate(records), [])
mine = [e for e in errors if e.split(':')[0] in ids]
print('errors in the named records:', len(mine))
for e in mine: print('  ', e[:400])
print('errors elsewhere:', len([e for e in errors if e.split(':')[0] not in ids]))
