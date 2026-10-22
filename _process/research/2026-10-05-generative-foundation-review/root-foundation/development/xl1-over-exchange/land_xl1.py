#!/usr/bin/env python3
"""XL1's landing texts, from the worktree root on a branch rebased onto main, after the checker run:
python3 -I <kit>/land_xl1.py CORE_RECEIPT SECTION

Writes the study section, the record central-laws-over-every-exchange, the chapter's text (§0 block C, §8.1 item 1,
§8.5, §8.9, T8; EN and ZH), the foundation chapter's §9.1 (EN, ZH), the goal record's next step, and the history note
and next_delta of premises-that-are-states-of-the-law. Every count is computed from the receipt and COVERAGE.json, and
every declaration cited is resolved against the receipt. Each text edit must match exactly once."""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
STUDY = RF + '/BECOMING-RENEWAL-READING.md'
CH, CHZ = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md', 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md'
FD, FDZ = 'theories/becoming/chapters/BECOMING-FOUNDATION.md', 'theories/becoming/chapters/BECOMING-FOUNDATION.zh.md'
GOAL = '_process/goals/theory-of-becoming.json'
COV = 'theories/becoming/results/completion/COVERAGE.json'
RECORDS = ROOT / 'theories/becoming/results/records'
RID = 'central-laws-over-every-exchange'
MOD = 'OverExchange'
core_id, N = sys.argv[1], int(sys.argv[2])
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def src(mod):
    return f'{PKG}/Becoming/{mod}.lean'


def once(path, old, new):
    t = (ROOT / path).read_text(encoding='utf-8')
    assert t.count(old) == 1, ('edit does not match once', path, old[:100], t.count(old))
    (ROOT / path).write_text(t.replace(old, new), encoding='utf-8')


mod = next(m for m in core['modules'] if m['module'] == f'Becoming.{MOD}')
assert core['source_sha256'][f'Becoming.{MOD}'] == sha(src(MOD)), 'receipt does not bind the module'
assert not any(mod['axiom_dependencies'].values())
names = {d['name'] for d in mod['declarations']}
n_decl, n_thm = len(mod['declarations']), sum(1 for d in mod['declarations'] if d.get('kind') == 'theorem')
cov = json.loads((ROOT / COV).read_text())
forms = cov['premises']['exchange_forms']
assert set(forms.values()) <= names, sorted(set(forms.values()) - names)
read =sorted(c for c, f in forms.items() if f.startswith('Becoming.World.ReadOffExchange.'))
two = sorted(c for c, f in forms.items() if c not in read and f in (
    'Becoming.World.withRest_comparison_within_response', 'Becoming.World.withRest_act_unselected',
    'Becoming.World.withRest_act_selected_by_pool', 'Becoming.World.withRest_widening_selected_by_pool',
    'Becoming.World.withRest_apart_only_downstream'))
one = sorted(c for c in forms if c not in read and c not in two)
nF, n1, n2, nR = len(forms), len(one), len(two), len(read)
assert n1 + n2 + nR == nF
central = sorted({d for row in cov['rows'] for d in row['declarations']})
nC = len(central)


def short(n):
    return n.removeprefix('Becoming.')


