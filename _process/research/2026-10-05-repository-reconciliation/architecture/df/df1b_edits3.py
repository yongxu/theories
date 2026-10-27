#!/usr/bin/env python3
"""DF1b, third round: the findings of the recheck of the second round and of the cold read of the whole change
(reports/recheck-df1b.txt), applied after df1b_edits2.py. Run once from the checkout root:
python3 -B <kit>/df1b_edits3.py.

Every replacement is asserted to occur exactly once. A record that already has a DF1b note has a sentence added to
it (or the note rewritten, where the second round's note itself was wrong); any other record gets one DF1b note."""
import json
import re
from pathlib import Path

ROOT = Path.cwd()
BEC = ROOT / 'theories/becoming'
CH = BEC / 'chapters'
REC = BEC / 'results/records'
EP = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/physics'
DEFECTS = ROOT / '_process/research/2026-10-05-repository-reconciliation/architecture/DEFECTS-FOUND.md'
NOTE = '26 October 2026, board item DF1b (study section DF_N): '
NOTE_ZH = '2026年10月26日，工作板条目 DF1b（研究第 DF_N 节）：'


def sub(path, old, new, count=1):
    p = path if isinstance(path, Path) else ROOT / path
    t = p.read_text(encoding='utf-8')
    assert t.count(old) == count, (str(p), old[:80], t.count(old))
    p.write_text(t.replace(old, new), encoding='utf-8')


# The second law read in available work gives the spine's first law (EntropyProduction.gainless_of_secondLaw, which
# also takes the exergy balance and a positive unit); no converse is proved, so no text says it is that law.
sub(CH / '02-MAP.md',
    "the second law in available work is the spine's first law, destroyed exergy its record.",
    "the second law in available work gives the spine's first law, and destroyed exergy is its record.")
sub(CH / '02-MAP.md',
    "the spine's name, given in available work by thermodynamics' second law "
    "([§4](#r-least-loss-from-entropy-production)), while",
    "the spine's name; under the exergy balance, thermodynamics' second law read in available work gives it "
    "([§4](#r-least-loss-from-entropy-production)), while")
sub('GLOSSARY.md',
    "read in available work, thermodynamics' second law gives it (`EntropyProduction.gainless_of_secondLaw`).",
    "under the exergy balance, thermodynamics' second law read in available work gives it "
    "(`EntropyProduction.gainless_of_secondLaw`).")
sub(EP / 'EntropyProduction.lean',
    "* **The second law is the spine's first law.**",
    "* **The second law gives the spine's first law.**")
sub(EP / 'EntropyProduction.lean',
    "/-- The second law is the spine's first law at the unit: nothing comes from nothing. -/",
    "/-- The second law gives the spine's first law at the unit: nothing comes from nothing. -/")
# Thermodynamics' first law named in full; the second round's guard missed it across a line break.
sub(EP / 'EntropyProduction.lean',
    "the formations taking part take from it and give to it. Read physically, it is the first\n"
    "law with locality: a quantity carried only by the exchanges taking part balances exactly\n",
    "the formations taking part take from it and give to it. Read physically, it is thermodynamics'\n"
    "first law with locality: a quantity carried only by the exchanges taking part balances exactly\n")

# MQ6: A1, A2, C1 and L were read at constant regimes (the sucrose bifurcation and the constant group at DF 500),
# the four T1 and two T2 verdicts on the runs driven past the fold (§314).
sub(CH / '02-MAP.md',
    "past the fold (§314, 3 of 10 frozen verdicts passed): the frozen fate reading counted noise at the instrument's "
    "floor as survival below the need (read by the floor, as in §266, the fates separate 97–100%, post hoc), the need "
    "predicted by the odd-level fit was 0.58 of the need read from fates at 0.2%, the held-out level nearest the fold, "
    "and of the six",
    "yeast at constant regimes and driven past its fold (§314, 3 of 10 frozen verdicts passed): the frozen fate "
    "reading counted noise at the instrument's floor as survival below the need (read by the floor, as in §266, the "
    "fates separate 97–100%, post hoc); the need predicted by the fit on the odd sucrose levels was 0.58 of the need "
    "read from fates at 0.2%, the held-out level nearest the fold; and of the six")
