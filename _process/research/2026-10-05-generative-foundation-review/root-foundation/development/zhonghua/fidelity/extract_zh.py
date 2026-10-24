"""The fidelity count (board item FC1; design experiments/wenli-reading-transfer/FIDELITY.md §2): the 條 of the 中华本.

Splits the 中华本 at its `### ` headings under 凡例, 篇一–篇十六 and 论纲 (stopping at each `#### 对照` and at the
appendices), and for each 條 records its 經, the 經 split into clauses (at 。 and ；, a definition head ending in ：
kept with its body), its 說, the backticked names of its 證 resolved against the newest core receipt (work/resolve.py;
a unique suffix match where that fails; the ambiguous and unresolved logged), its record links, and the flags of
§2: a reading (讀（AI…）), a constructed example (有例), a double negation (不可非), a thesis (论纲).

    python3 -I fidelity/extract_zh.py        # writes fidelity/data/tiao.jsonl and prints the pilot figures
"""
import json, re, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
KIT = HERE.parent
ROOT = KIT.parents[5]
sys.path.insert(0, str(KIT / 'work'))
import resolve as R  # noqa: E402

BOOK = ROOT / 'theories/becoming/chapters/THE-THEORY-OF-BECOMING-ZHONGHUA.md'
OUT = HERE / 'data'
PIAN = re.compile(r'^## (凡例|篇[一二三四五六七八九十]+|论纲)')
STOP = re.compile(r'^(#### 对照|## 附录)')
HEAD = re.compile(r'^### (\S+)　(.+)$')
TICK = re.compile(r'`([^`]+)`')
REC = re.compile(r'\]\(\.\./results/records/([a-z0-9\-]+)\.md\)')
DECLS = R.DECLS


def resolve(n):
    cur, _ = R.resolve_decl(n)
    if cur:
        return cur, 'exact'
    short = n.strip('`').split('.')
    tail = '.'.join(short[-2:]) if len(short) > 1 else short[-1]
    cands = [d for d in DECLS if d.endswith('.' + tail) or d == tail]
    if len(cands) == 1:
        return cands[0], 'suffix'
    return None, 'ambiguous' if cands else 'unresolved'


def clauses(jing):
    """Split at 。 and ；, keeping a definition head that ends in ： with its body."""
    parts, buf = [], ''
    for ch in jing:
        buf += ch
        if ch in '。；':
            parts.append(buf.strip())
            buf = ''
    if buf.strip():
        parts.append(buf.strip())
    return [p for p in parts if p.strip('。； ')]


def main():
    lines = BOOK.read_text(encoding='utf-8').split('\n')
    pian, live, out, cur = None, False, [], None
    for line in lines:
        m = PIAN.match(line)
        if m:
            pian, live = m.group(1), True
            continue
        if STOP.match(line) or (line.startswith('## ') and not PIAN.match(line)):
            live = False
            cur = None
            continue
        if not live:
            continue
        h = HEAD.match(line)
        if h:
            cur = {'id': h.group(1), 'title': h.group(2), 'pian': pian, 'jing': '', 'shuo': '', 'zheng': ''}
            out.append(cur)
            continue
        if cur is None:
            continue
        for key, tag in (('jing', '**經**'), ('shuo', '**說**'), ('zheng', '**證**')):
            if line.startswith(tag):
                cur[key] = line[len(tag):].strip('　 ')
                cur['_last'] = key
                break
        else:
            if line.strip() and cur.get('_last') == 'shuo':
                cur['shuo'] += '\n' + line
    stats = {'tiao': 0, 'with_jing_and_zheng': 0, 'names': 0, 'exact': 0, 'suffix': 0, 'ambiguous': 0,
             'unresolved': 0, 'no_decl': 0}
    rows = []
    for t in out:
        t.pop('_last', None)
        stats['tiao'] += 1
        names = [n for n in TICK.findall(t['zheng']) if re.match(r"[A-Za-z][\w.'₀-₉]*$", n)]
        decls, bad = [], []
        for n in names:
            d, how = resolve(n)
            stats['names'] += 1
            stats[how] += 1
            if d:
                if d not in decls:
                    decls.append(d)
            else:
                bad.append({'name': n, 'how': how})
        if t['jing'] and t['zheng']:
            stats['with_jing_and_zheng'] += 1
        if not decls:
            stats['no_decl'] += 1
        text = t['jing'] + t['shuo']
        flags = {'reading': '讀（AI' in text or '讀，AI' in text, 'example': '有例' in t['jing'] or '构造之例' in text,
                 'double_negation': '不可非' in t['jing'], 'thesis': t['pian'] == '论纲'}
        rows.append({'id': t['id'], 'title': t['title'], 'pian': t['pian'], 'jing': t['jing'],
                     'jing_clauses': clauses(t['jing']), 'shuo': t['shuo'], 'decls': decls, 'unresolved': bad,
                     'records': REC.findall(t['zheng']), 'flags': flags})
    OUT.mkdir(exist_ok=True)
    with open(OUT / 'tiao.jsonl', 'w', encoding='utf-8') as f:
        for r in rows:
            f.write(json.dumps(r, ensure_ascii=False) + '\n')
    print(json.dumps(stats, ensure_ascii=False))


if __name__ == '__main__':
    main()
