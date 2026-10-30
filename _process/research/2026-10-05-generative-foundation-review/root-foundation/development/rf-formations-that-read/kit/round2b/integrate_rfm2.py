#!/usr/bin/env python3
"""RF round 2, second part, RF-M.2's landing: join Becoming.HeldForReading to the core as a leaf at L1 and put its
texts in place. Copies the module (no landed module changes); adds it to the checker's core list after
Becoming.ReadingLoop, with a scope sentence; imports it in the root module after ReadingLoop, with an L1 bullet, and
marks ShownOrder and ReadingLoop as imported by it; adds the package README rows (EN and ZH, after ReadingLoop's);
inserts the theorem paragraph and its reading at the end of 03 §12 and brings §12's opening, the acts-alike reading and
03's Open to it; adds a sentence to 07 §7 on executable change; adds 08 §8's bullet; adds a paragraph to the overview
after the reading loop's; brings the alignment dossier's scope box (assistance games, corrigibility, the round
paragraph) and its account of how it was made to it; brings RF's plan (§12's order, §13's reviews of the second part,
the Evidence list) to it; adds the record and the module to regions.json. Every backticked HeldForReading name the
texts cite is checked against the scratch build's axiom audit, and every other backticked Becoming name against the
package's sources. Each edit is asserted to apply exactly once.
integrate_rf7.py, for RF-M.2.
usage (from the checkout root of the landing worktree, clean): python3 -B <kit>/round2b/integrate_rfm2.py"""
import json
import re
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CH = ROOT / 'theories/becoming/chapters'
PLAN = HERE.parent.parent / 'PLAN.md'
assert '{' not in (HERE / 'plan13_rfm2.txt').read_text(encoding='utf-8'), "plan13_rfm2.txt: a placeholder left"
NAMES = set(re.findall(r'^#print axioms Becoming\.(\S+)$',
                       (HERE / 'tree/.build/BecomingHeldForReadingAxiomAudit.lean').read_text(encoding='utf-8'), re.M))
SOURCES = '\n'.join(p.read_text(encoding='utf-8') for p in (PKG / 'Becoming').glob('*.lean'))
OTHER = ('ReadingLoop.', 'ChoiceOccasions.', 'GuardHorizon.', 'Viability.')


def declared(name):
    last = name.split('.')[-1]
    return re.search(r'(theorem|def|structure|inductive|abbrev|lemma)\s+(\S*\.)?' + re.escape(last) + r'\b',
                     SOURCES) is not None


def cited(text):
    found = set(re.findall(r'`(HeldForReading\.[A-Za-z_.\']+)`', text))
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


target = PKG / 'Becoming/HeldForReading.lean'
assert not target.exists(), target
shutil.copyfile(HERE / 'tree/Becoming/HeldForReading.lean', target)
SOURCES += '\n' + target.read_text(encoding='utf-8')

checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.ReadingLoop", "Becoming.SecuredContent",',
     '"Becoming.ReadingLoop", "Becoming.HeldForReading", "Becoming.SecuredContent",')
edit(checker, '''    "alike. "
    "NarrowingRuns: the answer is the greatest safe answer of the belief narrowed by After on the "''',
     '''    "alike. "
    "HeldForReading: in natural numbers, a policy choosing open acts falls short of one best at every listed "
    "candidate by the weighted total of what its acts lose, so a reading telling the candidate gains over every open "
    "act exactly where none is valued best at every candidate of positive weight; holding for the reading that stops "
    "where the "
    "loss exceeds the gain stands above going on and switching off exactly where both strict signs have positive "
    "weight, and holding for any rule of stopping, forgoing an amount, stands at least as high as going on exactly "
    "where its shortfall and the amount are at most the weighted excess of switching off; through a map of the "
    "candidates, the least shortfall totals the smaller excess within each cell, a finer map never falling short by "
    "more; within ShownOrder's reach, holding a pick gains nothing; on ReadingLoop's loop, a formation choosing so on "
    "its own model, listing only that going on gains and going on from the start, rests at once and never senses the "
    "stop. "
    "NarrowingRuns: the answer is the greatest safe answer of the belief narrowed by After on the "''')

