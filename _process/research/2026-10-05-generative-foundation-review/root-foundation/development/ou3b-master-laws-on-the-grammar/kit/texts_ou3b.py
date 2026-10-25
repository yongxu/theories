#!/usr/bin/env python3
"""OU3b texts: the home section of the new record (01 §7: the theorem, law by law, after the paragraph on what the
grammar derives; the module's link reference; the Open item on lifting), 08 §7 (the column "On the grammar", the
finite-runs clause corrected as PROPOSED-08-7-FINITE-RUNS.md proposes, the connectivity counts read from
THEOREM-CONNECTIVITY.json and the grammar-reach measure read from the measure's output against its baseline), 08's
receipt and counts read from the receipt, COVERAGE.json's finite-runs statement, the study section and regions.json.
Mirrors UE4's texts_ue4.py. Every edit asserts that its anchor occurs exactly once.
usage (from the checkout root of the landing worktree, after the checker, the connectivity write and the measure):
  python3 -B <kit>/texts_ou3b.py RECEIPT N AFTER_JSON"""
import collections
import importlib.util
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
RECEIPT, N, AFTER = sys.argv[1], int(sys.argv[2]), Path(sys.argv[3])
PKG = 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CH = ROOT / 'theories/becoming/chapters'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
DEVREL = f'{RF}/development/ou3b-master-laws-on-the-grammar'
STUDY = ROOT / RF / 'BECOMING-RENEWAL-READING.md'
REGIONS = ROOT / 'theories/becoming/results/data/regions.json'
COVERAGE = ROOT / 'theories/becoming/results/completion/COVERAGE.json'
CONNECTIVITY = ROOT / RF / 'THEOREM-CONNECTIVITY.json'
APART = ROOT / RF / 'THEOREM-CONNECTIVITY-APART.json'
BASELINE = ROOT / DEVREL / 'baseline.json'
RID = 'master-laws-on-the-grammar'


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, new), encoding='utf-8')


