#!/usr/bin/env python3
"""HE: the records the moves touch, after the checker run. (deferred_grammarpath.py has already written its record,
what-a-line-holds-and-a-regularity-takes-in, with its own history line.)
  master-laws-on-the-grammar: kept_onward's reference moves from Becoming.KeptOnward to GrammarLaws, its binding
    goes; «保之像» joins the lumping group and the GrammarLaws reference; Mechanism's factors_image and Image.least join
    the last group and the Mechanism reference, as cases of «保之像»; the validation scope drops KeptOnward; history.
  processes-represented-both-ways: «保之像» moves from its GrammarTransport reference to its GrammarLaws reference,
    which gets a proof binding; history.
  what-keeping-widening-needs: total_eq_of_supports moves from its KeepingWidening reference to a new Dissipation
    reference with a proof binding; history.
Each anchor is found by its text and asserted.
usage (from the checkout root, after the checker): python3 -B <kit>/he_records.py RECEIPT N"""
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path.cwd()
RECEIPT_ID, N = sys.argv[1], int(sys.argv[2])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
DEV = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/he-held-edits'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECS = ROOT / 'theories/becoming/results/records'


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
gl = mods['Becoming.GrammarLaws']


def binding(path, module):
    return {'source': path, 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{module}',
            'success_pointer': '/status', 'success_value': 'passed'}


def ref(r, path):
    found = [x for x in r['references'] if x['path'] == path and x['role'] == 'proof']
    assert len(found) == 1, (r['id'], path, len(found))
    return found[0]


def history(r, en, zh):
    r['history'].append({'en': f'29 October 2026 (HE, study section {N}): ' + en,
                         'zh': f'2026年10月29日（HE，研究第 {N} 节）：' + zh})


# master-laws-on-the-grammar
p = RECS / 'master-laws-on-the-grammar.json'
r = json.loads(p.read_text(encoding='utf-8'))
ko = ref(r, lean('KeptOnward'))
assert ko['declarations'] == ['Becoming.kept_onward'], ko['declarations']
r['references'].remove(ko)
before = len(r['proof_bindings'])
r['proof_bindings'] = [b for b in r['proof_bindings'] if b['source'] != lean('KeptOnward')]
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
for key, old, new in (('en', 'and Becoming.KeptOnward, ', ''), ('zh', '及 Becoming.KeptOnward，', '')):
    assert vs[key].count(old) == 1, (key, old)
    vs[key] = vs[key].replace(old, new)
vs['en'] = vs['en'].split('(receipt ')[0] + f'(receipt {RECEIPT_ID}): Becoming.GrammarLaws, ' + \
    f"{gl['theorems']} theorems in {len(gl['declarations'])} declarations, " + vs['en'].split(' declarations, ', 1)[1]
vs['zh'] = vs['zh'].split('（回执 ')[0] + f'（回执 {RECEIPT_ID}）：Becoming.GrammarLaws，{len(gl["declarations"])} 项声明中 ' + \
    f"{gl['theorems']} 条定理，" + vs['zh'].split(' 条定理，', 1)[1]
assert len(vs['en']) <= 600, len(vs['en'])
r['references'].append({'path': f'{DEV}/DESIGN.md', 'role': 'integration', 'sha256': sha(f'{DEV}/DESIGN.md')})
r['references'].append({'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)})
history(r, "kept_onward moved from Becoming.KeptOnward, now retired, to its home beside «线则所闭» in GrammarLaws; «保之像» "
           "moved from GrammarTransport to beside «像» in GrammarLaws, and Mechanism's factors_image and Image.least "
           "proved as its cases, statements and names unchanged; GrammarLaws' module doc says the lineage laws are proved "
           "from the laws of steps.",
        "kept_onward 自已退役之 Becoming.KeptOnward 移至其所居，GrammarLaws 中「线则所闭」之旁；「保之像」自 GrammarTransport "
        "移至 GrammarLaws 中「像」之旁，Mechanism 之 factors_image 与 Image.least 证为其例，陈述与名不变；GrammarLaws 之模块说明言"
        "谱系诸律由计步之律证出。")
p.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

# processes-represented-both-ways
p = RECS / 'processes-represented-both-ways.json'
r = json.loads(p.read_text(encoding='utf-8'))
gt, g = ref(r, lean('GrammarTransport')), ref(r, lean('GrammarLaws'))
assert 'Becoming.«保之像»' in gt['declarations'] and 'Becoming.«保之像»' not in g['declarations']
gt['declarations'] = [d for d in gt['declarations'] if d != 'Becoming.«保之像»']
gt['sha256'] = sha(lean('GrammarTransport'))
g['declarations'] = g['declarations'] + ['Becoming.«保之像»']
g['sha256'] = sha(lean('GrammarLaws'))
assert not any(b['source'] == lean('GrammarLaws') for b in r['proof_bindings'])
r['proof_bindings'].append(binding(lean('GrammarLaws'), 'GrammarLaws'))
history(r, "«保之像» moved from GrammarTransport to beside «像» in GrammarLaws, statement and name unchanged; its "
           "reference and binding follow.",
        "「保之像」自 GrammarTransport 移至 GrammarLaws 中「像」之旁，陈述与名不变；其引用与绑定随之。")
p.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

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
history(r, 'total_eq_of_supports moved from KeepingWidening to beside total_le_of_support in Dissipation, statement and '
           'name unchanged; its reference and binding follow.',
        'total_eq_of_supports 自 KeepingWidening 移至 Dissipation 中 total_le_of_support 之旁，陈述与名不变；其引用与绑定随之。')
p.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('records: master-laws-on-the-grammar, processes-represented-both-ways, what-keeping-widening-needs')
