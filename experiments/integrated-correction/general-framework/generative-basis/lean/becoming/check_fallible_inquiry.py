#!/usr/bin/env python3
"""Check the peripheral finite fallible inquiry adapter on the native Becoming spine.

The core never imports this adapter. Shared module resolution, immutable inherited
receipts (matched by module and sha256), cache keys, declaration scanning, the Lean binary
(`LEAN`, `elan which lean`, or the default path), `BECOMING_OUT` and the runner of each Lean
step (the cache, the step's lock and the machine's Lean slots) come from check_becoming. Compile
with Lean 4.29.1; retain exact signatures and every source declaration's axiom report.
Only propext and Quot.sound are allowed in this periphery, inherited from the finite
statistical proof. This check does not certify actual weights or universal ontology.
"""
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import re
import sys
import tempfile

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
LEAN_ROOT = HERE.parent
sys.path.insert(0, str(LEAN_ROOT / "becoming"))
import check_becoming as core  # noqa: E402

TARGET = "Becoming.FallibleInquiry"
RECEIPT = HERE / "fallible-inquiry-verification.json"
RETAINED = HERE / "fallible-inquiry-checks"
TOOLCHAIN = "leanprover/lean4:v4.29.1"
EXTERNAL = {"Init", "Std", "Lean", "Mathlib"}
# Seconds allowed for each Lean run; a heavily loaded machine may need more.
TIMEOUT = int(os.environ.get("LEAN_TIMEOUT", "900"))

SCOPE = (
    "P104 additionally composes TimedResponse deadline blindness with the existing finite "
    "discrimination bound. Under equal initial levels and prefix-local balance, common presence, "
    "past-registration response outside a time-indexed source and complete reading, commitment "
    "is at most paired error plus timely-route weight. A route decision is explicit for the "
    "weighted bound; total blindness gives exact equality without that decision. These added "
    "premises do not replace the historical structural or common-residual statements below. "
    "Native balanced courses with the same present formations and matching initial registered "
    "conditions outside responsive reach, governed outside the varying part by one supplied "
    "registration-dependent exchange law. A common reader factors through its complete past "
    "registration. Finite commitment is at most two error weights plus responsive-reach weight; "
    "quantitative reach uses an explicit decision. The blind case needs no decision and has "
    "exact equality. Native witnesses demonstrate a distinct reader receiving a signal and "
    "failure when a reachable signal is ignored. Actual target labels, paired weights, complete "
    "access and law correspondence are not checked; no full scientific foundation is proved. "
    "P94 tests balance by retaining the same native readout while omitting exchange, and composes "
    "the existing imbalance-as-relatum construction. The added residual either violates the "
    "unchanged response premise or belongs to the varying source. Common residual exchange, "
    "possibly nonzero, suffices for beyond-reach registration and answer equality; balance is "
    "its zero-residual special case. No least-condition theorem or new generalized quantitative "
    "bound is asserted. Full-core necessity is a revisable hypothesis, not a proof premise."
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


def main():
    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S.%fZ")
    receipt_path, runs = core.output_paths(RECEIPT, RETAINED)
    retained = runs / stamp
    retained.mkdir(parents=True, exist_ok=False)
    index = core.module_index()
    order = closure(index)
    paths = {name: index[name][0] for name in order}
    sources = {name: paths[name].read_bytes() for name in order}
    helper_paths = [Path(__file__).resolve(), LEAN_ROOT / "becoming/check_becoming.py", LEAN_ROOT / "universal-ethics/generative-capacity/check.py"]
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
        "retained_run": core.shown(retained),
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
    steps = receipt["lean_steps"] = {"cache": str(core.CACHE), "fresh": core.FRESH, "ran": [], "reused": {}, "keys": {},
                                     "seconds": {}}
    try:
        assert TARGET not in core.closure(index, core.CORE), "the core imports the bridge"
        receipts = core.passed_receipts(exclude=(RECEIPT, RETAINED, receipt_path, runs))
        matches = {}
        for name in order[:-1]:
            found = core.receipts_for(name, paths[name], receipt["source_sha256"][name], receipts)
            assert found, ("module has no passed receipt for its current bytes", name)
            matches[name] = found
        receipt["inherited_receipts"] = matches
        scan = core.scanned(sources[TARGET])
        registry = scan["declarations"]
        # Not audited by name (no environment audit runs here); empty for this adapter.
        receipt["not_audited_by_name"] = {"private": [d["name"] for d in scan["private"]],
                                          "unnamed_instance_lines": scan["unnamed_instances"]}
        command, lean, receipt["lean_resolution"] = core.resolve_lean(HERE, TOOLCHAIN)
        receipt["lean_binary_sha256"] = digest(lean.read_bytes())
        context = [TOOLCHAIN, receipt["lean_binary_sha256"]]
        keys = core.module_keys(context, sources, order)
        origin = {"utc": stamp, "retained": str(retained)}
        with tempfile.TemporaryDirectory(prefix="fallible-inquiry-") as scratch:
            work = Path(scratch)

            def run(step):
                # The checker's plan and runner: the cache, the step's lock and one of the machine's Lean slots.
                if step.key:
                    steps["keys"][step.log] = step.key
                keep = (lambda: (retained / step.driver).write_text(step.text)) if step.driver else None
                outcome = core.lean_step(command, step, work, origin, TIMEOUT, before=keep)
                if outcome.reused_from:
                    steps["reused"][step.log] = outcome.reused_from
                    return outcome.output
                (retained / step.log).write_text(outcome.output)
                assert outcome.returncode == 0, outcome.output
                assert not re.search(r"\b(?:error|warning):", outcome.output), outcome.output
                steps["ran"].append(step.log)
                steps["seconds"][step.log] = outcome.seconds
                return outcome.output

            receipt["lean_version"] = run(core.Step("version", [], ["--version"], "version.log", "", None, [],
                                                    None, None)).strip()
            assert "version 4.29.1" in receipt["lean_version"]
            # The closure's compiles, then the adapter's axiom audit and signatures, as the checker plans them.
            plan, files = core.lean_plan(context, sources, keys, {TARGET: registry}, order,
                                         audited=[TARGET], signed=[TARGET])
            core.write_files(work, files)
            outputs = {step.task: run(step) for step in plan}
            output = outputs["audit " + TARGET]
        dependencies = {}
        for item in registry:
            name = item["name"]
            empty = f"'{name}' does not depend on any axioms" in output
            match = re.search(r"'" + re.escape(name) + r"' depends on axioms:\s*\[([^]]*)\]", output)
            assert empty or match, (name, output)
            deps = [] if empty else [a.strip() for a in match[1].split(",") if a.strip()]
            assert set(deps) <= {"propext", "Quot.sound"}, (name, deps)
            dependencies[name] = deps
        receipt["source_unchanged_during_check"] = all(
            paths[name].read_bytes() == data for name, data in sources.items())
        assert receipt["source_unchanged_during_check"], "Source changed; only snapshot checked"
        assert all(p.read_bytes() == helpers[p.name] for p in helper_paths), "Checker changed"
        assert digest(lean.read_bytes()) == receipt["lean_binary_sha256"], "Compiler changed"
        receipt["modules"] = [{
            "module": TARGET, "layer": "periphery bridge",
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
                      "declaration_audits": len(registry), "axioms": sorted({a for deps in dependencies.values() for a in deps}),
                      "inherited_modules": len(order) - 1,
                      "lean_steps_run": len(steps["ran"]), "lean_steps_reused": len(steps["reused"]),
                      "lean": receipt["lean_resolution"], "receipt": str(receipt_path)}))


if __name__ == "__main__":
    main()
