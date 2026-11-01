#!/usr/bin/env python3
"""P58: the decidability inventory of the Becoming core, read by Lean and written as a bilingual page:
python3 -B DECIDABILITY-INVENTORY.py

A periphery tool: `DECIDABILITY-INVENTORY.lean` imports Lean's own library, which the core never does. The core's
compiled modules are restored from the checker's shared cache (`check_becoming.py`'s keys; a module not there is
compiled, nothing is stored), then the Lean file writes one row per binder of a core declaration whose type is a
decidability family (`Decidable`, `DecidableEq`, `DecidablePred`, or a definition unfolding to one under binders), a
decided proposition (`p ∨ ¬ p`, such as the core's `Decided p`, read at default transparency) or an excluded middle
(the same for every proposition or predicate a binder ranges over), with whether the statement depends on it, whether the proof uses it and which
decidability-taking definitions the statement mentions; a row per declaration whose result is one (decidedness proved);
and a row per theorem whose statement uses a decidability-taking definition with no such binder (decidedness supplied by
a proved instance). The page `DECIDABILITY-INVENTORY.md` is written next to this file and names the consolidated receipt
whose checked sources the core's current bytes match; it refuses to run where they do not match."""
import collections
import importlib.util
import json
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
B = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
OUT = HERE / 'DECIDABILITY-INVENTORY.md'
sys.path.insert(0, str(B))
sys.path.insert(0, str(B.parent))
spec = importlib.util.spec_from_file_location('check_becoming_inventory', B / 'check_becoming.py')
cb = importlib.util.module_from_spec(spec)
spec.loader.exec_module(cb)

receipt = json.loads((B / 'becoming-verification.json').read_text())
assert receipt['status'] == 'passed', 'the receipt has not passed'
index = cb.module_index()
order = cb.closure(index, ['Becoming'])
sources = {name: index[name][0].read_bytes() for name in order}
stale = [n for n in order if cb.audit_support.digest(sources[n]) != receipt['source_sha256'].get(n)]
assert not stale, ('the core differs from the receipt; run the checker first', stale)
RUN = receipt['utc']
binary = Path.home() / '.elan/toolchains/leanprover--lean4---v4.29.1/bin/lean'
context = [cb.audit_support.TOOLCHAIN, cb.audit_support.digest(binary.read_bytes())]
keys = cb.module_keys(context, sources, order)
lean = [str(Path.home() / '.elan/bin/lean'), '+' + cb.audit_support.TOOLCHAIN]

compiled, restored = [], 0
with tempfile.TemporaryDirectory(prefix='decidability-inventory-') as scratch:
    work = Path(scratch)
    for name, data in sources.items():
        target = work / cb.source_file(name)
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(data)
    for name in order:
        olean = cb.source_file(name)[:-5] + '.olean'
        if cb.reuse(keys[name], [work / olean]):
            restored += 1
            continue
        p = subprocess.run(lean + ['-o', olean, cb.source_file(name)], cwd=work,
                           env={**os.environ, 'LEAN_PATH': str(work)}, text=True,
                           stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=3600)
        if p.returncode != 0 or re.search(r'\b(?:error|warning):', p.stdout):
            sys.exit(f'compiling {name} failed:\n{p.stdout[-6000:]}')
        compiled.append(name)
    (work / 'Inventory.lean').write_bytes((HERE / 'DECIDABILITY-INVENTORY.lean').read_bytes())
    rows_path = work / 'inventory.tsv'
    p = subprocess.run(lean + ['Inventory.lean'], cwd=work,
                       env={**os.environ, 'LEAN_PATH': str(work), 'P58_OUT': str(rows_path)}, text=True,
                       stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=3600)
    if p.returncode != 0 or re.search(r'\b(?:error|warning):', p.stdout):
        sys.exit(f'the inventory failed:\n{p.stdout[-6000:]}')
    print(p.stdout.strip())
    ROWS = rows_path.read_text()
print(f'restored {restored} modules from the cache, compiled {len(compiled)}')

