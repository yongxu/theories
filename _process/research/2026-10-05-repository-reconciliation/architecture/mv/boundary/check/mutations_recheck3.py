"""Mutations of the attachment rule for the third re-check's fixes (MV's follow-up), kept from the landing's scratch: each mutates one part of tools/research/boundary_check.lean (a copy in SP) or of tools/research/boundary.py (in memory) and runs the boundary tests; each must fail some test. Run from the checkout root:
  python3 -B <this file> SP all > mutations-recheck3.log
Two anchors ('no _arg_pusher', 'eq_N on opaque') are those of the line the fourth re-check rewrote (it added the
functional induction and cases names), the same mutations on the current text.
"""
import io, re, sys, unittest
from pathlib import Path
sys.path.insert(0, '.')
from tools.research import boundary
from tools.research.tests import test_boundary as tb
SP = Path(sys.argv[1])  # a scratch folder for the mutated Lean copies
src = boundary.CHECK.read_text()
LEAN = {
 'inj on ind': ('then k == "ctor"\n', 'then k == "ctor" || k == "ind"\n'),
 'proof/match any kind': ('if ["_proof_", "proof_"].any (fun p => (after p).any numerals) then ["def", "opaque", "thm", "ind"].contains k\n  else if (after "match_").any numerals then ["def", "opaque", "thm"].contains k',
                          'if ["_proof_", "proof_", "match_"].any (fun p => (after p).any numerals) then true\n  else if false then true'),
 'opaque as def': ('| some (.opaqueInfo _) => "opaque"', '| some (.opaqueInfo _) => "def"'),
 'brecOn any kind': ('kindOf env p\' == "def" && (s == "go"', 'true && (s == "go"'),
 'no macro scopes': ('  match v.name with\n  | .str p s =>\n    let p\' := sc p\n', '  match n with\n  | .str p s =>\n    let p\' := p\n'),
 'no _arg_pusher': ('"_default", "_arg_pusher", "induct"', '"_default", "induct"'),
 '_proof_N not on ind': ('["def", "opaque", "thm", "ind"].contains k', '["def", "opaque", "thm"].contains k'),
 'eq_N on opaque': ('"fun_cases_unfolding"].contains s then k == "def"', '"fun_cases_unfolding"].contains s then k == "def" || k == "opaque"'),
}
PY = {
 'py inj on ind': lambda: setattr(boundary, 'AUX', tuple((p, k + ('ind',)) if 'inj' in p.pattern else (p, k) for p, k in boundary.AUX)),
 'py proof on ctor': lambda: setattr(boundary, 'AUX', tuple((p, k + ('ctor',)) if 'proof' in p.pattern else (p, k) for p, k in boundary.AUX)),
 'py match on ind': lambda: setattr(boundary, 'AUX', tuple((p, k + ('ind',)) if p.pattern.startswith('match') else (p, k) for p, k in boundary.AUX)),
 'py no opaque': lambda: setattr(boundary, 'AUX', tuple((p, tuple(x for x in k if x != 'opaque')) for p, k in boundary.AUX)),
 'py eq on opaque': lambda: setattr(boundary, 'AUX', tuple((p, k + ('opaque',)) if p.pattern.startswith('eq_') else (p, k) for p, k in boundary.AUX)),
 'py no supplied kinds': lambda: setattr(boundary.Terms, 'supplied', lambda self, kinds: self),
 'py no hygiene': lambda: setattr(boundary, 'hygienic', lambda n: (n, '')),
 'py brecOn any kind': None,
}
which = sys.argv[2]
if which == 'all':  # each mutation in a fresh process, one line each
    import subprocess
    for k in list(LEAN) + list(PY):
        r = subprocess.run([sys.executable, '-B', __file__, str(SP), k], capture_output=True, text=True)
        print(r.stdout.strip() or f'{k}: did not run: ' + (r.stderr.strip().splitlines() or ['no output'])[-1], flush=True)
    sys.exit()
if which in LEAN:
    a, b = LEAN[which]
    assert src.count(a) == 1, which
    m = SP / f'check-{re.sub(r"[^a-z]+", "-", which)}.lean'
    m.write_text(src.replace(a, b))
    boundary.CHECK = m
    classes = [tb.TheLeanCheck]
else:
    orig = (boundary.AUX, boundary.Terms.supplied, boundary.hygienic)
    if which == 'py brecOn any kind':
        import inspect
        code = inspect.getsource(boundary.Terms.aux).replace("self.kind_of(prefix) == 'def' and c[-1]", "c[-1]")
        ns = {}
        exec('import boundary_dummy\n' if False else '', ns)
        exec(compile('\n'.join(l[4:] for l in code.splitlines()), 'aux', 'exec'), {**vars(boundary)}, ns)
        boundary.Terms.aux = ns['aux']
    else:
        PY[which]()
    classes = [tb.TheTerms, tb.TheDerivedChecks, tb.TheReport, tb.TheLeanCheck]
suite = unittest.TestSuite(unittest.defaultTestLoader.loadTestsFromTestCase(c) for c in classes)
r = unittest.TextTestRunner(stream=io.StringIO(), verbosity=0).run(suite)
bad = [t.id().split('.')[-1] for t, _ in r.failures + r.errors]
print(f'{which}: {"CAUGHT" if bad else "MISSED"} ({r.testsRun} run) {bad}')
