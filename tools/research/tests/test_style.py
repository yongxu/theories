"""Readability lint and growth ratchet: form only, never the substance of a boundary."""
import copy
import json
import unittest

from tools.research import registry, research, style


def v1_record(**fields):
    base = {'id': 'example', 'schema_version': 1, 'title': {'en': 'Example', 'zh': '例'},
            'claim': {'en': 'Every step keeps the balance.', 'zh': '每一步保持平衡。'},
            'limitations': {'en': 'Stated for discrete steps.', 'zh': '按离散步骤陈述。'},
            'validation_scope': {'en': 'Checked.', 'zh': '已查。'}, 'correspondence': {'en': 'Formal.', 'zh': '形式。'},
            'next_delta': {'en': 'None.', 'zh': '无。'}, 'hypotheses': [], 'counterexamples': []}
    base.update(fields)
    return base


def v2_record(**fields):
    r = v1_record(schema_version=2, statement={'en': 'Every step keeps the balance.', 'zh': '每一步保持平衡。'})
    r.pop('limitations')
    r.update(fields)
    return r


class LintTests(unittest.TestCase):
    def rules(self, record):
        return {f['rule'] for f in style.lint(record)}

    def test_process_markers_in_claim(self):
        r = v1_record(claim={'en': 'P92 shows the bound (receipt 20261013T125626.097616Z); this round adds §29.', 'zh': '本轮'})
        found = self.rules(r)
        for rule in ('process-marker:round-number', 'process-marker:receipt-timestamp', 'process-marker:round-narration', 'process-marker:section-reference'):
            self.assertIn(rule, found)

    def test_lean_names_and_letters_are_not_round_numbers(self):
        r = v1_record(claim={'en': 'Uses World.P2 and P(x), J1–J4, BC1 and G0.', 'zh': '使用 G0。'})
        self.assertNotIn('process-marker:round-number', self.rules(r))

    def test_process_markers_outside_public_fields_are_allowed_singly(self):
        r = v2_record(validation_scope={'en': 'The P92 receipt binds the module.', 'zh': 'P92 回执绑定该模块。'})
        self.assertEqual([f for f in style.lint(r) if f['rule'].startswith('process-marker')], [])

    def test_stock_boundary_is_suggested_as_key(self):
        r = v1_record(limitations={'en': 'Stated for discrete steps; evaluates neither arising nor ceasing.', 'zh': '…'},
                      claim={'en': 'Each run returns. No ethical premise and no Lean axiom is used.', 'zh': '每次运行都返回。不用伦理前提，也不用 Lean 公理。'})
        keys = {f['detail'] for f in style.lint(r) if f['rule'] == 'stock-boundary'}
        for key in ('discrete-steps', 'no-evaluation', 'no-ethical-premise'):
            self.assertTrue(any(key in k for k in keys), key)

    def test_suggested_keys_exist_in_the_shared_file(self):
        self.assertLessEqual(set(style.STOCK), set(registry.standard_boundaries()))

    def test_v1_findings_are_warnings_only(self):
        r = v1_record(claim={'en': 'P92 ' * 600, 'zh': 'x'}, title={'en': 'A title: ' + 'that carries the whole statement ' * 5, 'zh': '题'})
        self.assertTrue(style.lint(r))
        self.assertEqual({f['severity'] for f in style.lint(r)}, {'warning'})

    def test_v1_statement_is_checked_like_schema_2(self):
        r = v1_record(statement={'en': 'P92 shows it. ' + 'x' * 300, 'zh': '陈述'})
        errors = {(f['field'], f['rule']) for f in style.lint(r) if f['severity'] == 'error'}
        self.assertEqual(errors, {('statement', 'length'), ('statement', 'process-marker:round-number')})

    def test_v2_hard_rules_are_errors_and_other_caps_warn(self):
        r = v2_record(statement={'en': 'Target: P90 shows it.', 'zh': '目标'}, claim={'en': 'x' * 1600, 'zh': '式'},
                      title={'en': 'T' * 101, 'zh': '题'})
        by_rule = {(f['field'], f['rule']): f['severity'] for f in style.lint(r)}
        self.assertEqual(by_rule[('statement', 'process-marker:round-number')], 'error')
        self.assertEqual(by_rule[('title', 'length')], 'error')
        self.assertEqual(by_rule[('claim', 'length')], 'warning')

    def test_overview_is_always_a_warning(self):
        overview = {'title': {'en': 'P92 result', 'zh': '结果'}, 'summary': {'en': 'Summary.', 'zh': '摘要。'}, 'evidence': {'en': 'Receipt.', 'zh': '回执。'}}
        for r in (v1_record(overview=overview), v2_record(overview=overview)):
            found = [f for f in style.lint(r) if f['field'].startswith('overview.')]
            self.assertTrue(found)
            self.assertEqual({f['severity'] for f in found}, {'warning'})

    def test_round_accretion(self):
        r = v1_record(validation_scope={'en': 'P90 ok. P92 ok. P94 ok. P97 ok.', 'zh': '…'})
        self.assertIn('round-accretion', self.rules(r))
        self.assertIn('error', {f['severity'] for f in style.lint(v2_record(validation_scope=r['validation_scope'])) if f['rule'] == 'round-accretion'})

    def test_statement_leads_with_what_the_result_does(self):
        self.assertIn('negation-lead', self.rules(v2_record(statement={'en': 'No run returns.', 'zh': '无运行返回。'})))
        # a statement of which differences make a difference is the theorem's own relation, not a negation to lead away from
        self.assertNotIn('negation-lead', self.rules(v2_record(
            statement={'en': 'A fall of the level makes no difference to the way while the level meets the need.', 'zh': '水平满足所需时，其下降于其道无别。'})))
        self.assertNotIn('negation-lead', self.rules(v2_record(statement={'en': 'A run returns exactly when it is lossless.', 'zh': '运行恰在无损时返回。'})))

    def test_does_not_show_items_are_short(self):
        item = {'en': 'One. Two. Three.', 'zh': '一。二。三。', 'kind': 'scope'}
        found = [f for f in style.lint(v2_record(does_not_show=[item] * 9)) if f['field'].startswith('does_not_show')]
        self.assertEqual({f['rule'] for f in found}, {'item-count', 'one-sentence'})
        self.assertEqual({f['severity'] for f in found}, {'warning'})


