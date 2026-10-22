#!/usr/bin/env python3
"""XL2's landing texts, from the worktree root on a branch rebased onto main, after the core checker run (which
holds Becoming.WholeAmounts) and the periphery run of Representation:
python3 -I <kit>/land_xl2.py CORE_RECEIPT SECTION   (after land_xl1.py, so SECTION is XL1's plus one)

Writes the study section, the record what-discrete-steps-and-whole-amounts-represent, the chapter's text (§0 block
A, §8.1 item 6; EN and ZH), COVERAGE.json's K4 natural-number laws, and the goal record's next step. Each text edit
must match exactly once; every declaration cited is resolved against the receipts."""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
LEAN = 'experiments/integrated-correction/general-framework/generative-basis/lean'
PKG = LEAN + '/becoming'
PER = LEAN + '/representation'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
STUDY = RF + '/BECOMING-RENEWAL-READING.md'
CH, CHZ = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md', 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md'
GOAL = '_process/goals/theory-of-becoming.json'
COV = 'theories/becoming/results/completion/COVERAGE.json'
RECORDS = ROOT / 'theories/becoming/results/records'
RID = 'what-discrete-steps-and-whole-amounts-represent'
core_id, N = sys.argv[1], int(sys.argv[2])
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
PRECEIPT = f'{PER}/representation-verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def once(path, old, new):
    t = (ROOT / path).read_text(encoding='utf-8')
    assert t.count(old) == 1, ('edit does not match once', path, old[:100], t.count(old))
    (ROOT / path).write_text(t.replace(old, new), encoding='utf-8')


core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
wm = next(m for m in core['modules'] if m['module'] == 'Becoming.WholeAmounts')
assert core['source_sha256']['Becoming.WholeAmounts'] == sha(f'{PKG}/Becoming/WholeAmounts.lean')
assert not any(wm['axiom_dependencies'].values())
per = json.loads((ROOT / PRECEIPT).read_text())
assert per['status'] == 'passed'
assert per['source_sha256']['Representation'] == sha(f'{PER}/Representation.lean'), 'periphery receipt does not bind'
pid = per['utc']
pm = per['modules'][0]
cnames = {d['name'] for d in wm['declarations']}
pnames = {d['name'] for d in pm['declarations']}
n_c, n_p, t_p = len(cnames), len(pnames), pm['theorems']
P = 'Becoming.Representation.'

