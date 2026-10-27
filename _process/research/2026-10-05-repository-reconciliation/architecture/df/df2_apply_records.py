#!/usr/bin/env python3
"""DF2: apply the four reviewers' edits to the 30 records the drafters wrote (reports/df2-review-*.json). Run once
from the checkout root: python3 -B <kit>/df2_apply_records.py.

Each edit names a record, a field path (`statement.en`, `laws[2].en`, `related[1].detail.zh`, `laws[2].declarations`,
several joined by " and "), the old text and the new. A string field has the old text replaced by the new, the old
asserted to occur once (an empty old sets the field). A list field (declarations, aliases) takes the names the new
text adds beside the old and drops those it leaves out. Edits to the drafters' proposed chapter edits, to chapters, or
whose old text is not found are not applied here: they are written to reports/df2-pending.json, with the reason, for
the lander, who applies them with the chapter edits after main is merged. Every outcome goes to reports/df2-applied.json."""
import json
import re
from pathlib import Path

ROOT = Path.cwd()
KIT = Path(__file__).resolve().parent
REC = ROOT / 'theories/becoming/results/records'
DRAFTED = {r['id'] for u in 'ABCD' for r in json.loads((KIT / f'reports/df2-draft-{u}.json').read_text())['records']}
PATH = re.compile(r'^[a-z_]+(\[\d+\])?(\.[a-z_]+(\[\d+\])?)*$')


def walk(d, field):
    obj = d
    parts = re.findall(r'[a-z_]+|\[\d+\]', field)
    for p in parts[:-1]:
        obj = obj[int(p[1:-1])] if p.startswith('[') else obj[p]
    last = parts[-1]
    return obj, (int(last[1:-1]) if last.startswith('[') else last)


def names(s):
    return [x.strip().strip('`') for x in re.split(r',\s*', s or '') if x.strip()]


applied, pending = [], []
for u in 'ABCD':
    for i, e in enumerate(json.loads((KIT / f'reports/df2-review-{u}.json').read_text())['edits']):
        tag = f'{u}{i}'
        rid, field = e['id'], e['field']
        fields = [f.strip() for f in field.split(' and ')]
        if rid not in DRAFTED or not all(PATH.match(f) for f in fields) or field.startswith(('chapter_edits', 'anchor_before')):
            pending.append({'tag': tag, 'why': 'not a record field', **e})
            continue
        p = REC / f'{rid}.json'
        d = json.loads(p.read_text(encoding='utf-8'))
        ok, why = True, ''
        for f in fields:
            try:
                obj, key = walk(d, f)
                cur = obj[key]
            except (KeyError, IndexError, TypeError) as x:
                ok, why = False, f'no field {f}: {x!r}'
                break
            if isinstance(cur, list) and not all(isinstance(x, str) for x in cur):
                ok, why = False, f'{f}: a list of objects, not of names'
                break
            if isinstance(cur, list):
                old, new = names(e.get('old')), names(e.get('new'))
                have = [x for x in cur]
                def find(n):
                    return [x for x in have if x == n or x.endswith('.' + n) or n.endswith('.' + x)]
                if not all(find(n) for n in old):
                    ok, why = False, f'{f}: an old name is not in the list'
                    break
                prefix = 'Becoming.' if have and all(x.startswith('Becoming.') for x in have) else ''
                for n in old:
                    if n not in new:
                        for x in find(n):
                            have.remove(x)
                for n in new:
                    if not find(n):
                        have.append(n if n.startswith('Becoming.') or not prefix else prefix + n)
                obj[key] = have
            elif isinstance(cur, str) or cur is None:
                old = e.get('old') or ''
                if not old:
                    obj[key] = e['new']
                elif (cur or '').count(old) == 1:
                    obj[key] = cur.replace(old, e['new'])
                else:
                    ok, why = False, f'{f}: old text occurs {(cur or "").count(old)} times'
                    break
            else:
                ok, why = False, f'{f}: not a string or list'
                break
        if ok:
            p.write_text(json.dumps(d, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
            applied.append({'tag': tag, 'id': rid, 'field': field, 'severity': e['severity']})
        else:
            pending.append({'tag': tag, 'why': why, **e})

(KIT / 'reports/df2-applied.json').write_text(json.dumps(applied, indent=1, ensure_ascii=False) + '\n', encoding='utf-8')
(KIT / 'reports/df2-pending.json').write_text(json.dumps(pending, indent=1, ensure_ascii=False) + '\n', encoding='utf-8')
print('applied', len(applied), 'pending', len(pending))
for x in pending:
    print(' ', x['tag'], x['id'], '|', x['field'][:60], '|', x['why'])
