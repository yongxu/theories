"""Write evidence/REVIEW-RFM3-COLDREAD.md: the cold read of RF-M.3's texts, verbatim, and what was taken
(evidence_rfm2_coldread.py's pattern).

Inputs (saved where the reads ran): the cross-model reader's cold read (markdown); the workflow's result, the three
lenses' findings with their refuters' verdicts (JSON: a list of {lens, found: {verdict, findings}, verdicts:
{verdicts}}); and the cross-model reader's two re-checks (markdown, or `-` while one has not run): the first of how
its own points were taken and of the texts cut or added since, before the lenses ran; the second of how the lenses'
findings were taken. What was taken from each re-check is in RECHECKS. Usage, from the repository root:

    python3 -B <this file> <cold read .md> <lens results .json> <first re-check .md | -> <second re-check .md | ->
"""
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent / 'round2b'))
from relink_rfm2 import relink  # noqa: E402

STUDY = HERE.parents[1]
OUT = STUDY / 'evidence' / 'REVIEW-RFM3-COLDREAD.md'
ROOTS = ('/private/tmp/claude-501/-Users-ren-theories/50635de9-b91e-4f4c-a63c-8413ce8c4652/scratchpad/rfm3-rehearsal/',
         '/Users/ren/theories/.claude/worktrees/rf-landing/')

reader_md, lens_json = Path(sys.argv[1]), Path(sys.argv[2])
recheck_mds = [None if a == '-' else Path(a) for a in sys.argv[3:5]]


def relinked(text):
    """Paths made relative to the checkout, and links made to resolve from this folder (relink_rfm2.py)."""
    for root in ROOTS:
        text = text.replace(root, '')
    return relink(text)


def cx_body(path):
    text = path.read_text(encoding='utf-8')
    return text[:text.index('\n── cx ·')].rstrip('\n') if '\n── cx ·' in text else text.rstrip('\n')


def cell(text):
    return text.replace('|', '\\|').replace('\n', ' ')


INTRO = """# The cold read of RF-M.3's texts

RF round 2, third part, RF-M.3: the valuation as state; informing and revaluing (plan §4.8). Before RF-M.3's landing, its texts were cold-read against the Lean of `Becoming.ListingValuation` (`kit/round2c/tree/Becoming/ListingValuation.lean`, 138 theorems in 186 declarations, every axiom report empty), as the kit's integration applied them to main in a rehearsal worktree (for the cross-model reader the kit at `07a24e169` with main at `1ec20513d`; for the lenses, after its points and its first re-check were taken, the kit at `3f43eefcf` with main at `8a8b0df82`): 03 §12's opening, its new theorem paragraph with its Reading, the pointer in the acts-alike reading and the Open bullet; 07 §7's sentences on moving the reading that gives the stop; 08 §8's bullet; the overview's paragraph; the dossier's scope box, its paragraph on RF's rounds and its account of how it was made; the package's root bullets, both READMEs and the checker's scope sentence; the module's header and docstrings; the record in both languages and the amendments to two related records; the study section's template; PLAN §4.8, §12, §13 and the Evidence list, and for the lenses also its §5 and §8 rows; regions; and the opening and the tables of what was taken in [REVIEW-RFM3-LEAN](REVIEW-RFM3-LEAN.md). Two reads ran on 31 October 2026: the cross-model reader (GPT astra, high effort, read-only, a fresh session `01a18ddb-e3da-78a0-ab08-f6fec1f4bf57`) and a workflow of three Opus readers, one per lens (exactness, readings, fit), each lens's findings given to one reader asked to refute them against the files. The prompts are in [the brief](BRIEF.md#round-2-third-part). The findings and verdicts are verbatim, with the rehearsal worktree's absolute paths made repository-relative and links made to resolve from this folder, since it is link-checked as live: a line number kept in a link's text and dropped from its target, and a link that does not resolve here (an anchor of the page a quotation came from, a path of the rehearsal alone) shown as its text with its target as code.

{SUMMARY} BUILD_SENTENCE

RECHECK_SENTENCE
"""

