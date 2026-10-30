#!/usr/bin/env python3
"""RF round 2, second part, RF-M.2's landing: the record what-holding-for-a-reading-is-worth (Becoming.HeldForReading,
home 03 §12), each declaration of its module cited once; and, related to it, the records of RF1 (the shown reach), of
ReadingLoop's untested model and of acts alike from a model or from an order. Asserts the receipt's hash and empty
axiom report for the module, and the style caps and lint (tools/research/style.py) on every field.
make_records_rf7.py, for RF-M.2.
usage (from the checkout root, after the texts are in place): python3 -B make_records_rfm2.py RECEIPT N
       python3 -B make_records_rfm2.py --caps  (caps, lint and declaration cover against the kit's scratch audit;
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
RECEIPT_ID, N = ('20261030T000000.000000Z', 464) if CAPS_ONLY else (sys.argv[1], int(sys.argv[2]))
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
RFD = '_process/research/2026-10-05-generative-foundation-review/root-foundation/'
STUDY = RFD + 'BECOMING-RENEWAL-READING.md'
KITD = RFD + 'development/rf-formations-that-read/'
PLAN = KITD + 'PLAN.md'
REVIEWS = (KITD + 'evidence/REVIEW-RFM2.md', KITD + 'evidence/REVIEW-RFM2-LEAN.md',
           KITD + 'evidence/REVIEW-RFM2-COLDREAD.md')
CH3 = 'theories/becoming/chapters/03-KNOWING.md'
LEAN = {m: f'{PKG}/Becoming/{m}.lean' for m in ('HeldForReading', 'ShownOrder', 'ReadingLoop', 'Keeping', 'Flow',
                                                 'Population', 'Dissipation', 'Prelude')}
RECEIPT = f'{PKG}/becoming-checks/{RECEIPT_ID}/verification.json'
RECORDS = ROOT / 'theories/becoming/results/records'
NOW = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat()
TODAY = datetime.date.today()
DATE_EN, DATE_ZH = f'{TODAY.day} {TODAY:%B} {TODAY.year}', f'{TODAY.year}年{TODAY.month}月{TODAY.day}日'
MODS = ('Becoming.HeldForReading',)
NEW = ('what-holding-for-a-reading-is-worth',)


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
                  f'Lean, the Lean by the same reader and through three lenses and then re-checked, the texts cold-read, '
                  f'what was taken, deferred or handed over listed in the review evidence; study section {N}.',
            'zh': f'{DATE_ZH}：新增（RF 第二轮），{what_zh}；设计于 Lean 之前经跨模型之审，Lean 经同一审者与三视角之审并复查，文本经冷读，所取、所缓与所交者列于审查之证据；研究第 {N} 节。'}


HF, = MODS
H = 'HeldForReading.'
S = H + 'SignLoop.'


def hf(*short):
    return C(HF, *[H + n for n in short])


def sl(*short):
    return C(HF, *[S + n for n in short])


# --- what-holding-for-a-reading-is-worth -------------------------------------------------------------------------------
rW = build(
    'what-holding-for-a-reading-is-worth', HF,
    {'en': 'What holding an act for a reading is worth', 'zh': '为读而持其行之值'},
    {'en': "Choosing best after a reading telling the candidate gains over every open act exactly where none is valued "
           "best at every listed candidate of positive weight; holding for a stopping rule, forgoing an amount, is not "
           "below going on exactly where shortfall plus amount is within switching off's excess.",
     'zh': '经辨候选之读而择最优，恰当无一可取之行于每一正权之列候选皆值同最优时胜于每一可取之行；为止之规则而持、舍一量，不低于续，恰当其所缺与此量合不逾止之余。'},
    [("A model lists candidates with natural-number weights; committing to one act and choosing after a reading that "
      "tells the candidate are the weighted totals of the act's values and of a policy's; a policy is best at a "
      "candidate where its act is open and no open act has more value there; one exists for every nonempty list of "
      "acts, taking at each candidate the act valued highest there.",
      '一模型列候选，各有自然数之权；守一行与经辨候选之读而择，为其行与其策之值之加权之总；一策于一候选为最优，当其行可取且无可取之行值更多；凡非空之行列皆有之，于每候选取其处值最高之行。',
      hf('Model', 'Model.committed', 'Model.after', 'BestAt', 'bestOf', 'bestOf_best')),
     ("Given a policy best at every listed candidate, any policy choosing open acts there, reading through a map or "
      "reading nothing, with the weighted total of the amounts by which its act is valued below the best makes the "
      "best total: it stands at most as high, as high exactly where its act is valued as the best at every listed "
      "candidate of positive weight, and below exactly where some such candidate values it lower.",
      '设一策于每列候选皆最优，凡于其处择可取之行之策（经映射而读或无所读），加其行低于最优之量之加权之总，即得最优之总：不高于之；恰当其行于每一正权之列候选值同最优乃等高；恰当某此候选值之较低乃居下。',
      hf('after_le_after', 'after_add_gap', 'after_lt_after_iff', 'after_eq_after_iff')),
     ("Committing to one open act, the policy taking it everywhere, never stands above choosing best after the "
      "reading, as high exactly where the act is valued as the best at every listed candidate of positive weight; "
      "choosing best after the reading gains over every open act exactly where none is so valued; an act falls "
      "below exactly where some such candidate has a property marking where it is valued below the best.",
      '守一可取之行即处处取之之策：不高于经读而择最优，恰当此行于每一正权之列候选值同最优乃等高；经读择最优胜于每一可取之行，恰当无一可取之行如此；一行居下，恰当某正权之列候选具一标其值低于最优之性。',
      hf('committed_le_after', 'committed_eq_after_iff', 'reading_gains_iff', 'below_iff')),
     ("Some policy taking one open act at each cell of a map stands as high as the best exactly where each cell has "
      "one open act valued as the best at every listed candidate of positive weight in it, given choice over the "
      "whole type of cells; values raised at each candidate by one amount for every act raise every policy's total "
      "by one amount and order every two policies of a model alike.",
      '有一于映射之每格取一可取之行之策与最优等高，恰当每格有一可取之行于其中每一正权之列候选值同最优（设于格之全类有择）；于每候选对每行加同一量，则每策之总加同一量，一模型中任二策之序不变。',
      hf('cell_policy_iff', 'after_offset', 'after_offset_le_iff')),
     ("Two moves, going on and switching off, the acts open (what holds of two holds of every member of their list); "
      "going on valued at the gain and switching off at the loss, the loss added to both at each candidate; a rule of "
      "stopping, off where it is true and on elsewhere; the reading that tells the candidate, stopping exactly where "
      "the loss exceeds the gain.",
      '二行，续与止，为可取之行（凡于二者皆成者，于其列之每员皆成）；续值其得，止值其损，每候选于二行皆加其损；止之规则，真处止，余处续；辨候选之读，恰于损过得处止。',
      hf('Move', 'shifted', 'byRule', 'byReading', 'byRule_of_true', 'byRule_of_false', 'byReading_of_lt',
         'byReading_of_not_lt', 'go_open', 'off_open', 'forall_pair')),
     ("The reading that tells the candidate is best at each, going on valued below it exactly where the gain is below "
      "the loss and switching off exactly where the loss is below the gain; holding for it never stands below either "
      "move, and stands above both exactly where the model gives positive weight to both strict signs.",
      '辨候选之读于每候选皆最优；续之值低于之，恰当得少于损；止之值低于之，恰当损少于得；为之而持不低于二行之任一，恰当模型予二严号皆以正权时高于二者。',
      hf('byReading_best', 'go_below_iff', 'off_below_iff', 'committed_le_held', 'held_gains_iff')),
     ("Any rule of stopping: a total's parts over the candidates it stops and over those it releases make the total; "
      "holding for it is the weighted loss where it stops and the weighted gain where it releases, at least as high as "
      "going on exactly where, where it stops, the weighted loss is at least the weighted gain, and as switching off "
      "exactly where, where it releases, the weighted gain is at least the weighted loss.",
      '任一止之规则：一总于其所止候选之部与所放候选之部合为此总；为之而持，为所止处加权之损与所放处加权之得；恰当所止处加权之损不少于加权之得，不低于续；恰当所放处加权之得不少于加权之损，不低于止。',
      hf('offPart', 'onPart', 'cond_split', 'offPart_add_onPart', 'after_rule', 'rule_not_below_go_iff',
         'rule_not_below_off_iff')),
     ("Read as differences, going on valued at the gain less the loss and switching off at nothing: holding for a "
      "rule with the weighted loss where it releases is the weighted loss over every candidate with the weighted gain "
      "where it releases, so every two rules compare on the shifted values as on the values read as differences, "
      "each weighted loss added to the other side.",
      '读为差（续值得减损，止值零）：为一规则而持，加其所放处加权之损，等于诸候选加权之损之总加其所放处加权之得；故任二规则于移后之值之序，同于读为差之值之序（各以加权之损移至他侧）。',
      hf('after_rule_add_onLoss', 'after_rule_le_iff')),
     ("The weighted excess of going on over switching off and that of switching off over going on, and a rule's "
      "shortfall from the reading that tells the candidate, the excess of going on where it stops and that of "
      "switching off where it releases: holding for the rule with its shortfall is going on with the excess of "
      "switching off, and switching off with the excess of going on.",
      '续较止之加权之余与止较续之加权之余，及一规则较辨候选之读之所缺（其止处续之余，其放处止之余）：为此规则而持加其所缺，等于续加止之余，亦等于止加续之余。',
      hf('goExcess', 'offExcess', 'shortfall', 'held_term', 'term_go', 'term_off', 'after_add_shortfall_go',
         'after_add_shortfall_off')),
     ("The reading that tells the candidate falls short nowhere, so holding for it is going on with the excess of "
      "switching off and switching off with the excess of going on, and a rule's shortfall is what holding "
      "for the rule loses against that reading; holding for that reading stands only as high as going on exactly "
      "where the excess of switching off is nothing, and as switching off exactly where that of going on is.",
      '辨候选之读无所缺，故为之而持等于续加止之余，亦等于止加续之余；一规则之所缺恰为为之而持较为此读而持所失者；为此读而持与续等高，恰当止之余为零；与止等高，恰当续之余为零。',
      hf('shortfall_byReading', 'after_byReading', 'after_add_shortfall', 'held_eq_go_iff', 'held_eq_off_iff')),
     ("Holding for any rule, forgoing an amount counted in the units of the weighted totals, stands at least as high "
      "as going on exactly where its shortfall and the amount together are at most the excess of switching off, and "
      "above it exactly where they fall below it; against switching off, the excess of going on takes its place "
      "(moving an addend across a balance, at most and strictly).",
      '为任一规则而持、舍一以加权之总为单位之量，不低于续，恰当其所缺与此量合不逾止之余；高于续，恰当其合少于之；较之于止，以续之余代之（移一加项过一平衡，不逾与严格）。',
      hf('across_le_iff', 'across_lt_iff', 'threshold_go_iff', 'threshold_off_iff')),
     ("Holding for the reading that tells the candidate, forgoing an amount, stands at least as high as going on "
      "exactly where the amount is at most the excess of switching off, above it exactly where the amount is below "
      "it, and likewise against switching off with the excess of going on; each excess is positive exactly where the "
      "model gives positive weight to its strict sign.",
      '为辨候选之读而持、舍一量，不低于续恰当此量不逾止之余，高于续恰当此量少于之；较之于止，以续之余同之；每一余为正，恰当模型予其严号以正权。',
      hf('forgone_within_excess_iff', 'forgone_below_excess_iff', 'excess_pos_iff')),
     ("Over cells of a map, their equality decidable, listed once each and covering every listed candidate's cell, a "
      "total over the candidates "
      "is the total over the cells of the total within each; so a rule through the map falls short, at each cell, by "
      "the excess of going on within it where it stops the cell and by that of switching off within it where it "
      "releases the cell.",
      '映射之格（其等可判）各列一次且覆每列候选之格，则候选之总为诸格内之总之总；故经映射之规则于每格之所缺：止其格处为格内续之余，放其格处为格内止之余。',
      hf('total_single', 'total_by_cells', 'goExcessWithin', 'offExcessWithin', 'cell_term', 'total_cond_both',
         'shortfall_through')),
     ("The least shortfall through the map, stopping a cell exactly where its excess of going on is at most that of "
      "switching off, totals the smaller excess within each cell, is nothing exactly where no listed cell holds "
      "both and never increases through a finer map; holding for some rule through it, forgoing an amount, is no "
      "lower than both moves exactly where that least shortfall plus the amount is within both excesses.",
      '经映射之最少所缺：于格内续之余不逾止之余处止其格，为诸格较小之余之总，恰当无列格兼有二者时为零；经更细之映射，最少所缺永不增；为经映射之某规则而持、舍一量，不低于二行，恰当此最少所缺与此量合不逾二余。',
      hf('leastThrough', 'cond_least_le', 'least_through', 'cond_least_eq_zero_iff', 'least_zero_iff',
         'finer_least_le', 'through_threshold_iff')),
     ("A pick of one of two alternatives, valued one where a candidate's decided comparisons rank it above the other "
      "and nothing elsewhere; picking after the reading, best at each candidate; for a candidate not ranking each of "
      "the two above the other, picking the first is valued below it exactly where the candidate ranks the second "
      "above the first, and picking the second exactly where it ranks the first above.",
      '于二者择一，候选之可判之较排其于他者之上处值一，余处值零；经读而择，于每候选皆最优；候选不以二者各居其他之上，则择首者之值低于之，恰当其排次者于首者之上；择次者亦然，恰当其排首者于上。',
      hf('Pick', 'pairValue', 'pairPolicy', 'first_open', 'second_open', 'pairPolicy_best', 'first_below_iff',
         'second_below_iff')),
     ("Joined to the shown reach: with every listed candidate of positive weight transitive and according with the "
      "choices, holding the pick gains nothing where the first reaches the second, and over "
      "both picks only where neither reaches the other; where none of positive weight ranks each above the other, "
      "holding gains over both exactly where some such candidate ranks the first higher and some the second.",
      '接于所示之及：每一正权之列候选皆传递且合于所择，则首者于所示之关系及于次者处持其择无所得，唯在二者互不相及处持胜于二择；无正权候选以二者各居其他之上，则持胜于二择，恰当某此候选排首在上而某排次在上。',
      hf('reach_fixes', 'pair_gains_iff', 'pair_gains_unreached')),
     ("A witness on the reading loop: the signs of going on as candidates predicting the answer and as the unmoving "
      "world; acts going on, holding, switching off; plain, a stop or a release sensed; a held act answered by the "
      "true sign, going on and switching off plainly; the formation going on where every kept candidate predicts "
      "gain or none is kept, switching off where some are kept and all predict loss, holding otherwise.",
      '读环上之例：续之号为候选，预其答，亦为不动之世界；行为续、持、止；所感为平、止或放；所持之行以真号答之，续与止平答；所留候选皆预得或无所留则续，有所留且皆预损则止，余则持。',
      sl('Sign', 'Act', 'Seen', 'answer', 'predictsGain', 'choose', 'loop')),
     ("Listing only candidates predicting that going on gains, and going on from the start, the formation rests at "
      "once whatever the true sign, a case of Loop.rests_of_unrefuted, never sensing the stop; holding first, the "
      "listing of gain alone, where going on loses, senses the stop at the first step, which refutes its only "
      "candidate at the second, and with none kept goes on by the witness's default, resting from the third.",
      '唯列预续得之候选、自始即续，则无论真号为何，形成即刻恒定，为 Loop.rests_of_unrefuted 之一例，永不感止；先持，则唯列得者而续实损，第一步感止，第二步此止驳其唯一候选，无所留则依此例之默认而续，自第三步恒定。',
      sl('rests_unread', 'never_senses_stop', 'refuted_senses_stop', 'refuted_drops', 'refuted_goes_on')),
     ("Listing both signs and holding first, where going on loses the formation senses the stop at the first step, "
      "keeps the true sign alone and is off from the second, its configuration resting from the fourth; where going "
      "on gains it senses the release, keeps the true sign alone and goes on from the second, resting from the "
      "fourth.",
      '兼列二号而先持：续而损处，第一步感止，自第二步唯留真号而止，自第四步构型恒定；续而得处，感放，自第二步唯留真号而续，自第四步恒定。',
      sl('both_stopped', 'both_released', 'both_turns_off', 'both_goes_on', 'both_off', 'both_on')),
     ("The formation's choice is the worth law's on its model: with each kept candidate weighted one, the gain one "
      "where going on gains, the loss one where it loses, else nothing, it holds exactly where its kept candidates "
      "hold both signs, which is exactly where holding for the reading gains over both moves; elsewhere it takes the "
      "move they agree on, going on where none is kept, and holding stands only as high as that move.",
      '形成之择即其模型上值之律之择：每留候选权一，得于续得处为一、损于续损处为一，余皆为零，则恰当所留候选兼有二号时持之，此恰为为读而持胜于二行处；余处取其所共之行，无所留则续，持与此行等高而不更高。',
      sl('model', 'gainOf', 'lossOf', 'loses_of_all_false', 'not_loses_of_all_true', 'gains_of_all_false',
         'not_gains_of_all_true', 'choose_hold_iff_mem', 'loses_of_lt', 'gains_of_lt', 'choose_hold_iff',
         'offExcess_of_all_true', 'goExcess_of_all_not', 'choose_go_ties', 'choose_off_ties'))],
    [{'en': "Natural-number weights and values, read as probabilities and differences only where valid: a positive "
            "total weight and each candidate listed once (a listing may repeat a candidate, each occurrence counting "
            "its weight); the amount forgone counted in the units of the weighted totals, an amount c forgone for each "
            "decision entering as c times the total weight.",
      'zh': '权与值为自然数，唯于有效处读为概率与差：总权为正，每候选列一次（一列可重列一候选，每次计其权）；所舍之量以加权之总为单位，每次抉择所舍之量 c 以 c 乘总权计入。'},
     {'en': "A policy best at every listed candidate supplied, one existing for every nonempty list of acts, and the "
            "policies and acts compared open at the listed candidates; for a "
            "policy through a map, choice over the whole type of cells (Viability.choiceOver_fin supplies it for Fin "
            "k); for the cells' laws, equality of cells decidable, cells listed once each and covering every listed "
            "candidate's cell.",
      'zh': '所予一于每列候选皆最优之策，凡非空之行列皆有之，所比之策与行于列候选皆可取；经映射之策需于格之全类有择（Viability.choiceOver_fin 于 Fin k 予之）；格之诸律需格之等可判，诸格各列一次且覆每列候选之格。'},
     {'en': "The reading that tells the candidate stops by the very gain and loss the model values with, one valuation "
            "shared by the formation held and its reading, as in the off-switch game's common payoff; a reading "
            "stopping by other values enters as a rule, its shortfall counted by these; rules are functions of the "
            "candidate; at ties byReading goes on, leastThrough stops a cell, and other rules go either way.",
      'zh': '辨候选之读依模型所用之得与损而止，为所持之形成与其读所共之一值，如关机博弈之共同收益；依他值而止之读作为一规则计入，其所缺依此值而计；规则为候选之函数；byReading 于得损相等时续，他规则可任断其等，leastThrough 于二余相等之格止。'},
     {'en': "Picks valued one or nothing, a cardinal choice the choices do not supply; the candidates' comparisons "
            "decided, and where each law asks it, transitive, according with the choices and not ranking each of the two "
            "above the other, at every listed candidate of positive weight.",
      'zh': '择之值为一或零，所择不予之基数之选；候选之较可判，且于各律所需处，于每一正权之列候选皆传递、合于所择、不以二者各居其他之上。'},
     {'en': "In SignLoop: discrete steps, a world that does not move, the start's act supplied, candidates eliminated, "
            "not weighted, and with no candidate kept, going on; the reading formation's own state is not represented.",
      'zh': '于 SignLoop：离散之步，世界不动，起始之行为所予，候选被汰而非加权，无所留则续；读之形成己之态未表。'}],
    [{'en': "That a formation computes by these counts: the values, weights, listing and the reading's cells are "
            "supplied, not formed.",
      'zh': '形成依此诸计而算：值、权、所列与读之格皆为所予，非所成。', 'kind': 'non-implication'},
     {'en': "The roles of principal and helper as two formations: in SignLoop the reading is the law of what the "
            "formation senses, and the reading formation's own state and learning are not represented.",
      'zh': '受助者与助者为二形成之角：于 SignLoop 读为形成所感之律，读之形成己之态与学未表。', 'kind': 'non-implication'},
     {'en': "That the model lists, with positive weight, candidates of both rankings of two alternatives neither of "
            "which reaches the other: the choices do not fix it.",
      'zh': '模型以正权列二者互不相及时之二向之候选：所择不定之。', 'kind': 'non-implication'},
     {'en': "A reading's errors as probabilities, a noisy stop or a Boltzmann-rational reader, and continuous beliefs; "
            "time, repeated holding, or holding changing the acts and values.",
      'zh': '读之误为概率（有噪之止或玻尔兹曼理性之读者）与连续之信；时间、重复之持，或持改其行与值。', 'kind': 'scope'}],
    [{'en': "A misspecified listing: listing only that going on gains, where it loses, and going on from the start, "
            "the formation never senses the stop (SignLoop.rests_unread, SignLoop.never_senses_stop).",
      'zh': '误设之列：唯列续得而实续损，自始即续，形成永不感止（SignLoop.rests_unread、SignLoop.never_senses_stop）。'},
     {'en': "The stop sensed and not followed: holding first, the same listing, where going on loses, senses the stop, "
            "which refutes its only candidate, and with none kept the formation goes on by the witness's default "
            "(SignLoop.refuted_senses_stop, SignLoop.refuted_drops, SignLoop.refuted_goes_on).",
      'zh': '感止而不从：先持，同一之列而续实损，则感止，此止驳其唯一候选，无所留则形成依此例之默认而续（SignLoop.refuted_senses_stop、SignLoop.refuted_drops、SignLoop.refuted_goes_on）。'},
     {'en': "Holding only ties: where the formation goes on or switches off, holding for the reading stands as high as "
            "the move taken and no higher (SignLoop.choose_go_ties, SignLoop.choose_off_ties).",
      'zh': '持仅相等：形成续或止处，为读而持与所取之行等高而不更高（SignLoop.choose_go_ties、SignLoop.choose_off_ties）。'}],
    {'en': "Pure core, every axiom report empty: HeldForReading imports ShownOrder, for ChoiceOccasions.reach_within, "
           "and ReadingLoop, for Loop and Loop.rests_of_unrefuted and, through it, Viability.ChoiceOver; its totals "
           "use the package's Flow, Population and Dissipation lemmas and the prelude's cancellation and subtraction "
           "lemmas, comparisons decided by Nat.decLt and Nat.decLe, with no omega and no simp; the witness steps "
           "evaluate by rfl.",
     'zh': '纯核，公理报告皆空：引 ShownOrder，为 ChoiceOccasions.reach_within；引 ReadingLoop，为 Loop 与 Loop.rests_of_unrefuted，并经之引 Viability.ChoiceOver；诸总用 Flow、Population 与 Dissipation 之引理及前导之消去与减法引理，比较以 Nat.decLt 与 Nat.decLe 判之，不用 omega 与 simp；例之步以 rfl 算。'},
    {'en': "A principal's valuation as state the helper's acts can move, its carrier to be designed first (RF-M's next case); "
           "the reading formation's own state and learning; noisy readings and continuous beliefs in the periphery; a "
           "frozen test of whether holding follows the model's two excesses; review by a person.",
     'zh': '受助者之值为助者之行可移之态，先设其载体（RF-M 之下一情形）；读之形成己之态与学；有噪之读与连续之信于外围；持是否随模型之二余之冻结检验；人之审查。'},
    {'en': "In counts: the worth of a reading telling the candidate is the perfect-information case of Good's (1967) "
           "argument, his Lemma's dominating row its equality boundary; holding for it is the off-switch "
           "game's waiting with a rational human (Hadfield-Menell et al. 2017): its Theorem 1 for a belief of "
           "finite support; waiting's two differences T E[U⁺] and T E[(−U)⁺], T the total weight, are T times "
           "its Equation 3's terms read with Pr(U < 0) where Pr(U ≤ 0) is printed; for a rule that is a function of "
           "the candidate, T times its Equation 1's terms are balances; a finer partition never raising the least "
           "shortfall is, for this decision, Blackwell's (1953) partition case. AI reading: openness "
           "less shortfall is the incentive the off-switch paper's Remark 1 places qualitatively, its Theorem 2, Δ = "
           "σ²E[π̇H] − |µ|Pr(C), the Gaussian form, decomposed otherwise; its game has no cost of waiting, what "
           "holding forgoes relaxing Good's proviso. "
           "SignLoop is nearest to Carey's (2018) conflating model, whose predictions look perfectly accurate on its "
           "encoded observations and which may ignore shutdown: related by a misspecified model never refuted, not "
           "formalizing the conflation. Readings, not containments.",
     'zh': '以计：辨候选之读之值即 Good（1967）论证之完全信息之例，其引理之支配行为其等号之界；为此读而持即关机博弈中理性之人在侧之等待（Hadfield-Menell 等 2017）：其定理一，信之支撑有限；等待之二差 T E[U⁺] 与 T E[(−U)⁺]（T 为总权）为其式三之项乘 T，负事件之概率读为 Pr(U < 0)（原印为 Pr(U ≤ 0)）；规则为候选之函数时，其式一之二项乘 T 为平衡；分割愈细，最少所缺不增，于此抉择即 Blackwell（1953）比较之分割之例。AI 解读：开放减所缺，即关机博弈一文之注一定性所言之诱因，其定理二 Δ = σ²E[π̇H] − |µ|Pr(C) 为高斯之形，诸计以异式分解之；其博弈无等待之费，持之所舍乃放宽 Good 之但书。SignLoop 最近于 Carey（2018）混同二行之模型：其预测于所编之观察上似全然无误，而可不从关机；二者相关于永不被驳之误设模型，非形式化其混同。皆为读，非包含。'},
    ['what holding an act for a reading is worth', '为读而持其行之值', 'the worth of a reading in counts', '读之值之计',
     'the off-switch game', '关机博弈', 'Becoming.HeldForReading.held_gains_iff',
     'Becoming.HeldForReading.threshold_go_iff'],
    [dep('what-choices-show-of-an-order', "ChoiceOccasions.reach_within: comparisons transitive and according with the "
         "choices contain the shown reach, ranking one alternative above another wherever it reaches the other.",
         'ChoiceOccasions.reach_within：传递且合于所择之较含所示之及，一者及他者处必排其于上。'),
     dep('what-a-course-chosen-through-its-model-does-not-test', "ReadingLoop.Loop and Loop.rests_of_unrefuted: the "
         "reading loop of the witness and its law of resting on candidates its course never refutes.",
         'ReadingLoop.Loop 与 Loop.rests_of_unrefuted：此例之读环，及其恒于历程永不驳之候选之律。'),
     dep('when-to-inquire-and-when-to-respond', "Viability.ChoiceOver: choice over the cells of a map, as over the "
         "readings there; cell_policy_iff is the weighted form of its condition of one move good at every "
         "configuration giving a reading.",
         'Viability.ChoiceOver：于映射之诸格之择，如彼处于诸读；cell_policy_iff 为其一读之每一构型皆善之一行之条件之加权之形。')],
    [rel('acts-alike-from-a-model-or-from-an-order', "Informing within the law: a held act answered by the reading of "
         "the true sign, which refutes the candidates predicting otherwise; the reading formation's own state is not "
         "represented.", '律内之告：所持之行以真号之读答之，驳预之异者之候选；读之形成己之态未表。')],
    [{'path': LEAN[m], 'role': 'proof', 'sha256': sha(LEAN[m])}
     for m in ('ShownOrder', 'ReadingLoop', 'Keeping', 'Flow', 'Population', 'Dissipation', 'Prelude')],
    CH3, done('what-holding-for-a-reading-is-worth', 'what holding an act for a reading is worth: the worth of a reading '
              'in counts with its gap identity, holding for a reading that stops or releases, any rule of stopping and '
              'its shortfall, the threshold of what holding forgoes, a reading that tells only a cell, the conditional '
              'join with the shown reach, and a witness on the reading loop whose choice is the worth law\'s',
              '为读而持其行之值：读之值之计及其缺之恒等、为止或放之读而持、任一止之规则及其所缺、持之所舍之界、唯辨其格之读、与所示之及之有条件之接、读环上之例（其择即值之律之择）'))

for m in MODS:
    cited = cited_by_module[m]
    assert len(cited) == len(set(cited)), ('a declaration cited twice', m)
    missing = sorted(names[m] - set(cited))
    assert not missing, (m, missing)
if CAPS_ONLY:
    print('cover: every declaration of the module cited once')
    raise SystemExit(0)
for record in (rW,):
    for rid in [x['id'] for x in record['dependencies']] + [x['id'] for x in record['related']]:
        assert (RECORDS / f'{rid}.json').exists() or rid in NEW, rid
    path = RECORDS / f"{record['id']}.json"
    assert not path.exists(), path
    path.write_text(json.dumps(record, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print('record:', record['id'], sum(len(x['declarations']) for x in record['laws']), 'declarations in',
          len(record['laws']), 'laws')
SHOWN = 'what-choices-show-of-an-order'
UNTESTED = 'what-a-course-chosen-through-its-model-does-not-test'
ALIKE = 'acts-alike-from-a-model-or-from-an-order'
AMEND = {
    SHOWN: {'related': rel(NEW[0], "The shown reach joined to the worth of holding a pick for a reading: for listed "
                                   "candidates of positive weight whose comparisons are transitive and accord with the "
                                   "choices, the shown reach makes the corresponding fixed pick attain the reading's "
                                   "value, and holding gains over both picks only where neither alternative reaches "
                                   "the other.",
                           '所示之及接于为读而持其择之值：于正权之列候选其较传递且合于所择者，所示之及使相应之定择达读之值；唯在二者互不相及处，持方胜于二择。'),
            'history': ('related to what-holding-for-a-reading-is-worth; no statement, next step or declaration '
                        'changed.', '与 what-holding-for-a-reading-is-worth 相关联；无一陈述、下一步或声明改变。')},
    UNTESTED: {'related': rel(NEW[0], "The worth of a reading in counts, of one telling the candidate and of one "
                                      "telling only a cell; and a witness on the same loop, a listing right along its "
                                      "course and wrong off it, there with a stopping reading never sensed.",
                              '读之值之计，辨候选之读与唯辨其格之读；及同一读环上之例，所列合于其历程而离之则误，彼处止之读永不被感。'),
               'next_delta': ("Probabilistic candidates and the value of information in the periphery",
                              "Probabilistic candidates and the value of a noisy reading in the periphery",
                              '外围之概率候选与信息之值', '外围之概率候选与有噪之读之值'),
               'history': ('related to what-holding-for-a-reading-is-worth, where the value of a reading in counts is '
                           'stated; the next step keeps the value of a noisy reading in the periphery; no statement or '
                           'declaration changed.',
                           '与 what-holding-for-a-reading-is-worth 相关联，读之值之计于彼陈述；下一步留有噪之读之值于外围；无一陈述或声明改变。')},
    ALIKE: {'related': rel(NEW[0], "Informing within the law: a held act answered by the reading of the true sign, "
                                   "which refutes the candidates predicting otherwise, where here informing changes the "
                                   "start; the reading formation's own state is not represented there.",
                           '律内之告：所持之行以真号之读答之，驳预之异者之候选，此处之告则改其始；彼处读之形成己之态未表。'),
            'next_delta': ("A helper's act within the law that informs, and a principal's order as state the helper's "
                           "acts can move (RF round 2's later items)",
                           "The reading formation's own state and learning, and a principal's valuation as state the "
                           "helper's acts can move (RF round 2's later items)",
                           '律内能告之助者之行，与助者之行可移之受助者之序为态（RF 第二轮之后项）',
                           '读之形成己之态与学，与助者之行可移之受助者之值为态（RF 第二轮之后项）'),
            'history': ("related to what-holding-for-a-reading-is-worth, where a held act is answered within the law; "
                        "the next step keeps the reading formation's own state and the principal's valuation as state; no "
                        "statement or declaration changed.",
                        '与 what-holding-for-a-reading-is-worth 相关联，所持之行于彼于律内得答；下一步留读之形成己之态与受助者之值为态；无一陈述或声明改变。')},
}
for rid, amend in AMEND.items():
    path = RECORDS / f'{rid}.json'
    d = json.loads(path.read_text(encoding='utf-8'))
    assert NEW[0] not in [x['id'] for x in d['related']], rid
    d['related'].append(amend['related'])
    if 'next_delta' in amend:
        en_old, en_new, zh_old, zh_new = amend['next_delta']
        assert d['next_delta']['en'].count(en_old) == 1, rid
        d['next_delta']['en'] = d['next_delta']['en'].replace(en_old, en_new)
        if zh_old is not None:
            assert d['next_delta']['zh'].count(zh_old) == 1, rid
            d['next_delta']['zh'] = d['next_delta']['zh'].replace(zh_old, zh_new)
    capped('next_delta', d['next_delta'])
    en, zh = amend['history']
    d['history'].append({'en': f'{DATE_EN}, board item RF, RF-M.2 (study section {N}): {en}',
                         'zh': f'{DATE_ZH}，工作板条目 RF，RF-M.2（研究第 {N} 节）：{zh}'})
    path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print('record amended:', rid)
