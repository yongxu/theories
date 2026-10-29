#!/usr/bin/env python3
"""RF round 2, first landing: join Becoming.ReadingLoop and Becoming.ReflexivePrediction to the core as leaves at L1,
and put the texts in place. Copies the two modules (no landed module changes); adds them to the checker's core list
(ReadingLoop after Becoming.NarrowingRuns, ReflexivePrediction after Becoming.Keeping) and scope text; imports them in
the root module, each with an L1 bullet; adds the package README rows (EN after NarrowingRuns' and Keeping's rows, ZH
after LumpedSeeking's); inserts 03 §12 before "What this chapter does not show" and brings 03's bases sentence and
Open bullet to it; adds 08 §8's known-results bullet; adds the overview's §3 paragraph; brings AJ5's scope box in the
alignment dossier to it; adds the four records and two modules to regions.json. Every backticked name the texts cite
from the two modules is checked against the scratch build's axiom audits, so a renamed declaration fails here. Each
edit is asserted to apply exactly once. Becoming.OpenedCorrection stays in the kit.
usage (from the checkout root of the landing worktree, clean): python3 -B <kit>/round2/integrate_rf2.py"""
import json
import re
import shutil
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
TREE = HERE / 'tree/Becoming'
MODULES = ('ReadingLoop', 'ReflexivePrediction')
AUDITS = [HERE / f'tree/.build/Becoming{m}AxiomAudit.lean' for m in MODULES]
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CH = ROOT / 'theories/becoming/chapters'
NAMES = set()
for audit in AUDITS:
    NAMES |= set(re.findall(r'^#print axioms Becoming\.(\S+)$', audit.read_text(encoding='utf-8'), re.M))


def cited(text):
    """Every backticked name of the two modules the text cites is one of their declarations."""
    found = set(re.findall(r'`((?:ReadingLoop|ReflexivePrediction)\.[A-Za-z_.\']+)`', text))
    missing = sorted(n for n in found if n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


# the new modules
for name in MODULES:
    target = PKG / f'Becoming/{name}.lean'
    assert not target.exists(), target
    shutil.copyfile(TREE / f'{name}.lean', target)

# the checker: core list and scope text
checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.Narrowing", "Becoming.NarrowingRuns",',
     '"Becoming.Narrowing", "Becoming.NarrowingRuns", "Becoming.ReadingLoop",')
edit(checker, '"Becoming.Viability", "Becoming.Keeping",',
     '"Becoming.Viability", "Becoming.Keeping", "Becoming.ReflexivePrediction",')
edit(checker, '''    "NarrowingRuns: the answer is the greatest safe answer of the belief narrowed by After on the "''',
     '''    "ReadingLoop: a region kept along every reach is closed; with a reading its update keeps, a policy keeps a "
    "task and goes on exactly where each state's act is good and enabled for its reading; the worlds possible after "
    "a history are the least reading kept by recording, and a policy acting from its history keeps a task exactly "
    "where its act is safe at every world possible after each history it generates; two worlds give one formation "
    "one course exactly as long as they answer alike what it does, and where every answer telling them apart breaks "
    "a task, keeping it is never telling them apart; a formation keeping candidate laws keeps those fitting its own "
    "course's answers and can rest on a model its course never refutes; formations related by a relation their steps "
    "keep act and sense alike. "
    "NarrowingRuns: the answer is the greatest safe answer of the belief narrowed by After on the "''')
edit(checker, '''    "Recurrence: with no premise and no decidability, a list holding the first l.length + 1 values "''',
     '''    "ReflexivePrediction: a published prediction read by the response is right exactly where the response leaves "
    "it; none is right where the response moves every value, whatever the predictor reads; on a chain of n + 1 "
    "values under a response keeping them and their order, repeated publication from the bottom is the least right "
    "prediction by step n. "
    "Recurrence: with no premise and no decidability, a list holding the first l.length + 1 values "''')

