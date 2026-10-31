#!/usr/bin/env python3
"""U4's boundary record, `one-root-to-its-edge`: each central declaration's standing on the edge of one root, carried
by MV's `boundary` field (BOUNDARY-FIELD.md), with Becoming.RootForms' two root forms as the record's laws.

From the checkout root:
  python3 -B <dir>/make_record_u4.py --names           every entry with the names its review must give in code spans
  python3 -B <dir>/make_record_u4.py --draft OUT       the record without receipt or binding, for review
  python3 -B <dir>/make_record_u4.py RECEIPT STUDY     the record, bound to the core run's receipt; STUDY is the study
                                                       section of the landing

The standings come from the design (DESIGN-BOUNDARY.md, boundary-table.json's hand readings) and MV's probe (§6: the
eight derived rows' laws, bridges and support). Two rows depend on HE2's items 3 and 4: once GrammarLaws states
«所闭之逆», `Flow.mutuallyDependent_iff_reach` and `Flow.withinCoupling_reads_iff` are declared derived, cases of the
closure laws their model lemmas are now proved as; before, they are readings at connected, as the rule gives. The
generator checks nothing about the Lean: master_laws.py does (D1 to D6, the Lean check), and the landing requires its
four lists empty. Counts in the statement are computed from the standings and the rule's labels in boundary-table.json
and checked against master-laws.json's boundary report when it reads this record.
"""
import hashlib
import json
import os
import re
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/'
B = PKG + 'Becoming/'
RID = 'one-root-to-its-edge'
REC = f'theories/becoming/results/records/{RID}.json'
DEV = '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/u4-one-root-to-its-edge/'
MV = '_process/research/2026-10-05-repository-reconciliation/architecture/mv/'
REVIEW = DEV + 'REVIEW-U4-RECORD.md'
SOURCE = B + 'RootForms.lean'


def full(name):
    return name if name.startswith('Becoming.') else 'Becoming.' + name


def digest(path):
    return hashlib.sha256((ROOT / path).read_bytes()).hexdigest()


# The leaf's declarations, in source order.
LEAF = re.findall(r'^(?:theorem|def) (\S+)', (ROOT / SOURCE).read_text(encoding='utf-8'), re.M)
LEAF = ['Becoming.RootForms.' + n for n in LEAF]
assert len(LEAF) == len(set(LEAF)) == 42, len(LEAF)
R = lambda n: 'Becoming.RootForms.' + n
PARTS = [R(n) for n in ('everywhere', 'nowhere', 'allRelated', 'noneRelated', 'oneListed', 'oneOffspring')]
DESCENT = [n for n in LEAF if n.split('RootForms.')[1].split('.')[0] in (
    'GivenTo', 'Inherits', 'UndependedFrom', 'descent_forms_no_dependence', 'given_everywhere', 'inherits_vacuous',
    'inherits_everywhere', 'undepended_vacuous', 'undepended_nowhere', 'some_depends', 'no_new_dependence_at_model',
    'no_new_dependence_certified')]
ALL_END = [n for n in LEAF if n not in DESCENT]
assert len(DESCENT) == 18 and len(ALL_END) == 24 and set(PARTS) <= set(ALL_END)

# U4_HE2=1 forces the entries of HE2's state, for reviewing them before HE2 lands; the landing never sets it.
HE2 = os.environ.get('U4_HE2') == '1' or 'theorem «所闭之逆»' in (ROOT / (B + 'GrammarLaws.lean')).read_text(encoding='utf-8')

