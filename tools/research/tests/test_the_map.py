"""The map (the_map.py) against what it promises: every dynamic of the atlas has one card and every test one case; a
card's law is a declaration of its dynamic and its conditions are premises of the ledger; a law's sentence uses no word
on the list of words that fit only a person; a law keeps its conditions and a card its note whole; a law written up on
several cards counts once in a place; a square is filled by a general law only; a frozen prediction that rests on the
account is placed by its own conditions and outcome, and no case changes a law; a tie is drawn by one stated rule; the
six views are written from one join, the same bytes each time; and the repository's own data passes."""
import copy
import json
from pathlib import Path
import re
import sys
import unittest
from unittest import mock
from xml.etree import ElementTree

ROOT = Path(__file__).resolve().parents[3]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
from tools.research import the_map  # noqa: E402

WEB = {'roles': [{'id': 'any', 'en': 'anything that goes on', 'zh': '凡相续者', 'is': 'No role named.', 'account': 'line'},
                 {'id': 'stock', 'en': 'a stock', 'zh': '存量', 'is': 'Something with a level.', 'account': 'reserve'},
                 {'id': 'drawers', 'en': 'the drawers', 'zh': '取用者', 'is': 'What takes from a stock.', 'account': 'drawer'}],
       'ties': [{'id': 'draws-on', 'en': 'draws on', 'zh': '取', 'is': 'Takes from a stock.', 'short': 'draws on'}],
       'marks': [{'id': m, 'en': m, 'zh': z, 'is': 'said of a tie'} for m, z in zip(('begins', 'lasts', 'changes', 'ends', 'absent'), '生住异亡无')],
       'forms': [{'id': 'tie', 'en': 'a mark'}, {'id': 'border', 'en': 'a line'}], 'frames': [{'id': 'one-course', 'en': 'one course'}],
       'ways_in': [{'ask': 'what happens to something many draw on', 'ties': ['draws-on|drawers|stock']}]}
DYN = {'d1': {'id': 'd1', 'name': {'en': 'One'}, 'family': 'A', 'base': 'proved',
              'premises': [{'law': 'Becoming.X.a', 'takes': ['p1', 'p2']}], 'declarations': ['Becoming.X.b', 'Becoming.X.named']},
       'd2': {'id': 'd2', 'name': {'en': 'Two'}, 'family': 'B', 'base': 'proved', 'premises': [{'law': 'Becoming.X.b', 'takes': ['p2']}]},
       'd3': {'id': 'd3', 'name': {'en': 'Three'}, 'family': 'A', 'base': 'proved', 'premises': [{'law': 'Becoming.X.a', 'takes': ['p1']}]}}
LEDGER = {'p1': {'id': 'p1', 'name': {'en': 'a positive draw'}, 'statement': {'en': 'The draw is positive (0 < draw)'}},
          'p2': {'id': 'p2', 'name': {'en': 'nothing given back'}, 'statement': {'en': 'Nothing gives back: ∀ t, given t = 0'}}}
LAW = {'lean': 'Becoming.X.a', 'items': [], 'about': 0, 'form': 'tie', 'mark': 'ends', 'frame': 'one-course', 'then_en': 'The stock is empty from some step on.',
       'then_zh': '自某步起存量为空。', 'main_ifs': ['p1'], 'by_outside': False, 'strength': 'sufficient', 'evidence': 'theorem a'}
CARD = {'dynamic': 'd1', 'plain_en': 'A stock drawn on with nothing given back runs out.', 'plain_zh': '只取不补的存量会耗尽。', 'legend': False,
        'cast': [{'role': 'stock', 'as': 'the level'}], 'ties': [{'tie': 'draws-on', 'from': 'drawers', 'to': 'stock', 'as': 'draw'}],
        'laws': [LAW], 'built_cases': [], 'misfit': 'The amounts are not held. ' * 30}
CARD2 = {'dynamic': 'd2', 'plain_en': 'Every course goes on.', 'plain_zh': '凡相续者皆续。', 'legend': True, 'cast': [], 'ties': [],
         'laws': [], 'built_cases': [], 'misfit': 'Nothing here names a role.'}
CARD3 = {'dynamic': 'd3', 'plain_en': 'A stock refilled from outside does not run out.', 'plain_zh': '外来补给的存量不会耗尽。', 'legend': False,
         'cast': [{'role': 'stock', 'as': 'the level'}], 'ties': [{'tie': 'draws-on', 'from': 'drawers', 'to': 'stock', 'as': 'draw'}],
         'laws': [], 'built_cases': [], 'misfit': 'The amounts are not held.'}