# Where a form with no decision procedure, or none at all, exists: the theorem name (without `Becoming.`) maps to it.
FORMS = {
    'Web.arising_of_ceasing_listing': '`Web.arising_of_ceasing`（给定普查；此处还用 `listOnce` 造普查 / a supplied '
                                      'census; here `listOnce` also constructs it, P77）',
    'Web.inheritsAt_of_split': '`Web.inheritsAt_not_not`（不判定时继承不能被否证 / inheritance is unrefuted without '
                               'the decision, P84）',
    'held_over_stretch': '`Counts.over_stretch`（无前提 / no premise）',
    'marks_within': '`Counts.le_length`（无前提 / no premise）',
    'keep_pace': '`CountsAcross.keep_pace`（无前提 / no premise）',
    'Listed.across': '`Counts.listed_across`（无前提 / no premise）',
    'Listed.across_at': '`Counts.listed_across`（无前提 / no premise）',
    'Listed.over_stretch': '`Counts.listed_over_stretch`（无前提 / no premise）',
    'Listed.over_stretch_on': '`Counts.listed_over_stretch`（无前提 / no premise）',
    'coming_recurs_iff': '`Recurs.ceasing_not_stopping`、`Recurs.coming_not_stopping`（无前提 / no premise）；'
                         '`coming_recurs_iff_decided`（从某步起已定 / decided from some step on）',
    'Web.arising_recurs_iff': '同上 / as for `coming_recurs_iff`',
    'Web.unceasing_iff': '`Web.unceasing_iff_decided`（从某步起已定 / decided from some step on）',
    'World.arising_iff_ceasing': '`World.ceasing_not_stopping`、`World.arising_not_stopping`（无前提 / no premise）；'
                                 '`World.arising_iff_ceasing_decided`（从某步起已定 / decided from some step on）',
    'coming_of_ceasing_covered': '`Covers.not_not_coming_from`、`Covers.ceasing_not_recurring`（无前提 / no premise, P48）',
    'Covers.coming_from_of_ceasing': '`Covers.not_not_coming_from`（无前提 / no premise, P48）',
    'persists': '`stays_failing`（不成立的持续，不判定 / failing persists, no decision）；`persists_of_em` 示其需要 / '
                'shows the need',
    'comes_after': '`comes_after_unrefuted`（不判定，那一步不能被否证 / no decision, the step unrefuted）',
    'Listed.few_of_quiet': '`Listed.few_of_stop_unrefuted`（不判定 / no decision, P58）',
    'World.few_active': '`Listed.few_of_stop_unrefuted`、`World.rest_few`（不判定 / no decision, P58）',
    'Flow.Enclosed.around': '`Flow.Enclosed.around_not_not`（不判定 / no decision）',
    'Flow.Enclosed.aroundStanding': '`Flow.Enclosed.aroundStanding_not_not`（不判定 / no decision）',
    'Flow.Balances.comparison_within_response_of_decidable': '`Flow.Balances.comparison_within_response`（覆盖不被否证在回应所及之内者，不判定 / covering what is not refuted to be within the reach, no decision, P65）',
    'Law.none_drawn_lossless': '`Law.none_drawn_merges_nothing`（不判定 / no decision, P67）',
    'Law.lossless_iff_none_drawn': '`Law.Lossless.not_drawn`、`Law.none_drawn_merges_nothing`（不判定 / no decision, P67）',
    'Web.scores_alike_iff': '`Web.selects_alike_iff`（选择而非分数，不判定 / selections rather than scores, no decision, P64）',
    'Learning.claim_refuted_on_one': '`Learning.no_record_fixes_next`（无前提：主张不在两者上都对 / no premise: the claim is '
                                     'not right on both, P73）',
    'Learning.determines_lumped_iff': '`Learning.lumped_determines`（无前提的一个方向 / one direction, no premise, P73）',
    'Learnable.refuted_on_one': '`Learnable.claim_not_right_on_both`（无前提：主张不在两者上都对 / no premise: the '
                                'claim is not right on both）',
    'Learnable.learnable_iff': '`Learnable.agree_of_rests_both`（必要一侧，对每个学习者，不判定 / the necessary side, of '
                               'every learner, no decision）',
    'Learnable.still_learnable_iff_lumped': '`Learnable.still_lumped_of_rests`（必要一侧，不判定 / the necessary side, '
                                            'no decision）',
    'alike_of_sensitive_agree': '`ExchangeLaw.Nonanticipating.through_all`（经识一切，不判定 / through registering everything, no decision, P80）',
    'ExchangeLaw.Nonanticipating.through_of_observed': '`ExchangeLaw.Nonanticipating.through_all`（不判定 / no decision, P80）；逆向 `ExchangeLaw.Through.registers_of_sensitive`（不判定 / the converse, no decision）',
    'ExchangeLaw.Nonanticipating.through_sensitive': '`ExchangeLaw.Nonanticipating.through_all`（不判定 / no decision, P80）；逆向 `ExchangeLaw.Through.registers_of_sensitive`（不判定 / the converse, no decision）',
    'comparison_through_sensitivity': '`comparison_of_courses`（经律所经的识，不判定 / through a registration the law reads through, no decision, P80）',
    # 2026-10-15, P83c; the forms with no premise from P83d
    'Law.sameFuture_iff_classes': '`Law.sameFuture_iff_within`（N − 1，无前提，判定位置 / no premise, positions '
                                  'decided）；`Law.sameFuture_classes_unrefuted`（不判定，不被否证 / no decision, refuted by '
                                  'nothing）；`Law.sameFuture_iff_below`（2N − 1，无前提 / no premise）',
    'Identification.sameAhead_iff_classes': '`Identification.sameAhead_iff_within`（N − 1，无前提，判定位置 / no premise, '
                                            'positions decided）；`Identification.sameAhead_iff_below`（2N − 1，无前提 / no premise）',
    # 2026-10-15, P113 the least registration with any number of conditions (Becoming.Sensitivity)
    'alike_of_sensitive_agree_within': '`ExchangeLaw.ReadsFinitely.nonanticipating` 与 `ExchangeLaw.Nonanticipating.through_all`（经识一切，不判定 / through registering everything, no decision, P113）；逆向 `ExchangeLaw.Through.registers_of_sensitive`（不判定 / the converse, no decision）',
    'ExchangeLaw.ReadsFinitely.through_of_observed': '`ExchangeLaw.ReadsFinitely.nonanticipating` 与 `ExchangeLaw.Nonanticipating.through_all`（经识一切，不判定 / through registering everything, no decision, P113）；逆向 `ExchangeLaw.Through.registers_of_sensitive`（不判定 / the converse, no decision）',
    'ExchangeLaw.ReadsFinitely.through_sensitive': '`ExchangeLaw.ReadsFinitely.nonanticipating` 与 `ExchangeLaw.Nonanticipating.through_all`（经识一切，不判定 / through registering everything, no decision, P113）；逆向 `ExchangeLaw.Through.registers_of_sensitive`（不判定 / the converse, no decision）',
    'ExchangeLaw.ReadsFinitely.least_registration': '`ExchangeLaw.ReadsFinitely.nonanticipating` 与 `ExchangeLaw.Nonanticipating.through_all`（经识一切，不判定 / through registering everything, no decision, P113）；逆向 `ExchangeLaw.Through.registers_of_sensitive`（不判定 / the converse, no decision）',
    'ExchangeLaw.Nonanticipating.through_sensitive_of_every': '`ExchangeLaw.ReadsFinitely.nonanticipating` 与 `ExchangeLaw.Nonanticipating.through_all`（经识一切，不判定 / through registering everything, no decision, P113）；逆向 `ExchangeLaw.Through.registers_of_sensitive`（不判定 / the converse, no decision）',
    'comparison_through_sensitivity_of_readsFinitely': '`comparison_of_courses`（经律所经的识，不判定 / through a registration the law reads through, no decision, P113）',
    # 2026-10-16, P116 identification where runs part (Becoming.Parting)
    'Parting.unparted_iff': '`Parting.unparted_iff` 的正向与 `Parting.not_right_on_both`（不判定 / the forward direction and the parting law, no decision, P116）',
    'Parting.free_open': '`Parting.free_parts_after` 与 `Parting.not_right_on_both`（无前提：不在两个运行上都对 / no premise: not right on both runs, P116）',
}