HEAD = f'## {N}. What discrete steps and whole amounts represent (XL2, XL3)'
ANCH = f'{N}-what-discrete-steps-and-whole-amounts-represent-xl2-xl3'
SLINK = f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{ANCH}'
SECTION = f'''{HEAD}

```text
Result(s): new record {RID}; reuses rest-theorem-in-any-amounts (Amounts.EndlessFall, InAmounts.change_stops_iff),
       least-loss-rest (Dyadic, Halving), where-novelty-gain-comes-from (Web.rises_late_of_new) and the frequency
       record (Frequency.count, Frequency.SelfLoop.carried_eq, polynomial_iff, carried_doubles_roundTrip); the
       sampling of Becoming.Sampling and the tower of Becoming.Tower.
Delta: the goal record asked to settle whether every becoming can be represented with discrete steps and
       natural-number amounts, on which rest, novelty needing gain and the setting of runaway by frequency depend,
       and to state the laws with real amounts and continuous time. Settled: discrete steps represent real-valued
       time exactly for balance, at every reading at instants, coarser steps summing the finer (a tower), and what
       changes within a step is not shown; whole amounts are not available wherever amounts change by ever smaller
       amounts; over real amounts rest needs a least fall, novelty needs gain exactly where it is by a least
       separation, and runaway is set by frequency where the difference is held (every positive real strength) and
       by strength where it is damped. For a web of several conditions coupled at every step (XL3), its rate (the least
       norm of a power to the inverse of the power, the spectral radius by Gelfand's formula) decides: what it
       carries vanishes exactly where the rate is below one and runs away where above one.
Premises / correspondence: none in the core module; the periphery uses Lean's standard axioms through Mathlib. That
       an actual becoming's rates are summable, its amounts real and its loops of the module's form is a
       correspondence.
Evidence: core receipt {core_id} (Becoming.WholeAmounts, {n_c} theorems, empty axiom reports); periphery receipt
       {pid} (Representation, {t_p} theorems in {n_p} declarations, axioms propext, Quot.sound, Classical.choice only).
Boundary: the gap between the damped laws where the coupled step's norm exceeds its rate, noise, and
       real-valued time with rates that are not summable are not treated; the rate at exactly one is left open.
Output → input: chapter §0 block A and §8.1 item 6 (EN, ZH); COVERAGE.json's natural-number laws gain
       Web.rises_late_of_new and carried_doubles_roundTrip with their dense counterexamples; the goal record's next
       step.
```

**What was built.** In the core, `Becoming.WholeAmounts`: `falls_by_steps`, `not_falls_ever`, `Amounts.no_whole_reading`, `Halving.no_whole_reading`, `Halving.two_pow_lt`, `Halving.new_without_gain`, `Dyadic.half_return`; every one has an empty axiom report. In the periphery, `Representation` over Mathlib: `Course`, `Course.Balances`, `Course.balance_over`, `Course.sample_balances`, `Course.givenOver_coarse`, `Course.takenOver_coarse`, `Oscillation.still_reading`, `no_whole_reading`, `reals_no_whole_reading`, `unit_reading`, `new_without_gain`, `separated_bounded`, `separated_exceeds`, `carried`, `held_carried`, `selfLoop_cast`, `held_polynomial_iff`, `every_carried`, `every_bounded_iff`, `every_vanishes`, and (XL3) `rate`, `rate_bdd`, `rate_le`, `pow_rate_le`, `unbounded_of_one_lt`, `vanishes_iff`, `rate_real`, `every_vanishes_iff`, `webCarried`, `webCarried_eq`, `web_polynomial_iff`, `dampedWeb`, `dampedWeb_eq`, `dampedWeb_vanishes`, `rate_pow_le_norm`, `dampedWeb_unbounded`.

**Discrete steps.** A course in real-valued time whose levels change at the rate given less the rate taken, with rates summable over every stretch, balances over every stretch (the fundamental theorem of calculus), so read at any instants it balances across each step with the amounts summed over the step, and a coarser reading sums the finer: the readings at ever finer instants are a tower, as `Becoming.Tower` builds continuous time in the core. So every such becoming is represented by discrete steps, for balance exactly. What a reading does not show is what changes within a step: `Oscillation.still_reading` stands at nothing at every whole instant and rises to two between them, the analogue for levels of `Becoming.Sampling`'s strobe for activity. Laws of the levels at the instants read hold at every reading; laws about what happens between them are relative to the reading.

**Whole amounts.** Where some amount falls strictly at every step, no reading into the whole numbers keeps the strict falls (`Amounts.no_whole_reading`, in any amounts; the reals in the periphery). So a becoming whose amounts change by ever smaller amounts is not represented in whole numbers keeping its order; amounts in multiples of a unit are (`unit_reading`). The whole-number representation is exactly the representation with a least change.

**The three laws.** Rest: over any amounts it needs exactly that the census's total stop falling, which a least fall gives and an endless fall refutes (`World.InAmounts.change_stops_iff`, unchanged). Novelty: the halving stock is new at every step without gain (`Halving.new_without_gain`, core, and `new_without_gain`, reals), so `Web.rises_late_of_new` needs whole amounts; with a least separation `ε`, finitely many conditions new by `ε` at every step exceed every bound (`separated_exceeds`): novelty needs gain exactly where it is by a least separation. Runaway: a return of strength one half does not double (`Dyadic.half_return`), so `carried_doubles_roundTrip` needs whole strengths; but the held loop carries `D (1 + r) ^ count` for every real strength (the core's self-loop its case, `selfLoop_cast`), and for every positive strength it is bounded by a polynomial exactly where two to the count is (`held_polynomial_iff`): frequency decides, as in whole numbers. Damped with factor `a`, coupling at every step, it stays bounded exactly where `a + r ≤ 1` (`every_bounded_iff`): there strength decides. Whole amounts cannot keep a factor below one, which is why the core's loop is held.

**Several conditions (XL3).** For the step `M = a I + S` of a web of conditions coupled at every step, in any normed ring of such steps (matrices with an operator norm, for example), the rate is the least `‖M ^ k‖ ^ (1 / k)`; Gelfand's formula, cited and not proved here, identifies it with the spectral radius. What the web carries vanishes exactly where the rate is below one (`vanishes_iff`): one power below one in norm bounds every later power by a geometric factor. Above one it runs away (`unbounded_of_one_lt`), each power being at least the rate to that power. One condition's rate is `|a + r|` (`rate_real`), so XL2's damped loop is the web law's case (`every_vanishes_iff`). With several conditions, as with one, the damping and the strengths together decide, not each strength alone. Held and coupling at some steps only, a web carries `(1 + S) ^ count` (`webCarried_eq`): the steps at which it does not couple change nothing, so only how many steps couple matters. Where the rate of `1 + S` is above one, it is bounded by a polynomial exactly where two to the count is (`web_polynomial_iff`), the frequency law of `Becoming.Frequency` for several conditions and real strengths. Damped with factor `a` and coupling at some steps only, a web carries `a ^ (t - count) (a + S) ^ count` (`dampedWeb_eq`): the damping commutes with every step. Where `0 < a < 1`, the coupled step is at most `B ≥ 1` in norm and at most a share `θ` of the steps couple, with `a ^ (1 - θ) B ^ θ < 1`, what it carries vanishes whatever its strength (`dampedWeb_vanishes`): rare couplings are absorbed by damping. Where at least a share `θ` of the steps couple and `a ^ (1 - θ) ρ ^ θ > 1`, `ρ` the rate of `a + S`, it runs away (`dampedWeb_unbounded`): frequent strong couplings outrun the damping. Here frequency and strength trade against the damping, and the two laws meet where `B` is the rate.

**What stays open.** The gap between the two damped laws, where the norm of the coupled step exceeds its rate; the rate exactly one; a law with noise; rates that are not summable.
'''