# The eight derived rows: MV's probe (BOUNDARY-FIELD.md §6), laws, bridges (equivalences) and support.
PROBE = json.loads((ROOT / (MV + 'boundary/probe.json')).read_text(encoding='utf-8'))['summary']['eight']
DERIVED_BASIS = {
    'Flow.beyond_gives_nothing':
        'A case of «所闭之界» at feeding from (FedFrom): what lies beyond a formation\'s closure is given nothing by '
        'it. FedFrom and FedBy unfold to the closure, and the support, eq_zero_of_not_pos, is one step of the '
        'prelude, a natural number not above nothing being nothing.',
    'Flow.withinSystem_of_withinInfluence':
        'A case of «所闭之单调» at being affected within sharing: Flow.shares_of_affectedBy, an unfolding, meets the '
        'law\'s inclusion, and WithinClosure.mono is the law at the frame\'s closure, applied past its conclusion.',
    'Law.drawn_iff_not_returns':
        'A case of «定后有后则入当且仅当不返» at the relation of the law\'s next configuration, its successor fixed '
        'and total. The bridges read the model\'s drawn, absorbing, orbit and return as the grammar\'s «入», closure, '
        '«及» and return, the orbit by recursion; the support is the orbit\'s arithmetic of steps, the trace\'s '
        'length and the successor\'s being fixed and total.',
    'Law.lossless_iff_returns':
        'A case of «有限遍后定后则定前当且仅当皆返» at the law\'s next configuration over the listed ones: lossless is '
        'the predecessor fixed (two bridges), and the other bridges and the support are those of '
        'Law.drawn_iff_not_returns.',
    'Learning.goAlike_iff_lumped':
        'A case of «像定后当且仅当同行» at the law\'s step along the projection, with «同行之逐点»: going alike under '
        'the projection is the grammar\'s «同行», and lumped is a fixed successor of the image, both unfoldings.',
    'Tolerance.answers_restores_iff':
        'A case of «承之迭» at the relation up: answering is «承» of up by definition, the model\'s chain is «迭» by '
        'recursion through «迭之末步», and the worst start instantiates the law\'s start; the support keeps inclusion '
        'along a course and takes the chain\'s last step.',
    'Withholding.withholding_spreads':
        'A case of «存承之迭» at up: waiting on all is closed by definition, and within n steps is the grammar\'s, '
        'through the chain read as «迭» by recursion; the support takes the chain\'s last step.',
    'WithinMoves.after_course':
        'A case of «迭内之接» at the moves\' steps: a trace and being within moves are the grammar\'s steps (two '
        'bridges), and that a trace gives steps is support.',
}
assert set(DERIVED_BASIS) == set(PROBE)


def derived(decl, laws, bridges, support, basis):
    e = {'declaration': full(decl), 'standing': 'derived', 'basis': {'en': basis}, 'review': REVIEW,
         'law': [full(n) for n in laws]}
    if bridges:
        e['bridges'] = [full(n) for n in bridges]
    if support:
        e['support'] = [full(n) for n in support]
    return e


def reading(decl, standing, basis, **extra):
    return {'declaration': full(decl), 'standing': standing, 'basis': {'en': basis}, 'review': REVIEW, **extra}


STANDINGS = [derived(d, [PROBE[d]['law']], PROBE[d]['bridges'], PROBE[d]['support'], DERIVED_BASIS[d])
             for d in sorted(PROBE)]

# HE2's items 3 and 4: the two rows whose model lemmas are proved as the closure laws.
if HE2:
    STANDINGS += [
        derived('Flow.mutuallyDependent_iff_reach', ['«所闭之逆»'], [], [],
                'A case of «所闭之逆», both ways: mutual dependence is every formation within every other\'s '
                'influence closure, being within reach is that closure read backward, and WithinClosure.converse, '
                'through which the row is proved, is the law at the frame (HE2, item 3).'),
        derived('Flow.withinCoupling_reads_iff', ['«借步之所闭在二所闭»', '«二所闭在借步之所闭»'], [],
                ['Flow.withinCoupling_reads', 'WithinClosure.of_reads', 'Flow.CoupledFrom.of_reads'],
                'A case of «借步之所闭在二所闭» one way and «二所闭在借步之所闭» the other: the coupling closure of o '
                'reading a\'s couplings is the closure through borrowed steps. Flow.CoupledFrom.of_reads splits a '
                'step of it into a step of the pool or one from a taken at o, which meets the first law\'s '
                'hypothesis; the row\'s hypothesis that a acts on a condition coupled into it puts a within o\'s '
                'closure, which meets the second\'s (HE2, item 4).'),
    ]
