#!/usr/bin/env python3
"""DF2: the cold read of the applied state (reports/recheck-df2.json, 36 findings, tags Ra0-Ra22 for 01, 03, 08 and
Rb0-Rb12 for 02, 04, 05, 07), taken by this rule: every error, overclaim and imprecision is taken; an omission is
taken where the home section lacks part of its record's statement, where another section points to the home for a
law it does not state, or where one result was stated in two places; laws a record states beyond its statement stay
in the record (Ra3 in part, Ra5, Ra7, Ra8, Ra10, Ra13, Ra16 in part, Ra18, Ra19, Ra21 and Ra22 in part, Rb9). Where
a finding's text was shortened or reworded against the Lean, the replacement here is the one applied. Run once from
the checkout root."""
import json
from pathlib import Path

ROOT = Path.cwd()
CH = ROOT / 'theories/becoming/chapters'
REC = ROOT / 'theories/becoming/results/records'
LEAN = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
R31 = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/r31-support/layers.py'
KIT = Path(__file__).resolve().parent

E = {}  # path -> list of (tag, old, new)


def ed(path, tag, old, new):
    E.setdefault(path, []).append((tag, old, new))


M08, K03, L04, C05 = CH / '08-METHOD.md', CH / '03-KNOWING.md', CH / '04-LIFE.md', CH / '05-COLLECTIVES.md'

# 08 §4, what a summary keeps; one-move covering; §6 contraction; §3 the layers.
ed(M08, 'Ra1', '(any process; the access witness on standard axioms, as is the access model: `propext` and `Quot.sound` in some declarations)',
   "(any process; the access model's two laws on standard axioms: `propext`, and `Quot.sound` in one)")
ed(M08, 'Ra2', '(`projection_exact_iff`, the [root\'s](01-ROOT.md#r-finite-trace-transport) law; pointwise, `local_exact_iff_trace_exact`).',
   '(`projection_exact_iff`, the [root\'s](01-ROOT.md#r-finite-trace-transport) law; pointwise, `local_exact_iff_trace_exact`). '
   'The summary then keeps what is enabled and the feasibility of every finite word, and for a one-to-one map traces '
   'correspond end to end (`enabled_projection_iff`, `feasible_projection_iff`, `trace_faithful_iff`).')
ed(M08, 'Ra0', '- In the access model, with the current route fixed, agreement on occupancy throughout the permitted access set is '
   'necessary and sufficient for every permitted word to have the same feasibility.\n- A newly admitted access can separate '
   'two states that every old judgment identified (`hidden_formed` and its witness): the access relations that can still '
   "form limit what a current abstraction may forget. The access model's exact behaviour with the route fixed and its "
   "witness are [knowing's](03-KNOWING.md#r-access-yet-to-form).",
   "- The access model's exact behaviour with the current route fixed, and a newly admitted access that separates two "
   "states every old judgment identified, are [knowing's](03-KNOWING.md#r-access-yet-to-form): the access relations that "
   'can still form limit what a current abstraction may forget.')
ed(M08, 'Ra3/Ra4', '- Four processes on two configurations are witnesses: more possible outcomes need not cover, covering can remove a '
   'possibility, and a summary can hide a loss.',
   '- Four processes on two configurations are witnesses: more possible outcomes need not cover, covering can remove a '
   'possibility, goals ensured separately need not be ensured jointly, and a summary can hide a loss.')
ed(M08, 'Ra6', 'The validity of a logical rule is here a condition of the process. A companion module',
   'The validity of a logical rule is here a condition of the process. Derivability is then reachability '
   '(`derivation_iff_reach`), and replacing `y` by `x` in every left context is exactly `x` reaching `y` '
   '(`replacement_iff_reach`). A companion module')
ed(M08, 'Ra9', '`Becoming.World` with every module it imports, that is', '`Becoming.World` with every module of the package it imports, that is')

# 03.
ed(K03, 'Ra4', "**Theorem** (any process; no premise). One process's moves cover another's at a configuration exactly where every "
   'goal one move of the second completes is completed by one move of the first; covering is kept along revisions each '
   'covering the last, and fails exactly where not every goal is carried (a lost goal is named under double-negation '
   'elimination, a hypothesis; that it is needed is not shown). Witnesses: more possible outcomes need not cover; goals '
   'ensured separately need not be ensured jointly; a summary can hide a loss. Stated in [08](08-METHOD.md#r-one-move-covering);',
   "Stated in [08](08-METHOD.md#r-one-move-covering): when one process's moves cover another's at a configuration, what one "
   'move ensures, and the witnesses;')
