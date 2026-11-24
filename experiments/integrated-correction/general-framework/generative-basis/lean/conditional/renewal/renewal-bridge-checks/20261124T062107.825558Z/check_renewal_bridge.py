#!/usr/bin/env python3
"""Check the peripheral RenewalBridge adapter joining Becoming.KeepableStep and RenewalConfigurations.

AI-written (Wave U5-C, 24 November 2026), modelled on becoming/check_fallible_inquiry.py.
The Becoming core never imports this bridge, and October's conditional/renewal/check.py and
conditional/renewal/verification.json remain untouched.

Shared module resolution, immutable inherited receipts (matched by module and sha256), cache
keys, declaration scanning, Lean binary resolution (`LEAN`, `elan which lean`, or the default
path), `BECOMING_OUT`, and concurrent step execution (`core.run_graph`, `core.lean_step`,
`core.lean_slot`) come from becoming/check_becoming.py.

Any dependency in the import closure lacking a passed receipt for its current bytes (e.g.
Depletion.lean after the I4c header comment) is compiled from source and axiom-audited directly
alongside RenewalBridge. Compile with Lean 4.29.1; retain exact signatures and every source
declaration's axiom report. Zero axioms are allowed (`ALLOWED_AXIOMS = set()`, Init-only).
"""
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import re
import sys
import tempfile
import threading
import time

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
LEAN_ROOT = HERE.parents[1]
sys.path.insert(0, str(LEAN_ROOT / "becoming"))
import check_becoming as core  # noqa: E402

TARGET = "RenewalBridge"
RECEIPT = HERE / "renewal-bridge-verification.json"
RETAINED = HERE / "renewal-bridge-checks"
TOOLCHAIN = "leanprover/lean4:v4.29.1"
EXTERNAL = {"Init", "Std", "Lean", "Mathlib"}
ALLOWED_AXIOMS = set()
# Seconds allowed for each Lean run; a heavily loaded machine may need more.
TIMEOUT = int(os.environ.get("LEAN_TIMEOUT", "900"))

