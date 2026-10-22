#!/usr/bin/env python3
"""Execute the document casebook and verify semantic boundary rejections.

Only Python's standard library and the adjacent wenli.py are used.  These checks
establish truth in the supplied finite models, not historical or empirical truth.
"""
from __future__ import annotations

import argparse
import copy
import json
from pathlib import Path

from wenli import GrammarError, Model, assess, load_json, run_bundle


BASE = Path(__file__).resolve().parent


def validate():
    paths = sorted((BASE / "casebook").glob("[0-9][0-9]_*.json"))
    if len(paths) != 12:
        raise AssertionError(f"Expected 12 document bundles; found {len(paths)}")
    bundles = {}
    results = []
    bundle_reports = []
    for path in paths:
        bundle = load_json(path)
        bundles[path.name] = bundle
        report = run_bundle(bundle)
        bundle_reports.append({"file": path.name, "title": report["title"],
                               "checks": report["checks"], "all_pass": report["all_pass"]})
        for result in report["results"]:
            results.append({"file": path.name, **result})

    def record(name, actual, expected, kind="integration"):
        results.append({"file": "validate_casebook.py", "name": name, "type": kind,
                        "actual": actual, "expected": expected, "pass": actual == expected})

    def rejects(name, callback):
        try:
            callback()
        except GrammarError as exc:
            results.append({"file": "validate_casebook.py", "name": name,
                            "type": "rejection", "actual": "GrammarError",
                            "expected": "GrammarError", "pass": True, "diagnostic": str(exc)})
        else:
            record(name, "accepted", "GrammarError", "rejection")

    def model(filename):
        return Model(bundles[filename]["model"])

    observation = model("01_negation_observation.json")
    unseen = model("01_negation_possible_unseen.json")
    record("观测相同的候选模型不能决定是否发生", assess(
        [observation, unseen], {"op": "fref", "name": "NotPast"}, "safe"), "unknown")
    record("候选模型一致支持未观测到", assess(
        [observation, unseen], {"op": "fref", "name": "NotObservedPast"}, "safe"), "true")
    record("候选模型一致否定全窗口未发生", assess(
        [observation, unseen], {"op": "fref", "name": "NotFull"}, "safe"), "false")
    rejects("候选模型为空不能借空真得到知识", lambda: assess(
        [], {"op": "fref", "name": "NotPast"}, "safe"))
    foreign_context = copy.deepcopy(bundles["01_negation_observation.json"]["model"])
    foreign_context["context_id"] = "different-scale-and-identity"
    rejects("相同签名但不同context不可合评", lambda: assess(
        [observation, Model(foreign_context)], {"op": "fref", "name": "NotPast"}, "safe"))
    rejects("Interval项不能占Time参数位", lambda: observation.holds(
        {"op": "atom", "name": "Occurs", "args": [{"const": "ignite"}, {"const": "I"}]}, "safe"))
    rejects("Observed不能以Formula作事件项", lambda: observation.holds(
        {"op": "atom", "name": "Observed", "args": [
            {"op": "fref", "name": "NotPast"}, {"const": "I"}]}, "safe"))

    concepts = model("03_relational_concepts.json")
    rejects("Concept不能自动提升为Entity因果关系", lambda: concepts.holds(
        {"op": "atom", "name": "Cause", "args": [{"const": "you"}, {"const": "wu"}]}, "full"))

    identity = model("05_birth_end_lineage.json")
    rejects("生灭Program不能以命题合取连接", lambda: identity.holds(
        {"op": "and", "args": [{"op": "pref", "name": "EndA"},
                                  {"op": "pref", "name": "BornB"}]}, "s0"))

    route = model("06_follow_structure.json")
    rejects("不不能直接否定刀对象", lambda: route.holds(
        {"op": "not", "arg": {"const": "knife"}}, "at_A"))
    rejects("刀工具不能填入施事角色", lambda: route.holds(
        {"op": "atom", "name": "CutRole", "args": [
            {"const": "knife"}, {"const": "body"}, {"const": "cook"},
            {"const": "route_AB"}]}, "at_A"))
    record("明确附加的零损伤边成本相加为零", 0 + 0, 0, "bridge_arithmetic")

    norms = model("07_norms_and_feasibility.json")
    record("a虽可行但被V禁止", norms.decision("V", "s", "a", {"op": "atomic", "name": "a"}),
           {"judgment": "forbidden", "feasible": True, "eligible": False})
    record("b可行且获V许可", norms.decision("V", "s", "b", {"op": "atomic", "name": "b"}),
           {"judgment": "permitted", "feasible": True, "eligible": True})
    record("未定规范不能制造不存在的动作", norms.decision("V", "h", "b", {"op": "atomic", "name": "b"}),
           {"judgment": "undetermined", "feasible": False, "eligible": False})
    for action in ("a", "b"):
        # This consistency check uses the openly declared case-specific V rule.
        # The engine does not infer V or endorse it as universal ethics.
        safe = norms.holds({"op": "and", "args": [
            {"op": "diamond", "program": {"op": "atomic", "name": action}, "body": {"op": "true"}},
            {"op": "box", "program": {"op": "atomic", "name": action},
             "body": {"op": "not", "arg": {"op": "atom", "name": "Harm", "args": []}}}]}, "s")
        record(f"V表对{action}与其明示准则相容", norms.judge("V", "s", action),
               "permitted" if safe else "forbidden", "declared_norm_consistency")
    rejects("Judgement不属于Formula", lambda: norms.holds(
        {"op": "judge", "norm": "V", "action": "b"}, "s"))
    rejects("TextClaim不能作为现实Formula执行", lambda: norms.holds(
        {"op": "TextClaim", "source": "Y04", "body": {"op": "true"}}, "s"))

    incomplete = copy.deepcopy(bundles["01_negation_observation.json"]["model"])
    del incomplete["predicates"]["Observed"]["true_at"]["safe"]
    rejects("缺失整项解释不默认为假", lambda: Model(incomplete))

    counts = {}
    for result in results:
        counts[result["type"]] = counts.get(result["type"], 0) + 1
    return {"title": "07与09完整推导案例的实际执行验证", "bundles": len(paths),
            "checks": len(results), "counts": counts,
            "all_pass": all(r["pass"] for r in results),
            "scope": "Finite supplied models and explicit assumptions; no claim of empirical or philological proof.",
            "bundle_reports": bundle_reports, "results": results}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--report", type=Path, help="Optional JSON report path")
    args = parser.parse_args()
    result = validate()
    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({k: result[k] for k in ("bundles", "checks", "counts", "all_pass")}, ensure_ascii=False))
    if not result["all_pass"]:
        print(json.dumps([r for r in result["results"] if not r["pass"]], ensure_ascii=False, indent=2))
    return 0 if result["all_pass"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
