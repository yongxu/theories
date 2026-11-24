#!/usr/bin/env python3
"""Check the Mathlib periphery module `MovingFeatureCone` (`AlignmentReals` + cone bounds).

AI-written (Wave 4 Track B3, 25 November 2026).

`MovingFeatureCone` depends on Mathlib and periphery `AlignmentReals` (under Lean 4.30.0-rc2,
`SYSTEMS_MATHLIB_PROJECT`, default `~/repos/生生不息`). Every declaration must depend only on
Lean's three standard axioms (`propext`, `Classical.choice`, `Quot.sound`), with zero
`sorryAx`, `private`, unnamed `instance`s, `lemma`, `class`, `native_decide`, or forbidden market
words in declaration names.
"""
from contextlib import nullcontext
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import tempfile

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
LEAN_ROOT = HERE.parent
sys.path.insert(0, str(LEAN_ROOT / "becoming"))
import check_becoming as core  # noqa: E402

TARGET = "MovingFeatureCone"
RECEIPT = HERE / "moving-feature-cone-verification.json"
RETAINED = HERE / "moving-feature-cone-checks"
TOOLCHAIN_FILE = HERE / "lean-toolchain"
TOOLCHAIN = "leanprover/lean4:v4.30.0-rc2"
LEAN = Path.home() / ".elan/toolchains/leanprover--lean4---v4.30.0-rc2/bin/lean"
MATHLIB_REVISION = "ea11ccc0c5c7c4c562742e918fe2e0b2814a58aa"
EXTERNAL = {"Init", "Std", "Lean", "Mathlib"}
STANDARD_AXIOMS = {"propext", "Classical.choice", "Quot.sound"}
TIMEOUT = int(os.environ.get("LEAN_TIMEOUT", "900"))

SCOPE = (
    "On MovingFeatureCone over Mathlib and AlignmentReals: (1) deterministic endpoint cone "
    "characterization top_cone_iff (3 x^2 <= y^2 <-> (2 / sqrt 3) |c| <= d - a for any unit "
    "top eigenpair with a + d < 2 mu, covering both axis cases without dividing by c/x/y); "
    "(2) path-decomposition deterministic inclusion fp_sandwich and boundary-strip split "
    "intra_boundary_or_osc separating rolling first passage FP from endpoint EP, early passage "
    "Early, and late oscillation Intra under monotone drift; and (3) exact bridges to "
    "AlignmentReals: feature_delay_headroom / feature_delay_extra_headroom via "
    "inertia_lag_headroom_penalty at supplied lag L + tau, and feature_delay_linear_fa_collapse "
    "via linear_fa_leakage_hysteresis at M_delay := tau (retaining fixed-feature margin and "
    "strict shortfall hshort premises, not supplied by the rolling probe)."
)

DISALLOWED_TOKENS = re.compile(
    r"\b(?:lemma|class|opaque|private|sorry|admit|axiom|unsafe|native_decide|implemented_by)\b|debug\.skipKernelTC"
)
SCOPE_OPEN = re.compile(r"^\s*(?:noncomputable\s+)?(namespace|section)\b\s*(\S*)")
MUTUAL_OPEN = re.compile(r"^\s*mutual\s*$")
SCOPE_END = re.compile(r"^\s*end(?:\s+\S+)?\s*$")
DECL_HDR = re.compile(
    r"^\s*(?:(?:open|variable|universe|include|omit)\b.*?\bin\s+)*"
    r"((?:(?:@\[[^\]]*\]|public|private|protected|noncomputable|partial|nonrec|unsafe|scoped(?:\[[^\]]*\])?|local)\s*)*)"
    r"(theorem|def|abbrev|structure|inductive|instance|opaque|class|axiom)\b(.*)$"
)
DECL_NAME = re.compile(r"[^\s:()\[\]{}⦃⦄,]+")
COMPILER_PRIVATE_RE = re.compile(
    rf"^_private\.{re.escape(TARGET)}\.0\.[A-Za-z0-9_.']+\.match_\d+\.(?:eq_\d+|splitter)$"
)
STRUCT_DR_SUFFIXES = {
    "mk", "rec", "recOn", "casesOn", "noConfusion", "mk.noConfusion",
}
STRUCT_AUX_SUFFIXES = STRUCT_DR_SUFFIXES | {
    "mk._flat_ctor", "mk.inj", "mk.injEq", "mk.sizeOf_spec",
    "ctorIdx", "noConfusionType", "_sizeOf_1", "_sizeOf_inst",
}
PARENT_AUX_RE = re.compile(
    r"^(?:_proof_\d+(?:_\d+)*|_simp_\d+(?:_\d+)*|match_\d+(?:_\d+)*|eq_\d+|eq_def|_f|_aux_\d+)$"
)


