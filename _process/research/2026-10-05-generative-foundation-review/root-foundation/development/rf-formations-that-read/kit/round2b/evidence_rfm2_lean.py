"""Write evidence/REVIEW-RFM2-LEAN.md: the reviews of Becoming.HeldForReading's Lean, verbatim, and how each was taken.

Inputs (the review outputs, saved where the reviews ran): the cross-model reader's review (markdown), the three
lenses' findings with the exactness verifier's verdicts (JSON), the taken check's rows (JSON) and the cross-model
reader's re-check (markdown). Rows that later changes completed are given here, after the check, in AFTER; what was
taken from the re-check is RECHECK. Usage, from the repository root:

    python3 -B <this file> <reader review .md> <lens results .json> <taken rows .json> <re-check .md>
"""
import json
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
STUDY = HERE.parents[1]
OUT = STUDY / 'evidence' / 'REVIEW-RFM2-LEAN.md'
ROOT = '/Users/ren/theories/.claude/worktrees/rf-landing/'

reader_md, lens_json, rows_json, recheck_md = (Path(x) for x in sys.argv[1:5])


def unlink(text):
    """Links unlinked, since this folder is link-checked as live; paths made relative to the checkout."""
    return text.replace(ROOT, '').replace('](', '\\](')


INTRO = """# The review of `Becoming.HeldForReading`

RF round 2, second part, RF-M.2: an act held for a reading (plan §4.7). The module as first built on the reviewed design (`kit/round2b/tree/Becoming/HeldForReading.lean` at the kit's commit `7f4679003`: 56 theorems in 80 declarations, every axiom report empty) was reviewed on the Lean on 30 October 2026 in two independent ways: by the cross-model reader (GPT astra, high effort, read-only, a fresh session `01a18c02-6b30-79a3-acff-297bd8cf6b60`), and through three lenses (exactness, structure, sources), each an Opus reader working read-only, with one verifier per lens asked to refute that lens's findings. The prompts are in [the brief](BRIEF.md#round-2-second-part). The reviews follow verbatim; their line numbers are those of the reviewed version, the reader's links are unlinked (`\\](`), since this folder is link-checked as live, and its paths are made relative to the checkout.

**What was verified, and how.** The exactness verifier judged all seventeen of its lens's findings: fourteen real and three not (E8, E11, E15); the module changed at those three places anyway, as the table says. The verifiers of the structure and sources lenses were stopped before they reported, so those findings carry no independent verdict. In their place, every literature point the sources lens raised was checked against the papers' own texts by the session that wrote the module ([below](#the-literature-checked-against-the-papers)), and each structure finding was judged against the Lean by that session before it was taken; neither check is independent. The module was then rebuilt, and at 81 theorems in 111 declarations four read-only Opus readers, one per set of findings, checked from the files alone how each finding is reflected in it; [the table](#what-was-taken) gives their rows, with the rows that later changes completed marked as updated after the check. Later changes brought the module to 89 theorems in 119 declarations, every axiom report empty ([build-18](../kit/round2b/logs/build-18.log)).

**The re-check.** The rebuilt module (89 theorems in 119 declarations), its record script and the plan were then re-checked by the cross-model reader in the same session, read-only ([below](#the-re-check)): no false Lean statement, twelve points, every one taken but one taken in part ([its table](#what-was-taken-from-the-re-check)). The module was rebuilt for them to 90 theorems in 120 declarations, every axiom report empty ([build-20](../kit/round2b/logs/build-20.log); build-19 stopped on an unqualified name).
"""

