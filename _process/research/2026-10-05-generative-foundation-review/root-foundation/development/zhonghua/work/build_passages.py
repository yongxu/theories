"""Build passages.json: mapper entries + reviser changes + checker corrections, per cluster.
Accounts for every primary-flagged judgment (entry, parallel or rejected) and resolves Lean names on main."""
import json, os, sys, collections
HERE = os.path.dirname(os.path.abspath(__file__)); KIT = os.path.dirname(HERE); A = KIT + '/agents'
sys.path.insert(0, HERE)
from resolve import resolve_decl, resolve_record, DECLS, receipt, lst
cov = json.load(open(KIT + '/coverage.json'))['verdicts']
mods = {m['module'] for m in json.load(open(receipt))['modules']}
# integrator fixes, each with its reason
FIXES = {'C11': [{'do': 'parallel', 'record_id': 'LAO2-C36-R03', 'entry': 'lao-36-jiang-yu-xi-zhi',
                  'why': '同章「将欲……必固……」四式之一（将欲废之，必固兴之），结构与本条相同；检查者以 R08 替换了它，R08 归 C10'}]}
out, report = {'clusters': {}}, collections.OrderedDict()
import re
ALL_IDS = {}
for j in range(1, 18):
    cc = 'C%02d' % j
    ALL_IDS[cc] = {e['id'] for e in json.load(open('%s/map-%s.json' % (A, cc)))['entries']} | {e['id'] for e in json.load(open('%s/revise-%s.json' % (A, cc)))['revised']}
def cross(t):
    mm = re.match(r'(C\d\d)\s*[:/：]\s*(.+)$', t)
    return bool(mm and mm.group(2).strip() in ALL_IDS.get(mm.group(1), ()))
for i in range(1, 18):
    c = 'C%02d' % i
    m = json.load(open('%s/map-%s.json' % (A, c)))
    rv = json.load(open('%s/revise-%s.json' % (A, c)))
    ck = json.load(open('%s/check-%s.json' % (A, c)))
    ent = collections.OrderedDict((e['id'], dict(e, status='mapped')) for e in m['entries'])
    for k in rv['kept']:
        if k['id'] in ent: ent[k['id']]['names_used'] = k['names_used']; ent[k['id']]['status'] = 'kept'
    for e in rv['revised']:
        ent[e['id']] = e
    dropped = {d['id']: d for d in rv['dropped']}
    for d in ck['drops']: dropped[d['id']] = {'id': d['id'], 'why': d['why'], 'now': 'dropped by the checker'}
    for e in ck['corrections']:
        ent[e['id']] = dict(e, checked='corrected')
    for p in ck['passed']:
        if p in ent: ent[p]['checked'] = 'passed'
    dropped_recs = {}
    for d in dropped:
        old = ent.pop(d, None) or next((e for e in rv['revised'] + m['entries'] if e['id'] == d), None)
        for r in lst((old or {}).get('record_ids')): dropped_recs[r] = d
    unacc = [i for i, e in ent.items() if e.get('status') == 'mapped']
    # declarations and records on current main
    bad_d, ren_d, bad_r = [], 0, []
    for e in ent.values():
        ds = []
        for d in lst(e.get('declarations')):
            cur, path = resolve_decl(d)
            if not cur:
                mm = d if d.startswith('Becoming.') else 'Becoming.' + d
                if mm in mods: ds.append(mm); continue
                bad_d.append((e['id'], d)); continue
            ren_d += bool(path); ds.append(cur)
        e['declarations'] = ds
        rs = []
        for r in lst(e.get('records')):
            cur = resolve_record(r)
            if cur: rs.append(cur)
            else: bad_r.append((e['id'], r))
        e['records'] = rs
        e['record_ids'] = lst(e.get('record_ids'))
    par = {p['record_id']: p for p in m['parallels']}; rej = {r['record_id']: r for r in m['rejected']}
    for ch in rv['candidate_changes']:
        rid = ch['record_id']; par.pop(rid, None); rej.pop(rid, None)
        if ch['now'] == 'parallel': par[rid] = {'record_id': rid, 'same_as_entry': ch.get('same_as_entry', ''), 'note': ch['why']}
        elif ch['now'] == 'rejected': rej[rid] = {'record_id': rid, 'why': ch['why']}
    for fx in FIXES.get(c, []):
        if fx['do'] == 'parallel':
            par[fx['record_id']] = {'record_id': fx['record_id'], 'same_as_entry': fx['entry'], 'note': fx['why'], 'by': 'integrator'}
    in_entries = {r for e in ent.values() for r in e['record_ids']}
    for r, d in dropped_recs.items():
        if r not in in_entries and r not in par and r not in rej and cov.get(r, {}).get('c') == c:
            rej[r] = {'record_id': r, 'why': 'its entry %s was dropped: %s' % (d, dropped[d]['why'])}
    for rid, v in list(par.items()):
        t = v.get('same_as_entry', '')
        if t and t not in ent and t in dropped:
            par.pop(rid); rej[rid] = {'record_id': rid, 'why': 'parallel of the dropped entry %s: %s' % (t, dropped[t]['why'])}
    # parallels pointing at a dropped entry
    orphan = [p for p, v in par.items() if v.get('same_as_entry') and v['same_as_entry'] not in ent and not cross(v['same_as_entry'])]
    prim = [r for r, v in cov.items() if v['c'] == c]
    places = collections.Counter()
    unplaced = []
    for r in prim:
        n = (r in in_entries) + (r in par) + (r in rej)
        places[n] += 1
        if n == 0: unplaced.append(r)
    kinds = collections.Counter(e['kind'] for e in ent.values())
    out['clusters'][c] = {'entries': list(ent.values()), 'parallels': list(par.values()), 'rejected': list(rej.values()),
                          'dropped': list(dropped.values()), 'name_flags': rv['name_flags'], 'notes': rv['notes'], 'check_notes': ck['notes']}
    report[c] = dict(entries=len(ent), kinds=dict(kinds), unaccounted=len(unacc), bad_decl=len(bad_d), renamed=ren_d, bad_rec=len(bad_r),
                     primary=len(prim), placed_once=places[1], multi=sum(v for k, v in places.items() if k > 1), unplaced=len(unplaced), orphan_par=len(orphan))
    if '-v' in sys.argv:
        for x in bad_d[:6]: print('  ', c, 'decl', x)
        for x in bad_r[:6]: print('  ', c, 'rec', x)
        print('  ', c, 'unplaced', unplaced[:8], 'orphan', orphan[:4])
json.dump(out, open(KIT + '/passages.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
for c, r in report.items(): print(c, r)
tot = collections.Counter()
for r in report.values():
    for k in ('entries', 'unaccounted', 'bad_decl', 'bad_rec', 'primary', 'placed_once', 'multi', 'unplaced', 'orphan_par'): tot[k] += r[k]
    for k, v in r['kinds'].items(): tot[k] += v
print(dict(tot))
