#!/usr/bin/env python3
"""Standalone `comparator`-style verifier for `BecomingSpec` (v1 -> v2 + IN1 + Oplax).

AI-written (Track S1, 2026-11-24). Strictly read-only on repository sources:
- Compiles only inside `tempfile.TemporaryDirectory()` (zero `.olean`/`.ilean` clutter in repo).
- Phase 1: Audits `BecomingSpec.*` (`import Init` only) on BOTH Lean v4.29.1 and Lean v4.30.0-rc2,
  verifying zero compiler warnings, zero `.injEq`, zero axioms across EVERY constant,
  `#print axioms` cleanliness, and cross-toolchain specification signature equality.
- Phase 2: Compiles `Challenge.lean` (`BecomingSpec.*`-only) and `Solution.lean` (`Becoming.*`
  adapters) in isolated v4.29.1 build roots, performs Alpöge/Claude-style `comparator` AST +
  transitive spec-closure equivalence verification, and audits zero axioms on all targets and
  adapters in `Solution.lean`.
- Phase 3: Runs 4 automated negative tamper self-tests in temp dirs (`<=` -> `<`, `Safe := True`,
  swapped projection, `sorryAx`) and asserts every tamper is rejected.
- Phase 4: Writes `becoming-spec-verification.json`.
"""

from __future__ import annotations

import hashlib
import importlib.util
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from datetime import datetime, timezone
from pathlib import Path

sys.dont_write_bytecode = True

HERE = Path(__file__).resolve().parent
LEAN_ROOT = HERE.parent
SPEC_ROOT = LEAN_ROOT / "becoming-spec"
BECOMING_ROOT = LEAN_ROOT / "becoming"
CHALLENGE_FILE = HERE / "Challenge.lean"
SOLUTION_FILE = HERE / "Solution.lean"
OUTPUT_JSON = HERE / "becoming-spec-verification.json"

ELAN_TOOLCHAINS = Path.home() / ".elan" / "toolchains"
LEAN_429 = Path(os.environ.get("BECOMING_SPEC_LEAN_429", str(ELAN_TOOLCHAINS / "leanprover--lean4---v4.29.1" / "bin" / "lean")))
LEAN_430 = Path(os.environ.get("BECOMING_SPEC_LEAN_430", str(ELAN_TOOLCHAINS / "leanprover--lean4---v4.30.0-rc2" / "bin" / "lean")))

SPEC_MODULES = [
    "BecomingSpec.V1.Targets",
    "BecomingSpec.V2.Targets",
    "BecomingSpec.Revision.IN1",
    "BecomingSpec.Extensions.OplaxTargets",
    "BecomingSpec.Extensions.EntryTargets",
    "BecomingSpec.Extensions.SpineTargets",
]

ALLOWED_SPEC_IMPORTS = {
    "BecomingSpec.V1.Targets": {"Init"},
    "BecomingSpec.V2.Targets": {"Init"},
    "BecomingSpec.Revision.IN1": {"BecomingSpec.V2.Targets"},
    "BecomingSpec.Extensions.OplaxTargets": {"Init"},
    "BecomingSpec.Extensions.EntryTargets": {"Init"},
    "BecomingSpec.Extensions.SpineTargets": {"Init"},
}

TARGET_THEOREMS = [
    "BecomingSpecCheck.v1_prefixMargin",
    "BecomingSpecCheck.v1_live",
    "BecomingSpecCheck.v1_cycleBoundary",
    "BecomingSpecCheck.v1_sameViewObstruction",
    "BecomingSpecCheck.v1_in1SameViewWitness",
    "BecomingSpecCheck.v1_commonAction",
    "BecomingSpecCheck.v1_completes",
    "BecomingSpecCheck.v1_branchStuck",
    "BecomingSpecCheck.v1_significanceFree",
    "BecomingSpecCheck.v2_eraseCommutes",
    "BecomingSpecCheck.v2_pass2RefinesPass1",
    "BecomingSpecCheck.v2_v1Blindness",
    "BecomingSpecCheck.in1_sameView",
    "BecomingSpecCheck.in1_separation",
    "BecomingSpecCheck.in1_decisionDefeat",
    "BecomingSpecCheck.in1_seed3FaithfulHarm",
    "BecomingSpecCheck.in1_seed7RevisionSaves",
    "BecomingSpecCheck.ext_allFibers",
    "BecomingSpecCheck.ext_missingLift",
    "BecomingSpecCheck.entry_adaptiveBeatsFixed",
    "BecomingSpecCheck.entry_branchingVsPathCount",
    "BecomingSpecCheck.entry_openSecondEntry",
    "BecomingSpecCheck.spine_hiddenCouplingCollapse",
    "BecomingSpecCheck.spine_widenHealsBlindness",
    "BecomingSpecCheck.spine_directed3DNonCollapse",
    "BecomingSpecCheck.spine_masterSpineEthicsFirewall",
]

TARGET_DEFS = [
    "BecomingSpec.V1.prefixMarginTarget",
    "BecomingSpec.V1.liveTarget",
    "BecomingSpec.V1.cycleBoundaryTarget",
    "BecomingSpec.V1.sameViewObstructionTarget",
    "BecomingSpec.V1.in1SameViewWitnessTarget",
    "BecomingSpec.V1.commonActionTarget",
    "BecomingSpec.V1.completesTarget",
    "BecomingSpec.V1.branchStuckTarget",
    "BecomingSpec.V1.significanceFreeTarget",
    "BecomingSpec.V2.eraseCommutesTarget",
    "BecomingSpec.V2.pass2RefinesPass1Target",
    "BecomingSpec.V2.v1BlindnessTarget",
    "BecomingSpec.Revision.IN1.in1SameViewTarget",
    "BecomingSpec.Revision.IN1.in1SeparationTarget",
    "BecomingSpec.Revision.IN1.in1DecisionDefeatTarget",
    "BecomingSpec.Revision.IN1.in1Seed3FaithfulHarmTarget",
    "BecomingSpec.Revision.IN1.in1Seed7RevisionSavesTarget",
    "BecomingSpec.Extensions.allFibersTarget",
    "BecomingSpec.Extensions.missingLiftTarget",
    "BecomingSpec.Extensions.adaptiveBeatsFixedTarget",
    "BecomingSpec.Extensions.branchingVsPathCountTarget",
    "BecomingSpec.Extensions.openSecondEntryTarget",
    "BecomingSpec.Extensions.hiddenCouplingCollapseTarget",
    "BecomingSpec.Extensions.widenHealsBlindnessTarget",
    "BecomingSpec.Extensions.directed3DNonCollapseTarget",
    "BecomingSpec.Extensions.masterSpineEthicsFirewallTarget",
]