LITERATURE = """## The literature, checked against the papers

Each point the sources lens raised, checked against the paper's text: the off-switch game (Hadfield-Menell, Dragan, Abbeel and Russell 2017, arXiv 1611.08219v3), Carey (2018, arXiv 1709.06275v2), Milli, Hadfield-Menell, Dragan and Russell (2017, arXiv 1705.09990v1) and Good (1967, the British Journal for the Philosophy of Science). Paraphrased, with places as printed.

| Work and place | What it says | How the module reads it |
|---|---|---|
| Off-switch game, Equation 1 | the robot's incentive to wait, for any policy of the human, is the smaller of two signed expectations, of the negated utility times the chance that the human switches it off and of the utility times the chance that the human lets it act; for a policy other than the rational one either can be negative | `after_add_shortfall_go` and `after_add_shortfall_off`: `T` times its two terms, as balances, for a rule that is a function of the candidate; a rule treating alike-valued candidates differently is, on the utility alone, the paper's policy releasing at each value with the share of weight it releases there |
| Equation 2 | the rational human lets the robot act exactly where the utility is at least zero | `byReading`, going on where gain and loss are equal |
| Theorem 1 | for a rational human: (1) the incentive is never negative, and is Equation 3, the smaller of the expected positive part and the expected negative part, the second printed with the probability that the utility is at most zero; (2) if the belief gives positive probability to both strict signs, the incentive is strictly positive (one direction) | `committed_le_held` (part 1); `after_byReading` (Equation 3 as `T` times the smaller of waiting's two differences, read with the probability that the utility is below zero); `held_gains_iff` (part 2 as an equivalence, for a belief of finite support) |
| Corollary 1 | for a belief putting all its mass on one utility, waiting is optimal exactly where the human is rational | widened to any model fixing the sign (`threshold_go_iff`, `threshold_off_iff` with `excess_pos_iff`), with the exception where gain and loss are equal, which the corollary leaves unstated |
| Remark 1 | the incentive to defer comes from the robot's uncertainty about the human's preferences and from the human's effectiveness at acting on them | the model's openness less the reading's shortfall is that incentive, decomposed otherwise; the threshold adds what holding forgoes, which the paper's game lacks [AI reading] |
| Section 4 and Theorem 2 | with a noisily (Boltzmann) rational human the incentive can be negative; for a Gaussian belief it is the variance times the human's expected responsiveness less the size of the mean times the probability that the human corrects the robot (Equation 7), positive exactly where Equation 8's condition holds | not represented: a periphery debt, named in the Readings |
| Carey, setup | rewards with a sign error, the prior over the human's reward parameter correct, the human noisy | `SignLoop` represents no valuation beyond the counts on the kept listing: related, not contained |
| Carey, Figure 2a | the faulty reward makes going on better under every parameter, so a recommendation to shut down is received and disregarded | the case here of a model fixing the sign, there with a strict preference |
| Carey, Figure 3a | a system that obeys any stop it is given routes around the states where a stop can be given | named; not represented (`SignLoop` anticipates no stop) |
| Carey, footnote 1 | a system kept indifferent to shutdown and deferring at ties would defer wherever shutting down is open | the Readings' rule for ties |
| Carey, Discussion | the positive results assume a correct posterior; a model conflating the better of two acts with the worse makes its predictions appear perfectly accurate on the observations it encodes, passes Milli and others' check over an initial period of obedience, and can then ignore the instruction to shut down (paraphrased first as predicting the human's choices without error, corrected on the re-check's point 12) | nearest to `SignLoop.rests_unread`, a misspecified model its course never refutes; not a formalization of the conflation |
| Milli and others, setting | a robot learning a reward from a noisily rational human's orders over repeated rounds | not represented |
| Their Theorem 1 | the optimal robot's advantage over obeying is never negative, and is zero exactly where it always obeys | `after_le_after` and `after_eq_after_iff`, the candidates being what the system observes, ties counted here by value |
| Their Theorem 3 | the robot obeys blindly exactly where the human is rational | parallels the off-switch Corollary 1 |
| Their Section 5 | the maximum-likelihood robot is robust to a wrong rationality parameter (Theorem 5); with missing features the robot obeys less than it should and can do worse than obeying; Remark 4 on mixing policies and an initial period of obedience | `SignLoop`'s listing without the true sign is a deterministic relative |
| Good (1967) | finite throughout: deciding after a free observation is expected to be worth at least deciding now, with equality where one act's row dominates (each of its entries at least every entry in its column), under the proviso that the observation's cost be negligible; observations need not reveal the hypothesis | `after_add_gap`, `after_lt_after_iff`, `after_eq_after_iff`, `reading_gains_iff`: the perfect-information specialization, his dominating row the equality boundary, the amount forgone relaxing the proviso for two moves |
"""

