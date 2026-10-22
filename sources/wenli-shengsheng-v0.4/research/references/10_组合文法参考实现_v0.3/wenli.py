#!/usr/bin/env python3
"""Finite, many-sorted relational grammar. Python standard library only.

The evaluator checks truth in an explicitly supplied finite model. It does not
infer that the model's interpretation is true of the historical text or world.
"""

from __future__ import annotations

import argparse
import copy
import json
import sys
from collections import deque
from pathlib import Path


class GrammarError(ValueError):
    """A malformed model, expression, or incompatible semantic category."""


def _fail(path, message):
    raise GrammarError(f"{path}: {message}")


def _object(value, path, required, optional=()):
    if not isinstance(value, dict):
        _fail(path, "expected an object")
    if any(not isinstance(key, str) for key in value):
        _fail(path, "object keys must be strings")
    missing = set(required) - value.keys()
    extra = value.keys() - set(required) - set(optional)
    if missing:
        _fail(path, f"missing keys {sorted(missing)}")
    if extra:
        _fail(path, f"unexpected keys {sorted(extra)}")
    return value


def _mapping(value, path):
    if not isinstance(value, dict):
        _fail(path, "expected an object")
    for key in value:
        _name(key, path)
    return value


def _name(value, path):
    if not isinstance(value, str) or not value.strip():
        _fail(path, "expected a nonempty string")
    return value


def _list(value, path):
    if not isinstance(value, list):
        _fail(path, "expected an array")
    return value


def _names(value, path, nonempty=False):
    values = _list(value, path)
    for item in values:
        _name(item, path)
    if len(set(values)) != len(values):
        _fail(path, "duplicate names")
    if nonempty and not values:
        _fail(path, "must not be empty")
    return tuple(values)


def _exact_keys(value, path, keys):
    return _object(value, path, keys)


