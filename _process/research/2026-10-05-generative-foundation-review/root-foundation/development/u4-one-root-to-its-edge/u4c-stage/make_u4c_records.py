#!/usr/bin/env python3
"""U4c's record and chapter edits, for its stage in OU7's rebuild (CENSUS-ON-THE-ROOT.md §5, §6 and Appendix A).

From the checkout root of a tree whose records and chapters are main's (records and chapters are untouched by the kit's
apply, so main itself or the throwaway tree after it):

  python3 -B <dir>/make_u4c_records.py [BASE]   edit the records and chapters in place; BASE (default main) gives the
                                                hashes of the new references and the receipts already binding them

Steps, each asserting that the text it replaces is there exactly once:
  move      the twenty records whose declaration lists name a moved lemma under Population, Change or Flow: each such
            declaration moves to a Becoming.Prelude reference, added with its proof binding where the record has none;
            in closing-needs-net-draw and orders-as-a-sum-over-histories the Change.lean reference, left empty, goes
            with its binding, nothing the record says resting on that file
  ceasing   ceasing-needs-arising: law 2 for the route through the root's census of a run, its declarations with it;
            the census balance moves from its dependencies to related; the root's census among its dependencies
  census    census-balance-under-continuation: laws 3 and 4, the second hypotheses entry, the related note on
            not_not_all, the root's census among its dependencies
  balance   census-balance: the root's census among its dependencies (Listed.across_at, law 8)
  master    master-laws-on-the-grammar: law 4 gains the three laws and the corollary, law 3 the five list lemmas they
            use, the GrammarLaws reference all nine, the validation scope U4c's derivations, statements and review
  edge      one-root-to-its-edge: the two entries from make_record_u4.py in U4c's state, the review and the design among
            the references, next_delta
  chapters  01 §7 (the census laws after HE2's, and the root theorem's sentence on a model's statement), 01 §9.5 (the
            census-under-continuation row's clause), 08 §7 (the standings' counts and U4c's derived row), and the
            release gate's line on the two census rows (WHAT-REMAINS)

Each record changed gets one history note in both languages, its date and the study section left as {DAY}, {DAY_ZH}
and {N} for the landing to fill. Source hashes are main's; the landing's one re-point pass rebinds them to its receipt.
"""
import hashlib
import importlib.util
import json
import os
import subprocess
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
DEV = HERE.parent
BASE = next((a for a in sys.argv[1:] if not a.startswith('--')), 'main')
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/'
RECS = 'theories/becoming/results/records/'
CHECKS = PKG + 'becoming-checks/'
U4 = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u4-one-root-to-its-edge/'


def src(module):
    return PKG + 'Becoming/' + module + '.lean'


# The fifteen lemmas that move to the prelude (CENSUS-ON-THE-ROOT.md §5), each with the module it leaves.
MOVED = {**{n: 'Population' for n in ['mem_remove', 'length_le_of_matched', 'not_not_all', 'gaining_of_losing',
                                       'losing_of_gaining', 'recurs_shift', 'recurs_unshift', 'gaining_of_losing_from',
                                       'losing_of_gaining_from']},
         **{n: 'Change' for n in ['steps_mem', 'steps_last', 'steps_mono', 'recurring_accumulates', 'pos_of_exceeds']},
         'total_pos': 'Flow'}
GENERALIZED = ['mem_remove', 'length_le_of_matched', 'not_not_all']
EMPTIED = {'closing-needs-net-draw', 'orders-as-a-sum-over-histories'}
TWENTY = sorted(['bounded-census-keeps-pace', 'ceasing-needs-arising', 'census-balance-under-continuation',
                 'census-balance', 'closing-needs-net-draw', 'coming-and-ceasing-keep-pace',
                 'continued-change-needs-openness', 'counting-under-enclosure', 'generation-is-replenishment',
                 'how-often-couplings-act', 'identity-across-steps', 'laws-of-one-step', 'more-needs-renewers',
                 'no-finite-part-bears-taking', 'orders-as-a-sum-over-histories', 'rest-at-every-resolution',
                 'rising-and-falling-in-one-exchange', 'support-from-the-supported', 'what-a-cut-loses',
                 'whole-law-of-counting'])
STEP, STEP_MIRROR, PAIRED, RUN = ('Becoming.«定后则后并亡不过前并生»', 'Becoming.«定前则前并生不过后并亡»',
                                  'Becoming.«定后定前则前并生与后并亡同数»', 'Becoming.«定后前者在前则亡屡者生屡»')
LIST_LEMMAS = ['Becoming.GrammarLaws.' + n for n in ['length_keep', 'count_add_not', 'distinct_keep',
                                                     'count_pos_of_mem', 'eq_true_of_not_false']]
# Each of the four laws is the corollary of a local form beside it, asking no split (no merge) only among the listed
# units, as master-laws' first hypothesis says of every global form.
LOCAL = ['Becoming.GrammarLaws.' + n for n in ['census_le', 'census_le_converse', 'census_count', 'census_run']]
CENSUS_LAWS = [d for pair in zip(LOCAL, [STEP, STEP_MIRROR, PAIRED, RUN]) for d in pair]
DESIGN, REVIEW_DESIGN, REVIEW_RECORD = (U4 + 'CENSUS-ON-THE-ROOT.md', U4 + 'REVIEW-U4C.md',
                                        U4 + 'REVIEW-U4C-RECORD.md')
NOTE_EN, NOTE_ZH = '{DAY}, U4c (study section {N}): ', '{DAY_ZH}，U4c（研究第 {N} 节）：'


def base_bytes(path):
    return subprocess.run(['git', 'show', f'{BASE}:{path}'], cwd=ROOT, capture_output=True, check=True).stdout


def digest(data):
    return hashlib.sha256(data).hexdigest()


_receipts = {}


def receipt_for(path):
    """A passing receipt that binds the base's text of a Lean source: the latest one a record already binds it to."""
    if path not in _receipts:
        sha, module = digest(base_bytes(path)), 'Becoming.' + Path(path).stem
        found = set()
        for f in (ROOT / RECS).glob('*.json'):
            r = json.loads(f.read_text(encoding='utf-8'))
            refs = {x['path']: x for x in r.get('references', [])}
            found |= {b['receipt'] for b in r.get('proof_bindings', [])
                      if b['source'] == path and refs.get(path, {}).get('sha256') == sha}
        for receipt in sorted(found, reverse=True):
            data = json.loads((ROOT / receipt).read_text(encoding='utf-8'))
            if data['source_sha256'].get(module) == sha and data['status'] == 'passed':
                _receipts[path] = receipt
                break
        else:
            raise SystemExit(f'no receipt binds the base text of {path}')
    return _receipts[path]


