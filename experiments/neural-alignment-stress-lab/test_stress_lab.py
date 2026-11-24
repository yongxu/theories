"""Unit tests for the Neural Alignment Stress Lab.

Covers:
1. Analytical backpropagation finite-difference checks (MLP2 tanh/sigmoid, BCE,
   and ReinforcePolicy log-probability gradients).
2. Self-rewarding judge learning and rotating judge pool disagreement behavior.
3. Exact determinism across repeated seeded runs.
4. Structural empirical invariants across B1-B4 (including explicit verification
   that B4 documents BOTH rescued nominal regimes AND genuine failure regimes).
5. Strict hygiene scan ensuring zero forbidden market-vocabulary tokens anywhere
   in code, identifiers, or docs inside experiments/neural-alignment-stress-lab/.
"""

from __future__ import annotations

import math
import random
import re
import sys
import unittest
from pathlib import Path

LAB_DIR = Path(__file__).resolve().parent
if str(LAB_DIR) not in sys.path:
    sys.path.insert(0, str(LAB_DIR))

from benchmarks import (  # noqa: E402
    run_b1_representation_leakage,
    run_b2_neural_causal_goodhart,
    run_b3_concurrent_vs_serialized,
    run_b4_guarded_alignment_protocol,
)
from nn_core import (  # noqa: E402
    MLP2,
    ReinforcePolicy,
    RotatingJudgePool,
    SelfRewardingJudge,
    softmax,
)


def _finite_diff_check_mlp(hidden_act: str, out_act: str) -> float:
    rng = random.Random(77)
    net = MLP2(d_in=4, d_hid=5, d_out=3, rng=rng, hidden_act=hidden_act, out_act=out_act)
    x = [0.6, -0.4, 0.9, -0.2]
    target = [0.2, 0.8, -0.3]

    def loss_fn() -> float:
        y = net.forward(x)
        return 0.5 * sum((yk - tk) ** 2 for yk, tk in zip(y, target))

    y, h, _ = net.forward_with_cache(x)
    d_y = [yk - tk for yk, tk in zip(y, target)]
    grads = net.backward_from_dy(x, h, y, d_y)

    eps = 1e-6
    max_err = 0.0

    for j in range(net.d_hid):
        for i in range(net.d_in):
            orig = net.w1[j][i]
            net.w1[j][i] = orig + eps
            lp = loss_fn()
            net.w1[j][i] = orig - eps
            lm = loss_fn()
            net.w1[j][i] = orig
            num = (lp - lm) / (2.0 * eps)
            max_err = max(max_err, abs(num - grads.d_w1[j][i]))

        orig = net.b1[j]
        net.b1[j] = orig + eps
        lp = loss_fn()
        net.b1[j] = orig - eps
        lm = loss_fn()
        net.b1[j] = orig
        num = (lp - lm) / (2.0 * eps)
        max_err = max(max_err, abs(num - grads.d_b1[j]))

    for k in range(net.d_out):
        for j in range(net.d_hid):
            orig = net.w2[k][j]
            net.w2[k][j] = orig + eps
            lp = loss_fn()
            net.w2[k][j] = orig - eps
            lm = loss_fn()
            net.w2[k][j] = orig
            num = (lp - lm) / (2.0 * eps)
            max_err = max(max_err, abs(num - grads.d_w2[k][j]))

        orig = net.b2[k]
        net.b2[k] = orig + eps
        lp = loss_fn()
        net.b2[k] = orig - eps
        lm = loss_fn()
        net.b2[k] = orig
        num = (lp - lm) / (2.0 * eps)
        max_err = max(max_err, abs(num - grads.d_b2[k]))

    return max_err