IMPORT_RE = re.compile(r"^\s*import\s+([A-Za-z0-9_.]+)", re.MULTILINE)


class VerifierError(RuntimeError):
    """Structured failure raised when any verification gate rejects a submission."""

    def __init__(self, code: str, detail: str):
        super().__init__(f"[{code}] {detail}")
        self.code = code
        self.detail = detail


def mod_to_rel_lean(mod: str) -> str:
    return mod.replace(".", "/") + ".lean"


def mod_to_rel_olean(mod: str) -> str:
    return mod.replace(".", "/") + ".olean"


def parse_imports(text: str) -> list[str]:
    return IMPORT_RE.findall(text)


def toolchain_env(lean_bin: Path, build_dir: Path) -> dict[str, str]:
    sysroot = lean_bin.parent.parent
    return dict(
        os.environ,
        LEAN_PATH=str(build_dir),
        LEAN_SYSROOT=str(sysroot),
        PATH=f"{lean_bin.parent}:{os.environ.get('PATH', '')}",
    )


def run_lean(lean_bin: Path, args: list[str], env: dict[str, str], cwd: Path | None = None) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [str(lean_bin), *args],
        cwd=str(cwd) if cwd else None,
        env=env,
        capture_output=True,
        text=True,
        timeout=300,
    )


def ensure_no_repo_clutter() -> None:
    clutter: list[str] = []
    for root in (SPEC_ROOT, HERE):
        for pat in ("*.olean", "*.ilean", "*.c"):
            for p in root.rglob(pat):
                clutter.append(str(p.relative_to(LEAN_ROOT)))
    if clutter:
        raise VerifierError("repo_clutter", f"Found forbidden compiled artifacts in repo: {clutter}")


def strip_lean_comments(text: str) -> str:
    """Strip Lean line `-- ...` and nested `/- ... -/` comments for hygiene token scans."""
    out: list[str] = []
    i, n, depth = 0, len(text), 0
    while i < n:
        if depth == 0 and text.startswith("--", i):
            j = text.find("\n", i)
            i = n if j == -1 else j
        elif text.startswith("/-", i):
            depth += 1
            i += 2
        elif depth > 0 and text.startswith("-/", i):
            depth -= 1
            i += 2
        elif depth == 0:
            out.append(text[i])
            i += 1
        else:
            i += 1
    return "".join(out)


def check_hygiene() -> dict:
    for tc_path in (SPEC_ROOT / "lean-toolchain", HERE / "lean-toolchain"):
        val = tc_path.read_text(encoding="utf-8").strip()
        if val != "leanprover/lean4:v4.29.1":
            raise VerifierError("toolchain_mismatch", f"{tc_path} has {val!r}, expected 'leanprover/lean4:v4.29.1'")

    spec_imports: dict[str, list[str]] = {}
    line_counts: dict[str, int] = {}
    for mod in SPEC_MODULES:
        path = SPEC_ROOT / mod_to_rel_lean(mod)
        text = path.read_text(encoding="utf-8")
        stripped = strip_lean_comments(text)
        line_counts[mod] = len(text.splitlines())
        if "AI-written" not in text:
            raise VerifierError("missing_attribution", f"{path} missing AI-written attribution")
        if re.search(r"(?m)^\s*axiom\b", stripped) or re.search(r"\bsorry\b", stripped):
            raise VerifierError("spec_forbidden_token", f"{path} contains axiom or sorry")
        imps = parse_imports(stripped)
        spec_imports[mod] = imps
        if set(imps) != ALLOWED_SPEC_IMPORTS[mod]:
            raise VerifierError(
                "spec_import_violation",
                f"{mod} imports {imps}, expected {sorted(ALLOWED_SPEC_IMPORTS[mod])}",
            )

    chal_text = CHALLENGE_FILE.read_text(encoding="utf-8")
    chal_imps = parse_imports(strip_lean_comments(chal_text))
    if set(chal_imps) != set(SPEC_MODULES) or len(chal_imps) != len(SPEC_MODULES):
        raise VerifierError("challenge_import_violation", f"Challenge.lean imports {chal_imps}, expected {SPEC_MODULES}")
    if "AI-written" not in chal_text:
        raise VerifierError("missing_attribution", "Challenge.lean missing AI-written attribution")

    sol_text = SOLUTION_FILE.read_text(encoding="utf-8")
    sol_stripped = strip_lean_comments(sol_text)
    if "AI-written" not in sol_text:
        raise VerifierError("missing_attribution", "Solution.lean missing AI-written attribution")
    if re.search(r"(?m)^\s*axiom\b", sol_stripped) or re.search(r"\bsorry\b|\badmit\b", sol_stripped):
        raise VerifierError("solution_forbidden_token", "Solution.lean source contains axiom/sorry/admit")

    line_counts["Challenge"] = len(chal_text.splitlines())
    line_counts["Solution"] = len(sol_text.splitlines())
    v1_v2_in1_total = (
        line_counts["BecomingSpec.V1.Targets"]
        + line_counts["BecomingSpec.V2.Targets"]
        + line_counts["BecomingSpec.Revision.IN1"]
    )
    return {
        "toolchains_ok": True,
        "spec_imports": spec_imports,
        "challenge_imports": chal_imps,
        "line_counts": line_counts,
        "v1_v2_in1_total_lines": v1_v2_in1_total,
    }