def load(rid):
    return json.loads((ROOT / RECS / f'{rid}.json').read_text(encoding='utf-8'))


def save(r):
    (ROOT / RECS / f"{r['id']}.json").write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def ref_of(r, path):
    got = [x for x in r['references'] if x['path'] == path]
    assert len(got) <= 1, (r['id'], path)
    return got[0] if got else None


def ensure_ref(r, module, names):
    """The proof reference of a module, added after the last proof reference with its binding (to a receipt binding the
    base's text, among the references) where the record has none; names are added to it, in order, once."""
    path = src(module)
    ref = ref_of(r, path)
    if ref is None:
        ref = {'path': path, 'role': 'proof', 'sha256': digest(base_bytes(path)), 'declarations': []}
        last = max(i for i, x in enumerate(r['references']) if x['role'] == 'proof')
        r['references'].insert(last + 1, ref)
        receipt = receipt_for(path)
        if ref_of(r, receipt) is None:
            r['references'].append({'path': receipt, 'role': 'receipt', 'sha256': digest((ROOT / receipt).read_bytes()),
                                    'declarations': []})
        r['proof_bindings'].append({'source': path, 'receipt': receipt, 'sha256_pointer': f'/source_sha256/{module_name(module)}',
                                    'success_pointer': '/status', 'success_value': 'passed'})
    assert ref['role'] == 'proof', (r['id'], path)
    for n in names:
        if n not in ref['declarations']:
            ref['declarations'].append(n)
    return ref


def module_name(module):
    return 'Becoming.' + module


def once(text, old, new, where):
    if new in text and old not in text:
        return text
    assert text.count(old) == 1, (where, old[:90])
    return text.replace(old, new)


def note(r, en, zh):
    assert not any(h['en'].startswith(NOTE_EN) for h in r['history']), (r['id'], 'a U4c note is there already')
    r['history'].append({'en': NOTE_EN + en, 'zh': NOTE_ZH + zh})


def listed(names):
    return ', '.join(names)


# ---------------------------------------------------------------------------------------------------------- move

def move(r):
    """The moved declarations a record lists under their old modules go to its Prelude reference; returns them."""
    moved = []
    for module in ('Population', 'Change', 'Flow'):
        ref = ref_of(r, src(module))
        if ref is None:
            continue
        here = [d for d in ref.get('declarations', []) if d.startswith('Becoming.') and MOVED.get(d[9:]) == module]
        if not here:
            continue
        ref['declarations'] = [d for d in ref['declarations'] if d not in here]
        moved += here
        if here and not ref['declarations']:
            assert r['id'] in EMPTIED, (r['id'], module, 'left empty')
            r['references'].remove(ref)
            r['proof_bindings'] = [b for b in r['proof_bindings'] if b['source'] != ref['path']]
    if moved:
        ensure_ref(r, 'Prelude', moved)
    return [d[9:] for d in moved]


def move_note(r, moved, extra_en='', extra_zh=''):
    gen = [n for n in GENERALIZED if n in moved]
    en = (f'declarations moved with their full names: {listed(moved)} to Becoming.Prelude, with the list and stretch '
          'lemmas the root\'s census laws use')
    zh = f'声明以完整名称移动：{listed(moved)} 移至 Becoming.Prelude，与根上之清点诸律所用之列表与跨段引理同处'
    if gen:
        en += f'; {listed(gen)} generalized from Type to every universe, every earlier use an instance'
        zh += f'；{"、".join(gen)} 自 Type 推至任一宇宙，此前之用皆为其例'
    if r['id'] in EMPTIED:
        en += ('; the Change.lean reference, which cited only steps_last, goes with its proof binding, nothing the record '
               'says resting on that file')
        zh += '；Change.lean 之引用只引 steps_last，与其证明绑定一并去掉，记录所言无一依于该文件'
    return (en + '. The cited Lean source and its proof binding follow them' + extra_en,
            zh + '。所引 Lean 源及其证明绑定随之' + extra_zh)


def finish(en, zh):
    """A note's last sentence, as EC2's: the claim is unchanged."""
    return en + '; the claim is unchanged.', zh + '；论断不变。'


def capital(en):
    return en[0].upper() + en[1:]


def step_move():
    done = {}
    for rid in TWENTY:
        r = load(rid)
        moved = move(r)
        assert moved, (rid, 'nothing moved')
        done[rid] = (r, moved)
    others = []
    for f in sorted((ROOT / RECS).glob('*.json')):
        r = json.loads(f.read_text(encoding='utf-8'))
        if r.get('id') in done:
            continue
        if move(r):
            others.append(r['id'])
    assert not others, ('records outside the twenty list a moved lemma', others)
    return done


# ---------------------------------------------------------------------------------------------------------- texts

CEASING_LAW2 = {
    'en': ('The proof goes through the census balance: with ceasing to be recurring, the ceasings from any step N on '
           'accumulate past the list at N, while the list at the end with what ceased between is the list at N with '
           'what came between, so something comes to be between.',
           'The proof goes through the root\'s census of a run («定后前者在前则亡屡者生屡») at a member\'s occurrences along '
           'its steps, under the two-valued class of its determination, where coming to be and ceasing to be are '
           'beginning and ending; the occurrences are listed once, each predecessor before, nothing splitting. The '
           'listing, census and dependence readings go through it; the world and standing readings through the '
           'covering law (law 6), not a case of it.'),
    'zh': ('证明经过普查的平衡：不再成立复现时，从任一步 N 起其间不再成立的累加而超过 N 时的列表，而终点的列表连同其间不再成立的恰是 N '
           '时的列表连同其间开始成立的，所以其间有开始成立。',
           '证明经过根上一程的清点（«定后前者在前则亡屡者生屡»）：单位是一成员沿其各步的出现，以其判定的二值之类为类，开始成立与不再成立在'
           '那里是生与亡；出现各列一次，前者列在其前，无分裂。列举、清点与依存的读法经过该律；世界与立的读法经过覆盖之律（第 6 条），它不是'
           '根上一程之清点的情形。')}
