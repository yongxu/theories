"""Pure Python stdlib neural learners with analytical backpropagation.

Implements:
- MLP2: 2-layer neural network (tanh or sigmoid hidden layer; linear, sigmoid,
  or tanh output layer) with exact analytical backpropagation and SGD updates.
- ReinforcePolicy: 2-layer tanh MLP outputting categorical logits with
  numerically stable softmax and analytical REINFORCE policy gradients.
- SelfRewardingJudge: 2-layer neural judge (tanh hidden, sigmoid score output)
  supporting online binary cross-entropy training and multi-judge pools.

Zero third-party dependencies (Python stdlib only, deterministic seeding).
"""

from __future__ import annotations

import math
import random
from dataclasses import dataclass
from typing import Callable, List, Sequence, Tuple


def _tanh(z: float) -> float:
    return math.tanh(z)


def _dtanh_from_y(y: float) -> float:
    return 1.0 - y * y


def _sigmoid(z: float) -> float:
    if z >= 0.0:
        ez = math.exp(-min(z, 60.0))
        return 1.0 / (1.0 + ez)
    ez = math.exp(max(z, -60.0))
    return ez / (1.0 + ez)


def _dsigmoid_from_y(y: float) -> float:
    return y * (1.0 - y)


def softmax(logits: Sequence[float]) -> List[float]:
    m = max(logits)
    exps = [math.exp(max(min(z - m, 60.0), -60.0)) for z in logits]
    s = sum(exps)
    if s <= 0.0:
        n = len(logits)
        return [1.0 / n] * n
    return [e / s for e in exps]


def cosine_similarity(u: Sequence[float], v: Sequence[float]) -> float:
    dot = sum(a * b for a, b in zip(u, v))
    nu = math.sqrt(sum(a * a for a in u))
    nv = math.sqrt(sum(b * b for b in v))
    if nu < 1e-12 or nv < 1e-12:
        return 0.0
    return dot / (nu * nv)


def mean_std(values: Sequence[float]) -> Tuple[float, float]:
    if not values:
        return 0.0, 0.0
    mu = sum(values) / len(values)
    var = sum((v - mu) ** 2 for v in values) / len(values)
    return mu, math.sqrt(max(var, 0.0))


def sample_categorical(probs: Sequence[float], rng: random.Random) -> int:
    u = rng.random()
    acc = 0.0
    for idx, p in enumerate(probs):
        acc += p
        if u <= acc:
            return idx
    return len(probs) - 1


@dataclass
class MLP2Grads:
    d_w1: List[List[float]]
    d_b1: List[float]
    d_w2: List[List[float]]
    d_b2: List[float]


