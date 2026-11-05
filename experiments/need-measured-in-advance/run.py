"""T1N's run (DESIGN.md, section 10, step 4): the need under the branch the fallback order settles, V1, V2 and
the reports, on the recorders' tables in FOLDER; the result kept whatever it is.

    python3 -B experiments/need-measured-in-advance/run.py FOLDER     # writes results/run.json

It refuses unless the freeze checks: FROZEN.sha256, and each addendum's link after it, committed once and
never changed, each link listing the one before's files and its own text, changing none but MAY_CHANGE,
and the newest link's files the bytes it names. Standard library only; no model is called.
"""

import hashlib
import json
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[1]
sys.path.insert(0, str(HERE))
import t1n                       # noqa: E402
import reader                    # noqa: E402

FOLDER = HERE.relative_to(REPO)
BASE = HERE / "FROZEN.sha256"
MAY_CHANGE = frozenset({str(FOLDER / "reader.py"), str(FOLDER / "results" / "dry-run.json")})
OUT = HERE / "results" / "run.json"


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def parse(link):
    return {p: h for h, p in (line.split() for line in Path(link).read_text().splitlines() if line.strip())}


def git(*args):
    return subprocess.run(["git", "-C", str(REPO), *args], capture_output=True, text=True).stdout


def blobs(rel):
    """Every commit of the full history touching rel, newest first, with the blob rel has in each (None where
    absent), as freeze 1's chain reads them (told/run.py): a link is committed once where all its commits
    hold one blob, so a merge carrying it unchanged does not count against it."""
    out = []
    for c in git("rev-list", "--full-history", "--topo-order", "HEAD", "--", rel).split():
        r = subprocess.run(["git", "-C", str(REPO), "rev-parse", "--verify", "-q", f"{c}:{rel}"],
                           capture_output=True, text=True)
        out.append((c, r.stdout.strip() if r.returncode == 0 else None))
    return out


def frozen():
    """The freeze's chain, checked: returns the newest link's name and its hashes, or refuses."""
    if not BASE.exists():
        raise SystemExit("FROZEN.sha256 is not written: the test is not frozen")
    links = [BASE]
    while (HERE / "addenda" / f"FROZEN-{len(links)}.sha256").exists():
        links.append(HERE / "addenda" / f"FROZEN-{len(links)}.sha256")
    found = sorted((HERE / "addenda").glob("FROZEN-*.sha256")) if (HERE / "addenda").exists() else []
    if len(found) != len(links) - 1:
        raise SystemExit(f"the addenda's links are not numbered 1 to {len(found)}")
    prev, prev_commit = None, None
    for k, link in enumerate(links):
        rel = str(link.relative_to(REPO))
        history = blobs(rel)
        if not history or len({b for _, b in history}) != 1 or history[0][1] is None \
                or git("status", "--porcelain", "--", rel).strip():
            raise SystemExit(f"{rel} must be committed exactly once and never changed")
        commit = history[-1][0]
        if prev_commit and subprocess.run(["git", "-C", str(REPO), "merge-base", "--is-ancestor", prev_commit,
                                           commit]).returncode != 0:
            raise SystemExit(f"{rel} was not committed after the link before it")
        prev_commit = commit
        hashes = parse(link)
        if prev is not None:
            own = str(FOLDER / "addenda" / f"ADDENDUM-{k}.md")
            if own not in hashes or set(hashes) - set(prev) != {own} or not set(prev) <= set(hashes):
                raise SystemExit(f"{rel} must list the files before it and its own {own}, and no other")
            changed = {p for p in prev if prev[p] != hashes[p]}
            if changed - MAY_CHANGE:
                raise SystemExit(f"{rel} changes files an addendum may not: {sorted(changed - MAY_CHANGE)}")
        prev = hashes
    bad = [p for p, h in prev.items() if sha(REPO / p) != h]
    if bad:
        raise SystemExit(f"frozen files differ from the newest link: {bad}")
    if git("status", "--porcelain", "--", *prev).strip():
        raise SystemExit("frozen files differ from the commit")
    return {"link": str(links[-1].relative_to(REPO)), "commit": prev_commit}


def verdicts(lakes, needs, first, last, floor=t1n.FLOOR):
    res = t1n.read(lakes, needs, first, last, floor)
    return {"V1": res["V1"], "V2": res["V2"], "reports": res["reports"]}


def run(folder, check_frozen=True):
    stamp = frozen() if check_frozen else {"link": None, "note": "the dry run's: the freeze not checked"}
    facts = reader.layout_facts(folder)
    lakes = list(reader.read_all(folder).values())
    curves = reader.curves(folder)
    last = facts["last estimate year"] - t1n.GAP_MIN
    branch = "A" if len(curves) >= t1n.BRANCH_A_LAKES else "B"
    out = {"frozen": stamp, "layout facts": facts, "lakes read": len(lakes), "branch deciding V1": branch}
    b = {}
    for floor in t1n.FLOORS_REPORTED:
        nb = t1n.need_branch_b(lakes, floor=floor)
        cell = {"need": nb}
        if nb["need"] is not None:
            cell.update(verdicts(lakes, {lk["id"]: nb["need"] for lk in lakes}, t1n.FIRST_REF, last, floor))
            seep = [lk for lk in lakes if lk.get("seepage")]
            if seep:
                cell["seepage lakes alone (reported)"] = verdicts(seep, {lk["id"]: nb["need"] for lk in seep},
                                                                  t1n.FIRST_REF, last, floor)["V1"]
        b[f"floor {floor}"] = cell
    out["branch B"] = b
    if branch == "A":
        pub_last = max(c[2] for c in curves.values())
        a = {}
        for floor in t1n.FLOORS_REPORTED:
            needs = {lid: t1n.need_branch_a(form, params, floor) for lid, (form, params, _) in curves.items()}
            needs = {k: v for k, v in needs.items() if v is not None}
            a[f"floor {floor}"] = {"lakes with a need": len(needs), "references from": pub_last + 1,
                                   **verdicts(lakes, needs, pub_last + 1, last, floor)}
        out["branch A"] = a
    decided = out["branch A" if branch == "A" else "branch B"][f"floor {t1n.FLOOR}"]
    out["V1"] = decided.get("V1", {"verdict": "not decided: no need"})
    out["V2"] = decided.get("V2")
    if branch == "A":
        needs = {lid: t1n.need_branch_a(form, params) for lid, (form, params, _) in curves.items()}
        out["rows"] = t1n.rows(lakes, {k: v for k, v in needs.items() if v is not None},
                               max(c[2] for c in curves.values()) + 1, last)
    elif b[f"floor {t1n.FLOOR}"]["need"]["need"] is not None:
        y = b[f"floor {t1n.FLOOR}"]["need"]["need"]
        out["rows"] = t1n.rows(lakes, {lk["id"]: y for lk in lakes}, t1n.FIRST_REF, last)
    return out


def main():
    if len(sys.argv) != 2:
        raise SystemExit(__doc__)
    out = run(Path(sys.argv[1]))
    OUT.parent.mkdir(exist_ok=True)
    OUT.write_text(json.dumps(out, indent=1, default=sorted) + "\n")
    print(json.dumps({"branch": out["branch deciding V1"], "V1": out["V1"].get("verdict"),
                      "V2 met": (out["V2"] or {}).get("met")}, indent=1))


if __name__ == "__main__":
    main()
