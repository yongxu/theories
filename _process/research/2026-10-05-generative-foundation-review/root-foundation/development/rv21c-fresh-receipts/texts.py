#!/usr/bin/env python3
"""RV21c's texts, from the runs: 08 §3's receipt sentence and the study section.

08 §3 ("Rings and receipts") names the core receipt and its counts; every core landing rewrites the sentence from
its receipt (reland_ue25.py's code). The fresh run checks the same bytes as the core receipt on main when the runs
began (BASE's pointer): their `source_paths` and `source_sha256` must be equal, and so must every count; only the
receipt changes. 08 §3 should name BASE's receipt, since every core landing rewrites the sentence from its own run; if it
names an earlier one, the sentence is brought to the fresh receipt's counts all the same (the coordinator's word,
31 October), under the same gate (the fresh run's source hashes and counts equal BASE's receipt's), and the study
says where the counts came from. After the sentence goes one naming the fresh receipt by its stamp and commit (so a
later landing, rewriting the counts and adding modules, leaves it true): the fresh run rebuilt every core step from
nothing on main at that commit, and each record's proof binding keeps a run that checked the bound bytes. The study
section, appended to BECOMING-RENEWAL-READING.md as section N, is written from out/receipts.json, verify.json,
status.json, compare.json, repoint.json and swap.json (when the swap ran).

usage (from the checkout root of the landing worktree):
  texts.py --check CORE_UTC BASE [--chapter PATH]   compare only, write nothing (run before the head is claimed;
                                                   PATH, a copy of main's 08, instead of the checkout's)
  texts.py CORE_UTC BASE N                          write 08 §3 and the study's section N
"""
import json
from pathlib import Path
import re
import subprocess
import sys

import kit
from kit import CORE_POINTER, CORE_RUNS, OUT, PKG, RECEIPTS, REPO, copies, stem

CHAPTER_ARG = sys.argv[sys.argv.index("--chapter") + 1] if "--chapter" in sys.argv else None
ARGS = [a for a in sys.argv[1:] if not a.startswith("--") and a != CHAPTER_ARG]
CHECK = "--check" in sys.argv
assert CHAPTER_ARG is None or CHECK, "--chapter only with --check"
CORE_UTC, BASE = ARGS[0], ARGS[1]
N = None if CHECK else int(ARGS[2])
STUDY = REPO / kit.STUDY
CHAPTER = Path(CHAPTER_ARG) if CHAPTER_ARG else REPO / kit.CHAPTER
TITLE = "Fresh receipts: the core rebuilt from nothing and every stale periphery receipt rerun (RV21c)"
KIT = "development/rv21c-fresh-receipts"
SENTENCE = re.compile(
    r"At core receipt \[`([0-9TZ.]+)`\]\([^)]*\) \(Lean 4\.29\.1\), the closure held \d+ modules \(\d+ foundation, "
    r"\d+ core, \d+ in the instance and application ring\) and [\d,]+ theorems; the \d+ core modules held [\d,]+ of "
    r"them; [\d,]+ declarations were audited; \d+ generated `injEq` lemmas depend on `propext`; \d+ superseded "
    r"modules were kept out of the run\.")
FRESH_MARK = "rebuilt every core step from nothing"


def run_receipt(receipt):
    return json.loads((REPO / CORE_RUNS / receipt / "verification.json").read_text())


