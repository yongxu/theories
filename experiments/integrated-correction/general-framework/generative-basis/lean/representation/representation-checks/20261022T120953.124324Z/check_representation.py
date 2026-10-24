#!/usr/bin/env python3
"""Check the periphery module on what discrete steps and whole amounts represent.

`Representation` imports the core's `Becoming.Frequency` and Mathlib's reals, integrals and limits, so it is
compiled with Lean 4.30.0-rc2 against the installed Mathlib (`SYSTEMS_MATHLIB_PROJECT`, default
`~/repos/生生不息`). Module resolution, declaration scanning and passed-receipt
matching are those of the core checker. Every other module in the closure must
match a passed receipt. The module's own declarations may depend on Lean's three standard
axioms (`propext`, `Classical.choice`, `Quot.sound`), through Mathlib; the receipt reports
each declaration's axioms, and any other axiom (`sorryAx` among them) fails the run.
The core does not import this module. Lean steps are reused as in the core checker,
keyed also by the Mathlib revision, and run concurrently (`BECOMING_JOBS`);
`BECOMING_FRESH=1` runs every step. As in the core checker, the run folder keeps the
receipt, the drivers and logs of the steps that ran, and a copy of each file `main` does
not hold byte for byte.
"""
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

TARGET = "Representation"
RECEIPT = HERE / "representation-verification.json"
RETAINED = HERE / "representation-checks"
TOOLCHAIN = "leanprover/lean4:v4.30.0-rc2"
LEAN = Path.home() / ".elan/toolchains/leanprover--lean4---v4.30.0-rc2/bin/lean"
MATHLIB_REVISION = "ea11ccc0c5c7c4c562742e918fe2e0b2814a58aa"
EXTERNAL = {"Init", "Std", "Lean", "Mathlib"}
# The axioms a declaration may depend on through Mathlib; any other fails the run.
STANDARD_AXIOMS = {"propext", "Classical.choice", "Quot.sound"}
# Seconds allowed for each Lean run; a heavily loaded machine may need more.
TIMEOUT = int(os.environ.get("LEAN_TIMEOUT", "900"))

SCOPE = (
    "Real-valued time and real amounts against the Becoming core's discrete steps and whole amounts: a course "
    "whose levels change at the rate given less taken, its rates summable, balances over every stretch and so "
    "across every step of any reading at instants, coarser steps summing the finer, while a balanced course read "
    "at the whole instants can stand still at every step and change between them; no reading into the whole "
    "numbers keeps the order of an endless fall, real amounts fall so, and multiples of a unit are read in whole "
    "numbers; a halving level is new at every step without gain, while finitely many conditions new by at least "
    "a least separation exceed every bound; a held loop of any positive real strength carries D (1 + r) ^ count, "
    "the core's self-loop its case, and is bounded by a polynomial exactly where two to the count is, while a "
    "damped loop coupling at every step stays bounded exactly where its factor and strength add to at most one; "
    "for the step of a web of conditions in any normed ring, what it carries vanishes exactly where its rate, the "
    "least norm of a power to the inverse of the power, is below one and runs away where above one, one "
    "condition's rate being the absolute value of factor plus strength; a held web coupling at some steps carries "
    "(1 + S) ^ count and, where the rate of 1 + S is above one, is bounded by a polynomial exactly where two to the "
    "count is; a damped web coupling at some steps carries a ^ (t - count) (a + S) ^ count and vanishes where "
    "a ^ (1 - theta) B ^ theta < 1, theta bounding the share of steps that couple and B the coupled step's norm. "
    "That an actual becoming's rates, amounts and loops are of these forms is a correspondence, not checked."
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


def passed_receipts():
    receipts = []
    for path in LEAN_ROOT.rglob("*.json"):
        if path == RECEIPT or RETAINED in path.parents:
            continue
        text = path.read_text(errors="replace")
        if '"passed"' in text:
            receipts.append((str(path.relative_to(LEAN_ROOT)), text))
    return receipts


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
    retained = RETAINED / stamp
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
        "retained_run": str(retained.relative_to(HERE)),
        "bridge_module": TARGET, "compile_order": order,
        "source_paths": {name: str(paths[name].relative_to(LEAN_ROOT)) for name in order},
        "source_sha256": {name: digest(data) for name, data in sources.items()},
        "checker_sha256": {name: digest(data) for name, data in helpers.items()},
        # Files main holds byte for byte are named by this commit; the rest are copied here.
        "source_commit": {"main": commit, "copied": sorted(copied)},
        "scope": SCOPE,
    }
    # A reused step passed in the named run with the same binary and identical inputs; its log
    # stays in the cache under its key. Drivers and logs of the steps that ran are kept here.
    steps = receipt["lean_steps"] = {"cache": str(core.CACHE), "fresh": core.FRESH, "ran": [], "reused": {}, "keys": {}}
    try:
        assert TARGET not in core.closure(index, core.CORE), "the core imports the bridge"
        receipts = passed_receipts()
        matches = {}
        for name in order[:-1]:
            found = sorted(path for path, text in receipts if receipt["source_sha256"][name] in text)
            assert found, ("module has no passed receipt for its current bytes", name)
            matches[name] = found
        receipt["inherited_receipts"] = matches
        registry = core.declarations(sources[TARGET])
        receipt["lean_binary_sha256"] = digest(LEAN.read_bytes())
        context = [TOOLCHAIN, receipt["lean_binary_sha256"], MATHLIB_REVISION]
        keys = core.module_keys(context, sources, order)
        origin = {"utc": stamp, "retained": str(retained)}
        with tempfile.TemporaryDirectory(prefix="representation-") as scratch:
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
                if driver:
                    (retained / driver).write_bytes((work / driver).read_bytes())
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

            # Steps run concurrently as in the core checker, each once the compiles of the
            # modules it imports have passed; the receipt lists them in one-at-a-time order.
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
        RECEIPT.write_text(serialized)
    print(json.dumps({"status": receipt["status"], "theorems": receipt["modules"][0]["theorems"],
                      "declaration_audits": len(registry),
                      "axioms": sorted({a for d in receipt["modules"][0]["axiom_dependencies"].values() for a in d}),
                      "inherited_modules": len(order) - 1,
                      "lean_steps_run": len(steps["ran"]), "lean_steps_reused": len(steps["reused"]),
                      "receipt": str(RECEIPT)}))


if __name__ == "__main__":
    main()