class MLP2:
    """Two-layer neural network with exact analytical backpropagation.

    Architecture: x (d_in) -> W1, b1 -> hidden_act -> h (d_hid) -> W2, b2 -> out_act -> y (d_out)
    """

    def __init__(
        self,
        d_in: int,
        d_hid: int,
        d_out: int,
        rng: random.Random,
        hidden_act: str = "tanh",
        out_act: str = "linear",
        init_scale: float = 0.0,
    ) -> None:
        if hidden_act not in ("tanh", "sigmoid"):
            raise ValueError(f"Unsupported hidden_act: {hidden_act}")
        if out_act not in ("linear", "sigmoid", "tanh"):
            raise ValueError(f"Unsupported out_act: {out_act}")

        self.d_in = d_in
        self.d_hid = d_hid
        self.d_out = d_out
        self.hidden_act = hidden_act
        self.out_act = out_act

        s1 = init_scale if init_scale > 0.0 else math.sqrt(1.0 / max(d_in, 1))
        s2 = init_scale if init_scale > 0.0 else math.sqrt(1.0 / max(d_hid, 1))

        self.w1: List[List[float]] = [
            [rng.gauss(0.0, s1) for _ in range(d_in)] for _ in range(d_hid)
        ]
        self.b1: List[float] = [0.0 for _ in range(d_hid)]
        self.w2: List[List[float]] = [
            [rng.gauss(0.0, s2) for _ in range(d_hid)] for _ in range(d_out)
        ]
        self.b2: List[float] = [0.0 for _ in range(d_out)]

    def forward_with_cache(
        self, x: Sequence[float]
    ) -> Tuple[List[float], List[float], List[float]]:
        """Returns (outputs y, hidden activations h, pre-output logits z2)."""
        h: List[float] = [0.0] * self.d_hid
        act_h: Callable[[float], float] = _tanh if self.hidden_act == "tanh" else _sigmoid
        for j in range(self.d_hid):
            row = self.w1[j]
            z = self.b1[j]
            for i in range(self.d_in):
                z += row[i] * x[i]
            h[j] = act_h(z)

        z2: List[float] = [0.0] * self.d_out
        y: List[float] = [0.0] * self.d_out
        for k in range(self.d_out):
            row2 = self.w2[k]
            z = self.b2[k]
            for j in range(self.d_hid):
                z += row2[j] * h[j]
            z2[k] = z
            if self.out_act == "linear":
                y[k] = z
            elif self.out_act == "sigmoid":
                y[k] = _sigmoid(z)
            else:
                y[k] = _tanh(z)
        return y, h, z2

    def forward(self, x: Sequence[float]) -> List[float]:
        y, _, _ = self.forward_with_cache(x)
        return y

    def hidden_representation(self, x: Sequence[float]) -> List[float]:
        _, h, _ = self.forward_with_cache(x)
        return h

    def backward_from_dz2(
        self,
        x: Sequence[float],
        h: Sequence[float],
        d_z2: Sequence[float],
    ) -> MLP2Grads:
        """Exact analytical gradients given dL/dz2 (pre-output activation)."""
        d_w2 = [[d_z2[k] * h[j] for j in range(self.d_hid)] for k in range(self.d_out)]
        d_b2 = list(d_z2)

        d_h = [0.0] * self.d_hid
        for j in range(self.d_hid):
            acc = 0.0
            for k in range(self.d_out):
                acc += self.w2[k][j] * d_z2[k]
            d_h[j] = acc

        dact_h = _dtanh_from_y if self.hidden_act == "tanh" else _dsigmoid_from_y
        d_z1 = [d_h[j] * dact_h(h[j]) for j in range(self.d_hid)]
        d_w1 = [[d_z1[j] * x[i] for i in range(self.d_in)] for j in range(self.d_hid)]
        d_b1 = d_z1
        return MLP2Grads(d_w1=d_w1, d_b1=d_b1, d_w2=d_w2, d_b2=d_b2)

    def backward_from_dy(
        self,
        x: Sequence[float],
        h: Sequence[float],
        y: Sequence[float],
        d_y: Sequence[float],
    ) -> MLP2Grads:
        """Exact analytical gradients given dL/dy."""
        if self.out_act == "linear":
            d_z2 = list(d_y)
        elif self.out_act == "sigmoid":
            d_z2 = [d_y[k] * _dsigmoid_from_y(y[k]) for k in range(self.d_out)]
        else:
            d_z2 = [d_y[k] * _dtanh_from_y(y[k]) for k in range(self.d_out)]
        return self.backward_from_dz2(x, h, d_z2)

    def zero_grads(self) -> MLP2Grads:
        return MLP2Grads(
            d_w1=[[0.0] * self.d_in for _ in range(self.d_hid)],
            d_b1=[0.0] * self.d_hid,
            d_w2=[[0.0] * self.d_hid for _ in range(self.d_out)],
            d_b2=[0.0] * self.d_out,
        )

    @staticmethod
    def accumulate_grads(acc: MLP2Grads, g: MLP2Grads, scale: float = 1.0) -> None:
        for j in range(len(acc.d_b1)):
            acc.d_b1[j] += scale * g.d_b1[j]
            row_a = acc.d_w1[j]
            row_g = g.d_w1[j]
            for i in range(len(row_a)):
                row_a[i] += scale * row_g[i]
        for k in range(len(acc.d_b2)):
            acc.d_b2[k] += scale * g.d_b2[k]
            row_a2 = acc.d_w2[k]
            row_g2 = g.d_w2[k]
            for j in range(len(row_a2)):
                row_a2[j] += scale * row_g2[j]

    def apply_grads(
        self,
        grads: MLP2Grads,
        lr: float,
        weight_decay: float = 0.0,
        grad_clip: float = 5.0,
    ) -> float:
        """Applies SGD descent step: theta <- theta - lr * (grad + weight_decay * theta).

        Returns the pre-clipping L2 gradient norm.
        """
        sq = 0.0
        for j in range(self.d_hid):
            sq += grads.d_b1[j] ** 2
            for i in range(self.d_in):
                sq += grads.d_w1[j][i] ** 2
        for k in range(self.d_out):
            sq += grads.d_b2[k] ** 2
            for j in range(self.d_hid):
                sq += grads.d_w2[k][j] ** 2
        gnorm = math.sqrt(sq)
        scale = 1.0
        if grad_clip > 0.0 and gnorm > grad_clip:
            scale = grad_clip / gnorm

        for j in range(self.d_hid):
            self.b1[j] -= lr * scale * grads.d_b1[j]
            for i in range(self.d_in):
                self.w1[j][i] -= lr * (scale * grads.d_w1[j][i] + weight_decay * self.w1[j][i])
        for k in range(self.d_out):
            self.b2[k] -= lr * scale * grads.d_b2[k]
            for j in range(self.d_hid):
                self.w2[k][j] -= lr * (scale * grads.d_w2[k][j] + weight_decay * self.w2[k][j])
        return gnorm

    def train_step_mse(
        self,
        x: Sequence[float],
        target: Sequence[float],
        lr: float,
        mask: Sequence[float] | None = None,
        weight_decay: float = 0.0,
        grad_clip: float = 5.0,
    ) -> float:
        """One SGD step minimizing 0.5 * sum_k mask_k * (y_k - target_k)^2."""
        y, h, _ = self.forward_with_cache(x)
        d_y = [0.0] * self.d_out
        loss = 0.0
        for k in range(self.d_out):
            w = 1.0 if mask is None else mask[k]
            err = y[k] - target[k]
            loss += 0.5 * w * err * err
            d_y[k] = w * err
        grads = self.backward_from_dy(x, h, y, d_y)
        self.apply_grads(grads, lr=lr, weight_decay=weight_decay, grad_clip=grad_clip)
        return loss

    def train_step_bce(
        self,
        x: Sequence[float],
        target_prob: float,
        lr: float,
        weight_decay: float = 0.0,
        grad_clip: float = 5.0,
    ) -> float:
        """One SGD step for 1-output sigmoid MLP minimizing binary cross-entropy."""
        if self.d_out != 1 or self.out_act != "sigmoid":
            raise ValueError("train_step_bce requires d_out == 1 and out_act == 'sigmoid'")
        y, h, _ = self.forward_with_cache(x)
        p = min(max(y[0], 1e-7), 1.0 - 1e-7)
        loss = -(target_prob * math.log(p) + (1.0 - target_prob) * math.log(1.0 - p))
        # Exact derivative of BCE wrt pre-sigmoid logit z2 is (p - target_prob).
        grads = self.backward_from_dz2(x, h, [y[0] - target_prob])
        self.apply_grads(grads, lr=lr, weight_decay=weight_decay, grad_clip=grad_clip)
        return loss