study = (ROOT / STUDY).read_text(encoding='utf-8')
assert HEAD not in study
last = max(int(x) for x in re.findall(r'^## (\d+)\. ', study, re.M))
assert N == last + 1, ('section number', N, last)
(ROOT / STUDY).write_text(study.rstrip('\n') + '\n\n' + SECTION.strip() + '\n', encoding='utf-8')

# --- chapter EN ----------------------------------------------------------------------------------------------------
once(CH, '''a relation read at one step on relata no exchange there connects is read on the interleaving chosen (`Pair.apart_differs`, §1.4). | `World`, `Web`, `Flow` | representation |''',
     f'''a relation read at one step on relata no exchange there connects is read on the interleaving chosen (`Pair.apart_differs`, §1.4). Real-valued time is represented exactly for balance: a course whose levels change at the rate given less taken, its rates summable, balances across every step of any reading at instants, a coarser reading summing the finer (`Representation.Course.sample_balances`, `Representation.Course.givenOver_coarse`, periphery; XL2, [study §{N}]({SLINK})); what changes within a step is not shown (`Representation.Oscillation.still_reading`). | `World`, `Web`, `Flow` | representation |''')
once(CH, '''The second law supplies no least loss per step. | `Web.level`, `Flow.take`, `Flow.give` |''',
     '''The second law supplies no least loss per step. Whole amounts are not available for every becoming: no reading into the whole numbers keeps the order of an amount falling at every step (`Amounts.no_whole_reading`). Over dense amounts the halving stock is new at every step without gain (`Halving.new_without_gain`) and a return of strength one half does not double (`Dyadic.half_return`); over the reals novelty needs gain exactly where it is by a least separation (`Representation.separated_exceeds`), a held loop of every positive strength runs away exactly where it couples often (`Representation.held_polynomial_iff`), and a damped loop where its strength makes up for the damping (`Representation.every_bounded_iff`). | `Web.level`, `Flow.take`, `Flow.give` |''')
