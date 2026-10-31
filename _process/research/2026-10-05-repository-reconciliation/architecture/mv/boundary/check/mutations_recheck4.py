"""Mutations of the attachment rule for the fourth re-check's fixes (MV's follow-up), kept from the landing's scratch: each mutates one part of tools/research/boundary_check.lean (a copy in SP) or of tools/research/boundary.py (in memory) and runs the boundary tests; each must fail some test. Run from the checkout root:
  python3 -B <this file> SP all > mutations-recheck4.log
"""
import io, re, sys, unittest
from pathlib import Path
sys.path.insert(0, '.')
from tools.research import boundary
from tools.research.tests import test_boundary as tb
SP = Path(sys.argv[1])  # a scratch folder for the mutated Lean copies
src = boundary.CHECK.read_text()
LEAN = {
 'no brecOn_N': ('(b == "brecOn" || ("brecOn_".toList.isPrefixOf b.toList && digits (b.toList.drop 7)))', '(b == "brecOn")'),
 'no _sizeOf_N_eq': ('numbered "_sizeOf_" || sizeOfEq ||', 'numbered "_sizeOf_" ||'),
 'no nested ind names': ('|| numbered "brecOn_" || numbered "below_" || numbered "rec_" ||', '||'),
 'induct any kind': ('"mutual_induct", "mutual_induct_unfolding", "fun_cases", "fun_cases_unfolding"].contains s then k == "def"',
                     '"mutual_induct", "mutual_induct_unfolding", "fun_cases", "fun_cases_unfolding"].contains s then k != ""'),
 'no induct names': (', "induct", "induct_unfolding",\n       "mutual_induct", "mutual_induct_unfolding", "fun_cases", "fun_cases_unfolding"]', ']'),
 'unsafe_rec any kind': ('else if s == "_unsafe_rec" then k == "def" || k == "opaque"', 'else if s == "_unsafe_rec" then k != ""'),
 'rec_N on def': ('numbered "rec_" ||\n', 'false ||\n'),
}
def py_aux(pattern_has, extra):
    def f():
        boundary.AUX = tuple((p, k + extra) if pattern_has in p.pattern else (p, k) for p, k in boundary.AUX)
    return f
def py_drop(pattern_from, to):
    def f():
        boundary.AUX = tuple((re.compile(p.pattern.replace(pattern_from, to)), k) for p, k in boundary.AUX)
    return f
PY = {
 'py no printed': lambda: setattr(boundary, 'printed', lambda c: '.'.join(c)),
 'py BRECON plain': lambda: setattr(boundary, 'BRECON', re.compile(r'brecOn')),
 'py no _sizeOf_N_eq': py_drop(r'_sizeOf_\d+(_eq)?', r'_sizeOf_\d+'),
 'py no induct': py_drop(r'|(mutual_)?induct(_unfolding)?|fun_cases(_unfolding)?', ''),
 'py induct on thm': py_aux('induct', ('thm', 'ind', 'opaque')),
 'py unsafe_rec any': py_aux('_unsafe_rec', ('thm', 'ind', 'ctor')),
 'py arg_pusher on opaque': lambda: setattr(boundary, 'AUX', boundary.AUX + ((re.compile('_arg_pusher'), ('opaque', 'thm')),)),
 'py rec_N on def': py_aux('rec(_', ('def',)),
 'py no did-not-run note': lambda: setattr(boundary, 'D2_UNDECLARED', 'never matches: '),
}
which = sys.argv[2]
if which == 'all':  # each mutation in a fresh process, one line each
    import subprocess
    for k in list(LEAN) + list(PY):
        print(subprocess.run([sys.executable, '-B', __file__, str(SP), k], capture_output=True, text=True).stdout.strip()
              or f'{k}: did not run', flush=True)
    sys.exit()
if which in LEAN:
    a, b = LEAN[which]
    assert src.count(a) == 1, which
    m = SP / f'check-{re.sub(r"[^a-z0-9]+", "-", which)}.lean'
    m.write_text(src.replace(a, b))
    boundary.CHECK = m
    classes = [tb.TheLeanCheck]
else:
    PY[which]()
    classes = [tb.TheTerms, tb.TheDerivedChecks, tb.TheReport, tb.TheLeanCheck]
suite = unittest.TestSuite(unittest.defaultTestLoader.loadTestsFromTestCase(c) for c in classes)
r = unittest.TextTestRunner(stream=io.StringIO(), verbosity=0).run(suite)
bad = [t.id().split('.')[-1] for t, _ in r.failures + r.errors]
print(f'{which}: {"CAUGHT" if bad else "MISSED"} ({r.testsRun} run) {bad}')