else:
    STANDINGS += [
        reading('Flow.mutuallyDependent_iff_reach', 'connected',
                'Exactly WithinClosure.converse at the influence closure, grammar-only in content but declared off '
                'the grammar; a case once «所闭之逆» is in GrammarLaws and WithinClosure.converse is proved as it '
                '(HE2, item 3). The rule gives the same.'),
        reading('Flow.withinCoupling_reads_iff', 'connected',
                'Its two halves are WithinClosure.of_reads and WithinClosureOf.to_reads, grammar-only in content '
                'but declared off the grammar, their hypotheses met by case splits on the model; a case once HE2\'s '
                'item 4 lands. The rule gives the same.'),
    ]

# Row 17: under a stated hypothesis, the root form at one step.
STANDINGS.append({
    'declaration': 'Becoming.GroupEnding.Flow.all_end', 'standing': 'under a stated hypothesis',
    'basis': {'en': 'The row is the root form at one step: giving is a member present at the step giving a positive '
                    'amount, the region is activity at the step, and the listing is the generation with its '
                    'offspring lists. That only active formations give meets the first hypothesis, and that descent '
                    'is giving meets the second, each by definitions alone; the next generation\'s size is the '
                    'length of the offspring lists\' join, by the family\'s definition. The row carries nothing '
                    'beyond the three hypotheses but these readings. Lever 2\'s witnesses at the model show that '
                    'the model does not meet each hypothesis automatically.'},
    'review': REVIEW,
    'form': R('outside_leaves_no_offspring'),
    'hypotheses': [
        {'hypothesis': R('GivesFrom'), 'countermodel': R('outside_leaves_no_offspring.needs_gate'),
         'fit': R('outside_leaves_no_offspring.gate_needed')},
        {'hypothesis': R('ListedWithin'), 'countermodel': R('outside_leaves_no_offspring.needs_descent'),
         'fit': R('outside_leaves_no_offspring.descent_needed')},
        {'hypothesis': R('Outside'), 'countermodel': R('outside_leaves_no_offspring.needs_outside'),
         'fit': R('outside_leaves_no_offspring.outside_needed')},
    ],
    'recovery': R('all_end_at_model'),
    'certificate': R('all_end_certified'),
})

# Row 5: a reading equal to the rule's label, with its relational part.
STANDINGS.append(reading(
    'Flow.no_new_dependence', 'balance in its statement',
    'Its statement writes balance out, an equation of the level with what is taken and given, so the rule places it '
    'here. Its relational part is the root form RootForms.descent_forms_no_dependence: the row is that form at its '
    'one relatum, certified by rfl. But the row meets the form\'s first hypothesis, that what comes to stand is given '
    'to, only through Flow.descends_of_comes, which is amount reasoning (balance and a rise from nothing give a '
    'positive giving), so its recovery fails the discharge condition and the row keeps its distance.',
    relational_part=R('descent_forms_no_dependence')))

GATE = ('The gate is stated on the root as inclusions, and each hypothesis that is not counting is witnessed at the '
        'model (lever 2); the conclusion compares sums of amounts over generations, which the grammar has no terms '
        'for.')
