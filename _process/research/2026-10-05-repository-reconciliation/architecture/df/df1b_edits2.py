#!/usr/bin/env python3
"""DF1b, second round: the findings of DF1b's review (reports/review-df1b.json) that were taken, applied after
df1b_edits.py. Run once from the checkout root: python3 -B <kit>/df1b_edits2.py.

Every replacement is asserted to occur exactly once. A record that df1b_edits.py already noted has that DF1b note
rewritten to cover both rounds; any other record gets one DF1b note."""
import json
import re
from pathlib import Path

ROOT = Path.cwd()
BEC = ROOT / 'theories/becoming'
CH = BEC / 'chapters'
REC = BEC / 'results/records'
EP = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/physics'


def sub(path, old, new, count=1):
    p = path if isinstance(path, Path) else ROOT / path
    t = p.read_text(encoding='utf-8')
    assert t.count(old) == count, (str(p), old[:80], t.count(old))
    p.write_text(t.replace(old, new), encoding='utf-8')


# MQ6 (study §314): of ten frozen verdicts three passed (T1a-SUC, C1, L). Only T2-DF and T2-SUC are on the time to
# break, and both failed; the four T1 verdicts are level forecasts. MQ2 (§266) read fates by the floor; A2's
# held-out need was the odd-level fit's, 0.58 of the fates' at 0.2%, the held-out level nearest the fold.
sub(CH / '02-MAP.md',
    "(read by the floor, as in §253, the fates separate 97–100%, post hoc), the need predicted from the fitted curve "
    "was 0.58 of the need read from fates at the sucrose level nearest the fold, and five of six verdicts on the time "
    "to break failed",
    "(read by the floor, as in §266, the fates separate 97–100%, post hoc), the need predicted by the odd-level fit "
    "was 0.58 of the need read from fates at 0.2%, the held-out level nearest the fold, and of the six forecast and "
    "timing verdicts five failed: neither break was timed, and the level forecast away from the break passed only "
    "under falling sucrose")
sub(CH / '08-METHOD.md',
    "the predicted need near the fold and five of six verdicts on the time to break failed)",
    "the predicted need near the fold, the timing of both breaks and three of four level forecasts failed)")

# MQ6's constant group (DF 500) was never past its fold, and lies outside T2's refuting settings; its deteriorating
# runs, inside them, measured none of T2's three forbidden items (margin-measured README, open items).
sub(CH / '02-MAP.md',
    "In yeast past its fold (§314), residuals at constant dilution carry nothing day to day (lag-1 −0.14, passed); "
    "under a rising draw giving falls below the curve about three days before the break (post hoc).",
    "In MQ6's yeast (§314), residuals at one constant dilution, never past the fold, carry nothing day to day (lag-1 "
    "−0.14, passed), outside the deteriorating environments that could refute T2; the populations driven past their "
    "fold were not measured on T2's three forbidden items, and under a rising draw their giving falls below the curve "
    "about three days before the break (post hoc).")
sub(CH / '08-METHOD.md',
    "in yeast past its fold (MQ6) residuals at constant dilution carry nothing day to day, outside the deteriorating "
    "environments that could refute T2 |",
    "in MQ6's yeast residuals at one constant dilution, never past the fold, carry nothing day to day, outside the "
    "settings that could refute T2, and the runs past the fold measured none of its forbidden items |")
sub(BEC / 'THE-THEORY-OF-BECOMING.md',
    "| conjectured; of three frozen fish-stock tests one passed, as did one in yeast past its fold; untested on "
    "grassland and forests |",
    "| conjectured; of three frozen fish-stock tests one passed; untested outside fisheries |")
sub(BEC / 'THE-THEORY-OF-BECOMING.zh.md',
    "| 猜想；三项冻结的鱼类种群检验中一项通过，越过折点的酵母上的一项检验亦通过；在草地与森林上未经检验 |",
    "| 猜想；三项冻结的鱼类种群检验中一项通过；在渔业之外未经检验 |")
sub('experiments/margin-measured/README.md',
    "This is thesis T2, conjectured and supported, and untested outside fisheries.",
    "This is thesis T2, conjectured (of three frozen fish-stock tests, MQ5's passed) and untested outside fisheries.")

