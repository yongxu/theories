"""Check the ZH kit and the 中华本 against the repository (board item ZH).

    python3 -I verify_zh.py [--receipt PATH] [--chapter PATH]    # exit 1 on any failure

Everything is checked against repository copies only:
  1. the import: every file of sources/civilization-thought-v1.0 hashes to its PROVENANCE.json entry;
  2. coverage: coverage.json has one verdict for every judgment (relation) of the imported model;
  3. passages: every judgment the sweep flagged for a cluster lies in exactly one place there (an entry, a
     parallel or a rejection); every id an entry cites exists in the model (a judgment, a reading unit, a sense
     or a chapter of the Laozi); every fragment is in its source's frozen
     text, character for character (whitespace may differ); every declaration is in the audited list of the
     newest core receipt (or is a module of it), or of a periphery receipt (Mathlib, axioms reported; listed
     apart); every result record exists;
  4. names: one name per concept, no two names alike once simplified, every anchor current, every quotation in
     the frozen text it names;
  5. the chapter (06-CLASSICAL-TEXTS; a missing one is a failure): every Lean name it cites in backticks is exactly one
     audited declaration, module or namespace of the newest core receipt (or a listed periphery declaration), read
     whole, with `Becoming.` put before it, or with the namespace the chapter states for that name's section or table
     (a line saying that `Becoming.X.` is left out, 省去: in a section's opening, before its first ### heading, for the
     section; in a table's header, for the table) put before it; a name that resolves to none, or to more than one, of
     these fails, but for OUTSIDE, which the chapter names as off the spine;
     every record link exists; every 「…」〔ID〕 quotation is in source ID's frozen text, every 对照 line names
     entries of the map with the kind the map gives them, and the generated tables equal what the data gives (06
     has none of these three today); and nine numbers its section 七 states of the map and the name table are the
     data's (STATED). A chapter in which no Lean name is found fails. Its other quotations and numbers are not
     checked. The three chapters this checked until RA moved them to history/ (23 October 2026) are frozen there
     and not checked.
Failures are printed, not written to a file.
"""
import argparse, csv, glob, hashlib, json, os, re, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[5]
SRC = ROOT / 'sources/civilization-thought-v1.0'
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RECORDS = ROOT / 'theories/becoming/results/records'
CHAPTER = ROOT / 'theories/becoming/chapters/06-CLASSICAL-TEXTS.md'
# Lean modules the chapter names outside the core receipt, each with the file it is; the chapter says each is off the spine.
OUTSIDE = {'SituatedPractice': ROOT / 'experiments/integrated-correction/general-framework/generative-basis/'
                                     'noninstrumental-concern/SituatedPractice.lean'}
IDENT = re.compile(r"[A-Za-z_][A-Za-z0-9_'.₀-₉]*")


