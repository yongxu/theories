#!/usr/bin/env python3
"""UE23 texts: 03 §6, the home sections of expected-free-energy-and-its-terms (seeking by expected free energy, joined
to the core's seeking, through the lumping, for any likelihoods) and of what-seeking-cannot-separate (choice by expected
free energy as one policy of choice); 08 §8's bullet on expected free energy and seeking; the principle's page (In brief,
the two table rows, §1, §4's fourth law, §5 and Standing); the study section; the UE plan's owners and FEP-INTEGRATION's
item 8; the region notes of the two records. Every ExpectedFreeEnergy name the texts cite is checked against the
receipt's declarations. Mirrors UE22's texts_ue22.py; every edit is asserted to apply exactly once.
usage (from the checkout root of the landing worktree, after the periphery checker):
  python3 -B <kit>/texts_ue23.py RECEIPT_EFE N"""
import json
import re
import sys
from pathlib import Path

ROOT = Path.cwd()
HERE = Path(__file__).resolve().parent
RECEIPT, N = sys.argv[1], int(sys.argv[2])
FE = 'experiments/integrated-correction/general-framework/generative-basis/lean/free-energy'
CH = ROOT / 'theories/becoming/chapters'
PAGE = ROOT / 'theories/becoming/FREE-ENERGY-PRINCIPLE.md'
RF = '_process/research/2026-10-05-generative-foundation-review/root-foundation'
STUDY = ROOT / RF / 'BECOMING-RENEWAL-READING.md'
REGIONS = ROOT / 'theories/becoming/results/data/regions.json'
RIDE, RIDS = 'expected-free-energy-and-its-terms', 'what-seeking-cannot-separate'
R = json.loads((ROOT / FE / 'expected-free-energy-reals-checks' / RECEIPT / 'verification.json').read_text())
assert R['status'] == 'passed' and R['bridge_module'] == 'ExpectedFreeEnergyReals'
MOD = R['modules'][0]
NAMES = {d['name'] for d in MOD['declarations']}
COUNT = len(NAMES)


def cited(text):
    """Every backticked ExpectedFreeEnergy name the text cites is a declaration of the module."""
    found = set(re.findall(r'`ExpectedFreeEnergy\.([A-Za-z_.]+)`', text))
    missing = sorted(n for n in found if 'Becoming.ExpectedFreeEnergy.' + n not in NAMES)
    assert not missing, missing
    return text


def edit(path, old, new):
    text = path.read_text(encoding='utf-8')
    assert text.count(old) == 1, (path.name, old[:80], text.count(old))
    path.write_text(text.replace(old, cited(new)), encoding='utf-8')


C03 = CH / '03-KNOWING.md'
edit(C03, "one step and one policy, its predicted distribution over states given; Mathlib's conventions at zero). "
          "*Expected free energy and its terms.*",
     "one step and one policy, its predicted distribution over states given, and for seeking, courses of experiments "
     "with the hidden state fixed; Mathlib's conventions at zero). *Expected free energy and its terms.*")
edit(C03, "two states of one likelihood keep their prior ratio in the posterior under every outcome "
          "(`ExpectedFreeEnergy.posterior_ratio_of_lumped`). ",
     "two states of one likelihood keep their prior ratio in the posterior under every outcome "
     "(`ExpectedFreeEnergy.posterior_ratio_of_lumped`). "
     f"Joined to [what seeking cannot separate](#r-{RIDS}): over a course of seeking, each experiment chosen from the "
     "course so far, the posterior after the course is the prior times the course's likelihood normalized; with a "
     "nonnegative prior and likelihoods, where the course weighs something, it is the belief of least free energy "
     "among those zero wherever the joint weights are (`ExpectedFreeEnergy.coursePosterior_minimizes`), and choice "
     "weights along the course drop out of it wherever they weigh something "
     "(`ExpectedFreeEnergy.posterior_choice_eq_coursePosterior`). Where the agent's model is the core's, with natural "
     "weights, the core's share given a course chosen with some weight is that posterior, and the core's order of two "
     "shares given it is the posterior's order (`ExpectedFreeEnergy.givenCourse_eq_coursePosterior`, "
     "`ExpectedFreeEnergy.givenCourse_le_iff`). Choosing each experiment by a rule with natural weights reading the "
     "experiments' expected free energies is one of the core's policies, whatever the agent's model, so the core's law "
     "holds at it (`ExpectedFreeEnergy.efe_seeking_keeps_order`, an instance); the softmax is not one of them, and over "
     "the reals it keeps a tied order where the course is possible under the pair "
     "(`ExpectedFreeEnergy.softmax_order_kept`). Conditioning commutes with the lumping "
     "(`ExpectedFreeEnergy.coarse_coursePosterior`), so at every step every experiment's expected free energy and "
     "epistemic value are the classes' (`ExpectedFreeEnergy.efe_through_course`, "
     "`ExpectedFreeEnergy.epistemic_through_course`), and two priors alike on the classes choose alike under every "
     "rule and give every course one predictive weight (`ExpectedFreeEnergy.seeking_blind_to_split`); for any "
     "likelihoods, seeking by expected free energy reads the prior only through the weight it gives each likelihood "
     "profile (`ExpectedFreeEnergy.seeking_reads_profiles`). In the coin, an outcome of a separating experiment turns "
     "the posterior, and with an experiment reading agreement and one telling nothing, two priors whose posteriors "
     "differ weigh both experiments alike at every course under every rule "
     "(`ExpectedFreeEnergy.Witness.separating_turns`, `ExpectedFreeEnergy.Witness.split_unseen`). ")
