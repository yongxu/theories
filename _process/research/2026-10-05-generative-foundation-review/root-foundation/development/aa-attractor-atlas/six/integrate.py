"""AA six-family pass: fold the six shares' extractions and their checkers' corrections into the entries.

Order: each share's own corrections and missed items are applied to its extraction; every checker's merges are pooled and
resolved into one canonical id per proposition (see CANON and SPLIT below); premise lines are pooled across shares; the
decidedness rule is applied from the Lean pass (decidable.out) for the core and from the extractors for the periphery;
case_of keeps only general laws listed under another dynamic or under none and stated in no record of the law's own
dynamic; then the entries are written: each read law's listing (takes, case_of), each exit's destination and drops, each
transition's ends, each dynamic's joinings, the ledger; and the evidence: the six families' mapping, readings, report.
Run: python3 -B integrate.py [--write]"""
import collections, copy, json, re, sys
from pathlib import Path

K = Path('/Users/ren/tmp/aa-six'); W = K / 'wt'
E = W / 'theories/becoming/results/atlas/entries'
EV = W / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aa-attractor-atlas'
SHARES = ['A', 'B1', 'B2E', 'G', 'FH1', 'H2']
WRITE = '--write' in sys.argv
report = collections.defaultdict(list)

D = json.loads((E / 'dynamics.json').read_text(encoding='utf-8'))
P0 = json.loads((E / 'premises.json').read_text(encoding='utf-8'))
ledger = {p['id']: p for p in P0}
by_dyn = {d['id']: d for d in D}
rows = json.load(open(K / 'run/lister.json'))
inputs = {s: json.load(open(K / f'run/input-{s}.json')) for s in SHARES}
share_of = {x['id']: s for s in SHARES for x in inputs[s]['dynamics']}
six = [d for d in D if d['family'] in 'ABEFGH']
assert set(share_of) == {d['id'] for d in six}

# --- 1. read each share's lines and apply its checker --------------------------------------------------------------
dyn, prem, inc = {}, {}, []          # dynamic id -> line; premise id -> (share, line); incoming lines
for s in SHARES:
    for n, l in enumerate(open(K / f'run/extract-{s}.jsonl', encoding='utf-8'), 1):
        if not l.strip():
            continue
        x = json.loads(l)
        if x['kind'] == 'dynamic':
            assert x['id'] in share_of and x['id'] not in dyn, (s, x['id'])
            x['_share'] = s
            dyn[x['id']] = x
        elif x['kind'] == 'premise':
            if x['id'] in prem:
                old = prem[x['id']][1]
                if (old['statement'], old['lean']) != (x['statement'], x['lean']):
                    keep, other = sorted([old, x], key=lambda y: (not any(re.search(r'\.[A-Z«][^.]*$', n) for n in y['lean']),
                                                                   -len(y['statement']['en'])))
                    keep = dict(keep)
                    for f in ('holds_in', 'fails_in'):
                        keep[f] = list(dict.fromkeys((keep.get(f) or []) + (other.get(f) or [])))
                    if not any(re.search(r'\.[A-Z«][^.]*$', n) for n in keep['lean']):
                        keep['lean'] = list(dict.fromkeys(keep['lean'] + other['lean']))
                    prem[x['id']] = (prem[x['id']][0], keep)
                    report['premise minted twice: one line kept'].append((x['id'], prem[x['id']][0], s))
                continue
            prem[x['id']] = (s, x)
        elif x['kind'] == 'incoming':
            x['_share'] = s
            inc.append(x)
        else:
            raise SystemExit(f'{s}:{n}: kind {x["kind"]!r}')
missing = sorted(set(share_of) - set(dyn))
assert not missing, missing


def law_of(d, name, create=False):
    for h in d['laws']:
        if h['law'] == name:
            return h
    if create:
        h = {'law': name, 'binders': [], 'also_takes': [], 'case_of': []}
        d['laws'].append(h)
        return h
    raise KeyError((d['id'], name))