# What the texts' changes did to the module: a sentence for the opening.
BUILD_SENTENCE = ("For the lenses' findings the module's statements did not change: its header, the docstring of "
                  "`WeightsApart.not_splitsKeep` and one section heading were revised, and it was rebuilt, 138 theorems "
                  "in 186 declarations, every axiom report empty "
                  "([build-6](../kit/round2c/logs/build-6.log)).")
# The re-checks, for the opening, once they have run.
RECHECK_SENTENCE = ("Before the lenses ran, the cross-model reader re-checked, in the session of its cold read, how its "
                    "six points were taken and the texts cut or added since: one point, the reason to keep the valuation "
                    "stated on a shared model wherever it is stated, taken ([the first "
                    "re-check](#the-re-check-of-the-cross-model-readers-points)).")

# What was taken from the cross-model reader: (point, finding, taken).
TAKEN_READER = (
    ('A1', "a revision that changes a decision is said to lose, where `revalued_lowers_iff` needs a listed cell decided "
           "against the current valuation's strict weighted preference (a change at a tie loses nothing)",
     "deciding “a listed cell against the current valuation's strict weighted preference” (or “its”, or “that "
     "valuation's”) wherever the loss is stated: 03 §12's Reading (twice), 07 §7 (with “keep the valuation from such a "
     "revision”), 08 §8, the overview, the dossier, the study, PLAN §4.8 and the record's correspondence, English and "
     "Chinese (有护值免于使某列格之断逆当下严格加权之偏之改值之由)"),
    ('A2', "the record's Chinese law on deciding a whole cell reverses `split_cell_le`'s inequality",
     "整断一格之值不高于分之，当所移之部有得"),
    ('A3', "the record and the study make every act of the holding formation leave the world and the reading formation "
           "unchanged, though demonstrating and presenting change the reading formation",
     "“the holding formation's going on, switching off and holding change neither the candidate world nor the reading "
     "formation” in the record's premise (zh 持之形成之续、止与持不改候选世界亦不改读之形成) and the study, as the "
     "module and the plan say"),
    ('A4', "the record gives every criterion the split's cell-list hypotheses",
     "the record's hypothesis in two items, each law's lists as it takes them: the split needs the cells listed once "
     "each and covering; the residual's criteria need neither; the told criterion only its cell list covering the "
     "holding formation's listing; informing the factoring and the finer map's cells, the strict comparison the "
     "coarser map's as well; the criterion over every refinement the factoring on both listings, the coarse cells "
     "covering the holding formation's listing and the fine cells covering both, each listed once"),
    ('A5', "REVIEW-RFM3-LEAN's row R5 says the coarser map's cells are named only for the criterion over every "
           "refinement and for `refined_lt_iff`, stale after `informed_lt_iff`",
     "the row now says that after the check of the delta (its point 1) the bullet also names the coarser map's "
     "cells, listed once each and covering, for `informed_lt_iff`; the page regenerated from its script"),
    ('A6', "the dossier keeps the placeholder `(WORKS_CHECKED)`",
     "the works named as the design's and the Lean's cross-model reviews read them: Kamenica and Gentzkow's paper in "
     "the American Economic Review, 2011, and arXiv 1908.04734 and 2204.11966; the entry's date is the landing's"),
)