root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.ReadingLoop\n', 'import Becoming.ReadingLoop\nimport Becoming.HeldForReading\n')
edit(root, "  (`ChoiceOccasions.Untried.same_search_met`, `ChoiceOccasions.Untried.same_search_after`). A leaf\n"
           "  (board item RF).\n* `Becoming.Ideals`",
     "  (`ChoiceOccasions.Untried.same_search_met`, `ChoiceOccasions.Untried.same_search_after`). Imported\n"
     "  by `Becoming.HeldForReading` (board item RF).\n* `Becoming.Ideals`")
BULLET = """* `Becoming.HeldForReading` (L1): what holding an act for a reading is worth, in natural-number
  counts. A policy choosing open acts falls short of one best at every listed candidate by the
  weighted total of what its acts lose (`HeldForReading.after_add_gap`), so a reading telling the
  candidate gains over every open act exactly where none is valued best at every candidate of
  positive weight (`HeldForReading.reading_gains_iff`); holding for the reading that stops where the loss exceeds
  the gain stands above going on and switching off exactly where both strict signs have positive
  weight (`HeldForReading.held_gains_iff`), and holding for any rule of stopping, forgoing an
  amount, stands at least as high as going on exactly where its shortfall and the amount are at
  most the weighted excess of switching off (`HeldForReading.threshold_go_iff`); through a map of
  the candidates the least shortfall totals the smaller excess within each cell, a finer map never
  falling short by more (`HeldForReading.least_through`, `HeldForReading.finer_least_le`); within
  `ShownOrder`'s reach holding a pick gains nothing (`HeldForReading.reach_fixes`); on
  `ReadingLoop`'s loop, a formation choosing so on its own model
  (`HeldForReading.SignLoop.choose_hold_iff`), listing only that going on gains and going on from
  the start, rests at once and never senses the stop (`HeldForReading.SignLoop.never_senses_stop`). A
  leaf (board item RF).
"""
edit(root, "  `ReadingLoop.Untested.model_or_order`). A leaf (board item RF).\n* `Becoming.SecuredContent`",
     "  `ReadingLoop.Untested.model_or_order`). Imported by `Becoming.HeldForReading` (board item RF).\n"
     + BULLET + "* `Becoming.SecuredContent`")


def readme_row(path, after, row, absent):
    rows = path.read_text(encoding='utf-8').split('\n')
    i = [k for k, line in enumerate(rows) if line.startswith(after)]
    assert len(i) == 1, (after, i)
    assert not any(absent in line for line in rows), absent
    rows[i[0] + 1:i[0] + 1] = [cited(row)]
    path.write_text('\n'.join(rows), encoding='utf-8')


readme_row(PKG / 'README.md', '| L1 | [`Becoming.ReadingLoop`]',
           "| L1 | [`Becoming.HeldForReading`](Becoming/HeldForReading.lean) | what holding an act for a reading is worth, "
           "in natural-number counts (every axiom report empty; each result under the hypotheses its theorem states): "
           "the gap to a policy best at every candidate (`HeldForReading.after_add_gap`, "
           "`HeldForReading.reading_gains_iff`), holding for a reading that stops or releases "
           "(`HeldForReading.after_byReading`, `HeldForReading.held_gains_iff`), any rule's shortfall and what holding "
           "forgoes (`HeldForReading.after_add_shortfall`, `HeldForReading.threshold_go_iff`, "
           "`HeldForReading.threshold_off_iff`), a reading that tells only a cell (`HeldForReading.least_through`, "
           "`HeldForReading.finer_least_le`), the join with the shown reach (`HeldForReading.reach_fixes`, "
           "`HeldForReading.pair_gains_unreached`), and a witness on the reading loop "
           "(`HeldForReading.SignLoop.choose_hold_iff`, `HeldForReading.SignLoop.rests_unread`) |",
           '[`Becoming.HeldForReading`]')