merges = []
for s in SHARES:
    ck = json.load(open(K / f'run/check-{s}.json'))
    for c in ck.get('corrections', []) + [dict(m, _missed=True) for m in ck.get('missed', [])]:
        part, v = c.get('part'), c.get('value')
        d = dyn.get(c.get('dynamic'))
        try:
            if part == 'premise':
                pid = (v or {}).get('id') or c.get('id')
                if v is None:
                    prem.pop(pid, None)
                else:
                    v = dict(v, kind='premise')
                    prem[pid] = (prem.get(pid, (s,))[0], v)
            elif part == 'exit':
                i = c.get('index') or v['index']
                xs = [x for x in d['exits'] if x['index'] == i]
                if xs:
                    xs[0].clear(); xs[0].update(v)
                else:
                    d['exits'].append(v)
            elif part == 'transition':
                i = c.get('index') or v['index']
                xs = [x for x in d['transitions'] if x['index'] == i]
                if xs:
                    xs[0].clear(); xs[0].update(v)
                else:
                    d['transitions'].append(v)
            elif part == 'binder':
                h = law_of(d, c['law'], create=True)
                bs = [b for b in h['binders'] if b['position'] == (c.get('position') or v['position'])]
                if v is None:
                    h['binders'] = [b for b in h['binders'] if b not in bs]
                elif bs:
                    bs[0].clear(); bs[0].update(v)
                else:
                    h['binders'].append(v)
                    h['binders'].sort(key=lambda b: b['position'])
            elif part in ('also_takes', 'case_of'):
                h = law_of(d, c['law'], create=True)
                h[part] = v if isinstance(v, list) else ([v] if v else [])
            elif part == 'compose':
                d.setdefault('compose', [])
                if c.get('_missed') or not c.get('index'):
                    d['compose'].append(v)
                elif v is None:
                    d['compose'].pop(c['index'] - 1)
                else:
                    d['compose'][c['index'] - 1] = v
            elif part == 'readings':
                d.setdefault('readings', []).append(v)
            elif part == 'law':
                h = law_of(d, v['law'], create=True)
                h.update(v)
            elif part == 'incoming':
                if v is None:
                    tgt = c.get('dynamic')
                    frm = c.get('from_dynamic') or (c.get('id') or '').split('#')[0]
                    idx = c.get('index')
                    before = len(inc)
                    inc[:] = [x for x in inc if not (x['to'] == tgt and x['from_dynamic'] == frm and x['index'] == idx)]
                    if len(inc) == before:
                        report['incoming removal matched nothing'].append((s, frm, idx, tgt))
                else:
                    inc.append(dict(v, _share=s))
            else:
                report['correction of an unknown part'].append((s, part, c.get('dynamic')))
        except Exception as ex:  # noqa: BLE001
            report['correction not applied'].append((s, part, c.get('dynamic'), c.get('law'), c.get('index'), repr(ex)[:120]))
    merges += [dict(m, _share=s) for m in ck.get('merges', [])]

# --- 2. the premise pool and its merges -----------------------------------------------------------------------------
# Decisions of this session (each read against the Lean; see the evidence README):
#  * explicit decidedness disjunctions are k3-decided's proposition stated as a binder;
#  * a census of what stands, embodiment of what arises and enclosure around what stands are their own propositions,
#    not K3's census, embodiment and enclosure (K3's coverage patterns group them; the Lean shows them apart:
#    Locality.lean:150, InAmounts.lean:327, Openness.lean:195); C and D's two StandingCensus binders are re-pointed.
SPLIT = {'k3-a-census': 'web-standingcensus', 'k3-embodiment': 'world-arisingembodied', 'k3-enclosed': 'flow-aroundstanding'}
SPLIT_FORMS = {'web-standingcensus': r'\bStandingCensus\b', 'world-arisingembodied': r'\bArisingEmbodied\b',
               'flow-aroundstanding': r'\bAroundStanding\b'}
OVERRIDE = {}     # merge decisions the session takes where checkers disagree: id -> into
pool = {pid: line for pid, (s, line) in prem.items()}
into = {}
for m in merges:
    a, b = m['id'], m['into']
    if a == b:
        continue
    if a in into and into[a] != b:
        report['merge given two targets'].append((a, into[a], b, m['_share']))
    into[a] = b