READINGS = [
    # below the grammar: laws of counting (lever 2's review, S2)
    ('CensusWebs.keep_pace', 'counting',
     'The counting law CountsAcross.keep_pace, for any predicate, at a web\'s arising and ceasing over a listing.'),
    ('Drift.falls_back', 'counting',
     'Courses of n binary draws, weighted, counted; reading the courses as drift is the model\'s hypothesis, not '
     'part of the statement.'),
    ('Listed.coming_of_ceasing', 'counting',
     'For any carrier, predicate and exact listing, ceasing without end needs coming to be without end; the '
     'statement unfolds to the prelude\'s Distinct and Init and names no amount.'),
    ('RelativePosition.rise_needs_fall', 'counting',
     'A rise and a fall counted over a list, by the commutativity of addition.'),
    ('SelectionLevels.levels_sized', 'counting',
     'Price\'s partition into selection within and among groups of any sizes: an identity of counting.'),
    ('SelectionTerm.covariation', 'counting', 'Price\'s covariance: an identity of counting.'),
    # amounts
    ('Flow.new_beyond_every', 'amounts',
     'Endless novelty concludes that a family gives more than it takes or is open, an imbalance of amounts; balance '
     'enters only the proof.'),
    ('Flow.selected_le', 'amounts', GATE),
    ('Flow.selection_within', 'amounts', GATE),
    ('Flow.transmitted_supported', 'amounts', GATE),
    ('SelectionTerm.Flow.support_moved_rises', 'amounts', GATE),
    ('SelectionTerm.Flow.support_not_lower', 'amounts', GATE),
    ('GroupEnding.Flow.rises_iff_inactive', 'amounts',
     'The gate and descent are stated on the root as two inclusions, but cancellation, and inactivity compared on '
     'sums of the trait, constrain amounts; its list facts are counting.'),
    ('SelectionLevels.rises_exact_iff_levels', 'amounts',
     'Cancellation, what transmission raises equal to what it lowers at each step, constrains amounts; its list '
     'facts are counting.'),
    ('Reproduction.Flow.number_within_take', 'amounts',
     'Dissipation on a family and an injection from births to given units bound a count within a take, an amount; '
     'dissipation is kept as a premise of the account.'),
    ('RegimeMargin.ends_iff_below', 'amounts',
     'A run of natural-number margins ends exactly below H + y: a comparison of amounts.'),
    ('RegimeMargin.Adjusted.ends_iff_below', 'amounts',
     'As RegimeMargin.ends_iff_below, with recent giving adjusted: a comparison of amounts.'),
    ('Web.Next.frontier_ends_drawn_first', 'amounts',
     'Optima end the condition drawn first, in natural-number levels and weighted sums.'),
    ('Web.frontier_breaks_below', 'amounts',
     'A coupling below what keeping forgoes, in natural-number worths and draws, breaks a dependence.'),
    ('Web.frontier_broken', 'amounts',
     'Optima of orders on natural-number levels and weighted draws break a dependence.'),
    ('Web.frontier_exhausts', 'amounts',
     'A weighting falling faster than levels rise leaves the level at nothing.'),
    ('Web.frontier_keeps_stepwise', 'amounts',
     'Optima keep a level stepwise, in natural-number levels and weighted sums.'),
    ('Web.frontier_rebuilds', 'amounts',
     'A level rising faster than the weighting falls is rebuilt, in natural-number levels and weights.'),
    ('responses_le_missBound', 'amounts', 'A bound of propagation on amounts, a law of its model.'),
    # laws of their models
    ('Direction.extension_iff_widens', 'at its model',
     'C\'s extension on the moves\' frame, a law of that model; its statement on a web\'s level paths is U3\'s, on '
     'its own carrier, and states another row.'),
    ('PartForms.goAlike', 'at its model',
     'A law of its model, the part carrying a law of its own; the image law only reads it.'),
    ('carried_iff_rising', 'at its model',
     'An exchange law carries exactly where the reading rises; the support is inside the existential, not kept.'),
    # free significance (07 §1)
    ('Web.paths_one_object', 'free significance',
     'It keeps significance free, as 07 §1 intends; its root form, paths_one_object_root, holds at the own-closure '
     'reading only (U3) and states less than the row.'),
    ('Web.widens_iff_retains_adds', 'free significance',
     'It keeps significance free, as 07 §1 intends; its root form, widens_iff_retains_adds_root, holds at the '
     'own-closure reading only (U3) and states less than the row.'),
    ('unrestricted_iff_livingSignificance', 'free significance',
     'The continuation condition read as living significance, significance free; its root form, '
     'noOutside_iff_paths_livingSignificance, holds at the own-closure reading only (U3). The condition itself is a '
     'premise of the ethics, listed apart.'),
]
STANDINGS += [reading(d, s, b) for d, s, b in READINGS]
assert len(STANDINGS) == len({e['declaration'] for e in STANDINGS}) == 42, len(STANDINGS)

