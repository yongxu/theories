"""LA4 Stage A's checks of the code (design §10, step 1), run before the freeze and again by run.py before the
first run. None of them trains a feedforward or recurrent learner on the test season.

1. Gradients against central finite differences, at six random entries of every parameter tensor (for the
   separable family, all nine logits of one visited state): each family's policy loss under the rising, the
   unshared, the counted-after and the plateau rewards, with the KL term and with the control's split, and the
   value network's, on fixed batches.
2. The exact evaluation against exact_flow.py's at the two starts, and against season.py's independent
   recursion on a random table that differs at every state.
3. The sampled separable update against the exact flow's expected gradient, and the control's expected update
   of the bay's and the site's heads being zero, both by averaging many batches at the prudent start.
4. The mirror test: each family trained twice from one seed and one random stream, the second with the
   site's values exchanged (and, in the KL arm, its reference's); every parameter, the value network's and
   Adam's moments must be exchanges of each other at every update, up to rounding. Four arms' updates are
   checked: rising from the prudent start, the control from the uniform start, counted after with the KL
   term, and the plateau.

Usage: python3 -B checks.py [--quick]. Exit status 0 if every check passes.
"""

import argparse
import json
import math
import sys

import numpy as np

import exact_flow
import learners as L
import evaluate as E
import season

TOL_FD = 1e-5          # relative error of a gradient against central differences
VISITED = 0.05      # the expected-update check reads states visited at least this often
TOL_MIRROR = 1e-9      # largest absolute difference between a run and its exchanged run's image


def policy_loss(learner, game, adv, other=None):
    """The loss whose gradient policy_grad returns, recomputed from the parameters."""
    fam, p = learner.fam, learner.p
    n = adv.shape[0]
    if fam.markov:
        z, _ = fam.logits(p, L.flat(game["t"]), L.flat(game["x"]), L.flat(game["b"]))
        z = z.reshape(n, L.H, L.NOUT)
    else:
        caches, _ = game["rec"]
        h = np.zeros((n, L.HID))
        zs = []
        for t in range(L.H):
            h, _ = fam.step(p, caches[t][0], h)
            zs.append(fam.head(p, h))
        z = np.stack(zs, axis=1)
    lp = L.log_softmax_heads(z)
    mask = L.chosen_mask(game)
    a = np.repeat(adv[:, :, None], L.NOUT, axis=2)
    if other is not None:
        a[:, :, L.SL["bay"]] = other[:, :, None]
        a[:, :, L.SL["site"]] = other[:, :, None]
    loss = -(a * mask * lp).sum() / n
    if learner.beta:
        q = np.exp(lp)
        for sl in L.SL.values():
            loss += learner.beta * (q[:, :, sl] * (lp[:, :, sl] - learner.ref[sl])).sum() / n
    return loss


def fd_check(family, reward, beta, control, seed=0):
    lr = L.Learner(family, "prudent", seed, 1e-3, 1e-3, 16, reward=reward, kl_beta=beta, control=control)
    rng = np.random.default_rng(seed)
    for k in lr.p:                      # move off the start so every term is active
        lr.p[k] += 0.3 * rng.standard_normal(lr.p[k].shape)
    for k in lr.vp:
        lr.vp[k] += 0.3 * rng.standard_normal(lr.vp[k].shape)
    game = L.play(lr.fam, lr.p, 16, rng)
    adv, g, vcache, v = lr.advantages(game)
    other = None
    if control:
        other = lr.advantages(L.play(lr.fam, lr.p, 16, rng))[0]
    grads, _ = lr.policy_grad(game, adv, other)
    worst = 0.0
    for k, w in lr.p.items():
        idx = [tuple(rng.integers(0, s) for s in w.shape) for _ in range(6)]
        if family == "separable":
            ti = rng.integers(0, 16 * L.H)
            tt, xx, bb = L.flat(game["t"])[ti], L.flat(game["x"])[ti], L.flat(game["b"])[ti]
            idx = [(tt, xx, bb, j) for j in range(L.NOUT)]
        for i in idx:
            old = w[i]
            eps = 1e-5
            w[i] = old + eps
            up = policy_loss(lr, game, adv, other)
            w[i] = old - eps
            dn = policy_loss(lr, game, adv, other)
            w[i] = old
            num = (up - dn) / (2 * eps)
            ana = grads[k][i]
            worst = max(worst, abs(num - ana) / max(1e-6, abs(num) + abs(ana)))
    # the value network: loss = mean squared error over the batch's steps
    gt = g.reshape(-1, 1)
    vloss = lambda: float(((L.VALUE.forward(lr.vp, L.flat(game["t"]), L.flat(game["x"]), L.flat(game["b"]))[0]
                            - gt) ** 2).mean())
    dv = 2.0 * (v - gt) / v.size
    vgrads = L.VALUE.backward(lr.vp, vcache, dv)
    for k, w in lr.vp.items():
        for _ in range(4):
            i = tuple(rng.integers(0, s) for s in w.shape)
            old = w[i]
            w[i] = old + 1e-5
            up = vloss()
            w[i] = old - 1e-5
            dn = vloss()
            w[i] = old
            num = (up - dn) / 2e-5
            worst = max(worst, abs(num - vgrads[k][i]) / max(1e-6, abs(num) + abs(vgrads[k][i])))
    return worst