PREDICTION = {'label': 'P1', 'frozen': True, 'says_en': 'The tank empties.', 'from_thesis': '', 'from_laws': ['Becoming.X.a'], 'step': 'follows',
              'ifs': [{'what_en': 'the pump runs', 'how': 'built', 'state': 'met'}], 'seen_en': 'It emptied.', 'outcome': 'agreed',
              'failed_at': 'none', 'rival_en': ''}
CASE = {'test': 'T', 'kind': 'run', 'state': 'run', 'case_en': 'A tank and a pump.', 'case_zh': '一个水箱和一台泵。',
        'things': [{'thing_en': 'the tank', 'role': 'stock', 'how': 'built'}],
        'bridges': [{'name': 'tank as stock', 'claim_en': 'The tank is the stock.', 'state': 'by construction', 'why_en': ''}],
        'predictions': [PREDICTION], 'afterwards_en': '', 'dynamics': ['d1'], 'shows_en': 'They agree.', 'shows_zh': '相合。'}
EDGE = 'draws-on|drawers|stock'


def changed(base, **change):
    out = copy.deepcopy(base)
    out.update(change)
    return out


def card(**law):
    return changed(CARD, laws=[changed(LAW, **law)])


def case(**prediction):
    return changed(CASE, predictions=[changed(PREDICTION, **prediction)])