def require(cond, msg=""):
    if not cond:
        raise ValueError(str(msg) if msg else "Verification check failed")


def strict_code_only(source):
    """Strip comments and string literals without assert so -O preserves checks."""
    out, i, depth, quoted = [], 0, 0, False
    n = len(source)
    while i < n:
        ch, pair = source[i], source[i:i + 2]
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
    require(not depth and not quoted, "Unclosed source comment/string")
    return "".join(out)


def strict_scan(source):
    """-O-safe declaration and token scan across all supported declaration syntax."""
    code = strict_code_only(source)
    bad_tok = DISALLOWED_TOKENS.search(code)
    require(bad_tok is None, f"Disallowed token/declaration keyword in source: {bad_tok.group(0) if bad_tok else ''}")
    attr_stripped = re.sub(r"@\[[^\]]*\]|\battribute\s*\[[^\]]*\]", " ", code)
    for im in re.finditer(r"\binstance\b", attr_stripped):
        tail = attr_stripped[im.end():].lstrip()
        tail = re.sub(r"^\(priority\s*:=[^)]*\)\s*", "", tail)
        iname = DECL_NAME.match(tail)
        require(iname is not None and not iname[0].startswith((".", ":=")),
                ("Unnamed instance declaration in source", attr_stripped[im.start():im.start() + 60]))
    scopes, named = [], []
    for number, line in enumerate(code.splitlines(), 1):
        scope = SCOPE_OPEN.match(line)
        if scope:
            scopes.append((scope[1], scope[2]))
            continue
        if MUTUAL_OPEN.match(line):
            scopes.append(("mutual", ""))
            continue
        if SCOPE_END.match(line):
            require(bool(scopes), (number, line))
            scopes.pop()
            continue
        decl = DECL_HDR.match(line)
        if not decl:
            continue
        modifiers, kind, rest = decl[1], decl[2], decl[3].strip()
        require(not re.search(r"\bprivate\b", modifiers), (number, line))
        if kind == "instance":
            rest = re.sub(r"^\(priority\s*:=[^)]*\)\s*", "", rest)
        name = DECL_NAME.match(rest)
        require(name is not None, ("Unnamed declaration/instance", number, line))
        raw_name = name[0].split(".{")[0].rstrip(".")
        if raw_name.startswith("_root_."):
            full = raw_name[len("_root_."):]
        else:
            prefix = ".".join(nm for k, nm in scopes if k == "namespace" and nm)
            full = prefix + "." + raw_name if prefix else raw_name
        named.append({"kind": kind, "name": full})
    require(not [s for s in scopes if s[0] != "section"], ("Unclosed namespace/mutual scope", scopes))
    require(bool(named), f"Scanned zero declarations in {TARGET}")
    require(len({item["name"] for item in named}) == len(named), "Duplicate declaration names")
    return named