CEASING_LAW2_DECLS = [RUN, 'Becoming.comesToBe_iff_sheng_along', 'Becoming.ceasesToBe_iff_wang_along',
                      'Becoming.Steps.along_fixed', 'Becoming.listedOccurrences', 'Becoming.gaining_of_losing_from']
ROOT_DEP = {
    'ceasing-needs-arising': (
        'The root\'s census of a run («定后前者在前则亡屡者生屡»), of which Listed.coming_of_ceasing is the case at a '
        'member\'s occurrences along its steps (law 2).',
        '根上一程的清点（«定后前者在前则亡屡者生屡»），Listed.coming_of_ceasing 是它在一成员沿其各步的出现上的情形（第 2 条）。'),
    'census-balance-under-continuation': (
        'Reuses the root\'s census of a step and its mirror («定后则后并亡不过前并生», «定前则前并生不过后并亡»): '
        'Web.Census.balanceFrom_at is their case at the step\'s relation between formations active at both ends (law 4).',
        '复用根上一步的清点及其镜像（«定后则后并亡不过前并生»、«定前则前并生不过后并亡»）：Web.Census.balanceFrom_at 是它们在该步两端'
        '都活跃的形成之间的关系上的情形（第 4 条）。'),
    'census-balance': (
        'The root\'s census of a step and its mirror («定后则后并亡不过前并生», «定前则前并生不过后并亡»), of which '
        'Listed.across_at is the case at the step\'s relation on members, each continuing only itself where it holds at '
        'both ends (law 8).',
        '根上一步的清点及其镜像（«定后则后并亡不过前并生»、«定前则前并生不过后并亡»），Listed.across_at 是它们在该步成员间关系上的'
        '情形，每个成员在两端都成立处只延续自身（第 8 条）。')}
CENSUS_RELATED = {
    'en': ('This law follows from it (P30); the form with rates:',
           'This law followed from it from P30 until U4c, which re-proved it through the root\'s census of a run (law 2); '
           'the census balance still characterizes coming to be recurring exactly, by the lengths of the lists '
           '(Listed.coming_iff_excess, Listed.over_stretch), which this law does not. The form with rates:'),
    'zh': ('本规律由它推出（P30）；比率形式：',
           '本规律自 P30 至 U4c 由它推出，U4c 改经根上一程的清点证明（第 2 条）；普查的平衡仍以列表之长恰刻画开始成立的复现'
           '（Listed.coming_iff_excess、Listed.over_stretch），本规律不然。比率形式：')}


def step_ceasing(r):
    law = r['laws'][1]
    for lang in ('en', 'zh'):
        old, new = CEASING_LAW2[lang]
        if law[lang] != new:
            assert law[lang] == old, ('ceasing-needs-arising law 2', lang)
            law[lang] = new
    assert law['declarations'] == ['Becoming.recurring_accumulates', 'Becoming.Listed.over_stretch',
                                   'Becoming.Listed.coming_iff_excess'], law['declarations']
    law['declarations'] = CEASING_LAW2_DECLS
    ensure_ref(r, 'GrammarLaws', [RUN])
    ensure_ref(r, 'Population', ['Becoming.comesToBe_iff_sheng_along', 'Becoming.ceasesToBe_iff_wang_along',
                                 'Becoming.listedOccurrences'])
    ensure_ref(r, 'Arising', ['Becoming.Steps.along_fixed'])
    ensure_ref(r, 'Prelude', ['Becoming.gaining_of_losing_from'])
    dep = [d for d in r['dependencies'] if d['id'] == 'census-balance']
    assert len(dep) == 1 and 'Listed.coming_iff_excess' in dep[0]['detail']['en']
    r['dependencies'].remove(dep[0])
    rel = [x for x in r['related'] if x['id'] == 'census-balance']
    assert len(rel) == 1
    for lang in ('en', 'zh'):
        rel[0]['detail'][lang] = once(rel[0]['detail'][lang], *CENSUS_RELATED[lang], f'related census-balance {lang}')
    add_root_dep(r)


ROOT_INTERFACE = {
    'output': {'zh': '计之一步清点，分两半。', 'en': 'The census of a step, counted, in two halves.'},
    'input': {'zh': '延续下跨一步的平衡（Web.Census.balanceFrom_at）。',
              'en': 'The balance across a step under a continuation (Web.Census.balanceFrom_at).'},
    'conditions': {'zh': '生起与止息之测；前一半在该步无分裂，其镜像无合并。',
                   'en': 'The tests of arising and ceasing; no split at the step for the first half, no merge for its '
                         'mirror.'},
    'evidence': src('GrammarLaws')}


def add_root_dep(r):
    """The root's census: a formal-reuse dependency of census-balance-under-continuation, which
    master-laws-on-the-grammar does not reach; related for census-balance and ceasing-needs-arising, which it reaches
    (census-balance among its own dependencies, ceasing-needs-arising through least-loss-rest and
    continued-change-needs-openness), so that a dependency back would close a cycle."""
    en, zh = ROOT_DEP[r['id']]
    assert not any(d['id'] == 'master-laws-on-the-grammar' for d in r['dependencies'] + r['related']), r['id']
    if r['id'] == 'census-balance-under-continuation':
        r['dependencies'].append({'id': 'master-laws-on-the-grammar', 'relation': 'formal-reuse',
                                  'detail': {'zh': zh, 'en': en}, 'interface': ROOT_INTERFACE})
    else:
        r['related'].append({'id': 'master-laws-on-the-grammar', 'detail': {'en': en, 'zh': zh}})


CONT_LAW3 = {
    'en': ('Under a census, with activity and the continuation decided, across each step:',
           'Under a census, with activity decided and whether a formation continues, or is continued by, some active '
           'formation decided, across each step:'),
    'zh': ('在普查之下、活动与延续可判定时，每一步上：',
           '在普查之下、活动可判定、一个形成是否延续某个活跃形成与是否被某个活跃形成延续可判定时，每一步上：')}
