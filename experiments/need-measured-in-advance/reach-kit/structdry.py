# T1N's frozen rules on the real grid: the lakes, years of estimates and fall surveys, labels and stocking years as published
# (R1 with GLIFWC's spring lake-years, the fall tables), the values simulated by T1N's worlds. Reads no value of any record.
# Usage: structdry.py T1N_FOLDER GRID_FOLDER FALL_CSV ARCHIVES
import csv, hashlib, importlib.util, json, math, random, re, sys, collections
from pathlib import Path
T = Path(sys.argv[1]); sys.path.insert(0, str(T))
import t1n
spec = importlib.util.spec_from_file_location('dry_run', T / 'dry_run.py')
D = importlib.util.module_from_spec(spec)
sys.argv_saved = sys.argv; spec.loader.exec_module(D)
GRID, FALL, ARCH = sys.argv[2], sys.argv[3], int(sys.argv[4])
grid = {}
for r in csv.DictReader(open(f'{GRID}/adult_estimates.csv', newline='', encoding='utf-8-sig')):
    lid, yr = str(int(float(r['WBIC']))), int(float(r['Survey Year']))
    g = grid.setdefault(lid, {'est': set(), 'label': {}, 'fall': set(), 'stock': set()})
    g['est'].add(yr)
    lab = t1n.NR if r['Primary Recruitment Source'].strip() == 'NATURAL' else 'other'
    if g['label'].get(yr) != t1n.NR:
        g['label'][yr] = lab
for r in csv.DictReader(open(FALL, newline='')):
    if r['WBIC'] in grid:
        grid[r['WBIC']]['fall'].add(int(r['Year']))
for r in csv.DictReader(open(f'{GRID}/stocking.csv', newline='', encoding='utf-8-sig')):
    g = grid.get((r['WBIC'] or '').strip())
    try:
        if g is not None and r['Species'].strip().lower() == 'walleye' and float(r['Number Stocked'] or 0) > 0:
            g['stock'].add(int(r['Year']))
    except ValueError:
        pass
A, K, S, C, SIGMA_R, CV, KNOCK, CUT, STOCK_BELOW = D.A, D.K, D.S, D.C, D.SIGMA_R, D.CV, D.KNOCK, D.CUT, D.STOCK_BELOW
def lake(rng, lid, g, world):
    w = D.WORLDS[world]
    q = w['q_mix'][int(hashlib.sha256(lid.encode()).hexdigest(), 16) % 2] if 'q_mix' in w else w['q']
    k0 = K * math.exp(rng.gauss(0, w['k_spread'])) if w.get('k_spread') else K
    spread = w.get('prod_spread', 0.0)
    a0 = A * math.exp(rng.gauss(0, spread)) if spread else A
    c0 = C * math.exp(rng.gauss(0, spread)) if spread else C
    e = rng.uniform(0.05, 0.6)
    closed = rng.random() < 0.4
    x = rng.uniform(1.5, 8.0)
    none = 'none' in w and rng.random() < w['none']
    collapse = 'collapse' in w and rng.random() < w['collapse']
    loss_year = None
    if 'loss' in w:
        share, y0, y1 = w['loss']
        if rng.random() < share:
            loss_year = rng.randint(y0, y1)
    hist = {}
    rec = {'id': lid, 'acres': 500.0, 'label': dict(g['label']), 'adults': {}, 'age0': {}, 'harvest': {}, 'creel': set(), 'stocked': set(g['stock']), 'closed': closed, 'other': set()}
    for yr in D.YEARS:
        k = k0 * (w.get('k_after', 1.0) if yr > t1n.CUTOFF else 1.0)
        a = a0 * (1 - w.get('decline', 0.0)) ** max(yr - 1990, 0)
        if none or (collapse and yr > t1n.CUTOFF) or (loss_year is not None and yr >= loss_year):
            a = 0.0
        sr = w.get('sigma_r', SIGMA_R)
        r = D.recruitment(x, q, k, a) * math.exp(sr * rng.gauss(0, 1) - sr * sr / 2 + SIGMA_R * SIGMA_R / 2)
        hist[yr] = r
        if yr in g['est']:
            est = x * math.exp(CV * rng.gauss(0, 1) - CV * CV / 2)
            rec['adults'][yr] = (est, est * math.exp(-1.96 * CV), est * math.exp(1.96 * CV))
        if yr in g['fall']:
            seen = x / (x + w['unseen']) if 'unseen' in w else 1.0
            rec['age0'][yr] = round(r * seen * w.get('catch', 1.0) * math.exp(0.3 * rng.gauss(0, 1)), 1)
        h = (e if x >= STOCK_BELOW else CUT) * x
        add = 1.0 if yr in g['stock'] else 0.0
        r3 = hist.get(yr - 3, D.recruitment(x, q, k, a))
        joins = w['c_gamma'] * r3 ** w['gamma'] if 'gamma' in w else c0 * r3
        x = max(S * x - h + joins + add + (0.0 if closed else w.get('immigration', 0.0)), 0.0)
        if rng.random() < KNOCK:
            x *= 0.1
    return rec
# Every world of dry_run.py whose settings lake() above carries; the others change how labels or estimates are made, leave stocking unrecorded, make the fall survey reach the floor by chance or run renewal in spells.
CARRIED = {'family', 'q', 'q_mix', 'k_spread', 'prod_spread', 'none', 'collapse', 'loss', 'k_after', 'decline', 'sigma_r', 'unseen', 'catch', 'gamma', 'c_gamma', 'immigration'}
worlds = [n for n, w in D.WORLDS.items() if set(w) <= CARRIED]
skipped = [n for n in D.WORLDS if n not in worlds]
out = {}
for world in worlds:
    tally = collections.Counter(); ns = []; pairs = []; nd_none = 0
    funnel = []; needs = []
    for a in range(ARCH):
        rng = random.Random(f'structdry|{world}|{a}')
        lakes = [lake(rng, lid, g, world) for lid, g in sorted(grid.items())]
        labels = t1n.labels_per_year(lakes)
        nd = t1n.need(lakes, labels=labels)
        pairs.append(len(t1n.pairs(lakes, labels=labels)))
        if nd['need'] is None:
            nd_none += 1
            why = str(nd.get('why', nd.get('reason', '')))
            tally['no need fitted' + (': too few pairs' if 'too few' in why else '')] += 1
            continue
        res = t1n.read(lakes, nd['need'], labels=labels)
        v = res['V1']['verdict']
        ns.append(res['V1']['below: resolved'])
        tab = res['rows']
        funnel.append((sum(1 for r in tab if 'out' not in r), sum(1 for r in tab if 'out' not in r and r['T1 predicts'] == 'falls'), sum(1 for r in tab if r.get('out') == 'the premise not shown: no two estimates up to the cutoff held above the need')))
        needs.append(round(nd['need'], 2))
        tally['need fitted, V1 ' + ('not decided: fewer than 10 resolved' if 'fewer than 10' in v else v[:60])] += 1
    out[world] = {'family': D.WORLDS[world]['family'], 'pairs': (min(pairs), max(pairs)), 'below resolved, median': sorted(ns)[len(ns) // 2] if ns else None, 'range': (min(ns), max(ns)) if ns else None, 'tally': dict(tally), 'median rows in, below, premise not shown': [sorted(x)[len(x) // 2] for x in zip(*funnel)] if funnel else None, 'need median': sorted(needs)[len(needs) // 2] if needs else None}
print(json.dumps({'archives a world': ARCH, 'lakes': len(grid), 'worlds in dry_run.py': len(D.WORLDS), 'not carried here': skipped, 'worlds': out}, indent=1))
