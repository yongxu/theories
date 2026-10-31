#!/usr/bin/env python3
"""RR2's landing (integrate_rr.py's pattern): join Becoming.RevisionPlans to the core below Becoming.HeldForReading,
which imports it and derives from it its balances, ties, thresholds and comparisons with an amount forgone (rule 9, the diff with RF's
owner), and put the texts in place. Copies RevisionPlans and the changed HeldForReading, the latter only where main's
HeldForReading is the one the kit's diff was made against; where RF-M.3's ListingValuation is on main, proves its
forgone_lt_iff from the order of plans (lv_edits.json, each old text asserted once); adds RevisionPlans to the checker's core list before HeldForReading, with
a scope sentence; imports it in the root module before HeldForReading, with an L1 bullet, and brings HeldForReading's
bullet to it; adds the package README rows (EN and ZH) and HeldForReading's clause; inserts 07 §7's section
(s07_rr2.txt) before the `executable` anchor and points RR's reading to it; adds 03 §12's sentence (in its owner's wording); adds 08 §8's
bullet after RF-M.2's (after RF-M.3's where it has landed); adds the alignment dossier's sentence and how it was made; adds the record and the module to
regions.json; copies RR's note and review and this kit into RR's folder. Every backticked name the texts cite from
either module is checked against the kit's scratch-build axiom audits. Each edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree, clean): python3 -B <kit2>/integrate_rr2.py"""
import hashlib
import json
import re
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CH = ROOT / 'theories/becoming/chapters'
RID = 'when-holding-for-a-reading-stands-above-a-route'
RR = 'when-no-route-stands-above-a-revision'
NOTE_LINK = ('../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/'
             'rr-revision-routes/NOTE.md#10-the-join-routes-of-keeping-and-holding-for-a-reading-one-order-rr2')
REVIEW_LINK = ('../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/'
               'rr-revision-routes/REVIEW.md#rr2-the-independent-review-of-the-join-and-its-re-check')
NAMES = set()
for mod in ('RevisionPlans', 'HeldForReading'):
    NAMES |= set(re.findall(r'^#print axioms Becoming\.(\S+)$',
                            (HERE / f'tree/.build/Becoming{mod}AxiomAudit.lean').read_text(encoding='utf-8'), re.M))
# main's HeldForReading when the kit's diff was made (RF-M.2's landing); stop if it changed since
HELD_BASE = '3e7c19b113e61dc3ae6493ef564d571fc216dc1bc588a0c6b2b64f44b25eb94b'


def cited(text):
    found = set(re.findall(r'`((?:HeldForReading|RevisionPlans)\.[A-Za-z_.\']+)`', text))
    missing = sorted(n for n in found if n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


# RR's folder: the note and the review (their edited copies kept in this kit as `.staged`, so the shared checkout's
# tracked files stay clean and the links check, which reads Markdown, does not read them at the wrong depth) and
# this kit, without the scratch build and the staged copies
WORK = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rr-revision-routes'
if WORK.resolve() != HERE.parent:
    shutil.copyfile(HERE / 'NOTE.md.staged', WORK / 'NOTE.md')
    shutil.copyfile(HERE / 'REVIEW.md.staged', WORK / 'REVIEW.md')
    shutil.copytree(HERE, WORK / 'kit2', dirs_exist_ok=True, ignore=shutil.ignore_patterns(
        '.build', '__pycache__', '*.staged'))

# the modules
target = PKG / 'Becoming/RevisionPlans.lean'
assert not target.exists(), target
shutil.copyfile(HERE / 'tree/Becoming/RevisionPlans.lean', target)
held = PKG / 'Becoming/HeldForReading.lean'
assert hashlib.sha256(held.read_bytes()).hexdigest() == HELD_BASE, 'HeldForReading changed on main: remake the diff'
shutil.copyfile(HERE / 'tree/Becoming/HeldForReading.lean', held)
# RF-M.3's ListingValuation, once on main: forgone_lt_iff from the order of plans (rule 9, with its owner), the
# edits of lv_edits.json (each old text asserted once, so a changed module stops the landing)
listing = PKG / 'Becoming/ListingValuation.lean'
HAS_LV = listing.exists()
if HAS_LV:
    text = listing.read_text(encoding='utf-8')
    for e in json.loads((HERE / 'lv_edits.json').read_text(encoding='utf-8'))['edits']:
        assert text.count(e['old']) == 1, ('ListingValuation', e['old'][:70], text.count(e['old']))
        text = text.replace(e['old'], e['new'])
    listing.write_text(text, encoding='utf-8')

# the checker
checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.ReadingLoop", "Becoming.HeldForReading",',
     '"Becoming.ReadingLoop", "Becoming.RevisionPlans", "Becoming.HeldForReading",')
