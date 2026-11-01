#!/usr/bin/env python3
"""UE27 texts: the home section of a-formations-couplings-as-its-blanket in 03 §1, after the blanket's reading, the
blanket's last sentence and its reading brought to it; 08 §8's blanket bullet; the principle's page (In brief, the claim
table, §1, §2, §4, §5 and Standing); the UE plan's owners and FEP-INTEGRATION's item 12. Every backticked
BlanketCouplings name is checked against the scratch-build axiom audit. Mirrors UE26's texts_ue26.py; every edit is
asserted to apply exactly once. The wording follows the review of the Lean (REVIEW-UE27-LEAN) and the review of the
landing texts (REVIEW-UE27-LANDING): the agent is any model fed by what couples into a formation, where the couplings
give the values, not the formation or its own record; the join is a construction, not a test, at the first level; the
levels are readings of the course, readings of the configuration (a degenerate one refuting no family whose law is
determined) and a sparse partition fixed apart from the family, which can be refuted, with no "only"; "the blanket's
form" is glossed as a law determined part by part where it first appears; no "forbids" for the first two levels.
usage (from the checkout root of the landing worktree, after integrate_ue27.py): python3 -B <kit>/texts_ue27.py N
(N the study section the landing appends)"""
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
AUDIT = HERE.parent / 'tree/.build/BecomingBlanketCouplingsAxiomAudit.lean'
NAMES = set(re.findall(r'^#print axioms Becoming\.(\S+)$', AUDIT.read_text(encoding='utf-8'), re.M))
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


# 03 §1: the blanket's last sentence and its reading, then the home section after the reading
C03 = CH / '03-KNOWING.md'
edit(C03, "Near-definitional; a World formation in general as the agent of a blanketed law is not shown "
          "([record](../results/records/the-markov-blanket-as-a-coupling-structure.md)).",
     "Near-definitional; for any formation whose couplings give the values of what couples in, the join holds by "
     f"construction, with a model as the agent ([a formation's couplings as its blanket](#r-{RID}); "
     "[record](../results/records/the-markov-blanket-as-a-coupling-structure.md)).")
edit(C03, "any one of them, the internal course among them, at most that (`Blanket.Deaf.lumps`). What the theory adds",
     "any one of them, the internal course among them, at most that (`Blanket.Deaf.lumps`). That a formation's "
     "support and observed levels are a blanketed agent's sensory states is a theorem wherever its admission is "
     f"decided and its observed levels listed, by construction, with a model as the internal part ([below](#r-{RID})); "
     "that what it keeps of them, its own record, can be the internal part is not shown. What the theory adds")
DESIGN = ('../../../_process/research/2026-10-05-generative-foundation-review/root-foundation/development/'
          'ue27-which-blanket-a-thing-has/DESIGN.md')
