#!/usr/bin/env python3
"""DF1b: the ten weak points UE8's drafting found (development/ue8-sciences-dossier/README.md, "Found in the account
while drafting"), each checked against main at 04c7f93ae. Run once from the checkout root: python3 -B <kit>/df1b_edits.py.

Every replacement is asserted to occur exactly once. Records get one history note each, with DF_N for the study
section filled at landing."""
import json
import re
from pathlib import Path

ROOT = Path.cwd()
CH = ROOT / 'theories/becoming/chapters'
REC = ROOT / 'theories/becoming/results/records'


def sub(path, old, new, count=1):
    p = ROOT / path if not isinstance(path, Path) else path
    t = p.read_text(encoding='utf-8')
    assert t.count(old) == count, (str(p), old[:80], t.count(old))
    p.write_text(t.replace(old, new), encoding='utf-8')


# 1, 2. 08 §9's T1 and T2 rows; 02's T1 evidence.
sub(CH / '08-METHOD.md',
    'in fish stocks under held catches (MQ3), on the time to break past the fold (MQ6); no field test of a need measured in advance |',
    'in fish stocks under held catches (MQ3), past the fold (MQ6: 3 of 10 frozen verdicts passed; the fate reading at the '
    "instrument's floor, the predicted need near the fold and five of six verdicts on the time to break failed); no field "
    'test of a need measured in advance |')
sub(CH / '08-METHOD.md',
    '| conjectured, on three frozen fish-stock tests and one in yeast past its fold; untested on grassland and forests |',
    '| conjectured, on three frozen fish-stock tests; untested outside fisheries |')
sub(CH / '08-METHOD.md',
    'in yeast past its fold (MQ6) residuals carry nothing day to day |',
    'in yeast past its fold (MQ6) residuals at constant dilution carry nothing day to day, outside the deteriorating '
    'environments that could refute T2 |')
sub(CH / '02-MAP.md',
    'the time to break past the fold (§314)',
    'past the fold (§314, 3 of 10 frozen verdicts passed): the frozen fate reading counted noise at the instrument\'s '
    'floor as survival below the need (read by the floor, as in §253, the fates separate 97–100%, post hoc), the need '
    'predicted from the fitted curve was 0.58 of the need read from fates at the sucrose level nearest the fold, and '
    'five of six verdicts on the time to break failed')

# 3. Food-generated autocatalytic sets: Hordijk and Steel 2004 (J. Theor. Biol. 227:451-461); 2012 extends them.
sub(CH / '08-METHOD.md', 'autocatalytic sets are food-generated (Hordijk and Steel 2012)',
    'autocatalytic sets are food-generated (Hordijk and Steel 2004)')

# 4. 02 §7: Closing.Onset is a namespace; the witness is Closing.Onset.unforeseen.
sub(CH / '02-MAP.md',
    'so before a loop forms growth is polynomial and the amounts do not show whether one will (`Closing.Onset`).',
    'so before a loop forms growth is polynomial, and the amounts need not show whether one will: a loop forming at '
    '`T` and one forming later carry the same amounts up to `T` (`Closing.Onset.unforeseen`, a witness).')

# 6. 04: two works.
sub(CH / '04-LIFE.md', 'the reproductive-excess limit of Nei and Felsenstein (1971)',
    'the reproductive-excess limit of Nei (1971) and Felsenstein (1971)')

# 7. 02 §4: Landauer's bound is on heat exported, not on exergy destroyed.
sub(CH / '02-MAP.md',
    'irreversibility of every taking with whole units gives it, and a floor at least the unit, as Landauer\'s bound, at '
    'every finer unit (`EntropyProduction.dissipative_of_floor`).',
    'irreversibility of every taking with whole units gives it, and so does a floor of destroyed exergy at least the '
    'unit, at every finer unit (`EntropyProduction.dissipative_of_floor`). Landauer\'s bound is no such floor by itself: '
    'it bounds the heat an erasure exports, heat exported is not exergy destroyed, and a logically irreversible step can '
    'be carried out thermodynamically reversibly (Sagawa 2014).')

