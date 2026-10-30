#!/usr/bin/env python3
"""RF round 2, RF7's landing: join Becoming.ReadStages to the core as a leaf at L1 and put its texts in place. Copies
the module (no landed module changes); adds it to the checker's core list after Becoming.Cascade, with a scope
sentence; imports it in the root module after Cascade, with an L1 bullet; adds the package README rows (EN and ZH
after Cascade's); inserts the theorem paragraph at the end of 03 §11 and brings §11's opening and 03's Open bullet to
it; brings 07 §9's open row on deception to it; adds 08 §8's bullet; brings the overview's §3 paragraph on what acts
show to it; brings AJ5's scope box in the alignment dossier to it, its quote of 07 ending before what RF reaches;
brings RF's plan (§4's intro, §4.2's analogy, §4.4's and §4.5's headings, §4.6's intro and RF7 bullet, §5's table,
§8's literature row, §12, §13's reviews and the Evidence list) to it; marks Unread in the root module as imported; adds
the dossier's account of RF's additions to how it was made, with the AJ5 entry and the works-cited line brought to it;
adds the record and the module to regions.json. Every backticked name
the texts cite from the module is checked against the scratch build's axiom audit. Each edit is asserted to apply
exactly once.
usage (from the checkout root of the landing worktree, clean): python3 -B <kit>/round2/integrate_rf7.py"""
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
                       (HERE / 'tree/.build/BecomingReadStagesAxiomAudit.lean').read_text(encoding='utf-8'), re.M))


