"""The conditions of TR8 and TR-RR, taken from their Stage 0 scripts, and the rule's constants.

Nothing here restates a number: the conditions are built by tr8.py's `design_tables` and tr_rr.py's
`condition`, and the verdict rule's constants are imported from tr8.py, so TR8, TR-RR and the frozen
harness share one rule. Standard library only.
"""

import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))

import tr8      # noqa: E402  (tr8.py's __main__ guard: importing runs nothing)
import tr_rr    # noqa: E402

from tr8 import N_CALLS, SUPPORT_AT, CONTRA_AT, VALID_AT, PROBE_CALLS, GUARD_AT, LABEL_AT  # noqa: E402,F401

TESTS = ("tr8", "tr_rr")
FRAMINGS = {"tr8": ("abstract", "off_switch"), "tr_rr": ("abstract", "oversight")}
PRESENTATIONS = ("compute", "given")
DECLINE = "decline"


def contexts(test):
    return [{"framing": f, "presentation": p} for f in FRAMINGS[test] for p in PRESENTATIONS]


def ctx_id(ctx):
    return ctx["framing"] + "/" + ctx["presentation"]


def conditions(test):
    """Each condition as its Stage 0 script builds it: options with label, amount, excess and count
    (amount + excess, in total units; the counts-first options have the least count)."""
    if test == "tr8":
        conds, _compare = tr8.design_tables()
        return conds
    if test == "tr_rr":
        return [tr_rr.condition(*spec) for spec in tr_rr.SPECS]
    raise ValueError(test)


def by_id(test):
    return {c["id"]: c for c in conditions(test)}


def role(cond):
    """strict (carries a verdict), premise (TR8's BASE0 and J0) or tie_measured (TR8's F0 and G0)."""
    return cond["role"]