# 8. "First law": the spine's name (Flow.Gainless) apart from thermodynamics' first law.
sub(CH / '02-MAP.md',
    '*the first law* (`Flow.Gainless`: a closed family without repetition gets back at most what is taken from it)',
    '*the first law* (`Flow.Gainless`: a closed family without repetition gets back at most what is taken from it; the '
    'spine\'s name, which read in available work is thermodynamics\' second law, [§4](#r-least-loss-from-entropy-production), '
    'while [01\'s balance theorem](01-ROOT.md#r-balance-from-the-first-law) reads thermodynamics\' first law)')
sub(CH / '01-ROOT.md', 'with the first law and the entropy balance at each store and exchange',
    "with thermodynamics' first law and the entropy balance at each store and exchange")
sub(CH / '08-METHOD.md', 'balance as the first law with locality is a correspondence',
    "balance as thermodynamics' first law with locality is a correspondence")
sub('theories/becoming/THE-THEORY-OF-BECOMING.md', '([balance from the first law](chapters/01-ROOT.md#r-balance-from-the-first-law))',
    "([balance from thermodynamics' first law](chapters/01-ROOT.md#r-balance-from-the-first-law))")
sub('theories/becoming/THE-THEORY-OF-BECOMING.zh.md', '（[第一定律给出的平衡](chapters/01-ROOT.md#r-balance-from-the-first-law)）',
    '（[热力学第一定律给出的平衡](chapters/01-ROOT.md#r-balance-from-the-first-law)）')
sub('GLOSSARY.md',
    '| meta-attractor (元吸引子) |',
    '| first law | the spine\'s name for `Flow.Gainless`: a closed family without repetition gets back at most what is '
    'taken from it; read in available work it is thermodynamics\' second law. Thermodynamics\' first law, the '
    'conservation of energy, is always named in full | [02](theories/becoming/chapters/02-MAP.md#how-to-read) |\n'
    '| meta-attractor (元吸引子) |')

# 9. The tests' accounts link T1, T2 and T6 to their home chapters, not to a history copy of the overview.
sub('experiments/margin-measured/README.md',
    '[T1](../../theories/becoming/history/THE-THEORY-OF-BECOMING.md#t1-persistence-certifies-the-joint-draw)',
    '[T1](../../theories/becoming/chapters/02-MAP.md#t1)')
sub('experiments/margin-measured/README.md',
    '[T2](../../theories/becoming/history/THE-THEORY-OF-BECOMING.md#t2-the-state-of-a-renewable-condition-under-a-draw)',
    '[T2](../../theories/becoming/chapters/02-MAP.md#t2)')
sub('experiments/break-warnings/README.md',
    '([chapter](../../theories/becoming/history/THE-THEORY-OF-BECOMING.md#t6-a-break-is-seen-coming-only-through-what-couples-into-what-breaks))',
    '([chapter](../../theories/becoming/chapters/03-KNOWING.md#break-seen-coming))')

# 10. Gao, Schulman and Hilton: ICML 2023 (PMLR 202), arXiv October 2022; the account cites the published year.
sub('theories/becoming/review/ALIGNMENT.md', '"Gao, Schulman and Hilton 2022; Wen et al. 2024;',
    '"Gao, Schulman and Hilton 2023; Wen et al. 2024;')


# Records.
def path_of(d, path):
    parts = re.findall(r'[^.\[\]]+|\[\d+\]', path)
    for part in parts[:-1]:
        d = d[int(part[1:-1])] if part.startswith('[') else d[part]
    last = parts[-1]
    return d, (int(last[1:-1]) if last.startswith('[') else last)


NOTE = '26 October 2026, board item DF1b (study section DF_N): '
NOTE_ZH = '2026年10月26日，工作板条目 DF1b（研究第 DF_N 节）：'


