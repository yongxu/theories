#!/usr/bin/env python3
"""WRT2 record: write the-world-represented-both-ways (Becoming.WorldRepresentation with Becoming.GrammarTransport as
its lemma module, homed at 01 §8.6), each declaration of the two modules cited once. The failure on amounts is stated
as plainly as the success: in the statement, the laws, the does-not-show items and the counterexamples. The record
reorderings-as-courses-of-growth, whose does-not-show item named the World's representation theorem, has that item
brought to the landed theorem, a related entry and a history note; its statement, next step and declarations do not
change. Asserts the receipt's hash and empty axiom reports for both modules, and the style caps and lint
(tools/research/style.py) on every field written. Mirrors UE15's make_records_ue15.py.
usage (from the checkout root, after texts_wrt2.py): python3 -B make_records_wrt2.py RECEIPT N
       python3 -B make_records_wrt2.py --caps  (the caps, lint and declaration cover against the kit's scratch audits;
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
RECEIPT_ID, N = ('20261029T000000.000000Z', 440) if CAPS_ONLY else (sys.argv[1], int(sys.argv[2]))
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RF + 'BECOMING-RENEWAL-READING.md'
KITD = RF + 'development/world-representation/'
DESIGN, REVIEW, REVIEW2 = KITD + 'DESIGN.md', KITD + 'REVIEW-WRT.md', KITD + 'REVIEW-WRT2.md'
CH1 = 'theories/becoming/chapters/01-ROOT.md'
LEAN = {m: f'{PKG}/Becoming/{m}.lean' for m in
        ('GrammarTransport', 'WorldRepresentation', 'ContinuedClasses', 'Persistence', 'Identity', 'Arising',
         'Change', 'Amounts', 'Diagonal', 'Decidedness', 'GrammarLaws', 'GrammarMap', 'Grammar', 'Space')}
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
RID = 'the-world-represented-both-ways'
RIDU = 'reorderings-as-courses-of-growth'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
TODAY = datetime.date.today()
DATE_EN, DATE_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'
MODS = {'Becoming.GrammarTransport': 44, 'Becoming.WorldRepresentation': 48}


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def capped(field, pair, item=False):
    caps = style.ITEM_CAPS_V2 if item else style.CAPS_V2
    en, zh = caps[field][:2]
    assert len(pair['en']) <= en and len(pair['zh']) <= zh, (field, len(pair['en']), en, len(pair['zh']), zh, pair['en'][:60])
    return pair


names = {}
if CAPS_ONLY:
    for m in MODS:
        short = m.replace('.', '')
        audit = (HERE.parent / f'tree/.build/{short}AxiomAudit.lean').read_text(encoding='utf-8')
        names[m] = set(re.findall(r'^#print axioms (\S+)$', audit, re.M))
else:
    core = json.loads((ROOT / RECEIPT).read_text())
    assert core['status'] == 'passed'
    for m in MODS:
        assert core['source_sha256'][m] == sha(LEAN[m.split('.')[1]]), m
        mod = next(x for x in core['modules'] if x['module'] == m)
        assert not any(mod['axiom_dependencies'].values()), m
        names[m] = {d['name'] for d in mod['declarations']}
for m, count in MODS.items():
    assert len(names[m]) == count, (m, len(names[m]))
ALL = names['Becoming.GrammarTransport'] | names['Becoming.WorldRepresentation']


def C(*short):
    out = ['Becoming.' + s for s in short]
    missing = [n for n in out if n not in ALL]
    assert not missing, missing
    return out


groups = [
    ("A one-to-one correspondence of carriers («一一对应», with its inverse and composite) carries R to R' where the "
     "image of R along it is R' («谓» («像» e.to R) R'), exactly where two things are related exactly where their images "
     "are («对应之像»); read back and pointwise, the inverse carries back, composites carry the composite, and every "
     "relation on the second carrier is the image of what it reads back.",
     "一一对应（«一一对应»，及其逆与合成）携 R 至 R'，当 R 沿之之像为 R'（«谓» («像» e.to R) R'），恰当二者相关恰当其像相关（«对应之像»）；"
     "逐点与回读之，逆对应携回，合成携合成，第二载体上每一关系为其回读者之像。",
     C('«一一对应»', '«一一对应».symm', '«一一对应».trans', '«一一对应».to_eq_iff', '«对应之像»', '«对应之逐点»',
       '«对应之回»', '«回之像»', '«谓之自反»', '«反对应之像»', '«合成之像»')),
    ("Carrying is kept by the grammar's operations, the meet, the converse, composition and reach («合之像», «逆之像», "
     "«而之像», «及之像»), and inclusion is kept («则之对应»); identity and the one are carried («静之像», «一之像»), and a "
     "predicate is carried as its partial identity «合» «静» (fun x _ => P x) where it holds exactly where it holds at the "
     "image («部分恒等之像»).",
     "携为文法之运算所保：合、逆、而、及（«合之像»、«逆之像»、«而之像»、«及之像»），含亦保（«则之对应»）；静与一被携（«静之像»、«一之像»），"
     "谓词以其部分恒等 «合» «静» (fun x _ => P x) 被携，当其恰于像处成立（«部分恒等之像»）。",
     C('«合之像»', '«逆之像»', '«而之像»', '«及之像»', '«则之对应»', '«静之像»', '«一之像»', '«部分恒等之像»')),
    ("The continuation family is kept: a correspondence carrying 缘 and the class carries reach, continuation, lines, "
     "reach on a line, closure and families, having a condition or a consequence, beginning, ending, abiding, "
     "alteration (with the finer class), renewal and going on without end, each at x exactly where at e.to x (and the "
     "nine more of the family).",
     "续之族为所保：携缘与类之一一对应携及、续、相续、所及、所闭、同族、有前、有后、生、亡、住、异（携细类）、复生、不穷，各于 x 恰当于 e.to x。",
     C('«及之对应»', '«续之对应»', '«相续之对应»', '«所及之对应»', '«所闭之对应»', '«同族之对应»', '«有前之对应»',
       '«有后之对应»', '«生之对应»', '«亡之对应»', '«住之对应»', '«异之对应»', '«复生之对应»', '«不穷之对应»')),
    ("Being a class, acyclicity and constancy are kept both ways, and the core is kept at every pair: forward through the "
     "image of the witnessing relation, back through the relation it reads back («类之对应», «无环之对应», «有常之对应», "
     "«核之对应»).",
     "为类、无环与有常两向皆保，核于每一对皆保：前向经见证关系之像，回向经其回读之关系（«类之对应»、«无环之对应»、«有常之对应»、«核之对应»）。",
     C('«类之对应»', '«无环之对应»', '«有常之对应»', '«核之对应»')),
    ("The map's terms are kept: carrying renewal, a carrying renewal within reach, generation and keeping in the strong "
     "form, and reaching an end («传之对应», «所及有传之对应», «全生成之对应», «全守之对应», «有终之对应»).",
     "图之诸项为所保：传、所及中有传、全生成、全守、有终（«传之对应»、«所及有传之对应»、«全生成之对应»、«全守之对应»、«有终之对应»）。",
     C('«传之对应»', '«所及有传之对应»', '«全生成之对应»', '«全守之对应»', '«有终之对应»')),
    ("Ending on every branch is pulled back along any map carrying continuation from a region closed under it into "
     "continuation of another model, with no inverse («尽之拉回»); its keeping by a correspondence is two cases of it "
     "(«尽之对应»).",
     "处处终尽沿任一自闭区携续入他模型之续之映射拉回，无需逆（«尽之拉回»）；其为一一对应所保即其二例（«尽之对应»）。",
     C('«尽之拉回»', '«尽之对应»')),
    ("The occurrence model's name-free part: the class of being at the same step, conservation's step, a relation within "
     "each step, and the partial identity of a predicate (Web.sameStep, World.conservationStep, World.withinStep, "
     "Web.partialIdentity); the names' step is the step along the names' continuation (Steps.along_iff_itself).",
     "出现模型之无名部分：同步之类、守恒之步、一步之内之关系、谓词之部分恒等（Web.sameStep、World.conservationStep、World.withinStep、"
     "Web.partialIdentity）；名之步即沿名之续之步（Steps.along_iff_itself）。",
     C('Web.sameStep', 'Web.sameStep_class', 'Web.partialIdentity', 'World.conservationStep', 'World.withinStep',
       'Steps.along_iff_itself')),
    ("A later step, and the same step or later, are read at the model along the names and across by the same step "
     "(Steps.later_iff, Steps.sameOrLater_iff); so arising and ceasing recurring are statements at the model through the "
     "names' step, each with the conjunct that an occurrence exists (World.arisingRecurs_iff, World.ceasingRecurs_iff).",
     "较晚之步与同步或较晚，于模型上沿名并经同步读之（Steps.later_iff、Steps.sameOrLater_iff）；故生之屡与亡之屡经名之步为模型上之陈述，"
     "各带有一出现之合取（World.arisingRecurs_iff、World.ceasingRecurs_iff）。",
     C('Steps.later_iff', 'Steps.sameOrLater_iff', 'World.arisingRecurs_iff', 'World.ceasingRecurs_iff')),
    ("Every re-identification is a one-to-one correspondence of the relata at each step and of the occurrences, carrying "
     "the name-free part's ten relations: the same-step class, conservation's step (its conservation is the carried one), "
     "activity, standing and presence as partial identities, and five relations within a step; so beginning under "
     "conservation is fixed (World.reidentify_carries and nine more).",
     "每一重认为每步关系项与诸出现之一一对应，携无名部分之十关系：同步之类、守恒之步（其守恒即所携者）、活动站位与在场为部分恒等、一步之内五关系；"
     "故守恒下之生为所定（World.reidentify_carries 等十律）。",
     C('Reidentify.atStep', 'Reidentify.onOccurrences', 'Reidentify.sameStep_carried', 'Reidentify.withinStep_carried',
       'Reidentify.partialIdentity_carried', 'World.conserves_reidentify', 'World.conservationStep_reidentify',
       'World.activityClass_reidentify', 'World.reidentify_carries', 'World.sheng_conservation_reidentify')),
    ("The relational part ranges over everything: any activity, requiring, drawing and presence is some world's, with no "
     "amount, and at the model any predicate's partial identity, two relations lying within a step and presence lists "
     "are the relational part of a world's model (World.ofRelations, World.ofModel and their lemmas).",
     "关系部分遍及一切：任一活动、所需、所取与在场为某世界者，无数量；于模型上，任一谓词之部分恒等、二在一步之内之关系与在场之列，"
     "为某世界模型之关系部分（World.ofRelations、World.ofModel 及其引理）。",
     C('World.ofRelations', 'World.ofRelations_relations', 'World.ofModel', 'World.ofModel_model')),
    ("Conservation is exactly a relation 'f's standing after the step with b is a': every world's has this form by "
     "definition, and every such relation is some world's, one relatum exchanging (World.conserves_form, "
     "World.ofConservationForm_conserves); through one conserving pair it is labelled by standings after the step, so "
     "difunctional (World.conserves_iff_same_level, World.conserves_difunctional).",
     "守恒恰为「f 步后之站位加 b 为 a」之关系：每一世界之守恒依定义有此形，每一此等关系为某世界者，一关系项交换（World.conserves_form、"
     "World.ofConservationForm_conserves）；经一守恒之对，其为步后站位所标，故为双函数（World.conserves_iff_same_level 等）。",
     C('World.conserves_form', 'World.ofConservationForm', 'World.ofConservationForm_conserves',
       'World.conserves_iff_same_level', 'World.conserves_difunctional')),
    ("What amounts induce is decided: conservation, a need met, giving, taking, standing and falling; on one relatum, "
     "conservation is a proposition Q across every step exactly where Q is decided, a lemma of whole-number equations "
     "(compare indicates_iff_decided); and that every world decides its activity is exactly excluded middle "
     "(World.amounts_decided and three more).",
     "数量所引者皆可判定：守恒、所需得足、予、取、站位与落；于一关系项上，守恒于每步为命题 Q 恰当 Q 可判定，自然数等式之引理（参 indicates_iff_decided）；"
     "每一世界判定其活动恰为排中律（World.amounts_decided 等四律）。",
     C('World.conserves_decided', 'World.amounts_decided', 'World.conservation_iff_decided',
       'World.decides_activity_iff_em')),
    ("F1, standings not determined: two worlds standing at positive k and k', with nothing exchanged, agree at every step "
     "on each field the model's selection reads (activity, standing, requiring, drawing, presence, a need met, giving, "
     "taking, conservation, falling), while their standings are k and k' (World.standingAt_alike).",
     "F1，站位不为所定：二世界站位于正之 k 与 k'，无所交换，于每步在模型所选读之每一域上皆合（活动、站位、所需、所取、在场、所需得足、予、取、守恒、落），"
     "而其站位为 k 与 k'（World.standingAt_alike）。",
     C('World.standingAt', 'World.standingAt_alike')),
    ("F1′, balance not determined by the web and the signs of exchange: no property of a world's web and its signs of "
     "exchange (who is present, who gives to and takes from whom) that keeps to the signs' agreement is balance; the idle "
     "world balances and its double, giving itself two units, does not (World.balance_needs_conservation and five more).",
     "F1′，网与交换之号不定平衡：世界之网与其交换之号（谁在场、谁予谁、谁取于谁）之任何守号之合之性质皆非平衡；闲世界平衡，其倍（自予二单位）则否"
     "（World.balance_needs_conservation 等六）。",
     C('World.ExchangeSigns', 'World.exchangeSigns', 'World.ExchangeSigns.Agree', 'World.idleTwice',
       'World.idleTwice_unbalanced', 'World.balance_needs_conservation')),
    ("F2, identity not induced: where conservation across a step is identity, the standings after it tell every two "
     "relata apart, and no map of the predicates on Nat into Nat is one to one (from Diagonal.claims_incomplete), so on "
     "the predicates of Nat conservation is never identity (World.not_conserves_identity and two more).",
     "F2，同一不由数量所引：守恒于一步为同一处，步后站位分辨每二关系项；Nat 之谓词入 Nat 之映射皆非单射（由 Diagonal.claims_incomplete），"
     "故于 Nat 之谓词上守恒永非同一（World.not_conserves_identity 等三）。",
     C('World.conserves_identity_injective', 'Diagonal.no_injection_of_predicates', 'World.not_conserves_identity')),
    ("F3, a line of falls ends: along the names it ends on every branch, from the amounts' law of falls ending at whole "
     "numbers (Amounts.falls_end) through «尽之拉回», so it does not go on without end and no world with a relatum falls "
     "at every occurrence; a line under a class holding everywhere goes on without end, so this is a condition of the "
     "image (World.falls_exhaust and three more).",
     "F3，落之线终尽：沿名处处终尽，由整数上落终之律（Amounts.falls_end）经 «尽之拉回»，故不不穷，有关系项之世界无处处皆落者；"
     "处处成立之类下之线不穷，故此为像之条件（World.falls_exhaust 等四）。",
     C('World.falls_exhaust', 'World.falls_not_endless', 'World.not_falls_everywhere', 'Steps.along_endless')),
]
cited = [d for _, _, ds in groups for d in ds]
assert len(cited) == len(set(cited)), 'a declaration cited twice'
missing = sorted(ALL - set(cited))
assert not missing, missing
laws = [capped('laws', {'en': en, 'zh': zh, 'declarations': ds}, item=True) for en, zh, ds in groups]

title = capped('title', {'en': 'The World represented in the grammar both ways, its amounts not',
                         'zh': '世界于文法中两向得表示，其数量则否'})
statement = capped('statement', {
    'en': "The World's relations are a model of the grammar both ways: every re-identification is a correspondence of "
          "its name-free part, and every relational part is some world's. Its amounts are not: the model does not "
          "determine standings, and balance is carried only by conservation's step.",
    'zh': '世界之关系两向为文法之模型：每一重认为其无名部分之一一对应，每一关系部分为某世界者。其数量则否：模型不定站位，平衡唯由守恒之步所载。'})
hypotheses = [capped('hypotheses', x, item=True) for x in (
    {'en': "The World's modelling commitments: discrete steps with one shared index, the same relata at every step, "
           "whole-number amounts, Prop-valued activity, requiring and drawing, and equality on relata.",
     'zh': '世界之建模所承：离散之步共一指标，每步同一关系项，整数数量，活动、所需、所取为命题值，关系项上之相等。'},
    {'en': "The name-free part is a stated selection: amounts read only by sign, against a need and in conservation's "
           "equation, the index only through the same-step class and the steps' own 缘; a re-identification carries "
           "more, such as a standing's value or the step order.",
     'zh': '无名部分为明言之选：数量唯以号、对所需与守恒之式读之，指标唯经同步之类与诸步自身之缘；重认所携者更多，如站位之值或步之序。'},
    {'en': "The forward direction is a schema of instance theorems; transport is shown for the terms listed in "
           "GrammarTransport, each with the relations it reads carried.",
     'zh': '前向为实例定理之格式；搬运仅于 GrammarTransport 所列诸项示之，各带其所读关系之携。'})]
does_not_show = [capped('does_not_show', x, item=True) for x in (
    {'en': "That amounts are represented: the model does not determine a world's standings, so a world is not recovered "
           "from its model.",
     'zh': '数量得表示：模型不定世界之站位，故世界不能自其模型复得。', 'kind': 'non-implication'},
    {'en': "That balance is derived: at the occurrence model only conservation's step carries it, defined from the "
           "balance equation; unit pairings and an idle added relatum are near-definitional too; F1′ reads the web and "
           "signs only.",
     'zh': '平衡得推出：于出现模型唯守恒之步载之，其由平衡式定义；单位之配对与闲之增项亦近乎定义；F1′ 只读网与号。', 'kind': 'non-implication'},
    {'en': "The amount part's image beyond conservation alone: its form is exact taken alone, with one relatum "
           "present; the joint image with presence, falls and the other relations is open.",
     'zh': '守恒之外数量部分之像：其形单独取之为确，一关系项在场；与在场、落及他关系之共像未决。', 'kind': 'scope'},
    {'en': "Anything beyond whole amounts: decidedness comes from their equations; F2 gives not identity, not two relata "
           "standing alike; F3 runs along one relatum's line, on the least loss one, not settling rest as no endless fall.",
     'zh': '整数数量之外之事：可判定出于其等式；F2 给出非同一，非二关系项站位相同；F3 沿一关系项之线、依最小损一，未定止即无无穷之落。', 'kind': 'scope'},
    {'en': "That a world leaves its activity undecided: none can be shown to (not_not_decided); what holds is that every "
           "world deciding it is exactly excluded middle, activity being Prop-valued, a modelling choice.",
     'zh': '某世界之活动不可判定：无可示者（not_not_decided）；成立者为每一世界判定之恰为排中律，活动为命题值，乃建模之选。', 'kind': 'non-implication'},
    {'en': "A forward theorem: no statement says every World notion is a grammar term, and that keeping to "
           "correspondences gives a term is not stated, the embedding having no syntax of terms.",
     'zh': '前向之定理：无陈述言每一世界之概念为文法之项；守对应即给出项亦未陈述，因嵌入无项之语法。', 'kind': 'non-implication'},
    {'en': "Re-identification beyond the ten relations and the class of activity: that the names' step is carried only "
           "by renamings the same at every step, and the faithful but not full reading, are not in Lean.",
     'zh': '十关系与活动之类之外之重认：名之步唯为每步同之重名所携，及忠实而非满之读，皆未入 Lean。', 'kind': 'scope'},
    {'en': "Processes; a representation through the order of joined exchanges; whether the descent laws follow from F3; "
           "interpretation with Lean; the grammar's terms not listed in GrammarTransport.",
     'zh': '过程；经相接交换之序之表示；降律是否由 F3 推出；与 Lean 之互译；GrammarTransport 未列之文法诸项。', 'kind': 'scope'})]
validation = capped('validation_scope', {
    'en': "Pure core, every axiom report empty: GrammarTransport imports GrammarLaws, WorldRepresentation imports "
          "ContinuedClasses, Decidedness, Diagonal and GrammarTransport; both compile with the whole package and no "
          "name clash. Modelling choices: the World's own; the witnesses are single small worlds; every result is "
          "pointwise, with no function extensionality.",
    'zh': '纯核，公理报告皆空：GrammarTransport 引 GrammarLaws，WorldRepresentation 引 ContinuedClasses、Decidedness、Diagonal 与 GrammarTransport；'
          '二者与全包同编译，无名冲突。建模之选为世界自身者；诸例皆单一小世界；皆逐点，不用函数外延性。'})
next_delta = capped('next_delta', {
    'en': "A representation theorem for processes; the amount part's joint image; a representation through the order "
          "of joined exchanges; the laws that read only activity at the occurrence model (OU3f); review by a person.",
    'zh': '过程之表示定理；数量部分之共像；经相接交换之序之表示；于出现模型上唯读活动之诸律（OU3f）；人之审查。'})
correspondence = capped('correspondence', {
    'en': "That definable properties are kept by isomorphisms of structures is standard model theory; here it is shown "
          "term by term, since the grammar is embedded with no syntax of terms. Difunctional relations are Riguet's "
          "(1948). The no-injection lemma is the constructive form of Cantor's theorem for a powerset, through the "
          "package's diagonal lemma (Lawvere 1969 states the general form). That conservation is labelled by standings "
          "is the cancellation of a whole-number equation. The representation is an interpretation of the World into "
          "grammar models, faithful on re-identifications and not injective on amounts. Graded in WRT's DESIGN.md.",
    'zh': '可定义之性质为结构同构所保，为标准模型论；此处逐项示之，因文法之嵌入无项之语法。双函数关系为 Riguet（1948）所立。无单射之引理为幂集 Cantor 定理之构造形，'
          '经本包之对角引理（Lawvere 1969 述其一般形）。守恒为站位所标，即整数等式之消去。此表示为世界入文法模型之诠释，于重认忠实，于数量非单射。分级见 WRT 之 DESIGN.md。'})
counterexamples = [
    {'en': "Two worlds of one relatum, never active, standing at 1 and at 2 throughout with nothing exchanged, agree on "
           "every field the model reads (World.standingAt_alike): the model does not determine standings.",
     'zh': '二一关系项之世界，从不活动，始终站位于 1 与 2，无所交换，于模型所读之每一域上皆合（World.standingAt_alike）：模型不定站位。'},
    {'en': "The idle world, one relatum never active and standing at the number of steps, gives itself one unit a step "
           "and balances; giving itself two it does not, with the same web and signs of exchange "
           "(World.balance_needs_conservation).",
     'zh': '闲世界，一关系项从不活动、站位于步数，每步自予一单位而平衡；自予二单位则否，网与交换之号皆同（World.balance_needs_conservation）。'},
    {'en': "On the predicates of Nat as relata, conservation across a step is identity in no world "
           "(World.not_conserves_identity).",
     'zh': '以 Nat 之谓词为关系项，任何世界于一步之守恒皆非同一（World.not_conserves_identity）。'},
    {'en': "The model of one relatum's line of steps under the class of a predicate holding everywhere goes on without "
           "end, while no world's line of falls does (Steps.along_endless, World.falls_not_endless).",
     'zh': '一关系项之步线于处处成立之谓词之类下之模型不穷，而无世界之落之线如此（Steps.along_endless、World.falls_not_endless）。'}]


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
          '; hypotheses max', max(len(x['en']) for x in hypotheses), max(len(x['zh']) for x in hypotheses),
          '; does_not_show max', max(len(x['en']) for x in does_not_show), max(len(x['zh']) for x in does_not_show))
    raise SystemExit(0)

lean_refs = [{'path': LEAN[m], 'role': 'proof', 'sha256': sha(LEAN[m])}
             for m in ('ContinuedClasses', 'Persistence', 'Identity', 'Arising', 'Change', 'Amounts', 'Diagonal',
                       'Decidedness', 'GrammarLaws', 'GrammarMap', 'Grammar', 'Space')]
common_refs = [{'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
               {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
               {'path': DESIGN, 'role': 'integration', 'sha256': sha(DESIGN)},
               {'path': REVIEW, 'role': 'integration', 'sha256': sha(REVIEW)},
               {'path': REVIEW2, 'role': 'integration', 'sha256': sha(REVIEW2)}]
binding = [{'source': LEAN[m.split('.')[1]], 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/{m}',
            'success_pointer': '/status', 'success_value': 'passed'} for m in MODS]
own_refs = [{'path': LEAN[m.split('.')[1]], 'role': 'proof',
             'declarations': sorted(d for d in cited if d in names[m]), 'sha256': sha(LEAN[m.split('.')[1]])}
            for m in MODS]


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
    'counterexamples': [{'path': LEAN['WorldRepresentation'], 'detail': x} for x in counterexamples],
    'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'formal-not-empirical', 'names-provisional',
                            'omission-not-refutation'],
    'validation_scope': validation,
    'next_delta': next_delta,
    'correspondence': correspondence,
    'canonical_source': LEAN['WorldRepresentation'],
    'aliases': ["The World's representation theorem", '世界之表示定理', 'the occurrence model', '出现模型',
                'the grammar kept by correspondence', 'Becoming.World.reidentify_carries',
                'Becoming.World.standingAt_alike', 'Becoming.World.balance_needs_conservation',
                'Becoming.World.ofConservationForm_conserves', 'Becoming.World.falls_exhaust'],
    'dependencies': [
        dep('continuation-relative-to-a-class',
            "The grammar's continuation family, Steps.along, Web.activityClass, Web.continuationStep and the instance "
            "theorems Web.unceasing_iff_late_beginnings and Web.ceases_iff_wang.",
            '文法之续之族、Steps.along、Web.activityClass、Web.continuationStep 及实例定理 Web.unceasing_iff_late_beginnings 与 Web.ceases_iff_wang。'),
        dep('identity-across-steps',
            "Reidentify, World.reidentify, World.Conserves, reidentify_taken and reidentify_given, Reidentify.mem_map and "
            "World.balanced_iff_conserves.",
            'Reidentify、World.reidentify、World.Conserves、reidentify_taken 与 reidentify_given、Reidentify.mem_map 与 World.balanced_iff_conserves。'),
        dep('classes-along-a-continuation', "Web.itself, the names' continuation, and Reidentify.carry.",
            'Web.itself（名之续）与 Reidentify.carry。'),
        dep('master-laws-on-the-grammar', "«像», «闭» and «所闭», and Amounts.falls_end, the amounts' law of falls ending.",
            '«像»、«闭» 与 «所闭»，及数量落终之律 Amounts.falls_end。'),
        dep('least-loss-rest', "Amounts.whole_within: in whole numbers every stock lies within its count of least losses.",
            'Amounts.whole_within：整数中每一存量在其最小损之数之内。'),
        dep('generation-and-degeneration-at-two-grains',
            "The map's terms: «所及», «尽», «尽则非不穷», «传», «全生成», «全守» and «有终».",
            '图之诸项：«所及»、«尽»、«尽则非不穷»、«传»、«全生成»、«全守» 与 «有终»。'),
        dep('readings-within-what-they-read', "Diagonal.claims_incomplete, the diagonal lemma.",
            '对角引理 Diagonal.claims_incomplete。'),
        dep('counts-exist-where-decided', "Decided, a proposition holding or failing.", 'Decided：命题或成立或不成立。'),
        dep('space-and-its-parts', "World.idle and World.idle_world, the idle world, and Flow.still.",
            '闲世界 World.idle 与 World.idle_world，及 Flow.still。'),
        dep('worlds-are-runs', "World.of, the world with given relata, flow and web.", 'World.of：给定关系项、流与网之世界。')],
    'related': [{'id': RIDU, 'detail': {
        'en': "The interleavings are one aspect of the World's representation: the occurrence model reads the shared "
              "index, which a world's reorderings change while keeping the order of joined exchanges.",
        'zh': '交错为世界之表示之一面：出现模型读共指标，世界之重排改之而守相接交换之序。'}}],
    'references': own_refs + lean_refs + common_refs + [{'path': CH1, 'role': 'statement', 'sha256': sha(CH1)}],
    'proof_bindings': binding,
    'history': [{
        'en': f'{DATE_EN}: added (WRT2), the World represented in the grammar both ways, its amounts not: the occurrence '
              f'model and its name-free part, carried by every re-identification; the grammar\'s listed terms kept by '
              f'correspondence; recurrence at the model; the relational part ranging over everything, conservation '
              f'exactly its form, what amounts induce decided; the failure on amounts with four witnesses; after the '
              f'design\'s two reviews, a review of the Lean and its re-read; study section {N}.',
        'zh': f'{DATE_ZH}：新增（WRT2），世界于文法中两向得表示，其数量则否：出现模型及其无名部分，为每一重认所携；文法所列诸项为对应所保；'
              f'模型上之屡；关系部分遍及一切，守恒恰为其形，数量所引者可判定；数量处之不成及其四例；经设计之二审、Lean 之审及其复读；研究第 {N} 节。'}],
}

for rid in [x['id'] for x in record['dependencies']] + [RIDU]:
    assert (RECORDS / f'{rid}.json').exists(), rid
path = RECORDS / f'{RID}.json'
assert not path.exists(), path
path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record:', RID, len(cited), 'declarations in', len(groups), 'laws')

# the UE15 record: its item on the representation theorem brought to the landed theorem
d = json.loads((RECORDS / f'{RIDU}.json').read_text(encoding='utf-8'))
items = [x for x in d['does_not_show'] if 'representation theorem' in x['en']]
assert len(items) == 1, items
item = items[0]
item['en'] = capped('does_not_show', {
    'en': "A representation of the World through the order of joined exchanges: the World's representation theorem "
          "(the-world-represented-both-ways) reads the shared index, and this is one aspect of it, the interleavings.",
    'zh': ''}, item=True)['en'] if False else ("A representation of the World through the order of joined exchanges: the "
          "World's representation theorem (the-world-represented-both-ways) reads the shared index, and this is one "
          "aspect of it, the interleavings.")
item['zh'] = '经相接交换之序之世界之表示：世界之表示定理（the-world-represented-both-ways）读共指标，此为其一面，即交错。'
capped('does_not_show', {'en': item['en'], 'zh': item['zh']}, item=True)
assert RID not in [x['id'] for x in d['related']]
d['related'].append({'id': RID, 'detail': {
    'en': "The World represented in the grammar both ways, its amounts not: its occurrence model reads the shared index.",
    'zh': '世界于文法中两向得表示，其数量则否：其出现模型读共指标。'}})
d['history'].append({'en': f'{DATE_EN}, board item WRT2 (study section {N}): the does-not-show item on the World\'s '
                           f'representation theorem brought to the landed theorem, {RID}; related to it; no statement, '
                           f'next step or declaration changed.',
                     'zh': f'{DATE_ZH}，工作板条目 WRT2（研究第 {N} 节）：关于世界之表示定理之「未示」条目随已落地之定理 {RID} 而更新；'
                           f'与之相关联；无一陈述、下一步或声明改变。'})
(RECORDS / f'{RIDU}.json').write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
print('record brought to the theorem:', RIDU)
