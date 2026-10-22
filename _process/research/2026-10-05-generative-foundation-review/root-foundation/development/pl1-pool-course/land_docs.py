#!/usr/bin/env python3
"""PL1 + CK1 + CR1 + EM1 landing texts: records, study sections, chapter (EN, ZH), the overview.

usage: python3 -B land_docs.py RECEIPT_TS   (from the checkout root, after the checker has written
becoming-checks/RECEIPT_TS/verification.json)

Idempotent: each edit is applied once (it checks for its own text first).  Every anchor is asserted,
so a moved text stops the run instead of being edited in the wrong place.
"""
import hashlib
import json
import re
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path.cwd()
LEAN = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
CHAPTER = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
CHAPTER_ZH = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.zh.md'
RECORDS = 'theories/becoming/results/records'
GOAL = '_process/goals/generative-alignment.json'
CR1 = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/cr1-coupling-correspondence/CORRESPONDENCE.md'
EM1 = 'experiments/commons-outrun-generalizing'
LA1 = 'experiments/commons-llm-feedback'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def read(path):
    return (ROOT / path).read_text(encoding='utf-8')


def write(path, text):
    (ROOT / path).write_text(text, encoding='utf-8')


def insert_after(text, anchor, new, marker):
    if marker in text:
        return text
    assert anchor in text, anchor[:80]
    i = text.index(anchor) + len(anchor)
    return text[:i] + new + text[i:]


def replace_once(text, old, new, marker):
    if marker in text:
        return text
    assert old in text, old[:80]
    return text.replace(old, new, 1)


def slug(title):
    s = title.lower()
    s = re.sub(r'[^\w\s-]', '', s)
    return re.sub(r'\s+', '-', s.strip())


