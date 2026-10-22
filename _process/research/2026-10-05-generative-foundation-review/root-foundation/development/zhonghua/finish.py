"""Finish the 中华本 from the rewrite pass: python3 -I finish.py [--report]

Reads work/book-1.json (the parsed book with the restructuring plan applied), agents/rewrite-<KEY>.json (each part
rewritten, its 條 by id) and agents/review-<KEY>.json (exact edits by 條 id, INTRO or DUIZHAO), work/redo/<KEY>.json
where a part was rewritten again by hand or by a later pass (it replaces the rewrite, and its own review edits, if
any, are in work/redo/<KEY>-review.json), work/integrator-edits.json (the integrator's exact edits by 條 id, each
with its reason, applied after the review's), work/xu.fragment (the preface) and work/appendices.fragment. Checks that each part
keeps its 條 ids in order, applies each edit only where its text occurs exactly once, and reports what a 條 lost
(declarations, quotations) against the parsed book; then renders the book (book.py), fills the generated tables
(build_tables.py) and runs verify_zh.py. Writes work/finish-report.json."""
import json, os, re, subprocess, sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import book as B

ROOT = os.path.abspath(os.path.join(HERE, *(['..'] * 6)))
OUT = os.path.join(ROOT, 'theories/becoming/chapters/THE-THEORY-OF-BECOMING-ZHONGHUA.md')
ROUNDS = ['work/round2-edits.json', 'work/round3-edits.json', 'work/round4-edits.json', 'work/round5-edits.json', 'work/round6-edits.json', 'work/round7-edits.json', 'work/round8-edits.json']
DECL = re.compile(r'`(Becoming\.[^`]+)`')
QUOTE = re.compile(r'「([^」]{2,})」〔([A-Za-z0-9\-]+)〕')


def load(path):
    return json.load(open(path, encoding='utf-8')) if os.path.exists(path) else None