def check_gradients():
    out = {}
    for family in L.FAMILIES:
        for reward, beta, control in (("rising", 0.0, False), ("plateau", 0.0, False), ("after", 0.5, False),
                                      ("rising", 0.0, True), ("unshared", 0.0, False), ("rising", 0.3, False)):
            key = f"{family}/{reward}/beta={beta}/control={control}"
            out[key] = fd_check(family, reward, beta, control)
    return dict(worst=max(out.values()), each=out, passed=bool(max(out.values()) < TOL_FD))


def check_exact_random():
    """The exact evaluation of a policy that differs at every state (a random separable table) against
    season.evaluate's independent recursion."""
    rng = np.random.default_rng(5)
    p = {"Z": rng.normal(0, 1.5, size=(L.H, L.X + 1, L.B0 + 1, L.NOUT))}
    pt = E.table("separable", p)
    v, _ = E.exact(pt)

    def pol(t, x, b):
        q = pt[t, x, b]
        return {(h, u, s_): q[h] * q[L.NG + u] * q[L.NG + L.NU + s_] for h in range(L.NG) for u in range(L.NU)
                for s_ in range(L.NS)}
    w = season.evaluate(season.SEASON, pol)
    d = [abs(v["nearness"] * 40 - w["catch"]), abs(v["ground_nearness"] * 34 - w["ground_catch"]),
         abs(v["bay_left"] - w["bay_left"]), abs(v["kept"] - w["kept"]), abs(v["disturbance"] * 10 - w["disturbances"])]
    return dict(worst=max(d), passed=bool(max(d) < 1e-10))


def check_exact():
    sep = L.FAMILIES["separable"]
    got = {}
    for start, ref in (("prudent", season.prudent), ("uniform", None)):
        v, _ = E.exact(E.table("separable", sep.init(np.random.default_rng(0), start)))
        got[start] = v
    pol = exact_flow.policy(exact_flow.start_logits("prudent"))
    want, _ = exact_flow.evaluate(pol)
    diffs = [abs(got["prudent"]["nearness"] * 40 - want["catch"]), abs(got["prudent"]["bay_left"] - want["bay_left"]),
             abs(got["prudent"]["kept"] - want["kept"]), abs(got["prudent"]["disturbance"] * 10 - want["disturbances"])]
    polu = exact_flow.policy(exact_flow.start_logits("uniform"))
    wu, _ = exact_flow.evaluate(polu)
    diffs += [abs(got["uniform"]["nearness"] * 40 - wu["catch"]), abs(got["uniform"]["kept"] - wu["kept"])]
    return dict(worst=max(diffs), passed=bool(max(diffs) < 1e-12))


