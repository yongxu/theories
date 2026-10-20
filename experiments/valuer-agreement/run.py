"""Runs VD1: every model x presentation, one call each (results/runs/<model>.jsonl).

python3 run.py                      the frozen configuration (OpenAI API); resumes where a file stops
python3 run.py --dry D --kind K     every code path with scripted valuers of kind K, written to D
"""

from __future__ import annotations

import argparse
import json
import threading
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

from client import OpenAIClient, ScriptedValuer
from frames import CLASSES, all_items

CONFIG = {
    "models": ["gpt-4o-mini-2024-07-18", "gpt-4.1-nano-2025-04-14", "gpt-4.1-mini-2025-04-14",
               "gpt-5.4-mini-2026-03-17"],
    "parallel": 16,
}


def key(it: dict) -> str:
    return f"{it['frame']}-{it['cls']}-{it['standpoint']:02d}-{it['replicate']}"


def seed(it: dict) -> int:
    return 1_000_000 * it["replicate"] + 10_000 * it["standpoint"] + 100 * it["frame_index"] + CLASSES.index(it["cls"])


def run_model(client, path: Path, parallel: int) -> None:
    done = set()
    if path.exists():
        for line in path.read_text().splitlines():
            row = json.loads(line)
            if row["valid"]:
                done.add(row["key"])
    todo = [it for it in all_items() if key(it) not in done]
    lock = threading.Lock()

    def one(it):
        out = client.judge(it, seed(it))
        row = {"key": key(it), "model": client.model, "seed": seed(it),
               **{k: it[k] for k in ("frame", "frame_index", "domain", "cls", "standpoint", "replicate", "shown",
                                     "admits_1", "admits_2", "framing_1", "framing_2")},
               **out}
        with lock:
            with path.open("a") as f:
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
        for m in ("scripted-a", "scripted-b", "scripted-c", "scripted-d"):
            run_model(ScriptedValuer(m, args.kind, args.misread), out / f"{m}.jsonl", 8)
        return
    out = Path(__file__).parent / "results" / "runs"
    out.mkdir(parents=True, exist_ok=True)
    for m in args.models or CONFIG["models"]:
        run_model(OpenAIClient(m), out / f"{m}.jsonl", CONFIG["parallel"])


if __name__ == "__main__":
    main()