# --- the study section ---------------------------------------------------------------------------------------------
HEAD = f'## {N}. The central laws over every relation of exchange (XL1)'
SECTION = f'''{HEAD}

```text
Result(s): new record {RID}; reuses premises-read-off-the-exchange (World.withRest, withRest_balanced,
       withRest_dependent_iff, ExchangeLaw.readWorld), requirement-over-open-exchanges (ExchangeRelation, Runs,
       RespondsBelow), census-read-off-the-exchange (World.withRest_counted) and premises-that-are-states-of-the-law;
       instantiates the {nF} central declarations listed below.
Delta: chapter §8.1 item 1 left open "the spine's laws over every law, or relation, of exchange rather than over
       separately chosen premises". Of the {nC} central declarations of the completion criterion's coverage, {nF}
       take in their binders balance, only active relata giving or taking, or activity needing support. Each now has
       a form over what is read off an exchange, its proof the central law, its binders taking none of the four:
       {n1} over every world with its rest counted, {n2} (the comparisons of two courses) over every two worlds of one
       kind of relatum with their rests counted, and {nR} over every world read off a relation of exchange
       (World.ReadOffExchange: its flow a run of the relation along its standings, each requirement a necessary
       response of its exchange), which every run of every relation and the course of every law are and a world
       whose relatum exchanges unsupported is not. The rest theorem's form also reads the census off the exchange
       where a named family closes each step. completion.py's K3 checks every form.
Premises / correspondence: what stays a hypothesis is a state of the law (dissipation, embodiment, bounded
       transmission, enclosure, feasibility, a census of what stands) or the law's own; the forms over a world read
       off a relation take that reading. No ethical predicate, ranking or axiom.
Evidence: core receipt {core_id} (passed): {n_decl} declarations of Becoming.{MOD}, {n_thm} theorems, empty axiom
       reports; research-check runs the K3 check on the forms.
Boundary: the forms read the world with its rest counted; where closure fails the rest is a relatum the laws count
       (a giver, a feeder). Discrete steps and natural-number amounts unchanged (item 6). The twelve companion modules
       left are kept, judged below. Which law or relation of exchange holds is not derived.
Output → input: chapter §0 block C, §8.1 item 1, §8.5, §8.9 and T8 (EN, ZH); BECOMING-FOUNDATION §9.1 (EN, ZH);
       COVERAGE.json (tying, exchange_forms, reading; the balance and embodiment patterns widened to `.Balanced` and
       `ArisingEmbodied`); completion.py K3; premises-that-are-states-of-the-law's next_delta met; the goal record's
       next step.
```

**What was built.** `Becoming.OverExchange`, a leaf module of the pure core: `World.withRest_acting`, `World.withRest_taking`, `World.withRest_rest_idle` (under balance the rest takes and gives nothing), `World.withRest_some` (the world's relata exchange and stand as in the world), `World.withRest_present`, `World.withRest_start`, `World.ReadOffExchange`, `World.ReadOffExchange.dependent`, `ExchangeRelation.Runs.readOffExchange`, `ExchangeLaw.readWorld_readOffExchange`, `World.takingUnsupported` with `World.takingUnsupported_not_readOff`, and the forms. Every one has an empty axiom report.

**The forms.** Over every world with its rest counted ({n1}): {", ".join("`" + short(c) + "`" for c in one)}. Over every two worlds of one kind of relatum ({n2}): {", ".join("`" + short(c) + "`" for c in two)}. Over every world read off a relation of exchange ({nR}): {", ".join("`" + short(c) + "`" for c in read)}. Each central declaration is mapped to its form in `COVERAGE.json` (`premises.exchange_forms`).

**What the reading changes.** With the rest counted, what the world's own relata do not account for is the rest's exchange, and a law naming givers or feeders counts the rest among them where it gives: `consumption_ends_with_feeders`'s feeders include the rest wherever something comes from beyond, and the rest, requiring nothing, is never unsupported, so consumption fed from beyond is not bounded by it. That is the content, not a defect: the law over the world's own relata is the case where the world balances, and there the rest takes and gives nothing (`World.withRest_rest_idle`) and the world's relata are as they were (`World.withRest_some`). Closure is a state of the law (feasibility, `ExchangeLaw.readWorld_closed_iff`); the forms hold whether or not it holds.

**Requirement as response.** Activity needing support is the one tying premise that needs more than counting the rest: requirement read as necessary response of the exchange. `World.ReadOffExchange` names exactly that reading, and K3 lists what meets and fails it. Read as possible response it fails (`ExchangeRelation.free_unsupported`), so the forms of the {nR} laws hold of what is read off an exchange with requirement read as what the exchange cannot go on without.

**The check.** `completion.py` gains `exchange_forms`: for each central declaration whose binders take one of the four tying premises, the listed form must be a declaration of the receipt, its binders must take none of the four, and its proof must reach the central declaration; the report lists the forms and what they still take. Two of K3's patterns were too narrow: `w.Balanced` and `ArisingEmbodied` were not found, so `World.comes_to_rest_unrefuted` was reported without balance and embodiment; the patterns now find them (`World.balanced_reidentify_iff`, an equivalence about balance, is now counted as using it, as K3 counts every use). The tying check reads binders only, so a statement about a premise (`Web.roles_dependent`, an equivalence) is not taken as assuming it.

**The internal-relations thesis.** The argument that the determinations the World premises name are internally related moments of one exchange, and its limits, is in [BECOMING-FOUNDATION §9.1](../../../../theories/becoming/chapters/BECOMING-FOUNDATION.md#91-the-passage-from-inclusion-to-relation-argued). In short: four ties hold by what the readings are, the central laws then hold of every world read off an exchange, and what varies is the law, not a relation between separately given items; what this does not reach is that every becoming has a law or relation of exchange of this kind (items 6 and 7) and the warrant of the readings.

**The companion modules, judged.** R32 folded 26 reading modules into the modules they read and kept 19 with reasons ([§223](#223-forwarders-copies-and-reading-modules-r32)). Twelve with a run, trace or frame suffix were left unjudged. By R32's criterion (fold where the module adds no import to its source), each is kept. Folding would add to its law module imports that the module does not otherwise reach: `FrontierFrames` into `Frontier` (Extension, Acceptance), `LearnableRuns` into `Learnable` (Parting, LimitVerification), `FinerTraces` into `Situations` (WeightedTraces), `SeekingRuns` into `Seeking` (Branching, Capture). For seven, the added import itself reaches the law module, so the fold is impossible without a cycle: `ContextualRuns` (ParityReadings), `CounterfactualRuns` (Runs, which reads `Becoming.Reading` above `Counterfactual`), `IdentificationRuns` (LearningRuns, Courses), `LearningRuns` (LearnableRuns, Parting), `RouteTraces` (FormedLoops), `SituationTraces` and `TypicalRuns` (FinerTraces). `ContextArrivalTraces` alone would add only the base `Becoming.Frame` to `Context`; the fold changes no statement and recompiles every module above `Context`, so it is left for the next change to `Context`. None of the twelve is a forwarder: each states laws of its own (6 to 44 theorems). So no companion module only carries laws across the old gap; the gap is closed by definition (R28), and these modules are readings with content of their own, placed where their imports put them.

**What remains of item 1.** Nothing formal beyond which law holds (item 7) and the representation (item 6).
'''