def audit_environment(env_output, registry):
    """Verify and reconcile every compiled constant belonging to TARGET in the Lean environment."""
    done = re.search(r"^ENV_AUDIT_DONE COUNT=(\d+)$", env_output, re.M)
    require(done is not None, ("Missing ENV_AUDIT_DONE", env_output))
    reported_count = int(done.group(1))
    struct_fields = {}
    for sm in re.finditer(r"^ENV_STRUCT\t([^\t\n]+)\t\[([^\]]*)\]$", env_output, re.M):
        struct_fields[sm.group(1).strip()] = {f.strip() for f in sm.group(2).split(",") if f.strip()}
    env_consts = {}
    all_axioms = set()
    compiler_priv_count = 0
    for m in re.finditer(r"^ENV_CONST\t([^\t\n]+)\t\[([^\]]*)\]\t(true|false)\t(true|false)\t(true|false)$", env_output, re.M):
        cname = m.group(1).strip()
        axs = sorted(a.strip() for a in m.group(2).split(",") if a.strip())
        is_inst, has_dr, eq_stem_imp = m.group(3) == "true", m.group(4) == "true", m.group(5) == "true"
        if "._private." in cname or cname.startswith("_private."):
            require(COMPILER_PRIVATE_RE.fullmatch(cname) is not None and not has_dr and not is_inst,
                    ("Private user or unclassified private constant in environment", cname))
            compiler_priv_count += 1
        require(set(axs) <= STANDARD_AXIOMS, ("Non-standard axiom in environment constant", cname, axs))
        bad_words = sorted(set(core.name_words(cname)) & core.MARKET_WORDS)
        require(cname in core.MARKET_ALLOWED or not bad_words,
                ("Market word in environment constant", cname, bad_words))
        env_consts[cname] = (axs, is_inst, has_dr, eq_stem_imp)
        all_axioms.update(axs)
    require(len(env_consts) == reported_count and reported_count >= len(registry),
            ("Environment constant count mismatch", len(env_consts), reported_count, len(registry)))
    missing = [item["name"] for item in registry if item["name"] not in env_consts]
    require(not missing, ("Scanned declarations missing from environment", missing))
    reg_kinds = {item["name"]: item["kind"] for item in registry}
    for cname, (_, is_inst, has_dr, eq_stem_imp) in env_consts.items():
        if is_inst:
            is_size_of = any(
                reg_kinds.get(p) in ("structure", "inductive") and cname == f"{p}._sizeOf_inst"
                for p in reg_kinds
            )
            require(is_size_of or reg_kinds.get(cname) == "instance",
                    ("Undeclared or unnamed typeclass instance in environment", cname))
        if has_dr and cname not in reg_kinds:
            struct_dr = any(
                reg_kinds.get(p) in ("structure", "inductive")
                and cname.startswith(p + ".")
                and (cname[len(p) + 1:] in STRUCT_DR_SUFFIXES or cname[len(p) + 1:] in struct_fields.get(p, set()))
                for p in reg_kinds
            )
            require(struct_dr, ("Source-authored declaration missing from registry", cname))
        if cname in reg_kinds or COMPILER_PRIVATE_RE.fullmatch(cname):
            continue
        matched = False
        for p, kind in reg_kinds.items():
            if cname.startswith(p + "."):
                suf = cname[len(p) + 1:]
                if not has_dr and PARENT_AUX_RE.fullmatch(suf):
                    matched = True
                    break
                if kind in ("structure", "inductive") and (
                    suf in STRUCT_AUX_SUFFIXES or suf in struct_fields.get(p, set())
                ):
                    matched = True
                    break
        if not matched:
            ext_eq = re.fullmatch(r"([A-Za-z_][A-Za-z0-9_.']*)\.(?:eq_\d+|eq_def)", cname)
            if ext_eq and not has_dr and not is_inst and eq_stem_imp:
                matched = True
        require(matched, ("Unaccounted non-registry constant in environment", cname))
    return {
        "module_constants": reported_count,
        "source_private_declarations": 0,
        "compiler_private_constants": compiler_priv_count,
        "axioms": sorted(all_axioms),
    }


