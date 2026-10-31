#!/usr/bin/env python3
"""HE2: the records, after the checker run, in one pass, so that each record gets one HE2 history note.
  items 2 to 4 (he2_u4.py) and items 6 and 7 (he2_core_li.py): each kit's records part, run here without its notes;
    their clauses are folded below.
  item 1 (ou3f-activity-laws/he2-item1/KIT.md): continuation-relative-to-a-class, the law citing «两端分则中有标»
    (laws.9), en and zh, widened as its owner gave it: a relation that composes, a class being one.
  item 5 (ou3b-master-laws-on-the-grammar/he2-item5/KIT.md): generation-and-degeneration-at-two-grains cites
    Map.step_reached_le, Map.step_reaches and Map.step_reaches_of_le from GrammarMap, where item 5 moves them, and
    no longer from MapRegions, and the validation scope gives both modules' counts at HE2's receipt; the two
    references' hashes and bindings are the re-point's, as for every record whose source changed.
  master-laws-on-the-grammar: the validation scope, within its cap, gives HE2's receipt and GrammarLaws' counts, every
    declaration of GrammarLaws cited; the design, the review and the receipt are referenced.
  One history note per record: an item's own note where one item changes the record, else one note giving each
    item's clause in item order.
Every anchor is found by its text and asserted before anything is written. `--check` writes nothing and prints the
notes; the kits' own parts run in check mode.
usage (from the checkout root, after the checker): python3 -B <kit>/he2_records.py RECEIPT N [--check]"""
from datetime import datetime, timezone
import hashlib
import importlib.util
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
RECEIPT_ID, N = sys.argv[1], int(sys.argv[2])
CHECK = '--check' in sys.argv
DEV = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/'
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
HERE = DEV + 'he2-held-edits/'
REVIEW = HERE + 'review/REVIEW-HE2.md'
RECS = ROOT / 'theories/becoming/results/records'
ML, CRC, GDG = 'master-laws-on-the-grammar', 'continuation-relative-to-a-class', 'generation-and-degeneration-at-two-grains'


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, ROOT / path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


k24 = load('k24', DEV + 'u4-one-root-to-its-edge/he2-items-2-to-4/he2_u4.py')
k67 = load('k67', DEV + 'rv21-one-sense/kit/he2_core_li.py')


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def lean(m):
    return f'{PKG}/Becoming/{m}.lean'


def read(rid):
    return json.loads((RECS / f'{rid}.json').read_text(encoding='utf-8'))


def ref(r, path):
    found = [x for x in r['references'] if x['path'] == path and x['role'] == 'proof']
    assert len(found) == 1, (r['id'], path, len(found))
    return found[0]


def add_ref(r, path, role):
    assert (ROOT / path).exists(), path
    if not any(x['path'] == path for x in r['references']):
        r['references'].append({'path': path, 'role': role, 'sha256': sha(path)})


# The receipt: passed, every changed module's source the one checked, and the declarations where the items put them.
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed', core['status']
mods = {m['module']: m for m in core['modules']}
for m in ('Grammar', 'GrammarLaws', 'GrammarRegularity', 'GrammarScope', 'GrammarCandidates', 'GrammarMap',
          'MapRegions', 'WideningOnTheMap', 'HeldPossible', 'PatternPassing', 'Sampling', 'Response', 'SelectionPool'):
    assert core['source_sha256'][f'Becoming.{m}'] == sha(lean(m)), m
    assert not any(mods[f'Becoming.{m}']['axiom_dependencies'].values()), m


def names(m):
    return {d['name'] for d in mods[f'Becoming.{m}']['declarations']}


def theorems(m):
    return mods[f'Becoming.{m}']['theorems']