study = (ROOT / STUDY).read_text(encoding='utf-8')
assert HEAD not in study
last = max(int(x) for x in re.findall(r'^## (\d+)\. ', study, re.M))
assert N == last + 1, ('section number', N, last)
(ROOT / STUDY).write_text(study.rstrip('\n') + '\n\n' + SECTION.strip() + '\n', encoding='utf-8')
ANCH = f'{N}-the-central-laws-over-every-relation-of-exchange-xl1'
SLINK = f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{ANCH}'

# --- the chapter (EN) ----------------------------------------------------------------------------------------------
once(CH, '''For a law of exchange the two readings are the law's (`ExchangeLaw.relation_readWeb_requires`, `ExchangeLaw.relation_readWeb_may`).
''', f'''For a law of exchange the two readings are the law's (`ExchangeLaw.relation_readWeb_requires`, `ExchangeLaw.relation_readWeb_may`).
  - *The central laws over every relation of exchange* (XL1, [study §{N}]({SLINK})). Each of the {nF} central declarations of the completion criterion's coverage that takes balance, only active giving or taking, or activity needing support holds over what is read off an exchange with those premises discharged (`Becoming.OverExchange`): over every world with its rest counted where it needs balance and the activity premises (`World.withRest_renewedBy`, `World.withRest_comes_to_rest_unrefuted`, …), over every two worlds of one kind of relatum for the comparisons of two courses (`World.withRest_act_unselected`, …), and over every world read off a relation of exchange where it needs activity needing support (`World.ReadOffExchange`, `World.ReadOffExchange.consumption_ends_with_feeders`, …), which every run of every relation and every law's course are (`ExchangeRelation.Runs.readOffExchange`, `ExchangeLaw.readWorld_readOffExchange`). What stays a hypothesis is a state of the law or the law's own. With the rest counted, a law naming givers counts the rest among them where something comes from beyond; under balance the rest exchanges nothing and the laws read the world's own relata (`World.withRest_rest_idle`, `World.withRest_some`). K3 checks every form.
''')
once(CH, '''*Open:* the spine's laws over every law, or relation, of exchange rather than over separately chosen premises, and folding back the companion modules that carried laws across the old gap; the definitional part ([S4](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/twentieth-review/S4-ONE-BASE-FEASIBILITY.md)) has landed.''',
     f'''Landed (XL1, [study §{N}]({SLINK})): the spine's central laws over every relation of exchange rather than over separately chosen premises. Each of the {nF} central declarations taking a tying premise has its form over what is read off an exchange, the premise discharged by the reading and what stays a state of the law (§0, block C; `Becoming.OverExchange`; K3 checks the forms). The companion modules are judged by R32's criterion: none only carries laws across the old gap, and folding the twelve left would add to their law modules imports they do not reach, beyond the base for eleven and through a cycle for seven (study §{N}). *Open:* no formal part beyond which law holds (item 7) and the representation (item 6); the definitional part ([S4](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/twentieth-review/S4-ONE-BASE-FEASIBILITY.md)) has landed.''')
once(CH, '''- **The deductive necessity of the whole**, with no added substantive premise: that its determinations are internally related moments of one unfolding, not a collection of instances ([foundation §9](BECOMING-FOUNDATION.md#9-the-content-of-the-whole-deduction)).''',
     '''- **The deductive necessity of the whole**, with no added substantive premise: that its determinations are internally related moments of one unfolding, not a collection of instances ([foundation §9](BECOMING-FOUNDATION.md#9-the-content-of-the-whole-deduction)). Argued for the determinations the World premises name ([foundation §9.1](BECOMING-FOUNDATION.md#91-the-passage-from-inclusion-to-relation-argued)): four ties hold by what the readings of one exchange are, the central laws then hold of every world read off an exchange, and what varies is the law, not a relation between separately given items. Open: that every becoming has a law or relation of exchange of this kind (items 6 and 7), and the warrant of the readings, requirement read as necessary response above all.''')
