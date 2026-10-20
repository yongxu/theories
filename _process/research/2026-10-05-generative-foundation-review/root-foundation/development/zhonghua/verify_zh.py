"""Check the ZH kit and the 中华本 against the repository (board item ZH).

    python3 -I verify_zh.py [--receipt PATH] [--chapter PATH]    # exit 1 on any failure

Everything is checked against repository copies only:
  1. the import: every file of sources/civilization-thought-v1.0 hashes to its PROVENANCE.json entry;
  2. coverage: coverage.json has one verdict for every judgment (relation) of the imported model;
  3. passages: every judgment the sweep flagged for a cluster lies in exactly one place there (an entry, a
     parallel or a rejection); every id an entry cites exists in the model (a judgment, a reading unit, a sense
     or a chapter of the Laozi); every fragment is in its source's frozen
     text, character for character (whitespace may differ); every declaration is in the audited list of the
     newest core receipt (or is a module of it); every result record exists;
  4. names: one name per concept, no two names alike once simplified, every anchor current, every quotation in
     the frozen text it names;
  5. the chapters, when present: every 「…」〔ID〕 quotation is in source ID's frozen text, every `Becoming.…`
     declaration is current, every record link exists, and the generated tables equal what the data gives.
"""
import argparse, csv, glob, hashlib, json, os, re, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[5]
SRC = ROOT / 'sources/civilization-thought-v1.0'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RECORDS = ROOT / 'theories/becoming/results/records'
CHAPTER = ROOT / 'theories/becoming/chapters/THE-THEORY-OF-BECOMING-ZHONGHUA.md'
MAP_CHAPTER = ROOT / 'theories/becoming/chapters/CIVILIZATION-THOUGHT-AND-BECOMING.md'
sys.path.insert(0, str(HERE / 'work'))
from simplify import simp  # noqa: E402

PUNCT = r'[\s，。、；：！？「」『』〈〉《》“”‘’,.;:]*'


