#!/usr/bin/env python3
"""MV: the shared laws each law of a record rests on, by the Lean dependencies of its declarations.

python3 -B tools/research/shared_laws.py [--dump PICKLE]

Run after check_becoming.py has passed on the current Lean sources (the constants come from its cache;
nothing is compiled), then make research-render. The generator refuses to run where the latest core receipt did
not pass or did not check the current sources; with --dump it reads a saved dump and records that it did, and the
check never reads such a file as current.

It reads the measure, unchanged: measure_grammar.py in OU3b's study folder, and the EC measure.py it loads.
From the measure it takes the anchors of the five shared laws (closure, balance, finite runs, lumping, widening),
the grammar test, and the rows for the central declarations of COVERAGE.json, with their dependence, category
and reason. For each law of each record, it follows the constants the law's declarations' types and values use
(proofs, and the bodies of definitions), as the measure does. It writes theories/becoming/results/data/
shared-laws.json, giving for each law:

- which shared laws' anchors the declarations reach, taken together: a shared law is listed where any of
  them reaches its anchor;
- whether any of them reaches the grammar, as the measure reads it. That is a constant with a «» name,
  vocabulary included (the relation type «际»), so the reach may be through vocabulary alone, which the file
  marks. The number and list lemmas of Becoming.GrammarLaws (no «» name) do not count, so finite runs' anchor
  Becoming.revisits_within, Becoming.Recurrence's name for the pigeonhole GrammarLaws.revisits_within, does not
  reach it;
- the measure's four-way dependence for them together;
- for each central declaration among them, the measure's category and reason, and its own dependence;
- the anchors that are among the law's own declarations;
- the declarations the spine run does not have, which the measure cannot read: the Mathlib periphery, the
  older modules, and names a superseded record keeps that the current Lean no longer has.

This is a measurement of Lean dependency only, as the measure's is. A shared law counts where one of its
anchors occurs, directly or through other constants, in what the declarations state, define or use in a
proof. That does not make it the reason they hold, nor say they state nothing else. Reaching no anchor says
none occurs there, not that the law is no case of a shared law: Continuity.Balancing states a balance of its
own and reaches none. A shared law's statement on the grammar (08 §7) is among its anchors. The record
pages show the result under each law. The check
reports how many laws the file no longer matches, and whether the core sources, the measure, COVERAGE.json, the
dump or this tool changed since it was written.

F5 (architecture/mv/F5-MODEL-STATEMENTS.md). A law may carry statements_at_model: theorems that state a row of
the same record at a model, each declaring its row, its models and its review. That the theorem states the row's
statement is a reader's judgment; this tool verifies what the Lean can show and computes the rest:

- the theorem and the row are in the spine run;
- the walk from the theorem through the constants each declaration uses (statement and proof or body), grammar
  constants not expanded, reaches the row without entering the theorem of another item, except one on the same
  law with the same row;
- its statement names a grammar term other than «际», among its own constants or, transitively, in the bodies of
  the definitions of its own module that it names;
- in that same reach, a relation of each declared model: OCCURRENCE for a World's occurrence model, PROCESS for a
  process's model, nothing for the row's own carrier;
- the law carrying it holds no central declaration of COVERAGE.json.

It also lists the grammar terms the statement names and what it keeps in other terms (U2Deps' report), and the
row's own dependence. An item that fails is written unverified, with what it fails; the tool does not stop for it.
So is an item the check would refuse, except one whose review does not name it: only the check reads the review.
A law carrying items is measured as any law is, and counted in counts_at_model instead of counts, so a statement
at a model raises no count of the others. Under every law whose declarations include a verified item's row, the
file names the item (stated_at_model). central_reach counts the distinct central declarations: reaching the
grammar, by the measure; not reaching it but stated at a represented model (a World's occurrence model or a
process's model); not reaching it and stated only on their own carrier; and the rest.

The boundary field (architecture/mv/BOUNDARY-FIELD.md; tools/research/boundary.py). One record, U4's boundary
record, may carry `boundary`: the standings of central declarations on U4's edge (derived, on the root under a stated
hypothesis, or a reading) and the two premises of the ethics. Where a record carries it, this tool checks each entry
(D1 to D5 on the constants; the forms under a stated hypothesis, the derived rows' laws and their bridges in Lean,
by tools/research/boundary_check.lean in the core run's environment restored from the cache), places every other
central declaration by U4's rule, and writes `boundary`: the counts by label and group, the counts against F5's four
classes, the premises' Q1, what the Lean check ran on, the unverified entries and every row. An entry that fails is
unverified and its row takes the rule's label. The laws of the record carrying the field are counted in
counts_at_boundary_record, not counts or counts_at_model, so the standings' own declarations raise no count.
"""
import hashlib, importlib.util, json, os, pickle, sys, tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
from tools.research import boundary  # noqa: E402
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation'
MEASURE = STUDY / 'development/ou3b-master-laws-on-the-grammar/measure_grammar.py'
TC = STUDY / 'THEOREM-CONNECTIVITY.py'
OUT = ROOT / 'theories/becoming/results/data/shared-laws.json'
CORE = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-verification.json'
# The order of 08 §7 and the names it gives them.
NAMES = {'closure': 'closure', 'balance': 'balance', 'return': 'finite runs', 'lumping': 'lumping', 'order': 'widening'}
DEPENDENCES = ('grammar', 'balance, represented', 'anchor, not reached', 'no shared law')
AT_MODEL_KEYS = ('declaration', 'of', 'models', 'review')
# The relations that evidence each model, split from U2Deps' modelRelations (U2's check); WRT's and WRP's designer
# changes them. U2Deps' other model relations are regions or classes on any carrier: they count as a model's
# structure when listing other terms, and evidence no model.
OCCURRENCE = {'Becoming.World.withinStep', 'Becoming.Web.roles', 'Becoming.Steps.along'}
PROCESS = {'Becoming.moveRel', 'Becoming.Steps', 'Becoming.Steps.next'}
MODEL_RELATIONS = {'occurrence': OCCURRENCE, 'process': PROCESS}
STRUCTURE = OCCURRENCE | PROCESS | {'Becoming.Web.partialIdentity', 'Becoming.sameValue', 'Becoming.Web.admitted'}
RELATION_TYPE = 'Becoming.«际»'


