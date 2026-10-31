#!/usr/bin/env python3
"""RV21c: check that the re-point changed only bookkeeping, record by record, against the committed records.

For every record that differs from BASE (default HEAD): only `proof_bindings[*].receipt`, `references` and, where
`swap_stamps.py` ran, the stamp inside `validation_scope` may differ. Every binding whose receipt changed must have
named, before, one of the 25 checkers' pointer or runs (`kit.bound_here`), and must now name that checker's renewed
run, whose checker passed. A reference may only gain the new run's receipt entry, or change the sha256 it pins for a
path RV21c rewrote (a renewed pointer, the core pointer, 08, the study, the generated data: `kit.MINE`); no reference
is removed or renamed, and no other pinned hash moves; an older-layout receipt renewed in place
(`out/older.json`) may have its pinned hash moved, its binding keeping the path. A `validation_scope` text may differ only by the swaps `swap_stamps.py`
made for that record (`swapped`, a renewed checker's old stamp turning into its new one) and the passing dates it
lists under `dated` (out/swap.json). A record whose axiom sentences axiom_texts.py brought to the renewed receipt
(out/axiom_texts.json) may differ, besides, in exactly those fields, each from the old text it recorded to the new, and
by the one history note it appended; such a record may not appear under `left`, `left_dated`, `earlier` or
`dates_kept` in out/swap.json for a receipt it was rewritten from (out/axiom_texts.json `receipts`), since its stamp
or date would then name an earlier run than the figures it states (axiom_texts.py stops on the same case at the gate,
by swap_stamps.kept_earlier). A
record file no commit holds is a new record and fails. Anything else fails.

usage: check_repoint.py [BASE]   -> prints the records checked and exits 1 on any other change
"""
import copy
import json
from pathlib import Path
import subprocess
import sys

from kit import MINE, OUT, RECEIPTS, RECORDS, REPO, bound_here, load, run_receipt, runs_folder, stem
from axiom_texts import get, put


def committed(path, base):
    p = subprocess.run(["git", "show", f"{base}:{path}"], cwd=REPO, capture_output=True, text=True)
    return json.loads(p.stdout) if p.returncode == 0 else None