# What was taken from the lenses: id -> (finding, taken), every finding, confirmed or refuted.
TAKEN_LENS = {
    'X1': ("with the weights apart, splits read as never keeping the worth, where `WeightsApart.not_splitsKeep` is one "
           "witness and `splitsKeep_of_off_le_go` holds whatever the models",
           "03 §12: “with the weights apart, a shared valuation can fail to keep it”, after a semicolon, "
           "`splitsKeep_of_off_le_go` said to hold whatever the models; the header and the study: “can break it”; the "
           "record's law: “With the weights apart, splits can fail to keep the worth even with a shared valuation” (zh "
           "权相异，即共值，分亦可不守其值); the docstring title of `WeightsApart.not_splitsKeep` the same"),
    'X2': ("the root bullet and the checker's scope say “every refinement” without the factoring on both listings that "
           "`refining_never_lowers_iff` takes",
           "both: “over every refinement factoring on both (formations') listings” and “through the finer map”; both "
           "also give the split its cells, listed once each and covering"),
    'X3': ("03 §12 and the study say “on the holding formation's model” where `own_least`, `revalued_lowers_iff` and "
           "`outcome_least` need the reading formation's model to be the holding formation's",
           "“with the reference the reading formation's own current valuation and its model the holding formation's”, "
           "as the header and the record say, and “with that shared model” before `outcome_least`, in both"),
    'X4': ("the record's law on `outcome_least` states no model condition, and its hypothesis leaves it out of the "
           "theorems taking the shared model",
           "the law opens “With the reading formation's model the holding formation's” (zh "
           "读之形成之模型即持之形成之模型，则), and the hypothesis lists `outcome_least` with `own_least`, "
           "`revalued_lowers_iff`, `revaluing_gain` and `revaluing_gains_iff`, in both languages"),
    'X5': ("“with both answers least” given as the hypothesis of `forgone_least_iff` and `coarser_not_above`, which "
           "assume a shared model and net agreement",
           "“with a shared model and net agreement” (and “so both answers least” where it fits) in 03 §12, the header, "
           "the study, the record's law (zh 共模型且净相合（故二答皆最少）, the English at 418 of its 420 characters), "
           "the plan's item 7 and §13, and the Lean review's row F20"),
    'X6': ("“at one model” for `revalued_split` and `revalued_forgone_lt_iff`, which take the two formations' models "
           "apart",
           "“with both formations' models, the reference and the map fixed” in 03 §12, the study, the record's law (zh "
           "二形成之模型、参照与映射皆定) and the plan's item 8"),
    'X7': ("the header's told sentence and its sentence on `refined_lt_iff` omit their cell conditions, and the Lean "
           "review's row R5 says the header names the coarser cells for `refined_lt_iff`",
           "the header: “over cells covering the holding formation's listing” for the told criterion and “both maps' "
           "cells listed once each and covering the holding formation's listing” for `refined_lt_iff`; R5 says what was "
           "named when, its page regenerated"),
    'X8': ("the record's carrier law says a world is sensed, where a demonstration gives what it shows",
           "“what a demonstration shows, an input presented, or asked” (zh 示之所显、所呈之入或问)"),
    'X9': ("the dossier's “From different starts the answers and the final state do not tell” reads as general from "
           "one witness",
           "“From different starts a route informing and one revaluing can answer alike and end in one state, so the "
           "answers and the final state need not tell whether the valuation changed”, in 07's and the overview's terms"),
    'X10': ("the record's Chinese law on informing has a clause the English lacks",
            "the clause dropped from the Chinese, the English being at its cap"),
    'X11': ("the Chinese README row and alias parse as informing acting on the valuation",
            "告读之形成与改其值, in the row and in the alias"),
    'X12': ("the plan's cells {1, 2} and {3} count from one, where the candidates are 0, 1 and 2",
            "“the cells of the first two candidates and of the third” in items 8 and 10, as the header and the record say"),
    'X13': ("the plan makes the weights part of the revisable listing",
            "“its *listing* (candidate worlds, weighted by its law)”, the header's words"),
    'X14': ("the plan's item 4 title drops that the unweighted candidate is one the holding formation weighs",
            "“exactly where a candidate the holding formation weighs, unweighted by the reading formation, is one to stop”"),
    'X15': ("the plan's “weaker than the answer being least at every cell” claims an implication no theorem states",
            "dropped; the next sentence already says splits keep the worth even where the answer has a residual "
            "(`release_keeps`)"),
    'X16': ("the plan's “the course forms of the four cases”, which cover the two turning cases",
            "“the course forms of the two turning cases, `TwoWorlds.shown_course` and `TwoWorlds.presented_course`”"),
    'X17': ("rows A10, F14, L9 and R1 of the Lean review do not match the texts as they stand",
            "in the generator, and the page regenerated: A10 holds once the study names `cond_zero_le` beside "
            "`total_lt_of_mem` (T29) and says so; F14 and L9 corrected through entries made after the check; R1 without "
            "“and correspondence”"),
    'X18': ("the record cites this page before it exists, and the plan's Evidence does not name it",
            "this page written and the study's paragraph filled before registration; the plan's Evidence names the page, "
            "and §13 has a paragraph on the cold read of the third part's texts"),
    'X19': ("08 §8's bullet on RR says holding an act for a reading is the bullet above's, where it is the next one",
            "RR's text, already on main: given to RR's second item, whose landing, after RF-M.3's, makes it “the next "
            "bullet's”"),
    'R1': ("the dossier gives the preservation incentive to current-reward-function evaluation as such, where their "
           "Claim 2 gives it to the agent that anticipates time inconsistency and their Claim 3 none to the one that "
           "ignores it",
           "“the preservation incentive of current-reward-function evaluation by an agent that anticipates time "
           "inconsistency (Everitt, Hutter, Kumar and Krakovna 2021, Claim 2)”"),
    'R2': ("the same in the record's correspondence",
           "“preservation incentive for an agent anticipating time inconsistency (Everitt et al. 2021, Claim 2)” (zh "
           "以当下奖励函数评估而顾及时间不一致者之保存之诱因), within the cap"),
    'R3': ("08 §8 and the study name current-reward-function evaluation in general",
           "“current-reward-function evaluation by an agent that anticipates time inconsistency”, and “their Claim 2 "
           "permits that agent”, in both"),
    'R4': ("the dossier's sentence on different starts generalizes one witness and drops that the start tells the "
           "routes apart",
           "refuted (one colliding pair shows the record does not determine the property); met all the same by X9's "
           "wording"),
    'R5': ("the plan's §8 row drops “can” and that with the start the record determines the property",
           "refuted; the row brought to the dossier's wording all the same, as clearer and harmless: “can answer alike "
           "and end in one state, so the answers and the final state need not tell whether it changed”"),
    'R6': ("the module, 03 §12 and the plan say the holding formation's choice is represented by the comparisons, "
           "where `Revaluing.revaluing_best` represents no choice; the plan adds 13",
           "the module: “No choice by the holding formation among these is represented: only the worth comparisons of "
           "… and the four valued alternatives of `Revaluing.revaluing_best`, relate them”; 03 §12 and the plan "
           "likewise, the plan naming 7, 8 and 14"),
    'R7': ("the record drops “deterministic” from the off-switch reading",
           "“for a deterministic constant policy” (zh 于确定且恒定之策)"),
    'R8': ("the Lean review's re-check row R1 says the record's correspondence says “from one state of each formation”",
           "“the record's laws, 03 §12's paragraph and the study likewise”, the page regenerated"),
    'R9': ("the overview, the dossier and the record state the incentive to revise without the supplied update's "
           "reach, the overview also without costs",
           "the overview and the dossier: “incentives, before costs, to withhold and, where the supplied update reaches "
           "such a valuation, to revise”; the record: “(if the update reaches it), before costs” (zh 若所予之更新可达)"),
    'R10': ("in 03 §12 the sender-favouring tie-break reads as a reason the weights apart lie outside their model",
            "“their receiver breaks ties in the sender's favour, where the answer here releases; their prior is "
            "common, so the weights apart lie outside their model”"),
    'R11': ("“by them” in 03 §12 can be read as Carroll and others' own verdict",
            "“evaluated by the current valuation, a revision deciding a listed cell against its strict weighted "
            "preference counts as a loss”; their very crude baseline kept as the design's and the Lean's checks of the "
            "paper read it"),
    'R12': ("03 §12's “what a reader of the answers alone leaves open” generalizes the witness",
            "refuted (the labelled Reading scopes it to the witness just stated); not changed"),
    'R13': ("the module's Standing, 08 §8, the plan's Standing and the study name the contribution by its reading, "
            "withholding against informing, unmarked",
            "“the thresholds with amounts forgone (read as withholding against informing) and of revaluing” in all four; "
            "the module's section heading and the plan's item 7 title likewise"),
    'R14': ("08 §8 and the record state the counterpart of Kamenica and Gentzkow's condition without the reading label",
            "refuted (RF-M.2's landed convention: restatements in 08 §8 and the record's counts, readings labelled); not "
            "changed"),
    'T1': ("the weights apart said to break the criterion in 03 §12, the study, the record and the header",
           "as X1"),
    'T2': ("“its answer” in 03 §12 and 07 §7 binds to the replacement valuation, where `revaluing_gains_iff`'s "
           "condition is the current answer's residual",
           "“the current answer” in 03 §12, “its current answer” in 07 §7"),
    'T3': ("“at one model” in 03 §12, the record, the study and the plan's item 8",
           "as X6"),
    'T4': ("the dossier's sentence on different starts and the plan's §8 row drop the witness qualifier",
           "refuted; met all the same by X9's and R5's wording"),
    'T5': ("the overview's paragraph, cut for a reading budget, keeps that a finer map never raises the least "
           "shortfall but drops that it can raise the residual by more, states no standing and glosses no residual",
           "“Proved in natural-number counts: … plus a residual, positive exactly where the answer decides a listed cell "
           "against the reference's strict weighted preference; a finer map never raises the first but can raise the "
           "second by more than it lowers the first”"),
    'T6': ("no kit step brings the plan to the landing: §12 says built in the kit, §13 has no paragraph on the cold "
           "read, the Evidence omits this page",
           "integrate_rfm3.py sets §12's entry to “(§4.8, landed)” at the landing, as integrate_rfm2.py did, and its "
           "docstring says so; §13's paragraph and the Evidence entry added"),
    'T7': ("“them” in 03 §12 can bind to the authors",
           "refuted; met all the same by R11's change"),
    'T8': ("03 §12's sentence on courses alike does not parse and leaves out `answer_constant`'s case",
           "“so they are alike wherever no demonstration is emitted or none tells the listed worlds apart, and there "
           "holding for the answer is worth one committed move”; the study and the header likewise"),
    'T9': ("“the first” and “the second” read as worlds, and the study's (a) and (b) are never introduced",
           "“in the course shown” and “in the course presented”, in 03 §12 and the study"),
    'T10': ("03 §12 and the study say an input is compared with a valuation by the residuals",
            "“holding for the answer after one presented input, forgoing an amount, stands above holding for the "
            "current answer, forgoing another, exactly where its residual through the one cell and its amount together "
            "fall below the other's”, in both"),
    'T11': ("03 §12's premises omit costs entering as amounts forgone",
            "refuted (worth before any amount forgone is accurate, the laws adding the amounts); not changed"),
    'T12': ("the tie-break joined by “so” to the common prior in 03 §12",
            "as R10, with the semicolon"),
    'T13': ("“the least shortfall reads only the map and the residual only the deciding” would keep the residual from "
            "moving with the map",
            "“By a reference on the holding formation's model, the least shortfall is fixed by the map and the residual "
            "is what the deciding adds through it”"),
    'T14': ("§12's opening uses “the reading formation” before the section introduces it, and “the least shortfall "
            "through it” is not tied to RF-M.2's quantity",
            "refuted; not changed"),
    'T15': ("07 §7's sentence runs to 115 words",
            "refuted (a matter of style, each clause attached); not changed but for T2's word"),
    'T16': ("the dossier's scope box ties the principal to no role, and its “learning beyond what it is shown” is wider "
            "than 03's",
            "“move within one law (below, as the reading formation's), and the principal's learning beyond filtering by "
            "what it is shown is not represented”"),
    'T17': ("the dossier's account of how it was made names only the sentences added",
            "“RF-M.3's sentences and its changes to the assistance-games clause and round 2's sentence, made on …”"),
    'T18': ("the record's next step omits the reading formation's learning beyond filtering by what it is shown, and the "
            "amendments say “beyond what it is shown”",
            "the next step names it (384 of its 400 characters; zh 读之形成依所示而滤以外之学), and the amendments' next "
            "steps and history lines and the register's reason say “beyond filtering by what it is shown”"),
    'T19': ("the related detail files revaluing under informing",
            "“Informing and revaluing within one law: … and an input presented revising its valuation” (zh "
            "一律之内之告与改值：…呈一入改其值)"),
    'T20': ("“a route revalued” in the checker's scope, the root bullet and the board's text; the scope without "
            "revaluing's law or the map",
            "“a route presented” in all three; the scope adds “revaluing changes only the residual” and “through the "
            "finer map”"),
    'T21': ("the READMEs and 08 §8 name the group by its reading, unmarked",
            "the README: “amounts forgone, read as withholding against informing” (zh 舍量，读为扣告与告); 08 §8 and "
            "the module's, the study's and the plan's Standing as R13"),
    'T22': ("the plan's §4.7 paragraph on RF-M.3 says not built and keeps the old name",
            "“(redesigned and built in §4.8, where 'shaping' became 'revaluing')”; §4.7's heading kept, since it is "
            "linked"),
    'T23': ("the study's output and input omit the plan's §5 and §8 rows",
            "“(§4.8, §5's and §8's rows, §12, §13 and Evidence)”"),
    'T24': ("the study, the plan and the Lean review say six were completed with nine declarations, where four were "
            "and two in prose; the plan's “four cases”",
            "“six … completed, four with nine declarations (…) and two in prose (…)” in the study, the plan and the "
            "Lean review's opening; the plan's “the two turning cases”"),
    'T25': ("the plan's cells counted from one",
            "as X12"),
    'T26': ("the plan's §5 row calls the gain under a reference a reading, where it is a law",
            "“its laws read as an incentive to revise under a reference the valuation does not share and, by the "
            "reading formation's current valuation on a shared model, a reason to keep it from a revision …”"),
    'T27': ("the Lean review's prefix repeats “not real” in E10 and F16, and its opening says revised on the "
            "forty-nine real findings",
            "the prefix only where the row does not say so; the opening: “revised on all fifty-one lens findings (the "
            "two judged not real taken anyway)”"),
    'T28': ("the Lean review's row F14 says `joint`'s docstring says more than it does",
            "as X17: the row says what the docstring says"),
    'T29': ("A10 says the study leaves both lemmas' extraction to their owners, where it names only "
            "`total_lt_of_mem`",
            "the study's self-review names `cond_zero_le`, repeating `Weighting.term_le_of`, beside it, one statement "
            "of each left to its module's owner, and A10 says so"),
    'T30': ("the Lean review's re-check row R1 names the record's correspondence",
            "as R8"),
    'T31': ("no blank line before the Lean review's first heading",
            "refuted (it renders); taken all the same: a blank line"),
}

