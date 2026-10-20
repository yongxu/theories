#!/usr/bin/env python3
"""PE2: update the proposition-identity record (next_delta, history, review references).

usage: update_record.py SECTION   (the study section number PE2's section lands as)
"""
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import sys

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[5]
RECORD = REPO / "theories/becoming/results/records/proposition-identity.json"
KIT = "_process/research/2026-10-05-generative-foundation-review/root-foundation/development/pe2-propext-uses/"
STUDY = "_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md"
REVIEW = ["Uses.lean", "summary.json", "reduction/machine-instances.log", "reduction/learning-correspondence.log",
          "reduction/ideals-correspondence.log", "reduction/continuation-correspondence.log", "reduction/sparse.log"]


def digest(path):
    return hashlib.sha256((REPO / path).read_bytes()).hexdigest()


def main():
    section = sys.argv[1]
    record = json.loads(RECORD.read_text())
    record["next_delta"] = {
        "en": "The same account for function extensionality and quotient soundness, which the periphery's "
              "reports show beside propext; the periphery's uses rechecked once its receipts are renewed "
              "against the current core; the inherited periphery modules' own declarations; an independent "
              "review.",
        "zh": "对函数外延性与商的可靠性作同样的说明（外围的报告中它们与 propext 并列）；外围回执对当前核心更新后重查其使用；"
              "继承的外围模块自身的声明；独立审查。",
    }
    record["history"].append({
        "en": f"20 October 2026: the periphery's uses of propext checked use by use (PE2, study section {section}): "
              "in the 23 periphery receipts, 489 of 762 audited declarations and the core's 196 generated injEq "
              "lemmas, read from their kernel terms at the receipts' bytes. Every proof gets propext only "
              "inside a proof, as an identification of interderivable propositions; none of the 45 "
              "definitions on propext computes a value through one (propext enters them through Lean's "
              "compilation of wildcard matches, a Fin recursion and list indexing, and Mathlib's measure "
              "structures; closed values compute). next_delta narrowed; review references added.",
        "zh": f"2026年10月20日：逐一检查外围对 propext 的使用（PE2，研究第 {section} 节）：23 个外围回执中所审 762 项声明的 489 项，"
              "以及核心生成的 196 个 injEq 引理，按回执的字节从其内核项读取。每个证明只在证明之内得到 propext，作为对可互推命题的等同；"
              "依赖 propext 的 45 个定义无一经它计算值（propext 经 Lean 对通配匹配、一个 Fin 递归与列表索引的编译，以及 Mathlib 的测度结构进入；"
              "闭值可计算）。next_delta 收窄；新增审查引用。",
    })
    record["reviewed_at_utc"] = datetime.now(timezone.utc).replace(microsecond=0).isoformat()
    refs = [r for r in record["references"] if not r["path"].startswith(KIT)]
    for r in refs:
        if r["path"] == STUDY:
            r["sha256"] = digest(STUDY)
    refs += [{"path": KIT + name, "role": "review", "sha256": digest(KIT + name)} for name in REVIEW]
    record["references"] = refs
    RECORD.write_text(json.dumps(record, indent=2, ensure_ascii=False) + "\n")
    print("updated", RECORD.relative_to(REPO))


if __name__ == "__main__":
    main()
