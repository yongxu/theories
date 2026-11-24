#!/usr/bin/env python3
"""Standalone pure-Init Lean v4.29.1 verifier for `EncounterEntry.lean`.

AI-written (`Track S3`, 24 November 2026). Compiles `EncounterEntry.lean` in a
temporary directory (leaving zero `.olean` clutter in the repository), checks:
1. Only `import Init` is present (no `Std`, `Lean`, `Mathlib`, or `Becoming`).
2. Zero `sorry`, `admit`, `axiom`, `opaque`, `unsafe`, `native_decide`,
   `implemented_by`, `debug.skipKernelTC`, `private`, `lemma`, `class`,
   unnamed `instance`, or `deriving` clauses.
3. Zero forbidden `MARKET_WORDS` (matching `check_becoming.py`) in declaration names.
4. `#print axioms` reports `[]` for EVERY explicit declaration.
5. Lean meta transitive-closure audit confirms `0` axiom dependencies and
   `0` `.injEq` dependencies across the transitive closure of EVERY explicit
   declaration; any module-generated constant carrying axioms must be strictly
   an unused `*.injEq` on `["propext"]`.
6. Automated negative self-tests (in temp dirs) confirm `propext`/`omega`,
   `.injEq` via `simp`, `sorryAx`, and forbidden market words are rejected.

Writes `encounter-entry-verification.json` in this directory.
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
TARGET_MODULE = "EncounterEntry"
SOURCE_FILE = HERE / "EncounterEntry.lean"
TOOLCHAIN_FILE = HERE / "lean-toolchain"
RECEIPT_FILE = HERE / "encounter-entry-verification.json"
EXPECTED_TOOLCHAIN = "leanprover/lean4:v4.29.1"
LEAN = Path(
    os.environ.get(
        "LEAN",
        str(Path.home() / ".elan/toolchains/leanprover--lean4---v4.29.1/bin/lean"),
    )
)

# Exact 39 exchange words from `check_becoming.py` (`MARKET_WORDS`).
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
    assert depth == 0 and not quoted, "Unclosed comment or string literal"
    return "".join(out)


def name_words(full: str) -> list[str]:
    return [
        w.lower()
        for part in re.split(r"[._']", full)
        for w in re.findall(r"[A-Z]?[a-z]+|[A-Z]+(?![a-z])|[0-9]+", part)
    ]


def scan_source(source: str) -> dict:
    code = strip_comments_and_strings(source)
    escape_match = FORBIDDEN_ESCAPE_RE.search(code)
    if escape_match:
        raise ValueError(f"Forbidden proof-escape token: {escape_match.group(0)}")
    mod_match = FORBIDDEN_MODIFIER_RE.search(code)
    if mod_match:
        raise ValueError(f"Forbidden declaration modifier/keyword: {mod_match.group(0)}")

    imports = [line.strip() for line in re.findall(r"^import\s+(.+)$", code, re.M)]
    if imports != ["Init"]:
        raise ValueError(f"Expected strictly ['Init'] import, got {imports}")

    scopes: list[tuple[str, str]] = []
    decls: list[dict] = []
    unnamed_instances: list[int] = []

    for lineno, line in enumerate(code.splitlines(), 1):
        m_open = SCOPE_OPEN_RE.match(line)
        if m_open:
            scopes.append((m_open.group(1), m_open.group(2)))
            continue
        if MUTUAL_OPEN_RE.match(line):
            scopes.append(("mutual", ""))
            continue
        if SCOPE_END_RE.match(line):
            if not scopes:
                raise ValueError(f"Unmatched end at line {lineno}")
            scopes.pop()
            continue
        m_decl = DECL_RE.match(line)
        if not m_decl:
            continue
        kind, rest = m_decl.group(1), m_decl.group(2).strip()
        if kind == "instance" and (not rest or rest[0] in ":({[⦃"):
            unnamed_instances.append(lineno)
            continue
        m_name = IDENT_RE.match(rest)
        if not m_name:
            raise ValueError(f"Could not parse declaration name at line {lineno}: {line}")
        short_name = m_name.group(0)
        ns_parts = [name for skind, name in scopes if skind == "namespace" and name]
        full_name = ".".join(ns_parts + [short_name]) if ns_parts else short_name
        decls.append({"kind": kind, "name": full_name, "line": lineno})

    if unnamed_instances:
        raise ValueError(f"Unnamed instances at lines: {unnamed_instances}")
    if not decls:
        raise ValueError("No declarations found")
    names = [d["name"] for d in decls]
    if len(names) != len(set(names)):
        raise ValueError("Duplicate declaration names found")

    market_hits = {
        d["name"]: sorted(set(name_words(d["name"])) & MARKET_WORDS)
        for d in decls
        if set(name_words(d["name"])) & MARKET_WORDS
    }
    if market_hits:
        raise ValueError(f"Forbidden market words in declarations: {market_hits}")

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
  let roots : List Name := [{roots}]
  checkClosure env roots
  let some idx := env.getModuleIdx? `{module} | throwError "missing module"
  for (n, _) in env.constants.map₁.toList do
    if env.getModuleIdxFor? n == some idx then
      let axs ← collectAxioms n
      if !axs.isEmpty then
        IO.println s!"ENV_AXIOM {{n}} {{axs.toList}}"
"""