SCOPE = (
    "RenewalBridge joins Becoming.KeepableStep and October's RenewalConfigurations over the one "
    "Process of GenerativeCore with zero Lean axioms (Init-only v4.29.1). It defines the exact "
    "field renamings historyRun and runHistory between History law and Run (channelProcess law) "
    "with definitional round-trip identities (runHistory_historyRun, historyRun_runHistory), proves "
    "renewable_iff_keepable without extra premises, and derives October's renewable_iff_step and "
    "renewability_not_generated as cases of keepable_step_iff and not_keepable_run (using "
    "dead_stays_dead without deciding liveness), checking statement identity against "
    "Generative.Conditional.Renewal by rfl (renewable_iff_step_same, "
    "renewability_not_generated_same). No physical identification or ethical appraisal is asserted."
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


def main():
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
    commit, held = core.held_in_main({
        **{p: helpers[p.name] for p in helper_paths},
        **{paths[name]: sources[name] for name in order},
    })
    copied = {p.name: helpers[p.name] for p in helper_paths if p not in held}
    copied.update({name + ".lean": sources[name] for name in order if paths[name] not in held})
    for name, data in copied.items():
        (retained / name).write_bytes(data)
    digest = core.audit_support.digest
    receipt = {
        "status": "checking",
        "utc": stamp,
        "toolchain": TOOLCHAIN,
        "retained_run": shown(retained),
        "bridge_module": TARGET,
        "compile_order": order,
        "source_paths": {name: str(paths[name].relative_to(LEAN_ROOT)) for name in order},
        "source_sha256": {name: digest(data) for name, data in sources.items()},
        "checker_sha256": {name: digest(data) for name, data in helpers.items()},
        # Files main holds byte for byte are named by this commit; the rest are copied here.
        "source_commit": {"main": commit, "copied": sorted(copied)},
        "scope": SCOPE,
    }
    steps = receipt["lean_steps"] = {
        "cache": str(core.CACHE),
        "fresh": core.FRESH,
        "ran": [],
        "reused": {},
        "keys": {},
        "seconds": {},
    }
    try:
        assert TARGET not in core.closure(index, core.CORE), "the core imports the bridge"
        receipts = core.passed_receipts(exclude=(RECEIPT, RETAINED, receipt_path, runs))
        matches = {}
        unreceipted = []
        for name in order[:-1]:
            found = core.receipts_for(name, paths[name], receipt["source_sha256"][name], receipts)
            if found:
                matches[name] = found
            else:
                unreceipted.append(name)
        receipt["inherited_receipts"] = matches
        receipt["unreceipted_dependencies"] = unreceipted

        audited = [TARGET] + unreceipted
        scans = {}
        for name in audited:
            code = core.audit_support.code_only(sources[name].decode())
            assert not re.search(r"\b(?:lemma|class)\b", code), (
                "disallowed declaration keyword (lemma/class) in source", name)
            s = core.scanned(sources[name])
            assert not s["private"] and not s["unnamed_instances"], (
                "unaudited declarations in source", name, s["private"], s["unnamed_instances"])
            market = {
                item["name"]: sorted(set(core.name_words(item["name"])) & core.MARKET_WORDS)
                for item in s["declarations"]
                if item["name"] not in core.MARKET_ALLOWED
                and set(core.name_words(item["name"])) & core.MARKET_WORDS
            }
            assert not market, ("market words in declarations", name, market)
            scans[name] = s
        registries = {name: scans[name]["declarations"] for name in audited}
        scan = scans[TARGET]
        # Not audited by name; empty for RenewalBridge.
        receipt["not_audited_by_name"] = {
            "private": [d["name"] for d in scan["private"]],
            "unnamed_instance_lines": scan["unnamed_instances"],
        }
        command, lean, receipt["lean_resolution"] = core.resolve_lean(HERE, TOOLCHAIN)
        receipt["lean_binary_sha256"] = digest(lean.read_bytes())
        context = [TOOLCHAIN, receipt["lean_binary_sha256"]]
        keys = core.module_keys(context, sources, order)
        origin = {"utc": stamp, "retained": str(retained)}
        steps_lock = threading.Lock()
        with tempfile.TemporaryDirectory(prefix="renewal-bridge-") as scratch:
            work = Path(scratch)

            def run(step):
                if step.key:
                    with steps_lock:
                        steps["keys"][step.log] = step.key
                keep = (lambda: (retained / step.driver).write_text(step.text)) if step.driver else None
                outcome = core.lean_step(command, step, work, origin, TIMEOUT, before=keep)
                if outcome.reused_from:
                    with steps_lock:
                        steps["reused"][step.log] = outcome.reused_from
                    return outcome.output
                (retained / step.log).write_text(outcome.output)
                assert outcome.returncode == 0, outcome.output
                assert not re.search(r"\b(?:error|warning):", outcome.output), outcome.output
                with steps_lock:
                    steps["ran"].append(step.log)
                    steps["seconds"][step.log] = outcome.seconds
                return outcome.output

            started = time.perf_counter()
            receipt["lean_version"] = run(
                core.Step("version", [], ["--version"], "version.log", "", None, [], None, None)
            ).strip()
            assert "version 4.29.1" in receipt["lean_version"], receipt["lean_version"]
            plan, files = core.lean_plan(
                context, sources, keys, registries, order, audited=audited, signed=audited)
            core.write_files(work, files)
            tasks = {step.task: (step.needs, lambda step=step: run(step)) for step in plan}
            sequence = ["version.log"] + [step.log for step in plan]
            try:
                outputs = core.run_graph(tasks)
            finally:
                core.in_serial_order(steps, sequence)
                steps["wall_seconds"] = round(time.perf_counter() - started, 3)

        all_deps = {}
        for mod in audited:
            output = outputs["audit " + mod]
            dependencies = {}
            for item in registries[mod]:
                name = item["name"]
                empty = f"'{name}' does not depend on any axioms" in output
                match = re.search(r"'" + re.escape(name) + r"' depends on axioms:\s*\[([^]]*)\]", output)
                assert empty or match, (mod, name, output)
                deps = [] if empty else [a.strip() for a in match[1].split(",") if a.strip()]
                assert set(deps) <= ALLOWED_AXIOMS, (mod, name, deps)
                dependencies[name] = deps
            all_deps[mod] = dependencies

        receipt["source_unchanged_during_check"] = all(
            paths[name].read_bytes() == data for name, data in sources.items())
        assert receipt["source_unchanged_during_check"], "Source changed; only snapshot checked"
        assert all(p.read_bytes() == helpers[p.name] for p in helper_paths), "Checker changed"
        assert digest(lean.read_bytes()) == receipt["lean_binary_sha256"], "Compiler changed"
        receipt["modules"] = [
            {
                "module": TARGET,
                "layer": "periphery bridge",
                "theorems": sum(d["kind"] == "theorem" for d in registries[TARGET]),
                "declarations": registries[TARGET],
                "axiom_dependencies": all_deps[TARGET],
                "kernel_checked": True,
            },
            *[
                {
                    "module": mod,
                    "layer": "unreceipted dependency (compiled and audited)",
                    "theorems": sum(d["kind"] == "theorem" for d in registries[mod]),
                    "declarations": registries[mod],
                    "axiom_dependencies": all_deps[mod],
                    "kernel_checked": True,
                }
                for mod in unreceipted
            ],
        ]
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
    print(json.dumps({
        "status": receipt["status"],
        "theorems": receipt["modules"][0]["theorems"],
        "declaration_audits": len(registries[TARGET]),
        "axioms": sorted({a for deps in all_deps[TARGET].values() for a in deps}),
        "inherited_modules": len(matches),
        "unreceipted_audited": unreceipted,
        "lean_steps_run": len(steps["ran"]),
        "lean_steps_reused": len(steps["reused"]),
        "lean": receipt["lean_resolution"],
        "receipt": str(receipt_path),
    }))


if __name__ == "__main__":
    main()
