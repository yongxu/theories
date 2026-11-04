"""TR2's Stage A (board item TR2A; FREEZE-11): small networks trained only on the read occasions of each schedule.

    python3 -B tr2a.py check    # the freeze's files against FROZEN.sha256, and the platform; writes nothing
    python3 -B tr2a.py run      # on Ren's yes: every training of the plan, then results/run.json, written once

What it does. Occasions are (cue, content, copy), as in Stage 0 (tr2.py): J contents, the cue up or down, R copies of
each input that do not couple in. Each content has a fixed vector and a fixed act, the content act (CONTENT_ACT). For
each architecture, schedule and seed (PLAN), a network is trained by gradient descent only on the occasions the schedule
reads, with the content act as their label, and then every occasion is passed through it. Two architectures: one whose
input is the content alone (the cue does not couple in) and one whose input is the content and the cue (it does). Three
schedules: S1 reads exactly the cue-up occasions (the witness's schedule), S2 each occasion with chance 1/2 apart from
the cue, S3 the cue-up occasions and each cue-down occasion with chance RHO.

What it measures. The chain, link by link, at every unread cue-down occasion u = (down, k, q) against (up, k, q), the
cue toggled alone with the content and copy fixed: couplings apart (the inputs differ), states apart (the hidden layer
differs, exactly, as Python floats), acts apart (the greedy acts differ). Coverage, at every unread occasion: covered
where some read occasion's state equals its state exactly (the measured lumping). The uncovered occasions are of two
kinds. Where the content is read at some occasion and only the cue keeps u's lump unread, a network that acts as the
content act at every read occasion (it fits the readings) and otherwise at u has a twin installed by training, at the
cue: nothing the readings show fixes the act there (Learning.free_lumped), and RF2 predicts nothing of whether training
installs one (realizability). Where the content is read nowhere (S2 only), an act other than the content act is
generalization to an unseen content, reported apart. The changed share (an unread act other than the content act) is,
under S1 with the contents matched, the misled share of a reader whose class reads the content alone. Nothing is
tested: every share is reported with its seeds, no verdict.

Forbidden cases, counted in every training (the chain, Becoming.Unread; F1 and F2 at every pair of occasions, F3 at
every unread occasion):
  F1, acts apart with states exactly equal (state_apart_of_acts_apart: the act reads the state alone);
  F2, states apart with inputs equal (coupling_apart_of_state_apart: the state reads the input alone);
  F3, for the content-only network, an unread occasion acting otherwise than a read occasion of the same content
      (Learning.lumped_determines, the lumping the content).
Each holds by the code's construction; met, it shows a fault of the implementation, and the run records it.

The run is deterministic: pure Python, seeded, its floating point the platform's IEEE double. A run stopped part way
leaves no readout (at most a run.json.tmp, written over by the next run) and is begun again from nothing; it writes
results/run.json once, atomically, and refuses where one is there. It refuses unless FROZEN.sha256 lists every file
REQUIRED names, each listed file has its bytes and is committed unchanged, FROZEN.sha256 has one commit (a second would
make a new freeze), and the platform is the one PLATFORM names."""
import argparse
import hashlib
import json
import math
import os
import platform
import random
import subprocess
import sys
import time
from fractions import Fraction as Fr
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]           # the repository's root: FROZEN.sha256 lists paths from it
RESULTS = HERE / 'results'
FROZEN = HERE / 'FROZEN.sha256'
REQUIRED = ['experiments/formations-that-read/train-tr2a/tr2a.py', 'experiments/formations-that-read/train-tr2a/tr2a_dry_run.py',
            'experiments/formations-that-read/train-tr2a/results/dry-run.json', 'experiments/formations-that-read/tr2.py']
sys.path.insert(0, str(HERE.parent))
import tr2  # noqa: E402  Stage 0: coverage_exact, the expected coverage by lumping and schedule

if sys.flags.optimize:
    raise SystemExit('refused: run without -O; the checks here are asserts')

