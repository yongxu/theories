#!/usr/bin/env python3
"""WRP2 records. Writes processes-represented-both-ways (Becoming.ProcessRepresentation with GrammarTransport's
additions, homed at 01 §8.1), each of their declarations cited once; adds to master-laws-on-the-grammar one law for
GrammarLaws' additions (passing through a word's relations in turn, «历», whose constant family is «迭», with six laws
of «迭» its cases and the list lemmas it uses), its GrammarLaws reference extended and a history note, nothing else of
it changed; and brings the-world-represented-both-ways' item and next step on processes to the landed theorem, with
a related entry and a history note. The limits are stated as plainly as the success. Asserts the receipt's hashes and
empty axiom reports for the three modules, that every new declaration is cited exactly once, and the style caps and
lint (tools/research/style.py) on every field written. Mirrors WRT2's make_records_wrt2.py.
usage (from the checkout root, after texts_wrp2.py): python3 -B make_records_wrp2.py RECEIPT N
       python3 -B make_records_wrp2.py --caps  (caps, lint and the declaration cover against the scratch audits;
                                                writes nothing)"""
import datetime
import hashlib
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT))
from tools.research import style  # noqa: E402

CAPS_ONLY = sys.argv[1] == '--caps'
RECEIPT_ID, N = ('20261029T000000.000000Z', 446) if CAPS_ONLY else (sys.argv[1], int(sys.argv[2]))
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
KITD = RF + 'development/process-representation/'
DESIGN, REVIEW, REVIEW2 = KITD + 'DESIGN.md', KITD + 'REVIEW-WRP.md', KITD + 'REVIEW-WRP2.md'
MEASURE, SIGNATURES = KITD + 'measure.json', KITD + 'signatures.json'
CH1 = 'theories/becoming/chapters/01-ROOT.md'
LEAN = {m: f'{PKG}/Becoming/{m}.lean' for m in
        ('ProcessRepresentation', 'GrammarTransport', 'GrammarLaws', 'GrammarRegularity', 'GrammarCandidates',
         'GrammarCourse', 'GrammarMap', 'Grammar', 'Labelled', 'Onward', 'EdgeClosure', 'Frame', 'Likeness',
         'Experiment', 'Recurrence', 'Arising')}
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
RID, RIDM, RIDW = 'processes-represented-both-ways', 'master-laws-on-the-grammar', 'the-world-represented-both-ways'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
TODAY = datetime.date.today()
DATE_EN, DATE_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'
MODS = ('Becoming.ProcessRepresentation', 'Becoming.GrammarTransport', 'Becoming.GrammarLaws')


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def capped(field, pair, item=False):
    caps = style.ITEM_CAPS_V2 if item else style.CAPS_V2
    en, zh = caps[field][:2]
    assert len(pair['en']) <= en and len(pair['zh']) <= zh, (field, len(pair['en']), en, len(pair['zh']), zh, pair['en'][:60])
    return pair


# the declarations: the new module whole, and what the two landed modules add (the signature audit's list)
audit = json.loads((ROOT / SIGNATURES).read_text(encoding='utf-8'))
added = {m: audit['modules'][m]['added'] for m in ('Becoming.GrammarTransport', 'Becoming.GrammarLaws')}
names = {}
if CAPS_ONLY:
    for m in MODS:
        text = (HERE.parent / f'tree/.build/{m.replace(".", "")}AxiomAudit.lean').read_text(encoding='utf-8')
        names[m] = set(re.findall(r'^#print axioms (\S+)$', text, re.M))
else:
    core = json.loads((ROOT / RECEIPT).read_text())
    assert core['status'] == 'passed'
    for m in MODS:
        assert core['source_sha256'][m] == sha(LEAN[m.split('.')[1]]), m
        mod = next(x for x in core['modules'] if x['module'] == m)
        assert not any(mod['axiom_dependencies'].values()), m
        names[m] = {d['name'] for d in mod['declarations']}
for m, new in added.items():
    assert set(new) <= names[m], (m, sorted(set(new) - names[m]))
OWN = names['Becoming.ProcessRepresentation'] | set(added['Becoming.GrammarTransport'])
assert len(names['Becoming.ProcessRepresentation']) == 54 and len(added['Becoming.GrammarTransport']) == 13 \
    and len(added['Becoming.GrammarLaws']) == 12, 'declaration counts'