ANCHOR = '<a id="r-the-blanket-at-a-steady-state"></a>'
SECTION = (
    f'<a id="r-{RID}"></a>\n'
    "**Theorem** (World for the join: any web and formation, the couplings by level supplied, any model, policy and "
    "environment; any type for the readings: any family of courses). *A formation's couplings as its blanket, and when "
    "a blanket constrains.* Where a formation's couplings give the values of what couples into it, any model fed by "
    "those values, with any policy and any environment, the environment reading the formation's act or not, is the "
    "agent of a blanketed law whose sensory part's next state is the value of what couples in at the step, the step "
    "held on the world's side (`BlanketCouplings.couplingLaw`). Its sensory course is the formation's own course "
    "through its couplings ([above](#r-a-formations-own-course)) under the course's own level history "
    "(`BlanketCouplings.sensory_course`); two of its courses from one start of the agent's parts are alike on the "
    "blanket before step n + 2 exactly where their level histories are alike through the couplings up to n "
    "(`BlanketCouplings.blanket_iff_through`), and their internal courses then agree up to n + 2 "
    "(`BlanketCouplings.internal_through_couplings`); in the open loop, the act moving no level, every reading of the "
    "internal course up to n + 2 is a selection through the couplings up to n "
    "(`BlanketCouplings.internal_selectsThrough`). The threshold witness's join above is its case "
    "(`BlanketCouplings.ThresholdCase.threshold_case`). For a World, with admission at the formation decided and its "
    "couplings listed, the World's own case is the open loop at its levels; the closed loop is a model beside it, and "
    "the agent is a model, not the formation's own record. The law is a construction, not a test: wherever the "
    "couplings give the values it exists, and having it forbids nothing of the formation's course.\n\n"
    "When, then, does a blanket's existence constrain? The law a family of courses shows "
    "([01 §9](01-ROOT.md#r-histories-fix-law-up-to-dead-ends)) has a part depending only on a reading exactly where "
    "the family is consistent under the reading and the part (`BlanketCouplings.shownBy_partDependsOnlyOn_iff`), and a "
    "family is admitted by some law determined part by part, the blanket's form, which may be partial and keeps the "
    "family's moves, exactly where it is consistent part by part (`BlanketCouplings.admitted_iff`). With parts that "
    "read the course, which course and the step, every family of courses, so read, is the course family of a "
    "blanketed law (`BlanketCouplings.clocked_course`), consistent or not (`BlanketCouplings.clocked_witness`), the "
    "step alone not enough (`BlanketCouplings.clock_only_fails`), and every course is the internal course of one "
    "blanketed law reading its future (`BlanketCouplings.future_course`). With a reading of the configuration, a "
    "degenerate one gives every family a law determined part by part (the constant one, "
    "`BlanketCouplings.const_consistent`) or exactly the families whose law is determined (the whole configuration, "
    "`BlanketCouplings.whole_iff`); any injective reading, degenerate or not, gives one only where the law is "
    "determined (`BlanketCouplings.injective_consistent`), and not always there: under the identity reading of a "
    "sparse partition it fails (`BlanketCouplings.injective_converse_fails`). A sparse partition fixed apart from the "
    "family, on a law the same at every step, can be refuted, even by one run: the run whose internal part's next "
    "state is whether the external part, cycling through three values, is at its first is the course of no blanketed "
    "law on its four parts (`BlanketCouplings.ReadsExternal.not_blanketed`), while the whole configuration reads it "
    "in the blanket's form (`BlanketCouplings.ReadsExternal.whole_consistent`), as a line-by-line reading of the "
    "received order of the hexagrams is refuted ([06 §5.5](06-CLASSICAL-TEXTS.md#r-hexagram-arrangements-and-laws), "
    "`Hexagram.runsOrder_reads`). Whoever may pick the reading after seeing the family can pick one of the first two "
    "kinds, so a blanket read that way constrains nothing. Near-definitional, the partition's dependence on a model "
    "argued in words by the principle's critics (Bruineberg, Dołęga, Dewhurst and Baltieri 2022); new: the three "
    f"levels in the pure core ([record](../results/records/{RID}.md)).\n\n"
    "**Reading** [AI reading, D45]. Which blanket a thing has is a question of how its parts are read. The couplings "
    "give one reading, not derived: what couples into a formation as its sensory part, under which, by construction, "
    "whatever a model fed by it tells apart passes through the couplings. That reading constrains nothing of the "
    "formation's course. What can be refuted is a claim that a given sparse partition of a thing's own states, fixed "
    "apart from its course, on a law the same at every step, is a blanket: there a single run can show a part reading "
    f"what it is barred from ([design]({DESIGN})).\n\n")
edit(C03, ANCHOR, SECTION + ANCHOR)

# 08 §8: after the blanket bullet's last sentence
C08 = CH / '08-METHOD.md'
edit(C08, "and a circulating witness in which the synchronous scheme loses the four-part blanket. No sentence of the "
          "literature is forbidden.",
     "and a circulating witness in which the synchronous scheme loses the four-part blanket. No sentence of the "
     f"literature is forbidden. Which blanket a thing has ([03 §1](03-KNOWING.md#r-{RID})) states in the pure core the "
     "partition's dependence on a model that the principle's critics argue in words (Bruineberg, Dołęga, Dewhurst and "
     "Baltieri 2022), its single-run witness of the same kind as the refutation of a line-by-line reading of the "
     "received hexagram order (`Hexagram.runsOrder_reads`, [06 §5.5](06-CLASSICAL-TEXTS.md#r-hexagram-arrangements-and-"
     "laws)); the join of a formation's couplings to a blanketed law is the threshold witness's join made general, "
     "near-definitional. New are the three levels at which a blanket's existence constrains. No sentence of the "
     "literature is forbidden.")

