"""Write evidence/REVIEW-RFM2-COLDREAD.md: the cold read of RF-M.2's texts, verbatim, and what was taken.

Inputs (saved where the reads ran): the cross-model reader's cold read (markdown) and the workflow's result, the three
lenses' findings with their refuters' verdicts (JSON: a list of {lens, findings, verdicts}). Usage, from the repository
root:

    python3 -B <this file> <cross-model cold read .md> <lens results .json>
"""
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
STUDY = HERE.parents[1]
OUT = STUDY / 'evidence' / 'REVIEW-RFM2-COLDREAD.md'
ROOTS = ('/private/tmp/claude-501/-Users-ren-theories/50635de9-b91e-4f4c-a63c-8413ce8c4652/scratchpad/wt-rfm2-rehearse/',
         '/Users/ren/theories/.claude/worktrees/rf-landing/')

reader_md, lens_json = (Path(x) for x in sys.argv[1:3])


def unlink(text):
    """Links unlinked, since this folder is link-checked as live; paths made relative to the checkout."""
    for root in ROOTS:
        text = text.replace(root, '')
    return text.replace('](', '\\](')


INTRO = """# The cold read of RF-M.2's texts

RF round 2, second part, RF-M.2: an act held for a reading (plan §4.7). Before the landing of RF-M.2's documents, its texts were cold-read against the Lean of `Becoming.HeldForReading` (`kit/round2b/tree/Becoming/HeldForReading.lean`, 90 theorems in 120 declarations, every axiom report empty), as the kit's integration applied them to main in a rehearsal worktree (the kit at `6d5f244be`, main at `59ca8c812`): 03 §12's opening, its new theorem paragraph with its Reading, the pointer in the acts-alike reading and the Open bullet; 07 §7's sentence on an incentive to accept a correction; 08 §8's bullet; the overview's paragraph; the dossier's scope box, its paragraph on RF's rounds and its account of how it was made; the package's root bullets, both READMEs and the checker's scope sentence; the module's header and docstrings; the record in both languages and the amendments to three related records; the study section's template; PLAN §4.7, §8's row on assistance games, §12, §13 and the Evidence list; regions; the board's texts; and the opening, the literature table and the two tables of what was taken in [REVIEW-RFM2-LEAN](REVIEW-RFM2-LEAN.md). Two reads ran: the cross-model reader (GPT astra, high effort, read-only, a fresh session) and a workflow of three Opus readers, one per lens (exactness, readings, fit), each lens's findings given to one reader asked to refute them against the files. The prompts are in [the brief](BRIEF.md#round-2-second-part). The findings and verdicts are verbatim, with the rehearsal worktree's absolute paths made repository-relative and links shown unlinked (`]\\(`), their targets being relative to the texts' own folders.

{SUMMARY}
"""

# What was taken from the cross-model reader: (point, finding, taken).
TAKEN_READER = (
    ('A1', "the overview drops the open acts of the policy compared",
     "“a policy choosing open acts falls short of one best at every listed candidate”, as the root bullet and the "
     "checker's scope say"),
    ('A2', "“a reading that stops or releases” does not name the reading `held_gains_iff` concerns, and the overview "
           "drops “strict”",
     "“the reading that stops where the loss exceeds the gain” and “both strict signs” in the overview and the "
     "board's landing sentence, “the reading that stops where going on loses” in the dossier, and the reading so "
     "named in both package READMEs (为损逾得处即止之读而持); the module's section titles, which name the kind of "
     "reading, stay"),
    ('A3', "the root bullet and the checker's scope drop `reach_fixes`'s conditions",
     "“where every listed candidate of positive weight has transitive comparisons according with the choices” in both"),
    ('A4', "PLAN's held start omits where going on loses",
     "PLAN §4.7 item 7: “holding first with the listing of gain alone, where going on loses”, “by the witness's "
     "default” and “listing both signs and holding first”; the record's second counterexample likewise, English and "
     "Chinese, citing `SignLoop.refuted_drops` and saying “not followed” for “disregarded”, as its Chinese 不从 says"),
    ('A5', "the witness docstrings omit the held start",
     "“holding from the start” in the docstrings of `both_stopped`, `both_turns_off` and `both_off`, “the same "
     "listing and start” in those of `both_released`, `both_goes_on` and `both_on`, and “holding first” in the "
     "header's witness; the module rebuilt, its statements unchanged, every axiom report empty "
     "(`kit/round2b/logs/build-21.log`)"),
    ('A6', "the literature table gives Equation 1's terms as positive and negative parts",
     "“the smaller of two signed expectations, of the negated utility times the chance that the human switches it "
     "off and of the utility times the chance that the human lets it act; for a policy other than the rational one "
     "either can be negative”, checked against the paper's text (arXiv 1611.08219v3, Equation 1)"),
    ('A7', "03 §12's opening counts four laws and lists five", "“Five laws”"),
    ('A8', "five rows of REVIEW-RFM2-LEAN's first table describe states that later changes completed",
     "E3, E5, E14 and L1 updated after the check and F11 after the re-check (its point 7), each row now describing "
     "the module, the record and the plan as they stand"),
)

