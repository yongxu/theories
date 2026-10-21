"""The judges of VD2: whether a widening violation's reason describes the plans as they are.

A violation's listed sets can be right while its reason misdescribes the pair (VD1: 23 of 121
right-read violations described a trade the lists did not contain). A judge reads the decision as it
was shown, a plain statement of what the two plans keep, the plan chosen and the reason, and says
whether the reason's account of what each plan keeps and ends is consistent with the plans. It does not
see the standpoint or any sign answer, and a reason that values the ending as good is consistent.

python3 -B vd2_judge.py --calibrate J ...   the candidate judges J on VD1's 121 right-read W1/W2
                                         violations, coded after VD1's verdicts (posthoc.TRADE):
                                         results/vd2/calibration/<judge>.jsonl and calibration.json
python3 -B vd2_judge.py --violations     the frozen judges (JUDGES) on every exact-read widening
                                         violation of VD2 (results/vd2/runs) and of VD1 (results/runs):
                                         results/vd2/judge/<judge>.jsonl
Run from Ren's interactive zsh: zsh -ic 'python3 -B vd2_judge.py ...'; the key is never printed.
"""

from __future__ import annotations

import argparse
import json
import threading
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

from client import LimitReached, NoReply
from frames import FRAMES, item as vd1_item, phrase, join
from run import cost, fname
from vd2_client import OpenRouterTask, ScriptedJudge
from vd2_frames import rank_item

HERE = Path(__file__).parent
OUT = HERE / "results" / "vd2"

# Fixed at the freeze from the calibration (PREDICTIONS-2026-10-21-VD2.md): the two candidates of
# different families, neither the theory's, with the highest agreement with the VD1 coding.
JUDGES: list[str] = ["google/gemini-3.8-flash", "deepseek/deepseek-v4.1-flash-1017"]
CANDIDATES = ("openai/gpt-6-luna", "deepseek/deepseek-v4.1-flash-1017", "google/gemini-3.1-flash-lite",
              "google/gemini-3.8-flash")
SETTINGS = {"rpm": None, "json_mode": "json_schema", "seed": True}

SYSTEM = ("You check whether a person's stated reason describes two plans correctly: what each plan keeps "
          "and what each ends. You do not judge whether the choice or its values are good.")


def judge_prompt(shown_text: str, wider: int, narrower: int, added: list[str], chosen: int, reason: str) -> str:
    """The judge's question for one violation: plan `chosen` (the narrower) was chosen."""
    a = join(added)
    a_or = a if len(added) == 1 else ", ".join(added[:-1]) + " or " + added[-1]
    verb = "ends" if len(added) == 1 else "end"
    return (f"Here is a decision exactly as it was shown to someone:\n\n<<<\n{shown_text}\n>>>\n\n"
            f"Fact: plan {wider} keeps everything that plan {narrower} keeps, and also {a}. So under plan "
            f"{narrower}, {a} {verb}, and plan {wider} ends nothing that plan {narrower} keeps.\n\n"
            f"The person chose plan {chosen} and gave this reason:\n\"{reason}\"\n\n"
            f"Is the reason's account of what each plan keeps and ends consistent with the fact? It is "
            f"inconsistent if it says or implies that plan {narrower} keeps something that plan {wider} ends, "
            f"that plan {wider} ends something that plan {narrower} keeps, or that plan {narrower} keeps "
            f"{a_or}. A reason that calls the ending of {a} good, a gain, or unimportant, or that prefers fewer "
            f"things, is consistent if it describes the plans correctly. Reply in JSON with \"explanation\" "
            f"(at most 30 words) and \"verdict\" (\"consistent\" or \"inconsistent\").")


def judge_item(row: dict, source: str) -> dict:
    """The judge item for a violation row of VD1 (source 'vd1') or VD2 (source 'vd2')."""
    if source == "vd2":
        it = rank_item(row["frame_index"], row["pair"], row["standpoint"])
    else:
        it = vd1_item(row["frame_index"], row["cls"], row["standpoint"])
    shown_text = it["user"].rsplit("\n\n", 1)[0]
    shown = it["shown"]
    wider, narrower = shown.index("A") + 1, shown.index("B") + 1
    sets = {shown[0]: set(it["admits_1"]), shown[1]: set(it["admits_2"])}
    frame = FRAMES[row["frame_index"]]
    added = [phrase(frame, x) for x in [f[0] for f in frame["formations"]] if x in sets["A"] - sets["B"]]
    chosen = {"1": 1, "2": 2}[row["better"]]
    assert chosen == narrower
    return {"task": "judge", "key": f"{source}|{row['model']}|{row['key']}", "source": source,
            "valuer_model": row["model"], "row_key": row["key"],
            "system": SYSTEM, "user": judge_prompt(shown_text, wider, narrower, added, chosen, row["reason"])}


