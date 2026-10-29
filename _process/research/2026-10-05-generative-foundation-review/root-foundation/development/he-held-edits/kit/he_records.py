#!/usr/bin/env python3
"""HE: the records the moves touch, after the checker run. (deferred_grammarpath.py has already written its record,
what-a-line-holds-and-a-regularity-takes-in, with its own history line, dated by the day it runs; these lines take
the same day.)
  master-laws-on-the-grammar: kept_onward's reference (re-pointed by the history move to the history copy, or still at
    the package path) and its binding go, its proof being GrammarLaws'; «保之像» joins the lumping group and the
    GrammarLaws reference; Mechanism's factors_image and Image.least join the last group and the Mechanism reference,
    as cases of «保之像»; the validation scope, within its cap, names HE's derivations and review; the design, the review
    and the receipt are referenced; history.
  processes-represented-both-ways: «保之像» moves from its GrammarTransport reference to its GrammarLaws reference,
    which gets a proof binding, and the receipt is referenced; history.
  what-keeping-widening-needs: total_eq_of_supports moves from its KeepingWidening reference to a new Dissipation
    reference with a proof binding; the validation scope follows HE's receipt; the receipt and the review are
    referenced; history.
Every anchor is found by its text and asserted, and the three records are written only at the end.
usage (from the checkout root, after the checker): python3 -B <kit>/he_records.py RECEIPT N"""
from datetime import date
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
RECEIPT_ID, N = sys.argv[1], int(sys.argv[2])
TODAY = date.today()
DAY_EN = f'{TODAY.day} {TODAY.strftime("%B")} {TODAY.year}'
DAY_ZH = f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
DEV = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/he-held-edits'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
HIST = 'experiments/integrated-correction/general-framework/generative-basis/lean/history/becoming/Becoming/KeptOnward.lean'
RECS = ROOT / 'theories/becoming/results/records'
REVIEW = f'{DEV}/review/REVIEW-HE.md'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def lean(m):
    return f'{PKG}/Becoming/{m}.lean'


core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
mods = {m['module']: m for m in core['modules']}
decl = {m: {d['name'] for d in mods[f'Becoming.{m}']['declarations']} for m in
        ('GrammarLaws', 'GrammarTransport', 'Mechanism', 'KeepingWidening', 'Dissipation')}
assert {'Becoming.kept_onward', 'Becoming.«保之像»'} <= decl['GrammarLaws']
assert 'Becoming.«保之像»' not in decl['GrammarTransport']
assert 'Becoming.total_eq_of_supports' in decl['Dissipation'] and 'Becoming.total_eq_of_supports' not in decl['KeepingWidening']
assert 'Becoming.KeptOnward' not in mods
for m in decl:
    assert core['source_sha256'][f'Becoming.{m}'] == sha(lean(m)), m
gl, kwm = mods['Becoming.GrammarLaws'], mods['Becoming.KeepingWidening']
writes = {}


def binding(path, module):
    return {'source': path, 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{module}',
            'success_pointer': '/status', 'success_value': 'passed'}


def ref(r, path):
    found = [x for x in r['references'] if x['path'] == path and x['role'] == 'proof']
    assert len(found) == 1, (r['id'], path, len(found))
    return found[0]


def add_ref(r, path, role):
    if not any(x['path'] == path for x in r['references']):
        r['references'].append({'path': path, 'role': role, 'sha256': sha(path)})


def history(r, en, zh):
    r['history'].append({'en': f'{DAY_EN} (HE, study section {N}): ' + en, 'zh': f'{DAY_ZH}（HE，研究第 {N} 节）：' + zh})


# master-laws-on-the-grammar
p = RECS / 'master-laws-on-the-grammar.json'
r = json.loads(p.read_text(encoding='utf-8'))
kos = [x for x in r['references'] if x['path'] in (HIST, lean('KeptOnward')) and x['role'] == 'proof']
assert len(kos) == 1, kos
assert kos[0]['declarations'] == ['Becoming.kept_onward'], kos[0]['declarations']
r['references'].remove(kos[0])
before = len(r['proof_bindings'])
r['proof_bindings'] = [b for b in r['proof_bindings'] if b['source'] not in (HIST, lean('KeptOnward'))]
assert len(r['proof_bindings']) == before - 1
g = ref(r, lean('GrammarLaws'))
g['declarations'] = g['declarations'] + [d for d in ('Becoming.kept_onward', 'Becoming.«保之像»')
                                         if d not in g['declarations']]
