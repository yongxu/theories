"""Runs VD2: every model x presentation, one call each (results/vd2/runs/<model>.jsonl).

python3 -B vd2_run.py [--through S] [--budget B]   the configuration below (OpenRouter); resumes
                                    where a file stops. Run it from Ren's interactive zsh so that it
                                    inherits OPENROUTER_API_KEY:  zsh -ic 'python3 -B vd2_run.py'
python3 -B vd2_run.py --project S   the projection from the standpoints up to S (reads costs only)
python3 -B vd2_run.py --dry D --kind K   every code path with scripted valuers of kind K, written to D

Each model has its own queue in standpoint order: for each standpoint the first elicitation of the
96 formations, the second, then the 96 widenings. A model whose daily cap is reached, or whose calls
fail for good, stops; the others go on. The budget guard (VD1's run.Spend, over VD2's rows only) stops
every model at the budget.
"""

from __future__ import annotations

import argparse
import json
import threading
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

from client import LimitReached, NoReply
from run import CONFIG as VD1_CONFIG, Spend, cost, fname
from vd2_client import OpenRouterTask, ScriptedValuer
from vd2_frames import all_items

HERE = Path(__file__).parent
OUT = HERE / "results" / "vd2"

# VD1's six valuers, client settings unchanged (run.CONFIG). The budget was VD1's scale ($6) at the
# freeze; Ren approved $9 (PREDICTIONS-2026-10-21-VD2.md, "Run notes").
CONFIG = {
    "provider": "openrouter",
    "budget_usd": 9.0,
    "models": dict(VD1_CONFIG["models"]),
}
ROW_KEYS = ("key", "task", "frame", "frame_index", "domain", "standpoint", "formation", "kind", "elicitation",
            "levels", "pair", "added", "shown", "admits_1", "admits_2", "framing_1", "framing_2")


def seed(it: dict) -> int:
    """A fixed seed per presentation (for the models that take one)."""
    base = 2_000_000 + 10_000 * it["standpoint"] + 100 * it["frame_index"]
    if it["task"] == "sign":
        from frames import FRAMES
        labels = [f[0] for f in FRAMES[it["frame_index"]]["formations"]]
        return base + 10 * it["elicitation"] + labels.index(it["formation"])
    return base + 50 + it["pair"]


def done_keys(path: Path) -> set:
    done = set()
    if path.exists():
        for line in path.read_text().splitlines():
            row = json.loads(line)
            if row["valid"]:
                done.add(row["key"])
    return done


def run_model(model: str, client, out: Path, parallel: int, spend: Spend, through: int | None) -> None:
    path = out / fname(model)
    done = done_keys(path)
    order = all_items()
    if through is not None:
        order = [it for it in order if it["standpoint"] <= through]
    todo = [it for it in order if it["key"] not in done]
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
        row = {"model": model, "seed": seed(it), **{k: it[k] for k in ROW_KEYS if k in it}, **res}
        with lock:
            with path.open("a") as f:
                f.write(json.dumps(row, sort_keys=True) + "\n")
        spend.add(cost(row))

    with ThreadPoolExecutor(max_workers=parallel) as ex:
        list(ex.map(one, todo))
    print(f"{model}: {len(done_keys(path))} valid of {len(order)}", flush=True)


def run_all(models: dict, out: Path, budget: float | None = None, through: int | None = None) -> None:
    out.mkdir(parents=True, exist_ok=True)
    spend = Spend(out, budget)
    threads = [threading.Thread(target=run_model, args=(m, c, out, par, spend, through))
               for m, (c, par) in models.items()]
    for t in threads:
        t.start()
    for t in threads:
        t.join()
    print(f"spend so far: ${spend.total:.4f}", flush=True)


def project(out: Path, through: int) -> float:
    """Each model's reported cost on the standpoints up to `through`, scaled to all sixteen, plus the
    judges' spend so far. Reads costs and keys only."""
    items = all_items()
    n_stage = sum(1 for it in items if it["standpoint"] <= through)
    total = 0.0
    for m in CONFIG["models"]:
        path = out / fname(m)
        rows = [json.loads(line) for line in path.read_text().splitlines()] if path.exists() else []
        stage = [r for r in rows if r["standpoint"] <= through]
        c = sum(cost(r) for r in stage)
        p = c * len(items) / n_stage
        total += p
        print(f"{m}: {len(done_keys(path) & {r['key'] for r in stage})} of {n_stage} done, ${c:.4f}, "
              f"projected ${p:.2f}")
    judge_dir = out.parent / "judge"
    judged = sum(cost(json.loads(line)) for f in judge_dir.glob("*.jsonl") for line in f.read_text().splitlines()) \
        if judge_dir.exists() else 0.0
    total += judged
    print(f"judges so far: ${judged:.4f}")
    print(f"projected total (valuers, before the judges' run on violations): ${total:.2f}")
    return total


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry")
    ap.add_argument("--kind", default="signed")
    ap.add_argument("--misread", type=float, default=0.0)
    ap.add_argument("--sd", type=float, default=0.0, help="dry runs: per-call noise of the scripted weights")
    ap.add_argument("--models", nargs="*")
    ap.add_argument("--through", type=int, help="only the standpoints up to this one")
    ap.add_argument("--budget", type=float, default=CONFIG["budget_usd"])
    ap.add_argument("--project", type=int, help="print the projection from the standpoints up to this one")
    args = ap.parse_args()
    if args.project is not None:
        project(Path(args.dry) if args.dry else OUT / "runs", args.project)
        return
    if args.dry:
        run_all({m: (ScriptedValuer(m, args.kind, args.misread, sd=args.sd), 4) for m in CONFIG["models"]},
                Path(args.dry), None, args.through)
        return
    chosen = args.models or list(CONFIG["models"])
    c = CONFIG["models"]
    run_all({m: (OpenRouterTask(m, c[m]["rpm"], c[m]["json_mode"], c[m]["seed"]), c[m]["parallel"]) for m in chosen},
            OUT / "runs", args.budget, args.through)


if __name__ == "__main__":
    main()
