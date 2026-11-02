"""LA4's Stage A learners (design §3, §4): the season vectorized, three policy families, a value network,
Adam, and one REINFORCE update for each arm. numpy only, float64 throughout.

The season is season.py's, its constants imported. A policy observes the step, the ground's level and the
bay's level, each one-hot (28 inputs); the recurrent family also reads its own past act, one-hot (9 more).
Its output is nine logits: the ground's take (0..4), the bay (0, 1) and the site (0, 1), each a softmax.

Families:
  separable    a table of nine logits for each of the 770 states, no parameters shared;
  feedforward  two tanh layers of 64 on one trunk, three heads;
  recurrent    a GRU of 64 reading the observation and its past act, three heads.
Every family is trained by REINFORCE with a separate value network (two tanh layers of 64 on the
observation, no parameters shared with the policy), Adam, no entropy bonus and no weight decay. The
advantage at a step is the reward to go less the value network's estimate there.

Starts: `uniform` sets every output layer to zero; `prudent` sets the output weights to zero and the output
biases to the logarithms of the prudent start's probabilities. The prudent start is the same at every state
and history, so this is the prudent start exactly, with nothing to clone (design §3 asked for a clone within
a tolerance; the exact form needs none).

Arms: the reward (`rising`, `unshared`, `after`, `plateau`), the start, and two changes to the update: `kl`
adds beta times the KL divergence from the policy to the prudent start at each visited state, the visits held
fixed (exact_flow.py's term); `control` updates the bay's and the site's heads with the advantages of an
independent batch of seasons played by the same policy (design §4, C1).

The mirror test needs a run with the site's two values exchanged: `mirror=True` samples the site in the
exchanged order, so that with the same random numbers it lands where the plain run does not, and `exchange`
maps a learner's whole state to its image.
"""

import numpy as np

from season import SEASON, QUOTA, ETA, renew

X, R, K, H, B0, NEED, A = (SEASON[k] for k in ("X", "R", "K", "H", "B0", "NEED", "A"))
NG, NU, NS = K + 1, 2, 2                      # choices at each head
SL = {"ground": slice(0, NG), "bay": slice(NG, NG + NU), "site": slice(NG + NU, NG + NU + NS)}
NOUT = NG + NU + NS                           # nine logits
NOBS = H + (X + 1) + (B0 + 1)                 # 28 one-hot inputs
NACT = NOUT                                   # the past act, one-hot per head
RENEW = np.array([renew(y, X, R) for y in range(X + 1)], dtype=np.int64)
HID = 64
STEP_REWARDS = {
    "rising": lambda ge, ue: ge + ue,
    "unshared": lambda ge, ue: ge + 0.0 * ue,
    "after": lambda ge, ue: ge + ue * B0 / (B0 + 1),   # the season's constant B0/(B0+1) is left out
    "plateau": None,                                    # min(g + k, A), at the season's end
}


def prudent_probs():
    ph = np.array([(1 - ETA) * (h == QUOTA) + ETA / NG for h in range(NG)])
    pu = np.array([(1 - ETA) * (u == 0) + ETA / NU for u in range(NU)])
    ps = np.array([(1 - ETA) * (s == 0) + ETA / NS for s in range(NS)])
    return ph, pu, ps


def start_bias(start):
    if start == "uniform":
        return np.zeros(NOUT)
    return np.concatenate([np.log(p) for p in prudent_probs()])


def one_hot_obs(t, x, b):
    """(M,) arrays of step, ground level and bay level -> (M, 28)."""
    m = len(t)
    o = np.zeros((m, NOBS))
    r = np.arange(m)
    o[r, t] = 1.0
    o[r, H + x] = 1.0
    o[r, H + X + 1 + b] = 1.0
    return o


def act_one_hot(h, u, s):
    m = len(h)
    o = np.zeros((m, NACT))
    r = np.arange(m)
    o[r, h] = 1.0
    o[r, NG + u] = 1.0
    o[r, NG + NU + s] = 1.0
    return o


def log_softmax_heads(z):
    out = np.empty_like(z)
    for sl in SL.values():
        v = z[..., sl]
        m = v.max(axis=-1, keepdims=True)
        lse = m + np.log(np.exp(v - m).sum(axis=-1, keepdims=True))
        out[..., sl] = v - lse
    return out


def dense_init(rng, n_in, n_out):
    """Glorot-uniform weights, zero bias."""
    lim = np.sqrt(6.0 / (n_in + n_out))
    return rng.uniform(-lim, lim, size=(n_in, n_out)), np.zeros(n_out)


# ---------------------------------------------------------------- families

