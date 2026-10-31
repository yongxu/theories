#!/usr/bin/env python3
"""FA's comparison of formal's renewed receipt with the one it replaces, declaration by declaration.

Reads each module's `#print axioms` lines from the logs of BASE (default main: `formal/verification/<module>.txt`)
and of the checkout, maps BASE's names through the vocabulary rename's own map (renames.json, preserved with
51a975fdd; it renames declarations of ResourceContinuation only), and reports, per module, the declarations kept,
added and dropped and every axiom report that changed. The gate: no declaration of BASE is dropped and no kept
declaration gains an axiom. Added declarations (ResourceContinuation's three constructive lemmas from f11eb55d6) are
listed with their reports. Writes out/axioms.json.

usage (from the checkout root): axioms_compare.py [BASE]
"""
import json
from pathlib import Path
import re
import subprocess
import sys

F = "experiments/shared-renewal-capability/regulation/retention/formation/formal"
RENAMES = ("experiments/integrated-correction/general-framework/generative-basis/lean/verification-history/"
           "2026-10-06-before-vocabulary-rename/renames.json")
OUT = Path(__file__).resolve().parent / "out"
LINE = re.compile(r"^'(?P<name>[^']+)' (?:depends on axioms: \[(?P<ax>[^\]]*)\]|does not depend on any axioms)")


def audits(text):
    out = {}
    for line in text.splitlines():
        m = LINE.match(line)
        if m:
            out[m["name"]] = sorted(a.strip() for a in (m["ax"] or "").split(",") if a.strip())
    return out


def main():
    base = sys.argv[1] if len(sys.argv) > 1 else "main"
    rename = json.loads(Path(RENAMES).read_text())["declaration_renames_by_module"]
    modules = [m["module"] for m in json.loads(Path(F, "verification.json").read_text())["modules"]]
    report, bad = {}, []
    for mod in modules:
        old_text = subprocess.run(["git", "show", f"{base}:{F}/verification/{mod}.txt"], check=True,
                                  capture_output=True, text=True).stdout
        names = dict(rename.get(mod, {}))
        def mapped(n):
            parts = n.split(".")
            parts[-1] = names.get(parts[-1], parts[-1])
            return ".".join(parts)
        old = {mapped(n): a for n, a in audits(old_text).items()}
        new = audits(Path(F, "verification", f"{mod}.txt").read_text())
        dropped = sorted(set(old) - set(new))
        gained = {n: {"old": old[n], "new": new[n]} for n in sorted(set(old) & set(new)) if set(new[n]) - set(old[n])}
        fewer = {n: {"old": old[n], "new": new[n]} for n in sorted(set(old) & set(new)) if set(old[n]) - set(new[n])
                 and not set(new[n]) - set(old[n])}
        report[mod] = {"kept": len(set(old) & set(new)), "added": {n: new[n] for n in sorted(set(new) - set(old))},
                       "dropped": dropped, "gained_an_axiom": gained, "fewer_axioms": fewer}
        if dropped or gained:
            bad.append(mod)
        print(f"{mod}: {len(set(old) & set(new))} kept, {len(set(new) - set(old))} added, {len(dropped)} dropped, "
              f"{len(gained)} gained an axiom, {len(fewer)} with fewer axioms")
    OUT.mkdir(exist_ok=True)
    (OUT / "axioms.json").write_text(json.dumps({"base": base, "modules": report}, indent=1) + "\n")
    print("every axiom report the same or smaller" if not bad else f"CHANGED for the worse in {bad}")
    sys.exit(1 if bad else 0)


if __name__ == "__main__":
    main()
