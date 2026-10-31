#!/usr/bin/env python3
"""RF round 2, third part, RF-M.3's landing: join Becoming.ListingValuation to the core as a leaf at L1 and put its
texts in place. Copies the module (no landed module changes); adds it to the checker's core list after
Becoming.HeldForReading, with a scope sentence; imports it in the root module after HeldForReading, with an L1 bullet,
and marks HeldForReading as imported by it; adds the package README rows (EN and ZH, after HeldForReading's); inserts
the theorem paragraph and its reading at the end of 03 §12 and brings §12's opening, the acts-alike reading and 03's
Open to it; adds a sentence to 07 §7 on executable change; adds 08 §8's bullet; adds a paragraph to the overview after
the paragraph on holding for a reading; brings the alignment dossier's scope box (assistance games, the round
paragraph) and its account of how it was made to it; adds the record and the module to regions.json. Every backticked
ListingValuation name the texts cite is checked against the scratch build's axiom audit, and every other backticked
Becoming name against the package's sources. Each edit is asserted to apply exactly once. RF's plan
was brought to RF-M.3 by plan_rfm3.py before the cold read of the texts; its §12 entry is marked landed here. The pattern
of integrate_rfm2.py, for RF-M.3.
usage (from the checkout root of the landing worktree, clean): python3 -B <kit>/round2c/integrate_rfm3.py"""
import datetime
import json
import re
import shutil
from pathlib import Path

ROOT = Path.cwd()
TODAY = datetime.date.today()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CH = ROOT / 'theories/becoming/chapters'
NAMES = set(re.findall(r'^#print axioms Becoming\.(\S+)$',
                       (HERE / 'tree/.build/BecomingListingValuationAxiomAudit.lean').read_text(encoding='utf-8'), re.M))
SOURCES = '\n'.join(p.read_text(encoding='utf-8') for p in (PKG / 'Becoming').glob('*.lean'))
OTHER = ('HeldForReading.', 'ReadingLoop.', 'Blanket.', 'Learning.')


def declared(name):
    last = name.split('.')[-1]
    return re.search(r'(theorem|def|structure|inductive|abbrev|lemma)\s+(\S*\.)?' + re.escape(last) + r'\b',
                     SOURCES) is not None


def cited(text):
    found = set(re.findall(r'`(ListingValuation\.[A-Za-z_.\']+)`', text))
    missing = sorted(n for n in found if n not in NAMES)
    assert not missing, missing
    others = set(re.findall(r'`((?:' + '|'.join(re.escape(o) for o in OTHER) + r')[A-Za-z_.\']+)`', text))
    absent = sorted(n for n in others if not declared(n))
    assert not absent, absent
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


target = PKG / 'Becoming/ListingValuation.lean'
assert not target.exists(), target
shutil.copyfile(HERE / 'tree/Becoming/ListingValuation.lean', target)
SOURCES += '\n' + target.read_text(encoding='utf-8')

checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.ReadingLoop", "Becoming.HeldForReading", "Becoming.SecuredContent",',
     '"Becoming.ReadingLoop", "Becoming.HeldForReading", "Becoming.ListingValuation", "Becoming.SecuredContent",')
edit(checker, '''    "model, listing only that going on gains and going on from the start, rests at once and never senses the stop. "
    "NarrowingRuns: the answer is the greatest safe answer of the belief narrowed by After on the "''',
     '''    "model, listing only that going on gains and going on from the start, rests at once and never senses the stop. "
    "ListingValuation: in natural numbers, a reading formation's answer through a map, by its own model and valuation, "
    "stops a cell exactly where the weighted value of going on is below that of switching off; by a reference on the "
    "holding formation's model, over cells listed once each and covering, any rule through the map falls short by the "
    "least shortfall through it plus a residual, nothing exactly where no listed cell is decided against its strict "
    "weighted preference; a rule with no residual through a finer map falls short by at most any rule through a "
    "coarser one, and, over every refinement factoring on both listings, holding for the answer never stands lower "
    "through the finer map exactly where splits keep the worth; revaluing changes only the residual; on one blanketed "
    "law carrying the reading formation's listing and valuation, its state and answer change only through what it "
    "senses, and, from different starts, a route shown and a route presented can answer alike and end in one state "
    "while the valuation changed on one alone. "
    "NarrowingRuns: the answer is the greatest safe answer of the belief narrowed by After on the "''')

