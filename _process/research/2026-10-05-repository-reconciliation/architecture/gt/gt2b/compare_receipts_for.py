#!/usr/bin/env python3
"""Show that `receipts_for`, now reading each receipt's bindings once, finds the receipts the walk per module found.

usage: python3 -B compare_receipts_for.py [EXTRA]

For the modules each checker asks about, over the passed receipts that checker reads (`passed_receipts` without its
own receipt and runs): the core's inherited modules over the core checker's receipts, the fallible-inquiry
adapter's closure over its checker's, and EXTRA more of the core's modules (default 20, every twentieth in compile
order) over the latter, each module at its current bytes: the receipts `binds` accepts, walked as
before, and the receipts `receipts_for` gives, must be the same list. Prints the counts, the seconds each way and any
module that differs; exits 1 if one does.
"""
import json
import sys
import time
from pathlib import Path

REPO = Path(__file__).resolve().parents[6]
BECOMING = REPO / "experiments/integrated-correction/general-framework/generative-basis/lean/becoming"
sys.path.insert(0, str(BECOMING))
import check_becoming as cb  # noqa: E402
import check_fallible_inquiry as fi  # noqa: E402


def main():
    extra = int(sys.argv[1]) if len(sys.argv) > 1 else 20
    index = cb.module_index()
    order = cb.closure(index)
    core = [n for n in order if n not in cb.CHECKED]
    adapter = fi.closure(index)[:-1]
    more = [n for n in order[::20] if n not in core + adapter][:extra]
    sets = {"core": cb.passed_receipts(exclude=(cb.RECEIPT, cb.RETAINED)),
            "fallible inquiry": cb.passed_receipts(exclude=(fi.RECEIPT, fi.RETAINED))}
    asked = core + adapter
    rows, differ, walked, indexed = 0, [], 0.0, 0.0
    for name, which in [(n, "core") for n in core] + [(n, "fallible inquiry") for n in adapter + more]:
        receipts = sets[which]
        path = index[name][0]
        digest = cb.audit_support.digest(path.read_bytes())
        started = time.perf_counter()
        before = sorted(where for where, data in receipts if cb.binds(data, name, path, digest))
        walked += time.perf_counter() - started
        started = time.perf_counter()
        after = cb.receipts_for(name, path, digest, receipts)
        indexed += time.perf_counter() - started
        rows += 1
        if before != after:
            differ.append({"module": name, "receipts": which, "walk": before, "index": after})
    print(json.dumps({"receipts": {k: len(v) for k, v in sets.items()}, "comparisons": rows,
                      "asked_by_the_checkers": len(asked),
                      "seconds_walk": round(walked, 1), "seconds_index": round(indexed, 1),
                      "differ": differ}, indent=2))
    return 1 if differ else 0


if __name__ == "__main__":
    raise SystemExit(main())
