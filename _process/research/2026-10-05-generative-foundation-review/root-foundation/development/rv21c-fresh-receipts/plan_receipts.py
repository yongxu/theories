#!/usr/bin/env python3
"""RV21c: the periphery receipts to rerun, decided from the records at run time, written to out/receipts.json.

The list is not fixed in the kit, because a core landing before the runs can make more receipts stale (HE2 edits
Grammar.lean and GrammarLaws.lean, in the closures of cells-under-noise and both free-energy receipts). A periphery
checker is rerun when some record's proof binding names its pointer or one of its runs, and that bound receipt binds a
source whose bytes differ from REV's (stale_bound.py's test). The core is left out: its fresh run is separate. Order:
PE2's (PR1's) first, then the rest by path.

A bound receipt in an older layout (no `<name>-checks/<utc>` run under a `*-verification.json` pointer, or a receipt
there that records no `source_paths`) is not rerun by this kit; it is classified instead (`older_layout`): for each source a record binds to it, the source's import
closure is followed through the files beside it, and every file in the closure is compared with the hash the receipt
recorded for that module. `stale` lists the files whose bytes differ; `unrecorded`, those the receipt gives no hash for;
`compared` is false where an import could not be found or no file of the closure is recorded, and the texts name
those receipts as not compared rather than counting them as matching.

Also written, for the texts: the earlier receipts' reuse of steps from builds no one kept, counted at REV (a reused
step whose origin stamp names no tracked run folder), as occurrences and as distinct keys, for the core pointer and
for the periphery pointers to be rerun.

usage: plan_receipts.py [REV] [--out NAME]   (default HEAD, receipts.json)   -> writes out/NAME, prints the list.
       Run again after the re-points with another NAME, the receipts still to rerun are exactly the failed checkers.
"""
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[5]
LEAN = "experiments/integrated-correction/general-framework/generative-basis/lean/"
CORE_POINTER = LEAN + "becoming/becoming-verification.json"
RECORDS = REPO / "theories/becoming/results/records"
OUT = HERE / "out"
sys.path.insert(0, str(HERE.parent / "pe2-propext-uses"))
from uses import RECEIPTS as PE2  # noqa: E402


def git(*args):
    return subprocess.run(["git", *args], cwd=REPO, capture_output=True, text=True, check=True).stdout


def show(rev, path):
    p = subprocess.run(["git", "show", f"{rev}:{path}"], cwd=REPO, capture_output=True)
    return p.stdout if p.returncode == 0 else None


def resolve(rel, base):
    for root in (REPO / LEAN, base, REPO / "experiments", REPO):
        path = (root / rel).resolve()
        if path.exists():
            return path
    return (REPO / LEAN / rel).resolve()


def pointer_of(receipt):
    """The pointer a bound receipt belongs to: itself, or `<dir>/<name>-verification.json` for a run of `<name>-checks`."""
    if receipt.endswith("-verification.json") and "-checks/" not in receipt:
        return receipt
    m = re.match(r"(.*)/([^/]+)-checks/[0-9TZ.]+/verification\.json$", receipt)
    if not m:
        return None
    pointer = f"{m[1]}/{m[2]}-verification.json"
    return pointer if (REPO / pointer).exists() else None


def recorded_hashes(d):
    """Module stem -> (recorded path or None, sha256) for a receipt in any of the older layouts."""
    out = {}
    rows = d.get("modules", [])
    if isinstance(rows, dict):
        rows = [{"module": k, **v} for k, v in rows.items() if isinstance(v, dict)]
    elif not isinstance(rows, list):
        rows = []
    for m in rows:
        if not isinstance(m, dict):
            continue
        src = m.get("source") or m.get("path")
        name = m.get("module") or m.get("name") or (Path(src).stem if src else None)
        h = m.get("source_sha256") or m.get("sha256")
        if name and isinstance(h, str):
            out[name] = (src, h)
    if isinstance(d.get("source_sha256"), dict):
        for n, h in d["source_sha256"].items():
            out.setdefault(Path(n).stem, (None, h))
    elif isinstance(d.get("source"), str) and isinstance(d.get("source_sha256"), str):
        out[Path(d["source"]).stem] = (d["source"], d["source_sha256"])
    # `sources`: file name -> sha256, or module -> {path, sha256}.
    if isinstance(d.get("sources"), dict):
        for n, v in d["sources"].items():
            if isinstance(v, str):
                out.setdefault(Path(n).stem, (None, v))
            elif isinstance(v, dict) and isinstance(v.get("sha256"), str):
                out.setdefault(Path(n).stem, (v.get("path"), v["sha256"]))
    return out