CONT_LAW4 = {
    'en': ('The proof goes through the continuing pairs: the formations after the step that continue one before it are '
           'no more than the pairs, exactly as many without merges, and those before it that are continued are no more '
           'than the pairs, exactly as many without splits.',
           'The balance across a step and the laws through it (laws 3, 6 and 9) go through the root\'s census of a step '
           '(«定后则后并亡不过前并生», its mirror «定前则前并生不过后并亡») at the step\'s relation between formations active at '
           'both ends: without splits the first, without merges the mirror. The tests decide arising and ceasing, counted '
           'by marks; the continuation itself is not decided. The covering laws (laws 10 and 11) go by lineages.'),
    'zh': ('证明以跨步延续的配对数为中介：步后延续步前某个形成的不多于配对数，没有合并时恰是；步前被延续的不多于配对数，没有分裂时恰是。',
           '跨步的平衡与经过它的各律（第 3、6、9 条）经过根上一步的清点（«定后则后并亡不过前并生»，其镜像«定前则前并生不过后并亡»），'
           '取步上两端都活跃的形成之间的关系：没有分裂时用前者，没有合并时用镜像。检验判定生起与止息，以标记计数；延续本身不需判定。'
           '覆盖之律（第 10、11 条）经由谱系。')}
CONT_LAW4_DECLS = ['Becoming.Web.Census.balanceFrom_at', STEP, STEP_MIRROR, 'Becoming.total_mark_eq_count']
CONT_HYP = {
    'en': ('A census: the formations active at each step are listed, each once. Decided activity, a decided continuation '
           'and decided ‘continues some active formation’ are hypotheses of the theorems, not axioms; the latter two '
           'follow from the census and a decided continuation (Census.decideContinues, Census.decideContinued).',
           'A census: the formations active at each step are listed, each once. Decided activity and decided '
           '‘continues some active formation’ and ‘is continued by some active formation’ are hypotheses of the '
           'theorems, not axioms; under a census a decided continuation gives the latter two (Census.decideContinues, '
           'Census.decideContinued), and the census laws do not take a decided continuation itself.'),
    'zh': ('普查：每步活跃的形成被不重复地列出。活动、延续以及“是否延续某个活跃形成”可判定，是定理的假设，不是公理；后两者由普查与可判定的'
           '延续给出（Census.decideContinues、Census.decideContinued）。',
           '普查：每步活跃的形成被不重复地列出。活动可判定、“延续某个活跃形成”与“被某个活跃形成延续”可判定，是定理的假设，不是公理；'
           '在普查之下，可判定的延续给出后两者（Census.decideContinues、Census.decideContinued），普查诸律不取延续本身的可判定。')}
CONT_RELATED = {'en': ('(moved into Becoming.Population for this)',
                       '(moved into Becoming.Population for this, and with U4c into Becoming.Prelude)'),
                'zh': ('（为此移入 Becoming.Population）', '（为此移入 Becoming.Population，U4c 时移入 Becoming.Prelude）')}
# The census balance's dependency names the counting the record now reuses; the identity dependency's conditions what
# its theorems decide.
CONT_BALANCE_DEP = {
    'en': ('Reuses counting by marks (marks_le_of_sub, mark_add_not, total_congr_on) and the stretch form of the balance '
           '(balance_over_stretch, here as inequalities).',
           'Reuses counting by marks (total_mark_eq_count, which reads it as the root\'s count) and the stretch form of '
           'the balance (balance_over_stretch, here as inequalities: le_over_stretch, ge_over_stretch, through '
           'gaining_of_losing_from and losing_of_gaining_from).'),
    'zh': ('复用标记的计数（marks_le_of_sub、mark_add_not、total_congr_on）与平衡的累加形式（balance_over_stretch 的不等式版本）。',
           '复用标记的计数（total_mark_eq_count，以根上之计读之）与平衡的累加形式（balance_over_stretch 的不等式版本：'
           'le_over_stretch、ge_over_stretch，经 gaining_of_losing_from 与 losing_of_gaining_from）。')}
CONT_IDENTITY_CONDITIONS = {'en': ('A census; decided activity and continuation.',
                                   'A census; decided activity, and decided continuing of an active formation.'),
                            'zh': ('普查；活动与延续可判定。', '普查；活动可判定，延续某个活跃形成可判定。')}
# Declarations no law of the record declares and no text of it names once law 4 goes through the root's census.
CONT_UNUSED = {'Population': ['Becoming.mark_add_not', 'Becoming.marks_le_of_sub', 'Becoming.mark_le_total',
                              'Becoming.total_le_mark'],
               'Flow': ['Becoming.total_swap', 'Becoming.total_le']}


def step_census(r):
    law3, law4 = r['laws'][2], r['laws'][3]
    for lang in ('en', 'zh'):
        law3[lang] = once(law3[lang], *CONT_LAW3[lang], f'law 3 {lang}')
        old, new = CONT_LAW4[lang]
        if law4[lang] != new:
            assert law4[lang] == old, ('law 4', lang)
            law4[lang] = new
        hyp = r['hypotheses'][1]
        old, new = CONT_HYP[lang]
        if hyp[lang] != new:
            assert hyp[lang] == old, ('hypotheses 2', lang)
            hyp[lang] = new
        rel = [x for x in r['related'] if x['id'] == 'laws-of-one-step']
        assert len(rel) == 1
        rel[0]['detail'][lang] = once(rel[0]['detail'][lang], *CONT_RELATED[lang], f'related {lang}')
        dep = {d['id']: d for d in r['dependencies']}
        dep['census-balance']['detail'][lang] = once(dep['census-balance']['detail'][lang], *CONT_BALANCE_DEP[lang],
                                                     f'census-balance dependency {lang}')
        cond = dep['identity-across-steps']['interface']['conditions']
        cond[lang] = once(cond[lang], *CONT_IDENTITY_CONDITIONS[lang], f'identity dependency conditions {lang}')
    assert law4['declarations'] == ['Becoming.mark_le_total', 'Becoming.total_le_mark', 'Becoming.total_swap']
    law4['declarations'] = CONT_LAW4_DECLS
    assert 'Becoming.Web.Census.balanceFrom_at' in ref_of(r, src('Identity'))['declarations']
    ensure_ref(r, 'GrammarLaws', [STEP, STEP_MIRROR])
    ensure_ref(r, 'Population', ['Becoming.total_mark_eq_count'])
    declared = {d for law in r['laws'] for d in law['declarations']}
    texts = json.dumps({k: v for k, v in r.items() if k not in ('references', 'proof_bindings', 'history')},
                       ensure_ascii=False)
    for module, names in CONT_UNUSED.items():
        ref = ref_of(r, src(module))
        for n in names:
            assert n in ref['declarations'] and n not in declared and n[9:] not in texts, (module, n)
        ref['declarations'] = [d for d in ref['declarations'] if d not in names]
    add_root_dep(r)


