#!/usr/bin/env python3
"""Compile FeedbackAtlas.lean against the Becoming core and write its verification record.

The record binds the application's own files by SHA-256 and names the core it was checked
against by commit and tree hash. It does not hash the core's files: a core landing changes
the core, not this application, so re-verification is run on purpose rather than forced by CI.
"""
import hashlib
import json
import shutil
from pathlib import Path
import subprocess
import sys
from datetime import datetime, timezone

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
ROOT = next(p for p in HERE.parents if (p / "tools/research/research.py").is_file())
CORE = "experiments/integrated-correction/general-framework/generative-basis/lean"
PACKAGE = ROOT / CORE / "becoming"
MODULE = "FeedbackAtlas"
sys.path.insert(0, str(PACKAGE))
import check_becoming as cb  # noqa: E402


def git(*args):
    return subprocess.check_output(["git", *args], cwd=ROOT, text=True).strip()


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


command, binary, _ = cb.resolve_lean()
version = subprocess.check_output(command + ["--version"], text=True).strip()
if "version 4.29.1" not in version:
    raise SystemExit("This application is pinned to Lean 4.29.1; found " + version)
if git("status", "--porcelain", "--", CORE):
    raise SystemExit("The core has uncommitted changes; verify against a committed core")
process = subprocess.run([sys.executable, "-B", str(PACKAGE / "scratch_build.py"), str(HERE), MODULE],
                         text=True, capture_output=True)
try:
    report = json.loads(process.stdout)
except json.JSONDecodeError:
    report = None
if process.returncode or report is None or report.get("failed"):
    raise SystemExit(process.stdout + process.stderr)
audit = report["audits"][MODULE]
if report["unclean"] or audit["with_axioms"]:
    raise SystemExit("Compiler warnings or reported axiom dependencies:\n" + json.dumps(report, indent=2))
# Cite the newest core commit that is also on the upstream main branch.
upstream = git("merge-base", "HEAD", "origin/main")
if git("rev-parse", "HEAD:" + CORE) != git("rev-parse", upstream + ":" + CORE):
    raise SystemExit("This branch changes the core; verify against a core that is on origin/main")
own = [HERE / (MODULE + ".lean"), Path(__file__).resolve()]
record = {
    "status": "passed",
    "module": MODULE,
    "checked_at_utc": datetime.now(timezone.utc).isoformat(timespec="seconds"),
    "lean_version": version,
    "lean_binary_sha256": digest(binary),
    "theorems": audit["theorems"],
    "declarations": audit["declarations"],
    "axiom_dependencies": audit["with_axioms"],
    "modules_compiled": report["modules"],
    "core": {"path": CORE,
             "checked_against_commit": git("log", "-1", "--format=%H", upstream, "--", CORE),
             "tree": git("rev-parse", upstream + ":" + CORE)},
    "own_sha256": {str(p.relative_to(ROOT)): digest(p) for p in own},
    "not_established": [
        "Empirical validity or fitted values of the update laws, probe or example histories",
        "Anything about actual motives, worth or safety, or an obligation to keep engaging",
        "The core package's own environment and purity audits, which only check_becoming.py runs",
    ],
}
# The scratch build output is not data; leaving it would enter the repository's Lean index.
shutil.rmtree(HERE / ".build", ignore_errors=True)
(HERE / "atlas-verification.json").write_text(json.dumps(record, indent=2) + "\n")
print(json.dumps({k: record[k] for k in ["status", "theorems", "declarations", "axiom_dependencies", "core"]},
                 indent=2))