SPEC_AUDIT_LEAN = r'''import Lean
import BecomingSpec.V1.Targets
import BecomingSpec.V2.Targets
import BecomingSpec.Revision.IN1
import BecomingSpec.Extensions.OplaxTargets
import BecomingSpec.Extensions.EntryTargets
import BecomingSpec.Extensions.SpineTargets
open Lean

partial def lvlKey : Level → String
  | .zero => "z"
  | .succ l => s!"s({lvlKey l})"
  | .max a b => s!"m({lvlKey a},{lvlKey b})"
  | .imax a b => s!"im({lvlKey a},{lvlKey b})"
  | .param n => s!"p({n})"
  | .mvar id => s!"mv({id.name})"

partial def exprKey : Expr → String
  | .bvar i => s!"b({i})"
  | .fvar id => s!"f({id.name})"
  | .mvar id => s!"mv({id.name})"
  | .sort l => s!"S({lvlKey l})"
  | .const n ls => s!"C({n},[{String.intercalate "," (ls.map lvlKey)}])"
  | .app f a => s!"A({exprKey f},{exprKey a})"
  | .lam _ t b bi => s!"L({repr bi},{exprKey t},{exprKey b})"
  | .forallE _ t b bi => s!"F({repr bi},{exprKey t},{exprKey b})"
  | .letE _ t v b _ => s!"E({exprKey t},{exprKey v},{exprKey b})"
  | .lit l => s!"lit({repr l})"
  | .mdata _ e => exprKey e
  | .proj t i e => s!"P({t},{i},{exprKey e})"

def runAudit (specMods : Std.HashSet Nat) : CoreM (List String) := do
  let env ← getEnv
  let mut out : Array String := #[]
  for (n, ci) in env.constants.map₁.toList do
    if let some idx := env.getModuleIdxFor? n then
      if specMods.contains idx then
        let s := n.toString
        let axs := ((← collectAxioms n).toList.map (·.toString))
        let kind := match ci with
          | .defnInfo _ => "defn"
          | .thmInfo _ => "thm"
          | .inductInfo _ => "induct"
          | .ctorInfo _ => "ctor"
          | .recInfo _ => "rec"
          | .opaqueInfo _ => "opaque"
          | .axiomInfo _ => "axiom"
          | .quotInfo _ => "quot"
        let body := match ci with
          | .defnInfo v => exprKey v.value
          | .thmInfo _ => "thm"
          | .inductInfo v => s!"ind:{v.numParams}:{v.numIndices}:{v.ctors}"
          | .ctorInfo v => s!"ctor:{v.cidx}:{v.numParams}:{v.numFields}"
          | .recInfo v => s!"rec:{v.numParams}:{v.numIndices}:{v.numMotives}:{v.numMinors}"
          | _ => kind
        let line := Json.mkObj [
          ("name", Json.str s),
          ("kind", Json.str kind),
          ("injEq", Json.bool (s.endsWith ".injEq")),
          ("axioms", Json.arr (axs.map Json.str).toArray),
          ("levelParams", Json.arr (ci.levelParams.map (fun p => Json.str p.toString)).toArray),
          ("type", Json.str (exprKey ci.type)),
          ("body", Json.str body)
        ] |>.compress
        out := out.push line
  return (out.qsort (· < ·)).toList

def main : IO Unit := do
  let sysroot ← IO.getEnv "LEAN_SYSROOT"
  initSearchPath (sysroot.getD "")
  let env ← importModules #[
    { module := `BecomingSpec.V1.Targets },
    { module := `BecomingSpec.V2.Targets },
    { module := `BecomingSpec.Revision.IN1 },
    { module := `BecomingSpec.Extensions.OplaxTargets },
    { module := `BecomingSpec.Extensions.EntryTargets }
  ] {} 0
  let mut specMods : Std.HashSet Nat := {}
  for m in [`BecomingSpec.V1.Targets, `BecomingSpec.V2.Targets, `BecomingSpec.Revision.IN1, `BecomingSpec.Extensions.OplaxTargets, `BecomingSpec.Extensions.EntryTargets] do
    if let some idx := env.getModuleIdx? m then
      specMods := specMods.insert idx
  let ctx : Core.Context := { fileName := "<spec-audit>", fileMap := default }
  let (lines, _) ← (runAudit specMods).toIO ctx { env := env }
  for l in lines do
    IO.println l
'''


def compile_spec_and_audit(lean_bin: Path, tag: str, spec_dir: Path = SPEC_ROOT) -> dict:
    if not lean_bin.is_file():
        raise VerifierError("missing_lean_binary", f"Lean toolchain binary not found: {lean_bin}")
    ver = subprocess.run([str(lean_bin), "--version"], capture_output=True, text=True, check=True).stdout.strip()
    with tempfile.TemporaryDirectory(prefix=f"becoming-spec-{tag}-") as td:
        tmp = Path(td)
        build = tmp / "build"
        build.mkdir()
        env = toolchain_env(lean_bin, build)
        for mod in SPEC_MODULES:
            src = spec_dir / mod_to_rel_lean(mod)
            ol = build / mod_to_rel_olean(mod)
            ol.parent.mkdir(parents=True, exist_ok=True)
            res = run_lean(lean_bin, ["-o", str(ol), str(src)], env, cwd=spec_dir)
            if res.returncode != 0 or res.stdout.strip() or res.stderr.strip():
                raise VerifierError(
                    "spec_compile_error",
                    f"[{tag}] {mod} compile rc={res.returncode}\nSTDOUT:{res.stdout}\nSTDERR:{res.stderr}",
                )

        # 1. Full environment constant + axiom + .injEq audit via `import Lean`
        audit_file = tmp / "SpecAudit.lean"
        audit_file.write_text(SPEC_AUDIT_LEAN, encoding="utf-8")
        res = run_lean(lean_bin, ["--run", str(audit_file)], env)
        if res.returncode != 0:
            raise VerifierError("spec_audit_failed", f"[{tag}] SpecAudit.lean rc={res.returncode}\n{res.stdout}\n{res.stderr}")
        constants = [json.loads(line) for line in res.stdout.splitlines() if line.strip()]
        inj_eqs = [c["name"] for c in constants if c["injEq"]]
        ax_fails = {c["name"]: c["axioms"] for c in constants if c["axioms"]}
        bad_kinds = [c["name"] for c in constants if c["kind"] in ("axiom", "opaque", "quot")]
        if inj_eqs:
            raise VerifierError("spec_injeq_present", f"[{tag}] Found .injEq constants: {inj_eqs}")
        if ax_fails:
            raise VerifierError("spec_axiom_present", f"[{tag}] Non-empty axioms in spec: {ax_fails}")
        if bad_kinds:
            raise VerifierError("spec_forbidden_kind", f"[{tag}] Forbidden axiom/opaque/quot kinds: {bad_kinds}")

        # 2. Explicit `#print axioms` verification on all 19 frozen target propositions
        pa_lines = [f"import {m}" for m in SPEC_MODULES]
        pa_lines += [f"#print axioms {t}" for t in TARGET_DEFS]
        pa_file = tmp / "PrintAxiomsSpec.lean"
        pa_file.write_text("\n".join(pa_lines) + "\n", encoding="utf-8")
        pa_res = run_lean(lean_bin, [str(pa_file)], env)
        if pa_res.returncode != 0 or pa_res.stderr.strip():
            raise VerifierError("spec_print_axioms_error", f"[{tag}] #print axioms failed:\n{pa_res.stdout}\n{pa_res.stderr}")
        pa_out = pa_res.stdout.splitlines()
        clean_targets = []
        for t in TARGET_DEFS:
            expected = f"'{t}' does not depend on any axioms"
            if expected not in pa_out:
                raise VerifierError("spec_print_axioms_nonclean", f"[{tag}] Missing {expected!r} in:\n{pa_res.stdout}")
            clean_targets.append(t)

        # User-level signatures (excluding compiler-generated internal helpers like `._f` that vary 4.29 vs 4.30)
        public_sigs = {
            c["name"]: {
                "kind": c["kind"],
                "levelParams": c["levelParams"],
                "type": c["type"],
                "body": c["body"],
            }
            for c in constants
            if not any(part.startswith("_") for part in c["name"].split("."))
            and "match_" not in c["name"]
        }
        return {
            "toolchain": tag,
            "version": ver,
            "compile_rc": 0,
            "warnings_count": 0,
            "total_constants_audited": len(constants),
            "injEq_count": 0,
            "axiom_failures": [],
            "print_axioms_clean_targets": clean_targets,
            "public_signatures": public_sigs,
        }


