#!/usr/bin/env python3
"""UE28 texts (DESIGN §5, with the landing review's findings, REVIEW-UE28-LANDING): in 03 §1, the blanket's reading brought to a formation's level ("folds" for "keeps"),
UE27's home section label and its sentence on the agent, and a new paragraph after the three levels, before the
section's reading; 08 §8's which-blanket sentence gains the correspondence clause; the principle's page (In brief, the
claim table's blanket row, §1's blanket line, §4's sentence on the agent and §5's item); the UE plan's owners and
FEP-INTEGRATION's item 13. Every backticked BlanketCouplings name is checked against the scratch-build axiom audit.
Mirrors UE27's texts_ue27.py; every edit is asserted to apply exactly once, its old text taken from main as UE27 and
DU left it. The wording follows the review of the Lean (REVIEW-UE28-LEAN, finding 7) with the module's names:
"agree wherever ... agree" or "fixed pairwise by", never "read off"; "one run", never "a run"; the test bites only
where the states recur; a law determined part by part, the blanketed law's form, where the Lean gives that.
usage (from the checkout root of the landing worktree, after integrate_ue28.py): python3 -B <kit>/texts_ue28.py N
(N the study section the landing appends)"""
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
AUDIT = HERE.parent / 'tree/.build/BecomingBlanketCouplingsAxiomAudit.lean'
NAMES = set(re.findall(r'^#print axioms Becoming\.(\S+)$', AUDIT.read_text(encoding='utf-8'), re.M))
assert len(NAMES) == 140, len(NAMES)
CH = ROOT / 'theories/becoming/chapters'
PAGE = ROOT / 'theories/becoming/FREE-ENERGY-PRINCIPLE.md'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
RID = 'a-formations-couplings-as-its-blanket'
N = int(sys.argv[1])


