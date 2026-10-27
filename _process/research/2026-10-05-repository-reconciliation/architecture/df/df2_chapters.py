#!/usr/bin/env python3
"""DF2: the chapter phase, after main is merged. Run once from the checkout root, after df2_apply_records.py and
df2_apply_records2.py: python3 -B <kit>/df2_chapters.py.

1. The drafters' chapter edits (reports/df2-draft-*.json), with the reviewers' corrections to them (reports/
   df2-pending.json: A2, A41, B47, C29, C47, D8, D10, D12, D22, D35) and without the optional renamings of landed text
   that state no wrong meaning (B31: equal-totals' two edits; the same rule drops succession's "fee" edit). Then the
   reviewers' own chapter edits (B44, C4, C5, C6, C40, D11, D23). Every old text must occur exactly once when its
   edit is applied.
2. One `<a id="r-<id>"></a>` per new record, found by its anchor text after the edits (A42, C30 and C47 shorten or
   change three), on its own line before the paragraph, or at the start of the first cell of a table row.
3. The drafters' edits to records outside their own (becoming-renewal-reading, row 36) and the related links that had
   to wait for both records (the-updater-line, what-a-summary-keeps), then significance-through-a-common-condition's
   aliases, which wait for becoming-renewal-reading's alias drop.
4. regions.json: the thirty records' entries, and least-loss-from-entropy-production's note."""
import json
import re
from pathlib import Path

ROOT = Path.cwd()
KIT = Path(__file__).resolve().parent
CH = ROOT / 'theories/becoming/chapters'
REC = ROOT / 'theories/becoming/results/records'
REG = ROOT / 'theories/becoming/results/data/regions.json'
DRAFTS = [r for u in 'ABCD' for r in json.loads((KIT / f'reports/df2-draft-{u}.json').read_text())['records']]
BY = {r['id']: r for r in DRAFTS}
assert len(BY) == 30

text = {}


def chapter(f):
    name = Path(f).name
    if name not in text:
        text[name] = (CH / name).read_text(encoding='utf-8')
    return name


def sub(f, old, new, tag):
    n = chapter(f)
    c = text[n].count(old)
    assert c == 1, (tag, n, c, old[:120])
    text[n] = text[n].replace(old, new)


def fix(s, old, new, tag):
    assert s.count(old) == 1, (tag, old, s[:200])
    return s.replace(old, new)


# 1. Corrections to the drafters' edits, keyed by (record, edit index).
def a2(s):
    return fix(s, "**Theorem** (any type; roster, fault envelopes, report law and protected monitor supplied; the core's "
                  "restatements of the correction modules, with empty axiom reports).",
               '**Theorem** (core restatement of the correction modules: numbered domains, listed envelopes and a '
               'supplied tree; roster, fault envelopes, faithfulness outside the actual fault set and coverage of the '
               'actual causes supplied; empty axiom reports).', 'A2')


def c29(s):
    P = {x['tag']: x for x in json.loads((KIT / 'reports/df2-pending.json').read_text())}
    return fix(s, P['C29']['old'], P['C29']['new'], 'C29')


def c47(s):
    head, para = s.split('\n\n')[0], s.split('\n\n')[1]
    assert s.endswith('\n\n<a id="yields"></a>'), 'C47'
    return fix(para, '**Theorem** (any process; the relational reading of a run; the separate witness).',
               '**Theorem** (any process; the whole-run reading of `living`; a witness for the unconnected case).', 'C47')


CORR = {
    ('certificates-sound-and-available', 0): a2,
    ('adaptive-closure-cannot-resolve', 0): lambda s: fix(s, '`propext` in some declarations, as its receipt reports;',
                                                          '`propext` in some declarations cited, as its receipt reports;', 'A41'),
    ('reviewers-count-by-independent-causes', 0): c29,
    ('reach-from-a-seed', 0): lambda s: fix(s, 'refuting every separation gives no path, and reaching a configuration needs one',
                                            'refuting every separation refutes only that the configuration is unreached, '
                                            'and reaching it needs a path', 'D8'),
    ('what-a-summary-keeps', 2): lambda s: fix(s, 'The access model and its witness are [knowing\'s]',
                                               "The access model's exact behaviour with the route fixed and its witness are [knowing's]", 'D10'),
    ('what-a-summary-keeps', 0): lambda s: fix(s, "the access witness on standard axioms, `propext` and `Quot.sound`, and the access model's laws on `propext`)",
                                               'the access witness on standard axioms, as is the access model: `propext` and `Quot.sound` in some declarations)', 'D12'),
    ('type-formation-gives-no-dynamics', 0): lambda s: fix(s, 'and keeps distinct seeds distinct.',
                                                           'and the diagonal keeps distinct elements of the seed distinct.', 'D22'),
    ('contraction-where-duplication-is-reachable', 1): lambda s: fix(s, 'acquire–release rounds return it to free for any finite number of rounds, and from free two acquisitions',
                                                                     'take–release rounds return it to free for any finite number of rounds, and from free two takes', 'D35'),
}
DROP = {('equal-totals-can-hide-what-a-capacity-carries', 1), ('equal-totals-can-hide-what-a-capacity-carries', 2),
        ('succession-on-a-funded-carrier', 1)}

