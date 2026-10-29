# MV: the master laws under each law of a record

The plan was agreed on RA's line, 28 October 2026, with the session coordinating the unification. Ren approved the work on 29 October. MV shows, under each law of a record page, which of the five master laws its declarations rest on by Lean dependency. It is computed from the Lean and is not written into the records.

## Files

- `tools/research/master_laws.py`, the generator. It reads OU3b's measure (`measure_grammar.py`, unchanged) and the checker's cache, and writes `theories/becoming/results/data/master-laws.json`.
- `tools/research/registry.py`: `master_laws`, `master_law_note` and `master_laws_status`, and their use in `load_records`, `render_record_v2` and `affected_ids`. The check reports `master_laws` (`tools/research/research.py`).
- `tools/research/tests/test_master_laws.py`.
- `_process/RESULT-WORKFLOW.md`, the paragraph "Master laws under each law (MV)".

## Review

- [`review.js`](review.js) ran two readers; their findings are in [`review.json`](review.json). Every finding was taken but one: counting a master law's statement on the grammar, which the measure does not count, was proposed to its owner instead.
- [`recheck.json`](recheck.json) holds the second reader's check of the fixes.
- [`land_mv.py`](land_mv.py) writes the landing texts.

## To keep it current

Every core landing that changes dependencies, every change to a record's laws, and every change to `COVERAGE.json` or the measure makes the data stale. After `check_becoming.py` passes on the new sources, run `python3 -B tools/research/master_laws.py` and then `make research-render`. Until then, the check's `master_laws` entry says the data is stale, and pages show nothing under a law whose declarations changed.
