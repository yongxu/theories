"""The fidelity count (FC1; FIDELITY.md §2 "Aligning 經 clauses to declarations"): the proposal, the coders' packets,
and the merge of their answers.

propose: for each 條 that has a paired declaration (an E1 segment), the names of the name table in each 經 clause
(longest match on the simplified names) give anchor constants; a clause is proposed for the declarations whose own
name, constants or U1 constants meet those anchors, and, where none does, for the declaration at its place in the 證
order (the prior). Calibration 條 are set aside first: whole 條, stratified by 篇, until forty pairs are held.

packets: batches of 條 for the two coders (a 條's 經 clauses, its 證 declarations with a short form of their Lean
statements, the proposal); no English text.

merge: a clause's set of declarations is final where both coders agree; where they differ it goes to the adjudicator's
answer. Agreement is reported per clause (exact set equality) and as Cohen's κ over (clause, declaration) incidences.

    python3 -I fidelity/align.py propose
    python3 -I fidelity/align.py packets N            # N 條 per packet
    python3 -I fidelity/align.py merge A.json B.json [ADJ.json]
"""
import csv, json, random, re, sys
from collections import defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent
KIT = HERE.parent
DATA = HERE / 'data'
sys.path.insert(0, str(KIT / 'work'))
from simplify import simp  # noqa: E402


def load(name):
    return [json.loads(l) for l in open(DATA / name, encoding='utf-8')]


def lean_index():
    return {d['decl']: d for d in load('lean_table.jsonl')}


def short(L, limit=700):
    """A short form of L(d) for the alignment: binders by name and type, and the conclusion."""
    b = '; '.join('%s : %s' % (x['name'], x['type']) for x in L['binders'] if x['role'] != 'type parameter')
    s = '%s. ∀ %s ⊢ %s' % (L['kind'], b, L['conclusion'])
    return s if len(s) <= limit else s[:limit] + ' …'


def names_table():
    rows = list(csv.DictReader(open(KIT / 'work/names-decisions.tsv', encoding='utf-8'), delimiter='\t'))
    out = []
    for r in rows:
        anchors = {('Becoming.' + a.strip()) if not a.strip().startswith(('Becoming.', 'Generative.')) else a.strip()
                   for a in r['锚'].split('；') if a.strip() not in ('', '—')}
        out.append((simp(r['名']), anchors))
    out.sort(key=lambda x: -len(x[0]))
    return out


def names_in(text, table):
    found, used = [], [False] * len(text)
    for name, anchors in table:
        for m in re.finditer(re.escape(name), text):
            if not any(used[m.start():m.end()]):
                found.append((name, anchors))
                for i in range(m.start(), m.end()):
                    used[i] = True
    return found


