#!/usr/bin/env python3
"""Write evidence/REVIEW-RFM3-LEAN.md: the reviews of Becoming.ListingValuation's Lean, verbatim, and how each was taken.

Inputs (the review outputs, saved where the reviews ran): the cross-model reader's review (markdown); the three lenses'
findings (the workflow's JSON result); the three verifiers' verdicts (JSON, one per lens); the taken check's rows (JSON:
a list of {lens, rows}); the cross-model reader's re-check (markdown); and its check of the delta made after the taken
check (markdown). Usage, from the repository root:

    python3 -B <this file> <review .md> <lenses .json> <verdicts exactness .json> <verdicts structure .json> \
        <verdicts sources .json> <taken rows .json> <re-check .md> <delta check .md>
"""
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
STUDY = HERE.parents[1]
OUT = STUDY / 'evidence' / 'REVIEW-RFM3-LEAN.md'
sys.path.insert(0, str(HERE.parent / 'round2b'))
from relink_rfm2 import relink  # noqa: E402

ROOT = '/Users/ren/theories/.claude/worktrees/rf-landing/'
review_md, lenses_json, ve_json, vf_json, vl_json, rows_json, recheck_md, delta_md = (Path(x) for x in sys.argv[1:9])


def relinked(text):
    """Paths made relative to the checkout, and links made to resolve from this folder (relink_rfm2.py)."""
    return relink(text.replace(ROOT, ''))


def cx_body(path):
    text = path.read_text(encoding='utf-8')
    return text[:text.index('\n── cx ·')].rstrip('\n') if '\n── cx ·' in text else text.rstrip('\n')


INTRO = """# The review of `Becoming.ListingValuation`

RF round 2, third part, RF-M.3: the valuation as state; informing and revaluing (plan §4.8). The module as first built on the reviewed design (`kit/round2c/tree/Becoming/ListingValuation.lean` at the kit's commit `801f74681`: 105 theorems in 145 declarations, every axiom report empty, [build-1](../kit/round2c/logs/build-1.log)) was reviewed on the Lean on 30 October 2026 in two independent ways: by the cross-model reader (GPT astra, high effort, read-only, a fresh session `01a18d75-3522-7a52-87a0-f551210adf5d`), and through three lenses (exactness, structure, sources), each an Opus reader working read-only, with one verifier per lens asked to refute that lens's findings. The prompts are in [the brief](BRIEF.md#round-2-third-part). The reviews follow verbatim; their line numbers are those of the reviewed version, their paths are made relative to the checkout, and their links are made to resolve from this folder, since it is link-checked as live: a line number kept in a link's text and dropped from its target, and a link that does not resolve here shown as its text with its target as code.

**What was verified, and how.** Each lens's verifier judged every finding of its lens: exactness, sixteen of seventeen real (E10 not); structure, nineteen of twenty real (F16 not); sources, all fourteen real. The module was revised on all fifty-one lens findings (the two judged not real taken anyway) and the cross-model reader's fifteen, and rebuilt at the kit's commit `4843dd795`, 129 theorems in 177 declarations, every axiom report empty ([build-2](../kit/round2c/logs/build-2.log)). Three read-only Opus readers, one per lens, then checked from the files alone how each lens finding is reflected in the revised module: forty-four taken and seven in part (F4, F8, F9, F17, F20, L8, L13). Six of the seven were then completed, four with nine more declarations (F8, F9, F17, F20) and two in prose (F4, L13), and L8 stays in part for the re-check's R2 ([the table](#what-was-taken), each row completed after the check saying so); the cross-model reader's own findings were checked by its re-check.

**The re-check.** The revised module was re-checked by the cross-model reader in the session of its review, read-only ([below](#the-re-check)): no new mathematical error; of its fifteen findings ten resolved and five in part, and nine points, all in prose, every one taken ([its table](#what-was-taken-from-the-re-check)). The module's statements did not change for them; its prose was revised and it was rebuilt, 129 theorems in 177 declarations, every axiom report empty ([build-3](../kit/round2c/logs/build-3.log)).

**The check of the delta.** The changes made after the taken check (the nine declarations, the retitled docstrings, the off-switch paragraph citing `undemonstrated_worth`) were rebuilt, 138 theorems in 186 declarations, every axiom report empty, with no warning ([build-4](../kit/round2c/logs/build-4.log)), and checked by the cross-model reader in the session of its review, read-only ([below](#the-check-of-the-delta)): DELTA_SUMMARY"""