ed(K03, 'Ra11', 'with no task-success alarm, under an exact affine sign-transfer criterion;',
   'with no task-success alarm; signs transfer between epochs exactly where the bias is kept and the gains agree in sign, '
   'so a change of gain keeping zero and orientation, as from 1 to 2, keeps every sign '
   '(`CalibrationRenewal.positive_gain_change_preserves_signs`);')
ed(K03, 'Ra12', '<a id="r-learning-a-rule-by-narrowing"></a>\n**Assessment**, *three forces*. Accuracy, epistemic support and '
   'obligation (to investigate, disclose, perform or compel) have different grounds: content and the relation it concerns '
   'fix accuracy without an external commander, and neither other force follows. A core law (`Becoming.Narrowing`, ported '
   'from StandardsBridge; empty axiom reports): on a nonempty candidate list a definite answer is error-free across the '
   'list only where every candidate agrees, so a repertoire omitting the actual rule can answer confidently and falsely. '
   'Lean: `Narrowing.answer_iff`, `Narrowing.safe_definite_requires_agreement`, `Narrowing.wrong_model_class_can_be_confidently_wrong`;',
   '**Assessment**, *three forces*. Accuracy, epistemic support and obligation (to investigate, disclose, perform or '
   'compel) have different grounds: content and the relation it concerns fix accuracy without an external commander, and '
   'neither other force follows.\n\n<a id="r-learning-a-rule-by-narrowing"></a>\n**Theorem** (any type of questions; '
   'candidate rules listed, observations supplied; `Becoming.Narrowing`, ported from StandardsBridge, empty axiom '
   'reports). Narrowing a list of candidate rules by observations keeps exactly the rules fitting them, and the actual '
   'rule among them where it is listed and the observations are faithful. The answer asserting what every kept rule '
   'agrees on is safe; on a nonempty candidate list a definite answer is error-free across the list only where every '
   'candidate agrees, so that answer is the greatest safe one. Observations acquired from a listed actual rule make every '
   'asserted answer its value, and in the named repertoire contrasting cases settle both questions; a repertoire omitting '
   'the actual rule can answer confidently and falsely. Lean: `Narrowing.narrowed_iff_fits`, `Narrowing.actual_retained`, '
   '`Narrowing.answer_iff`, `Narrowing.safe_definite_requires_agreement`, `Narrowing.answer_maximal`, '
   '`Narrowing.acquired_answers_correct`, `Narrowing.contrasting_settles_both`, '
   '`Narrowing.wrong_model_class_can_be_confidently_wrong`;')
ed(K03, 'Ra14', 'among repetition, production, suspension, uptake, ineffective inspection and rest resolves them',
   'among repetition, production, suspension, uptake, inspection (ineffective once closed), closure and rest resolves them')
ed(K03, 'Ra14', 'A record can stay true of its sample while reusing it for the present question is wrong. Lean: '
   '`NormativeActivity.sound_closed_answer_abstains`, `NormativeActivity.historical_truth_present_error`, '
   '`NormativeActivity.reopening_and_inspection_repair`;',
   'A record can stay true of its sample while reusing it for the present question is wrong. In the named history, '
   'reopening, inspecting and taking up repairs the judgment, using up the inspection available; reopening and taking up '
   'without inspection does not. Lean: `NormativeActivity.sound_closed_answer_abstains`, '
   '`NormativeActivity.historical_truth_present_error`, `NormativeActivity.reopening_and_inspection_repair`, '
   '`NormativeActivity.reopening_without_inspection_does_not_repair`;')
ed(K03, 'Ra15', '(periphery modules; `propext`, `Quot.sound` and, in one declaration, `Classical.choice`, as their receipt reports; '
   'admitted transitions supplied)',
   '(periphery modules TemporalInspection and ChangingDependency; `propext` and `Quot.sound` in some TemporalInspection '
   'declarations, and every ChangingDependency declaration, over the reals, on `propext`, `Quot.sound` and '
   '`Classical.choice`, as their receipts report; admitted transitions supplied)')