into.update(OVERRIDE)
# One law read in two shares: the same binder of the same law states one proposition, so the second share's id for it
# is merged into the first's (by the dynamics' order in the entries).
first = {}
order_of = {d['id']: i for i, d in enumerate(D)}
uses = collections.Counter(q for x in dyn.values() for h in x['laws'] for b in h.get('binders') or [] for q in b.get('premises') or [])
for did in sorted(dyn, key=order_of.get):
    for h in dyn[did]['laws']:
        first.setdefault(h['law'], (did, h))


def _c(p, seen=()):
    return _c(into[p], seen + (p,)) if p in into and p not in seen else p


for did in sorted(dyn, key=order_of.get):
    for h in dyn[did]['laws']:
        d0, h0 = first[h['law']]
        if dyn[d0]['_share'] == dyn[did]['_share'] or d0 == did:
            continue
        pos0 = {b['position']: [_c(q) for q in b.get('premises') or []] for b in h0.get('binders') or []}
        for b in h.get('binders') or []:
            a, z = pos0.get(b['position']), [_c(q) for q in b.get('premises') or []]
            if a and z and a != z:
                if len(a) == len(z) == 1 and not (z[0] in ledger and a[0] in ledger):
                    # the id fewer binders take merges into the one more take (a ledger id is never merged away)
                    lo, hi = sorted([z[0], a[0]], key=lambda q: (q in ledger, uses[q]))
                    into[lo] = hi
                    report['merged: one binder, two shares'].append((h['law'], b['position'], lo, hi, uses[lo], uses[hi]))
                else:
                    report['one binder, two shares, not merged'].append((h['law'], b['position'], z, a))
for a in list(into):            # a form SPLIT keeps apart is not merged back into the K3 premise
    if a in SPLIT.values() or any(re.fullmatch(v + r'(-.*)?', a) for v in SPLIT.values()):
        report['merge undone: a form kept apart from K3'].append((a, into.pop(a)))
for v in SPLIT.values():
    if v not in pool:
        report['a split premise with no line'].append(v)


def canon(p, seen=()):
    if p in into and p not in seen:
        return canon(into[p], seen + (p,))
    return p


cycles = [a for a in into if canon(a) == a]
for a in cycles:
    report['merge cycle broken (kept as itself)'].append(a)
    del into[a]
for a, b in sorted(into.items()):
    t = canon(b)
    if t not in pool and t not in ledger:
        if a in pool:            # the target is named by the naming rule but no share wrote its line: the source's line moves
            pool[t] = dict(pool[a], id=t)
            report['a merge target given the line of what merges into it'].append((a, t))
        else:
            report['merge into an unknown id'].append((a, b))
# Same defining declaration, two ids: report (decided by reading, then added to OVERRIDE).
by_def = collections.defaultdict(set)
for pid, l in list(pool.items()) + [(p['id'], p) for p in P0]:
    if canon(pid) != pid:
        continue
    if len(l.get('lean') or []) == 1 and re.search(r'\.[A-Z«][^.]*$', l['lean'][0]):
        by_def[l['lean'][0]].add(pid)
for name, ids in sorted(by_def.items()):
    if len(ids) > 1:
        report['one defining declaration, several ids'].append((name, sorted(ids)))

# --- 3. the decidedness rule --------------------------------------------------------------------------------------
dec = {}
for l in open(K / 'run/decidable.out', encoding='utf-8'):
    if l.startswith('AADEC '):
        try:
            r = json.loads(l[6:])
        except json.JSONDecodeError:
            report['decidable line unreadable'].append(l[:80]); continue
        dec[r['law']] = r.get('decidable') or []