def is_grammar_term(name):
    """A grammar term for F5: a «» name other than the relation type «际» (the measure's grammar test counts it)."""
    return '«' in name and name != RELATION_TYPE


def stated(C, d):
    """What the statement of d names: its own constants, and transitively the bodies of the definitions of its own
    module that they name. Grammar constants are not expanded."""
    module, seen = C[d]['m'], set(C[d]['t'])
    stack = [n for n in seen if n in C and C[n]['m'] == module and C[n]['k'] == 'def' and '«' not in n]
    while stack:
        for b in C[stack.pop()]['v']:
            if b not in seen:
                seen.add(b)
                if b in C and C[b]['m'] == module and C[b]['k'] == 'def' and '«' not in b:
                    stack.append(b)
    return seen


def reaches(C, d, row, blocked):
    """Whether the walk from d through the constants each declaration uses reaches row, entering no blocked theorem
    and expanding no grammar constant (as U2Deps walks)."""
    seen, stack = {d}, [d]
    while stack:
        n = stack.pop()
        if n == row:
            return True
        if n in C and '«' not in n:
            for b in list(C[n]['t']) + list(C[n]['v']):
                if b not in seen and b not in blocked:
                    seen.add(b)
                    stack.append(b)
    return False


MODELS = ('occurrence', 'process', 'own')


def shape_failures(r, i, item, declared):
    """What the check would refuse in an item, so the generator writes it unverified rather than stop or miscount:
    every rule of the check but one. Whether the review names the theorem is read by the check alone, since the
    review's text is not among this tool's inputs."""
    d, of, models, review = (item.get(k) for k in AT_MODEL_KEYS)
    if set(item) != set(AT_MODEL_KEYS) or not all(isinstance(x, str) and x for x in (d, of, review)) \
            or not isinstance(models, list) or not models or any(not isinstance(m, str) or m not in MODELS for m in models) \
            or len(set(models)) != len(models):
        return ['not in the shape the check requires']
    laws = [law if isinstance(law, dict) else {} for law in r.get('laws', [])]
    names = [[n for n in law.get('declarations', []) if isinstance(n, str)] if isinstance(law.get('declarations'), list) else []
             for law in laws]
    rows = {y.get('of') for r2, _, y in declared if r2 == r['id'] and isinstance(y.get('of'), str)}
    reviews = {x.get('path') for x in r.get('references', []) if isinstance(x, dict) and x.get('role') == 'review'}
    if r.get('status') in {'superseded', 'withdrawn'} or d not in names[i - 1] \
            or not any(of in n for j, n in enumerate(names, 1) if j != i) or review not in reviews \
            or any(rows & set(names[j - 1]) for j, law in enumerate(laws, 1) if 'statements_at_model' in law) \
            or sum(1 for _, _, y in declared if y.get('declaration') == d) > 1:
        return ["its record breaks the check's rules"]
    return []