def main():
    b = load(os.path.join(HERE, 'work/book-1.json'))
    report = {}
    for p in b['parts']:
        k = p['key']
        rep = report.setdefault(k, {})
        redo = load(os.path.join(HERE, 'work/redo/%s.json' % k))
        new = redo or load(os.path.join(HERE, 'agents/rewrite-%s.json' % k))
        rv = load(os.path.join(HERE, 'work/redo/%s-review.json' % k)) if redo else load(os.path.join(HERE, 'agents/review-%s.json' % k))
        if not new:
            rep['missing'] = True
            continue
        old_ids = [t['id'] for t in p['tiao']]
        new_ids = [t['id'] for t in new['tiao']]
        if old_ids != new_ids:
            rep['ids'] = {'lost': [i for i in old_ids if i not in new_ids], 'extra': [i for i in new_ids if i not in old_ids],
                          'order': old_ids != [i for i in new_ids if i in old_ids]}
        by = {t['id']: t for t in new['tiao']}
        failed = []
        for e in (rv or {}).get('edits', []):
            if e['id'] == 'INTRO':
                tgt, field = new, 'intro'
            elif e['id'] == 'DUIZHAO':
                tgt, field = new, 'duizhao'
            elif e['id'] in by:
                tgt, field = by[e['id']], 'body'
            else:
                failed.append({'id': e['id'], 'why': 'no such 條', 'find': e['find'][:60]})
                continue
            n = tgt[field].count(e['find'])
            if n == 1:
                tgt[field] = tgt[field].replace(e['find'], e['replace'])
            elif e['find'] == e['replace']:
                pass
            else:
                hit = [t['id'] for t in new['tiao'] if t['body'].count(e['find']) == 1]
                if len(hit) == 1 and field == 'body':
                    t = by[hit[0]]
                    t['body'] = t['body'].replace(e['find'], e['replace'])
                else:
                    failed.append({'id': e['id'], 'count': n, 'find': e['find'][:60], 'why': e['why'][:80]})
        for e in [x for x in (load(os.path.join(HERE, 'work/integrator-edits.json')) or []) if x['id'] in by]:
            t = by[e['id']]
            if t['body'].count(e['find']) == 1 or (e.get('all') and t['body'].count(e['find']) > 1):
                t['body'] = t['body'].replace(e['find'], e['replace'])
            else:
                failed.append({'id': e['id'], 'why': 'integrator edit not applied: ' + e['why'], 'find': e['find'][:60]})
        rep['edits'], rep['failed'] = len((rv or {}).get('edits', [])), failed
        lost = {}
        for t in p['tiao']:
            if t['id'] not in by:
                continue
            nb = by[t['id']]['title'] + by[t['id']]['body']
            d = set(DECL.findall(t['body'])) - set(DECL.findall(nb))
            q = {m.group(2) + ':' + m.group(1)[:12] for m in QUOTE.finditer(t['body'])} - \
                {m.group(2) + ':' + m.group(1)[:12] for m in QUOTE.finditer(nb)}
            if d or q:
                lost[t['id']] = {'declarations': sorted(d), 'quotations': sorted(q)}
        rep['lost'] = lost
        p['heading'], p['intro'], p['duizhao'] = new['heading'], new['intro'], new['duizhao']
        for t in p['tiao']:
            if t['id'] in by:
                t['title'], t['body'] = by[t['id']]['title'], by[t['id']]['body']
    ids = {t['id'] for p in b['parts'] for t in p['tiao']} | set(b['redirect'])
    head = open(os.path.join(HERE, 'work/xu.fragment'), encoding='utf-8').read()
    b['head'] = B.REF.sub(lambda m: '⟦%s⟧' % m.group(1) if m.group(1) in ids else m.group(1), head)
    # review rounds after the rewrite: exact edits by 條 id, KEY:INTRO, KEY:DUIZHAO or HEAD, in file order
    parts = {p['key']: p for p in b['parts']}
    tiao = {t['id']: t for p in b['parts'] for t in p['tiao']}
    for f in ROUNDS:
        rep = report.setdefault(os.path.basename(f), {'applied': 0, 'failed': []})
        for e in load(os.path.join(HERE, f)) or []:
            i = e['id']
            if i == 'HEAD':
                tgt, field = b, 'head'
            elif ':' in i and i.split(':')[0] in parts:
                tgt, field = parts[i.split(':')[0]], {'INTRO': 'intro', 'DUIZHAO': 'duizhao'}.get(i.split(':')[1], 'intro')
            elif i in tiao:
                tgt, field = tiao[i], ('title' if e['find'] in tiao[i]['title'] and e['find'] not in tiao[i]['body'] else 'body')
            else:
                rep['failed'].append({'id': i, 'why': 'no such place', 'find': e['find'][:60]})
                continue
            if tgt[field].count(e['find']) == 1:
                tgt[field] = tgt[field].replace(e['find'], e['replace'])
                rep['applied'] += 1
            elif tgt[field].count(e['replace']) and e['replace']:
                rep['applied'] += 1  # already in place
            else:
                rep['failed'].append({'id': i, 'count': tgt[field].count(e['find']), 'find': e['find'][:60], 'why': e['why'][:120]})
    b['tail'] = open(os.path.join(HERE, 'work/appendices.fragment'), encoding='utf-8').read()
    for g in load(os.path.join(HERE, 'work/global-replacements.json')) or []:
        n = 0
        for p in b['parts']:
            for fld in ('intro', 'duizhao', 'heading'):
                n += p[fld].count(g['find']); p[fld] = p[fld].replace(g['find'], g['replace'])
            for t in p['tiao']:
                for fld in ('title', 'body'):
                    n += t[fld].count(g['find']); t[fld] = t[fld].replace(g['find'], g['replace'])
        n += b['head'].count(g['find']); b['head'] = b['head'].replace(g['find'], g['replace'])
        report.setdefault('global-replacements', {'applied': 0, 'failed': []})['applied'] += n
    mv = load(os.path.join(HERE, 'work/moves-after-rounds.json')) or []
    B.apply(b, mv)
    report['moves-after-rounds'] = {'applied': len(mv), 'failed': []}
    json.dump(report, open(os.path.join(HERE, 'work/finish-report.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    for k, v in report.items():
        if 'applied' in v:
            print(k, 'applied %d, failed %d' % (v['applied'], len(v['failed'])))
            continue
        print(k, 'missing' if v.get('missing') else 'edits %d, failed %d, 條 losing content %d%s' % (
            v['edits'], len(v['failed']), len(v['lost']), ', ids differ' if v.get('ids') else ''))
    if '--report' in sys.argv:
        return
    json.dump(b, open(os.path.join(HERE, 'work/book-2.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    open(OUT, 'w', encoding='utf-8').write(B.render(b))
    subprocess.run([sys.executable, '-I', os.path.join(HERE, 'build_tables.py')], check=True)
    r = subprocess.run([sys.executable, '-I', os.path.join(HERE, 'verify_zh.py')], capture_output=True, text=True)
    print(r.stdout[-1500:])


if __name__ == '__main__':
    main()