def normalized_legacy_scan(src_text):
    """Consistent comparison against shared scanner handling Lean `public` modifier."""
    stripped_public = re.sub(r"(?m)(^|\s)public\s+", r"\1", strict_code_only(src_text))
    return core.scanned(stripped_public.encode())


def regression_self_test():
    """-O-safe regression tests including named public instance and .eq_1 outside target."""
    pub_inst_src = "namespace Demo\npublic instance instDemoNat : Inhabited Nat := ⟨0⟩\nend Demo\n"
    decls_inst = strict_scan(pub_inst_src)
    require(decls_inst == [{"kind": "instance", "name": "Demo.instDemoNat"}], decls_inst)
    require(normalized_legacy_scan(pub_inst_src)["declarations"] == decls_inst, "legacy/strict mismatch on public instance")
    audit_environment(f"ENV_CONST\tDemo.instDemoNat\t[]\ttrue\ttrue\tfalse\nENV_AUDIT_DONE COUNT=1\n", decls_inst)

    eq_src = "namespace Evil\npublic theorem foo.eq_1 : True := trivial\nend Evil\n"
    decls_eq = strict_scan(eq_src)
    require(decls_eq == [{"kind": "theorem", "name": "Evil.foo.eq_1"}], decls_eq)
    require(normalized_legacy_scan(eq_src)["declarations"] == decls_eq, "legacy/strict mismatch on public .eq_1")
    audit_environment(f"ENV_CONST\tEvil.foo.eq_1\t[]\tfalse\ttrue\tfalse\nENV_AUDIT_DONE COUNT=1\n", decls_eq)

    ok_reg = [{"kind": "theorem", "name": f"Becoming.{TARGET}.ok"}]
    for bad_env in [
        f"ENV_CONST\tBecoming.{TARGET}.ok\t[]\tfalse\ttrue\tfalse\nENV_CONST\tEvil.foo.eq_1\t[]\tfalse\ttrue\tfalse\nENV_AUDIT_DONE COUNT=2\n",
        f"ENV_CONST\tBecoming.{TARGET}.ok\t[]\tfalse\ttrue\tfalse\nENV_CONST\tEvil.foo.eq_1\t[]\tfalse\tfalse\tfalse\nENV_AUDIT_DONE COUNT=2\n",
        f"ENV_CONST\tBecoming.{TARGET}.ok\t[]\tfalse\ttrue\tfalse\nENV_CONST\tBecoming.{TARGET}.instHidden\t[]\ttrue\ttrue\tfalse\nENV_AUDIT_DONE COUNT=2\n",
    ]:
        rejected = False
        try:
            audit_environment(bad_env, ok_reg)
        except ValueError:
            rejected = True
        require(rejected, ("Expected EnvAudit rejection", bad_env))
    audit_environment(
        f"ENV_CONST\tBecoming.{TARGET}.ok\t[]\tfalse\ttrue\tfalse\n"
        f"ENV_CONST\tImpMod.impRec.eq_1\t[]\tfalse\tfalse\ttrue\nENV_AUDIT_DONE COUNT=2\n",
        ok_reg,
    )


def closure(index):
    order, seen = [], set()

    def visit(name):
        if name in seen or name.split(".")[0] in EXTERNAL:
            return
        paths = index.get(name, [])
        require(len(paths) == 1, (name, [str(p) for p in paths]))
        for dependency in core.imports_of(paths[0].read_bytes()):
            visit(dependency)
        seen.add(name)
        order.append(name)

    visit(TARGET)
    return order


def shown(path):
    return str(path.relative_to(HERE)) if HERE in path.parents else str(path)