edit(checker, '''    "HeldForReading: in natural numbers, a policy choosing open acts falls short of one best at every listed "''',
     '''    "RevisionPlans: in natural numbers, plans keeping a law going on at some weight and switching it off at some "
    "weight at each listed candidate, each with a loss of its own, ordered by RevisionRoutes' order of a gain and a "
    "loss: every two plans splitting the weights gain the same with their excesses, so one stands above another "
    "exactly where its loss with its excess is below the other's; RR's revision and routes are plans on one "
    "candidate. "
    "HeldForReading: in natural numbers, a policy choosing open acts falls short of one best at every listed "''')
edit(checker, '''    "model, listing only that going on gains and going on from the start, rests at once and never senses the stop. "''',
     '''    "model, listing only that going on gains and going on from the start, rests at once and never senses the stop; "
    "its balances, ties, thresholds and comparisons with an amount forgone come from RevisionPlans' laws, holding for "
    "a rule being a plan whose excess is the rule's shortfall. "''')

# the root module
root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.HeldForReading\n', 'import Becoming.RevisionPlans\nimport Becoming.HeldForReading\n')
FROM_PLANS = ("  `HeldForReading.SignLoop.never_senses_stop`). It imports `Becoming.RevisionPlans` and derives from\n"
              "  it its balances, its ties, its thresholds and its comparisons with an amount forgone, holding for a\n"
              "  rule being a plan whose excess is the rule's shortfall (`HeldForReading.excess_held`). ")
if HAS_LV:
    edit(root, "  `HeldForReading.SignLoop.never_senses_stop`). Imported by `Becoming.ListingValuation` (board item RF).\n",
         FROM_PLANS + "Imported by `Becoming.ListingValuation` (board items RF,\n  RR2).\n")
else:
    edit(root, "  `HeldForReading.SignLoop.never_senses_stop`). A leaf (board item RF).\n",
         FROM_PLANS + "A leaf (board items RF, RR2).\n")
BULLET = """* `Becoming.RevisionPlans` (L1): plans at a revision, the routes of keeping a law and holding for a
  reading on one order. A plan keeps the law going on at some weight and switches it off at some
  weight at each listed candidate, with a loss of its own, ordered by `RevisionRoutes.GainLoss`;
  every two plans splitting the weights gain the same with their excesses (`RevisionPlans.balance`),
  so between them one stands above another exactly where its loss with its excess is below the
  other's (`RevisionPlans.above_iff`); holding for the reading, forgoing an amount, stands at least as
  high as such a plan exactly where the amount is at most its loss with its excess
  (`RevisionPlans.reading_not_below_iff`); RR's revision and routes are plans on one candidate,
  ordered by each one's loss with the value of the weight it leaves unkept
  (`RevisionPlans.routes_above_iff`). Imported by `Becoming.HeldForReading` (board item RR2).
"""
lines = root.read_text(encoding='utf-8').split('\n')
at = [i for i, line in enumerate(lines) if line.startswith('* `Becoming.HeldForReading` (L')]
assert len(at) == 1, at
lines[at[0]:at[0]] = cited(BULLET).rstrip('\n').split('\n')
root.write_text('\n'.join(lines), encoding='utf-8')


