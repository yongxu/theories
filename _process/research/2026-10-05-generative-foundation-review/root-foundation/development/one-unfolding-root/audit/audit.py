#!/usr/bin/env python3
"""Dependency audit of the Becoming spine (one-unfolding root plan, section 9.1):
python3 -B audit.py DUMPDIR

DUMPDIR holds what dump.py produced (dump.jsonl from the unchanged THEOREM-CONNECTIVITY-DUMP.lean,
proj.jsonl from PROJ-DUMP.lean, registry.json, meta.json). Writes audit.json and REPORT-DATA.json
beside this script; nothing else.

For every spine theorem, separately for its statement (the constants of its type) and its proof
(the constants of its value), the transitive closure of constant dependencies is taken, and from it:

* fields read: the eight fields of the old base, read through either record that carries them
  (state: `WebAt.f` per step or `Dependence.f` along the step index, f in level, active, requires,
  need, draws; exchange: `Exchange.f` or `Flow.f`, f in present, take, give);
* premises: which of the eight `World` premises (`World.Dependent` ... `World.Transmitting`) are
  reached, and, apart, the record-level predicates they are stated by (`Web.Dependent`, ...);
* master laws: which anchors of COVERAGE.json's `master_laws` are reached.

Packaging. A definition whose value applies a constructor of a base record (`WebAt.mk`,
`Exchange.mk`, `Dependence.mk`, `Flow.mk`, `World.mk`, `Run.mk`) repackages fields: `World.web`
reads all five state fields of the history to build the web, and `World.of` reads all eight of
its arguments. The closure does not descend into such a definition when counting fields read: the
field is counted where something projects out of the package (`w.web.active` names
`Dependence.active` in the user's own term). The definition is recorded as a construction
(`constructs`). A second, naive closure that descends everywhere is kept as `*_naive` for comparison.
An upper closure (`fields_upper`) descends into every packaging definition except the
pass-throughs listed in PASS_THROUGH (read by hand: each field goes to the same field); the field
set a theorem really needs lies between `fields` and `fields_upper`.
Destructuring a base record (`casesOn`, `rec`, `recOn`, `noConfusion`, `mk.injEq`, `mk.inj`) is
recorded as `destructures`: it can reach every field, which constant dependencies cannot settle.
Primitive projection nodes (`Expr.proj`) are invisible to `getUsedConstants`; PROJ-DUMP.lean lists
them, and for the base records they occur only inside the projection functions themselves, so no
field is read past the closure (checked below). Instances are ordinary definitions and are followed.
"""
import collections
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[6]
COVERAGE = ROOT / 'theories/becoming/results/completion/COVERAGE.json'

STATE = ['level', 'active', 'requires', 'need', 'draws']
EXCHANGE = ['present', 'take', 'give']
FIELDS = STATE + EXCHANGE
FIELD_OF = {}
for f in STATE:
    FIELD_OF[f'Becoming.WebAt.{f}'] = f
    FIELD_OF[f'Becoming.Dependence.{f}'] = f
for f in EXCHANGE:
    FIELD_OF[f'Becoming.Exchange.{f}'] = f
    FIELD_OF[f'Becoming.Flow.{f}'] = f
STRUCTURAL = {'Becoming.World.Relatum': 'Relatum', 'Becoming.World.history': 'history',
              'Becoming.Run.state': 'Run.state', 'Becoming.Run.act': 'Run.act', 'Becoming.Run.step': 'Run.step'}
# Repackagings read by hand and found to pass each field through to the same field (possibly reindexed):
# the upper closure does not descend into these, and descends into every other packaging definition.
PASS_THROUGH = {'Becoming.World.web', 'Becoming.World.flow', 'Becoming.World.move', 'Becoming.World.of',
                'Becoming.Web.roles', 'Becoming.Flow.roles', 'Becoming.Web.reidentify', 'Becoming.Flow.reidentify'}
ACCESSORS = {'Becoming.World.web', 'Becoming.World.flow', 'Becoming.World.move'}
RECORDS = ['Becoming.WebAt', 'Becoming.Exchange', 'Becoming.Dependence', 'Becoming.Flow',
           'Becoming.World', 'Becoming.Run']
MK = {r + '.mk': r for r in RECORDS}
DESTRUCT = {r + s: r for r in RECORDS for s in ('.casesOn', '.rec', '.recOn', '.noConfusion',
                                                '.mk.injEq', '.mk.inj')}
PREMISES = ['Dependent', 'Balanced', 'Acting', 'Taking', 'Dissipative', 'Embodied', 'Counted', 'Transmitting']
PREMISE_OF = {f'Becoming.World.{p}': p for p in PREMISES}
UNDERLYING = {'Becoming.Web.Dependent': 'Dependent', 'Becoming.Flow.Balances': 'Balanced',
              'Becoming.Flow.Acting': 'Acting', 'Becoming.Flow.Taking': 'Taking',
              'Becoming.Flow.Dissipative': 'Dissipative', 'Becoming.Web.Embodied': 'Embodied',
              'Becoming.Web.Census': 'Counted', 'Becoming.Flow.TransmitsWithin': 'Transmitting'}