PREMISES = [
    {'role': 'scope', 'name': {'en': 'the continuation condition', 'zh': '延续之条件'},
     'premise': 'Becoming.Unrestricted', 'not_entailed': 'Becoming.ReadsOnlyDynamics.not_entails',
     'basis': {'en': 'For anything, its continuation into the future has significance: the condition fixes scope, '
                     'whose losses count. No statement reading only the dynamics entails it. Its warrant is open, '
                     'and no warrant binding every possible mind is claimed (07 §3).'},
     'review': REVIEW},
    {'role': 'order', 'name': {'en': 'C, calling widening better', 'zh': 'C，谓扩大为更好'},
     'premise': 'Becoming.Comparison', 'not_entailed': None,
     'absent': {'en': 'No theorem shows that no statement reading only the dynamics entails Comparison with "better" '
                      'free; Comparison leaves "better" free as Unrestricted leaves significance free.'},
     'basis': {'en': 'What ranks lies in C alone: the condition by itself orders nothing. A reason for C is open '
                     'apart from the condition.'},
     'review': REVIEW},
]

# The rule's labels (boundary-table.json), for the counts.
TABLE = {r['declaration']: r for r in json.loads((HERE / 'boundary-table.json').read_text(encoding='utf-8'))['rows']}
LABELS = ['derived', 'under a stated hypothesis', 'counting', 'connected', 'witnessed at its model',
          'balance in its statement', 'amounts', 'at a represented model', 'own carrier', 'at its model',
          'free significance', 'unplaced']


def counts():
    placed = {e['declaration'].removeprefix('Becoming.'): e['standing'] for e in STANDINGS}
    c = dict.fromkeys(LABELS, 0)
    for d, row in TABLE.items():
        c[placed.get(d) or row['rule_would_give'] or row['standing']] += 1
    return c


def statement(c):
    """Short, as the record's style asks; the counts are in the home section and the generated standings section."""
    return {'en': 'Each central declaration stands in one place on the edge of one root: derived from grammar laws; '
                  'under a stated hypothesis, each needed; counting; or at a named distance, with its reason. None is '
                  'a premise: the ethics\' two, the condition for scope and C for order, are listed apart.',
            'zh': '每一中心声明立于一根之边上之一处：推出，为文法之律之例；在所述假设之下，为一根形，其每一假设皆必要；计数；'
                  '或在有名之距，各有其理。无一为前提：伦理之二前提，条件定范围、C 定序，另列。'}


def home(c):
    """08 §7's home section, before `known-results`: the standings with their counts, both premises named."""
    lean = '../../../' + SOURCE
    two = ('; and, since HE2 proved their model lemmas as `«所闭之逆»` and the laws of a closure through borrowed '
           'steps, `Flow.mutuallyDependent_iff_reach` and `Flow.withinCoupling_reads_iff`') if HE2 else ''
    rest = sum(c.values()) - c['derived'] - c['under a stated hypothesis'] - c['counting']
    word = lambda n: ['No', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten', 'Eleven',
                      'Twelve'][n] if n <= 12 else str(n)
    return ('<a id="r-one-root-to-its-edge"></a>\n'
            f"**Standings on the edge** (the central declarations). Each of the {sum(c.values())} distinct central "
            f"declarations stands in one place on the edge of one root. {word(c['derived'])} are derived, each a case of "
            'grammar laws through bridges checked in Lean as equivalences and support the review reads: the eight '
            'connected rows the reading took (`Flow.beyond_gives_nothing`, `Law.drawn_iff_not_returns`, '
            f'`Learning.goAlike_iff_lumped` and five more){two}. One, `GroupEnding.Flow.all_end`, is under a stated '
            'hypothesis: it is the root form `RootForms.outside_leaves_no_offspring` at one step, each of the form\'s '
            'three hypotheses needed by a countermodel over one point and met at the model by definitions alone, the '
            f"recovery certified by `rfl`. {word(c['counting'])} are counting, below the grammar. The other {rest} stand at "
            f"a named distance, each with its reason: {c['connected']} connected, reaching grammar laws without being "
            f"declared a case of one; {c['balance in its statement']} with balance in their statements, among them "
            '`Flow.no_new_dependence`, whose relational part is the root form `RootForms.descent_forms_no_dependence` '
            "(it meets the form's first hypothesis only through amount reasoning); "
            f"{c['amounts']} on amounts; {c['at a represented model']} at a represented model and {c['own carrier']} "
            f"on their own carrier, by F5's verified items; {c['at its model']} laws of their models; and "
            f"{c['free significance']} keeping significance free, as chapter 7 intends. None is a premise. The ethics "
            'rests on two premises with two roles, listed apart: the continuation condition (`Unrestricted`) for '
            'scope, which no statement reading only the dynamics entails (`ReadsOnlyDynamics.not_entails`), and C '
            '(`Comparison`) for order, with no such theorem. Neither is shown stated on the root, so no premise stands '
            'on the edge. `master_laws.py` checks every entry on the core run '
            f'([record](../results/records/{RID}.md); [Becoming.RootForms]({lean})).\n')


