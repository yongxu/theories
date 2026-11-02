#!/usr/bin/env python3
"""U4e: the edge record's Next drops an item DU already gave (ReadsNoOrder.not_entails), with a history line; applied
in the tree given as argv[1]. The record round-trips byte for byte; the replaced text occurs once."""
import json
import sys
from pathlib import Path

p = Path(sys.argv[1]) / 'theories/becoming/results/records/one-root-to-its-edge.json'
t = p.read_text(encoding='utf-8')
d = json.loads(t)
assert t == json.dumps(d, ensure_ascii=False, indent=2) + '\n'
nd = d['next_delta']
for lang, old in (('en', 'a theorem that no statement reading only the dynamics entails C; '),
                  ('zh', '无一仅读动力之陈述蕴涵 C 之定理；')):
    assert nd[lang].count(old) == 1, (lang, nd[lang])
    nd[lang] = nd[lang].replace(old, '')
d['history'].append({
    'en': "2 November 2026, U4e (study section U4E_SECTION): the Next drops a theorem that no statement reading only "
          "the dynamics entails C. DU gave it (ReadsNoOrder.not_entails: a statement reading no order, as one reading "
          "only the dynamics does, entails C at a datum on a frame with an extension only where it fails), and the home "
          "section already names it. RootForms.some_depends states its witness instead of only that it is not refuted, so "
          "law 2's witnesses read directly; its statement is stronger, the law unchanged. No standing or count changed.",
    'zh': "2026年11月2日，U4e（研究第 U4E_SECTION 节）：下一步去掉“无一仅读动力之陈述蕴涵 C 之定理”。DU 已给出之"
          "（ReadsNoOrder.not_entails：不读次序之陈述——仅读动力者即是——于有延伸之框架上之一数据处，唯于其不成处蕴含 C），"
          "家节已名之。RootForms.some_depends 径陈其见证，不再只言其不被否证，第 2 条之见证遂直读；其陈述更强，规律不变。"
          "无一立处或计数改变。"})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('edge record: Next item dropped, history line added')
