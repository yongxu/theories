#!/usr/bin/env python3
"""RV21c: in the records that bind a renewed periphery receipt, swap the old run's stamp in `validation_scope`.

A record's `validation_scope` may name the run its proof binding names ("bound to fallible-inquiry-checks/<stamp>").
After `repoint_all.py --apply` the binding names the renewed run, so the prose would name a run the record no longer
binds. For every record re-pointed (`out/repoint.json`), each occurrence of the renewed checker's old stamp in
`validation_scope` (every language) becomes the new stamp, and nothing else changes; only where `out/compare.json`
shows the checker's module unchanged (no declaration added or removed, no axiom report changed, no printed signature
changed where both runs kept one), so whatever the prose says of the cited declarations stays true. A record that
fails the guard is left as it is and listed. A record whose `validation_scope` names another, earlier run of the
same checker (not the one its binding named) keeps that stamp, since the prose may describe that run; it is listed
under `earlier`, for the texts. One line in `_process/architecture/rebinds.jsonl` records the swap.

The older-layout receipts renewed in place (`out/older.json`) have no stamp; their records' `validation_scope` names
the day the receipt passed ("passed 7 October 2026", "2026年10月7日通过"). That is prose, not the token the coordinator
agreed to swap, so it changes only with --dates (land.sh's SWAP_DATES=1, on the coordinator's own word): the date
becomes the renewed receipt's (its `checked_at_utc`, UTC), only where the module the record binds keeps every axiom
report and the receipt's audit total is unchanged (`dated`); a record failing that guard is left and listed under
`left_dated`, apart from the stamp cases; without --dates the records that would pass it keep the earlier date and are
listed under `dates_kept`, so the texts can say so.

A record whose axiom sentences axiom_texts.py brought to the renewed receipt (`out/axiom_texts.json`) describes the
renewed run, so for it the guards give way on the axiom reports (the coordinator's ruling of 31 October): its stamp is
swapped though its module's reports changed (declarations and signatures still guarded), and its passing date though
its bound module's reports changed (the audit total still guarded).

usage: swap_stamps.py [--apply] [--dates]   -> prints the records swapped and the records left; writes out/swap.json
"""
import datetime as _dt
import json
from pathlib import Path
import subprocess
import sys

from kit import OUT, RECEIPTS, RECORDS, REPO, bound_here, load, runs_folder, stem

LOG = REPO / "_process/architecture/rebinds.jsonl"


def unchanged(row):
    mods = row["modules"].values()
    same = all(not m["removed"] and not m["added"] and not m["axioms_changed"] for m in mods)
    return same and not row.get("signatures_changed")


def same_declarations(row):
    """No declaration added or removed and no printed signature changed: what still guards a rewritten record."""
    mods = row["modules"].values()
    return all(not m["removed"] and not m["added"] for m in mods) and not row.get("signatures_changed")


def other_stamps(pointer, row):
    """The checker's run folders other than the two the comparison names: earlier runs a record may describe."""
    folder = REPO / runs_folder(pointer, load(pointer))
    return {f.name for f in folder.iterdir() if f.is_dir()} - {row["old_utc"], row["new_utc"]}


def stamp_outcome(text, s, row, stamps, rewritten):
    """What the stamp swap does with one record's validation_scope text for one renewed periphery checker: the
    earlier runs it names (kept, listed under `earlier`), and ("left", why), ("swap", (old, new)), or None where it
    names no stamp of the binding's run. A record whose axiom sentences were rewritten (`rewritten`) passes on the
    declarations and signatures alone."""
    old, new = row["old_utc"], row["new_utc"]
    named = sorted(t for t in stamps if t in text)
    if old not in text:
        return named, None
    if "signatures_compared" not in row:
        return named, ("left", f"{s}: signatures not compared, {row.get('signatures', 'no log')}")
    if not (unchanged(row) or rewritten and same_declarations(row)):
        return named, ("left", f"{s}: the module changed between {old} and {new}")
    return named, ("swap", (old, new))