# The cross-model reader's findings: (status, how), its re-check's status first.
TAKEN_A = {
    '1': ('taken', "Re-check: resolved. The header says that, with the holding formation's model, the reading "
                   "formation's model, the reference and the map fixed, two valuations' answers fall short by amounts "
                   "that differ exactly as their residuals do (`revalued_split`), and the cost comparison is "
                   "`revalued_forgone_lt_iff`."),
    '2': ('taken', "Re-check: partly, its point R3 then taken. `revaluing_gains_iff` keeps the shared model and says "
                   "'some pair of value functions, unrestricted'; `residual_pos_of_gains` gives the forward direction "
                   "for any model of the reading formation and `unweighted_told` the boundary with the models apart; the "
                   "header, the docstring and the Readings say reachability under the supplied update is not asserted, "
                   "and `presented_forgone_lt_iff` compares a given input presented."),
    '3': ('taken', "Re-check: resolved. `inputs_alike_before` takes equality of the inputs along the course; "
                   "`undemonstrated_alike` and `undemonstrated_worth` are its corollaries where no demonstration is "
                   "emitted, whatever a demonstration would show; `inputs_alike` and `answer_constant` are kept."),
    '4': ('taken', "Re-check: resolved. `timing` states the answer available to the holding formation's move to "
                   "`t + 3`, which may ignore it; the modelling choices say the answer is exposed at every step, asked "
                   "or not, and that going on, switching off and holding change neither the candidate world nor the "
                   "reading formation, the worth of holding counted in Part 1."),
    '5': ('taken', "Re-check: resolved. The header's opening: equality of cells is decidable wherever cells are "
                   "compared or listings filtered."),
    '6': ('taken', "Re-check: resolved. `SplitsKeep` speaks of sets tested by Boolean functions; "
                   "`refining_never_lowers_iff`'s docstring names factoring on both listings, the coarser cells "
                   "covering the holding formation's listing and the finer covering both, the candidate the reading "
                   "formation alone lists (`OneListing.refined_lowers`), and a criterion of monotonicity, not of "
                   "agreement (`splitsKeep_of_off_le_go`, `release_keeps`)."),
    '7': ('taken', "Re-check: partly, its point R5 then taken. The coarse `DecidableEq` instance is removed from "
                   "`informed_le` and `informed_answer_le`; the header's informing bullet now asks only for the finer "
                   "map's cells; the Standing says `informed_le` composes `finer_least_le` with the split."),
    '8': ('taken', "Re-check: resolved. `Revaluing.revaluing_best` is four one-decision alternatives; the four cases "
                   "are stated as updates of one state ('as one update each'), apart from the courses."),
    '9': ('taken', "Re-check: resolved. The header gives the routes' different starts (`TwoWorlds.starts_apart`), their "
                   "answers at every step (`TwoWorlds.route_answers`), one configuration from step 2 on "
                   "(`TwoWorlds.routes_rest`, after R7), `T` from 2 on, the record leaving out the start and the "
                   "inputs, and with the start added (`TwoWorlds.lumped_with_start`); neither an ambiguity from one "
                   "start nor a test of legitimate change."),
    '10': ('taken', "Re-check: resolved in the import closure. `SupportGated.sub_pos_of_lt`, `across_le_iff`, "
                    "`across_lt_iff` and `lt_iff_pos` replace the four helpers; `total_lt_of_mem` and `cond_zero_le` "
                    "stay, their docstrings naming `Loops.total_lt` and `Weighting.term_le_of`, outside this module's "
                    "imports (the study leaves one statement of each to its module's owner)."),
    '11': ('taken', "Re-check: resolved. The Standing separates general laws on finite weighted listings, identities "
                    "and compositions of `HeldForReading`'s and `Blanketed`'s laws, and definitional equations and "
                    "finite witnesses; the kit's shard markers are removed."),
    '12': ('taken', "Re-check: partly, its points R2, R4 and R8 then taken. The weights read as a prior once a "
                    "positive total weight is normalized (Kamenica and Gentzkow); the off-switch reading, Claim 2's "
                    "assumptions and the demonstration's map corrected as the re-check's table says."),
    '13': ('taken', "Re-check: resolved in the implementation. The design review's table is left as that review's "
                    "record; its rows 11, 13 and 24 are now met in the Lean (findings 1 and 3), and rows 10, 12, 14 and "
                    "15 are qualified as findings 4, 8 and 9 say and by `answer_shown`'s docstring (a decision on a "
                    "conditional distribution needs positive weight in the cell)."),
    '14': ('taken', "Re-check: partly, its point R9 then taken: PLAN §4.8's items 5, 6 and 13, with the rest of §4.8, "
                    "restated as the Lean has them (`kit/round2c/plan_rfm3.py`)."),
    '15': ('taken', "Re-check: partly, its point R1 then taken. `revalued_forgone_lt_iff` is the costly criterion by "
                    "the residuals, `presented_forgone_lt_iff` its form for one presented input, `undemonstrated_alike` "
                    "and `undemonstrated_worth` the unshown corollary, and `TwoWorlds.orders_apart` the order witness, "
                    "its two starts alike but for the order of the holding formation's schedule."),
}

