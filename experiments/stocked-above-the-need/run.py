"""T1R's run (DESIGN.md, section 10): on the recorders' tables in FOLDER, the folder T1N's downloads fill, with R8
where it could be had: T1N's need, then V1 and its readings, the reports, and the lakes T1N also reads; the result
kept whatever it is, and never overwritten.

    python3 -B experiments/stocked-above-the-need/run.py FOLDER     # writes results/run.json

It refuses unless T1N's freeze checks and T1R's does, by T1N's own check (its run.py's `frozen`, here on T1R's
folder): each link committed once and never changed, the newest link's files the bytes it names and committed,
and the dry run's record passed on that code. It refuses unless T1N's downloads.json is committed once and its
files are in the folder with their sha-256, by T1N's own `inputs`; unless R8, where it is in the folder, is
recorded with its sha-256 in T1R's downloads.json, committed once; and where results/run.json exists.
Standard library only; no model is called.
"""

import importlib.util
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import t1r                       # noqa: E402  (checks T1N's files against T1N's freeze as it loads)
import additions                 # noqa: E402
import reader                    # noqa: E402  (T1N's)
t1n = t1r.t1n
_spec = importlib.util.spec_from_file_location("t1n_run", t1r.T1N_DIR / "run.py")
T1N_RUN = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(T1N_RUN)

OUT = HERE / "results" / "run.json"
DOWNLOADS = HERE / "downloads.json"


def frozen():
    """T1N's freeze and T1R's, each by T1N's frozen check; refuses where either fails."""
    return {"T1N": T1N_RUN.frozen(), "T1R": T1N_RUN.frozen(here=HERE)}


def inputs(folder):
    """T1N's downloads by T1N's own check, and R8 by T1R's downloads.json where the file is in the folder."""
    T1N_RUN.once(t1r.T1N_DIR.parents[1], str(T1N_RUN.DOWNLOADS.relative_to(t1r.T1N_DIR.parents[1])))
    out = {"T1N's": T1N_RUN.inputs(folder)}
    r8 = Path(folder) / additions.MARKS["file"]
    if DOWNLOADS.exists():
        T1N_RUN.once(HERE.parents[1], str(DOWNLOADS.relative_to(HERE.parents[1])))
        recorded = {d["file"]: d["sha256"] for d in json.loads(DOWNLOADS.read_text())["files"]}
        for name, h in recorded.items():
            if not (Path(folder) / name).exists() or T1N_RUN.sha(Path(folder) / name) != h:
                raise SystemExit(f"{name} is not the file T1R's downloads.json records, or is missing")
        out["T1R's"] = recorded
    elif r8.exists():
        raise SystemExit(f"{r8.name} is in the folder and T1R's downloads.json does not record it")
    return out


def run(folder, check_frozen=True, check_inputs=True):
    stamp = frozen() if check_frozen else {"note": "the dry run's: the freezes not checked"}
    hashes = inputs(folder) if check_inputs else None
    lakes, meta = reader.read_all(folder)
    lakes = list(lakes.values())
    labels = meta["labels per year"]
    dated, _ = additions.dated(folder)
    marks, marks_read = additions.marks(folder)
    out = {"frozen": stamp, "inputs": hashes, "layout facts": {"T1N's": reader.layout_facts(folder),
                                                                "T1R's": additions.facts(folder)},
           "reading": {**meta, "R8": marks_read, "stocking dates read": dated is not None}, "lakes read": len(lakes)}
    nd = t1n.need(lakes, floor=t1n.FLOOR, labels=labels)
    out["need"] = nd
    if nd["need"] is None:
        out["V1"] = {"verdict": "not decided: no need, " + nd.get("reason", "")}
    else:
        res = t1r.read(lakes, nd, dated, marks=marks)
        out.update(res)
        mine = {r["id"] for r in res["rows"] if "out" not in r}
        last = max(t for lk in lakes for t in lk["adults"]) - t1n.GAP_MIN
        theirs = {r["id"] for r in t1n.read(lakes, nd["need"], t1n.FIRST_REF, last, t1n.FLOOR, labels)["rows"] if "out" not in r}
        out["lakes T1R reads that T1N also reads (reported)"] = {"T1R's lakes read": len(mine), "of them read by T1N": len(mine & theirs)}
        ids = reader.seen(lakes)
        out["without the lakes a search summary showed (reported)"] = (
            {"lakes": None, "V1": "not computed: no lake's name was read"} if ids is None else
            {"lakes": [], "V1": "not computed: no lake in the county matches the names (T1N's DESIGN.md, section 9)"}
            if not ids else
            {"lakes": ids, "V1": t1r.read([lk for lk in lakes if lk["id"] not in ids], nd, dated)["V1"]["verdict"]})
    return out


def main():
    if len(sys.argv) != 2:
        raise SystemExit(__doc__)
    if OUT.exists():
        raise SystemExit(f"{OUT} exists: the run is kept once and never overwritten")
    out = run(sys.argv[1])
    OUT.parent.mkdir(exist_ok=True)
    OUT.write_text(json.dumps(out, indent=1, default=sorted) + "\n")
    print(out["V1"]["verdict"])


if __name__ == "__main__":
    main()
