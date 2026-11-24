#!/usr/bin/env python3
"""Compile, axiom-audit, and statically verify TrackBKrylovBridge.lean.

AI-written (Wave 3 follow-up, 24 November 2026).

`TrackBKrylovBridge` imports `DualityBridges` and `SurvivalDistinguishability` (Track B, periphery
#14), neither of which it changes. The import closure of Track B (`Becoming.*` core, Mathlib
linear algebra) is compiled into a temporary directory in dependency order, then
`ConsequenceDuality`, `DualityBridges`, `SurvivalDistinguishability`, and the bridge. Nothing is
written in the repository except the receipt `trackb-krylov-bridge-verification.json`.
"""

from __future__ import annotations

import hashlib
import json
import os
import pathlib
import re
import subprocess
import sys
import tempfile
from datetime import datetime, timezone

sys.dont_write_bytecode = True

HERE = pathlib.Path(__file__).resolve().parent
LEAN_ROOT = HERE.parent
sys.path.insert(0, str(LEAN_ROOT / "becoming"))
import check_becoming as core  # noqa: E402

# The repository's own market-word filter (`tools/research/style.py`), not a copy of it.
REPO_ROOT = next(p for p in HERE.parents if (p / "tools" / "research" / "style.py").is_file())
sys.path.insert(0, str(REPO_ROOT / "tools" / "research"))
import style  # noqa: E402

BASE_CONSEQ = HERE / "ConsequenceDuality.lean"
BASE_BRIDGES = HERE / "DualityBridges.lean"
TRACK_B = LEAN_ROOT / "survival-distinguishability" / "SurvivalDistinguishability.lean"
SOURCE_FILE = HERE / "TrackBKrylovBridge.lean"
TOOLCHAIN_FILE = HERE / "lean-toolchain"
RECEIPT_FILE = HERE / "trackb-krylov-bridge-verification.json"

MODULE_NAME = "TrackBKrylovBridge"
TRACK_B_MODULE = "SurvivalDistinguishability"
STANDARD_AXIOMS = {"propext", "Classical.choice", "Quot.sound"}
TIMEOUT = int(os.environ.get("LEAN_TIMEOUT", "900"))

REQUIRED_DECLARATIONS = [
    "TrackBKrylovBridge.stepOp_eq",
    "TrackBKrylovBridge.survVec_eq",
    "TrackBKrylovBridge.trackB_finite_krylov_zero_minimax_radius",
    "TrackBKrylovBridge.short_word_agreement_lifts",
    "TrackBKrylovBridge.countdown_zero_minimax_radius",
]

DECL_RE = re.compile(
    r"^(?:@\[[^\]]+\]\s+)*(?:noncomputable\s+)?(theorem|def|abbrev|structure)\s+([A-Za-z0-9_']+)",
    re.MULTILINE,
)


def find_lean_binary() -> pathlib.Path:
    toolchain = TOOLCHAIN_FILE.read_text(encoding="utf-8").strip()
    mangled = toolchain.replace("/", "--").replace(":", "---")
    candidate = pathlib.Path.home() / ".elan" / "toolchains" / mangled / "bin" / "lean"
    if candidate.exists():
        return candidate
    raise FileNotFoundError(f"Could not locate Lean binary for toolchain {toolchain!r}")


def mathlib_project() -> pathlib.Path:
    return pathlib.Path(os.environ.get("SYSTEMS_MATHLIB_PROJECT",
                                       str(pathlib.Path.home() / "repos" / "生生不息")))


def find_mathlib_lean_paths() -> list[str]:
    pkgs = mathlib_project() / ".lake" / "packages"
    paths = [str(p) for p in sorted(pkgs.glob("*/.lake/build/lib/lean")) if p.is_dir()]
    if not paths:
        raise FileNotFoundError(f"No .lake/build/lib/lean directories found under {pkgs}")
    return paths


def read_mathlib_revision() -> str:
    manifest = mathlib_project() / "lake-manifest.json"
    try:
        for pkg in json.loads(manifest.read_text(encoding="utf-8")).get("packages", []):
            if pkg.get("name") == "mathlib":
                return str(pkg.get("rev", "unknown"))
    except Exception:
        pass
    return "unknown"


def strip_lean_comments(src: str) -> str:
    out: list[str] = []
    i, n, depth = 0, len(src), 0
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