g['sha256'] = sha(lean('GrammarLaws'))
mech = ref(r, lean('Mechanism'))
mech['declarations'] = mech['declarations'] + ['Becoming.factors_image', 'Becoming.Image.least']
mech['sha256'] = sha(lean('Mechanism'))
lump = [l for l in r['laws'] if l['en'].startswith('Lumping. E goes alike under R')]
assert len(lump) == 1
lump = lump[0]
lump['en'] = lump['en'].rstrip() + ' A map preserves a relation exactly where its image lies within the other.'
lump['zh'] = lump['zh'].rstrip() + '映射保一关系，恰当该关系沿之之像在另一关系之内。'
lump['declarations'] = lump['declarations'] + ['Becoming.«保之像»']
last = [l for l in r['laws'] if l['en'].startswith("The models' laws of closure, return, being drawn")]
assert len(last) == 1
last = last[0]
END_EN = 'and a lineage being a line under activity and a line from an active occurrence a lineage.'
assert last['en'].endswith(END_EN), last['en'][-120:]
last['en'] = last['en'][:-1] + ('; and the image of a step along a projection the least process the step factors '
                                'through, from preserving read through the image.')
last['zh'] = last['zh'][:-1] + '；又步沿投影之像为步所经之最小进程，出自沿像读之保。'
last['declarations'] = sorted(set(last['declarations']) | {'Becoming.factors_image', 'Becoming.Image.least'})
vs = r['validation_scope']
assert vs['en'].count('and Becoming.KeptOnward, ') == 1 and vs['zh'].count('及 Becoming.KeptOnward，') == 1
vs['en'] = (f"Machine-checked by the Lean 4.29.1 checker (receipt {RECEIPT_ID}): Becoming.GrammarLaws, {gl['theorems']} "
            f"theorems in {len(gl['declarations'])} declarations, 40 representation and bridge declarations in fourteen "
            "model modules, the derivations of OU3c, OU3e and OU3f in fourteen more and HE's two in Mechanism, every "
            "axiom report empty, all cited; every changed module's statements print as before, but for the two relation "
            "laws moved into the grammar at any universe. Read-only AI reviews, every finding taken: three of OU3b, one "
            "each of OU3c to OU3e and HE, three of OU3f, three with a second pass; not reviewed by a person.")
vs['zh'] = (f"Lean 4.29.1 检查器实查（回执 {RECEIPT_ID}）：Becoming.GrammarLaws，{len(gl['declarations'])} 项声明中 "
            f"{gl['theorems']} 条定理，十四个模型模块中 40 项表示与桥接声明，另十四模块中 OU3c、OU3e、OU3f 之推导及 Mechanism 中 HE "
            "之二推导，公理报告皆空，本记录全引；诸改动模块之陈述所印如前，唯移入文法之二关系律推广至任一宇宙。只读 AI 审查，所见皆采："
            "OU3b 三次，OU3c 至 OU3e 与 HE 各一次，OU3f 三次，其中三次复审一遍；未经人审。")
assert len(vs['en']) <= 600, len(vs['en'])
add_ref(r, f'{DEV}/DESIGN.md', 'integration')
add_ref(r, REVIEW, 'review')
add_ref(r, RECEIPT, 'receipt')
history(r, "kept_onward moved to its home beside «线则所闭» in GrammarLaws, and Becoming.KeptOnward went to the Lean "
           "history folder with its bytes (research.py move, batch HE-history); «保之像» moved from GrammarTransport to "
           "beside «像» in GrammarLaws, and Mechanism's factors_image and Image.least are proved as its cases, statements "
           "and names unchanged; GrammarLaws' module doc says the lineage laws are proved from the laws of steps.",
        "kept_onward 移至其所居，GrammarLaws 中「线则所闭」之旁，Becoming.KeptOnward 连其字节移入 Lean 历史目录（research.py "
        "move，批次 HE-history）；「保之像」自 GrammarTransport 移至 GrammarLaws 中「像」之旁，Mechanism 之 factors_image 与 "
        "Image.least 证为其例，陈述与名不变；GrammarLaws 之模块说明言谱系诸律由计步之律证出。")
writes[p] = r

