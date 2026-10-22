#!/usr/bin/env python3
"""Build tree/Becoming/RegimeMargin.lean: one law of exact thresholds (UM).

Reads Becoming/RegimeMargin.lean from this worktree's package, or from the git ref in
UM_BASE, and applies exact once-only region edits, each replacing the text from a start
anchor up to (not including) an end anchor with a kit fragment. Every anchor must occur
exactly once (the end anchor once after its start).
"""
import os
import subprocess
import sys
from pathlib import Path

KIT = Path(__file__).resolve().parent
ROOT = KIT.parents[5]
PKG = "experiments/integrated-correction/general-framework/generative-basis/lean/becoming"
REL = PKG + "/Becoming/RegimeMargin.lean"


def source():
    base = os.environ.get("UM_BASE")
    if base:
        return subprocess.run(["git", "-C", str(ROOT), "show", f"{base}:{REL}"],
                              check=True, capture_output=True, text=True).stdout
    return (ROOT / REL).read_text()


def frag(name):
    return (KIT / name).read_text()


# (start anchor, end anchor, replacement); the start anchor is replaced, the end anchor kept.
EDITS = [
    # The header: the one law, before the threshold in the plane.
    ("* **The threshold in the plane.** Where the adjustment rises",
     "* **The threshold in the plane.** Where the adjustment rises",
     lambda: frag("header.md")),
    # The law at the leading layer, after leading_false.
    ("namespace Adjusted\n\n/-- The run from a state comes to rest below the draw. -/",
     "namespace Adjusted\n\n/-- The run from a state comes to rest below the draw. -/",
     lambda: frag("threshold_law.lean")),
    # RM4: exactness and falling in the plane.
    ("/-- **The threshold is exact.** Where the adjustment rises",
     "/-- **Every state in the band has its fate by the threshold.** Where the adjustment rises",
     lambda: frag("adjusted.lean")),
    # The regime's threshold: leading_eq.
    ("  have same : ∀ x, x ≤ hi → (x < Adjusted.threshold",
     "namespace Notch\n",
     lambda: frag("regime_tail.lean")),
    # RM8: the web within a band.
    ("/-- **The point of no return is exact.** Within a band under mutual support, condition `i` ends from",
     "/-- **Every state in the band has its fate by the threshold.** Within a band under mutual support,\nthe run from condition",
     lambda: frag("indexed.lean")),
    # RM9/RM10: beyond a band, any law keeping the order.
    ("/-- **The point of no return is exact beyond a band.**",
     "/-! #### Webs with a recent giving",
     lambda: frag("within.lean")),
    # Adjusted.threshold_le: no law reads it once the regime's threshold is leading_eq.
    ("theorem threshold_le (A : Nat → Nat → Nat) (H hi r : Nat) : threshold A H hi r ≤ hi + 1 :=",
     "/-- **Below a state whose run rests below the draw, every run does.**",
     lambda: ""),
    # leading_congr moves to the leading layer.
    ("/-- Leading runs of `true` agree for readings that agree. -/",
     "/-- The pair from `x` with its partner at `y` is the web's state",
     lambda: ""),
]


def apply(text):
    for start, end, new in EDITS:
        assert text.count(start) == 1, f"start anchor not once: {start[:60]!r}"
        i = text.index(start)
        if start == end:
            text = text[:i] + new() + text[i:]
            continue
        j = text.index(end, i + len(start)) if end in text[i + len(start):] else -1
        assert j >= 0 and text.count(end) == 1, f"end anchor not once: {end[:60]!r}"
        text = text[:i] + new() + text[j:]
    return text


def main():
    out = KIT / "tree" / "Becoming" / "RegimeMargin.lean"
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(apply(source()))
    print(out)


if __name__ == "__main__":
    sys.exit(main())
