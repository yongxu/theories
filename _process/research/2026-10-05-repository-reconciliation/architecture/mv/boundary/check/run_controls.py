"""MV's boundary field: run tools/research/boundary_check.lean on U4's two forms and the controls.

python3 -B run_controls.py U4_BUILD [WORK]

U4_BUILD is the .build folder of U4's boundary-scratch, built by its run_check.sh (U4 at fe2a1942b). The script
compiles BoundaryCheckControls.lean (beside it) against that build into WORK (default: a temporary folder), runs the
check on row 17, row 5 and the controls, and exits non-zero unless each case fails exactly as expected
(controls-run.log is its output on 31 October 2026, after the discharge condition counted a package's
definitions of propositions as proofs and test 3's message named the hypotheses; the same output again after the walk
read term positions only and went through generated auxiliaries)."""
import copy, json, os, subprocess, sys, tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
CHECK = HERE.parents[6] / 'tools/research/boundary_check.lean'
U4B = Path(sys.argv[1]).resolve()
B = Path(sys.argv[2]).resolve() if len(sys.argv) > 2 else Path(tempfile.mkdtemp(prefix='boundary-check-'))
T = Path.home() / '.elan/toolchains/leanprover--lean4---v4.29.1'
U, C = 'Becoming.U4Boundary.', 'Becoming.BoundaryCheckControls.'

def hyp(h, cm, fit):
    return {'hypothesis': h, 'countermodel': cm, 'fit': fit}

F5, F17 = U + 'descent_forms_no_dependence', U + 'outside_leaves_no_offspring'
row5 = {'row': 'Becoming.Flow.no_new_dependence', 'form': F5,
        'hypotheses': [hyp(U + 'GivenTo', F5 + '.needs_given', F5 + '.given_needed'),
                       hyp(U + 'Inherits', F5 + '.needs_inherits', F5 + '.inherits_needed'),
                       hyp(U + 'UndependedFrom', F5 + '.needs_undepended', F5 + '.undepended_needed')],
        'recovery': U + 'no_new_dependence_at_model', 'certificate': U + 'no_new_dependence_certified'}
row17 = {'row': 'Becoming.GroupEnding.Flow.all_end', 'form': F17,
         'hypotheses': [hyp(U + 'GivesFrom', F17 + '.needs_gate', F17 + '.gate_needed'),
                        hyp(U + 'ListedWithin', F17 + '.needs_descent', F17 + '.descent_needed'),
                        hyp(U + 'Outside', F17 + '.needs_outside', F17 + '.outside_needed')],
         'recovery': U + 'all_end_at_model', 'certificate': U + 'all_end_certified'}

def changed(e, **kw):
    e = copy.deepcopy(e)
    for k, v in kw.items():
        if k.startswith('h0_'):
            e['hypotheses'][0][k[3:]] = v
        elif k.startswith('h1_'):
            e['hypotheses'][1][k[3:]] = v
        else:
            e[k] = v
    return e

holds = {'row': 'Becoming.GroupEnding.Flow.all_end', 'form': C + 'holds_form',
         'hypotheses': [hyp(C + 'Holds', C + 'holds_form.needs_holds', C + 'holds_form.holds_needed')],
         'recovery': C + 'all_end_by_holds', 'certificate': C + 'all_end_by_holds_certified'}

