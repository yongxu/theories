"""T1N's run (DESIGN.md, section 10, step 4): the need, V1, V2 and the reports at each floor, on the recorders'
tables in FOLDER; the result kept whatever it is, and never overwritten.

    python3 -B experiments/need-measured-in-advance/run.py FOLDER     # writes results/run.json

It refuses unless the freeze checks (frozen): FROZEN.sha256, and each addendum's link after it, committed once
and never changed (one blob across the full history), each after the one before, none committed and then
removed, each listing the files before it and its own text and changing none but layout.json and the dry run's
record; the newest link's files the bytes it names and committed; and the dry run's record passed, every
check, on the code that link names. It refuses unless every input file is the one downloads.json records, by
its sha-256, and where results/run.json exists. Standard library only; no model is called.
"""

import hashlib
import json
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import t1n                       # noqa: E402
import reader                    # noqa: E402

OUT = HERE / "results" / "run.json"
DOWNLOADS = HERE / "downloads.json"


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def parse(link):
    return {p: h for h, p in (line.split() for line in Path(link).read_text().splitlines() if line.strip())}


def git(repo, *args):
    return subprocess.run(["git", "-C", str(repo), *args], capture_output=True, text=True, check=True).stdout


def blobs(repo, rel):
    """Every commit of the full history touching rel, newest first, with the blob rel has in each (None where
    absent), as freeze 1's chain reads them (told/run.py): a link is committed once where all its commits hold
    one blob, so a merge carrying it unchanged does not count against it."""
    out = []
    for c in git(repo, "rev-list", "--full-history", "--topo-order", "HEAD", "--", rel).split():
        r = subprocess.run(["git", "-C", str(repo), "rev-parse", "--verify", "-q", f"{c}:{rel}"],
                           capture_output=True, text=True)
        out.append((c, r.stdout.strip() if r.returncode == 0 else None))
    return out


def frozen(repo=None, here=HERE):
    """The freeze's chain, checked; returns the newest link's name and its commit, or refuses."""
    repo = Path(repo) if repo else here.parents[1]
    folder = here.relative_to(repo)
    may_change = {str(folder / "layout.json"), str(folder / "results" / "dry-run.json")}
    base = here / "FROZEN.sha256"
    if not base.exists():
        raise SystemExit("FROZEN.sha256 is not written: the test is not frozen")
    links = [base]
    while (here / "addenda" / f"FROZEN-{len(links)}.sha256").exists():
        links.append(here / "addenda" / f"FROZEN-{len(links)}.sha256")
    found = sorted((here / "addenda").glob("FROZEN-*.sha256")) if (here / "addenda").exists() else []
    if len(found) != len(links) - 1:
        raise SystemExit(f"the addenda's links are not numbered 1 to {len(found)}")
    nxt = str(folder / "addenda" / f"FROZEN-{len(links)}.sha256")
    if git(repo, "rev-list", "--full-history", "HEAD", "--", nxt).split():
        raise SystemExit(f"{nxt} was committed and is gone: the chain was cut")
    prev, prev_commit = None, None
    for k, link in enumerate(links):
        rel = str(link.relative_to(repo))
        history = blobs(repo, rel)
        if not history or len({b for _, b in history}) != 1 or history[0][1] is None \
                or git(repo, "status", "--porcelain", "--", rel).strip():
            raise SystemExit(f"{rel} must be committed exactly once and never changed")
        commit = history[-1][0]
        if prev_commit and subprocess.run(["git", "-C", str(repo), "merge-base", "--is-ancestor", prev_commit,
                                           commit]).returncode != 0:
            raise SystemExit(f"{rel} was not committed after the link before it")
        hashes = parse(link)
        if prev is not None:
            own = str(folder / "addenda" / f"ADDENDUM-{k}.md")
            if own not in hashes or set(hashes) - set(prev) != {own} or not set(prev) <= set(hashes):
                raise SystemExit(f"{rel} must list the files before it and its own {own}, and no other")
            changed = {p for p in prev if prev[p] != hashes[p]}
            if changed - may_change:
                raise SystemExit(f"{rel} changes files an addendum may not: {sorted(changed - may_change)}")
        prev, prev_commit = hashes, commit
    bad = [p for p, h in prev.items() if sha(repo / p) != h]
    if bad:
        raise SystemExit(f"frozen files differ from the newest link: {bad}")
    if git(repo, "status", "--porcelain", "--", *prev).strip():
        raise SystemExit("frozen files differ from the commit")
    record = json.loads((here / "results" / "dry-run.json").read_text())
    if record["failed"] or not record["code unchanged during the run"] \
            or any(prev.get(p) != h for p, h in record["code hashes"].items()):
        raise SystemExit("the dry run's record did not pass every check on the code the newest link names")
    return {"link": str(links[-1].relative_to(repo)), "commit": prev_commit}


