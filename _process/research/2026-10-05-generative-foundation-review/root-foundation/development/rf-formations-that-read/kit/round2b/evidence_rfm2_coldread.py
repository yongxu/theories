"""Write evidence/REVIEW-RFM2-COLDREAD.md: the cold read of RF-M.2's texts, verbatim, and what was taken.

Inputs (saved where the reads ran): the cross-model reader's cold read (markdown) and the workflow's result, the three
lenses' findings with their refuters' verdicts (JSON: a list of {lens, findings, verdicts}), and the cross-model reader's
re-check of how they were taken (markdown); what was taken from the re-check is RECHECK. Usage, from the repository root:

    python3 -B <this file> <cross-model cold read .md> <lens results .json> <re-check .md>
"""
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
from relink_rfm2 import relink  # noqa: E402

STUDY = HERE.parents[1]
OUT = STUDY / 'evidence' / 'REVIEW-RFM2-COLDREAD.md'
ROOTS = ('/private/tmp/claude-501/-Users-ren-theories/50635de9-b91e-4f4c-a63c-8413ce8c4652/scratchpad/wt-rfm2-rehearse/',
         '/Users/ren/theories/.claude/worktrees/rf-landing/')

reader_md, lens_json, recheck_md = (Path(x) for x in sys.argv[1:4])


def relinked(text):
    """Paths made relative to the checkout, and links made to resolve from this folder (relink_rfm2.py)."""
    for root in ROOTS:
        text = text.replace(root, '')
    return relink(text)