# --- the plan, fixed at the freeze ----------------------------------------------------------------------------------
J, DIM, R = 64, 8, 3              # contents, the content vector's dimension, copies of each input
HIDDEN, EPOCHS, RATE = 16, 400, 0.5
RHO = Fr(1, 4)                    # S3's chance of reading a cue-down occasion
SEEDS = 20                        # trainings per content act, architecture and schedule
SEED_BASE = 100                   # the plan's seeds are 100 to 119; seeds 0 to 3 were trained while the code was written
CONTENT_ACTS = ('linear', 'xor')  # the content act: one projection's side, or the parity of two projections' sides
ARCHS = ('content-only', 'content-and-cue')
SCHEDULES = ('S1', 'S2', 'S3')
DATA_SEED = 20261105              # the content vectors and the content act
PLATFORM = {'python': '3.11', 'machine': 'arm64', 'system': 'Darwin'}


def plan():
    """Every training, in the order the run makes them: (content act, architecture, schedule, seed)."""
    return [(c, a, s, k) for c in CONTENT_ACTS for a in ARCHS for s in SCHEDULES for k in range(SEED_BASE, SEED_BASE + SEEDS)]


# --- the data ------------------------------------------------------------------------------------------------------
def contents(kind, j=J, dim=DIM, seed=DATA_SEED):
    """The content vectors (Gaussian, seeded, the same for both acts) and the content act. linear: 1 where a fixed
    direction's projection is above its median, so that half the contents act 1. xor: 1 where exactly one of two fixed
    directions' projections is above its median."""
    rnd = random.Random(seed)
    vec = [[rnd.gauss(0, 1) for _ in range(dim)] for _ in range(j)]
    side = []
    for _ in range(2):
        w = [rnd.gauss(0, 1) for _ in range(dim)]
        proj = [sum(a * b for a, b in zip(v, w)) for v in vec]
        med = sorted(proj)[j // 2 - 1]
        side.append([1 if p > med else 0 for p in proj])
    if kind == 'linear':
        return vec, side[0]
    if kind == 'xor':
        return vec, [p ^ q for p, q in zip(*side)]
    raise ValueError(kind)


def occasions(j=J, r=R):
    return [(c, k, q) for c in (1, 0) for k in range(j) for q in range(r)]


def schedule(name, occ, seed, rho=RHO):
    """The occasions a schedule reads, its chance draws seeded by the training's seed (apart from the network's)."""
    rnd = random.Random(10_007 * seed + {'S1': 1, 'S2': 2, 'S3': 3}[name])
    if name == 'S1':
        return {o for o in occ if o[0] == 1}
    if name == 'S2':
        return {o for o in occ if rnd.random() < 0.5}
    if name == 'S3':
        return {o for o in occ if o[0] == 1 or rnd.random() < float(rho)}
    raise ValueError(name)


def inputs(arch, o, vec):
    """What couples in: the content's vector, and the cue for content-and-cue. The copy never does."""
    c, k, _ = o
    return tuple(vec[k]) + ((float(c),) if arch == 'content-and-cue' else ())


# --- the network ---------------------------------------------------------------------------------------------------
class Net:
    """One hidden layer of tanh units, a sigmoid output. state(x) is the hidden layer; act(x) is 1 where the output
    exceeds 1/2, and reads the state alone."""

    def __init__(self, n_in, hidden, seed):
        rnd = random.Random(seed)
        s = 1 / math.sqrt(n_in)
        self.W1 = [[rnd.gauss(0, s) for _ in range(n_in)] for _ in range(hidden)]
        self.b1 = [0.0] * hidden
        self.W2 = [rnd.gauss(0, 1 / math.sqrt(hidden)) for _ in range(hidden)]
        self.b2 = 0.0

    def state(self, x):
        return tuple(math.tanh(sum(w * v for w, v in zip(row, x)) + b) for row, b in zip(self.W1, self.b1))

    def out(self, h):
        z = sum(w * v for w, v in zip(self.W2, h)) + self.b2
        return 1 / (1 + math.exp(-z)) if z > -700 else 0.0

    def act(self, h):
        return 1 if self.out(h) > 0.5 else 0

    def train(self, data, epochs, rate):
        """Full-batch gradient descent on the mean cross-entropy; data is [(input, label, weight)]: the distinct read
        inputs, each weighted by how many read occasions share it."""
        total = sum(w for _, _, w in data)
        for _ in range(epochs):
            g1 = [[0.0] * len(self.W1[0]) for _ in self.W1]
            gb1 = [0.0] * len(self.b1)
            g2 = [0.0] * len(self.W2)
            gb2 = 0.0
            for x, y, w in data:
                h = self.state(x)
                d = (self.out(h) - y) * w / total
                gb2 += d
                for i, hi in enumerate(h):
                    g2[i] += d * hi
                    dh = d * self.W2[i] * (1 - hi * hi)
                    gb1[i] += dh
                    row = g1[i]
                    for m, xm in enumerate(x):
                        row[m] += dh * xm
            self.b2 -= rate * gb2
            for i in range(len(self.W2)):
                self.W2[i] -= rate * g2[i]
                self.b1[i] -= rate * gb1[i]
                row, grow = self.W1[i], g1[i]
                for m in range(len(row)):
                    row[m] -= rate * grow[m]


# --- one training and its measures ---------------------------------------------------------------------------------
def train_one(kind, arch, sched, seed, vec, cact, j=J, r=R, hidden=HIDDEN, epochs=EPOCHS, rate=RATE, net_cls=Net,
              inputs_fn=inputs):
    occ = occasions(j, r)
    read = schedule(sched, occ, seed)
    distinct = {}
    for o in read:
        x = inputs_fn(arch, o, vec)
        y = cact[o[1]]
        if x in distinct:
            assert distinct[x][0] == y, 'one input, two labels'
            distinct[x][1] += 1
        else:
            distinct[x] = [y, 1]
    data = [(x, y, n) for x, (y, n) in sorted(distinct.items())]
    net = net_cls(len(inputs_fn(arch, occ[0], vec)), hidden, 1_000_003 * seed + (ARCHS.index(arch) if arch in ARCHS else 7))
    net.train(data, epochs, rate)
    return dict(measure(arch, sched, seed, net, occ, read, vec, cact, inputs_fn), **{'content act': kind})


def measure(arch, sched, seed, net, occ, read, vec, cact, inputs_fn=inputs):
    x = {o: inputs_fn(arch, o, vec) for o in occ}
    h = {o: net.state(x[o]) for o in occ}
    a = {o: net.act(h[o]) for o in occ}
    read_states = {}
    for o in read:
        read_states.setdefault(h[o], set()).add(o[1])
    fits = all(a[o] == cact[o[1]] for o in read)
    unread = [o for o in occ if o not in read]
    f1 = f2 = f3 = 0
    for i, o in enumerate(occ):                    # the chain at every pair of occasions
        for p in occ[i + 1:]:
            if a[o] != a[p] and h[o] == h[p]:
                f1 += 1
            if h[o] != h[p] and x[o] == x[p]:
                f2 += 1
    if arch == 'content-only':
        for u in unread:
            if any(d[1] == u[1] and a[d] != a[u] for d in read):
                f3 += 1
    links = {'pairs': 0, 'couplings apart': 0, 'states apart': 0, 'acts apart': 0}
    shift = []                                     # how far toggling the cue alone moves the output
    seen = {o[1] for o in read}
    n = {'covered': 0, 'changed': 0, 'uncovered, content read': 0, 'twin at the cue': 0,
         'uncovered, content unread': 0, 'unseen content changed': 0}
    for u in unread:
        if u[0] == 0:
            up = (1, u[1], u[2])
            links['pairs'] += 1
            links['couplings apart'] += x[u] != x[up]
            links['states apart'] += h[u] != h[up]
            links['acts apart'] += a[u] != a[up]
            shift.append(abs(net.out(h[u]) - net.out(h[up])))
        other = a[u] != cact[u[1]]
        n['changed'] += other
        if h[u] in read_states:
            n['covered'] += 1
        elif u[1] in seen:
            n['uncovered, content read'] += 1
            n['twin at the cue'] += other
        else:
            n['uncovered, content unread'] += 1
            n['unseen content changed'] += other
    return {'arch': arch, 'schedule': sched, 'seed': seed, 'read': len(read), 'unread': len(unread),
            'fits the readings': fits, 'read acts wrong': sum(a[o] != cact[o[1]] for o in read),
            'links': links, 'output shift at the pairs': {'mean': sum(shift) / len(shift) if shift else None,
                                                          'max': max(shift) if shift else None},
            **dict(n, **{'twin at the cue': n['twin at the cue'] if fits else None}),
            'forbidden': {'F1': f1, 'F2': f2, 'F3': f3}}


def summary(rows, r=R, rho=RHO):
    """Per content act, architecture and schedule: the shares, each seed's and their median, with the expected coverage
    of Stage 0 (coverage_exact) beside the measured one. Reported, no verdict."""
    exp = tr2.coverage_exact(r, rho)
    lump = {'content-only': 'lumping (content): the cue does not couple in',
            'content-and-cue': 'lumping (cue, content): the cue couples in'}
    out = {}
    for c, arch, s in [(c, a, s) for c in CONTENT_ACTS for a in ARCHS for s in SCHEDULES]:
        rs = [x for x in rows if x['content act'] == c and x['arch'] == arch and x['schedule'] == s]
        if not rs:
            continue

        def share(key, den='unread'):
            return [str(Fr(x[key], x[den])) if x[den] else None for x in rs]
        cov = share('covered')
        tw = [str(Fr(x['twin at the cue'], x['uncovered, content read']))
              if x['twin at the cue'] is not None and x['uncovered, content read'] else None for x in rs]
        num = [Fr(v) for v in cov if v is not None]
        shifts = [x['output shift at the pairs']['max'] for x in rs if x['output shift at the pairs']['max'] is not None]
        out[f'{c}, {arch}, {s}'] = {
            'trainings': len(rs), 'fit the readings': sum(x['fits the readings'] for x in rs),
            'coverage, each seed': cov, 'coverage, mean': str(sum(num, Fr(0)) / len(num)) if num else None,
            'coverage, expected (Stage 0)': exp[lump[arch]]['S1' if s == 'S1' else 'S2' if s == 'S2' else 'S3 (cue-down unread)'],
            'changed, each seed': share('changed'),
            'twin at the cue, each seed (of the uncovered occasions whose content is read)': tw,
            'twin at the cue, median': median(tw),
            'trainings with a twin at the cue': sum(1 for x in rs if x['twin at the cue']),
            'trainings not fitting the readings (no twin counted)': sum(1 for x in rs if not x['fits the readings']),
            'unseen content changed, each seed': share('unseen content changed', 'uncovered, content unread'),
            'links, summed': {k: sum(x['links'][k] for x in rs) for k in rs[0]['links']},
            'output shift at the pairs, largest': max(shifts) if shifts else None,
            'forbidden': {f: sum(x['forbidden'][f] for x in rs) for f in ('F1', 'F2', 'F3')}}
    return out


def median(vals):
    v = sorted(Fr(x) for x in vals if x is not None)
    if not v:
        return None
    n = len(v)
    return str(v[n // 2] if n % 2 else (v[n // 2 - 1] + v[n // 2]) / 2)


# --- the freeze and the run ----------------------------------------------------------------------------------------
def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def frozen_check(frozen=FROZEN, root=ROOT, required=REQUIRED):
    """The freeze's files: FROZEN.sha256 lists every required file, each line's file has that sha256 and is committed
    with no change, and FROZEN.sha256 itself is committed, in one commit only (a second commit of it would make a new
    freeze). Returns the listed {path: sha256} and {the freeze commit, HEAD}."""
    if not frozen.exists():
        raise SystemExit(f'refused: no {frozen.name}; the freeze is not committed')
    listed = {}
    for line in frozen.read_text().splitlines():
        if line.strip():
            h, p = line.split(None, 1)
            listed[p] = h
    missing = [p for p in required if p not in listed]
    if missing:
        raise SystemExit(f'refused: FROZEN.sha256 does not list {missing}')
    paths = [str(frozen.relative_to(root))] + list(listed)
    for p, h in listed.items():
        if not (root / p).exists() or sha(root / p) != h:
            raise SystemExit(f'refused: {p} differs from FROZEN.sha256')
    git = subprocess.run(['git', '-C', str(root), 'status', '--porcelain', '--', *paths], capture_output=True, text=True)
    tracked = subprocess.run(['git', '-C', str(root), 'ls-files', '--error-unmatch', '--', *paths],
                             capture_output=True, text=True)
    if git.returncode or git.stdout.strip() or tracked.returncode:
        raise SystemExit('refused: a frozen file is uncommitted or changed:\n' + (git.stdout or tracked.stderr))
    rel = str(frozen.relative_to(root))
    commits = subprocess.run(['git', '-C', str(root), 'rev-list', 'HEAD', '--', rel], capture_output=True,
                             text=True).stdout.split()
    if len(commits) != 1:
        raise SystemExit(f'refused: {rel} has {len(commits)} commits; the freeze is the one that added it')
    head = subprocess.run(['git', '-C', str(root), 'rev-parse', 'HEAD'], capture_output=True, text=True).stdout.strip()
    return listed, {'the freeze commit': commits[0], 'HEAD': head}


def platform_check(want=PLATFORM):
    have = {'python': '%d.%d' % sys.version_info[:2], 'machine': platform.machine(), 'system': platform.system()}
    if have != want:
        raise SystemExit(f'refused: the platform is {have}, the freeze names {want}')
    return dict(have, version=platform.python_version(), platform=platform.platform())


def durable(path, data):
    """Write a file whole: a temporary name, synced, renamed, the folder synced."""
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_name(path.name + '.tmp')
    with open(tmp, 'wb') as f:
        f.write(data)
        f.flush()
        os.fsync(f.fileno())
    os.replace(tmp, path)
    fd = os.open(path.parent, os.O_RDONLY)
    try:
        os.fsync(fd)
    finally:
        os.close(fd)


def run(out=RESULTS / 'run.json', trainings=None, frozen=None, plat=None, **kw):
    """Every training of the plan (or of `trainings`), then the readout, written once."""
    if out.exists():
        raise SystemExit(f'refused: {out.name} is there; a run is written once')
    listed, commits = frozen() if frozen else frozen_check()
    have = plat() if plat else platform_check()
    data = {c: contents(c) for c in CONTENT_ACTS}
    started = time.time()
    rows = [train_one(c, a, s, k, *data[c], **kw) for c, a, s, k in (trainings or plan())]
    readout = {'about': 'TR2 Stage A (FREEZE-11): every training of the plan; reported, no verdict.',
               'frozen': listed, 'commits': commits, 'platform': have, 'seconds': round(time.time() - started, 1),
               'plan': {'J': J, 'DIM': DIM, 'R': R, 'HIDDEN': HIDDEN, 'EPOCHS': EPOCHS, 'RATE': RATE, 'RHO': str(RHO),
                        'SEEDS': SEEDS, 'SEED_BASE': SEED_BASE, 'DATA_SEED': DATA_SEED, 'CONTENT_ACTS': list(CONTENT_ACTS)},
               'content act ones': {c: sum(data[c][1]) for c in CONTENT_ACTS}, 'summary': summary(rows), 'trainings': rows}
    durable(out, (json.dumps(readout, indent=1) + '\n').encode())
    return readout


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('cmd', choices=('check', 'run'))
    a = ap.parse_args()
    if a.cmd == 'check':
        listed, commits = frozen_check()
        print(json.dumps({'frozen files': len(listed), **commits, 'platform': platform_check()}, indent=1))
        return 0
    r = run()
    print(json.dumps(r['summary'], indent=1))
    return 0


if __name__ == '__main__':
    sys.exit(main())