# the principle's page
HOME = f'(chapters/03-KNOWING.md#r-{RID})'
edit(PAGE, "the blanket's partition names the couplings, a reading through the blanket separating at most what the "
           "blanket tells apart;",
     "the blanket's partition names the couplings (any model fed by what couples into a formation being, by "
     "construction, the agent of a blanketed law), a reading through the blanket separating at most what the blanket "
     "tells apart;")
edit(PAGE, "Four further laws forbid no sentence of the literature but state what it leaves open:",
     "Five further laws forbid no sentence of the literature but state what it leaves open:")
edit(PAGE, "an agent reading its supply only by threshold cannot see its break coming, whatever its model and policy; "
           "and the blanket's statistical form holds where",
     "an agent reading its supply only by threshold cannot see its break coming, whatever its model and policy; "
     "the blanket's statistical form holds where")
edit(PAGE, "or, in the linear case, under the principle's sparse coupling with footnote 13's condition and diagonal "
           "positive noise; it need not hold with circulation, and in a witness the synchronous steps of a drift meeting "
           "footnote 13 and the 2023 paper's term-by-term sparse coupling lose it, a loss of the discrete step, the "
           "drift's continuous-time zero standing. The existence claim forbids nothing alone.",
     "or, in the linear case, under the principle's sparse coupling with footnote 13's condition and diagonal "
     "positive noise, and need not hold with circulation, as in a witness the synchronous steps of a drift meeting "
     "footnote 13 and the 2023 paper's term-by-term sparse coupling lose it, a loss of the discrete step, the drift's "
     "continuous-time zero standing; and which blanket a thing has turns on how its parts are read: with parts reading "
     "the course every family of courses has one, a degenerate reading of the configuration refutes no family whose "
     "law is determined, and a sparse partition fixed apart from the family, on a law the same at every step, can be "
     "refuted, even by one run. The existence claim forbids nothing alone.")
edit(PAGE, "| The Markov blanket | a blanketed law: the agent's course fixed by its start and its sensory course "
           "([03 §1](chapters/03-KNOWING.md#r-the-markov-blanket-as-a-coupling-structure)) | stated, pure core, the "
           "deterministic case |",
     "| The Markov blanket | a blanketed law: the agent's course fixed by its start and its sensory course "
     "([03 §1](chapters/03-KNOWING.md#r-the-markov-blanket-as-a-coupling-structure)); which blanket: relative to the "
     f"reading, any model fed by a formation's couplings a blanketed agent by construction ([03 §1]{HOME}) | stated, "
     "pure core, the deterministic case; which blanket, near-definitional, the classification new |")
edit(PAGE, "| stated for the deterministic case; joined to the World's couplings for the threshold witness |",
     "| stated for the deterministic case; joined to the World's couplings, in the open loop, for any model fed by "
     f"what couples into a formation ([03 §1]{HOME}), the threshold witness its case |")
edit(PAGE, "each side's fixed by its start and the blanket's ([03 §1](chapters/03-KNOWING.md#r-the-markov-blanket-as-a-"
           "coupling-structure); `Blanket.Blanketed.agent_through_sensory`, `Blanket.Blanketed.internal_through_blanket`).",
     "each side's fixed by its start and the blanket's ([03 §1](chapters/03-KNOWING.md#r-the-markov-blanket-as-a-"
     "coupling-structure); `Blanket.Blanketed.agent_through_sensory`, `Blanket.Blanketed.internal_through_blanket`). "
     "Where a formation's couplings give the values of what couples into it (*World*), any model fed by them, with any "
     "policy and environment, is by construction the agent of a blanketed law whose sensory course is the formation's "
     "own course through its couplings, two of its courses alike on the blanket exactly where alike through them "
     f"([03 §1]{HOME}; `BlanketCouplings.sensory_course`, `BlanketCouplings.blanket_iff_through`).")
