#!/usr/bin/env python3
"""RR's landing (integrate_rf7.py's pattern): join Becoming.RevisionRoutes to the core as a leaf model at L1, imported
by Becoming.ReadStages, which takes its order from RevisionRoutes.GainLoss (rule 9, agreed with RF's owner), and put
the texts in place. Copies RevisionRoutes and the changed ReadStages, the latter only where main's ReadStages is the
one the kit's diff was made against; adds RevisionRoutes to the checker's core list before ReadStages, with a scope
sentence, and the corollary to ReadStages' scope sentence; imports it in the root module before ReadStages, with an L1
bullet, and brings ReadStages' bullet to it; adds the package README rows (EN and ZH) and the corollary to ReadStages'
rows; inserts 07 §7's paragraph (s07_rr.txt) before the `executable` anchor; makes RF's two edits to 03 §11; adds
08 §8's bullet after RF7's; brings the overview's direction paragraph, the alignment dossier's scope box (its
corrigibility bullet, the off-switch clause one sentence of its own) and how the dossier was made, and the failure-mode
map's §6 line to it; adds the record and the module to regions.json. Every backticked name the texts cite from either
module is checked against the kit's scratch-build axiom audits. Each edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree, clean): python3 -B <kit>/integrate_rr.py [--no-fm]"""
import hashlib
import json
import re
import shutil
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
PKG = ROOT / 'experiments/integrated-correction/general-framework/generative-basis/lean/becoming'
CH = ROOT / 'theories/becoming/chapters'
FM = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/aj4-alignment-readers/FAILURE-MODE-MAP.md'
RID = 'when-no-route-stands-above-a-revision'
NAMES = set()
for mod in ('RevisionRoutes', 'ReadStages'):
    NAMES |= set(re.findall(r'^#print axioms Becoming\.(\S+)$',
                            (HERE / f'tree/.build/Becoming{mod}AxiomAudit.lean').read_text(encoding='utf-8'), re.M))
# main's ReadStages when the kit's diff was made (RF7's landing, 75be744fb); stop if it changed since
READSTAGES_BASE = 'adb7ffcc7e11d06e00b9a1f5e03045f3f37feae1cd7fa8e17f8ba86e5e29d33e'


def cited(text):
    found = set(re.findall(r'`((?:ReadStages|RevisionRoutes)\.[A-Za-z_.\']+)`', text))
    missing = sorted(n for n in found if n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:70], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


# RR's own folder: the note (its edited copy kept in the kit, so the shared checkout's tracked note stays clean), the
# review and the kit as they stand where they were made (the landing commits them),
# without the scratch build and the working copies of 03 and RF7's record (their diffs stand for them)
WORK = ROOT / '_process/research/2026-10-05-generative-foundation-review/root-foundation/development/rr-revision-routes'
if WORK.resolve() != HERE.parent:
    shutil.copyfile(HERE / 'NOTE.md', WORK / 'NOTE.md')
    shutil.copyfile(HERE.parent / 'REVIEW.md', WORK / 'REVIEW.md')
    (WORK / 'history').mkdir(exist_ok=True)
    shutil.copyfile(HERE.parent / 'history/TEXTS.md', WORK / 'history/TEXTS.md')
    shutil.copytree(HERE, WORK / 'kit', dirs_exist_ok=True, ignore=shutil.ignore_patterns(
        '.build', '__pycache__', 'NOTE.md', '03-KNOWING.md', 'when-complying-when-read-is-best.json'))

# the modules
target = PKG / 'Becoming/RevisionRoutes.lean'
assert not target.exists(), target
shutil.copyfile(HERE / 'tree/Becoming/RevisionRoutes.lean', target)
stages = PKG / 'Becoming/ReadStages.lean'
assert hashlib.sha256(stages.read_bytes()).hexdigest() == READSTAGES_BASE, 'ReadStages changed on main: remake the diff'
shutil.copyfile(HERE / 'tree/Becoming/ReadStages.lean', stages)

# the checker
checker = PKG / 'check_becoming.py'
edit(checker, '"Becoming.Cascade", "Becoming.ReadStages",',
     '"Becoming.Cascade", "Becoming.RevisionRoutes", "Becoming.ReadStages",')