class Model:
    """A fully interpreted finite model; all checks are eager at construction."""

    def __init__(self, data):
        data = copy.deepcopy(data)
        _object(data, "model",
                {"context_id", "closed_world", "states", "sorts", "constants", "predicates", "programs"},
                {"formula_defs", "program_defs", "norms"})
        self.context_id = _name(data["context_id"], "model.context_id")
        if data["closed_world"] is not True:
            _fail("model.closed_world", "must explicitly be true")
        self.states = _names(data["states"], "model.states", nonempty=True)
        self._state_set = set(self.states)
        raw_sorts = _mapping(data["sorts"], "model.sorts")
        self.sorts = {key: _names(value, f"model.sorts.{key}")
                      for key, value in raw_sorts.items()}
        self.constants = {}
        for name, value in _mapping(data["constants"], "model.constants").items():
            path = f"model.constants.{name}"
            _exact_keys(value, path, {"sort", "value"})
            sort = self._sort(value["sort"], path + ".sort")
            item = _name(value["value"], path + ".value")
            if item not in self.sorts[sort]:
                _fail(path, f"value {item!r} not in sort {sort!r}")
            self.constants[name] = (sort, item)

        self.predicates = {}
        for name, value in _mapping(data["predicates"], "model.predicates").items():
            path = f"model.predicates.{name}"
            _exact_keys(value, path, {"sorts", "kind", "true_at"})
            # Repeated sorts are valid, e.g. Similar : Entity × Entity.
            arg_sorts = tuple(self._sort(s, path + ".sorts")
                              for s in _list(value["sorts"], path + ".sorts"))
            if value["kind"] != "descriptive":
                _fail(path + ".kind", "only descriptive predicates are formulas; no normative/textual/causal coercion")
            truth = _mapping(value["true_at"], path + ".true_at")
            if set(truth) != self._state_set:
                _fail(path + ".true_at", "must interpret every state, with no extra states")
            extension = {}
            for state, rows in truth.items():
                tuples = []
                for row in _list(rows, path + f".true_at.{state}"):
                    row = _list(row, path + ".tuple")
                    if len(row) != len(arg_sorts):
                        _fail(path + ".tuple", "predicate tuple arity mismatch")
                    for item, sort in zip(row, arg_sorts):
                        _name(item, path + ".tuple")
                        if item not in self.sorts[sort]:
                            _fail(path + ".tuple", f"value {item!r} not in sort {sort!r}")
                    tuples.append(tuple(row))
                if len(set(tuples)) != len(tuples):
                    _fail(path + ".true_at", "duplicate tuples")
                extension[state] = frozenset(tuples)
            self.predicates[name] = (arg_sorts, extension)

        self.programs = {}
        for name, value in _mapping(data["programs"], "model.programs").items():
            edges = []
            path = f"model.programs.{name}"
            for edge in _list(value, path):
                edge = _list(edge, path + ".edge")
                if len(edge) != 2:
                    _fail(path, "each edge must have exactly two states")
                self._state(edge[0], path)
                self._state(edge[1], path)
                edges.append(tuple(edge))
            if len(set(edges)) != len(edges):
                _fail(path, "duplicate edges")
            self.programs[name] = frozenset(edges)

        self.formula_defs = _mapping(data.get("formula_defs", {}), "model.formula_defs")
        self.program_defs = _mapping(data.get("program_defs", {}), "model.program_defs")
        self._checked_defs = set()
        self._active_defs = []
        for name in self.formula_defs:
            self._check_definition("formula", name)
        for name in self.program_defs:
            self._check_definition("program", name)

        self.norms = {}
        allowed_judgments = {"required", "permitted", "forbidden", "undetermined"}
        for name, value in _mapping(data.get("norms", {}), "model.norms").items():
            path = f"model.norms.{name}"
            _exact_keys(value, path, {"actions", "judgments"})
            actions = _names(value["actions"], path + ".actions")
            judgments = _mapping(value["judgments"], path + ".judgments")
            if set(judgments) != self._state_set:
                _fail(path, "norm must explicitly judge every state")
            for state, row in judgments.items():
                _mapping(row, path + ".judgments." + state)
                if set(row) != set(actions):
                    _fail(path, "norm must explicitly judge every declared action")
                for judgment in row.values():
                    if not isinstance(judgment, str) or judgment not in allowed_judgments:
                        _fail(path, "invalid normative judgment")
            self.norms[name] = (actions, judgments)

    def _sort(self, value, path):
        value = _name(value, path)
        if value not in self.sorts:
            _fail(path, f"undeclared sort {value!r}")
        return value

    def _state(self, value, path="state"):
        value = _name(value, path)
        if value not in self._state_set:
            _fail(path, f"unknown state {value!r}")
        return value

    def _check_term(self, term, env, path):
        if not isinstance(term, dict) or len(term) != 1:
            _fail(path, "term must have exactly one of const or var")
        if "const" in term:
            name = _name(term["const"], path)
            if name not in self.constants:
                _fail(path, f"undeclared constant {name!r}")
            return self.constants[name][0]
        if "var" in term:
            name = _name(term["var"], path)
            if name not in env:
                _fail(path, f"unbound variable {name!r}")
            return env[name]
        _fail(path, "term must use const or var")

    def _op(self, ast, path):
        if not isinstance(ast, dict) or "op" not in ast:
            _fail(path, "expression must be an object with op")
        return _name(ast["op"], path + ".op")

    def _check_definition(self, kind, name):
        _name(name, "definition name")
        definitions = self.formula_defs if kind == "formula" else self.program_defs
        if name not in definitions:
            _fail("definition", f"undeclared {kind} definition {name!r}")
        key = (kind, name)
        if key in self._active_defs:
            cycle = self._active_defs[self._active_defs.index(key):] + [key]
            _fail("definition", "cyclic definitions: " + " -> ".join(f"{k}:{n}" for k, n in cycle))
        if key in self._checked_defs:
            return
        self._active_defs.append(key)
        try:
            checker = self._check_formula if kind == "formula" else self._check_program
            # Named definitions are closed. External bindings cannot be captured.
            checker(definitions[name], {}, f"{kind}_defs.{name}")
            self._checked_defs.add(key)
        finally:
            self._active_defs.pop()

    def _check_formula(self, ast, env, path):
        op = self._op(ast, path)
        if op in {"true", "false"}:
            _exact_keys(ast, path, {"op"})
        elif op == "atom":
            _exact_keys(ast, path, {"op", "name", "args"})
            name = _name(ast["name"], path + ".name")
            if name not in self.predicates:
                _fail(path, f"undeclared descriptive predicate {name!r}")
            actual = tuple(self._check_term(t, env, path + f".args[{i}]")
                           for i, t in enumerate(_list(ast["args"], path + ".args")))
            if actual != self.predicates[name][0]:
                _fail(path, f"predicate signature mismatch: expected {self.predicates[name][0]}, got {actual}")
        elif op == "eq":
            _exact_keys(ast, path, {"op", "left", "right"})
            left = self._check_term(ast["left"], env, path + ".left")
            right = self._check_term(ast["right"], env, path + ".right")
            if left != right:
                _fail(path, "equality requires terms of the same sort")
        elif op == "not":
            _exact_keys(ast, path, {"op", "arg"})
            self._check_formula(ast["arg"], env, path + ".arg")
        elif op in {"and", "or"}:
            _exact_keys(ast, path, {"op", "args"})
            for i, arg in enumerate(_list(ast["args"], path + ".args")):
                self._check_formula(arg, env, path + f".args[{i}]")
        elif op == "implies":
            _exact_keys(ast, path, {"op", "left", "right"})
            self._check_formula(ast["left"], env, path + ".left")
            self._check_formula(ast["right"], env, path + ".right")
        elif op in {"forall", "exists"}:
            _exact_keys(ast, path, {"op", "var", "sort", "body"})
            name = _name(ast["var"], path + ".var")
            sort = self._sort(ast["sort"], path + ".sort")
            if name in env:
                _fail(path, f"variable rebinding is forbidden: {name!r}")
            self._check_formula(ast["body"], {**env, name: sort}, path + ".body")
        elif op in {"diamond", "box"}:
            _exact_keys(ast, path, {"op", "program", "body"})
            self._check_program(ast["program"], env, path + ".program")
            self._check_formula(ast["body"], env, path + ".body")
        elif op == "fref":
            _exact_keys(ast, path, {"op", "name"})
            self._check_definition("formula", ast["name"])
        else:
            _fail(path, f"unknown Formula operator {op!r}; Program and Norm are not Formula")

    def _check_program(self, ast, env, path):
        op = self._op(ast, path)
        if op == "atomic":
            _exact_keys(ast, path, {"op", "name"})
            name = _name(ast["name"], path + ".name")
            if name not in self.programs:
                _fail(path, f"undeclared program {name!r}")
        elif op == "skip":
            _exact_keys(ast, path, {"op"})
        elif op == "test":
            _exact_keys(ast, path, {"op", "condition"})
            self._check_formula(ast["condition"], env, path + ".condition")
        elif op in {"seq", "choice", "sync"}:
            _exact_keys(ast, path, {"op", "args"})
            args = _list(ast["args"], path + ".args")
            if op == "sync" and len(args) < 2:
                _fail(path, "sync requires at least two programs")
            for i, arg in enumerate(args):
                self._check_program(arg, env, path + f".args[{i}]")
        elif op == "star":
            _exact_keys(ast, path, {"op", "body"})
            self._check_program(ast["body"], env, path + ".body")
        elif op == "repeat":
            _exact_keys(ast, path, {"op", "count", "body"})
            count = ast["count"]
            if type(count) is not int or count < 0:
                _fail(path + ".count", "must be a nonnegative integer, not bool")
            self._check_program(ast["body"], env, path + ".body")
        elif op == "pref":
            _exact_keys(ast, path, {"op", "name"})
            self._check_definition("program", ast["name"])
        else:
            _fail(path, f"unknown Program operator {op!r}; Formula and Norm are not Program")

    def check_formula(self, ast):
        self._check_formula(ast, {}, "formula")
        return "Formula"

    def check_program(self, ast):
        self._check_program(ast, {}, "program")
        return "Program"

    def _term_value(self, term, env):
        if "const" in term:
            return self.constants[term["const"]][1]
        return env[term["var"]]

    def _eval_formula(self, ast, state, env):
        op = ast["op"]
        if op == "true":
            return True
        if op == "false":
            return False
        if op == "atom":
            values = tuple(self._term_value(t, env) for t in ast["args"])
            return values in self.predicates[ast["name"]][1][state]
        if op == "eq":
            return self._term_value(ast["left"], env) == self._term_value(ast["right"], env)
        if op == "not":
            return not self._eval_formula(ast["arg"], state, env)
        if op == "and":
            return all(self._eval_formula(a, state, env) for a in ast["args"])
        if op == "or":
            return any(self._eval_formula(a, state, env) for a in ast["args"])
        if op == "implies":
            return not self._eval_formula(ast["left"], state, env) or self._eval_formula(ast["right"], state, env)
        if op in {"forall", "exists"}:
            truths = (self._eval_formula(ast["body"], state, {**env, ast["var"]: value})
                      for value in self.sorts[ast["sort"]])
            return all(truths) if op == "forall" else any(truths)
        if op in {"diamond", "box"}:
            targets = {target for source, target in self._eval_program(ast["program"], env) if source == state}
            truths = (self._eval_formula(ast["body"], target, env) for target in targets)
            return any(truths) if op == "diamond" else all(truths)
        if op == "fref":
            return self._eval_formula(self.formula_defs[ast["name"]], state, {})
        raise AssertionError("unreachable after type checking")

    @staticmethod
    def _compose(first, second):
        index = {}
        for source, target in second:
            index.setdefault(source, set()).add(target)
        return frozenset((source, target)
                         for source, middle in first
                         for target in index.get(middle, ()))

    def _identity(self):
        return frozenset((state, state) for state in self.states)

    def _closure(self, relation):
        adjacent = {state: set() for state in self.states}
        for source, target in relation:
            adjacent[source].add(target)
        result = set()
        for source in self.states:
            seen = {source}
            queue = deque([source])
            while queue:
                current = queue.popleft()
                for target in adjacent[current] - seen:
                    seen.add(target)
                    queue.append(target)
            result.update((source, target) for target in seen)
        return frozenset(result)

    def _eval_program(self, ast, env):
        op = ast["op"]
        if op == "atomic":
            return self.programs[ast["name"]]
        if op == "skip":
            return self._identity()
        if op == "test":
            return frozenset((s, s) for s in self.states if self._eval_formula(ast["condition"], s, env))
        if op == "seq":
            result = self._identity()
            for arg in ast["args"]:
                result = self._compose(result, self._eval_program(arg, env))
            return result
        if op == "choice":
            result = frozenset()
            for arg in ast["args"]:
                result = result | self._eval_program(arg, env)
            return result
        if op == "sync":
            result = self._eval_program(ast["args"][0], env)
            for arg in ast["args"][1:]:
                result = result & self._eval_program(arg, env)
            return result
        if op == "star":
            return self._closure(self._eval_program(ast["body"], env))
        if op == "repeat":
            # Exponentiation by squaring also handles very large finite n.
            result = self._identity()
            power = self._eval_program(ast["body"], env)
            count = ast["count"]
            while count:
                if count & 1:
                    result = self._compose(result, power)
                count >>= 1
                if count:
                    power = self._compose(power, power)
            return result
        if op == "pref":
            return self._eval_program(self.program_defs[ast["name"]], {})
        raise AssertionError("unreachable after type checking")

    def holds(self, ast, state):
        self.check_formula(ast)
        self._state(state)
        return self._eval_formula(ast, state, {})

    def relation(self, ast):
        self.check_program(ast)
        return self._eval_program(ast, {})

    def successors(self, ast, state):
        self._state(state)
        return frozenset(target for source, target in self.relation(ast) if source == state)

    def judge(self, norm, state, action):
        _name(norm, "norm")
        self._state(state)
        _name(action, "action")
        if norm not in self.norms:
            _fail("norm", f"undeclared norm {norm!r}")
        actions, judgments = self.norms[norm]
        if action not in actions:
            _fail("action", f"action {action!r} is not declared by norm {norm!r}")
        return judgments[state][action]

    def decision(self, norm, state, action, program):
        """Combine an explicit norm with feasibility of a caller-bound program.

        This neither infers action/program identity nor ranks ethical choices.
        `None` means the action is feasible but the supplied norm is undecided.
        """
        judgment = self.judge(norm, state, action)
        feasible = bool(self.successors(program, state))
        if not feasible or judgment == "forbidden":
            eligible = False
        elif judgment == "undetermined":
            eligible = None
        else:
            eligible = True
        return {"judgment": judgment, "feasible": feasible, "eligible": eligible}

    def _signature(self):
        # Definitions must be identical; interpretations may vary across models.
        return {
            "context_id": self.context_id,
            "states": sorted(self.states),
            "sorts": {k: sorted(v) for k, v in self.sorts.items()},
            "constants": self.constants,
            "predicates": {k: v[0] for k, v in self.predicates.items()},
            "programs": sorted(self.programs),
            "formula_defs": self.formula_defs,
            "program_defs": self.program_defs,
            "norm_actions": {k: sorted(v[0]) for k, v in self.norms.items()},
        }