# Lens rows that later changes completed, or that stay in part with a reason: (status, how).
AFTER = {
    'F4': ('taken', "`inputs_alike_before` takes agreement only at the acts emitted on the course before `n`; "
                    "`undemonstrated_alike` and `undemonstrated_worth` need only that no demonstration is emitted "
                    "before `n` at `w₀`, stronger than the proposed `answer_constant_unshown`; `inputs_alike` is its "
                    "corollary. Completed after the check: the off-switch Readings cite `undemonstrated_worth` beside "
                    "`answer_constant`, the case where no demonstration is emitted at worlds a demonstration would "
                    "tell apart."),
    'F8': ('taken', "`shown_split` and `shown_never_lowers` are added with the proposed statements and cited in the "
                    "header; the TwoWorlds bullet labels the four cases 'as updates of one state'. Completed after the "
                    "check: `shown_least_le` (the least shortfall through what is shown at most that through one "
                    "cell) and the course forms `TwoWorlds.shown_course` and `TwoWorlds.presented_course`: along "
                    "courses of `joint`, holding for the answer falls short by 1 at step 1 and by nothing at step 2 "
                    "in both cases."),
    'F9': ('taken', "The bold title now says the answer has a residual exactly where a candidate the holding formation "
                    "weighs, unweighted by the reading formation, is one to stop. Completed after the check: the two "
                    "`have`s are factored into `unweighted_released` and `weighed_stops_iff`, and "
                    "`told_shortfall_zero_iff` states the proposed shortfall form, with no cell list."),
    'F14': ('taken', "The Modelling choices now say the answer is shown at every step, asked or not (`asked` and "
                     "`none` update alike), that going on, switching off and holding change neither the candidate "
                     "world nor the reading formation, and that holding's worth is counted in Part 1, not along "
                     "the courses. Corrected after the cold read of the texts (its findings X17 and T28): "
                     "`joint`'s docstring says that the answer is exposed at every step, asked or not, and that "
                     "going on and switching off are sensed as nothing and change no world."),
    'F17': ('taken', "`informed_le_add_residual` is the proposed graded bound, cited in the header with `informed_le` "
                     "its consequence. Completed after the check: `informed_lt_iff`, the strict form (with the finer "
                     "rule's residual nothing, the coarser rule stands strictly lower exactly where the least "
                     "shortfall falls or its own residual is positive), through `least_falls`."),
    'F20': ('taken', "`forgone_least_iff` is the proposed `withhold_net_iff`. Completed after the check: "
                     "`coarser_not_above`, the corollary (through a refinement, with a shared model and net agreement, holding for the coarser answer, forgoing no less, never stands above holding for the finer), cited in the "
                     "header and in the Readings: none against informing where informing forgoes no more."),
    'L8': ('taken in part', "The Readings cite Equation 1 for any policy of the human (a deterministic constant "
                            "policy giving waiting the value of its move, a randomized one a mixture), Theorem 1 as "
                            "the rational, informative case, Remark 1's two sources, and the observation difference. "
                            "The link asked for, `answer_constant` as the failure of Remark 1's second source, was "
                            "made and then withdrawn under the re-check's R2: a constant answer can give the better "
                            "move (gain 1 and loss 0 everywhere, a constant release is optimal), so constancy is not "
                            "failed effectiveness; the Readings say a constant answer gives holding no strict "
                            "advantage whether or not its move is the better one."),
    'L9': ('taken', "The Standing now reads `shortfall_split` as `shortfall_through` cell by cell through "
                    "`cond_split_least`, 'the least rule being the definition `leastThrough`'; `outcome_least` is "
                    "`answer_least_of_net` at the revised valuation. Corrected after the cold read of the texts (its "
                    "finding X17): `informed_le` and `informed_le_add_residual` compose `finer_least_le` with the "
                    "split, and `informed_lt_iff`, `refined_lt_iff` and `coarser_not_above` compose `least_falls` "
                    "with it, as their proofs do."),
    'L13': ('taken', "(a) `Act.present` replaces `press` at every use. (b) The two laws are renamed `forgone_lt_iff` "
                     "and `forgone_through_lt_iff`, the first titled structurally with 'read as withholding against "
                     "informing' marked. (c) 'an optimal signal chosen by the holding formation'. (d) 'an input "
                     "presented revises the valuation'. Completed after the check: the docstring titles of "
                     "`refined_lt_iff` and `forgone_least_iff` and the header's bullet are structural, the reading "
                     "marked, `forgone_least_iff`'s saying that no refinement is assumed; the record's law and the "
                     "study's bullet say 'amounts forgone'."),
}

