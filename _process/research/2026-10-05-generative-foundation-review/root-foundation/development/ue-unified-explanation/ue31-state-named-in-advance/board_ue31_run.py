#!/usr/bin/env python3
"""UE31's run landed (board_t2.py's pattern): its result where readers were told the test had not run.

edit: T2's home (02 §5) and its row in 08's thesis table, the experiments index, the sciences dossier's quotation of
      08's T2 row (stale since T2's sentence landed, 10c89f41d), the directives' parenthesis on the download, the board's
      UE31 row, the way now's item 2 and the Decisions line that goes now it is answered, and a row in the history file.
      Every file is shared, so the edits are made by script on the landing tree.
head: put the clause "UE31's run at the head of the queue (...); " at the front of the Queue line.
land: drop the head clause and put the landed clause first.
usage (from the checkout root): python3 -B board_ue31_run.py edit | head | land"""
import re
import sys
from pathlib import Path

BOARD = Path('_process/BECOMING-WORKBOARD.md')
HISTORY = Path('_process/history/workboard/BECOMING-WORKBOARD-2026-10-11_to_2026-10-17.md')
M02 = Path('theories/becoming/chapters/02-MAP.md')
M08 = Path('theories/becoming/chapters/08-METHOD.md')
INDEX = Path('experiments/README.md')
SCIENCES = Path('_process/research/2026-10-05-generative-foundation-review/root-foundation/development/'
                'ue8-sciences-dossier/SCIENCES.md')
DIRECTIVES = Path('_process/RESEARCH-DIRECTIVES.md')
RESULT = 'experiments/state-named-in-advance/README.md#the-result'