def C(pool, *short):
    out = ['Becoming.' + s for s in short]
    missing = [n for n in out if n not in pool]
    assert not missing, missing
    return out


def P(*short):
    return C(OWN, *short)


groups = [
    ("A process is exactly its relations, one per move: the family read back is the process, and the process read as "
     "its family is itself, by definition; its steps are their union. Every relation is the steps of the one-move "
     "process of its edges, a process with its moves forgotten has the same steps, a determined law's steps are its "
     "step relation, and enabledness is «能» at a move's relation.",
     "过程恰为其诸关系，每一着一关系：回读之族即其过程，过程读为其族即其自身，皆依定义；其步为诸关系之并。每一关系为其边之一着过程之步，"
     "忘其着之过程同其步，定律之步为其步之关系，可行即一着之关系上之 «能»。",
     P('moveRel_mk', 'mk_moveRel', 'steps_iff_moveRel', 'steps_edgeProcess', 'steps_unlabelled', 'steps_lawProcess',
       'enabled_iff_neng')),
    ("A law's truth is carried: a property of a carrier and a relation that relations alike pointwise share holds of "
     "every process's steps exactly where it holds of every relation, and a property of families holds of every "
     "process's moves' relations exactly where it holds of every family. The statement is not carried: a statement "
     "naming a process notion is in the grammar's terms only through that notion's bridge.",
     "律之真为所携：逐点相同之关系所共之载体与关系之性质，于每一过程之步成立恰当于每一关系成立；族之性质于每一过程诸着之关系成立恰当于每一族成立。"
     "陈述不为所携：言过程概念之陈述，唯经其概念之桥方入文法之项。",
     P('forall_steps_iff', 'forall_moveRel_iff')),
    ("The converse: every class is the class of a frame's claims, likeness to depth zero. The model with the move inside "
     "recovers the process on its fixed carrier, and its image is exactly the relations leaving the next move open, so "
     "a relation reading the next move is no process's model; on it the classes of the same move and of the same "
     "configuration are read.",
     "逆向：每一类为某框架断言之类，即零深之相似。着在其内之模型于其定载体上复得其过程，其像恰为留下一着未定之关系，故读下一着之关系非任何过程之模型；"
     "于其上读同着之类与同构形之类。",
     P('class_is_claims', 'sameMove', 'sameConfiguration', 'step_iff_withMove', 'withMove_image_iff',
       'reading_next_move_not_withMove')),
    ("Faithful up to correspondence with both classes: a renaming of configurations and moves is a correspondence of "
     "the models with the move inside carrying the steps and both classes; from a configuration and a move, every such "
     "correspondence is the product of renamings of configurations and moves relating the processes. With no move a "
     "point is needed: the empty models correspond, yet one configuration is not two.",
     "携二类则于对应下忠实：构形与着之重名即携步与二类之着在其内之模型之一一对应，即其积；自一构形与一着起，每一如此之对应即构形之重名与着之重名之积，"
     "且关联二过程。无着则需一点：空模型相对应，而一构形非二。",
     P('renamed_withMove', 'configurationRenaming', 'moveRenaming', 'withMove_renamed', 'NoMoves.P', "NoMoves.P'",
       'NoMoves.e', 'NoMoves.needs_a_point')),
    ("Neither class alone: the twist flips the configuration where the move is true and keeps the class of the same "
     "move, the flip flips the move where the configuration is true and keeps the class of the same configuration, and "
     "each carries the model of one process to that of another which no renaming of configurations and moves relates "
     "to it.",
     "单一类不足：扭于着为真处翻其构形而保同着之类，翻于构形为真处翻其着而保同构形之类；各携一过程之模型至另一过程者，而构形与着之重名无一关联二者。",
     P('Twist.P₁', 'Twist.P₂', 'Twist.twist', 'Twist.twist_twist', 'Twist.e', 'Twist.twist_steps',
       'Twist.models_correspond', 'Twist.P₂_not_both', 'Twist.P₂_key', 'Twist.not_renamed', 'Flip.P₃', 'Flip.P₄',
       'Flip.flip', 'Flip.flip_flip', 'Flip.e', 'Flip.flip_steps', 'Flip.models_correspond', 'Flip.P₄_apart',
       'Flip.not_renamed')),
    ("Forward: a trace is passing through the moves' relations along its word («历»), and a word is feasible exactly "
     "where that leads somewhere. A process factors through a map exactly where, at each move, the image of its "
     "relation lies within the other's; a run's configurations carry the line of steps into the steps, and with the "
     "move inside a run is exactly a sequence along which that image lies within the steps.",
     "前向：迹即沿其字依次历诸着之关系（«历»），字可行恰当如此有所至。过程经一映射分解，恰当每一着其关系之像在他者之内；运行之构形携步之线入其步，"
     "着在其内则运行恰为如此之像在步内之序列。",
     P('trace_iff_li', 'feasible_iff_li', 'factorsThrough_iff_image', 'run_image', 'run_iff_image')),
    ("Going on along some branch of the steps («延») is lying in a family that keeps moving, and a run goes on from "
     "where it starts. On relations on a type of the first universe, going on gives a line exactly under dependent "
     "choice, read from Onward's calibration; within finitely many configurations it gives one with nothing chosen.",
     "沿某支而延于步（«延»）即在一常动之族中，运行自其始而延。于第一宇宙之类型上之关系，延恰于依赖选择下给出一线，读自 Onward 之校准；"
     "于有限多构形之内则无所选而给出一线。",
     P('yan_iff_keepsMoving', 'run_yan', 'yan_line_iff_dependentChoice', 'yan_line_of_list')),
    ("The steps forget the moves: on one configuration with two moves, the process stepping only by true and the one "
     "stepping only by false have the same steps, and only the first is enabled by true.",
     "步忘其着：一构形二着，唯以真行之过程与唯以假行之过程同其步，而唯前者以真为可行。",
     P('Forgotten.byTrue', 'Forgotten.byFalse', 'Forgotten.moves_forgotten')),
    ("Along any map: it preserves a relation exactly where the image of the relation along it lies within the other "
     "(«保之像»), and going on along some branch reflects along any map lifting continuation, with no inverse "
     "(«延之拉回»).",
     "沿任一映射：其保一关系恰当该关系沿之之像在他者之内（«保之像»）；沿某支而延沿任一提升续之映射回射，无需逆（«延之拉回»）。",
     P('«保之像»', '«延之拉回»')),
    ("Correspondences compose side by side («一一对应».prod), and the terms the processes' representation reads are kept "
     "by a correspondence carrying what they read: steps and passing through a word, carried and kept; within n steps; "
     "a closed region where membership is carried; a fixed successor and predecessor; going alike; and going on along "
     "some branch, two cases of its pulling back.",
     "一一对应可并置（«一一对应».prod），过程之表示所读诸项为携其所读之一一对应所保：迭与历，被携且保；n 步以内；成员被携之闭区；定后与定前；同行；"
     "沿某支而延，即其拉回之二例。",
     P('«一一对应».prod', '«迭之像»', '«迭之对应»', '«历之像»', '«历之对应»', '«迭内之对应»', '«闭之对应»',
       '«定后之对应»', '«定前之对应»', '«同行之对应»', '«延之对应»')),
]
cited = [d for _, _, ds in groups for d in ds]
assert len(cited) == len(set(cited)), 'a declaration cited twice'
missing = sorted(OWN - set(cited))
assert not missing, missing
laws = [capped('laws', {'en': en, 'zh': zh, 'declarations': ds}, item=True) for en, zh, ds in groups]