def main():
    base = sys.argv[1] if len(sys.argv) > 1 else "HEAD"
    status = json.loads((OUT / "status.json").read_text())
    renewed = {}
    for pointer in RECEIPTS:
        s = stem(pointer)
        if status.get(s, {}).get("passed"):
            # BASE already holds the renewed pointers (run.sh committed them), so the old stamp is status.json's.
            new = load(pointer)
            assert new["utc"] == status[s]["utc"], s
            renewed[s] = {"pointer": pointer, "folder": runs_folder(pointer, new),
                          "run": run_receipt(pointer, new), "old_utc": status[s]["previous_utc"],
                          "new_utc": new["utc"]}
    older = json.loads((OUT / "older.json").read_text()) if (OUT / "older.json").exists() else {}
    swap = json.loads((OUT / "swap.json").read_text()) if (OUT / "swap.json").exists() else {}
    dated, swaps = swap.get("dated", {}), swap.get("swapped", {})
    axioms = json.loads((OUT / "axiom_texts.json").read_text()) if (OUT / "axiom_texts.json").exists() else {}
    rehashed = MINE | {r for r, v in older.get("receipts", {}).items() if v["passed"]}
    changed = subprocess.run(["git", "diff", "--name-only", base, "--", RECORDS + "/*.json"], cwd=REPO,
                             capture_output=True, text=True).stdout.split()
    # A record file no commit holds yet is a new record, which RV21c never writes.
    changed += subprocess.run(["git", "ls-files", "--others", "--exclude-standard", "--", RECORDS + "/*.json"],
                              cwd=REPO, capture_output=True, text=True).stdout.split()
    problems = []
    for path in changed:
        before, after = committed(path, base), json.loads((REPO / path).read_text())
        rid = after.get("id", Path(path).stem)
        if before is None:
            problems.append(f"{rid}: a new record")
            continue
        # The record as axiom_texts.py left it: its rewritten fields, from the old text it recorded, and its note.
        expected = copy.deepcopy(before)
        for p, (a, b) in axioms.get(rid, {}).get("fields", {}).items():
            if get(expected, p) != a:
                problems.append(f"{rid}: {p} is not the text axiom_texts.py rewrote")
            put(expected, p, b)
        if rid in axioms:
            expected["history"] = expected.get("history", []) + [axioms[rid]["note"]]
        keys = set(before) | set(after)
        for k in sorted(keys - {"proof_bindings", "references", "validation_scope"}):
            if expected.get(k) != after.get(k):
                problems.append(f"{rid}: field {k} changed")
        ob, nb = before.get("proof_bindings", []), after.get("proof_bindings", [])
        if len(ob) != len(nb):
            problems.append(f"{rid}: proof_bindings count {len(ob)} -> {len(nb)}")
        for o, n in zip(ob, nb):
            if {k: v for k, v in o.items() if k != "receipt"} != {k: v for k, v in n.items() if k != "receipt"}:
                problems.append(f"{rid}: a binding changed beyond its receipt")
            if o.get("receipt") != n.get("receipt"):
                owner = [r for r in renewed.values() if bound_here(o.get("receipt", ""), r["pointer"], r["folder"])]
                if len(owner) != 1 or n.get("receipt") != owner[0]["run"]:
                    problems.append(f"{rid}: binding {o.get('source')} {o.get('receipt')} -> {n.get('receipt')}")
        orf = {r.get("path"): r for r in before.get("references", [])}
        nrf = {r.get("path"): r for r in after.get("references", [])}
        if set(orf) - set(nrf):
            problems.append(f"{rid}: references removed {sorted(set(orf) - set(nrf))}")
        for p in set(nrf) - set(orf):
            if p not in {r["run"] for r in renewed.values()} or nrf[p].get("role") != "receipt":
                problems.append(f"{rid}: reference added {p}")
        for p in set(orf) & set(nrf):
            if {k: v for k, v in orf[p].items() if k != "sha256"} != {k: v for k, v in nrf[p].items() if k != "sha256"}:
                problems.append(f"{rid}: reference {p} changed beyond its sha256")
            elif orf[p].get("sha256") != nrf[p].get("sha256") and p not in rehashed:
                problems.append(f"{rid}: reference {p} re-hashed, but RV21c did not rewrite it")
        ov, nv = json.dumps(expected.get("validation_scope"), ensure_ascii=False), \
            json.dumps(after.get("validation_scope"), ensure_ascii=False)
        if ov != nv:
            # Only the swaps swap_stamps.py made for this record (none without SWAP=1), then its dated pairs.
            swapped = ov
            for s_, a, b in swaps.get(rid, []):
                assert s_ in renewed and (a, b) == (renewed[s_]["old_utc"], renewed[s_]["new_utc"]), (rid, s_)
                swapped = swapped.replace(a, b)
            for a, b in dated.get(rid, []):
                swapped = swapped.replace(a, b)
            if swapped != nv:
                problems.append(f"{rid}: validation_scope changed beyond a stamp swap"
                                + (" and its axiom sentences" if rid in axioms else ""))
    # A record whose axiom sentences now state a renewed receipt's figures must name that receipt's renewed run: the
    # swaps may not have left it naming an earlier run of a receipt it was rewritten from (a listing that comes from
    # another binding of the record is not this case).
    for rid in sorted(axioms):
        stems, older_names = set(), set()
        for receipt in axioms[rid].get("receipts", []):
            owner = [stem(q) for q in RECEIPTS if bound_here(receipt, q, runs_folder(q, load(q)))]
            stems |= set(owner)
            older_names |= set() if owner else {Path(receipt).parent.name}
        hits = [f"earlier {e}" for e in swap.get("earlier", {}).get(rid, []) if e[0] in stems]
        hits += [f"left ({swap['left'][rid]})"] if swap.get("left", {}).get(rid, ":").split(":")[0] in stems else []
        hits += ([f"left_dated ({swap['left_dated'][rid]})"]
                 if swap.get("left_dated", {}).get(rid, ":").split(":")[0] in older_names else [])
        hits += ["dates_kept"] if rid in swap.get("dates_kept", {}) and older_names else []
        if hits:
            problems.append(f"{rid}: its axiom sentences were brought to the renewed receipt, but the swaps left it "
                            f"naming an earlier run of it: {'; '.join(hits)}")
    print(f"records changed: {len(changed)}; problems: {len(problems)}")
    for p in problems:
        print("  " + p)
    sys.exit(1 if problems else 0)


if __name__ == "__main__":
    main()
