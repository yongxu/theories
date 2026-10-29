#!/usr/bin/env python3
"""OU3f, closure: extend master-laws-on-the-grammar. The closure group gains kept_onward (a region every step keeps holds
from where it holds on, the closure at the successor along a line); the last group gains the eight inductions over steps
proved by it; proof references and bindings for Becoming.KeptOnward and the six modules; the design, the review and the
receipt; the validation scope within its cap; a history note.
usage (from the checkout root, after the checker): python3 -B <kit>/records_closure.py RECEIPT N"""
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
RECEIPT_ID, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
DEV = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3f-activity-laws/closure'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
P = ROOT / 'theories/becoming/results/records/master-laws-on-the-grammar.json'
W = 'Becoming.Web.'
BY_MODULE = {'KeptOnward': ['Becoming.kept_onward'],
             'Retaining': [W + 'inactive_of_not_arising'], 'Wholes': [W + 'active_back'],
             'Exclusion': [W + 'active_before'], 'Reserve': [W + 'ended_for_good'],
             'PatternPassing': [W + 'ByPassing.present_earlier', W + 'ByPassing.trace', W + 'ByPassing.line_back'],
             'Persistence': [W + 'steady_held']}
DERIVED = [d for m, ds in BY_MODULE.items() if m != 'KeptOnward' for d in ds]


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
mods = {m['module']: m for m in core['modules']}
for m, ds in BY_MODULE.items():
    entry = mods[f'Becoming.{m}']
    assert not any(entry['axiom_dependencies'].values()), m
    assert set(ds) <= {d['name'] for d in entry['declarations']}, (m, set(ds) - {d['name'] for d in entry['declarations']})
    assert core['source_sha256'][f'Becoming.{m}'] == sha(f'{PKG}/Becoming/{m}.lean'), m
gl = mods['Becoming.GrammarLaws']

r = json.loads(P.read_text(encoding='utf-8'))
closure = r['laws'][0]
assert closure['en'].startswith('Closure.'), closure['en'][:20]
closure['en'] = closure['en'].rstrip() + (' A region of the steps of time that every step keeps holds from where it holds on: the '
                                          'closure at the successor along a line.')
closure['zh'] = closure['zh'].rstrip() + '每步皆守之时步之域，自其所守处以后皆守：即闭包于后继沿线。'
closure['declarations'] = closure['declarations'] + ['Becoming.kept_onward']
last = r['laws'][17]
END_EN, END_ZH = 'k steps advancing the index by k.', 'k 步则指标增 k。'
assert last['en'].endswith(END_EN) and last['zh'].endswith(END_ZH), 'the last group has changed; re-read it'
last['en'] = last['en'][:-1] + ('; and the inductions over steps that keep a region, from a region every step keeps holding from '
                                'where it holds on: never arising from an inactive start being never active, activity and '
                                'presence kept back, an ending kept, a name kept over a held stretch, and a carrier and the '
                                "pattern's line traced back.")
last['zh'] = last['zh'][:-1] + ('；又守一域之逐步归纳，出自每步皆守之域自其所守处以后皆守：自不活跃之始而永不生则永不活跃、活跃与在场之回溯、'
                                '终之所守、持守之段上之一名，以及载者与样式之线之回溯。')
last['declarations'] = sorted(set(last['declarations']) | set(DERIVED))
refs = r['references']
at = max(i for i, x in enumerate(refs) if x['role'] == 'proof') + 1
for m, ds in BY_MODULE.items():
    path = f'{PKG}/Becoming/{m}.lean'
    assert not any(x['path'] == path for x in refs), path
    refs.insert(at, {'path': path, 'role': 'proof', 'declarations': ds, 'sha256': sha(path)})
    at += 1
    r['proof_bindings'].append({'source': path, 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{m}',
                                'success_pointer': '/status', 'success_value': 'passed'})
refs.append({'path': f'{DEV}/DESIGN.md', 'role': 'integration', 'sha256': sha(f'{DEV}/DESIGN.md')})
refs.append({'path': f'{DEV}/review/REVIEW-CLOSURE.md', 'role': 'review', 'sha256': sha(f'{DEV}/review/REVIEW-CLOSURE.md')})
refs.append({'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)})
vs = r['validation_scope']
vs['en'] = (f"Machine-checked by the Lean 4.29.1 checker (receipt {RECEIPT_ID}): Becoming.GrammarLaws, "
            f"{gl['theorems']} theorems in {len(gl['declarations'])} declarations, and Becoming.KeptOnward, 40 representation "
            f"and bridge declarations in fourteen model modules, and the derivations of OU3c, OU3e and OU3f in thirteen more, "
            f"every axiom report empty, all cited; every changed module's statements print as before, but for the two "
            f"relation laws moved into the grammar at any universe. Read-only AI reviews, every finding taken: three of OU3b, "
            f"one each of OU3c to OU3e, two of OU3f, two with a second pass; not reviewed by a person.")
vs['zh'] = (f"Lean 4.29.1 检查器实查（回执 {RECEIPT_ID}）：Becoming.GrammarLaws，{len(gl['declarations'])} 项声明中 "
            f"{gl['theorems']} 条定理，及 Becoming.KeptOnward，十四个模型模块中 40 项表示与桥接声明，及另十三模块中 OU3c、OU3e、OU3f "
            f"之推导，公理报告皆空，本记录全引；诸改动模块之陈述所印如前，唯移入文法之二关系律推广至任一宇宙。只读 AI 审查，所见皆采："
            f"OU3b 三次，OU3c 至 OU3e 各一次，OU3f 两次，其中两次复审一遍；未经人审。")
assert len(vs['en']) <= 600, len(vs['en'])
r['history'].append({
    'en': f"29 October 2026 (OU3f, study section {N}): the closure at the successor along a line, that a region every step "
          f"keeps holds from where it holds on (kept_onward, in Becoming.KeptOnward, its home beside «线则所闭» in "
          f"GrammarLaws), and the eight inductions over steps in six model modules proved by it in place of their own "
          f"(board rule 9), statements unchanged.",
    'zh': f"2026年10月29日（OU3f，研究第 {N} 节）：闭包于后继沿线，即每步皆守之域自其所守处以后皆守（kept_onward，在 Becoming.KeptOnward，"
          f"其所居在 GrammarLaws 中「线则所闭」之旁），及六个模型模块中八条逐步归纳以之代其自证（板规九），陈述不变。"})
P.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record extended; validation scope', len(vs['en']), 'chars')