applied = []
for r in DRAFTS:
    for i, e in enumerate(r['chapter_edits']):
        key = (r['id'], i)
        if key in DROP:
            applied.append(f'{r["id"]}[{i}] dropped')
            continue
        old, new = e['old'], e['new']
        new = new.replace('([Record](../results/records/', '([record](../results/records/')  # B47
        if key in CORR:
            new = CORR[key](new)
        if key == ('significance-through-a-common-condition', 0):  # C47: before the stepwise reading
            para = c47(e['new'])
            old, new = '<a id="r-becoming-stepwise-reading"></a>', para + '\n\n<a id="r-becoming-stepwise-reading"></a>'
        sub(e['file'], old, new, f'{r["id"]}[{i}]')
        applied.append(f'{r["id"]}[{i}]')

# The reviewers' own chapter edits.
EXTRA = [
    ('B44', '04-LIFE.md', 'need not invalidate judgment; under bounded drift',
     'need not invalidate judgment ([03](03-KNOWING.md#correction-is-not-calibration)); under bounded drift'),
    ('C4', '05-COLLECTIVES.md', 'the threshold is protected at the next step, with correction paid and no quality error, from every exposure `q` with `θ ≤ q ≤ 1`',
     'the accountability floor is kept at the next step, with correction paid and no error, from every accountability `q` with `θ ≤ q ≤ 1`'),
    ('C5', '05-COLLECTIVES.md', 'influence bound `λ` and threshold `θ`, let `M = α(1 − θ) − βλθ`',
     'influence bound `λ` and accountability floor `θ`, let `M = α(1 − θ) − βλθ`'),
    ('C6', '05-COLLECTIVES.md', 'coupled to the essential support the low end fails in finite time even with correction paid at every step (',
     'coupled to the essential support the low end fails in finite time even with correction paid at every step, while '
     'from the box about the maintenance end, with stock at least 5, the guarded history never fails '
     '(`high_coupled_history_never_fails`) ('),
    ('C40', '07-SIGNIFICANCE.md', 'and it does not agree on every pair of histories (`PracticalPriorityIdentification.finite_agreement_without_global_identification`)',
     'and no fixed weight agrees on every pair of histories (`PracticalPriorityIdentification.finite_agreement_without_global_identification`, '
     '`PracticalPriorityIdentification.no_fixed_finite_weight_is_lexical`)'),
    ('D11', '08-METHOD.md', '- An exact summary of feasibility cannot identify two configurations that differ on some finite word.',
     '- An exact summary of feasibility cannot identify two configurations that differ on some finite word '
     '(`feasible_difference_implies_projection_difference`). In the access model, a summary from which some reader '
     "reads off every word's feasibility separates occupancy throughout the permitted access set "
     '(`exact_reader_separates`); with every support permitted and the route fixed, every such encoding of occupancy is '
     'one to one (`unrestricted_reader_injective`).'),
    ('D23', '08-METHOD.md', 'So type formation alone yields no distinction and no occurrence.',
     'So type formation alone yields no element from an empty seed and no distinction from a seed with at most one element.'),
]
for tag, f, old, new in EXTRA:
    sub(f, old, new, tag)
    applied.append(tag)

