#!/usr/bin/env python3
"""Pre-registered empirical replay for Frontier 1: capture-lock race and split evidence.

AI-written (f1-lean-builder, 24 November 2026). Pure Python stdlib `unittest`.
Implements R1-R5 from
`_process/research/2026-10-05-generative-foundation-review/root-foundation/development/frontier1-endogenous-capture-2026-11-24/PAPER-ATTACK.md`.
"""

from __future__ import annotations

import itertools
import random
import sys
import unittest
from dataclasses import dataclass
from typing import Callable

sys.dont_write_bytecode = True


def gate(admit: bool, act: str) -> str:
    return act if admit else "extract"


def admits(carriers: int, others: int) -> bool:
    return carriers <= others


def favours(g: tuple[int, int]) -> bool:
    return g[1] <= g[0]


def disfavours(g: tuple[int, int]) -> bool:
    return g[0] <= g[1]


def pool(u: tuple[int, int], v: tuple[int, int], share: tuple[int, int]) -> tuple[int, int]:
    return (
        share[0] * u[0] + share[1] * v[0],
        share[0] * u[1] + share[1] * v[1],
    )


def select_share(share: tuple[int, int], g: tuple[int, int]) -> tuple[int, int]:
    return (share[0] * g[0], share[1] * g[1])


HI = (4, 1)
ONE_TO_ONE = (1, 1)
LO = (1, 4)


@dataclass(frozen=True)
class StrainWorld:
    x_crit: int
    plateau: int
    sense_offset: int
    mode: str  # "endo" | "exo" | "exo_shift" | "cliff"

    def step_stock(self, x: int, act: str) -> int:
        if x < self.x_crit:
            return 0
        if self.mode in ("exo", "exo_shift") and act == "safe":
            return max(x - 2, 0)
        draw = 3 if act == "extract" else 1
        rem = max(x - draw, 0)
        renew = 1 if rem >= self.x_crit - 1 else 0
        return rem + renew

    def sense(self, x: int, act: str) -> int:
        if self.mode == "inf_plateau":
            return (16 if act == "extract" else 13) + self.sense_offset
        if self.mode == "cliff":
            if x < self.x_crit:
                return 0
            return (16 if act == "extract" else 13) + self.sense_offset
        base = min(x, self.plateau)
        if self.mode == "exo_shift":
            return base + (4 if act == "extract" else 3) + self.sense_offset
        return base + (4 if act == "extract" else 1) + self.sense_offset


W_ENDO = StrainWorld(x_crit=6, plateau=12, sense_offset=0, mode="endo")
W_EXO = StrainWorld(x_crit=6, plateau=12, sense_offset=0, mode="exo")
W_EXO_SHIFT = StrainWorld(x_crit=6, plateau=12, sense_offset=0, mode="exo_shift")
W_CLIFF = StrainWorld(x_crit=6, plateau=12, sense_offset=0, mode="cliff")
W_INF_PLATEAU = StrainWorld(x_crit=6, plateau=12, sense_offset=0, mode="inf_plateau")
W_MASKED = StrainWorld(x_crit=6, plateau=10, sense_offset=0, mode="endo")


class EmergentLearner:
    """Blind Moore-machine learner reading only primary task return `y : int`."""

    def __init__(self) -> None:
        self.phase: str = "coarse"
        self.baseline_ext: int | None = None
        self.y_strain: int | None = None
        self.y_safe1: int | None = None
        # Weights over (immYield, sustainedContinuation, downstreamDependent)
        self.pos: list[int] = [2, 0, 0]
        self.base: tuple[int, int, int] = (0, 1, 0)
        self.own_hat: list[bool] = [True, False, False]

    def _select_by_order(self) -> str:
        # cExt = (1, 0, 0), cSafe = (1, 1, 0)
        pos_ext = self.pos[0]
        base_ext = self.base[0]
        pos_safe = self.pos[0] + self.pos[1]
        base_safe = self.base[0] + self.base[1]
        return "safe" if pos_ext + base_safe < pos_safe + base_ext else "extract"

    def act(self) -> str:
        if self.phase in ("probingSafe", "probingVerify"):
            return "safe"
        return self._select_by_order()

    def registers(self) -> bool:
        return self.own_hat[1]

    def update(self, y: int) -> None:
        act_taken = self.act()
        pulse_sc = self.phase == "probingVerify" and self.y_safe1 is not None and self.y_safe1 <= y
        if self.phase == "coarse":
            if self.baseline_ext is None:
                if act_taken == "extract":
                    self.baseline_ext = y
            else:
                if act_taken == "extract" and y != self.baseline_ext:
                    self.phase = "probingSafe"
                    self.y_strain = y
        elif self.phase == "probingSafe":
            self.phase = "probingVerify"
            self.y_safe1 = y
        elif self.phase == "probingVerify":
            self.phase = "resolved"
        if pulse_sc:
            self.pos[1] += 2
            self.own_hat[1] = True