# Why a statement depends on decidedness: the decidability-taking definitions it mentions (Lean's `ment` column).
COUNTING_DEFS = {'mark', 'comings', 'ceasings', 'World.CensusMarksHold', 'Web.decideForms', 'Web.decideDissolves',
                 'instDecidableComesToBe', 'instDecidableCeasesToBe', 'Web.instDecidableArises',
                 'Web.instDecidableCeases', 'Web.instDecidableArisesFrom', 'Web.instDecidableCeasesFrom'}
CONSTRUCTIONS = {
    'Flow.sample': 'coarse', 'World.sample': 'coarse', 'Flow.unionPresent': 'coarse', 'gate': 'coarse',
    'gateBy': 'coarse', 'Tower.web': 'coarse', 'Tower.flow': 'coarse', 'Tower.reads': 'coarse',
    'Tower.refine': 'coarse', 'Web.raise': 'raise', 'Web.redirect': 'redirect', 'keep': 'keep', 'insertNew': 'once',
    'Learning.learner': 'refute', 'Learning.index': 'refute', 'Learning.swapTo': 'other',
    'Identification.knowing': 'refute', 'Identification.firstFit': 'first',
    'listOnce': 'once', 'keepFresh': 'once',
    'adjoin': 'once', 'mixIn': 'mix',
    'transpose': 'swap', 'Reidentify.exchangeAfter': 'swap', 'Footprinted.inList': 'member',
    # 2026-10-14, general-laws batches 1-4 (classified at the batch-4 landing)
    **{n: 'same' for n in [
        'Copying.countOf', 'Copying.remove', 'Copying.removeAll', 'Copying.Supplies', 'Copying.tick', 'Copying.steps',
        'Copying.batch', 'Copying.readStep', 'Copying.readTick', 'Copying.readSteps', 'Copying.exchange',
        'Copying.inspect', 'Copying.scanSites', 'Copying.defects', 'Copying.pairDraw', 'Copying.unlikeFrom',
        'Retrodiction.changes', 'Segmentation.departures', 'Segmentation.transitions', 'Segmentation.bond']},
    'Contacts.spot': 'indicate', 'Web.requiredLevel': 'indicate', 'Frame.classCount': 'count',
    'Frame.lostOf': 'keep', 'Identification.withBound': 'first', 'Lasting.hitTime': 'first',
    'Viability.guardedStep': 'guard', 'Viability.guardedHistory': 'guard', 'ite': 'split',
    # 2026-10-15, integration I3a (classified at the I3a landing)
    'Readout.pick': 'indicate', 'dirac': 'same',
    # 2026-10-15, P109 where a move is formed (Becoming.Coupling): the policy read off a finite stretch compares
    # configurations
    'policyUpto': 'same',
    # 2026-10-15, P83f: the learner by the least bound
    'Identification.leastFit': 'first', 'Identification.leastBound': 'first',
    # 2026-10-15, integration I3d: the judge of a listed family answers with the first listed member of each reduced
    # value
    'Readout.firstJudge': 'first',
    # 2026-10-15, P113 the least registration with any number of conditions (Becoming.Sensitivity): the tail law
    # exchanges the indicator of whether levels vanish from some condition on, given its decision
    'vanishIndicator': 'indicate', 'tailLaw': 'indicate',
    # 2026-10-15, P114 the apart laws read on the shared base (Becoming.Courses): the release law of copies from one
    # shared pool and inspection as a process take the copy's moves, which compare tokens
    'Courses.release': 'same', 'Courses.inspection': 'same',
    # 2026-10-16, P115 how much difference arrives (Becoming.Propagation): one history mixed into another at
    # listed levels, each a step with a condition, as mixIn mixes condition by condition
    'mixCells': 'mix',
    # 2026-10-16, P119 the open proofs: the learner given the world reads the configurations reached under the record,
    # deciding steps and telling registered values apart; a course's multiplicity in a list compares courses
    **{n: 'reach' for n in ['Parting.candidates', 'Parting.live', 'Parting.firstLive', 'Parting.worldLearner']},
    'Situations.occ': 'same',
    # integration I4b (2026-10-16): a selection through a model of the options exchanges two options' entries
    **{n: 'swap' for n in ['Relabel.swap', 'Relabel.Equivariant', 'Relabel.EquivariantValue',
                           'Relabel.EquivariantChoice']},
    # 2026-10-16, P126 what a law of the whole and no part takes (Becoming.Tail): whether levels vanish
    # from a condition on, or some level from it on is above zero, decided by a rule, the indicator of
    # never vanishing and its law
    **{n: 'indicate' for n in ['vanishesFrom', 'raisedFrom', 'neverIndicator', 'neverLaw']},
    # 2026-10-16, P127 where a run goes on (Becoming.Onward): the test of each enumerated move, true where
    # the step is taken and its target is in the family
    'Onward.decidedTest': 'indicate',
}
MENT_REASON = {
    'count': '计数：计数存在恰当所计数者已定（`counts_iff_decided`）/ counts: a count exists exactly where what it counts '
             'is decided (`counts_iff_decided`)',
    'coarse': '较粗的读法：粗步内每个关系项只列一次，需分辨关系项的相同 / a coarser reading: each relatum listed once '
              'within a coarse step, which tells relata apart',
    'raise': '抬高一个条件：需分辨条件的相同 / one condition raised: tells conditions apart',
    'redirect': '在不被支持之步移开依存：支持已定 / dependence moved at unsupported steps: support decided',
    'keep': '按规定保留的列表：对其成员已定 / a list kept by a determination: decided of its members',
    'refute': '按否证学习：判定主张是否被否证，以保留假设或选出记录所支持的假设，需分辨值的相同 / learning by refutation: '
              'decides whether claims are refuted, to retain a hypothesis or select one borne out by the record, which '
              'tells values apart',
    'first': '选出首个符合者：依次判定列表成员是否满足规定 / first fitting member: decides the condition on each '
             'listed member in order',
    'other': '另一个值：取与给定值不同的值，需分辨值的相同 / another value: a value other than a given one, which tells '
             'values apart',
    'once': '不重复的列表：成员关系已定 / a list without repetition: membership decided',
    'mix': '逐个条件换入另一段历史：需分辨条件的相同 / another history mixed in condition by condition: tells '
           'conditions apart',
    'swap': '交换两个值：需分辨输入是否为其中任一值 / exchanging two values: decides whether the input is either '
            'of the exchanged values',
    'member': '列表成员的布尔判定：需逐项分辨值的相同 / boolean list membership: tells values apart at each '
              'listed member',
    'same': '分辨记号或值的相同：计数、取出或比较需要分辨两者是否相同 / tells tokens or values apart: counting, '
            'taking out or comparing them tells whether two are the same',
    'indicate': '指示：在已定命题成立处取一个值，不成立处取另一个 / an indicator: one value where a decided '
                'proposition holds, another where it fails',
    'split': '按情形取值：陈述用 `if … then … else`，其条件须已定 / a value by cases: the statement uses '
             '`if … then … else`, whose condition must be decided',
    'guard': '守护之步：每步判定守护是否成立，不成立处停止 / a guarded step: decides the guard at each step and stops '
             'where it fails',
    'reach': '可达：判定步是否可走，并分辨所识的值 / reached: decides whether steps are admissible and tells '
             'registered values apart',
}
LABEL = {
    'count': '计数 / counts', 'coarse': '较粗的读法 / coarser reading', 'raise': '抬高一个条件 / one condition raised',
    'redirect': '移开依存 / dependence moved', 'keep': '保留的列表 / a kept list',
    'once': '不重复的列表 / a list without repetition', 'refute': '按否证学习 / learning by refutation',
    'other': '另一个值 / another value', 'first': '首个符合者 / first fitting member', 'find': '找出 / finds', 'build': '造出列表 / builds a list',
    'same': '分辨相同 / tells same from different', 'split': '分情形 / splits on a case',
    'indicate': '造出指示 / builds an indicator', 'mix': '逐个条件换入 / mixed in condition by condition',
    'swap': '交换两个值 / exchanging two values', 'member': '列表成员判定 / list membership',
    'guard': '守护之步 / a guarded step', 'reach': '可达 / reached',
}
# Why a proof uses decidedness its statement does not mention. Every such theorem is classified here (asserted).
PROOF_REASON = {
    'find': '找出一步或一个成员：陈述断言其存在，不给已定时它只是不能被否证 / finds a step or a member: the statement '
            'asserts one exists, which without decidedness is only not refuted',
    'build': '造出列表：普查或不重复的列表由已定的成员造出 / builds a list: a census or a list without repetition, from '
             'decided members',
    'same': '分辨相同：证明按两个条件、关系项、值或输入是否相同、或条件是否在家族中分情形 / tells same from different: '
            'the proof splits on whether two conditions, relata, values or inputs are the same, or a condition is in a '
            'family',
    'split': '按规定分情形：证明分别用规定成立与不成立的情形 / splits on a determination: the proof uses both '
             'its holding and failing cases',
    'indicate': '造出指示：证明以已定命题的标记（成立为一、不成立为零）作为一个数，例如一个分数 / builds an indicator: the '
                'proof uses the mark of a decided proposition (one where it holds, zero where it fails) as a number, such '
                'as a score',
    'reach': '可达：证明以已定的步与所识的值造出被给予世界的学习者 / reached: the proof builds the learner given the '
             'world from decided steps and registered values',
}
PROOF_KIND = {
    **{n: 'find' for n in [
        'Web.arising_of_ceasing_listing', 'Web.persisting_census',
        'Web.arising_recurs_iff', 'Web.unceasing_iff', 'Web.unceasing_iff_covering', 'coming_recurs_iff',
        'World.arising_iff_ceasing_of_decidable', 'Flow.More.unceasingFrom', 'Flow.More.unceasing_reidentified',
        'Flow.More.unceasing_reidentified_covering', 'Web.Census.arisingFrom_of_ceasingFrom',
        'Web.Census.arisingFrom_of_ceasingFrom_from', 'Web.Census.ceasingFrom_of_arisingFrom',
        'Web.Census.ceasingFrom_of_arisingFrom_from', 'Web.arisesFrom_of_more', 'Web.unceasingFrom_of_growth',
        'Covers.coming_from_of_ceasing', 'Covers.within', 'coming_of_ceasing_covered', 'Listed.few_of_quiet',
        'World.CountedBy.arising_iff_ceasing', 'World.CountedWithin.arising_iff_ceasing',
        'World.Finite.arising_iff_ceasing', 'World.arising_of_ceasing', 'World.few_active', 'comes_after',
        'Flow.More.unceasing', 'Flow.More.unceasing_covering', 'Listed.ceasing_of_coming', 'Listed.ceasing_of_returning',
        'Listed.coming_iff_ceasing', 'Listed.coming_of_ceasing', 'Web.DependenceCensus.forming_iff_dissolving',
        'Web.DependenceCensus.forming_of_dissolving', 'Web.arises_of_more', 'Web.arising_of_ceasing',
        'Web.ceasing_of_arising', 'Web.unceasing_iff_bounded', 'Web.unceasing_of_growth', 'came_between',
        'came_between_from', 'search', 'Web.sample_arises', 'Web.sample_ceases', 'Web.sample_ceasing',
        'Web.sample_unceasing', 'arises_within', 'ceases_within', 'World.arising_iff_ceasing',
        'World.arising_iff_ceasing_covering', 'ceasing_step', 'Frame.claims_recur_iff',
        'Learning.determines_lumped_iff', 'Learnable.learnable_iff', 'Learnable.learnable_of_lumped',
        'Learnable.still_learnable_iff_lumped']},
    **{n: 'build' for n in [
        'Flow.Enclosed.around', 'Flow.Enclosed.aroundStanding', 'World.Finite.countedWithin', 'World.Finite.counted',
        'World.counted_of_ever', 'Flow.sample_ceasesToStand_iff', 'Flow.sample_changes_iff',
        'Flow.sample_comesToStand_iff']},
    **{n: 'same' for n in [
        'World.fixed_iff', 'World.arises_fixed_iff', 'World.ceases_fixed_iff',
        'Footprinted.least_exists_iff', 'Footprinted.decidesIdle_iff',
        'Identification.bounded_induction', 'Identification.fits_of_unrefuted',
        'Identification.unrefuted_persists',
        'Diagonal.alike_of_complete', 'Diagonal.complete_iff_alike',
        'Learning.claim_refuted_on_one', 'Learning.eq_of_not_refuted', 'Learning.every_free',
        'Learning.every_determines_nothing', 'Learnable.refuted_on_one',
        'Flow.fed_from_beyond', 'Flow.fed_from_beyond_from', 'Flow.fed_of_not_inward', 'Flow.inward_iff_not_fed',
        'Flow.inward_of_not_fed', 'Flow.rising_fed_from_beyond', 'Flow.rising_fed_from_beyond_from',
        'Web.generation_fed_from_beyond', 'forces_iff_noSplit', 'Flow.exchangeFollows_of_policy',
        'Flow.policy_keeps_difference', 'Flow.policy_uses_after_failure', 'Flow.boundary_crossed',
        'Flow.region_not_a_cut', 'Flow.subthreshold_alike', 'Flow.subthreshold_alike_always', 'Web.alike_of_threshold',
        'Web.tail_unrefuted', 'Flow.Balances.comparison_within_response_of_decidable',
        'Law.none_drawn_lossless', 'Law.lossless_iff_none_drawn',
        'alike_of_sensitive_agree', 'ExchangeLaw.Nonanticipating.through_of_observed', 'ExchangeLaw.Nonanticipating.through_sensitive', 'comparison_through_sensitivity']},
    **{n: 'split' for n in ['Web.inheritsAt_of_split', 'Flow.transmitsWithin_iff_split', 'persists', 'Flow.Balances.adds_iff_exceeds_of_decidable',
                            'Valuation.significant_iff_reached']},
    **{n: 'indicate' for n in ['Web.scores_alike_iff']},
    # 2026-10-14, general-laws batches 1-4 (classified at the batch-4 landing)
    **{n: 'same' for n in [
        'Contacts.selections_survive_iff', 'Contacts.trace_keeps_of_retains', 'Contacts.added_gains',
        'Contacts.blind_misses', 'Contacts.through_data_iff', 'Contacts.survive_data_iff', 'Contacts.answers_iff',
        'Contacts.through_at_iff', 'Contacts.retired_loses', 'Contacts.mem_or_not', 'Contacts.keeps_iff_retains',
        'Contacts.keeps_data_iff', 'CrossSituational.candidates_eq_iff', 'CrossSituational.resolves_iff',
        'CrossSituational.resolves_explained_iff', 'CrossSituational.reads_every_iff',
        'Retrodiction.fits_or_separated', 'Retrodiction.reading_right_iff', 'Retrodiction.look_right_iff',
        'Frame.strictLossMatch_iff_length_of_alike', 'Gated.change_located']},
    **{n: 'find' for n in [
        'Lasting.reaches_of_not_lasts', 'Lasting.reaches_iff_not_lasts', 'Lasting.reaches_of_histories',
        'Lasting.reaches_iff_histories', 'Frame.exists_fresh']},
    'Lasting.orbit_reaches_iff_variant': 'indicate',
    'TimedResponse.different_answers_require_reached': 'split',
    # 2026-10-15, P83c: refinement stops within its classes; Moore's bound with values decided
    **{n: 'split' for n in ['Decided.exists_within', 'Refining.grow', 'Law.AgreeTo.decided']},
    **{n: 'find' for n in ['Refining.steady_or_grown', 'Refining.steady_within']},
    **{n: 'same' for n in ['Law.sameFuture_iff_classes', 'Identification.sameAhead_iff_classes']},
    # 2026-10-15, P83e: a frame whose moves carry the registration is finite and decided
    'Law.labelled_finite': 'same',
    # 2026-10-14, `Decided` binders read at default transparency (a decided proposition, not excluded middle)
    **{n: 'split' for n in [
        'Decided.and', 'Decided.not', 'Decided.imp', 'Decided.iff', 'Decided.of_not_not', 'Decided.exists_mem',
        'Decided.exists_listed', 'Decided.exists_below', 'Decided.exists_of_listed', 'Decided.forall_in',
        'Decided.forall_of_listed', 'forth_decided', 'OutcomesListed.forth_decided', 'OutcomesListed.matched_decided',
        'Counts.over_stretch_decided']},
    **{n: 'find' for n in [
        'Decided.exists_not_in', 'Decided.exists_not_of_listed', 'stops_decreasing', 'drops_somewhere',
        'EitherThroughout.list', 'unmatched_of_not_forth', 'OutcomesListed.unmatched', 'BranchingTest.apart_from_listed']},
    **{n: 'build' for n in [
        'listsOnce_of_decided', 'listsOnceBy_of_decided', 'of_listsOnce', 'Flow.standing_lowers_decided',
        'Chains.outcomes', 'Chains.outcomesListed']},
    # 2026-10-15, integration I3a (classified at the I3a landing)
    **{n: 'find' for n in [
        'Readout.commonWitness_or_covered', 'Readout.no_common_report_iff', 'Readout.no_common_report_envelopes_iff']},
    'every_weighting_iff': 'indicate',
    # 2026-10-16, P129 (R18 item 41): LLPO beside WLPO and LPO
    **{n: 'split' for n in ['LLPO.FirstAt.decided', 'LLPO.Interleave.decided']},
    'LLPO.FirstAt.of_holds': 'find', 'LLPO.decidable': 'indicate',
    # 2026-10-14, the relation-first re-founding (Becoming.Novelty): finitely many steps checked, a failing one found
    'upto_or_fails': 'find',
    # 2026-10-15, integration I3b: decided tests pick the side of a choice, or list where a guard lets through
    **{n: 'find' for n in ['Recipe.holds_after', 'Frame.holds_byRecipes', 'Frame.byRecipes_translates']},
    'Recipe.outcomes': 'build',
    # 2026-10-15, P109 where a move is formed (Becoming.Coupling): the policy on a finite stretch is built by comparing
    # configurations; where none exists, a configuration recurring with the move varied is found
    'lumped_upto_iff': 'same', 'no_policy_upto_iff': 'find', 'throughout_or_fails': 'find',
    # 2026-10-15, integration I3d: a judge of a listed family exists where the observable is lumped, found from the first
    # listed members
    'Readout.judges_iff_lumpedOn': 'find',
    # 2026-10-15, integration I3e: undominated members of a listed menu; the pass along the list finds the member and
    # the member bettering one lacking the determination, and the determination is read off its refuted failure
    **{n: 'find' for n in ['exists_undominated', 'bettered_of_undominated_has', 'undominated_has_iff']},
    **{n: 'split' for n in ['Decided.weakly', 'undominated_has']},
    # 2026-10-15, P113 the least registration with any number of conditions (Becoming.Sensitivity): one history is
    # mixed into another condition by condition, as in Becoming.Counterfactual; the decision of vanishing gives LPO
    # by both its cases
    **{n: 'same' for n in [
        'alike_of_sensitive_agree_within', 'ExchangeLaw.ReadsFinitely.through_of_observed',
        'ExchangeLaw.ReadsFinitely.through_sensitive', 'ExchangeLaw.ReadsFinitely.least_registration',
        'ExchangeLaw.Nonanticipating.through_sensitive_of_every', 'comparison_through_sensitivity_of_readsFinitely',
        'alike_of_insensitiveAt_within', 'ExchangeLaw.ReadsFinitely.alike_of_insensitive']},
    'lpo_of_vanish_decided': 'split',
    # 2026-10-15, P114 the apart laws read on the shared base (Becoming.Courses): each is proved by the law it reads on
    # the base and is classified as that law is
    **{n: 'same' for n in [
        'Courses.run_resolves_iff', 'Courses.run_resolves_explained_iff', 'Courses.course_resolves_every_iff',
        'Courses.runs_reading_right_iff', 'Courses.runs_look_right_iff']},
    **{n: 'indicate' for n in ['Courses.claims_every_weighting_iff', 'Courses.course_reaches_iff_variant']},
    **{n: 'find' for n in [
        'Courses.extension_frontier_exists', 'Courses.extension_frontier_has_iff', 'Courses.run_judges_iff']},
    # 2026-10-16, P116 identification where runs part (Becoming.Parting): the proofs split on whether two registered
    # values, or a claim and a value, are the same
    'Parting.unparted_iff': 'same', 'Parting.free_open': 'same',
    # 2026-10-16, P115 how much difference arrives (Becoming.Propagation): the strengths add up by mixing the
    # other history in level by level, and the carrying law splits on whether a level is the one that differs
    **{n: 'same' for n in [
        'ExchangeLaw.exchangeGap_le_strengths', 'ExchangeLaw.exchangeGap_le_strengths_listed',
        'ExchangeLaw.exchangeGap_le_shares', 'ExchangeLaw.insensitiveAt_iff_strength_zero',
        'ExchangeLaw.sensitive_iff_strength', 'gap_le_carried', 'ExchangeLaw.carrying_respondsWithin',
        'most_difference_arrives', 'levels_alike_of_not_conveyed']},
    # integration I4b (2026-10-16): the origin law where each gate is decided
    **{n: 'split' for n in ['Gated.origin_of_decides']},
    # integration I4b (2026-10-16): lasting some course where the process branches finitely
    **{n: 'split' for n in ['Lasting.list_throughout_not_not']},
    **{n: 'build' for n in ['Lasting.TwoChains.branching']},
    # 2026-10-16, P112 when readings in context glue, for parity (Becoming.Gluing): elimination splits on whether a
    # claim is the one being eliminated
    **{n: 'same' for n in [
        'ParityConstraint.met_or_contradicts', 'ParitySystem.global_or_contradicts', 'ParitySystem.noGlobal_iff',
        'ParitySystem.glues_iff']},
    # 2026-10-16, P119 the open proofs (Becoming.Parting): where runs part only before a step, the proofs split on
    # whether two registered values are the same; some learner is right exactly where none part, the learner given the
    # world being built from decided steps and values
    **{n: 'same' for n in ['Parting.unparted_at_of_late', 'Parting.late_statesBelow']},
    'Parting.some_right_iff': 'reach',
    # integration I4b (2026-10-16): at most one option holds an entry alone, told by whether two options are the same
    **{n: 'same' for n in ['Relabel.alone_single']},
    # 2026-10-16, P118 how a carried difference grows (Becoming.Loops): the gap bounds of Propagation,
    # gap_le_carried and most_difference_arrives, read the equality of conditions in their proofs
    **{n: 'same' for n in ['most_difference_within', 'gap_le_polynomial', 'gap_polynomial_iff_no_loop']},
    # 2026-10-16, P120 what a cut loses (Becoming.Remainder): the equivalence for every law reads the
    # equality of conditions in its proof, through most_difference_arrives
    'gap_within_order_iff': 'same',
    # 2026-10-16, P123 how often couplings act (Becoming.Frequency): the rate for every law reads the
    # equality of conditions in its proof, through gap_le_carried
    'gap_le_count': 'same',
    # 2026-10-16, P126 what a law of the whole and no part takes (Becoming.Tail): a rule gives the
    # principle by both its cases
    **{n: 'split' for n in ['WLPO.of_rule', 'LPO.of_rule']},
    # 2026-10-16, P130 the frontier and the apart modules on the base: each instance reads its law's
    # decidedness through the law it restates (Learnable's search; Gluing's elimination; Propagation's,
    # Loops', Remainder's and Frequency's equality of conditions)
    **{n: 'find' for n in ['LearnableRuns.learnable_iff', 'LearnableRuns.still_learnable_iff_lumped']},
    **{n: 'same' for n in [
        'ParitySystem.freeFrame_iff', 'ParitySystem.world_free_iff', 'TwoActs.gap_le_carried',
        'TwoActs.gap_le_carried_read', 'TwoActs.gap_le_count', 'TwoActs.gap_le_polynomial',
        'TwoActs.gap_le_polynomial_before', 'TwoActs.gap_le_polynomial_from', 'carrying_twoActs',
        'gap_polynomial_iff_no_loop_worlds', 'gap_within_order_iff_worlds', 'most_difference_courses_worlds',
        'most_difference_within_worlds', 'most_difference_worlds', 'runaway_worlds', 'worlds_iff_flows']},
}
# Proved to need decidedness where asked of every world: the boundary theorems.
BOUNDARY = ['World.law_iff_em', 'World.law_decides', 'World.lpo_of_finite_ends', 'Listed.lpo_of_few',
            'Web.lpo_of_ending', 'ChangeBound.lpo_of_ends', 'alike_decided_iff_em', 'alike_of_sameBranchingTests_iff_em',
            'alike_of_sameBranchingTests_decided_steps_iff_em', 'alike_of_sameBranchingTests_outcomes_iff',
            # integrations I3a and I3b (added 2026-10-15; I3a's two were omitted at its landing by oversight)
            'matchesParts_of_compact_iff_em', 'jointAlike_of_sameJointTests_iff_em', 'Recipe.holds_after_iff_em',
            # integration I3e (added 2026-10-15): weak excluded middle for undominated members, excluded middle for
            # what every undominated member has
            'exists_undominated_iff_weakly', 'undominated_has_iff_em',
            # integration I4b (2026-10-16): with the gate a proposition, the origin law is double-negation
            # elimination
            'Gated.origin_of_propositions_iff',
            # integration I4b (2026-10-16): asked of every process, refutability of a reading made of prefix
            # tests is Markov's principle
            'refutable_passes_iff_markov',
            # integration I4b (2026-10-16): asked of every finitely branching process, an unbounded successor is
            # EitherThroughout
            'Lasting.step_iff_either']