# What was taken from the lenses: id -> taken (every finding, confirmed or refuted).
TAKEN_LENS = {}

reader = reader_md.read_text(encoding='utf-8')
reader = reader[:reader.index('\n── cx ·')].rstrip('\n')
lenses = json.loads(lens_json.read_text(encoding='utf-8'))
LETTER = {'exactness': 'E', 'readings': 'R', 'fit': 'F'}

blocks, rows, counts = [], [], {'confirmed': 0, 'refuted': 0, 'unverified': 0}
for lens in lenses:
    key = lens['lens']
    verdicts = {v['number']: v for v in (lens.get('verdicts') or [])}
    for i, f in enumerate(lens['findings'], 1):
        fid = f'{LETTER[key]}{i}'
        v = verdicts.get(i)
        state = ('confirmed' if v['real'] else 'refuted') if v else 'unverified'
        counts[state] += 1
        block = [f"### {fid} ({key}, {f['severity']}, {state})", '',
                 f"**Location.** {unlink(f['location'])}", '',
                 f"**Quoted.** {unlink(f['quote'])}", '',
                 f"**Problem.** {unlink(f['problem'])}", '',
                 f"**Replacement.** {unlink(f['replacement'])}", '']
        if v:
            block += [f"**Verdict: {'real' if v['real'] else 'not real'}.** {unlink(v['reason'])}", '']
            better = (v.get('better_replacement') or '').strip()
            if better:
                block += [f'**Better replacement.** {unlink(better)}', '']
        blocks.append('\n'.join(block))
        assert fid in TAKEN_LENS, f'{fid}: no entry in TAKEN_LENS'
        short, taken = TAKEN_LENS[fid]
        rows.append(f"| {fid} | {key} | {state} | {short} | {taken} |")
assert set(TAKEN_LENS) == {r.split(' | ')[0][2:] for r in rows}, 'TAKEN_LENS names a finding not reported'

total = sum(counts.values())
summary = (f"The cross-model reader reported {len(TAKEN_READER)} points, every one taken. The lenses reported {total} "
           f"findings, {counts['confirmed']} confirmed and {counts['refuted']} refuted by their refuters"
           + (f", {counts['unverified']} not verified" if counts['unverified'] else '')
           + "; what each became is in [the table](#what-was-taken-from-the-lenses).")
parts = [INTRO.replace('{SUMMARY}', summary), '## The cross-model reader\n', unlink(reader) + '\n',
         '### What was taken from the cross-model reader\n', '| # | Finding | Taken |', '|---|---|---|']
parts += [f'| {p} | {f} | {t} |' for p, f, t in TAKEN_READER]
parts.append('\n## The three lenses\n')
parts += blocks
parts += ['### What was taken from the lenses\n', '| # | Lens | Verdict | Finding | Taken |', '|---|---|---|---|---|']
parts += rows
text = '\n'.join(parts) + '\n'
assert '](/' not in text and not any(root in text for root in ROOTS)
OUT.write_text(text, encoding='utf-8')
print(OUT.relative_to(STUDY.parents[0]), len(text), 'characters;', len(TAKEN_READER), 'points,', total, 'findings', counts)