sub(CH / '08-METHOD.md',
    "in fish stocks under held catches (MQ3), past the fold (MQ6: 3 of 10 frozen verdicts passed;",
    "in fish stocks under held catches (MQ3), in yeast at constant regimes and past the fold (MQ6: 3 of 10 frozen "
    "verdicts passed;")
sub(CH / '08-METHOD.md',
    "in MQ6's yeast residuals at one constant dilution",
    "in MQ6's yeast, residuals at one constant dilution")

# The loops formed by T + 1 are exactly those of T and those closed at T (onLoop_succ_iff); forms_by_closing is one
# direction.
sub(CH / '02-MAP.md',
    "that closes a chain (`forms_by_closing`).",
    "that closes a chain (`onLoop_succ_iff`; so a loop that forms passes through a coupling acting at that step, "
    "`forms_by_closing`).")

# Fixed and still-mixed histories are disjoint; the bound is on the first kind (Drift.fixation, Replacement.fixation).
sub(CH / '04-LIFE.md',
    "over cohorts of drawing the weight of the histories still mixed is bounded by a share falling geometrically, "
    "within which the histories fixing each kind take a share the laws give.",
    "over cohorts of drawing, the weight of the histories still mixed is bounded by a share falling geometrically, "
    "and the share of the histories fixing the first kind lies within that bound of a share the laws give.")

sub('experiments/margin-measured/README.md', '-mq4) [280](', '-mq4), [280](')
sub('experiments/margin-measured/README.md', '-mq5) , [314](', '-mq5), [314](')

# DEFECTS-FOUND's DF1b section says what the change did.
sub(DEFECTS,
    "- 08 §9's T1 standing, and 02's T1 evidence, name only MQ6's timing",
    "- 08 §9's T1 evidence, and 02's, name only MQ6's timing")
sub(DEFECTS,
    "and EntropyProduction.lean's header, whose expected floor's hypothesis is renamed from `landauer` to `floor` "
    "(the periphery checker reran) and whose checker's scope no longer lists Landauer's bound.*",
    "and EntropyProduction.lean: its header, the hypothesis of `ExpectedDissipatesOn.of_exergy`, renamed from "
    "`landauer` to `floor` (the periphery checker reran), and its checker's scope, which no longer lists Landauer's "
    "bound.*")
sub(DEFECTS,
    "the spine's (`Flow.Gainless`, thermodynamics' second law read in available work)",
    "the spine's (`Flow.Gainless`, which thermodynamics' second law read in available work gives)")
sub(DEFECTS,
    "three records' Chinese now write the spine's 第一律, not 第一定律; and a first-numbered law is no longer called a "
    "first law in 01, 05 and three records.*",
    "three records' Chinese now write the spine's 第一律, not 第一定律, and one of them names the rest laws' premises "
    "as the Lean has them, balance and dissipation; 02 §4, the least-loss record and EntropyProduction.lean say the "
    "second law gives the spine's first law, not that it is that law; and a first-numbered law is no longer called a "
    "first law in 01, 05 and four records.*")


def path_of(d, field):
    obj, parts = d, re.findall(r'[^.\[\]]+', field)
    for k in parts[:-1]:
        obj = obj[int(k)] if k.isdigit() else obj[k]
    k = parts[-1]
    return obj, (int(k) if k.isdigit() else k)


