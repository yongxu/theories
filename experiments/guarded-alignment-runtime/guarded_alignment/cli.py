"""Command-line interface for the guarded-alignment runtime.

AI-written (Wave U6 runtime, 24 November 2026). Pure Python 3 standard library.
Usage:
  python3 -m guarded_alignment list
  python3 -m guarded_alignment run <example|all> [--json]
  python3 -m guarded_alignment check <spec.json> [--json]
  python3 -m guarded_alignment dump-example <example>
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Sequence

from .diagnostics import DiagnosticReport, evaluate_pipeline_spec
from .examples import builtin_example_specs, run_builtin_example


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="guarded-alignment",
        description="Strict 2D/3D kernel, oplax Beck-Chevalley guard, and exact rational fidelity runtime.",
    )
    sub = parser.add_subparsers(dest="command", required=True)

    sub.add_parser("list", help="List built-in alignment and categorical witness examples.")

    p_run = sub.add_parser("run", help="Run a built-in example (or 'all').")
    p_run.add_argument("example", help="Built-in example name or 'all'.")
    p_run.add_argument("--json", action="store_true", help="Emit JSON report.")

    p_check = sub.add_parser("check", help="Evaluate a declarative JSON pipeline spec file.")
    p_check.add_argument("spec_path", help="Path to JSON pipeline specification.")
    p_check.add_argument("--json", action="store_true", help="Emit JSON report.")

    p_dump = sub.add_parser("dump-example", help="Print JSON specification of a built-in example.")
    p_dump.add_argument("example", help="Built-in example name.")

    return parser


def _emit_reports(reports: list[DiagnosticReport], as_json: bool) -> str:
    if as_json:
        payload = reports[0].to_dict() if len(reports) == 1 else [r.to_dict() for r in reports]
        return json.dumps(payload, indent=2, sort_keys=True)
    return "\n\n".join(r.format_text() for r in reports)


def main(argv: Sequence[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    specs = builtin_example_specs()

    if args.command == "list":
        for name in sorted(specs):
            print(f"{name} ({specs[name]['kind']})")
        return 0

    if args.command == "dump-example":
        if args.example not in specs:
            print(f"Unknown example {args.example!r}", file=sys.stderr)
            return 2
        print(json.dumps(specs[args.example], indent=2, sort_keys=True))
        return 0

    if args.command == "run":
        if args.example == "all":
            reports = [run_builtin_example(name) for name in sorted(specs)]
        elif args.example in specs:
            reports = [run_builtin_example(args.example)]
        else:
            print(f"Unknown example {args.example!r}", file=sys.stderr)
            return 2
        print(_emit_reports(reports, args.json))
        return 0

    if args.command == "check":
        path = Path(args.spec_path)
        data = json.loads(path.read_text(encoding="utf-8"))
        report = evaluate_pipeline_spec(data)
        print(_emit_reports([report], args.json))
        return 0

    return 2


if __name__ == "__main__":
    raise SystemExit(main())
