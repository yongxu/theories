#!/usr/bin/env python3
"""Enumerate trigram/hexagram transformations and check finite G1 models.

All update laws here are modern stipulated examples. A successful evaluation is
an exact result for those finite models, not historical or empirical validation.
"""

from __future__ import annotations

import argparse
import importlib.util
import itertools
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
ENGINE = HERE.parent / "10_组合文法参考实现_v0.3" / "wenli.py"
spec = importlib.util.spec_from_file_location("wenli_bagua_reference", ENGINE)
if spec is None or spec.loader is None:
    raise RuntimeError(f"Cannot load the shared G1 engine: {ENGINE}")
wenli = importlib.util.module_from_spec(spec)
spec.loader.exec_module(wenli)


# Leftmost character is the bottom line, not the usual printed top line.
TRIGRAMS = (
    ("乾", "111"), ("兑", "110"), ("离", "101"), ("震", "100"),
    ("巽", "011"), ("坎", "010"), ("艮", "001"), ("坤", "000"),
)
NAMES = dict((code, name) for name, code in TRIGRAMS)
CODES = tuple(code for _, code in TRIGRAMS)
RULES = ("identity", "zero", "negrotate")
CONTEXT_ID = "bagua-bottom-middle-top-fixed-domain-v0.1"


def bits(code):
    return tuple(int(bit) for bit in code)


def code(values):
    return "".join(str(value) for value in values)


def complement(values):
    return tuple(1 - bit for bit in values)


def reversal(values):
    return tuple(reversed(values))


def flip(values, position):
    return tuple(1 - bit if index == position else bit
                 for index, bit in enumerate(values))


def identity(values):
    return tuple(values)


def zero(values):
    return (0, values[0], values[1])


def negrotate(values):
    return (1 - values[2], values[0], values[1])


UPDATES = {"identity": identity, "zero": zero, "negrotate": negrotate}


def swap_halves(values):
    return tuple(values[3:]) + tuple(values[:3])


def hu(values):
    return (values[1], values[2], values[3], values[2], values[3], values[4])


def iterate(function, values, count):
    for _ in range(count):
        values = function(values)
    return values


def true():
    return {"op": "true"}


def atom(name):
    return {"op": "atom", "name": name, "args": []}


def atomic(name):
    return {"op": "atomic", "name": name}


def fref(name):
    return {"op": "fref", "name": name}


def pref(name):
    return {"op": "pref", "name": name}


def modal(op, program, body):
    return {"op": op, "program": program, "body": body}


def diamond(program, body):
    return modal("diamond", program, body)


def box(program, body):
    return modal("box", program, body)


def conjunction(*formulas):
    return {"op": "and", "args": list(formulas)}


def star(program):
    return {"op": "star", "body": program}


def predicate(true_states):
    allowed = set(true_states)
    return {"sorts": [], "kind": "descriptive",
            "true_at": {state: ([[]] if state in allowed else []) for state in CODES}}


