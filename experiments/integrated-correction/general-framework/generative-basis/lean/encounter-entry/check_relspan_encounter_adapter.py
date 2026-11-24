#!/usr/bin/env python3
"""External `-O`-safe verifier for `RelSpanEncounterAdapter.lean` (`Becoming.RelSpan` + `EncounterEntry`).

AI-written (Wave 3 Track A3, 25 November 2026). Compiles `GenerativeCore`, `Becoming.Prelude`,
`Becoming.RelSpan`, `EncounterEntry`, and `RelSpanEncounterAdapter` in a temporary directory
under Lean `v4.29.1`, verifies zero warnings/errors, zero axioms (`[]` across every explicit
declaration and transitive closure), snapshots source bytes before compile, and writes
`relspan-encounter-verification.json`.
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

sys.dont_write_bytecode = True

HERE = Path(__file__).resolve().parent
LEAN_ROOT = HERE.parent
BECOMING_DIR = LEAN_ROOT / "becoming"
TARGET_MODULE = "RelSpanEncounterAdapter"
SOURCE_FILE = HERE / "RelSpanEncounterAdapter.lean"
TOOLCHAIN_FILE = HERE / "lean-toolchain"
RECEIPT_FILE = HERE / "relspan-encounter-verification.json"
EXPECTED_TOOLCHAIN = "leanprover/lean4:v4.29.1"
EXPECTED_VERSION_RE = re.compile(r"^Lean \(version 4\.29\.1(?:,|\)|\s|$)")
REQUIRED_DECLS = [
    "RelSpanEncounterAdapter.listNth?",
    "RelSpanEncounterAdapter.mem_of_listNth?_eq_some",
    "RelSpanEncounterAdapter.exists_listNth?_eq_some_of_mem",
    "RelSpanEncounterAdapter.Mid",
    "RelSpanEncounterAdapter.ExitOcc",
    "RelSpanEncounterAdapter.ExitWitness",
    "RelSpanEncounterAdapter.forgetIdx",
    "RelSpanEncounterAdapter.proj_surjective_iff_completesPostBranch",
    "RelSpanEncounterAdapter.sysA_proj_surjective",
    "RelSpanEncounterAdapter.sysB_leftMid_reqB_empty_fiber",
    "RelSpanEncounterAdapter.heldout_pathCount_vs_branch_fiber_separation",
    "RelSpanEncounterAdapter.branchProcess",
    "RelSpanEncounterAdapter.branchProcess_mapTrace",
]

ELAN_BIN = Path.home() / ".elan" / "toolchains" / "leanprover--lean4---v4.29.1" / "bin" / "lean"
LEAN = Path(os.environ.get("LEAN", str(ELAN_BIN)))

LOCAL_DEPS: list[tuple[str, str, Path]] = [
    ("GenerativeCore", "GenerativeCore.lean", LEAN_ROOT / "GenerativeCore.lean"),
    ("Becoming.Prelude", "Becoming/Prelude.lean", BECOMING_DIR / "Becoming" / "Prelude.lean"),
    ("Becoming.RelSpan", "Becoming/RelSpan.lean", BECOMING_DIR / "Becoming" / "RelSpan.lean"),
    ("EncounterEntry", "EncounterEntry.lean", HERE / "EncounterEntry.lean"),
    ("RelSpanEncounterAdapter", "RelSpanEncounterAdapter.lean", SOURCE_FILE),
]

MARKET_WORDS = {
    "cost", "costs", "costly", "costing",
    "charge", "charges", "charged", "charging",
    "budget", "budgets", "budgeted",
    "pay", "pays", "paying", "payment", "payments", "paid",
    "price", "prices", "priced", "pricing",
    "spend", "spends", "spending", "spent",
    "accounting",
    "credit", "credits", "credited", "crediting",
    "fee", "fees",
    "profit", "profits", "profitable",
    "fund", "funds", "funded", "funding",
}

FORBIDDEN_ESCAPE_RE = re.compile(
    r"\b(?:sorry|admit|axiom|opaque|unsafe|native_decide|implemented_by)\b|debug\.skipKernelTC"
)
FORBIDDEN_MODIFIER_RE = re.compile(r"\b(?:private|lemma|class|deriving)\b")
SCOPE_OPEN_RE = re.compile(r"^\s*(?:noncomputable\s+)?(namespace|section)\b\s*(\S*)")
MUTUAL_OPEN_RE = re.compile(r"^\s*mutual\s*$")
SCOPE_END_RE = re.compile(r"^\s*end(?:\s+\S+)?\s*$")
DECL_RE = re.compile(
    r"^\s*(?:open\b.*?\bin\s+)?"
    r"(?:(?:@\[[^\]]*\]|protected|noncomputable|partial|nonrec|scoped|local)\s+)*"
    r"(theorem|def|abbrev|structure|inductive|instance)\b(.*)$"
)
IDENT_RE = re.compile(r"[^\s:()\[\]{}⦃⦄,]+")
AXIOM_PRINT_RE = re.compile(
    r"'([^']+)' (does not depend on any axioms|depends on axioms: \[([^\]]*)\])"
)


def require(cond: bool, msg: str) -> None:
    if not cond:
        raise ValueError(msg)


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def strip_comments_and_strings(source: str) -> str:
    out: list[str] = []
    i, n, depth, quoted = 0, len(source), 0, False
    while i < n:
        pair, ch = source[i : i + 2], source[i]
        if depth:
            if pair == "/-":
                depth += 1
                out.append("  ")
                i += 2
            elif pair == "-/":
                depth -= 1
                out.append("  ")
                i += 2
            else:
                out.append("\n" if ch == "\n" else " ")
                i += 1
        elif quoted:
            if ch == "\\" and i + 1 < n:
                out.append("  ")
                i += 2
            else:
                quoted = ch != '"'
                out.append("\n" if ch == "\n" else " ")
                i += 1
        elif pair == "/-":
            depth = 1
            out.append("  ")
            i += 2
        elif pair == "--":
            end = source.find("\n", i)
            end = n if end == -1 else end
            out.append(" " * (end - i))
            i = end
        elif ch == '"':
            quoted = True
            out.append(" ")
            i += 1
        else:
            out.append(ch)
            i += 1
    require(depth == 0 and not quoted, "Unclosed comment or string literal")
    return "".join(out)


def name_words(full: str) -> list[str]:
    return [
        w.lower()
        for part in re.split(r"[._']", full)
        for w in re.findall(r"[A-Z]?[a-z]+|[A-Z]+(?![a-z])|[0-9]+", part)
    ]


def scan_adapter_source(source: str) -> dict:
    code = strip_comments_and_strings(source)
    escape_match = FORBIDDEN_ESCAPE_RE.search(code)
    require(escape_match is None, f"Forbidden escape token: {escape_match}")
    mod_match = FORBIDDEN_MODIFIER_RE.search(code)
    require(mod_match is None, f"Forbidden modifier/keyword: {mod_match}")

    imports = [line.strip() for line in re.findall(r"^import\s+(.+)$", code, re.M)]
    require(imports == ["Becoming.RelSpan", "EncounterEntry"], f"Unexpected imports: {imports}")

    scopes: list[tuple[str, str]] = []
    decls: list[dict] = []
    for lineno, line in enumerate(code.splitlines(), 1):
        m_open = SCOPE_OPEN_RE.match(line)
        if m_open:
            scopes.append((m_open.group(1), m_open.group(2)))
            continue
        if MUTUAL_OPEN_RE.match(line):
            scopes.append(("mutual", ""))
            continue
        if SCOPE_END_RE.match(line):
            require(bool(scopes), f"Unmatched end at line {lineno}")
            scopes.pop()
            continue
        m_decl = DECL_RE.match(line)
        if not m_decl:
            continue
        kind, rest = m_decl.group(1), m_decl.group(2).strip()
        require(not (kind == "instance" and (not rest or rest[0] in ":({[⦃")), f"Unnamed instance at line {lineno}")
        m_name = IDENT_RE.match(rest)
        require(m_name is not None, f"Could not parse declaration name at line {lineno}: {line}")
        short_name = m_name.group(0)
        ns_parts = [name for skind, name in scopes if skind == "namespace" and name]
        full_name = ".".join(ns_parts + [short_name]) if ns_parts else short_name
        decls.append({"kind": kind, "name": full_name, "line": lineno})

    require(bool(decls), "No declarations found in adapter")
    names = [d["name"] for d in decls]
    require(len(names) == len(set(names)), f"Duplicate declaration names: {names}")
    for d in decls:
        bad = sorted(set(name_words(d["name"])) & MARKET_WORDS)
        require(not bad, f"Forbidden market words in {d['name']}: {bad}")
    return {"imports": imports, "declarations": decls}


TRANSITIVE_AUDIT_TEMPLATE = """import Lean
import {module}
open Lean