BALANCE_LAW1 = {
    'en': ('equals the length of the list before it with the number that came to be: the members kept across the step '
           'are counted alike on both lists.',
           'equals the length of the list before it with the number that came to be (Listed.across, a case of the '
           'root\'s census of a step, law 8); the members kept across the step are counted alike on both lists '
           '(Listed.keeps).'),
    'zh': ('等于步前的列表长度加上跨步开始成立的成员数：跨步保持成立的成员在两张列表上计数相同。',
           '等于步前的列表长度加上跨步开始成立的成员数（Listed.across，根上一步之清点之例，第 8 条）；跨步保持成立的成员在两张列表上'
           '计数相同（Listed.keeps）。')}
BALANCE_LAW5 = {
    'en': ('The census law and the bounded law follow from it (ceasing-needs-arising, bounded-census-keeps-pace).',
           'The bounded law follows from it (bounded-census-keeps-pace); the census law (ceasing-needs-arising) was '
           'proved from it until U4c, which proved it through the root\'s census of a run, and still follows from it.'),
    'zh': ('普查定律与有界定律由此推出（ceasing-needs-arising、bounded-census-keeps-pace）。',
           '有界定律由此推出（bounded-census-keeps-pace）；普查定律（ceasing-needs-arising）至 U4c 由此证明，U4c 改经根上一程之'
           '清点证明，它仍由此推出。')}
BALANCE_RELATED = {
    'en': ('The census law follows from this balance (P30).',
           'The census law was proved from this balance from P30 until U4c, which proved it through the root\'s census '
           'of a run; it still follows from it.'),
    'zh': ('普查定律由本平衡推出（P30）。', '普查定律自 P30 至 U4c 由本平衡证明，U4c 改经根上一程的清点证明；它仍由本平衡推出。')}


def step_balance(r):
    law1, law5 = r['laws'][0], r['laws'][4]
    rel = [x for x in r['related'] if x['id'] == 'ceasing-needs-arising']
    assert len(rel) == 1
    for lang in ('en', 'zh'):
        law1[lang] = once(law1[lang], *BALANCE_LAW1[lang], f'census-balance law 1 {lang}')
        law5[lang] = once(law5[lang], *BALANCE_LAW5[lang], f'census-balance law 5 {lang}')
        rel[0]['detail'][lang] = once(rel[0]['detail'][lang], *BALANCE_RELATED[lang], f'related ceasing {lang}')
    old, new = 'Becoming.marks_le_of_sub', 'Becoming.Listed.keeps'
    assert law1['declarations'] == ['Becoming.Listed', 'Becoming.Listed.across', old], law1['declarations']
    law1['declarations'] = ['Becoming.Listed', 'Becoming.Listed.across', new]
    assert not any(old in law['declarations'] for law in r['laws'])
    ref = ref_of(r, src('Population'))
    ref['declarations'] = [new if d == old else d for d in ref['declarations']]
    # Listed.across_at, re-proved through the root's census, reads marks as the root's count (law 8).
    law8, count = r['laws'][7], 'Becoming.total_mark_eq_count'
    i = law8['declarations'].index('Becoming.Listed.across_at') + 1
    law8['declarations'][i:i] = [count]
    ref['declarations'].insert(ref['declarations'].index('Becoming.Listed.across_at') + 1, count)
    add_root_dep(r)


# ---------------------------------------------------------------------------------------------------------- master

MASTER_LAW4 = {
    'en': ('arising and ceasing are beginning and ending. The listing and the test are supplied.',
           'arising and ceasing are beginning and ending. Counted, the census needs no decision of identity: under a '
           'continuation fixing successors, the units listed once after a step with those a test marks as ceasing are '
           'at most the units before with those a test marks as arising, the tests asking only, as far as can be '
           'refuted, that a unit marked as ceasing has no successor after and that a unit after not marked as arising '
           'has a predecessor before; its mirror holds under a continuation fixing predecessors, and where both are '
           'fixed the two meet in the census\'s count, the tests read off its decision. Along a run, from some step on, '
           'the units after each step listed once, nothing splitting and every predecessor of a unit listed after a '
           'step listed before it, endings recurring among the listed units need beginnings recurring among the units '
           'listed after a step, the beginnings and endings decided by tests. Each is the corollary of a local form '
           'beside it that asks no split (no merge) only among the listed units. The listing and the test are '
           'supplied.'),
    'zh': ('所列之生与亡恰是生与亡。列表与判别皆为所给。',
           '所列之生与亡恰是生与亡。计之，清点不须同一之判定：在定后之续下，一步后各列一次之单位并判别所标为亡者，不过步前之单位并判别所'
           '标为生者；判别所问，于可驳之限内，唯标为亡者在后无后者、后列未标为生者在前有前者；定前之续下其镜像亦然；两者皆定之处，二者'
           '相会于清点之数，判别读自其判定。沿一程，自某步起，各步后之单位各列一次、无分裂、步后所列单位之前者皆列于其前，所列单位中亡屡'
           '则步后所列单位中生屡，生与亡由判别所定。每一律为其旁一局部之形之推论，后者只在所列单位之中要求无分裂（无合并）。列表与判别皆为所给。')}
MASTER_LAW3 = {'en': ('the census of a step and the count laws need.',
                      'the census of a step, the census of a run and the count laws need.'),
               'zh': ('步之清点与计数之律所需之筛、查与计。', '步之清点、程之清点与计数之律所需之筛、查与计。')}
MASTER_HYP3 = {'en': ('lists the units before and after once each.',
                      'lists the units before and after once each; counted, the census reads arising and ceasing (along '
                      'a run, beginnings and endings) by tests on the listed units in place of a test of the '
                      'continuation.'),
               'zh': ('一步之清点所列前后之单位各只一次。',
                      '一步之清点所列前后之单位各只一次；计之，清点以所列单位上生起与止息（沿一程则生与亡）之测代续之测。')}
