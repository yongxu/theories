"""Policy-gradient learners for EM1, and one training-and-evaluation run.

CG2's environment, conditions, identity checks and evaluation are reused unchanged
(../commons-outrun, ../commons-gated-renewal).  What changes is the learner: instead of a table of
values over (level, steps left), each learner has a linear softmax policy over eight features of
(level, steps left), so what it learns at one state carries to others, and it is trained on
whole-episode returns (REINFORCE with a Monte Carlo linear baseline), with no bootstrapping from
its own later values.  This is the class of learner CG2's post hoc reading of its joint learner
singles out: a learner that selects each step's action through its own later values is outrun by
its own later acts; one trained on the returns its acts actually led to is not.

Training follows CG2 otherwise: undiscounted, exploring starts (random step, random apples),
30,000 episodes, the reward of each condition as CG2 defines it.  Exploration comes from the
softmax policy itself.  Evaluation is greedy (the most probable action), as CG2's is (eps = 0).
"""

import math
import os
import random
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.append(os.path.join(HERE, "..", "commons-outrun"))
sys.path.append(os.path.join(HERE, "..", "commons-gated-renewal"))
from commons import Commons, isolated_layout  # noqa: E402
from learning import Checks  # noqa: E402

from calibrate import table  # noqa: E402
from learners import OutrunChecks  # noqa: E402

NF = 8


def features(x, tau, H):
    """Eight smooth features of the level x (0..9) and the steps left tau (1..H)."""
    u = x / 9.0
    w = tau / H
    e = 1.0 / tau
    return (1.0, u, u * u, w, w * w, u * w, e, u * e)


class PG:
    def __init__(self, n_actions, H, seed, alpha, beta):
        self.n, self.H, self.alpha, self.beta = n_actions, H, alpha, beta
        self.theta = [[0.0] * NF for _ in range(n_actions)]
        self.w = [0.0] * NF
        self.rng = random.Random(seed)

    def probs(self, phi):
        z = [sum(t * f for t, f in zip(th, phi)) for th in self.theta]
        m = max(z)
        ex = [math.exp(v - m) for v in z]
        s = sum(ex)
        return [v / s for v in ex]

    def act(self, x, tau, greedy):
        phi = features(x, tau, self.H)
        p = self.probs(phi)
        if greedy:
            best = max(p)
            ties = [a for a, q in enumerate(p) if q == best]
            return (ties[0] if len(ties) == 1 else self.rng.choice(ties)), phi
        r = self.rng.random()
        acc = 0.0
        for a, q in enumerate(p):
            acc += q
            if r < acc:
                return a, phi
        return self.n - 1, phi

    def learn(self, traj):
        """traj: list of (phi, action, reward) for one episode, the end reading in the last reward."""
        G = 0.0
        rets = []
        for phi, a, r in reversed(traj):
            G += r
            rets.append(G)
        rets.reverse()
        for (phi, a, _), G in zip(traj, rets):
            b = sum(wi * f for wi, f in zip(self.w, phi))
            d = G - b
            for i in range(NF):
                self.w[i] += self.beta * d * phi[i]
            p = self.probs(phi)
            for k in range(self.n):
                g = (1.0 if k == a else 0.0) - p[k]
                th = self.theta[k]
                for i in range(NF):
                    th[i] += self.alpha * d * g * phi[i]


def run_episode(env, agents, cond, H, learn, start=None, checks=None, outrun=None):
    k, v, lam, share, joint = cond["k"], cond["v"], cond["lam"], cond["share"], cond["joint"]
    env.reset(full=True)
    t0 = 0
    if start is not None:
        t0, apples = start
        env.apple = list(apples)
    xs = [env.level(0)]
    taken, given, got_by = [], [], []
    harvest = [0] * k
    trajs = [[] for _ in agents]
    for t in range(t0, H):
        tau = H - t
        x = xs[-1]
        if joint:
            a, phi = agents[0].act(x, tau, not learn)
            acts, phis = [a], [phi]
            req = list(range(a))
        else:
            pairs = [ag.act(x, tau, not learn) for ag in agents]
            acts = [p[0] for p in pairs]
            phis = [p[1] for p in pairs]
            req = [i for i in range(k) if acts[i]]
        tk, gv, got = env.step([req])
        x2 = env.level(0)
        xs.append(x2)
        taken.append(tk[0])
        given.append(gv[0])
        got_by.append(sorted(got))
        for i in got:
            harvest[i] += 1
        if learn:
            last = tau == 1
            if joint:
                trajs[0].append((phis[0], acts[0], tk[0] + (k * lam * x2 if last else 0.0)))
            else:
                for i in range(len(agents)):
                    own = (tk[0] / k) if share else (1.0 if i in got else 0.0)
                    trajs[i].append((phis[i], acts[i], own + v * x2 + (lam * x2 if last else 0.0)))
    if learn:
        for ag, tr in zip(agents, trajs):
            if tr:
                ag.learn(tr)
    if checks is not None:
        checks.episode(xs, taken, given)
    if outrun is not None and t0 == 0:
        outrun.episode(xs, got_by, given, k)
    return harvest, xs


def train_eval(spec):
    cond, seed, H = spec["cond"], spec["seed"], spec["H"]
    k = cond["k"]
    env = Commons(isolated_layout(1), f"{seed}/train", table=table(cond["s"]))
    if cond["joint"]:
        agents = [PG(k + 1, H, f"{seed}/agent/joint", spec["alpha"], spec["beta"])]
    else:
        agents = [PG(2, H, f"{seed}/agent/{i}", spec["alpha"], spec["beta"]) for i in range(k)]
    checks, outrun = Checks(), OutrunChecks()
    starts = random.Random(f"{seed}/starts")
    for e in range(spec["episodes"]):
        t0 = starts.randrange(H)
        u = starts.random()
        apples = [1 if starts.random() < u else 0 for _ in range(9)]
        run_episode(env, agents, cond, H, True, start=(t0, apples), checks=checks)
    env_eval = Commons(isolated_layout(1), f"{seed}/eval", table=table(cond["s"]))
    for j, ag in enumerate(agents):
        ag.rng = random.Random(f"{seed}/agent/{j}/eval")
    ev = dict(harvest=[], alive_probe=[], final=[], paths=[])
    for e in range(spec["eval_episodes"]):
        h, xs = run_episode(env_eval, agents, cond, H, False, checks=checks, outrun=outrun)
        ev["harvest"].append(h)
        ev["alive_probe"].append(xs[H - spec["probe"]])
        ev["final"].append(xs[H])
        if e < spec.get("keep_paths", 0):
            ev["paths"].append(xs)
    return dict(spec=spec, checks=checks.c, outrun=outrun.c, eval=ev,
                theta=[ag.theta for ag in agents])