# The two re-checks: (heading, what was read, what was taken: (point, status, how)).
RECHECKS = (
    ("The re-check of the cross-model reader's points",
     "The cross-model reader, in the session of its cold read, read how its six points were taken and, as new text, "
     "the overview's paragraph and the dossier's sentences cut for reading budgets, the plan's §5 and §8 rows and the "
     "study's paragraph on the reviews, read-only, in a rehearsal rebuilt at the same path on the kit at `18001d918` "
     "with main at `8a8b0df82`. Verbatim; its line numbers are those of the version it read.",
     (('1', 'taken',
       "the two rows as it gives them (§5's “by the reading formation's current valuation on a shared model a reason "
       "to keep it from a revision deciding a listed cell against its strict weighted preference”, §8's corrigibility "
       "row the same); and, where the same claim is stated without the shared model, 08 §8's bullet (“evaluating by "
       "the reading formation's current valuation on a shared model”), the study's standing (“by the current "
       "valuation on a shared model no revaluation gains”) and the record's correspondence (“on a shared model, a "
       "reason to keep the valuation”, zh 共模型时), `own_least` and `revalued_lowers_iff` both evaluating on the "
       "holding formation's model; kit `6837be33a`, the record's caps passing"),)),
    ("The re-check of what was taken from the lenses",
     "RECHECK2_READ",
     ()),
)