EDITS = {
    M02: [
        ("the frozen test UE31 ([design](../../../experiments/state-named-in-advance/DESIGN.md), not yet run) expects",
         "the frozen test UE31 ([design](../../../experiments/state-named-in-advance/DESIGN.md)) expects"),
        ("to the field; if T2's law held, it would often go to T2.",
         "to the field; if T2's law held and the cultures were dense, it would often go to T2. Run on the Beetle Team "
         f"archive on 3 November 2026 ([result](../../../{RESULT})), the test decided nothing: the 40 cultures of the "
         "archive's adult-loss experiment, with the loss set and recruitment left to them, hold 13 censuses each under "
         "the loss, too few for its frozen rules, so each of these expectations stands untested. Of the archive's 25 "
         "control cultures, which have no set loss and are reported only, the 13 long enough read, at the census "
         "grain, as the test expects of cultures under one; that shows the rules run on the archive, not how cultures "
         "under a loss would read."),
    ],
    M08: [
        ("any decision then the field's, and often T2's if T2's law holds (UE31, frozen, not yet run) |",
         "any decision then the field's, and often T2's if T2's law holds and the cultures are dense (UE31, frozen; "
         "run on 3 November 2026, it decided nothing, the adult-loss experiment's cultures, with recruitment left to "
         "them, being too short for its rules) |"),
    ],
    INDEX: [
        ("(UE31, designed and frozen 3 Nov 2026; nothing downloaded or run; the answer expected, stated before the run: "
         "the field's state wins the next step by the life cycle, the course ties, the lag's sign is the one contrary "
         "prediction) |",
         "(UE31, designed and frozen 3 Nov 2026, run the same day: nothing decided, since the adult-loss experiment's "
         "40 cultures, with the loss set and recruitment left to them, hold 13 censuses each under the loss, too few "
         "for the frozen rules; the answer expected, stated before the run, stands untested: the field's state wins "
         "the next step by the life cycle, the course ties, the lag's sign is the one contrary prediction; the 13 "
         "control cultures long enough to read, reported only, read so at the census grain, which shows the rules run "
         "on the archive, not how cultures under a loss would read) |"),
    ],
    SCIENCES: [
        ("In yeast both chapters place MQ6 outside the settings that could refute T2: Quote "
         "[theories/becoming/chapters/08-METHOD.md]: \"in MQ6's yeast, residuals at one constant dilution, never past "
         "the fold, carry nothing day to day, outside the settings that could refute T2, and the runs past the fold "
         "measured none of its forbidden items\";",
         "In yeast both chapters place MQ6 outside the settings T2's *Refuted by* names: Quote "
         "[theories/becoming/chapters/08-METHOD.md]: \"in MQ6's yeast, residuals at one constant dilution, never past "
         "the fold, carry nothing day to day, outside the settings T2's *Refuted by* names, and the runs past the fold "
         "measured none of its forbidden items\";"),
        ("- Quote [experiments/margin-measured/README.md]: \"The series are assessment outputs, not measurements; "
         "age-structured assessments carry a recruitment lag of their own.\"",
         "- Quote [experiments/margin-measured/README.md]: \"The series are assessment outputs, not measurements; "
         "age-structured assessments carry a recruitment lag of their own.\"\n"
         "- Outside fisheries, one frozen test of what T2 forbids has run, UE31 on the flour beetle. Of its expectations "
         "there (T2's wording failing to the pupae and the adults, the course tying, the sign mostly undecided), Quote "
         "[theories/becoming/chapters/02-MAP.md]: \"the test decided nothing: the 40 cultures of the archive's "
         "adult-loss experiment, with the loss set and recruitment left to them, hold 13 censuses each under the loss, "
         "too few for its frozen rules, so each of these expectations stands untested.\""),
    ],
    DIRECTIVES: [
        ("which the session that would make it asks him for directly (UE31's run waits on that alone).",
         "which the session that would make it asks him for directly (UE31's download was asked for so, and given on "
         "3 November)."),
    ],
    BOARD: [
        ("UE31, a state named in advance against the field's, by \"Free Energy Principle and self-organization\";",
         "UE31, a state named in advance against the field's, by \"Free Energy Principle and self-organization\", run on "
         "Ren's yes on 3 November and nothing decided, the adult-loss experiment's cultures too short for its frozen "
         f"rules ([result](../{RESULT}));"),
        ("the answer expected stated before the run (its §10); the download and the run wait on Ren's yes |",
         "the answer expected stated before the run (its §10); run on Ren's yes on 3 November "
         "([his words](../sources/15-codex-theory-conversations/2026-11-03-ue31-download-and-run.md)), nothing "
         "decided: the 40 cultures with the loss set and recruitment left to them hold 13 censuses each under the loss, "
         "against the 25 the frozen rules need, so every verdict on them is not testable; the 13 controls long enough, "
         "reported only, read as expected at the census grain, which shows the rules run on the archive, not how "
         f"cultures under a loss would read ([result](../{RESULT})); one independent reader's ten findings taken; a "
         "design reading the adult-loss cultures, made before any of their values is seen, would be new work |"),
        ("- **UE31's run, one yes**: frozen in [the design](../experiments/state-named-in-advance/DESIGN.md), not run. "
         "One yes downloads the Beetle Team Tribolium Data Archive from Dryad (doi 10.5061/dryad.qjq2bvqmp, two files, "
         "238,350 bytes, CC0), then runs the layout, the reader and the frozen rules in order (DESIGN §9): a few seconds "
         "of CPU, no money and no GPU. The answer expected was stated before the run: the next step goes to the field, "
         "the course ties by construction, and the lag's sign is mostly undecided at the archive's size.\n",
         ""),
    ],
}
HISTORY_AFTER = "| **LA4's Stage A run and its results landed** "
HISTORY_ROW = (
    "| **UE31's run and its result landed** (way now's item 2, 3 November 2026; Ren's yes to the download and the run; "
    "the coordinator's word to land by slot, the verdicts as they fall). Dryad refused automated download, so the "
    "archive was downloaded by hand and its digests checked; the layout, the reader and the frozen rules ran in order, "
    "each committed before the next. Nothing decided: the 40 cultures of the adult-loss experiment, with the loss set "
    "and recruitment left to them, hold 13 censuses each under the loss, 8 rows against the 20 the frozen rules need, "
    "so every verdict on the primary group is not testable at both grains, and the answer expected stands untested; "
    "the 13 control cultures long enough, reported only, read as expected at the census grain, which shows the rules "
    "run on the archive, not how cultures under a loss would read. One independent reader's ten findings taken. "
    "The data are CC0, not copied into the repository, and keep their own terms as COMMONS.md has it. The result "
    "stated in its README, T2's home, 08's thesis row, the experiments index and the sciences dossier. | Claude Code "
    "desktop session (Free Energy Principle and self-organization) | landed | `experiments/state-named-in-advance/` | "
    "T2 (02 §5), 08's theses → a design reading the adult-loss cultures, made before any of their values is seen, as "
    "new work |")