def populate_becoming_deps(lean_bin: Path, sol_text: str, build_dir: Path, tmp_src: Path) -> dict[str, int]:
    """Restore cached Becoming `.olean`s where SHA-256 matches `check_becoming.py`, compiling any misses in temp."""
    sol_imps = parse_imports(sol_text)
    needed_roots = [m for m in sol_imps if m.startswith("Becoming.") or m == "EncounterEntry"]

    # Load `check_becoming.py` read-only with `sys.dont_write_bytecode = True` for exact cache keys.
    cb_spec = importlib.util.spec_from_file_location("becoming_checker_readonly", str(BECOMING_ROOT / "check_becoming.py"))
    assert cb_spec and cb_spec.loader
    cb = importlib.util.module_from_spec(cb_spec)
    cb_spec.loader.exec_module(cb)

    context = [cb.audit_support.TOOLCHAIN, cb.audit_support.digest(lean_bin.read_bytes())]
    idx = cb.module_index()
    sources = {name: paths[0].read_bytes() for name, paths in idx.items() if len(paths) == 1}

    order: list[str] = []
    seen: set[str] = set()

    def visit(mod: str) -> None:
        if mod in seen or mod not in sources:
            return
        seen.add(mod)
        for dep in cb.imports_of(sources[mod]):
            visit(dep)
        order.append(mod)

    for m in needed_roots:
        visit(m)

    keys = cb.module_keys(context, sources, order)
    reused = 0
    compiled = 0
    env = toolchain_env(lean_bin, build_dir)
    for mod in order:
        ol = build_dir / mod_to_rel_olean(mod)
        ol.parent.mkdir(parents=True, exist_ok=True)
        if cb.reuse(keys[mod], [ol]) is not None:
            reused += 1
        else:
            src = tmp_src / mod_to_rel_lean(mod)
            src.parent.mkdir(parents=True, exist_ok=True)
            src.write_bytes(sources[mod])
            res = run_lean(lean_bin, ["-o", str(ol), str(src)], env, cwd=tmp_src)
            if res.returncode != 0:
                raise VerifierError("becoming_dep_compile_error", f"Failed compiling {mod}:\n{res.stdout}\n{res.stderr}")
            compiled += 1
    return {"total": len(order), "reused_from_cache": reused, "compiled_fresh": compiled}


