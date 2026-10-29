#!/usr/bin/env python3
"""RF round 2, RF6.1's landing: join Becoming.OpenedCorrection to the ring as an application (it imports
GuardHorizon, an application, and Revision) and put its texts in place. Copies the module (no landed module changes);
adds it to the checker's application list; imports it in the root module after GuardHorizon, with an L1 bullet; adds
the package README rows (EN after GuardHorizon's, ZH after ReflexivePrediction's); inserts 03 §8's entry after the
record of selection under registration revision and brings 03's Open bullet to it; adds 08 §8's bullet; brings RF's
plan (§4.6's RF6.1 bullet and §12's order) to it; adds the record and the module to regions.json. Every backticked
name the texts cite from the module is checked against the scratch build's axiom audit. Each edit is asserted to
apply exactly once.
usage (from the checkout root of the landing worktree, clean): python3 -B <kit>/round2/integrate_rf61.py"""
import json
import re
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CH = ROOT / 'theories/becoming/chapters'
PLAN = HERE.parent.parent / 'PLAN.md'
NAMES = set(re.findall(r'^#print axioms Becoming\.(\S+)$',
                       (HERE / 'tree/.build/BecomingOpenedCorrectionAxiomAudit.lean').read_text(encoding='utf-8'), re.M))


def cited(text):
    found = set(re.findall(r'`(OpenedCorrection\.[A-Za-z_.\']+)`', text))
    missing = sorted(n for n in found if n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


target = PKG / 'Becoming/OpenedCorrection.lean'
assert not target.exists(), target
shutil.copyfile(HERE / 'tree/Becoming/OpenedCorrection.lean', target)

checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.SeedReach", "Becoming.ScopedReach"]',
     '"Becoming.SeedReach", "Becoming.ScopedReach", "Becoming.OpenedCorrection"]')

root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.GuardHorizon\n', 'import Becoming.GuardHorizon\nimport Becoming.OpenedCorrection\n')
BULLET = """* `Becoming.OpenedCorrection` (L1): a revision of a reading that opens a correction, along one
  process. Correctable at a configuration: a fitting uniform policy exists through the reading in
  force there, its acts acceptable and executable (`OpenedCorrection.Correctable`); a course of the
  process opens a correction where it leads from a configuration lacking one to one with it,
  acceptability fixed (`OpenedCorrection.OpensAlong`); a reading read off the old through a supplied
  map, gaining no executability, opens nothing (`OpenedCorrection.coarser_opens_nothing`); on
  Revising's process, rebuilding the link opens the correction where a unit of stock remains after
  (`OpenedCorrection.Linked.opens`, `OpenedCorrection.Linked.rebuilt_starved`), and replenishing
  alone opens it where the link is on and the stock is not (`OpenedCorrection.Linked.opens_by_support`).
  An application in the ring (board item RF).
"""
lines = root.read_text(encoding='utf-8').split('\n')
at = [i for i, line in enumerate(lines) if line.startswith('* `Becoming.GuardHorizon` (L')]
assert len(at) == 1, at
nxt = next(i for i in range(at[0] + 1, len(lines)) if lines[i].startswith('* `Becoming.'))
lines[nxt:nxt] = cited(BULLET).rstrip('\n').split('\n')
root.write_text('\n'.join(lines), encoding='utf-8')


def readme_row(path, after, row, absent):
    rows = path.read_text(encoding='utf-8').split('\n')
    i = [k for k, line in enumerate(rows) if line.startswith(after)]
    assert len(i) == 1, (after, i)
    assert not any(absent in line for line in rows), absent
    rows[i[0] + 1:i[0] + 1] = [cited(row)]
    path.write_text('\n'.join(rows), encoding='utf-8')


readme_row(PKG / 'README.md', '| L1 | [`Becoming.GuardHorizon`]',
           "| L1 | [`Becoming.OpenedCorrection`](Becoming/OpenedCorrection.lean) | a revision of a reading that opens a "
           "correction, along one process (an application; every axiom report empty; each result under the hypotheses "
           "its theorem states): correctable where a fitting uniform policy exists through the reading in force "
           "(`OpenedCorrection.Correctable`), a course opening one with acceptability fixed "
           "(`OpenedCorrection.OpensAlong`), on Revising's process where a unit of stock remains after the rebuild "
           "(`OpenedCorrection.Linked.opens`) |", '[`Becoming.OpenedCorrection`]')
