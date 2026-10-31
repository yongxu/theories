#!/usr/bin/env python3
"""U1b's landing, after the core run (the leaf, Becoming.UnitMatchings, is already on the branch at its package path,
with its import in Becoming.lean after SelectionReach, its L1 note after Undecided's, its README rows and its place in
the checker's core list after Undecided, with its scope sentence):

  python3 -B <dir>/integrate_u1b.py record RECEIPT STUDY   08 §3's receipt sentence, every count read from the receipt;
                                                           01 §8.6's home section (home-01-section-8-6.txt, inserted
                                                           after the World's representation); regions.json's two
                                                           entries; then the record amounts-by-unit-matchings, bound to
                                                           the receipt and hashing the chapter with its home in place
  python3 -B <dir>/integrate_u1b.py register LOG           the apart register, from THEOREM-CONNECTIVITY.py --check's
                                                           log: the leaf's roots with their reasons (REASONS below); a
                                                           root of the leaf with no reason stops it; others printed
  python3 -B <dir>/integrate_u1b.py check                  after master_laws.py: the data is the landing run's, reads the
                                                           record's four laws as they stand, and U4's boundary report
                                                           and the central figures are unchanged from the merged main
  python3 -B <dir>/integrate_u1b.py study N RECEIPT        the study's section N (the next free one), from the receipt

Run from the checkout root of the landing worktree, in that order (record, master_laws.py, check, register with the
connectivity write, study). Each edit asserts that it applies exactly once, or that it is already applied, so a stage
can be rerun after main moves. After it: render, check --strict-fresh, links, the record's lint, tests.
"""
import importlib.util
import json
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location('make_record_u1b', HERE / 'make_record_u1b.py')
mr = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mr)

HOME = ROOT / mr.CHAPTER
METHOD = ROOT / 'theories/becoming/chapters/08-METHOD.md'
REGIONS = ROOT / 'theories/becoming/results/data/regions.json'
MASTER = 'theories/becoming/results/data/master-laws.json'
COVERAGE = ROOT / 'theories/becoming/results/completion/COVERAGE.json'
APART = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/THEOREM-CONNECTIVITY-APART.json'
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
SECTION = (HERE / 'home-01-section-8-6.txt').read_text(encoding='utf-8')
ANCHOR = '\n<a id="r-amounts-by-unit-matchings"></a>\n'
# The World's representation and its "What is not shown" list end §8.6; the section goes right after them.
AFTER = '<a id="r-the-world-represented-both-ways"></a>\n'
BEFORE = '\n<a id="test-systems"></a>\n### 8.7 Test systems of the source texts\n'
DEVLINK = 'development/u1-balance-under-units/'


# 08 §3's sentence naming the core receipt and its counts (U4's integrate_u4.py, the same pattern): UnitMatchings
# joins the core, so the landing's own receipt replaces the earlier one.
SENTENCE = re.compile(
    r"At core receipt \[`[0-9TZ.]+`\]\([^)]*\) \(Lean 4\.29\.1\), the closure held \d+ modules \(\d+ foundation, "
    r"\d+ core, \d+ in the instance and application ring\) and [\d,]+ theorems; the \d+ core modules held [\d,]+ of "
    r"them; [\d,]+ declarations were audited; \d+ generated `injEq` lemmas depend on `propext`; \d+ superseded "
    r"modules were kept out of the run\.")


def receipt_sentence(receipt):
    r = json.loads((ROOT / receipt).read_text(encoding='utf-8'))
    assert r['status'] == 'passed'
    mr.receipt_module(receipt)
    stamp = Path(receipt).parent.name
    layers = {}
    for m in r['modules']:
        count = layers.setdefault(m['layer'], [0, 0])
        count[0] += 1
        count[1] += m['theorems']
    assert set(layers) <= {'foundation', 'core', 'instance', 'application'}, set(layers)
    modules = sum(v[0] for v in layers.values())
    theorems = sum(v[1] for v in layers.values())
    assert modules == len(r['core_closure']), (modules, len(r['core_closure']))
    ring = layers.get('instance', [0, 0])[0] + layers.get('application', [0, 0])[0]
    declarations = sum(len(m['declarations']) for m in r['modules'])
    injeq = sum(1 for name, axioms in r['generated_axiom_dependencies'].items()
                if name.endswith('.injEq') and axioms == ['propext'])
    assert injeq == len(r['generated_axiom_dependencies']), 'a generated dependency other than injEq on propext'
    link = '../../../' + receipt
    counts = (f"At core receipt [`{stamp}`]({link}) (Lean 4.29.1), the closure held {modules} modules "
              f"({layers['foundation'][0]} foundation, {layers['core'][0]} core, {ring} in the instance and application "
              f"ring) and {theorems:,} theorems; the {layers['core'][0]} core modules held {layers['core'][1]:,} of them; "
              f"{declarations:,} declarations were audited; {injeq} generated `injEq` lemmas depend on `propext`; "
              f"{len(r['superseded_modules'])} superseded modules were kept out of the run.")
    text = METHOD.read_text(encoding='utf-8')
    text, k = SENTENCE.subn(lambda m: counts, text)
    assert k == 1, k
    METHOD.write_text(text, encoding='utf-8')
    print('08 §3:', counts[:160], '…')


