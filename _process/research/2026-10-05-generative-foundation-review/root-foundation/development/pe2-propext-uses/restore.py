#!/usr/bin/env python3
"""PE2: put the compiled closure of one periphery module, as its receipt checked it, in a work directory.

Each periphery receipt names its compile order, the sha256 of every source it compiled, the
commit of main that held those bytes and a run folder with a copy of each file main did not
hold. This script takes the bytes from there (and fails if any digest differs), computes the
checkers' step keys (toolchain context, the module's bytes, the keys of what it imports) and
restores each `.olean` from the shared cache (`~/.cache/becoming-lean`) where the checker stored
it; a step not cached is compiled here and stored, as the checkers do. The current bytes are
not used: several periphery modules no longer compile against the current core, so the
analysis reads each module as its receipt checked it. This runs no check of its own.

usage: restore.py RECEIPT WORKDIR
"""
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys

sys.dont_write_bytecode = True
REPO = Path(__file__).resolve().parents[6]
LEAN_ROOT = REPO / "experiments/integrated-correction/general-framework/generative-basis/lean"
sys.path.insert(0, str(LEAN_ROOT / "becoming"))
import check_becoming as core  # noqa: E402

MATHLIB_REVISION = "ea11ccc0c5c7c4c562742e918fe2e0b2814a58aa"
TOOLCHAINS = {
    False: ("leanprover/lean4:v4.29.1", Path.home() / ".elan/toolchains/leanprover--lean4---v4.29.1/bin/lean"),
    True: ("leanprover/lean4:v4.30.0-rc2", Path.home() / ".elan/toolchains/leanprover--lean4---v4.30.0-rc2/bin/lean"),
}
def receipt_sources(receipt_path):
    """The bytes each module had when the receipt was written, from main's commit or the run folder."""
    receipt = json.loads(receipt_path.read_text())
    commit = receipt["source_commit"]["main"]
    retained = receipt_path.parent / receipt["retained_run"]
    sources, origin = {}, {}
    for name in receipt["compile_order"]:
        path, want = receipt["source_paths"][name], receipt["source_sha256"][name]
        found = None
        for root in [LEAN_ROOT, REPO / "experiments"]:
            relative = os.path.relpath(os.path.normpath(root / path), REPO)
            shown = subprocess.run(["git", "show", f"{commit}:{relative}"], cwd=REPO, capture_output=True)
            if shown.returncode == 0 and hashlib.sha256(shown.stdout).hexdigest() == want:
                found, origin[name] = shown.stdout, f"{commit[:9]}:{relative}"
                break
        if found is None:
            copy = retained / (name + ".lean")
            data = copy.read_bytes() if copy.is_file() else b""
            assert hashlib.sha256(data).hexdigest() == want, ("no bytes with the receipt's digest", name)
            found, origin[name] = data, str(copy.relative_to(REPO))
        sources[name] = found
    return receipt, sources, origin


def mathlib_path():
    project = Path(os.environ.get("SYSTEMS_MATHLIB_PROJECT", Path.home() / "repos/生生不息")).expanduser()
    manifest = json.loads((project / "lake-manifest.json").read_text())
    packages = project / manifest.get("packagesDir", ".lake/packages")
    assert next(p for p in manifest["packages"] if p["name"] == "mathlib")["rev"] == MATHLIB_REVISION
    return [p / ".lake/build/lib/lean" for p in sorted(packages.iterdir()) if (p / ".lake/build/lib/lean").is_dir()]


def main():
    receipt_path, work = Path(sys.argv[1]).resolve(), Path(sys.argv[2]).resolve()
    receipt, sources, origin = receipt_sources(receipt_path)
    mathlib = "4.30" in receipt["toolchain"]
    toolchain, lean = TOOLCHAINS[mathlib]
    assert toolchain == receipt["toolchain"], receipt["toolchain"]
    digest = hashlib.sha256(lean.read_bytes()).hexdigest()
    assert digest == receipt.get("lean_binary_sha256", digest), "another Lean binary than the receipt's"
    order = receipt["compile_order"]
    work.mkdir(parents=True, exist_ok=True)
    context = [toolchain, digest] + ([MATHLIB_REVISION] if mathlib else [])
    keys = core.module_keys(context, sources, order)
    env = {**os.environ, "LEAN_PATH": ":".join([str(work)] + ([str(p) for p in mathlib_path()] if mathlib else []))}
    restored, compiled = [], []
    for name in order:
        source = work / core.source_file(name)
        source.parent.mkdir(parents=True, exist_ok=True)
        source.write_bytes(sources[name])
        olean = work / (core.source_file(name)[:-5] + ".olean")
        if core.reuse(keys[name], [olean]):
            restored.append(name)
            continue
        p = subprocess.run([str(lean), "-o", str(olean), core.source_file(name)], cwd=work, env=env,
                           text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        assert p.returncode == 0, (name, p.stdout)
        core.store(keys[name], [olean], p.stdout, {"utc": "pe2-restore", "retained": "not retained"})
        compiled.append(name)
    (work / "restore.json").write_text(json.dumps({
        "receipt": str(receipt_path.relative_to(REPO)), "receipt_utc": receipt["utc"],
        "target": order[-1], "toolchain": toolchain, "mathlib_revision": MATHLIB_REVISION if mathlib else None,
        "lean": str(lean), "order": order, "origin": origin,
        "restored_from_cache": restored, "compiled": compiled}, indent=1))
    print(order[-1], "restored", len(restored), "compiled", len(compiled), compiled)


if __name__ == "__main__":
    main()
