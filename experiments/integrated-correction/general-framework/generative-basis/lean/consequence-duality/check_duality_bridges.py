#!/usr/bin/env python3
"""Compile, axiom-audit, and statically verify DualityBridges.lean cleanly.

AI-written (Wave 2, 2026-11-24).
"""

from __future__ import annotations

import hashlib
import json
import os
import pathlib
import re
import subprocess
import tempfile
from datetime import datetime, timezone

HERE = pathlib.Path(__file__).resolve().parent
BASE_SOURCE = HERE / "ConsequenceDuality.lean"
SOURCE_FILE = HERE / "DualityBridges.lean"
TOOLCHAIN_FILE = HERE / "lean-toolchain"
RECEIPT_FILE = HERE / "duality-bridges-verification.json"

MODULE_NAME = "DualityBridges"
STANDARD_AXIOMS = {"propext", "Classical.choice", "Quot.sound"}

REQUIRED_DECLARATIONS = [
    "DualityBridges.PrimalFeasibleVec",
    "DualityBridges.dualBoundVec",
    "DualityBridges.approx_feasible_of_model_error",
    "DualityBridges.primalGap_le_dualBoundVec",
    "DualityBridges.dualBound_with_model_error",
    "DualityBridges.dualBound_with_uniform_model_error",
    "DualityBridges.extendQueryFamily",
    "DualityBridges.extendDualCoeff",
    "DualityBridges.dualBound_extendQueryFamily",
    "DualityBridges.monotone_entry_value",
    "DualityBridges.monotone_entry_value_exists",
    "DualityBridges.strict_entry_improvement_witness",
    "DualityBridges.dualBound_zero_eq_zero_iff",
    "DualityBridges.zero_dualBound_iff_affine_span",
    "DualityBridges.stepOp",
    "DualityBridges.stepLinearMap",
    "DualityBridges.wordVec",
    "DualityBridges.survVec",
    "DualityBridges.krylovSub",
    "DualityBridges.krylovSub_stabilizes_before_card",
    "DualityBridges.wordVec_mem_krylovSub_pred",
    "DualityBridges.ShortWord",
    "DualityBridges.shortWordQuery",
    "DualityBridges.finite_krylov_zero_minimax_radius",
]

MARKET_WORDS = [
    "market",
    "price",
    "pay",
    "cost",
    "buyer",
    "seller",
    "money",
    "dollar",
    "currency",
    "profit",
    "revenue",
    "bid",
    "ask",
    "trade",
    "arbitrage",
    "auction",
    "budget",
    "fee",
    "credit",
    "wealth",
    "firm",
    "wage",
]

DECL_RE = re.compile(
    r"^(?:@\[[^\]]+\]\s+)*(?:noncomputable\s+)?(theorem|def|abbrev|structure)\s+([A-Za-z0-9_']+)",
    re.MULTILINE,
)


def find_lean_binary() -> pathlib.Path:
    toolchain = TOOLCHAIN_FILE.read_text(encoding="utf-8").strip()
    # leanprover/lean4:v4.30.0-rc2 -> leanprover--lean4---v4.30.0-rc2
    mangled = toolchain.replace("/", "--").replace(":", "---")
    candidate = pathlib.Path.home() / ".elan" / "toolchains" / mangled / "bin" / "lean"
    if candidate.exists():
        return candidate
    for entry in sorted((pathlib.Path.home() / ".elan" / "toolchains").glob("*v4.30*")):
        cand = entry / "bin" / "lean"
        if cand.exists():
            return cand
    raise FileNotFoundError(f"Could not locate Lean binary for toolchain {toolchain!r}")


def find_mathlib_lean_paths() -> list[str]:
    pkgs = pathlib.Path.home() / "repos" / "生生不息" / ".lake" / "packages"
    if not pkgs.exists():
        raise FileNotFoundError(f"Prebuilt Mathlib packages directory not found: {pkgs}")
    paths = [str(p) for p in sorted(pkgs.glob("*/.lake/build/lib/lean")) if p.is_dir()]
    if not paths:
        raise FileNotFoundError(f"No .lake/build/lib/lean directories found under {pkgs}")
    return paths