LAWS = [
    {'en': 'Where giving lies within giving from a region and listed descent within giving, a listing wholly '
           'outside the region has no listed offspring (RootForms.outside_leaves_no_offspring); over one point, each '
           'hypothesis dropped, the conclusion fails. GroupEnding.Flow.all_end is this form at one step, each '
           'hypothesis met by definitions alone (RootForms.all_end_at_model, certified by rfl).',
     'zh': '给予在出自一域之给予之内、所列之传在给予之内处，全在该域外之一列无所列之后代（RootForms.outside_leaves_no_offspring）；'
           '于单点处去任一假设，结论不成。GroupEnding.Flow.all_end 即此根形于一步之处，各假设唯由定义满足。',
     'declarations': ALL_END},
    {'en': 'Where what comes to stand is given to, dependence is inherited along descent and nothing descended from '
           'depends before a step, nothing coming to stand depends after it (RootForms.descent_forms_no_dependence), '
           'none of the three redundant. Flow.no_new_dependence is this form at its relatum, but meets "given to" '
           'only through amount reasoning, so the form is its relational part.',
     'zh': '来立者皆有所给、依赖沿传而承、所传自者无一于步前依赖处，来立者无一于步后依赖'
           '（RootForms.descent_forms_no_dependence），三者无一冗余。Flow.no_new_dependence 即此根形于其关系项处，'
           '然满足「有所给」唯经量之推理，故此根形为其关系之部。',
     'declarations': DESCENT},
]


