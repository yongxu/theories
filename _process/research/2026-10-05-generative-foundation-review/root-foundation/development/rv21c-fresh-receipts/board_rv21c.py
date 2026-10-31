#!/usr/bin/env python3
"""RV21c's board edits (board_ue25.py's pattern), never in the shared checkout.

head [BOARD]: put RV21c's clause, "RV21c at the head of the queue (landing now: ...); ", at the front of the Queue
      line, behind no other "landing now" clause; its counts come from out/status.json (the runs are done by then).
      BOARD defaults to the checkout's board; claim_head.sh passes a copy of main's, for a commit made without a
      worktree.
land CORE_UTC N DATE ORDER: drop RV21c's head clause and put the landed clause first; move RV21c's row, its claim
      brought to what was done and its state the landing on DATE (YYYY-MM-DD, the landing day), to the history file
      after the last landed row (its links rebased there). ORDER is the coordinator's sentence naming what comes
      after, given verbatim with the slot ("Then, in the coordinator's order: ...; ask the coordinator for a slot."),
      written after the landed clause.
check BOARD HISTORY ORDER: before the head claim, on copies of main's board and history file: the order sentence,
      RV21c's row with the text land rewrites, and the history file's anchor.
usage (from the checkout root): python3 -B board_rv21c.py head [BOARD] | check BOARD HISTORY ORDER
                                 | land CORE_UTC N DATE ORDER
"""
import json
from pathlib import Path
import re
import sys

from kit import OUT, RECEIPTS, stem

BOARD = Path("_process/BECOMING-WORKBOARD.md")
HISTORY = Path("_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md")
WORK = "research/2026-10-05-generative-foundation-review/root-foundation/development/rv21c-fresh-receipts"
HEAD = re.compile(r"RV21c at the head of the queue \([^()]*\); ")
FALLIBLE = "fallible-inquiry-verification"


def older_name(receipt):
    """formal, evolution, evolution/development: the checker folder below `formation/`."""
    return receipt.split("/formation/")[-1].removesuffix("/verification.json")


def older_head():
    ran = json.loads((OUT / "older.json").read_text()) if (OUT / "older.json").exists() else {}
    if not ran.get("receipts"):
        return ""
    renewed = sum(1 for v in ran["receipts"].values() if v["passed"])
    return f" and {renewed} of {len(ran['receipts'])} older-layout receipts renewed in place"


def head_text():
    status = json.loads((OUT / "status.json").read_text())
    passed = sum(1 for p in RECEIPTS if status[stem(p)]["passed"])
    failed = len(RECEIPTS) - passed
    text = (f"landing now: the fresh core receipt and {passed} of the {len(RECEIPTS)} stale periphery receipts renewed"
            + (f", {failed} failed and kept as findings," if failed else "")
            + older_head()
            + ", run before this clause, the core with every Lean step run and the periphery reusing only steps this "
            "slot's runs kept; the records binding the renewed runs re-pointed to them, no statement changed; 08 §3's "
            "receipt; a study section; then render, strict check, links and tests, then the fast-forward")
    # The clause is found again by HEAD (here, in release_head.sh and in land), which allows no parentheses inside.
    assert "(" not in text and ")" not in text, text
    return text


def queue_line(lines):
    at = [i for i, line in enumerate(lines) if line.startswith("- **Queue:** ")]
    assert len(at) == 1, at
    return at[0]


def head(board):
    lines = board.read_text(encoding="utf-8").split("\n")
    q = queue_line(lines)
    assert "(landing now" not in lines[q], "another clause holds the head: " + lines[q][:200]
    clause = f"RV21c at the head of the queue ({head_text()}); "
    assert HEAD.fullmatch(clause), clause
    lines[q] = lines[q].replace("- **Queue:** ", "- **Queue:** " + clause, 1)
    board.write_text("\n".join(lines), encoding="utf-8")
    print("head: RV21c at the head of the queue")


def facts():
    status = json.loads((OUT / "status.json").read_text())
    repoint = json.loads((OUT / "repoint.json").read_text())
    swap = json.loads((OUT / "swap.json").read_text()) if (OUT / "swap.json").exists() else None
    verify = json.loads((OUT / "verify.json").read_text())
    passed = [stem(p) for p in RECEIPTS if status[stem(p)]["passed"]]
    failed = [stem(p).removesuffix("-verification") for p in RECEIPTS if not status[stem(p)]["passed"]]
    records = sorted({r for s in passed for r in repoint.get(s, {}).get("records", [])})
    texts = json.loads((OUT / "texts.json").read_text())
    plan = json.loads((OUT / "receipts.json").read_text())
    return passed, failed, records, swap, verify, texts, plan


REPLACE = [("the 25 periphery receipts rerun on the same main on the warm cache",
            "the stale periphery receipts rerun on the same main on this slot's step cache, reusing only steps "
            "this slot's runs ran and kept"),
           ("`development/rv21c-fresh-receipts/stale_all.py`, not yet in the repository)",
            "`development/rv21c-fresh-receipts/stale_all.py`)")]