def assess(models, ast, state):
    """Supervaluate a formula over a nonempty, explicitly enumerated model set.

    'unknown' means disagreement among the supplied candidates. This does not
    claim that the candidates exhaust all possibilities in the real world.
    """
    if not isinstance(models, (list, tuple)) or not models:
        _fail("assess", "requires a nonempty list of Model objects")
    if any(not isinstance(model, Model) for model in models):
        _fail("assess", "all candidates must be Model objects")
    signature = models[0]._signature()
    if any(model._signature() != signature for model in models[1:]):
        _fail("assess", "candidate model signatures are incompatible")
    results = {model.holds(ast, state) for model in models}
    if results == {True}:
        return "true"
    if results == {False}:
        return "false"
    return "unknown"


def _unique_object(pairs):
    result = {}
    for key, value in pairs:
        if key in result:
            raise GrammarError(f"JSON: duplicate key {key!r}")
        result[key] = value
    return result


def load_json(path):
    try:
        return json.loads(Path(path).read_text(encoding="utf-8"), object_pairs_hook=_unique_object,
                          parse_constant=lambda s: _fail("JSON", f"nonfinite number {s}"))
    except (OSError, UnicodeError, json.JSONDecodeError) as exc:
        raise GrammarError(f"cannot read JSON: {exc}") from exc