rows = [l.rstrip('\n').split('\t') for l in ROWS.splitlines() if l.strip()]
theorems = collections.OrderedDict()
results, supplied, defs = [], [], collections.OrderedDict()
for mod, kind, name, pos, k, ty, stmt, proof, ment in rows:
    short = name.removeprefix('Becoming.')
    if pos == 'RESULT':
        results.append((mod, kind, short, k))
    elif pos == 'NONE':
        supplied.append((mod, short, ment))
    elif kind == 'theorem':
        theorems.setdefault((mod, short), []).append((k, ty, stmt == 'true', proof == 'true', ment))
    else:
        defs.setdefault((mod, short), []).append((k, ty, stmt == 'true', proof == 'true'))

# Statements naming Lean's own `if … then … else` (its condition decided) and no core definition (2026-10-14;
# `Situations.mul_indicator` 2026-10-16, P117).
ITE_STATEMENTS = ['Copying.ite_cases', 'Situations.mul_indicator']
for key in [key for key in theorems if key[1] in ITE_STATEMENTS]:
    theorems[key] = [(k, ty, s, p, ment or 'ite') for k, ty, s, p, ment in theorems[key]]

counting, proof_only, unused, em = [], [], [], []
for (mod, short), bs in sorted(theorems.items()):
    if all(k == 'excluded-middle' for k, *_ in bs):
        em.append((mod, short))
    elif any(s for _, _, s, _, _ in bs):
        counting.append((mod, short, bs))
    elif any(p for _, _, _, p, _ in bs):
        proof_only.append((mod, short, bs))
    else:
        unused.append((mod, short, bs))