# 2. Anchors.
ANCHOR = {r['id']: r['anchor_before'] for r in DRAFTS}
ANCHOR['composition-route'] = 'Composition route | **Theorem** ('  # A42
ANCHOR['reviewers-count-by-independent-causes'] = '**Theorem** (pure core, no axiom: members and causes numbered'  # C30
ANCHOR['significance-through-a-common-condition'] = '**Theorem** (any process; the whole-run reading of'  # C47
TAG = re.compile(r'^(<a id="[^"]+"></a>\n?)+')
for rid, a in ANCHOR.items():
    n = chapter('theories/becoming/chapters/' + BY[rid]['home'].split('chapters/')[-1].split(' ')[0].split(',')[0])
    s = text[n]
    assert f'id="r-{rid}"' not in s, rid
    assert s.count(a) == 1, (rid, n, s.count(a))
    p = s.index(a)
    m = TAG.match(a)
    q = p + (m.end() if m else 0)  # after any anchors the text begins with
    ls = s.rfind('\n', 0, q) + 1
    line = s[ls:s.find('\n', q)]
    tag = f'<a id="r-{rid}"></a>'
    if line.startswith('|'):
        assert re.fullmatch(r'\| (<a id="[^"]+"></a>)*', s[ls:q]), (rid, s[ls:q])
        text[n] = s[:q] + tag + s[q:]
    else:
        assert ls == q, (rid, 'mid-line', s[ls:q][:80])
        text[n] = s[:q] + tag + '\n' + s[q:]
    applied.append(f'anchor {rid} ({n})')

for n, s in text.items():
    (CH / n).write_text(s, encoding='utf-8')


# 3. Records.
def edit(rid, fn):
    p = REC / f'{rid}.json'
    d = json.loads(p.read_text(encoding='utf-8'))
    fn(d)
    p.write_text(json.dumps(d, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')


RE = {(r['id'], e['id'], e['field']): e for r in DRAFTS for e in r['record_edits']}
REN = 'significance-through-a-common-condition'


def renewal(d):
    g = lambda f: RE[(REN, 'becoming-renewal-reading', f)]
    for f in ('statement.en', 'statement.zh'):
        k = f.split('.')[1]
        assert d['statement'][k] == g(f)['old'], f
        d['statement'][k] = g(f)['new']
    for k in ('en', 'zh'):
        e = g(f'claim.{k}')
        assert d['claim'][k].count(e['old']) == 1, k
        d['claim'][k] = d['claim'][k].replace(e['old'], e['new'])
    assert d['aliases'] == json.loads(g('aliases')['old'])
    d['aliases'] = json.loads(g('aliases')['new'])
    assert d['hypotheses'][2] == json.loads(g('hypotheses[2]')['old'])
    del d['hypotheses'][2]
    assert d['counterexamples'][0] == json.loads(g('counterexamples[0]')['old'])
    del d['counterexamples'][0]
    d['history'].append({
        'en': '27 October 2026, board item DF2 (study section DF_N): the statement says what the record keeps, the '
              'run-class laws (every run a web the classes apply to, a falling natural observable does not recur, and '
              'from one configuration one run can renew and another consume); connection through a common condition '
              'and transmission along co-participation, with their hypothesis, counterexample and five aliases, moved '
              'to significance-through-a-common-condition, at home in 07 §3.1. The run-class laws are unchanged.',
        'zh': '2026年10月27日，工作板条目 DF2（研究第 DF_N 节）：陈述改为本记录所保留的运行类律（每次运行都是这些类所适用之网，'
              '下降的自然数可观测量不再复现，自同一配置一次运行可以更新、另一次可以消耗）；经共同条件的连通与沿共同参与的传递，'
              '连同其假设、反例与五个别名，移至 significance-through-a-common-condition，其家在 07 §3.1。运行类律不变。'})


edit('becoming-renewal-reading', renewal)


def related(src, rid, field='related'):
    e = RE[src]
    x = json.loads(e['new'].removeprefix('append ').strip()) if e['new'].startswith('append') else \
        json.loads(e['new'])[-1]
    def fn(d):
        assert x['id'] not in [y['id'] for y in d[field]], (rid, x['id'])
        d[field].append(x)
    edit(rid, fn)


related(('correction-is-not-calibration', 'the-updater-line', 'related'), 'the-updater-line')
related(('what-a-summary-keeps', 'what-a-summary-keeps', 'related'), 'what-a-summary-keeps')


def aliases(d):
    e = RE[(REN, REN, 'aliases')]
    assert d['aliases'] == json.loads(e['old'])
    d['aliases'] = json.loads(e['new'])


edit(REN, aliases)

# 4. Regions.
reg = json.loads(REG.read_text(encoding='utf-8'))
for r in DRAFTS:
    assert r['id'] not in reg['records'], r['id']
    reg['records'][r['id']] = r['regions']
LL = reg['records']['least-loss-from-entropy-production']
assert LL['note'] == 'T1 EntropyProduction: second law as first law'
LL['note'] = "T1 EntropyProduction: the second law gives the spine's first law"
reg['records'] = dict(sorted(reg['records'].items()))
REG.write_text(json.dumps(reg, indent=1, ensure_ascii=False) + '\n', encoding='utf-8')

print('df2_chapters: applied', len(applied))
for x in applied:
    print(' ', x)