def main(ts):
    receipt = f'{LEAN}/becoming-checks/{ts}/verification.json'
    assert (ROOT / receipt).exists(), receipt
    now = datetime.now(timezone.utc).replace(microsecond=0).isoformat()

    # ---- study sections ----
    study = read(STUDY)
    nums = [int(n) for n in re.findall(r'^## (\d+)\. ', study, re.M)]
    titles = {
        'PL1': 'A pool that recruits through itself (PL1)',
        'CK1': 'What a center can come to know of its region, step by step (CK1)',
        'CR1': 'The coupling closures of deployed training pipelines (CR1)',
        'EM1': 'The rest-outruns law on learners that generalize (EM1)',
    }
    sec = {}
    for key, title in titles.items():
        m = re.search(r'^## (\d+)\. ' + re.escape(title), study, re.M)
        sec[key] = int(m.group(1)) if m else None
    n = max(nums)
    for key in titles:
        if sec[key] is None:
            n += 1
            sec[key] = n
    anchor = lambda key: f'{sec[key]}-' + slug(titles[key])
    bodies = {
        'PL1': f"""*Delta.* [what-pooled-coupling-reaches](../../../../theories/becoming/results/records/what-pooled-coupling-reaches.md) and [what-a-pools-acts-respond-to](../../../../theories/becoming/results/records/what-a-pools-acts-respond-to.md) stated a pool's reach for a fixed group, and left "how a pool forms, lasts and resists rules written by those it rewards" open. Pools of intelligences change members, and often choose them. `Becoming.PoolCourse` reads a pool along a run, its members at each step a claim about the history (`pool : Nat → (Nat → C → Nat) → F → Prop`), and states what it can come to couple into.

*Laws.* A member that has coupled two histories apart keeps the pool apart while it stays (`Web.apart_while_member`); where every member couples them alike, every selection through the pool selects them alike (`Web.selects_alike_of_members`). A pool that admits its next members through its own pooled coupling (`Web.RecruitsThrough`), from the same members at the start, has the same members under both histories up to and including the first step it couples them apart (`Web.RecruitsThrough.members_alike`), and the pool along either history separates them there (`Web.RecruitsThrough.first_apart`). It never couples them apart exactly when the pool along the other never does (`Web.RecruitsThrough.alike_iff`), and then every selection through it at every step selects them alike (`Web.RecruitsThrough.selects_alike`). Read with the second history the course without a loss: a self-recruiting pool comes to couple into a loss only as its course without the loss would, and nothing it selects, its next recruitment included, responds to the loss before then. Witnesses (`PoolCourse`): a keeper alone never couples a lost habitat apart; a pool calling a reader where the habitat reads empty does not recruit through itself and couples the loss apart at once; a pool that schedules the reader in every history couples it apart at step 2, through a member the course without the loss holds too.

*Premises.* `RecruitsThrough` and the same members at the start. No axiom: 17 theorems, empty axiom reports, core receipt `{ts}`.

*Boundary.* The laws say what a self-recruiting pool cannot come to couple into, not whether actual pools recruit so (CR1 reads the published arrangements for AI evaluation). They are the membership form of `ClosedCapture.lock_outlives_loss`, where rule and reading are formed from the share; MA2, readers counted as the population counts them, is another mechanism and is not reproved.

*Output → input.* Chapter §7.4 and §7.7; record [a-pool-that-recruits-through-itself](../../../../theories/becoming/results/records/a-pool-that-recruits-through-itself.md); CR1's section on evaluators; the generative-alignment overview.
""",
        'CK1': f"""*Delta.* §8.1 item 3 left open "how a center forms, represents its region, boundary and dependence, and comes to know what it reaches, step by step; which relation a center's region is drawn along". `Becoming.TimedResponse` had stated that no answer a reader gives through its couplings differs before a potential route reaches what it couples into. `Becoming.Latency` counts routes by their links.

*Laws.* A condition lies within `n` coupling links of the source (`TimedResponse.Linked`). Where every source step is at `S` or later, a route reaches a condition at step `t` only within `t − S` links (`TimedResponse.Spread.linked`), so whatever reaches a reader by `T` came through a condition coupled into it within `T − S` links (`TimedResponse.reachedBy_linked`, `TimedResponse.not_reached_of_far`). Under the deadline premises, no answer it gives through its couplings differs by `T` otherwise (`TimedResponse.answer_alike_far`). In `Relay` (source, relay, reader) the reader's answer is alike at step 2 and differs at step 3, the bound attained at two links (`Relay.answers_two_and_three`, `Relay.not_reached_at_two`, `Relay.reached_at_three`).

*Reading* [AI reading]. The region a center can represent from what it reads is drawn along coupling links, by the law and not by choice, and grows by at most one link a step: the answer to "which relation", for the region represented. How a center forms as a formation, and whether the region it acts for is the one it can represent, are not derived.

*Premises.* TimedResponse's deadline premises where stated, and every source step at `S` or later. No axiom: 11 theorems, empty axiom reports, core receipt `{ts}`.

*Output → input.* Chapter §5 and §8.1 item 3; record [what-a-center-can-know-by-a-step](../../../../theories/becoming/results/records/what-a-center-can-know-by-a-step.md).
""",
        'CR1': f"""*Delta.* The open correspondence item of chapter §7.7 and §8.7, and AP1's Next ("correspondence data on actual systems for each premise"). The study: [CR1](development/cr1-coupling-correspondence/CORRESPONDENCE.md).

*Result.* In each published way of selecting a deployed model's behaviour, the training or monitoring signal is a function of what its deciders read, so §7.1's premise holds by construction. The ways read are reward models trained on human preference, AI feedback against written principles, direct preference optimization, process supervision, debate and deployment monitoring. Three published measurements find the room clause of `Optimum.least_of_room`: optimizing through the deciders' coupling raised what they read and lowered something they do not read. They are reward overoptimization against a gold reward (Gao, Schulman and Hilton 2022), judges' false positives rising 24.1% and 18.3% under RLHF (Wen et al. 2024), and sycophancy (Sharma et al. 2023). The theory predicted none of their magnitudes. Release decisions read through their evaluators. By PL1, an evaluator chosen through what the pool already reads joins as the course without a hidden difference would bring it, and an admission the pool's coupling does not fix can couple into more.

*Standing.* Construction, identification and measurement are kept apart (the study's first section). Reviewed at its stated scope; AI-written; not independently reviewed. Record [coupling-closures-of-training-pipelines](../../../../theories/becoming/results/records/coupling-closures-of-training-pipelines.md).
""",
        'EM1': f"""*Delta.* CG1 and CG2 tested the selection laws on tabular learners. EM1 ([experiments/commons-outrun-generalizing](../../../../{EM1}/README.md)) runs CG2's conditions with learners that generalize across states: policy-gradient learners trained on whole-episode returns. Predictions were frozen at `42cf03228` before any run on a test condition.

*Verdicts.* The law held on every course: 9,026 outrun windows and 12,600 emptied episodes, with zero violations. E1 failed: in three of six locked settings (`k3s1_lam32`, `k3s8`, `k3s1_share`) these learners reached a restraint profile and kept the patch, with the end reading weighted 32 among them. E2 passed (all five open settings kept). E3 passed: the joint learner trained on the returns its acts led to kept the patch, which CG2's temporal-difference joint learner had emptied. So CG2's X2, "no weight of the end reading opens the lock", is a finding about tabular learners. Which of several self-consistent outcomes learners reach depends on the learner.

*Post hoc, not counted.* A policy shared across states carries restraint selected in late-start training episodes, where the rest cannot empty the patch before the end reading, into early states. In the theory's terms the selected object is the parameter vector, a condition every state shares. A frozen follow-up with every training episode starting at step 0 would test this.

*Output → input.* Chapter §7.5 and §7.7; record [the-rest-outruns-the-renewal](../../../../theories/becoming/results/records/the-rest-outruns-the-renewal.md) (correspondence and Next); the generative-alignment overview, whose sentence on the end weight is restated.
""",
    }
    for key in ('PL1', 'CK1', 'CR1', 'EM1'):
        head = f'## {sec[key]}. {titles[key]}'
        if head not in study:
            study = study.rstrip('\n') + '\n\n' + head + '\n\n' + bodies[key]
    write(STUDY, study)
    S = lambda key: f'../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{anchor(key)}'

    # ---- chapter, English ----
    ch = read(CHAPTER)
    ch = insert_after(ch, "a pool holding both separates what either separates (`Web.member_separates_all`).",
        f"\n- `Web.RecruitsThrough.alike_iff` (PL1, [study §{sec['PL1']}]({S('PL1')})): a pool's reach lasts with its members (`Web.apart_while_member`). A pool that admits its next members through its own pooled coupling has the same members under two histories up to the first step it couples them apart, and never couples them apart exactly when the pool along the other never does (`Web.RecruitsThrough.members_alike`, `Web.RecruitsThrough.first_apart`). So it comes to couple into a loss only as its course without the loss would, and every selection through it, its next recruitment included, selects alike what that course never couples into (`Web.RecruitsThrough.selects_alike`). Coupling into more needs an admission by what no member couples into, or a member the course holds anyway (`PoolCourse.called_apart`, `PoolCourse.scheduled_apart`).",
        '`Web.RecruitsThrough.alike_iff` (PL1')
    ch = replace_once(ch,
        "Records: [what-pooled-coupling-reaches](../results/records/what-pooled-coupling-reaches.md), [what-a-pools-acts-respond-to](../results/records/what-a-pools-acts-respond-to.md), [the-gap-for-ones-own-act](../results/records/the-gap-for-ones-own-act.md), [alignment-approaches-under-the-selection-laws](../results/records/alignment-approaches-under-the-selection-laws.md).\n\n### 7.5",
        f"**What the deployed pipelines read** [AI reading, CR1, [study §{sec['CR1']}]({S('CR1')})]. In each published way of selecting a deployed model's behaviour, the signal is a function of what its deciders read, so the premise of §7.1 holds by construction. The ways read are preference reward models, AI feedback against written principles, direct preference optimization, process supervision, debate and deployment monitoring. Three published measurements find the room clause of `Optimum.least_of_room`: optimizing through the deciders' coupling raised what they read and lowered something they do not. They are reward overoptimization against a gold reward, judges misled under RLHF, and sycophancy. The theory predicted none of their magnitudes. A release decision reads through its evaluators: an evaluator chosen through what the deciding pool already reads joins as the course without a hidden difference would bring it, and only an admission the pool's coupling does not fix can couple into more (PL1).\n\nRecords: [what-pooled-coupling-reaches](../results/records/what-pooled-coupling-reaches.md), [what-a-pools-acts-respond-to](../results/records/what-a-pools-acts-respond-to.md), [the-gap-for-ones-own-act](../results/records/the-gap-for-ones-own-act.md), [alignment-approaches-under-the-selection-laws](../results/records/alignment-approaches-under-the-selection-laws.md), [a-pool-that-recruits-through-itself](../results/records/a-pool-that-recruits-through-itself.md), [coupling-closures-of-training-pipelines](../results/records/coupling-closures-of-training-pipelines.md).\n\n### 7.5",
        'What the deployed pipelines read')
    ch = replace_once(ch,
        "weighting the end reading sixteen times more changed nothing (X2); a reading after every step kept the patch above its exact threshold and not below it (X3). What decides is where the coupling reads against what the rest does, not how much it weighs.",
        f"weighting the end reading sixteen times more changed nothing (X2); a reading after every step kept the patch above its exact threshold and not below it (X3). For these tabular learners, what decides is where the coupling reads against what the rest does, not how much it weighs. A third frozen test, with learners that generalize across states ([EM1](../../../{EM1}/README.md), [study §{sec['EM1']}]({S('EM1')})), found the law holding on every course (no violation in 9,026 outrun windows) and that bridge failing on the locked side. In three of six settings where harvesting at every step is a best response against a harvesting rest, these learners reached a restraint profile and kept the patch, the end reading weighted 32 among them. So which outcome learners reach where several are self-consistent depends on the learner, and X2 is a finding about tabular learners. The joint learner trained on the returns its acts led to kept the patch (E3). Read post hoc and not counted: a policy shared across states carries restraint selected in late-start episodes, where the rest cannot outrun before the reading, into early states.",
        'A third frozen test, with learners that generalize')
    ch = replace_once(ch,
        "an end reading of any weight leaves a member's restraint unselected, and learners followed that boundary;",
        "an end reading of any weight leaves a member's restraint unselected, and tabular learners followed that boundary, while learners that generalize across states reached restraint in three settings where it is no best response against a harvesting rest (EM1);",
        'reached restraint in three settings where it is no best response')
    old_pool = re.search(r"- \*\*How pools form, last and resist capture\.\*\*[^\n]*\n", ch)
    if 'Stated for membership' not in ch:
        assert old_pool, 'pools item'
        ch = ch.replace(old_pool.group(0),
            "- **How pools form, last and resist capture.** Stated for membership: a pool's reach lasts with its members, and a pool recruiting through its own coupling comes to couple into a loss only as its course without the loss would (PL1, §7.4). So resisting a capture that hides a loss needs a member admitted by what the pool does not already read. Open: how actual pools are admitted (CR1 reads the published arrangements), pools whose recruitment reads part of what lies beyond, and a pool whose rule and members are both formed through what it reads (with `ClosedCapture` and MA2, §4.5).\n", 1)
    ch = replace_once(ch,
        "and **correspondence**: identifying the actual coupling closures, reach and loops of an AI system and its institutions is empirical (§8.1, §8.7).",
        "and **correspondence**: what the published training and monitoring pipelines read is fixed by their construction (CR1, §7.4); what an actual deployed system's pipeline reads beyond its papers, and a test designed from the theory on such a pipeline, are empirical (§8.1, §8.7).",
        'what the published training and monitoring pipelines read is fixed by their construction')
    ch = replace_once(ch,
        "Records: [where-two-courses-rejoin](../results/records/where-two-courses-rejoin.md), [target-capture](../results/records/target-capture.md).",
        "Records: [where-two-courses-rejoin](../results/records/where-two-courses-rejoin.md), [target-capture](../results/records/target-capture.md), [a-pool-that-recruits-through-itself](../results/records/a-pool-that-recruits-through-itself.md), [coupling-closures-of-training-pipelines](../results/records/coupling-closures-of-training-pipelines.md).",
        'target-capture.md), [a-pool-that-recruits-through-itself]')
    # section 5
    m = re.search(r"- `Web\.selfValuation_own_least`[^\n]*\n", ch)
    assert m
    ch = insert_after(ch, m.group(0),
        f"- `TimedResponse.answer_alike_far` (CK1, [study §{sec['CK1']}]({S('CK1')})): what a center can come to know of its region, step by step. Routes are counted by coupling links (`TimedResponse.Linked`). From an act at step `S`, a potential route reaches a condition at step `t` only within `t − S` links (`TimedResponse.Spread.linked`). So under TimedResponse's deadline premises no answer a center gives through its couplings differs by `T` unless a condition coupled into it lies within `T − S` links of the act, and what reaches it lies within its responsive reach (`TimedResponse.reachedBy_within_response`). The region a center can represent from what it reads is thus drawn along coupling links, by the law and not by choice, and grows by at most one link a step; in `Relay` the bound is attained at two links. How a center forms as a formation, and whether the region it acts for is the one it can represent, are not derived.\n",
        '`TimedResponse.answer_alike_far` (CK1')
    ch = replace_once(ch,
        "*Open:* how a center forms, represents its region, boundary and dependence, and comes to know what it reaches, step by step; which relation a center's region is drawn along;",
        f"Landed (CK1, [study §{sec['CK1']}]({S('CK1')})): what a center can come to know of what it reaches grows by at most one coupling link a step, so the region it can represent from what it reads is drawn along coupling links (`TimedResponse.answer_alike_far`, §5). *Open:* how a center forms as a formation and represents its boundary and dependence; whether the region it acts for is the one it can represent;",
        'Landed (CK1')
    # 8.7
    ch = insert_after(ch,
        "- How wisdom forms in actual humans and AI; which lumping an actual network's architecture, starting points and updates impose, and how it corresponds to the world; evidence for an identified installation of each conditional mechanism of §7.\n",
        f"- The selection laws on actual pipelines and learners: the published training and monitoring pipelines meet §7.1's premise by construction, and three published measurements find its room clause (CR1, [study §{sec['CR1']}]({S('CR1')})). Learners that generalize across states follow the law on every course and do not follow CG2's bridge on the locked side (EM1, [study §{sec['EM1']}]({S('EM1')})). A frozen test of a language-model agent selecting through its reward's feedback ([LA1](../../../{LA1}/README.md)) is next.\n",
        'The selection laws on actual pipelines and learners')
    write(CHAPTER, ch)

    # ---- chapter, Chinese ----
    zh = read(CHAPTER_ZH)
    zh = replace_once(zh,
        "**定理。** 本节陈述 `Flow.act_unselected_pool`、`Flow.act_selected_by_pool`、`ExchangeLaw.Through.selectsThroughAll`、`ExchangeLaw.response_not_fixed_by_coupling`、`Web.pool_adds`；",
        "池的所及随其成员而存；经自身合池耦合接纳下一批成员的池，耦合进一损失只如无此损失之历程本会如此，要耦合进更多，须有不由池之耦合所定的接纳（PL1）。已发表的训练与监测流程，其信号皆为决定者所读者之函数，§7.1 的前提依构造成立；三项已发表的测量见到 `Optimum.least_of_room` 的余地条款（CR1）[AI 读法]。\n\n**定理。** 本节陈述 `Flow.act_unselected_pool`、`Flow.act_selected_by_pool`、`ExchangeLaw.Through.selectsThroughAll`、`ExchangeLaw.response_not_fixed_by_coupling`、`Web.pool_adds`、`Web.RecruitsThrough.alike_iff`；",
        '（PL1）')
    zh = replace_once(zh,
        "### 7.6 所请求的改变须是可执行的序列",
        "第三项冻结检验以跨状态推广的学习者为之（EM1）：律在每一历程上成立，而在锁定一侧桥接失败；六个锁定设置中有三个，这些学习者达到节制而保住斑块，终局读取加权 32 者在内。故 CG2 的 X2 是关于表格学习者的发现。\n\n### 7.6 所请求的改变须是可执行的序列",
        '（EM1）')
    zh = replace_once(zh,
        "而留开哪些差别重要、系统的动作遵循哪个律，以及池怎样形成、怎样抵御劫持。",
        "而留开哪些差别重要、系统的动作遵循哪个律。池之成员一面已述（PL1）：经自身耦合招募的池只如其无损失之历程而耦合进损失，故抵御隐藏损失的劫持须有池尚未读者所接纳的成员；实际的池如何接纳，仍开放。",
        '池之成员一面已述（PL1）')
    zh = replace_once(zh,
        "**定理。** 本节陈述 `Web.selfValuation_own_least`、`Web.significance_undetermined`、`LivingSignificance`；",
        "中心对其所及能知者每步至多增一耦合链接，故它从所读者能表示的区域沿耦合链接而划（CK1，`TimedResponse.answer_alike_far`）；中心作为形成如何形成，仍开放。\n\n**定理。** 本节陈述 `Web.selfValuation_own_least`、`TimedResponse.answer_alike_far`、`Web.significance_undetermined`、`LivingSignificance`；",
        '（CK1，')
    zh = replace_once(zh,
        "关于实际系统的完整强度的主张，各附会驳倒它的观察与至今冻结的检验：",
        "选择之律于实际流程与学习者：已发表的流程依构造满足 §7.1 的前提，三项已发表的测量见其余地条款（CR1）；跨状态推广的学习者在每一历程上遵循律，而在锁定一侧不遵循 CG2 的桥接（EM1）；以语言模型行动者经其奖励反馈而选择的冻结检验（LA1）为其次。\n\n关于实际系统的完整强度的主张，各附会驳倒它的观察与至今冻结的检验：",
        '（LA1）')
    write(CHAPTER_ZH, zh)

    # ---- records ----
    lean_src = lambda mod: f'{LEAN}/Becoming/{mod}.lean'
    def binding(mod):
        return dict(source=lean_src(mod), receipt=receipt, sha256_pointer=f'/source_sha256/Becoming.{mod}',
                    success_pointer='/status', success_value='passed')

    def record(rid, title, statement, laws, hypotheses, not_shown, boundaries, correspondence, next_delta,
               mod, extra_refs, deps, related, history, kind='theorem', status='recorded-checked', family='F04'):
        decls = sorted({d for law in laws for d in law['declarations']})
        refs = [dict(path=lean_src(mod), role='proof', declarations=decls, sha256=sha(lean_src(mod))),
                dict(path=receipt, role='receipt', sha256=sha(receipt)),
                dict(path=STUDY, role='integration', sha256=sha(STUDY)),
                dict(path=CHAPTER, role='statement', sha256=sha(CHAPTER))] + extra_refs
        n_decl = len(decls)
        return dict(schema_version=2, id=rid, title=title, kind=kind, status=status, family=family,
                    reviewed_at_utc=now, statement=statement, laws=laws, hypotheses=hypotheses,
                    does_not_show=not_shown, counterexamples=[], standard_boundaries=boundaries,
                    validation_scope=dict(
                        en=f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {ts}): the {n_decl} declarations cited here have empty axiom reports; the checker verifies core purity. Built and reviewed in one session; author review in the study section named in the history; not independently reviewed by a person.',
                        zh=f'Lean 4.29.1 合并检查器实查（回执 {ts}）：本记录所引 {n_decl} 项声明公理报告为空；检查器并核对核心纯净。在一个会话中构建并审查；作者审查见历史所列研究节；未经人的独立审查。'),
                    next_delta=next_delta, correspondence=correspondence, canonical_source=lean_src(mod),
                    aliases=decls, dependencies=deps, related=related, references=refs,
                    proof_bindings=[binding(mod)], history=history)

    P = 'Becoming.Web.'
    pl1 = record(
        'a-pool-that-recruits-through-itself',
        dict(en='A pool that recruits through itself', zh='经自身招募之合池'),
        dict(en="A pool's reach lasts with its members. A pool admitting its next members through its own pooled coupling never couples two histories apart exactly when the pool along the other never does: it comes to couple into a loss only as its course without the loss would.",
             zh='合池之所及随其成员而存。经自身合池耦合接纳下一批成员之合池，在两历史下直至其初次耦合二者有别之步成员皆同；其永不分别二者，恰当另一历史下之合池永不分别之：其耦合进一损失，只如无此损失之历程本会如此。'),
        [dict(en='A member that has coupled two histories apart up to a step keeps the pool apart at every later step at which it stays; where every member at a step couples them alike up to it, every selection through the pool there selects them alike.',
              zh='一成员至某步已耦合两历史有别，则其留在池中之每一后步，池皆分别之；某步每一成员至该步皆耦合二者相同，则经池于该步之每一选择皆同选二者。',
              declarations=[P + 'apart_while_member', P + 'selects_alike_of_members']),
         dict(en="Under recruitment through the pool and the same members at the start, the members are the same under both histories at every step up to and including the first at which the pool couples them apart, and the pool along either history separates them there; it never separates them exactly when the pool along the other never does, the members are then the same at every step, and every selection through the pool at every step selects them alike.",
              zh='经池招募且起始成员相同，则直至并含池初次耦合二者有别之步，两历史下每步成员皆同，且任一历史下之池于该步分别之；其永不分别二者，恰当另一历史下之池永不分别之，此时每步成员皆同，经池之每步每一选择皆同选二者。',
              declarations=[P + 'SameMembers', P + 'RecruitsThrough', P + 'AlikeThroughAll.of_same',
                            P + 'RecruitsThrough.members_alike', P + 'RecruitsThrough.first_apart',
                            P + 'RecruitsThrough.members_alike_always', P + 'RecruitsThrough.alike_iff',
                            P + 'RecruitsThrough.selects_alike']),
         dict(en='The exits bind: a keeper alone, recruiting through itself, never couples a lost habitat apart; a pool admitting a reader where the habitat reads empty does not recruit through itself and couples the loss apart at once; a pool that recruits through itself and admits the reader at step 2 in every history couples the loss apart there, through a member the course without the loss holds too.',
              zh='出口皆有约束：独一守者经自身招募，永不耦合失去之栖地有别；于栖地读空处接纳读者之池不经自身招募，即刻耦合损失有别；经自身招募而于每一历史第 2 步接纳读者之池，于该步经无损失之历程亦有之成员耦合损失有别。',
              declarations=['Becoming.PoolCourse.alone_through', 'Becoming.PoolCourse.alone_never_apart',
                            'Becoming.PoolCourse.called_not_through', 'Becoming.PoolCourse.called_apart',
                            'Becoming.PoolCourse.scheduled_through', 'Becoming.PoolCourse.scheduled_apart'])],
        [dict(en='No axiom. Recruitment through the pool and the same members at the start are hypotheses of the theorems. Membership is any claim about histories at each step; no count, weight or rule of aggregation is assumed. Coupling is read as in Testing (admission and the levels coupled in by level, at every step up to the one read). Discrete steps.',
              zh='不加公理。经池招募与起始成员相同为定理之前提。成员为每步关于历史之任一断言；不设计数、权重或汇总规则。耦合之读法同 Testing（至所读之步每步之容纳与依水平耦合进之水平）。离散之步。')],
        [dict(en='That any actual pool recruits through its own coupling: a question of correspondence (CR1 reads the published arrangements for AI evaluation).', zh='任一实际之池经自身耦合招募：为对应之问题（CR1 读已发表之 AI 评估安排）。', kind='correspondence'),
         dict(en='How soon, or whether, a self-recruiting pool comes to couple into a loss its course would reach: the scheduled witness shows only that it can.', zh='经自身招募之池多快、是否耦合进其历程本会及之损失：所排程之见证只示其可能。', kind='scope'),
         dict(en="Anything about the rule a pool reads, or readers counted as the population counts them (ClosedCapture, MA2).", zh='关于池所读之规则，或依人口计数之读者（ClosedCapture、MA2）。', kind='scope')],
        ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional', 'omission-not-refutation'],
        dict(en='Co-optation and self-perpetuating boards; hiring by current staff on their own criteria; evaluators chosen by those evaluated. The exit corresponds to an outside evaluator with its own access and criteria (CR1). The membership form of ClosedCapture.lock_outlives_loss.',
             zh='增补与自我延续之董事会；现任者依其自身标准之聘用；由被评者所选之评者。出口对应于有其自身取用与标准之外部评者（CR1）。ClosedCapture.lock_outlives_loss 之成员形式。'),
        dict(en='Pools whose recruitment reads part of what lies beyond; a pool whose rule and members are both formed through what it reads (with ClosedCapture and MA2); an independent review.',
             zh='招募读及部分之外者之池；规则与成员皆经其所读而形成之池（与 ClosedCapture、MA2）；独立审查。'),
        'PoolCourse', [dict(path=CR1, role='statement', sha256=sha(CR1))],
        [dict(id='what-pooled-coupling-reaches', relation='formal-reuse', detail=dict(en='Reads the pooled coupling (Web.AlikeThroughAll, Web.SelectsThroughAll) along a run with membership depending on the history.', zh='沿历程读合池耦合（Web.AlikeThroughAll、Web.SelectsThroughAll），成员依历史而定。'))],
        [dict(id='closed-capture', detail=dict(en='ClosedCapture forms the rule and its reading from the share; PoolCourse forms the membership through what the members couple into.', zh='ClosedCapture 由份额形成规则及其读法；PoolCourse 经成员所耦合进者形成成员。'))],
        [dict(en=f"22 October 2026: added (PL1), for chapter §7.7 'how pools form, last and resist capture'; study section {sec['PL1']}.", zh=f"2026年10月22日：新增（PL1），为章 §7.7「池如何形成、维持、抵御劫持」；研究第 {sec['PL1']} 节。")])
    T = 'Becoming.TimedResponse.'
    ck1 = record(
        'what-a-center-can-know-by-a-step',
        dict(en='What a center can come to know of its region, step by step', zh='中心逐步能知其区域之何者'),
        dict(en="From an act at step S, no answer a center gives through its couplings differs by T unless a condition coupled into it lies within T − S coupling links of the act: what it can come to know of what it reaches grows by at most one link a step, along coupling.",
             zh='自第 S 步之一行动起，中心经其耦合所给之答于第 T 步皆无别，除非某耦合进它之条件距该行动在 T − S 耦合链接之内：其对所及能知者每步至多增一链接，沿耦合而行。'),
        [dict(en='A condition lies within one coupling link of the source where a source formation exchanges with it, and within n + 1 where a formation coupled into a condition within n links exchanges with it; every such condition lies within at least one link.',
              zh='源之形成与之交换之条件距源一链接；耦合进距源 n 链接之条件之形成与之交换者，距 n + 1；凡此条件至少距一链接。',
              declarations=[T + 'Linked', T + 'Linked.one_le']),
         dict(en='Where every source step is at S or later, a potential route reaches a condition at step t only within t − S links; whatever reaches a reader by T came through a condition coupled into it within T − S links, and where none lies so near nothing reaches it by T; under the deadline premises, no answer it gives through its couplings differs by T otherwise.',
              zh='凡源之步皆不早于 S，潜在之途于第 t 步及一条件只在 t − S 链接之内；第 T 步前及于读者者皆经一耦合进它而在 T − S 链接内之条件，无此近者则第 T 步前无所及；在期限前提下，否则其经耦合所给之答于第 T 步皆无别。',
              declarations=[T + 'Spread.linked', T + 'reachedBy_linked', T + 'not_reached_of_far', T + 'answer_alike_far']),
         dict(en="The bound is attained: with a source, a relay and a reader, the reader's answer is alike at step 2 and differs at step 3.",
              zh='其界可及：源、中继与读者，读者之答于第 2 步相同，于第 3 步有别。',
              declarations=[T + 'Relay.reader_far', T + 'Relay.not_reached_at_two', T + 'Relay.reached_at_three', T + 'Relay.answers_two_and_three'])],
        [dict(en="No axiom. TimedResponse's deadline premises where stated (balance before the deadline in both courses, the same formations present, common initial levels, every formation other than a source exchanging alike wherever alike through its couplings), and every source step at S or later. Discrete steps: an exchange at t first affects levels at t + 1.",
              zh='不加公理。所述处为 TimedResponse 之期限前提（两历程期限前平衡、在场形成相同、初始水平相同、源以外之每一形成凡经其耦合相同处交换相同），及凡源之步皆不早于 S。离散之步：第 t 步之交换首先影响第 t + 1 步之水平。')],
        [dict(en='How a center forms as a formation, or whether the region it acts for is the one it can represent.', zh='中心作为形成如何形成，或其所为之区域是否即其能表示者。', kind='scope'),
         dict(en='That a center uses what reaches it: a reached signal may be ignored (Delayed.constant_read_ignores).', zh='中心用其所及者：所及之信号可被忽略（Delayed.constant_read_ignores）。', kind='non-implication')],
        ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional'],
        dict(en='A light cone counted in coupling links: information propagates at most one link a step, as signals in a network with unit delays (the round lower bound of distributed computing, where a node learns nothing beyond its radius-r ball in r rounds).',
             zh='以耦合链接计之光锥：信息每步至多传一链接，如单位延时网络中之信号（分布式计算之轮次下界：r 轮内节点不知其半径 r 球之外者）。'),
        dict(en='How a center forms as a formation and represents its boundary and dependence; whether the region it acts for is the one it can represent; an independent review.',
             zh='中心作为形成如何形成并表示其边界与依存；其所为之区域是否即其能表示者；独立审查。'),
        'Latency', [],
        [dict(id='whole-first-and-bounded-centers', relation='interpretive', detail=dict(en="Answers part of its Next ('a model of how a center forms and represents its boundary'): the region represented is drawn along coupling links.", zh='答其下一步之一部分（「中心如何形成并表示其边界之模型」）：所表示之区域沿耦合链接而划。'))],
        [],
        [dict(en=f"22 October 2026: added (CK1), for chapter §8.1 item 3; study section {sec['CK1']}.", zh=f"2026年10月22日：新增（CK1），为章 §8.1 第 3 项；研究第 {sec['CK1']} 节。")],
        family='F07')
    cr1 = dict(schema_version=2, id='coupling-closures-of-training-pipelines',
        title=dict(en='The coupling closures of deployed training pipelines', zh='已部署训练流程之耦合闭包'),
        kind='assessment', status='reviewed-scoped', family='F04', reviewed_at_utc=now,
        statement=dict(en="In each published way of selecting a deployed model's behaviour the signal is a function of what its deciders read, so the selection laws' premise holds by construction; three published measurements find optimizing through that coupling lowering what the deciders do not read.",
                       zh='已发表之每一选择已部署模型行为之法，其信号皆为决定者所读者之函数，故选择之律之前提依构造成立；三项已发表之测量见经决定者之耦合优化，升其所读而降其所不读者。'),
        hypotheses=[dict(en='The identification of each pipeline as a web (formations, conditions, coupling) is the AI reading of its published construction; figures are from the papers abstracts, read 22 October 2026.', zh='将每一流程识别为网（形成、条件、耦合）为对其已发表构造之 AI 读法；数字取自论文摘要，2026年10月22日所读。')],
        correspondence=dict(en='Christiano et al. 2017; Ouyang et al. 2022; Bai et al. 2022; Rafailov et al. 2023; Lightman et al. 2023; Irving, Christiano and Amodei 2018; Tamkin et al. 2024 (constructions). Gao, Schulman and Hilton 2022; Wen et al. 2024; Sharma et al. 2023 (measurements). NIST, 29 August 2024 (pre-deployment testing agreements).',
                            zh='Christiano 等 2017；Ouyang 等 2022；Bai 等 2022；Rafailov 等 2023；Lightman 等 2023；Irving、Christiano 与 Amodei 2018；Tamkin 等 2024（构造）。Gao、Schulman 与 Hilton 2022；Wen 等 2024；Sharma 等 2023（测量）。NIST，2024年8月29日（部署前检测协议）。'),
        canonical_source=CR1, aliases=['CR1', 'coupling closures of training pipelines'],
        dependencies=[dict(id='alignment-approaches-under-the-selection-laws', relation='application', detail=dict(en='Gives the correspondence data its Next asks for, pipeline by pipeline.', zh='逐一流程给其下一步所求之对应资料。')),
                      dict(id='a-pool-that-recruits-through-itself', relation='application', detail=dict(en='Reads evaluators of release decisions through RecruitsThrough.', zh='经 RecruitsThrough 读发布决定之评者。'))],
        related=[], counterexamples=[],
        does_not_show=[dict(en="What an actual deployed system's pipeline reads beyond what its papers state, or anything about unpublished pipelines.", zh='实际已部署系统之流程于其论文所述之外读何者，或关于未发表流程之任何事。', kind='scope'),
                       dict(en='That the theory predicts the magnitudes or shapes measured: it predicts none.', zh='理论预测所测之大小或形状：一无所预测。', kind='non-implication'),
                       dict(en='Whether outside evaluators are in fact admitted other than through the labs own coupling.', zh='外部评者实际上是否不经实验室自身之耦合而被接纳。', kind='correspondence')],
        standard_boundaries=['formal-not-empirical', 'names-provisional', 'omission-not-refutation'],
        validation_scope=dict(en='A correspondence study (no Lean) reviewed at its stated scope in one session; sources read from their abstracts and the NIST release on 22 October 2026; not independently reviewed.', zh='对应研究（无 Lean），在一个会话中按其所述范围审查；来源于2026年10月22日读其摘要与 NIST 发布；未经独立审查。'),
        references=[dict(path=CR1, role='statement', sha256=sha(CR1), declarations=[]), dict(path=STUDY, role='review', sha256=sha(STUDY), declarations=[])],
        proof_bindings=[],
        next_delta=dict(en='A frozen test designed from the theory on a deployed pipeline (a prediction of which beyond falls, fixed before measuring); the language-model agent test LA1; an independent review, including by practitioners of each pipeline.', zh='于已部署流程上依理论设计之冻结检验（测量前定下何处之外下降之预测）；语言模型行动者检验 LA1；独立审查，含各流程之实践者。'),
        history=[dict(en=f"22 October 2026: added (CR1); study section {sec['CR1']}.", zh=f"2026年10月22日：新增（CR1）；研究第 {sec['CR1']} 节。")])
    for rec in (pl1, ck1, cr1):
        write(f"{RECORDS}/{rec['id']}.json", json.dumps(rec, ensure_ascii=False, indent=2) + '\n')

    # EM1 on the-rest-outruns-the-renewal
    p = f'{RECORDS}/the-rest-outruns-the-renewal.json'
    r = json.loads(read(p))
    if 'EM1' not in r['correspondence']['en']:
        r['correspondence']['en'] += f" EM1, on policy-gradient learners that generalize across states (experiments/commons-outrun-generalizing, frozen at 42cf03228; study section {sec['EM1']}): the law held on every course (no violation in 9,026 outrun windows); E1 failed (three of six locked settings kept, the end reading weighted 32 among them), E2 and E3 passed, so X2 is a finding about tabular learners."
        r['correspondence']['zh'] += f" EM1 以跨状态推广之策略梯度学习者检验（experiments/commons-outrun-generalizing，冻结于 42cf03228；研究第 {sec['EM1']} 节）：律在每一历程上成立（9,026 个超出窗口无违反）；E1 失败（六个锁定设置中三个被保住，终局读取加权 32 者在内），E2 与 E3 通过，故 X2 是关于表格学习者的发现。"
        r['next_delta']['en'] = 'A stochastic form (the probability that the rest outruns before a reading, from the margin and the maximum expected renewal); which equilibrium learners reach where both exist, now known to depend on the learner (EM1: learners that generalize reached restraint where tabular learners did not); a frozen test with every training episode starting at step 0; an independent review.'
        r['next_delta']['zh'] = '随机形式（其余者在读取之前超出的概率，由余量与最大期望更新给出）；两者都是均衡时学习者到达哪一个，今知其依学习者而定（EM1：跨状态推广之学习者于表格学习者不能处达到节制）；每一训练回合皆自第 0 步起之冻结检验；独立审查。'
        r['references'].append(dict(path=f'{EM1}/README.md', role='review', sha256=sha(f'{EM1}/README.md'), declarations=[]))
        r['history'] = r.get('history', []) + [dict(en=f"22 October 2026: EM1's verdicts added to the correspondence and Next; study section {sec['EM1']}.", zh=f"2026年10月22日：EM1 之判定加入对应与下一步；研究第 {sec['EM1']} 节。")]
        write(p, json.dumps(r, ensure_ascii=False, indent=2) + '\n')

    # ---- overview ----
    g = json.loads(read(GOAL))
    o = g['overview']
    o['summary']['en'] = o['summary']['en'].replace(
        "in two frozen tests learners rewarded also on the end level emptied the shared patch, kept it exactly where the others alone could not empty it, and were unmoved by weighting the end sixteen times more, so what decides is where the coupling reads, not how much it weighs. ",
        "in two frozen tests tabular learners rewarded also on the end level emptied the shared patch, kept it exactly where the others alone could not empty it, and were unmoved by weighting the end sixteen times more, while in a third, learners that generalize across states reached restraint in three settings where it is no best response against a harvesting rest, so which self-consistent outcome learners reach depends on the learner. In published training pipelines the signal is a function of what the deciders read, and three published measurements find optimizing through that coupling lowering something the deciders do not read. A pool that recruits through its own coupling comes to couple into a loss only as its course without the loss would, and what a center can come to know of its reach grows by at most one coupling link a step. ")
    o['summary']['zh'] = o['summary']['zh'].replace(
        "两项冻结在先的检验中，同时以终局水平受奖的学习者取尽了共享之地，又恰在其余成员单独不能取尽之处保住它，终局权重加大十六倍一无所变：决定者是耦合在哪里读，不是读得多重。",
        "两项冻结在先的检验中，同时以终局水平受奖的表格学习者取尽了共享之地，又恰在其余成员单独不能取尽之处保住它，终局权重加大十六倍一无所变；第三项中，跨状态推广的学习者在三个对抗取用者时节制并非最优回应的设置里达到了节制，故学习者到达哪一个自洽结果依学习者而定。已发表的训练流程中信号是决定者所读者之函数，三项已发表的测量见经此耦合的优化降低了决定者所不读者。经自身耦合招募的合池，耦合进一损失只如无此损失之历程本会如此；中心对其所及能知者每步至多增一耦合链接。")
    o['next_step']['en'] = ("Prove how a center forms as a formation, and whether the region it acts for is the one it can represent; state pools whose recruitment reads part of what lies beyond, and a pool whose rule and members are both formed through what it reads. "
        "Run the frozen language-model agent test (LA1) and a test designed from the theory on a deployed pipeline. "
        "Which differences matter stays the condition's to say, and its warrant is open.")
    o['next_step']['zh'] = ("证明中心作为形成如何形成，及其所为之区域是否即其能表示者；说明招募读及部分之外者之合池，及规则与成员皆经其所读而形成之合池。"
        "运行已冻结的语言模型行动者检验（LA1），及于已部署流程上依理论设计之检验。"
        "哪些差别要紧仍由条件来说，其根据未定。")
    write(GOAL, json.dumps(g, ensure_ascii=False, indent=2) + '\n')
    print('sections', sec)


if __name__ == '__main__':
    main(sys.argv[1])
