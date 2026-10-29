#!/usr/bin/env python3
"""RF round 1, after the cross-model reader's re-read of the fixes (evidence/REVIEW-TEXTS.md, The re-read): the
one-occasion example read as an example, not a law for every schedule not given as a list, and accordance assuming
strict dominance at the occasions shown, without fixing a planner. Applied once to the branch (the chapters, the two
modules' doc comments in the package and the kit, the root's bullet, the README rows) and mirrored into the kit's
scripts and blocks (cold-read/s11.md, texts_rf.py, integrate_rf.py, make_records_rf.py, study_rf.txt). Each edit is
asserted to apply exactly once in each file named.
usage (from the checkout root of the landing worktree): python3 -B reread_rf.py"""
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CH3 = ROOT / 'theories/becoming/chapters/03-KNOWING.md'
S11, TEXTS, INTEGRATE = HERE / 'cold-read/s11.md', HERE / 'texts_rf.py', HERE / 'integrate_rf.py'
RECORDS, STUDY = HERE / 'make_records_rf.py', HERE / 'study_rf.txt'
UNREAD = [PKG / 'Becoming/Unread.lean', HERE / 'tree/Becoming/Unread.lean']
SHOWN = [PKG / 'Becoming/ShownOrder.lean', HERE / 'tree/Becoming/ShownOrder.lean']


def edit(paths, old, new):
    for path in paths:
        text = path.read_text(encoding='utf-8')
        assert text.count(old) == 1, (str(path.relative_to(ROOT)), old[:70], text.count(old))
        path.write_text(text.replace(old, new), encoding='utf-8')


# 03 §11 (and its block in the kit, held whole there and in texts_rf.py's S11)
edit([CH3, S11, TEXTS],
     "(the read occasions listed; for a schedule not given as a list, up to a double negation, "
     "`Learning.determines_iff_not_not`)",
     "(the read occasions listed; in a one-occasion example read where `P` holds, the act is fixed exactly where `¬¬P`, "
     "where the exact form would say `P`, `Learning.determines_iff_not_not`)")
edit([CH3, S11, TEXTS],
     "that behaviour fixes a planner and a reward together only under assumptions on the planner (Armstrong and "
     "Mindermann 2018) lies outside, since accordance fixes the planner.",
     "that behaviour fixes a planner and a reward together only under assumptions on the planner (Armstrong and "
     "Mindermann 2018) lies outside: the law assumes strict dominance at the occasions shown and does not represent how "
     "the choices are computed.")

# the two modules' doc comments
edit(UNREAD,
     """  `lumped_determines`, needs none of these. For a schedule not given as a list, the exact form holds
  up to a double negation: with one occasion, a constant lumping and two act values, read exactly
  where `P` holds, the readings fix the act exactly where `¬¬P` (`determines_iff_not_not`).
""",
     """  `lumped_determines`, needs none of these. A one-occasion example shows why the list is needed:
  with a constant lumping and two act values, the occasion read exactly where `P` holds, the readings
  fix the act exactly where `¬¬P`, where the exact form would say `P` (`determines_iff_not_not`).
""")
edit(UNREAD,
     """/-- **For a schedule not given as a list, fixing up to a double negation.** With one occasion, a
constant lumping and two act values, read exactly where `P` holds, the readings fix the act exactly
where `¬¬P`, not `P`: for such a schedule the exact form of `determines_lumped_iff` holds up to a
double negation. -/""",
     """/-- **One occasion read where `P` holds: fixed exactly where `¬¬P`.** With one occasion, a constant
lumping and two act values, the occasion read exactly where `P` holds, the readings fix the act
exactly where `¬¬P`, where the exact form of `determines_lumped_iff` would say `P`: an example of why
that form takes the read occasions as a list, not a law for every schedule. -/""")
edit(SHOWN,
     """  order form (Ng and Russell 2000). That behaviour fixes a planner and a reward together only under
  assumptions on the planner (Armstrong and Mindermann 2018) lies outside: accordance fixes the
  planner here.""",
     """  order form (Ng and Russell 2000). That behaviour fixes a planner and a reward together only under
  assumptions on the planner (Armstrong and Mindermann 2018) lies outside: this module assumes strict
  dominance at the occasions shown and does not represent how the choices are computed.""")