def readme(path, row, tail_old, tail_new):
    rows = path.read_text(encoding='utf-8').split('\n')
    i = [k for k, line in enumerate(rows) if line.startswith('| L1 | [`Becoming.HeldForReading`]')]
    assert len(i) == 1, i
    assert not any('[`Becoming.RevisionPlans`]' in line for line in rows)
    assert rows[i[0]].endswith(tail_old), rows[i[0]][-80:]
    rows[i[0]] = cited(rows[i[0]][:-len(tail_old)] + tail_new)
    rows[i[0]:i[0]] = [cited(row)]
    path.write_text('\n'.join(rows), encoding='utf-8')


readme(PKG / 'README.md',
       "| L1 | [`Becoming.RevisionPlans`](Becoming/RevisionPlans.lean) | plans at a revision, the routes of keeping a "
       "law and holding for a reading on one order (every axiom report empty; each result under the hypotheses its "
       "theorem states): the balance (`RevisionPlans.balance`), the order as each plan's loss with its excess "
       "(`RevisionPlans.above_iff`), holding for the reading against any plan (`RevisionPlans.reading_not_below_iff`), "
       "RR's routes as plans (`RevisionPlans.routes_above_iff`), and moving weight (`RevisionPlans.gainOf_move`) |",
       "`HeldForReading.SignLoop.rests_unread`) |",
       "`HeldForReading.SignLoop.rests_unread`); its balances, ties, thresholds and comparisons with an amount "
       "forgone from RevisionPlans' laws (`HeldForReading.excess_held`) |")
readme(PKG / 'README.zh.md',
       "| L1 | [`Becoming.RevisionPlans`](Becoming/RevisionPlans.lean) | 修订之策：守律之诸途与为读而持同居一序（每项公理报告皆空；"
       "各结果以各定理所列条件为前提）：衡（`RevisionPlans.balance`），序即各策之损加其余（`RevisionPlans.above_iff`），"
       "为读而持对任一策（`RevisionPlans.reading_not_below_iff`），RR 之途为策（`RevisionPlans.routes_above_iff`），"
       "移权（`RevisionPlans.gainOf_move`） |",
       "`HeldForReading.SignLoop.rests_unread`） |",
       "`HeldForReading.SignLoop.rests_unread`）；其衡、等、阈与舍一量之比取自 RevisionPlans 之律（`HeldForReading.excess_held`） |")

# 07 §7: the section before the executable route, and RR's reading pointed to it
ch7 = CH / '07-SIGNIFICANCE.md'
edit(ch7, '<a id="executable"></a>\n',
     (HERE / 's07_rr2.txt').read_text(encoding='utf-8').rstrip('\n') + '\n\n<a id="executable"></a>\n')
edit(ch7, "is not represented here, but in [what holding an act for a reading is worth]"
          "(03-KNOWING.md#r-what-holding-for-a-reading-is-worth), and beliefs or intentions are not",
     "is not represented here, but in [what holding an act for a reading is worth]"
     f"(03-KNOWING.md#r-what-holding-for-a-reading-is-worth), the two joined on one order [below](#r-{RID}); "
     "beliefs or intentions are not")

# 03 §12: holding as a plan of that order
ch3 = CH / '03-KNOWING.md'
# in the Theorem paragraph of what holding for a reading is worth, in its owner's wording (RF-M.3 does not touch it)
edit(ch3, "is what holding for it loses against that reading (`HeldForReading.shortfall`, "
          "`HeldForReading.after_add_shortfall`).",
     "is what holding for it loses against that reading (`HeldForReading.shortfall`, "
     "`HeldForReading.after_add_shortfall`). Going on, switching off and holding for a rule are plans in [the order "
     f"of plans at a revision](07-SIGNIFICANCE.md#r-{RID}): holding for a rule has the rule's shortfall as its excess "
     "there, and its balances with going on and with switching off are that order's balance "
     "(`HeldForReading.excess_held`, `HeldForReading.after_add_shortfall_go`, "
     "`HeldForReading.after_add_shortfall_off`).")