# Rows that changes after the taken check completed: (status, how).
AFTER = {
    'A1': ('taken', "Updated after the check and the re-check: PLAN §13 now gives the design review's statuses "
                    "(twelve implemented, eight deferred as specified, seven to RF-M.3's design and one to the "
                    "institutional reading, one handed to its record's owner, one taken in part), and the record's "
                    "history lists the reviews and points to this evidence instead of saying every finding was taken. "
                    "The re-check found the eight first placed all in RF-M.3 (its point 1); PLAN §4.7, §13 and "
                    "REVIEW-RFM2's status line now place them."),
    'A8': ('partly taken', "Updated after the re-check (its point 9): the two list inductions it named, "
                           "`SignLoop.not_loses_of_all_true` and `SignLoop.not_gains_of_all_true`, now use the "
                           "prelude's `ListTests.all_mem`. `total_single` stays, disclosed in its docstring: "
                           "`Interleavings.LocalLaw.total_single` is outside this module's imports; its move to a "
                           "shared totals dependency is left for a board proposal to the owners, with F17's addend "
                           "lemma (none made yet)."),
    'A14': ('taken', "Updated after the re-check (its points 10 to 12): the record, PLAN and the texts now carry the "
                     "module's source corrections: Equation 3 read with Pr(U < 0), Remark 1 qualitative and Theorem 2 "
                     "Gaussian with the off-switch paper named, and Carey's conflating model's accuracy relative to "
                     "the observations it encodes."),
    'A3': ('taken', "Updated after the check: PLAN §4.7 item 6 now reads 'With no cycle shown, for two different "
                    "alternatives neither of which reaches the other, strict orders according with the choices rank them "
                    "both ways (`ChoiceOccasions.both_ways_of_unreached`), as relations, not decided comparisons'."),
    'A5': ('taken', "Updated after the check: `SignLoop.choose_go_ties` and `SignLoop.choose_off_ties` (through "
                    "`held_eq_go_iff`, `held_eq_off_iff`, `SignLoop.offExcess_of_all_true` and "
                    "`SignLoop.goExcess_of_all_not`) prove that where the formation goes on or switches off, holding "
                    "stands exactly as high as the move taken, so with `committed_le_held` the move taken is maximal; "
                    "the header, the docstrings and the record's counterexample now say this, and no longer that holding "
                    "gains over neither move."),
    'A7': ('taken', "Updated after the check: the docstrings of `after_lt_after_iff`, `committed_eq_after_iff` and "
                    "`reading_gains_iff` name the open act and the supplied policy best at every listed candidate."),
    'E17': ('taken', "Updated after the check: (d) is taken throughout: `pair_gains_iff`'s docstring says 'disagree on "
                     "the two' and 'ranks each of the two above the other', and the record's law 'ranks each above the "
                     "other' and 'some such candidate ranks the first higher and some the second'."),
    'F5': ('taken', "Updated after the check: PLAN §4.7 item 6 states the three conditions, and the record's "
                    "does_not_show speaks of two alternatives neither of which reaches the other; the optional "
                    "`both_ways_decided` bridge is not added."),
    'F6': ('taken', "Updated after the check: `after_rule_add_onLoss` and `after_rule_le_iff` state the correspondence "
                    "with the signed values for every rule of stopping, the committed moves included, in natural "
                    "numbers, each weighted loss added to the other side; the `shifted` docstring, the header, the "
                    "modelling choices, the record, the chapter's paragraph, PLAN and REVIEW-RFM2's row 4 cite them."),
    'F9': ('taken', "Updated after the check: the tie is a law, `held_eq_go_iff` and `held_eq_off_iff`, cited in the "
                    "header and the Readings; `held_gains_iff_margins` is not added, being `held_gains_iff` with "
                    "`excess_pos_iff`."),
    'F15': ('taken', "Updated after the check: the record's statement says 'valued best' and the Standing 'valued as the "
                     "best'; `bestAt_iff_alike` is not added, the docstrings taking the finding's alternative wording."),
    'F17': ('partly taken', "Updated after the check: `across_le_iff` and `across_lt_iff` now name "
                            "`Optimum.le_iff_of_add_eq` and `SelectionTerm.lt_iff_of_balance`, each with `k` added to "
                            "both sums and outside this module's imports; `cond_split` meets no other declaration of the "
                            "package. Not taken: a board proposal to state the addend lemma once, beside the Prelude's "
                            "root cancellation lemmas."),
    'L5': ('taken', "Updated after the check: the Readings give Milli and others' Theorem 1 with its equality half "
                    "(`after_le_after` and `after_eq_after_iff`, ties counted here by value) and their Section 5's "
                    "model 'able to do worse than obeying', of which `SignLoop`'s listing without the true sign is a "
                    "deterministic relative."),
    'L7': ('taken', "Updated after the check: the Standing says 'the paper's Equation 1, which holds for any policy of "
                    "the human', and reads a rule treating alike-valued candidates differently as, on the utility "
                    "alone, the paper's policy releasing at each value with the share of weight it releases there."),
    'E3': ('taken', "Updated after the check: the empty-list default is kept and stated in `choose`'s docstring ('go on "
                    "... where none is kept; switch off where some are kept and every one predicts that it loses'), the "
                    "header, the modelling choices and the record's law and hypothesis, the switch-off clause now saying "
                    "'where some are kept'. `SignLoop.refuted_senses_stop`, `SignLoop.refuted_drops` and "
                    "`SignLoop.refuted_goes_on` (the finding's `held_start_disregards` configuration, from step 3) "
                    "witness the held start, which the header, the Readings and record counterexample 2 describe; "
                    "`rests_unread`/`never_senses_stop` are stated from the going-on start."),
    'E5': ('taken', "Updated after the check: the header is the replacement nearly word for word: no cycle shown, two "
                    "different alternatives neither of which reaches the other, 'as relations, not decided comparisons', "
                    "and 'whether the model lists decided candidates of both rankings with positive weight is not "
                    "fixed'. The record's does_not_show item makes no existence claim, and PLAN §4.7 item 6, which the "
                    "finding does not name, now states the same conditions (as for A3)."),
    'E14': ('taken', "Updated after the check: the Standing lists `committed_eq_after_iff` and `below_iff` as short "
                     "compositions ('`after_eq_after_iff` and `after_lt_after_iff` at a constant policy'), places "
                     "`forgone_within_excess_iff` (formerly `cost_within_margins_iff`) and `total_by_cells` among them, "
                     "and calls `held_gains_iff` and `pair_gains_iff` each 'two instances of `below_iff`'. Unlike the "
                     "replacement, `threshold_go_iff`/`threshold_off_iff` are listed as short compositions."),
    'F11': ('taken', "Updated after the re-check (its point 7): `pair_gains_unreached` is added, taking `trans` and "
                     "`accords` alone on listed candidates of positive weight in place of `StrictAccording`, and "
                     "concluding `¬ «及» ch.Shown x y ∧ ¬ «及» ch.Shown y x`; `asymm` stays a hypothesis of "
                     "`pair_gains_iff` only. The header ('with comparisons transitive and according with the choices "
                     "alone, it gains over both only where neither alternative reaches the other'), the record's law "
                     "and the amended related entry of what-choices-show-of-an-order carry it."),
    'L1': ('taken', "Updated after the check: the Standing gives `held_gains_iff` as the off-switch Theorem 1 for a "
                    "belief of finite support with natural-number weights and values ('deterministic' dropped), with "
                    "`byReading` its rational human and the strict condition stated as an equivalence. It names "
                    "`committed_le_held` (was `held_le`) as its inequality, attaches Equation 3 to `after_byReading` "
                    "(T times the smaller of waiting's two differences, read with Pr(Ua < 0) where Pr(Ua ≤ 0) is "
                    "printed) and Equation 1 to `after_add_shortfall_go`/`after_add_shortfall_off`, and lists "
                    "`forgone_within_excess_iff` (was `cost_within_margins_iff`) and `threshold_go_iff`/"
                    "`threshold_off_iff` (were `held_above_*`) as short compositions; the Readings credit Remark 1 and "
                    "Theorem 2, and the record's correspondence matches. `byReading`'s docstring now names Equation 2, "
                    "and 'shortfall' replaces 'the reading's accuracy' (as for L11)."),
    'L10': ('taken', "Updated after the check: the Readings say the witness has the structure of "
                     "`ReadingLoop.Untested` (read there with self-confirming equilibrium and incomplete learning, the "
                     "citations of Fudenberg and Levine (1993) and Rothschild (1974) not repeated), its kept candidate "
                     "agreeing with the world along the course and not off it, and that holding first where going on "
                     "loses refutes the only candidate (`SignLoop.refuted_senses_stop`, `SignLoop.refuted_drops`, "
                     "`SignLoop.refuted_goes_on`). The record depends on and amends "
                     "`what-a-course-chosen-through-its-model-does-not-test`."),
    'A6': ('taken', "Updated after the check: `SignLoop.choose`'s docstring now reads 'go on where every "
                    "candidate kept predicts that going on gains, and where none is kept; switch off where some are "
                    "kept and every one predicts that it loses; hold where those kept disagree', the switch-off clause "
                    "adding 'where some are kept' (as for E3); the header, the modelling choices and the record say "
                    "the same, and `SignLoop.refuted_goes_on` uses the default with none kept. The wording 'a listing "
                    "lacking the true sign rests on it' is gone: `SignLoop.rests_unread`, for any listing that all "
                    "predicts gain and any true sign, says the formation 'rests at once, whatever the true sign'."),
    'A9': ('taken', "Updated after the check: `after_offset` proves the common-offset identity through `total_add`, "
                    "and `after_offset_le_iff` proves that comparisons are preserved, by cancellation; both are cited "
                    "in the header and the Standing, and `shifted`'s docstring now cites `after_rule_add_onLoss` and "
                    "`after_rule_le_iff` (as for F6). `Model`'s docstring, the modelling choices and record hypothesis "
                    "1 say a listing may repeat a candidate, each occurrence counting its weight, and that "
                    "probabilities are read over a listing without repetition; the 'otherwise aggregate occurrence "
                    "weights' clause is not stated."),
    'E7': ('taken', "Updated after the check and the re-check: the local `le_of_add_le_add_left_core` and "
                    "`cond_le_one` are deleted, the Prelude's used in their place, and `total_lt_of` is deleted, "
                    "`after_lt_after_iff` going through `after_add_gap` and Flow's `total_pos`/`total_pos_of_mem`. "
                    "The one new copy, `total_single`, names `Interleavings.LocalLaw.total_single` (outside the "
                    "import closure) in its docstring; the counts, recomputed at each rebuild, are now 90 theorems in "
                    "120 declarations (PLAN §4.7's entry for RF-M.2)."),
    'F10': ('taken', "Updated after the check: `cell_policy_iff` is the proposed `through_lumping_iff`, with cells of "
                     "a map for the classes of a lumping and `Viability.ChoiceOver` over the cells "
                     "(`Viability.choiceOver_fin` named). The header and Standing state it ('`cell_policy_iff` states "
                     "it weighted'), and the record carries it with the ChoiceOver dependency. The Standing cites "
                     "`GuardHorizon.uniform_policy_iff_fiber_feasible` as 'an application of the ring', as proposed."),
    'L11': ('taken', "Updated after the check: `byReading`'s docstring says it stops by the supplied values and is the "
                     "paper's rational human, its Equation 2; 'accuracy' is replaced by 'shortfall' in the Readings, the "
                     "record's correspondence and PLAN."),
}