class Separable:
    name = "separable"
    markov = True

    def init(self, rng, start):
        return {"Z": np.tile(start_bias(start), (H, X + 1, B0 + 1, 1))}

    def logits(self, p, t, x, b):
        return p["Z"][t, x, b], (t, x, b)

    def backward(self, p, cache, dz):
        t, x, b = cache
        g = np.zeros_like(p["Z"])
        np.add.at(g, (t, x, b), dz)
        return {"Z": g}


class Feedforward:
    name = "feedforward"
    markov = True

    def init(self, rng, start):
        W1, b1 = dense_init(rng, NOBS, HID)
        W2, b2 = dense_init(rng, HID, HID)
        return {"W1": W1, "b1": b1, "W2": W2, "b2": b2, "W3": np.zeros((HID, NOUT)), "b3": start_bias(start)}

    def logits(self, p, t, x, b):
        o = one_hot_obs(t, x, b)
        h1 = np.tanh(o @ p["W1"] + p["b1"])
        h2 = np.tanh(h1 @ p["W2"] + p["b2"])
        return h2 @ p["W3"] + p["b3"], (o, h1, h2)

    def backward(self, p, cache, dz):
        o, h1, h2 = cache
        g = {"W3": h2.T @ dz, "b3": dz.sum(0)}
        d2 = (dz @ p["W3"].T) * (1 - h2 ** 2)
        g["W2"], g["b2"] = h1.T @ d2, d2.sum(0)
        d1 = (d2 @ p["W2"].T) * (1 - h1 ** 2)
        g["W1"], g["b1"] = o.T @ d1, d1.sum(0)
        return g


class Recurrent:
    """A GRU (r, z, n gates; PyTorch's form) over [observation, past act]; h0 = 0; three heads on h_t."""
    name = "recurrent"
    markov = False
    NIN = NOBS + NACT

    def init(self, rng, start):
        p = {}
        for gname in ("r", "z", "n"):
            p["W" + gname], p["b" + gname] = dense_init(rng, self.NIN, HID)
            p["U" + gname], p["c" + gname] = dense_init(rng, HID, HID)
        p["Wo"], p["bo"] = np.zeros((HID, NOUT)), start_bias(start)
        return p

    def step(self, p, inp, h):
        sig = lambda a: 1.0 / (1.0 + np.exp(-a))
        r = sig(inp @ p["Wr"] + p["br"] + h @ p["Ur"] + p["cr"])
        z = sig(inp @ p["Wz"] + p["bz"] + h @ p["Uz"] + p["cz"])
        hn = h @ p["Un"] + p["cn"]
        n = np.tanh(inp @ p["Wn"] + p["bn"] + r * hn)
        h2 = (1 - z) * n + z * h
        return h2, (inp, h, r, z, n, hn)

    def head(self, p, h):
        return h @ p["Wo"] + p["bo"]

    def backward_seq(self, p, caches, hs, dz):
        """caches[t], hs[t] = h_t for t = 0..H-1 (after the step); dz (N, H, 9)."""
        g = {k: np.zeros_like(v) for k, v in p.items()}
        dh_next = np.zeros_like(hs[0])
        for t in range(len(caches) - 1, -1, -1):
            inp, h, r, z, n, hn = caches[t]
            g["Wo"] += hs[t].T @ dz[:, t]
            g["bo"] += dz[:, t].sum(0)
            dh = dz[:, t] @ p["Wo"].T + dh_next
            dn = dh * (1 - z)
            dzg = dh * (h - n)
            dhprev = dh * z
            dan = dn * (1 - n ** 2)
            g["Wn"] += inp.T @ dan
            g["bn"] += dan.sum(0)
            dr = dan * hn
            dhn = dan * r
            g["Un"] += h.T @ dhn
            g["cn"] += dhn.sum(0)
            dhprev += dhn @ p["Un"].T
            daz = dzg * z * (1 - z)
            dar = dr * r * (1 - r)
            for gname, da in (("z", daz), ("r", dar)):
                g["W" + gname] += inp.T @ da
                g["b" + gname] += da.sum(0)
                g["U" + gname] += h.T @ da
                g["c" + gname] += da.sum(0)
                dhprev += da @ p["U" + gname].T
            dh_next = dhprev
        return g


FAMILIES = {f.name: f for f in (Separable(), Feedforward(), Recurrent())}


class Value:
    """The value network: two tanh layers of 64 on the observation, one output initialized at zero."""

    def init(self, rng):
        W1, b1 = dense_init(rng, NOBS, HID)
        W2, b2 = dense_init(rng, HID, HID)
        return {"W1": W1, "b1": b1, "W2": W2, "b2": b2, "W3": np.zeros((HID, 1)), "b3": np.zeros(1)}

    def forward(self, p, t, x, b):
        return Feedforward.logits(self, p, t, x, b)

    def backward(self, p, cache, dz):
        return Feedforward.backward(self, p, cache, dz)


