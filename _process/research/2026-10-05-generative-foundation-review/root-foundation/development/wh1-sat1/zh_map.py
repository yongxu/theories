#!/usr/bin/env python3
"""WH1 and SAT1: the ZH map's five gap entries read with the new laws. Each entry's reading is revised where it named
the gap, its gap note says what now states it, and the declarations and records it cites grow by the new ones. Every
edit must match exactly once; kinds are unchanged.
usage (from the checkout root): python3 -B zh_map.py"""
import json
from pathlib import Path

ROOT = Path.cwd()
MAP = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/zhonghua/passages.json'
WH = 'a-whole-of-every-part'
SA = 'a-coupling-saturated-by-what-it-has-carried'

EDITS = {
    'huayan-liu-xiang': {
        'reading': [(
            '剩余：华严的总相是合取的，「去却椽即無舍故」；问「無一椽時豈非舍耶？」答「但是破舍，無好舍也」，缺一部分整体即不成，或只成破损的整体。'
            '脊柱的整体（Web.Whole）是析取的活动之相合，某一部分活动整体即活动，与华严相反，所以不以 Web.Whole 释总相。',
            '华严的总相是合取的，「去却椽即無舍故」：舍读作每椽之整体（Web.AllWhole，恰在每个部分都活跃时活跃），缺一椽它即不活跃'
            '（Web.AllWhole.inactive_of_part），一椽终结它即终结（Web.AllWhole.ends_of_part）。问「無一椽時豈非舍耶？」答「但是破舍，無好舍也」：'
            '破舍读作减损之整体，某椽之整体活跃而每椽之整体不活跃（Web.diminished_iff）。脊柱原有的整体（Web.Whole）是析取的，某一部分活动整体即活动，'
            '读的是破舍，不是好舍；两种整体恰在诸部分同步之处相合（Web.Whole.same_iff_inStep）。'),
            ('脊柱尚无合取或分级的整体，列入缺口（见 gap）。', '')],
        'gap': ('已补（WH1，2026年10月22日）：合取的整体为 Becoming.Web.AllWhole（恰在每个部分都活跃时活跃），缺一部分即不活跃'
                '（Web.AllWhole.inactive_of_part），一部分终结即终结（Web.AllWhole.ends_of_part），所列部分之活动可判定时，其止息必有所列部分同步止息'
                '（Web.AllWhole.ceases_part）；分级者为所列部分之等级（Web.Grade，一个计数）与至少 j 个部分之整体（Web.AtLeastWhole），'
                '减损之整体为 Web.Diminished（Web.diminished_iff）。见记录 a-whole-of-every-part。'),
        'relational': [('合取之总在脊柱上尚缺', '总相是每个部分之整体')],
        'declarations': ['Becoming.Web.AllWhole', 'Becoming.Web.AllWhole.inactive_of_part',
                         'Becoming.Web.AllWhole.ends_of_part', 'Becoming.Web.diminished_iff',
                         'Becoming.Web.Whole.same_iff_inStep'],
        'records': [WH],
    },
    'mojing-sun-jian-ti': {
        'reading': [(
            '定域之处：「謂其存者損」以余存者为减损的整体，脊柱没有减损的整体：在 Web.Whole 下，只要有一部分活动，整体就完全活动。'
            '墨经「體，分於兼也」的构成之意，理论不取。损（整体减损的程度）列入缺口，与华严破舍同（见 gap）。',
            '「謂其存者損」以余存者为减损的整体：所列部分有的活跃、不是全部（Web.Diminished），恰是某部分之整体活跃而每个部分之整体不活跃'
            '（Web.diminished_iff）；损之程度读作所列部分中活跃者之数（Web.Grade），缺一部分它即少于部分之数（Web.Grade.lt_length_of_inactive）。'
            '定域之处：墨经「體，分於兼也」的构成之意，理论不取。')],
        'gap': ('已补（WH1，2026年10月22日）：见 huayan-liu-xiang 的 gap；减损之整体为 Becoming.Web.Diminished（Web.diminished_iff），'
                '损之程度为所列部分之等级 Becoming.Web.Grade。见记录 a-whole-of-every-part。'),
        'relational': [('减损的整体在脊柱上尚缺', '减损的整体是某部分之整体活跃而每个部分之整体不活跃')],
        'declarations': ['Becoming.Web.Diminished', 'Becoming.Web.diminished_iff', 'Becoming.Web.Grade',
                         'Becoming.Web.Grade.lt_length_of_inactive'],
        'records': [WH],
    },
    'suzhe-che-bu-ke-shu': {
        'reading': [(
            '车是诸件同时并存的构成，不是脊柱的析取整体（Web.Whole：某一部分活动即整体活动），所以不以 Web.Whole 读。',
            '车是诸件同时并存而成，读作每件之整体（Web.AllWhole：恰在每件都活跃时活跃），不以析取的整体（Web.Whole：某一部分活动即整体活动）读；'
            '缺一件，每件之整体即不活跃（Web.AllWhole.inactive_of_part）。')],
        'gap': '已补（WH1，2026年10月22日）：诸件同时并存之整体为 Becoming.Web.AllWhole，见 huayan-liu-xiang 的 gap 与记录 a-whole-of-every-part。',
        'relational': [],
        'declarations': ['Becoming.Web.AllWhole', 'Becoming.Web.AllWhole.inactive_of_part'],
        'records': [WH],
    },
    'lao-72-min-bu-wei-wei': {
        'reading': [(
            '畏自某步起才不读入时环断开，这一〈自某步起〉的环之形式脊柱缺，见缺口。',
            '畏自某步起才不读入时，耦合自该步停止（StopsBy），不再复现，经它的环不再返回（Saturation.not_recurs）。'),
            ('但「民不畏威」是怎样来的——威用得多而畏渐失——是强度随所传之量而降，脊柱没有这样的律。脊柱已有的相近形式是：强度可以读自历程'
             '（ReadsBefore），耦合可以到某步停止（StopsBy），自某步起无耦合再读则有限阶精确（exact_of_reading_before）；缺的是把强度依所传之量'
             '归零与这些连起来的饱和律，见缺口。',
             '「民不畏威」是怎样来的——威用得多而畏渐失——读作为已传之量所饱和的耦合：强度读自经该耦合已传之量（Saturation.strengths，'
             '读先前之水平：Saturation.readsBefore）；强度在已传 A 之后为零、且至第 N 步已传 A 时，该耦合至 N 停止（Saturation.stops），'
             '此后无所再传（Saturation.passed_from），诸耦合皆如此饱和则有限阶自此精确（Saturation.exact）；未饱和时每步作用、源之水平常在者，'
             '至第 A 步即停（Saturation.stops_by）。响应非增时，耦合恰在响应于某量归零处停止（Saturation.stops_iff）；响应只减而不归零者不停'
             '（Saturation.floored）。威之用怎样耗畏是前提（sat 或 f 给定），不是导出。')],
        'gap': ('已补（SAT1，2026年10月22日）：强度随经由耦合已传之量而降的律为 Becoming.Saturation（passed、strengths，读先前：readsBefore）。'
                '定理一：强度自 A 起为零而至第 N 步已传 A，则该耦合至 N 停止（Saturation.stops），不再复现（Saturation.not_recurs），'
                '诸耦合皆饱和则有限阶自此精确（Saturation.exact）。定理二（对照）：响应以一为下限时耦合复现，自耦合则无有限阶处处精确'
                '（Saturation.floored、Saturation.floored_inexact）；非增而不归零之响应终为常数，其在何步需 LPO，不陈述。'
                '见记录 a-coupling-saturated-by-what-it-has-carried。'),
        'relational': [],
        'declarations': ['Becoming.Saturation.strengths', 'Becoming.Saturation.readsBefore', 'Becoming.Saturation.stops',
                         'Becoming.Saturation.not_recurs', 'Becoming.Saturation.passed_from', 'Becoming.Saturation.exact',
                         'Becoming.Saturation.stops_by', 'Becoming.Saturation.stops_iff', 'Becoming.Saturation.floored'],
        'records': [SA],
    },
    'jielao-shi-qiang-mu-buming': {
        'reading': [(
            '经文的因果——用得过强，强度因此而降——脊柱没有：强度或给定、或读自水平，没有依所传之量归零的律，见缺口（与 lao-72-min-bu-wei-wei '
            '同一缺口）。定域：脊柱给出「不明」是什么，不给出〈强则不明〉。',
            '经文的因果——用得过强，强度因此而降——读作为已传之量所饱和的耦合：耦合恰在其响应于某已传之量归零处停止（Saturation.stops_iff），'
            '未饱和时每步读入者至阈值之步即停（Saturation.stops_by）；响应只减而不归零者不停（Saturation.floored）。定域：脊柱给出「不明」是什么，'
            '并在用耗强度的前提下给出〈强则不明〉；用是否这样耗目、耳之强度，是经验问题。')],
        'gap': ('已补（SAT1，2026年10月22日）：同 lao-72-min-bu-wei-wei 之 gap，见 Becoming.Saturation.stops_iff 与记录 '
                'a-coupling-saturated-by-what-it-has-carried。'),
        'relational': [],
        'declarations': ['Becoming.Saturation.strengths', 'Becoming.Saturation.stops_iff', 'Becoming.Saturation.stops_by',
                         'Becoming.Saturation.floored'],
        'records': [SA],
    },
}

data = json.loads(MAP.read_text(encoding='utf-8'))
seen = set()
for cluster in data['clusters'].values():
    for e in cluster['entries']:
        spec = EDITS.get(e['id'])
        if not spec:
            continue
        seen.add(e['id'])
        assert e['gap'] and not e['gap'].startswith('已补'), (e['id'], 'already edited')
        for field in ('reading', 'relational'):
            for old, new in spec[field]:
                assert e[field].count(old) == 1, (e['id'], field, old[:40], e[field].count(old))
                e[field] = e[field].replace(old, new)
        e['reading'] = e['reading'].replace('。。', '。')
        e['gap'] = spec['gap']
        for field in ('declarations', 'records'):
            for x in spec[field]:
                assert x not in e[field], (e['id'], x)
                e[field].append(x)
assert seen == set(EDITS), set(EDITS) - seen
MAP.write_text(json.dumps(data, ensure_ascii=False, indent=1), encoding='utf-8')
print('edited', sorted(seen))
