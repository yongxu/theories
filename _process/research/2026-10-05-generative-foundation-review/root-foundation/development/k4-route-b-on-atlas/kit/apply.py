"""Apply K4's atlas plan (plan.json beside this file) to theories/becoming/results/atlas/entries/dynamics.json, run from
the checkout root: new dynamics placed after a named entry, extensions appended to existing entries. Refuses C and D.
Writes the file in its own format (indent 1, UTF-8, newline at the end)."""
import json
from pathlib import Path

ENTRIES = Path('theories/becoming/results/atlas/entries/dynamics.json')
plan = json.loads((Path(__file__).parent / 'plan.json').read_text())
src = ENTRIES.read_text(encoding='utf-8')
d = json.loads(src)
assert json.dumps(d, ensure_ascii=False, indent=1) + '\n' == src, 'format drifted'
by_id = {e['id']: e for e in d}
FIELDS = list(d[0].keys())
EXT = {'id', 'records', 'declarations', 'sources', 'hypotheses', 'exits', 'open', 'mechanism_append', 'beyond',
       'beyond_append', 'amend_exit'}

for ext in plan['extend']:
    assert set(ext) <= EXT, set(ext) - EXT
    e = by_id[ext['id']]
    assert e['family'] not in ('C', 'D'), ('C and D are step 2b', e['id'])
    for k in ('records', 'declarations', 'sources'):
        for v in ext.get(k, []):
            assert v not in e[k], (e['id'], k, v)
            e[k].append(v)
    for h in ext.get('hypotheses', []):
        assert h not in e['hypotheses'], (e['id'], h)
        e['hypotheses'].append(h)
    e['exits'].extend(ext.get('exits', []))
    e['open'].extend(ext.get('open', []))
    if 'mechanism_append' in ext:
        assert set(e['mechanism']) == {'en'}, 'a Chinese mechanism would go stale'
        e['mechanism']['en'] += ' ' + ext['mechanism_append']
    if 'beyond' in ext:
        assert e['beyond'] is None, e['id']
        e['beyond'] = ext['beyond']
    if 'beyond_append' in ext:
        assert set(e['beyond']) == {'en'}
        e['beyond']['en'] += ' ' + ext['beyond_append']
    if 'amend_exit' in ext:
        hit = [x for x in e['exits'] if x['law'] == ext['amend_exit']['law']]
        assert len(hit) == 1 and hit[0]['to'] is None, hit
        hit[0]['to'] = ext['amend_exit']['to']

for new in plan['new']:
    assert new['id'] not in by_id, new['id']
    assert new['family'] not in ('C', 'D'), new['id']
    assert set(new) == set(FIELDS) | {'after'}, set(new) ^ (set(FIELDS) | {'after'})
    entry = {k: new[k] for k in FIELDS}
    after = by_id[new['after']]
    assert after['family'] == new['family'], (new['id'], new['after'])
    d.insert(d.index(after) + 1, entry)
    by_id[entry['id']] = entry

ENTRIES.write_text(json.dumps(d, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('dynamics', len(d), '| new', len(plan['new']), '| extended', len(plan['extend']),
      '| exits added', sum(len(n['exits']) for n in plan['new']) + sum(len(x.get('exits', [])) for x in plan['extend']))