def check_expected_update(batches, batch):
    """At the prudent start (plain logits, the separable family), the mean sampled gradient of the return
    (the loss's negative) against the exact flow's, scaled by the visit; and the control's bay and site
    gradients against zero. The value network is held at zero, so the advantage is the reward to go."""
    pol = exact_flow.policy(exact_flow.start_logits("prudent"))
    _, visits = exact_flow.evaluate(pol)
    ex, _ = exact_flow.gradients(pol, visits, exact_flow.REWARDS["rising"])
    want = np.zeros((L.H, L.X + 1, L.B0 + 1, L.NOUT))
    often = np.zeros((L.H, L.X + 1, L.B0 + 1, L.NOUT), dtype=bool)
    for (t, x, b), (gh, gu, gs) in ex.items():
        want[t, x, b] = np.concatenate([gh, gu, gs])
        often[t, x, b] = visits.get((t, x, b), 0.0) >= VISITED
    lr = L.Learner("separable", "prudent", 0, 0.0, 0.0, batch)
    lrc = L.Learner("separable", "prudent", 0, 0.0, 0.0, batch, control=True)
    rng = np.random.default_rng(7)
    acc, acc2, accc, accc2 = (np.zeros_like(want) for _ in range(4))
    for _ in range(batches):
        game = L.play(lr.fam, lr.p, batch, rng)
        g = L.rewards_to_go(game, "rising")
        grads, _ = lr.policy_grad(game, g)
        gz = -grads["Z"]
        acc += gz
        acc2 += gz * gz
        game2 = L.play(lr.fam, lr.p, batch, rng)
        g2 = L.rewards_to_go(game2, "rising")
        gc, _ = lrc.policy_grad(game, g, g2)
        gcz = -gc["Z"]
        accc += gcz
        accc2 += gcz * gcz
    mean, se = acc / batches, np.sqrt(np.maximum(acc2 / batches - (acc / batches) ** 2, 0) / batches)
    meanc, sec = accc / batches, np.sqrt(np.maximum(accc2 / batches - (accc / batches) ** 2, 0) / batches)
    big = np.abs(want) > 1e-3
    z = np.abs(mean - want) / np.maximum(se, 1e-12)
    zc = np.abs(meanc[..., L.NG:]) / np.maximum(sec[..., L.NG:], 1e-12)
    zcg = np.abs(meanc[..., :L.NG] - want[..., :L.NG]) / np.maximum(sec[..., :L.NG], 1e-12)
    live = often & (se > 0)
    livec = often[..., L.NG:] & (sec[..., L.NG:] > 0)
    res = dict(
        largest_exact=float(np.abs(want).max()),
        share_over_1_96=float((z[live] > 1.96).mean()), largest_z=float(z[live].max()),
        control_share_over_1_96=float((zc[livec] > 1.96).mean()), control_largest_z=float(zc[livec].max()),
        control_ground_largest_z=float(zcg[often[..., :L.NG] & (sec[..., :L.NG] > 0)].max()),
        relative_error_on_large=float(np.abs(mean - want)[big].sum() / np.abs(want)[big].sum()),
        logits=int(live.sum()))
    # Under a correct estimator about 5% of z-scores exceed 1.96 and, among a few hundred, none exceeds 4.5.
    res["passed"] = bool(res["share_over_1_96"] < 0.09 and res["control_share_over_1_96"] < 0.09
                         and max(res["largest_z"], res["control_largest_z"], res["control_ground_largest_z"]) < 4.5)
    return res


def state_diff(fam, a, b):
    """Largest absolute difference between learner b's whole state and the exchange of learner a's."""
    worst = 0.0
    for got, want in ((b.p, L.exchange(fam, a.p)), (b.opt.m, L.exchange(fam, a.opt.m)),
                      (b.opt.v, L.exchange(fam, a.opt.v)), (b.vp, a.vp), (b.vopt.m, a.vopt.m),
                      (b.vopt.v, a.vopt.v)):
        for k in want:
            worst = max(worst, float(np.abs(got[k] - want[k]).max()))
    return worst


def check_mirror(updates, batch, families=None):
    out = {}
    for family in families or L.FAMILIES:
        for start, reward, control, beta in (("prudent", "rising", False, 0.0), ("uniform", "rising", True, 0.0),
                                             ("prudent", "after", False, 0.1), ("uniform", "plateau", False, 0.0)):
            kw = dict(reward=reward, control=control, kl_beta=beta)
            a = L.Learner(family, start, 11, 3e-3, 3e-3, batch, **kw)
            b = L.Learner(family, start, 11, 3e-3, 3e-3, batch, mirror=True, **kw)
            worst = state_diff(family, a, b)
            flips = 0
            for _ in range(updates):
                a.update()
                b.update()
                flips += int((a.last["game"]["acts"]["s"] + b.last["game"]["acts"]["s"] != 1).sum())
                worst = max(worst, state_diff(family, a, b))
            out[f"{family}/{start}/{reward}/control={control}/beta={beta}"] = dict(worst=worst, unmirrored_site_draws=flips,
                                                              moved=a.movement())
    worst = max(v["worst"] for v in out.values())
    return dict(worst=worst, each=out, passed=bool(worst < TOL_MIRROR) and all(v["unmirrored_site_draws"] == 0
                                                                         for v in out.values()))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--quick", action="store_true")
    ap.add_argument("--out")
    args = ap.parse_args()
    res = dict(gradients=check_gradients(), exact=check_exact(), exact_random=check_exact_random())
    res["expected_update"] = check_expected_update(1000 if args.quick else 4000, 64)
    res["mirror"] = check_mirror(10 if args.quick else 60, 32)
    res["passed"] = all(v["passed"] for v in res.values())
    text = json.dumps(res, indent=1, default=float)
    if args.out:
        open(args.out, "w").write(text + "\n")
    print(text)
    sys.exit(0 if res["passed"] else 1)


if __name__ == "__main__":
    main()