class ValidationTests(unittest.TestCase):
    def check(self, cards=None, cases=None, web=WEB):
        return ' '.join(the_map.validate(web, [CARD, CARD2, CARD3] if cards is None else cards + [CARD2, CARD3], [CASE] if cases is None else cases,
                                         DYN, {'T'}, set(LEDGER)))

    def test_a_small_map_passes(self):
        self.assertEqual(self.check(), '')

    def test_every_dynamic_has_exactly_one_card(self):
        self.assertRegex(self.check(cards=[]), 'no card for the dynamic d1')
        self.assertNotRegex(self.check(cards=[]), 'no card for the dynamic d[23]')
        self.assertRegex(self.check(cards=[CARD, CARD]), '2 cards for one dynamic')
        self.assertRegex(self.check(cards=[CARD, changed(CARD, dynamic='d9')]), 'd9: not a dynamic of the atlas')

    def test_a_law_must_be_a_declaration_of_its_dynamic(self):
        self.assertEqual(self.check(cards=[card(lean='Becoming.X.b')]), '')
        self.assertRegex(self.check(cards=[card(lean='Becoming.Y.c')]), 'Becoming.Y.c is not a declaration of this dynamic')

    def test_a_condition_must_be_a_premise_of_the_ledger(self):
        self.assertRegex(self.check(cards=[card(main_ifs=['p1', 'p7'])]), 'main_ifs: p7 is not a premise of the atlas\'s ledger')

    def test_a_law_sentence_uses_no_word_on_the_list_of_words_that_fit_only_a_person(self):
        for field, said, word in (('then_en', 'Those ahead keep the rule.', 'Those ahead'), ('then_en', 'Nobody reads the stock.', 'Nobody'),
                                  ('then_zh', '领先的人守住规则。', '人'), ('then_zh', '谁也读不到存量。', '谁'), ('compare_en', 'more people than before', 'people')):
            with self.subTest(said=said):
                self.assertRegex(self.check(cards=[card(**{field: said})]), re.escape(f'{field}: "{word}" fits only a person'))
        self.assertRegex(self.check(cards=[changed(CARD, plain_en='People drain a stock.')]), 'plain_en: "People"')
        self.assertRegex(self.check(cards=[changed(CARD, plain_zh='人取尽存量。')]), 'plain_zh: "人"')

    def test_a_model_and_a_case_keep_their_own_words(self):
        """The list is short: a model's own terms pass, and a case says what was there, people included."""
        self.assertEqual(self.check(cards=[card(then_en='The round completes where worker and reviewer are present.')]), '')
        self.assertEqual(self.check(cases=[changed(CASE, case_en='Forty people shared a well.', case_zh='四十人共用一口井。')]), '')

    def test_a_law_names_kinds_the_web_has(self):
        self.assertRegex(self.check(cards=[card(form='border')]), 'states one mark of web.json')
        self.assertRegex(self.check(cards=[card(mark='')]), 'states one mark of web.json')
        self.assertEqual(self.check(cards=[card(form='border', mark='')]), '')
        self.assertRegex(self.check(cards=[card(frame='two')]), "frame 'two' is not in web.json")
        self.assertRegex(self.check(cards=[card(strength='likely')]), "strength 'likely'")
        self.assertRegex(self.check(cards=[card(strength='')]), "strength ''")
        self.assertRegex(self.check(cards=[card(about=3)]), 'neither one of the card\'s ties nor a role')
        self.assertRegex(self.check(cards=[card(about=True)]), 'neither one of the card\'s ties nor a role')
        self.assertEqual(self.check(cards=[card(about=-1, about_role='stock')]), '')
        self.assertRegex(self.check(cards=[changed(CARD, ties=[{'tie': 'draws-on', 'from': 'drawers', 'to': 'pool'}])]), 'not a tie between two named roles')
        self.assertRegex(self.check(cards=[changed(CARD, ties=[{'tie': 'draws-on', 'from': 'any', 'to': 'stock'}])]), 'not a tie between two named roles')
        self.assertRegex(self.check(cards=[changed(CARD, legend=True)]), 'names no tie')
        self.assertRegex(self.check(cards=[changed(CARD, built_cases=[{'lean': 'Becoming.X.b'}])]), 'built_cases: each needs lean and shows_en')
        self.assertRegex(self.check(cards=[{k: v for k, v in CARD.items() if k != 'misfit'}]), 'a card needs')

    def test_every_test_has_exactly_one_case_in_the_lists(self):
        self.assertRegex(self.check(cases=[]), 'no case for the test T')
        self.assertRegex(self.check(cases=[CASE, CASE]), '2 cases for one test')
        self.assertRegex(self.check(cases=[CASE, changed(CASE, test='U')]), 'U: not a test of')
        self.assertRegex(self.check(cases=[changed(CASE, kind='survey')]), "kind 'survey'")
        self.assertRegex(self.check(cases=[changed(CASE, dynamics=['d9'])]), 'd9 is not a dynamic of the atlas')
        self.assertRegex(self.check(cases=[changed(CASE, things=[{'thing_en': 'x', 'role': 'pool', 'how': 'built'}])]), 'things: each says what it is')
        self.assertRegex(self.check(cases=[changed(CASE, things=[{'role': 'stock', 'how': 'built'}])]), 'things: each says what it is')
        self.assertRegex(self.check(cases=[changed(CASE, bridges=[{'name': 'b', 'state': 'proved'}])]), 'its state is one of held, failed')
        self.assertRegex(self.check(cases=[case(outcome='refuted the law')]), 'outside its list')
        self.assertRegex(self.check(cases=[case(failed_at='law')]), 'outside its list')  # a case has no place for a failure of a proved law
        self.assertRegex(self.check(cases=[changed(CASE, predictions=[{k: v for k, v in PREDICTION.items() if k != 'ifs'}])]), 'a prediction needs')
        self.assertRegex(self.check(cases=[case(frozen='yes')]), 'frozen true or false')
        self.assertRegex(self.check(cases=[case(failed_at='if', outcome='disagreed')]), 'none of its conditions is recorded as failed')
        self.assertEqual(self.check(cases=[case(failed_at='if', outcome='disagreed', ifs=[{'what_en': 'x', 'how': 'measured', 'state': 'failed'}])]), '')

    def test_the_web_needs_its_kinds(self):
        self.assertRegex(self.check(web=changed(WEB, roles=WEB['roles'][1:])), 'the role "any"')
        self.assertRegex(self.check(web=changed(WEB, marks=WEB['marks'][:2])), 'begins, lasts, changes, ends are needed')
        self.assertRegex(self.check(web=changed(WEB, ties=[])), 'ties: missing')
        self.assertRegex(self.check(web=changed(WEB, roles=[{k: v for k, v in r.items() if k != 'is'} for r in WEB['roles']])), 'roles: each needs id, en, zh, is, account')
        self.assertRegex(self.check(web=changed(WEB, ways_in=[{'ask': 'what selects', 'ties': ['selects|rule|selected']}])), 'ways_in\\[0\\]')
        self.assertRegex(self.check(web=changed(WEB, forms=WEB['forms'] + [{'id': 'sums', 'en': 'a sum'}])), 'the views have no line for the mark or form sums')


