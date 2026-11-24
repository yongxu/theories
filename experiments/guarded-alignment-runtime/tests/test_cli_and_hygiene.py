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