# the root module: imports, and the new bullets
root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.NarrowingRuns\n', 'import Becoming.NarrowingRuns\nimport Becoming.ReadingLoop\n')
edit(root, 'import Becoming.Keeping\n', 'import Becoming.Keeping\nimport Becoming.ReflexivePrediction\n')
RL_BULLET = """* `Becoming.ReadingLoop` (L1): the reading loop, sensing, predicting, choosing, acting and revising as
  one blanketed law. A region kept along every reach is closed (`ReadingLoop.kept_iff_closed`); with a
  reading its update keeps, a policy keeps a task and goes on exactly where each state's act is good and
  enabled for its reading (`ReadingLoop.keeps_continues_iff`); the worlds possible after a history are
  the least reading kept by recording (`ReadingLoop.possible_least`), and a policy acting from its
  history keeps a task exactly where its act is safe at every world possible after each history it
  generates (`ReadingLoop.history_keeps_iff`); two worlds give one formation one course exactly as
  long as they answer alike what it does (`ReadingLoop.sensed_alike_iff`), and where every answer
  telling them apart breaks a task, keeping it is never telling them apart
  (`ReadingLoop.alike_of_kept`); a formation keeping candidate laws keeps those fitting its course's
  answers (`ReadingLoop.Loop.kept_iff`) and rests on a model its course never refutes
  (`ReadingLoop.Loop.rests_of_unrefuted`); formations related by a relation their steps keep act alike
  (`ReadingLoop.observed_alike`); witnesses (`ReadingLoop.Untested.floor_forgoes`,
  `ReadingLoop.Untested.model_or_order`). A leaf (board item RF).
"""
RP_BULLET = """* `Becoming.ReflexivePrediction` (L1): a prediction read by what it predicts. Right exactly where the
  response leaves it (`ReflexivePrediction.Right`); none right where the response moves every value,
  whatever the predictor reads (`ReflexivePrediction.no_predictor_right`); on a chain of `n + 1` values
  under a response keeping them and their order, repeated publication from the bottom is the least right
  prediction by step `n` (`ReflexivePrediction.bottom_rests`); witnesses with two right predictions,
  none and one (`ReflexivePrediction.ThresholdResponse.reached_by_start`,
  `ReflexivePrediction.Negating.alternates`, `ReflexivePrediction.Reflecting.middle_right`). A leaf
  (board item RF).
"""


def bullet_after(path, name, bullet):
    lines = path.read_text(encoding='utf-8').split('\n')
    at = [i for i, line in enumerate(lines) if line.startswith(f'* `{name}` (L')]
    assert len(at) == 1, (name, at)
    nxt = next(i for i in range(at[0] + 1, len(lines)) if lines[i].startswith('* `Becoming.'))
    lines[nxt:nxt] = cited(bullet).rstrip('\n').split('\n')
    path.write_text('\n'.join(lines), encoding='utf-8')


bullet_after(root, 'Becoming.NarrowingRuns', RL_BULLET)
bullet_after(root, 'Becoming.Keeping', RP_BULLET)


def readme_row(path, after, row, absent):
    lines = path.read_text(encoding='utf-8').split('\n')
    at = [i for i, line in enumerate(lines) if line.startswith(after)]
    assert len(at) == 1, (after, at)
    assert not any(absent in line for line in lines), absent
    lines[at[0] + 1:at[0] + 1] = [cited(row)]
    path.write_text('\n'.join(lines), encoding='utf-8')


RL_EN = ("| L1 | [`Becoming.ReadingLoop`](Becoming/ReadingLoop.lean) | the reading loop (no premise; equality of values "
         "decided where stated): a reading kept by its update and the good and enabled acts for it "
         "(`ReadingLoop.keeps_continues_iff`), the worlds possible after a history (`ReadingLoop.possible_least`, "
         "`ReadingLoop.history_keeps_iff`), two worlds and one formation (`ReadingLoop.sensed_alike_iff`, "
         "`ReadingLoop.alike_of_kept`), a formation keeping candidate laws (`ReadingLoop.Loop.kept_iff`, "
         "`ReadingLoop.Loop.rests_of_unrefuted`), acts alike from a model or an order (`ReadingLoop.observed_alike`, "
         "`ReadingLoop.Untested.model_or_order`) |")
RP_EN = ("| L1 | [`Becoming.ReflexivePrediction`](Becoming/ReflexivePrediction.lean) | a prediction read by what it "
         "predicts (no premise): right exactly where the response leaves it, none where it moves every value "
         "(`ReflexivePrediction.no_predictor_right`), the least right prediction reached from the bottom of a chain "
         "under a response keeping the order (`ReflexivePrediction.bottom_rests`) |")
RL_ZH = ("| L1 | [`Becoming.ReadingLoop`](Becoming/ReadingLoop.lean) | 读之环（不加前提；所言处所感之值之相等可判定）：更新所守之读与于其善且可行之行"
         "（`ReadingLoop.keeps_continues_iff`），历后可能之诸世（`ReadingLoop.possible_least`、`ReadingLoop.history_keeps_iff`），"
         "二世一形成（`ReadingLoop.sensed_alike_iff`、`ReadingLoop.alike_of_kept`），守候选律之形成（`ReadingLoop.Loop.kept_iff`、"
         "`ReadingLoop.Loop.rests_of_unrefuted`），出于模型或出于序之同行（`ReadingLoop.observed_alike`、"
         "`ReadingLoop.Untested.model_or_order`） |")
