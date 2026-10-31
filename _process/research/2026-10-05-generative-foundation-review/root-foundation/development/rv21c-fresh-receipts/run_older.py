#!/usr/bin/env python3
"""RV21c's older-layout step, after the periphery: the record-bound receipts in the older layout whose bound closures
changed, rerun by their own checkers, with the receipt they inherit from first.

`plan_receipts.py` finds them at run time (`older_layout`, `stale`). On 31 October they are
`formation/evolution/verification.json` and `formation/evolution/development/verification.json`, which bind
`formation/formal/FormedSelection.lean` at bytes from before 8 October (one `set_option` line added to drop a propext
dependency). Evolution's checker asserts that the formal receipt it inherits records FormedSelection's live bytes, so
`formal/check.py` runs first; development's inherits evolution's. The chain is written out here and checked against
the plan: any other stale set stops the step, to be routed to the coordinator. All three are on Lean 4.29.1 with Std
only, minutes in all.

Each checker writes its `verification.json` in place: the old bytes stay in git history and their sha256 goes into the
re-point's reason, and nothing is copied beside the live file. Formal also rewrites its `verification/*.txt` logs in
place, even when it fails; evolution's and development's keep an attempt folder under `checks/` either way. A checker
that fails is a finding for the coordinator: the files it rewrote in place are first copied, as the checker left
them, into `out/older-failed/<checker folder>/` (the failure's log is the finding routed, so it must survive the
restore), then restored from git (an attempt folder stays too, with its log), and the checkers after it are not run. Then every passed receipt is compared, file by file, with
the checkout's bytes (`plan_receipts.recorded_hashes`), and its axiom reports with the old receipt's, module by module
(`axioms_changed`; `bound_modules` names the modules each record binds, whose change `run.sh` routes to the
coordinator; a change elsewhere, as in FormedSelection itself, whose 8 October line dropped a propext dependency, is
listed), with the audit totals.

Also written: the live receipts in the older layout, bound by no record, that record a file the renewed receipts renew
(FormedSelection, ResourceContinuation, FormationSupport) at other bytes. They stay unrun (no record binds them; a
later rerun of any would meet the new hashes) and the README names them.

usage (from the checkout root, after run_periphery.py): run_older.py   -> writes out/older.json, exits 1 if one failed
"""
import glob
import hashlib
import json
from pathlib import Path
import re
import shutil
import subprocess
import sys
import time

from kit import OUT, REPO, git
from plan_receipts import recorded_hashes

F = "experiments/shared-renewal-capability/regulation/retention/formation"
CHAIN = [
    {"receipt": F + "/formal/verification.json", "checker": F + "/formal/check.py",
     "in_place": [F + "/formal/verification.json", F + "/formal/verification"], "attempts": None},
    {"receipt": F + "/evolution/verification.json", "checker": F + "/evolution/check.py",
     "in_place": [F + "/evolution/verification.json"], "attempts": F + "/evolution/checks"},
    {"receipt": F + "/evolution/development/verification.json", "checker": F + "/evolution/development/check.py",
     "in_place": [F + "/evolution/development/verification.json"], "attempts": F + "/evolution/development/checks"},
]


def sha(path):
    return hashlib.sha256((REPO / path).read_bytes()).hexdigest()


def reports(d):
    """Module -> the receipt's axiom reports: per declaration where it lists them, else the module's list."""
    out = {}
    for m in d.get("modules", []):
        name = m.get("module") or Path(m.get("source", "")).stem
        if "axioms_by_declaration" in m:
            out[name] = {k: sorted(v) for k, v in m["axioms_by_declaration"].items()}
        else:
            out[name] = {"declarations": sorted(m.get("audited_declarations", [])), "axioms": sorted(m.get("axioms", []))}
    return out


def audits(d):
    return sum(len(m.get("axioms_by_declaration", m.get("audited_declarations", []))) for m in d.get("modules", []))


def bound_modules(receipt, records, d):
    """Record id -> the modules its proof bindings to this receipt bind (by `sha256_pointer` /modules/<i>/...)."""
    out = {}
    for rid in records:
        rec = json.loads((REPO / "theories/becoming/results/records" / f"{rid}.json").read_text())
        for b in rec.get("proof_bindings", []):
            m = re.fullmatch(r"/modules/(\d+)/\w+", b.get("sha256_pointer", ""))
            if b.get("receipt") == receipt and m:
                row = d["modules"][int(m[1])]
                out.setdefault(rid, []).append(row.get("module") or Path(row["source"]).stem)
    return out