def check_order(order):
    order = order.strip()
    assert order.startswith("Then, in the coordinator's order: ") and order.endswith(
        "ask the coordinator for a slot."), order
    assert "); " not in order and "\n" not in order and " | " not in order, "the order sentence"
    return order


def check(board, history, order):
    """Before the head claim: the order sentence, RV21c's row as land() will rewrite it, the history file's anchor."""
    check_order(order)
    rows = [line for line in board.read_text(encoding="utf-8").split("\n") if line.startswith("| **RV21c: ")]
    assert len(rows) == 1, len(rows)
    cells = rows[0].split(" | ")
    assert len(cells) == 5, len(cells)
    for a, _ in REPLACE:
        assert cells[0].count(a) == 1, ("RV21c's row changed since the kit was written", a)
    assert "## Lapsed claims (18 October 2026)" in history.read_text(encoding="utf-8").split("\n")
    print("check: the order sentence, RV21c's row and the history file are as land() needs them")


def land(core, n, date, order):
    assert re.fullmatch(r"2026-1[0-2]-\d\d", date), date
    order = check_order(order)
    passed, failed, records, swap, verify, texts, plan = facts()
    # The records binding an older-layout receipt renewed in place are re-pointed too (their pinned hash follows it).
    older_recs = sorted({r for k, v in json.loads((OUT / "repoint.json").read_text()).items() if k.startswith("older:")
                         for r in v.get("records", [])} - set(records))
    repointed = (f"{len(records)} records re-pointed to the renewed periphery runs"
                 + (f" and {len(older_recs)} to the older-layout receipts renewed in place" if older_recs else ""))
    steps = verify["core"]["steps"]
    total = len(RECEIPTS)
    fallible = ([p for p in RECEIPTS if stem(p) == FALLIBLE] or [None])[0]
    path = ("" if fallible is None else
            "; FallibleInquiry's receipt " + ("renewed" if stem(fallible) in passed else "kept as a finding")
            + " in `becoming/fallible-inquiry-checks/`, not in `development/pr1-periphery-receipts/` as first written")
    ran = json.loads((OUT / "older.json").read_text()) if (OUT / "older.json").exists() else {}
    rows = ran.get("receipts", {})
    renewed = [older_name(r) for r, v in rows.items() if v["passed"]]
    failed_older = [older_name(r) for r, v in rows.items() if not v["passed"] and not v.get("not_run")]
    not_run = [older_name(r) for r, v in rows.items() if v.get("not_run")]
    acks = json.loads((OUT / "acks.json").read_text()) if (OUT / "acks.json").exists() else {}
    older_text = ("" if not rows else
                  f"; the older-layout step, as the coordinator set it: {len(renewed)} of {len(rows)} "
                  f"receipts renewed in place by their own checkers, {', '.join(renewed) or 'none'}"
                  + (f", {', '.join(failed_older)} failed on main and kept as a finding" if failed_older else "")
                  + (f", {', '.join(not_run)} not run after it" if not_run else "")
                  + (f", routed to the coordinator, who ruled: {acks['older']}" if acks.get("older") else "")
                  + f", {len(ran.get('not_renewed', []))} unbound ones named in the README as not renewed")
    left = (swap or {}).get("left", {})
    left_text = ("" if not left else
                 f"; validation_scope left as it was in {len(left)} records, the module changed between the two "
                 "runs or its signatures not compared: "
                 + ", ".join(f"{rid} {why.split(':')[0]}" for rid, why in sorted(left.items())))
    axioms_text = (f"; a changed axiom report routed to the coordinator, who ruled: {acks['axioms']}"
                   if acks.get("axioms") else "")
    chapter = ("08 §3's receipt, every count the same" if not texts["stale_08"] else
               "08 §3's receipt and counts, the same as the core receipt at the run base, where 08 §3 still named an "
               "earlier one")
    found = (f"; {len(failed)} failed on main and kept as findings, each one's records on their old binding and no Lean "
             f"changed: {', '.join(failed)}" if failed else "")
    axioms = json.loads((OUT / "axiom_texts.json").read_text()) if (OUT / "axiom_texts.json").exists() else {}
    stamps = (f"; the run's stamp in {len(swap['swapped'])} records' validation_scope swapped for the renewed run's "
              "where the module is unchanged between the two runs"
              + (" or only its axiom reports changed and the record's axiom sentences were brought to the renewed "
                 "receipt" if set(swap["swapped"]) & set(axioms) else "") if swap and swap["swapped"] else "")
    dated, left_dated, kept = ((swap or {}).get(k, {}) for k in ("dated", "left_dated", "dates_kept"))
    recs = lambda d: f"{len(d)} record{'s' * (len(d) != 1)}"
    dates_text = ((f"; on the coordinator's word, the earlier passing date in the validation_scope of {recs(dated)} "
                   "swapped for the renewed older-layout receipt's, where the audit total is unchanged and "
                   + ("either the bound module keeps every axiom report or the record's axiom sentences were brought to "
                      "the renewed receipt" if set(dated) & set(axioms) else "the bound module keeps every axiom report")
                   if dated else "")
                  + (f"; the earlier passing date kept in {recs(left_dated)}, the guard failing: "
                     + ", ".join(f"{rid} {why.split(':')[0]}" for rid, why in sorted(left_dated.items()))
                     if left_dated else "")
                  + (f"; the earlier passing date kept in the validation_scope of {recs(kept)}, the date swap not run"
                     if kept else ""))
    homes = len({(c["file"], rid) for rid, v in axioms.items() for c in v["chapter"]})
    sentences = ("" if not axioms else
                 f"; for that reason the axiom sentences (in "
                 + " and ".join(sorted({f.strip("/").split("/")[0] for v in axioms.values() for f in v["fields"]}))
                 + f") of {recs(axioms)}"
                 + (f", and the {homes} home section{'s' * (homes != 1)} stating the same figures," if homes else "")
                 + " brought to the renewed receipts' axiom reports, mechanically from their data, each with one "
                 "history note: " + ", ".join(sorted(axioms))
                 + (f"; the records citing the changed part of those home sections re-pointed by hash: "
                    f"{', '.join(texts.get('home_drift', []))}" if texts.get("home_drift") else ""))
    said = (", nothing they say changed" + (" but the axiom sentences and swaps named next" if axioms else
                                            " but the swaps named next" if stamps or dated else ""))
    lines = BOARD.read_text(encoding="utf-8").split("\n")
    rows = [i for i, line in enumerate(lines) if line.startswith("| **RV21c: ")]
    assert len(rows) == 1, rows
    cells = lines[rows[0]].split(" | ")
    assert len(cells) == 5, len(cells)
    # The claim, brought to what was done before the row moves (board_ue25.py's practice).
    for a, b in REPLACE:
        assert cells[0].count(a) == 1, a
        cells[0] = cells[0].replace(a, b)
    cells[2] = (f"landed {date} (study §{n}): core receipt `{core}`, every one of its {steps} Lean steps run; "
                f"{len(passed)} of the {total} stale periphery receipts renewed, reusing only this slot's retained "
                f"steps{found}{path}; {repointed}{said}"
                f"{stamps}{left_text}{older_text}{dates_text}{axioms_text}{sentences}; {chapter}; kit and outputs in "
                f"[rv21c-fresh-receipts](../../{WORK}/)")
    row = " | ".join(cells)
    row = re.sub(r"\]\(research/", "](../../research/", row)
    row = re.sub(r"\]\(\.\./sources/", "](../../../sources/", row)
    del lines[rows[0]]
    q = queue_line(lines)
    assert len(HEAD.findall(lines[q])) == 1 and lines[q].startswith("- **Queue:** RV21c at the head"), "RV21c not at the head"
    lines[q] = HEAD.sub("", lines[q], count=1)
    only = ("receipts and the axiom sentences stating their reports" if axioms else "receipts only")
    landed = (f"RV21c landed (§{n}, {only}, no Lean changed and no statement changed: the twenty-first review's "
              f"§6 item 9 as the coordinator widened it; core receipt `{core}` with every one of its {steps} Lean steps "
              "run and every log kept, so a verifier needs no cache (its README says how to repeat it); the periphery "
              "receipts binding core bytes changed since rerun one at a time on this slot's cache, reusing only steps "
              f"this slot's runs ran and kept, the checkers on 4.30.0-rc2 on the pinned Mathlib build, "
              f"{len(passed)} of {total} renewed{found}{path}; {repointed}"
              f"{said}{stamps}{left_text}{older_text}{dates_text}{axioms_text}{sentences}; the core-bound records keep their "
              f"bindings; {chapter}, "
              "and a sentence naming "
              "the fresh receipt as the one a verifier repeats; RV21c's row in the history file; render, strict check, "
              f"links and tests pass). {order} ")
    lines[q] = lines[q].replace("- **Queue:** ", "- **Queue:** " + landed, 1)
    BOARD.write_text("\n".join(lines), encoding="utf-8")
    history = HISTORY.read_text(encoding="utf-8").split("\n")
    lapsed = history.index("## Lapsed claims (18 October 2026)")
    end = lapsed - 1
    while not history[end].startswith("| "):
        end -= 1
    history.insert(end + 1, row)
    HISTORY.write_text("\n".join(history), encoding="utf-8")
    print(f"land: clause written, row moved after history line {end + 1}")


if __name__ == "__main__":
    if sys.argv[1:2] == ["head"]:
        head(Path(sys.argv[2]) if len(sys.argv) > 2 else BOARD)
    elif sys.argv[1:2] == ["check"]:
        assert len(sys.argv) == 5, __doc__
        check(Path(sys.argv[2]), Path(sys.argv[3]), sys.argv[4])
    elif sys.argv[1:2] == ["land"]:
        assert len(sys.argv) == 6, __doc__
        land(sys.argv[2], int(sys.argv[3]), sys.argv[4], sys.argv[5])
    else:
        raise SystemExit(__doc__)
