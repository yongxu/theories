#!/usr/bin/env python3
"""DF3 batch B: the review edits that replace a whole does-not-show or hypothesis item, given as a JSON object (with or
without its braces); df3b_apply.py reports them as failures. Each object's keys replace the item's, and the record's
history note names the field."""
import json, re, sys
from pathlib import Path
RECORDS = Path('theories/becoming/results/records')
EN = {'does_not_show': 'does-not-show items', 'hypotheses': 'hypotheses'}
ZH = {'does_not_show': '“未表明”各项', 'hypotheses': '前提'}
res = json.loads(Path(sys.argv[1]).read_text())
for x in res:
    if not x or not x.get('review'):
        continue
    for e in x['review']['edits']:
        m = re.fullmatch(r'(does_not_show|hypotheses)\[(\d+)\]', e['field'])
        if not m or e['id'].endswith('.md'):
            continue
        p = RECORDS / f"{e['id']}.json"
        d = json.loads(p.read_text())
        key, k = m.group(1), int(m.group(2))
        new = e['new'].strip()
        obj = json.loads(new if new.startswith('{') else '{' + new + '}')
        old = e['old'].strip()
        try:
            oldobj = json.loads(old if old.startswith('{') else '{' + old + '}')
        except ValueError:
            oldobj = None  # cut short in the report; the item is compared by the keys the new object keeps
        cur = d[key][k]
        if oldobj is not None:
            assert all(cur.get(a) == b for a, b in oldobj.items()), (e['id'], e['field'])
        cur.update(obj)
        h = d['history'][-1]
        if EN[key] not in h['en']:
            h['en'] = re.sub(r'(The migration\'s skeptical review was taken in )', r'\1' + EN[key] + ', ', h['en']) if 'skeptical review was taken in' in h['en'] else h['en'].rstrip() + f" The migration's skeptical review was taken in {EN[key]}, each read against the Lean it cites."
            h['zh'] = h['zh'].replace('迁移的审查意见已采纳，涉及', '迁移的审查意见已采纳，涉及' + ZH[key] + '、', 1) if '迁移的审查意见已采纳，涉及' in h['zh'] else h['zh'].rstrip() + f'迁移的审查意见已采纳，涉及{ZH[key]}，各条对照所引 Lean 核读。'
        p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
        print('applied', e['id'], e['field'])