def sentence(receipt):
    R = run_receipt(receipt)
    assert R["status"] == "passed"
    layers = {}
    for module in R["modules"]:
        count = layers.setdefault(module["layer"], [0, 0])
        count[0] += 1
        count[1] += module["theorems"]
    assert set(layers) <= {"foundation", "core", "instance", "application"}, set(layers)
    modules = sum(v[0] for v in layers.values())
    theorems = sum(v[1] for v in layers.values())
    assert modules == len(R["core_closure"]), (modules, len(R["core_closure"]))
    ring = layers.get("instance", [0, 0])[0] + layers.get("application", [0, 0])[0]
    declarations = sum(len(m["declarations"]) for m in R["modules"])
    injeq = sum(1 for name, axioms in R["generated_axiom_dependencies"].items()
                if name.endswith(".injEq") and axioms == ["propext"])
    assert injeq == len(R["generated_axiom_dependencies"]), "a generated dependency other than injEq on propext"
    link = f"../../../{PKG}/becoming-checks/{receipt}/verification.json"
    return (f"At core receipt [`{receipt}`]({link}) (Lean 4.29.1), the closure held {modules} modules "
            f"({layers['foundation'][0]} foundation, {layers['core'][0]} core, {ring} in the instance and application "
            f"ring) and {theorems:,} theorems; the {layers['core'][0]} core modules held {layers['core'][1]:,} of them; "
            f"{declarations:,} declarations were audited; {injeq} generated `injEq` lemmas depend on `propext`; "
            f"{len(R['superseded_modules'])} superseded modules were kept out of the run."), R


def strip(t):
    return re.sub(r"\[`[0-9TZ.]+`\]\([^)]*\)", "[R](L)", t)


def compare():
    """What 08 §3 names, BASE's core receipt, and the fresh one: same bytes, same counts. Returns the facts."""
    s = CHAPTER.read_text(encoding="utf-8")
    found = SENTENCE.findall(s)
    assert len(found) == 1, found
    named, old_text = found[0], SENTENCE.search(s).group(0)
    base_utc = json.loads(subprocess.check_output(["git", "show", f"{BASE}:{CORE_POINTER}"], cwd=REPO))["utc"]
    base_text, B = sentence(base_utc)
    new_text, R = sentence(CORE_UTC)
    assert B["source_paths"] == R["source_paths"], "the fresh run's modules are not BASE's receipt's"
    differ = [n for n in R["source_sha256"] if B["source_sha256"].get(n) != R["source_sha256"][n]]
    assert not differ, ("the fresh run checked other bytes than BASE's receipt", differ[:5])
    assert strip(base_text) == strip(new_text), ("the counts changed", base_text, new_text)
    assert FRESH_MARK not in s, "08 §3 already names a fresh run"
    if named == base_utc:
        assert strip(old_text) == strip(base_text), ("08 §3's counts are not its receipt's", old_text, base_text)
    return {"text": s, "named": named, "old_text": old_text, "base_utc": base_utc, "new_text": new_text, "R": R}


def chapter(facts):
    R = facts["R"]
    link = f"../../../{PKG}/becoming-checks/{CORE_UTC}/"
    commit = R["source_commit"]["main"][:9]
    fresh = (f" The fresh run [`{CORE_UTC}`]({link}README.md) {FRESH_MARK} on main at `{commit}` and keeps every "
             "log, so a verifier can repeat it without this machine's cache; each record's proof binding keeps, as its "
             "provenance, a run that checked the bound bytes.")
    CHAPTER.write_text(facts["text"].replace(facts["old_text"], facts["new_text"] + fresh, 1), encoding="utf-8")


def mb(n):
    return f"{n / 1e6:.1f} MB"


def size(folder):
    files = [p for p in folder.rglob("*") if p.is_file()]
    return sum(p.stat().st_size for p in files)


def reused_from(v):
    came = v.get("reused_from", {})
    if not came:
        return "none"
    order = sorted(came, key=lambda k: (k != "core", -came[k], k))
    return ", ".join(f"{k.removesuffix('-verification')} {came[k]}" for k in order)


def home_drift_text(facts, axioms):
    """The records whose cited part of a rewritten home section changed: re-pointed by hash in the same step
    (repoint_texts.py, which re-points exactly these); kept in facts for texts.json, the board and the commit."""
    files = {c["file"] for v in axioms.values() for c in v["chapter"]}
    if not files:
        facts["home_drift"] = []
        return ""
    ids = sorted({x["id"] for x in kit.source_drift() if x["path"] in files})
    facts["home_drift"] = ids
    where = ", ".join(sorted(f.split("/")[-1] for f in files))
    return (f" The records whose cited part of {where} changed were re-pointed to it by hash in the same step "
            f"(repoint_texts.py): {', '.join(ids)}." if ids else
            f" No record cites the changed part of {where}, so none is re-pointed for it.")


