#!/usr/bin/env python3
"""Check the Mathlib periphery module `ObservationalFidelity`.

AI-written (Wave U6, 24 November 2026).

`ObservationalFidelity` imports `AlignmentReals`, `BecomingReals`, and `Becoming.OplaxHistory`
(plus its transitive `Becoming.*` core closure), compiled with Lean 4.30.0-rc2 against the pinned
Mathlib (`SYSTEMS_MATHLIB_PROJECT`, default `~/repos/生生不息`). Every transitive dependency must
already match a passed receipt. The module's own declarations may depend only on Lean's three
standard axioms (`propext`, `Classical.choice`, `Quot.sound`), with no `sorryAx`, `private`,
unnamed `instance`s, `lemma`, `class`, or forbidden market words in declaration names.
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

TARGET = "ObservationalFidelity"
RECEIPT = HERE / "observational-fidelity-verification.json"
RETAINED = HERE / "observational-fidelity-checks"
TOOLCHAIN = "leanprover/lean4:v4.30.0-rc2"
LEAN = Path.home() / ".elan/toolchains/leanprover--lean4---v4.30.0-rc2/bin/lean"
MATHLIB_REVISION = "ea11ccc0c5c7c4c562742e918fe2e0b2814a58aa"
EXTERNAL = {"Init", "Std", "Lean", "Mathlib"}
STANDARD_AXIOMS = {"propext", "Classical.choice", "Quot.sound"}
TIMEOUT = int(os.environ.get("LEAN_TIMEOUT", "900"))

SCOPE = (
    "On ObservationalFidelity, joining WenHeHua (v7 Appendix G / v9 formal/61) over Mathlib's reals "
    "to AlignmentReals, BecomingReals, and Becoming.OplaxHistory: (1) finite probability distributions "
    "FinDist, pushforward, total variation tvDist, data-processing tvDist_pushforward_le, exact query-image "
    "TV blindness floor optimal_query_tv_floor (lower bound + constructive achievement under [Nonempty U]), "
    "and empty_source_infeasible under IsEmpty U; (2) coarsening_tv_mono, macro_refinement_tv_mono, and "
    "zero_tv_does_not_prevent_fiber_viability_split over Becoming.OplaxHistory.C2CoupledAlignmentWitness; "
    "(3) 3-way multi-query convex feasibility separation (per_query_not_implies_joint_marginal and "
    "joint_marginal_not_implies_joint_dist); (4) finite Markov kernels FinKernel/compKernel/"
    "tensorKernel, sequential_kernel_tv_bound, independent_tensor_tv_bound, and "
    "three_regime_error_contrast joining linear open-loop TV growth, contractive closed-loop tubes via "
    "AlignmentReals.metricSlack and BecomingReals.iterVar_eq_metricSlack, and coupled-phase/concurrent "
    "reserve breakdown via Becoming.OplaxHistory; and (5) oplax rowDefect, optimal_floor_le_rowDefect, "
    "Dobrushin kernel contraction (tvDist_pushKernel_dobrushin, tvDist_pushKernel_dobrushin_step), "
    "literal AlignmentReals.MetricLaxSim kernel instantiation (kernelMetricLaxSim) yielding derived "
    "iterated bounds and Viability.Kernel tube transfer (tvDist_pushKernel_iter_bound, "
    "kernel_contraction_tube_via_metricLaxSim, three_regime_kernel_contrast), [0,1]-bounded "
    "viability_risk_transfer_bound and fiber_split_readout_floor, sharp attainment "
    "(sharp_oplax_dobrushin_attainment on Bool), and closed-loop feedback control "
    "(feedback_destroys_openloop_contraction)."
)


def closure(index):
    order, seen = [], set()

    def visit(name):
        if name in seen or name.split(".")[0] in EXTERNAL:
            return
        paths = index.get(name, [])
        assert len(paths) == 1, (name, [str(p) for p in paths])
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
    assert next(p for p in manifest["packages"] if p["name"] == "mathlib")["rev"] == MATHLIB_REVISION
    assert subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=packages / "mathlib",
                                   text=True).strip() == MATHLIB_REVISION
    assert (packages / "mathlib/lean-toolchain").read_text().strip() == TOOLCHAIN
    return [p / ".lake/build/lib/lean" for p in sorted(packages.iterdir())
            if (p / ".lake/build/lib/lean").is_dir()]


def main():
    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S.%fZ")
    receipt_path, runs = core.output_paths(RECEIPT, RETAINED)
    retained = runs / stamp
    retained.mkdir(parents=True, exist_ok=False)
    index = core.module_index()
    order = closure(index)
    paths = {name: index[name][0] for name in order}
    sources = {name: paths[name].read_bytes() for name in order}
    helper_paths = [Path(__file__).resolve(), LEAN_ROOT / "becoming/check_becoming.py"]
    helpers = {p.name: p.read_bytes() for p in helper_paths}
    commit, held = core.held_in_main({**{p: helpers[p.name] for p in helper_paths},
                                      **{paths[name]: sources[name] for name in order}})
    copied = {p.name: helpers[p.name] for p in helper_paths if p not in held}
    copied.update({name + ".lean": sources[name] for name in order if paths[name] not in held})
    for name, data in copied.items():
        (retained / name).write_bytes(data)
    digest = core.audit_support.digest
    receipt = {
        "status": "checking", "utc": stamp, "toolchain": TOOLCHAIN,
        "mathlib_revision": MATHLIB_REVISION,
        "retained_run": shown(retained),
        "bridge_module": TARGET, "compile_order": order,
        "source_paths": {name: str(paths[name].relative_to(LEAN_ROOT)) for name in order},
        "source_sha256": {name: digest(data) for name in order for data in [sources[name]]},
        "checker_sha256": {name: digest(data) for name, data in helpers.items()},
        "source_commit": {"main": commit, "copied": sorted(copied)},
        "scope": SCOPE,
    }
    steps = receipt["lean_steps"] = {"cache": str(core.CACHE), "fresh": core.FRESH, "ran": [], "reused": {}, "keys": {}}
    try:
        assert TARGET not in core.closure(index, core.CORE), "the core imports the bridge"
        receipts = core.passed_receipts(exclude=(RECEIPT, RETAINED, receipt_path, runs))
        matches = {}
        for name in order[:-1]:
            found = core.receipts_for(name, paths[name], receipt["source_sha256"][name], receipts)
            assert found, ("module has no passed receipt for its current bytes", name)
            matches[name] = found
        receipt["inherited_receipts"] = matches
        code = core.audit_support.code_only(sources[TARGET].decode())
        assert not re.search(r"\b(?:lemma|class)\b", code), "disallowed declaration keyword (lemma/class) in source"
        scan = core.scanned(sources[TARGET])
        assert not scan["private"] and not scan["unnamed_instances"], (
            "unaudited declarations in bridge", scan["private"], scan["unnamed_instances"])
        registry = scan["declarations"]
        market = {
            item["name"]: sorted(set(core.name_words(item["name"])) & core.MARKET_WORDS)
            for item in registry
            if item["name"] not in core.MARKET_ALLOWED and set(core.name_words(item["name"])) & core.MARKET_WORDS
        }
        assert not market, ("disallowed market words in declaration names", market)
        receipt["lean_binary_sha256"] = digest(LEAN.read_bytes())
        context = [TOOLCHAIN, receipt["lean_binary_sha256"], MATHLIB_REVISION]
        keys = core.module_keys(context, sources, order)
        origin = {"utc": stamp, "retained": str(retained)}
        with tempfile.TemporaryDirectory(prefix="observational-fidelity-") as scratch:
            work = Path(scratch)
            env = {**os.environ, "LEAN_PATH": ":".join([str(work)] + [str(p) for p in mathlib_path()])}

            def run(args, log, key=None, outputs=(), driver=None):
                outputs = [work / output for output in outputs]
                if key:
                    steps["keys"][log] = key
                found = core.reuse(key, outputs) if key else None
                if found:
                    output, steps["reused"][log] = found
                    return output
                with core.step_lock(key) if key else nullcontext(lambda: None) as beat:
                    found = core.reuse(key, outputs) if key else None
                    if found:
                        output, steps["reused"][log] = found
                        return output
                    if driver:
                        (retained / driver).write_bytes((work / driver).read_bytes())
                    with core.lean_slot(beat):
                        p = subprocess.run([str(LEAN)] + args, cwd=work, env=env, text=True,
                                           stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=TIMEOUT)
                    (retained / log).write_text(p.stdout)
                    assert p.returncode == 0, p.stdout
                    assert not re.search(r"\b(?:error|warning):", p.stdout), p.stdout
                    steps["ran"].append(log)
                    if key:
                        core.store(key, outputs, p.stdout, origin)
                    return p.stdout

            receipt["lean_version"] = run(["--version"], "version.log").strip()
            assert "version 4.30.0-rc2" in receipt["lean_version"]
            for name, data in sources.items():
                target = work / core.source_file(name)
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_bytes(data)
            audit = f"import {TARGET}\n" + "".join(f"#print axioms {d['name']}\n" for d in registry)
            signatures = f"import {TARGET}\n" + "".join(
                f"#check @{d['name']}\n" for d in registry if d["kind"] == "theorem")
            for label, text in [("AxiomAudit", audit), ("Signatures", signatures)]:
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
            try:
                output = core.run_graph(tasks)["audit"]
            finally:
                core.in_serial_order(steps, ["version.log"] + [name + ".log" for name in order]
                                     + [TARGET + "AxiomAudit.log", TARGET + "Signatures.log"])
        dependencies = {}
        for item in registry:
            name = item["name"]
            if f"'{name}' does not depend on any axioms" in output:
                dependencies[name] = []
                continue
            found = re.search(r"'" + re.escape(name) + r"' depends on axioms: \[([^\]]*)\]", output)
            assert found, (name, output)
            axioms = sorted(a.strip() for a in found.group(1).split(",") if a.strip())
            assert set(axioms) <= STANDARD_AXIOMS, (name, axioms)
            dependencies[name] = axioms
        receipt["source_unchanged_during_check"] = all(
            paths[name].read_bytes() == data for name, data in sources.items())
        assert receipt["source_unchanged_during_check"], "Source changed; only snapshot checked"
        receipt["modules"] = [{
            "module": TARGET, "layer": "periphery",
            "theorems": sum(d["kind"] == "theorem" for d in registry),
            "declarations": registry, "axiom_dependencies": dependencies, "kernel_checked": True,
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
                      "axioms": sorted({a for d in receipt["modules"][0]["axiom_dependencies"].values() for a in d}),
                      "inherited_modules": len(order) - 1,
                      "lean_steps_run": len(steps["ran"]), "lean_steps_reused": len(steps["reused"]),
                      "receipt": str(receipt_path)}))


if __name__ == "__main__":
    main()