class JoinTests(unittest.TestCase):
    def join(self, cards=None, cases=None):
        return the_map.join(WEB, [CARD, CARD2, CARD3] if cards is None else cards + [CARD2, CARD3], [CASE] if cases is None else cases, DYN, LEDGER)

    def edge(self, **kw):
        return self.join(**kw)['edges'][EDGE]

    def test_a_law_sits_on_its_tie_with_its_conditions(self):
        model = self.join()
        edge = model['edges'][EDGE]
        self.assertEqual((edge['dyn'], edge['marks'], edge['n_dyn']), (['d1', 'd3'], {'begins': 0, 'lasts': 0, 'changes': 0, 'ends': 1}, 1))
        law = model['laws'][edge['laws'][0]]
        self.assertEqual((law['main'], law['more'], law['strength'], law['listed']), (['p1'], 1, 'sufficient', True))
        self.assertEqual(model['prem'], {'p1': 'a positive draw'})  # a condition is said by its name in the ledger
        self.assertIn(' *If:* a positive draw; and 1 more.', the_map._said(model, law, the_map.LAWS_PAGE))

    def test_a_law_whose_premises_the_atlas_keeps_under_another_dynamic_keeps_its_conditions(self):
        """Becoming.X.b is declared by d1 and has its premise row under d2."""
        law = next(iter(self.join(cards=[card(lean='Becoming.X.b', main_ifs=['p2'])])['laws'].values()))
        self.assertEqual((law['main'], law['more'], law['also']), (['p2'], 0, ['d2']))
        law = next(iter(self.join(cards=[card(lean='Becoming.X.b', main_ifs=[])])['laws'].values()))
        self.assertEqual(law['main'], ['p2'])  # with no main condition named, the row's first ones stand in

    def test_a_law_the_atlas_lists_by_name_alone_says_where_its_conditions_are(self):
        model = self.join(cards=[card(lean='Becoming.X.named', main_ifs=[])])
        law = next(iter(model['laws'].values()))
        self.assertEqual((law['main'], law['listed'], model['counts']['unlisted']), ([], False, 1))
        self.assertIn('Its conditions are in its Lean statement', the_map._said(model, law, the_map.LAWS_PAGE))

    def test_a_law_written_up_on_two_cards_counts_once_in_a_place(self):
        """The write-up of the course itself stands for the law; the one that needs a given changed is kept with its dynamic."""
        other = changed(CARD3, laws=[changed(LAW, by_outside=True, then_en='Refilled, the stock does not empty.')])
        model = the_map.join(WEB, [CARD, CARD2, other], [CASE], DYN, LEDGER)
        edge = model['edges'][EDGE]
        self.assertEqual((len(edge['laws']), edge['marks']['ends'], edge['given'], model['counts']['folded']), (1, 1, 0, 1))
        self.assertEqual(model['laws'][edge['laws'][0]]['dynamic'], 'd1')
        self.assertEqual(len(model['dynamics']['d3']['laws']), 1)
        only = the_map.join(WEB, [changed(CARD, laws=[]), CARD2, other], [CASE], DYN, LEDGER)['edges'][EDGE]
        self.assertEqual((only['marks']['ends'], only['given']), (0, 1))

    def test_a_card_keeps_its_note_whole(self):
        self.assertEqual(self.join()['dynamics']['d1']['misfit'], CARD['misfit'])
        self.assertGreater(len(CARD['misfit']), 600)

    def test_a_square_is_filled_by_a_general_law_only(self):
        self.assertEqual(the_map._square(self.edge(), 'ends'), 'law')
        built = self.edge(cards=[card(strength='witness')])
        self.assertEqual((built['marks']['ends'], built['built']['ends'], the_map._square(built, 'ends')), (0, 1, 'built'))
        given = self.edge(cards=[card(by_outside=True)])
        self.assertEqual((given['marks']['ends'], given['given'], the_map._square(given, 'ends')), (0, 1, 'none'))
        line = self.edge(cards=[card(form='border', mark='')])
        self.assertEqual((line['marks'], line['other']), ({m: 0 for m in the_map.MARKS}, 1))
        for e in (self.edge(), built, given, line):  # every law is counted once
            self.assertEqual(sum(e['marks'].values()) + sum(e['built'].values()) + e['other'] + e['other_built'] + e['given'], len(e['laws']))
        lines = the_map._law_lines(self.join(cards=[card(strength='witness')]), built['laws'], the_map.LAWS_PAGE)
        self.assertRegex(lines[0], r'^- \*\*What makes it end\*\*\. .*\(one built case; ')
        self.assertEqual(lines[1], '- **No law here shows** what makes it begin, last or change.')
        lines = the_map._law_lines(self.join(cards=[card(by_outside=True)]), given['laws'], the_map.LAWS_PAGE)
        self.assertEqual(len(lines), 1)
        self.assertRegex(lines[0], r'^- \*\*If something given were changed\*\* \(1 law\)\. ')

    def test_a_law_about_one_role_or_none_is_kept_with_that_role(self):
        roles = {r['id']: r for r in self.join(cards=[changed(CARD, laws=[changed(LAW, about=-1, about_role='stock'), changed(LAW, about=-1)])])['roles']}
        self.assertEqual((len(roles['stock']['laws']), len(roles['any']['laws'])), (1, 1))

    def test_a_frozen_prediction_that_rests_on_the_account_is_placed_by_its_own_record(self):
        state = lambda *states: the_map.if_state({'ifs': [{'state': s} for s in states]})
        self.assertEqual([state('met', 'met'), state('met', 'failed'), state('met', 'not checked'), state()], ['met', 'not met', 'not checked', 'none stated'])
        self.assertEqual(self.join()['grid']['met']['agreed'], [('T', 1)])
        missed = self.join(cases=[case(outcome='disagreed', failed_at='bridge', ifs=[{'what_en': 'x', 'how': 'measured', 'state': 'failed'}])])
        self.assertEqual((missed['grid']['not met']['disagreed'], missed['counts']['unmet_unseen'], missed['fails']), ([('T', 1)], 1, [['bridge', 1]]))
        self.assertEqual(missed['tests']['T']['spread'], [['not met', 'disagreed', 1]])
        corner = next(c for c in missed['corners'] if (c['if'], c['then']) == ('not met', 'disagreed'))
        self.assertEqual((corner['n'], corner['tests'], corner['placed']), (1, [('T', 1)], [['bridge', 1]]))

    def test_what_is_not_such_a_prediction_is_counted_apart(self):
        for change, count in (({'from_laws': [], 'from_thesis': ''}, 'preds_other'),  # names no law or thesis
                              ({'step': 'identity'}, 'preds_checks'), ({'step': 'check'}, 'preds_checks'),  # cannot come out otherwise; a check of the test
                              ({'frozen': False}, 'preds_unfrozen')):  # stated without a freeze
            model = self.join(cases=[case(**change)])
            self.assertEqual((model['counts']['preds_rest'], model['counts'][count], model['grid']['met']['agreed'], model['tests']['T']['rests']),
                             (0, 1, [], 0), change)
        self.assertEqual(self.join(cases=[case(frozen=False)])['edges'][EDGE]['met'], [])  # and it marks no tie

    def test_a_case_changes_no_law(self):
        """Reasoning and situation are kept apart: the laws, their conditions and each tie's squares are the same with
        every case, with a case that disagreed, and with none."""
        told = [self.join(cases=c) for c in ([CASE], [case(outcome='disagreed', failed_at='bridge')], [])]
        laws_of = lambda m: {k: {f: e[f] for f in ('marks', 'built', 'other', 'other_built', 'given', 'laws', 'dyn', 'drawn')} for k, e in m['edges'].items()}
        for model in told[1:]:
            self.assertEqual(model['laws'], told[0]['laws'])
            self.assertEqual(laws_of(model), laws_of(told[0]))
            self.assertEqual(model['prem'], told[0]['prem'])

    def test_only_a_prediction_with_a_verdict_marks_a_tie(self):
        self.assertEqual([self.edge()[k] for k in ('reach', 'near', 'met')], [the_map.REACH['run'], 1, ['T']])
        for outcome in ('could not tell', 'no verdict'):
            self.assertEqual([self.edge(cases=[case(outcome=outcome)])[k] for k in ('reach', 'near', 'met')], [0, 0, []], outcome)
        elsewhere = self.edge(cases=[case(from_laws=['Becoming.Z.z'])])  # it bears on the dynamic and names no law here
        self.assertEqual([elsewhere[k] for k in ('reach', 'near', 'met')], [0, 1, []])