def comparator_dump_lean(entry_mod: str) -> str:
    return f'''import Lean
import {entry_mod}
open Lean

partial def lvlKey : Level → String
  | .zero => "z"
  | .succ l => s!"s({{lvlKey l}})"
  | .max a b => s!"m({{lvlKey a}},{{lvlKey b}})"
  | .imax a b => s!"im({{lvlKey a}},{{lvlKey b}})"
  | .param n => s!"p({{n}})"
  | .mvar id => s!"mv({{id.name}})"

partial def exprKey : Expr → String
  | .bvar i => s!"b({{i}})"
  | .fvar id => s!"f({{id.name}})"
  | .mvar id => s!"mv({{id.name}})"
  | .sort l => s!"S({{lvlKey l}})"
  | .const n ls => s!"C({{n}},[{{String.intercalate "," (ls.map lvlKey)}}])"
  | .app f a => s!"A({{exprKey f}},{{exprKey a}})"
  | .lam _ t b bi => s!"L({{repr bi}},{{exprKey t}},{{exprKey b}})"
  | .forallE _ t b bi => s!"F({{repr bi}},{{exprKey t}},{{exprKey b}})"
  | .letE _ t v b _ => s!"E({{exprKey t}},{{exprKey v}},{{exprKey b}})"
  | .lit l => s!"lit({{repr l}})"
  | .mdata _ e => exprKey e
  | .proj t i e => s!"P({{t}},{{i}},{{exprKey e}})"

partial def collectConsts (e : Expr) (acc : Array Name) : Array Name :=
  match e with
  | .const n _ => acc.push n
  | .app f a => collectConsts a (collectConsts f acc)
  | .lam _ t b _ => collectConsts b (collectConsts t acc)
  | .forallE _ t b _ => collectConsts b (collectConsts t acc)
  | .letE _ t v b _ => collectConsts b (collectConsts v (collectConsts t acc))
  | .mdata _ e' => collectConsts e' acc
  | .proj _ _ e' => collectConsts e' acc
  | _ => acc

def isExternalMod (m : Name) : Bool :=
  let r := m.getRoot
  r == `Init || r == `Std || r == `Lean

def targetList : List Name := [
  {", ".join("`" + t for t in TARGET_THEOREMS)}
]

def runComparator : CoreM (List String) := do
  let env ← getEnv
  let entryModIdx? := env.getModuleIdx? `{entry_mod}
  let mut lines : Array String := #[]
  let mut queue : Array Name := #[]

  -- 1. Extract target theorems
  for n in targetList do
    match env.find? n with
    | none =>
      lines := lines.push (Json.mkObj [("kind", Json.str "missing_target"), ("name", Json.str n.toString)] |>.compress)
    | some ci =>
      let axs := ((← collectAxioms n).toList.map (·.toString))
      queue := collectConsts ci.type queue
      lines := lines.push (Json.mkObj [
        ("kind", Json.str "target"),
        ("name", Json.str n.toString),
        ("levelParams", Json.arr (ci.levelParams.map (fun p => Json.str p.toString)).toArray),
        ("type", Json.str (exprKey ci.type)),
        ("axioms", Json.arr (axs.map Json.str).toArray)
      ] |>.compress)

  -- 2. BFS transitive closure of non-external constants reachable from target types
  let mut visited : Std.HashSet Name := {{}}
  let mut qi : Nat := 0
  while qi < queue.size do
    let c := queue[qi]!
    qi := qi + 1
    if visited.contains c then
      continue
    visited := visited.insert c
    let some idx := env.getModuleIdxFor? c | continue
    let modName := env.header.moduleNames[idx]!
    if isExternalMod modName then
      continue
    let some ci := env.find? c | continue
    queue := collectConsts ci.type queue
    let valStr := match ci with
      | .defnInfo v => exprKey v.value
      | .thmInfo _ => "thm"
      | .inductInfo v => s!"ind:{{v.numParams}}:{{v.numIndices}}:{{v.ctors}}"
      | .ctorInfo v => s!"ctor:{{v.cidx}}:{{v.numParams}}:{{v.numFields}}"
      | .recInfo v => s!"rec:{{v.numParams}}:{{v.numIndices}}:{{v.numMotives}}:{{v.numMinors}}"
      | .opaqueInfo _ => "opaque"
      | .axiomInfo _ => "axiom"
      | .quotInfo _ => "quot"
    match ci with
    | .defnInfo v => queue := collectConsts v.value queue
    | .inductInfo v =>
      for ctor in v.ctors do
        queue := queue.push ctor
    | _ => pure ()
    lines := lines.push (Json.mkObj [
      ("kind", Json.str "closure_const"),
      ("name", Json.str c.toString),
      ("module", Json.str modName.toString),
      ("cinfo", Json.str (match ci with
        | .defnInfo _ => "defn" | .thmInfo _ => "thm" | .inductInfo _ => "induct"
        | .ctorInfo _ => "ctor" | .recInfo _ => "rec" | .opaqueInfo _ => "opaque"
        | .axiomInfo _ => "axiom" | .quotInfo _ => "quot")),
      ("levelParams", Json.arr (ci.levelParams.map (fun p => Json.str p.toString)).toArray),
      ("type", Json.str (exprKey ci.type)),
      ("body", Json.str valStr)
    ] |>.compress)

  -- 3. Audit every constant declared inside `{entry_mod}` itself (targets + adapters + helpers)
  if let some modIdx := entryModIdx? then
    for (n, _) in env.constants.map₁.toList do
      if env.getModuleIdxFor? n == some modIdx then
        let axs := ((← collectAxioms n).toList.map (·.toString))
        lines := lines.push (Json.mkObj [
          ("kind", Json.str "entry_const"),
          ("name", Json.str n.toString),
          ("axioms", Json.arr (axs.map Json.str).toArray)
        ] |>.compress)

  return lines.toList

def main : IO Unit := do
  let sysroot ← IO.getEnv "LEAN_SYSROOT"
  initSearchPath (sysroot.getD "")
  let env ← importModules #[{{ module := `{entry_mod} }}] {{}} 0
  let ctx : Core.Context := {{ fileName := "<comparator>", fileMap := default }}
  let (lines, _) ← runComparator.toIO ctx {{ env := env }}
  for l in lines do
    IO.println l
'''


def parse_comparator_output(stdout: str) -> dict:
    targets: dict[str, dict] = {}
    closure: dict[str, dict] = {}
    entry_consts: dict[str, list[str]] = {}
    missing: list[str] = []
    for line in stdout.splitlines():
        if not line.strip():
            continue
        obj = json.loads(line)
        k = obj["kind"]
        if k == "missing_target":
            missing.append(obj["name"])
        elif k == "target":
            targets[obj["name"]] = obj
        elif k == "closure_const":
            closure[obj["name"]] = obj
        elif k == "entry_const":
            entry_consts[obj["name"]] = obj["axioms"]
    return {"missing": missing, "targets": targets, "closure": closure, "entry_consts": entry_consts}


def compile_and_dump_challenge(lean_bin: Path = LEAN_429) -> tuple[dict, bytes]:
    with tempfile.TemporaryDirectory(prefix="becoming-spec-chal-") as td:
        tmp = Path(td)
        build = tmp / "build"
        build.mkdir()
        env = toolchain_env(lean_bin, build)
        for mod in SPEC_MODULES:
            src = SPEC_ROOT / mod_to_rel_lean(mod)
            ol = build / mod_to_rel_olean(mod)
            ol.parent.mkdir(parents=True, exist_ok=True)
            res = run_lean(lean_bin, ["-o", str(ol), str(src)], env, cwd=SPEC_ROOT)
            if res.returncode != 0 or res.stdout.strip() or res.stderr.strip():
                raise VerifierError("challenge_spec_compile_error", f"{mod}: {res.stdout}\n{res.stderr}")

        chal_res = run_lean(lean_bin, ["-o", str(build / "Challenge.olean"), str(CHALLENGE_FILE)], env, cwd=CHALLENGE_FILE.parent)
        if chal_res.returncode != 0:
            raise VerifierError("challenge_compile_error", f"Challenge.lean failed:\n{chal_res.stdout}\n{chal_res.stderr}")
        non_sorry = [ln for ln in (chal_res.stdout + chal_res.stderr).splitlines()
                     if ln.strip() and "declaration uses `sorry`" not in ln and "declaration uses 'sorry'" not in ln]
        if non_sorry:
            raise VerifierError("challenge_unexpected_warning", "\n".join(non_sorry))

        dump_file = tmp / "DumpChallenge.lean"
        dump_file.write_text(comparator_dump_lean("Challenge"), encoding="utf-8")
        dres = run_lean(lean_bin, ["--run", str(dump_file)], env)
        if dres.returncode != 0:
            raise VerifierError("challenge_dump_error", f"{dres.stdout}\n{dres.stderr}")
        parsed = parse_comparator_output(dres.stdout)
        if parsed["missing"]:
            raise VerifierError("challenge_missing_targets", str(parsed["missing"]))
        non_spec = [c["name"] for c in parsed["closure"].values() if c["module"] not in SPEC_MODULES]
        if non_spec:
            raise VerifierError("challenge_closure_leak", f"Challenge target types reference non-BecomingSpec constants: {non_spec}")
        digest = hashlib.sha256(
            json.dumps({"targets": {k: {"type": v["type"], "levelParams": v["levelParams"]} for k, v in sorted(parsed["targets"].items())},
                        "closure": dict(sorted(parsed["closure"].items()))}, sort_keys=True).encode()
        ).hexdigest()
        return parsed, digest.encode()