title = capped('title', {'en': 'Processes represented in the grammar both ways', 'zh': '过程于文法中两向得表示'})
statement = capped('statement', {
    'en': "A process is exactly its relations, one per move, so a law over processes holds of every family of "
          "relations; every relation is a process's steps and every class a frame's claims. With the move inside, a "
          "correspondence carrying the steps and both classes is a renaming; one class alone is not enough.",
    'zh': '过程恰为其诸关系，每一着一关系，故过程上之律于每一关系之族成立；每一关系为某过程之步，每一类为某框架之断言。着在其内，携步与二类之一一对应即重名；单一类不足。'})
hypotheses = [capped('hypotheses', x, item=True) for x in (
    {'en': "The process model's commitments: configurations and moves as types, Prop-valued steps, discrete runs indexed "
           "by the natural numbers; a process is read only through its steps, so what a statement reads beyond them is "
           "outside the reading.",
     'zh': '过程模型之所承：构形与着为类型，步为命题值，离散之运行以自然数为指标；过程唯经其步读之，故陈述读于其外者在此读之外。'},
    {'en': "Faithfulness up to correspondence is for the model with the move inside, on configurations paired with "
           "moves, with the classes of the same move and the same configuration carried, from a configuration and a "
           "move given.",
     'zh': '于对应下之忠实为着在其内之模型而言，于构形与着之偶上，携同着与同构形之类，自给定之一构形与一着起。'},
    {'en': "The calibration is for relations on types of the first universe, as Onward's dependent choice is; the forward "
           "bridges are notion by notion, for the notions listed.",
     'zh': '校准为第一宇宙类型上之关系而言，如 Onward 之依赖选择；前向之桥逐概念而立，限于所列之概念。'})]
