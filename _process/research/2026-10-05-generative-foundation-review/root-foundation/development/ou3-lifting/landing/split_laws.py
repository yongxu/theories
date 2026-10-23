"""OU2 + OU3a: split the record's instance law in three and shorten the sufficing law (length limits).
usage (from the checkout root): python3 -B split_laws.py"""
import json
from pathlib import Path
p = Path('theories/becoming/results/records/continuation-relative-to-a-class.json')
r = json.loads(p.read_text())
laws = r['laws']
suf = laws[10]
assert suf['en'].startswith('Holding, mutual need')
suf['en'] = ("Holding, mutual need and leaning-on through constancy apply only to lines that do not end; through the "
             "core they apply to all: a class suffices for another's regularity where what is alike under both is "
             "alike under the other's core. The constancy forms imply the core forms, a class is constant exactly "
             "where it lies in its core, and a flame's regularity lies in fire and fuel.")
inst = laws[12]
assert inst['en'].startswith("The old base's continuation family")
ds = inst['declarations']


def pick(*mods):
    return [x for x in ds if any(x.startswith('Becoming.' + m) for m in mods)]


a = [x for x in ds if x.split('.')[1] in ('Steps',) or x in (
    'Becoming.Web.arises_iff_sheng', 'Becoming.Web.unceasing_iff_late_beginnings', 'Becoming.Web.renews_iff',
    'Becoming.Web.activityClass', 'Becoming.ceasesToBe_iff_wang', 'Becoming.comesToBe_iff_sheng',
    'Becoming.Web.ceases_iff_wang', 'Becoming.positions_iff_em', 'Becoming.persists_of_positions',
    'Becoming.core_iff_same_course', 'Becoming.Web.flash_positions', 'Becoming.World.law_iff_positions',
    'Becoming.World.law_iff_grammar_positions')]
b = [x for x in ds if x in (
    'Becoming.Web.continuationStep', 'Becoming.Web.arisesFrom_iff_sheng', 'Becoming.Web.ceasesFrom_iff_wang',
    'Becoming.Web.split_fission', 'Becoming.Web.merge_candles', 'Becoming.Web.lineage_iff_line',
    'Becoming.Web.positions_not_self_standing', 'Becoming.Web.reach_strict_order', 'Becoming.Web.continuing_iff_line',
    'Becoming.Web.linked_iff_line', 'Becoming.Web.held_iff_line', 'Becoming.Web.RenewingAlong.branches',
    'Becoming.Web.ConsumingAlong.merged_candles', 'Becoming.Web.line_reidentify')]
c = [x for x in ds if x not in a and x not in b]
assert sorted(a + b + c) == sorted(ds) and len(set(a) & set(b)) == 0
new = [
    {"en": "The old base's arising and ceasing along one relatum are beginning and ending under 'alike in activity', "
           "occurrences being pairs of a step and a relatum; ceasing to be is an ending and coming to be a beginning; "
           "the finite-world law of arising and ceasing is exactly the decidability of the positions.",
     "zh": "旧基底在同一关系项上的生起与终止，是“活动相同”之类下的生与亡（事为步与关系项之对）；不再是为亡，成为为生；有穷世界的生灭之律恰是诸位之可判定。",
     "declarations": a},
    {"en": "Relative to a continuation of the old base, arising and ceasing are its beginning and ending; a split is "
           "fission and a merge the candles' merge; lineages, continuing, links and holding are lines, unchanged by "
           "re-identification.",
     "zh": "相对于旧基底的一个延续，生起与终止是其生与亡；分裂是分叉，合并是蜡烛之合；世系、延续、联系与持有都是线，不因重新认定而变。",
     "declarations": b},
    {"en": "Passing a pattern on while the carrier ceases is an alteration, ending under the carrier class and "
           "continuing under the pattern's (火传); falling dormant is an alteration under holding, and choosing what "
           "holds is choosing a class.",
     "zh": "载者终止而传其样式是异：在载者之类下亡，在样式之类下续（火传）；休眠在持有之下是异，择其所持即择一类。",
     "declarations": c},
]
r['laws'] = laws[:12] + new + laws[13:]
for law in r['laws']:
    assert len(law['en']) <= 420, (len(law['en']), law['en'][:60])
    assert len(law['zh']) <= 190, (len(law['zh']), law['zh'][:30])
p.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n')
print('laws', len(r['laws']))