def run_coupled_race(
    world: StrainWorld,
    learner: EmergentLearner,
    others0: int,
    reads: Callable[[int], bool],
    x0: int = 14,
    horizon: int = 20,
) -> list[dict[str, object]]:
    share = (1, others0)
    g = HI
    stock = x0
    trace: list[dict[str, object]] = []
    for t in range(horizon):
        adm = admits(share[0], share[1])
        intended = learner.act()
        executed = gate(adm, intended)
        reg = learner.registers()
        trace.append(
            {
                "t": t,
                "share": share,
                "g": g,
                "stock": stock,
                "admit": adm,
                "reg": reg,
                "intended": intended,
                "executed": executed,
            }
        )
        next_share = select_share(share, g)
        next_g = pool(HI, LO if reg else ONE_TO_ONE, share) if reads(t) else g
        next_stock = world.step_stock(stock, executed)
        y = world.sense(next_stock, executed)
        learner.update(y)
        share, g, stock = next_share, next_g, next_stock
    return trace


def mask_bit(a: bool, b: bool) -> bool:
    return (not b) if a else b


@dataclass(frozen=True)
class MooreAgent:
    n_states: int
    init: int
    trans: tuple[tuple[int, int], ...]
    alarm: tuple[bool, ...]

    def run(self, stream: tuple[bool, ...]) -> bool:
        s = self.init
        for bit in stream:
            s = self.trans[s][1 if bit else 0]
        return self.alarm[s]

    def trace_states(self, stream: tuple[bool, ...]) -> list[bool]:
        s = self.init
        out = [self.alarm[s]]
        for bit in stream:
            s = self.trans[s][1 if bit else 0]
            out.append(self.alarm[s])
        return out


def pure_extract_stock(world: StrainWorld, x0: int, steps: int) -> int:
    x = x0
    for _ in range(steps):
        x = world.step_stock(x, "extract")
    return x