def verify_source_text(module_name: str, source_text: str) -> dict:
    scan = scan_source(source_text)
    decls = scan["declarations"]
    names = [d["name"] for d in decls]

    with tempfile.TemporaryDirectory(prefix="encounter-entry-") as tmp:
        stage = Path(tmp)
        env = dict(os.environ, LEAN_PATH=str(stage))
        (stage / f"{module_name}.lean").write_text(source_text, encoding="utf-8")

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
                raise RuntimeError(f"Lean exited {proc.returncode}:\n{out}")
            if re.search(r"\b(?:error|warning):", out):
                raise RuntimeError(f"Lean emitted warning/error:\n{out}")
            return out

        compile_out = run_lean(["-o", f"{module_name}.olean", f"{module_name}.lean"])

        axiom_driver = f"import {module_name}\n" + "\n".join(
            f"#print axioms {n}" for n in names
        ) + "\n"
        (stage / "AxiomCheck.lean").write_text(axiom_driver, encoding="utf-8")
        axiom_out = run_lean(["AxiomCheck.lean"])

        parsed = AXIOM_PRINT_RE.findall(axiom_out)
        if [n for n, _, _ in parsed] != names:
            raise RuntimeError(f"Axiom audit mismatch: {parsed} vs {names}")

        nonempty_axioms: dict[str, list[str]] = {}
        for n, status, ax_str in parsed:
            if "does not depend on any axioms" not in status:
                axs = [a.strip() for a in ax_str.split(",") if a.strip()]
                nonempty_axioms[n] = axs
        if nonempty_axioms:
            raise ValueError(f"Non-empty axiom dependencies: {nonempty_axioms}")

        roots_lit = ", ".join(f"`{n}" for n in names)
        meta_driver = TRANSITIVE_AUDIT_TEMPLATE.format(
            module=module_name, roots=roots_lit
        )
        (stage / "MetaAudit.lean").write_text(meta_driver, encoding="utf-8")
        meta_out = run_lean(["MetaAudit.lean"])

        trans_inj: dict[str, list[str]] = {}
        trans_ax: dict[str, list[str]] = {}
        for line in meta_out.splitlines():
            if line.startswith("TRANSITIVE "):
                m = re.match(r"^TRANSITIVE (\S+) INJEQ=\[(.*)\] AX=\[(.*)\]$", line)
                if not m:
                    raise RuntimeError(f"Malformed TRANSITIVE line: {line}")
                root, inj_s, ax_s = m.group(1), m.group(2).strip(), m.group(3).strip()
                if inj_s:
                    trans_inj[root] = [x.strip() for x in inj_s.split(",") if x.strip()]
                if ax_s:
                    trans_ax[root] = [ax_s]
        if trans_inj:
            raise ValueError(f"Transitive .injEq dependencies detected: {trans_inj}")
        if trans_ax:
            raise ValueError(f"Transitive axiom dependencies detected: {trans_ax}")

        env_axioms: dict[str, str] = {}
        for line in meta_out.splitlines():
            if line.startswith("ENV_AXIOM "):
                _, cname, axs = line.split(" ", 2)
                if not (cname.endswith(".injEq") and axs.strip() == "[propext]"):
                    raise ValueError(f"Unexpected module constant with axioms: {cname} {axs}")
                if cname in set(names):
                    raise ValueError(f"Source declaration has axioms: {cname}")
                env_axioms[cname] = axs.strip()

        return {
            "compile_log": compile_out,
            "declarations": decls,
            "nonempty_axioms": nonempty_axioms,
            "transitive_injEq_dependencies": trans_inj,
            "transitive_axiom_dependencies": trans_ax,
            "unused_generated_injEq": env_axioms,
        }


