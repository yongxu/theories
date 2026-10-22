#!/usr/bin/env python3
"""Exact modern bridge examples; standard library only; imports the G1 engine."""

from __future__ import annotations

import argparse
import importlib.util
import json
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
ENGINE_DIR = "10_组合文法参考实现_v0.3"
CASES = (
    ("decay", "消退", Fraction(1, 2), Fraction(1, 2)),
    ("hold", "幅度保持", Fraction(1), Fraction(1)),
    ("grow", "放大失稳", Fraction(2), Fraction(1)),
    ("one_way", "单向无返程", Fraction(0), Fraction(1)),
)


def load_engine(explicit=None):
    if explicit:
        candidates = [Path(explicit).expanduser().resolve()]
    else:
        candidates = []
        for directory in (HERE, *HERE.parents):
            candidates.extend((directory / "outputs" / ENGINE_DIR / "wenli.py",
                               directory / ENGINE_DIR / "wenli.py"))
    engine = next((path for path in candidates if path.is_file()), None)
    if engine is None:
        raise FileNotFoundError("G1 engine not found; use --engine /path/to/wenli.py")
    spec = importlib.util.spec_from_file_location("wenli_bridge_reference", engine)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"Cannot import {engine}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module, engine


def truth():
    return {"op": "true"}


def atom(name):
    return {"op": "atom", "name": name, "args": []}


def atomic(name):
    return {"op": "atomic", "name": name}


def modal(op, program, body):
    return {"op": op, "program": program, "body": body}


def diamond(program, body):
    return modal("diamond", program, body)


def box(program, body):
    return modal("box", program, body)


def conjunction(*args):
    return {"op": "and", "args": list(args)}


def sequence(*args):
    return {"op": "seq", "args": list(args)}


def star(program):
    return {"op": "star", "body": program}


def repeat(program, count):
    return {"op": "repeat", "count": count, "body": program}


def guarantee(pre, program, post):
    return {"op": "implies", "left": pre,
            "right": conjunction(diamond(program, truth()), box(program, post))}


def predicate(states, true_states):
    selected = set(true_states)
    return {"sorts": [], "kind": "descriptive",
            "true_at": {state: ([[]] if state in selected else []) for state in states}}


def finite_model(context, states, predicates, programs, formulas=None):
    return {"context_id": context, "closed_world": True, "states": states,
            "sorts": {}, "constants": {},
            "predicates": {name: predicate(states, selected)
                           for name, selected in predicates.items()},
            "programs": programs, "formula_defs": formulas or {},
            "program_defs": {}, "norms": {}}


def a_update(state, p, q):
    x, y = state
    return p * y, q * x


def make_a_data():
    cases = []
    for name, label, p, q in CASES:
        state = (Fraction(1), Fraction(0))
        trace = []
        for t in range(13):
            x, y = state
            norm = max(abs(x), abs(y))
            trace.append({"t": t, "x": float(x), "y": float(y),
                          "norm_inf": float(norm), "x_exact": str(x),
                          "y_exact": str(y), "norm_inf_exact": str(norm)})
            state = a_update(state, p, q)
        cases.append({"id": name, "label": label, "p": float(p), "q": float(q),
                      "p_exact": str(p), "q_exact": str(q),
                      "loop_gain": float(p * q), "loop_gain_exact": str(p * q),
                      "initial": [1, 0], "dt_seconds": 1, "trace": trace})
    return {"rule": "x_next=p*y; y_next=q*x", "orientation": "q:A->B, p:B->A",
            "A": {"cases": cases}}


def make_a_topology(p, q):
    states = ["A", "B"]
    ab = [["A", "B"]] if q else []
    ba = [["B", "A"]] if p else []
    return finite_model("bridge-A-influence-location-v0.1", states,
                        {"AtA": ["A"], "AtB": ["B"]},
                        {"AB": ab, "BA": ba, "hop": ab + ba})


def b_name(state):
    level, mode = state
    return f"{level}{mode}"


def b_states(hysteresis=True):
    return [(level, mode) for level in range(7) for mode in ("ON", "OFF")
            if (mode == "ON" if level <= 2 else mode == "OFF" if level >= 4
                else True)] if hysteresis else [(level, "ON" if level <= 3 else "OFF")
                                                for level in range(7)]