def load(dumpdir):
    d = Path(dumpdir)
    constants = {}
    for line in (d / 'dump.jsonl').read_text().splitlines():
        x = json.loads(line)
        constants[x['n']] = x
    projs = {}
    for line in (d / 'proj.jsonl').read_text().splitlines():
        x = json.loads(line)
        projs[x['n']] = x
    return constants, projs, json.loads((d / 'registry.json').read_text()), json.loads((d / 'meta.json').read_text())


def main(dumpdir):
    constants, projs, registry, meta = load(dumpdir)
    for n in list(FIELD_OF) + list(PREMISE_OF) + list(UNDERLYING) + list(MK):
        assert n in constants, ('expected constant missing', n)
    deps = {n: set(x['t']) | set(x['v']) for n, x in constants.items()}

    # Primitive projections of base records outside their projection functions: none expected.
    stray = sorted((n, p) for n, x in projs.items() for p in x['pt'] + x['pv']
                   if p.split('#')[0] in RECORDS and n not in FIELD_OF and n not in STRUCTURAL)
    # Packaging definitions: value applies a base constructor directly.
    packaging = {n for n, x in constants.items() if x['k'] in ('def', 'opaque') and any(d in MK for d in x['v'])}

    coverage = json.loads(COVERAGE.read_text())
    anchors = {}
    for law in coverage['master_laws']:
        for a in law['anchors']:
            anchors.setdefault(a, []).append(law['id'])
    missing_anchors = sorted(a for a in anchors if a not in constants)

    memo_cut, memo_naive = {}, {}

    def closure(start, cut):
        """Every constant reached from `start` (not including the starting theorem itself unless reached).
        `cut` is a set of definitions reached but not descended into (None: descend everywhere)."""
        seen, stack = set(), list(start)
        while stack:
            n = stack.pop()
            if n in seen or n not in constants:
                continue
            seen.add(n)
            if cut and n in cut:
                continue
            stack.extend(deps[n])
        return seen

    def summary(reached, upper, naive):
        return {
            'fields': sorted({FIELD_OF[n] for n in reached if n in FIELD_OF}, key=FIELDS.index),
            'fields_upper': sorted({FIELD_OF[n] for n in upper if n in FIELD_OF}, key=FIELDS.index),
            'fields_naive': sorted({FIELD_OF[n] for n in naive if n in FIELD_OF}, key=FIELDS.index),
            'structural': sorted({STRUCTURAL[n] for n in reached if n in STRUCTURAL}),
            'constructs': sorted(n for n in reached if n in packaging and n not in ACCESSORS),
            'destructures': sorted({DESTRUCT[n].split('.')[-1] for n in naive if n in DESTRUCT}),
            'premises': sorted({PREMISE_OF[n] for n in naive if n in PREMISE_OF}, key=PREMISES.index),
            'premise_predicates': sorted({UNDERLYING[n] for n in naive if n in UNDERLYING}, key=PREMISES.index),
            'master_laws': sorted({l for n in naive if n in anchors for l in anchors[n]}),
            'world': 'Becoming.World' in naive,
        }

    spine = registry['spine']
    rings = registry['rings']
    theorems = [(d['name'], m) for m in spine for d in registry['declarations'].get(m, []) if d['kind'] == 'theorem']
    absent = [n for n, _ in theorems if n not in constants]
    assert not absent, absent[:5]
    out = {}
    for n, m in theorems:
        x = constants[n]
        st_cut, st_up, st_naive = (closure(x['t'], c) for c in (packaging, PASS_THROUGH, None))
        pr_cut, pr_up, pr_naive = (closure(x['v'], c) for c in (packaging, PASS_THROUGH, None))
        ring = 'instances' if m in rings['instances'] else 'applications' if m in rings['applications'] else 'core'
        s, p = summary(st_cut, st_up, st_naive), summary(pr_cut, pr_up, pr_naive)
        uses = sorted(set(s['fields']) | set(p['fields']), key=FIELDS.index)
        out[n] = {'module': m, 'ring': ring, 'statement': s, 'proof': p, 'fields': uses,
                  'premises': sorted(set(s['premises']) | set(p['premises']), key=PREMISES.index),
                  'premise_hypotheses': s['premises'],
                  'master_laws': sorted(set(s['master_laws']) | set(p['master_laws']))}
    (HERE / 'audit.json').write_text(json.dumps(
        {'commit': meta['commit'], 'sources_match_commit': meta['sources_match_commit'],
         'fields': FIELDS, 'premises': PREMISES, 'master_law_anchors': anchors,
         'packaging_definitions': sorted(packaging), 'stray_primitive_projections': stray,
         'theorems': out}, ensure_ascii=False, indent=1) + '\n')

    # Aggregates for the report.
    T = out.values()
    def key(fs):
        return '{' + ', '.join(fs) + '}' if fs else '{}'
    agg = {
        'commit': meta['commit'], 'sources_match_commit': meta['sources_match_commit'],
        'spine_modules': len(spine), 'theorems': len(out), 'missing_anchors': missing_anchors,
        'packaging_definitions': len(packaging), 'stray_primitive_projections': stray,
        'by_ring': dict(collections.Counter(t['ring'] for t in T)),
    }
    for scope, get in (('uses', lambda t: t['fields']), ('statement', lambda t: t['statement']['fields']),
                       ('proof', lambda t: t['proof']['fields']),
                       ('uses_upper', lambda t: sorted(set(t['statement']['fields_upper']) | set(t['proof']['fields_upper']), key=FIELDS.index)),
                       ('statement_upper', lambda t: t['statement']['fields_upper']),
                       ('uses_naive', lambda t: sorted(set(t['statement']['fields_naive']) | set(t['proof']['fields_naive']), key=FIELDS.index))):
        sizes = collections.Counter(len(get(t)) for t in T)
        agg[scope] = {
            'by_count': {k: sizes[k] for k in sorted(sizes)},
            'exactly_one_by_field': dict(collections.Counter(get(t)[0] for t in T if len(get(t)) == 1)),
            'each_field': {f: sum(1 for t in T if f in get(t)) for f in FIELDS},
            'state_only': sum(1 for t in T if get(t) and set(get(t)) <= set(STATE)),
            'exchange_only': sum(1 for t in T if get(t) and set(get(t)) <= set(EXCHANGE)),
            'both_kinds': sum(1 for t in T if set(get(t)) & set(STATE) and set(get(t)) & set(EXCHANGE)),
            'groups': collections.Counter(key(get(t)) for t in T).most_common(),
        }
        agg[scope]['by_ring'] = {r: {k: v for k, v in sorted(collections.Counter(
            len(get(t)) for t in T if t['ring'] == r).items())} for r in ('core', 'instances', 'applications')}
    agg['premises'] = {
        'none': sum(1 for t in T if not t['premises']),
        'each': {p: sum(1 for t in T if p in t['premises']) for p in PREMISES},
        'each_as_hypothesis_in_statement': {p: sum(1 for t in T if p in t['premise_hypotheses']) for p in PREMISES},
        'by_count': dict(sorted(collections.Counter(len(t['premises']) for t in T).items())),
        'all_eight': sum(1 for t in T if len(t['premises']) == 8),
        'predicates_each': {p: sum(1 for t in T if p in set(t['statement']['premise_predicates']) | set(t['proof']['premise_predicates'])) for p in PREMISES},
    }
    agg['master_laws'] = {
        'none': sum(1 for t in T if not t['master_laws']),
        'each': {l['id']: sum(1 for t in T if l['id'] in t['master_laws']) for l in coverage['master_laws']},
        'in_statement': {l['id']: sum(1 for t in T if l['id'] in t['statement']['master_laws']) for l in coverage['master_laws']},
    }
    agg['world_in_statement'] = sum(1 for t in T if t['statement']['world'])
    agg['constructs_in_proof'] = sum(1 for t in T if t['proof']['constructs'])
    agg['constructs_in_statement'] = sum(1 for t in T if t['statement']['constructs'])
    agg['lower_differs_from_upper'] = sum(1 for t in T if set(t['fields']) != set(t['statement']['fields_upper']) | set(t['proof']['fields_upper']))
    agg['destructures_in_proof'] = dict(collections.Counter(c for t in T for c in t['proof']['destructures']))
    agg['destructures_any'] = sum(1 for t in T if t['proof']['destructures'] or t['statement']['destructures'])
    agg['modules'] = {}
    for mod in ('Becoming.ContinuedClasses', 'Becoming.Identity', 'Becoming.Persistence', 'Becoming.Arising', 'Becoming.Change'):
        rows = {n: t for n, t in out.items() if t['module'] == mod}
        agg['modules'][mod] = {
            'theorems': len(rows),
            'groups_uses': collections.Counter(key(t['fields']) for t in rows.values()).most_common(),
            'groups_statement': collections.Counter(key(t['statement']['fields']) for t in rows.values()).most_common(),
            'premises': collections.Counter(key(t['premises']) for t in rows.values()).most_common(),
            'groups_upper': collections.Counter(key(sorted(set(t['statement']['fields_upper']) | set(t['proof']['fields_upper']), key=FIELDS.index)) for t in rows.values()).most_common(),
            'rows': {n: [t['statement']['fields'], t['proof']['fields'], t['premises'], t['master_laws']] for n, t in rows.items()},
        }
    (HERE / 'REPORT-DATA.json').write_text(json.dumps(agg, ensure_ascii=False, indent=1) + '\n')
    print(json.dumps({k: agg[k] for k in ('theorems', 'by_ring', 'missing_anchors', 'packaging_definitions')}, indent=1))


if __name__ == '__main__':
    main(sys.argv[1])