# The scope is at its length cap (600, 260): the list of changed statements gives way to the history notes, which carry
# it, and the reviews are counted, not listed by item (each is referenced from its item's records), so the scope stays
# true as items land.
MASTER_SCOPE = {
    'en': [("Changed modules' statements as before but for OU3b's two relation laws at any universe, HE2's renames and "
            "one law widened. Read-only AI reviews, every finding taken: OU3b and OU3f three each, HE2 two, OU3c to OU3e "
            "and HE one each, three with a second pass; no person's review.",
            "Changed modules' statements as before but where the history notes say: laws taken to any universe, renames, "
            "one law widened, an instance dropped from eight laws. Read-only AI reviews of each item, every finding "
            "taken, five with a second pass; no person's review.")],
    'zh': [('改动模块陈述如前，唯 OU3b 二关系律推至任一宇宙、HE2 改名与一律之设放宽。只读 AI 审查，所见皆采：OU3b、OU3f 各三，HE2 '
            '二，余各一，三项经复审；未经人审。',
            '改动模块陈述如前，唯历史说明所言：推至任一宇宙、改名、放宽一律、八律去一实例。只读 AI 审查各项，所见皆采，五项经复审；'
            '未经人审。')]}


def step_master(r):
    law3, law4 = r['laws'][2], r['laws'][3]
    for lang in ('en', 'zh'):
        law4[lang] = once(law4[lang], *MASTER_LAW4[lang], f'master law 4 {lang}')
        law3[lang] = once(law3[lang], *MASTER_LAW3[lang], f'master law 3 {lang}')
        r['hypotheses'][2][lang] = once(r['hypotheses'][2][lang], *MASTER_HYP3[lang], f'master hypothesis 3 {lang}')
        for old, new in MASTER_SCOPE[lang]:
            r['validation_scope'][lang] = once(r['validation_scope'][lang], old, new, f'validation scope {lang}')
    after = 'Becoming.GrammarLaws.pair_of_class_counts'
    assert law4['declarations'][-1] == after, law4['declarations'][-3:]
    law4['declarations'] += CENSUS_LAWS
    law3['declarations'] += [n for n in LIST_LEMMAS if n not in law3['declarations']]
    ref = ref_of(r, src('GrammarLaws'))
    i = ref['declarations'].index(after) + 1
    ref['declarations'][i:i] = LIST_LEMMAS + CENSUS_LAWS
    for path, role in [(DESIGN, 'integration'), (REVIEW_DESIGN, 'review'), (REVIEW_RECORD, 'review')]:
        assert ref_of(r, path) is None, path
        r['references'].append({'path': path, 'role': role, 'sha256': file_digest(path), 'declarations': []})
    note(r, ('law 4, balance at one step, gains the census counted: the root\'s census of a step, one side '
             '(«定后则后并亡不过前并生»), its mirror («定前则前并生不过后并亡»), the two meeting in the count of the paired census '
             '(«定后定前则前并生与后并亡同数»), and the census of a run («定后前者在前则亡屡者生屡»), each the corollary of a '
             'local form asking no split (no merge) only among the listed units (GrammarLaws.census_le, '
             'census_le_converse, census_count, census_run), as the first hypothesis says of every global form; law 3 '
             'and the GrammarLaws reference gain the five list lemmas they use, in GrammarLaws\' namespace, law 3 '
             'naming the census of a run, and the third hypothesis says what the counted census tests. U4c\'s '
             'derivations: Listed.coming_of_ceasing, Listed.across_at and Web.Census.balanceFrom_at, re-proved as cases '
             'in Population and Identity; its changed statements: three list lemmas moved to the prelude at any '
             'universe, and eight census laws of Identity without the instance deciding the continuation; its design '
             'and reviews join the references (CENSUS-ON-THE-ROOT.md; REVIEW-U4C.md and REVIEW-U4C-RECORD.md, each with a '
             'second pass). The validation scope, at its length, now leaves the list of changed statements to these '
             'notes and counts the reviews without listing them by item, each referenced from its item\'s records. '
             'Nothing else the record states changed.'),
         ('律 4（一步之平衡）增计之清点：根上一步之清点之一边（«定后则后并亡不过前并生»）、其镜像（«定前则前并生不过后并亡»）、二者相会于'
          '成对清点之数（«定后定前则前并生与后并亡同数»）、一程之清点（«定后前者在前则亡屡者生屡»），各为一局部之形之推论，后者只在所列'
          '单位之中要求无分裂（无合并）（GrammarLaws.census_le、census_le_converse、census_count、census_run），如第一假设之言每一全局'
          '之形；律 3 与 GrammarLaws 之引用增其所用之五列表引理，在 GrammarLaws 之名下，律 3 名一程之清点，第三假设言计之清点所测。'
          'U4c 之推导：Listed.coming_of_ceasing、Listed.across_at 与 Web.Census.balanceFrom_at 改证为其例，在 Population 与 '
          'Identity；其所改之陈述：三列表引理移入序章、推至任一宇宙，Identity 八条清点之律去判定延续之实例；其设计与审查入引用'
          '（CENSUS-ON-THE-ROOT.md；REVIEW-U4C.md 与 REVIEW-U4C-RECORD.md，皆经复审）。验证范围限于其长，今以改动陈述之列交此诸'
          '说明，审查只计其数而不逐项列之，各见引于其项之记录。记录所述余无改变。'))


# ---------------------------------------------------------------------------------------------------------- edge

DRAFT = '--draft' in sys.argv


def file_digest(path):
    """A new reference's hash, from the file in this tree (the design files land with the stage); None in a draft."""
    if (ROOT / path).is_file():
        return digest((ROOT / path).read_bytes())
    assert DRAFT, (path, 'missing: apply the design patch first, or pass --draft')
    return None


def edge_record():
    os.environ['U4_U4C'] = '1'
    spec = importlib.util.spec_from_file_location('make_record_u4', DEV / 'make_record_u4.py')
    mr = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mr)
    return mr


NEXT = {'en': ('A root form for the census rows;',
               'The covering laws\' root form (lines traced back to a covering list, no splits); a stretch form of the '
               'census on positions, of which CensusWebs.keep_pace would be a case;'),
        'zh': ('清点诸行之根形；', '覆盖之律之根形（诸线溯至一覆盖之列表，无分裂）；清点于位置上之跨段形，CensusWebs.keep_pace 将为其例；')}