readme_row(PKG / 'README.zh.md', '| L1 | [`Becoming.ReflexivePrediction`]',
           "| L1 | [`Becoming.OpenedCorrection`](Becoming/OpenedCorrection.lean) | 沿一过程开一更正之读之修订（一应用；每项公理报告皆空；各结果以各定理所列条件为前提）："
           "经所行之读有合之一致策略处可更正（`OpenedCorrection.Correctable`），一历程于可受者守定时开之（`OpenedCorrection.OpensAlong`），"
           "于 Revising 之过程重建后尚余一储处（`OpenedCorrection.Linked.opens`） |", '[`Becoming.OpenedCorrection`]')

ch3 = CH / '03-KNOWING.md'
edit(ch3, "Lean: `Learning.Training.keeps_through_iff`, `Learning.Training.lost_choice`, `Stock.feasible_iff_covered`; "
          "[record](../results/records/selection-under-registration-revision.md).\n",
     "Lean: `Learning.Training.keeps_through_iff`, `Learning.Training.lost_choice`, `Stock.feasible_iff_covered`; "
     "[record](../results/records/selection-under-registration-revision.md).\n\n"
     + (HERE / 's8.txt').read_text(encoding='utf-8').rstrip('\n') + '\n')
edit(ch3, "revision that opens an executable correction, as a reachable step of a formation's own course; ",
     "a supplied controller's run taking a correction a revision opens ([§8](#r-a-revision-that-opens-a-correction)); ")

ch8 = CH / '08-METHOD.md'
edit(ch8, "The laws are near-definitional, general laws of blanketed laws, or witnesses; what they add is their place in "
          "one account.\n",
     "The laws are near-definitional, general laws of blanketed laws, or witnesses; what they add is their place in "
     "one account.\n"
     "- A revision of a reading that opens a correction ([03 §8](03-KNOWING.md#r-a-revision-that-opens-a-correction)) "
     "composes GuardHorizon's choice from readings with Revising's stock and link along a trace of one process, the "
     "acceptability fixed; its relation to double-loop learning (Argyris and Schön 1978) depends on whether inquiry "
     "changes a governing norm, which it does not here. Near-definitional, with witnesses on Revising's process.\n")

edit(PLAN, "- **RF6.1** (`Becoming.OpenedCorrection`). Built in the kit and reviewed, and held out of this landing: its "
           "opening is a static statement where the design asks for a revision that is a reachable step of one process. It "
           "is rebuilt with the institutional case before its own landing.",
     "- **RF6.1** (`Becoming.OpenedCorrection`). Built in the kit and reviewed, and held out of the first landing: its "
     "opening was a static statement where the design asks for a revision that is a reachable step of one process. "
     "Rebuilt along a trace of one process, on Revising's stock-and-link process, re-checked (findings 19 to 26) and "
     "its texts cold-read, it landed on its own after the first landing: a course opens a correction where it leads "
     "from a configuration lacking a fitting uniform policy through the reading in force to one with it, acceptability "
     "fixed, the gain from the reading, from executability or both; rebuilding the link opens it where a unit of stock "
     "remains after. The institutional case is read on it; an institution's rule of reading as its own process with "
     "members' acts is not built.")
edit(PLAN, "2. Round 2, each landing reviewed before it: first RF3, RF-M's mechanism and RF6.3 (§4.6); then RF6.1 with the "
           "institutional case; then RF-M's assistance and preference cases and RF7.",
     "2. Round 2, each landing reviewed before it: first RF3, RF-M's mechanism and RF6.3 (§4.6, landed); then RF6.1 "
     "(landed, §4.6); then RF-M's assistance and preference cases, an institution's rule of reading with members' acts, "
     "and RF7.")

regions = ROOT / 'theories/becoming/results/data/regions.json'
d = json.loads(regions.read_text(encoding='utf-8'))
assert 'a-revision-that-opens-a-correction' not in d['records'] and 'Becoming.OpenedCorrection' not in d['modules']
d['records']['a-revision-that-opens-a-correction'] = {
    'region': 'knowing', 'base': 'frame', 'note': "OpenedCorrection RF6.1: a course opening a correction along a trace, "
                                                  "acceptability fixed; on Revising's process"}
d['modules']['Becoming.OpenedCorrection'] = {'region': 'knowing', 'base': 'frame',
                                             'note': 'RF6.1 a revision of a reading that opens a correction (03 §8)'}
d['records'] = dict(sorted(d['records'].items()))
d['modules'] = dict(sorted(d['modules'].items()))
regions.write_text(json.dumps(d, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('integrated: Becoming.OpenedCorrection joined as an application (root import and L1 bullet, checker application '
      'list, README rows EN and ZH); 03 §8 and Open; 08 §8 bullet; RF\'s plan §4.6 and §12; regions')