def takes_of(h, law_kind):
    """The listing's takes in binder order, then what is taken another way; decidedness from the Lean pass where the law
    is in the core."""
    out = []
    for b in sorted(h.get('binders') or [], key=lambda b: b['position']):
        for p in b.get('premises') or []:
            p = canon(p)
            if p not in out:
                out.append(p)
    also = [dict(a, premise=canon(a['premise'])) for a in h.get('also_takes') or []]
    if law_kind == 'lister':
        also = [a for a in also if a['premise'] != 'k3-decided' or a.get('as') not in ('data', 'definition', 'form')]
        if dec.get(h['law']):
            also.append({'premise': 'k3-decided', 'as': 'data', 'note': 'a Decidable binder: ' + '; '.join(x['type'] for x in dec[h['law']])})
    for a in also:
        if a['premise'] not in out:
            out.append(a['premise'])
    return out, also


# --- 4. case_of: general laws elsewhere ------------------------------------------------------------------------------
owners = collections.defaultdict(set)
for d in D:
    for n in d['declarations']:
        owners[n].add(d['id'])
recdecls = {}
for d in D:
    names = set()
    for r in d['records']:
        rj = json.loads((W / f'theories/becoming/results/records/{r}.json').read_text(encoding='utf-8'))
        for law in rj.get('laws') or []:
            names.update(law.get('declarations') or [])
    recdecls[d['id']] = names


def keep_case(did, law, c):
    m = c['law']
    if m == law or m in by_dyn[did]['declarations']:
        return 'a law of the same dynamic'
    if not owners.get(m) and m in recdecls[did]:
        return 'listed under no dynamic and stated in a record of the same dynamic: an inner step'
    return None


# --- 4b. C and D's binders of the forms kept apart: re-pointed in their listings and in step 2b's mapping -----------
S2B = EV / 'step2b/mapping.json'
m2b = json.loads(S2B.read_text(encoding='utf-8'))
for law, v in m2b.items():
    for b in v['binders']:
        for k3, form in SPLIT.items():
            if k3 in b['premises'] and re.search(SPLIT_FORMS[form], b.get('type') or ''):
                b['premises'] = [form if q == k3 else q for q in b['premises']]
                still = any(k3 in bb['premises'] for bb in v['binders']) or k3 in v['takes_unbound']
                for d in D:
                    for h in d.get('premises') or []:
                        if h['law'] == law:
                            h['takes'] = [x for x in (form if q == k3 and not still else q for q in h['takes'])]
                            if form not in h['takes']:
                                h['takes'].append(form)
                report['C or D binder re-pointed to a form kept apart'].append((law, b['position'], k3, form, 'kept' if still else 'replaced'))