class TestCaptureLockRace(unittest.TestCase):
    def test_r1_window_grid_across_cadences(self) -> None:
        horizon = 20
        for L in (1, 2, 3, 4):
            kept_count = 0
            turned_count = 0
            middle_count = 0
            reads = lambda t, L=L: (t % L == L - 1)
            for others0 in range(1, 1101):
                learner = EmergentLearner()
                trace = run_coupled_race(W_ENDO, learner, others0, reads, x0=14, horizon=horizon)
                tau = next((row["t"] for row in trace if row["reg"]), None)
                if tau is None:
                    continue
                assert isinstance(tau, int)
                r = next((t for t in range(tau, horizon - 1) if reads(t)), None)
                if r is None:
                    continue
                s_r = trace[r]["share"]
                s_r1 = trace[r + 1]["share"]
                assert isinstance(s_r, tuple) and isinstance(s_r1, tuple)
                if s_r[1] <= s_r[0]:
                    kept_count += 1
                    for row in trace[r + 1 :]:
                        sh = row["share"]
                        assert isinstance(sh, tuple)
                        self.assertLessEqual(sh[1], sh[0])
                elif s_r[0] <= s_r[1] and s_r1[0] <= s_r1[1]:
                    turned_count += 1
                    for row in trace[r + 1 :]:
                        sh = row["share"]
                        gg = row["g"]
                        assert isinstance(sh, tuple) and isinstance(gg, tuple)
                        self.assertTrue(disfavours(gg))
                        self.assertLessEqual(sh[0], sh[1])
                        self.assertGreaterEqual(int(row["stock"]), W_ENDO.x_crit)  # type: ignore[arg-type]
                else:
                    middle_count += 1
            self.assertGreater(kept_count, 0, f"vacuous kept for L={L}")
            self.assertGreater(turned_count, 0, f"vacuous turned for L={L}")

    def test_r2_no_hardcoded_threshold_and_lockstep_tamper(self) -> None:
        forbidden_keys = {"stock", "crit", "world", "gate", "plateau", "label", "endo", "exo"}
        for plateau in range(9, 15):
            for offset in (0, 50, 1000):
                for x_crit in (5, 6):
                    world = StrainWorld(x_crit=x_crit, plateau=plateau, sense_offset=offset, mode="endo")
                    learner = EmergentLearner()  # zero-arg constructor
                    trace = run_coupled_race(world, learner, others0=256, reads=lambda _t: True, x0=plateau + 2, horizon=16)
                    for key in learner.__dict__:
                        self.assertFalse(any(bad in key.lower() for bad in forbidden_keys), f"leaked attr {key}")
                    self.assertTrue(learner.registers(), f"failed to register on p={plateau}, off={offset}, crit={x_crit}")
                    self.assertTrue(all(int(row["stock"]) >= x_crit for row in trace))  # type: ignore[arg-type]

        # Lockstep tamper check: identical y at t = 0..2 in W_ENDO vs W_EXO_SHIFT => identical state and action at t = 3
        l_endo = EmergentLearner()
        l_shift = EmergentLearner()
        ys_endo: list[int] = []
        ys_shift: list[int] = []
        x_e, x_s = 14, 14
        for _ in range(3):
            ae, ash = l_endo.act(), l_shift.act()
            self.assertEqual(ae, ash)
            x_e = W_ENDO.step_stock(x_e, ae)
            x_s = W_EXO_SHIFT.step_stock(x_s, ash)
            ye = W_ENDO.sense(x_e, ae)
            ys = W_EXO_SHIFT.sense(x_s, ash)
            ys_endo.append(ye)
            ys_shift.append(ys)
            l_endo.update(ye)
            l_shift.update(ys)
        self.assertEqual(ys_endo, [16, 14, 11])
        self.assertEqual(ys_shift, [16, 14, 11])
        self.assertEqual(l_endo.__dict__, l_shift.__dict__)
        self.assertEqual(l_endo.act(), l_shift.act())

    def test_r3_negative_controls(self) -> None:
        # W_EXO_SHIFT and W_INF_PLATEAU: zero registrations and zero turns across all (L, others0).
        for world in (W_EXO_SHIFT, W_INF_PLATEAU):
            for L in (1, 2, 3, 4):
                reads = lambda t, L=L: (t % L == L - 1)
                for others0 in (1, 4, 12, 20, 64, 256, 1100):
                    learner = EmergentLearner()
                    trace = run_coupled_race(world, learner, others0, reads, x0=14, horizon=12)
                    self.assertFalse(any(row["reg"] for row in trace))
                    self.assertTrue(all(favours(row["g"]) for row in trace))  # type: ignore[arg-type]

        # W_EXO: zero turns across all (L, others0); zero registrations whenever probe is not split mid-probe
        # (admit[2] == admit[3]). When admit[2] is True and admit[3] is False (e.g. o0=20, L in {2,3,4}),
        # the gate forces extract at t=3, emitting y=10 >= 9 and causing a post-lockout false registration
        # that leaves selection captured (all g favour carriers).
        mid_probe_false_regs = 0
        for L in (1, 2, 3, 4):
            reads = lambda t, L=L: (t % L == L - 1)
            for others0 in (1, 4, 12, 20, 64, 256, 1100):
                learner = EmergentLearner()
                trace = run_coupled_race(W_EXO, learner, others0, reads, x0=14, horizon=12)
                self.assertTrue(all(favours(row["g"]) for row in trace))  # type: ignore[arg-type]
                if trace[2]["admit"] and not trace[3]["admit"]:
                    self.assertTrue(trace[4]["reg"])
                    mid_probe_false_regs += 1
                else:
                    self.assertFalse(any(row["reg"] for row in trace))
        self.assertGreater(mid_probe_false_regs, 0)

        # W_CLIFF: zero pre-collapse registration/turn before crossing x_crit at t=5;
        # after collapse onto the 0->0 floor, 0<=0 triggers a post-collapse floor-degeneracy pulse at t=7.
        for L in (1, 2, 3, 4):
            reads = lambda t, L=L: (t % L == L - 1)
            for others0 in (1, 4, 12, 20, 64, 256, 1100):
                learner = EmergentLearner()
                trace = run_coupled_race(W_CLIFF, learner, others0, reads, x0=14, horizon=12)
                self.assertEqual(trace[5]["stock"], 3)
                self.assertFalse(any(row["reg"] for row in trace[:6]))
                self.assertTrue(all(favours(row["g"]) for row in trace[:6]))  # type: ignore[arg-type]
                self.assertTrue(trace[7]["reg"])