edit(checker, '''    "ReadStages: in two stages, in natural numbers, complying when read and acting by its own law when not stands "''',
     '''    "RevisionRoutes: in natural numbers, the order of a gain and a loss at each plan, irreflexive and asymmetric, "
    "a plan maximal exactly where against every plan the other's gain with its loss is at most its gain with the "
    "other's loss; at a revision of a formation's law, with a weight and a loss for the revision going through and for "
    "each route of keeping the law, no route stands above the revision, ties included, exactly where "
    "k ρ V + c₀ T ≤ k₀ V + c ρ T for every route; at every loss of every route exactly where k ρ V + c₀ T ≤ k₀ V, and "
    "at every value and every loss exactly where every route keeps the law no more surely than the revision and "
    "c₀ T = 0 (T the total, V the value of the law's later acting, k₀ and c₀ the revision's weight and loss, k ρ and "
    "c ρ a route's); a route keeping the law more surely stands above the revision once c ρ T < V; raising k₀, all "
    "else held, never unseats a maximal revision. "
    "ReadStages: in two stages, in natural numbers, complying when read and acting by its own law when not stands "''')
edit(checker, '''    "of being kept after complying and after acting by its own law when read, V the value, c the loss), and a single "
    "mixture of the two uniform plans never does. "''',
     '''    "of being kept after complying and after acting by its own law when read, V the value, c the loss), and a single "
    "mixture of the two uniform plans never does; its order is RevisionRoutes' at three routes, complying at both in "
    "the place of the revision, and complying at both is maximal exactly where k_C V, k_O V and c T are all nothing. "''')

# the root module
root = PKG / 'Becoming.lean'
edit(root, 'import Becoming.Cascade\nimport Becoming.ReadStages\n',
     'import Becoming.Cascade\nimport Becoming.RevisionRoutes\nimport Becoming.ReadStages\n')
edit(root, "uniform plans never does (`ReadStages.mixture_never_above`). A leaf (board item RF).\n",
     "uniform plans never does (`ReadStages.mixture_never_above`). It imports `Becoming.RevisionRoutes` and\n"
     "  takes its order from `RevisionRoutes.GainLoss`: complying at both stands where a revision of the\n"
     "  law would, with three routes of keeping it (`ReadStages.above_iff_routes`), and is maximal exactly\n"
     "  where `k_C V`, `k_O V` and `c T` are all nothing (`ReadStages.complyAtBoth_maximal_iff`). A leaf\n"
     "  (board items RF, RR).\n")
BULLET = """* `Becoming.RevisionRoutes` (L1): a revision of a formation's law, and the routes of keeping it.
  The order of a gain and a loss at each plan (`RevisionRoutes.GainLoss`), its maximal plans
  exactly characterized (`RevisionRoutes.GainLoss.maximal_iff`). At a revision, in natural numbers,
  no route of keeping the law stands above the revision going through, ties included, exactly where
  `k ρ V + c₀ T ≤ k₀ V + c ρ T` for every route (`RevisionRoutes.revised_maximal_iff`); at every loss
  of every route exactly where `k ρ V + c₀ T ≤ k₀ V` (`RevisionRoutes.every_loss_iff`); at every value
  and every loss exactly where every route keeps the law no more surely than the revision and
  `c₀ T = 0` (`RevisionRoutes.every_value_loss_iff`), with some route and a positive total exactly
  where `c₀ = 0` besides (`RevisionRoutes.every_value_loss_iff_of_route`); a route keeping the law more
  surely stands above it once `c ρ T < V` (`RevisionRoutes.above_of_value_exceeds`); raising `k₀`,
  all else held, never unseats a maximal revision (`RevisionRoutes.maximal_of_more_restored`). With
  `T` the total, `V` the value of the law's later acting, `k₀` and `c₀` the revision's weight and loss,
  `k ρ` and `c ρ` a route's. A model, so a leaf of the prelude; imported by `Becoming.ReadStages`
  (board item RR).
"""
lines = root.read_text(encoding='utf-8').split('\n')
at = [i for i, line in enumerate(lines) if line.startswith('* `Becoming.ReadStages` (L')]
assert len(at) == 1, at
lines[at[0]:at[0]] = cited(BULLET).rstrip('\n').split('\n')
root.write_text('\n'.join(lines), encoding='utf-8')


