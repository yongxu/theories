#!/usr/bin/env python3
"""SJ1's record, a-response-common-over-a-reading, written from this script (make_record_du.py's pattern) with the
receipt left PENDING for reland_sj.py and the theorem counts as COUNT marks it fills from the receipt. The sha256 of
the two Lean files is taken from the bytes on the branch; reland_sj.py checks the receipt bound the same bytes.
usage (from the checkout root of the worktree): python3 -B <kit>/make_record_sj.py"""
import hashlib
import json
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
LEAF = f'{PKG}/Becoming/CommonResponse.lean'
VIA = f'{PKG}/Becoming/Viability.lean'
CH = 'theories/becoming/chapters'
SJ = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/sj-edge-and-judgement'
RECEIPT = f'{PKG}/becoming-checks/PENDING/verification.json'
OUT = ROOT / 'theories/becoming/results/records/a-response-common-over-a-reading.json'


def sha(p):
    return hashlib.sha256((ROOT / p).read_bytes()).hexdigest()


def t(en, zh):
    return {'en': en, 'zh': zh}


B = 'Becoming.'
E = 'Becoming.«共应之例».'
LEAF_DECLS = [
    B + '«共应»', B + '«自反则承在内»', B + '«诸承在内当且仅当自反»', B + '«传递则承闭»', B + '«诸承闭当且仅当传递»',
    B + '«闭在内则在承»', B + '«所闭之承在内»', B + '«所闭之承闭»', B + '«闭在内则在所闭之承»', B + '«所闭之承最大»',
    B + '«共应当且仅当所闭之承遍»', B + '«自反传递则共应当且仅当承遍»', B + '«共应之细»', B + '«静之共应当且仅当遍»',
    B + '«一之共应当且仅当一应遍»', B + '«依读而应则共应»', B + '«应际»', B + '«读应»', B + '«应际同行当且仅当同读同应»',
    B + '«遍定应共应当且仅当同读同应»', B + '«遍定应共应当且仅当像定后»', B + '«映应共应当且仅当同读同应»',
    E + 'NotReflexive.trans', E + 'NotReflexive.held_each', E + 'NotReflexive.none',
    E + 'NotTransitive.refl', E + 'NotTransitive.symm', E + 'NotTransitive.held_each', E + 'NotTransitive.none',
    E + 'EachNotCommon.each', E + 'EachNotCommon.none', E + 'PairsNotCommon.pairs', E + 'PairsNotCommon.none',
    E + 'NotCovering.fixed', E + 'NotCovering.none', E + 'NotOne.common', E + 'NotOne.differ',
    E + 'OneCarrier.fixed', E + 'OneCarrier.none']
VIA_DECLS = ['Becoming.Viability.kernel_iff_held', 'Becoming.Viability.Certificate.kernel',
             'Becoming.Viability.kernel_certificate', 'Becoming.Viability.Kernel', 'Becoming.Viability.Certificate']