def blocked(declared, rid, i, item):
    """The theorems of the other items, which the walk from item's theorem may not enter: all but those on the same
    law stating the same row."""
    return {y['declaration'] for r2, j, y in declared if y is not item and isinstance(y.get('declaration'), str)
            and not (r2 == rid and j == i and y.get('of') == item.get('of'))}


def verify(C, item, law_names, central, others):
    """F5's tests of one declared statement at a model; others are the theorems of items it must not pass through.
    Returns what it fails, the grammar terms its statement names and what it keeps in other terms."""
    d, row = item['declaration'], item['of']
    failed, terms, kept = [], [], []
    if d not in C or row not in C:
        failed.append('not in the spine run')
    else:
        if not reaches(C, d, row, others):
            failed.append('its proof does not reach the row')
        names = stated(C, d)
        terms = sorted(n for n in names if is_grammar_term(n))
        if not terms:
            failed.append('its statement names no grammar term')
        for m in item['models']:
            if m in MODEL_RELATIONS and not names & MODEL_RELATIONS[m]:
                failed.append(f'its statement names no relation of the {m} model')
        kept = sorted(n for n in C[d]['t'] if n in C and '«' not in n and C[n]['m'] != C[d]['m'] and n not in STRUCTURE)
    held = sorted(set(law_names) & central)
    if held:
        failed.append('its law holds the central declaration ' + ', '.join(held))
    return failed, terms, kept


def counted_in(rid, i, carrying, checked):
    """Where law i of record rid is counted: the laws of the record carrying the boundary field apart (a law also
    carrying statements at a model among them), then F5's carrying laws, then every other law."""
    return 'counts_at_boundary_record' if rid in carrying else 'counts_at_model' if (rid, i) in checked else 'counts'


COUNTED = ('counts', 'counts_at_model', 'counts_at_boundary_record')


def boundary_data(carrying, report):
    """The data's `boundary`: report(record) for the one record carrying the field, an error naming the records where
    more than one carries it, and None where none does."""
    if len(carrying) > 1:
        return {'error': 'the boundary field is carried by more than one record', 'records': carrying}
    return report(carrying[0]) if carrying else None


def law_entries(loaded, C, above, central, is_anchor, checked, at_model, carrying):
    """Each record's law entries, and the three tables each law is counted in one of (counted_in): counts,
    counts_at_model (F5's carrying laws) and counts_at_boundary_record (the laws of the record carrying the boundary
    field). above(n) is (reaches the grammar, reaches a grammar theorem, the shared laws whose anchors it reaches)."""
    counts = {'laws': 0, 'no_declarations': 0, 'outside': 0, **{d: 0 for d in DEPENDENCES}, 'vocabulary_only': 0, **{k: 0 for k in NAMES}}
    tables = {k: dict.fromkeys(counts, 0) for k in COUNTED}
    records = {}
    for r in loaded:
        entries = []
        for i, law in enumerate(r.get('laws', []), 1):
            names = list(law.get('declarations', []))
            inside = [n for n in names if n in C]
            g, gl, hit = False, False, set()
            for n in inside:
                gn, gln, hn = above(n)
                g, gl, hit = g or gn, gl or gln, hit | hn
            e = {'law': i, 'declarations': names}
            c = tables[counted_in(r['id'], i, carrying, checked)]
            c['laws'] += 1
            if inside:
                e['shared_laws'] = [k for k in NAMES if k in hit]
                e['grammar'] = g
                if g and not gl:
                    e['grammar_vocabulary_only'] = True
                    c['vocabulary_only'] += 1
                e['dependence'] = dependence(g, hit)
                c[e['dependence']] += 1
                for k in e['shared_laws']:
                    c[k] += 1
                defines = [n for n in inside if n in is_anchor]
                if defines:
                    e['defines'] = defines
            elif names:
                c['outside'] += 1
            else:
                c['no_declarations'] += 1
            cen = [{'declaration': n, **central[n]} for n in names if n in central]
            if cen:
                e['central'] = cen
            out = [n for n in names if n not in C]
            if out:
                e['outside'] = out
            if (r['id'], i) in checked:
                e['statements_at_model'] = checked[r['id'], i]
            elsewhere = [x for n in dict.fromkeys(names) for x in at_model.get(n, []) if (x['record'], x['law']) != (r['id'], i)]
            if elsewhere:
                e['stated_at_model'] = elsewhere
            entries.append(e)
        if entries:
            records[r['id']] = entries
    return records, tables


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def sources_digest(receipt):
    """One hash of the core sources a receipt checked, to tell whether the data was computed on them."""
    return hashlib.sha256(json.dumps(receipt.get('source_sha256', {}), sort_keys=True).encode()).hexdigest()