def date_outcome(text, receipt, row, rid, rewritten, dates):
    """What the date swap does with one record's validation_scope text for one renewed older-layout receipt: None
    where it names no earlier passing date, else ("left_dated", why), ("dates_kept", pairs) or ("dated", pairs)."""
    od = _dt.datetime.fromisoformat(row["old_checked_at_utc"]).astimezone(_dt.timezone.utc).date()
    nd = _dt.datetime.fromisoformat(row["new_checked_at_utc"]).astimezone(_dt.timezone.utc).date()
    pairs = [[f"passed {od.day} {od:%B} {od.year}", f"passed {nd.day} {nd:%B} {nd.year}"],
             [f"{od.year}年{od.month}月{od.day}日通过", f"{nd.year}年{nd.month}月{nd.day}日通过"]]
    found = [pr for pr in pairs if pr[0] in text]
    if not found or od == nd:
        return None
    changed = [m for m in row["bound_modules"].get(rid, []) if m in row["axioms_changed"] and not rewritten]
    if changed or row["audits"][0] != row["audits"][1]:
        return ("left_dated", f"{Path(receipt).parent.name}: axiom reports changed in {changed}" if changed else
                f"{Path(receipt).parent.name}: audits {row['audits'][0]} -> {row['audits'][1]}")
    return ("dates_kept", found) if not dates else ("dated", found)


def kept_earlier(rid, text, receipt, dates):
    """Why the swaps would leave this record naming an earlier run than one renewed receipt it binds, were its axiom
    sentences rewritten from that receipt (or None): the stamp left or an earlier run named, for a periphery checker;
    the date left or kept, for an older-layout receipt. axiom_texts.py stops on it at the gate, check_repoint.py after
    the swaps, both by this function, so the two agree."""
    for pointer in RECEIPTS:
        if bound_here(receipt, pointer, runs_folder(pointer, load(pointer))):
            s = stem(pointer)
            row = json.loads((OUT / "compare.json").read_text()).get(s)
            if row is None:
                return f"{s}: not compared"
            named, outcome = stamp_outcome(text, s, row, other_stamps(pointer, row), True)
            if named:
                return f"{s}: it names an earlier run, {', '.join(named)}"
            return outcome[1] if outcome and outcome[0] == "left" else None
    row = json.loads((OUT / "older.json").read_text())["receipts"][receipt]
    outcome = date_outcome(text, receipt, row, rid, True, dates)
    if outcome and outcome[0] == "dates_kept":
        return f"{Path(receipt).parent.name}: the date swap not run"
    return outcome[1] if outcome and outcome[0] == "left_dated" else None