def step_edge(r, mr):
    new = {e['declaration']: e for e in mr.STANDINGS}
    rows = ['Becoming.Listed.coming_of_ceasing', 'Becoming.CensusWebs.keep_pace']
    assert new[rows[0]]['standing'] == 'derived'
    standings = r['boundary']['standings']
    for d in rows:
        k = [i for i, e in enumerate(standings) if e['declaration'] == d]
        assert len(k) == 1, d
        if standings[k[0]] != new[d]:
            assert standings[k[0]]['standing'] == 'counting', d
            standings[k[0]] = new[d]
    rest = [e['declaration'] for e in standings if e['declaration'] not in rows and e != new.get(e['declaration'])]
    assert not rest, ('entries U4c does not change differ from make_record_u4.py', rest)
    for path, role in [(REVIEW_RECORD, 'review'), (REVIEW_DESIGN, 'review'), (DESIGN, 'integration')]:
        if ref_of(r, path) is None:
            r['references'].append({'path': path, 'role': role, 'sha256': file_digest(path), 'declarations': []})
    # DESIGN-BOUNDARY gains a dated §9 for U4c, its §0 to §8 unchanged (read against the new text).
    design = ref_of(r, U4 + 'DESIGN-BOUNDARY.md')
    text = (ROOT / design['path']).read_text(encoding='utf-8')
    assert '## 9. ' in text and 'U4c' in text[text.index('## 9. '):] or DRAFT, 'DESIGN-BOUNDARY §9 is not there'
    design['sha256'] = file_digest(design['path'])
    for lang in ('en', 'zh'):
        r['next_delta'][lang] = once(r['next_delta'][lang], *NEXT[lang], f'next_delta {lang}')
    note(r, ('Listed.coming_of_ceasing moved from counting to derived, a case of the root\'s census of a run '
             '(«定后前者在前则亡屡者生屡») at a member\'s occurrences along its steps, through two bridges '
             '(comesToBe_iff_sheng_along, ceasesToBe_iff_wang_along) and the support of Steps.along; its statement is '
             'unchanged and still reads as counting, the row placed by its proof\'s reach, as were the eight connected '
             'rows the reading of connected rows took as derived. CensusWebs.keep_pace stays counting, its basis saying '
             'why it is not a case of the root\'s census of a step. The next step names the covering laws\' root form '
             'and a stretch form of the census on positions, of which keep_pace would be a case, in place of a root form '
             'for the census rows (CENSUS-ON-THE-ROOT.md, reviewed in REVIEW-U4C.md, its record texts in '
             'REVIEW-U4C-RECORD.md, both among the references); DESIGN-BOUNDARY gains a dated §9 saying what differs '
             'from lever 1\'s census candidate.'),
         ('Listed.coming_of_ceasing 由计数移至推出：根上一程之清点（«定后前者在前则亡屡者生屡»）于一成员沿其各步之出现之例，经二桥'
          '（comesToBe_iff_sheng_along、ceasesToBe_iff_wang_along）与 Steps.along 之所助；其陈述不变，仍读作计数，依其证明所及而置，'
          '如相连诸行之读法所取为推出之八相连行。CensusWebs.keep_pace 仍为计数，其理据言其何以非根上一步之清点之例。下一步以覆盖之律'
          '之根形与清点于位置上之跨段形（keep_pace 将为其例）代清点诸行之根形（CENSUS-ON-THE-ROOT.md，经 REVIEW-U4C.md 审阅，其记录'
          '之文经 REVIEW-U4C-RECORD.md 审阅，二者皆在引用中）；DESIGN-BOUNDARY 增一注明日期之 §9，言其与第一杠杆之清点候选何异。'))


# ---------------------------------------------------------------------------------------------------------- chapters

ROOT_7 = ('arising and ceasing are beginning and ending (`«前者在前则所列生者生»`, `«后者在后则所列亡者亡»`). The listing and '
          'the test are supplied.',
          'arising and ceasing are beginning and ending (`«前者在前则所列生者生»`, `«后者在后则所列亡者亡»`). Counted, the census '
          'needs no decision of identity: under a continuation fixing successors, the units listed once after a step, '
          'joined with those a test marks as ceasing, are at most the units before, joined with those a test marks as '
          'arising, the tests asking only, as far as can be refuted, that a unit marked as ceasing has no successor '
          'after and that a unit after not marked as arising has a predecessor before (`«定后则后并亡不过前并生»`); its '
          'mirror holds under a continuation fixing predecessors (`«定前则前并生不过后并亡»`), and where both are fixed the '
          'two meet in the count of the census above, the tests read off its decision (`«定后定前则前并生与后并亡同数»`). '
          'Along a run, from some step on, with the units after each step listed once, nothing splitting, and every '
          'predecessor of a unit listed after a step listed before it, endings recurring among the listed units need '
          'beginnings recurring among the units listed after a step, the beginnings and endings decided by tests '
          '(`«定后前者在前则亡屡者生屡»`); `Listed.coming_of_ceasing` is its case at a member\'s occurrences '
          '([08 §7](08-METHOD.md#r-one-root-to-its-edge)). Each of the four is the corollary of a local form beside it '
          'that asks no split (no merge) only among the listed units (`GrammarLaws.census_le`, `census_le_converse`, '
          '`census_count`, `census_run`). The listing and the test are supplied.')
# M3: a model's law keeps its statement or takes a more general one (eight of Identity's census laws lose an instance).
ROOT_THEOREM = ('each model\'s law is proved from the grammar\'s in its own module, keeping its name and statement.',
                'each model\'s law is proved from the grammar\'s in its own module, keeping its name and its statement or a '
                'more general one.')
# M8: the release gate's line on the two census rows, as U4c leaves them.
WHAT_REMAINS = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/' \
    'ou3b-master-laws-on-the-grammar/WHAT-REMAINS.md'
REMAINS_ROWS = ('are where the census pairing reaches most directly. They are a candidate item of their own.',
                'are where the census pairing reaches most directly. U4c took them up: `Listed.coming_of_ceasing` is '
                'derived, a case of the root\'s census of a run; `CensusWebs.keep_pace` stays counting, a stretch form of '
                'the census on positions being the boundary record\'s next step.')
ROOT_95 = ('Under a census, read along a continuation, with activity and the continuation decided:',
           'Under a census, read along a continuation, with activity decided and whether a formation continues, or is '
           'continued by, some active formation decided:')
METHOD_7 = [('Ten are derived, each a case of grammar laws,', 'Eleven are derived, each a case of grammar laws,'),
            ('; and, since HE2 proved their model lemmas as `«所闭之逆»` and the laws of a closure through borrowed steps, '
             '`Flow.mutuallyDependent_iff_reach` and `Flow.withinCoupling_reads_iff`.',
             '; since HE2 proved their model lemmas as `«所闭之逆»` and the laws of a closure through borrowed steps, '
             '`Flow.mutuallyDependent_iff_reach` and `Flow.withinCoupling_reads_iff`; and, since U4c, '
             '`Listed.coming_of_ceasing`, a case of the root\'s census of a run (`«定后前者在前则亡屡者生屡»`) at a member\'s '
             'occurrences along its steps, through two bridges reading coming to be and ceasing to be as beginning and '
             'ending there.'),
            ('Seven are counting, below the grammar.', 'Six are counting, below the grammar.')]


