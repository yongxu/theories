#!/usr/bin/env python3
"""MV: the master laws each law of a record rests on, computed from the Lean dependencies.

python3 -B tools/research/master_laws.py [--dump PICKLE]

Run after check_becoming.py has passed on the current Lean sources (the constants come from its cache;
nothing is compiled), then make research-render. Reads the measure, ../measure_grammar.py in OU3b's study
folder and EC's measure.py it loads, unchanged: the anchors of the five master laws (closure, balance,
finite runs, lumping, order), the grammar's names, and its rows for the central declarations of
COVERAGE.json, with their dependence, category and reason. Then, for each law of each record, it follows
the constants its declarations' types and proofs use, as the measure does, and writes
theories/becoming/results/data/master-laws.json. For each law the file gives:

- which master laws' anchors the law's declarations reach, together;
- whether they reach the grammar;
- the measure's dependence for them together: `grammar`, `balance, represented`, `anchor, not reached` or
  `no master law`;
- for each of them that is a central declaration, the measure's category and reason;
- the declarations outside the core run, which the measure cannot read (the Mathlib periphery and the
  older modules).

This is a measurement of Lean dependency only, as the measure's is. Reaching an anchor says the law is
among the reasons the declarations hold or are defined. It does not say they state nothing else, and
reaching none says no master law is among their reasons. The record pages show the result beside each law.
The check reports how many laws the file no longer matches, and whether the core receipt it was computed
against is still the latest.
"""
import hashlib, importlib.util, json, os, pickle, sys, tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
MEASURE = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/ou3b-master-laws-on-the-grammar/measure_grammar.py'
OUT = ROOT / 'theories/becoming/results/data/master-laws.json'
CORE = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-verification.json'
NAMES = {'closure': 'closure', 'balance': 'balance', 'return': 'finite runs', 'lumping': 'lumping', 'order': 'order'}


def load_measure():
    spec = importlib.util.spec_from_file_location('measure_grammar', MEASURE)
    mg = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mg)
    return mg


def dependence(grammar, laws):
    """The measure's four-way split (measure_grammar.py's `dependence`), for a set of declarations together."""
    return 'grammar' if grammar else 'balance, represented' if 'balance' in laws else 'anchor, not reached' if laws else 'no master law'


def main():
    mg = load_measure()
    ec = mg.ec
    os.chdir(ROOT)
    C = ec.constants()  # honours --dump, as the measure does
    with tempfile.TemporaryDirectory(prefix='master-laws-') as scratch:
        dump, report = Path(scratch) / 'constants.pickle', Path(scratch) / 'measure.json'
        pickle.dump(C, open(dump, 'wb'))
        argv = sys.argv
        sys.argv = [str(MEASURE), '--dump', str(dump), '--json', str(report)]
        try:
            mg.main()  # the measure's rows, the interface MV reads
        finally:
            sys.argv = argv
        measured = json.loads(report.read_text())
    deps = {n: set(x['t']) | set(x['v']) for n, x in C.items()}
    anchors = {k: [a for a in v if a in C] for k, v in ec.LAWS.items()}
    memo = {}

    def above(n):
        if n not in memo:
            seen, stack = {n}, [n]
            while stack:
                for b in deps.get(stack.pop(), ()):
                    if b in C and b not in seen:
                        seen.add(b)
                        stack.append(b)
            memo[n] = (any(mg.is_grammar(b) for b in seen), frozenset(k for k, v in anchors.items() if any(a in seen for a in v)))
        return memo[n]

    central = {}
    for row in measured['rows']:
        g, hit = above(row['declaration'])
        # MV reads the same Lean the measure reads: where they differ, one of them is wrong.
        assert (g, sorted(hit)) == (row['grammar'], sorted(row['laws'])), row['declaration']
        assert dependence(g, hit) == row['dependence'], row['declaration']
        central[row['declaration']] = {'category': row['category'], **({'reason': row['reason']} if 'reason' in row else {})}
    records = {}
    counts = {'laws': 0, 'outside': 0, **{d: 0 for d in ('grammar', 'balance, represented', 'anchor, not reached', 'no master law')},
              **{k: 0 for k in anchors}}
    for path in sorted((ROOT / 'theories/becoming/results/records').glob('*.json')):
        r = json.loads(path.read_text())
        entries = []
        for i, law in enumerate(r.get('laws', []), 1):
            names = list(law.get('declarations', []))
            inside = [n for n in names if n in C]
            g, hit = False, set()
            for n in inside:
                gn, hn = above(n)
                g, hit = g or gn, hit | hn
            e = {'law': i, 'declarations': names}
            counts['laws'] += 1
            if inside:
                e['master_laws'] = [k for k in anchors if k in hit]
                e['grammar'] = g
                e['dependence'] = dependence(g, hit)
                counts[e['dependence']] += 1
                for k in e['master_laws']:
                    counts[k] += 1
            else:
                counts['outside'] += 1
            cen = [{'declaration': n, **central[n]} for n in names if n in central]
            if cen:
                e['central'] = cen
            out = [n for n in names if n not in C]
            if out:
                e['outside'] = out
            entries.append(e)
        if entries:
            records[r['id']] = entries
    core = json.loads(CORE.read_text())
    data = {
        'about': ('MV: the master laws each law of a record rests on, computed from the Lean dependencies of its declarations by '
                  'tools/research/master_laws.py, reading the measure (measure_grammar.py) and the checker cache. A measurement of '
                  'Lean dependency only. Generated; edit nothing here, rerun the generator after a core landing.'),
        'core_receipt': core['utc'],
        'measure_sha256': {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest()
                           for p in (MEASURE, Path(ec.__file__), ec.COVERAGE)},
        'names': NAMES,
        'anchors': anchors,
        'counts': counts,
        'records': records,
    }
    OUT.write_text(json.dumps(data, ensure_ascii=False, indent=1) + '\n')
    print(json.dumps({'records': len(records), **counts, 'core_receipt': core['utc']}, ensure_ascii=False))


if __name__ == '__main__':
    main()