reader = cx_body(reader_md)
results = json.loads(lens_json.read_text(encoding='utf-8'))
blocks, rows, counts = [], [], {'confirmed': 0, 'refuted': 0, 'unverified': 0}
for result in results:
    key = result['lens']
    verdicts = {v['id']: v for v in ((result.get('verdicts') or {}).get('verdicts') or [])}
    for f in result['found']['findings']:
        fid = f['id']
        v = verdicts.get(fid)
        state = ('confirmed' if v['real'] else 'refuted') if v else 'unverified'
        counts[state] += 1
        block = [f"### {fid} ({key}, {f['severity']}, {state})", '',
                 f"**Location.** {relinked(f['location'])}", '',
                 f"**Quoted.** {relinked(f['quote'])}", '',
                 f"**Problem.** {relinked(f['problem'])}", '',
                 f"**Replacement.** {relinked(f['replacement'])}", '']
        if v:
            block += [f"**Verdict: {'real' if v['real'] else 'not real'}.** {relinked(v['reason'])}", '']
            better = (v.get('better_replacement') or '').strip()
            if better:
                block += [f'**Better replacement.** {relinked(better)}', '']
        blocks.append('\n'.join(block))
        assert fid in TAKEN_LENS, f'{fid}: no entry in TAKEN_LENS'
        short, taken = TAKEN_LENS[fid]
        rows.append(f"| {fid} | {key} | {state} | {cell(short)} | {cell(relinked(taken))} |")