does_not_show = [capped('does_not_show', x, item=True) for x in (
    {'en': "That a statement over processes is in the grammar's terms: its truth is carried, but a statement naming an "
           "unbridged process notion (likeness by bisimulation, stretch orders, branching tests and others) stays with "
           "its model.",
     'zh': '过程上之陈述即在文法之项中：其真为所携，而言未立桥之过程概念者（互模拟之相似、段之序、分支之测等）仍随其模型。',
     'kind': 'non-implication'},
    {'en': "That every functional total relation is a determined law's step: that is unique choice on one carrier, "
           "which the core does not assume.",
     'zh': '每一函数且全之关系皆为某定律之步：此即一载体上之唯一选择，纯核不设之。', 'kind': 'non-implication'},
    {'en': "A product and its factors as one construction: the grammar relates the three carriers only through maps, "
           "forming no pairing.",
     'zh': '积与其因子为一构造：文法唯经映射关联三载体，不成偶对。', 'kind': 'scope'},
    {'en': "That a sequence whose image lies within the steps is a run's configurations: a move chosen at each step is "
           "countable choice, not assumed; with the move inside it is a run, and nothing is chosen.",
     'zh': '像在步内之序列即运行之构形：每步择一着为可数选择，不设之；着在其内则为运行，无所选。', 'kind': 'non-implication'},
    {'en': "A line from going on along some branch beyond finitely many configurations without dependent choice.",
     'zh': '无依赖选择而于有限多构形之外自沿某支而延得一线。', 'kind': 'non-implication'},
    {'en': "The theorems that read no field of the old base and are about other structures than processes (optima, "
           "weightings, regime margins and the rest), which this reading does not reach.",
     'zh': '不读旧基之域而关乎过程以外之结构之定理（最优、权重、制度边际等），此读不及之。', 'kind': 'scope'},
    {'en': "A forward theorem: no statement says every process notion is a grammar term; correspondence lemmas for the "
           "grammar's terms not listed in GrammarTransport.",
     'zh': '前向之定理：无陈述言每一过程概念皆为文法之项；GrammarTransport 未列之文法诸项之对应引理。', 'kind': 'non-implication'})]
validation = capped('validation_scope', {
    'en': "Pure core, every axiom report empty: ProcessRepresentation imports EdgeClosure, GrammarTransport, Labelled, "
          "Onward, GrammarRegularity and GrammarCandidates, and with GrammarLaws and GrammarTransport extended the whole "
          "package compiles with no name clash. Every result is pointwise; the core's List.reverse_cons reports propext, "
          "so the list lemmas «历» needs are proved by induction. The witnesses are single small processes.",
    'zh': '纯核，公理报告皆空：ProcessRepresentation 引 EdgeClosure、GrammarTransport、Labelled、Onward、GrammarRegularity 与 '
          'GrammarCandidates；GrammarLaws 与 GrammarTransport 扩充后，全包同编译，无名冲突。皆逐点；核之 List.reverse_cons 报 propext，'
          '故 «历» 所需之列表引理以归纳证之。诸例皆单一小过程。'})