def checkClosure (env : Environment) (roots : List Name) : MetaM Unit := do
  for root in roots do
    let mut stack : Array Name := #[root]
    let mut visited : NameSet := {{}}
    let mut injDeps : Array Name := #[]
    let mut axDeps : Array (Name × List Name) := #[]
    while !stack.isEmpty do
      let n := stack.back!
      stack := stack.pop
      if !visited.contains n then
        visited := visited.insert n
        if n.toString.endsWith ".injEq" then
          injDeps := injDeps.push n
        let axs ← collectAxioms n
        if !axs.isEmpty then
          axDeps := axDeps.push (n, axs.toList)
        if let some ci := env.find? n then
          for u in ci.type.getUsedConstants do
            stack := stack.push u
          if let some v := ci.value? then
            for u in v.getUsedConstants do
              stack := stack.push u
    IO.println s!"TRANSITIVE {{root}} INJEQ={{injDeps.toList}} AX={{axDeps.toList}}"

#eval show MetaM Unit from do
  let env ← getEnv
  checkClosure env [{roots}]
  let some idx := env.getModuleIdx? `{module} | throwError "missing module"
  let mut modConsts : Nat := 0
  let mut modAxioms : Nat := 0
  for (n, _) in env.constants.map₁.toList do
    if env.getModuleIdxFor? n == some idx then
      modConsts := modConsts + 1
      let axs ← collectAxioms n
      if !axs.isEmpty then
        modAxioms := modAxioms + 1
        IO.println s!"ENV_AXIOM {{n}} {{axs.toList}}"
  let containsConst (root tgt : Name) : MetaM Bool := do
    let mut stack : Array Name := #[root]
    let mut visited : NameSet := {{}}
    while !stack.isEmpty do
      let cur := stack.back!
      stack := stack.pop
      if cur == tgt then
        return true
      if !visited.contains cur then
        visited := visited.insert cur
        if let some ci := env.find? cur then
          if let some v := ci.value? then
            for u in v.getUsedConstants do
              stack := stack.push u
    return false
  let usesRelSpan ← containsConst `RelSpanEncounterAdapter.branchProcess_mapTrace `Becoming.RelSpan.mapTrace
  let usesPathCount ← containsConst `RelSpanEncounterAdapter.heldout_pathCount_vs_branch_fiber_separation `EncounterEntry.pathCount_eq
  let usesSysBStuck ← containsConst `RelSpanEncounterAdapter.heldout_pathCount_vs_branch_fiber_separation `EncounterEntry.sysB_branch_stuck
  IO.println s!"ENV_AUDIT_DONE MOD_CONSTS={{modConsts}} ENV_AXIOM_COUNT={{modAxioms}} BRIDGE={{usesRelSpan}},{{usesPathCount}},{{usesSysBStuck}}"
"""

STATEMENT_CHECK_SOURCE = """import Becoming.RelSpan
import EncounterEntry
import RelSpanEncounterAdapter

section StatementCheck
open EncounterEntry

example : BranchSys → Type := RelSpanEncounterAdapter.Mid
example : (sys : BranchSys) → (RelSpanEncounterAdapter.Mid sys × PostReq) → Type :=
  RelSpanEncounterAdapter.ExitOcc
example : BranchSys → Type := RelSpanEncounterAdapter.ExitWitness
example : (sys : BranchSys) → RelSpanEncounterAdapter.ExitWitness sys →
    RelSpanEncounterAdapter.Mid sys × PostReq :=
  RelSpanEncounterAdapter.forgetIdx
example : ∀ sys : BranchSys,
    (∀ q : RelSpanEncounterAdapter.Mid sys × PostReq,
      ∃ w : RelSpanEncounterAdapter.ExitWitness sys,
        RelSpanEncounterAdapter.forgetIdx sys w = q) ↔
    CompletesPostBranch sys :=
  RelSpanEncounterAdapter.proj_surjective_iff_completesPostBranch
example : ∀ q : RelSpanEncounterAdapter.Mid sysA × PostReq,
    ∃ w : RelSpanEncounterAdapter.ExitWitness sysA,
      RelSpanEncounterAdapter.forgetIdx sysA w = q :=
  RelSpanEncounterAdapter.sysA_proj_surjective
example : ¬ ∃ w : RelSpanEncounterAdapter.ExitWitness sysB,
    RelSpanEncounterAdapter.forgetIdx sysB w = (⟨.leftMid, .head _⟩, .reqB) :=
  RelSpanEncounterAdapter.sysB_leftMid_reqB_empty_fiber
example :
    (∀ w : List BranchLabel, entryToExitCount sysA w = entryToExitCount sysB w) ∧
    (∀ q : RelSpanEncounterAdapter.Mid sysA × PostReq,
      ∃ w : RelSpanEncounterAdapter.ExitWitness sysA,
        RelSpanEncounterAdapter.forgetIdx sysA w = q) ∧
    (¬ ∃ w : RelSpanEncounterAdapter.ExitWitness sysB,
      RelSpanEncounterAdapter.forgetIdx sysB w = (⟨.leftMid, .head _⟩, .reqB)) ∧
    ¬ CompletesPostBranch sysB :=
  RelSpanEncounterAdapter.heldout_pathCount_vs_branch_fiber_separation
example : BranchSys → Generative.Process BranchState BranchLabel :=
  RelSpanEncounterAdapter.branchProcess
example :
    ∀ (sys₁ sys₂ : BranchSys) (π : BranchState → BranchState) (φ : BranchLabel → BranchLabel)
      (_ : ∀ s a t, t ∈ sys₁.edges s a → π t ∈ sys₂.edges (π s) (φ a))
      {s t : BranchState} {w : List BranchLabel},
      Generative.Trace (RelSpanEncounterAdapter.branchProcess sys₁) s w t →
      Generative.Trace (RelSpanEncounterAdapter.branchProcess sys₂) (π s) (w.map φ) (π t) :=
  @RelSpanEncounterAdapter.branchProcess_mapTrace
end StatementCheck
"""


def main() -> int:
    require(TOOLCHAIN_FILE.is_file(), f"Missing toolchain file: {TOOLCHAIN_FILE}")
    tc = TOOLCHAIN_FILE.read_text(encoding="utf-8").strip()
    require(tc == EXPECTED_TOOLCHAIN, f"Expected toolchain {EXPECTED_TOOLCHAIN}, got {tc}")
    require(LEAN.is_file(), f"Lean binary not found: {LEAN}")
    ver_out = subprocess.run([str(LEAN), "--version"], capture_output=True, text=True, check=True).stdout.strip()
    require(EXPECTED_VERSION_RE.match(ver_out) is not None, f"Unexpected Lean compiler version '{ver_out}' (expected Lean 4.29.1)")

    # Pre-compile exact byte snapshot before spawning any Lean process
    snapshots: dict[str, bytes] = {}
    source_paths: dict[str, str] = {}
    source_sha256: dict[str, str] = {}
    for mod, rel, path in LOCAL_DEPS:
        require(path.is_file(), f"Missing dependency file: {path}")
        raw = path.read_bytes()
        snapshots[rel] = raw
        source_paths[mod] = str(path.relative_to(LEAN_ROOT))
        source_sha256[mod] = sha256_bytes(raw)

    adapter_src = snapshots["RelSpanEncounterAdapter.lean"].decode("utf-8")
    scan = scan_adapter_source(adapter_src)
    decls = scan["declarations"]
    names = [d["name"] for d in decls]
    require(names == REQUIRED_DECLS, f"Adapter declaration mismatch: got {names}, expected {REQUIRED_DECLS}")

    with tempfile.TemporaryDirectory(prefix="relspan-encounter-") as tmp:
        stage = Path(tmp)
        env = dict(os.environ, LEAN_PATH=str(stage))
        for mod, rel, _ in LOCAL_DEPS:
            dst = stage / rel
            dst.parent.mkdir(parents=True, exist_ok=True)
            dst.write_bytes(snapshots[rel])

        def run_lean(args: list[str]) -> str:
            proc = subprocess.run(
                [str(LEAN)] + args,
                cwd=stage,
                env=env,
                capture_output=True,
                text=True,
                timeout=120,
            )
            out = proc.stdout + proc.stderr
            if proc.returncode != 0:
                raise RuntimeError(f"Lean exited {proc.returncode} on {args}:\n{out}")
            if re.search(r"\b(?:error|warning):", out):
                raise RuntimeError(f"Lean emitted warning/error on {args}:\n{out}")
            return out

        for mod, rel, _ in LOCAL_DEPS:
            olean = rel[:-5] + ".olean"
            run_lean(["-o", olean, rel])

        axiom_driver = f"import {TARGET_MODULE}\n" + "\n".join(f"#print axioms {n}" for n in names) + "\n"
        (stage / "AxiomCheck.lean").write_text(axiom_driver, encoding="utf-8")
        axiom_out = run_lean(["AxiomCheck.lean"])

        parsed = AXIOM_PRINT_RE.findall(axiom_out)
        require([n for n, _, _ in parsed] == REQUIRED_DECLS, f"Axiom audit mismatch: {parsed} vs {REQUIRED_DECLS}")
        for n, status, ax_str in parsed:
            require("does not depend on any axioms" in status, f"Axioms found for {n}: {ax_str}")

        (stage / "StatementCheck.lean").write_text(STATEMENT_CHECK_SOURCE, encoding="utf-8")
        run_lean(["StatementCheck.lean"])

        roots_lit = ", ".join(f"`{n}" for n in REQUIRED_DECLS)
        (stage / "MetaAudit.lean").write_text(
            TRANSITIVE_AUDIT_TEMPLATE.format(module=TARGET_MODULE, roots=roots_lit), encoding="utf-8"
        )
        meta_out = run_lean(["MetaAudit.lean"])
        trans_inj: dict[str, list[str]] = {}
        trans_ax: dict[str, str] = {}
        trans_roots: list[str] = []
        unused_generated_injeq: dict[str, str] = {}
        env_audit_info: tuple[int, int, str] | None = None
        for line in meta_out.splitlines():
            if line.startswith("TRANSITIVE "):
                m = re.match(r"^TRANSITIVE (\S+) INJEQ=\[(.*)\] AX=\[(.*)\]$", line)
                require(m is not None, f"Malformed TRANSITIVE line: {line}")
                root, inj_s, ax_s = m.group(1), m.group(2).strip(), m.group(3).strip()
                trans_roots.append(root)
                if inj_s:
                    trans_inj[root] = [x.strip() for x in inj_s.split(",") if x.strip()]
                if ax_s:
                    trans_ax[root] = ax_s
            elif line.startswith("ENV_AXIOM "):
                _, cname, axs = line.split(" ", 2)
                require(
                    cname.endswith(".injEq") and axs.strip() == "[propext]" and cname not in set(names),
                    f"Unexpected module constant with axioms: {cname} {axs}",
                )
                unused_generated_injeq[cname] = axs.strip()
            elif line.startswith("ENV_AUDIT_DONE "):
                m = re.match(r"^ENV_AUDIT_DONE MOD_CONSTS=(\d+) ENV_AXIOM_COUNT=(\d+) BRIDGE=(\S+)$", line)
                require(m is not None, f"Malformed ENV_AUDIT_DONE line: {line}")
                env_audit_info = (int(m.group(1)), int(m.group(2)), m.group(3))
        require(trans_roots == REQUIRED_DECLS, f"Transitive audit roots mismatch: got {trans_roots}, expected {REQUIRED_DECLS}")
        require(env_audit_info is not None, "Missing ENV_AUDIT_DONE summary from MetaAudit")
        mod_consts, env_axiom_count, bridge_flags = env_audit_info
        require(mod_consts >= len(REQUIRED_DECLS), f"Module constant count too small: {mod_consts}")
        require(
            len(unused_generated_injeq) == env_axiom_count,
            f"ENV_AXIOM rows ({len(unused_generated_injeq)}) != ENV_AXIOM_COUNT ({env_axiom_count})",
        )
        require(
            unused_generated_injeq == {"RelSpanEncounterAdapter.ExitOcc.mk.injEq": "[propext]"},
            f"Unexpected module-level axiom constants: {unused_generated_injeq}",
        )
        require(bridge_flags == "true,true,true", f"Required theorem dependency bridge check failed: {bridge_flags}")
        require(not trans_inj, f"Transitive .injEq dependencies detected: {trans_inj}")
        require(not trans_ax, f"Transitive axiom dependencies detected: {trans_ax}")

    receipt = {
        "ai_written": True,
        "status": "passed",
        "module": TARGET_MODULE,
        "toolchain": tc,
        "lean_version": ver_out,
        "checked_utc": datetime.now(timezone.utc).isoformat(),
        "theorem_count": sum(1 for d in decls if d["kind"] == "theorem"),
        "declaration_count": len(decls),
        "declarations": [d["name"] for d in decls],
        "axioms_empty": True,
        "transitive_injEq_dependencies": trans_inj,
        "transitive_axiom_dependencies": trans_ax,
        "unused_generated_injEq": unused_generated_injeq,
        "source_paths": source_paths,
        "source_sha256": source_sha256,
    }
    RECEIPT_FILE.write_text(json.dumps(receipt, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"status": "passed", "module": TARGET_MODULE, "theorems": receipt["theorem_count"], "declarations": receipt["declaration_count"]}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