# --- 5. build the entries ------------------------------------------------------------------------------------------
cd_listing = {h['law']: h['takes'] for d in D if d['family'] in 'CD' for h in d.get('premises') or []}
mapping, listings = {}, collections.defaultdict(list)
new_D = copy.deepcopy(D)
nd = {d['id']: d for d in new_D}
readings = []
counts = collections.Counter()
for did, x in dyn.items():
    d = nd[did]
    inp = {y['law']: y for y in next(z for z in inputs[x['_share']]['dynamics'] if z['id'] == did)['declarations']}
    listing = []
    order = [n for n in d['declarations']]
    lawlines = {h['law']: h for h in x['laws']}
    for name in order + [n for n in lawlines if n not in order]:
        h = lawlines.get(name)
        src = inp.get(name, {})
        is_law = src.get('kind') == 'theorem' or (src.get('source') == 'source text' and src.get('kind') in ('theorem', 'lemma'))
        if h is None:
            if is_law:
                report['a law of the input not read'].append((did, name))
            continue
        if name not in order:
            report['a law read that the entry does not declare (left out)'].append((did, name))
            continue
        kind = 'lister' if src.get('source') == 'lister' else 'source text'
        for b in h.get('binders') or []:
            ty = b.get('type') or next((y['type'] for y in src.get('binders', []) if y['position'] == b['position']), '') or ''
            for k3, form in SPLIT.items():
                if k3 in (b.get('premises') or []) and re.search(SPLIT_FORMS[form], ty):
                    b['premises'] = [form if q == k3 else q for q in b['premises']]
                    report['binder re-pointed from a K3 premise to its form'].append((did, name, b['position'], k3, form))
        takes, also = takes_of(h, kind)
        if name in cd_listing and set(cd_listing[name]) != set(takes):
            report['a C or D law read differently here (C and D listing kept)'].append((did, name, sorted(set(takes) ^ set(cd_listing[name]))))
            takes = list(cd_listing[name])
        entry = {'law': name, 'takes': takes}
        cases = []
        for c in h.get('case_of') or []:
            why = keep_case(did, name, c)
            if why:
                report['case_of left out'].append((did, name, c['law'], why))
                readings.append({'dynamic': did, 'reading': f'{name} applies {c["law"]} ({why}): {c.get("how", "")}'})
                continue
            cases.append({'law': c['law'], 'how': {'en': c['how'] if isinstance(c['how'], str) else c['how']['en']}})
        if cases:
            entry['case_of'] = cases
            counts['case_of'] += len(cases)
        listing.append(entry)
        listings[name].append((did, takes))
        if name not in cd_listing:
            mapping[name] = {'family': d['family'], 'source': kind,
                             'binders': [{'position': b['position'], 'name': b.get('name'),
                                          'type': b.get('type') or next((y['type'] for y in src.get('binders', []) if y['position'] == b['position']), None),
                                          'premises': [canon(p) for p in b.get('premises') or []]}
                                         for b in sorted(h.get('binders') or [], key=lambda b: b['position'])],
                             'takes_unbound': {a['premise']: a.get('as') for a in also}}
    d['premises'] = listing
    counts['laws'] += len(listing)
    # exits
    ex = {e_['index']: e_ for e_ in x['exits']}
    for i, e_ in enumerate(d['exits'], 1):
        r = ex.get(i)
        if r is None:
            report['exit not read'].append((did, i)); continue
        to = r.get('to')
        if isinstance(to, dict) and set(to) != {'en'}:
            to = {'en': to.get('en')}
        e_['to'] = to
        e_.pop('to_law', None); e_.pop('drops', None)
        if isinstance(to, str):
            if to not in nd:
                report['exit to an unknown dynamic'].append((did, i, to)); e_['to'] = None
            elif r.get('to_law'):
                e_['to_law'] = r['to_law']
            elif not e_.get('standing_without_law'):
                report['exit to a dynamic with no law placing it'].append((did, i, to))
        if not e_.get('standing_without_law'):
            e_['drops'] = [canon(p) for p in r.get('drops') or []]
        counts['exits to a dynamic' if isinstance(e_['to'], str) else 'exits in words' if e_['to'] else 'exits null'] += 1
    tr = {t['index']: t for t in x['transitions']}
    for i, t in enumerate(d['transitions'], 1):
        r = tr.get(i)
        if r is None:
            report['transition not read'].append((did, i)); continue
        b = r.get('between')
        if b:
            fix = lambda v: v if isinstance(v, str) or v is None else {'en': v['en'] if isinstance(v, dict) else v}  # noqa: E731
            t['between'] = {'from': fix(b.get('from')), 'to': fix(b.get('to'))}
            counts['transitions between'] += 1
        else:
            t.pop('between', None)
    comps = []
    for c in x.get('compose') or []:
        txt = lambda v: None if v is None else {'en': v} if isinstance(v, str) else {'en': v['en']}  # noqa: E731
        comps.append({'from': {k: c['from'].get(k) for k in ('dynamic', 'law', 'role')},
                      'to': {k: c['to'].get(k) for k in ('dynamic', 'law', 'role')},
                      'map': txt(c['map']), 'order_kept': c['order_kept'], 'premises': [canon(p) for p in c.get('premises') or []],
                      'joint_law': c.get('joint_law'), 'exits_kept': txt(c.get('exits_kept')), 'standing': c['standing'],
                      'source': c['source']})
    if comps:
        d['compose'] = comps
        counts['joinings'] += len(comps)
    readings += [{'dynamic': did, 'reading': r} for r in x.get('readings') or []]
    if x.get('not_read'):
        report['not read'].append((did, x['not_read']))