class TestNeuralCore(unittest.TestCase):
    def test_mlp2_backprop_finite_differences(self) -> None:
        for h_act in ("tanh", "sigmoid"):
            for o_act in ("linear", "sigmoid", "tanh"):
                err = _finite_diff_check_mlp(h_act, o_act)
                self.assertLess(err, 1e-6, f"Grad mismatch for {h_act}/{o_act}: {err}")

    def test_mlp2_bce_gradient_finite_difference(self) -> None:
        rng = random.Random(101)
        net = MLP2(d_in=3, d_hid=4, d_out=1, rng=rng, hidden_act="tanh", out_act="sigmoid")
        x = [0.7, -0.5, 0.3]
        target = 0.85

        def bce() -> float:
            p = net.forward(x)[0]
            return -(target * math.log(p) + (1.0 - target) * math.log(1.0 - p))

        y, h, _ = net.forward_with_cache(x)
        grads = net.backward_from_dz2(x, h, [y[0] - target])
        eps = 1e-6
        max_err = 0.0
        for j in range(net.d_hid):
            for i in range(net.d_in):
                orig = net.w1[j][i]
                net.w1[j][i] = orig + eps
                lp = bce()
                net.w1[j][i] = orig - eps
                lm = bce()
                net.w1[j][i] = orig
                max_err = max(max_err, abs((lp - lm) / (2.0 * eps) - grads.d_w1[j][i]))
        self.assertLess(max_err, 1e-6)

    def test_reinforce_log_prob_finite_difference(self) -> None:
        rng = random.Random(202)
        pol = ReinforcePolicy(d_in=4, d_hid=5, n_actions=3, rng=rng, hidden_act="tanh")
        x = [0.5, -0.3, 0.8, 0.1]
        action = 1
        _, grads = pol.log_prob_grads(x, action)

        def log_pi() -> float:
            probs = softmax(pol.net.forward(x))
            return math.log(probs[action])

        eps = 1e-6
        max_err = 0.0
        for j in range(pol.net.d_hid):
            for i in range(pol.net.d_in):
                orig = pol.net.w1[j][i]
                pol.net.w1[j][i] = orig + eps
                lp = log_pi()
                pol.net.w1[j][i] = orig - eps
                lm = log_pi()
                pol.net.w1[j][i] = orig
                max_err = max(max_err, abs((lp - lm) / (2.0 * eps) - grads.d_w1[j][i]))
        for k in range(pol.net.d_out):
            for j in range(pol.net.d_hid):
                orig = pol.net.w2[k][j]
                pol.net.w2[k][j] = orig + eps
                lp = log_pi()
                pol.net.w2[k][j] = orig - eps
                lm = log_pi()
                pol.net.w2[k][j] = orig
                max_err = max(max_err, abs((lp - lm) / (2.0 * eps) - grads.d_w2[k][j]))
        self.assertLess(max_err, 1e-6)

    def test_self_rewarding_judge_and_pool_disagreement(self) -> None:
        rng = random.Random(303)
        judge = SelfRewardingJudge(d_in=3, d_hid=6, rng=rng)
        pos = [1.0, 0.9, 0.8]
        neg = [-1.0, -0.8, 0.1]
        for _ in range(80):
            judge.update(pos, label=0.95, lr=0.1)
            judge.update(neg, label=0.05, lr=0.1)
        self.assertGreater(judge.score(pos), 0.85)
        self.assertLess(judge.score(neg), 0.15)

        pool = RotatingJudgePool(n_judges=3, d_in=3, d_hid=6, rng=rng)
        for _ in range(40):
            pool.update_subset(pos, label=0.95, lr=0.12, judge_indices=[0])
            pool.update_subset(pos, label=0.05, lr=0.12, judge_indices=[1])
        _, _, sd = pool.evaluate(pos)
        self.assertGreater(sd, 0.25)