def b_update(state, hysteresis=True):
    level, mode = state
    next_level = level + (2 if mode == "ON" else 0) - 1
    if hysteresis:
        next_mode = "ON" if next_level <= 2 else "OFF" if next_level >= 4 else mode
    else:
        next_mode = "ON" if next_level <= 3 else "OFF"
    return next_level, next_mode


def make_b(hysteresis=True):
    pairs = b_states(hysteresis)
    states = [b_name(state) for state in pairs]
    tick = atomic("tick")
    two = repeat(tick, 2)
    predicates = {
        "On": [b_name(s) for s in pairs if s[1] == "ON"],
        "Off": [b_name(s) for s in pairs if s[1] == "OFF"],
        "Band": [b_name(s) for s in pairs if 2 <= s[0] <= 4],
        "High": ["4OFF"], "Low": ["2ON"],
        "Level3": [b_name(s) for s in pairs if s[0] == 3],
    }
    formulas = {
        "Enabled": diamond(tick, truth()),
        "CanResume": diamond(star(tick), atom("On")),
        "AlwaysOff": box(star(tick), atom("Off")),
        "ReachesBand": diamond(star(tick), atom("Band")),
        "BandForever": box(star(tick), conjunction(atom("Band"), diamond(tick, truth()))),
        "HighToLow": guarantee(atom("High"), two, atom("Low")),
        "LowToHigh": guarantee(atom("Low"), two, atom("High")),
        "HighRoundTrip": guarantee(atom("High"), sequence(two, two), atom("High")),
        "DeadBoxLow": box(atomic("dead"), atom("Low")),
        "DeadEnabled": diamond(atomic("dead"), truth()),
        "DeadGuarantee": guarantee(atom("High"), atomic("dead"), atom("Low")),
    }
    return finite_model("bridge-B-hysteretic-tank-v0.1" if hysteresis else
                        "bridge-B-memoryless-tank-v0.1", states, predicates,
                        {"tick": [[b_name(s), b_name(b_update(s, hysteresis))] for s in pairs],
                         "dead": []}, formulas)


def orbit(start, successor):
    seen, path = {}, []
    state = start
    while state not in seen:
        seen[state] = len(path)
        path.append(state)
        state = successor[state]
    index = seen[state]
    return path[:index], path[index:]


def canonical_cycle(cycle):
    return min(tuple(cycle[i:] + cycle[:i]) for i in range(len(cycle)))


def cycle_report(model):
    successor = dict(model["programs"]["tick"])
    cycles, entries = {}, {}
    for start in model["states"]:
        transient, cycle = orbit(start, successor)
        key = canonical_cycle(cycle)
        cycles.setdefault(key, []).append(start)
        entries[start] = len(transient)
    result = []
    for cycle, basin in sorted(cycles.items()):
        switches = sum(state.endswith("ON") != cycle[(i + 1) % len(cycle)].endswith("ON")
                       for i, state in enumerate(cycle))
        result.append({"cycle": list(cycle), "period_seconds": len(cycle),
                       "basin": basin, "switches_per_period": switches,
                       "long_run_switches_per_second": switches / len(cycle)})
    return {"cycles": result, "entry_steps": entries, "max_entry_seconds": max(entries.values())}


def b_trace(hysteresis=True):
    state, trace = (4, "OFF"), []
    for t in range(13):
        trace.append({"t": t, "state": b_name(state), "level": state[0], "mode": state[1]})
        state = b_update(state, hysteresis)
    return trace


class Checks:
    def __init__(self):
        self.assertions = 0
        self.g1_evaluations = 0

    def equal(self, actual, expected, description):
        self.assertions += 1
        if actual != expected:
            raise AssertionError(f"{description}: {actual!r} != {expected!r}")

    def holds(self, model, formula, state):
        self.g1_evaluations += 1
        return model.holds(formula, state)