# 08 §8: after RF-M.2's bullet
ch8 = CH / '08-METHOD.md'
lines = ch8.read_text(encoding='utf-8').split('\n')
at = [i for i, line in enumerate(lines)
      if line.startswith('- What holding an act for a reading is worth ([03 §12]')]
assert len(at) == 1, at
# after RF-M.3's bullet where it has landed, which follows RF-M.2's
after = at[0] + 1 if lines[at[0] + 1].startswith('- A reading informed and revalued ([03 §12]') else at[0]
lines[after + 1:after + 1] = [cited(
    f"- When holding for a reading stands above a route ([07 §7](07-SIGNIFICANCE.md#r-{RID})) extends the off-switch "
    "paper's Equation 1 (Hadfield-Menell, Dragan, Abbeel and Russell 2017), whose two terms are RF-M.2's balances for "
    "a rule of stopping, to every two plans splitting a model's weights, each with a loss of its own: the order "
    "between them is that of each one's loss with its distance from the pointwise best. Routes that keep a law in "
    "part, at losses of their own, so stand beside waiting on one order, and RR's routes and RF-M.2's thresholds are "
    "its cases. None of it is claimed new as mathematics. Near-definitional, with witnesses.")]
ch8.write_text('\n'.join(lines), encoding='utf-8')
# RR's bullet points to RF-M.2's, which follows it (RF-M.3's cold read, X19, left to RR2)
edit(ch8, "is not represented here: holding an act for a reading is the bullet above's.",
     "is not represented here: holding an act for a reading is the next bullet's, and the bullet on when holding for "
     "a reading stands above a route joins the two.")

# the alignment dossier
dossier = ROOT / 'theories/becoming/review/ALIGNMENT.md'
edit(dossier, f"as the value of the law's later acting grows ([07 §7](../chapters/07-SIGNIFICANCE.md#r-{RR})). ",
     f"as the value of the law's later acting grows ([07 §7](../chapters/07-SIGNIFICANCE.md#r-{RR})). On the "
     "formation's own model, holding for a reviser's reading and a route of keeping the law stand by each one's own "
     "loss with its excess, its distance from the model's pointwise best, which joins those routes with what a "
     f"stopping reading tells ([07 §7](../chapters/07-SIGNIFICANCE.md#r-{RID})). ")
edit(dossier, "- Under **Known weaknesses**, a bullet quoting a chapter, a record or a study reports a recorded weakness.",
     "- Added on 31 October 2026 (board item RR2, the routes of keeping and holding for a reading on one order): in "
     "the box above, the corrigibility bullet's sentence joining the two, after a cross-model review of the Lean and "
     "the study, every finding taken ([RR's review](" + REVIEW_LINK + ")).\n"
     "- Under **Known weaknesses**, a bullet quoting a chapter, a record or a study reports a recorded weakness.")

# regions
regions = ROOT / 'theories/becoming/results/data/regions.json'
data = json.loads(regions.read_text(encoding='utf-8'))
assert RID not in data['records'] and 'Becoming.RevisionPlans' not in data['modules']
data['records'][RID] = {'region': 'significance', 'base': 'general',
                        'note': 'RR2: when holding for a reading stands above a route of keeping (07 §7); the routes '
                                'and the off-switch game on one order'}
data['modules']['Becoming.RevisionPlans'] = {'region': 'significance', 'base': 'general',
                                             'note': 'RR2: plans at a revision; the balance HeldForReading takes'}
data['records'] = dict(sorted(data['records'].items()))
data['modules'] = dict(sorted(data['modules'].items()))
text = regions.read_text(encoding='utf-8')
regions.write_text(json.dumps(data, ensure_ascii=False, indent=1) + ('\n' if text.endswith('\n') else ''),
                   encoding='utf-8')
print('integrate: RevisionPlans joined below HeldForReading, its laws from it' + (', ListingValuation.forgone_lt_iff from its order' if HAS_LV else '') + '; checker, root, READMEs, 07 §7, '
      '03 §12, 08 §8, dossier, regions')
