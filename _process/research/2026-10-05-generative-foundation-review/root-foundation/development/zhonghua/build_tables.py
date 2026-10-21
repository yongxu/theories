"""Generated tables of the ZH chapters (board item ZH).

    python3 -I build_tables.py          # rewrite every <!-- ZH-TABLE:name --> block in the two chapters
    python3 -I build_tables.py --print  # print the tables only

verify_zh.py imports TABLES and fails when a block in a chapter differs from what the data gives. Each table
is a function of the checked passages (passages.json), the name table (work/names-decisions.tsv) and the
triage verdicts (coverage.json), with the imported model for the source titles and the judgments' domains.

A source's era is read off its title: a pre-Qin work (the 周易 and its 傳, the Laozi, the Zhuangzi, the Mohist
canon, Xunzi, Mencius, the Analects, the 禮記 chapters, the military and Legalist books, the excavated Laozi
texts) unless it is a commentary or a later work; the later sources are classified one by one in LATER. The
pre-Qin class includes works whose date is disputed and may reach into Qin and Han (the 易傳, 大學 and 中庸,
the outer chapters of the Zhuangzi); the tables say so.
"""
import csv, json, re, sys
from collections import Counter, OrderedDict
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[5]
MODEL = ROOT / 'sources/civilization-thought-v1.0/data/model.json'
CHAPTERS = [ROOT / 'theories/becoming/chapters/THE-THEORY-OF-BECOMING-ZHONGHUA.md',
            ROOT / 'theories/becoming/chapters/CIVILIZATION-THOUGHT-AND-BECOMING.md']

PRE = re.compile('周易|易傳|易传|道德經|道德经|老子|墨子|庄子|莊子|荀子|孟子|論語|论语|禮記|礼记|孙子|孫子|吴子|吳子|'
                 '司马法|司馬法|韓非子|韩非子|商君|公孫龍|公孙龙|郭店|帛書|尹文|鄧析|邓析|管子|鬼谷|呂氏|吕氏|國語|国语|'
                 '左傳|左传|尚書|尚书|詩經|诗经')
LATE = re.compile('伊川|本義|本义|正義|正义|略例|章句|注|註|疏|苏辙|蘇轍|河上公|集解|語類|语类|外傳|外传')
ERAS = ['先秦', '秦汉', '魏晋南北朝', '隋唐', '宋元明', '明清']
LATER = [  # (id pattern, era): the sources outside the pre-Qin class, by their dates
    (r'LC-HS|CT1-S-SJ|CT1-S-HS|IN1-S01', '秦汉'),
    (r'YWH-L|CT1-S-ZL|IN1-S02|IN1-S03|FO1-S-SA|FO1-S-MMK|FO1-S-DIAMOND|FO2-SM|FO2-AM$|FO2-GW|FO2-QX|FO2-FH',
     '魏晋南北朝'),
    (r'YWH-H|YWH-Q|YWH-F|FO1-S-HEART|FO1-S-CY|FO1-S-NY|FO2-MH|FO2-XZG|FO2-KS$|FO2-KS-P|FO2-FQ|FO2-TJ|IN1-S0[4-7]',
     '隋唐'),
    (r'YD-CY|YD-ZX|LC-SZ|RU2-S-S\d|IN2-S0[1-6]|FO2-KS-C|RT1', '宋元明'),
    (r'YD-WF|RU2-S-V3Q|IN2-S0[78]|FO2-YJ|YWH-ATTR', '明清'),
]
KIND = OrderedDict([('agreement', '相合'), ('scope', '定域'), ('divergence', '相分')])
DOMAIN = OrderedDict([('yi', '易'), ('lao', '老子'), ('庄', '庄子'), ('道', '道家其他'), ('儒', '儒'), ('墨', '墨'),
                      ('名辩', '名辩'), ('法', '法'), ('兵', '兵'), ('佛', '佛'), ('三教互动', '三教互动'),
                      ('思想史与交涉', '思想史与交涉')])
FORM = OrderedDict([('古', '古名（单字或成词，取其古义）'), ('复', '复名（古已有之的复合）'),
                    ('新', '新组合（由古字组成，本编约定）')])

_model = None


def model():
    global _model
    if _model is None:
        _model = json.loads(MODEL.read_text(encoding='utf-8'))
    return _model


def era(s):
    t = re.sub(r'（[^）]*）|\([^)]*\)', '', s['title'])
    if PRE.search(t) and not LATE.search(t):
        return '先秦'
    for pat, e in LATER:
        if re.match(pat, s['id']):
            return e
    raise ValueError('source %s (%s) has no era' % (s['id'], s['title']))


def eras():
    return {s['id']: era(s) for s in model()['sources']}


