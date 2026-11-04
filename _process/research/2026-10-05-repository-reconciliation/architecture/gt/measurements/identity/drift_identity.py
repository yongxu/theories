"""Identity of the drift comparison cache: for every (record, source) pair whose bytes differ from
the reviewed hash, as registry.validate finds them, compare the original registry.py (copied aside
before the change) with the changed one, cold (empty cache directory) and warm (same directory, the
in-process memo cleared, difflib forbidden so every warm answer must come from the cache).

usage: python3 -B drift_identity.py <worktree> <original registry.py> <scratch dir>
"""
import difflib
import importlib.util
import json
import sys
import tempfile
import time
from pathlib import Path

worktree, original, scratch = Path(sys.argv[1]), Path(sys.argv[2]), Path(sys.argv[3])
sys.path.insert(0, str(worktree))
from tools.research import registry as new  # noqa: E402

spec = importlib.util.spec_from_file_location('registry_original', original)
old = importlib.util.module_from_spec(spec)
spec.loader.exec_module(old)
old.ROOT, old.OUT, old.RECORDS = new.ROOT, new.OUT, new.RECORDS
assert new.ROOT == worktree.resolve(), (new.ROOT, worktree)

records, errors = new.load_records()
pairs = []  # (record, path, expected, p), as registry.validate reaches scoped_drift
for r in records:
    for ref in r.get('references', []):
        path, expected = ref.get('path'), ref.get('sha256', '')
        p = new.path_in_repo(path)
        if p is None or not new.SHA256.fullmatch(expected):
            continue
        if new.digest(p) != expected:
            pairs.append((r, path, expected, p))
compared = sorted({(path, expected) for r, path, expected, p in pairs if path.endswith('.md')})
print(f'records {len(records)}, drifted (record, source) pairs {len(pairs)}, '
      f'Markdown pairs {sum(path.endswith(".md") for _, path, _, _ in pairs)}, distinct (source, reviewed hash) comparisons {len(compared)}')


def run(module):
    t = time.perf_counter()
    lines = {key: module.changed_lines(key[0], key[1], (new.ROOT / key[0]).read_text()) for key in compared}
    drift = [module.scoped_drift(r, path, expected, p) for r, path, expected, p in pairs]
    return lines, drift, time.perf_counter() - t


base_lines, base_drift, t_old = run(old)
print(f'original: {t_old:.1f} s; comparisons not in history: {sum(v is None for v in base_lines.values())}')

with tempfile.TemporaryDirectory(dir=scratch) as d:
    new.DRIFT_CACHE = Path(d) / 'cache'
    new._comparisons.clear()
    cold_lines, cold_drift, t_cold = run(new)
    entries = sorted((new.DRIFT_CACHE / new.DRIFT_VERSION).glob('*.json'))
    print(f'cold: {t_cold:.1f} s; cache entries written {len(entries)}, bytes {sum(e.stat().st_size for e in entries)}')

    new._comparisons.clear()
    real = difflib.SequenceMatcher.get_opcodes
    def forbidden(self):
        raise AssertionError('warm run recomputed a comparison')
    difflib.SequenceMatcher.get_opcodes = forbidden
    try:
        warm_lines, warm_drift, t_warm = run(new)
    finally:
        difflib.SequenceMatcher.get_opcodes = real
    print(f'warm: {t_warm:.1f} s (difflib forbidden)')

for name, lines, drift in (('cold', cold_lines, cold_drift), ('warm', warm_lines, warm_drift)):
    for key in compared:
        if lines[key] != base_lines[key]:
            raise SystemExit(f'{name}: changed_lines differs first at {key}')
    for (r, path, expected, _), a, b in zip(pairs, base_drift, drift):
        if a != b:
            raise SystemExit(f'{name}: scoped_drift differs first at {r["id"]} {path}: {a!r} != {b!r}')
    print(f'{name}: changed_lines equal for {len(compared)} of {len(compared)}, scoped_drift equal for {len(pairs)} of {len(pairs)}')
nonempty = sum(1 for v in base_lines.values() if v)
spans = sum(len(v) for v in base_lines.values() if v)
bearing = sum(1 for v in base_drift if v)
print(f'non-empty comparisons {nonempty}, spans {spans}; pairs with bearing changes {bearing}, without {len(pairs) - bearing}')
json.dump({'pairs': len(pairs), 'compared': len(compared), 't_original': t_old, 't_cold': t_cold, 't_warm': t_warm},
          open(scratch / 'drift_identity.json', 'w'))
