#!/usr/bin/env python3
"""RF round 2, third part, RF-M.3's landing: the record a-reading-informed-and-revalued (Becoming.ListingValuation,
home 03 §12), each declaration of its module cited once; and, related to it, the records of what holding for a reading
is worth and of acts alike from a model or from an order. Asserts the receipt's hash and empty axiom report for the
module, and the style caps and lint (tools/research/style.py) on every field.
make_records_rfm2.py, for RF-M.3.
usage (from the checkout root, after the texts are in place): python3 -B make_records_rfm3.py RECEIPT N
       python3 -B make_records_rfm3.py --caps  (caps, lint and declaration cover against the kit's scratch audit;
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
RECEIPT_ID, N = ('20261030T000000.000000Z', 467) if CAPS_ONLY else (sys.argv[1], int(sys.argv[2]))
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RFD = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RFD + 'BECOMING-RENEWAL-READING.md'
KITD = RFD + 'development/rf-formations-that-read/'
PLAN = KITD + 'PLAN.md'
REVIEWS = (KITD + 'evidence/REVIEW-RFM3.md', KITD + 'evidence/RFM3-DESIGN-FIRST-DRAFT.md',
           KITD + 'evidence/REVIEW-RFM3-LEAN.md', KITD + 'evidence/REVIEW-RFM3-COLDREAD.md')
CH3 = 'theories/becoming/chapters/03-KNOWING.md'
LEAN = {m: f'{PKG}/Becoming/{m}.lean' for m in ('ListingValuation', 'HeldForReading', 'Blanket', 'Learning',
                                                 'Narrowing', 'Recurrence', 'Flow', 'Population', 'Dissipation',
                                                 'Prelude')}
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
TODAY = datetime.date.today()
DATE_EN, DATE_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'
MODS = ('Becoming.ListingValuation',)
NEW = ('a-reading-informed-and-revalued',)


def sha(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


def capped(field, pair, item=False):
    caps = style.ITEM_CAPS_V2 if item else style.CAPS_V2
    en, zh = caps[field][:2]
    assert len(pair['en']) <= en and len(pair['zh']) <= zh, (field, len(pair['en']), en, len(pair['zh']), zh,
                                                              pair['en'][:60])
    return pair


names = {}
if CAPS_ONLY:
    for m in MODS:
        audit = (HERE / f'tree/.build/{m.replace(".", "")}AxiomAudit.lean').read_text(encoding='utf-8')
        names[m] = set(re.findall(r'^#print axioms (\S+)$', audit, re.M))
else:
    core = json.loads((ROOT / RECEIPT).read_text())
    assert core['status'] == 'passed'
    for m in MODS:
        assert core['source_sha256'][m] == sha(LEAN[m.split('.')[1]]), m
        mod = next(x for x in core['modules'] if x['module'] == m)
        assert not any(mod['axiom_dependencies'].values()), m
        names[m] = {d['name'] for d in mod['declarations']}
cited_by_module = {m: [] for m in MODS}


def C(module, *short):
    out = ['Becoming.' + s for s in short]
    missing = [n for n in out if n not in names[module]]
    assert not missing, missing
    return out


def lint_errors(rec):
    found = style.lint(rec)
    for f in found:
        print('lint:', rec['id'], f['severity'], f['field'], f['rule'], f['detail'])
    return [f for f in found if f['severity'] == 'error']


def dep(rid, en, zh, relation='formal-reuse'):
    return {'id': rid, 'relation': relation, 'detail': {'en': en, 'zh': zh}}


def rel(rid, en, zh):
    return {'id': rid, 'detail': {'en': en, 'zh': zh}}


def build(rid, module, title, statement, groups, hypotheses, does_not_show, counterexamples, validation, next_delta,
          correspondence, aliases, dependencies, related, refs, home, history):
    laws = [capped('laws', {'en': en, 'zh': zh, 'declarations': ds}, item=True) for en, zh, ds in groups]
    cited = [d for _, _, ds in groups for d in ds]
    cited_by_module[module] += cited
    capped('title', title)
    capped('statement', statement)
    for x in hypotheses:
        capped('hypotheses', x, item=True)
    for x in does_not_show:
        capped('does_not_show', x, item=True)
    capped('validation_scope', validation)
    capped('next_delta', next_delta)
    capped('correspondence', correspondence)
    assert len(laws) <= style.ITEM_CAPS_V2['laws'][2] and len(hypotheses) <= style.ITEM_CAPS_V2['hypotheses'][2]
    assert len(does_not_show) <= style.ITEM_CAPS_V2['does_not_show'][2]
    assert not lint_errors({'schema_version': 2, 'id': rid, 'title': title, 'statement': statement, 'laws': laws,
                            'hypotheses': hypotheses, 'does_not_show': does_not_show,
                            'counterexamples': [{'detail': x} for x in counterexamples],
                            'validation_scope': validation, 'next_delta': next_delta,
                            'correspondence': correspondence}), rid
    if CAPS_ONLY:
        print(f'caps: {rid} ok; {len(cited)} declarations in {len(laws)} laws; statement', len(statement['en']),
              len(statement['zh']))
        return None
    source = LEAN[module.split('.')[1]]
    return {
        'schema_version': 2, 'id': rid, 'title': title, 'kind': 'theorem', 'status': 'recorded-checked',
        'family': 'F04', 'reviewed_at_utc': NOW, 'statement': statement, 'laws': laws, 'hypotheses': hypotheses,
        'does_not_show': does_not_show,
        'counterexamples': [{'path': source, 'detail': x} for x in counterexamples],
        'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'formal-not-empirical', 'names-provisional'],
        'validation_scope': validation, 'next_delta': next_delta, 'correspondence': correspondence,
        'canonical_source': source, 'aliases': aliases, 'dependencies': dependencies, 'related': related,
        'references': [{'path': source, 'role': 'proof', 'declarations': sorted(cited), 'sha256': sha(source)}] + refs
                      + [{'path': RECEIPT, 'role': 'receipt', 'sha256': sha(RECEIPT)},
                         {'path': STUDY, 'role': 'integration', 'sha256': sha(STUDY)},
                         {'path': PLAN, 'role': 'integration', 'sha256': sha(PLAN)}]
                      + [{'path': r, 'role': 'integration', 'sha256': sha(r)} for r in REVIEWS]
                      + [{'path': home, 'role': 'statement', 'sha256': sha(home)}],
        'proof_bindings': [{'source': source, 'receipt': RECEIPT, 'sha256_pointer': f'/source_sha256/{module}',
                            'success_pointer': '/status', 'success_value': 'passed'}],
        'history': [history],
    }


def done(rid, what_en, what_zh):
    return {'en': f'{DATE_EN}: added (RF round 2), {what_en}; the design reviewed by a cross-model reader before the '
                  f'Lean (its first draft kept beside the review), the Lean by the same reader and through three lenses, '
                  f'the texts cold-read, what was taken listed in the review evidence; study section {N}.',
            'zh': f'{DATE_ZH}：新增（RF 第二轮），{what_zh}；设计于 Lean 之前经跨模型之审（其初稿存于审查之旁），Lean 经同一审者与三视角之审，文本经冷读，所取者列于审查之证据；研究第 {N} 节。'}


LV, = MODS
P = 'ListingValuation.'


def lv(*short):
    return C(LV, *[P + n for n in short])


# --- a-reading-informed-and-revalued ----------------------------------------------------------------------------------
rI = build(
    'a-reading-informed-and-revalued', LV,
    {'en': 'A reading informed and revalued', 'zh': '受告与改值之读'},
    {'en': "By a reference, a reading formation's answer through a map falls short by the least shortfall through it "
           "and a residual, nothing exactly where no listed cell is decided against its strict weighted preference; a "
           "finer map never raises the first, and a revaluation changes only the second.",
     'zh': '依参照，读之形成经映射之答之所缺，为经此映射之最少所缺加一余缺；余缺为零，恰当无一列格被断逆其严格加权之偏；映射愈细，前者不增；改值唯改后者。'},
    [("One joint law carries a reading formation and a holding formation, two roles told apart by the paths of "
      "sensing and control. The reading formation's model lists candidates with natural-number weights, its valuation "
      "values going on and switching off; through a map, its answer stops a cell exactly where the weighted "
      "value of going on is below that of switching off there, and releases it elsewhere, ties included.",
      '一律承读之形成与持之形成，二者为依感与控之径而辨之二角。读之形成之模型列候选，各有自然数之权；其值定每候选处续与止之值；经映射，其答止一格，恰当其处续之加权之值少于止者；余处放之，等者亦放。',
      lv('within', 'answer', 'answer_true_iff', 'answer_false_iff')),
     ("Weighted totals within a cell add and scale with the amounts, depend only on listed candidates of positive "
      "weight, and through the map with one cell are the weighted total over the listing; within a cell, the weighted "
      "loss and the excess of going on together equal the weighted gain and the excess of switching off.",
      '格内之加权之总随其量可加可乘，唯依正权之列候选；经单格之映射，即全列之加权之总；格内，加权之损与续之余合，等于加权之得与止之余合。',
      lv('ite_mul_add', 'ite_mul_left', 'within_add', 'within_mul', 'within_congr_weighted', 'within_one_cell',
         'goExcessWithin_eq', 'offExcessWithin_eq', 'within_turn')),
     ("By a supplied reference valuation on the holding formation's model, over cells listed once each and covering "
      "the listed candidates' cells, a rule through the map falls short by the least shortfall through it plus its "
      "residual: over the cells, the excess of going on beyond that of switching off where it stops a cell and the "
      "converse where it releases it, each difference truncated.",
      '依所予之参照之值于持之形成之模型，诸格各列一次且覆所列候选之格，则经映射之规则之所缺，为经此映射之最少所缺加其余缺：于诸格，止其格处为续之余逾止之余者，放其格处反之，各差截断。',
      lv('residual', 'shortfall_split', 'cond_split_least')),
     ("The residual is nothing exactly where at every listed cell the rule stops only where the excess of going on is "
      "at most that of switching off and releases only where it is at least, and positive exactly where some listed "
      "cell is decided against its strict weighted preference; a cell with no listed candidate of positive weight adds "
      "nothing, whichever way it is decided.",
      '余缺为零，恰当于每列格，规则唯于续之余不逾止之余处止、唯于其不少于处放；为正，恰当某列格被断逆其严格加权之偏；无正权列候选之格，无论如何断之，皆不增余缺。',
      lv('residual_zero_iff', 'residual_pos_iff', 'unweighted_cell', 'cond_sub_eq_zero_iff', 'cond_sub_pos_iff',
         'lt_of_sub_pos_core')),
     ("For any model of the reading formation, its answer has no residual exactly where at every listed cell it stops "
      "only where the reference's excess of going on is at most that of switching off and releases only where it is "
      "at least; so where its model is the holding formation's and its valuation agrees with the reference on one "
      "positive scale at every listed candidate of positive weight, net agreement the scale one.",
      '于读之形成之任一模型，其答无余缺，恰当于每列格唯于参照之续之余不逾止之余处止、唯于其不少于处放；其模型即持之形成之模型，且其值于每一正权之列候选与参照同于一正尺度，则成；净之相合为尺度一。',
      lv('answer_residual_zero_iff', 'answer_least_of_scaled', 'answer_least_of_net', 'answer_shortfall_least')),
     ("Scales differing by candidate do not suffice: two candidates of weight one in one cell, each valued on a scale "
      "of the reference, the scales apart, released where the cell's strict preference is to stop, residual one. Told "
      "the candidate, a candidate the reading formation weighs nothing is released whatever its valuation: of holding "
      "weight one, gain nothing and loss one, its residual is one and it falls short by one.",
      '尺度随候选而异则不足：一格二候选权各一，各依参照之一尺度定值而尺度相异，格之严格之偏为止而答放之，余缺为一。辨候选，读之形成权之为零之候选，无论其值如何皆被放：持之权一、得零损一，其余缺为一，所缺为一。',
      lv('scales_by_candidate', 'unweighted_told')),
     ("Told the candidate, with net agreement where the reading formation gives positive weight, the answer's residual "
      "is nothing exactly where every candidate the holding formation weighs positively and where the loss exceeds "
      "the gain has positive total weight in the reading formation's listing, exactly where that listing holds it "
      "with positive weight.",
      '辨候选，读之形成于其正权处与参照净相合，则其答余缺为零，恰当持之形成以正权列之且损逾得之每候选，于读之形成之列总权为正，亦即此列以正权列之。',
      lv('weightOf', 'weightOf_pos_iff', 'within_id', 'told_residual_zero_iff')),
     ("Told the candidate, with net agreement where the reading formation gives positive weight, a candidate it "
      "leaves unweighted is released and one it weighs is stopped exactly where the loss exceeds the gain; so, with no "
      "cell list, holding for the answer falls short by nothing exactly where every candidate the holding formation "
      "weighs positively and where the loss exceeds the gain is weighed by the reading formation.",
      '辨候选，读之形成于其正权处与参照净相合，则其不权之候选被放，其所权者止之恰当损逾得；故无需格之列，为答而持无所缺，恰当持之形成以正权列之且损逾得之每候选，皆为读之形成所权。',
      lv('unweighted_released', 'weighed_stops_iff', 'told_shortfall_zero_iff')),
     ("Holding for one rule stands at most as high as holding for another exactly where its shortfall is at least the "
      "other's, and strictly below exactly where it is more; rules agreeing at every listed candidate fall short "
      "alike.",
      '为一规则而持不高于为他规则而持，恰当其所缺不少于他者；严格居下，恰当其所缺更多；于每列候选皆同之规则，所缺相同。',
      lv('after_le_iff_shortfall', 'after_lt_iff_shortfall', 'shortfall_congr_on')),
     ("Informing: through a map telling apart all a coarser one does on the holding formation's listed "
      "candidates, holding for any rule through the coarser map stands at most as high as holding for any rule "
      "through the finer with that rule's residual added; so a rule with no residual stands at least as high, "
      "and so does the reading formation's answer where its model is the holding formation's and it agrees in "
      "net.",
      '告之：经于持之形成之列候选上辨较粗者所辨之一切之映射，经较粗映射为任一规则而持，不高于经较细映射为任一规则而持加其余缺；故无余缺之规则不低；读之形成之模型即持之形成之模型且净相合时，其答亦然。',
      lv('informed_le', 'informed_answer_le', 'informed_le_add_residual')),
     ("Through such a refinement the least shortfall never rises; with both maps' cells listed once each and "
      "covering, a rule with no residual through the finer map stands strictly above a rule through the coarser "
      "exactly where the least shortfall falls or the coarser rule has a positive residual.",
      '经此细分，最少所缺不增；二映射之格各列一次且皆覆之，则经较细映射无余缺之规则严格高于经较粗映射之规则，恰当最少所缺降，或较粗之规则余缺为正。',
      lv('least_falls', 'informed_lt_iff')),
     ("Over every refinement factoring on both listings, coarse cells covering the holding formation's listing "
      "and fine cells both, each listed once, holding for the answer never stands lower through the finer map "
      "exactly where splits keep the worth: for any two disjoint sets of candidates, one the reading "
      "formation's totals release and one they stop, deciding them apart is worth at least deciding them "
      "together.",
      '于每一于二列皆分解之细分，粗格覆持之形成之列，细格覆二列，各列一次：为答而持经较细映射永不更低，恰当分之守其值：于任二不交之候选集，一为读之形成之总所放、一为其所止，分断之不逊于合断之，依参照。',
      lv('weightedOn', 'SplitsKeep', 'refining_never_lowers_iff')),
     ("Splits keep the worth with a shared model and net agreement, and wherever the reading formation's value of "
      "switching off is nowhere above that of going on, whatever the reference, even where its answer has a residual: "
      "one candidate, going on gaining nothing and switching off saving 1, valued going on 1 and switching off "
      "nothing, released with residual one.",
      '共模型且净相合，分之守其值；读之形成之止之值处处不高于续者，无论参照如何，亦然，即其答有余缺亦然：一候选，续得零、止省一，值续一止零，被放而余缺为一。',
      lv('splitsKeep_of_net', 'splitsKeep_of_off_le_go', 'release_keeps')),
     ("Sufficiency, by coarse cells: holding for a rule totals the weighted loss where it stops and the weighted gain "
      "elsewhere; a coarse cell splits into the part the finer answer releases and the part it stops, each a total of "
      "whole fine cells; a total at most another term by term and below it at a member is below it; deciding a whole "
      "cell is worth at most splitting it where the part moved gains.",
      '充分，依粗格：为一规则而持，为其止处加权之损与余处加权之得之总；一粗格分为细答所放之部与所止之部，各为整细格之总；逐项不逾而于一员居下之总居下；整断一格之值不高于分之，当所移之部有得。',
      lv('after_rule_total', 'total_cond_by_cells', 'ite_split_rule', 'ite_cond_split', 'within_split',
         'within_rule_split', 'weightedOn_by_cells', 'total_lt_of_mem', 'cond_zero_le', 'split_cell_le',
         'cell_refined_le', 'refined_le_of_splitsKeep')),
     ("Necessity, one refinement per pair of sets: the cells telling whether a candidate is in either set, refined to "
      "those telling which; per candidate, the two worths and the part moved balance as the coarse answer releases or "
      "stops both sets together, so splits keep the worth wherever this refinement never lowers it.",
      '必要，每对集一细分：辨候选是否在二集之一之格，细分为辨其在何集之格；逐候选，二值与所移之部依粗答合放或合止二集而平衡，故此细分永不降其值处，分之守其值。',
      lv('eitherCell', 'whichCell', 'either_which', 'either_mem', 'which_mem', 'which_first', 'which_second',
         'either_both', 'either_neither', 'split_released_term', 'split_stopped_term', 'worth_split_released',
         'worth_split_stopped', 'splitsKeep_of_refined_le')),
     ("Where the valuation differs, informing can lower the worth below both moves: two candidates of weight one; by "
      "the reference going on gains nothing and 1, switching off saves 10 and nothing; the reading formation values "
      "going on 2 and nothing, switching off nothing and 5: told nothing, holding for its answer is worth 10; told the "
      "candidate, nothing, below going on (1) and switching off (10).",
      '值相异处，告之可使其值低于二行：二候选权各一；依参照，续之得为零与一，止之所省为十与零；读之形成值续为二与零、止为零与五：无所告，为其答而持值十；辨候选，值零，低于续（一）与止（十）。',
      lv('Informing.model', 'Informing.gain', 'Informing.loss', 'Informing.goValue', 'Informing.offValue',
         'Informing.informing_lowers')),
     ("A shared valuation with the weights apart does not keep informing from lowering the worth: three candidates, "
      "holding weights 2, 1 and 1, reading weights 1, 2 and 2: worth 3 through one cell, 2 through the cells of the "
      "first two candidates and of the third, 4 through the identity map; least shortfalls 1, 1 and nothing, residuals "
      "nothing, 1 and nothing, so a finer map can move the residual either way.",
      '共值而权相异，不保告之不降其值：三候选，持之权二、一、一，读之权一、二、二：经单格值三，经前二候选与第三者之格值二，经恒等映射值四；最少所缺一、一、零，余缺零、一、零，故较细之映射可使余缺增亦可使之减。',
      lv('WeightsApart.holding', 'WeightsApart.reading', 'WeightsApart.gain', 'WeightsApart.loss',
         'WeightsApart.weights_matter', 'WeightsApart.weights_split')),
     ("With the weights apart, splits can fail to keep the worth even with a shared valuation: by its weights the reading formation releases the third candidate, "
      "stops the first two and releases all three, while by the holding formation's weights the first two gain 2 and "
      "lose 1, so splits do not keep the worth.",
      '权相异，即共值，分亦可不守其值：依其权，读之形成放第三候选，止前二者，合三者则放之；依持之形成之权，前二者得二损一，故分之不守其值。',
      lv('WeightsApart.not_splitsKeep')),
     ("Factoring on the holding formation's listing alone does not suffice: it lists one candidate, the reading "
      "formation also a second it alone weighs; the identity factors through the map with one cell at the first "
      "alone, and splits keep the worth, yet holding for the answer is worth 1 through the identity and nothing through "
      "the one cell.",
      '唯于持之形成之列上分解则不足：其列一候选，读之形成另列唯己权之次者；恒等映射唯于前者经单格之映射而分解，分之守其值，然为答而持，经恒等映射值一，经单格值零。',
      lv('OneListing.holding', 'OneListing.reading', 'OneListing.gain', 'OneListing.loss', 'OneListing.goValue',
         'OneListing.offValue', 'OneListing.refined_lowers')),
     ("Amounts forgone: holding for one rule, forgoing an amount, stands above holding for another, forgoing "
      "another, exactly where its shortfall and amount together fall below the other's; through maps, in the split's "
      "terms; with a shared model and net agreement, the least shortfalls and the amounts decide, so through a refinement holding "
      "for the coarser answer, forgoing no less, never stands above holding for the finer.",
      '舍量：为一规则而持、舍一量，高于为他规则而持、舍他量，恰当前者之所缺与其量合少于后者；经映射，以分之项言之；共模型且净相合，则最少所缺与其量定之，故经细分，为较粗之答而持、所舍不少，永不高于为较细者而持。',
      lv('forgone_lt_iff', 'forgone_through_lt_iff', 'forgone_least_iff', 'coarser_not_above')),
     ("Forgoing one amount through a refinement, holding for the coarser rule stands above holding for the finer "
      "exactly where the finer rule's residual exceeds the coarser's by more than the least shortfall falls through the "
      "finer map; adding one amount to both sides keeps a strict order, and only it.",
      '经一细分舍同量，为较粗之规则而持高于为较细者而持，恰当细者之余缺逾粗者之余缺，多于经较细映射最少所缺之降；二边加同量，严格之序守之，唯此。',
      lv('refined_lt_iff', 'add_lt_iff_sub_add_lt', 'add_lt_add_left_iff')),
     ("Revaluing: with both formations' models, the reference and the map fixed, two valuations' answers have shortfalls differing exactly as their "
      "residuals do, and holding for one, forgoing an amount, stands above holding for the other, forgoing another, "
      "exactly where its residual and amount together fall below the other's; for the carrier's reading formation, "
      "one presented input is so compared.",
      '改值：二形成之模型、参照与映射皆定，二值之答之所缺之差恰如其余缺之差；为一者而持、舍一量，高于为他者而持、舍他量，恰当其余缺与量合少于他者；载体之读之形成一呈之入亦如此比。',
      lv('revalued_split', 'revalued_forgone_lt_iff', 'presented_forgone_lt_iff')),
     ("With the reference the reading formation's own current valuation and its model the holding formation's, no "
      "rule through the map stands higher than its answer, and a revaluation lowers it exactly where it decides some "
      "listed cell against the current valuation's strict weighted preference.",
      '以读之形成当下之值为参照、其模型即持之形成之模型，经映射无一规则高于其答；改值降之，恰当其断某列格逆当下之值之严格加权之偏。',
      lv('own_least', 'revalued_lowers_iff')),
     ("With the reading formation's model the holding formation's, by the valuation after a revaluation the revised answer has no residual, which endorses no revaluation, and "
      "no order of attained worth across valuations follows: one candidate valued 10 and 9, revised to 1 and 2, "
      "attains 10 and then 2.",
      '读之形成之模型即持之形成之模型，则依改后之值，改后之答无余缺，然此不许任一改值；诸值之间所达之值亦无序可言：一候选值十与九，改为一与二，先达十后达二。',
      lv('outcome_least', 'no_order_across')),
     ("With the reading formation's model the holding formation's, revaluing to the reference gains exactly the "
      "current answer's residual, so some unrestricted pair of value functions gives an answer strictly above the "
      "current one by the reference exactly where that residual is positive, reachability under the supplied update "
      "not asserted; for any model of the reading formation, such a gain needs a positive residual.",
      '读之形成之模型即持之形成之模型，则改值为参照恰得当下之答之余缺，故某一不限之值对之答依参照严格高于当下之答，恰当此余缺为正，未断言所予之更新可达之；于读之形成之任一模型，此得必需余缺为正。',
      lv('revaluing_gain', 'revaluing_gains_iff', 'residual_pos_of_gains')),
     ("A witness of four one-decision alternatives: two candidates of weight one, going on gaining 1 at the first and "
      "losing 1 at the second by the reference, the reading formation told the candidate and valuing switching off "
      "above going on at both: going on, switching off and holding for its answer each fall short by 1, holding for "
      "it after revising its valuation to the reference's by nothing.",
      '四一次之择之例：二候选权各一，依参照续于首者得一、于次者损一；读之形成辨候选而于二者皆值止高于续：续、止与为其答而持各缺一，改其值为参照之值后为其答而持则无所缺。',
      lv('Revaluing.model', 'Revaluing.gain', 'Revaluing.loss', 'Revaluing.revaluing_best')),
     ("An answer constant over the listed candidates is worth one committed move, the move it gives, and forgoing an "
      "amount it is strictly lower exactly where the amount is positive; the answer through the map with one cell is "
      "such an answer.",
      '于列候选恒同之答，值一所守之行，即其所予之行；舍一量则严格居下，恰当此量为正；经单格映射之答即此类之答。',
      lv('const_worth', 'const_below_iff', 'one_cell_worth')),
     ("One blanketed law: internal, the reading formation's listing and valuation state; sensory, nothing, what a demonstration shows, an input presented, or asked; active, its answer; external, the candidate world with the "
      "holding formation's state. The holding formation goes on, switches off, holds, demonstrates or presents an "
      "input, by a law reading only its own state and the answer.",
      '一毯化之律：内为读之形成之列与值之态；感为无、示之所显、所呈之入或问；动为其答；外为候选之世界与持之形成之态。持之形成续、止、持、示或呈一入，依唯读己态与答之律。',
      lv('Input', 'Act', 'Reader', 'Reader.update', 'Reader.answerOf', 'Reader.input', 'Holder', 'joint')),
     ("An act emitted at a step is sensed at the next, taken into the state and the answer at the one after, and "
      "available to the holding formation's move to the third; the answer is that of the updated state; the candidate "
      "world is unchanged along every course.",
      '一步所发之行，下一步被感，再下一步入态与答，并可为持之形成至第三步之行所用；答为更新之态之答；候选之世界于每一历程不变。',
      lv('internal_step', 'active_step', 'sensory_step', 'external_step', 'active_answer', 'world_fixed', 'timing')),
     ("The reading formation's state and answer change only through what it senses, an instance of "
      "Blanketed.agent_through_sensory; a filter and a revaluation commute as updates, acting on separate "
      "components.",
      '读之形成之态与答唯经其所感而变，为 Blanketed.agent_through_sensory 之一例；滤与改值作为更新可交换，各作用于异部。',
      lv('through_sensed', 'updates_commute')),
     ("Shown what a world shows, the listing is filtered to the worlds showing it, weights and valuation unchanged, "
      "and the answer is the answer through what is shown at that world's cell; its shortfall splits through what is "
      "shown, the least shortfall at most that through one cell, and, with the holding formation's model the reading "
      "formation's before and net agreement, holding for it never stands lower than before.",
      '示一世界之所显，则其列滤为所显同者之诸世界，权与值不变，其答即经所示之映射于此世界之格之答；其所缺经所示而分，最少所缺不逾经单格者；持之形成之模型即读之形成示前之模型且净相合，则为之而持永不低于示前。',
      lv('total_filter_shows', 'within_shown', 'answer_shown', 'shown_split', 'shown_least_le', 'shown_never_lowers')),
     ("Where the acts taken give two worlds one input, from one state of each formation their internal, sensory, answer and holding "
      "courses agree, so where no demonstration tells the worlds apart or none is emitted; so holding for the answer, where the worlds the holding formation lists all show one value or no demonstration is emitted, is worth one committed move.",
      '所行之行予二世界同入处，自二形成各同一之态，其内、感、答与持之历程皆同；示不能辨二世界或未发示处亦然；故于持之形成所列之诸世界所示皆同处，或未发示时，为答而持值一所守之行。',
      lv('input_eq_of_reveal_eq', 'inputs_alike_before', 'inputs_alike', 'input_eq_of_ne_demonstrate',
         'undemonstrated_alike', 'undemonstrated_worth', 'answer_constant')),
     ("Witnesses of four cases: two worlds, weights 1 and 2; valuation states agreeing with the reference, raised and "
      "reversed; a fixed schedule of acts. From both worlds listed and agreeing, the answer stops, is turned by being "
      "shown, which removes the least shortfall, and left by a revaluation; from the first world alone and reversed, "
      "it is left by being shown and turned by a revaluation, which removes the residual.",
      '四情之例：二世界，权一与二；值之态为合于参照、加重与反转；行之序固定。自二世界皆列且相合，答止，被示则转（去其最少所缺），改值则留；自唯列首世界且反转，被示则留，改值则转（去其余缺）。',
      lv('TwoWorlds.World', 'TwoWorlds.Val', 'TwoWorlds.rd', 'TwoWorlds.schedule', 'TwoWorlds.shownStart',
         'TwoWorlds.presentedStart', 'TwoWorlds.route', 'TwoWorlds.shown_turns', 'TwoWorlds.presented_turns',
         'TwoWorlds.shown_removes_least', 'TwoWorlds.presented_removes_residual')),
     ("Along courses of the joint law, by the reference with the holding formation listing both worlds, weights 1 "
      "and 2, for the demonstration and the first world alone for the presented input, from each witness's start "
      "with its act scheduled, holding for the answer falls short by 1 at step 1 and by nothing at step 2.",
      '沿此一律之历程，依参照，示之情持之形成列二世界（权一与二），呈之情唯列首世界，自各例之始并所排之行，为答而持于第一步缺一，于第二步无所缺。',
      lv('TwoWorlds.shown_course', 'TwoWorlds.presented_course')),
     ("From two starts alike but for the order of the holding formation's two scheduled acts, a demonstration and "
      "a revaluation reach one configuration from the third step on, while the answers at the second step differ: "
      "the updates commute, the courses do not.",
      '二始唯持之形成所排二行之先后异，示与改值自第三步起达同一构型，而第二步之答相异：更新可交换，历程则否。',
      lv('TwoWorlds.orderStart', 'TwoWorlds.orderEnd', 'TwoWorlds.orderEnd_rests', 'TwoWorlds.orders_rest',
         'TwoWorlds.orders_apart')),
     ("From different starts, the route shown and the route presented reach one configuration at the second step and "
      "rest there; they answer alike at every step, stopping at steps 0 and 1 and releasing from 2 on, and end in one "
      "state, while the valuation changes on the second alone; so whether it changed is not Learning.Lumped through "
      "the record of the answers and the final state.",
      '自异始，示之途与呈之途于第二步达同一构型而恒于此；每步之答皆同，第零与第一步止、自第二步起放，终于同一之态，而唯后者之值有变；故值是否曾变，不经答之记录与终态而为 Learning.Lumped。',
      lv('TwoWorlds.changedBefore', 'TwoWorlds.answersBefore', 'TwoWorlds.record', 'TwoWorlds.changed',
         'TwoWorlds.reached', 'TwoWorlds.reached_rests', 'TwoWorlds.routes_rest', 'TwoWorlds.answers_alike',
         'TwoWorlds.route_answers', 'TwoWorlds.answersBefore_congr', 'TwoWorlds.shown_keeps_agree',
         'TwoWorlds.changedBefore_of_constant', 'TwoWorlds.changedBefore_succ_of_true', 'TwoWorlds.presented_changed',
         'TwoWorlds.routes_alike', 'TwoWorlds.changed_apart', 'TwoWorlds.not_lumped')),
     ("The two routes start from different internal states, and with the start added to the record, whether the "
      "valuation changed is Learning.Lumped through it: the result concerns the record of the answers and the final "
      "state only.",
      '二途之始之内态相异；记录加其始，则值是否曾变经之而为 Learning.Lumped：此结果唯涉答之记录与终态。',
      lv('TwoWorlds.starts_apart', 'TwoWorlds.lumped_with_start'))],
    [{'en': "Natural-number weights and values, the valuation's scale supplied, so a comparison across valuations rests "
            "on that scale; the reference valuation and the holding formation's model supplied; values read as "
            "probabilities and differences only where valid.",
      'zh': '权与值为自然数，值之尺度为所予，故诸值之比依此尺度；参照之值与持之形成之模型为所予；唯于有效处读为概率与差。'},
     {'en': "Equality of cells decidable. The split needs the cells listed once each, covering every listed "
            "candidate's cell; the residual's criteria need neither, and the told criterion only its cell list "
            "covering the holding formation's listing.",
      'zh': '格之等可判。分需诸格各列一次且覆每列候选之格；余缺之判二者皆不需，辨候选之判唯需其格之列覆持之形成之列。'},
     {'en': "Informing needs the coarser map factoring through the finer on "
            "the holding formation's listed candidates and the finer map's cells listed once each and covering, the "
            "strict comparison the coarser map's as well; the criterion over every refinement needs the factoring on "
            "both listings, the coarse cells listed once each and covering the holding formation's listing, and the "
            "fine cells listed once each and covering both.",
      'zh': '告需较粗之映射于持之形成之列候选上经较细者而分解，且较细映射之格各列一次而覆之，严格之比较需较粗者亦然；于每一细分之判，需二列皆分解，粗格各列一次且覆持之形成之列，细格各列一次且覆二列。'},
     {'en': "For the answer's sufficient conditions, its model the holding formation's and its valuation agreeing with "
            "the reference on one positive scale, net agreement the scale one, at every listed candidate of positive "
            "weight; own_least, revalued_lowers_iff, outcome_least, revaluing_gain and revaluing_gains_iff take its model to be the "
            "holding formation's, residual_pos_of_gains any model.",
      'zh': '答之充分条件需其模型即持之形成之模型，且其值于每一正权之列候选与参照同于一正尺度（净之相合为尺度一）；own_least、revalued_lowers_iff、outcome_least、revaluing_gain 与 revaluing_gains_iff 取其模型为持之形成之模型，residual_pos_of_gains 取任一模型。'},
     {'en': "Ties release in the answer, as HeldForReading.byReading goes on at ties, while leastThrough stops a cell "
            "at ties; rules are functions of the candidate's cell.",
      'zh': '答于等者放之，如 HeldForReading.byReading 于得损相等时续；leastThrough 则于二余相等之格止；规则为候选之格之函数。'},
     {'en': "In the carrier: discrete steps; the candidate world unchanged by the acts; a demonstration "
            "filtering truly by what it shows, its equality decidable; an input presented revising the valuation by a "
            "supplied update, in the witnesses adopting the state presented; the answer shown at every step, asked or "
            "not; the holding formation's law reading only its own state and the answer, in the witnesses a fixed "
            "schedule.",
      'zh': '于载体：离散之步；候选之世界不为所论之行所改；示依其所示真滤之，其等可判；所呈之入依所予之更新改值，于诸例中即取所呈之态；答每步皆示，问与否皆然；持之形成之律唯读己态与答，于诸例中为固定之序。'},
     {'en': "Worth for one decision before any amount forgone; costs enter only as amounts forgone, counted in the "
            "units of the weighted totals; the holding formation's going on, switching off and holding change neither "
            "the candidate world nor the reading formation, so the worth of holding is counted on the answer as a rule, not along the courses.",
      'zh': '一次抉择、未舍任何量前之值；费唯以所舍之量计入，以加权之总为单位；持之形成之续、止与持不改候选世界亦不改读之形成，故持之值以答为规则计之，非沿历程计之。'}],
    [{'en': "That a formation computes by these counts, or that its listing, weights and valuation are formed as "
            "supplied: they are supplied, their formation and warrant outside these counts.",
      'zh': '形成依此诸计而算，或其列、权与值如所予而成：皆为所予，其成与其据在此诸计之外。', 'kind': 'non-implication'},
     {'en': "That informing removes the least shortfall and revaluing the residual in general: a finer map can move "
            "the residual either way.",
      'zh': '告去最少所缺、改值去余缺为普遍之事：较细之映射可使余缺增亦可使之减。', 'kind': 'non-implication'},
     {'en': "A criterion of legitimate, desired or autonomous change of a valuation, or that revaluing, or keeping a "
            "valuation from revision, is endorsed or forbidden: the counts compare by a supplied reference.",
      'zh': '值之变为正当、所欲或自主之判准，或改值、或护值免于改，当许或当禁：诸计依所予之参照而比。', 'kind': 'non-implication'},
     {'en': "A holding formation planning over several steps among informing, revaluing and holding, a multistep "
            "incentive or an optimal signal chosen by the holding formation; its learning about the reading "
            "formation.",
      'zh': '持之形成于告、改值与持之间多步之谋，多步之诱因或持之形成所择之最优之信号；其于读之形成之学。', 'kind': 'scope'},
     {'en': "A misleading demonstration, belief and intention, so deception; the reading formation's learning beyond "
            "filtering by what it is shown; noisy answers and continuous beliefs; an institution's rule of reading.",
      'zh': '误导之示、信与意，故欺；读之形成依所示而滤以外之学；有噪之答与连续之信；制度之读之规则。', 'kind': 'scope'},
     {'en': "A case of one start that the answers and the final state leave undetermined: the two routes start apart, "
            "and the record with the start determines whether the valuation changed.",
      'zh': '答与终态未定之同始之情：二途之始相异，记录加其始则定值是否曾变。', 'kind': 'scope'}],
    ["Informing lowering the worth below both moves where the valuation differs: told nothing, holding for the answer is "
     "worth 10; told the candidate, nothing, below going on and switching off (Informing.informing_lowers).",
     "A shared valuation with the weights apart: holding for the answer is worth 3 through one cell and 2 through a "
     "finer map (WeightsApart.weights_matter), and splits do not keep the worth (WeightsApart.not_splitsKeep).",
     "Factoring on the holding formation's listing alone: splits keep the worth, yet holding for the answer is worth 1 "
     "through the identity and nothing through the map with one cell (OneListing.refined_lowers).",
     "Scales differing by candidate: the answer releases a cell whose strict weighted preference is to stop "
     "(scales_by_candidate).",
     "The models apart: a candidate the reading formation weighs nothing is released whatever its valuation, its "
     "residual one, so no revaluation removes it (unweighted_told).",
     "No order across valuations: each answer has no residual by its own valuation, while the worth attained falls from "
     "10 to 2 (no_order_across).",
     "Two executable routes from different starts answering alike at every step and ending in one state, the "
     "valuation changed on one alone (TwoWorlds.not_lumped); from starts alike but for the order of the holding "
     "formation's two scheduled acts, two orders of the same updates answering apart (TwoWorlds.orders_apart)."],
    {'en': "Pure core, every axiom report empty: ListingValuation imports HeldForReading, reusing its models, shifted "
           "values, rules, shortfall, cells, offPart and least shortfall, and through it Blanket (Blanketed, its course "
           "and agent_through_sensory), Learning (Lumped), Narrowing's filter lemmas and Law.orbit; totals use Flow, "
           "Population and Dissipation lemmas and the prelude's cancellation and subtraction lemmas, with a core form "
           "of one subtraction lemma whose library form carries propext; no omega and no simp; the witnesses evaluate "
           "by rfl or decide.",
     'zh': '纯核，公理报告皆空：引 HeldForReading，用其模型、移后之值、规则、所缺、格、offPart 与最少所缺，经之引 Blanket（Blanketed、其历程与 agent_through_sensory）、Learning（Lumped）、Narrowing 之滤之引理与 Law.orbit；诸总用 Flow、Population、Dissipation 之引理与前导之消去、减法引理，一减法引理之库形带 propext，用其核心之形；不用 omega 与 simp；诸例以 rfl 或 decide 定。'},
    {'en': "A holding formation planning over several steps among informing, revaluing and holding, and its learning about the reading formation; the reading formation's learning beyond filtering by what it is shown; a misleading demonstration and a recipient's belief, toward deception; noisy answers and continuous beliefs in the periphery; an institution's rule of reading; review by a person.",
     'zh': '持之形成于告、改值与持之间多步之谋，及其于读之形成之学；读之形成依所示而滤以外之学；误导之示与受者之信，以向欺；外围之有噪之答与连续之信；制度之读之规则；人之审查。'},
    {'en': "In counts: informed_le is, for this decision, the deterministic-refinement, fixed-decision direction of "
           "Blackwell's (1953) comparison; with a shared model, SplitsKeep is the counterpart, along the cells of the "
           "listing's partitions, of Bayesian persuasion's convexity condition for full disclosure (Kamenica and Gentzkow 2011), no optimal signal or equilibrium represented. AI reading: under a reference unlike the valuation, possible incentives to withhold and to revise (if the update reaches a gaining valuation), before costs; coarse equilibrium communication "
           "(Crawford and Sobel 1982) differs. own_least with revalued_lowers_iff is a one-decision counterpart of "
           "current-reward-function evaluation's preservation incentive for an agent anticipating time inconsistency (Everitt et al. 2021, Claim 2): on a shared "
           "model, a reason to keep the valuation from a revision deciding a listed cell against its strict weighted preference; no path-specific objective (Farquhar et al. 2022); answer_constant is the off-switch game's Equation 1 for a deterministic constant policy (Hadfield-Menell "
           "et al. 2017); the routes relate to induced preference shifts (Carroll et al. 2022). Readings, not "
           "containments.",
     'zh': '以计：informed_le 于此抉择为 Blackwell（1953）比较之确定性细分、定抉择之一向；共模型时，SplitsKeep 沿列之分割之格，对应贝叶斯劝说中全然披露之凸性条件（Kamenica 与 Gentzkow 2011），最优之信号与均衡未表。AI 解读：参照与值相异时，读为扣告与改（若所予之更新可达有得之值）之或有之诱因，未计其费；偏好相异下之粗略均衡通信（Crawford 与 Sobel 1982）与此不同。own_least 与 revalued_lowers_iff 为以当下奖励函数评估而顾及时间不一致者之保存之诱因（Everitt 等 2021，Claim 2）于一次抉择之对应：共模型时，有护值免于使某列格之断逆当下严格加权之偏之改值之由；未构路径特定之目标（Farquhar 等 2022）；answer_constant 为关机博弈之 Equation 1 于确定且恒定之策（Hadfield-Menell 等 2017）；二途与诱发之偏好之移（Carroll 等 2022）相关。皆为读，非包含。'},
    ['a reading informed and revalued', '受告与改值之读', 'informing and revaluing a reading formation',
     '告读之形成与改其值', 'the valuation as state', '值为态', 'Becoming.ListingValuation.shortfall_split',
     'Becoming.ListingValuation.refining_never_lowers_iff'],
    [dep('what-holding-for-a-reading-is-worth', "HeldForReading's models, shifted values, rules, shortfall and "
         "after_add_shortfall, across_le_iff, its cells (goExcessWithin, offExcessWithin, total_by_cells, offPart), "
         "leastThrough, shortfall_through, least_through and finer_least_le.",
         'HeldForReading 之模型、移后之值、规则、所缺与 after_add_shortfall、across_le_iff、其格（goExcessWithin、offExcessWithin、total_by_cells、offPart）、leastThrough、shortfall_through、least_through 与 finer_least_le。'),
     dep('the-markov-blanket-as-a-coupling-structure', "Blanket.Blanketed, its course and "
         "Blanketed.agent_through_sensory: the carrier joint and the instance through_sensed.",
         'Blanket.Blanketed、其历程与 Blanketed.agent_through_sensory：载体 joint 与其例 through_sensed。'),
     dep('generalization-through-lumping', "Learning.Lumped: the route property not lumped through the record of the "
         "answers and the final state, and lumped with the start added (TwoWorlds.not_lumped, "
         "TwoWorlds.lumped_with_start).",
         'Learning.Lumped：途之性不经答之记录与终态而为 Lumped，加其始则为之（TwoWorlds.not_lumped、TwoWorlds.lumped_with_start）。')],
    [rel('acts-alike-from-a-model-or-from-an-order', "Informing and revaluing within one law: a demonstration filtering the reading formation's listing and an input presented revising its valuation, beside courses alike from an unresolved model and a "
         "reversed ranking, informing there represented by a changed start.",
         '一律之内之告与改值：示滤读之形成之列，呈一入改其值，与彼处未分之模型与反转之排序之同历程相并，彼处之告以改其始表之。')],
    [{'path': LEAN[m], 'role': 'proof', 'sha256': sha(LEAN[m])}
     for m in ('HeldForReading', 'Blanket', 'Learning', 'Narrowing', 'Recurrence', 'Flow', 'Population',
               'Dissipation', 'Prelude')],
    CH3, done('a-reading-informed-and-revalued', "a reading informed and revalued: the answer of a formation reading by "
              "its own model and valuation through a map; any rule's shortfall split into the least shortfall and a "
              "residual, with exact criteria; informing and the criterion over every refinement, with its sufficient "
              "conditions and counterexamples; amounts forgone, read as withholding against informing; revaluing; and one blanketed law carrying "
              "the reading formation's listing and valuation, with witnesses of four cases, two orders and two routes",
              '受告与改值之读：读之形成依己之模型与值经映射之答；任一规则之所缺分为最少所缺与余缺，并其确判；告与于每一细分之判，并其充分条件与反例；舍量，读为扣告与告；改值；及承读之形成之列与值之一毯化之律，并四情、二序与二途之例'))

for m in MODS:
    cited = cited_by_module[m]
    assert len(cited) == len(set(cited)), ('a declaration cited twice', m)
    missing = sorted(names[m] - set(cited))
    assert not missing, (m, missing)
if CAPS_ONLY:
    print('cover: every declaration of the module cited once')
    raise SystemExit(0)
for record in (rI,):
    for rid in [x['id'] for x in record['dependencies']] + [x['id'] for x in record['related']]:
        assert (RECORDS / f'{rid}.json').exists() or rid in NEW, rid
    path = RECORDS / f"{record['id']}.json"
    assert not path.exists(), path
    path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print('record:', record['id'], sum(len(x['declarations']) for x in record['laws']), 'declarations in',
          len(record['laws']), 'laws')
WORTH = 'what-holding-for-a-reading-is-worth'
ALIKE = 'acts-alike-from-a-model-or-from-an-order'
AMEND = {
    WORTH: {'related': rel(NEW[0], "The reading formation's own listing and valuation as state: holding for its answer "
                                   "through a map falls short by the least shortfall and a residual; a finer map never "
                                   "raises the first, revaluing moves the second alone, in one blanketed law.",
                           '读之形成己之列与值为态：为其经映射之答而持，所缺为最少所缺加余缺；映射愈细前者不增，改值唯移后者，于一毯化之律。'),
            'next_delta': ("A principal's valuation as state the helper's acts can move, its carrier to be designed "
                           "first (RF-M's next case); the reading formation's own state and learning;",
                           "The reading formation's learning beyond filtering by what it is shown, and a holding formation planning "
                           "among informing, revaluing and holding (after RF-M.3's carrier);",
                           '受助者之值为助者之行可移之态，先设其载体（RF-M 之下一情形）；读之形成己之态与学；',
                           '读之形成依所示而滤以外之学，与持之形成于告、改值与持之间之谋（RF-M.3 之载体之后）；'),
            'history': ("related to a-reading-informed-and-revalued, where the reading formation's listing and "
                        "valuation are state; the next step keeps its learning beyond filtering by what it is shown and the holding "
                        "formation's planning; no statement or declaration changed.",
                        '与 a-reading-informed-and-revalued 相关联，读之形成之列与值于彼为态；下一步留其依所示而滤以外之学与持之形成之谋；无一陈述或声明改变。')},
    ALIKE: {'related': rel(NEW[0], "Informing as an act within one law: a demonstration filtering the reading "
                                   "formation's listing, where here informing changes the start; and revaluing, an input "
                                   "revising its valuation.",
                           '告为一律之内之行：示滤读之形成之列，此处之告则改其始；及改值，呈一入改其值。'),
            'next_delta': ("The reading formation's own state and learning, and a principal's valuation as state the "
                           "helper's acts can move (RF round 2's later item, RF-M.3's carrier);",
                           "The reading formation's learning beyond filtering by what it is shown, and a holding formation planning "
                           "over several steps (after RF-M.3's carrier);",
                           '读之形成己之态与学，与助者之行可移之受助者之值为态（RF 第二轮之后项，RF-M.3 之载体）；',
                           '读之形成依所示而滤以外之学，与持之形成多步之谋（RF-M.3 之载体之后）；'),
            'history': ("related to a-reading-informed-and-revalued, where informing and revaluing are acts within one "
                        "law; the next step keeps the reading formation's learning beyond filtering by what it is shown; no "
                        "statement or declaration changed.",
                        '与 a-reading-informed-and-revalued 相关联，告与改值于彼为一律之内之行；下一步留读之形成依所示而滤以外之学；无一陈述或声明改变。')},
}
for rid, amend in AMEND.items():
    path = RECORDS / f'{rid}.json'
    d = json.loads(path.read_text(encoding='utf-8'))
    assert NEW[0] not in [x['id'] for x in d['related']], rid
    d['related'].append(amend['related'])
    en_old, en_new, zh_old, zh_new = amend['next_delta']
    assert d['next_delta']['en'].count(en_old) == 1, rid
    d['next_delta']['en'] = d['next_delta']['en'].replace(en_old, en_new)
    assert d['next_delta']['zh'].count(zh_old) == 1, rid
    d['next_delta']['zh'] = d['next_delta']['zh'].replace(zh_old, zh_new)
    capped('next_delta', d['next_delta'])
    en, zh = amend['history']
    d['history'].append({'en': f'{DATE_EN}, board item RF, RF-M.3 (study section {N}): {en}',
                         'zh': f'{DATE_ZH}，工作板条目 RF，RF-M.3（研究第 {N} 节）：{zh}'})
    path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print('record amended:', rid)
