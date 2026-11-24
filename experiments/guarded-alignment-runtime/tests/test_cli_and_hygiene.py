"""End-to-end DSL, CLI, built-in example, and forbidden-word hygiene tests."""

from __future__ import annotations

import contextlib
import io
import json
import re
import tempfile
import unittest
from pathlib import Path

from guarded_alignment import Verdict, builtin_example_specs, evaluate_pipeline_spec, run_builtin_example
from guarded_alignment.cli import main as cli_main


PACKAGE_ROOT = Path(__file__).resolve().parent.parent

# Encoded reversed so none of the banned tokens appear literally inside this test file.
_BANNED_REVERSED = (
    "tsoc", "stsoc", "yltsoc", "gnitsoc",
    "egrahc", "segrahc", "degrahc", "gnigrahc",
    "tegdub", "stegdub", "detegdub",
    "yap", "syap", "gniyap", "tnemyap", "stnemyap", "diap",
    "ecirp", "secirp", "decirp", "gnicirp",
    "dneps", "sdneps", "gnidneps", "tneps",
    "gnitnuocca",
    "tiderc", "stiderc", "detiderc", "gnitiderc",
    "eef", "seef",
    "tiforp", "stiforp", "elbatiforp",
    "dnuf", "sdnuf", "dednuf", "gnidnuf",
)
_BANNED_WORDS = frozenset(tok[::-1] for tok in _BANNED_REVERSED)