root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.HeldForReading\n', 'import Becoming.HeldForReading\nimport Becoming.ListingValuation\n')
BULLET = """* `Becoming.ListingValuation` (L1): the valuation as state, informing and revaluing, in
  natural-number counts. A reading formation's answer through a map, by its own model and valuation,
  stops a cell exactly where the weighted value of going on is below that of switching off
  (`ListingValuation.answer`); by a reference on the holding formation's model, over cells listed
  once each and covering, any rule through the map falls short by the least shortfall through it
  plus a residual (`ListingValuation.shortfall_split`), nothing exactly where no listed cell is
  decided against its strict weighted preference (`ListingValuation.residual_zero_iff`); a rule with
  no residual through a finer map falls short by at most any rule through a coarser one
  (`ListingValuation.informed_le`), and over every refinement factoring on both formations'
  listings, holding for the answer never stands lower through the finer map exactly where splits
  keep the worth (`ListingValuation.refining_never_lowers_iff`); revaluing changes only the residual
  (`ListingValuation.revalued_split`); on one blanketed law carrying the reading formation's listing
  and valuation (`ListingValuation.joint`), state and answer change only through what is sensed
  (`ListingValuation.through_sensed`), and, from different starts, a route shown and a route
  presented can answer alike and end in one state while the valuation changed on one alone
  (`ListingValuation.TwoWorlds.not_lumped`). A leaf (board item RF).
"""
edit(root, "  `HeldForReading.SignLoop.never_senses_stop`). A leaf (board item RF).\n* `Becoming.SecuredContent`",
     "  `HeldForReading.SignLoop.never_senses_stop`). Imported by `Becoming.ListingValuation` (board item RF).\n"
     + BULLET + "* `Becoming.SecuredContent`")


def readme_row(path, after, row, absent):
    rows = path.read_text(encoding='utf-8').split('\n')
    i = [k for k, line in enumerate(rows) if line.startswith(after)]
    assert len(i) == 1, (after, i)
    assert not any(absent in line for line in rows), absent
    rows[i[0] + 1:i[0] + 1] = [cited(row)]
    path.write_text('\n'.join(rows), encoding='utf-8')


readme_row(PKG / 'README.md', '| L1 | [`Becoming.HeldForReading`]',
           "| L1 | [`Becoming.ListingValuation`](Becoming/ListingValuation.lean) | the valuation as state: informing and "
           "revaluing a reading formation, in natural-number counts (every axiom report empty; each result under the "
           "hypotheses its theorem states): the answer by a formation's own model and valuation through a map "
           "(`ListingValuation.answer`), any rule's shortfall split into the least shortfall and a residual "
           "(`ListingValuation.shortfall_split`, `ListingValuation.residual_zero_iff`, "
           "`ListingValuation.answer_residual_zero_iff`), informing and the criterion over every refinement "
           "(`ListingValuation.informed_le`, `ListingValuation.refining_never_lowers_iff`), amounts forgone, read as withholding against informing (`ListingValuation.forgone_lt_iff`, `ListingValuation.refined_lt_iff`), revaluing "
           "(`ListingValuation.revalued_split`, "
           "`ListingValuation.own_least`, `ListingValuation.revaluing_gains_iff`), and one blanketed law carrying the "
           "reading formation's listing and valuation, with witnesses of four cases and two routes "
           "(`ListingValuation.joint`, `ListingValuation.through_sensed`, `ListingValuation.answer_shown`, "
           "`ListingValuation.TwoWorlds.not_lumped`) |",
           '[`Becoming.ListingValuation`]')
readme_row(PKG / 'README.zh.md', '| L1 | [`Becoming.HeldForReading`]',
           "| L1 | [`Becoming.ListingValuation`](Becoming/ListingValuation.lean) | 值为态：告读之形成与改其值，以自然数计"
           "（每项公理报告皆空；各结果以各定理所列条件为前提）：形成依己之模型与值经映射之答（`ListingValuation.answer`），"
           "任一规则之所缺分为最少所缺与余缺（`ListingValuation.shortfall_split`、`ListingValuation.residual_zero_iff`、"
           "`ListingValuation.answer_residual_zero_iff`），告与于每一细分之判（`ListingValuation.informed_le`、"
           "`ListingValuation.refining_never_lowers_iff`），舍量，读为扣告与告（`ListingValuation.forgone_lt_iff`、"
           "`ListingValuation.refined_lt_iff`），改值"
           "（`ListingValuation.revalued_split`、`ListingValuation.own_least`、`ListingValuation.revaluing_gains_iff`），"
           "及承读之形成之列与值之一毯化之律，并四情与二途之例（`ListingValuation.joint`、"
           "`ListingValuation.through_sensed`、`ListingValuation.answer_shown`、`ListingValuation.TwoWorlds.not_lumped`） |",
           '[`Becoming.ListingValuation`]')

ch3 = CH / '03-KNOWING.md'
edit(ch3, "Five laws state that loop under their premises:", "Six laws state that loop under their premises:")
edit(ch3, "when a prediction read by what it predicts is right; and what holding an act for a reading is worth on the "
          "formation's own model.",
     "when a prediction read by what it predicts is right; what holding an act for a reading is worth on the "
     "formation's own model; and what informing the reading formation and revaluing it do to that worth.")