def record(name, edits, en, zh, mode='add'):
    """edits: (field, lang, old, new); old None sets the whole string. mode: 'add' appends to the record's DF1b note
    (or gives it one), 'rewrite' replaces that note's text."""
    p = REC / f'{name}.json'
    d = json.loads(p.read_text(encoding='utf-8'))
    for field, lang, old, new in edits:
        obj, key = path_of(d, field)
        if old is None:
            obj[key][lang] = new
        else:
            s = obj[key][lang]
            assert s.count(old) == 1, (name, field, lang, old[:60], s.count(old))
            obj[key][lang] = s.replace(old, new)
    notes = [h for h in d['history'] if h.get('en', '').startswith(NOTE)]
    assert len(notes) <= 1, name
    if not notes:
        assert mode == 'add', name
        d['history'].append({'en': NOTE + en, 'zh': NOTE_ZH + zh})
    elif mode == 'rewrite':
        notes[0]['en'], notes[0]['zh'] = NOTE + en, NOTE_ZH + zh
    else:
        notes[0]['en'] = notes[0]['en'].rstrip() + ' ' + en
        notes[0]['zh'] = notes[0]['zh'].rstrip() + zh
    p.write_text(json.dumps(d, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')


record('least-loss-from-entropy-production', [
    ('statement', 'en', "the second law is the spine's first law", "the second law gives the spine's first law"),
    ('statement', 'zh', '第二定律是脊柱的第一律', '第二定律给出脊柱的第一律'),
    ('laws[1]', 'en', "is the spine's first law", "gives the spine's first law"),
    ('correspondence', 'en', "is the spine's first law", "gives the spine's first law"),
], "The second law read in available work gives the spine's first law (statement, law 2, correspondence): no "
   "converse is proved.",
   '以可用功读出，第二定律给出脊柱的第一律（陈述、第 2 条规律、对应）：未证其逆。')

record('recurrence-without-premise', [
    ('correspondence', 'en', 'take the first law and dissipation as premises', 'take balance and dissipation as premises'),
    ('correspondence', 'en', 'Under the first law an enclosed family', 'Under balance and the first law an enclosed family'),
    ('correspondence', 'zh', '以第一律与耗散为前提', '以平衡与耗散为前提'),
    ('correspondence', 'zh', '第一律之下被围住的家族', '平衡与第一律之下被围住的家族'),
    ('related[1].detail', 'en', 'under the first law and dissipation', 'under balance and dissipation'),
    ('related[1].detail', 'zh', '在第一律与耗散之下', '在平衡与耗散之下'),
], "The rest laws' premises are named as the Lean has them, balance and dissipation (World.comes_to_rest_unrefuted), "
   "and an enclosed family's finitely many configurations need balance beside the spine's first law; the Chinese "
   "writes that law (Flow.Gainless) 第一律, not 第一定律, which names thermodynamics' first law.",
   '停息规律的前提按 Lean 写作平衡与耗散（World.comes_to_rest_unrefuted），被围住的家族构型有限多个，除脊柱的第一律外还需要平衡；'
   '中文把该律（Flow.Gainless）写作第一律，而不写作第一定律，后者指热力学第一定律。', mode='rewrite')

record('fixation-with-selection', [
    ('statement', 'en', 'Replacing one at a time, up with weight a and down with b,',
     'Replacing one of M + 1 at a time, up with weight a and down with b,'),
    ('statement', 'en', 'so for positive a it tends to the ratio:', 'so for positive a tends to it:'),
    ('statement', 'zh', '一次替换一个、上升权重 a', 'M + 1 个成员中一次替换一个、上升权重 a'),
    ('related[0].detail', 'en', None,
     'Drift alone: the share fixing the first kind at most its starting share and within a geometrically falling bound '
     'of it.'),
    ('related[0].detail', 'zh', None, '单凭漂变：固定第一类的份额至多为其起始份额，与之之差有按几何下降之界。'),
    ('dependencies[0].detail', 'en', None,
     "The neutral case: with a = b the potential's ratio is the starting share, to which sampled generations' bounds "
     "also close."),
    ('dependencies[0].detail', 'zh', None, '中性情形：a = b 时势之比即起始份额，多代抽样的界亦向它收紧。'),
], "The statement names the population of M + 1; the related note on drift and the neutral case give drift's bounds, "
   "not a limit.",
   '陈述写明 M + 1 个成员的种群；关于漂变的相关说明与中性情形给出漂变的界，而非极限。')

record('fixation-by-drift', [
    ('statement', 'en', 'and those fixing a kind a share', 'and those fixing the first kind a share'),
    ('statement', 'zh', '固定某类的历史所占份额', '固定第一类的历史所占份额'),
    ('related[2].detail', 'en', None,
     "With selection in the draw, replacement one at a time: the fixing share within a bound of a potential's ratio "
     "that falls geometrically where a is positive."),
    ('related[2].detail', 'zh', None, '抽取中有选择时，一次替换一个：固定份额与势之比之差有界，a 为正时按几何下降。'),
], 'The statement names the first kind, as Drift.fixation does, and the bound with selection falls geometrically '
   'where a is positive.',
   '陈述写明第一类，与 Drift.fixation 一致；有选择时的界在 a 为正时按几何下降。')

record('derived-history-law-exactness', [
    ('claim', 'en', "in the core an instance of the record's first law, not one declaration",
     "in the core an instance of the first of the record's laws, not one declaration"),
], "The first of the record's laws is not called a first law, the spine's name for Flow.Gainless.",
   '英文版中本记录的第一条规律不称为 first law，那是脊柱对 Flow.Gainless 的称呼。', mode='rewrite')

record('continuous-time-as-tower', [
    ('correspondence', 'en', 'This result gives the tower and its first law:',
     'This result gives the tower and the first of its laws:'),
], "The first of the tower's laws is not called its first law, the spine's name for Flow.Gainless.",
   '英文版中塔的第一条规律不称为 first law，那是脊柱对 Flow.Gainless 的称呼。')

record('balance-from-the-first-law', [
    ('related[2].detail', 'en', 'There least loss is the first law plus a record',
     "There least loss is the spine's first law plus a record"),
], "Where a related note means the spine's first law, it says so.",
   '一条相关说明的英文版中指脊柱之第一律处写明为脊柱的。')

record('how-loops-form', [
    ('correspondence', 'en', "Readings (the AI's, agreed by Ren on 16 October 2026):",
     "Readings (the AI's, agreed by Ren on 16 October 2026; the third revised on 26 October 2026, board item DF1b, "
     "since Closing.Onset.unforeseen is a witness):"),
    ('correspondence', 'zh', '读法（AI 的，Ren 2026-10-16 同意）：',
     '读法（AI 的，Ren 2026-10-16 同意；第三项于 2026-10-26 按工作板条目 DF1b 修订，因 Closing.Onset.unforeseen 是见证）：'),
], "The readings' label says the third was revised.",
   '读法的标注写明第三项已修订。')

# The second round's note on Hordijk and Steel: two works, not three, in the Chinese.
p = REC / 'what-keeping-widening-needs.json'
d = json.loads(p.read_text(encoding='utf-8'))
notes = [h for h in d['history'] if h.get('en', '').startswith(NOTE)]
assert len(notes) == 1 and notes[0]['zh'].count('Steel 2000 与 Hordijk 与 Steel 2004') == 1
notes[0]['zh'] = notes[0]['zh'].replace('Steel 2000 与 Hordijk 与 Steel 2004', 'Steel 2000 及 Hordijk 与 Steel 2004')
p.write_text(json.dumps(d, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')

# Guards: no bare first law in EntropyProduction's thermodynamic sense, and no identity of the two laws in the account.
lean = (EP / 'EntropyProduction.lean').read_text(encoding='utf-8')
for m in re.finditer(r"(?<!thermodynamics' )(?<!spine's )(?<!thermodynamics'\n)first\s+law", lean):
    print('CHECK EntropyProduction.lean:', lean.count('\n', 0, m.start()) + 1, repr(lean[m.start() - 60:m.end() + 30]))
for f in [CH / '02-MAP.md', ROOT / 'GLOSSARY.md', REC / 'least-loss-from-entropy-production.json', EP / 'EntropyProduction.lean']:
    t = f.read_text(encoding='utf-8')
    assert "is the spine's first law" not in t and '是脊柱的第一律' not in t, f
for f in [REC / 'fixation-with-selection.json']:
    s = json.loads(f.read_text(encoding='utf-8'))['statement']
    assert len(s['en']) <= 300 and len(s['zh']) <= 150, (len(s['en']), len(s['zh']))
print('df1b_edits3: applied')