# What was taken from the re-check: (point, status, how).
RECHECK = (
    ('R1', 'taken', "The header's carrier bullet and `TwoWorlds.orders_apart`'s docstring: two starts alike but for the "
                    "order of the holding formation's two scheduled acts, the answers apart at step 2 and one "
                    "configuration from step 3 on. Where two courses differ only in the world, the docstrings and the "
                    "header say 'from one state of each formation'; the record's laws, 03 §12's paragraph and the study likewise."),
    ('R2', 'taken', "The Readings: `answer_constant` takes one state of each formation at every world, nothing shown "
                    "telling the listed worlds apart; the answer is then constant and holding for it gives no strict "
                    "advantage over the better committed move, whether or not the move it gives is the better one; "
                    "'effectiveness failing' is gone, there and in 03 §12's reading."),
    ('R3', 'taken', "The header and `revaluing_gains_iff`'s docstring: reachability under the supplied update is not "
                    "asserted, and `presented_forgone_lt_iff` compares a given input presented; the Readings: the "
                    "incentive to revise only where the update reaches such a valuation, which is not asserted; PLAN "
                    "§4.8 item 13."),
    ('R4', 'taken', "The Readings: the comparison holds the listing, weights and map fixed, so the revision teaches "
                    "the reading formation nothing of the world; their assumptions (reward functions conditionally "
                    "uninformative about state transitions, private and state-based) are among what is not "
                    "represented."),
    ('R5', 'taken', "The header's informing bullet asks only for `π'`'s cells, listed once each and covering the "
                    "holding formation's listing; the coarser map's cells are named only for the criterion over every refinement. Updated after the check of the delta (its point 1): the bullet also names the coarser map's cells, listed once each and covering, for `informed_lt_iff`; and after the cold read of the texts (its finding X7), the bullet on amounts forgone names both maps' cells, listed once each and covering the holding formation's listing, for `refined_lt_iff`, and the bullet on when the answer is least names the told criterion's cells, covering that listing."),
    ('R6', 'taken', "`forgone_least_iff`'s docstring: holding for the answer through `π`, forgoing `k`, stands above "
                    "holding for it through `π'`, forgoing `k'`, exactly where the least shortfall through `π` and "
                    "`k` fall below that through `π'` and `k'`, each map's cells listed once each and covering the "
                    "listing."),
    ('R7', 'taken', "The header cites `TwoWorlds.routes_rest` for one configuration from step 2 on and "
                    "`TwoWorlds.routes_alike` for the records alike."),
    ('R8', 'taken', "The Readings: the holding formation's law reads only its own state and the answer, not the world; "
                    "a demonstration shows the world through the supplied map `reveal`, fixed in advance as a committed "
                    "experiment is and not chosen by the holding formation; 03 §12's reading likewise."),
    ('R9', 'taken', "PLAN §4.8: item 5 with the finer map's cells alone; item 6 with factoring on both listings, both "
                    "cell lists without repetitions and the coverage of each; item 13 with an unrestricted pair of "
                    "value functions and reachability not asserted; the other items brought to the Lean "
                    "(`kit/round2c/plan_rfm3.py`)."),
)