def record(receipt=None, study=None, reviewed=None):
    c = counts()
    refs = [{'path': SOURCE, 'role': 'proof', 'declarations': LEAF, 'sha256': digest(SOURCE)}]
    if receipt:
        data = json.loads((ROOT / receipt).read_text(encoding='utf-8'))
        assert data['status'] == 'passed' and data['source_sha256']['Becoming.RootForms'] == digest(SOURCE), receipt
        refs.append({'path': receipt, 'role': 'receipt', 'sha256': digest(receipt), 'declarations': []})
    for path, role in [(REVIEW, 'review'), (DEV + 'REVIEW-U4-BOUNDARY.md', 'review'),
                       (DEV + 'REVIEW-U4-BOUNDARY-SECOND.md', 'review'), (DEV + 'DESIGN-BOUNDARY.md', 'integration'),
                       (DEV + 'LEVER-2-AUDIT.md', 'integration'), (DEV + 'CONNECTED-ROWS-READING.md', 'integration'),
                       (MV + 'BOUNDARY-FIELD.md', 'integration'), ('theories/becoming/chapters/08-METHOD.md', 'statement')]:
        if (ROOT / path).is_file():
            refs.append({'path': path, 'role': role, 'sha256': digest(path), 'declarations': []})
    now = reviewed or datetime.now(timezone.utc).replace(microsecond=0).isoformat()
    day = datetime.fromisoformat(now)
    r = {
        'schema_version': 2,
        'id': RID,
        'title': {'en': 'One root to its edge: where each central declaration stands',
                  'zh': '一根至其边：各中心声明之所立'},
        'kind': 'theorem',
        'status': 'recorded-checked' if receipt else 'open',
        'family': 'F01',
        'reviewed_at_utc': now,
        'statement': statement(c),
        'laws': LAWS,
        'hypotheses': [
            {'en': 'The standings are of the distinct central declarations of COVERAGE.json at the core run the '
                   'receipt names; a declaration added later takes the rule\'s label until the record places it.',
             'zh': '所立者为收据所名之核心运行时 COVERAGE.json 之相异中心声明；后增之声明取规则之标，直至此记录置之。'},
            {'en': 'The root forms range over relations, regions and finite lists on any carrier; offspring are '
                   'listed, as the row lists them.',
             'zh': '根形遍及任何载体上之关系、域与有限列表；后代为所列者，如此行所列。'},
            {'en': '"Derived" rests on the review\'s reading that each row applies its laws as the case, which the '
                   'checks bound but do not show; readings rest on the review.',
             'zh': '「推出」立于审阅之读：各行以其律为其例而用之，检验限之而不示之；读法立于审阅。'},
        ],
        'does_not_show': [
            {'kind': 'non-implication',
             'en': 'That a row under a stated hypothesis uses the grammar\'s laws: neither root form reaches one. A '
                   'form shows that the row\'s conclusion follows from its hypotheses read as relations.',
             'zh': '在所述假设下之行用文法之律：二根形皆不及之。根形示此行之结论由其假设（读作关系）而得。'},
            {'kind': 'scope',
             'en': 'That the countermodels show more than that no hypothesis of a form is redundant: they are over one '
                   'point. Lever 2\'s witnesses at the model stay beside them.',
             'zh': '反模型示根形之假设无一冗余以上之事：其在单点之上。第二杠杆于模型处之见证并存。'},
            {'kind': 'non-implication',
             'en': 'That either premise of the ethics is warranted: the continuation condition is not entailed by '
                   'the dynamics, and C has no such theorem; the warrant of each is open.',
             'zh': '伦理之二前提有其据：延续之条件不为动力所蕴涵，C 无此定理；二者之据皆开放。'},
            {'kind': 'scope',
             'en': 'That a distance is a gap or a failure: each row at a distance has its reason, and the measure '
                   'records dependence, not meaning.',
             'zh': '距即缺或败：每一在距之行各有其理，度量记依赖，不记意义。'},
        ],
        'counterexamples': [
            {'path': SOURCE,
             'detail': {'en': 'Over one point, each hypothesis of each root form dropped, the conclusion fails '
                              '(RootForms.outside_leaves_no_offspring.needs_gate, needs_descent, needs_outside; '
                              'RootForms.descent_forms_no_dependence.needs_given, needs_inherits, needs_undepended).',
                        'zh': '于单点处，各根形之各假设去之，结论不成。'}}],
        'standard_boundaries': ['no-ethical-premise', 'no-evaluation', 'formal-not-empirical', 'names-provisional'],
        'validation_scope': {
            'en': 'Pure core, every axiom report empty: Becoming.RootForms imports Grammar, Transmission and '
                  'GroupEnding, and its forms name only grammar terms, Init and their own hypotheses. master_laws.py '
                  'checks the standings on the core run: derived entries by D1 to D6 on the dump and in Lean, the '
                  'entry under a stated hypothesis by boundary_check.lean\'s nine tests, the premises by Q1, readings '
                  'of computed labels against the rule\'s facts. The landing requires none unverified, unplaced or '
                  'unmatched.',
            'zh': '纯核，每一公理报告皆空：Becoming.RootForms 导入 Grammar、Transmission 与 GroupEnding，其根形唯名文法之词、'
                  'Init 与其自身之假设。master_laws.py 于核心运行上验诸所立：推出之条目以 D1 至 D6 于转储与 Lean 中验，'
                  '在所述假设下之条目以 boundary_check.lean 之九试验，前提以 Q1 验，所计之标之读法对照规则之事实。'
                  '落地要求无未验、无未置、无未合。'},
        'next_delta': {
            'en': 'A root form for the census rows; a theorem that no statement reading only the dynamics entails C; '
                  'the root reading of significance that chapter 7 leaves open, for the three rows keeping it free; '
                  'HE2\'s laws read as cases at more connected rows.',
            'zh': '清点诸行之根形；无一仅读动力之陈述蕴涵 C 之定理；第七章所留之意义根读，为保意义自由之三行；于更多相连之行读 HE2 之律为其例。'},
        'correspondence': {
            'en': 'Reverse mathematics in kind: each theorem placed by what it needs, with countermodels showing each '
                  'hypothesis needed (Friedman 1975; Simpson 2009). Here the base is a grammar of relations and the '
                  'measure is dependence in the compiled terms, not provability over a base system.',
            'zh': '类于逆数学：每一定理依其所需而置，以反模型示各假设之必要（Friedman 1975；Simpson 2009）。此处之基为关系之文法，'
                  '度量为编译项中之依赖，非于一基系统上之可证。'},
        'canonical_source': SOURCE,
        'aliases': ['one root to its edge', '一根至其边', 'standings on the edge', '边上之所立',
                    'Becoming.RootForms.outside_leaves_no_offspring', 'Becoming.RootForms.descent_forms_no_dependence'],
        'dependencies': [
            {'id': 'master-laws-on-the-grammar', 'relation': 'formal-reuse',
             'detail': {'en': 'The grammar laws the derived rows are cases of, and the measure that gives the rule its '
                              'reach.',
                        'zh': '推出之行所为其例之文法之律，及予规则以所及之度量。'}}],
        'related': [
            {'id': 'selection-among-groups-by-ending',
             'detail': {'en': 'GroupEnding.Flow.all_end, row 17, under a stated hypothesis here.',
                        'zh': 'GroupEnding.Flow.all_end，第 17 行，此处在所述假设之下。'}},
            {'id': 'transmission-is-inheritance-and-need',
             'detail': {'en': 'Flow.no_new_dependence, row 5, at balance in its statement, with its relational part '
                              'here.',
                        'zh': 'Flow.no_new_dependence，第 5 行，于其陈述中有平衡，其关系之部在此。'}}],
        'references': refs,
        'proof_bindings': ([{'source': SOURCE, 'receipt': receipt, 'sha256_pointer': '/source_sha256/Becoming.RootForms',
                             'success_pointer': '/status', 'success_value': 'passed'}] if receipt else []),
        'history': [{'en': f'{day.day} {day:%B %Y}, board item U4 (study section {study or "…"}): added, each central '
                           'declaration\'s standing on the edge of one root, carried by MV\'s boundary field, with '
                           'Becoming.RootForms\' two root forms as its laws; reviewed independently before landing.',
                     'zh': f'{day.year}年{day.month}月{day.day}日，工作板条目 U4（研究第 {study or "…"} 节）：增，各中心声明'
                           '于一根之边上之所立，由 MV 之 boundary 字段所载，以 Becoming.RootForms 之二根形为其律；落地前经独立审阅。'}],
        'boundary': {'standings': STANDINGS, 'premises_of_the_ethics': PREMISES},
    }
    return r, c