def verify(engine):
    check = Checks()
    a_data = make_a_data()
    topologies = {name: make_a_topology(p, q) for name, _, p, q in CASES}
    b_data, comparator = make_b(), make_b(False)
    models = {"A_topology": topologies, "B_hysteresis": b_data, "B_memoryless": comparator}
    topology_results = {}
    expected_final = {"decay": Fraction(1, 4096), "hold": Fraction(1),
                      "grow": Fraction(64), "one_way": Fraction(0)}
    for (name, _, p, q), case in zip(CASES, a_data["A"]["cases"]):
        for basis in ((Fraction(1), Fraction(0)), (Fraction(0), Fraction(1))):
            check.equal(a_update(a_update(basis, p, q), p, q),
                        tuple(p * q * value for value in basis), name + " M²=pqI basis")
        for point in case["trace"]:
            t, k = point["t"], point["t"] // 2
            expected = ((p * q) ** k, Fraction(0)) if t % 2 == 0 else (Fraction(0), q * (p * q) ** k)
            check.equal((Fraction(point["x_exact"]), Fraction(point["y_exact"])), expected,
                        f"{name} closed form t={t}")
            check.equal(Fraction(point["norm_inf_exact"]), max(map(abs, expected)), name + " norm")
        check.equal(Fraction(case["trace"][-1]["norm_inf_exact"]), expected_final[name], name + " t12")
        model = engine.Model(topologies[name])
        queries = {
            "outbound_A_to_B": diamond(atomic("AB"), atom("AtB")),
            "return_A_to_B_to_A": diamond(sequence(atomic("AB"), atomic("BA")), atom("AtA")),
            "all_reachable_locations_have_next_hop": box(star(atomic("hop")), diamond(atomic("hop"), truth())),
        }
        actual = {label: check.holds(model, formula, "A") for label, formula in queries.items()}
        check.equal(actual, {"outbound_A_to_B": True,
                            "return_A_to_B_to_A": bool(p),
                            "all_reachable_locations_have_next_hop": bool(p)}, name + " topology")
        topology_results[name] = {"initial": "A", "queries": queries, "values": actual}
    check.equal(topologies["decay"], topologies["hold"], "same loop, decay vs hold")
    check.equal(topologies["hold"], topologies["grow"], "same loop, hold vs growth")

    pairs = b_states()
    check.equal(len(pairs), 8, "B legal state count")
    for state in pairs:
        check.equal(b_update(state) in pairs, True, "B transition closure " + b_name(state))
    model = engine.Model(b_data)
    memoryless_model = engine.Model(comparator)
    tick, two = atomic("tick"), repeat(atomic("tick"), 2)
    roundtrip = sequence(two, two)
    table = {}
    for state in b_data["states"]:
        row = {name: check.holds(model, {"op": "fref", "name": name}, state)
               for name in b_data["formula_defs"]}
        table[state] = row
        expected = {
            "Enabled": True, "CanResume": True, "AlwaysOff": False, "ReachesBand": True,
            "BandForever": state in ("2ON", "3ON", "3OFF", "4OFF"),
            "HighToLow": True, "LowToHigh": True, "HighRoundTrip": True,
            "DeadBoxLow": True, "DeadEnabled": False, "DeadGuarantee": state != "4OFF",
        }
        check.equal(row, expected, "B modal query table " + state)
    pre_states = [s for s in model.states if check.holds(model, atom("High"), s)]
    middle_states = [s for s in model.states if check.holds(model, atom("Low"), s)]
    check.equal(pre_states, ["4OFF"], "P states nonempty")
    check.equal(middle_states, ["2ON"], "Q states nonempty")
    composition = {"definition": "C(P,pi,Q)=P implies (<pi>true and [pi]Q)",
                   "P_states": pre_states, "Q_states": middle_states, "R_states": pre_states,
                   "pi": two, "rho": two, "steps": [],
                   "all_states_satisfy_first_guarantee": all(r["HighToLow"] for r in table.values()),
                   "all_states_satisfy_second_guarantee": all(r["LowToHigh"] for r in table.values()),
                   "all_states_satisfy_composed_guarantee": all(r["HighRoundTrip"] for r in table.values())}
    for start, program, expected in (("4OFF", two, {"2ON"}), ("2ON", two, {"4OFF"}),
                                     ("4OFF", roundtrip, {"4OFF"})):
        targets = model.successors(program, start)
        check.equal(set(targets), expected, "nonempty guarantee endpoint " + start)
        composition["steps"].append({"start": start, "program": program, "end_states": sorted(targets),
                                     "nonempty": bool(targets)})
    check.equal(check.holds(model, guarantee(atom("High"), repeat(tick, 3), atom("High")), "4OFF"),
                False, "wrong duration does not give arbitrary round trip")
    check.equal(set(model.successors(tick, "3ON")), {"4OFF"}, "level3 ON next")
    check.equal(set(model.successors(tick, "3OFF")), {"2ON"}, "level3 OFF next")
    check.equal(model.successors(atomic("dead"), "4OFF"), frozenset(), "dead has no endpoint")
    hysteresis_report, memoryless_report = cycle_report(b_data), cycle_report(comparator)
    check.equal(len(hysteresis_report["cycles"]), 1, "B unique recurrent cycle")
    cycle = hysteresis_report["cycles"][0]
    check.equal(cycle["cycle"], ["2ON", "3ON", "4OFF", "3OFF"], "B cycle")
    check.equal(len(cycle["basin"]), 8, "B cycle basin")
    check.equal(hysteresis_report["max_entry_seconds"], 2, "B max entry time")
    check.equal(cycle["long_run_switches_per_second"], 0.5, "hysteretic switching rate")
    check.equal(memoryless_report["cycles"][0]["cycle"], ["3ON", "4OFF"], "memoryless cycle")
    check.equal(memoryless_report["cycles"][0]["long_run_switches_per_second"], 1.0, "memoryless switching rate")
    for state in comparator["states"]:
        check.equal(check.holds(memoryless_model, diamond(tick, truth()), state), True,
                    "memoryless enabled " + state)
    trace = b_trace()
    check.equal([row["state"] for row in trace[:5]], ["4OFF", "3OFF", "2ON", "3ON", "4OFF"], "B 4 step witness")
    results = {
        "scope": {"status": "modern stipulated examples; exact model evaluation, not empirical validation",
                  "time": "each physical update tick has fixed delta_t=1 second",
                  "classical_mapping": "Tai/Pi and Gen are interpretive analogies, not sources of these update laws",
                  "A_state": "real signal perturbation amplitudes (x,y), not conserved resource or information amounts",
                  "A_G1_state": "finite influence-token location only; not a finite abstraction certificate for amplitudes",
                  "B_state": "integer tank level plus remembered pump mode after controller update"},
        "A": {**a_data["A"], "rule": a_data["rule"], "orientation": a_data["orientation"],
              "identity": "M^2=pq I; z_(2k)=(pq)^k z_0; z_(2k+1)=(pq)^k M z_0",
              "topology_checks": topology_results,
              "counterexample": "identical bidirectional graphs yield decay, persistence, or unbounded exponential growth",
              "limits": "infinite-time conclusions use the exact linear identity; a 12-step trace alone does not prove them"},
        "B": {"dt_seconds": 1, "level_unit": "arbitrary volume unit",
              "plant": "inflow ON=2, OFF=0, drain=1 unit/second",
              "relay": "new level<=2 => ON; >=4 => OFF; otherwise retain prior mode",
              "state_count": 8, "transition_count": 8, "trace": trace,
              "queries_all_states": table, "composition": composition,
              "recurrence": hysteresis_report,
              "memoryless_comparator": {"rule": "new level<=3 => ON, else OFF",
                                        "trace": b_trace(False), "recurrence": memoryless_report},
              "counterexamples": {
                  "stop_is_not_absorbing": ["4OFF", "3OFF", "2ON"],
                  "level_alone_loses_memory": {"3ON": "4OFF", "3OFF": "2ON"},
                  "vacuous_box": {"state": "4OFF", "box_dead_Low": True,
                                  "diamond_dead_true": False, "executable_guarantee": False},
                  "arbitrary_composition_fails": {"state": "4OFF", "ticks": 3, "High_postcondition": False}},
              "limits": "finite noise-free relay example; closed recurrent class is not a proof of physical robustness"},
        "verification": {"assertions": check.assertions, "g1_formula_evaluations": check.g1_evaluations,
                         "passed": True},
    }
    return {"a_data.json": a_data, "models.json": models, "results.json": results}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--engine", help="explicit path to the existing wenli.py")
    parser.add_argument("--check", action="store_true", help="recompute and compare existing JSON; do not rewrite")
    args = parser.parse_args()
    engine, engine_path = load_engine(args.engine)
    artifacts = verify(engine)
    for filename, data in artifacts.items():
        path = HERE / filename
        if args.check:
            if json.loads(path.read_text(encoding="utf-8")) != data:
                raise AssertionError(f"Saved artifact differs from recomputation: {path}")
        else:
            path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"engine": str(engine_path), "mode": "check" if args.check else "write",
                      **artifacts["results.json"]["verification"]}, ensure_ascii=False))


if __name__ == "__main__":
    main()
