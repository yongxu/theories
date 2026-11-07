#!/usr/bin/env python3
"""Render/check the curated bilingual generativity chain, without proving claims.

Source fingerprints are review receipts, not semantic validation. Updating them
is appropriate only after reading the changed source and revising/confirming its
paired entry. Discovery fingerprints describe the inspected list of pages.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
from urllib.parse import unquote

ROOT = Path(__file__).resolve().parents[2]
BASE = ROOT / "theories/becoming/results"
DATA = BASE / "data/generativity-chain.json"
OUTPUT = BASE / "GENERATIVITY-CHAIN.md"


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read_data():
    return json.loads(DATA.read_text())


def write_data(data):
    DATA.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n")


def local_target(reference):
    name, _, fragment = reference.partition("#")
    path = (ROOT / unquote(name)).resolve()
    if not path.is_relative_to(ROOT):
        raise ValueError("Reference escapes repository: " + reference)
    return path, unquote(fragment)


def heading_ids(path):
    result = set()
    counts = {}
    for line in path.read_text().splitlines():
        match = re.match(r"^#{1,6}\s+(.+?)\s*#*$", line)
        if not match:
            continue
        title = re.sub(r"\[([^]]+)\]\([^)]+\)", r"\1", match[1]).lower()
        slug = "".join(c for c in title if c.isalnum() or c in " -_").replace(" ", "-")
        n = counts.get(slug, 0)
        counts[slug] = n + 1
        result.add(slug + ("-" + str(n) if n else ""))
    result.update(re.findall(r'<a\s+(?:id|name)=["\']([^"\']+)', path.read_text()))
    return result


def moved_from(globs):
    """Pages that matched a discovery glob and were moved since (to history or elsewhere), at
    their present paths, read from the move receipts (tools/research/moves.py)."""
    try:
        import sys
        if str(ROOT) not in sys.path:
            sys.path.insert(0, str(ROOT))
        from tools.research import moves
    except ImportError:
        return set()
    return moves.historical_paths(globs, ROOT)


def discovery(data):
    found = set()
    for pattern in data["discovery_globs"]:
        found.update(str(p.relative_to(ROOT)) for p in ROOT.glob(pattern) if p.is_file())
    # A moved page stays in the inspected inventory at its new path: moving it is not a removal.
    found.update(moved_from(data["discovery_globs"]))
    return sorted(found)


def changes(data):
    modified, missing = [], []
    for name, fingerprint in data["reviewed_sources"].items():
        path = ROOT / name
        if not path.exists():
            missing.append(name)
        elif digest(path) != fingerprint:
            modified.append(name)
    current, known = set(discovery(data)), set(data["known_discovery_paths"])
    return {"modified_sources": modified, "missing_sources": missing,
            "new_pages": sorted(current-known), "removed_pages": sorted(known-current)}


def validate(data):
    errors = []
    ids = set()
    fields = ["id", "title_zh", "title_en", "claim_zh", "claim_en", "scope_zh", "scope_en"]
    for section in data["sections"]:
        for entry in section["entries"]:
            for field in fields:
                if not isinstance(entry.get(field), str) or not entry[field].strip():
                    errors.append(f"Missing {field}: {entry.get('id')}")
            if entry["id"] in ids:
                errors.append("Duplicate id: " + entry["id"])
            ids.add(entry["id"])
            if not entry.get("links"):
                errors.append("No evidence link: " + entry["id"])
            for link in entry.get("links", []):
                if not link.get("label_zh") or not link.get("label_en"):
                    errors.append("Unpaired link label: " + entry["id"])
                path, fragment = local_target(link["path"])
                if not path.exists():
                    errors.append("Missing link: " + link["path"])
                elif fragment and path.suffix == ".md" and fragment not in heading_ids(path):
                    errors.append("Missing heading: " + link["path"])
                name = str(path.relative_to(ROOT))
                if name not in data["reviewed_sources"]:
                    errors.append("Unversioned source: " + name)
    return errors


def cell(text):
    return str(text).replace("|", "\\|").replace("\n", "<br>")


def link(reference, label):
    path, fragment = local_target(reference)
    relative = os.path.relpath(path, BASE)
    target = relative + ("#" + fragment if fragment else "")
    return f"[{label}]({target})"


def render(data):
    total = sum(len(section["entries"]) for section in data["sections"])
    record_zh, record_en = link(data["maintenance_record"], "维护记录"), link(data["maintenance_record"], "maintenance record")
    lines = ["# 生成、共同实现与伦理：自 2026 年 10 月起维护的一条理论链 / Generativity, co-realization and ethics: a curated chain kept since October 2026", "",
             f"内容更新 / Content updated: **{data['updated']}** · Asia/Bangkok · **{total} 条导航项 / {total} indexed entries**", "",
             f"本页是按论证关系选编的一条理论链，共 {total} 条，自 2026 年 10 月 8 日起维护，沿用当时的词汇（如 G0）；它与理论的现行陈述并存，本身不陈述现行理论。理论今陈述于[一页](../ONE-PAGE.zh.md)、[总览](../THE-THEORY-OF-BECOMING.zh.md)与[八章](../chapters/README.md)。上面的日期是最近一次改动之日，不是逐一重读所链来源之日（{record_zh}）。", "",
             f"This page is a curated chain of {total} entries, kept since 8 October 2026 in the vocabulary of its time (G0 among it), beside the live account and not a statement of it. The account is stated in [the one page](../ONE-PAGE.md), [the overview](../THE-THEORY-OF-BECOMING.md) and [the eight chapters](../chapters/README.md). The date above is that of its last change, not of a reading of every linked source ({record_en}).", "",
             "[2026 年 10 月 8 日起的章节读法 / Chapter readings of 8 October 2026 and later](README.md) · [A–L](ARGUMENTS-A-L.md) · [M–Z](ARGUMENTS-M-Z.md) · [Lean 声明 / Lean declarations](LEAN-DECLARATIONS.md)", "",
             data["scope_zh"], "", data["scope_en"], "",
             "## 本链的核心论断（其时的候选） / The chain's central claim (a candidate of its time)", "",
             "> " + data["quote_zh"], "", "> " + data["quote_en"], "",
             "这段话是 AI 撰写的候选论证及其英文对译；共同形成的某些机制与表示已得到检查，其普遍伦理识别仍在论证。 / This is an AI-authored candidate argument and its English translation. Some mechanisms and representations of joint formation are checked; its universal ethical identification remains under investigation.", "",
             link(data["quote_source"], "所引论证与完整范围 / Quoted argument and full scope"), "",
             "## 主链与读法 / Chain and reading guide", "",
             "同一生成展开 → 组织及后续条件 → 有支持的共同实现 → 整体质量与真实得失 → 情境理由 → 学习、关怀、良知与智慧 → 实践及校准。这是阅读主线，不是已完成的单向推导；组织—调节—学习—关切的形成路径与规范研究相互回接。各连接的根据和完成程度分列于表中。", "",
             "One unfolding → organization and further conditions → supported co-realization → whole quality and real gains/losses → situated reasons → learning, concern, Liangzhi and wisdom → practice and calibration. This is a reading guide, not a completed one-way derivation; organization–regulation–learning–concern and normative inquiry reconnect with one another. The tables distinguish each connection’s warrant and completion scope.", "",
             "表中的理论、方法、机制、命题与检查包是不同维护单元，并非同等地位的独立理论。‘已检查’仅及于所列定义、前提、对应与历史版本；‘候选’和‘未完成’保留其真实研究状态。", "",
             "Theories, methods, mechanisms, propositions and verification packages are different maintenance units, not equally established independent theories. Checked results retain their definitions, hypotheses, correspondence and source versions; candidates and open questions remain identified.", ""]
    for section in data["sections"]:
        lines += [f"## {section['title_zh']} / {section['title_en']}", "",
                  "| 编号 / ID | 理论或命题 / Theory or proposition | 中文论断 | English formulation | 范围与状态 / Scope and status | 原文、证明与评审 / Sources, proofs and reviews |",
                  "|---|---|---|---|---|---|"]
        for entry in section["entries"]:
            references = "<br>".join(link(item["path"], item["label_zh"]+" / "+item["label_en"]) for item in entry["links"])
            row = [entry["id"], entry["title_zh"]+"<br>"+entry["title_en"], entry["claim_zh"], entry["claim_en"],
                   entry["scope_zh"]+"<br>"+entry["scope_en"], references]
            lines.append("| " + " | ".join(cell(item) for item in row) + " |")
        lines.append("")
    lines += ["## 持续维护 / Ongoing maintenance", "",
              "这份表在原位置持续更新。关联研究发生实质变化时，同时修订中英文论断、状态与链接。未发现相关变化时不改写内容，也不重复运行已通过的证明。", "",
              "Maintain this same document in place. When linked research changes substantively, revise both languages, status and links together. Without relevant changes, leave the content and successful proof runs untouched.", "",
              "生成文件的编辑来源是 [双语数据](data/generativity-chain.json)。源文件摘要只用于发现变化，不能代替重读与判断；维护流程和更新记录见 " + link(data["maintenance_record"], "维护记录 / Maintenance record") + "。", "",
              "The [bilingual data](data/generativity-chain.json) is the editable source. Source hashes detect changes; they do not replace reading or judgment. Follow the linked maintenance record for the maintenance workflow and update history.", ""]
    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--changes", action="store_true")
    mode.add_argument("--render", action="store_true")
    mode.add_argument("--record-review", nargs="+", metavar="REPO_PATH")
    mode.add_argument("--record-discovery-review", action="store_true")
    args = parser.parse_args()
    data = read_data()
    if args.record_review:
        for name in args.record_review:
            path, _ = local_target(name)
            data["reviewed_sources"][str(path.relative_to(ROOT))] = digest(path)
        write_data(data)
        print("Recorded explicitly reviewed source versions; this does not validate their content.")
        return
    if args.record_discovery_review:
        data["known_discovery_paths"] = discovery(data)
        write_data(data)
        print("Recorded inspected page inventory; this does not classify new research automatically.")
        return
    delta = changes(data)
    if args.changes:
        print(json.dumps(delta, ensure_ascii=False, indent=2))
        return
    errors = validate(data)
    if delta["modified_sources"] or delta["missing_sources"]:
        errors.append("Linked source versions changed; reread affected entries before rendering.")
    if errors:
        print(json.dumps({"status": "needs-review", "errors": errors, "changes": delta}, ensure_ascii=False, indent=2))
        raise SystemExit(2)
    content = render(data)
    if args.render:
        if not OUTPUT.exists() or OUTPUT.read_text() != content:
            OUTPUT.write_text(content)
    elif not OUTPUT.exists() or OUTPUT.read_text() != content:
        print("Generated table differs from bilingual data; render after source review.")
        raise SystemExit(2)
    report = {"status": "passed", "entries": sum(len(s["entries"]) for s in data["sections"]),
              "reviewed_sources": len(data["reviewed_sources"]), "new_pages_for_scope_review": delta["new_pages"],
              "removed_pages_for_scope_review": delta["removed_pages"], "output": str(OUTPUT.relative_to(ROOT))}
    print(json.dumps(report, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
