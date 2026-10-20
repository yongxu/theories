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

from client import LimitReached, NoReply, OpenRouterClient, ScriptedValuer
from frames import CLASSES, all_items

# The original freeze's configuration, never run (the OpenAI account had no credit):
#   gpt-4o-mini-2024-07-18, gpt-4.1-nano-2025-04-14, gpt-4.1-mini-2025-04-14, gpt-5.4-mini-2026-03-17.
# The first addendum's, never run (superseded; the Claude plan was at its weekly limit):
#   claude-haiku-5-5, claude-sonnet-5-5, claude-opus-5-5 through headless Claude Code (client.ClaudeCLIClient).
CONFIG = {
    "provider": "openrouter",
    "budget_usd": 10.0,
    "models": {
        "deepseek/deepseek-v4.1-flash-1017": {"parallel": 8, "rpm": None, "json_mode": "json_schema", "seed": True},
        "z-ai/glm-5.3-flash": {"parallel": 8, "rpm": None, "json_mode": "json_schema", "seed": True},
        "openai/gpt-6-luna": {"parallel": 8, "rpm": None, "json_mode": "json_schema", "seed": True},
        "anthropic/claude-haiku-5.5": {"parallel": 8, "rpm": None, "json_mode": "json_schema", "seed": False},
        "qwen/qwen3.8-flash": {"parallel": 8, "rpm": None, "json_mode": "json_schema", "seed": True},
        "nvidia/nemotron-3.5-lightning": {"parallel": 8, "rpm": None, "json_mode": "json_schema", "seed": True},
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


class Spend:
    """The run's spend, from the cost OpenRouter reports in each row; at the budget every model stops."""

    def __init__(self, out: Path, budget: float | None):
        self.budget, self.lock, self.stop = budget, threading.Lock(), threading.Event()
        self.total = sum(cost(json.loads(line)) for f in out.glob("*.jsonl") for line in f.read_text().splitlines())

    def add(self, c: float) -> None:
        with self.lock:
            self.total += c
            if self.budget is not None and self.total >= self.budget and not self.stop.is_set():
                self.stop.set()
                print(f"budget reached: ${self.total:.2f}; stopping", flush=True)


def cost(row: dict) -> float:
    c = (row.get("usage") or {}).get("cost")
    return float(c) if isinstance(c, (int, float)) else 0.0


def run_model(model: str, client, out: Path, parallel: int, spend: Spend, through: int | None) -> None:
    """Every presentation not yet valid for this model, in standpoint order, replicates last; with
    `through`, only the main design's standpoints up to it."""
    path = out / fname(model)
    done = done_keys(path)
    order = sorted(all_items(), key=lambda it: (it["replicate"], it["standpoint"], it["frame_index"],
                                                CLASSES.index(it["cls"])))
    if through is not None:
        order = [it for it in order if it["replicate"] == 0 and it["standpoint"] <= through]
    todo = [it for it in order if key(it) not in done]
    lock = threading.Lock()
    stopped = threading.Event()

    def one(it):
        if stopped.is_set() or spend.stop.is_set():
            return
        try:
            res = client.judge(it, seed(it))
        except NoReply:
            return  # no row: a later run makes the call again
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
        spend.add(cost(row))

    with ThreadPoolExecutor(max_workers=parallel) as ex:
        list(ex.map(one, todo))
    print(f"{model}: {len(done_keys(path))} valid of {len(order)}", flush=True)


def run_all(models: dict, out: Path, budget: float | None = None, through: int | None = None) -> None:
    """Each model in its own thread: {model: (client, parallel)}."""
    spend = Spend(out, budget)
    threads = [threading.Thread(target=run_model, args=(m, c, out, par, spend, through))
               for m, (c, par) in models.items()]
    for t in threads:
        t.start()
    for t in threads:
        t.join()
    print(f"spend so far: ${spend.total:.4f}", flush=True)


def project(out: Path, through: int) -> float:
    """The staged projection of the second addendum: each model's reported cost on the main design's
    standpoints up to `through`, scaled to its 1,920 presentations. Reads costs and keys only."""
    n = sum(1 for it in all_items() if it["replicate"] == 0 and it["standpoint"] <= through)
    total = 0.0
    for m in CONFIG["models"]:
        path = out / fname(m)
        rows = [json.loads(line) for line in path.read_text().splitlines()] if path.exists() else []
        stage = [r for r in rows if r["replicate"] == 0 and r["standpoint"] <= through]
        c = sum(cost(r) for r in stage)
        p = c * len(all_items()) / n
        total += p
        print(f"{m}: {len(done_keys(path) & {r['key'] for r in stage})} of {n} done, ${c:.4f}, projected ${p:.2f}")
    kept = {fname(m) for m in CONFIG["models"]}
    outside = sum(cost(json.loads(line)) for f in out.glob("*.jsonl") if f.name not in kept
                  for line in f.read_text().splitlines())
    total += outside
    print(f"spent on models outside the configuration: ${outside:.4f}")
    print(f"projected total: ${total:.2f}")
    return total


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry")
    ap.add_argument("--kind", default="weigher")
    ap.add_argument("--misread", type=float, default=0.0)
    ap.add_argument("--models", nargs="*")
    ap.add_argument("--through", type=int, help="only the main design's standpoints up to this one")
    ap.add_argument("--budget", type=float, default=CONFIG["budget_usd"])
    ap.add_argument("--project", type=int, help="print the projection from the standpoints up to this one")
    args = ap.parse_args()
    if args.project is not None:
        project(Path(args.dry) if args.dry else Path(__file__).parent / "results" / "runs", args.project)
        return
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
                                  CONFIG["models"][m]["seed"]), CONFIG["models"][m]["parallel"]) for m in chosen}, out,
            args.budget, args.through)


if __name__ == "__main__":
    main()
