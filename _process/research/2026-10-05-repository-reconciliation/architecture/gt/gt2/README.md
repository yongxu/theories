<!-- AI-written: GT2's kit, 5 November 2026. -->
# GT2's kit: the Lean checker made fast

What GT2 did and why each part leaves what is checked unchanged is in [GATE.md §5.1](../GATE.md#51-gt2-what-was-done-and-measured). This folder holds what it measured and how:

- [`measure_environment_audit.py`](measure_environment_audit.py) restores the core's compiled modules from the step cache and times environment-audit drivers on them, against the checker's own. [`per-module.lean`](per-module.lean) is the driver before GT2, [`onepass.lean`](onepass.lean) the one GT2 adopted, and [`count-only.lean`](count-only.lean) the pass without `collectAxioms`, to show where the time goes. Results: [core](out/environment-audit-core.json), [bridge](out/environment-audit-bridge.json) (empty since F3, so it shows nothing).
- [`measure_drivers.py`](measure_drivers.py) times the axiom-audit and signature drivers of chosen modules against one merged driver ([result](out/drivers.json)).
- [`compare_receipts.py`](compare_receipts.py) compares a core receipt written by the new checker with one written by the old checker on the same tree ([result](out/compare-first-run.json)).
- [`land_gt2.py`](land_gt2.py) makes the board's edits at the landing.

To repeat the comparison: run the old checker (`git show 77248feec:…/check_becoming.py`) and the new one with `BECOMING_OUT` set to two scratch folders, then `python3 -B compare_receipts.py OLD/becoming-verification.json NEW/becoming-verification.json`.
