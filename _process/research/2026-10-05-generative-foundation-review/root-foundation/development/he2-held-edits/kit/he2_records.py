#!/usr/bin/env python3
"""HE2: the records, after the checker run, in one pass, so that each record gets one HE2 history note.
  items 2 to 4 (he2_u4.py) and items 6 and 7 (he2_core_li.py): each kit's records part, run here without its notes;
    their clauses are folded below.
  item 1 (ou3f-activity-laws/he2-item1/KIT.md): continuation-relative-to-a-class, the law citing «两端分则中有标»
    (laws.9), en and zh, widened as its owner gave it and the record's owner worded it: a transitive relation, a class being one.
  item 5 (ou3b-master-laws-on-the-grammar/he2-item5/KIT.md): generation-and-degeneration-at-two-grains cites
    Map.step_reached_le, Map.step_reaches and Map.step_reaches_of_le from GrammarMap, where item 5 moves them, and
    no longer from MapRegions, and the validation scope gives both modules' counts at HE2's receipt; the two
    references' hashes and bindings are the re-point's, as for every record whose source changed.
  master-laws-on-the-grammar: the validation scope, within its cap, gives HE2's receipt and GrammarLaws' counts, every
    declaration of GrammarLaws cited; the does-not-show item on a pairing under continuation narrowed to what is not
    stated, as GrammarLaws' module doc is; the hypotheses name the test a region, a class or a continuation is read by,
    and the census's lists without repeats; the design, the review and the receipt are referenced.
  continuation-relative-to-a-class: Grammar's counts in the validation scope, stale since OU6 (70 theorems in 118).
  laws-at-coarser-steps (item 1): the scope's Sampling binding names HE2's receipt, since the re-point rebinds it.
  One history note per record: an item's own note where one item changes the record, else one note giving each
    item's clause in item order.
Every anchor is found by its whole text and asserted before anything is written; the study section N must be the
next; the records written must be the eight expected, and no other record may cite the three moved laws. The kits'
parts write first: every record is snapshotted before, and restored if anything after fails. One date, the local
day, dates every note. `--check` writes nothing and prints the notes; the kits' own parts run in check mode.
usage (from the checkout root, after the checker): python3 -B <kit>/he2_records.py RECEIPT N [--check]"""
from datetime import date
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
LCS = 'laws-at-coarser-steps'
EXPECTED = {ML, CRC, GDG, LCS, 'a-regularity-kept-and-changed', 'candidate-theorems-of-the-corpus', 'reach-past-ones-own-end',
            'what-a-line-holds-and-a-regularity-takes-in'}
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'


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
         'and where every step keeps a transitive relation (a class is one) or carries a mark, a line whose ends the '
         'relation tells apart has a marked step')
I1_ZH = ('凡每一步或保一类或带一标者，其两端为此类所分之线，必有带标之一步',
         '凡每一步或保一传递之关系（类即其一）或带一标者，其两端为此关系所分之线，必有带标之一步')


CRC_VS = ('Becoming.Grammar, 68 theorems in 116 declarations,', 'Becoming.Grammar，116 个声明中 68 条定理，')


def crc_scope(r):
    vs = r['validation_scope']
    assert vs['en'].count(CRC_VS[0]) == 1 and vs['zh'].count(CRC_VS[1]) == 1, CRC
    t, d = theorems('Grammar'), len(names('Grammar'))
    vs['en'] = vs['en'].replace(CRC_VS[0], f'Becoming.Grammar, {t} theorems in {d} declarations,')
    vs['zh'] = vs['zh'].replace(CRC_VS[1], f'Becoming.Grammar，{d} 个声明中 {t} 条定理，')
    assert len(vs['en']) <= 600 and len(vs['zh']) <= 260, (CRC, len(vs['en']), len(vs['zh']))


def item1(r):
    laws = [law for law in r['laws'] if I1_LAW in law['declarations']]
    assert len(laws) == 1, (CRC, len(laws))
    law = laws[0]
    for lang, (old, new) in (('en', I1_EN), ('zh', I1_ZH)):
        assert law[lang].count(old) == 1 and new not in law[lang], (CRC, lang)
        law[lang] = law[lang].replace(old, new)
    return r['laws'].index(law)


# Item 5's move, and the scope's counts after it.
GDG_MI = 'and Becoming.MapInstances, 28 theorems, each'
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
    assert all(vs['en'].count(s) == 1 for s in GDG_VS_EN + (GDG_MI,)) and all(vs['zh'].count(s) == 1 for s in GDG_VS_ZH), GDG
    vs['en'] = vs['en'].replace(GDG_MI, f"and Becoming.MapInstances, {theorems('MapInstances')} theorems, each")
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


