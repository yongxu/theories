#!/usr/bin/env python3
"""Prospective predict/evaluate entry point for Wave 2 Real-Learner B1/B2/B3.

AI-written (Wave 2, 24 November 2026). `-O`-safe `--prediction-sha` check enforced
via `ValueError`; enforces shared `18.0s` CPU budget ceiling (`budget_exceeded`).
"""
from __future__ import annotations

import argparse
import hashlib
import json
import sys
import time
from pathlib import Path
from typing import Any, Dict

sys.dont_write_bytecode = True

HERE = Path(__file__).resolve().parent
if str(HERE) not in sys.path:
    sys.path.insert(0, str(HERE))

from finite_paced import (  # noqa: E402
    compute_b1_word_metrics,
    cross_check_runtime_observational_fidelity,
    evaluate_b1_heldout,
    evaluate_b2_heldout,
    load_policy,
    predict_b2,
    train_real_learner,
)
from rotating import evaluate_b3_heldout, predict_b3  # noqa: E402

CKPT_FILE = HERE / "checkpoints.json"
PRED_FILE = HERE / "predictions.json"
RES_FILE = HERE / "results.json"
BUDGET_SECONDS = 18.0


def cmd_predict() -> int:
    t0 = time.process_time()
    train_data = train_real_learner()
    pol1 = load_policy(train_data["ckpt_1"])
    rt_checks = cross_check_runtime_observational_fidelity(pol1)
    b1_pred = compute_b1_word_metrics(pol1)
    b2_pred = predict_b2(train_data["ckpt_0"], train_data["ckpt_1"])
    b3_pred = predict_b3()
    elapsed = time.process_time() - t0
    if elapsed > BUDGET_SECONDS:
        raise RuntimeError(f"budget_exceeded in predict: {elapsed:.3f}s > {BUDGET_SECONDS}s")

    ckpt_payload = {
        "ai_written": True,
        "python_version": sys.version.split()[0],
        "train_cpu_seconds": elapsed,
        **train_data,
    }
    ckpt_bytes = (json.dumps(ckpt_payload, indent=2, sort_keys=True) + "\n").encode("utf-8")
    CKPT_FILE.write_bytes(ckpt_bytes)

    # Strip large exact Fraction tables not needed downstream while keeping chosen_m, blocks, tubes, B2/B3
    b1_serial = {k: v for k, v in b1_pred.items() if k not in ("k_frac", "l_frac", "tubes_frac")}
    pred_payload: Dict[str, Any] = {
        "ai_written": True,
        "predict_cpu_seconds": elapsed,
        "checkpoints_sha256": hashlib.sha256(ckpt_bytes).hexdigest(),
        "runtime_observational_fidelity_crosscheck": rt_checks,
        "b1": b1_serial,
        "b2": b2_pred,
        "b3": b3_pred,
    }
    pred_bytes = (json.dumps(pred_payload, indent=2, sort_keys=True) + "\n").encode("utf-8")
    PRED_FILE.write_bytes(pred_bytes)
    pred_sha = hashlib.sha256(pred_bytes).hexdigest()
    print(json.dumps({
        "status": "predicted",
        "predict_cpu_seconds": round(elapsed, 4),
        "chosen_m": b1_serial["chosen_m"],
        "alpha_1": b1_serial["blocks"]["1"]["alpha"],
        "prediction_sha": pred_sha,
        "predictions_file": str(PRED_FILE),
    }))
    return 0


def cmd_evaluate(expected_sha: str) -> int:
    if not PRED_FILE.is_file() or not CKPT_FILE.is_file():
        raise FileNotFoundError("Missing predictions.json or checkpoints.json; run predict first")
    # Single-read hash-and-parse prevents TOCTOU swap between verification and load.
    pred_bytes = PRED_FILE.read_bytes()
    actual_sha = hashlib.sha256(pred_bytes).hexdigest()
    if actual_sha != expected_sha:
        raise ValueError(f"Prediction SHA mismatch: expected {expected_sha}, got {actual_sha}")
    pred_data = json.loads(pred_bytes.decode("utf-8"))

    ckpt_bytes = CKPT_FILE.read_bytes()
    if hashlib.sha256(ckpt_bytes).hexdigest() != pred_data["checkpoints_sha256"]:
        raise ValueError("checkpoints.json modified after predict")
    ckpt_data = json.loads(ckpt_bytes.decode("utf-8"))

    t0 = time.process_time()
    pol1 = load_policy(ckpt_data["ckpt_1"])
    b1_res = evaluate_b1_heldout(pol1, pred_data["b1"])
    b2_res = evaluate_b2_heldout(ckpt_data["ckpt_0"], ckpt_data["ckpt_1"], pred_data["b2"])
    b3_res = evaluate_b3_heldout()
    eval_cpu = time.process_time() - t0
    total_cpu = pred_data["predict_cpu_seconds"] + eval_cpu
    if total_cpu > BUDGET_SECONDS:
        raise RuntimeError(f"budget_exceeded: total {total_cpu:.3f}s > {BUDGET_SECONDS}s")

    out = {
        "ai_written": True,
        "prediction_sha": actual_sha,
        "predict_cpu_seconds": pred_data["predict_cpu_seconds"],
        "evaluate_cpu_seconds": eval_cpu,
        "total_cpu_seconds": total_cpu,
        "b1": b1_res,
        "b2": b2_res,
        "b3": b3_res,
    }
    RES_FILE.write_text(json.dumps(out, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(json.dumps({
        "status": "evaluated",
        "prediction_sha": actual_sha,
        "total_cpu_seconds": round(total_cpu, 4),
        "b1_chosen_m": b1_res["chosen_m"],
        "b1_impl_ok": b1_res["impl_sanity_passed"],
        "b1_exact_tube_viol": b1_res["exact_tube_violations"],
        "b2_a_ok": b2_res["arm_a"]["all_within_allow"],
        "b2_b_ok": b2_res["arm_b"]["all_within_allow"],
        "b2_c_online_passed": b2_res["arm_c"]["online_passed"],
        "b2_c_equal_clock_gap": b2_res["arm_c"]["equal_clock"]["exact_gap"],
        "b3_col_nat": b3_res["collapse_count_natural"],
        "b3_col_clm": b3_res["collapse_count_clamped"],
    }))
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description="Wave 2 Real-Learner B1/B2/B3 Runner")
    sub = parser.add_subparsers(dest="cmd", required=True)
    sub.add_parser("predict")
    ev = sub.add_parser("evaluate")
    ev.add_argument("--prediction-sha", required=True, dest="prediction_sha")
    args = parser.parse_args()
    if args.cmd == "predict":
        return cmd_predict()
    return cmd_evaluate(args.prediction_sha)


if __name__ == "__main__":
    raise SystemExit(main())