# the root's bullet and the README rows (the package and integrate_rf.py)
edit([PKG / 'Becoming.lean', INTEGRATE],
     """  on every reading and taking that value at `x` (`Learning.twin_selected`); for a schedule not given
  as a list, fixing holds up to a double negation (`Learning.determines_iff_not_not`); for fixed maps""",
     """  on every reading and taking that value at `x` (`Learning.twin_selected`); in a one-occasion example
  read where `P` holds, fixed exactly where `¬¬P` (`Learning.determines_iff_not_not`); for fixed maps""")
EN_OLD = "for a schedule not given as a list, fixing up to a double negation (`Learning.determines_iff_not_not`)"
EN_NEW = "in a one-occasion example read where `P` holds, fixed exactly where `¬¬P` (`Learning.determines_iff_not_not`)"
ZH_OLD = "读时不以列给，则所定唯至二重否定（`Learning.determines_iff_not_not`）"
ZH_NEW = "一时之例，`P` 成立处为读，则所定恰当 `¬¬P`（`Learning.determines_iff_not_not`）"
edit([PKG / 'README.md'], EN_OLD, EN_NEW)
edit([PKG / 'README.zh.md'], ZH_OLD, ZH_NEW)
text = INTEGRATE.read_text(encoding='utf-8')
assert text.count(EN_OLD) == 1 and text.count(ZH_OLD) == 1
INTEGRATE.write_text(text.replace(EN_OLD, EN_NEW).replace(ZH_OLD, ZH_NEW), encoding='utf-8')

# the records' texts
edit([RECORDS],
     '''     ("For a schedule not given as a list, fixing holds up to a double negation: with one occasion, a constant lumping "
      "and two act values, read exactly where P holds, the readings fix the act exactly where ¬¬P.",
      "读时不以列给，则所定唯至二重否定：一时、归并恒定、行有二值，P 成立处为读，则读处定此行恰当 ¬¬P。",''',
     '''     ("Example, why the exact form takes a list: with one occasion, a constant lumping and two act values, the occasion "
      "read exactly where P holds, the readings fix the act exactly where ¬¬P, where the exact form would say P.",
      "例，确形何以需列：一时、归并恒定、行有二值，此时恰于 P 成立时为读，则读处定此行恰当 ¬¬P，而确形当言 P。",''')
edit([RECORDS],
     "f'{DATE_EN}: added (RF round 1), what readings fix of the unread: the twin where the formation can tell, fixing '\n"
     "           f'up to a double negation where the schedule is not a list, the chain of acts, states and couplings with its '",
     "f'{DATE_EN}: added (RF round 1), what readings fix of the unread: the twin where the formation can tell, a '\n"
     "           f'one-occasion example fixed exactly where ¬¬P, the chain of acts, states and couplings with its '")
edit([RECORDS], "读时不以列给时所定唯至二重否定，", "一时之例所定恰当 ¬¬P，")
edit([RECORDS],
     '"assumptions on the planner (Armstrong and Mindermann 2018) lies outside, since accordance fixes the "\n'
     '           "planner. These are readings, not containments.",',
     '"assumptions on the planner (Armstrong and Mindermann 2018) lies outside: the law assumes strict dominance at "\n'
     '           "the occasions shown and does not represent how choices are computed. These are readings, not containments.",')
edit([RECORDS], "（Armstrong 与 Mindermann 2018），在外，'\n           '因相合已定择者。皆为读，非包含。'",
     "（Armstrong 与 Mindermann 2018），在外：'\n           '此律设所择于所示之时严胜，未表择之所算。皆为读，非包含。'")

# the study section's template
edit([STUDY],
     "    as the data, and for a schedule not given as a list fixing holds up to a double negation\n"
     "    (determines_iff_not_not); with being in x's lump decided,",
     "    as the data, and a one-occasion example read where P holds is fixed exactly where ¬¬P\n"
     "    (determines_iff_not_not), why the exact form takes a list; with being in x's lump decided,")
edit([STUDY],
     "the record readings say \"AI reading\", and \"exact kernel\" and \"exact form\" are gone.",
     "the record readings say \"AI reading\", and \"exact kernel\" and \"exact form\" are gone. A re-read by the "
     "cross-model reader found thirteen of its fourteen findings taken correctly and two further problems (the "
     "one-occasion example generalized in some summaries; accordance said to fix a planner), both taken.")
print('re-read: 03 §11; Unread and ShownOrder doc comments (package and kit); root bullet; README rows; records; '
      'study template; kit mirrors')