def step_chapters(mr):
    p = ROOT / 'theories/becoming/chapters/01-ROOT.md'
    t = p.read_text(encoding='utf-8')
    t = once(t, *ROOT_7, '01 §7')
    t = once(t, *ROOT_95, '01 §9.5')
    t = once(t, *ROOT_THEOREM, '01 §7, the root theorem')
    p.write_text(t, encoding='utf-8')
    p = ROOT / WHAT_REMAINS
    p.write_text(once(p.read_text(encoding='utf-8'), *REMAINS_ROWS, 'WHAT-REMAINS, the census rows'), encoding='utf-8')
    p = ROOT / 'theories/becoming/chapters/08-METHOD.md'
    t = p.read_text(encoding='utf-8')
    start = t.index('<a id="r-one-root-to-its-edge"></a>')
    end = t.index('\n\n', start)
    para = t[start:end]
    for old, new in METHOD_7:
        para = once(para, old, new, '08 §7')
    c = mr.counts()
    assert (c['derived'], c['counting']) == (11, 6), c
    generated = mr.home(c).rstrip('\n')
    # The generator's paragraph and the chapter's agree on the sentences U4c changes.
    for _, new in METHOD_7:
        assert new in generated, new[:60]
    p.write_text(t[:start] + para + t[end:], encoding='utf-8')


# ---------------------------------------------------------------------------------------------------------- main

def main():
    mr = edge_record()
    assert mr.U4C
    done = step_move()
    for rid, (r, moved) in done.items():
        en, zh = move_note(r, moved)
        if rid == 'ceasing-needs-arising':
            step_ceasing(r)
            en, zh = ('law 2 restated: Listed.coming_of_ceasing is re-proved through the root\'s census of a run, no '
                      'longer through Listed.over_stretch and Listed.coming_iff_excess; its statement is unchanged, and '
                      'law 2\'s declarations follow the proof, with the references that hold them. The census balance '
                      'leaves the dependencies, its related note saying until when it was the proof, and the root\'s '
                      'census joins related. '
                      + capital(en) + '; gaining_of_losing_from, which law 2 now declares, is cited there too',
                      '第 2 条重述：Listed.coming_of_ceasing 改经根上一程的清点证明，不再经 Listed.over_stretch 与 '
                      'Listed.coming_iff_excess；其陈述不变，第 2 条的声明随证明，并及载之之引用。普查的平衡离开依赖，其相关说明言其至何时'
                      '为证明；根上之清点入相关。' + zh + '；第 2 条今所声明之 gaining_of_losing_from 亦引于彼')
        elif rid == 'census-balance-under-continuation':
            step_census(r)
            en, zh = ('Web.Census.balanceFrom_at is re-proved through the root\'s census of a step, and the instance '
                      'deciding the continuation is dropped from the eight census laws of Identity\'s Counting section, '
                      'none of which uses it; law 4 restated for the new route and laws 10 and 11 left on theirs, law 3, '
                      'the second hypotheses entry and the home row in 01 §9.5 no longer saying the continuation is '
                      'decided, nor the identity dependency\'s conditions; the root\'s census joins the dependencies, '
                      'law 4 reusing its two halves, and the related note on not_not_all names the prelude. The census '
                      'balance\'s dependency names the counting now reused (total_mark_eq_count, the stretch form as '
                      'inequalities), and the declarations no law here uses any more leave the Population and Flow '
                      'references (mark_add_not, marks_le_of_sub, mark_le_total, total_le_mark, total_swap, '
                      'total_le). Each statement is unchanged or more general. ' + capital(en),
                      'Web.Census.balanceFrom_at 改经根上一步的清点证明，判定延续的实例从 Identity 的 Counting 一节的八条普查律中去掉，'
                      '它们都不用它；第 4 条按新路径重述，第 10、11 条留在其原路径，第 3 条、第二条假设、01 §9.5 的本行与同一性依赖之条件'
                      '不再说延续可判定；根上之清点入依赖，第 4 条复用其两半；关于 not_not_all 之相关说明名序章。普查平衡之依赖名今所复用之'
                      '计数（total_mark_eq_count、跨段形之不等式），此处已无律所用之声明离开 Population 与 Flow 之引用（mark_add_not、'
                      'marks_le_of_sub、mark_le_total、total_le_mark、total_swap、total_le）。各陈述不变或更一般。' + zh)
        elif rid == 'census-balance':
            step_balance(r)
            en, zh = ('Listed.across_at is re-proved as a case of the root\'s census of a step, its statement unchanged, '
                      'and the root\'s census joins related. Law 1 says Listed.across is that case and declares '
                      'Listed.keeps, whose counting of the members kept the text names, in place of marks_le_of_sub, '
                      'which Listed.across no longer goes through; law 5 and the related note on ceasing-needs-arising '
                      'say the census law was proved from the balance until U4c and still follows from it; law 8 declares '
                      'total_mark_eq_count, by which Listed.across_at reads marks as the root\'s count. '
                      + capital(en),
                      'Listed.across_at 改证为根上一步之清点之例，其陈述不变；根上之清点入相关。第 1 条言 Listed.across 为其例，并声明'
                      ' Listed.keeps（其文所言保持成员之计数）以代 marks_le_of_sub，Listed.across 已不经后者；第 5 条与关于 '
                      'ceasing-needs-arising 之相关说明言普查定律至 U4c 由平衡证明，今仍由之推出；第 8 条声明 total_mark_eq_count，'
                      'Listed.across_at 以之将标记读作根上之计。' + zh)
        note(r, *finish(en, zh))
        save(r)
        print(f'{rid}: {listed(moved)}')
    r = load('master-laws-on-the-grammar')
    step_master(r)
    save(r)
    print('master-laws-on-the-grammar: law 4, law 3, the GrammarLaws reference, the validation scope')
    r = load('one-root-to-its-edge')
    step_edge(r, mr)
    save(r)
    print('one-root-to-its-edge: two entries, references, next_delta')
    step_chapters(mr)
    print('01 §7, 01 §9.5, 08 §7, WHAT-REMAINS')


if __name__ == '__main__':
    main()