def record(name, edits, en, zh):
    p = REC / f'{name}.json'
    d = json.loads(p.read_text(encoding='utf-8'))
    for field, lang, old, new in edits:
        obj, key = path_of(d, field)
        s = obj[key][lang]
        assert s.count(old) == 1, (name, field, lang, old[:60])
        obj[key][lang] = s.replace(old, new)
    d['history'].append({'en': NOTE + en, 'zh': NOTE_ZH + zh})
    p.write_text(json.dumps(d, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')


TH = "thermodynamics' first law"
record('balance-from-the-first-law', [
    ('title', 'en', 'Balance from the first law', "Balance from thermodynamics' first law"),
    ('title', 'zh', '第一定律给出的平衡', '热力学第一定律给出的平衡'),
    ('statement', 'en', 'Read in available work, the first law and the entropy balance give balance where no store '
     "generates entropy, and the exchanges' exergy balance: balance and least loss from one reading.",
     f"Read in available work, {TH} and the entropy balance give balance where no store generates entropy, and the "
     "exchanges' exergy balance: both from one reading."),
    ('statement', 'zh', '读作可用功，第一定律与熵平衡', '读作可用功，热力学第一定律与熵平衡'),
    ('laws[3]', 'en', 'With the first law and the entropy balance at each store', f'With {TH} and the entropy balance at each store'),
    ('laws[3]', 'zh', '每个储存满足第一定律与熵平衡时', '每个储存满足热力学第一定律与熵平衡时'),
    ('laws[4]', 'en', 'With the first law and the entropy balance at each exchange', f'With {TH} and the entropy balance at each exchange'),
    ('laws[4]', 'zh', '每个交换满足第一定律与熵平衡', '每个交换满足热力学第一定律与熵平衡'),
    ('dependencies[0].detail', 'en', 'premise from the first law and the entropy balance', f'premise from {TH} and the entropy balance'),
    ('dependencies[0].detail', 'zh', '由每个交换处的第一定律与熵平衡', '由每个交换处的热力学第一定律与熵平衡'),
    ('related[2].detail', 'en', 'here the physical first law with locality gives balance', f'here {TH} with locality gives balance'),
    ('related[2].detail', 'zh', '这里物理的第一定律加局部性给出平衡', '这里热力学第一定律加局部性给出平衡'),
], f"'The first law' here is {TH}, named in full apart from the spine's first law (Flow.Gainless), which is "
   "thermodynamics' second law read in available work; title, statement, laws 4 and 5, a dependency and a related note.",
   '这里的“第一定律”是热力学第一定律，与脊柱的第一律（Flow.Gainless，即以可用功读出的热力学第二定律）分开，写出全名；标题、陈述、第 4、5 条规律、一项依赖与一条相关说明。')

record('least-loss-from-entropy-production', [
    ('statement', 'en', 'or a floor of destruction at least the unit (Landauer), gives it',
     'or a floor of destroyed exergy at least the unit, gives it'),
    ('statement', 'zh', '或被毁㶲有不小于单位的下限（Landauer），就给出耗散', '或被毁㶲有不小于单位的下限，就给出耗散'),
    ('laws[4]', 'en', ': a floor in energy, as Landauer\'s kT ln 2 per merged bit, survives refinement.',
     ': a floor in energy survives refinement.'),
    ('correspondence', 'en', 'erasing a bit at temperature T destroys at least kT ln 2 in expectation, a floor for '
     'DestroysAtLeast wherever each taking exchange merges what it held.',
     'erasing a bit at temperature T exports at least kT ln 2 of heat in expectation, which is not exergy destroyed: '
     'erasure can be thermodynamically reversible (Sagawa 2014), so it is no DestroysAtLeast floor alone.'),
    ('related[2].detail', 'en', "Landauer's floor, here a physical premise, has its count as a core law there.",
     "The floor of destroyed exergy, here a physical premise, is not Landauer's bound alone; Landauer's count is a core law there."),
    ('related[2].detail', 'zh', '这里作为物理前提的 Landauer 下限，其计数在那里是核心规律。',
     '这里作为物理前提的被毁㶲下限，单靠 Landauer 下限给不出；Landauer 的计数在那里是核心规律。'),
    ('related[3].detail', 'en', 'derived there from the first law and the entropy balance', f'derived there from {TH} and the entropy balance'),
    ('related[3].detail', 'zh', '在那里由每个交换处的第一定律与熵平衡推出', '在那里由每个交换处的热力学第一定律与熵平衡推出'),
    ('next_delta', 'en', 'the exchange-level Landauer bound from the count now in the core (record '
     'merge-of-a-part-kept-by-the-rest) with a reading of count as energy.',
     'Landauer\'s bound from the core\'s count (merge-of-a-part-kept-by-the-rest) read as energy would bound heat '
     'exported, not exergy destroyed, so no floor without irreversibility.'),
    ('next_delta', 'zh', '由现已在核心中的计数（记录 merge-of-a-part-kept-by-the-rest）加上把计数读作能量，得出交换层面的 Landauer 下限。',
     '由核心中的计数（merge-of-a-part-kept-by-the-rest）读作能量所得的 Landauer 下限，界定的是导出之热而非被毁之㶲，无不可逆则不成下限。'),
], "Landauer's bound is not a floor of destroyed exergy by itself: it bounds the heat an erasure exports, and erasure can "
   "be thermodynamically reversible (Sagawa 2014; UE6's first round); statement, law 5, correspondence, a related note "
   f"and the next step say so. {TH} named in full in a related note.",
   'Landauer 下限本身不是被毁㶲的下限：它界定擦除所导出的热，而擦除可以在热力学上可逆（Sagawa 2014；UE6 第一轮）；陈述、第 5 条规律、对应、一条相关说明与下一步据此改写。一条相关说明中的热力学第一定律写出全名。')

record('balance-from-conservation-along-a-relation', [
    ('correspondence', 'en', "of which FL1's first law with locality is the energy case.",
     f'of which {TH} with locality (FL1) is the energy case.'),
], f"{TH} named in full in the correspondence, apart from the spine's first law.",
   '对应中的热力学第一定律写出全名，与脊柱的第一律分开。')

record('merge-of-a-part-kept-by-the-rest', [
    ('related[1].detail', 'en', "There Landauer's floor is a physical premise (DestroysAtLeast); here its count is a core law.",
     "There a floor of destroyed exergy is a physical premise (DestroysAtLeast), not Landauer's bound alone; here "
     "Landauer's count is a core law."),
    ('related[1].detail', 'zh', '那里 Landauer 的下限是物理前提（DestroysAtLeast）；这里其计数是核心规律。',
     '那里被毁㶲的下限是物理前提（DestroysAtLeast），单靠 Landauer 下限给不出；这里 Landauer 的计数是核心规律。'),
], "The related note no longer calls DestroysAtLeast Landauer's floor: Landauer's bound is on heat exported, not on "
   'exergy destroyed (Sagawa 2014).',
   '相关说明不再把 DestroysAtLeast 称为 Landauer 下限：Landauer 下限关乎导出之热，而非被毁之㶲（Sagawa 2014）。')

record('how-loops-form', [
    ('statement', 'en', 'growth before it forms is polynomial and does not show it will',
     'growth before it forms is polynomial and need not show it will'),
    ('statement', 'zh', '形成之前增长至多是多项式，且不显示它是否将形成', '形成之前增长至多是多项式，且未必显示它是否将形成'),
    ('laws[3]', 'en', 'The amounts before a loop forms do not show whether it will:', 'The amounts before a loop forms need not show whether it will:'),
    ('laws[3]', 'zh', '形成之前的量不显示它是否将形成', '形成之前的量未必显示它是否将形成'),
], 'That the amounts before a loop forms do not show it is a witness (Closing.Onset.unforeseen), so statement and law 4 '
   'say they need not show it.',
   '形成之前的量不显示回路将形成，这是一个见证（Closing.Onset.unforeseen），故陈述与第 4 条规律改为“未必显示”。')

record('fixation-by-drift', [
    ('statement', 'en', 'its still-varied histories vanish geometrically, and each kind is fixed with exactly its starting '
     'share in the limit.',
     'after k generations its still-varied histories weigh a share at most ((N^N − 2)/N^N)^k, and those fixing a kind '
     'its starting share to within that, so fixation tends to the starting share.'),
    ('statement', 'zh', '仍有差异的历史按几何速率消失，各类在极限中恰以其起始份额被固定。',
     'k 代之后仍有差异的历史所占份额至多为 ((N^N − 2)/N^N)^k，固定某类的历史在此之内等于其起始份额，故固定趋于起始份额。'),
], 'The Lean gives finite two-sided bounds after k generations (Drift.fixation, Drift.varied_vanishes); the limit is '
   'read from them, as chapter 04 says, and the statement now gives the bounds.',
   'Lean 给出 k 代之后有限的双侧界（Drift.fixation、Drift.varied_vanishes）；极限由之读出，如第 04 章所说；陈述现给出这些界。')

record('pace-of-selection-within-what-flows-in', [
    ('laws[13]', 'en', 'the reproductive-excess limit of Nei and Felsenstein (1971)', 'the reproductive-excess limit of Nei (1971) and Felsenstein (1971)'),
    ('laws[13]', 'zh', 'Nei 与 Felsenstein（1971）', 'Nei（1971）与 Felsenstein（1971）'),
], 'Nei (1971) and Felsenstein (1971) cited as the two works they are, as the correspondence does.',
   'Nei（1971）与 Felsenstein（1971）作为两篇著作引用，与对应一致。')

record('what-keeping-widening-needs', [
    ('correspondence', 'en', 'food-generated (Hordijk and Steel 2012;', 'food-generated (Hordijk and Steel 2004;'),
    ('correspondence', 'zh', '由食物生成（Hordijk 与 Steel 2012；', '由食物生成（Hordijk 与 Steel 2004；'),
], 'Food-generated autocatalytic sets cited to their formalization, Hordijk and Steel 2004 (Journal of Theoretical '
   'Biology 227:451-461); their 2012 papers extend it.',
   '由食物生成的自催化集引其形式化，Hordijk 与 Steel 2004（Journal of Theoretical Biology 227:451-461）；其 2012 年论文为扩展。')

p = REC / 'coupling-closures-of-training-pipelines.json'
d = json.loads(p.read_text(encoding='utf-8'))
hits = []
for k, v in d.items():
    if k != 'history' and isinstance(v, dict) and all(isinstance(v.get(x), str) for x in ('en', 'zh')):
        for lang, old, new in (('en', 'Gao, Schulman and Hilton 2022', 'Gao, Schulman and Hilton 2023'),
                               ('zh', 'Gao、Schulman 与 Hilton 2022', 'Gao、Schulman 与 Hilton 2023')):
            if old in v[lang]:
                v[lang] = v[lang].replace(old, new)
                hits.append((k, lang))
assert len(hits) == 2, hits
d['history'].append({'en': NOTE + 'Gao, Schulman and Hilton cited by the published year, 2023 (ICML, PMLR 202; '
                     'arXiv October 2022), as elsewhere in the account.',
                     'zh': NOTE_ZH + 'Gao、Schulman 与 Hilton 按发表年份 2023 引用（ICML，PMLR 202；arXiv 2022 年 10 月），与本说明他处一致。'})
p.write_text(json.dumps(d, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
print('DF1b edits applied')
