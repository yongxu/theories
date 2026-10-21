#!/usr/bin/env python3
"""Working compile of the periphery module RegimeReals before the core receipt that binds its imports exists: runs
the periphery checker with every module of the closure taken as matched and its receipt written to a scratch folder
(SCRATCH, default the system temporary folder). Steps that pass are cached as the checker caches them, so the landing
run reuses them. Not a receipt.
usage: python3 -B dev_periphery.py   (from anywhere; the checkout is the one holding this kit)"""
import json
import os
import sys
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[5]
LEAN_ROOT = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean'
sys.path.insert(0, str(LEAN_ROOT / 'regime'))
sys.dont_write_bytecode = True
import check_regime_reals as chk  # noqa: E402

scratch = Path(os.environ.get('SCRATCH', tempfile.mkdtemp(prefix='rm5-dev-')))
chk.HERE = scratch
chk.RECEIPT = scratch / 'dev-verification.json'
chk.RETAINED = scratch / 'dev-checks'
chk.passed_receipts = lambda: [('dev', json.dumps(
    [chk.core.audit_support.digest(p.read_bytes()) for p in LEAN_ROOT.rglob('*.lean')]) + '"passed"')]
work = scratch / 'work'
work.mkdir(parents=True, exist_ok=True)


class Kept:
    """The checker's temporary folder, kept at SCRATCH/work so a session can compile against it."""
    def __init__(self, *args, **kwargs):
        pass

    def __enter__(self):
        return str(work)

    def __exit__(self, *exc):
        return False


chk.tempfile.TemporaryDirectory = Kept
print('scratch', scratch)
chk.main()