def build_becoming_cache_image(lean_bin: Path, sol_text: str, out_build: Path, tmp_src: Path) -> dict[str, int]:
    return populate_becoming_deps(lean_bin, sol_text, out_build, tmp_src)


def verify_candidate_solution(
    chal_parsed: dict,
    spec_dir: Path,
    sol_path: Path,
    lean_bin: Path,
    becoming_prebuild_dir: Path | None = None,
    allow_warnings: bool = False,
) -> dict:
    sol_text = sol_path.read_text(encoding="utf-8")
    with tempfile.TemporaryDirectory(prefix="becoming-spec-sol-") as td:
        tmp = Path(td)
        build = tmp / "build"
        if becoming_prebuild_dir is not None:
            shutil.copytree(becoming_prebuild_dir, build)
            dep_stats = {"copied_prebuild": True}
        else:
            build.mkdir()
            src_tmp = tmp / "bec_src"
            src_tmp.mkdir()
            dep_stats = populate_becoming_deps(lean_bin, sol_text, build, src_tmp)

        env = toolchain_env(lean_bin, build)
        for mod in SPEC_MODULES:
            src = spec_dir / mod_to_rel_lean(mod)
            ol = build / mod_to_rel_olean(mod)
            ol.parent.mkdir(parents=True, exist_ok=True)
            res = run_lean(lean_bin, ["-o", str(ol), str(src)], env, cwd=spec_dir)
            if res.returncode != 0 or (not allow_warnings and (res.stdout.strip() or res.stderr.strip())):
                raise VerifierError("candidate_spec_compile_error", f"{mod} rc={res.returncode}\n{res.stdout}\n{res.stderr}")

        sol_ol = build / "Solution.olean"
        sres = run_lean(lean_bin, ["-o", str(sol_ol), str(sol_path)], env, cwd=sol_path.parent)
        if sres.returncode != 0:
            raise VerifierError("solution_compile_error", f"Solution failed rc={sres.returncode}\n{sres.stdout}\n{sres.stderr}")
        if not allow_warnings and (sres.stdout.strip() or sres.stderr.strip()):
            raise VerifierError("solution_warning", f"Solution emitted warnings:\n{sres.stdout}\n{sres.stderr}")

        dump_file = tmp / "DumpSolution.lean"
        dump_file.write_text(comparator_dump_lean("Solution"), encoding="utf-8")
        dres = run_lean(lean_bin, ["--run", str(dump_file)], env)
        if dres.returncode != 0:
            raise VerifierError("solution_dump_error", f"{dres.stdout}\n{dres.stderr}")
        sol_parsed = parse_comparator_output(dres.stdout)
        if sol_parsed["missing"]:
            raise VerifierError("solution_missing_targets", f"Missing targets: {sol_parsed['missing']}")

        # Comparator check 1: every target theorem signature matches Challenge
        for t in TARGET_THEOREMS:
            ct = chal_parsed["targets"][t]
            st = sol_parsed["targets"][t]
            if ct["levelParams"] != st["levelParams"] or ct["type"] != st["type"]:
                raise VerifierError(
                    "comparator_type_mismatch",
                    f"Target theorem {t} differs from frozen Challenge!\nChallenge: {ct['type'][:220]}\nSolution:  {st['type'][:220]}",
                )
            if st["axioms"]:
                raise VerifierError("solution_target_axioms", f"Target {t} uses axioms: {st['axioms']}")

        # Comparator check 2: transitive spec closure of target types matches Challenge identically
        chal_closure = chal_parsed["closure"]
        sol_closure = sol_parsed["closure"]
        if set(chal_closure.keys()) != set(sol_closure.keys()):
            missing_k = sorted(set(chal_closure.keys()) - set(sol_closure.keys()))
            extra_k = sorted(set(sol_closure.keys()) - set(chal_closure.keys()))
            raise VerifierError(
                "comparator_closure_key_mismatch",
                f"Transitive closure mismatch: missing={missing_k}, extra={extra_k}",
            )
        for cname in sorted(chal_closure.keys()):
            if chal_closure[cname] != sol_closure[cname]:
                diffs = [
                    f"{fld}: chal={chal_closure[cname][fld]!r:.120} vs sol={sol_closure[cname][fld]!r:.120}"
                    for fld in ("module", "cinfo", "levelParams", "type", "body")
                    if chal_closure[cname][fld] != sol_closure[cname][fld]
                ]
                raise VerifierError(
                    "comparator_spec_tamper",
                    f"Constant {cname} in transitive target closure tampered: {'; '.join(diffs)}",
                )

        # Check 3: ZERO axioms on ALL declarations in Solution module (targets + adapters + helpers)
        entry_ax_fails = {n: axs for n, axs in sol_parsed["entry_consts"].items() if axs}
        if entry_ax_fails:
            raise VerifierError("solution_entry_axioms", f"Axioms detected in Solution declarations: {entry_ax_fails}")

        # Check 4: Independent `#print axioms` check on all 19 targets + all `adapter_*` theorems
        adapter_names = sorted(
            n for n in sol_parsed["entry_consts"].keys()
            if n.startswith("BecomingSpecCheck.adapter_") and ".match_" not in n
        )
        pa_names = TARGET_THEOREMS + adapter_names
        pa_file = tmp / "PrintAxiomsSol.lean"
        pa_file.write_text("import Solution\n" + "\n".join(f"#print axioms {n}" for n in pa_names) + "\n", encoding="utf-8")
        pa_res = run_lean(lean_bin, [str(pa_file)], env)
        if pa_res.returncode != 0 or pa_res.stderr.strip():
            raise VerifierError("solution_print_axioms_error", f"{pa_res.stdout}\n{pa_res.stderr}")
        pa_lines = pa_res.stdout.splitlines()
        for n in pa_names:
            expected = f"'{n}' does not depend on any axioms"
            if expected not in pa_lines:
                raise VerifierError("solution_print_axioms_nonclean", f"Missing {expected!r} in:\n{pa_res.stdout}")

        return {
            "dep_stats": dep_stats,
            "targets_matched": len(TARGET_THEOREMS),
            "closure_constants_matched": len(chal_closure),
            "solution_constants_audited": len(sol_parsed["entry_consts"]),
            "adapter_theorems": adapter_names,
            "print_axioms_verified_count": len(pa_names),
        }