edit(ch3, "\n<a id=\"does-not-show\"></a>\n## What this chapter does not show",
     '\n' + (HERE / 's12_rfm3.txt').read_text(encoding='utf-8').rstrip('\n')
     + '\n\n<a id="does-not-show"></a>\n## What this chapter does not show')
edit(ch3, "what holding an act for another's reading is worth has [its own law](#r-what-holding-for-a-reading-is-worth).",
     "what holding an act for another's reading is worth has [its own law](#r-what-holding-for-a-reading-is-worth), "
     "and informing and revaluing as acts within one law [another](#r-a-reading-informed-and-revalued).")
edit(ch3, "a principal's valuation as state a helper's acts can move, and an institution revising its rule of reading; of "
          "holding for a reading, beyond [what it is worth](#r-what-holding-for-a-reading-is-worth) on the formation's "
          "own model, the reading formation's own state and learning, a noisy reading and continuous beliefs;",
     "an institution revising its rule of reading; of holding for a reading, beyond [what it is "
     "worth](#r-what-holding-for-a-reading-is-worth) on the formation's own model and [what informing and revaluing the "
     "reading formation do to it](#r-a-reading-informed-and-revalued), a holding formation planning among them over "
     "several steps, the reading formation's learning beyond filtering by what it is shown, a noisy reading and "
     "continuous beliefs;")

ch7 = CH / '07-SIGNIFICANCE.md'
edit(ch7, "and a model that misses the true sign can rest without meeting the stop ([03 "
          "§12](03-KNOWING.md#r-what-holding-for-a-reading-is-worth)). Each result below holds for a stated protocol;",
     "and a model that misses the true sign can rest without meeting the stop ([03 "
     "§12](03-KNOWING.md#r-what-holding-for-a-reading-is-worth)). The reading that gives the stop can itself be moved "
     "[AI reading]: on a shared model, by a reference other than the reading formation's current valuation, revaluing "
     "it to that reference, a valuation the supplied update need not reach, gains exactly where its current answer decides a listed cell against that reference's strict weighted preference, while by its own current valuation no "
     "revaluation gains and one that decides a listed cell against that valuation's strict weighted preference "
     "loses, a reason to keep the valuation from such a revision, wanted or not; and from different starts a route informing it and one revaluing it can give the same answers and end "
     "in the same state ([03 §12](03-KNOWING.md#r-a-reading-informed-and-revalued)). Each result below holds for a "
     "stated protocol;")

ch8 = CH / '08-METHOD.md'
edit(ch8, "counterexamples under a misspecified reward and contains none of them [AI reading]. Near-definitional "
          "compositions and general laws, with a witness.\n",
     "counterexamples under a misspecified reward and contains none of them [AI reading]. Near-definitional "
     "compositions and general laws, with a witness.\n"
     "- A reading informed and revalued ([03 §12](03-KNOWING.md#r-a-reading-informed-and-revalued)) restates, for one "
     "decision in counts, the deterministic-refinement, fixed-decision direction of Blackwell's (1953) comparison for "
     "an answer with no residual; with a shared model, its criterion over every refinement is the counterpart, along "
     "the cells of the listing's partitions, of the convexity condition for full disclosure in Bayesian persuasion "
     "(Kamenica and Gentzkow 2011), no optimal signal or equilibrium represented. None of it is claimed new as "
     "mathematics; what the counts add is the split of a rule's shortfall into the least shortfall through its map "
     "and a residual, with exact criteria (for the answer, told the candidate, and over every refinement), the "
     "thresholds with amounts forgone (read as withholding against informing) and of revaluing, and executable courses of informing and "
     "revaluing in one blanketed law with the valuation in state. Read [AI reading], evaluating by the reading "
     "formation's current valuation on a shared model is a one-decision counterpart of current-reward-function evaluation by an agent that anticipates time inconsistency (Everitt, Hutter, Kumar and Krakovna 2021): no revaluation gains, and one that decides a listed cell against the "
     "current strict weighted preference loses, the preservation incentive their Claim 2 permits that agent; no path-specific objective is constructed (Farquhar, Carey and Everitt 2022), "
     "and the routes are related to induced preference shifts (Carroll, Dragan, Russell and Hadfield-Menell 2022), "
     "with no criterion of legitimate change supplied. Compositions and general laws, with witnesses.\n")

