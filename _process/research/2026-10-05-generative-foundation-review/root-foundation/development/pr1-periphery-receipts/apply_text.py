#!/usr/bin/env python3
"""PR1: write the chapter's section 9 receipt mentions, the study section and the proposition-identity
record's note from the renewed receipts. Idempotent on the chapter (it rewrites the mentions to the
current receipts); the study section and the record note are added once.

usage: apply_text.py SECTION_NUMBER
"""
from datetime import datetime, timezone
import json
from pathlib import Path
import re
import sys

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[5]
sys.path.insert(0, str(HERE.parent / "pe2-propext-uses"))
from uses import RECEIPTS  # noqa: E402

CHAPTER = REPO / "theories/becoming/chapters/THE-THEORY-OF-BECOMING.md"
STUDY = REPO / "_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md"
RECORD = REPO / "theories/becoming/results/records/proposition-identity.json"
KIT = "development/pr1-periphery-receipts"
TITLE = "Every periphery receipt renewed on the current core (PR1)"


def receipt(stem):
    path = next(r for r in RECEIPTS if Path(r).stem == stem)
    return json.loads((REPO / path).read_text())


def anchor(n):
    return f"{n}-" + re.sub(r"[^a-z0-9 -]", "", TITLE.lower()).replace(" ", "-")


def main():
    n = int(sys.argv[1])
    ds = {Path(r).stem: json.loads((REPO / r).read_text()) for r in RECEIPTS[:-1]}
    assert all(d["status"] == "passed" for d in ds.values())
    mains = sorted({d["source_commit"]["main"][:9] for d in ds.values()})
    # Main may move by docs-only commits while the checkers run; `stale.py main` confirms that every
    # receipt binds main's current bytes (the repaired modules aside). Name the latest of them.
    import subprocess
    latest = mains[0]
    for m in mains[1:]:
        if subprocess.run(["git", "merge-base", "--is-ancestor", latest, m], cwd=REPO).returncode == 0:
            latest = m
    main_commit = latest
    ci, fi, mi = ds["correction-inquiry-verification"], ds["fallible-inquiry-verification"], ds["machine-instances-verification"]
    fim = fi["modules"][0]
    fi_axioms = sum(1 for v in fim["axiom_dependencies"].values() if v)
    link = f"../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md#{anchor(n)}"

    text = CHAPTER.read_text()
    para_start = text.index("**The periphery's own checks.**")
    para_end = text.index("\n", para_start)
    para = text[para_start:para_end]
    para = re.sub(r"\(receipt `\d{8}T\d{6}\.\d{6}Z`; the core compiles there too",
                  f"(receipt `{ci['utc']}`; the core compiles there too", para)
    para = re.sub(r"\(\d+ theorems, standard axioms only\)\. Eighteen",
                  f"({mi['modules'][0]['theorems']} theorems, standard axioms only). Eighteen", para)
    para = re.sub(r"\(run `\d{8}T\d{6}\.\d{6}Z`: \d+ theorems, \d+ declarations, \d+ on `propext` or `Quot.sound`\)\.",
                  f"(run `{fi['utc']}`: {fim['theorems']} theorems, {len(fim['declarations'])} declarations, "
                  f"{fi_axioms} on `propext` or `Quot.sound`).", para)
    renewal = (f" All 23 periphery receipts were renewed on 20 October 2026 against the core of main {main_commit} "
               f"([study §{n}]({link})). Seven modules no longer compiled after the core's renames and moves of 19 and "
               "20 October and now name the core's current declarations: MachineInstances, ProtocolInstances, "
               "VersionedTaskInstances, IdealsCorrespondence and EntropyProduction renamed definitions, "
               "LearningCorrespondence and TransmissionCorrespondence the modules that now hold what they use. Every "
               "theorem and declaration kept its name and axiom report, and the twelve theorems whose printed statements "
               "changed name the same definitions by their new names. Read again at the new receipts, every periphery "
               "use of `propext` is classed as before: none computes a value through an identification of propositions.")
    para = re.sub(r" All 23 periphery receipts were renewed on .*$", "", para) + renewal
    CHAPTER.write_text(text[:para_start] + para + text[para_end:])

    study = STUDY.read_text()
    if f"## {n}. {TITLE}" not in study:
        section = (HERE / "section.md").read_text().format(
            n=n, title=TITLE, main=main_commit, ci=ci["utc"], fi=fi["utc"], mi=mi["utc"],
            receipts="; ".join(f"{s.replace('-verification', '')} `{d['utc']}`" for s, d in ds.items()))
        STUDY.write_text(study.rstrip("\n") + "\n\n" + section.rstrip("\n") + "\n")

    rec = json.loads(RECORD.read_text())
    note_en = (f"20 October 2026: the periphery's receipts renewed against the current core (PR1, study section {n}); "
               "PE2's analysis rerun at the new receipts classes all 489 periphery declarations on propext as before "
               "(every recorded axiom report matched, 24 of 24; the core's generated injEq lemmas now 197). next_delta narrowed; "
               "review reference added.")
    if not any(h.get("en") == note_en for h in rec["history"]):
        rec["next_delta"]["en"] = rec["next_delta"]["en"].replace(
            "; the periphery's uses rechecked once its receipts are renewed against the current core", "")
        rec["next_delta"]["zh"] = rec["next_delta"]["zh"].replace("；外围回执对当前核心更新后重查其使用", "")
        rec["history"].append({"en": note_en, "zh": (
            f"2026年10月20日：外围回执对当前核心更新（PR1，研究第 {n} 节）；在新回执上重跑 PE2 的分析，"
            "依赖 propext 的 489 项外围声明分类与前相同（所记公理报告全部相符，24 中 24；核心生成的 injEq 引理现为 197）。"
            "next_delta 收窄；新增审查引用。")})
        import hashlib
        path = f"_process/research/2026-10-05-generative-foundation-review/root-foundation/{KIT}/pe2/summary.json"
        rec["references"].append({"path": path, "role": "review",
                                  "sha256": hashlib.sha256((REPO / path).read_bytes()).hexdigest()})
        rec["reviewed_at_utc"] = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%S+00:00")
        RECORD.write_text(json.dumps(rec, ensure_ascii=False, indent=2) + "\n")
    print("chapter, study section", n, "record; main", main_commit)


if __name__ == "__main__":
    main()