class RatchetTests(unittest.TestCase):
    def test_ratchet_blocks_growth_of_v1_boundaries(self):
        old = v1_record()
        new = copy.deepcopy(old)
        new['limitations']['en'] += ' This round adds no new theorem and keeps every earlier boundary.'
        self.assertEqual([(f['rule'], f['severity']) for f in style.growth(old, new)], [('v1-growth', 'error')])
        new['schema_version'] = 2
        self.assertEqual(style.growth(old, new), [])

    def test_ratchet_only_warns_on_slight_growth(self):
        # A renamed identifier or a wording fix lengthens a field by a few characters.
        old = v1_record()
        new = copy.deepcopy(old)
        new['limitations']['en'] += ' (renamed)'
        self.assertEqual([(f['rule'], f['severity']) for f in style.growth(old, new)], [('v1-growth', 'warning')])

    def test_ratchet_reads_both_languages_and_allows_shrinking(self):
        old = v1_record()
        new = copy.deepcopy(old)
        new['correspondence']['zh'] += '另加一句。'
        new['limitations']['en'] = 'Discrete.'
        self.assertEqual([(f['field'], f['rule']) for f in style.growth(old, new)], [('correspondence', 'v1-growth')])

    def test_schema_2_may_not_return_to_schema_1(self):
        self.assertEqual([f['rule'] for f in style.growth(v2_record(), v1_record())], ['schema-downgrade'])

    def test_changed_record_is_compared_with_its_committed_bytes(self):
        records, _ = registry.load_records()
        path = str(registry.record_path(records[0]).relative_to(registry.ROOT))
        # Growth is measured against the committed bytes at the base revision.
        committed = json.loads(research.subprocess.check_output(['git', 'show', f'HEAD:{path}'], cwd=registry.ROOT))
        if committed.get('schema_version') != 1:
            self.skipTest('first record already migrated')
        record = dict(copy.deepcopy(committed), _record_path=path)
        self.assertEqual(research.ratchet([record], 'HEAD', {path}), [])
        record['validation_scope'] = {k: v + ' Another receipt paragraph, appended for this round of checks and its receipt.' for k, v in committed['validation_scope'].items()}
        found = research.ratchet([record], 'HEAD', {path})
        self.assertEqual({(f['field'], f['rule'], f['severity']) for f in found}, {('validation_scope', 'v1-growth', 'error')})

    def test_new_schema_1_record_is_a_warning(self):
        record = dict(v1_record(id='not-yet-committed-example'), _record_path='theories/becoming/results/records/not-yet-committed-example.json')
        found = research.ratchet([record], 'HEAD', {record['_record_path']})
        self.assertEqual([(f['rule'], f['severity']) for f in found], [('new-v1-record', 'warning')])


class MarketWordTests(unittest.TestCase):
    """Words of exchange: warned in schema-2 public fields and in spine declaration names."""

    def found(self, record):
        return [(f['field'], f['severity']) for f in style.lint(record) if f['rule'] == 'market-word']

    def test_schema_2_public_fields_warn_in_both_languages(self):
        r = v2_record(statement={'en': 'The reading credits each event at its cost.', 'zh': '读法以其代价记入每个事件。'})
        self.assertEqual(self.found(r), [('statement', 'warning'), ('statement', 'warning')])

    def test_schema_1_evidence_and_scientific_terms_are_not_warned(self):
        self.assertEqual(self.found(v1_record(claim={'en': 'The reading credits each event.', 'zh': '记入。'})), [])
        self.assertEqual(self.found(v2_record(validation_scope={'en': 'Paid receipts.', 'zh': '回执。'})), [])
        r = v2_record(statement={'en': "The counting form of Price's equation; credit assignment; the full account.",
                                 'zh': '生成本身承担要求；形成本身；完成本目标。'})
        self.assertEqual(self.found(r), [])

    def test_checker_uses_the_same_words(self):
        checker = load_checker()
        for word in checker.MARKET_WORDS:
            self.assertTrue(style.MARKET_EN.fullmatch(word), word)
        for word in ('cost', 'charged', 'budget', 'paid', 'pricing', 'spent', 'credited', 'fees', 'profit', 'funding'):
            self.assertIn(word, checker.MARKET_WORDS)

    def test_checker_reports_spine_names_outside_the_allowed_terms(self):
        checker = load_checker()
        registry_ = {'Becoming.Ranking': [{'name': 'Becoming.Ranking.stops_credited', 'kind': 'theorem'},
                                          {'name': 'Becoming.Ranking.pairDraw', 'kind': 'def'}],
                     'Becoming.Evolution': [{'name': 'Becoming.price', 'kind': 'theorem'}],
                     'Elsewhere': [{'name': 'Elsewhere.costOf', 'kind': 'def'}]}
        self.assertEqual(checker.market_names(registry_), {'Becoming.Ranking.stops_credited': ['credited']})
        self.assertEqual(checker.name_words('Becoming.LPOOf_x'), ['becoming', 'lpo', 'of', 'x'])


def load_checker():
    import importlib.util
    path = registry.ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/check_becoming.py'
    spec = importlib.util.spec_from_file_location('check_becoming_for_tests', path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


if __name__ == '__main__':
    unittest.main()