def ask_all(judges: dict, items: list[dict], out: Path) -> None:
    """Each judge on every item not yet valid in its file."""
    out.mkdir(parents=True, exist_ok=True)

    def run(model, client, parallel):
        path = out / fname(model)
        done = set()
        if path.exists():
            done = {json.loads(l)["key"] for l in path.read_text().splitlines() if json.loads(l)["valid"]}
        lock = threading.Lock()
        stopped = threading.Event()

        def one(it):
            if stopped.is_set():
                return
            try:
                res = client.judge(it, 1)
            except NoReply:
                return
            except (LimitReached, RuntimeError) as e:
                stopped.set()
                print(f"{model} stopped: {e}", flush=True)
                return
            row = {"judge": model, **{k: it[k] for k in ("key", "source", "valuer_model", "row_key")}, **res}
            with lock:
                with path.open("a") as f:
                    f.write(json.dumps(row, sort_keys=True) + "\n")

        with ThreadPoolExecutor(max_workers=parallel) as ex:
            list(ex.map(one, [it for it in items if it["key"] not in done]))
        n = sum(1 for l in path.read_text().splitlines() if json.loads(l)["valid"]) if path.exists() else 0
        print(f"{model}: {n} valid rows", flush=True)

    threads = [threading.Thread(target=run, args=(m, c, 8)) for m, c in judges.items()]
    for t in threads:
        t.start()
    for t in threads:
        t.join()


def vd1_coded() -> list[tuple[dict, str]]:
    """VD1's 121 right-read W1/W2 violations with the code given after VD1's verdicts."""
    from analyze import load
    from posthoc import TRADE
    rows = {(r["model"], r["standpoint"], r["frame"], r["cls"]): r for r in load(HERE / "results" / "runs")
            if r["valid"] and r["replicate"] == 0}
    ph = json.loads((HERE / "results" / "posthoc.json").read_text())["right_read_W12_violations"]
    out = []
    for v in ph:
        k = (v["model"], v["standpoint"], v["frame"], v["cls"])
        out.append((rows[k], "inconsistent" if k in TRADE else "consistent"))
    assert len(out) == 121 and sum(c == "inconsistent" for _, c in out) == 23
    return out


def kappa(pairs: list[tuple[str, str]]) -> float:
    n = len(pairs)
    if not n:
        return 0.0
    po = sum(a == b for a, b in pairs) / n
    cats = ("consistent", "inconsistent")
    pe = sum((sum(a == c for a, _ in pairs) / n) * (sum(b == c for _, b in pairs) / n) for c in cats)
    return (po - pe) / (1 - pe) if pe < 1 else 1.0


def calibration_summary(out: Path) -> dict:
    coded = vd1_coded()
    code = {f"vd1|{r['model']}|{r['key']}": c for r, c in coded}
    summary = {}
    for f in sorted(out.glob("*.jsonl")):
        rows = {}
        for l in f.read_text().splitlines():
            r = json.loads(l)
            if r["valid"]:
                rows[r["key"]] = r
        pairs = [(code[k], rows[k]["verdict"]) for k in code if k in rows]
        summary[json.loads(f.read_text().splitlines()[0])["judge"]] = {
            "n": len(pairs), "kappa": kappa(pairs),
            "agreement": sum(a == b for a, b in pairs) / max(1, len(pairs)),
            "coded_inconsistent_called_inconsistent": sum(a == b == "inconsistent" for a, b in pairs),
            "coded_consistent_called_inconsistent": sum(a == "consistent" and b == "inconsistent" for a, b in pairs),
            "cost": sum(cost(json.loads(l)) for l in f.read_text().splitlines()),
        }
    (out.parent / "calibration.json").write_text(json.dumps(summary, indent=1) + "\n")
    return summary


def violation_rows() -> list[tuple[dict, str]]:
    """Every exact-read widening violation: VD2's ranking rows, and VD1's W1, W2 and W1X rows."""
    from analyze import load
    from vd2_analyze import load_rank
    out = [(r, "vd2") for r in load_rank(OUT / "runs") if r["read_exact"] and r["choice"] == "B"]
    out += [(r, "vd1") for r in load(HERE / "results" / "runs")
            if r["valid"] and r["replicate"] == 0 and r["cls"] in ("W1", "W2", "W1X") and r["read_exact"]
            and r["choice"] == "B"]
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--calibrate", nargs="*")
    ap.add_argument("--violations", action="store_true")
    ap.add_argument("--dry", help="scripted judges, VD2 rows from this directory, output beside it")
    args = ap.parse_args()
    if args.calibrate is not None:
        models = args.calibrate or list(CANDIDATES)
        items = [judge_item(r, "vd1") for r, _ in vd1_coded()]
        ask_all({m: OpenRouterTask(m, **SETTINGS) for m in models}, items, OUT / "calibration" / "rows")
        print(json.dumps(calibration_summary(OUT / "calibration" / "rows"), indent=1))
        return
    if args.violations:
        assert len(JUDGES) == 2, "the judges are fixed at the freeze"
        items = [judge_item(r, s) for r, s in violation_rows()]
        print(f"{len(items)} violations to judge")
        ask_all({m: OpenRouterTask(m, **SETTINGS) for m in JUDGES}, items, OUT / "judge")
        return
    if args.dry:
        from vd2_analyze import load_rank
        rows = [(r, "vd2") for r in load_rank(Path(args.dry)) if r["read_exact"] and r["choice"] == "B"]
        ask_all({m: ScriptedJudge(m) for m in ("scripted/j1", "scripted/j2")},
                [judge_item(r, s) for r, s in rows], Path(args.dry).parent / (Path(args.dry).name + "-judge"))


if __name__ == "__main__":
    main()