INTRO = """# The cold read of RF-M.2's texts

RF round 2, second part, RF-M.2: an act held for a reading (plan §4.7). Before RF-M.2's landing, its texts were cold-read against the Lean of `Becoming.HeldForReading` (`kit/round2b/tree/Becoming/HeldForReading.lean`, 90 theorems in 120 declarations, every axiom report empty), as the kit's integration applied them to main in a rehearsal worktree (the kit at `6d5f244be`, main at `59ca8c812`): 03 §12's opening, its new theorem paragraph with its Reading, the pointer in the acts-alike reading and the Open bullet; 07 §7's sentence on an incentive to accept a correction; 08 §8's bullet; the overview's paragraph; the dossier's scope box, its paragraph on RF's rounds and its account of how it was made; the package's root bullets, both READMEs and the checker's scope sentence; the module's header and docstrings; the record in both languages and the amendments to three related records; the study section's template; PLAN §4.7, §8's row on assistance games, §12, §13 and the Evidence list; regions; the board's texts; and the opening, the literature table and the two tables of what was taken in [REVIEW-RFM2-LEAN](REVIEW-RFM2-LEAN.md). Two reads ran: the cross-model reader (GPT astra, high effort, read-only, a fresh session) and a workflow of three Opus readers, one per lens (exactness, readings, fit), each lens's findings given to one reader asked to refute them against the files. The prompts are in [the brief](BRIEF.md#round-2-second-part). The findings and verdicts are verbatim, with the rehearsal worktree's absolute paths made repository-relative and links made to resolve from this folder, since it is link-checked as live: a line number kept in a link's text and dropped from its target, and a link that does not resolve here (an anchor of the page a quotation came from, a path of the rehearsal alone) shown as its text with its target as code.

{SUMMARY} The module's statements are unchanged; its header and docstrings changed with the findings, and it was rebuilt after each change, last at 90 theorems in 120 declarations, every axiom report empty and no warnings ([build-25](../kit/round2b/logs/build-25.log)).

**The re-check.** How the findings were taken was then re-checked by the cross-model reader, in the cold read's session, read-only, in the rehearsal rebuilt on main with the kit integrated and the diff of the kit's changes since the cold read at its root ([below](#the-re-check); its prompt is in [the brief](BRIEF.md#round-2-second-part)): one point, F32's correction not yet on REVIEW-RFM2-LEAN's page, and no new error. The page was regenerated from its script ([its table](#what-was-taken-from-the-re-check)).
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

# What was taken from the lenses: id -> (finding, taken), every finding, confirmed or refuted.
AS = "as the cross-model reader's "
TAKEN_LENS = {
    'E1': ("the overview extends `held_gains_iff` to any reading that stops or releases", AS + "A2"),
    'E2': ("the dossier extends it likewise", AS + "A2: “the reading that stops where going on loses”, “both strict signs”"),
    'E3': ("the board's landing sentence extends it likewise", AS + "A2"),
    'E4': ("“Four laws” before five", AS + "A7"),
    'E5': ("the threshold bounds a sum, which “its shortfall and the amount are at most” does not say",
           "“together” in 03 §12 (“above it exactly where together they fall below it”), PLAN §4.7 item 4 and the study"),
    'E6': ("the other summaries of the sum likewise, and the record's English statement and cells law",
           "“shortfall plus amount” in the record's statement and “that least shortfall plus the amount” in its cells "
           "law; “together” in the root bullet, the checker's scope, the overview, both passages of the dossier, 07 §7, "
           "the board and the header's cells line"),
    'E7': ("the overview drops the open acts of `after_add_gap`", AS + "A1"),
    'E8': ("`ShownOrder` is already imported by `ReadingLoop`",
           "its root bullet says “Imported by `Becoming.ReadingLoop` and `Becoming.HeldForReading`”; the study says "
           "`ReadingLoop` is no longer a leaf and `ShownOrder` was already imported by it, and its Output → input "
           "“ReadingLoop now imported, ShownOrder's importers corrected”; the re-point reason likewise"),
    'E9': ("the root bullet and the checker's scope drop `reach_fixes`'s conditions", AS + "A3"),
    'E10': ("“the paper's Remark 1” follows Blackwell's paper",
            "“the off-switch paper's Remark 1” in the record (zh 关机博弈一文之注一); Remark 1 added to PLAN §4.7 item 4, "
            "so that §13's “carried into the record and the plan” holds"),
    'E11': ("rows of REVIEW-RFM2-LEAN describe states later changes replaced",
            "A6, A9, E7 and F10 updated after the check, beside " + AS + "A8 (E3, E5, E14, F11, L1); PLAN §4.7 item 7 "
            "now cites `SignLoop.refuted_senses_stop`, `SignLoop.refuted_drops` and `SignLoop.refuted_goes_on`, as "
            "re-check row 8 says"),
    'E12': ("“proposed to the owners”, though no proposal was made",
            "“left for a board proposal to the owners (none made yet)” in A8, re-check row 9 and PLAN §13"),
    'E13': ("`Interleavings.total_single` names no declaration",
            "`Interleavings.LocalLaw.total_single` in `total_single`'s docstring and in A8"),
    'E14': ("PLAN's “with both conditions” keeps the dropped asymmetry",
            "“with comparisons transitive and according with the choices alone” and `pair_gains_unreached`"),
    'E15': ("the record's law of the witness gives going on's value only",
            "the verifier's replacement: “the gain one where going on gains, the loss one where it loses, else "
            "nothing”, zh 得于续得处为一、损于续损处为一，余皆为零"),
    'E16': ("“rank as the shown reach does” reads as equality",
            "“contain the shown reach, ranking one alternative above another wherever it reaches the other”, zh 含所示之及"),
    'E17': ("the acts-alike amendment calls the later item the principal's order", "as F19"),
    'E18': ("“a map … never falls short by more”",
            "“through a map telling apart all a coarser one does, the least shortfall never increases” in the header; "
            "“the least shortfall never increasing through a finer map” in PLAN §13"),
    'E19': ("Good's proviso is relaxed for the two moves only", "“for the two moves” in 03 §12's Reading"),
    'E20': ("the cells' total and the witness's resting cite no theorem",
            "`HeldForReading.shortfall_through` cited in 03 §12 and the root bullet, and "
            "`HeldForReading.SignLoop.rests_unread` in the root bullet"),
    'E21': ("PLAN's parenthesis pairs the two excesses in the wrong order",
            "the verifier's replacement: “the excess of switching off is `T E[(−U)⁺]` and that of going on `T E[U⁺]`”"),
    'E22': ("PLAN's held start omits where going on loses", AS + "A4, with the three theorems cited (as E11)"),
    'E23': ("PLAN §8 gives Good's inequality for a cell, which no theorem states",
            "“through a reading that tells only a cell the two-move threshold and refinement (`through_threshold_iff`, "
            "`finer_least_le`)”, as R14"),
    'E24': ("`Population.total_congr_on` and `Dissipation.total_eq_zero` are not names",
            "“`total_congr_on` (Population), `total_eq_zero` (Dissipation)” in the study"),
    'E25': ("“rank them above the other” leaves the pick unsaid",
            "“each valued one where a candidate's decided comparisons rank the alternative picked above the other”"),
    'E26': ("the record's hypotheses omit that the compared policies and acts are open",
            "“and the policies and acts compared open at the listed candidates” in the record (zh 所比之策与行于列候选皆可取) "
            "and the study's premises"),
    'E27': ("the incentive reading carries no label in 07 and the dossier",
            "07: “read as an incentive to accept it [AI reading]” (as R13); the dossier: “which RF reaches [AI reading] "
            "only on a formation's own model”"),
    'E28': ("08's “the paper's Remark 1” follows Blackwell's paper", "“the off-switch paper's Remark 1”, as F8"),
    'E29': ("“choosing so” has no antecedent",
            "“a formation holding exactly where holding for the reading gains over both moves on its own model” in the "
            "overview, the dossier, the root bullet, the checker's scope and the board"),
    'R1': ("03 §12 credits the whole threshold to Remark 1, though the paper's game has no cost of waiting",
           "the verifier's replacement: the openness less the shortfall is the incentive Remark 1 places qualitatively, "
           "the paper's game has no cost of waiting, and comparing that incentive with an amount forgone relaxes Good's "
           "proviso, for the two moves"),
    'R2': ("08 likewise", "the verifier's replacement, labelled [AI reading], with F8's referents"),
    'R3': ("“correctable only as far as that model is right” places the condition wrongly",
           "the verifier's “strict reason”: “gives a formation a strict reason to wait for another's reading only where "
           "that model leaves the sign of going on open”, “correctable” avoided (F26)"),
    'R4': ("the overview's “reason to be corrected … only as far as the model is right”",
           "the verifier's replacement: “a strict reason to be corrected that the formation has only where its own model "
           "leaves the sign of going on open”"),
    'R5': ("the overview's proved clauses say more than the Lean", AS + "A1 and A2"),
    'R6': ("`reach_fixes`'s conditions dropped", AS + "A3"),
    'R7': ("“Four laws” before five", AS + "A7"),
    'R8': ("the record, the study, the module and the literature table credit the three-term relation to Remark 1",
           "the verifier's replacements in the record (en, zh), the study and the table's Remark 1 row; the module's "
           "Readings: “whose game has no cost of waiting, draws the incentive the first two make in its own terms”"),
    'R9': ("the dossier and the board name a reading that stops or releases", AS + "A2"),
    'R10': ("Carey's conflating model ignores shutdown only where the better act is shutting down",
            "“then takes the worse act, ignoring shutdown where the better act is shutting down” in 03 §12, the "
            "dossier and PLAN; the record “which may ignore shutdown” (zh 而可不从关机)"),
    'R11': ("Good's value of evidence only where the reading stops by the formation's own values",
            "“where the reading stops by the formation's own values its worth is Good's (1967) value of evidence; for "
            "any other rule it is that value less the rule's shortfall”, and “for the two moves” (E19)"),
    'R12': ("Blackwell's comparison is an equivalence; the module proves one direction for one decision",
            "“a finer partition never raising the least shortfall is, for this decision, Blackwell's (1953) partition "
            "case” in the record (zh 于此抉择); “for this decision … from finer to worth at least as much” in 03 and 08"),
    'R13': ("07 reads the worth law as an incentive unlabelled",
            "“Nor does the worth of accepting one on the formation's own model, read as an incentive to accept it [AI "
            "reading]”"),
    'R14': ("PLAN §8 gives Good's inequality for a cell", "as E23"),
    'R15': ("rows L1 and L10 of REVIEW-RFM2-LEAN are stale", "both updated after the check"),
    'R16': ("the acts-alike amendment keeps “order as state”, and its Chinese history 主者", "as F19; 受助者 throughout"),
    'R17': ("the dossier's sentence on costly correction reads as denying what the bullet states",
            "refuted: the sentence concerns a disposition the Lean does not derive. F31 raised the same, so it was made "
            "explicit: “Whether an actual system's model leaves the sign open, or whether the system acts on that "
            "assessment and accepts costly correction, is not derived”"),
    'F1': ("the threshold's sum stated as two bounds", "as E5 and E6"),
    'F2': ("a reading that stops or releases, and “both signs”", AS + "A2"),
    'F3': ("“Four laws” before five", AS + "A7"),
    'F4': ("the overview's “any policy” and “committing to any open act”",
           AS + "A1, and “stands above committing to every open act exactly where none is valued best”"),
    'F5': ("`reach_fixes`'s conditions dropped", AS + "A3"),
    'F6': ("`ShownOrder`'s importers", "as E8"),
    'F7': ("PLAN's “with both conditions”", "as E14"),
    'F8': ("“the paper's Remark 1” after Blackwell, 08's antecedents, and 08's reading unlabelled",
           "as E10 and E28; 08: “Read [AI reading], the openness less the shortfall is the incentive the off-switch "
           "paper's Remark 1 places qualitatively; its Theorem 2's form for a Gaussian belief is not represented, the "
           "counts decompose the incentive differently” (with R2)"),
    'F9': ("stale rows of REVIEW-RFM2-LEAN", "as E11"),
    'F10': ("the proposal said made is not on the board", "as E12"),
    'F11': ("“the previous witness” and “the previous laws” point past the law before",
            "“the untested model's witness” and “what a course chosen through its model does not test”"),
    'F12': ("“choosing so” has no antecedent", "as E29"),
    'F13': ("07's incentive unlabelled", "as R13"),
    'F14': ("“a map … never falls short by more”, and “at every cell”", "as E18, and “at every listed cell”"),
    'F15': ("the header's wrapping left irregular",
            "the header's paragraphs rewrapped at 100 columns, words unchanged; the module rebuilt "
            "([build-25](../kit/round2b/logs/build-25.log))"),
    'F16': ("the header's witness omits where going on loses", AS + "A5"),
    'F17': ("the record's second counterexample omits where going on loses and `refuted_drops`", AS + "A4"),
    'F18': ("PLAN's held start", AS + "A4"),
    'F19': ("one planned item under three names",
            "“a principal's valuation as state” throughout: the acts-alike amendment (en, zh 受助者之值为态, with the "
            "verifier's “RF round 2's later item, RF-M.3's carrier”), the dossier, PLAN §4.6's list of what was not built then, §13 and §4.7's title (the "
            "re-point script's expected sections updated)"),
    'F20': ("PLAN's design-review count reads as thirty", "the split of the eight in parentheses"),
    'F21': ("“its carrier first” reads as already designed",
            "“its carrier to be designed first” in the board's texts and the record's next step, the board's landing "
            "sentence saying “Next:”"),
    'F22': ("the study's Output → input misnames what changes",
            "the overview's new paragraph, the three records' related entries, the package READMEs, the checker's "
            "scope and regions.json named"),
    'F23': ("lemma names in the study", "as E24"),
    'F24': ("“the last law” names a position",
            "refuted: the position is accurate and the anchor does not drift; “has [its own law]” kept all the same, "
            "as harmless"),
    'F25': ("the chapters assert non-novelty outright",
            "refuted: 08 §8's verdict says none of the central results is new mathematics; “none claimed new as "
            "mathematics” kept all the same in 03 §12 and 08, the module's and the study's form"),
    'F26': ("“correctable” is a defined term of the chapter", "avoided, as R3"),
    'F27': ("“the paper's Theorem 1” follows Good", "“the off-switch paper's Theorem 1”, and its Corollary 1 likewise"),
    'F28': ("03 §12 leaves the witness's model unstated",
            "“(each kept candidate weighted one, the gain one where going on gains and the loss one where it loses, "
            "else nothing)”, with E15's correction"),
    'F29': ("“no such candidate” narrows `pair_gains_iff`'s asymmetry",
            "“where no listed candidate of positive weight ranks each of the two above the other”"),
    'F30': ("the overview's cell clause misparses", "“through a reading that tells only a cell, no rule through it”"),
    'F31': ("the dossier's sentence on costly correction", "as R17"),
    'F32': ("REVIEW-RFM2-LEAN's opening tells the check out of order",
            "the check at 81 theorems in 111 declarations told first, then the rebuild to 89 in 119, linked to build-18; "
            "the page regenerated after the re-check (its point 1)"),
}

# What was taken from the re-check: (point, status, how).
RECHECK = (
    ('1', 'taken', "REVIEW-RFM2-LEAN regenerated from its script: its opening is now the replacement given, word for "
                   "word, and the Remark 1 row of its literature table is regenerated with it."),
)

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
        rows.append(f"| {fid} | {key} | {state} | {short} | {taken} |")
assert set(TAKEN_LENS) == {r.split(' | ')[0][2:] for r in rows}, 'TAKEN_LENS names a finding not reported'

total = sum(counts.values())
summary = (f"The cross-model reader reported {len(TAKEN_READER)} points, every one taken. The lenses reported {total} "
           f"findings, {counts['confirmed']} confirmed and {counts['refuted']} refuted by their refuters"
           + (f", {counts['unverified']} not verified" if counts['unverified'] else '')
           + "; what each became is in [the table](#what-was-taken-from-the-lenses).")
parts = [INTRO.replace('{SUMMARY}', summary), '## The cross-model reader\n', relinked(reader) + '\n',
         '### What was taken from the cross-model reader\n', '| # | Finding | Taken |', '|---|---|---|']
parts += [f'| {p} | {f} | {t} |' for p, f, t in TAKEN_READER]
parts.append('\n## The three lenses\n')
parts += blocks
parts += ['### What was taken from the lenses\n', '| # | Lens | Verdict | Finding | Taken |', '|---|---|---|---|---|']
parts += rows
recheck = recheck_md.read_text(encoding='utf-8')
recheck = recheck[:recheck.index('\n── cx ·')].rstrip('\n')
parts += ['\n## The re-check\n', 'The cross-model reader, in the session of its cold read, read how the findings were '
          'taken, read-only. Verbatim; its line numbers are those of the version it read (the kit at `175550266`).\n',
          relinked(recheck) + '\n', '### What was taken from the re-check\n', '| Point | Status | How |', '|---|---|---|']
parts += [f'| {p} | {s} | {h} |' for p, s, h in RECHECK]
text = '\n'.join(parts) + '\n'
assert '](/' not in text and not any(root in text for root in ROOTS)
OUT.write_text(text, encoding='utf-8')
print(OUT.relative_to(STUDY.parents[0]), len(text), 'characters;', len(TAKEN_READER), 'points,', total, 'findings', counts)
