#!/usr/bin/env python3
"""Kept as the record of the warm-up the drafting receipt reused. Run only from a scratch copy: W
names the drafting worktree, and it writes work/ and warm-logs/ beside itself.

It compiles the import closure of Becoming.ConditionalWeights with the periphery toolchain,
exactly as check_free_energy_reals.py would (same context, keys, command and environment), stores
each passed step in the shared Lean cache, and keeps the oleans in a work folder so that
FreeEnergyReals.lean can be compiled against them while it is drafted."""
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import re
import subprocess
import sys

sys.dont_write_bytecode = True
W = Path("/private/tmp/claude-501/-Users-ren-theories/7e73c253-c642-4ddd-ad8f-cc6d011978ec/scratchpad/wt-ue17")
LEAN_ROOT = W / "experiments/integrated-correction/general-framework/generative-basis/lean"
sys.path.insert(0, str(LEAN_ROOT / "becoming"))
import check_becoming as core  # noqa: E402

TOOLCHAIN = "leanprover/lean4:v4.30.0-rc2"
LEAN = Path.home() / ".elan/toolchains/leanprover--lean4---v4.30.0-rc2/bin/lean"
MATHLIB_REVISION = "ea11ccc0c5c7c4c562742e918fe2e0b2814a58aa"
TIMEOUT = int(os.environ.get("LEAN_TIMEOUT", "900"))
SCRATCH = Path(__file__).resolve().parent
WORK = SCRATCH / "work"
LOGS = SCRATCH / "warm-logs"


def mathlib_path():
    project = Path(os.environ.get("SYSTEMS_MATHLIB_PROJECT", str(Path.home() / "repos/生生不息")))
    manifest = json.loads((project / "lake-manifest.json").read_text())
    packages = project / manifest.get("packagesDir", ".lake/packages")
    assert next(p for p in manifest["packages"] if p["name"] == "mathlib")["rev"] == MATHLIB_REVISION
    return [p / ".lake/build/lib/lean" for p in sorted(packages.iterdir())
            if (p / ".lake/build/lib/lean").is_dir()]


def main():
    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S.%fZ")
    WORK.mkdir(parents=True, exist_ok=True)
    LOGS.mkdir(parents=True, exist_ok=True)
    index = core.module_index()
    order = core.closure(index, ["Becoming.ConditionalWeights"])
    sources = {name: index[name][0].read_bytes() for name in order}
    context = [TOOLCHAIN, core.audit_support.digest(LEAN.read_bytes()), MATHLIB_REVISION]
    keys = core.module_keys(context, sources, order)
    origin = {"utc": stamp, "retained": str(LOGS)}
    env = {**os.environ, "LEAN_PATH": ":".join([str(WORK)] + [str(p) for p in mathlib_path()])}
    for name, data in sources.items():
        target = WORK / core.source_file(name)
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(data)
    ran, reused = [], []

    def compile_step(name):
        def step():
            olean = core.source_file(name)[:-5] + ".olean"
            outputs = [WORK / olean]
            found = core.reuse(keys[name], outputs)
            if found:
                reused.append(name)
                return found[0]
            p = subprocess.run([str(LEAN), "-o", olean, core.source_file(name)], cwd=WORK, env=env, text=True,
                               stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=TIMEOUT)
            (LOGS / (name + ".log")).write_text(p.stdout)
            assert p.returncode == 0, (name, p.stdout)
            assert not re.search(r"\b(?:error|warning):", p.stdout), (name, p.stdout)
            core.store(keys[name], outputs, p.stdout, origin)
            ran.append(name)
            print("compiled", name, flush=True)
            return p.stdout
        return step

    tasks = {"compile " + name: (["compile " + m for m in core.imports_of(sources[name]) if m in keys],
                                 compile_step(name)) for name in order}
    core.run_graph(tasks)
    print(json.dumps({"stamp": stamp, "modules": len(order), "ran": len(ran), "reused": len(reused)}))


if __name__ == "__main__":
    main()
