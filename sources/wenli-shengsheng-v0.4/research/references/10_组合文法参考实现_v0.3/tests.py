"""Independent black-box acceptance tests for the finite typed grammar.

These fixtures and expected relations were designed from the published contract,
not from the implementation. Run this file with Python 3.
"""

from copy import deepcopy
from pathlib import Path
import sys
import itertools
import tempfile
import unittest

ENGINE_DIR = Path(__file__).resolve().parent
sys.path.insert(0, str(ENGINE_DIR))
from wenli import Model, GrammarError, assess, load_json, run_bundle


def truth():
    return {"op": "true"}


def falsehood():
    return {"op": "false"}


def const(name):
    return {"const": name}


def var(name):
    return {"var": name}


def atom(name, *terms):
    return {"op": "atom", "name": name, "args": list(terms)}


def atomic(name="step"):
    return {"op": "atomic", "name": name}


def modal(op, program, body):
    return {"op": op, "program": program, "body": body}


def base_data():
    return {
        "context_id": "test-fixed-scale-and-identity",
        "closed_world": True,
        "states": ["s0", "s1", "s2"],
        "sorts": {"Entity": ["a", "b"], "Action": ["wait", "reform"], "Empty": []},
        "constants": {
            "a": {"sort": "Entity", "value": "a"},
            "b": {"sort": "Entity", "value": "b"},
            "wait": {"sort": "Action", "value": "wait"},
        },
        "predicates": {
            "Alive": {
                "sorts": ["Entity"],
                "kind": "descriptive",
                "true_at": {"s0": [["a"]], "s1": [["b"]], "s2": [["a"], ["b"]]},
            },
            "Safe": {
                "sorts": [],
                "kind": "descriptive",
                "true_at": {"s0": [[]], "s1": [], "s2": [[]]},
            },
        },
        "programs": {"step": [["s0", "s1"], ["s1", "s2"]], "reset": [["s2", "s0"]]},
        "formula_defs": {},
        "program_defs": {},
        "norms": {
            "N": {
                "actions": ["wait", "reform"],
                "judgments": {
                    "s0": {"wait": "permitted", "reform": "forbidden"},
                    "s1": {"wait": "required", "reform": "undetermined"},
                    "s2": {"wait": "forbidden", "reform": "permitted"},
                },
            }
        },
    }