def make_models():
    models = {}
    single_line = [[state, code(flip(bits(state), position))]
                   for state in CODES for position in range(3)]
    common_programs = {
        "one_line": single_line,
        "flip_bottom": [[state, code(flip(bits(state), 0))] for state in CODES],
        "flip_middle": [[state, code(flip(bits(state), 1))] for state in CODES],
        "flip_top": [[state, code(flip(bits(state), 2))] for state in CODES],
    }
    for name in RULES:
        update = UPDATES[name]
        predicates = {"DemoK": predicate(state for state in CODES if state != "000")}
        predicates.update({"Is_" + state: predicate([state]) for state in CODES})
        formulas = {
            "K": atom("DemoK"),
            "Enabled": diamond(atomic("tick"), true()),
            "MayLast_0": fref("K"),
            "AllLast_0": fref("K"),
        }
        for length in range(1, 9):
            formulas["MayLast_" + str(length)] = conjunction(
                fref("K"), diamond(atomic("tick"), fref("MayLast_" + str(length - 1))))
            formulas["AllLast_" + str(length)] = conjunction(
                fref("K"), fref("Enabled"),
                box(atomic("tick"), fref("AllLast_" + str(length - 1))))
        formulas["AllLast_infinite"] = box(
            star(atomic("tick")), conjunction(fref("K"), fref("Enabled")))
        models[name] = {
            "context_id": CONTEXT_ID,
            "closed_world": True,
            "states": list(CODES),
            "sorts": {"Trigram": list(CODES)},
            "constants": {"gua_" + state: {"sort": "Trigram", "value": state}
                          for state in CODES},
            "predicates": predicates,
            "programs": {**common_programs,
                         "tick": [[state, code(update(bits(state)))] for state in CODES]},
            "formula_defs": formulas,
            "program_defs": {
                "potential": star(atomic("one_line")),
                "safe_tick": {"op": "seq", "args": [
                    {"op": "test", "condition": fref("K")},
                    atomic("tick"),
                    {"op": "test", "condition": fref("K")},
                ]},
            },
            "norms": {},
        }
    return {
        "title": "八卦离散动力学的三个G1模型",
        "encoding": {
            "order": ["bottom", "middle", "top"],
            "zero": "阴", "one": "阳",
            "trigrams": [{"name": name, "code": state} for name, state in TRIGRAMS],
            "context_id": CONTEXT_ID,
        },
        "interpretation": {
            "status": "modern_stipulated_models",
            "tick": "each fixed-rule update takes the same stipulated duration delta_t=1 in an arbitrary fixed time unit",
            "tick_duration": {"value": 1, "unit": "arbitrary_fixed_time_unit"},
            "one_line": "exactly one of the three positions flips",
            "potential": "one_line reflexive-transitive closure, allowing zero or several flips",
            "DemoK": "all states except 000, an arbitrary test constraint, not an evaluation of 坤",
            "shared_context": "same encoding, objects, scale, and symbols; only tick interpretation varies",
        },
        "rules": {
            "identity": {"formula": "F(b1,b2,b3)=(b1,b2,b3)", "model": models["identity"]},
            "zero": {"formula": "F(b1,b2,b3)=(0,b1,b2)", "model": models["zero"]},
            "negrotate": {"formula": "F(b1,b2,b3)=(1-b3,b1,b2)", "model": models["negrotate"]},
        },
    }


def trace_until_repeat(function, start):
    order = []
    indices = {}
    current = start
    while current not in indices:
        indices[current] = len(order)
        order.append(current)
        current = code(function(bits(current)))
    entry = indices[current]
    return {"prefix": order[:entry], "cycle": order[entry:], "entry_step": entry,
            "period": len(order) - entry}


def reachable(edges, start):
    adjacency = {state: set() for state in CODES}
    for source, target in edges:
        adjacency[source].add(target)
    seen, todo = {start}, [start]
    while todo:
        node = todo.pop()
        for target in adjacency[node] - seen:
            seen.add(target)
            todo.append(target)
    return seen


def components_and_basins(edges):
    reach = {state: reachable(edges, state) for state in CODES}
    components = []
    unassigned = set(CODES)
    for state in CODES:
        if state not in unassigned:
            continue
        component = {other for other in CODES if other in reach[state] and state in reach[other]}
        unassigned -= component
        components.append([other for other in CODES if other in component])
    terminal = [component for component in components
                if not any(source in component and target not in component for source, target in edges)]
    recurrent = []
    for component in terminal:
        has_cycle = len(component) > 1 or any((node, node) in edges for node in component)
        recurrent.append({
            "states": component,
            "names": [NAMES[state] for state in component],
            "has_cycle": has_cycle,
            "basin": [state for state in CODES if any(target in reach[state] for target in component)],
        })
    return components, recurrent