# The check of the delta: its summary for the opening, and what was taken from it: (point, status, how).
DELTA_SUMMARY = ("no new problem in the Lean statements, the proofs or the course arithmetic; two low omissions in "
                 "the header, both taken ([its table](#what-was-taken-from-the-check-of-the-delta)), and the module "
                 "rebuilt, 138 theorems in 186 declarations, every axiom report empty, with no warning "
                 "([build-5](../kit/round2c/logs/build-5.log)).")
DELTA = (
    ('1', 'taken', "The header's informing bullet: with the coarser map's cells also listed once each and covering the "
                   "holding formation's listing, holding for the finer rule with no residual stands strictly higher "
                   "exactly where the least shortfall falls or the coarser rule has a positive residual "
                   "(`informed_lt_iff`); 03 §12's paragraph, the study, the record's law and PLAN §4.8 item 5 "
                   "likewise."),
    ('2', 'taken', "The header's TwoWorlds bullet: the course forms measured by the reference `agree` with the holding "
                   "formation listing both worlds at weights 1 and 2 (`TwoWorlds.shown_course`) and the first world "
                   "alone at weight 1 (`TwoWorlds.presented_course`), from each witness's start; 03 §12's paragraph, "
                   "the study, the record's law and PLAN §4.8 item 20 likewise."),
)
INTRO = INTRO.replace('DELTA_SUMMARY', DELTA_SUMMARY)
assert 'DELTA_SUMMARY' not in INTRO, 'the summary of the check of the delta is not written'

def labelled(label, text):
    """A bold label and its text; a text opening with a code fence starts its own paragraph, so the fence is one."""
    body = relinked(text)
    return f'**{label}.**\n\n{body}' if body.lstrip().startswith(('```', '~~~')) else f'**{label}.** {body}'


review = relinked(cx_body(review_md))
lenses = {r['lens']: r['findings'] for r in json.loads(lenses_json.read_text(encoding='utf-8'))['result']}
verdicts = {}
for path in (ve_json, vf_json, vl_json):
    for v in json.loads(path.read_text(encoding='utf-8'))['verdicts']:
        verdicts[v['id']] = v
rows = {r['lens']: r['rows'] for r in json.loads(rows_json.read_text(encoding='utf-8'))}