def stretch(a, b):
    """The changed stretch of a sentence, widened to whole words: `old` → `new`."""
    i = 0
    while i < min(len(a), len(b)) and a[i] == b[i]:
        i += 1
    j = 0
    while j < min(len(a), len(b)) - i and a[-1 - j] == b[-1 - j]:
        j += 1
    while i > 0 and a[i - 1] not in " ，：":
        i -= 1
    while j > 0 and a[len(a) - j] not in " ，,;；":
        j -= 1
    return f"“{a[i:len(a) - j].strip(' ,')}” → “{b[i:len(b) - j].strip(' ,')}”"


def section(facts):
    plan = json.loads((OUT / "receipts.json").read_text())
    verify = json.loads((OUT / "verify.json").read_text())
    status = json.loads((OUT / "status.json").read_text())
    repoint = json.loads((OUT / "repoint.json").read_text())
    swap = json.loads((OUT / "swap.json").read_text()) if (OUT / "swap.json").exists() else None
    axioms = json.loads((OUT / "axiom_texts.json").read_text()) if (OUT / "axiom_texts.json").exists() else {}
    core = verify["core"]
    # The study says nothing was left out of the run folder; past 40 MB (the 16 October fresh receipt held 7.6 MB
    # for 703 steps) that is a judgment to make by hand first (the coordinator's condition 3), not to write blind.
    assert core["size"]["bytes"] < 40e6, ("the core run folder is large: decide what a verifier needs first",
                                          core["size"])
    assert plan["receipts"] == RECEIPTS
    passed = [stem(p) for p in RECEIPTS if status[stem(p)]["passed"]]
    failed = [stem(p) for p in RECEIPTS if not status[stem(p)]["passed"]]
    assert all(verify[s].get("fresh") is False or verify[s].get("reused") == 0 for s in passed)
    records = sorted({r for s in passed for r in repoint.get(s, {}).get("records", [])})
    rows, failed_bytes = [], 0
    for p in RECEIPTS:
        s = stem(p)
        v, st = verify[s], status[s]
        name = s.removesuffix("-verification")
        if st["passed"]:
            n = len(repoint.get(s, {}).get("records", []))
            rows.append(f"| {name} | `{st['previous_utc']}` | `{v['utc']}` | {v['modules']} | {v['ran']} | "
                        f"{reused_from(v)} | {st['seconds']} s | {mb(v['size']['bytes'])} | {n} |")
        else:
            kept = st.get("new_folders") or []
            failed_bytes += sum(size(REPO / f) for f in kept)
            where = ", ".join(f"`{Path(f).name}`" for f in kept) or f"output in `{KIT}/out/{s}.log`"
            rows.append(f"| {name} | `{st['previous_utc']}` | failed: {where}, kept as a finding | | | | "
                        f"{st['seconds']} s | | 0, kept on the old binding |")
    # The older-layout checkers that passed keep their runs in new folders under checks/ beside their receipts.
    older_runs = json.loads((OUT / "older.json").read_text()) if (OUT / "older.json").exists() else {}
    older_folders = sorted({f.split("/checks/")[0] + "/checks/" + f.split("/checks/")[1].split("/")[0]
                            for v in older_runs.get("receipts", {}).values() if v["passed"]
                            for f in v.get("changed", []) if "/checks/" in f})
    older_bytes = sum(size(REPO / f) for f in older_folders)
    total = sum(v.get("size", {}).get("bytes", 0) for v in verify.values()) + failed_bytes + older_bytes
    rc2 = [s for s in passed if verify[s].get("mathlib_revision")]
    old = [s for s in passed if (verify[s].get("toolchain") or "").endswith("4.29.1")]
    revisions = {verify[s]["mathlib_revision"] for s in rc2}
    assert len(revisions) <= 1, revisions
    gone = plan["earlier_unretained"]
    older = plan.get("older_layout", {})
    older_stale = {r: v for r, v in older.items() if v["stale"]}
    commit = (core["source_commit"] or {}).get("main", "")[:9]
    lines = [
        f"## {N}. {TITLE}",
        "",
        "The twenty-first review's §6 item 9 found that a verifier could not repeat the core receipt: it reused "
        "nearly every Lean step from a cache outside the repository. It also found `Becoming.FallibleInquiry`'s "
        "periphery receipt certified against an older core. The coordinator routed the item to the comprehensive "
        "review's session (RV21c) and widened it to every periphery receipt that binds core bytes changed since. "
        f"At the run base `{plan['rev'][:9]}`, `{KIT}/plan_receipts.py` read every record's proof bindings and "
        f"found {len(RECEIPTS)} periphery checkers whose bound runs bind such bytes, binding "
        f"{len({i for v in plan['records'].values() for i in v})} records.",
        "",
    ]
    if older:
        uncompared = {r: v for r, v in older.items() if not v.get("compared", True) and not v["stale"]}
        assert not any(v.get("unresolved_live") for v in older.values()), "an unresolved import has a live file"
        matching = len(older) - len(older_stale) - len(uncompared)
        lines += [
            f"The same scan found {len(older)} bound receipts in an older layout (before the run folders under a "
            "pointer, or under a pointer without recorded source paths). For each, the import closure of every source "
            "a record binds to it was compared, file by file, with the hashes the receipt recorded: "
            f"{matching} match"
            + ("; " + "; ".join(f"`{r}` binds `{', '.join(Path(f).name for f in v['stale'])}` at earlier bytes "
                                f"(records {', '.join(v['records'])})" for r, v in older_stale.items())
               + ". The coordinator put their renewal in this slot, as a step after the periphery (below)"
               if older_stale else "")
            + (f". {len(uncompared)} could not be compared whole, because their closures import modules that exist "
               "only as copies inside earlier run folders, with no live source to differ: "
               + "; ".join(f"`{r}` ({', '.join(v['unresolved_imports']) or 'no file of its closure recorded'})"
                           for r, v in uncompared.items())
               if uncompared else "")
            + ".",
            "",
        ]
    lines += [
        f"**The core.** Receipt [`{CORE_UTC}`](../../../../{PKG}/becoming-checks/{CORE_UTC}/README.md) ran "
        f"every one of its {core['steps']} Lean steps with `BECOMING_FRESH=1` on an empty step cache kept for this "
        f"slot, reusing none, on main `{commit}`, which held every source byte for byte (nothing copied). Its run "
        f"folder keeps every step's log and every audit step's driver, {core['size']['files']} files, "
        f"{mb(core['size']['bytes'])}, in the form of the 16 October fresh receipt. It checks the same bytes as "
        f"`{facts['base_utc']}`, the core receipt on main when the runs began (equal source hashes), and every count "
        + ("in 08 §3 comes out the same; only the receipt named there changes"
           if facts["named"] == facts["base_utc"] else
           f"comes out the same as that receipt's. 08 §3 still named `{facts['named']}`, from before a later core "
           "landing that did not rewrite it, so its counts are now the fresh receipt's, which equal those of the "
           f"core receipt at the run base (`{facts['base_utc']}`)")
        + ", and one sentence after it names this run as rebuilding every core step from nothing at that commit. "
        "Its README says how to repeat it. Nothing beyond what a verifier needs to repeat or compare the run made "
        "the folder much bigger, so nothing was left out but caches and compiled outputs.",
        "",
        "**The periphery.** Each checker ran once, one at a time, on the same slot cache, so it reused a step only "
        "where an earlier run of this slot under the same toolchain (the core run, or an earlier periphery checker) "
        "had run it and kept its log; the table counts the reused steps by the run they came from. The earlier "
        f"receipts reused {gone['periphery']['occurrences']:,} steps ({gone['periphery']['distinct_keys']:,} "
        f"distinct) from builds no run folder keeps, and the core receipt before this one {gone['core']['occurrences']:,}; "
        "none is reused here. "
        + (f"The {len(rc2)} checkers on Lean 4.30.0-rc2 use the pinned Mathlib build, revision "
           f"`{next(iter(revisions))[:12]}`, never rebuilt; the {len(old)} on 4.29.1 use none. " if rc2 else "")
        + "Every source and checker file each passing receipt names is identical to main's.",
        "",
        "| receipt | was | now | modules | steps run | reused from | time | run folder | records re-pointed |",
        "|---|---|---|---|---|---|---|---|---|",
        *rows,
        "",
        f"New run folders in all: {mb(total)}"
        + (f", the older-layout checkers' {len(older_folders)} with them ({mb(older_bytes)})" if older_folders else "")
        + ".",
        "",
    ]
    ran = json.loads((OUT / "older.json").read_text()) if (OUT / "older.json").exists() else {}
    if ran.get("receipts"):
        rows_older = []
        for r, v in ran["receipts"].items():
            if v["passed"]:
                changed = sorted(v["axioms_changed"])
                rows_older.append(f"`{r}` passed again on {v['new_checked_at_utc'][:10]} (before: "
                                  f"{v['old_checked_at_utc'][:10]}), audits {v['audits'][0]} → {v['audits'][1]}, "
                                  + (f"axiom reports changed in {', '.join(changed)}" if changed else
                                     "every axiom report the same"))
            else:
                unclean = "; ".join(f"{u['module']} exited {u['exit']}"
                                    + (f", first error `{u['errors'][0]}`" if u.get("errors") else "")
                                    for u in v.get("unclean", []))
                rows_older.append(f"`{r}` " + (f"not run, since {v['not_run']}" if v.get("not_run") else "failed on main, kept as a finding"
                                               + (f" ({unclean})" if unclean else "")
                                               + f", the files it rewrote kept in `{v.get('failed_copy')}/`, then "
                                               "restored, and the records binding the chain keep their earlier binding"))
        unbound = ran.get("not_renewed", [])
        lines += [
            "**The older layout.** After the periphery, the stale older-layout receipts' chain was rerun by its own "
            "checkers (Lean 4.29.1, Std only), the formal receipt they inherit from first, since evolution's checker "
            "asserts the hashes formal records, and a checker that failed stopped the chain; "
            + ("each rewrote its `verification.json` in place, the earlier bytes kept in git history and their hashes "
               "in the re-point's reason"
               + ("; the checkers that keep a run folder wrote a new one beside their receipt ("
                  + ", ".join(f"`{f.split('formation/')[-1]}/`" for f in older_folders) + ")"
                  if older_folders else "") + ": " if all(v["passed"] for v in ran["receipts"].values()) else
               "a passing checker rewrites its `verification.json` in place, the earlier bytes kept in git history and "
               "their hashes in the re-point's reason: ")
            + "; ".join(rows_older) + ". "
            + (f"Not renewed, because no record binds them: {len(unbound)} live receipts outside this chain that "
               "record `FormedSelection`, `ResourceContinuation` or `FormationSupport` at bytes other than main's, "
               f"and {len(ran.get('kept_copies', []))} kept copies of earlier attempts, each named in the core "
               "receipt's README. "
               if unbound or ran.get("kept_copies") else ""),
            "",
        ]
    acks = json.loads((OUT / "acks.json").read_text()) if (OUT / "acks.json").exists() else {}
    if acks:
        lines += ["**Routed to the coordinator.** "
                  + "; ".join(f"{'An axiom report changed between a checker' + chr(39) + 's two runs' if k == 'axioms' else 'The older-layout step did not renew every receipt'}, "
                              f"and the coordinator ruled: {v}" for k, v in sorted(acks.items())) + ".", ""]
    if failed:
        lines += [f"**Findings.** {len(failed)} of {len(RECEIPTS)} checkers failed on main: {', '.join(failed)}. No "
                  f"Lean was changed here. Each one's output is kept in `{KIT}/out/<checker>.log`, with any run "
                  "folder it wrote; each pointer was restored, and the records binding it keep their earlier "
                  "binding. The coordinator routes the fix to the module's owner.", ""]
    older_recs = sorted({r for k, v in repoint.items() if k.startswith("older:") for r in v.get("records", [])}
                        - set(records))
    lines += [
        f"**Re-points.** {len(records)} records whose proof bindings named a renewed periphery checker's runs, or "
        "its pointer, now bind the renewed run (`tools/research/repoint.py --receipt`, one line per receipt in "
        "`_process/architecture/rebinds.jsonl`). Where a reference pinned a pointer's own bytes, its sha256 follows "
        "the rewritten pointer"
        + (f"; so too for the {len(older_recs)} record{'s' * (len(older_recs) != 1)} binding an older-layout receipt "
           "renewed in place, whose binding keeps the receipt's path while the hash it pins follows the rewritten "
           f"receipt ({', '.join(older_recs)})" if older_recs else "")
        + f". `{KIT}/check_repoint.py` confirms nothing else in those {len(records) + len(older_recs)} records changed"
        + (" but the axiom sentences and swaps below" if axioms else
           " but the swaps in `validation_scope` below" if swap and (swap["swapped"] or swap.get("dated")) else "")
        + ". A record citing an earlier run only as a reference keeps it. No statement changed.",
        "",
    ]
    if axioms:
        notes = sorted({v["note"]["en"].split(": ", 1)[1].rstrip(".") for v in axioms.values()})
        kept = [k for v in axioms.values() for k in v.get("kept", [])]
        holds = [h for v in axioms.values() for h in v.get("holds", [])]
        how = [f"{n} by a template that renders the same text from the renewed receipt"
               for n in [sum(k["kind"] == "template" for k in kept)] if n]
        how += [f"{n} by a reports entry naming declarations whose reports are the same in both receipts"
                for n in [sum(k["kind"] == "reports" for k in kept)] if n]
        how += [f"{len(holds)} by an entry that keeps it for the reason it gives ("
                + "; ".join(sorted({h["reason"] for h in holds})) + ")"] if holds else []
        read = (f"the other {len(kept) + len(holds)} stretch{'es' * (len(kept) + len(holds) != 1)} stating an axiom "
                "or a count of reports in those records and their home sections were read and stay, "
                + ", ".join(how) + "; " if how else "")
        sections = lambda v: [f"its home section ({f.split('/')[-1]}, {h}), "
                              + ", ".join(stretch(c["old"], c["new"]) for c in v["chapter"] if (c["file"], c["heading"]) == (f, h))
                              for f, h in dict.fromkeys((c["file"], c["heading"]) for c in v["chapter"])]
        lines += [f"**Axiom sentences.** In {len(axioms)} record{'s' * (len(axioms) != 1)} bound to a renewed receipt "
                  "whose module reports fewer axioms than the earlier receipt (the same declarations, none gained), "
                  "the sentences stating those reports would, re-pointed as they stood, have stated figures the bound "
                  "receipt no longer reports. As the coordinator ruled, they were brought to the renewed receipt's "
                  "reports in the same step, mechanically: each rewritten sentence is a template over the reports' counts "
                  f"(`{KIT}/AXIOM-SPECS.json`) that reads the sentence as written from the earlier receipt's data and "
                  f"writes it from the renewed one's (`{KIT}/axiom_texts.py`), so each sentence then says exactly "
                  "what the renewed receipt reports: its figures, and a clause for a class of report the receipt now "
                  "reports or no longer reports; every mention of an axiom or a count of reports in those records "
                  "and their home sections lies in a sentence some entry reads, or the run stops; " + read
                  + "each record gained one history note (" + "; ".join(notes) + "). "
                  + " ".join(f"{rid} ("
                             + "; ".join(f"{m}, {len(x)} of its declarations report{'s' * (len(x) == 1)} fewer axioms"
                                         for m, x in v["modules"].items()) + "): "
                             + "; ".join([f"{p.strip('/').replace('/', ' ')}, {stretch(a, b)}"
                                          for p, (a, b) in v["fields"].items() if not p.endswith("/zh")]
                                         + sections(v)) + "."
                             for rid, v in sorted(axioms.items()))
                  + home_drift_text(facts, axioms), ""]
    if swap is not None:
        left, swapped = swap["left"], swap["swapped"]
        named = len(set(swapped) | set(left))
        if named or swap.get("earlier"):
            lines += [f"**Stamps.** In {named or 'none'} of those records `validation_scope` named the run the binding "
                      "named"
                      + (f"; in {len(swapped)} its stamp was swapped for the renewed run's, only where the checker's "
                         "module is unchanged between the two runs (no declaration, axiom report or printed signature "
                         "changed)" + (", or only its axiom reports changed and the record's axiom sentences were "
                                       "brought to the renewed receipt" if set(swapped) & set(axioms) else "")
                         if swapped else "")
                      + (f"; left as they were, the module changed or its signatures not compared: "
                         f"{'; '.join(f'{k} ({v})' for k, v in sorted(left.items()))}" if left else "")
                      + "."
                      + (f" Records naming an earlier run's stamp, not the one the binding named, keep it: "
                         f"{', '.join(sorted(swap['earlier']))}." if swap.get("earlier") else ""), ""]
        dated, left_dated, kept = swap.get("dated", {}), swap.get("left_dated", {}), swap.get("dates_kept", {})
        if dated or left_dated or kept:
            n = len(set(dated) | set(left_dated) | set(kept))
            lines += [f"**Passing dates.** In {n} record{'s' * (n != 1)} binding a renewed older-layout receipt, "
                      "`validation_scope` gives the day the earlier receipt passed"
                      + (f"; in {len(dated)}, on the coordinator's word, that day was swapped for the renewed "
                         "receipt's, only where the audit total is unchanged and "
                         + ("either the bound module keeps every axiom report or the record's axiom sentences were "
                            "brought to the renewed receipt" if set(dated) & set(axioms) else
                            "the bound module keeps every axiom report") + ": " + "; ".join(f"{k} ({v[0][0].removeprefix('passed ')} → "
                                                     f"{v[0][1].removeprefix('passed ')})"
                                                     for k, v in sorted(dated.items())) if dated else "")
                      + (f"; {len(left_dated)} keep the earlier day, the guard failing: "
                         + "; ".join(f"{k} ({v})" for k, v in sorted(left_dated.items())) if left_dated else "")
                      + (f"; {len(kept)} keep the earlier day, still true of the receipt that passed then, since the "
                         "date swap was not run: " + ", ".join(sorted(kept)) if kept else "")
                      + ".", ""]
    exceptions = copies()
    lines += [
        "**What this does not do.** The core-bound records keep their bindings, as their provenance: each names a "
        "run that checked the bound bytes. The fresh run rebuilt every core file on main at its commit, so for "
        "every core binding whose source is a package file on main it is the run a verifier repeats"
        + (". The exceptions bind copies kept inside old run folders, and keep those runs as their only receipt: "
           + "; ".join(f"{rid} (`{src}`)" for rid, src in exceptions) + "." if exceptions else ".")
        + " PE2's propext classification was not rerun; its summary remains the audit at PR1's receipts. Nothing "
        "here bears on what a statement says: an empty or listed axiom report is a fact about the logic, not about "
        "the modelling choices.",
        "",
        f"Kit: `{KIT}/` (the run and landing scripts, out/ with every checker's output, the statuses, the "
        "comparison, the re-points and the checks).",
    ]
    return "\n".join(lines)


def main():
    facts = compare()
    if CHECK:
        print(f"08 §3 names {facts['named']}; core receipt at {BASE[:9]} is {facts['base_utc']}; fresh {CORE_UTC}: "
              "same bytes, same counts" + ("" if facts["named"] == facts["base_utc"] else " (08 §3 stale)"))
        return
    t = STUDY.read_text(encoding="utf-8")
    assert TITLE not in t, "the section is already in the study"
    assert f"\n## {N}. " not in t and f"\n## {N - 1}. " in t, N
    text = section(facts)
    chapter(facts)
    STUDY.write_text(t.rstrip("\n") + "\n\n" + text.strip("\n") + "\n", encoding="utf-8")
    (OUT / "texts.json").write_text(json.dumps({"home_drift": facts.get("home_drift", []),
                                                "named": facts["named"], "base_utc": facts["base_utc"],
                                                "fresh": CORE_UTC, "section": N,
                                                "stale_08": facts["named"] != facts["base_utc"]}, indent=1) + "\n")
    print(f"08 §3: {facts['named']} -> {CORE_UTC}; study section {N} written")


if __name__ == "__main__":
    main()