def hashed_inputs(ec):
    """What decides the data besides the Lean: the measure, its coverage, the dump, the boundary field's code and
    Lean check, and this tool."""
    return {str(p.relative_to(ROOT)): digest(p)
            for p in (MEASURE, Path(ec.__file__), ec.COVERAGE, TC, TC.with_name('THEOREM-CONNECTIVITY-DUMP.lean'),
                      Path(boundary.__file__).resolve(), boundary.CHECK, Path(__file__).resolve())}


def load_measure():
    spec = importlib.util.spec_from_file_location('measure_grammar', MEASURE)
    mg = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mg)
    return mg


def dependence(grammar, laws):
    """The measure's four-way split (the `dependence` field of measure_grammar.py's rows), for declarations together."""
    return 'grammar' if grammar else 'balance, represented' if 'balance' in laws else 'anchor, not reached' if laws else 'no shared law'


def main():
    mg = load_measure()
    ec = mg.ec
    os.chdir(ROOT)
    core = json.loads(CORE.read_text())
    if core.get('status') != 'passed':
        sys.exit(f"the latest core receipt ({core.get('utc')}) has status {core.get('status')!r}: run check_becoming.py until it passes")
    from_dump = '--dump' in sys.argv
    if not from_dump:
        lean = CORE.parents[1]  # the receipt's source paths are relative to the lean folder
        changed = [m for m, p in core.get('source_paths', {}).items()
                   if not (lean / p).is_file() or digest(lean / p) != core['source_sha256'].get(m)]
        if changed:
            sys.exit(f'the current Lean sources are not those the latest core receipt checked ({len(changed)} modules, '
                     f'e.g. {changed[:3]}): run check_becoming.py first')
    C = ec.constants()  # honours --dump, as the measure does
    extra = sorted({x['m'] for x in C.values()} - set(core.get('source_paths', {})))
    if extra:
        sys.exit(f'the constants hold modules the latest core receipt did not check: {extra[:3]}')
    with tempfile.TemporaryDirectory(prefix='shared-laws-') as scratch:
        dump, report = Path(scratch) / 'constants.pickle', Path(scratch) / 'measure.json'
        with open(dump, 'wb') as f:
            pickle.dump(C, f)
        argv = sys.argv
        sys.argv = [str(MEASURE), '--dump', str(dump), '--json', str(report)]
        try:
            mg.main()  # the measure's rows, the interface MV reads
        finally:
            sys.argv = argv
        measured = json.loads(report.read_text())
    deps = {n: set(x['t']) | set(x['v']) for n, x in C.items()}
    laws = getattr(mg, 'ANCHORS', ec.LAWS)  # the measure's joined map of anchors where it exports one, else EC's
    if set(laws) != set(NAMES):
        sys.exit(f'the measure names shared laws {sorted(laws)}, MV names {sorted(NAMES)}: update NAMES')
    anchors = {k: [a for a in laws[k] if a in C] for k in NAMES}
    is_anchor = {a for v in anchors.values() for a in v}
    memo = {}

    def above(n):
        """(reaches the grammar, reaches a grammar theorem, the shared laws whose anchors it reaches)."""
        if n not in C:
            return False, False, frozenset()  # as the measure: a name the run lacks reaches nothing
        if n not in memo:
            seen, stack = {n}, [n]
            while stack:
                for b in deps.get(stack.pop(), ()):
                    if b in C and b not in seen:
                        seen.add(b)
                        stack.append(b)
            grammar = [b for b in seen if mg.is_grammar(b)]
            memo[n] = (bool(grammar), any(C[b]['k'] == 'thm' for b in grammar),
                       frozenset(k for k, v in anchors.items() if any(a in seen for a in v)))
        return memo[n]

    central = {}
    for row in measured['rows']:
        g, _, hit = above(row['declaration'])
        # MV reads the same Lean the measure reads: where they differ, one of them is wrong.
        if (g, sorted(hit)) != (row['grammar'], sorted(row['laws'])) or dependence(g, hit) != row['dependence']:
            sys.exit(f'MV and the measure disagree on {row["declaration"]}')
        central[row['declaration']] = {'category': row['category'], 'dependence': row['dependence'],
                                       'shared_laws': [k for k in NAMES if k in row['laws']],
                                       **({'reason': row['reason']} if 'reason' in row else {})}
    loaded = [json.loads(path.read_text()) for path in sorted((ROOT / 'theories/becoming/results/records').glob('*.json'))]
    by_id = {r['id']: r for r in loaded}
    carrying = [r['id'] for r in boundary.carriers(loaded)]
    declared = [(r['id'], i, x) for r in loaded for i, law in enumerate(r.get('laws', []), 1) if isinstance(law, dict)
                for x in (law.get('statements_at_model') if isinstance(law.get('statements_at_model'), list) else [])
                if isinstance(x, dict)]
    checked, at_model = {}, {}  # (record, law) -> its items as verified; row -> its verified statements at a model
    for rid, i, x in declared:
        failed = shape_failures(by_id[rid], i, x, declared)
        terms, kept, row = [], [], 'not measured'
        if not failed:
            failed, terms, kept = verify(C, x, by_id[rid]['laws'][i - 1].get('declarations', []), set(central),
                                         blocked(declared, rid, i, x))
            g, _, hit = above(x['of'])
            row = dependence(g, hit) if x['of'] in C else 'not measured'
        checked.setdefault((rid, i), []).append({**{k: x.get(k) for k in AT_MODEL_KEYS}, 'verified': not failed,
                                                 **({'failed': failed} if failed else {}), 'grammar_terms': terms,
                                                 'other_terms': kept, 'row_dependence': row})
        if not failed:
            at_model.setdefault(x['of'], []).append({'of': x['of'], 'record': rid, 'law': i, 'declaration': x['declaration'],
                                                     'models': x['models'], 'review': x['review']})
    records, tables = law_entries(loaded, C, above, central, is_anchor, checked, at_model, carrying)
    counts, counts_at_model, counts_at_boundary_record = (tables[k] for k in COUNTED)
    reach, f5_class = dict.fromkeys(boundary.F5_CLASSES, 0), {}
    for n, row in central.items():
        models = {m for x in at_model.get(n, []) for m in x['models']}
        f5_class[n] = ('reaching the grammar' if row['dependence'] == 'grammar' else 'stated at a represented model'
                       if models & {'occurrence', 'process'} else 'stated on its own carrier only' if models else 'the rest')
        reach[f5_class[n]] += 1
    data = {
        'about': ('MV: the shared laws each law of a record rests on, by the Lean dependencies of its declarations, computed by '
                  'tools/research/shared_laws.py from the measure (measure_grammar.py) and the checker cache. A measurement of Lean '
                  'dependency only. Generated: edit nothing here; rerun the generator after a core landing or a change to a '
                  "record's laws, COVERAGE.json, the measure, the dump or this generator."),
        'core_receipt': core['utc'],
        'core_sources_sha256': sources_digest(core),
        'from_dump': from_dump,
        'inputs_sha256': hashed_inputs(ec),
        'names': NAMES,
        'anchors': anchors,
        'counts': counts,
        'counts_at_model': counts_at_model,
        'counts_at_boundary_record': counts_at_boundary_record,
        'model_relations': {'occurrence': sorted(OCCURRENCE), 'process': sorted(PROCESS), 'structure': sorted(STRUCTURE)},
        'central_reach': {'counts': reach, 'rows': {n: at_model[n] for n in sorted(central) if n in at_model}},
        'records': records,
    }
    b = boundary_data(carrying, lambda rid: boundary.report(C, central, at_model, f5_class, by_id[rid], laws['balance']))
    if b is not None:
        data['boundary'] = b
    OUT.write_text(json.dumps(data, ensure_ascii=False, indent=1) + '\n')
    unverified = sum(1 for v in checked.values() for x in v if not x['verified'])
    b = data.get('boundary', {})
    print(json.dumps({'records': len(records), **counts, 'at_model_laws': counts_at_model['laws'], 'statements_at_model': len(declared),
                      'unverified': unverified, 'central_reach': reach, 'core_receipt': core['utc'], 'from_dump': from_dump,
                      **({'boundary': b.get('error') or {'record': b['record'], 'counts': b['counts'], 'unverified': len(b['unverified']),
                                                          'lean_check': b['lean_check'].get('ran')}} if b else {})},
                     ensure_ascii=False))


if __name__ == '__main__':
    main()