def inputs(folder):
    """The input files' sha-256, each checked against downloads.json; refuses where one is not recorded."""
    if not DOWNLOADS.exists():
        raise SystemExit("downloads.json is not written: no download is recorded")
    recorded = {d["file"]: d["sha256"] for d in json.loads(DOWNLOADS.read_text())["files"]}
    out = {}
    for name in reader.FILES.values():
        p = Path(folder) / name
        if p.exists():
            out[name] = sha(p)
            if recorded.get(name) != out[name]:
                raise SystemExit(f"{name} is not the file downloads.json records")
    return out


def run(folder, check_frozen=True, check_inputs=True):
    stamp = frozen() if check_frozen else {"link": None, "note": "the dry run's: the freeze not checked"}
    hashes = inputs(folder) if check_inputs else None
    facts = reader.layout_facts(folder)
    lakes, meta = reader.read_all(folder)
    lakes = list(lakes.values())
    labels = meta["labels per year"]
    out = {"frozen": stamp, "inputs": hashes, "layout facts": facts, "reading": meta, "lakes read": len(lakes),
           "labels": "per year" if labels else "static: the stocking records alone decide the scope and fate"}
    last = facts["last estimate year"] - t1n.GAP_MIN
    by_floor = {}
    for floor in t1n.FLOORS_REPORTED:
        nd = t1n.need(lakes, floor=floor, labels=labels)
        cell = {"need": nd}
        if nd["need"] is not None:
            res = t1n.read(lakes, nd["need"], t1n.FIRST_REF, last, floor, labels)
            cell.update({"V1": res["V1"], "V2": res["V2"], "reports": res["reports"],
                         "renewal below the need (reported)": t1n.renewal_below(lakes, nd, floor=floor, labels=labels)})
            if floor == t1n.FLOOR:
                out["rows"] = res["rows"]
                alone = t1n.read(lakes, nd["need"], t1n.FIRST_REF, last, floor, labels, label_alone=True)
                cell["V1 with the label alone a fall (the reading set aside)"] = alone["V1"]["verdict"]
                closed = [lk for lk in lakes if lk.get("closed") is True]
                if closed:
                    cell["recorded seepage lakes alone (reported)"] = t1n.read(
                        closed, nd["need"], t1n.FIRST_REF, last, floor, labels)["V1"]
        by_floor[f"floor {floor}"] = cell
    out["by floor"] = by_floor
    decided = by_floor[f"floor {t1n.FLOOR}"]
    out["V1"] = decided.get("V1", {"verdict": "not decided: no need, " + decided["need"].get("reason", "")})
    out["V2"] = decided.get("V2")
    return out


def main():
    if len(sys.argv) != 2:
        raise SystemExit(__doc__)
    if OUT.exists():
        raise SystemExit(f"{OUT.name} exists: the run is made once and its result kept")
    out = run(Path(sys.argv[1]))
    OUT.parent.mkdir(exist_ok=True)
    OUT.write_text(json.dumps(out, indent=1, default=sorted) + "\n")
    print(json.dumps({"V1": out["V1"].get("verdict"), "V2 met": (out["V2"] or {}).get("met")}, indent=1))


if __name__ == "__main__":
    main()