# processes-represented-both-ways
p = RECS / 'processes-represented-both-ways.json'
r = json.loads(p.read_text(encoding='utf-8'))
gt, g = ref(r, lean('GrammarTransport')), ref(r, lean('GrammarLaws'))
assert 'Becoming.«保之像»' in gt['declarations'] and 'Becoming.«保之像»' not in g.get('declarations', [])
gt['declarations'] = [d for d in gt['declarations'] if d != 'Becoming.«保之像»']
gt['sha256'] = sha(lean('GrammarTransport'))
g['declarations'] = g.get('declarations', []) + ['Becoming.«保之像»']
g['sha256'] = sha(lean('GrammarLaws'))
assert not any(b['source'] == lean('GrammarLaws') for b in r['proof_bindings'])
r['proof_bindings'].append(binding(lean('GrammarLaws'), 'GrammarLaws'))
add_ref(r, RECEIPT, 'receipt')
history(r, "«保之像» moved from GrammarTransport to beside «像» in GrammarLaws, statement and name unchanged; its "
           "reference and binding follow.",
        "「保之像」自 GrammarTransport 移至 GrammarLaws 中「像」之旁，陈述与名不变；其引用与绑定随之。")
writes[p] = r

# what-keeping-widening-needs
p = RECS / 'what-keeping-widening-needs.json'
r = json.loads(p.read_text(encoding='utf-8'))
kw = ref(r, lean('KeepingWidening'))
assert 'Becoming.total_eq_of_supports' in kw['declarations']
kw['declarations'] = [d for d in kw['declarations'] if d != 'Becoming.total_eq_of_supports']
kw['sha256'] = sha(lean('KeepingWidening'))
assert not any(x['path'] == lean('Dissipation') for x in r['references'])
at = r['references'].index(kw) + 1
r['references'].insert(at, {'path': lean('Dissipation'), 'role': 'proof',
                            'declarations': ['Becoming.total_eq_of_supports'], 'sha256': sha(lean('Dissipation'))})
r['proof_bindings'].append(binding(lean('Dissipation'), 'Dissipation'))
vs = r['validation_scope']
assert vs['en'].startswith('Machine-checked by the consolidated Lean 4.29.1 checker (receipt ') and \
    "Becoming.KeepingWidening, 307 declarations, and Population's length_le_count" in vs['en'], vs['en'][:200]
vs['en'] = (f"Machine-checked by the consolidated Lean 4.29.1 checker (receipt {RECEIPT_ID}): Becoming.KeepingWidening, "
            f"{len(kwm['declarations'])} declarations, Dissipation's total_eq_of_supports and Population's "
            "length_le_count, every one with an empty axiom report, all cited here; every earlier statement of the module "
            "prints unchanged (signature audit). Built in sessions; independent read-only reviews by a separate AI agent, "
            "REVIEW-UE7 (study section 419), REVIEW-GW-LEAN with its re-check (study section 448) and REVIEW-HE (study "
            f"section {N}), every finding taken but one of the first; not reviewed by a person.")
vs['zh'] = (f"Lean 4.29.1 合并检查器实查（回执 {RECEIPT_ID}）：Becoming.KeepingWidening 之 {len(kwm['declarations'])} 项声明、"
            "Dissipation 之 total_eq_of_supports 与 Population 之 length_le_count，公理报告皆空，本记录全引；本模块之每一旧陈述所印"
            "不变（签名审查）。另一 AI 代理作独立只读审查：REVIEW-UE7（研究第 419 节）、REVIEW-GW-LEAN 及其复查（研究第 448 节）与 "
            f"REVIEW-HE（研究第 {N} 节），所见除首次一项外皆采；未经人审。")
assert len(vs['en']) <= 600, len(vs['en'])
add_ref(r, RECEIPT, 'receipt')
add_ref(r, REVIEW, 'review')
history(r, 'total_eq_of_supports moved from KeepingWidening to beside total_le_of_support in Dissipation, statement and '
           'name unchanged; its reference, binding and the validation scope follow.',
        'total_eq_of_supports 自 KeepingWidening 移至 Dissipation 中 total_le_of_support 之旁，陈述与名不变；其引用、绑定与验证'
        '范围随之。')
writes[p] = r

for path, record in writes.items():
    path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('records:', ', '.join(path.stem for path in writes), '; dated', DAY_EN)