def m(x):
    return x.removeprefix('Becoming.')


def types(bs):
    return '；'.join(sorted({'`' + ty + '`' for _, ty, *_ in bs}))


def ment_kinds(bs):
    kinds = []
    for name in sorted({x.removeprefix('Becoming.') for *_, ment in bs for x in ment.split(',') if x}):
        kind = 'count' if name in COUNTING_DEFS else CONSTRUCTIONS.get(name)
        assert kind, ('unclassified definition', name)
        if kind not in kinds:
            kinds.append(kind)
    assert kinds, 'a statement depending on decidedness mentions no decidability-taking definition'
    return kinds


TALLY = collections.Counter(k for _, _, bs in counting for k in ment_kinds(bs))
TALLY.update(PROOF_KIND.get(short, '?') for _, short, _ in proof_only)
print('reasons', dict(TALLY))

lines = [
    '# 可判定性清点 / Decidability inventory (P58)', '',
    f'生成：`DECIDABILITY-INVENTORY.py` 在合并检查器回执 `{RUN}` 所检查的核心上运行 `DECIDABILITY-INVENTORY.lean`（源字节与回执一致；'
    '外围工具，导入 Lean 自身的库，核心从不导入它）。每一行由 Lean 读出：绑定的类型是否为可判定族、已判定的命题（对给定的 `p` 有 `p ∨ ¬ p`，如核心的 `Decided p`）或排中律（对约束所涉的每个命题或谓词，完全或受限的形式）、陈述是否依赖它、证明是否用到它。'
    'Ren 2026-10-11：“i intuitively feel decidability is too dualist”，并以“please”接受把它局部化（'
    '[原话](../../../../sources/15-codex-theory-conversations/2026-10-11-decidability-local-imbalance-relatum.md)）。', '',
    f'Generated: `DECIDABILITY-INVENTORY.py` runs `DECIDABILITY-INVENTORY.lean` on the core checked by consolidated '
    f'receipt `{RUN}`, its source bytes matching the receipt (a periphery tool importing Lean\'s own library, which the '
    'core never does). Lean reads each row: whether a binder\'s '
    'type is a decidability family, a decided proposition (`p ∨ ¬ p` for a given `p`, such as the core\'s `Decided p`) or '
    'an excluded middle (`p ∨ ¬ p` for every proposition or predicate a binder ranges over, in full or restricted form), '
    'whether the statement depends on it, and whether the proof uses it.', '',
    '## 总数 / Totals', '',
    '| 类 / Class | 数 / Count |', '|---|---:|',
    f'| 陈述依赖它（计数或构造），可判定是该陈述自己的条件 / statements depending on it (counting or construction): '
    f'decidedness is that statement\'s own condition | {len(counting)} |',
    f'| 只在证明中用到 / used only in proofs | {len(proof_only)} |',
    f'| 不用到 / unused | {len(unused)} |',
    f'| 排中律或其受限形式作为假设（边界定理）/ excluded middle, in full or restricted form, as a hypothesis (boundary '
    f'theorems) | {len(em)} |',
    f'| 计数而可判定被证明，不是假设 / counting with decidedness proved, not assumed | {len(supplied)} |',
    f'| 证明可判定的定义与实例 / definitions and instances proving decidedness | {len(results)} |',
    f'| 取可判定族的定义（计数的原语）/ definitions taking a decidability family (counting primitives) | {len(defs)} |', '',
    '## 理由 / Reasons', '',
    '陈述依赖可判定性时，理由由 Lean 读出的、陈述提到的取可判定族的定义给出；只在证明中用到时，理由逐条分类，生成时断言每条都已分类。'
    ' / Where a statement depends on decidedness, the reason is given by the decidability-taking definitions its statement '
    'mentions, as Lean reads them; where only a proof uses it, each theorem is classified by hand, and generation asserts '
    'that every one is.', '',
    '| 理由 / Reason | 说明 / Meaning | 定理数 / Theorems |', '|---|---|---:|',
] + [f'| {LABEL[k]} | {v} | {TALLY[k]} |' for k, v in {**MENT_REASON, **PROOF_REASON}.items()] + ['']