def run_static_checks(src: str, decls: list[dict[str, str]]):
    clean = strip_lean_comments(src)
    private_decls = re.findall(r"^\s*private\s+\S+", clean, flags=re.MULTILINE)
    unnamed_instances = re.findall(
        r"^\s*(?:@\[[^\]]+\]\s+)?instance\s*[:{\[(]", clean, flags=re.MULTILINE)
    forbidden: list[str] = []
    for tok in ("sorry", "admit"):
        if re.search(rf"\b{tok}\b", clean):
            forbidden.append(tok)
    for kw in ("axiom", "lemma", "class"):
        if re.search(rf"^\s*{kw}\b", clean, flags=re.MULTILINE):
            forbidden.append(kw)
    scanned = style.MARKET_ALLOWED.sub("", src)
    market_hits = sorted({w.lower() for w in style.MARKET_EN.findall(scanned)}
                         | set(style.MARKET_ZH.findall(scanned)))
    present = {d["name"] for d in decls}
    missing = [r for r in REQUIRED_DECLARATIONS if r not in present]
    return private_decls, unnamed_instances, forbidden, market_hits, missing


def parse_axioms_output(stdout: str, decl_names: list[str]) -> dict[str, list[str]]:
    result: dict[str, list[str]] = {}
    for line in stdout.splitlines():
        line = line.strip()
        m_no = re.match(r"^'([^']+)' does not depend on any axioms$", line)
        if m_no:
            result[m_no.group(1)] = []
            continue
        m_yes = re.match(r"^'([^']+)' depends on axioms:\s*\[([^\]]*)\]$", line)
        if m_yes:
            result[m_yes.group(1)] = [a.strip() for a in m_yes.group(2).split(",") if a.strip()]
    missing = [name for name in decl_names if name not in result]
    if missing:
        raise RuntimeError(f"Missing #print axioms output for: {missing}\nSTDOUT:\n{stdout}")
    return result


def compile_lean(lean_bin, args, cwd, env, what):
    res = subprocess.run([str(lean_bin), *args], cwd=cwd, env=env, text=True,
                         capture_output=True, timeout=TIMEOUT)
    if res.returncode != 0:
        raise RuntimeError(f"Lean compilation of {what} failed (exit {res.returncode}):\n"
                           f"STDOUT:\n{res.stdout}\nSTDERR:\n{res.stderr}")
    return res