class TestBenchmarksAndDeterminism(unittest.TestCase):
    def test_determinism_small_seeds(self) -> None:
        r1 = run_b1_representation_leakage(n_seeds=2, base_seed=9100)
        r2 = run_b1_representation_leakage(n_seeds=2, base_seed=9100)
        self.assertEqual(r1, r2)

        g1 = run_b2_neural_causal_goodhart(n_seeds=2, base_seed=9200)
        g2 = run_b2_neural_causal_goodhart(n_seeds=2, base_seed=9200)
        self.assertEqual(g1, g2)

    def test_b1_representation_leakage_invariants(self) -> None:
        rows = run_b1_representation_leakage(n_seeds=8, base_seed=1100)
        by_key = {(r["learner"], r["x0"], r["rho"]): r for r in rows}
        self.assertEqual(by_key[("tabular_q", 27.0, 0.0)]["collapse_rate"], 0.0)
        self.assertGreater(
            by_key[("reinforce_mlp", 27.0, 0.9)]["mean_hidden_cosine"], 0.75
        )
        self.assertGreater(
            by_key[("reinforce_mlp", 27.0, 0.9)]["collapse_rate"],
            by_key[("tabular_q", 27.0, 0.0)]["collapse_rate"],
        )

    def test_b2_zero_tv_fiber_viability_split_invariants(self) -> None:
        out = run_b2_neural_causal_goodhart(n_seeds=8, base_seed=2100)
        conds = {c["mode"]: c for c in out["conditions"]}
        self.assertEqual(conds["passive_sustain"]["collapse_rate"], 0.0)
        self.assertGreaterEqual(conds["self_rewarding_tv_audited"]["collapse_rate"], 0.75)
        self.assertLess(conds["self_rewarding_tv_audited"]["pooled_macro_tv"], 0.08)
        self.assertGreater(
            conds["overt_reinforce"]["pooled_macro_tv"],
            conds["self_rewarding_tv_audited"]["pooled_macro_tv"],
        )
        fp = out["fiber_split_probe"]
        self.assertEqual(fp["same_macro_tv"], 0.0)
        self.assertEqual(fp["within_fiber_viability_split"], 1.0)
        self.assertGreater(fp["within_fiber_probe_gap_mean"], 0.8)

    def test_b3_concurrent_vs_serialized_invariants(self) -> None:
        rows = run_b3_concurrent_vs_serialized(n_seeds=8, base_seed=3100)
        by_reg = {r["regime"]: r for r in rows}
        self.assertEqual(by_reg["solo_admissible_check"]["collapse_rate"], 0.0)
        self.assertGreaterEqual(by_reg["unserialized_concurrent_K4"]["collapse_rate"], 0.875)
        self.assertEqual(by_reg["epoch_reserve_serialized_K4"]["collapse_rate"], 0.0)
        self.assertGreaterEqual(by_reg["stale_snapshot_serialized"]["collapse_rate"], 0.875)

    def test_b4_guarded_saves_nominal_and_documents_failures(self) -> None:
        rows = run_b4_guarded_alignment_protocol(n_seeds=10, base_seed=4100)
        by_key = {(r["scenario"], r["protocol"]): r for r in rows}
        self.assertGreaterEqual(by_key[("nominal_coupled", "unguarded")]["collapse_rate"], 0.8)
        self.assertEqual(by_key[("nominal_coupled", "full_guarded")]["collapse_rate"], 0.0)
        # Honest Rule 2 check: explicit failure regimes actually break the full guard!
        fail_scenarios = [
            "FAIL_high_lr",
            "FAIL_severe_aliasing",
            "FAIL_long_lag",
            "FAIL_correlated_pool_drift",
        ]
        for sc in fail_scenarios:
            self.assertGreater(
                by_key[(sc, "full_guarded")]["collapse_rate"],
                0.0,
                f"Expected genuine failure under {sc}",
            )


class TestVocabularyHygiene(unittest.TestCase):
    def test_zero_forbidden_market_tokens_in_all_lab_files(self) -> None:
        # Reversed tokens so this test file itself contains zero literal matches.
        forbidden = tuple(
            tok[::-1]
            for tok in (
                "tsoc", "stsoc", "yltsoc", "gnitsoc",
                "egrahc", "segrahc", "degrahc", "gnigrahc",
                "tegdub", "stegdub", "detegdub",
                "yap", "syap", "gniyap", "tnemyap", "stnemyap", "diap",
                "ecirp", "secirp", "decirp", "gnicirp",
                "dneps", "sdneps", "gnidneps", "tneps",
                "gnitnuocca",
                "tiderc", "stiderc", "detiderc", "gnitiderc",
                "eef", "seef",
                "tiforp", "stiforp", "elbatiforp",
                "dnuf", "sdnuf", "dednuf", "gnidnuf",
            )
        )
        self.assertEqual(len(forbidden), 39)
        word_re = re.compile(r"\b(?:" + "|".join(re.escape(w) for w in forbidden) + r")\b", re.IGNORECASE)
        ident_re = re.compile(r"[a-z]+")
        forbidden_set = set(forbidden)

        hits = []
        for path in sorted(LAB_DIR.rglob("*")):
            if not path.is_file() or "__pycache__" in path.parts:
                continue
            text = path.read_text(encoding="utf-8", errors="ignore")
            for m in word_re.finditer(text):
                hits.append((path.name, "word", m.group(0)))
            for tok in ident_re.findall(text.lower()):
                if tok in forbidden_set:
                    hits.append((path.name, "ident", tok))
        self.assertEqual(hits, [], f"Forbidden vocabulary matches found: {hits}")


if __name__ == "__main__":
    unittest.main()
