#!/usr/bin/env python3
"""WB: astra's fourth round (review/readers/round4-astra.md). The remaining pattern was incomplete propagation:
"needs" made "rests on" kept a universal scope; T8 still described as a way or verdict under the two readings or
P2 and P4; current Chinese record fields left in the old frame; choices said to need J1–J4; and 05's "ranked only
under the two readings" with three records and the dynamics atlas that copy it. Exact replacements and counted
regular families; a record changed here gets a history note unless it has this round's already."""
import json
import pathlib
import re
import sys

ROOT = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else '.')
B = ROOT / 'theories/becoming'


def esc(s):
    return json.dumps(s, ensure_ascii=False)[1:-1]


def rep_text(path, pairs, js=False):
    s = path.read_text(encoding='utf-8')
    for a, b, n in pairs:
        ka, kb = (esc(a), esc(b)) if js else (a, b)
        c = s.count(ka)
        if c == 0 and s.count(kb):
            continue
        if n is not None and c != n:
            raise SystemExit(f'{path.name}: {c} of {a[:70]!r}, expected {n}')
        s = s.replace(ka, kb)
    if js:
        json.loads(s)
    path.write_text(s, encoding='utf-8')


ONLY_EN = [("That is ranked only under the two readings of [07](07-SIGNIFICANCE.md), the continuation condition for scope and C for order.",
            "A ranking of it names its scope and order; the continuation condition and C are one pair of readings [07](07-SIGNIFICANCE.md) examines.", 1)]
rep_text(B / 'chapters/05-COLLECTIVES.md', ONLY_EN)

REC_EN = ("that is ranked only under the two readings 07 names, the continuation condition for scope and C for order.",
          "a ranking names its scope and order; the continuation condition and C are one pair of readings 07 examines.")
REC_EN2 = ("and a ranking is asked only under the two readings 07 names, the continuation condition for scope and C for order.",
           "and a ranking names its scope and order; the continuation condition and C are one pair of readings 07 examines.")
REC_ZH = ("这只在第七章所指名的两种读法之下才被排定，延续条件定范围，C 定次序。", "排序须指名其范围与次序；延续条件与 C 是第七章考察的一对读法。")
REC_ZH2 = ("排序只在第七章所指名的两种读法之下，延续条件定范围，C 定次序。", "排序须指名其范围与次序；延续条件与 C 是第七章考察的一对读法。")
ZH_GLOSS = [("扩大比较生生的方向，生生是生成者生成新的生成（D1、D22）", "扩大比较能够形成者；自 2026 年 11 月 9 日起，生生读作生命之延续，而非扩大（D1）"),
            ("生生的方向另行读出，以扩展能够形成者来比较（D1）", "生生，即生命之延续，另行读出（D1）")]
NOTE = {"en": "9 November 2026, board item WB (the readers' fourth round): a ranking said to name its scope and order, the continuation condition and C being one pair of readings 07 examines, in place of 'ranked only under the two readings'; current Chinese fields brought to their English; no change to the claim, its hypotheses or its Lean.",
        "zh": "2026 年 11 月 9 日，工作板条目 WB（读者第四轮）：改「只在两种读法之下排定」为排序须指名其范围与次序，延续条件与 C 是第七章考察的一对读法；现行中文字段与其英文一致；主张、假设与 Lean 皆不变。"}
for name in ['a-pair-tolerates-only-within-a-window', 'errors-by-chance-in-a-pair-keeping-mutual-withholding',
             'what-decides-giving-against-keeping-on-a-flow', 'comparison-by-widening', 'positive-ground-open-futures']:
    p = B / f'results/records/{name}.json'
    raw = p.read_text(encoding='utf-8')
    before = raw
    for a, b in [REC_EN, REC_EN2, REC_ZH, REC_ZH2] + ZH_GLOSS:
        raw = raw.replace(esc(a), esc(b))
    if raw == before:
        raise SystemExit(f'{name}: nothing replaced')
    d = json.loads(raw)
    if not any('fourth round' in h.get('en', '') for h in d['history']):
        d['history'].append(NOTE)
        indent = 2 if '\n  "' in raw[:200] else 1
        raw = json.dumps(d, ensure_ascii=False, indent=indent) + '\n'
    p.write_text(raw, encoding='utf-8')
    print(name)

