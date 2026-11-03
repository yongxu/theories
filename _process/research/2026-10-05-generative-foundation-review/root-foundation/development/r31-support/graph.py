#!/usr/bin/env python3
"""R31: the core's import graph and the ethics' import closure.

Reads the package's modules (Becoming/*.lean) and the checker's CORE list; prints, for the core,
how many modules have Becoming.Metaethics or Becoming.Significance in their import closure, and how
many of those use the ethical vocabulary in their source outside comments (the statement scan of
the twentieth review's A4). `python3 graph.py [--json]`.
"""
import json
import os
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[5]
PKG = Path(os.environ.get("R31_PKG", REPO / "experiments/integrated-correction/general-framework/generative-basis/lean/becoming"))


def core_list():
    src = (PKG / "check_becoming.py").read_text()
    m = re.search(r"^CORE = \[(.*?)\]\n", src, re.S | re.M)
    return re.findall(r'"([^"]+)"', m.group(1))


def checker_list(name):
    """One of the checker's module lists (`FOUNDATION`, `INSTANCES`, `APPLICATIONS`)."""
    src = (PKG / "check_becoming.py").read_text()
    m = re.search(r"^" + name + r" = \[(.*?)\]\n", src, re.S | re.M)
    return re.findall(r'"([^"]+)"', m.group(1))


def strip_comments(src):
    src = re.sub(r"/-.*?-/", "", src, flags=re.S)
    return re.sub(r"--[^\n]*", "", src)


def modules():
    mods = {}
    for p in sorted((PKG / "Becoming").glob("*.lean")):
        src = p.read_text()
        mods["Becoming." + p.stem] = {"imports": re.findall(r"^import\s+(\S+)", src, re.M), "src": src}
    src = (PKG / "Becoming.lean").read_text()
    mods["Becoming"] = {"imports": re.findall(r"^import\s+(\S+)", src, re.M), "src": src}
    return mods


def closures(mods):
    memo = {}
    sys.setrecursionlimit(10000)

    def clo(m):
        if m in memo:
            return memo[m]
        s = set()
        for i in mods.get(m, {}).get("imports", []):
            s.add(i)
            if i in mods:
                s |= clo(i)
        memo[m] = s
        return s

    for m in mods:
        clo(m)
    return memo


# The twentieth review's A4 scan read the ethical vocabulary broadly (the condition, valuations, the
# neutralities, articulation, endorsement, `living`, `sig`, ...); `--broad` uses that list with R30's
# names. The default is the checkable property of the layers (A5): a module states the condition or a
# valuation, `Unrestricted` or `Valuation`, in its source. Import lines and comments are not read.
BROAD = re.compile(
    r"\b(Unrestricted|Valuation|Neutral|SelfSignificance|LivingSignificance|articulates|endorses|"
    r"Retains|bounded|Extension|living|sig)\b")
CONDITIONAL = re.compile(r"\b(Unrestricted|Valuation)\b")
ETHICS = BROAD if "--broad" in sys.argv else CONDITIONAL


def strip_comments(src):
    src = re.sub(r"/-.*?-/", "", src, flags=re.S)
    src = re.sub(r"^import [^\n]*", "", src, flags=re.M)
    return re.sub(r"--[^\n]*", "", src)


def measure():
    mods = modules()
    core = [m for m in core_list() if m != "Becoming"]
    clo = closures(mods)
    targets = ["Becoming.Metaethics", "Becoming.Significance"]
    reach = [m for m in core if any(t in clo[m] for t in targets)]
    uses = [m for m in reach if ETHICS.search(strip_comments(mods[m]["src"]))]
    return {
        "core_modules": len(core),
        "reach_ethics": len(reach),
        "reach_ethics_and_use_vocabulary": len(uses),
        "reach_without_use": sorted(set(reach) - set(uses)),
        "use": sorted(uses),
    }


def main():
    out = measure()
    if "--json" in sys.argv:
        print(json.dumps(out, indent=1))
        return
    print(f"core modules {out['core_modules']}; Metaethics/Significance in the import closure of "
          f"{out['reach_ethics']}; of these {out['reach_ethics_and_use_vocabulary']} use the ethical "
          f"vocabulary, {out['reach_ethics'] - out['reach_ethics_and_use_vocabulary']} do not")
    print("using:", " ".join(m[9:] for m in out["use"]))
    print("not using:", " ".join(m[9:] for m in out["reach_without_use"]))


if __name__ == "__main__":
    main()