# ---- what is read: the receipt, the connectivity, the measure, the register, the signature audit
R = json.loads((ROOT / PKG / 'becoming-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed'
GL = next(m for m in R['modules'] if m['module'] == 'Becoming.GrammarLaws')
assert not any(GL['axiom_dependencies'].values())
THEOREMS, DECLARATIONS = GL['theorems'], len(GL['declarations'])
spec = importlib.util.spec_from_file_location('signatures_ou3b', HERE / 'signatures_ou3b.py')
sig = importlib.util.module_from_spec(spec)
spec.loader.exec_module(sig)
_, _, report = sig.compare(RECEIPT)
assert not any(r['changed'] or r['gone'] or r['definitions_gone'] for r in report.values()), report
STATEMENTS = sum(r['old'] for r in report.values())
head_receipt = sig.receipt_at_head()
BRIDGES = 0
for m in sig.CHANGED:
    names = {d['name'] for d in next(x for x in R['modules'] if x['module'] == 'Becoming.' + m)['declarations']}
    was = {d['name'] for d in next(x for x in head_receipt['modules'] if x['module'] == 'Becoming.' + m)['declarations']}
    assert was <= names, ('a declaration is gone', m, sorted(was - names))
    BRIDGES += len(names - was)

ml = json.loads(CONNECTIVITY.read_text(encoding='utf-8'))['master_laws']
TOTAL, APART_N = ml['central_declarations'], ml['resting_on_no_master_law']
ON = ml['by_law']
after, before = json.loads(AFTER.read_text()), json.loads(BASELINE.read_text())
assert after['central_declarations'] == before['central_declarations'] == TOTAL, (after['central_declarations'], TOTAL)
by = after['by_master_law_resting_and_reaching_grammar']
assert all(by[k][0] == ON[k] for k in ON), (by, ON)
reaching_anchors = sorted(a for law in after['anchors_reach_grammar'].values() for a, v in law.items() if v)
assert reaching_anchors == ['Becoming.Amounts.rests', 'Becoming.WithinClosure'], reaching_anchors
assert before['reaching_the_grammar'] == 0


def part(law, label):
    rest, reach = by[law]
    if reach == rest:
        return f'all {rest} on {label}' if rest > 1 else f'the one on {label}'
    if reach == 0:
        return f'none of the {rest} on {label}' if rest > 1 else f'not the one on {label}'
    return f'{reach} of {rest} on {label}'


MEASURE = (f"Of the {TOTAL}, {after['reaching_the_grammar']} now reach the grammar, and none did "
           f"before: " + ', '.join(part(k, label) for k, label in (('closure', 'closure'), ('return', 'finite runs'),
                                                                   ('balance', 'balance'), ('order', 'order'),
                                                                   ('lumping', 'lumping')))
           + ". Of the anchors, `WithinClosure` reaches it by definition and `Amounts.rests` by its proof. The other "
             "anchors are read on the grammar by separate representation theorems, which the declarations resting on "
             "them do not use; where those declarations reach the grammar, they do so by another route.")

apart = json.loads(APART.read_text(encoding='utf-8'))['roots']
mine = collections.Counter(v['category'] for v in apart.values() if 'OU3b' in v['reason'])
assert not ({'Becoming.«一之续»', 'Becoming.«则之传递»'} & set(apart))
REGISTER = (f"The {sum(mine.values())} apart roots the landing makes are registered, each with a category and a "
            f"reason ({mine['general-structure']} general structure, {mine['support']} support, {mine['model-witness']} "
            f"model witnesses, {mine['calibration']} calibration): laws of every relation that nothing on the base "
            "uses, representation theorems that document a reading, the witnesses, and the excluded-middle "
            "calibration of the four cases. The two entries of `Becoming.Grammar` that are no longer apart roots "
            "(`«一之续»`, `«则之传递»`) are dropped: the frame imports the grammar's laws, which use them.")

# ---- 01 §7: the theorem, law by law
edit(CH / '01-ROOT.md', """
<a id="models"></a>
## 8. The models""", f"""
<a id="r-{RID}"></a>
**Theorem** (root). *The master laws on the grammar.* The five master laws of [08 §7](08-METHOD.md#master-laws-and-connectivity) hold for every carrier and relation ([`Becoming.GrammarLaws`][GrammarLaws]). Each anchor is read at its model's relation both ways, and each model's law is proved from the grammar's in its own module, keeping its name and statement.

- *Closure.* Lying within a relation's closure (`«所闭»`: every region closed under it that holds `x` holds `y`) is being `x` or being reached from `x` (`«所闭当且仅当同一或及»`). The frame's closed region and closure are the grammar's by definition (`closedUnder_iff_closed`, `withinClosure_iff_within`), and the frame's closure laws, with `withinClosure_iff_reached`, are proved from the grammar's.
- *Balance*, represented and not derived. A perfect pairing of two finite lists under a relation (`«对»`) conserves count. Lists paired from what comes in (the level before, what is given) to what goes on (the level after, what is taken) have after + taken = before + given, and every four numbers with that equation are the lengths of unit lists so paired under the one (`«守数当且仅当可对»`); over a stretch the count law is a pairing of units (`«程守数当且仅当可对»`). A flow balances exactly where its units so pair at each step and condition (`Flow.balances_iff_units`), and over a family the members' pairings gather (`Flow.BalancesOn.units_over`). Under the one a pairing is equal count (`«一之对»`), so the representation is near-definitional, and balance's consumers keep their arithmetic; under the empty relation equal count gives no pairing (`«等长而不对之例»`).
- *Finite runs.* For every relation an occurrence is drawn in exactly where it reaches something that does not reach back (`«入当且仅当有不返»`). Along a line whose places a list holds, merging nothing brings it back to its start within the list's length, by pigeonhole with no decidability (`«线有限不并则回»`); on a listed carrier with a successor everywhere and the successor fixed, merging nothing is every place reaching itself (`«有限遍后定后则定前当且仅当皆返»`). A process's return is reaching itself under its steps (`Branching.returns_iff_reaches`) and a law's being drawn is the grammar's (`Law.drawn_iff_drawnIn`); `Law.lossless_iff_returns` and `Law.drawn_iff_not_returns` are proved from these.
- *Rest.* Where the steps of a line do not rise and every course of no rise then a least fall ends from its place (`«尽»`), the falls along it do not recur, as far as can be refuted and outright, with no decision and no choice (`«尽则不或屡»`, `«尽则不屡»`). Within fewer than `m` least losses those courses end (`Amounts.falls_end`), so `Amounts.rests` is proved from the grammar's law. The ending is sufficient, not what rest is, and no converse is established. Rest is not being drawn, either way: a fixed point is at rest and not drawn (`«止而不入之例»`), and a place can be drawn in while its marked steps recur (`«入而屡之例»`).
- *Lumping.* `E` goes alike under `R` (`«同行»`, `R˘;E;R ⊆ E`) where `E`-alike places go to `E`-alike ones. With the successor fixed where `E` leads, constancy is exactly going alike with a successor available there (`«局定后则有常当且仅当同行可续»`), and a map's image has a fixed successor exactly where sameness under the map goes alike (`«像定后当且仅当同行»`). `GoAlikeUnder` is going alike at each move (`goAlikeUnder_iff_alike`), and `image_determined_iff`, so `carries_law_iff`, is proved from the image law.
- *Order.* Widening of relations, including and exceeding (`«广»`), is irreflexive, one-way and transitive (`«广非自»`, `«广不可逆»`, `«广之传递»`) and excludes keeping the same and being mixed; deciding inclusion against exceeding for every pair of relations is exactly excluded middle (`«则逾之定当且仅当排中»`). What a level path admits is a partial identity, and `Web.Widens` is the grammar's widening of these (`Web.widens_iff`), as `Weighting.WidensOn` is over a listing (`Weighting.widensOn_iff`); the order laws of both are proved from the grammar's.

Not shown: that any model's relation is functional, total or listed, which the models supply and the global forms take as hypotheses; a derivation of balance; a converse of the law of rest; the models' other laws on the grammar ([record](../results/records/{RID}.md)).

<a id="models"></a>
## 8. The models""")
edit(CH / '01-ROOT.md', """
[Grammar]: ../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Grammar.lean
""", """
[Grammar]: ../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/Grammar.lean
[GrammarLaws]: ../../../experiments/integrated-correction/general-framework/generative-basis/lean/becoming/Becoming/GrammarLaws.lean
""")
edit(CH / '01-ROOT.md', "each is to be restated by a lifting theorem, as the continuation family was, the counting of lines first.",
     f"each is to be restated by a lifting theorem, as the continuation family and the five master laws were ([§7](#r-{RID})), "
     "the counting of lines first.")

# ---- 08 §7: the column, the finite-runs clause, the counts and the measure
path = CH / '08-METHOD.md'
s = path.read_text(encoding='utf-8')
lines = s.split('\n')
head = lines.index('| Law | Statement | Anchor | Central declarations on it |')
assert lines[head + 1] == '|---|---|---|---:|'
GRAMMAR = {
    'Closure': '`«所闭当且仅当同一或及»`; `WithinClosure` is `«所闭»` by definition',
    'Balance': '`«守数当且仅当可对»`, `«程守数当且仅当可对»`: represented both ways (`Flow.balances_iff_units`), '
               'not derived',
    'Finite runs': '`«入当且仅当有不返»`, `«有限遍后定后则定前当且仅当皆返»`, `«尽则不或屡»`; the row\'s three laws are '
                   'proved from them',
    'Lumping': '`«像定后当且仅当同行»`; `GoAlikeUnder` is `«同行»` at each move',
    'Order': '`«广不可逆»`, `«广之传递»`; `Web.Widens` and `Weighting.WidensOn` are `«广»` of what is admitted',
}
LAW_ID = {'Closure': 'closure', 'Balance': 'balance', 'Finite runs': 'return', 'Lumping': 'lumping', 'Order': 'order'}
OLD_RUNS = 'rest is a case of being drawn'
NEW_RUNS = ('where every course of no rise then a least fall ends, falls along a line that does not rise do not recur, '
            'and within a finite budget a least loss makes those courses end (`Amounts.rests`); rest is not a case of '
            'being drawn')
rows = []
for i, name in enumerate(GRAMMAR, start=head + 2):
    cells = lines[i].split(' | ')
    assert lines[i].startswith(f'| {name} | ') and len(cells) == 4, lines[i][:60]
    statement, anchor = cells[1], cells[2]
    if name == 'Finite runs':
        assert statement.endswith(OLD_RUNS), statement[-60:]
        statement = statement[:-len(OLD_RUNS)] + NEW_RUNS
    rows.append(f'| {name} | {statement} | {anchor} | {GRAMMAR[name]} | {ON[LAW_ID[name]]} |')
lines[head:head + 2 + len(GRAMMAR)] = (['| Law | Statement | Anchor | On the grammar | Central declarations on it |',
                                        '|---|---|---|---|---:|'] + rows)
s = '\n'.join(lines)
old = re.search(r"The connectivity measure counts, at each landing, the master laws that a central declaration's compiled "
                r"type or value reaches\. Of (\d+) central declarations, (\d+) rest on at least one \(\[report\]"
                r"\(\.\./results/completion/COMPLETION\.md#master-laws\)\); the report lists the other (\d+) by row\.", s)
assert old and len(re.findall(r"The connectivity measure counts, at each landing", s)) == 1
link = f'../../../{DEVREL}/measure_grammar.py'
s = s.replace(old.group(0),
              f"The column *On the grammar* names the law's statement in [`Becoming.GrammarLaws`](01-ROOT.md#r-{RID}) "
              "and how the anchor reads it: every model's law in a row is proved from it, except balance's, which the "
              "grammar represents and does not derive. "
              "The connectivity measure counts, at each landing, the master laws that a central declaration's compiled "
              f"type or value reaches. Of {TOTAL} central declarations, {TOTAL - APART_N} rest on at least one ([report]"
              f"(../results/completion/COMPLETION.md#master-laws)); the report lists the other {APART_N} by row. "
              + MEASURE.replace('now reach the grammar,', f'now reach the grammar ([measure]({link})),', 1), 1)
path.write_text(s, encoding='utf-8')

# ---- 08: receipt and counts, every count read from the receipt (UE4's texts_ue4.py)
layers = {}
for module in R['modules']:
    count = layers.setdefault(module['layer'], [0, 0])
    count[0] += 1
    count[1] += module['theorems']
assert set(layers) <= {'foundation', 'core', 'instance', 'application'}, set(layers)
modules = sum(v[0] for v in layers.values())
theorems = sum(v[1] for v in layers.values())
assert modules == len(R['core_closure']), (modules, len(R['core_closure']))
ring = layers.get('instance', [0, 0])[0] + layers.get('application', [0, 0])[0]
declarations = sum(len(m['declarations']) for m in R['modules'])
injeq = sum(1 for name, axioms in R['generated_axiom_dependencies'].items()
            if name.endswith('.injEq') and axioms == ['propext'])
assert injeq == len(R['generated_axiom_dependencies']), 'a generated dependency other than injEq on propext'
superseded = len(R['superseded_modules'])
rlink = f'../../../{PKG}/becoming-checks/{RECEIPT}/verification.json'
counts = (f"At core receipt [`{RECEIPT}`]({rlink}) (Lean 4.29.1), the closure held {modules} modules "
          f"({layers['foundation'][0]} foundation, {layers['core'][0]} core, {ring} in the instance and application ring) "
          f"and {theorems:,} theorems; the {layers['core'][0]} core modules held {layers['core'][1]:,} of them; "
          f"{declarations:,} declarations were audited; {injeq} generated `injEq` lemmas depend on `propext`; "
          f"{superseded} superseded modules were kept out of the run.")
s = path.read_text(encoding='utf-8')
s, k = re.subn(r"At core receipt \[`[0-9TZ.]+`\]\([^)]*\) \(Lean 4\.29\.1\), the closure held \d+ modules \(\d+ foundation, "
               r"\d+ core, \d+ in the instance and application ring\) and [\d,]+ theorems; the \d+ core modules held [\d,]+ of "
               r"them; [\d,]+ declarations were audited; \d+ generated `injEq` lemmas depend on `propext`; \d+ superseded "
               r"modules were kept out of the run\.", lambda m: counts, s)
assert k == 1, k
path.write_text(s, encoding='utf-8')

# ---- COVERAGE.json: the finite-runs statement, as the corrected 08 §7 clause (textual edit, the rest byte for byte)
edit(COVERAGE, '"statement": "within finitely many configurations a law returns every configuration or is drawn, and rest '
               'is a case of being drawn"',
     '"statement": "within finitely many configurations a law returns every configuration or is drawn; where every course '
     'of no rise then a least fall ends, falls along a line that does not rise do not recur, and rest is not a case of '
     'being drawn"')
json.loads(COVERAGE.read_text(encoding='utf-8'))

# ---- the study section
section = (HERE / 'study_ou3b.txt').read_text(encoding='utf-8')
for key, value in (('{N}', str(N)), ('{RECEIPT}', RECEIPT), ('{THEOREMS}', str(THEOREMS)),
                   ('{DECLARATIONS}', str(DECLARATIONS)), ('{BRIDGES}', str(BRIDGES)),
                   ('{STATEMENTS}', f'{STATEMENTS:,}'), ('{TOTAL}', str(TOTAL)), ('{MEASURE}', MEASURE),
                   ('{REGISTER}', REGISTER)):
    assert key in section, key
    section = section.replace(key, value)
assert '{' + 'N}' not in section and not re.search(r'\{[A-Z]+\}', section)
t = STUDY.read_text(encoding='utf-8')
last = max(int(x) for x in re.findall(r'^## (\d+)\. ', t, re.M))
assert N == last + 1, (N, last)
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# ---- regions
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
assert RID not in reg['records'] and 'Becoming.GrammarLaws' not in reg['modules']
reg['records'][RID] = {'region': 'root', 'base': 'grammar',
                       'note': "GrammarLaws OU3b: the five master laws on the grammar, the models' laws proved from them"}
reg['records'] = dict(sorted(reg['records'].items()))
reg['modules']['Becoming.GrammarLaws'] = {'region': 'root', 'base': 'grammar',
                                          'note': 'the master laws on the grammar (OU3b): closure, balance represented, '
                                                  'finite runs and rest, lumping, order; below the frame'}
frame = reg['modules']['Becoming.Frame']
assert frame['note'] == 'L0 frame: process, runs, one closure, reach, invariants; frames as models', frame
frame['note'] = "L0 frame: process, runs, one closure (the grammar's «所闭»), reach, invariants; frames as models"
reg['modules'] = dict(sorted(reg['modules'].items()))
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 01 §7 theorem, link and Open item; 08 §7 column, finite runs, counts', TOTAL - APART_N, 'of', TOTAL,
      'and the measure:', MEASURE[:120], '...; 08 receipt counts:', counts[:80], '...; COVERAGE; study section', N,
      f'({THEOREMS} theorems in {DECLARATIONS} declarations, {BRIDGES} bridges, {STATEMENTS} statements compared); regions')