rep_text(B / 'results/atlas/entries/dynamics.json', [(REC_EN[0], REC_EN[1], 2), (REC_EN2[0], REC_EN2[1], 1)], js=True)

CW = B / 'results/atlas/entries/correspondences.json'
T8_NOW = ("T8 is the makers' offer for life, binding no one: to see what each course draws on, from what renewal and at which grain, "
          "what ends, what goes on through that ending, and who bears it. The continuation condition and C belong to conditional comparisons; "
          "P2 and P4 belong to the separate argument about an actor's line.")
rep_text(CW, [
    ("; on my reading his theory does not meet that.", ". The comparison with Metz's order does not test this claim.", 1),
    ("which has the shape T8's refuter had until 9 November 2026, still wanting the argument",
     "which was compared to T8's former refuter and does not test the current thesis", 1),
    ("choice needs J1 to J4.", "§5's practical-judgment scheme uses J1 to J4.", 1),
    ("Rankings rest on C or another named order, choices J1-J4.", "Each ranking names its order; §5's practical-judgment scheme uses J1-J4.", 1),
    ("T8's 'of whatever substrate' rests on P2 and P4, unasserted.", T8_NOW, 1),
    ("T8 offers 生生 for life, compared by widening what can form, argued.", T8_NOW, 1),
    ("T8 says whose way, for life, and claims no verdict binding every possible mind, under the continuation condition for scope and C for order, neither asserted.", T8_NOW, 1),
    ("T8's way, under the continuation condition and C, neither asserted, holds of whatever substrate only under P2 and P4, open; if they fail that ground goes. It scopes the universal: \"all beings\" becomes those whose line runs through life.",
     T8_NOW + " Whether an actor's line runs through life is that argument's question, under P2 and P4, open.", 1),
    ("T8 offers 生生 for life, scope from the condition, order from C, neither asserted, no warrant from outside sought. Dossier B records one such case: Buddhist cessation, read as release by no longer continuing, runs against the condition, on that reading only.",
     T8_NOW + " Dossier B discusses Buddhist cessation as release by no longer continuing. That reading alone does not conflict with the continuation condition, which counts continuations without ranking them; any conflict with C requires a comparison meeting C's widening hypotheses.", 1),
    ("T8, thesis: for life, the way is 生生, compared by widening, with the continuation condition for scope and C for order. No verdict binding every possible mind is claimed.", T8_NOW, 1),
    ("T8 names its premises, the condition for scope and C for order, neither asserted, and 生生 is not the whole's own good.", T8_NOW + " 生生 is not the whole's own good.", 1),
    ("A frozen test of what instruction does and does not install, and the two readings named for any ranking.",
     "A frozen test of what instruction does and does not install, and the scope and order named for each ranking.", 1),
    ("A loss rests on a named scope and order, most often the continuation condition and C, neither asserted.",
     "The loss can occur without being counted; whether it counts depends on the significance supplied, and a ranking names its order.", 1),
    ("any ranking there is under the continuation condition for scope and C for order, neither asserted.",
     "any ranking there names its scope and order, most often the continuation condition and C, neither asserted.", 1),
], js=True)
s = CW.read_text(encoding='utf-8')
s, k1 = re.subn(r'(rests? on|is under|takes) C( \(order\))?(?: or another named order)?,? (?:for order,? )?(?:and|with) (?:scope from )?the (?:continuation )?condition(?: for scope| for whose losses count)?',
                lambda m: f"{m.group(1)} C{m.group(2) or ''} or another named order, with a named scope, most often the continuation condition", s)
s, k2 = re.subn(r'ranking takes C for order(,| and) the condition for scope', 'ranking names its order and scope, most often C and the condition', s)
json.loads(s)
CW.write_text(s, encoding='utf-8')
print('crosswalk families', k1, k2)
