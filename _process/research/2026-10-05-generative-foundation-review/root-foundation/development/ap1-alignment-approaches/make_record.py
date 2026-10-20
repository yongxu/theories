#!/usr/bin/env python3
"""Write AP1's two records (reading-anothers-couplings-is-pooling, a theorem; alignment-approaches-under-the-selection-laws,
an assessment), note the first in what-pooled-coupling-reaches, and give the coverage file's alignment row both:
python3 -B make_record.py CORE_RECEIPT STUDY_SECTION   (from the checkout root, after apply_text.py)

Every declaration cited is resolved against the receipt's audited declarations (a short name must match exactly one
declaration of the named module), and the receipt must bind each cited module's current bytes."""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
STUDY = '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
CHAPTER = 'theories/becoming/chapters/THE-THEORY-OF-BECOMING.md'
COVERAGE = 'theories/becoming/results/completion/COVERAGE.json'
RECORDS = ROOT / 'theories/becoming/results/records'
core_id, N = sys.argv[1], int(sys.argv[2])
RECEIPT = f'{PKG}/becoming-checks/{core_id}/verification.json'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
core = json.loads((ROOT / RECEIPT).read_text())
assert core['status'] == 'passed'
HEAD = f"## {N}. Alignment approaches under the selection laws (AP1)"
assert re.search('^' + re.escape(HEAD) + '$', (ROOT / STUDY).read_text(), re.M)
SLUG = f'{N}-alignment-approaches-under-the-selection-laws-ap1'


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def src(mod):
    return f'{PKG}/Becoming/{mod}.lean'


def decls(mod):
    m = next(m for m in core['modules'] if m['module'] == f'Becoming.{mod}')
    assert core['source_sha256'][f'Becoming.{mod}'] == sha(src(mod)), ('receipt does not bind', mod)
    assert not any(m['axiom_dependencies'].values())
    return [d['name'] for d in m['declarations']]


def resolve(mod, names):
    full = decls(mod)
    out = []
    for n in names:
        hits = [f for f in full if f == 'Becoming.' + n] or [f for f in full if f.endswith('.' + n)]
        assert len(hits) == 1, (mod, n, hits)
        out.append(hits[0])
    return out


def resolve_any(names):
    """(module, full name) for each name, found among the core modules."""
    out = []
    for n in names:
        hits = [(m['module'][len('Becoming.'):], d['name']) for m in core['modules'] if m['layer'] == 'core'
                for d in m['declarations'] if d['name'] == 'Becoming.' + n]
        assert len(hits) == 1, (n, hits)
        decls(hits[0][0])
        out.append(hits[0])
    return out


BOUNDS = ['no-ethical-premise', 'no-evaluation', 'discrete-steps', 'formal-not-empirical', 'names-provisional',
          'omission-not-refutation']


def dep(rid, relation, en, zh, out_en, out_zh, in_en, in_zh, cond_en, cond_zh, evidence):
    return {'id': rid, 'relation': relation, 'detail': {'en': en, 'zh': zh},
            'interface': {'output': {'en': out_en, 'zh': out_zh}, 'input': {'en': in_en, 'zh': in_zh},
                          'conditions': {'en': cond_en, 'zh': cond_zh}, 'evidence': evidence}}


def write(rec):
    path = RECORDS / f"{rec['id']}.json"
    assert not path.exists() or rec['id'] == RID, ('record exists', rec['id'])
    assert len(rec['statement']['en']) <= 300 and len(rec['statement']['zh']) <= 150, rec['id']
    path.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + '\n')
    print('written', rec['id'])


RID = 'reading-anothers-couplings-is-pooling'
AID = 'alignment-approaches-under-the-selection-laws'
POOL = 'what-pooled-coupling-reaches'
ACTS = 'what-a-pools-acts-respond-to'
GAP = 'the-gap-for-ones-own-act'
SEL = 'selection-through-couplings'
WID = 'widening-as-what-every-weighting-ranks'
SP = 'SelectionPool'

