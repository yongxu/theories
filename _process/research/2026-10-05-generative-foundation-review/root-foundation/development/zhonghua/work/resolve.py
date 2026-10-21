"""Resolve Lean names and record ids cited by the mappers against current main (read-only).

Loads every rename table on main, follows renames in chains, and checks the result against the
newest core receipt's audited declarations and the live record ids. Usage:
    python3 -I work/resolve.py            # summary + unresolved
    from resolve import resolve_decl, resolve_record
"""
import glob, json, os, re
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..', '..', '..', '..', '..'))
DEV = os.path.join(ROOT, '_process/research/2026-10-05-generative-foundation-review/root-foundation/development')
PKG = os.path.join(ROOT, 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming')
receipt = max(glob.glob(PKG + '/becoming-checks/*/verification.json'))
DECLS = {d['name'] for m in json.load(open(receipt))['modules'] for d in m['declarations']}
RECORDS = {os.path.basename(p)[:-5] for p in glob.glob(ROOT + '/theories/becoming/results/records/*.json')}
REN = {}
def add(o, n):
    if o and n and o != n: REN.setdefault(o, n)
for f in glob.glob(DEV + '/*/RENAME-TABLE.json') + glob.glob(DEV + '/*/*/RENAME-TABLE.json'):
    d = json.load(open(f))
    for k in ('declarations', 'modules'):
        for o, n in (d.get(k) or {}).items(): add(o, n)
    for k in ('renamed', 'removed'):
        for r in d.get(k) or []:
            add(r.get('old'), r.get('new') or r.get('kept'))
for r in json.load(open(DEV + '/r32-folds/removals.json'))['rows']:
    add(r['old'], r['new'])
for f in glob.glob(ROOT + '/_process/architecture/renames/*.json'):
    for r in json.load(open(f)).get('renames', []): add(r['old'], r['new'])
f = os.path.join(ROOT, '_process/architecture/rename-2026-10-09.json')
if os.path.exists(f):
    d = json.load(open(f))
    for r in (d if isinstance(d, list) else d.get('renames', d.get('rows', []))):
        if isinstance(r, dict): add(r.get('old'), r.get('new'))

def full(n):
    n = n.strip().strip('`')
    return n if n.startswith('Becoming.') or n in DECLS else 'Becoming.' + n

def resolve_decl(n):
    """(current name or None, path of renames)"""
    x, path = full(n), []
    for _ in range(12):
        if x in DECLS: return x, path
        if x in REN: path.append(x); x = REN[x]; continue
        # a renamed namespace prefix
        parts = x.split('.')
        for i in range(len(parts) - 1, 1, -1):
            pre = '.'.join(parts[:i])
            if pre in REN:
                path.append(x); x = REN[pre] + '.' + '.'.join(parts[i:]); break
        else:
            return None, path
    return None, path

def resolve_record(r):
    x = r
    for _ in range(8):
        if x in RECORDS: return x
        if x in REN: x = REN[x]; continue
        return None
    return None

def lst(v):
    if isinstance(v, list): return v
    if not v: return []
    try: return json.loads(v.replace("'", '"'))
    except Exception: return re.findall(r"[\w.'₀-₉]+", v)

if __name__ == '__main__':
    import sys
    if len(sys.argv) > 1:
        for a in sys.argv[1:]:
            cur, path = resolve_decl(a)
            rec = resolve_record(a)
            print(a, '->', cur or (('record ' + rec) if rec else 'NONE'), ('(renamed via ' + ' > '.join(path) + ')') if path else '')
        sys.exit(0)
    cited, recs = {}, {}
    for f in sorted(glob.glob(HERE + '/../agents/map-C*.json')):
        m = json.load(open(f)); c = os.path.basename(f)[4:7]
        for n in m['names']:
            for x in lst(n.get('lean')): cited.setdefault(x, set()).add(c)
        for e in m['entries']:
            for x in lst(e.get('declarations')): cited.setdefault(x, set()).add(c)
            for x in lst(e.get('records')): recs.setdefault(x, set()).add(c)
    ok = ren = bad = 0; unresolved = []
    for x in sorted(cited):
        cur, path = resolve_decl(x)
        if cur and not path: ok += 1
        elif cur: ren += 1
        else: bad += 1; unresolved.append(x)
    rb = [r for r in recs if not resolve_record(r)]
    rr = [r for r in recs if resolve_record(r) and resolve_record(r) != r]
    print('receipt', os.path.basename(os.path.dirname(receipt)), len(DECLS), 'decls;', len(REN), 'renames')
    print('declarations cited', len(cited), 'current', ok, 'renamed', ren, 'unresolved', bad)
    print('records cited', len(recs), 'renamed', len(rr), 'unresolved', len(rb))
    print('UNRESOLVED DECLS:', ' '.join(unresolved))
    print('UNRESOLVED RECORDS:', ' '.join(rb))