def ment_reason(bs):
    return '；'.join(LABEL[k] for k in ment_kinds(bs))


def table(title_zh, title_en, items, reason, extra):
    out = [f'## {title_zh} / {title_en}', '',
           '| 模块 / Module | 定理 / Theorem | 可判定 / Decidability | 理由 / Reason | 另一形式 / Other form |',
           '|---|---|---|---|---|']
    for mod, short, bs in items:
        out.append(f'| {m(mod)} | `{short}` | {types(bs)} | {reason(short, bs)} | {extra(short)} |')
    return out + ['']


missing = sorted(short for _, short, _ in proof_only if short not in PROOF_KIND)
assert not missing, ('unclassified proof-only theorems', missing)
stale = sorted(set(PROOF_KIND) - {short for _, short, _ in proof_only})
assert not stale, ('classified theorems no longer proof-only', stale)
lines += table('陈述依赖可判定性的定理（计数或构造）', 'Theorems whose statements depend on decidedness (counting or construction)',
               counting, lambda s, bs: ment_reason(bs), lambda s: FORMS.get(s, '可判定是它自己的条件 / its own condition'))
lines += table('只在证明中用到可判定性的定理', 'Theorems using decidability only in proofs', proof_only,
               lambda s, bs: LABEL[PROOF_KIND[s]], lambda s: FORMS.get(s, '—'))
