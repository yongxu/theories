"""Runs VD1: every model x presentation, one call each (results/runs/<model>.jsonl).

python3 run.py                      the configuration of the addendum (headless Claude Code); resumes
                                    where a file stops
python3 run.py --dry D --kind K     every code path with scripted valuers of kind K, written to D

Calls go in standpoint order: standpoint 0's 112 pairs for every model, then standpoint 1's, and so
on, the replicates last. If the plan's usage limit stops the run (client.LimitReached), no further
call is made, and the analysis uses the complete standpoints (analyze.py, the reduced design).
"""

from __future__ import annotations

import argparse
import json
import threading
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

from client import ClaudeCLIClient, LimitReached, ScriptedValuer
from frames import CLASSES, all_items

# The original freeze's configuration, never run (the OpenAI account had no credit):
#   models gpt-4o-mini-2024-07-18, gpt-4.1-nano-2025-04-14, gpt-4.1-mini-2025-04-14, gpt-5.4-mini-2026-03-17
CONFIG = {
    "provider": "claude-cli",
    "models": ["claude-haiku-5-5", "claude-sonnet-5-5", "claude-opus-5-5"],
    "parallel": 6,
}


def key(it: dict) -> str:
    return f"{it['frame']}-{it['cls']}-{it['standpoint']:02d}-{it['replicate']}"


def seed(it: dict) -> int:
    return 1_000_000 * it["replicate"] + 10_000 * it["standpoint"] + 100 * it["frame_index"] + CLASSES.index(it["cls"])


def done_keys(path: Path) -> set:
    done = set()
    if path.exists():
        for line in path.read_text().splitlines():
            row = json.loads(line)
            if row["valid"]:
                done.add(row["key"])
    return done


def run_all(clients: dict, out: Path, parallel: int) -> None:
    """Every (model, presentation) not yet valid, in standpoint order, replicates last."""
    done = {m: done_keys(out / f"{m}.jsonl") for m in clients}
    order = sorted(all_items(), key=lambda it: (it["replicate"], it["standpoint"], it["frame_index"],
                                                CLASSES.index(it["cls"])))
    todo = [(m, it) for it in order for m in clients if key(it) not in done[m]]
    lock = threading.Lock()
    stopped = threading.Event()

    def one(task):
        m, it = task
        if stopped.is_set():
            return
        try:
            res = clients[m].judge(it, seed(it))
        except LimitReached as e:
            stopped.set()
            print("limit reached, stopping:", e, flush=True)
            return
        row = {"key": key(it), "model": m, "seed": seed(it),
               **{k: it[k] for k in ("frame", "frame_index", "domain", "cls", "standpoint", "replicate", "shown",
                                     "admits_1", "admits_2", "framing_1", "framing_2")},
               **res}
        with lock:
            with (out / f"{m}.jsonl").open("a") as f:
                f.write(json.dumps(row, sort_keys=True) + "\n")

    with ThreadPoolExecutor(max_workers=parallel) as ex:
        list(ex.map(one, todo))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry")
    ap.add_argument("--kind", default="weigher")
    ap.add_argument("--misread", type=float, default=0.0)
    ap.add_argument("--models", nargs="*")
    args = ap.parse_args()
    if args.dry:
        out = Path(args.dry)
        out.mkdir(parents=True, exist_ok=True)
        run_all({m: ScriptedValuer(m, args.kind, args.misread) for m in ("scripted-a", "scripted-b", "scripted-c")},
                out, 8)
        return
    out = Path(__file__).parent / "results" / "runs"
    out.mkdir(parents=True, exist_ok=True)
    run_all({m: ClaudeCLIClient(m) for m in args.models or CONFIG["models"]}, out, CONFIG["parallel"])


if __name__ == "__main__":
    main()
