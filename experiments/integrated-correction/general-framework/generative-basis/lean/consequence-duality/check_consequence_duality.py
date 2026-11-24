#!/usr/bin/env python3
"""Standalone verification gate and axiom audit for ``ConsequenceDuality.lean``.

AI-written (``Track S2``, 24 November 2026). Compiles ``ConsequenceDuality.lean`` against the
local prebuilt Mathlib ``.olean`` cache in ``~/repos/生生不息`` inside a temporary directory (so
zero ``.olean`` or ``*-checks/`` artifacts remain in the repository), checks policy constraints
(standard axioms only, ``0`` ``sorryAx``, ``0`` ``private``, ``0`` ``lemma``/``class``, ``0``
unnamed ``instance``, ``0`` forbidden market words), audits ``#print axioms`` and ``#check @...``
for every declaration, and writes ``consequence-duality-verification.json``.
"""

from __future__ import annotations

import hashlib
import json
import os
import re
import subprocess
import sys
import tempfile
from datetime import datetime, timezone
from pathlib import Path

HERE = Path(__file__).resolve().parent
BECOMING_DIR = (HERE.parent / "becoming").resolve()
sys.path.insert(0, str(BECOMING_DIR))
import check_becoming as core  # noqa: E402

MODULE_NAME = "ConsequenceDuality"
SOURCE_FILE = HERE / "ConsequenceDuality.lean"
FPK_SOURCE = (HERE.parent / "finite-prob-krylov" / "FiniteProbKrylov.lean").resolve()
LEAN_ROOT = HERE.parent.resolve()
TOOLCHAIN_FILE = HERE / "lean-toolchain"
RECEIPT_FILE = HERE / "consequence-duality-verification.json"

EXPECTED_TOOLCHAIN = "leanprover/lean4:v4.30.0-rc2"
EXPECTED_MATHLIB_REVISION = "ea11ccc0c5c7c4c562742e918fe2e0b2814a58aa"
LEAN_BIN = Path.home() / ".elan/toolchains/leanprover--lean4---v4.30.0-rc2/bin/lean"
SIBX_DIR = Path.home() / "repos/生生不息"
STANDARD_AXIOMS = {"propext", "Classical.choice", "Quot.sound"}

REQUIRED_DECLARATIONS = [
    "ConsequenceDuality.FinDist",
    "ConsequenceDuality.FinDist.ext",
    "ConsequenceDuality.diracDist",
    "ConsequenceDuality.pushforward",
    "ConsequenceDuality.pushforward_comp",
    "ConsequenceDuality.tvDist",
    "ConsequenceDuality.tvDist_nonneg",
    "ConsequenceDuality.tvDist_self",
    "ConsequenceDuality.tvDist_symm",
    "ConsequenceDuality.tvDist_triangle",
    "ConsequenceDuality.tvDist_pushforward_le",
    "ConsequenceDuality.massOutside",
    "ConsequenceDuality.massOutside_nonneg",
    "ConsequenceDuality.optimal_query_tv_floor",
    "ConsequenceDuality.empty_source_infeasible",
    "ConsequenceDuality.PrimalFeasible",
    "ConsequenceDuality.primalGap",
    "ConsequenceDuality.dualBound",
    "ConsequenceDuality.primalGap_le_dualBound",
    "ConsequenceDuality.dualBound_attained",
    "ConsequenceDuality.consequence_minimax_duality",
    "ConsequenceDuality.multiQueryTvError",
    "ConsequenceDuality.multiQueryDualObj",
    "ConsequenceDuality.multiQueryDualObj_le_multiQueryTvError",
    "ConsequenceDuality.common_history_tv_duality",
    "ConsequenceDuality.one_query_tv_floor_via_duality",
    "ConsequenceDuality.two_query_diagonal_three_fifths_witness",
    "ConsequenceDuality.joint_distribution_one_half_witness",
    "ConsequenceDuality.policyMargin",
    "ConsequenceDuality.fiberActionMargin",
    "ConsequenceDuality.fiberBestMargin",
    "ConsequenceDuality.policyMargin_le_fiberBestMargin",
    "ConsequenceDuality.decision_margin_minimax",
    "ConsequenceDuality.decision_margin_pos_iff_common_action",
    "ConsequenceDuality.two_state_exact_minimax",
    "ConsequenceDuality.public_port_vs_recipient_exact",
    "ConsequenceDuality.b2_aliasing_08_exact_certificate",
    "ConsequenceDuality.diagSurvivalProb",
    "ConsequenceDuality.diagSurvivalProb_eq",
    "ConsequenceDuality.noisy_short_word_amplification",
]