def pattern(phrase):
    return re.compile(PUNCT.join(map(re.escape, re.sub(r'[\s，。、；：]', '', phrase))))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--receipt', type=Path)
    ap.add_argument('--chapter', type=Path, default=CHAPTER)
    args = ap.parse_args()
    fail = []

    # 1. import
    prov = json.loads((SRC / 'PROVENANCE.json').read_text(encoding='utf-8'))
    for f in prov['files']:
        p = SRC / f['file']
        if not p.exists() or hashlib.sha256(p.read_bytes()).hexdigest() != f['sha256']:
            fail.append('import: %s differs from PROVENANCE.json' % f['file'])
    model = json.loads((SRC / 'data/model.json').read_text(encoding='utf-8'))
    if hashlib.sha256((SRC / 'data/model.json').read_bytes()).hexdigest() != prov['model_sha256']:
        fail.append('import: model sha256')
    text_of = {}
    cache = {}
    for s in model['sources']:
        tp = s.get('text_path')
        if tp:
            if tp not in cache:
                cache[tp] = (SRC / tp).read_text(encoding='utf-8')
            text_of[s['id']] = cache[tp]
    rel_ids = {r['id'] for r in model['relations']}
    model_ids = {x['id'] for v in model.values() if isinstance(v, list) for x in v if isinstance(x, dict) and 'id' in x}

    def in_text(sid, phrase):
        t = text_of.get(sid)
        return t is not None and pattern(phrase).search(t) is not None

    # 2. coverage
    cov = json.loads((HERE / 'coverage.json').read_text(encoding='utf-8'))
    if cov.get('model_sha256') != prov['model_sha256']:
        fail.append('coverage: model sha256')
    verdicts = cov['verdicts']
    if set(verdicts) != rel_ids:
        fail.append('coverage: %d verdicts for %d judgments' % (len(verdicts), len(rel_ids)))

    # 3. passages
    receipt = args.receipt or max((PKG / 'becoming-checks').glob('*/verification.json'))
    rec = json.loads(receipt.read_text())
    decls = {d['name'] for m in rec['modules'] for d in m['declarations']}
    modules = {m['module'] for m in rec['modules']} | {d.rsplit('.', 1)[0] for d in decls}
    records = {p.stem for p in RECORDS.glob('*.json')}

    def decl_ok(n):
        n = n.strip('`')
        full = n if n.startswith('Becoming.') or n in decls else 'Becoming.' + n
        return full in decls or full in modules

    P = json.loads((HERE / 'passages.json').read_text(encoding='utf-8'))['clusters']
    counts = {}
    n_frag = n_entries = 0
    for c, d in P.items():
        ids = {e['id'] for e in d['entries']}
        all_ids = {e['id'] for cc in P.values() for e in cc['entries']}
        placed = {}
        for e in d['entries']:
            n_entries += 1
            for r in e['record_ids']:
                placed.setdefault(r, []).append('entry')
                if r not in model_ids:
                    fail.append('passages %s/%s: id %s not in the model' % (c, e['id'], r))
            for fr in e['fragments']:
                n_frag += 1
                if not in_text(e['source_id'], fr):
                    fail.append('passages %s/%s: fragment not in %s: %s' % (c, e['id'], e['source_id'], fr[:30]))
            for x in e['declarations']:
                if not decl_ok(x):
                    fail.append('passages %s/%s: declaration %s not in receipt %s' % (c, e['id'], x, receipt.parent.name))
            for x in e['records']:
                if x not in records:
                    fail.append('passages %s/%s: record %s missing' % (c, e['id'], x))
            counts.setdefault(c, {}).setdefault(e['kind'], 0)
            counts[c][e['kind']] += 1
        for p in d['parallels']:
            placed.setdefault(p['record_id'], []).append('parallel')
            t = p.get('same_as_entry', '')
            m = re.match(r'(C\d\d)\s*[:/：]\s*(.+)$', t)
            if t and t not in ids and not (m and m.group(2).strip() in all_ids):
                fail.append('passages %s: parallel %s points at %s' % (c, p['record_id'], t))
        for r in d['rejected']:
            placed.setdefault(r['record_id'], []).append('rejected')
        for r, v in verdicts.items():
            if v['c'] == c and len(placed.get(r, [])) != 1:
                fail.append('passages %s: flagged judgment %s placed %d times' % (c, r, len(placed.get(r, []))))

    # 4. names
    rows = list(csv.DictReader(open(HERE / 'work/names-decisions.tsv', encoding='utf-8'), delimiter='\t'))
    simp_seen = {}
    for r in rows:
        simp_seen.setdefault(simp(r['名']), []).append(r['名'])
        for a in [a.strip() for a in r['锚'].split('；') if a.strip() not in ('', '—')]:
            if not decl_ok(a):
                fail.append('names %s: anchor %s' % (r['名'], a))
        for q in [q for q in r['引'].split('／') if q.strip() not in ('', '—')]:
            if '@' in q:
                q, sid = q.split('@')
                if not in_text(sid, q):
                    fail.append('names %s: quotation not in %s: %s' % (r['名'], sid, q))
            elif not any(pattern(q).search(t) or pattern(simp(q)).search(t) for t in cache.values()):
                fail.append('names %s: quotation not found: %s' % (r['名'], q))
    for k, v in simp_seen.items():
        if len(v) > 1:
            fail.append('names: %s and %s coincide as %s' % (v[0], v[1], k))
    if len({r['名'] for r in rows}) != len(rows):
        fail.append('names: a name appears twice')

    # 5. chapters
    n_q = n_d = n_l = 0
    for ch in [args.chapter, MAP_CHAPTER]:
        if not ch.exists():
            continue
        t = ch.read_text(encoding='utf-8')
        for m in re.finditer(r'「([^」]{2,})」〔([A-Za-z0-9\-]+)〕', t):
            n_q += 1
            if not in_text(m.group(2), m.group(1)):
                fail.append('%s: quotation not in %s: %s' % (ch.name, m.group(2), m.group(1)[:30]))
        for m in re.finditer(r'`(Becoming\.[A-Za-z0-9_.\'₀-₉]+)`', t):
            n_d += 1
            if not decl_ok(m.group(1)):
                fail.append('%s: declaration %s' % (ch.name, m.group(1)))
        for m in re.finditer(r'\]\(\.\./results/records/([a-z0-9\-]+)\.md\)', t):
            n_l += 1
            if m.group(1) not in records:
                fail.append('%s: record link %s' % (ch.name, m.group(1)))
        for m in re.finditer(r'<!-- ZH-TABLE:(\w+) -->\n(.*?)<!-- /ZH-TABLE -->', t, re.S):
            want = TABLES[m.group(1)](P, rows, verdicts)
            if m.group(2).strip() != want.strip():
                fail.append('%s: generated table %s differs from the data (run build_tables.py)' % (ch.name, m.group(1)))

    open(HERE / "work/verify-failures.txt", "w", encoding="utf-8").write("\n".join(fail) + "\n")
    for f in fail[:60]:
        print('FAIL', f)
    if len(fail) > 60:
        print('… and %d more' % (len(fail) - 60))
    tot = {}
    for v in counts.values():
        for k, n in v.items():
            tot[k] = tot.get(k, 0) + n
    print('%s: %d files bound; %d judgments, %d flagged; %d entries (%s), %d fragments; %d names; '
          'chapters: %d quotations, %d declarations, %d record links; receipt %s'
          % ('FAILED' if fail else 'ok', len(prov['files']), len(rel_ids), sum(1 for v in verdicts.values() if v['c'] != '-'),
             n_entries, ', '.join('%s %d' % kv for kv in sorted(tot.items())), n_frag, len(rows), n_q, n_d, n_l, receipt.parent.name))
    sys.exit(1 if fail else 0)


sys.path.insert(0, str(HERE))
try:
    from build_tables import TABLES  # noqa: E402
except ImportError:
    TABLES = {}

if __name__ == '__main__':
    main()