def cited(text):
    """Every backticked BlanketCouplings name the text cites is a declaration of the module."""
    names = set(re.findall(r'`(BlanketCouplings\.[A-Za-z_.]+)`', text))
    missing = sorted(n for n in names if n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


# 03 §1: the blanket's reading ("folds"; the level along one run, in place of "not shown")
C03 = CH / '03-KNOWING.md'
edit(C03, "a formation's support and observed levels are its sensory states, what it keeps of them its internal "
          "states, and the blanket condition is that",
     "a formation's support and observed levels are its sensory states, what it folds of them its internal "
     "states, and the blanket condition is that")
edit(C03, f"with a model as the internal part ([below](#r-{RID})); that what it keeps of them, its own record, can be "
          "the internal part is not shown. What the theory adds",
     f"with a model as the internal part ([below](#r-{RID})). Along one run, the step external and a value across "
     "steps of what couples into it the sensory part, its own level is the internal part of a law determined part "
     "by part exactly where, at any two steps alike on its level, on that value and on its act, its next levels and "
     "next acts agree. The test bites only where these recur; across a family of runs, with the step off the "
     "world's side, and for its other records, nothing is shown. What the theory adds")

# 03 §1: UE27's home section, its label and its sentence on the agent
edit(C03, "**Theorem** (World for the join: any web and formation, the couplings by level supplied, any model, policy "
          "and environment; any type for the readings: any family of courses).",
     "**Theorem** (World for the join: any web and formation, the couplings by level supplied, any model, policy "
     "and environment; any type for the readings: any family of courses, or one course with the step external; for "
     "a formation's level, one balanced World run).")
edit(C03, "the closed loop is a model beside it, and the agent is a model, not the formation's own record.",
     "the closed loop is a model beside it, and the agent here is a model; the formation's own level as the internal "
     "part, along one run, is stated after the three levels below.")

# 03 §1: the new paragraph, after the three levels and before the section's reading
DESIGN = ('../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/'
          'ue28-a-formations-level-as-the-internal-part/DESIGN.md')
PARAGRAPH = (
    "Can a formation's own level be the internal part? Read one course with the step as the external part: some "
    "law determined part by part admits it exactly where its agent is consistent, at any two steps alike on the "
    "internal, sensory and active states the next internal and active states agreeing "
    "(`BlanketCouplings.stepExternal_admitted_iff`). The world's half holds of every such course, since the step "
    "tells any two steps apart. Given functions for the next internal and active states at every step, the course "
    "is that of a blanketed law whose internal part moves by the sensory state at its own step "
    "(`BlanketCouplings.stepLaw_course`); the converse is not stated.\n\n"
    "Now read a balanced World run so. The formation's own level is the internal part. A value across steps of "
    "what couples into it is the sensory part: it tells two steps apart only by admission at each and by the "
    "levels coupled into it (`BlanketCouplings.ValuesAcross`; where admission is decided and the couplings listed, "
    "`Web.listed_values`' value is one, `BlanketCouplings.listed_valuesAcross`). Its act, its rows at the steps "
    "where it takes part, is the active part, and the World's other records enter only through the step. Then "
    "some law determined part by part admits the run exactly where, at any two steps alike on its level, its "
    "admission, the levels coupled into it and its act, its next acts agree and what the relata present give to "
    "it at one step plus what they take from it at the other is the same with the steps exchanged, a comparison "
    "with no subtraction (`BlanketCouplings.levelParts_admitted_iff`). The test bites only where these recur. A "
    "drain in three phases from what does not couple in fails it for every value across steps "
    "(`BlanketCouplings.PhasedDrain.not_admitted`); a drain and feed in two phases from what does not couple in "
    "either meets it, the level recurring (`BlanketCouplings.Alternating.admitted`, "
    "`BlanketCouplings.Alternating.recurs`). So whether what moves the level couples in does not decide; whether "
    "the level, what couples in and the act fix the next level and act does. Where its own level couples into it "
    "(`Web.SelfBearing`), the sensory part reads the internal part at the same step, and nothing beyond one run "
    "with the step is shown. Across a family of runs, or with the step off the world's side, the world's half "
    "becomes a condition, not stated here. Near-definitional: the elementary condition for one trajectory to come "
    "from a time-invariant deterministic state machine, stated on the World's exchange "
    f"([record](../results/records/{RID}.md), [design]({DESIGN})).\n\n")
edit(C03, f"new: the three levels in the pure core ([record](../results/records/{RID}.md)).\n\n**Reading** [AI reading, "
          "D45]. Which blanket a thing has",
     f"new: the three levels in the pure core ([record](../results/records/{RID}.md)).\n\n" + PARAGRAPH +
     "**Reading** [AI reading, D45]. Which blanket a thing has")

# 08 §8: the which-blanket sentence gains the correspondence clause
C08 = CH / '08-METHOD.md'
edit(C08, "the join of a formation's couplings to a blanketed law is the threshold witness's join made general, "
          "near-definitional. New are the three levels",
     "the join of a formation's couplings to a blanketed law is the threshold witness's join made general, "
     "near-definitional; a formation's level along one run, the step external, is the internal part of a law "
     "determined part by part exactly under the elementary condition for one trajectory to come from a "
     "time-invariant deterministic state machine, here stated on the World's exchange, pairwise. New are the three "
     "levels")

# the principle's page
HOME = f'(chapters/03-KNOWING.md#r-{RID})'
edit(PAGE, "and a sparse partition fixed apart from the family, on a law the same at every step, can be refuted, even "
           "by one run. The existence claim forbids nothing alone.",
     "and a sparse partition fixed apart from the family, on a law the same at every step, can be refuted, even "
     "by one run, as can a formation's own level read as the internal part along one run with the step external, "
     "which a drain in three phases fails. The existence claim forbids nothing alone.")
edit(PAGE, f"which blanket: relative to the reading, any model fed by a formation's couplings a blanketed agent by "
           f"construction ([03 §1]{HOME}) | stated, pure core, the deterministic case; which blanket, "
           "near-definitional, the classification new |",
     "which blanket: relative to the reading, any model fed by a formation's couplings a blanketed agent by "
     "construction, and, along one run with the step external, the formation's own level the internal part of a "
     "law determined part by part exactly where its next level and act agree wherever its level, a value across "
     "steps of what couples in and its act agree, a test that bites only where these recur "
     f"([03 §1]{HOME}) | stated, pure core, the deterministic case; which blanket and the level along one run, "
     "near-definitional, the classification new |")
edit(PAGE, f"two of its courses alike on the blanket exactly where alike through them ([03 §1]{HOME}; "
           "`BlanketCouplings.sensory_course`, `BlanketCouplings.blanket_iff_through`).",
     f"two of its courses alike on the blanket exactly where alike through them ([03 §1]{HOME}; "
     "`BlanketCouplings.sensory_course`, `BlanketCouplings.blanket_iff_through`). Along one balanced run of a World "
     "(*World*), the step external and a value across steps of what couples in the sensory part, a formation's own "
     "level is the internal part of a law determined part by part exactly where its next level and act agree "
     "wherever its level, that value and its act agree, a test that bites only where these recur, which a drain in "
     f"three phases fails ([03 §1]{HOME}; "
     "`BlanketCouplings.levelParts_admitted_iff`, `BlanketCouplings.PhasedDrain.not_admitted`).")
edit(PAGE, "; the agent is a model, not the formation's own record, and having that law forbids nothing of the "
           "formation's course.",
     "; the agent is a model, and having that law forbids nothing of the formation's course. With the formation's "
     "own level as the internal part, read along one balanced run with the step external, the reading can fail: the "
     "level is the internal part of a law determined part by part exactly where its next level and act agree "
     "wherever its level, a value across steps of what couples into it and its act agree, a test that bites only "
     "where these recur, which a drain in three phases from what does not couple in fails and a drain and feed in "
     "two phases meets "
     f"([03 §1]{HOME}; `BlanketCouplings.levelParts_admitted_iff`, `BlanketCouplings.PhasedDrain.not_admitted`, "
     "`BlanketCouplings.Alternating.admitted`).")
edit(PAGE, "a World formation's own record, rather than a model, as the internal part of a blanketed law;",
     "a World formation's records other than its level, rather than a model, as the internal part of a blanketed "
     "law; its level as that part across a family of runs, or with the step off the world's side, or along one run "
     "from the consistency condition alone, without functions for its next states;")

# the UE plan and the plan for the principle
UE = ROOT / RF / 'development/ue-unified-explanation'
REC = '../../../../../../theories/becoming/results/records/'
edit(UE / 'PLAN.md', "UE24, UE25, UE26 and UE27, and holds UE8.", "UE24, UE25, UE26, UE27 and UE28, and holds UE8.")
FI = UE / 'FEP-INTEGRATION.md'
lines = FI.read_text(encoding='utf-8').split('\n')
at = [i for i, line in enumerate(lines) if line.startswith('12. **UE27. Which blanket a thing has**')]
assert len(at) == 1 and not any(line.startswith('13. **UE28.') for line in lines), at
lines[at[0] + 1:at[0] + 1] = [cited(
    "13. **UE28. A formation's level as the internal part** (landed as the last part of the core leaf "
    f"`Becoming.BlanketCouplings`, amending [its record]({REC}{RID}.md), study section {N}). Along one run with the "
    "step as the external part, a course is admitted by some law determined part by part exactly where its agent "
    "is consistent, the world's side the run read by the step. On a balanced World run read with a formation's own "
    "level internal, a value across steps of what couples into it sensory and its act active, the agent's "
    "consistency is a condition on the World's records: at any two steps alike on its level, its admission, the "
    "levels coupled into it and its act, what is given to it at one step plus what is taken from it at the other "
    "is the same with the steps exchanged and its next acts agree, tested only where these recur. A drain in three "
    "phases fails it and a drain and feed in two phases meets it, so whether what moves the level couples in does "
    "not decide the condition; whether the level, what couples in and the act fix the next level and act does. It "
    "narrows §5's item to the formation's other records, its level across a family of runs or with the step off "
    "the world's side, and a blanketed law for its level from consistency alone, and forbids no sentence of the "
    "literature.")]
FI.write_text('\n'.join(lines), encoding='utf-8')
print('texts: 03 §1 (the blanket\'s reading; UE27\'s home section label and agent sentence; the level\'s paragraph), '
      '08 §8, the page (In brief, claim table, §1, §4, §5), UE plan, FEP-INTEGRATION item 13')