def home():
    text = HOME.read_text(encoding='utf-8')
    if ANCHOR in text:
        assert SECTION in text, 'a different home section is in place: remove it and rerun'
        print('01 §8.6: the home section is already in place')
        return
    assert text.count(AFTER) == 1 and text.count(BEFORE) == 1 and text.index(AFTER) < text.index(BEFORE), \
        "01 §8.6 no longer ends with the World's representation before §8.7: place the section by hand"
    HOME.write_text(text.replace(BEFORE, '\n' + SECTION + BEFORE), encoding='utf-8')
    print('01 §8.6: the home section inserted after the World\'s representation')


def regions():
    data = json.loads(REGIONS.read_text(encoding='utf-8'))
    # Region: the chapter of the home section (01, the root). Base: what the laws state, read as the file's "about"
    # defines bases: every law but crossing_edge is stated on a Flow over a Web (old-base); the grammar enters as the
    # pairing «对» the exchange laws quantify over, as WRT2's World laws use the grammar for their lemmas.
    data['records'][mr.RID] = {
        'region': 'root', 'base': 'old-base',
        'note': "UnitMatchings U1b: amounts, the root's second sort, by their interface: balance represented by "
                "selected frame matchings, both ways; the crossing laws at a rise; the residual counts and dissipation; "
                "not derived, the residual units accounting"}
    data['modules'][mr.MODULE] = {
        'region': 'root', 'base': 'old-base',
        'note': "U1b: the interface of amounts by selected unit matchings (01 §8.6): FrameMatch, "
                "frameMatchings_iff_balances, crossing_edge, rise_crossing_weak/strong, endings_count"}
    for key in ('records', 'modules'):
        data[key] = dict(sorted(data[key].items()))
    REGIONS.write_text(json.dumps(data, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
    print('regions: the record and the module, region root, base old-base')


def record(receipt, study):
    receipt_sentence(receipt)
    home()
    regions()
    r = mr.record(receipt, study)
    (ROOT / mr.REC).write_text(json.dumps(r, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    print('record', mr.REC, 'bound to', receipt)


# The leaf's theorems expected to stand apart (used by no theorem on the base), with their reasons. Every other
# theorem of the leaf states a Flow or a Web, or is used by one that does (FrameMatch.le and .eq by
# FrameMatchings.balances, crossing_edge by the two rise laws, the two length lemmas by the rise and residual laws).
REASONS = {
    'Becoming.UnitMatchings.FrameMatch.predecessor_unique': (
        'support', "UnitMatchings.FrameMatch.predecessor_unique: a one-line unpacking of FrameMatch's own fields "
                   "(bwd_fwd): an out-position has one in-position the selected matching sends to it, «定前» at a "
                   "frame; the record amounts-by-unit-matchings cites it in its first law"),
}


# Grammar laws whose register entry said nothing on the base used them, and which the leaf uses (crossing_edge reads
# its pairing backward through «对之逆»).
NOW_USED = {'Becoming.«对之逆»'}


def register(log_path):
    t = APART.read_text(encoding='utf-8')
    log = Path(log_path).read_text(encoding='utf-8')
    m = re.search(r"apart roots without a reason in [^:]+: (\[[^\]]*\])", log)
    listed = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
    block, others, unknown = '', [], []
    for name in listed:
        if not name.startswith('Becoming.UnitMatchings.'):
            others.append(name)
            continue
        if name not in REASONS:
            unknown.append(name)
            continue
        if json.dumps(name, ensure_ascii=False) in t:
            continue
        cat, why = REASONS[name]
        block += ('  ' + json.dumps(name, ensure_ascii=False) + ': {\n   "module": "Becoming.UnitMatchings",\n'
                  '   "category": "' + cat + '",\n   "reason": ' + json.dumps(why, ensure_ascii=False) + '\n  },\n')
    assert not unknown, ('roots of the leaf with no reason: add each to REASONS, read from its statement', unknown)
    if block:
        anchor = '  }\n },\n "instances": {'
        assert t.count(anchor) == 1
        t = t.replace(anchor, '  },\n' + block.rstrip(',\n') + '\n },\n "instances": {')
        json.loads(t)
        APART.write_text(t, encoding='utf-8')
    # A grammar law the leaf now uses is no longer an apart root: its register entry, whose reason said nothing on
    # the base used it, goes. Only the laws named in NOW_USED may go this way; any other stops for its owner's reading.
    m = re.search(r"register entries no longer apart roots: (\[[^\]]*\])", log)
    gone = [] if not m else [s.strip().strip("'\"") for s in m.group(1).strip('[]').split(',') if s.strip()]
    unexpected = [g for g in gone if g not in NOW_USED]
    assert not unexpected, ('register entries no longer apart roots that this leaf does not explain', unexpected)
    t = APART.read_text(encoding='utf-8')
    d = json.loads(t)
    dropped = [g for g in gone if g in d['roots']]
    for g in dropped:
        start = t.index('  ' + json.dumps(g, ensure_ascii=False) + ': {\n')
        end = t.index('\n  },\n', start) + len('\n  },\n')
        t = t[:start] + t[end:]
    if dropped:
        after = json.loads(t)
        assert all(g not in after['roots'] for g in dropped) and len(after['roots']) == len(d['roots']) - len(dropped)
        APART.write_text(t, encoding='utf-8')
    print('dropped', len(dropped), 'register entries the leaf now uses:', ', '.join(dropped) or 'none')
    print('registered', block.count('"module"'), 'roots of the leaf;', 'expected', sorted(REASONS))
    if others:
        print("roots not the leaf's, for their owners:", ', '.join(others))


def head_master():
    """master-laws.json as the merged main has it (the landing worktree's HEAD, before the landing commit)."""
    out = subprocess.run(['git', 'show', 'HEAD:' + MASTER], capture_output=True, text=True, check=True).stdout
    return json.loads(out)


def check():
    data = json.loads((ROOT / MASTER).read_text(encoding='utf-8'))
    before = head_master()
    problems = []
    verification = json.loads((ROOT / mr.PKG / 'becoming-verification.json').read_text(encoding='utf-8'))
    if data.get('from_dump') or data.get('core_receipt') != verification.get('utc'):
        problems.append(('the data is not the landing run\'s', data.get('core_receipt'), verification.get('utc')))
    # The record's four laws, read as they stand (else the data no longer matches them and the page shows nothing).
    rec = json.loads((ROOT / mr.REC).read_text(encoding='utf-8'))
    laws = data.get('records', {}).get(mr.RID)
    if not laws:
        problems.append(('the data has no entry for the record', mr.RID))
    else:
        mine = [law['declarations'] for law in rec['laws']]
        theirs = [law.get('declarations') for law in laws]
        if mine != theirs:
            problems.append(('the data does not match the record\'s laws', len(mine), len(theirs)))
        for i, law in enumerate(laws, 1):
            print(f"law {i}: master laws {law.get('master_laws')}, grammar {law.get('grammar')}, "
                  f"dependence {law.get('dependence')}")
    # No central declaration is the leaf's, so U4's boundary record needs no new entry, and nothing it placed moves.
    central = {d for row in json.loads(COVERAGE.read_text(encoding='utf-8'))['rows'] for d in row.get('declarations', [])}
    if central & set(mr.LEAF):
        problems.append(('a declaration of the leaf is central: U4\'s boundary record must place it', central & set(mr.LEAF)))
    b = data.get('boundary') or {}
    if b.get('record') != 'one-root-to-its-edge' or b.get('field_failures') or b.get('unverified'):
        problems.append(('the boundary report', b.get('record'), b.get('field_failures'), b.get('unverified')))
    unplaced = [d for d, row in (b.get('rows') or {}).items() if row.get('label') == 'unplaced']
    if unplaced:
        problems.append(('unplaced', unplaced))
    if not b.get('lean_check', {}).get('ran'):
        problems.append(('the Lean check did not run', b.get('lean_check')))
    for key, now, then in [('boundary counts', b.get('counts'), (before.get('boundary') or {}).get('counts')),
                           ('central reach', (data.get('central_reach') or {}).get('counts'),
                            (before.get('central_reach') or {}).get('counts')),
                           ('counts at a model', data.get('counts_at_model'), before.get('counts_at_model')),
                           ('counts at the boundary record', data.get('counts_at_boundary_record'),
                            before.get('counts_at_boundary_record'))]:
        if now != then:
            problems.append((key + ' changed', then, now))
    grown = {k: (before['counts'].get(k), v) for k, v in data['counts'].items() if before['counts'].get(k) != v}
    print('record-law counts, main -> landing (only the new record\'s four laws should add):', grown)
    if data['counts']['laws'] != before['counts']['laws'] + len(rec['laws']):
        problems.append(('law count', before['counts']['laws'], data['counts']['laws']))
    for p in problems:
        print('PROBLEM', p)
    assert not problems
    print('master laws read the record; the boundary report and the central figures are as on main:',
          b.get('counts'), (data.get('central_reach') or {}).get('counts'))


def study(n, receipt):
    """The study's section N (the next free one), from the landing's receipt."""
    text = STUDY.read_text(encoding='utf-8')
    title = '## {}. Amounts by unit matchings: U1\'s interface in the package (U1b)'
    if title.format(n) in text:
        print('study §', n, 'already in place')
        return
    free = max(int(x) for x in re.findall(r'^## (\d+)\. ', text, re.M)) + 1
    assert int(n) == free, ('the next free section is', free)
    m = mr.receipt_module(receipt)
    stamp = Path(receipt).parent.name
    section = f"""{title.format(n)}

Board item U1b, the release gate's item 3, its last part: U1's limited interface for amounts, the root's second sort, reviewed in [U1's design]({DEVLINK}DESIGN.md) (§2, the established interface; §3 and §5, what failed) and until now in scratch only, ported into one core leaf with structural names. What the package already states (the census form of balance, the stretch law) is cited, not restated. A cross-model reader reviewed the leaf and rechecked it, every finding taken ([the review]({DEVLINK}u1b/REVIEW-U1B.md)).

```text
Result(s): amounts-by-unit-matchings (new, home 01 §8.6, after the-world-represented-both-ways). Reused:
       master-laws-on-the-grammar («对», «对之逆», «对之取», «对之长», «聚之长», GrammarLaws.revisits_within),
       a-rise-past-the-inflow-is-drawn-from-beyond (Flow.Balances.rise_draws_beyond_inflow), census form
       Flow.balances_iff_units and «对之程» cited.
Delta:
  - Frame matchings, both ways: a selected matching of a frame (FrameMatch), a bijection given as data, forces
    equal counts by pigeonhole through GrammarLaws.revisits_within, with no decidability (FrameMatch.le, .eq);
    each out-position has one in-position sent to it (FrameMatch.predecessor_unique); a flow over a web has one
    at every step and condition exactly where it balances, the converse by position (frameMatchings_iff_balances);
    a standing unit goes on standing or is taken, which being the matching's (FrameMatchings.next).
  - The crossing laws: a longer first block on one side of a one-to-one pairing has a member of the other side's
    rest related to it (crossing_edge, constructive); in a balanced flow, a family listed without repetition rising
    past the inflow of a family containing it, one formation taking part relates at every pairing of its exchange
    a unit it gives the risen family to another input (rise_crossing_weak), to one taken from the rest where
    beyond's inputs are source-minimal (rise_crossing_strong).
  - The residual counts: beyond's units source-minimal, every pairing's endings number taken beyond given
    (endings_count), leaving and endings together where leaving outputs are kept (leaving_and_endings_count);
    on a family a present formation dissipates on the source-minimal count is zero and the residual count positive
    where it takes, and lossless storage through it is excluded (source_minimal_zero_of_dissipates,
    residual_pos_of_dissipates, lossless_not_dissipative).
Supplied premises / correspondence: none beyond the hypotheses of each theorem. Modelling choices: natural-number
       amounts in one unit commensurable across conditions, discrete steps, positions as numbers below a count, a
       family as a list of conditions, formations counted with their multiplicity among those present; the exchange
       lists are any lists of exchange occurrences.
Evidence: core receipt `{stamp}`; Becoming.UnitMatchings ({m['theorems']} theorems in {len(m['declarations'])} declarations),
       a core leaf importing GrammarLaws, Flow, SelectionReach and Undecided, nothing importing it; every axiom
       report empty. master_laws.py on that run reads the record's four laws, and U4's boundary report and the
       central figures are unchanged (no central declaration is the leaf's).
Standing: near-definitional; pigeonhole and counting at one formation, none of it claimed new as mathematics. What
       it adds is the interface itself, in the package: what amounts have in place of a derivation, with U1's
       failures written down as its boundary.
Boundary:
  - That balance is derived: every number-stated consumer of the matchings would be a round trip.
  - That residual units are actual boundary traffic; the identification fails once actual exchange is kept.
  - That the frame matchings and the exchange pairings are one structure; line laws across steps.
  - That unit continuation projects onto the World's conservation: the design's conclusion, not a theorem here.
Output -> input: the record's next step (a labelled exchange pairing for a World's formations attached to the
       frames; a bridge from a frame matching to the grammar's pairing; review by a person). With U4's record
       placing all 118 central declarations, the release gate's item 3 is met.
```
"""
    STUDY.write_text(text.rstrip('\n') + '\n\n' + section, encoding='utf-8')
    print('study §', n, 'written')


if __name__ == '__main__':
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    if sys.argv[1] == 'record':
        record(sys.argv[2], sys.argv[3])
    elif sys.argv[1] == 'register':
        register(sys.argv[2])
    elif sys.argv[1] == 'check':
        check()
    elif sys.argv[1] == 'study':
        study(sys.argv[2], sys.argv[3])
    else:
        sys.exit(__doc__)