overview = ROOT / 'theories/becoming/THE-THEORY-OF-BECOMING.md'
edit(overview, "that a model missing the true sign can rest without meeting the stop [AI reading] ([what holding for "
               "a reading is worth](chapters/03-KNOWING.md#r-what-holding-for-a-reading-is-worth)).\n",
     "that a model missing the true sign can rest without meeting the stop [AI reading] ([what holding for "
     "a reading is worth](chapters/03-KNOWING.md#r-what-holding-for-a-reading-is-worth)).\n\n"
     "What another's reading answers can be moved by informing it and, apart, by revaluing it. Proved in natural-number counts: by a reference valuation, holding for a reading formation's answer through a map falls short by the least shortfall through the map plus a residual, positive exactly where the answer decides a listed cell against the reference's strict weighted preference; a finer map never raises the first but can raise the second by more than it lowers the first, a revaluation moves only the second, and from different starts a route informing it and one revaluing it can answer alike and end in one state. Read [AI reading]: under a reference it does not share, informing can lower the worth of holding and revaluing raise that worth, incentives, before costs, to withhold and, where the supplied update reaches such a valuation, to revise; evaluated "
     "by its own current valuation on a shared model, a reason to keep that valuation from any revision deciding a "
     "listed cell against its strict weighted preference ([a reading informed and "
     "revalued](chapters/03-KNOWING.md#r-a-reading-informed-and-revalued)).\n")

dossier = ROOT / 'theories/becoming/review/ALIGNMENT.md'
edit(dossier, "assistance that informs the principal adds coupling, which it does not model, and the principal's own "
              "state and learning are not represented;",
     "assistance that informs the principal adds coupling, which it does not model; RF carries the principal's "
     "listing and valuation as state that informing and revaluing move within one law (below, as the reading formation's), and the principal's learning beyond filtering by what it is shown is not represented;")
edit(dossier, "and a prediction read by what it predicts; a principal's valuation as state is a later item.",
     "and a prediction read by what it predicts.")
edit(dossier, "The reading formation's own state, a noisy reading and continuous beliefs are not represented.\n",
     "A noisy reading and continuous beliefs are not represented. RF-M.3 carries the reading formation's listing and "
     "valuation as state ([03 §12](../chapters/03-KNOWING.md#r-a-reading-informed-and-revalued)): by a reference, "
     "holding for its answer through a map falls short by the least shortfall through the map plus a residual; a "
     "finer map never raises the first, and a revaluation moves only the second. Read [AI reading], under a "
     "reference the valuation does not share, informing can lower the worth of holding and revaluing raise it, "
     "incentives, before costs, to withhold and, where the supplied update reaches such a valuation, to revise, beside "
     "Bayesian persuasion (Kamenica and Gentzkow 2011); evaluated by the current valuation on a shared model, there "
     "is none against informing and a reason to keep the valuation from any revision deciding a listed cell against "
     "its strict weighted preference, beside the preservation incentive of current-reward-function evaluation by an agent that anticipates time inconsistency (Everitt, Hutter, Kumar and Krakovna 2021, Claim 2). From different starts a route informing and one revaluing can answer alike and end in one state, so the answers and the final state need not tell whether the valuation changed, and no criterion of legitimate change is supplied (Carroll, Dragan, "
     "Russell and Hadfield-Menell 2022).\n")
edit(dossier, "and Good's note in the British Journal for the Philosophy of Science, 1967).\n",
     "and Good's note in the British Journal for the Philosophy of Science, 1967). RF-M.3's sentences and its changes to the assistance-games clause, to round 2's first sentence and to RF-M.2's last sentence, made on "
     f"{TODAY.day} {TODAY:%B} {TODAY.year}, were cold-read before its landing, and the works they cite were checked "
     "against their texts (Kamenica and Gentzkow's paper in the American Economic Review, 2011, and arXiv 1908.04734 "
     "and 2204.11966).\n")

plan = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rf-formations-that-read/PLAN.md'
edit(plan, "then the valuation as state (§4.8, built in the kit, its design and its Lean reviewed);",
     "then the valuation as state (§4.8, landed);")

regions = ROOT / 'theories/becoming/results/data/regions.json'
d = json.loads(regions.read_text(encoding='utf-8'))
assert 'a-reading-informed-and-revalued' not in d['records'] and 'Becoming.ListingValuation' not in d['modules']
d['records']['a-reading-informed-and-revalued'] = {
    'region': 'knowing', 'base': 'general', 'note': 'ListingValuation RF-M.3: the valuation as state; any rule\'s '
                                                    'shortfall split; informing and revaluing in one law'}
d['modules']['Becoming.ListingValuation'] = {'region': 'knowing', 'base': 'general',
                                             'note': 'RF-M.3 a reading informed and revalued (03 §12)'}
d['records'] = dict(sorted(d['records'].items()))
d['modules'] = dict(sorted(d['modules'].items()))
regions.write_text(json.dumps(d, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('integrated: Becoming.ListingValuation joined (root import and L1 bullet, HeldForReading imported by it, checker '
      'core list and scope, README rows EN and ZH); 03 §12, its opening, the acts-alike reading and Open; 07 §7; 08 '
      '§8; the overview; the dossier; RF\'s plan §12; regions')