def mathlib_path():
    project = Path(os.environ.get("SYSTEMS_MATHLIB_PROJECT", str(Path.home() / "repos/生生不息")))
    manifest = json.loads((project / "lake-manifest.json").read_text())
    packages = project / manifest.get("packagesDir", ".lake/packages")
    require(next(p for p in manifest["packages"] if p["name"] == "mathlib")["rev"] == MATHLIB_REVISION,
            "Mathlib revision mismatch in lake-manifest.json")
    require(subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=packages / "mathlib",
                                    text=True).strip() == MATHLIB_REVISION,
            "Mathlib git HEAD mismatch")
    require((packages / "mathlib/lean-toolchain").read_text().strip() == TOOLCHAIN,
            "Mathlib lean-toolchain mismatch")
    return [p / ".lake/build/lib/lean" for p in sorted(packages.iterdir())
            if (p / ".lake/build/lib/lean").is_dir()]


def main():
    require(TOOLCHAIN_FILE.is_file() and TOOLCHAIN_FILE.read_text().strip() == TOOLCHAIN,
            "Missing or mismatched lean-toolchain")
    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S.%fZ")
    receipt_path, runs = core.output_paths(RECEIPT, RETAINED)
    retained = runs / stamp
    retained.mkdir(parents=True, exist_ok=False)
    index = core.module_index()
    order = closure(index)
    paths = {name: index[name][0] for name in order}
    sources = {name: paths[name].read_bytes() for name in order}
    helper_paths = [
        Path(__file__).resolve(),
        LEAN_ROOT / "becoming/check_becoming.py",
        LEAN_ROOT / "universal-ethics/generative-capacity/check.py",
    ]
    helpers = {p.name: p.read_bytes() for p in helper_paths}
    digest = core.audit_support.digest
    runner_id = digest(json.dumps({
        "checker": digest(helpers[Path(__file__).name]),
        "check_becoming": digest(helpers["check_becoming.py"]),
        "scanner": digest(helpers["check.py"]),
        "core_runner": core.RUNNER,
    }, sort_keys=True).encode())
    commit, held = core.held_in_main({**{p: helpers[p.name] for p in helper_paths},
                                      **{paths[name]: sources[name] for name in order}})
    copied = {p.name: helpers[p.name] for p in helper_paths if p not in held}
    copied.update({name + ".lean": sources[name] for name in order if paths[name] not in held})
    for name, data in copied.items():
        (retained / name).write_bytes(data)
    receipt = {
        "status": "checking", "utc": stamp, "toolchain": TOOLCHAIN,
        "mathlib_revision": MATHLIB_REVISION,
        "retained_run": shown(retained),
        "bridge_module": TARGET, "compile_order": order,
        "source_paths": {name: str(paths[name].relative_to(LEAN_ROOT)) for name in order},
        "source_sha256": {name: digest(data) for name in order for data in [sources[name]]},
        "checker_sha256": {name: digest(data) for name, data in helpers.items()},
        "runner_sha256": runner_id,
        "source_commit": {"main": commit, "copied": sorted(copied)},
        "scope": SCOPE,
    }
    steps = receipt["lean_steps"] = {"cache": str(core.CACHE), "fresh": core.FRESH, "ran": [], "reused": {}, "keys": {}}
    try:
        require(TARGET not in core.closure(index, core.CORE), "the core imports the bridge")
        receipts = core.passed_receipts(exclude=(RECEIPT, RETAINED, receipt_path, runs))
        matches = {}
        for name in order[:-1]:
            found = core.receipts_for(name, paths[name], receipt["source_sha256"][name], receipts)
            require(bool(found), ("module has no passed receipt for its current bytes", name))
            matches[name] = found
        receipt["inherited_receipts"] = matches
        regression_self_test()
        src_text = sources[TARGET].decode()
        registry = strict_scan(src_text)
        legacy_scan = normalized_legacy_scan(src_text)
        require(not legacy_scan["private"] and not legacy_scan["unnamed_instances"],
                ("unaudited declarations in bridge", legacy_scan["private"], legacy_scan["unnamed_instances"]))
        require(legacy_scan["declarations"] == registry, "Scanner mismatch between strict_scan and legacy scanner")
        market = {
            item["name"]: sorted(set(core.name_words(item["name"])) & core.MARKET_WORDS)
            for item in registry
            if item["name"] not in core.MARKET_ALLOWED and set(core.name_words(item["name"])) & core.MARKET_WORDS
        }
        require(not market, ("disallowed market words in declaration names", market))
        receipt["lean_binary_sha256"] = digest(LEAN.read_bytes())
        context = [TOOLCHAIN, receipt["lean_binary_sha256"], MATHLIB_REVISION, runner_id]
        keys = core.module_keys(context, sources, order)
        origin = {"utc": stamp, "retained": str(retained)}
        with tempfile.TemporaryDirectory(prefix="moving-feature-cone-") as scratch:
            work = Path(scratch)
            env = {**os.environ, "LEAN_PATH": ":".join([str(work)] + [str(p) for p in mathlib_path()])}

            def accept(log, driver, output):
                (retained / log).write_text(output)
                if driver:
                    (retained / driver).write_bytes((work / driver).read_bytes())
                require(not re.search(r"\b(?:error|warning):", output), output)
                return output

            def run(args, log, key=None, outputs=(), driver=None):
                outputs = [work / output for output in outputs]
                if key:
                    steps["keys"][log] = key
                found = core.reuse(key, outputs, runner=runner_id) if key else None
                if found:
                    output, steps["reused"][log] = found
                    return accept(log, driver, output)
                with core.step_lock(key) if key else nullcontext(lambda: None) as beat:
                    found = core.reuse(key, outputs, runner=runner_id) if key else None
                    if found:
                        output, steps["reused"][log] = found
                        return accept(log, driver, output)
                    with core.lean_slot(beat):
                        p = subprocess.run([str(LEAN)] + args, cwd=work, env=env, text=True,
                                           stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=TIMEOUT)
                    output = accept(log, driver, p.stdout)
                    require(p.returncode == 0, output)
                    steps["ran"].append(log)
                    if key:
                        core.store(key, outputs, output, origin, runner=runner_id)
                    return output

            receipt["lean_version"] = run(["--version"], "version.log").strip()
            require(
                re.match(r"^Lean \(version 4\.30\.0-rc2(?:,|\)|\s|$)", receipt["lean_version"]) is not None,
                receipt["lean_version"],
            )
            for name, data in sources.items():
                target = work / core.source_file(name)
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_bytes(data)
            audit = f"import {TARGET}\n" + "".join(f"#print axioms {d['name']}\n" for d in registry)
            signatures = f"import {TARGET}\n" + "".join(
                f"#check @{d['name']}\n" for d in registry if d["kind"] == "theorem")
            env_audit = (
                f"import Lean\nimport {TARGET}\nopen Lean Elab Command\n\n"
                f"#eval show CommandElabM Unit from do\n"
                f"  let env ← getEnv\n"
                f"  let some idx := env.getModuleIdx? `{TARGET} | throwError \"missing module\"\n"
                f"  let mut count : Nat := 0\n"
                f"  for (n, _) in env.constants.map₁.toList do\n"
                f"    if env.getModuleIdxFor? n == some idx then\n"
                f"      count := count + 1\n"
                f"      let axs ← liftCoreM <| Lean.collectAxioms n\n"
                f"      let isInst ← liftCoreM <| Lean.Meta.isInstance n\n"
                f"      let dr ← liftCoreM <| findDeclarationRanges? n\n"
                f"      let eqStemImp := match env.getModuleIdxFor? n.getPrefix with | some pidx => pidx != idx | none => false\n"
                f"      IO.println s!\"ENV_CONST\\t{{n}}\\t{{axs.toList}}\\t{{isInst}}\\t{{dr.isSome}}\\t{{eqStemImp}}\"\n"
                f"      if let some si := getStructureInfo? env n then\n"
                f"        IO.println s!\"ENV_STRUCT\\t{{n}}\\t{{si.fieldNames.toList}}\"\n"
                f"  IO.println s!\"ENV_AUDIT_DONE COUNT={{count}}\"\n"
            )
            for label, text in [("AxiomAudit", audit), ("Signatures", signatures), ("EnvAudit", env_audit)]:
                (work / (TARGET + label + ".lean")).write_text(text)

            def compile_step(name):
                olean = core.source_file(name)[:-5] + ".olean"
                return lambda: run(["-o", olean, core.source_file(name)], name + ".log", key=keys[name],
                                   outputs=[olean])

            def driver_step(label, text):
                driver = TARGET + label + ".lean"
                return lambda: run([driver], TARGET + label + ".log",
                                   key=core.step_key(context, driver, text.encode(), keys), driver=driver)

            tasks = {"compile " + name: (["compile " + m for m in core.imports_of(sources[name]) if m in keys],
                                         compile_step(name)) for name in order}
            tasks["audit"] = (["compile " + TARGET], driver_step("AxiomAudit", audit))
            tasks["signatures"] = (["compile " + TARGET], driver_step("Signatures", signatures))
            tasks["env_audit"] = (["compile " + TARGET], driver_step("EnvAudit", env_audit))
            try:
                results_map = core.run_graph(tasks)
                output = results_map["audit"]
                env_output = results_map["env_audit"]
            finally:
                core.in_serial_order(steps, ["version.log"] + [name + ".log" for name in order]
                                     + [TARGET + "AxiomAudit.log", TARGET + "Signatures.log", TARGET + "EnvAudit.log"])
        dependencies = {}
        for item in registry:
            name = item["name"]
            if f"'{name}' does not depend on any axioms" in output:
                dependencies[name] = []
                continue
            found = re.search(r"'" + re.escape(name) + r"' depends on axioms: \[([^\]]*)\]", output)
            require(found is not None, (name, output))
            axioms = sorted(a.strip() for a in found.group(1).split(",") if a.strip())
            require(set(axioms) <= STANDARD_AXIOMS, (name, axioms))
            dependencies[name] = axioms
        env_summary = audit_environment(env_output, registry)
        receipt["environment_audit"] = env_summary
        receipt["source_unchanged_during_check"] = all(
            paths[name].read_bytes() == data for name, data in sources.items())
        require(receipt["source_unchanged_during_check"], "Source changed; only snapshot checked")
        receipt["modules"] = [{
            "module": TARGET, "layer": "periphery",
            "theorems": sum(d["kind"] == "theorem" for d in registry),
            "declarations": registry, "axiom_dependencies": dependencies,
            "environment_constants": env_summary["module_constants"],
            "kernel_checked": True,
        }]
        receipt["artifact_sha256"] = {
            p.name: digest(p.read_bytes()) for p in sorted(retained.iterdir()) if p.is_file()}
        receipt["status"] = "passed"
    except Exception as error:
        receipt["status"] = "failed"
        receipt["error"] = str(error)
        raise
    finally:
        serialized = json.dumps(receipt, indent=2, ensure_ascii=False) + "\n"
        (retained / "verification.json").write_text(serialized)
        receipt_path.write_text(serialized)
    print(json.dumps({"status": receipt["status"], "theorems": receipt["modules"][0]["theorems"],
                      "declaration_audits": len(registry),
                      "environment_constants": env_summary["module_constants"],
                      "axioms": sorted({a for d in receipt["modules"][0]["axiom_dependencies"].values() for a in d}),
                      "inherited_modules": len(order) - 1,
                      "lean_steps_run": len(steps["ran"]), "lean_steps_reused": len(steps["reused"]),
                      "receipt": str(receipt_path)}))


if __name__ == "__main__":
    main()
