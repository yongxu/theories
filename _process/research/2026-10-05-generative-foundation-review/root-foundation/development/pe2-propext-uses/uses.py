#!/usr/bin/env python3
"""PE2: classify every periphery use of `propext`, receipt by receipt.

For each receipt below: restore its target's compiled closure as the receipt checked it
(`restore.py`), run `Uses.lean` on every declaration the receipt audited, check that the
analysis finds `propext` in exactly the declarations whose recorded axiom report has it, and
keep the result in `out/<receipt stem>.json`. `summary.py` reads those files.

usage: uses.py WORKROOT [receipt ...]
"""
import json
import os
from pathlib import Path
import subprocess
import sys

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[5]
LEAN = "experiments/integrated-correction/general-framework/generative-basis/lean/"
MATH = "experiments/integrated-correction/general-framework/generative-basis/mathematical-abstraction/"
# The bridge and the instance modules chapter section 9 names ("The periphery's own checks"),
# and EntropyProduction, the periphery's physics module.
RECEIPTS = [
    LEAN + "becoming/fallible-inquiry-verification.json",
    LEAN + "universal-ethics/generative-capacity/correction-inquiry-verification.json",
    LEAN + "universal-ethics/generative-capacity/machine-instances-verification.json",
    LEAN + "universal-ethics/evolution-connectionism/learning-correspondence-verification.json",
    LEAN + "universal-ethics/generative-capacity/copying-instances-verification.json",
    LEAN + "universal-ethics/generative-capacity/retrodiction-instances-verification.json",
    "experiments/market-generativity/formal/market-instances-verification.json",
    LEAN + "universal-ethics/generative-capacity/protocol-instances-verification.json",
    "experiments/market-generativity/meta-attractor/versioned-task-instances-verification.json",
    "experiments/market-generativity/meta-attractor/shared-stock-instances-verification.json",
    LEAN + "systems-complexity/analysis/continuation-correspondence-verification.json",
    LEAN + "universal-ethics/evolution-connectionism/transmission-correspondence-verification.json",
    LEAN + "universal-ethics/preparation-correspondence-verification.json",
    LEAN + "deeper/judging-correspondence-verification.json",
    LEAN + "universal-ethics/generative-capacity/renewing-correspondence-verification.json",
    LEAN + "deeper/substitution-correspondence-verification.json",
    LEAN + "universal-ethics/generative-capacity/organization-correspondence-verification.json",
    LEAN + "universal-ethics/living-organization-correspondence-verification.json",
    MATH + "completion/formal/prefix-safety-correspondence-verification.json",
    MATH + "completion/formal/finite-branching-correspondence-verification.json",
    MATH + "acquisition/feedback/remaining-dependency/formal/selection-relabel-correspondence-verification.json",
    MATH + "completion/formal/ideals-correspondence-verification.json",
    LEAN + "physics/entropy-production-verification.json",
    # The core: its generated constructor-injectivity lemmas, the only core constants on an axiom.
    LEAN + "becoming/becoming-verification.json",
]


def recorded(receipt):
    deps = {}

    def walk(x):
        if isinstance(x, dict):
            if isinstance(x.get("axiom_dependencies"), dict):
                deps.update(x["axiom_dependencies"])
            for v in x.values():
                walk(v)
        elif isinstance(x, list):
            for v in x:
                walk(v)

    walk(receipt)
    return deps


def compact(result):
    """Keep each distinct occurrence once; among values reached, keep only the occurrences that
    decide a verdict (a proof taken apart, or a value that is not merely carried)."""
    def distinct(items):
        seen, out = set(), []
        for item in items:
            key = json.dumps(item, sort_keys=True)
            if key not in seen:
                seen.add(key)
                out.append(item)
        return out

    for d in result["declarations"]:
        if "occurrences" in d:
            d["occurrences"] = distinct(d["occurrences"])
    for v in result["values_reached"]:
        v["occurrences"] = distinct(o for o in v["occurrences"]
                                    if not (o["kind"] == "value" and o["its_verdict"] == "carried"))
    return result


def run(receipt_path, root):
    receipt = json.loads((REPO / receipt_path).read_text())
    work = root / Path(receipt_path).stem
    subprocess.run([sys.executable, "-B", str(HERE / "restore.py"), str(REPO / receipt_path), str(work)], check=True)
    restore = json.loads((work / "restore.json").read_text())
    deps = recorded(receipt)
    imports = [restore["target"]]
    if "generated_axiom_dependencies" in receipt:
        # The core receipt: the generated constants on an axiom, read with every core module.
        deps = receipt["generated_axiom_dependencies"]
        imports = restore["order"]
    names = sorted(deps)
    analysis = (HERE / "Uses.lean").read_text().replace("import Lean\n", "", 1)
    out = work / "uses.json"
    listed = ", ".join(json.dumps(n, ensure_ascii=False) for n in names)
    driver = ("".join(f"import {m}\n" for m in imports) + "import Lean\n" + analysis
              + f"\n#eval PE2.main ([{listed}] : List String) \"{out}\"\n")
    (work / "PE2Driver.lean").write_text(driver)
    env = dict(os.environ)
    if restore["mathlib_revision"]:
        sys.path.insert(0, str(HERE))
        import restore as r  # noqa: E402
        env["LEAN_PATH"] = ":".join([str(work)] + [str(p) for p in r.mathlib_path()])
    else:
        env["LEAN_PATH"] = str(work)
    p = subprocess.run([restore["lean"], "PE2Driver.lean"], cwd=work, env=env, text=True,
                       stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    assert p.returncode == 0, p.stdout[-4000:]
    result = compact(json.loads(out.read_text()))
    found = {d["name"]: d for d in result["declarations"]}
    mismatch = [n for n in names if found.get(n, {}).get("onPropext") != ("propext" in deps[n])]
    result.update({"receipt": receipt_path, "receipt_utc": receipt["utc"], "target": restore["target"],
                   "toolchain": restore["toolchain"], "audited": len(names),
                   "recorded_on_propext": sum("propext" in deps[n] for n in names),
                   "agrees_with_receipt": not mismatch, "mismatch": mismatch,
                   "restored_from_cache": len(restore["restored_from_cache"]), "compiled": restore["compiled"]})
    (HERE / "out").mkdir(exist_ok=True)
    (HERE / "out" / (Path(receipt_path).stem + ".json")).write_text(json.dumps(result, indent=1, ensure_ascii=False))
    print(Path(receipt_path).stem, "audited", len(names), "on propext", result["recorded_on_propext"],
          "agrees", not mismatch, mismatch[:5])


def main():
    root = Path(sys.argv[1]).resolve()
    for receipt_path in sys.argv[2:] or RECEIPTS:
        run(receipt_path, root)


if __name__ == "__main__":
    main()