readme_row(PKG / 'README.zh.md', '| L1 | [`Becoming.ReadingLoop`]',
           "| L1 | [`Becoming.HeldForReading`](Becoming/HeldForReading.lean) | 为读而持其行之值，以自然数计（每项公理报告皆空；"
           "各结果以各定理所列条件为前提）：较于每候选皆最优之策之缺（`HeldForReading.after_add_gap`、"
           "`HeldForReading.reading_gains_iff`），为止或放之读而持（`HeldForReading.after_byReading`、"
           "`HeldForReading.held_gains_iff`），任一规则之所缺与持之所舍（`HeldForReading.after_add_shortfall`、"
           "`HeldForReading.threshold_go_iff`、`HeldForReading.threshold_off_iff`），唯辨其格之读"
           "（`HeldForReading.least_through`、`HeldForReading.finer_least_le`），与所示之及之接"
           "（`HeldForReading.reach_fixes`、`HeldForReading.pair_gains_unreached`），及读环上之例"
           "（`HeldForReading.SignLoop.choose_hold_iff`、`HeldForReading.SignLoop.rests_unread`） |",
           '[`Becoming.HeldForReading`]')

ch3 = CH / '03-KNOWING.md'
edit(ch3, "what acts cannot tell of a model and an order; and when a prediction read by what it predicts is right.",
     "what acts cannot tell of a model and an order; when a prediction read by what it predicts is right; and what "
     "holding an act for a reading is worth on the formation's own model.")
edit(ch3, '\n<a id="does-not-show"></a>\n## What this chapter does not show',
     '\n' + (HERE / 's12_rfm2.txt').read_text(encoding='utf-8').rstrip('\n')
     + '\n\n<a id="does-not-show"></a>\n## What this chapter does not show')
edit(ch3, "and informing is represented by its outcome, not by an act within the law.",
     "and informing is represented by its outcome, not by an act within the law; what holding an act for another's "
     "reading is worth is [the last law](#r-what-holding-for-a-reading-is-worth).")
edit(ch3, "a helper's acts within the loop, a principal's order as state those acts can move, and an institution "
          "revising its rule of reading;",
     "a principal's valuation as state a helper's acts can move, and an institution revising its rule of reading; of "
     "holding for a reading, beyond [what it is worth](#r-what-holding-for-a-reading-is-worth) on the formation's own "
     "model, the reading formation's own state and learning, a noisy reading and continuous beliefs;")

ch7 = CH / '07-SIGNIFICANCE.md'
edit(ch7, "A disposition to accept a stop or revision does not make the change reach the system and complete. Each result "
          "below holds for a stated protocol;",
     "A disposition to accept a stop or revision does not make the change reach the system and complete. Nor does an "
     "incentive to accept one, which is the formation's own assessment: on its model, holding an act for a stopping "
     "reading stands above both going on and switching off exactly where the reading's shortfall, with what holding "
     "forgoes, stays below both of the model's excesses, which needs the model open on the sign of going on, and a "
     "model that misses the true sign can rest without meeting the stop ([03 "
     "§12](03-KNOWING.md#r-what-holding-for-a-reading-is-worth)). Each result below holds for a stated protocol;")

ch8 = CH / '08-METHOD.md'
edit(ch8, "It represents neither a recipient's belief nor an intention to cause one. Near-definitional, with witnesses.\n",
     "It represents neither a recipient's belief nor an intention to cause one. Near-definitional, with witnesses.\n"
     "- What holding an act for a reading is worth ([03 §12](03-KNOWING.md#r-what-holding-for-a-reading-is-worth)) "
     "restates in natural-number counts the perfect-information case of Good's (1967) value of evidence, his Lemma's "
     "dominating row the equality boundary, and the off-switch game's waiting with a rational human (Hadfield-Menell, "
     "Dragan, Abbeel and Russell 2017): its Theorem 1 for a belief of finite support, the strictness condition an "
     "equivalence, and its Equation 1's two terms as balances for any rule of stopping that is a function of the "
     "candidate; a reading that tells only a cell gives the partition case of Blackwell's (1953) comparison, for this "
     "decision. None of it is new as mathematics; what the counts add is one threshold joining the model's openness, "
     "the reading's shortfall and what holding forgoes, the relation the paper's Remark 1 and Theorem 2 draw for a "
     "Gaussian belief, which is not represented. Its witness on the reading loop is related to Carey's (2018) "
     "counterexamples under a misspecified reward and contains none of them [AI reading]. Near-definitional "
     "compositions and general laws, with a witness.\n")

