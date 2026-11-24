#!/usr/bin/env python3
"""Reproduce six finite Span(colim) examples and emit deterministic JSON.

Run from this directory with:
    python demo_v9_semantics.py
or:
    python demo_v9_semantics.py --output examples.json

The examples are built from public mathematical data constructors. They do not
import test fixtures. The output verifies these concrete instances; the general
coherence and Beck--Chevalley results are proved in the accompanying report.
"""
from __future__ import annotations

import argparse
import json
from pathlib import Path

from wenhehua.diagrammatic_v9 import (
    Arrow,
    Diagram,
    DiagramError,
    DSpan,
    FMap,
    FSet,
    Natural,
    SEAM,
    Shape,
    beck_chevalley_fiber,
    coherence_check,
    colimit,
    comparison,
    fid,
    n_comparison,
)


def seam_state(seam_names, left_names, right_names, to_left, to_right):
    """Create a typed diagram L <- S -> R, without hidden identifications."""
    objects = {
        "S": FSet.of(tuple(seam_names)),
        "L": FSet.of(tuple(left_names)),
        "R": FSet.of(tuple(right_names)),
    }
    return Diagram.build(
        SEAM,
        objects,
        {
            "sl": FMap(objects["S"], objects["L"], tuple(to_left.items())),
            "sr": FMap(objects["S"], objects["R"], tuple(to_right.items())),
        },
    )


def natural(source, target, components):
    return Natural(
        source,
        target,
        tuple(
            (
                obj,
                FMap(
                    source.obj(obj),
                    target.obj(obj),
                    tuple(components[obj].items()),
                ),
            )
            for obj in source.shape.objects
        ),
    )


def to_singletons(source, target):
    """The unique component maps to a diagram with singleton components."""
    if source.shape != target.shape:
        raise DiagramError("singleton target must have the same diagram shape")
    if any(len(target.obj(obj)) != 1 for obj in target.shape.objects):
        raise DiagramError("every target component must be a singleton")
    return natural(
        source,
        target,
        {
            obj: {
                element: target.obj(obj).keys[0]
                for element in source.obj(obj).keys
            }
            for obj in source.shape.objects
        },
    )


def singleton_seam():
    return seam_state(("s",), ("l",), ("r",), {"s": "l"}, {"s": "r"})


def loop_history(state, witness):
    leg = to_singletons(witness, state)
    return DSpan(state, state, witness, leg, leg)


def exact_singleton():
    """Every step records the side histories and their common seam history."""
    state = singleton_seam()
    steps = []
    for label in ("first", "second"):
        s, l, r = label + ":s", label + ":l", label + ":r"
        witness = seam_state((s,), (l,), (r,), {s: l}, {s: r})
        steps.append(loop_history(state, witness))
    return tuple(steps)


def missing_local_handoff():
    """First left-only, then right-only; the intermediate state glues them."""
    state = singleton_seam()
    first = seam_state((), ("left-event",), (), {}, {})
    second = seam_state((), (), ("right-event",), {}, {})
    return loop_history(state, first), loop_history(state, second)


def two_side_events():
    """Each step has a left and a right event, but no common seam witness."""
    state = singleton_seam()
    first = seam_state((), ("left-1",), ("right-1",), {}, {})
    second = seam_state((), ("left-2",), ("right-2",), {}, {})
    return loop_history(state, first), loop_history(state, second)


def merging_seam_histories():
    """Two different compatible local history classes map to one global pair."""
    endpoint = singleton_seam()
    middle = seam_state(
        ("s1", "s2"), ("a",), ("b",),
        {"s1": "a", "s2": "a"}, {"s1": "b", "s2": "b"},
    )
    first_witness = seam_state(
        ("x1", "x2"), ("u1", "u2"), ("v",),
        {"x1": "u1", "x2": "u2"}, {"x1": "v", "x2": "v"},
    )
    second_witness = seam_state(
        ("y1", "y2"), ("p",), ("q1", "q2"),
        {"y1": "p", "y2": "p"}, {"y1": "q1", "y2": "q2"},
    )
    first_to_middle = natural(
        first_witness, middle,
        {
            "S": {"x1": "s1", "x2": "s2"},
            "L": {"u1": "a", "u2": "a"},
            "R": {"v": "b"},
        },
    )
    second_to_middle = natural(
        second_witness, middle,
        {
            "S": {"y1": "s1", "y2": "s2"},
            "L": {"p": "a"},
            "R": {"q1": "b", "q2": "b"},
        },
    )
    return (
        DSpan(
            endpoint, middle, first_witness,
            to_singletons(first_witness, endpoint), first_to_middle,
        ),
        DSpan(
            middle, endpoint, second_witness,
            second_to_middle, to_singletons(second_witness, endpoint),
        ),
    )