def verify(bundle):
    check_count = 0

    def check(condition, message):
        nonlocal check_count
        check_count += 1
        if not condition:
            raise AssertionError(message)

    check(bundle == make_models(), "bagua_models.json does not match the frozen encoding and rule definitions")
    bit_vectors = [bits(state) for state in CODES]
    check(set(bit_vectors) == set(itertools.product((0, 1), repeat=3)), "eight encodings must be bijective")
    single_edges = {(state, code(flip(bits(state), index))) for state in CODES for index in range(3)}
    undirected = {tuple(sorted((a, b))) for a, b in single_edges}
    check(len(single_edges) == 24, "single-line graph must have 24 directed edges")
    check(len(undirected) == 12, "single-line graph must have 12 undirected edges")
    for state in CODES:
        check(sum(a == state for a, _ in single_edges) == 3, "out-degree must be three")
        check(sum(b == state for _, b in single_edges) == 3, "in-degree must be three")
        for target in [b for a, b in single_edges if a == state]:
            check(sum(x != y for x, y in zip(state, target)) == 1, "each local edge changes exactly one line")
    for vector in bit_vectors:
        check(complement(complement(vector)) == vector, "C must be involutive")
        check(reversal(reversal(vector)) == vector, "R must be involutive")
        check(complement(reversal(vector)) == reversal(complement(vector)), "C and R must commute")
        for position in range(3):
            check(flip(flip(vector, position), position) == vector, "line flips must be involutive")
        check(iterate(zero, vector, 3) == (0, 0, 0), "zero update must converge in at most three steps")
        check(iterate(negrotate, vector, 3) == complement(vector), "negrotate cubed must equal C")
        check(iterate(negrotate, vector, 6) == vector, "negrotate sixth power must be identity")
    r_fixed = [state for state in CODES if reversal(bits(state)) == bits(state)]
    check(set(r_fixed) == {"111", "101", "010", "000"}, "R-fixed trigrams differ")
    check(not any(complement(vector) == vector for vector in bit_vectors), "C has no binary fixed point")

    hexagrams = list(itertools.product((0, 1), repeat=6))
    stacks = {lower + upper for lower in bit_vectors for upper in bit_vectors}
    check(stacks == set(hexagrams) and len(stacks) == 64, "stacking must give all 64 hexagrams once")
    fibers = {}
    six_rows = []
    non_idempotent_examples = []
    for vector in hexagrams:
        h = hu(vector)
        fibers.setdefault(code(h), []).append(code(vector))
        check(swap_halves(swap_halves(vector)) == vector, "swap must be involutive")
        check(reversal(reversal(vector)) == vector, "R6 must be involutive")
        check(complement(complement(vector)) == vector, "C6 must be involutive")
        check(complement(reversal(vector)) == reversal(complement(vector)), "C6 and R6 must commute")
        check(complement(swap_halves(vector)) == swap_halves(complement(vector)), "C6 and swap must commute")
        check(reversal(vector) == reversal(vector[3:]) + reversal(vector[:3]), "R6 must reverse both order and internal triples")
        check(h[1] == h[3] and h[2] == h[4], "hu image coordinate constraints fail")
        if hu(h) != h:
            non_idempotent_examples.append({"input": code(vector), "hu": code(h), "hu_twice": code(hu(h))})
        six_rows.append({"code": code(vector), "lower": code(vector[:3]), "upper": code(vector[3:]),
                         "swap": code(swap_halves(vector)), "reverse6": code(reversal(vector)),
                         "complement6": code(complement(vector)), "hu": code(h)})
    check(len(fibers) == 16, "hu must have sixteen distinct images")
    check({len(preimages) for preimages in fibers.values()} == {4}, "each hu image must have four preimages")
    check(hu(bits("000000")) == hu(bits("100001")), "explicit hu collision missing")
    check(bool(non_idempotent_examples), "hu is not generally an idempotent projection")
    swap_fixed = [code(v) for v in hexagrams if swap_halves(v) == v]
    reverse_fixed = [code(v) for v in hexagrams if reversal(v) == v]
    check(len(swap_fixed) == 8, "swap has eight fixed hexagrams")
    check(len(reverse_fixed) == 8, "R6 has eight fixed hexagrams")
    check(not any(complement(v) == v for v in hexagrams), "C6 has no fixed point")

    engine_checks = 0
    rule_results = {}
    model_objects = []
    k_set = set(CODES) - {"000"}
    for name in RULES:
        update = UPDATES[name]
        model = wenli.Model(bundle["rules"][name]["model"])
        model_objects.append(model)
        edges = {(state, code(update(bits(state)))) for state in CODES}
        check(model.relation(atomic("tick")) == edges, name + " tick relation differs")
        check(model.relation(atomic("one_line")) == single_edges, "local potential graph differs")
        check(model.relation(pref("potential")) == set(itertools.product(CODES, repeat=2)), "potential closure must have 64 pairs")
        components, recurrent = components_and_basins(edges)
        check(all(item["has_cycle"] for item in recurrent), "terminal component here must contain a cycle")
        state_results = []
        for state in CODES:
            trace = [code(iterate(update, bits(state), count)) for count in range(9)]
            enabled = model.holds(fref("Enabled"), state)
            check(enabled is True, "all three chosen update laws are total")
            engine_checks += 1
            may, all_last = [], []
            for length in range(9):
                expected = all(item in k_set for item in trace[:length + 1])
                actual_may = model.holds(fref("MayLast_" + str(length)), state)
                actual_all = model.holds(fref("AllLast_" + str(length)), state)
                check(actual_may == expected, f"{name}/{state}/MayLast_{length}")
                check(actual_all == expected, f"{name}/{state}/AllLast_{length}")
                engine_checks += 2
                may.append(actual_may)
                all_last.append(actual_all)
            orbit = trace_until_repeat(update, state)
            expected_infinite = set(orbit["prefix"] + orbit["cycle"]).issubset(k_set)
            actual_infinite = model.holds(fref("AllLast_infinite"), state)
            check(actual_infinite == expected_infinite, f"{name}/{state}/AllLast_infinite")
            check(may[len(k_set)] == expected_infinite, "finite safe-path bound must match reachable safe cycle")
            engine_checks += 1
            lawful_reachable = reachable(edges, state)
            for target in CODES:
                p = diamond(pref("potential"), atom("Is_" + target))
                q = diamond(star(atomic("tick")), atom("Is_" + target))
                check(model.holds(p, state) is True, "any state is potentially reachable via single flips")
                check(model.holds(q, state) == (target in lawful_reachable), "lawful reachability differs")
                engine_checks += 2
            state_results.append({
                "state": state, "name": NAMES[state], "enabled": enabled,
                "trace_0_to_8": trace, "trace_names": [NAMES[item] for item in trace],
                "orbit": orbit, "may_last_0_to_8": may, "all_last_0_to_8": all_last,
                "all_last_infinite": actual_infinite,
                "lawful_reachable": [item for item in CODES if item in lawful_reachable],
            })
        periods = sorted({trace_until_repeat(update, state)["period"] for state in CODES})
        fixed = [state for state in CODES if code(update(bits(state))) == state]
        cycles = []
        for component in recurrent:
            cycle = trace_until_repeat(update, component["states"][0])["cycle"]
            cycles.append({"states_in_tick_order": cycle,
                           "names_in_tick_order": [NAMES[item] for item in cycle],
                           "period": len(cycle), "basin": component["basin"]})
        rule_results[name] = {
            "formula": bundle["rules"][name]["formula"],
            "tick_edges": [[state, code(update(bits(state)))] for state in CODES],
            "single_line_tick_edges": sorted([list(edge) for edge in edges & single_edges]),
            "multiline_tick_edges": sorted([list(edge) for edge in edges if edge[0] != edge[1] and edge not in single_edges]),
            "self_loop_tick_edges": sorted([list(edge) for edge in edges if edge[0] == edge[1]]),
            "fixed_points": fixed, "periods": periods,
            "cycles": cycles,
            "max_transient_steps": max(item["orbit"]["entry_step"] for item in state_results),
            "strongly_connected_components": components,
            "closed_terminal_components": recurrent,
            "states": state_results,
            "infinite_demo_K_states": [item["state"] for item in state_results if item["all_last_infinite"]],
        }
    check(len(rule_results["identity"]["fixed_points"]) == 8, "identity must have eight fixed points")
    check(rule_results["zero"]["fixed_points"] == ["000"], "zero must have only Kun fixed")
    check(rule_results["zero"]["periods"] == [1], "zero's only recurrent period is one")
    check(rule_results["negrotate"]["fixed_points"] == [], "negrotate has no fixed point")
    check(rule_results["negrotate"]["periods"] == [2, 6], "negrotate period set must be two and six")
    neg_components = {frozenset(item["states"]) for item in rule_results["negrotate"]["closed_terminal_components"]}
    check(neg_components == {frozenset({"101", "010"}), frozenset(set(CODES) - {"101", "010"})}, "negrotate component partition differs")
    epistemic = {state: wenli.assess(model_objects, fref("AllLast_infinite"), state) for state in CODES}
    engine_checks += len(CODES) * len(model_objects)
    for state in CODES:
        check(epistemic[state] == ("false" if state == "000" else "unknown"), "same symbols do not determine dynamics")
    return {
        "all_pass": True,
        "checks": check_count,
        "g1_formula_evaluations": engine_checks,
        "encoding": bundle["encoding"],
        "model_status": "modern_stipulated_finite_models_not_empirical_or_historical_laws",
        "trigram_transformations": {
            "directed_single_line_edges": 24,
            "undirected_single_line_edges": 12,
            "one_line_edges": sorted([list(edge) for edge in single_edges]),
            "potential_closure_pairs": 64,
            "C_involution": True, "R_involution": True, "C_R_commute": True,
            "R_fixed": r_fixed, "R_fixed_names": [NAMES[item] for item in r_fixed],
            "C_fixed": [],
            "mapping": [{"state": state, "name": NAMES[state],
                         "C": code(complement(bits(state))), "R": code(reversal(bits(state)))}
                        for state in CODES],
        },
        "hexagram_transformations": {
            "stack_count": 64, "encoding": "bottom_to_top = lower_triple + upper_triple",
            "swap_involution": True, "reverse6_involution": True, "complement6_involution": True,
            "C6_R6_commute": True, "C6_swap_commute": True,
            "swap_fixed_count": len(swap_fixed), "swap_fixed": swap_fixed,
            "reverse6_fixed_count": len(reverse_fixed), "reverse6_fixed": reverse_fixed,
            "complement6_fixed_count": 0,
            "hu": {
                "formula": "(b2,b3,b4,b3,b4,b5)", "image_count": len(fibers),
                "preimages_per_image": 4, "invertible": False, "idempotent": False,
                "collision": {"inputs": ["000000", "100001"], "output": "000000"},
                "non_idempotent_example": non_idempotent_examples[0],
                "fibers": fibers,
            },
            "mapping": six_rows,
        },
        "rules": rule_results,
        "assess_across_three_rules": {"formula": "AllLast_infinite", "results": epistemic},
        "scope": {
            "DemoK": "000 excluded only for an arbitrary constraint demonstration; 坤 is not bad or dead",
            "SCC": "closed terminal SCCs of these total finite maps are recurrent classes; no continuous-space attractor claim",
            "tick_vs_one_line": "fixed-rule ticks may change zero, one, two, or three lines; not all are cube edges",
            "time": "each tick takes the same fixed duration delta_t=1; tests, skips, and zero-step closure do not advance time",
            "hu": "coordinate selection and recombination, not an idempotent linear projection",
        },
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--regenerate", action="store_true", help="regenerate bagua_models.json from the frozen definitions")
    args = parser.parse_args()
    models_path = HERE / "bagua_models.json"
    if args.regenerate:
        models_path.write_text(json.dumps(make_models(), ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    if not models_path.exists():
        parser.error("bagua_models.json is missing; use --regenerate to create it")
    bundle = wenli.load_json(models_path)
    results = verify(bundle)
    (HERE / "results.json").write_text(json.dumps(results, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"all_pass": results["all_pass"], "checks": results["checks"],
                      "g1_formula_evaluations": results["g1_formula_evaluations"],
                      "rules": {name: {"periods": item["periods"], "fixed_points": item["fixed_points"],
                                        "infinite_demo_K_states": item["infinite_demo_K_states"]}
                                for name, item in results["rules"].items()},
                      "hu": {"image_count": 16, "preimages_per_image": 4, "invertible": False, "idempotent": False}},
                     ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