ed(K03, 'Ra16', 'a change recorded as none leaves false confidence.', 'a change recorded as none can leave false confidence.')
ed(K03, 'Ra17', '**Theorem** (periphery over the reals; `Classical.choice`, `Quot.sound`, `propext`), *when to inquire and when to respond*.',
   "**Theorem** (in the core with empty axiom reports, given a choice over the readings; the periphery's form on "
   '`Classical.choice`, its dosing witnesses over the reals on `propext`, `Quot.sound` and `Classical.choice`), *when to '
   'inquire and when to respond*.')
ed(K03, 'Ra20', 'Primitive-only encounters cannot identify argument order, and a later change of the operative order defeats '
   'transfer. Where construction admits a route duplicating one argument, the old records stop identifying the operation; '
   'a further reference encounter exposes and repairs the duplicate, and without spare parts the error is recorded, not repaired.',
   'Three probes, the two atoms and one join, identify a code wherever its primitives differ, so the code read off them '
   'evaluates every expression as the code does, at every depth (`CodeAcquisition.acquired_exact`, '
   '`CodeAcquisition.acquired_every_expression`); primitive-only encounters cannot identify argument order, and a code '
   'read under one order answers a novel expression otherwise than the switched order does. For the collapsed code, whose '
   'primitives are equal, a program formed from connectors that duplicates one argument fits the old records yet answers '
   "the novel expression wrongly; the novel expression's record exposes it, a course with spare parts rebuilds the right "
   'program, and without spare parts the error is recorded, not repaired.')
ed(K03, 'Ra21', 'at both of the equal-total states (2, 0) and (0, 2); T(a, b)',
   'at both of the equal-total states (2, 0) and (0, 2), while the total read with b follows the exact law '
   '(a + b, b) ↦ (a + b + cb, b) (`enriched_routing_exact`); T(a, b)')
ed(K03, 'Ra21', '| `RelationsAcrossScales.routing_defect_lower_bound`, `exact_total_can_hide_loss`,',
   '| `RelationsAcrossScales.routing_defect_lower_bound`, `enriched_routing_exact`, `exact_total_can_hide_loss`,')
ed(K03, 'Ra22', 'states alike under every old observation can be told apart by a newly admitted probe',
   'states alike under every old observation and in their active view can be told apart by a newly admitted probe')

# 04.
ed(L04, 'Rb0', 'The one-step connectionist recovery derives the developmental response, keeping the recurrence, the initial '
   'profile and the selection law as premises.',
   "The connectionist recovery derives the developmental response, the derivative of the state developed over any number "
   "of steps in one link's weight, and in one step, with the identity activation and an initial profile aligned with the "
   "selection profile, changing a link raises the score exactly where the change has the sign of the selection profile's "
   'product at its two ends, the Hebbian sign (`ConnectionistRecovery.developmental_response`, '
   '`ConnectionistRecovery.beneficial_iff_hebbian`), keeping the recurrence, the initial profile and the selection law as premises.')
ed(L04, 'Rb1', '([03](03-KNOWING.md#correction-is-not-calibration))', '([03](03-KNOWING.md#r-correction-is-not-calibration))')
ed(L04, 'Rb2', 'under bounded drift, understated bounds can falsely certify success and loose valid bounds can withhold repair.',
   'with the drift per step and the reading noise bounded, the readings at the references decide a margin exactly at ages '
   'below a bound the drift, the noise and the gain fix (`DriftMargins.aged_decoding_bound`, '
   '`DriftMargins.assurance_window`); understated bounds can falsely certify success and loose valid bounds can withhold repair.')
ed(L04, 'Rb3', '**Theorem** (periphery, Mathlib with `propext`, `Quot.sound`, `Classical.choice`; pre-spine module; witness). '
   '*Equal totals can hide what a capacity carries.*',
   '**Theorem** (periphery, its imports reaching Mathlib; pre-spine module; witness; the laws stated here with empty axiom '
   'reports). *Equal totals can hide what a capacity carries.*')