def propose():
    tiao = {t['id']: t for t in load('tiao.jsonl')}
    pairs = load('pairs.jsonl')
    L = lean_index()
    table = names_table()
    paired = defaultdict(list)
    for p in pairs:
        if p['e1']:
            paired[p['tiao']].append(p['decl'])
    # calibration: whole 條, stratified by 篇, until forty pairs are held
    rnd = random.Random(20261022)
    by_pian = defaultdict(list)
    for tid in sorted(paired):
        by_pian[tiao[tid]['pian']].append(tid)
    for v in by_pian.values():
        rnd.shuffle(v)
    calib, held, k = [], 0, 0
    while held < 40:
        progressed = False
        for pian in sorted(by_pian):
            if k < len(by_pian[pian]) and held < 40:
                tid = by_pian[pian][k]
                calib.append(tid)
                held += len(paired[tid])
                progressed = True
        k += 1
        if not progressed:
            break
    out = []
    for tid, ds in paired.items():
        t = tiao[tid]
        decls = t['decls']
        reach = {d: ({d} | set(L[d]['consts']) | {u['const'] for u in L[d]['unfold1']}) if d in L else {d} for d in decls}
        prop = []
        for i, c in enumerate(t['jing_clauses']):
            anchors = set().union(*[a for _, a in names_in(c, table)]) if c else set()
            hit = [d for d in decls if anchors & reach[d]]
            if not hit and decls:
                hit = [decls[min(len(decls) - 1, i * len(decls) // max(1, len(t['jing_clauses'])))]]
            prop.append(hit)
        out.append({'tiao': tid, 'pian': t['pian'], 'calibration': tid in calib, 'paired': ds,
                    'clauses': t['jing_clauses'], 'decls': decls, 'proposal': prop})
    with open(DATA / 'align_proposal.jsonl', 'w', encoding='utf-8') as f:
        for o in out:
            f.write(json.dumps(o, ensure_ascii=False) + '\n')
    print(json.dumps({'tiao': len(out), 'calibration_tiao': len(calib), 'calibration_pairs': held,
                      'pairs': sum(len(v) for v in paired.values())}))


def packets(n):
    L = lean_index()
    rows = load('align_proposal.jsonl')
    rnd = random.Random(7)
    rnd.shuffle(rows)
    pk = []
    for i in range(0, len(rows), n):
        batch = []
        for r in rows[i:i + n]:
            batch.append({'tiao': r['tiao'],
                          'clauses': [{'n': j + 1, 'text': c} for j, c in enumerate(r['clauses'])],
                          'declarations': [{'name': d, 'lean': short(L[d]) if d in L else '(not dumped)'} for d in r['decls']],
                          'proposal': [{'clause': j + 1, 'declarations': p} for j, p in enumerate(r['proposal'])]})
        pk.append(batch)
    d = DATA / 'align_packets'
    d.mkdir(exist_ok=True)
    for j, b in enumerate(pk):
        (d / ('align_%02d.json' % j)).write_text(json.dumps(b, ensure_ascii=False, indent=1))
    print(len(pk), 'packets')


def merge(a_path, b_path, adj_path=None):
    rows = {r['tiao']: r for r in load('align_proposal.jsonl')}

    def answers(p):
        out = {}
        for x in json.loads(Path(p).read_text()):
            for t in x['tiao_alignments']:
                out[t['tiao']] = {c['clause']: sorted(set(c['declarations'])) for c in t['clauses']}
        return out
    A, B = answers(a_path), answers(b_path)
    ADJ = answers(adj_path) if adj_path else {}
    final, agree, total, disagreements = {}, 0, 0, []
    n11 = n10 = n01 = n00 = 0
    for tid, r in rows.items():
        fa, fb = A.get(tid, {}), B.get(tid, {})
        f = {}
        for j in range(1, len(r['clauses']) + 1):
            sa, sb = fa.get(j, []), fb.get(j, [])
            total += 1
            for d in r['decls']:
                x, y = d in sa, d in sb
                n11 += x and y
                n10 += x and not y
                n01 += y and not x
                n00 += (not x) and (not y)
            if sa == sb:
                agree += 1
                f[j] = sa
            else:
                disagreements.append({'tiao': tid, 'clause': j, 'a': sa, 'b': sb})
                f[j] = ADJ.get(tid, {}).get(j)
        final[tid] = f
    n = n11 + n10 + n01 + n00
    po = (n11 + n00) / n if n else 0
    pe = (((n11 + n10) * (n11 + n01)) + ((n00 + n01) * (n00 + n10))) / n / n if n else 0
    kappa = (po - pe) / (1 - pe) if pe < 1 else 1.0
    (DATA / 'align_final.json').write_text(json.dumps(final, ensure_ascii=False, indent=1))
    (DATA / 'align_disagreements.json').write_text(json.dumps(disagreements, ensure_ascii=False, indent=1))
    unresolved = sum(1 for t in final.values() for v in t.values() if v is None)
    print(json.dumps({'clauses': total, 'agree_exact': agree, 'disagree': len(disagreements),
                      'kappa_incidence': round(kappa, 3), 'unresolved': unresolved}))


if __name__ == '__main__':
    cmd = sys.argv[1]
    if cmd == 'propose':
        propose()
    elif cmd == 'packets':
        packets(int(sys.argv[2]))
    elif cmd == 'merge':
        merge(*sys.argv[2:])
