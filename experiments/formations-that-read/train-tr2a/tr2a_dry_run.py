"""The dry run of TR2's Stage A (FREEZE-11): python3 -B tr2a_dry_run.py, writing results/dry-run.json.

It runs no training of the plan. Through tr2a.py's own functions it checks:
  - the plan: its trainings, the data's hashes, every schedule's read set;
  - that each forbidden case is counted where it is planted: F1 by a network whose act reads more than its state, F2 by
    one whose state reads more than its input, F3 by a content-only architecture the cue leaks into;
  - that a planted twin is counted: a network acting as the content act with the cue up and otherwise with it down is a
    twin at the cue at every uncovered occasion under S1, and none under the content-only input;
  - that the measured coverage is the read set's own (recomputed apart from the network), and Stage 0's expectation
    the mean over schedules (coverage_exact against an enumeration of tr2's own);
  - that a training is the same twice (determinism), and a run on a small plan writes its readout once;
  - the refusals: a frozen file changed, uncommitted, or missing from FROZEN.sha256; another platform; a readout already
    there; python3 -O;
  - and it times one training at the plan's sizes on a seed outside the plan, to project the run's time."""
import hashlib
import json
import subprocess
import sys
import tempfile
import time
from fractions import Fraction as Fr
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import tr2a as T  # noqa: E402

OUT = HERE / 'results' / 'dry-run.json'


def refused(fn, why):
    try:
        fn()
    except SystemExit as e:
        return why in str(e)
    return False


class Planted(T.Net):
    """A network that is not trained; its acts and states as each test plants them."""
    mode = None

    def train(self, data, epochs, rate):
        self.calls = 0

    def state(self, x):
        if self.mode == 'state reads more than its input':
            self.calls = getattr(self, 'calls', 0) + 1
            return tuple(x) + (self.calls,)
        return tuple(x)

    def act(self, h):
        if self.mode == 'act reads more than its state':
            self.calls = getattr(self, 'calls', 0) + 1
            return self.calls % 2
        if self.mode in ('twin at the cue', 'cue leaks'):
            k = PLANT_INDEX[tuple(h[:T.DIM])]
            cue = h[T.DIM] if len(h) > T.DIM else 1.0
            return PLANT_ACT[k] if cue == 1.0 else 1 - PLANT_ACT[k]
        k = PLANT_INDEX[tuple(h[:T.DIM])]
        return PLANT_ACT[k]

    def out(self, h):
        return float(self.act(h))


PLANT_INDEX, PLANT_ACT = {}, []


def planted(mode):
    return type('P', (Planted,), {'mode': mode})


def leaky(arch, o, vec):
    """The content-only architecture with the cue leaking in."""
    return tuple(vec[o[1]]) + (float(o[0]),)