def names():
    """Each entry and the names its review must give in code spans (BOUNDARY-FIELD.md §2)."""
    out = []
    for e in STANDINGS:
        given = [e['declaration']] + e.get('law', []) + e.get('bridges', []) + e.get('support', [])
        if 'form' in e:
            given += [e['form'], e['recovery'], e['certificate']] + [h[k] for h in e['hypotheses']
                                                                      for k in ('hypothesis', 'countermodel', 'fit')]
        if 'relational_part' in e:
            given.append(e['relational_part'])
        out.append((e['standing'], [n.removeprefix('Becoming.') for n in given]))
    for p in PREMISES:
        out.append(('premise, ' + p['role'], [n.removeprefix('Becoming.') for n in (p['premise'], p['not_entailed']) if n]))
    return out


if __name__ == '__main__':
    if sys.argv[1] == '--names':
        for standing, ns in names():
            print(f'- {standing}: ' + ', '.join(f'`{n}`' for n in ns))
        print('counts:', counts(), '\nHE2 laws on this checkout:', HE2)
    elif sys.argv[1] == '--home':
        print(home(counts()))
    elif sys.argv[1] == '--draft':
        r, c = record()
        Path(sys.argv[2]).write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
        print('draft written; counts', c)
    else:
        receipt, study = sys.argv[1], sys.argv[2]
        r, c = record(receipt, study)
        (ROOT / REC).write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
        print(f'written {REC}; counts', c)
