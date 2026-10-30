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

RF round 2, third part, RF-M.3: the valuation as state; informing and revaluing (plan §4.8). Before RF-M.3's landing, its texts were cold-read against the Lean of `Becoming.ListingValuation` (`kit/round2c/tree/Becoming/ListingValuation.lean`, 138 theorems in 186 declarations, every axiom report empty), as the kit's integration applied them to main in a rehearsal worktree (the kit at `07a24e169`, main at `1ec20513d`): 03 §12's opening, its new theorem paragraph with its Reading, the pointer in the acts-alike reading and the Open bullet; 07 §7's sentences on moving the reading that gives the stop; 08 §8's bullet; the overview's paragraph; the dossier's scope box, its paragraph on RF's rounds and its account of how it was made; the package's root bullets, both READMEs and the checker's scope sentence; the module's header and docstrings; the record in both languages and the amendments to two related records; the study section's template; PLAN §4.8, §12, §13 and the Evidence list; regions; and the opening and the tables of what was taken in [REVIEW-RFM3-LEAN](REVIEW-RFM3-LEAN.md). Two reads ran on 31 October 2026: the cross-model reader (GPT astra, high effort, read-only, a fresh session `01a18ddb-e3da-78a0-ab08-f6fec1f4bf57`) and a workflow of three Opus readers, one per lens (exactness, readings, fit), each lens's findings given to one reader asked to refute them against the files. The prompts are in [the brief](BRIEF.md#round-2-third-part). The findings and verdicts are verbatim, with the rehearsal worktree's absolute paths made repository-relative and links made to resolve from this folder, since it is link-checked as live: a line number kept in a link's text and dropped from its target, and a link that does not resolve here (an anchor of the page a quotation came from, a path of the rehearsal alone) shown as its text with its target as code.

{SUMMARY} BUILD_SENTENCE

RECHECK_SENTENCE
"""

# What the texts' changes did to the module: a sentence for the opening.
BUILD_SENTENCE = 'BUILD_SENTENCE'
# The re-check, for the opening, once it has run.
RECHECK_SENTENCE = 'RECHECK_SENTENCE'

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
AS = "as the cross-model reader's "
TAKEN_LENS = {
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