def c2_orbit_histories():
    """A finite category with a nonidentity composite: s after s = e."""
    shape = Shape(
        ("O",),
        (Arrow("e", "O", "O"), Arrow("s", "O", "O")),
        (("O", "e"),),
        (("e", "e", "e"), ("e", "s", "s"),
         ("s", "e", "s"), ("s", "s", "e")),
    )
    point, bit = FSet.of(("point",)), FSet.of(("0", "1"))
    state = Diagram.build(shape, {"O": point}, {"s": fid(point)})
    witness = Diagram.build(
        shape, {"O": bit},
        {"s": FMap(bit, bit, (("0", "1"), ("1", "0")))},
    )
    step = loop_history(state, witness)
    return step, step


def three_components_two_seams():
    """An incidence diagram A <- S1 -> B <- S2 -> C."""
    shape = Shape.bipartite(
        ("S1", "S2", "A", "B", "C"),
        (("s1a", "S1", "A"), ("s1b", "S1", "B"),
         ("s2b", "S2", "B"), ("s2c", "S2", "C")),
    )
    state_objects = {obj: FSet.of(("state:" + obj,)) for obj in shape.objects}
    identity_names = {name for _, name in shape.identities}
    state_maps = {
        arrow.name: FMap(
            state_objects[arrow.source], state_objects[arrow.target],
            ((state_objects[arrow.source].keys[0], state_objects[arrow.target].keys[0]),),
        )
        for arrow in shape.arrows if arrow.name not in identity_names
    }
    state = Diagram.build(shape, state_objects, state_maps)

    def step(label):
        objects = {
            obj: FSet.of(()) if obj in {"S1", "S2"}
            else FSet.of((label + ":" + obj,))
            for obj in shape.objects
        }
        maps = {
            arrow.name: FMap(objects[arrow.source], objects[arrow.target], ())
            for arrow in shape.arrows if arrow.name not in identity_names
        }
        return loop_history(state, Diagram.build(shape, objects, maps))

    return step("first"), step("second")


def ordered_binary_trees(indices):
    """All planar binary bracketings; four ordered leaves have five trees."""
    indices = tuple(indices)
    if len(indices) == 1:
        return (indices[0],)
    return tuple(
        (left, right)
        for split in range(1, len(indices))
        for left in ordered_binary_trees(indices[:split])
        for right in ordered_binary_trees(indices[split:])
    )


def tree_notation(tree):
    if isinstance(tree, int):
        return "h" + str(tree + 1)
    return "(" + tree_notation(tree[0]) + " ; " + tree_notation(tree[1]) + ")"


def map_profile(mapping, include_fibers=False):
    source_ids = {x: "local_" + str(i) for i, x in enumerate(mapping.source.keys)}
    target_ids = {y: "global_" + str(i) for i, y in enumerate(mapping.target.keys)}
    fibers = {y: [] for y in mapping.target.keys}
    for x in mapping.source.keys:
        fibers[mapping(x)].append(source_ids[x])
    result = {
        "source_count": len(mapping.source),
        "target_count": len(mapping.target),
        "image_count": sum(bool(xs) for xs in fibers.values()),
        "injective": mapping.injective,
        "surjective": mapping.surjective,
        "bijective": mapping.bijective,
        "uncovered_target_count": sum(not xs for xs in fibers.values()),
        "nontrivial_fiber_sizes": sorted(len(xs) for xs in fibers.values() if len(xs) > 1),
    }
    if include_fibers:
        result["fibers"] = [
            {"target_id": target_ids[y], "source_ids": xs}
            for y, xs in fibers.items()
        ]
    return result


def singleton_family_bc(first, second):
    """Compute actual BC fiber functions, not just their expected cardinalities."""
    fw, fv = colimit(first.witness).apex, colimit(second.witness).apex
    family = {w: FSet.of(("unit",)) for w in fw.keys}
    fibers = []
    for index, v in enumerate(fv.keys):
        mapping = beck_chevalley_fiber(first, second, family, v)
        fibers.append({"second_step_class": index, **map_profile(mapping)})
    every_fiber_bijective = all(item["bijective"] for item in fibers)
    return {
        "family": "one element over every class of the first witness colimit",
        "canonical_direction": "Sigma_Fq (Fp)^* E -> (Fs)^* Sigma_Fr E",
        "element_rule": "(u,e) -> (Fp(u),e)",
        "fibers": fibers,
        "every_fiber_bijective": every_fiber_bijective,
        "agrees_with_chi_bijectivity": every_fiber_bijective == comparison(first, second).cell.bijective,
    }


def four_stage_report(first, second):
    """All examples return to their initial diagram, so their pair can repeat."""
    if first.before != second.after:
        raise DiagramError("four-stage demo requires a repeatable two-step history")
    steps = (first, second, first, second)
    direct = n_comparison(steps)
    trees = ordered_binary_trees(range(4))
    checks = [
        {
            "tree": tree,
            "notation": tree_notation(tree),
            "commutes_after_explicit_reassociation": coherence_check(steps, tree),
        }
        for tree in trees
    ]
    return {
        "step_count": 4,
        "chi": map_profile(direct.cell),
        "bracketing_count": len(trees),
        "bracketings": checks,
        "all_five_commute": len(checks) == 5 and all(
            check["commutes_after_explicit_reassociation"] for check in checks
        ),
    }