once(CH, '''- **The internal-relations thesis is open** (item 1). *Would answer it:* the passage the first target describes.''',
     '''- **The internal-relations thesis.** *Answered in part* ([foundation §9.1](BECOMING-FOUNDATION.md#91-the-passage-from-inclusion-to-relation-argued)): within the representation, the determinations the World premises name are readings of one exchange, four of their ties hold by what the readings are, and every central law then holds of every world read off an exchange (`Becoming.OverExchange`). *Would answer the rest:* that every becoming has a law or relation of exchange whose readings these are (items 6 and 7), and an argument that requirement is necessary response of the exchange rather than possible response.''')
once(CH, '''That shows the theory needs no independent entity, not that reality has none; the internal-relations thesis is open (§8.1, item 1).''',
     '''That shows the theory needs no independent entity, not that reality has none. The internal-relations thesis is argued for the determinations the World premises name: the central laws hold of every world read off an exchange (`Becoming.OverExchange`; [foundation §9.1](BECOMING-FOUNDATION.md#91-the-passage-from-inclusion-to-relation-argued)); that every becoming has such an exchange is open (§8.1, items 6 and 7).''')

# --- the chapter (ZH) ----------------------------------------------------------------------------------------------
once(CHZ, '''五个由构造成立，三个是交换之律的状态（`Becoming.Reading`、`Becoming.ExchangePremises`）。''',
     f'''五个由构造成立，三个是交换之律的状态（`Becoming.Reading`、`Becoming.ExchangePremises`）。XL1（[研究第 {N} 节]({SLINK})）：完成标准覆盖中取平衡、只有活跃者给出或取用、或活动需要支撑的 {nF} 条中心规律，都对从交换读出者陈述，这些前提由读法卸去（`Becoming.OverExchange`）：只需平衡与两个活跃前提者，对每个算入其余的世界；两段进程的比较，对同一种关系项的每两个世界；需要活动需要支撑者，对每个从交换关系读出的世界（`World.ReadOffExchange`），每个交换关系的每段运行与每个交换之律的进程都是这样的世界。仍为假设的，是律的状态或各律自身的假设；K3 检查每个形式。''')
once(CHZ, '''其余方向由指名的构造满足（R43）：每个运行是确定它的世界（`Frame.world_fixes_run`），一种关系项上的每个网与流是一个世界的（`World.of_web`、`World.of_flow`）。''',
     f'''其余方向由指名的构造满足（R43）：每个运行是确定它的世界（`Frame.world_fixes_run`），一种关系项上的每个网与流是一个世界的（`World.of_web`、`World.of_flow`）。已落地（XL1，[研究第 {N} 节]({SLINK})）：脊柱的中心规律对每个交换关系陈述，而非对分别选定的前提陈述；{nF} 条取联结前提的中心规律各有其在交换上的形式（`Becoming.OverExchange`）。余下十二个伴随模块按 R32 的标准判定保留：并回会给其规律模块加上它本不触及的导入，七个经由循环。*开放：* 除哪条律成立（第 7 项）与表示（第 6 项）外没有形式部分。''')
once(CHZ, '''内在关系论题开放（§8.1 第 1 项）。*禁止：*''',
     '''内在关系论题对世界前提所称的诸规定已有论证：中心规律对每个从交换读出的世界成立（`Becoming.OverExchange`；[基础第 9.1 节](BECOMING-FOUNDATION.zh.md#91-从包容到关系的过渡论证)）；每个生成／变化是否都有这样的交换，仍开放（§8.1 第 6、7 项）。*禁止：*''')
once(CHZ, '''学得的是哪个函数；内在关系论题开放（第 1 项）；''', '''学得的是哪个函数；内在关系论题（第 1 项；对世界前提所称的诸规定已部分回答，见[基础第 9.1 节](BECOMING-FOUNDATION.zh.md#91-从包容到关系的过渡论证)）；''')

