#!/usr/bin/env python3
"""MV: the master laws each law of a record rests on, by the Lean dependencies of its declarations.

python3 -B tools/research/master_laws.py [--dump PICKLE]

Run after check_becoming.py has passed on the current Lean sources (the constants come from its cache;
nothing is compiled), then make research-render. The generator refuses to run where the latest core receipt did
not pass or did not check the current sources; with --dump it reads a saved dump and records that it did, and the
check never reads such a file as current.

It reads the measure, unchanged: measure_grammar.py in OU3b's study folder, and the EC measure.py it loads.
From the measure it takes the anchors of the five master laws (closure, balance, finite runs, lumping, order),
the grammar test, and the rows for the central declarations of COVERAGE.json, with their dependence, category
and reason. For each law of each record, it follows the constants the law's declarations' types and values use
(proofs, and the bodies of definitions), as the measure does. It writes theories/becoming/results/data/
master-laws.json, giving for each law:

- which master laws' anchors the declarations reach, taken together: a master law is listed where any of
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

This is a measurement of Lean dependency only, as the measure's is. A master law counts where one of its
anchors occurs, directly or through other constants, in what the declarations state, define or use in a
proof. That does not make it the reason they hold, nor say they state nothing else. Reaching no anchor says
none occurs there, not that the law is no case of a master law: Continuity.Balancing states a balance of its
own and reaches none. A master law's statement on the grammar (08 §7) does not count; only its anchors do, so
the grammar's own master-law laws show none. The record pages show the result under each law. The check
reports how many laws the file no longer matches, and whether the core sources, the measure, COVERAGE.json, the
dump or this tool changed since it was written.
"""
import hashlib, importlib.util, json, os, pickle, sys, tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation'
MEASURE = STUDY / 'development/ou3b-master-laws-on-the-grammar/measure_grammar.py'
TC = STUDY / 'THEOREM-CONNECTIVITY.py'
OUT = ROOT / 'theories/becoming/results/data/master-laws.json'
CORE = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-verification.json'
# The order of 08 §7 and the names it gives them.
NAMES = {'closure': 'closure', 'balance': 'balance', 'return': 'finite runs', 'lumping': 'lumping', 'order': 'order'}
DEPENDENCES = ('grammar', 'balance, represented', 'anchor, not reached', 'no master law')


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def sources_digest(receipt):
    """One hash of the core sources a receipt checked, to tell whether the data was computed on them."""
    return hashlib.sha256(json.dumps(receipt.get('source_sha256', {}), sort_keys=True).encode()).hexdigest()


def hashed_inputs(ec):
    """What decides the data besides the Lean: the measure, its coverage, the dump and this tool."""
    return {str(p.relative_to(ROOT)): digest(p)
            for p in (MEASURE, Path(ec.__file__), ec.COVERAGE, TC, TC.with_name('THEOREM-CONNECTIVITY-DUMP.lean'), Path(__file__).resolve())}


def load_measure():
    spec = importlib.util.spec_from_file_location('measure_grammar', MEASURE)
    mg = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mg)
    return mg


def dependence(grammar, laws):
    """The measure's four-way split (the `dependence` field of measure_grammar.py's rows), for declarations together."""
    return 'grammar' if grammar else 'balance, represented' if 'balance' in laws else 'anchor, not reached' if laws else 'no master law'


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
    with tempfile.TemporaryDirectory(prefix='master-laws-') as scratch:
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
        sys.exit(f'the measure names master laws {sorted(laws)}, MV names {sorted(NAMES)}: update NAMES')
    anchors = {k: [a for a in laws[k] if a in C] for k in NAMES}
    is_anchor = {a for v in anchors.values() for a in v}
    memo = {}

    def above(n):
        """(reaches the grammar, reaches a grammar theorem, the master laws whose anchors it reaches)."""
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
                                       'master_laws': [k for k in NAMES if k in row['laws']],
                                       **({'reason': row['reason']} if 'reason' in row else {})}
    records = {}
    counts = {'laws': 0, 'no_declarations': 0, 'outside': 0, **{d: 0 for d in DEPENDENCES}, 'vocabulary_only': 0, **{k: 0 for k in NAMES}}
    for path in sorted((ROOT / 'theories/becoming/results/records').glob('*.json')):
        r = json.loads(path.read_text())
        entries = []
        for i, law in enumerate(r.get('laws', []), 1):
            names = list(law.get('declarations', []))
            inside = [n for n in names if n in C]
            g, gl, hit = False, False, set()
            for n in inside:
                gn, gln, hn = above(n)
                g, gl, hit = g or gn, gl or gln, hit | hn
            e = {'law': i, 'declarations': names}
            counts['laws'] += 1
            if inside:
                e['master_laws'] = [k for k in NAMES if k in hit]
                e['grammar'] = g
                if g and not gl:
                    e['grammar_vocabulary_only'] = True
                    counts['vocabulary_only'] += 1
                e['dependence'] = dependence(g, hit)
                counts[e['dependence']] += 1
                for k in e['master_laws']:
                    counts[k] += 1
                defines = [n for n in inside if n in is_anchor]
                if defines:
                    e['defines'] = defines
            elif names:
                counts['outside'] += 1
            else:
                counts['no_declarations'] += 1
            cen = [{'declaration': n, **central[n]} for n in names if n in central]
            if cen:
                e['central'] = cen
            out = [n for n in names if n not in C]
            if out:
                e['outside'] = out
            entries.append(e)
        if entries:
            records[r['id']] = entries
    data = {
        'about': ('MV: the master laws each law of a record rests on, by the Lean dependencies of its declarations, computed by '
                  'tools/research/master_laws.py from the measure (measure_grammar.py) and the checker cache. A measurement of Lean '
                  'dependency only. Generated: edit nothing here; rerun the generator after a core landing or a change to a '
                  "record's laws, COVERAGE.json, the measure, the dump or this generator."),
        'core_receipt': core['utc'],
        'core_sources_sha256': sources_digest(core),
        'from_dump': from_dump,
        'inputs_sha256': hashed_inputs(ec),
        'names': NAMES,
        'anchors': anchors,
        'counts': counts,
        'records': records,
    }
    OUT.write_text(json.dumps(data, ensure_ascii=False, indent=1) + '\n')
    print(json.dumps({'records': len(records), **counts, 'core_receipt': core['utc'], 'from_dump': from_dump}, ensure_ascii=False))


if __name__ == '__main__':
    main()