class IndependentGrammarSemantics(unittest.TestCase):
    def setUp(self):
        self.model = Model(base_data())

    def test_truth_and_closed_extension(self):
        self.assertTrue(self.model.holds(atom("Alive", const("a")), "s0"))
        self.assertFalse(self.model.holds(atom("Alive", const("a")), "s1"))
        self.assertTrue(self.model.holds({"op": "not", "arg": atom("Alive", const("a"))}, "s1"))

    def test_empty_boolean_connectives(self):
        self.assertTrue(self.model.holds({"op": "and", "args": []}, "s0"))
        self.assertFalse(self.model.holds({"op": "or", "args": []}, "s0"))

    def test_quantification(self):
        any_alive = {"op": "exists", "var": "x", "sort": "Entity", "body": atom("Alive", var("x"))}
        all_alive = {"op": "forall", "var": "x", "sort": "Entity", "body": atom("Alive", var("x"))}
        self.assertTrue(self.model.holds(any_alive, "s0"))
        self.assertFalse(self.model.holds(all_alive, "s0"))
        self.assertTrue(self.model.holds(all_alive, "s2"))

    def test_empty_domain_quantifiers(self):
        all_false = {"op": "forall", "var": "x", "sort": "Empty", "body": falsehood()}
        any_true = {"op": "exists", "var": "x", "sort": "Empty", "body": truth()}
        self.assertTrue(self.model.holds(all_false, "s0"))
        self.assertFalse(self.model.holds(any_true, "s0"))

    def test_box_dead_end_vacuity_is_not_reachability(self):
        self.assertTrue(self.model.holds(modal("box", atomic(), falsehood()), "s2"))
        self.assertFalse(self.model.holds(modal("diamond", atomic(), truth()), "s2"))

    def test_modal_result_in_target_state(self):
        self.assertFalse(self.model.holds(modal("diamond", atomic(), atom("Alive", const("a"))), "s0"))
        self.assertTrue(self.model.holds(modal("diamond", atomic(), atom("Alive", const("a"))), "s1"))

    def test_star_includes_zero_and_multiple_steps(self):
        closure = self.model.relation({"op": "star", "body": atomic()})
        self.assertEqual(closure, {("s0", "s0"), ("s1", "s1"), ("s2", "s2"),
                                   ("s0", "s1"), ("s1", "s2"), ("s0", "s2")})
        self.assertTrue(self.model.holds(modal("diamond", {"op": "star", "body": atomic()}, truth()), "s2"))

    def test_exact_repeat_not_at_most_repeat(self):
        self.assertEqual(self.model.relation({"op": "repeat", "count": 0, "body": atomic()}),
                         {("s0", "s0"), ("s1", "s1"), ("s2", "s2")})
        self.assertEqual(self.model.relation({"op": "repeat", "count": 2, "body": atomic()}), {("s0", "s2")})
        self.assertEqual(self.model.relation({"op": "repeat", "count": 3, "body": atomic()}), set())

    def test_seq_direction_and_empty_seq(self):
        self.assertEqual(self.model.relation({"op": "seq", "args": [atomic(), atomic("reset")]}), {("s1", "s0")})
        self.assertEqual(self.model.relation({"op": "seq", "args": [atomic("reset"), atomic()]}), {("s2", "s1")})
        self.assertEqual(self.model.relation({"op": "seq", "args": []}),
                         {("s0", "s0"), ("s1", "s1"), ("s2", "s2")})

    def test_empty_choice_and_sync_as_intersection(self):
        self.assertEqual(self.model.relation({"op": "choice", "args": []}), set())
        both = {"op": "choice", "args": [atomic(), atomic("reset")]}
        self.assertEqual(self.model.relation({"op": "sync", "args": [both, atomic()]}),
                         {("s0", "s1"), ("s1", "s2")})
        self.assertEqual(self.model.relation({"op": "sync", "args": [atomic(), atomic("reset")]}), set())

    def test_test_is_identity_filter(self):
        self.assertEqual(self.model.relation({"op": "test", "condition": atom("Safe")}),
                         {("s0", "s0"), ("s2", "s2")})
        filtered = {"op": "seq", "args": [{"op": "test", "condition": atom("Safe")}, atomic()]}
        self.assertEqual(self.model.relation(filtered), {("s0", "s1")})

    def test_nested_test_preserves_quantified_environment(self):
        # At s0, a is alive; at its next state only b is alive. There is no one
        # entity satisfying both the source test and target formula.
        program = {"op": "seq", "args": [{"op": "test", "condition": atom("Alive", var("x"))}, atomic()]}
        formula = {"op": "exists", "var": "x", "sort": "Entity",
                   "body": modal("diamond", program, atom("Alive", var("x")))}
        self.assertFalse(self.model.holds(formula, "s0"))
        self.assertTrue(self.model.holds(formula, "s1"))

    def test_implication_is_not_transition(self):
        implication = {"op": "implies", "left": atom("Safe"), "right": atom("Alive", const("a"))}
        self.assertTrue(self.model.holds(implication, "s0"))
        self.assertTrue(self.model.holds(implication, "s1"))
        with self.assertRaises(GrammarError):
            self.model.check_program(implication)

    def test_closed_definitions_can_use_cross_type_dag(self):
        data = base_data()
        data["formula_defs"]["AnyAlive"] = {"op": "exists", "var": "x", "sort": "Entity", "body": atom("Alive", var("x"))}
        data["program_defs"]["AliveTest"] = {"op": "test", "condition": {"op": "fref", "name": "AnyAlive"}}
        data["formula_defs"]["CanTest"] = modal("diamond", {"op": "pref", "name": "AliveTest"}, truth())
        model = Model(data)
        self.assertTrue(model.holds({"op": "fref", "name": "CanTest"}, "s0"))
        self.assertEqual(model.relation({"op": "pref", "name": "AliveTest"}),
                         {("s0", "s0"), ("s1", "s1"), ("s2", "s2")})

    def test_closed_definition_binders_are_local(self):
        data = base_data()
        data["formula_defs"]["AllAlive"] = {"op": "forall", "var": "x", "sort": "Entity", "body": atom("Alive", var("x"))}
        model = Model(data)
        formula = {"op": "exists", "var": "x", "sort": "Entity", "body": {"op": "fref", "name": "AllAlive"}}
        self.assertFalse(model.holds(formula, "s0"))
        self.assertTrue(model.holds(formula, "s2"))

    def test_norm_is_explicit_separate_judgment(self):
        self.assertEqual(self.model.judge("N", "s0", "wait"), "permitted")
        self.assertEqual(self.model.judge("N", "s1", "reform"), "undetermined")
        with self.assertRaises(GrammarError):
            self.model.holds({"op": "judge", "name": "N", "action": "wait"}, "s0")
        with self.assertRaises(GrammarError):
            self.model.holds(atom("N"), "s0")

    def test_candidate_models_unknown_not_false(self):
        other = base_data()
        other["predicates"]["Safe"]["true_at"]["s0"] = []
        second = Model(other)
        self.assertEqual(assess([self.model, second], atom("Safe"), "s0"), "unknown")
        self.assertEqual(assess([self.model, second], atom("Safe"), "s1"), "false")
        self.assertEqual(assess([self.model, second], atom("Safe"), "s2"), "true")