AXIOM_DEP_RE = re.compile(
    r"^'(.+)' depends on axioms: \[(.*)\]\s*$",
    re.MULTILINE,
)
AXIOM_NONE_RE = re.compile(
    r"^'(.+)' does not depend on any axioms\s*$",
    re.MULTILINE,
)


def parse_axiom_output(stdout: str, decl_names: list[str]) -> dict[str, list[str]]:
    """Parse Lean ``#print axioms`` output, accounting for every requested declaration."""
    found: dict[str, list[str]] = {}
    # Split on Lean info diagnostics/messages cleanly: each `#print axioms` produces a line or
    # indented block starting with `'DeclName' ...`. Join wrapped axiom brackets first.
    normalized = re.sub(r"\n\s+", " ", stdout)
    for m in AXIOM_NONE_RE.finditer(normalized):
        found[m.group(1)] = []
    for m in AXIOM_DEP_RE.finditer(normalized):
        axioms_raw = m.group(2).strip()
        axioms = [a.strip() for a in axioms_raw.split(",") if a.strip()]
        found[m.group(1)] = axioms
    missing = [name for name in decl_names if name not in found]
    if missing:
        raise RuntimeError(
            f"Missing #print axioms output for {len(missing)} declaration(s): {missing}\n"
            f"Raw stdout:\n{stdout}"
        )
    return {name: found[name] for name in decl_names}


