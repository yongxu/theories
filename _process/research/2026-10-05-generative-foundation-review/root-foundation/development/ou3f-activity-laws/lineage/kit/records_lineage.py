#!/usr/bin/env python3
"""OU3f, lineage laws: extend master-laws-on-the-grammar. The last group (the models' laws proved from the master laws)
gains the six lineage laws of Becoming.Identity, read through the grammar's steps of the continuation within activity;
a proof reference and binding for Identity (the bridge, steps_advance moved there, and the six); MapInstances' reference
drops steps_advance; the does-not-show item on the lineage laws goes; the design, the review and the receipt; the
validation scope within its cap; a history note. Anchors are found by their text, not their index, and each is asserted.
usage (from the checkout root, after the checker): python3 -B <kit>/records_lineage.py RECEIPT N"""
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
RECEIPT_ID, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
DEV = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3f-activity-laws/lineage'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
P = ROOT / 'theories/becoming/results/records/master-laws-on-the-grammar.json'
W = 'Becoming.Web.'
DERIVED = [W + 'Lineage.' + n for n in ('unique', 'origin', 'split', 'through', 'onward', 'back')]
BRIDGE = [W + 'activityFrom', W + 'steps_advance', W + 'steps_iff_lineage', W + 'steps_start_active']
IDENTITY = f'{PKG}/Becoming/Identity.lean'
MAPS = f'{PKG}/Becoming/MapInstances.lean'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
mods = {m['module']: m for m in core['modules']}
ident = mods['Becoming.Identity']
assert not any(ident['axiom_dependencies'].values())
names = {d['name'] for d in ident['declarations']}
assert set(DERIVED + BRIDGE) <= names, set(DERIVED + BRIDGE) - names
assert W + 'steps_advance' not in {d['name'] for d in mods['Becoming.MapInstances']['declarations']}
for m, path in (('Identity', IDENTITY), ('MapInstances', MAPS)):
    assert core['source_sha256'][f'Becoming.{m}'] == sha(path), m
gl = mods['Becoming.GrammarLaws']

r = json.loads(P.read_text(encoding='utf-8'))
lasts = [l for l in r['laws'] if l['en'].startswith("The models' laws of closure, return, being drawn")]
assert len(lasts) == 1, len(lasts)
last = lasts[0]
END_EN, END_ZH = "and a carrier and the pattern's line traced back.", '以及载者与样式之线之回溯。'
assert last['en'].endswith(END_EN) and last['zh'].endswith(END_ZH), 'the last group has changed; re-read it'
last['en'] = last['en'][:-1] + ('; and the lineage laws under a continuation, a lineage read as the grammar\'s steps of the '
                                'continuation within activity: reaching one formation at each step without splits and '
                                'coming from one without merges, splitting as its steps split, and going on where nothing '
                                'ceases and back where nothing arises, as far as can be refuted.')
last['zh'] = last['zh'][:-1] + ('；又续之下之谱系诸律，谱系读为活跃之内续之文法之步：无分则每步所及唯一，无合则所出唯一，'
                                '随其步之分而分，无止则或续往，无生则或回溯。')
assert W + 'steps_advance' in last['declarations']
last['declarations'] = sorted(set(last['declarations']) | set(DERIVED))

dns = [i for i, d in enumerate(r['does_not_show'])
       if d['en'].startswith("That the models' lineage laws are proved from these laws of steps")]
assert len(dns) == 1, dns
del r['does_not_show'][dns[0]]

refs = r['references']
maps = [x for x in refs if x['path'] == MAPS]
assert len(maps) == 1 and W + 'steps_advance' in maps[0]['declarations'], maps
maps[0]['declarations'] = [d for d in maps[0]['declarations'] if d != W + 'steps_advance']
maps[0]['sha256'] = sha(MAPS)
assert not any(x['path'] == IDENTITY for x in refs), 'Identity is already a reference; re-read the record'
at = max(i for i, x in enumerate(refs) if x['role'] == 'proof') + 1
refs.insert(at, {'path': IDENTITY, 'role': 'proof', 'declarations': BRIDGE + DERIVED, 'sha256': sha(IDENTITY)})
r['proof_bindings'].append({'source': IDENTITY, 'receipt': RECEIPT, 'sha256_pointer': '/source_sha256/Becoming.Identity',
                            'success_pointer': '/status', 'success_value': 'passed'})
refs.append({'path': f'{DEV}/DESIGN.md', 'role': 'integration', 'sha256': sha(f'{DEV}/DESIGN.md')})
refs.append({'path': f'{DEV}/review/REVIEW-LINEAGE.md', 'role': 'review', 'sha256': sha(f'{DEV}/review/REVIEW-LINEAGE.md')})
refs.append({'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)})

vs = r['validation_scope']
vs['en'] = (f"Machine-checked by the Lean 4.29.1 checker (receipt {RECEIPT_ID}): Becoming.GrammarLaws, "
            f"{gl['theorems']} theorems in {len(gl['declarations'])} declarations, and Becoming.KeptOnward, 40 representation "
            f"and bridge declarations in fourteen model modules, and the derivations of OU3c, OU3e and OU3f in fourteen more, "
            f"every axiom report empty, all cited; every changed module's statements print as before, but for the two "
            f"relation laws moved into the grammar at any universe. Read-only AI reviews, every finding taken: three of OU3b, "
            f"one each of OU3c to OU3e, three of OU3f, two with a second pass; not reviewed by a person.")
vs['zh'] = (f"Lean 4.29.1 检查器实查（回执 {RECEIPT_ID}）：Becoming.GrammarLaws，{len(gl['declarations'])} 项声明中 "
            f"{gl['theorems']} 条定理，及 Becoming.KeptOnward，十四个模型模块中 40 项表示与桥接声明，及另十四模块中 OU3c、OU3e、OU3f "
            f"之推导，公理报告皆空，本记录全引；诸改动模块之陈述所印如前，唯移入文法之二关系律推广至任一宇宙。只读 AI 审查，所见皆采："
            f"OU3b 三次，OU3c 至 OU3e 各一次，OU3f 三次，其中两次复审一遍；未经人审。")
assert len(vs['en']) <= 600, len(vs['en'])
r['history'].append({
    'en': f"29 October 2026 (OU3f, study section {N}): the lineage laws of Becoming.Identity proved from the laws of steps "
          f"(Web.Lineage.unique from «迭之定», origin from «迭之定前», split and through from «迭之分», onward and back from "
          f"«或有后则或迭», back through «迭之逆»), a lineage read as the grammar's steps of the continuation within activity "
          f"(Web.steps_iff_lineage), statements unchanged; Web.steps_advance moved from MapInstances to Identity, unchanged; "
          f"the does-not-show item on the lineage laws dropped.",
    'zh': f"2026年10月29日（OU3f，研究第 {N} 节）：Becoming.Identity 之谱系诸律由计步之律证出（Web.Lineage.unique 出自「迭之定」，"
          f"origin 出自「迭之定前」，split 与 through 出自「迭之分」，onward 与 back 出自「或有后则或迭」，back 经「迭之逆」），"
          f"谱系读为活跃之内续之文法之步（Web.steps_iff_lineage），陈述不变；Web.steps_advance 自 MapInstances 移至 Identity，不变；"
          f"关于谱系诸律之「未示」一条删去。"})
P.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record extended; validation scope', len(vs['en']), 'chars')