def cluster_titles():
    return {c['key']: c['title'] for c in json.loads((HERE / 'clusters.json').read_text(encoding='utf-8'))}


def placements(P, verdicts):
    """Every flagged judgment's place in its cluster: an entry's kind, a parallel's entry's kind, or 'rejected'."""
    kind_of = {(c, e['id']): e['kind'] for c, d in P.items() for e in d['entries']}
    by_id = {}
    for (c, i), k in kind_of.items():
        by_id.setdefault(i, k)
    out = {}
    for c, d in P.items():
        for e in d['entries']:
            for r in e['record_ids']:
                if verdicts.get(r, {}).get('c') == c:
                    out[r] = e['kind']
        for p in d['parallels']:
            t = p.get('same_as_entry', '')
            m = re.match(r'(C\d\d)\s*[:/：]\s*(.+)$', t)
            out[p['record_id']] = kind_of.get((c, t)) or (m and kind_of.get((m.group(1), m.group(2).strip()))) \
                or by_id.get(m.group(2).strip() if m else t)
        for r in d['rejected']:
            out[r['record_id']] = 'rejected'
    return out


def row(cells):
    return '| ' + ' | '.join(str(x) for x in cells) + ' |'


def t_clusters(P, rows, verdicts):
    titles = cluster_titles()
    flagged = Counter(v['c'] for v in verdicts.values() if v['c'] != '-')
    names = Counter(r['篇'] for r in rows)
    out = [row(['簇', '题', '所标判断', '条目', '相合', '定域', '相分', '并列', '不取', '名']),
           row(['---'] + ['---'] + ['---:'] * 8)]
    tot = Counter()
    for c in sorted(P):
        d = P[c]
        k = Counter(e['kind'] for e in d['entries'])
        cells = [flagged[c], len(d['entries']), k['agreement'], k['scope'], k['divergence'], len(d['parallels']),
                 len(d['rejected']), names[c]]
        for key, n in zip(['f', 'e', 'a', 's', 'd', 'p', 'r', 'n'], cells):
            tot[key] += n
        out.append(row([c, titles[c]] + cells))
    out.append(row(['合计', ''] + [tot[k] for k in ['f', 'e', 'a', 's', 'd', 'p', 'r', 'n']]))
    return '\n'.join(out)


def t_domains(P, rows, verdicts):
    dom = {r['id']: r['domain'] for r in model()['relations']}
    place = placements(P, verdicts)
    grid = {d: Counter() for d in DOMAIN}
    for r, v in verdicts.items():
        g = grid[dom[r]]
        g['all'] += 1
        if v['c'] == '-':
            g['none'] += 1
        else:
            g[place.get(r) or 'none'] += 1
    out = [row(['脉络之域', '判断', '相合', '定域', '相分', '不取', '未标', '相分占已对应']),
           row(['---'] + ['---:'] * 7)]
    tot = Counter()
    for d, label in DOMAIN.items():
        g = grid[d]
        mapped = g['agreement'] + g['scope'] + g['divergence']
        out.append(row([label, g['all'], g['agreement'], g['scope'], g['divergence'], g['rejected'], g['none'],
                        '%d%%' % round(100 * g['divergence'] / mapped) if mapped else '—']))
        tot.update(g)
    mapped = tot['agreement'] + tot['scope'] + tot['divergence']
    out.append(row(['合计', tot['all'], tot['agreement'], tot['scope'], tot['divergence'], tot['rejected'],
                    tot['none'], '%d%%' % round(100 * tot['divergence'] / mapped)]))
    return '\n'.join(out)


def t_eras(P, rows, verdicts):
    E = eras()
    grid = {e: Counter() for e in ERAS}
    for d in P.values():
        for e in d['entries']:
            grid[E[e['source_id']]][e['kind']] += 1
    out = [row(['所据文本之时代', '条目', '相合', '定域', '相分', '相分占']), row(['---'] + ['---:'] * 5)]
    tot = Counter()
    for e in ERAS:
        g = grid[e]
        n = sum(g.values())
        out.append(row([e, n, g['agreement'], g['scope'], g['divergence'],
                        '%d%%' % round(100 * g['divergence'] / n) if n else '—']))
        tot.update(g)
    n = sum(tot.values())
    out.append(row(['合计', n, tot['agreement'], tot['scope'], tot['divergence'],
                    '%d%%' % round(100 * tot['divergence'] / n)]))
    return '\n'.join(out)


def witness(r):
    for q in [q for q in r['引'].split('／') if q.strip() not in ('', '—')]:
        return q.split('@')[1] if '@' in q else None
    return None