GL_NEW = [k24.full(n) for n in k24.NEW] + [k67.full(n) for n in k67.NEW_LAWS]
assert set(GL_NEW) <= names('GrammarLaws'), sorted(set(GL_NEW) - names('GrammarLaws'))
MOVED = [f'Becoming.Map.{n}' for n in ('step_reached_le', 'step_reaches', 'step_reaches_of_le')]
assert set(MOVED) <= names('GrammarMap') and not set(MOVED) & names('MapRegions')

# Item 1's widening (its KIT, "One claim widened").
I1_LAW = 'Becoming.«两端分则中有标»'
I1_EN = ('and where every step keeps a class or carries a mark, a line whose ends the class tells apart has a marked step',
         'and where every step keeps a relation that composes (a class is one) or carries a mark, a line whose ends '
         'the relation tells apart has a marked step')
I1_ZH = ('凡每一步或保一类或带一标者，其两端为此类所分之线，必有带标之一步',
         '凡每一步或保一传递之关系（类即其一）或带一标者，其两端为此关系所分之线，必有带标之一步')


def item1(r):
    laws = [law for law in r['laws'] if I1_LAW in law['declarations']]
    assert len(laws) == 1, (CRC, len(laws))
    law = laws[0]
    for lang, (old, new) in (('en', I1_EN), ('zh', I1_ZH)):
        assert law[lang].count(old) == 1 and new not in law[lang], (CRC, lang)
        law[lang] = law[lang].replace(old, new)
    return r['laws'].index(law)


# Item 5's move, and the scope's counts after it.
GDG_VS_EN = ('Becoming.GrammarMap, 39 theorems in 58 declarations, and',
             'Becoming.MapRegions (GW1, GW2), a core leaf importing GrammarMap only, 39 theorems in 45 declarations at '
             'receipt 20261030T152859.871907Z, every')
GDG_VS_ZH = ('由核心检查器以 Lean 4.29.1 从前奏检查：Becoming.GrammarMap，58 个声明中 39 条定理，',
             'MapRegions（GW1、GW2，核心叶）于回执 20261030T152859.871907Z：45 项声明（39 项定理），')


def item5(r):
    mr, gm = ref(r, lean('MapRegions')), ref(r, lean('GrammarMap'))
    assert all(d in mr['declarations'] for d in MOVED) and not any(d in gm['declarations'] for d in MOVED), GDG
    mr['declarations'] = [d for d in mr['declarations'] if d not in MOVED]
    was_sorted = gm['declarations'] == sorted(gm['declarations'])
    gm['declarations'] += MOVED
    if was_sorted:
        gm['declarations'].sort()
    vs = r['validation_scope']
    gd, md = len(names('GrammarMap')), len(names('MapRegions'))
    assert all(vs['en'].count(s) == 1 for s in GDG_VS_EN) and all(vs['zh'].count(s) == 1 for s in GDG_VS_ZH), GDG
    vs['en'] = (vs['en'].replace(GDG_VS_EN[0], f"Becoming.GrammarMap, {theorems('GrammarMap')} theorems in {gd} "
                                               f"declarations at receipt {RECEIPT_ID}, and")
                .replace(GDG_VS_EN[1], f"Becoming.MapRegions (GW1, GW2), a core leaf importing GrammarMap only, "
                                       f"{theorems('MapRegions')} theorems in {md} declarations at the same receipt, "
                                       "every"))
    vs['zh'] = (vs['zh'].replace(GDG_VS_ZH[0], f'核心检查器以 Lean 4.29.1 从前奏检查（回执 {RECEIPT_ID}）：'
                                               f"Becoming.GrammarMap，{gd} 个声明中 {theorems('GrammarMap')} 条定理，")
                .replace(GDG_VS_ZH[1], f"MapRegions（GW1、GW2，核心叶）于同一回执：{md} 项声明"
                                       f"（{theorems('MapRegions')} 项定理），"))
    assert len(vs['en']) <= 600 and len(vs['zh']) <= 260, (GDG, len(vs['en']), len(vs['zh']))
    add_ref(r, RECEIPT, 'receipt')