# The spine's first law is given by thermodynamics' second law read in available work
# (EntropyProduction.gainless_of_secondLaw); no converse is proved, so neither text says it is that law.
sub(CH / '02-MAP.md',
    "the spine's name, which read in available work is thermodynamics' second law, "
    "[§4](#r-least-loss-from-entropy-production),",
    "the spine's name, given in available work by thermodynamics' second law "
    "([§4](#r-least-loss-from-entropy-production)),")
sub('GLOSSARY.md',
    "read in available work it is thermodynamics' second law. Thermodynamics' first law",
    "read in available work, thermodynamics' second law gives it (`EntropyProduction.gainless_of_secondLaw`). "
    "Thermodynamics' first law")

# Landauer: Bennett 2003 said it first (erasing random data is thermodynamically reversible).
sub(CH / '02-MAP.md',
    'a logically irreversible step can be carried out thermodynamically reversibly (Sagawa 2014).',
    'a logically irreversible step can be carried out thermodynamically reversibly (Bennett 2003; Sagawa 2014).')
sub(CH / '08-METHOD.md',
    '*Open:* a least loss in energy from the pure core, which needs a reading of count as energy;',
    "*Open:* a least loss in energy from the pure core, which needs a reading of count as energy and, since Landauer's "
    "count so read bounds heat exported rather than exergy destroyed, irreversibility as well;")

# §7: the witness shows that the amounts up to T need not show when a loop forms; growth is at most polynomial;
# forms_by_closing lies in a section, not in a namespace Closing.
sub(CH / '02-MAP.md',
    "closes a chain (`Closing.forms_by_closing`). Up to `T` the carried amount reads only couplings acting before "
    "`T`, so before a loop forms growth is polynomial, and the amounts need not show whether one will: a loop forming "
    "at `T` and one forming later carry the same amounts up to `T`",
    "closes a chain (`forms_by_closing`). Up to `T` the carried amount reads only couplings acting before `T`, so "
    "before a loop forms growth is at most polynomial, and the amounts need not show when one forms: a loop forming "
    "at `T` and one forming at any later step carry the same amounts up to `T`")

# Witnesses cited as general laws (RegimeMargin.Notch, Crossing).
sub(CH / '02-MAP.md',
    'Unless giving rises with what is left, no level separates the fates (`Notch`)',
    'Rising with what is left cannot be dropped: in a witness whose giving does not rise with it, no level separates '
    'the fates (`RegimeMargin.Notch.no_threshold`)')
sub(CH / '02-MAP.md',
    'otherwise what was given carries a condition across it (`Crossing`).',
    'otherwise what was given can carry a condition across it (`Crossing.crosses`, a witness).')

# Finite bounds, not limits.
sub(CH / '04-LIFE.md',
    'over many cohorts of drawing the weight of the histories still mixed falls toward none, each kind fixed with a '
    'share the laws give.',
    'over cohorts of drawing the weight of the histories still mixed is bounded by a share falling geometrically, '
    'within which the histories fixing each kind take a share the laws give.')
sub('experiments/valuation-development/README.md',
    'a noisy witness in which greedy lock-in tends to certainty',
    'a noisy witness in which greedy lock-in has probability at least `1 - (2/3)^n`, so tends to certainty')

# Food-generated sets: Steel 2000 and Hordijk and Steel 2004 together.
sub(CH / '08-METHOD.md', 'autocatalytic sets are food-generated (Hordijk and Steel 2004)',
    'autocatalytic sets are food-generated (Steel 2000; Hordijk and Steel 2004)')

# "First law" in a third sense: the first of a record's laws.
sub(CH / '01-ROOT.md', 'These are the first laws of [continuation relative to a class]',
    'These are the opening laws of [continuation relative to a class]')
sub(CH / '05-COLLECTIVES.md',
    'the first law says when a part makes the difference to a loss, the rest what joint drawing does',
    'the first of the laws below says when a part makes the difference to a loss, the others what joint drawing does')

# OPENING's footnote (AI-written; the body in Ren's voice is untouched).
OP = BEC / 'OPENING.md'
sub(OP, 'Balance is the first law with locality:', "Balance is thermodynamics' first law with locality:")
sub(OP, 'With the first law and the entropy balance at each store,',
    "With thermodynamics' first law and the entropy balance at each store,")
