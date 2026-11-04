#!/usr/bin/env python3
"""Time the core environment audit's driver against candidate drivers, on the same compiled modules.

usage: python3 -B measure_environment_audit.py [--bridge] DRIVER.lean ...

Each DRIVER is the text of an environment-audit driver with `{imports}` and `{modules}` where the checker
puts them (the checker's own ENVIRONMENT_AUDIT is run first, as `current`). The core closure's compiled
modules are restored from the checker's step cache by their keys, so nothing is compiled; a module whose
key is missing stops the run. Each driver runs once in that directory, and the script prints each one's wall
and CPU seconds and whether its output is byte for byte the current driver's.
"""
import json
import os
import resource
import subprocess
import sys
import tempfile
import time
from pathlib import Path

HERE = Path(__file__).resolve()
REPO = HERE.parents[6]
BECOMING = REPO / "experiments/integrated-correction/general-framework/generative-basis/lean/becoming"
sys.path.insert(0, str(BECOMING))
import check_becoming as cb  # noqa: E402


def timed(command, cwd, env):
    before = resource.getrusage(resource.RUSAGE_CHILDREN)
    start = time.perf_counter()
    p = subprocess.run(command, cwd=cwd, env=env, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    wall = time.perf_counter() - start
    after = resource.getrusage(resource.RUSAGE_CHILDREN)
    cpu = (after.ru_utime - before.ru_utime) + (after.ru_stime - before.ru_stime)
    return p.returncode, p.stdout, wall, cpu


def main():
    args = sys.argv[1:]
    bridge = "--bridge" in args
    drivers = [Path(a) for a in args if a != "--bridge"]
    index = cb.module_index()
    order = cb.closure(index)
    core_closure = cb.closure(index, cb.CORE)
    modules = cb.BRIDGE if bridge else core_closure
    needed = cb.closure(index, modules) if bridge else core_closure
    sources = {name: index[name][0].read_bytes() for name in order}
    command, binary, _ = cb.resolve_lean()
    context = [cb.audit_support.TOOLCHAIN, cb.audit_support.digest(binary.read_bytes())]
    keys = cb.module_keys(context, sources, order)
    with tempfile.TemporaryDirectory(prefix="gt2-environment-") as scratch:
        work = Path(scratch)
        missing = []
        for name in needed:
            target = work / cb.source_file(name)
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(sources[name])
            olean = work / (cb.source_file(name)[:-5] + ".olean")
            if cb.reuse(keys[name], [olean]) is None:
                missing.append(name)
        assert not missing, ("compiled modules not in the step cache", missing[:5], len(missing))
        fill = {"imports": "\n".join("import " + name for name in modules),
                "modules": ", ".join("`" + name for name in modules)}
        texts = [("current", cb.ENVIRONMENT_AUDIT.format(**fill))]
        texts += [(d.stem, d.read_text().format(**fill)) for d in drivers]
        env = {**os.environ, "LEAN_PATH": str(work)}
        results, reference = [], None
        for label, text in texts:
            (work / "Driver.lean").write_text(text)
            code, out, wall, cpu = timed(command + ["Driver.lean"], work, env)
            reference = out if reference is None else reference
            results.append({"driver": label, "exit": code, "wall_s": round(wall, 1), "cpu_s": round(cpu, 1),
                            "output_bytes": len(out), "identical_to_current": out == reference,
                            "constants_lines": out.count("CONSTANTS "), "axioms_lines": out.count("AXIOMS ")})
            if code != 0:
                results[-1]["error"] = out[-2000:]
        print(json.dumps({"modules": len(modules), "load": os.getloadavg(), "runs": results}, indent=2))


if __name__ == "__main__":
    main()