next_delta = capped('next_delta', {
    'en': "Bridges for the unbridged process notions, the most named first: likeness by bisimulation, stretch orders, "
          "branching tests, adherence; whether every functional total relation is a law's step; a product and its "
          "factors as one construction; review by a person.",
    'zh': '为未立桥之过程概念立桥，先其最常名者：互模拟之相似、段之序、分支之测、依循；每一函数且全之关系是否为某律之步；积与因子为一构造；人之审查。'})
correspondence = capped('correspondence', {
    'en': "A process is a labelled transition system, and its moves' relations are its labelled transition relations; "
          "the model with the move inside is the system read on states paired with labels. That a correspondence of "
          "such models respecting both coordinates is a pair of renamings is the elementary fact that a bijection of a "
          "product preserving both projection kernels is a product of bijections. A trace as the composite along its "
          "word is the relational semantics of words (the transition monoid); a line from going on is dependent choice "
          "(Onward's calibration). Graded in WRP's DESIGN.md.",
    'zh': '过程为带标之迁移系统，其诸着之关系即其带标之迁移关系；着在其内之模型即于状态与标之偶上读之系统。此类模型之对应保其二坐标即一对重名，'
          '乃积之双射保二投影之核即为双射之积之初等事实。迹为沿其字之复合，即字之关系语义（迁移幺半群）；自延得线即依赖选择（Onward 之校准）。'
          '分级见 WRP 之 DESIGN.md。'})
counterexamples = [
    {'en': "The twist: P₁ steps exactly from true, P₂ by true from false and by false from true; flipping the "
           "configuration where the move is true carries one model to the other with the class of the same move, and "
           "no renaming relates them (Twist.models_correspond, Twist.not_renamed).",
     'zh': '扭：P₁ 恰自真而行，P₂ 自假以真、自真以假而行；于着为真处翻其构形，携一模型至另一，保同着之类，而无重名关联二者（Twist.models_correspond、Twist.not_renamed）。'},
    {'en': "The flip: P₃ steps by true everywhere, P₄ by false at true and by true at false; flipping the move where "
           "the configuration is true carries one model to the other with the class of the same configuration, and no "
           "renaming relates them (Flip.models_correspond, Flip.not_renamed).",
     'zh': '翻：P₃ 处处以真而行，P₄ 于真以假、于假以真而行；于构形为真处翻其着，携一模型至另一，保同构形之类，而无重名关联二者（Flip.models_correspond、Flip.not_renamed）。'},
    {'en': "With no move, the models of a process on one configuration and of one on two are both empty and correspond, "
           "and no correspondence of the configurations exists (NoMoves.needs_a_point).",
     'zh': '无着时，一构形之过程与二构形之过程之模型皆空而相对应，而构形之间无一一对应（NoMoves.needs_a_point）。'},
    {'en': "On one configuration, stepping only by true and only by false give the same steps, and only the first is "
           "enabled by true (Forgotten.moves_forgotten); a relation reading the next move is no process's model "
           "(reading_next_move_not_withMove).",
     'zh': '一构形上，唯以真行与唯以假行同其步，而唯前者以真为可行（Forgotten.moves_forgotten）；读下一着之关系非任何过程之模型（reading_next_move_not_withMove）。'}]

# the master-laws record's new law
master_law = capped('laws', {
    'en': "«历», passing through a word's relations in turn, with «迭» its constant family («迭即历»): it composes along "
          "joined words, reads its last letter last and the reversed word by the converse relations backward, merges "
          "nothing where no letter merges and keeps alike where each goes alike, with the list lemmas it uses. The six "
          "laws of «迭» are its cases, with statements unchanged: «迭之接», «迭之分», «迭之末步», «迭之逆», «迭之定前» and "
          "«同行之迭».",
    'zh': '«历»，依次历一字之诸关系，«迭» 为其常族（«迭即历»）：沿相接之字可接，末字母末历，逆字以逆关系倒历，无字母并则不并，各同行则保同行，并其所用之列表引理。'
          '«迭» 之六律为其例，陈述不改：«迭之接»、«迭之分»、«迭之末步»、«迭之逆»、«迭之定前»、«同行之迭»。',
    'declarations': C(set(added['Becoming.GrammarLaws']), '«历»', '«迭即历»', '«历之接»', '«历之末步»', '«历之逆»',
                      '«历之定前»', '«同行之历»', 'GrammarLaws.replicate_add_right', 'GrammarLaws.replicate_succ_right',
                      'GrammarLaws.reverseAux_append_right', 'GrammarLaws.reverse_cons_right',
                      'GrammarLaws.reverse_replicate')}, item=True)
