#!/usr/bin/env python3
"""WRP's measure: how much of the layer that reads no field of the old base is stated on processes,
how much of it binds a process or a frame, and which process notions those statements name.

python3 -B measure_wrp.py [--dump PICKLE] [--save PICKLE] [--json OUT]

Uses EC's measure (../ec-elegant-completion/measure.py) to restore the spine's constants from the
checker cache at the checkout's latest core receipt (nothing is compiled). A measurement of Lean
dependency and of the constants a statement names, not of meaning: a statement naming a notion may
use it only through a constructed process.

- **No field.** A spine theorem (core, instance, application and foundation modules of the
  receipt) reads no field of the old base where neither its statement nor its proof reaches,
  transitively, any of the eight World fields in its sixteen projections (`FIELDS`), found by a
  search along the reversed dependencies whose result does not depend on order. Generated lemmas
  (`GEN`, structural recursion's `brecOn` and `below` among them) are dropped. Only projections are
  read: a theorem that builds or matches the four structures through their constructors or
  eliminators alone (e.g. `World.run_world`) counts as reading no field; 18 do at receipt
  `20261029T104256.342764Z`.
- **On processes.** Its statement names one of `PROC`: a process or its step, a trace, enabledness,
  feasibility, a product, a run or its configurations, moves or window, a frame or its process or
  claims, the steps, reach, an invariant, or a deterministic law (`Becoming.Law.*`).
- **Binding.** Its statement's type names `Generative.Process` (it quantifies over, or takes, a
  process), or `Becoming.Frame` and not `Generative.Process` (a frame only).
- **Naming a grammar term** means naming a constant with «» in its name; it misses the grammar
  readings named in English (`moveRel`, `WithinClosure`, `Law.step`).
- **Notions.** The definitions, inductives and constructors, not generated, whose type names a
  process or a frame, named in a binding statement.
- **Bridged.** `LANDED` maps each notion with a landed grammar reading to that reading; `WRP2` to
  the reading WRP2 proposes (its scratch check, check/tree/Becoming/WRPCheck.lean). A binding
  statement is covered where every notion it names is bridged.
"""
import collections, importlib.util, json, re, sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location('ec', HERE.parent / 'ec-elegant-completion/measure.py')
ec = importlib.util.module_from_spec(spec)
spec.loader.exec_module(ec)
ROOT = ec.ROOT
CHECKS = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming/becoming-checks'

FIELDS_AT = ('Dependence.level', 'Dependence.active', 'Dependence.requires', 'Dependence.need', 'Dependence.draws',
             'Flow.present', 'Flow.take', 'Flow.give', 'WebAt.level', 'WebAt.active', 'WebAt.requires', 'WebAt.need',
             'WebAt.draws', 'Exchange.present', 'Exchange.take', 'Exchange.give')
GEN = re.compile(r'(\.injEq|\.inj|\.sizeOf_spec|\.eq_def|\.eq_\d+|\.match_\d+|\.proof_\d+|\.ext_iff|\.ext|\.brecOn|\.below'
                 r'|\.binductionOn)$|\._')
PROC_NAMED = {'Generative.Process', 'Generative.Process.step', 'Generative.Trace', 'Generative.Enabled',
              'Generative.Feasible', 'Generative.productProcess', 'Becoming.Run', 'Becoming.Run.state',
              'Becoming.Run.act', 'Becoming.Run.window', 'Becoming.Frame', 'Becoming.Frame.P',
              'Becoming.Frame.realized', 'Becoming.Steps', 'Becoming.Reach', 'Becoming.Invariant'}
LANDED = {
    'Becoming.Steps': 'the union of the moves\' relations, by definition (Frame)',
    'Generative.Process.step': 'moveRel, by definition (GrammarRegularity)',
    'Becoming.moveRel': 'a relation of the grammar (GrammarRegularity)',
    'Becoming.Reach': 'reach_iff_withinClosure (Frame)',
    'Becoming.Invariant': 'invariant_iff_closedUnder (Frame)',
    'Becoming.Branching.Returns': 'returns_iff_reaches (Recurrence)',
    'Becoming.Branching.Lossless': 'lossless_iff_fixedBefore (Recurrence)',
    'Becoming.Determined': 'determined_iff_fixed (Laws)',
    'Becoming.GoAlikeUnder': 'goAlikeUnder_iff_alike (Laws)',
    'Becoming.GoAlike': 'GoAlikeUnder at equality, by definition (Laws)',
    'Becoming.WithinMoves': 'withinMoves_iff_withinSteps (Labelled)',
    'Becoming.Image': 'image_step_iff, image_determined_iff (Mechanism)',
    'Becoming.Frame.P': 'a frame\'s process, read by its moves\' relations, by definition',
    'Becoming.Frame.mk': 'a process with claims, by definition',
    'Becoming.Frame.realized': 'each claim the partial identity of its predicate, Web.partialIdentity (WorldRepresentation), '
                               'carriers in Type',
}
WRP2 = {
    'Generative.Enabled': 'enabled_iff_neng («能» at the move\'s relation)',
    'Generative.Trace': 'trace_iff_wordRel (the composite along the word)',
    'Generative.Trace.nil': 'trace_iff_wordRel',
    'Generative.Trace.cons': 'trace_iff_wordRel',
    'Generative.Feasible': 'feasible_iff_wordRel',
    'Becoming.Run': 'run_image, run_iff_image',
    'Becoming.Run.state': 'run_image',
    'Becoming.Run.act': 'run_iff_image (the move inside)',
    'Becoming.Run.step': 'run_iff_image',
    'Becoming.Run.mk': 'run_iff_image',
    'Becoming.Onward.KeepsMoving': 'yan_iff_keepsMoving («延»)',
    'Becoming.withMove': 'step_iff_withMove, withMove_image_iff',
    'Becoming.unlabelled': 'steps_unlabelled',
    'Becoming.edgeProcess': 'steps_edgeProcess',
    'Becoming.Law.process': 'steps_lawProcess (Law.step)',
    'Becoming.FactorsThrough': 'factorsThrough_iff_image («像» at each move)',
}