# (label, entry, expected failure fragments; [] means the entry must pass, and 'only' that no other test fails)
CASES = [
    ('row 17', row17, [], True),
    ('row 5: the discharge condition fails', row5, ['the discharge condition fails: the recovery uses [Becoming.Flow.descends_of_comes]'], True),
    ('row 17, its certificate in the other order', changed(row17, certificate=C + 'all_end_certified_reversed'), [], True),
    ('a row checked as a form', changed(row17, form='Becoming.GroupEnding.Flow.all_end'),
     ['the form\'s statement names constants neither admitted nor its hypotheses'], False),
    ('a repeated countermodel', changed(row17, h0_countermodel=F17 + '.needs_descent'),
     ['the countermodels are not distinct', 'is not ¬ Becoming.U4Boundary.outside_leaves_no_offspring without Becoming.U4Boundary.GivesFrom'], False),
    ('a countermodel reaching the form', changed(row17, h0_countermodel=C + 'needs_gate_through_form'),
     ['the countermodel Becoming.BoundaryCheckControls.needs_gate_through_form reaches the form or the row'], False),
    ('the prelude\'s total as a hypothesis', changed(row17, h0_hypothesis='Becoming.total'),
     ['the hypothesis Becoming.total names amounts'], False),
    ('a vacuous countermodel', changed(row5, h0_countermodel=C + 'needs_given_vacuous'),
     ['is not ¬ Becoming.U4Boundary.descent_forms_no_dependence without Becoming.U4Boundary.GivenTo'], False),
    ('a form with an inline amount hypothesis', changed(row5, form=C + 'bounded_form'), ['is not a listed hypothesis'], False),
    ('a fact reaching the form', changed(row17, h0_fit=C + 'gate_needed_through_fact'),
     ['the fact Becoming.BoundaryCheckControls.one_offspring_through_form reaches the form or the row'], False),
    ('a fit not applying the form to its hypothesis', changed(row17, h0_fit=C + 'gate_needed_aside'),
     ['the fit Becoming.BoundaryCheckControls.gate_needed_aside does not apply the form to its hypothesis'], False),
    ('a degenerate form, its one hypothesis its conclusion', holds,
     ['the discharge condition fails: the recovery uses [Becoming.GroupEnding.Flow.all_end]',
      'neither the form\'s statement nor a hypothesis it applies names a «» term of the root'], False),
    ('the degenerate form with the row declared a bridge', changed(holds, bridges=['Becoming.GroupEnding.Flow.all_end']),
     ['the bridge Becoming.GroupEnding.Flow.all_end uses theorems outside the closed set',
      'the bridge Becoming.GroupEnding.Flow.all_end, used by the recovery, is not an equivalence'], False),
    ('an unused bridge', changed(row17, bridges=['Becoming.«一之生»']),
     ['the bridge Becoming.«一之生» is used by neither the recovery nor another bridge'], True),
    ('a repeated hypothesis', changed(row17, h1_hypothesis=U + 'GivesFrom'),
     ['the hypotheses are not distinct'], False),
    ('a certificate of another shape', changed(row17, certificate=C + 'all_end_vacuous'),
     ['is not @Becoming.GroupEnding.Flow.all_end = @Becoming.U4Boundary.all_end_at_model'], True),
    ('a recovery applying the form under a have', changed(row17, recovery=C + 'all_end_through_have', certificate=C + 'all_end_through_have_certified'),
     ['is not, under its binders, the form applied'], True),
    ('a certificate at a specialized universe', changed(row17, row=C + 'rowU', recovery=C + 'atType', certificate=C + 'certAtZero'),
     ['the certificate states the row at a specialized universe'], False),
    ('a recovery through a declared bridge', changed(row17, recovery=C + 'all_end_by_bridge', certificate=C + 'all_end_by_bridge_certified', bridges=[C + 'swap_bridge']), [], True),
    ('the same recovery, its bridge undeclared', changed(row17, recovery=C + 'all_end_by_bridge', certificate=C + 'all_end_by_bridge_certified'),
     ['the discharge condition fails: the recovery uses [Becoming.BoundaryCheckControls.swap_bridge]'], True),
    ('a name not in the environment', changed(row17, recovery=U + 'no_such_recovery'), ['not in the environment'], True),
]
NAMES = {'Nat': True, 'Becoming.total': True, 'Becoming.«际»': True, 'Becoming.«则»': True,
         'Generative.Process': False, 'Becoming.Flow.taken': False, 'Becoming.U4Boundary.GivenTo': False,
         C + '«不在文法»': False, 'Lean.Json': False, 'Std.HashMap': False}

(B / 'out').mkdir(parents=True, exist_ok=True)
build = subprocess.run([str(T / 'bin/lean'), '-R', str(HERE), '-o', str(B / 'out/BoundaryCheckControls.olean'),
                        str(HERE / 'BoundaryCheckControls.lean')], env={**os.environ, 'LEAN_PATH': f'{U4B}:{T / "lib/lean"}'},
                       text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
if build.returncode:
    sys.exit(build.stdout)
work = B / 'work'
work.mkdir(exist_ok=True)
src = CHECK.read_text().replace('import Lean\n', 'import Lean\nimport Becoming.U4Boundary\nimport BoundaryCheckControls\n', 1)
(work / 'boundary_check.lean').write_text(src)
(work / 'in.json').write_text(json.dumps({'entries': [c[1] for c in CASES], 'names': list(NAMES)}, ensure_ascii=False))
env = {**os.environ, 'LEAN_PATH': f'{B / "out"}:{U4B}:{T / "lib/lean"}',
       'BOUNDARY_CHECK_IN': str(work / 'in.json'), 'BOUNDARY_CHECK_OUT': str(work / 'out.json')}
p = subprocess.run([str(T / 'bin/lean'), 'boundary_check.lean'], cwd=work, env=env, text=True,
                   stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
print(p.stdout)
if p.returncode:
    sys.exit('lean failed')
out = json.loads((work / 'out.json').read_text())
bad = 0
for (label, _, expected, only), r in zip(CASES, out['entries']):
    fs = r['failures']
    ok = (not fs) if not expected else all(any(x in f for f in fs) for x in expected) and (not only or len(fs) == len(expected))
    bad += not ok
    print(('ok  ' if ok else 'FAIL'), label)
    for f in fs[:4]:
        print('      ', f[:220])
    if len(fs) > 4:
        print('       … and', len(fs) - 4, 'more')
for n, want in NAMES.items():
    got = out['admitted'][n]
    bad += got != want
    print(('ok  ' if got == want else 'FAIL'), 'admitted', n, got)
sys.exit(1 if bad else 0)
