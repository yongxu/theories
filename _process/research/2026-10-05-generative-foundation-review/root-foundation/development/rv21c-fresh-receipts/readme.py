#!/usr/bin/env python3
"""RV21c: the fresh core receipt's README, written into its run folder from the runs (out/verify.json, status.json).

It says what a verifier needs and where it is: how the receipt was made (every Lean step run, on an empty cache),
what must agree when it is repeated elsewhere, how the periphery receipts of the same slot reused steps (only from
earlier runs of this slot under the same toolchain, counted by the run they came from), the toolchains and the pinned
Mathlib the checkers on 4.30.0-rc2 use (never rebuilt here), what the folders leave out and why, and that the
core-bound records keep their bindings while this run rebuilt every core step on that commit (with the bindings to
copies inside old run folders named as exceptions).

usage (from the checkout root of the landing worktree): RV21C_CACHE=<slot cache> readme.py CORE_UTC
"""
import json
from pathlib import Path
import sys

from kit import CORE_RUNS, KIT_PATH, OUT, PKG, RECEIPTS, REPO, copies, stem

MATHLIB_PROJECT = Path.home() / "repos/生生不息"


def main():
    core_utc = sys.argv[1]
    folder = REPO / CORE_RUNS / core_utc
    core = json.loads((folder / "verification.json").read_text())
    verify = json.loads((OUT / "verify.json").read_text())
    status = json.loads((OUT / "status.json").read_text())
    manifest = json.loads((MATHLIB_PROJECT / "lake-manifest.json").read_text())
    mathlib = next(p for p in manifest["packages"] if p["name"] == "mathlib")
    toolchain_rc = (MATHLIB_PROJECT / "lean-toolchain").read_text().strip()
    revisions = {verify[s].get("mathlib_revision") for s in verify if s != "core" and not verify[s].get("failed")}
    revisions.discard(None)
    assert revisions <= {mathlib["rev"]}, ("a periphery receipt names another Mathlib", revisions, mathlib["rev"])
    up = "../../../../../../../../"
    rows = []
    for p in RECEIPTS:
        s, v, st = stem(p), verify[stem(p)], status[stem(p)]
        name = s.removesuffix("-verification")
        if st["passed"]:
            runs = str(Path(p).parent / st["retained_run"])
            came = v.get("reused_from", {})
            order = sorted(came, key=lambda k: (k != "core", -came[k], k))
            reused = ", ".join(f"{k.removesuffix('-verification')} {came[k]}" for k in order) or "none"
            rows.append(f"| [{name}]({up}{runs}/verification.json) | {v['toolchain'].split(':')[-1]} "
                        f"| {v['ran']} | {reused} |")
        else:
            kept = ", ".join(f"`{f}`" for f in st.get("new_folders") or []) or f"output in `{KIT_PATH}/out/{s}.log`"
            rows.append(f"| {name} (failed, kept as a finding: {kept}) | | | |")
    rc2 = [s for s in verify if s != "core" and not verify[s].get("failed") and verify[s].get("mathlib_revision")]
    exceptions = copies()
    built = [q.name for q in folder.rglob("*") if q.suffix in (".olean", ".ilean", ".c")]
    assert not built, ("compiled outputs in the run folder; the README says none is kept", built[:5])
    older = json.loads((OUT / "older.json").read_text()) if (OUT / "older.json").exists() else {}
    older_text = ""
    if older.get("receipts"):
        lines = []
        for r, v in older["receipts"].items():
            name = "/".join(Path(r).parts[-3:-1]) if "development" in r else Path(r).parent.name
            if v["passed"]:
                changed = ", ".join(sorted(v["axioms_changed"])) or "none"
                lines.append(f"| [{name}]({up}{r}) | {v['old_checked_at_utc'][:10]} | {v['new_checked_at_utc'][:10]} "
                             f"| {v['audits'][0]} → {v['audits'][1]} | {changed} | {len(v['records'])} |")
            else:
                unclean = "; ".join(f"{u['module']} exited {u['exit']}" for u in v.get("unclean", []))
                why = (f"not run, since {v['not_run']}" if v.get("not_run") else None) or (f"failed ({unclean or 'see the log'}), kept as a finding: output in `{KIT_PATH}/out/older-{Path(r).parent.name}.log`"
                                           + (f", the files it rewrote in `{v['failed_copy']}/`" if v.get("failed_copy") else ""))
                lines.append(f"| {name} | {v['old_checked_at_utc'][:10]} | {why} | | | {len(v['records'])}, kept on the old receipt |")
        unbound, kept = older.get("not_renewed", []), older.get("kept_copies", [])
        nrec = len({rid for v in older["receipts"].values() for rid in v["records"]})
        files = "`FormedSelection`, `ResourceContinuation` or `FormationSupport`"
        older_text = (
            f"\n\n**Older-layout receipts.** {nrec} records bind receipts written before run folders under a pointer, "
            "whose closures held `FormedSelection.lean` at bytes from before 8 October (one `set_option` line added "
            "to drop a propext dependency). After the periphery, their chain was rerun by its own checkers on Lean "
            "4.29.1 with Std, the formal receipt they inherit from first, a failure stopping the chain; a checker "
            "that passed rewrote its `verification.json` in place, the earlier bytes in git history and their hashes "
            "in `_process/architecture/rebinds.jsonl`, and kept its run's files in a new folder under `checks/` beside "
            "it where its checker writes one. Axiom reports are compared module by module with the earlier "
            "receipt's.\n\n"
            "| receipt | passed before | now | audits | axiom reports changed in | records |\n|---|---|---|---|---|---|\n"
            + "\n".join(lines)
            + (f"\n\nNot renewed, because no record binds them: {len(unbound)} live receipts outside this chain that "
               f"record {files} at bytes other than main's. A later rerun of any of them would meet the new hashes."
               "\n\n" + "\n".join(f"- `{u['receipt']}` ({', '.join(u['stale'])})" for u in unbound)
               if unbound else "")
            + (f"\n\nAlso stale in the same files, and kept as evidence of earlier attempts rather than live "
               f"receipts (no checker beside them, or a folder named as an earlier attempt): {len(kept)}.\n\n"
               + "\n".join(f"- `{u['receipt']}` ({', '.join(u['stale'])})" for u in kept)
               if kept else ""))
    exception_text = ("" if not exceptions else
                      " The exceptions bind copies kept inside old run folders and keep those runs as their only "
                      "receipt: " + "; ".join(f"{rid} (`{src}`)" for rid, src in exceptions) + ".")
    main_commit = core["source_commit"]["main"]
    steps = len(core["lean_steps"]["keys"])
    text = f"""# Core receipt {core_utc}: every Lean step run

This receipt is the one a verifier can repeat ([the twenty-first review](../../../../../../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-TWENTY-FIRST-REVIEW.md#6-errors-overstatements-and-stale-text-found), §6 item 9; RV21c). It was made with `BECOMING_FRESH=1` on an empty step cache kept for this slot alone, so every one of its {steps} keyed Lean steps ran here, none was reused, and each step's log (with each audit step's driver) is in this folder. It ran on main `{main_commit[:9]}`, which held every source byte for byte, so nothing was copied (`source_commit` names the commit, `source_sha256` each file).

**To repeat it.** On that commit, with Lean {core['lean_version'].split(',')[0].removeprefix('Lean (version ')} (`elan`, the package's `lean-toolchain`; the binary's sha256 is `lean_binary_sha256`):

    cd {PKG}
    BECOMING_FRESH=1 BECOMING_LEAN_CACHE=$(mktemp -d) python3 -B check_becoming.py

and compare the new run with this one. On any machine the declarations and axiom reports in `verification.json`, the printed types in the `*Signatures.log` files of this folder, and `source_sha256` must agree. The step keys (`lean_steps.keys`) agree only with the same Lean binary, since they hash its sha256 (`lean_binary_sha256`); `lean_version`, `lean_binary_sha256`, the stamps and the paths may differ.

**The core-bound records.** Each record's proof binding keeps, as its provenance, a core run that checked the bound bytes; none was re-pointed. This run rebuilt every core file present on main at `{main_commit[:9]}` from nothing, so for every core binding whose source is a package file on main at that commit it is the run a verifier repeats.{exception_text} Modules added after that commit are checked by later receipts, not by this one.

**The periphery receipts of the same slot.** The periphery receipts whose closures had changed since their last run were rerun one at a time after this receipt, on the same slot cache. A checker reused a step only where an earlier run of this slot under the same toolchain (this receipt's run, or an earlier periphery checker's) had run it and kept its log; the keys hash the toolchain and the Lean binary, so the checkers on {toolchain_rc.split(':')[-1]} share none with this receipt. Each reused step names the run it came from (`lean_steps.reused`, `utc`), and that run's folder holds its log; the table counts them by run. The `retained` paths there name the landing worktree, which became this repository; read them by stamp.

| receipt | toolchain | steps run | steps reused, by the run they came from |
|---|---|---|---|
{chr(10).join(rows)}

**Mathlib** is used by the checkers on {toolchain_rc.split(':')[-1]} only: the pinned build, never rebuilt here, revision `{mathlib['rev']}` ({mathlib.get('url', 'mathlib4')}), with {toolchain_rc}, as those {len(rc2)} receipts record (`mathlib_revision`). A verifier fetches it by that pin. The checkers on Lean 4.29.1 use no Mathlib.{older_text}

**Left out.** No cache, `.lake` or `.build` is kept, and no compiled `.olean`: the logs and drivers are what a verifier needs to repeat and compare the runs, and the outputs are rebuilt from the sources. Nothing else was left out.
"""
    (folder / "README.md").write_text(text, encoding="utf-8")
    print(f"README written in {folder.relative_to(REPO)}")


if __name__ == "__main__":
    main()