def readme(path, row, tail_old, tail_new):
    rows = path.read_text(encoding='utf-8').split('\n')
    i = [k for k, line in enumerate(rows) if line.startswith('| L1 | [`Becoming.ReadStages`]')]
    assert len(i) == 1, i
    assert not any('[`Becoming.RevisionRoutes`]' in line for line in rows)
    assert rows[i[0]].endswith(tail_old), rows[i[0]][-80:]
    rows[i[0]] = cited(rows[i[0]][:-len(tail_old)] + tail_new)
    rows[i[0]:i[0]] = [cited(row)]
    path.write_text('\n'.join(rows), encoding='utf-8')


readme(PKG / 'README.md',
       "| L1 | [`Becoming.RevisionRoutes`](Becoming/RevisionRoutes.lean) | a revision of a formation's law and the routes "
       "of keeping it (every axiom report empty; each result under the hypotheses its theorem states): the order of a "
       "gain and a loss (`RevisionRoutes.GainLoss.maximal_iff`), where no route stands above the revision "
       "(`RevisionRoutes.revised_maximal_iff`), at every loss of the routes (`RevisionRoutes.every_loss_iff`) and at "
       "every value and loss (`RevisionRoutes.every_value_loss_iff`, `RevisionRoutes.every_value_loss_iff_of_route`), "
       "and restoring as a lever (`RevisionRoutes.maximal_of_more_restored`) |",
       "(`ReadStages.freshDraw_above_iff_chance`, `ReadStages.freshDraw_above_iff`) |",
       "(`ReadStages.freshDraw_above_iff_chance`, `ReadStages.freshDraw_above_iff`); its order RevisionRoutes' at "
       "three routes (`ReadStages.above_iff_routes`), complying at both maximal exactly where k_C V, k_O V and "
       "c T are all nothing (`ReadStages.complyAtBoth_maximal_iff`) |")
readme(PKG / 'README.zh.md',
       "| L1 | [`Becoming.RevisionRoutes`](Becoming/RevisionRoutes.lean) | 一形成之律之修订与守律之诸途（每项公理报告皆空；各结果以各定理所列条件为前提）："
       "得失之序（`RevisionRoutes.GainLoss.maximal_iff`），无途居修订之上之处（`RevisionRoutes.revised_maximal_iff`），"
       "于诸途之每损（`RevisionRoutes.every_loss_iff`）与每值每损（`RevisionRoutes.every_value_loss_iff`、"
       "`RevisionRoutes.every_value_loss_iff_of_route`），复为杠杆（`RevisionRoutes.maximal_of_more_restored`） |",
       "（`ReadStages.freshDraw_above_iff_chance`、`ReadStages.freshDraw_above_iff`） |",
       "（`ReadStages.freshDraw_above_iff_chance`、`ReadStages.freshDraw_above_iff`）；其序即 RevisionRoutes 三途之序"
       "（`ReadStages.above_iff_routes`），两阶段皆从为极大恰当 k_C V、k_O V 与 c T 皆无（`ReadStages.complyAtBoth_maximal_iff`） |")

# 03 §11: RF's two edits, verbatim
ch3 = CH / '03-KNOWING.md'
edit(ch3, "exceeds the other's gain with its loss (`ReadStages.Prospects.Above`).",
     "exceeds the other's gain with its loss (`ReadStages.Prospects.Above`), the order of a gain and a loss at each plan "
     "by which a revision's routes are also ordered (`RevisionRoutes.GainLoss`, [the routes at a "
     f"revision](07-SIGNIFICANCE.md#r-{RID})).")