reader = reader_md.read_text(encoding='utf-8')
reader = reader[:reader.index('\n── cx ·')].rstrip('\n')
lenses = json.loads(lens_json.read_text(encoding='utf-8'))
verdicts = {v['id']: v for v in lenses['refute:exactness']['verdicts']}
rows = json.loads(rows_json.read_text(encoding='utf-8'))

parts = [INTRO, '## The cross-model review\n', unlink(reader) + '\n']
NAMES = (('exactness', 'The exactness lens'), ('structure', 'The structure lens'), ('sources', 'The sources lens'))
for key, title in NAMES:
    found = lenses[f'lens:{key}']['findings']
    note = {'exactness': 'each finding judged by the verifier; its verdict follows the finding',
            'structure': 'not independently verified: its verifier was stopped before it reported',
            'sources': 'not independently verified: its verifier was stopped before it reported; the literature '
                       'points were checked against the papers ([below](#the-literature-checked-against-the-papers))'}[key]
    parts.append(f'## {title}\n\n{len(found)} findings, {note}.\n')
    for f in found:
        v = verdicts.get(f['id']) if key == 'exactness' else None
        state = ('confirmed' if v['real'] else 'refuted') if v else 'not verified'
        block = [f"### {f['id']} ({key}, {f['severity']}, {state})", '',
                 f"**Location.** {unlink(f['location'])}", '',
                 f"**Quoted.** {unlink(f['quote'])}", '',
                 f"**Problem.** {unlink(f['problem'])}", '',
                 f"**Replacement.** {unlink(f['replacement'])}", '']
        if v:
            block += [f"**Verdict: {'real' if v['real'] else 'not real'}.** {unlink(v['reason'])}", '']
            better = (v.get('better_replacement') or '').strip()
            if better:
                block += [f'**Better replacement.** {unlink(better)}', '']
        parts.append('\n'.join(block))
