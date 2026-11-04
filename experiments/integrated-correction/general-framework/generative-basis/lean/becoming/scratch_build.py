#!/usr/bin/env python3
"""Build changed or new modules in scratch, sharing the checker's cache.

usage: python3 -B scratch_build.py TREE [MODULE ...]

TREE holds the modules a session changed or added, at their package paths
(`Becoming/Foo.lean` for `Becoming.Foo`; a module the checker finds by file name, such as
`GenerativeCore`, at TREE's top level). Every other module comes from this checkout.
MODULE names the modules to build and audit; by default every module in TREE.

The import closure is compiled in dependency order with the checker's Lean (`LEAN`, else
`elan which lean` in the package folder, else elan's default path), toolchain and steps:
they come from the checker's own plan (`check_becoming.lean_plan`) and run through its
runner (`check_becoming.lean_step`), concurrently as in the checker (`BECOMING_JOBS`), each
Lean process in one of the machine's slots. A step whose inputs match a step that passed is
restored from the shared cache instead of run; a step that passes (exit 0, no error or
warning) is stored there, so the landing run and other sessions reuse it. Each named module,
once compiled, has its declarations' axioms printed and, if the checker checks it, its
theorems' statements; a named module of the core closure is compiled again from Lean's
prelude with the modules it imports, as the checker does. Every such step is the checker's
own, so the checker reuses it. This is a working build, not a receipt: nothing is retained,
and the environment audit and the controls run only in the checker. Writes only into
TREE/.build and the cache.
"""
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import re
import sys
import threading

sys.dont_write_bytecode = True
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import check_becoming as cb  # noqa: E402

# Seconds allowed for each Lean run; a heavily loaded machine may need more.
TIMEOUT = int(os.environ.get("LEAN_TIMEOUT", "1800"))


def overlay(tree):
    """The modules in TREE by name, read from their paths below it."""
    found = {}
    for path in sorted(tree.rglob("*.lean")):
        relative = path.relative_to(tree)
        if not any(part.startswith(".") for part in relative.parts):
            found[".".join(relative.with_suffix("").parts)] = path
    return found


def main():
    if len(sys.argv) < 2 or sys.argv[1] in ("-h", "--help"):
        print(__doc__)
        return 2
    tree = Path(sys.argv[1]).resolve()
    mine = overlay(tree)
    targets = sys.argv[2:] or sorted(mine)
    assert targets, ("no modules to build in", str(tree))
    index = cb.module_index()
    for name, path in mine.items():
        index[name] = [path]
    order = cb.closure(index, targets)
    sources = {name: index[name][0].read_bytes() for name in order}
    # The checker's Lean: `LEAN`, `elan which lean` in the package folder, or the default path.
    command, binary, _ = cb.resolve_lean()
    context = [cb.audit_support.TOOLCHAIN, cb.audit_support.digest(binary.read_bytes())]
    keys = cb.module_keys(context, sources, order)
    build = tree / ".build"
    origin = {"utc": datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S.%fZ"),
              "retained": "scratch build, not retained: " + str(tree)}
    report = {"tree": str(tree), "modules": len(order), "ran": [], "reused": 0, "unclean": [], "audits": {},
              "seconds": {}}
    registries = {name: cb.declarations(sources[name]) for name in targets}
    # Named modules the checker's core closure holds (with TREE's modules in place) are compiled from the
    # prelude too, each with the modules it imports.
    core = set(cb.closure(index, cb.CORE))
    plan, files = cb.lean_plan(context, sources, keys, registries, order, audited=targets,
                               signed=[name for name in targets if name in cb.CHECKED],
                               prelude=cb.closure(index, [name for name in targets if name in core]))
    labels = [step.log[:-4] for step in plan]

    lock = threading.Lock()

    class Failed(Exception):
        pass

    def checked(step):
        """Restore a passed step or run it; a step that fails stops the build, one with an error or
        warning in its log is reported and not stored."""
        def action():
            label = step.log[:-4]
            outcome = cb.lean_step(command, step, build, origin, TIMEOUT)
            with lock:
                if outcome.reused_from:
                    report["reused"] += 1
                    return outcome.output
                report["ran"].append(label)
                report["seconds"][label] = outcome.seconds
                if not outcome.passed:
                    print(outcome.output[-8000:], file=sys.stderr)
                if outcome.returncode != 0:
                    raise Failed(label)
                if not outcome.passed:
                    report["unclean"].append(label)
            return outcome.output
        return action

    cb.write_files(build, files)
    # Steps run concurrently as in the checker (`BECOMING_JOBS`), each once the compiles of the
    # modules it imports have passed; an audit waits for its module's compile.
    tasks = {step.task: (step.needs, checked(step)) for step in plan}
    try:
        outputs = cb.run_graph(tasks)
    except Failed as failure:
        report["failed"] = str(failure)
    report["ran"].sort(key=labels.index)
    report["unclean"].sort(key=labels.index)
    report["seconds"] = {label: report["seconds"][label] for label in report["ran"]}
    if "failed" in report:
        print(json.dumps(report, ensure_ascii=False, indent=2))
        return 1
    for name in targets:
        registry, output = registries[name], outputs["audit " + name]
        axioms = {}
        for item in registry:
            full = item["name"]
            if "'" + full + "' does not depend on any axioms" in output:
                continue
            match = re.search(r"'" + re.escape(full) + r"' depends on axioms:\s*\[([^]]*)\]", output)
            axioms[full] = [a.strip() for a in match[1].split(",") if a.strip()] if match else ["not reported"]
        report["audits"][name] = {
            "theorems": sum(item["kind"] == "theorem" for item in registry),
            "declarations": len(registry), "with_axioms": axioms}
    print(json.dumps(report, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