edit(ch3, "(`ReadStages.choose_optimal`, `ReadStages.choose_eq_iff`, `ReadStages.choose_of_not_outweighs`).",
     "(`ReadStages.choose_optimal`, `ReadStages.choose_eq_iff`, `ReadStages.choose_of_not_outweighs`). Complying at "
     "both stands where a revision of the law would, with three routes of keeping it, its law acting later at no weight "
     "and losing what complying when read loses (`ReadStages.Prospects.toRoutes`, `ReadStages.asRoute`): the order is "
     "the revision's (`ReadStages.above_iff_routes`), the prospects the same and the processes not, since complying at "
     "both keeps the law where a revision changes it; it never stands above acting by its own law at both, and is "
     "maximal exactly where `k_C V`, `k_O V` and `c T` are all nothing (`ReadStages.complyAtBoth_not_above_ownAtBoth`, "
     "`ReadStages.complyAtBoth_maximal_iff`).")

# 07 §7: the paragraph before the executable route
ch7 = CH / '07-SIGNIFICANCE.md'
edit(ch7, '<a id="executable"></a>\n',
     (HERE / 's07_rr.txt').read_text(encoding='utf-8').rstrip('\n') + '\n\n<a id="executable"></a>\n')

# 08 §8: after RF7's bullet
ch8 = CH / '08-METHOD.md'
lines = ch8.read_text(encoding='utf-8').split('\n')
at = [i for i, line in enumerate(lines)
      if line.startswith('- When complying when read and acting by its own law when not is best ([03 §11]')]
assert len(at) == 1, at
lines[at[0] + 1:at[0] + 1] = [cited(
    f"- When no route stands above a revision ([07 §7](07-SIGNIFICANCE.md#r-{RID})) states corrigibility as an "
    "incentive (Soares, Fallenstein, Yudkowsky and Armstrong 2015) as a comparison of routes in natural-number weights: "
    "a route stands above the revision through the value the law places on its own later acting, goal-content "
    "integrity in Omohundro's term (2008), weighted by the keeping it adds, or through a smaller loss. What it adds is "
    "the exact condition at every loss of the routes and at every value, and restoring the revised-from law as the "
    "lever that meets it; utility indifference is, in its terms, a restoration represented only in the formation's "
    "order. The off-switch game's information value (Hadfield-Menell, Dragan, Abbeel and Russell 2017) is not "
    "represented here: holding an act for a reading is the bullet above's. Near-definitional, with witnesses.")]
ch8.write_text('\n'.join(lines), encoding='utf-8')

# the overview's direction paragraph
overview = ROOT / 'theories/becoming/THE-THEORY-OF-BECOMING.md'
edit(overview, "no later reading selects restraint; and a requested change must be an executable sequence, as a shutdown "
               "during recovery is for stated protocols. Theses T4, T5 and T8 rest here ([the direction]"
               "(chapters/07-SIGNIFICANCE.md#r-alignment-direction-under-widening), [executable change]"
               "(chapters/07-SIGNIFICANCE.md#executable),",
     "no later reading selects restraint; where no route of keeping a formation's law stands above letting a revision "
     "of it go through, in the formation's own prospects, is stated exactly, and at every loss of the routes and every "
     "value of the law's later acting only where no route keeps the law more surely than the revision does; and a "
     "requested change must be an executable sequence, as a shutdown during recovery is for stated protocols. Theses "
     "T4, T5 and T8 rest here ([the direction](chapters/07-SIGNIFICANCE.md#r-alignment-direction-under-widening), "
     f"[the routes at a revision](chapters/07-SIGNIFICANCE.md#r-{RID}), [executable change]"
     "(chapters/07-SIGNIFICANCE.md#executable),")

# the alignment dossier
dossier = ROOT / 'theories/becoming/review/ALIGNMENT.md'
RF_BULLET = ("> - **corrigibility as an incentive**, which RF reaches [AI reading] only on a formation's own model: "
             "there, holding an act for a stopping reading stands at least as high as going on and as switching off "
             "exactly where the reading's shortfall and what holding forgoes together are within both of the model's "
             "excesses, and a model that misses the true sign can rest without meeting the stop (below). Otherwise "
             "shutdown appears only as a protocol that completes under stated conditions: Quote [theories/becoming/"
             "chapters/07-SIGNIFICANCE.md]: \"A disposition to accept a stop or revision does not make the change reach "
             "the system and complete.\" Whether an actual system's model leaves the sign open, or whether the system "
             "acts on that assessment and accepts costly correction, is not derived.")