class IndependentGrammarRejections(unittest.TestCase):
    def setUp(self):
        self.model = Model(base_data())

    def test_no_free_variables_or_undeclared_symbols(self):
        for expression in [atom("Alive", var("x")), atom("Missing"), atom("Alive", const("missing"))]:
            with self.subTest(expression=expression), self.assertRaises(GrammarError):
                self.model.check_formula(expression)

    def test_sort_and_arity_checks(self):
        for expression in [atom("Alive", const("wait")), atom("Alive"),
                           {"op": "eq", "left": const("a"), "right": const("wait")}]:
            with self.subTest(expression=expression), self.assertRaises(GrammarError):
                self.model.check_formula(expression)

    def test_variable_rebinding_rejected(self):
        nested = {"op": "forall", "var": "x", "sort": "Entity", "body":
                  {"op": "exists", "var": "x", "sort": "Entity", "body": truth()}}
        with self.assertRaises(GrammarError):
            self.model.check_formula(nested)

    def test_malformed_or_multi_constructor_ast_rejected(self):
        bad = [{"op": "true", "args": []}, {"op": "true", "not": truth()},
               {"op": "atom", "name": "Alive", "args": [{"const": "a", "var": "x"}]},
               {"op": "not", "arg": atomic()}, {"op": "and", "args": "true"}]
        for expression in bad:
            with self.subTest(expression=expression), self.assertRaises(GrammarError):
                self.model.check_formula(expression)

    def test_repeat_count_is_natural_integer_not_bool(self):
        for count in [True, False, -1, 1.0, "1"]:
            with self.subTest(count=count), self.assertRaises(GrammarError):
                self.model.check_program({"op": "repeat", "count": count, "body": atomic()})

    def test_sync_requires_two_programs(self):
        for args in [[], [atomic()]]:
            with self.subTest(args=args), self.assertRaises(GrammarError):
                self.model.check_program({"op": "sync", "args": args})

    def test_closed_world_is_explicit_true(self):
        for value in [False, 1, "true", None]:
            data = base_data()
            data["closed_world"] = value
            with self.subTest(value=value), self.assertRaises(GrammarError):
                Model(data)
        data = base_data()
        del data["closed_world"]
        with self.assertRaises(GrammarError):
            Model(data)

    def test_missing_truth_extension_cannot_mean_false(self):
        data = base_data()
        del data["predicates"]["Alive"]["true_at"]["s1"]
        with self.assertRaises(GrammarError):
            Model(data)

    def test_predicate_tuple_sort_arity_and_state_validated(self):
        bad_rows = [[["wait"]], [["a", "b"]], [["missing"]]]
        for rows in bad_rows:
            data = base_data()
            data["predicates"]["Alive"]["true_at"]["s0"] = rows
            with self.subTest(rows=rows), self.assertRaises(GrammarError):
                Model(data)
        data = base_data()
        data["predicates"]["Alive"]["true_at"]["ghost"] = []
        with self.assertRaises(GrammarError):
            Model(data)

    def test_non_descriptive_predicate_kind_rejected(self):
        for kind in ["normative", "causal", "textual"]:
            data = base_data()
            data["predicates"]["Alive"]["kind"] = kind
            with self.subTest(kind=kind), self.assertRaises(GrammarError):
                Model(data)

    def test_no_invalid_states_or_edges(self):
        for states in [[], ["s0", "s0"], ["s0", ""]]:
            data = base_data()
            data["states"] = states
            with self.subTest(states=states), self.assertRaises(GrammarError):
                Model(data)
        data = base_data()
        data["programs"]["step"] = [["s0", "ghost"]]
        with self.assertRaises(GrammarError):
            Model(data)

    def test_definitions_do_not_capture_external_variable(self):
        data = base_data()
        data["formula_defs"]["Capture"] = atom("Alive", var("x"))
        with self.assertRaises(GrammarError):
            Model(data)
        data = base_data()
        data["program_defs"]["Capture"] = {"op": "test", "condition": atom("Alive", var("x"))}
        with self.assertRaises(GrammarError):
            Model(data)

    def test_cross_kind_definition_cycle_rejected(self):
        data = base_data()
        data["formula_defs"]["F"] = modal("diamond", {"op": "pref", "name": "P"}, truth())
        data["program_defs"]["P"] = {"op": "test", "condition": {"op": "fref", "name": "F"}}
        with self.assertRaises(GrammarError):
            Model(data)

    def test_unreachable_bad_definition_still_rejected(self):
        data = base_data()
        data["formula_defs"]["Unused"] = {"op": "fref", "name": "Undefined"}
        with self.assertRaises(GrammarError):
            Model(data)

    def test_norm_rows_must_be_complete(self):
        data = base_data()
        del data["norms"]["N"]["judgments"]["s0"]["wait"]
        with self.assertRaises(GrammarError):
            Model(data)
        data = base_data()
        data["norms"]["N"]["judgments"]["s0"]["wait"] = True
        with self.assertRaises(GrammarError):
            Model(data)

    def test_empty_candidate_set_is_not_certain(self):
        with self.assertRaises(GrammarError):
            assess([], truth(), "s0")

    def test_candidate_signatures_must_match(self):
        variants = []
        data = base_data()
        data["sorts"]["Entity"].append("c")
        variants.append(data)
        data = base_data()
        data["constants"]["a"]["value"] = "b"
        variants.append(data)
        data = base_data()
        data["programs"]["extra"] = []
        variants.append(data)
        for data in variants:
            with self.subTest(data=data), self.assertRaises(GrammarError):
                assess([self.model, Model(data)], truth(), "s0")

    def test_unknown_query_state_or_norm_action_rejected(self):
        with self.assertRaises(GrammarError):
            self.model.holds(truth(), "ghost")
        with self.assertRaises(GrammarError):
            self.model.judge("N", "s0", "missing")