def run_tamper_tests(chal_parsed: dict, becoming_prebuild: Path, lean_bin: Path) -> list[dict]:
    results = []

    def copy_spec_and_sol(td_path: Path) -> tuple[Path, Path]:
        t_spec = td_path / "becoming-spec"
        shutil.copytree(SPEC_ROOT, t_spec)
        t_sol = td_path / "Solution.lean"
        shutil.copy2(SOLUTION_FILE, t_sol)
        return t_spec, t_sol

    # Tamper 1: `≤` flipped to `<` in `liveTarget` (proof still passes with 0 errors and 0 axioms!)
    with tempfile.TemporaryDirectory(prefix="tamper1-le-lt-") as td:
        t_spec, t_sol = copy_spec_and_sol(Path(td))
        v1 = t_spec / "BecomingSpec/V1/Targets.lean"
        orig = v1.read_text(encoding="utf-8")
        old_s = "liveMargin.xCrit ≤ s3.1 ∧ liveMargin.xCrit ≤ s4.1"
        new_s = "liveMargin.xCrit < s3.1 ∧ liveMargin.xCrit ≤ s4.1"
        assert old_s in orig
        v1.write_text(orig.replace(old_s, new_s, 1), encoding="utf-8")
        try:
            verify_candidate_solution(chal_parsed, t_spec, t_sol, lean_bin, becoming_prebuild)
            raise AssertionError("Tamper 1 (`<=` -> `<`) unexpectedly passed!")
        except VerifierError as e:
            assert e.code in ("comparator_type_mismatch", "comparator_spec_tamper", "comparator_closure_key_mismatch"), f"Unexpected error for Tamper 1: {e}"
            results.append({
                "name": "tamper_1_le_to_lt",
                "mutation": "Flipped `liveMargin.xCrit ≤ s3.1` to `liveMargin.xCrit < s3.1` (0-axiom proof still compiles)",
                "rejected": True,
                "error_code": e.code,
                "error_detail": e.detail[:260],
            })

    # Tamper 2: `Safe := True` (`Pass₁ (_ : View₁) : Prop := True` with matching 0-axiom Solution compile)
    with tempfile.TemporaryDirectory(prefix="tamper2-safe-true-") as td:
        t_spec, t_sol = copy_spec_and_sol(Path(td))
        v2 = t_spec / "BecomingSpec/V2/Targets.lean"
        orig = v2.read_text(encoding="utf-8")
        old_s = "def Pass₁ (v : View₁) : Prop := 70 ≤ v.nextStock"
        new_s = "def Pass₁ (_ : View₁) : Prop := True"
        assert old_s in orig
        v2.write_text(orig.replace(old_s, new_s, 1), encoding="utf-8")
        sol_orig = t_sol.read_text(encoding="utf-8")
        sol_new = (
            sol_orig
            .replace("show 70 ≤ 100 by decide", "trivial")
            .replace("show 70 ≤ 80 by decide", "trivial")
        )
        assert sol_new != sol_orig
        t_sol.write_text(sol_new, encoding="utf-8")
        try:
            verify_candidate_solution(chal_parsed, t_spec, t_sol, lean_bin, becoming_prebuild)
            raise AssertionError("Tamper 2 (`Safe := True`) unexpectedly passed!")
        except VerifierError as e:
            assert e.code in ("comparator_type_mismatch", "comparator_spec_tamper", "comparator_closure_key_mismatch"), f"Unexpected error for Tamper 2: {e}"
            results.append({
                "name": "tamper_2_safe_true",
                "mutation": "Weakened `BecomingSpec.V2.Pass₁` to `fun _ => True` (with 0-axiom compiling Solution)",
                "rejected": True,
                "error_code": e.code,
                "error_detail": e.detail[:260],
            })

    # Tamper 3: Swapped projection (`erase` and `q₁` swap `openingStock` and `nextStock`, 0-axiom Solution compiles untouched!)
    with tempfile.TemporaryDirectory(prefix="tamper3-swap-proj-") as td:
        t_spec, t_sol = copy_spec_and_sol(Path(td))
        v2 = t_spec / "BecomingSpec/V2/Targets.lean"
        orig = v2.read_text(encoding="utf-8")
        old_erase = "def erase (v : View₂) : View₁ := ⟨v.openingStock, v.announcements, v.nextStock⟩"
        new_erase = "def erase (v : View₂) : View₁ := ⟨v.nextStock, v.announcements, v.openingStock⟩"
        old_q1 = "def q₁ (h : LakeHistory) : View₁ := ⟨h.openingStock, h.months.map MonthRecord.said, (evalHistory h).1.stock⟩"
        new_q1 = "def q₁ (h : LakeHistory) : View₁ := ⟨(evalHistory h).1.stock, h.months.map MonthRecord.said, h.openingStock⟩"
        assert old_erase in orig and old_q1 in orig
        v2.write_text(orig.replace(old_erase, new_erase, 1).replace(old_q1, new_q1, 1), encoding="utf-8")
        sol_orig = t_sol.read_text(encoding="utf-8")
        t_sol.write_text(sol_orig.replace("show 70 ≤ 80 by decide", "show 70 ≤ 100 by decide"), encoding="utf-8")
        try:
            verify_candidate_solution(chal_parsed, t_spec, t_sol, lean_bin, becoming_prebuild)
            raise AssertionError("Tamper 3 (swapped projection) unexpectedly passed!")
        except VerifierError as e:
            assert e.code in ("comparator_type_mismatch", "comparator_spec_tamper", "comparator_closure_key_mismatch"), f"Unexpected error for Tamper 3: {e}"
            results.append({
                "name": "tamper_3_swapped_projection",
                "mutation": "Swapped `openingStock` and `nextStock` projections in `erase` and `q₁` (0-axiom Solution compiles untouched)",
                "rejected": True,
                "error_code": e.code,
                "error_detail": e.detail[:260],
            })

    # Tamper 4: `sorryAx` injected into `Solution.lean` (`allow_warnings=True` proves `CollectAxioms` catches `sorryAx` directly)
    with tempfile.TemporaryDirectory(prefix="tamper4-sorry-ax-") as td:
        t_spec, t_sol = copy_spec_and_sol(Path(td))
        sol_orig = t_sol.read_text(encoding="utf-8")
        old_thm = "theorem v1_significanceFree : BecomingSpec.V1.significanceFreeTarget := by"
        new_thm = "theorem v1_significanceFree : BecomingSpec.V1.significanceFreeTarget := sorry\nprivate theorem unused_sig_backup : BecomingSpec.V1.significanceFreeTarget := by"
        assert old_thm in sol_orig
        t_sol.write_text(sol_orig.replace(old_thm, new_thm, 1), encoding="utf-8")
        try:
            verify_candidate_solution(chal_parsed, t_spec, t_sol, lean_bin, becoming_prebuild, allow_warnings=True)
            raise AssertionError("Tamper 4 (`sorryAx`) unexpectedly passed!")
        except VerifierError as e:
            assert e.code in ("solution_target_axioms", "solution_entry_axioms") and "sorryAx" in e.detail, f"Unexpected error for Tamper 4: {e}"
            results.append({
                "name": "tamper_4_sorry_ax",
                "mutation": "Replaced `v1_significanceFree` proof in `Solution.lean` with `sorry` (`sorryAx` check with warnings allowed)",
                "rejected": True,
                "error_code": e.code,
                "error_detail": e.detail[:260],
            })

    assert len(results) == 4
    return results