ed(L04, 'Rb4', '**Theorem** (periphery, `propext`, `Quot.sound`, `Classical.choice`; pre-spine module; witness for the unavailability).',
   '**Theorem** (periphery, `propext`, `Quot.sound`, `Classical.choice`, except `reconstruction_counts` with `propext` only '
   'and the witnesses with none; pre-spine module; witness for the unavailability).')
ed(L04, 'Rb5', 'Every admitted finite history stays within the initial material and support, and in one history',
   'Every admitted finite history keeps the material exactly and the sum of available and used support, and is no '
   'longer than the support available at its start (`run_accounts`, `run_length_bound`); in one history')
ed(L04, 'Rb10', 'one later repairs and reconstructs, the other does not, so the same carrier',
   'one later repairs and reconstructs, the other does not unless a supplied assisted repair comes first '
   '(`supplied_assistance_can_rescue_development`), so the same carrier')

# 05.
ed(C05, 'Rb6', 'SeededContinuation.lean), `propext` and `Quot.sound` reported)',
   'SeededContinuation.lean), `propext` in some of the cited declarations and none in the others, as its receipt '
   'reports; `Quot.sound` enters only `absent_reserve_blocks_ignition`)')
ed(C05, 'Rb7', 'influence bound `λ` and accountability floor `θ`, let', 'influence bound `λ` and floor `θ`, let')
ed(C05, 'Rb7', 'the accountability floor is kept at the next step, with correction paid and no error, from every accountability `q` with `θ ≤ q ≤ 1`',
   'the floor is kept at the next step, with correction paid and no error in `q`, from every level `q` with `θ ≤ q ≤ 1`')
ed(C05, 'Rb8', '; the cases witnesses)', '; the computed cases are witnesses)')

# The L0 wording outside the chapters (Ra9).
ed(LEAN / 'Becoming.lean', 'Ra9', 'L0 is the base, `Becoming.World` with every module it imports: `Becoming.Frame`, `Becoming.Prelude`\n'
   "and the grammar's `Becoming.Grammar`, `Becoming.GrammarMap` and `Becoming.GrammarLaws`, on which the\nframe rests;",
   'L0 is the base, `Becoming.World` with every module of the package it imports: `Becoming.Frame`,\n'
   "`Becoming.Prelude` and the grammar's `Becoming.Grammar`, `Becoming.GrammarMap` and `Becoming.GrammarLaws`, on\n"
   'which the frame rests;')
ed(LEAN / 'README.md', 'Ra9', 'L0 is the base, `Becoming.World` with every module it imports', 'L0 is the base, `Becoming.World` with every module of the package it imports')
ed(LEAN / 'README.zh.md', 'Ra9', 'L0 是基底，即 `Becoming.World` 及其导入的每个模块', 'L0 是基底，即 `Becoming.World` 及其导入的本包每个模块')
ed(R31, 'Ra9', '* L0: the base, `Becoming.World` with every module it imports (', '* L0: the base, `Becoming.World` with every module of the package it imports (')
ed(R31, 'Ra9', '# The base is computed: the World with every module it imports (', '# The base is computed: the World with every module of the package it imports (')
ed(ROOT / '_process/research/2026-10-05-repository-reconciliation/architecture/DEFECTS-FOUND.md', 'Ra9',
   'L0 is the World with every module it imports, in the legend', 'L0 is the World with every module of the package it imports, in the legend')
ed(KIT / 'study_df2.txt', 'Ra9', 'L0 is the World with every module it imports (', 'L0 is the World with every module of the package it imports (')

done = []
for p, edits in E.items():
    t = p.read_text(encoding='utf-8')
    for tag, old, new in edits:
        assert t.count(old) == 1, (tag, p.name, t.count(old), old[:90])
        t = t.replace(old, new)
        done.append(f'{tag} {p.name}')
    p.write_text(t, encoding='utf-8')


