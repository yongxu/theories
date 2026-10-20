#!/usr/bin/env python3
"""PE2: classify every periphery use of `propext` from `out/*.json` and write `summary.json`.

A declaration on `propext` that is not a proof (a definition) gets the verdict of
`Uses.lean`: `carried` (every proof on `propext` in it is only carried: a constructor's
field, a quotient primitive, a decision built from an iff), `kernel-native` (a proof on
`propext` is taken apart only inside a `Nat` function the kernel computes on literals
itself) or `eliminated` (a value is computed through a proof on `propext` that reduction
must take apart). A proof is classed by how `propext` reaches it:
  identification: the proof term applies `propext` itself;
  through-theorems: not itself, but through a theorem it uses (the identification is
    made inside that theorem's proof);
  through-values: only through definitions its term or statement uses, no theorem on
    `propext` and no `propext` in the term (the proof makes no identification at all).
"""
import collections
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent


def library(module):
    return module.split(".")[0] in {"Init", "Std", "Lean", "Mathlib", "Batteries", "Aesop", "Qq"}


def main():
    rows, totals = [], collections.Counter()
    leaves = collections.Counter()
    theorem_entries = collections.Counter()
    eliminated_values = {}
    per_declaration = []
    for path in sorted((HERE / "out").glob("*.json")):
        data = json.loads(path.read_text())
        reached = {v["name"]: v for v in data["values_reached"]}
        own = [d for d in data["declarations"] if d.get("onPropext")]
        for d in own:
            reached.setdefault(d["name"], d) if not d["proof"] else None
        row = collections.Counter()
        for d in own:
            if d["proof"]:
                theorems = [e for e in d["entries"] if e["proof"]]
                values = [e for e in d["entries"] if not e["proof"]] + d["statement_values"]
                cls = ("identification" if d["propext_in_term"] else
                       "through-theorems" if theorems else "through-values")
                for e in theorems:
                    theorem_entries[("library" if library(e["module"]) else "repository", e["module"].split(".")[0])] += 1
                worst = max((v.get("verdict", "carried") for v in values),
                            key=["clean", "carried", "kernel-native", "eliminated"].index, default="none")
                row["proof " + cls] += 1
                if worst != "none":
                    row["proof mentioning a value: " + worst] += 1
                per_declaration.append({"receipt": data["receipt"], "name": d["name"], "proof": True,
                                        "class": cls, "worst_value": worst,
                                        "theorems": [e["name"] for e in theorems][:8],
                                        "values": sorted({v.get("name") or v.get("value") for v in values})[:8]})
            else:
                row["definition " + d["verdict"]] += 1
                per_declaration.append({"receipt": data["receipt"], "name": d["name"], "proof": False,
                                        "verdict": d["verdict"], "occurrences": d["occurrences"]})
        # The leaves: where a proof on propext is taken apart, in any value reached.
        for name, v in reached.items():
            for o in v.get("occurrences", []):
                if o["kind"] == "eliminated":
                    leaves[(name, o["sink"], o.get("route"))] += 1
                    eliminated_values[name] = o
        row["audited"] = data["audited"]
        row["on propext"] = data["recorded_on_propext"]
        totals.update(row)
        rows.append({"receipt": data["receipt"], "target": data["target"], "toolchain": data["toolchain"],
                     "agrees_with_receipt": data["agrees_with_receipt"],
                     "compiled_here": data["compiled"], **dict(row)})
    summary = {"rows": rows, "totals": dict(totals),
               "eliminated_leaves": [{"value": k[0], "sink": k[1], "route": k[2], "count": n}
                                     for k, n in leaves.most_common()],
               "theorem_entries_by_origin": [{"origin": k[0], "root": k[1], "count": n}
                                             for k, n in theorem_entries.most_common()],
               "declarations": per_declaration}
    (HERE / "summary.json").write_text(json.dumps(summary, indent=1, ensure_ascii=False))
    for r in rows:
        print(r["target"], {k: v for k, v in r.items() if k not in ("receipt", "target", "toolchain", "compiled_here", "agrees_with_receipt")})
    print("TOTAL", dict(totals))
    print("LEAVES")
    for x in summary["eliminated_leaves"]:
        print(" ", x)
    print("THEOREM ENTRIES", summary["theorem_entries_by_origin"])


if __name__ == "__main__":
    main()