# The master-laws record's scope: HE2's receipt and GrammarLaws' counts, every declaration cited.
ML_VS_EN_START = 'Machine-checked by the Lean 4.29.1 checker (receipt 20261029T184601.050950Z): Becoming.GrammarLaws, '


def ml_scope(r):
    gl = ref(r, lean('GrammarLaws'))
    assert set(gl['declarations']) == names('GrammarLaws'), sorted(set(gl['declarations']) ^ names('GrammarLaws'))
    vs = r['validation_scope']
    assert vs['en'].startswith(ML_VS_EN_START), vs['en'][:120]
    t, d = theorems('GrammarLaws'), len(names('GrammarLaws'))
    vs['en'] = (f"Machine-checked by the Lean 4.29.1 checker (receipt {RECEIPT_ID}): Becoming.GrammarLaws, {t} theorems "
                f"in {d} declarations, 40 representation and bridge declarations in 14 model modules, the derivations "
                "of OU3c, OU3e and OU3f in 14 more and of HE in Mechanism, every axiom report empty, all cited; changed "
                "modules' statements print as before but for two relation laws at any universe (OU3b), HE2's renames "
                "and one weakened law. Read-only AI reviews, every finding taken: three of OU3b, one each of OU3c to "
                "OU3e, HE and HE2, three of OU3f, three with a second pass; not reviewed by a person.")
    vs['zh'] = (f"Lean 4.29.1 检查器实查（回执 {RECEIPT_ID}）：Becoming.GrammarLaws，{d} 项声明中 {t} 条定理，十四模型模块 40 "
                "项表示桥接声明，另十四模块 OU3c、OU3e、OU3f 及 Mechanism 之 HE 推导，公理报告皆空，皆引；改动模块陈述所印如前，唯 "
                "OU3b 二关系律及任一宇宙、HE2 改名与一律设宽。只读 AI 审查，所见皆采：OU3b 三次，OU3c 至 OU3e、HE 与 HE2 各一次，"
                "OU3f 三次，其中三次复审；未经人审。")
    assert len(vs['en']) <= 600 and len(vs['zh']) <= 260, (ML, len(vs['en']), len(vs['zh']))
    add_ref(r, HERE + 'DESIGN.md', 'integration')
    add_ref(r, REVIEW, 'review')
    add_ref(r, RECEIPT, 'receipt')


# The history notes. Each item's clause is (label en, label zh, body en, body zh); a record changed by one item gets
# that item's note, a record changed by several one note with each item's clause in item order.
day = datetime.now(timezone.utc)
DAY_EN, DAY_ZH = f'{day.day} {day:%B %Y}', f'{day.year}年{day.month}月{day.day}日'
EN_RE = re.compile(r'^(\d+ \w+ \d{4}), board item HE2, (items? [^()]+?) \(study section (\d+)\): (.+)$', re.S)
ZH_RE = re.compile(r'^(\d{4}年\d+月\d+日)，工作板条目 HE2 之(第.+?项)（研究第 (\d+) 节）：(.+)$', re.S)
NO_OTHER = (re.compile(r'[.;] [Nn]o other law changes\.$'), re.compile(r'[。；]其余之律不变。$'))


def clause(note):
    e, z = EN_RE.match(note['en']), ZH_RE.match(note['zh'])
    assert e and z and int(e.group(3)) == int(z.group(3)) == N, note
    return e.group(2), z.group(2), e.group(4), z.group(4)


I1_CLAUSE = ('item 1', '第 1 项',
             '«两端分则中有标» asks only that the relation it keeps compose (its hypotheses split, then trans, in place '
             'of a class), so laws.{law}.en and laws.{law}.zh now read a relation that composes, a class being one; its '
             'declarations are unchanged.',
             '«两端分则中有标» 只求所保之关系传递（其设先分后传，以代类），故 laws.{law}.en 与 laws.{law}.zh 今言保一传递之关系，类即其一；所引声明不变。')
