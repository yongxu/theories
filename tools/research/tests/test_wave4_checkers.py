"""Regression tests for Wave 4 Lean checkers (`check_interface_bits`, `check_moving_feature_cone`)."""
from __future__ import annotations

import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

sys.dont_write_bytecode = True

REPO = Path(__file__).resolve().parents[3]
LEAN_ROOT = REPO / "experiments/integrated-correction/general-framework/generative-basis/lean"
LEAN_BIN = Path.home() / ".elan/toolchains/leanprover--lean4---v4.30.0-rc2/bin/lean"

for folder in ("interface-bits", "moving-feature-cone"):
    folder_str = str(LEAN_ROOT / folder)
    if folder_str not in sys.path:
        sys.path.insert(0, folder_str)

import check_interface_bits as b4_chk  # noqa: E402
import check_moving_feature_cone as b3_chk  # noqa: E402


class Wave4CheckersRegressionTest(unittest.TestCase):
    CHECKERS = (b4_chk, b3_chk)

    def test_builtin_self_tests(self) -> None:
        for mod in self.CHECKERS:
            mod.regression_self_test()

    def test_named_public_instance_and_public_eq_outside_namespace(self) -> None:
        src = (
            "namespace ExternalNs\n"
            "public instance instExternalNat : Inhabited Nat := ⟨0⟩\n"
            "public theorem custom.eq_1 : True := trivial\n"
            "end ExternalNs\n"
        )
        expected = [
            {"kind": "instance", "name": "ExternalNs.instExternalNat"},
            {"kind": "theorem", "name": "ExternalNs.custom.eq_1"},
        ]
        for mod in self.CHECKERS:
            decls = mod.strict_scan(src)
            self.assertEqual(decls, expected)
            self.assertEqual(mod.normalized_legacy_scan(src)["declarations"], decls)

    def test_rejects_disallowed_and_unnamed_syntax(self) -> None:
        bad_sources = (
            "private opaque foo : Nat",
            "opaque market_price : Nat",
            "lemma bad : True := trivial",
            "class Foo where",
            "instance : Inhabited Nat := ⟨0⟩",
            "public instance : Inhabited Nat := ⟨0⟩",
            "open Nat in\nvariable {α : Type} in\ninstance [Inhabited α] : Inhabited α := ⟨default⟩",
            "noncomputable\nscoped[S] instance : Inhabited Bool := ⟨true⟩",
            "attribute [default_instance]\ninstance (n : Nat) : Inhabited Bool := ⟨true⟩",
        )
        for mod in self.CHECKERS:
            for src in bad_sources:
                with self.assertRaises(ValueError):
                    mod.strict_scan(src)

    def test_lean_kernel_env_audit_fixtures(self) -> None:
        if not LEAN_BIN.is_file():
            self.skipTest("Lean v4.30.0-rc2 binary not present")
        with tempfile.TemporaryDirectory(prefix="wave4-checker-test-") as tmp:
            work = Path(tmp)
            env = {**os.environ, "LEAN_PATH": str(work)}
            imp_src = (
                "def impRec : Nat → Nat\n"
                "  | 0 => 1\n"
                "  | n + 1 => impRec n\n"
            )
            (work / "ImpMod.lean").write_text(imp_src, encoding="utf-8")
            p_imp = subprocess.run(
                [str(LEAN_BIN), "-o", "ImpMod.olean", "ImpMod.lean"],
                cwd=work, env=env, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=60,
            )
            self.assertEqual(p_imp.returncode, 0, p_imp.stdout)

            child_src = (
                "import ImpMod\n"
                "namespace Evil\n"
                "public theorem foo.eq_1 : True := trivial\n"
                "end Evil\n"
                "namespace Becoming.InterfaceBits\n"
                "public instance instFixtureNat : Inhabited Nat := ⟨0⟩\n"
                "theorem use_imp : impRec 0 = 1 := by simp [impRec]\n"
                "end Becoming.InterfaceBits\n"
            )
            (work / "InterfaceBits.lean").write_text(child_src, encoding="utf-8")
            p_child = subprocess.run(
                [str(LEAN_BIN), "-o", "InterfaceBits.olean", "InterfaceBits.lean"],
                cwd=work, env=env, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=60,
            )
            self.assertEqual(p_child.returncode, 0, p_child.stdout)

            driver = (
                "import Lean\nimport InterfaceBits\nopen Lean Elab Command\n\n"
                "#eval show CommandElabM Unit from do\n"
                "  let env ← getEnv\n"
                "  let some idx := env.getModuleIdx? `InterfaceBits | throwError \"missing module\"\n"
                "  let mut count : Nat := 0\n"
                "  for (n, _) in env.constants.map₁.toList do\n"
                "    if env.getModuleIdxFor? n == some idx then\n"
                "      count := count + 1\n"
                "      let axs ← liftCoreM <| Lean.collectAxioms n\n"
                "      let isInst ← liftCoreM <| Lean.Meta.isInstance n\n"
                "      let dr ← liftCoreM <| findDeclarationRanges? n\n"
                "      let eqStemImp := match env.getModuleIdxFor? n.getPrefix with | some pidx => pidx != idx | none => false\n"
                "      IO.println s!\"ENV_CONST\\t{n}\\t{axs.toList}\\t{isInst}\\t{dr.isSome}\\t{eqStemImp}\"\n"
                "  IO.println s!\"ENV_AUDIT_DONE COUNT={count}\"\n"
            )
            (work / "FixtureEnvAudit.lean").write_text(driver, encoding="utf-8")
            p_env = subprocess.run(
                [str(LEAN_BIN), "FixtureEnvAudit.lean"],
                cwd=work, env=env, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=60,
            )
            self.assertEqual(p_env.returncode, 0, p_env.stdout)

            reg = b4_chk.strict_scan(child_src)
            self.assertEqual(reg, b4_chk.normalized_legacy_scan(child_src)["declarations"])
            summary = b4_chk.audit_environment(p_env.stdout, reg)
            self.assertGreaterEqual(summary["module_constants"], 3)

            # Omitting either Evil.foo.eq_1 or instFixtureNat must make audit_environment reject!
            with self.assertRaises(ValueError):
                b4_chk.audit_environment(p_env.stdout, [d for d in reg if d["name"] != "Evil.foo.eq_1"])
            with self.assertRaises(ValueError):
                b4_chk.audit_environment(
                    p_env.stdout, [d for d in reg if d["name"] != "Becoming.InterfaceBits.instFixtureNat"]
                )


if __name__ == "__main__":
    unittest.main()