def main() -> int:
    if not SOURCE_FILE.is_file():
        raise FileNotFoundError(f"Missing source file: {SOURCE_FILE}")
    if not FPK_SOURCE.is_file():
        raise FileNotFoundError(f"Missing shared dependency source file: {FPK_SOURCE}")
    if not TOOLCHAIN_FILE.is_file():
        raise FileNotFoundError(f"Missing toolchain file: {TOOLCHAIN_FILE}")
    if not LEAN_BIN.is_file():
        raise FileNotFoundError(f"Missing Lean binary: {LEAN_BIN}")

    toolchain = TOOLCHAIN_FILE.read_text(encoding="utf-8").strip()
    if toolchain != EXPECTED_TOOLCHAIN:
        raise RuntimeError(f"Toolchain mismatch: {toolchain!r} != {EXPECTED_TOOLCHAIN!r}")

    lean_ver = subprocess.run(
        [str(LEAN_BIN), "--version"],
        text=True,
        capture_output=True,
        check=True,
    ).stdout.strip()
    if "4.30.0-rc2" not in lean_ver:
        raise RuntimeError(f"Lean binary version mismatch: {lean_ver!r}")

    manifest_path = SIBX_DIR / "lake-manifest.json"
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    mathlib_rev = next(
        (pkg.get("rev") for pkg in manifest.get("packages", []) if pkg.get("name") == "mathlib"),
        None,
    )
    if mathlib_rev != EXPECTED_MATHLIB_REVISION:
        raise RuntimeError(
            f"Mathlib revision mismatch: {mathlib_rev!r} != {EXPECTED_MATHLIB_REVISION!r}"
        )

    pkgs_dir = SIBX_DIR / ".lake/packages"
    lean_lib_paths = [
        str(pkg / ".lake/build/lib/lean")
        for pkg in sorted(pkgs_dir.iterdir())
        if (pkg / ".lake/build/lib/lean").is_dir()
    ]
    if not lean_lib_paths:
        raise RuntimeError(f"No prebuilt .lake/build/lib/lean dirs found under {pkgs_dir}")

    raw_bytes = SOURCE_FILE.read_bytes()
    source_sha256 = hashlib.sha256(raw_bytes).hexdigest()
    fpk_bytes = FPK_SOURCE.read_bytes()
    fpk_sha256 = hashlib.sha256(fpk_bytes).hexdigest()
    source_text = raw_bytes.decode("utf-8")
    code_only = core.audit_support.code_only(source_text)

    # Static scanner checks
    scan_info = core.scanned(raw_bytes)
    private_decls = list(scan_info["private"])
    unnamed_instances = list(scan_info["unnamed_instances"])
    decls = list(scan_info["declarations"])
    decl_names = [d["name"] for d in decls]

    forbidden_tokens = re.findall(
        r"\b(?:sorry|admit|axiom|unsafe|native_decide|implemented_by|debug\.skipKernelTC|lemma|class)\b",
        code_only,
    )

    market_word_hits = []
    for name in decl_names:
        words = set(core.name_words(name))
        hits = sorted(words & set(core.MARKET_WORDS))
        if hits:
            market_word_hits.append({"declaration": name, "words": hits})

    missing_required = [name for name in REQUIRED_DECLARATIONS if name not in set(decl_names)]

    if private_decls:
        raise RuntimeError(f"Forbidden private declarations found: {private_decls}")
    if unnamed_instances:
        raise RuntimeError(f"Forbidden unnamed instances found: {unnamed_instances}")
    if forbidden_tokens:
        raise RuntimeError(f"Forbidden Lean tokens found in code: {forbidden_tokens}")
    if market_word_hits:
        raise RuntimeError(f"Forbidden market words found in declarations: {market_word_hits}")
    if missing_required:
        raise RuntimeError(f"Missing required declarations: {missing_required}")

    # Dynamic kernel compilation + axiom/signature audit inside a temporary directory
    with tempfile.TemporaryDirectory(prefix="consequence-duality-") as tmp:
        tmp_dir = Path(tmp)
        env = os.environ.copy()
        env["LEAN_PATH"] = os.pathsep.join([str(tmp_dir)] + lean_lib_paths)

        for dep_name, dep_bytes in (("FiniteProbKrylov", fpk_bytes), (MODULE_NAME, raw_bytes)):
            dep_lean = tmp_dir / f"{dep_name}.lean"
            dep_lean.write_bytes(dep_bytes)
            dep_olean = tmp_dir / f"{dep_name}.olean"
            compile_res = subprocess.run(
                [str(LEAN_BIN), "-o", str(dep_olean), dep_lean.name],
                cwd=tmp_dir,
                env=env,
                text=True,
                capture_output=True,
            )
            if compile_res.returncode != 0:
                raise RuntimeError(
                    f"Lean compilation of {dep_name}.lean failed (exit {compile_res.returncode}):\n"
                    f"STDOUT:\n{compile_res.stdout}\nSTDERR:\n{compile_res.stderr}"
                )
            if compile_res.stdout.strip() or compile_res.stderr.strip():
                raise RuntimeError(
                    f"Lean compilation of {dep_name}.lean emitted unexpected output/warnings:\n"
                    f"STDOUT:\n{compile_res.stdout}\nSTDERR:\n{compile_res.stderr}"
                )

        axiom_lines = [f"import {MODULE_NAME}", ""] + [
            f"#print axioms {name}" for name in decl_names
        ]
        axiom_file = tmp_dir / f"{MODULE_NAME}AxiomAudit.lean"
        axiom_file.write_text("\n".join(axiom_lines) + "\n", encoding="utf-8")
        axiom_res = subprocess.run(
            [str(LEAN_BIN), str(axiom_file)],
            cwd=tmp_dir,
            env=env,
            text=True,
            capture_output=True,
        )
        if axiom_res.returncode != 0:
            raise RuntimeError(
                f"Axiom audit script failed (exit {axiom_res.returncode}):\n"
                f"STDOUT:\n{axiom_res.stdout}\nSTDERR:\n{axiom_res.stderr}"
            )

        axioms_by_decl = parse_axiom_output(axiom_res.stdout, decl_names)
        nonstandard_axioms = {
            name: sorted(set(axioms) - STANDARD_AXIOMS)
            for name, axioms in axioms_by_decl.items()
            if not set(axioms).issubset(STANDARD_AXIOMS)
        }
        if nonstandard_axioms:
            raise RuntimeError(f"Non-standard axioms detected: {nonstandard_axioms}")

        sig_lines = [f"import {MODULE_NAME}", ""] + [
            f"#check @{name}" for name in decl_names
        ]
        sig_file = tmp_dir / f"{MODULE_NAME}Signatures.lean"
        sig_file.write_text("\n".join(sig_lines) + "\n", encoding="utf-8")
        sig_res = subprocess.run(
            [str(LEAN_BIN), str(sig_file)],
            cwd=tmp_dir,
            env=env,
            text=True,
            capture_output=True,
        )
        if sig_res.returncode != 0:
            raise RuntimeError(
                f"Signature check script failed (exit {sig_res.returncode}):\n"
                f"STDOUT:\n{sig_res.stdout}\nSTDERR:\n{sig_res.stderr}"
            )

    if FPK_SOURCE.read_bytes() != fpk_bytes or SOURCE_FILE.read_bytes() != raw_bytes:
        raise RuntimeError("Source bytes changed on disk during check; snapshot integrity failed")
    all_axioms_used = sorted({ax for axs in axioms_by_decl.values() for ax in axs})
    receipt = {
        "module": MODULE_NAME,
        "source_file": str(SOURCE_FILE.relative_to(HERE)),
        "source_paths": {
            "FiniteProbKrylov": str(FPK_SOURCE.relative_to(LEAN_ROOT)),
            MODULE_NAME: str(SOURCE_FILE.relative_to(LEAN_ROOT)),
        },
        "source_sha256": source_sha256,
        "dependency_sha256": {
            "FiniteProbKrylov": fpk_sha256,
        },
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