d = {
    'schema_version': 2,
    'id': 'a-response-common-over-a-reading',
    'title': t('A response common over a reading', '读之共应'),
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F02',
    'reviewed_at_utc': 'REVIEWED_AT',
    'statement': t(
        "The occurrences whose closure under a relation stays in a region form its largest closed part, the invariance "
        "kernel at a process's steps. A response common over a reading within a requirement exists exactly where the "
        "acts' kernels cover the situations: judgment is viability indexed by acts.",
        '依一关系之闭包留在一区域之内的诸事，构成该区域对该关系封闭的最大部分，在一过程之步即不变核。读之共应在要求之内存在，'
        '当且仅当诸行之不变核遍盖诸情境：判断即以行为索引的生存性。'),
    'laws': [
        {**t("The kernel: for every carrier, relation and region, the occurrences at which the region holds "
             "throughout their closure under the relation lie inside the region, form a region closed under the "
             "relation, and include every region inside it closed under the relation. At a process's steps it is the invariance "
             "kernel, and the kernel's two laws, every certificate inside it and it a certificate, are proved from it.",
             '不变核：对每一载体、关系与区域，该区域依该关系之闭包处处成立之诸事，在该区域之内，对该关系封闭，且含该区域之内'
             '每一对该关系封闭的区域。在一过程之步即不变核，不变核之二律（每一证书在不变核内、不变核为证书）由之证出。'),
         'declarations': [B + '«所闭之承最大»', B + '«所闭之承在内»', B + '«所闭之承闭»', B + '«闭在内则在所闭之承»',
                          'Becoming.Viability.kernel_iff_held', 'Becoming.Viability.Certificate.kernel',
                          'Becoming.Viability.kernel_certificate']},
        {**t("Covering: for every reading and requirement, a response common over the reading, one region for each "
             "act inside that act's requirement, closed under the reading and together covering the situations, "
             "exists exactly where every situation has an act whose requirement holds throughout its closure under "
             "the reading; for a reflexive and transitive reading, along the reading itself. No choice or decision.",
             '遍盖：对每一读与要求，读之共应（每一行一区域，在该行之要求之内，对读封闭，合而遍盖诸情境）存在，当且仅当每一'
             '情境有一行，其要求沿该情境依读之闭包处处成立；读自反且传递时，沿读本身即可。无需选择或判定。'),
         'declarations': [B + '«共应»', B + '«共应当且仅当所闭之承遍»', B + '«自反传递则共应当且仅当承遍»']},
        {**t("Along the reading without its closure, what holds at every situation alike lies inside every region "
             "exactly where the reading is reflexive, and is closed for every region exactly where it is transitive; "
             "a reading transitive and not reflexive, and one reflexive and symmetric and not transitive, each give "
             "every situation such an act while no common response exists.",
             '不取闭包而沿读本身：处处所承者在每一区域之内，当且仅当读自反；于每一区域皆对读封闭，当且仅当读传递；读传递而不'
             '自反、或自反对称而不传递时，每一情境皆有这样的行，而无共应。'),
         'declarations': [B + '«诸承在内当且仅当自反»', B + '«诸承闭当且仅当传递»', B + '«自反则承在内»', B + '«传递则承闭»',
                          B + '«闭在内则在承»', E + 'NotReflexive.trans', E + 'NotReflexive.held_each',
                          E + 'NotReflexive.none', E + 'NotTransitive.refl', E + 'NotTransitive.symm',
                          E + 'NotTransitive.held_each', E + 'NotTransitive.none']},
        {**t("A response common over a reading is common over every reading inside it; under staying the same one "
             "exists exactly where the requirement covers every situation, and under the reading that tells "
             "nothing apart, on an inhabited carrier, exactly where one act meets the requirement everywhere. A rule "
             "from what a map reads, meeting the requirement, gives one with no choice.",
             '读之共应对其内每一读亦为共应；在静之下，存在当且仅当要求遍盖每一情境；在一无所分之读（一）下，于非空之载体，'
             '当且仅当一行处处合乎要求。依映射所读之规则合乎要求，则无需选择而给出共应。'),
         'declarations': [B + '«共应之细»', B + '«静之共应当且仅当遍»', B + '«一之共应当且仅当一应遍»',
                          B + '«依读而应则共应»']},
        {**t("One act per situation: where the requirement gives exactly one act at each situation, a response "
             "common over a map's sameness exists exactly where situations the map does not tell apart have the "
             "same act, which, on a carrier keeping situations and acts apart, is the image of the response "
             "relation along the map having a fixed successor; with an act map, situations read alike get the same "
             "act.",
             '每一情境一行：要求在每一情境恰给一行时，映射之同上的共应存在，当且仅当映射不分的情境有同一行；在分开情境与行'
             '的载体上，即应之关系沿映射之像有定后；有行之映射时，读之相同的情境得同一行。'),
         'declarations': [B + '«应际»', B + '«读应»', B + '«应际同行当且仅当同读同应»', B + '«遍定应共应当且仅当同读同应»',
                          B + '«遍定应共应当且仅当像定后»', B + '«映应共应当且仅当同读同应»']},
        {**t("Witnesses: a situation with no act leaves the image determined and no response; two acts at one "
             "situation give a response with differing acts; situations and acts on one carrier leave the image "
             "determined and no response; an act at every situation, or one shared by every two of three, gives no "
             "common response under the reading that tells nothing apart.",
             '见证：某情境无行时像有定后而无共应；一情境有二行时有共应而其行相异；情境与行在一载体上时像有定后而无共应；'
             '在一无所分之读下，每一情境各有一行、或三者每两者共有一行，皆无共应。'),
         'declarations': [E + 'NotCovering.fixed', E + 'NotCovering.none', E + 'NotOne.common', E + 'NotOne.differ',
                          E + 'OneCarrier.fixed', E + 'OneCarrier.none', E + 'EachNotCommon.each',
                          E + 'EachNotCommon.none', E + 'PairsNotCommon.pairs', E + 'PairsNotCommon.none']},
    ],
    'hypotheses': [
        t("A reading is a relation on situations, supplied; the situations are the grammar's occurrences of one "
          "carrier, and no separate reader is given. The reading's own formation is not represented here.",
          '读是情境上的关系，为所给；情境是一载体上的文法之事，不另设读者。读本身如何形成，此处不表示。'),
        t("The requirement is supplied and fixed before the outcome: for each act, the region where it is "
          "acceptable and can be done. The act is an index outside the grammar's relations.",
          '要求为所给，并在结果之前确定：对每一行，是其可接受且可行的区域。行是文法关系之外的索引。'),
        t("For the one-act law, situations and acts are held apart on a sum carrier; the requirement giving "
          "exactly one act at each situation is a premise, and each premise is shown to do work.",
          '每一情境一行之律中，情境与行在和载体上分开；要求在每一情境恰给一行是前提，每一前提皆有见证表明其作用。'),
    ],
    'does_not_show': [
        {**t('Which requirement is right or better: the requirement is supplied, and no law here ranks requirements.',
             '哪个要求是对的或更好：要求为所给，此处无律排序要求。'), 'kind': 'non-implication'},
        {**t('A rule fixing one act for each reading from a common response: GuardHorizon has such a rule with choice '
             'over the readings named as a hypothesis; that the choice is needed for this rule is not proved here.',
             '由共应得出为每一读数确定一行的规则：GuardHorizon 在读数上的选择（列为前提）之下给出此规则；此规则需要该选择，'
             '此处未证。'), 'kind': 'converse'},
        {**t("That every situation having an act whose requirement holds at every situation the reading relates to "
             "it gives a common response, for a reading that is not both reflexive and transitive (here reflexive and "
             "symmetric, not transitive).",
             '对并非既自反又传递之读（此处自反且对称而不传递）：每一情境有一行，其要求在读所关联的每一情境成立，即给出共应。'), 'kind': 'non-implication',
         'witness': E + 'NotTransitive.none'},
        {**t('That an act at every situation, or one shared by every two situations, gives a common response.',
             '每一情境各有一行、或每两情境共有一行，即给出共应。'), 'kind': 'non-implication',
         'witness': E + 'PairsNotCommon.none'},
        {**t("How a reading forms or is revised, or what a response's outcome is worth: a common response meets the "
             "requirement and no more.",
             '读如何形成或修订，或回应之结果价值几何：共应只合乎要求，不多于此。'), 'kind': 'scope'},
    ],
    'counterexamples': [],
    'standard_boundaries': ['no-evaluation', 'no-ethical-premise', 'formal-not-empirical', 'names-provisional',
                            'omission-not-refutation'],
    'validation_scope': t(
        "Checked by the core checker with Lean 4.29.1 from the prelude: Becoming.CommonResponse at receipt PENDING, "
        "CR_DECLS declarations (CR_THMS theorems), and Becoming.Viability, VIA_DECLS declarations (VIA_THMS "
        "theorems), whose two kernel laws are proved from the leaf with their statements unchanged, each with an "
        "empty axiom report; built in scratch, its Lean and map read by three independent AI reviewers and its "
        "landing texts by four, each with a verifier, every confirmed finding taken.",
        '由核心检查器以 Lean 4.29.1 从前奏检查：Becoming.CommonResponse，回执 PENDING，CR_DECLS 个声明（CR_THMS 条定理），'
        '以及 Becoming.Viability，VIA_DECLS 个声明（VIA_THMS 条定理），其两条不变核之律由此叶证出、陈述不变，公理报告均为空；'
        '先在草稿中构建，其 Lean 与图经三位独立 AI 审阅者阅读，其落地文本经四位（各有一位核验者）阅读，所核实者皆采纳。'),
    'next_delta': t(
        "The rule form with choice, GuardHorizon's uniform policy, stated as this law with choice over the readings "
        "and every reading given, and its example re-proved from this record's witness.",
        '带选择的规则形式（GuardHorizon 之一致策略）表为本律加读数上的选择与每一读数皆被给出，其例由本记录之见证重证。'),
    'correspondence': t(
        "At a process's steps the kernel is what discrete-time viability theory (Aubin 1991) calls the invariance "
        "kernel of the constraint set, the largest subset that every evolution keeps; where each configuration has "
        "exactly one successor it is also Aubin's viability kernel, from which some evolution stays. A common response over a reading is the relational, set-valued form of a policy "
        "measurable with respect to an observation partition: the partition replaced by any relation and its "
        "closure, the policy by an admissible relation closed under the reading; one act chosen in each class gives "
        "the policy. Requisite variety (Ashby 1956) reads the covering law's failure: a reading too coarse for the "
        "requirement.",
        '在一过程之步，此核即离散时间生存理论（Aubin 1991）所谓约束集之不变核：为每一演化所保的最大子集；'
        '每一构型恰有一后继时，亦即 Aubin 之生存核（有某演化留于其中）。读之共应是相对观察分划可测之策略的关系形式（集值）：'
        '分划换为任一关系及其闭包，策略换为对读封闭的可接受关系；于每一类择一行，即得此策略。必要多样性（Ashby 1956）读出'
        '遍盖律之不成立：读对要求过粗。'),
    'canonical_source': LEAF,
    'aliases': ['a response common over a reading', '共应', 'judgment is viability indexed by acts',
                B + '«所闭之承最大»', B + '«共应当且仅当所闭之承遍»', B + '«遍定应共应当且仅当像定后»'],
    'dependencies': [
        {'id': 'master-laws-on-the-grammar', 'relation': 'formal-reuse', 'detail': t(
            "Reuses the grammar's closure, «承», «闭» and «闭含所闭», and the lumping law «像定后当且仅当同行»: the kernel "
            "and the one-act law are proved from them.",
            '复用文法之闭包、«承»、«闭» 与 «闭含所闭»，以及归并律 «像定后当且仅当同行»：不变核与每一情境一行之律由之证出。')},
        {'id': 'market-protected-continuation', 'relation': 'formal-reuse', 'detail': t(
            "Reuses Viability's kernel and a process's steps: kernel_iff_held reads the kernel as the grammar's, and "
            "that record's two kernel laws are proved from this record's first law, their statements unchanged.",
            '复用 Viability 之不变核与过程之步：kernel_iff_held 把不变核读作文法上沿诸步之闭包处处所承者（«所闭之承»），该记录的两条不变核之律由本记录第一律证出，陈述不变。')},
        {'id': 'finite-continuation-plans', 'relation': 'interpretive', 'detail': t(
            "A rule fixed in advance from a common response asks for a choice over the readings; "
            "Viability.plans_iff_choice shows that such choice cannot be dropped for plans, cited by analogy and not "
            "re-proved for this rule.",
            '由共应预先确定的规则要求读数上的选择；Viability.plans_iff_choice 表明计划不能免去此类选择，此处类比引之，未就此规则重证。')},
        {'id': 'testing-within-couplings', 'relation': 'interpretive', 'detail': t(
            "States on the grammar its sentence that a judgment through the couplings is a common response over "
            "the class alike through them.",
            '在文法上陈述其一句：经耦合的判断是对经耦合相同之类的共应。')},
    ],
    'related': [
        {'id': 'when-to-inquire-and-when-to-respond', 'detail': t(
            "Its uniform policy from readings is the rule form of this law, with choice over the readings.",
            '其由读数得出的一致策略是本律的规则形式，带读数上的选择。')},
        {'id': 'readings-a-response-needs', 'detail': t(
            "Its three routes, each pair with a common route and the three with none, are this record's pairs "
            "witness at a model.",
            '其三路线（每两个情境有共同到达的路线，三者无）即本记录之成对见证在一模型上的情形。')},
        {'id': 'generalization-through-lumping', 'detail': t(
            "Learning.Lumped of a map and an act map is the condition of the one-act law at an act map, unfolded.",
            '映射与行之映射的 Learning.Lumped，即每一情境一行之律在行之映射处的条件，展开即是。')},
    ],
    'references': [
        {'path': LEAF, 'role': 'proof', 'sha256': sha(LEAF), 'declarations': LEAF_DECLS},
        {'path': VIA, 'role': 'proof', 'sha256': sha(VIA), 'declarations': VIA_DECLS},
        {'path': f'{SJ}/DESIGN.md', 'role': 'provenance', 'sha256': sha(f'{SJ}/DESIGN.md'), 'declarations': []},
        {'path': f'{SJ}/REVIEW-2.md', 'role': 'review', 'sha256': sha(f'{SJ}/REVIEW-2.md'), 'declarations': []},
        {'path': f'{SJ}/REVIEW-3.md', 'role': 'review', 'sha256': sha(f'{SJ}/REVIEW-3.md'), 'declarations': []},
    ],
    'proof_bindings': [
        {'source': LEAF, 'receipt': RECEIPT, 'sha256_pointer': '/source_sha256/Becoming.CommonResponse',
         'success_pointer': '/status', 'success_value': 'passed'},
        {'source': VIA, 'receipt': RECEIPT, 'sha256_pointer': '/source_sha256/Becoming.Viability',
         'success_pointer': '/status', 'success_value': 'passed'},
    ],
    'history': [t(
        "1 November 2026, board item SJ (SJ1): added from SJ's design after three reviews (REVIEW-1, four lenses on "
        "the design; REVIEW-2, three on the Lean and the map; REVIEW-3, four on the landing texts, each with a "
        "verifier), every confirmed finding taken; Viability's two kernel laws re-proved "
        "from it with their statements unchanged; GuardHorizon's bridge left to a ring slot.",
        '2026年11月1日，工作板条目 SJ（SJ1）：据 SJ 的设计新增，经三轮审阅（REVIEW-1 以四个视角审设计；REVIEW-2 以三个视角审 Lean '
        '与图；REVIEW-3 以四个视角审落地文本，各有核验者），所核实者皆采纳；Viability 的两条不变核之律由之重证，陈述不变；GuardHorizon 之桥留待环之槽位。')],
}
OUT.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('written', OUT.name)
