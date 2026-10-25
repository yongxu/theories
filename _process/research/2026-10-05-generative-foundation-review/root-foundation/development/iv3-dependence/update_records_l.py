#!/usr/bin/env python3
"""IV3l: the review's fixes in the records self-concern-through-dependence (F14 in the store-degree law, F15 next step,
Routing.possible among the two-tier law's declarations) and need-and-feeding-read-with-time (F1 correspondence); references
re-hashed to the new receipt; one history note each.
usage (from the checkout root, after apply_text_l.py): python3 -B update_records_l.py CORE_RECEIPT STUDY_SECTION"""
import datetime
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RECORDS = ROOT / 'theories/becoming/results/records'
SOURCE = f'{PKG}/Becoming/Weightings.lean'
core_id, N = sys.argv[1], int(sys.argv[2])
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
R = json.loads((ROOT / RECEIPT).read_text())
assert R['status'] == 'passed'
found = [m for m in R['modules'] if m['module'] == 'Becoming.Weightings']
assert len(found) == 1 and not any(found[0]['axiom_dependencies'].values())
HAVE = {d['name'] for d in found[0]['declarations']}
assert 'Becoming.Routing.possible' in HAVE
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def rehash(d):
    for ref in d['references']:
        if ref['role'] == 'receipt':
            ref['path'] = RECEIPT
        ref['sha256'] = sha(ref['path'])
    for binding in d['proof_bindings']:
        if binding['source'] == SOURCE:
            binding['receipt'] = RECEIPT


def setv(field, old, new):
    assert field.count(old) == 1, old[:60]
    return field.replace(old, new)


p1 = RECORDS / 'self-concern-through-dependence.json'
d = json.loads(p1.read_text(encoding='utf-8'))
law = d['laws'][-2]
law['en'] = setv(law['en'], "has a member giving at least the sum of its shortfalls under the stores' falls, and where it can "
                 "give each some such flow has it give exactly that",
                 "has each member give at least the sum of its shortfalls under the stores' falls, and where a member can "
                 "give each, some such flow has it give exactly that")
law['zh'] = setv(law['zh'], "都使某成员至少给出其在库存下降量下的缺额之和；它能给出每个缺额时", "都使每个成员至少给出其在库存下降量下的缺额之和；某成员能给出每个缺额时")
assert len(law['en']) <= 420 and len(law['zh']) <= 190
two = d['laws'][-1]
two['declarations'] = sorted(set(two['declarations']) | {'Becoming.Routing.possible'})
d['next_delta'] = {'en': 'More tiers, each tier\'s capacity read off its own supply; the degree of need across two tiers. Need '
                         'and feeding read with time are in need-and-feeding-read-with-time.',
                   'zh': '更多层，每层的容量从其自身供给读出；跨两层的被需要程度。带着时间来读的所需与供养见 need-and-feeding-read-with-time。'}
for ref in d['references']:
    if ref['path'] == SOURCE and ref['role'] == 'proof':
        ref['declarations'] = sorted(set(ref['declarations']) | {'Becoming.Routing.possible'})
rehash(d)
d['reviewed_at_utc'] = NOW
d['history'].append({'en': f'25 October 2026: corrected (IV3l) after an independent review against the Lean: each member, not a '
                           f'member, in the store-degree law; the two-tier witnesses shown not vacuous (Routing.possible); next '
                           f'step updated; study section {N}.',
                     'zh': f'2026年10月25日：经对照 Lean 的独立审查后修正（IV3l）：库存程度之律中为每个成员而非某成员；两层见证经证明非空真'
                           f'（Routing.possible）；下一步更新；研究第 {N} 节。'})
p1.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

p2 = RECORDS / 'need-and-feeding-read-with-time.json'
e = json.loads(p2.read_text(encoding='utf-8'))
e['correspondence'] = {
    'en': 'PW note §2-§3 held that need reaches contemporaries and predecessors, never successors, and that the feeding closure '
          'reaches the future only read without time. The Lean corrects the first: need reaches, except vacuously, only what is '
          'active within the stretch it is read across, so neither predecessors nor successors active only outside it. Parfit: '
          'what matters passes to successors in degrees; here need does not pass at all, and the reach past one\'s end is a '
          'question of classes (GS2).',
    'zh': 'PW 笔记 §2-§3 认为所需达到同时代者与前人，从不达到后来者；供养闭包只在不带时间来读时达到未来。Lean 修正了前一点：所需除空真情形外只达到'
          '在其所读区间内活跃者，故只在区间外活跃的前人与后来者都不达到。帕菲特：重要者以程度传给后来者；此处所需全不传递，过己之终的所及是类的问题（GS2）。'}
assert len(e['correspondence']['en']) <= 1200 and len(e['correspondence']['zh']) <= 500
e['validation_scope']['en'] = e['validation_scope']['en'].replace('Author review in study section 397.',
                                                                  f'Author review in study section 397; an independent AI reader '
                                                                  f'checked it against the Lean, its findings fixed in section {N}.')
e['validation_scope']['zh'] = e['validation_scope']['zh'].replace('作者审查见研究第 397 节。',
                                                                  f'作者审查见研究第 397 节；一个独立的 AI 读者对照 Lean 审查，其发现在第 {N} 节修正。')
e['validation_scope']['en'] = e['validation_scope']['en'].replace(e['validation_scope']['en'].split('(receipt ')[1].split(')')[0], core_id)
e['validation_scope']['zh'] = e['validation_scope']['zh'].replace(e['validation_scope']['zh'].split('（回执 ')[1].split('）')[0], core_id)
assert len(e['validation_scope']['en']) <= 600 and len(e['validation_scope']['zh']) <= 260
rehash(e)
e['reviewed_at_utc'] = NOW
e['history'].append({'en': f'25 October 2026: corrected (IV3l) after an independent review against the Lean: the correspondence '
                           f'says the Lean corrects PW on predecessors; study section {N}.',
                     'zh': f'2026年10月25日：经对照 Lean 的独立审查后修正（IV3l）：对应项说明 Lean 在前人一点上修正 PW；研究第 {N} 节。'})
p2.write_text(json.dumps(e, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('updated both records')