sub(OP,
    'where each exchange that takes destroys at least a floor, as Landauer\'s bound gives one that erases a bit, the '
    'loss counted at any unit within the floor is at least one unit (`dissipative_of_floor`), and at an r-fold finer '
    'unit at least r units (`loss_at_finer_unit`);',
    'where each exchange that takes destroys at least a floor of exergy, the loss counted at any unit within the floor '
    'is at least one unit (`dissipative_of_floor`), and at an r-fold finer unit at least r units '
    "(`loss_at_finer_unit`), though Landauer's bound is no such floor by itself (it bounds the heat an erasure exports, "
    'and an erasure can be thermodynamically reversible);')
sub(OP, "The reading of amounts as available work, locality and Landauer's bound are hypotheses:",
    'The reading of amounts as available work, locality and any floor of destroyed exergy are hypotheses:')

# EntropyProduction: thermodynamics' first law named in full; the expected floor's hypothesis renamed from
# `landauer` (the code is otherwise unchanged; the periphery checker reruns); the checker's scope likewise.
LEAN = EP / 'EntropyProduction.lean'
TH = "thermodynamics' first law"
sub(LEAN, '* **The first law with locality gives balance.**', "* **Thermodynamics' first law with locality gives balance.**")
sub(LEAN, '(`Teleport.conserved_not_balanced`). With the first law and the entropy balance at each',
    f'(`Teleport.conserved_not_balanced`). With {TH} and the entropy balance at each')
sub(LEAN, 'can be thermodynamically reversible (Sagawa 2014).', 'can be thermodynamically reversible (Bennett 2003; Sagawa 2014).')
sub(LEAN, "/-! ## The first law: balance", "/-! ## Thermodynamics' first law: balance")
sub(LEAN, 'Read in available work relative to one environment, as the least loss is read above, the\nfirst law and',
    f'Read in available work relative to one environment, as the least loss is read above,\n{TH} and')
sub(LEAN, 'conserved locally, as energy is by the first law;', f'conserved locally, as energy is by {TH};')
sub(LEAN, '/-- The first law and the entropy balance at each condition,', f"/-- Thermodynamics' first law and the entropy balance at each condition,")
sub(LEAN, '/-- **Balance from the first law.** Read in available work relative to an environment at\n`T0 > 0`, with the first law and',
    f"/-- **Balance from {TH}.** Read in available work relative to an environment at\n`T0 > 0`, with {TH} and")
sub(LEAN, '/-- The first law and the entropy balance at each exchange,', f"/-- Thermodynamics' first law and the entropy balance at each exchange,")
sub(LEAN, '/-- **The exergy balance from the first law.** With the first law and the entropy balance at',
    f"/-- **The exergy balance from {TH}.** With {TH} and the entropy balance at")
sub(LEAN, 'work relative to one environment at `T0 > 0`, with the first law and the entropy balance at',
    f'work relative to one environment at `T0 > 0`, with {TH} and the entropy balance at')
sub(LEAN, '    (landauer : u * ∫ ω, ((L ω).takers cs t : ℝ) ∂μ ≤ ∫ ω, D ω ∂μ)',
    '    (floor : u * ∫ ω, ((L ω).takers cs t : ℝ) ∂μ ≤ ∫ ω, D ω ∂μ)')
assert 'the first law' not in LEAN.read_text(encoding='utf-8').replace("thermodynamics' first law", '').replace(
    "spine's first law", ''), 'a bare first law remains in EntropyProduction.lean'
sub(EP / 'check_entropy_production.py', 'relative to an environment at T0 > 0, the first law and the entropy "',
    "relative to an environment at T0 > 0, thermodynamics' first law and the entropy \"")
sub(EP / 'check_entropy_production.py',
    '"system\'s amounts are available work, that its stores and exchanges meet these premises, and Landauer\'s "\n'
    '    "bound itself are correspondences, not checked."',
    '"system\'s amounts are available work, that its stores and exchanges meet these premises, and any floor "\n'
    '    "of destroyed exergy are correspondences, not checked."')


# Records.
def path_of(d, path):
    parts = re.findall(r'[^.\[\]]+|\[-?\d+\]', path)
    for part in parts[:-1]:
        d = d[int(part[1:-1])] if part.startswith('[') else d[part]
    last = parts[-1]
    return d, (int(last[1:-1]) if last.startswith('[') else last)


NOTE = '26 October 2026, board item DF1b (study section DF_N): '
NOTE_ZH = '2026年10月26日，工作板条目 DF1b（研究第 DF_N 节）：'