def keep_copy(c, keep):
    """The checker's in-place files as it left them, copied into `keep` before they are restored."""
    for path in c["in_place"]:
        src = REPO / path
        if src.is_dir():
            shutil.copytree(src, keep / src.name, dirs_exist_ok=True)
        elif src.is_file():
            keep.mkdir(parents=True, exist_ok=True)
            shutil.copy2(src, keep / src.name)


def first_errors(log, n=6):
    """A module log's first error lines, each with the term it names when Lean puts that on the next line."""
    lines = log.read_text().splitlines() if log.is_file() else []
    out = []
    for i, line in enumerate(lines):
        if ": error" in line:
            nxt = lines[i + 1].strip() if i + 1 < len(lines) else ""
            out.append(f"{line} {nxt}" if line.rstrip().endswith(" at") and nxt else line)
    return out[:n]


def compare(receipt):
    """Files the receipt records at bytes other than the checkout's."""
    d = json.loads((REPO / receipt).read_text())
    differ = []
    for name, (src, h) in recorded_hashes(d).items():
        if src and (REPO / src).is_file() and sha(src) != h:
            differ.append(src)
    return differ


def not_renewed(chain, files):
    """Live receipts bound by no record, outside this step's chain, that record one of `files` (stem -> path) at
    other bytes: (live, kept copies). A kept copy has no checker (check*.py) beside it, or sits in a folder named as
    an earlier attempt (*-before-*, first-attempt-*, review)."""
    bound = set()
    for r in glob.glob(str(REPO / "theories/becoming/results/records/*.json")):
        bound |= {b["receipt"] for b in json.loads(Path(r).read_text()).get("proof_bindings", [])}
    live = {stem: sha(path) for stem, path in files.items()}
    rows, copies = [], []
    for p in sorted(glob.glob(str(REPO / "experiments/**/*verification.json"), recursive=True)):
        rel = str(Path(p).relative_to(REPO))
        # Run folders and history copies (a numeric or stamp folder, checks/, runs/, attempts/, history/,
        # verification-history/, a <name>-checks folder) are earlier runs kept as evidence, not live receipts.
        if rel in chain or rel in bound or any(
                re.fullmatch(r"\d{10,}|\d{8}T[\d.]+Z", x)
                or x in ("checks", "runs", "attempts", "history", "verification-history")
                or x.endswith("-checks") for x in Path(rel).parts[:-1]):
            continue
        try:
            d = json.loads(Path(p).read_text())
        except ValueError:
            continue
        if not isinstance(d, dict):
            continue
        stale = sorted(n for n, (_, h) in recorded_hashes(d).items() if n in live and h != live[n])
        if not stale:
            continue
        checker = any(Path(p).parent.glob("check*.py"))
        copy = not checker or any("-before-" in x or x.startswith("first-attempt") or x == "review"
                                  for x in Path(rel).parts[:-1])
        (copies if copy else rows).append({"receipt": rel, "stale": stale, "checker": checker})
    return rows, copies


def main():
    plan = json.loads((OUT / "receipts.json").read_text())
    stale = sorted(r for r, v in plan.get("older_layout", {}).items() if v["stale"])
    expected = sorted(c["receipt"] for c in CHAIN[1:])
    report = {"chain": [c["receipt"] for c in CHAIN], "planned_stale": stale, "receipts": {}}
    if not stale:
        report["skipped"] = "no record-bound older-layout receipt is stale"
        (OUT / "older.json").write_text(json.dumps(report, indent=1) + "\n")
        print("older layout: nothing stale, nothing run")
        return
    assert stale == expected, ("stale older-layout receipts other than this step's chain: route to the coordinator",
                               stale, expected)
    records = {r: v["records"] for r, v in plan["older_layout"].items()}
    try:
        run_chain(report, records)
    except Exception as e:
        # An error while a checker's in-place files were rewritten: keep them as the checker left them, restore them
        # from git, and route the error to the coordinator.
        cur = report.pop("current", None)
        if cur:
            keep_copy(cur, OUT / "older-failed" / Path(cur["checker"]).parent.name)
            git("checkout", "HEAD", "--", *cur["in_place"])
        report["error"] = f"{type(e).__name__}: {e} (route to the coordinator)"
        raise
    finally:
        # older.json is written whatever happened, so run.sh's later steps read what was run.
        (OUT / "older.json").write_text(json.dumps(report, indent=1, ensure_ascii=False) + "\n")
    renewed = {r for r, v in report["receipts"].items() if v["passed"]}
    print(f"older layout: {len(renewed)} of {len(CHAIN)} renewed; {len(report['not_renewed'])} unbound live receipts "
          f"and {len(report['kept_copies'])} kept copies stale in the same files, not renewed")
    sys.exit(0 if len(renewed) == len(CHAIN) else 1)


