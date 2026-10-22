#!/usr/bin/env python3
"""Generate and verify 13 typed-edge witnesses from explicit modern raw inputs."""

from __future__ import annotations

import argparse
import copy
import importlib.util
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
ENGINE_DIR = "10_组合文法参考实现_v0.3"
EDGE_NAMES = ["生—变", "变—势", "势—理", "分—合", "合—中", "中—和", "生—分",
              "变—合", "势—中", "理—和", "生—合", "合—势", "中—理"]


def load_engine(explicit):
    candidates = [Path(explicit)] if explicit else [HERE.parent / "core" / "wenli.py"] + [p / sub / "wenli.py"
        for p in (HERE, *HERE.parents)
        for sub in (Path("outputs") / ENGINE_DIR, Path(ENGINE_DIR))]
    path = next((p for p in candidates if p.is_file()), None)
    if path is None:
        raise FileNotFoundError("Use --engine /path/to/10_组合文法参考实现_v0.3/wenli.py")
    spec = importlib.util.spec_from_file_location("wenli_v04_reference", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def atom(name, *terms):
    return {"op": "atom", "name": name, "args": [{"const": t} for t in terms]}


def op(name):
    return {"op": "atomic", "name": name}


def true():
    return {"op": "true"}


def neg(body):
    return {"op": "not", "arg": body}


def conj(*args):
    return {"op": "and", "args": list(args)}


def seq(*args):
    return {"op": "seq", "args": list(args)}


def sync(*args):
    return {"op": "sync", "args": list(args)}


def test(body):
    return {"op": "test", "condition": body}


def star(body):
    return {"op": "star", "body": body}


def dia(program, body):
    return {"op": "diamond", "program": program, "body": body}


def box(program, body):
    return {"op": "box", "program": program, "body": body}


def born(kind, entity, program):
    return seq(test(neg(atom("E", kind, entity))), program, test(atom("E", kind, entity)))


def ended(kind, entity, program):
    return seq(test(atom("E", kind, entity)), program, test(neg(atom("E", kind, entity))))


def changed(kind, entity, program):
    return {"op": "choice", "args": [born(kind, entity, program), ended(kind, entity, program)]}


def raw_inputs():
    return {
        "schema_version": "v0.4.0",
        "scope": "modern stipulated models; no empirical mechanism or historical universal law is claimed",
        "time": "each world event is one fixed positive step; reasoning tests do not advance time",
        "reorganization": {
            "entities": ["A", "B", "C", "D"], "parts": ["u", "v"],
            "initial": {"active": ["A"], "holdings": {"A": ["u", "v"]},
                        "bonds": [["u", "v"]], "information": ["u", "v"],
                        "resource": 2, "compatible_pairs": [["u", "v"]],
                        "lineage": [], "window_open": True, "task_required": True,
                        "completed_tasks": []},
            "events": [
                ["s0", "split", "s1"], ["s0", "cut_in_place", "s_cut"],
                ["s1", "merge", "s2"], ["s1", "merge_lossy", "s3"],
                ["s1", "drain", "s1_empty"], ["s1", "spoil", "s1_bad"],
                ["s1", "delay", "s1_late"],
                ["s1_empty", "attempt_merge", "s_empty_fail"],
                ["s1_bad", "attempt_merge", "s_bad_fail"],
                ["s1_late", "merge", "s2_late"],
            ],
            "merge_cost": 1, "operate_cost": 1,
            "operate_rule": "for every generated state, generate an operate edge iff Coord(D) and resource>=operate_cost; its output records task completion",
            "norm_N_timely": {
                "actions": ["merge", "merge_lossy"],
                "rule": "closed window => forbidden; open window with task_required => required; else permitted",
                "scope": "timing-only illustrative norm; does not assess identity, information, coordination or moral optimality"},
        },
        "constraints": {
            "states": ["start", "p", "q", "goal", "harm"],
            "candidate_edges": [["start", "p"], ["start", "harm"], ["p", "q"],
                                ["q", "p"], ["q", "goal"], ["goal", "goal"], ["harm", "harm"]],
            "safe_allow": "exclude edges whose target is harm",
            "overrestrict_allow": "exclude edges whose target is goal",
            "goal_states": ["goal"], "harm_states": ["harm"],
        },
        "expression_norms": {
            "context": "one explicit illustrative meeting-expression standard, not a reconstruction of all Zhongyong ethics",
            "initial": {"manifestations": []},
            "express_fit": [{"affect": "anger", "form": "reasoned_objection"},
                            {"affect": "joy", "form": "quiet_acknowledgment"}],
            "express_excess": [{"affect": "anger", "form": "insult"}],
            "N_expression": {"action": "assess_expression",
                "allowed_forms": {"anger": ["reasoned_objection"], "joy": ["quiet_acknowledgment"],
                                  "sorrow": ["solemn_statement"], "pleasure": ["moderate_praise"]},
                "rule": "unexpressed => undetermined; expressed and every manifestation allowed => permitted; else forbidden",
                "reading": "permitted/forbidden are this declared expression norm's harmony/non-harmony judgments; never inherited from N_timely"},
        },
    }


def connected(parts, bonds):
    if not parts:
        return False
    seen, pending = {parts[0]}, [parts[0]]
    while pending:
        current = pending.pop()
        for a, b in bonds:
            if current in (a, b):
                other = b if current == a else a
                if other in parts and other not in seen:
                    seen.add(other)
                    pending.append(other)
    return seen == set(parts)


def organization(state, entity):
    parts = state["holdings"].get(entity, [])
    return entity in state["active"] and len(parts) >= 2 and connected(parts, state["bonds"])


def coordinate(state, entity):
    parts = state["holdings"].get(entity, [])
    compatible = {frozenset(pair) for pair in state["compatible_pairs"]}
    return (organization(state, entity) and set(parts) <= set(state["information"])
            and all(frozenset((a, b)) in compatible for i, a in enumerate(parts) for b in parts[i + 1:]))


def perform(state, event, config):
    result = copy.deepcopy(state)
    if event == "split":
        if not organization(state, "A"):
            raise ValueError("split requires A organization")
        result.update(active=["B", "C"], holdings={"B": ["u"], "C": ["v"]}, bonds=[])
        result["lineage"] += [["A", "B"], ["A", "C"]]
    elif event == "cut_in_place":
        result["bonds"] = []
    elif event in ("merge", "merge_lossy", "attempt_merge"):
        enough = state["resource"] >= config["merge_cost"]
        supplied = state["active"] == ["B", "C"] and state["holdings"] == {"B": ["u"], "C": ["v"]}
        compatible = ["u", "v"] in state["compatible_pairs"]
        if not (enough and supplied and compatible):
            if event != "attempt_merge":
                raise ValueError("effectful merge requires supply, compatibility and resources")
            return result  # Executed attempt with no new organization, rather than a hidden missing outcome.
        result.update(active=["D"], holdings={"D": ["u", "v"]}, bonds=[["u", "v"]])
        result["resource"] -= config["merge_cost"]
        result["lineage"] += [["B", "D"], ["C", "D"]]
        if event == "merge_lossy":
            result["information"].remove("v")
    elif event == "drain":
        result["resource"] = 0
    elif event == "spoil":
        result["compatible_pairs"] = []
    elif event == "delay":
        result["window_open"] = False
    elif event == "operate":
        if not coordinate(state, "D") or state["resource"] < config["operate_cost"]:
            raise ValueError("operate requires derived coordination and enough resource")
        result["resource"] -= config["operate_cost"]
        result["completed_tasks"].append("task")
    else:
        raise ValueError(event)
    return result


def empty_model(context, states, sorts=None):
    sorts = sorts or {}
    return {"context_id": context, "closed_world": True, "states": list(states), "sorts": sorts,
            "constants": {v: {"sort": key, "value": v} for key, values in sorts.items() for v in values},
            "predicates": {}, "programs": {}, "formula_defs": {}, "program_defs": {}, "norms": {}}


def add_pred(model, name, sorts, facts):
    model["predicates"][name] = {"sorts": sorts, "kind": "descriptive",
                                "true_at": {s: sorted(facts(s)) for s in model["states"]}}


def reorg_fact(raw, name, values):
    if name == "E":
        kind, entity = values
        if kind == "Org":
            return organization(raw, entity)
        return entity in raw["active"] and len(raw["holdings"].get(entity, [])) == 1
    if name == "L":
        return list(values) in raw["lineage"]
    if name == "Coord":
        return coordinate(raw, values[0])
    if name == "InfoComplete":
        return {"u", "v"} <= set(raw["information"])
    if name == "Done":
        return "task" in raw["completed_tasks"]
    if name == "ResourceEnough":
        return raw["resource"] >= 1
    if name == "Compatible":
        return ["u", "v"] in raw["compatible_pairs"]
    raise KeyError(name)


def build_models(inputs):
    config = inputs["reorganization"]
    snapshots = {"s0": config["initial"]}
    events = copy.deepcopy(config["events"])
    for source, event, target in events:
        snapshots[target] = perform(snapshots[source], event, config)
    for source, snapshot in list(snapshots.items()):
        if coordinate(snapshot, "D") and snapshot["resource"] >= config["operate_cost"]:
            target = {"s2": "s_done", "s2_late": "s_done_late"}.get(source, source + "_done")
            snapshots[target] = perform(snapshot, "operate", config)
            events.append([source, "operate", target])
    model = empty_model("G1-v04-reorganization-fixed-identity", snapshots,
                        {"Entity": config["entities"], "Kind": ["Org", "Unit"]})
    add_pred(model, "E", ["Kind", "Entity"], lambda s: [[k, e] for k in ["Org", "Unit"]
             for e in config["entities"] if reorg_fact(snapshots[s], "E", [k, e])])
    add_pred(model, "L", ["Entity", "Entity"], lambda s: snapshots[s]["lineage"])
    add_pred(model, "Coord", ["Entity"], lambda s: [[e] for e in config["entities"]
             if coordinate(snapshots[s], e)])
    for name in ["InfoComplete", "Done", "ResourceEnough", "Compatible"]:
        add_pred(model, name, [], lambda s, n=name: [[]] if reorg_fact(snapshots[s], n, []) else [])
    programs = {name: [] for name in {event for _, event, _ in events}}
    for source, event, target in events:
        programs[event].append([source, target])
        if event == "merge":
            programs["attempt_merge"].append([source, target])
    all_edges = sorted({(s, t) for s, _, t in events})
    programs["change_membership"] = [[s, t] for s, t in all_edges
                                     if snapshots[s]["holdings"] != snapshots[t]["holdings"]]
    programs["change_resource"] = [[s, t] for s, t in all_edges
                                   if snapshots[s]["resource"] != snapshots[t]["resource"]]
    programs["preserve_information"] = [[s, t] for s, t in all_edges
                                        if set(snapshots[s]["information"]) <= set(snapshots[t]["information"])]
    programs["structural_allowed"] = [[s, t] for s, t in all_edges
        if all(pair in snapshots[t]["compatible_pairs"] for pair in snapshots[t]["bonds"])]
    model["programs"] = {key: sorted(value) for key, value in sorted(programs.items())}
    actions = config["norm_N_timely"]["actions"]
    def timely(raw):
        return "forbidden" if not raw["window_open"] else "required" if raw["task_required"] else "permitted"
    model["norms"]["N_timely"] = {"actions": actions,
        "judgments": {s: {a: timely(raw) for a in actions} for s, raw in snapshots.items()}}

    c = inputs["constraints"]
    cm = empty_model("G1-v04-constraint-reachability", c["states"])
    for name, values in [("Goal", c["goal_states"]), ("Harm", c["harm_states"])]:
        add_pred(cm, name, [], lambda s, v=values: [[]] if s in v else [])
    cm["programs"] = {"move": c["candidate_edges"],
        "allow_safe": [[s, t] for s, t in c["candidate_edges"] if t not in c["harm_states"]],
        "allow_overrestrict": [[s, t] for s, t in c["candidate_edges"] if t not in c["goal_states"]],
        "allow_without_goal_loop": [[s, t] for s, t in c["candidate_edges"] if [s, t] != ["goal", "goal"]]}

    e = inputs["expression_norms"]
    expression_states = {"n0": e["initial"], "n_fit": {"manifestations": e["express_fit"]},
                         "n_excess": {"manifestations": e["express_excess"]}}
    em = empty_model("G1-v04-expression-specific-norm", expression_states)
    add_pred(em, "Unexpressed", [], lambda s: [[]] if not expression_states[s]["manifestations"] else [])
    add_pred(em, "Expressed", [], lambda s: [[]] if expression_states[s]["manifestations"] else [])
    em["programs"] = {"express_fit": [["n0", "n_fit"]], "express_excess": [["n0", "n_excess"]],
                      "express": [["n0", "n_fit"], ["n0", "n_excess"]]}
    def expression_judgment(raw):
        manifestations = raw["manifestations"]
        if not manifestations:
            return "undetermined"
        return "permitted" if all(item["form"] in e["N_expression"]["allowed_forms"].get(item["affect"], [])
                                  for item in manifestations) else "forbidden"
    em["norms"]["N_expression"] = {"actions": ["assess_expression"],
        "judgments": {s: {"assess_expression": expression_judgment(raw)} for s, raw in expression_states.items()}}
    trace = []
    for source, event, target in events:
        before, after = snapshots[source], snapshots[target]
        old_e = {(k, e) for k in ["Org", "Unit"] for e in config["entities"] if reorg_fact(before, "E", [k, e])}
        new_e = {(k, e) for k in ["Org", "Unit"] for e in config["entities"] if reorg_fact(after, "E", [k, e])}
        trace.append({"source": source, "event": event, "target": target,
            "raw_before": before, "raw_after": after,
            "derived": {"entered_modes": sorted(map(list, new_e - old_e)),
                        "exited_modes": sorted(map(list, old_e - new_e)),
                        "new_lineage": [pair for pair in after["lineage"] if pair not in before["lineage"]],
                        "information_lost": sorted(set(before["information"]) - set(after["information"])),
                        "resource_delta": after["resource"] - before["resource"],
                        "Coord_D_after": coordinate(after, "D"),
                        "merge_requirements_before": {
                            "parts_supplied": before["active"] == ["B", "C"] and before["holdings"] == {"B": ["u"], "C": ["v"]},
                            "resource_enough": before["resource"] >= config["merge_cost"],
                            "compatible": ["u", "v"] in before["compatible_pairs"]}}})
    return {"reorganization": model, "constraints": cm, "expression_norms": em}, {
        "reorganization": snapshots, "expression_norms": expression_states}, trace


def queries():
    q = []
    def add(identifier, model, kind, expected, **request):
        q.append({"query_id": identifier, "model": model, "kind": kind, "request": request, "expected": expected})
    def formula(identifier, model, state, ast, expected=True):
        add(identifier, model, "formula", expected, state=state, formula=ast)
    def decision(identifier, state, action, program, judgment, feasible, eligible):
        add(identifier, "reorganization", "decision", {"judgment": judgment, "feasible": feasible, "eligible": eligible},
            state=state, norm="N_timely", action=action, program=program)
    # Each success is a valid conditional instance. Counterexamples target an explicitly stronger claim.
    add("edge_01.success", "reorganization", "relation_subset", True,
        left=born("Unit", "B", op("split")), right=changed("Unit", "B", op("split")))
    add("edge_01.counterexample", "reorganization", "relation_subset", False,
        left=ended("Org", "A", op("split")), right=born("Org", "A", op("split")))
    add("edge_02.success", "constraints", "compare_reach", False, program=op("move"), left_state="start", right_state="p")
    add("edge_02.counterexample", "constraints", "compare_reach", True, program=op("move"), left_state="p", right_state="q")
    restricted = sync(op("move"), op("allow_safe"))
    add("edge_03.success", "constraints", "relation_subset", True, left=star(restricted), right=star(op("move")))
    formula("edge_03.counterexample", "constraints", "start", dia(star(sync(op("move"), op("allow_overrestrict"))), atom("Goal")), False)
    post = conj(atom("E", "Org", "D"), atom("L", "B", "D"), atom("L", "C", "D"),
                neg({"op": "eq", "left": {"const": "D"}, "right": {"const": "A"}}), atom("InfoComplete"))
    formula("edge_04.success", "reorganization", "s0", dia(seq(op("split"), op("merge")), post))
    formula("edge_04.counterexample", "reorganization", "s0", dia(seq(op("split"), op("merge_lossy")), atom("InfoComplete")), False)
    decision("edge_05.success", "s1", "merge", op("merge"), "required", True, True)
    decision("edge_05.counterexample", "s1_late", "merge", op("merge"), "forbidden", True, False)
    add("edge_06.success", "expression_norms", "judgment", "permitted", state="n_fit", norm="N_expression", action="assess_expression")
    add("edge_06.counterexample", "expression_norms", "normative_successors", {"n_excess": "forbidden", "n_fit": "permitted"},
        state="n0", program=op("express"), norm="N_expression", action="assess_expression")
    split_birth = sync(ended("Org", "A", op("split")), born("Unit", "B", op("split")), born("Unit", "C", op("split")))
    formula("edge_07.success", "reorganization", "s0", dia(split_birth, conj(atom("L", "A", "B"), atom("L", "A", "C"))))
    formula("edge_07.counterexample", "reorganization", "s0", dia(born("Unit", "B", op("cut_in_place")), true()), False)
    add("edge_08.success", "reorganization", "relation_subset", True, left=op("merge"), right=op("change_membership"))
    formula("edge_08.counterexample", "reorganization", "s1", dia(op("merge_lossy"), atom("Coord", "D")), False)
    decision("edge_09.success", "s1", "merge", op("merge"), "required", True, True)
    decision("edge_09.counterexample", "s1_empty", "merge", op("merge"), "required", False, False)
    constrained_attempt = sync(op("attempt_merge"), op("structural_allowed"))
    formula("edge_10.success", "reorganization", "s1", dia(constrained_attempt, atom("Coord", "D")))
    formula("edge_10.counterexample", "reorganization", "s1_empty", dia(constrained_attempt, atom("Coord", "D")), False)
    formula("edge_11.success", "reorganization", "s1", dia(born("Org", "D", op("merge")), true()))
    formula("edge_11.counterexample", "reorganization", "s1_bad", dia(born("Org", "D", op("attempt_merge")), true()), False)
    formula("edge_12.success", "reorganization", "s2", dia(op("operate"), atom("Done")))
    formula("edge_12.counterexample", "reorganization", "s3", dia(op("operate"), atom("Done")), False)
    decision("edge_13.success", "s1", "merge", sync(op("merge"), op("preserve_information")), "required", True, True)
    decision("edge_13.counterexample", "s1", "merge_lossy", sync(op("merge_lossy"), op("preserve_information")), "required", False, False)
    # Non-vacuity and bridge checks: these distinguish derivation from facts stipulated as conclusions.
    formula("support_birth_nonempty", "reorganization", "s0", dia(born("Unit", "B", op("split")), true()))
    formula("support_original_identity_not_restored", "reorganization", "s0", dia(seq(op("split"), op("merge")), atom("E", "Org", "A")), False)
    formula("support_lossy_still_forms_new_org", "reorganization", "s3", atom("E", "Org", "D"))
    formula("support_lossy_not_coordinated", "reorganization", "s3", atom("Coord", "D"), False)
    formula("support_insufficient_resource_no_birth", "reorganization", "s1_empty", dia(born("Org", "D", op("attempt_merge")), true()), False)
    formula("support_failed_attempt_is_executable", "reorganization", "s1_empty", dia(constrained_attempt, true()))
    formula("support_incompatible_attempt_is_executable", "reorganization", "s1_bad", dia(op("attempt_merge"), true()))
    formula("support_low_resource_compatible", "reorganization", "s1_empty", atom("Compatible"))
    formula("support_incompatible_before_attempt", "reorganization", "s1_bad", atom("Compatible"), False)
    formula("support_before_merge_no_operate", "reorganization", "s1", dia(op("operate"), atom("Done")), False)
    formula("support_composed_merge_operate", "reorganization", "s1", dia(seq(op("merge"), op("operate")), atom("Done")))
    add("support_drain_is_resource_change", "reorganization", "relation_subset", True, left=op("drain"), right=op("change_resource"))
    add("support_drain_is_not_merge", "reorganization", "relation_subset", False, left=op("drain"), right=op("merge"))
    formula("support_lineage_is_not_identity", "reorganization", "s1", conj(atom("L", "A", "B"),
            neg({"op": "eq", "left": {"const": "A"}, "right": {"const": "B"}})))
    add("support_redundant_constraint_same_reach", "constraints", "relation_equal", True,
        left=star(sync(op("move"), op("allow_without_goal_loop"))), right=star(op("move")))
    formula("support_original_graph_reaches_goal", "constraints", "start", dia(star(op("move")), atom("Goal")))
    formula("support_original_graph_all_safe", "constraints", "start", box(star(op("move")), neg(atom("Harm"))), False)
    formula("support_restricted_graph_all_safe", "constraints", "start", box(star(restricted), neg(atom("Harm"))))
    formula("support_restricted_goal_retained", "constraints", "start", dia(star(restricted), atom("Goal")))
    formula("support_unexpressed_start", "expression_norms", "n0", atom("Unexpressed"))
    formula("support_actual_expression", "expression_norms", "n0", box(op("express"), atom("Expressed")))
    add("support_unexpressed_is_not_normative_harmony", "expression_norms", "judgment", "undetermined", state="n0", norm="N_expression", action="assess_expression")
    return q


class IndependentOracle:
    """Small relational checker. Atomic facts are reevaluated from raw snapshots."""
    def __init__(self, model_id, model, inputs, snapshots):
        self.id, self.model, self.inputs, self.snapshots = model_id, model, inputs, snapshots

    def fact(self, name, values, state):
        if self.id == "reorganization":
            return reorg_fact(self.snapshots[self.id][state], name, values)
        if self.id == "constraints":
            key = {"Goal": "goal_states", "Harm": "harm_states"}[name]
            return state in self.inputs["constraints"][key]
        expressed = bool(self.snapshots[self.id][state]["manifestations"])
        return expressed if name == "Expressed" else not expressed

    def formula(self, ast, state):
        k = ast["op"]
        if k == "true": return True
        if k == "not": return not self.formula(ast["arg"], state)
        if k == "and": return all(self.formula(a, state) for a in ast["args"])
        if k == "eq": return ast["left"]["const"] == ast["right"]["const"]
        if k == "atom": return self.fact(ast["name"], [a["const"] for a in ast["args"]], state)
        targets = [t for s, t in self.relation(ast["program"]) if s == state]
        values = [self.formula(ast["body"], t) for t in targets]
        return any(values) if k == "diamond" else all(values)

    def relation(self, ast):
        k = ast["op"]
        identity = {(s, s) for s in self.model["states"]}
        if k == "atomic": return {tuple(edge) for edge in self.model["programs"][ast["name"]]}
        if k == "test": return {(s, s) for s in self.model["states"] if self.formula(ast["condition"], s)}
        if k == "star":
            base = self.relation(ast["body"])
            result = set(identity)
            while True:
                expanded = result | {(a, d) for a, b in result for c, d in base if b == c}
                if expanded == result: return result
                result = expanded
        relations = [self.relation(arg) for arg in ast["args"]]
        if k == "sync": return set.intersection(*relations)
        if k == "choice": return set.union(set(), *relations)
        result = identity
        for following in relations:
            result = {(a, d) for a, b in result for c, d in following if b == c}
        return result

    def judge(self, norm, state, action):
        if norm == "N_timely":
            raw = self.snapshots["reorganization"][state]
            if not raw["window_open"]: return "forbidden"
            return "required" if raw["task_required"] else "permitted"
        items = self.snapshots["expression_norms"][state]["manifestations"]
        if not items: return "undetermined"
        rules = self.inputs["expression_norms"]["N_expression"]["allowed_forms"]
        failures = [item for item in items if item["affect"] not in rules or item["form"] not in rules[item["affect"]]]
        return "forbidden" if failures else "permitted"


def evaluate(query, model, oracle=None):
    request, kind = query["request"], query["kind"]
    relation = oracle.relation if oracle else model.relation
    formula = oracle.formula if oracle else model.holds
    judge = oracle.judge if oracle else model.judge
    def successors(program, state):
        return sorted(t for s, t in relation(program) if s == state)
    if kind == "formula": return formula(request["formula"], request["state"])
    if kind == "relation_subset": return relation(request["left"]) <= relation(request["right"])
    if kind == "relation_equal": return relation(request["left"]) == relation(request["right"])
    if kind == "compare_reach":
        return successors(star(request["program"]), request["left_state"]) == successors(star(request["program"]), request["right_state"])
    if kind == "judgment": return judge(request["norm"], request["state"], request["action"])
    if kind == "normative_successors":
        return {s: judge(request["norm"], s, request["action"]) for s in successors(request["program"], request["state"])}
    if kind == "decision":
        if not oracle:
            return model.decision(request["norm"], request["state"], request["action"], request["program"])
        judgment = judge(request["norm"], request["state"], request["action"])
        feasible = bool(successors(request["program"], request["state"]))
        eligible = False if not feasible or judgment == "forbidden" else None if judgment == "undetermined" else True
        return {"judgment": judgment, "feasible": feasible, "eligible": eligible}
    raise KeyError(kind)


def verify(engine):
    inputs = raw_inputs()
    data, snapshots, trace = build_models(inputs)
    models = {name: engine.Model(value) for name, value in data.items()}
    oracles = {name: IndependentOracle(name, value, inputs, snapshots) for name, value in data.items()}
    raw_reorg = snapshots["reorganization"]
    enabled_operation = {s for s, raw in raw_reorg.items() if coordinate(raw, "D") and raw["resource"] >= 1}
    enabled_merge = {s for s, raw in raw_reorg.items() if raw["active"] == ["B", "C"]
                     and raw["holdings"] == {"B": ["u"], "C": ["v"]}
                     and raw["resource"] >= 1 and ["u", "v"] in raw["compatible_pairs"]}
    for name, expected in [("operate", enabled_operation), ("merge", enabled_merge)]:
        actual = {s for s, _ in data["reorganization"]["programs"][name]}
        if actual != expected:
            raise AssertionError(("action domain incomplete", name, actual, expected))
    results = []
    for query in queries():
        model_id = query["model"]
        actual = evaluate(query, models[model_id])
        independent = evaluate(query, models[model_id], oracles[model_id])
        if actual != query["expected"] or actual != independent:
            raise AssertionError((query["query_id"], actual, independent, query["expected"]))
        results.append({**query, "actual": actual, "independent_raw_oracle": independent, "passed": True})
    rejected = []
    for name, ast in [("norm_is_not_formula", atom("N_expression")),
                      ("program_is_not_formula", op("express"))]:
        try:
            models["expression_norms"].check_formula(ast)
        except engine.GrammarError as error:
            rejected.append({"id": name, "rejected": True, "reason": str(error)})
        else:
            raise AssertionError(name + " was not rejected")
    # Verify all generated factual extensions against the raw snapshot interpretation, not final query labels.
    raw_fact_checks = 0
    import itertools
    for name, model in data.items():
        for pred, declaration in model["predicates"].items():
            domains = [model["sorts"][sort] for sort in declaration["sorts"]]
            for state in model["states"]:
                for values in itertools.product(*domains):
                    raw = oracles[name].fact(pred, values, state)
                    stored = list(values) in declaration["true_at"][state]
                    if raw != stored: raise AssertionError((name, pred, state, values))
                    raw_fact_checks += 1
    types = ["definition_inclusion", "conditional_reachability", "constraint_monotonicity", "conditional_composition",
             "normative_interface", "expression_normative_interface", "joint_transition", "projection_change",
             "normative_interface", "conditional_coordination", "conditional_generation", "conditional_reachability", "normative_interface"]
    stronger = ["any change is birth", "every change alters the reachable profile", "more constraint or reach means better",
                "merge is split's identity/information inverse", "merging implies timely appropriateness",
                "unexpressed guarantees all later expressions satisfy the expression norm", "every structural division creates new instances",
                "merger guarantees coordination or improvement", "normatively required implies feasible", "structural admissibility alone ensures coordination",
                "attempting merger creates an organization regardless of compatibility", "all formed organizations enable the same tasks",
                "normative permission supplies an execution satisfying every structural restriction"]
    rules = [{"edge_id": f"edge_{i:02d}", "adjacency": label, "status": "verified_conditional_instance",
              "rule_type": types[i - 1], "verification": [f"edge_{i:02d}.success", f"edge_{i:02d}.counterexample"],
              "unconditional_claim": {"status": "not_inference", "claim": stronger[i - 1],
                                      "counterexample_query": f"edge_{i:02d}.counterexample"}}
             for i, label in enumerate(EDGE_NAMES, 1)]
    output = {"schema_version": "v0.4.0", "rules": rules, "queries": results, "rejections": rejected,
              "verification": {"rule_count": len(rules), "query_count": len(results),
                               "cross_checked_query_count": len(results), "raw_fact_checks": raw_fact_checks,
                               "action_domain_completeness_checks": 2, "rejection_count": len(rejected), "passed": True},
              "scope": "conditional derivation and boundary counterexamples in declared modern models; no minimum/universal/empirical claim",
              "independence_limit": "relational oracle uses different composition/closure code and raw fact lookups; both share the declared event mechanism, so this is not independent empirical validation"}
    return {"raw_inputs.json": inputs, "models.json": {"schema_version": "v0.4.0", "models": data, "derived_snapshots": snapshots},
            "transition_trace.json": {"schema_version": "v0.4.0", "trace": trace}, "rule_results.json": output}


def validate_graph(graph_path, results):
    graph = json.loads(graph_path.read_text(encoding="utf-8"))
    required = [f"edge_{i:02d}" for i in range(1, 14)]
    edges = graph["edges"]
    if [edge["edge_id"] for edge in edges] != required:
        raise AssertionError("Graph must contain the original 13 edges once, in order")
    index = {query["query_id"]: query for query in results["queries"]}
    if len(index) != len(results["queries"]):
        raise AssertionError("Duplicate engine query id")
    primary_count, support_count = 0, 0
    for edge, label in zip(edges, EDGE_NAMES):
        if edge["original_adjacency"]["nodes"] != label.split("—"):
            raise AssertionError((edge["edge_id"], "adjacency changed"))
        contract = edge["verification_contract"]
        expected_ids = [edge["edge_id"] + ".success", edge["edge_id"] + ".counterexample"]
        if contract["query_ids"] != expected_ids or contract["status"] != "bound_to_executable_queries":
            raise AssertionError((edge["edge_id"], "query contract is not bound"))
        bound_file = (graph_path.parent / contract["result_file"]).resolve()
        if bound_file != (HERE / "rule_results.json").resolve():
            raise AssertionError((edge["edge_id"], "registry points to a different result artifact", str(bound_file)))
        for identifier in contract["query_ids"]:
            query = index[identifier]
            if query["model"] != edge["model_scope"] or not query["passed"]:
                raise AssertionError((identifier, "wrong model or failed query"))
            primary_count += 1
        for identifier in contract.get("support_query_ids", []):
            if not index[identifier]["passed"]:
                raise AssertionError((identifier, "support failed"))
            support_count += 1
        expected_summaries = [{key: index[identifier][key] for key in ("query_id", "kind", "expected", "actual", "passed")}
                              for identifier in expected_ids]
        if contract.get("primary_results") != expected_summaries:
            raise AssertionError((edge["edge_id"], "registry's cached result differs from fresh evaluation"))
    return {"graph_edges": len(edges), "primary_query_links": primary_count,
            "support_query_links": support_count, "passed": True,
            "scope": "reference, model and actual-result consistency; textual interpretation still requires review"}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="recompute and compare saved JSON, without writes")
    parser.add_argument("--engine", help="path to existing v0.3 wenli.py")
    parser.add_argument("--graph", help="typed_graph.json to join-check; sibling graph/v04_graph is found automatically")
    args = parser.parse_args()
    artifacts = verify(load_engine(args.engine))
    graph_candidates = [Path(args.graph)] if args.graph else [HERE.parent / "graph" / "typed_graph.json",
                                                             HERE.parent / "v04_graph" / "typed_graph.json"]
    graph_path = next((path for path in graph_candidates if path.is_file()), None)
    if args.graph and graph_path is None:
        raise FileNotFoundError(args.graph)
    joined = validate_graph(graph_path, artifacts["rule_results.json"]) if graph_path else None
    for name, value in artifacts.items():
        path = HERE / name
        if args.check:
            if json.loads(path.read_text(encoding="utf-8")) != value:
                raise AssertionError(f"Saved artifact differs: {path}")
        else:
            path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({**artifacts["rule_results.json"]["verification"], "graph_join": joined}, ensure_ascii=False))


if __name__ == "__main__":
    main()
