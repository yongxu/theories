"""Generate NAMES-ZH.md (the 名表, simplified forms) from names-decisions.tsv and names-checked.json."""
import csv, json, os
H = os.path.dirname(os.path.abspath(__file__)); KIT = os.path.dirname(H)
import sys; sys.path.insert(0, H)
from simplify import simp
checked = {r['名']: r for r in json.load(open(H + '/names-checked.json', encoding='utf-8'))}
rows = list(csv.DictReader(open(H + '/names-decisions.tsv', encoding='utf-8'), delimiter='\t'))
TITLES = json.load(open(KIT + '/clusters.json', encoding='utf-8'))
order = {c['key']: i for i, c in enumerate(TITLES)}
out = ['# 名表（中华本所用之名）', '', 'AI 所定（board item ZH），2026 年 10 月 21 日。每个理论概念一个名；名用简体（「闢」除外），繁体附后。「锚」是 Lean 声明或模块（`Becoming.` 前缀省去）；「出处」引自《中华思想脉络》v1.0 的冻结文本，〔〕内为其来源编号；「式」：古＝单字古名，复＝有出处之复词，新＝新组合（约定）。「注」写明此名不带之义与分工。', '']
for c in TITLES:
    rs = [r for r in rows if r['篇'] == c['key']]
    if not rs: continue
    out += ['## %s %s' % (c['key'], c['title']), '', '| 名 | 所名 | 锚 | 出处 | 式 | 注 |', '|---|---|---|---|---|---|']
    for r in rs:
        n = r['名']; sn = simp(n); trad = '' if sn == n else '（%s）' % n
        q = []
        for qq in checked[n]['quotes']:
            if qq['found']:
                f = qq['found'][0]; q.append('「%s」〔%s〕' % (f['text'].replace('\n', ''), f['source_id']))
        anc = '；'.join('`%s`' % a.replace('Becoming.', '') for a in checked[n]['anchors']) or '—'
        cell = lambda x: (x or '—').replace('|', '／').replace('\n', ' ')
        out.append('| %s%s | %s | %s | %s | %s | %s |' % (sn, trad, cell(r['所名']), anc, '；'.join(q) or '—', r['式'], cell(r['注'])))
    out.append('')
open(KIT + '/NAMES-ZH.md', 'w', encoding='utf-8').write('\n'.join(out) + '\n')
print(len(rows), 'names written to NAMES-ZH.md')