parts = [INTRO + '\n', '## The cross-model review\n', review + '\n']
NAMES = (('exactness', 'The exactness lens'), ('structure', 'The structure lens'), ('sources', 'The sources lens'))
for key, title in NAMES:
    found = lenses[key]
    real = sum(1 for f in found if verdicts[f['id']]['real'])
    parts.append(f'## {title}\n\n{len(found)} findings, each judged by the verifier: {real} real, '
                 f'{len(found) - real} not. The verdict follows each finding.\n')
    for f in found:
        v = verdicts[f['id']]
        block = [f"### {f['id']} ({key}, {f['severity']}, {'confirmed' if v['real'] else 'refuted'})", '',
                 labelled('Location', f['location']), '',
                 labelled('Quoted', f['quote']), '',
                 labelled('Problem', f['problem']), '',
                 labelled('Replacement', f['replacement']), '',
                 labelled(f"Verdict: {'real' if v['real'] else 'not real'}", v['reason']), '']
        better = (v.get('better_replacement') or '').strip()
        if better:
            block += [labelled('Better replacement', better), '']
        parts.append('\n'.join(block))

table = ['## What was taken', '',
         "The cross-model reader's findings (A1 to A15) with its re-check's status and how each was taken; each lens "
         "finding as the taken check found it in the revised module, or, where later changes completed it, as updated "
         "after the check. Statuses: taken; taken in part (what remains is said); not taken; superseded (the passage "
         "was replaced by one the problem no longer applies to).", '',
         '| Finding | Status | How |', '|---|---|---|']
for n in range(1, 16):
    status, how = TAKEN_A[str(n)]
    table.append(f"| A{n} | {status} | {relinked(how).replace('|', chr(92) + '|')} |")
seen = []
for key, _ in NAMES:
    for row in rows[key]:
        rid = row['id']
        seen.append(rid)
        if rid in AFTER:
            status, how = AFTER[rid]
        else:
            status = row['status']
            how = row['how'] + (f" Remaining: {row['gap']}" if row['gap'].strip() else '')
            if row['verdict'] == 'not real' and 'not real' not in how:
                how = 'Judged not real by the verifier. ' + how
        how = relinked(how).replace('|', '\\|').replace('\n', ' ')
        table.append(f'| {rid} | {status} | {how} |')
assert set(AFTER) <= set(seen), set(AFTER) - set(seen)
assert seen == [f['id'] for key, _ in NAMES for f in lenses[key]], 'rows out of order or missing'
parts.append('\n'.join(table) + '\n')

parts.append('## The re-check\n\nThe cross-model reader, in the session of its review, read the revised module and '
             'the diff from the reviewed commit, read-only (its prompt is in [the brief](BRIEF.md#round-2-third-part)). '
             'Verbatim; its line numbers are those of the kit\'s commit `4843dd795`.\n')
parts.append(relinked(cx_body(recheck_md)) + '\n')
rtable = ['### What was taken from the re-check', '', '| Point | Status | How |', '|---|---|---|']
for point, status, how in RECHECK:
    rtable.append(f"| {point} | {status} | {how.replace('|', chr(92) + '|')} |")
parts.append('\n'.join(rtable) + '\n')

parts.append('## The check of the delta\n\nThe cross-model reader, in the session of its review, read the changes made '
             'after the taken check and the diff from the re-checked commit, read-only (its prompt is in [the '
             'brief](BRIEF.md#round-2-third-part)). Verbatim.\n')
parts.append(relinked(cx_body(delta_md)) + '\n')
if DELTA:
    dtable = ['### What was taken from the check of the delta', '', '| Point | Status | How |', '|---|---|---|']
    for point, status, how in DELTA:
        dtable.append(f"| {point} | {status} | {how.replace('|', chr(92) + '|')} |")
    parts.append('\n'.join(dtable) + '\n')

text = '\n'.join(parts)
assert '](/' not in text and ROOT not in text
OUT.write_text(text, encoding='utf-8')
print(OUT.relative_to(STUDY.parents[0]), len(text), 'characters,', 15 + len(seen), 'rows')
