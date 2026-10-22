"""The fidelity count (FC1; FIDELITY.md §2): English counterparts and the pairing of (條, declaration).

E1 is taken from the canonical chapter §0–§7, and §8.6 and §9 for 凡例 items. Code spans are protected; sentences are
split at . or ; followed by a capital, a code span or (. A clause is the text before a parenthetical that holds code
spans, citing those spans; a bullet head "- `a` (with `b`)?: text" is a clause citing a (and b); a sentence with code
spans outside parentheses is a clause at sentence level. Each cited short name is resolved in the context of the 條:
among resolve_decl and suffix candidates, the one in the 條's 證 set. Where several clauses cite d, the primary is the
one citing the fewest other declarations, ties by first occurrence; the others are logged. E2 (fallback): the laws[].en
of a record cited in the 證 whose law names d. Records' laws also give the genre-matched EN-rec and ZH-rec segments.

    python3 -I fidelity/extract_en.py      # needs data/tiao.jsonl; writes data/en_clauses.jsonl and data/pairs.jsonl
"""
import json, re, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
KIT = HERE.parent
ROOT = KIT.parents[5]
sys.path.insert(0, str(KIT / 'work'))
import resolve as R  # noqa: E402

EN = ROOT / 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
RECORDS = ROOT / 'theories/becoming/results/records'
DATA = HERE / 'data'
SPAN = re.compile(r'`([^`]+)`')
NAMEISH = re.compile(r"^[A-Za-z][\w.'₀-₉]*$")


def sections(lines):
    """§0–§7 (from '## 0.' to '## The theorem map'), and §8.6 and §9 apart."""
    main, extra, mode = [], [], None
    for i, line in enumerate(lines):
        if line.startswith('## 0. '):
            mode = 'main'
        elif line.startswith('## The theorem map'):
            mode = None
        elif line.startswith('### 8.6 ') or line.startswith('## 9. '):
            mode = 'extra'
        elif mode == 'extra' and (line.startswith('### 8.7') or line.startswith('## 10. ')):
            mode = None
        if mode == 'main':
            main.append((i + 1, line))
        elif mode == 'extra':
            extra.append((i + 1, line))
    return main, extra


def section_of(lines_with_no):
    sec, out = '', []
    for no, line in lines_with_no:
        m = re.match(r'^#{2,3} ((?:\d+\.)?\d+(?:\.\d+)?)', line)
        if m:
            sec = m.group(1).rstrip('.')
        out.append((no, sec, line))
    return out


def protect(text):
    spans = []

    def sub(m):
        spans.append(m.group(1))
        return '\x00%d\x00' % (len(spans) - 1)
    return SPAN.sub(sub, text), spans


def restore(text, spans):
    return re.sub(r'\x00(\d+)\x00', lambda m: '`%s`' % spans[int(m.group(1))], text)


def names_in(text, spans):
    return [spans[int(i)] for i in re.findall(r'\x00(\d+)\x00', text) if NAMEISH.match(spans[int(i)])]


def top_parens(s):
    """Spans (start, end) of the top-level parenthetical groups, nesting respected."""
    out, depth, start = [], 0, None
    for i, ch in enumerate(s):
        if ch == '(':
            if depth == 0:
                start = i
            depth += 1
        elif ch == ')' and depth:
            depth -= 1
            if depth == 0:
                out.append((start, i))
    return out


def gaps(groups, n):
    pos, out = 0, []
    for a, b in groups:
        out.append((pos, a))
        pos = b + 1
    out.append((pos, n))
    return out


def split_sentences(body):
    """Split at . or ; followed by whitespace and a capital, a code span or (, outside parentheses."""
    out, depth, start, i = [], 0, 0, 0
    while i < len(body):
        ch = body[i]
        if ch == '(':
            depth += 1
        elif ch == ')' and depth:
            depth -= 1
        elif ch in '.;' and depth == 0:
            m = re.match(r'\s+(?=[A-Z\x00(])', body[i + 1:])
            if m:
                out.append(body[start:i + 1])
                start = i + 1 + m.end()
                i = start
                continue
        i += 1
    out.append(body[start:])
    return [x for x in out if x.strip()]