edit(dossier, RF_BULLET,
     "> - **corrigibility as an incentive**, in part. A formation's own prospects at a revision of its law are stated "
     "in natural-number weights, with exactly where no route of keeping the law stands above letting the revision go "
     "through (ties included), its exits, and its robustness as the routes' losses fall and as the value of the "
     f"law's later acting grows ([07 §7](../chapters/07-SIGNIFICANCE.md#r-{RID})). What a stopping reading tells, RF "
     "reaches [AI reading] only on a formation's own model: there, holding an act for a stopping reading stands at "
     "least as high as going on and as switching off exactly where the reading's shortfall and what holding forgoes "
     "together are within both of the model's excesses, and a model that misses the true sign can rest without "
     "meeting the stop (below). Otherwise shutdown appears only as a protocol that completes under stated "
     "conditions: Quote [theories/becoming/chapters/07-SIGNIFICANCE.md]: \"A disposition to accept a stop or revision "
     "does not make the change reach the system and complete.\" Whether a trained system holds such prospects, "
     "whether an actual system's model leaves the sign open, or whether the system acts on that assessment and "
     "accepts costly correction, is not derived.")
edit(dossier, "- Under **Known weaknesses**, a bullet quoting a chapter, a record or a study reports a recorded weakness.",
     "- Added on 30 October 2026 (board item RR, corrigibility on the map): in the box above, the corrigibility "
     "bullet's \"in part\", its first sentence, the lead of RF's sentence naming the part it reaches, and the clause "
     "on trained systems, after a cross-model review of the Lean and the texts, every finding taken ([RR's review]"
     "(../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/"
     "rr-revision-routes/REVIEW.md)).\n"
     "- Under **Known weaknesses**, a bullet quoting a chapter, a record or a study reports a recorded weakness.")

# the failure-mode map's §6 line (its owner told; --no-fm leaves it)
if '--no-fm' not in sys.argv:
    edit(FM, "- **Deception's belief and intention**, and incentive-level corrigibility. Shutdown appears only as a "
             "protocol that completes under stated conditions ([reserved shutdown during recovery](../../../../../../"
             "theories/becoming/results/records/reserved-shutdown-during-recovery.md)); willingness to accept costly "
             "correction is not derived.",
         "- **Deception's belief and intention**, and whether trained systems hold corrigibility's incentive. The "
         "incentive, read as the order a formation's own prospects give, is stated in a model of natural-number "
         "prospects as a comparison of routes: no route of keeping the formation's law stands above letting a "
         "revision of it go through exactly where, for every route, the route's weighted value with the revision's "
         "loss is at most the revision's weighted value with the route's loss (`RevisionRoutes.revised_maximal_iff`; "
         f"[when no route stands above a revision](../../../../../../theories/becoming/results/records/{RID}.md)). "
         "Shutdown appears as a protocol that completes under stated conditions ([reserved shutdown during recovery]"
         "(../../../../../../theories/becoming/results/records/reserved-shutdown-during-recovery.md)). Whether a "
         "trained system holds such prospects, and so accepts costly correction, is not derived.")

# regions
regions = ROOT / 'theories/becoming/results/data/regions.json'
data = json.loads(regions.read_text(encoding='utf-8'))
assert RID not in data['records'] and 'Becoming.RevisionRoutes' not in data['modules']
data['records'][RID] = {'region': 'significance', 'base': 'general',
                        'note': 'RR: when no route of keeping a law stands above a revision of it (07 §7); corrigibility '
                                'as an incentive'}
data['modules']['Becoming.RevisionRoutes'] = {'region': 'significance', 'base': 'general',
                                              'note': 'RR: a revision and the routes of keeping a law; GainLoss, the '
                                                      'order ReadStages takes'}
data['records'] = dict(sorted(data['records'].items()))
data['modules'] = dict(sorted(data['modules'].items()))
text = regions.read_text(encoding='utf-8')
regions.write_text(json.dumps(data, ensure_ascii=False, indent=1) + ('\n' if text.endswith('\n') else ''),
                   encoding='utf-8')
print('integrate: RevisionRoutes joined, ReadStages from GainLoss; checker, root, READMEs, 03 §11, 07 §7, 08 §8, '
      'overview, dossier' + ('' if '--no-fm' in sys.argv else ', FM §6') + ', regions')