# laws-at-coarser-steps: its scope names Sampling's binding, which the re-point moves to HE2's receipt (item 1).
LCS_VS = ('(Sampling to 20261020T051144.879480Z)', '（Sampling 绑定 20261020T051144.879480Z）')


def lcs_scope(r):
    vs = r['validation_scope']
    assert vs['en'].count(LCS_VS[0]) == 1 and vs['zh'].count(LCS_VS[1]) == 1, LCS
    vs['en'] = vs['en'].replace(LCS_VS[0], f'(Sampling to {RECEIPT_ID})')
    vs['zh'] = vs['zh'].replace(LCS_VS[1], f'（Sampling 绑定 {RECEIPT_ID}）')
    assert len(vs['en']) <= 600 and len(vs['zh']) <= 260, (LCS, len(vs['en']), len(vs['zh']))


# The master-laws record's scope: HE2's receipt and GrammarLaws' counts, every declaration cited.
ML_VS_OLD = ("Machine-checked by the Lean 4.29.1 checker (receipt 20261029T184601.050950Z): Becoming.GrammarLaws, 138 "
             "theorems in 162 declarations, 40 representation and bridge declarations in fourteen model modules, the "
             "derivations of OU3c, OU3e and OU3f in fourteen more and of HE in Mechanism, every axiom report empty, all "
             "cited; every changed module's statements print as before, but for the two relation laws moved into the "
             "grammar at any universe. Read-only AI reviews, every finding taken: three of OU3b, one each of OU3c to "
             "OU3e and HE, three of OU3f, three with a second pass; not reviewed by a person.",
             "Lean 4.29.1 检查器实查（回执 20261029T184601.050950Z）：Becoming.GrammarLaws，162 项声明中 138 条定理，十四个模型模块中 "
             "40 项表示与桥接声明，另十四模块中 OU3c、OU3e、OU3f 之推导及 Mechanism 中 HE 之推导，公理报告皆空，本记录全引；诸改动模块之"
             "陈述所印如前，唯移入文法之二关系律推广至任一宇宙。只读 AI 审查，所见皆采：OU3b 三次，OU3c 至 OU3e 与 HE 各一次，OU3f 三次，"
             "其中三次复审一遍；未经人审。")
ML_DNS = (('That a pairing under continuation adds anything to equal count, or the n-step law for lines of different '
           'lengths.',
           'That a pairing under continuation adds anything to equal count beyond what is now stated, the count on every '
           'region it does not cross and, under a class decided by a test, in every class; or the n-step law for lines '
           'of different lengths.'),
          ('续之下之配对于等长之外有所增益，或不同长度之线的 n 步之律。',
           '续之下之配对于等长之外、于今所述（其所不越之每一域守数，及一测所定之类下每一类守数）之外有所增益，或不同长度之线的 n 步之律。'))
# A hypothesis added (items 2 to 4): what counting reads, a modelling choice, as GrammarLaws' table and census say.
ML_HYP = {'en': "Counting reads a region, the class counted in and a continuation each as a test to Bool (a modelling "
                "choice; a proposition enters by decide), and the census of a step lists the units before and after "
                "once each.",
          'zh': '计数读所计之域、所计之类与续各为取真假值之测（建模之择；命题经判定而入），一步之清点所列前后之单位各只一次。'}


def ml_text(r):
    """The does-not-show item narrowed and the hypothesis added, after items 2 to 4's laws (style.py's item caps)."""
    hits = [x for x in r['does_not_show'] if x['en'] == ML_DNS[0][0] and x['zh'] == ML_DNS[1][0]]
    assert len(hits) == 1, (ML, 'does_not_show')
    hits[0]['en'], hits[0]['zh'] = ML_DNS[0][1], ML_DNS[1][1]
    assert len(ML_DNS[0][1]) <= 240 and len(ML_DNS[1][1]) <= 110
    assert ML_HYP not in r['hypotheses'] and len(r['hypotheses']) < 9
    assert len(ML_HYP['en']) <= 420 and len(ML_HYP['zh']) <= 190
    r['hypotheses'].append(dict(ML_HYP))