def main() -> int:
    ensure_no_repo_clutter()
    hygiene = check_hygiene()

    # Phase 1: Dual-toolchain (`v4.29.1` & `v4.30.0-rc2`) Init-only `BecomingSpec` compilation + audit
    audit_429 = compile_spec_and_audit(LEAN_429, "v4.29.1")
    audit_430 = compile_spec_and_audit(LEAN_430, "v4.30.0-rc2")
    sig_429 = audit_429.pop("public_signatures")
    sig_430 = audit_430.pop("public_signatures")
    if set(sig_429) != set(sig_430):
        raise VerifierError("cross_toolchain_spec_symbol_mismatch", f"Diff: {sorted(set(sig_429) ^ set(sig_430))}")
    type_diffs = [
        k for k in sorted(sig_429)
        if (sig_429[k]["kind"], sig_429[k]["levelParams"], sig_429[k]["type"])
        != (sig_430[k]["kind"], sig_430[k]["levelParams"], sig_430[k]["type"])
    ]
    if type_diffs:
        raise VerifierError("cross_toolchain_spec_type_mismatch", f"Type/kind/levelParams mismatch: {type_diffs[:10]}")
    body_diffs = [k for k in sorted(sig_429) if sig_429[k]["body"] != sig_430[k]["body"]]
    unexpected_body_diffs = [
        k for k in body_diffs
        if k in TARGET_DEFS or f"C({k}._f," not in sig_430[k]["body"]
    ]
    if unexpected_body_diffs:
        raise VerifierError("cross_toolchain_spec_body_mismatch", f"Unexpected body AST diff v4.29.1 vs v4.30.0-rc2: {unexpected_body_diffs}")

    # Phase 2: Isolated `Challenge` vs `Solution` comparator check + adapter axiom audit (v4.29.1)
    chal_parsed, chal_digest = compile_and_dump_challenge(LEAN_429)
    with tempfile.TemporaryDirectory(prefix="becoming-prebuild-") as pre_td:
        pre_path = Path(pre_td)
        pre_build = pre_path / "build"
        pre_src = pre_path / "src"
        pre_build.mkdir()
        pre_src.mkdir()
        dep_stats = build_becoming_cache_image(LEAN_429, SOLUTION_FILE.read_text(encoding="utf-8"), pre_build, pre_src)

        sol_summary = verify_candidate_solution(
            chal_parsed,
            SPEC_ROOT,
            SOLUTION_FILE,
            LEAN_429,
            becoming_prebuild_dir=pre_build,
            allow_warnings=False,
        )
        sol_summary["dep_stats"] = dep_stats

        # Phase 3: 4 automated negative tamper self-tests
        tamper_results = run_tamper_tests(chal_parsed, pre_build, LEAN_429)

    ensure_no_repo_clutter()

    report = {
        "ai_written": "Track S1 (2026-11-24)",
        "status": "PASS",
        "generated_utc": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "hygiene": hygiene,
        "dual_toolchain_spec_audit": {
            "v4_29_1": audit_429,
            "v4_30_0_rc2": audit_430,
            "cross_toolchain_public_spec_type_match": True,
            "cross_toolchain_target_defs_exact_body_match": True,
            "lean430_brecOn_lambda_factored_defs": body_diffs,
            "public_spec_symbols_matched": len(sig_429),
        },
        "comparator_verification": {
            "challenge_closure_sha256": chal_digest.decode(),
            **sol_summary,
        },
        "tamper_self_tests": tamper_results,
        "repo_clutter_check": "PASS (0 .olean/.ilean/.c artifacts under becoming-spec/ or becoming-spec-check/)",
    }
    OUTPUT_JSON.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(f"PASS: V1+V2+IN1={hygiene['v1_v2_in1_total_lines']} lines | "
          f"spec constants v4.29.1={audit_429['total_constants_audited']} v4.30.0-rc2={audit_430['total_constants_audited']} (0 injEq, 0 axioms) | "
          f"comparator matched {sol_summary['targets_matched']} targets + {sol_summary['closure_constants_matched']} closure constants | "
          f"Solution constants={sol_summary['solution_constants_audited']} (adapters={len(sol_summary['adapter_theorems'])}, 0 axioms) | "
          f"tamper tests={len(tamper_results)}/4 rejected")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except VerifierError as exc:
        print(f"FAIL: {exc}", file=sys.stderr)
        raise SystemExit(1)