parts.append(LITERATURE)


table = ['## What was taken', '',
         'Each row as the taken check found it in the rebuilt module (81 theorems in 111 declarations), or, where '
         'later changes completed a finding, as updated after the check. Statuses: taken; partly taken; superseded '
         '(the passage was replaced by one the problem no longer applies to).', '',
         '| Finding | Status | How |', '|---|---|---|']
ORDER = (('astra', 'A'), ('exactness', 'E'), ('structure', 'F'), ('sources', 'L'))
seen = []
for key, _ in ORDER:
    for row in rows[f'taken:{key}']:
        rid = row['id']
        seen.append(rid)
        status, how = AFTER.get(rid, (row['status'], row['how']))
        how = unlink(how).replace('|', '\\|').replace('\n', ' ')
        table.append(f'| {rid} | {status} | {how} |')
assert set(AFTER) <= set(seen), set(AFTER) - set(seen)
assert len(seen) == 14 + 17 + 24 + 14, len(seen)
parts.append('\n'.join(table) + '\n')

# What was taken from the re-check: (point, status, how).
RECHECK = (
    ('1', 'taken', "A1's deferrals placed (seven to RF-M.3's design, one to the institutional reading) in PLAN §4.7, "
                   "§13 and REVIEW-RFM2's status line; A8 as point 9, A14 as points 10 to 12 (the table above, "
                   "updated)."),
    ('2', 'taken', "`cell_policy_iff`'s docstring, the header, the record's law, PLAN, 03 §12's paragraph and the study "
                   "say that some policy through the map attains the best exactly where every cell has a common best "
                   "open act; `least_zero_iff`'s docstring and the texts say that the least shortfall through the reading "
                   "is nothing exactly where no listed cell holds both excesses; refinement is said as the least "
                   "shortfall never increasing (`finer_least_le`'s docstring, the Readings, the record, PLAN, the root "
                   "module's bullet, the checker's scope, the overview, the study)."),
    ('3', 'taken', "The record's statement: choosing best after a reading telling the candidate gains over every open "
                   "act exactly where none is valued best at every listed candidate of positive weight (298 "
                   "characters, within the cap); 'listed' kept in the laws and the texts."),
    ('4', 'taken', "The record's hypotheses, the header, the cells' law, PLAN's item 5, 03 §12's paragraph and the study "
                   "name equality of cells decidable, cells listed once each and covering every listed candidate's "
                   "cell, and choice over the whole type of cells, `Viability.choiceOver_fin` supplying it for "
                   "`Fin k`."),
    ('5', 'taken', "The modelling choices, the record's hypotheses and the study: `byReading` goes on at equal gain "
                   "and loss, `leastThrough` stops a cell at equal excesses, other rules go either way; PLAN's and 03 "
                   "§12's fixed-sign sentence now says 'with nothing forgone' and 'exactly where'."),
    ('6', 'taken', "The amendment to what-choices-show-of-an-order carries transitivity and accordance at listed "
                   "candidates of positive weight, under which the shown reach makes the fixed pick attain the "
                   "reading's value; the record's law is restructured so that those conditions govern 'only where "
                   "neither reaches the other', and `pair_gains_iff`'s condition stands apart."),
    ('7', 'taken', "`pair_gains_unreached` has no asymmetry hypothesis: where the second reaches the first, every "
                   "listed candidate of positive weight ranks the second above the first, `pairPolicy` picks it, and "
                   "`committed_eq_after_iff` ties committing to it with holding, against the strict gain. Compiled, "
                   "its axiom report empty; the header, the record, 03 §12's paragraph and the study say it needs "
                   "transitivity and accordance alone."),
    ('8', 'taken', "The Readings say the internal, sensory and active course is the same whatever the true sign. The "
                   "step-two equation is a theorem, `SignLoop.refuted_drops` (by `rfl`, compiled), and "
                   "`refuted_goes_on`'s docstring says the formation goes on by `choose`'s default with none kept, "
                   "which the law of resting on unrefuted candidates does not need; the record, the header, PLAN, 03 "
                   "§12's paragraph and the study cite it."),
    ('9', 'partly taken', "`SignLoop.not_loses_of_all_true` and `SignLoop.not_gains_of_all_true` use the prelude's "
                          "`ListTests.all_mem`. `total_single` stays as disclosed, its move to a shared totals "
                          "dependency left for a board proposal to the owners (none made yet); `across_le_iff` and "
                           "`across_lt_iff` stay, their relation "
                          "to `Optimum` and `SelectionTerm` named."),
    ('10', 'taken', "The record's correspondence in both languages, PLAN's item 2 and the study: waiting's two "
                    "differences T E[U⁺] and T E[(−U)⁺], T times Equation 3's terms read with Pr(U < 0) where "
                    "Pr(U ≤ 0) is printed."),
    ('11', 'taken', "The Readings, the record (the off-switch paper named), 03 §12's reading, 08's bullet and the study: "
                    "Remark 1 gives the relation qualitatively, Theorem 2, Δ = σ²E[π̇H] − |µ|Pr(C), is its Gaussian "
                    "form, and the counts decompose the incentive differently."),
    ('12', 'taken', "The Readings, the record in both languages, PLAN's item 7, 03 §12's reading, the dossier and the "
                    "literature table: the conflating model's predictions appear perfectly accurate on the "
                    "observations it encodes; the relation is a misspecified model the course never refutes, not a "
                    "formalization of the conflation."),
    ('verdict', 'taken', "The Standing labels `bestOf_best` elementary finite maximization."),
)
recheck = recheck_md.read_text(encoding='utf-8')
recheck = recheck[:recheck.index('\n── cx ·')].rstrip('\n')
parts.append('## The re-check\n\nThe cross-model reader, in the session of its review, read the rebuilt module, its '
             'record script and the plan, read-only (its prompt is in [the brief](BRIEF.md#round-2-second-part)). '
             'Verbatim; its line numbers are those of the version it read (89 theorems in 119 declarations).\n')
parts.append(unlink(recheck) + '\n')
rtable = ['### What was taken from the re-check', '', '| Point | Status | How |', '|---|---|---|']
for point, status, how in RECHECK:
    rtable.append(f"| {point} | {status} | {how.replace('|', chr(92) + '|')} |")
parts.append('\n'.join(rtable) + '\n')

text = '\n'.join(parts)
assert '](/' not in text and ROOT not in text
OUT.write_text(text, encoding='utf-8')
print(OUT.relative_to(STUDY.parents[0]), len(text), 'characters,', len(seen), 'rows')