RP_ZH = ("| L1 | [`Becoming.ReflexivePrediction`](Becoming/ReflexivePrediction.lean) | 为其所预言者所读之预言（不加前提）：应不移处为是，"
         "应移每一值处无是者（`ReflexivePrediction.no_predictor_right`），守序之应下自链之底达最小之是者（`ReflexivePrediction.bottom_rests`） |")
readme_row(PKG / 'README.md', '| L1 | [`Becoming.NarrowingRuns`]', RL_EN, '[`Becoming.ReadingLoop`]')
readme_row(PKG / 'README.md', '| L1 | [`Becoming.Keeping`]', RP_EN, '[`Becoming.ReflexivePrediction`]')
readme_row(PKG / 'README.zh.md', '| L1 | [`Becoming.LumpedSeeking`]', RL_ZH, '[`Becoming.ReadingLoop`]')
readme_row(PKG / 'README.zh.md', '| L1 | [`Becoming.ReadingLoop`]', RP_ZH, '[`Becoming.ReflexivePrediction`]')

# 03: section 12, the bases sentence and the Open bullet
ch3 = CH / '03-KNOWING.md'
edit(ch3, '<a id="does-not-show"></a>\n## What this chapter does not show',
     (HERE / 's12.txt').read_text(encoding='utf-8').rstrip('\n') +
     '\n\n<a id="does-not-show"></a>\n## What this chapter does not show')
edit(ch3, "testing within the net, 文 and what choices show of an order ([§11](#r-what-choices-show-of-an-order)) are on "
          "the root's grammar.",
     "testing within the net, 文, what choices show of an order ([§11](#r-what-choices-show-of-an-order)) and a region "
     "kept along every reach ([§12](#r-a-reading-kept-by-its-update)) are on the root's grammar.")
edit(ch3, "- Formations that read, beyond what their acts show ([§11](#what-the-acts-show)): a formation's reading kept "
          "by its own update, composed with the good regulator's adequacy ([§9](#r-when-to-inquire-and-when-to-respond)); "
          "revision that opens an executable correction; a prediction negated by the response it predicts; one finite "
          "mechanism in which prediction, selection, revision and intervention act together; disclosure or concealment "
          "when read, in two stages.",
     "- Formations that read, beyond [§11](#what-the-acts-show) and [§12](#the-reading-loop): a condition for a policy "
     "acting from its history to exist, tying histories to the task's futures; revision that opens an executable "
     "correction, as a reachable step of a formation's own course; a helper's acts within the loop, a principal's order "
     "as state those acts can move, and an institution revising its rule of reading; disclosure or concealment when "
     "read, in two stages.")

# 08: known results
ch8 = CH / '08-METHOD.md'
edit(ch8, "readers reading readers ([05 §8](05-COLLECTIVES.md#r-readers-reading-readers)) is the deterministic form of an "
          "information cascade (Bikhchandani, Hirshleifer and Welch 1992; Banerjee 1992). Each law is near-definitional "
          "or a witness; what they add is their place in one account.\n",
     "readers reading readers ([05 §8](05-COLLECTIVES.md#r-readers-reading-readers)) is the deterministic form of an "
     "information cascade (Bikhchandani, Hirshleifer and Welch 1992; Banerjee 1992). Each law is near-definitional "
     "or a witness; what they add is their place in one account.\n"
     "- The reading loop ([03 §12](03-KNOWING.md#the-reading-loop)): a reading kept by its update is a safety "
     "composition related to possibilistic interpretations of regulation (Virgo, Biehl, Baltieri and Capucci 2025), not "
     "the good regulator theorem (Conant and Ashby 1970); what a course chosen through its model does not test is a "
     "deterministic case related to self-confirming equilibrium (Fudenberg and Levine 1993) and incomplete learning "
     "(Rothschild 1974), with a two-run obstruction beside safe exploration; acts alike from a model or an order "
     "illustrates the ambiguity between beliefs and preferences (Armstrong and Mindermann 2018; Reddy, Dragan and "
     "Levine 2018); a prediction read by what it predicts reaches Tarski's least fixed point (1955) on a finite chain "
     "within its length, beside the existence of a correct public prediction (Grunberg and Modigliani 1954; Simon 1954). "
     "The laws are near-definitional, general laws of blanketed laws, or witnesses; what they add is their place in one "
     "account.\n")