for name, ls in listings.items():
    if len({tuple(sorted(t)) for _, t in ls}) > 1:
        union = list(dict.fromkeys(q for _, t in ls for q in t))
        report['one law, two lists: their union listed on both'].append((name, [(d, sorted(set(union) - set(t))) for d, t in ls]))
        for d_, _ in ls:
            for h in nd[d_]['premises']:
                if h['law'] == name:
                    h['takes'] = list(union)
        if name in mapping:
            for q in union:
                if not any(q in b['premises'] for b in mapping[name]['binders']):
                    mapping[name]['takes_unbound'].setdefault(q, 'commitment' if q.startswith('card-') else 'definition')

# incoming routes: report each against the source exit as now read; applied only by decision (APPLY_INCOMING)
APPLY_INCOMING = {('two-sided-regulation-and-late-reading', 3, 'loss-of-renewal-for-good'),
                  ('no-finite-part-bears-taking', 1, 'closed-cycle-without-dissipation'),
                  ('selection-when-the-lumping-changes', 3, 'a-revision-that-opens-a-correction')}
for x in inc:
    src = nd.get(x['from_dynamic'])
    if src is None:
        report['incoming from an unknown dynamic'].append((x['_share'], x['from_dynamic'])); continue
    if not 1 <= x['index'] <= len(src['exits']):
        report['incoming to an exit that does not exist'].append((x['_share'], x['from_dynamic'], x['index'])); continue
    e_ = src['exits'][x['index'] - 1]
    key = (x['from_dynamic'], x['index'], x['to'])
    if e_['to'] == x['to']:
        counts['incoming already so'] += 1
    elif key in APPLY_INCOMING:
        e_['to'], e_['to_law'] = x['to'], x['to_law']
        counts['incoming applied'] += 1
    else:
        report['incoming to decide'].append((x['_share'], x['from_dynamic'], x['index'], x['to'], x.get('to_law'),
                                             'now: ' + (e_['to'] if isinstance(e_['to'], str) else json.dumps(e_['to'], ensure_ascii=False)[:160])))

# --- 6. the ledger ---------------------------------------------------------------------------------------------------
used = set()
for d in new_D:
    for h in d.get('premises') or []:
        used.update(h['takes'])
    for e_ in d['exits']:
        used.update(e_.get('drops') or [])
    for c in d.get('compose') or []:
        used.update(c['premises'])
new_P = copy.deepcopy(P0)
added = []
for pid in sorted(used - set(ledger)):
    if pid not in pool:
        report['a premise used but written nowhere'].append(pid); continue
    l = pool[pid]
    p = {'id': pid, 'name': {'en': l['name']['en'] if isinstance(l['name'], dict) else l['name']},
         'statement': {'en': l['statement']['en'] if isinstance(l['statement'], dict) else l['statement']},
         'kind': l.get('kind_of') or l.get('kind'), 'lean': l.get('lean') or [], 'holds_in': l.get('holds_in') or [],
         'fails_in': l.get('fails_in') or [], 'home': l['home'], 'seeded_from': l.get('seeded_from') or ['Lean']}
    if p['kind'] == 'premise':
        report['premise with no kind'].append(pid)
    added.append(p)
new_P += added
counts['premises added'] = len(added)
unused = sorted(p for p in pool if canon(p) == p and p not in used and p not in ledger)
if unused:
    report['premise written, taken by no law'].extend(unused)

print(json.dumps(dict(counts), indent=0))
for k, v in report.items():
    print(f'\n## {k} ({len(v)})')
    for y in v[:400]:
        print('  ', json.dumps(y, ensure_ascii=False)[:400])
json.dump({'readings': readings}, open(K / 'run/readings.json', 'w'), ensure_ascii=False, indent=1)
if WRITE:
    (E / 'dynamics.json').write_text(json.dumps(new_D, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
    (E / 'premises.json').write_text(json.dumps(new_P, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
    (EV / 'six').mkdir(exist_ok=True)
    (EV / 'six/mapping.json').write_text(json.dumps(mapping, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
    S2B.write_text(json.dumps(m2b, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
    print('written')