# --- the foundation chapter §9.1 -----------------------------------------------------------------------------------
FD91 = f'''
<a id="91-the-passage-from-inclusion-to-relation-argued"></a>
### 9.1 The passage from inclusion to relation, argued

[AI argument, XL1, 22 October 2026; [study §{N}](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{ANCH})]

The step this section left to be demonstrated is that the whole's determinations have their constitution within the same unfolding, rather than being a collection of established instances. For the determinations the World premises name it can now be argued, and its limits stated.

**Two ways to hold the laws.** A world (`World`) carries its standings, its activity, what each relatum requires and needs, and what it draws on, as separately chosen fields. Held that way, the eight premises that tie them are independent (`World.independent`): each is failed by a world meeting the other seven. A law under balance is then a law of the worlds that happen to balance, and the whole is what its parts happen to satisfy, a collection. The other way is to read each determination off one exchange: activity as exchanging, drawing as taking from, requirement as what the exchange cannot go on without (necessary response), and what the relata do not account for as the rest of the whole, one more relatum (`Becoming.Reading`).

**A relation is internal here** where it holds by what its terms are: no pair of terms of that kind lacks it, and what lacks it is not a pair of that kind. Read off one exchange, four ties are internal in this sense. Balance and only active relata giving and taking hold of every world with its rest counted, whatever its standings and requirements; activity needing support holds of every world read off a relation of exchange, and a world whose relatum exchanges while what it requires stands below the need is not one (`World.ReadOffExchange.dependent`, `World.takingUnsupported_not_readOff`).

**The central laws are then laws of the exchange.** Every central law of the coverage that takes one of these ties holds of every world read off an exchange with the tie discharged (`Becoming.OverExchange`, {nF} laws, checked by K3). So these laws are not a collection, each holding of whatever world meets a separately chosen premise; each says how moments of one exchange stand to one another.

**Contingency lies in the law.** What reading does not settle is which exchange there is: closure (feasibility), dissipation, embodiment, bounded transmission and enclosure are states of the law, met by some laws and failed by others with the ties holding (`ExchangeLaw.contingent`). They are determinations of the one exchange, not relations between otherwise independent items, and what follows from one follows of that exchange.

**Differentiation is kept.** The moments do not collapse into one another: requirement is a counterfactual of the law that no course fixes (`ExchangeLaw.requirement_beyond_course`), activity and standing come apart wherever a relatum is dormant (`ExchangeLaw.still_not_embodied`), and the losses, endings and exclusions the laws describe are losses within the one exchange, counted where they fall.

**What this does not reach.** (1) That every becoming has a law or relation of exchange whose readings these are: the representation commits to discrete steps and natural-number amounts, and which law holds is not derived ([chapter §8.1](THE-THEORY-OF-BECOMING.md#81-open-items-ranked), items 6 and 7). (2) The warrant of the readings: activity needing support is internal only under requirement read as necessary response; read as possible response it fails (`ExchangeRelation.free_unsupported`). The case for necessary response is that a requirement the exchange can go on without is no requirement of that exchange, an argument, not a proof. (3) Necessity in a sense beyond "holds by what its terms are, within the representation". (4) The determinations no World premise names (evaluation, significance, the direction); there the condition and C enter as premises, with their roles (chapter §6.4).
'''
once(FD, '''Its substantive correction is to locate the missing deduction in relational unity and differentiation at the whole scope, while preserving the explanatory work already earned for particular forms.
''', '''Its substantive correction is to locate the missing deduction in relational unity and differentiation at the whole scope, while preserving the explanatory work already earned for particular forms.
''' + FD91)
fdz = (ROOT / FDZ).read_text(encoding='utf-8')
FD91Z = f'''

<a id="91-从包容到关系的过渡论证"></a>
### 9.1 从包容到关系的过渡，论证

[AI 的论证，XL1，2026年10月22日；[研究第 {N} 节](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{ANCH})；英文见 [§9.1](BECOMING-FOUNDATION.md#91-the-passage-from-inclusion-to-relation-argued)]

本节留待证明的一步，是整体的各规定在同一展开中有其构成，而非已确立实例的汇集。对世界前提所称的规定，这一步现在可以论证，并说明其界限。世界（`World`）把立着、活跃、各关系项需要什么与需要多少、汲取什么，作为分别选定的字段；如此持有，联结它们的八个前提彼此独立（`World.independent`），整体便是各部分恰好满足者的汇集。另一种方式是从同一交换读出每个规定：活跃读作交换，汲取读作所取，需要读作交换不能缺少者（必然回应），关系项未说明者读作整体的其余。

**这里的关系是内在的**，指它凭其项之所是而成立。从同一交换读出时，四个联结是内在的：平衡与只有活跃者给出、取用，对每个算入其余的世界成立；活动需要支撑，对每个从交换关系读出的世界成立，而关系项在所需低于需要时仍交换的世界不是这样的世界（`World.ReadOffExchange.dependent`、`World.takingUnsupported_not_readOff`）。于是覆盖中取这些联结的每条中心规律，对每个从交换读出的世界成立（`Becoming.OverExchange`，{nF} 条，K3 检查）：它们说的是同一交换的诸环节彼此怎样相处。读法不决定的，是有哪一个交换：封闭（可行）、耗散、体现、有界传递与包围是律的状态（`ExchangeLaw.contingent`），是同一交换的规定，不是独立项之间的关系。各环节并不相互消融：需要是律的反事实，没有进程确定它；活跃与立着在休眠处分开；规律所述的损失、终结与排斥是同一交换之内的损失。

**它不及之处。** 每个生成／变化是否都有其读法如此的交换之律或关系（第 8.1 节第 6、7 项）；读法的根据，尤其是需要读作必然回应（读作可能回应时活动需要支撑不成立，`ExchangeRelation.free_unsupported`）；“在表示之内凭其项之所是而成立”之外的必然性；世界前提未称的规定（评价、意义、方向），那里条件与 C 作为前提进入。
'''
(ROOT / FDZ).write_text(fdz.rstrip('\n') + FD91Z, encoding='utf-8')