I5_CLAUSE = ('item 5', '第 5 项',
             "the successor's three reach laws (Map.step_reached_le, Map.step_reaches, Map.step_reaches_of_le) moved "
             'from MapRegions into GrammarMap whole, names and statements unchanged, so this record cites them from '
             "GrammarMap, and the validation scope gives both modules' counts at HE2's receipt; no law's text changes.",
             '后继之三及达律（Map.step_reached_le、Map.step_reaches、Map.step_reaches_of_le）连名与陈述整移自 MapRegions 入 '
             'GrammarMap，本记录遂自 GrammarMap 引之，验证范围言二模块于 HE2 回执之数；诸律之文不变。')


def history(clauses):
    if len(clauses) == 1:
        le, lz, be, bz = clauses[0]
        return {'en': f'{DAY_EN}, board item HE2, {le} (study section {N}): {be}',
                'zh': f'{DAY_ZH}，工作板条目 HE2 之{lz}（研究第 {N} 节）：{bz}'}
    other = any(NO_OTHER[0].search(c[2]) for c in clauses)
    en, zh = [], []
    for le, lz, be, bz in clauses:
        if other:
            be, bz = NO_OTHER[0].sub('.', be), NO_OTHER[1].sub('。', bz)
        en.append(f'{le[0].upper() + le[1:]}: {be}')
        zh.append(f'{lz}：{bz}')
    return {'en': f'{DAY_EN}, board item HE2 (study section {N}). ' + ' '.join(en)
                  + (' No other law changes.' if other else ''),
            'zh': f'{DAY_ZH}，工作板条目 HE2（研究第 {N} 节）。' + ''.join(zh) + ('其余之律不变。' if other else '')}


def order(label):
    return int(re.search(r'\d+', label).group())


# Run. Every record is checked before any file is written: the kits' parts in check mode first, then this kit's
# edits on copies of the records as they will be after the kits' parts.
applied = [rid for rid in (ML, CRC, GDG) if any('board item HE2' in h['en'] for h in read(rid)['history'])]
if applied:
    print('HE2 history notes already in', ', '.join(applied), '- nothing done')
    sys.exit(0 if len(applied) == 3 else 1)
k24.records(False)
k67.records(False, N)
item1(read(CRC))
item5(read(GDG))
r = read(ML)
ref(r, lean('GrammarLaws'))['declarations'] += [d for d in GL_NEW if d not in ref(r, lean('GrammarLaws'))['declarations']]
ml_scope(r)  # on a copy, as the kits' parts will leave it
if not CHECK:
    k24.records(True, N, notes=False)
    k67.records(True, N, notes=False)
clauses = {}
clauses.setdefault(ML, []).append(clause(k24.ml_note(N)))
for rid, note in k67.HELD.items():
    clauses.setdefault(rid, []).append(clause(note))
writes = {}
r = read(CRC)
law = item1(r)
clauses[CRC].append(tuple(s.format(law=law) for s in I1_CLAUSE))
writes[CRC] = r
r = read(GDG)
item5(r)
clauses.setdefault(GDG, []).append(I5_CLAUSE)
writes[GDG] = r
if not CHECK:
    r = read(ML)
    ml_scope(r)
writes[ML] = r
for rid in clauses:
    r = writes.get(rid) or read(rid)
    note = history(sorted(clauses[rid], key=lambda c: order(c[0])))
    if CHECK:
        print(f'{rid}\n  en: {note["en"]}\n  zh: {note["zh"]}')
    r['history'].append(note)
    writes[rid] = r
if CHECK:
    print(f'checked: {len(writes)} records; nothing written')
else:
    for rid, r in writes.items():
        path = RECS / f'{rid}.json'
        raw = path.read_text(encoding='utf-8')
        path.write_text(json.dumps(r, ensure_ascii=False, indent=2) + ('\n' if raw.endswith('\n') else ''),
                        encoding='utf-8')
    print('records:', ', '.join(sorted(writes)), '; dated', DAY_EN)