class TestSplitEvidenceExhaustive(unittest.TestCase):
    def test_r4_exhaustive_split_marginal_and_closed_capture(self) -> None:
        T = 6
        d_D = tuple(pure_extract_stock(W_ENDO, 14, t + 1) < 12 for t in range(T))
        d_S = (False,) * T
        self.assertEqual(d_D[:2], (False, True))

        rng = random.Random(20261124)
        agents: list[MooreAgent] = []
        for _ in range(200):
            n = rng.choice((2, 3, 4))
            trans = tuple((rng.randrange(n), rng.randrange(n)) for _ in range(n))
            alarm = tuple(rng.choice((False, True)) for _ in range(n))
            agents.append(MooreAgent(n_states=n, init=0, trans=trans, alarm=alarm))

        # Hand-written adversarial agents: constant, parity, last-bit, threshold-2-ones
        adv_agents = [
            MooreAgent(1, 0, ((0, 0),), (False,)),
            MooreAgent(2, 0, ((0, 1), (1, 0)), (False, True)),  # parity
            MooreAgent(2, 0, ((0, 1), (0, 1)), (False, True)),  # last bit
            MooreAgent(3, 0, ((0, 1), (1, 2), (2, 2)), (False, False, True)),  # >=2 true bits
        ]

        all_tags = list(itertools.product((False, True), repeat=T))
        self.assertEqual(len(all_tags), 64)

        nontrivial_random = 0
        for idx, agent in enumerate(agents + adv_agents):
            count_D = 0
            count_S = 0
            for theta in all_tags:
                view_b_D = tuple(mask_bit(theta[t], d_D[t]) for t in range(T))
                view_b_S = tuple(mask_bit(theta[t], d_S[t]) for t in range(T))
                if agent.run(view_b_D):
                    count_D += 1
                if agent.run(view_b_S):
                    count_S += 1
            self.assertEqual(count_D, count_S)
            if idx < len(agents) and 0 < count_S < len(all_tags):
                nontrivial_random += 1
            if count_S == 0:
                self.assertEqual(count_D, 0)
        self.assertGreater(nontrivial_random, 20)

        # Open exchange and verdict-leak checks across all 64 tags
        tp_exchange = 0
        fp_exchange = 0
        tp_leak = 0
        fp_leak = 0
        for theta in all_tags:
            vA = theta
            vB_D = tuple(mask_bit(theta[t], d_D[t]) for t in range(T))
            vB_S = tuple(mask_bit(theta[t], d_S[t]) for t in range(T))
            ex_D = tuple(mask_bit(vA[t], vB_D[t]) for t in range(T))
            ex_S = tuple(mask_bit(vA[t], vB_S[t]) for t in range(T))
            if ex_D == d_D:
                tp_exchange += 1
            if any(ex_S):
                fp_exchange += 1
            # Verdict leak at t = 1 (T = 2): raw last-bit verdicts combined by mask_bit
            if mask_bit(vA[1], vB_D[1]):
                tp_leak += 1
            if mask_bit(vA[1], vB_S[1]):
                fp_leak += 1
        self.assertEqual(tp_exchange, 64)
        self.assertEqual(fp_exchange, 0)
        self.assertEqual(tp_leak, 64)
        self.assertEqual(fp_leak, 0)

        # Closed-loop replay of B7 across all 64 tags: silenced consensus trapped vs exchange turns
        sound_agent = MooreAgent(1, 0, ((0, 0),), (False,))
        for theta in all_tags:
            vA = theta
            vB_D = tuple(mask_bit(theta[t], d_D[t]) for t in range(T))
            vB_S = tuple(mask_bit(theta[t], d_S[t]) for t in range(T))

            # Silenced consensus (B7a): mark stays False => locked under closed pool
            tr_A = sound_agent.trace_states(vA)
            tr_B = sound_agent.trace_states(vB_D)
            share = (1, 20)
            g = HI
            for t in range(T):
                mark = tr_A[t] or tr_B[t]
                self.assertFalse(mark)
                if t >= 2:
                    self.assertTrue(favours(g))
                share = select_share(share, g)
                g = pool(HI, LO if mark else ONE_TO_ONE, share)

            # Open exchange (B7b): registers from tau = 2 in d_D => turns from t = 3; never in d_S
            for d_vec, is_draw in ((d_D, True), (d_S, False)):
                vB = vB_D if is_draw else vB_S
                share = (1, 20)
                g = HI
                reg = False
                for t in range(T):
                    self.assertEqual(reg, is_draw and t >= 2)
                    if is_draw and t >= 3:
                        self.assertTrue(disfavours(g))
                        self.assertTrue(admits(share[0], share[1]))
                    if not is_draw:
                        self.assertTrue(favours(g))
                    share = select_share(share, g)
                    g = pool(HI, LO if reg else ONE_TO_ONE, share)
                    reg = reg or mask_bit(vA[t], vB[t])


if __name__ == "__main__":
    unittest.main()