def ml_scope(r):
    gl = ref(r, lean('GrammarLaws'))
    assert set(gl['declarations']) == names('GrammarLaws'), sorted(set(gl['declarations']) ^ names('GrammarLaws'))
    vs = r['validation_scope']
    assert (vs['en'], vs['zh']) == ML_VS_OLD, 'the master-laws scope changed since the kit was written: re-read it'
    t, d = theorems('GrammarLaws'), len(names('GrammarLaws'))
    vs['en'] = (f"Checked by the Lean 4.29.1 checker (receipt {RECEIPT_ID}): Becoming.GrammarLaws, {t} theorems in {d} "
                "declarations, 40 representation and bridge declarations in 14 model modules, the derivations of OU3c, "
                "OU3e and OU3f in 14 more and of HE in Mechanism, every axiom report empty, all cited; changed modules' "
                "statements print as before but for two relation laws at any universe (OU3b), HE2's renames and one law "
                "widened. Read-only AI reviews, every finding taken: three of OU3b, one each of OU3c to OU3e and HE, two "
                "of HE2, three of OU3f, three with a second pass; not reviewed by a person.")
    vs['zh'] = (f"Lean 4.29.1 检查器查（回执 {RECEIPT_ID}）：Becoming.GrammarLaws，{d} 项声明中 {t} 条定理，十四模型模块 40 "
                "项表示桥接声明，另十四模块 OU3c、OU3e、OU3f 及 Mechanism 之 HE 推导，公理报告皆空，皆引；改动模块陈述所印如前，唯 "
                "OU3b 二关系律及任一宇宙、HE2 改名与一律设宽。只读 AI 审查，所见皆采：OU3b 三次，OU3c 至 OU3e 与 HE 各一次，HE2 "
                "二次，OU3f 三次，三次复审；未经人审。")
    assert len(vs['en']) <= 600 and len(vs['zh']) <= 260, (ML, len(vs['en']), len(vs['zh']))
    add_ref(r, HERE + 'DESIGN.md', 'integration')
    add_ref(r, REVIEW, 'review')
    add_ref(r, RECEIPT, 'receipt')


# The history notes. Each item's clause is (label en, label zh, body en, body zh); a record changed by one item gets
# that item's note, a record changed by several one note with each item's clause in item order.
day = date.today()  # the local day, as HE's notes and the board's
DAY_EN, DAY_ZH = f'{day.day} {day:%B %Y}', f'{day.year}年{day.month}月{day.day}日'
EN_RE = re.compile(r'^(\d+ \w+ \d{4}), board item HE2, (items? [^()]+?) \(study section (\d+)\): (.+)$', re.S)
ZH_RE = re.compile(r'^(\d{4}年\d+月\d+日)，工作板条目 HE2 之(第.+?项)（研究第 (\d+) 节）：(.+)$', re.S)
NO_OTHER = (re.compile(r'[.;] [Nn]o other law changes\.$'), re.compile(r'[。；]其余之律不变。$'))
# Items 6 and 7's tail speaks of their own renames; beside another item's clause it is said of them.
NO_CONTENT = ("; no statement's content changes.", '；所述之义皆不变。',
              "; these renames and rewordings change no statement's content.", '；此诸改名与措辞皆不改所述之义。')


def clause(note):
    e, z = EN_RE.match(note['en']), ZH_RE.match(note['zh'])
    assert e and z and int(e.group(3)) == int(z.group(3)) == N, note
    return e.group(2), z.group(2), e.group(4), z.group(4)


I1_CLAUSE = ('item 1', '第 1 项',
             '«两端分则中有标» asks only that the relation it keeps be transitive (its hypotheses split, then trans, in '
             'place of a class), so laws.{law}.en and laws.{law}.zh now read a transitive relation, a class being one; '
             'its declarations are unchanged.',
             '«两端分则中有标» 只求所保之关系传递（其设先分后传，以代类），故 laws.{law}.en 与 laws.{law}.zh 今言保一传递之关系，类即其一；所引声明不变。')
LCS_CLAUSE = ('item 1', '第 1 项',
              "Sampling's arises_within and ceases_within, which the coarse-step laws use, are now read from the grammar "
              "law «两端分则中有标» along the successor, their statements unchanged; the validation scope names Sampling's "
              "binding at HE2's receipt.",
              'Sampling 之 arises_within 与 ceases_within（粗步之律所用）今沿后继由文法之律 «两端分则中有标» 读出，陈述不变；验证'
              '范围言 Sampling 绑定于 HE2 之回执。')
CRC_LAND = ('the landing', '落地',
            "Grammar's counts in the validation scope corrected to the receipt (stale since OU6).",
            '验证范围中 Grammar 之数依回执更正（自 OU6 以来未更）。')
