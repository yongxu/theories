"""The attachment rule before the fourth re-check's fixes (26977f25a's tools/research/boundary.py) against the
current one, on the latest core receipt's dump: generated auxiliaries, root constants, grammar laws, forwarders and
every theorem's walk, and the theorems outside lists. Run from the checkout root, after shared_laws.py's own checks
pass: python3 -B <this file> [OLD_COMMIT]."""
import importlib.util, json, subprocess, sys, tempfile
from pathlib import Path

ROOT = Path.cwd()
sys.path.insert(0, str(ROOT))
from tools.research import master_laws as ml, boundary as new  # noqa: E402

commit = sys.argv[1] if len(sys.argv) > 1 else '26977f25a'
with tempfile.TemporaryDirectory() as d:
    p = Path(d) / 'boundary_old.py'
    p.write_bytes(subprocess.check_output(['git', 'show', f'{commit}:tools/research/boundary.py']))
    spec = importlib.util.spec_from_file_location('boundary_old', p)
    old = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(old)
mg = ml.load_measure()
C = mg.ec.constants()
laws = getattr(mg, 'ANCHORS', mg.ec.LAWS)
bal = [a for a in laws['balance'] if a in C]
T = {k: m.Terms(C, bal) for k, m in (('old', old), ('new', new))}
out = {'old': commit, 'core_receipt': json.loads(ml.CORE.read_text()).get('utc'), 'constants': len(C)}
for name, f in (('aux', lambda t: sorted(n for n in C if t.aux(n))), ('root', lambda t: sorted(t.root)),
                ('laws', lambda t: sorted(t.laws)), ('forwarders', lambda t: sorted(t.forwarders.items())),
                ('walks', lambda t: {n: sorted(t.walk(n)) for n, x in C.items() if x['k'] == 'thm'})):
    a, b = f(T['old']), f(T['new'])
    out[name] = {'same': a == b, 'count': len(b)}
out['outside'] = sorted(new.outside(C))
out['hygienic'] = sorted(n for n in C if '._@.' in n or '«_@»' in n)
out['kinds'] = sorted({x['k'] for x in C.values()})
print(json.dumps(out, indent=1))