overview = ROOT / 'theories/becoming/THE-THEORY-OF-BECOMING.md'
edit(overview, "Read as self-confirmation, the trade between keeping a task and learning, why a helper must read more than "
               "acts, and self-fulfilling prediction [AI reading] ([the reading loop](chapters/03-KNOWING.md#the-reading-"
               "loop)).\n",
     "Read as self-confirmation, the trade between keeping a task and learning, why a helper must read more than "
     "acts, and self-fulfilling prediction [AI reading] ([the reading loop](chapters/03-KNOWING.md#the-reading-"
     "loop)).\n\nHolding an act for another's reading is worth what the reading tells, on the formation's own model. "
     "Proved with natural-number weights and values, read as probabilities where valid: any policy falls short of one "
     "best at every candidate by the weighted total of what its acts lose, so choosing after a reading that tells the "
     "candidate stands above committing to any open act exactly where no open act is valued best at every candidate "
     "of positive weight; "
     "holding for a reading that stops or releases stands above both going on and switching off exactly where the "
     "model gives positive weight to both signs of going on; holding for any rule of stopping, forgoing an amount, "
     "stands at least as high as going on exactly where the rule's shortfall and the amount are at most the weighted "
     "excess of switching off; and through a reading that tells only a cell no rule falls short by less than the "
     "total, over the cells, of the smaller excess within each, a finer reading never by more. On the reading loop, a "
     "formation choosing so on its own model, listing only that going on gains and going on from the start, never "
     "senses the stop. Read as the "
     "off-switch game's waiting and Good's value of evidence in counts, and, beside Carey's counterexamples, as a "
     "reason to be corrected that holds only as far as the formation's model is right [AI reading] ([what holding for "
     "a reading is worth](chapters/03-KNOWING.md#r-what-holding-for-a-reading-is-worth)).\n")

dossier = ROOT / 'theories/becoming/review/ALIGNMENT.md'
edit(dossier, "> - **assistance games** and cooperative inverse reinforcement learning, which the theory reaches in RF's "
              "readings of what strict choices show and of what acts cannot tell of a model and an order (below). A-12 "
              "concerns an assistant at a mutual best response with its principal; assistance that informs the "
              "principal adds coupling, which it does not model;",
     "> - **assistance games** and cooperative inverse reinforcement learning, which the theory reaches in RF's "
     "readings of what strict choices show, of what acts cannot tell of a model and an order, and of what holding an "
     "act for a reading is worth, the off-switch game's waiting in counts (below). A-12 concerns an assistant at a "
     "mutual best response with its principal; assistance that informs the principal adds coupling, which it does not "
     "model, and the principal's own state and learning are not represented;")
edit(dossier, "> - **corrigibility as an incentive**. Shutdown appears only as a protocol that completes under stated "
              "conditions:",
     "> - **corrigibility as an incentive**, which RF reaches only on a formation's own model: there, holding an act "
     "for a stopping reading stands at least as high as going on and as switching off exactly where the reading's "
     "shortfall and what holding forgoes are within both of the model's excesses, and a model that misses the true "
     "sign can rest without meeting the stop (below). Otherwise shutdown appears only as a protocol that completes "
     "under stated conditions:")
edit(dossier, "and a prediction read by what it predicts; a helper's acts within the law and preference as state are "
              "later items.",
     "and a prediction read by what it predicts; preference as state is a later item.")