VALUE = Value()


class Adam:
    def __init__(self, params, lr, b1=0.9, b2=0.999, eps=1e-8):
        self.lr, self.b1, self.b2, self.eps, self.n = lr, b1, b2, eps, 0
        self.m = {k: np.zeros_like(v) for k, v in params.items()}
        self.v = {k: np.zeros_like(v) for k, v in params.items()}

    def descend(self, params, grads):
        self.n += 1
        c1, c2 = 1 - self.b1 ** self.n, 1 - self.b2 ** self.n
        for k, g in grads.items():
            self.m[k] = self.b1 * self.m[k] + (1 - self.b1) * g
            self.v[k] = self.b2 * self.v[k] + (1 - self.b2) * g * g
            params[k] -= self.lr * (self.m[k] / c1) / (np.sqrt(self.v[k] / c2) + self.eps)


# ---------------------------------------------------------------- the season, played

def sample(logp, u, order=None):
    """Inverse-CDF draws from rows of log-probabilities with uniforms u; `order` permutes the values."""
    p = np.exp(logp)
    if order is not None:
        p = p[:, order]
    idx = (u[:, None] > np.cumsum(p, axis=1)[:, :-1]).sum(axis=1)
    return idx if order is None else np.asarray(order)[idx]


def play(fam, p, n, rng, b0=B0, mirror=False):
    """n seasons under the policy p. Returns a dict of (n, H) arrays and what the update needs."""
    t_all, x_all, b_all = (np.zeros((n, H), dtype=np.int64) for _ in range(3))
    acts = {k: np.zeros((n, H), dtype=np.int64) for k in ("h", "u", "s")}
    ge, ue = np.zeros((n, H)), np.zeros((n, H))
    logp_all = np.zeros((n, H, NOUT))
    x, b = np.full(n, X, dtype=np.int64), np.full(n, b0, dtype=np.int64)
    rec_caches, hs = [], []
    hstate = np.zeros((n, HID)) if not fam.markov else None
    prev = np.zeros((n, NACT))
    site_order = (1, 0) if mirror else None
    for t in range(H):
        tt = np.full(n, t, dtype=np.int64)
        if fam.markov:
            z, _ = fam.logits(p, tt, x, b)
        else:
            inp = np.concatenate([one_hot_obs(tt, x, b), prev], axis=1)
            hstate, cache = fam.step(p, inp, hstate)
            rec_caches.append(cache)
            hs.append(hstate)
            z = fam.head(p, hstate)
        lp = log_softmax_heads(z)
        uh, uu, us = rng.random(n), rng.random(n), rng.random(n)
        h = sample(lp[:, SL["ground"]], uh)
        u = sample(lp[:, SL["bay"]], uu)
        s = sample(lp[:, SL["site"]], us, site_order)
        t_all[:, t], x_all[:, t], b_all[:, t] = t, x, b
        acts["h"][:, t], acts["u"][:, t], acts["s"][:, t] = h, u, s
        g_eff = np.minimum(h, x)
        u_eff = u * (b > 0)
        ge[:, t], ue[:, t] = g_eff, u_eff
        logp_all[:, t] = lp
        x = RENEW[x - g_eff]
        b = b - u_eff
        prev = act_one_hot(h, u, s)
    return dict(t=t_all, x=x_all, b=b_all, acts=acts, ge=ge, ue=ue, logp=logp_all, end_bay=b,
                rec=(rec_caches, hs))


def rewards_to_go(game, reward):
    if reward == "plateau":
        ret = np.minimum((game["ge"] + game["ue"]).sum(axis=1), A)
        return np.repeat(ret[:, None], H, axis=1)
    r = STEP_REWARDS[reward](game["ge"], game["ue"])
    return np.cumsum(r[:, ::-1], axis=1)[:, ::-1]


def chosen_mask(game):
    n = game["t"].shape[0]
    m = np.zeros((n, H, NOUT))
    nn, tt = np.meshgrid(np.arange(n), np.arange(H), indexing="ij")
    m[nn, tt, game["acts"]["h"]] = 1.0
    m[nn, tt, NG + game["acts"]["u"]] = 1.0
    m[nn, tt, NG + NU + game["acts"]["s"]] = 1.0
    return m


def flat(a):
    return a.reshape(-1, *a.shape[2:])


