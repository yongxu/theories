# Fills the lake code of parsed rows from aliases.csv, where a row has none: names a lake was renamed from, spelt otherwise
# or joined to its L by the OCR. No value of any record. Usage: aliases_apply.py ALIASES.csv LIST.json ...
import collections, csv, json, sys
al = {(r['County'], r['Name as parsed']): r['WBIC'] for r in csv.DictReader(open(sys.argv[1], newline=''))}
for path in sys.argv[2:]:
    d = json.load(open(path))
    n = collections.Counter()
    for t in d:
        if not t.get('wbic'):
            w = al.get((t['county'], t['norm']))
            if w:
                t['wbic'] = w
                n[t.get('kind', 'spring')] += 1
    json.dump(d, open(path, 'w'))
    print(path.rsplit('/', 1)[-1], 'rows', len(d), 'filled', dict(n), 'still with no code', sum(1 for t in d if not t.get('wbic')))
