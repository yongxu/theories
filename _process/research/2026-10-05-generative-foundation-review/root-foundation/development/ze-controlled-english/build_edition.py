"""ZE: assemble the one source of both editions and the readable controlled English edition.

controlled-english.jsonl (this kit): one line per 條, in the 中华本's order, with its id, 篇, title, the 經 clause by
clause in Chinese (zh, from fidelity/data/tiao.jsonl) and in controlled English (en, from data/render-output/), the
declarations each clause states (FC1's final alignment, where it exists) and the number each 條 has in the English
edition (凡·三 → C.3, 一·十二 → 1.12, 纲·二 → T.2). In the English text, a cross-reference to a 條 id is rewritten to
that number; nothing else is changed.

experiments/wenli-reading-transfer/CONTROLLED-ENGLISH.md: the controlled English 經, by chapter, with the numbers.

    python3 -I build_edition.py
"""
import json, re
from pathlib import Path

HERE = Path(__file__).resolve().parent
FD = HERE.parent / 'zhonghua' / 'fidelity' / 'data'
ROOT = HERE.parents[5]
DOC = ROOT / 'experiments/wenli-reading-transfer/CONTROLLED-ENGLISH.md'
DIG = {'〇': 0, '一': 1, '二': 2, '三': 3, '四': 4, '五': 5, '六': 6, '七': 7, '八': 8, '九': 9}
TIAO_ID = re.compile(r'([凡纲]|[一二三四五六七八九十]+)·([一二三四五六七八九十]+)')
PIAN = {'凡例': ('C', 'Conventions: suppositions, proofs, readings and the marks of inference'), '论纲': ('T', 'Theses')}


def num(s):
    if s == '十':
        return 10
    if '十' in s:
        a, b = s.split('十')
        return (DIG[a] if a else 1) * 10 + (DIG[b] if b else 0)
    return DIG[s]


def number(tid):
    m = TIAO_ID.fullmatch(tid)
    head = {'凡': 'C', '纲': 'T'}.get(m.group(1)) or str(num(m.group(1)))
    return '%s.%d' % (head, num(m.group(2)))


def renumber(text):
    return TIAO_ID.sub(lambda m: number(m.group(0)), text)


def load(p):
    return [json.loads(l) for l in open(p, encoding='utf-8')]


def main():
    T = load(FD / 'tiao.jsonl')
    final = json.loads((FD / 'align_final.json').read_text())
    R = {r['tiao']: r for q in sorted((HERE / 'data/render-output').glob('batch_*.jsonl')) for r in load(q)}
    out = []
    for t in T:
        r = R[t['id']]
        fa = final.get(t['id'])
        assert [c['j'] for c in r['clauses']] == list(range(1, len(t['jing_clauses']) + 1)), t['id']
        out.append({'tiao': t['id'], 'number': number(t['id']), 'pian': t['pian'], 'title': t['title'],
                    'title_en': r['title_en'],
                    'clauses': [{'j': j, 'zh': z, 'en': renumber(c['en']).strip(),
                                 'states': fa.get(str(j), []) if fa else None}
                                for j, (z, c) in enumerate(zip(t['jing_clauses'], r['clauses']), 1)]})
    with open(HERE / 'controlled-english.jsonl', 'w', encoding='utf-8') as f:
        for x in out:
            f.write(json.dumps(x, ensure_ascii=False) + '\n')
    lines = ['# The controlled English edition of the 經',
             '',
             '23 October 2026. AI-written (board item ZE). This is not a chapter of the theory and not a translation of '
             'the canonical English chapter. It renders the 經 (the short statements) of every 條 of the '
             '[中华本](../../theories/becoming/chapters/THE-THEORY-OF-BECOMING-ZHONGHUA.md) into English, clause by clause, '
             'in the [English name table](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ze-controlled-english/names-en.tsv), '
             'which gives each of the 中华本\'s 449 names an English name, the sense it takes, what it does not carry, and the '
             'same Lean anchors. It was written as the control of the fidelity count ([CONTROLLED-ENGLISH-RESULTS.md](CONTROLLED-ENGLISH-RESULTS.md)): '
             'a code under the same discipline as the 經, in another language.',
             '',
             'Both editions share one source, [`controlled-english.jsonl`](../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ze-controlled-english/controlled-english.jsonl), '
             'which holds each 條\'s clauses in both languages with the declarations each clause states. Numbers: C.n are '
             'the conventions (凡例), T.n the theses (论纲), and k.n the n-th 條 of chapter k; a cross-reference uses the same '
             'numbers. The proofs (證), commentary (說) and comparisons stay in the 中华本.',
             '']
    cur = None
    for x in out:
        if x['pian'] != cur:
            cur = x['pian']
            if cur in PIAN:
                lines += ['## %s' % PIAN[cur][1], '']
            else:
                lines += ['## Chapter %d' % num(cur[1:]), '']
        lines += ['### %s %s' % (x['number'], x['title_en']), '', ' '.join(c['en'] for c in x['clauses']), '']
    DOC.write_text('\n'.join(lines), encoding='utf-8')
    print(len(out), '條 ->', HERE / 'controlled-english.jsonl', 'and', DOC)


if __name__ == '__main__':
    main()