assert sorted(master_law['declarations']) == sorted(added['Becoming.GrammarLaws']), 'GrammarLaws additions'
world_item = capped('does_not_show', {
    'en': "A representation through the order of joined exchanges; whether the descent laws follow from F3; "
          "interpretation with Lean; the grammar's terms not listed in GrammarTransport. Processes are represented in "
          "processes-represented-both-ways.",
    'zh': '经相接交换之序之表示；降律是否由 F3 推出；与 Lean 之互译；GrammarTransport 未列之文法诸项。过程之表示见 processes-represented-both-ways。',
    'kind': 'scope'}, item=True)
world_next = capped('next_delta', {
    'en': "The amount part's joint image; a representation through the order of joined exchanges; the laws that read "
          "only activity at the occurrence model (OU3f); review by a person.",
    'zh': '数量部分之共像；经相接交换之序之表示；于出现模型上唯读活动之诸律（OU3f）；人之审查。'})


def lint_errors(rec):
    found = style.lint(rec)
    for f in found:
        print('lint:', rec['id'], f['severity'], f['field'], f['rule'], f['detail'])
    return [f for f in found if f['severity'] == 'error']


assert not lint_errors({'schema_version': 2, 'id': RID, 'title': title, 'statement': statement, 'laws': laws,
                        'hypotheses': hypotheses, 'does_not_show': does_not_show,
                        'counterexamples': [{'detail': x} for x in counterexamples],
                        'validation_scope': validation, 'next_delta': next_delta,
                        'correspondence': correspondence})

if CAPS_ONLY:
    print(f'caps: ok; {len(cited)} declarations in {len(laws)} laws; statement', len(statement['en']),
          len(statement['zh']), '; validation', len(validation['en']), len(validation['zh']), '; next',
          len(next_delta['en']), len(next_delta['zh']), '; correspondence', len(correspondence['en']),
          len(correspondence['zh']), '; laws max', max(len(x['en']) for x in laws), max(len(x['zh']) for x in laws),
          '; master law', len(master_law['en']), len(master_law['zh']), '; world item', len(world_item['en']),
          len(world_item['zh']))
    raise SystemExit(0)

lean_refs = [{'path': LEAN[m], 'role': 'proof', 'sha256': sha(LEAN[m])}
             for m in ('GrammarLaws', 'GrammarRegularity', 'GrammarCandidates', 'GrammarCourse', 'GrammarMap', 'Grammar',
                       'Labelled', 'Onward', 'EdgeClosure', 'Frame', 'Likeness', 'Experiment', 'Recurrence', 'Arising')]