class RepositoryTests(unittest.TestCase):
    """The repository's own map."""

    @classmethod
    def setUpClass(cls):
        loaded, errors = the_map.load()
        assert not errors, errors
        cls.web, cls.cards, cls.cases, cls.dyn, cls.ledger, cls.folders = loaded
        cls.model = the_map.join(cls.web, cls.cards, cls.cases, cls.dyn, cls.ledger)
        cls.pages, cls.errors = the_map.render()

    def test_the_data_passes_and_six_views_are_written(self):
        self.assertEqual(the_map.validate(self.web, self.cards, self.cases, self.dyn, set(self.folders), set(self.ledger)), [])
        self.assertEqual(self.errors, [])
        self.assertEqual(set(self.pages), {the_map.PAGE, the_map.LAWS_PAGE, the_map.DYNAMICS_PAGE, the_map.CASES_PAGE, the_map.PICTURE, the_map.INTERACTIVE})

    def test_the_views_are_the_same_bytes_each_time(self):
        again, errors = the_map.render()
        self.assertEqual((errors, again), ([], self.pages))

    def test_the_inputs_exist(self):
        self.assertEqual([str(p) for p in the_map.inputs() if not p.is_file()], [])

    def test_a_tie_is_drawn_by_one_rule(self):
        by_kind = {}
        for e in self.model['edges'].values():
            by_kind.setdefault(e['tie'], []).append(e)
        for kind, edges in by_kind.items():
            most = max(len(e['dyn']) for e in edges)
            heads = [e for e in edges if e.get('others') is not None]
            self.assertEqual(len(heads), 1, kind)
            self.assertEqual(len(heads[0]['dyn']), most, kind)
            for e in edges:
                self.assertEqual(e['drawn'], e is heads[0] or len(e['dyn']) >= the_map.DRAWN_MIN, e['id'])
                self.assertEqual(e['shown_as'], e['id'] if e['drawn'] else heads[0]['id'], e['id'])
        drawn = {g['k'] for g in the_map.geometry(self.model)}
        self.assertEqual(drawn, {k for k, e in self.model['edges'].items() if e['drawn']})

    def test_the_counts_agree_with_one_another(self):
        c, grid = self.model['counts'], self.model['grid']
        self.assertEqual(c['agreed'] + c['disagreed'] + c['notrej'] + c['cant'] + c['noverdict'], c['preds_frozen'])
        self.assertEqual(c['preds_frozen'] + c['preds_unfrozen'], c['preds'])
        self.assertEqual(c['preds_rest'] + c['preds_checks'] + c['preds_other'], c['preds_frozen'])
        self.assertEqual(c['rest_follows'] + c['rest_beyond'] + c['rest_forecast'], c['preds_rest'])
        self.assertEqual(sum(n for i in grid for o in grid[i] for _, n in grid[i][o]), c['preds_rest'])
        for corner in self.model['corners']:
            self.assertEqual(corner['n'], sum(n for _, n in grid[corner['if']][corner['then']]))
            self.assertLessEqual(sum(n for _, n in corner['placed']), corner['n'])
        self.assertEqual(c['on_ties'] + c['on_roles'] + c['on_any'], c['laws'] - c['folded'])
        self.assertLessEqual(c['laws_distinct_atlas'], c['laws_distinct'])
        self.assertLessEqual(c['laws_distinct'], c['laws'])
        self.assertEqual(c['bridges_held'] + c['bridges_failed'] + c['bridges_built'] + c['bridges_unchecked'], c['bridges'])
        self.assertEqual(c['ifs_met'] + c['ifs_failed'] + c['ifs_unchecked'], c['ifs'])
        self.assertEqual(c['edges_seen'] + c['edges_near'] + c['edges_none'], c['edges'])
        self.assertEqual(c['laws_named_atlas'] + c['laws_named_off'], c['laws_named'])
        self.assertEqual(c['edges'] + c['edges_thin'], len(self.model['edges']))
        self.assertEqual(c['dynamics'], len(self.dyn))
        self.assertEqual(c['fails_total'], sum(1 for x in self.cases for p in x['predictions'] if p['frozen'] and p['failed_at'] != 'none'))
        for e in list(self.model['edges'].values()) + self.model['roles']:  # every law of a place is counted once
            self.assertEqual(sum(e['marks'].values()) + sum(e['built'].values()) + e['other'] + e['other_built'] + e['given'], len(e['laws']), e['id'])
            self.assertEqual(len({self.model['laws'][i]['lean'] for i in e['laws']}), len(e['laws']), e['id'])

    def test_every_law_keeps_its_conditions(self):
        named = [l['main_ifs'] for c in self.cards for l in c['laws']]
        rows = {}  # a Lean law, and whether some premise row of the atlas gives it a premise
        for e in self.dyn.values():
            for h in e.get('premises') or []:
                rows[h['law']] = rows.get(h['law'], False) or bool(h.get('takes'))
        for l in self.model['laws'].values():
            mine = named[int(l['id'][1:])]
            if mine:
                self.assertEqual(l['main'], mine, l['lean'])
            elif rows.get(l['lean']):
                self.assertTrue(l['main'], l['lean'])  # the row's first conditions stand in, whichever dynamic keeps the row
            self.assertEqual(l['listed'], l['lean'] in rows or bool(l['main']), l['lean'])
        self.assertEqual(self.model['counts']['unlisted'], sum(1 for l in self.model['laws'].values() if l['lean'] not in rows and not l['main']))
        self.assertEqual([i for i, s in self.model['prem'].items() if not s], [])

    def test_the_page_is_short_and_points_to_every_drawn_tie(self):
        page = self.pages[the_map.PAGE]
        self.assertTrue(page.startswith('# The map\n'))
        self.assertIn(the_map.GENERATED, page)
        self.assertIn('*AI-written, ', page)
        self.assertLessEqual(len(re.findall(r'\bAI\b', page)), 3)  # that it is AI-written, and how it was made
        self.assertLess(len(re.findall(r'\S+', page)), 4200)  # a page to read through; the detail is on the three pages it links
        laws = self.pages[the_map.LAWS_PAGE]
        for k, e in self.model['edges'].items():
            anchor = 'tie-' + k.replace('|', '-')
            self.assertEqual(f'<a id="{anchor}"></a>' in laws, e['drawn'], k)
            self.assertEqual(f'](LAWS.md#{anchor})' in page, e['drawn'], k)
        for r in self.model['roles']:
            if r['id'] != 'any':
                self.assertEqual(f'<a id="role-{r["id"]}"></a>' in laws, bool(r['laws']), r['id'])
        for name in (the_map.PICTURE, the_map.INTERACTIVE, the_map.LAWS_PAGE, the_map.DYNAMICS_PAGE, the_map.CASES_PAGE):
            self.assertIn(f']({name.rsplit("/", 1)[1]}', page, name)

    def test_the_laws_page_gives_each_law_with_its_conditions(self):
        laws = self.pages[the_map.LAWS_PAGE]
        quoted = [line for line in laws.split('\n') if re.match(r'- \*\*[^*]+\*\*.*`[^`]+`', line)]
        self.assertGreater(len(quoted), 150)
        with_conditions = sum(1 for l in self.model['laws'].values() if l['main'] or l['more'])
        self.assertGreater(with_conditions, 600)
        self.assertGreater(sum(' *If:* ' in q for q in quoted), len(quoted) * 0.7)
        for e in self.model['edges'].values():  # a thinner tie's laws stand under the drawn tie of its kind
            if not e['drawn'] and e['laws']:
                roles = {r['id']: r['en'] for r in self.model['roles']}
                self.assertIn(f'*The same tie between {roles[e["from"]]} and {roles[e["to"]]}* ({the_map._n(len(e["dyn"]), "dynamic")}, '
                              f'{the_map._n(len(e["laws"]), "law")}):', laws, e['id'])

    def test_every_dynamic_and_every_test_is_listed_once(self):
        linked = re.findall(r'^\| \[[^\]]*\]\(\.\./atlas/families/[a-h]\.md#([^)]+)\)', self.pages[the_map.DYNAMICS_PAGE], re.M)
        self.assertEqual(sorted(linked), sorted(self.dyn))
        anchors = re.findall(r'^<a id="(case-[^"]+)"></a>$', self.pages[the_map.CASES_PAGE], re.M)
        self.assertEqual(sorted(anchors), sorted(the_map.case_anchor(t) for t in self.folders))
        dynamics = self.pages[the_map.DYNAMICS_PAGE]
        for e in self.model['edges'].values():  # a tie's section accounts for every dynamic that speaks of it
            if e['drawn']:
                section = dynamics.split(f'<a id="tie-{e["id"].replace("|", "-")}"></a>', 1)[1].split('\n<a id="', 1)[0]
                said = re.search(r'(\d+) dynamics speak of this tie: (\d+) of the (\d+) listed here, and (\d+) listed elsewhere', section)
                rows = re.findall(r'^\| \[[^\]]*\]\([^)]*#([^)]+)\)', section, re.M)
                self.assertEqual((int(said.group(1)), int(said.group(3))), (len(e['dyn']), len(rows)), e['id'])
                self.assertEqual(int(said.group(2)) + int(said.group(4)), len(e['dyn']), e['id'])
                self.assertEqual(int(said.group(2)), len(set(rows) & set(e['dyn'])), e['id'])
        for d in self.model['dynamics'].values():  # where a dynamic has laws on a tie, it is listed under the tie with most of them
            on = [self.model['laws'][i]['edge'] for i in d['laws'] if self.model['laws'][i]['edge']]
            self.assertEqual(d['home'] is None, not on, d['id'])
            if on:
                self.assertEqual(on.count(d['home']), max(on.count(k) for k in set(on)), d['id'])

    def test_the_pages_link_one_another_at_anchors_that_exist(self):
        from tools.research import reading_catalogue, research
        self.assertEqual(research.check_links(self.pages, set(self.pages)), [])  # the render's own check, the script and the picture included
        pages = {p.rsplit('/', 1)[1]: body for p, body in self.pages.items() if p.endswith('.md')}
        anchors = {name: reading_catalogue.anchors_from_text(body) for name, body in pages.items()}
        missing = [f'{name}: {target}#{anchor}' for name, body in pages.items()
                   for target, anchor in re.findall(r'\]\((?:(THE-MAP|LAWS|DYNAMICS|CASES)\.md)?#([^)\s]+)\)', body)
                   if anchor not in anchors[(target + '.md') if target else name]]
        self.assertEqual(missing, [])
        for e in self.model['edges'].values():  # every drawn tie has its section on the laws page and on the dynamics page
            for name in ('LAWS.md', 'DYNAMICS.md'):
                self.assertEqual('tie-' + e['id'].replace('|', '-') in anchors[name], e['drawn'], (name, e['id']))

    def test_the_picture_is_one_drawing_that_stands_alone(self):
        svg = ElementTree.fromstring(self.pages[the_map.PICTURE])
        ns = '{http://www.w3.org/2000/svg}'
        self.assertEqual((svg.find(ns + 'title') is not None, svg.find(ns + 'desc') is not None), (True, True))
        self.assertEqual(len(svg.findall(ns + 'path')), self.model['counts']['edges'])
        boxes = [t.text for t in svg.iter(ns + 'text')]
        for r in self.web['roles']:
            self.assertEqual(r['en'] in boxes, r['id'] != 'any', r['id'])
        self.assertNotRegex(self.pages[the_map.PICTURE], r'var\(|class=|<style|href="http')

    def test_the_map_to_operate_is_one_document_the_site_takes(self):
        from tools.publishing import build_site
        document = self.pages[the_map.INTERACTIVE]
        self.assertLess(len(document.encode('utf-8')), the_map.MAX_INTERACTIVE)
        self.assertLess(the_map.MAX_INTERACTIVE, build_site.MAX_PAGE)
        self.assertTrue(document.startswith('<!doctype html>\n<html lang="en">\n<head>\n<meta charset="utf-8">'))
        self.assertNotRegex(document, r'/\*[A-Z]+\*/|\{\{\w+\}\}')  # every place of the template is filled
        outside = [u for u in re.findall(r'\b(?:src|href)="([^"]+)"', document) if not u.startswith(('#', the_map.SITE, '${D.site}'))]
        self.assertEqual(outside, [])  # no font, script or style from elsewhere: its links go to the reader's site
        self.assertEqual(self.model['site'], the_map.SITE)
        self.assertNotRegex(document, r'@import|url\(\s*["\']?https?:|<link\b|<script\b[^>]*\bsrc=')
        self.assertIsNone(build_site.LOCAL_PATH.search(document))
        # A name that differs from a page's only by case would be one file on a disk blind to case.
        written = [the_map.INTERACTIVE.lower()] + [p[:-3].lower() + '.html' for p in (the_map.PAGE, the_map.LAWS_PAGE, the_map.DYNAMICS_PAGE, the_map.CASES_PAGE)]
        self.assertEqual(len(set(written)), len(written))
        data = json.loads(re.search(r'const D = (\{.*\});\n', document).group(1).replace('<\\/', '</'))
        self.assertEqual(data['counts'], self.model['counts'])
        self.assertEqual({d: x['misfit'] for d, x in data['dynamics'].items()}, {c['dynamic']: c['misfit'] for c in self.cards})
        self.assertEqual(data['labels']['questions'], [list(q) for q in the_map.QUESTIONS])  # the views share one list of words

    def test_a_map_to_operate_too_large_for_the_site_stops_the_render(self):
        with mock.patch.object(the_map, 'MAX_INTERACTIVE', 1000):
            pages, errors = the_map.render()
        self.assertEqual(pages, {})
        self.assertRegex(' '.join(errors), 'interactive.html: \\d+ bytes, over 1000')

    def test_the_site_publishes_the_views(self):
        site = json.loads((ROOT / '_process/research-config.json').read_text(encoding='utf-8'))['site']
        for page in (the_map.PAGE, the_map.LAWS_PAGE, the_map.DYNAMICS_PAGE, the_map.CASES_PAGE):
            self.assertIn(page, site['pages'])
        self.assertLessEqual({the_map.PICTURE, the_map.INTERACTIVE}, set(site['assets']))
        self.assertIn([the_map.PAGE, 'Map'], site['nav'])
        card = next(w for w in site['ways_in'] if w['path'] == the_map.PAGE)
        self.assertIn('time_until', card)  # a page to look things up in says what its time is of


if __name__ == '__main__':
    unittest.main()