edit(PAGE, "for the threshold witness the blanket is the World's coupling ([03 §1](chapters/03-KNOWING.md#r-the-markov-"
           "blanket-as-a-coupling-structure)).",
     "for the threshold witness the blanket is the World's coupling ([03 §1](chapters/03-KNOWING.md#r-the-markov-"
     "blanket-as-a-coupling-structure)), and wherever a formation's couplings give the values of what couples into "
     "it, any model fed by them is, by construction, the agent of a blanketed law, the threshold witness's join its "
     f"case ([03 §1]{HOME}; `BlanketCouplings.ThresholdCase.threshold_case`).")
edit(PAGE, "forbidding needs a weighting fixed apart from the course, or a law of the courses themselves.",
     "forbidding needs a weighting fixed apart from the course, or a law of the courses themselves. So it is with a "
     "blanket's existence. With parts that read the course, every family of courses has a blanket; a degenerate "
     "reading of the configuration, which gives every family, or exactly the families whose law is determined, a law "
     "determined part by part (the blanket's form on the law the family shows, which may be partial), refutes no "
     "family whose law is determined; a sparse partition fixed apart from the family, on a law the same at every "
     f"step, can be refuted, even by one run ([03 §1]{HOME}; `BlanketCouplings.clocked_course`, "
     "`BlanketCouplings.whole_iff`, `BlanketCouplings.ReadsExternal.not_blanketed`). That the partition depends on a "
     "model is the critics' point (Bruineberg, Dołęga, Dewhurst and Baltieri 2022). Where a formation's couplings give "
     "the values of what couples into it, any model fed by them is, by construction, the agent of a blanketed law "
     "whose sensory course is the formation's own course through its couplings; the agent is a model, not the "
     "formation's own record, and having that law forbids nothing of the formation's course.")
edit(PAGE, "a World formation in general as the agent of a blanketed law;",
     "a World formation's own record, rather than a model, as the internal part of a blanketed law;")
edit(PAGE, "and a circulating witness in which the synchronous scheme loses the four-part blanket. Here the theory",
     "and a circulating witness in which the synchronous scheme loses the four-part blanket; and the three levels at "
     "which a blanket's existence constrains (the join of a formation's couplings to a blanketed law, "
     "near-definitional, is not counted new). Here the theory")

# the UE plan and the plan for the principle
UE = ROOT / RF / 'development/ue-unified-explanation'
REC = '../../../../../../theories/becoming/results/records/'
edit(UE / 'PLAN.md', "UE21, UE22, UE23, UE24, UE25 and UE26, and holds UE8.",
     "UE21, UE22, UE23, UE24, UE25, UE26 and UE27, and holds UE8.")
FI = UE / 'FEP-INTEGRATION.md'
lines = FI.read_text(encoding='utf-8').split('\n')
at = [i for i, line in enumerate(lines) if line.startswith('11. **UE26. Blankets at a steady state**')]
assert len(at) == 1 and not any(line.startswith('12. **UE27.') for line in lines), at
lines[at[0] + 1:at[0] + 1] = [cited(
    "12. **UE27. Which blanket a thing has** (landed as the core leaf `Becoming.BlanketCouplings`, with "
    f"[its record]({REC}{RID}.md), study section {N}). Where a formation's couplings give the values of what couples "
    "into it, any model fed by them, with any policy and environment, is by construction the agent of a blanketed law "
    "whose sensory course is the formation's own course through its couplings, alike on the blanket exactly where alike "
    "through them, the threshold witness's join its case; a construction, not a test. When a blanket's existence "
    "constrains, at three levels: with parts reading the course every family of courses is the course family of a "
    "blanketed law; a degenerate reading of the configuration gives every family, or exactly the families whose law "
    "is determined, a law determined part by part, so refutes no family whose law is determined; a sparse partition "
    "fixed apart from the family, on a law the same at every step, can be refuted, even by one run. It narrows §5's "
    "item to the formation's own record as the internal part, and forbids no sentence of the literature.")]
FI.write_text('\n'.join(lines), encoding='utf-8')
print('texts: 03 §1 (home section and reading; the blanket\'s last sentence and reading), 08 §8, the page (In brief, '
      'claim table, §1, §2, §4, §5, Standing), UE plan, FEP-INTEGRATION item 12')