once(CH, '''real strengths and factors, damping and how fast a runaway is. *Settling it:*''',
     f'''the gap between the damped laws where a coupled step's norm exceeds its rate, the rate exactly one, and a law with noise. (Landed, XL2 and XL3, [study §{N}]({SLINK}): discrete steps represent real-valued time exactly for balance, whole amounts are not available where amounts change by ever smaller amounts, and over real amounts novelty needs gain exactly where it is by a least separation and runaway is set by frequency where the difference is held, by strength where it is damped, and for several conditions by the rate (the spectral radius) of the step; `Becoming.WholeAmounts`, periphery `Representation`.) *Settling it:*''')
# --- chapter ZH ----------------------------------------------------------------------------------------------------
once(CHZ, '''完成报告所列的每条自然数规律现在都有稠密形式或反例（R40、R41）；实数的强度与倍率。''',
     f'''完成报告所列的每条自然数规律现在都有稠密形式或反例（R40、R41）；耦合步的范数超过其速率时两条阻尼规律之间的间隙、速率恰为一，以及带噪声的规律。已落地（XL2、XL3，[研究第 {N} 节]({SLINK})）：离散步对平衡恰好表示实数时间，每次在时刻上的读取都平衡，较粗的读取是较细者之和；量以越来越小的量变化之处没有整数表示；实数量中，新颖恰在以最小间隔为新时需要增益，差别保持时失控由频率决定，有阻尼时由强度决定，多个条件时由一步的速率（谱半径）决定（`Becoming.WholeAmounts`、外围 `Representation`）。''')

# --- K4 ------------------------------------------------------------------------------------------------------------
cov = json.loads((ROOT / COV).read_text())
laws = cov['representation']['natural_number_laws']
assert not any(x['law'] in ('Becoming.Web.rises_late_of_new', 'Becoming.carried_doubles_roundTrip') for x in laws)
laws.append({'law': 'Becoming.Web.rises_late_of_new', 'dense': 'Becoming.Halving.new_without_gain', 'kind': 'counterexample',
             'note': 'over dyadic amounts the halving stock is new at every step, never rises and stays within one; over the reals novelty by a least separation needs gain (periphery Representation.separated_exceeds)'})
laws.append({'law': 'Becoming.carried_doubles_roundTrip', 'dense': 'Becoming.Dyadic.half_return', 'kind': 'counterexample',
             'note': 'a return of strength one half rises and stays below twice; over the reals a held loop of every positive strength runs away exactly where it couples often, a damped one where its strength makes up for the damping (periphery Representation.held_polynomial_iff, every_bounded_iff)'})
(ROOT / COV).write_text(json.dumps(cov, ensure_ascii=True, indent=2) + '\n')