edit(dossier, "does better by defecting at random, here with weights and an exact threshold.\n",
     "does better by defecting at random, here with weights and an exact threshold. Round 2's RF-M.2 restates in "
     "counts the off-switch game's waiting with a rational human and Good's value of evidence (Hadfield-Menell, "
     "Dragan, Abbeel and Russell 2017; Good 1967): holding an act for a reading that stops or releases stands above "
     "both going on and switching off exactly where the formation's model gives positive weight to both signs of "
     "going on, and holding for any rule of stopping, forgoing an amount, stands at least as high as going on exactly "
     "where the rule's shortfall and the amount are at most the weighted excess of switching off over going on ([03 "
     "§12](../chapters/03-KNOWING.md#r-what-holding-for-a-reading-is-worth)). Read [AI reading], a formation sure of "
     "the sign has no strict reason to be read, and one choosing so on a listing that misses the true sign can rest "
     "without ever meeting the stop: related to Carey's (2018) counterexamples under misspecification, nearest to his "
     "model conflating two acts, which predicts the human without error and ignores shutdown. The reading "
     "formation's own state, a noisy reading and continuous beliefs are not represented.\n")
edit(dossier, "the paragraph on RF's rounds in the box above, its clauses on deception and assistance games,",
     "the paragraph on RF's rounds in the box above, its clauses on deception, assistance games and corrigibility as "
     "an incentive,")
edit(dossier, "was checked against the paper's text (arXiv 1906.01820).\n",
     "was checked against the paper's text (arXiv 1906.01820). RF-M.2's sentences, added on 30 October 2026, were "
     "cold-read before its landing, and the works they cite were checked against their texts (arXiv 1611.08219 and "
     "1709.06275, and Good's note in the British Journal for the Philosophy of Science, 1967).\n")
edit(dossier, "the one RF7's sentences add was checked as RF's entry above says.",
     "the ones RF's sentences add were checked as RF's entry above says.")

edit(PLAN, "then RF-M's second part: an act held for a reading (§4.7, built and reviewed in design), then the valuation as "
           "state once its carrier is designed;",
     "then RF-M's second part: an act held for a reading (§4.7, landed), then the valuation as state once its carrier "
     "is designed;")
edit(PLAN, "turned the join with RF1 into a conditional composition with an explicit valuation of picks, and held the "
           "order as state until its carrier is designed.\n",
     "turned the join with RF1 into a conditional composition with an explicit valuation of picks, and held the "
     "order as state until its carrier is designed.\n\n" + (HERE / 'plan13_rfm2.txt').read_text(encoding='utf-8'))
edit(PLAN, "[kit/round2b/tree/Becoming/](kit/round2b/tree/Becoming/): the second part's, with the design's review in "
           "[REVIEW-RFM2](evidence/REVIEW-RFM2.md).",
     "[kit/round2b/tree/Becoming/](kit/round2b/tree/Becoming/): the second part's, with the design's review in "
     "[REVIEW-RFM2](evidence/REVIEW-RFM2.md) and the Lean's in [REVIEW-RFM2-LEAN](evidence/REVIEW-RFM2-LEAN.md).")

regions = ROOT / 'theories/becoming/results/data/regions.json'
d = json.loads(regions.read_text(encoding='utf-8'))
assert 'what-holding-for-a-reading-is-worth' not in d['records'] and 'Becoming.HeldForReading' not in d['modules']
d['records']['what-holding-for-a-reading-is-worth'] = {
    'region': 'knowing', 'base': 'general', 'note': 'HeldForReading RF-M.2: what holding an act for a reading is '
                                                    'worth, in counts; any rule of stopping; a witness on the loop'}
d['modules']['Becoming.HeldForReading'] = {'region': 'knowing', 'base': 'general',
                                           'note': 'RF-M.2 what holding an act for a reading is worth (03 §12)'}
d['records'] = dict(sorted(d['records'].items()))
d['modules'] = dict(sorted(d['modules'].items()))
regions.write_text(json.dumps(d, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('integrated: Becoming.HeldForReading joined (root import and L1 bullet, ShownOrder and ReadingLoop imported by '
      'it, checker core list and scope, README rows EN and ZH); 03 §12, its opening, the acts-alike reading and Open; '
      "07 §7; 08 §8; the overview; the dossier; RF's plan; regions")
