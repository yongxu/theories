#!/usr/bin/env python3
"""F5's field, MV's part: the landing's document edits, run on the merged tree after the generator.

python3 -B _process/research/2026-10-05-repository-reconciliation/architecture/mv/land_f5a.py

It appends the study section with the next number and the figures of data/shared-laws.json, marks the
spec and the kit landed, and moves the board's claim to landed with a queue entry. Each edit is checked to
apply exactly once; nothing is written unless all of them apply.
"""
import json, re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[5]
KIT = Path(__file__).resolve().parent
STUDY = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/BECOMING-RENEWAL-READING.md'
BOARD = ROOT / '_process/BECOMING-WORKBOARD.md'
SPEC = KIT / 'F5-MODEL-STATEMENTS.md'
README = KIT / 'README.md'
DATA = ROOT / 'theories/becoming/results/data/shared-laws.json'


def once(text, old, new, where):
    assert text.count(old) == 1, f'{where}: expected one {old[:60]!r}, found {text.count(old)}'
    return text.replace(old, new)


def main():
    d = json.loads(DATA.read_text())
    c, reach = d['counts'], d['central_reach']['counts']
    assert d['counts_at_model']['laws'] == 0 and not d['from_dump']
    figures = (f"{c['laws']:,} laws: {c['grammar']:,} reach the grammar ({c['vocabulary_only']} through its vocabulary only), "
               f"{c['balance, represented']:,} rest on balance and do not reach it, {c['anchor, not reached']} rest on another "
               f"anchor and do not reach it, {c['no master law']:,} have no master law's anchor, {c['outside']} cite only "
               f"declarations the spine run does not have, {c['no_declarations']} cite none; counts_at_model all zero")
    total = sum(reach.values())
    reach_text = (f"of the {total} distinct central declarations, {reach['reaching the grammar']} reach the grammar, "
                  f"{reach['stated at a represented model']} are stated at a represented model, "
                  f"{reach['stated on its own carrier only']} only on their own carrier, and {reach['the rest']} are the rest")
    study = STUDY.read_text()
    n = max(int(m) for m in re.findall(r'^## (\d+)\. ', study, re.M)) + 1
    section = (KIT / 'study_f5a.txt').read_text()
    section = once(section, '## NNN.', f'## {n}.', 'study section')
    section = once(section, 'core receipt `CORE`', f"core receipt `{d['core_receipt']}`", 'study section')
    section = once(section, 'FIGURES;', figures + ';', 'study section')
    section = once(section, 'REACH;', reach_text + ';', 'study section')
    assert not re.search(r'\bNNN\b|`CORE`|FIGURES|REACH', section)
    study = study.rstrip('\n') + '\n\n' + section.rstrip('\n') + '\n'

    spec = once(SPEC.read_text(), "**Status:** final shape, given to U2; MV's part built on branch `f5a`.",
                f"**Status:** MV's part landed (study §{n}); U2's Lean fills the field.", 'spec')
    readme = README.read_text().rstrip('\n') + (
        f"\n\n**F5's field (landed, study §{n}).** `statements_at_model` on a law declares a theorem that states a row of the "
        "same record at a model, with its models and review; the check enforces its rules, `shared_laws.py` verifies it from "
        "the checker cache and counts laws carrying items apart, and the record pages show it marked as declared. Design, "
        "reviews and re-checks: [F5-MODEL-STATEMENTS.md](F5-MODEL-STATEMENTS.md), [reports/](reports/).\n")

    board = BOARD.read_text()
    claim = re.search(r"F5's field, MV's part, claimed 30 October 2026 on `[0-9a-f]+`: .*? It lands before U2's Lean, which fills the field\.", board)
    assert claim and board.count(claim.group(0)) == 1, 'board: the claim sentence'
    board = board.replace(claim.group(0), (
        f"F5's field, MV's part, landed 30 October 2026 (study §{n}, "
        "[spec](research/2026-10-05-repository-reconciliation/architecture/mv/F5-MODEL-STATEMENTS.md)): `statements_at_model` on a "
        "law, a theorem stating a row of the same record at a model with its models and review, checked by the registry, verified "
        "by `shared_laws.py` from the checker cache (counted apart in `counts_at_model`; `central_reach`), and shown on the record "
        "pages marked as declared; U2's Lean fills it."))
    queue = '- **Queue:** '
    assert board.count(queue) == 1, 'board: the queue line'
    board = board.replace(queue, queue + (
        f"F5's field, MV's part, landed (§{n}, tools and documents only, no Lean and no record changed: `statements_at_model` on "
        "a law, the check's rules with a law item's keys closed, the generator's verification, `counts_at_model` and "
        "`central_reach`, the record pages' lines, RESULT-WORKFLOW, 14 tests; every existing figure unchanged; the design "
        "reviewed and re-checked, the code reviewed and re-checked, every finding taken; U2's Lean next, filling it); "), 1)

    STUDY.write_text(study)
    SPEC.write_text(spec)
    README.write_text(readme)
    BOARD.write_text(board)
    print(json.dumps({'section': n, 'core_receipt': d['core_receipt'], 'figures': figures, 'central_reach': reach_text}, ensure_ascii=False))


if __name__ == '__main__':
    main()