ML_LAND = ('the landing', '落地',
           "the validation scope gives HE2's receipt and GrammarLaws' counts, every declaration cited; the does-not-show "
           "item on a pairing under continuation is narrowed to what is not stated, as GrammarLaws' module doc is; a "
           "hypothesis names what counting reads as a test to Bool and the census's lists without repeats; HE2's "
           "design, review and receipt are referenced.",
           '验证范围言 HE2 之回执与 GrammarLaws 之数，声明皆引；续下配对之「未示」一项收窄至未述者，如 GrammarLaws 之模块说明；增一前提，'
           '言计数所读之取真假值之测与一步之清点所列无重；HE2 之设计、审查与回执已引。')
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
        if be.endswith(NO_CONTENT[0]):
            be, bz = be[:-len(NO_CONTENT[0])] + NO_CONTENT[2], bz.replace(NO_CONTENT[1], NO_CONTENT[3])
        en.append(f'{le[0].upper() + le[1:]}: {be}')
        zh.append(f'{lz}：{bz}')
    return {'en': f'{DAY_EN}, board item HE2 (study section {N}). ' + ' '.join(en)
                  + (' No other law changes.' if other else ''),
            'zh': f'{DAY_ZH}，工作板条目 HE2（研究第 {N} 节）。' + ''.join(zh) + ('其余之律不变。' if other else '')}


def order(label):
    found = re.search(r'\d+', label)
    return int(found.group()) if found else 99  # the landing's own clause last


# Run. Every record is checked before any file is written: the kits' parts in check mode first, then this kit's
# edits on copies of the records as they will be after the kits' parts.
study = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in study and max(int(x) for x in re.findall(r'^## (\d+)\. ', study, re.M)) == N - 1, \
    'N must be the study\'s next section'
citing = sorted(p.stem for p in RECS.glob('*.json') if any(d in p.read_text(encoding='utf-8') for d in MOVED))
assert citing == [GDG], ('records citing the moved reach laws beyond the one item 5 names', citing)
applied = [rid for rid in (ML, CRC, GDG) if any('board item HE2' in h['en'] for h in read(rid)['history'])]
if applied:
    print('HE2 history notes already in', ', '.join(applied), '- nothing done')
    sys.exit(0 if len(applied) == 3 else 1)
k24.records(False)
k67.records(False, N)
for rid, fns in ((CRC, (item1, crc_scope)), (GDG, (item5,)), (LCS, (lcs_scope,))):
    r = read(rid)
    for fn in fns:
        fn(r)
ml_copy = read(ML)
ref(ml_copy, lean('GrammarLaws'))['declarations'] += [d for d in GL_NEW
                                                      if d not in ref(ml_copy, lean('GrammarLaws'))['declarations']]
ml_scope(ml_copy)  # on a copy, as the kits' parts will leave it
ml_text(ml_copy)
held = {rid: note for rid, note in k67.HELD.items()}
ml_note24 = k24.ml_note(N)
snapshot = {p: p.read_bytes() for p in RECS.glob('*.json')}
try:
    if not CHECK:
        k24.records(True, N, notes=False)
        k67.records(True, N, notes=False)
    clauses = {ML: [clause(ml_note24), ML_LAND]}
    for rid, note in held.items():
        clauses.setdefault(rid, []).append(clause(note))
    writes = {}
    r = read(CRC)
    law = item1(r)
    crc_scope(r)
    clauses[CRC] += [tuple(s.format(law=law) for s in I1_CLAUSE), CRC_LAND]
    writes[CRC] = r
    r = read(GDG)
    item5(r)
    clauses.setdefault(GDG, []).append(I5_CLAUSE)
    writes[GDG] = r
    r = read(LCS)
    lcs_scope(r)
    clauses.setdefault(LCS, []).append(LCS_CLAUSE)
    writes[LCS] = r
    if CHECK:
        writes[ML] = ml_copy
    else:
        r = read(ML)
        ml_scope(r)
        ml_text(r)
        writes[ML] = r
    for rid in clauses:
        r = writes.get(rid) or read(rid)
        note = history(sorted(clauses[rid], key=lambda c: order(c[0])))
        if CHECK:
            print(f'{rid}\n  en: {note["en"]}\n  zh: {note["zh"]}')
        r['history'].append(note)
        writes[rid] = r
    assert set(writes) == EXPECTED, ('records written', sorted(set(writes) ^ EXPECTED))
    if CHECK:
        print(f'checked: {len(writes)} records; nothing written')
    else:
        for rid, r in writes.items():
            path = RECS / f'{rid}.json'
            raw = path.read_text(encoding='utf-8')
            path.write_text(json.dumps(r, ensure_ascii=False, indent=2) + ('\n' if raw.endswith('\n') else ''),
                            encoding='utf-8')
        print('records:', ', '.join(sorted(writes)), '; dated', DAY_EN)
except BaseException:
    for path, raw in snapshot.items():
        if path.read_bytes() != raw:
            path.write_bytes(raw)
    print('failed: every record restored as it was')
    raise