def t_names(P, rows, verdicts):
    E = eras()
    checked = {r['名']: r for r in json.loads((HERE / 'work/names-checked.json').read_text(encoding='utf-8'))}
    grid = {f: Counter() for f in FORM}
    for r in rows:
        found = [f['source_id'] for q in checked[r['名']]['quotes'] for f in q['found']]
        g = grid[r['式']]
        g['all'] += 1
        if not found:
            g['none'] += 1
        elif E[found[0]] == '先秦':
            g['pre'] += 1
        else:
            g['later'] += 1
    out = [row(['名之来历', '名', '引文见于先秦文本', '引文只见于后世文本', '未录引文']), row(['---'] + ['---:'] * 4)]
    tot = Counter()
    for f, label in FORM.items():
        g = grid[f]
        out.append(row([label, g['all'], g['pre'], g['later'], g['none']]))
        tot.update(g)
    out.append(row(['合计', tot['all'], tot['pre'], tot['later'], tot['none']]))
    return '\n'.join(out)


PIAN = OrderedDict([('C16', '凡例'), ('C01', '篇一'), ('C02', '篇二'), ('C03', '篇三'), ('C04', '篇四'), ('C05', '篇五'),
                    ('C06', '篇六'), ('C07', '篇七'), ('C17', '篇八'), ('C08', '篇九'), ('C09', '篇十'), ('C10', '篇十一'),
                    ('C11', '篇十二'), ('C12', '篇十三'), ('C13', '篇十四'), ('C14', '篇十五'), ('C15', '篇十六')])


def cell(x):
    return (x or '—').replace('|', '／').replace('\n', ' ').strip() or '—'


def t_namelist(P, rows, verdicts):
    """The 名表 of the 中华本: every name by the 篇 that defines it, with its anchor, witness and what it does not carry."""
    sys.path.insert(0, str(HERE / 'work'))
    from simplify import simp
    checked = {r['名']: r for r in json.loads((HERE / 'work/names-checked.json').read_text(encoding='utf-8'))}
    titles = cluster_titles()
    out = []
    for c, pian in PIAN.items():
        rs = [r for r in rows if r['篇'] == c]
        out += ['### 名组：%s' % titles[c], '', '| 名 | 所名 | 锚 | 出处 | 注 |', '|---|---|---|---|---|']
        for r in rs:
            n = r['名']
            sn = simp(n)
            q = ['「%s」〔%s〕' % (x['found'][0]['text'].replace('\n', ''), x['found'][0]['source_id'])
                 for x in checked[n]['quotes'] if x['found']]
            anc = '；'.join('`%s`' % a for a in checked[n]['anchors']) or '—'
            out.append('| %s%s | %s | %s | %s | %s |' % (sn, '' if sn == n else '（%s）' % n, cell(r['所名']), anc,
                                                        '；'.join(q) or ('新组合' if r['式'] == '新' else '—'), cell(r['注'])))
        out.append('')
    return '\n'.join(out).rstrip()


def t_notadopted(P, rows, verdicts):
    rs = list(csv.DictReader(open(HERE / 'work/symbols-not-adopted.tsv', encoding='utf-8'), delimiter='\t'))
    out = ['| 字 | 决定 | 理由 | 相关条目 |', '|---|---|---|---|']
    for r in rs:
        out.append('| %s | %s | %s | %s |' % (r['字'], cell(r['决定']), cell(r['理由']), cell(r['条目'])))
    return '\n'.join(out)


TABLES = {'clusters': t_clusters, 'domains': t_domains, 'eras': t_eras, 'names': t_names, 'namelist': t_namelist,
          'notadopted': t_notadopted}


def load():
    P = json.loads((HERE / 'passages.json').read_text(encoding='utf-8'))['clusters']
    rows = list(csv.DictReader(open(HERE / 'work/names-decisions.tsv', encoding='utf-8'), delimiter='\t'))
    verdicts = json.loads((HERE / 'coverage.json').read_text(encoding='utf-8'))['verdicts']
    return P, rows, verdicts


def main():
    data = load()
    if '--print' in sys.argv:
        for k, f in TABLES.items():
            print('##', k)
            print(f(*data))
        return
    for ch in CHAPTERS:
        if not ch.exists():
            continue
        t = ch.read_text(encoding='utf-8')
        new = re.sub(r'(<!-- ZH-TABLE:(\w+) -->\n)(.*?)(<!-- /ZH-TABLE -->)',
                     lambda m: m.group(1) + TABLES[m.group(2)](*data) + '\n' + m.group(4), t, flags=re.S)
        if new != t:
            ch.write_text(new, encoding='utf-8')
            print('wrote', ch.relative_to(ROOT))


if __name__ == '__main__':
    main()