def run_bundle(bundle):
    _object(bundle, "bundle", {"model"}, {"title", "notes", "queries", "relations", "norm_queries"})
    model = Model(bundle["model"])
    results = []
    for item in _list(bundle.get("queries", []), "queries"):
        _exact_keys(item, "query", {"name", "state", "formula", "expected"})
        _name(item["name"], "query.name")
        if type(item["expected"]) is not bool:
            _fail("query.expected", "must be a bool")
        actual = model.holds(item["formula"], item["state"])
        results.append({"name": item["name"], "type": "formula", "actual": actual,
                        "expected": item["expected"], "pass": actual == item["expected"]})
    for item in _list(bundle.get("relations", []), "relations"):
        _exact_keys(item, "relation query", {"name", "program", "expected"})
        _name(item["name"], "relation query.name")
        expected = []
        for edge in _list(item["expected"], "relation query.expected"):
            if not isinstance(edge, list) or len(edge) != 2:
                _fail("relation query.expected", "expected two-state edges")
            model._state(edge[0])
            model._state(edge[1])
            expected.append(tuple(edge))
        if len(set(expected)) != len(expected):
            _fail("relation query.expected", "duplicate edges")
        actual = model.relation(item["program"])
        results.append({"name": item["name"], "type": "program", "actual": sorted(actual),
                        "expected": sorted(expected), "pass": actual == frozenset(expected)})
    for item in _list(bundle.get("norm_queries", []), "norm_queries"):
        _exact_keys(item, "norm query", {"name", "norm", "state", "action", "expected"})
        _name(item["name"], "norm query.name")
        if not isinstance(item["expected"], str) or item["expected"] not in {"required", "permitted", "forbidden", "undetermined"}:
            _fail("norm query.expected", "invalid normative judgment")
        actual = model.judge(item["norm"], item["state"], item["action"])
        results.append({"name": item["name"], "type": "norm", "actual": actual,
                        "expected": item["expected"], "pass": actual == item["expected"]})
    return {"title": bundle.get("title", ""), "all_pass": all(r["pass"] for r in results),
            "checks": len(results), "results": results}


def main(argv=None):
    parser = argparse.ArgumentParser(description="Check and execute a finite relational grammar example bundle.")
    parser.add_argument("bundle", type=Path)
    args = parser.parse_args(argv)
    try:
        result = run_bundle(load_json(args.bundle))
    except GrammarError as exc:
        print(json.dumps({"error": str(exc)}, ensure_ascii=False), file=sys.stderr)
        return 2
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0 if result["all_pass"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