# Records.
def edit(rid, fn):
    p = REC / f'{rid}.json'
    d = json.loads(p.read_text(encoding='utf-8'))
    fn(d)
    p.write_text(json.dumps(d, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')
    done.append(f'record {rid}')


def sub(o, k, old, new):
    assert o[k].count(old) == 1, (k, old, o[k][:120])
    o[k] = o[k].replace(old, new)


def market(d):  # Rb7: the floor θ on the level q, in the record as in its home section
    sub(d['statement'], 'en', 'the accountability floor holds under every admissible influence', 'the floor on the level q holds under every admissible influence')
    sub(d['statement'], 'zh', '问责之下限在每一容许之影响下得保', 'q 之下限在每一容许之影响下得保')
    sub(d['laws'][0], 'en', 'the fine times the accountability,', 'the fine times the level q,')
    sub(d['laws'][0], 'zh', '罚额乘问责', '罚额乘 q')
    sub(d['laws'][1], 'en', 'every accountability q in [θ, 1]', 'every level q in [θ, 1]')
    sub(d['laws'][1], 'zh', '凡问责 q ∈ [θ, 1]', '凡 q ∈ [θ, 1]')
    sub(d['laws'][2], 'en', 'accountability in [0, θ)', 'the level q in [0, θ)')
    sub(d['laws'][2], 'zh', '问责在 [0, θ)', 'q 在 [0, θ)')
    sub(d['hypotheses'][1], 'en', 'no accountability error', 'no error in q')
    sub(d['hypotheses'][1], 'zh', '问责无误差', 'q 无误差')
    sub(d['history'][0], 'en', 'its margin for the accountability floor', 'its margin for the floor on the level q')
    sub(d['history'][0], 'zh', '问责下限', 'q 之下限')
    assert len(d['statement']['en']) <= 300 and len(d['statement']['zh']) <= 150


edit('market-model-share-margin-and-ends', market)


def renewal(d):  # Rb11, Rb12: what moved to significance-through-a-common-condition leaves this record's text
    sub(d['correspondence'], 'en', 'Connection depends on what counts as a condition and as participation: adding a condition '
        'everyone depends on at level 0 connects everything for free, while a too coarse common condition empties living '
        '(independent review Q4, Q10); a discipline excluding idle conditions is stated in condition-correspondence-discipline, '
        'which does not exclude a renewed condition every formation depends on at a positive level, used once by one living '
        'event, and does not resolve Q10.',
        'What counts as a condition and as participation decides connection, which significance-through-a-common-condition '
        'states with its caveat on idle conditions; a too coarse common condition empties living (independent review Q10), '
        'which condition-correspondence-discipline does not resolve.')
    sub(d['correspondence'], 'zh', '连通依赖什么算条件、什么算参与：加入一个人人在水平 0 依存的条件即可免费连通，而过粗的共同条件又使 '
        'living 变空（独立审查 Q4、Q10）；一条排除惰性条件的纪律已在 condition-correspondence-discipline 中陈述，它排除不了每个形成都以'
        '正水平依存、由一个活的事件使用一次的被更新条件，也不解决 Q10。',
        '什么算条件、什么算参与决定连通，由 significance-through-a-common-condition 陈述，并附其关于惰性条件之限；过粗的共同条件使 '
        'living 变空（独立审查 Q10），condition-correspondence-discipline 不解决此点。')
    sub(d['hypotheses'][1], 'en', '`living` is the whole-run relational reading (active and not consuming) and `related` is '
        'participation in a common condition; both are disclosed reading choices, not proved correspondences.',
        '`living` is the whole-run relational reading (active and not consuming), a disclosed reading choice, not a proved '
        "correspondence; relation through a common condition is significance-through-a-common-condition's.")
    sub(d['hypotheses'][1], 'zh', 'living 取整段运行上的关系读法（活跃且不消耗），related 取共同参与某一条件；两者都是公开的读法选择，不是被证明的对应。',
        'living 取整段运行上的关系读法（活跃且不消耗），是公开的读法选择，不是被证明的对应；经共同条件的关系属 '
        'significance-through-a-common-condition。')
    sub(d['limitations'], 'en', 'The relational reading and the common-participation relation are disclosed reading choices; '
        'whether they are the right reading of 生生, and the empirical correspondence of common conditions, lie outside this result.',
        'The relational reading is a disclosed reading choice; whether it is the right reading of 生生 lies outside this result.')
    sub(d['limitations'], 'zh', '关系读法与共同参与关系是公开的读法选择；它们是否为生生的正确读法、共同条件的经验对应，都不在本结果内。',
        '关系读法是公开的读法选择；它是否为生生的正确读法，不在本结果内。')


edit('becoming-renewal-reading', renewal)
print('df2_recheck: applied', len(done))
for x in done:
    print(' ', x)
