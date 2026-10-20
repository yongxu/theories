#!/usr/bin/env python3
"""Compile the imported example and retain its source-bound local verification."""
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
from datetime import datetime, timezone

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
ROOT = next(p for p in HERE.parents if (p / "tools/research/research.py").is_file())
PACKAGE = ROOT / "experiments/integrated-correction/general-framework/generative-basis/lean/becoming"
sys.path.insert(0, str(PACKAGE))
import check_becoming as cb

command, binary, resolution = cb.resolve_lean()
version = subprocess.check_output(command + ["--version"], text=True).strip()
if "version 4.29.1" not in version:
    raise SystemExit("This example is pinned to Lean 4.29.1; found " + version)
process = subprocess.run([sys.executable, "-B", str(PACKAGE / "scratch_build.py"),
                          str(HERE), "ResearchInteractionTrial"], text=True, capture_output=True)
(HERE / "research-verification.log").write_text(process.stdout + process.stderr)
if process.returncode:
    print(process.stdout + process.stderr)
    raise SystemExit(process.returncode)
report = json.loads(process.stdout)
audit = report["audits"]["ResearchInteractionTrial"]
if report["unclean"] or audit["with_axioms"]:
    raise SystemExit("Compilation warnings or nonempty/unreported axiom dependencies; see research-verification.log")
index = cb.module_index()
for source in HERE.glob("*.lean"):
    index[source.stem] = [source]
order = cb.closure(index, ["ResearchInteractionTrial"])
def digest(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()
receipt = {
    "status": "passed", "scope": "Research-informed candidate interaction model with separate expectation, confidence and credibility; not a full core-checker receipt",
    "checked_at_utc": datetime.now(timezone.utc).isoformat(),
    "lean_version": version,
    "lean_binary_sha256": digest(binary), "lean_resolution": resolution,
    "git_head": subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=ROOT, text=True).strip(),
    "theorems": audit["theorems"], "declarations": audit["declarations"],
    "axiom_dependencies": audit["with_axioms"],
    "source_sha256": {str(index[n][0].relative_to(ROOT)): digest(index[n][0]) for n in order},
    "verification_script_sha256": digest(Path(__file__)),
    "build_report": report,
    "not_established": ["Actual motives or human worth", "Safety or obligation to engage", "Empirical validity or fitted parameters of the update laws, response probes, evidence independence, confidence mass or credibility rules", "Emotional recovery, moral obligation, safety, or absence of future shocks", "The full package environment and purity audits"],
}
(HERE / "research-verification.json").write_text(json.dumps(receipt, indent=2) + "\n")
print(json.dumps({k: receipt[k] for k in ["status", "lean_version", "theorems", "declarations", "axiom_dependencies"]}, indent=2))
