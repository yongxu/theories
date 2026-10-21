"""Merge the naming pass (core judge and the verified group decisions) into one list: python3 -I work/merge_new_names.py

Reads agents/core-judge.json and agents/verify-G*.json (harvested from the naming workflow's journal), the current
table (names-decisions.tsv) and work/new-names-overrides.json (the integrator's decisions on conflicts, each with
its reason). Writes work/new-names.json: names to add to the table, concepts mapped onto existing names, and plain
wordings, and lists every conflict left: a new name that coincides, once simplified, with a table name or another
new name for a different concept; one concept given different names; a name with no anchor."""
import csv, glob, json, os, sys

H = os.path.dirname(os.path.abspath(__file__)); KIT = os.path.dirname(H)
sys.path.insert(0, H)
from simplify import simp

table = {r['名']: r for r in csv.DictReader(open(H + '/names-decisions.tsv', encoding='utf-8'), delimiter='\t')}
table_s = {simp(n): n for n in table}
ov = json.load(open(H + '/new-names-overrides.json', encoding='utf-8')) if os.path.exists(H + '/new-names-overrides.json') else {}
decs = []
for f in [KIT + '/agents/core-judge.json'] + sorted(glob.glob(KIT + '/agents/verify-G*.json')):
    src = os.path.basename(f)[:-5]
    for d in json.load(open(f, encoding='utf-8'))['decisions']:
        d = dict(d, source=src)
        o = ov.get(d['key'])
        if o:
            d.update(o, overridden=True)
        decs.append(d)
added, existing, plain, conflicts = {}, [], [], []
new_names = {d['name'].strip() for d in decs if d['decision'] == 'name'}
for d in decs:
    n = d['name'].strip()
    if d['decision'] == 'existing':
        if n not in table and simp(n) not in table_s and n not in new_names:
            conflicts.append({'key': d['key'], 'why': 'existing name %s not in the table' % n})
        existing.append(d)
    elif d['decision'] == 'plain':
        plain.append(d)
    else:
        if simp(n) in table_s:
            conflicts.append({'key': d['key'], 'why': '%s coincides with the table name %s' % (n, table_s[simp(n)])})
            continue
        if not d['anchor'].strip() or d['anchor'].strip() == '—':
            conflicts.append({'key': d['key'], 'why': '%s has no anchor' % n})
        prev = added.get(n) or next((a for a in added.values() if simp(a['name']) == simp(n)), None)
        if prev and prev['concept'].split('(')[0].strip().lower() != d['concept'].split('(')[0].strip().lower():
            conflicts.append({'key': d['key'], 'why': '%s also names %s (%s)' % (n, prev['key'], prev['concept'][:40])})
        added.setdefault(n, d)
by_key = {}
for d in decs:
    by_key.setdefault(d['key'], set()).add((d['decision'], d['name'] or d['plain']))
for k, v in by_key.items():
    if len(v) > 1 and len({x[1] for x in v}) > 1:
        conflicts.append({'key': k, 'why': 'decided twice: %s' % sorted(v)})
json.dump({'added': list(added.values()), 'existing': existing, 'plain': plain, 'conflicts': conflicts},
          open(H + '/new-names.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
print('%d decisions: %d names to add, %d existing, %d plain; %d conflicts'
      % (len(decs), len(added), len(existing), len(plain), len(conflicts)))
for c in conflicts:
    print('  CONFLICT', c['key'], c['why'])