# the overview: section 3
over = ROOT / 'theories/becoming/THE-THEORY-OF-BECOMING.md'
edit(over, "installation, intention and incentive are not represented [AI reading] ([what choices show]"
           "(chapters/03-KNOWING.md#r-what-choices-show-of-an-order), [what readings fix]"
           "(chapters/03-KNOWING.md#r-what-readings-fix-of-the-unread)).\n",
     "installation, intention and incentive are not represented [AI reading] ([what choices show]"
     "(chapters/03-KNOWING.md#r-what-choices-show-of-an-order), [what readings fix]"
     "(chapters/03-KNOWING.md#r-what-readings-fix-of-the-unread)).\n\n"
     "A formation that senses, predicts, chooses, acts and revises is one law, its internal part reading what goes on "
     "through what it senses. Proved for every type: two worlds give one formation one course exactly as long as they "
     "answer alike what it does; where every answer telling two worlds apart breaks a task, a formation keeping the "
     "task never tells them apart; a formation keeping candidate laws keeps those its own course's answers fit, and can "
     "rest on a model its course never refutes; with the state its history, a policy keeps a task exactly where its "
     "act is safe at every world possible after each history it generates; and a published prediction read by the "
     "response is right exactly where the response leaves it, the least right one reached from the bottom of a finite "
     "chain under a response keeping the order. Read as self-confirmation, the trade between keeping a task and "
     "learning, why a helper must read more than acts, and self-fulfilling prediction [AI reading] ([the reading loop]"
     "(chapters/03-KNOWING.md#the-reading-loop)).\n")

# AJ5's scope box in the alignment dossier
dossier = ROOT / 'theories/becoming/review/ALIGNMENT.md'
edit(dossier, "which the theory reaches only in RF's reading of what strict choices show (below).",
     "which the theory reaches in RF's readings of what strict choices show and of what acts cannot tell of a model "
     "and an order (below).")
edit(dossier, "installation, intention, anticipation and incentive are not represented, and this dossier quotes none of "
              "them yet.",
     "installation, intention, anticipation and incentive are not represented, and this dossier quotes none of them "
     "yet. Round 2's first landing, the reading loop ([03 §12](../chapters/03-KNOWING.md#the-reading-loop)), adds a "
     "formation's reading kept by its own update, what a course chosen through its model does not test (where only "
     "answers breaking a task tell two worlds apart, no formation keeping the task learns which holds), that an "
     "unresolved model and a reversed ranking can act alike, and a prediction read by what it predicts; a helper's acts "
     "within the law, preference as state and the incentive to conceal are later items.")

# regions
regions = ROOT / 'theories/becoming/results/data/regions.json'
d = json.loads(regions.read_text(encoding='utf-8'))
for rid, note in (
        ('a-reading-kept-by-its-update', 'ReadingLoop RF3: a reading kept by its update, good and enabled acts for it; '
                                         'the worlds possible after a history and a history policy'),
        ('what-a-course-chosen-through-its-model-does-not-test', 'ReadingLoop RF-M: two worlds and one formation, a '
                                                                 'formation keeping candidate laws, keeping a task as '
                                                                 'not telling worlds apart'),
        ('acts-alike-from-a-model-or-from-an-order', 'ReadingLoop RF-M: formations related by a relation their steps keep '
                                                     'act alike; an unresolved model and a reversed ranking'),
        ('a-prediction-read-by-what-it-predicts', 'ReflexivePrediction RF6.3: right where the response leaves it; the '
                                                  'least right prediction on a chain')):
    assert rid not in d['records'], rid
    d['records'][rid] = {'region': 'knowing', 'base': 'general', 'note': note}
for mod, note in (('Becoming.ReadingLoop', 'RF3 and RF-M the reading loop (03 §12)'),
                  ('Becoming.ReflexivePrediction', 'RF6.3 a prediction read by what it predicts (03 §12)')):
    assert mod not in d['modules'], mod
    d['modules'][mod] = {'region': 'knowing', 'base': 'general', 'note': note}
d['records'] = dict(sorted(d['records'].items()))
d['modules'] = dict(sorted(d['modules'].items()))
regions.write_text(json.dumps(d, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('integrated: Becoming.ReadingLoop and Becoming.ReflexivePrediction joined (root imports and L1 bullets, checker core '
      'list and scope, README rows EN and ZH); 03 §12, bases and Open; 08 §8 bullet; overview §3; the dossier\'s scope box; '
      'regions; no landed module changed')
