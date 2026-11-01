#!/usr/bin/env python3
"""BD4: after an edit of the leaf on the branch, write the leaf's digest into the one reference of
balance-from-conservation-along-a-relation that names it, so that reland_bd4.py's check (the receipt checked the
very leaf the record names) holds. Nothing else in the record changes; it must round-trip byte for byte.
usage (from the checkout root of the worktree): python3 -B <kit>/sha_bd4.py"""
import hashlib
import json
from pathlib import Path

PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
LEAF = f'{PKG}/Becoming/BalanceRegions.lean'
REC = Path('theories/becoming/results/records/balance-from-conservation-along-a-relation.json')
text = REC.read_text(encoding='utf-8')
d = json.loads(text)
assert json.dumps(d, ensure_ascii=False, indent=2) + '\n' == text, 'the record does not round-trip'
named = [x for x in d['references'] if x['path'] == LEAF]
assert len(named) == 1, named
digest = hashlib.sha256(Path(LEAF).read_bytes()).hexdigest()
old = named[0]['sha256']
named[0]['sha256'] = digest
REC.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('sha:', old[:12], '->', digest[:12], '(unchanged)' if old == digest else '')
