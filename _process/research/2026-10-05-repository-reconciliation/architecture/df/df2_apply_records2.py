#!/usr/bin/env python3
"""DF2: the reviewers' record edits df2_apply_records.py could not place by its field paths (both editions in one
edit, lists of objects), applied as the reviewers wrote them: C26, C46, D9, D26, D27, D28, D29, D34, D42. Run once
from the checkout root, after df2_apply_records.py. (A42 and C30 change anchor texts, which the chapter step takes.)"""
import json
from pathlib import Path

REC = Path.cwd() / 'theories/becoming/results/records'
KIT = Path(__file__).resolve().parent
P = {x['tag']: x for x in json.loads((KIT / 'reports/df2-pending.json').read_text())}


def edit(rid, fn):
    p = REC / f'{rid}.json'
    d = json.loads(p.read_text(encoding='utf-8'))
    fn(d)
    p.write_text(json.dumps(d, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')


def sub(obj, key, old, new):
    assert obj[key].count(old) == 1, (key, old, obj[key])
    obj[key] = obj[key].replace(old, new)


def both(obj, tag):
    """An edit written 'en | zh': replace each edition's old text by its new."""
    (oe, oz), (ne, nz) = (s.split(' | ') for s in (P[tag]['old'], P[tag]['new']))
    sub(obj, 'en', oe, ne)
    sub(obj, 'zh', oz, nz)


def c26(d):
    assert d['dependencies'] == []
    d['dependencies'] = json.loads(P['C26']['new'])


edit('reviewers-count-by-independent-causes', c26)


def c46(d):
    assert len(d['does_not_show']) == 4
    d['does_not_show'].append(json.loads(P['C46']['new']))


edit('significance-through-a-common-condition', c46)


def related(tag):
    def fn(d):
        x = json.loads(P[tag]['new'].removeprefix('append ').strip())
        assert x['id'] not in [r['id'] for r in d['related']]
        d['related'].append(x)
    return fn


edit('reach-from-a-seed', related('D9'))
edit('type-formation-gives-no-dynamics', related('D29'))


def d26(d):
    a = d['aliases']
    for old, new in [('type formation gives no distinction and no dynamics',
                      'type formation keeps the seed\'s boundary and gives no dynamics'),
                     ('类型构造不给出区分与动力学', '类型构造保持种子之界而不给出动力学')]:
        assert a.count(old) == 1
        a[a.index(old)] = new
    both(d['correspondence'], 'D27')
    both(d['hypotheses'][0], 'D28')


edit('type-formation-gives-no-dynamics', d26)
edit('contraction-where-duplication-is-reachable', lambda d: both(d['hypotheses'][2], 'D34'))
edit('self-reference-does-not-certify-itself', lambda d: both(d['hypotheses'][0], 'D42'))
print('df2_apply_records2: applied C26, C46, D9, D26, D27, D28, D29, D34, D42')
