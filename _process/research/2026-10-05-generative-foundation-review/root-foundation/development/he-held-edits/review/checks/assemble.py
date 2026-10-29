"""Assemble an olean tree for a receipt from the shared step cache (read-only on the cache)."""
import json, shutil, sys, hashlib
from pathlib import Path
receipt_path, out = Path(sys.argv[1]), Path(sys.argv[2])
r = json.loads(receipt_path.read_text())
cache = Path(r['lean_steps']['cache'])
keys = r['lean_steps']['keys']
missing = []
n = 0
for name in r['compile_order']:
    key = keys.get(name + '.log')
    if key is None:
        missing.append((name, 'no key')); continue
    rel = name.replace('.', '/') + '.olean'
    src = cache / key / Path(rel).name
    entry = json.loads((cache / (key + '.json')).read_text())
    blob = src.read_bytes()
    if hashlib.sha256(blob).hexdigest() != entry['outputs'][0]:
        missing.append((name, 'digest mismatch')); continue
    dst = out / rel
    dst.parent.mkdir(parents=True, exist_ok=True)
    dst.write_bytes(blob)
    n += 1
print(r['utc'], 'modules', len(r['compile_order']), 'assembled', n, 'missing', missing)