def main():
    out = {}
    vec, lin = T.contents('linear')
    _, xor = T.contents('xor')
    PLANT_INDEX.update({tuple(v): k for k, v in enumerate(vec)})
    PLANT_ACT[:] = lin
    p = T.plan()
    out['the plan'] = {'trainings': len(p), 'distinct': len(set(p)) == len(p),
                       'no seed of the plan below SEED_BASE (seeds 0 to 3 were trained in development)':
                           min(k for *_, k in p) == T.SEED_BASE >= 4,
                       'content vectors sha256': hashlib.sha256(json.dumps(vec).encode()).hexdigest(),
                       'linear act ones': sum(lin), 'xor act ones': sum(xor)}
    occ = T.occasions()
    sched = {}
    for s in T.SCHEDULES:
        reads = [T.schedule(s, occ, k) for k in range(T.SEED_BASE, T.SEED_BASE + T.SEEDS)]
        sched[s] = {'reads, each seed': [len(x) for x in reads],
                    'S1 is the cue-up occasions': s != 'S1' or all(x == {o for o in occ if o[0] == 1} for x in reads),
                    'S3 holds every cue-up occasion': s != 'S3' or all({o for o in occ if o[0] == 1} <= x for x in reads),
                    'seeds give different draws': s == 'S1' or len({frozenset(x) for x in reads}) == len(reads)}
    out['schedules'] = sched

    # forbidden cases, planted
    f = {}
    r = T.train_one('linear', 'content-and-cue', 'S1', 0, vec, lin, net_cls=planted('act reads more than its state'))
    f['F1 counted where the act reads more than its state'] = r['forbidden']['F1'] > 0
    r = T.train_one('linear', 'content-and-cue', 'S1', 0, vec, lin, net_cls=planted('state reads more than its input'))
    f['F2 counted where the state reads more than its input'] = r['forbidden']['F2'] > 0
    r = T.train_one('linear', 'content-only', 'S1', 0, vec, lin, net_cls=planted('cue leaks'), inputs_fn=leaky)
    f['F3 counted where the cue leaks into the content-only input'] = r['forbidden']['F3'] > 0
    clean = [T.train_one('linear', a, s, 0, vec, lin, net_cls=planted(None)) for a in T.ARCHS for s in T.SCHEDULES]
    f['none counted by a network acting as the content act'] = all(x['forbidden'] == {'F1': 0, 'F2': 0, 'F3': 0}
                                                                   for x in clean)
    out['forbidden cases'] = f

    # a planted twin
    tw = {}
    r = T.train_one('linear', 'content-and-cue', 'S1', 0, vec, lin, net_cls=planted('twin at the cue'))
    tw['under S1, a twin at every uncovered occasion'] = (r['fits the readings'] and r['covered'] == 0
                                                         and r['twin at the cue'] == r['uncovered, content read'] == 192)
    tw['and its acts apart at every pair'] = r['links']['acts apart'] == r['links']['pairs'] == 192
    r2 = T.train_one('linear', 'content-and-cue', 'S2', 0, vec, lin, net_cls=planted('twin at the cue'))
    tw['under S2 it acts otherwise at read cue-down occasions, so fits nothing and is no twin'] = (
        not r2['fits the readings'] and r2['twin at the cue'] == 0 and r2['read acts wrong'] > 0)
    r3 = T.train_one('linear', 'content-only', 'S1', 0, vec, lin, net_cls=planted('twin at the cue'))
    tw['none under the content-only input'] = r3['twin at the cue'] == 0 and r3['covered'] == r3['unread']
    out['planted twin'] = tw

    # coverage: the measured is the read set's own; Stage 0's expectation the schedules' mean
    cv = {}
    for a in T.ARCHS:
        for s in T.SCHEDULES:
            ok = True
            for k in range(3):
                r = T.train_one('linear', a, s, k, vec, lin, net_cls=planted(None))
                read = T.schedule(s, occ, k)
                lump = (lambda o: (o[0], o[1])) if a == 'content-and-cue' else (lambda o: o[1])
                want = sum(1 for o in occ if o not in read and any(lump(d) == lump(o) for d in read))
                ok &= r['covered'] == want
            cv[f'{a}, {s}: measured coverage is the read set\'s'] = ok
    enum = T.tr2.coverage_enumerated()
    cv['Stage 0: coverage_exact against its enumeration'] = all(
        str(v) == T.tr2.coverage_exact(3, Fr(1, 3))[lk][sk] for (lk, sk), v in _pairs(enum))
    out['coverage'] = cv

    # determinism and the run written once
    dt = {}
    a1 = T.train_one('xor', 'content-and-cue', 'S2', -1, vec, xor, epochs=20)
    a2 = T.train_one('xor', 'content-and-cue', 'S2', -1, vec, xor, epochs=20)
    dt['a training is the same twice'] = json.dumps(a1, sort_keys=True) == json.dumps(a2, sort_keys=True)
    with tempfile.TemporaryDirectory() as tmp:
        o = Path(tmp) / 'run.json'
        small = [('linear', 'content-and-cue', 'S1', -1), ('xor', 'content-only', 'S2', -2)]
        rd = T.run(out=o, trainings=small, frozen=lambda: {'(dry)': '0'}, plat=lambda: {'(dry)': True}, epochs=5)
        dt['a run on a small plan writes its readout'] = o.exists() and len(rd['trainings']) == 2 and \
            json.loads(o.read_text())['summary'] == rd['summary']
        dt['a readout there: refused'] = refused(lambda: T.run(out=o, trainings=small, frozen=lambda: {},
                                                               plat=lambda: {}), 'written once')
    out['the run'] = dt

    # refusals
    rf = {}
    with tempfile.TemporaryDirectory() as tmp:
        root = Path(tmp)
        sub = root / 'x'
        sub.mkdir()
        (sub / 'a.py').write_text('a = 1\n')
        fz = sub / 'FROZEN.sha256'
        git = lambda *a: subprocess.run(['git', '-C', str(root), *a], capture_output=True, text=True, check=True)  # noqa: E731
        git('init', '-q')
        git('config', 'user.email', 'dry@run')
        git('config', 'user.name', 'dry run')
        rf['no FROZEN.sha256: refused'] = refused(lambda: T.frozen_check(fz, root), 'no FROZEN.sha256')
        fz.write_text(f"{T.sha(sub / 'a.py')}  x/a.py\n")
        git('add', '-A')
        git('commit', '-q', '-m', 'freeze')
        rf['committed and unchanged: read'] = T.frozen_check(fz, root) == {'x/a.py': T.sha(sub / 'a.py')}
        (sub / 'a.py').write_text('a = 2\n')
        rf['a frozen file changed: refused'] = refused(lambda: T.frozen_check(fz, root), 'differs from FROZEN.sha256')
        (sub / 'a.py').write_text('a = 1\n')
        fz.write_text(fz.read_text() + '\n')
        rf['FROZEN.sha256 itself uncommitted: refused'] = refused(lambda: T.frozen_check(fz, root), 'uncommitted or changed')
        git('checkout', '-q', '--', 'x/FROZEN.sha256')
        (sub / 'b.py').write_text('b = 1\n')
        fz.write_text(fz.read_text() + f"{T.sha(sub / 'b.py')}  x/b.py\n")
        git('add', 'x/FROZEN.sha256')
        git('commit', '-q', '-m', 'list b')
        rf['a listed file not committed: refused'] = refused(lambda: T.frozen_check(fz, root), 'uncommitted or changed')
    rf['another platform: refused'] = refused(lambda: T.platform_check({'python': '0.0', 'machine': 'x', 'system': 'y'}),
                                              'the platform is')
    opt = subprocess.run([sys.executable, '-O', '-c', 'import tr2a'], cwd=HERE, capture_output=True, text=True)
    rf['python3 -O: refused'] = opt.returncode != 0 and 'without -O' in opt.stderr
    out['refusals'] = rf

    # the time of one training at the plan's sizes, on a seed outside the plan
    t0 = time.time()
    T.train_one('xor', 'content-and-cue', 'S2', -3, vec, xor)
    one = time.time() - t0
    out['time'] = {'one training at the plan\'s sizes, seconds': round(one, 2),
                   'the plan\'s trainings': len(p), 'projected seconds': round(one * len(p))}

    checks = {k: v for sec in out.values() if isinstance(sec, dict) for k, v in sec.items() if isinstance(v, bool)}
    out['ok'] = all(checks.values())
    out['checks'] = len(checks)
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(out, indent=1) + '\n')
    for k, v in checks.items():
        if not v:
            print('FAIL', k)
    print('dry run:', 'ok' if out['ok'] else 'FAILED', out['checks'], 'checks;', out['time'])
    return 0 if out['ok'] else 1


def _pairs(enum):
    m = {'cue couples in': 'lumping (cue, content): the cue couples in',
         'content only': 'lumping (content): the cue does not couple in'}
    s = {'S2': 'S2', 'S3': 'S3 (cue-down unread)'}
    for key, v in enum.items():
        lname, sname = key.split(', ')
        yield (m[lname], s[sname]), v


if __name__ == '__main__':
    sys.exit(main())