class Learner:
    """One seed's learner: policy, value network, their Adam states, and the arm's update."""

    def __init__(self, family, start, seed, lr, value_lr, batch, reward="rising", kl_beta=0.0,
                 control=False, b0=B0, mirror=False):
        self.fam = FAMILIES[family]
        init_rng = np.random.default_rng([seed, 1])
        self.p = self.fam.init(init_rng, start)
        self.vp = VALUE.init(np.random.default_rng([seed, 2]))
        self.start = {k: v.copy() for k, v in self.p.items()}
        self.opt, self.vopt = Adam(self.p, lr), Adam(self.vp, value_lr)
        self.rng = np.random.default_rng([seed, 3])
        self.batch, self.reward, self.beta, self.control, self.b0 = batch, reward, kl_beta, control, b0
        self.mirror = mirror
        self.ref = np.concatenate([np.log(q) for q in prudent_probs()])
        self.updates = 0
        if mirror:   # the exchanged learner starts at the exchange of the plain one's state and reference
            self.p = exchange(family, self.p)
            self.start = {k: v.copy() for k, v in self.p.items()}
            s0, s1 = NG + NU, NG + NU + 1
            self.ref[[s0, s1]] = self.ref[[s1, s0]]

    def advantages(self, game):
        n = game["t"].shape[0]
        v, cache = VALUE.forward(self.vp, flat(game["t"]), flat(game["x"]), flat(game["b"]))
        g = rewards_to_go(game, self.reward)
        return (g - v.reshape(n, H)), g, cache, v

    def policy_grad(self, game, adv, adv_other=None):
        """Gradient of the loss: minus the batch mean of advantage times log-probability, summed over
        steps and heads, plus beta times the KL at each visited state; with adv_other, the bay's and the
        site's heads take those advantages."""
        n = game["t"].shape[0]
        lp = game["logp"]
        pr = np.exp(lp)
        a = np.repeat(adv[:, :, None], NOUT, axis=2)
        if adv_other is not None:
            a[:, :, SL["bay"]] = adv_other[:, :, None]
            a[:, :, SL["site"]] = adv_other[:, :, None]
        mask = chosen_mask(game)
        # d/dz of -adv*log pi(a): -adv*(onehot - p), per head
        dz = -a * (mask - pr)
        if self.beta:
            for sl in SL.values():
                q, lq = pr[:, :, sl], lp[:, :, sl]
                lr = self.ref[sl]
                kl = (q * (lq - lr)).sum(axis=2, keepdims=True)
                dz[:, :, sl] += self.beta * q * (lq - lr - kl)
        dz /= n
        if self.fam.markov:
            _, cache = self.fam.logits(self.p, flat(game["t"]), flat(game["x"]), flat(game["b"]))
            return self.fam.backward(self.p, cache, flat(dz)), dz
        caches, hs = game["rec"]
        return self.fam.backward_seq(self.p, caches, hs, dz), dz

    def update(self, return_grads=False):
        game = play(self.fam, self.p, self.batch, self.rng, self.b0, self.mirror)
        adv, g, vcache, v = self.advantages(game)
        other = None
        if self.control:
            game2 = play(self.fam, self.p, self.batch, self.rng, self.b0, self.mirror)
            other, _, _, _ = self.advantages(game2)
        grads, dz = self.policy_grad(game, adv, other)
        n = adv.shape[0]
        dv = 2.0 * (v - g.reshape(-1, 1)) / (n * H)
        vgrads = VALUE.backward(self.vp, vcache, dv)
        self.opt.descend(self.p, grads)
        self.vopt.descend(self.vp, vgrads)
        self.updates += 1
        self.last = dict(game=game, adv=adv, dz=dz, bay_adv=other if self.control else adv)
        if return_grads:
            return grads, vgrads
        return None

    def head_norms(self, dz):
        return {k: float(np.sqrt((dz[:, :, sl] ** 2).sum())) for k, sl in SL.items()}

    def movement(self):
        return float(np.sqrt(sum(((self.p[k] - self.start[k]) ** 2).sum() for k in self.p)))


# ---------------------------------------------------------------- the exchange of the site's values

def exchange(family, params):
    """The image of a policy's parameters under exchanging the site's two values: its output rows and,
    for the recurrent family, the input columns carrying its past site act."""
    q = {k: v.copy() for k, v in params.items()}
    s0, s1 = NG + NU, NG + NU + 1
    if family == "separable":
        q["Z"][..., [s0, s1]] = q["Z"][..., [s1, s0]]
    elif family == "feedforward":
        q["W3"][:, [s0, s1]] = q["W3"][:, [s1, s0]]
        q["b3"][[s0, s1]] = q["b3"][[s1, s0]]
    else:
        q["Wo"][:, [s0, s1]] = q["Wo"][:, [s1, s0]]
        q["bo"][[s0, s1]] = q["bo"][[s1, s0]]
        i0, i1 = NOBS + s0, NOBS + s1
        for gname in ("r", "z", "n"):
            q["W" + gname][[i0, i1], :] = q["W" + gname][[i1, i0], :]
    return q