# --- goal record ---------------------------------------------------------------------------------------------------
goal = json.loads((ROOT / GOAL).read_text(encoding='utf-8'))
ns = goal['overview']['next_step']
old = 'Settle whether every becoming can be represented with discrete steps and natural-number amounts, on which rest, novelty needing gain and the setting of runaway by frequency depend, and state the laws with real amounts and continuous time.'
assert ns['en'].count(old) == 1
ns['en'] = ns['en'].replace(old, 'Representation (XL2): discrete steps represent real-valued time exactly for balance, at every reading, what changes within a step not shown; whole amounts are not available where amounts change by ever smaller amounts, and over real amounts rest needs a least fall, novelty needs gain exactly where it is by a least separation, and runaway is set by frequency where the difference is held and by strength where it is damped and for several conditions by the rate of the step, its spectral radius (`Becoming.WholeAmounts`, periphery `Representation`). Open: the rate exactly one, and laws with noise.')
oldz = '判明每个生成／变化能否以离散步与自然数量表示（停息、新颖需要增益、由频率决定失控都依赖于此），并陈述实数量与连续时间下的规律。'
assert ns['zh'].count(oldz) == 1
ns['zh'] = ns['zh'].replace(oldz, '表示（XL2）：离散步对平衡恰好表示实数时间，每次读取皆然，步内的变化不显示；量以越来越小的量变化之处没有整数表示；实数量中停息需要最小下降，新颖恰在以最小间隔为新时需要增益，差别保持时失控由频率决定、有阻尼时由强度决定，多个条件时由一步的速率即谱半径决定（`Becoming.WholeAmounts`、外围 `Representation`）。开放：速率恰为一，以及带噪声的规律。')
(ROOT / GOAL).write_text(json.dumps(goal, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')

# --- record --------------------------------------------------------------------------------------------------------
def cites(names, pool):
    for n in names:
        assert n in pool, n
    return sorted(names)


rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'What discrete steps and whole amounts represent', 'zh': '离散步与整数量表示什么'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F01', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Discrete steps represent real-valued time exactly for balance; whole amounts are not available where amounts change ever less; over real amounts novelty needs gain only by a least separation, and runaway is set by frequency where held, by strength where damped.',
        'zh': '离散步对平衡恰好表示实数时间；量越变越少之处没有整数量；实数量中新颖只在有最小间隔时需要增益，失控在保持时由频率决定、有阻尼时由强度决定。'},
    'laws': [
        {'en': 'A course in real-valued time whose levels change at the rate given less taken, its rates summable, balances over every stretch and across every step of any reading at instants, a coarser reading summing the finer; a balanced course read at the whole instants can stand still at every step and change between them.',
         'zh': '实数时间中水平以所给减所取的速率变化、速率可加总的进程，在每一段上平衡，在时刻上的任何读取的每一步都平衡，较粗的读取是较细者之和；在整数时刻读取的平衡进程可以每步都静止而在其间变化。',
         'declarations': cites([P + x for x in ('Course', 'Course.Balances', 'Course.balance_over', 'Course.sample_balances', 'Course.givenOver_coarse', 'Course.takenOver_coarse', 'Oscillation.still_reading')], pnames)},
        {'en': 'No reading into the whole numbers keeps the strict falls of an amount falling at every step, in any amounts and in the reals; amounts in multiples of a unit are read in whole numbers.',
         'zh': '在任何量中以及在实数中，没有到整数的读法保住每步都下降之量的严格下降；单位倍数的量以整数读出。',
         'declarations': cites(['Becoming.Amounts.no_whole_reading', 'Becoming.Halving.no_whole_reading'], cnames) + cites([P + 'no_whole_reading', P + 'reals_no_whole_reading', P + 'unit_reading'], pnames)},
        {'en': 'The halving stock is new at every step without gain; finitely many conditions new by at least a least separation at every step exceed every bound.',
         'zh': '减半的存量每步都新而没有增益；有限多个条件若每步以至少一个最小间隔为新，就超过每个界。',
         'declarations': cites(['Becoming.Halving.new_without_gain'], cnames) + cites([P + 'new_without_gain', P + 'separated_bounded', P + 'separated_exceeds'], pnames)},
        {'en': 'A return of strength one half does not double; a held loop of every positive real strength carries D (1 + r) to the count, the core\'s self-loop its case, and is bounded by a polynomial exactly where two to the count is; damped, coupling at every step, it stays bounded exactly where its factor and strength add to at most one, and vanishes below.',
         'zh': '强度二分之一的返回不加倍；任何正实数强度的保持环路携带 D (1 + r) 的计数次方，核心的自环是其情形，且恰在 2 的计数次方受多项式所限时受多项式所限；有阻尼时每步耦合，恰在倍率与强度之和至多为一时有界，小于一时消失。',
         'declarations': cites(['Becoming.Dyadic.half_return'], cnames) + cites([P + x for x in ('carried', 'held_carried', 'selfLoop_cast', 'held_polynomial_iff', 'every_carried', 'every_bounded_iff', 'every_vanishes')], pnames)},
        {'en': 'A web of several conditions coupled at every step, in any normed ring of steps: what it carries vanishes exactly where its rate (the least norm of a power to the inverse of the power, the spectral radius by Gelfand\'s formula) is below one, and runs away where above one; one condition\'s rate is the absolute value of factor plus strength; held and coupling at some steps only, a web carries (1 + S) to the count and, its rate above one, is bounded by a polynomial exactly where two to the count is; damped and coupling at some steps, it carries a to the steps not coupled times (a + S) to the count, vanishes where couplings are rare enough for the damping and runs away where frequent enough against it (XL3).',
         'zh': '每步耦合的多个条件之网，在任何赋范环中：其所携带者恰在其速率（幂的范数的幂次倒数之最小值，由 Gelfand 公式即谱半径）小于一时消失，大于一时失控；一个条件的速率是倍率加强度的绝对值；保持而只在部分步耦合的网携带 (1 + S) 的计数次方，速率大于一时恰在 2 的计数次方受多项式所限时受多项式所限；有阻尼而只在部分步耦合时，携带 a 的未耦合步数次方乘 (a + S) 的计数次方，耦合足够稀少时消失，足够频繁时抵过阻尼而失控（XL3）。',
         'declarations': cites([P + x for x in ('rate', 'rate_le', 'pow_rate_le', 'vanishes_iff', 'unbounded_of_one_lt', 'rate_real', 'every_vanishes_iff', 'webCarried', 'webCarried_eq', 'web_polynomial_iff', 'dampedWeb', 'dampedWeb_eq', 'dampedWeb_vanishes', 'rate_pow_le_norm', 'dampedWeb_unbounded')], pnames)},
    ],
    'hypotheses': [{'en': 'No premise in the core module; the periphery uses Lean\'s standard axioms through Mathlib and states the summability of rates, the bounds and the strengths where each law takes them.',
                    'zh': '核心模块不加前提；外围经 Mathlib 使用 Lean 的标准公理，并在各律取用处写明速率的可加总、界与强度。'}],
    'does_not_show': [
        {'en': 'That an actual becoming\'s rates are summable, its amounts real, or its loops of one condition.', 'zh': '实际生成／变化的速率可加总、其量为实数、或其环路只有一个条件。', 'kind': 'scope'},
        {'en': 'The gap between the damped laws where the coupled step\'s norm exceeds its rate; the rate exactly one; that the rate is the spectral radius, which is Gelfand\'s formula, cited; laws with noise.', 'zh': '耦合步的范数超过其速率时两条阻尼规律之间的间隙；速率恰为一；速率即谱半径（Gelfand 公式，引用而未证明）；带噪声的规律。', 'kind': 'scope'},
        {'en': 'That the whole-number laws are wrong where they apply: they hold of every becoming with a least change.', 'zh': '整数规律在其适用处有误：它们对每个有最小变化的生成／变化成立。', 'kind': 'non-implication'},
    ],
    'counterexamples': [
        {'path': f'{PKG}/Becoming/WholeAmounts.lean', 'detail': {
            'en': 'Halving.new_without_gain against Web.rises_late_of_new over dense amounts; Dyadic.half_return against carried_doubles_roundTrip.',
            'zh': 'Halving.new_without_gain 在稠密量上反驳 Web.rises_late_of_new；Dyadic.half_return 反驳 carried_doubles_roundTrip。'}},
        {'path': f'{PER}/Representation.lean', 'detail': {
            'en': 'Oscillation.still_reading: a balanced course still at every whole instant and changing between them.',
            'zh': 'Oscillation.still_reading：在每个整数时刻静止、其间变化的平衡进程。'}}],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'formal-not-empirical', 'names-provisional', 'omission-not-refutation'],
    'validation_scope': {
        'en': f'Core: Lean 4.29.1 checker, receipt {core_id}: the {n_c} declarations of Becoming.WholeAmounts have empty axiom reports. Periphery: Lean 4.30.0-rc2 with Mathlib, receipt {pid}: {t_p} theorems in {n_p} declarations of Representation, each depending on Lean\'s standard axioms only; its core closure matches passed receipts. Author review in study section {N}; not independently reviewed.',
        'zh': f'核心：Lean 4.29.1 检查器，回执 {core_id}：Becoming.WholeAmounts 的 {n_c} 项声明公理报告为空。外围：Lean 4.30.0-rc2 与 Mathlib，回执 {pid}：Representation 的 {n_p} 项声明（{t_p} 项定理）只依赖 Lean 的标准公理；其核心闭包与已通过的回执一致。作者审查见研究第 {N} 节；未经独立审查。'},
    'next_delta': {'en': 'A law with noise; the rate exactly one; an independent review.',
                   'zh': '带噪声的规律；速率恰为一；独立审查。'},
    'correspondence': {
        'en': 'The goal record\'s question whether every becoming can be represented with discrete steps and natural-number amounts, and chapter §8.1 item 6. Real-valued time enters as the periphery correspondence the core\'s tower anticipated (Becoming.Tower); the fundamental theorem of calculus, the pigeonhole principle and the geometric series are standard.',
        'zh': '目标记录关于每个生成／变化能否以离散步与自然数量表示的问题，以及第 8.1 节第 6 项。实数时间作为核心之塔（Becoming.Tower）所预期的外围对应进入；微积分基本定理、鸽巢原理与几何级数是标准的。'},
    'canonical_source': f'{PER}/Representation.lean',
    'aliases': ['what discrete steps and whole amounts represent', '离散步与整数量表示什么', 'Becoming.Representation.held_polynomial_iff', 'Becoming.Representation.separated_exceeds'],
    'dependencies': [
        {'id': 'rest-theorem-in-any-amounts', 'relation': 'formal-reuse', 'detail': {'en': 'Reuses Amounts.EndlessFall and the Dyadic witnesses.', 'zh': '复用 Amounts.EndlessFall 与二进分数的见证。'},
         'interface': {'output': {'en': 'Amounts with an endless fall.', 'zh': '有无尽下降的量。'}, 'input': {'en': 'No whole reading.', 'zh': '没有整数读法。'}, 'conditions': {'en': 'None.', 'zh': '无。'}, 'evidence': f'{PKG}/Becoming/WholeAmounts.lean'}},
    ],
    'related': [{'id': 'theory-of-becoming-foundation', 'detail': {'en': 'The representation question of the first target.', 'zh': '首要目标的表示问题。'}}],
    'references': [{'path': f'{PKG}/Becoming/WholeAmounts.lean', 'role': 'proof', 'declarations': sorted(cnames), 'sha256': sha(f'{PKG}/Becoming/WholeAmounts.lean')},
                   {'path': f'{PER}/Representation.lean', 'role': 'proof', 'declarations': sorted(pnames), 'sha256': sha(f'{PER}/Representation.lean')},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': PRECEIPT, 'role': 'receipt', 'sha256': sha(PRECEIPT)},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': CH, 'role': 'statement', 'sha256': sha(CH)}],
    'proof_bindings': [{'source': f'{PKG}/Becoming/WholeAmounts.lean', 'receipt': RECEIPT, 'sha256_pointer': '/source_sha256/Becoming.WholeAmounts', 'success_pointer': '/status', 'success_value': 'passed'},
                       {'source': f'{PER}/Representation.lean', 'receipt': PRECEIPT, 'sha256_pointer': '/source_sha256/Representation', 'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{'en': f'22 October 2026: added (XL2, with XL3\'s webs of several conditions), on the goal record\'s representation question and chapter §8.1 item 6; study section {N}.',
                 'zh': f'2026年10月22日：新增（XL2），针对目标记录的表示问题与第 8.1 节第 6 项；研究第 {N} 节。'}],
}
assert len(rec['statement']['en']) <= 300, len(rec['statement']['en'])
path = RECORDS / f'{RID}.json'
assert not path.exists()
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('landed texts', RID, 'section', N, n_c, n_p, t_p)