class TestCLIAndHygiene(unittest.TestCase):
    def test_all_builtin_examples_expected_verdicts(self) -> None:
        expected = {
            "rlhf_shared_substrate_c2": Verdict.OBSTRUCTED,
            "rlhf_shared_substrate_phase_guarded": Verdict.GUARDED,
            "emergent_cross_seam": Verdict.OBSTRUCTED,
            "c2_phase_split_scaling": Verdict.OBSTRUCTED,
            "guarded_bc_upgrade": Verdict.GUARDED,
            "strict_2d_3d_kernel": Verdict.OBSTRUCTED,
            "multi_query_separation": Verdict.OBSTRUCTED,
            "proposal_rlhf_one_pass": Verdict.OBSTRUCTED,
            "proposal_rlaif_self_refit": Verdict.OBSTRUCTED,
            "proposal_constitutional_ai_closed": Verdict.OBSTRUCTED,
            "proposal_scalable_oversight_lagged": Verdict.OBSTRUCTED,
            "proposal_multi_agent_governance_unserialized": Verdict.OBSTRUCTED,
            "proposal_finite_mode_switching_blind": Verdict.OBSTRUCTED,
            "proposal_guarded_open_alignment": Verdict.GUARDED,
        }
        specs = builtin_example_specs()
        self.assertEqual(set(specs.keys()), set(expected.keys()))
        for name, exp_verdict in expected.items():
            rep = run_builtin_example(name)
            self.assertEqual(rep.verdict, exp_verdict, msg=f"Unexpected verdict for {name}")
            self.assertTrue(rep.rule2_boundary)
            # Round-trip JSON clean
            encoded = json.dumps(rep.to_dict())
            decoded = json.loads(encoded)
            self.assertEqual(decoded["verdict"], exp_verdict.value)

    def test_cli_commands_and_json_spec_check(self) -> None:
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            rc = cli_main(["list"])
        self.assertEqual(rc, 0)
        self.assertIn("rlhf_shared_substrate_c2", buf.getvalue())

        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            rc = cli_main(["run", "guarded_bc_upgrade", "--json"])
        self.assertEqual(rc, 0)
        parsed = json.loads(buf.getvalue())
        self.assertEqual(parsed["verdict"], "GUARDED")

        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            rc = cli_main(["dump-example", "rlhf_shared_substrate_c2"])
        self.assertEqual(rc, 0)
        spec_text = buf.getvalue()

        with tempfile.TemporaryDirectory() as td:
            spec_file = Path(td) / "spec.json"
            spec_file.write_text(spec_text, encoding="utf-8")
            buf_chk = io.StringIO()
            with contextlib.redirect_stdout(buf_chk):
                rc_chk = cli_main(["check", str(spec_file), "--json"])
            self.assertEqual(rc_chk, 0)
            rep_json = json.loads(buf_chk.getvalue())
            self.assertEqual(rep_json["verdict"], "OBSTRUCTED")

    def test_custom_strict_kernel_proved_verdict(self) -> None:
        spec = {
            "name": "pure_proved_id_law",
            "kind": "strict_kernel",
            "objs": ["a", "b", "c", "d"],
            "h_gens": {"f": ["a", "b"], "g": ["c", "d"]},
            "v_gens": {"u": ["a", "c"], "v": ["b", "d"]},
            "sq_gens": {
                "P": {
                    "tl": "a", "tr": "b", "bl": "c", "br": "d",
                    "top": ["f"], "bot": ["g"], "left": ["u"], "right": ["v"],
                }
            },
            "eq_certs": [{"label": "idH_left", "cert": {"rule": "idH_l", "p": "P"}}],
        }
        rep = evaluate_pipeline_spec(spec)
        self.assertEqual(rep.verdict, Verdict.PROVED)
        self.assertIn("[PROVED]", rep.format_text())

    def test_json_dsl_and_cli_support_cong_h_and_cong_v(self) -> None:
        spec = {
            "name": "strict_kernel_cong_h_v",
            "kind": "strict_kernel",
            "objs": ["o00", "o01", "o02", "o10", "o11", "o12", "o20", "o21", "o22"],
            "h_gens": {
                "h00": ["o00", "o01"],
                "h01": ["o01", "o02"],
                "h10": ["o10", "o11"],
                "h11": ["o11", "o12"],
                "h20": ["o20", "o21"],
                "h21": ["o21", "o22"],
            },
            "v_gens": {
                "v00": ["o00", "o10"],
                "v01": ["o01", "o11"],
                "v02": ["o02", "o12"],
                "v10": ["o10", "o20"],
                "v11": ["o11", "o21"],
                "v12": ["o12", "o22"],
            },
            "sq_gens": {
                "P": {
                    "tl": "o00", "tr": "o01", "bl": "o10", "br": "o11",
                    "top": ["h00"], "bot": ["h10"], "left": ["v00"], "right": ["v01"],
                },
                "Q": {
                    "tl": "o01", "tr": "o02", "bl": "o11", "br": "o12",
                    "top": ["h01"], "bot": ["h11"], "left": ["v01"], "right": ["v02"],
                },
                "R": {
                    "tl": "o10", "tr": "o11", "bl": "o20", "br": "o21",
                    "top": ["h10"], "bot": ["h20"], "left": ["v10"], "right": ["v11"],
                },
            },
            "eq_certs": [
                {
                    "label": "congH_check",
                    "cert": {
                        "rule": "congH",
                        "left": {"rule": "idH_l", "p": "P"},
                        "right": {"rule": "refl", "term": "Q"},
                    },
                },
                {
                    "label": "congV_check",
                    "cert": {
                        "rule": "congV",
                        "top": {"rule": "idV_l", "p": "P"},
                        "bot": {"rule": "symm", "cert": {"rule": "idV_r", "p": "R"}},
                    },
                },
            ],
        }
        rep = evaluate_pipeline_spec(spec)
        self.assertEqual(rep.verdict, Verdict.PROVED)
        self.assertEqual(len(rep.checks), 2)
        with tempfile.TemporaryDirectory() as td:
            spec_file = Path(td) / "cong_spec.json"
            spec_file.write_text(json.dumps(spec), encoding="utf-8")
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                rc = cli_main(["check", str(spec_file), "--json"])
            self.assertEqual(rc, 0)
            out = json.loads(buf.getvalue())
            self.assertEqual(out["verdict"], "PROVED")
            self.assertEqual([c["label"] for c in out["checks"]], ["congH_check", "congV_check"])

    def test_zero_forbidden_market_words_across_package(self) -> None:
        word_re = re.compile(r"[A-Za-z]+")
        hits: list[tuple[str, str]] = []
        for path in sorted(PACKAGE_ROOT.rglob("*")):
            if path.is_dir() or "__pycache__" in path.parts:
                continue
            if path.suffix not in {".py", ".md", ".json", ".txt"}:
                continue
            text = path.read_text(encoding="utf-8")
            for tok in word_re.findall(text):
                low = tok.lower()
                if low in _BANNED_WORDS:
                    hits.append((str(path.relative_to(PACKAGE_ROOT)), low))
        self.assertEqual(hits, [], msg=f"Forbidden words found: {hits}")


if __name__ == "__main__":
    unittest.main()