class IndependentGrammarBoundaryChecks(unittest.TestCase):
    def test_all_three_state_graph_closures_and_exact_lengths(self):
        # BFS computes reflexive reachability independently; explicit frontier
        # iteration computes exact path length, including cyclic walks.
        states = ["s0", "s1", "s2"]
        possible = list(itertools.product(states, repeat=2))
        for bits in range(1 << len(possible)):
            edges = {edge for bit, edge in enumerate(possible) if bits & (1 << bit)}
            data = base_data()
            data["programs"]["step"] = [list(edge) for edge in sorted(edges)]
            model = Model(data)
            reachable = set()
            for source in states:
                seen = {source}
                queue = [source]
                while queue:
                    current = queue.pop()
                    for left, right in edges:
                        if left == current and right not in seen:
                            seen.add(right)
                            queue.append(right)
                reachable.update((source, target) for target in seen)
            with self.subTest(graph=bits):
                self.assertEqual(model.relation({"op": "star", "body": atomic()}), reachable)
                frontier = {(state, state) for state in states}
                for count in range(5):
                    self.assertEqual(model.relation({"op": "repeat", "count": count, "body": atomic()}), frontier)
                    frontier = {(start, right) for start, current in frontier for left, right in edges if left == current}

    def test_cross_sort_same_spelling_never_erases_type(self):
        data = base_data()
        data["sorts"]["Action"].append("a")
        data["constants"]["action_a"] = {"sort": "Action", "value": "a"}
        model = Model(data)
        self.assertTrue(model.holds(atom("Alive", const("a")), "s0"))
        with self.assertRaises(GrammarError):
            model.holds(atom("Alive", const("action_a")), "s0")
        with self.assertRaises(GrammarError):
            model.holds({"op": "eq", "left": const("a"), "right": const("action_a")}, "s0")

    def test_json_duplicate_keys_are_rejected_at_any_depth(self):
        sources = ['{"closed_world":true,"closed_world":false}',
                   '{"formula":{"op":"true","op":"false"}}']
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "invalid.json"
            for source in sources:
                path.write_text(source, encoding="utf-8")
                with self.subTest(source=source), self.assertRaises(GrammarError):
                    load_json(path)

    def test_non_json_numeric_constants_rejected(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "invalid.json"
            for source in ['{"value":NaN}', '{"value":Infinity}', '{"value":-Infinity}']:
                path.write_text(source, encoding="utf-8")
                with self.subTest(source=source), self.assertRaises(GrammarError):
                    load_json(path)

    def test_invalid_utf8_is_reported_as_grammar_input_error(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "invalid.json"
            path.write_bytes(b'{"x":"\xff"}')
            with self.assertRaises(GrammarError):
                load_json(path)

    def test_norm_query_expectation_type_is_strict(self):
        for expected in [True, 0, [], {}, None, "allowed"]:
            bundle = {"model": base_data(), "norm_queries": [
                {"name": "invalid", "norm": "N", "state": "s0", "action": "wait", "expected": expected}
            ]}
            with self.subTest(expected=expected), self.assertRaises(GrammarError):
                run_bundle(bundle)

    def test_formula_query_expectation_rejects_numeric_bool_coercion(self):
        for expected in [0, 1, "true", None]:
            bundle = {"model": base_data(), "queries": [
                {"name": "invalid", "state": "s0", "formula": truth(), "expected": expected}
            ]}
            with self.subTest(expected=expected), self.assertRaises(GrammarError):
                run_bundle(bundle)

    def test_decision_combines_norm_and_nonempty_relation(self):
        model = Model(base_data())
        self.assertEqual(model.decision("N", "s0", "wait", atomic()),
                         {"judgment": "permitted", "feasible": True, "eligible": True})
        self.assertEqual(model.decision("N", "s0", "reform", atomic()),
                         {"judgment": "forbidden", "feasible": True, "eligible": False})
        self.assertEqual(model.decision("N", "s1", "reform", atomic()),
                         {"judgment": "undetermined", "feasible": True, "eligible": None})
        self.assertEqual(model.decision("N", "s1", "wait", atomic("reset")),
                         {"judgment": "required", "feasible": False, "eligible": False})

    def test_decision_is_not_formula_and_validates_program_even_if_forbidden(self):
        model = Model(base_data())
        with self.assertRaises(GrammarError):
            model.holds({"op": "decision", "norm": "N", "action": "wait", "program": atomic()}, "s0")
        with self.assertRaises(GrammarError):
            model.decision("N", "s0", "reform", {"op": "atomic", "name": "missing"})

    def test_candidates_freeze_definition_meaning(self):
        first = base_data()
        first["formula_defs"]["F"] = truth()
        second = deepcopy(first)
        second["formula_defs"]["F"] = falsehood()
        with self.assertRaises(GrammarError):
            assess([Model(first), Model(second)], {"op": "fref", "name": "F"}, "s0")

    def test_input_mutation_does_not_rewrite_constructed_model(self):
        data = base_data()
        model = Model(data)
        data["predicates"]["Alive"]["true_at"]["s0"] = []
        data["programs"]["step"] = []
        self.assertTrue(model.holds(atom("Alive", const("a")), "s0"))
        self.assertEqual(model.successors(atomic(), "s0"), {"s1"})


class DeliveredExampleChecks(unittest.TestCase):
    def test_complete_example_bundle(self):
        result = run_bundle(load_json(ENGINE_DIR / "examples.json"))
        self.assertEqual(result["checks"], 26)
        self.assertTrue(result["all_pass"], result)

    def test_model_assumptions_do_not_create_norms(self):
        data = base_data()
        data["norms"] = {}
        model = Model(data)
        self.assertTrue(model.holds(atom("Safe"), "s0"))
        with self.assertRaises(GrammarError):
            model.decision("N", "s0", "wait", atomic())

    def test_context_id_is_required_and_nonempty(self):
        for invalid in [None, "", "   ", 1, False, []]:
            data = base_data()
            data["context_id"] = invalid
            with self.subTest(context_id=invalid), self.assertRaises(GrammarError):
                Model(data)
        data = base_data()
        del data["context_id"]
        with self.assertRaises(GrammarError):
            Model(data)

    def test_candidates_with_different_contexts_are_rejected(self):
        first = base_data()
        second = deepcopy(first)
        second["context_id"] = "different-scale-or-identity"
        with self.assertRaises(GrammarError):
            assess([Model(first), Model(second)], atom("Safe"), "s0")


if __name__ == "__main__":
    unittest.main(verbosity=2)
