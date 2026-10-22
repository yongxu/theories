#!/usr/bin/env python3
"""Two finite G1 counterexamples to unjustified abstraction transfer."""

from __future__ import annotations

import argparse
import importlib.util
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
ENGINE = HERE.parent / "10_组合文法参考实现_v0.3" / "wenli.py"
spec = importlib.util.spec_from_file_location("wenli_abstraction_reference", ENGINE)
if spec is None or spec.loader is None:
    raise RuntimeError(f"Cannot load the shared G1 engine: {ENGINE}")
wenli = importlib.util.module_from_spec(spec)
spec.loader.exec_module(wenli)


def model(context, states, programs):
    return {"context_id": context, "closed_world": True, "states": states,
            "sorts": {}, "constants": {},
            "predicates": {"K": {"sorts": [], "kind": "descriptive",
                                  "true_at": {state: [[]] for state in states}}},
            "programs": programs, "formula_defs": {}, "program_defs": {}, "norms": {}}


def make_examples():
    return {
        "title": "卦类抽象不自动保留路径和共同终点",
        "status": "two_counterexamples_under_explicit_modern_models",
        "step_duration": {"value": 1, "unit": "arbitrary_fixed_time_unit"},
        "path_counterexample": {
            "beta": {"a": "111", "b": "000", "c": "000", "d": "111"},
            "abstract_names": {"111": "乾", "000": "坤"},
            "concrete": model("abstraction-path-concrete-v0.1", ["a", "b", "c", "d"],
                              {"step": [["a", "b"], ["c", "d"]]}),
            "abstract": model("abstraction-path-two-gua-v0.1", ["111", "000"],
                              {"step": [["111", "000"], ["000", "111"]]}),
        },
        "sync_counterexample": {
            "beta": {"s": "A", "t": "B", "u": "B"},
            "abstract_names": {"A": "乾111", "B": "坤000"},
            "concrete": model("abstraction-sync-concrete-v0.1", ["s", "t", "u"],
                              {"a": [["s", "t"]], "b": [["s", "u"]]}),
            "abstract": model("abstraction-sync-two-gua-v0.1", ["A", "B"],
                              {"a": [["A", "B"]], "b": [["A", "B"]]}),
        },
    }


def truth():
    return {"op": "true"}


def atomic(name):
    return {"op": "atomic", "name": name}


def diamond(program, body=None):
    return {"op": "diamond", "program": program, "body": truth() if body is None else body}


def infinite_safe(name):
    return {"op": "box", "program": {"op": "star", "body": atomic(name)},
            "body": {"op": "and", "args": [
                {"op": "atom", "name": "K", "args": []}, diamond(atomic(name))]}}


def image_relation(beta, relation):
    return {(beta[source], beta[target]) for source, target in relation}


def lifting_report(concrete, abstract, beta, names):
    forward_failures, backward_failures = [], []
    for name in names:
        concrete_edges = concrete.relation(atomic(name))
        abstract_edges = abstract.relation(atomic(name))
        for source, target in concrete_edges:
            if (beta[source], beta[target]) not in abstract_edges:
                forward_failures.append({"program": name, "concrete_edge": [source, target]})
        for source in concrete.states:
            for abstract_source, abstract_target in abstract_edges:
                if abstract_source != beta[source]:
                    continue
                if not any(a == source and beta[b] == abstract_target for a, b in concrete_edges):
                    backward_failures.append({"program": name, "concrete_source": source,
                                              "abstract_edge": [abstract_source, abstract_target]})
    return {"forward_holds": not forward_failures, "backward_holds": not backward_failures,
            "forward_failures": forward_failures, "backward_failures": backward_failures}