edit(C03, "The decompositions are the principle's definitions and the gain form is known; the reading through the "
          "lumping is near-definitional ([record]",
     "The decompositions are the principle's definitions and the gain form is known; the reading through the "
     "lumping is near-definitional, as is the course form, a corollary of Bayesian non-identification (Kadane 1974, "
     "Poirier 1998) restated for an agent choosing by expected free energy, and new is its join to the core's seeking "
     "([record]")
edit(C03, "whatever the policy of choice (`LumpedSeeking.seeking_keeps_order`). In a witness of three coins",
     "whatever the policy of choice (`LumpedSeeking.seeking_keeps_order`); choosing each experiment by a rule with "
     "natural weights reading expected free energy is one such policy, whatever the agent's model "
     f"([expected free energy](#r-{RIDE}); `ExpectedFreeEnergy.efe_seeking_keeps_order`), and where the agent's model "
     "is the core's, the share given a course chosen with some weight is its posterior after the course "
     "(`ExpectedFreeEnergy.givenCourse_eq_coursePosterior`). In a witness of three coins")

C08 = CH / '08-METHOD.md'
edit(C08, "and that expected free energy reads beliefs only through the lumping its likelihood makes. What seeking",
     "and that expected free energy reads beliefs only through the lumping its likelihood makes, at every step of a "
     "course of seeking by it, so that seeking by expected free energy reads the prior only through the weight it "
     "gives each likelihood profile. What seeking")
edit(C08, "it forbids the unqualified wording of inherent self-correction (Wen 2025), not active inference's account. "
          "The decompositions are the principle's definitions and the other laws near-definitional or corollaries; new "
          "is the seeking form.",
     "it forbids the unqualified wording of inherent self-correction (Wen 2025), not active inference's account. It "
     "holds for an agent choosing by expected free energy, by the core's law at every rule with natural weights and "
     "over the reals under the softmax, and where the agent's model is the core's, the share given a chosen course is "
     "its posterior and the two orders are one. The decompositions are the principle's definitions and the other laws "
     "near-definitional or corollaries; new are the seeking form and its join to expected free energy.")

# the principle's page
edit(PAGE, "the epistemic value an expected information gain; the Markov blanket",
     "the epistemic value an expected information gain, and seeking by it reads the prior only through the weight it "
     "gives each likelihood profile, its posterior after a course being the core's share given the course where its "
     "model is the core's; the Markov blanket")
edit(PAGE, "expected free energy reads beliefs only through the lumping its likelihood makes, and an agent",
     "expected free energy reads beliefs only through the lumping its likelihood makes, and so does every course of "
     "seeking by it, and an agent")
edit(PAGE, "| stated, periphery, for one step and one policy; read only through the likelihood's lumping |",
     "| stated, periphery, for one step and one policy, and over courses of seeking by it, joined to the core's seeking; "
     "read only through the likelihood's lumping |")
edit(PAGE, "| forbidden unqualified: seeking corrects within what some experiment separates, not beyond; weak |",
     "| forbidden unqualified: seeking corrects within what some experiment separates, not beyond, seeking by expected "
     "free energy included; weak |")
edit(PAGE, "`ExpectedFreeEnergy.expectedFreeEnergy_eq_neg_epistemic_sub_pragmatic`, "
           "`ExpectedFreeEnergy.expectedFreeEnergy_same_of_coarse`).",
     "`ExpectedFreeEnergy.expectedFreeEnergy_eq_neg_epistemic_sub_pragmatic`, "
     "`ExpectedFreeEnergy.expectedFreeEnergy_same_of_coarse`). Over a course of seeking, each experiment chosen by a "
     "rule reading the experiments' expected free energies at the posterior after the course so far, that posterior "
     "is, where the agent's model is the core's, the core's share given a course chosen with some weight, and at every "
     "step the expected free energy is the classes', so seeking by expected free energy reads the prior only through "
     "the weight it gives each likelihood "
     "profile, in its choices and in the predictive weight of every course (*periphery*; "
     "`ExpectedFreeEnergy.givenCourse_eq_coursePosterior`, "
     "`ExpectedFreeEnergy.seeking_blind_to_split`, `ExpectedFreeEnergy.seeking_reads_profiles`).")
