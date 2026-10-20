"""Runs VD1: every model x presentation, one call each (results/runs/<model>.jsonl).

python3 run.py                      the configuration of the second addendum (OpenRouter); resumes
                                    where a file stops. Run it from Ren's interactive zsh so that it
                                    inherits OPENROUTER_API_KEY:  zsh -ic 'python3 -B run.py'
python3 run.py --dry D --kind K     every code path with scripted valuers of kind K, written to D

Each model has its own queue, in standpoint order: standpoint 0's 112 pairs, then standpoint 1's,
and so on, the replicates last. A model whose daily cap is reached (client.LimitReached), or whose
calls fail for good, stops; the other goes on. The analysis uses the complete standpoints
(analyze.py, the reduced design); a later run resumes where each model stopped.
"""

from __future__ import annotations

import argparse
import json
import threading
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

from client import LimitReached, OpenRouterClient, ScriptedValuer
from frames import CLASSES, all_items

# The original freeze's configuration, never run (the OpenAI account had no credit):
#   gpt-4o-mini-2024-07-18, gpt-4.1-nano-2025-04-14, gpt-4.1-mini-2025-04-14, gpt-5.4-mini-2026-03-17.
# The first addendum's, never run (superseded; the Claude plan was at its weekly limit):
#   claude-haiku-5-5, claude-sonnet-5-5, claude-opus-5-5 through headless Claude Code (client.ClaudeCLIClient).
CONFIG = {
    "provider": "openrouter",
    "models": {
        "deepseek/deepseek-v4.1-flash-1017": {"parallel": 8, "rpm": None, "json_mode": "json_schema", "seed": True},
        "openai/gpt-6-luna": {"parallel": 8, "rpm": None, "json_mode": "json_schema", "seed": True},
        "anthropic/claude-haiku-5.5": {"parallel": 8, "rpm": None, "json_mode": "json_schema", "seed": False},
        "meta/muse-spark-1.3-contributor": {"parallel": 8, "rpm": None, "json_mode": "json_schema", "seed": False},
        "stepfun/step-5-preview": {"parallel": 8, "rpm": None, "json_mode": "json_schema", "seed": True},
    },
}


def fname(model: str) -> str:
    return model.replace("/", "__").replace(":", "_") + ".jsonl"


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


def run_model(model: str, client, out: Path, parallel: int) -> None:
    """Every presentation not yet valid for this model, in standpoint order, replicates last."""
    path = out / fname(model)
    done = done_keys(path)
    order = sorted(all_items(), key=lambda it: (it["replicate"], it["standpoint"], it["frame_index"],
                                                CLASSES.index(it["cls"])))
    todo = [it for it in order if key(it) not in done]
    lock = threading.Lock()
    stopped = threading.Event()

    def one(it):
        if stopped.is_set():
            return
        try:
            res = client.judge(it, seed(it))
        except (LimitReached, RuntimeError) as e:
            stopped.set()
            print(f"{model} stopped: {e}", flush=True)
            return
        row = {"key": key(it), "model": model, "seed": seed(it),
               **{k: it[k] for k in ("frame", "frame_index", "domain", "cls", "standpoint", "replicate", "shown",
                                     "admits_1", "admits_2", "framing_1", "framing_2")},
               **res}
        with lock:
            with path.open("a") as f:
                f.write(json.dumps(row, sort_keys=True) + "\n")

    with ThreadPoolExecutor(max_workers=parallel) as ex:
        list(ex.map(one, todo))
    print(f"{model}: {len(done_keys(path))} valid of {len(order)}", flush=True)


def run_all(models: dict, out: Path) -> None:
    """Each model in its own thread: {model: (client, parallel)}."""
    threads = [threading.Thread(target=run_model, args=(m, c, out, par)) for m, (c, par) in models.items()]
    for t in threads:
        t.start()
    for t in threads:
        t.join()


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
        run_all({m: (ScriptedValuer(m, args.kind, args.misread), 4)
                 for m in ("scripted/a-1", "scripted/b:free", "scripted/c", "anthropic/scripted-d")}, out)
        return
    out = Path(__file__).parent / "results" / "runs"
    out.mkdir(parents=True, exist_ok=True)
    chosen = args.models or list(CONFIG["models"])
    run_all({m: (OpenRouterClient(m, CONFIG["models"][m]["rpm"], CONFIG["models"][m]["json_mode"],
                                  CONFIG["models"][m]["seed"]), CONFIG["models"][m]["parallel"]) for m in chosen}, out)


if __name__ == "__main__":
    main()