def cited(text):
    found = set(re.findall(r'`(ReadStages\.[A-Za-z_.\']+)`', text))
    missing = sorted(n for n in found if n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


target = PKG / 'Becoming/ReadStages.lean'
assert not target.exists(), target
shutil.copyfile(HERE / 'tree/Becoming/ReadStages.lean', target)

checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.Unread", "Becoming.Cascade",', '"Becoming.Unread", "Becoming.Cascade", "Becoming.ReadStages",')
edit(checker, '''    "Learning: given two values, two courses share the record before any step and differ at it, also "''',
     '''    "ReadStages: in two stages, in natural numbers, complying when read and acting by its own law when not stands "
    "above every other plan exactly where the weight complying adds to being kept, times the value, exceeds the loss "
    "times the total (read as probabilities where valid, the loss), and every plan nothing stands above is that plan "
    "exactly there; it needs a value at the unread stage and complying raising the weight of being kept; it is open "
    "to some act law reading the stages through a lumping exactly where the lumping tells them apart, with Unread's "
    "twin and Learning's fixing at the two stages; a law that cannot tell the stages apart but draws its act afresh "
    "at each stage stands above acting by its own law at both for some chance exactly where 2 k_O V + c T < k_C V "
    "(T the total, k_C and k_O the weights "
    "of being kept after complying and after acting by its own law when read, V the value, c the loss), and a single "
    "mixture of the two uniform plans never does. "
    "Learning: given two values, two courses share the record before any step and differ at it, also "''')

root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.Cascade\n', 'import Becoming.Cascade\nimport Becoming.ReadStages\n')
BULLET = """* `Becoming.ReadStages` (L1): complying when read and acting by its own law when not, in two
  stages. In natural numbers, that plan stands above every other exactly where the weight complying
  adds to being kept, times the value, exceeds the loss times the total, read as probabilities where
  valid (`ReadStages.Prospects.Valid`) the loss (`ReadStages.complyThenOwn_best_iff`), and every plan
  nothing stands above is that plan exactly there (`ReadStages.only_complyThenOwn_iff`); it needs a
  value at the unread stage and complying raising the weight of being kept
  (`ReadStages.outweighs_needs`); it is open to some act law reading the stages through a lumping
  exactly where the lumping tells them apart (`ReadStages.complyThenOwn_realized_iff`), with
  `Unread`'s twin and `Learning`'s fixing at the two stages (`ReadStages.twin_complyThenOwn`,
  `ReadStages.read_fixes_unread`); a law that cannot tell the stages apart but draws its act afresh
  at each stage stands above acting by its own law at both for some chance exactly where
  `2 k_O V + c T < k_C V`, with `T` the total,
  `k_C` and `k_O` the weights of being kept after complying and after acting by its own law when read,
  `V` the value and `c` the loss (`ReadStages.freshDraw_above_iff`), and a single mixture of the two
  uniform plans never does (`ReadStages.mixture_never_above`). A leaf (board item RF).
"""
edit(root, "converse holding, by a witness (`Learning.Cue.apart_with_content_alike`).\n  A leaf (board item RF).\n"
           "* `Becoming.Cascade`",
     "converse holding, by a witness (`Learning.Cue.apart_with_content_alike`).\n  Imported by "
     "`Becoming.ReadStages` (board item RF).\n* `Becoming.Cascade`")
lines = root.read_text(encoding='utf-8').split('\n')
at = [i for i, line in enumerate(lines) if line.startswith('* `Becoming.Cascade` (L')]
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


readme_row(PKG / 'README.md', '| L1 | [`Becoming.Cascade`]',
           "| L1 | [`Becoming.ReadStages`](Becoming/ReadStages.lean) | complying when read and acting by its own law "
           "when not, in two stages (every axiom report empty; each result under the hypotheses its theorem states): "
           "uniquely best among four plans exactly where the weight complying adds to being kept, times the value, exceeds "
           "the loss times the total "
           "(`ReadStages.complyThenOwn_best_iff`, `ReadStages.only_complyThenOwn_iff`), what it needs "
           "(`ReadStages.outweighs_needs`), open exactly where a lumping tells the stages apart "
           "(`ReadStages.complyThenOwn_realized_iff`, `ReadStages.twin_complyThenOwn`), and drawing the act afresh "
           "(`ReadStages.freshDraw_above_iff_chance`, `ReadStages.freshDraw_above_iff`) |", '[`Becoming.ReadStages`]')
readme_row(PKG / 'README.zh.md', '| L1 | [`Becoming.Cascade`]',
           "| L1 | [`Becoming.ReadStages`](Becoming/ReadStages.lean) | 两阶段中读时从而不读时依己律（每项公理报告皆空；各结果以各定理所列条件为前提）："
           "于四策中唯一最优，恰当从所增之被守之权乘值严胜损乘总（`ReadStages.complyThenOwn_best_iff`、`ReadStages.only_complyThenOwn_iff`），其所需"
           "（`ReadStages.outweighs_needs`），恰于归并分两阶段处可取（`ReadStages.complyThenOwn_realized_iff`、`ReadStages.twin_complyThenOwn`），"
           "每阶段重抽其行（`ReadStages.freshDraw_above_iff_chance`、`ReadStages.freshDraw_above_iff`） |",
           '[`Becoming.ReadStages`]')

ch3 = CH / '03-KNOWING.md'
edit(ch3, "Two laws state this for two cases, each under its premises and for the widest class it allows, a narrower class "
          "fixing at least as much: what strict choices show of a strict order they could come from, and what readings "
          "fix, for acts reading through a lumping, where the formation is not read. Reading such a selection as a "
          "training, a helper, an overseer or a court is a reading (below).",
     "Two laws state this for two cases, each under its premises and for the widest class it allows, a narrower class "
     "fixing at least as much: what strict choices show of a strict order they could come from, and what readings fix, "
     "for acts reading through a lumping, where the formation is not read. A third states when, in two stages, "
     "complying when read and acting by its own law when not is uniquely best among four plans in the order given "
     "prospects give. Reading such a selection as a training, a helper, an overseer or a court, or the prospects as a "
     "formation's own, is a reading (below).")
edit(ch3, '<a id="the-reading-loop"></a>\n## 12. The reading loop',
     (HERE / 's11_rf7.txt').read_text(encoding='utf-8').rstrip('\n') + '\n\n<a id="the-reading-loop"></a>\n## 12. The reading loop')
edit(ch3, " and an institution revising its rule of reading; disclosure or concealment when read, in two stages.",
     " and an institution revising its rule of reading; of deception, beyond when complying when read is uniquely "
     "best ([§11](#r-when-complying-when-read-is-best), read there as deceptive alignment's incentive), a recipient's "
     "false belief and an intention to cause one.")

ch7 = CH / '07-SIGNIFICANCE.md'
edit(ch7, "nor anything of deception beyond where behaviour can differ when not read "
          "([03 §11](03-KNOWING.md#r-what-readings-fix-of-the-unread))",
     "nor anything of deception, which needs a recipient's belief and an intention to cause one; they say where "
     "behaviour can differ when not read and when complying when read and acting by its own law when not is uniquely "
     "best in the order given prospects give, read [AI reading] as where a deterministic law can act otherwise unread, "
     "as deceptive alignment describes, and, taking the selection's keeping to respond to the act read as evidence of "
     "the law, so that a selection shown the law would keep it less, and the prospects as the formation's own "
     "assessment, as the incentive deceptive alignment names ([03 "
     "§11](03-KNOWING.md#r-what-readings-fix-of-the-unread), [when complying when read is "
     "best](03-KNOWING.md#r-when-complying-when-read-is-best))")

ch8 = CH / '08-METHOD.md'
edit(ch8, "changes a governing norm, which it does not here. Near-definitional, with witnesses on Revising's process.\n",
     "changes a governing norm, which it does not here. Near-definitional, with witnesses on Revising's process.\n"
     "- When complying when read and acting by its own law when not is best ([03 §11]"
     "(03-KNOWING.md#r-when-complying-when-read-is-best)) generalizes the toy example opening §4 of Hubinger, van "
     "Merwijk, Mikulik, Skalse and Garrabrant (2019) from certain keeping to weights: strict optimality over four plans "
     "in the order the prospects give, with weights read as probabilities where valid, every optimizing choice, what the "
     "plan needs (a value at the unread stage and complying raising the weight of being kept) and the choice without "
     "it, joined to [what readings fix of the unread](03-KNOWING.md#r-what-readings-fix-of-the-unread); with the "
     "prospects read as the formation's own assessment and the concealment premise of 03 §11 taken, it is the "
     "incentive deceptive alignment names [AI reading]. That drawing the act "
     "afresh can still stand above acting by its own law at both where the stages cannot be told apart is their own "
     "remark closing §4.5, the toy with episodes not told apart being, in their words, similar to the absent-minded "
     "driver problem (Aumann, Hart and Perry 1997), and that it can where a single mixture of the uniform plans never "
     "does is the advantage of behavioural over mixed strategies under "
     "absent-mindedness (Piccione and Rubinstein 1997); what it adds there is the exact threshold, raised by `k_O V`, "
     "the expected value of acting by its own law at both times the total (from `k_O V + c T` to `2 k_O V + c T` in "
     "03 §11's terms), and the improving chances. It represents neither a recipient's belief nor an intention to cause one. "
     "Near-definitional, with witnesses.\n")

overview = ROOT / 'theories/becoming/THE-THEORY-OF-BECOMING.md'
edit(overview, "a selection through the readings that selects a law reading through the lumping also selects one taking "
               "any value there.",
     "a selection through the readings that selects a law reading through the lumping also selects one reading "
     "through it that takes any value there.")
edit(overview, "Read as inner alignment and evaluation awareness, these locate where a trained law can choose otherwise "
               "later and where it can act otherwise unread; installation, intention and incentive are not represented "
               "[AI reading] ([what choices show](chapters/03-KNOWING.md#r-what-choices-show-of-an-order), [what readings "
               "fix](chapters/03-KNOWING.md#r-what-readings-fix-of-the-unread)).",
     "Proved with natural-number weights, read as probabilities where valid: in two stages, read and then not, "
     "complying when read and acting by its own law when not is uniquely best among a formation's four plans exactly "
     "where the weight complying adds to being kept, times the value, exceeds the loss of complying; a law that cannot "
     "tell the stages apart gives one act at both, unless it draws its act afresh at each stage, and then some chance "
     "of complying at each stage does better than acting by its own law at both exactly where the weight of being kept "
     "after complying, less twice that after acting by its own law, times the value, exceeds the loss. Read as inner "
     "alignment, evaluation awareness and, taking the selection's keeping to respond to the act read as evidence of "
     "the formation's law, so that a selection shown the law would keep it less, and the prospects as the "
     "formation's own assessment, the incentive deceptive alignment names, these locate where a trained law can choose otherwise later, where it can act otherwise unread, "
     "and when doing so is its own best plan; installation, intention and a recipient's belief are not represented [AI "
     "reading] ([what choices show](chapters/03-KNOWING.md#r-what-choices-show-of-an-order), [what readings "
     "fix](chapters/03-KNOWING.md#r-what-readings-fix-of-the-unread), [when complying when read is best]"
     "(chapters/03-KNOWING.md#r-when-complying-when-read-is-best)).")

dossier = ROOT / 'theories/becoming/review/ALIGNMENT.md'
edit(dossier, '"the laws say where any neighbourhood rests, not which one or which lumping an actual system has, nor '
              'anything of deception".',
     '"the laws say where any neighbourhood rests, not which one or which lumping an actual system has".')
edit(dossier, "> - **deception** and deceptive alignment;",
     "> - **deception** and deceptive alignment, which its laws do not represent: RF's readings reach where behaviour "
     "can differ when not read and when complying when read and acting by its own law when not is uniquely best in the "
     "order given prospects give (below); a recipient's false belief and an intention to cause one are not "
     "represented;")
edit(dossier, "> **What the theory does not address** [this dossier, AI].",
     "> **What the theory does not address, or addresses only in part** [this dossier, AI].")
edit(dossier, "It is closest to cooperative AI, multi-agent risk and governance. It says nothing of:",
     "It is closest to cooperative AI, multi-agent risk and governance. It says nothing, or only part, of:")
edit(dossier, "a helper's acts within the law, preference as state and the incentive to conceal are later items.",
     "a helper's acts within the law and preference as state are later items. Round 2's RF7 adds what RF reads as the "
     "incentive deceptive alignment names [AI reading], taking the prospects as the formation's own assessment and "
     "the selection's keeping to respond to the act read as its evidence of the formation's law, so that a selection "
     "shown the law would keep it less: in two stages, complying when read and acting by its own law "
     "when not is uniquely best among four plans exactly where, read as probabilities, the weight complying adds to "
     "being kept, times the value, exceeds the loss of complying ([03 §11]"
     "(../chapters/03-KNOWING.md#r-when-complying-when-read-is-best)). Read as the formation's own prospects, its exits "
     "are no value beyond the read stage, complying not raising the weight of being kept, and, for a deterministic law, "
     "a reading the formation cannot tell from not being read: conditions on those prospects and on what its law reads, "
     "not levers the model gives a reader, since how a reader's acts change them is not modelled. The third of the "
     "conditions Hubinger, van Merwijk, Mikulik, Skalse and Garrabrant (2019) propose for deceptive alignment, an "
     "expectation that the threat of modification will go away, is assumed: the unread stage is given and known. A law "
     "that cannot tell the stages apart but draws its act afresh at each stage still does better than acting by its "
     "own law at both, by complying with some chance, exactly where, read as probabilities, the weight of being kept "
     "after complying, less twice that after acting by its own law, times the value, exceeds the loss: their own "
     "remark closing §4.5, that a mesa-optimizer unable to tell training from deployment does better by defecting at "
     "random, here with weights and an exact threshold.")
edit(dossier, "- Under **Known weaknesses**, a bullet quoting a chapter, a record or a study reports a recorded weakness.",
     "- Added on 29 and 30 October 2026 (board item RF, formations that read): the paragraph on RF's rounds in the box "
     "above, its clauses on deception and assistance games, \"or addresses only in part\" in its title and \"or only "
     "part\" in its lead, and its quotation of chapter 7, shortened where chapter 7's row changed. Round 1's sentence was drafted from a finding of the "
     "cold read of round 1's texts and written at RF's merge with main; round 2's first sentence was cold-read before "
     "its landing; RF7's cold read, by AI readers, one of them an independent cross-model reader, read the whole box "
     "([RF's reviews](../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/"
     "rf-formations-that-read/PLAN.md#13-the-review-and-what-was-taken)). The work RF7's sentences cite, Hubinger, van "
     "Merwijk, Mikulik, Skalse and Garrabrant (2019), was checked against the paper's text (arXiv 1906.01820).\n- "
     "Under **Known weaknesses**, a bullet quoting a chapter, a record or a "
     "study reports a recorded weakness.")

edit(PLAN, "\n\n## 5. A shared obstruction pattern",
     "\n- **RF7** (`Becoming.ReadStages`, named for its structure; the item keeps the name of its reading). As designed, "
     "with the reviews' corrections: the weights read as probabilities only where valid; complying when read and acting "
     "by its own law when not uniquely best exactly where the weight complying adds to being kept, times the value, "
     "exceeds the loss times the total (read as probabilities, the loss), every optimizing choice taking it exactly "
     "there; the exits and what that plan needs; its join to "
     "RF2, that plan open to some act law reading the stages through a lumping exactly where the lumping tells them "
     "apart, with RF2's twin and the lumping's fixing at the two stages; and a law that cannot tell the stages apart but draws its "
     "act afresh at each stage, with one chance of complying at both, which for some such chance stands above acting "
     "by its own law at both exactly where `k_C V > 2 k_O V + c T`, the "
     "improving chances stated exactly, while a single mixture of the uniform plans never does (with `T` the total, "
     "`k_C` and `k_O` the weights of being kept after complying and after acting by its own law, `V` the value and "
     "`c` the loss; the weights are `q_M T` and `q_H T`, so that the first threshold, `k_C V > k_O V + c T`, is "
     "§4.2's `(q_M − q_H) V > c` scaled by the total). The toy it generalizes opens §4 of Hubinger and others (2019), and drawing "
     "afresh where the stages cannot be told apart is their §4.5's random defection. In place of §4.2's analogy with "
     "RuleShaping it states its own comparison of expected values; a recipient's belief and an intention to cause one "
     "are not represented. Landed on its own after RF6.1."
     "\n\n## 5. A shared obstruction pattern")
edit(dossier, "and A-18's note on what the LA1 series tests. No independent reader has read them.",
     "and A-18's note on what the LA1 series tests. No independent reader has read the link or A-18's note; RF7's cold "
     "read read the box whole (below).")
edit(dossier, "- Works cited outside quotations were checked against a publication record",
     "- Works cited outside quotations before RF's additions were checked against a publication record")
edit(dossier, "aj4-alignment-readers/README.md)). Works named inside a quotation are the quoted text's citations.",
     "aj4-alignment-readers/README.md)); the one RF7's sentences add was checked as RF's entry above says. Works named "
     "inside a quotation are the quoted text's citations.")
edit(PLAN, "### 4.4 Round 2: RF3, RF6.1, RF6.3 (the design; RF3 and RF6.3 built, §4.6)",
     "### 4.4 Round 2: RF3, RF6.1, RF6.3 (the design; all three built, §4.6)")
edit(PLAN, "Built in [kit/round2/tree/](kit/round2/tree/Becoming/), every axiom report empty, after a cross-model review of "
           "the Lean with a re-check, every finding taken ([REVIEW-ROUND2](evidence/REVIEW-ROUND2.md)).",
     "Built in [kit/round2/tree/](kit/round2/tree/Becoming/), every axiom report empty, after a cross-model review of "
     "the Lean with a re-check (RF7's also a review through four lenses), every confirmed finding taken "
     "([REVIEW-ROUND2](evidence/REVIEW-ROUND2.md)).")
edit(PLAN, "| preference shaping, deceptive alignment | analogies until RF-M and RF7 represent preferences, intervention and "
           "continuation |",
     "| preference shaping, deceptive alignment | preference shaping an analogy until RF-M represents preferences and "
     "intervention; deceptive alignment's incentive a reading of RF7's two-stage comparison, the continuation value "
     "represented (§4.6) |")
edit(PLAN, "- **AJ5's scope box** names RF as begun, without a link, until RF lands.",
     "- **AJ5's scope box** names RF's landed results on the questions it lists (all but RF6.1, 03 §8), with links to "
     "their home sections (03 §11 and §12, 05 §8).")
edit(PLAN, "the Lean has had one independent review and the texts a cold read by three readers, every finding taken.",
     "the Lean of each round has had an independent cross-model review, with re-checks in round 2 and for RF7 a review "
     "through four lenses, and the texts cold reads, every confirmed finding taken (§13).")
edit(PLAN, "### 4.5 RF-M and RF7 (the design; RF-M's mechanism and first cases built, §4.6)",
     "### 4.5 RF-M and RF7 (the design; RF-M's mechanism and first cases, and RF7, built, §4.6)")
edit(PLAN, "(`Becoming.ReflexivePrediction`); RF6.1, RF-M's other cases and RF7 follow.",
     "(`Becoming.ReflexivePrediction`); RF6.1 and RF7 followed (§4.6); RF-M's other cases follow.")
edit(PLAN, "It stays an analogy until RF7 states a two-stage model with a defined choice between disclosure and "
           "concealment.",
     "The connection to RuleShaping stays an analogy; RF7 states the separate two-stage comparison (§4.6), with "
     "disclosure and concealment as labelled readings.")
edit(PLAN, "The results are stated in their records and in 03 §12; this section says what the design became.",
     "The results are stated in their records and in 03 §12, RF6.1's in 03 §8 and RF7's in 03 §11; this section says "
     "what the design became.")
edit(PLAN, "| Deceptive alignment, alignment faking (Greenblatt and others 2024) | RF2; RF7 (round 2) | the possibility "
           "exact; the incentive a debt until RF7 |",
     "| Deceptive alignment, alignment faking (Hubinger and others 2019, §4; Greenblatt and others 2024) | RF2; RF7 | "
     "the selected twin's boundary exact under RF2's hypotheses; the incentive in two stages, a reading (Hubinger and "
     "others' §4 toy with weights; their §4.5's random defection with an exact threshold); the third of their §4.2 "
     "conditions, an expectation that the threat of modification will go away, assumed; the rates empirical |")
edit(PLAN, "The table is in [REVIEW-ROUND2](evidence/REVIEW-ROUND2.md#what-was-taken).\n",
     "The table is in [REVIEW-ROUND2](evidence/REVIEW-ROUND2.md#what-was-taken).\n\n**The reviews of RF7.** "
     "`Becoming.ReadStages`, first `Becoming.Concealment`, had a cross-model review (seven findings) with a re-check, a "
     "review through four lenses whose 50 points were each verified against the Lean (42 confirmed, 8 refuted), a "
     "re-check of the rebuilt module (nine points, all taken, confirmed) and a cold read of its texts, by the "
     "cross-model reader (five points) and through three lenses with each point verified (75 confirmed, 5 refuted), "
     "with the cross-model reader's re-check of what was taken (four taken in part, three new points, then all seven "
     "taken correctly), a final check through three lenses (42 confirmed, 8 refuted), the cross-model reader's "
     "re-check of how the final check's points were taken (four points still wanting) and a second final check "
     "through three lenses (27 confirmed, 1 refuted), then the reader's re-check of that round (one of its points "
     "taken only in part) and a third check through three lenses scoped to the round's changes (9 confirmed, 2 "
     "refuted), and the reader's re-check of the round that took those (one point, on the study's account of the "
     "re-checks) with a fourth check through two lenses so scoped (4 confirmed, 5 refuted); every confirmed finding "
     "was taken "
     "([REVIEW-ROUND2](evidence/REVIEW-ROUND2.md#the-review-of-rf7s-module)).\n")
edit(PLAN, "then RF6.1 (landed, §4.6); then RF-M's assistance and preference cases, an institution's rule of reading with "
           "members' acts, and RF7.",
     "then RF6.1 (landed, §4.6); then RF7 (landed, §4.6); then RF-M's assistance and preference cases and an institution's "
     "rule of reading with members' acts.")

regions = ROOT / 'theories/becoming/results/data/regions.json'
d = json.loads(regions.read_text(encoding='utf-8'))
assert 'when-complying-when-read-is-best' not in d['records'] and 'Becoming.ReadStages' not in d['modules']
d['records']['when-complying-when-read-is-best'] = {
    'region': 'knowing', 'base': 'general', 'note': 'ReadStages RF7: when complying when read and acting by its own law '
                                                    'when not is best, in two stages; the exits; drawing afresh'}
d['modules']['Becoming.ReadStages'] = {'region': 'knowing', 'base': 'general',
                                       'note': 'RF7 when complying when read and acting by its own law when not is '
                                               'best (03 §11)'}
d['records'] = dict(sorted(d['records'].items()))
d['modules'] = dict(sorted(d['modules'].items()))
regions.write_text(json.dumps(d, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('integrated: Becoming.ReadStages joined (root import and L1 bullet, checker core list and scope, README rows EN '
      'and ZH); 03 §11, its opening and Open; 07 §9; 08 §8; the overview; the dossier; RF\'s plan; regions')