edit(PAGE, "in a witness seeking turns the order once an experiment separating it is chosen, as at the cue of the "
           "principle's T-maze. Against",
     "in a witness seeking turns the order once an experiment separating it is chosen, as at the cue of the "
     "principle's T-maze. An agent choosing each experiment by a rule with natural weights reading expected free energy "
     "is one such policy (*periphery*; `ExpectedFreeEnergy.efe_seeking_keeps_order`, an instance), and over the reals "
     "the softmax keeps a tied order too, where the course is possible under the pair "
     "(`ExpectedFreeEnergy.softmax_order_kept`). Against")
edit(PAGE, "the data-processing bound for the epistemic value; a theorem joining the core's seeking law to the "
           "periphery's expected free energy; a World formation",
     "the data-processing bound for the epistemic value; whether, or how often, an agent choosing by expected free "
     "energy chooses an experiment that separates, which turns on its preferences, its posterior and the experiments' "
     "information; a World formation")
edit(PAGE, "new also are the seeking form of identification and expected free energy read through the lumping.",
     "new also are the seeking form of identification, joined to seeking by expected free energy, and expected free "
     "energy read through the lumping at every step of a course.")

# the study section
section = (HERE / 'study_ue23.txt').read_text(encoding='utf-8').replace('{N}', str(N)).replace('{RECEIPT}', RECEIPT)
section = section.replace('(COUNTS)', f"({MOD['theorems']} theorems in {COUNT} declarations)")
assert not any(x in section for x in ('{', 'TODO', 'COUNTS', 'REVIEW-PARAGRAPH')), 'a placeholder left'
t = STUDY.read_text(encoding='utf-8')
assert f'\n## {N}. ' not in t and f'\n## {N - 1}. ' in t, N
STUDY.write_text(t.rstrip('\n') + '\n\n' + section.strip('\n') + '\n', encoding='utf-8')

# the UE plan and the plan for the principle
UE = ROOT / RF / 'development/ue-unified-explanation'
REC = '../../../../../../theories/becoming/results/records/'
edit(UE / 'PLAN.md', "UE16, UE17, UE18, UE19, UE20, UE21 and UE22, and holds UE8.",
     "UE16, UE17, UE18, UE19, UE20, UE21, UE22 and UE23, and holds UE8.")
ITEM7 = ("The identity can fail off the support or with a hypothesis listed twice.\n")
edit(UE / 'FEP-INTEGRATION.md', ITEM7,
     ITEM7 + f"8. **UE23. Seeking by expected free energy, joined to the core's seeking** (landed as a section of "
     f"`ExpectedFreeEnergyReals`, with laws in [the record of expected free energy]({REC}{RIDE}.md), study section "
     f"{N}). Over a course of seeking, each experiment chosen from the course so far, the choice weights drop out of "
     "the posterior after the course wherever they weigh something; where the agent's model is the core's, with "
     "natural weights, the core's share given a course chosen with some weight is that posterior, and the core's order "
     "given the course is the posterior's. Choosing by a rule with natural weights reading expected free energy is one "
     "of the core's policies, whatever the agent's model, so every order every experiment ties is kept; over the reals "
     "the softmax keeps it too, where the course is possible under the pair. Through the lumping, at every step the "
     "expected free energy and the epistemic value are the classes', so for any likelihoods seeking by expected free "
     "energy reads the prior only through the weight it gives each likelihood profile, in its choices and in the "
     "predictive weight of every course. Whether, or how often, such an agent chooses an experiment that separates "
     "turns on its preferences, its posterior and the experiments' information.\n")

# regions: the notes of the two records
reg = json.loads(REGIONS.read_text(encoding='utf-8'))
for rid, extra in [(RIDE, '; UE23: seeking by it over courses, joined to the core\'s seeking, reads the prior only '
                          'through the weight it gives each likelihood profile'),
                   (RIDS, '; UE23: choice by expected free energy with natural weights is one such policy (ExpectedFreeEnergyReals)')]:
    note = reg['records'][rid]['note']
    assert 'UE23' not in note
    reg['records'][rid]['note'] = note + extra
REGIONS.write_text(json.dumps(reg, ensure_ascii=False, indent=1) + '\n', encoding='utf-8')
print('texts: 03 §6 (two home sections), 08 §8, the page, study section', N, ', UE plan and FEP-INTEGRATION, regions')