def older_layout(receipt, sources, sha):
    """Follow each bound source's import closure and compare it with the hashes the receipt recorded."""
    d = json.loads((REPO / receipt).read_text())
    known = recorded_hashes(d)
    # A receipt holding one bare hash for one bound source records that source.
    if not known and isinstance(d.get("source_sha256"), str) and len(sources) == 1:
        only = sorted(sources)[0]
        known[Path(only).stem] = (only, d["source_sha256"])
    roots = [REPO / LEAN, REPO / LEAN / "deeper", REPO / LEAN / "systems-complexity"]

    def find(mod, near):
        rec = known.get(mod, (None, None))[0]
        if rec and (REPO / rec).is_file():
            return REPO / rec
        for root in (near, near.parent, near.parent / "formal", *roots):
            if (root / (mod.replace(".", "/") + ".lean")).is_file():
                return root / (mod.replace(".", "/") + ".lean")
        # Elsewhere in the repository: only a single live file of that name is taken.
        found = live_lean(mod)
        return REPO / found[0] if len(found) == 1 else None

    closure, todo, missing = set(), [REPO / s for s in sources], set()
    while todo:
        f = todo.pop()
        if f in closure:
            continue
        closure.add(f)
        for m in re.findall(r"^import\s+(\S+)", f.read_text(), re.M):
            if m in ("Std", "Init") or m.startswith(("Std.", "Init.", "Mathlib", "Lean.")):
                continue
            q = find(m, f.parent)
            todo.append(q) if q else missing.add(m)
    stale, unrecorded = [], []
    for f in sorted(closure):
        rel = str(f.relative_to(REPO))
        if f.stem not in known:
            unrecorded.append(rel)
        elif sha(rel) != known[f.stem][1]:
            stale.append(rel)
    # Not compared: an import the walk could not find, or no file of the closure recorded at all. An unresolved
    # import with a live file of that name anywhere (outside run folders and history) is a gap in the walk, which
    # run.sh stops on; one that exists only as copies inside run folders has no live source to differ.
    compared = not missing and len(unrecorded) < len(closure)
    live = sorted(m for m in missing if live_lean(m))
    return {"sources": sorted(sources), "closure": len(closure), "stale": stale,
            "unrecorded": unrecorded, "unresolved_imports": sorted(missing), "unresolved_live": live,
            "compared": compared}