def main() -> int:
    src = SOURCE_FILE.read_text(encoding="utf-8")
    toolchain = TOOLCHAIN_FILE.read_text(encoding="utf-8").strip()
    lean_bin = find_lean_binary()
    lean_ver = subprocess.check_output([str(lean_bin), "--version"], text=True).strip()
    math_paths = find_mathlib_lean_paths()

    decls = [{"kind": m.group(1), "name": f"{MODULE_NAME}.{m.group(2)}"}
             for m in DECL_RE.finditer(src)]
    decl_names = [d["name"] for d in decls]
    private_decls, unnamed_instances, forbidden, market_hits, missing = run_static_checks(src, decls)
    if private_decls or unnamed_instances or forbidden or market_hits or missing:
        raise RuntimeError(
            "Static check failed: "
            f"private={private_decls}, unnamed_instances={unnamed_instances}, "
            f"forbidden={forbidden}, market_words={market_hits}, missing_required={missing}")

    index = core.module_index()
    order: list[str] = []
    seen: set[str] = set()

    def visit(name: str) -> None:
        if name in seen or name.split(".")[0] in {"Init", "Std", "Lean", "Mathlib"}:
            return
        paths = index.get(name, [])
        assert len(paths) == 1, (name, [str(p) for p in paths])
        for dep in core.imports_of(paths[0].read_bytes()):
            visit(dep)
        seen.add(name)
        order.append(name)

    visit(TRACK_B_MODULE)
    inherited = list(order)

    with tempfile.TemporaryDirectory(prefix="trackb_krylov_bridge_") as tmp:
        tmp_path = pathlib.Path(tmp)
        env = os.environ.copy()
        env["LEAN_PATH"] = os.pathsep.join([str(tmp_path)] + math_paths)

        conseq_bytes = BASE_CONSEQ.read_bytes()
        bridges_bytes = BASE_BRIDGES.read_bytes()
        trackb_bytes = TRACK_B.read_bytes()
        raw_bytes = SOURCE_FILE.read_bytes()

        for name in inherited:
            rel = core.source_file(name)
            target = tmp_path / rel
            target.parent.mkdir(parents=True, exist_ok=True)
            dep_bytes = trackb_bytes if name == TRACK_B_MODULE else index[name][0].read_bytes()
            target.write_bytes(dep_bytes)
            compile_lean(lean_bin, ["-o", str(tmp_path / rel[:-5]) + ".olean", rel],
                         tmp_path, env, name)

        for name, file_bytes in (("ConsequenceDuality", conseq_bytes),
                                 ("DualityBridges", bridges_bytes),
                                 (MODULE_NAME, raw_bytes)):
            dep_lean = tmp_path / f"{name}.lean"
            dep_lean.write_bytes(file_bytes)
            res = compile_lean(lean_bin, ["-o", str(tmp_path / f"{name}.olean"), dep_lean.name],
                               tmp_path, env, dep_lean.name)
            if name == MODULE_NAME and (res.stdout.strip() or res.stderr.strip()):
                raise RuntimeError(f"Lean compilation of {dep_lean.name} emitted output:\n"
                                   f"STDOUT:\n{res.stdout}\nSTDERR:\n{res.stderr}")

        audit_lines = [f"import {MODULE_NAME}", ""]
        audit_lines += [f"#print axioms {d}" for d in decl_names]
        audit_lines += [f"#check @{r}" for r in REQUIRED_DECLARATIONS]
        audit_file = tmp_path / "AuditTrackBKrylovBridge.lean"
        audit_file.write_text("\n".join(audit_lines) + "\n", encoding="utf-8")
        audit_res = compile_lean(lean_bin, [str(audit_file)], tmp_path, env, "audit")
        axioms_by_decl = parse_axioms_output(audit_res.stdout, decl_names)
        disallowed = {n: sorted(set(a) - STANDARD_AXIOMS)
                      for n, a in axioms_by_decl.items() if set(a) - STANDARD_AXIOMS}
        if disallowed:
            raise RuntimeError(f"Non-standard axioms detected: {disallowed}")

    all_axioms = sorted({ax for axs in axioms_by_decl.values() for ax in axs})
    if (
        BASE_CONSEQ.read_bytes() != conseq_bytes
        or BASE_BRIDGES.read_bytes() != bridges_bytes
        or TRACK_B.read_bytes() != trackb_bytes
        or SOURCE_FILE.read_bytes() != raw_bytes
    ):
        raise RuntimeError("Source bytes changed on disk during check; snapshot integrity failed")

    receipt = {
        "module": MODULE_NAME,
        "source_file": str(SOURCE_FILE.relative_to(HERE)),
        "source_sha256": hashlib.sha256(raw_bytes).hexdigest(),
        "imported_unmodified_sha256": {
            "ConsequenceDuality": hashlib.sha256(conseq_bytes).hexdigest(),
            "DualityBridges": hashlib.sha256(bridges_bytes).hexdigest(),
            TRACK_B_MODULE: hashlib.sha256(trackb_bytes).hexdigest(),
        },
        "track_b_inherited_modules": len(inherited) - 1,
        "verified_at_utc": datetime.now(timezone.utc).isoformat(),
        "ai_written": True,
        "toolchain": toolchain,
        "lean_version": lean_ver,
        "mathlib_revision": read_mathlib_revision(),
        "status": "passed",
        "standard_axioms_allowed": sorted(STANDARD_AXIOMS),
        "all_axioms_used": all_axioms,
        "sorry_ax_count": sum(1 for a in axioms_by_decl.values() if "sorryAx" in a),
        "static_checks": {
            "private_declarations": private_decls,
            "unnamed_instances": unnamed_instances,
            "forbidden_tokens": forbidden,
            "market_word_hits": market_hits,
            "missing_required_declarations": missing,
        },
        "declaration_count": len(decl_names),
        "theorem_count": sum(1 for d in decls if d["kind"] == "theorem"),
        "definition_count": sum(1 for d in decls if d["kind"] in ("def", "abbrev")),
        "structure_count": sum(1 for d in decls if d["kind"] == "structure"),
        "required_declarations_verified": REQUIRED_DECLARATIONS,
        "declarations": [{"kind": d["kind"], "name": d["name"], "axioms": axioms_by_decl[d["name"]]}
                         for d in decls],
    }
    RECEIPT_FILE.write_text(json.dumps(receipt, indent=2) + "\n", encoding="utf-8")
    print(f"PASSED: {MODULE_NAME} ({receipt['declaration_count']} declarations: "
          f"{receipt['theorem_count']} theorems, {receipt['definition_count']} defs, "
          f"{receipt['structure_count']} structures); axioms={all_axioms}; "
          f"sorryAx=0; private=0; unnamed_instances=0; market_word_hits=0")
    print(f"Receipt written to {RECEIPT_FILE}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