NAME = "UE31's run"
HEAD_TEXT = ("landing now, by the coordinator's word, before the freeze: documents and data only, no Lean and no core "
             "run; nothing downloaded by the landing: the run's three steps from its branch, its result in UE31's "
             "README, T2's home, 08's thesis row, the experiments index and the sciences dossier, whose quotation of "
             "08's T2 row is fixed with it; the records binding 02 and 08 re-pointed after reading; render, strict "
             "check, links, tests and the dossier checks, then the fast-forward")
HEAD = re.compile(re.escape(NAME) + r' at the head of the queue \([^()]*\); ')
LANDED = (
    "UE31's run landed (documents and data only: no Lean, no new record and no core run; the archive downloaded by "
    "hand on Ren's yes, not copied into the repository). Run on 3 November in the design's order, each step committed "
    "before the next: the layout, read from the workbook's structure before any census value; the reader, checked on "
    "55 synthetic cultures in the archive's layout; the frozen rules at both grains. It decided nothing: the 40 "
    "cultures of the archive's adult-loss experiment, with the loss set and recruitment left to them, hold 13 censuses "
    "each under the loss, 8 rows against the 20 the frozen rules need, so every verdict on the primary group is not "
    "testable and the answer expected stands untested; the design had assumed 41 censuses, and that is recorded as a "
    "finding about the test. The 13 control cultures long enough, reported only, read as expected at the census grain, "
    "which shows the rules run on the archive, not how cultures under a loss would read "
    f"([result](../{RESULT})). One independent reader checked the result against the run's output and every "
    "restatement against the result; its ten findings were taken (one error: the control's sign had not separated by "
    "the route the design's control world took). The data are CC0 and keep their own terms, as COMMONS.md has it. T2's "
    "home (02 §5), 08's thesis row, the experiments index, the sciences dossier, the board and the directives now say "
    "the test ran, where they said it had not; the sciences dossier's quotation of 08's T2 row, stale since T2's "
    "sentence landed, is fixed with it. The records binding 02 and 08 by their whole bytes were read against the "
    "change and re-pointed in their rebinds line; nothing they say changed. ")


def edit():
    for path, pairs in EDITS.items():
        s = path.read_text(encoding='utf-8')
        for old, new in pairs:
            assert s.count(old) == 1, (str(path), old[:80])
            assert not new or new not in s, (str(path), 'already applied', new[:80])
            s = s.replace(old, new, 1)
        path.write_text(s, encoding='utf-8')
        print('edit:', path)
    h = HISTORY.read_text(encoding='utf-8').split('\n')
    at = [i for i, line in enumerate(h) if line.startswith(HISTORY_AFTER)]
    assert len(at) == 1 and HISTORY_ROW not in h, 'the history row'
    h.insert(at[0] + 1, HISTORY_ROW)
    HISTORY.write_text('\n'.join(h), encoding='utf-8')
    print('edit:', HISTORY)


def queue_line(lines):
    at = [i for i, line in enumerate(lines) if line.startswith('- **Queue:** ')]
    assert len(at) == 1, at
    return at[0]


def head():
    lines = BOARD.read_text(encoding='utf-8').split('\n')
    q = queue_line(lines)
    assert '(landing now' not in lines[q], 'another clause holds the head: ' + lines[q][:200]
    clause = f'{NAME} at the head of the queue ({HEAD_TEXT}); '
    assert HEAD.fullmatch(clause), clause
    lines[q] = lines[q].replace('- **Queue:** ', '- **Queue:** ' + clause, 1)
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('head: clause written')


def land():
    lines = BOARD.read_text(encoding='utf-8').split('\n')
    q = queue_line(lines)
    assert len(HEAD.findall(lines[q])) == 1 and lines[q].startswith('- **Queue:** ' + NAME + ' at the head'), 'not at the head'
    lines[q] = HEAD.sub('', lines[q], count=1)
    lines[q] = lines[q].replace('- **Queue:** ', '- **Queue:** ' + LANDED, 1)
    BOARD.write_text('\n'.join(lines), encoding='utf-8')
    print('land: clause written')


if __name__ == '__main__':
    commands = {'edit': edit, 'head': head, 'land': land}
    if len(sys.argv) == 2 and sys.argv[1] in commands:
        commands[sys.argv[1]]()
    else:
        sys.exit(__doc__)