if unused:
    lines += table('不用到的', 'Unused', unused, lambda s, bs: '—', lambda s: '可去掉 / removable')
lines += ['## 排中律或其受限形式作为假设 / Excluded middle, in full or restricted form, as a hypothesis', '',
          '这些是边界定理：它们表明排中律或其受限形式（例如 `NowhereDecided`：一个已判定的族是否处处不成立已判定）给出什么，配合 ' +
          '、'.join(f'`{b}`' for b in BOUNDARY) +
          '，表明命名一步、对每个世界要求复现、由检验判定相同、把配方读作一个检验、找出不被胜过的选项、在门上定位起源、由前缀检验否证、或在有限分支处找到无界的后继的形式需要可判定性。 / These are boundary theorems: they show what '
          'excluded middle, or a restricted form of it (such as `NowhereDecided`: whether a decided family holds nowhere is '
          'decided), gives, and with ' + ', '.join(f'`{b}`' for b in BOUNDARY) + ', that the forms naming a step, asking '
          'recurrence of every world, fixing likeness by tests, reading a recipe as one test, finding an undominated choice, '
          'locating an origin at a gate, refuting by prefix tests or finding an unbounded successor where branching '
          'is finite need '
          'decidedness.', '']
lines += [f'- {m(mod)}: `{short}`' for mod, short in em] + ['']
by_mod = collections.Counter(m(mod) for mod, *_ in supplied)
lines += ['## 计数而可判定被证明 / Counting with decidedness proved', '',
          '这些定理的陈述计数，但不以可判定为假设：可判定由见证世界或体现证明（例如 `Embodied.decided`）。按模块计： / These '
          'theorems count in their statements without taking decidedness as a hypothesis: it is proved for witness worlds '
          'or from embodiment (for example `Embodied.decided`). By module:', '']
lines += [f'- {k}: {v}' for k, v in sorted(by_mod.items())] + ['']
lines += ['## 计数的原语 / Counting primitives', '', '| 模块 / Module | 定义 / Definition | 可判定 / Decidability |',
          '|---|---|---|']
lines += [f'| {m(mod)} | `{short}` | {types([(k, ty, s, p, "") for k, ty, s, p in bs])} |' for (mod, short), bs in sorted(defs.items())]
lines += ['', '另：一个部分以 `part : F → Bool` 给出，它的切分由类型定下（`Becoming.Admission`、`Becoming.Significance`）；这是比较的'
          '参数，不是关于世界的前提。 / Also: a part is given as `part : F → Bool`, its split decided by its type (`Becoming.Admission`, '
          '`Becoming.Significance`); it is a parameter of the comparison, not a premise about the world.', '']
assert lines[-1] == ''
OUT.write_text('\n'.join(lines))
print(OUT, len(counting), len(proof_only), len(unused), len(em), len(supplied), len(results), len(defs))