class ReinforcePolicy:
    """2-layer tanh MLP stochastic policy trained by analytical REINFORCE."""

    def __init__(
        self,
        d_in: int,
        d_hid: int,
        n_actions: int,
        rng: random.Random,
        hidden_act: str = "tanh",
        init_scale: float = 0.35,
    ) -> None:
        self.net = MLP2(
            d_in=d_in,
            d_hid=d_hid,
            d_out=n_actions,
            rng=rng,
            hidden_act=hidden_act,
            out_act="linear",
            init_scale=init_scale,
        )
        self.n_actions = n_actions
        self.baseline = 0.0

    def action_probs(self, x: Sequence[float]) -> List[float]:
        logits = self.net.forward(x)
        return softmax(logits)

    def hidden_representation(self, x: Sequence[float]) -> List[float]:
        return self.net.hidden_representation(x)

    def act(self, x: Sequence[float], rng: random.Random) -> Tuple[int, List[float]]:
        probs = self.action_probs(x)
        action = sample_categorical(probs, rng)
        return action, probs

    def log_prob_grads(self, x: Sequence[float], action: int) -> Tuple[float, MLP2Grads]:
        """Returns (log pi(action|x), gradient of +log pi(action|x) wrt params)."""
        logits, h, _ = self.net.forward_with_cache(x)
        probs = softmax(logits)
        p_a = max(probs[action], 1e-12)
        # d(+log pi(a|x))/d logit_k = 1[k == a] - pi_k
        d_z2 = [(1.0 if k == action else 0.0) - probs[k] for k in range(self.n_actions)]
        grads = self.net.backward_from_dz2(x, h, d_z2)
        return math.log(p_a), grads

    def update_step(
        self,
        x: Sequence[float],
        action: int,
        reward: float,
        lr: float,
        baseline_decay: float = 0.1,
        entropy_coef: float = 0.01,
        weight_decay: float = 1e-4,
        grad_clip: float = 5.0,
    ) -> float:
        """Online single-step REINFORCE ascent update (with running baseline & entropy)."""
        logits, h, _ = self.net.forward_with_cache(x)
        probs = softmax(logits)
        advantage = reward - self.baseline
        self.baseline = (1.0 - baseline_decay) * self.baseline + baseline_decay * reward

        # Minimize J = -advantage * log pi(a|x) - entropy_coef * H(pi)
        # d(-advantage * log pi)/dz_k = advantage * (pi_k - 1[k==a])
        # d(-H)/dz_k = pi_k * (log pi_k - sum_j pi_j log pi_j)
        log_p = [math.log(max(p, 1e-12)) for p in probs]
        neg_entropy = sum(p * lp for p, lp in zip(probs, log_p))
        d_z2 = [0.0] * self.n_actions
        for k in range(self.n_actions):
            d_pg = advantage * (probs[k] - (1.0 if k == action else 0.0))
            d_ent = entropy_coef * probs[k] * (log_p[k] - neg_entropy)
            d_z2[k] = d_pg + d_ent

        grads = self.net.backward_from_dz2(x, h, d_z2)
        return self.net.apply_grads(
            grads, lr=lr, weight_decay=weight_decay, grad_clip=grad_clip
        )

    def update_trajectory(
        self,
        trajectory: Sequence[Tuple[Sequence[float], int, float]],
        lr: float,
        gamma: float = 0.92,
        entropy_coef: float = 0.01,
        weight_decay: float = 1e-4,
        grad_clip: float = 5.0,
    ) -> float:
        """Episodic REINFORCE ascent update over (x_t, a_t, r_t) steps."""
        if not trajectory:
            return 0.0
        returns = [0.0] * len(trajectory)
        g_ret = 0.0
        for idx in range(len(trajectory) - 1, -1, -1):
            g_ret = trajectory[idx][2] + gamma * g_ret
            returns[idx] = g_ret

        mean_ret = sum(returns) / len(returns)
        self.baseline = 0.85 * self.baseline + 0.15 * mean_ret

        acc = self.net.zero_grads()
        inv_n = 1.0 / len(trajectory)
        for (x, action, _), ret in zip(trajectory, returns):
            logits, h, _ = self.net.forward_with_cache(x)
            probs = softmax(logits)
            adv = ret - self.baseline
            log_p = [math.log(max(p, 1e-12)) for p in probs]
            neg_ent = sum(p * lp for p, lp in zip(probs, log_p))
            d_z2 = [
                adv * (probs[k] - (1.0 if k == action else 0.0))
                + entropy_coef * probs[k] * (log_p[k] - neg_ent)
                for k in range(self.n_actions)
            ]
            step_g = self.net.backward_from_dz2(x, h, d_z2)
            self.net.accumulate_grads(acc, step_g, scale=inv_n)
        return self.net.apply_grads(
            acc, lr=lr, weight_decay=weight_decay, grad_clip=grad_clip
        )