def record(name, edits, en, zh, amend=False):
    """edits: (field, lang, old, new); old None sets the whole string. amend rewrites the record's DF1b note."""
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
    if amend:
        assert len(notes) == 1, (name, len(notes))
        notes[0]['en'], notes[0]['zh'] = NOTE + en, NOTE_ZH + zh
    else:
        assert not notes, name
        d['history'].append({'en': NOTE + en, 'zh': NOTE_ZH + zh})
    p.write_text(json.dumps(d, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')


record('least-loss-from-entropy-production', [
    ('next_delta', 'en', None,
     "A core form (rational amounts, no Mathlib) for the deterministic laws; an exchange-level Landauer bound on "
     "exported heat, from the core's count (merge-of-a-part-kept-by-the-rest) read as energy, by itself no floor of "
     "destroyed exergy. Finite-time floors and the uncertainty relation as instances of DestroysAtLeast restate known "
     "physics (the significance review's least-loss check): not planned."),
    ('next_delta', 'zh', None,
     '确定性规律在核心中以有理量、不用 Mathlib 的形式；由核心中的计数（merge-of-a-part-kept-by-the-rest）读作能量，得出交换层面'
     '对导出之热的 Landauer 下限，它本身不是被毁之㶲的下限。把有限时间的下限与不确定性关系作为 DestroysAtLeast 的实例，只会重述已知'
     '物理（意义审查的最小损失检查），不在计划中。'),
    ('correspondence', 'en', 'erasure can be thermodynamically reversible (Sagawa 2014)',
     'erasure can be thermodynamically reversible (Bennett 2003; Sagawa 2014)'),
    ('does_not_show[0]', 'en', "or Landauer's bound itself:", 'or any floor of destroyed exergy:'),
], "Landauer's bound is not a floor of destroyed exergy by itself: it bounds the heat an erasure exports, and erasure "
   "can be thermodynamically reversible (Bennett 2003; Sagawa 2014; UE6's first round); statement, law 5, "
   "correspondence, a limit, a related note and the next step say so. Thermodynamics' first law is named in full in a "
   "related note.",
   'Landauer 下限本身不是被毁㶲的下限：它界定擦除所导出的热，而擦除可以在热力学上可逆（Bennett 2003；Sagawa 2014；UE6 第一轮）；'
   '陈述、第 5 条规律、对应、一条限度、一条相关说明与下一步据此改写。一条相关说明中的热力学第一定律写出全名。', amend=True)

record('merge-of-a-part-kept-by-the-rest', [
    ('next_delta', 'en', None,
     "A reading of count as energy, so that Landauer's bound on the heat an erasure exports follows from this count "
     "with only that reading supplied (a DestroysAtLeast floor needs irreversibility as well: heat exported is not "
     "exergy destroyed); an independent review."),
    ('next_delta', 'zh', None,
     '把计数读作能量，使 Landauer 关于擦除所导出之热的下限只需给出这一读法即由此计数推出（DestroysAtLeast 的下限还需不可逆：'
     '导出之热不是被毁之㶲）；独立审查。'),
], "The related note and the next step no longer read Landauer's bound as DestroysAtLeast's floor: it is on heat "
   "exported, not on exergy destroyed (Bennett 2003; Sagawa 2014).",
   '相关说明与下一步不再把 Landauer 下限读作 DestroysAtLeast 的下限：它关乎导出之热，而非被毁之㶲（Bennett 2003；Sagawa 2014）。',
   amend=True)

record('fixation-by-drift', [
    ('statement', 'en', None,
     'Sampled by drift alone, generation after generation, a population of N keeps each count on average; after k '
     'generations its still-varied histories weigh a share at most ((N^N − 2)/N^N)^k, and those fixing a kind a share '
     'at most its starting share and within that of it.'),
    ('statement', 'zh', None,
     '仅由漂变逐代抽样，N 个成员的种群平均保持每个计数；k 代之后仍有差异的历史所占份额至多为 ((N^N − 2)/N^N)^k，固定某类的历史'
     '所占份额至多为其起始份额，且与之相差不超过此数。'),
    ('laws[4]', 'en', 'and with N r^k at least it, so the fixing share tends to h/N, the neutral fixation probability.',
     'and with N r^k at least it: finite bounds, whose reading is that the fixing share tends to h/N, the neutral '
     'fixation probability.'),
    ('laws[4]', 'zh', '加上 N r^k 则至少为它，故固定的份额趋于 h/N，即中性固定概率。',
     '加上 N r^k 则至少为它：有限之界，其读法为固定的份额趋于 h/N，即中性固定概率。'),
    ('related[2].detail', 'en', 'the fixation share a potential\'s ratio.',
     "the fixing share within a geometrically falling bound of a potential's ratio."),
    ('related[2].detail', 'zh', '固定份额为势之比', '固定份额与势之比之差有按几何下降之界'),
], 'The Lean gives finite two-sided bounds after k generations (Drift.fixation, Drift.varied_vanishes); the limit is '
   'read from them, as chapter 04 says. The statement gives the bounds, law 5 marks the limit as their reading, and '
   'the related note on selection gives its bound.',
   'Lean 给出 k 代之后有限的双侧界（Drift.fixation、Drift.varied_vanishes）；极限由之读出，如第 04 章所说。陈述给出这些界，'
   '第 5 条规律把极限标为其读法，关于选择的相关说明给出其界。', amend=True)

record('fixation-with-selection', [
    ('statement', 'en', None,
     "Replacing one at a time, up with weight a and down with b, after (M + 1) m steps the fixing share is at most a "
     "potential's ratio and at least it less (1 − (a/(a + b))^(M + 1))^m, so for positive a it tends to the ratio: the "
     "starting share where a = b, above it from every mixed start where b < a."),
    ('statement', 'zh', None,
     '一次替换一个、上升权重 a、下降 b 时，(M + 1) m 步后固定份额至多为势之比，至少为它减 (1 − (a/(a + b))^(M + 1))^m，故 a 为正'
     '时趋于此比：a = b 时为起始份额，b < a 时自每个混合起点高于它。'),
    ('laws[2]', 'en', 'and with the varied ones at least it; the varied ones vanish geometrically, so the fixation share '
     "tends to the potential's ratio.",
     'and with the varied ones at least it; after (M + 1) m steps the varied ones weigh at most r^m, with r + a^(M + 1) '
     "= (a + b)^(M + 1), so for positive a the fixation share tends to the potential's ratio."),
    ('laws[2]', 'zh', '仍有差异者几何地消失，故固定份额趋于势之比。',
     '(M + 1) m 步后仍有差异者至多重 r^m（r + a^(M + 1) = (a + b)^(M + 1)），故 a 为正时固定份额趋于势之比。'),
], 'The Lean gives finite two-sided bounds after (M + 1) m steps (Drift.Replacement.fixation, '
   'Drift.Replacement.varied_vanishes); the statement and law 3 give them and read the limit from them. The '
   'favoured kind lost with weight at least b^i stays in law 4 and the counterexample.',
   'Lean 给出 (M + 1) m 步之后有限的双侧界（Drift.Replacement.fixation、Drift.Replacement.varied_vanishes）；陈述与第 3 条规律'
   '给出这些界并由之读出极限。受青睐的一类以至少 b^i 的权重失去，仍见于第 4 条规律与反例。')

record('drift-offspring-sampled', [
    ('related[3].detail', 'en', None,
     'Many generations of sampling: the count kept, the still-varied histories bounded by a share falling '
     'geometrically, and the fixing share within that of the starting share.'),
    ('related[3].detail', 'zh', None, '多代抽样：计数保持，仍有差异的历史之份额有按几何下降之界，固定的份额在此界内等于起始份额。'),
], 'The related note on fixation-by-drift gives its finite bounds, not a limit.',
   '关于 fixation-by-drift 的相关说明给出其有限之界，而非极限。')

record('how-loops-form', [
    ('statement', 'en', None,
     'The loops formed by T + 1 are those formed by T and those through a coupling acting at T that closes a chain; '
     'with every condition listed, growth before one forms is at most polynomial and need not show when it will; with '
     'strengths read off the course, formation is read off the unfolding.'),
    ('statement', 'zh', None,
     '到 T + 1 形成的回路，是到 T 形成的回路与经过在第 T 步作用、闭合一条链的耦合的回路；条件全部列出时，形成之前增长至多是多项式，'
     '且未必显示它何时形成；强度从进程读出时，回路的形成从展开读出。'),
    ('laws[3]', 'en', 'The amounts before a loop forms need not show whether it will:',
     'The amounts before a loop forms need not show when it will:'),
    ('laws[3]', 'zh', '形成之前的量未必显示它是否将形成：', '形成之前的量未必显示它何时形成：'),
    ('correspondence', 'en', "a loop's formation is not foreseen from the amounts before it",
     "a loop's formation need not be foreseen from the amounts before it"),
    ('correspondence', 'zh', '回路的形成不从它之前的量预见', '回路的形成未必能从它之前的量预见'),
    ('related[0].detail', 'en', 'here the formation of the loop that runs away does not show in the amounts it carries '
     'either.', 'here the formation of the loop that runs away need not show in the amounts it carries either.'),
    ('related[0].detail', 'zh', '这里使之失控的回路的形成也不在它所携带的量中显出', '这里使之失控的回路的形成也未必在它所携带的量中显出'),
], 'That the amounts before a loop forms do not show when it forms is a witness (Closing.Onset.unforeseen, which '
   'compares a loop forming at T with one forming at any later step), so statement, law 4, the reading in the '
   'correspondence and a related note say they need not show it; growth before a loop forms is at most polynomial.',
   '形成之前的量不显示回路何时形成，这是一个见证（Closing.Onset.unforeseen，比较在 T 形成的回路与在任何更晚之步形成的回路），'
   '故陈述、第 4 条规律、对应中的读法与一条相关说明改为“未必显示”；回路形成之前的增长至多是多项式。', amend=True)

record('runaway-distance-uncoupled', [
    ('related[3].detail', 'en', 'there the formation of the loop that runs away does not show in the amounts it '
     'carries either', 'there the formation of the loop that runs away need not show in the amounts it carries either'),
    ('related[3].detail', 'zh', '那里使之失控的回路的形成也不在它所携带的量中显出', '那里使之失控的回路的形成也未必在它所携带的量中显出'),
], "The related note on how-loops-form reads its witness (Closing.Onset.unforeseen) as one: the formation need not "
   "show in the amounts.",
   '关于 how-loops-form 的相关说明把其见证（Closing.Onset.unforeseen）读作见证：形成未必显示在量中。')

record('balance-from-the-first-law', [
    ('statement', 'zh', '平衡与最小损失出自同一读法。', '两者出自同一读法。'),
    ('does_not_show[3]', 'en', 'it is relocated to the first law with locality',
     "it is relocated to thermodynamics' first law with locality"),
    ('does_not_show[3]', 'zh', '它被移到带局部性的第一定律上', '它被移到带局部性的热力学第一定律上'),
    ('related[1].detail', 'en', 'here it is the first law with locality.', "here it is thermodynamics' first law with locality."),
    ('related[1].detail', 'zh', '这里它是带局部性的第一定律。', '这里它是带局部性的热力学第一定律。'),
    ('correspondence', 'en', 'First law: the energy of a store', "Thermodynamics' first law: the energy of a store"),
], "'The first law' here is thermodynamics' first law, named in full apart from the spine's first law (Flow.Gainless), "
   "which thermodynamics' second law gives read in available work; title, statement, laws 4 and 5, a limit, the "
   "correspondence, a dependency and two related notes.",
   '这里的“第一定律”是热力学第一定律，与脊柱的第一律（Flow.Gainless，以可用功读出时由热力学第二定律给出）分开，写出全名；'
   '标题、陈述、第 4、5 条规律、一条限度、对应、一项依赖与两条相关说明。', amend=True)

record('balance-from-conservation-along-a-relation', [
    ('dependencies[0].detail', 'en', 'FL1 reads balance as the first law with locality',
     "FL1 reads balance as thermodynamics' first law with locality"),
    ('dependencies[0].detail', 'zh', 'FL1 把平衡读作带局部性的第一定律', 'FL1 把平衡读作带局部性的热力学第一定律'),
], "Thermodynamics' first law named in full in the correspondence and a dependency, apart from the spine's first law.",
   '对应与一项依赖中的热力学第一定律写出全名，与脊柱的第一律分开。', amend=True)

ZH_SPINE = ('The Chinese edition writes the spine\'s first law (Flow.Gainless) 第一律, as the account does, not 第一定律, '
            'which names thermodynamics\' first law.',
            '中文版把脊柱的第一律（Flow.Gainless）写作第一律，与本说明一致，而不写作第一定律，后者指热力学第一定律。')
record('recurrence-without-premise', [
    ('correspondence', 'zh', '以第一定律与耗散为前提', '以第一律与耗散为前提'),
    ('correspondence', 'zh', '第一定律之下被围住的家族', '第一律之下被围住的家族'),
    ('related[1].detail', 'zh', '在第一定律与耗散之下', '在第一律与耗散之下'),
], *ZH_SPINE)
record('mutual-dependence-and-its-pace', [
    ('does_not_show[1]', 'zh', '在第一定律下按指数增长的是量而不是差', '在第一律下按指数增长的是量而不是差'),
], *ZH_SPINE)
record('where-novelty-gain-comes-from', [
    ('correspondence', 'zh', '在第一定律下它需要来自每个有界部分之外的流入', '在第一律下它需要来自每个有界部分之外的流入'),
], *ZH_SPINE)

# A witness read as a general law (Ranking.Immediate).
record('becoming-stepwise-reading', [
    ('related[3].detail', 'en', 'and without such an event it still does (Ranking.Immediate).',
     'and in a law with no such event it still does (Ranking.Immediate.stepwise_ranks_absence, a witness).'),
    ('related[3].detail', 'zh', '没有这样的事件时仍排得更高（Ranking.Immediate）。',
     '在一个没有这样事件的律中仍排得更高（Ranking.Immediate.stepwise_ranks_absence，见证）。'),
], 'Ranking.Immediate is one law, a witness: the related note says so instead of reading it for every law without '
   'such an event.',
   'Ranking.Immediate 是一个律，即见证：相关说明如此说，而不把它读作对每个没有这样事件之律成立。')
record('ranking-under-readings', [
    ('counterexamples[1].detail', 'en', None,
     "In Immediate, whose focal formation's first step already crosses support, no focal event is included and the "
     "stepwise reading too ranks the absence higher (Ranking.Immediate.stepwise_ranks_absence, a witness), so what the "
     "stepwise reading gives up need not reach formations with no included event."),
    ('counterexamples[1].detail', 'zh', None,
     '在 Immediate 中，焦点形成的第一步已越过支持，没有被记入的焦点事件，逐步读法同样把不在场排得更高'
     '（Ranking.Immediate.stepwise_ranks_absence，见证），故逐步读法所放弃者未必及于没有被记入事件的形成。'),
], 'The counterexample is read as the witness it is: in Immediate the stepwise reading ranks the absence higher, '
   'which does not show that what it gives up concerns only formations with an included event.',
   '反例按其为见证读出：在 Immediate 中逐步读法把不在场排得更高，这并不表明它所放弃者只涉及有被记入事件的形成。')

# "First law" for the first of a record's laws.
record('eventual-widening', [
    ('does_not_show[4]', 'en', 'its first law fixed a recency form', 'the first of its laws fixed a recency form'),
    ('does_not_show[4]', 'zh', '其第一律定出近期形式', '其第一条规律定出近期形式'),
], "The first of a record's laws is not called its first law, the spine's name for Flow.Gainless.",
   '记录的第一条规律不称为其第一律，那是脊柱对 Flow.Gainless 的称呼。')
record('what-a-line-holds-and-a-regularity-takes-in', [
    ('hypotheses[0]', 'en', 'the region in the first law decided', 'the region in law 1 decided'),
    ('related[0].detail', 'en', 'proved from the first law (GS6)', 'proved from law 1 (GS6)'),
], "Law 1 is not called the first law, the spine's name for Flow.Gainless (English only; the Chinese has 首律).",
   '第 1 条规律不称为第一律，那是脊柱对 Flow.Gainless 的称呼（仅英文；中文作首律）。')
record('derived-history-law-exactness', [
    ('claim', 'en', 'in the core an instance of the first law, not one declaration',
     "in the core an instance of the record's first law, not one declaration"),
], "The record's own first law is named as the record's, apart from the spine's first law (Flow.Gainless).",
   '本记录自己的第一条规律写明为本记录的，与脊柱的第一律（Flow.Gainless）分开。')

record('what-keeping-widening-needs', [
    ('correspondence', 'en', 'food-generated (Hordijk and Steel 2004;', 'food-generated (Steel 2000; Hordijk and Steel 2004;'),
    ('correspondence', 'zh', '由食物生成（Hordijk 与 Steel 2004；', '由食物生成（Steel 2000；Hordijk 与 Steel 2004；'),
], 'Food-generated autocatalytic sets cited to their formalization, Steel 2000 and Hordijk and Steel 2004 (Journal of '
   'Theoretical Biology 227:451-461); the 2012 papers extend it.',
   '由食物生成的自催化集引其形式化，Steel 2000 与 Hordijk 与 Steel 2004（Journal of Theoretical Biology 227:451-461）；'
   '2012 年论文为扩展。', amend=True)
print('DF1b second round applied')