def run_negative_self_tests() -> list[dict]:
    cases = [
        (
            "reject_omega_propext",
            "import Init\nnamespace NegTest\ntheorem bad (n : Nat) : n + 1 = 1 + n := by omega\nend NegTest\n",
        ),
        (
            "reject_injEq_via_simp",
            "import Init\nnamespace NegTest\ninductive Box where | mk (x : Bool)\ntheorem bad (a b : Bool) (h : Box.mk a = Box.mk b) : a = b := by simp at h; exact h\nend NegTest\n",
        ),
        (
            "reject_sorryAx",
            "import Init\nnamespace NegTest\ntheorem bad : False := by sorry\nend NegTest\n",
        ),
        (
            "reject_market_word",
            "import Init\nnamespace NegTest\ndef unitCost : Nat := 1\nend NegTest\n",
        ),
    ]
    results = []
    for label, src in cases:
        caught = False
        reason = ""
        try:
            verify_source_text("NegTest", src)
        except Exception as exc:
            caught = True
            reason = str(exc)
        if not caught:
            raise AssertionError(f"Negative self-test {label} unexpectedly passed!")
        results.append({"case": label, "rejected": True, "reason": reason})
    return results


def main() -> int:
    toolchain_text = TOOLCHAIN_FILE.read_text(encoding="utf-8").strip()
    assert toolchain_text == EXPECTED_TOOLCHAIN, (toolchain_text, EXPECTED_TOOLCHAIN)
    assert LEAN.is_file(), f"Missing Lean binary at {LEAN}"
    lean_version = subprocess.check_output([str(LEAN), "--version"], text=True).strip()
    assert "version 4.29.1," in lean_version, lean_version

    source_bytes = SOURCE_FILE.read_bytes()
    source_text = source_bytes.decode("utf-8")
    audit = verify_source_text(TARGET_MODULE, source_text)
    neg_tests = run_negative_self_tests()

    # Ensure source file did not change and no `.olean` clutter leaked into HERE.
    assert SOURCE_FILE.read_bytes() == source_bytes
    leaked_oleans = [p.name for p in HERE.glob("*.olean")]
    assert not leaked_oleans, f"Unexpected .olean files in repo: {leaked_oleans}"

    decls = audit["declarations"]
    receipt = {
        "checked_at_utc": datetime.now(timezone.utc).isoformat(),
        "status": "passed",
        "toolchain": EXPECTED_TOOLCHAIN,
        "lean_version": lean_version,
        "lean_binary_sha256": sha256_bytes(LEAN.resolve().read_bytes()),
        "module": TARGET_MODULE,
        "source_file": str(SOURCE_FILE.name),
        "source_sha256": sha256_bytes(source_bytes),
        "checker_sha256": sha256_bytes(Path(__file__).read_bytes()),
        "imports": ["Init"],
        "declaration_count": len(decls),
        "theorem_count": sum(1 for d in decls if d["kind"] == "theorem"),
        "declarations": decls,
        "nonempty_axioms": audit["nonempty_axioms"],
        "transitive_injEq_dependencies": audit["transitive_injEq_dependencies"],
        "transitive_axiom_dependencies": audit["transitive_axiom_dependencies"],
        "unused_generated_injEq": audit["unused_generated_injEq"],
        "negative_self_tests": neg_tests,
        "leaked_olean_files": leaked_oleans,
    }
    RECEIPT_FILE.write_text(json.dumps(receipt, indent=2) + "\n", encoding="utf-8")
    print(
        json.dumps(
            {
                "status": receipt["status"],
                "lean_version": receipt["lean_version"],
                "declarations": receipt["declaration_count"],
                "theorems": receipt["theorem_count"],
                "nonempty_axioms": receipt["nonempty_axioms"],
                "transitive_injEq_dependencies": receipt["transitive_injEq_dependencies"],
                "negative_self_tests_passed": len(neg_tests),
            }
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
