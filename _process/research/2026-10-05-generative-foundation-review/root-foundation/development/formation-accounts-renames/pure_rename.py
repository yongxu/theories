#!/usr/bin/env python3
"""FA's check that the three names FormationAccounts.lean needs were pure renames.

For each pair (AccountLaw → SustainLaw, credited → arrivalEvent, support_trace_balance → support_trace_bound) it reads
the declaration in `conditional/ResourceContinuation.lean` at three commits: before the rename (51a975fdd's parent), at
the rename (51a975fdd) and at REV (default HEAD). The statement, from the keyword to `:=`, must be the same at all
three once the old names are mapped to the new by the rename's own table (RENAMES.md, preserved with the commit:
the declaration names and the binder names `reserve` → `held`, `demand` → `enacted`, `credit` → `arrived`,
`spent` → `enactedTotal`, `received` → `arrivedTotal`). For the two definitions the body after `:=` must be the same
too, so they unfold alike, and so must the whole of `SupportTrace`, which the theorem's statement names; for the
theorem only the statement counts (f11eb55d6 later rewrote its proof to drop
propext and Quot.sound). Binder names are bound variables, so a change of them alone changes no meaning.

usage (from the checkout root): pure_rename.py [REV]   -> prints each comparison, exits 1 on any difference
"""
import re
import subprocess
import sys

SOURCE = "experiments/integrated-correction/general-framework/generative-basis/lean/conditional/ResourceContinuation.lean"
RENAME = "51a975fdd624d94c6a5ea1b4b37d5fadbf03bd1e"
PAIRS = [("AccountLaw", "SustainLaw", "def"), ("credited", "arrivalEvent", "def"),
         ("support_trace_balance", "support_trace_bound", "theorem")]
# What the theorem's statement names besides SustainLaw: the trace relation, whose whole definition must also agree.
CONTEXT = [("SupportTrace", "SupportTrace", "inductive")]
# The rename's own table (RENAMES.md beside the preserved sources), for the names these three declarations use.
MAP = {"AccountLaw": "SustainLaw", "credited": "arrivalEvent", "support_trace_balance": "support_trace_bound",
       "reserve": "held", "demand": "enacted", "credit": "arrived", "spent": "enactedTotal",
       "received": "arrivedTotal"}


def text(rev):
    return subprocess.run(["git", "show", f"{rev}:{SOURCE}"], check=True, capture_output=True, text=True).stdout


def declaration(src, kind, name):
    """The declaration's text from its keyword to the next blank line, as (statement, body) split at the first ':='."""
    m = re.search(rf"^{kind} {re.escape(name)}\b.*?(?=\n\s*\n)", src, re.S | re.M)
    assert m, (kind, name)
    statement, _, body = m.group(0).partition(":=")
    return " ".join(statement.split()), " ".join(body.split())


def mapped(s):
    return re.sub(r"\b(" + "|".join(map(re.escape, MAP)) + r")\b", lambda m: MAP[m.group(1)], s)


def main():
    rev = sys.argv[1] if len(sys.argv) > 1 else "HEAD"
    before, at, now = text(RENAME + "^"), text(RENAME), text(rev)
    bad = 0
    for old, new, kind in PAIRS + CONTEXT:
        s0, b0 = declaration(before, kind, old)
        s1, b1 = declaration(at, kind, new)
        s2, b2 = declaration(now, kind, new)
        same_statement = mapped(s0) == s1 == s2
        same_body = kind == "theorem" or mapped(b0) == b1 == b2
        print(f"{old} -> {new}: statement {'same' if same_statement else 'DIFFERS'} before, at and after the rename"
              + ("" if kind == "theorem" else f"; body {'same' if same_body else 'DIFFERS'}"))
        print(f"  now: {s2}" + ("" if kind == "theorem" or not b2 else f" := {b2}"))
        if not (same_statement and same_body):
            print(f"  before (mapped): {mapped(s0)} := {mapped(b0)}\n  at: {s1} := {b1}")
            bad += 1
    sys.exit(1 if bad else 0)


if __name__ == "__main__":
    main()