EXAMPLES = (
    {
        "id": "exact_common_witness",
        "title_zh": "完整共同见证：1→1",
        "factory": exact_singleton,
        "expected": (1, 1),
        "meaning_zh": "两步均记录左右见证与共同接缝见证；这一个实例中，先合成历史与先拼合给出等价记录。",
        "conditional_application_zh": "若模块接口及其持续见证被完整记录，这类模型可以验证两种装配计算是否一致；不能由单个例子推断所有接口都会一致。",
    },
    {
        "id": "missing_local_handoff",
        "title_zh": "局部无延续、全局出现接续：0→1",
        "factory": missing_local_handoff,
        "expected": (0, 1),
        "meaning_zh": "第一步只有左侧事件，第二步只有右侧事件；中间状态被拼合后，两事件可以全局接续，但局部没有对应的连续历史。",
        "conditional_application_zh": "如果机器人模块或软件服务的聚合状态识别了不同来源，聚合后的可接续性需要额外的来源见证检查。",
    },
    {
        "id": "two_local_events",
        "title_zh": "两侧事件与混合历史：2→4",
        "factory": two_side_events,
        "expected": (2, 4),
        "meaning_zh": "局部连续历史只能一直在左侧或一直在右侧；每步先聚合后还允许两种换侧配对。",
        "conditional_application_zh": "若调度或服务路由采用聚合状态，应明确允许换侧的条件；本例只计算记录系统中的可配对性。",
    },
    {
        "id": "merged_seam_histories",
        "title_zh": "不同局部历史被合并：2→1",
        "factory": merging_seam_histories,
        "expected": (2, 1),
        "meaning_zh": "逐分量匹配保留两个局部历史类；各步分别拼合后，它们映为同一个全局历史。因此一般比较并非历史集合的包含映射。",
        "conditional_application_zh": "若接缝标识记录了不同连接来源，过早合并这些标识可能隐藏不同的重构过程。是否必须保留，应由选定观察任务决定。",
    },
    {
        "id": "c2_relative_phase",
        "title_zh": "群作用与相对关系：2→1；四步8→1",
        "factory": c2_orbit_histories,
        "expected": (2, 1),
        "meaning_zh": "同步翻转两个二值标签保留同向与反向两个轨道；分别取轨道后两者合并。四个标签同步翻转有八个轨道，分别取轨道后只有一个。",
        "conditional_application_zh": "若二值标签代表部件的抽象朝向，整体共同对称与逐部件独立忽略标签是不同操作。本例不包含几何、力学或控制模型。",
    },
    {
        "id": "three_components_two_seams",
        "title_zh": "三部件、两接缝：3→9",
        "factory": three_components_two_seams,
        "expected": (3, 9),
        "meaning_zh": "三个局部部件通过两个状态接缝聚合；两步中没有接缝历史见证。局部只保留三种同部件延续，聚合后允许九种配对。",
        "conditional_application_zh": "这是多模块装配或多服务组合的有限记录模型，用于展示一般图式方法已超出二块一缝；物理与业务合法性仍由额外约束给定。",
    },
)


def build_report():
    cases = []
    for spec in EXAMPLES:
        first, second = spec["factory"]()
        cell = comparison(first, second).cell
        observed = (len(cell.source), len(cell.target))
        if observed != spec["expected"]:
            raise RuntimeError(f"unexpected counts in {spec['id']}: {observed!r}")
        bc = singleton_family_bc(first, second)
        four = four_stage_report(first, second)
        if not bc["agrees_with_chi_bijectivity"] or not four["all_five_commute"]:
            raise RuntimeError(f"finite coherence/BC verification failed in {spec['id']}")
        if spec["id"] == "c2_relative_phase" and (
            four["chi"]["source_count"], four["chi"]["target_count"]
        ) != (8, 1):
            raise RuntimeError("C2 four-stage orbit count must be 8 -> 1")
        cases.append({
            "id": spec["id"],
            "title_zh": spec["title_zh"],
            "meaning_zh": spec["meaning_zh"],
            "conditional_application_zh": spec["conditional_application_zh"],
            "two_stage_chi": map_profile(cell, include_fibers=True),
            "beck_chevalley_singleton_family": bc,
            "four_stage": four,
        })
    return {
        "schema": "wenhehua.v9.span_colimit_examples",
        "version": "9.0",
        "comparison_direction": "colim(local pullback histories) -> pullback(colim(each step))",
        "identifier_scope": "local_* and global_* are display indices for finite witnesses, not physical identities",
        "verification_scope": "Computed finite examples; universal statements are proved separately in the report",
        "example_count": len(cases),
        "checked_four_stage_bracketings": sum(c["four_stage"]["bracketing_count"] for c in cases),
        "all_instance_checks_passed": True,
        "examples": cases,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, help="write JSON to this path instead of stdout")
    args = parser.parse_args()
    text = json.dumps(build_report(), ensure_ascii=False, indent=2) + "\n"
    if args.output is None:
        print(text, end="")
    else:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(text, encoding="utf-8")


if __name__ == "__main__":
    main()