def read_mathlib_revision() -> str:
    manifest = pathlib.Path.home() / "repos" / "生生不息" / "lake-manifest.json"
    if not manifest.exists():
        return "unknown"
    try:
        data = json.loads(manifest.read_text(encoding="utf-8"))
        for pkg in data.get("packages", []):
            if pkg.get("name") == "mathlib":
                return str(pkg.get("rev", "unknown"))
    except Exception:
        pass
    return "unknown"


def strip_lean_comments(src: str) -> str:
    out: list[str] = []
    i = 0
    n = len(src)
    depth = 0
    while i < n:
        if depth == 0 and src.startswith("--", i):
            while i < n and src[i] != "\n":
                i += 1
            continue
        if src.startswith("/-", i):
            depth += 1
            i += 2
            continue
        if depth > 0 and src.startswith("-/", i):
            depth -= 1
            i += 2
            continue
        if depth == 0:
            out.append(src[i])
        i += 1
    return "".join(out)


def parse_declarations(src: str) -> list[dict[str, str]]:
    decls: list[dict[str, str]] = []
    for m in DECL_RE.finditer(src):
        kind, short = m.group(1), m.group(2)
        decls.append({"kind": kind, "name": f"{MODULE_NAME}.{short}"})
    return decls


def run_static_checks(src: str, decls: list[dict[str, str]]) -> tuple[list[str], list[str], list[str], list[str], list[str]]:
    clean = strip_lean_comments(src)
    private_decls = re.findall(r"^\s*private\s+\S+", clean, flags=re.MULTILINE)
    unnamed_instances = re.findall(r"^\s*(?:@\[[^\]]+\]\s+)?instance\s*[:{\[(]", clean, flags=re.MULTILINE)
    forbidden_tokens: list[str] = []
    for tok in ("sorry", "admit"):
        if re.search(rf"\b{tok}\b", clean):
            forbidden_tokens.append(tok)
    if re.search(r"^\s*axiom\b", clean, flags=re.MULTILINE):
        forbidden_tokens.append("axiom")
    if re.search(r"^\s*lemma\b", clean, flags=re.MULTILINE):
        forbidden_tokens.append("lemma")
    if re.search(r"^\s*class\b", clean, flags=re.MULTILINE):
        forbidden_tokens.append("class")

    lower_src = src.lower()
    market_word_hits = [w for w in MARKET_WORDS if re.search(rf"\b{re.escape(w)}\b", lower_src)]

    present = {d["name"] for d in decls}
    missing_required = [req for req in REQUIRED_DECLARATIONS if req not in present]
    return private_decls, unnamed_instances, forbidden_tokens, market_word_hits, missing_required


def parse_axioms_output(stdout: str, decl_names: list[str]) -> dict[str, list[str]]:
    axioms_by_decl: dict[str, list[str]] = {}
    lines = stdout.splitlines()
    for line in lines:
        line = line.strip()
        m_no = re.match(r"^'([^']+)' does not depend on any axioms$", line)
        if m_no:
            axioms_by_decl[m_no.group(1)] = []
            continue
        m_yes = re.match(r"^'([^']+)' depends on axioms:\s*\[([^\]]*)\]$", line)
        if m_yes:
            raw = [a.strip() for a in m_yes.group(2).split(",") if a.strip()]
            axioms_by_decl[m_yes.group(1)] = raw
    missing = [name for name in decl_names if name not in axioms_by_decl]
    if missing:
        raise RuntimeError(f"Missing #print axioms output for: {missing}\nSTDOUT:\n{stdout}")
    return axioms_by_decl