def clauses_of(par, spans):
    """Clauses of one paragraph (already protected)."""
    out = []
    m = re.match(r'^\s*[-*] (\x00\d+\x00)(?: \(with (\x00\d+\x00)\))?: (.*)$', par)
    body = re.sub(r'^\s*[-*] ', '', par)
    if m:
        cites = names_in(m.group(1) + (m.group(2) or ''), spans)
        if cites:
            # the bullet head cites a (and b) for its first sentence; the rest is read by the sentence rules
            first = split_sentences(m.group(3))
            out.append({'text': restore(re.sub(r'\([^()]*\x00[^()]*\)', '', first[0]).strip() if first else '', spans),
                        'cites': cites, 'kind': 'bullet'})
            body = m.group(3)
    for sent in split_sentences(body):
        pos = 0
        groups = top_parens(sent)
        for a, b in groups:
            inner = sent[a + 1:b]
            cites = names_in(inner, spans)
            if cites:
                text = sent[pos:a].strip(' ,;:')
                if text:
                    out.append({'text': restore(text, spans), 'cites': cites, 'kind': 'paren'})
                pos = b + 1
        outside = ''.join(sent[x:y] for x, y in gaps(groups, len(sent)))
        cites = names_in(outside, spans)
        if cites:
            out.append({'text': restore(sent, spans).strip(), 'cites': cites, 'kind': 'sentence'})
    return out


def candidates(name):
    cur, _ = R.resolve_decl(name)
    c = {cur} if cur else set()
    tail = name.split('.')
    for k in range(1, min(3, len(tail)) + 1):
        suf = '.'.join(tail[-k:])
        c |= {d for d in R.DECLS if d.endswith('.' + suf)}
    return c


def main():
    lines = EN.read_text(encoding='utf-8').split('\n')
    main_part, extra_part = sections(lines)
    clauses = []
    for part, tag in ((main_part, 'main'), (extra_part, 'extra')):
        for no, sec, line in section_of(part):
            if not line.strip() or line.startswith('#') or line.startswith('|') or line.startswith('```'):
                continue
            prot, spans = protect(line)
            for c in clauses_of(prot, spans):
                c.update({'id': 'en%05d' % len(clauses), 'line': no, 'section': sec, 'part': tag})
                c['cands'] = sorted(set().union(*[candidates(n) for n in c['cites']])) if c['cites'] else []
                clauses.append(c)
    DATA.mkdir(exist_ok=True)
    with open(DATA / 'en_clauses.jsonl', 'w', encoding='utf-8') as f:
        for c in clauses:
            f.write(json.dumps(c, ensure_ascii=False) + '\n')
    recs = {}
    for p in RECORDS.glob('*.json'):
        d = json.loads(p.read_text(encoding='utf-8'))
        recs[d['id']] = d
    tiao = [json.loads(l) for l in open(DATA / 'tiao.jsonl', encoding='utf-8')]
    pairs, stats = [], {'tiao_with_e1': 0, 'pairs_e1': 0, 'pairs_e2': 0, 'unmatched_decls': 0}
    for t in tiao:
        zset = set(t['decls'])
        allowed = ('main', 'extra') if t['pian'] == '凡例' else ('main',)
        got = False
        for d in t['decls']:
            hits = []
            for c in clauses:
                if c['part'] not in allowed:
                    continue
                if d in c['cands']:
                    # resolution in the 條's context: each cite resolves to its candidate in the 證 set
                    ctx = [x for x in c['cands'] if x in zset]
                    hits.append((len(set(ctx)) - 1 if ctx else len(c['cites']) - 1, c['line'], c))
            e1 = sorted(hits, key=lambda h: (h[0], h[1]))
            e2 = []
            for rid in t['records']:
                for law in recs.get(rid, {}).get('laws') or []:
                    if d in (law.get('declarations') or []):
                        e2.append({'record': rid, 'en': law.get('en', ''), 'zh': law.get('zh', ''),
                                   'declarations': law.get('declarations')})
            row = {'tiao': t['id'], 'decl': d, 'pian': t['pian'],
                   'e1': ({'clause': e1[0][2]['id'], 'text': e1[0][2]['text'], 'section': e1[0][2]['section'],
                           'cites_in_context': sorted({x for x in e1[0][2]['cands'] if x in zset} or {d})}
                          if e1 else None),
                   'e1_others': [h[2]['id'] for h in e1[1:]], 'e2': e2[:1], 'rec_laws': e2}
            if e1:
                stats['pairs_e1'] += 1
                got = True
            elif e2:
                stats['pairs_e2'] += 1
            else:
                stats['unmatched_decls'] += 1
            pairs.append(row)
        stats['tiao_with_e1'] += got
    with open(DATA / 'pairs.jsonl', 'w', encoding='utf-8') as f:
        for p in pairs:
            f.write(json.dumps(p, ensure_ascii=False) + '\n')
    stats['clauses'] = len(clauses)
    print(json.dumps(stats))


if __name__ == '__main__':
    main()