def latest_receipt():
    return sorted(p for p in CHECKS.iterdir() if re.fullmatch(r'\d{8}T\d{6}\.\d+Z', p.name))[-1]


def main():
    C = ec.constants()
    receipt = latest_receipt()
    R = json.load(open(receipt / 'verification.json'))
    spine = set(R['core_modules']) | set(R.get('instance_modules', [])) | set(R.get('application_modules', [])) \
        | set(R.get('foundation_modules', []))
    fields = {n for n in C if n.endswith(FIELDS_AT)}
    assert len(fields) == 16, sorted(fields)
    # What reaches a field: a search from the fields along the reversed dependencies, exact and
    # independent of iteration order.
    users = collections.defaultdict(list)
    for x, d in C.items():
        for y in set(d['t']) | set(d['v']):
            users[y].append(x)
    reaching, frontier = set(fields), list(fields)
    while frontier:
        y = frontier.pop()
        for x in users[y]:
            if x not in reaching:
                reaching.add(x)
                frontier.append(x)

    def reach(n):
        return n in reaching

    law = {x for x in C if x.startswith('Becoming.Law.')}
    proc = PROC_NAMED | law
    source = [n for n, d in C.items() if d['k'] == 'thm' and d['m'] in spine and not GEN.search(n)]
    nofield = [n for n in source if not reach(n)]
    t = {n: set(C[n]['t']) for n in nofield}
    onproc = [n for n in nofield if t[n] & proc]
    lawonly = [n for n in onproc if not (t[n] & PROC_NAMED)]
    binds_process = [n for n in onproc if 'Generative.Process' in t[n]]
    binds_frame = [n for n in onproc if 'Becoming.Frame' in t[n] and 'Generative.Process' not in t[n]]
    binds = binds_process + binds_frame
    on_grammar = [n for n in onproc if any('«' in x for x in t[n])]
    onproc_set = set(onproc)
    other = [n for n in nofield if n not in onproc_set]
    other_on_grammar = [n for n in other if any('«' in x for x in t[n])]
    other_beyond_grammar = [n for n in other if any(x.startswith('Becoming.') and '«' not in x for x in t[n])]
    other_no_becoming = [n for n in other if not any(x.startswith('Becoming.') for x in t[n])]
    beyond = set(other_beyond_grammar)

    def is_notion(y):
        d = C.get(y)
        return bool(d) and d['k'] != 'thm' and not GEN.search(y) and y not in ('Generative.Process', 'Becoming.Frame') \
            and ('Generative.Process' in d['t'] or 'Becoming.Frame' in d['t'] or y == 'Generative.Trace')

    named = {n: {y for y in t[n] if is_notion(y)} for n in binds}
    notions = set().union(*named.values())
    landed = set(LANDED) & (notions | set(LANDED))
    wrp2 = landed | set(WRP2)
    covered_now = [n for n in binds if named[n] <= landed]
    covered_wrp2 = [n for n in binds if named[n] <= wrp2]
    left = collections.Counter(y for n in binds for y in named[n] if y not in wrp2)
    report = {
        'receipt': receipt.name,
        'spine_modules': len(spine),
        'source_theorems': len(source),
        'no_field': len(nofield),
        'on_processes': len(onproc),
        'on_processes_modules': len({C[n]['m'] for n in onproc}),
        'on_processes_through_laws_only': len(lawonly),
        'on_processes_already_naming_a_grammar_term': len(on_grammar),
        'binding_a_process': len(binds_process),
        'binding_a_frame_only': len(binds_frame),
        'binding': len(binds),
        'not_binding': len(onproc) - len(binds),
        'not_on_processes': len(other),
        'not_on_processes_naming_a_grammar_term': len(other_on_grammar),
        'not_on_processes_naming_no_Becoming_constant_beyond_the_grammar': len(other) - len(other_beyond_grammar),
        'of_which_naming_no_Becoming_constant': len(other_no_becoming),
        'of_which_naming_grammar_terms_only': len(other) - len(other_beyond_grammar) - len(other_no_becoming),
        'not_on_processes_beyond_the_grammar': len(beyond),
        'beyond_the_grammar_top_modules': collections.Counter(C[n]['m'] for n in beyond).most_common(12),
        'not_on_processes_top_modules': collections.Counter(C[n]['m'] for n in other).most_common(12),
        'notions_named_in_binding_statements': len(notions),
        'landed_bridged_notions_named': sorted(landed & notions),
        'wrp2_bridged_notions_named': sorted((wrp2 - landed) & notions),
        'covered_now': len(covered_now),
        'covered_with_wrp2': len(covered_wrp2),
        'left': len(binds) - len(covered_wrp2),
        'left_notions': len(left),
        'left_most_named': left.most_common(12),
        'criteria': {'fields': sorted(fields), 'proc_named': sorted(PROC_NAMED), 'law_prefix': 'Becoming.Law.',
                     'landed': LANDED, 'wrp2': WRP2},
    }
    print(json.dumps({k: v for k, v in report.items() if k != 'criteria'}, indent=1, ensure_ascii=False))
    if '--json' in sys.argv:
        Path(sys.argv[sys.argv.index('--json') + 1]).write_text(json.dumps(report, indent=1, ensure_ascii=False) + '\n')


if __name__ == '__main__':
    main()