def main() -> int:
    src = SOURCE_FILE.read_text(encoding="utf-8")
    source_sha256 = hashlib.sha256(SOURCE_FILE.read_bytes()).hexdigest()
    toolchain = TOOLCHAIN_FILE.read_text(encoding="utf-8").strip()
    lean_bin = find_lean_binary()
    lean_ver = subprocess.check_output([str(lean_bin), "--version"], text=True).strip()
    mathlib_rev = read_mathlib_revision()
    math_paths = find_mathlib_lean_paths()

    decls = parse_declarations(src)
    decl_names = [d["name"] for d in decls]
    (
        private_decls,
        unnamed_instances,
        forbidden_tokens,
        market_word_hits,
        missing_required,
    ) = run_static_checks(src, decls)

    if private_decls or unnamed_instances or forbidden_tokens or market_word_hits or missing_required:
        raise RuntimeError(
            "Static check failed: "
            f"private={private_decls}, unnamed_instances={unnamed_instances}, "
            f"forbidden={forbidden_tokens}, market_words={market_word_hits}, "
            f"missing_required={missing_required}"
        )

    with tempfile.TemporaryDirectory(prefix="duality_bridges_") as tmp:
        tmp_path = pathlib.Path(tmp)
        env = os.environ.copy()
        env["LEAN_PATH"] = os.pathsep.join([str(tmp_path)] + math_paths)

        for name, file_path in (("ConsequenceDuality", BASE_SOURCE), ("DualityBridges", SOURCE_FILE)):
            res = subprocess.run(
                [str(lean_bin), "-o", str(tmp_path / f"{name}.olean"), file_path.name],
                cwd=HERE,
                env=env,
                text=True,
                capture_output=True,
            )
            if res.returncode != 0:
                raise RuntimeError(
                    f"Lean compilation of {file_path.name} failed (exit {res.returncode}):\n"
                    f"STDOUT:\n{res.stdout}\nSTDERR:\n{res.stderr}"
                )

        audit_lines = ["import ConsequenceDuality", "import DualityBridges", ""]
        for d in decl_names:
            audit_lines.append(f"#print axioms {d}")
        for req in REQUIRED_DECLARATIONS:
            audit_lines.append(f"#check @{req}")
        audit_file = tmp_path / "AuditDualityBridges.lean"
        audit_file.write_text("\n".join(audit_lines) + "\n", encoding="utf-8")

        audit_res = subprocess.run(
            [str(lean_bin), str(audit_file)],
            cwd=tmp_path,
            env=env,
            text=True,
            capture_output=True,
        )
        if audit_res.returncode != 0:
            raise RuntimeError(
                f"Axiom/signature audit failed (exit {audit_res.returncode}):\n"
                f"STDOUT:\n{audit_res.stdout}\nSTDERR:\n{audit_res.stderr}"
            )

        axioms_by_decl = parse_axioms_output(audit_res.stdout, decl_names)
        disallowed = {
            name: sorted(set(axs) - STANDARD_AXIOMS)
            for name, axs in axioms_by_decl.items()
            if set(axs) - STANDARD_AXIOMS
        }
        if disallowed:
            raise RuntimeError(f"Non-standard axioms detected: {disallowed}")

    all_axioms_used = sorted({ax for axs in axioms_by_decl.values() for ax in axs})
    receipt = {
        "module": MODULE_NAME,
        "source_file": str(SOURCE_FILE.relative_to(HERE)),
        "source_sha256": source_sha256,
        "verified_at_utc": datetime.now(timezone.utc).isoformat(),
        "ai_written": True,
        "toolchain": toolchain,
        "lean_version": lean_ver,
        "mathlib_revision": mathlib_rev,
        "status": "passed",
        "standard_axioms_allowed": sorted(STANDARD_AXIOMS),
        "all_axioms_used": all_axioms_used,
        "sorry_ax_count": sum(1 for axs in axioms_by_decl.values() if "sorryAx" in axs),
        "static_checks": {
            "private_declarations": private_decls,
            "unnamed_instances": unnamed_instances,
            "forbidden_tokens": forbidden_tokens,
            "market_word_hits": market_word_hits,
            "missing_required_declarations": missing_required,
        },
        "declaration_count": len(decl_names),
        "theorem_count": sum(1 for d in decls if d["kind"] == "theorem"),
        "definition_count": sum(1 for d in decls if d["kind"] in ("def", "abbrev")),
        "structure_count": sum(1 for d in decls if d["kind"] == "structure"),
        "required_declarations_verified": REQUIRED_DECLARATIONS,
        "declarations": [
            {
                "kind": d["kind"],
                "name": d["name"],
                "axioms": axioms_by_decl[d["name"]],
            }
            for d in decls
        ],
    }

    RECEIPT_FILE.write_text(json.dumps(receipt, indent=2) + "\n", encoding="utf-8")
    print(
        f"PASSED: {MODULE_NAME} ({receipt['declaration_count']} declarations: "
        f"{receipt['theorem_count']} theorems, {receipt['definition_count']} defs, "
        f"{receipt['structure_count']} structures); axioms={all_axioms_used}; "
        f"sorryAx=0; private=0; unnamed_instances=0; market_word_hits=0"
    )
    print(f"Receipt written to {RECEIPT_FILE}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
