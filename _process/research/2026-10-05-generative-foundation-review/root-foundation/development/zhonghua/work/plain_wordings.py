"""Write work/plain-wordings.md from work/new-names.json: the concepts that stay in plain modern Chinese, each with
its one wording, and the concepts mapped onto an existing name (python3 -I work/plain_wordings.py)."""
import json, os, sys
H = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, H)
from simplify import simp
nn = json.load(open(H + '/new-names.json', encoding='utf-8'))
out = ['# 不立名之概念的固定说法，与归入已有之名者', '', '中华本中，下列概念不立古典之名：每个只用这里给出的一种说法，经与说皆同。', '',
       '| 概念 | 说法 | 理由 |', '|---|---|---|']
for d in nn['plain']:
    out.append('| %s | %s | %s |' % (d['concept'].replace('|', '／'), d['plain'], d['note'].replace('|', '／').replace('\n', ' ')[:160]))
out += ['', '下列概念归入名表已有之名（用其简体）：', '', '| 概念 | 名 | 说明 |', '|---|---|---|']
for d in nn['existing']:
    out.append('| %s | %s | %s |' % (d['concept'].replace('|', '／'), simp(d['name']), d['note'].replace('|', '／').replace('\n', ' ')[:160]))
open(H + '/plain-wordings.md', 'w', encoding='utf-8').write('\n'.join(out) + '\n')
print(len(nn['plain']), 'plain;', len(nn['existing']), 'existing')
