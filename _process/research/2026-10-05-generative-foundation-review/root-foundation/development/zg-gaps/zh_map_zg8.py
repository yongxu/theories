#!/usr/bin/env python3
"""ZG8: the last ZH gap note (唯识「無因」) reads the law of forming, necessary and sufficient.
usage (from the checkout root): python3 -B zh_map_zg8.py"""
import json
from pathlib import Path

MAP = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/development/zhonghua/passages.json')
ADD = ('充要之律今已证（ZG8）：一个依存在一降中新结（Web.FormsAnewAt：后代持之，给予者未持），恰在因于此不成之处（Web.inheritsAt_iff_not_formsAnew，给予者之依存稳定），'
       '而在给予者处依存与汲取相合时，恰在后代依于给予者所未汲取者之处（Web.formsAnew_iff_undrawn）；汲取之读法恰是因加上给予者汲取其所持而传下者'
       '（Flow.dependsOnDrawn_iff），这是 inherits_of_drawn 所缺之必要一半。所以「無因緣」之新结恰是依于给予者所未汲者。')
GAP = ('已补（ZG8，2026年10月22日）：Becoming.Web.FormsAnewAt、Web.inheritsAt_iff_not_formsAnew、Web.formsAnew_iff_undrawn、Web.drawn_necessary_iff、'
       'Flow.PassesDrawn、Flow.dependsOnDrawn_iff、Flow.inherits_iff_none_undrawn（以汲取与依存陈述之充要之律；依存与汲取相合为所设）。'
       '见记录 forming-anew-necessary-and-sufficient。')
DECLS = ['Becoming.Web.formsAnew_iff_undrawn', 'Becoming.Flow.dependsOnDrawn_iff', 'Becoming.Flow.inherits_iff_none_undrawn']
data = json.loads(MAP.read_text(encoding='utf-8'))
n = 0
for cluster in data['clusters'].values():
    for e in cluster['entries']:
        if e['id'] == 'weishi-shiqi-wu-yin' and e.get('gap'):
            assert e['gap'].startswith('仍开'), e['gap'][:20]
            e['reading'] = e['reading'].rstrip() + ADD
            e['gap'] = GAP
            for x in DECLS:
                if x not in e['declarations']:
                    e['declarations'].append(x)
            if 'forming-anew-necessary-and-sufficient' not in e['records']:
                e['records'].append('forming-anew-necessary-and-sufficient')
            n += 1
assert n >= 1
MAP.write_text(json.dumps(data, ensure_ascii=False, indent=1), encoding='utf-8')
print('edited', n)
