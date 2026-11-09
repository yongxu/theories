#!/usr/bin/env python3
"""WB: "the second-order direction of 生生" re-said as the second-order direction of widening.

The phrase names a comparison of a range whose widening keeps widening with one merely wider now. Since 9 November
2026 生生 is the continuation of life, and the glossary says widening is not 生生's measure; the comparison is
widening's, a formal open question. Re-said in the homes (07, COLLECTIVE-DIRECTION), in the records' current fields
(history entries are left as written; a record changed here gets a history note unless it has WB's already), and in
the crosswalk's quotations of them. No claim, hypothesis or Lean changes."""
import json
import pathlib
import re
import sys

ROOT = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else '.')
EN = [("the second-order direction of 生生", "the second-order direction of widening"),
      ("The second-order direction of 生生", "The second-order direction of widening"),
      ("the direction of 生生 is read separately, by widening what can form (D1)", "生生, the continuation of life, is read separately (D1)"),
      ("the direction of 生生 being read separately (D1)", "生生, the continuation of life, being read separately (D1)"),
      ("widening compares the direction of 生生, which is generation generating generation (D1, D22)",
       "widening compares what can form; 生生 is read since 9 November 2026 as the continuation of life, not as widening (D1)"),
      ("That growth relative to what is held is better or is the direction of 生生:", "That growth relative to what is held is better or is what 生生 asks:")]
ZH = [("生生的二阶方向", "扩大的二阶方向"), ("即生生之方向", "即生生之所求")]
NOTE = {"en": "9 November 2026, board item WB: 'the second-order direction of 生生' re-said as the second-order direction of widening, since 生生 is read as the continuation of life and widening is not its measure; no change to the claim, its hypotheses or its Lean.",
        "zh": "2026 年 11 月 9 日，工作板条目 WB：「生生的二阶方向」改说为扩大的二阶方向，因生生读作生命之延续，扩大不是它的尺度；主张、假设与 Lean 皆不变。"}


def esc(s):
    return json.dumps(s, ensure_ascii=False)[1:-1]


def text(path, pairs):
    p = ROOT / path
    s = p.read_text(encoding='utf-8')
    n = 0
    for a, b in pairs:
        n += s.count(a)
        s = s.replace(a, b)
    p.write_text(s, encoding='utf-8')
    return n


for f in ['theories/becoming/chapters/07-SIGNIFICANCE.md', 'theories/becoming/COLLECTIVE-DIRECTION.md']:
    print(f, text(f, EN + ZH))

for f in sorted((ROOT / 'theories/becoming/results/records').glob('*.json')):
    raw = f.read_text(encoding='utf-8')
    d = json.loads(raw)
    found = []

    def walk(o, path):
        if isinstance(o, dict):
            for k, v in o.items():
                walk(v, path + [k])
        elif isinstance(o, list):
            for v in o:
                walk(v, path + ['[]'])
        elif isinstance(o, str) and 'history' not in path and 'text_versions' not in path:
            if any(a in o for a, _ in EN + ZH):
                found.append(o)
    walk(d, [])
    if not found:
        continue
    for o in set(found):
        new = o
        for a, b in EN + ZH:
            new = new.replace(a, b)
        k = esc(o)
        if raw.count(k) != 1:
            raise SystemExit(f'{f.name}: {raw.count(k)} copies of a field')
        raw = raw.replace(k, esc(new))
    d = json.loads(raw)
    if not any('second-order direction of widening' in h.get('en', '') for h in d.get('history', [])):
        # append the note as the last history entry, in the file's own layout
        d['history'].append(NOTE)
        indent = 2 if '\n  "' in raw[:200] else 1
        raw = json.dumps(d, ensure_ascii=False, indent=indent) + '\n'
    json.loads(raw)
    f.write_text(raw, encoding='utf-8')
    print(f.name, len(set(found)))

cw = ROOT / 'theories/becoming/results/atlas/entries/correspondences.json'
s = cw.read_text(encoding='utf-8')
n = 0
for a, b in EN + ZH:
    n += s.count(esc(a))
    s = s.replace(esc(a), esc(b))
json.loads(s)
cw.write_text(s, encoding='utf-8')
print('crosswalk', n)