reported = {r.split(' | ')[0][2:] for r in rows}
assert set(TAKEN_LENS) == reported, ('TAKEN_LENS names a finding not reported', set(TAKEN_LENS) - reported)

total = sum(counts.values())
summary = (f"The cross-model reader reported {len(TAKEN_READER)} points, every one taken. The lenses reported {total} "
           f"findings, {counts['confirmed']} confirmed and {counts['refuted']} refuted by their refuters"
           + (f", {counts['unverified']} not verified" if counts['unverified'] else '')
           + "; what each became is in [the table](#what-was-taken-from-the-lenses).")
intro = INTRO.replace('{SUMMARY}', summary).replace('BUILD_SENTENCE', BUILD_SENTENCE)
intro = intro.replace('RECHECK_SENTENCE', RECHECK_SENTENCE if any(recheck_mds) else '')
assert 'BUILD_SENTENCE' not in intro and 'RECHECK_SENTENCE' not in intro, 'a sentence of the opening is not written'
parts = [intro.rstrip('\n') + '\n', '## The cross-model reader\n', relinked(reader) + '\n',
         '### What was taken from the cross-model reader\n', '| # | Finding | Taken |', '|---|---|---|']
parts += [f'| {p} | {cell(f)} | {cell(t)} |' for p, f, t in TAKEN_READER]
parts.append('\n## The three lenses\n')
parts += blocks
parts += ['### What was taken from the lenses\n', '| # | Lens | Verdict | Finding | Taken |', '|---|---|---|---|---|']
parts += rows
for md, (heading, read, taken) in zip(recheck_mds, RECHECKS):
    if md is None:
        continue
    assert 'RECHECK2_READ' not in read, 'the second re-check is not described'
    parts += [f'\n## {heading}\n', read + '\n', relinked(cx_body(md)) + '\n',
              f'### What was taken from {heading[0].lower()}{heading[1:]}\n',
              '| Point | Status | How |', '|---|---|---|']
    parts += [f'| {p} | {s} | {cell(h)} |' for p, s, h in taken]
text = '\n'.join(parts) + '\n'
assert '](/' not in text and not any(root in text for root in ROOTS)
OUT.write_text(text, encoding='utf-8')
print(OUT.relative_to(STUDY.parents[0]), len(text), 'characters;', len(TAKEN_READER), 'points,', total, 'findings', counts)