common_refs = [{'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
               {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
               {'path': DESIGN, 'role': 'integration', 'sha256': sha(DESIGN)},
               {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
               {'path': REVIEW2, 'role': 'integration', 'sha256': sha(REVIEW2)},
               {'path': MEASURE, 'role': 'integration', 'sha256': sha(MEASURE)},
               {'path': SIGNATURES, 'role': 'integration', 'sha256': sha(SIGNATURES)}]
binding = [{'source': LEAN[m.split('.')[1]], 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/{m}',
            'success_pointer': '/status', 'success_value': 'passed'}
           for m in ('Becoming.ProcessRepresentation', 'Becoming.GrammarTransport')]
own_refs = [{'path': LEAN[m.split('.')[1]], 'role': 'proof',
             'declarations': sorted(d for d in cited if d in pool), 'sha256': sha(LEAN[m.split('.')[1]])}
            for m, pool in (('Becoming.ProcessRepresentation', names['Becoming.ProcessRepresentation']),
                            ('Becoming.GrammarTransport', set(added['Becoming.GrammarTransport'])))]


def dep(rid, en, zh):
    return {'id': rid, 'relation': 'formal-reuse', 'detail': {'en': en, 'zh': zh}}


record = {
    'schema_version': 2,
    'id': RID,
    'title': title,
    'kind': 'theorem',
    'status': 'recorded-checked',
    'family': 'F01',
    'reviewed_at_utc': NOW,
    'statement': statement,
    'laws': laws,
    'hypotheses': hypotheses,
    'does_not_show': does_not_show,
    'counterexamples': [{'path': LEAN['ProcessRepresentation'], 'detail': x} for x in counterexamples],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'formal-not-empirical', 'names-provisional',
                            'omission-not-refutation'],
    'validation_scope': validation,
    'next_delta': next_delta,
    'correspondence': correspondence,
    'canonical_source': LEAN['ProcessRepresentation'],
    'aliases': ["The processes' representation theorem", '过程之表示定理', 'the model with the move inside', '着在其内之模型',
                'Becoming.withMove_renamed', 'Becoming.forall_steps_iff', 'Becoming.trace_iff_li',
                'Becoming.yan_line_iff_dependentChoice'],
    'dependencies': [
        dep(RIDM, "«历» and its laws, «迭», «像», «闭», «定后», «定前» and «同行».", '«历» 及其律，«迭»、«像»、«闭»、«定后»、«定前» 与 «同行»。'),
        dep(RIDW, "«一一对应», «对应之像» with its pointwise and back readings, the carrying of «静», «而» and inclusion, "
                  "«续之对应», and «尽之拉回»'s pattern.",
            '«一一对应»、«对应之像» 及其逐点与回读，«静»、«而» 与含之携，«续之对应»，及 «尽之拉回» 之式。'),
        dep('rules-that-change-themselves-in-the-grammar', "moveRel, a move of a process read as a relation.",
            'moveRel：过程之一着读为一关系。'),
        dep('process-and-frame-as-readings', "withMove, withMove_open and unlabelled.", 'withMove、withMove_open 与 unlabelled。'),
        dep('becoming-spine-instances', "edgeProcess and Frame.", 'edgeProcess 与 Frame。'),
        dep('candidate-theorems-of-the-corpus', "«能», the correlative.", '«能»，相关者。'),
        dep('tests-fix-likeness-where-determined', "AlikeTo, likeness to a depth.", 'AlikeTo：至某深之相似。'),
        dep('experiment-needs-return', "FactorsThrough, a step factoring through a map.", 'FactorsThrough：步经映射而分解。'),
        dep('wen-in-the-grammar', "Law.step, a determined law's step read as 缘.", 'Law.step：定律之步读为缘。'),
        dep('recurrence-without-premise', "Law.process, a determined law as a process.", 'Law.process：定律为过程。'),
        dep('where-a-run-goes-on', "Onward.KeepsMoving, KeepsMoving.run, DependentChoice and runs_iff_dependentChoice.",
            'Onward.KeepsMoving、KeepsMoving.run、DependentChoice 与 runs_iff_dependentChoice。'),
        dep('levels-of-closure', "Steps, one step of a process whatever its move.", 'Steps：过程之一步，无论其着。'),
        dep('continuation-relative-to-a-class', "Steps.next, the steps' 缘.", 'Steps.next：诸步之缘。'),
        dep('generation-and-degeneration-at-two-grains', "«延», going on along some branch.", '«延»：沿某支而延。'),
        dep('histories-fix-law-up-to-dead-ends', "trace_nil_iff and trace_cons_iff, a trace's two cases.",
            'trace_nil_iff 与 trace_cons_iff：迹之二例。')],
    'related': [{'id': RIDW, 'detail': {
        'en': "The World's representation and this one are two models of the grammar read both ways: the World fails on "
              "its amounts, processes on nothing their steps carry, and both read their terms through GrammarTransport.",
        'zh': '世界之表示与此为文法两向读之二模型：世界于其数量不成，过程于其步所载者无所不成；二者皆经 GrammarTransport 读其诸项。'}}],
    'references': own_refs + lean_refs + common_refs + [{'path': CH1, 'role': 'statement', 'sha256': sha(CH1)}],
    'proof_bindings': binding,
    'history': [{
        'en': f'{DATE_EN}: added (WRP2), processes represented in the grammar both ways: a process exactly its relations, '
              f'one per move, a law\'s truth carried to every family of relations; the converse, with the model with the '
              f'move inside faithful up to correspondence carrying both classes and neither alone; the forward bridges '
              f'and the calibration read on the grammar; after the design\'s review and re-read, a review of the Lean; '
              f'study section {N}.',
        'zh': f'{DATE_ZH}：新增（WRP2），过程于文法中两向得表示：过程恰为其诸关系，每一着一关系，律之真携至每一关系之族；逆向，着在其内之模型携二类则于对应下忠实，'
              f'单一类不足；前向之桥与于文法上读之校准；经设计之审及其复读、Lean 之审；研究第 {N} 节。'}],
}

for rid in [x['id'] for x in record['dependencies']]:
    assert (RECORDS / f'{rid}.json').exists(), rid
path = RECORDS / f'{RID}.json'
assert not path.exists(), path
path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record:', RID, len(cited), 'declarations in', len(groups), 'laws')

# the master-laws record: one law added, its GrammarLaws reference extended, a history note
p = RECORDS / f'{RIDM}.json'
d = json.loads(p.read_text(encoding='utf-8'))
before = json.dumps({k: v for k, v in d.items() if k not in ('laws', 'references', 'history')}, ensure_ascii=False)
assert not any(set(master_law['declarations']) & set(x.get('declarations', [])) for x in d['laws']), 'cited already'
# beside the laws of steps counted, where «迭之末步» is (OU3d's part), as the record's owner asked
counted = [i for i, x in enumerate(d['laws']) if 'Becoming.«迭之末步»' in x.get('declarations', [])]
assert len(counted) == 1, counted
d['laws'].insert(counted[0] + 1, master_law)
assert len(d['laws']) <= style.ITEM_CAPS_V2['laws'][2]
refs = [r for r in d['references'] if r['path'] == LEAN['GrammarLaws']]
assert len(refs) == 1, refs
refs[0]['declarations'] = sorted(set(refs[0].get('declarations', [])) | set(master_law['declarations']))
d['history'].append({
    'en': f"{DATE_EN} (WRP2, study section {N}): passing through a word's relations in turn («历»), n steps its case for "
          f"one relation, stated beside n steps; six laws of n steps proved as cases of its laws with their statements "
          f"and names unchanged (GrammarLaws' owner's decision (a)), and the list lemmas it uses proved by induction, "
          f"the core's List.reverse_cons reporting propext.",
    'zh': f"{DATE_ZH}（WRP2，研究第 {N} 节）：依次历一字之诸关系（«历»），n 步为其一关系之例，置于 n 步之旁；n 步之六律证为其律之例，陈述与名不改"
          f"（GrammarLaws 主之决定 (a)）；其所用之列表引理以归纳证之，因核之 List.reverse_cons 报 propext。"})
assert json.dumps({k: v for k, v in d.items() if k not in ('laws', 'references', 'history')}, ensure_ascii=False) == before
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record:', RIDM, 'law', counted[0] + 2, 'of', len(d['laws']), 'added with', len(master_law['declarations']),
      'declarations')

# the World's record: its item and next step on processes brought to the landed theorem
p = RECORDS / f'{RIDW}.json'
d = json.loads(p.read_text(encoding='utf-8'))
items = [x for x in d['does_not_show'] if x['en'].startswith('Processes; ')]
assert len(items) == 1, items
items[0].update(world_item)
assert d['next_delta']['en'].startswith('A representation theorem for processes; ')
d['next_delta'] = world_next
assert not any(x['id'] == RID for x in d.get('related', []))
d.setdefault('related', []).append({'id': RID, 'detail': {
    'en': "Processes are represented in the grammar both ways by their moves' relations, faithful up to correspondence "
          "with the move inside and both classes; the World's representation reads its terms through the same "
          "GrammarTransport.",
    'zh': '过程以其诸着之关系于文法中两向得表示，着在其内携二类则于对应下忠实；世界之表示经同一 GrammarTransport 读其诸项。'}})
d['history'].append({
    'en': f"{DATE_EN} (WRP2, study section {N}): its item and next step on processes brought to the landed theorem, "
          f"processes-represented-both-ways, as a related record; no statement, law or declaration changed.",
    'zh': f"{DATE_ZH}（WRP2，研究第 {N} 节）：其言过程之项与下一步归于已成之定理 processes-represented-both-ways，列为相关；陈述、律与声明皆不改。"})
assert not lint_errors(d)
p.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record:', RIDW, 'item and next step on processes brought to', RID)
