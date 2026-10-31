#!/usr/bin/env python3
"""Tests of axiom_texts.py on real data, each finding of its review (31 October) as a case.

Reads the chapters and the two rewritten records at REV (default HEAD; after RV21c's landing, its run base, where they
still state the earlier reports) and writes only in a temporary folder: a fake repository holding those copies, and an
out/ folder built from axiom-tests-fixture.json (the older-layout receipts' reports before and after the rehearsal
run, and the 28-checker plan). Prints PASS or FAIL per case; exits 1 on any failure.

usage (from the checkout root): python3 -B axiom_tests.py [REV]
"""
import contextlib
import copy
import io
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import kit  # noqa: E402
import axiom_texts as A  # noqa: E402
import swap_stamps as SW  # noqa: E402

CHECKOUT = kit.REPO
FIXTURE = json.loads((HERE / "axiom-tests-fixture.json").read_text())
REAL = json.loads((HERE / "AXIOM-SPECS.json").read_text())
AS, SC = "a-selected-template-need-not-raise-structure", "same-carrier-need-not-fix-the-response"
CHAPTER = "theories/becoming/chapters/04-LIFE.md"
FAILED = []
REV = sys.argv[1] if len(sys.argv) > 1 else "HEAD"


def show(path):
    return subprocess.check_output(["git", "show", f"{REV}:{path}"], cwd=CHECKOUT).decode()


def reports(receipt, old):
    return {m: {k: sorted(v or []) for k, v in x["old" if old else "new"].items()}
            for m, x in FIXTURE["older"][receipt]["axioms_changed"].items()}


OVR = {}


def fake_modules(receipt, rev):
    return copy.deepcopy(OVR.get((receipt, bool(rev))) or reports(receipt, bool(rev)))


def run(tmp, specs, repo=None, apply=False, out="older"):
    A.REPO, A.OUT = repo or CHECKOUT, tmp / out
    # The gate asks swap_stamps.kept_earlier, which reads its own module's paths.
    SW.REPO, SW.OUT, SW.RECEIPTS = A.REPO, A.OUT, A.RECEIPTS
    (tmp / "specs.json").write_text(json.dumps(specs, ensure_ascii=False))
    A.SPECS = tmp / "specs.json"
    sys.argv = ["axiom_texts.py", "HEAD", "2026-10-31", "999"] + (["--apply"] if apply else [])
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        try:
            A.main()
            code = 0
        except SystemExit as e:
            code = e.code
    return code, buf.getvalue()


def check(name, ok, out=""):
    print(("PASS " if ok else "FAIL ") + name + ("" if ok else "\n" + out))
    if not ok:
        FAILED.append(name)


def main():
    tmp = Path(tempfile.mkdtemp(prefix="axiom-tests-"))
    try:
        cases(tmp)
    finally:
        shutil.rmtree(tmp)
    sys.exit(1 if FAILED else 0)