def run_chain(report, records):
    """Run the chain in order; on any error while a checker's files are rewritten, restore them from git first."""
    failed = None
    for c in CHAIN:
        r = c["receipt"]
        old = json.loads((REPO / r).read_text())
        row = {"records": records.get(r, []), "old_sha256": sha(r), "old_checked_at_utc": old.get("checked_at_utc")}
        if failed:
            row.update({"passed": False, "not_run": f"{failed} failed first"})
            report["receipts"][r] = row
            continue
        before = set(git("status", "--porcelain", "--untracked-files=all", "--", str(Path(r).parent)).splitlines())
        report["current"] = c
        start = time.time()
        p = subprocess.run([sys.executable, "-B", str(REPO / c["checker"])], cwd=REPO, text=True,
                           stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        name = Path(c["checker"]).parent.name
        (OUT / f"older-{name}.log").write_text(p.stdout)
        try:
            d = json.loads((REPO / r).read_text())
        except ValueError as e:
            d = {}
            row["error"] = f"verification.json unreadable after the run: {e}"
        passed = (p.returncode == 0 and d.get("status") == "passed"
                  and d.get("checked_at_utc") != row["old_checked_at_utc"])
        differ = compare(r) if passed else []
        passed = passed and not differ
        after = set(git("status", "--porcelain", "--untracked-files=all", "--", str(Path(r).parent)).splitlines())
        row.update({"exit": p.returncode, "status": d.get("status"), "seconds": round(time.time() - start),
                    "passed": passed, "differ": differ, "tail": p.stdout[-2000:],
                    "changed": sorted(line[3:] for line in after - before)})
        if passed:
            before_reports, after_reports = reports(old), reports(d)
            row.update({"new_sha256": sha(r), "new_checked_at_utc": d["checked_at_utc"],
                        "modules_added": sorted(set(after_reports) - set(before_reports)),
                        "modules_removed": sorted(set(before_reports) - set(after_reports)),
                        "axioms_changed": {m: {"old": before_reports[m], "new": after_reports[m]}
                                           for m in sorted(set(before_reports) & set(after_reports))
                                           if before_reports[m] != after_reports[m]},
                        "audits": [audits(old), audits(d)],
                        "bound_modules": bound_modules(r, row["records"], d)})
        else:
            # The modules the receipt marks unclean, each with its first error lines (formal's per-module logs),
            # so the texts name what failed from the run itself.
            logs = REPO / Path(r).parent / "verification"
            row["unclean"] = [{"module": m.get("module"), "exit": m.get("exit_code"), "axioms": m.get("axioms"),
                               "errors": first_errors(logs / f"{m.get('module')}.txt")}
                              for m in d.get("modules", []) if m.get("exit_code") or m.get("clean_dependency_audit") is False]
            keep = OUT / "older-failed" / name
            keep_copy(c, keep)
            row["failed_copy"] = str(keep.relative_to(REPO))
            git("checkout", "HEAD", "--", *c["in_place"])
            row["restored"] = c["in_place"]
            row["kept"] = sorted(x for x in row["changed"] if c["attempts"] and x.startswith(c["attempts"] + "/"))
            failed = Path(c["checker"]).parent.name
        report["receipts"][r] = row
        report.pop("current", None)
        print(r, "passed" if passed else "FAILED", p.returncode, d.get("status"), f"{row['seconds']}s", flush=True)
    files = {"FormedSelection": F + "/formal/FormedSelection.lean",
             "ResourceContinuation": "experiments/integrated-correction/general-framework/generative-basis/lean/"
                                     "conditional/ResourceContinuation.lean",
             "FormationSupport": "experiments/integrated-correction/general-framework/generative-basis/lean/"
                                 "learning/FormationSupport.lean"}
    report["not_renewed"], report["kept_copies"] = not_renewed({c["receipt"] for c in CHAIN}, files)


if __name__ == "__main__":
    main()