def stated(n):
    """The numbers the chapter's section 七 states, each as the words it is stated in, from the data's counts n."""
    return [f"v1.0 的 {n['judgments']:,} 条判断",
            f"{n['flagged']:,} 条涉及其结构",
            f"条目共 {n['entries']:,} 个",
            f"（相合 {n['agreement']}，定域 {n['scope']}，相分 {n['divergence']}）",
            f"另有 {n['judgments'] - n['flagged']:,} 条没有脊柱可读的结构",
            f"以 {n['names']} 个古典之名",
            f"已对应的 {n['flagged'] - n['rejected']:,} 条计（{n['flagged']:,} 条除去读后不取之 {n['rejected']} 条",
            f"{n['names']} 名中 {n['anchored']} 个录有锚，其余 {n['names'] - n['anchored']} 个",
            f"{n['names']} 个名中 {n['quoted']} 个录有引文"]
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

    # periphery declarations (Mathlib; axioms reported) from the periphery receipts, accepted and counted apart
    periphery = set()
    for f in PKG.parent.glob('*/*verification.json'):
        try:
            for m in json.loads(f.read_text()).get('modules', []):
                if m.get('layer') == 'periphery':
                    periphery |= {d['name'] for d in m.get('declarations', [])}
        except (ValueError, AttributeError):
            pass
    used_periphery = set()

    def decl_ok(n):
        n = n.strip('`')
        full = n if n.startswith('Becoming.') or n in decls else 'Becoming.' + n
        if full in periphery and full not in decls:
            used_periphery.add(full)
            return True
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

    # 5. the chapter
    n_q = n_d = n_l = n_dz = n_st = n_out = 0
    tot = {}
    for v in counts.values():
        for k, n in v.items():
            tot[k] = tot.get(k, 0) + n
    n = {'judgments': len(rel_ids), 'flagged': sum(1 for v in verdicts.values() if v['c'] != '-'),
         'entries': n_entries, 'names': len(rows),
         'rejected': sum(1 for c, d in P.items() for r in d['rejected'] if verdicts.get(r['record_id'], {}).get('c') == c),
         'anchored': sum(1 for r in rows if r['锚'].strip() not in ('', '—')),
         'quoted': sum(1 for r in rows if r['引'].strip() not in ('', '—')), **tot}
    for ch in [args.chapter]:
        if not ch.exists():
            fail.append('no chapter at %s' % ch)
            continue
        t = ch.read_text(encoding='utf-8')
        for s in stated(n):
            n_st += 1
            if s not in t:
                fail.append('%s: does not state, as the data gives it: %s' % (ch.name, s))
        for m in re.finditer(r'「([^」]{2,})」〔([A-Za-z0-9\-]+)〕', t):
            n_q += 1
            if not in_text(m.group(2), m.group(1)):
                fail.append('%s: quotation not in %s: %s' % (ch.name, m.group(2), m.group(1)[:30]))
        spaces = {'.'.join(d.split('.')[:i]) for d in decls for i in range(1, d.count('.') + 1)}
        known = decls | modules | spaces | periphery
        section_ns, table_ns, opening = None, None, False
        for line in t.split('\n'):
            if line.startswith('## '):
                section_ns, opening = None, True
            elif line.startswith('### '):
                opening = False
            left_out = [s.rstrip('.') for s in re.findall(r'`(Becoming\.[A-Za-z0-9_.]+\.)`', line)] if '省去' in line else []
            for s in left_out:
                if s not in spaces and s not in modules:
                    fail.append('%s: the namespace it says is left out, %s, is not in receipt %s' % (ch.name, s, receipt.parent.name))
            if line.startswith('|'):
                if left_out:
                    table_ns = left_out[0]
            else:
                table_ns = None
                if left_out and opening:
                    section_ns = left_out[0]
            for m in re.finditer(r'`([^`\n]+)`', line):
                x = m.group(1).rstrip('.')               # a name ending in a dot names its namespace (a prefix left out)
                if len(x) < 2 or not IDENT.fullmatch(x) or x in left_out:
                    continue
                if '省去' in line and x + '.' == m.group(1):     # a namespace named as an example on the line that says so
                    if x not in known and 'Becoming.' + x not in known:
                        fail.append('%s: namespace %s is not in receipt %s' % (ch.name, x, receipt.parent.name))
                    continue
                if x in OUTSIDE:
                    n_out += 1
                    if not OUTSIDE[x].exists():
                        fail.append('%s: %s, named as outside the receipt, is not at %s' % (ch.name, x, OUTSIDE[x]))
                    continue
                n_d += 1
                cands = {x, 'Becoming.' + x} | {ns + '.' + x for ns in (section_ns, table_ns) if ns}
                hits = sorted(c for c in cands if c in known)
                if not hits:
                    fail.append('%s: Lean name %s is not in receipt %s' % (ch.name, x, receipt.parent.name))
                elif len(hits) > 1:
                    fail.append('%s: Lean name %s is ambiguous: %s' % (ch.name, x, ', '.join(hits)))
        if not n_d:
            fail.append('%s: no Lean name found to check' % ch.name)
        for m in re.finditer(r'\]\(\.\./results/records/([a-z0-9\-]+)\.md\)', t):
            n_l += 1
            if m.group(1) not in records:
                fail.append('%s: record link %s' % (ch.name, m.group(1)))
        # 对照 lines: each names entries of the map, and the kind it states is the kind the map gives them
        PIAN_C = {'凡例': 'C16', '篇一': 'C01', '篇二': 'C02', '篇三': 'C03', '篇四': 'C04', '篇五': 'C05', '篇六': 'C06',
                  '篇七': 'C07', '篇八': 'C17', '篇九': 'C08', '篇十': 'C09', '篇十一': 'C10', '篇十二': 'C11',
                  '篇十三': 'C12', '篇十四': 'C13', '篇十五': 'C14', '篇十六': 'C15'}
        KIND_ZH = {'相合': 'agreement', '定域': 'scope', '相分': 'divergence'}
        kinds_of = {}
        for cc, d in P.items():
            for e in d['entries']:
                kinds_of.setdefault(e['id'], {})[cc] = e['kind']
        cur, in_dz = None, False
        for line in t.split('\n'):
            h = re.match(r'^## (\S+?)(?:\u3000|\s|$)', line)
            if h:
                cur, in_dz = PIAN_C.get(h.group(1)), False
            if line.startswith('#### 对照'):
                in_dz = True
                continue
            if line.startswith('#'):
                in_dz = False
            if not (in_dz and line.startswith('- ')):
                continue
            n_dz += 1
            k = re.search(r'——\s*(相合|定域|相分)', line)
            ids = [x for x in re.findall(r'[（(]([a-z0-9:]+(?:-[a-z0-9]+)+)[）)]', line)]
            if not k or not ids:
                fail.append('%s: 对照 line without a kind or an entry id: %s' % (ch.name, line[:40]))
                continue
            for i in ids:
                ks = kinds_of.get(i)
                if not ks:
                    fail.append('%s: 对照 entry %s not in the map' % (ch.name, i))
                elif KIND_ZH[k.group(1)] != ks.get(cur, next(iter(ks.values()))) and KIND_ZH[k.group(1)] not in ks.values():
                    fail.append('%s: 对照 entry %s is %s in the map, the line says %s' % (ch.name, i, '/'.join(ks.values()), k.group(1)))
        for m in re.finditer(r'<!-- ZH-TABLE:(\w+) -->\n(.*?)<!-- /ZH-TABLE -->', t, re.S):
            want = TABLES[m.group(1)](P, rows, verdicts)
            if m.group(2).strip() != want.strip():
                fail.append('%s: generated table %s differs from the data (run build_tables.py)' % (ch.name, m.group(1)))

    for f in fail[:60]:
        print('FAIL', f)
    if len(fail) > 60:
        print('… and %d more' % (len(fail) - 60))
    e_decls = {x.strip('`') if x.strip('`').startswith('Becoming.') else 'Becoming.' + x.strip('`')
               for d in P.values() for e in d['entries'] for x in e['declarations']}
    e_recs = {x for d in P.values() for e in d['entries'] for x in e['records']}
    print('%s: %d files bound; %d judgments, %d flagged; %d entries (%s), %d fragments, %d declarations, %d records; '
          '%d names; '
          'chapter %s: %d quotations with a source id, %d Lean-name citations%s and %d named as off the spine, %d record links, '
          '%d 对照 lines, %d stated numbers; receipt %s; '
          'periphery declarations: %d'
          % ('FAILED' if fail else 'ok', len(prov['files']), len(rel_ids), n['flagged'],
             n_entries, ', '.join('%s %d' % kv for kv in sorted(tot.items())), n_frag, len(e_decls), len(e_recs),
             len(rows), args.chapter.name,
             n_q, n_d, '' if fail else ' (each exact)', n_out, n_l, n_dz, n_st, receipt.parent.name, len(used_periphery)))
    for x in sorted(used_periphery):
        print('  periphery:', x)
    sys.exit(1 if fail else 0)


sys.path.insert(0, str(HERE))
try:
    from build_tables import TABLES  # noqa: E402
except ImportError:
    TABLES = {}

if __name__ == '__main__':
    main()