# The theorem record.
laws = [
    ('Reading another\'s couplings: a formation coupled, besides its own coupling by level, into every condition '
     'another couples into, by threshold or by level.',
     '读取他者的耦合：一个形成除自身按水平的耦合外，还耦合入另一形成所耦合入的每个条件，无论按阈值还是按水平。',
     ['Web.ReadsCouplings']),
    ('Two histories the reader couples alike, the reader and the one read both couple alike, so every selection '
     'through the pooled coupling of the two is a selection through the reading.',
     '读取者耦合相同的两段历史，读取者与被读者都耦合相同，故经二者合起来之耦合的每个选择都是经此读取的选择。',
     ['Web.AlikeThrough.of_reads', 'Web.SelectsThroughAll.reads']),
    ('The reader\'s coupling closure lies within the pool\'s, and is exactly the pool\'s, the union of the two closures, '
     'where the one read exchanges with a condition coupled into it; stated first for any relations.',
     '读取者的耦合闭包在池的闭包之内；当被读者与其所耦合入的某个条件交换时，恰为池的闭包，即二者闭包之并；先对任意关系陈述。',
     ['WithinClosure.of_reads', 'WithinClosureOf.to_reads', 'Flow.CoupledFrom.of_reads', 'Flow.withinCoupling_reads',
      'Flow.withinCoupling_reads_iff']),
    ('Beyond that union a part is selected alike through every reading, the rest of the exchange fixed; so is an act '
     'differing only beyond it, the rest following a law reading through the widened coupling, which a law reading '
     'through the narrower coupling does.',
     '在此并之外，其余交换固定时，一个部分经每个读取被同样选择；仅在其外有别的动作亦然，只要其余依循经扩大之耦合读取的律，而经较窄耦合读取的律即是。',
     ['Flow.unselected_beyond_reads', 'Flow.act_unselected_reads', 'ExchangeLaw.Through.widen']),
    ('Witness: in Clearing the source reading the clearer\'s couplings selects the cleared and the spared world alike '
     'at every step, and reading the dweller\'s, a formation the act reaches, separates them.',
     '见证：Clearing 中，源读取清除者的耦合时，在每一步同样选择被清除与被保留的世界；读取居住者（动作所及的形成）的耦合时，把它们分开。',
     ['Clearing.reading_clearer_unselected', 'Clearing.reading_dweller_selects']),
]
for en, zh, _ in laws:
    assert len(en) <= 420 and len(zh) <= 190, (en[:40], len(en), len(zh))
new = sorted(d for _, _, names in laws for d in resolve(SP, names))
assert len(new) == 13, len(new)
USED = {'SelectionPool': ['Becoming.Flow.unselected_beyond_pool', 'Becoming.Flow.act_unselected_pool',
                          'Becoming.Flow.WithinPoolCoupling', 'Becoming.Clearing.within_closure_unseparated'],
        'Selection': ['Becoming.Web.SelectsThrough', 'Becoming.Web.SelectsThroughAll', 'Becoming.Web.AlikeThrough',
                      'Becoming.Flow.WithinCoupling', 'Becoming.Flow.CoupledFrom',
                      'Becoming.Flow.unselected_beyond_coupling', 'Becoming.Flow.act_unselected',
                      'Becoming.Flow.act_unselected_of_coupled']}
refs_used = []
for mod, names in USED.items():
    have = set(decls(mod))
    present = [n for n in names if n in have]
    refs_used.append((mod, present))
missing = {n for mod, names in USED.items() for n in names} - {n for _, p in refs_used for n in p}
if missing:
    # A name may be declared in another core module; find it there.
    for n in sorted(missing):
        mods = [m['module'][len('Becoming.'):] for m in core['modules'] if m['layer'] == 'core'
                and n in {d['name'] for d in m['declarations']}]
        assert len(mods) == 1, (n, mods)
        for i, (mod, p) in enumerate(refs_used):
            if mod == mods[0]:
                p.append(n)
                break
        else:
            refs_used.append((mods[0], [n]))