def verify(examples):
    assertions, formula_evaluations = 0, 0

    def check(condition, message):
        nonlocal assertions
        assertions += 1
        if not condition:
            raise AssertionError(message)

    def holds(instance, expression, state):
        nonlocal formula_evaluations
        formula_evaluations += 1
        return instance.holds(expression, state)

    check(examples == make_examples(), "counterexample definitions differ from the frozen cases")
    first = examples["path_counterexample"]
    cm = wenli.Model(first["concrete"])
    am = wenli.Model(first["abstract"])
    beta = first["beta"]
    check(set(beta) == set(cm.states), "first beta must be total")
    check(set(beta.values()) == set(am.states), "first beta must cover abstract states")
    check(image_relation(beta, cm.relation(atomic("step"))) == am.relation(atomic("step")),
          "first abstract relation must be exactly the existential image")
    lifting_first = lifting_report(cm, am, beta, ["step"])
    check(lifting_first["forward_holds"], "first concrete edges must have abstract images")
    check(not lifting_first["backward_holds"], "first case must fail uniform successor lifting")
    two_steps = {"op": "repeat", "count": 2, "body": atomic("step")}
    check(cm.relation(two_steps) == set(), "concrete model must have no two-step path")
    check(am.relation(two_steps) == {("111", "111"), ("000", "000")}, "abstract model must have two-step cycles")
    concrete_first, abstract_first = [], []
    for state in cm.states:
        enabled = holds(cm, diamond(atomic("step")), state)
        two_possible = holds(cm, diamond(two_steps), state)
        infinite = holds(cm, infinite_safe("step"), state)
        check(enabled == (state in {"a", "c"}), "unexpected concrete terminal state")
        check(two_possible is False, "concrete two-step formula must be false")
        check(infinite is False, "concrete infinite safe formula must be false")
        concrete_first.append({"state": state, "beta": beta[state], "enabled": enabled,
                               "may_two_steps": two_possible, "all_last_infinite_K_true": infinite})
    for state in am.states:
        infinite = holds(am, infinite_safe("step"), state)
        check(infinite is True, "abstract infinite safe formula must be true")
        finite = {}
        for length in range(1, 7):
            actual = holds(am, diamond({"op": "repeat", "count": length, "body": atomic("step")}), state)
            check(actual is True, "abstract cycle must support all tested lengths")
            finite[str(length)] = actual
        abstract_first.append({"state": state, "all_last_infinite_K_true": infinite,
                               "may_steps_1_to_6": finite})

    second = examples["sync_counterexample"]
    cs = wenli.Model(second["concrete"])
    abstract_sync = wenli.Model(second["abstract"])
    beta2 = second["beta"]
    check(set(beta2) == set(cs.states), "second beta must be total")
    check(set(beta2.values()) == set(abstract_sync.states), "second beta must be onto")
    for name in ("a", "b"):
        check(image_relation(beta2, cs.relation(atomic(name))) == abstract_sync.relation(atomic(name)),
              "second atom must abstract by exact existential image")
    lifting_second = lifting_report(cs, abstract_sync, beta2, ["a", "b"])
    check(lifting_second["forward_holds"], "second atomic forward condition must hold")
    check(lifting_second["backward_holds"], "second atomic backward condition must hold for every source")
    for state in cs.states:
        check(holds(cs, {"op": "atom", "name": "K", "args": []}, state)
              == holds(abstract_sync, {"op": "atom", "name": "K", "args": []}, beta2[state]),
              "second labels must be preserved")
    sync = {"op": "sync", "args": [atomic("a"), atomic("b")]}
    concrete_sync_relation = cs.relation(sync)
    abstract_sync_relation = abstract_sync.relation(sync)
    projected_concrete_sync = image_relation(beta2, concrete_sync_relation)
    check(concrete_sync_relation == set(), "distinct concrete endpoints must make sync empty")
    check(abstract_sync_relation == {("A", "B")}, "collapsed abstract endpoint makes sync nonempty")
    check(projected_concrete_sync != abstract_sync_relation, "existential image must fail to preserve intersection here")
    concrete_can_sync = holds(cs, diamond(sync), "s")
    abstract_can_sync = holds(abstract_sync, diamond(sync), "A")
    check(concrete_can_sync is False, "concrete sync feasibility must be false")
    check(abstract_can_sync is True, "abstract sync feasibility must be true")
    concrete_no_sync = holds(cs, {"op": "box", "program": sync, "body": {"op": "false"}}, "s")
    abstract_no_sync = holds(abstract_sync, {"op": "box", "program": sync, "body": {"op": "false"}}, "A")
    check(concrete_no_sync is True and abstract_no_sync is False, "box must reflect the same common-endpoint failure")
    return {
        "all_pass": True, "assertions": assertions, "g1_formula_evaluations": formula_evaluations,
        "time_assumption": "each atomic step takes the same fixed duration delta_t=1",
        "scope": "two finite counterexamples; neither proves that every abstraction is unsound",
        "path_counterexample": {
            "beta": beta,
            "concrete_step": sorted(cm.relation(atomic("step"))),
            "abstract_step": sorted(am.relation(atomic("step"))),
            "atomic_lifting": lifting_first,
            "concrete_states": concrete_first,
            "abstract_states": abstract_first,
            "conclusion": "existentially aggregated edges may concatenate different representatives and create spurious indefinite paths",
        },
        "sync_counterexample": {
            "beta": beta2,
            "concrete_a": sorted(cs.relation(atomic("a"))), "concrete_b": sorted(cs.relation(atomic("b"))),
            "abstract_a": sorted(abstract_sync.relation(atomic("a"))), "abstract_b": sorted(abstract_sync.relation(atomic("b"))),
            "atomic_lifting": lifting_second,
            "labels_preserved": True,
            "concrete_sync": sorted(concrete_sync_relation), "abstract_sync": sorted(abstract_sync_relation),
            "image_of_concrete_sync": sorted(projected_concrete_sync),
            "concrete_sync_feasible_at_s": concrete_can_sync,
            "abstract_sync_feasible_at_A": abstract_can_sync,
            "conclusion": "per-atom successor lifting does not preserve same-endpoint intersection; a joint lifting condition is additional",
        },
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--regenerate", action="store_true", help="recreate the saved four models")
    args = parser.parse_args()
    example_path = HERE / "abstraction_examples.json"
    if args.regenerate:
        example_path.write_text(json.dumps(make_examples(), ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    if not example_path.exists():
        parser.error("abstraction_examples.json is missing; use --regenerate")
    result = verify(wenli.load_json(example_path))
    (HERE / "abstraction_results.json").write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"all_pass": result["all_pass"], "assertions": result["assertions"],
                      "g1_formula_evaluations": result["g1_formula_evaluations"],
                      "path_false_to_true": {"concrete_infinite": False, "abstract_infinite": True},
                      "sync_false_to_true": {"concrete_sync": False, "abstract_sync": True,
                                             "per_atom_lifting_holds": True}}, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
