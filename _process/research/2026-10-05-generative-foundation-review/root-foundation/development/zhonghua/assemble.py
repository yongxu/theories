"""Assemble the 中华本《变化论》 from the drafted 篇, their reviews, the preface and the appendices (board item ZH).

    python3 -I assemble.py            # write theories/becoming/chapters/THE-THEORY-OF-BECOMING-ZHONGHUA.md
    python3 -I assemble.py --report   # only report what would fail

Inputs: agents/draft-Cxx.json and agents/review-Cxx.json (harvested from the drafting workflow's journal by
harvest.py), work/redraft/Cxx.md where a 篇 was redrafted by hand (it replaces the draft, and the review's edits
are not applied to it), work/xu.fragment (the preface), work/appendices.fragment (the appendices, with generated blocks).
Each review edit names a substring that occurs exactly once in the draft; the edits are applied in order, and an
edit whose substring is not found exactly once is reported, not guessed. build_tables.py then fills the generated
blocks and verify_zh.py checks the result.
"""
import json, re, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[5]
OUT = ROOT / 'theories/becoming/chapters/THE-THEORY-OF-BECOMING-ZHONGHUA.md'
ORDER = ['C16', 'C01', 'C02', 'C03', 'C04', 'C05', 'C06', 'C07', 'C17', 'C08', 'C09', 'C10', 'C11', 'C12', 'C13',
         'C14', 'C15', 'TH']


def load(name):
    p = HERE / 'agents' / (name + '.json')
    return json.loads(p.read_text(encoding='utf-8')) if p.exists() else None


def apply_edits(text, edits):
    failed = []
    for e in edits:
        n = text.count(e['find'])
        if n == 1:
            text = text.replace(e['find'], e['replace'])
        else:
            failed.append({'find': e['find'][:80], 'count': n, 'why': e['why']})
    return text, failed


def main():
    report = {}
    parts = []
    for c in ORDER:
        hand = HERE / 'work/redraft' / (c + '.md')
        d, r = load('draft-' + c), load('review-' + c)
        rep = {}
        if hand.exists():
            md = hand.read_text(encoding='utf-8')
            rep['source'] = 'redraft'
        elif d:
            md, failed = apply_edits(d['markdown'], (r or {}).get('edits', []))
            rep.update(source='draft', edits=len((r or {}).get('edits', [])), failed=failed,
                       verdict=(r or {}).get('verdict'), missing_names=d.get('missing_names'), open=d.get('open'))
        else:
            rep['source'] = 'missing'
            md = None
        report[c] = rep
        if md:
            parts.append(md.strip())
    (HERE / 'work/assembly-report.json').write_text(json.dumps(report, ensure_ascii=False, indent=1), encoding='utf-8')
    bad = {c: v for c, v in report.items() if v['source'] == 'missing' or v.get('failed')
           or v.get('verdict') == 'needs redrafting'}
    for c, v in bad.items():
        print(c, v.get('source'), v.get('verdict'), 'failed edits:', len(v.get('failed') or []))
    if '--report' in sys.argv:
        return
    head = (HERE / 'work/xu.fragment').read_text(encoding='utf-8').strip()
    tail = (HERE / 'work/appendices.fragment').read_text(encoding='utf-8').strip()
    OUT.write_text(head + '\n\n' + '\n\n'.join(parts) + '\n\n' + tail + '\n', encoding='utf-8')
    print('wrote', OUT.relative_to(ROOT), '(%d 篇)' % len(parts))


if __name__ == '__main__':
    main()