# --- the goal record -----------------------------------------------------------------------------------------------
goal = json.loads((ROOT / GOAL).read_text(encoding='utf-8'))
ns = goal['overview']['next_step']
old_en = "what remains is the spine's central laws stated over every law of exchange rather than over separately chosen premises."
assert ns['en'].count(old_en) == 1
ns['en'] = ns['en'].replace(old_en, f"the spine's central laws are stated over every relation of exchange rather than over separately chosen premises (`Becoming.OverExchange`, XL1: each of the {nF} central declarations taking a tying premise has its form over what is read off an exchange, what stays a hypothesis a state of the law; K3 checks the forms). The companion modules left are readings with laws of their own, kept by R32's criterion, so nothing formal remains of the first target's formal part beyond which law holds and the representation.")
old_ph = "The philosophical part: that the whole's determinations are internally related moments of one unfolding, not a collection of laws each holding of every represented world."
assert ns['en'].count(old_ph) == 1
ns['en'] = ns['en'].replace(old_ph, old_ph + " Argued for the determinations the World premises name (BECOMING-FOUNDATION §9.1); open: that every becoming has a law or relation of exchange of this kind, and the warrant of reading requirement as necessary response.")
old_zh = "尚待的是把脊柱的中心规律对每个交换之律陈述，而非对分别选定的前提陈述。"
assert ns['zh'].count(old_zh) == 1
ns['zh'] = ns['zh'].replace(old_zh, f"脊柱的中心规律已对每个交换关系陈述，而非对分别选定的前提陈述（`Becoming.OverExchange`，XL1：{nF} 条取联结前提的中心规律各有其在交换上的形式，仍为假设者是律的状态；K3 检查这些形式）。余下的伴随模块是有自身规律的读法，按 R32 的标准保留，所以形式部分除哪条律成立与表示之外不再有待。")
old_zhp = "哲学部分：整体的诸规定是同一展开中内在相关的环节，而非各自对每个被表示世界成立的一组规律。"
assert ns['zh'].count(old_zhp) == 1
ns['zh'] = ns['zh'].replace(old_zhp, old_zhp + "对世界前提所称的规定已有论证（BECOMING-FOUNDATION 第 9.1 节）；开放：每个生成／变化是否都有这样的交换之律或关系，以及把需要读作必然回应的根据。")
(ROOT / GOAL).write_text(json.dumps(goal, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')

# --- premises-that-are-states-of-the-law ---------------------------------------------------------------------------
p = RECORDS / 'premises-that-are-states-of-the-law.json'
r = json.loads(p.read_text(encoding='utf-8'))
r['next_delta'] = {
    'en': 'Local conditions on a law that give each state; an independent review. (The spine\'s laws that use these premises are stated over the laws of exchange: central-laws-over-every-exchange.)',
    'zh': '给出每个状态的律的局部条件；独立审查。（用到这些前提的脊柱规律已对交换之律陈述：central-laws-over-every-exchange。）'}
r['history'].append({
    'en': f'22 October 2026: next_delta\'s first item met by XL1 (central-laws-over-every-exchange, study section {N}); no statement changed.',
    'zh': f'2026年10月22日：next_delta 的第一项由 XL1 完成（central-laws-over-every-exchange，研究第 {N} 节）；陈述未变。'})
p.write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')

# --- the record ----------------------------------------------------------------------------------------------------
BOUNDS = ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional',
          'omission-not-refutation']
decl_list = sorted(names)
rec = {
    'schema_version': 2,
    'id': RID,
    'title': {'en': 'The central laws over every relation of exchange', 'zh': '中心规律对每个交换关系成立'},
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F01',
    'reviewed_at_utc': NOW,
    'statement': {
        'en': f'Each of the {nF} central laws taking balance, only active giving or taking, or activity needing support holds over what is read off an exchange, those premises discharged by the reading; what stays a hypothesis is a state of the law or the law\'s own.',
        'zh': f'取平衡、只有活跃者给出或取用、或活动需要支撑的 {nF} 条中心规律，都对从交换读出者成立，这些前提由读法卸去；仍为假设者是律的状态或律自身的假设。'},
    'laws': [
        {'en': 'Over every world with its rest counted: balance and the two activity premises hold by the reading, so every central law needing no more holds with no premise, and the rest theorem reads the census off the exchange where a named family closes each step; under balance the rest exchanges nothing and the world\'s relata are as they were.',
         'zh': '对每个算入其余的世界：平衡与两个活跃前提由读法成立，故只需它们的中心规律不加前提成立；在有指名的族封闭每一步之处，停息定理从交换读出普查；平衡时其余不交换任何东西，世界的关系项一如原样。',
         'declarations': sorted(['Becoming.World.withRest_acting', 'Becoming.World.withRest_taking',
                                 'Becoming.World.withRest_rest_idle', 'Becoming.World.withRest_some']
                                + [forms[c] for c in one])},
        {'en': 'Over every two worlds of one kind of relatum with their rests counted: the comparisons of two courses hold with balance discharged in both, under every law of exchange over the relata with the rest.',
         'zh': '对同一种关系项、各自算入其余的每两个世界：两段进程的比较在两者平衡都卸去时成立，在关系项连同其余上的每个交换之律下。',
         'declarations': sorted(['Becoming.World.withRest_present', 'Becoming.World.withRest_start'] + [forms[c] for c in two])},
        {'en': 'Over every world read off a relation of exchange, its flow a run along its standings and each requirement a necessary response of its exchange: activity needs support with its rest counted, so the central laws needing it hold with no premise. Every run of every relation and the course of every law are such worlds; a world whose relatum exchanges unsupported is not.',
         'zh': '对每个从交换关系读出的世界（其流是沿其立着的一段运行，每个需要都是其交换的必然回应）：算入其余时活动需要支撑，故需要它的中心规律不加前提成立。每个关系的每段运行与每个律的进程都是这样的世界；关系项不受支撑而交换的世界不是。',
         'declarations': sorted(['Becoming.World.ReadOffExchange', 'Becoming.World.ReadOffExchange.dependent',
                                 'Becoming.ExchangeRelation.Runs.readOffExchange', 'Becoming.ExchangeLaw.readWorld_readOffExchange',
                                 'Becoming.World.takingUnsupported', 'Becoming.World.takingUnsupported_not_readOff',
                                 'Becoming.World.ReadOffExchange.roles_dependent'] + [forms[c] for c in read])},
    ],
    'hypotheses': [
        {'en': 'No axiom and no premise beyond each law\'s own hypotheses and the states of the law it takes (dissipation, embodiment, bounded transmission, enclosure, feasibility, a census of what stands); the forms over a world read off a relation take that reading.',
         'zh': '除各律自身的假设与它所取的律的状态（耗散、体现、有界传递、包围、可行、立着者的普查）外，不加公理与前提；对从交换关系读出的世界的形式取这一读法。'}],
    'does_not_show': [
        {'en': 'That every becoming has a law or relation of exchange whose readings these are: discrete steps and natural-number amounts stay commitments of the representation.', 'zh': '每个生成／变化都有其读法如此的交换之律或关系：离散步与自然数量仍是表示的承诺。', 'kind': 'scope'},
        {'en': 'Which law of exchange holds, or whether it meets the states the laws take.', 'zh': '哪个交换之律成立，或它是否满足规律所取的状态。', 'kind': 'scope'},
        {'en': 'The laws over the world\'s own relata where closure fails: there the rest is a relatum the laws count, a giver or a feeder.', 'zh': '封闭不成立时，关于世界自身关系项的规律：那里其余是规律所计的关系项，一个给予者或供给者。', 'kind': 'scope'},
        {'en': 'The warrant of reading requirement as necessary response; read as possible response, activity needing support fails.', 'zh': '把需要读作必然回应的根据；读作可能回应时，活动需要支撑不成立。', 'kind': 'non-implication'},
    ],
    'counterexamples': [{'path': src(MOD), 'detail': {
        'en': 'World.takingUnsupported: a world whose relatum takes a unit from itself at every step while standing at nothing and requiring itself at need one is read off no relation of exchange (takingUnsupported_not_readOff).',
        'zh': 'World.takingUnsupported：关系项每步从自身取一个单位、立于零、以需要一要求自身的世界，不从任何交换关系读出（takingUnsupported_not_readOff）。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): the {n_decl} declarations of Becoming.{MOD}, {n_thm} of them theorems, have empty axiom reports; the checker verifies core purity. completion.py\'s K3 checks that each central declaration taking a tying premise has its form, whose proof uses it and whose binders take none of the four. Author review in study section {N}; not independently reviewed.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.{MOD} 的 {n_decl} 项声明（{n_thm} 项定理）公理报告为空；检查器并核对核心纯净。completion.py 的 K3 检查每条取联结前提的中心声明都有其形式，形式的证明用到它，绑定中不取四者之一。作者审查见研究第 {N} 节；未经独立审查。'},
    'next_delta': {
        'en': 'The laws over dense amounts and continuous time; local conditions on a law giving each state; an independent review.',
        'zh': '稠密量与连续时间下的规律；给出各状态的律的局部条件；独立审查。'},
    'correspondence': {
        'en': 'Chapter §8.1 item 1, the formal part of the first target as restated on 20 October 2026: every central law stated over every law, or relation, of exchange, each World premise a reading of the exchange or a state of the law. The classification of the premises is premises-that-are-states-of-the-law\'s; this record states the laws over it. The philosophical reading (BECOMING-FOUNDATION §9.1) is the AI\'s.',
        'zh': '第 8.1 节第 1 项，即 2026年10月20日重述的首要目标的形式部分：每条中心规律都对每个交换之律或关系陈述，每个世界前提是交换的读法或律的状态。前提的分类属于 premises-that-are-states-of-the-law；本记录在其上陈述规律。哲学读法（BECOMING-FOUNDATION 第 9.1 节）是 AI 的。'},
    'canonical_source': src(MOD),
    'aliases': ['the central laws over every relation of exchange', '中心规律对每个交换关系成立', 'laws over every law of exchange',
                'Becoming.World.ReadOffExchange', 'Becoming.World.ReadOffExchange.dependent'],
    'dependencies': [
        {'id': 'premises-read-off-the-exchange', 'relation': 'formal-reuse', 'detail': {
            'en': 'Reuses World.withRest, withRest_balanced, withRest_dependent_iff, withRest_exchanging_iff, Flow.readOff_acting, Flow.readOff_taking and ExchangeLaw.readWorld.',
            'zh': '复用 World.withRest、withRest_balanced、withRest_dependent_iff、withRest_exchanging_iff、Flow.readOff_acting、Flow.readOff_taking 与 ExchangeLaw.readWorld。'},
         'interface': {'output': {'en': 'Worlds read off an exchange with the rest counted and the ties holding.', 'zh': '算入其余、联结成立、从交换读出的世界。'},
                       'input': {'en': 'The worlds the central laws are instantiated at.', 'zh': '中心规律所实例化的世界。'}, 'conditions': {'en': 'None.', 'zh': '无。'}, 'evidence': src(MOD)}},
        {'id': 'requirement-over-open-exchanges', 'relation': 'formal-reuse', 'detail': {
            'en': 'Reuses ExchangeRelation, Runs, RespondsBelow, ExchangeLaw.relation, course_runs and relation_responds_iff.',
            'zh': '复用 ExchangeRelation、Runs、RespondsBelow、ExchangeLaw.relation、course_runs 与 relation_responds_iff。'},
         'interface': {'output': {'en': 'Requirement as necessary response over a relation of exchange.', 'zh': '交换关系上作为必然回应的需要。'},
                       'input': {'en': 'World.ReadOffExchange and its dependence.', 'zh': 'World.ReadOffExchange 及其依存。'}, 'conditions': {'en': 'None.', 'zh': '无。'}, 'evidence': src(MOD)}},
        {'id': 'premises-that-are-states-of-the-law', 'relation': 'formal-reuse', 'detail': {
            'en': 'What stays a hypothesis of the forms is a state of the law in its sense.', 'zh': '形式中仍为假设者，是其意义上的律的状态。'},
         'interface': {'output': {'en': 'The classification of the World premises.', 'zh': '世界前提的分类。'},
                       'input': {'en': 'The hypotheses the forms keep.', 'zh': '形式保留的假设。'}, 'conditions': {'en': 'None.', 'zh': '无。'}, 'evidence': src(MOD)}},
    ],
    'related': [
        {'id': 'theory-of-becoming-foundation', 'detail': {'en': 'The formal part of the first target, for the coverage of K1.', 'zh': '首要目标的形式部分，就 K1 的覆盖而言。'}},
        {'id': 'map-of-premises', 'detail': {'en': 'There the World premises are independent as separately chosen fields; here the laws under them hold of every world read off an exchange.', 'zh': '那里世界前提作为分别选定的字段彼此独立；这里其下的规律对每个从交换读出的世界成立。'}},
    ],
    'references': [{'path': src(MOD), 'role': 'proof', 'declarations': decl_list, 'sha256': sha(src(MOD))},
                   {'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': COV, 'role': 'integration', 'sha256': sha(COV)},
                   {'path': 'tools/research/completion.py', 'role': 'integration', 'sha256': sha('tools/research/completion.py')},
                   {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                   {'path': FD, 'role': 'statement', 'sha256': sha(FD)},
                   {'path': CH, 'role': 'statement', 'sha256': sha(CH)}],
    'proof_bindings': [{'source': src(MOD), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{MOD}',
                        'success_pointer': '/status', 'success_value': 'passed'}],
    'history': [{
        'en': f'22 October 2026: added (XL1), on chapter §8.1 item 1, the formal part of the first target; study section {N}.',
        'zh': f'2026年10月22日：新增（XL1），针对第 8.1 节第 1 项，首要目标的形式部分；研究第 {N} 节。'}],
}
for law in rec['laws']:
    for d in law['declarations']:
        assert d in names, d
assert len(rec['statement']['en']) <= 300, len(rec['statement']['en'])
path = RECORDS / f'{RID}.json'
assert not path.exists(), ('record exists', RID)
path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
print('landed texts', RID, 'section', N, n_thm, n_decl, 'forms', nF, n1, n2, nR)