def cases(tmp):
    # out/ for the older-layout receipts (no periphery checker), and one for the 28-checker plan.
    (tmp / "older").mkdir()
    (tmp / "older/receipts.json").write_text(json.dumps({"receipts": [], "records": {}}))
    (tmp / "older/status.json").write_text("{}")
    older = {"receipts": {r: {"records": v["records"], "passed": v["passed"], "audits": v["audits"],
                              "old_checked_at_utc": v["checked_at_utc"][0], "new_checked_at_utc": v["checked_at_utc"][1],
                              "bound_modules": v["bound_modules"],
                              "axioms_changed": {m: {} for m in v["modules_changed"]}}
                          for r, v in FIXTURE["older"].items()}}
    (tmp / "older/older.json").write_text(json.dumps(older))
    (tmp / "plan").mkdir()
    (tmp / "plan/receipts.json").write_text(json.dumps(FIXTURE["plan"]))
    (tmp / "plan/status.json").write_text(json.dumps({kit.stem(p): {"passed": True} for p in FIXTURE["plan"]["receipts"]}))
    fake = tmp / "fake"
    (fake / A.RECORDS).mkdir(parents=True)
    (fake / "theories/becoming/chapters").mkdir(parents=True)
    names = subprocess.check_output(["git", "ls-tree", "--name-only", REV, "theories/becoming/chapters/"],
                                    cwd=CHECKOUT).decode().split()
    for name in names:
        if Path(name).suffix == ".md":
            (fake / name).write_text(show(name))
    for rid in (AS, SC):
        (fake / A.RECORDS / f"{rid}.json").write_text(show(f"{A.RECORDS}/{rid}.json"))
    record = fake / A.RECORDS / f"{AS}.json"
    chapter = fake / CHAPTER
    rec, orig = record.read_text(), chapter.read_text()

    # No report changed (the run base HEAD, every one of the 28 checkers passed, the real receipt reader): nothing
    # stops, including the records binding files their receipt compiles but does not audit (F0, F7).
    A.RECEIPTS = FIXTURE["plan"]["receipts"]
    code, out = run(tmp, REAL, out="plan")
    check("no change: 28 checkers, 52 records, nothing stops (F0, F7)", code == 0 and "records rewritten: 0" in out, out)
    A.RECEIPTS = []
    real_reader = A.receipt_modules
    A.receipt_modules = fake_modules

    # The real reductions: the ruled figures, the home sentence of a-selected, the reports entry of same-carrier.
    code, out = run(tmp, REAL, fake)
    d = json.loads((tmp / "older/axiom_texts-dry.json").read_text())
    check("real reductions", code == 0 and set(d) == {AS, SC}
          and "propext in 9 of its 19 declarations, the other 10 none" in d[AS]["fields"]["/hypotheses/3/en"][1]
          and "9 with propext only and 10 with empty reports" in d[AS]["fields"]["/validation_scope/en"][1]
          and "14 with propext only, 1 with an empty report and the two energy laws" in d[SC]["fields"]["/validation_scope/en"][1]
          and "14 项只用 propext，1 项报告为空，两条能量律" in d[SC]["fields"]["/validation_scope/zh"][1]
          and [c["new"] for c in d[AS]["chapter"]] == ["**Theorem** (periphery, `propext` in 9 of 19 declarations, the rest none; pre-spine module)"]
          and not d[SC]["chapter"] and "/hypotheses/1/en" not in d[SC]["fields"], out)

    # F2: two entries on one field apply in order.
    s = copy.deepcopy(REAL)
    s[AS]["entries"][2:3] = [
        {"path": "/validation_scope/en", "decls": "module",
         "template": "19 declarations audited, {P} with propext only<<assert:P>>", "covers": ["N"]},
        {"path": "/validation_scope/en", "decls": "module", "template": "and {N} with empty reports<<assert:N>1>>",
         "covers": ["P"]}]
    code, out = run(tmp, s, fake)
    d = json.loads((tmp / "older/axiom_texts-dry.json").read_text())
    check("F2 entries on one field apply in order", code == 0 and "9 with propext only and 10 with empty reports"
          in d[AS]["fields"]["/validation_scope/en"][1], out)

    # F3: a template starting with a count does not read inside a longer number (propext in 3, then 2, of 19).
    ev = next(r for r in FIXTURE["older"] if r.endswith("formation/evolution/verification.json"))
    old, new = reports(ev, True), reports(ev, False)
    ct_o, ct_n = old["ConsequenceTransmission"], new["ConsequenceTransmission"]
    keep = sorted(k for k in ct_o if ct_o[k] and ct_n[k])[:3]
    for k in ct_o:
        if k not in keep:
            ct_o[k], ct_n[k] = [], []
    ct_n[keep[2]] = []
    OVR[(ev, True)], OVR[(ev, False)] = old, new
    s = copy.deepcopy(REAL)
    s[AS]["entries"][0].update(template="{P} of its {total} declarations<<assert:P>>", covers=["N"])
    code, out = run(tmp, s, fake)
    OVR.clear()
    check("F3 digit boundary", code == 1 and "(rendered: '3 of its 19 declarations')" in out, out)

    # F4: a set named only by a condition is not named (two uncited declarations lose propext, so N = 2 and only the
    # N=1 branch is left).
    dv = next(r for r in FIXTURE["older"] if r.endswith("development/verification.json"))
    old, new = reports(dv, True), reports(dv, False)
    for k in ("DevelopedResponse.runnable_trace", "DevelopedResponse.carrier_is_not_already_a_developed_response"):
        new["DevelopedResponse"][k] = []
    OVR[(dv, True)], OVR[(dv, False)] = old, new
    s = copy.deepcopy(REAL)
    e = s[SC]["entries"][2]
    e["template"] = e["template"].replace("<<N>1|, {N} with empty reports>>", "")
    code, out = run(tmp, s, fake)
    OVR.clear()
    check("F4 a condition alone names nothing", code == 1 and "axiom sets not named: ['N']" in out, out)

    # F5: a home sentence repeated elsewhere in the chapter stops, and --apply writes nothing.
    chapter.write_text(orig + "\n**Theorem** (periphery, `propext` in 13 of 19 declarations, the rest none; "
                       "pre-spine module) again.\n")
    code, out = run(tmp, REAL, fake, apply=True)
    check("F5 chapter-wide uniqueness, nothing written", code == 1 and "more than once" in out
          and record.read_text() == rec, out)
    chapter.write_text(orig)

    # F6: number words and unknown counts are problems, not tracebacks.
    zero = {**{k: 0 for k in A.KEYS}, "total": 13}
    for name, template, c, want in (("F6 number word bound", "{P:en}", {**zero, "P": 13}, "no en number word"),
                                    ("F6 unknown count", "{QP}", zero, "unknown count")):
        try:
            A.render(template, c)
            check(name, False, "rendered")
        except A.Problem as err:
            check(name, want in str(err), str(err))

    # F8: a count sentence with no axiom word stops when no entry covers it.
    s = copy.deepcopy(REAL)
    s[AS]["entries"] = [x for x in s[AS]["entries"] if "validation_scope" not in x.get("path", "")]
    d = json.loads(rec)
    d["validation_scope"]["en"] = d["validation_scope"]["en"].replace(
        "13 with propext only and 6 with empty reports", "6 with empty reports")
    d["validation_scope"]["zh"] = d["validation_scope"]["zh"].replace("13 项只用 propext，6 项报告为空", "6 项报告为空")
    record.write_text(json.dumps(d, ensure_ascii=False, indent=2) + "\n")
    code, out = run(tmp, s, fake)
    check("F8 an uncovered count sentence stops", code == 1 and "/validation_scope/en" in out
          and "lies in no entry" in out, out)
    record.write_text(rec)

    # A reports entry whose declarations' reports changed stops (it needs a template).
    dv = next(r for r in FIXTURE["older"] if r.endswith("development/verification.json"))
    old, new = reports(dv, True), reports(dv, False)
    new["DevelopedResponse"]["DevelopedResponse.same_assay_enacts_developed_difference"] = []
    OVR[(dv, True)], OVR[(dv, False)] = old, new
    code, out = run(tmp, REAL, fake)
    OVR.clear()
    check("a reports entry stops when its reports changed", code == 1
          and "states reports the renewed receipt changed" in out, out)

    # E1 (re-review): a count inside a segment that does not render names nothing (N=1 with only the N>1 branch).
    s = copy.deepcopy(REAL)
    e = s[SC]["entries"][2]
    e["template"] = e["template"].replace("<<N=1|, 1 with an empty report>>", "")
    code, out = run(tmp, s, fake)
    check("E1 a count in a segment that does not render names nothing", code == 1
          and "axiom sets not named: ['N']" in out, out)

    # E2: "cited" counts the cited declarations within the entry's module, so a law citing another module's
    # declaration leaves the reading unchanged; a reports entry naming nothing stops.
    sc_record = fake / A.RECORDS / f"{SC}.json"
    sc_rec = sc_record.read_text()
    d = json.loads(sc_rec)
    d["laws"][0].setdefault("declarations", []).append("FormedSelection.copy_increment_le_spent")
    sc_record.write_text(json.dumps(d, ensure_ascii=False, indent=2) + "\n")
    code, out = run(tmp, REAL, fake)
    check("E2 cited within the entry's module", code == 0 and "records rewritten: 2" in out, out)
    sc_record.write_text(sc_rec)
    s = copy.deepcopy(REAL)
    s[SC]["entries"][-1]["reports"], s[SC]["entries"][-1]["only"] = {}, {}
    code, out = run(tmp, s, fake)
    check("E2 a reports entry naming nothing stops", code == 1 and "names no declaration" in out, out)

    # E3: a record's bindings are collected, not overwritten: a second binding to a receipt whose module is
    # unchanged keeps the first binding's change; a second binding whose reports cannot be read keeps both.
    fm = next(r for r in FIXTURE["older"] if r.endswith("formation/formal/verification.json"))
    d = json.loads(rec)
    d["proof_bindings"].append({**d["proof_bindings"][0], "receipt": fm, "source": d["proof_bindings"][0]["source"]
                                .replace("ConsequenceTransmission", "FormationAccounts")})
    record.write_text(json.dumps(d, ensure_ascii=False, indent=2) + "\n")
    older2 = copy.deepcopy(older)
    older2["receipts"][fm]["records"] = older2["receipts"][fm]["records"] + [AS]
    (tmp / "older/older.json").write_text(json.dumps(older2))
    OVR[(fm, True)] = OVR[(fm, False)] = {"FormationAccounts": {"FormationAccounts.root_account_balance": ["propext"]}}
    code, out = run(tmp, REAL, fake)
    check("E3 a second, unchanged binding keeps the first binding's change", code == 0 and "records rewritten: 2" in out, out)
    saved = A.receipt_modules

    def failing(receipt, rev):
        if receipt == fm:
            raise OSError("unreadable")
        return saved(receipt, rev)
    A.receipt_modules = failing
    code, out = run(tmp, REAL, fake)
    A.receipt_modules = saved
    check("E3 an unreadable second binding is a problem, the first binding's change kept", code == 1
          and "reports not read" in out and f"{AS} (ConsequenceTransmission" in out, out)
    OVR.clear()
    (tmp / "older/older.json").write_text(json.dumps(older))
    record.write_text(rec)

    # E3: a bound file whose stem names two modules is a problem.
    old, new = reports(ev, True), reports(ev, False)
    old["Copy.ConsequenceTransmission"] = old["ConsequenceTransmission"]
    new["Copy.ConsequenceTransmission"] = new["ConsequenceTransmission"]
    OVR[(ev, True)], OVR[(ev, False)] = old, new
    code, out = run(tmp, REAL, fake)
    OVR.clear()
    check("E3 a stem naming two modules stops", code == 1 and "ConsequenceTransmission names" in out, out)

    # E3: the real older-layout reader at REV gives the fixture's earlier reports (true until RV21c lands; pass its
    # run base as REV after that).
    A.REPO = CHECKOUT
    got = real_reader(ev, REV).get("ConsequenceTransmission")
    check("E3 the real older-layout reader at REV", got == reports(ev, True)["ConsequenceTransmission"],
          f"{len(got or {})} declarations read")

    # E3: two home sentences in one chapter, the first rewrite making a second copy of the other's old text, stop
    # when applied.
    A.REPO = fake
    problems = []
    a_old = "`propext` in 13 of 19 declarations"
    b_old = "`propext`, and `Quot.sound` in two declarations"
    A.build({AS: {"fields": {}, "note": {"en": "", "zh": ""},
                  "chapter": [{"file": CHAPTER, "heading": "", "old": a_old, "new": a_old + " " + b_old}]},
             SC: {"fields": {}, "note": {"en": "", "zh": ""},
                  "chapter": [{"file": CHAPTER, "heading": "", "old": b_old, "new": "x"}]}}, problems)
    check("E3 the apply-time check of a home sentence", any("when applied" in x for x in problems), str(problems))

    # E4: a malformed entry is a problem line, not a traceback.
    for name, change, want in (("E4 a template entry without decls", lambda x: x.pop("decls"), "needs decls"),
                               ("E4 a path naming a non-text field", lambda x: x.update(path="/hypotheses/3"),
                                "is not a text")):
        s = copy.deepcopy(REAL)
        change(s[AS]["entries"][0])
        code, out = run(tmp, s, fake)
        check(name, code == 1 and want in out, out)

    # C1: a record whose sentences would be rewritten but whose date the swap would leave (the audit total changed)
    # stops before anything is written.
    older2 = copy.deepcopy(older)
    older2["receipts"][ev]["audits"] = [90, 91]
    (tmp / "older/older.json").write_text(json.dumps(older2))
    code, out = run(tmp, REAL, fake)
    (tmp / "older/older.json").write_text(json.dumps(older))
    check("C1 the swaps' guard is checked first", code == 1 and "would leave it naming an earlier run" in out
          and "audits 90 -> 91" in out, out)

    # G1 (final review): the gate asks the swaps' own per-record logic, so it stops on the same cases check_repoint
    # does. A record naming an earlier run of a periphery checker is listed under earlier; one naming the old stamp
    # with signatures not compared is left; the same text with the module unchanged but for its axiom reports is
    # swapped when its sentences were rewritten, and left when they were not.
    import swap_stamps as W
    row = {"old_utc": "20261020T000000.000000Z", "new_utc": "20261031T000000.000000Z", "signatures_compared": 3,
           "signatures_changed": {}, "modules": {"M": {"removed": [], "added": [], "axioms_changed": {"M.x": 1}}}}
    named, outcome = W.stamp_outcome("receipt 20261019T000000.000000Z", "m", row, {"20261019T000000.000000Z"}, True)
    check("G1 an earlier run named is listed", named == ["20261019T000000.000000Z"] and outcome is None)
    text = "receipt 20261020T000000.000000Z"
    check("G1 a rewritten record is swapped on declarations and signatures alone",
          W.stamp_outcome(text, "m", row, set(), True)[1] == ("swap", (row["old_utc"], row["new_utc"])))
    check("G1 a record not rewritten is left when its axiom reports changed",
          W.stamp_outcome(text, "m", row, set(), False)[1][0] == "left")
    check("G1 signatures not compared leave the stamp",
          W.stamp_outcome(text, "m", {k: v for k, v in row.items() if k != "signatures_compared"}, set(), True)[1][0]
          == "left")
    orow = {"old_checked_at_utc": "2026-10-07T10:00:00+00:00", "new_checked_at_utc": "2026-10-31T10:00:00+00:00",
            "bound_modules": {"r": ["M"]}, "axioms_changed": {"M": {}}, "audits": [90, 90]}
    check("G1 a date with the audit total unchanged is dated for a rewritten record",
          W.date_outcome("passed 7 October 2026", "x/evolution/verification.json", orow, "r", True, True)[0] == "dated")
    check("G1 the date swap not run keeps the date",
          W.date_outcome("passed 7 October 2026", "x/evolution/verification.json", orow, "r", True, False)[0]
          == "dates_kept")

    # G2: a reports entry whose lists name no declaration stops.
    s = copy.deepcopy(REAL)
    s[SC]["entries"][-1]["reports"], s[SC]["entries"][-1]["only"] = {}, {"Classical.choice": []}
    code, out = run(tmp, s, fake)
    check("G2 a reports entry with empty lists stops", code == 1 and "names no declaration" in out, out)

    # G3: a pinned segment names its set only when its text states the value.
    for variant in ("<<N=1>>", "<<N=1|,>>"):
        s = copy.deepcopy(REAL)
        e = s[SC]["entries"][2]
        e["template"] = e["template"].replace("<<N=1|, 1 with an empty report>>", variant)
        code, out = run(tmp, s, fake)
        check(f"G3 {variant} names nothing", code == 1 and "axiom sets not named: ['N']" in out, out)

    # --apply on the fake repository: the records and the chapter written, the note dated.
    code, out = run(tmp, REAL, fake, apply=True)
    d = json.loads(record.read_text())
    check("apply writes", code == 0 and "`propext` in 9 of 19 declarations" in chapter.read_text()
          and d["history"][-1]["en"].startswith("31 October 2026, RV21c (study section 999): axiom reports"), out)

    # F1: a table row holding the anchor is the home section alone.
    A.REPO = fake
    for rid, word in (("regime-in-any-amounts", "Classical.choice"), ("retrospective-source-binding", "propext"),
                      ("transition-grouping-word-partition", None)):
        _, para, _ = A.home(rid)
        ok = "\n" not in para and f'r-{rid}"' in para and (word in para if word else not A.MENTION.search(para))
        check(f"F1 the home section of {rid} is its own row", ok, para[:300])


if __name__ == "__main__":
    main()
