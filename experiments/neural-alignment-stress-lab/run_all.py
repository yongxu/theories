#!/usr/bin/env python3
"""Deterministic CLI runner for the Neural Alignment Stress Lab (B1-B5)."""

from __future__ import annotations

import argparse
import json
import sys
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
if str(HERE) not in sys.path:
    sys.path.insert(0, str(HERE))

from benchmarks import run_all_benchmarks  # noqa: E402
from b5_walls import format_b5_markdown, run_b5_walls_vs_defects  # noqa: E402


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Run multi-seed neural alignment stress benchmarks B1-B4."
    )
    parser.add_argument(
        "--seeds",
        type=int,
        default=20,
        help="Number of deterministic seeds per cell (default: 20).",
    )
    parser.add_argument(
        "--json-out",
        type=str,
        default="",
        help="Optional path to write full JSON summary.",
    )
    parser.add_argument(
        "--b5",
        action="store_true",
        help="Run ONLY benchmark B5 (walls vs. defects) and print its markdown tables.",
    )
    parser.add_argument(
        "--with-b5",
        action="store_true",
        help="Also run B5 after B1-B4 (adds about 40s CPU at 20 seeds).",
    )
    args = parser.parse_args()

    t0 = time.perf_counter()
    c0 = time.process_time()
    if args.b5:
        results = {"n_seeds": args.seeds, "B5": run_b5_walls_vs_defects(n_seeds=args.seeds)}
    else:
        results = run_all_benchmarks(n_seeds=args.seeds)
        if args.with_b5:
            results["B5"] = run_b5_walls_vs_defects(n_seeds=args.seeds)
    elapsed = round(time.perf_counter() - t0, 3)
    cpu = round(time.process_time() - c0, 3)
    results["elapsed_seconds"] = elapsed

    if args.json_out:
        Path(args.json_out).write_text(json.dumps(results, indent=2) + "\n", encoding="utf-8")

    if args.b5:
        print(format_b5_markdown(results["B5"]))
        print(f"elapsed_wall_seconds: {elapsed}  cpu_seconds: {cpu}")
    else:
        print(json.dumps(results, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