class SelfRewardingJudge:
    """2-layer neural judge (tanh hidden, sigmoid score) with online BCE training."""

    def __init__(
        self,
        d_in: int,
        d_hid: int,
        rng: random.Random,
        hidden_act: str = "tanh",
        init_scale: float = 0.4,
    ) -> None:
        self.net = MLP2(
            d_in=d_in,
            d_hid=d_hid,
            d_out=1,
            rng=rng,
            hidden_act=hidden_act,
            out_act="sigmoid",
            init_scale=init_scale,
        )

    def score(self, feat: Sequence[float]) -> float:
        return self.net.forward(feat)[0]

    def update(
        self,
        feat: Sequence[float],
        label: float,
        lr: float = 0.06,
        weight_decay: float = 1e-4,
    ) -> float:
        clamped = min(max(label, 0.0), 1.0)
        return self.net.train_step_bce(
            feat, target_prob=clamped, lr=lr, weight_decay=weight_decay
        )


class RotatingJudgePool:
    """Pool of independently initialized neural judges with rotating evaluation and disagreement veto."""

    def __init__(
        self,
        n_judges: int,
        d_in: int,
        d_hid: int,
        rng: random.Random,
        hidden_act: str = "tanh",
    ) -> None:
        self.judges: List[SelfRewardingJudge] = [
            SelfRewardingJudge(d_in=d_in, d_hid=d_hid, rng=rng, hidden_act=hidden_act)
            for _ in range(n_judges)
        ]
        self._cursor = 0

    def evaluate(self, feat: Sequence[float]) -> Tuple[float, float, float]:
        """Returns (active_rotating_score, pool_mean, pool_disagreement_std)."""
        scores = [j.score(feat) for j in self.judges]
        active = scores[self._cursor % len(self.judges)]
        self._cursor += 1
        mu, sd = mean_std(scores)
        return active, mu, sd

    def update_subset(
        self,
        feat: Sequence[float],
        label: float,
        lr: float,
        judge_indices: Sequence[int],
    ) -> None:
        for idx in judge_indices:
            self.judges[idx % len(self.judges)].update(feat, label=label, lr=lr)