def live_lean(mod):
    """Tracked files named `<mod>.lean` outside run folders, history and kept copies."""
    name = mod.replace(".", "/") + ".lean"
    return [f for f in git("ls-files", "--", f"*/{name}", name).splitlines()
            if not re.search(r"(-checks/[0-9TZ.]+/|/runs/|/snapshots/|/history/|verification-history/|/sources/)", f)]


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    name = sys.argv[sys.argv.index("--out") + 1] if "--out" in sys.argv else "receipts.json"
    args = [a for a in args if a != name]
    rev = args[0] if args else "HEAD"
    shas = {}

    def sha(path):
        if path not in shas:
            data = show(rev, path)
            shas[path] = hashlib.sha256(data).hexdigest() if data is not None else None
        return shas[path]

    stale_runs, records, unresolved = {}, {}, {}
    seen = {}
    for path in sorted(RECORDS.glob("*.json")):
        rec = json.loads(path.read_text())
        for b in rec.get("proof_bindings", []):
            r = b.get("receipt", "")
            if not r or r == CORE_POINTER or "/becoming-checks/" in r:
                continue
            pointer = pointer_of(r)
            # A receipt under a pointer that records no `source_paths` cannot take the run layout's test: it is
            # classified with the older layouts instead of being taken as fresh.
            if pointer is not None and r not in seen:
                d = json.loads((REPO / r).read_text())
                if not isinstance(d.get("source_paths"), dict):
                    pointer = None
            if pointer is None:
                unresolved.setdefault(r, {"sources": set(), "records": set()})
                unresolved[r]["sources"].add(b["source"])
                unresolved[r]["records"].add(rec.get("id", path.stem))
                continue
            if r not in seen:
                d = json.loads((REPO / r).read_text())
                base = (REPO / r).parent if r == pointer else (REPO / r).parent.parent
                seen[r] = [n for n, rel in d.get("source_paths", {}).items()
                           if sha(str(resolve(rel, base).relative_to(REPO))) != d["source_sha256"].get(n)]
            if seen[r]:
                stale_runs.setdefault(pointer, set()).add(r)
                records.setdefault(pointer, set()).add(rec.get("id", path.stem))
    order = [p for p in PE2[:-1] if p in stale_runs] + sorted(p for p in stale_runs if p not in PE2)
    # The earlier receipts' reuse of steps from builds no one kept.
    folders = {m[1] for m in re.finditer(r"-checks/([0-9TZ.]+)/", git("ls-tree", "-r", "--name-only", rev, "experiments"))}

    def unretained(pointer):
        data = show(rev, pointer)
        reused = json.loads(data).get("lean_steps", {}).get("reused", {}) if data else {}
        keys = json.loads(data).get("lean_steps", {}).get("keys", {}) if data else {}
        gone = [n for n, o in reused.items() if not (isinstance(o, dict) and o.get("utc") in folders)]
        return len(gone), {keys.get(n) for n in gone}

    core_n, core_keys = unretained(CORE_POINTER)
    per = {p: unretained(p) for p in order}
    plan = {
        "rev": git("rev-parse", rev).strip(),
        "receipts": order,
        "stale_bound_runs": {p: sorted(stale_runs[p]) for p in order},
        "records": {p: sorted(records[p]) for p in order},
        "older_layout": {r: {**older_layout(r, v["sources"], sha), "records": sorted(v["records"])}
                         for r, v in sorted(unresolved.items())},
        "earlier_unretained": {
            "core": {"occurrences": core_n, "distinct_keys": len(core_keys - {None})},
            "periphery": {"occurrences": sum(v[0] for v in per.values()),
                          "distinct_keys": len(set().union(*(v[1] for v in per.values())) - {None}) if per else 0,
                          "receipts": sum(1 for v in per.values() if v[0])},
        },
    }
    OUT.mkdir(exist_ok=True)
    (OUT / name).write_text(json.dumps(plan, indent=1, ensure_ascii=False) + "\n")
    for p in order:
        print(f"{Path(p).stem:50s} records {len(records[p]):2d}  stale bound runs {len(stale_runs[p])}")
    older = plan["older_layout"]
    for r, v in older.items():
        if v["stale"] or v["unresolved_imports"] or not v["compared"]:
            print(f"OLDER LAYOUT {r}: stale {v['stale']} unrecorded {len(v['unrecorded'])} of {v['closure']} "
                  f"unresolved imports {v['unresolved_imports']} (with a live file: {v['unresolved_live']}) "
                  f"compared {v['compared']} (records {v['records']})")
    print(f"PERIPHERY TO RERUN {len(order)}; records {len({i for v in records.values() for i in v})}; "
          f"older-layout receipts {len(older)}, stale {sum(1 for v in older.values() if v['stale'])}, "
          f"not compared {sum(1 for v in older.values() if not v['compared'])}; "
          f"earlier unretained reuse {plan['earlier_unretained']}")


if __name__ == "__main__":
    main()