def main():
    apply = "--apply" in sys.argv
    dates = "--dates" in sys.argv
    repoint = json.loads((OUT / "repoint.json").read_text())
    compare = json.loads((OUT / "compare.json").read_text())
    swapped, left, earlier, dated, left_dated, dates_kept = {}, {}, {}, {}, {}, {}
    rewritten = (set(json.loads((OUT / "axiom_texts.json").read_text())) if (OUT / "axiom_texts.json").exists()
                 else set())
    for pointer in RECEIPTS:
        s = stem(pointer)
        rp = repoint.get(s, {})
        if not rp.get("records") or rp.get("skipped"):
            continue
        row = compare[s]
        old, new = row["old_utc"], row["new_utc"]
        stamps = other_stamps(pointer, row)
        for rid in rp["records"]:
            path = REPO / RECORDS / f"{rid}.json"
            raw = path.read_text()
            d = json.loads(raw)
            text = json.dumps(d.get("validation_scope"), ensure_ascii=False)
            named, outcome = stamp_outcome(text, s, row, stamps, rid in rewritten)
            if named:
                earlier.setdefault(rid, []).append([s, *named])
            if outcome is None:
                continue
            if outcome[0] == "left":
                left[rid] = outcome[1]
                continue
            d["validation_scope"] = json.loads(text.replace(old, new))
            swapped.setdefault(rid, []).append([s, old, new])
            if apply:
                path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + "\n")
    older = json.loads((OUT / "older.json").read_text()) if (OUT / "older.json").exists() else {}
    for receipt, row in older.get("receipts", {}).items():
        if not row["passed"]:
            continue
        for rid in row["records"]:
            path = REPO / RECORDS / f"{rid}.json"
            d = json.loads(path.read_text())
            text = json.dumps(d.get("validation_scope"), ensure_ascii=False)
            outcome = date_outcome(text, receipt, row, rid, rid in rewritten, dates)
            if outcome is None:
                continue
            if outcome[0] == "left_dated":
                left_dated[rid] = outcome[1]
                continue
            found = outcome[1]
            if outcome[0] == "dates_kept":
                dates_kept[rid] = found
                continue
            for a, b in found:
                text = text.replace(a, b)
            d["validation_scope"] = json.loads(text)
            dated[rid] = found
            if apply:
                path.write_text(json.dumps(d, ensure_ascii=False, indent=2) + "\n")
    if apply and dated:
        base = subprocess.run(["git", "rev-parse", "--short=9", "HEAD"], cwd=REPO, capture_output=True,
                              text=True).stdout.strip()
        line = {"date": _dt.datetime.now(_dt.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"), "base": base,
                "reason": ("RV21c: validation_scope's passing date swapped for the renewed older-layout receipt's, "
                           "where the audit total is unchanged and the bound module keeps every axiom report"
                           + (", or, in the records whose axiom sentences axiom_texts.py brought to the renewed "
                              "receipt's reports in the same step (the coordinator's ruling of 31 October; each with "
                              "one history note), though its reports changed: " + ", ".join(sorted(set(dated) & rewritten))
                              if set(dated) & rewritten else "; nothing else changed")),
                "records": sorted(dated), "paths": [], "receipt": None,
                "swaps": {rid: v for rid, v in sorted(dated.items())}}
        with LOG.open("a") as stream:
            stream.write(json.dumps(line, ensure_ascii=False) + "\n")
    if apply and swapped:
        base = subprocess.run(["git", "rev-parse", "--short=9", "HEAD"], cwd=REPO, capture_output=True,
                              text=True).stdout.strip()
        line = {"date": _dt.datetime.now(_dt.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"), "base": base,
                "reason": ("RV21c: validation_scope's receipt stamp swapped for the renewed run's in the records "
                           "re-pointed to it, where the checker's module is unchanged between the two runs "
                           "(no declaration, axiom report or printed signature changed)"
                           + (", or only its axiom reports changed, in the records whose axiom sentences "
                              "axiom_texts.py brought to the renewed receipt's reports in the same step (the "
                              "coordinator's ruling of 31 October; each with one history note): "
                              + ", ".join(sorted(set(swapped) & rewritten))
                              if set(swapped) & rewritten else "; nothing else changed")),
                "records": sorted(swapped), "paths": [], "receipt": None,
                "swaps": {rid: v for rid, v in sorted(swapped.items())}}
        with LOG.open("a") as stream:
            stream.write(json.dumps(line, ensure_ascii=False) + "\n")
    (OUT / ("swap.json" if apply else "swap-dry.json")).write_text(
        json.dumps({"swapped": swapped, "left": left, "earlier": earlier, "dated": dated, "left_dated": left_dated,
                    "dates_kept": dates_kept, "dates_asked": dates}, indent=1, ensure_ascii=False) + "\n")
    print(f"swapped {len(swapped)}: {' '.join(sorted(swapped))}")
    print(f"dates swapped {len(dated)}: {' '.join(sorted(dated))}")
    print(f"left {len(left)}: " + "; ".join(f"{k} ({v})" for k, v in sorted(left.items())))
    print(f"dates left by the guard {len(left_dated)}: " + "; ".join(f"{k} ({v})" for k, v in sorted(left_dated.items())))
    print(f"dates kept, --dates not given {len(dates_kept)}: {' '.join(sorted(dates_kept))}")
    print(f"naming an earlier run, kept {len(earlier)}: " + "; ".join(f"{k} {v}" for k, v in sorted(earlier.items())))


if __name__ == "__main__":
    main()