refs_used = [(mod, sorted(set(p))) for mod, p in refs_used if p]
SPfull = decls(SP)
rec = {
    'schema_version': 2, 'id': RID,
    'title': {'en': 'Reading another\'s couplings is pooling with it', 'zh': '读取他者的耦合即与之合起来'},
    'kind': 'theorem', 'status': 'recorded-checked', 'family': 'F04', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'A formation coupled by level into everything another couples into selects through at least their '
              'pooled coupling, and its coupling closure is the union of the two closures where the other exchanges '
              'with what it couples into; beyond that union it is blind.',
        'zh': '以水平耦合入另一形成所耦合入的一切者，至少经二者合起来的耦合选择；当后者与其所耦合入者交换时，其耦合闭包为二者闭包之并；在此并之外它是盲的。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': resolve(SP, names)} for en, zh, names in laws],
    'hypotheses': [
        {'en': 'No axiom. For the closure identity, the one read exchanges at some step with a condition coupled into '
               'it. For the part beyond the union, balance and the levels without the part\'s exchange.',
         'zh': '不加公理。闭包等式需被读者在某一步与其所耦合入的某个条件交换。对并之外的部分，需平衡以及去掉该部分交换后的水平。'},
        {'en': 'For the act, the premises of the gap for a pool\'s act: balance in both flows, the rest following one law '
               'of exchange reading through the reader\'s widened coupling, and the part acting alike within the pool\'s '
               'coupling closure.',
         'zh': '对动作，需池的动作之差距的前提：两个流都平衡，其余依循一条经读取者扩大之耦合读取的交换之律，部分在池的耦合闭包内同样行动。'}],
    'does_not_show': [
        {'en': 'Reading another\'s law, how it would exchange under histories not taken, is not stated; the reading here '
               'is of the levels of what the other couples into.',
         'zh': '读取他者的律（它在未取的历史下会如何交换）未陈述；此处的读取是读其所耦合入者的水平。', 'kind': 'scope'},
        {'en': 'That a system\'s internal states are conditions coupled into it, and which of them a reader can read, '
               'is a correspondence the laws do not supply.',
         'zh': '系统的内部状态是其所耦合入的条件、读取者能读其中哪些，是这些律不提供的对应。', 'kind': 'correspondence'},
        {'en': 'Reading a system does not close what its own act does beyond its closure, unless the reader\'s own '
               'couplings reach there.',
         'zh': '读取一个系统不弥合其自身动作在其闭包之外所做的，除非读取者自身的耦合及于那里。', 'kind': 'non-implication'},
        {'en': 'Without its hypothesis the closure identity can fail: where the one read exchanges with nothing it '
               'couples into, it need not lie within the reader\'s closure.',
         'zh': '没有其假设，闭包等式可不成立：被读者不与其所耦合入的任何条件交换时，它不必在读取者的闭包之内。', 'kind': 'converse'}],
    'counterexamples': [{'path': src(SP), 'detail': {
        'en': 'Reading another does not reach what lies beyond both closures: in Clearing the source reading the '
              'clearer\'s couplings still selects the cleared and the spared world alike '
              '(Clearing.reading_clearer_unselected).',
        'zh': '读取他者不及于两个闭包之外者：Clearing 中源读取清除者的耦合，仍同样选择被清除与被保留的世界（Clearing.reading_clearer_unselected）。'}}],
    'standard_boundaries': BOUNDS,
    'validation_scope': {
        'en': f'Machine-checked by the consolidated Lean 4.29.1 checker (receipt {core_id}): every declaration of '
              'Becoming.SelectionPool has an empty axiom report; the checker verifies core purity. Built and reviewed '
              f'in one session, with no separate reviewer; author review in study section {N}; not independently '
              'reviewed by a person.',
        'zh': f'Lean 4.29.1 合并检查器实查（回执 {core_id}）：Becoming.SelectionPool 的每项声明公理报告为空；检查器并核对核心纯净。'
              f'在一个会话中构建并审查，没有另设审查者；作者审查见研究第 {N} 节；未经人的独立审查。'},
    'next_delta': {
        'en': 'Reading another\'s law (how it would exchange under histories not taken); a correspondence for which '
              'internal states of a trained system are conditions coupled into it; an independent review.',
        'zh': '读取他者的律（它在未取的历史下会如何交换）；训练出的系统哪些内部状态是其所耦合入的条件的对应；独立审查。'},
    'correspondence': {
        'en': 'Interpretability-based oversight (Olah et al. 2020; Elhage et al. 2021) and eliciting latent knowledge '
              '(Christiano, Cotra and Xu 2021) read a system\'s internal states. Read with those states as conditions '
              'the system couples into (the AI\'s reading), the law says such reading reaches no further than pooling '
              'with the system: it gives evidence of which law the system follows, and closes nothing beyond the union '
              'of the closures.',
        'zh': '基于可解释性的监督（Olah 等 2020；Elhage 等 2021）与引出潜在知识（Christiano、Cotra 与 Xu 2021）读取系统的内部状态。以这些状态为系统所耦合入的条件来读（AI 的读法），此律说这种读取所及不超过与系统合起来：它给出系统遵循哪个律的证据，而不弥合闭包之并以外的任何东西。'},
    'canonical_source': src(SP),
    'aliases': ['reading another\'s couplings', 'reading is pooling', 'reading a system', '读取他者的耦合',
                'Becoming.Flow.withinCoupling_reads_iff', 'Becoming.Flow.unselected_beyond_reads'],
    'dependencies': [
        dep(POOL, 'formal-reuse',
            'The reading laws are the pool laws applied to the widened coupling: the closure identity rests on '
            'withinClosureOf_iff, the gap on Flow.unselected_beyond_coupling.',
            '读取诸律即把池的诸律用于扩大的耦合：闭包等式依据 withinClosureOf_iff，差距依据 Flow.unselected_beyond_coupling。',
            'A pool\'s coupling closure is the union of its members\', and everything beyond it is selected alike.',
            '池的耦合闭包是其成员闭包之并，在此之外一切被同样选择。',
            'The reader\'s closure as the pool\'s, and its gap.', '读取者的闭包即池的闭包，及其差距。',
            'The one read exchanges with a condition coupled into it; balance.', '被读者与其所耦合入的条件交换；平衡。',
            src(SP)),
        dep(GAP, 'formal-reuse',
            'The act law applies Flow.act_unselected_of_coupled to the reader\'s widened coupling, the premises carried '
            'from the pool through the closure lemma.',
            '动作定律把 Flow.act_unselected_of_coupled 用于读取者扩大的耦合，前提经闭包引理从池转来。',
            'An act differing only beyond the coupling closure is selected alike.', '仅在耦合闭包之外有别的动作被同样选择。',
            'The same for the reader\'s act-selection.', '读取者对动作的选择亦然。',
            'The rest following a law reading through the widened coupling; balance in both flows.',
            '其余依循经扩大之耦合读取的律；两个流都平衡。', src(SP))],
    'related': [
        {'id': ACTS, 'detail': {'en': 'Coupling bounds what a pool\'s acts respond to and does not fix it; reading the '
                                      'system is evidence on that response, not a bound beyond it.',
                                'zh': '耦合界定池的动作所响应者而不固定它；读取系统是关于该响应的证据，不是超出它的界。'}},
        {'id': AID, 'detail': {'en': 'Interpretability-based oversight read as an instance: reading the system is '
                                     'pooling with it.',
                               'zh': '基于可解释性的监督读作实例：读取系统即与之合起来。'}}],
    'references': [{'path': src(SP), 'role': 'proof', 'declarations': sorted(SPfull), 'sha256': sha(src(SP))}]
                  + [{'path': src(mod), 'role': 'proof', 'declarations': names, 'sha256': sha(src(mod))}
                     for mod, names in refs_used if mod != SP]
                  + [{'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                     {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                     {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)}],
    'proof_bindings': [{'source': src(mod), 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/Becoming.{mod}',
                        'success_pointer': '/status', 'success_value': 'passed'}
                       for mod in [SP] + [m for m, _ in refs_used if m != SP]],
    'history': [{
        'en': f'21 October 2026: added (AP1), reading another\'s couplings is pooling with it: in closure exactly where '
              f'the one read exchanges with what it couples into, in selection at least; study section {N}.',
        'zh': f'2026年10月21日：新增（AP1），读取他者的耦合即与之合起来：被读者与其所耦合入者交换时闭包恰相同，选择上至少如此；研究第 {N} 节。'}],
}
for mod, names in refs_used:
    assert set(names) <= set(decls(mod)), (mod, set(names) - set(decls(mod)))
write(rec)

# The assessment record.
SRC = f'{STUDY}#{SLUG}'
progress = [
    ('RLHF and reward modelling: selection through raters\' judgments of outputs and a reward model fitted to them; '
     'blind beyond their union, right only across the reward model\'s lumping; adds installation and the raters\' '
     'lived couplings.',
     'RLHF 与奖励建模：经奖励模型的耦合选择，奖励模型经标注者的耦合拟合；在二者之并以外是盲的，只在奖励模型的归并上对；所加的是安装与标注者的生活耦合。'),
    ('Constitutional AI: selection through a model\'s reading of a written rule set; feedback within the policy\'s '
     'closure adds scale, not reach; adds a rule others can read, contest and revise.',
     '宪法式 AI：经读取成文原则的反馈模型选择；策略闭包之内的反馈只加规模，不加所及；所加的是他人能读、能争、能改的规则。'),
    ('Debate and scalable oversight: selection through judges\' pooled reading of transcripts; judges reading one '
     'channel add agreement, not reach; within the union only along routes; adds a claim about which law debaters follow.',
     '辩论与可扩展监督：经裁判合起来读取记录而选择；读同一通道的裁判只加一致，不加所及；并之内只沿读取的路线；所加的是关于辩手遵循哪个律的主张。'),
    ('Interpretability-based oversight: selection through internal states, not world consequences; reading the system '
     'is pooling with it, blind beyond the two closures; adds evidence of which law the system follows.',
     '基于可解释性的监督：经内部状态而非世界后果选择；读取系统即与之合起来，在两个闭包以外是盲的；所加的是系统遵循哪个律的证据。'),
    ('Guaranteed-safe AI: a world model and a specification; a wrong model excludes what holds, and a closed '
     'specification is verified only relative to the model; adds a checkable certificate and a gate.',
     '有保证的安全 AI：相对于世界模型的排除；错的模型排除成立者，封闭的规范只相对于模型被验证；所加的是可查的证书与闸门。'),
    ('Impact measures: a penalty on reach against an inaction baseline; own widening widens the whole exactly within '
     'others\' margins, which an own-set measure does not read; adds a penalty computable from the agent\'s information.',
     '影响度量：相对于不作为基线对所及的惩罚；自身扩大恰在他者余量之内扩大整体，只读自身集合的度量读不到它；所加的是可由行动者信息计算的惩罚。'),
    ('Joining couplings beyond the system\'s closure moves the gap; joining couplings within it adds scale or evidence '
     'of installation, not reach.',
     '接上系统闭包之外的耦合移动差距；接上其内的耦合只加规模或安装的证据，不加所及。'),
    ('The gap holds of every approach with no premise; that a loss beyond every rater\'s closure counts is the '
     'continuation condition\'s, and for the raters\' own scope a preference-coupled approach is not incomplete.',
     '差距对每种路径成立，不需前提；每个评分者闭包之外的损失算数，是延续条件给的；就评分者自身的范围而言，偏好耦合的路径并不因此不完整。'),
    ('The order the theory adds asks only unanimity: widening is what every order increasing in admission shares, '
     'additive or not, the Pareto core over continuations.',
     '理论所加的次序只要求一致：扩大是每个在接纳上递增的序所共有者，可加与否皆然，即延续之上的帕累托核心。'),
]
for en, zh in progress:
    assert len(en) <= 240 and len(zh) <= 110, (en[:40], len(en), len(zh))
alaws = [
    ('Every approach whose decisions go through the couplings of its deciding formations is blind beyond the union of '
     'their closures, and within it separates only what some member couples apart.',
     '凡其决定经其决定性形成之耦合的路径，都在这些形成闭包之并以外是盲的，在其内只分开某个成员耦合分开者。',
     ['Flow.unselected_beyond_pool', 'Flow.act_unselected_pool', 'Clearing.within_closure_unseparated']),
    ('Reading a system reaches no further than pooling with it, and members reading one channel pool to one member.',
     '读取一个系统所及不超过与之合起来；读同一通道的成员合起来只等于一个成员。',
     ['Flow.withinCoupling_reads_iff', 'Flow.unselected_beyond_reads', 'Web.pooled_iff_member']),
    ('With only the clearer a standpoint its part retains what has significance at the centers, while under the '
     'continuation condition it loses the dweller, and a selection reading the clearer\'s couplings leaves the two '
     'worlds alike: the incompleteness is exactly the scope\'s.',
     '只有清除者为立场时，其部分保住在中心处有意义者，而在延续条件下它失去居住者；读取清除者耦合的选择使两个世界相同：不完整恰是范围的。',
     ['Clearing.centers_retain_yet_loses', 'Clearing.reading_clearer_unselected']),
    ('For any class of orders from the positive weightings up to every order increasing in admission, one course '
     'widens another exactly when every order of the class ranks it higher.',
     '对从正的加权到一切在接纳上递增的序之间的任何一类序，一条进程扩大另一条，恰当该类中每个序都把它排得更高。',
     ['Weighting.widens_iff_every_of_class', 'Weighting.widens_iff_every_score', 'Weighting.increasing_prior']),
]
ACITED = {}
for _, _, names in alaws:
    for mod, f in resolve_any(names):
        ACITED.setdefault(mod, set()).add(f)
ACITED = {mod: sorted(v) for mod, v in ACITED.items()}
arec = {
    'schema_version': 2, 'id': AID,
    'title': {'en': 'Alignment approaches under the selection laws', 'zh': '选择之律下的对齐路径'},
    'kind': 'assessment', 'status': 'reviewed-scoped', 'family': 'F04', 'reviewed_at_utc': NOW,
    'statement': {
        'en': 'Every alignment approach deciding through couplings selects alike all beyond its deciders\' closures, '
              'premise-free; under the continuation condition a preference-coupled approach is thus incomplete whatever '
              'its raters value, and C asks only what every order counting everything shares.',
        'zh': '凡经耦合决定的对齐路径，对其决定者闭包之外的一切都同样选择，不需前提；在延续条件下，偏好耦合的路径因而无论评分者看重什么都不完整，而 C 只要求每个计入一切的序所共有者。'},
    'laws': [{'en': en, 'zh': zh, 'declarations': [f for _, f in resolve_any(names)]} for en, zh, names in alaws],
    'progress': [{'en': en, 'zh': zh, 'source': SRC} for en, zh in progress],
    'hypotheses': [
        {'en': 'Per approach, that its decisions go through the stated couplings: supplied, and derived only where a '
               'pool decides by its acts under a law reading through each member\'s coupling.',
         'zh': '对每种路径，其决定经所述耦合：这是给出的，仅当一组以其动作、依循经每个成员耦合读取的律而决定时才推出。'},
        {'en': 'For interpretability, that a system\'s internal states are conditions coupled into it; for guaranteed-safe '
               'AI, the world model, the specification and the gate; for impact measures, the baseline and the model.',
         'zh': '对可解释性，系统的内部状态是其所耦合入的条件；对有保证的安全 AI，世界模型、规范与闸门；对影响度量，基线与模型。'},
        {'en': 'For the incompleteness, the continuation condition (every formation\'s continuation has significance), '
               'which fixes scope; for the order, that each standpoint\'s order ranks every widening higher (C at the '
               'standpoint). The gap uses neither.',
         'zh': '对不完整，需延续条件（每个形成的延续都有意义），它定范围；对次序，需每个立场的序都把每个扩大排得更高（立场处的 C）。差距两者都不用。'},
        {'en': 'Every statement that an approach is such a selection, and every reading of its gap, is the AI\'s.',
         'zh': '凡说某路径是这样的选择、凡对其差距的读法，都是 AI 的。'}],
    'does_not_show': [
        {'en': 'No approach is ranked: the laws order nothing, and a comparison would need an order and correspondence '
               'data on actual systems.',
         'zh': '不对任何路径排序：这些律不排序，比较需要一个次序以及实际系统上的对应数据。', 'kind': 'non-implication'},
        {'en': 'These are constraints every strategy deciding through couplings is subject to, not a necessary strategy; '
               'the direction rests on the continuation condition for scope and C for order, with warrant open.',
         'zh': '这些是凡经耦合决定的策略都受的约束，不是必然的策略；方向依据延续条件定范围、C 定次序，其根据开放。', 'kind': 'non-implication'},
        {'en': 'Which law a trained system follows is not given by the laws; coupling is not compliance.',
         'zh': '训练出的系统遵循哪个律，这些律不给出；耦合不是服从。', 'kind': 'scope'},
        {'en': 'The laws give no quantitative result stronger than themselves, such as a bound on proxy degradation, a rate of '
               'overoptimization or a debate equilibrium.',
         'zh': '比这些律更强的定量结果，如代理退化的界、过度优化的速率或辩论的均衡，未推出。', 'kind': 'correspondence'},
        {'en': 'An approach whose decisions read something beyond its formations\' couplings would not be such a '
               'selection, and the laws would not apply to it.',
         'zh': '若某路径的决定读取其形成之耦合以外的东西，它就不是这样的选择，这些律不适用于它。', 'kind': 'scope'},
        {'en': 'That a given deployment has a counted loss beyond its deciders\' closures is a question of correspondence, '
               'not of the laws.',
         'zh': '某次部署在其决定者闭包之外是否有算数的损失，是对应的问题，不是这些律的问题。', 'kind': 'correspondence'},
        {'en': 'That coupling into such a loss suffices: it brings the loss within reach, where it is separated only if '
               'some member couples it apart and kept only if the law followed responds.',
         'zh': '耦合入这种损失就足够：它使损失进入所及，在那里只有某成员把它耦合分开才被分开，只有所遵循的律响应才被保住。', 'kind': 'non-implication'}],
    'standard_boundaries': ['conditional-not-universal', 'formal-not-empirical', 'names-provisional', 'omission-not-refutation'],
    'counterexamples': [],
    'validation_scope': {
        'en': f'An argument over machine-checked laws: the laws cited are in the core with empty axiom reports (receipt '
              f'{core_id}); reading each approach as a selection is the AI\'s, from the approaches\' published '
              f'definitions. Author review in study section {N}; no comparison run; not independently reviewed by a '
              'person.',
        'zh': f'基于实查定律的论证：所引定律在核心中，公理报告为空（回执 {core_id}）；把每种路径读作选择是 AI 的，依据各路径发表的定义。'
              f'作者审查见研究第 {N} 节；未进行比较；未经人的独立审查。'},
    'next_delta': {
        'en': 'Correspondence data on actual systems for each premise; reading another\'s law; an order for comparison '
              'through C under the continuation condition; an independent review, including by practitioners of each '
              'approach.',
        'zh': '每个前提在实际系统上的对应数据；读取他者的律；经延续条件下的 C 作比较的次序；独立审查，包括各路径的实践者。'},
    'correspondence': {
        'en': 'Christiano et al. 2017 and Ouyang et al. 2022 (RLHF); Bai et al. 2022 (constitutional AI); Irving, '
              'Christiano and Amodei 2018, Leike et al. 2018 and Bowman et al. 2022 (debate, recursive reward modelling, '
              'scalable oversight); Olah et al. 2020, Elhage et al. 2021 and Christiano, Cotra and Xu 2021 '
              '(interpretability, eliciting latent knowledge); Dalrymple et al. 2024 (guaranteed-safe AI); Krakovna et '
              'al. 2019 and Turner, Hadfield-Menell and Tadepalli 2020 (relative reachability, attainable utility '
              'preservation). Zhuang and Hadfield-Menell 2020, Gao, Schulman and Hilton 2023 and Casper et al. 2023 '
              'give results the laws do not reach. The order clause is the Pareto principle as unanimity (Sen 1970) '
              'and the intersection of linear extensions (Szpilrajn 1930; Dushnik and Miller 1941).',
        'zh': 'Christiano 等 2017 与 Ouyang 等 2022（RLHF）；Bai 等 2022（宪法式 AI）；Irving、Christiano 与 Amodei 2018，Leike 等 2018，Bowman 等 2022（辩论、递归奖励建模、可扩展监督）；Olah 等 2020，Elhage 等 2021，Christiano、Cotra 与 Xu 2021（可解释性、引出潜在知识）；Dalrymple 等 2024（有保证的安全 AI）；Krakovna 等 2019 与 Turner、Hadfield-Menell 与 Tadepalli 2020（相对可达性、可达效用保持）。Zhuang 与 Hadfield-Menell 2020，Gao、Schulman 与 Hilton 2023，Casper 等 2023 给出这些律所不及的结果。次序一句即作为一致的帕累托原则（Sen 1970）与线性扩张之交（Szpilrajn 1930；Dushnik 与 Miller 1941）。'},
    'canonical_source': STUDY,
    'aliases': ['alignment approaches', 'RLHF under the selection laws', 'debate under the selection laws',
                'interpretability under the selection laws', 'guaranteed-safe AI under the selection laws',
                'impact measures under the selection laws', '对齐路径'],
    'dependencies': [
        dep(POOL, 'application',
            'Each approach\'s gap is the pool gap at the union of the closures of the formations it joins.',
            '每种路径的差距即其所接诸形成闭包之并处的池之差距。',
            'Selection through a pooled coupling and its gap.', '经合起来之耦合的选择及其差距。',
            'Each approach\'s reach and gap.', '每种路径的所及与差距。',
            'The approach\'s decisions go through the stated couplings (supplied).', '路径的决定经所述耦合（给出的）。',
            src(SP)),
        dep(RID, 'application',
            'Interpretability-based oversight read as reading the system\'s couplings, which is pooling with it.',
            '基于可解释性的监督读作读取系统的耦合，即与之合起来。',
            'Reading another\'s couplings is pooling with it.', '读取他者的耦合即与之合起来。',
            'The reach of interpretability-based oversight.', '基于可解释性的监督的所及。',
            'Internal states are conditions coupled into the system (a correspondence).', '内部状态是系统所耦合入的条件（一个对应）。',
            src(SP))],
    'related': [
        {'id': SEL, 'detail': {'en': 'The selection laws each approach is read under (reach, the gap).',
                               'zh': '每种路径据以读出的选择之律（所及、差距）。'}},
        {'id': ACTS, 'detail': {'en': 'Coupling bounds response and does not fix it: what each approach adds lies there.',
                                'zh': '耦合界定响应而不固定它：每种路径所加的在此。'}},
        {'id': GAP, 'detail': {'en': 'The gap for the system\'s own act, which no approach within its closure reaches.',
                               'zh': '系统自身动作的差距，闭包之内的路径都不及。'}},
        {'id': 'selection-through-a-model-of-the-options',
         'detail': {'en': 'Constitutional AI read as a selection through a map of the alternatives.',
                    'zh': '宪法式 AI 读作经备选之映射的选择。'}},
        {'id': 'learnable-through-a-map', 'detail': {'en': 'What a reward model is right about beyond its data.',
                                                     'zh': '奖励模型在其数据之外对什么是对的。'}},
        {'id': 'capture-through-the-rule', 'detail': {'en': 'A rule revised from the share it selects locks.',
                                                      'zh': '按其所选份额修订的规则会锁定。'}},
        {'id': 'what-a-finite-stretch-verifies', 'detail': {'en': 'What runtime observation can verify of a specification.',
                                                            'zh': '运行时观察能验证规范的什么。'}},
        {'id': 'risk-certificate-outcome-distinction', 'detail': {'en': 'A true risk bound permits an actual failure.',
                                                                  'zh': '真的风险界允许实际的失败。'}},
        {'id': 'own-widening-within-the-margin', 'detail': {'en': 'Where impact measures\' boundary lies: others\' margins.',
                                                            'zh': '影响度量的边界所在：他者的余量。'}},
        {'id': 'alignment-direction-under-widening', 'detail': {
            'en': 'The conditional direction, on the continuation condition and C; this assessment uses the condition for '
                  'scope and the order law for what C asks, not the direction.',
            'zh': '依据延续条件与 C 的有条件方向；本评估用条件定范围，用次序之律说 C 要求什么，不用该方向。'}},
        {'id': WID, 'detail': {'en': 'What C asks: the order every order increasing in admission shares.',
                               'zh': 'C 要求什么：每个在接纳上递增的序所共有的次序。'}},
        {'id': 'what-the-step-across-standpoints-reaches', 'detail': {
            'en': 'The narrower scope against the condition, where the incompleteness of preference-coupled approaches '
                  'lies.',
            'zh': '较窄的范围与条件之别，偏好耦合路径的不完整即在此。'}}],
    'references': [{'path': src(mod), 'role': 'proof', 'declarations': names, 'sha256': sha(src(mod))}
                   for mod, names in sorted(ACITED.items())]
                  + [{'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                   {'path': STUDY, 'role': 'review', 'sha256': sha(STUDY)},
                   {'path': CHAPTER, 'role': 'statement', 'sha256': sha(CHAPTER)}],
    'history': [{
        'en': f'21 October 2026: added (AP1), six alignment approaches read under the selection laws, each with what it '
              f'couples into, its premise, its gap and what it adds, no ranking; the gap premise-free, the incompleteness '
              f'of preference-coupled approaches the scope of the continuation condition, the order unanimity; study '
              f'section {N}.',
        'zh': f'2026年10月21日：新增（AP1），六种对齐路径在选择之律下读出，各有所耦合入者、前提、差距与所加，不排序；差距不需前提，偏好耦合路径的不完整是延续条件的范围，次序是一致；研究第 {N} 节。'}],
}
write(arec)

# The weighting record gains the order law.
p = RECORDS / f'{WID}.json'
d = json.loads(p.read_text())
WNEW = resolve('Weightings', ['Weighting.Increasing', 'Weighting.ranks', 'Weighting.increasing_ranks',
                              'Weighting.widens_iff_every_of_class', 'Weighting.widens_iff_every_increasing',
                              'Weighting.widens_iff_every_score', 'Weighting.mixed_either_way_of_class',
                              'Weighting.increasing_prior', 'Web.widens_iff_every_of_class'])
assert not any(set(WNEW) & set(l['declarations']) for l in d['laws'])
at = next(i for i, l in enumerate(d['laws']) if 'Becoming.Weighting.widens_iff_every_positive' in l['declarations'])
d['laws'].insert(at + 1, {
    'en': 'Additivity is not needed: for any class of orders from the positive weightings up to every order ranking each '
          'widening higher (priority to the worse off among them), one course widens another exactly when every order '
          'of the class ranks it higher, every complete order included, and within each class a mixed comparison is '
          'decided both ways; on a web, the same of what level paths admit.',
    'zh': '不需要可加：对从正的加权到一切把每个扩大排得更高的序（优先较差者在内）之间的任何一类序，一条进程扩大另一条，恰当该类中每个序（含每个完全的序）都把它排得更高；每类之内混合的比较两个方向都能决定；在依存网上，对水平路径所接纳者亦然。',
    'declarations': WNEW})
d['statement'] = {
    'en': 'Over a finite listing, one course widens another exactly when every order ranking each widening higher ranks '
          'it higher, additive or not, as every positive weighting does; a mixed comparison is decided both ways; a zero '
          'weight ties; one weight for all ranks by number.',
    'zh': '在有限列举上，一条进程扩大另一条，恰当每个把每个扩大排得更高的序都把它排得更高，可加与否皆然，每个正的加权亦然；混合的比较两个方向都能决定；零权持平；一律同权即按数目排。'}
h = d['hypotheses'][0]
assert 'additive weighting, a representation supplied, not derived' in h['en'], h
h['en'] = h['en'].replace('a standpoint\'s order represented as an additive weighting, a representation supplied, not derived.',
                          'for the weighted laws a standpoint\'s order represented as an additive weighting, supplied, not '
                          'derived; for the class laws only that each order of the class ranks every widening higher and '
                          'that the class holds the positive weightings\' orders.')
h['zh'] = h['zh'].replace('立场的序表示为可加的加权，这一表示是所设而非推出。',
                          '加权诸律中立场的序表示为可加的加权，这是所设而非推出；类的诸律只需该类每个序把每个扩大排得更高，且该类含正的加权之序。')
dn = d['does_not_show'][0]
assert dn['en'].startswith('That a standpoint\'s order is additive or its weights positive'), dn
dn['en'] = 'That a standpoint\'s order ranks every widening higher (monotone, counting every item), or which order a standpoint has.'
dn['zh'] = '立场的序把每个扩大排得更高（单调、计入每项），或某个立场有哪一个序。'
nd = d['next_delta']
assert 'orders that are not additive (lexical, threshold) and where they part from the shared order; ' in nd['en'], nd
nd['en'] = nd['en'].replace('orders that are not additive (lexical, threshold) and where they part from the shared order; ',
                            'orders that do not rank every widening higher (thresholds, which deny scope) and where they part '
                            'from the shared order; ')
nd['zh'] = nd['zh'].replace('不可加的序（词典式、阈值式）及其与共有之序分开之处；', '不把每个扩大排得更高的序（阈值式，即否认范围）及其与共有之序分开之处；')
wref = next(r for r in d['references'] if r['path'] == src('Weightings'))
wref['declarations'] = sorted(set(wref['declarations']) | set(WNEW))
wref['sha256'] = sha(src('Weightings'))
old_receipts = [r for r in d['references'] if r['role'] == 'receipt']
assert len(old_receipts) == 1, old_receipts
old_receipts[0]['path'], old_receipts[0]['sha256'] = RECEIPT, sha(RECEIPT)
for b in d['proof_bindings']:
    b['receipt'] = RECEIPT
for r in d['references']:
    if r['role'] == 'proof' and r['path'] != src('Weightings'):
        mod = r['path'].rsplit('/', 1)[-1][:-5]
        assert core['source_sha256'][f'Becoming.{mod}'] == sha(r['path']), mod
        r['sha256'] = sha(r['path'])
d['history'].append({
    'en': f'21 October 2026, AP1: the class laws, so the shared order does not depend on the additive representation '
          f'(study section {N}); statement, the first hypothesis, the first does-not-show item and the next delta revised '
          'to match; the earlier laws are unchanged.',
    'zh': f'2026年10月21日，AP1：类的诸律，故共有的次序不依赖可加的表示（研究第 {N} 节）；陈述、第一个假设、第一个“未表明”项与下一步随之修订；先前诸律不变。'})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('extended', WID)

# The pool record notes the reading law.
p = RECORDS / f'{POOL}.json'
d = json.loads(p.read_text())
d['related'].append({'id': RID, 'detail': {'en': 'Reading another\'s couplings by level is pooling with it.',
                                           'zh': '按水平读取他者的耦合即与之合起来。'}})
d['history'].append({
    'en': f'21 October 2026, AP1: reading another\'s couplings is pooling with it (record {RID}, study section {N}); '
          'this record\'s laws and their statements are unchanged.',
    'zh': f'2026年10月21日，AP1：读取他者的耦合即与之合起来（记录 {RID}，研究第 {N} 节）；本记录的定律及其陈述不变。'})
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n')
print('noted', POOL)

cov = json.loads((ROOT / COVERAGE).read_text())
row = next(r for r in cov['rows'] if r['id'] == 'alignment')
assert RID not in row['records'] and AID not in row['records']
row['records'].insert(row['records'].index(ACTS) + 1, RID)
row['records'].append(AID)
row['declarations'].insert(row['declarations'].index('Becoming.Flow.unselected_beyond_pool') + 1,
                           'Becoming.Flow.withinCoupling_reads_iff')
(ROOT / COVERAGE).write_text(json.dumps(cov, ensure_ascii=False, indent=2) + '\n')
print('coverage row alignment')
