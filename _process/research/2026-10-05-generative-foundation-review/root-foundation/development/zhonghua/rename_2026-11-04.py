"""A dated rename of the ZH passage map (board item RAE, 4 November 2026; AA Phase 0's E1 and E2).

passages.json has no build guard, so the renames that reached the spine after it was written are applied here, once:
- a record CD renamed (603ce1722, 3 November 2026; receipt _process/architecture/renames/cd-ranking-names.json):
  whole-first-and-bounded-centers -> whole-and-regions-and-bounded-centers, in the entries' `records`;
- a declaration ND renamed in OU7 (e5951932b, 1 November 2026; development/nd-nondual-names/part2/nd_rename.py):
  Pool.difference_belongs_to_the_joint -> Pool.difference_only_together, wherever the map names it (an entry's
  declarations and reading, a cluster's notes, a name flag's proposal).
Each entry changed is noted in `corrected`; the claims, kinds and readings' words do not change. Run once; a second
run finds nothing to change and refuses."""
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
P = HERE / 'passages.json'
OLD_REC, NEW_REC = 'whole-first-and-bounded-centers', 'whole-and-regions-and-bounded-centers'
OLD_DECL, NEW_DECL = 'Pool.difference_belongs_to_the_joint', 'Pool.difference_only_together'
NOTES = {
    'record': 'record ids follow the renamed records (cd-ranking-names, 3 November 2026), claims unchanged',
    'declaration': 'names follow the declaration ND renamed in OU7 (e5951932b, 1 November 2026), statement unchanged',
}


def sub(x):
    if isinstance(x, str):
        return x.replace(OLD_DECL, NEW_DECL)
    if isinstance(x, list):
        return [sub(v) for v in x]
    if isinstance(x, dict):
        return {k: sub(v) for k, v in x.items()}
    return x


def main():
    raw = P.read_text(encoding='utf-8')
    data = json.loads(raw)
    assert json.dumps(data, ensure_ascii=False, indent=1) == raw, 'passages.json is not in the form this script writes'
    counts = {'records': 0, 'declarations': 0, 'other': 0, 'entries': 0}
    for c, d in data['clusters'].items():
        for e in d['entries']:
            why = []
            if OLD_REC in e['records']:
                counts['records'] += e['records'].count(OLD_REC)
                e['records'] = [NEW_REC if r == OLD_REC else r for r in e['records']]
                why.append(NOTES['record'])
            before = json.dumps(e, ensure_ascii=False)
            counts['declarations'] += sum(x.count(OLD_DECL) for x in e['declarations'])
            new = sub(e)
            if json.dumps(new, ensure_ascii=False) != before:
                e.clear()
                e.update(new)
                why.append(NOTES['declaration'])
            if why:
                counts['entries'] += 1
                e['corrected'] = '; '.join(([e['corrected']] if e.get('corrected') else []) + why)
        for k in [k for k in d if k != 'entries']:
            s = json.dumps(d[k], ensure_ascii=False)
            if OLD_DECL in s:
                counts['other'] += s.count(OLD_DECL)
                d[k] = sub(d[k])
    left = json.dumps(data, ensure_ascii=False)
    if not counts['entries']:
        raise SystemExit('nothing to rename: already applied')
    assert OLD_DECL not in left and f'"{OLD_REC}"' not in left, 'an old name is left'
    P.write_text(json.dumps(data, ensure_ascii=False, indent=1), encoding='utf-8')
    print(json.dumps(counts))
    return 0


if __name__ == '__main__':
    sys.exit(main())
